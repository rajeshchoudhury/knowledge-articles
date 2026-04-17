# 2.1 Configuring and Provisioning Compute

This chapter focuses on the operational knobs of compute on GCP — how to create and size resources correctly.

---

## 1. Compute Engine machine families

| Family | Prefix | Use |
| --- | --- | --- |
| General | E2, N1, N2, N2D, N4, C3, C3D, Tau T2A/T2D | Balanced workloads |
| Compute-optimized | C2, C2D, C3 | HPC, gaming, high single-thread |
| Memory-optimized | M1, M2, M3 | SAP HANA, in-memory analytics, large Redis |
| Storage-optimized | Z3 | Scale-out DBs, high-IO |
| Accelerator | A2 (A100), A3 (H100), G2 (L4), TPU v4/v5 | ML/AI |
| Shared-core (very small) | E2-micro/small/medium, F1-micro (legacy) | Dev / free-tier |

### Pricing classes

- **On-demand** — full price, no commitment.
- **Sustained-use discount** — automatic up to 30% for fleet uptime in a month (N1/N2 mainly).
- **Committed-use discount (CUD)** — 1yr (~37%) or 3yr (~55%) **resource-based** (vCPU + RAM pool) or **spend-based** (Cloud SQL, GKE, Dataflow, etc.).
- **Flex CUD (flexible committed use)** — resource-based, any region, any family within a class.
- **Spot VMs** — 60–91% off; preempted anytime; 30s notice.

### Sole-tenant nodes

- Dedicated physical host; avoids tenancy with other customers.
- Use for BYOL (Windows / SQL Server), compliance (FedRAMP High), or CPU-pinning.

---

## 2. Provisioning patterns

### Single VM

```bash
gcloud compute instances create web-1 \
  --machine-type=n2-standard-2 \
  --image-family=debian-12 --image-project=debian-cloud \
  --zone=us-central1-a \
  --tags=http-server,https-server \
  --service-account=app-sa@project.iam.gserviceaccount.com \
  --scopes=cloud-platform \
  --shielded-secure-boot --shielded-vtpm --shielded-integrity-monitoring
```

### Managed Instance Group (regional, autoscaled)

```bash
# 1. Template
gcloud compute instance-templates create web-tpl \
  --machine-type=n2-standard-2 \
  --image-family=debian-12 --image-project=debian-cloud \
  --metadata-from-file=startup-script=./startup.sh \
  --service-account=app-sa@project.iam.gserviceaccount.com \
  --scopes=cloud-platform

# 2. MIG (regional - spans zones)
gcloud compute instance-groups managed create web-mig \
  --template=web-tpl --size=3 --region=us-central1 \
  --health-check=web-hc --initial-delay=300

# 3. Autoscaling
gcloud compute instance-groups managed set-autoscaling web-mig \
  --region=us-central1 \
  --min-num-replicas=3 --max-num-replicas=30 \
  --target-cpu-utilization=0.6
```

### Rolling update / canary

```bash
# Canary: deploy new template to 10% of instances
gcloud compute instance-groups managed rolling-action start-update web-mig \
  --version=template=web-tpl-v1 \
  --canary-version=template=web-tpl-v2,target-size=10% \
  --region=us-central1
```

### Stateful MIG

- Preserve instance names, metadata, disks.
- `--stateful-disk=device-name=data,auto-delete=never`.
- `--stateful-internal-ip`, `--stateful-metadata`.

---

## 3. GKE provisioning

### Autopilot

```bash
gcloud container clusters create-auto my-cluster \
  --region=us-central1 \
  --release-channel=regular \
  --workload-pool=my-project.svc.id.goog \
  --enable-private-nodes --enable-private-endpoint \
  --master-ipv4-cidr=172.16.0.0/28 \
  --enable-master-authorized-networks --master-authorized-networks=10.0.0.0/24 \
  --enable-ip-alias \
  --network=shared-vpc --subnetwork=projects/host/regions/us-central1/subnetworks/gke
```

### Standard with node pools

```bash
gcloud container clusters create prod \
  --region=us-central1 \
  --release-channel=regular \
  --num-nodes=1 \
  --machine-type=e2-standard-4 \
  --enable-ip-alias \
  --enable-autorepair --enable-autoupgrade \
  --enable-network-policy \
  --workload-pool=proj.svc.id.goog

# Spot / preemptible node pool
gcloud container node-pools create spot-pool --cluster=prod --region=us-central1 \
  --machine-type=n2-standard-4 --spot --num-nodes=1 \
  --min-nodes=0 --max-nodes=50 --enable-autoscaling \
  --node-taints=cloud.google.com/spot=true:PreferNoSchedule
```

