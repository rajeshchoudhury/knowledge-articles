# Database Cheat Sheet

## RDS Multi-AZ vs Read Replicas

| Feature                     | Multi-AZ Deployment            | Read Replicas                  |
|-----------------------------|--------------------------------|--------------------------------|
| **Purpose**                 | High availability (HA)         | Read scalability / performance |
| **Synchronous/Async**       | Synchronous replication        | Asynchronous replication       |
| **Failover**                | Automatic (DNS endpoint swap)  | Manual promotion               |
| **Read traffic**            | Standby NOT used for reads     | CAN serve read traffic         |
| **Region**                  | Same region only               | Same or cross-region           |
| **Number**                  | 1 standby                      | Up to 15 (Aurora), 5 (RDS)    |
| **Endpoint**                | Single DNS endpoint            | Each replica has own endpoint  |
| **Backup from**             | Standby (no I/O impact)        | N/A (not for backup)           |
| **Engine support**          | All RDS engines                | All RDS engines                |
| **Cross-region**            | No (except Aurora Global DB)   | Yes                            |
| **Cost**                    | No extra (included)            | Extra instance + data transfer |
| **Can be Multi-AZ?**        | N/A                            | Yes, replica can be Multi-AZ   |

**Multi-AZ DB Cluster (new):** 2 readable standbys in different AZs, up to 35x faster failover. Available for MySQL and PostgreSQL.

**Exam tip:** "High availability / disaster recovery" → Multi-AZ. "Improve read performance" → Read Replicas. You can have BOTH enabled.

---

## Aurora vs Standard RDS

| Feature                     | Aurora                         | Standard RDS                   |
|-----------------------------|--------------------------------|--------------------------------|
| **Engines**                 | MySQL and PostgreSQL compatible | MySQL, PostgreSQL, MariaDB, Oracle, SQL Server |
| **Storage**                 | Auto-scales up to 128 TB       | Manual provisioning (up to 64 TB) |
| **Replication**             | 6 copies across 3 AZs          | 1 standby (Multi-AZ)          |
| **Read replicas**           | Up to 15 (auto-failover)       | Up to 5 (manual promotion)     |
| **Failover time**           | ~30 seconds                    | 60–120 seconds                 |
| **Performance**             | 5x MySQL, 3x PostgreSQL        | Standard engine performance    |
| **Backtrack**               | Supported (MySQL)              | Not supported                  |
| **Global Database**         | <1 sec cross-region replication | Cross-region read replicas     |
| **Serverless**              | Aurora Serverless v2            | Not available                  |
| **Cost**                    | ~20% more than RDS             | Standard pricing               |
| **Storage billing**         | Pay for what you use            | Pay for provisioned            |
| **Multi-Master**            | Supported (write scalability)  | Not supported                  |

---

## DynamoDB RCU/WCU Calculations

### Read Capacity Units (RCU)

| Read Type                   | Item Size   | RCU per Read                   |
|-----------------------------|-------------|--------------------------------|
| **Strongly Consistent**     | up to 4 KB  | 1 RCU per read                 |
| **Eventually Consistent**   | up to 4 KB  | 0.5 RCU per read               |
| **Transactional**           | up to 4 KB  | 2 RCU per read                 |

**Formula:** RCUs = (reads/sec) x (ceil(item_size / 4 KB)) x multiplier

- Strongly consistent multiplier: 1
- Eventually consistent multiplier: 0.5
- Transactional multiplier: 2

**Example:** 10 strongly consistent reads/sec of 6 KB items  
= 10 x ceil(6/4) x 1 = 10 x 2 x 1 = **20 RCUs**

**Example:** 20 eventually consistent reads/sec of 12 KB items  
= 20 x ceil(12/4) x 0.5 = 20 x 3 x 0.5 = **30 RCUs**

### Write Capacity Units (WCU)

| Write Type                  | Item Size   | WCU per Write                  |
|-----------------------------|-------------|--------------------------------|
| **Standard**                | up to 1 KB  | 1 WCU per write                |
| **Transactional**           | up to 1 KB  | 2 WCU per write                |

**Formula:** WCUs = (writes/sec) x (ceil(item_size / 1 KB)) x multiplier

- Standard multiplier: 1
- Transactional multiplier: 2

