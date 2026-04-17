# 1.2 Technical Requirements — HA, Scalability, Elasticity, Resilience

Technical requirements turn "what must be true" into concrete Google Cloud service choices. For the PCA exam, master the vocabulary below and the thresholds that flip decisions from one service to another.

---

## 1. High Availability (HA)

**Definition.** Capability to remain operational in the presence of failures within a defined scope.

### HA scopes on GCP

| Scope | Example failures | Typical designs |
| --- | --- | --- |
| **Instance** | VM crash, hardware fault | Managed Instance Group (MIG) with auto-heal, live migration |
| **Zone** | Power / network loss in one zone | Multi-zone MIG, regional PD, GKE regional cluster |
| **Region** | Natural disaster, major outage | Multi-region deployment, Spanner multi-region, cross-region replication |
| **Global** | Provider-wide (rare) | Multi-cloud / hybrid failover |

### Availability math

```
Availability = Uptime / (Uptime + Downtime)
SLA 99.9%  -> 43m 12s downtime/month
SLA 99.95% -> 21m 36s/month
SLA 99.99% -> 4m 19s/month
SLA 99.999% (5 nines) -> 26s/month
```

### Service SLAs to memorize

| Service | SLA (single region / zone) | Multi-region SLA |
| --- | --- | --- |
| Compute Engine instance | 99.5% single, 99.99% MIG multi-zone | — |
| Cloud Storage Standard | 99.0% standard / 99.9% dual-region read | 99.95% multi-region |
| Cloud SQL HA | 99.95% | — |
| Spanner regional | 99.99% | 99.999% multi-region |
| GKE zonal | 99.5% | 99.95% regional |
| Cloud Run | 99.95% | — |
| Cloud Load Balancing | 99.99% | — |
| BigQuery | 99.99% (same-region storage) | 99.9% multi-region |
| Pub/Sub | 99.95% | — |
| Cloud DNS | 100% SLA (notable) | — |

*Always confirm with docs; numbers drift. On exam, pick **regional** over zonal for stateful workloads; **multi-region** only if a requirement explicitly demands it (cost doubles).*

---

## 2. Scalability vs. Elasticity

- **Scalability** — capacity to grow (vertical or horizontal).
- **Elasticity** — ability to scale **in and out** automatically with demand.

### Horizontal scaling patterns

- **Managed Instance Groups** with autoscaler (CPU, custom metric, HTTP LB serving capacity, Pub/Sub queue length, schedule).
- **GKE HPA / VPA / Cluster Autoscaler / Node auto-provisioning** — pods, pods' requests, nodes, and node pools.
- **Cloud Run** — concurrency-based; scales to zero.
- **App Engine Standard** — automatic scaling; scale-to-zero with cold starts.
- **Serverless products (Functions, Run)** are elastic **by design**; preferred for spiky workloads.

### Vertical scaling

- Resizing a Cloud SQL instance or GCE VM requires downtime (Cloud SQL) or a stop/restart (GCE).
- Spanner scales by adding **nodes** (no downtime).
- Bigtable scales by adding **nodes** (no downtime; storage independent).
- BigQuery slots can auto-grow with Editions (Enterprise / Enterprise Plus).

### Common exam trap

Picking a design that scales but doesn't **scale to zero** when cost is the priority (use Cloud Run or Functions). Conversely, picking Cloud Run for a workload that needs deep customization of the runtime (use GKE).

---

## 3. Resilience and fault tolerance

- **Idempotent operations** — safe retries (e.g., Pub/Sub deliveries may duplicate; design exactly-once downstream).
- **Circuit breakers / retries with backoff + jitter.**
- **Dead-letter queues** — Pub/Sub DLQ topic or subscription.
- **Checkpointing** — Dataflow, BigQuery load jobs, long-running Cloud Run jobs.
- **Graceful degradation** — serve stale cache, read replicas, feature flags.
- **Chaos engineering** — inject failure (e.g., Cloud Chaos, Gremlin); ensures real resilience.

### Patterns

- **Strangler fig** — migrate monolith gradually by routing portions through new services.
- **Saga** — distributed transactions via compensating actions; ideal for microservices over Spanner/Firestore + Pub/Sub.
- **CQRS / Event sourcing** — separate read/write; common with Firestore + Pub/Sub.
- **Retry / compensation with Workflows / Eventarc.**