### Node auto-provisioning

- Cluster creates new node pools as needed to satisfy pod resource requests, GPU types, taints.
- Set `--enable-autoprovisioning --max-cpu=... --max-memory=... --autoprovisioning-service-account=...`.

---

## 4. Cloud Run provisioning

```bash
gcloud run deploy api \
  --image=us-docker.pkg.dev/proj/repo/api:1.2.3 \
  --region=us-central1 \
  --platform=managed \
  --allow-unauthenticated \
  --concurrency=80 --cpu=2 --memory=1Gi \
  --min-instances=1 --max-instances=100 \
  --set-secrets=DB_PASS=projects/proj/secrets/db-pass:latest \
  --vpc-connector=vpc-con-central --vpc-egress=private-ranges-only \
  --ingress=internal-and-cloud-load-balancing
```

Ingress options:

- `all` — public.
- `internal` — only internal VPC and shared VPC.
- `internal-and-cloud-load-balancing` — LB + internal VPC. Preferred if fronting with HTTPS LB + Armor.

---

## 5. Service accounts and identity for compute

- Each compute surface should use a dedicated **service account**.
- Avoid the default Compute Engine SA (`<project-number>-compute@developer.gserviceaccount.com`) for workloads; it has broad Editor by default.
- Scopes on GCE VMs matter; for GKE, prefer **Workload Identity** (KSA → GSA mapping).
- Never bake JSON keys into images; use metadata / Secret Manager / IAM.

---

## 6. Quotas and capacity planning

- Quotas are **per project per region** (sometimes per zone).
- Key quotas: CPUs per region, in-use external IPs, persistent disk SSD TiB, Cloud NAT ports, LB forwarding rules, BigQuery slots.
- Request increases early; large orgs use **project factories** so each BU inherits a baseline.
- For planned surges (marketing launch) → **reservation** (specific / any shape) in addition to CUD.
- **Maintenance windows**: use maintenance policies for Cloud SQL, GKE (release channels), Memorystore.

---

## 7. GPUs / TPUs

- GPUs attached to GCE or to GKE via node pool.
- **A100** (A2), **H100** (A3), **L4** (G2), **V100**, **T4** (N1 only).
- **Spot GPUs** up to 70% cheaper.
- **TPU v4/v5** via Cloud TPU or Vertex AI.
- Consider **Dynamic Workload Scheduler** for queued GPU jobs.

---

## 8. Sole-tenant / Confidential VMs

- **Confidential VMs**: AMD SEV / Intel TDX / SEV-SNP; memory encrypted with ephemeral CPU keys; N2D / C3D / C2D.
- **Shielded VMs**: secure boot, vTPM, integrity monitoring; recommended default.
- **Sole-tenant**: full node dedicated to your project.
- **Confidential GKE Nodes**, **Confidential Cloud Run** — newer surfaces.

---

## 9. Image & OS management

- **Public images**: Google-curated, Debian, Ubuntu, RHEL, CentOS Stream, Windows, Container-Optimized OS (COS).
- **Custom images** built via Packer / Cloud Build; stored in project or Image Family.
- **OS Config / OS Patch Management** for patch schedules across fleets.
- **OS Login** enforces SSH via IAM (replaces project metadata SSH keys).
- **Confidential Space** for multi-party computations.

---

## 10. Instance-level best practices

- Enable **OS Login** (`enable-oslogin=TRUE` at project or instance).
- Enable **Shielded VM**.
- No external IP by default; use **IAP TCP tunnelling** for SSH from admin workstations.
- Use **startup scripts** for bootstrap, but prefer bake-in (Packer).
- Instance metadata: project vs instance scope; avoid sensitive data in metadata.

Example IAP SSH:

```bash
gcloud compute ssh web-1 --zone=us-central1-a --tunnel-through-iap
```

---

## 11. Exam traps

| Trap | Correct answer |
| --- | --- |
| "Assign wide roles to compute default SA" | Create dedicated SA with least privilege |
| "Use manual instance group for autoscaling" | MIGs with autoscaler |
| "Use zonal MIG for 99.99% SLA" | Regional MIG across 3 zones |
| "SSH via external IP" | Tunnel through IAP; no external IPs |
| "Use startup scripts for everything" | Prefer pre-baked images + startup for late binding |
| "GCE for spiky API" | Cloud Run with min instances |

Next: `02-storage-systems.md`.
