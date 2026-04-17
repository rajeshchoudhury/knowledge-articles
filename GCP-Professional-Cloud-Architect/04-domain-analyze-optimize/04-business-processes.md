# 4.4 Business Processes — Stakeholders, Change, Skills, Success

Non-technical questions appear on the PCA. You must align architecture decisions with people and processes.

---

## 1. Stakeholders and responsibilities

| Stakeholder | Cares about | Typical asks |
| --- | --- | --- |
| **CEO / CTO** | Business outcomes, time-to-market, risk | ROI, 3-yr TCO, competitive differentiation |
| **CISO / Security** | Risk, compliance, incident containment | IAM, VPC-SC, audit logs, CMEK |
| **CFO / FinOps** | Cost predictability, unit economics | Budgets, CUDs, chargeback |
| **VP Eng / Dev** | Velocity, developer experience | CI/CD, managed services, IDE integration |
| **SRE / Ops** | Reliability, toil reduction | SLOs, automation, observability |
| **Data / BI** | Analytics, governance | BigQuery, Looker, Dataplex |
| **Legal / Privacy** | GDPR, contracts, residency | DPIAs, Assured Workloads, BAAs |
| **BU leaders** | Delivery of features, customer success | Roadmap alignment |

### RACI mental model

- Responsible / Accountable / Consulted / Informed.
- The architect often **accountable** for design; **responsible** for authoring key decisions; **consulted** on anything cross-cutting.

---

## 2. Change management

- **Prosci ADKAR** framework: Awareness, Desire, Knowledge, Ability, Reinforcement.
- Communicate *why* before *what*.
- Run design reviews with stakeholders; capture ADRs.
- Maintain a backlog of improvements tied to KPIs.

### GCP-specific change governance

- Deploy via GitOps → PR approvals.
- Org policies + org-level guardrails.
- Change advisory board (CAB) for org-wide changes (network, IAM).

---

## 3. Team assessment and skills readiness

- **Skills matrix**: each team member rated on GCP services they need.
- Ramp plans: Google Cloud Skills Boost paths; certifications (ACE, PCA, PCNE, PDE, PCSE).
- Pair programming; internal architecture council.
- **Cloud Center of Excellence (CCoE)** or **Cloud Architecture Team** to set patterns, review designs.

### Adoption maturity model

1. **Tactical** — individual projects experiment.
2. **Strategic** — central patterns emerge.
3. **Transformational** — entire org on GCP with CCoE and SRE.

---

## 4. Decision-making

- **Architecture Decision Records (ADR)**: context, decision, consequences.
- **Trade-off analysis**: capture constraints; list options; score against criteria.
- **Risk register**: architecture risks with owners and mitigations.
- **Working backwards** (Amazon-inspired): write the press release first.

---

## 5. Customer success

- Define **success metrics** (NPS, feature adoption, uptime).
- Instrument product analytics (GA4, Firebase Analytics) + customer funnels.
- Run **quarterly business reviews** with internal stakeholders.
- Maintain a **support tier** mapping; route incidents.

---

## 6. Cost governance processes

- **FinOps cadence**: monthly cost reviews; quarterly commitment planning.
- **Showback/chargeback** via billing labels.
- **Budgets & alerts** with thresholds.
- **Recommenders** (Active Assist) integrated into monthly reviews.
- **Forecasting** with billing export → BQ → Looker + ML model.

---

## 7. Vendor and partner management

- **Google Cloud Partner Advantage**: services partners (Accenture, Deloitte, Wipro, etc.).
- **SaaS on GCP Marketplace**: procurement through Google; counts toward commitment.
- **Mandiant** (Google-owned) for security services.

---

## 8. Procurement & contracts

- Enterprise Agreement with committed spend discount.
- Data Processing Addendum (DPA) / Business Associate Agreement (BAA).
- Service-specific terms for Assured Workloads, Apigee, Chronicle.
- Professional Services Statement of Work for migration projects.

---

## 9. Cloud governance structure

Recommended pattern:

```
Cloud Governance Board (CTO, CISO, CFO rep)
   ├── Cloud CoE (architects, platform eng, security eng)
   │     ├── Landing zone & org policy
   │     ├── Shared services (DNS, IAM, logging)
   │     └── Reusable Terraform modules
   ├── Business Units with service projects
   └── FinOps team (reports to CFO)
```

---

## 10. Business process exam patterns

| Scenario | Answer |
| --- | --- |
| "Central team vets designs, BUs build" | CCoE + Private Marketplace |
| "Finance wants per-team cost visibility" | Labels + billing export + Looker dashboards |
| "Dev team wants approved stacks" | Private Service Catalog / published Terraform modules |
| "Migrate 500 apps with limited staff" | Engage Google PSO + partner; phased waves |
| "Executive wants risk summary" | SCC Premium + policy compliance dashboards |
| "Measure DevOps maturity" | DORA metrics via Cloud Build / Cloud Deploy telemetry |

Next: `05-domain-implementation/`.
