# ElastiCache, Redshift & Other Database Services

## Table of Contents

1. [Amazon ElastiCache Overview](#amazon-elasticache-overview)
2. [ElastiCache for Redis](#elasticache-for-redis)
3. [ElastiCache for Memcached](#elasticache-for-memcached)
4. [Redis vs Memcached Comparison](#redis-vs-memcached-comparison)
5. [ElastiCache Caching Strategies](#elasticache-caching-strategies)
6. [ElastiCache Use Cases](#elasticache-use-cases)
7. [Amazon Redshift Overview](#amazon-redshift-overview)
8. [Redshift Architecture](#redshift-architecture)
9. [Redshift Node Types](#redshift-node-types)
10. [Redshift Spectrum](#redshift-spectrum)
11. [Redshift Serverless](#redshift-serverless)
12. [Redshift Networking and Security](#redshift-networking-and-security)
13. [Redshift Snapshots and DR](#redshift-snapshots-and-dr)
14. [Redshift Performance Features](#redshift-performance-features)
15. [Amazon Neptune](#amazon-neptune)
16. [Amazon DocumentDB](#amazon-documentdb)
17. [Amazon Keyspaces](#amazon-keyspaces)
18. [Amazon QLDB](#amazon-qldb)
19. [Amazon Timestream](#amazon-timestream)
20. [Amazon MemoryDB for Redis](#amazon-memorydb-for-redis)
21. [Database Selection Guide](#database-selection-guide)
22. [Common Exam Scenarios](#common-exam-scenarios)

---

## Amazon ElastiCache Overview

Amazon ElastiCache is a fully managed in-memory caching service that supports two open-source engines: **Redis** and **Memcached**.

### Why Use ElastiCache

- **Performance**: Sub-millisecond latency for cached data
- **Reduce database load**: Cache frequently accessed data, reducing reads to the primary database
- **Session management**: Store user sessions in-memory for fast access
- **Real-time analytics**: Leaderboards, counters, rate limiting
- **Managed service**: AWS handles patching, monitoring, failover, backups

### ElastiCache Common Architecture

```
Application → ElastiCache (check cache) → Cache Hit → Return data
                                       → Cache Miss → Read from RDS/DynamoDB → Store in cache → Return data
```

### Important Note for the Exam

- ElastiCache is deployed in your **VPC**
- ElastiCache is **NOT accessible from the internet** directly
- Applications must be in the same VPC (or peered VPC) to access ElastiCache
- No IAM authentication for Redis AUTH (Redis 6.0+ supports RBAC with user/password through ElastiCache)

---

## ElastiCache for Redis

Redis is an open-source, in-memory data structure store that supports complex data types and persistence.

### Redis Data Structures

- **Strings**: Simple key-value pairs, counters
- **Lists**: Ordered collections, queues, stacks
- **Sets**: Unordered unique collections, tags, memberships
- **Sorted Sets**: Ranked sets, leaderboards
- **Hashes**: Object-like structures, user profiles
- **Bitmaps**: Bit-level operations, feature flags
- **HyperLogLogs**: Probabilistic counting, unique visitors
- **Streams**: Log data structures, event sourcing
- **Geospatial**: Location-based queries

### Cluster Mode Disabled (Replication Group)

- **Single shard**: One primary node + up to 5 read replica nodes
- All data fits on a single node
- Maximum data: Limited by node type memory (up to ~635 GiB for r7g.16xlarge)
- **Multi-AZ**: Failover to a read replica if primary fails
- **Use case**: Smaller datasets, simpler architecture
- Read replicas provide read scaling
- Endpoint: Single **primary endpoint** for writes, **reader endpoint** for reads

### Cluster Mode Enabled

- **Multiple shards**: Data is partitioned across multiple shards
- Each shard has a primary node + up to 5 replicas
- Maximum: **500 nodes** per cluster (e.g., 250 shards with 1 replica each)
- Data is automatically distributed across shards using **hash slots** (16,384 hash slots)
- Horizontal scaling: Add or remove shards to scale capacity
- **Multi-AZ**: Each shard can have replicas in different AZs
- **Use case**: Large datasets that exceed single-node memory, high throughput
- Online resharding: Add/remove shards without downtime
- Endpoint: **Configuration endpoint** for cluster-aware clients

### Redis Multi-AZ with Auto-Failover

- Available for both cluster mode disabled and enabled
- Primary node failure triggers automatic failover to a replica
- Failover process:
  1. ElastiCache detects primary node failure
  2. Promotes the replica with the least replication lag
  3. DNS record is updated to point to the new primary
  4. Other replicas sync with the new primary
- Failover typically completes in **less than 60 seconds**
- Application should handle brief connection interruptions

### Redis Backup and Restore

- **Automated backups**: Daily snapshots during backup window
- **Manual backups**: Create snapshots on demand
- Backup retention: 1-35 days for automated, manual retained until deleted
- Backups stored in S3 (managed by AWS)
- Snapshots can be used to **seed new clusters**
- Can copy snapshots to other regions for DR
- Backup creates a **Redis RDB file**
- Backup from replica (if available) to minimize performance impact
- **Note**: Memcached does NOT support backups

### Redis Encryption

**Encryption at rest:**
- Uses AWS KMS for key management
- Encrypts disk during sync, backup, and swap operations
- Must be enabled at cluster creation (cannot add later)

**Encryption in transit:**
- TLS connections between clients and Redis
- Must be enabled at cluster creation
- May cause some performance overhead (encryption/decryption)
- Required for Redis AUTH and RBAC

### Redis AUTH and RBAC

**Redis AUTH (legacy):**
- Simple password authentication
- Single password for the entire cluster
- Requires encryption in transit to be enabled

**Redis RBAC (Role-Based Access Control) — Redis 6.0+:**
- Create users with specific permissions
- Access control lists (ACLs) per user
- Control access to specific commands and keys
- More granular than Redis AUTH
- Recommended over Redis AUTH

### Redis Global Datastore

- Cross-region replication for Redis
- **Primary cluster** in one region + up to **2 secondary clusters** in other regions
- Asynchronous replication with typical lag < 1 second
- Secondary clusters: Read-only
- Failover: Promote a secondary cluster to primary (manual process)
- Use cases: Disaster recovery, low-latency global reads
- Requires Redis 5.0.6+ and cluster mode enabled
- Only one primary cluster at a time (not multi-active like DynamoDB Global Tables)

### Redis Reserved Nodes

- 1-year or 3-year terms
- Up to 55% cost savings compared to on-demand
- Apply to specific node types and regions
- Payment options: All Upfront, Partial Upfront, No Upfront

---

## ElastiCache for Memcached

Memcached is a high-performance, distributed memory object caching system designed for simplicity.

### Key Characteristics

- **Multi-threaded**: Takes advantage of multiple CPU cores
- **Simple key-value store**: String data type only
- **No persistence**: Data is lost if node fails
- **No replication**: No built-in replica nodes
- **No backup**: Cannot create snapshots
- **No Multi-AZ**: No automatic failover
- **No encryption**: No native encryption at rest or in transit
- **Auto-discovery**: Clients can automatically discover all nodes in the cluster

### Memcached Architecture

- **Distributed cache**: Data is partitioned across multiple nodes
- Each node is independent (no replication between nodes)
- Clients use consistent hashing to determine which node holds each key
- Maximum: **300 nodes** per cluster
- Supports **Auto Discovery**: Client SDKs automatically detect node additions/removals

### Memcached Scaling

- **Horizontal scaling**: Add or remove nodes
- When a node is added/removed, some cached data is lost (cache needs to warm up)
- Data is not redistributed automatically
- No read replicas (each node handles both reads and writes)

### When to Use Memcached

- Simple caching with no persistence requirements
- Multi-threaded performance is critical
- Horizontal scaling of cache (distributed across nodes)
- No need for backups, replication, or failover
- Running large cache nodes with multiple cores

---

## Redis vs Memcached Comparison

| Feature | Redis | Memcached |
|---------|-------|-----------|
| **Data Structures** | Strings, Lists, Sets, Sorted Sets, Hashes, Streams, etc. | Strings only |
| **Persistence** | Yes (RDB snapshots, AOF) | No |
| **Replication** | Yes (up to 5 replicas per shard) | No |
| **Multi-AZ** | Yes (with auto-failover) | No |
| **Backup/Restore** | Yes (snapshots) | No |
| **Encryption at Rest** | Yes (KMS) | No |
| **Encryption in Transit** | Yes (TLS) | Yes (TLS, added later) |
| **Authentication** | Redis AUTH, RBAC | SASL authentication |
| **Cluster Mode** | Yes (data partitioning) | Yes (data partitioning via client) |
| **Max Nodes** | 500 (cluster mode) | 300 |
| **Thread Model** | Single-threaded (per shard) | Multi-threaded |
| **Pub/Sub** | Yes | No |
| **Lua Scripting** | Yes | No |
| **Geospatial** | Yes | No |
| **Global Datastore** | Yes (cross-region) | No |
| **Compliance** | HIPAA eligible | HIPAA eligible |
| **Use Cases** | Complex caching, sessions, leaderboards, pub/sub | Simple caching, large-scale distributed cache |

### Exam Decision Matrix

- Need **persistence, backup, or replication** → Redis
- Need **Multi-AZ and failover** → Redis
- Need **complex data types** (sorted sets, lists, etc.) → Redis
- Need **pub/sub messaging** → Redis
- Need **multi-threaded performance** → Memcached
- Need the **simplest possible cache** → Memcached
- Default choice for most exam scenarios → **Redis**

---

## ElastiCache Caching Strategies

### Lazy Loading (Cache-Aside)

**How it works:**
1. Application requests data from the cache
2. **Cache hit**: Return cached data
3. **Cache miss**: Application reads from the database, writes to cache, returns data

**Pros:**
- Only requested data is cached (no wasted space)
- Cache failures don't break the application (falls back to database)
- Data in cache is always "requested" data

**Cons:**
- **Cache miss penalty**: Three round trips (cache miss → DB read → cache write)
- **Stale data**: Data can become outdated if the database changes but cache isn't updated
- **Cold start**: New cache is empty, causing initial cache miss storm

### Write-Through

**How it works:**
1. Application writes data to the cache AND the database simultaneously
2. Every write updates both cache and database
3. Reads always get the latest data from cache

**Pros:**
- Data in cache is **never stale** (always up to date)
- Read performance is excellent (data is already in cache)

**Cons:**
- **Write penalty**: Every write has two steps (cache + DB)
- **Wasted resources**: Data is cached even if never read
- **Node failure**: If a cache node fails and is replaced, the new node is empty until writes occur
- Often combined with Lazy Loading to handle cache misses

### Write-Behind (Write-Back)

**How it works:**
1. Application writes to the cache only
2. Cache asynchronously writes to the database in batches
3. Reduces write load on the database

**Pros:**
- Fast write performance (only cache write is synchronous)
- Reduces database write load
- Batching improves database efficiency

**Cons:**
- **Data loss risk**: If cache fails before writing to DB, data is lost
- More complex implementation
- Not natively supported by ElastiCache (application must implement)

### Adding TTL (Time to Live)

- Set an expiration time on cached data
- Expired data is automatically removed from cache
- Balances freshness vs performance
- **Lazy Loading + TTL**: Best combination for most use cases
  - Cache data on read (lazy loading)
  - Set TTL to ensure data doesn't become too stale
  - After TTL expires, next read causes cache miss and fresh data is loaded
- **Write-Through + TTL**: Prevents cache from filling with infrequently accessed data

### Session Store Pattern

- Store user session data in ElastiCache (Redis recommended)
- All application servers read/write sessions from the same cache
- Enables **stateless application servers** (sessions are externalized)
- Fast session retrieval (sub-millisecond)
- TTL for automatic session expiration
- Multi-AZ Redis for session durability

---

## ElastiCache Use Cases

### Database Query Caching

- Cache results of expensive database queries
- Reduce load on RDS/Aurora
- Dramatically improve read performance
- Use Lazy Loading + TTL strategy

### Session Management

- External session store for web applications
- Enables horizontal scaling of application tier
- Redis preferred (persistence, replication)
- TTL for automatic session cleanup

### Real-Time Leaderboards

- Redis Sorted Sets for ranking
- O(log N) time for add/update/rank operations
- ZRANGEBYSCORE, ZRANK for leaderboard queries

### Rate Limiting

- Redis INCR with TTL for API rate limiting
- Count requests per key (user ID, IP address) per time window
- Atomic increment operations

### Pub/Sub Messaging

- Redis Pub/Sub for real-time messaging
- Chat applications, notifications
- Not durable (messages lost if no subscriber)

### Geospatial Data

- Redis geospatial commands (GEOADD, GEODIST, GEORADIUS)
- Find nearby locations, restaurants, stores
- "Find all stores within 10 miles"

---

## Amazon Redshift Overview

Amazon Redshift is a fully managed, petabyte-scale data warehouse service optimized for Online Analytical Processing (OLAP).

### Key Characteristics

- **Columnar storage**: Data stored by columns, not rows (optimized for analytics)
- **Massive Parallel Processing (MPP)**: Distributes queries across multiple nodes
- **SQL-based**: Standard SQL with extensions for analytics
- **Petabyte-scale**: Can handle exabytes with Redshift Spectrum
- **10x better performance** than traditional data warehouses (using ML-based query optimization)
- **Cost-effective**: Starts at $0.25/hour per node
- **Not for OLTP**: Designed for analytics, not transactional workloads

### Redshift vs RDS/Aurora

| Feature | Redshift | RDS/Aurora |
|---------|----------|-----------|
| Workload | OLAP (analytics) | OLTP (transactions) |
| Storage | Columnar | Row-based |
| Query Type | Complex aggregations | Simple lookups, joins |
| Concurrency | Lower (hundreds) | Higher (thousands) |
| Data Volume | Petabytes | Terabytes |
| Index | Zone maps, sort keys | B-tree, hash |
| Use Case | BI, reporting, data warehouse | Application backend |

---

## Redshift Architecture

### Cluster Components

**Leader Node:**
- Receives queries from clients
- Parses queries and develops execution plans
- Distributes execution plans to compute nodes
- Aggregates results from compute nodes
- Returns results to the client
- Free (not charged separately)

**Compute Nodes:**
- Execute the query plan
- Store data in columnar format
- Process queries in parallel
- Each node is divided into **slices**
- Each slice is allocated a portion of the node's memory and disk
- Number of slices depends on node type

### Data Distribution Styles

| Style | Description | When to Use |
|-------|-------------|-------------|
| **AUTO** | Redshift determines best strategy | Default, recommended for most cases |
| **EVEN** | Rows distributed evenly (round-robin) | No joins or aggregations on distribution key |
| **KEY** | Rows with same key value go to same node | Frequently joined tables (co-locate join keys) |
| **ALL** | Full copy on every node | Small dimension tables (< ~2M rows) |

### Sort Keys

- Define the order data is stored on disk within each node
- **Compound sort key**: Multi-column sort (prefix columns matter)
- **Interleaved sort key**: Equal weight to all sort key columns
- Sort keys improve performance for: range queries, GROUP BY, ORDER BY, JOINs
- Best practice: Use the most commonly filtered/joined column as the sort key

---

## Redshift Node Types

### RA3 Nodes (Recommended)

- Managed storage (data stored in S3, cached locally on SSD)
- **RA3.xlplus**: 4 vCPU, 32 GiB RAM, 32 TB managed storage
- **RA3.4xlarge**: 12 vCPU, 96 GiB RAM, 128 TB managed storage
- **RA3.16xlarge**: 48 vCPU, 384 GiB RAM, 128 TB managed storage
- Storage scales independently from compute
- Pay for managed storage separately
- Best for: Most workloads, flexible scaling

### DC2 Nodes (Dense Compute)

- Local SSD storage
- **DC2.large**: 2 vCPU, 15 GiB RAM, 160 GB SSD
- **DC2.8xlarge**: 32 vCPU, 244 GiB RAM, 2.56 TB SSD
- Best for: Performance-sensitive workloads under 500 GB
- Limited by local storage (cannot scale storage independently)

### DS2 Nodes (Dense Storage) — Previous Generation

- Local HDD storage
- **DS2.xlarge**: 4 vCPU, 31 GiB RAM, 2 TB HDD
- **DS2.8xlarge**: 36 vCPU, 244 GiB RAM, 16 TB HDD
- **Not recommended** for new clusters (use RA3 instead)
- Suitable for large data volumes where cost is primary concern

### Node Type Selection

- **< 500 GB data, high performance needed**: DC2
- **500 GB - many TB, flexible scaling**: RA3
- **Exam default answer**: RA3 (most common recommendation)

---

## Redshift Spectrum

Redshift Spectrum extends Redshift queries to data stored in Amazon S3 without loading it.

### How It Works

1. Define **external tables** pointing to data in S3
2. Write standard SQL queries that reference external tables
3. Redshift Spectrum pushes filtering and aggregation to dedicated Spectrum compute layer
4. Results are returned to the Redshift cluster for final processing

### Key Features

- Query **exabytes** of data in S3
- Supports open data formats: Parquet, ORC, CSV, JSON, Avro, etc.
- Uses the **AWS Glue Data Catalog** for table definitions (or Redshift's own external catalog)
- Pushes predicates and aggregations down to the Spectrum layer
- Pay per query: $5 per TB of data scanned
- No data loading required
- Supports partitioning for cost optimization (scan less data)

### When to Use Spectrum

- Query large datasets in S3 without loading into Redshift
- Combine S3 data with local Redshift data in the same query
- Cost-effective analysis of infrequently accessed data
- Data lake queries with SQL

### Spectrum vs Athena

| Feature | Redshift Spectrum | Athena |
|---------|------------------|--------|
| Requires Cluster | Yes (Redshift cluster) | No (serverless) |
| Cost | $5/TB scanned + cluster cost | $5/TB scanned |
| Local Data | Can join with local Redshift data | S3 only |
| Concurrency | Higher (dedicated resources) | Limited |
| Best For | Hybrid queries (local + S3) | Ad-hoc S3 queries |

---

## Redshift Serverless

Amazon Redshift Serverless provides data warehouse capacity without managing clusters.

### Key Features

- No cluster provisioning or management
- Automatically scales compute capacity based on workload
- Pay only for compute used (measured in **Redshift Processing Units (RPU)**)
- Data stored in managed storage (same as RA3)
- Automatic pause when idle (no charge for idle time)
- Compatible with existing Redshift SQL, tools, and drivers

### Pricing

- **Compute**: Per RPU-hour (billed per second)
- **Storage**: Per GB per month (managed storage)
- Base capacity: Configurable (default 128 RPU)
- Auto-scales between 8 RPU and configured maximum

### Use Cases

- Intermittent analytics workloads
- Dev/test environments
- Variable query patterns
- Teams that don't want to manage clusters

---

## Redshift Networking and Security

### Enhanced VPC Routing

- When enabled, all COPY and UNLOAD traffic between Redshift and data repositories flows through the **VPC**
- Without enhanced VPC routing, traffic may go through the internet
- Enables use of **VPC security features**: security groups, NACLs, VPC endpoints, NAT gateways
- Required for compliance scenarios where data must stay within the VPC
- **Exam tip**: If a question mentions "data must not traverse the internet" → Enable enhanced VPC routing

### Redshift Security

- **Encryption at rest**: AES-256, using KMS or CloudHSM
- **Encryption in transit**: SSL/TLS for connections
- **VPC isolation**: Deploy in a VPC with security groups
- **IAM integration**: IAM roles for COPY/UNLOAD from S3
- **Audit logging**: Log connections, queries, user activity to S3
- **Column-level access control**: GRANT/REVOKE on specific columns
- **Row-level security**: Restrict which rows users can see

---

## Redshift Snapshots and DR

### Automated Snapshots

- Taken automatically every **8 hours** or every **5 GB** of data changes (whichever comes first)
- Retention: 1-35 days (default 1 day)
- Stored in S3 (managed by AWS)
- Restoring creates a new cluster

### Manual Snapshots

- Created by the user at any time
- Retained **indefinitely** until manually deleted
- Can be shared with other AWS accounts
- Used for long-term archival

### Cross-Region Snapshots

- Automated or manual snapshots can be **copied to another region**
- Configure **cross-region snapshot copy** for automated DR
- Specify retention period for cross-region copies
- If using KMS encryption, must configure a **snapshot copy grant** in the target region

### Disaster Recovery Strategy

- **Cross-region snapshot copy**: RPO depends on snapshot frequency
- **Restore in another region**: Create a new cluster from the snapshot
- Snapshots are incremental (only changed data is stored)

---

## Redshift Performance Features

### Concurrency Scaling

- Automatically adds additional cluster capacity to handle concurrent queries
- Activates when queries start queuing
- Scales to a virtually unlimited number of concurrent users
- **Free credits**: 1 hour of concurrency scaling per day per cluster (accumulated over 24 hours)
- Beyond free tier: Billed per second of concurrency scaling usage
- Seamless to users (no configuration changes needed)

### Workload Management (WLM)

- Define **queues** with different memory and concurrency settings
- Assign queries to queues based on user groups or query groups
- **Automatic WLM**: Redshift manages concurrency and memory allocation (recommended)
- **Manual WLM**: You define concurrency levels and memory per queue
- Short Query Acceleration (SQA): Automatically identifies and prioritizes short queries
- Priority: Assign priority levels to queues (highest, high, normal, low, lowest)

### AQUA (Advanced Query Accelerator)

- Hardware-accelerated cache for Redshift
- Available for RA3 node types
- Pushes data filtering and aggregation to the storage layer
- Reduces data movement between storage and compute
- Transparent to users (no query changes needed)

### Materialized Views

- Precomputed query results stored as a table
- Automatically refreshed by Redshift
- Significantly speeds up repeated complex queries
- Redshift can automatically rewrite queries to use materialized views

### Federated Query

- Query data across operational databases (RDS, Aurora) directly from Redshift
- No ETL required for simple cross-database queries
- Uses external schemas and tables
- Pushes predicates down to the source database

---

## Amazon Neptune

Amazon Neptune is a fully managed **graph database** service optimized for storing and querying highly connected data.

### Graph Database Concepts

- **Nodes (vertices)**: Entities (people, places, things)
- **Edges (relationships)**: Connections between nodes
- **Properties**: Attributes of nodes and edges
- Designed for datasets where relationships are as important as the data itself

### Supported Graph Models and Query Languages

| Model | Query Language | Description |
|-------|---------------|-------------|
| **Property Graph** | **Apache TinkerPop Gremlin** | Traversal-based queries |
| **RDF (Resource Description Framework)** | **SPARQL** | Semantic web standard, triples (subject-predicate-object) |
| **openCypher** | **openCypher** | Declarative graph query language |

### Neptune Architecture

- Fully managed: Automated backups, patching, failover
- Up to **15 read replicas**
- Multi-AZ with failover support
- Storage: Auto-scales up to **128 TiB**
- Storage replicated **6 ways across 3 AZs** (similar to Aurora)
- Encryption at rest (KMS) and in transit (TLS)
- Point-in-time recovery

### Neptune Use Cases

- **Social networking**: Friend recommendations, relationship analysis
- **Knowledge graphs**: Wikipedia-style connected knowledge bases
- **Fraud detection**: Detecting patterns in transaction networks
- **Recommendation engines**: "People who bought X also bought Y"
- **Network management**: Mapping IT infrastructure, network topology
- **Life sciences**: Drug interaction analysis, protein interaction networks
- **Identity graphs**: Linking user identities across systems

### Neptune Machine Learning

- Run graph neural network (GNN) predictions using SQL/Gremlin
- Integrates with SageMaker for model training
- Use cases: Fraud detection, link prediction, node classification

### Exam Tip

- If a question mentions **"graph database"**, **"social network"**, **"highly connected data"**, **"relationship queries"**, or **"knowledge graph"** → **Neptune**

---

## Amazon DocumentDB

Amazon DocumentDB is a fully managed document database service that is **MongoDB-compatible**.

### Key Features

- Compatible with **MongoDB 3.6, 4.0, 5.0** APIs
- Existing MongoDB drivers and tools work with DocumentDB
- Fully managed: Automated backups, patching, monitoring
- Storage auto-scales up to **128 TiB**
- Replication: **6 copies across 3 AZs**
- Up to **15 read replicas** with auto-failover
- Continuous backup to S3 with point-in-time recovery
- Encryption at rest (KMS) and in transit (TLS)

### Architecture

- Similar to Aurora: Shared distributed storage, separate compute and storage
- Cluster: One primary instance + up to 15 replica instances
- Endpoints: Cluster endpoint (writes), reader endpoint (reads), instance endpoints

### DocumentDB vs MongoDB on EC2

| Feature | DocumentDB | MongoDB on EC2 |
|---------|-----------|----------------|
| Management | Fully managed | Self-managed |
| Scalability | Auto-scaling storage | Manual scaling |
| Availability | Multi-AZ, auto-failover | Manual replication |
| Backup | Automated, PITR | Manual |
| Cost | Higher per-unit | Lower (but more ops) |

### Use Cases

- Content management systems
- Catalogs and profiles
- Mobile and web applications using MongoDB
- Migration from on-premises MongoDB

### Exam Tip

- "MongoDB" or "document database" in the question → **DocumentDB** (or DynamoDB if key-value patterns are suitable)
- "Migrate MongoDB to AWS with minimal code changes" → **DocumentDB**

---

## Amazon Keyspaces

Amazon Keyspaces is a fully managed, serverless **Apache Cassandra-compatible** database service.

### Key Features

- Compatible with **Apache Cassandra Query Language (CQL)**
- Serverless: Automatically scales capacity based on traffic
- No servers to manage, patch, or maintain
- Tables replicated **3 times across multiple AZs**
- Capacity modes: **On-demand** and **Provisioned** (with auto scaling)
- Encryption at rest (KMS) and in transit (TLS)
- Point-in-time recovery (PITR) up to 35 days
- Supports Cassandra drivers and tools

### Pricing

- On-demand: Pay per read/write request
- Provisioned: Pay per provisioned read/write capacity
- Storage: Per GB per month

### Use Cases

- Migrate Apache Cassandra workloads to AWS
- IoT time-series data
- High-throughput applications that use Cassandra
- Applications requiring Cassandra-compatible API

### Exam Tip

- "Cassandra" or "CQL" in the question → **Amazon Keyspaces**
- "Migrate Cassandra to AWS" → **Amazon Keyspaces**

---

## Amazon QLDB

Amazon Quantum Ledger Database (QLDB) is a fully managed **ledger database** that provides a transparent, immutable, and cryptographically verifiable transaction log.

### Key Features

- **Immutable**: Once data is written, it cannot be altered or deleted
- **Cryptographically verifiable**: SHA-256 hash chain proves data integrity
- **Transparent**: Complete, verifiable history of all changes
- Fully managed, serverless
- Supports **PartiQL** query language (SQL-compatible)
- ACID transactions
- 2-3x better performance than common blockchain frameworks
- **Centralized**: Owned by a single trusted authority (NOT decentralized like blockchain)

### QLDB vs Blockchain

| Feature | QLDB | Blockchain |
|---------|------|------------|
| Trust Model | Central authority | Decentralized |
| Performance | 2-3x faster | Slower (consensus) |
| Immutability | Yes (SHA-256 chain) | Yes (distributed) |
| Use Case | Financial, compliance | Multi-party trust |

### QLDB Journal

- **Journal**: Append-only, immutable log of all changes
- Every transaction is recorded in the journal
- **Digest**: Cryptographic hash of the journal (like a Merkle tree)
- Can verify that a specific document existed at a specific time
- Journal can be **exported to S3** for analytics (via Kinesis Data Streams)

### Use Cases

- **Financial transactions**: Complete audit trail of all financial operations
- **Supply chain**: Track items through the supply chain with verified history
- **Insurance claims**: Immutable record of claim lifecycle
- **HR/Payroll**: Verifiable employee record changes
- **Government registries**: Land titles, vehicle registrations
- **Healthcare**: Immutable patient records

### QLDB Streams

- Real-time streaming of journal data to **Kinesis Data Streams**
- Enables downstream processing, analytics, and replication
- Can be used to replicate data to other databases or services

### Exam Tip

- "Immutable", "cryptographically verifiable", "ledger", "audit trail", "financial transactions with complete history" → **QLDB**
- "Decentralized, multi-party trust" → **Amazon Managed Blockchain** (not QLDB)

---

## Amazon Timestream

Amazon Timestream is a fully managed, serverless **time-series database** for IoT and operational applications.

### Key Features

- **Purpose-built for time-series data**: Optimized storage and query engine
- **Serverless**: Automatically scales to handle any volume
- **Tiered storage**: Recent data in memory, historical data in magnetic storage (automatic)
- **Built-in analytics**: Interpolation, smoothing, time-series functions
- **1,000x faster** and **1/10th the cost** of relational databases for time-series workloads
- Supports SQL with time-series extensions
- Encryption at rest and in transit
- Data retention policies for automatic data lifecycle management

### Architecture

- **Memory store**: Recent data, fast queries (configurable retention: hours to days)
- **Magnetic store**: Historical data, cost-effective (configurable retention: days to years)
- Data automatically moves from memory to magnetic based on retention policy
- Both stores are queryable seamlessly

### Integration

- **AWS IoT Core**: Direct ingestion from IoT devices
- **Kinesis Data Streams**: Stream data into Timestream
- **Amazon MSK (Kafka)**: Ingest from Kafka topics
- **Telegraf**: Open-source collector plugin
- **Prometheus**: Remote write integration
- **Grafana**: Native dashboard support
- **Amazon QuickSight**: BI and visualization
- **SageMaker**: ML on time-series data

### Use Cases

- **IoT**: Sensor data, telemetry, device metrics
- **DevOps**: Application monitoring, infrastructure metrics
- **Industrial**: Equipment monitoring, predictive maintenance
- **Analytics**: Clickstream data, user behavior over time
- **Financial**: Stock prices, trading data

### Exam Tip

- "Time-series data", "IoT sensor data", "DevOps monitoring metrics", "data with timestamps" → **Timestream**

---

## Amazon MemoryDB for Redis

Amazon MemoryDB for Redis is a Redis-compatible, durable, in-memory database for ultra-fast performance with data durability.

### Key Differences from ElastiCache for Redis

| Feature | MemoryDB for Redis | ElastiCache for Redis |
|---------|-------------------|----------------------|
| **Primary Purpose** | Durable database | Cache |
| **Durability** | Multi-AZ transactional log | Optional (snapshots) |
| **Data Loss** | No data loss on node failure | Possible data loss |
| **Write Performance** | Strong consistency (durable) | Faster (not durable) |
| **Read Latency** | Microseconds | Microseconds |
| **Use Case** | Primary database | Caching layer |

### How Durability Works

- Uses a **Multi-AZ transactional log** to persist data durably
- Writes are committed to the transactional log across multiple AZs before acknowledgment
- On node failure, data is recovered from the transactional log
- **Zero data loss** during node failures, cluster scaling, and patching

### Key Features

- Redis-compatible API (existing Redis applications work without changes)
- Up to **500 nodes** per cluster
- Multi-AZ with auto-failover
- Microsecond read latency, single-digit millisecond write latency
- Encryption at rest and in transit
- Supports Redis data structures, Lua scripts, pub/sub, Streams

### Use Cases

- Applications that need Redis speed with database durability
- Session stores, shopping carts, user profiles (where data loss is unacceptable)
- Gaming leaderboards with persistent data
- Real-time applications that need both speed and durability
- Replace Redis + RDS combination with single MemoryDB

### Exam Tip

- "Redis-compatible database with durability" → **MemoryDB for Redis**
- "In-memory database with no data loss" → **MemoryDB for Redis**
- "Cache with best-effort durability" → **ElastiCache for Redis**

---

## Database Selection Guide

### Decision Framework

| Requirement | Recommended Service |
|-------------|-------------------|
| Relational data, complex queries, OLTP | **RDS** or **Aurora** |
| MySQL/PostgreSQL with high performance | **Aurora** |
| NoSQL, key-value, serverless | **DynamoDB** |
| Caching layer, sub-millisecond reads | **ElastiCache** |
| Durable in-memory, Redis-compatible | **MemoryDB for Redis** |
| Data warehousing, OLAP, analytics | **Redshift** |
| Graph data, social networks | **Neptune** |
| Document database, MongoDB-compatible | **DocumentDB** |
| Cassandra-compatible, CQL | **Keyspaces** |
| Immutable ledger, audit trail | **QLDB** |
| Time-series, IoT, DevOps metrics | **Timestream** |
| Decentralized blockchain | **Managed Blockchain** |
| Search and analytics | **OpenSearch Service** |

### Detailed Selection Criteria

**Choose RDS when:**
- Standard relational database needs
- Familiar with specific engine (MySQL, PostgreSQL, Oracle, SQL Server)
- Need multi-AZ for HA with minimal changes
- OLTP workload under 64 TiB

**Choose Aurora when:**
- Need higher performance than standard RDS (5x MySQL, 3x PostgreSQL)
- Need more than 5 read replicas (up to 15)
- Need faster failover (< 30 seconds)
- Need more storage (up to 128 TiB)
- Need cross-region with Global Database
- Cost is acceptable (20% more than RDS)

**Choose DynamoDB when:**
- Key-value or document data model
- Need serverless, fully managed NoSQL
- Need single-digit millisecond latency
- Need global tables (multi-region, multi-active)
- Known, predictable access patterns

**Choose ElastiCache when:**
- Need a caching layer for another database
- Need sub-millisecond read latency
- Session store, leaderboards, rate limiting
- Can tolerate data loss (cache, not primary data)

**Choose Redshift when:**
- Data warehousing and analytics (OLAP)
- Need to run complex analytical queries
- Need columnar storage for aggregations
- Petabyte-scale data analysis
- BI tool integration (QuickSight, Tableau)

---

## Common Exam Scenarios

### Scenario 1: High-Performance Caching for RDS

**Question**: An application backed by RDS is experiencing high read latency. The same queries are executed repeatedly.

**Solution**: Add **ElastiCache for Redis** as a caching layer. Implement lazy loading with TTL. Application checks cache first; on cache miss, reads from RDS and caches the result.

### Scenario 2: Session Management for Scaled Application

**Question**: A web application runs on Auto Scaling EC2 instances and needs consistent session management.

**Solution**: Use **ElastiCache for Redis** as an external session store. All application instances read/write sessions from Redis. Redis Multi-AZ ensures session durability.

### Scenario 3: Data Warehouse for Analytics

**Question**: A company needs to analyze petabytes of sales data with complex SQL queries and integrate with their BI tools.

**Solution**: Use **Amazon Redshift**. Load data from S3 using COPY command. Use Redshift Spectrum for querying data still in S3. Connect BI tools (QuickSight, Tableau) directly to Redshift.

### Scenario 4: Query S3 Data Without Loading

**Question**: Analysts need to run SQL queries against CSV and Parquet files in S3 without loading them into a database.

**Solution**: Use **Redshift Spectrum** (if already have a Redshift cluster) or **Amazon Athena** (if serverless and no cluster). Spectrum is better for joining S3 data with existing Redshift data.

### Scenario 5: Social Network Relationship Queries

**Question**: A social media application needs to efficiently find "friends of friends" and recommend connections.

**Solution**: Use **Amazon Neptune**. Graph databases excel at traversing relationships. Use Gremlin queries to find paths between users and recommend connections.

### Scenario 6: MongoDB Migration

**Question**: A company wants to migrate their on-premises MongoDB database to AWS with minimal application changes.

**Solution**: Use **Amazon DocumentDB**. It's MongoDB-compatible, so existing drivers and applications work with minimal changes. Supports MongoDB 3.6, 4.0, and 5.0 APIs.

### Scenario 7: Financial Transaction Audit Trail

**Question**: A financial institution needs an immutable, verifiable record of all transactions for regulatory compliance.

**Solution**: Use **Amazon QLDB**. It provides an immutable, cryptographically verifiable ledger. Every transaction is recorded and cannot be altered. The SHA-256 hash chain proves data integrity.

### Scenario 8: IoT Sensor Data Storage

**Question**: An IoT application generates millions of sensor readings per second and needs to store and analyze time-series data.

**Solution**: Use **Amazon Timestream**. Purpose-built for time-series data with automatic tiered storage. Ingests millions of records per second. Built-in time-series functions for analysis.

### Scenario 9: Cassandra Workload Migration

**Question**: A company running Apache Cassandra on-premises wants to migrate to AWS without changing their application code.

**Solution**: Use **Amazon Keyspaces**. It's Cassandra-compatible and supports CQL. Existing Cassandra applications and tools work with minimal changes.

### Scenario 10: Redis with Durability Guarantee

**Question**: An application uses Redis for user profiles but cannot tolerate any data loss during failures.

**Solution**: Use **Amazon MemoryDB for Redis**. It provides microsecond reads with durable, Multi-AZ transactional logging. Unlike ElastiCache, it guarantees zero data loss on node failure.

### Scenario 11: Redshift Data Must Not Traverse Internet

**Question**: A Redshift cluster needs to COPY data from S3, but security requires data to stay within the VPC.

**Solution**: Enable **Redshift Enhanced VPC Routing**. This forces all COPY/UNLOAD traffic through the VPC, where it can be controlled with VPC endpoints, security groups, and NACLs.

### Scenario 12: Choosing Between DAX and ElastiCache

**Question**: A DynamoDB-backed application needs caching. Should you use DAX or ElastiCache?

**Solution**: Use **DAX** for DynamoDB-specific caching (API-compatible, minimal code changes, microsecond latency). Use **ElastiCache** when you need caching for multiple data sources, complex caching logic, or features like pub/sub that DAX doesn't provide.

---

## Key Numbers to Remember

| Service/Feature | Value |
|----------------|-------|
| ElastiCache Redis max replicas per shard | 5 |
| ElastiCache Redis cluster max nodes | 500 |
| ElastiCache Memcached max nodes | 300 |
| Redis hash slots | 16,384 |
| Redshift Spectrum pricing | $5/TB scanned |
| Redshift automated snapshot retention | 1-35 days |
| Neptune max replicas | 15 |
| Neptune max storage | 128 TiB |
| DocumentDB max replicas | 15 |
| DocumentDB max storage | 128 TiB |
| QLDB hash algorithm | SHA-256 |
| MemoryDB max nodes | 500 |
| Keyspaces replication | 3 AZs |
| Redis Global Datastore secondary clusters | Up to 2 |

---

## Summary

- **ElastiCache Redis** = feature-rich cache, persistence, replication, Multi-AZ, pub/sub, complex data types
- **ElastiCache Memcached** = simple cache, multi-threaded, no persistence, no replication
- **Redshift** = columnar data warehouse, OLAP, petabyte-scale, MPP, SQL
- **Redshift Spectrum** = query S3 data from Redshift, $5/TB
- **Neptune** = graph database, Gremlin/SPARQL, social networks, knowledge graphs
- **DocumentDB** = MongoDB-compatible, managed document database
- **Keyspaces** = Cassandra-compatible, serverless, CQL
- **QLDB** = immutable ledger, cryptographic verification, central authority
- **Timestream** = time-series, IoT, DevOps, tiered storage
- **MemoryDB** = Redis-compatible + durability, no data loss, primary database
