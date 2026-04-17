# 3.5 Security Operations — Detection, Response, and Hardening

Having good defaults is not enough; you must detect, triage, and respond. This chapter covers the Google Cloud toolchain for SecOps.

---

## 1. Security Command Center (SCC)

Central security posture dashboard.

### Tiers

- **Standard** (free) — asset inventory, Security Health Analytics (basic misconfigurations).
- **Premium** — adds Event Threat Detection, Container Threat Detection, Virtual Machine Threat Detection, Web Security Scanner, integrations.
- **Enterprise (SCC Enterprise)** — includes Mandiant attack surface management, threat intel, SOAR capabilities.

### Key built-in detectors

- **Security Health Analytics**: misconfigurations (public buckets, overly permissive IAM, unused SAs, missing MFA, etc.).
- **Event Threat Detection**: malicious IAM changes, IAM anomalous grants, malware domains, data exfil via GCS, SSH brute force.
- **Container Threat Detection**: suspicious processes in GKE nodes.
- **VM Threat Detection**: cryptomining, rootkits in VM memory (leveraging kernel memory scanning).
- **Web Security Scanner**: scans App Engine / Compute / GKE for OWASP issues.

### Integrations

- Forward findings to Pub/Sub → Chronicle SIEM or external SIEM (Splunk, QRadar).
- Cloud Run / Cloud Functions automation for remediation (e.g., auto-quarantine public bucket).

---

## 2. Chronicle Security Operations (SecOps)

- Google's cloud-native **SIEM + SOAR** (formerly Chronicle + Siemplify).
- Ingests at petabyte scale; 1-year retention default.
- YARA-L detection rules.
- Integrates with SCC, GCP, M365, AWS, network, EDR.

---

## 3. Cloud Audit Logs — SecOps view

Four categories:

1. **Admin Activity** — IAM, provisioning, org policy changes. Always on, free.
2. **System Event** — Google-initiated actions. Always on, free.
3. **Data Access** — reads / writes to user data (BQ, GCS, Spanner). Off by default. Enable selectively; data access logs cost $$.
4. **Policy Denied** — access attempts blocked by org policy / VPC-SC / IAM.

### Log-based metrics + alerts

- Alert on SA key creation, IAM role grant to basic roles, firewall changes, GCS bucket made public, org policy changes.
- Use **log-based metrics** → Cloud Monitoring alert → Pub/Sub / PagerDuty.

---

## 4. Access Transparency & Access Approval

- **Transparency**: audit Google support's access to your content (near real time).
- **Approval**: you approve or deny each support access request.
- Required for regulated envs.

---

## 5. Incident response

### Pre-incident preparedness

- Runbooks in a well-known location (internal wiki / Git).
- On-call rotation with PagerDuty / Opsgenie.
- Break-glass accounts (separate, MFA + hardware key, audited).
- Isolated logging project (org sink) — can't be tampered with by compromised principals.

### Incident response process (NIST SP 800-61)

1. **Preparation**.
2. **Detection & analysis** — SCC / Chronicle / Monitoring alerts.
3. **Containment** — IAM revocations, firewall rule, isolate VM (tag, VPC move).
4. **Eradication** — remove malware, patch.
5. **Recovery** — restore from backups, re-key.
6. **Lessons learned** — postmortem; action items.

### Tools

- **IAM deny policies** or **remove bindings** for rapid containment.
- **Firewall rules** to isolate (drop all egress to quarantine).
- **Snapshots** of VM for forensics, stop VM, recreate.
- **Rotate keys** (KMS, service accounts, secrets) post-incident.

---

## 6. Binary Authorization

- Deploy-time policy enforcement for containers.
- **Attestations** signed by authorities; cluster verifies before scheduling.
- Integrations: Cloud Build, Artifact Registry (Artifact Analysis), Cloud Deploy, GKE, Cloud Run.

```yaml
# Example admission policy
defaultAdmissionRule:
  evaluationMode: REQUIRE_ATTESTATION
  enforcementMode: ENFORCED_BLOCK_AND_AUDIT_LOG
  requireAttestationsBy:
    - projects/p/attestors/prod-attestor
```

---

## 7. Artifact Analysis (Container Analysis)

- Vulnerability scanning for container images & OS packages (Java, Node, Python deps).
- Works with Artifact Registry + Container Registry (legacy).
- Integrates with Binary Authorization and SCC.

---

## 8. Web Application & API security (WAAP)

Bundle: Cloud Armor + Apigee + reCAPTCHA Enterprise + Cloud IAP.

- Cloud Armor for WAF / DDoS.
- Apigee for API management (quotas, OAuth, JWT validation, monetization).
- reCAPTCHA Enterprise for bot mitigation.
- Cloud IAP for app-level authentication.

---

## 9. Penetration testing

- Allowed without notifying Google for most services, but follow their policy (no DoS, no social engineering Google).
- Keep evidence for audit.
- Consider **Mandiant** (Google-owned) for red team / incident simulation.

---

## 10. Data breach prevention

- Secrets not in code (use Secret Manager).
- Service accounts without keys (Workload Identity Federation).
- DLP scanning of inbound/outbound data.
- Export control / IP marking via Sensitive Data Protection.
- Outbound network egress allow-list (mesh egress gateway, hierarchical firewall).

---

## 11. Supply chain security

- Use **Artifact Registry** with vulnerability scanning.
- **SLSA** (Supply-chain Levels for Software Artifacts) framework; target SLSA 3+.
- Sign builds (Binary Auth, Sigstore, Cloud Build provenance).
- Pin dependencies; software bill of materials (SBOM).
- **Assured Open Source Software (Assured OSS)**: Google-curated trusted OSS packages.

---

## 12. Event-driven remediation

Pattern:

```
SCC finding → Pub/Sub → Cloud Run / Cloud Functions → remediate
  ├── Revoke IAM binding
  ├── Remove public ACL on GCS bucket
  └── Notify SOC via Slack / PagerDuty
```

---

## 13. Security operations exam patterns

| Scenario | Answer |
| --- | --- |
| "Central dashboard for misconfigurations" | Security Command Center |
| "Detect crypto mining on VM" | VM Threat Detection (SCC Premium) |
| "Only signed containers can run in GKE" | Binary Authorization |
| "Scan images for CVEs" | Artifact Analysis |
| "SIEM / SOAR consolidated on GCP" | Chronicle SecOps |
| "Logs tamper-proof for 7y" | GCS bucket lock + retention + aggregated org sink |
| "Auto-remediate public bucket" | SCC → Pub/Sub → Cloud Function |
| "Simulate attack against web app" | Web Security Scanner + red team |
| "Restrict OSS packages to trusted set" | Assured OSS |

Next: `04-domain-analyze-optimize/`.
