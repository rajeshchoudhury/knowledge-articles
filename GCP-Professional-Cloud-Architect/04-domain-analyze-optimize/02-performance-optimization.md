# 4.2 Performance Optimization

This chapter deals with improving latency and throughput once the workload is running.

---

## 1. Performance diagnostic toolchain

- **Cloud Profiler** — continuous profiling (CPU, heap, contention) for Go/Java/Node/Python/PHP/.NET.
- **Cloud Trace** — distributed tracing (OpenTelemetry integration).
- **Cloud Monitoring** — metrics; dashboards; golden signals.
- **Cloud Logging** + log-based metrics.
- **Error Reporting** — surface exceptions.
- **Active Assist Recommender** — performance hints.
- **Network Intelligence Center** — latency, topology, connectivity tests.

---

## 2. Latency optimization patterns

### Compute

- Warm containers (min instances ≥ 1) for Cloud Run / Functions to avoid cold starts.
- Prefer Cloud Run **always-allocated CPU** for latency-sensitive background work.
- Right instance family: C3/C3D for compute-heavy, Tau for cost/perf, M-series for memory latency.
- Tune GC / thread pools; profile hot paths.

### Networking

- Global LB for global users; Premium Tier for Google backbone routing.
- Cloud CDN for static and dynamic with signed requests.
- **Private Service Connect** to reduce hops vs VPC peering.
- Reduce TLS overhead via HTTP/2 & long-lived connections.

### Database

- Indexes (all engines).
- Read replicas close to readers (Cloud SQL, Spanner read-only replicas per region).
- Memorystore cache in front of Cloud SQL / Spanner for hot keys.
- Spanner: interleave tables, avoid hot keys, tune transactions.
- Bigtable: design row keys for locality.

### Storage

- Use PD-SSD / Hyperdisk for DB workloads.
- Local SSDs for scratch/temp.
- GCS + CDN for static assets.

---

## 3. Throughput optimization

- MIGs with appropriate max size; LB max RPS per backend.
- Pub/Sub publish batch size + message ordering; careful with ordering keys (sequential writes).
- BigQuery: partitioning + clustering; large slot reservations; **Storage Read API** for Spark/Dataflow.
- Dataflow Streaming Engine to decouple shuffle/state from workers.
- Dataproc: Spark adaptive query execution.

---

## 4. SLO-driven optimization

- Define **SLI** (availability, latency p95/p99, throughput).
- Set **SLO** targets (e.g., 99.9% success, p95 < 300 ms).
- Compute **error budget**; if burn rate high, stop new features, fix reliability first.
- Automate alerts with **SLO burn rate alerts** (fast and slow burn).

---

## 5. Load testing

- **Locust / k6 / JMeter** on GCE or GKE.
- **Cloud Load Balancing** handles traffic ramp to test backend scaling.
- Validate autoscalers (MIG, HPA) behave; capture metrics.
- Include realistic distributions (hot-spots, cache miss, error paths).

---

## 6. Caching hierarchy

```
Edge: Cloud CDN (HTML/JSON with TTL, signed URLs for private content)
Region: Memorystore (Redis / Memcached) for dynamic reads, sessions
Application: Local in-process cache with TTL (language-specific)
Database: BQ materialized views, Spanner read replicas, Cloud SQL replicas
```

---

## 7. Network tier choice

- **Premium tier**: traffic uses Google backbone end-to-end; better p99.
- **Standard tier**: uses public internet closer to client; cheaper, higher variance.
- Use **Premium** by default; **Standard** only for cost-tolerant regional systems.

---

## 8. Managed services performance knobs

| Service | Knob |
| --- | --- |
| Cloud Run | concurrency, CPU allocation, min instances |
| Cloud Functions 2nd gen | max concurrent requests, memory |
| App Engine Standard | instance class, min idle instances |
| GKE | HPA, VPA, cluster autoscaler, node auto-provisioning |
| Spanner | nodes / PUs; Data Boost for analytics |
| BigQuery | slots (editions), BI Engine, materialized views |
| Bigtable | nodes; SSD vs HDD; multi-cluster routing |
| Dataflow | autoscaling algorithm; max workers; Streaming Engine |
| Cloud SQL | tier; read replicas; maintenance window |

---

## 9. Specific performance exam patterns

| Scenario | Answer |
| --- | --- |
| "Slow cold starts on Cloud Run" | Set `--min-instances` > 0 |
| "BQ query scanning whole table" | Partition + cluster + require partition filter |
| "Bigtable hot node" | Redesign row key (hash prefix) |
| "Global app feels slow in Europe" | Add region; ensure Premium tier; CDN caching |
| "Spanner hotspot" | Interleave + avoid monotonic key |
| "App Engine cold start" | Warmup requests; min idle instances |
| "Dataflow backlog growing" | Increase max workers; Streaming Engine; bigger machine |

Next: `03-technical-processes.md`.
