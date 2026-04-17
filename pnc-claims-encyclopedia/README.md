# PnC Claims Encyclopedia

> A comprehensive, architect-grade reference for **Property & Casualty (P&C) Insurance Claims**: domain knowledge, processes, data formats and standards, automation, AI/ML, integration patterns, and end-to-end system architecture.

This encyclopedia consists of 25 deep-dive articles totaling **~55,000+ lines** of technical content. It is intended for **solutions architects, enterprise architects, business analysts, product managers, and senior engineers** building or modernizing P&C claims platforms.

---

## How to Use This Encyclopedia

| Audience | Suggested Reading Order |
|---|---|
| **Domain newcomers** | 01 → 02 → 04 → 05 → 13/14/15 (LOB specializations) |
| **Solutions architects** | 23 → 11 → 25 → 03 → 17 → 24 |
| **Data architects** | 03 → 20 → 24 → 11 → 18 |
| **Automation/AI leads** | 06 → 07 → 08 → 19 → 25 |
| **Operations leaders** | 02 → 05 → 09 → 10 → 16 → 20 |
| **Compliance/regulatory** | 12 → 08 → 21 → 22 → 18 |
| **Modernization programs** | 24 → 23 → 11 → 25 → 06 |

---

## Table of Contents

### Part I — Foundations of P&C Claims

| # | Article | Lines | Description |
|---|---|---:|---|
| 01 | [PnC Claims Domain: Overview & Taxonomy](./01-pnc-claims-domain-overview.md) | 1,749 | All lines of business, claim types, stakeholders, policy structure, coverages, industry bodies, glossary (125+ terms), entity model |
| 02 | [Claims Lifecycle: End-to-End Process Flows](./02-claims-lifecycle-process-flows.md) | 2,410 | Lifecycle stages with entry/exit criteria, state machines, BPMN-style flows for every LOB, SLAs, escalations, exception handling |
| 03 | [ACORD Standards & Data Models](./03-acord-standards-data-models.md) | 1,960 | ACORD XML, AL3, P&C data model, ISO ClaimSearch, NCCI EDI, HL7/X12, MISMO, JSON/REST, code lists, sample payloads |
| 04 | [FNOL: First Notice of Loss Deep Dive](./04-fnol-first-notice-of-loss.md) | 1,830 | Channels, 200+ field data model, validation, triage, duplicate detection, IVR/NLP, STP eligibility, complete API design |
| 05 | [Claims Investigation & Adjustment](./05-claims-investigation-adjustment.md) | 1,833 | Investigation types, adjuster roles, evidence handling, estimatics, BI evaluation, liability frameworks, expert engagement |

### Part II — Automation, AI & Specialized Operations

| # | Article | Lines | Description |
|---|---|---:|---|
| 06 | [Claims Automation & Straight-Through Processing](./06-claims-automation-stp.md) | 3,412 | Automation maturity model, BRMS (Drools/Camunda/Pega), RPA, IDP, auto-adjudication, 50+ rule pseudocode, ROI models |
| 07 | [AI/ML in Claims Processing](./07-ai-ml-claims-processing.md) | 2,358 | Computer vision, NLP, predictive models, MLOps, XAI, bias/fairness, conversational AI, vendor landscape, feature stores |
| 08 | [Fraud Detection & SIU Operations](./08-fraud-detection-siu.md) | 2,006 | Fraud taxonomy, 100+ red flags, SNA/link analysis, image forensics, ISO ClaimSearch, NICB, real-time fraud scoring |
| 09 | [Subrogation & Recovery](./09-subrogation-recovery.md) | 2,001 | Subrogation lifecycle, ML scoring, Arbitration Forums e-filing, Copart/IAA salvage, MSA, made-whole doctrine, GAAP accounting |
| 10 | [Reserves & Financial Management](./10-reserves-financial-management.md) | 2,124 | Case/IBNR/LAE reserves, chain ladder/BF/Cape Cod methods, payment rails, 1099, SAP vs GAAP, Schedule P, GL integration |

### Part III — Architecture, Integration & Compliance

| # | Article | Lines | Description |
|---|---|---:|---|
| 11 | [Integration Patterns & Enterprise Architecture](./11-integration-patterns-architecture.md) | 4,465 | ESB, API gateways, event-driven (Kafka), canonical models, Guidewire/Duck Creek/CCC integration, Saga, circuit breaker, mTLS |
| 12 | [Regulatory Compliance & Reporting](./12-regulatory-compliance-reporting.md) | 2,403 | UCSPA, NAIC market conduct, HIPAA, FCRA, OFAC, AML, 50-state matrix, Schedule P, data retention, e-discovery |

### Part IV — Lines of Business Specialization

