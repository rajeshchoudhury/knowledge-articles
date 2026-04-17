# 4.3 Technical Processes — SDLC, CI/CD, Testing, Validation

Beyond architecture, the PCA evaluates your fluency in modern software delivery and operational processes.

---

## 1. Software Delivery Lifecycle (SDLC)

### Stages

1. **Plan** — backlog, design docs, ADRs (Architecture Decision Records).
2. **Develop** — code, unit tests.
3. **Build** — CI, quality gates.
4. **Test** — unit, integration, performance, security, contract.
5. **Release** — version, package, sign.
6. **Deploy** — rollout, canary, gradual.
7. **Operate** — monitor, on-call.
8. **Learn** — postmortems, DORA metrics.

### DORA metrics (Accelerate)

- **Deployment frequency**: elite = multiple/day.
- **Lead time for changes**: elite = < 1 day.
- **Change failure rate**: elite = 0–15%.
- **MTTR**: elite = < 1 hour.

GCP tools to measure: **Cloud Deploy**, **Cloud Build**, **Artifact Registry**, **Monitoring**, **Error Reporting**.

---

## 2. CI/CD reference on GCP

### Tools

- **Cloud Source Repositories** (basic Git; many teams use GitHub/GitLab/Bitbucket instead).
- **Cloud Build**: server-side CI; container-based builders; triggers.
- **Artifact Registry**: stores containers + Maven/Yarn/NPM/Python packages.
- **Container Analysis / Artifact Analysis**: scan images for CVEs.
- **Cloud Deploy**: CD pipelines with targets (GKE, Cloud Run, Anthos).
- **Binary Authorization**: signed image verification at admission.
- **Skaffold**: local dev + CI/CD manifest pipeline.
- **Cloud Code**: IDE integration (VS Code / JetBrains).

### Reference pipeline

```
Dev commit → GitHub → Cloud Build (via trigger)
  ├── Build multi-arch image
  ├── Run unit + integration tests
  ├── SAST/secret scan
  ├── Push image to Artifact Registry
  └── Artifact Analysis scans for CVEs
→ Cloud Build signs image (Binary Authorization attestation)
→ Cloud Deploy pipeline
  ├── Target: dev (auto)
  ├── Target: staging (auto + verify)
  └── Target: prod (canary 25/50/100 + verify + approval)
Observability: Monitoring + Error Reporting alert on burn-rate
```

---

## 3. Testing strategy

- **Unit**: fast, runs in CI.
- **Integration**: uses emulators (Firestore emulator, Spanner emulator, Pub/Sub emulator).
- **Contract**: Pact for service boundaries.
- **End-to-end**: periodic, on staging with synthetic workload.
- **Performance**: k6/Locust against staging; compare to baseline.
- **Security**: SAST (e.g., Cloud Build + Snyk), DAST (Web Security Scanner), dependency scanning (Assured OSS).
- **Chaos**: inject failures on staging (Chaos Mesh on GKE, Gremlin).

---

## 4. Release strategies

| Strategy | Description | Downside |
| --- | --- | --- |
| **Recreate** | Kill old, start new | Downtime |
| **Rolling** | Replace pods/VMs gradually | Mixed versions live |
| **Blue/Green** | Two full stacks; switch traffic | Cost double during switch |
| **Canary** | Route small % to new version; expand | Need metrics & automatic rollback |
| **Feature flag / dark launch** | Deploy disabled; toggle per user | Complexity in code |
| **Traffic split (App Engine / Run / GKE w/ mesh)** | % weights per version | Requires mesh or LB feature |

### GKE strategies

- **Deployment** with `maxSurge`/`maxUnavailable` for rolling.
- **Argo Rollouts / Flagger** for canary/blue-green with metrics analysis.
- **Cloud Deploy** canary mode with verification.

### Cloud Run

- Traffic tags + split: `gcloud run services update-traffic api --to-revisions=api-v2=10,api-v1=90`.
- Revisions are immutable; roll back by shifting traffic.

### App Engine

- Versions + traffic splits (by IP / cookie / random).

---

## 5. Troubleshooting / root-cause analysis

- **Cloud Logging** with structured logs (jsonPayload).
- **Cloud Trace** correlates spans end-to-end.
- **Cloud Profiler** identifies CPU hotspots.
- **Error Reporting** groups stack traces.
- **Cloud Debugger** (deprecated; replaced by Ops Agent snapshots).
- **Live monitoring** dashboards with golden signals.
- **Audit logs** for permission-related failures.

### Postmortem template

1. Summary.
2. Timeline (UTC).
3. Impact (users, revenue).
4. Detection.
5. Resolution.
6. Root cause.
7. Action items (owner, due date).
8. Blameless lessons learned.

---

## 6. Change management

- Feature flags (LaunchDarkly, Firebase Remote Config).
- GitOps: environment state in git; PR approvals + CI checks gate changes.
- Peer review + security review required.
- Preview environments per PR (Cloud Run with env per PR or ephemeral GKE namespaces).

---

## 7. BCP and DR processes

- **RTO** / **RPO** agreed per workload.
- **Tier**: critical / important / normal.
- **DR runbooks** with annual test (game days).
- **Failover automation** where possible (Spanner multi-region, global LB, Cloud SQL promote replica).
- **Backup strategy**:
  - Cloud SQL automated + export to GCS + cross-region copy.
  - Spanner backups + cross-region export.
  - GCS turbo replication (dual-region).
  - GCE snapshots + machine images.

---

## 8. Service catalog & self-service

- **Private Service Catalog** (via Deployment Manager / Terraform) to expose vetted blueprints to dev teams.
- Google's **Terraform Blueprints**: project factories, landing zone, HA VPC.
- Developers consume via Cloud Marketplace internal publications.

---

## 9. Exam patterns — technical processes

| Scenario | Answer |
| --- | --- |
| "Release to 10% users first" | Canary (Cloud Run traffic split, or Cloud Deploy canary) |
| "Zero-downtime deploy on GKE" | Rolling update with sufficient maxSurge, readiness probe |
| "Enforce only signed images deploy" | Binary Authorization |
| "Scan container CVEs" | Artifact Analysis |
| "Automate deploy from git merge to prod with approvals" | Cloud Build trigger → Cloud Deploy pipeline with manual prod approval |
| "Reproducible infra in multiple envs" | Terraform + module repo |

Next: `04-business-processes.md`.
