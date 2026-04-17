# Term Life Insurance Underwriting — Complete Domain Encyclopedia

> An exhaustive reference covering every aspect of term life underwriting from first principles through advanced concepts. Written for solution architects, product owners, and technologists building automated underwriting platforms.

---

## Table of Contents

1. [What Is Term Life Insurance](#1-what-is-term-life-insurance)
2. [The Purpose of Underwriting](#2-the-purpose-of-underwriting)
3. [Term Product Taxonomy](#3-term-product-taxonomy)
4. [The Underwriting Function — Organization & Roles](#4-the-underwriting-function--organization--roles)
5. [Underwriting Philosophy & Risk Appetite](#5-underwriting-philosophy--risk-appetite)
6. [The Application — Data Collection](#6-the-application--data-collection)
7. [Evidence Requirements & Ordering Rules](#7-evidence-requirements--ordering-rules)
8. [Risk Assessment — The Five Pillars](#8-risk-assessment--the-five-pillars)
9. [Risk Classification & Rating](#9-risk-classification--rating)
10. [Mortality & Morbidity Fundamentals](#10-mortality--morbidity-fundamentals)
11. [Reinsurance in Term Underwriting](#11-reinsurance-in-term-underwriting)
12. [Policy Issue & Delivery](#12-policy-issue--delivery)
13. [Post-Issue Underwriting](#13-post-issue-underwriting)
14. [Key Industry Bodies & Standards](#14-key-industry-bodies--standards)
15. [Glossary of Underwriting Terms](#15-glossary-of-underwriting-terms)

---

## 1. What Is Term Life Insurance

### 1.1 Definition

Term life insurance provides a **death benefit** to named beneficiaries if the insured dies during a specified period (the "term"). If the insured survives the term, the policy expires with no payout (pure insurance — no cash value accumulation).

### 1.2 Why Term Matters

- **Largest individual life insurance segment** by policy count in the US.
- ~70% of individual life insurance policies sold are term (LIMRA).
- Average face amount: $250,000–$500,000.
- Average annual premium: $500–$2,000 (healthy 35-year-old, 20-year term, $500K).
- Over **40 million** term policies in force in the US.
- Term is the primary vehicle for **income replacement**, **debt coverage**, and **financial protection**.

### 1.3 Term vs. Permanent Life

| Feature | Term Life | Whole Life | Universal Life |
|---------|----------|-----------|---------------|
| Duration | Fixed (10, 15, 20, 25, 30 years) | Lifetime | Flexible |
| Premiums | Level during term; lowest initial cost | Level; highest cost | Flexible |
| Cash Value | None | Guaranteed | Variable |
| Underwriting Complexity | Standard | Standard to Complex | Complex |
| Conversion Option | Usually available | N/A | N/A |
| Primary Use | Income replacement, debt protection | Estate planning, wealth transfer | Flexible planning |

### 1.4 Economic Significance

- US life insurance industry: ~$900B in annual premiums (direct + assumed).
- Term life: ~$160B in annual premiums.
- Life insurance in force: ~$22 trillion face amount.
- Term represents the highest-volume, highest-velocity product for underwriting automation.

---

## 2. The Purpose of Underwriting

### 2.1 Core Objective

Underwriting is the process of **evaluating risk** to determine whether to insure an applicant, and if so, at what **price** (premium) and under what **terms** (conditions, exclusions, ratings).

### 2.2 The Anti-Selection Problem

Without underwriting, **adverse selection** would occur:
- High-risk individuals (those who know they're likely to die soon) would disproportionately purchase insurance.
- Low-risk individuals would subsidize high-risk individuals through higher premiums.
- Eventually, premiums would become unaffordable for healthy applicants, causing a **death spiral**.

Underwriting ensures that **each risk is priced commensurate with its expected mortality**, maintaining the fundamental fairness and solvency of the insurance pool.

### 2.3 The Underwriting Value Chain

```
Application ──▶ Evidence ──▶ Risk ──▶ Classification ──▶ Decision ──▶ Issue
  Intake        Gathering    Assessment    & Rating                    & Delivery
```

### 2.4 Underwriting Adds Value By:

1. **Protecting the insurer's solvency** — ensuring premiums collected are sufficient to pay claims.
2. **Maintaining equity among policyholders** — similar risks pay similar premiums.
3. **Enabling competitive pricing** — better risk selection = lower premiums for healthy applicants.
4. **Detecting fraud and misrepresentation** — preventing anti-selection and material misrepresentation.
5. **Complying with regulations** — ensuring fair, non-discriminatory underwriting practices.

---

## 3. Term Product Taxonomy

### 3.1 Term Durations

| Product | Duration | Typical Ages | Notes |
|---------|----------|-------------|-------|
| **10-Year Term** | 10 years | 18–75 | Shortest standard term; lowest premium |
| **15-Year Term** | 15 years | 18–70 | Growing popularity |
| **20-Year Term** | 20 years | 18–65 | Most popular term product |
| **25-Year Term** | 25 years | 18–60 | Less common; some carriers offer |
| **30-Year Term** | 30 years | 18–55 | Longest standard term; highest premium |
| **Annual Renewable Term (ART)** | 1 year (renewable) | 18–80 | Premium increases annually; guaranteed renewable |
| **Return of Premium (ROP)** | 20–30 years | 18–55 | Returns premiums if insured survives term; much higher premium |
| **Decreasing Term** | 10–30 years | 18–65 | Face amount decreases over time; aligned with mortgage balance |

### 3.2 Face Amount Ranges

| Tier | Face Amount | Underwriting Requirements |
|------|------------|--------------------------|
| **Simplified Issue** | $25,000–$100,000 | Application questions only; no labs |
| **Accelerated UW** | $100,000–$1,000,000 | Application + data-driven (Rx, MIB, MVR, credit); no fluids for qualifying applicants |
| **Full Traditional UW** | $100,000–$10,000,000+ | Full medical exam, labs, APS, financial docs |
| **Jumbo / High-Net-Worth** | $10,000,000+ | Extensive medical, financial, and reinsurance underwriting |

### 3.3 Product Features

| Feature | Description | Underwriting Impact |
|---------|------------|-------------------|
| **Level Premium** | Premium fixed for entire term | Standard |
| **Conversion Privilege** | Right to convert to permanent without evidence | Anti-selection risk; conversion UW rules |
| **Waiver of Premium** | Premiums waived if insured becomes disabled | Requires disability underwriting |
| **Accelerated Death Benefit** | Advance of death benefit upon terminal diagnosis | Standard rider; minimal UW impact |
| **Child Term Rider** | Coverage for children of insured | Simplified child health questions |
| **Accidental Death Rider** | Additional benefit for accidental death | Occupation, avocation assessment |
| **Guaranteed Insurability** | Future purchase right without evidence | Limits on amount; age restrictions |

### 3.4 Distribution Channels

| Channel | Description | Underwriting Characteristics |
|---------|------------|------------------------------|
| **Career Agency** | Captive agents (e.g., Northwestern Mutual, MassMutual) | Full underwriting; face-to-face |
| **Independent Brokerage (BGA)** | Independent agents through Brokerage General Agencies | Full underwriting; broker submitted |
| **Direct-to-Consumer (DTC)** | Online/phone (e.g., Haven Life, Bestow, Ethos) | Accelerated/instant-issue; digital-first |
| **Worksite / Group** | Employer-sponsored voluntary term | Simplified or guaranteed issue |
| **Bank / Affinity** | Banks, credit unions, associations | Simplified issue; smaller face amounts |
| **Embedded** | Term embedded in other purchases (mortgage, auto loan) | Simplified; API-driven |

---

## 4. The Underwriting Function — Organization & Roles

### 4.1 Organizational Structure

```
                    ┌────────────────────────┐
                    │  Chief Underwriter /    │
                    │  VP of Underwriting     │
                    └───────────┬────────────┘
          ┌─────────────────────┼─────────────────────┐
          │                     │                     │
  ┌───────▼──────────┐ ┌───────▼──────────┐ ┌───────▼──────────┐
  │  AVP New Business│ │ AVP Underwriting │ │ AVP UW Technology│
  │  Underwriting    │ │ Quality & Risk   │ │ & Innovation     │
  └───────┬──────────┘ └───────┬──────────┘ └───────┬──────────┘
          │                    │                     │
  ┌───────▼──────┐     ┌──────▼───────┐     ┌──────▼──────────┐
  │ UW Teams     │     │ Quality      │     │ Rules Engine    │
  │ (by region   │     │ Assurance    │     │ Data Science    │
  │  or product) │     │ Audit Team   │     │ Vendor Mgmt     │
  └──────────────┘     └──────────────┘     └─────────────────┘
```

### 4.2 Key Roles

| Role | Responsibility | Authority |
|------|---------------|-----------|
| **Underwriter (Associate/Junior)** | Reviews applications with lower face amounts and simpler risk profiles. Follows guidelines with limited discretionary authority. | Up to $500K face, standard risk classes |
| **Underwriter (Senior)** | Handles complex cases — medical impairments, financial justification issues, borderline risks. | Up to $2M face, substandard ratings |
| **Underwriter (Team Lead)** | Mentors team; handles escalated cases; ensures consistency. | Up to $5M face |
| **Chief/Senior Medical Director** | Physician who sets medical underwriting guidelines, reviews complex medical cases, approves impairment ratings. | All face amounts; medical authority |
| **Underwriting Consultant** | Expert in specific areas (financial, avocation, foreign travel) providing guidance. | Advisory |
| **Case Manager / New Business Coordinator** | Orders evidence (labs, APS, MIB, MVR), tracks requirements, manages case workflow. | No underwriting authority; operational |
| **Actuarial (Pricing)** | Sets mortality assumptions, risk class definitions, premium rates. Works with UW to calibrate risk appetite. | Pricing authority |
| **Underwriting Quality Analyst** | Audits completed cases for guideline adherence, decision consistency, documentation quality. | Audit findings |
| **Rules Engine Analyst / UW Technologist** | Configures automated underwriting rules, maintains decision models, analyzes straight-through rates. | System configuration |
| **Reinsurance Underwriter** | Reviews cases exceeding retention; negotiates with reinsurers on facultative cases. | Per reinsurance treaty |

### 4.3 Authority Levels

| Level | Face Amount | Substandard Authority | Decline Authority |
|-------|-----------|----------------------|------------------|
| Associate UW | ≤$500K | Table B (150%) max | Refer to senior |
| Senior UW | ≤$2M | Table H (300%) max | Yes, with documentation |
| Team Lead | ≤$5M | Table P (400%+) | Yes |
| AVP/Director | ≤$10M | Unlimited | Yes |
| Chief UW / Med Director | Unlimited | Unlimited | Yes |
| Reinsurer (facultative) | Above retention | Per treaty | Per treaty |

---

## 5. Underwriting Philosophy & Risk Appetite

### 5.1 Risk Appetite Statement

Every carrier defines a **risk appetite** that guides underwriting decisions:

```
┌──────────────────────────────────────────────────────────────────┐
│  RISK APPETITE DIMENSIONS                                        │
│                                                                  │
│  1. TARGET MARKET                                               │
│     Ages 18-70, face amounts $100K-$10M, US residents           │
│                                                                  │
│  2. RISK CLASS DISTRIBUTION (Target)                            │
│     Preferred Plus: 10-15%                                      │
│     Preferred: 20-25%                                           │
│     Standard Plus: 20-25%                                       │
│     Standard: 25-30%                                            │
│     Substandard: 5-10%                                          │
│     Decline: 3-5%                                               │
│                                                                  │
│  3. MORTALITY EXPERIENCE TARGET                                 │
│     Actual-to-Expected (A/E) ratio: 85-95% of pricing basis    │
│                                                                  │
│  4. RETENTION LIMIT                                              │
│     Maximum risk retained per life: $5M-$25M (varies by carrier)│
│     Excess ceded to reinsurers                                   │
│                                                                  │
│  5. PROHIBITED RISKS                                             │
│     Active military deployment, certain foreign residency,       │
│     specific hazardous occupations/avocations per guidelines     │
└──────────────────────────────────────────────────────────────────┘
```

### 5.2 Underwriting Guidelines (The "Manual")

The underwriting manual is the **central reference document** containing:

| Section | Content |
|---------|---------|
| **Medical Impairment Guide** | Risk assessment for 500+ medical conditions — diabetes, heart disease, cancer, mental health, etc. Rating tables, build charts, lab value thresholds. |
| **Non-Medical Guidelines** | Occupation, avocation, aviation, foreign travel, driving record, criminal history, financial, tobacco. |
| **Financial Underwriting Guide** | Income multiples, net worth requirements, business insurance justification, third-party ownership rules. |
| **Evidence Requirements** | What evidence is required based on age and face amount (requirements grid). |
| **Risk Classification Definitions** | Criteria for each risk class (Preferred Plus through Substandard). |
| **Reinsurance Guidelines** | Retention limits, automatic vs. facultative, cession procedures. |
| **Policy Forms & Riders** | Availability rules, state variations, rider underwriting. |
| **Underwriting Authority** | Who can approve what — authority matrix. |
| **Special Programs** | Accelerated underwriting, simplified issue, guaranteed issue criteria. |

### 5.3 Debits and Credits System

Underwriting uses a **debit/credit** framework to assess overall risk:

```
BASE: Standard risk class (100% expected mortality)

DEBITS (increase risk / worsen class):
  +25  Controlled hypertension on medication
  +50  BMI 32 (mild obesity)
  +75  Family history of heart disease (parent died < age 60)
  +100 Diabetes Type 2, well-controlled (Table B)
  +150 History of DUI within 5 years

CREDITS (decrease risk / improve class):
  -25  Excellent cholesterol profile
  -15  Regular exercise (documented)
  -10  No family history of cancer or heart disease

NET RESULT determines risk class or table rating.
```

---

## 6. The Application — Data Collection

### 6.1 Application Components

The life insurance application is the **primary data collection instrument**. It consists of several parts:

| Part | Content | Format |
|------|---------|--------|
| **Part 1: General Information** | Applicant name, DOB, SSN, address, citizenship, occupation, income | Structured fields |
| **Part 2: Coverage Details** | Product, term length, face amount, riders, beneficiaries, owner | Structured fields |
| **Part 3: Medical History** | Health questions — 30-60 yes/no with detail prompts | Structured + free text |
| **Part 4: Lifestyle & Activities** | Tobacco, alcohol, drugs, avocations, foreign travel, aviation, driving | Structured + free text |
| **Part 5: Financial Information** | Income, net worth, existing insurance, replacement, business purpose | Structured fields |
| **Part 6: Agent Report** | Agent observations: physical appearance, demeanor, how introduced, relationship | Free text |
| **Part 7: Authorizations** | HIPAA authorization, MIB authorization, consumer report authorization, fair credit reporting act notice | Signature fields |
| **Part 8: Declarations & Signatures** | Representations, warranties, fraud warning, signatures (applicant, owner, agent) | Signature + date |

### 6.2 Medical History Questions (Typical)

The medical section asks about the last **5–10 years** of medical history:

```
CATEGORY                          EXAMPLE QUESTIONS
─────────────────────────────── ──────────────────────────────────────────────
CARDIOVASCULAR                   Heart attack, stroke, TIA, angina, heart murmur,
                                 irregular heartbeat, high blood pressure,
                                 peripheral vascular disease, aneurysm

CANCER                           Any cancer, tumor, growth, abnormal biopsy,
                                 pre-cancerous condition, melanoma, leukemia,
                                 lymphoma

RESPIRATORY                      COPD, emphysema, asthma (adult), sleep apnea,
                                 pulmonary fibrosis, chronic bronchitis

NEUROLOGICAL                     Epilepsy, seizures, multiple sclerosis,
                                 Parkinson's, ALS, numbness, paralysis,
                                 memory loss, dementia

DIGESTIVE                        Liver disease, hepatitis, cirrhosis, Crohn's,
                                 ulcerative colitis, pancreatitis

KIDNEY/URINARY                   Kidney disease, dialysis, kidney stones,
                                 protein in urine

ENDOCRINE                        Diabetes (Type 1/2), thyroid disease,
                                 adrenal disorders

MENTAL HEALTH                    Depression, anxiety, bipolar, schizophrenia,
                                 suicide attempt, psychiatric hospitalization

MUSCULOSKELETAL                  Back surgery, joint replacement, chronic pain,
                                 disability

HIV/AIDS                         HIV positive, AIDS, ARC

SUBSTANCE USE                    Alcohol treatment, drug use/treatment, DUI/DWI

GENERAL                          Hospitalization, surgery, disability,
                                 disability benefits, workers' comp claim,
                                 pending medical tests, abnormal lab results

MEDICATIONS                      All current prescriptions with dosages

FAMILY HISTORY                   Parents and siblings: heart disease, stroke,
                                 cancer, diabetes — age of onset, age at death
```

### 6.3 Application Channels

| Channel | Data Capture Method | Signature Method |
|---------|-------------------|-----------------|
| **Paper Application** | Hand-written; scanned & OCR'd or manually keyed | Wet ink signature |
| **E-Application (Agent-assisted)** | Agent enters data on tablet/laptop during interview | Electronic signature (DocuSign, etc.) |
| **Tele-Application** | Phone interview by call center; scripted questions; recorded | Voice signature or e-sign follow-up |
| **Online Self-Service** | Applicant completes web form directly | Electronic signature |
| **Mobile Application** | Applicant completes via mobile app | Touch/biometric signature |
| **API-Embedded** | Third-party platform collects data; submits via API | E-sign within partner platform |

### 6.4 Application Data Standards

Applications are transmitted electronically using **ACORD standards**:

- **ACORD 103 (Life Application)**: The standard electronic life application form.
- **ACORD TXLife XML**: XML schema for transmitting application data between distribution and carrier systems.
- **ACORD 121 (Life Supplement)**: Additional medical/lifestyle detail beyond the base application.

---

## 7. Evidence Requirements & Ordering Rules

### 7.1 The Requirements Grid

Every carrier maintains a **requirements grid** (also called the "evidence matrix") that dictates what underwriting evidence is required based on **age** and **face amount**:

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    EVIDENCE REQUIREMENTS GRID (Example)                      │
│                                                                             │
│  Face Amount    │ Age 18-35  │ Age 36-45  │ Age 46-55  │ Age 56-65  │ 66+ │
│  ═══════════════│════════════│════════════│════════════│════════════│═════│
│  $100K-$249K    │ App+MIB    │ App+MIB    │ App+MIB+   │ App+MIB+   │ Full│
│                 │            │            │ BPL        │ BPL+ECG   │     │
│                 │            │            │            │            │     │
│  $250K-$499K    │ App+MIB+   │ App+MIB+   │ App+MIB+   │ App+MIB+   │ Full│
│                 │ BPL        │ BPL        │ BPL+ECG   │ Full       │     │
│                 │            │            │            │            │     │
│  $500K-$999K    │ App+MIB+   │ App+MIB+   │ Full+      │ Full+      │ Full│
│                 │ BPL+MVR   │ BPL+ECG+  │ ECG+MVR   │ ECG+Insp+ │ +   │
│                 │            │ MVR        │            │ Fin        │ Ext │
│                 │            │            │            │            │     │
│  $1M-$2.99M     │ App+MIB+   │ Full+ECG+ │ Full+ECG+ │ Full+ECG+ │ Full│
│                 │ BPL+MVR   │ MVR        │ MVR+Fin   │ Insp+Fin  │ +   │
│                 │            │            │            │            │ Ext │
│                 │            │            │            │            │     │
│  $3M-$4.99M     │ Full+MVR+ │ Full+ECG+ │ Full+ECG+ │ Full+ECG+ │ Full│
│                 │ Fin        │ MVR+Fin   │ MVR+Insp+ │ Insp+Fin+ │ +   │
│                 │            │            │ Fin        │ APS       │ Ext │
│                 │            │            │            │            │     │
│  $5M+           │ Full+MVR+ │ Full+ECG+ │ Full+ECG+ │ Full+ECG+ │ Full│
│                 │ Fin+Insp  │ MVR+Fin+  │ MVR+Insp+ │ Insp+Fin+ │ +   │
│                 │            │ Insp       │ Fin+APS   │ APS       │ Ext │
│                 │            │            │            │            │     │
│  LEGEND:                                                                    │
│  App = Application   MIB = MIB Check    BPL = Blood Profile + Urinalysis  │
│  ECG = Electrocardiogram (resting)      MVR = Motor Vehicle Report         │
│  Fin = Financial Questionnaire          Insp = Inspection Report           │
│  APS = Attending Physician Statement    Full = Paramedical Exam + BPL      │
│  Ext = Extended (treadmill, additional labs, cognitive screening)           │
└─────────────────────────────────────────────────────────────────────────────┘
```

### 7.2 Evidence Types — Detailed

| Evidence | Source | Content | Turnaround |
|----------|--------|---------|-----------|
| **Application** | Applicant/Agent | Demographics, medical history, lifestyle, financial | Immediate (digital) |
| **MIB Check** | MIB Group, Inc. | Prior application activity with other carriers; coded impairments | Real-time (seconds) |
| **Prescription History (Rx)** | Milliman IntelliScript / ExamOne ScriptCheck | 5-10 year Rx history from PBMs and pharmacies | Real-time (seconds) |
| **Motor Vehicle Report (MVR)** | State DMVs via LexisNexis, TransUnion | Driving record: violations, suspensions, DUI/DWI | Minutes to hours |
| **Credit-Based Insurance Score** | LexisNexis Risk Classifier, TransUnion TrueRisk | Mortality-predictive score derived from credit attributes | Real-time (seconds) |
| **Criminal History** | LexisNexis, state databases | Felony/misdemeanor convictions | Minutes to hours |
| **Identity Verification** | LexisNexis, Experian, TransUnion | KBA (Knowledge-Based Authentication), SSN validation, identity fraud check | Real-time |
| **Paramedical Exam** | ExamOne, APPS, Portamedic | Height, weight, blood pressure, pulse, medical history interview | 3-7 days |
| **Blood Profile (BPL)** | ExamOne, Quest Diagnostics | CBC, CMP (Chem 20), lipid panel, HbA1c, HIV, hepatitis, cotinine, CDT, PSA | 3-7 days |
| **Urinalysis** | ExamOne, Quest | Drugs, nicotine, protein, glucose | 3-7 days |
| **Resting ECG** | Paramedical vendor | 12-lead electrocardiogram; interpreted by cardiologist | 3-7 days |
| **Attending Physician Statement (APS)** | Treating physician/hospital | Complete medical records for specific conditions | 10-45 days |
| **Inspection Report** | Factual data vendors | Face-to-face or phone interview covering financial, personal, lifestyle | 3-10 days |
| **Financial Documentation** | Applicant | Tax returns, financial statements, business valuations | Varies |
| **Treadmill / Stress ECG** | Medical facility | Exercise stress test for cardiac assessment | 7-14 days |
| **Cognitive Screening** | Paramedical vendor | Mini-mental status exam (ages 70+) | During paramedical |

### 7.3 Evidence Ordering Logic

The rules engine determines which evidence to order based on:

```
INPUTS:
  ├── Applicant age
  ├── Face amount (applied for + in-force)
  ├── Product type
  ├── Distribution channel (accelerated UW eligible?)
  ├── Application answers (any "yes" triggers additional requirements)
  ├── MIB results (coded impairments may trigger APS)
  ├── Rx history results (medications may trigger APS or additional labs)
  └── State of issue (some states restrict certain evidence types)

OUTPUT:
  ├── List of required evidence items
  ├── Ordering priority (parallel vs. sequential)
  ├── Vendor assignments
  └── Expected turnaround time
```

### 7.4 Reflexive / Knock-Out Questions

Modern digital applications use **reflexive questioning** — follow-up questions appear dynamically based on prior answers:

```
Q: Have you been diagnosed with diabetes?
  └── YES ──▶
      Q: Type 1 or Type 2?
        └── Type 2 ──▶
            Q: When were you diagnosed?
            Q: What is your most recent HbA1c?
            Q: What medications are you taking?
            Q: Any complications (retinopathy, neuropathy, nephropathy)?
        └── Type 1 ──▶
            Q: Age at diagnosis?
            Q: Most recent HbA1c?
            Q: Insulin pump or injections?
            Q: Any hospitalizations for DKA?
  └── NO ──▶ [Next question]
```

Some answers are **immediate knock-outs** (automatic decline or referral to human underwriter):
- Terminal illness or life expectancy < 24 months
- Active cancer treatment (except certain early-stage cancers)
- HIV/AIDS (most carriers; some now offer coverage)
- Current hospitalization
- Active substance abuse treatment

---

## 8. Risk Assessment — The Five Pillars

### 8.1 Overview

Underwriting evaluates risk across five major dimensions:

```
┌──────────────────────────────────────────────────────────────────┐
│                   FIVE PILLARS OF RISK ASSESSMENT                │
│                                                                  │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌───────┐  ┌──────┐│
│  │ MEDICAL  │  │LIFESTYLE │  │FINANCIAL │  │MORAL  │  │BUILD ││
│  │          │  │          │  │          │  │HAZARD │  │      ││
│  │ Health   │  │ Tobacco  │  │ Income   │  │       │  │ Age  ││
│  │ history  │  │ Alcohol  │  │ Net worth│  │Intent │  │Gender││
│  │ Labs     │  │ Drugs    │  │ Existing │  │Anti-  │  │ BMI  ││
│  │ Current  │  │ Driving  │  │ insurance│  │select │  │      ││
│  │ meds     │  │ Avocatn  │  │ Business │  │Fraud  │  │      ││
│  │ Family   │  │ Travel   │  │ purpose  │  │       │  │      ││
│  │ history  │  │ Criminal │  │          │  │       │  │      ││
│  └──────────┘  └──────────┘  └──────────┘  └───────┘  └──────┘│
└──────────────────────────────────────────────────────────────────┘
```

### 8.2 Pillar 1: Medical Risk

The most significant underwriting factor. Assessed through:

**Build (Height/Weight/BMI)**
- BMI thresholds define risk class eligibility:
  - Preferred Plus: BMI 18.5–27.0
  - Preferred: BMI 18.0–30.0
  - Standard Plus: BMI 17.0–33.0
  - Standard: BMI 16.0–38.0
  - Substandard: BMI 38+
- Build charts are gender and age-specific

**Blood Chemistry**
- Cholesterol: Total, HDL, LDL, triglycerides, TC/HDL ratio
- Glucose / HbA1c: Diabetes screening
- Liver function: ALT, AST, GGT, bilirubin — detect liver disease, alcohol abuse
- Kidney function: BUN, creatinine, eGFR
- PSA: Prostate cancer screening (males 50+)
- CDT (Carbohydrate-Deficient Transferrin): Alcohol biomarker
- Cotinine: Tobacco/nicotine detection
- HIV antibody: HIV screening
- Hepatitis B/C: Viral hepatitis screening

**Blood Pressure**
- Preferred Plus: ≤130/80 (no medication)
- Preferred: ≤135/85 (no medication or well-controlled with 1 med)
- Standard Plus: ≤140/90
- Standard: ≤145/92
- Substandard: Above standard thresholds

**Family History**
- Cardiovascular death in parent/sibling before age 60
- Cancer death in parent/sibling before age 60
- Two or more first-degree relatives with same condition
- Hereditary conditions (Huntington's, BRCA, etc.)

**Personal Medical History**
- 500+ conditions evaluated per the impairment guide
- Each condition assessed for: severity, duration, treatment, control, complications
- Common conditions and typical outcomes:

| Condition | Well-Controlled | Poorly Controlled |
|-----------|----------------|-------------------|
| Hypertension | Preferred possible | Standard to Substandard |
| Diabetes Type 2 | Standard to Table B | Table D to Decline |
| Depression (no hospitalization) | Preferred possible | Standard to Substandard |
| Sleep Apnea (CPAP compliant) | Standard Plus | Table B–D |
| Asthma (mild) | Preferred | Standard |
| Cancer (>5 yr remission, early stage) | Standard | Decline (active) |
| Atrial Fibrillation | Standard to Table B | Table D to Decline |

### 8.3 Pillar 2: Lifestyle Risk

| Factor | Assessment Criteria | Impact |
|--------|-------------------|--------|
| **Tobacco** | Any nicotine use in last 12-60 months (varies by carrier); includes cigarettes, cigars, chewing tobacco, vaping, nicotine patches | Smoker vs. Non-Smoker class; 2-3x premium differential |
| **Alcohol** | Consumption level; history of treatment; DUI/DWI history; CDT lab values | Moderate = standard; Heavy = substandard; Treatment history = rated |
| **Marijuana** | Recreational vs. medical; frequency; state legality | Varies widely: some carriers offer non-smoker rates for occasional use |
| **Illicit Drugs** | Any use within 5-10 years; type of drug; frequency | Recent use = decline; historical use = rated or standard (time-dependent) |
| **Driving Record (MVR)** | DUI/DWI, reckless driving, license suspensions, accidents, speeding tickets | DUI <3yr = rated or decline; multiple violations = substandard |
| **Aviation** | Private pilot vs. commercial; hours flown; ratings; aircraft type | Commercial pilots often standard; private pilots may be rated or excluded |
| **Avocations** | Skydiving, SCUBA (>100ft), rock climbing, auto racing, hang gliding, etc. | Flat extra ($2.50–$10 per $1,000) or exclusion |
| **Foreign Travel** | Travel to high-risk countries (war zones, endemic disease areas) | Postpone, flat extra, or exclusion depending on destination and duration |
| **Criminal History** | Felony convictions, pending charges, incarceration | Varies by type and recency; violent felony recent = decline |
| **Occupation** | Hazardous occupations: mining, logging, offshore oil, stunt performers | Flat extra or table rating |

### 8.4 Pillar 3: Financial Risk

Financial underwriting prevents **over-insurance** (moral hazard). The principle: insurance should not be worth more than the financial loss the beneficiary would suffer.

**Income Replacement Guidelines**

| Age | Multiple of Annual Income (Earned Income) |
|-----|------------------------------------------|
| 18–35 | 20–30× annual income |
| 36–45 | 15–25× annual income |
| 46–55 | 10–20× annual income |
| 56–65 | 5–15× annual income |
| 66+ | 5–10× annual income |

**Additional Financial Justification**
| Need | Justification | Documentation |
|------|--------------|---------------|
| Income Replacement | Replace lost income for dependents | Pay stubs, tax returns |
| Mortgage Protection | Cover outstanding mortgage balance | Mortgage statement |
| Key Person | Value of key employee to business | Business financials |
| Buy-Sell | Fund buy-sell agreement between partners | Buy-sell agreement, business valuation |
| Loan Collateral | Collateral assignment for business loan | Loan documents |
| Estate Planning | Cover estate tax liability | Estate planning documents, net worth statement |
| Charitable | Insurable interest for charity | Board resolution |

### 8.5 Pillar 4: Moral Hazard

Moral hazard assessment looks for indicators that the applicant (or owner/beneficiary) may have **intent to defraud** or that the policy creates a **perverse incentive**:

- Over-insurance relative to income/net worth
- Third-party ownership without clear insurable interest
- Multiple applications to different carriers simultaneously
- Beneficiary with no clear insurable interest
- Recent increase in coverage after divorce or business failure
- STOLI (Stranger-Originated Life Insurance) indicators
- Applicant with terminal diagnosis applying for large coverage

### 8.6 Pillar 5: Build (Age, Gender, BMI)

These are the **most predictive** mortality factors:

- **Age**: Single strongest predictor. Mortality doubles approximately every 8–10 years.
- **Gender**: Females live ~5 years longer on average. Separate mortality tables. (Some states require unisex pricing, e.g., Montana.)
- **BMI**: U-shaped mortality curve — both underweight and obese individuals have elevated mortality.

---

## 9. Risk Classification & Rating

### 9.1 Risk Classes

Most carriers offer **4-6 non-tobacco** and **2-3 tobacco** risk classes:

| Risk Class | Description | Approx. % of Applicants | Relative Mortality |
|-----------|------------|------------------------|--------------------|
| **Preferred Plus (Super Preferred)** | Exceptional health, no medical conditions, excellent labs, no family history, non-smoker | 10–15% | 50–60% of standard |
| **Preferred** | Very good health, minor conditions acceptable, good labs, non-smoker | 20–25% | 70–80% of standard |
| **Standard Plus** | Good health with some limitations, non-smoker | 15–20% | 85–95% of standard |
| **Standard** | Average health, baseline risk, non-smoker | 25–30% | 100% (basis) |
| **Preferred Smoker** | Good health but uses tobacco | 2–3% | 100–120% of standard |
| **Standard Smoker** | Average health and uses tobacco | 5–8% | 150–200% of standard |
| **Substandard (Table-Rated)** | Elevated risk due to medical conditions, lifestyle, or combination | 5–10% | 125–500%+ of standard |
| **Decline** | Risk too high to insure at any standard price | 3–5% | N/A |

### 9.2 Table Ratings (Substandard)

When an applicant doesn't fit into standard risk classes, a **table rating** is applied:

```
TABLE RATING SYSTEM (Standard = 100%)

Table   Extra Mortality    Premium Impact (Approx.)
─────   ──────────────    ──────────────────────────
  A     +25% (125%)       +25% above standard premium
  B     +50% (150%)       +50% above standard premium
  C     +75% (175%)       +75% above standard premium
  D     +100% (200%)      +100% (double standard premium)
  E     +125% (225%)
  F     +150% (250%)
  G     +175% (275%)
  H     +200% (300%)
  J     +225% (325%)
  K     +250% (350%)
  L     +275% (375%)
  P     +300%+ (400%+)    Maximum typically offered

Note: Some carriers use numerical tables (Table 2 = 150%, Table 4 = 200%, etc.)
```

### 9.3 Flat Extra Premiums

For risks that are **temporary** or **specific** (not reflected in table ratings):

```
FLAT EXTRA: Additional $ per $1,000 of face amount per year

Examples:
  Aviation (private pilot, <200 hours) .... $2.50 per $1,000/year
  Skydiving (>25 jumps/year) .............. $5.00 per $1,000/year
  History of cancer (within 5 years) ....... $7.50 per $1,000/year for 5 years
  Foreign travel (moderate risk country) ... $5.00 per $1,000/year, temporary

On a $500,000 policy with a $5.00 flat extra:
  Annual flat extra = $5.00 × 500 = $2,500 additional per year
```

### 9.4 Exclusion Riders

Instead of rating, certain risks may be **excluded** from coverage:

- **Aviation Exclusion**: Death from private aviation not covered
- **Avocation Exclusion**: Death from specific activity not covered
- **Foreign Residence/Travel Exclusion**: Death while in specific countries
- **War Exclusion**: Death from war or military action (standard in most policies)

---

## 10. Mortality & Morbidity Fundamentals

### 10.1 Mortality Tables

Underwriting and pricing rely on **mortality tables** that express the probability of death at each age:

| Table | Source | Use |
|-------|--------|-----|
| **2017 CSO (Commissioners Standard Ordinary)** | SOA / NAIC | Statutory minimum reserves; regulatory valuation |
| **2015 VBT (Valuation Basic Table)** | SOA | Basis for pricing; reflects insured population mortality |
| **2008 VBT** | SOA | Still used by some carriers; being replaced by 2015 VBT |
| **Company-Specific Experience Tables** | Internal actuarial | Carrier's own mortality experience; most accurate for pricing |
| **Reinsurance Mortality Tables** | Reinsurers (Swiss Re, Munich Re, RGA, etc.) | Used for reinsurance pricing and treaty negotiations |

### 10.2 Select and Ultimate Mortality

- **Select Period**: The first 15-25 years after underwriting. Mortality is *lower* than ultimate because underwriting has screened out high-risk individuals.
- **Ultimate Period**: After the select period, mortality converges to general population rates. The "underwriting wear-off" effect.

```
Mortality Rate
     │
     │                                 ╱ Ultimate
     │                            ╱───
     │                       ╱───
     │                  ╱───
     │         ╱───────
     │    ╱───    Select period
     │───        (underwriting benefit)
     │
     └──────────────────────────────────── Duration
          0    5    10   15   20   25
```

### 10.3 Mortality Improvement

- Life expectancy has been increasing ~1-2% per year.
- Pricing may include **mortality improvement factors** — assumption that future mortality will be lower than current tables.
- COVID-19 caused a temporary mortality increase in 2020-2022; long-term impact still being studied.

### 10.4 Experience Studies

Carriers and industry bodies conduct **experience studies** comparing actual deaths to expected:

```
Actual-to-Expected (A/E) Ratio = Actual Deaths / Expected Deaths (per table)

A/E < 100%: Mortality better than expected (profitable)
A/E = 100%: Mortality as expected (pricing accurate)
A/E > 100%: Mortality worse than expected (unprofitable)

Targets by risk class:
  Preferred Plus:  A/E target 50-65%
  Preferred:       A/E target 70-85%
  Standard:        A/E target 90-100%
  Substandard:     A/E target 90-110%
```

---

## 11. Reinsurance in Term Underwriting

### 11.1 Why Reinsurance

- **Risk Transfer**: No single carrier retains 100% of large face amount policies.
- **Capacity**: Reinsurance enables carriers to write policies exceeding their retention limit.
- **Volatility Management**: Smooths mortality fluctuations.
- **Expertise**: Reinsurers provide underwriting manuals, training, and pricing support (especially for smaller carriers).

### 11.2 Retention and Cession

```
EXAMPLE: Carrier retention = $5M per life

Application: $10M face amount, 40-year-old male, Preferred

Carrier retains:     $5,000,000 (50%)
Ceded to Reinsurer:  $5,000,000 (50%)

Automatic Treaty: Reinsurer accepts risk automatically up to treaty limit
                  if it meets treaty criteria (no individual review needed)

Facultative:      If risk exceeds auto limits or has unusual features,
                  submitted to reinsurer for individual underwriting review
```

### 11.3 Reinsurance Types

| Type | Description |
|------|------------|
| **Automatic / Treaty** | Reinsurer agrees in advance to accept risks meeting defined criteria. No case-by-case review. Most common. |
| **Facultative** | Each case submitted individually to reinsurer for review and acceptance. Used for large/complex risks. |
| **YRT (Yearly Renewable Term)** | Most common reinsurance premium basis. Reinsurance premium = mortality rate × net amount at risk. |
| **Coinsurance** | Reinsurer shares proportionally in premiums, reserves, and claims. Less common for term. |

### 11.4 Key Reinsurers in Life

| Reinsurer | Headquarters | Specialty |
|-----------|-------------|-----------|
| **Swiss Re** | Zurich | Largest life reinsurer globally |
| **Munich Re** | Munich | Second largest; strong in mortality research |
| **RGA (Reinsurance Group of America)** | St. Louis | Largest US-based life reinsurer |
| **SCOR** | Paris | Global reinsurer |
| **Hannover Re** | Hannover | Strong in automated underwriting support |
| **Gen Re (Berkshire Hathaway)** | Stamford | Specialty reinsurance |

---

## 12. Policy Issue & Delivery

### 12.1 Issue Process

```
UW Decision ──▶ Compliance ──▶ Policy ──▶ Quality ──▶ Delivery ──▶ Free Look
  (Approve)      Review         Assembly    Check       to Owner     Period
                                                                    (10-30 days)
```

### 12.2 Pre-Issue Checks

| Check | Description |
|-------|------------|
| **Suitability Review** | Is the product appropriate for the applicant's needs? (Required by many states.) |
| **Replacement Review** | Is the applicant replacing existing insurance? If yes, comparison required (state replacement regulations). |
| **State Filing Compliance** | Policy form approved in the state of issue? Rider available? |
| **Illustration Compliance** | If an illustration was used, does it comply with NAIC illustration model regulation? |
| **Anti-Money Laundering (AML)** | Large face amounts require AML screening; OFAC check on all applicants. |
| **Premium Verification** | Initial premium received and correct? Modal premium matches classification? |

### 12.3 Policy Delivery Methods

| Method | Timeline | Trend |
|--------|----------|-------|
| **Electronic (e-Delivery)** | Immediate | Growing rapidly |
| **Agent Delivery** | 1-3 days | Traditional; allows review with client |
| **Mail** | 5-10 days | Declining |

### 12.4 Free Look Period

- Most states provide **10-30 days** after delivery for the policyholder to review and return the policy for a full refund.
- Some states allow longer periods (e.g., senior citizens may get 30 days).
- Free look returns must be tracked as they impact new business metrics.

---

## 13. Post-Issue Underwriting

### 13.1 Contestability Period

- **First 2 years** after issue (most states): Carrier can investigate and rescind the policy if material misrepresentation is discovered.
- **After 2 years**: Incontestability clause prevents rescission except for fraud (varies by state).

### 13.2 Post-Issue Activities

| Activity | Description |
|----------|------------|
| **Change Requests** | Face amount increase (requires new underwriting), beneficiary change, address change |
| **Conversion** | Exercise of conversion privilege — term to permanent. Conversion underwriting (limited or full). |
| **Reinstatement** | Policy lapsed; applicant requests reinstatement. New evidence of insurability required. |
| **Assignment** | Collateral or absolute assignment. Review for STOLI indicators. |
| **Claims Investigation** | Death claim within contestability period triggers full investigation. |

---

## 14. Key Industry Bodies & Standards

| Organization | Role |
|-------------|------|
| **ACORD** | Data standards for life insurance (TXLife XML, forms) |
| **MIB Group** | Industry information exchange for prior application activity |
| **SOA (Society of Actuaries)** | Mortality research, experience studies, actuarial standards |
| **LIMRA** | Industry research, benchmarking, distribution studies |
| **NAIC** | Model regulations, statutory standards (CSO tables) |
| **AHOU (Academy of Home Office Underwriters)** | Underwriting education and certification (FALU, FLMI) |
| **ALU (Academy of Life Underwriting)** | Underwriting designation and continuing education |
| **LOMA** | Education and designations (FLMI) |
| **CLHIA (Canadian Life & Health Insurance Association)** | Canadian life insurance standards |

---

## 15. Glossary of Underwriting Terms

| Term | Definition |
|------|-----------|
| **APS** | Attending Physician Statement — medical records from treating doctor |
| **BPL** | Blood Profile with Lipids — standard blood panel for underwriting |
| **Build** | Height and weight combination, usually expressed as BMI |
| **Contestability** | 2-year period during which carrier can challenge misrepresentation |
| **Conversion** | Right to change term policy to permanent without new underwriting |
| **CSO** | Commissioners Standard Ordinary — statutory mortality table |
| **Debit/Credit** | System of adding (debit) or subtracting (credit) mortality risk to arrive at risk class |
| **Decline** | Refusal to issue coverage due to excessive risk |
| **Evidence** | Any information used to assess risk (labs, APS, Rx, MIB, etc.) |
| **Exclusion Rider** | Endorsement excluding a specific cause of death from coverage |
| **FALU** | Fellow, Academy of Life Underwriting — senior underwriting designation |
| **Flat Extra** | Additional per-$1,000 charge for temporary or specific risks |
| **FLMI** | Fellow, Life Management Institute — LOMA designation |
| **Free Look** | Period after delivery allowing full refund |
| **Impairment** | Medical condition or lifestyle factor that increases mortality risk |
| **Insurable Interest** | Legal and financial relationship justifying the insurance coverage |
| **MIB** | Medical Information Bureau — industry database of coded impairments |
| **MMI** | Maximum Medical Improvement |
| **Moral Hazard** | Risk that the existence of insurance changes behavior (incentive to cause loss) |
| **Mortality** | Rate of death in a population |
| **Paramedical** | Physical examination conducted by trained examiner (not a physician) |
| **Rated / Substandard** | Policy issued with extra premium due to elevated risk |
| **Retention** | Maximum amount of risk a carrier retains per life (excess ceded to reinsurer) |
| **Risk Class** | Category of risk (Preferred Plus, Preferred, Standard, etc.) |
| **Select Period** | Period after underwriting when mortality is lower than ultimate |
| **STOLI** | Stranger-Originated Life Insurance — prohibited scheme |
| **Table Rating** | Method of pricing substandard risk using lettered or numbered tables |
| **Underwriting Wear-Off** | Gradual loss of underwriting selection benefit over time |
| **VBT** | Valuation Basic Table — SOA mortality table for pricing |

---

*This article is Part 1 of a 10-part series on Term Life Insurance Underwriting. Proceed to [02_AUTOMATED_UNDERWRITING_ENGINE.md](02_AUTOMATED_UNDERWRITING_ENGINE.md) for the technical architecture deep dive.*
