# 5.2 — Compliance Frameworks for AI

The exam tests recognition of compliance regimes that affect AI workloads and which AWS services / tools help.

---

## 1. Common Compliance Frameworks

| Framework | Scope | Key implications for AI |
|-----------|-------|-------------------------|
| **HIPAA** | US healthcare (PHI) | Sign BAA with AWS; use HIPAA-eligible services; encrypt; limit access; audit |
| **GDPR** | EU personal data | Lawful basis, DPIA, right to erasure, cross-border transfer; DPA with AWS |
| **CCPA / CPRA** | California consumer privacy | Opt-out, data subject access, don't sell personal info |
| **PCI DSS** | Payment card data | Cardholder data environment — rarely feed to LLMs; use tokenization |
| **SOC 1/2/3** | Service org controls | AWS SOC reports available via Artifact |
| **ISO 27001 / 27017 / 27018 / 27701** | Infosec / cloud / privacy | Management systems; evidence via Artifact |
| **ISO/IEC 42001** | AI Management System (AIMS) | First standard for AI governance; AWS is certified |
| **NIST AI Risk Management Framework (AI RMF)** | US AI governance | Voluntary, widely adopted framework: Govern, Map, Measure, Manage |
| **EU AI Act** | EU AI regulation (risk-based) | Prohibited, high-risk, limited-risk, minimal-risk tiers; obligations scale with risk |
| **FedRAMP** | US federal cloud | Pick AWS US-Fed regions; fewer services available |
| **FIPS 140-2/3** | Cryptographic modules | Use FIPS endpoints in GovCloud |
| **PIPEDA, LGPD, PDPA** | Canada, Brazil, Singapore | Similar to GDPR at a high level |
| **FINRA / SEC / OCC** | Financial services | Additional recordkeeping and explainability expectations |

---

## 2. Responsibility Split

- **AWS** certifies its infrastructure and services. Evidence is in **AWS Artifact**.
- **You** certify **your application** built on top — your data flows, policies, access controls.

---

## 3. AWS Artifact

- **On-demand** compliance reports: SOC 1/2/3, ISO, PCI, C5, IRAP, FedRAMP packages.
- Online **agreements**: HIPAA BAA, GDPR DPA, etc.
- Review before onboarding for regulated workloads.

---

## 4. HIPAA-Eligible AI Services (examples)

Most mainstream AI services are HIPAA-eligible under a BAA, including:

- Amazon Bedrock (check per model eligibility)
- Amazon SageMaker (all major features)
- Amazon Comprehend / Comprehend Medical
- Amazon Transcribe / Transcribe Medical
- Amazon Polly
- Amazon Translate
- Amazon Textract
- Amazon Rekognition
- Amazon Kendra
- Amazon Lex
- Amazon Personalize
- Amazon Forecast
- Amazon Fraud Detector
- Amazon Lookout (Vision/Equipment/Metrics)
- Amazon HealthLake
- Amazon Q Business (in many regions)

For the exam, default to **yes, it's HIPAA eligible** unless the scenario says otherwise.

---

## 5. GDPR Considerations

- **Lawful basis** — consent, contract, legal obligation, legitimate interest, etc.
- **Data subject rights** — access, rectification, erasure ("right to be forgotten"), portability, objection.
- **DPIA** — Data Protection Impact Assessment for high-risk processing (AI often qualifies).
- **Automated decision-making** — Article 22 restricts purely automated decisions with legal/significant effects; allow human intervention.
- **Cross-border transfers** — Standard Contractual Clauses (SCCs) or EU-US Data Privacy Framework; AWS supports both; pick EU regions for EU data residency.

### For GenAI specifically
- Personal data in prompts counts as processing.
- Output can be personal data too.
- Retention, logging, and deletion policies must support subject requests.
- Training on personal data requires lawful basis.

---

## 6. EU AI Act (2024–2026 phase-in)

Risk-based tiers:
1. **Unacceptable risk** — banned (e.g., social scoring).
2. **High risk** — strict obligations (risk management, quality management, transparency, human oversight, logging, data governance, conformity assessment). Includes AI in employment, credit, education, essential services, law enforcement.
3. **Limited risk** — transparency (labeling AI interactions, deepfake marking).
4. **Minimal risk** — voluntary codes.

Also sets **General-Purpose AI (GPAI) model** obligations for providers of FMs (documentation, copyright compliance, summary of training data, systemic risk for very large models).

---

## 7. NIST AI Risk Management Framework (AI RMF)

Four functions:
1. **Govern** — policies, roles, accountability across AI lifecycle.
2. **Map** — understand context, risks.
3. **Measure** — evaluate risks (accuracy, fairness, robustness, security).
4. **Manage** — prioritize and respond to risks.

Use it as a scaffolding for an internal AI governance program.

---

## 8. ISO/IEC 42001 — AI Management System

First international standard for AI governance. Similar to ISO 27001 but for AI.

- Establish policies, objectives, risk controls.
- AI-specific clauses on impact assessment, data for AI systems, AI system lifecycle.
- AWS is **certified to ISO 42001**.

If a customer asks "does AWS have AI-specific certifications?" → yes, **ISO 42001**.

---

## 9. Audit Trail Requirements

Most frameworks require some variant of:
- **Access logs** (who did what, when): CloudTrail.
- **Data access logs**: S3 access logs; CloudWatch Logs.
- **Model invocation logs**: Bedrock → S3/CloudWatch.
- **Change logs**: AWS Config.
- **Review/approval records**: SageMaker Model Registry, Model Cards.

**AWS Audit Manager** maps AWS evidence to control frameworks (PCI DSS, HIPAA, GDPR, SOC 2, NIST AI RMF, ISO 42001).

---

## 10. Data Residency

- **Choose the region** first.
- Bedrock models are region-scoped; pick where your data must reside.
- Some regions have fewer services / models — plan accordingly.
- Cross-region replication and transfer must be explicit.
- AWS GovCloud (US) and AWS China regions for sovereign needs.

---

## 11. Privacy-Enhancing Techniques

- **PII redaction** — Comprehend, Guardrails, Macie.
- **Tokenization** — replace sensitive tokens with pseudonyms.
- **Differential privacy** — add calibrated noise to outputs / aggregates.
- **Federated learning** — train without centralizing raw data.
- **Homomorphic encryption** — compute on encrypted data (research-grade, not common on AWS AI services yet).
- **Secure enclaves** — **AWS Nitro Enclaves** for isolated processing.

---

## 12. Contractual Controls

- **BAA** for HIPAA.
- **DPA** for GDPR.
- **MSA / Order Forms** for enterprise terms.
- **Data Processing** between you and vendors that host models.
- **Acceptable Use Policy** for your users.

---

## 13. Exam Cues

| Scenario | Answer |
|----------|--------|
| "Where do I get the HIPAA BAA?" | **AWS Artifact** |
| "Automated compliance evidence for a framework" | **AWS Audit Manager** |
| "Record configuration drift of resources" | **AWS Config** |
| "Aggregate security findings across services" | **AWS Security Hub** |
| "Detect compromised credentials / unusual API calls" | **Amazon GuardDuty** |
| "AI-specific international standard AWS is certified against" | **ISO/IEC 42001** |
| "Standard for AI risk management from NIST" | **NIST AI Risk Management Framework** |
| "Tiered regulation of AI by risk level" | **EU AI Act** |
| "Need to support right-to-erasure" | **GDPR** |
| "Medical transcription with BAA" | **Transcribe Medical + BAA** |

> Next — [5.3 IAM for AI Services](./03-IAM-AI.md)
