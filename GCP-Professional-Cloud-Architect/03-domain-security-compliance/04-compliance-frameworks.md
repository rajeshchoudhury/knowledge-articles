# 3.4 Compliance Frameworks on GCP

The PCA expects you to pick the right configuration for common regulations. This chapter maps standards to Google services and controls.

---

## 1. Google Cloud compliance program snapshot

Google maintains a public compliance reports manager. Notable certifications / attestations:

- **ISO 27001, 27017, 27018, 27701**.
- **SOC 1, 2, 3**.
- **PCI DSS** (Level 1 service provider).
- **FedRAMP High (moderate, high in certain regions)**.
- **HIPAA** (BAA available).
- **GDPR / UK GDPR, DPA, SCCs**.
- **HITRUST**.
- **PCI DSS v4** (in audits).
- **IRAP** (Australia), **BSI C5** (Germany), **K-ISMS** (Korea), **MTCS** (Singapore).
- **FIPS 140-2 L3** via Cloud HSM.

Check the **Compliance Reports Manager** for the current list and region-specific coverage.

---

## 2. HIPAA (healthcare, US)

### Key obligations

- Sign a **BAA** with Google.
- Only use **covered services** (list updated by Google — most popular GCP services are covered; confirm in docs).
- Audit controls + encryption in transit/at rest + integrity controls.

### GCP configuration

- Enable BAA via Cloud Console.
- Dedicate a regulated folder with org policies:
  - Block non-covered services.
  - Restrict data residency if needed.
  - CMEK required on storage.
- Healthcare API (Cloud Healthcare) for FHIR / HL7v2 / DICOM data with BAA included.
- DLP for PHI de-id.
- Logs to a separate logging project.

---

## 3. PCI DSS (card data)

### Key concepts

- **Cardholder Data Environment (CDE)**: isolate scope.
- **Level 1 provider** means the platform is attested; **your app must still be compliant**.
- **Segmentation** using VPC, subnets, firewall rules, VPC-SC.

### GCP approach

- Dedicated project(s) for CDE; folder with strict org policies.
- Use tokenization (DLP / format-preserving encryption) to remove card data from systems when possible.
- Apigee + Cloud Armor to limit public surface.
- Cloud KMS + Cloud HSM for key control.
- Logging to SIEM; audit trails for every admin action (Admin Activity + Data Access).

---

## 4. GDPR and data residency

### Pillars

- **Lawful basis** + consent.
- **Right to erasure** / portability.
- **Data localization** — often required for EU/UK/Switzerland.
- **DPIA** for high-risk processing.
- **Data Processing Addendum (DPA)** + **SCCs** for international transfers.

### GCP mechanisms

- **Regional services** deployed in EU regions (europe-west1 etc.).
- **Org policy** `gcp.resourceLocations` → `in:eu-locations`.
- **Assured Workloads** for **EU Sovereignty**, **US Regions**, **Canada**, **ITAR**, **Japan**, etc. — automated compliance blueprint.
- **Access Transparency + Approval** for Google support access.
- **EU Sovereignty controls** (via Assured Workloads) restrict Google personnel to EU residents with background checks.

---

## 5. FedRAMP (US federal)

- **Assured Workloads for US Regions** configures FedRAMP High / Moderate controls.
- Limits to personnel (US persons), regions (us-central1, us-east1, us-west1, etc.), encryption (FIPS 140-2 L3 via Cloud HSM).
- Log retention with immutable settings.
- CJIS (Criminal Justice Info Services) similar.

---

## 6. ITAR (defense)

- Data can't be accessed from outside the US.
- Assured Workloads ITAR profile enforces.

---

## 7. SOC 2 readiness

Google attestations cover the underlying platform. Your app still needs to demonstrate:

- Access control (IAM / conditions / deny policies).
- System monitoring (Cloud Monitoring + SCC).
- Change management (CI/CD with approvals).
- Data backup and recovery (Cloud SQL PITR, Spanner backups, GCS versioning).
- Incident management (Cloud Monitoring + PagerDuty + postmortems).

---

## 8. ISO 27001 / 27017 / 27018 / 27701

- 27001 (ISMS), 27017 (cloud), 27018 (PII in cloud), 27701 (privacy management).
- Leverage Google's certifications; maintain your control mappings.

---

## 9. Industry-specific

- **SOX / FINRA / SEC** — US financial: immutable logs, segregation of duties, retention (WORM).
- **MAS / HKMA / RBI** — APAC financial regulators; regional residency + inspection rights.
- **FDA 21 CFR Part 11** — pharma: e-signature, audit trails.
- **HITRUST** — healthcare common security framework.
- **DORA** — EU financial resilience (starting 2025+).
- **NIST 800-53 / CSF** — widely used baseline.

---

## 10. Assured Workloads (summary)

- Blueprint for regulated workloads; available for EU Sovereignty, US Public Sector (FedRAMP Moderate/High, IL2/4/5), Canada, Japan, Israel, UK, ITAR, HIPAA, CJIS.
- Enforces:
  - Allowed regions.
  - Personnel access.
  - Encryption key policies (often Cloud HSM).
  - Restricted support.
- Deploy via Cloud Console or `gcloud assured workloads create`.

---

## 11. Audit-ready logging architecture

- Aggregated org sinks → three targets:
  - **BigQuery** for analytics & SIEM ingestion.
  - **GCS bucket** with **retention policy** and **bucket lock** for WORM compliance (7 years typical).
  - **Pub/Sub** for real-time SIEM / SOAR (Chronicle, Splunk).
- **Data Access logs** enabled for highly regulated services.
- Access Approval logs; Access Transparency logs.
- **Security Command Center Premium / Enterprise**: continuous findings, policy checks.

---

## 12. Preparing for an audit

1. Inventory (Cloud Asset Inventory).
2. Map each control to a GCP feature + evidence (screenshots / logs).
3. Export 6–12 months of logs.
4. Test BCP / DR at least annually.
5. Run pentest (notify Google if required; usually allowed without prior notification).

---

## 13. Compliance exam patterns

| Scenario | Answer |
| --- | --- |
| "PHI data, US" | BAA enabled, covered services only, CMEK, VPC-SC, Data Access logs. |
| "EU sovereignty, German data" | Assured Workloads EU + Cloud EKM + EU regions. |
| "FedRAMP High" | Assured Workloads US + Cloud HSM keys + US personnel. |
| "PCI Level 1" | Dedicated CDE project, tokenization, Armor + LB, logging isolation. |
| "Retain logs 7 years immutably" | GCS bucket lock + retention policy + logging sink. |
| "Prove Google didn't access data" | Access Transparency + Access Approval. |
| "Mask PII before dashboards" | Cloud DLP de-id + BQ policy tags. |

Next: `05-security-operations.md`.
