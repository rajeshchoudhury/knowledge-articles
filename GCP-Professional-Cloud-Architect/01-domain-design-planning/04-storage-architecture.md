# 1.3b Designing Storage and Database Architecture

Storage and data choices dominate the exam. Know each service's consistency, latency, throughput, scale, cost and durability properties. The decision tree below is the core tool.

---

## 1. Unified storage decision tree

```
Is it structured data with schemas and transactions?
├── Yes → How big and how global?
│        ├── < 30 TB, single region → Cloud SQL
│        ├── Global, strongly consistent, 99.999% → Cloud Spanner
│        └── Analytical (PB-scale, OLAP) → BigQuery
│
└── No → Is it semi-structured / document / key-value?
        ├── Document store, mobile/web, offline sync → Firestore
        ├── Wide-column, >1TB, time-series, high-throughput → Bigtable
        ├── In-memory cache / session → Memorystore (Redis/Memcached)
        └── Unstructured files / objects / media → Cloud Storage (GCS)

Need POSIX file system?
├── Yes → Filestore (NFS)  / persistent disks (block) / GCS Fuse for read-heavy
```

### Latency-to-cost spectrum (typical p50)

```
Memorystore (< 1 ms) → Bigtable (~5 ms) → Spanner (~10 ms) → Firestore (~15 ms) → Cloud SQL (~10–20 ms) → BigQuery (>200 ms) → GCS (~30 ms) → Filestore (< 10 ms)
```

---

## 2. Object storage — Cloud Storage (GCS)

- Buckets: name is globally unique; location = region / dual-region / multi-region.
- Storage classes: **Standard, Nearline (30d), Coldline (90d), Archive (365d)** minimum storage duration; early delete fees.
- **Autoclass**: auto-transitions objects between classes based on access pattern; no early-delete.
- **Object Lifecycle Management**: rules to move/delete based on age, version, class, prefix.
- **Versioning** + generation numbers; noncurrent versions billed like current.
- **Retention Policies (bucket lock)** + **Object Retention Lock** for WORM compliance.
- **Uniform bucket-level access (UBLA)**: IAM only, no ACLs; required for most hardened envs.
- **Signed URLs / V4 signing** for temporary grants.
- **Customer-managed encryption keys (CMEK)** and **customer-supplied (CSEK)**.
- **Turbo replication** for dual-region (RPO 15 min).
- **Object notifications** → Pub/Sub on object create/delete/update.
- **Requester-pays**: bucket owner charges requester network egress.
- **Cloud Storage Fuse** → mount as file system (read/write; eventual consistency for concurrent writes).

### Picking a class

| Access pattern | Class |
| --- | --- |
| Frequent | Standard |
| < 1×/month | Nearline |
| < 1×/quarter | Coldline |
| < 1×/year, compliance | Archive |

### Traps

- Choosing Nearline for logs with 7-day retention → early delete fee.
- Choosing multi-region when data must stay in one country → compliance violation.
- Using dual-region for compute colocated data without Turbo → RPO 12h only.

---

## 3. Block storage — Persistent Disks and Hyperdisk

- **PD-Standard / PD-Balanced / PD-SSD / PD-Extreme**.
- **Regional PD**: synchronous replication across 2 zones in a region (HA boot / DB data disk).
- **Hyperdisk Extreme / Throughput / Balanced / ML**: latest-gen, decouples IOPS/throughput from size; attach to supported VMs (C3, N4, etc.).
- Snapshots: global, incremental, encrypted, restore to any zone/region. Schedules for automatic retention.
- Machine image: boot + data disks + metadata; distinct from raw snapshot.

### Local SSD

- Ephemeral; 375 GB per disk; NVMe; extremely low latency.
- Data lost on stop/host maintenance. Use for scratch / caches.

---

## 4. File storage — Filestore

- Managed NFSv3.
- Tiers: **Basic HDD/SSD**, **Zonal**, **Enterprise** (regional HA), **High Scale**.
- Use for legacy apps that expect POSIX, media rendering, HPC.
- Multi-region not supported; for cross-region, replicate at application layer.

---

## 5. Relational — Cloud SQL and AlloyDB

### Cloud SQL

- MySQL, PostgreSQL, SQL Server.
- Up to ~128 vCPU, 864 GB RAM, 64 TB storage.
- **HA:** regional (primary + standby in different zones), synchronous replication, automatic failover. SLA 99.95%.
- **Read replicas**: in-region (async) or cross-region (async).
- **Backups**: automated daily + on-demand; PITR up to 35 days (default 7).
- **Connection**: Cloud SQL Auth Proxy, Private IP via Private Service Access, Cloud SQL Language connectors.
- **IAM database authentication** (MySQL, PG).
- **Transparent Data Encryption** by default; CMEK supported.

### AlloyDB for PostgreSQL

- Google's enterprise Postgres.
- Columnar accelerator for analytical queries.
- 4× faster than stock PG for TP, 100× for analytics.
- **AlloyDB Omni** for on-prem / other clouds.
- Strong fit for modernizing Oracle PG workloads.

