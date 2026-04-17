# 3.1 Identity and Access Management (IAM)

IAM is the foundation of every GCP design. Expect multiple questions on IAM roles, service accounts, workload identity, conditions, and deny policies.

---

## 1. Identity sources

- **Google Accounts**: individual users (e.g., `alice@gmail.com`).
- **Google Groups**: recommended **primary binding** target.
- **Cloud Identity / Google Workspace**: enterprise identity with managed domain.
- **Federated identities**: SAML 2.0 or OIDC from external IdP (Okta, AD, Ping) via Cloud Identity.
- **Service accounts**: non-human identities scoped to projects.
- **Identity Platform**: customer identity (B2C), social, phone, SSO — for your apps.
- **External identities** (workforce / workload identity federation): federate AWS IAM roles or Azure AD to GCP without keys.

### Workforce Identity Federation

- Lets employees from your IdP (Okta, Azure AD) use GCP as if they were Cloud Identity users.
- Ideal when you don't want to migrate to Cloud Identity.

### Workload Identity Federation

- AWS, Azure, on-prem workloads → GCP without service account keys.
- Mapped via **identity pool** + **provider** (OIDC/SAML/AWS).

---

## 2. Resource hierarchy and IAM inheritance

```
Organization (acme.com)
├── Folder: Prod
│   ├── Folder: Retail
│   │   ├── Project: retail-app
│   │   └── Project: retail-data
│   └── Project: shared-prod
├── Folder: Non-prod
└── Folder: Common
```

- IAM bindings inherit from **parent** resources. Lower levels can add but not subtract — unless you use **IAM Deny Policies**.
- Use folders to map org structure and to isolate blast radius.
- Use **labels** across resources (env, app, owner, cost_center).

---

## 3. IAM roles

Three kinds:

1. **Basic (primitive)**: Owner, Editor, Viewer. Legacy; avoid on production.
2. **Predefined**: curated by Google, e.g., `roles/storage.objectAdmin`, `roles/compute.instanceAdmin.v1`.
3. **Custom**: you define permissions list; bound at org or project level.

### Picking roles

- Prefer the **least privileged predefined role**.
- Custom roles for gaps. Note: custom roles can drift when Google adds permissions to predefined roles; review periodically.
- Don't bind roles to individuals; bind to **groups**.

### Granting examples

```bash
gcloud projects add-iam-policy-binding my-proj \
  --member=group:data-engineers@acme.com \
  --role=roles/bigquery.dataEditor \
  --condition='expression=request.time < timestamp("2025-12-31T00:00:00Z"),title=Temp,description=Temp access'
```

---

## 4. IAM Conditions

Attribute-based access using **CEL** (Common Expression Language):

- `request.time` — temporary access.
- `resource.type` / `resource.name` — scope binding.
- `request.auth.claims.ip_address` — restrict by source.
- Access Context Manager **access levels** (device trust, IP range, geo, MDM) — tie in via VPC-SC and IAP.

---

## 5. IAM Deny Policies

- Attached at org / folder / project.
- Explicit deny beats allow.
- Use to guard against privilege escalation (e.g., deny `iam.serviceAccountKeys.create` across org).

```yaml
name: projects/p/denyPolicies/block-sa-keys
rules:
  - deniedPrincipals: [principalSet://iam.googleapis.com/cloudIdentityGroups/all-devs@acme.com]
    deniedPermissions: [iam.googleapis.com/serviceAccountKeys.create]
```

---

## 6. Service accounts

### Types

- **User-managed SA**: `SA@PROJECT.iam.gserviceaccount.com`.
- **Default SAs**: Compute / App Engine / Cloud Functions default SAs (legacy; have Editor). Delete or restrict.
- **Google-managed SAs**: used by services, patched automatically.

### Authentication options

- **SA keys** (JSON): highly risky; prefer alternatives.
- **Impersonation**: grant `roles/iam.serviceAccountTokenCreator` to a principal; generate short-lived tokens.
- **Workload Identity** (on GKE): KSA ↔ GSA mapping; no JSON keys on pods.
- **Metadata server**: instances get tokens from metadata server.
- **Attached service account** on Cloud Run / Functions / App Engine.

