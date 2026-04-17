# 2.2 Configuring Storage Systems

Practical operational knowledge of GCP storage — how to configure, secure, tune, and evolve each service.

---

## 1. Cloud Storage — operational knobs

### Bucket creation

```bash
gcloud storage buckets create gs://acme-prod-data \
  --location=US-CENTRAL1 \
  --default-storage-class=STANDARD \
  --uniform-bucket-level-access \
  --public-access-prevention \
  --retention-period=7y \
  --enable-autoclass
```

### Lifecycle management

```json
{
  "rule": [
    {"action": {"type": "SetStorageClass", "storageClass": "NEARLINE"},
     "condition": {"age": 30, "matchesStorageClass": ["STANDARD"]}},
    {"action": {"type": "SetStorageClass", "storageClass": "COLDLINE"},
     "condition": {"age": 90}},
    {"action": {"type": "Delete"}, "condition": {"age": 2555}}
  ]
}
```

Use:
- **Autoclass** unless objects are <128 KiB (autoclass doesn't optimize small objects).
- **Object retention lock** for WORM compliance per object.
- **Bucket lock** + retention policy for per-bucket legal holds.

### Access control

- Prefer **Uniform bucket-level access** (UBLA) + IAM.
- For fine-grained time-limited access → **signed URLs** or **signed policy documents**.
- For service-to-service → service account IAM binding.
- For public content → **allUsers** + Object Viewer (or front with CDN and keep bucket private).

### Data classification with DLP

- Scan buckets periodically (via **Sensitive Data Protection / Cloud DLP**).
- Auto-redact PII before downstream processing.

### Performance tips

- Parallel composite uploads for >150 MB files (`gcloud storage cp` does this automatically).
- For high QPS with sequential keys, **randomize prefix** to avoid hot ranges.
- **HTTP/2 + multipart** for small-object throughput.
- Use **GCS Fuse** only for read-heavy / simple write patterns.

---

## 2. Persistent Disks & Hyperdisk

### Disk types

| Type | IOPS | Use |
| --- | --- | --- |
| PD-Standard | modest | backups, cold data |
| PD-Balanced | moderate | general SSD-class |
| PD-SSD | high IOPS | databases |
| PD-Extreme | up to 100K IOPS | large HPC DBs |
| Hyperdisk-Balanced/Throughput/Extreme | decoupled IOPS+throughput | modern, latest-gen machines |
| Local SSD | ephemeral | scratch, cache |

### Regional PD

- Sync replication across 2 zones in one region.
- Use for HA stateful workloads (e.g., Jenkins master, single-node DB with standby).
- Cannot boot 2 VMs on one regional PD; failover manual (but snapshotting and re-mount is common pattern).

### Snapshots

- Global resource; incremental; encrypted at rest.
- Schedules: hourly/daily/weekly; retention policy.
- Cross-region restore possible.
- **Multi-regional snapshot** (MRS) for HA.

### Disk resize

- **Grow** online (`gcloud compute disks resize ...`) then resize the filesystem inside the VM.
- **Shrink** not supported in place.

---

## 3. Filestore

Tiers:

- **Basic HDD / SSD** (zonal, low-cost NFS).
- **Zonal / Enterprise** (enterprise HA in region).
- **High Scale** (up to 100 TB, up to 480K IOPS).

Key capabilities:

- NFSv3 only.
- CMEK supported.
- Backups to GCS.
- Active Directory / LDAP not supported (use SMB on third-party if needed).

Use when an app requires POSIX NFS. Otherwise prefer GCS / Cloud Storage Fuse.

---

## 4. Cloud SQL — ops knobs

- Tier (vCPU / RAM), storage (auto-grow), HA on/off, read replicas (within region / cross-region).
- **Private IP** via **Private Service Access** (producer VPC peering).
- **Cloud SQL Auth Proxy** for IAM-based DB auth.
- **Point-in-time recovery** via write-ahead logs (PG) / binlogs (MySQL).
- **Maintenance window** — set explicitly.
- **Query Insights** for slow query analysis.
- **Backups**: automatic daily + manual; copy to other regions for DR.
- **CMEK** + customer secret rotation via Cloud KMS.

### Scaling patterns

- Read scaling → add read replicas; for heavy read traffic use multiple replicas with HAProxy or a connector.
- Write scaling → increase tier; if exhausted, shard or move to **Spanner / AlloyDB**.

---

## 5. Spanner — ops

- **Instance** → configuration (regional / multi-region nam3, nam6, nam-eur-asia1…) + processing units (PU) or nodes (1 node = 1000 PU).
- Resize online; add / remove PUs with no downtime.
- Backups in same or cross-region; **Backup Schedules** for automation.
- **Data Boost** — serverless compute for analytics without hurting OLTP.
- **Change streams** for CDC to Pub/Sub / BigQuery.
- **Granular Instance Partitioning** (Spanner Graph, Full-text search, vector search recent additions).

### Schema design

- Interleave child tables with parent for locality.
- Avoid hotspot keys (monotonic increasing) — hash the prefix or use UUIDv4.
- Use **secondary indexes** + **STORING** clause to avoid extra round-trips.

---

## 6. BigQuery — ops

- Dataset is regional / multi-regional / bi-regional.
- **Partitioned** by ingestion time / DATE / TIMESTAMP / integer range.
- **Clustered** by up to 4 columns (prune scans).
- **Materialized views** for accelerated aggregations.
- **Table snapshots** and **clone** (copy-on-write).
- **Time travel** 7d default (configurable 2–7d).
- **Authorized views / authorized datasets / authorized routines** for column/row-level access.
- **Row/Column-level security**: `ROW ACCESS POLICY` and `GRANT ... ON COLUMN`.
- **Dynamic data masking** (PII), **policy tags** via Data Catalog / Dataplex.

### Pricing modes

- **On-demand**: $6.25/TB scanned (after free 1 TB/month/region).
- **Editions**: Standard (no time travel), Enterprise, Enterprise Plus (CMEK, multi-region replication).
- **Slot reservations** + **autoscaler** in Enterprise.
- **Storage**: active vs long-term (90-day untouched), much cheaper (~50%).

---

## 7. Firestore — ops

- Pick **Native** (new apps) or **Datastore mode** at DB creation; cannot switch.
- Regional / multi-region locations (nam5, eur3).
- **Firestore indexes** — single-field auto; composite via `firebase deploy` or `firestore.indexes.json`.
- **Firestore security rules** for mobile/web; backend uses IAM.
- **Import/export** to GCS (managed).

---

## 8. Bigtable — ops

- **Instance** with one or more **clusters**, each in a zone.
- Multi-cluster routing = active/active; single-cluster = active/passive.
- **App profiles** route requests by consistency level (single-cluster for strong, multi-cluster for HA).
- **Replication** lag minimal.
- Autoscaling CPU / storage utilization.
- **Key Visualizer** to diagnose hot keys.
- **HBase shell** compatibility.

### Schema design

- One table, wide rows. Columns are strings.
- Rowkey: most important; reverse timestamp, hashed prefix, composite (`device#ts#sensor`).
- Column families as access pattern groupings (GC rules per family).

---

## 9. Memorystore — ops

- Redis (Standard HA vs Basic) or Memcached.
- VPC-only via Private Service Access.
- **Redis Cluster mode** (newer scale-out managed product).
- Persistence: RDB snapshots (Redis Standard Tier).
- CMEK.

---

## 10. Data protection & lifecycle (cross-cutting)

| Concern | Service |
| --- | --- |
| Backup orchestration (GCE + Cloud SQL + VMware) | **Backup and DR Service** |
| Object-level retention | GCS bucket lock + retention lock |
| Data masking | DLP + BigQuery policy tags |
| Immutable audit | Logs export to GCS bucket with retention |
| Key management | Cloud KMS / EKM / Cloud HSM |
| Secrets | Secret Manager (+ CMEK) |

### Encryption

- Every GCP service encrypts at rest by default.
- **CMEK** (Cloud KMS keys) available on GCS, PDs, BQ, Spanner, Cloud SQL, Filestore, Pub/Sub, etc.
- **CSEK** (you supply key material) for GCS and PD only; rare.
- **EKM** (External Key Manager) via partners (Thales, Fortanix, Virtru); required for some high-regulation workloads.

---

## 11. Growth and tiering strategy

- Define a **taxonomy of labels** (env, app, owner, cost-center) and enforce at project factory.
- Use **Dataplex** to catalog and govern lakes across GCS + BQ.
- Use **Active Assist** recommenders to rightsize and decommission idle resources.
- **Budget alerts** + billing export; review monthly in FinOps reviews.

---

## 12. Storage configuration exam patterns

| Requirement | Correct choice |
| --- | --- |
| 7-year retention + WORM | GCS + Archive + bucket lock |
| Small-object, high-QPS | GCS Standard, UBLA; consider CDN |
| Video streaming | GCS Standard or Nearline + CDN |
| OLTP <10TB regional | Cloud SQL HA |
| OLTP global strongly consistent | Spanner multi-region |
| Time-series IoT | Bigtable |
| Mobile app state | Firestore Native |
| Low-latency session store | Memorystore Redis |
| Shared NFS for render farm | Filestore Enterprise or High Scale |

Next: `03-networking-configuration.md`.
