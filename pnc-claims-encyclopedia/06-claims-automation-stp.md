# Claims Automation & Straight-Through Processing (STP)

## A Comprehensive Architecture & Implementation Guide for P&C Insurance

---

## Table of Contents

1. [Introduction & Evolution of Claims Automation](#1-introduction--evolution-of-claims-automation)
2. [Claims Automation Maturity Model](#2-claims-automation-maturity-model)
3. [Straight-Through Processing (STP)](#3-straight-through-processing-stp)
4. [STP Decision Engine Architecture](#4-stp-decision-engine-architecture)
5. [Touchless Claims Processing End-to-End Flow](#5-touchless-claims-processing-end-to-end-flow)
6. [Business Rules Engine Design](#6-business-rules-engine-design)
7. [Workflow Automation & BPM Integration](#7-workflow-automation--bpm-integration)
8. [Robotic Process Automation (RPA) in Claims](#8-robotic-process-automation-rpa-in-claims)
9. [Intelligent Document Processing (IDP)](#9-intelligent-document-processing-idp)
10. [Auto-Adjudication Logic](#10-auto-adjudication-logic)
11. [Configurable Business Rules by LOB](#11-configurable-business-rules-by-lob)
12. [Decision Tables & Decision Trees](#12-decision-tables--decision-trees)
13. [Automated Reserve Setting](#13-automated-reserve-setting)
14. [Automated Payment Processing](#14-automated-payment-processing)
15. [Task Automation](#15-task-automation)
16. [Integration Automation](#16-integration-automation)
17. [Automation Metrics & KPIs](#17-automation-metrics--kpis)
18. [Technology Stack for Claims Automation](#18-technology-stack-for-claims-automation)
19. [Microservices Architecture](#19-microservices-architecture)
20. [Event-Driven Automation with Kafka](#20-event-driven-automation-with-kafka)
21. [Sample Automation Rules in Pseudocode](#21-sample-automation-rules-in-pseudocode)
22. [ROI Calculation Models](#22-roi-calculation-models)
23. [Change Management](#23-change-management)
24. [Automation Decision Matrix](#24-automation-decision-matrix)

---

## 1. Introduction & Evolution of Claims Automation

### 1.1 What Is Claims Automation?

Claims automation is the application of technology—rules engines, workflow orchestration, machine learning, robotic process automation, and event-driven architectures—to reduce or eliminate human intervention in the claims lifecycle. The goal is to increase speed, reduce cost, improve accuracy, and deliver a superior policyholder experience while maintaining regulatory compliance and appropriate claim-handling standards.

### 1.2 Historical Evolution

| Era | Period | Characteristics | Key Technologies |
|-----|--------|----------------|-----------------|
| **Paper-Based** | Pre-1980 | Physical files, manual calculation, postal mail | Typewriters, filing cabinets |
| **Mainframe** | 1980–1995 | Batch processing, coded transactions, green-screen | COBOL, DB2, IMS |
| **Client-Server** | 1995–2005 | GUI-based claim systems, relational databases | Visual Basic, Oracle, PowerBuilder |
| **Web-Based** | 2005–2015 | Browser-based portals, SOA, early rules engines | Java/J2EE, .NET, BPEL |
| **Digital** | 2015–2020 | Mobile FNOL, API-first, cloud migration | REST APIs, Cloud, Microservices |
| **Intelligent** | 2020–Present | AI/ML, touchless processing, real-time decisioning | Deep Learning, NLP, Computer Vision |

### 1.3 Drivers of Claims Automation

```
+---------------------+      +---------------------+      +---------------------+
|   CUSTOMER DEMAND   |      |   COST PRESSURE     |      |   COMPETITIVE       |
|                     |      |                     |      |   LANDSCAPE         |
| - Instant response  |      | - Rising LAE        |      | - InsurTech entry   |
| - Self-service      |      | - Combined ratio    |      | - Customer churn    |
| - Real-time updates |      |   pressure          |      | - Market speed      |
| - Digital-first     |      | - Adjuster shortage |      | - Product parity    |
+---------------------+      +---------------------+      +---------------------+
           |                           |                           |
           v                           v                           v
     +----------------------------------------------------------+
     |            CLAIMS AUTOMATION IMPERATIVE                    |
     +----------------------------------------------------------+
           |                           |                           |
           v                           v                           v
+---------------------+      +---------------------+      +---------------------+
|   TECHNOLOGY        |      |   REGULATORY        |      |   DATA AVAILABILITY |
|   ENABLEMENT        |      |   ENVIRONMENT       |      |                     |
| - Cloud computing   |      | - Fair claims acts  |      | - IoT/telematics    |
| - AI/ML maturity    |      | - Speed mandates    |      | - Digital photos    |
| - API ecosystems    |      | - Transparency req  |      | - Third-party data  |
| - Low-code/no-code  |      | - Anti-fraud laws   |      | - Historical claims |
+---------------------+      +---------------------+      +---------------------+
```

### 1.4 The Business Case

The financial impact of claims automation is substantial:

| Metric | Before Automation | After Automation | Improvement |
|--------|------------------|-----------------|-------------|
| Average cycle time (auto physical damage) | 14 days | 3 days | 78% reduction |
| Cost per claim (auto PD) | $350 | $120 | 66% reduction |
| Adjuster caseload | 150 claims | 250 claims | 67% increase |
| Customer satisfaction (NPS) | +15 | +55 | 267% improvement |
| Leakage rate | 8–12% | 2–4% | 67% reduction |
| Fraud detection rate | 40% | 75% | 88% improvement |
| Touchless processing rate | 0% | 35–60% | New capability |

---

## 2. Claims Automation Maturity Model

### 2.1 The Five Stages of Maturity

```
Level 5: INTELLIGENT AUTOMATION
  ┌──────────────────────────────────────────────────────────────────┐
  │ AI-driven decisions, predictive intervention, self-optimizing   │
  │ Continuous learning, autonomous exception handling               │
  │ Target: 70-90% touchless rate                                   │
  └──────────────────────────────────────────────────────────────────┘
                              ▲
Level 4: FULLY AUTOMATED      │
  ┌──────────────────────────────────────────────────────────────────┐
  │ STP for eligible claims, auto-adjudication, auto-payment        │
  │ Human reviews exceptions only, real-time processing             │
  │ Target: 40-70% touchless rate                                   │
  └──────────────────────────────────────────────────────────────────┘
                              ▲
Level 3: SEMI-AUTOMATED       │
  ┌──────────────────────────────────────────────────────────────────┐
  │ Rules-driven routing, automated reserve setting, auto-diaries   │
  │ Workflow-driven tasks, digital document intake                  │
  │ Target: 15-40% touchless rate                                   │
  └──────────────────────────────────────────────────────────────────┘
                              ▲
Level 2: ASSISTED              │
  ┌──────────────────────────────────────────────────────────────────┐
  │ System prompts and checklists, basic workflow routing            │
  │ Template-based correspondence, adjuster decision support         │
  │ Target: 5-15% touchless rate                                    │
  └──────────────────────────────────────────────────────────────────┘
                              ▲
Level 1: MANUAL                │
  ┌──────────────────────────────────────────────────────────────────┐
  │ Paper-based or minimal system support, full manual processing   │
  │ Adjuster handles all decisions, manual diary management          │
  │ Target: 0% touchless rate                                       │
  └──────────────────────────────────────────────────────────────────┘
```

### 2.2 Maturity Assessment Dimensions

Each stage should be evaluated across 12 dimensions:

| Dimension | Level 1 | Level 2 | Level 3 | Level 4 | Level 5 |
|-----------|---------|---------|---------|---------|---------|
| **FNOL Intake** | Phone/paper | Web form | Multi-channel + OCR | Conversational AI | Proactive FNOL (IoT) |
| **Claim Triage** | Manual assignment | Basic rules | ML-based scoring | Real-time routing | Predictive intervention |
| **Coverage Verification** | Manual lookup | System prompts | Auto-verification | Real-time decisioning | Predictive coverage gap |
| **Investigation** | Fully manual | Checklist-driven | Automated data gather | AI-assisted analysis | Autonomous investigation |
| **Documentation** | Physical files | Scanned documents | IDP extraction | Auto-classification | Knowledge graph |
| **Reserve Setting** | Manual estimate | Tabular guides | Algorithm-based | ML-predicted | Dynamic re-estimation |
| **Liability** | Adjuster judgment | Decision support | Rules-based partial | Auto-determination | AI liability scoring |
| **Damage Estimation** | Manual inspection | Photo-assisted | AI photo estimate | Auto-estimate + verify | Real-time IoT + AI |
| **Payment** | Manual check | Auto-check print | EFT with rules | Real-time payment | Predictive payment |
| **Fraud Detection** | SIU referral only | Red flag alerts | Scoring at triage | Real-time ML scoring | Network analysis + AI |
| **Communication** | Manual letters | Templates | Auto-correspondence | Conversational AI | Proactive outreach |
| **Reporting** | Manual reports | Scheduled reports | Dashboards | Real-time analytics | Predictive insights |

### 2.3 Maturity Assessment Scoring Model

```
ASSESSMENT_SCORE = SUM(dimension_score[i] * weight[i]) for i in 1..12

Dimension Weights:
  FNOL Intake:           0.10
  Claim Triage:          0.10
  Coverage Verification: 0.08
  Investigation:         0.10
  Documentation:         0.06
  Reserve Setting:       0.10
  Liability:             0.08
  Damage Estimation:     0.10
  Payment:               0.08
  Fraud Detection:       0.08
  Communication:         0.06
  Reporting:             0.06

Maturity Level Ranges:
  Level 1: 1.0 – 1.4
  Level 2: 1.5 – 2.4
  Level 3: 2.5 – 3.4
  Level 4: 3.5 – 4.4
  Level 5: 4.5 – 5.0
```

---

## 3. Straight-Through Processing (STP)

### 3.1 STP Definition

Straight-Through Processing (STP) in claims is the ability to receive, evaluate, adjudicate, and pay a claim from FNOL to settlement without any human intervention. The claim flows entirely through automated decision points, with every step—coverage verification, liability determination, damage assessment, reserve setting, payment calculation, and disbursement—handled programmatically.

### 3.2 STP Eligibility Criteria

Not all claims are eligible for STP. The following criteria define the boundary:

```
STP_ELIGIBLE = TRUE when ALL of the following are met:

  1. CLAIM_TYPE in (AUTO_GLASS, AUTO_TOW, AUTO_RENTAL, SIMPLE_AUTO_PD,
                    SIMPLE_PROPERTY, SIMPLE_WC_MEDICAL_ONLY)
  2. POLICY_STATUS = 'ACTIVE' at DATE_OF_LOSS
  3. PREMIUM_STATUS = 'CURRENT' (no outstanding balance > threshold)
  4. COVERAGE_VERIFIED = TRUE (applicable coverage exists)
  5. FRAUD_SCORE < FRAUD_THRESHOLD (typically < 30 on 0-100 scale)
  6. CLAIMED_AMOUNT < STP_AMOUNT_THRESHOLD (varies by LOB)
  7. CLAIMANT_COUNT <= MAX_CLAIMANT_THRESHOLD (typically 1-2)
  8. NO_BODILY_INJURY or INJURY_SEVERITY = 'MINOR_MEDICAL_ONLY'
  9. LIABILITY_CLEAR = TRUE (single vehicle or clear fault)
  10. NO_PRIOR_CLAIMS_CONFLICT (no overlapping open claims)
  11. NO_LITIGATION_INDICATOR
  12. NO_REGULATORY_HOLD
  13. DOCUMENT_COMPLETENESS_SCORE >= MIN_THRESHOLD
  14. CLAIMANT_IDENTITY_VERIFIED = TRUE
```

### 3.3 STP Amount Thresholds by LOB

| Line of Business | Coverage | STP Threshold | Typical Range |
|-----------------|----------|---------------|---------------|
| Personal Auto | Comprehensive – Glass | $2,500 | $500–$3,000 |
| Personal Auto | Comprehensive – Non-Glass | $5,000 | $2,000–$7,500 |
| Personal Auto | Collision | $5,000 | $3,000–$10,000 |
| Personal Auto | Towing/Roadside | $500 | $200–$500 |
| Personal Auto | Rental Reimbursement | $1,500 | $500–$2,000 |
| Personal Auto | Medical Payments | $2,000 | $1,000–$5,000 |
| Commercial Auto | Physical Damage | $7,500 | $5,000–$15,000 |
| Homeowners | Property Damage | $10,000 | $5,000–$25,000 |
| Homeowners | Personal Property | $5,000 | $2,000–$10,000 |
| Workers Comp | Medical Only | $5,000 | $2,000–$10,000 |
| Commercial Property | Building Damage | $15,000 | $10,000–$50,000 |
| General Liability | BI – Minor | N/A (not STP) | Not eligible |

### 3.4 STP Claim Types — Detailed Eligibility

#### Auto Glass Claims

```
ELIGIBLE_FOR_STP(glass_claim):
  REQUIRE policy.status = 'ACTIVE'
  REQUIRE policy.comprehensive_coverage EXISTS
  REQUIRE policy.comprehensive_deductible <= claimed_amount
  REQUIRE glass_vendor IN approved_vendor_list
  REQUIRE glass_type IN ('WINDSHIELD', 'SIDE_WINDOW', 'REAR_WINDOW')
  REQUIRE repair_or_replace IN ('REPAIR', 'REPLACE')
  REQUIRE claimed_amount <= glass_stp_threshold
  REQUIRE fraud_score < 25
  REQUIRE no_prior_glass_claims_in_period(policy, 180_DAYS) OR
          prior_glass_claims_count(policy, 365_DAYS) < 3
  RETURN TRUE
```

#### Towing & Roadside Claims

```
ELIGIBLE_FOR_STP(tow_claim):
  REQUIRE policy.status = 'ACTIVE'
  REQUIRE policy.towing_coverage EXISTS
  REQUIRE tow_vendor IN approved_vendor_list
  REQUIRE tow_distance <= policy.towing_max_distance
  REQUIRE claimed_amount <= policy.towing_max_amount
  REQUIRE service_type IN ('TOW', 'JUMPSTART', 'LOCKOUT', 'FLAT_TIRE', 'FUEL_DELIVERY')
  REQUIRE fraud_score < 20
  RETURN TRUE
```

#### Rental Reimbursement Claims

```
ELIGIBLE_FOR_STP(rental_claim):
  REQUIRE policy.status = 'ACTIVE'
  REQUIRE policy.rental_coverage EXISTS
  REQUIRE rental_vendor IN approved_vendor_list
  REQUIRE daily_rate <= policy.rental_daily_max
  REQUIRE total_days <= policy.rental_max_days
  REQUIRE claimed_amount <= policy.rental_max_amount
  REQUIRE associated_claim EXISTS AND associated_claim.status = 'OPEN'
  REQUIRE fraud_score < 25
  RETURN TRUE
```

---

## 4. STP Decision Engine Architecture

### 4.1 High-Level Architecture

```
                         ┌─────────────────────┐
                         │    FNOL INTAKE       │
                         │  (Multi-Channel)     │
                         └──────────┬──────────┘
                                    │
                                    ▼
                         ┌─────────────────────┐
                         │   CLAIM CREATION     │
                         │   & ENRICHMENT       │
                         │  (Data Augmentation) │
                         └──────────┬──────────┘
                                    │
                         ┌──────────▼──────────┐
                         │  STP ELIGIBILITY     │
                         │  GATEWAY             │
                         │                      │
                         │  ┌────────────────┐  │
                         │  │ Eligibility    │  │
                         │  │ Rules Engine   │  │
                         │  └────────────────┘  │
                         └──────────┬──────────┘
                                    │
                          ┌─────────┴─────────┐
                          │                   │
                     STP_ELIGIBLE        NOT_ELIGIBLE
                          │                   │
                          ▼                   ▼
               ┌────────────────┐   ┌────────────────┐
               │  STP PIPELINE  │   │  MANUAL QUEUE  │
               └───────┬────────┘   │  (Traditional  │
                       │            │   Processing)  │
                       ▼            └────────────────┘
              ┌─────────────────┐
              │ COVERAGE        │
              │ VERIFICATION    │
              │ ENGINE          │
              └────────┬────────┘
                       │
                       ▼
              ┌─────────────────┐
              │ LIABILITY       │
              │ DETERMINATION   │
              │ ENGINE          │
              └────────┬────────┘
                       │
                       ▼
              ┌─────────────────┐
              │ DAMAGE/LOSS     │
              │ ASSESSMENT      │
              │ ENGINE          │
              └────────┬────────┘
                       │
                       ▼
              ┌─────────────────┐
              │ FRAUD           │
              │ SCORING         │
              │ ENGINE          │
              └────────┬────────┘
                       │
                       ▼
              ┌─────────────────┐
              │ RESERVE         │
              │ CALCULATION     │
              │ ENGINE          │
              └────────┬────────┘
                       │
                       ▼
              ┌─────────────────┐
              │ PAYMENT         │
              │ DETERMINATION   │
              │ ENGINE          │
              └────────┬────────┘
                       │
                       ▼
              ┌─────────────────┐
              │ PAYMENT         │
              │ DISBURSEMENT    │
              └────────┬────────┘
                       │
                       ▼
              ┌─────────────────┐
              │ NOTIFICATION    │
              │ & CLOSURE       │
              └─────────────────┘
```

### 4.2 Rule Categories in the STP Decision Engine

#### 4.2.1 Eligibility Rules

These determine whether a claim enters the STP pipeline at all.

| Rule ID | Rule Name | Description | Priority |
|---------|-----------|-------------|----------|
| ELIG-001 | Policy Active Check | Policy must be in active status at DOL | 1 |
| ELIG-002 | Premium Current Check | No outstanding premium > grace period | 2 |
| ELIG-003 | Claim Type STP Check | Claim type must be in STP-eligible list | 3 |
| ELIG-004 | Amount Threshold Check | Claimed amount < LOB-specific threshold | 4 |
| ELIG-005 | Claimant Count Check | Number of claimants <= max threshold | 5 |
| ELIG-006 | Injury Severity Check | No BI or medical-only minor injuries | 6 |
| ELIG-007 | Prior Claims Check | No conflicting or suspicious prior claims | 7 |
| ELIG-008 | Litigation Check | No litigation indicators present | 8 |
| ELIG-009 | Regulatory Hold Check | No state-specific regulatory holds | 9 |
| ELIG-010 | Document Completeness | Required documents present | 10 |

#### 4.2.2 Coverage Rules

```
COVERAGE_RULES:
  COV-001: Verify policy effective date brackets the date of loss
  COV-002: Verify specific coverage for loss type exists on policy
  COV-003: Calculate applicable deductible amount
  COV-004: Check coverage limits against claimed amount
  COV-005: Verify named insured or permissive user
  COV-006: Check for coverage exclusions applicable to this loss
  COV-007: Verify no lapse in coverage at time of loss
  COV-008: Check for endorsement modifications to standard coverage
  COV-009: Verify vehicle/property scheduled on policy
  COV-010: Check territory restrictions
  COV-011: Verify driver listed or meets unlisted driver criteria
  COV-012: Check for applicable waiting periods (e.g., WC)
  COV-013: Verify loss location within covered territory
  COV-014: Check for applicable sublimits
  COV-015: Verify coordination of benefits if applicable
```

#### 4.2.3 Liability Rules

```
LIABILITY_RULES:
  LIAB-001: Single-vehicle accident = insured at fault (100%)
  LIAB-002: Rear-end collision = following vehicle at fault (unless exceptions)
  LIAB-003: Left-turn collision = turning vehicle at fault
  LIAB-004: Parked vehicle hit = moving vehicle at fault (100%)
  LIAB-005: Fixed object collision = insured at fault (100%)
  LIAB-006: Animal collision = no-fault (comp coverage applies)
  LIAB-007: Vandalism = no-fault (comp coverage applies)
  LIAB-008: Weather damage = no-fault (comp coverage applies)
  LIAB-009: Theft = no-fault (comp coverage applies)
  LIAB-010: Multi-vehicle with police report = use fault code
  LIAB-011: Clear red-light violation = violator at fault
  LIAB-012: Backing vehicle = backing vehicle at fault
  LIAB-013: Comparative negligence state rules
  LIAB-014: Contributory negligence state rules
  LIAB-015: No-fault PIP state rules
```

#### 4.2.4 Damage Rules

```
DAMAGE_RULES:
  DMG-001: Glass repair estimate within vendor schedule = accept
  DMG-002: Glass replacement estimate within market rate +/- 10% = accept
  DMG-003: Tow charge within standard rate per mile = accept
  DMG-004: Rental daily rate within policy limit = accept
  DMG-005: Photo estimate from AI model with confidence > 85% = accept
  DMG-006: Vendor estimate within +/- 15% of AI estimate = accept
  DMG-007: Repair estimate below total loss threshold = proceed
  DMG-008: OEM vs aftermarket parts rules by state
  DMG-009: Labor rate within prevailing market rate
  DMG-010: Supplement request rules and thresholds
```

#### 4.2.5 Payment Rules

```
PAYMENT_RULES:
  PAY-001: Net payment = approved_amount - deductible
  PAY-002: Payment cannot exceed coverage limit
  PAY-003: Payment cannot exceed remaining aggregate limit
  PAY-004: Lienholder included on payment if applicable
  PAY-005: Vendor direct pay if approved vendor program
  PAY-006: Deductible waiver applies if state-mandated (e.g., glass)
  PAY-007: Coordination of benefits adjustment
  PAY-008: Prior payment offset for supplemental payments
  PAY-009: Depreciation applied per policy terms (ACV vs RC)
  PAY-010: Tax included per state requirements
  PAY-011: Payment method based on amount (EFT < $10K, check > $10K)
  PAY-012: Multi-payee rules (named insured + lienholder)
```

#### 4.2.6 Fraud Rules

```
FRAUD_RULES:
  FRD-001: Claim filed within 30 days of policy inception
  FRD-002: Policy limit increase within 60 days before loss
  FRD-003: Multiple claims in 12-month period (>= 3)
  FRD-004: Loss reported on Friday/Monday (day-of-week pattern)
  FRD-005: Claimant address mismatch with policy address
  FRD-006: Prior claim with same claimant at different carrier
  FRD-007: Vehicle VIN mismatch or alteration
  FRD-008: Damage inconsistent with reported loss description
  FRD-009: Delayed reporting beyond normal threshold
  FRD-010: High-value claim on low-value vehicle
  FRD-011: Provider on fraud watch list
  FRD-012: Suspicious phone/email patterns
  FRD-013: Geographic anomaly (loss far from insured area)
  FRD-014: Repeat vendor across multiple claims
  FRD-015: Composite fraud score exceeds threshold
```

### 4.3 Decision Engine Data Model

```
TABLE: stp_decision_log
  decision_id          UUID PRIMARY KEY
  claim_id             VARCHAR(20) NOT NULL
  claim_number         VARCHAR(30) NOT NULL
  decision_timestamp   TIMESTAMP NOT NULL
  decision_type        VARCHAR(50) NOT NULL  -- 'STP_ELIGIBILITY', 'COVERAGE', 'LIABILITY', etc.
  decision_result      VARCHAR(20) NOT NULL  -- 'APPROVED', 'DECLINED', 'REFERRED'
  rule_set_version     VARCHAR(20) NOT NULL
  rules_evaluated      INTEGER NOT NULL
  rules_passed         INTEGER NOT NULL
  rules_failed         INTEGER NOT NULL
  rules_skipped        INTEGER NOT NULL
  confidence_score     DECIMAL(5,2)
  processing_time_ms   INTEGER NOT NULL
  fallout_reason       VARCHAR(500)
  fallout_rule_id      VARCHAR(50)
  override_flag        BOOLEAN DEFAULT FALSE
  override_user        VARCHAR(50)
  override_reason      VARCHAR(500)
  created_at           TIMESTAMP DEFAULT CURRENT_TIMESTAMP

INDEX: idx_stp_decision_claim ON stp_decision_log(claim_id)
INDEX: idx_stp_decision_type ON stp_decision_log(decision_type)
INDEX: idx_stp_decision_timestamp ON stp_decision_log(decision_timestamp)

TABLE: stp_rule_execution_detail
  execution_id         UUID PRIMARY KEY
  decision_id          UUID REFERENCES stp_decision_log(decision_id)
  rule_id              VARCHAR(50) NOT NULL
  rule_name            VARCHAR(200) NOT NULL
  rule_category        VARCHAR(50) NOT NULL
  rule_version         VARCHAR(20) NOT NULL
  execution_order      INTEGER NOT NULL
  input_data           JSONB
  evaluation_result    VARCHAR(20) NOT NULL  -- 'PASS', 'FAIL', 'SKIP', 'ERROR'
  output_data          JSONB
  execution_time_ms    INTEGER NOT NULL
  error_message        VARCHAR(500)
  created_at           TIMESTAMP DEFAULT CURRENT_TIMESTAMP

INDEX: idx_rule_exec_decision ON stp_rule_execution_detail(decision_id)
INDEX: idx_rule_exec_rule ON stp_rule_execution_detail(rule_id)
```

---

## 5. Touchless Claims Processing End-to-End Flow

### 5.1 Auto Glass Touchless Flow

```
STEP 1: FNOL INTAKE
  ├─ Customer calls, uses app, or website
  ├─ Chatbot/IVR gathers: policy number, DOL, vehicle, damage type
  ├─ System validates policyholder identity (KBA or app auth)
  └─ Claim record created with status = 'NEW'

STEP 2: POLICY VERIFICATION (automated, < 1 second)
  ├─ Query policy system via API
  ├─ Verify: active status, comprehensive coverage exists
  ├─ Determine deductible amount
  ├─ Check glass-specific endorsements
  └─ Result: COVERAGE_VERIFIED or COVERAGE_ISSUE

STEP 3: STP ELIGIBILITY CHECK (automated, < 1 second)
  ├─ Run eligibility rules engine
  ├─ Evaluate all ELIG rules (001-010)
  ├─ Check claim amount vs glass threshold
  ├─ Query fraud scoring service
  └─ Result: STP_ELIGIBLE or ROUTE_TO_ADJUSTER

STEP 4: VENDOR ASSIGNMENT (automated, < 2 seconds)
  ├─ Query approved glass vendor network
  ├─ Match by: geography, vehicle make/model, mobile capability
  ├─ Generate vendor assignment with authorization
  ├─ Send electronic dispatch to vendor
  └─ Notify customer of vendor and appointment options

STEP 5: REPAIR/REPLACEMENT COMPLETION
  ├─ Vendor performs service
  ├─ Vendor submits electronic invoice via vendor portal
  ├─ Invoice auto-validated against price schedules
  └─ Invoice data mapped to claim

STEP 6: PAYMENT PROCESSING (automated, < 5 seconds)
  ├─ Apply payment rules (PAY-001 through PAY-012)
  ├─ Calculate: vendor_invoice - deductible = payment_amount
  ├─ Check state-specific deductible waiver rules
  ├─ Generate payment authorization
  ├─ Initiate EFT to vendor
  └─ Record payment transaction

STEP 7: CLAIM CLOSURE (automated, < 2 seconds)
  ├─ Set final reserves = total paid
  ├─ Generate closing correspondence to customer
  ├─ Update claim status = 'CLOSED'
  ├─ Update loss history
  └─ Send satisfaction survey

TOTAL ELAPSED: 3-5 days (driven by physical repair time)
TOTAL HUMAN TOUCHES: 0
```

### 5.2 Touchless Processing Decision Points

At each step, a "circuit breaker" determines whether to continue STP or eject to manual handling:

```
CIRCUIT_BREAKER_EVALUATION:
  FOR EACH step IN stp_pipeline:
    result = execute_step(step, claim_data)
    
    IF result.status = 'ERROR':
      ROUTE_TO_MANUAL(claim, step, 'SYSTEM_ERROR')
      BREAK
      
    IF result.status = 'FAIL':
      IF step.fallback_available:
        result = execute_fallback(step, claim_data)
        IF result.status = 'FAIL':
          ROUTE_TO_MANUAL(claim, step, result.reason)
          BREAK
      ELSE:
        ROUTE_TO_MANUAL(claim, step, result.reason)
        BREAK
        
    IF result.confidence < step.min_confidence:
      ROUTE_TO_REVIEW(claim, step, result.confidence)
      BREAK
      
    LOG_DECISION(claim, step, result)
    CONTINUE_TO_NEXT_STEP
```

---

## 6. Business Rules Engine Design

### 6.1 Rules Engine Comparison

| Feature | Drools (Red Hat) | IBM ODM | FICO Blaze | Custom Engine |
|---------|-----------------|---------|------------|---------------|
| **Rule Language** | DRL / DMN | IRL / Decision Tables | SRL | Domain-specific |
| **Performance** | High (Rete algorithm) | High | High | Variable |
| **Decision Tables** | Yes (spreadsheet) | Yes | Yes | Custom |
| **Decision Trees** | Via DMN | Yes | Yes | Custom |
| **Versioning** | Git-based | Built-in | Built-in | Custom |
| **Business User UI** | Business Central | Decision Center | Decision Studio | Custom |
| **Cloud Native** | Kogito (cloud) | Cloud Pak | Blaze Cloud | Cloud ready |
| **Integration** | REST, Kafka, CDI | REST, MQ, SOAP | REST, JMS | Any |
| **Licensing** | Open source / RHPAM | Commercial | Commercial | None |
| **Learning Curve** | Medium | High | Medium | Low |
| **Scalability** | Horizontal | Horizontal | Horizontal | Design-dependent |
| **Claims Fit** | Excellent | Excellent | Good | Depends |

### 6.2 Drools-Based Architecture

```
┌─────────────────────────────────────────────────────────┐
│                 CLAIMS RULES PLATFORM                    │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  ┌─────────────────┐  ┌──────────────────────────────┐ │
│  │  Business        │  │  Rules Repository            │ │
│  │  Central UI      │  │  (Git-backed)                │ │
│  │  - Rule authoring│  │  - Versioned rule packages   │ │
│  │  - Test scenarios│  │  - Decision tables (.xlsx)   │ │
│  │  - Deployment    │  │  - DMN models (.dmn)         │ │
│  └────────┬────────┘  │  - DRL rules (.drl)          │ │
│           │           └──────────────┬───────────────┘ │
│           │                          │                  │
│           ▼                          ▼                  │
│  ┌─────────────────────────────────────────────────┐   │
│  │           KIE Server (Execution Engine)          │   │
│  │                                                   │   │
│  │  ┌─────────┐  ┌──────────┐  ┌────────────────┐  │   │
│  │  │ Rete    │  │ DMN      │  │ Rule           │  │   │
│  │  │ Engine  │  │ Engine   │  │ Audit Logger   │  │   │
│  │  └─────────┘  └──────────┘  └────────────────┘  │   │
│  │                                                   │   │
│  │  ┌────────────────────────────────────────────┐  │   │
│  │  │          REST API Layer                     │  │   │
│  │  │  POST /kie-server/services/rest/server/     │  │   │
│  │  │       containers/{id}/dmn                   │  │   │
│  │  └────────────────────────────────────────────┘  │   │
│  └─────────────────────────────────────────────────┘   │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

### 6.3 Rule Structure — DRL Example

```java
package com.insurance.claims.stp

import com.insurance.claims.model.Claim
import com.insurance.claims.model.Policy
import com.insurance.claims.model.STPDecision

rule "ELIG-001: Policy Active at Date of Loss"
    salience 100
    when
        $claim : Claim()
        $policy : Policy(
            policyId == $claim.policyId,
            status == "ACTIVE",
            effectiveDate <= $claim.dateOfLoss,
            expirationDate >= $claim.dateOfLoss
        )
        $decision : STPDecision(claimId == $claim.claimId)
    then
        $decision.addPassedRule("ELIG-001");
        update($decision);
end

rule "ELIG-001: Policy NOT Active at Date of Loss"
    salience 100
    when
        $claim : Claim()
        $policy : Policy(
            policyId == $claim.policyId,
            (status != "ACTIVE" ||
             effectiveDate > $claim.dateOfLoss ||
             expirationDate < $claim.dateOfLoss)
        )
        $decision : STPDecision(claimId == $claim.claimId)
    then
        $decision.addFailedRule("ELIG-001", "Policy not active at date of loss");
        $decision.setSTPEligible(false);
        $decision.setFalloutReason("POLICY_NOT_ACTIVE");
        update($decision);
end

rule "ELIG-004: Claim Amount Below STP Threshold"
    salience 90
    when
        $claim : Claim(stpEligible == true)
        $threshold : STPThreshold(
            lob == $claim.lineOfBusiness,
            coverageType == $claim.coverageType
        )
        eval($claim.getClaimedAmount().compareTo($threshold.getMaxAmount()) <= 0)
        $decision : STPDecision(claimId == $claim.claimId)
    then
        $decision.addPassedRule("ELIG-004");
        update($decision);
end

rule "FRD-001: New Policy Fraud Check"
    salience 80
    when
        $claim : Claim(stpEligible == true)
        $policy : Policy(
            policyId == $claim.policyId
        )
        eval(daysBetween($policy.getInceptionDate(), $claim.getDateOfLoss()) < 30)
        $decision : STPDecision(claimId == $claim.claimId)
    then
        $decision.addFraudFlag("FRD-001", "Claim within 30 days of inception");
        $decision.incrementFraudScore(15);
        update($decision);
end
```

### 6.4 DMN Decision Table Example

```
+--------------------------------------------------+
| DECISION TABLE: STP_Threshold_Lookup              |
+--------------------------------------------------+
| INPUT                    | OUTPUT                 |
| LOB        | Coverage    | STP_Threshold | Max    |
|            | Type        |               | Clmts  |
+------------+-------------+---------------+--------+
| AUTO_PPA   | COMP_GLASS  | 2500          | 1      |
| AUTO_PPA   | COMP_OTHER  | 5000          | 1      |
| AUTO_PPA   | COLLISION   | 5000          | 1      |
| AUTO_PPA   | TOW         | 500           | 1      |
| AUTO_PPA   | RENTAL      | 1500          | 1      |
| AUTO_PPA   | MED_PAY     | 2000          | 2      |
| AUTO_COMM  | PHYS_DMG    | 7500          | 1      |
| HOME_HO3   | PROP_DMG    | 10000         | 1      |
| HOME_HO3   | PERS_PROP   | 5000          | 1      |
| WC         | MED_ONLY    | 5000          | 1      |
| COMM_PROP  | BLDG_DMG    | 15000         | 1      |
+------------+-------------+---------------+--------+
| Hit Policy: UNIQUE (U)                            |
+--------------------------------------------------+
```

### 6.5 Custom Rules Engine Architecture

For carriers building a custom engine:

```
┌──────────────────────────────────────────────────────┐
│              CUSTOM RULES ENGINE                      │
│                                                       │
│  ┌─────────────────────────────────────────────┐     │
│  │          Rule Repository (Database)          │     │
│  │  ┌────────────┐  ┌────────────┐             │     │
│  │  │ Rule Sets  │  │ Versions   │             │     │
│  │  │ Categories │  │ Effective  │             │     │
│  │  │ Priorities │  │ Dates      │             │     │
│  │  └────────────┘  └────────────┘             │     │
│  └─────────────────────┬───────────────────────┘     │
│                        │                              │
│  ┌─────────────────────▼───────────────────────┐     │
│  │          Rule Evaluation Engine               │     │
│  │                                               │     │
│  │  1. Load applicable rule set (cached)         │     │
│  │  2. Sort rules by priority                    │     │
│  │  3. For each rule:                            │     │
│  │     a. Evaluate conditions against claim      │     │
│  │     b. Short-circuit on first FAIL (optional) │     │
│  │     c. Execute actions                        │     │
│  │     d. Log result                             │     │
│  │  4. Aggregate results                         │     │
│  │  5. Return decision                           │     │
│  └─────────────────────┬───────────────────────┘     │
│                        │                              │
│  ┌─────────────────────▼───────────────────────┐     │
│  │          Rule Audit Trail                     │     │
│  │  - Every rule evaluation logged               │     │
│  │  - Input/output captured                      │     │
│  │  - Performance metrics recorded               │     │
│  └─────────────────────────────────────────────┘     │
│                                                       │
└──────────────────────────────────────────────────────┘
```

Data model for custom engine:

```sql
CREATE TABLE rule_set (
    rule_set_id        UUID PRIMARY KEY,
    rule_set_name      VARCHAR(100) NOT NULL,
    rule_set_category  VARCHAR(50) NOT NULL,
    lob                VARCHAR(20),
    effective_date     DATE NOT NULL,
    expiration_date    DATE,
    version            INTEGER NOT NULL DEFAULT 1,
    status             VARCHAR(20) NOT NULL DEFAULT 'DRAFT',
    created_by         VARCHAR(50) NOT NULL,
    created_at         TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at         TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE rule_definition (
    rule_id            UUID PRIMARY KEY,
    rule_set_id        UUID REFERENCES rule_set(rule_set_id),
    rule_code          VARCHAR(50) NOT NULL UNIQUE,
    rule_name          VARCHAR(200) NOT NULL,
    rule_description   TEXT,
    rule_category      VARCHAR(50) NOT NULL,
    priority           INTEGER NOT NULL DEFAULT 100,
    condition_expression TEXT NOT NULL,
    action_expression  TEXT NOT NULL,
    failure_message    VARCHAR(500),
    is_blocking        BOOLEAN DEFAULT TRUE,
    is_active          BOOLEAN DEFAULT TRUE,
    created_at         TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at         TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE rule_condition (
    condition_id       UUID PRIMARY KEY,
    rule_id            UUID REFERENCES rule_definition(rule_id),
    condition_order    INTEGER NOT NULL,
    field_path         VARCHAR(200) NOT NULL,
    operator           VARCHAR(20) NOT NULL,
    value_expression   TEXT NOT NULL,
    data_type          VARCHAR(20) NOT NULL,
    logical_operator   VARCHAR(5) DEFAULT 'AND'
);

CREATE TABLE rule_execution_log (
    log_id             UUID PRIMARY KEY,
    claim_id           VARCHAR(20) NOT NULL,
    rule_set_id        UUID NOT NULL,
    rule_id            UUID NOT NULL,
    rule_code          VARCHAR(50) NOT NULL,
    execution_timestamp TIMESTAMP NOT NULL,
    result             VARCHAR(20) NOT NULL,
    input_snapshot     JSONB,
    output_snapshot    JSONB,
    execution_time_ms  INTEGER,
    error_details      TEXT
);
```

---

## 7. Workflow Automation & BPM Integration

### 7.1 BPM Engine Comparison for Claims

| Feature | Camunda | Appian | Pega | Guidewire ClaimCenter |
|---------|---------|--------|------|----------------------|
| **Architecture** | Lightweight, embeddable | Low-code platform | Low-code + AI | Claims-specific suite |
| **BPMN Support** | Full BPMN 2.0 | Visual designer | Proprietary + BPMN | Claims workflows |
| **DMN Support** | Full DMN 1.3 | Decision rules | Decision tables | Business rules |
| **Case Management** | CMMN support | Built-in | Built-in | Native claims |
| **Integration** | REST, gRPC, Kafka | REST, SOAP | REST, connectors | GW Cloud API |
| **Deployment** | On-prem, Cloud, SaaS | Cloud | Cloud, on-prem | Cloud (GW Cloud) |
| **Scalability** | High (Zeebe engine) | High | High | High |
| **Claims Fit** | Good (customizable) | Good | Excellent | Purpose-built |
| **User Task UI** | Tasklist + custom | Auto-generated | Auto-generated | ClaimCenter UI |
| **Cost Model** | OSS + Enterprise | Per user/month | Per user/month | Premium license |
| **Learning Curve** | Medium | Low | Medium-High | High (domain) |

### 7.2 BPMN Process Model for STP Claims

```
┌───────┐    ┌──────────┐    ┌──────────┐    ┌──────────┐
│ START │───▶│ Receive  │───▶│ Validate │───▶│ STP      │
│ EVENT │    │ FNOL     │    │ FNOL     │    │ Check    │
└───────┘    └──────────┘    └──────────┘    └─────┬────┘
                                                    │
                                          ┌─────────┴─────────┐
                                          │                   │
                                    [STP=YES]           [STP=NO]
                                          │                   │
                                          ▼                   ▼
                                   ┌──────────┐       ┌──────────┐
                                   │ Auto     │       │ Manual   │
                                   │ Coverage │       │ Queue    │
                                   │ Check    │       │ (HUMAN)  │
                                   └─────┬────┘       └──────────┘
                                         │
                                   [COVERED?]
                                  ┌──────┴──────┐
                                  │             │
                             [YES]│        [NO] │
                                  ▼             ▼
                           ┌──────────┐  ┌──────────┐
                           │ Auto     │  │ Coverage │
                           │ Liability│  │ Denial   │
                           │ Assess   │  │ Letter   │
                           └─────┬────┘  └──────────┘
                                 │
                           ┌──────────┐
                           │ Auto     │
                           │ Damage   │
                           │ Assess   │
                           └─────┬────┘
                                 │
                           ┌──────────┐
                           │ Fraud    │
                           │ Score    │
                           └─────┬────┘
                                 │
                           [SCORE OK?]
                          ┌──────┴──────┐
                          │             │
                     [YES]│        [NO] │
                          ▼             ▼
                   ┌──────────┐  ┌──────────┐
                   │ Auto     │  │ SIU      │
                   │ Reserve  │  │ Referral │
                   │ & Pay    │  │ (HUMAN)  │
                   └─────┬────┘  └──────────┘
                         │
                   ┌──────────┐
                   │ Send     │
                   │ Payment  │
                   └─────┬────┘
                         │
                   ┌──────────┐
                   │ Close    │
                   │ Claim    │
                   └─────┬────┘
                         │
                   ┌──────────┐
                   │   END    │
                   └──────────┘
```

### 7.3 Camunda Integration Pattern

```java
// Camunda External Task Worker for STP Coverage Check
@Component
public class CoverageCheckWorker {

    @Autowired
    private PolicyService policyService;

    @Autowired
    private CoverageRulesEngine coverageRulesEngine;

    @ExternalTaskHandler(topicName = "stp-coverage-check")
    public void handleCoverageCheck(ExternalTask task, ExternalTaskService service) {
        String claimId = task.getVariable("claimId");
        String policyId = task.getVariable("policyId");
        String dateOfLoss = task.getVariable("dateOfLoss");
        String coverageType = task.getVariable("coverageType");

        try {
            Policy policy = policyService.getPolicy(policyId);
            CoverageResult result = coverageRulesEngine.evaluate(
                policy, claimId, dateOfLoss, coverageType
            );

            Map<String, Object> variables = new HashMap<>();
            variables.put("coverageVerified", result.isCovered());
            variables.put("deductibleAmount", result.getDeductible());
            variables.put("coverageLimit", result.getLimit());
            variables.put("coverageDecisionReason", result.getReason());

            service.complete(task, variables);
        } catch (Exception e) {
            service.handleFailure(task, e.getMessage(), null, 3, 10000L);
        }
    }
}
```

### 7.4 Workflow State Machine for Claims

```
                    ┌───────────┐
                    │   NEW     │
                    └─────┬─────┘
                          │ create_claim
                          ▼
                    ┌───────────┐
              ┌─────│   OPEN    │─────┐
              │     └─────┬─────┘     │
              │           │           │
         assign_stp   assign_adj   coverage_deny
              │           │           │
              ▼           ▼           ▼
        ┌───────────┐ ┌────────┐ ┌──────────┐
        │ STP_PROC  │ │ INVEST │ │ DENIED   │
        └─────┬─────┘ └───┬────┘ └──────────┘
              │           │
         stp_approve   complete_investigation
              │           │
              ▼           ▼
        ┌───────────┐ ┌────────────┐
        │ STP_PAY   │ │ NEGOTIATION│
        └─────┬─────┘ └─────┬──────┘
              │             │
         payment_sent   settlement_agreed
              │             │
              ▼             ▼
        ┌───────────────────────┐
        │       PAYMENT         │
        └──────────┬────────────┘
                   │ payment_cleared
                   ▼
        ┌───────────────────────┐
        │       CLOSED          │
        └───────────────────────┘
```

---

## 8. Robotic Process Automation (RPA) in Claims

### 8.1 RPA Use Cases in Claims

| # | Use Case | Process | Bot Type | Estimated Savings |
|---|----------|---------|----------|-------------------|
| 1 | FNOL data entry from email | Extract claim data from emailed reports, enter into claim system | Unattended | 5 min/claim |
| 2 | Policy verification | Look up policy in legacy system, verify coverage | Unattended | 3 min/claim |
| 3 | ISO ClaimSearch query | Submit and retrieve claim search results | Unattended | 8 min/claim |
| 4 | DMV/motor vehicle record pull | Query state DMV for driver/vehicle info | Unattended | 4 min/claim |
| 5 | Medical bill data entry | Extract data from medical bills, enter into bill review system | Unattended | 15 min/bill |
| 6 | Check printing and mailing | Generate checks, print, stuff envelopes | Unattended | 2 min/check |
| 7 | Subrogation demand letter | Generate and send demand letters from templates | Unattended | 10 min/demand |
| 8 | Diary follow-up | Check diary items, send reminders, escalate | Unattended | 3 min/diary |
| 9 | Reserve update in legacy | Post reserve changes from modern to legacy system | Unattended | 4 min/update |
| 10 | Regulatory report generation | Compile data, generate state-mandated reports | Unattended | 60 min/report |
| 11 | Vendor invoice reconciliation | Match invoices to authorizations, flag discrepancies | Unattended | 7 min/invoice |
| 12 | Claim status inquiry response | Look up claim status, respond to policyholder email | Attended | 5 min/inquiry |

### 8.2 Attended vs Unattended RPA

```
ATTENDED RPA                           UNATTENDED RPA
┌──────────────────────┐               ┌──────────────────────┐
│  Adjuster Desktop    │               │  RPA Server          │
│                      │               │  (Orchestrator)      │
│  ┌────────────────┐  │               │                      │
│  │ Adjuster works │  │               │  ┌────────────────┐  │
│  │ in claim system│  │               │  │ Scheduler      │  │
│  └───────┬────────┘  │               │  │ triggers bots  │  │
│          │           │               │  └───────┬────────┘  │
│          │ triggers  │               │          │           │
│          ▼           │               │          ▼           │
│  ┌────────────────┐  │               │  ┌────────────────┐  │
│  │ Bot assists    │  │               │  │ Bot runs on    │  │
│  │ with task      │  │               │  │ virtual machine│  │
│  │ (foreground)   │  │               │  │ (background)   │  │
│  └───────┬────────┘  │               │  └───────┬────────┘  │
│          │           │               │          │           │
│          │ returns   │               │          │ logs &    │
│          ▼           │               │          ▼ reports   │
│  ┌────────────────┐  │               │  ┌────────────────┐  │
│  │ Adjuster       │  │               │  │ Results stored │  │
│  │ continues work │  │               │  │ in queue/DB    │  │
│  └────────────────┘  │               │  └────────────────┘  │
│                      │               │                      │
│ USE WHEN:            │               │ USE WHEN:            │
│ - Decision required  │               │ - Rule-based task    │
│ - Human judgment     │               │ - High volume        │
│ - Exception handling │               │ - Off-hours process  │
│ - Complex navigation │               │ - No judgment needed │
└──────────────────────┘               └──────────────────────┘
```

### 8.3 RPA Bot Design Pattern

```
BOT: ISO_ClaimSearch_Query_Bot

TRIGGER: New claim created with claimant SSN/Name available
SCHEDULE: Every 15 minutes, process queue

STEPS:
  1. READ claim queue for pending ISO searches
  2. FOR EACH claim in queue:
     a. OPEN ISO ClaimSearch portal
     b. ENTER search criteria:
        - Last Name, First Name
        - SSN (if available)
        - Date of Birth
        - Date of Loss (+/- 30 days)
        - State
     c. SUBMIT search
     d. WAIT for results (timeout: 30 seconds)
     e. IF results found:
        - CAPTURE matching claim records
        - PARSE: carrier, claim number, DOL, claim type, status
        - STORE results in claim system activity log
        - FLAG claim if suspicious matches found
     f. IF no results:
        - LOG "No prior claims found"
     g. UPDATE claim record with search timestamp
     h. MARK queue item as processed
  3. GENERATE daily summary report
  4. SEND report to supervisory queue

ERROR HANDLING:
  - Portal timeout: Retry 3 times, then park in error queue
  - Login failure: Alert IT operations, pause bot
  - Data format error: Log error, skip record, continue
  - Queue empty: Sleep for 15 minutes
```

---

## 9. Intelligent Document Processing (IDP)

### 9.1 IDP Pipeline Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                    DOCUMENT INTAKE LAYER                         │
│                                                                  │
│  ┌──────┐  ┌──────┐  ┌──────┐  ┌──────┐  ┌──────┐            │
│  │Email │  │Fax   │  │Upload│  │Mobile│  │Vendor│            │
│  │Attach│  │Server│  │Portal│  │App   │  │Portal│            │
│  └──┬───┘  └──┬───┘  └──┬───┘  └──┬───┘  └──┬───┘            │
│     │         │         │         │         │                  │
│     └─────────┴─────────┴─────────┴─────────┘                  │
│                         │                                       │
│                         ▼                                       │
│              ┌────────────────────┐                             │
│              │  Document Queue    │                             │
│              │  (Object Storage)  │                             │
│              └─────────┬──────────┘                             │
└─────────────────────────┼──────────────────────────────────────┘
                          │
┌─────────────────────────▼──────────────────────────────────────┐
│                    PRE-PROCESSING LAYER                         │
│                                                                  │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐      │
│  │ Format   │  │ Image    │  │ Deskew   │  │ Noise    │      │
│  │ Detection│  │ Quality  │  │ Rotate   │  │ Removal  │      │
│  │          │  │ Check    │  │ Crop     │  │ Enhance  │      │
│  └──────────┘  └──────────┘  └──────────┘  └──────────┘      │
│                                                                  │
└─────────────────────────┼──────────────────────────────────────┘
                          │
┌─────────────────────────▼──────────────────────────────────────┐
│                    CLASSIFICATION LAYER                          │
│                                                                  │
│  Document Type Classifier (ML Model)                            │
│  Classes:                                                        │
│    - Police Report          - Medical Record                    │
│    - Repair Estimate        - Medical Bill                      │
│    - Invoice                - Attorney Letter                   │
│    - Photos (damage)        - Proof of Loss                     │
│    - ID Document            - Subrogation Demand                │
│    - Correspondence         - Legal Filing                      │
│    - Policy Declaration     - Salvage Report                    │
│                                                                  │
│  Confidence Threshold: >= 90% auto-classify, < 90% human review│
│                                                                  │
└─────────────────────────┼──────────────────────────────────────┘
                          │
┌─────────────────────────▼──────────────────────────────────────┐
│                    EXTRACTION LAYER                              │
│                                                                  │
│  ┌────────────────┐  ┌────────────────┐  ┌────────────────┐   │
│  │ OCR Engine     │  │ ICR Engine     │  │ Table          │   │
│  │ (Printed Text) │  │ (Handwriting)  │  │ Extraction     │   │
│  │ ABBYY/Textract│  │ Google Vision  │  │ (Structured)   │   │
│  └────────┬───────┘  └────────┬───────┘  └────────┬───────┘   │
│           │                   │                    │            │
│           └───────────────────┴────────────────────┘            │
│                               │                                  │
│                    ┌──────────▼──────────┐                      │
│                    │  NER + Field        │                      │
│                    │  Extraction Engine  │                      │
│                    │  (Entity Mapping)   │                      │
│                    └──────────┬──────────┘                      │
│                               │                                  │
│                    ┌──────────▼──────────┐                      │
│                    │  Validation &       │                      │
│                    │  Confidence Scoring │                      │
│                    └────────────────────┘                       │
│                                                                  │
└─────────────────────────┼──────────────────────────────────────┘
                          │
┌─────────────────────────▼──────────────────────────────────────┐
│                    INTEGRATION LAYER                             │
│                                                                  │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │  Map extracted fields to claim system fields              │  │
│  │  Auto-populate claim record                               │  │
│  │  Attach document to claim file                            │  │
│  │  Trigger downstream workflows                             │  │
│  └──────────────────────────────────────────────────────────┘  │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

### 9.2 Document-Specific Extraction Fields

#### Police Report Extraction

| Field | Source Location | Extraction Method | Confidence Target |
|-------|----------------|-------------------|-------------------|
| Report Number | Header, top-right | OCR + regex | 98% |
| Date of Accident | Section header | OCR + date parser | 95% |
| Time of Accident | Section header | OCR + time parser | 95% |
| Location/Address | Narrative or field | NER (location) | 90% |
| Officer Name/Badge | Footer or header | OCR + NER | 92% |
| Vehicle 1 Info | Vehicle section | Structured OCR | 93% |
| Vehicle 2 Info | Vehicle section | Structured OCR | 93% |
| Driver 1 Info | Driver section | NER (person) | 91% |
| Driver 2 Info | Driver section | NER (person) | 91% |
| Narrative | Free-text section | Full OCR | 88% |
| Diagram | Drawing section | Image classification | 75% |
| Citations Issued | Citation section | OCR + NER | 90% |
| Weather Conditions | Checkbox/field | OCR + classification | 85% |
| Road Conditions | Checkbox/field | OCR + classification | 85% |

#### Medical Bill Extraction

| Field | Source Location | Extraction Method | Confidence Target |
|-------|----------------|-------------------|-------------------|
| Provider Name | Header | OCR + NER (org) | 96% |
| Provider NPI | Header | OCR + regex | 98% |
| Provider Tax ID | Header | OCR + regex | 97% |
| Patient Name | Patient section | NER (person) | 95% |
| Date of Service | Line items | OCR + date parser | 94% |
| CPT/HCPCS Codes | Line items | Table OCR + regex | 93% |
| ICD-10 Codes | Diagnosis section | OCR + regex | 93% |
| Billed Amount | Line items | Table OCR + currency | 95% |
| Total Amount | Summary | OCR + currency | 96% |
| Place of Service | Field | OCR + code lookup | 90% |

#### Repair Estimate Extraction

| Field | Source Location | Extraction Method | Confidence Target |
|-------|----------------|-------------------|-------------------|
| Estimate Number | Header | OCR + regex | 97% |
| Shop Name | Header | OCR + NER (org) | 95% |
| Vehicle Year/Make/Model | Vehicle section | OCR + VIN decode | 96% |
| VIN | Vehicle section | OCR + VIN validation | 97% |
| Mileage | Vehicle section | OCR + numeric | 93% |
| Line Items | Repair details | Table OCR | 90% |
| Parts (OEM/Aftermarket) | Line items | OCR + classification | 88% |
| Labor Hours | Line items | Table OCR + numeric | 91% |
| Labor Rate | Line items | Table OCR + currency | 92% |
| Paint/Materials | Line items | Table OCR + currency | 90% |
| Total Estimate | Summary | OCR + currency | 95% |
| Supplement Flag | Header/notation | OCR + classification | 85% |

### 9.3 IDP Platform Selection

| Platform | OCR Quality | Classification | Extraction | Claims Fit | Cloud |
|----------|-------------|----------------|------------|-----------|-------|
| ABBYY FlexiCapture | Excellent | Good | Good | Good | Hybrid |
| AWS Textract | Very Good | Good | Good | Medium | AWS |
| Google Document AI | Excellent | Excellent | Excellent | Good | GCP |
| Azure Form Recognizer | Very Good | Good | Very Good | Good | Azure |
| Hyperscience | Excellent | Excellent | Excellent | Excellent | Hybrid |
| Indico Data | Good | Excellent | Excellent | Good | Cloud |
| Kofax | Excellent | Good | Good | Good | Hybrid |

---

## 10. Auto-Adjudication Logic

### 10.1 Auto-Adjudication for Glass Claims

```
FUNCTION auto_adjudicate_glass(claim):
    
    // Step 1: Coverage verification
    policy = get_policy(claim.policy_id)
    IF NOT policy.has_coverage('COMPREHENSIVE'):
        RETURN AdjudicationResult(status='DENIED', reason='NO_COMP_COVERAGE')
    
    // Step 2: Deductible determination
    deductible = policy.get_deductible('COMPREHENSIVE')
    IF state_law_requires_glass_deductible_waiver(claim.loss_state):
        deductible = 0
    
    // Step 3: Vendor estimate validation
    vendor_estimate = claim.get_vendor_estimate()
    market_rate = get_glass_market_rate(claim.vehicle, claim.glass_type)
    
    IF vendor_estimate.amount > market_rate * 1.15:
        RETURN AdjudicationResult(status='REVIEW', reason='ESTIMATE_ABOVE_MARKET')
    
    // Step 4: Calculate payment
    payment_amount = vendor_estimate.amount - deductible
    IF payment_amount <= 0:
        RETURN AdjudicationResult(status='DENIED', reason='BELOW_DEDUCTIBLE')
    
    // Step 5: Determine payee
    IF claim.vendor_direct_pay:
        payee = vendor_estimate.vendor
    ELSE:
        payee = policy.named_insured
    
    // Step 6: Generate payment
    RETURN AdjudicationResult(
        status='APPROVED',
        payment_amount=payment_amount,
        payee=payee,
        payment_method='EFT',
        reserve_amount=payment_amount
    )
```

### 10.2 Auto-Adjudication for Tow Claims

```
FUNCTION auto_adjudicate_tow(claim):
    
    policy = get_policy(claim.policy_id)
    IF NOT policy.has_coverage('TOWING'):
        RETURN AdjudicationResult(status='DENIED', reason='NO_TOW_COVERAGE')
    
    tow_coverage = policy.get_coverage_details('TOWING')
    
    // Validate vendor
    IF claim.vendor_id NOT IN get_approved_tow_vendors(claim.loss_location):
        RETURN AdjudicationResult(status='REVIEW', reason='NON_APPROVED_VENDOR')
    
    // Validate charges
    vendor_charges = claim.get_vendor_invoice()
    max_rate_per_mile = get_tow_rate_schedule(claim.loss_state)
    max_hookup_fee = get_hookup_fee_schedule(claim.loss_state)
    
    IF vendor_charges.per_mile_rate > max_rate_per_mile * 1.10:
        RETURN AdjudicationResult(status='REVIEW', reason='RATE_ABOVE_SCHEDULE')
    
    IF vendor_charges.total > tow_coverage.max_per_occurrence:
        payment_amount = tow_coverage.max_per_occurrence
    ELSE:
        payment_amount = vendor_charges.total
    
    RETURN AdjudicationResult(
        status='APPROVED',
        payment_amount=payment_amount,
        payee=vendor_charges.vendor,
        payment_method='EFT'
    )
```

### 10.3 Auto-Adjudication for Simple Property Claims

```
FUNCTION auto_adjudicate_property(claim):
    
    policy = get_policy(claim.policy_id)
    
    // Coverage check
    applicable_coverage = determine_property_coverage(policy, claim)
    IF applicable_coverage IS NULL:
        RETURN AdjudicationResult(status='DENIED', reason='NO_APPLICABLE_COVERAGE')
    
    // Deductible
    deductible = applicable_coverage.deductible
    IF claim.cause_of_loss IN ('HURRICANE', 'NAMED_STORM'):
        deductible = policy.hurricane_deductible  // Often percentage-based
    
    // Damage assessment
    IF claim.has_contractor_estimate:
        estimate = claim.contractor_estimate
        IF estimate.amount > get_xactimate_benchmark(claim) * 1.20:
            RETURN AdjudicationResult(status='REVIEW', reason='ESTIMATE_HIGH')
    ELIF claim.has_ai_estimate:
        estimate = claim.ai_estimate
        IF estimate.confidence < 0.85:
            RETURN AdjudicationResult(status='REVIEW', reason='LOW_CONFIDENCE')
    ELSE:
        RETURN AdjudicationResult(status='REVIEW', reason='NO_ESTIMATE')
    
    // Depreciation (if ACV policy)
    IF applicable_coverage.valuation = 'ACV':
        depreciation = calculate_depreciation(claim.damaged_items)
        net_amount = estimate.amount - depreciation
    ELSE:
        net_amount = estimate.amount
    
    // Payment calculation
    payment_amount = net_amount - deductible
    
    IF payment_amount > applicable_coverage.limit:
        payment_amount = applicable_coverage.limit - deductible
    
    IF payment_amount <= 0:
        RETURN AdjudicationResult(status='DENIED', reason='BELOW_DEDUCTIBLE')
    
    // Mortgage clause check
    IF payment_amount > mortgage_clause_threshold AND policy.has_mortgagee:
        payee = [policy.named_insured, policy.mortgagee]
    ELSE:
        payee = policy.named_insured
    
    RETURN AdjudicationResult(
        status='APPROVED',
        payment_amount=payment_amount,
        payee=payee,
        deductible_applied=deductible,
        depreciation_applied=depreciation if ACV else 0,
        holdback_amount=depreciation if RC else 0
    )
```

---

## 11. Configurable Business Rules by LOB

### 11.1 Personal Auto Rules Configuration

```json
{
  "lob": "PERSONAL_AUTO",
  "rule_set_version": "2024.03",
  "effective_date": "2024-03-01",
  "rules": {
    "stp_eligibility": {
      "max_claimed_amount": {
        "COMPREHENSIVE_GLASS": 2500,
        "COMPREHENSIVE_NON_GLASS": 5000,
        "COLLISION": 5000,
        "TOWING": 500,
        "RENTAL": 1500,
        "MED_PAY": 2000,
        "UNINSURED_MOTORIST_PD": 5000
      },
      "max_claimants": 2,
      "max_vehicles": 1,
      "excluded_injury_types": ["SEVERE", "PERMANENT", "FATALITY"],
      "max_fraud_score": 30,
      "min_document_completeness": 0.80,
      "new_policy_exclusion_days": 0,
      "max_prior_claims_12_months": 3
    },
    "coverage_verification": {
      "grace_period_days": 30,
      "permissive_use_allowed": true,
      "unlisted_driver_allowed": true,
      "unlisted_driver_excluded_states": ["MI"],
      "territory_check_enabled": true
    },
    "liability": {
      "auto_determine_scenarios": [
        "SINGLE_VEHICLE_FIXED_OBJECT",
        "SINGLE_VEHICLE_ANIMAL",
        "PARKED_VEHICLE_HIT",
        "REAR_END_CLEAR",
        "VANDALISM",
        "THEFT",
        "WEATHER_DAMAGE"
      ],
      "comparative_negligence_threshold": 50,
      "state_fault_rules_enabled": true
    },
    "payment": {
      "max_auto_pay_amount": 5000,
      "payment_methods": {
        "under_1000": "EFT",
        "1000_to_10000": "EFT",
        "over_10000": "CHECK"
      },
      "lienholder_threshold": 0,
      "deductible_waiver_states_glass": ["FL", "KY", "SC", "AZ", "CT", "MA", "MN"]
    },
    "reserves": {
      "initial_reserve_method": "TABULAR",
      "reserve_tables": {
        "COMPREHENSIVE_GLASS": {"min": 300, "max": 2500, "default": 750},
        "COMPREHENSIVE_NON_GLASS": {"min": 500, "max": 10000, "default": 2500},
        "COLLISION": {"min": 1000, "max": 25000, "default": 5000},
        "TOWING": {"min": 50, "max": 500, "default": 150},
        "RENTAL": {"min": 200, "max": 1500, "default": 600}
      }
    }
  }
}
```

### 11.2 Homeowners Rules Configuration

```json
{
  "lob": "HOMEOWNERS",
  "rule_set_version": "2024.03",
  "effective_date": "2024-03-01",
  "rules": {
    "stp_eligibility": {
      "max_claimed_amount": {
        "DWELLING_DAMAGE": 10000,
        "PERSONAL_PROPERTY": 5000,
        "ADDITIONAL_LIVING_EXPENSE": 3000,
        "LIABILITY": null,
        "MED_PAY": 1000
      },
      "excluded_perils": ["FLOOD", "EARTHQUAKE", "MOLD", "SINKHOLE"],
      "max_fraud_score": 25,
      "required_documents": ["PROOF_OF_LOSS", "PHOTOS", "ESTIMATE"],
      "catastrophe_event_override": true
    },
    "coverage_verification": {
      "policy_forms_supported": ["HO-3", "HO-5", "HO-6", "DP-3"],
      "special_limits_check": true,
      "ordinance_or_law_check": true,
      "coinsurance_check": true,
      "mortgage_clause_threshold": 5000
    },
    "damage_assessment": {
      "xactimate_integration": true,
      "aerial_imagery_enabled": true,
      "contractor_estimate_variance_threshold": 0.20,
      "ai_estimate_min_confidence": 0.85,
      "depreciation_schedules_enabled": true,
      "replacement_cost_holdback": true
    },
    "cat_event_rules": {
      "auto_assign_by_geography": true,
      "surge_pricing_rules": true,
      "temporary_threshold_increase": 1.5,
      "expedited_payment_enabled": true,
      "advance_payment_enabled": true,
      "advance_payment_max": 5000
    }
  }
}
```

### 11.3 Workers Compensation Rules Configuration

```json
{
  "lob": "WORKERS_COMPENSATION",
  "rule_set_version": "2024.03",
  "effective_date": "2024-03-01",
  "rules": {
    "stp_eligibility": {
      "eligible_claim_types": ["MEDICAL_ONLY"],
      "max_medical_amount": 5000,
      "excluded_injury_types": ["AMPUTATION", "BRAIN_INJURY", "SPINAL", "DEATH"],
      "max_lost_days": 0,
      "employer_report_required": true,
      "state_filing_auto": true
    },
    "coverage_verification": {
      "verify_employment_status": true,
      "verify_arising_out_of_employment": true,
      "verify_in_course_of_employment": true,
      "waiting_period_check": true,
      "state_specific_waiting_periods": {
        "CA": 3, "TX": 7, "NY": 7, "FL": 7, "IL": 3
      }
    },
    "medical_management": {
      "treatment_guideline_source": "ODG",
      "utilization_review_auto": true,
      "pharmacy_pbm_integration": true,
      "fee_schedule_by_state": true,
      "medical_provider_network_check": true,
      "pre_authorization_required_procedures": [
        "MRI", "SURGERY", "PHYSICAL_THERAPY_EXTENDED"
      ]
    },
    "state_reporting": {
      "first_report_deadline_days": {
        "CA": 5, "TX": 8, "NY": 10, "FL": 7
      },
      "electronic_filing_required_states": ["CA", "NY", "TX", "FL", "IL"],
      "edi_format": "IAIABC_FROI",
      "subsequent_report_triggers": [
        "INDEMNITY_PAYMENT", "DENIAL", "RETURN_TO_WORK", "CLOSURE"
      ]
    }
  }
}
```

### 11.4 Commercial General Liability Rules Configuration

```json
{
  "lob": "GENERAL_LIABILITY",
  "rule_set_version": "2024.03",
  "effective_date": "2024-03-01",
  "rules": {
    "stp_eligibility": {
      "eligible_for_stp": false,
      "reason": "GL claims require investigation and liability analysis",
      "auto_reserve_enabled": true,
      "auto_triage_enabled": true,
      "auto_assignment_enabled": true
    },
    "triage": {
      "severity_scoring_enabled": true,
      "severity_factors": [
        "claimed_amount",
        "injury_type",
        "claimant_representation",
        "venue",
        "policy_limits",
        "prior_similar_claims"
      ],
      "assignment_rules": {
        "LOW": "DESK_ADJUSTER",
        "MEDIUM": "FIELD_ADJUSTER",
        "HIGH": "SENIOR_ADJUSTER",
        "COMPLEX": "COMPLEX_CLAIMS_UNIT"
      }
    },
    "coverage_analysis": {
      "occurrence_vs_claims_made_check": true,
      "additional_insured_check": true,
      "contractual_liability_check": true,
      "professional_services_exclusion_check": true,
      "pollution_exclusion_check": true,
      "aggregate_tracking_enabled": true
    }
  }
}
```

---

## 12. Decision Tables & Decision Trees

### 12.1 Coverage Verification Decision Table

```
+--------+----------+----------+----------+----------+----------+---------+
| Policy | Coverage | DOL in   | Premium  | Vehicle  | Exclu-   | RESULT  |
| Active | Exists   | Period   | Current  | Listed   | sion     |         |
+--------+----------+----------+----------+----------+----------+---------+
| Y      | Y        | Y        | Y        | Y        | N        | COVERED |
| Y      | Y        | Y        | Y        | N        | N        | REVIEW  |
| Y      | Y        | Y        | N        | Y        | N        | REVIEW  |
| Y      | Y        | Y        | Y        | Y        | Y        | DENIED  |
| Y      | N        | -        | -        | -        | -        | DENIED  |
| N      | -        | -        | -        | -        | -        | DENIED  |
| Y      | Y        | N        | -        | -        | -        | DENIED  |
| -      | -        | -        | -        | -        | -        | REVIEW  |
+--------+----------+----------+----------+----------+----------+---------+
```

### 12.2 Claim Severity Decision Tree

```
                            ┌──────────────────┐
                            │ Bodily Injury?   │
                            └────────┬─────────┘
                              ┌──────┴──────┐
                            [YES]          [NO]
                              │              │
                              ▼              ▼
                    ┌────────────────┐  ┌────────────────┐
                    │ Hospitalized?  │  │ Property Only   │
                    └───────┬────────┘  │ Amount > $15K? │
                      ┌─────┴─────┐    └───────┬────────┘
                    [YES]       [NO]      ┌─────┴─────┐
                      │          │       [YES]      [NO]
                      ▼          ▼        │          │
              ┌──────────┐ ┌──────────┐  ▼          ▼
              │Surgery   │ │ER Visit? │ MEDIUM     LOW
              │Required? │ └────┬─────┘
              └────┬─────┘  ┌───┴───┐
              ┌────┴────┐ [YES]  [NO]
            [YES]     [NO]  │      │
              │         │   ▼      ▼
              ▼         ▼ MEDIUM  LOW
           ┌────────┐ ┌────────┐
           │Multi-  │ │Attorney│
           │Surgery?│ │Repre-  │
           └──┬─────┘ │sented? │
          ┌───┴───┐   └──┬─────┘
        [YES]  [NO]  ┌───┴───┐
          │      │  [YES]  [NO]
          ▼      ▼    │      │
        SEVERE  HIGH  ▼      ▼
                     HIGH  MEDIUM

SEVERITY MAPPING:
  LOW    → Auto-adjudicate candidate, desk adjuster
  MEDIUM → Standard handling, experienced adjuster
  HIGH   → Senior adjuster, supervisor involvement
  SEVERE → Complex claims unit, litigation management
```

### 12.3 Fraud Risk Decision Tree

```
                            ┌──────────────────┐
                            │ Policy Age       │
                            │ < 60 days?       │
                            └────────┬─────────┘
                              ┌──────┴──────┐
                            [YES]          [NO]
                         (+20 pts)      (+0 pts)
                              │              │
                              ▼              ▼
                    ┌────────────────┐  ┌────────────────┐
                    │ Coverage       │  │ Prior Claims   │
                    │ Increased      │  │ > 2 in 12 mo?  │
                    │ < 90 days?     │  └───────┬────────┘
                    └───────┬────────┘    ┌─────┴─────┐
                      ┌─────┴─────┐     [YES]      [NO]
                    [YES]       [NO]  (+15 pts)  (+0 pts)
                  (+25 pts)  (+0 pts)     │          │
                      │          │        ▼          ▼
                      ▼          ▼     (continue)  (continue)
                   (continue) (continue)
                              ...
                              
FINAL SCORING:
  Total Points < 20  → LOW RISK    → STP eligible
  Total Points 20-40 → MEDIUM RISK → Enhanced review
  Total Points 40-60 → HIGH RISK   → SIU referral  
  Total Points > 60  → VERY HIGH   → Immediate SIU + hold
```

---

## 13. Automated Reserve Setting

### 13.1 Reserve Calculation Algorithms

```
ALGORITHM: Tabular Reserve Setting

INPUT: claim_type, lob, coverage, severity_score, loss_state, injury_type
OUTPUT: initial_reserve_amount

FUNCTION calculate_initial_reserve(claim):
    
    // Step 1: Get base reserve from lookup table
    base = LOOKUP reserve_table
           WHERE lob = claim.lob
           AND   coverage = claim.coverage_type
           AND   severity = claim.severity_category
    
    // Step 2: Apply state multiplier
    state_factor = LOOKUP state_factor_table
                   WHERE state = claim.loss_state
                   AND   lob = claim.lob
    adjusted = base * state_factor
    
    // Step 3: Apply injury modifier (if applicable)
    IF claim.has_bodily_injury:
        injury_factor = LOOKUP injury_factor_table
                        WHERE injury_type = claim.injury_type
                        AND   severity = claim.injury_severity
        adjusted = adjusted + (base * injury_factor)
    
    // Step 4: Apply vehicle/property modifier
    IF claim.lob = 'AUTO':
        vehicle_factor = LOOKUP vehicle_factor_table
                         WHERE vehicle_year = claim.vehicle_year
                         AND   vehicle_class = claim.vehicle_class
        adjusted = adjusted * vehicle_factor
    
    // Step 5: Apply inflation factor
    inflation = LOOKUP inflation_factor
                WHERE year = CURRENT_YEAR
                AND   lob = claim.lob
    adjusted = adjusted * inflation
    
    // Step 6: Cap at coverage limit
    adjusted = MIN(adjusted, claim.coverage_limit)
    
    // Step 7: Round to standard increment
    adjusted = ROUND_UP(adjusted, 100)  // Round to nearest $100
    
    RETURN adjusted
```

### 13.2 Reserve Tables

#### Auto Physical Damage Reserves

| Severity | Comp-Glass | Comp-Other | Collision | Rental | Towing |
|----------|-----------|------------|-----------|--------|--------|
| Low | $400 | $1,500 | $2,000 | $300 | $100 |
| Medium | $800 | $3,500 | $5,000 | $600 | $200 |
| High | $1,500 | $7,500 | $12,000 | $1,000 | $350 |
| Severe | $2,500 | $15,000 | $25,000 | $1,500 | $500 |
| Total Loss | N/A | ACV | ACV | Max | $500 |

#### Auto Bodily Injury Reserves

| Injury Type | Minor | Moderate | Serious | Severe | Catastrophic |
|------------|-------|----------|---------|--------|-------------|
| Soft Tissue | $3,000 | $8,000 | $20,000 | N/A | N/A |
| Fracture | $5,000 | $15,000 | $40,000 | $100,000 | N/A |
| Head/Brain | $10,000 | $30,000 | $100,000 | $500,000 | $1,000,000 |
| Spinal | $10,000 | $25,000 | $75,000 | $300,000 | $1,000,000 |
| Internal | $8,000 | $20,000 | $60,000 | $200,000 | $500,000 |
| Burns | $5,000 | $15,000 | $50,000 | $200,000 | $750,000 |
| Death | N/A | N/A | N/A | $100,000 | $500,000 |

### 13.3 ML-Enhanced Reserve Setting

```
ALGORITHM: ML-Enhanced Reserve Prediction

FEATURES:
  claim_features = {
    'lob': categorical,
    'coverage_type': categorical,
    'loss_state': categorical,
    'loss_cause': categorical,
    'injury_type': categorical,
    'injury_count': numeric,
    'vehicle_year': numeric,
    'vehicle_value': numeric,
    'claimant_age': numeric,
    'policy_limit': numeric,
    'deductible': numeric,
    'prior_claim_count': numeric,
    'days_to_report': numeric,
    'attorney_represented': binary,
    'fraud_score': numeric,
    'severity_score': numeric,
    'venue_score': numeric
  }

MODEL: GradientBoostingRegressor
  - Trained on 5+ years of closed claims
  - Target: total_incurred (reserves + payments)
  - Validated using time-based cross-validation
  - Updated quarterly

PREDICTION:
  ml_reserve = model.predict(claim_features)
  
  // Blend ML with tabular
  tabular_reserve = calculate_initial_reserve(claim)
  
  IF ml_model.confidence >= 0.80:
    final_reserve = (ml_reserve * 0.70) + (tabular_reserve * 0.30)
  ELSE:
    final_reserve = tabular_reserve
    FLAG for adjuster review
  
  RETURN ROUND_UP(final_reserve, 100)
```

---

## 14. Automated Payment Processing

### 14.1 Payment Processing Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                   PAYMENT PROCESSING ENGINE                   │
│                                                               │
│  ┌─────────────┐    ┌──────────────┐    ┌────────────────┐  │
│  │ Payment     │    │ Approval     │    │ Disbursement   │  │
│  │ Request     │───▶│ Workflow     │───▶│ Engine         │  │
│  │ Validator   │    │ Engine       │    │                │  │
│  └─────────────┘    └──────────────┘    └────────────────┘  │
│        │                   │                    │             │
│        ▼                   ▼                    ▼             │
│  ┌─────────────┐    ┌──────────────┐    ┌────────────────┐  │
│  │ Rules       │    │ Authority    │    │ Payment        │  │
│  │ Check       │    │ Matrix      │    │ Gateway        │  │
│  │ - Amount    │    │ - Level 1   │    │ - Check Print  │  │
│  │ - Payee     │    │ - Level 2   │    │ - ACH/EFT      │  │
│  │ - Duplicate │    │ - Level 3   │    │ - Virtual Card │  │
│  │ - Limit     │    │ - Level 4   │    │ - Wire         │  │
│  └─────────────┘    └──────────────┘    └────────────────┘  │
│                                                │              │
│                                                ▼              │
│                                         ┌────────────────┐   │
│                                         │ Financial      │   │
│                                         │ Posting        │   │
│                                         │ (GL + SAP)     │   │
│                                         └────────────────┘   │
│                                                               │
└─────────────────────────────────────────────────────────────┘
```

### 14.2 Payment Authority Matrix

| Role | Auto PD | Auto BI | Property | WC Med | WC Indemnity | GL |
|------|---------|---------|----------|--------|-------------|-----|
| **STP Engine** | $5,000 | $0 | $10,000 | $5,000 | $0 | $0 |
| **Adjuster I** | $10,000 | $15,000 | $25,000 | $10,000 | $10,000 | $15,000 |
| **Adjuster II** | $25,000 | $50,000 | $50,000 | $25,000 | $25,000 | $50,000 |
| **Sr. Adjuster** | $50,000 | $100,000 | $100,000 | $50,000 | $50,000 | $100,000 |
| **Supervisor** | $100,000 | $250,000 | $250,000 | $100,000 | $100,000 | $250,000 |
| **Manager** | $250,000 | $500,000 | $500,000 | $250,000 | $250,000 | $500,000 |
| **Director** | $500,000 | $1,000,000 | $1,000,000 | $500,000 | $500,000 | $1,000,000 |
| **VP Claims** | Unlimited | Unlimited | Unlimited | Unlimited | Unlimited | Unlimited |

### 14.3 Payment Approval Workflow

```
FUNCTION process_payment_request(payment_request):

    // Step 1: Validate payment request
    validation = validate_payment(payment_request)
    IF NOT validation.is_valid:
        RETURN PaymentResult(status='REJECTED', reason=validation.errors)
    
    // Step 2: Check for duplicates
    IF is_duplicate_payment(payment_request):
        RETURN PaymentResult(status='REJECTED', reason='DUPLICATE_PAYMENT')
    
    // Step 3: Verify remaining coverage limit
    remaining = get_remaining_limit(payment_request.claim_id, payment_request.coverage)
    IF payment_request.amount > remaining:
        RETURN PaymentResult(status='REJECTED', reason='EXCEEDS_LIMIT')
    
    // Step 4: Determine approval authority
    required_authority = determine_authority_level(
        payment_request.amount,
        payment_request.lob,
        payment_request.payment_type
    )
    
    // Step 5: Check if STP-eligible
    IF payment_request.is_stp AND payment_request.amount <= stp_authority:
        approval_status = 'AUTO_APPROVED'
    ELSE:
        // Route to appropriate approver
        approver = find_approver(required_authority, payment_request.claim_handler)
        approval_status = 'PENDING_APPROVAL'
        create_approval_task(approver, payment_request)
    
    // Step 6: Determine payment method
    IF approval_status = 'AUTO_APPROVED':
        method = determine_payment_method(payment_request)
        disbursement = create_disbursement(payment_request, method)
        post_financial_transaction(disbursement)
        RETURN PaymentResult(status='PAID', disbursement_id=disbursement.id)
    
    RETURN PaymentResult(status='PENDING_APPROVAL', approver=approver)
```

### 14.4 Payment Method Selection

```
FUNCTION determine_payment_method(payment):
    
    IF payment.payee_type = 'VENDOR' AND payment.vendor.has_eft:
        RETURN 'EFT'
    
    IF payment.payee_type = 'INSURED':
        IF payment.amount < 1000 AND insured.has_zelle:
            RETURN 'INSTANT_PAY'
        ELIF payment.amount <= 10000 AND insured.has_eft:
            RETURN 'EFT'
        ELIF payment.amount <= 100000:
            RETURN 'CHECK'
        ELSE:
            RETURN 'WIRE'
    
    IF payment.payee_type = 'ATTORNEY':
        RETURN 'CHECK'  // Trust account requirements
    
    IF payment.payee_type = 'MEDICAL_PROVIDER':
        IF payment.provider.accepts_virtual_card:
            RETURN 'VIRTUAL_CARD'  // Carrier earns interchange
        ELIF payment.provider.has_eft:
            RETURN 'EFT'
        ELSE:
            RETURN 'CHECK'
    
    RETURN 'CHECK'  // Default fallback
```

---

## 15. Task Automation

### 15.1 Automated Diary Management

```
DIARY_AUTOMATION_RULES:

  DIARY-001: Initial Contact Diary
    TRIGGER: Claim created
    ACTION: Create diary for 24 hours
    TASK: "Contact insured/claimant within 24 hours of FNOL"
    AUTO_CLOSE: When contact activity logged
    ESCALATION: If not closed in 48 hours, escalate to supervisor

  DIARY-002: Coverage Decision Diary
    TRIGGER: Claim created, coverage investigation needed
    ACTION: Create diary for 5 business days
    TASK: "Complete coverage determination"
    AUTO_CLOSE: When coverage decision entered
    ESCALATION: If not closed in 10 days, alert manager

  DIARY-003: Reserve Review Diary
    TRIGGER: Claim open > 30 days
    ACTION: Create recurring diary every 30 days
    TASK: "Review and update reserves"
    AUTO_CLOSE: When reserve change logged or confirmed
    ESCALATION: If 3 consecutive missed reviews, alert supervisor

  DIARY-004: Settlement Follow-up Diary
    TRIGGER: Settlement offer sent
    ACTION: Create diary for 10 business days
    TASK: "Follow up on settlement offer response"
    AUTO_CLOSE: When response received
    ESCALATION: If no response in 20 days, trigger second attempt

  DIARY-005: Vendor Estimate Diary
    TRIGGER: Vendor assigned for inspection/estimate
    ACTION: Create diary for 3 business days
    TASK: "Vendor estimate expected"
    AUTO_CLOSE: When estimate received
    ESCALATION: If not received in 5 days, auto-reassign vendor

  DIARY-006: Document Request Diary
    TRIGGER: Document request sent to claimant
    ACTION: Create diary for 14 days
    TASK: "Requested documents due"
    AUTO_CLOSE: When documents received
    ESCALATION: If not received in 30 days, send reminder

  DIARY-007: State Filing Diary
    TRIGGER: State filing required
    ACTION: Create diary per state deadline
    TASK: "State filing due"
    AUTO_CLOSE: When filing confirmed
    ESCALATION: 2 days before deadline, escalate to supervisor

  DIARY-008: Litigation Response Diary
    TRIGGER: Suit filed notification received
    ACTION: Create diary per jurisdictional deadline
    TASK: "Litigation response due"
    AUTO_CLOSE: When response filed
    ESCALATION: Immediate escalation to litigation unit
```

### 15.2 Automated Correspondence

```
CORRESPONDENCE_AUTOMATION:

  CORR-001: Acknowledgment Letter
    TRIGGER: Claim created
    TIMING: Immediate (within 1 hour)
    TEMPLATE: ACK_LETTER_{LOB}_{STATE}
    DELIVERY: Email (preferred), postal if no email
    VARIABLES: claim_number, claimant_name, adjuster_name,
               adjuster_phone, adjuster_email, date_of_loss
    STATE_SPECIFIC: Yes (language varies by state)

  CORR-002: Document Request Letter
    TRIGGER: Document gap identified
    TIMING: Within 4 hours of identification
    TEMPLATE: DOC_REQUEST_{DOC_TYPE}
    DELIVERY: Email + postal
    VARIABLES: claim_number, claimant_name, missing_documents[],
               due_date, submission_methods

  CORR-003: Reservation of Rights Letter
    TRIGGER: Coverage question identified
    TIMING: Within 24 hours (state-mandated in many jurisdictions)
    TEMPLATE: ROR_LETTER_{STATE}_{ISSUE_TYPE}
    DELIVERY: Certified mail + email
    VARIABLES: claim_number, policy_number, coverage_issue,
               relevant_policy_language, investigation_notice
    REQUIRES_REVIEW: Yes (supervisor must approve)

  CORR-004: Coverage Denial Letter
    TRIGGER: Coverage denial decision entered
    TIMING: Within 48 hours of decision
    TEMPLATE: DENIAL_LETTER_{LOB}_{STATE}_{REASON}
    DELIVERY: Certified mail + email
    VARIABLES: claim_number, policy_number, denial_reason,
               policy_provisions, appeal_rights, DOI_contact
    REQUIRES_REVIEW: Yes (supervisor must approve)

  CORR-005: Payment Notification
    TRIGGER: Payment issued
    TIMING: Same day as payment
    TEMPLATE: PAYMENT_NOTICE_{PAYMENT_TYPE}
    DELIVERY: Email
    VARIABLES: claim_number, payment_amount, payment_method,
               payee_name, deductible_applied, explanation

  CORR-006: Claim Status Update
    TRIGGER: Status change or every 14 days (whichever first)
    TIMING: Within 4 hours of trigger
    TEMPLATE: STATUS_UPDATE_{LOB}
    DELIVERY: Email, SMS (if opted in), app push notification
    VARIABLES: claim_number, current_status, next_steps,
               expected_timeline, contact_info

  CORR-007: Closing Letter
    TRIGGER: Claim closed
    TIMING: Within 24 hours of closure
    TEMPLATE: CLOSING_LETTER_{LOB}_{DISPOSITION}
    DELIVERY: Email + postal
    VARIABLES: claim_number, total_paid, disposition,
               survey_link, reopen_instructions
```

---

## 16. Integration Automation

### 16.1 API Orchestration Architecture

```
┌─────────────────────────────────────────────────────────────────────┐
│                    API ORCHESTRATION LAYER                           │
│                                                                      │
│  ┌──────────────────────────────────────────────────────────────┐   │
│  │                    API Gateway (Kong/Apigee)                  │   │
│  │  - Rate limiting    - Authentication    - Routing             │   │
│  │  - Transformation   - Monitoring        - Circuit breaker     │   │
│  └──────────────────────────────┬───────────────────────────────┘   │
│                                  │                                    │
│  ┌──────────────────────────────▼───────────────────────────────┐   │
│  │                    Orchestration Engine                        │   │
│  │                    (Apache Camel / Spring Integration)         │   │
│  │                                                                │   │
│  │  ┌────────────┐  ┌────────────┐  ┌────────────┐              │   │
│  │  │ FNOL       │  │ Payment    │  │ Vendor     │              │   │
│  │  │ Orchestr.  │  │ Orchestr.  │  │ Orchestr.  │              │   │
│  │  └────────────┘  └────────────┘  └────────────┘              │   │
│  │                                                                │   │
│  │  ┌────────────┐  ┌────────────┐  ┌────────────┐              │   │
│  │  │ Document   │  │ Fraud      │  │ Reporting  │              │   │
│  │  │ Orchestr.  │  │ Orchestr.  │  │ Orchestr.  │              │   │
│  │  └────────────┘  └────────────┘  └────────────┘              │   │
│  └──────────────────────────────────────────────────────────────┘   │
│                                                                      │
│  ┌──────────────────────────────────────────────────────────────┐   │
│  │                    INTEGRATION ADAPTERS                        │   │
│  │                                                                │   │
│  │  ┌────────┐ ┌────────┐ ┌────────┐ ┌────────┐ ┌────────┐    │   │
│  │  │ Policy │ │ Billing│ │ Vendor │ │ ISO    │ │ State  │    │   │
│  │  │ Admin  │ │ System │ │ Portal │ │ Claim  │ │ Bureau │    │   │
│  │  │ API    │ │ API    │ │ API    │ │ Search │ │ API    │    │   │
│  │  └────────┘ └────────┘ └────────┘ └────────┘ └────────┘    │   │
│  │                                                                │   │
│  │  ┌────────┐ ┌────────┐ ┌────────┐ ┌────────┐ ┌────────┐    │   │
│  │  │ CCC    │ │ Weather│ │ Geo-   │ │ Credit │ │ DMV    │    │   │
│  │  │ ONE    │ │ API    │ │ coding │ │ Bureau │ │ API    │    │   │
│  │  └────────┘ └────────┘ └────────┘ └────────┘ └────────┘    │   │
│  └──────────────────────────────────────────────────────────────┘   │
│                                                                      │
└─────────────────────────────────────────────────────────────────────┘
```

### 16.2 Event-Driven Architecture

```
CLAIM EVENTS → KAFKA TOPICS → CONSUMER SERVICES

Topic: claims.fnol.created
  Consumers:
    - Policy Verification Service
    - Fraud Scoring Service
    - STP Eligibility Service
    - Document Request Service
    - ISO ClaimSearch Service
    - Notification Service

Topic: claims.coverage.determined
  Consumers:
    - Reserve Setting Service
    - STP Pipeline Service
    - Correspondence Service
    - Subrogation Identification Service

Topic: claims.payment.requested
  Consumers:
    - Payment Validation Service
    - Payment Approval Service
    - 1099 Tracking Service
    - Financial Posting Service

Topic: claims.payment.issued
  Consumers:
    - Notification Service
    - Reserve Update Service
    - Reinsurance Reporting Service
    - GL Posting Service

Topic: claims.status.changed
  Consumers:
    - Notification Service
    - Diary Management Service
    - Reporting Service
    - Analytics Service

Topic: claims.document.received
  Consumers:
    - IDP Classification Service
    - IDP Extraction Service
    - Document Indexing Service
    - Workflow Trigger Service

Topic: claims.fraud.scored
  Consumers:
    - STP Eligibility Service
    - SIU Referral Service
    - Adjuster Alert Service
    - Analytics Service
```

### 16.3 Message Schemas

```json
{
  "$schema": "claims.fnol.created.v2",
  "event_id": "evt-12345-abcde",
  "event_type": "claims.fnol.created",
  "event_timestamp": "2024-03-15T14:30:00Z",
  "correlation_id": "corr-67890",
  "source": "fnol-service",
  "payload": {
    "claim_id": "CLM-2024-001234",
    "claim_number": "PA-2024-001234",
    "policy_id": "POL-12345678",
    "lob": "PERSONAL_AUTO",
    "loss_type": "COLLISION",
    "date_of_loss": "2024-03-14",
    "date_reported": "2024-03-15",
    "loss_state": "CA",
    "loss_description": "Rear-ended at intersection",
    "claimed_amount": 3500.00,
    "claimant": {
      "claimant_id": "CLT-001",
      "type": "INSURED",
      "name": "John Smith",
      "phone": "555-123-4567",
      "email": "john.smith@email.com"
    },
    "vehicle": {
      "vin": "1HGBH41JXMN109186",
      "year": 2021,
      "make": "Honda",
      "model": "Civic",
      "damage_area": "REAR"
    },
    "fnol_channel": "MOBILE_APP",
    "reporter": "INSURED",
    "photos_submitted": true,
    "photo_count": 4
  }
}
```

---

## 17. Automation Metrics & KPIs

### 17.1 Core Automation Metrics

| Metric | Definition | Formula | Target |
|--------|-----------|---------|--------|
| **Touchless Rate** | % of claims processed without human touch | (STP claims / total claims) × 100 | 35–60% |
| **STP Success Rate** | % of STP-eligible claims that complete STP | (STP completed / STP eligible) × 100 | >90% |
| **STP Fallout Rate** | % of STP-eligible claims that fall out | (STP fallout / STP eligible) × 100 | <10% |
| **Cycle Time** | Average days from FNOL to closure | Sum(close_date - FNOL_date) / count | Varies by LOB |
| **Cost Per Claim** | Average expense per claim | Total LAE / total claims | $100–$350 |
| **Accuracy Rate** | % of automated decisions matching expert | (correct decisions / total decisions) × 100 | >95% |
| **Auto-Reserve Accuracy** | Variance of auto-reserve vs final incurred | (auto_reserve - final) / final × 100 | <15% |
| **Document Processing Rate** | % of documents auto-classified/extracted | (auto-processed / total docs) × 100 | >80% |
| **RPA Bot Utilization** | % of time bots are actively processing | (active_time / available_time) × 100 | 60–80% |
| **Rule Hit Rate** | % of rules that trigger on claims | (triggered rules / total rules) × 100 | Varies |
| **Exception Rate** | % of claims requiring manual override | (overrides / total decisions) × 100 | <5% |
| **Customer Satisfaction** | NPS or CSAT for automated claims | Survey results | NPS > 50 |

### 17.2 Automation Dashboard Design

```
┌─────────────────────────────────────────────────────────────────────┐
│                    CLAIMS AUTOMATION DASHBOARD                       │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  ┌──────────────────┐  ┌──────────────────┐  ┌──────────────────┐  │
│  │ TOUCHLESS RATE   │  │ AVG CYCLE TIME   │  │ COST PER CLAIM   │  │
│  │                  │  │                  │  │                  │  │
│  │     42.3%        │  │     4.2 days     │  │     $187         │  │
│  │   ▲ +3.1% MoM   │  │   ▼ -1.3d MoM   │  │   ▼ -$23 MoM    │  │
│  └──────────────────┘  └──────────────────┘  └──────────────────┘  │
│                                                                      │
│  ┌──────────────────┐  ┌──────────────────┐  ┌──────────────────┐  │
│  │ STP SUCCESS RATE │  │ ACCURACY RATE    │  │ CUST SAT (NPS)   │  │
│  │                  │  │                  │  │                  │  │
│  │     93.7%        │  │     96.2%        │  │     +52          │  │
│  │   ▲ +0.5% MoM   │  │   ▲ +0.3% MoM   │  │   ▲ +4 MoM      │  │
│  └──────────────────┘  └──────────────────┘  └──────────────────┘  │
│                                                                      │
│  ┌─────────────────────────────────────────────────────────────┐    │
│  │ TOUCHLESS RATE BY LOB                                        │    │
│  │                                                               │    │
│  │ Auto Glass    ████████████████████████████░░  85%             │    │
│  │ Auto Tow      ████████████████████████████░░  82%             │    │
│  │ Auto Rental   ████████████████████████░░░░░░  72%             │    │
│  │ Auto PD       ████████████████░░░░░░░░░░░░░░  45%             │    │
│  │ Property      ██████████████░░░░░░░░░░░░░░░░  38%             │    │
│  │ WC Med-Only   ████████████░░░░░░░░░░░░░░░░░░  32%             │    │
│  │ Auto BI       █████░░░░░░░░░░░░░░░░░░░░░░░░░  12%             │    │
│  │ GL            ███░░░░░░░░░░░░░░░░░░░░░░░░░░░   5%             │    │
│  └─────────────────────────────────────────────────────────────┘    │
│                                                                      │
│  ┌──────────────────────────────┐ ┌────────────────────────────┐    │
│  │ STP FALLOUT REASONS          │ │ TOP AUTOMATION ERRORS      │    │
│  │                              │ │                            │    │
│  │ Fraud Score      28%  ████▓  │ │ API Timeout       22%     │    │
│  │ Amount Exceed    22%  ███▓   │ │ Data Quality      18%     │    │
│  │ Coverage Issue   18%  ███    │ │ Rule Conflict     15%     │    │
│  │ Multi-Vehicle    12%  ██     │ │ Doc Processing    14%     │    │
│  │ BI Involved      10%  ██    │ │ Payment Error     12%     │    │
│  │ Missing Docs      6%  █     │ │ Coverage API       9%     │    │
│  │ Other             4%  █     │ │ Other             10%     │    │
│  └──────────────────────────────┘ └────────────────────────────┘    │
│                                                                      │
└─────────────────────────────────────────────────────────────────────┘
```

---

## 18. Technology Stack for Claims Automation

### 18.1 Reference Architecture Stack

| Layer | Technology Options | Recommended |
|-------|-------------------|-------------|
| **Frontend** | React, Angular, Vue.js | React + TypeScript |
| **API Gateway** | Kong, Apigee, AWS API Gateway | Kong Enterprise |
| **Microservices** | Spring Boot, .NET Core, Node.js | Spring Boot (Java 17+) |
| **Rules Engine** | Drools, Easy Rules, custom | Drools/Kogito |
| **BPM/Workflow** | Camunda, Temporal, Step Functions | Camunda Platform 8 |
| **Event Streaming** | Apache Kafka, Pulsar, Kinesis | Apache Kafka (Confluent) |
| **Message Queue** | RabbitMQ, ActiveMQ, SQS | RabbitMQ |
| **Database (OLTP)** | PostgreSQL, Oracle, SQL Server | PostgreSQL 15+ |
| **Database (Document)** | MongoDB, DynamoDB | MongoDB |
| **Cache** | Redis, Hazelcast | Redis Cluster |
| **Search** | Elasticsearch, OpenSearch | Elasticsearch |
| **Object Storage** | S3, GCS, Azure Blob | S3 compatible |
| **ML Platform** | SageMaker, Vertex AI, MLflow | SageMaker + MLflow |
| **IDP** | Textract, Document AI, ABBYY | AWS Textract + custom |
| **RPA** | UiPath, Automation Anywhere, Blue Prism | UiPath |
| **Monitoring** | Datadog, Prometheus + Grafana | Datadog |
| **CI/CD** | Jenkins, GitHub Actions, GitLab CI | GitHub Actions |
| **Container Orchestration** | Kubernetes, ECS | Amazon EKS |
| **Service Mesh** | Istio, Linkerd | Istio |

### 18.2 Infrastructure Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                         AWS CLOUD                                │
│                                                                  │
│  ┌────────────────────────────────────────────────────────────┐ │
│  │                     VPC (Claims Platform)                   │ │
│  │                                                              │ │
│  │  ┌──────────────────────┐  ┌──────────────────────────┐    │ │
│  │  │   Public Subnets      │  │   Private Subnets         │    │ │
│  │  │                       │  │                            │    │ │
│  │  │  ┌─────────────────┐ │  │  ┌──────────────────────┐ │    │ │
│  │  │  │ ALB (Internet)  │ │  │  │ EKS Cluster          │ │    │ │
│  │  │  │ WAF             │ │  │  │ - Claims Services    │ │    │ │
│  │  │  └─────────────────┘ │  │  │ - Rules Engine       │ │    │ │
│  │  │                       │  │  │ - BPM Engine         │ │    │ │
│  │  │  ┌─────────────────┐ │  │  │ - IDP Services       │ │    │ │
│  │  │  │ NAT Gateway     │ │  │  │ - Payment Services   │ │    │ │
│  │  │  └─────────────────┘ │  │  └──────────────────────┘ │    │ │
│  │  └──────────────────────┘  │                            │    │ │
│  │                             │  ┌──────────────────────┐ │    │ │
│  │                             │  │ RDS PostgreSQL       │ │    │ │
│  │                             │  │ (Multi-AZ)           │ │    │ │
│  │                             │  └──────────────────────┘ │    │ │
│  │                             │                            │    │ │
│  │                             │  ┌──────────────────────┐ │    │ │
│  │                             │  │ Amazon MSK (Kafka)   │ │    │ │
│  │                             │  └──────────────────────┘ │    │ │
│  │                             │                            │    │ │
│  │                             │  ┌──────────────────────┐ │    │ │
│  │                             │  │ ElastiCache (Redis)  │ │    │ │
│  │                             │  └──────────────────────┘ │    │ │
│  │                             └────────────────────────────┘    │ │
│  └────────────────────────────────────────────────────────────┘ │
│                                                                  │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────────────┐  │
│  │ S3 (Docs)    │  │ SageMaker    │  │ CloudWatch/Datadog   │  │
│  └──────────────┘  └──────────────┘  └──────────────────────┘  │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

## 19. Microservices Architecture

### 19.1 Claims Automation Microservices

```
┌─────────────────────────────────────────────────────────────────┐
│                    CLAIMS AUTOMATION SERVICES                     │
│                                                                   │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐             │
│  │ FNOL        │  │ Policy      │  │ Coverage    │             │
│  │ Service     │  │ Verification│  │ Decision    │             │
│  │             │  │ Service     │  │ Service     │             │
│  │ - Create    │  │ - Status    │  │ - Rules     │             │
│  │ - Validate  │  │ - Coverage  │  │ - Exclusions│             │
│  │ - Enrich    │  │ - Limits    │  │ - Limits    │             │
│  └─────────────┘  └─────────────┘  └─────────────┘             │
│                                                                   │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐             │
│  │ STP         │  │ Fraud       │  │ Reserve     │             │
│  │ Orchestrator│  │ Scoring     │  │ Service     │             │
│  │             │  │ Service     │  │             │             │
│  │ - Eligibil. │  │ - Rules     │  │ - Calculate │             │
│  │ - Pipeline  │  │ - ML Model  │  │ - Update    │             │
│  │ - Fallout   │  │ - SNA       │  │ - Audit     │             │
│  └─────────────┘  └─────────────┘  └─────────────┘             │
│                                                                   │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐             │
│  │ Payment     │  │ Document    │  │ Notification│             │
│  │ Service     │  │ Processing  │  │ Service     │             │
│  │             │  │ Service     │  │             │             │
│  │ - Validate  │  │ - Classify  │  │ - Email     │             │
│  │ - Approve   │  │ - Extract   │  │ - SMS       │             │
│  │ - Disburse  │  │ - Index     │  │ - Push      │             │
│  └─────────────┘  └─────────────┘  └─────────────┘             │
│                                                                   │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐             │
│  │ Vendor      │  │ Diary       │  │ Correspond. │             │
│  │ Management  │  │ Service     │  │ Service     │             │
│  │ Service     │  │             │  │             │             │
│  │ - Assign    │  │ - Create    │  │ - Template  │             │
│  │ - Invoice   │  │ - Escalate  │  │ - Generate  │             │
│  │ - Rate      │  │ - Auto-close│  │ - Deliver   │             │
│  └─────────────┘  └─────────────┘  └─────────────┘             │
│                                                                   │
└─────────────────────────────────────────────────────────────────┘
```

### 19.2 Service Communication Patterns

```
SYNCHRONOUS (REST/gRPC):
  - Policy Verification (real-time lookup required)
  - Coverage Decision (blocking for STP pipeline)
  - Payment Validation (must confirm before disbursement)
  - Fraud Score Retrieval (needed for STP gateway)

ASYNCHRONOUS (Kafka Events):
  - FNOL Creation → triggers multiple downstream services
  - Document Receipt → triggers IDP pipeline
  - Payment Issued → triggers notifications, GL posting
  - Status Change → triggers correspondence, diary updates
  - Reserve Change → triggers reinsurance, reporting

CHOREOGRAPHY (Event-Driven):
  - Each service publishes domain events
  - Other services subscribe to events they care about
  - No central orchestrator for loosely coupled flows

ORCHESTRATION (Workflow Engine):
  - STP Pipeline → Camunda orchestrates step-by-step flow
  - Payment Approval → Camunda manages approval routing
  - Investigation → Camunda manages complex case lifecycle
```

### 19.3 Service Contract Example

```yaml
openapi: 3.0.3
info:
  title: STP Eligibility Service API
  version: 1.0.0
  description: Evaluates claim STP eligibility

paths:
  /api/v1/stp/evaluate:
    post:
      operationId: evaluateSTPEligibility
      summary: Evaluate a claim for STP eligibility
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/STPEvaluationRequest'
      responses:
        '200':
          description: STP evaluation result
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/STPEvaluationResponse'
        '400':
          description: Invalid request
        '500':
          description: Internal server error

components:
  schemas:
    STPEvaluationRequest:
      type: object
      required: [claimId, policyId, lob, claimType, dateOfLoss, claimedAmount]
      properties:
        claimId:
          type: string
          example: "CLM-2024-001234"
        policyId:
          type: string
          example: "POL-12345678"
        lob:
          type: string
          enum: [PERSONAL_AUTO, COMMERCIAL_AUTO, HOMEOWNERS, WORKERS_COMP, GENERAL_LIABILITY]
        claimType:
          type: string
          example: "COLLISION"
        coverageType:
          type: string
          example: "COLLISION"
        dateOfLoss:
          type: string
          format: date
        claimedAmount:
          type: number
          format: decimal
        claimantCount:
          type: integer
        hasBodilyInjury:
          type: boolean
        hasLitigationIndicator:
          type: boolean
        fraudScore:
          type: number
          format: decimal

    STPEvaluationResponse:
      type: object
      properties:
        claimId:
          type: string
        stpEligible:
          type: boolean
        stpScore:
          type: number
        evaluationTimestamp:
          type: string
          format: date-time
        rulesEvaluated:
          type: integer
        rulesPassed:
          type: integer
        rulesFailed:
          type: integer
        falloutReasons:
          type: array
          items:
            $ref: '#/components/schemas/FalloutReason'
        processingTimeMs:
          type: integer

    FalloutReason:
      type: object
      properties:
        ruleId:
          type: string
        ruleName:
          type: string
        reason:
          type: string
        severity:
          type: string
          enum: [BLOCKING, WARNING, INFO]
```

---

## 20. Event-Driven Automation with Kafka

### 20.1 Kafka Topic Design

```
TOPIC NAMING CONVENTION:
  {domain}.{entity}.{action}
  
  Example: claims.fnol.created

TOPIC CONFIGURATION:
  claims.fnol.created:
    partitions: 12
    replication-factor: 3
    retention.ms: 604800000  (7 days)
    cleanup.policy: delete
    key: claim_id
    
  claims.coverage.determined:
    partitions: 6
    replication-factor: 3
    retention.ms: 604800000
    key: claim_id
    
  claims.stp.evaluated:
    partitions: 6
    replication-factor: 3
    retention.ms: 604800000
    key: claim_id
    
  claims.payment.requested:
    partitions: 12
    replication-factor: 3
    retention.ms: 2592000000  (30 days)
    key: claim_id
    
  claims.payment.issued:
    partitions: 12
    replication-factor: 3
    retention.ms: 2592000000
    key: claim_id

  claims.document.received:
    partitions: 12
    replication-factor: 3
    retention.ms: 604800000
    key: claim_id

  claims.fraud.scored:
    partitions: 6
    replication-factor: 3
    retention.ms: 604800000
    key: claim_id

  claims.reserve.changed:
    partitions: 6
    replication-factor: 3
    retention.ms: 2592000000
    key: claim_id

  claims.status.changed:
    partitions: 6
    replication-factor: 3
    retention.ms: 604800000
    key: claim_id

CONSUMER GROUP NAMING:
  {service-name}-{purpose}
  
  Example: stp-service-eligibility-evaluator
           fraud-service-scoring-consumer
           notification-service-status-consumer
```

### 20.2 Event Processing Flow

```
FNOL Created Event Flow:

  Producer: FNOL Service
       │
       ▼
  [claims.fnol.created]  ──────────────────────────────────────────┐
       │                                                            │
       ├──▶ Consumer: Policy Verification Service                   │
       │       │                                                    │
       │       ├──▶ Verify policy (sync call to Policy Admin)       │
       │       └──▶ Publish: [claims.coverage.determined]           │
       │                                                            │
       ├──▶ Consumer: Fraud Scoring Service                         │
       │       │                                                    │
       │       ├──▶ Run fraud rules + ML model                     │
       │       └──▶ Publish: [claims.fraud.scored]                  │
       │                                                            │
       ├──▶ Consumer: ISO ClaimSearch Service                       │
       │       │                                                    │
       │       ├──▶ Query ISO ClaimSearch                           │
       │       └──▶ Publish: [claims.iso.searched]                  │
       │                                                            │
       ├──▶ Consumer: Notification Service                          │
       │       │                                                    │
       │       └──▶ Send acknowledgment to policyholder             │
       │                                                            │
       └──▶ Consumer: Document Request Service                      │
               │                                                    │
               └──▶ Identify and request missing documents          │
                                                                    │
  [claims.coverage.determined] + [claims.fraud.scored]              │
       │                                                            │
       └──▶ Consumer: STP Eligibility Service (joins both events)   │
               │                                                    │
               ├──▶ Evaluate STP eligibility                        │
               └──▶ Publish: [claims.stp.evaluated]                 │
                       │                                            │
                       ├── IF STP_ELIGIBLE:                         │
                       │    └──▶ Trigger STP Pipeline               │
                       │                                            │
                       └── IF NOT_ELIGIBLE:                         │
                            └──▶ Route to manual queue              │
```

### 20.3 Event Joining Pattern

```java
// Kafka Streams topology for joining coverage + fraud events
StreamsBuilder builder = new StreamsBuilder();

KStream<String, CoverageDeterminedEvent> coverageStream =
    builder.stream("claims.coverage.determined");

KStream<String, FraudScoredEvent> fraudStream =
    builder.stream("claims.fraud.scored");

KStream<String, STPEligibilityInput> joined = coverageStream.join(
    fraudStream,
    (coverage, fraud) -> new STPEligibilityInput(
        coverage.getClaimId(),
        coverage.isCovered(),
        coverage.getDeductible(),
        coverage.getCoverageLimit(),
        fraud.getFraudScore(),
        fraud.getFraudFlags()
    ),
    JoinWindows.ofTimeDifferenceWithNoGrace(Duration.ofMinutes(5)),
    StreamJoined.with(
        Serdes.String(),
        coverageSerde,
        fraudSerde
    )
);

joined.mapValues(input -> stpEligibilityService.evaluate(input))
      .to("claims.stp.evaluated");
```

---

## 21. Sample Automation Rules in Pseudocode

### 21.1 STP Eligibility Rules (Rules 1–15)

```
RULE STP-001: "Policy Must Be Active"
  WHEN claim.policy.status != 'ACTIVE'
  THEN REJECT(reason="Policy not active", blocking=true)

RULE STP-002: "Policy Must Cover Date of Loss"
  WHEN claim.dateOfLoss < claim.policy.effectiveDate
    OR claim.dateOfLoss > claim.policy.expirationDate
  THEN REJECT(reason="DOL outside policy period", blocking=true)

RULE STP-003: "Premium Must Be Current"
  WHEN claim.policy.premiumBalance > 0
    AND claim.policy.daysPastDue > claim.policy.gracePeriodDays
  THEN REJECT(reason="Premium past due beyond grace", blocking=true)

RULE STP-004: "Claim Type Must Be STP-Eligible"
  WHEN claim.claimType NOT IN STP_ELIGIBLE_TYPES[claim.lob]
  THEN REJECT(reason="Claim type not STP eligible", blocking=true)

RULE STP-005: "Amount Below STP Threshold"
  WHEN claim.claimedAmount > STP_THRESHOLD[claim.lob][claim.coverageType]
  THEN REJECT(reason="Amount exceeds STP threshold", blocking=true)

RULE STP-006: "Maximum Claimant Count"
  WHEN claim.claimantCount > MAX_CLAIMANTS[claim.lob]
  THEN REJECT(reason="Too many claimants for STP", blocking=true)

RULE STP-007: "No Severe Bodily Injury"
  WHEN claim.hasBodilyInjury = true
    AND claim.injurySeverity IN ('SEVERE', 'CATASTROPHIC', 'FATAL')
  THEN REJECT(reason="Severe injury requires manual handling", blocking=true)

RULE STP-008: "No Litigation Indicators"
  WHEN claim.hasAttorney = true OR claim.hasLawsuit = true
  THEN REJECT(reason="Litigation involvement", blocking=true)

RULE STP-009: "Fraud Score Below Threshold"
  WHEN claim.fraudScore > FRAUD_THRESHOLD[claim.lob]
  THEN REJECT(reason="Fraud score too high for STP", blocking=true)

RULE STP-010: "No Regulatory Hold"
  WHEN claim.hasRegulatoryHold = true
  THEN REJECT(reason="Regulatory hold prevents STP", blocking=true)

RULE STP-011: "Document Completeness"
  WHEN claim.documentCompletenessScore < MIN_DOC_SCORE[claim.lob]
  THEN REJECT(reason="Insufficient documentation", blocking=false)

RULE STP-012: "Claimant Identity Verified"
  WHEN claim.claimant.identityVerified = false
  THEN REJECT(reason="Claimant identity not verified", blocking=true)

RULE STP-013: "No Overlapping Open Claims"
  WHEN EXISTS(openClaim WHERE openClaim.policyId = claim.policyId
    AND openClaim.claimId != claim.claimId
    AND ABS(openClaim.dateOfLoss - claim.dateOfLoss) < 7)
  THEN REJECT(reason="Overlapping open claim exists", blocking=false)

RULE STP-014: "Vehicle/Property on Policy"
  WHEN claim.lob = 'AUTO'
    AND claim.vehicle.vin NOT IN claim.policy.scheduledVehicles
  THEN REJECT(reason="Vehicle not scheduled on policy", blocking=true)

RULE STP-015: "Within STP Operating Hours"
  WHEN CURRENT_TIME NOT BETWEEN STP_START_TIME AND STP_END_TIME
    AND claim.lob NOT IN ALWAYS_STP_LOBS
  THEN HOLD(reason="Outside STP operating hours", retry_at=NEXT_STP_START)
```

### 21.2 Coverage Rules (Rules 16–30)

```
RULE COV-016: "Comprehensive Coverage Active for Comp Claim"
  WHEN claim.coverageType = 'COMPREHENSIVE'
    AND NOT EXISTS(coverage WHERE coverage.type = 'COMPREHENSIVE'
      AND coverage.status = 'ACTIVE' ON claim.policy)
  THEN DENY_COVERAGE(reason="No comprehensive coverage")

RULE COV-017: "Collision Coverage Active for Collision Claim"
  WHEN claim.coverageType = 'COLLISION'
    AND NOT EXISTS(coverage WHERE coverage.type = 'COLLISION'
      AND coverage.status = 'ACTIVE' ON claim.policy)
  THEN DENY_COVERAGE(reason="No collision coverage")

RULE COV-018: "Deductible Calculation"
  WHEN coverage = GET_COVERAGE(claim.policy, claim.coverageType)
  THEN SET claim.applicableDeductible = coverage.deductible

RULE COV-019: "Glass Deductible Waiver"
  WHEN claim.coverageType = 'COMPREHENSIVE'
    AND claim.damageType = 'GLASS'
    AND claim.lossState IN GLASS_DEDUCTIBLE_WAIVER_STATES
  THEN SET claim.applicableDeductible = 0

RULE COV-020: "Coverage Limit Check"
  WHEN claim.claimedAmount > GET_COVERAGE_LIMIT(claim.policy, claim.coverageType)
  THEN SET claim.paymentCappedAtLimit = true
    AND SET claim.maxPayable = GET_COVERAGE_LIMIT(claim.policy, claim.coverageType)

RULE COV-021: "Named Driver Exclusion"
  WHEN claim.lob = 'AUTO'
    AND claim.driver.driverId IN claim.policy.excludedDrivers
  THEN DENY_COVERAGE(reason="Named driver exclusion applies")

RULE COV-022: "Permissive Use Check"
  WHEN claim.lob = 'AUTO'
    AND claim.driver.driverId NOT IN claim.policy.namedDrivers
    AND claim.driver.isPermissiveUser = false
  THEN REFER_TO_ADJUSTER(reason="Permissive use question")

RULE COV-023: "Business Use Exclusion"
  WHEN claim.lob = 'PERSONAL_AUTO'
    AND claim.vehicleUseAtTimeOfLoss = 'BUSINESS'
    AND NOT claim.policy.hasBusinessUseEndorsement
  THEN REFER_TO_ADJUSTER(reason="Business use exclusion question")

RULE COV-024: "Intentional Act Exclusion"
  WHEN claim.causeOfLoss = 'INTENTIONAL_ACT'
  THEN DENY_COVERAGE(reason="Intentional act exclusion")

RULE COV-025: "Racing Exclusion"
  WHEN claim.lob = 'AUTO'
    AND claim.activityAtLoss IN ('RACING', 'SPEED_CONTEST', 'STUNT')
  THEN DENY_COVERAGE(reason="Racing/speed contest exclusion")

RULE COV-026: "Aggregate Limit Tracking"
  WHEN claim.coverageType HAS aggregate_limit
    AND SUM(prior_payments) + claim.claimedAmount > aggregate_limit
  THEN SET claim.maxPayable = aggregate_limit - SUM(prior_payments)

RULE COV-027: "Endorsement Modification"
  WHEN EXISTS(endorsement ON claim.policy
    WHERE endorsement.modifiesCoverage = claim.coverageType)
  THEN APPLY_ENDORSEMENT(endorsement, claim)

RULE COV-028: "Coinsurance Penalty"
  WHEN claim.lob = 'PROPERTY'
    AND claim.policy.coinsurancePercentage > 0
    AND claim.policy.coverageAmount < 
        claim.property.replacementValue * claim.policy.coinsurancePercentage
  THEN APPLY_COINSURANCE_PENALTY(claim)

RULE COV-029: "Sublimit Application"
  WHEN EXISTS(sublimit ON claim.policy
    WHERE sublimit.appliesTo = claim.damageType)
  THEN SET claim.maxPayable = MIN(claim.maxPayable, sublimit.amount)

RULE COV-030: "Waiting Period Check (WC)"
  WHEN claim.lob = 'WORKERS_COMP'
    AND claim.daysDisabled < WAITING_PERIOD[claim.lossState]
    AND claim.paymentType = 'INDEMNITY'
  THEN HOLD_PAYMENT(reason="Within waiting period",
    release_at=claim.injuryDate + WAITING_PERIOD[claim.lossState])
```

### 21.3 Fraud Detection Rules (Rules 31–45)

```
RULE FRD-031: "New Policy Inception Fraud"
  WHEN DAYS_BETWEEN(claim.policy.inceptionDate, claim.dateOfLoss) < 30
  THEN ADD_FRAUD_POINTS(15, "Loss within 30 days of inception")

RULE FRD-032: "Coverage Increase Before Loss"
  WHEN EXISTS(endorsement ON claim.policy
    WHERE endorsement.type = 'COVERAGE_INCREASE'
    AND DAYS_BETWEEN(endorsement.effectiveDate, claim.dateOfLoss) < 90)
  THEN ADD_FRAUD_POINTS(20, "Coverage increase within 90 days of loss")

RULE FRD-033: "Multiple Claims Pattern"
  WHEN COUNT(claims WHERE claims.policyId = claim.policyId
    AND claims.dateOfLoss > TODAY - 365) >= 3
  THEN ADD_FRAUD_POINTS(15, "3+ claims in 12 months")

RULE FRD-034: "Weekend/Holiday Loss Pattern"
  WHEN DAY_OF_WEEK(claim.dateOfLoss) IN (FRIDAY, SATURDAY, SUNDAY)
    AND claim.lossType IN ('THEFT', 'VANDALISM', 'FIRE')
  THEN ADD_FRAUD_POINTS(5, "Weekend loss for suspicious peril")

RULE FRD-035: "Late Reporting"
  WHEN DAYS_BETWEEN(claim.dateOfLoss, claim.dateReported) > 30
  THEN ADD_FRAUD_POINTS(10, "Loss reported more than 30 days after DOL")

RULE FRD-036: "Address Mismatch"
  WHEN claim.claimant.address != claim.policy.address
    AND claim.claimant.addressChangeDate < claim.dateOfLoss
  THEN ADD_FRAUD_POINTS(8, "Claimant address differs from policy")

RULE FRD-037: "Prior Claim Same Type"
  WHEN EXISTS(priorClaim WHERE priorClaim.claimant = claim.claimant
    AND priorClaim.lossType = claim.lossType
    AND priorClaim.dateOfLoss > TODAY - 730)
  THEN ADD_FRAUD_POINTS(12, "Same loss type claim in prior 2 years")

RULE FRD-038: "Suspicious Provider"
  WHEN claim.serviceProvider IN FRAUD_WATCH_PROVIDERS
  THEN ADD_FRAUD_POINTS(20, "Provider on fraud watch list")

RULE FRD-039: "VIN Discrepancy"
  WHEN claim.vehicle.vin != claim.policy.vehicle.vin
    OR NOT VALID_VIN(claim.vehicle.vin)
  THEN ADD_FRAUD_POINTS(25, "VIN mismatch or invalid")

RULE FRD-040: "High Value Claim Low Value Vehicle"
  WHEN claim.claimedAmount > claim.vehicle.actualCashValue * 0.80
    AND claim.claimType != 'TOTAL_LOSS'
  THEN ADD_FRAUD_POINTS(10, "Claim amount near vehicle ACV")

RULE FRD-041: "ISO ClaimSearch Match"
  WHEN ISO_SEARCH_RESULTS.matchCount > 0
    AND ANY(ISO_SEARCH_RESULTS.matches.claimType = claim.claimType)
  THEN ADD_FRAUD_POINTS(8, "ISO ClaimSearch prior history match")

RULE FRD-042: "Inconsistent Damage Description"
  WHEN NLP_ANALYZE(claim.lossDescription).consistencyScore < 0.60
  THEN ADD_FRAUD_POINTS(15, "Damage description inconsistent with loss type")

RULE FRD-043: "Geographic Anomaly"
  WHEN DISTANCE(claim.lossLocation, claim.policy.garageLocation) > 200 miles
    AND claim.lossType NOT IN ('TRAVEL', 'VACATION')
  THEN ADD_FRAUD_POINTS(8, "Loss location far from garage/home")

RULE FRD-044: "Repeat Vendor Across Claimants"
  WHEN COUNT(DISTINCT claimants WHERE claims.vendor = claim.vendor
    AND claims.dateOfLoss > TODAY - 180) > 5
  THEN ADD_FRAUD_POINTS(12, "Vendor associated with multiple claimants")

RULE FRD-045: "Composite Fraud Score Threshold"
  WHEN claim.totalFraudPoints >= FRAUD_THRESHOLD_SIU_REFERRAL
  THEN REFER_TO_SIU(claim, claim.fraudFlags)
    AND SET claim.stpEligible = false
```

### 21.4 Payment Rules (Rules 46–55)

```
RULE PAY-046: "Net Payment Calculation"
  WHEN claim.adjudicationResult = 'APPROVED'
  THEN SET claim.paymentAmount = claim.approvedAmount - claim.applicableDeductible

RULE PAY-047: "Payment Cannot Exceed Limit"
  WHEN claim.paymentAmount > claim.coverageLimit
  THEN SET claim.paymentAmount = claim.coverageLimit

RULE PAY-048: "Lienholder on Payment"
  WHEN claim.lob = 'AUTO'
    AND claim.paymentAmount > 0
    AND EXISTS(lienholder ON claim.policy.vehicle)
  THEN ADD_PAYEE(lienholder, claim.payment)

RULE PAY-049: "Mortgagee on Payment (Property)"
  WHEN claim.lob IN ('HOMEOWNERS', 'COMMERCIAL_PROPERTY')
    AND claim.paymentAmount > MORTGAGEE_THRESHOLD
    AND EXISTS(mortgagee ON claim.policy)
  THEN ADD_PAYEE(mortgagee, claim.payment)

RULE PAY-050: "Vendor Direct Pay"
  WHEN claim.vendor IN DIRECT_PAY_VENDORS
    AND claim.vendor.directPayAuthorized = true
  THEN SET claim.payment.payee = claim.vendor
    AND SET claim.payment.method = 'EFT'

RULE PAY-051: "Replacement Cost Holdback"
  WHEN claim.policy.valuation = 'REPLACEMENT_COST'
    AND claim.paymentType = 'INITIAL'
  THEN SET claim.paymentAmount = claim.approvedAmount - claim.depreciation
    AND SET claim.holdbackAmount = claim.depreciation
    AND CREATE_DIARY("RC holdback: awaiting proof of repair", 180 days)

RULE PAY-052: "1099 Reporting Threshold"
  WHEN claim.paymentType = 'INDEMNITY'
    AND SUM(payments_to_payee_ytd) + claim.paymentAmount >= 600
  THEN FLAG_FOR_1099(claim.payment.payee)

RULE PAY-053: "State Tax on Payment"
  WHEN claim.lossState IN STATES_REQUIRING_TAX
    AND claim.paymentType = 'PROPERTY_DAMAGE'
  THEN ADD_TAX(claim.payment, TAX_RATE[claim.lossState])

RULE PAY-054: "Duplicate Payment Prevention"
  WHEN EXISTS(priorPayment WHERE priorPayment.claimId = claim.claimId
    AND priorPayment.payee = claim.payment.payee
    AND priorPayment.amount = claim.paymentAmount
    AND priorPayment.paymentDate > TODAY - 30)
  THEN REJECT_PAYMENT(reason="Potential duplicate payment")

RULE PAY-055: "EFT vs Check Determination"
  WHEN claim.paymentAmount < 10000 AND claim.payee.hasEFT = true
  THEN SET claim.payment.method = 'EFT'
  ELSE SET claim.payment.method = 'CHECK'
```

### 21.5 Reserve Rules (Rules 56–65)

```
RULE RSV-056: "Initial Reserve Minimum"
  WHEN NEW_CLAIM(claim) AND claim.initialReserve < MIN_RESERVE[claim.lob]
  THEN SET claim.initialReserve = MIN_RESERVE[claim.lob]

RULE RSV-057: "Reserve Cannot Exceed Limit"
  WHEN claim.reserveAmount > claim.coverageLimit
  THEN SET claim.reserveAmount = claim.coverageLimit

RULE RSV-058: "Reserve Stairstepping Detection"
  WHEN COUNT(reserve_increases WHERE claim_id = claim.claimId
    AND change_date > TODAY - 90) >= 3
    AND TOTAL(reserve_increases) / initial_reserve > 2.0
  THEN ALERT_SUPERVISOR(reason="Potential reserve stairstepping")

RULE RSV-059: "Auto-Reserve on Payment"
  WHEN claim.payment.issued = true
    AND claim.reserveAmount < claim.totalPaid + RESERVE_CUSHION
  THEN SET claim.reserveAmount = claim.totalPaid + RESERVE_CUSHION

RULE RSV-060: "Reserve Reduction on Closure"
  WHEN claim.status = 'CLOSED'
  THEN SET claim.reserveAmount = claim.totalPaid

RULE RSV-061: "ALAE Reserve Setting"
  WHEN claim.hasAssignedVendor = true OR claim.hasAttorney = true
  THEN SET claim.alaeReserve = ESTIMATE_ALAE(claim)

RULE RSV-062: "Total Loss Reserve"
  WHEN claim.lob = 'AUTO' AND claim.totalLossDetermined = true
  THEN SET claim.reserveAmount = claim.vehicle.actualCashValue
    + claim.totalLossExpenses - claim.salvageEstimate

RULE RSV-063: "Subrogation Reserve Offset"
  WHEN claim.subrogationPotential > 0
  THEN SET claim.netReserve = claim.reserveAmount - claim.subrogationEstimate

RULE RSV-064: "Catastrophe Event Reserve"
  WHEN claim.catastropheEvent = true
  THEN SET claim.reserveAmount = CAT_RESERVE_TABLE[claim.catEventId][claim.damageLevel]
    AND APPLY_FACTOR(CAT_SEVERITY_MULTIPLIER)

RULE RSV-065: "ML Reserve Override Confidence Check"
  WHEN claim.mlReserveConfidence < 0.70
  THEN USE claim.tabularReserve INSTEAD OF claim.mlReserve
    AND FLAG_FOR_REVIEW(reason="Low ML confidence")
```

---

## 22. ROI Calculation Models

### 22.1 Claims Automation ROI Framework

```
ROI CALCULATION:

  Total Investment (Year 1):
    Technology Platform License       = $2,000,000
    Implementation Services           = $3,000,000
    Infrastructure (Cloud)            = $500,000/year
    Training & Change Management      = $500,000
    Ongoing Maintenance (Year 1)      = $400,000
    ─────────────────────────────────────────────
    TOTAL YEAR 1 INVESTMENT           = $6,400,000

  Annual Benefits:

    1. Cycle Time Reduction
       Claims/year: 100,000
       Avg handling time saved: 2 hours/claim
       Adjuster hourly cost: $45
       Savings = 100,000 × 2 × $45 = $9,000,000

    2. Touchless Processing
       STP-eligible claims: 40,000 (40%)
       Touchless rate: 75% of eligible = 30,000
       Cost per manual claim: $350
       Cost per touchless claim: $50
       Savings = 30,000 × ($350 - $50) = $9,000,000

    3. Leakage Reduction
       Total claim payments: $500,000,000
       Leakage rate before: 8%
       Leakage rate after: 3%
       Savings = $500,000,000 × 5% = $25,000,000

    4. Fraud Detection Improvement
       Annual fraud loss before: $15,000,000
       Detection improvement: 25%
       Savings = $15,000,000 × 25% = $3,750,000

    5. Staffing Optimization
       Adjuster FTEs reduced: 15 (not layoffs; redeployed)
       Average fully loaded cost: $95,000
       Savings = 15 × $95,000 = $1,425,000

    ─────────────────────────────────────────────
    TOTAL ANNUAL BENEFIT                = $48,175,000
    
    NET BENEFIT YEAR 1 = $48,175,000 - $6,400,000 = $41,775,000
    
    ROI = (Net Benefit / Investment) × 100
        = ($41,775,000 / $6,400,000) × 100
        = 652%
    
    PAYBACK PERIOD = Investment / Monthly Benefit
                   = $6,400,000 / ($48,175,000/12)
                   = 1.6 months
```

### 22.2 Phased ROI Model

| Phase | Timeline | Investment | Annual Benefit | Cumulative ROI |
|-------|----------|-----------|---------------|----------------|
| Phase 1: STP (Glass/Tow/Rental) | 0–6 months | $2.0M | $4.5M | 125% |
| Phase 2: Auto PD STP | 6–12 months | $1.5M | $12.0M | 371% |
| Phase 3: Property STP | 12–18 months | $1.0M | $8.0M | 544% |
| Phase 4: AI/ML Enhancement | 18–24 months | $1.5M | $15.0M | 658% |
| Phase 5: WC/GL Automation | 24–36 months | $0.5M | $8.7M | 742% |

---

## 23. Change Management

### 23.1 Change Management Framework

```
┌─────────────────────────────────────────────────────────────────────┐
│                CLAIMS AUTOMATION CHANGE MANAGEMENT                   │
│                                                                      │
│  Phase 1: AWARENESS (Months 1-2)                                    │
│  ├─ Executive sponsorship and communication                         │
│  ├─ Town halls explaining vision and benefits                       │
│  ├─ Address fear of job loss directly                               │
│  ├─ Share industry success stories                                  │
│  └─ Establish change champion network                               │
│                                                                      │
│  Phase 2: UNDERSTANDING (Months 2-4)                                │
│  ├─ Detailed process impact assessments                             │
│  ├─ Role redefinition workshops                                     │
│  ├─ New skill identification (data analysis, exception handling)    │
│  ├─ Technology demos and sandboxes                                  │
│  └─ FAQ documentation and Q&A sessions                              │
│                                                                      │
│  Phase 3: ADOPTION (Months 4-8)                                     │
│  ├─ Hands-on training programs                                      │
│  ├─ Pilot group selection and execution                             │
│  ├─ Feedback loops and rapid iteration                              │
│  ├─ Success metrics tracking and sharing                            │
│  └─ Buddy system for technology adoption                            │
│                                                                      │
│  Phase 4: OPTIMIZATION (Months 8-12)                                │
│  ├─ Full rollout with support structure                             │
│  ├─ Performance monitoring and coaching                             │
│  ├─ Continuous improvement cycles                                   │
│  ├─ Advanced training for exception handling                        │
│  └─ Career path development for new roles                           │
│                                                                      │
│  Phase 5: REINFORCEMENT (Ongoing)                                   │
│  ├─ Regular performance reviews against new metrics                 │
│  ├─ Recognition and rewards for adoption                            │
│  ├─ Ongoing skill development                                      │
│  ├─ Community of practice for automation                            │
│  └─ Continuous feedback and enhancement                             │
│                                                                      │
└─────────────────────────────────────────────────────────────────────┘
```

### 23.2 Role Transformation

| Current Role | Evolved Role | Key Changes |
|-------------|-------------|-------------|
| Claim Adjuster (simple) | Automation Monitor / Exception Handler | Focus on STP fallout and complex cases |
| Claim Adjuster (complex) | Senior Claims Analyst | Higher complexity, decision authority |
| Claims Supervisor | Automation Performance Manager | Manage rules, metrics, optimization |
| Data Entry Clerk | Document Quality Analyst | IDP quality review, training data curation |
| Claims Manager | Claims Operations Director | Strategic automation roadmap |
| IT Support | Automation Engineer | Rules development, bot maintenance |

---

## 24. Automation Decision Matrix

### 24.1 Complete Decision Matrix by Claim Type

```
┌─────────────────────┬──────────┬──────────┬──────────┬──────────┬──────────┐
│ Claim Type          │ Full STP │ Assisted │ AI-      │ Manual + │ Manual   │
│                     │          │ STP      │ Assisted │ Auto     │ Only     │
├─────────────────────┼──────────┼──────────┼──────────┼──────────┼──────────┤
│ Auto Glass          │    ✓     │          │          │          │          │
│ Auto Tow/Roadside   │    ✓     │          │          │          │          │
│ Auto Rental          │    ✓     │          │          │          │          │
│ Auto PD (simple)     │    ✓     │          │          │          │          │
│ Auto PD (moderate)   │          │    ✓     │          │          │          │
│ Auto PD (complex)    │          │          │    ✓     │          │          │
│ Auto PD (total loss) │          │    ✓     │          │          │          │
│ Auto BI (minor)      │          │          │    ✓     │          │          │
│ Auto BI (moderate)   │          │          │          │    ✓     │          │
│ Auto BI (severe)     │          │          │          │          │    ✓     │
│ Auto BI (litigation) │          │          │          │          │    ✓     │
│ Property (minor)     │    ✓     │          │          │          │          │
│ Property (moderate)  │          │    ✓     │          │          │          │
│ Property (major)     │          │          │    ✓     │          │          │
│ Property (CAT)       │          │          │    ✓     │          │          │
│ WC Medical Only      │    ✓     │          │          │          │          │
│ WC Lost Time         │          │          │    ✓     │          │          │
│ WC Permanent Disab.  │          │          │          │          │    ✓     │
│ GL PD Only           │          │          │    ✓     │          │          │
│ GL BI                │          │          │          │    ✓     │          │
│ GL Litigation        │          │          │          │          │    ✓     │
│ Prof Liability       │          │          │          │          │    ✓     │
│ D&O                  │          │          │          │          │    ✓     │
│ Umbrella/Excess      │          │          │          │    ✓     │          │
└─────────────────────┴──────────┴──────────┴──────────┴──────────┴──────────┘

KEY:
  Full STP:      100% automated, no human touch
  Assisted STP:  Mostly automated, human spot-check at key points
  AI-Assisted:   AI provides recommendations, adjuster confirms
  Manual + Auto: Manual adjudication with automated tasks (diary, correspondence)
  Manual Only:   Full human handling (complex liability, litigation)
```

### 24.2 Automation Readiness by Dimension

| Dimension | Ease of Automation | Data Availability | Regulatory Sensitivity | Priority |
|-----------|-------------------|-------------------|----------------------|----------|
| FNOL Intake | High | High | Low | 1 |
| Document Processing | High | High | Low | 2 |
| Coverage Verification | High | High | Medium | 3 |
| Fraud Screening | Medium | Medium | Medium | 4 |
| Reserve Setting | Medium | High | Medium | 5 |
| Payment Processing | High | High | Medium | 6 |
| Correspondence | High | High | High | 7 |
| Diary Management | High | High | Low | 8 |
| Damage Assessment | Medium | Medium | Low | 9 |
| Liability Determination | Low | Medium | High | 10 |
| Settlement Negotiation | Low | Low | High | 11 |
| Litigation Management | Very Low | Low | Very High | 12 |

---

## Appendix A: Glossary

| Term | Definition |
|------|-----------|
| **STP** | Straight-Through Processing — end-to-end automation with no human touch |
| **FNOL** | First Notice of Loss — initial claim report |
| **BPM** | Business Process Management |
| **BRMS** | Business Rules Management System |
| **RPA** | Robotic Process Automation |
| **IDP** | Intelligent Document Processing |
| **OCR** | Optical Character Recognition |
| **ICR** | Intelligent Character Recognition |
| **DMN** | Decision Model and Notation |
| **BPMN** | Business Process Model and Notation |
| **ACV** | Actual Cash Value |
| **RC** | Replacement Cost |
| **LAE** | Loss Adjustment Expense |
| **ALAE** | Allocated Loss Adjustment Expense |
| **LOB** | Line of Business |
| **PD** | Physical/Property Damage |
| **BI** | Bodily Injury |
| **WC** | Workers' Compensation |
| **GL** | General Liability |
| **SIU** | Special Investigations Unit |
| **NPS** | Net Promoter Score |

## Appendix B: Reference Architecture Diagram (Complete)

```
┌──────────────────────────────────────────────────────────────────────────┐
│                    CLAIMS AUTOMATION PLATFORM                             │
│                                                                           │
│  ┌───────────────────────────────────────────────────────────────────┐   │
│  │                      PRESENTATION LAYER                           │   │
│  │  ┌─────────┐  ┌──────────┐  ┌──────────┐  ┌──────────────────┐  │   │
│  │  │ Web App │  │ Mobile   │  │ Agent    │  │ Partner Portal   │  │   │
│  │  │ (React) │  │ App      │  │ Desktop  │  │ (Vendor/Agent)   │  │   │
│  │  └─────────┘  └──────────┘  └──────────┘  └──────────────────┘  │   │
│  └───────────────────────────────────────────────────────────────────┘   │
│                                    │                                      │
│  ┌───────────────────────────────────────────────────────────────────┐   │
│  │                      API GATEWAY (Kong)                           │   │
│  └───────────────────────────────────────────────────────────────────┘   │
│                                    │                                      │
│  ┌───────────────────────────────────────────────────────────────────┐   │
│  │                    ORCHESTRATION LAYER                             │   │
│  │  ┌──────────────┐  ┌──────────────┐  ┌──────────────────────┐    │   │
│  │  │ BPM Engine   │  │ Rules Engine │  │ Event Orchestrator   │    │   │
│  │  │ (Camunda)    │  │ (Drools)     │  │ (Kafka Streams)      │    │   │
│  │  └──────────────┘  └──────────────┘  └──────────────────────┘    │   │
│  └───────────────────────────────────────────────────────────────────┘   │
│                                    │                                      │
│  ┌───────────────────────────────────────────────────────────────────┐   │
│  │                    MICROSERVICES LAYER                             │   │
│  │                                                                    │   │
│  │  ┌──────┐ ┌──────┐ ┌──────┐ ┌──────┐ ┌──────┐ ┌──────┐         │   │
│  │  │ FNOL │ │Cover.│ │Fraud │ │Reserv│ │Paymnt│ │ Doc  │         │   │
│  │  └──────┘ └──────┘ └──────┘ └──────┘ └──────┘ └──────┘         │   │
│  │  ┌──────┐ ┌──────┐ ┌──────┐ ┌──────┐ ┌──────┐ ┌──────┐         │   │
│  │  │Vendor│ │Diary │ │Corres│ │Notif.│ │Subrog│ │Report│         │   │
│  │  └──────┘ └──────┘ └──────┘ └──────┘ └──────┘ └──────┘         │   │
│  └───────────────────────────────────────────────────────────────────┘   │
│                                    │                                      │
│  ┌───────────────────────────────────────────────────────────────────┐   │
│  │                    AI/ML LAYER                                     │   │
│  │  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────────────┐    │   │
│  │  │ Computer │ │ NLP      │ │ Fraud ML │ │ Predictive       │    │   │
│  │  │ Vision   │ │ Engine   │ │ Models   │ │ Analytics        │    │   │
│  │  └──────────┘ └──────────┘ └──────────┘ └──────────────────┘    │   │
│  └───────────────────────────────────────────────────────────────────┘   │
│                                    │                                      │
│  ┌───────────────────────────────────────────────────────────────────┐   │
│  │                    DATA LAYER                                      │   │
│  │  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────────────┐    │   │
│  │  │PostgreSQL│ │MongoDB   │ │Redis     │ │Elasticsearch     │    │   │
│  │  │(Claims)  │ │(Docs)    │ │(Cache)   │ │(Search)          │    │   │
│  │  └──────────┘ └──────────┘ └──────────┘ └──────────────────┘    │   │
│  │  ┌──────────┐ ┌──────────┐ ┌──────────┐                         │   │
│  │  │S3 (Files)│ │Kafka     │ │Data Lake │                         │   │
│  │  │          │ │(Events)  │ │(Analytics)│                        │   │
│  │  └──────────┘ └──────────┘ └──────────┘                         │   │
│  └───────────────────────────────────────────────────────────────────┘   │
│                                    │                                      │
│  ┌───────────────────────────────────────────────────────────────────┐   │
│  │                    INTEGRATION LAYER                               │   │
│  │  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────────────┐    │   │
│  │  │ Policy   │ │ ISO      │ │ Vendors  │ │ State Bureaus    │    │   │
│  │  │ Admin    │ │ ClaimSrch│ │ (CCC etc)│ │ (Filing/Report)  │    │   │
│  │  └──────────┘ └──────────┘ └──────────┘ └──────────────────┘    │   │
│  └───────────────────────────────────────────────────────────────────┘   │
│                                                                           │
└──────────────────────────────────────────────────────────────────────────┘
```

---

*This document is part of the PnC Claims Encyclopedia. For related topics, see:*
- *Article 7: AI/ML in Claims Processing*
- *Article 8: Fraud Detection & SIU Operations*
- *Article 9: Subrogation & Recovery*
- *Article 10: Reserves & Financial Management*
