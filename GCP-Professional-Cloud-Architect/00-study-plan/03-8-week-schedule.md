# 8-Week Daily Schedule

A day-by-day plan assuming ~1.5 hours on weekdays and 3 hours on weekends. Scale time up or down to taste.

> Format: **Day — Topic — Primary reading — Practice**

---

## Week 1 — Foundations + Design Principles

| Day | Topic | Read | Practice |
| --- | --- | --- | --- |
| 1 | Exam mechanics + GCP global infra (regions, zones, multi-region) | `README.md`, `00-study-plan/` | 10 Q from `13-practice-exams/test-01.md` (Q1-Q10) |
| 2 | Resource hierarchy, org policies, projects, folders, labels | `07-service-deep-dives/16-iam-resource-manager.md` | `11-code-labs/01-gcloud-essentials.md` §1-3 |
| 3 | Identity & IAM basics; roles (primitive / predefined / custom) | `03-domain-security-compliance/01-iam-and-identity.md` | 15 flashcards from `09-flashcards/04-security-iam.md` |
| 4 | Networking 101: VPC, subnets, routes, firewall, MTU | `07-service-deep-dives/05-vpc-networking.md` §1-4 | lab: `11-code-labs/02-terraform-gcp.md` §VPC |
| 5 | Load balancers overview (global vs regional, L4/L7) | `07-service-deep-dives/06-cloud-load-balancing.md` | 15 Q mock |
| 6 | Design for HA/DR — basics | `01-domain-design-planning/07-solution-design-patterns.md` | Read EHR case study `08-case-studies/01-ehr-healthcare.md` |
| 7 | Review + weekly mock | `12-cheat-sheets/02-decision-trees.md` | Full 30-Q mini exam from `test-02.md` |

## Week 2 — Compute

| Day | Topic | Read | Practice |
| --- | --- | --- | --- |
| 8 | Compute Engine: MIGs, templates, autoscaling | `07-service-deep-dives/01-compute-engine.md` | Lab: create MIG via `gcloud` |
| 9 | GKE: clusters, node pools, autopilot | `07-service-deep-dives/02-gke-kubernetes.md` | Lab: Autopilot + deploy nginx |
| 10 | GKE: workloads, HPA, VPA, cluster autoscaler | continued | Flashcards: containers |
| 11 | Cloud Run + Functions (serverless containers / functions) | `07-service-deep-dives/03-cloud-run-functions.md` | Lab: deploy a Cloud Run service |
| 12 | App Engine Standard vs Flex | `07-service-deep-dives/04-app-engine.md` | 15 Q mock |
| 13 | Sole-tenant, preemptible/spot, committed use | `01-domain-design-planning/03-compute-architecture.md` | Read HRL case study |
| 14 | Weekly mock: compute-heavy | `test-03.md` | — |

## Week 3 — Storage & Databases

| Day | Topic | Read | Practice |
| --- | --- | --- | --- |
| 15 | Cloud Storage classes, lifecycle, versioning, retention | `07-service-deep-dives/08-cloud-storage.md` | Lab: lifecycle policy |
| 16 | Persistent Disks, Hyperdisk, Filestore | `07-service-deep-dives/09-persistent-disks-filestore.md` | Flashcards: storage |
| 17 | Cloud SQL (MySQL/PG/SQL Server), HA, read replicas | `07-service-deep-dives/10-cloud-sql.md` | Lab: create Cloud SQL HA instance |
| 18 | Spanner: architecture, TrueTime, multi-region | `07-service-deep-dives/11-cloud-spanner.md` | 15 Q mock |
| 19 | Firestore (native + datastore mode), Bigtable | `07-service-deep-dives/12-firestore-bigtable.md` | Flashcards: databases |
| 20 | Choosing the right database (decision tree) | `12-cheat-sheets/02-decision-trees.md` | Read Mountkirk case |
| 21 | Weekly mock | `test-04.md` | — |

## Week 4 — Networking & Domain 2

| Day | Topic | Read | Practice |
| --- | --- | --- | --- |
| 22 | Shared VPC, VPC Peering, Private Service Connect | `02-domain-manage-provision/03-networking-configuration.md` | Lab: Shared VPC |
| 23 | Interconnect (Dedicated / Partner), Cloud VPN (HA) | same | Flashcards: networking |
| 24 | Cloud NAT, Cloud DNS (public/private/split-horizon) | same | 15 Q mock |
| 25 | Cloud CDN, Cloud Armor (WAF), Edge security | `07-service-deep-dives/07-cloud-cdn-armor.md` | — |
| 26 | Load Balancer deep dive (external global L7, internal L4) | `07-service-deep-dives/06-cloud-load-balancing.md` | Lab: global HTTPS LB w/ Armor |
| 27 | VPC-SC, Private Google Access | `03-domain-security-compliance/03-network-security.md` | Read TerramEarth case |
| 28 | Weekly mock | `test-05.md` | — |

