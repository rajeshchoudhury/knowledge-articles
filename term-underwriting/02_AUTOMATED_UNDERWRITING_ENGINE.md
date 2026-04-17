# Automated Underwriting Engine — Architecture Deep Dive

> A solutions architect's comprehensive guide to designing, building, and operating an automated underwriting system for term life insurance. Covers architecture patterns, decision engines, data pipelines, scoring models, API design, and deployment strategies.

---

## Table of Contents

1. [Evolution of Automated Underwriting](#1-evolution-of-automated-underwriting)
2. [Target Operating Model](#2-target-operating-model)
3. [Reference Architecture](#3-reference-architecture)
4. [Core Components Deep Dive](#4-core-components-deep-dive)
5. [Decision Engine Architecture](#5-decision-engine-architecture)
6. [Data Ingestion & Normalization Pipeline](#6-data-ingestion--normalization-pipeline)
7. [Rules vs. Models — Hybrid Approach](#7-rules-vs-models--hybrid-approach)
8. [Scoring & Risk Classification Engine](#8-scoring--risk-classification-engine)
9. [Evidence Orchestration Engine](#9-evidence-orchestration-engine)
10. [Straight-Through Processing (STP) Design](#10-straight-through-processing-stp-design)
11. [API Design for Underwriting](#11-api-design-for-underwriting)
12. [Event-Driven Architecture & CQRS](#12-event-driven-architecture--cqrs)
13. [State Machine for Case Lifecycle](#13-state-machine-for-case-lifecycle)
14. [Audit, Explainability & Compliance](#14-audit-explainability--compliance)
15. [Performance, Scalability & Resilience](#15-performance-scalability--resilience)
16. [Vendor Platforms & Build vs. Buy](#16-vendor-platforms--build-vs-buy)
17. [Implementation Roadmap](#17-implementation-roadmap)

---

## 1. Evolution of Automated Underwriting

### 1.1 Generations of Underwriting Technology

| Generation | Era | Technology | Automation Level |
|-----------|-----|-----------|-----------------|
| **Gen 1: Manual** | Pre-2000 | Paper files, physical mail, manual review | 0% STP |
| **Gen 2: Workflow** | 2000–2010 | Case management systems, document imaging, workflow routing | 5–10% STP |
| **Gen 3: Rules-Based** | 2010–2018 | Rules engines (Drools, ILOG), triage automation, auto-requirements | 15–30% STP |
| **Gen 4: Data-Driven** | 2018–2023 | Accelerated UW, predictive models, third-party data (Rx, credit), reflexive apps | 40–60% STP |
| **Gen 5: AI-Native** | 2024+ | GenAI-assisted, real-time decisioning, continuous underwriting, embedded APIs | 60–80% STP target |

### 1.2 Key Metrics for Automated UW Success

| Metric | Traditional UW | Gen 4 Automated | Gen 5 Target |
|--------|---------------|----------------|--------------|
| **STP Rate** | 0% | 40–60% | 70–80% |
| **Cycle Time (STP)** | N/A | Minutes | Seconds |
| **Cycle Time (Full UW)** | 25–45 days | 10–20 days | 5–10 days |
| **Cost per Application** | $300–$500 | $100–$200 | $50–$100 |
| **Placement Rate** | 65–75% | 75–85% | 80–90% |
| **Mortality A/E** | 90–100% | 90–105% | 90–100% |

---

## 2. Target Operating Model

### 2.1 Tiered Processing Model

```
╔════════════════════════════════════════════════════════════════════════╗
║                  TIERED PROCESSING MODEL                              ║
╚════════════════════════════════════════════════════════════════════════╝

                    100% of Applications
                           │
                           ▼
              ┌────────────────────────┐
              │   INTAKE & TRIAGE      │
              │   (Real-time scoring)  │
              └────────────┬───────────┘
                           │
           ┌───────────────┼───────────────┐
           ▼               ▼               ▼
  ┌──────────────┐ ┌──────────────┐ ┌──────────────┐
  │   TIER 1     │ │   TIER 2     │ │   TIER 3     │
  │   AUTO-ISSUE │ │   AUGMENTED  │ │   FULL UW    │
  │              │ │   UW         │ │              │
  │  40-60% of   │ │  25-35% of   │ │  15-25% of   │
  │  applications│ │  applications│ │  applications│
  │              │ │              │ │              │
  │  STP:        │ │  AI-assisted │ │  Human       │
  │  Rules +     │ │  with human  │ │  underwriter │
  │  Models      │ │  review of   │ │  full review │
  │  auto-decide │ │  edge cases  │ │              │
  │              │ │              │ │  Complex     │
  │  Minutes     │ │  Hours-Days  │ │  medical,    │
  │              │ │              │ │  financial,  │
  │              │ │              │ │  large face  │
  └──────────────┘ └──────────────┘ └──────────────┘
```

### 2.2 Processing Paths

```
APPLICATION ──▶ [Accelerated UW Eligible?]
                    │
        ┌───────────┴───────────┐
        ▼                       ▼
   ┌─────────┐            ┌─────────────┐
   │  YES    │            │   NO        │
   │         │            │             │
   │ Path A: │            │ Path B:     │
   │ Digital │            │ Traditional │
   │ Data    │            │ Full UW     │
   │ Only    │            │ (Fluids +   │
   │         │            │  Exam)      │
   └────┬────┘            └──────┬──────┘
        │                        │
        ▼                        ▼
   ┌─────────────┐         ┌─────────────┐
   │ Score using: │         │ Order:      │
   │ • App data  │         │ • Paramedic │
   │ • Rx history│         │ • Labs/BPL  │
   │ • MIB       │         │ • ECG       │
   │ • MVR       │         │ • APS       │
   │ • Credit    │         │ • Inspection│
   │ • Behavioral│         │ • Financial │
   └──────┬──────┘         └──────┬──────┘
          │                       │
     [Score meets                 │
      auto-decision              │
      threshold?]                │
        │                        │
   ┌────┴────┐                   │
   ▼         ▼                   ▼
 [AUTO]   [REFER to           [HUMAN UW
  ISSUE    Human UW]           REVIEW]
```

---

## 3. Reference Architecture

```
╔════════════════════════════════════════════════════════════════════════════════╗
║              AUTOMATED UNDERWRITING — REFERENCE ARCHITECTURE                  ║
╚════════════════════════════════════════════════════════════════════════════════╝

┌──────────────────────────────── CHANNELS ─────────────────────────────────────┐
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌───────────────┐ │
│  │ Agent    │  │ DTC Web  │  │ Mobile   │  │ Partner  │  │ BGA/Broker    │ │
│  │ Platform │  │ Portal   │  │ App      │  │ API      │  │ Portal        │ │
│  └────┬─────┘  └────┬─────┘  └────┬─────┘  └────┬─────┘  └───────┬───────┘ │
└───────┼──────────────┼──────────────┼──────────────┼───────────────┼─────────┘
        └──────────────┴──────────────┴──────┬───────┴───────────────┘
                                             │
                                     ┌───────▼───────┐
                                     │  API GATEWAY   │
                                     │  (Kong / AWS)  │
                                     └───────┬───────┘
                                             │
┌────────────────────────────── SERVICE LAYER ──────────────────────────────────┐
│                                                                               │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐  ┌──────────────────┐ │
│  │ APPLICATION  │  │ EVIDENCE     │  │ DECISION     │  │ CASE MANAGEMENT  │ │
│  │ SERVICE      │  │ ORCHESTRATOR │  │ ENGINE       │  │ SERVICE          │ │
│  │              │  │              │  │              │  │                  │ │
│  │ • Intake     │  │ • Order mgmt │  │ • Rules      │  │ • Workflow       │ │
│  │ • Validation │  │ • Vendor API │  │ • ML Models  │  │ • Assignments    │ │
│  │ • Reflexive  │  │ • Response   │  │ • Scoring    │  │ • Activities     │ │
│  │   questions  │  │   normalize  │  │ • Classify   │  │ • Notes/Docs     │ │
│  │ • E-Sign     │  │ • Status     │  │ • Decision   │  │ • SLA tracking   │ │
│  └──────┬───────┘  └──────┬───────┘  └──────┬───────┘  └────────┬─────────┘ │
│         │                 │                 │                    │           │
│  ┌──────▼───────┐  ┌──────▼───────┐  ┌──────▼───────┐  ┌───────▼────────┐  │
│  │ PRICING      │  │ REINSURANCE  │  │ COMPLIANCE   │  │ NOTIFICATION   │  │
│  │ SERVICE      │  │ SERVICE      │  │ SERVICE      │  │ SERVICE        │  │
│  │              │  │              │  │              │  │                │  │
│  │ • Quote      │  │ • Retention  │  │ • State rules│  │ • Agent notify │  │
│  │ • Premium    │  │ • Auto cede  │  │ • AML/OFAC   │  │ • Applicant    │  │
│  │   calculate  │  │ • Facultativ │  │ • Suitability│  │ • Email/SMS    │  │
│  │ • Modal      │  │ • Bordereaux │  │ • Replacement│  │ • Status push  │  │
│  └──────────────┘  └──────────────┘  └──────────────┘  └────────────────┘  │
│                                                                               │
├───────────────────────────── EVENT BUS (Kafka) ───────────────────────────────┤
│                                                                               │
│  Topics: app.submitted, evidence.ordered, evidence.received,                 │
│          decision.rendered, case.referred, policy.issued, case.closed         │
│                                                                               │
├───────────────────────────── DATA LAYER ──────────────────────────────────────┤
│                                                                               │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐  ┌──────────────────┐ │
│  │ UW Database  │  │ Document     │  │ Analytics    │  │ ML Model         │ │
│  │ (Postgres/   │  │ Store        │  │ (Snowflake)  │  │ Registry         │ │
│  │  DynamoDB)   │  │ (S3)         │  │              │  │ (SageMaker/      │ │
│  │              │  │              │  │              │  │  MLflow)         │ │
│  └──────────────┘  └──────────────┘  └──────────────┘  └──────────────────┘ │
│                                                                               │
├───────────────────────────── EXTERNAL VENDORS ────────────────────────────────┤
│                                                                               │
│  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐          │
│  │ MIB      │ │ Rx Check │ │ MVR      │ │ Credit   │ │ ExamOne  │          │
│  │ (codes)  │ │(IntelliSc│ │(LexisNex)│ │(LN Risk) │ │(labs/    │          │
│  │          │ │  ript)   │ │          │ │          │ │ paramed) │          │
│  └──────────┘ └──────────┘ └──────────┘ └──────────┘ └──────────┘          │
│  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐          │
│  │ Criminal │ │ Identity │ │ APS      │ │ Rein-    │ │ Payment  │          │
│  │ (LN)     │ │ (KBA)    │ │ Retrieval│ │ surers   │ │ Gateway  │          │
│  │          │ │          │ │ (Clareto)│ │ (RGA/    │ │ (Stripe) │          │
│  │          │ │          │ │          │ │  SwissRe)│ │          │          │
│  └──────────┘ └──────────┘ └──────────┘ └──────────┘ └──────────┘          │
└───────────────────────────────────────────────────────────────────────────────┘
```

---

## 4. Core Components Deep Dive

### 4.1 Application Intake Service

**Responsibilities:**
- Accept application data from all channels (API, web form, agent platform)
- Validate input against schema (ACORD TXLife or custom JSON)
- Enrich with derived fields (age calculation, BMI, income multiples)
- Execute reflexive question logic
- Manage e-signature workflow
- Emit `app.submitted` event

**Key Design Decisions:**

| Decision | Recommendation | Rationale |
|----------|---------------|-----------|
| API format | REST + JSON (ACORD-aligned schema) | Industry standard; mobile-friendly |
| Validation | JSON Schema + custom business validation | Separate structural from business rules |
| Reflexive engine | Front-end-driven with server-side rule definition | Responsive UX; centrally managed rules |
| E-signature | Integrate DocuSign/OneSpan via SDK | Compliance; audit trail; mobile support |
| Idempotency | Application UUID generated client-side | Prevent duplicate submissions |

**Application Data Model (Core Entities):**

```
Application
  ├── ApplicationID (UUID)
  ├── Status (Draft|Submitted|InUW|Issued|Declined|Withdrawn)
  ├── Channel (Agent|DTC|Partner|Broker)
  ├── SubmittedDate
  ├── Applicant
  │    ├── FirstName, LastName, MiddleName, Suffix
  │    ├── DOB, Gender, SSN (encrypted)
  │    ├── Address (Street, City, State, ZIP, Country)
  │    ├── Phone, Email
  │    ├── Citizenship, ResidencyStatus
  │    ├── Occupation { Title, Duties, Industry, EmployerName, Income }
  │    └── Height, Weight, BMI (calculated)
  ├── Coverage
  │    ├── ProductCode (T10|T15|T20|T25|T30)
  │    ├── FaceAmount
  │    ├── Riders[] { RiderCode, RiderAmount }
  │    ├── PaymentMode (Monthly|Quarterly|SemiAnnual|Annual)
  │    └── RequestedEffectiveDate
  ├── Beneficiaries[]
  │    ├── Name, Relationship, Percentage, Type (Primary|Contingent)
  │    └── TrustInfo (if applicable)
  ├── Owner (if different from insured)
  ├── MedicalHistory
  │    ├── Questions[] { QuestionCode, Answer (Y/N), Details }
  │    ├── Medications[] { Name, Dosage, Frequency, Condition }
  │    └── FamilyHistory[] { Relation, Condition, AgeOfOnset, AgeAtDeath }
  ├── LifestyleHistory
  │    ├── TobaccoUse { Ever, Current, LastUseDate, Type, Frequency }
  │    ├── AlcoholUse { Frequency, Quantity }
  │    ├── DrugUse { Type, LastUseDate }
  │    ├── DrivingRecord { DUI, Violations, Suspensions }
  │    ├── Avocations[] { Activity, Frequency }
  │    ├── ForeignTravel[] { Country, Duration, Purpose }
  │    └── Aviation { PilotType, HoursFlown, AircraftType }
  ├── FinancialInfo
  │    ├── AnnualIncome, NetWorth
  │    ├── ExistingInsurance[] { Carrier, FaceAmount, Year }
  │    ├── TotalInForce (existing + applied)
  │    ├── Purpose (IncomeReplacement|Mortgage|KeyPerson|BuySell|Estate)
  │    └── Replacement { IsReplacement, ExistingPolicyNumbers }
  ├── AgentReport
  │    ├── AgentID, AgentName
  │    ├── HowIntroduced, Relationship, PhysicalObservations
  │    └── Comments
  └── Authorizations
       ├── HIPAAAuth { Signed, Date }
       ├── MIBAuth { Signed, Date }
       └── ConsumerReportAuth { Signed, Date }
```

### 4.2 Evidence Orchestration Engine

The evidence orchestrator manages the ordering, tracking, and collection of all underwriting evidence.

**Orchestration Pattern: Saga with Parallel Fan-Out**

```
app.submitted
     │
     ▼
┌─────────────────────────────────────────────────────────┐
│  REQUIREMENTS DETERMINATION                              │
│                                                          │
│  Input: Age, FaceAmount, Channel, AppAnswers             │
│  Output: RequiredEvidence[] with priority and vendor      │
│                                                          │
│  Logic: Requirements Grid + Reflexive Triggers           │
└──────────────────────────┬──────────────────────────────┘
                           │
              ┌────────────┼────────────┬────────────┐
              ▼            ▼            ▼            ▼
         ┌─────────┐ ┌─────────┐ ┌─────────┐ ┌─────────┐
         │ MIB     │ │ Rx Chk  │ │ MVR     │ │ Credit  │
         │ Order   │ │ Order   │ │ Order   │ │ Order   │
         │ (async) │ │ (async) │ │ (async) │ │ (async) │
         └────┬────┘ └────┬────┘ └────┬────┘ └────┬────┘
              │            │            │            │
              │     All return in seconds (real-time APIs)
              │            │            │            │
              └────────────┼────────────┼────────────┘
                           │
                           ▼
              ┌────────────────────────┐
              │  CONDITIONAL ORDERING  │
              │                        │
              │  Based on results:     │
              │  • MIB codes → APS?    │
              │  • Rx flags → Labs?    │
              │  • Score → Exam?       │
              └────────────┬───────────┘
                           │
              ┌────────────┼────────────┐
              ▼            ▼            ▼
         ┌─────────┐ ┌─────────┐ ┌─────────┐
         │ Paramed │ │ APS     │ │ Inspect │
         │ + Labs  │ │ Order   │ │ Report  │
         │ (3-7d)  │ │ (10-45d)│ │ (3-10d) │
         └────┬────┘ └────┬────┘ └────┬────┘
              │            │            │
              │   Each result triggers re-evaluation
              │   of whether additional evidence needed
              │            │            │
              └────────────┼────────────┘
                           │
                           ▼
              ┌────────────────────────┐
              │  ALL EVIDENCE COMPLETE │
              │  → DECISION ENGINE     │
              └────────────────────────┘
```

**Vendor Integration Patterns:**

| Vendor Type | Integration | Response Time | Retry Strategy |
|------------|------------|---------------|----------------|
| MIB | Real-time API (TXLife XML) | <3 seconds | 2 retries, 5s timeout |
| Rx (IntelliScript) | Real-time API (REST/XML) | <5 seconds | 2 retries, 10s timeout |
| MVR | Near-real-time (REST) | 10–60 seconds | Async callback or poll |
| Credit Score | Real-time API | <3 seconds | 2 retries, 5s timeout |
| Criminal | Near-real-time | 5–30 seconds | Async callback |
| Identity (KBA) | Real-time | <3 seconds | Interactive flow |
| Paramedical/Labs | Order API → Results via file/API | 3–7 days | Daily status poll |
| APS | Order API → Results via fax/portal | 10–45 days | Weekly follow-up |
| Inspection | Order API → Results via API/file | 3–10 days | Daily status poll |

### 4.3 Decision Engine

The decision engine is the **core brain** of automated underwriting. It combines rules and models to produce an underwriting decision.

**Decision Engine Architecture:**

```
┌─────────────────────────────────────────────────────────────────┐
│                      DECISION ENGINE                             │
│                                                                  │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │  INPUT: Unified Risk Profile                               │  │
│  │                                                            │  │
│  │  Application data + All evidence results (normalized)      │  │
│  │  + Derived features + External scores                      │  │
│  └───────────────────────────────────────────────────────────┘  │
│                              │                                   │
│              ┌───────────────┼───────────────┐                  │
│              ▼               ▼               ▼                  │
│  ┌────────────────┐ ┌──────────────┐ ┌──────────────────┐     │
│  │  RULES ENGINE  │ │  ML SCORING  │ │  MEDICAL RULES   │     │
│  │  (Drools/      │ │  MODELS      │ │  (Impairment     │     │
│  │   DMN/Custom)  │ │              │ │   Guide Engine)  │     │
│  │                │ │  • Mortality  │ │                  │     │
│  │  • Eligibility │ │    predictor │ │  • 500+ condition│     │
│  │  • Knock-outs  │ │  • Fraud     │ │    assessments   │     │
│  │  • Requirements│ │    score     │ │  • Debit/credit  │     │
│  │  • Build chart │ │  • Accel UW  │ │    calculations  │     │
│  │  • Lab limits  │ │    eligiblty │ │  • Lab interpret  │     │
│  │  • Financial   │ │  • Risk class│ │  • Rx interpret   │     │
│  │    justificatn │ │    predictor │ │                  │     │
│  └───────┬────────┘ └──────┬───────┘ └────────┬─────────┘     │
│          │                 │                   │                │
│          └─────────────────┼───────────────────┘                │
│                            ▼                                    │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │  AGGREGATION & CLASSIFICATION                              │  │
│  │                                                            │  │
│  │  Combine all rule outcomes + model scores + medical        │  │
│  │  debits/credits to determine:                              │  │
│  │                                                            │  │
│  │  1. Insurability (Accept / Decline / Postpone)            │  │
│  │  2. Risk Class (PFP / PF / SP / STD / Smoker classes)     │  │
│  │  3. Table Rating (if substandard)                          │  │
│  │  4. Flat Extras (temporary/permanent, amount)              │  │
│  │  5. Exclusions (if any)                                    │  │
│  │  6. Face Amount (approved vs. applied)                     │  │
│  │  7. Confidence Score (for auto-issue vs. refer threshold)  │  │
│  └───────────────────────────────────────────────────────────┘  │
│                              │                                   │
│                              ▼                                   │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │  DECISION OUTPUT                                           │  │
│  │                                                            │  │
│  │  {                                                         │  │
│  │    "decision": "APPROVE",                                  │  │
│  │    "riskClass": "PREFERRED",                               │  │
│  │    "tableRating": null,                                    │  │
│  │    "flatExtras": [],                                       │  │
│  │    "exclusions": [],                                       │  │
│  │    "approvedFaceAmount": 500000,                           │  │
│  │    "confidenceScore": 0.94,                                │  │
│  │    "autoIssueEligible": true,                              │  │
│  │    "reasonCodes": ["RC001", "RC002"],                      │  │
│  │    "debitCredits": {                                       │  │
│  │      "medical": -15,                                       │  │
│  │      "build": 0,                                           │  │
│  │      "lifestyle": 0,                                       │  │
│  │      "family": +10,                                        │  │
│  │      "net": -5                                             │  │
│  │    },                                                      │  │
│  │    "auditTrail": [ ... ]                                   │  │
│  │  }                                                         │  │
│  └───────────────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────────────────┘
```

---

## 5. Decision Engine Architecture

### 5.1 Rules Engine Selection

| Engine | Type | Strengths | Weaknesses |
|--------|------|-----------|------------|
| **Drools** | Open-source BRMS (Java) | Powerful rule language (DRL), decision tables, DMN support, complex event processing | Steep learning curve; JVM-only |
| **IBM ODM** | Commercial BRMS | Enterprise-grade; business-user rule authoring; versioning; testing | Expensive; heavy |
| **FICO Blaze Advisor** | Commercial | Strong in scoring + rules combo; insurance industry focus | Expensive; proprietary |
| **DMN (Decision Model & Notation)** | Standard | Vendor-neutral; visual decision tables; good for business rules | Less flexible for complex logic |
| **Custom (Python/Java)** | In-house | Full control; optimized for specific needs; easier ML integration | Maintenance burden; no rule governance UI |
| **AWS Step Functions + Lambda** | Serverless | Scalable; event-driven; pay-per-use | Vendor lock-in; state management complexity |
| **Camunda** | Open-source BPM | DMN + BPMN; strong workflow; good UI | More suited to workflow than pure rules |

### 5.2 Rule Categories

| Category | Volume | Volatility | Example |
|----------|--------|-----------|---------|
| **Eligibility Rules** | ~50 rules | Low (quarterly) | Age limits, face amount limits, state availability |
| **Knock-Out Rules** | ~100 rules | Low | Terminal illness, active cancer treatment, felony conviction |
| **Evidence Requirement Rules** | ~200 rules | Medium (monthly) | Age + face amount → required evidence |
| **Build Chart Rules** | ~100 rules | Low | Height/weight → BMI → risk class ceiling |
| **Lab Interpretation Rules** | ~500 rules | Medium | Cholesterol range → debit/credit; HbA1c → diabetes rating |
| **Rx Interpretation Rules** | ~1,000 rules | High (monthly) | Medication → implied condition → assessment |
| **Medical Impairment Rules** | ~2,000 rules | Medium | Condition + severity + duration → rating |
| **Financial Justification Rules** | ~100 rules | Low | Income × multiple → max face amount |
| **Risk Classification Rules** | ~200 rules | Low | Aggregate debits/credits → risk class assignment |
| **Accelerated UW Eligibility** | ~150 rules | High (weekly) | Criteria for auto-issue without fluids |

### 5.3 Decision Table Example (DMN)

**Build Chart Decision Table:**

```
┌────────┬────────┬──────────────┬───────────────┬──────────────────┐
│ Gender │  Age   │  BMI Range   │ Max Risk Class│  Debit Points    │
├────────┼────────┼──────────────┼───────────────┼──────────────────┤
│ M      │ 18-45  │ 18.5 - 25.0  │ Pref Plus     │  0               │
│ M      │ 18-45  │ 25.1 - 28.0  │ Preferred     │  +10             │
│ M      │ 18-45  │ 28.1 - 30.0  │ Std Plus      │  +25             │
│ M      │ 18-45  │ 30.1 - 33.0  │ Standard      │  +40             │
│ M      │ 18-45  │ 33.1 - 38.0  │ Table B       │  +75             │
│ M      │ 18-45  │ 38.1 - 43.0  │ Table D       │  +125            │
│ M      │ 18-45  │ > 43.0       │ Decline       │  N/A             │
│ M      │ 46-55  │ 18.5 - 26.0  │ Pref Plus     │  0               │
│ M      │ 46-55  │ 26.1 - 29.0  │ Preferred     │  +10             │
│ ...    │ ...    │ ...          │ ...           │  ...             │
│ F      │ 18-45  │ 18.0 - 24.0  │ Pref Plus     │  0               │
│ F      │ 18-45  │ 24.1 - 27.5  │ Preferred     │  +10             │
│ ...    │ ...    │ ...          │ ...           │  ...             │
└────────┴────────┴──────────────┴───────────────┴──────────────────┘
```

---

## 6. Data Ingestion & Normalization Pipeline

### 6.1 The Problem

Evidence arrives from multiple vendors in different formats:
- MIB: ACORD TXLife XML with proprietary code sets
- Rx: Vendor-specific XML or JSON
- MVR: State-specific formats via LexisNexis
- Labs: HL7 ORU messages or proprietary CSV
- APS: Unstructured PDF/fax (requires NLP/OCR)
- Credit: Vendor-specific JSON

### 6.2 Normalization Architecture

```
┌──────────────────────────────────────────────────────────────────┐
│                   DATA NORMALIZATION PIPELINE                     │
│                                                                  │
│  RAW VENDOR    ──▶  ADAPTER     ──▶  CANONICAL   ──▶  FEATURE   │
│  RESPONSE           LAYER            MODEL            STORE      │
│                                                                  │
│  ┌──────────┐    ┌──────────┐    ┌──────────┐    ┌──────────┐  │
│  │ MIB XML  │───▶│ MIB      │───▶│          │    │          │  │
│  │          │    │ Adapter  │    │          │    │          │  │
│  └──────────┘    └──────────┘    │          │    │          │  │
│  ┌──────────┐    ┌──────────┐    │ Unified  │    │ Feature  │  │
│  │ Rx JSON  │───▶│ Rx       │───▶│ Risk     │───▶│ Vectors  │  │
│  │          │    │ Adapter  │    │ Profile  │    │ for ML   │  │
│  └──────────┘    └──────────┘    │ (JSON)   │    │ Models   │  │
│  ┌──────────┐    ┌──────────┐    │          │    │          │  │
│  │ Labs HL7 │───▶│ Lab      │───▶│          │    │          │  │
│  │          │    │ Adapter  │    │          │    │          │  │
│  └──────────┘    └──────────┘    └──────────┘    └──────────┘  │
│  ┌──────────┐    ┌──────────┐                                   │
│  │ APS PDF  │───▶│ NLP/OCR  │───▶ (structured extraction)      │
│  │          │    │ Pipeline │                                   │
│  └──────────┘    └──────────┘                                   │
└──────────────────────────────────────────────────────────────────┘
```

### 6.3 Unified Risk Profile Schema

```json
{
  "applicationId": "APP-2026-0001234",
  "applicant": {
    "age": 38,
    "gender": "M",
    "bmi": 26.4,
    "smokerStatus": "NEVER",
    "state": "IL"
  },
  "medicalProfile": {
    "conditions": [
      {
        "code": "E11",
        "description": "Type 2 Diabetes",
        "status": "CONTROLLED",
        "diagnosisDate": "2020-03-15",
        "medications": ["Metformin 1000mg"],
        "latestHbA1c": 6.8,
        "complications": []
      }
    ],
    "labResults": {
      "totalCholesterol": 210,
      "hdl": 55,
      "ldl": 128,
      "triglycerides": 135,
      "tcHdlRatio": 3.82,
      "glucose": 118,
      "hba1c": 6.8,
      "alt": 28,
      "ast": 25,
      "ggt": 35,
      "creatinine": 0.9,
      "egfr": 95,
      "psa": null,
      "cotinine": "NEGATIVE",
      "cdt": 1.2,
      "hiv": "NEGATIVE",
      "hepatitisB": "NEGATIVE",
      "hepatitisC": "NEGATIVE"
    },
    "bloodPressure": { "systolic": 128, "diastolic": 78, "medicated": false },
    "familyHistory": {
      "cardiovascular": { "present": true, "earliestOnsetAge": 62 },
      "cancer": { "present": false }
    }
  },
  "lifestyleProfile": {
    "tobacco": { "ever": false, "current": false },
    "alcohol": { "drinksPerWeek": 4 },
    "driving": { "dui": false, "violations": 1, "accidents": 0 },
    "avocations": [],
    "foreignTravel": [],
    "criminal": { "felony": false, "misdemeanor": false }
  },
  "financialProfile": {
    "annualIncome": 125000,
    "netWorth": 450000,
    "existingInsurance": 250000,
    "appliedFaceAmount": 500000,
    "totalInsurance": 750000,
    "incomeMultiple": 6.0,
    "purpose": "INCOME_REPLACEMENT"
  },
  "externalScores": {
    "mibCodes": ["042-0"],
    "rxRiskScore": 72,
    "creditInsuranceScore": 810,
    "fraudScore": 12,
    "acceleratedUWScore": 0.87
  },
  "evidenceStatus": {
    "mib": "COMPLETE",
    "rx": "COMPLETE",
    "mvr": "COMPLETE",
    "credit": "COMPLETE",
    "paramedical": "NOT_REQUIRED",
    "labs": "NOT_REQUIRED",
    "aps": "NOT_REQUIRED"
  }
}
```

---

## 7. Rules vs. Models — Hybrid Approach

### 7.1 When to Use Rules vs. Models

| Characteristic | Rules Engine | ML Models |
|---------------|-------------|-----------|
| **Transparency** | Fully explainable; every decision traceable | Less transparent; requires SHAP/LIME for explanation |
| **Regulatory acceptance** | High — regulators understand rules | Lower — "black box" concerns; must prove non-discrimination |
| **Speed of change** | Business users can modify rules (with governance) | Requires data science retrain cycle |
| **Handling edge cases** | Excellent — explicit rules for specific scenarios | Poor — may not generalize to rare conditions |
| **Complex pattern recognition** | Poor — can't detect non-linear interactions easily | Excellent — finds patterns in high-dimensional data |
| **Data requirements** | Low — based on expert knowledge | High — requires labeled training data |
| **Best for** | Eligibility, knock-outs, lab limits, regulatory rules | Mortality prediction, fraud detection, risk scoring, accelerated UW eligibility |

### 7.2 Hybrid Architecture

```
┌───────────────────────────────────────────────────────────────────┐
│                    HYBRID DECISION FLOW                            │
│                                                                   │
│  RULES (deterministic, explainable, regulatory)                   │
│  │                                                                │
│  ├── Pass: Eligibility check                                     │
│  ├── Pass: Knock-out check                                       │
│  ├── Pass: Evidence completeness check                           │
│  │                                                                │
│  ▼                                                                │
│  MODELS (probabilistic, pattern-based)                            │
│  │                                                                │
│  ├── Mortality risk score (0-1000)                               │
│  ├── Fraud probability (0.0-1.0)                                 │
│  ├── Accelerated UW eligibility score (0.0-1.0)                  │
│  │                                                                │
│  ▼                                                                │
│  RULES (deterministic, classification)                            │
│  │                                                                │
│  ├── Map model scores to risk classes                            │
│  ├── Apply table ratings for substandard                         │
│  ├── Calculate flat extras                                       │
│  ├── Apply financial limits                                      │
│  └── Determine auto-issue vs. refer                              │
│                                                                   │
│  OUTPUT: Final underwriting decision                              │
└───────────────────────────────────────────────────────────────────┘
```

---

## 8. Scoring & Risk Classification Engine

### 8.1 Predictive Models Used in Underwriting

| Model | Training Data | Features | Output | Use |
|-------|-------------|----------|--------|-----|
| **Mortality Predictor** | Historical policy + claims data | Age, gender, BMI, labs, Rx, conditions, lifestyle | Predicted mortality multiplier (e.g., 1.35× standard) | Risk class assignment |
| **Accelerated UW Eligibility** | Applications with and without fluids; mortality outcomes | App answers, Rx, MIB, MVR, credit score, behavioral | Probability of being within standard mortality if fluids were obtained | Decide if fluids can be waived |
| **Fraud Score** | Known fraud cases + normal applications | Application patterns, coverage amount, timing, beneficiary, third-party owner | Fraud probability (0-1) | Flag for investigation |
| **Risk Class Predictor** | Completed UW decisions with all evidence | All available features at time of app submission | Predicted risk class | Instant quote; triage |
| **APS Necessity Predictor** | Cases where APS changed the decision vs. didn't | Rx, MIB codes, app answers, labs | Probability that APS would change the decision | Avoid unnecessary APS orders |
| **Lapse/Placement Predictor** | Policy persistency data | Demographics, coverage, channel, quote-to-issue time | Probability of policy persisting | Prioritize cases likely to place |

### 8.2 Feature Engineering for Underwriting Models

```
DERIVED FEATURES (computed from raw data):

Demographic:
  ├── exact_age (decimal years from DOB)
  ├── bmi (weight_lbs / (height_in^2) × 703)
  ├── income_to_coverage_ratio
  └── total_insurance_to_income_ratio

Medical (from Rx):
  ├── rx_count (total unique medications)
  ├── rx_chronic_condition_count
  ├── rx_cardiovascular_flag
  ├── rx_diabetes_flag
  ├── rx_mental_health_flag
  ├── rx_opioid_flag
  ├── rx_max_daily_dose_morphine_equivalent
  └── rx_gap_months (time since last Rx fill)

Medical (from Labs):
  ├── tc_hdl_ratio (total cholesterol / HDL)
  ├── non_hdl_cholesterol (total - HDL)
  ├── egfr_calculated (from creatinine, age, gender, race)
  ├── bmi_bp_interaction (BMI × systolic BP)
  └── lab_abnormal_count (# of values outside normal range)

MIB:
  ├── mib_code_count
  ├── mib_has_cardiovascular
  ├── mib_has_cancer
  ├── mib_has_substance
  └── mib_inquiry_count (# of prior carrier inquiries)

MVR:
  ├── mvr_violation_count_3yr
  ├── mvr_dui_flag
  ├── mvr_suspension_flag
  └── mvr_accident_count_5yr

Credit:
  ├── credit_insurance_score
  ├── credit_score_bin (quartile)
  └── credit_thin_file_flag

Behavioral:
  ├── time_of_application (hour of day)
  ├── application_completion_time_minutes
  ├── question_change_count (how many answers were revised)
  └── channel_type
```

---

## 9. Evidence Orchestration Engine

### 9.1 Orchestrator as a Finite State Machine

```
                  ┌────────────────┐
                  │   SUBMITTED    │
                  └───────┬────────┘
                          │ (determine requirements)
                          ▼
                  ┌────────────────┐
                  │  ORDERING      │
                  │  REAL-TIME     │
                  │  EVIDENCE      │
                  └───────┬────────┘
                          │ (MIB + Rx + MVR + Credit complete)
                          ▼
                  ┌────────────────┐
                  │  EVALUATING    │
                  │  REAL-TIME     │
                  │  RESULTS       │
                  └───────┬────────┘
                          │
            ┌─────────────┼─────────────┐
            ▼             ▼             ▼
   ┌──────────────┐ ┌──────────┐ ┌───────────────┐
   │ AUTO-ISSUE   │ │ ORDER    │ │  ORDER        │
   │ ELIGIBLE     │ │ LABS +   │ │  LABS + APS   │
   │ (STP)        │ │ PARAMED  │ │  + INSPECT    │
   └──────┬───────┘ └────┬─────┘ └───────┬───────┘
          │              │               │
          ▼              ▼               ▼
   ┌──────────────┐ ┌──────────────┐ ┌──────────────┐
   │  DECISION    │ │  AWAITING    │ │  AWAITING    │
   │  ENGINE      │ │  FLUIDS      │ │  ALL         │
   │  (immediate) │ │  (3-7 days)  │ │  EVIDENCE    │
   └──────┬───────┘ └──────┬───────┘ │  (10-45 days)│
          │                │         └──────┬───────┘
          │                │                │
          │         ┌──────▼───────┐        │
          │         │  FLUIDS      │        │
          │         │  RECEIVED    │        │
          │         └──────┬───────┘        │
          │                │                │
          │                ▼                ▼
          │         ┌──────────────────────────┐
          │         │  ALL EVIDENCE RECEIVED    │
          │         └──────────────┬───────────┘
          │                        │
          │                        ▼
          │              ┌──────────────────┐
          │              │  DECISION ENGINE │
          │              └────────┬─────────┘
          │                       │
          └───────────┬───────────┘
                      │
           ┌──────────┼──────────┐
           ▼          ▼          ▼
    ┌──────────┐ ┌─────────┐ ┌──────────┐
    │ APPROVED │ │DECLINED │ │REFERRED  │
    │          │ │         │ │ to Human │
    │ → Issue  │ │ → Notify│ │ → Queue  │
    └──────────┘ └─────────┘ └──────────┘
```

---

## 10. Straight-Through Processing (STP) Design

### 10.1 STP Definition

An application that is **received, evaluated, decided, and ready for policy issue** without any human underwriter intervention.

### 10.2 STP Architecture

```
STP GATE CHECKS (all must pass for auto-issue):

 CHECK 1: Data Quality ────────── All required fields present & validated
 CHECK 2: Eligibility ─────────── Product, age, face, state all eligible
 CHECK 3: Knock-Outs ──────────── No immediate decline conditions
 CHECK 4: Evidence Complete ────── All required evidence received
 CHECK 5: Model Confidence ────── Mortality model confidence ≥ threshold
 CHECK 6: Risk Class ──────────── Decision falls within auto-issue classes
 CHECK 7: Financial Justification  Income × multiple ≥ face amount
 CHECK 8: No Referral Triggers ─── No flags requiring human review
 CHECK 9: Fraud Score ─────────── Below fraud threshold
 CHECK 10: Compliance ──────────── State-specific rules satisfied

 ALL 10 PASS ──▶ AUTO-ISSUE (STP)
 ANY FAILS ────▶ REFER TO HUMAN UW (with pre-populated assessment)
```

### 10.3 STP Referral Triggers (Examples)

| Trigger | Threshold | Action |
|---------|-----------|--------|
| Face amount exceeds STP limit | >$1M (varies by program) | Refer |
| Applicant age | >60 | Refer |
| Any medical "yes" answer not auto-resolvable | Complex condition | Refer |
| MIB code requires human interpretation | Certain code ranges | Refer |
| Rx indicates serious condition | Cancer drugs, insulin, etc. | Refer |
| Model confidence below threshold | <0.80 confidence | Refer |
| Financial justification insufficient | Income multiple <5× | Refer |
| Fraud score above threshold | >0.30 | Refer to SIU |
| Criminal history | Any felony | Refer |
| Foreign residency | Non-US resident | Refer |
| Aviation | Private pilot | Refer |
| Tobacco detected (cotinine+) but app says no | Inconsistency | Refer |

---

## 11. API Design for Underwriting

### 11.1 API Endpoints

```
POST   /api/v1/applications                  Create new application
GET    /api/v1/applications/{id}              Get application details
PATCH  /api/v1/applications/{id}              Update application
POST   /api/v1/applications/{id}/submit       Submit for underwriting

GET    /api/v1/applications/{id}/evidence     Get all evidence status
POST   /api/v1/applications/{id}/evidence     Trigger evidence ordering

GET    /api/v1/applications/{id}/decision     Get underwriting decision
POST   /api/v1/applications/{id}/decision/override   Manual UW override

POST   /api/v1/quotes                         Quick quote (pre-UW)
POST   /api/v1/quotes/preliminary             Preliminary decision (real-time)

GET    /api/v1/cases                          List UW cases (with filters)
GET    /api/v1/cases/{id}                     Get case detail (UW workbench)
POST   /api/v1/cases/{id}/assign              Assign to underwriter
POST   /api/v1/cases/{id}/notes               Add UW notes
POST   /api/v1/cases/{id}/decision            Record UW decision

Webhooks (outbound):
POST   {partner_callback_url}/status          Application status update
POST   {partner_callback_url}/decision        Decision notification
```

### 11.2 Key API Response: Decision

```json
{
  "applicationId": "APP-2026-0001234",
  "decisionDate": "2026-04-16T14:30:00Z",
  "decisionType": "AUTOMATED",
  "decision": "APPROVE",
  "classification": {
    "riskClass": "PREFERRED",
    "riskClassCode": "PF",
    "smokerStatus": "NON_SMOKER",
    "tableRating": null,
    "flatExtras": [],
    "exclusions": []
  },
  "approvedCoverage": {
    "productCode": "T20",
    "faceAmount": 500000,
    "annualPremium": 485.00,
    "modalPremium": {
      "monthly": 42.12,
      "quarterly": 124.49,
      "semiAnnual": 245.40,
      "annual": 485.00
    }
  },
  "confidence": 0.94,
  "reasonCodes": [
    { "code": "RC001", "description": "All lab values within preferred range" },
    { "code": "RC015", "description": "Family history debit (+10) for cardiovascular" },
    { "code": "RC042", "description": "BMI 26.4 within preferred limits" }
  ],
  "auditTrail": {
    "rulesVersion": "v4.2.1",
    "modelVersion": "mortality_v3.1",
    "evidenceUsed": ["APPLICATION", "MIB", "RX", "MVR", "CREDIT"],
    "processingTimeMs": 342
  }
}
```

---

## 12. Event-Driven Architecture & CQRS

### 12.1 Domain Events

```
APPLICATION DOMAIN EVENTS:

app.created              → Application record created
app.submitted            → Application submitted for underwriting
app.validation.passed    → Input validation successful
app.validation.failed    → Input validation failed

evidence.requirements.determined → Evidence list calculated
evidence.ordered         → Evidence order placed with vendor
evidence.received        → Evidence response received from vendor
evidence.normalized      → Evidence data normalized to canonical model
evidence.all.complete    → All required evidence collected

decision.initiated       → Decision engine invoked
decision.rules.executed  → Rules engine completed
decision.models.scored   → ML models scored
decision.rendered        → Final decision made
decision.auto.issued     → STP auto-issue decision
decision.referred        → Referred to human underwriter

case.assigned            → Case assigned to underwriter
case.reviewed            → Underwriter completed review
case.decision.manual     → Manual decision recorded
case.escalated           → Case escalated to senior UW

policy.issued            → Policy issued and ready for delivery
policy.delivered         → Policy delivered to owner
policy.free.look.started → Free look period started
```

### 12.2 CQRS Pattern

```
COMMAND SIDE (Write):                    QUERY SIDE (Read):
┌──────────────────┐                    ┌──────────────────┐
│ Application      │                    │ Application      │
│ Command Service  │                    │ Query Service     │
│                  │                    │                  │
│ • CreateApp      │     Events         │ • GetAppStatus   │
│ • SubmitApp      │ ────────────▶     │ • SearchCases    │
│ • RecordDecision │    (Kafka)         │ • GetDashboard   │
│ • OverrideDecisn │                    │ • GetAnalytics   │
│                  │                    │                  │
│ Source of Truth: │                    │ Optimized for:   │
│ Event Store +    │                    │ Read patterns    │
│ Transactional DB │                    │ (Elasticsearch,  │
│                  │                    │  Materialized    │
│                  │                    │  views)          │
└──────────────────┘                    └──────────────────┘
```

---

## 13. State Machine for Case Lifecycle

```
┌────────────┐    ┌──────────────┐    ┌────────────────┐
│   DRAFT    │───▶│  SUBMITTED   │───▶│  IN_TRIAGE     │
└────────────┘    └──────────────┘    └───────┬────────┘
                                              │
                       ┌──────────────────────┼──────────────────────┐
                       ▼                      ▼                      ▼
              ┌──────────────┐       ┌──────────────┐       ┌──────────────┐
              │ ORDERING     │       │ AUTO_DECIDING │       │ REFERRED     │
              │ _EVIDENCE    │       │ (STP path)    │       │ _TO_UW       │
              └──────┬───────┘       └──────┬───────┘       └──────┬───────┘
                     │                      │                      │
                     ▼                      │                      ▼
              ┌──────────────┐              │               ┌──────────────┐
              │ AWAITING     │              │               │ UW_REVIEW    │
              │ _EVIDENCE    │              │               │ _IN_PROGRESS │
              └──────┬───────┘              │               └──────┬───────┘
                     │                      │                      │
                     ▼                      │                      ▼
              ┌──────────────┐              │               ┌──────────────┐
              │ EVIDENCE     │              │               │ UW_DECISION  │
              │ _COMPLETE    │              │               │ _PENDING     │
              └──────┬───────┘              │               │ _APPROVAL    │
                     │                      │               └──────┬───────┘
                     ▼                      ▼                      ▼
              ┌───────────────────────────────────────────────────────────┐
              │                    DECISION RENDERED                       │
              └───────────────────────────┬───────────────────────────────┘
                                          │
                  ┌───────────────────────┼───────────────────────┐
                  ▼                       ▼                       ▼
          ┌──────────────┐       ┌──────────────┐       ┌──────────────┐
          │  APPROVED    │       │  DECLINED    │       │  POSTPONED   │
          └──────┬───────┘       └──────┬───────┘       └──────────────┘
                 │                      │
                 ▼                      ▼
          ┌──────────────┐       ┌──────────────┐
          │  ISSUED      │       │  CLOSED      │
          └──────┬───────┘       └──────────────┘
                 │
                 ▼
          ┌──────────────┐
          │  DELIVERED   │
          └──────┬───────┘
                 │
                 ▼
          ┌──────────────┐
          │  IN_FORCE    │
          └──────────────┘
```

---

## 14. Audit, Explainability & Compliance

### 14.1 Regulatory Requirements for Automated Decisions

Every automated decision must be:
1. **Auditable**: Complete record of all inputs, rules fired, models scored, and outputs.
2. **Explainable**: Ability to produce a human-readable explanation of why a decision was made.
3. **Non-discriminatory**: Must not discriminate on protected classes (race, national origin, etc.).
4. **Reviewable**: Human underwriter can override any automated decision.
5. **Reproducible**: Same inputs should produce the same outputs (deterministic for rules; stochastic for models requires version pinning).

### 14.2 Audit Trail Schema

```json
{
  "auditId": "AUD-2026-0001234-001",
  "applicationId": "APP-2026-0001234",
  "timestamp": "2026-04-16T14:30:00.342Z",
  "decisionType": "AUTOMATED",
  "rulesEngineVersion": "v4.2.1",
  "mlModelVersions": {
    "mortality": "v3.1.0",
    "fraud": "v2.0.4",
    "accelEligibility": "v1.8.2"
  },
  "inputSnapshot": { /* full unified risk profile */ },
  "ruleExecutionLog": [
    { "ruleId": "ELIG-001", "ruleName": "Age eligibility", "result": "PASS", "input": {"age": 38}, "output": "eligible" },
    { "ruleId": "KO-015", "ruleName": "Terminal illness check", "result": "PASS" },
    { "ruleId": "BUILD-042", "ruleName": "BMI risk class ceiling", "result": "PREFERRED", "input": {"bmi": 26.4, "age": 38, "gender": "M"} },
    { "ruleId": "LAB-TC", "ruleName": "Total cholesterol", "result": "PASS_PREFERRED", "input": {"tc": 210} }
  ],
  "modelScores": {
    "mortality": { "score": 0.72, "features_importance": { "age": 0.25, "bmi": 0.12, "rx_count": 0.10 } },
    "fraud": { "score": 0.03 },
    "accelEligibility": { "score": 0.87, "threshold": 0.80, "eligible": true }
  },
  "debitCredits": { "medical": -5, "build": +10, "lifestyle": 0, "family": +10, "net": +15 },
  "finalDecision": { "decision": "APPROVE", "riskClass": "PREFERRED", "confidence": 0.94 },
  "explanation": "Approved as Preferred Non-Smoker. Net debit of +15 within Preferred limits (max +25). BMI 26.4 within Preferred range. Well-controlled Type 2 Diabetes (HbA1c 6.8) resolved to +25 debit offset by excellent cholesterol (-15) and no other impairments."
}
```

---

## 15. Performance, Scalability & Resilience

### 15.1 Performance Requirements

| Operation | Target Latency | Volume |
|-----------|---------------|--------|
| Application submission | <500ms | 100K/day peak |
| Real-time evidence (MIB, Rx, MVR) | <5s per vendor | 100K/day peak |
| STP decision (no fluids) | <2s | 50K/day peak |
| Full UW decision (all evidence) | <10s computation | 30K/day |
| Quote / preliminary decision | <1s | 500K/day (DTC) |

### 15.2 Scalability Architecture

```
┌─────────────────────────────────────────────────────┐
│  KUBERNETES CLUSTER (EKS / AKS / GKE)              │
│                                                      │
│  ┌──────────────┐  Auto-scaling based on:           │
│  │ App Service  │  • Pending application queue depth │
│  │ (3-10 pods)  │  • Evidence response queue depth   │
│  └──────────────┘  • Decision engine CPU utilization │
│  ┌──────────────┐  • API request rate                │
│  │ Evidence     │                                    │
│  │ Orchestrator │  Peak handling:                    │
│  │ (5-20 pods)  │  • 10x normal during enrollment   │
│  └──────────────┘    season (Q4)                     │
│  ┌──────────────┐  • Vendor rate limits managed      │
│  │ Decision     │    via token bucket                │
│  │ Engine       │                                    │
│  │ (5-15 pods)  │  Circuit breakers on all vendor    │
│  └──────────────┘  integrations                      │
└─────────────────────────────────────────────────────┘
```

### 15.3 Resilience Patterns

| Pattern | Implementation | Purpose |
|---------|---------------|---------|
| **Circuit Breaker** | Resilience4j / Hystrix | Vendor API failures don't cascade |
| **Retry with Backoff** | Exponential backoff + jitter | Transient vendor failures |
| **Timeout** | Per-vendor timeouts (3-30s) | Prevent indefinite waits |
| **Fallback** | Default to "order traditional evidence" | If accelerated data unavailable, fall back |
| **Dead Letter Queue** | Kafka DLQ | Failed evidence processing |
| **Idempotency** | UUID-based dedup | Prevent duplicate evidence orders |
| **Saga / Compensating Transaction** | Orchestrator pattern | Multi-vendor ordering coordination |

---

## 16. Vendor Platforms & Build vs. Buy

### 16.1 Underwriting Platforms (Buy)

| Platform | Vendor | Capabilities |
|----------|--------|-------------|
| **UnderwriteMe** | Pacific Life Re | Fully hosted UW rules engine; strong in accelerated UW |
| **AURA (Automated Underwriting & Risk Assessment)** | Munich Re | AI-powered; modular; API-first |
| **RHEA** | Swiss Re | Automated UW with deep medical rules |
| **Velogica** | RGA | Fast accelerated UW engine; reflexive app; real-time decision |
| **MagMutual OASIS** | MagMutual | Medical impairment assessment engine |
| **EXL XTRAKTO** | EXL | APS extraction using NLP/AI |
| **Clareto** | Clareto | Electronic APS ordering and retrieval |
| **Intelligent Medical Underwriting (IMU)** | Gen Re | Medical underwriting engine |
| **iPipeline / Hexure** | iPipeline | E-application, illustration, and case management |

### 16.2 Build vs. Buy Decision Matrix

| Factor | Build | Buy (Platform) | Hybrid |
|--------|-------|----------------|--------|
| **Time to market** | 12–24 months | 3–6 months | 6–12 months |
| **Cost (Year 1)** | $3M–$8M | $500K–$2M (license + impl) | $2M–$5M |
| **Customization** | Unlimited | Limited to platform capabilities | Core platform + custom extensions |
| **Competitive differentiation** | High | Low (same as other users) | Medium |
| **Maintenance burden** | High (your team) | Low (vendor maintains) | Medium |
| **ML model flexibility** | Full control | Limited to vendor models | Custom models + vendor rules |
| **Vendor dependency** | None | High | Medium |

**Recommendation for most carriers:** Hybrid approach — buy a rules engine (or reinsurer platform) for medical underwriting rules, build the orchestration, API layer, and custom ML models.

---

## 17. Implementation Roadmap

### 17.1 Phased Approach

```
PHASE 1 (Months 1-6): FOUNDATION
├── Implement case management workflow
├── Build evidence orchestration (MIB, Rx, MVR, Credit APIs)
├── Deploy rules engine with basic eligibility and knock-out rules
├── Achieve: 10-15% STP (simplest cases only)

PHASE 2 (Months 6-12): ACCELERATION
├── Implement accelerated UW scoring model
├── Build full medical rules (build charts, lab interpretation, Rx mapping)
├── Add reflexive application logic
├── Deploy financial justification rules
├── Achieve: 30-40% STP

PHASE 3 (Months 12-18): OPTIMIZATION
├── Train and deploy mortality prediction model
├── Implement fraud scoring model
├── Optimize STP thresholds using mortality experience data
├── Build UW workbench for augmented decision support
├── Achieve: 50-60% STP

PHASE 4 (Months 18-24): INTELLIGENCE
├── Deploy APS NLP extraction pipeline
├── Implement continuous model retraining
├── Add behavioral analytics features
├── Build real-time monitoring and drift detection
├── Achieve: 60-70% STP

PHASE 5 (Months 24+): NEXT GENERATION
├── GenAI-assisted UW (medical record summarization, rule explanation)
├── Continuous underwriting (post-issue risk monitoring)
├── Embedded UW APIs for partner distribution
├── Achieve: 70-80% STP
```

---

*This article is Part 2 of a 10-part series on Term Life Insurance Underwriting. See [01_TERM_UNDERWRITING_FUNDAMENTALS.md](01_TERM_UNDERWRITING_FUNDAMENTALS.md) for domain foundations and [03_UNDERWRITING_DATA_STANDARDS.md](03_UNDERWRITING_DATA_STANDARDS.md) for data formats and standards.*