---

## 4. Performance — latency, throughput, concurrency

### Latency sources

- Network (client → edge → region, cross-region, cross-VPC).
- Compute (cold start, CPU scheduling).
- Storage (PD vs SSD vs Hyperdisk vs Filestore vs GCS).
- Application (sync calls, DB indexing, N+1 queries).

### Reducing latency

| Lever | Service |
| --- | --- |
| Bring compute close to users | Global LB + regional backends + CDN |
| Cache static content | Cloud CDN (edge) or Memorystore (Redis) for app cache |
| Cache dynamic at region | Memorystore Redis / Memcached |
| Replicate data regionally | Spanner multi-region, Firestore multi-region |
| Reduce cross-service hops | Direct path (Private Service Connect, VPC peering) |

### Throughput knobs

- GCE network egress scales with vCPU count (2 Gbps/vCPU baseline).
- BigQuery slot count (ingest + query concurrency).
- Spanner nodes (≈10K QPS/node read, 2K QPS/node write).
- Bigtable nodes (≈10K QPS/node, 220 MB/s/node).
- Pub/Sub — practically unbounded; quotas apply.
- Cloud SQL — instance size; read replicas for read scaling.

---

## 5. Data durability

- **Durability** != availability. Durability is "never lost"; availability is "reachable now".
- Cloud Storage: **99.999999999%** (11 nines) durability.
- Persistent Disks: replicated within zone (regional PD replicates across 2 zones).
- Spanner: multi-region = 5× 5 replicas by default across 3+ regions.
- BigQuery: data replicated automatically; regional or multi-regional.
- Filestore: single-zone or enterprise (regional).

### Backups / retention

- **Cloud SQL** automated + on-demand backups; PITR up to 7 days default.
- **BigQuery** time travel 7 days; table snapshots; cross-region copy.
- **GCE** snapshots (incremental, global resource).
- **GCS** object versioning + retention policy (bucket lock) + Object Lifecycle Management.
- **Backup and DR Service** (Actifio-based) for GCE, VMware Engine, Cloud SQL.

---

## 6. Common NFRs and which GCP services satisfy them

| NFR | Example wording | Likely answer |
| --- | --- | --- |
| "Globally consistent OLTP" | "Users worldwide, strongly consistent balances" | **Spanner multi-region** |
| "Sub-10ms writes for telemetry, millions/sec" | IoT | **Bigtable** |
| "Ad-hoc analytics over PBs" | BI dashboards | **BigQuery + BI Engine / Looker** |
| "Low-latency product catalog with offline sync" | Mobile app | **Firestore** |
| "Cheap object archive 10y" | Compliance storage | **GCS Archive + bucket lock** |
| "Millisecond key-value < 1 ms" | Session store | **Memorystore Redis** |
| "Real-time 1M event/sec pipeline" | Event processing | **Pub/Sub + Dataflow streaming** |
| "Legacy WebLogic w/ Oracle" | Move as-is | **GCE + Bare Metal Solution + Cloud VPN/Interconnect** |
| "Containerized stateless app" | "Pay only for use" | **Cloud Run** |
| "K8s workload with CRDs, sidecars, service mesh" | — | **GKE Autopilot / Standard + Anthos Service Mesh** |

---

## 7. Translating NFRs into decisions (worked example)

> "Our API must serve 100K rps globally with p95 < 150 ms and a 99.99% SLA. Data is relational and needs strong consistency worldwide."

- 100K rps globally → **Global external HTTPS LB** + **Cloud CDN** (read-heavy caching).
- p95 < 150 ms → compute in **multiple regions**, close to users.
- 99.99% SLA globally → **multi-region Spanner** (5 nines) + regional **GKE** clusters across at least 3 regions.
- Relational + strongly consistent worldwide → **Spanner**, not Cloud SQL.
- Backups → Spanner PITR + export to GCS.
- Observability → Cloud Monitoring + Trace + Logging; SLO at 99.99% with 30-day window.

Wrong tempting answers:

- Cloud SQL with cross-region replicas — replicas are async, not strongly consistent.
- Regional LB — not global.
- Cloud Run with global but single-region Spanner — single-region Spanner SLA 99.99%, not bad, but fails multi-region requirement for latency.

Next: `03-compute-architecture.md`.