| # | Article | Lines | Description |
|---|---|---:|---|
| 13 | [Auto Claims Specialization](./13-auto-claims-specialization.md) | 1,959 | All auto coverages, estimatics deep dive (CCC/Mitchell/Audatex), total loss, salvage, BI/PIP/UM, telematics, ADAS, rideshare |
| 14 | [Property Claims Specialization](./14-property-claims-specialization.md) | 1,596 | HO-1 through HO-8, DP forms, commercial property, peril-specific handling, Xactimate ESX, ALE, mortgagee handling |
| 15 | [Liability & Commercial Lines Claims](./15-liability-commercial-claims.md) | 1,822 | CGL Coverage A/B/C, occurrence vs claims-made, products/E&O/D&O/EPLI/Cyber, ROR letters, Lloyd's market, UTBMS e-billing |
| 16 | [Catastrophe (CAT) Claims Management](./16-catastrophe-claims-management.md) | 2,595 | ISO PCS, CAT organization, surge staffing, drone/satellite imagery, NFIP, earthquake, wildfire, reinsurance triggers |
| 21 | [Workers Compensation Claims](./21-workers-compensation-claims.md) | 3,049 | FROI/SROI, IAIABC EDI, AOE/COE, AWW, NCCI, AMA Guides, MSA, state benefit tables (CA/TX/FL/NY/IL), Section 32 |

### Part V — Cross-Functional Operations

| # | Article | Lines | Description |
|---|---|---:|---|
| 17 | [Vendor & Partner Ecosystem](./17-vendor-partner-ecosystem.md) | 2,152 | Claims systems (Guidewire/Duck Creek/Majesco/Insurity), CCC/Mitchell/Audatex/Xactimate, salvage, IA firms, legal/medical |
| 18 | [Document Management & Correspondence](./18-document-management-correspondence.md) | 2,353 | IDP pipeline, OCR (Textract/Form Recognizer/Document AI), classification, ECM platforms, template engine, print vendors |
| 19 | [Customer Experience & Digital Claims](./19-customer-experience-digital-claims.md) | 1,740 | Omnichannel journey, mobile FNOL, chatbots, video claims, self-service, sentiment, ADA/WCAG, multi-language |
| 20 | [Claims Analytics, BI & Reporting](./20-claims-analytics-bi.md) | 1,800 | DW star schema, KPI catalog, dashboards (operational/executive), advanced analytics, real-time streaming, cloud BI stacks |
| 22 | [Reinsurance & Claims](./22-reinsurance-claims.md) | 2,177 | Treaty/facultative, bordereaux, XOL, Lloyd's/ECF/CLASS/Vitesse, commutation NPV, Schedule F, ceded reserve data model |

### Part VI — Architecture & Modernization

| # | Article | Lines | Description |
|---|---|---:|---|
| 23 | [Claims System Architecture Reference](./23-claims-system-architecture-reference.md) | 1,818 | Reference architecture, microservices decomposition, polyglot persistence, CQRS, event sourcing, K8s, AWS/Azure blueprints |
| 24 | [Data Migration & Legacy Modernization](./24-data-migration-legacy-modernization.md) | 1,532 | Strangler fig, data profiling, ETL pipelines, validation/reconciliation, cutover runbook, co-existence patterns |
| 25 | [API Design & Microservices for Claims](./25-api-design-microservices-claims.md) | 2,151 | REST/GraphQL/gRPC, complete OpenAPI 3.0 Claims API, 14+ microservices deep dive, service mesh, CloudEvents, Pact testing |

---

## Coverage Map (What's Inside)

### Domain & Process
- All P&C **lines of business**: Personal/Commercial Auto, Homeowners, Renters, Commercial Property, GL, Professional Liability, Workers Comp, Umbrella, Marine, Aviation, Surety, Fidelity
- Complete **claims lifecycle**: FNOL → Assignment → Investigation → Evaluation → Negotiation → Settlement → Payment → Subrogation → Close
- **State machines**, BPMN flows, and decision tables for every major scenario
- **Stakeholder roles**: Insured, Claimant, Adjuster (Staff/IA/Public), Examiner, SIU, TPA, Attorney, Medical Provider, Repair Shop, Contractor, Salvage Vendor

### Data Standards & Formats
- **ACORD** XML, AL3, P&C Data Model
- **ISO** ClaimSearch, ECF, Statistical Reporting
- **NCCI / IAIABC** EDI for Workers Comp (FROI/SROI)
- **NAIC** data calls and market conduct
- **HL7 FHIR** and **X12** (837/835/277/278) for medical
- **MISMO** for property/mortgage
- Reference code lists (cause of loss, body part, injury nature, occupation, NCCI class codes)
- 50+ sample XML/JSON/protobuf payloads

