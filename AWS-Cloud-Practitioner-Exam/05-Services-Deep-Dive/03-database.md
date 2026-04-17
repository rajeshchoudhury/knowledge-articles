# Database Services — Deep Dive

## Amazon RDS

- **What it is:** Managed relational DBs.
- **Engines:** MySQL, PostgreSQL, MariaDB, Oracle (BYOL / License
  Included), SQL Server, IBM Db2, **Aurora** (MySQL & PostgreSQL
  compatible).
- **HA:**
  - Single-AZ (dev/test).
  - **Multi-AZ instance deployment** — synchronous standby in a second AZ.
  - **Multi-AZ cluster deployment** — 1 writer + 2 readable standbys
    across 3 AZs (only MySQL/PostgreSQL engines).
- **Read replicas** — async; up to 5; can be cross-Region; can be
  promoted.
- **Backups** — daily automated (1–35 days retention) + transaction logs
  (PITR); manual snapshots.
- **RDS Proxy** — connection pooling (especially useful with Lambda).
- **RDS Custom** — for Oracle/SQL Server with OS/DB admin access.
- **Encryption at rest via KMS** chosen at creation; cannot be changed
  after (restore from snapshot to new encrypted DB).
- **Pricing:** Instance-hour + storage + IOPS + backup storage beyond
  free tier + data transfer.

---

## Amazon Aurora

- **What it is:** Cloud-native relational engine, API-compatible with
  MySQL or PostgreSQL.
- **Performance:** Up to 5× MySQL, 3× PostgreSQL vs stock RDS.
- **Architecture:**
  - **6 copies** of data across **3 AZs**.
  - Storage auto-grows to **128 TB** (MySQL) / 256 TB (newer PostgreSQL).
  - Up to 15 Aurora Replicas with near-zero replica lag.
  - **Multi-Master** (deprecated) / **Multi-Primary** variants.
  - **Aurora Serverless v2** — fine-grained auto scaling (ACUs).
  - **Aurora Global Database** — primary + up to 5 secondary Regions,
    sub-second cross-region replication, < 1 minute RPO / RTO.
  - **Aurora I/O-Optimized** — for I/O-heavy workloads, predictable cost.
- **Cost:** ~20% more than RDS MySQL/PostgreSQL but gives superior HA,
  scale, and performance.

---

## Amazon DynamoDB

- **What it is:** Fully managed NoSQL key-value + document database.
- **Best for:** Serverless apps, session state, IoT, gaming leaderboards,
  shopping carts, any unpredictable-scale KV workload.
- **Key features:**
  - Single-digit millisecond latency at any scale.
  - **Capacity modes:** On-Demand (pay-per-request) vs Provisioned
    (RCU/WCU; supports auto scaling).
  - **Global Tables** — multi-active multi-Region.
  - **Streams** — ordered change feed (24-hour retention) → trigger Lambda.
  - **DynamoDB Accelerator (DAX)** — in-memory cache, µs reads.
  - **Point-in-Time Recovery (PITR)** — 35 days.
  - **TTL** — auto-delete items.
  - Encryption at rest by default (AWS owned, or AWS managed / CMK).
- **Pricing:** Per RCU/WCU (Provisioned) or per request (On-Demand) +
  storage + streams.
- **Gotchas:**
  - Item max **400 KB**.
  - Querying outside the primary key requires a **Global Secondary
    Index (GSI)** or **Local Secondary Index (LSI)**.

---

## Amazon ElastiCache

- **What it is:** Managed in-memory cache.
- **Engines:**
  - **Redis** (or its open-source fork **Valkey**) — replication,
    persistence, pub/sub, Lua, geospatial, advanced data structures.
  - **Memcached** — simple, multi-threaded, sharding via client.
- **Best for:** Session store, leaderboards, cache-in-front-of-DB.
- **Pricing:** Per node-hour + data transfer.

---

## Amazon MemoryDB for Redis

- **What it is:** Redis-compatible durable database (multi-AZ
  transaction log).
- **Best for:** Microservices with in-memory performance that need the
  durability of a primary DB.
- **Compare with:** ElastiCache (cache, may lose data) vs MemoryDB (DB).

---

## Amazon DocumentDB (MongoDB compatible)

- **What it is:** Managed JSON document DB, MongoDB 3.6/4.0/5.0 wire
  protocol.
- **Best for:** MongoDB workloads that you want managed.

---

## Amazon Neptune

- **What it is:** Managed graph DB.
- **Models:** Property graph (Gremlin, openCypher) and RDF (SPARQL).
- **Best for:** Social networks, fraud detection, knowledge graphs,
  recommendation engines.

---

## Amazon Keyspaces (for Apache Cassandra)

- **What it is:** Serverless, Cassandra-compatible wide-column DB.
- **Pricing:** On-Demand or Provisioned.

---

## Amazon Timestream

- **What it is:** Serverless time-series DB.
- **Best for:** IoT device telemetry, operational metrics, industrial
  sensor data.
- **Features:** Two storage tiers (memory + magnetic), SQL-ish queries,
  scheduled queries, integrated with Kinesis, IoT Core, Grafana.

---

## Amazon QLDB

- **What it is:** Ledger DB with immutable journal and cryptographic
  verification.
- **Status:** AWS announced end of service on **July 31, 2025**. For
  new workloads prefer Aurora PostgreSQL with append-only tables or
  Amazon Managed Blockchain.
- **Still tested on CLF-C02** (know the concept).

---

## Amazon Redshift

- **What it is:** Petabyte-scale data warehouse, columnar MPP.
- **Key features:**
  - RA3 (managed storage), DC2 (compute-optimized, legacy) instance types.
  - **Redshift Serverless** for on-demand analytics.
  - **Concurrency Scaling** and **Data Sharing** across clusters/accounts.
  - **Redshift Spectrum** to query S3 without loading.
  - **Federated queries** to RDS/Aurora.
  - Integrates with Lake Formation, Glue, S3, SageMaker.
- **Pricing:** Node-hour (RA3/DC2), per-second (Serverless), plus
  concurrency-scaling credit bucket.

---

## Database Selection Rule

```
Use case                                  → Service
Standard SQL OLTP, 1 engine matters       → RDS (MySQL, PG, SQL Server, Oracle, Db2)
Cloud-native relational HA/perf           → Aurora
Autoscale relational, dev/test or spiky   → Aurora Serverless v2
Multi-Region active relational            → Aurora Global Database
NoSQL KV/document, serverless, any scale  → DynamoDB
Cache in front of DB                      → ElastiCache (Redis/Valkey) or DAX
Durable in-memory primary DB              → MemoryDB
Graph relationships                       → Neptune
MongoDB API                               → DocumentDB
Cassandra API                             → Keyspaces
Time-series IoT/metrics                   → Timestream
Ledger / cryptographically verifiable      → Aurora PG w/ append-only (QLDB dep.)
Data warehouse                            → Redshift / Redshift Serverless
Ad-hoc SQL on S3                          → Athena
```