### Best practices

- Create a **separate SA per workload**, not shared.
- Enforce org policy `iam.disableServiceAccountKeyCreation`.
- Rotate keys (if used) every 90 days; prefer impersonation.
- Audit unused SAs; `gcloud asset search-all-iam-policies --scope=organizations/ORG --query="memberTypes:serviceAccount"`.

---

## 7. Access Transparency / Access Approval

- **Access Transparency**: near-real-time logs of **Google** access to your content (support).
- **Access Approval**: require your explicit approval before Google staff access.
- Required in some regulated industries (banks, government).

---

## 8. Org Policies

- Applied at org / folder / project.
- **Boolean** or **list** constraints.
- Examples (mandatory for any enterprise landing zone):
  - `compute.vmExternalIpAccess` = deny (restrict external IPs).
  - `compute.requireOsLogin` = true.
  - `iam.disableServiceAccountKeyCreation` = true.
  - `iam.allowedPolicyMemberDomains` = your domain(s).
  - `gcp.resourceLocations` = allowed regions.
  - `sql.restrictPublicIp` = true.
  - `storage.uniformBucketLevelAccess` = true.
  - `storage.publicAccessPrevention` = true.

---

## 9. Identity Aware Proxy (IAP)

- Provides zero-trust per-request authentication for apps behind **HTTP(S) LB** or **TCP** tunnels.
- **IAP for HTTP(S)**: protects web apps; users must be in an IAM binding for `roles/iap.httpsResourceAccessor`.
- **IAP for TCP**: SSH/RDP to GCE without public IPs; `gcloud compute ssh --tunnel-through-iap`.
- Integrates with **Context-Aware Access** (access levels via Access Context Manager).

---

## 10. Context-Aware Access / BeyondCorp Enterprise

- Combine user identity + device posture + context (IP, geo, time).
- Access levels defined in **Access Context Manager**.
- Apply with **IAP**, **IAM Conditions**, or **VPC-SC**.
- BeyondCorp Enterprise adds managed Chrome Enterprise and threat/data protection.

---

## 11. Identity Platform (customer identity)

- Multi-tenant auth (Google, Apple, Facebook, email/password, SAML, OIDC, phone).
- 10× bigger than Firebase Auth, enterprise features (MFA, B2B tenants, audit).
- Use when building apps for external users; not for employees (use Cloud Identity).

---

## 12. Tying IAM to data perimeters

- **VPC Service Controls** protect data egress even from authorized principals; stop SA-key leakage from exfiltrating BQ/GCS.
- **Access levels** referenced in VPC-SC for ingress rules.
- **Private Service Connect** + **VPC-SC** = data perimeter.

---

## 13. Auditing

- **Cloud Audit Logs** categories:
  - **Admin Activity** — always on, free.
  - **System Event** — always on, free.
  - **Data Access** — off by default for most; enable selectively (high cost if universally on).
  - **Policy Denied** — on by default.
- **Aggregated sinks** at org level → BigQuery (analysis), GCS (long-term, retention locked), Pub/Sub (real-time SIEM).
- **Log-based metrics** + alerts on suspicious activity (SA key creation, IAM changes, firewall rule changes).

---

## 14. Exam patterns

| Scenario | Right answer |
| --- | --- |
| "Allow contractors access for 30 days" | IAM Condition with `request.time` |
| "Prevent anyone from creating SA keys" | Org policy `disableServiceAccountKeyCreation` + Deny Policy |
| "AWS workloads call BQ without keys" | Workload Identity Federation (AWS provider) |
| "GKE pods call BQ without keys" | Workload Identity (KSA → GSA) |
| "Employees access internal app without VPN" | IAP for HTTPS (BeyondCorp) |
| "Only access from corporate laptops" | Access Context Manager + IAP + Endpoint Verification |
| "Need customer-facing auth" | Identity Platform |
| "Only US regions" | Org policy `gcp.resourceLocations` |
| "Monitor Google support access" | Access Transparency + Access Approval |

Next: `02-data-security-encryption.md`.