**Example:** 15 writes/sec of 2.5 KB items  
= 15 x ceil(2.5/1) x 1 = 15 x 3 = **45 WCUs**

**Example:** 5 transactional writes/sec of 3 KB items  
= 5 x ceil(3/1) x 2 = 5 x 3 x 2 = **30 WCUs**

---

## DynamoDB GSI vs LSI

| Feature                     | GSI (Global Secondary Index)   | LSI (Local Secondary Index)    |
|-----------------------------|--------------------------------|--------------------------------|
| **Partition key**           | Different from base table      | Same as base table             |
| **Sort key**                | Different from base table      | Different from base table      |
| **When to create**          | Anytime                        | At table creation only         |
| **Throughput**              | Own provisioned RCU/WCU        | Shares base table's throughput |
| **Max per table**           | 20                             | 5                              |
| **Size limit**              | No limit                       | 10 GB per partition key value  |
| **Consistency**             | Eventually consistent only     | Eventually or strongly consistent |
| **Projection**              | Can project any attributes     | Can project any attributes     |
| **Throttling**              | Can throttle independently     | Can throttle base table        |

**Exam tip:** "Query with a different partition key" → GSI. "Query with same partition key but different sort key" → LSI. "Must be strongly consistent" → LSI only.

---

## ElastiCache: Redis vs Memcached

| Feature                     | Redis                          | Memcached                      |
|-----------------------------|--------------------------------|--------------------------------|
| **Data structures**         | Strings, lists, sets, hashes, sorted sets, streams | Simple key-value (strings) |
| **Persistence**             | Yes (AOF, RDB snapshots)       | No                             |
| **Replication**             | Yes (up to 5 replicas)         | No                             |
| **Multi-AZ**                | Yes (with auto-failover)       | No                             |
| **Backup/restore**          | Yes                            | No                             |
| **Clustering**              | Yes (sharding)                 | Yes (sharding)                 |
| **Multi-threaded**          | No (single-threaded)           | Yes (multi-threaded)           |
| **Pub/Sub**                 | Yes                            | No                             |
| **Lua scripting**           | Yes                            | No                             |
| **Geospatial**              | Yes                            | No                             |
| **Max node size**           | Up to 340+ GB                  | Up to 340+ GB                  |
| **Encryption**              | At-rest and in-transit         | No encryption                  |
| **Compliance**              | HIPAA eligible                 | Not HIPAA eligible             |

**Exam tip:** Need persistence, replication, Multi-AZ, complex data types → **Redis**. Need simplest caching, multi-threaded → **Memcached**. When in doubt, **Redis** is almost always the answer.

---

## Database Service Selection Guide

| Requirement                        | Recommended Service                |
|------------------------------------|------------------------------------|
| Relational, complex queries, joins | **RDS** or **Aurora**              |
| High availability relational       | **Aurora** (6 copies, 3 AZs)      |
| Serverless relational              | **Aurora Serverless v2**           |
| Key-value, <10ms latency           | **DynamoDB**                       |
| Microsecond latency cache          | **DAX** (DynamoDB Accelerator)     |
| Session store / caching            | **ElastiCache Redis**              |
| Document database (MongoDB compat) | **DocumentDB**                     |
| Graph database                     | **Neptune**                        |
| Time-series data                   | **Timestream**                     |
| Ledger / immutable records         | **QLDB**                           |
| Data warehouse / OLAP              | **Redshift**                       |
| In-memory (millions of TPS)        | **MemoryDB for Redis**             |
| Wide-column (Cassandra compat)     | **Keyspaces**                      |
| Search                             | **OpenSearch** (Elasticsearch)     |

---

## EBS Volume Types for Database Workloads

| Volume Type      | Max IOPS       | Max Throughput | Latency  | Use Case                           |
|------------------|----------------|----------------|----------|-------------------------------------|
| **gp3**          | 16,000         | 1,000 MB/s     | Low      | General purpose DB, boot volumes    |
| **gp2**          | 16,000 (burst) | 250 MB/s       | Low      | Legacy general purpose              |
| **io2 Block Exp**| 256,000        | 4,000 MB/s     | Sub-ms   | Largest, most critical databases    |
| **io2**          | 64,000         | 1,000 MB/s     | Sub-ms   | I/O intensive, mission-critical     |
| **io1**          | 64,000         | 1,000 MB/s     | Sub-ms   | Legacy provisioned IOPS             |
| **st1**          | 500             | 500 MB/s       | Low      | Data warehouse, log processing      |
| **sc1**          | 250             | 250 MB/s       | Low      | Cold storage, infrequent access     |