### Automation & AI
- **Business rules engines** (Drools, Camunda DMN, Pega), 50+ rule examples
- **RPA** (UiPath, Blue Prism, Automation Anywhere)
- **Intelligent Document Processing** (Textract, Form Recognizer, Document AI)
- **Computer vision** for damage estimation (CCC, Tractable, Snapsheet)
- **NLP** for narrative analysis, medical record summarization
- **Predictive models**: severity, litigation propensity, settlement amount, claim duration
- **Fraud detection**: rules + ML + SNA + image forensics
- **MLOps** lifecycle, XAI, bias detection, drift monitoring

### Integration & Architecture
- **ESB / API Gateway / Event-Driven** patterns
- **Microservices** decomposition with bounded contexts
- **CQRS / Event Sourcing / Saga** patterns
- **Polyglot persistence** (PostgreSQL, MongoDB, Neo4j, Elasticsearch, Redis)
- **Cloud reference architectures** (AWS, Azure, GCP)
- **Kubernetes**, service mesh (Istio), Helm
- **Security**: OAuth2/OIDC, mTLS, RBAC/ABAC, PII/PHI, audit
- **OpenAPI 3.0** Claims API specification
- **CloudEvents** event schemas, **gRPC/protobuf** definitions

### Compliance & Reporting
- **Unfair Claims Settlement Practices Acts** (state-by-state)
- **Bad faith** exposure and prevention
- **HIPAA, FCRA, OFAC, AML, GLBA, CCPA, GDPR**
- **Schedule P, Annual Statement, NAIC** reporting
- **State fraud bureau** notifications
- **Document retention** and e-discovery

### Vendor Ecosystem
- **Claims systems**: Guidewire ClaimCenter, Duck Creek Claims, Majesco, Insurity, Snapsheet, BriteCore, OneShield
- **Estimatics**: CCC ONE, Mitchell, Audatex/Solera, Xactimate
- **Salvage**: Copart, IAA
- **IA firms**: Crawford, Sedgwick, McLarens, EFI Global
- **Fraud**: Shift Technology, FRISS, SAS, BAE NetReveal
- **Data**: ISO/Verisk, LexisNexis, CoreLogic, TransUnion
- **Document/ECM**: OnBase, FileNet, Alfresco, Box
- **Payment**: One Inc, VPay, CheckFreePay
- **Telematics, drone/aerial, weather data** providers

---

## Statistics

- **25 articles**
- **~55,000+ lines** of markdown
- **~3.0 MB** of technical content
- **600+ data tables**
- **300+ ASCII diagrams** (flows, state machines, ERDs, architecture)
- **400+ code/payload samples** (JSON, XML, YAML, SQL, pseudocode)
- **125+ glossary terms** in Article 01
- **50+ business rule examples** in Article 06
- **200+ ML features** catalogued in Article 07
- **100+ fraud red flags** in Article 08
- **50-state regulatory matrix** in Article 12
- **14+ microservices** deeply specified in Article 25

---

## Conventions Used

- **ASCII diagrams** are used for portability across rendering environments.
- **Code blocks** include language tags (`json`, `xml`, `yaml`, `sql`, `python`, `pseudocode`).
- **Field-level data tables** typically include columns for *Field*, *Type*, *Length/Format*, *Required?*, *Description*, *Source/Validation*.
- **Process flows** follow a consistent format: pre-conditions → trigger → steps → post-conditions → exceptions → SLA.
- **API specs** use **OpenAPI 3.0** style.
- **Event schemas** use **CloudEvents 1.0** envelope.

---

## Related Materials in This Workspace

- `PnC_claims.md` — Foundational primer (in parent or this folder)
- `CLAIMS_WORKFLOWS.md` — Workflow companion document
- `presentation.html` — Executive-style slide deck on PnC claims

---

## Versioning & Maintenance

This encyclopedia reflects industry practice and standards as of **2026**. Specific items that change frequently and should be re-validated before use:

| Area | Refresh Cadence |
|---|---|
| State workers comp benefit rates | Annual (effective Jan 1 / July 1) |
| ACORD message versions | Quarterly (per ACORD release calendar) |
| NCCI / IAIABC EDI versions | Annual |
| NAIC reporting requirements | Annual (Annual Statement filing) |
| Cloud platform service names | Quarterly (AWS/Azure/GCP product changes) |
| Vendor product features | As-needed per vendor releases |

---

## License & Use

These materials were generated as an architectural reference. Verify all regulatory, actuarial, and legal content against current statutes and authoritative sources before acting. Do not use as a substitute for legal, actuarial, or regulatory counsel.

---

*End of README*
