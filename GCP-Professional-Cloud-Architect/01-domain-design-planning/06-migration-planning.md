# 1.4 Migration Planning

Migration questions appear on nearly every PCA exam. You must know the Google migration framework, the right tool for each workload, and how to size, sequence, and validate a move.

---

## 1. The 5-phase Google migration framework

Google's published framework ("Migration to Google Cloud" series):

1. **Assess** — inventory, dependency mapping, TCO analysis, categorize workloads.
2. **Plan** — landing zone design, network/IAM, training, migration waves.
3. **Deploy** (or **Migrate**) — actual move; choose rehost / replatform / refactor / rebuild / retire / retain.
4. **Optimize** — rightsize, cost tuning, automation, SRE adoption.
5. **Continuous improvement** — iterate, modernize further.

### The 7 R's (memorize)

| R | Definition | GCP example |
| --- | --- | --- |
| **Rehost** | Lift-and-shift | VMware → GCVE or VM → GCE via Migrate for Compute Engine |
| **Replatform** | Lift and slight shift | MySQL → Cloud SQL; App to App Engine Flex |
| **Refactor** | Change architecture | Monolith → microservices on GKE / Cloud Run |
| **Rebuild** | Rewrite from scratch | New Firestore + Cloud Run stack |
| **Repurchase** | Swap for SaaS | Exchange → Google Workspace; JIRA Cloud, etc. |
| **Retain** | Keep as-is (for now) | Mainframe stays on-prem |
| **Retire** | Decommission | Orphan apps / servers |

### Wave strategy

- Start with low-risk, low-dependency apps to build momentum.
- Move data-local apps after backend systems they depend on (or with them).
- Defer the "crown jewels" until you've proven the landing zone.

---

## 2. Assessment tools

- **Migration Center** (formerly CloudPhysics / StratoZone) — free discovery, dependency mapping, VM sizing, TCO.
- **Cloud Asset Inventory** — inventory of GCP assets (for already-in-cloud).
- **App Dynamics / Dynatrace / Datadog / CAST Highlight** — third-party for complex estates.
- **BigQuery for billing export** + Looker dashboards for cost baselining.

Outputs:

- Application portfolio (tier, tech stack, interdependencies).
- RTO/RPO per app.
- Licensing model (BYOL vs pay-as-you-go).
- Data gravity and compliance.

---

## 3. Landing zone

Before moving anything, build the landing zone:

- Organization node + Cloud Identity / Workspace domain.
- Folder hierarchy aligned to BUs / environments.
- Shared VPC host projects (prod / non-prod) or hub-and-spoke (NCC).
- IAM groups & role bindings via groups (not individuals).
- Org policies: `disableServiceAccountKeyCreation`, restrict `allowedServices`, restrict `allowedLocations`, `requireOsLogin`, etc.
- Logging: aggregated sink org-wide → BigQuery + GCS + Pub/Sub.
- Billing account structure (often 1 per BU for charge-back).
- Networking: Interconnect / VPN, DNS, firewall policies, egress design.
- Security baseline: SCC, VPC-SC perimeter, Binary Authorization.
- Deployment automation: Terraform foundation repo; CI via Cloud Build.

### Example folder structure

```
Org
├── fldr-common (shared services: DNS, secret mgmt, monitoring)
├── fldr-security (logs, SCC, SIEM)
├── fldr-network (host projects for Shared VPC)
├── fldr-prod
│   ├── bu-finance
│   ├── bu-retail
│   └── bu-hr
├── fldr-nonprod
└── fldr-sandbox (quota-limited, individual experiments)
```

---

## 4. Migration tools — what to use when

| Source | Target | Tool |
| --- | --- | --- |
| VMware / KVM / physical | GCE | **Migrate to Virtual Machines** (replication, cutover) |
| VMware as-is | **GCVE** | VMware HCX |
| Oracle / SAP HANA | **Bare Metal Solution** | partner tools + Netapp |
| MySQL / PG / SQL Server on-prem | Cloud SQL / AlloyDB | **Database Migration Service (DMS)** |
| Oracle CDC → BQ/GCS | analytics modernization | **Datastream** |
| SAP ECC | SAP on GCE | SAP Migration program |
| On-prem NFS/S3 | GCS | **Storage Transfer Service**; offline via **Transfer Appliance** |
| SaaS data (Google Ads, S3, Redshift) | BigQuery | **BQ Data Transfer Service** |
| VM → container | GKE/Run | **Migrate to Containers (M4C)** |
| Mainframe | GCP | **Dual Run / G4G** partner program; refactor with Apigee + MQs |
| AWS EC2 | GCE | Migrate to VMs or AWS VM Import + GCE import |

