# 6.1 Monitoring, Logging, Tracing — the Cloud Operations Suite

Operational visibility is central to the PCA role. This chapter covers the full operations suite and how to wire it into real systems.

---

## 1. Components

| Component | Purpose |
| --- | --- |
| **Cloud Monitoring** | Metrics + dashboards + alerting + uptime checks + SLOs |
| **Cloud Logging** | Log ingestion, storage, exports, log-based metrics |
| **Cloud Trace** | Distributed tracing (OpenTelemetry-compatible) |
| **Cloud Profiler** | Continuous CPU & heap profiling |
| **Error Reporting** | Exception aggregation + alerting |
| **Managed Service for Prometheus** | Managed, long-retention Prometheus metrics |

All piped into a per-project workspace; you can add cross-project scopes via **metrics scope**.

---

## 2. Cloud Logging

- Default receivers: GCP services, Ops Agent (GCE + GKE), Fluent Bit.
- **Log buckets**: `_Default` (30-day default), `_Required` (admin activity; 400-day, free), custom buckets with retention up to 10y.
- **Log scopes**: groups of buckets for unified search.
- **Log router**:
  - **Sinks** to BigQuery, GCS, Pub/Sub, other log buckets (even in other projects/orgs).
  - **Aggregated sinks** at org level capture logs from all projects.
  - **Inclusion / exclusion filters** with CEL-like syntax.
- **Log-based metrics** (counter or distribution).
- **Data Access logs** must be explicitly enabled; very high volume if broad.

### Best practice sink pattern

1. Aggregated org sink → **Security logging project** → three destinations:
   - BigQuery dataset (90-365d) for analytics.
   - GCS bucket with retention policy + bucket lock for WORM.
   - Pub/Sub topic for SIEM ingestion.
2. Separate sinks for dev vs prod.
3. Retention for compliance logs: 7y (GCS), 90-365d (BQ).

---

## 3. Cloud Monitoring

- **Metrics**: Google-built metrics + user metrics + agent metrics + BigQuery + more.
- **Dashboards** (built-in + custom JSON/Terraform).
- **Alerting**: **Policies** with conditions + notification channels (Slack, PagerDuty, email, SMS, webhook).
- **Uptime checks**: HTTPS/TCP checks from multiple regions; alert on consecutive failures.
- **SLO & burn-rate alerts**: define SLI + SLO; Monitoring calculates budget; alert on fast/slow burn.
- **Service monitoring** for GKE/Cloud Run/App Engine/Istio: auto-detected services, golden signals.

### Typical alerts

- High 5xx rate (>1% for 5 min).
- Latency p95 > threshold.
- Error budget burn rate.
- Queue length (Pub/Sub backlog).
- Disk usage > 85%.
- CPU saturation.
- Autoscaler at max / failing to scale.
- VM instance down.
- Quota nearing limit.

---

## 4. Tracing

- **Cloud Trace** receives spans from OpenTelemetry (preferred), OpenCensus, X-Ray compat.
- **Trace analysis**: latency distribution, waterfall, compare releases.
- **Integrations**: Cloud Run / App Engine / GKE auto-propagate W3C `traceparent`.

---

## 5. Profiling

- Low-overhead continuous profiler for Go, Java, Node, Python, PHP, .NET.
- Build into your binary / image (agent library).
- Useful for spotting CPU / heap regressions release-over-release.

---

## 6. Ops Agent

- Unified agent for GCE + on-prem (via Ops Agent for AWS / Azure).
- Collects metrics + logs; replaces legacy Stackdriver agent + Fluentd.
- YAML-configured; supports 3rd-party integrations (NGINX, MySQL, JVM, etc.).

---

## 7. Managed Service for Prometheus (GMP)

- Fully managed Prometheus storage & query.
- Keeps PromQL compatibility.
- Integrates with Grafana; auto-scales ingest.
- Long retention (24 months) without managing Thanos/Mimir.

---

## 8. Wiring observability into services

### Cloud Run

- stdout/stderr auto-shipped to Logging.
- OpenTelemetry SDK for traces; Cloud Profiler agent optional.
- Metrics auto-captured (req latency, instance counts).

### GKE

- GKE workload logging/monitoring on by default.
- Optional Managed Prometheus.
- Anthos Service Mesh enables service-level SLO dashboards.

### GCE

- Install Ops Agent via startup script or fleet manager.
- VM inventory / OS patch reports in Console.

### Serverless (Functions)

- Auto logs + metrics; add OpenTelemetry for Trace.

---

## 9. Log retention & compliance

- `_Required` bucket: 400 days (Admin Activity + System Event), free, non-deletable.
- `_Default` bucket: 30 days default; change to up to 10 years.
- Export to GCS with retention policy & bucket lock for WORM.
- Enable **Log Analytics** (bucket upgraded) for SQL queries directly on logs.

---

## 10. Alerting strategy

- **SLO-based**: alerts tied to customer impact; avoid pager fatigue.
- **Fast/slow burn** burn-rate alerts (Google SRE book pattern):
  - 2% budget in 1h → page.
  - 10% budget in 6h → page.
  - Slow burn: 10% in 3d → ticket.
- **Golden signals**: latency, traffic, errors, saturation.
- **Synthetic** uptime checks for user-critical flows.

### Notification channels best practices

- Route by severity (pager vs ticket vs email).
- Use **runbooks** link in alert description.
- Escalation paths in PagerDuty/Opsgenie.

---

## 11. Cost of observability

- Log ingest billed per GB (Logging) — reduce via exclusion filters & structured logs with reasonable verbosity.
- Metric ingestion billed per 1000 points; custom metrics high cardinality is expensive.
- GMP has separate pricing; multi-month retention included.
- Export to BigQuery for cheaper long-term + ad-hoc analysis.

---

## 12. Observability exam patterns

| Scenario | Answer |
| --- | --- |
| "Store logs 7 years, immutable" | GCS sink + bucket lock + retention |
| "Query logs with SQL" | Log Analytics upgrade + BigQuery |
| "Detect unusual login activity" | Log-based metrics + SCC + Chronicle |
| "Multi-project unified dashboards" | Metrics scope across projects |
| "Prometheus retention beyond 2 weeks" | Managed Service for Prometheus |
| "Pager fatigue" | SLO burn-rate alerts, not static thresholds |
| "Trace a slow cross-service request" | OpenTelemetry + Cloud Trace |

Next: `02-sre-principles.md`.
