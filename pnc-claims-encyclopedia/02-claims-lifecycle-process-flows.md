# Claims Lifecycle: End-to-End Process Flows

> **Audience:** Solutions Architects designing and building Property & Casualty claims systems.
> **Version:** 1.0 | **Last Updated:** 2026-04-16

---

## Table of Contents

1. [High-Level Claims Lifecycle](#1-high-level-claims-lifecycle)
2. [Claim Status State Machine](#2-claim-status-state-machine)
3. [Feature Status State Machine](#3-feature-status-state-machine)
4. [Detailed Subprocess: FNOL & Claim Creation](#4-detailed-subprocess-fnol--claim-creation)
5. [Detailed Subprocess: Assignment & Triage](#5-detailed-subprocess-assignment--triage)
6. [Detailed Subprocess: Investigation](#6-detailed-subprocess-investigation)
7. [Detailed Subprocess: Coverage Verification](#7-detailed-subprocess-coverage-verification)
8. [Detailed Subprocess: Evaluation & Reserving](#8-detailed-subprocess-evaluation--reserving)
9. [Detailed Subprocess: Negotiation & Settlement](#9-detailed-subprocess-negotiation--settlement)
10. [Detailed Subprocess: Payment Processing](#10-detailed-subprocess-payment-processing)
11. [Detailed Subprocess: Claim Closure](#11-detailed-subprocess-claim-closure)
12. [Activity-Based Flows by Line of Business](#12-activity-based-flows-by-line-of-business)
13. [Parallel Processing Paths](#13-parallel-processing-paths)
14. [Reopening & Supplemental Claim Flows](#14-reopening--supplemental-claim-flows)
15. [Diary & Follow-Up Management](#15-diary--follow-up-management)
16. [Escalation Paths & Authority Levels](#16-escalation-paths--authority-levels)
17. [Batch Processing Flows](#17-batch-processing-flows)
18. [Exception Handling Processes](#18-exception-handling-processes)
19. [SLA Definitions & Measurements](#19-sla-definitions--measurements)
20. [BPMN-Style Process Descriptions](#20-bpmn-style-process-descriptions)

---

## 1. High-Level Claims Lifecycle

### 1.1 Lifecycle Overview

Every P&C claim, regardless of line of business, follows a common lifecycle pattern with eight major stages:

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                         CLAIMS LIFECYCLE                                     │
│                                                                             │
│  ┌──────┐   ┌──────────┐   ┌─────────────┐   ┌──────────┐   ┌──────────┐  │
│  │ FNOL │──►│ASSIGNMENT│──►│INVESTIGATION│──►│EVALUATION│──►│NEGOTIATION│  │
│  │      │   │ & TRIAGE │   │             │   │& RESERV. │   │          │  │
│  └──────┘   └──────────┘   └─────────────┘   └──────────┘   └────┬─────┘  │
│                                                                    │        │
│                                                                    ▼        │
│  ┌──────┐   ┌──────────┐   ┌─────────────┐                ┌──────────┐    │
│  │CLOSE │◄──│ PAYMENT  │◄──│ SETTLEMENT  │◄───────────────│          │    │
│  │      │   │          │   │             │                │          │    │
│  └──────┘   └──────────┘   └─────────────┘                └──────────┘    │
│                                                                             │
│  Cross-cutting: Coverage Verification | SIU | Subrogation | Litigation      │
└─────────────────────────────────────────────────────────────────────────────┘
```

### 1.2 Lifecycle Stage Summary

| Stage | Primary Actor | Entry Criteria | Exit Criteria | Typical Duration |
|---|---|---|---|---|
| **FNOL** | CSR / Insured / Agent | Loss event occurs | Claim record created with minimum data | Minutes to hours |
| **Assignment & Triage** | System / Supervisor | Claim created | Adjuster assigned, priority set | Minutes (automated) to hours |
| **Investigation** | Adjuster | Assignment received | Facts gathered, liability determined | Days to months |
| **Coverage Verification** | Adjuster / Coverage Counsel | FNOL received (parallel) | Coverage confirmed, denied, or reserved | Hours to weeks |
| **Evaluation & Reserving** | Adjuster / Examiner | Investigation substantially complete | Accurate reserves set, claim valued | Days to weeks |
| **Negotiation** | Adjuster / Attorney | Claim evaluated | Settlement reached or litigation authorized | Days to years (BI) |
| **Settlement** | Adjuster / Examiner | Agreement reached | Settlement documented and approved | Hours to days |
| **Payment** | Adjuster / Finance | Settlement approved | Payment issued and delivered | Days to weeks |
| **Closure** | Adjuster / System | All features resolved, payments cleared | Claim closed | Hours to days |

### 1.3 Key Principles

1. **Not strictly linear** — stages overlap and iterate; investigation may reopen during negotiation
2. **Feature-level tracking** — each feature (coverage exposure) within a claim can be at a different lifecycle stage
3. **Parallel paths** — coverage verification, liability investigation, and damage assessment often run concurrently
4. **Business rules vary** — by line of business, jurisdiction, claim complexity, and carrier procedures

---

## 2. Claim Status State Machine

### 2.1 Primary Claim Statuses

```
                              ┌──────────────────┐
                              │                  │
            ┌────────────────►│    OPEN          │◄──────────────┐
            │                 │                  │               │
            │                 └───┬──────────┬───┘               │
            │                     │          │                   │
            │            ┌────────▼──┐  ┌────▼────────┐          │
            │            │  OPEN -   │  │  OPEN -     │          │
            │            │ ASSIGNED  │  │ UNASSIGNED  │          │
            │            └────┬──────┘  └─────────────┘          │
            │                 │                                  │
            │            ┌────▼──────────┐                       │
            │            │  OPEN -       │                       │
            │            │ INVESTIGATION │                       │
            │            └────┬──────────┘                       │
            │                 │                                  │
            │            ┌────▼──────────┐                       │
            │            │  OPEN -       │                       │
            │            │ EVALUATION    │                       │
            │            └────┬──────────┘                       │
            │                 │                                  │
            │            ┌────▼──────────┐                       │
            │            │  OPEN -       │                       │
            │            │ NEGOTIATION   │                       │
            │            └────┬──────────┘                       │
            │                 │                                  │
            │            ┌────▼──────────┐                       │
            │            │  OPEN -       │                       │
            │            │ SETTLEMENT    │                       │
            │            └────┬──────────┘                       │
            │                 │                                  │
            │            ┌────▼──────────┐     ┌──────────────┐  │
            │            │  OPEN -       │────►│ CLOSED -     │  │
            │            │ PAYMENT PEND  │     │ W/PAYMENT    │──┤
            │            └───────────────┘     └──────────────┘  │
            │                                                    │
            │                                  ┌──────────────┐  │
            │                                  │ CLOSED -     │  │
            │                                  │ W/O PAYMENT  │──┤
            │                                  └──────────────┘  │
            │                                                    │
            │                                  ┌──────────────┐  │
            │                                  │ CLOSED -     │──┘
            │                                  │ DENIAL       │
            │                 REOPEN           └──────────────┘
            │                                        │
            │                                        │
            └────────────────────────────────────────┘
                        (from any CLOSED status)
```

### 2.2 Complete Status Transition Table

| From Status | To Status | Trigger | Business Rules |
|---|---|---|---|
| (New) | OPEN - UNASSIGNED | FNOL submitted | Claim created; minimum required fields validated |
| OPEN - UNASSIGNED | OPEN - ASSIGNED | Assignment rules executed | Adjuster assigned; assignment notification sent |
| OPEN - ASSIGNED | OPEN - INVESTIGATION | Adjuster begins investigation | Contact initiated with insured/claimant |
| OPEN - INVESTIGATION | OPEN - EVALUATION | Investigation substantially complete | Key facts gathered; liability position established |
| OPEN - EVALUATION | OPEN - NEGOTIATION | Reserves set; valuation complete | Claim valued; settlement authority established |
| OPEN - NEGOTIATION | OPEN - SETTLEMENT | Terms agreed | Settlement agreement documented |
| OPEN - SETTLEMENT | OPEN - PAYMENT PENDING | Settlement approved | Payment request submitted |
| OPEN - PAYMENT PENDING | CLOSED - W/PAYMENT | Payment issued and cleared | All features resolved; no pending activities |
| Any OPEN | CLOSED - W/O PAYMENT | No payment owed | Coverage confirmed, no covered damage; insured withdraws |
| Any OPEN | CLOSED - DENIAL | Coverage denied | Denial letter issued; coverage review completed |
| Any CLOSED | OPEN (REOPENED) | New information, supplement, legal action | Reopen reason documented; reassignment may occur |
| OPEN - INVESTIGATION | OPEN - SIU REFERRAL | Fraud indicators detected | SIU referral form completed; claim flagged |
| Any OPEN | OPEN - LITIGATION | Lawsuit filed | Defense counsel assigned; litigation plan created |

### 2.3 Sub-Status Codes

Each primary status has associated sub-status codes for more granular tracking:

| Primary Status | Sub-Status | Description |
|---|---|---|
| OPEN - INVESTIGATION | PENDING_CONTACT | Awaiting initial contact with insured/claimant |
| OPEN - INVESTIGATION | PENDING_DOCS | Awaiting documentation (police report, medical records, etc.) |
| OPEN - INVESTIGATION | PENDING_INSPECTION | Awaiting property/vehicle inspection |
| OPEN - INVESTIGATION | PENDING_STATEMENT | Awaiting recorded statement |
| OPEN - INVESTIGATION | SIU_REFERRED | Referred to Special Investigations Unit |
| OPEN - INVESTIGATION | EXPERT_ENGAGED | Expert (engineer, doctor, etc.) engaged |
| OPEN - EVALUATION | PENDING_ESTIMATE | Awaiting damage estimate |
| OPEN - EVALUATION | PENDING_IME | Awaiting Independent Medical Examination |
| OPEN - EVALUATION | PENDING_APPRAISAL | Appraisal process invoked |
| OPEN - NEGOTIATION | DEMAND_RECEIVED | Demand package received from claimant/attorney |
| OPEN - NEGOTIATION | OFFER_EXTENDED | Settlement offer made |
| OPEN - NEGOTIATION | COUNTER_RECEIVED | Counteroffer from claimant/attorney |
| OPEN - NEGOTIATION | MEDIATION | Mediation scheduled/in progress |
| OPEN - LITIGATION | DISCOVERY | Litigation in discovery phase |
| OPEN - LITIGATION | TRIAL_PREP | Trial preparation underway |
| OPEN - LITIGATION | TRIAL | Trial in progress |
| OPEN - LITIGATION | APPEAL | Verdict under appeal |
| CLOSED | CLOSED_PAID | Closed with payment |
| CLOSED | CLOSED_NO_PAY | Closed without payment |
| CLOSED | CLOSED_DENIED | Closed - coverage denied |
| CLOSED | CLOSED_WITHDRAWN | Closed - insured withdrew claim |
| CLOSED | CLOSED_SUBROGATED | Closed - full recovery via subrogation |

---

## 3. Feature Status State Machine

### 3.1 Feature-Level Status Tracking

Features (coverage exposures) within a claim have their own lifecycle:

```
┌──────────┐     ┌──────────┐     ┌──────────┐     ┌──────────────┐
│  OPEN    │────►│ RESERVED │────►│ SETTLING │────►│   CLOSED     │
│(Created) │     │          │     │          │     │ (Resolved)   │
└──────────┘     └────┬─────┘     └──────────┘     └──────┬───────┘
                      │                                    │
                      │           ┌──────────┐             │
                      └──────────►│ DENIED   │             │
                                  └──────────┘             │
                                                           │
                                  ┌──────────┐             │
                                  │ REOPENED │◄────────────┘
                                  └──────────┘
```

### 3.2 Feature Closure Rules

| Closure Type | Conditions | Business Rule |
|---|---|---|
| Closed - Paid | Payment(s) issued, reserve = $0 | All payments must be in Cleared status |
| Closed - No Payment | Investigation complete, no payment owed | Reserve must be zeroed out |
| Closed - Denied | Coverage determination: not covered | Denial letter must be on file |
| Closed - Withdrawn | Insured/claimant withdraws feature | Withdrawal documented in notes |
| Closed - Combined | Feature merged into another feature | Reference to surviving feature |

### 3.3 Claim-Level vs. Feature-Level Status Relationship

```
RULE: A claim's status is derived from its features:
- Claim is OPEN if ANY feature is OPEN
- Claim is CLOSED only when ALL features are CLOSED
- Claim status reflects the "most advanced" open feature
- Claim reopens if ANY closed feature is reopened

Example:
  Claim CLM-2026-001
  ├── Feature: COLL (Collision)      → CLOSED-PAID
  ├── Feature: RENTAL                → CLOSED-PAID
  ├── Feature: BI-1 (Bodily Injury)  → OPEN-NEGOTIATION
  └── Feature: SUBROG                → OPEN-INVESTIGATION
  
  Claim Status: OPEN (because BI-1 and SUBROG are still open)
```

---

## 4. Detailed Subprocess: FNOL & Claim Creation

### 4.1 FNOL Process Flow

```
START
  │
  ▼
┌─────────────────────────────┐
│ Receive Loss Report          │
│ (Phone, Web, Mobile, Agent,  │
│  Email, EDI, IoT)            │
└──────────┬──────────────────┘
           │
           ▼
┌─────────────────────────────┐     ┌───────────────────┐
│ Verify Policy                │────►│ Policy Not Found  │
│ - Policy number lookup       │ NO  │ → Notify reporter │
│ - Name/DOB match             │     │ → End             │
│ - Policy in-force on loss dt │     └───────────────────┘
└──────────┬──────────────────┘
           │ YES
           ▼
┌─────────────────────────────┐
│ Capture Loss Details         │
│ - Date/Time of loss          │
│ - Location of loss           │
│ - Description of loss        │
│ - Cause of loss              │
│ - Reporter information       │
│ - Injured parties            │
│ - Damaged property/vehicles  │
│ - Other party information    │
│ - Witnesses                  │
│ - Police/fire report info    │
└──────────┬──────────────────┘
           │
           ▼
┌─────────────────────────────┐     ┌───────────────────┐
│ Duplicate Check              │────►│ Potential Dup Found│
│ - Match on policy + loss dt  │ YES │ → Review existing  │
│ - Match on VIN/address       │     │ → Link or merge    │
│ - Match on parties           │     └───────────────────┘
└──────────┬──────────────────┘
           │ NO DUPLICATE
           ▼
┌─────────────────────────────┐
│ Create Claim Record          │
│ - Generate claim number      │
│ - Set initial status         │
│ - Create claim parties       │
│ - Create features/exposures  │
│ - Timestamp entry            │
└──────────┬──────────────────┘
           │
           ▼
┌─────────────────────────────┐
│ Initial Coverage Assessment  │
│ - Map cause of loss to       │
│   available coverages        │
│ - Check for known exclusions │
│ - Flag coverage issues       │
└──────────┬──────────────────┘
           │
           ▼
┌─────────────────────────────┐
│ Triage & Scoring             │
│ - Complexity scoring         │
│ - Severity estimation        │
│ - STP eligibility check      │
│ - Fraud scoring              │
│ - CAT event check            │
└──────────┬──────────────────┘
           │
           ├──────────────────────────┐
           │ STP ELIGIBLE             │ NOT STP ELIGIBLE
           ▼                          ▼
┌─────────────────────┐    ┌─────────────────────┐
│ Straight-Through     │    │ Route to Assignment  │
│ Processing           │    │ Queue                │
│ - Auto-reserve       │    │ - Apply assignment   │
│ - Auto-payment       │    │   rules              │
│ - Auto-close         │    │ - Notify adjuster    │
└─────────────────────┘    └─────────────────────┘
           │                          │
           ▼                          ▼
          END                    ASSIGNMENT STAGE
```

### 4.2 FNOL Entry/Exit Criteria

| Criteria | Details |
|---|---|
| **Entry Criteria** | Loss event reported through any channel |
| **Minimum Required Data** | Policy number OR insured name + address; loss date; loss description; reporter contact info |
| **Validation Rules** | Loss date ≤ today; loss date ≥ policy effective date; policy number valid format |
| **Exit Criteria** | Claim record created with unique claim number; at least one feature created; initial activities generated |
| **Key Outputs** | Claim number, acknowledgment letter/email, claim assignment |

---

## 5. Detailed Subprocess: Assignment & Triage

### 5.1 Assignment Process Flow

```
START (Claim Created)
  │
  ▼
┌─────────────────────────────┐
│ Determine Assignment Criteria│
│ - Line of business           │
│ - Claim type (auto PD, auto  │
│   BI, property, liability)   │
│ - Jurisdiction/state         │
│ - Complexity score           │
│ - Severity score             │
│ - Catastrophe flag           │
│ - Litigation flag            │
│ - Special handling flags     │
└──────────┬──────────────────┘
           │
           ▼
┌─────────────────────────────┐     ┌───────────────────────┐
│ Check for Special Routing    │────►│ Route to Special Unit  │
│ - VIP / Large Account?       │YES  │ (Key Account, Complex  │
│ - Known attorney?            │     │  Claims, Litigation)   │
│ - Prior SIU referral?        │     └───────────────────────┘
│ - CAT event?                 │
│ - Above reserve threshold?   │
└──────────┬──────────────────┘
           │ STANDARD ROUTING
           ▼
┌─────────────────────────────┐
│ Identify Assignment Pool     │
│ - Match claim attributes to  │
│   adjuster skills/authority  │
│ - Filter by jurisdiction     │
│   license                    │
│ - Filter by workload capacity│
│ - Filter by availability     │
│   (not on leave/vacation)    │
└──────────┬──────────────────┘
           │
           ▼
┌─────────────────────────────┐
│ Apply Assignment Algorithm   │
│ ┌─────────────────────────┐ │
│ │ Round Robin              │ │
│ │ - Rotate among qualified │ │
│ │   adjusters              │ │
│ ├─────────────────────────┤ │
│ │ Workload Balancing       │ │
│ │ - Assign to adjuster     │ │
│ │   with lowest weighted   │ │
│ │   caseload               │ │
│ ├─────────────────────────┤ │
│ │ Skill-Based              │ │
│ │ - Match claim complexity │ │
│ │   to adjuster skill tier │ │
│ ├─────────────────────────┤ │
│ │ Geographic               │ │
│ │ - Assign to nearest      │ │
│ │   field adjuster         │ │
│ ├─────────────────────────┤ │
│ │ Hybrid                   │ │
│ │ - Weighted combination   │ │
│ │   of above factors       │ │
│ └─────────────────────────┘ │
└──────────┬──────────────────┘
           │
           ▼
┌─────────────────────────────┐
│ Assign Claim                 │
│ - Set assigned adjuster      │
│ - Set assigned unit/team     │
│ - Set assigned supervisor    │
│ - Generate initial activities│
│ - Send assignment notif.     │
│ - Update claim status        │
└──────────┬──────────────────┘
           │
           ▼
┌─────────────────────────────┐
│ Generate Initial Work Plan   │
│ - Create investigation       │
│   activity checklist         │
│ - Set contact diaries        │
│ - Set reserve review diary   │
│ - Set coverage review task   │
│ - Set SLA timers             │
└──────────┬──────────────────┘
           │
           ▼
         END → INVESTIGATION STAGE
```

### 5.2 Assignment Algorithm — Weighted Workload Balancing

```
Adjuster Score Calculation:

  score(adjuster) = 
    w1 × open_claim_count / max_capacity
  + w2 × weighted_reserve_total / reserve_threshold
  + w3 × new_claims_today / daily_limit
  + w4 × overdue_activities / activity_threshold

Where:
  w1 = 0.40 (volume weight)
  w2 = 0.25 (severity weight)  
  w3 = 0.20 (daily intake weight)
  w4 = 0.15 (quality/timeliness weight)

Lower score = more capacity = higher assignment priority

Additional Filters:
  - adjuster.licensed_states CONTAINS claim.jurisdiction
  - adjuster.skill_level >= claim.complexity_tier
  - adjuster.authority_limit >= claim.estimated_severity
  - adjuster.status = ACTIVE
  - adjuster.on_leave = FALSE
```

### 5.3 Triage Rules Engine

| Rule Category | Input | Output | Example |
|---|---|---|---|
| Complexity Scoring | Loss type, party count, injury count, property count | Complexity tier (1-5) | Multi-vehicle with injuries → Tier 4 |
| Severity Scoring | Cause of loss, injury type, property type, initial estimates | Severity tier (1-5) | House fire → Tier 5 |
| STP Eligibility | Claim type, amount, prior history, fraud score | STP flag (Y/N) | Glass-only, no prior claims → STP eligible |
| CAT Detection | Loss date, loss location, cause of loss | CAT code or null | Hurricane loss in Florida on 9/28 → CAT-2026-H4 |
| Fraud Scoring | Loss circumstances, prior claims, ISO ClaimSearch results | Fraud score (0-100) | Late-reported theft with prior theft claims → Score 75 |
| Routing | All above + policy type, account flag | Assignment queue/unit | Large commercial → Key Account unit |

---

## 6. Detailed Subprocess: Investigation

### 6.1 Investigation Process Flow

```
START (Assignment received)
  │
  ▼
┌──────────────────────────────┐
│ 1. INITIAL CONTACT            │
│ - Contact insured (within SLA │
│   — typically 24-48 hours)    │
│ - Confirm loss facts          │
│ - Explain claims process      │
│ - Identify immediate needs    │
│   (emergency repairs, rental) │
│ - Obtain recorded statement   │
│   (if applicable)             │
└──────────┬───────────────────┘
           │
           ▼
┌──────────────────────────────┐
│ 2. DOCUMENTATION COLLECTION   │
│ - Request police report       │
│ - Request fire report         │
│ - Request medical records     │
│ - Request repair estimates    │
│ - Request proof of ownership  │
│ - Request photos/video        │
│ - Request witness statements  │
│ - Request financial records   │
│   (BI/extra expense claims)   │
└──────────┬───────────────────┘
           │
           ▼
┌──────────────────────────────┐
│ 3. INSPECTION / ASSESSMENT    │
│ - Field inspection (if needed)│
│   OR desk review              │
│ - Vehicle inspection/estimate │
│ - Property inspection/scope   │
│ - Medical records review      │
│ - Scene documentation         │
│ - Photos and measurements     │
└──────────┬───────────────────┘
           │
           ▼
┌──────────────────────────────┐
│ 4. LIABILITY DETERMINATION    │
│ - Analyze facts               │
│ - Apply negligence framework  │
│ - Determine fault allocation  │
│ - Document liability position │
│ - Consider comparative/       │
│   contributory negligence     │
└──────────┬───────────────────┘
           │
           ▼
┌──────────────────────────────┐     ┌─────────────────────┐
│ 5. FRAUD ASSESSMENT           │────►│ SIU REFERRAL        │
│ - Review for red flags        │YES  │ - Complete referral  │
│ - Check ISO ClaimSearch       │     │   form               │
│ - Verify facts/consistency    │     │ - Transfer to SIU    │
│ - Apply fraud scoring model   │     └─────────────────────┘
└──────────┬───────────────────┘
           │ NO FRAUD INDICATORS
           ▼
┌──────────────────────────────┐
│ 6. EXPERT ENGAGEMENT          │
│ (If needed)                   │
│ - Engineering expert          │
│ - Medical expert / IME        │
│ - Accident reconstruction     │
│ - Fire origin & cause         │
│ - Forensic accounting         │
│ - Environmental consultant    │
└──────────┬───────────────────┘
           │
           ▼
         END → EVALUATION STAGE
```

### 6.2 Investigation Checklist by Claim Type

#### Auto Physical Damage

| Step | Activity | SLA | Required Docs |
|---|---|---|---|
| 1 | Contact insured | 24 hours | — |
| 2 | Verify vehicle on policy (VIN match) | During FNOL | Policy dec page |
| 3 | Inspect vehicle or obtain photos | 3-5 business days | Photos (all angles, damage, VIN, odometer) |
| 4 | Obtain/prepare damage estimate | 5-7 business days | CCC/Mitchell/Audatex estimate |
| 5 | Check for prior unrelated damage | During inspection | Prior claim history |
| 6 | Determine if total loss | After estimate | ACV comparison, threshold test |
| 7 | If repairable: authorize repairs | After estimate | Estimate, supplement if needed |
| 8 | If total loss: determine ACV, negotiate | After TL declaration | Valuation report, title |
| 9 | Set up rental reimbursement (if covered) | Immediately | Rental agreement |
| 10 | Handle salvage (if total loss) | After settlement | Title, salvage bid |
| 11 | Pursue subrogation (if not at fault) | After payment | Police report, liability docs |

#### Homeowners Property Damage

| Step | Activity | SLA | Required Docs |
|---|---|---|---|
| 1 | Contact insured | 24 hours | — |
| 2 | Advise on mitigation (prevent further damage) | During first contact | — |
| 3 | Authorize emergency repairs if needed | During first contact | Emergency repair authorization |
| 4 | Schedule inspection | 3-5 business days | — |
| 5 | Conduct field inspection / scope of loss | Per schedule | Xactimate estimate, photos, diagram |
| 6 | Determine cause of loss | During inspection | Inspection report |
| 7 | Verify coverage (cause of loss vs. policy perils) | After inspection | Policy review notes |
| 8 | Prepare estimate (Xactimate) | 5-10 business days | Xactimate estimate |
| 9 | Calculate depreciation (if ACV policy) | After estimate | Depreciation schedule |
| 10 | Apply deductible | After estimate | — |
| 11 | Determine Additional Living Expenses (if uninhabitable) | During first contact | Receipts, documentation |
| 12 | Handle contents claim (personal property) | Ongoing | Inventory list, receipts |
| 13 | Issue proof of loss form (if required) | After evaluation | Proof of loss form |
| 14 | Coordinate with mortgage company | Before payment | Mortgage company notification |
| 15 | Issue payment | After agreement | — |
| 16 | Handle recoverable depreciation (if RCV policy) | After repairs completed | Repair receipts |

---

## 7. Detailed Subprocess: Coverage Verification

### 7.1 Coverage Verification Flow

```
START (Triggered at FNOL, runs parallel to investigation)
  │
  ▼
┌──────────────────────────────┐
│ 1. POLICY VERIFICATION        │
│ - Retrieve full policy from   │
│   Policy Admin System         │
│ - Verify policy in-force on   │
│   loss date                   │
│ - Check for cancellation/     │
│   non-renewal                 │
│ - Check billing status        │
│   (grace period?)             │
└──────────┬───────────────────┘
           │
           ├── Policy NOT in force → Issue denial / reservation of rights
           │
           ▼
┌──────────────────────────────┐
│ 2. COVERAGE IDENTIFICATION    │
│ - Map cause of loss to        │
│   applicable coverages        │
│ - Identify all potentially    │
│   responsive coverages        │
│ - Check for endorsements that │
│   add or restrict coverage    │
│ - Identify applicable limits  │
│   and deductibles             │
└──────────┬───────────────────┘
           │
           ▼
┌──────────────────────────────┐
│ 3. EXCLUSION ANALYSIS         │
│ - Review all policy exclusions│
│ - Check if any exclusion      │
│   applies to this loss        │
│ - Check for exceptions to     │
│   exclusions (exclusion       │
│   within exclusion)           │
│ - Check for endorsements that │
│   buy back excluded coverage  │
└──────────┬───────────────────┘
           │
           ├── Exclusion clearly applies → Denial path
           ├── Exclusion may apply → Reservation of Rights
           │
           ▼
┌──────────────────────────────┐
│ 4. CONDITION COMPLIANCE       │
│ - Timely notice given?        │
│ - Insured cooperating?        │
│ - Proof of loss submitted     │
│   (if required)?              │
│ - Mitigation efforts made?    │
│ - Other conditions met?       │
└──────────┬───────────────────┘
           │
           ▼
┌──────────────────────────────┐
│ 5. COVERAGE DETERMINATION     │
│                               │
│ ┌───────────────────────────┐ │
│ │ A. COVERAGE CONFIRMED     │ │
│ │    Full coverage applies   │ │
│ ├───────────────────────────┤ │
│ │ B. PARTIAL COVERAGE       │ │
│ │    Some coverages apply,   │ │
│ │    others do not           │ │
│ ├───────────────────────────┤ │
│ │ C. RESERVATION OF RIGHTS  │ │
│ │    Coverage questionable;  │ │
│ │    investigation continues │ │
│ │    under ROR               │ │
│ ├───────────────────────────┤ │
│ │ D. COVERAGE DENIED        │ │
│ │    Loss not covered under  │ │
│ │    policy                  │ │
│ └───────────────────────────┘ │
└──────────┬───────────────────┘
           │
           ▼
┌──────────────────────────────┐
│ 6. DOCUMENTATION & NOTICE     │
│ - Document coverage analysis  │
│ - If denied: issue denial     │
│   letter (with specific       │
│   policy provisions cited)    │
│ - If ROR: issue reservation   │
│   of rights letter            │
│ - If confirmed: proceed to    │
│   evaluation                  │
│ - Comply with state-specific  │
│   timing requirements         │
└──────────────────────────────┘
```

### 7.2 Coverage Decision Matrix — Homeowners Example

| Cause of Loss | Cov A (Dwelling) | Cov B (Other Structures) | Cov C (Personal Property) | Cov D (Loss of Use) | Cov E (Liability) |
|---|---|---|---|---|---|
| Fire | Covered | Covered | Covered | Covered (if uninhabitable) | N/A |
| Wind/Hail | Covered | Covered | Covered (if wind enters) | Covered (if uninhabitable) | N/A |
| Theft | Covered | Covered | Covered | N/A typically | N/A |
| Water (burst pipe) | Covered | Covered | Covered | Covered (if uninhabitable) | N/A |
| Water (flood) | EXCLUDED | EXCLUDED | EXCLUDED | EXCLUDED | N/A |
| Water (gradual leak) | EXCLUDED (wear/tear) | EXCLUDED | May cover resulting damage | N/A | N/A |
| Earthquake | EXCLUDED (unless endorsed) | EXCLUDED | EXCLUDED | EXCLUDED | N/A |
| Sewer backup | EXCLUDED (unless endorsed) | EXCLUDED | EXCLUDED | N/A | N/A |
| Mold | Limited/EXCLUDED | Limited/EXCLUDED | Limited/EXCLUDED | N/A | N/A |
| Slip/fall by visitor | N/A | N/A | N/A | N/A | Covered |
| Dog bite | N/A | N/A | N/A | N/A | Covered (breed restrictions may apply) |

---

## 8. Detailed Subprocess: Evaluation & Reserving

### 8.1 Evaluation Process Flow

```
START (Investigation substantially complete)
  │
  ▼
┌──────────────────────────────┐
│ 1. DAMAGE ASSESSMENT          │
│                               │
│ Property Claims:              │
│ - Xactimate estimate review   │
│ - Contractor bid review       │
│ - Contents inventory valuation│
│ - Depreciation calculation    │
│ - Coinsurance check           │
│                               │
│ Auto Physical Damage:         │
│ - CCC/Mitchell estimate review│
│ - Supplement processing       │
│ - Total loss evaluation       │
│ - ACV determination           │
│ - Salvage value assessment    │
│                               │
│ Bodily Injury:                │
│ - Medical specials totaling   │
│ - Future medical estimation   │
│ - Lost wage calculation       │
│ - General damages evaluation  │
│ - Permanency assessment       │
│ - Verdict research            │
└──────────┬───────────────────┘
           │
           ▼
┌──────────────────────────────┐
│ 2. LIABILITY VALUATION        │
│ - Determine fault percentage  │
│ - Apply comparative/          │
│   contributory negligence     │
│ - Calculate net exposure      │
│ - Consider joint & several    │
│   liability                   │
└──────────┬───────────────────┘
           │
           ▼
┌──────────────────────────────┐
│ 3. RESERVE SETTING            │
│                               │
│ Reserve Components:           │
│ ┌──────────────────────────┐  │
│ │ Loss Reserve              │  │
│ │ - Indemnity / damages     │  │
│ │ - Expected ultimate pmt   │  │
│ └──────────────────────────┘  │
│ ┌──────────────────────────┐  │
│ │ ALAE Reserve              │  │
│ │ - Defense attorney fees   │  │
│ │ - Expert fees             │  │
│ │ - Independent adjuster    │  │
│ │ - Medical examinations    │  │
│ └──────────────────────────┘  │
│                               │
│ Reserve = Best estimate of    │
│ ultimate cost at feature level│
└──────────┬───────────────────┘
           │
           ▼
┌──────────────────────────────┐     ┌─────────────────────┐
│ 4. AUTHORITY CHECK            │────►│ ESCALATE TO          │
│ - Compare reserve to adjuster │YES  │ SUPERVISOR/EXAMINER  │
│   authority level             │     │ for approval         │
│ - If exceeds authority,       │     └─────────────────────┘
│   escalate                    │
└──────────┬───────────────────┘
           │ WITHIN AUTHORITY
           ▼
┌──────────────────────────────┐
│ 5. RESERVE APPROVAL & POSTING │
│ - Record reserve transaction  │
│ - Update financial aggregates │
│ - Trigger notifications       │
│   (large loss, reinsurance)   │
│ - Update claim diary          │
└──────────┬───────────────────┘
           │
           ▼
         END → NEGOTIATION STAGE
```

### 8.2 Reserve Setting Guidelines

| Reserve Type | Setting Approach | Timing |
|---|---|---|
| Initial Reserve | Formula-based or table-driven based on claim type, cause of loss, severity indicators | At FNOL or assignment (within 24-48 hours) |
| Adjuster Reserve | Case-specific estimate based on investigation findings | After initial investigation (3-15 days) |
| Reserve Review | Periodic reassessment as new information emerges | Per diary schedule (30/60/90 day reviews) |
| Staircase Reserve | Reserve adjusted upward in increments as claim develops | As milestones occur (surgery, IME, litigation) |
| Expert Reserve | Based on expert opinion (medical, engineering, legal) | When expert report received |

### 8.3 Reserve Adequacy Checks

```
Reserve Adequacy Validation Rules:

1. MINIMUM RESERVE RULE
   - Every open feature must have a reserve > $0
   - Minimum reserve floor by claim type:
     Auto PD: $500
     Auto BI: $5,000
     Homeowners: $1,000
     CGL: $5,000
     Workers Comp: $2,000

2. RESERVE CHANGE TOLERANCE
   - Changes > 50% of prior reserve require supervisor review
   - Changes > $50K require examiner approval
   - Changes > $250K require VP Claims approval
   - Changes > $1M require C-suite notification

3. RESERVE STALENESS
   - Reserves not reviewed in 60+ days flagged for review
   - Reserves not reviewed in 90+ days generate mandatory diary
   - Reserves unchanged for 180+ days trigger audit flag

4. RESERVE-TO-PAYMENT RATIO
   - Payment > 80% of reserve triggers review alert
   - Payment > reserve triggers mandatory reserve increase
   - Final payment must not exceed reserve without prior adjustment

5. AGGREGATE RESERVE MONITORING
   - Claim total incurred > $100K: monthly reserve review
   - Claim total incurred > $500K: biweekly reserve review
   - Claim total incurred > $1M: weekly reserve review
```

### 8.4 Total Loss Determination — Auto

```
Total Loss Decision Flow:

  Obtain repair estimate (E)
  Obtain Actual Cash Value (ACV)
  │
  ├── IF E > ACV → TOTAL LOSS (economic total loss)
  │
  ├── IF E > (ACV × threshold%) → TOTAL LOSS (threshold total loss)
  │   (threshold varies by state: 70%-100%)
  │   Example: State threshold = 75%
  │   ACV = $20,000, Estimate = $16,000
  │   $16,000 / $20,000 = 80% > 75% → TOTAL LOSS
  │
  ├── IF vehicle has structural damage → May be TOTAL LOSS regardless
  │
  └── IF E < ACV × threshold% → REPAIRABLE
      → Authorize repairs
      → Issue payment to shop (DRP) or insured (non-DRP)

Total Loss Settlement:
  Payment = ACV - Deductible - Prior Damage (if any) + Sales Tax + Title/Registration Fees
  
  Owner Retained Salvage Option:
  Payment = ACV - Deductible - Salvage Value
  (Vehicle remains with owner, title branded as salvage)
```

---

## 9. Detailed Subprocess: Negotiation & Settlement

### 9.1 Negotiation Process Flow

```
START (Claim evaluated, reserves set)
  │
  ▼
┌──────────────────────────────┐
│ 1. DETERMINE SETTLEMENT VALUE │
│ - Review damages evaluation   │
│ - Apply liability percentage  │
│ - Consider policy limits      │
│ - Consider other insurance    │
│ - Determine settlement range  │
│   (low, target, high)         │
└──────────┬───────────────────┘
           │
           ▼
┌──────────────────────────────┐
│ 2. OBTAIN SETTLEMENT AUTHORITY│
│ - If within adjuster authority│
│   → proceed                   │
│ - If exceeds authority        │
│   → request from supervisor   │
│ - Document authority level    │
│   and approval                │
└──────────┬───────────────────┘
           │
           ▼
┌──────────────────────────────┐
│ 3. INITIATE NEGOTIATION       │
│                               │
│ First-Party Claims:           │
│ - Present findings to insured │
│ - Explain coverage and        │
│   deductible application      │
│ - Discuss valuation           │
│                               │
│ Third-Party Claims:           │
│ - Respond to demand (or make  │
│   initial offer if no demand) │
│ - Present liability position  │
│ - Present damages evaluation  │
└──────────┬───────────────────┘
           │
           ▼
┌──────────────────────────────┐
│ 4. NEGOTIATION CYCLE          │
│                               │
│ ┌──Offer/Counter Loop──────┐  │
│ │                           │  │
│ │  Adjuster makes offer     │  │
│ │         │                 │  │
│ │         ▼                 │  │
│ │  Claimant responds:       │  │
│ │  ├─ Accepts → Settlement  │  │
│ │  ├─ Rejects → Deadlock    │  │
│ │  └─ Counters → Evaluate   │  │
│ │         │                 │  │
│ │         ▼                 │  │
│ │  Adjuster evaluates       │  │
│ │  counter:                 │  │
│ │  ├─ Accept → Settlement   │  │
│ │  ├─ Counter → Loop back   │  │
│ │  └─ Final offer → Wait    │  │
│ │                           │  │
│ └───────────────────────────┘  │
└──────────┬───────────────────┘
           │
           ├── AGREED → Settlement Documentation
           │
           ├── DEADLOCK → Alternative Resolution
           │   ├── Mediation
           │   ├── Appraisal (property)
           │   ├── Arbitration
           │   └── Litigation
           │
           ▼
┌──────────────────────────────┐
│ 5. DOCUMENT SETTLEMENT        │
│ - Release and settlement      │
│   agreement                   │
│ - General release (BI claims) │
│ - Property release            │
│ - Proof of loss (property)    │
│ - Settlement memo             │
│ - Approval documentation      │
└──────────┬───────────────────┘
           │
           ▼
         END → PAYMENT STAGE
```

### 9.2 Settlement Authority Matrix

| Claim Type | Adjuster Level 1 | Adjuster Level 2 | Senior Adjuster | Examiner | Manager | VP Claims | C-Suite |
|---|---|---|---|---|---|---|---|
| Auto PD | $15K | $25K | $50K | $100K | $250K | $1M | Unlimited |
| Auto BI | $10K | $25K | $75K | $150K | $500K | $1M | Unlimited |
| Homeowners | $15K | $30K | $75K | $200K | $500K | $1M | Unlimited |
| Commercial Prop | $25K | $50K | $100K | $500K | $1M | $5M | Unlimited |
| CGL | $15K | $30K | $100K | $250K | $750K | $2M | Unlimited |
| Workers Comp | $10K | $25K | $50K | $150K | $500K | $1M | Unlimited |

### 9.3 Bodily Injury Valuation Methods

| Method | Description | Formula/Approach |
|---|---|---|
| **Multiplier Method** | General damages = multiple of medical specials | GD = Medical Specials × Multiplier (1.5x to 5x based on severity) |
| **Per Diem Method** | Assign daily value to pain/suffering | GD = Daily Rate × Recovery Days |
| **Colossus / Claims IQ** | Software-based BI evaluation using injury attributes | Algorithmic: inputs include diagnosis codes, treatment duration, impairment rating, jurisdiction |
| **Verdict Research** | Compare to similar jury verdicts in jurisdiction | Research comparable cases in verdict databases (VerdictSearch, JuryVerdictReview) |
| **Round Table** | Panel of experienced adjusters review and value | Committee consensus-based valuation |
| **Total Exposure** | Sum of all damage components | Medical Specials + Lost Wages + Future Medical + General Damages + Future Lost Earnings |

---

## 10. Detailed Subprocess: Payment Processing

### 10.1 Payment Process Flow

```
START (Settlement approved)
  │
  ▼
┌──────────────────────────────┐
│ 1. CREATE PAYMENT REQUEST     │
│ - Feature / coverage code     │
│ - Payment type (loss, expense)│
│ - Payment category            │
│ - Payee information           │
│ - Co-payee (loss payee/       │
│   mortgage company)           │
│ - Amount                      │
│ - Invoice / supporting docs   │
│ - Tax reporting flags         │
└──────────┬───────────────────┘
           │
           ▼
┌──────────────────────────────┐
│ 2. PAYMENT VALIDATION         │
│ - Payment ≤ remaining reserve │
│ - Payment within authority    │
│ - Payee information complete  │
│ - Duplicate payment check     │
│ - OFAC/sanctions screening    │
│ - Loss payee check (property) │
│ - Lien check (WC/PIP)        │
│ - 1099 threshold check        │
└──────────┬───────────────────┘
           │
           ├── VALIDATION FAILS → Correct and resubmit
           │
           ▼
┌──────────────────────────────┐     ┌─────────────────────┐
│ 3. APPROVAL WORKFLOW          │────►│ ROUTE TO APPROVER   │
│ - Check if amount exceeds     │YES  │ (Supervisor/Examiner/│
│   adjuster's payment authority│     │  Manager/VP)         │
│ - Check for special approval  │     └─────────────────────┘
│   requirements                │
│   (SIU, Litigation, Large Loss)│
└──────────┬───────────────────┘
           │ APPROVED
           ▼
┌──────────────────────────────┐
│ 4. DETERMINE PAYMENT METHOD   │
│ - Check: one-party or two-    │
│   party (co-payee)?           │
│ - Check payee preferences     │
│ - EFT/ACH (electronic)        │
│ - Check (paper)               │
│ - Wire transfer (large/urgent)│
│ - Virtual card (vendor)       │
│ - Draft (adjuster-issued)     │
└──────────┬───────────────────┘
           │
           ▼
┌──────────────────────────────┐
│ 5. ISSUE PAYMENT              │
│ - Generate check or initiate  │
│   electronic transfer         │
│ - Record check number         │
│ - Update payment status       │
│ - Update reserve (reduce by   │
│   payment amount)             │
│ - Update financial totals     │
│ - Generate payment register   │
└──────────┬───────────────────┘
           │
           ▼
┌──────────────────────────────┐
│ 6. POST-PAYMENT PROCESSING    │
│ - Mail check / confirm EFT    │
│ - Notify payee                │
│ - Track outstanding checks    │
│ - 1099 reporting accumulation │
│ - Reinsurance reporting       │
│   (if applicable)             │
│ - Trigger subrogation review  │
│   (if applicable)             │
└──────────┬───────────────────┘
           │
           ▼
┌──────────────────────────────┐
│ 7. PAYMENT RECONCILIATION     │
│ - Track check clearance       │
│ - Stale-dated check process   │
│   (typically 90-180 days)     │
│ - Void and reissue process    │
│ - Stop payment process        │
│ - Escheatment for unclaimed   │
│   funds                       │
└──────────┬───────────────────┘
           │
           ▼
         END → CLOSURE CHECK
```

### 10.2 Payment Types and Categories

| Payment Type | Category Code | Description | Typical Payees |
|---|---|---|---|
| Loss - Indemnity | IND | Damage payments, settlements | Insured, claimant, repair facility |
| Loss - Medical | MED | Medical bill payments | Medical provider, insured |
| Loss - Lost Wages | WAG | Indemnity payments for lost income | Claimant, insured (WC/PIP) |
| Loss - Rental | RENT | Rental vehicle reimbursement | Rental company, insured |
| Loss - ALE | ALE | Additional living expenses | Insured (hotel, meals, etc.) |
| Loss - Contents | CONT | Personal property replacement | Insured |
| Expense - Legal | LEGAL | Defense attorney fees, plaintiff attorney fees | Law firm |
| Expense - Expert | EXPERT | Engineering, medical, accounting experts | Expert firm |
| Expense - IA | IA_FEE | Independent adjuster fees | IA firm |
| Expense - IME | IME | Independent medical examination | IME provider |
| Expense - Court | COURT | Filing fees, court costs, deposition costs | Various |
| Expense - Surveillance | SURV | Surveillance vendor fees | Investigation firm |
| Expense - Other ALAE | ALAE | Other allocated loss adjustment expenses | Various |
| Recovery - Subrogation | SUB_REC | Subrogation recovery (negative payment) | From responsible party/insurer |
| Recovery - Salvage | SALV_REC | Salvage proceeds | From salvage company |
| Recovery - Deductible | DED_REC | Deductible recovery from third party | From responsible party |
| Recovery - Reinsurance | RI_REC | Reinsurance recovery | From reinsurer |

### 10.3 Two-Party Check / Co-Payee Rules

| Scenario | Co-Payee Required | Payee Format |
|---|---|---|
| Property damage with mortgage | Mortgage company | "John Smith AND First National Bank" |
| Auto total loss with lienholder | Lienholder | "Jane Doe AND Capital One Auto Finance" |
| Medical bill payment (WC) | N/A (paid directly to provider) | "Regional Medical Center" |
| BI settlement with attorney | N/A (paid to attorney trust account) | "Smith & Jones Law Firm, Trust Account" |
| BI settlement without attorney | Claimant | "Robert Johnson" |
| Repair shop payment (DRP) | N/A | "ABC Body Shop" |

---

## 11. Detailed Subprocess: Claim Closure

### 11.1 Closure Process Flow

```
START (All payments processed)
  │
  ▼
┌──────────────────────────────┐
│ 1. CLOSURE ELIGIBILITY CHECK  │
│                               │
│ All features must satisfy:    │
│ ├── Outstanding reserve = $0  │
│ ├── No pending payments       │
│ ├── No pending activities     │
│ │   (or all waived/completed) │
│ ├── No open diary items       │
│ ├── Subrogation resolved or   │
│ │   referred to subrog unit   │
│ ├── All documents received    │
│ │   (or waived)               │
│ ├── Coverage determination    │
│ │   documented                │
│ ├── Liability determination   │
│ │   documented                │
│ └── Settlement/release signed │
│     (if applicable)           │
└──────────┬───────────────────┘
           │
           ├── NOT ELIGIBLE → Return to appropriate stage
           │
           ▼
┌──────────────────────────────┐
│ 2. CLOSE FEATURES             │
│ - Close each feature with     │
│   appropriate close code:     │
│   ├── Closed-Paid             │
│   ├── Closed-No Payment       │
│   ├── Closed-Denied           │
│   ├── Closed-Withdrawn        │
│   └── Closed-Subrogated       │
│ - Record close date           │
│ - Record close reason         │
└──────────┬───────────────────┘
           │
           ▼
┌──────────────────────────────┐
│ 3. CLOSE CLAIM                │
│ - Set claim status to CLOSED  │
│ - Record claim close date     │
│ - Record close code           │
│ - Generate closing summary    │
└──────────┬───────────────────┘
           │
           ▼
┌──────────────────────────────┐
│ 4. POST-CLOSURE PROCESSING    │
│ - Send claim closure notice   │
│ - Archive documents           │
│ - Update reporting databases  │
│ - Update actuarial data       │
│ - Report to ISO ClaimSearch   │
│ - Report to state (if req'd)  │
│ - Set reopen monitoring diary │
│   (if subrogation pending)    │
│ - Update experience rating    │
│   (WC: report to NCCI)        │
└──────────┬───────────────────┘
           │
           ▼
         END
```

### 11.2 Closure Validation Rules

| Rule ID | Rule | Action if Violated |
|---|---|---|
| CLO-001 | All feature reserves must be $0 | Block closure; prompt to zero reserves |
| CLO-002 | No payments in Pending/Approved status | Block closure; complete or void payments |
| CLO-003 | No open required activities | Block closure; complete, skip, or waive activities |
| CLO-004 | Coverage determination must be documented | Block closure; require coverage note |
| CLO-005 | Liability determination must be documented (liability claims) | Block closure; require liability note |
| CLO-006 | Release/settlement agreement on file (BI/GL claims > threshold) | Warn; allow supervisor override |
| CLO-007 | Salvage disposition complete (total loss auto) | Block closure; complete salvage process |
| CLO-008 | Subrogation disposition documented | Warn; allow closure with subrog referral |
| CLO-009 | All IRS-reportable payments flagged correctly | Block closure; require 1099 review |
| CLO-010 | State-specific closing requirements met | Block closure; varies by jurisdiction |

---

## 12. Activity-Based Flows by Line of Business

### 12.1 Simple Auto Collision Claim (Not-at-Fault, Vehicle Repairable)

```
Day 0: FNOL received via phone
  │
  ├── Claim created: CLM-2026-00100
  ├── Features: COLL, RENTAL
  ├── Auto-assigned to Desk Adjuster (Auto PD unit)
  │
Day 0-1: INITIAL CONTACT
  │
  ├── Call insured — confirm facts, advise on rental
  ├── Verify vehicle on policy (VIN match)
  ├── Verify collision coverage active
  ├── Set up rental reimbursement
  ├── Direct insured to DRP shop OR obtain photos
  ├── Request police report
  │
Day 1-5: VEHICLE INSPECTION & ESTIMATE
  │
  ├── Vehicle inspected at DRP shop
  ├── CCC estimate prepared: $4,200
  ├── Photos reviewed
  ├── Estimate approved
  │
Day 5-7: EVALUATION & PAYMENT
  │
  ├── Reserve set: $4,200 (loss) + $800 (rental estimate)
  ├── Deductible applied: $500
  ├── Payment issued to DRP shop: $3,700 ($4,200 - $500 deductible)
  │
Day 7-14: REPAIR & SUPPLEMENT
  │
  ├── During repair, additional damage found
  ├── Supplement estimate: $1,100 additional
  ├── Supplement approved
  ├── Additional payment to shop: $1,100
  │
Day 14-18: COMPLETION
  │
  ├── Repairs completed
  ├── Insured picks up vehicle
  ├── Rental closed: 14 days × $35/day = $490
  ├── Rental payment issued: $490
  │
Day 18-20: SUBROGATION & CLOSURE
  │
  ├── Subrogation referral sent (not-at-fault; other driver's insurer known)
  ├── Demand sent to other insurer for $5,300 + $490 rental + $500 deductible
  ├── All reserves zeroed
  ├── Claim closed
  │
Day 20-90: SUBROGATION RECOVERY (POST-CLOSURE)
  │
  └── Recovery received: $6,290 (claim may briefly reopen for recovery posting)
```

### 12.2 Complex Auto Claim with Bodily Injury

```
Day 0: FNOL received — multi-vehicle accident, 2 injuries reported
  │
  ├── Claim created: CLM-2026-00200
  ├── Features: COLL, BI-1 (passenger in other car), BI-2 (other driver), PD
  ├── Assigned to Senior Auto Adjuster (handles both PD and BI)
  │
Day 0-3: INITIAL INVESTIGATION
  │
  ├── Contact insured — recorded statement
  ├── Request police report
  ├── Contact other driver (or their insurer/attorney)
  ├── Inspect insured's vehicle
  ├── Set initial reserves:
  │   COLL: $6,000 | BI-1: $15,000 | BI-2: $10,000 | PD: $8,000
  │
Day 3-10: LIABILITY INVESTIGATION
  │
  ├── Review police report
  ├── Interview witnesses
  ├── Obtain scene photos
  ├── Determine liability: Insured 80% at fault
  │
Day 3-14: VEHICLE RESOLUTION
  │
  ├── Insured vehicle: repaired at DRP, $5,800
  ├── Other vehicle: PD demand from other insurer, $7,500
  ├── Negotiate PD: settle at $7,500 × 80% = $6,000
  ├── Issue PD payment: $6,000
  ├── Close PD feature
  │
Day 10-30: INJURY MONITORING
  │
  ├── BI-1 (passenger): Obtain medical authorization
  ├── BI-1: Treatment ongoing — soft tissue (PT, chiropractic)
  ├── BI-2 (other driver): Attorney letter of representation received
  ├── BI-2: All communication now through attorney
  ├── Set diary: 30-day medical check-in
  │
Day 30-120: ONGOING BI MANAGEMENT
  │
  ├── BI-1: Treatment concludes. Medical specials: $8,500
  ├── BI-1: Evaluate general damages: $8,500 × 2.0 = $17,000
  ├── BI-1: Adjust for liability (80%): $17,000 × 80% = $13,600
  ├── BI-1: Negotiate directly with claimant; settle at $12,000
  ├── BI-1: Release signed, payment issued
  ├── BI-1: Feature closed
  │
  ├── BI-2: Attorney demand received: $75,000
  ├── BI-2: Medical specials: $22,000 (MRI, injections, PT)
  ├── BI-2: Review medical records, prior medical history
  ├── BI-2: IME scheduled (defense medical exam)
  │
Day 120-180: BI-2 NEGOTIATION
  │
  ├── IME report received: confirms soft tissue, no permanency
  ├── Evaluation: $22,000 specials × 2.5 = $55,000 full value
  ├── Adjust for liability: $55,000 × 80% = $44,000
  ├── Counter-offer to attorney: $30,000
  ├── Attorney counters: $50,000
  ├── Final offer: $38,000
  ├── Settlement reached: $38,000
  ├── Release signed
  ├── Payment issued to attorney trust account
  ├── BI-2 feature closed
  │
Day 180-185: CLAIM CLOSURE
  │
  ├── All features closed
  ├── Total paid: COLL $5,800 + PD $6,000 + BI-1 $12,000 + BI-2 $38,000 = $61,800
  ├── Claim closed
  └── No subrogation (insured was majority at-fault)
```

### 12.3 Homeowner Water Damage Claim

```
Day 0: FNOL received — burst pipe caused water damage to kitchen
  │
  ├── Claim created: CLM-2026-00300
  ├── Features: COV_A (Dwelling), COV_C (Contents), COV_D (ALE - if needed)
  ├── Assigned to Property Adjuster
  │
Day 0: EMERGENCY RESPONSE
  │
  ├── Contact insured immediately
  ├── Advise: shut off water, begin drying, call mitigation company
  ├── Authorize emergency mitigation (water extraction, dehumidifiers)
  ├── Mitigation company deploys ($3,000-$8,000 typical)
  │
Day 1-3: COVERAGE VERIFICATION
  │
  ├── Verify HO-3 policy in force
  ├── Confirm burst pipe is covered peril (sudden and accidental)
  ├── Check for water damage endorsements/exclusions
  ├── Check deductible: $1,000
  │
Day 3-7: FIELD INSPECTION
  │
  ├── Adjuster inspects property
  ├── Document all damage with photos
  ├── Moisture readings throughout affected areas
  ├── Scope of loss: kitchen floor, cabinets, drywall, baseboards
  ├── Check for mold (if >48 hours since loss)
  ├── Prepare Xactimate estimate
  │
Day 7-14: ESTIMATE & EVALUATION
  │
  ├── Xactimate estimate completed:
  │   ├── Mitigation: $5,500
  │   ├── Dwelling repairs (Cov A): $18,000 RCV / $14,000 ACV
  │   ├── Contents (Cov C): $3,500 RCV / $2,200 ACV
  │   └── Total RCV: $27,000 / Total ACV: $21,700
  │
  ├── Apply deductible: $1,000
  ├── Initial payment (ACV - deductible): $21,700 - $1,000 = $20,700
  ├── Recoverable depreciation held: $5,300
  │
Day 14-21: PAYMENT
  │
  ├── Issue payment #1: $20,700
  │   ├── Dwelling portion: $13,000 (payable to insured AND mortgage co.)
  │   └── Contents portion: $2,200 + Mitigation: $5,500 (payable to insured)
  ├── Note: mortgage company must endorse check for dwelling portion
  │
Day 21-90: REPAIRS
  │
  ├── Insured hires contractor
  ├── Contractor supplement request: additional $4,000 found behind walls
  ├── Supplement inspected and approved: $3,200 additional
  ├── Issue supplement payment: $3,200
  │
Day 90-120: RECOVERABLE DEPRECIATION
  │
  ├── Insured completes all repairs
  ├── Submits repair receipts as proof
  ├── Issue recoverable depreciation payment: $5,300
  │
Day 120-130: CLOSURE
  │
  ├── All repairs verified
  ├── Total paid: $20,700 + $3,200 + $5,300 = $29,200
  ├── Zero all reserves
  ├── Claim closed
  │
  └── Subrogation: If pipe failed due to manufacturer defect,
      refer to subrogation unit for product liability recovery
```

### 12.4 Homeowner Fire Loss (Large / Complex)

```
Day 0: FNOL — house fire, family displaced
  │
  ├── Claim created: CLM-2026-00400
  ├── Features: COV_A (Dwelling), COV_B (Other Structures — shed destroyed),
  │            COV_C (Contents), COV_D (ALE)
  ├── Assigned to Senior Property Adjuster
  ├── Large Loss alert triggered (est. > $100K)
  │
Day 0-1: EMERGENCY RESPONSE
  │
  ├── Contact insured — immediate needs assessment
  ├── Authorize emergency ALE: hotel, clothing, food advance ($5,000)
  ├── Board-up authorized for structure security
  ├── Contact fire department for fire report
  ├── Retain salvage/debris removal company
  │
Day 1-5: INITIAL INVESTIGATION
  │
  ├── Fire department report obtained
  ├── Origin and cause investigation:
  │   ├── If arson suspected → SIU referral
  │   ├── If accidental → document cause
  │   └── If undetermined → retain fire investigator
  ├── Coordinate with fire investigator (if needed)
  ├── Inspect property — document with photos/drone
  │
Day 5-15: DAMAGE ASSESSMENT
  │
  ├── Structural engineer assessment (if needed)
  ├── Xactimate estimate prepared:
  │   ├── Cov A (Dwelling): $285,000 RCV
  │   ├── Cov B (Shed): $15,000 RCV
  │   ├── Cov C (Contents): to be inventoried
  │   ├── Cov D (ALE): ongoing
  │   └── Estimated total: $400,000+
  │
  ├── Reserve set: $400,000 total
  ├── Reinsurance notification triggered (> treaty attachment point)
  │
Day 5-60: CONTENTS INVENTORY
  │
  ├── Insured prepares room-by-room contents inventory
  ├── Adjuster assists with valuation
  ├── High-value items verified (jewelry, art, electronics)
  ├── Apply sublimits where applicable
  ├── Contents total: $85,000 RCV / $52,000 ACV
  │
Day 15-30: ALE MANAGEMENT
  │
  ├── Insured secures temporary rental housing
  ├── ALE tracking begins:
  │   ├── Rental: $2,500/month
  │   ├── Increased food costs: $500/month
  │   ├── Storage: $200/month
  │   ├── Additional transportation: $300/month
  │   └── Monthly ALE: ~$3,500
  ├── ALE payments issued monthly
  │
Day 30-60: PROOF OF LOSS
  │
  ├── Proof of loss form sent to insured
  ├── Insured completes and returns sworn proof of loss
  ├── Review proof of loss for accuracy
  │
Day 30-90: PAYMENTS (PHASED)
  │
  ├── ACV payment for dwelling: $285,000 - $78,000 depreciation = $207,000
  │   (Two-party check with mortgage company)
  ├── ACV payment for contents: $52,000
  ├── Other structures: $12,000 ACV
  ├── ALE advances: ongoing monthly
  │
Day 90-365: REBUILD
  │
  ├── Insured hires contractor
  ├── Building permits obtained
  ├── Construction begins
  ├── Progress inspections by adjuster
  ├── Supplement requests reviewed and approved
  ├── Ongoing ALE payments during rebuild
  │
Day 365-400: COMPLETION & DEPRECIATION RECOVERY
  │
  ├── Rebuild complete — final inspection
  ├── Recoverable depreciation payment: $78,000 (dwelling) + $33,000 (contents) = $111,000
  ├── Final ALE payment
  │
Day 400-420: CLOSURE
  │
  ├── Total paid: Dwelling $285K + Contents $85K + Structures $15K + ALE $45K = $430K
  ├── Mortgage company endorsement obtained on all dwelling checks
  ├── Subrogation: if fire caused by defective product, pursue manufacturer
  ├── Salvage: debris removal complete, any salvageable items accounted for
  ├── All reserves zeroed
  ├── Claim closed
  └── Total claim duration: ~14 months
```

### 12.5 Commercial Property Claim

```
Day 0: FNOL — warehouse fire, significant business interruption
  │
  ├── Claim: CLM-2026-00500
  ├── Features: BLDG (Building), BPP (Contents/Stock), BI (Business Income),
  │            EXTRA_EXP (Extra Expense)
  ├── Assigned to Commercial Property Specialist
  ├── Large Loss team notified
  │
Day 0-3: EMERGENCY & INITIAL RESPONSE
  │
  ├── Contact insured — assess impact
  ├── Authorize emergency measures (board-up, security, temporary measures)
  ├── Review policy: CPP with Building, BPP, BI/EE coverage
  ├── Check coinsurance requirement (80%)
  ├── Retain forensic accountant for Business Income claim
  ├── Assign independent adjuster if needed
  │
Day 3-14: INVESTIGATION
  │
  ├── Fire origin & cause investigation
  ├── Building inspection with structural engineer
  ├── Inventory of damaged stock/equipment
  ├── Begin business income analysis:
  │   ├── Historical financial records (3 years P&L)
  │   ├── Sales trends and seasonality
  │   ├── Fixed vs. variable expenses
  │   └── Projected revenue loss
  │
Day 14-45: EVALUATION
  │
  ├── Building estimate: $1.2M RCV
  ├── BPP (stock/equipment): $450K
  ├── Coinsurance check:
  │   ├── Building value: $1.5M
  │   ├── Building limit: $1.2M (80% of $1.5M = exactly meets 80% coinsurance)
  │   ├── No coinsurance penalty
  ├── Business Income projection:
  │   ├── Monthly revenue: $200K
  │   ├── Monthly variable expenses saved: $80K
  │   ├── Monthly net BI loss: $120K/month
  │   ├── Estimated restoration period: 8 months
  │   ├── Total BI estimate: $960K
  ├── Extra expense: $150K (temporary location, expediting)
  │
  ├── Total reserve: $2.76M
  ├── Reinsurance notification
  │
Day 45-365: ONGOING MANAGEMENT
  │
  ├── Monthly advance BI payments: $100K/month
  ├── Building repair progress payments
  ├── BPP replacement tracking
  ├── Extra expense documentation and payment
  ├── Monthly forensic accounting updates
  ├── Quarterly reserve reviews
  │
Day 365-400: FINAL SETTLEMENT
  │
  ├── Business reopens
  ├── Final BI accounting:
  │   ├── Actual restoration period: 10 months
  │   ├── Total BI loss: $1.15M
  │   ├── Less advances paid: $900K
  │   ├── Final BI payment: $250K
  ├── Recoverable depreciation on building and BPP
  ├── Total paid: $2.95M
  ├── Claim closed
```

### 12.6 General Liability Claim (Slip and Fall)

```
Day 0: FNOL — customer slipped and fell in retail store
  │
  ├── Claim: CLM-2026-00600
  ├── Features: BI (Bodily Injury — claimant), MED_PAY (Medical Payments)
  ├── Assigned to GL/Liability Adjuster
  │
Day 0-5: INITIAL INVESTIGATION
  │
  ├── Contact insured business — obtain incident report
  ├── Request surveillance video
  ├── Interview store manager and employees
  ├── Contact claimant — obtain statement
  ├── Request inspection/maintenance records for area
  ├── Set initial reserves: BI $20K, ALAE $5K
  │
Day 5-14: LIABILITY INVESTIGATION
  │
  ├── Review surveillance video
  ├── Determine: was there a hazard? Notice? Reasonable care?
  ├── Document:
  │   ├── What caused the fall (wet floor, uneven surface, debris)
  │   ├── Was hazard created by insured or third party?
  │   ├── How long was hazard present? (constructive notice)
  │   ├── Were warning signs/cones placed?
  │   ├── Inspection log review
  │   └── Was claimant distracted/contributory?
  ├── Liability determination: Insured 70% liable (no warning signs)
  │
Day 14-30: MEDICAL PAYMENTS (Coverage C)
  │
  ├── Claimant submits ER bills: $2,500
  ├── Med Pay coverage: $5,000 per person (no-fault)
  ├── Pay medical bills under Med Pay: $2,500
  ├── Close Med Pay feature (if treatment concludes)
  │
Day 30-180: BI CLAIM DEVELOPMENT
  │
  ├── Claimant continues treatment
  ├── Monitor medical progress
  ├── Claimant retains attorney (Day 45)
  ├── All contact now through attorney
  ├── Diary for demand: 90-120 days
  │
Day 180-270: DEMAND & NEGOTIATION
  │
  ├── Demand received from attorney: $150,000
  │   ├── Medical specials: $35,000
  │   ├── Lost wages: $15,000
  │   ├── Pain and suffering: $100,000
  ├── Evaluate:
  │   ├── Specials reasonable? Review with nurse consultant
  │   ├── Lost wages documented? Tax returns, employer verification
  │   ├── General damages: $35K × 2.0 = $70K
  │   ├── Total value: $120K
  │   ├── Liability adjustment (70%): $84K
  ├── Counter-offer: $55,000
  ├── Negotiation: several rounds
  ├── Settlement: $72,000
  │
Day 270-280: SETTLEMENT & PAYMENT
  │
  ├── Release signed
  ├── Payment issued to attorney trust account: $72,000
  ├── Close BI feature
  ├── Claim closed
  ├── Total paid: $2,500 (Med Pay) + $72,000 (BI) + $3,000 (ALAE) = $77,500
```

### 12.7 Workers' Compensation Claim

```
Day 0: Employer reports employee injury (back injury lifting heavy box)
  │
  ├── Claim: WC-2026-00700
  ├── Features: MED (Medical), IND (Indemnity/Lost Time)
  ├── Assigned to Workers Comp Adjuster
  │
Day 0-1: INITIAL RESPONSE
  │
  ├── Contact employer — obtain First Report of Injury
  ├── Contact injured worker
  ├── Verify employment and coverage
  ├── File state-required forms (varies by state)
  ├── Direct employee to approved medical provider / panel
  ├── Set initial reserves: Medical $10K, Indemnity $15K
  │
Day 1-3: COMPENSABILITY DETERMINATION
  │
  ├── Review: Did injury arise out of and in course of employment?
  ├── Check: pre-existing condition? Was this a new injury or aggravation?
  ├── Accept or deny compensability (state-specific deadline)
  ├── If accepted: begin benefits
  ├── If denied: issue denial letter with appeal rights
  │
Day 3-14: INITIAL MEDICAL MANAGEMENT
  │
  ├── Review initial medical reports
  ├── Authorize treatment plan
  ├── Assign nurse case manager (if complex)
  ├── Begin medical bill review
  ├── Apply fee schedule (state-specific)
  ├── PPO network repricing
  │
Day 7-ongoing: INDEMNITY BENEFITS
  │
  ├── Determine waiting period (3-7 days, varies by state)
  ├── Calculate TTD rate:
  │   ├── Average Weekly Wage (AWW): $1,200
  │   ├── State TTD rate: 66.67% of AWW
  │   ├── Weekly benefit: $800
  │   ├── Subject to state max/min
  ├── Issue weekly/biweekly indemnity payments
  ├── Track return-to-work status
  │
Day 14-90: ONGOING MANAGEMENT
  │
  ├── Monitor treatment progress
  ├── Review medical bills (bill review vendor)
  ├── Pharmacy management (formulary compliance)
  ├── Physical therapy authorization
  ├── Light/modified duty coordination with employer
  ├── 30-day reserve review: adjust to $25K medical, $35K indemnity
  │
Day 90-180: RETURN TO WORK / MMI
  │
  ├── Employee reaches MMI (Maximum Medical Improvement)
  ├── Treating physician releases to full duty (best case)
  │   └── OR assigns permanent restrictions
  ├── If permanent restrictions:
  │   ├── Impairment rating obtained
  │   ├── PPD (Permanent Partial Disability) calculated per state schedule
  │   ├── Example: 10% whole person impairment = 50 weeks × $800 = $40,000
  ├── Employee returns to work
  ├── TTD benefits stop
  │
Day 180-240: PPD SETTLEMENT
  │
  ├── If PPD owed:
  │   ├── Negotiate lump-sum settlement (Compromise & Release)
  │   ├── OR pay weekly PPD per schedule
  ├── Medicare Set-Aside (MSA) consideration if applicable:
  │   ├── If claimant is Medicare-eligible or close
  │   ├── MSA amount calculated and funded
  ├── Settlement approved by WC board (if required by state)
  │
Day 240-270: CLOSURE
  │
  ├── All medical treatment concluded
  ├── All indemnity benefits paid
  ├── File state closing forms
  ├── Report to NCCI/state rating bureau
  ├── Total paid: Medical $18K + Indemnity (TTD) $14.4K + PPD $40K = $72.4K
  ├── Claim closed
  │
  └── NOTE: WC claims can reopen for medical treatment in many states
      (lifetime medical in some jurisdictions)
```

---

## 13. Parallel Processing Paths

### 13.1 Concurrent Workflow Streams

```
                         ┌── CLAIM CREATED ──┐
                         │                    │
              ┌──────────▼──────────┐         │
              │                     │         │
   ┌──────────▼──────┐  ┌──────────▼──────┐  │  ┌──────────────────┐
   │ COVERAGE         │  │ LIABILITY       │  │  │ DAMAGE           │
   │ VERIFICATION     │  │ INVESTIGATION   │  │  │ ASSESSMENT       │
   │                  │  │                 │  │  │                  │
   │ • Policy lookup  │  │ • Statements    │  │  │ • Inspection     │
   │ • Coverage check │  │ • Police report │  │  │ • Estimate       │
   │ • Exclusion      │  │ • Witnesses     │  │  │ • Valuation      │
   │   analysis       │  │ • Fault alloc.  │  │  │ • Total loss     │
   │ • ROR letter     │  │ • Negligence    │  │  │   determination  │
   │   (if needed)    │  │   analysis      │  │  │                  │
   └──────────┬───────┘  └──────────┬──────┘  │  └────────┬─────────┘
              │                     │         │           │
              └──────────┬──────────┘         │           │
                         │                    │           │
              ┌──────────▼──────────┐         │           │
              │ CONVERGENCE POINT    │◄────────┘───────────┘
              │                     │
              │ All three streams    │
              │ must complete before │
              │ evaluation can begin │
              └──────────┬──────────┘
                         │
                         ▼
              ┌─────────────────────┐
              │   EVALUATION &      │
              │   RESERVE SETTING   │
              └─────────────────────┘
```

### 13.2 Parallel Processing Rules

| Rule | Description |
|---|---|
| Coverage is independent | Coverage verification can proceed without waiting for investigation |
| Damage assessment is independent | Estimates can be obtained before liability is determined |
| Liability is independent | Fault determination can proceed without damage valuation |
| Evaluation requires all three | Cannot properly evaluate claim without coverage, liability, and damage data |
| Payments require coverage | Cannot issue payment if coverage is not confirmed |
| SIU can block all | SIU referral may freeze all processing pending investigation |

---

## 14. Reopening & Supplemental Claim Flows

### 14.1 Reopen Process Flow

```
START (Closed claim + trigger event)
  │
  ▼
┌─────────────────────────────┐
│ REOPEN TRIGGER RECEIVED      │
│ - Supplement request          │
│ - Lawsuit filed               │
│ - Subrogation recovery        │
│ - New information discovered  │
│ - Regulatory requirement      │
│ - Error correction            │
│ - Claimant dispute            │
└──────────┬──────────────────┘
           │
           ▼
┌─────────────────────────────┐
│ VALIDATE REOPEN REQUEST      │
│ - Statute of limitations     │
│   check                      │
│ - Policy period check         │
│ - Legitimate new information? │
│ - Approval required?          │
│   (Supervisor for reopens     │
│    > certain age/amount)      │
└──────────┬──────────────────┘
           │
           ▼
┌─────────────────────────────┐
│ REOPEN CLAIM                 │
│ - Set status: REOPENED        │
│ - Set reopen date             │
│ - Set reopen reason code      │
│ - Re-assign adjuster          │
│   (may be different than      │
│    original adjuster)         │
│ - Reopen applicable features  │
│ - Set reserves (new reserves  │
│   on reopened features)       │
│ - Generate activities         │
└──────────┬──────────────────┘
           │
           ▼
         PROCESS (Return to appropriate lifecycle stage)
```

### 14.2 Supplement Flow (Property / Auto)

```
START (Additional damage found during or after repair)
  │
  ▼
┌─────────────────────────────┐
│ SUPPLEMENT REQUEST RECEIVED   │
│ - Additional estimate from    │
│   repair shop/contractor      │
│ - Photos of new damage        │
│ - Description of additional   │
│   work needed                 │
└──────────┬──────────────────┘
           │
           ▼
┌─────────────────────────────┐
│ REVIEW SUPPLEMENT             │
│ - Is additional damage        │
│   related to original loss?   │
│ - Is pricing reasonable?      │
│ - Was damage pre-existing?    │
│ - Does supplement change       │
│   total loss determination?   │
└──────────┬──────────────────┘
           │
           ├── APPROVED → Adjust reserve, issue payment
           ├── PARTIALLY APPROVED → Negotiate, pay approved portion
           └── DENIED → Notify with reason
```

---

## 15. Diary & Follow-Up Management

### 15.1 Diary System Design

```
┌─────────────────────────────────────────────────────────┐
│                    DIARY ENGINE                           │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  DIARY TYPES:                                           │
│  ├── System-Generated (Automatic)                       │
│  │   ├── SLA-based (contact SLA, acknowledgment SLA)    │
│  │   ├── Rule-based (reserve review every 30 days)      │
│  │   └── Event-based (payment issued → follow up)       │
│  │                                                      │
│  └── User-Created (Manual)                              │
│      ├── Follow-up with claimant                        │
│      ├── Follow-up on documents                         │
│      └── Supervisor review request                      │
│                                                         │
│  DIARY STATES:                                          │
│  ├── Pending (not yet due)                              │
│  ├── Due (due date reached)                             │
│  ├── Overdue (past due date)                            │
│  ├── Completed                                          │
│  ├── Cancelled                                          │
│  └── Escalated (auto-escalated to supervisor)           │
│                                                         │
│  ESCALATION RULES:                                      │
│  ├── Due + 1 day → Email reminder to adjuster           │
│  ├── Due + 3 days → Flagged as overdue; supervisor alert│
│  ├── Due + 7 days → Auto-escalate to supervisor queue   │
│  └── Due + 14 days → Manager notification               │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

### 15.2 Standard Diary Schedules

| Diary Type | Frequency | Trigger | Description |
|---|---|---|---|
| Initial Contact | Once | Claim assignment | Contact insured within SLA (24-48 hrs) |
| Reserve Review | 30/60/90 days | Time-based | Regular review of reserve adequacy |
| Medical Status | 30 days | Injury claim open | Check treatment status |
| Attorney Response | 30 days | Demand sent | Follow up on attorney response |
| Document Follow-Up | 14 days | Document requested | Follow up on requested documents |
| Repair Status | 7 days | Vehicle/property in repair | Check repair progress |
| Rental Check | 14 days | Rental authorized | Verify rental still needed |
| Subrogation Check | 30 days | Subro demand sent | Follow up on recovery |
| Supervisor Review | 90 days | Complex/high value | Mandatory supervisor review |
| Litigation Status | 30 days | In litigation | Defense counsel status check |
| ALE Verification | 30 days | ALE being paid | Verify ongoing need for ALE |
| Return to Work | 14 days | WC lost-time claim | Check RTW status |

---

## 16. Escalation Paths & Authority Levels

### 16.1 Escalation Matrix

```
┌──────────────────────────────────────────────────────────────────────┐
│                     ESCALATION HIERARCHY                              │
├──────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  Level 1: ADJUSTER                                                   │
│  └── Handles: routine claims within authority                        │
│      Authority: $15K-$50K (varies by experience)                     │
│                                                                      │
│  Level 2: SENIOR ADJUSTER / TEAM LEAD                                │
│  └── Escalation triggers:                                            │
│      - Reserve/payment exceeds Level 1 authority                     │
│      - Complex coverage issues                                       │
│      - Quality audit findings                                        │
│      Authority: $50K-$100K                                           │
│                                                                      │
│  Level 3: EXAMINER / SUPERVISOR                                      │
│  └── Escalation triggers:                                            │
│      - Reserve/payment exceeds Level 2 authority                     │
│      - Litigation potential                                          │
│      - SIU referral decisions                                        │
│      - Reservation of rights                                         │
│      - Coverage denial approval                                      │
│      Authority: $100K-$500K                                          │
│                                                                      │
│  Level 4: CLAIMS MANAGER                                             │
│  └── Escalation triggers:                                            │
│      - Reserve/payment exceeds Level 3 authority                     │
│      - Bad faith potential                                           │
│      - DOI complaint                                                 │
│      - Media/public exposure                                         │
│      Authority: $500K-$1M                                            │
│                                                                      │
│  Level 5: VP / SVP CLAIMS                                            │
│  └── Escalation triggers:                                            │
│      - Reserve/payment exceeds Level 4 authority                     │
│      - Class action / mass tort                                      │
│      - Reinsurance-level losses                                      │
│      - Regulatory action                                             │
│      Authority: $1M-$5M                                              │
│                                                                      │
│  Level 6: C-SUITE / CLAIMS COMMITTEE                                 │
│  └── Escalation triggers:                                            │
│      - Catastrophe-level events                                      │
│      - Systemic coverage issues                                      │
│      - Board-level financial impact                                  │
│      Authority: Unlimited                                            │
│                                                                      │
└──────────────────────────────────────────────────────────────────────┘
```

### 16.2 Automatic Escalation Triggers

| Trigger | Threshold | Escalation Target |
|---|---|---|
| Reserve amount | > Adjuster authority | Next level supervisor |
| Single payment | > Adjuster authority | Next level supervisor |
| Claim age | > 180 days open (auto PD) | Supervisor review |
| Claim age | > 1 year open (auto BI) | Manager review |
| Claim age | > 2 years open (any) | VP review |
| SLA breach | Contact SLA missed | Supervisor notification |
| SLA breach | 3+ SLAs missed on one claim | Manager notification |
| DOI complaint | Any DOI complaint received | Manager + Compliance |
| Bad faith allegation | Any bad faith claim | VP Claims + Legal |
| Attorney LOR | Letter of representation received | Auto-reassign to BI unit if needed |
| Lawsuit filed | Summons/complaint received | Litigation unit + Defense counsel assignment |
| Fatality | Death reported on claim | Manager + VP notification |
| Media inquiry | Press/media contact about claim | VP + Communications |

---

## 17. Batch Processing Flows

### 17.1 Bulk Payment Processing

```
DAILY BATCH — CHECK DISBURSEMENT
  │
  ├── 1. Gather all approved payments (status = APPROVED)
  ├── 2. Validate banking details / addresses
  ├── 3. Group by payment method (check vs. EFT vs. wire)
  ├── 4. Generate check file (positive pay format)
  ├── 5. Generate EFT/ACH file (NACHA format)
  ├── 6. Submit files to bank
  ├── 7. Receive confirmation
  ├── 8. Update payment statuses to ISSUED
  ├── 9. Update reserve positions
  └── 10. Generate disbursement register
  
WEEKLY BATCH — WORKERS COMP INDEMNITY
  │
  ├── 1. Identify all open WC claims with active TTD/TPD
  ├── 2. Calculate weekly benefit amount per claim
  ├── 3. Verify no return-to-work or benefit change
  ├── 4. Generate batch of indemnity payments
  ├── 5. Apply state-specific rules (waiting period, offset)
  ├── 6. Process payments (EFT preferred)
  └── 7. Update reserves
```

### 17.2 Catastrophe Declaration Processing

```
CAT EVENT DECLARED
  │
  ├── 1. Create catastrophe event record (PCS number, event type, affected geography)
  ├── 2. Define affected geographic zones (ZIP codes, counties, states)
  ├── 3. Identify existing open claims in affected area → flag as CAT
  ├── 4. Incoming FNOLs: auto-tag with CAT code based on loss date + location
  ├── 5. Activate surge FNOL handling:
  │   ├── Additional call center capacity
  │   ├── Simplified FNOL data capture (minimum viable data)
  │   ├── Expedited assignment rules (IA/CAT adjuster deployment)
  │   └── Auto-reserve rules (table-driven by loss type)
  ├── 6. Deploy CAT adjusters:
  │   ├── Mass assignment based on geographic zones
  │   ├── Temporary authority increases
  │   └── Streamlined payment approval
  ├── 7. Establish CAT communication:
  │   ├── Proactive outreach to policyholders in affected zones
  │   ├── Policyholder communication portal/hotline
  │   └── Agent/broker notifications
  ├── 8. Financial monitoring:
  │   ├── Aggregate CAT loss tracking
  │   ├── Reinsurance treaty attachment monitoring
  │   └── Reserve adequacy at CAT event level
  └── 9. Regulatory reporting:
      ├── State DOI notifications
      ├── NAIC data calls
      └── PCS reporting
```

### 17.3 Mass Reassignment

```
MASS REASSIGNMENT TRIGGER (adjuster departure, reorganization, workload rebalancing)
  │
  ├── 1. Identify claims to reassign:
  │   ├── All claims for departing adjuster
  │   ├── OR claims matching reassignment criteria
  ├── 2. Categorize claims by:
  │   ├── Priority (litigation, large loss, SIU, routine)
  │   ├── Complexity tier
  │   └── Claim type / LOB
  ├── 3. Identify receiving adjusters:
  │   ├── Available capacity
  │   ├── Skill match
  │   └── License/authority match
  ├── 4. Apply assignment algorithm (batch mode)
  ├── 5. Execute reassignment:
  │   ├── Update assigned adjuster on each claim
  │   ├── Transfer all open activities
  │   ├── Transfer diary items
  │   ├── Notify receiving adjusters
  │   └── Log reassignment audit trail
  └── 6. Post-reassignment:
      ├── Generate reassignment summary report
      ├── Monitor new adjuster workloads
      └── Flag any claims needing immediate attention
```

---

## 18. Exception Handling Processes

### 18.1 Coverage Dispute / Appraisal Process

```
APPRAISAL CLAUSE INVOKED (either party disputes loss amount, not coverage)
  │
  ├── 1. Written demand for appraisal received
  ├── 2. Each party selects an appraiser (within 20 days typically)
  ├── 3. Appraisers agree on an umpire (or court appoints)
  ├── 4. Each appraiser prepares independent estimate
  ├── 5. Appraisers attempt to agree
  │   ├── If agreed → binding on both parties
  │   └── If disagreed → submit to umpire
  ├── 6. Umpire decides; agreement of umpire + one appraiser = binding
  ├── 7. Adjust reserve and payment to appraisal result
  └── 8. Each party bears own appraiser cost; umpire cost split
```

### 18.2 Bad Faith Handling

```
BAD FAITH ALLEGATION RECEIVED
  │
  ├── 1. IMMEDIATE ESCALATION to VP Claims + Legal
  ├── 2. Claim handling freeze (no actions without Legal approval)
  ├── 3. Preserve all claim file materials (litigation hold)
  ├── 4. Internal review of claim handling:
  │   ├── Timeline compliance (SLAs met?)
  │   ├── Communication adequacy (prompt responses?)
  │   ├── Investigation thoroughness
  │   ├── Reserve adequacy history
  │   ├── Payment timeliness
  │   └── Unfair claims practices compliance
  ├── 5. Engage coverage counsel for bad faith exposure assessment
  ├── 6. Consider immediate resolution of underlying claim
  └── 7. Report to E&O / D&O carrier if needed
```

### 18.3 Regulatory Complaint Process

```
DOI COMPLAINT RECEIVED
  │
  ├── 1. Log complaint in complaint tracking system
  ├── 2. Route to Compliance unit
  ├── 3. Compliance reviews claim file
  ├── 4. Prepare response within state-mandated timeframe
  │   (typically 15-30 days)
  ├── 5. Response includes:
  │   ├── Claim handling timeline
  │   ├── Explanation of decisions
  │   ├── Supporting documentation
  │   └── Corrective action (if warranted)
  ├── 6. Submit response to DOI
  ├── 7. Track DOI disposition
  └── 8. If complaint upheld → corrective action + process improvement
```

---

## 19. SLA Definitions & Measurements

### 19.1 Core Claims SLAs

| SLA Name | Target | Measurement | Typical Standard |
|---|---|---|---|
| FNOL Acknowledgment | Time from FNOL receipt to acknowledgment letter/email | System timestamp | 24 hours |
| Initial Contact | Time from assignment to first contact with insured | Activity completion timestamp | 24-48 hours |
| Claimant Contact | Time from assignment to first contact with claimant | Activity completion timestamp | 48-72 hours |
| Coverage Determination | Time from FNOL to coverage decision | Coverage status timestamp | 30 days (varies by state) |
| Vehicle Inspection | Time from assignment to vehicle inspected | Inspection timestamp | 5 business days |
| Property Inspection | Time from assignment to property inspected | Inspection timestamp | 5-7 business days |
| Estimate Completion | Time from inspection to estimate delivered | Estimate timestamp | 3-5 business days |
| Payment Issuance | Time from settlement agreement to payment issued | Payment timestamp | 5-10 business days (varies by state) |
| Reserve Setting | Time from assignment to initial reserve set | Reserve transaction timestamp | 48-72 hours |
| Reserve Review | Frequency of reserve review | Last review timestamp | Every 30-90 days |
| Diary Compliance | Percentage of diaries completed on time | Diary completion vs. due date | 95% on-time |
| Cycle Time (Auto PD) | Total time from FNOL to closure | Claim dates | 30-45 days |
| Cycle Time (Auto BI) | Total time from FNOL to closure | Claim dates | 180-365 days |
| Cycle Time (HO Property) | Total time from FNOL to closure | Claim dates | 30-90 days |
| Cycle Time (CGL) | Total time from FNOL to closure | Claim dates | 365-730 days |
| Cycle Time (WC) | Total time from FNOL to closure | Claim dates | 60-365 days |

### 19.2 State-Mandated Timelines (Examples)

| State | Requirement | Timeline |
|---|---|---|
| California | Acknowledge receipt of claim | 15 days |
| California | Accept or deny claim | 40 days |
| California | Payment after proof of loss | 30 days |
| Texas | Acknowledge receipt | 15 business days |
| Texas | Accept or deny | 15 business days after all info received |
| Texas | Payment after acceptance | 5 business days |
| Florida | Acknowledge receipt | 14 days |
| Florida | Pay or deny | 90 days |
| New York | Acknowledge receipt | 15 business days |
| New York | Payment upon proof of loss | 30 days |
| All States | Unfair Claims Settlement Practices Act | Varies; based on NAIC model |

### 19.3 KPI Dashboard Metrics

| KPI | Formula | Target |
|---|---|---|
| Closing Ratio | Claims Closed / Claims Opened (period) | > 1.0 (closing more than opening) |
| Open Inventory | Total open claims at point in time | Trending down or stable |
| Average Cycle Time | Avg (Close Date - Report Date) by type | Below benchmark |
| SLA Compliance Rate | % of SLAs met / Total SLAs measured | > 90% |
| Reserve Accuracy | Actual Ultimate / Initial Reserve | 0.95-1.05 (±5%) |
| Severity (Average Paid) | Total Paid / Claim Count | Trending per inflation |
| Frequency | Claims per Exposure Unit | Trending down |
| ALAE Ratio | ALAE / Loss Paid | < 10-15% |
| Subrogation Recovery Rate | Recoveries / Eligible Losses | > 50% |
| Customer Satisfaction (NPS) | Survey-based | > 50 |
| Adjuster Productivity | Claims Closed per Adjuster per Month | 30-50 (varies by type) |
| Touch Count | Avg number of activities per claim | Lower is better (efficiency) |

---

## 20. BPMN-Style Process Descriptions

### 20.1 BPMN Elements Reference

```
BPMN Element Mapping for Text-Based Diagrams:

  (○) — Start Event
  (●) — End Event
  [□] — Task/Activity
  <◇> — Gateway (Decision/Parallel/Inclusive)
  (◎) — Intermediate Event (Timer, Message, Signal)
  [═] — Subprocess
  ──► — Sequence Flow
  - - ► — Message Flow
  ║   — Pool/Lane Boundary
```

### 20.2 Auto Claim BPMN Process

```
Pool: INSURANCE COMPANY
═══════════════════════════════════════════════════════════════════
Lane: CALL CENTER
───────────────────────────────────────────────────────────────────
  (○)──►[Receive FNOL Call]──►[Verify Policy]──►<◇ Policy Valid?>
                                                  │YES        │NO
                                                  ▼           ▼
                                        [Capture Loss    [Advise Caller]──►(●)
                                         Details]
                                            │
                                            ▼
                                        [Create Claim]──►[Dup Check]
                                                              │
                                                              ▼
                                                         <◇ Dup?>
                                                          │NO  │YES
                                                          ▼    ▼
                                                    [Triage] [Merge]
                                                       │
═══════════════════════════════════════════════════════════════════
Lane: ASSIGNMENT ENGINE
───────────────────────────────────────────────────────────────────
                                                       │
                                                       ▼
                                              [Score Complexity]
                                                       │
                                                       ▼
                                              <◇ STP Eligible?>
                                               │YES        │NO
                                               ▼           ▼
                                        [Auto-Process] [Select Adjuster]
                                             │              │
                                             ▼              ▼
                                           (●)      [Assign Claim]
                                                         │
═══════════════════════════════════════════════════════════════════
Lane: ADJUSTER
───────────────────────────────────────────────────────────────────
                                                         │
                                                         ▼
                                              [Contact Insured]
                                                         │
                                                         ▼
                                    ┌────────<◇>─────────┐ (PARALLEL)
                                    ▼                    ▼
                           [Investigate         [Verify Coverage]
                            Liability]                   │
                                │                        ▼
                                ▼                [Coverage Decision]
                           [Determine Fault]             │
                                │                        │
                                ▼                        │
                           [Order Estimate]              │
                                │                        │
                                ▼                        │
                           [Review Estimate]             │
                                │                        │
                                └────────►<◇>◄───────────┘ (CONVERGE)
                                           │
                                           ▼
                                    [Set Reserves]
                                           │
                                           ▼
                                    <◇ Total Loss?>
                                     │NO        │YES
                                     ▼          ▼
                              [Authorize   [Negotiate TL
                               Repairs]     Settlement]
                                  │              │
                                  ▼              ▼
                              [Process     [Process TL
                               Payment]    Payment + Salvage]
                                  │              │
                                  ▼              ▼
                              <◇ Subrog?>    <◇ Subrog?>
                               │YES  │NO     │YES  │NO
                               ▼     ▼       ▼     ▼
                           [Refer]  [Close] [Refer] [Close]
                              │        │      │       │
                              ▼        ▼      ▼       ▼
                            (●)      (●)    (●)     (●)
═══════════════════════════════════════════════════════════════════
```

### 20.3 Property Claim BPMN Process (Simplified)

```
(○)──►[FNOL]──►[Verify Policy]──►[Assign Adjuster]
                                        │
                                        ▼
                                [Contact Insured]──►[Authorize Emergency Mitigation]
                                        │
                                        ▼
                            ┌───<◇ PARALLEL>───┐
                            ▼                   ▼
                    [Field Inspection]    [Coverage Review]
                            │                   │
                            ▼                   │
                    [Prepare Xactimate]         │
                            │                   │
                            └───►<◇ JOIN>◄──────┘
                                    │
                                    ▼
                            [Calculate Payment]
                                    │
                                    ▼
                            [Apply Deductible]
                                    │
                                    ▼
                            [Apply Depreciation (ACV)]
                                    │
                                    ▼
                            <◇ Mortgage?>
                             │YES       │NO
                             ▼          ▼
                    [Two-Party Check] [Single Check]
                             │          │
                             └──►<◇>◄───┘
                                  │
                                  ▼
                            [Issue Payment]
                                  │
                                  ▼
                            (◎ Timer: Repairs Complete?)
                                  │
                                  ▼
                            <◇ RCV Policy?>
                             │YES       │NO
                             ▼          ▼
                    [Issue Depreciation  [Close Claim]──►(●)
                     Holdback Payment]
                             │
                             ▼
                    [Close Claim]──►(●)
```

---

*End of Article 2 — Claims Lifecycle: End-to-End Process Flows*
