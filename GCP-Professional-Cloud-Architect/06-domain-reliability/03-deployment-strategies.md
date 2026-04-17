# 6.3 Deployment and Release Management

How to roll out changes safely with GCP primitives.

---

## 1. Deployment strategies summary

| Strategy | Description | Use when |
| --- | --- | --- |
| **Recreate** | Stop old, start new | Non-prod, low-traffic |
| **Rolling** | Replace gradually | Default Kubernetes Deployment |
| **Blue/Green** | Two stacks, switch traffic | Need instant rollback, cost acceptable |
| **Canary** | Route small % to new | Need metric validation |
| **Shadow / Mirror** | Mirror traffic to new (no response) | Validate behavior at scale |
| **A/B / feature flag** | Route by user attributes | Product experimentation |

---

## 2. GKE rolling updates

- `kubectl set image` or apply new manifest → rolling update via ReplicaSet.
- `maxSurge` / `maxUnavailable` control pace.
- Readiness probes gate traffic.
- `kubectl rollout pause / resume / undo` for control.

Better: **Argo Rollouts** or **Cloud Deploy** for metric-based promotion.

---

## 3. Cloud Run traffic splitting

- Each deploy creates a new **revision**.
- Route traffic by weight or tag:
  ```bash
  gcloud run services update-traffic api \
    --to-revisions=api-v1=90,api-v2=10
  # Tag for testing
  gcloud run services update-traffic api --set-tags=canary=api-v2
  # Access: https://canary---api-<hash>-uc.a.run.app
  ```
- Rollback = shift 100% to previous revision.

---

## 4. App Engine traffic splitting

- Versions + `gcloud app services set-traffic`.
- Split by IP, cookie, or random.

---

## 5. Cloud Deploy

- Pipeline with stages and strategies.
- Supports canary, blue/green (through GKE Gateway API), rolling.
- Built-in verify job after each promotion.
- Manual approval step before prod target.
- Metrics-driven promotion via integration with Monitoring.

---

## 6. Blue/green with Global LB

- Two backend services (blue, green) behind the same URL map.
- Route by weight (traffic-split in URL map) or by swapping backend.
- Instant rollback.

---

## 7. Canary at MIG level

- Two MIGs: stable + canary, both attached to same LB backend service.
- Use `--max-rate-per-instance` and weights.
- Roll forward by scaling canary up; stable down.

---

## 8. Verification and rollback

- Automated verification: smoke tests, synthetic probes, or SLO burn-rate check.
- Rollback triggers:
  - Error rate > X%.
  - Latency p95 > X.
  - SLO burn fast.
- Cloud Deploy auto-rollback with **verify** + **postdeploy** hooks.

---

## 9. Database changes

- **Expand / Contract** migrations: add new schema, backfill, release code, drop old.
- Avoid breaking changes during canary; use feature flags to decouple.
- Blue/green with Cloud SQL via DMS: use replication + switch.

---

## 10. Infrastructure rollouts

- Terraform `plan` → `apply` with CI gating.
- For risky changes (network, IAM), use **Terraform plan file** reviewed by multiple stakeholders.
- Phased rollout across folders / environments (dev → staging → prod).

---

## 11. Deployment exam patterns

| Scenario | Answer |
| --- | --- |
| "Cut over new version in seconds, with instant rollback" | Blue/green with traffic switch |
| "Roll out new version to 10% users" | Canary (Cloud Deploy / Cloud Run traffic split) |
| "Deploy during business hours with minimal risk" | Canary + auto-rollback |
| "Test new version with production traffic, no user impact" | Shadow / mirror |
| "Feature available to beta users only" | Feature flag or traffic split by header/cookie |

Next: `04-incident-response.md`.