### When Cloud SQL vs AlloyDB vs Spanner

- **< 10 TB, OLTP, classic Postgres feature-set** → Cloud SQL.
- **Large Postgres with HTAP** → AlloyDB.
- **Global distribution, > 99.99% SLA, horizontal scale** → Spanner.

---

## 6. Globally distributed RDBMS — Cloud Spanner

- Horizontally scalable, strongly consistent, SQL.
- **TrueTime**: globally synchronized atomic/GPS clock; enables external consistency.
- Schema: parent-child interleaved tables for locality.
- Nodes (compute) decoupled from storage. Scale nodes or use **processing units** (100 PU = 1 node).
- **Regional** (99.99%) or **multi-region** (99.999%) instances.
- No downtime to resize.
- **Data Boost** for ETL reads without impacting transactional workload.
- **Change streams** for CDC.
- **Backups** stored for up to 1 year; PITR up to 7 days.

### When to choose Spanner

- Multi-region strongly consistent SQL.
- Workloads exceeding Cloud SQL scale.
- Financial / inventory systems needing external consistency.

### When Spanner is wrong

- Tiny, < 1 TB workload with budget constraints (min cost ≈ $650/mo at 1 node).
- Full PG feature set needed (Spanner supports GoogleSQL and PG dialect, but not all extensions).

---

## 7. Document store — Firestore

- Successor to Cloud Firestore + Datastore.
- **Native mode** (new apps, real-time listeners, offline sync for mobile/web).
- **Datastore mode** (legacy compatibility; higher throughput).
- Regional or multi-region.
- Strong consistency for entity reads; eventual for queries across entities.
- Security rules via Firebase Auth for mobile apps; IAM for server-side.
- Indexes: auto single-field; composite via config.
- **Firestore in Native mode** recommended for new apps.

### Sizes

- Up to hundreds of TB comfortable.
- 1 MB/document, 20K writes/second per key range auto-shards.

---

## 8. Wide-column NoSQL — Cloud Bigtable

- HBase-compatible API.
- Single-row atomic; no cross-row transactions.
- Designed for PB-scale, high throughput (> 1 M QPS).
- Clusters in a single region; replication across regions (multi-cluster routing).
- Use cases: time-series, IoT, personalization, ad-tech.
- Schema: rowkey design is critical (avoid hotspots; use reverse-timestamp / hash prefix).

---

## 9. In-memory — Memorystore

- **Redis**: managed; up to 300 GB; Standard (HA) and Basic; read replicas (Redis Cluster mode).
- **Memcached**: managed; horizontal scale; no persistence.
- **Memorystore for Redis Cluster** (newer): scale-out.
- VPC-only; use for sessions, cache, leaderboards.

---

## 10. Data warehouse — BigQuery (brief; full deep dive in 07-)

- Serverless; columnar; PB-scale.
- **Slots** (compute) separated from **storage**.
- Pricing: On-demand (per TB scanned) or **Editions** (Standard/Enterprise/Enterprise+) with commit slots and autoscaling.
- Partitioning: ingestion time / date / integer range.
- Clustering: up to 4 columns for pruning.
- **BigQuery Omni**: query data in AWS/Azure.
- **Storage API** for direct reads to Spark/Flink/Dataflow.
- **BI Engine** for sub-second dashboards (in-memory).

---

## 11. Data transfer / migration surfaces

- **Storage Transfer Service** — on-prem → GCS, S3 → GCS, GCS → GCS (scheduled).
- **Transfer Appliance** — offline, up to PB-scale shipping hardware.
- **BigQuery Data Transfer Service** — SaaS → BQ (Google Ads, YouTube, S3, Redshift).
- **Database Migration Service (DMS)** — MySQL/PG/SQL Server → Cloud SQL or AlloyDB.
- **Datastream** — change streams from MySQL/PG/Oracle → BigQuery/GCS/Spanner.
- **Migrate to Virtual Machines** (Migrate for Compute Engine) — VMware/AWS EC2 → GCE.
- **Migrate to Containers (M4C)** — VM → container.

---

## 12. Picking storage from a case-study one-liner

| Phrase | Almost certainly |
| --- | --- |
| "unstructured video" | GCS |
| "retain 7 years for compliance" | GCS Archive + retention policy |
| "time-series telemetry 1M points/s" | Bigtable |
| "worldwide financial ledger" | Spanner |
| "mobile app with offline sync" | Firestore |
| "analytics dashboards over years of data" | BigQuery |
| "shared file system for legacy app" | Filestore |
| "sub-ms key-value" | Memorystore |
| "regional Postgres with PITR" | Cloud SQL PG / AlloyDB |
| "NFS for render farm" | Filestore High Scale |
| "replicated 15-minute RPO across 2 regions" | GCS dual-region w/ Turbo |

Next: `05-network-architecture.md`.
