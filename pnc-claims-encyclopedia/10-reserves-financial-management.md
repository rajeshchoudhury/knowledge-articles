# Article 10: Reserves & Financial Management in Claims

## A Comprehensive Guide for Solutions Architects

---

## Table of Contents

1. [Reserve Definition & Purpose](#1-reserve-definition--purpose)
2. [Types of Reserves](#2-types-of-reserves)
3. [Reserve Setting Methodologies](#3-reserve-setting-methodologies)
4. [Initial Reserve Calculation Rules by LOB](#4-initial-reserve-calculation-rules-by-lob)
5. [Reserve Adequacy & Stairstepping Detection](#5-reserve-adequacy--stairstepping-detection)
6. [Actuarial Methods](#6-actuarial-methods)
7. [Loss Development Triangles](#7-loss-development-triangles)
8. [IBNR Calculation Methodologies](#8-ibnr-calculation-methodologies)
9. [Reserve Change Workflow](#9-reserve-change-workflow)
10. [Authority Levels for Reserve Changes](#10-authority-levels-for-reserve-changes)
11. [Automated Reserve Setting Algorithms](#11-automated-reserve-setting-algorithms)
12. [Financial Transactions in Claims](#12-financial-transactions-in-claims)
13. [Payment Types](#13-payment-types)
14. [Payment Processing Methods](#14-payment-processing-methods)
15. [Payment Approval Workflows](#15-payment-approval-workflows)
16. [1099 Reporting Requirements](#16-1099-reporting-requirements)
17. [Claims Financial Accounting: SAP vs GAAP](#17-claims-financial-accounting-sap-vs-gaap)
18. [Schedule P Reporting](#18-schedule-p-reporting)
19. [Loss Ratio Calculation & Monitoring](#19-loss-ratio-calculation--monitoring)
20. [LAE Ratio Analysis](#20-lae-ratio-analysis)
21. [Bulk Reserve Methodologies](#21-bulk-reserve-methodologies)
22. [Reinsurance Reserve Allocation](#22-reinsurance-reserve-allocation)
23. [Financial Data Model](#23-financial-data-model)
24. [General Ledger Integration](#24-general-ledger-integration)
25. [Claims Financial Dashboard](#25-claims-financial-dashboard)
26. [Audit Trail Requirements](#26-audit-trail-requirements)
27. [Reconciliation Processes](#27-reconciliation-processes)
28. [Month-End & Year-End Close](#28-month-end--year-end-close)
29. [Sample Financial Formats & GL Mappings](#29-sample-financial-formats--gl-mappings)

---

## 1. Reserve Definition & Purpose

### 1.1 What Are Reserves?

Reserves are the estimated liability an insurance carrier establishes for the cost of settling unpaid claims. They represent the carrier's best estimate of what will ultimately be paid on open claims and claims that have been incurred but not yet reported (IBNR). Reserves are the single largest liability on an insurance company's balance sheet.

```
RESERVE COMPONENTS ON THE BALANCE SHEET
==========================================

LIABILITIES (P&C Insurance Company)
├── Loss Reserves (Case Reserves)
│   ├── Indemnity reserves for open claims
│   ├── ALAE reserves for open claims
│   └── Represent estimated future payments on known claims
│
├── IBNR Reserves (Incurred But Not Reported)
│   ├── Pure IBNR: Claims not yet reported
│   ├── Development on known claims: Expected future changes
│   │   to reserves on already-reported claims
│   └── Calculated by actuaries using statistical methods
│
├── ULAE Reserves (Unallocated Loss Adjustment Expenses)
│   ├── Internal claims handling costs not charged to specific claims
│   ├── Salaries of adjusters, rent, IT systems, etc.
│   └── Estimated as percentage of losses
│
├── Salvage & Subrogation Anticipated
│   ├── Expected recoveries (reduces gross reserves)
│   └── Based on historical recovery patterns
│
└── TOTAL LOSS AND LAE RESERVES
    = Case Reserves + IBNR + ULAE - Anticipated S&S

TYPICAL SIZE:
  Large national carrier: $30-$80 billion in reserves
  Mid-size regional:      $1-$10 billion
  Small specialty:        $100M-$1 billion

IMPORTANCE:
  ├── Largest liability item (60-70% of total liabilities)
  ├── Directly affects reported profitability
  ├── Regulators monitor reserve adequacy
  ├── Affects policyholder surplus (solvency measure)
  ├── Impacts reinsurance calculations
  └── Investor/rating agency scrutiny
```

### 1.2 Reserve Accuracy Impact

| Reserve Position | Financial Impact | Regulatory Impact | Business Impact |
|---|---|---|---|
| Under-reserved (too low) | Overstates income, hidden losses | Potential solvency concern | Inadequate pricing, false profitability |
| Adequately reserved | Accurate income statement | Regulatory compliance | Sound business decisions |
| Over-reserved (too high) | Understates income, hidden surplus | Generally acceptable | Conservative pricing, lower ROE |
| Stairstepping (gradual increases) | Volatility in earnings | Signal of poor estimation | Erodes stakeholder confidence |

---

## 2. Types of Reserves

### 2.1 Reserve Taxonomy

```
RESERVE TYPE TAXONOMY
=======================

BY CATEGORY:
  ┌─────────────────────────────────────────────────┐
  │ INDEMNITY RESERVES                               │
  │                                                   │
  │ The estimated cost of the loss itself:            │
  │ ├── Property damage repair/replacement            │
  │ ├── Bodily injury settlement/judgment             │
  │ ├── Medical payments                              │
  │ ├── Disability benefits (WC)                      │
  │ ├── Death benefits                                │
  │ └── Other covered loss amounts                    │
  └─────────────────────────────────────────────────┘

  ┌─────────────────────────────────────────────────┐
  │ ALAE RESERVES (Allocated Loss Adjustment Exp.)   │
  │                                                   │
  │ Costs that can be assigned to a specific claim:  │
  │ ├── Independent adjuster fees                     │
  │ ├── Legal defense costs (attorney fees)           │
  │ ├── Expert witness fees                           │
  │ ├── Court costs                                   │
  │ ├── Independent medical exams (IME)               │
  │ ├── Surveillance costs                            │
  │ ├── Engineering/forensic expert fees              │
  │ ├── Appraisal fees                                │
  │ └── Accident reconstruction costs                 │
  └─────────────────────────────────────────────────┘

  ┌─────────────────────────────────────────────────┐
  │ ULAE RESERVES (Unallocated Loss Adjustment Exp.) │
  │                                                   │
  │ Internal overhead costs not tied to specific      │
  │ claims:                                           │
  │ ├── Claims staff salaries and benefits            │
  │ ├── Office rent and utilities                     │
  │ ├── IT systems and technology costs               │
  │ ├── Training costs                                │
  │ ├── Management overhead                           │
  │ └── General administrative costs                  │
  │                                                   │
  │ Typically calculated as % of losses:              │
  │   Auto PD: 3-7% of indemnity                     │
  │   Auto BI: 8-15% of indemnity                    │
  │   Property: 5-10% of indemnity                   │
  │   WC: 10-18% of indemnity                        │
  │   GL: 10-20% of indemnity                        │
  └─────────────────────────────────────────────────┘

  ┌─────────────────────────────────────────────────┐
  │ SALVAGE AND SUBROGATION RESERVES                 │
  │                                                   │
  │ Anticipated recoveries that offset gross reserves:│
  │ ├── Salvage: Recovery from sale of damaged assets │
  │ ├── Subrogation: Recovery from responsible parties│
  │ └── Deductible recoveries (large deductible pols)│
  │                                                   │
  │ Treatment:                                        │
  │   May be carried as a contra-liability            │
  │   (reduces gross reserves to net reserves)        │
  │   Based on historical recovery percentages        │
  └─────────────────────────────────────────────────┘

BY ESTIMATION METHOD:
  ┌─────────────────────────────────────────────────┐
  │ CASE RESERVES                                     │
  │ Set by adjusters on individual open claims        │
  │ Based on claim-specific facts and circumstances   │
  │ Updated as new information becomes available      │
  └─────────────────────────────────────────────────┘

  ┌─────────────────────────────────────────────────┐
  │ BULK / IBNR RESERVES                              │
  │ Set by actuaries for the portfolio                │
  │ Includes pure IBNR and development on known claims│
  │ Statistical methods (chain ladder, B-F, etc.)     │
  └─────────────────────────────────────────────────┘
```

---

## 3. Reserve Setting Methodologies

### 3.1 Individual Case Method

```
INDIVIDUAL CASE RESERVE METHOD
=================================

Process:
  1. Adjuster reviews claim facts:
     ├── Type of loss and coverage
     ├── Severity of damage/injury
     ├── Medical treatment and prognosis (BI)
     ├── Legal representation
     ├── Jurisdiction (venue)
     ├── Liability assessment
     └── Special circumstances

  2. Adjuster estimates ultimate cost:
     ├── Indemnity: Expected settlement or judgment amount
     ├── ALAE: Expected legal and expert costs
     └── Total reserve: Indemnity + ALAE

  3. Reserve documented with basis:
     ├── Comparable claims analysis
     ├── Current treatment information
     ├── Verdict/settlement research
     ├── Expert opinions
     └── Professional judgment

Advantages:
  ├── Claim-specific, considers unique circumstances
  ├── Adjusters closest to the facts
  └── Reflects current information

Disadvantages:
  ├── Subject to adjuster experience and bias
  ├── Inconsistency across adjusters
  ├── Often under-reserved early (optimism bias)
  ├── Stairstepping pattern (gradual increases)
  └── Time-consuming for high-volume operations
```

### 3.2 Tabular Method

```
TABULAR RESERVE METHOD
========================

Used primarily for: Workers compensation disability benefits

Process:
  1. Determine benefit type and rate:
     ├── TTD: 2/3 of AWW × expected weeks of disability
     ├── PPD: Scheduled benefits based on impairment rating
     ├── PTD: Weekly benefit × life expectancy (discounted)
     └── Medical: Based on diagnosis and treatment guidelines

  2. Apply tabular values:
     ├── Duration tables (expected weeks of disability by injury type)
     ├── Life tables (mortality for PTD/death benefits)
     ├── Wage tables (for AWW calculation)
     └── Medical cost tables (expected treatment cost by diagnosis)

  3. Calculate reserve:
     reserve = benefit_rate × expected_duration × discount_factor

Example (TTD):
  AWW: $1,000
  TTD Rate: $666.67/week (2/3 of AWW)
  Expected disability: 12 weeks
  Reserve: $666.67 × 12 = $8,000.04
  Less: Waiting period (7 days): -$666.67
  Net reserve: $7,333.37
```

### 3.3 Factor Method

```
FACTOR METHOD
===============

Process:
  1. Start with known data point (e.g., initial estimate or first payment)
  2. Multiply by development factor derived from historical experience
  3. Factor varies by claim type, age, severity, and other attributes

Formula:
  Ultimate_Reserve = Current_Known_Amount × Development_Factor

Example:
  Claim type: Auto BI
  Current medical specials: $15,000
  Historical specials-to-settlement factor: 3.5
  Estimated ultimate: $15,000 × 3.5 = $52,500

Factor Tables (Sample):
  ┌──────────────┬──────────┬─────────┬──────────┬──────────┐
  │ Claim Type   │ Factor   │ Applied │ Factor   │ Notes    │
  │              │ Name     │ To      │ Value    │          │
  ├──────────────┼──────────┼─────────┼──────────┼──────────┤
  │ Auto BI      │ Specials │Medical  │ 2.5-5.0  │Varies by │
  │ (soft tissue)│ multiplier│specials │          │severity  │
  │ Auto BI      │ Specials │Medical  │ 1.5-3.0  │More      │
  │ (fracture)   │ multiplier│specials │          │objective │
  │ Auto PD      │ Estimate │Initial  │ 1.05-1.15│Supplement│
  │              │ dev.     │estimate │          │factor    │
  │ Property     │ Estimate │Xactimate│ 1.10-1.25│Code + dep│
  │              │ dev.     │estimate │          │recovery  │
  │ WC Medical   │ Treatment│Initial  │ 1.5-4.0  │Depends on│
  │              │ dev.     │medical  │          │diagnosis │
  └──────────────┴──────────┴─────────┴──────────┴──────────┘
```

### 3.4 Loss Development Method

```
LOSS DEVELOPMENT METHOD
=========================

Used for: Portfolio-level reserve estimation (actuarial)

Process:
  1. Organize historical paid/incurred losses by accident year and maturity
  2. Calculate age-to-age development factors
  3. Select/smooth development factors
  4. Apply cumulative factors to estimate ultimate losses
  5. Compare to current reserves to determine adequacy

(See Section 7 for detailed triangle methodology)
```

---

## 4. Initial Reserve Calculation Rules by LOB

### 4.1 Auto Physical Damage

```
AUTO PD INITIAL RESERVE RULES
================================

RULE RESV-APD-001: GLASS ONLY
  IF claim.type == 'GLASS':
    indemnity = glassSchedule.lookup(vehicle, glassType)
    expense = 0
    TOTAL = indemnity

RULE RESV-APD-002: MINOR COLLISION (estimate < $3,000)
  IF claim.type == 'COLLISION' AND estimate <= 3000:
    indemnity = estimate (if available) OR 2500 (default)
    expense = 200
    TOTAL = indemnity + expense

RULE RESV-APD-003: MODERATE COLLISION ($3,000-$10,000)
  IF claim.type == 'COLLISION' AND 3000 < estimate <= 10000:
    indemnity = estimate (if available) OR 6500 (default)
    expense = 500
    TOTAL = indemnity + expense

RULE RESV-APD-004: MAJOR COLLISION (>$10,000)
  IF claim.type == 'COLLISION' AND estimate > 10000:
    indemnity = estimate
    expense = 750
    TOTAL = indemnity + expense

RULE RESV-APD-005: TOTAL LOSS
  IF claim.severity == 'TOTAL_LOSS':
    indemnity = vehicle.ACV - deductible
    expense = 1200  (appraisal, title processing, rental, tow)
    salvage_offset = vehicle.ACV × salvageRate[vehicle.age]
    TOTAL = indemnity + expense - salvage_offset

RULE RESV-APD-006: COMPREHENSIVE (THEFT)
  IF claim.type == 'COMP' AND claim.causeOfLoss == 'THEFT':
    IF vehicle.recovered == false:
      indemnity = vehicle.ACV - deductible
      expense = 800
    ELSE:
      indemnity = theft_damage_estimate (or 3000 default)
      expense = 500

RULE RESV-APD-007: COMPREHENSIVE (WEATHER)
  IF claim.type == 'COMP' AND claim.causeOfLoss IN ('HAIL', 'FLOOD', 'WIND'):
    indemnity = estimate (if available) OR 4000 (default)
    expense = 500
```

### 4.2 Auto Bodily Injury

```
AUTO BI INITIAL RESERVE RULES
================================

RULE RESV-ABI-001: MINOR INJURY (soft tissue, no ER)
  indemnity = 8000 × stateFactor[lossState]
  alae = 1500
  TOTAL = indemnity + alae

RULE RESV-ABI-002: MODERATE INJURY (ER visit, no hospitalization)
  indemnity = 25000 × stateFactor[lossState]
  alae = 3000
  TOTAL = indemnity + alae

RULE RESV-ABI-003: SERIOUS INJURY (hospitalization, surgery possible)
  indemnity = 75000 × stateFactor[lossState]
  alae = 10000
  TOTAL = indemnity + alae

RULE RESV-ABI-004: SEVERE INJURY (multiple surgeries, long-term)
  indemnity = 200000 × stateFactor[lossState]
  alae = 25000
  TOTAL = indemnity + alae

RULE RESV-ABI-005: CATASTROPHIC INJURY (TBI, spinal cord, amputation)
  indemnity = 750000 × stateFactor[lossState]
  alae = 50000
  TOTAL = indemnity + alae

RULE RESV-ABI-006: FATALITY
  indemnity = policyLimit (up to applicable limit)
  alae = 30000
  TOTAL = indemnity + alae

RULE RESV-ABI-007: ATTORNEY LOADING
  IF claim.attorneyRepresented == true:
    indemnity = indemnity × 1.35  (35% attorney loading)
    alae = alae × 1.50  (50% increase for defense costs)

STATE FACTORS:
  FL: 1.40, CA: 1.45, NY: 1.50, TX: 1.10, GA: 1.20
  IL: 1.25, PA: 1.15, OH: 1.05, NJ: 1.30, MI: 1.20
  (Based on historical settlement/verdict data by state)
```

### 4.3 Property / Homeowners

```
PROPERTY INITIAL RESERVE RULES
=================================

RULE RESV-PROP-001: WATER DAMAGE (NON-CAT)
  IF estimate available:
    indemnity = estimate (Xactimate)
  ELSE:
    indemnity = 8000 (default)
  expense = indemnity × 0.08  (8% ALAE)
  TOTAL = indemnity + expense

RULE RESV-PROP-002: FIRE DAMAGE
  IF dwelling_total_loss:
    indemnity = coverage_A_limit (dwelling)
    contents_reserve = coverage_C_limit × 0.50 (estimated)
    ALE_reserve = coverage_D_limit × 0.30
    expense = indemnity × 0.10
  ELSE:
    indemnity = estimate OR 25000 (default)
    expense = indemnity × 0.08

RULE RESV-PROP-003: WIND/HAIL (NON-CAT)
  indemnity = estimate OR 12000 (default)
  expense = indemnity × 0.06
  IF wind_hail_deductible_percentage:
    deductible = dwelling_coverage × wind_hail_deductible_pct
  TOTAL = indemnity - deductible + expense

RULE RESV-PROP-004: THEFT
  indemnity = reported_value × 0.60 (depreciation + verification)
  expense = 500
  TOTAL = indemnity + expense

RULE RESV-PROP-005: CAT EVENT
  indemnity = CAT_model_estimate OR coverage_A_limit × 0.30 (default)
  expense = indemnity × 0.12  (higher due to CAT conditions)
  TOTAL = indemnity + expense
```

### 4.4 Workers Compensation

```
WC INITIAL RESERVE RULES
===========================

RULE RESV-WC-001: MEDICAL ONLY (no lost time)
  medical_reserve = treatmentGuideline.lookup(diagnosis, state)
  indemnity_reserve = 0
  expense_reserve = 200
  TOTAL = medical_reserve + expense_reserve

RULE RESV-WC-002: TEMPORARY TOTAL DISABILITY (TTD)
  weekly_rate = MIN(AWW × 2/3, state_max_weekly_rate[state])
  expected_weeks = disabilityDuration.lookup(diagnosis, age, occupation)
  indemnity_reserve = weekly_rate × expected_weeks
  medical_reserve = medicalCost.lookup(diagnosis, state, treatment_type)
  expense_reserve = (indemnity_reserve + medical_reserve) × 0.12
  TOTAL = indemnity_reserve + medical_reserve + expense_reserve

RULE RESV-WC-003: PERMANENT PARTIAL DISABILITY (PPD)
  scheduled_benefit = state_PPD_schedule[body_part][impairment_rating]
  medical_reserve = medicalCost.lookup(diagnosis, state) × 1.5
  expense_reserve = (scheduled_benefit + medical_reserve) × 0.12
  TOTAL = scheduled_benefit + medical_reserve + expense_reserve

RULE RESV-WC-004: PERMANENT TOTAL DISABILITY (PTD)
  weekly_rate = MIN(AWW × 2/3, state_max_weekly_rate[state])
  life_expectancy = lifeTable.lookup(age, gender)
  indemnity_reserve = weekly_rate × 52 × life_expectancy × discountFactor
  medical_reserve = annual_medical × life_expectancy × discountFactor
  expense_reserve = (indemnity_reserve + medical_reserve) × 0.15
  TOTAL = indemnity_reserve + medical_reserve + expense_reserve

RULE RESV-WC-005: FATALITY
  death_benefit = state_death_benefit_schedule[state][dependents]
  funeral_benefit = state_funeral_max[state]
  expense_reserve = 5000
  TOTAL = death_benefit + funeral_benefit + expense_reserve
```

---

## 5. Reserve Adequacy & Stairstepping Detection

### 5.1 Reserve Adequacy Analysis

```
RESERVE ADEQUACY ANALYSIS
============================

INDIVIDUAL CLAIM LEVEL:
  1. Payment-to-Reserve Ratio:
     ratio = total_paid / initial_reserve
     IF ratio > 0.80: WARN "Reserve approaching exhaustion"
     IF ratio > 1.00: ALERT "Reserve exceeded"

  2. Remaining Reserve Reasonableness:
     remaining = current_reserve - total_paid
     expected_remaining = model.predict(claim_features)
     IF ABS(remaining - expected_remaining) / expected_remaining > 0.50:
       FLAG "Reserve may be inadequate or excessive"

  3. Duration-Based Review:
     IF claim.ageInDays > expectedDuration × 1.5 AND remaining < initial × 0.30:
       ALERT "Long-tailed claim with low remaining reserve"

PORTFOLIO LEVEL:
  1. Actuarial Reserve Review:
     ├── Quarterly comparison of case reserves to actuarial estimates
     ├── Calculate carried-to-indicated ratio
     │   ratio = carried_reserves / actuarial_indicated_reserves
     │   Target: 0.95 - 1.05 (within 5% of indicated)
     ├── IF ratio < 0.90: DEFICIENCY (under-reserved)
     └── IF ratio > 1.10: REDUNDANCY (over-reserved)

  2. Calendar Year Development:
     ├── Track prior-year reserve changes
     ├── Favorable development = reserves decreased = prior over-reserved
     ├── Adverse development = reserves increased = prior under-reserved
     └── Target: Minimal development (accurate initial estimates)
```

### 5.2 Stairstepping Detection

```
STAIRSTEPPING DETECTION ALGORITHM
====================================

Definition: Stairstepping occurs when reserves are repeatedly
increased in small increments rather than set at an adequate
level initially. This masks the true claim cost and delays
recognition of the ultimate liability.

Detection Algorithm:

FUNCTION detectStairstepping(claim):
  changes = getReserveChanges(claim, allHistory)
  
  // Count upward changes
  upChanges = changes.filter(c => c.direction == 'UP')
  
  // Stairstepping indicators:
  indicator1 = COUNT(upChanges) >= 3 (3+ upward changes)
  indicator2 = upChanges.allWithin90Days (multiple in short period)
  indicator3 = upChanges.lastChange / initialReserve > 0.50
               (total increase > 50% of initial)
  indicator4 = no downward changes (never reduced)
  indicator5 = each increase is similar magnitude
               (consistent small increments vs one-time correction)
  
  stairstepScore = SUM(
    indicator1 × 3,
    indicator2 × 2,
    indicator3 × 2,
    indicator4 × 1,
    indicator5 × 2
  )
  
  IF stairstepScore >= 7: ALERT("Stairstepping detected", HIGH)
  IF stairstepScore >= 4: WARN("Potential stairstepping", MEDIUM)

Example of Stairstepping:
  Day 0:   Reserve set at $10,000
  Day 30:  Reserve increased to $15,000 (+50%)
  Day 60:  Reserve increased to $22,000 (+47%)
  Day 90:  Reserve increased to $30,000 (+36%)
  Day 120: Reserve increased to $42,000 (+40%)
  → Total increase: 320% from initial reserve
  → Indicates initial reserve was inadequate
  → Should have been set closer to $42,000 initially

Prevention:
  ├── ML-assisted initial reserve setting (more accurate)
  ├── Mandatory comprehensive evaluation at 30 days
  ├── Supervisor review when > 2 upward changes
  ├── Training on severity indicators and early recognition
  └── KPI tracking: average number of reserve changes per claim
```

---

## 6. Actuarial Methods

### 6.1 Chain Ladder (Development) Method

```
CHAIN LADDER METHOD
=====================

Most widely used actuarial reserving method.

Process:
  1. Organize data in a triangle (accident year vs development period)
  2. Calculate age-to-age (link) factors
  3. Select development factors (average, weighted, selected)
  4. Calculate cumulative development factors (CDF)
  5. Project ultimate losses: Reported × CDF-to-Ultimate
  6. IBNR = Ultimate - Reported

Assumption: Future development will follow historical patterns

Strengths:
  ├── Simple to implement and explain
  ├── Works well for stable, mature lines
  └── Widely accepted by regulators and auditors

Weaknesses:
  ├── Assumes stable development patterns
  ├── Sensitive to data in recent diagonal
  ├── Does not adjust for changing claim mix
  └── Can produce volatile results for long-tail lines
```

### 6.2 Bornhuetter-Ferguson Method

```
BORNHUETTER-FERGUSON (B-F) METHOD
====================================

Blends the chain ladder method with an a priori expected loss ratio.

Formula:
  Ultimate = Reported + (Expected_Ultimate × (1 - 1/CDF))

Where:
  Reported = current reported (paid or incurred) losses
  Expected_Ultimate = Earned_Premium × Expected_Loss_Ratio
  CDF = cumulative development factor to ultimate

Process:
  1. Select a priori expected loss ratio (from pricing, industry, or experience)
  2. Calculate unreported factor: 1 - (1/CDF) for each maturity
  3. Expected IBNR = Expected_Ultimate × unreported_factor
  4. Ultimate = Reported + Expected_IBNR

Strengths:
  ├── More stable than chain ladder for immature years
  ├── Incorporates external information (pricing, industry)
  ├── Less influenced by volatile reported data
  └── Good for new lines or changing environments

Weaknesses:
  ├── Requires a priori loss ratio selection (subjective)
  ├── As claims mature, should converge to chain ladder
  └── May over-smooth actual experience
```

### 6.3 Cape Cod Method

```
CAPE COD METHOD
=================

Similar to B-F but derives the expected loss ratio from the data.

Process:
  1. Calculate used-up premium for each year:
     Used_Up_Premium[y] = Earned_Premium[y] × (1/CDF[maturity])
  2. Calculate overall expected loss ratio:
     ELR = SUM(Reported[all years]) / SUM(Used_Up_Premium[all years])
  3. Apply like B-F:
     Ultimate[y] = Reported[y] + (Premium[y] × ELR × (1 - 1/CDF[y]))

Advantage over B-F: Derives expected loss ratio from data rather
than external selection, but still provides stability benefit.
```

### 6.4 Frequency-Severity Method

```
FREQUENCY-SEVERITY METHOD
============================

Separates ultimate losses into:
  Ultimate = Expected_Claim_Count × Expected_Average_Severity

Process:
  1. Project ultimate claim counts (using count development triangle)
  2. Project average severity (using severity development triangle)
  3. Multiply to get ultimate losses

Useful when:
  ├── Frequency and severity are changing independently
  ├── Want to understand drivers of loss changes
  └── Claim count data is more stable than loss data
```

---

## 7. Loss Development Triangles

### 7.1 Paid Loss Development Triangle

```
PAID LOSS DEVELOPMENT TRIANGLE ($ in millions)
=================================================

Accident  │ Development Period (months)
Year      │  12      24      36      48      60      72    Ultimate
──────────┼──────────────────────────────────────────────────────────
2018      │ 45.0    72.0    88.0    95.0    98.0    99.5    100.0
2019      │ 48.0    78.0    93.0   101.0   104.0
2020      │ 50.0    80.0    97.0   105.0
2021      │ 52.0    84.0   102.0
2022      │ 55.0    88.0
2023      │ 58.0

Age-to-Age Factors:
          │ 12→24   24→36   36→48   48→60   60→72   72→Ult
──────────┼────────────────────────────────────────────────
2018      │ 1.600   1.222   1.080   1.032   1.015
2019      │ 1.625   1.192   1.086   1.030
2020      │ 1.600   1.213   1.082
2021      │ 1.615   1.214
2022      │ 1.600
──────────┼────────────────────────────────────────────────
Average   │ 1.608   1.210   1.083   1.031   1.015   1.005
Weighted  │ 1.609   1.212   1.082   1.031   1.015   1.005
Selected  │ 1.610   1.212   1.083   1.031   1.015   1.005

Cumulative Development Factors (CDF):
  12 months:  1.610 × 1.212 × 1.083 × 1.031 × 1.015 × 1.005 = 2.234
  24 months:  1.212 × 1.083 × 1.031 × 1.015 × 1.005 = 1.387
  36 months:  1.083 × 1.031 × 1.015 × 1.005 = 1.138
  48 months:  1.031 × 1.015 × 1.005 = 1.052
  60 months:  1.015 × 1.005 = 1.020
  72 months:  1.005

Ultimate Loss Projections:
  2023: $58.0M × 2.234 = $129.6M
  2022: $88.0M × 1.387 = $122.1M
  2021: $102.0M × 1.138 = $116.1M
  2020: $105.0M × 1.052 = $110.5M
  2019: $104.0M × 1.020 = $106.1M
  2018: $99.5M × 1.005 = $100.0M

IBNR = Ultimate - Current Paid:
  2023 IBNR: $129.6M - $58.0M = $71.6M
  2022 IBNR: $122.1M - $88.0M = $34.1M
  2021 IBNR: $116.1M - $102.0M = $14.1M
  etc.
```

### 7.2 Incurred Loss Development Triangle

```
INCURRED LOSS DEVELOPMENT TRIANGLE ($ in millions)
=====================================================

(Incurred = Paid + Case Reserves)

Accident  │ Development Period (months)
Year      │  12      24      36      48      60      72
──────────┼──────────────────────────────────────────────
2018      │ 92.0    97.0    98.5    99.0    99.5    99.8
2019      │ 96.0   102.0   103.5   104.5   105.0
2020      │ 100.0  106.0   108.0   109.0
2021      │ 104.0  110.0   113.0
2022      │ 110.0  116.0
2023      │ 115.0

Note: Incurred triangles develop less than paid triangles
(case reserves estimate the unpaid portion, reducing IBNR needed)

Incurred development factors are typically closer to 1.0
because case reserves "pre-estimate" the ultimate.
```

### 7.3 Claim Count Development Triangle

```
CLAIM COUNT DEVELOPMENT TRIANGLE
===================================

Accident  │ Development Period (months)
Year      │  12      24      36      48      60
──────────┼──────────────────────────────────────
2018      │ 4,200   4,500   4,600   4,620   4,625
2019      │ 4,400   4,720   4,830   4,850
2020      │ 4,600   4,950   5,060
2021      │ 4,800   5,160
2022      │ 5,000

Count CDF (12 months to Ultimate):
  12→24: 1.072, 24→36: 1.024, 36→48: 1.005, 48→60: 1.001
  CDF (12 to ultimate): 1.105

Ultimate Claims 2022: 5,000 × 1.105 = 5,525
Pure IBNR claims: 5,525 - 5,000 = 525 claims not yet reported
```

---

## 8. IBNR Calculation Methodologies

### 8.1 IBNR Components

```
IBNR BREAKDOWN
================

IBNR = Pure_IBNR + Development_on_Known

Pure IBNR:
  Claims that have occurred (before the evaluation date)
  but have NOT YET been reported to the insurer.
  
  Factors:
  ├── Reporting lag (time between occurrence and reporting)
  ├── Varies by line: Auto PD ~days, WC ~weeks, BI ~months, GL ~years
  └── Decreases rapidly as time passes

Development on Known Claims:
  Expected future changes to reserves on claims that
  have already been reported and are currently open.
  
  Factors:
  ├── Reserve changes (upward or downward adjustments)
  ├── Payment development beyond current reserves
  ├── Reopened claims
  └── Generally the larger component for mature years
```

### 8.2 IBNR Formulas

```
IBNR CALCULATION FORMULAS
============================

METHOD 1: CHAIN LADDER IBNR
  IBNR = Ultimate_Losses - Reported_Losses
  Where Ultimate = Reported × CDF_to_Ultimate

  Example:
    Reported losses (AY 2023 at 12 months): $115M
    CDF to ultimate: 1.065
    Ultimate: $115M × 1.065 = $122.5M
    IBNR: $122.5M - $115M = $7.5M

METHOD 2: BORNHUETTER-FERGUSON IBNR
  IBNR = Expected_Ultimate × Unreported_Factor
  Where:
    Expected_Ultimate = Earned_Premium × Expected_Loss_Ratio
    Unreported_Factor = 1 - (1 / CDF_to_Ultimate)

  Example:
    Earned premium: $200M
    Expected loss ratio: 0.62
    Expected ultimate: $200M × 0.62 = $124M
    CDF to ultimate: 1.065
    Unreported factor: 1 - (1/1.065) = 0.061
    IBNR: $124M × 0.061 = $7.6M

METHOD 3: EXPECTED LOSS RATIO IBNR
  IBNR = (Earned_Premium × Expected_Loss_Ratio) - Reported_Losses

  Example:
    Expected ultimate: $124M (as above)
    Reported: $115M
    IBNR: $124M - $115M = $9M

  Note: Most simple but least responsive to actual experience

METHOD 4: FREQUENCY × SEVERITY IBNR
  IBNR_Claims = Ultimate_Claims - Reported_Claims
  IBNR_Amount = IBNR_Claims × Expected_Average_Severity

  Example:
    Ultimate claims: 5,525
    Reported claims: 5,000
    IBNR claims: 525
    Expected average severity: $22,000
    IBNR amount: 525 × $22,000 = $11.55M
```

---

## 9. Reserve Change Workflow

### 9.1 Reserve Change Process

```
RESERVE CHANGE WORKFLOW
=========================

┌──────────────┐
│ TRIGGER      │
│              │
│ ├── New info │
│ ├── Review   │
│ ├── Payment  │
│ ├── System   │
│ └── Diary    │
└──────┬───────┘
       │
┌──────▼────────────────────────────────┐
│ ADJUSTER EVALUATES                     │
│                                        │
│ ├── Reviews new information            │
│ ├── Reassesses ultimate exposure       │
│ ├── Considers:                         │
│ │   ├── New medical records / treatment│
│ │   ├── Attorney involvement           │
│ │   ├── Litigation filed               │
│ │   ├── Expert opinions                │
│ │   ├── Settlement negotiations        │
│ │   └── Comparable claims              │
│ └── Prepares reserve recommendation    │
└──────┬────────────────────────────────┘
       │
┌──────▼────────────────────────────────┐
│ DOCUMENT RESERVE CHANGE                │
│                                        │
│ Required fields:                       │
│ ├── Current reserve (by type)          │
│ ├── Recommended new reserve (by type)  │
│ ├── Change amount (delta)              │
│ ├── Reason for change (coded + text)   │
│ ├── Supporting documentation           │
│ └── Effective date                     │
└──────┬────────────────────────────────┘
       │
┌──────▼────────────────────────────────┐
│ AUTHORITY CHECK                        │
│                                        │
│ IF change_amount <= adjuster_authority:│
│   → Auto-approve (adjuster approved)  │
│ ELSE:                                  │
│   → Route to supervisor/manager        │
│   (see Authority Matrix, Section 10)   │
└──────┬────────────────────────────────┘
       │
┌──────▼────────────────────────────────┐
│ APPROVAL (if required)                 │
│                                        │
│ Supervisor reviews:                    │
│ ├── Reserve adequacy                   │
│ ├── Documentation support              │
│ ├── Consistency with similar claims    │
│ ├── Stairstepping check                │
│ └── Approve / Modify / Reject          │
└──────┬────────────────────────────────┘
       │
┌──────▼────────────────────────────────┐
│ POST RESERVE CHANGE                    │
│                                        │
│ ├── Update claim reserves in system    │
│ ├── Generate GL entries                │
│ ├── Update reinsurance allocation      │
│ ├── Update financial reports           │
│ ├── Create audit trail record          │
│ └── Trigger diary for next review      │
└───────────────────────────────────────┘
```

---

## 10. Authority Levels for Reserve Changes

### 10.1 Reserve Authority Matrix

```
RESERVE AUTHORITY MATRIX
===========================

+------------------+----------+----------+----------+----------+----------+
│ Role             │ Auto PD  │ Auto BI  │ Property │ WC       │ GL/Liab  │
+------------------+----------+----------+----------+----------+----------+
│ Staff Adjuster   │ $25,000  │ $50,000  │ $75,000  │ $50,000  │ $50,000  │
│ Senior Adjuster  │ $75,000  │ $150,000 │ $200,000 │ $125,000 │ $150,000 │
│ Team Lead        │ $125,000 │ $300,000 │ $400,000 │ $250,000 │ $300,000 │
│ Supervisor       │ $250,000 │ $500,000 │ $750,000 │ $400,000 │ $500,000 │
│ Manager          │ $500,000 │ $1M      │ $2M      │ $750,000 │ $1M      │
│ Director         │ $1M      │ $3M      │ $5M      │ $2M      │ $3M      │
│ VP Claims        │ $3M      │ $10M     │ $15M     │ $5M      │ $10M     │
│ CCO              │ Unlimited│ Unlimited│ Unlimited│ Unlimited│ Unlimited│
+------------------+----------+----------+----------+----------+----------+

Notes:
  - Authority is TOTAL reserve (indemnity + expense), not change amount
  - Some carriers use change amount authority instead
  - Some carriers require dual approval above certain thresholds
  - Authority may differ for initial setting vs subsequent changes
```

---

## 11. Automated Reserve Setting Algorithms

### 11.1 Rules-Based Automated Reserves

```
AUTOMATED RESERVE ALGORITHM (RULES + ML HYBRID)
==================================================

FUNCTION setAutomatedReserve(claim):

  // Step 1: Rules-based initial estimate
  rulesEstimate = reserveRules.calculate(
    claim.type, claim.severity, claim.state,
    claim.coverage, claim.vehicle, claim.injury
  )

  // Step 2: ML model prediction
  features = featureStore.getFeatures(claim.id)
  mlEstimate = reserveModel.predict(features)
  mlConfidence = reserveModel.confidence(features)

  // Step 3: Comparable claims analysis
  comparables = findComparableClaims(claim, k=10)
  comparableAvg = AVG(comparables.ultimateCost)
  comparableMedian = MEDIAN(comparables.ultimateCost)

  // Step 4: Blend estimates
  IF mlConfidence > 0.80:
    blendedEstimate = (rulesEstimate × 0.30) +
                      (mlEstimate × 0.50) +
                      (comparableMedian × 0.20)
  ELSE IF mlConfidence > 0.60:
    blendedEstimate = (rulesEstimate × 0.50) +
                      (mlEstimate × 0.30) +
                      (comparableMedian × 0.20)
  ELSE:
    blendedEstimate = (rulesEstimate × 0.60) +
                      (comparableMedian × 0.40)

  // Step 5: Apply adjustments
  IF claim.attorneyRepresented:
    blendedEstimate *= 1.30  // attorney loading
  IF claim.state IN highLitigationStates:
    blendedEstimate *= stateAdjustment[claim.state]

  // Step 6: Split into components
  indemnityReserve = blendedEstimate × (1 - alaeRatio[claim.type])
  alaeReserve = blendedEstimate × alaeRatio[claim.type]

  // Step 7: Apply deductible
  indemnityReserve = MAX(0, indemnityReserve - claim.deductible)

  // Step 8: Apply coverage limit
  indemnityReserve = MIN(indemnityReserve, claim.coverageLimit)

  // Step 9: Determine if auto-approve or review needed
  IF blendedEstimate <= autoApproveThreshold[claim.type]:
    autoApproved = true
  ELSE:
    autoApproved = false  // route for review

  RETURN {
    indemnityReserve: ROUND(indemnityReserve, 2),
    alaeReserve: ROUND(alaeReserve, 2),
    totalReserve: ROUND(indemnityReserve + alaeReserve, 2),
    method: 'AUTOMATED_HYBRID',
    rulesComponent: rulesEstimate,
    mlComponent: mlEstimate,
    mlConfidence: mlConfidence,
    comparablesComponent: comparableMedian,
    autoApproved: autoApproved,
    reviewRequired: !autoApproved
  }
```

---

## 12. Financial Transactions in Claims

### 12.1 Transaction Types

```
CLAIMS FINANCIAL TRANSACTION TYPES
=====================================

RESERVE TRANSACTIONS:
  RESV_SET      Initial reserve establishment
  RESV_INC      Reserve increase
  RESV_DEC      Reserve decrease
  RESV_RELEASE  Reserve release (at claim closure)

PAYMENT TRANSACTIONS:
  PAY_INDEM     Indemnity payment (loss cost)
  PAY_ALAE      Allocated loss adjustment expense payment
  PAY_SUBRO     Payment to subrogation vendor
  PAY_SALARY    Payment to salvage vendor (included in ULAE typically)

RECOVERY TRANSACTIONS:
  REC_SUBRO     Subrogation recovery received
  REC_SALVAGE   Salvage recovery received
  REC_DEDUCT    Deductible recovery (large deductible policies)
  REC_REIMB     Reimbursement from third party
  REC_OTHER     Other recovery

ADJUSTMENT TRANSACTIONS:
  ADJ_VOID      Void a prior payment
  ADJ_REISSUE   Reissue a voided payment
  ADJ_STALE     Stale-dated check (uncashed beyond threshold)
  ADJ_RCLASS    Reclassify transaction (change coverage/type)
  ADJ_CORRECT   Correction entry

FINANCIAL EVENT IMPACTS:
  ┌────────────────────────────────────────────────────────┐
  │ Transaction    │ Reserve │ Paid    │ Incurred│ Cash    │
  ├────────────────┼─────────┼─────────┼─────────┼─────────┤
  │ Set Reserve    │ +       │         │ +       │         │
  │ Increase Resv  │ +       │         │ +       │         │
  │ Decrease Resv  │ -       │         │ -       │         │
  │ Make Payment   │ -       │ +       │ (net 0) │ -       │
  │ Receive Recov  │         │ -       │ -       │ +       │
  │ Void Payment   │ +       │ -       │ (net 0) │ +       │
  │ Close (release)│ -       │         │ -       │         │
  └────────────────┴─────────┴─────────┴─────────┴─────────┘

  Where: Incurred = Paid + Outstanding Reserves
```

---

## 13. Payment Types

```
PAYMENT TYPE DETAIL
=====================

INDEMNITY PAYMENTS:
  ├── Property damage repair payment
  ├── Property damage total loss settlement
  ├── Contents replacement/reimbursement
  ├── Additional living expense (ALE)
  ├── Bodily injury settlement
  ├── Bodily injury judgment
  ├── Medical payments (Med Pay, PIP)
  ├── Uninsured/underinsured motorist payment
  ├── Workers compensation indemnity (TTD, PPD, PTD)
  ├── Workers compensation medical
  ├── Rental car reimbursement
  ├── Tow reimbursement
  ├── Loss of use payment
  └── General liability settlement/judgment

ALAE (EXPENSE) PAYMENTS:
  ├── Defense attorney fees
  ├── Independent adjuster fees
  ├── Independent medical exam (IME)
  ├── Expert witness fees
  ├── Court costs and filing fees
  ├── Mediation/arbitration fees
  ├── Surveillance costs
  ├── Accident reconstruction
  ├── Engineering/forensic analysis
  ├── Appraisal fees
  ├── Medical record retrieval costs
  ├── Deposition costs
  └── Travel expenses (investigation)
```

---

## 14. Payment Processing Methods

| Method | Use Case | Speed | Cost | Security |
|---|---|---|---|---|
| Paper Check | Traditional, insured preference | 5-10 days | $5-$15 per check | Low (mail risk) |
| ACH/EFT | Direct deposit to bank | 1-3 days | $0.25-$1.00 | High |
| Virtual Card | Vendor payments, controlled spend | Instant | 1-3% interchange rebate | Very High |
| Wire Transfer | Large payments, urgent | Same day | $15-$30 | High |
| Digital Wallet | Consumer-friendly, mobile | Instant | $0.50-$2.00 | High |
| Push-to-Debit | Instant payment to debit card | Instant | $1.00-$5.00 | High |

---

## 15. Payment Approval Workflows

```
PAYMENT APPROVAL WORKFLOW
============================

┌───────────────┐
│ Payment       │
│ Request       │
│ Created       │
└──────┬────────┘
       │
┌──────▼────────────────────────────────┐
│ AUTOMATED VALIDATION                   │
│                                        │
│ ✓ Amount > 0                           │
│ ✓ Payee identified and verified        │
│ ✓ Reserve adequate (payment ≤ reserve) │
│ ✓ Coverage verified and active         │
│ ✓ No duplicate payment                 │
│ ✓ OFAC screening passed                │
│ ✓ Tax info on file (if required)       │
│ ✓ Lien check (if applicable)           │
│                                        │
│ IF any check FAILS → REJECT + reason   │
└──────┬────────────────────────────────┘
       │ All pass
       │
┌──────▼────────────────────────────────┐
│ AUTHORITY CHECK                        │
│                                        │
│ Compare payment amount to:             │
│ ├── Requester's payment authority      │
│ ├── Cumulative payments on claim       │
│ └── Any special handling flags         │
│                                        │
│ Routes:                                │
│ ├── Within authority → AUTO-APPROVE    │
│ ├── Over authority → ROUTE to approver │
│ └── Special flag → ROUTE to specialist │
└──────┬──────────────┬─────────────────┘
       │              │
  (auto-approve)  (needs approval)
       │              │
       │         ┌────▼─────────────────┐
       │         │ SUPERVISOR/MANAGER   │
       │         │ REVIEW               │
       │         │                      │
       │         │ ├── Review claim     │
       │         │ ├── Review payment   │
       │         │ ├── Approve/Reject   │
       │         │ └── Comments         │
       │         └────┬─────────────────┘
       │              │
┌──────▼──────────────▼─────────────────┐
│ PAYMENT PROCESSING                     │
│                                        │
│ ├── Generate payment instruction       │
│ ├── Route to payment method handler    │
│ ├── Issue check/EFT/wire              │
│ ├── Record transaction                 │
│ ├── Update reserves (reduce by payment)│
│ ├── Post to general ledger             │
│ ├── Update 1099 tracking               │
│ ├── Send notification to payee         │
│ └── Create audit trail entry           │
└───────────────────────────────────────┘
```

---

## 16. 1099 Reporting Requirements

```
1099 REPORTING IN CLAIMS
===========================

FORM 1099-MISC (Box 10: Gross proceeds paid to an attorney)
  ├── Report total payments to attorneys
  ├── Threshold: $600+ in calendar year
  ├── Include defense attorney AND claimant attorney fees
  ├── Report GROSS amount (before any deductions)
  └── Even if paid to law firm (not individual)

FORM 1099-NEC (Non-Employee Compensation)
  ├── Independent adjusters
  ├── Appraisers (if independent contractor)
  ├── Expert witnesses
  ├── Threshold: $600+ in calendar year
  └── Box 1: Non-employee compensation

FORM 1099-MISC (Box 3: Other income)
  ├── Punitive damages paid to claimants
  ├── Certain BI settlements (non-physical)
  └── Threshold: $600+

EXEMPT FROM 1099:
  ├── Insured's own PD payment (not income)
  ├── BI settlement for physical injury/sickness (IRC §104(a)(2))
  ├── Payments to corporations (generally exempt)
  ├── Payments to government entities
  └── Workers comp indemnity benefits

DATA REQUIREMENTS:
  ├── Payee TIN (SSN or EIN)
  ├── Payee name and address
  ├── Payment amount per calendar year
  ├── Payment type classification
  └── W-9 on file (or backup withholding at 24%)

FILING DEADLINES:
  ├── To recipient: January 31
  ├── To IRS (electronic): March 31
  ├── To IRS (paper): February 28
  └── Corrections: As soon as possible
```

---

## 17. Claims Financial Accounting: SAP vs GAAP

### 17.1 Key Differences

| Item | SAP (Statutory) | GAAP | Impact |
|---|---|---|---|
| Governing Body | NAIC (State regulators) | FASB | Different standard setters |
| Primary Users | Regulators, rating agencies | Investors, public markets | Different audiences |
| Conservatism | Very conservative | More balanced (fair value) | SAP tends to understate assets |
| DAC (Acquisition costs) | Expensed immediately | Deferred and amortized | SAP lower surplus in Year 1 |
| Bonds | Amortized cost (NAIC designation) | Fair value or amortized | GAAP shows market volatility |
| Non-admitted Assets | Excluded from surplus | Included on balance sheet | SAP lower surplus |
| Reinsurance | Offset on balance sheet | Gross + separate receivable | Different presentation |
| Loss Reserves | Undiscounted (most lines) | Undiscounted (US GAAP) | Both undiscounted |
| Schedule P | Required | Not required | SAP-specific reporting |
| RBC (Risk-Based Capital) | Required | Not required | SAP solvency measure |

### 17.2 Loss Reserve Accounting

```
LOSS RESERVE ACCOUNTING (SAP - SSAP No. 55)
=============================================

Opening Balance Sheet:
  Loss Reserves:       $500,000,000
  LAE Reserves:        $100,000,000
  Total L&LAE:         $600,000,000

During Period:
  New claim reserves:  +$80,000,000 (new claims reported)
  Reserve increases:   +$25,000,000 (development on existing)
  Reserve decreases:   -$15,000,000 (favorable development)
  Payments made:       -$70,000,000 (claims paid)
  Recoveries:          +$5,000,000  (subro/salvage credited)
  Reserve releases:    -$20,000,000 (claims closed)

Closing Balance Sheet:
  Loss Reserves:       $505,000,000
  LAE Reserves:        $100,000,000
  Total L&LAE:         $605,000,000

Income Statement Impact:
  Losses Incurred = Paid Losses + Change in Reserves
  = $70,000,000 + ($605,000,000 - $600,000,000)
  = $70,000,000 + $5,000,000
  = $75,000,000

  LAE Incurred = Paid LAE + Change in LAE Reserves
```

---

## 18. Schedule P Reporting

### 18.1 Schedule P Overview

```
NAIC SCHEDULE P - ANNUAL STATEMENT
=====================================

Schedule P is a mandatory regulatory filing in the Annual Statement
that discloses loss and LAE reserve development. It provides
regulators transparency into reserve accuracy over time.

Parts of Schedule P:
  Part 1: Summary (most recent 10 accident years)
    ├── Premiums earned
    ├── Loss and LAE reserves (1 year ago and current)
    ├── Losses and LAE paid (cumulative to date and during year)
    ├── Discount (if applicable)
    ├── Anticipated salvage and subrogation
    └── Number of claims (reported, closed with payment, outstanding)

  Part 2: Incurred Loss and LAE Development
    ├── 10×10 triangle of cumulative incurred
    ├── Shows how estimate of ultimate has changed over time
    └── One year development in last column

  Part 3: Paid Loss and LAE Development
    ├── 10×10 triangle of cumulative paid
    └── Shows payment pattern

  Part 4: Bulk + IBNR Reserves
    ├── Shows bulk/IBNR reserves by accident year
    └── Indicates adequacy of case reserves (bulk = development)

Required Lines (separate schedules):
  ├── Homeowners/Farmowners
  ├── Private Passenger Auto Liability
  ├── Commercial Auto Liability
  ├── Workers Compensation
  ├── Commercial Multiple Peril
  ├── Medical Malpractice
  ├── Special Liability (GL)
  ├── Other Liability
  ├── Products Liability
  ├── Auto Physical Damage
  ├── Fidelity and Surety
  ├── Other (Including Credit)
  └── International
```

---

## 19. Loss Ratio Calculation & Monitoring

### 19.1 Loss Ratio Definitions

```
LOSS RATIO FORMULAS
=====================

1. CALENDAR YEAR LOSS RATIO
   = (Calendar Year Incurred Losses) / (Calendar Year Earned Premiums)
   = (Paid Losses + Change in Reserves) / Earned Premiums

   Most common reported ratio. Includes development on all accident years.

2. ACCIDENT YEAR LOSS RATIO
   = (Accident Year Ultimate Losses) / (Accident Year Earned Premiums)
   
   Better measure of underwriting performance for a specific year.
   Requires IBNR estimates.

3. POLICY YEAR LOSS RATIO
   = (Policy Year Ultimate Losses) / (Policy Year Written Premiums)
   
   Most accurate but slowest to develop.
   Matches losses to specific policies that generated them.

4. COMBINED RATIO
   = Loss Ratio + LAE Ratio + Underwriting Expense Ratio
   = (Losses + LAE + UW Expenses) / Earned Premiums
   
   < 100%: Underwriting profit
   > 100%: Underwriting loss (investment income may still yield profit)

5. OPERATING RATIO
   = Combined Ratio - Investment Income Ratio
   
   True measure of overall profitability.

INDUSTRY BENCHMARKS:
  Line               Loss Ratio    LAE Ratio    Combined Ratio
  Auto PD            58-65%        8-12%        95-105%
  Auto BI            55-70%        12-18%       100-115%
  Homeowners         55-75%        8-12%        95-115%
  Workers Comp       55-65%        15-22%       95-110%
  Commercial GL      50-65%        15-25%       95-115%
  Commercial Property 45-60%       8-12%        90-100%
```

---

## 20. LAE Ratio Analysis

```
LAE RATIO ANALYSIS
====================

ALAE RATIO = Allocated LAE Incurred / Losses Incurred

Benchmarks by LOB:
  Auto PD:     3-6%
  Auto BI:     15-25%
  Homeowners:  5-10%
  Workers Comp: 8-15%
  General Liability: 20-35%
  Professional Liability: 30-50%

ULAE RATIO = Unallocated LAE Incurred / Losses Incurred

Benchmarks:
  Industry average: 8-12% of losses
  Efficient operations: 5-8%
  Complex lines: 12-18%

Drivers of High LAE:
  ├── High litigation rate (attorney involvement)
  ├── Complex investigation requirements
  ├── Expensive expert witnesses
  ├── Long-tail claim development
  ├── Regulatory compliance costs
  └── Inefficient claims operations

LAE Reduction Strategies:
  ├── Early resolution programs
  ├── Alternative dispute resolution (mediation)
  ├── Claims automation (reduce ULAE)
  ├── Staff attorney programs (reduce defense costs)
  ├── Vendor management (negotiate rates)
  └── Litigation management guidelines
```

---

## 21. Bulk Reserve Methodologies

```
BULK / IBNR RESERVE METHODS
==============================

METHOD 1: PERCENT OF CASE RESERVES
  Bulk = Case_Reserves × Bulk_Factor
  Where Bulk_Factor derived from historical development
  Simple but crude. Typically used as a reasonableness check.

METHOD 2: PERCENT OF EARNED PREMIUM
  Bulk = Earned_Premium × Expected_IBNR_Rate
  Where Expected_IBNR_Rate from historical patterns
  Works for stable, predictable books.

METHOD 3: DEVELOPMENT METHOD (Chain Ladder)
  See Section 7. Most common actuarial method.
  Bulk = Actuarial_Ultimate - (Case_Reserves + Paid)

METHOD 4: BORNHUETTER-FERGUSON
  See Section 6.2. Preferred for immature accident years.

METHOD 5: BENKTANDER
  Weighted average of B-F and chain ladder:
  Ultimate = α × CL_Ultimate + (1-α) × BF_Ultimate
  Weight α increases as maturity increases.
  Compromise between the two methods.

METHOD 6: AVERAGE COST PER CLAIM
  Ultimate = Expected_Claim_Count × Expected_Avg_Cost
  IBNR claims counted separately from development on known.
  Useful when frequency/severity trends differ.

Actuarial Judgment:
  ├── Actuaries often use multiple methods
  ├── Compare results across methods
  ├── Select or weight methods based on data quality
  ├── Apply judgment for unusual circumstances
  └── Document selection rationale
```

---

## 22. Reinsurance Reserve Allocation

```
REINSURANCE RESERVE ALLOCATION
=================================

Purpose: Determine which portions of gross reserves are recoverable
from reinsurers under reinsurance treaties.

Treaty Types and Reserve Impact:

  QUOTA SHARE:
    Ceded reserves = Gross reserves × Cession percentage
    Example: 30% quota share → 30% of all reserves ceded
    Simple and proportional.

  EXCESS OF LOSS (Per-occurrence):
    IF gross reserve on occurrence > retention:
      Ceded = MIN(gross - retention, treaty_limit)
    ELSE:
      Ceded = 0
    Must track on per-occurrence basis.

  EXCESS OF LOSS (Aggregate):
    IF cumulative losses > aggregate retention:
      Ceded = MIN(cumulative - retention, aggregate_limit)
    Track across all claims for policy period.

  CATASTROPHE EXCESS:
    Triggered by CAT event total across many claims.
    IF total_CAT_losses > CAT retention:
      Ceded = MIN(total - retention, CAT_limit)

Reserve Allocation Process:
  1. For each claim, identify applicable reinsurance treaties
  2. Calculate ceded reserves based on treaty terms
  3. Book reinsurance recoverable (asset)
  4. Report ceded reserves to reinsurers (bordereaux)
  5. Reconcile with reinsurer on quarterly/annual basis

Data Requirements:
  ├── Treaty structure (type, retention, limits, effective dates)
  ├── Per-claim coding (treaty assignment)
  ├── Occurrence grouping (for per-occurrence treaties)
  ├── CAT coding (for CAT treaties)
  └── Currency conversion (for international treaties)
```

---

## 23. Financial Data Model

### 23.1 Core Financial Tables

```
┌────────────────────────────────────────────────────────┐
│ Table: financial_transaction                            │
├────────────────────────────────────────────────────────┤
│ transaction_id        UUID           PK                │
│ claim_id              UUID           FK → claim        │
│ feature_id            UUID           FK → claim_feature│
│ transaction_number    VARCHAR(20)    UNIQUE             │
│ transaction_type      VARCHAR(20)    NOT NULL          │
│   (RESERVE_SET, RESERVE_CHANGE, PAYMENT, RECOVERY,     │
│    VOID, REISSUE, ADJUSTMENT)                          │
│ transaction_subtype   VARCHAR(30)    NOT NULL          │
│   (INDEMNITY, ALAE, ULAE, SALVAGE, SUBROGATION)       │
│ transaction_date      DATE           NOT NULL          │
│ effective_date        DATE           NOT NULL          │
│ amount                DECIMAL(14,2)  NOT NULL          │
│ running_reserve       DECIMAL(14,2)  NOT NULL          │
│ running_paid          DECIMAL(14,2)  NOT NULL          │
│ running_incurred      DECIMAL(14,2)  NOT NULL          │
│ payee_id              UUID           (for payments)     │
│ payee_name            VARCHAR(200)                     │
│ payee_type            VARCHAR(20)    (INSURED, VENDOR, │
│                                       ATTORNEY, PROVIDER│
│                                       , OTHER)         │
│ payment_method        VARCHAR(20)    (CHECK, EFT, WIRE,│
│                                       VIRTUAL_CARD)    │
│ check_number          VARCHAR(20)                      │
│ payment_status        VARCHAR(20)    (PENDING, ISSUED, │
│                                       CLEARED, VOIDED, │
│                                       STALE)           │
│ coverage_code         VARCHAR(10)    NOT NULL          │
│ lob_code              VARCHAR(10)    NOT NULL          │
│ accident_year         INTEGER        NOT NULL          │
│ gl_account            VARCHAR(20)    NOT NULL          │
│ gl_posted             BOOLEAN        DEFAULT false     │
│ gl_posting_date       DATE                             │
│ gl_batch_id           VARCHAR(20)                      │
│ reinsurance_ceded     DECIMAL(14,2)  DEFAULT 0         │
│ reinsurance_treaty_id VARCHAR(20)                      │
│ tax_reportable        BOOLEAN        DEFAULT false     │
│ tax_form              VARCHAR(10)    (1099-MISC, NEC)  │
│ created_by            VARCHAR(50)    NOT NULL          │
│ approved_by           VARCHAR(50)                      │
│ approval_date         TIMESTAMP                        │
│ notes                 TEXT                              │
│ created_at            TIMESTAMP      DEFAULT NOW()     │
│ updated_at            TIMESTAMP      DEFAULT NOW()     │
├────────────────────────────────────────────────────────┤
│ Indexes:                                               │
│   idx_fin_trans_claim (claim_id)                       │
│   idx_fin_trans_type (transaction_type)                │
│   idx_fin_trans_date (transaction_date)                │
│   idx_fin_trans_gl (gl_posted, gl_posting_date)        │
│   idx_fin_trans_payee (payee_id)                       │
│   idx_fin_trans_ay (accident_year)                     │
│   idx_fin_trans_coverage (coverage_code)               │
└────────────────────────────────────────────────────────┘

┌────────────────────────────────────────────────────────┐
│ Table: claim_financial_summary                          │
├────────────────────────────────────────────────────────┤
│ claim_id              UUID           PK, FK → claim    │
│ indemnity_reserve     DECIMAL(14,2)  DEFAULT 0         │
│ alae_reserve          DECIMAL(14,2)  DEFAULT 0         │
│ total_reserve         DECIMAL(14,2)  GENERATED         │
│ indemnity_paid        DECIMAL(14,2)  DEFAULT 0         │
│ alae_paid             DECIMAL(14,2)  DEFAULT 0         │
│ total_paid            DECIMAL(14,2)  GENERATED         │
│ indemnity_incurred    DECIMAL(14,2)  GENERATED         │
│ alae_incurred         DECIMAL(14,2)  GENERATED         │
│ total_incurred        DECIMAL(14,2)  GENERATED         │
│ salvage_received      DECIMAL(14,2)  DEFAULT 0         │
│ subrogation_received  DECIMAL(14,2)  DEFAULT 0         │
│ other_recovery        DECIMAL(14,2)  DEFAULT 0         │
│ total_recovery        DECIMAL(14,2)  GENERATED         │
│ net_incurred          DECIMAL(14,2)  GENERATED         │
│ deductible_applied    DECIMAL(10,2)  DEFAULT 0         │
│ deductible_reimbursed DECIMAL(10,2)  DEFAULT 0         │
│ reinsurance_ceded     DECIMAL(14,2)  DEFAULT 0         │
│ net_of_reinsurance    DECIMAL(14,2)  GENERATED         │
│ last_reserve_date     DATE                             │
│ last_payment_date     DATE                             │
│ last_recovery_date    DATE                             │
│ updated_at            TIMESTAMP      DEFAULT NOW()     │
├────────────────────────────────────────────────────────┤
│ Generated columns:                                     │
│   total_reserve = indemnity_reserve + alae_reserve     │
│   total_paid = indemnity_paid + alae_paid              │
│   indemnity_incurred = indemnity_reserve + indemnity_paid│
│   total_incurred = total_reserve + total_paid          │
│   total_recovery = salvage + subrogation + other       │
│   net_incurred = total_incurred - total_recovery       │
│   net_of_reinsurance = net_incurred - reinsurance_ceded│
└────────────────────────────────────────────────────────┘
```

---

## 24. General Ledger Integration

### 24.1 GL Integration Architecture

```
GL INTEGRATION ARCHITECTURE
==============================

┌──────────────────┐    ┌──────────────────┐    ┌──────────────────┐
│ Claims System    │    │ GL Integration   │    │ General Ledger   │
│                  │    │ Service          │    │ (SAP, Oracle,    │
│ Financial        │───▶│                  │───▶│  PeopleSoft)     │
│ Transactions     │    │ ├── Map accounts │    │                  │
│                  │    │ ├── Validate     │    │ Journal Entries  │
│                  │◀───│ ├── Batch/create │◀───│ Confirmation     │
│ Confirmation     │    │ └── Reconcile    │    │                  │
└──────────────────┘    └──────────────────┘    └──────────────────┘

Integration Patterns:
  1. Real-time: Each transaction immediately creates GL entry
  2. Batch: Transactions accumulated, posted in daily/nightly batch
  3. Hybrid: Payments real-time, reserves in batch

Typical batching:
  ├── Reserve transactions: Daily batch (end of business)
  ├── Payment transactions: Real-time or twice daily
  ├── Recovery transactions: Daily batch
  └── Month-end adjustments: Monthly batch
```

### 24.2 GL Account Mapping

```
GL ACCOUNT MAPPING (SAMPLE)
==============================

Claims Transaction              GL Debit          GL Credit
──────────────────────────      ──────────────    ──────────────
Set Reserve (Indemnity)         6100-Losses Inc   2200-Loss Reserves
Set Reserve (ALAE)              6200-ALAE Inc     2210-ALAE Reserves
Increase Reserve (Indemnity)    6100-Losses Inc   2200-Loss Reserves
Decrease Reserve (Indemnity)    2200-Loss Reserves 6100-Losses Inc
Payment (Indemnity-Check)       2200-Loss Reserves 1010-Cash
Payment (Indemnity-EFT)         2200-Loss Reserves 1020-Bank-EFT
Payment (ALAE)                  2210-ALAE Reserves 1010-Cash
Subrogation Recovery            1010-Cash          6100-Losses Inc
Salvage Recovery                1010-Cash          6100-Losses Inc
Void Payment                    1010-Cash          2200-Loss Reserves
Close Reserve (Release)         2200-Loss Reserves 6100-Losses Inc
Reinsurance Ceded               1300-RI Recoverbl  6300-Ceded Loss

Account Structure (Sample COA):
  1xxx  Assets
    1010  Cash and Bank
    1020  EFT Clearing
    1300  Reinsurance Recoverable
  2xxx  Liabilities
    2200  Loss Reserves
    2210  ALAE Reserves
    2220  ULAE Reserves
    2230  IBNR Reserves
  6xxx  Losses and Expenses
    6100  Losses Incurred
    6200  ALAE Incurred
    6300  Ceded Losses
    6400  Salvage & Subrogation
```

---

## 25. Claims Financial Dashboard

```
CLAIMS FINANCIAL DASHBOARD DESIGN
====================================

PANEL 1: EXECUTIVE KPIs (Top Row)
┌──────────────┐ ┌──────────────┐ ┌──────────────┐ ┌──────────────┐
│ Loss Ratio   │ │ Combined     │ │ Total        │ │ Reserve      │
│ (CY)         │ │ Ratio        │ │ Incurred     │ │ Adequacy     │
│   62.3%      │ │   97.8%      │ │   $485M      │ │  1.02        │
│  ▲ +1.2pts   │ │  ▲ +0.8pts   │ │  ▲ +3.5%     │ │  (adequate)  │
└──────────────┘ └──────────────┘ └──────────────┘ └──────────────┘

PANEL 2: RESERVES SUMMARY (Left)
  ┌─────────────────────────────────────┐
  │ Total Outstanding Reserves: $2.1B   │
  │                                     │
  │ By type:                            │
  │   Indemnity:  $1,680M  (80%)       │
  │   ALAE:       $315M    (15%)       │
  │   ULAE:       $105M    (5%)        │
  │                                     │
  │ By LOB:                             │
  │   Auto BI:    $840M    (40%)       │
  │   Auto PD:    $315M    (15%)       │
  │   Property:   $420M    (20%)       │
  │   WC:         $315M    (15%)       │
  │   GL:         $210M    (10%)       │
  └─────────────────────────────────────┘

PANEL 3: PAID LOSSES TREND (Line Chart)
  Monthly paid losses (rolling 24 months)
  With moving average and budget line

PANEL 4: RESERVE DEVELOPMENT (Waterfall Chart)
  Opening reserves → New claims → Development → Payments → Closing

PANEL 5: LOSS RATIO BY LOB (Bar Chart)
  Side-by-side: Current year vs Prior year vs Budget
  For each major LOB

PANEL 6: PAYMENT ACTIVITY (Table)
  Today's payments: Count, Total $, Avg $
  This week: Count, Total $
  This month: Count, Total $
  Year to date: Count, Total $
```

---

## 26. Audit Trail Requirements

```
AUDIT TRAIL REQUIREMENTS FOR FINANCIAL TRANSACTIONS
======================================================

Every financial transaction MUST capture:
  ├── Transaction ID (unique, immutable)
  ├── Claim ID
  ├── Transaction type and subtype
  ├── Amount (pre and post)
  ├── Date and time (system timestamp, not editable)
  ├── User who initiated
  ├── User who approved (if applicable)
  ├── Reason/justification
  ├── Before-state (prior reserve/balance)
  ├── After-state (new reserve/balance)
  ├── GL account mapping
  ├── GL posting status
  └── Any supporting document references

Immutability Rules:
  ├── No deletion of financial records (soft delete only)
  ├── No modification of posted transactions (create reversing entry)
  ├── All changes create new audit trail entries
  ├── System timestamps cannot be overridden by users
  └── Audit trail accessible to internal audit and regulators

Retention Requirements:
  ├── SAP: Minimum 5 years after policy expiration
  ├── GAAP: 7 years minimum
  ├── Tax (1099): 7 years minimum
  ├── State DOI: Varies, typically 5-7 years
  └── Best practice: 10 years or until all claims closed + 3 years
```

---

## 27. Reconciliation Processes

```
RECONCILIATION PROCESSES
===========================

1. DAILY RECONCILIATION:
   Claims system total payments = Bank disbursement total
   ├── Match: Check numbers, EFT references, amounts
   ├── Exception: Unmatched items investigated same day
   └── Report: Daily reconciliation report to Claims Finance

2. MONTHLY RESERVE RECONCILIATION:
   Sum of individual claim reserves = GL reserve balance
   ├── Run detailed reconciliation by LOB and coverage
   ├── Investigate variances > $1,000
   ├── Common causes: timing, posting errors, reclassifications
   └── Sign-off by Claims Finance Manager

3. MONTHLY PAYMENT RECONCILIATION:
   Claims system YTD payments = GL losses paid YTD
   ├── Reconcile by LOB, payment type
   ├── Reconcile outstanding checks
   ├── Match stale-dated and voided checks
   └── Verify 1099 accumulations

4. QUARTERLY REINSURANCE RECONCILIATION:
   Claims ceded reserves = Reinsurance recoverable balance
   ├── Reconcile by treaty
   ├── Verify ceded calculations per treaty terms
   └── Submit bordereaux to reinsurers

5. ANNUAL RECONCILIATION:
   Claims financials = Annual Statement (Schedule P, Parts 1-4)
   ├── Full reconciliation for audit
   ├── Accident year triangles verified
   ├── Reserve changes traced to source
   └── External auditor walkthrough
```

---

## 28. Month-End & Year-End Close

```
MONTH-END CLOSE PROCESS FOR CLAIMS
=====================================

DAY 1 (1st business day after month-end):
  ├── Cut-off: All transactions dated within month are final
  ├── Run payment reconciliation
  ├── Run reserve reconciliation
  └── Identify and resolve exceptions

DAY 2-3:
  ├── Post final GL entries
  ├── Calculate ULAE accrual
  ├── Update reinsurance ceded calculations
  ├── Calculate anticipated S&S adjustment
  └── Prepare claims financial summary

DAY 4-5:
  ├── Review and approve monthly claims financials
  ├── Variance analysis (actual vs plan, actual vs prior month)
  ├── Prepare management reports
  └── Submit to Corporate Finance for consolidation

YEAR-END CLOSE (Additional Steps):
  ├── Actuarial reserve review (comprehensive)
  ├── IBNR reserve update (all accident years)
  ├── Management best estimate vs actuarial indicated
  ├── Reserve margin analysis
  ├── Schedule P preparation
  ├── External auditor reserve review
  ├── Audit of paid losses
  ├── 1099 preparation and filing
  ├── Annual Statement preparation
  └── Board reserve certification
```

---

## 29. Sample Financial Formats & GL Mappings

### 29.1 Payment Transaction JSON

```json
{
  "transactionId": "TXN-2024-00892634",
  "claimId": "CLM-2024-00158372",
  "transactionType": "PAYMENT",
  "transactionSubtype": "INDEMNITY",
  "transactionDate": "2024-04-15",
  "effectiveDate": "2024-04-15",
  "amount": 7200.00,
  "payee": {
    "payeeId": "VND-00123",
    "payeeName": "ABC Auto Body",
    "payeeType": "VENDOR",
    "taxId": "XX-XXXXXXX",
    "taxIdType": "EIN",
    "w9OnFile": true
  },
  "paymentMethod": "EFT",
  "paymentReference": "ACH-20240415-00892634",
  "coverageCode": "COLL",
  "lobCode": "AUTO_PD",
  "accidentYear": 2024,
  "glEntries": [
    {
      "accountCode": "2200",
      "accountName": "Loss Reserves",
      "debitCredit": "DEBIT",
      "amount": 7200.00
    },
    {
      "accountCode": "1020",
      "accountName": "Bank - EFT",
      "debitCredit": "CREDIT",
      "amount": 7200.00
    }
  ],
  "priorBalance": {
    "reserve": 9500.00,
    "paid": 0.00,
    "incurred": 9500.00
  },
  "postBalance": {
    "reserve": 2300.00,
    "paid": 7200.00,
    "incurred": 9500.00
  },
  "taxReportable": true,
  "taxForm": "1099-NEC",
  "reinsuranceCeded": 0.00,
  "createdBy": "system_auto_pay",
  "approvedBy": "auto_approved",
  "notes": "Repair payment per approved estimate"
}
```

### 29.2 Reserve Change Transaction JSON

```json
{
  "transactionId": "TXN-2024-00892635",
  "claimId": "CLM-2024-00158372",
  "transactionType": "RESERVE_CHANGE",
  "transactionSubtype": "INDEMNITY",
  "transactionDate": "2024-04-20",
  "effectiveDate": "2024-04-20",
  "amount": 3500.00,
  "changeDirection": "INCREASE",
  "reasonCode": "NEW_ESTIMATE",
  "reasonDescription": "Supplement estimate received - additional hidden damage found",
  "coverageCode": "COLL",
  "lobCode": "AUTO_PD",
  "accidentYear": 2024,
  "glEntries": [
    {
      "accountCode": "6100",
      "accountName": "Losses Incurred",
      "debitCredit": "DEBIT",
      "amount": 3500.00
    },
    {
      "accountCode": "2200",
      "accountName": "Loss Reserves",
      "debitCredit": "CREDIT",
      "amount": 3500.00
    }
  ],
  "priorBalance": {
    "reserve": 2300.00,
    "paid": 7200.00,
    "incurred": 9500.00
  },
  "postBalance": {
    "reserve": 5800.00,
    "paid": 7200.00,
    "incurred": 13000.00
  },
  "authorityLevel": "STAFF_ADJUSTER",
  "authorityLimit": 25000.00,
  "approvalRequired": false,
  "createdBy": "adj_smith_j",
  "approvedBy": "adj_smith_j",
  "supportingDocuments": ["supplement_estimate_v2.pdf"]
}
```

### 29.3 Monthly Financial Summary Report Format

```
CLAIMS FINANCIAL SUMMARY - APRIL 2024
========================================

                        Auto PD      Auto BI      Property     WC          GL          TOTAL
                        ─────────    ─────────    ─────────    ─────────   ─────────   ─────────
RESERVES:
  Opening Reserve       $315.2M      $840.5M      $420.1M      $315.0M     $210.3M     $2,101.1M
  New Claim Reserves    $28.5M       $42.0M       $35.0M       $18.0M      $12.0M      $135.5M
  Reserve Increases     $8.2M        $35.0M       $12.5M       $10.0M      $8.0M       $73.7M
  Reserve Decreases     ($5.5M)      ($12.0M)     ($8.0M)      ($4.0M)     ($3.0M)     ($32.5M)
  Payments Applied      ($25.0M)     ($38.0M)     ($30.0M)     ($16.0M)    ($10.0M)    ($119.0M)
  Reserve Releases      ($8.0M)      ($5.0M)      ($10.0M)     ($5.0M)     ($2.0M)     ($30.0M)
  Closing Reserve       $313.4M      $862.5M      $419.6M      $318.0M     $215.3M     $2,128.8M

PAID LOSSES:
  Indemnity Paid        $22.5M       $33.0M       $27.0M       $13.0M      $8.0M       $103.5M
  ALAE Paid             $2.5M        $5.0M        $3.0M        $3.0M       $2.0M       $15.5M
  Total Paid            $25.0M       $38.0M       $30.0M       $16.0M      $10.0M      $119.0M

RECOVERIES:
  Subrogation           $3.5M        $0.5M        $1.0M        $0.8M       $0.2M       $6.0M
  Salvage               $4.0M        $0.0M        $0.5M        $0.0M       $0.0M       $4.5M
  Total Recoveries      $7.5M        $0.5M        $1.5M        $0.8M       $0.2M       $10.5M

NET INCURRED:
  Current Month         $31.2M       $65.0M       $39.5M       $24.0M      $17.0M      $176.7M
  YTD                   $128.5M      $262.0M      $155.0M      $98.0M      $68.0M      $711.5M

LOSS RATIOS:
  Current Month         62.4%        65.0%        58.2%        60.0%       68.0%       62.5%
  YTD                   61.8%        63.5%        57.0%        58.5%       66.0%       61.5%
  Prior Year            60.5%        62.0%        55.5%        57.0%       64.0%       60.0%

CLAIM COUNTS:
  Open Claims           12,500       8,200        6,800        5,400       3,200       36,100
  New This Month        3,500        1,200        2,000        900         400         8,000
  Closed This Month     3,200        800          2,100        850         350         7,300
```

---

## Appendix A: Glossary of Financial Terms

| Term | Definition |
|---|---|
| ACV | Actual Cash Value: replacement cost minus depreciation |
| ALAE | Allocated Loss Adjustment Expense: costs tied to specific claims |
| AWW | Average Weekly Wage: basis for WC benefit calculation |
| IBNR | Incurred But Not Reported: actuarial estimate of unreported claims |
| Incurred | Total of paid losses plus outstanding reserves |
| LAE | Loss Adjustment Expense: cost of adjusting and settling claims |
| Loss Ratio | Losses incurred divided by premiums earned |
| MMI | Maximum Medical Improvement: point of no further recovery |
| PPD | Permanent Partial Disability: scheduled WC benefit |
| PTD | Permanent Total Disability: lifetime WC benefit |
| RBC | Risk-Based Capital: regulatory solvency measure |
| SAP | Statutory Accounting Principles: NAIC-mandated rules |
| Schedule P | Annual Statement exhibit showing loss development |
| S&S | Salvage and Subrogation: recoveries from third parties |
| TTD | Temporary Total Disability: WC benefit during recovery |
| ULAE | Unallocated Loss Adjustment Expense: overhead costs |
| Ultimate Loss | Total expected cost of all claims from an accident year |

---

*This article is part of the PnC Claims Encyclopedia. For related topics, see Article 6 (Claims Automation & STP), Article 9 (Subrogation & Recovery), and Article 5 (Claims Workflow Management).*
