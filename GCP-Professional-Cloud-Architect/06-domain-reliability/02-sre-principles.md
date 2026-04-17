# 6.2 SRE Principles Applied to GCP

Google pioneered Site Reliability Engineering. The PCA expects you to speak fluent SRE: SLIs/SLOs, error budgets, toil reduction, blameless postmortems.

---

## 1. Why SRE

- Ops is software; automate toil.
- Reliability is a feature — with diminishing returns after SLO target.
- Error budgets balance velocity and stability.

---

## 2. SLI / SLO / SLA

- **SLI** (Indicator): measured, e.g., successful-request ratio, p95 latency.
- **SLO** (Objective): target for SLI over a window, e.g., 99.9% successful over 30d.
- **SLA** (Agreement): contractual commitment with consequences (refunds). Usually weaker than SLOs.
- Window: rolling 30d or 28d is typical; calendar windows for SLAs.

### Good SLIs

- Request success rate.
- Latency distribution (p50, p95, p99).
- Data freshness (ingest pipeline lag).
- Correctness (percentage of rows matching validation).
- Durability (rarely < 100%).

### SLO examples

- 99.95% of API requests succeed over 30d.
- p95 latency < 300 ms, 99% of the time.
- Pipeline freshness < 5 minutes, 99.5% of the time.

---

## 3. Error budget

`Error budget = 1 - SLO target`. If SLO is 99.9% → 0.1% of requests can fail monthly.

- When budget is healthy → ship features, experiment.
- When burn is high → freeze feature work; fix reliability.
- Engineers, product, and ops agree in advance on the policy.

### Burn-rate alerting

Two alerting thresholds:

- **Fast burn**: 2% budget in 1 hour → page.
- **Slow burn**: 10% budget in 3 days → ticket.

GCP Monitoring's **Service Monitoring** calculates this automatically once SLOs are defined.

---

## 4. Toil reduction

- Toil: manual, repetitive, scalable-with-service work.
- Budget < 50% of SRE time to toil.
- Reduce by:
  - Automation (Terraform, Cloud Build, runbook-as-code).
  - Self-healing (MIG autohealer, k8s probes, liveness).
  - Feature flags, canary deploys with auto-rollback.
  - Chatops (Slack bots for common tasks).

---

## 5. Incident management

- **On-call rotation** with primary + secondary.
- **Incident commander** orchestrates; dedicated Slack/IRC channel.
- Structured severity levels (SEV1–SEV4).
- Public status page (statuspage.io, Firebase Hosting, etc.).
- **Postmortem**: blameless, timeline, action items, shared widely.

---

## 6. Reliability patterns

- **Bulkheads**: isolate tenants/dependencies.
- **Timeouts + retries + jitter + max attempts**.
- **Circuit breakers**: stop hammering a failing dependency.
- **Graceful degradation**: serve cache, read-only, simpler UI.
- **Load shedding**: drop low-priority requests under load.
- **Backpressure**: queue + rate limit upstream.
- **Idempotency keys** for POST.
- **Exponential backoff** for retries.

---

## 7. Release reliability

- Canary with automatic rollback on SLO violation (Cloud Deploy + Monitoring).
- Progressive delivery (5 → 25 → 50 → 100%).
- Feature flags decouple deploy from release.
- Dark launches to mirror load.
- Clear rollback plans.

---

## 8. Capacity planning

- Forecast demand (seasonality, growth).
- Pre-scale before peak (autoscaler + `--min-num-replicas`).
- Reserve capacity in critical regions (GCE reservations, Spanner nodes).
- Quota increases approved ahead of peak.

---

## 9. Chaos engineering

- Purposeful fault injection.
- Tools: Chaos Mesh (GKE), Gremlin, Litmus.
- Scenarios: node drain, network latency, zone outage, dependency failure.
- Scope to staging first, then production game-days.

---

## 10. Observability for SRE

- **RED method** (services): Rate, Errors, Duration.
- **USE method** (resources): Utilization, Saturation, Errors.
- **Four golden signals**: latency, traffic, errors, saturation.
- Mean isn't enough — use percentiles (p50/p95/p99/p99.9) + histograms.

---

## 11. Organizational model

- SRE teams embedded or centralized.
- Shared on-call with dev teams (you build it, you run it — with SRE consult).
- SRE team right to *hand back* services that consistently exceed error budget.

---

## 12. SRE exam patterns

| Scenario | Answer |
| --- | --- |
| "Reduce pages that don't impact users" | Adopt SLO burn-rate alerts |
| "Stop rolling out features" | Error budget policy triggers freeze |
| "Reduce manual toil" | Automate via runbook-as-code / self-service platform |
| "Blameless culture" | Blameless postmortems with action items |
| "Pre-release risk reduction" | Canary + feature flags + auto-rollback |
| "Continuous reliability testing" | Chaos engineering game days |

Next: `03-deployment-strategies.md`.
