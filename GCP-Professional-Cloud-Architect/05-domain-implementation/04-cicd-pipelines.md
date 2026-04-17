# 5.4 CI/CD Pipelines on GCP

End-to-end pipelines with Cloud Build, Cloud Deploy, Artifact Registry, and Binary Authorization.

---

## 1. Cloud Build

- Runs builds in containers; fully managed pool or **private pool** (connected to your VPC).
- Triggers: Git push, PR, Pub/Sub, manual.
- **Private Pool** inside a VPC to access private resources (Cloud SQL private, GKE private).
- Substitutions: `${_MY_VAR}`, `${PROJECT_ID}`, `${COMMIT_SHA}`.
- Service account impersonation for least privilege.
- Cache via `--cache` or bucket.
- **Approval steps** via `waitFor` + `allowExitCodes` (or Cloud Deploy for proper prompt).

### Example pipeline

```yaml
options:
  logging: CLOUD_LOGGING_ONLY
  machineType: E2_HIGHCPU_8
substitutions:
  _IMAGE: us-docker.pkg.dev/${PROJECT_ID}/apps/api:${COMMIT_SHA}

steps:
  - id: test
    name: node:20
    entrypoint: npm
    args: [ci]
  - id: build
    name: gcr.io/cloud-builders/docker
    args: [build, -t, $_IMAGE, .]
    waitFor: ['test']
  - id: scan
    name: us-docker.pkg.dev/gcb-tools/scan:latest
    args: [$_IMAGE]
    waitFor: ['build']
  - id: push
    name: gcr.io/cloud-builders/docker
    args: [push, $_IMAGE]
    waitFor: ['scan']
  - id: attest
    name: gcr.io/cloud-builders/gcloud
    args:
      - beta
      - container
      - binauthz
      - attestations
      - sign-and-create
      - --artifact-url=$_IMAGE
      - --attestor=projects/${PROJECT_ID}/attestors/ci-attestor
      - --keyversion=projects/${PROJECT_ID}/locations/us-central1/keyRings/ci/cryptoKeys/sig/cryptoKeyVersions/1
  - id: deploy
    name: gcr.io/cloud-builders/gcloud
    args:
      - deploy
      - releases
      - create
      - rel-${SHORT_SHA}
      - --delivery-pipeline=app-pipeline
      - --region=us-central1
      - --images=app=$_IMAGE
artifacts:
  images: [$_IMAGE]
```

---

## 2. Artifact Registry

- Stores container images + Maven / npm / Python (/apt / yum) packages.
- Regional, multi-region, virtual (union) repositories.
- Supports **Customer-managed encryption keys**.
- **Vulnerability scanning** (Artifact Analysis) auto-scans on push for CVEs.
- Remote repositories (pulls Docker Hub/Maven Central through GCP) + virtual repos (multiple in one endpoint).

---

## 3. Binary Authorization

- Enforce that only trusted images deploy to GKE / Cloud Run / Anthos.
- **Attestors** validate signatures tied to KMS keys.
- **Policy** with default rule + cluster-specific rules.
- **Break-glass**: annotation to bypass in emergencies (audited).
- **Continuous validation (CV)** re-verifies running workloads.

---

## 4. Cloud Deploy

- Declarative CD pipelines.
- Targets: GKE, Cloud Run, Anthos clusters.
- Strategies: rolling, canary, blue/green; verification via webhooks.
- Integrates with Skaffold (render manifests), Cloud Build (promote).
- Manual approvals per target.

### Example pipeline (GKE + canary)

```yaml
apiVersion: deploy.cloud.google.com/v1
kind: DeliveryPipeline
metadata:
  name: app-pipeline
description: app promotion
serialPipeline:
  stages:
    - targetId: dev
    - targetId: prod
      strategy:
        canary:
          runtimeConfig:
            kubernetes:
              serviceNetworking: { service: app, deployment: app }
          canaryDeployment:
            percentages: [25, 50, 100]
            verify: true
---
apiVersion: deploy.cloud.google.com/v1
kind: Target
metadata: { name: prod }
gke: { cluster: projects/p/locations/us-central1/clusters/prod }
requireApproval: true
```

---

## 5. GitOps with Config Sync / Anthos Config Management

- Cluster config in Git; **RootSync** / **RepoSync** reconciles.
- Policy Controller (OPA) enforces constraints.
- Useful for multi-cluster fleets (Anthos).

---

## 6. Testing stages in pipelines

- Lint / static analysis.
- Unit tests.
- Container build + vuln scan.
- Integration tests against emulators or dedicated env.
- Deploy to dev; smoke tests.
- Canary in prod with automatic rollback via SLO burn alerts.

---

## 7. Secrets & pipeline identity

- Cloud Build SA (`@cloudbuild.gserviceaccount.com`) — grant only required roles, or better, use **per-trigger user-specified SA**.
- Fetch secrets from Secret Manager in build steps (`availableSecrets`).
- Avoid long-lived SA keys; rely on metadata server.

---

## 8. Preview environments (per PR)

Pattern:

- Trigger on PR open → Cloud Build builds image → deploys to Cloud Run with tag `pr-<num>` → comment URL on PR.
- Teardown on PR close.
- For GKE, create namespace per PR via Config Connector.

---

## 9. Observability of pipelines

- Cloud Build audit logs + Monitoring metrics.
- Cloud Deploy **rollout metrics** (duration, failure).
- **DORA dashboards** via billing + Build metrics → BigQuery + Looker.

---

## 10. CI/CD exam patterns

| Scenario | Answer |
| --- | --- |
| "Block untrusted images" | Binary Authorization + Artifact Analysis |
| "Canary release on GKE" | Cloud Deploy canary or Argo Rollouts |
| "Need private builder (VPC-SC)" | Cloud Build private pool |
| "Reuse Jenkins?" | Ok if entrenched; else Cloud Build for lower ops |
| "Fully GitOps Anthos fleet" | Config Sync + Policy Controller |
| "Promote same image dev→stage→prod" | Cloud Deploy pipeline with targets |

Next: Domain 6 (`06-domain-reliability/`).
