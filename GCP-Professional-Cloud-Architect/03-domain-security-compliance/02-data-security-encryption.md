# 3.2 Data Security and Encryption

GCP encrypts customer data at rest and in transit by default. This chapter covers when defaults are insufficient and how to operate Google's key management and data protection services.

---

## 1. Encryption fundamentals on GCP

| Layer | Default | Customer-controlled |
| --- | --- | --- |
| **At rest** | Google-managed DEK + KEK | Cloud KMS (CMEK), Cloud HSM, Cloud EKM, CSEK |
| **In transit (inside Google)** | Automatic ALTS / TLS | — |
| **In transit (to outside)** | TLS on public internet | managed certs, mTLS via ASM |
| **In use** | standard VM | **Confidential Computing** (AMD SEV/TDX) |

### Key hierarchy

```
Plaintext data
   │ encrypted with
   ▼
DEK  (Data Encryption Key, per object / block)
   │ encrypted with
   ▼
KEK (Key Encryption Key) ← managed by Google, or by you via Cloud KMS
```

---

## 2. Cloud KMS

- **Key rings** per location (global / regional / multi-regional / zonal not applicable).
- **Keys** belong to a key ring; have purposes:
  - `ENCRYPT_DECRYPT` (AES-256-GCM).
  - `ASYMMETRIC_SIGN` / `ASYMMETRIC_DECRYPT` (RSA, EC).
  - `MAC` (HMAC).
- **Key versions**: rotating, active/enabled/disabled/destroyed.
- **Protection levels**:
  - **Software** — Google-managed software HSM.
  - **HSM** — FIPS 140-2 L3 certified.
  - **External** — Cloud EKM, key stays with your EKM partner (Thales, Fortanix, Virtru, Equinix SmartKey).
  - **External VPC** — EKM over VPC (private network).

### Rotation

- Automatic rotation period (e.g., 90 days).
- Old versions stay active to decrypt existing data; new version becomes primary.

### Usage

```bash
gcloud kms keys create data-key --location=us-central1 --keyring=my-kr \
  --purpose=encryption --rotation-period=90d --next-rotation-time=...

# CMEK on Cloud Storage bucket
gcloud storage buckets update gs://acme-data --default-encryption-key=projects/.../cryptoKeys/data-key
```

---

## 3. CMEK vs CSEK vs EKM

| Model | Key material | Typical use |
| --- | --- | --- |
| Google-managed | Google controls | Default |
| CMEK | In Cloud KMS, you control lifecycle | Enterprise compliance |
| CSEK (GCS, PD only) | You supply AES-256 key per request | Legacy / niche |
| EKM | Held outside Google; KMS calls partner | Strict sovereignty / BYOK |
| EKM via VPC | EKM communicates over private network | Highest isolation |

---

## 4. Secret Manager

- Stores API keys, passwords, certs.
- Versions: enabled / disabled / destroyed; default "latest" label.
- CMEK-encrypted.
- IAM `roles/secretmanager.secretAccessor` to read.
- **Replication**: automatic (multi-region) or user-managed (list of regions).
- **Rotation schedules** with Cloud Scheduler + Cloud Functions.

```bash
gcloud secrets create db-pass --replication-policy=automatic
echo -n "P@ss!" | gcloud secrets versions add db-pass --data-file=-
```

---

## 5. Sensitive Data Protection (Cloud DLP)

- **Inspection** of GCS/BQ/Datastore/arbitrary text for sensitive data (PII, PHI, credit cards, custom infoTypes).
- **De-identification**:
  - Masking, tokenization, format-preserving encryption (FPE), cryptographic hashing, date shifting.
- **Re-identification** risk analysis (k-anonymity, l-diversity).
- Integrations: pre-ingestion scan of Pub/Sub via Dataflow; BQ scheduled scans; GCS discovery.
- Output findings to Security Command Center and Cloud Logging.

---

## 6. Confidential Computing

- **Confidential VMs** (AMD SEV / SEV-SNP / Intel TDX) encrypt RAM.
- **Confidential GKE Nodes**.
- **Confidential Space**: multi-party computation where parties collaborate on data without exposing raw data to each other.

Use for regulatory obligations (HIPAA, GDPR data minimization, financial privacy).

---

## 7. Cloud HSM

- FIPS 140-2 L3 certified.
- Runs HSMs operated by Google; keys never leave.
- Subset of KMS APIs; protection level = `HSM`.
- Required by certain regulators (e.g., PCI DSS L1).

---

## 8. Certificate Authority Service (CAS)

- Managed private CA (multi-tier).
- Issue TLS / client / device certs.
- Integrates with GKE mTLS (via ASM) and workload identity.
- Tier 1 (Enterprise) for 100K+ certs per month; Tier 2 (DevOps) for low-volume.

---

## 9. Certificate Manager

- Managed public TLS certificates (vs Google-managed on LB).
- Supports wildcard & DNS auth.
- Import/issue from Let's Encrypt, Google CA, or upload custom.
- Works with external application LB.

---

## 10. Data-in-transit patterns

- **HTTPS LB + managed cert** → edge TLS.
- **mTLS** within Anthos Service Mesh / Istio with managed workload certificates (Mesh CA / CAS).
- **Application-level encryption** for end-to-end (client → DB) when defense-in-depth required.
- **VPC internal traffic** is ALTS-encrypted by Google automatically.

---

## 11. Data classification and discovery

- **Dataplex** classification: attach policy tags to BQ columns.
- **DLP infoType** catalog: 150+ built-in (CC, SSN, passport), add custom dictionaries / regex / ML detectors.
- **BigQuery policy tags** + column-level access via Data Catalog Policy Tag Manager.

---

## 12. Example: HIPAA-ready data layer

1. **Project segmentation**: PHI in dedicated projects under a regulated folder.
2. **VPC-SC perimeter** around BQ, GCS, Pub/Sub, Spanner.
3. **CMEK** on all storage services (BQ, GCS, Spanner, Cloud SQL, Pub/Sub, PDs).
4. **DLP scans** on ingest; auto-redact PII in non-PHI zone.
5. **Access Transparency + Approval** on project.
6. **IAM Conditions** restrict high-privilege roles to time-boxed windows.
7. **Logs** exported to locked GCS bucket (bucket lock + retention) under separate logging project.
8. **BAAs**: request Google Cloud BAA via Cloud Console (automatic for covered services).

---

## 13. Exam cues

| Phrase | Answer |
| --- | --- |
| "Must control key material outside Google" | **Cloud EKM** |
| "FIPS 140-2 L3" | **Cloud HSM** |
| "Automatic rotation every 90 days" | Cloud KMS rotation period |
| "Scan BQ for PII" | **Cloud DLP** |
| "Mask tax IDs before exposing to analytics" | DLP de-identification + column-level policy tags |
| "Encrypt VM memory" | **Confidential VMs** |
| "Tamper-evident logs" | Cloud Logging sink to GCS with bucket lock + **retention policy** |
| "Short-lived secrets for CI" | Secret Manager + Workload Identity |

Next: `03-network-security.md`.
