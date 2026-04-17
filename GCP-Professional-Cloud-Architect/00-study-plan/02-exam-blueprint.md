# Exam Blueprint — What Google Tests

Google publishes an official exam guide for the PCA. The six domains below reflect the current blueprint (2024+). Every topic here is fair game.

---

## Domain 1 — Designing and planning a cloud solution architecture (~24%)

### 1.1 Designing a solution infrastructure that meets business requirements
- Business use cases and product strategy.
- Cost optimization: committed use, sustained use, rightsizing.
- Supporting application design.
- Integration with external systems.
- Movement of data.
- Build v. buy tradeoff.
- Success measurements: KPIs, OKRs, metrics.
- Compliance and observability.

### 1.2 Designing a solution infrastructure that meets technical requirements
- High availability and failover.
- Elasticity of capacity.
- Scalability to meet growth.
- Resilience of the architecture.

### 1.3 Designing network, storage, and compute resources
- Integration with on-prem: Interconnect (Dedicated / Partner), Cloud VPN (HA/classic).
- Regional v. multi-regional v. global.
- Multi-cloud considerations.
- Job processing types: batch, streaming.
- Storage systems by workload type.

### 1.4 Creating a migration plan
- Integrating with existing data center / third parties.
- Licensing (BYOL vs. PAYG).
- Network and management planning.
- Validation strategies.
- Business continuity and disaster recovery.

### 1.5 Envisioning future solution improvements
- Cloud / technology evolution.
- Evolution of business needs.
- Evangelism and adoption.

---

## Domain 2 — Managing and provisioning a solution infrastructure (~15%)

### 2.1 Configuring network topologies
- Hybrid networking; peerings; Shared VPC vs. peered VPC.
- Extending to on-prem / other clouds.
- Security protections (NGFW, firewall rules, hierarchical).
- Hybrid DNS: Cloud DNS with private zones, forwarding.

### 2.2 Configuring individual storage systems
- Data storage allocation and access patterns.
- Data processing/compute for data.
- Security and compliance (encryption at rest/in transit).
- SQL interface (ANSI) — BigQuery, Spanner, Cloud SQL.
- Storage and retrieval of unstructured data.
- Storage growth strategy.

### 2.3 Configuring compute systems
- Affinity (sole-tenant, node groups) for regulated workloads.
- Auto-scaling & autoscaler configurations.
- GPU/TPU provisioning.
- Managing required GCE / GKE resources.
- Container-based architecture: GKE, Cloud Run.

---

## Domain 3 — Designing for security and compliance (~18%)

### 3.1 Designing for security
- Identity: Cloud Identity, IAM, OIDC, SSO, SAML, 2FA, hardware keys.
- Resource hierarchy: org -> folder -> project -> resources, IAM inheritance.
- Data security: CMEK, CSEK, DLP, confidential computing.
- Separation of duties, least privilege.
- Security controls (e.g. firewall rules, VPC-SC, private Google access).
- Penetration testing considerations.

### 3.2 Designing for compliance
- Legislation (GDPR, HIPAA, CCPA, PCI-DSS).
- Commercial (sensitive data: PII, PHI, financial).
- Industry certs (ISO, SOC2/3, FedRAMP).
- Audit (Cloud Audit Logs, Access Transparency/Approval).

---

## Domain 4 — Analyzing and optimizing technical and business processes (~18%)

### 4.1 Analyzing and defining technical processes
- Software development lifecycle (SDLC) plans.
- CI/CD pipelines.
- Troubleshooting / root cause analysis best practices.
- Testing and validation of solutions.
- Service catalog & provisioning.
- Business continuity and disaster recovery.

### 4.2 Analyzing and defining business processes
- Stakeholder management (Dev / Ops / Security / Finance).
- Change management.
- Team assessment & skills readiness.
- Decision-making processes.
- Customer success management.
- Cost optimization / resource optimization (capex / opex).

### 4.3 Developing procedures to ensure reliability of solutions in production
- Chaos engineering.
- Penetration testing.
- Incident response & postmortems.

---

## Domain 5 — Managing implementation (~11%)

### 5.1 Advising development / operation teams to ensure success
- Applications and documentation updates.
- Performance testing.
- API best practices.
- Testing frameworks (load/unit/integration).
- Data and system migration / management tools.

### 5.2 Interacting with Google Cloud programmatically
- Provision resources: `gcloud`, Cloud SDK, Cloud Shell.
- Deploy repeatable infra: Terraform, Deployment Manager, Config Connector, Config Sync.
- Prebuilt solutions (Marketplace).
- Custom solutions (custom roles, Cloud Code, Cloud Functions).

---

## Domain 6 — Ensuring solution and operations reliability (~14%)

### 6.1 Monitoring / logging / profiling / alerting solution
- Cloud Monitoring, Logging, Trace, Profiler, Error Reporting.
- Golden signals, SLO/SLI, error budgets.

### 6.2 Deployment and release management
- Blue/green, canary, rolling, traffic splitting.
- GKE deployments, Cloud Run revisions, App Engine versions.

### 6.3 Assisting in the support of deployed solutions
- Root-cause investigation.
- Production runbooks.
- On-call rotation, paging.

### 6.4 Evaluating quality control measures
- Tests, reviews, code signing, policy checks.
- Binary Authorization, Artifact Analysis.

---

## Mapping exam topics to this repo

| Topic | Primary folder |
| --- | --- |
| Resource hierarchy, IAM, org policy | `03-domain-security-compliance/`, `07-service-deep-dives/16-iam-resource-manager.md` |
| Compute choice (GCE/GKE/Run/App Engine/Functions) | `07-service-deep-dives/01-04` |
| Networking: VPC, LB, Interconnect, DNS, NAT | `07-service-deep-dives/05-07`, `02-domain-manage-provision/` |
| Storage (GCS, PD, Filestore) | `07-service-deep-dives/08-09` |
| Databases (Cloud SQL, Spanner, Firestore, Bigtable) | `07-service-deep-dives/10-12` |
| Data & analytics (BigQuery, Dataflow, Dataproc, Pub/Sub) | `07-service-deep-dives/13-15` |
| Migration (VM Migration, DTS, DMS, Storage Transfer) | `01-domain-design-planning/06-migration-planning.md` |
| CI/CD (Cloud Build, Deploy, Artifact Registry, Binary Auth) | `05-domain-implementation/04-cicd-pipelines.md` |
| Monitoring / SRE | `06-domain-reliability/` |
| Case studies | `08-case-studies/` |

Next: `03-8-week-schedule.md`.