### Storage Transfer Service

- One-time or scheduled jobs.
- Supports S3, Azure Blob, HTTP(S), on-prem (via agent), GCS → GCS.
- Filtering by prefix / time / size.
- Preserve metadata; verifies checksums.

### Transfer Appliance

- TA7 (7 TB) / TA40 (40 TB) / TA300 (300 TB).
- Ship hardware; Google ingests into GCS; ~5–7 days end-to-end.
- Use when > ~60 TB or weeks to move via network.

---

## 5. Network planning for migration

- Sufficient bandwidth — rule of thumb: time = dataset / (usable bandwidth × 0.6). 60 TB over 1 Gbps = ~8 days at best-case usable throughput.
- Dedicated Interconnect for steady state; VPN during assess/plan.
- Avoid data egress surprises — plan private routing.
- Test before cutover (Connectivity Tests, Performance Dashboard).
- Consider **Cloud CDN** and **Global LB** at cutover for client traffic redirection.

---

## 6. Data migration strategies

### One-time cold move

- Feasible for small datasets (< 10 TB) and downtime-tolerant systems.
- Often via STS or pg_dump / mysqldump → Cloud SQL import.

### Online / near-zero downtime (CDC)

- Database Migration Service (supports continuous migration for MySQL, PG, SQL Server).
- Datastream for Oracle/MySQL/PG → BigQuery/GCS/Spanner.
- Partner tools (Striim, HVR, Qlik Replicate, Debezium).

### Blue-green cutover

- Mirror writes (dual-write) during cutover window.
- Run in parallel + validate with consistency checks before DNS flip.

### Rolling / phased

- Move tenants in waves; per-tenant switch.

### Validation

- Row counts, checksums (MD5, CRC32C), sampling, production-like workload replay.
- Latency / error rates compared to baseline.

---

## 7. Licensing and compliance

- **BYOL**: Microsoft Windows/SQL Server, Oracle — check license mobility (Windows requires Software Assurance for GCE).
- **PAYG**: Google supplies license cost baked into VM price.
- **Sole-tenant nodes** often required for certain BYOL compliance (Windows Server on-prem licensed via physical cores).
- **Compliance posture**: ensure target region satisfies data residency (use org policy `gcp.resourceLocations`).

---

## 8. Business continuity and DR

### DR tiers (industry)

| Tier | RPO | RTO | GCP pattern |
| --- | --- | --- | --- |
| Backup & restore | hours | hours/days | GCS + Snapshots + DMS |
| Pilot light | minutes | 1–2 h | DR region w/ Spanner, scripted VM startup |
| Warm standby | seconds–minutes | minutes | Active passive MIGs, replicated DBs |
| Hot / Multi-site | ~0 | ~0 | Active-active; Spanner multi-region, global LB |

### DR exam patterns

- "Weekly RPO is fine" → GCS + snapshots.
- "Business cannot tolerate > 1 hour data loss" → cross-region async replica + scripted failover.
- "Zero data loss, zero downtime" → Spanner multi-region or AlloyDB multi-region + global LB.

---

## 9. Cost model of migration

- **Sunk cost** of on-prem: licensed and hardware; compare 3-year TCO.
- Plan for **Egress** from on-prem (bandwidth) and during steady state (customer egress).
- Budget for **pro services** (partners, Google PSO, training).
- Expect **dual-run** period (both envs running) — include in TCO.
- Reservation & committed-use discount planning starts in the **plan** phase.

---

## 10. Typical exam distractors

| Distractor | Why wrong |
| --- | --- |
| "Use Transfer Appliance to move 500 GB nightly" | way overkill; use STS. |
| "Use Storage Transfer Service for PB over 3 days" | network bandwidth may not suffice; Transfer Appliance wins. |
| "Move Oracle to Cloud SQL" | Cloud SQL doesn't run Oracle. BMS, GCE, or refactor to Spanner/AlloyDB. |
| "Use DMS for Cassandra" | DMS covers MySQL/PG/SQL Server. Cassandra → self-managed or partner tools. |
| "Move 200 VMs by manual clone" | use Migrate to Virtual Machines. |
| "Lift-and-shift SAP HANA to GCE n2-standard-4" | SAP HANA needs certified memory-optimized or BMS. |

Next: `07-solution-design-patterns.md`.
