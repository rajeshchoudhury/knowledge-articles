# 4.1 Cost Optimization and FinOps

Cost questions appear on every PCA exam. You must know the discount models, rightsizing practices, and service-specific tricks.

---

## 1. Pricing fundamentals

- **On-demand**: full list price.
- **Sustained Use Discounts (SUD)**: automatic, up to 30% for GCE instances running ≥25% of the month.
- **Committed Use Discounts (CUD)**: 1y / 3y; choose **resource-based** (vCPU + RAM) or **spend-based** (for Cloud SQL, GKE, Dataflow, VMware Engine, etc.).
- **Spot VMs (preemptible)**: 60–91% off GCE. 30s termination notice; fault-tolerant workloads.
- **Free tier**: $300 credit for 90 days; always-free eligibility (e.g., 1 e2-micro VM in us-central1/east1/west1).
- **Reservations**: guarantee capacity; can be combined with CUD for discount coverage.
- **Flex committed use discounts** (newer): cross-region, cross-family within same "class" for flexibility.

### Discount stacking

- SUD auto-applies on top of on-demand.
- CUD replaces SUD when applicable.
- Spot is a separate SKU (no SUD/CUD needed).
- Reservations stack with CUD — you pay for reserved capacity, CUD covers the pricing discount.

---

## 2. Rightsizing

- **GCE rightsizing recommendations** (Active Assist) flag under-utilized VMs.
- Use **custom machine types** (custom vCPU + RAM) when predefined shapes waste capacity.
- For GKE: **Vertical Pod Autoscaler** in recommendation mode; set requests correctly.
- For Cloud SQL: pick smallest tier that handles peak + safety margin; use read replicas instead of oversized primary.
- For BigQuery: switch from on-demand to Editions with autoscaler when queries exceed threshold.

---

## 3. Storage cost optimization

### Cloud Storage

- **Autoclass** for unpredictable access patterns; otherwise lifecycle rules.
- Remove noncurrent versions after N days.
- Delete incomplete multipart uploads.
- Use **composite objects** to avoid re-upload.
- For dual-region: only if RPO demands; it's ~2× standard.
- **Egress**: keep data close to consumers; same-region egress to same-region services is free.

### Block storage

- Use **PD Balanced** instead of PD-SSD when IOPS isn't needed.
- Snapshots are incremental; remove old machine images.
- Attach persistent disks at required size only; resize later.

### Databases

- **BigQuery storage**: long-term (90-day untouched) storage is ~half price automatically.
- Cloud SQL: enable storage auto-grow but alert on large growth.
- Spanner: **processing units** (100 PU chunks) for lower baseline cost vs full node.
- Bigtable: monitor node utilization; right-size clusters; multi-cluster routing can avoid over-provisioning for HA.

---

## 4. Compute cost optimization

### GCE

- Mix instance families (E2 for general, N2 for balanced, Tau T2D for Arm/price-perf).
- Spot for batch, CI runners, data processing.
- **MIG autoscaling** with schedule + CPU + queue signals.
- **Delete idle VMs**: Active Assist recommendations.

### GKE

- **Autopilot** charges per pod; no wasted node capacity.
- Standard + Spot node pools for stateless workloads.
- Node auto-provisioning to create pools on demand.
- Cluster autoscaler for scale-down.

### Serverless

- Cloud Run scale-to-zero; pay per 100 ms of CPU + request time.
- Cloud Functions 2nd gen / Cloud Run Jobs for batch.
- App Engine Standard for low-traffic legacy.

---

## 5. Networking cost optimization

- **Egress** is the primary driver.
- Prefer **same-region** consumption.
- Cloud CDN caches reduce egress from origin.
- **Private Service Connect / Peering** for intra-cloud — avoid public egress.
- Use **Cloud Interconnect** over VPN for steady egress >2 Gbps (lower $/GB for Interconnect egress).
- Turn off unused **forwarding rules**, external IPs, NAT gateways when not needed.
- **Premium vs Standard Tier**: Standard cheaper, region-local path — don't use for global apps.

---

## 6. Data & analytics cost optimization

### BigQuery

- Pick mode: on-demand (per TB scanned) vs Editions.
- Always **partition + cluster**.
- Use **require partition filter**.
- Don't `SELECT *` — specify columns.
- Materialized views for hot aggregates.
- Use **BI Engine** for dashboards (capacity-based; cheaper per query).
- **Slot commitments** (annual) for predictable workloads; autoscaler for overflow.
- **Flat-rate reservations** (Editions) + **Enterprise Plus** for CMEK + multi-region replication if needed.

### Dataflow

- Streaming Engine + Shuffle Service shift compute from workers, often cheaper.
- Use FlexRS + spot for batch.
- Autoscale with caps.

### Dataproc

- **Ephemeral** clusters per job; preemptible workers.
- **Serverless Spark** for cheapest option.

---

## 7. Billing and cost monitoring

- **Billing export to BigQuery** (standard + detailed + pricing).
- Build dashboards with Looker / Looker Studio (or `gcloud billing budgets`).
- **Budgets & alerts** per project/folder/label; threshold alerts at 50/90/100%.
- **Cost Recommender** via Active Assist.
- **Label taxonomy**: env, app, owner, cost_center, project_code.

### Cost reports and FinOps cadence

- Monthly cost review with each BU.
- Track unit economics (cost / active user, cost / transaction).
- Chargeback or showback based on labels + billing export.
- Use **Committed Use Discount utilization reports**.

---

## 8. Commitment and reservation planning

### Steps

1. Analyze 30–60 days of usage per region / family from billing export.
2. Buy CUD for baseline steady-state (50–70% coverage typical).
3. Use reservations for workloads that need capacity guarantees.
4. Keep remainder on-demand / spot for elasticity.

### Pitfalls

- Over-commit → unused discounts expire.
- Single-family commit when workloads shift families → under-used.
- Not tracking commitment end dates.

Use **Flex CUD** for flexibility when mix changes.

---

## 9. Development / non-prod savings

- Use **Cloud Workstations** or **Cloud Shell** to avoid idle dev VMs.
- Lower-tier Cloud SQL / Spanner in non-prod.
- Schedule dev envs to stop at night (Cloud Scheduler + Cloud Functions).
- Quota limits on sandboxes.
- Preemptible GKE node pools for CI/CD.

---

## 10. Cost exam patterns

| Scenario | Correct answer |
| --- | --- |
| "Steady 24/7 GCE usage" | CUD 1y or 3y |
| "Workload OK to be preempted" | Spot VMs |
| "BQ queries unpredictable small" | On-demand |
| "BQ queries predictable heavy" | Editions + slot commitment + autoscaler |
| "Cold data kept 2 years" | GCS Coldline/Archive with lifecycle |
| "Same app runs in dev 8h/day" | Cloud Scheduler stop/start + Spot VMs |
| "Reduce cross-region egress" | Move consumers/producers same region, CDN, Interconnect for hybrid |
| "Identify idle VMs" | Active Assist recommender |
| "Forecast next month bill" | Billing export to BQ + Looker |

Next: `02-performance-optimization.md`.
