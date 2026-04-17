# 2.5 Deployment and Automation

Provisioning infrastructure repeatably and safely is a core PCA competency. This chapter covers Terraform, Config Connector / Config Sync, Deployment Manager, and the broader IaC ecosystem on GCP.

---

## 1. Tool choice

| Tool | Best for |
| --- | --- |
| **Terraform** | Standard IaC; provider `google` + `google-beta`; **recommended**. |
| **Config Connector (KCC)** | Manage GCP resources via Kubernetes CRDs (GitOps, Argo, Config Sync). |
| **Config Sync / Config Controller** | GitOps over multiple GKE clusters. |
| **Deployment Manager** | Legacy Google IaC (YAML/Jinja/Python); still tested. |
| **Cloud Deploy** | Application continuous delivery to GKE / Cloud Run. |
| **Cloud Build** | CI + IaC execution; triggers. |
| **`gcloud` / `gcloud-beta`** | Scripting, one-off. |
| **Cloud SDK client libraries** | Programmatic automation. |

PCA prefers Terraform as the enterprise IaC; Deployment Manager is still referenced.

---

## 2. Terraform on GCP

### Provider config

```hcl
terraform {
  required_version = ">= 1.6.0"
  required_providers {
    google      = { source = "hashicorp/google", version = "~> 5.30" }
    google-beta = { source = "hashicorp/google-beta", version = "~> 5.30" }
  }
  backend "gcs" {
    bucket = "acme-tf-state"
    prefix = "landing-zone"
  }
}

provider "google" {
  project = var.project_id
  region  = "us-central1"
}
```

### Typical resource examples

```hcl
resource "google_project" "svc" {
  name            = "app-prod"
  project_id      = "acme-app-prod"
  folder_id       = google_folder.prod.name
  billing_account = var.billing_account
}

resource "google_compute_network" "vpc" {
  project                 = google_project.svc.project_id
  name                    = "prod-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "app" {
  project       = google_project.svc.project_id
  name          = "app-us-central1"
  network       = google_compute_network.vpc.self_link
  region        = "us-central1"
  ip_cidr_range = "10.20.0.0/20"
  private_ip_google_access = true
  secondary_ip_range {
    range_name    = "pods"
    ip_cidr_range = "10.128.0.0/14"
  }
  secondary_ip_range {
    range_name    = "services"
    ip_cidr_range = "10.64.0.0/16"
  }
  log_config {
    aggregation_interval = "INTERVAL_5_SEC"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }
}

resource "google_service_account" "app" {
  project    = google_project.svc.project_id
  account_id = "app"
}

resource "google_project_iam_member" "app_gcs" {
  project = google_project.svc.project_id
  role    = "roles/storage.objectViewer"
  member  = "serviceAccount:${google_service_account.app.email}"
}
```

### State management

- Store state in GCS with **versioning** + **retention policy**.
- One state file per environment; break apart by domain (network, security, apps).
- **Terraform Cloud / Enterprise**, **Spacelift**, **Atlantis**, or **Cloud Build + state lock** for team workflows.
- Always use **remote state** (not local) in team settings.

### Terraform best practices

- **Modules** per domain (network, IAM, workloads).
- **Workspaces or directories** per env (prefer directories for isolation).
- **Pin provider versions**.
- Use **`terraform plan`** in CI; require approval for apply in prod.
- **Policy as code**: `terraform validate` + `tflint` + `checkov` + **Policy Validation** with Google Cloud's Terraform Validator.
- Don't manage one resource with both TF and KCC.

### Google's foundation modules

- `terraform-google-modules/*` organization.
- Landing zone: `terraform-example-foundation` (Prod / Network / Security / Env / Business).
- Cloud Architecture Framework: composable modules for networking, projects, IAM, security.

---

## 3. Config Connector & Config Sync

### Config Connector

Install CRDs in a GKE cluster; define GCP resources as K8s resources.

```yaml
apiVersion: storage.cnrm.cloud.google.com/v1beta1
kind: StorageBucket
metadata:
  name: acme-app-data
  namespace: app-prod
spec:
  location: US
  storageClass: STANDARD
  uniformBucketLevelAccess: true
  lifecycleRule:
    - action: {type: Delete}
      condition: {age: 365}
```

