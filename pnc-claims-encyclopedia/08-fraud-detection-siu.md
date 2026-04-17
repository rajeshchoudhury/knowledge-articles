# Fraud Detection & Special Investigations Unit (SIU) Operations

## A Comprehensive Architecture & Implementation Guide for P&C Insurance

---

## Table of Contents

1. [Insurance Fraud Landscape](#1-insurance-fraud-landscape)
2. [Fraud Taxonomy](#2-fraud-taxonomy)
3. [Red Flag Indicators by Claim Type](#3-red-flag-indicators-by-claim-type)
4. [SIU Organizational Structure](#4-siu-organizational-structure)
5. [SIU Investigation Process Flow](#5-siu-investigation-process-flow)
6. [Fraud Detection Technology Stack](#6-fraud-detection-technology-stack)
7. [Rule-Based Fraud Detection](#7-rule-based-fraud-detection)
8. [Statistical Anomaly Detection](#8-statistical-anomaly-detection)
9. [Machine Learning for Fraud Detection](#9-machine-learning-for-fraud-detection)
10. [Social Network Analysis (SNA)](#10-social-network-analysis-sna)
11. [Text Mining for Fraudulent Narratives](#11-text-mining-for-fraudulent-narratives)
12. [Image Forensics](#12-image-forensics)
13. [Geospatial Analysis](#13-geospatial-analysis)
14. [Predictive Fraud Scoring Models](#14-predictive-fraud-scoring-models)
15. [ISO ClaimSearch Integration](#15-iso-claimsearch-integration)
16. [NICB Integration](#16-nicb-integration)
17. [Fraud Referral Workflow & Data Model](#17-fraud-referral-workflow--data-model)
18. [Investigation Case Management](#18-investigation-case-management)
19. [Evidence Management](#19-evidence-management)
20. [SIU Reporting & Regulatory Requirements](#20-siu-reporting--regulatory-requirements)
21. [Fraud Analytics Dashboard](#21-fraud-analytics-dashboard)
22. [False Positive Management](#22-false-positive-management)
23. [Vendor Solutions](#23-vendor-solutions)
24. [Cost-Benefit Analysis](#24-cost-benefit-analysis)
25. [Privacy & Legal Considerations](#25-privacy--legal-considerations)
26. [Sample Fraud Scoring Rules & Algorithms](#26-sample-fraud-scoring-rules--algorithms)
27. [SIU Performance Metrics](#27-siu-performance-metrics)
28. [Real-Time Fraud Scoring Architecture](#28-real-time-fraud-scoring-architecture)

---

## 1. Insurance Fraud Landscape

### 1.1 Scale of Insurance Fraud

Insurance fraud is the second-largest economic crime in the United States after tax evasion. The FBI estimates that the total cost of insurance fraud (non-health) exceeds $40 billion per year, adding $400–$700 to annual premiums per household.

| Metric | Value | Source |
|--------|-------|--------|
| Annual fraud cost (non-health US) | $40+ billion | FBI |
| Annual fraud cost (all insurance US) | $80+ billion | Coalition Against Insurance Fraud |
| Fraud as % of total claim payments | 5–10% | Insurance Information Institute |
| Property/Casualty fraud estimate | $34 billion | NICB |
| Workers compensation fraud | $7.2 billion | National Insurance Crime Bureau |
| Auto insurance fraud | $29 billion | Insurance Research Council |
| Fraud detection rate (industry avg) | 20–30% | Various estimates |
| Premium impact per household | $400–$700/year | FBI |

### 1.2 Fraud by Line of Business

```
FRAUD PREVALENCE BY LOB:

  Auto (All)          ████████████████████████████░░  80% of P&C fraud
    ├─ Staged Accidents  ████████████░░░░░░░░░░░░░░░░  35%
    ├─ Inflated Claims   ████████████████░░░░░░░░░░░░  45%
    ├─ Phantom Vehicles  ███░░░░░░░░░░░░░░░░░░░░░░░░░  8%
    └─ Other Auto        ████░░░░░░░░░░░░░░░░░░░░░░░░  12%

  Workers Comp        ████████░░░░░░░░░░░░░░░░░░░░░░  10% of P&C fraud
    ├─ Malingering       ████████████░░░░░░░░░░░░░░░░  40%
    ├─ Fictitious Claims ██████░░░░░░░░░░░░░░░░░░░░░░  20%
    └─ Other WC          ████████████░░░░░░░░░░░░░░░░  40%

  Property            █████░░░░░░░░░░░░░░░░░░░░░░░░░  7% of P&C fraud
    ├─ Arson             ████████░░░░░░░░░░░░░░░░░░░░  30%
    ├─ Inflated Claims   ████████████████░░░░░░░░░░░░  50%
    └─ Staged Theft      █████░░░░░░░░░░░░░░░░░░░░░░░  20%

  General Liability   ██░░░░░░░░░░░░░░░░░░░░░░░░░░░░  3% of P&C fraud
    ├─ Slip-and-Fall     ████████████████░░░░░░░░░░░░  55%
    └─ Other GL          ████████████░░░░░░░░░░░░░░░░  45%
```

---

## 2. Fraud Taxonomy

### 2.1 Hard Fraud vs Soft Fraud

```
FRAUD CLASSIFICATION:

HARD FRAUD (Deliberate, Planned)
├─ Completely fabricated claims
├─ Staged accidents
├─ Intentional destruction (arson, vehicle dumping)
├─ Phantom injuries or vehicles
├─ Organized fraud rings
├─ Identity fraud (stolen policy, fake identity)
└─ Provider fraud (phantom treatments, fake diagnoses)

SOFT FRAUD (Opportunistic, Exaggerated)
├─ Inflated damage estimates
├─ Exaggerated injuries
├─ Padding legitimate claims with pre-existing damage
├─ Misrepresenting facts on application (affecting claim)
├─ Inflating value of stolen property
├─ Adding items to theft claims
└─ Exaggerating business interruption losses
```

### 2.2 Fraud Taxonomy by LOB

#### Auto Insurance Fraud

| Fraud Type | Description | Hard/Soft | Frequency |
|-----------|-------------|-----------|-----------|
| Staged rear-end collision | Intentionally causing rear-end accident | Hard | Medium |
| Swoop and squat | Staged multi-vehicle accident | Hard | Low |
| Side-swipe scheme | Staged lane-change collision | Hard | Low |
| Phantom vehicle | Filing claim for vehicle that doesn't exist | Hard | Low |
| Owner give-up | Disposing of vehicle to collect insurance | Hard | Medium |
| VIN switching/cloning | Placing VIN from wrecked vehicle on stolen one | Hard | Low |
| Inflated repair estimate | Padding repair costs above actual damage | Soft | Very High |
| Pre-existing damage | Claiming old damage as new | Soft | Very High |
| Phantom passengers | Adding fictional injured passengers | Hard | Medium |
| Exaggerated injury | Claiming injuries greater than actual | Soft | Very High |
| Paper accidents | Completely fabricated accident never occurred | Hard | Low |
| Jump-in claimant | Adding person not in vehicle to claim | Hard | Medium |
| Double dipping | Collecting from multiple carriers for same loss | Hard | Medium |
| Premium fraud | Misrepresenting info to reduce premium | Soft | High |

#### Property Insurance Fraud

| Fraud Type | Description | Hard/Soft | Frequency |
|-----------|-------------|-----------|-----------|
| Arson for profit | Setting fire to collect insurance | Hard | Low |
| Staged burglary | Faking a break-in and theft | Hard | Medium |
| Inflated contents claim | Overstating value of stolen/damaged items | Soft | Very High |
| Contractor fraud | Inflated repair estimates from complicit contractor | Soft | High |
| Pre-existing damage | Claiming old damage from new event | Soft | High |
| Fictitious loss | Loss never occurred | Hard | Low |
| Application fraud | Misrepresenting property to obtain coverage | Soft | Medium |
| Cat event exploitation | Using CAT event to claim unrelated damage | Soft | High |

#### Workers Compensation Fraud

| Fraud Type | Description | Hard/Soft | Frequency |
|-----------|-------------|-----------|-----------|
| Fictitious injury | Claiming injury that never occurred | Hard | Medium |
| Off-the-job injury | Claiming non-work injury as work-related | Hard | Medium |
| Malingering | Exaggerating disability/extending recovery | Soft | Very High |
| Working while collecting | Employed elsewhere while on disability | Hard | Medium |
| Provider fraud | Billing for treatments not rendered | Hard | Medium |
| Premium fraud (employer) | Misclassifying employees to reduce premium | Hard | High |
| Employee collusion | Multiple employees making related false claims | Hard | Low |

#### General Liability Fraud

| Fraud Type | Description | Hard/Soft | Frequency |
|-----------|-------------|-----------|-----------|
| Staged slip-and-fall | Faking a fall on business premises | Hard | Medium |
| Phantom injury | Claiming injury at location never visited | Hard | Low |
| Exaggerated injury | Inflating severity of actual injury | Soft | High |
| Professional plaintiff | Serial claimants filing across businesses | Hard | Low |
| Spoliation of evidence | Destroying or altering evidence | Hard | Low |

---

## 3. Red Flag Indicators by Claim Type

### 3.1 Universal Red Flags (All Claim Types)

| # | Red Flag | Risk Weight | Detection Method |
|---|----------|-------------|-----------------|
| 1 | Claim filed within 30 days of policy inception | High | Rule |
| 2 | Coverage increased within 90 days before loss | Very High | Rule |
| 3 | Multiple claims in 12-month period (3+) | Medium | Rule |
| 4 | History of prior SIU referrals | High | Database |
| 5 | Claimant uncooperative with investigation | High | Adjuster |
| 6 | Inconsistent or changing story | Very High | NLP + Adjuster |
| 7 | Excessive knowledge of insurance process | Medium | Adjuster |
| 8 | Claimant pushes for quick settlement | Medium | Adjuster |
| 9 | Policy about to lapse or cancel at time of loss | High | Rule |
| 10 | Financial difficulties (bankruptcy, liens) | Medium | External data |
| 11 | Claimant difficult to reach or uses burner phone | Medium | Adjuster |
| 12 | Loss occurs at unusual hour with no witnesses | Medium | Rule |
| 13 | Delayed reporting without good explanation | Medium | Rule |
| 14 | Prior insurance cancellation for non-payment | Medium | External data |
| 15 | Post office box or temporary address | Low | Rule |
| 16 | Claimant recently obtained coverage from another carrier | Medium | ISO ClaimSearch |
| 17 | Conflicting documentation | High | IDP + Adjuster |
| 18 | Claim amount just below SIU referral threshold | Medium | Rule |
| 19 | Evidence of alteration in documents | Very High | Image forensics |
| 20 | Social media contradicts claim | Very High | OSINT |

### 3.2 Auto-Specific Red Flags (21–50)

| # | Red Flag | Risk Weight |
|---|----------|-------------|
| 21 | Vehicle purchased recently (< 6 months) | Medium |
| 22 | Vehicle has high mileage relative to year | Medium |
| 23 | Vehicle has had multiple owners | Low |
| 24 | Damage inconsistent with described accident | Very High |
| 25 | Accident location is secluded/low-traffic | Medium |
| 26 | All occupants have same attorney | High |
| 27 | Attorney involvement within 24 hours of accident | High |
| 28 | All claimants go to same medical provider | High |
| 29 | Medical provider previously flagged for fraud | Very High |
| 30 | Soft tissue injuries only (no objective findings) | Medium |
| 31 | Treatment begins > 7 days after accident | Medium |
| 32 | Treatment pattern follows legal template | High |
| 33 | Other driver not located or uncooperative | Medium |
| 34 | No police report filed despite significant accident | Medium |
| 35 | Police report obtained by claimant (not officer-filed) | High |
| 36 | Tow truck arrived before police (pre-arranged) | High |
| 37 | Same tow company across multiple suspicious claims | High |
| 38 | Rental duration exceeds repair timeframe | Medium |
| 39 | Repair at non-approved shop with inflated estimate | Medium |
| 40 | VIN doesn't match vehicle description | Very High |
| 41 | Salvage title or prior total loss | High |
| 42 | Vehicle insured at much higher value than actual | High |
| 43 | Multiple claims for same body panel | Medium |
| 44 | Rear-end collision with heavy braking marks only on front vehicle | Medium |
| 45 | Low-impact collision with disproportionate injuries | High |
| 46 | Claimants from different households in same vehicle | Medium |
| 47 | Driver not on policy and relationship unclear | Medium |
| 48 | Photos appear staged or edited | Very High |
| 49 | Accident occurs in jurisdiction known for fraud | Medium |
| 50 | Claimant has CDL or driving-related occupation | Low |

### 3.3 Property-Specific Red Flags (51–75)

| # | Red Flag | Risk Weight |
|---|----------|-------------|
| 51 | Property recently purchased | Medium |
| 52 | Property listed for sale before loss | High |
| 53 | Property in foreclosure | Very High |
| 54 | Owner not present at time of fire/loss | Medium |
| 55 | Multiple points of fire origin | Very High |
| 56 | Fire/theft occurs during renovations | Medium |
| 57 | Inventory list prepared before loss | High |
| 58 | Receipts for high-value items are photocopies | High |
| 59 | Contents inventory contains unusually high-end items | Medium |
| 60 | Security system disabled at time of theft | High |
| 61 | No sign of forced entry in burglary claim | High |
| 62 | Neighbors unaware of claimed valuable items | Medium |
| 63 | Prior water damage claims at same property | Medium |
| 64 | Insurance to value ratio is unusually high | High |
| 65 | Contractor is relative or associate of insured | High |
| 66 | Contractor estimate significantly above Xactimate | Medium |
| 67 | Cat event claim but damage inconsistent with weather data | High |
| 68 | Claim for stolen jewelry without appraisal | Medium |
| 69 | Photos of loss scene are oddly composed or delayed | Medium |
| 70 | Insured recently added valuable items to inventory rider | High |
| 71 | Suspicious utility usage before fire (gas/electric) | Very High |
| 72 | Pets/personal valuables removed before fire | Very High |
| 73 | Recent large insurance on recently acquired property | High |
| 74 | Business interruption claim without revenue documentation | Medium |
| 75 | Claimed items not consistent with lifestyle/income | High |

### 3.4 Workers Compensation-Specific Red Flags (76–100)

| # | Red Flag | Risk Weight |
|---|----------|-------------|
| 76 | Monday morning claim (injury allegedly Friday) | Medium |
| 77 | Injury not witnessed | Medium |
| 78 | Disgruntled employee or recent discipline | Medium |
| 79 | Employee facing layoff or termination | High |
| 80 | Claim filed right before or after holiday/vacation | Medium |
| 81 | Employee works second job | Medium |
| 82 | History of frequent address changes | Low |
| 83 | Refusal to accept modified duty | Medium |
| 84 | Missed medical appointments | Medium |
| 85 | Social media shows physical activity during disability | Very High |
| 86 | Surveillance shows activity inconsistent with restrictions | Very High |
| 87 | Treatment from non-network provider far from home/work | Medium |
| 88 | Chiropractic-only treatment extending beyond guidelines | Medium |
| 89 | IME findings significantly different from treating physician | High |
| 90 | Employee retains attorney within days of injury | Medium |
| 91 | Same attorney represents multiple employees at same employer | High |
| 92 | Mechanism of injury inconsistent with medical findings | High |
| 93 | Delayed reporting by employee (> 48 hours) | Medium |
| 94 | Employee has prior WC claims (3+ in 5 years) | Medium |
| 95 | Employer reports suspicion of fraud | High |
| 96 | New employee (< 90 days) with injury claim | Medium |
| 97 | Seasonal/temporary employee with injury | Low |
| 98 | Provider treatment exceeds ODG guidelines | Medium |
| 99 | Pharmacy patterns show doctor shopping | High |
| 100 | Employee observed working elsewhere during disability | Very High |

---

## 4. SIU Organizational Structure

### 4.1 SIU Organization Chart

```
┌─────────────────────────────────────────────────────────────────┐
│                        VP of Claims                              │
│                            │                                     │
│                  ┌─────────▼──────────┐                         │
│                  │  SIU Director       │                         │
│                  │  - Strategy         │                         │
│                  │  - Budget           │                         │
│                  │  - Regulatory       │                         │
│                  └─────────┬──────────┘                         │
│                            │                                     │
│         ┌──────────────────┼──────────────────┐                 │
│         │                  │                  │                  │
│  ┌──────▼──────┐  ┌───────▼───────┐  ┌──────▼──────┐          │
│  │ SIU Manager │  │ SIU Manager   │  │ Analytics   │          │
│  │ (Field)     │  │ (Desk)        │  │ Manager     │          │
│  └──────┬──────┘  └───────┬───────┘  └──────┬──────┘          │
│         │                  │                  │                  │
│  ┌──────▼──────┐  ┌───────▼───────┐  ┌──────▼──────┐          │
│  │ Sr. Invest. │  │ Desk Invest.  │  │ Data        │          │
│  │ (Field)     │  │ (Phone/Desk)  │  │ Scientists  │          │
│  │ 6-8 staff   │  │ 4-6 staff     │  │ 2-3 staff   │          │
│  └─────────────┘  └───────────────┘  └─────────────┘          │
│                                                                  │
│  SUPPORTING ROLES:                                              │
│  ├─ Legal Counsel (internal or retained)                        │
│  ├─ Law Enforcement Liaison                                     │
│  ├─ Vendor Management (surveillance, forensics)                 │
│  └─ Administrative Support                                      │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

### 4.2 SIU Roles & Responsibilities

| Role | Responsibilities | Qualifications |
|------|-----------------|----------------|
| **SIU Director** | Strategy, budgeting, regulatory compliance, law enforcement liaison, executive reporting | 15+ years claims/investigations, CFE/CIFI, management experience |
| **SIU Manager** | Team leadership, case assignment, quality review, training, vendor management | 10+ years investigations, CFE, supervisory experience |
| **Sr. Investigator (Field)** | Complex field investigations, surveillance oversight, witness interviews, law enforcement coordination | 7+ years investigation, CFE, field experience |
| **Desk Investigator** | Desk-based investigations, database research, recorded statements, document analysis | 5+ years claims/investigation, strong analytical skills |
| **Analytics Manager** | Fraud model development, analytics strategy, reporting, technology evaluation | Data science background, insurance domain, ML experience |
| **Data Scientist** | Model development, feature engineering, anomaly detection, network analysis | MS/PhD in quantitative field, Python/R, ML experience |
| **SIU Coordinator** | Referral triage, case tracking, reporting, administrative support | Claims background, organizational skills |

---

## 5. SIU Investigation Process Flow

### 5.1 End-to-End SIU Process

```
┌──────────┐    ┌──────────┐    ┌──────────┐    ┌──────────┐    ┌──────────┐
│ REFERRAL │───▶│ TRIAGE   │───▶│ INVESTI- │───▶│ DETERMI- │───▶│ RESOLU-  │
│          │    │          │    │ GATION   │    │ NATION   │    │ TION     │
└──────────┘    └──────────┘    └──────────┘    └──────────┘    └──────────┘

STAGE 1: REFERRAL (Day 0)
  Sources:
    ├─ Automated fraud scoring (ML model, rules engine)
    ├─ Claims adjuster referral
    ├─ Underwriter referral
    ├─ Anonymous tip line
    ├─ Law enforcement notification
    ├─ NICB referral
    ├─ ISO ClaimSearch alert
    └─ Vendor/partner notification
  
  Data Captured:
    ├─ Claim information (number, type, amount)
    ├─ Referral source and reason
    ├─ Fraud indicators identified
    ├─ Fraud score and confidence
    ├─ Priority assessment
    └─ Supporting documentation

STAGE 2: TRIAGE (Days 1-3)
  Activities:
    ├─ SIU coordinator receives and logs referral
    ├─ Preliminary database checks (ISO, NICB, DMV, Lexis)
    ├─ Review claim file and adjuster notes
    ├─ Assess fraud probability (Low/Medium/High)
    ├─ Determine investigation type (desk/field)
    ├─ Assign to investigator based on:
    │   ├─ Geography
    │   ├─ Specialization (auto/property/WC/GL)
    │   ├─ Caseload
    │   └─ Complexity/severity
    └─ Set investigation priority and timeline
  
  Triage Outcomes:
    ├─ ACCEPT: Assign for investigation
    ├─ RETURN: Insufficient indicators, return to adjuster with notes
    ├─ REFER OUT: Law enforcement, state bureau, NICB
    └─ CLOSE: No fraud indicators upon review

STAGE 3: INVESTIGATION (Days 3-60+)
  Desk Investigation Activities:
    ├─ Comprehensive database searches
    ├─ Recorded statement(s) of insured/claimant
    ├─ Medical record analysis
    ├─ Financial background check
    ├─ Social media investigation
    ├─ Phone records analysis (if warranted)
    ├─ Document verification
    └─ Vendor invoice verification
    
  Field Investigation Activities:
    ├─ Scene investigation/documentation
    ├─ Witness interviews
    ├─ Surveillance operations
    ├─ Vehicle/property inspection
    ├─ Examination Under Oath (EUO)
    ├─ Forensic expert engagement (fire, accident recon)
    └─ Law enforcement coordination

STAGE 4: DETERMINATION (Days 45-90)
  Activities:
    ├─ Compile investigation findings
    ├─ Document evidence chain
    ├─ Evaluate sufficiency of evidence
    ├─ Legal review of findings
    ├─ Make determination:
    │   ├─ FRAUD CONFIRMED: Sufficient evidence of fraud
    │   ├─ SUSPICIOUS: Indicators present but insufficient evidence
    │   ├─ NOT FRAUD: Investigation clears claim
    │   └─ INCONCLUSIVE: Unable to determine
    └─ Recommend claim action

STAGE 5: RESOLUTION (Days 60-120)
  Actions Based on Determination:
    FRAUD CONFIRMED:
      ├─ Deny claim with documented basis
      ├─ Refer to law enforcement (if criminal)
      ├─ File state fraud bureau report
      ├─ Pursue civil remedies if applicable
      ├─ Policy rescission/cancellation
      ├─ Add to internal watch list
      └─ Update NICB/ISO records
    
    SUSPICIOUS (insufficient evidence):
      ├─ Pay claim with documentation of concerns
      ├─ File state fraud bureau report if required
      ├─ Add to internal watch list
      └─ Flag for future claim monitoring
    
    NOT FRAUD:
      ├─ Return claim to adjuster for normal processing
      ├─ Document investigation findings
      └─ Remove any claim holds
```

---

## 6. Fraud Detection Technology Stack

### 6.1 Technology Architecture

```
┌─────────────────────────────────────────────────────────────────────┐
│                    FRAUD DETECTION PLATFORM                          │
│                                                                      │
│  ┌───────────────────────────────────────────────────────────────┐  │
│  │                    DETECTION LAYER                             │  │
│  │                                                                │  │
│  │  ┌──────────────┐  ┌──────────────┐  ┌──────────────────┐   │  │
│  │  │ Rules Engine │  │ ML Models    │  │ Network Analysis │   │  │
│  │  │              │  │              │  │                  │   │  │
│  │  │ - Expert     │  │ - Supervised │  │ - Link Analysis  │   │  │
│  │  │   rules      │  │ - Unsuperv.  │  │ - Community      │   │  │
│  │  │ - Threshold  │  │ - Anomaly    │  │   Detection      │   │  │
│  │  │ - Pattern    │  │ - Text       │  │ - Ring Identif.  │   │  │
│  │  └──────────────┘  └──────────────┘  └──────────────────┘   │  │
│  │                                                                │  │
│  │  ┌──────────────┐  ┌──────────────┐  ┌──────────────────┐   │  │
│  │  │ Text Mining  │  │ Image        │  │ Geospatial       │   │  │
│  │  │              │  │ Forensics    │  │ Analysis         │   │  │
│  │  │ - NLP        │  │              │  │                  │   │  │
│  │  │ - Sentiment  │  │ - Tamper     │  │ - Location       │   │  │
│  │  │ - Anomaly    │  │   detection  │  │   verification   │   │  │
│  │  └──────────────┘  └──────────────┘  └──────────────────┘   │  │
│  └───────────────────────────────────────────────────────────────┘  │
│                                │                                     │
│  ┌─────────────────────────────▼─────────────────────────────────┐  │
│  │                    SCORING & DECISIONING                       │  │
│  │                                                                │  │
│  │  ┌──────────────────────────────────────────────────────┐    │  │
│  │  │  Fraud Score Aggregator                               │    │  │
│  │  │  - Combine rule scores, ML scores, SNA scores         │    │  │
│  │  │  - Calibrate to 0-100 scale                           │    │  │
│  │  │  - Apply business thresholds                          │    │  │
│  │  │  - Generate referral recommendation                   │    │  │
│  │  └──────────────────────────────────────────────────────┘    │  │
│  └───────────────────────────────────────────────────────────────┘  │
│                                │                                     │
│  ┌─────────────────────────────▼─────────────────────────────────┐  │
│  │                    DATA LAYER                                  │  │
│  │                                                                │  │
│  │  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────────┐    │  │
│  │  │ Claims   │ │ Policy   │ │ External │ │ Graph DB     │    │  │
│  │  │ Database │ │ Database │ │ Data     │ │ (Neo4j)      │    │  │
│  │  │          │ │          │ │ (ISO,    │ │              │    │  │
│  │  │          │ │          │ │  NICB,   │ │ Relationships│    │  │
│  │  │          │ │          │ │  LexisN) │ │ & Networks   │    │  │
│  │  └──────────┘ └──────────┘ └──────────┘ └──────────────┘    │  │
│  └───────────────────────────────────────────────────────────────┘  │
│                                                                      │
└─────────────────────────────────────────────────────────────────────┘
```

---

## 7. Rule-Based Fraud Detection

### 7.1 Rule Categories

#### Expert Rules (Based on SIU Investigation Experience)

```
EXPERT_RULE_001: "New Policy Quick Claim"
  IF policy.daysFromInception < 30 AND claim.type NOT IN ('WEATHER', 'CAT')
  THEN fraud_score += 15, flag = "NEW_POLICY_QUICK_CLAIM"

EXPERT_RULE_002: "Coverage Increase Before Loss"
  IF EXISTS(endorsement WHERE type='COVERAGE_INCREASE'
    AND DAYS_BETWEEN(effectiveDate, claim.dateOfLoss) < 90)
  THEN fraud_score += 25, flag = "RECENT_COVERAGE_INCREASE"

EXPERT_RULE_003: "Financial Stress Indicator"
  IF (claimant.bankruptcyLast5Years = true
    OR claimant.taxLiensActive > 0
    OR claimant.judgmentsActive > 0)
  THEN fraud_score += 10, flag = "FINANCIAL_STRESS"

EXPERT_RULE_004: "Professional Claimant Pattern"
  IF claimant.totalClaimsAllCarriers5Year >= 5
  THEN fraud_score += 20, flag = "PROFESSIONAL_CLAIMANT"

EXPERT_RULE_005: "Attorney Retention Speed"
  IF attorney.retainedWithin48Hours = true
    AND claim.type = 'AUTO_BI'
  THEN fraud_score += 12, flag = "QUICK_ATTORNEY"

EXPERT_RULE_006: "Provider Red Flag"
  IF ANY(claim.providers IN fraudWatchList)
  THEN fraud_score += 20, flag = "FLAGGED_PROVIDER"

EXPERT_RULE_007: "Damage-Description Mismatch"
  IF claimDescriptionAnalysis.speedEstimate = 'LOW_SPEED'
    AND (claim.injuryCount > 2 OR claim.injurySeverity = 'HIGH')
  THEN fraud_score += 18, flag = "DAMAGE_INJURY_MISMATCH"
```

#### Threshold Rules

```
THRESHOLD_RULE_001: "High Value Relative to Vehicle"
  IF claim.amount / vehicle.actualCashValue > 0.80
    AND claim.type != 'TOTAL_LOSS'
  THEN fraud_score += 10, flag = "HIGH_RELATIVE_VALUE"

THRESHOLD_RULE_002: "Excessive Reporting Delay"
  IF claim.daysToReport > 30
  THEN fraud_score += 8, flag = "LATE_REPORTING"

THRESHOLD_RULE_003: "Excessive Treatment Duration"
  IF claim.treatmentDurationDays > 180
    AND claim.injuryType = 'SOFT_TISSUE'
  THEN fraud_score += 10, flag = "EXCESSIVE_TREATMENT"

THRESHOLD_RULE_004: "ISO Match Count High"
  IF isoSearchResults.matchCount > 3
  THEN fraud_score += 12, flag = "MULTIPLE_ISO_MATCHES"

THRESHOLD_RULE_005: "Multiple Claims Same Period"
  IF COUNT(claims WHERE policyId = claim.policyId AND year = CURRENT_YEAR) > 2
  THEN fraud_score += 10, flag = "MULTIPLE_CLAIMS"
```

#### Pattern Rules

```
PATTERN_RULE_001: "Day-of-Week Pattern (Auto)"
  IF DAY_OF_WEEK(claim.dateOfLoss) IN (FRIDAY, SATURDAY)
    AND TIME(claim.timeOfLoss) BETWEEN '20:00' AND '04:00'
    AND claim.causeOfLoss IN ('THEFT', 'VANDALISM', 'HIT_AND_RUN')
  THEN fraud_score += 5, flag = "SUSPICIOUS_TIMING"

PATTERN_RULE_002: "Monday Morning Injury (WC)"
  IF claim.lob = 'WORKERS_COMP'
    AND DAY_OF_WEEK(claim.dateReported) = MONDAY
    AND claim.dateOfLoss IN (FRIDAY, SATURDAY, SUNDAY)
    AND claim.noWitnesses = true
  THEN fraud_score += 12, flag = "MONDAY_MORNING_CLAIM"

PATTERN_RULE_003: "Geographic Cluster"
  IF COUNT(claims WHERE ZIP_3 = claim.ZIP_3
    AND ABS(dateOfLoss - claim.dateOfLoss) < 30
    AND sameProvider = true) > 3
  THEN fraud_score += 15, flag = "GEOGRAPHIC_CLUSTER"

PATTERN_RULE_004: "Provider Volume Spike"
  IF provider.currentMonthClaims > provider.avg6MonthClaims * 2.0
  THEN fraud_score += 12, flag = "PROVIDER_VOLUME_SPIKE"

PATTERN_RULE_005: "Sequential Claim Pattern"
  IF claim_N.dateOfLoss - claim_N-1.closedDate < 30
    AND claim_N.type = claim_N-1.type
    AND claim_N.policyId = claim_N-1.policyId
  THEN fraud_score += 10, flag = "SEQUENTIAL_CLAIMS"
```

---

## 8. Statistical Anomaly Detection

### 8.1 Benford's Law Analysis

```
BENFORD'S LAW APPLICATION:

First-digit distribution of legitimate financial data follows:
  Digit 1: 30.1%
  Digit 2: 17.6%
  Digit 3: 12.5%
  Digit 4:  9.7%
  Digit 5:  7.9%
  Digit 6:  6.7%
  Digit 7:  5.8%
  Digit 8:  5.1%
  Digit 9:  4.6%

APPLICATION IN CLAIMS:
  - Analyze first digits of: repair estimates, medical bills,
    reserve amounts, payment amounts, invoice totals
  - Flag providers/adjusters whose distributions significantly
    deviate from Benford's Law (chi-square test, p < 0.05)

EXAMPLE OUTPUT:
  Provider: Dr. Smith Medical Group
  Invoice First-Digit Distribution (n=500):
    Digit 1: 18.2% (Expected: 30.1%) ← Anomaly
    Digit 2: 22.8% (Expected: 17.6%) ← Anomaly
    Digit 3: 15.4% (Expected: 12.5%)
    Digit 4: 12.6% (Expected:  9.7%) ← Anomaly
    Digit 5:  9.8% (Expected:  7.9%)
    Digit 6:  7.2% (Expected:  6.7%)
    Digit 7:  5.6% (Expected:  5.8%)
    Digit 8:  4.8% (Expected:  5.1%)
    Digit 9:  3.6% (Expected:  4.6%)
    
  Chi-Square: 45.3, p-value: 0.0001
  RESULT: SIGNIFICANT DEVIATION - Flag for investigation
```

### 8.2 Outlier Detection

```
METHODS:

1. Z-Score Method (Univariate)
   z = (x - mean) / std_dev
   Flag if |z| > 3.0
   
   Application: Repair cost vs similar vehicle/damage claims
   Example: Claim repair cost $15,000 for minor rear bumper dent
            Mean for similar: $2,500, StdDev: $1,200
            Z-score = (15000 - 2500) / 1200 = 10.4 → EXTREME OUTLIER

2. IQR Method
   Q1, Q3 = 25th and 75th percentiles
   IQR = Q3 - Q1
   Lower bound = Q1 - 1.5 * IQR
   Upper bound = Q3 + 1.5 * IQR
   Flag if outside bounds

3. Isolation Forest (Multivariate)
   - Unsupervised anomaly detection
   - Isolates anomalies by randomly partitioning feature space
   - Anomalies require fewer partitions to isolate
   - Score: -1 (anomaly) to +1 (normal)
   - Threshold: typically score < -0.5

4. Local Outlier Factor (LOF)
   - Density-based anomaly detection
   - Compares local density of point to neighbors
   - LOF > 1.5 indicates potential anomaly
   - Good for detecting clusters of legitimate claims vs fraudulent outliers

5. Mahalanobis Distance
   - Accounts for feature correlations
   - Measures distance from centroid of normal claims
   - Flag if distance > chi-square critical value
```

---

## 9. Machine Learning for Fraud Detection

### 9.1 Supervised Learning Approaches

```
MODEL: Supervised Fraud Classifier

ALGORITHMS EVALUATED:
  1. XGBoost (best performance typically)
  2. LightGBM (fast, good with categorical)
  3. Random Forest (robust, interpretable)
  4. Logistic Regression (baseline, interpretable)
  5. Neural Network (capture complex patterns)

TRAINING DATA:
  - Historical claims with SIU outcomes (FRAUD / NOT_FRAUD)
  - Class imbalance: typically 2-5% fraud rate
  - Handling imbalance: SMOTE, class weights, cost-sensitive learning

FEATURE ENGINEERING:
  - 200+ features (see Article 7 feature catalog)
  - Key fraud-specific features:
    - Days from inception to loss
    - Coverage change history
    - Prior claim patterns
    - ISO ClaimSearch results
    - NLP narrative indicators
    - Social network features
    - Provider-level aggregates
    - Geographic risk factors

PERFORMANCE (Typical):
  Metric           XGBoost  LightGBM  RandomForest  LogReg  NeuralNet
  AUC-ROC          0.92     0.91      0.89          0.84    0.90
  Precision@10%    0.42     0.40      0.38          0.32    0.39
  Recall@10%       0.68     0.65      0.62          0.52    0.64
  Lift@Top10%      4.2x     4.0x      3.8x          3.2x    3.9x
  F1 (optimal)     0.67     0.65      0.63          0.55    0.64

ENSEMBLE:
  Final = 0.50 * XGBoost + 0.25 * LightGBM + 0.25 * NeuralNet
  Ensemble AUC: 0.93
```

### 9.2 Unsupervised Anomaly Detection

```
METHOD: Isolation Forest + Autoencoder Ensemble

ISOLATION FOREST:
  - n_estimators: 500
  - max_samples: 0.8
  - contamination: 0.05 (expected fraud rate)
  - Features: all numeric features (standardized)
  
  Anomaly Score → converted to 0-100 scale
  Threshold: > 70 → flag for review

AUTOENCODER:
  Architecture:
    Encoder: 200 → 128 → 64 → 32 (latent space)
    Decoder: 32 → 64 → 128 → 200
    Activation: ReLU (hidden), Sigmoid (output)
    Loss: MSE (reconstruction error)
  
  Training: On clean (non-fraud) claims only
  Inference: High reconstruction error → potential fraud
  
  Threshold: Error > 95th percentile → flag for review

COMBINED SCORING:
  unsupervised_score = 0.5 * isolation_forest_score + 0.5 * autoencoder_score
  
  IF unsupervised_score > 70 AND supervised_score > 50:
    HIGH_PRIORITY_REFERRAL
  ELIF unsupervised_score > 70 OR supervised_score > 60:
    MEDIUM_PRIORITY_REFERRAL
  ELIF unsupervised_score > 50 AND supervised_score > 40:
    ENHANCED_MONITORING
```

### 9.3 Semi-Supervised Learning

```
METHOD: Label Propagation + Self-Training

CHALLENGE: Limited labeled fraud cases, vast unlabeled claims

APPROACH:
  1. Start with small labeled set (5,000 confirmed fraud + 50,000 confirmed clean)
  2. Train initial supervised model
  3. Score remaining 500,000+ unlabeled claims
  4. High-confidence predictions (score > 0.90 or < 0.10) added to training
  5. Retrain model with expanded labeled set
  6. Repeat 3-5 iterations until convergence
  
IMPROVEMENT:
  Initial model AUC: 0.88
  After 3 iterations: 0.91
  After 5 iterations: 0.92 (converged)
  
CAUTION:
  - Risk of reinforcing model biases
  - Human review of pseudo-labels recommended
  - Track label propagation confidence
```

---

## 10. Social Network Analysis (SNA)

### 10.1 Network Graph Model

```
GRAPH MODEL (Neo4j):

NODES:
  (:Person {name, ssn, dob, address, phone, email})
  (:Vehicle {vin, make, model, year, plate})
  (:Claim {claimId, dateOfLoss, amount, type})
  (:Policy {policyId, effectiveDate, premium})
  (:Provider {npi, name, specialty, address})
  (:Attorney {barNumber, name, firm})
  (:Address {street, city, state, zip})
  (:Phone {number})
  (:Employer {name, ein})
  (:BankAccount {accountNumber, routingNumber})

RELATIONSHIPS:
  (:Person)-[:FILED]->(:Claim)
  (:Person)-[:CLAIMANT_ON]->(:Claim)
  (:Person)-[:WITNESS_ON]->(:Claim)
  (:Person)-[:OWNS]->(:Vehicle)
  (:Person)-[:DRIVES]->(:Vehicle)
  (:Person)-[:INSURED_ON]->(:Policy)
  (:Person)-[:LIVES_AT]->(:Address)
  (:Person)-[:HAS_PHONE]->(:Phone)
  (:Person)-[:WORKS_AT]->(:Employer)
  (:Person)-[:TREATED_BY]->(:Provider)
  (:Person)-[:REPRESENTED_BY]->(:Attorney)
  (:Vehicle)-[:INVOLVED_IN]->(:Claim)
  (:Provider)-[:BILLED]->(:Claim)
  (:Attorney)-[:REPRESENTS_ON]->(:Claim)
  (:Claim)-[:ON_POLICY]->(:Policy)
  (:Person)-[:RELATED_TO]->(:Person) {relationship_type}
  (:Person)-[:SHARED_ADDRESS_WITH]->(:Person)
  (:Person)-[:SHARED_PHONE_WITH]->(:Person)
```

### 10.2 Fraud Ring Detection

```
ALGORITHM: Community Detection for Fraud Rings

APPROACH:
  1. Build graph from claims data (all entities and relationships)
  2. Run community detection (Louvain / Label Propagation)
  3. Score communities based on fraud indicators
  4. Flag suspicious communities for investigation

COMMUNITY SCORING:
  community_fraud_score = weighted_sum(
    0.25 * (count_shared_addresses / community_size),
    0.20 * (count_shared_phones / community_size),
    0.15 * (count_shared_providers / community_size),
    0.15 * (count_shared_attorneys / community_size),
    0.10 * (temporal_clustering_score),
    0.10 * (geographic_clustering_score),
    0.05 * (avg_individual_fraud_score)
  )

CYPHER QUERY EXAMPLE (Neo4j):
  // Find people connected through shared addresses and claims
  MATCH (p1:Person)-[:LIVES_AT]->(a:Address)<-[:LIVES_AT]-(p2:Person)
  WHERE p1 <> p2
  MATCH (p1)-[:CLAIMANT_ON]->(c1:Claim)
  MATCH (p2)-[:CLAIMANT_ON]->(c2:Claim)
  WHERE c1.dateOfLoss > date() - duration('P2Y')
    AND c2.dateOfLoss > date() - duration('P2Y')
  WITH p1, p2, a, 
       collect(DISTINCT c1) AS claims1, 
       collect(DISTINCT c2) AS claims2
  WHERE size(claims1) > 1 AND size(claims2) > 1
  RETURN p1.name, p2.name, a.address, 
         size(claims1) AS p1Claims, 
         size(claims2) AS p2Claims

EXAMPLE FRAUD RING OUTPUT:
  ┌─────────────────────────────────────────────────────┐
  │                 FRAUD RING #FR-2024-047              │
  │                                                      │
  │  Ring Score: 87/100 (HIGH)                           │
  │  Members: 7 persons                                  │
  │  Claims: 12 claims                                   │
  │  Total Amount: $185,000                              │
  │  Time Span: 8 months                                 │
  │                                                      │
  │  [Person A]──────[shared address]──────[Person B]    │
  │      │                                      │        │
  │   [Claim 1]  [Claim 2]               [Claim 3]      │
  │      │                                      │        │
  │  [Provider X]──────[billed on]──────[Provider X]     │
  │                                                      │
  │  [Person C]──────[shared phone]──────[Person D]      │
  │      │                                      │        │
  │   [Claim 4]  [Claim 5]      [Claim 6]  [Claim 7]   │
  │      │                           │                   │
  │  [Attorney Y]────[represents]────[Attorney Y]        │
  │                                                      │
  │  Connections:                                        │
  │  - 3 shared addresses                               │
  │  - 2 shared phone numbers                           │
  │  - 1 common medical provider (5 claims)             │
  │  - 1 common attorney (4 claims)                     │
  │  - All claims within 8-month window                 │
  │  - All claims in same county                        │
  └─────────────────────────────────────────────────────┘
```

---

## 11. Text Mining for Fraudulent Narratives

### 11.1 NLP Fraud Indicators

```
TEXT MINING PIPELINE FOR FRAUD DETECTION:

  STEP 1: Narrative Feature Extraction
    - Vocabulary complexity (type-token ratio)
    - Sentence length variability
    - Use of hedging language ("I think", "approximately", "maybe")
    - Specificity score (concrete details vs vague descriptions)
    - Temporal consistency (timeline makes sense)
    - Passive vs active voice ratio
    - Emotional language score
    - Insurance jargon usage (unusual for layperson)

  STEP 2: Fraud Language Patterns
    Suspicious phrases (weighted):
      "I was stopped at a red light"        (+3)  ← common in staged claims
      "came out of nowhere"                 (+2)  ← vague attribution
      "I believe the other driver was"      (+1)  ← hedging
      "I don't remember exactly"            (+2)  ← selective memory
      "my attorney said"                    (+3)  ← coached narrative
      "the other driver left the scene"     (+2)  ← no verifiable witness
      "I have receipts for everything"      (+2)  ← preemptive defense
      "I want to be made whole"             (+2)  ← insurance terminology
      
  STEP 3: Consistency Analysis
    - Compare FNOL narrative with recorded statement
    - Compare multiple statements over time
    - Check for contradictions in dates, times, locations
    - Compare narrative details with physical evidence
    - Cosine similarity between statements (low similarity = inconsistency)
    
  STEP 4: Comparative Analysis
    - Compare narrative to known fraud case narratives (embedding similarity)
    - Cluster similar narratives to detect templates/scripted claims
    - Detect copy-paste patterns across related claims
```

---

## 12. Image Forensics

### 12.1 Photo Manipulation Detection

```
IMAGE FORENSICS PIPELINE:

  CHECK 1: EXIF Metadata Analysis
    - Camera make/model consistency
    - GPS coordinates vs claim location
    - Date/time vs claimed loss date
    - Software editing indicators (Photoshop, GIMP)
    - Image resolution consistency
    
  CHECK 2: Error Level Analysis (ELA)
    - Detect regions with different compression levels
    - Manipulated areas show different error patterns
    - Threshold: ELA variance > 2x background
    
  CHECK 3: Clone Detection
    - Detect copy-paste regions within image
    - Uses DCT-based or keypoint matching algorithms
    - Common in damage inflation (duplicating damage regions)
    
  CHECK 4: Splicing Detection
    - Detect if image is composite of multiple photos
    - Lighting direction analysis
    - Shadow consistency analysis
    - Noise pattern analysis
    
  CHECK 5: Temporal Consistency
    - Weather/lighting consistent with claimed date/time
    - Foliage/season consistent with claimed date
    - Background elements consistent with claimed location
    
  CHECK 6: Reverse Image Search
    - Search for identical/similar images online
    - Detect stock photos or previously used claim photos
    - Compare across carrier's historical claim photos
```

---

## 13. Geospatial Analysis

### 13.1 Location-Based Fraud Detection

```
GEOSPATIAL FRAUD CHECKS:

  GEO-001: Loss Location vs Insured Address
    IF DISTANCE(claim.lossLocation, policy.garagingAddress) > 200 miles
      AND claim.type NOT IN ('TRAVEL', 'VACATION', 'BUSINESS_TRIP')
    THEN flag = "DISTANT_LOSS_LOCATION"

  GEO-002: Loss Location vs Repair Shop
    IF DISTANCE(claim.lossLocation, claim.repairShop.address) > 50 miles
      AND repair shop is not the claimant's chosen shop
    THEN flag = "DISTANT_REPAIR_SHOP"

  GEO-003: Hotspot Analysis
    Identify geographic clusters of suspicious claims
    METHOD: Kernel Density Estimation (KDE)
    Flag zones with claim density > 2x standard deviation above mean
    Cross-reference with known fraud hotspots

  GEO-004: Route Plausibility
    IF claim.lossLocation NOT ON plausible route
      between claimant's home and stated destination
    THEN flag = "IMPLAUSIBLE_ROUTE"

  GEO-005: Provider Geographic Pattern
    IF provider.patients come from > 50 mile radius
      AND provider is not a specialist
    THEN flag = "UNUSUAL_PROVIDER_CATCHMENT"
    
  GEO-006: Claim Location vs Property
    IF claim.type = 'PROPERTY'
      AND damage_location does not match insured property coordinates
    THEN flag = "LOCATION_MISMATCH"
```

---

## 14. Predictive Fraud Scoring Models

### 14.1 Score Architecture

```
FRAUD SCORING MODEL ARCHITECTURE:

  INPUT LAYERS:
    ┌─────────────────┐
    │ Rule-Based Score │ → Rules engine output (0-100)
    │ ML Score         │ → Supervised model output (0-1)
    │ Anomaly Score    │ → Unsupervised model output (0-1)
    │ SNA Score        │ → Network analysis output (0-1)
    │ NLP Score        │ → Text mining output (0-1)
    │ Image Score      │ → Image forensics output (0-1)
    │ Geo Score        │ → Geospatial analysis output (0-1)
    └─────────────────┘
    
  AGGREGATION LAYER:
    composite_score = 
      w1 * rule_score +          (w1 = 0.15)
      w2 * ml_score * 100 +     (w2 = 0.35)
      w3 * anomaly_score * 100 + (w3 = 0.15)
      w4 * sna_score * 100 +    (w4 = 0.15)
      w5 * nlp_score * 100 +    (w5 = 0.10)
      w6 * image_score * 100 +  (w6 = 0.05)
      w7 * geo_score * 100      (w7 = 0.05)
    
  CALIBRATION:
    Apply isotonic regression to map composite to calibrated probability
    
  THRESHOLDS:
    Score 0-25:   LOW RISK    → Normal processing
    Score 26-50:  MEDIUM RISK → Enhanced monitoring
    Score 51-75:  HIGH RISK   → Adjuster alert + enhanced review
    Score 76-100: VERY HIGH   → Auto-referral to SIU

  SCORE DISTRIBUTION (Expected):
    LOW:       70-75% of claims
    MEDIUM:    15-20% of claims
    HIGH:       5-8% of claims
    VERY HIGH:  2-5% of claims
```

### 14.2 Score Calibration

```
CALIBRATION METHOD: Isotonic Regression

PURPOSE: Ensure score reflects true fraud probability
  e.g., Score of 80 should mean ~80% fraud rate in that score band

CALIBRATION TABLE (Example):
  Score Band  | Claims | Confirmed Fraud | Fraud Rate | Calibrated Score
  0-10        | 35,000 |     70          |  0.2%      | 2
  11-20       | 20,000 |    160          |  0.8%      | 8
  21-30       | 12,000 |    240          |  2.0%      | 15
  31-40       |  8,000 |    320          |  4.0%      | 25
  41-50       |  5,000 |    350          |  7.0%      | 38
  51-60       |  3,500 |    385          | 11.0%      | 52
  61-70       |  2,000 |    340          | 17.0%      | 65
  71-80       |  1,200 |    300          | 25.0%      | 78
  81-90       |    600 |    240          | 40.0%      | 88
  91-100      |    200 |    140          | 70.0%      | 96
```

---

## 15. ISO ClaimSearch Integration

### 15.1 Integration Architecture

```
INTEGRATION PATTERN: Real-Time + Batch

REAL-TIME (at FNOL):
  Claim Created → Extract search criteria → 
  Call ISO ClaimSearch API → Process results → 
  Update claim record → Factor into fraud score

BATCH (Daily):
  Export new claims → Bulk search submission →
  Receive batch results → Process and flag matches →
  Update fraud scores

SEARCH CRITERIA:
  - Claimant name (first, last, aliases)
  - Claimant SSN (partial or full)
  - Claimant date of birth
  - Claimant address
  - Vehicle VIN
  - License plate
  - Date of loss range
  - Loss location

API INTEGRATION:
  Endpoint: HTTPS REST API
  Authentication: API key + client certificate
  Format: JSON (or legacy XML)
  Rate limits: 100 searches/minute (standard)
  Response time: 2-5 seconds

RESULT PROCESSING:
  FOR EACH match IN iso_results:
    match_score = calculate_match_confidence(match)
    IF match_score > 0.85:
      STRONG_MATCH → auto-link to claim file
    ELIF match_score > 0.60:
      PROBABLE_MATCH → flag for adjuster review
    ELSE:
      POSSIBLE_MATCH → log for reference
    
    FLAG if:
      - Same claimant, same loss type, < 2 years
      - Same vehicle, different claimant
      - Same claimant, multiple carriers
      - Pattern suggests claim shopping
```

### 15.2 ISO ClaimSearch Data Model

```sql
CREATE TABLE iso_search_request (
    search_id        UUID PRIMARY KEY,
    claim_id         VARCHAR(20) NOT NULL,
    search_type      VARCHAR(20) NOT NULL,
    search_criteria  JSONB NOT NULL,
    search_timestamp TIMESTAMP NOT NULL,
    status           VARCHAR(20) NOT NULL,
    match_count      INTEGER,
    response_time_ms INTEGER,
    created_at       TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE iso_search_result (
    result_id        UUID PRIMARY KEY,
    search_id        UUID REFERENCES iso_search_request(search_id),
    iso_claim_number VARCHAR(30),
    carrier_name     VARCHAR(100),
    carrier_naic     VARCHAR(10),
    loss_date        DATE,
    claim_type       VARCHAR(30),
    claim_status     VARCHAR(20),
    claimant_name    VARCHAR(100),
    claimant_role    VARCHAR(20),
    match_type       VARCHAR(30),
    match_confidence DECIMAL(5,2),
    linked_to_claim  BOOLEAN DEFAULT FALSE,
    reviewed         BOOLEAN DEFAULT FALSE,
    reviewed_by      VARCHAR(50),
    review_date      TIMESTAMP,
    created_at       TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

---

## 16. NICB Integration

### 16.1 NICB Services

| Service | Description | Use Case |
|---------|-------------|----------|
| **VINCheck** | Free public VIN status lookup | Theft, salvage, flood check |
| **ETrack** | ISO ClaimSearch reports to NICB | Cross-carrier claim patterns |
| **Questionable Claims** | Referral program for suspicious claims | SIU investigation support |
| **Analytics** | Fraud pattern analysis and intelligence | Strategic fraud detection |
| **Training** | Fraud detection training programs | SIU staff development |
| **Law Enforcement** | LE coordination and support | Criminal prosecution support |

### 16.2 NICB Referral Process

```
NICB REFERRAL WORKFLOW:

  1. SIU identifies potential fraud ring or organized scheme
  2. Prepare NICB referral package:
     - Claim summaries
     - Investigation findings
     - Network diagrams
     - Evidence summaries
  3. Submit via NICB online portal
  4. NICB assigns analyst
  5. NICB cross-references with other carrier submissions
  6. NICB provides additional intelligence:
     - Other carriers with related claims
     - Known fraud ring associations
     - Law enforcement contacts
  7. Coordinated investigation if multi-carrier
  8. NICB supports law enforcement prosecution
```

---

## 17. Fraud Referral Workflow & Data Model

### 17.1 Referral Data Model

```sql
CREATE TABLE fraud_referral (
    referral_id         UUID PRIMARY KEY,
    claim_id            VARCHAR(20) NOT NULL,
    claim_number        VARCHAR(30) NOT NULL,
    referral_source     VARCHAR(50) NOT NULL,
    referral_type       VARCHAR(30) NOT NULL,
    referral_date       TIMESTAMP NOT NULL,
    referral_reason     TEXT NOT NULL,
    fraud_score         DECIMAL(5,2),
    fraud_score_version VARCHAR(20),
    priority            VARCHAR(10) NOT NULL,
    status              VARCHAR(20) NOT NULL DEFAULT 'NEW',
    assigned_to         VARCHAR(50),
    assigned_date       TIMESTAMP,
    triage_date         TIMESTAMP,
    triage_result       VARCHAR(20),
    triage_notes        TEXT,
    estimated_exposure  DECIMAL(12,2),
    fraud_type          VARCHAR(50),
    lob                 VARCHAR(20) NOT NULL,
    loss_state          VARCHAR(2),
    created_at          TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at          TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE fraud_referral_indicator (
    indicator_id        UUID PRIMARY KEY,
    referral_id         UUID REFERENCES fraud_referral(referral_id),
    indicator_code      VARCHAR(50) NOT NULL,
    indicator_name      VARCHAR(200) NOT NULL,
    indicator_source    VARCHAR(50) NOT NULL,
    indicator_weight    DECIMAL(5,2),
    indicator_details   JSONB,
    created_at          TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE fraud_investigation (
    investigation_id    UUID PRIMARY KEY,
    referral_id         UUID REFERENCES fraud_referral(referral_id),
    investigation_type  VARCHAR(30) NOT NULL,
    status              VARCHAR(20) NOT NULL DEFAULT 'OPEN',
    lead_investigator   VARCHAR(50) NOT NULL,
    open_date           TIMESTAMP NOT NULL,
    target_close_date   TIMESTAMP,
    actual_close_date   TIMESTAMP,
    determination       VARCHAR(30),
    determination_date  TIMESTAMP,
    determination_notes TEXT,
    total_exposure      DECIMAL(12,2),
    total_savings       DECIMAL(12,2),
    law_enforcement_ref BOOLEAN DEFAULT FALSE,
    state_bureau_filed  BOOLEAN DEFAULT FALSE,
    nicb_referred       BOOLEAN DEFAULT FALSE,
    created_at          TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at          TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE investigation_activity (
    activity_id         UUID PRIMARY KEY,
    investigation_id    UUID REFERENCES fraud_investigation(investigation_id),
    activity_type       VARCHAR(50) NOT NULL,
    activity_date       TIMESTAMP NOT NULL,
    performed_by        VARCHAR(50) NOT NULL,
    description         TEXT NOT NULL,
    duration_hours      DECIMAL(5,2),
    cost                DECIMAL(10,2),
    result              VARCHAR(200),
    documents_attached  INTEGER DEFAULT 0,
    created_at          TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### 17.2 Referral Workflow State Machine

```
                    ┌───────────┐
                    │    NEW    │
                    └─────┬─────┘
                          │ receive_referral
                          ▼
                    ┌───────────┐
              ┌─────│  TRIAGE   │─────┐
              │     └─────┬─────┘     │
              │           │           │
          accepted    returned    closed
              │           │           │
              ▼           ▼           ▼
        ┌───────────┐ ┌────────┐ ┌──────────┐
        │ ASSIGNED  │ │RETURNED│ │ CLOSED   │
        └─────┬─────┘ │TO ADJ  │ │ NO_FRAUD │
              │       └────────┘ └──────────┘
              │ begin_investigation
              ▼
        ┌───────────┐
        │ INVESTI-  │
        │ GATING    │──── surveillance
        │           │──── statements
        │           │──── database_research
        └─────┬─────┘──── forensics
              │
              │ complete_investigation
              ▼
        ┌───────────┐
        │ REVIEW    │
        └─────┬─────┘
              │
     ┌────────┼────────┐
     │        │        │
  confirmed  suspicious  cleared
     │        │        │
     ▼        ▼        ▼
┌─────────┐ ┌──────┐ ┌──────────┐
│ FRAUD   │ │WATCH │ │ CLEARED  │
│CONFIRMED│ │ LIST │ │          │
└────┬────┘ └──────┘ └──────────┘
     │
     │ execute_resolution
     ▼
┌─────────┐
│RESOLVED │
│ - Denied│
│ - Pros. │
│ - Civil │
└─────────┘
```

---

## 18. Investigation Case Management

### 18.1 System Requirements

| Requirement | Description | Priority |
|------------|-------------|----------|
| Case creation | Auto-create from referral, manual create | Must Have |
| Case assignment | Auto-assign by geography/specialty/caseload | Must Have |
| Activity logging | Track all investigation activities with timestamps | Must Have |
| Document management | Attach and organize evidence documents | Must Have |
| Recorded statement | Schedule, record, transcribe statements | Must Have |
| Surveillance mgmt | Request, track, review surveillance results | Must Have |
| Timeline view | Visual timeline of claim and investigation events | Should Have |
| Network visualization | Display entity relationships graphically | Should Have |
| Collaboration | Multi-investigator case sharing | Must Have |
| Workflow automation | Auto-diary, auto-correspondence, auto-escalation | Must Have |
| Reporting | Standard and ad-hoc investigation reports | Must Have |
| Integration | Connect to claims system, ISO, NICB, external data | Must Have |
| Mobile access | Field investigators access on mobile devices | Should Have |
| Analytics | Investigation metrics, productivity, outcomes | Must Have |
| Compliance | Audit trail, regulatory reporting, data retention | Must Have |

---

## 19. Evidence Management

### 19.1 Evidence Chain of Custody Data Model

```sql
CREATE TABLE evidence_item (
    evidence_id         UUID PRIMARY KEY,
    investigation_id    UUID REFERENCES fraud_investigation(investigation_id),
    evidence_type       VARCHAR(50) NOT NULL,
    evidence_description TEXT NOT NULL,
    source              VARCHAR(200) NOT NULL,
    collected_by        VARCHAR(50) NOT NULL,
    collected_date      TIMESTAMP NOT NULL,
    collected_location  VARCHAR(200),
    storage_location    VARCHAR(200) NOT NULL,
    digital_file_path   VARCHAR(500),
    file_hash_sha256    VARCHAR(64),
    is_original         BOOLEAN DEFAULT TRUE,
    is_digital          BOOLEAN DEFAULT TRUE,
    retention_date      DATE NOT NULL,
    status              VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
    created_at          TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE evidence_chain_of_custody (
    custody_id          UUID PRIMARY KEY,
    evidence_id         UUID REFERENCES evidence_item(evidence_id),
    action              VARCHAR(50) NOT NULL,
    from_person         VARCHAR(50),
    to_person           VARCHAR(50) NOT NULL,
    action_date         TIMESTAMP NOT NULL,
    action_location     VARCHAR(200),
    purpose             VARCHAR(200) NOT NULL,
    notes               TEXT,
    witnessed_by        VARCHAR(50),
    created_at          TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Evidence types
-- PHOTO, VIDEO, DOCUMENT, RECORDED_STATEMENT, SURVEILLANCE_VIDEO,
-- FORENSIC_REPORT, FINANCIAL_RECORD, MEDICAL_RECORD, POLICE_REPORT,
-- WITNESS_STATEMENT, DIGITAL_EVIDENCE, PHYSICAL_EVIDENCE

-- Chain of custody actions
-- COLLECTED, TRANSFERRED, REVIEWED, COPIED, RETURNED, 
-- SENT_TO_LAB, RECEIVED_FROM_LAB, ARCHIVED, DESTROYED
```

---

## 20. SIU Reporting & Regulatory Requirements

### 20.1 State Fraud Bureau Reporting

```
STATE FRAUD BUREAU REPORTING REQUIREMENTS:

MANDATORY REPORTING STATES (as of 2024):
  Most states require insurers to report suspected fraud to state
  fraud bureau within specified timeframe.

TYPICAL FILING REQUIREMENTS:
  - Filing deadline: 30-60 days after detection of suspected fraud
  - Format: State-specific form or NAIC model form
  - Content required:
    ├─ Insured/claimant information
    ├─ Policy details
    ├─ Claim details
    ├─ Description of suspected fraud
    ├─ Type of fraud suspected
    ├─ Estimated dollar amount
    ├─ Summary of evidence
    ├─ Investigation status
    └─ Law enforcement referral status

ELECTRONIC FILING:
  Many states now accept electronic filing:
  - New York DFS: Online portal
  - California DOI: NAIC Fraud Reporting System
  - Florida DFS: Division of Investigative and Forensic Services portal
  - Texas DOI: Online Suspected Fraud Report
  
DATA MODEL FOR STATE REPORTING:
  report_id, filing_state, filing_date, claim_id, claim_number,
  policy_number, insured_name, claimant_name, loss_date,
  fraud_type_code, suspected_amount, investigation_summary,
  evidence_summary, referral_to_le (boolean), le_agency,
  le_case_number, reporter_name, reporter_title
```

---

## 21. Fraud Analytics Dashboard

### 21.1 Dashboard Design

```
┌─────────────────────────────────────────────────────────────────────┐
│                    FRAUD DETECTION DASHBOARD                         │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  ┌──────────────────┐  ┌──────────────────┐  ┌──────────────────┐  │
│  │ FRAUD REFERRALS  │  │ DETECTION RATE   │  │ SAVINGS (YTD)    │  │
│  │ (This Month)     │  │                  │  │                  │  │
│  │     247          │  │     28.5%        │  │   $12.3M         │  │
│  │   ▲ +12% MoM    │  │   ▲ +2.1% MoM   │  │   ▲ +$1.8M MoM  │  │
│  └──────────────────┘  └──────────────────┘  └──────────────────┘  │
│                                                                      │
│  ┌──────────────────┐  ┌──────────────────┐  ┌──────────────────┐  │
│  │ FALSE POS RATE   │  │ AVG INVEST TIME  │  │ OPEN CASES       │  │
│  │                  │  │                  │  │                  │  │
│  │     18.2%        │  │     42 days      │  │     156          │  │
│  │   ▼ -1.3% MoM   │  │   ▼ -3d MoM     │  │   ▲ +8 MoM      │  │
│  └──────────────────┘  └──────────────────┘  └──────────────────┘  │
│                                                                      │
│  ┌─────────────────────────────────────────────────────────────┐    │
│  │ REFERRALS BY SOURCE                                          │    │
│  │                                                               │    │
│  │ ML Model Auto     ████████████████████████████░░  68%        │    │
│  │ Adjuster Referral ████████░░░░░░░░░░░░░░░░░░░░░  18%        │    │
│  │ Rules Engine      ████░░░░░░░░░░░░░░░░░░░░░░░░░   8%        │    │
│  │ Tip Line          ██░░░░░░░░░░░░░░░░░░░░░░░░░░░   3%        │    │
│  │ NICB/ISO          █░░░░░░░░░░░░░░░░░░░░░░░░░░░░   2%        │    │
│  │ Other             █░░░░░░░░░░░░░░░░░░░░░░░░░░░░   1%        │    │
│  └─────────────────────────────────────────────────────────────┘    │
│                                                                      │
│  ┌──────────────────────────────┐ ┌────────────────────────────┐    │
│  │ FRAUD TYPE DISTRIBUTION      │ │ TOP FRAUD INDICATORS       │    │
│  │                              │ │                            │    │
│  │ Inflated Claims   32% ████▓ │ │ Coverage increase    22%   │    │
│  │ Staged Accident   18% ██▓   │ │ Prior claims pattern 18%   │    │
│  │ Phantom Injury    15% ██    │ │ Provider red flag    15%   │    │
│  │ Pre-existing Dmg  12% █▓    │ │ New policy + loss    12%   │    │
│  │ Provider Fraud    10% █▓    │ │ Inconsistent story   10%   │    │
│  │ Arson/Intentional  5% █     │ │ Geographic anomaly    8%   │    │
│  │ Other              8% █     │ │ Day/time pattern      7%   │    │
│  └──────────────────────────────┘ │ Other                8%   │    │
│                                    └────────────────────────────┘    │
│                                                                      │
│  ┌─────────────────────────────────────────────────────────────┐    │
│  │ INVESTIGATION OUTCOMES (LAST 12 MONTHS)                      │    │
│  │                                                               │    │
│  │ Fraud Confirmed     ████████████████░░░░░░░░░░░░  42%        │    │
│  │ Suspicious/Watch    ████████████░░░░░░░░░░░░░░░░  28%        │    │
│  │ Cleared             █████████░░░░░░░░░░░░░░░░░░░  22%        │    │
│  │ Inconclusive        ████░░░░░░░░░░░░░░░░░░░░░░░░   8%        │    │
│  └─────────────────────────────────────────────────────────────┘    │
│                                                                      │
└─────────────────────────────────────────────────────────────────────┘
```

---

## 22. False Positive Management

### 22.1 False Positive Reduction Strategy

```
FALSE POSITIVE MANAGEMENT FRAMEWORK:

  PROBLEM: High false positive rate → wasted investigator time,
           customer dissatisfaction, delayed claim payments

  TARGET: False positive rate < 15% at SIU referral threshold

  STRATEGIES:

  1. THRESHOLD OPTIMIZATION
     - Analyze precision-recall curve
     - Set threshold to maximize F1 at target FP rate
     - Different thresholds by LOB (auto vs property vs WC)
     
  2. TWO-STAGE SCORING
     Stage 1: Broad net (high recall, accept higher FP)
     Stage 2: Focused review (high precision, reduce FP)
     
     Stage 1: Score > 40 → Enhanced monitoring (20% of claims)
     Stage 2: Score > 40 AND investigation_value > $5K → SIU referral (5%)
     
  3. FEEDBACK LOOP
     ┌─────────────┐
     │ SIU reviews  │
     │ referral     │
     │              │
     │ Outcome:     │
     │ - Fraud      │
     │ - Not Fraud  │──────┐
     │ - Suspended  │      │
     └─────────────┘      │
                           ▼
     ┌──────────────────────────────┐
     │ Feed outcome back to model:  │
     │ - Retrain with updated labels│
     │ - Adjust feature weights     │
     │ - Update rule thresholds     │
     │ - Track FP by rule/feature   │
     └──────────────────────────────┘
     
  4. RULE PERFORMANCE MONITORING
     Track for each rule:
     - Hit rate (% of claims triggering)
     - True positive rate (confirmed fraud when triggered)
     - False positive rate (not fraud when triggered)
     - Disable rules with FP rate > 80%
     - Retune rules quarterly
```

---

## 23. Vendor Solutions

### 23.1 Fraud Detection Vendor Comparison

| Feature | Shift Technology | FRISS | SAS | BAE NetReveal |
|---------|-----------------|-------|-----|---------------|
| **ML Models** | Advanced (deep learning) | Good (ensemble) | Advanced | Advanced |
| **Rules Engine** | Integrated | Integrated | Integrated | Integrated |
| **SNA/Link Analysis** | Excellent | Good | Good | Excellent |
| **Real-Time Scoring** | Yes | Yes | Yes | Yes |
| **Claims Integration** | Multi-platform | Guidewire focus | Multi | Multi |
| **Deployment** | Cloud SaaS | Cloud/On-prem | Cloud/On-prem | On-prem/Cloud |
| **Insurance Focus** | Insurance-only | Insurance-only | Cross-industry | Cross-industry |
| **Claims Types** | All P&C | All P&C | All P&C | All P&C |
| **Implementation** | 3-6 months | 3-6 months | 6-12 months | 6-12 months |
| **Pricing Model** | Per-claim | Per-claim/license | License | License |

---

## 24. Cost-Benefit Analysis

### 24.1 Fraud Detection Program ROI

```
ROI MODEL: Fraud Detection Program

INVESTMENT (Annual):
  Technology platform               $1,200,000
  SIU staff (15 FTEs × $95K avg)   $1,425,000
  External services (surveillance,
    forensics, database access)      $  600,000
  Training and certification         $   75,000
  ──────────────────────────────────────────────
  TOTAL ANNUAL INVESTMENT            $3,300,000

BENEFITS (Annual):
  
  1. Claims Denied/Reduced (Fraud Confirmed)
     Referrals per year:                   3,000
     Confirmed fraud rate:                    42%
     Average fraud claim value:           $18,000
     Total fraud avoided = 3,000 × 0.42 × $18,000 = $22,680,000

  2. Deterrence Effect (estimated 10% of total fraud)
     Estimated total attempted fraud:     $50,000,000
     Deterrence factor:                          10%
     Deterrence benefit:                   $5,000,000

  3. Reduced Soft Fraud (Claims paid at reduced amount)
     Referrals with reduced payment:          900
     Average reduction:                    $3,500
     Total reduction = 900 × $3,500 =      $3,150,000

  ──────────────────────────────────────────────
  TOTAL ANNUAL BENEFIT                   $30,830,000

  NET BENEFIT = $30,830,000 - $3,300,000 = $27,530,000
  
  ROI = ($27,530,000 / $3,300,000) × 100 = 834%
  
  COST PER $1 OF FRAUD SAVED = $3,300,000 / $30,830,000 = $0.107
  (Every $1 invested returns $9.34 in fraud savings)
```

---

## 25. Privacy & Legal Considerations

### 25.1 Legal Framework for Fraud Investigation

| Area | Legal Basis | Considerations |
|------|-----------|----------------|
| **Recorded Statements** | Varies by state (one-party vs two-party consent) | Must disclose recording in two-party states |
| **Surveillance** | Generally legal in public spaces | Cannot trespass, use illegal devices, or harass |
| **Social Media** | Public profiles are fair game | Cannot create fake profiles or friend requests |
| **Background Checks** | FCRA governs; insurance exemption exists | Must have permissible purpose |
| **Medical Records** | HIPAA applies; authorization needed | Claim filing may constitute limited waiver |
| **Financial Records** | GLBA, state privacy laws | Generally need authorization or subpoena |
| **EUO (Exam Under Oath)** | Policy contract right | Must follow state-specific procedures |
| **Data Sharing** | ISO, NICB sharing authorized by policy | Must comply with state data sharing laws |
| **Denial of Claim** | State unfair claims practices acts | Must have reasonable basis, proper notice |
| **Prosecution Referral** | Qualified immunity in most states | Must have good faith basis |
| **State Fraud Reporting** | Mandatory in most states | Immunity for good faith reporting |

### 25.2 State-Specific Fraud Investigation Laws

```
KEY STATE VARIATIONS:

  CALIFORNIA:
    - Two-party consent for recordings
    - CDI Fraud Division reporting mandatory
    - Fraud reporting immunity (CIC §1874.8)
    - SIU must be certified (CIC §1875.24)
    
  NEW YORK:
    - One-party consent for recordings
    - DFS Fraud Bureau reporting mandatory
    - Fraud warning required on all claim forms
    - SIU annual report to DFS required
    
  FLORIDA:
    - Two-party consent for recordings
    - DFS Division of Investigative Services
    - Fraud reporting mandatory (FL Stat §626.989)
    - Insurer immunity for good faith reporting
    
  TEXAS:
    - One-party consent for recordings
    - TDI Fraud Unit reporting mandatory
    - Fraud statement required on applications/claims
    - Anti-fraud plan filing required
```

---

## 26. Sample Fraud Scoring Rules & Algorithms

### 26.1 Complete Scoring Algorithm

```
FUNCTION calculate_fraud_score(claim):

    score = 0
    flags = []

    // === POLICY-BASED RULES ===
    
    IF days_between(policy.inception, claim.dateOfLoss) < 30:
        score += 15; flags.add("NEW_POLICY_LOSS")
    ELIF days_between(policy.inception, claim.dateOfLoss) < 60:
        score += 8; flags.add("RECENT_POLICY_LOSS")

    IF policy.coverageIncreasedLast90Days:
        score += 20; flags.add("RECENT_COVERAGE_INCREASE")

    IF policy.premiumBalanceOverdue:
        score += 5; flags.add("PREMIUM_OVERDUE")

    IF policy.cancelPendingAtLoss:
        score += 15; flags.add("CANCEL_PENDING")

    // === CLAIM-BASED RULES ===
    
    IF claim.daysToReport > 30:
        score += 10; flags.add("LATE_REPORTING")
    ELIF claim.daysToReport > 14:
        score += 5; flags.add("DELAYED_REPORTING")

    IF claim.amount / policy.coverageLimit > 0.80:
        score += 8; flags.add("NEAR_LIMIT_CLAIM")

    IF claim.lob = 'AUTO' AND claim.amount / vehicle.acv > 0.75:
        score += 10; flags.add("HIGH_VALUE_RATIO")

    // === CLAIMANT-BASED RULES ===
    
    IF claimant.priorClaimsAllCarriers5Yr >= 5:
        score += 18; flags.add("FREQUENT_CLAIMANT")
    ELIF claimant.priorClaimsAllCarriers5Yr >= 3:
        score += 8; flags.add("MULTIPLE_PRIOR_CLAIMS")

    IF claimant.priorSIUReferral:
        score += 15; flags.add("PRIOR_SIU_HISTORY")

    IF claimant.financialStressIndicator:
        score += 8; flags.add("FINANCIAL_STRESS")

    IF claimant.addressMismatch:
        score += 5; flags.add("ADDRESS_MISMATCH")

    // === INVOLVEMENT RULES ===
    
    IF claim.attorneyAtFNOL:
        score += 10; flags.add("ATTORNEY_AT_FNOL")

    IF claim.providerOnWatchList:
        score += 18; flags.add("WATCH_LIST_PROVIDER")

    IF claim.allClaimantsShareProvider:
        score += 12; flags.add("SHARED_PROVIDER")

    IF claim.allClaimantsShareAttorney:
        score += 12; flags.add("SHARED_ATTORNEY")

    // === PATTERN RULES ===
    
    IF claim.lossOnWeekendNight AND claim.type IN ('THEFT', 'FIRE'):
        score += 5; flags.add("SUSPICIOUS_TIMING")

    IF claim.lob = 'WC' AND claim.mondayReport AND claim.fridayInjury:
        score += 10; flags.add("MONDAY_WC_PATTERN")

    IF claim.isoMatchCount > 3:
        score += 12; flags.add("MULTIPLE_ISO_MATCHES")

    // === ML MODEL SCORE ===
    
    ml_score = fraud_ml_model.predict(claim.features) * 100
    score += ml_score * 0.35  // ML contributes up to 35 points

    // === SNA SCORE ===
    
    IF sna_score(claim) > 0.7:
        score += 15; flags.add("NETWORK_SUSPICIOUS")
    ELIF sna_score(claim) > 0.4:
        score += 8; flags.add("NETWORK_ELEVATED")

    // === NLP SCORE ===
    
    IF nlp_fraud_score(claim.narrative) > 0.7:
        score += 10; flags.add("SUSPICIOUS_NARRATIVE")

    // Cap at 100
    score = MIN(score, 100)

    RETURN FraudScore(
        score=score,
        flags=flags,
        recommendation=get_recommendation(score),
        ml_component=ml_score,
        rule_component=score - (ml_score * 0.35)
    )

FUNCTION get_recommendation(score):
    IF score >= 76: RETURN "AUTO_SIU_REFERRAL"
    IF score >= 51: RETURN "ADJUSTER_ALERT_ENHANCED_REVIEW"
    IF score >= 26: RETURN "ENHANCED_MONITORING"
    RETURN "NORMAL_PROCESSING"
```

---

## 27. SIU Performance Metrics

### 27.1 KPI Dashboard

| KPI | Definition | Target | Benchmark |
|-----|-----------|--------|-----------|
| **Referral Volume** | Monthly SIU referrals received | Varies | 200–500/month |
| **Triage Turnaround** | Days from referral to triage decision | < 3 days | 2 days |
| **Investigation Cycle** | Days from assignment to determination | < 60 days | 45 days |
| **Confirmed Fraud Rate** | % referrals confirmed as fraud | > 35% | 40–50% |
| **False Positive Rate** | % referrals cleared (no fraud) | < 20% | 15–25% |
| **Savings per Investigation** | Avg claim savings per investigation | > $15K | $12K–$25K |
| **Total Savings (Annual)** | Total fraud savings from SIU | Varies | $10M–$50M |
| **ROI** | Return on SIU investment | > 5:1 | 6:1–10:1 |
| **Prosecution Rate** | % of confirmed fraud referred to LE | > 15% | 10–20% |
| **Conviction Rate** | % of prosecutions resulting in conviction | > 60% | 50–75% |
| **Caseload per Investigator** | Open cases per investigator | < 30 | 20–35 |
| **State Reporting Compliance** | % of required reports filed on time | 100% | 100% |
| **Detection Rate** | % of total fraud detected | > 25% | 20–35% |
| **Recovery Rate** | $ recovered from fraud perpetrators | > 10% | 5–15% |
| **Customer Impact** | Avg payment delay for non-fraud referrals | < 7 days | 5–10 days |

---

## 28. Real-Time Fraud Scoring Architecture

### 28.1 Architecture for FNOL-Time Scoring

```
┌─────────────────────────────────────────────────────────────────────┐
│              REAL-TIME FRAUD SCORING AT FNOL                         │
│                                                                      │
│  ┌──────────┐                                                       │
│  │ FNOL     │  New claim submitted via any channel                  │
│  │ Event    │                                                       │
│  └────┬─────┘                                                       │
│       │                                                              │
│       ▼                                                              │
│  ┌──────────────────────────────────────────────┐                   │
│  │ ENRICHMENT ORCHESTRATOR                       │                   │
│  │ (Parallel data gathering, < 5 seconds total)  │                   │
│  │                                                │                   │
│  │  ┌────────┐ ┌────────┐ ┌────────┐ ┌────────┐ │                   │
│  │  │ Policy │ │ ISO    │ │ NICB   │ │ Credit │ │                   │
│  │  │ Lookup │ │ Search │ │ VIN    │ │ /LexisN│ │                   │
│  │  └────────┘ └────────┘ └────────┘ └────────┘ │                   │
│  └──────────────────┬───────────────────────────┘                   │
│                     │                                                │
│                     ▼                                                │
│  ┌──────────────────────────────────────────────┐                   │
│  │ FEATURE ASSEMBLY                              │                   │
│  │ (Build feature vector from claim + enrichment)│                   │
│  │                                                │                   │
│  │ Online Feature Store (Redis) provides:         │                   │
│  │ - Policy-level features (pre-computed)         │                   │
│  │ - Claimant history features (pre-computed)     │                   │
│  │ - Geographic features (pre-computed)           │                   │
│  │                                                │                   │
│  │ Real-time computed:                            │                   │
│  │ - Claim-specific features                      │                   │
│  │ - ISO match features                           │                   │
│  │ - NLP narrative features                       │                   │
│  └──────────────────┬───────────────────────────┘                   │
│                     │                                                │
│                     ▼                                                │
│  ┌──────────────────────────────────────────────┐                   │
│  │ SCORING ENGINES (Parallel, < 200ms)           │                   │
│  │                                                │                   │
│  │  ┌──────────┐ ┌──────────┐ ┌──────────┐     │                   │
│  │  │ Rules    │ │ ML Model │ │ NLP      │     │                   │
│  │  │ Engine   │ │ (XGBoost)│ │ Scorer   │     │                   │
│  │  └──────────┘ └──────────┘ └──────────┘     │                   │
│  └──────────────────┬───────────────────────────┘                   │
│                     │                                                │
│                     ▼                                                │
│  ┌──────────────────────────────────────────────┐                   │
│  │ SCORE AGGREGATION & DECISIONING               │                   │
│  │                                                │                   │
│  │ composite_score → threshold → recommendation  │                   │
│  │                                                │                   │
│  │ OUTPUT:                                        │                   │
│  │ {                                              │                   │
│  │   "fraud_score": 72,                          │                   │
│  │   "risk_tier": "HIGH",                        │                   │
│  │   "recommendation": "SIU_REFERRAL",           │                   │
│  │   "top_indicators": [...],                    │                   │
│  │   "stp_eligible": false                       │                   │
│  │ }                                              │                   │
│  └──────────────────┬───────────────────────────┘                   │
│                     │                                                │
│         ┌───────────┼───────────┐                                   │
│         ▼           ▼           ▼                                   │
│  ┌──────────┐ ┌──────────┐ ┌──────────┐                           │
│  │ Claim    │ │ SIU      │ │ Kafka    │                           │
│  │ System   │ │ Referral │ │ Event    │                           │
│  │ (Store)  │ │ Queue    │ │ (Audit)  │                           │
│  └──────────┘ └──────────┘ └──────────┘                           │
│                                                                      │
│  TOTAL LATENCY: < 5 seconds (including external API calls)         │
│  THROUGHPUT: 500+ claims/minute                                     │
│                                                                      │
└─────────────────────────────────────────────────────────────────────┘
```

### 28.2 Asynchronous SNA Scoring

```
SNA scoring is typically asynchronous due to graph query complexity:

  FNOL Created Event
       │
       ▼
  [claims.fnol.created] → Kafka
       │
       ▼
  SNA Consumer Service
       │
       ├─ Build local subgraph around claim entities
       │   (claimant, vehicle, address, phone, providers)
       │
       ├─ Query Neo4j for connections
       │   - 1-hop: direct connections
       │   - 2-hop: connections of connections
       │   - 3-hop: extended network (for ring detection)
       │
       ├─ Calculate network metrics:
       │   - Degree centrality
       │   - Betweenness centrality
       │   - Clustering coefficient
       │   - Community membership
       │   - Shared entity count
       │
       ├─ Score network risk (0-100)
       │
       └─ Publish: [claims.fraud.sna_scored]
              │
              ▼
          Fraud Score Updater
              │
              └─ Update composite fraud score with SNA component
                 Typical latency: 10-30 seconds (acceptable for async)
```

---

## Appendix: Glossary

| Term | Definition |
|------|-----------|
| **SIU** | Special Investigations Unit |
| **NICB** | National Insurance Crime Bureau |
| **ISO ClaimSearch** | Insurance Services Office claims database |
| **SNA** | Social Network Analysis / Link Analysis |
| **EUO** | Examination Under Oath |
| **CFE** | Certified Fraud Examiner |
| **CIFI** | Certified Insurance Fraud Investigator |
| **NLP** | Natural Language Processing |
| **FP** | False Positive |
| **TP** | True Positive |
| **AUC-ROC** | Area Under the Receiver Operating Characteristic Curve |
| **PSI** | Population Stability Index |
| **OSINT** | Open Source Intelligence |
| **KDE** | Kernel Density Estimation |
| **LOF** | Local Outlier Factor |

---

*This document is part of the PnC Claims Encyclopedia. For related topics, see:*
- *Article 6: Claims Automation & Straight-Through Processing*
- *Article 7: AI/ML in Claims Processing*
- *Article 9: Subrogation & Recovery*
- *Article 10: Reserves & Financial Management*