## Week 5 — Security & Compliance

| Day | Topic | Read | Practice |
| --- | --- | --- | --- |
| 29 | IAM deep dive: conditions, deny policies, IAM recommender | `03-domain-security-compliance/01-iam-and-identity.md` | Flashcards: security |
| 30 | Service accounts, Workload Identity, impersonation | same | Lab: Workload Identity on GKE |
| 31 | KMS (Cloud KMS), CMEK, EKM; Secret Manager | `07-service-deep-dives/17-kms-secret-manager.md` | 15 Q mock |
| 32 | Data loss prevention (DLP), Cloud HSM, Confidential VMs | `03-domain-security-compliance/02-data-security-encryption.md` | — |
| 33 | Compliance: HIPAA, PCI, GDPR, FedRAMP, ISO | `03-domain-security-compliance/04-compliance-frameworks.md` | Lab: org policies |
| 34 | Security Command Center, Event Threat Detection | `03-domain-security-compliance/05-security-operations.md` | 15 Q mock |
| 35 | Weekly mock | `test-06.md` | — |

## Week 6 — Data analytics & Domain 4

| Day | Topic | Read | Practice |
| --- | --- | --- | --- |
| 36 | BigQuery: storage, slots, partitions/clustering | `07-service-deep-dives/13-bigquery.md` | Lab: partitioned table |
| 37 | BigQuery: BI Engine, Omni, Storage API, governance | same | Flashcards: data |
| 38 | Dataflow (Apache Beam), templates, streaming | `07-service-deep-dives/14-dataflow-dataproc.md` | 15 Q mock |
| 39 | Dataproc, Cloud Composer (Airflow) | same | — |
| 40 | Pub/Sub, Eventarc, Cloud Scheduler | `07-service-deep-dives/15-pubsub-eventarc.md` | Lab: Pub/Sub + Dataflow streaming |
| 41 | Cost optimization + FinOps | `04-domain-analyze-optimize/01-cost-optimization.md` | Read all 4 case studies |
| 42 | Weekly mock | `test-07.md` | — |

## Week 7 — Implementation & CI/CD

| Day | Topic | Read | Practice |
| --- | --- | --- | --- |
| 43 | Cloud Build, Artifact Registry, Container Analysis | `05-domain-implementation/04-cicd-pipelines.md` | Lab: Cloud Build pipeline |
| 44 | Cloud Deploy, blue/green, canary | same | 15 Q mock |
| 45 | Binary Authorization, policy-as-code | `03-domain-security-compliance/05-security-operations.md` | — |
| 46 | Terraform on GCP + Config Connector | `11-code-labs/02-terraform-gcp.md` | Lab: multi-project landing zone |
| 47 | API design, Apigee / API Gateway | `05-domain-implementation/02-apis-integration.md` | Flashcards: impl |
| 48 | Migration tools (Migrate for CE, DMS, DTS, Storage Transfer) | `01-domain-design-planning/06-migration-planning.md` | 15 Q mock |
| 49 | Weekly mock | `test-08.md` | — |

## Week 8 — Reliability, Case Studies, Final Prep

| Day | Topic | Read | Practice |
| --- | --- | --- | --- |
| 50 | Cloud Operations suite deep dive | `07-service-deep-dives/18-cloud-ops-monitoring.md` | Lab: SLO + alerts |
| 51 | SRE: SLI/SLO/error budgets, golden signals | `06-domain-reliability/02-sre-principles.md` | Flashcards: ops |
| 52 | DR patterns (cold/warm/hot, backup/restore) | `06-domain-reliability/05-dr-and-ha.md` | — |
| 53 | Case study drill: EHR + HRL | `08-case-studies/` | `test-09.md` |
| 54 | Case study drill: Mountkirk + TerramEarth | `08-case-studies/` | `test-10.md` |
| 55 | Review all cheat sheets + missed questions | `12-cheat-sheets/` | — |
| 56 | Final full timed mock | `test-11.md` (60 Q, 2 hrs) | Rest |
| Exam | Light review of flashcards; sleep | — | — |

---

## Pacing rules

- **Never miss review day.** Spaced repetition > new content on Day 7 of each week.
- If you score < 70% on a weekly mock, **do not advance**; re-do that week's topic.
- In the final week, aim for ≥ 80% on mocks before scheduling the real exam.
