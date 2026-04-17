# 1.3a Designing Compute Architecture

GCP offers five main compute platforms. Passing PCA means picking the right one given constraints, and justifying it.

```
                       More abstraction / less ops
   GCE  →  GKE (standard) → GKE (Autopilot) → Cloud Run → Cloud Functions
   ←        ←                ←                 ←           ←   less control
```

---

## 1. The compute decision tree

```
Is it a legacy/3rd-party VM image or needs kernel-level access?
├── Yes → Compute Engine (GCE)
└── No → Is it containerized?
        ├── Yes → Is it a stateless HTTP service?
        │        ├── Yes → Cloud Run
        │        └── No  → Long-lived / complex / sidecars? → GKE (Autopilot preferred, Standard if you need node-level control)
        └── No → Is it an event-triggered function?
                 ├── Yes (short, single-purpose) → Cloud Functions (2nd gen)
                 └── No → Is it a web app in a supported runtime?
                          ├── Yes → App Engine Standard (scale-to-zero) or Flex
                          └── No  → Go back up the tree
```

### Additional filters

- **Cost / scale-to-zero** required → Cloud Run, Cloud Functions, App Engine Standard.
- **Strict CPU/GPU/TPU topology** → GCE + sole-tenant or GKE with node pools.
- **Licensed OS (Oracle)** → **Bare Metal Solution** or GCE with BYOL.
- **Windows workloads** → GCE or GKE Windows node pools.

---

## 2. Compute Engine (GCE)

- **Instance types:** N-series (general), C3 (latest Intel general), C3D (AMD), T2A/T2D (Arm, Tau), E2 (cost-optimized), N2D, M-series (memory-optimized), A-series (GPU).
- **Machine shapes:** predefined and custom (vCPU + memory).
- **Sole-tenant nodes:** dedicate physical host (compliance, licensing).
- **Preemptible / Spot VMs:** 60–91% cheaper; max 24h preemptible, no time limit spot; 30s notice.
- **Live migration:** GCE automatically migrates between hosts during maintenance.
- **Local SSDs:** ephemeral NVMe, attached per VM.
- **Persistent Disks:** block storage; zonal or regional (sync replication across 2 zones).

### Managed Instance Groups (MIGs)

- Template-based; stateless or stateful (preserves names/disks).
- **Zonal** (one zone) or **regional** (spans 3 zones; preferred for HA).
- **Autoscaling signals:** CPU, HTTP LB serving capacity (RPS/util), Pub/Sub queue length, custom monitoring metrics, schedule.
- **Autohealing:** health check re-creates failed instances.
- **Surge/max-unavailable** for rolling updates; **canary** via second MIG + traffic split on LB.

### When to pick GCE

- Non-containerized legacy apps.
- Custom kernel modules, custom OS images.
- Bare-metal-like workloads where you need full root access.
- Windows / specialized licenses.
- HPC with specific CPU features, GPUs, TPUs.
- Sole-tenant for compliance isolation.

### When NOT to pick GCE

- Simple web APIs (use Cloud Run).
- Multi-tenant SaaS with containerized microservices (use GKE).
- Short event triggers (use Functions).

---

## 3. Google Kubernetes Engine (GKE)

### Modes

- **Autopilot:** Google manages nodes, security, upgrades. Pay per pod. Ideal default.
- **Standard:** You manage node pools, but control plane is managed. Needed for DaemonSets on nodes, custom kernel tweaks, certain networking configs.

### Key features

- **Regional clusters** → control plane and nodes across 3 zones (HA). SLA 99.95%.
- **Private clusters** → nodes have no public IPs; control plane access via private endpoint or authorized networks.
- **Workload Identity** → map KSA → GSA. Recommended; no static keys.
- **Config Connector** → manage GCP resources via K8s manifests.
- **Anthos Service Mesh (ASM)** → Istio-based mesh; mTLS, traffic policies, SLOs.
- **Binary Authorization** → only signed images can deploy.
- **Shielded nodes** / **sandbox nodes (gVisor)** for stronger isolation.

### Autoscalers

| Autoscaler | Scales | Trigger |
| --- | --- | --- |
| HPA | pod replicas | CPU / memory / custom metric |
| VPA | pod resources (requests/limits) | usage history |
| Cluster autoscaler | nodes within pool | pending pods |
| Node auto-provisioning | creates new node pools | workload requirements (GPUs, taints) |

*Do not combine HPA + VPA on same metric (conflict); use HPA on CPU + VPA on memory, or VPA in recommendation mode.*

### Workload patterns

