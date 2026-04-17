# Service Deep Dive — Firestore & Bigtable & Memorystore

## Firestore

- NoSQL document DB; serverless, elastic.
- Two **modes** (pick at creation, cannot switch):
  - **Native mode**: real-time listeners, offline sync (mobile/web).
  - **Datastore mode**: higher throughput, classic GAE Datastore compat.
- Location: **regional** (e.g., `us-central1`) or **multi-region** (`nam5`, `eur3`).
- **Strong consistency** on entity reads; eventual consistency on queries.
- **Indexes**: single-field auto + composite via config.
- **Security rules** (for Firebase Auth clients).
- **Firestore triggers** via Eventarc for serverless functions.
- **Bundle** / **offline** support.
- **Import/export** to GCS (managed).
- **Firestore in Native mode** recommended for new apps.

Limits:
- 1 MB/doc, 20K writes/sec per key range (auto-shards).
- Queries limited to one inequality filter per query.

## Bigtable

- Wide-column NoSQL; HBase-compatible API.
- Single-row atomic writes; no cross-row transactions.
- PB-scale; >1M QPS per cluster.
- **Clusters** per region (single-zone per cluster); **replication** across clusters.
- **App profiles** with routing policy: single-cluster (strong) or multi-cluster (AP).
- **SSD** (default) or HDD storage.
- **Autoscaling** on CPU & storage.
- **Key Visualizer** for hotspot analysis.
- **Backups** per table; up to 30 days.
- Integrates with Dataflow, Dataproc, BigQuery federated queries.

### Schema design
- Rowkey design is everything. Avoid monotonic keys; use hashed prefixes or `deviceId#reverseTimestamp`.
- Column families are access-pattern groups.
- Keep rows to <100 MB; single cell <10 MB.

### Use cases
- Time-series (IoT, monitoring).
- Ad tech, financial ticks.
- Personalization features.
- Low-latency hot storage fronting BigQuery historical.

## Memorystore

### Memorystore for Redis
- **Standard tier** (HA, 99.9% SLA) / **Basic** (single node).
- Sizes up to 300 GB.
- Read replicas (Redis cluster mode).
- Private IP via PSA; CMEK.

### Memorystore for Memcached
- Horizontal scale with shards; no persistence.

### Memorystore for Redis Cluster
- Newer scale-out managed Redis; up to TB-scale.
- Cluster mode enabled.

## Comparison cheat sheet

| Need | Pick |
| --- | --- |
| Document store with offline sync | Firestore Native |
| High-throughput document store | Firestore Datastore mode |
| Time-series / IoT, huge throughput | Bigtable |
| Sub-ms cache / sessions | Memorystore Redis |
| In-memory Memcached legacy | Memorystore Memcached |
| Global strongly consistent SQL | Spanner |
| Relational OLTP regional | Cloud SQL / AlloyDB |
