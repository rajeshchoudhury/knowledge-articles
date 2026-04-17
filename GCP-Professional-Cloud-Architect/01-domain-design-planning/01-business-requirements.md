# 1.1 Translating Business Requirements into Cloud Architecture

The PCA exam starts where real architecture starts: with business. You will get case studies and questions that force you to pick technical designs **that trace back to stated business outcomes**. You must be fluent in translating "the business says X" into "we will build Y."

---

## 1. Taxonomy of business requirements

| Category | Typical question | Implication on GCP design |
| --- | --- | --- |
| **Strategic** | "We want to enter 3 new geographies in 12 months." | Pick global services (Spanner, Cloud CDN, global HTTPS LB). |
| **Financial** | "Reduce infra spend by 30%." | CUDs, sustained-use, rightsizing, autoscaling, spot/preemptible. |
| **Regulatory** | "Data must remain in the EU." | Regional storage locations, org policy `gcp.resourceLocations`, VPC-SC. |
| **Operational** | "Reduce release lead time to hours." | CI/CD (Cloud Build + Deploy), GitOps, feature flags. |
| **Customer** | "99.99% SLA for paid customers." | Multi-region active/active, Spanner, global LB, DR plan. |
| **Organizational** | "We have 300 engineers across 5 BUs." | Landing zone (folders, Shared VPC, billing accounts per BU). |
| **Time-to-market** | "Launch in 6 weeks." | Managed services over DIY, App Engine / Cloud Run, Marketplace solutions. |

### The "requirements triangle"

```
         Time to market
             /\
            /  \
           /    \
          /      \
         /________\
Cost              Scope/Quality
```

You can pick any two. The case studies will imply the winner. E.g., EHR Healthcare = quality/compliance-first, Mountkirk Games = scalability/time-to-market.

---

## 2. Reading a case study

Every case study in the PCA follows the same structure:

1. **Company overview** — size, industry, revenue.
2. **Solution concept** — what they want to do.
3. **Existing technical environment** — what they have.
4. **Business requirements** — 5–10 bullets, usually strategic/commercial.
5. **Technical requirements** — specific non-functional limits (SLA, RPO, scale).
6. **Executive statement** — one paragraph from a CTO/CEO; pick up tone.

**Technique:** For each case study, build a **requirements matrix**:

| ID | Requirement | Category | GCP service(s) likely needed | Traps |
| -- | --- | --- | --- | --- |
| B1 | Global user base | Strategic | Global LB, Cloud CDN, Spanner | Don't pick regional-only answers |
| T3 | RPO 1 min / RTO 5 min | Technical | Spanner multi-region, HA Cloud SQL with cross-region replica | Don't propose nightly GCS backup |

Do this for each of the 4 case studies (we provide filled-in matrices in `08-case-studies/`).

---

## 3. Build vs. buy vs. managed

On PCA the **managed answer** is almost always right unless a stated constraint forbids it.

| Need | DIY on GCE | Managed GCP | Typical PCA answer |
| --- | --- | --- | --- |
| Relational DB | MySQL on GCE + replication | Cloud SQL HA | Cloud SQL |
| Global DB | Galera cluster | Spanner | Spanner |
| Analytics warehouse | Hadoop on Dataproc persistent cluster | BigQuery | BigQuery |
| Stream pipeline | Kafka on GCE | Pub/Sub + Dataflow | Pub/Sub + Dataflow |
| Kubernetes | self-managed | GKE (Autopilot) | GKE Autopilot unless portability > operational burden |
| CI | Jenkins on GCE | Cloud Build | Cloud Build |
| Secrets | HashiCorp Vault on GCE | Secret Manager | Secret Manager (unless multi-cloud vault mandate) |

### When buy / SaaS wins

- Commodity, non-differentiating workload (email, CRM, SSO directory).
- Strict vendor certifications (HIPAA BAA, PCI) the team can't maintain.
- Time-to-market constraint dominates cost.

### When DIY wins

- Unique workload (e.g., very custom legal-hold).
- Portability requirement (multi-cloud or on-prem parity).
- Regulatory rule prohibits use of specific managed services.

---

## 4. Cost and KPIs

### Financial metrics often referenced

- **TCO** — total cost of ownership over 3–5 years.
- **Unit economics** — cost per request / user / transaction.
- **Capex → Opex** — consumption shifts; procurement no longer up-front.
- **Budget burn rate** — monitor with Cloud Billing budgets and alerts.

### KPIs to tie a design to

- Throughput (rps), latency (p50/p95/p99).
- Availability (SLA %, error budget).
- MTTR, MTBF, change failure rate (DORA metrics).
- Deployment frequency, lead time for changes.
- Cost per 1K requests.

### Pricing levers on GCP

- **Sustained-use discounts** — automatic on GCE.
- **Committed-use discounts** — 1 or 3 years, resource-based (vCPU/RAM) or spend-based (Cloud SQL, GKE).
- **Spot / preemptible VMs** — 60–91% off; interruptible.
- **Cold storage** — Coldline, Archive for infrequent access.
- **BigQuery editions/slots** vs on-demand for predictable workloads.
- **Rightsizing recommendations** (Active Assist).
- **Idle resource cleanup** (unused disks, idle Cloud SQL replicas, unattached external IPs).

---

## 5. Integration with external systems

Most enterprise workloads don't live alone. Expect questions about:

- **On-prem ERP/HR/CRM** → Interconnect / VPN, Apigee / API Gateway, Dataflow CDC from JDBC.
- **Third-party SaaS** → HTTPS over internet with IAP / VPC-SC; or Private Service Connect for supported partners; or Apigee for consumer exposure.
- **Partner networks** → Partner Interconnect, Dedicated Interconnect, Cloud Interconnect-VLAN attachments.

### Preferred pattern for B2B APIs

- **Cloud Load Balancer + Cloud Armor** (DDoS/WAF) at the edge.
- **Apigee** for partner façade, quotas, monetization, mediation.
- **Cloud Endpoints / API Gateway** for simpler gRPC/REST and ESPv2.
- **Backend:** Cloud Run / GKE / Functions.
- **Auth:** Identity Platform or Cloud Identity + OAuth/JWT.

---

## 6. Observability and governance baked in

Non-functional business requirements often demand:

- Audit trail — Cloud Audit Logs (Admin Activity, Data Access, System Event, Policy Denied).
- Policy — Organization Policies (e.g., restrict service usage, require OS login, deny external IPs).
- Monitoring — Cloud Monitoring, Logging sinks to BigQuery / GCS for long-term retention.
- Cost governance — billing export to BigQuery, labels taxonomy, budgets per project.

**Design tip:** bake these in on day 1. Retrofitting a landing zone is painful and is usually a wrong answer to questions like "how should we migrate 500 VMs?".

---

## 7. A reusable business-to-technical mapping worksheet

When you see a new case study or question, quickly fill this out mentally:

```
1. Who are the users? Where are they? How many?
2. What is the SLA and error budget?
3. What is the RPO / RTO?
4. Where must data live (compliance)?
5. How is cost bounded? Who owns billing?
6. Who are the stakeholders (dev, sec, finance, BU leads)?
7. Build, buy, or borrow?
8. Greenfield or migration? What's the target state?
9. Single or multi-region? Multi-cloud? Hybrid?
10. Time-to-market vs. perfection?
```

Answering these 10 points aloud before picking an option on exam eliminates 70% of "bait" answers.

Next: `02-technical-requirements.md`.