- **Stateless microservices** — Deployment + HPA + Service + Ingress (GKE Ingress = Global L7 LB; Gateway API is newer).
- **Stateful** — StatefulSet + PVC (PD/Filestore) or managed DB.
- **Batch** — Jobs / CronJobs; use spot/preemptible node pools with taints/tolerations.
- **AI/ML** — GPU node pools; consider Vertex AI managed.

### When to pick GKE

- Microservices, polyglot.
- Portable across cloud / on-prem (Anthos, Anthos on AWS, Anthos on Azure).
- Requires sidecars (Envoy, telemetry), operators, CRDs.
- Complex stateful workloads (operators for Postgres, Cassandra).

---

## 4. Cloud Run

- Runs **any container** accepting HTTP/gRPC on a port.
- **Scales from 0 to N** concurrently (default concurrency 80, configurable 1–1000).
- **Fully managed** or **Cloud Run for Anthos** (on GKE).
- **Jobs** (not services) for batch-style containers.
- **CPU always allocated** option for background work; otherwise CPU allocated during requests only.
- **Max request timeout**: 60 minutes (services); jobs have longer.
- **Startup probes / liveness probes** supported.
- **Cloud Run Functions** (GA 2024) merges 2nd-gen Cloud Functions into Cloud Run.

### When to pick Cloud Run

- Stateless HTTP/gRPC APIs.
- Spiky traffic, want scale-to-zero.
- Simple microservices without k8s overhead.
- Pub/Sub push targets, Eventarc targets.

### When NOT

- Need long-running processes > 60 min (use GKE or GCE).
- Need TCP/UDP non-HTTP (use GKE).
- Need deep node-level customization.

---

## 5. App Engine

### Standard

- Sandboxed runtimes (Python, Java, Go, Node, Ruby, PHP, .NET).
- Scale-to-zero, automatic scaling, sub-second cold starts in some runtimes.
- Great for "classic webapp" feel; versions + traffic splitting built-in.

### Flexible

- Runs Docker containers on GCE VMs.
- Min 1 instance (no scale-to-zero), but no runtime restrictions.
- Often replaced in modern architectures by Cloud Run.

### When App Engine still appears on exam

- Case study says "existing App Engine app"; you don't typically migrate away on the exam.
- Rapid prototyping with scale-to-zero and multi-version traffic split.
- Integrated Memcache, task queues (now Cloud Tasks).

---

## 6. Cloud Functions (2nd gen)

- 2nd gen is built on Cloud Run + Eventarc.
- Event triggers: HTTP, Pub/Sub, Eventarc (GCS, Firestore, Audit Logs, custom).
- Runtimes: Node, Python, Go, Java, .NET, Ruby, PHP.
- Memory up to 16 GB, timeout up to 60 min (2nd gen).
- Good for glue, ETL light, webhooks.

### Limitations

- Cold starts (mitigate with min instances).
- Not ideal for large dependency graphs or heavy startup.

---

## 7. Specialty / peripheral compute

- **Bare Metal Solution (BMS)** — Oracle / SAP HANA / specialized workloads requiring raw hardware in a Google-adjacent datacenter, connected via Partner Interconnect.
- **VMware Engine (GCVE)** — run VMware vSphere/VSAN/NSX in GCP; lift-and-shift without converting.
- **Batch** — Google-managed batch scheduler for HPC / scientific workloads.
- **Dataflow / Dataproc** — for data processing (see data services).
- **Cloud Workstations** — managed dev environments.
- **Migrate to Containers (M4C / CloudMigrate)** — convert VMs to containers.

---

## 8. Trade-off exam patterns

| Scenario | Likely answer | Distractor |
| --- | --- | --- |
| "Spiky ML inference, pay only for use" | Cloud Run with min instances=0 | GKE Standard (overkill) |
| "3rd-party monolith on Ubuntu 18.04" | GCE (maybe in MIG) | Cloud Run (can't) |
| "Batch HPC with MPI" | GCE MIG / Batch / Dataproc cluster | Cloud Functions |
| "Low-cost dev/test" | Spot VMs in GCE / preemptible GKE pool | Standard on-demand |
| "Scale to millions concurrent WebSockets" | GKE behind internal/external LB with HTTP/2 or TCP LB | Cloud Functions (no WS) |
| "Hybrid K8s across clouds" | GKE + Anthos on AWS/Azure + Fleet / Connect | raw GCE |

---

## 9. Rule of thumb

- **Start with Cloud Run.** If it can't do it → **GKE Autopilot**. If that can't → **GKE Standard**. If that can't → **GCE**.
- **For scheduled short jobs**, Cloud Functions or Cloud Run Jobs + Cloud Scheduler.
- **For stateful legacy**, GCE or BMS.
- **For giant stateless fleets needing very fine network / node controls**, GKE Standard.

Next: `04-storage-architecture.md`.