**gp3 vs gp2:** gp3 lets you provision IOPS and throughput independently. gp2 IOPS scales with volume size (3 IOPS/GB, burst to 3,000).

**io2 Block Express:** Multi-attach supported. 99.999% durability. Best for critical databases.

---

## Aurora Endpoint Types

| Endpoint Type              | Purpose                                     | Use Case                        |
|----------------------------|---------------------------------------------|---------------------------------|
| **Cluster (Writer)**       | Points to current primary instance           | All write operations            |
| **Reader**                 | Load-balanced across all read replicas       | Read-heavy workloads            |
| **Custom**                 | Points to a subset of instances you choose   | Analytics on specific instances |
| **Instance**               | Points to a specific instance                | Debugging, specific instance ops|

**Auto-failover:** Cluster endpoint automatically points to new primary after failover. Reader endpoint excludes the failed instance.

---

## RDS Backup and Restore Options

| Feature                     | Automated Backups              | Manual Snapshots               |
|-----------------------------|--------------------------------|--------------------------------|
| **Triggered by**            | Automatic (backup window)      | User-initiated                 |
| **Retention**               | 0–35 days (default: 7)        | Until manually deleted         |
| **Backup type**             | Full daily + transaction logs  | Full snapshot                  |
| **Point-in-time restore**   | Yes (within retention period)  | No (snapshot time only)        |
| **Cross-region copy**       | No (use snapshot copy)         | Yes                            |
| **Restore creates**         | New RDS instance               | New RDS instance               |
| **Backup window impact**    | Brief I/O suspension (non Multi-AZ) | Brief I/O suspension     |
| **Sharing**                 | Cannot share                   | Can share with other accounts  |

**Restore always creates a NEW database instance** — cannot restore to an existing instance.

**Aurora cloning:** Faster than snapshot restore, uses copy-on-write protocol. Same cluster volume initially.

---

## All AWS Database Services at a Glance

| Service              | Type            | Engine/Model        | Max Storage  | Multi-AZ | Serverless | Key Feature                     |
|----------------------|-----------------|---------------------|-------------|----------|------------|---------------------------------|
| **RDS**              | Relational      | MySQL, PostgreSQL, MariaDB, Oracle, SQL Server | 64 TB | Yes | No | Managed relational DB |
| **Aurora**           | Relational      | MySQL, PostgreSQL   | 128 TB      | Yes (built-in) | Yes (v2) | 5x MySQL, 3x PostgreSQL perf |
| **DynamoDB**         | Key-Value/Doc   | Proprietary         | Unlimited   | Yes (built-in) | Yes (on-demand) | Single-digit ms, auto-scaling |
| **DocumentDB**       | Document        | MongoDB compatible  | 128 TB      | Yes      | No         | MongoDB workload migration      |
| **Neptune**          | Graph           | Gremlin, SPARQL     | 128 TB      | Yes      | Yes        | Billions of relationships       |
| **Keyspaces**        | Wide-Column     | Cassandra compatible| Unlimited   | Yes      | Yes        | Cassandra migration             |
| **QLDB**             | Ledger          | PartiQL             | Unlimited   | Yes (built-in) | Yes | Immutable, cryptographic journal|
| **Timestream**       | Time-Series     | Proprietary         | Unlimited   | Yes (built-in) | Yes | 1000x faster than relational  |
| **Redshift**         | Data Warehouse  | PostgreSQL-based    | PB scale    | No*      | Yes        | OLAP, columnar storage          |
| **ElastiCache**      | In-Memory       | Redis, Memcached    | ~340 GB/node| Redis only| No        | Microsecond latency caching     |
| **MemoryDB**         | In-Memory       | Redis compatible    | ~340 GB/node| Yes      | No         | Durable in-memory, millions TPS |
| **OpenSearch**       | Search/Analytics| Elasticsearch       | 3 PB        | Yes      | Yes        | Full-text search, log analytics |
| **DAX**              | In-Memory Cache | DynamoDB front-end  | N/A         | Yes      | No         | Microsecond reads for DynamoDB  |

*Redshift: Multi-AZ available for RA3 clusters