Config Connector reconciles; GCP API calls mirror TF behavior. Combine with namespaces = projects for isolation.

### Config Sync

- GitOps agent sync K8s manifests from a repo.
- **RootSync / RepoSync** objects.
- Used with **Policy Controller** (OPA Gatekeeper) for policy enforcement.
- Fleet-wide via **Anthos Config Management**.

---

## 4. Deployment Manager

Legacy; still appears on exam.

```yaml
resources:
  - name: my-vm
    type: compute.v1.instance
    properties:
      zone: us-central1-a
      machineType: zones/us-central1-a/machineTypes/n2-standard-2
      disks:
        - boot: true
          initializeParams:
            sourceImage: projects/debian-cloud/global/images/family/debian-12
      networkInterfaces:
        - network: global/networks/default
```

Limitations: YAML-only, less active development, Google suggests Terraform for new projects.

---

## 5. Cloud Build (CI + IaC runner)

`cloudbuild.yaml` example (Terraform plan/apply):

```yaml
steps:
  - id: init
    name: hashicorp/terraform:1.6
    args: ['init']
    dir: infra
  - id: plan
    name: hashicorp/terraform:1.6
    args: ['plan', '-out=tfplan']
    dir: infra
  - id: apply
    name: hashicorp/terraform:1.6
    args: ['apply', '-auto-approve', 'tfplan']
    dir: infra
    waitFor: ['plan']
options:
  logging: CLOUD_LOGGING_ONLY
```

Use **service account impersonation** with `--impersonate-service-account` so Cloud Build doesn't need key files.

---

## 6. Cloud Deploy

Application CD pipeline with targets (GKE / Cloud Run / Anthos).

```yaml
apiVersion: deploy.cloud.google.com/v1
kind: DeliveryPipeline
metadata: { name: app-pipeline }
serialPipeline:
  stages:
    - targetId: dev
    - targetId: staging
      strategy:
        standard: { verify: true }
    - targetId: prod
      strategy:
        canary:
          runtimeConfig:
            kubernetes: { serviceNetworking: { service: app, deployment: app } }
          canaryDeployment:
            percentages: [25, 50, 100]
            verify: true
```

Pairs with Cloud Build or Skaffold.

---

## 7. Policy as code

- **Organization policies** (GCP-native): `gcp.resourceLocations`, `constraints/compute.vmExternalIpAccess`, `iam.disableServiceAccountKeyCreation`.
- **Policy Controller** (Anthos OPA) for K8s clusters.
- **Terraform Validator / Policy Library** — convert Google org policies into Terraform-compatible Rego checks.
- **Binary Authorization**: sign + verify container images.
- **Security Command Center** can flag policy drift.

---

## 8. Cloud Shell / Cloud Code / Skaffold

- **Cloud Shell**: ephemeral VM with 5 GB home, preinstalled SDKs.
- **Cloud Shell Editor** (based on Theia): browser-based IDE.
- **Cloud Code**: VS Code / JetBrains plugin for GKE, Run, Functions, Skaffold.
- **Skaffold**: local → remote dev loop; generates manifests, builds, pushes.

---

## 9. Marketplace and custom solutions

- **Marketplace** offers Google-curated and partner solutions (WordPress, Jenkins, data products).
- For internal reusable deployments, publish **Private Marketplace** solutions.
- **Cloud Workstations** for golden dev environments.

---

## 10. Typical PCA exam patterns (Automation)

| Requirement | Answer |
| --- | --- |
| "Repeatable provisioning across envs" | Terraform + modules + CI |
| "Engineers prefer K8s objects to declare GCP resources" | Config Connector |
| "Policy enforcement on GKE" | Config Sync + Policy Controller |
| "Need to enforce only signed containers deploy" | Binary Authorization |
| "Central team wants read-only plan before apply" | Cloud Build + TF plan w/ approval |
| "Gradual rollout of app version to GKE" | Cloud Deploy canary |
| "Quickly scaffold a GCS + Cloud Run" | gcloud or `deployment-manager` small template; but prefer Terraform in prod |

Next: `03-domain-security-compliance/`.
