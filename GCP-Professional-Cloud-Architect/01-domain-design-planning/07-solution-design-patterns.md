# 1.5 Reference Solution Design Patterns

This chapter is a catalogue of the reference architectures the PCA tests most often. For each, we describe **when to use**, **component diagram**, and **why it wins on the exam**.

---

## 1. Global web application (user-facing)

**When:** SaaS with worldwide users, p95 < 200 ms, 99.99% SLA.

```
Users (global)
   │ DNS (Cloud DNS)
   ▼
Anycast VIP — Global External HTTPS LB
   │  └── Cloud Armor (WAF) + Cloud CDN + Managed Certs + IAP
   ▼
Regional backends (GKE Autopilot / Cloud Run / MIG)  (us-central1, europe-west1, asia-east1)
   │
Spanner multi-region (primary writes in nam-eur-asia1)
   │
BigQuery (analytics, async via Pub/Sub + Dataflow)
```

Why it wins:

- Global LB + CDN + Armor + IAP → answers about "DDoS / WAF / authentication at edge".
- Regional stateless backends + Spanner → strongly consistent + multi-region SLA.
- Pub/Sub for async events and decoupling.

---

## 2. Three-tier internal enterprise app

**When:** internal LOB, private-only, regional.

```
Employees (on-prem)
   │ HA VPN / Interconnect
   ▼
Shared VPC (service project) with private subnets
   ├── Internal HTTPS LB (IAP for employee SSO)
   │     └── GKE or MIG backends
   └── Cloud SQL HA (regional) with private IP (PSA) / Filestore
```

Why it wins:

- Private IP everywhere, no internet egress needed (Private Google Access).
- IAP for zero-trust access without VPN from employee laptops (BeyondCorp pattern).

---

## 3. Event-driven microservices

**When:** decouple producers from consumers, bursty load, serverless.

```
HTTP in → API Gateway / Apigee → Cloud Run (producer)
                                   │
                                   ▼
                              Pub/Sub topic
                                   │
                 ┌─────────────────┼────────────────────┐
                 ▼                 ▼                    ▼
          Cloud Run (worker)   Dataflow Streaming    Cloud Function
                 │                 │                    │
           Firestore          BigQuery              GCS / Pub/Sub DLQ
```

Why it wins:

- Pub/Sub isolates failure domains; DLQs for poison messages.
- Cloud Run scales-to-zero.
- Exactly-once with Dataflow; eventual consistency elsewhere.

---

## 4. Streaming data pipeline

**When:** IoT / telemetry, sensors, clickstream to BigQuery.

```
Devices/Clients → Pub/Sub → Dataflow (Apache Beam streaming)
                                 │        ├── window, enrich, aggregate
                                 ▼        ▼
                           BigQuery    Bigtable (hot)
                                       │
                            Looker dashboards
```

Why it wins:

- Pub/Sub = managed ingest with 7d retention.
- Dataflow autoscaling; Dataflow SQL / Streaming Engine.
- BigQuery streaming inserts or Storage Write API.
- Bigtable for sub-10ms lookups (monitoring apps).

---

## 5. Batch analytics lake + warehouse

**When:** nightly ETL, ML training data prep.

```
On-prem → Storage Transfer Service / Transfer Appliance → GCS (raw)
                                        │
                                        ▼
                                  Dataproc Serverless / Dataflow (ETL)
                                        │
                                        ▼
                                   GCS (curated, parquet)
                                        │
                                        ▼
                                    BigQuery (external + materialized)
                                        │
                                        ▼
                               Looker / Vertex AI
```

Optional: **Composer / Workflows** for orchestration.

---

## 6. Hybrid / multi-cloud with Anthos

**When:** regulatory or business reasons to run K8s across clouds or on-prem.

```
Control: Anthos Fleet + Config Management + Policy Controller
  ├── GKE on Google Cloud
  ├── GKE on AWS / Azure
  ├── GKE on VMware / Bare Metal
  └── GKE Connect to on-prem clusters

Data plane: Anthos Service Mesh (Istio) + Multi-Cluster Ingress / Gateway
Secrets: Secret Manager or external Vault
Observability: Cloud Monitoring + Logging (Ops Agent everywhere)
```

Why it wins: uniform policy, GitOps via Config Sync, mTLS across clusters.

---

## 7. Lift-and-shift landing zone

**When:** migrating hundreds of VMs quickly with minimal app changes.

```
On-prem → Dedicated Interconnect / HA VPN
Cloud org:
 ├── Host project: Shared VPC prod + non-prod
 ├── Service project per app: GCE MIGs running converted images (Migrate for VMs)
 ├── Cloud SQL or DMS for relational DBs
 ├── GCS for file shares, Filestore for NFS needs
 ├── Backup & DR Service for GCE + Cloud SQL backups
 └── Cloud Monitoring + Ops Agents on every VM
```

Why it wins: Google-preferred managed alternatives (Cloud SQL, Filestore) replace on-prem appliances; minimal code change.

---

## 8. Data processing with ML

**When:** real-time personalization, fraud detection.

```
Events → Pub/Sub → Dataflow (feature extraction) → Vertex AI Feature Store
                              │
                              ▼
                       Vertex AI endpoint (online prediction)
                              │
                              ▼
                       App (Cloud Run) reads prediction; writes to Firestore
```

Training:

- BigQuery → BigQuery ML (for tabular) or Vertex AI Workbench → Vertex AI Training.
- Vertex AI Pipelines orchestrate.

---

## 9. Gaming backend

**When:** Mountkirk-style game services.

```
Players → Global HTTPS LB + Cloud CDN
                        │
                        ▼
                  GKE Autopilot (matchmaking, chat, inventory) in 3 regions
                        │
                        ▼
         Spanner multi-region (player state)     Memorystore Redis (session, leaderboards)
                        │
                        ▼
           Pub/Sub → Dataflow → BigQuery (analytics)
                                    │
                                    ▼
                               Vertex AI (anti-cheat)
```

Key: Agones on GKE for dedicated game servers; fleet scaling; Cloud NAT for outbound.

---

## 10. IoT / Telemetry (TerramEarth-style)

**When:** millions of devices reporting data, need analytics + fleet command.

```
Device → Cloud IoT (deprecated 2023; replace with Pub/Sub + MQTT broker via Cloud Run / 3rd-party)
      → Pub/Sub (ingest)
         │
         ▼
     Dataflow streaming
         │
         ├── BigQuery (historical analytics)
         └── Bigtable (hot path, recent telemetry)
         │
         ▼
     Looker + Vertex AI + Apigee for external APIs
```

---

## 11. Regulated data platform (HIPAA / PCI)

```
External users → Cloud Armor → Apigee → Cloud Run (apps)
Internal data   → VPC-SC perimeter enforced on BQ, GCS, Pub/Sub
Data            → CMEK with Cloud KMS (or EKM) + DLP scanning
Secrets         → Secret Manager w/ VPC-SC
Identity        → Cloud Identity + SSO/SAML + hardware tokens; 2SV enforced
Access          → IAM Conditions (time, source, level) + Deny Policies
Audit           → Logs to BigQuery in locked project; Access Transparency / Approval
```

---

## 12. DR — warm standby

```
Primary region (us-central1):
  MIG app tier + Cloud SQL HA + GCS Standard
DR region (us-east1):
  Scale-to-0 MIG template (pre-provisioned), Cloud SQL cross-region replica (async)
  GCS dual-region bucket or Standard with nightly cross-region replication
Global LB:
  Failover group: primary backend + DR backend health-checked
DNS:
  Cloud DNS routing policy (active-passive) as secondary mechanism
Process:
  Promote replica; scale up DR MIG; update DNS if needed
```

---

## 13. CI/CD reference

```
Dev commits → Cloud Source Repos / GitHub → Cloud Build
   │          │
   │          ▼
   │      Artifact Registry (container + package)
   │          │
   │          ▼
   │      Binary Authorization (attestation)
   │          │
   │          ▼
   │      Cloud Deploy (blue/green, canary, rolling) → GKE / Cloud Run
   │
   └── Policy: Config Sync enforces cluster config (GitOps)
Observability:
   Cloud Monitoring + Error Reporting + Trace
```

---

## 14. Choose pattern by trigger phrase

| Phrase in case study | Pattern |
| --- | --- |
| "global low-latency users" | Pattern 1 |
| "internal employee LOB" | Pattern 2 |
| "microservices with queues" | Pattern 3 |
| "IoT streaming" | Pattern 4 / 10 |
| "data lake" / "data warehouse" | Pattern 5 |
| "on-prem and multi-cloud K8s" | Pattern 6 |
| "lift and shift 500 VMs" | Pattern 7 |
| "real-time ML recommendations" | Pattern 8 |
| "game players worldwide" | Pattern 9 |
| "HIPAA / PCI / PII" | Pattern 11 |
| "need DR with 1h RPO" | Pattern 12 |
| "automate deployments and policies" | Pattern 13 |

Next: Domain 2 (`02-domain-manage-provision/`).
