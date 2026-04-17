# Subrogation & Recovery: Complete Operations Guide

## A Comprehensive Architecture & Implementation Guide for P&C Insurance

---

## Table of Contents

1. [Subrogation Fundamentals](#1-subrogation-fundamentals)
2. [Subrogation Lifecycle](#2-subrogation-lifecycle)
3. [Subrogation Identification & Triggers](#3-subrogation-identification--triggers)
4. [ML-Based Subrogation Scoring](#4-ml-based-subrogation-scoring)
5. [Demand Letter Generation & Management](#5-demand-letter-generation--management)
6. [Inter-Company Arbitration](#6-inter-company-arbitration)
7. [Arbitration Data Formats](#7-arbitration-data-formats)
8. [Litigation Management for Subrogation](#8-litigation-management-for-subrogation)
9. [Recovery Tracking & Accounting](#9-recovery-tracking--accounting)
10. [Salvage Operations](#10-salvage-operations)
11. [Deductible Reimbursement](#11-deductible-reimbursement)
12. [Third-Party Liability Recovery](#12-third-party-liability-recovery)
13. [Workers Compensation Subrogation](#13-workers-compensation-subrogation)
14. [Made-Whole & Common Fund Doctrines](#14-made-whole--common-fund-doctrines)
15. [State-Specific Subrogation Laws](#15-state-specific-subrogation-laws)
16. [Subrogation Data Model](#16-subrogation-data-model)
17. [Integration with Arbitration Forums](#17-integration-with-arbitration-forums)
18. [Automated Subrogation Rules](#18-automated-subrogation-rules)
19. [Subrogation Workflow State Machine](#19-subrogation-workflow-state-machine)
20. [Financial Accounting for Recoveries](#20-financial-accounting-for-recoveries)
21. [Performance Metrics](#21-performance-metrics)
22. [Vendor Management](#22-vendor-management)
23. [Technology Platform Requirements](#23-technology-platform-requirements)
24. [Sample Demand Data Formats](#24-sample-demand-data-formats)

---

## 1. Subrogation Fundamentals

### 1.1 Definition of Subrogation

Subrogation is the legal right of an insurer, after paying a loss, to "step into the shoes" of the insured and seek recovery from the party responsible for causing the loss. It is a fundamental principle of insurance designed to prevent unjust enrichment and ensure the at-fault party ultimately bears the financial responsibility.

### 1.2 Types of Subrogation

| Type | Definition | Legal Basis | Example |
|------|-----------|-------------|---------|
| **Conventional** | Arises from the insurance contract itself (policy language) | Express policy provision | Standard auto policy subrogation clause |
| **Equitable** | Arises from principles of equity, not contract | Court-implied right | Insurer paid claim, seeks equity against tortfeasor |
| **Statutory** | Created by specific state statute | State law | Workers comp subrogation rights under state statute |

### 1.3 Subrogation vs Related Concepts

```
CONCEPT COMPARISON:

  SUBROGATION:
    - Insurer steps into insured's shoes
    - Recovery against at-fault third party
    - Based on insured's rights against tortfeasor
    - Insurer must pay claim first
    
  CONTRIBUTION:
    - Recovery between co-insurers
    - When multiple insurers cover same risk
    - Each pays proportional share
    - "Other insurance" clauses
    
  INDEMNIFICATION:
    - Contractual right to be held harmless
    - Not dependent on fault
    - Based on contract between parties
    - Common in commercial/vendor agreements
    
  SALVAGE:
    - Recovery from damaged property itself
    - Sale of damaged vehicle, materials, etc.
    - Reduces net claim cost
    - Not against a third party
    
  RESTITUTION:
    - Recovery of improper payment
    - Fraud, mistake, unjust enrichment
    - Against recipient of improper payment
    - Not subrogation-specific
```

### 1.4 Subrogation Financial Impact

```
INDUSTRY SUBROGATION METRICS:

  Total P&C subrogation recoveries (annual):     ~$40-50 billion
  Average recovery rate (auto collision):          35-45%
  Average recovery rate (auto comp - theft):       10-15%
  Average recovery rate (property - fire):         15-25%
  Average recovery rate (WC third-party):          8-12%
  
  Recovery as % of incurred losses:                8-12%
  
  Top carriers recovery rates:                     40-50%
  Bottom carriers recovery rates:                  15-25%
  
  Improvement opportunity (industry):              $8-15 billion
  
  IMPACT ON COMBINED RATIO:
    A 5% improvement in recovery rate ≈ 1-2 point
    improvement in loss ratio ≈ 1-2 point improvement
    in combined ratio
```

---

## 2. Subrogation Lifecycle

### 2.1 End-to-End Lifecycle

```
┌──────────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐
│ IDENTIFI-    │  │ DEMAND   │  │ NEGOTIA- │  │ ARBITRA- │
│ CATION       │──▶│          │──▶│ TION     │──▶│ TION/    │
│              │  │          │  │          │  │ LITIGATION│
└──────────────┘  └──────────┘  └──────────┘  └──────────┘
                                                     │
┌──────────────┐  ┌──────────┐                      │
│ ACCOUNTING   │  │ RECOVERY │◀─────────────────────┘
│              │◀──│          │
└──────────────┘  └──────────┘

DETAILED STEPS:

Phase 1: IDENTIFICATION (Day 0-14)
  ├─ Identify subrogation potential at FNOL
  ├─ Confirm third-party liability
  ├─ Obtain adverse party information
  ├─ Document liability evidence
  ├─ Create subrogation file
  └─ Assign to subrogation unit

Phase 2: DEMAND (Day 14-60)
  ├─ Determine adverse carrier (if insured)
  ├─ Prepare demand package
  ├─ Calculate demand amount (paid + outstanding reserves)
  ├─ Send demand letter with supporting documentation
  ├─ Follow up on demand acknowledgment
  └─ Track response timeline

Phase 3: NEGOTIATION (Day 30-120)
  ├─ Review adverse response
  ├─ Counter-offer if partial denial
  ├─ Liability negotiation
  ├─ Damage amount negotiation
  ├─ Settlement agreement
  └─ Escalate to arbitration if no agreement

Phase 4: ARBITRATION/LITIGATION (Day 60-365+)
  ├─ File arbitration with Arbitration Forums (if inter-company)
  ├─ Submit evidence and contentions
  ├─ Participate in hearing (if applicable)
  ├─ Receive arbitration decision
  ├─ OR file lawsuit (if no arbitration agreement)
  ├─ Litigation management
  └─ Judgment or settlement

Phase 5: RECOVERY (Upon Settlement/Decision)
  ├─ Receive payment from adverse party/carrier
  ├─ Apply payment to claim
  ├─ Calculate deductible reimbursement
  ├─ Reimburse insured's deductible
  ├─ Update reserves
  └─ Close subrogation file

Phase 6: ACCOUNTING (Ongoing)
  ├─ Record recovery in financial systems
  ├─ Update loss triangles
  ├─ Impact IBNR calculations
  ├─ Regulatory reporting
  └─ Performance reporting
```

---

## 3. Subrogation Identification & Triggers

### 3.1 Identification Sources

```
SUBROGATION IDENTIFICATION TRIGGERS:

  AT FNOL:
    ├─ Third-party involved in accident
    ├─ Other driver at fault (police report, admission)
    ├─ Product defect reported
    ├─ Premises liability indicated
    ├─ Vandalism with identified perpetrator
    ├─ Hit-and-run with identifiable vehicle
    └─ Contractor/subcontractor negligence

  DURING INVESTIGATION:
    ├─ Police report assigns fault to other party
    ├─ Witness statements support third-party fault
    ├─ Accident reconstruction shows third-party fault
    ├─ Product failure identified during inspection
    ├─ Building code violation caused or contributed
    └─ Weather event with responsible party (fallen tree, etc.)

  POST-PAYMENT:
    ├─ Newly discovered adverse party
    ├─ Litigation reveals additional responsible parties
    ├─ Cross-claim in related litigation
    └─ Information from other carrier's investigation

  AUTOMATED DETECTION:
    ├─ ML subrogation scoring model
    ├─ Rules-based identification
    ├─ NLP analysis of loss description
    ├─ Police report data extraction
    └─ Third-party claim data cross-reference
```

### 3.2 Identification Decision Matrix

| Loss Type | Subro Potential | Key Indicator | Auto-Identify? |
|-----------|----------------|---------------|---------------|
| Collision – rear-ended | Very High | Other driver hit insured from behind | Yes |
| Collision – intersection | High | Police report / witness / traffic controls | Yes (if police report) |
| Collision – multi-vehicle | Medium | Depends on fault determination | After investigation |
| Collision – single vehicle | Low | Unless road defect, animal, etc. | No |
| Comprehensive – theft | Low | Rarely identified perpetrator | No |
| Comprehensive – vandalism | Low | Occasionally identified perpetrator | No |
| Comprehensive – animal | Low | Possible against animal owner in rare cases | No |
| Comprehensive – weather | Very Low | Force majeure, generally no party | No |
| Property – fire | Medium | Arson by identifiable party, product defect | After investigation |
| Property – water | Medium | Plumbing failure (product), neighbor negligence | After investigation |
| Property – wind/hail | Low | CAT event, generally no party | No |
| WC – third-party | Medium | Employer/employee vs third party | After investigation |
| GL – cross-claim | Medium | Indemnification/contribution from co-defendant | After investigation |
| Product liability | High | Product defect causing loss | After investigation |

---

## 4. ML-Based Subrogation Scoring

### 4.1 Model Design

```
MODEL: Subrogation Potential Scorer

OBJECTIVE: Predict probability of successful subrogation recovery at FNOL

ALGORITHM: XGBoost Classifier

TARGET VARIABLE: subrogation_recovery > $0 (binary)

FEATURES:
  Claim Features:
    - Loss cause code (rear-end, intersection, product, etc.)
    - Number of vehicles/parties
    - Police report available
    - Fault determination (if available)
    - Third-party identified
    - Third-party insurance identified
    - Loss description NLP features
    
  Historical Features:
    - Recovery rate by loss cause code
    - Recovery rate by state
    - Recovery rate by adverse carrier
    - Average recovery amount for similar claims
    
  External Features:
    - State subrogation laws (favorable/unfavorable)
    - Comparative negligence rules
    - Arbitration agreement availability
    - Adverse carrier cooperation history

PERFORMANCE:
  AUC-ROC: 0.88
  Precision@80%recall: 0.72
  Lift@Top20%: 3.5x

OUTPUT:
  {
    "claim_id": "CLM-2024-001234",
    "subrogation_probability": 0.82,
    "estimated_recovery_amount": 4200,
    "estimated_recovery_timeline": "90-120 days",
    "recovery_method": "INTER_COMPANY_ARBITRATION",
    "adverse_carrier": "State Farm",
    "confidence": 0.85,
    "key_factors": [
      "Clear rear-end collision",
      "Police report assigns fault to other driver",
      "Adverse carrier identified and active",
      "State has favorable subrogation laws"
    ],
    "recommended_action": "AUTO_DEMAND",
    "priority": "HIGH"
  }
```

### 4.2 Scoring Thresholds and Actions

| Score Range | Probability | Action | Priority |
|------------|-------------|--------|----------|
| 0.80 – 1.00 | Very High | Auto-generate demand, assign to subro unit | Immediate |
| 0.60 – 0.79 | High | Flag for subro review, prepare demand | High |
| 0.40 – 0.59 | Medium | Flag for adjuster assessment | Medium |
| 0.20 – 0.39 | Low | Note on claim, review at closing | Low |
| 0.00 – 0.19 | Very Low | No action, standard processing | None |

---

## 5. Demand Letter Generation & Management

### 5.1 Demand Letter Components

```
DEMAND LETTER STRUCTURE:

  HEADER:
    - Carrier name and address
    - Subrogation unit contact information
    - Date of letter
    - Claim number / file reference
    - Adverse carrier / party address

  SECTION 1: NOTICE OF SUBROGATION INTEREST
    - Statement of subrogation rights
    - Policy reference
    - Legal basis (contract, statute)

  SECTION 2: FACTS OF LOSS
    - Date, time, location of loss
    - Description of incident
    - Parties involved
    - Police report reference

  SECTION 3: LIABILITY STATEMENT
    - Basis for adverse party liability
    - Supporting evidence summary
    - Applicable law (negligence, strict liability)

  SECTION 4: DAMAGES
    - Itemized payments:
      ├─ Vehicle repair/replacement
      ├─ Rental vehicle
      ├─ Towing
      ├─ Medical payments
      ├─ Loss of use
      └─ Other expenses
    - Total amount demanded
    - Deductible amount (for reimbursement)

  SECTION 5: DEMAND
    - Specific dollar amount demanded
    - Payment deadline (typically 30 days)
    - Payment instructions
    - Warning of further action if not paid

  ATTACHMENTS:
    - Police report
    - Repair estimate / invoice
    - Photos of damage
    - Medical bills (if applicable)
    - Rental receipts
    - Towing receipt
    - Payment proof / checks issued
    - Policy declarations (relevant pages)
```

### 5.2 Demand Letter Template Engine

```
TEMPLATE SYSTEM:

  Templates organized by:
    ├─ LOB (Auto, Property, WC, GL)
    ├─ Subrogation type (collision, comp, product, premises)
    ├─ Adverse party type (insured carrier, uninsured individual, commercial)
    └─ State (state-specific language requirements)

  Template Variables:
    ${carrier_name}
    ${carrier_address}
    ${claim_number}
    ${insured_name}
    ${adverse_party_name}
    ${adverse_carrier_name}
    ${adverse_claim_number}
    ${date_of_loss}
    ${loss_location}
    ${loss_description}
    ${liability_basis}
    ${total_demand_amount}
    ${deductible_amount}
    ${payment_deadline}
    ${payment_instructions}
    ${itemized_damages[]}
    ${state_specific_language}
    ${policy_number}
    ${police_report_number}

  Generation Process:
    1. Select template based on claim attributes
    2. Populate variables from claim data
    3. Generate itemized damages table
    4. Apply state-specific language
    5. Generate PDF
    6. Queue for review (if over threshold) or auto-send
    7. Track delivery and response
```

### 5.3 Demand Tracking Data Model

```sql
CREATE TABLE subrogation_demand (
    demand_id            UUID PRIMARY KEY,
    subrogation_id       UUID NOT NULL,
    claim_id             VARCHAR(20) NOT NULL,
    demand_number        VARCHAR(30) NOT NULL,
    demand_type          VARCHAR(30) NOT NULL,
    demand_date          DATE NOT NULL,
    demand_amount        DECIMAL(12,2) NOT NULL,
    deductible_amount    DECIMAL(10,2),
    adverse_party_name   VARCHAR(200),
    adverse_party_type   VARCHAR(30),
    adverse_carrier_name VARCHAR(200),
    adverse_carrier_naic VARCHAR(10),
    adverse_claim_number VARCHAR(30),
    delivery_method      VARCHAR(20) NOT NULL,
    delivery_date        DATE,
    delivery_confirmation VARCHAR(100),
    response_due_date    DATE NOT NULL,
    response_received_date DATE,
    response_type        VARCHAR(30),
    response_amount      DECIMAL(12,2),
    response_notes       TEXT,
    status               VARCHAR(20) NOT NULL DEFAULT 'SENT',
    follow_up_count      INTEGER DEFAULT 0,
    last_follow_up_date  DATE,
    template_id          VARCHAR(50),
    generated_by         VARCHAR(50),
    approved_by          VARCHAR(50),
    created_at           TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at           TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Status values: DRAFT, PENDING_APPROVAL, SENT, ACKNOWLEDGED,
--   ACCEPTED, PARTIALLY_ACCEPTED, DENIED, NEGOTIATING,
--   ARBITRATION_FILED, CLOSED
```

---

## 6. Inter-Company Arbitration

### 6.1 Arbitration Forums Inc. Overview

Arbitration Forums Inc. (AF) is the primary organization facilitating inter-company arbitration for automobile insurance subrogation disputes in the United States.

| Feature | Detail |
|---------|--------|
| **Founded** | 1943 |
| **Members** | 350+ insurance companies |
| **Annual Filings** | ~700,000+ |
| **Annual Dollars Arbitrated** | $7+ billion |
| **Dispute Types** | Auto collision, property damage, uninsured motorist, medical payments |
| **Binding** | Yes (per membership agreement) |
| **Platforms** | AF Online, e-Subro Hub |
| **Decision Time** | 60-90 days typical |

### 6.2 Arbitration Process Flow

```
INTER-COMPANY ARBITRATION PROCESS:

  STEP 1: FILING (Day 0)
    ├─ Insurer files arbitration demand via AF Online
    ├─ Include: claim details, liability contentions, damages
    ├─ Attach: police report, photos, estimates, payments
    ├─ Filing fee: varies by amount ($50-$200)
    └─ Statute of limitations: 2 years from payment (AF rules)

  STEP 2: NOTICE (Days 1-15)
    ├─ AF serves notice on responding company
    ├─ Respondent has 40 days to respond (standard)
    ├─ Extension requests allowed (one 30-day extension)
    └─ Default if no response (applicant wins by default)

  STEP 3: RESPONSE (Days 15-55)
    ├─ Respondent submits response and counter-contentions
    ├─ May accept liability, contest, or file counter-demand
    ├─ Attach supporting documentation
    └─ Counter-demand allowed (for respondent's damages)

  STEP 4: PANEL ASSIGNMENT (Days 55-60)
    ├─ AF assigns panel of arbitrators (typically 3)
    ├─ Arbitrators are experienced claims professionals
    ├─ From non-party insurance companies
    └─ Conflict of interest screening

  STEP 5: DECISION (Days 60-90)
    ├─ Panel reviews submissions from both parties
    ├─ No oral hearing in standard arbitration
    ├─ Decision based on documentation submitted
    ├─ Majority rules (2 of 3 arbitrators)
    ├─ Decision includes:
    │   ├─ Liability allocation (percentage)
    │   ├─ Damages awarded
    │   └─ Reasoning (brief)
    └─ Decision is binding per AF agreement

  STEP 6: PAYMENT (Days 90-120)
    ├─ Losing party pays within 30 days
    ├─ Payment through AF clearing system
    ├─ Netting across multiple filings between same parties
    └─ Interest accrues if late

  STEP 7: APPEAL (If applicable)
    ├─ Limited appeal rights (AF rules)
    ├─ Must show material error in process
    ├─ Appeal fee: higher than filing fee
    └─ Appeal panel: different arbitrators
```

### 6.3 Arbitration Types

| Type | Description | Dollar Range | Decision Method |
|------|-------------|-------------|-----------------|
| **Compact** | Simplified process for small claims | < $5,000 | Single arbitrator |
| **Standard** | Standard arbitration process | $5,000 – $100,000 | 3-member panel |
| **Special** | Complex disputes, large amounts | > $100,000 | Panel + hearing |
| **Nationwide** | Cross-state disputes | Any amount | Applicable rules vary |
| **UM/UIM** | Uninsured/underinsured motorist | Any amount | Specialized rules |
| **Med Pay** | Medical payments | Any amount | Simplified process |

---

## 7. Arbitration Data Formats

### 7.1 Electronic Filing Format

```json
{
  "filing_type": "STANDARD_ARBITRATION",
  "filing_date": "2024-03-15",
  "applicant": {
    "company_name": "ABC Insurance Company",
    "naic_code": "12345",
    "contact_name": "Jane Smith",
    "contact_email": "jane.smith@abcins.com",
    "contact_phone": "555-123-4567",
    "claim_number": "CLM-2024-001234",
    "insured_name": "John Doe",
    "policy_number": "PA-2024-12345678"
  },
  "respondent": {
    "company_name": "XYZ Insurance Company",
    "naic_code": "67890",
    "claim_number": "XYZ-2024-9876",
    "insured_name": "Jane Roe"
  },
  "loss_details": {
    "date_of_loss": "2024-02-14",
    "time_of_loss": "15:30",
    "location": {
      "address": "123 Main St & Oak Ave",
      "city": "Springfield",
      "state": "IL",
      "zip": "62701"
    },
    "loss_type": "COLLISION",
    "description": "Respondent's insured ran red light and struck applicant's insured broadside in intersection.",
    "police_report_number": "SPD-2024-0214-1234",
    "police_report_available": true,
    "weather": "CLEAR",
    "road_conditions": "DRY"
  },
  "vehicles": [
    {
      "role": "APPLICANT",
      "year": 2021,
      "make": "Toyota",
      "model": "Camry",
      "vin": "1HGBH41JXMN109186",
      "damage_area": "DRIVER_SIDE",
      "damage_severity": "MODERATE",
      "drivable": false
    },
    {
      "role": "RESPONDENT",
      "year": 2020,
      "make": "Ford",
      "model": "F-150",
      "vin": "1FTFW1E53JFB12345",
      "damage_area": "FRONT",
      "damage_severity": "MODERATE",
      "drivable": true
    }
  ],
  "liability_contentions": {
    "applicant_position": "Respondent's insured 100% at fault. Ran red light as confirmed by police report, traffic camera, and two independent witnesses.",
    "applicable_law": "IL negligence law; violation of traffic signal (625 ILCS 5/11-306)",
    "negligence_type": "NEGLIGENCE_PER_SE",
    "supporting_evidence": [
      "Police report (attached)",
      "Traffic camera footage (available upon request)",
      "Witness statement - Mary Johnson (attached)",
      "Witness statement - Robert Williams (attached)"
    ]
  },
  "damages": {
    "items": [
      {
        "type": "VEHICLE_REPAIR",
        "description": "Repair per estimate #EST-2024-5678",
        "amount": 8500.00,
        "documentation": "repair_estimate.pdf"
      },
      {
        "type": "RENTAL_VEHICLE",
        "description": "14 days @ $45/day (Enterprise)",
        "amount": 630.00,
        "documentation": "rental_receipt.pdf"
      },
      {
        "type": "TOWING",
        "description": "Tow from scene to repair facility",
        "amount": 185.00,
        "documentation": "tow_receipt.pdf"
      },
      {
        "type": "DIMINISHED_VALUE",
        "description": "Post-repair diminished value per appraisal",
        "amount": 1200.00,
        "documentation": "dv_appraisal.pdf"
      }
    ],
    "total_damages": 10515.00,
    "deductible_included": true,
    "deductible_amount": 500.00
  },
  "demand_amount": 10515.00,
  "attachments": [
    {"name": "police_report.pdf", "type": "POLICE_REPORT"},
    {"name": "repair_estimate.pdf", "type": "REPAIR_ESTIMATE"},
    {"name": "damage_photos.zip", "type": "PHOTOS"},
    {"name": "rental_receipt.pdf", "type": "RENTAL_RECEIPT"},
    {"name": "tow_receipt.pdf", "type": "TOW_RECEIPT"},
    {"name": "witness_johnson.pdf", "type": "WITNESS_STATEMENT"},
    {"name": "witness_williams.pdf", "type": "WITNESS_STATEMENT"},
    {"name": "payment_proof.pdf", "type": "PAYMENT_PROOF"},
    {"name": "dv_appraisal.pdf", "type": "APPRAISAL"}
  ]
}
```

---

## 8. Litigation Management for Subrogation

### 8.1 When to Litigate vs Arbitrate

| Factor | Arbitrate | Litigate |
|--------|----------|----------|
| Adverse party is insured carrier | Yes (AF member) | Only if not AF member |
| Adverse party is uninsured individual | No | Yes |
| Amount < $5,000 | Yes (Compact) | Cost prohibitive |
| Amount $5,000 – $100,000 | Yes (Standard) | Consider if bad faith |
| Amount > $100,000 | Yes (Special) or litigate | Complex, may prefer litigation |
| Product liability claim | Sometimes | Often (complex liability) |
| Multiple adverse parties | Possible | Often more appropriate |
| Coverage dispute involved | No | Yes (courts decide coverage) |
| Bad faith alleged | No | Yes |
| Statute of limitations issue | AF has own SOL (2 yr) | State-specific |

### 8.2 Subrogation Litigation Process

```
SUBROGATION LITIGATION WORKFLOW:

  STEP 1: LITIGATION EVALUATION
    ├─ Attorney recommendation
    ├─ Cost-benefit analysis
    │   ├─ Recovery amount potential
    │   ├─ Litigation costs estimate
    │   ├─ Probability of success
    │   └─ Expected net recovery
    ├─ Statute of limitations check
    └─ Authority approval

  STEP 2: ATTORNEY ENGAGEMENT
    ├─ Select from approved panel counsel
    ├─ Engagement letter / retention
    ├─ Provide claim file and evidence
    ├─ Litigation budget approval
    └─ Establish reporting requirements

  STEP 3: PRE-LITIGATION
    ├─ Final demand letter (attorney on letterhead)
    ├─ Settlement negotiation attempt
    ├─ Preservation of evidence notice
    └─ If no resolution → file suit

  STEP 4: LITIGATION
    ├─ File complaint
    ├─ Service of process
    ├─ Discovery (interrogatories, depositions, documents)
    ├─ Expert witnesses (if needed)
    ├─ Mediation (court-ordered or voluntary)
    ├─ Settlement conference
    ├─ Trial (if no settlement)
    └─ Judgment

  STEP 5: POST-JUDGMENT
    ├─ Collect judgment
    ├─ Garnishment/execution if needed
    ├─ Appeal (if applicable)
    └─ Close litigation file

  COST MANAGEMENT:
    Typical litigation costs for subrogation:
      Small claims ($5K-$25K):     $2,000-$5,000 legal costs
      Medium claims ($25K-$100K):  $5,000-$25,000 legal costs
      Large claims ($100K+):       $25,000-$100,000+ legal costs
    
    ROI Threshold:
      Litigate only if expected_recovery > 2x expected_costs
```

---

## 9. Recovery Tracking & Accounting

### 9.1 Recovery Transaction Types

| Transaction Type | Description | GL Impact |
|-----------------|-------------|-----------|
| **Subrogation Recovery** | Payment received from adverse party | Credit to loss paid |
| **Deductible Recovery** | Portion allocated to insured's deductible | Liability to insured |
| **Salvage Recovery** | Proceeds from sale of salvaged property | Credit to loss paid |
| **Contribution Recovery** | Payment from co-insurer | Credit to loss paid |
| **Restitution** | Payment from convicted fraudster | Credit to loss paid |
| **Workers Comp Recovery** | Third-party recovery in WC claim | Credit to loss paid |
| **Medicare Set-Aside** | Recovery of MSA funds | Specific accounting |
| **Recovery Expense** | Costs of recovery (legal, filing fees) | Debit to LAE |

### 9.2 Recovery Accounting Flow

```
RECOVERY ACCOUNTING:

  Gross Recovery Received:          $10,000
  
  ALLOCATION:
  ├─ Attorney fees (if contingency):  - $3,333  (33.3%)
  ├─ Litigation costs:                - $  500
  ├─ Filing fees:                     - $  150
  ├─ Net recovery:                    = $6,017
  │
  ├─ Deductible reimbursement:        - $  500  (to insured)
  ├─ Net to carrier:                  = $5,517
  │
  └─ Applied to claim:
       ├─ Indemnity recovery:          $4,517
       └─ Expense recovery:            $1,000
       
  FINANCIAL ENTRIES:
    DR  Cash/Bank Account                    $10,000
    CR  Accounts Payable - Attorney           $3,333
    CR  Accounts Payable - Insured (Deduct)   $  500
    CR  Loss Paid Recovery - Indemnity        $4,517
    CR  Loss Paid Recovery - Expense          $1,000
    DR  Recovery Expense (LAE)                $  650
    CR  Cash/Bank Account                     $  650
```

---

## 10. Salvage Operations

### 10.1 Total Loss Determination

```
TOTAL LOSS DETERMINATION PROCESS:

  METHOD 1: THRESHOLD METHOD
    IF repair_estimate > (vehicle_ACV * total_loss_threshold)
    THEN TOTAL_LOSS
    
    Thresholds vary by state:
      STATE    THRESHOLD    STATE    THRESHOLD
      AL       75%          MT       80%
      AK       80%          NE       75%
      AZ       100% (TLF)  NV       65%
      AR       70%          NH       75%
      CA       100% (TLF)  NJ       100% (TLF)
      CO       100% (TLF)  NM       100% (TLF)
      CT       100% (TLF)  NY       75%
      ...
    
    TLF = Total Loss Formula: repair + salvage > ACV

  METHOD 2: TOTAL LOSS FORMULA (TLF)
    IF (repair_cost + salvage_value) > vehicle_ACV
    THEN TOTAL_LOSS
    
    Example:
      Vehicle ACV:     $15,000
      Repair Estimate: $12,000
      Salvage Value:    $4,500
      Repair + Salvage: $16,500 > $15,000 → TOTAL LOSS

  METHOD 3: ECONOMIC TOTAL LOSS
    IF repair_cost > (vehicle_ACV - deductible)
    THEN ECONOMIC_TOTAL_LOSS
    (Insured would pay more than vehicle is worth)
```

### 10.2 Salvage Vendor Management

```
SALVAGE PROCESS:

  STEP 1: TOTAL LOSS DECLARATION
    ├─ Adjuster declares total loss
    ├─ Determine ACV (CCC/Mitchell/JD Power)
    ├─ Negotiate ACV with insured
    └─ Obtain title from insured and lienholder

  STEP 2: VEHICLE ASSIGNMENT TO SALVAGE
    ├─ Transport vehicle to salvage pool
    ├─ Generate salvage listing
    ├─ Take photos for auction
    └─ Assign to salvage vendor

  STEP 3: SALVAGE AUCTION
    ├─ List on Copart/IAA/other platform
    ├─ Set minimum bid (based on salvage estimate)
    ├─ Auction runs (typically 1-7 days)
    ├─ Buyer bids
    └─ Sale confirmed

  STEP 4: PROCEEDS
    ├─ Buyer pays salvage vendor
    ├─ Vendor remits to carrier (less fees)
    ├─ Carrier records salvage recovery
    └─ Title transferred to buyer

SALVAGE VENDORS:
  ┌─────────────────────────────────────────────────────────────┐
  │ Vendor    │ Type      │ Volume    │ Fee Structure           │
  ├───────────┼───────────┼───────────┼─────────────────────────┤
  │ Copart    │ Online    │ 3M+ /yr  │ Commission + buyer fees │
  │           │ auction   │           │ Avg return: 20-25% ACV  │
  ├───────────┼───────────┼───────────┼─────────────────────────┤
  │ IAA       │ Online    │ 2.5M+ /yr│ Commission + buyer fees │
  │ (Ritchie) │ auction   │           │ Avg return: 20-25% ACV  │
  ├───────────┼───────────┼───────────┼─────────────────────────┤
  │ Regional  │ Local     │ Varies   │ Fixed fee or commission  │
  │ salvage   │ auction   │           │ Avg return: 15-20% ACV  │
  └─────────────────────────────────────────────────────────────┘
```

### 10.3 Salvage Data Model

```sql
CREATE TABLE salvage_vehicle (
    salvage_id          UUID PRIMARY KEY,
    claim_id            VARCHAR(20) NOT NULL,
    vehicle_vin         VARCHAR(17) NOT NULL,
    vehicle_year        INTEGER,
    vehicle_make        VARCHAR(50),
    vehicle_model       VARCHAR(50),
    vehicle_color       VARCHAR(20),
    vehicle_mileage     INTEGER,
    actual_cash_value   DECIMAL(10,2) NOT NULL,
    total_loss_date     DATE NOT NULL,
    salvage_vendor      VARCHAR(50),
    salvage_vendor_ref  VARCHAR(50),
    location            VARCHAR(200),
    title_status        VARCHAR(30) NOT NULL,
    title_received_date DATE,
    lienholder_name     VARCHAR(100),
    lienholder_payoff   DECIMAL(10,2),
    auction_date        DATE,
    auction_platform    VARCHAR(50),
    minimum_bid         DECIMAL(10,2),
    sale_price          DECIMAL(10,2),
    buyer_name          VARCHAR(200),
    vendor_fees         DECIMAL(10,2),
    net_salvage_amount  DECIMAL(10,2),
    payment_received_date DATE,
    status              VARCHAR(20) NOT NULL DEFAULT 'PENDING',
    created_at          TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at          TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Status: PENDING_TITLE, TITLED, ASSIGNED_TO_VENDOR, LISTED, 
--   AUCTION_ACTIVE, SOLD, PAYMENT_PENDING, PAYMENT_RECEIVED, CLOSED
```

---

## 11. Deductible Reimbursement

### 11.1 Deductible Recovery Process

```
DEDUCTIBLE REIMBURSEMENT WORKFLOW:

  TRIGGER: Subrogation recovery received

  STEP 1: CALCULATE DEDUCTIBLE PORTION
    IF recovery >= total_claim_paid:
        deductible_reimbursement = full_deductible
    ELIF recovery > 0 AND recovery < total_claim_paid:
        // Pro-rata or insured-first (varies by state)
        IF state.rule = 'MADE_WHOLE':
            IF recovery >= total_claim_paid + deductible:
                deductible_reimbursement = full_deductible
            ELSE:
                deductible_reimbursement = 0  // Insured not made whole
        ELIF state.rule = 'PRO_RATA':
            ratio = recovery / (total_claim_paid + deductible)
            deductible_reimbursement = deductible * ratio
        ELIF state.rule = 'INSURED_FIRST':
            deductible_reimbursement = MIN(recovery, deductible)
    ELSE:
        deductible_reimbursement = 0

  STEP 2: ISSUE REIMBURSEMENT
    ├─ Generate reimbursement payment to insured
    ├─ Payment method: EFT (if on file) or check
    ├─ Include explanation letter
    └─ Record transaction

  STEP 3: COMMUNICATION
    ├─ Notify insured of deductible reimbursement
    ├─ Explain any partial reimbursement
    ├─ Provide contact info for questions
    └─ Update claim file

STATE RULES SUMMARY:
  Made-Whole (insured must be fully compensated first):
    FL, NY, CA, IL, OH, PA, etc. (majority of states)
  
  Pro-Rata (proportional sharing):
    TX, CO, WI, etc.
  
  Insured-First (deductible recovered first):
    Some contractual arrangements
```

---

## 12. Third-Party Liability Recovery

### 12.1 Recovery Process by Scenario

```
SCENARIO 1: AUTO COLLISION (OTHER DRIVER AT FAULT)
  ├─ Identify adverse driver and carrier
  ├─ Send demand to adverse carrier
  ├─ Negotiate or arbitrate (AF)
  ├─ Recovery from adverse carrier's liability coverage
  └─ Timeline: 60-180 days

SCENARIO 2: PRODUCT LIABILITY
  ├─ Identify defective product and manufacturer
  ├─ Engage product liability counsel
  ├─ Preserve evidence (defective product)
  ├─ Expert analysis of defect
  ├─ Demand or litigation against manufacturer
  └─ Timeline: 6-24 months

SCENARIO 3: PREMISES LIABILITY
  ├─ Identify property owner/occupier
  ├─ Document hazardous condition
  ├─ Demand against property owner's liability insurer
  ├─ If commercial, check for indemnification agreements
  └─ Timeline: 90-365 days

SCENARIO 4: CONTRACTOR NEGLIGENCE (PROPERTY)
  ├─ Identify negligent contractor
  ├─ Document faulty work/installation
  ├─ Check contractor's insurance and bonds
  ├─ Demand against contractor's GL carrier
  └─ Timeline: 90-365 days

SCENARIO 5: GOVERNMENT ENTITY
  ├─ Identify government entity (road maintenance, signal, etc.)
  ├─ Check sovereign immunity rules by jurisdiction
  ├─ File government tort claim within short deadline
  │   (often 30-180 days from loss)
  ├─ Follow government claims process
  └─ Timeline: 6-18 months (government processes slower)
```

---

## 13. Workers Compensation Subrogation

### 13.1 WC Third-Party Recovery

```
WC SUBROGATION SPECIFICS:

  SCENARIO: Employee injured at work due to third party's negligence

  EXAMPLE:
    Employee driving company vehicle, hit by drunk driver
    
    WC Carrier pays:
      Medical treatment:    $25,000
      Indemnity (lost wages): $12,000
      Total WC paid:        $37,000
    
    Third-Party Recovery:
      Demand against drunk driver's auto carrier
      Settlement: $75,000 (BI liability claim)
      
    ALLOCATION (varies by state):
      Attorney fees (33.3%):     $25,000
      Litigation costs:          $ 2,000
      Net to employee/carrier:   $48,000
      
      WC carrier lien:           $37,000
      Employee excess:           $11,000

  STATE VARIATIONS:
    ├─ Full lien states: WC carrier recovers full lien amount
    │   before employee gets remainder
    ├─ Partial lien states: WC carrier recovers proportional share
    ├─ Statutory reduction: Some states reduce lien by attorney fee
    │   proportion (carrier shares in attorney cost)
    └─ Made-whole states: Employee must be fully compensated
        before WC carrier can recover
```

### 13.2 Medicare Set-Aside (MSA) Considerations

```
MEDICARE SET-ASIDE IN WC SUBROGATION:

  WHEN REQUIRED:
    ├─ Workers compensation settlement
    ├─ Claimant is Medicare-eligible or expected to be
    │   within 30 months
    ├─ Settlement amount > $25,000 (CMS workload threshold)
    └─ Future medical treatment anticipated

  MSA AMOUNT CALCULATION:
    ├─ Based on projected future medical treatment
    ├─ Life expectancy of claimant
    ├─ Treatment frequency and cost
    └─ Typically requires professional MSA vendor

  IMPACT ON SUBROGATION:
    ├─ MSA amount must be set aside from settlement
    ├─ Reduces amount available for WC carrier's lien recovery
    ├─ Must protect Medicare's interests (MMSEA reporting)
    └─ Failure to set aside properly → Medicare secondary payer
        liability to carrier

  MMSEA SECTION 111 REPORTING:
    ├─ Mandatory electronic reporting to CMS
    ├─ Report all settlements involving Medicare beneficiaries
    ├─ Quarterly reporting deadlines
    └─ Penalties for non-compliance: $1,000/day per claim
```

---

## 14. Made-Whole & Common Fund Doctrines

### 14.1 Made-Whole Doctrine

```
MADE-WHOLE DOCTRINE:

  PRINCIPLE: The insurer cannot exercise subrogation rights until
  the insured has been fully compensated ("made whole") for their
  total loss, including amounts not covered by insurance.

  EXAMPLE:
    Insured's total loss: $50,000
    Insurance covers:     $35,000 (after deductible)
    Deductible:           $ 1,000
    Unreimbursed loss:    $14,000 (pain/suffering, etc.)
    
    Recovery from at-fault party: $40,000
    
    Made-Whole Analysis:
      Insured's total loss:          $50,000
      Insurance payment:             $35,000
      Insured's out-of-pocket:       $15,000 ($1K deductible + $14K uninsured)
      
      Recovery allocation:
        Insured gets first:          $15,000 (to be made whole)
        Carrier subrogation:         $25,000 (remainder)
        
    IF recovery was only $10,000:
      Insured not made whole ($50K - $35K - $10K = $5K still uncompensated)
      Carrier may get $0 in strict made-whole states

  STATES APPLYING MADE-WHOLE:
    Strong form: FL, TX, IL, OH, PA, NJ, WA
    Modified form: GA, TN, NC, SC (can override by contract)
    Not applied: MI (no-fault), some others by policy language
```

### 14.2 Common Fund Doctrine

```
COMMON FUND DOCTRINE:

  PRINCIPLE: When one party (the insured or their attorney)
  creates a common fund through their efforts, all who benefit
  from that fund must share in the costs of creating it.

  APPLICATION IN SUBROGATION:
    If insured's personal attorney recovers a settlement,
    the insurer's subrogation recovery from that settlement
    must bear a proportional share of attorney fees and costs.

  EXAMPLE:
    Insured hires attorney (1/3 contingency)
    Attorney recovers $90,000 settlement
    
    Attorney fee: $30,000 (33.3%)
    Net fund:     $60,000
    
    Carrier's subrogation lien: $40,000
    But must share attorney cost: $40,000 × 33.3% = $13,333
    Carrier net recovery: $40,000 - $13,333 = $26,667
    
    Alternatively, court may order:
    Total recovery:         $90,000
    Attorney fee:           $30,000
    Net:                    $60,000
    Carrier share:          $26,667 (lien reduced pro-rata)
    Insured share:          $33,333
```

---

## 15. State-Specific Subrogation Laws

### 15.1 Key State Variations

| State | Negligence Rule | Made-Whole | Anti-Subrogation Rule | PIP/No-Fault | Collateral Source |
|-------|----------------|-----------|----------------------|-------------|-------------------|
| CA | Pure comparative | Yes | Limited | No | Modified |
| TX | Modified comp (51%) | Pro-rata | No | No | No |
| NY | Pure comparative | Yes | Limited | Yes (serious) | Yes |
| FL | Pure comparative | Yes | Limited | Yes (PIP) | Modified |
| IL | Modified comp (50%) | Yes | No | No | No |
| PA | Modified comp (50%) | Yes | No | Choice | Modified |
| OH | Modified comp (50%) | Yes | No | No | Limited |
| MI | Modified comp (50%) | N/A | N/A | Yes (no-fault) | Yes |
| GA | Modified comp (50%) | Modified | No | No | No |
| NJ | Modified comp (varies) | Yes | Limited | Yes (verbal) | Modified |

### 15.2 Statute of Limitations for Subrogation

```
SUBROGATION STATUTE OF LIMITATIONS (General):

  PRINCIPLE: SOL begins when carrier pays the claim
             (not when loss occurred)

  TYPICAL SOL BY STATE:
    2 years:  CA (property), several states
    3 years:  NY, IL, most states (personal injury)
    4 years:  TX (negligence)
    5 years:  Several states (written contract)
    6 years:  NY (breach of contract), ME, OH

  ARBITRATION FORUMS SOL:
    2 years from date of payment (per AF rules)
    Separate from state court SOL
    
  KEY CONSIDERATIONS:
    ├─ SOL may be shorter for government entities
    ├─ Some states toll SOL during minority
    ├─ Discovery rule may apply (SOL starts when 
    │   defect discovered, not when loss occurred)
    └─ Contractual SOL provisions may apply
```

---

## 16. Subrogation Data Model

### 16.1 Complete Data Model

```sql
CREATE TABLE subrogation_claim (
    subrogation_id       UUID PRIMARY KEY,
    claim_id             VARCHAR(20) NOT NULL,
    claim_number         VARCHAR(30) NOT NULL,
    subrogation_type     VARCHAR(30) NOT NULL,
    identification_source VARCHAR(30) NOT NULL,
    identification_date  DATE NOT NULL,
    subrogation_score    DECIMAL(5,2),
    status               VARCHAR(20) NOT NULL DEFAULT 'IDENTIFIED',
    priority             VARCHAR(10) NOT NULL DEFAULT 'MEDIUM',
    assigned_to          VARCHAR(50),
    assigned_date        DATE,
    
    -- Adverse party information
    adverse_party_name   VARCHAR(200),
    adverse_party_type   VARCHAR(30),
    adverse_party_address TEXT,
    adverse_party_phone  VARCHAR(20),
    adverse_party_email  VARCHAR(100),
    adverse_carrier_name VARCHAR(200),
    adverse_carrier_naic VARCHAR(10),
    adverse_claim_number VARCHAR(30),
    adverse_policy_number VARCHAR(30),
    adverse_policy_limits DECIMAL(12,2),
    
    -- Liability
    liability_basis      VARCHAR(50),
    fault_percentage     DECIMAL(5,2),
    comparative_negligence_pct DECIMAL(5,2),
    
    -- Financial
    total_paid_to_date   DECIMAL(12,2) DEFAULT 0,
    total_reserved       DECIMAL(12,2) DEFAULT 0,
    demand_amount        DECIMAL(12,2),
    recovery_amount      DECIMAL(12,2) DEFAULT 0,
    deductible_amount    DECIMAL(10,2),
    deductible_recovered DECIMAL(10,2) DEFAULT 0,
    recovery_expenses    DECIMAL(10,2) DEFAULT 0,
    net_recovery         DECIMAL(12,2) DEFAULT 0,
    
    -- Dates
    demand_sent_date     DATE,
    response_due_date    DATE,
    arbitration_filed_date DATE,
    recovery_date        DATE,
    closed_date          DATE,
    sol_expiry_date      DATE NOT NULL,
    
    -- Resolution
    resolution_method    VARCHAR(30),
    resolution_date      DATE,
    resolution_notes     TEXT,
    
    created_at           TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at           TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE subrogation_recovery (
    recovery_id          UUID PRIMARY KEY,
    subrogation_id       UUID REFERENCES subrogation_claim(subrogation_id),
    claim_id             VARCHAR(20) NOT NULL,
    recovery_date        DATE NOT NULL,
    recovery_source      VARCHAR(50) NOT NULL,
    gross_amount         DECIMAL(12,2) NOT NULL,
    attorney_fees        DECIMAL(10,2) DEFAULT 0,
    filing_fees          DECIMAL(10,2) DEFAULT 0,
    other_expenses       DECIMAL(10,2) DEFAULT 0,
    net_amount           DECIMAL(12,2) NOT NULL,
    deductible_portion   DECIMAL(10,2) DEFAULT 0,
    carrier_portion      DECIMAL(12,2) NOT NULL,
    payment_method       VARCHAR(20),
    check_number         VARCHAR(30),
    deposited_date       DATE,
    gl_posted            BOOLEAN DEFAULT FALSE,
    gl_posted_date       DATE,
    created_at           TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE arbitration_filing (
    filing_id            UUID PRIMARY KEY,
    subrogation_id       UUID REFERENCES subrogation_claim(subrogation_id),
    af_docket_number     VARCHAR(30),
    filing_type          VARCHAR(30) NOT NULL,
    filing_date          DATE NOT NULL,
    filing_amount        DECIMAL(12,2) NOT NULL,
    filing_fee           DECIMAL(10,2),
    respondent_company   VARCHAR(200) NOT NULL,
    respondent_naic      VARCHAR(10),
    response_due_date    DATE,
    response_received    BOOLEAN DEFAULT FALSE,
    response_date        DATE,
    decision_date        DATE,
    decision_liability_pct DECIMAL(5,2),
    decision_amount      DECIMAL(12,2),
    decision_favorable   BOOLEAN,
    appeal_filed         BOOLEAN DEFAULT FALSE,
    appeal_date          DATE,
    status               VARCHAR(20) NOT NULL DEFAULT 'FILED',
    created_at           TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at           TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

---

## 17. Integration with Arbitration Forums

### 17.1 Integration Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│             ARBITRATION FORUMS INTEGRATION                       │
│                                                                  │
│  ┌──────────────────┐        ┌──────────────────────────┐       │
│  │ Claims System     │        │ Arbitration Forums       │       │
│  │                   │        │ (AF Online / e-Subro Hub)│       │
│  │ ┌──────────────┐ │        │                          │       │
│  │ │ Subrogation  │ │  API   │ ┌──────────────────────┐ │       │
│  │ │ Module       │◀┼───────▶│ │ Filing API           │ │       │
│  │ └──────────────┘ │        │ └──────────────────────┘ │       │
│  │                   │        │                          │       │
│  │ ┌──────────────┐ │  SFTP  │ ┌──────────────────────┐ │       │
│  │ │ Data Export/ │◀┼───────▶│ │ Batch File Exchange  │ │       │
│  │ │ Import       │ │        │ └──────────────────────┘ │       │
│  │ └──────────────┘ │        │                          │       │
│  │                   │        │ ┌──────────────────────┐ │       │
│  │ ┌──────────────┐ │ Email  │ │ Decision             │ │       │
│  │ │ Notification │◀┼───────▶│ │ Notification         │ │       │
│  │ │ Handler      │ │        │ └──────────────────────┘ │       │
│  │ └──────────────┘ │        │                          │       │
│  └──────────────────┘        └──────────────────────────┘       │
│                                                                  │
│  INTEGRATION METHODS:                                           │
│  1. API (Real-time): File, status check, decision retrieval    │
│  2. SFTP (Batch): Bulk filing, bulk decision import            │
│  3. Portal (Manual): Web UI for individual case management     │
│  4. Email (Notification): Decision and status notifications    │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

## 18. Automated Subrogation Rules

### 18.1 Identification Rules (50+ Rules)

```
// === COLLISION IDENTIFICATION RULES ===

SUBRO-001: "Rear-End Collision - Clear Liability"
  WHEN claim.lossType = 'COLLISION'
    AND claim.accidentType = 'REAR_END'
    AND claim.insuredPosition = 'FRONT_VEHICLE'
    AND claim.adversePartyIdentified = true
  THEN SET subrogation_potential = 'HIGH'
    AND SET fault_percentage = 100
    AND SET recommended_action = 'AUTO_DEMAND'

SUBRO-002: "Intersection Collision - Traffic Signal"
  WHEN claim.lossType = 'COLLISION'
    AND claim.accidentType = 'INTERSECTION'
    AND policeReport.adverseDriverViolation = 'RED_LIGHT'
  THEN SET subrogation_potential = 'HIGH'
    AND SET fault_percentage = 100

SUBRO-003: "Parked Vehicle Hit"
  WHEN claim.lossType = 'COLLISION'
    AND claim.insuredVehicleParked = true
    AND claim.adversePartyIdentified = true
  THEN SET subrogation_potential = 'HIGH'
    AND SET fault_percentage = 100

SUBRO-004: "Left Turn Collision"
  WHEN claim.lossType = 'COLLISION'
    AND claim.accidentType = 'LEFT_TURN'
    AND claim.insuredVehicleStraight = true
  THEN SET subrogation_potential = 'HIGH'
    AND SET fault_percentage = 90

SUBRO-005: "Lane Change Collision"
  WHEN claim.lossType = 'COLLISION'
    AND claim.accidentType = 'LANE_CHANGE'
    AND claim.adverseDriverChangedLane = true
  THEN SET subrogation_potential = 'MEDIUM'
    AND SET fault_percentage = 80

SUBRO-006: "DUI/DWI Adverse Driver"
  WHEN policeReport.adverseDriverDUI = true
  THEN SET subrogation_potential = 'VERY_HIGH'
    AND SET fault_percentage = 100
    AND SET punitive_damages_potential = true

// === COMPREHENSIVE IDENTIFICATION RULES ===

SUBRO-010: "Theft with Recovery and Third Party"
  WHEN claim.lossType = 'THEFT'
    AND claim.vehicleRecovered = true
    AND claim.theftSuspectIdentified = true
  THEN SET subrogation_potential = 'LOW'
    AND SET recovery_type = 'RESTITUTION'

SUBRO-011: "Vandalism with Identified Perpetrator"
  WHEN claim.lossType = 'VANDALISM'
    AND policeReport.suspectIdentified = true
  THEN SET subrogation_potential = 'LOW'
    AND SET recovery_type = 'RESTITUTION'

// === PROPERTY IDENTIFICATION RULES ===

SUBRO-020: "Fire Caused by Neighbor"
  WHEN claim.lob = 'PROPERTY'
    AND claim.lossType = 'FIRE'
    AND claim.fireOrigin = 'NEIGHBOR_PROPERTY'
    AND fireReport.causeIdentified = true
  THEN SET subrogation_potential = 'MEDIUM'
    AND SET adverse_party = claim.neighborInfo

SUBRO-021: "Water Damage from Upstairs Unit"
  WHEN claim.lob = 'PROPERTY'
    AND claim.lossType = 'WATER'
    AND claim.waterSource = 'UPSTAIRS_UNIT'
  THEN SET subrogation_potential = 'MEDIUM'
    AND SET adverse_party = claim.upstairsUnitInfo

SUBRO-022: "Product Defect - Appliance"
  WHEN claim.lob = 'PROPERTY'
    AND claim.lossType IN ('FIRE', 'WATER')
    AND claim.causeOfLoss = 'PRODUCT_DEFECT'
    AND claim.defectiveProduct.identified = true
  THEN SET subrogation_potential = 'HIGH'
    AND SET recovery_type = 'PRODUCT_LIABILITY'
    AND SET action = 'PRESERVE_EVIDENCE'

SUBRO-023: "Contractor Negligence"
  WHEN claim.lob = 'PROPERTY'
    AND claim.recentConstruction = true
    AND claim.causeOfLoss = 'FAULTY_WORKMANSHIP'
  THEN SET subrogation_potential = 'MEDIUM'
    AND SET recovery_type = 'CONTRACTOR_LIABILITY'

// === WORKERS COMPENSATION RULES ===

SUBRO-030: "WC Third-Party Auto"
  WHEN claim.lob = 'WORKERS_COMP'
    AND claim.injuryType = 'MOTOR_VEHICLE'
    AND claim.thirdPartyInvolved = true
  THEN SET subrogation_potential = 'HIGH'
    AND SET recovery_type = 'WC_THIRD_PARTY'

SUBRO-031: "WC Premises Liability"
  WHEN claim.lob = 'WORKERS_COMP'
    AND claim.injuryLocation = 'THIRD_PARTY_PREMISES'
    AND claim.hazardousCondition = true
  THEN SET subrogation_potential = 'MEDIUM'
    AND SET recovery_type = 'WC_PREMISES'

SUBRO-032: "WC Product Defect"
  WHEN claim.lob = 'WORKERS_COMP'
    AND claim.causeOfInjury = 'EQUIPMENT_FAILURE'
    AND claim.equipment.manufacturer != claim.employer
  THEN SET subrogation_potential = 'MEDIUM'
    AND SET recovery_type = 'WC_PRODUCT'

// === DEMAND AUTOMATION RULES ===

SUBRO-040: "Auto-Demand for Clear Liability"
  WHEN subrogation.faultPercentage >= 90
    AND subrogation.adverseCarrierIdentified = true
    AND claim.totalPaid > 0
  THEN AUTO_GENERATE_DEMAND(subrogation)
    AND SET demand_amount = claim.totalPaid + claim.deductible

SUBRO-041: "Demand Amount Calculation"
  WHEN subrogation.status = 'DEMAND_PENDING'
  THEN SET demand_amount = SUM(
    claim.indemnityPaid,
    claim.expensePaid,
    claim.deductible,
    OPTIONAL: claim.diminishedValue
  )

SUBRO-042: "Follow-Up Demand"
  WHEN subrogation.demandSentDate + 30 < TODAY
    AND subrogation.responseReceived = false
  THEN SEND_FOLLOW_UP_DEMAND(subrogation)
    AND INCREMENT subrogation.followUpCount

SUBRO-043: "Escalate to Arbitration"
  WHEN subrogation.demandDenied = true
    OR (subrogation.followUpCount >= 3 AND subrogation.noResponse = true)
  THEN SET recommended_action = 'FILE_ARBITRATION'
    AND CALCULATE arbitration_roi(subrogation)

// === SOL MONITORING RULES ===

SUBRO-050: "SOL Warning - 6 Months"
  WHEN subrogation.solExpiryDate - TODAY <= 180
    AND subrogation.status NOT IN ('CLOSED', 'RECOVERED')
  THEN ALERT(priority='HIGH', message='SOL expiring in 6 months')
    AND ESCALATE_TO_SUPERVISOR

SUBRO-051: "SOL Warning - 90 Days"
  WHEN subrogation.solExpiryDate - TODAY <= 90
    AND subrogation.status NOT IN ('CLOSED', 'RECOVERED')
  THEN ALERT(priority='CRITICAL', message='SOL expiring in 90 days')
    AND ESCALATE_TO_MANAGER
    AND AUTO_FILE_ARBITRATION_IF_ELIGIBLE
```

---

## 19. Subrogation Workflow State Machine

```
                         ┌───────────────┐
                         │  IDENTIFIED   │
                         └───────┬───────┘
                                 │ evaluate
                                 ▼
                    ┌────────────────────────┐
              ┌─────│      EVALUATED         │─────┐
              │     └────────────┬───────────┘     │
              │                  │                  │
          no_potential      has_potential       needs_info
              │                  │                  │
              ▼                  ▼                  ▼
       ┌──────────┐     ┌──────────────┐    ┌──────────┐
       │ CLOSED   │     │   DEMAND     │    │ PENDING  │
       │ NO_SUBRO │     │   PREPARED   │    │ INFO     │
       └──────────┘     └──────┬───────┘    └──────────┘
                               │
                          send_demand
                               │
                               ▼
                        ┌──────────────┐
                   ┌────│ DEMAND SENT  │────┐
                   │    └──────────────┘    │
                   │           │            │
              accepted    partial      denied/no_response
                   │           │            │
                   ▼           ▼            ▼
            ┌──────────┐ ┌──────────┐ ┌──────────────┐
            │SETTLEMENT│ │NEGOTIATE │ │ ARBITRATION/ │
            │ AGREED   │ │          │ │ LITIGATION   │
            └────┬─────┘ └────┬─────┘ │ EVALUATION   │
                 │            │       └──────┬───────┘
                 │       settled/failed      │
                 │        ┌───┴───┐    file_arb/litigate
                 │     settled  failed      │
                 │        │        │        ▼
                 │        │        │  ┌──────────────┐
                 │        │        │  │ ARBITRATION/ │
                 │        │        │  │ LITIGATION   │
                 │        │        │  │ PENDING      │
                 │        │        │  └──────┬───────┘
                 │        │        │         │
                 │        │        │    decision/settlement
                 │        │        │         │
                 ▼        ▼        │         ▼
            ┌───────────────────────────────────┐
            │         RECOVERY PENDING          │
            └───────────────┬───────────────────┘
                            │ payment_received
                            ▼
            ┌───────────────────────────────────┐
            │         RECOVERY RECEIVED         │
            └───────────────┬───────────────────┘
                            │ accounting_complete
                            ▼
            ┌───────────────────────────────────┐
            │             CLOSED                │
            └───────────────────────────────────┘
```

---

## 20. Financial Accounting for Recoveries

### 20.1 GAAP Requirements

```
GAAP ACCOUNTING FOR SUBROGATION:

  ASC 944 (Insurance Accounting):
    - Recoveries reduce incurred losses
    - Anticipated recoveries may be recognized as an asset
    - Must meet "probable and estimable" criteria
    - Salvage and subrogation are deducted from loss reserves

  RECORDING ANTICIPATED RECOVERIES:
    
    At Time of Loss:
      DR  Loss Reserve                    $10,000
      CR  Loss Reserve Liability                   $10,000
      
    When Subrogation Identified (Anticipated):
      DR  Subrogation Receivable          $ 4,000
      CR  Anticipated Recovery                     $ 4,000
      (Reduces net reserve to $6,000)
      
    When Recovery Received:
      DR  Cash                            $ 4,500
      CR  Subrogation Receivable                   $ 4,000
      CR  Recovery Income (unanticipated)          $   500
      
    Deductible Reimbursement:
      DR  Recovery Expense (or reduction)  $  500
      CR  Cash (payment to insured)                $   500

  ANTICIPATED RECOVERY ESTIMATION:
    Method 1: Historical recovery rate by LOB/type
    Method 2: Case-by-case estimate
    Method 3: ML model prediction
    
    Carriers must estimate probable recoveries and reduce
    reserves accordingly. Under-estimating creates reserve
    redundancy; over-estimating creates deficiency.
```

### 20.2 GL Entry Mappings

| Transaction | Debit Account | Credit Account | Amount |
|------------|--------------|----------------|--------|
| Record anticipated recovery | Subro Receivable (1xxx) | Loss Reserve (5xxx) | Estimated |
| Receive gross recovery | Cash/Bank (1xxx) | Subro Receivable (1xxx) | Actual |
| Recovery exceeds estimate | Cash/Bank (1xxx) | Recovery Income (4xxx) | Difference |
| Recovery less than estimate | Loss Reserve (5xxx) | Subro Receivable (1xxx) | Shortfall |
| Pay attorney fees | Recovery Expense (6xxx) | Cash/Bank (1xxx) | Fee amount |
| Pay filing fees | Recovery Expense (6xxx) | Cash/Bank (1xxx) | Fee amount |
| Reimburse deductible | Subro Recovery (contra) | Cash/Bank (1xxx) | Deductible |
| Salvage proceeds received | Cash/Bank (1xxx) | Salvage Recovery (4xxx) | Net proceeds |
| Write off uncollectible | Loss Reserve (5xxx) | Subro Receivable (1xxx) | Write-off |

---

## 21. Performance Metrics

### 21.1 KPI Framework

| Category | KPI | Definition | Target |
|----------|-----|-----------|--------|
| **Volume** | Identification Rate | % of eligible claims with subro opened | > 90% |
| **Volume** | Referral Volume | Monthly new subro claims | Track trend |
| **Recovery** | Gross Recovery Rate | $ recovered / $ paid on subro claims | 40–50% |
| **Recovery** | Net Recovery Rate | ($ recovered - expenses) / $ paid | 30–40% |
| **Recovery** | Deductible Recovery Rate | % deductibles recovered | > 60% |
| **Efficiency** | Cycle Time (Demand to Recovery) | Days from demand to payment received | < 120 days |
| **Efficiency** | Cycle Time (ID to Demand) | Days from identification to demand sent | < 30 days |
| **Efficiency** | Demands per Specialist per Month | Productivity metric | 80–120 |
| **Efficiency** | Arbitration Win Rate | % of arbitrations decided favorably | > 70% |
| **Financial** | Recovery as % of Incurred | Total recoveries / total incurred losses | 8–12% |
| **Financial** | Cost of Recovery | Total subro expenses / total recoveries | < 15% |
| **Financial** | ROI per Recovery Dollar | Net recovery / cost of recovery | > 6:1 |
| **Financial** | Salvage Yield | Salvage proceeds / ACV of total losses | 20–25% |
| **Quality** | SOL Expiry Rate | % of subro claims closed due to SOL | < 1% |
| **Quality** | Abandonment Rate | % of viable subro claims abandoned | < 5% |
| **Quality** | Customer Satisfaction | NPS for deductible reimbursement | > 60 |

### 21.2 Recovery Benchmarking

```
RECOVERY RATE BENCHMARKS BY CLAIM TYPE:

  Auto Collision (rear-end):       ████████████████████░░  55-65%
  Auto Collision (intersection):   ██████████████░░░░░░░░  40-50%
  Auto Collision (multi-vehicle):  ████████████░░░░░░░░░░  30-40%
  Auto Comp (theft w/ suspect):    ████░░░░░░░░░░░░░░░░░░  10-15%
  Auto Total Loss Salvage:         ████████░░░░░░░░░░░░░░  20-25% (of ACV)
  Property (fire - third party):   ██████████░░░░░░░░░░░░  25-35%
  Property (water - neighbor):     ████████░░░░░░░░░░░░░░  20-30%
  Property (product defect):       ████████████░░░░░░░░░░  30-40%
  WC Third-Party Auto:             ████████████████░░░░░░  45-55%
  WC Third-Party Premises:         ████████░░░░░░░░░░░░░░  20-30%
  WC Third-Party Product:          ██████████░░░░░░░░░░░░  25-35%
```

---

## 22. Vendor Management

### 22.1 Subrogation Vendor Ecosystem

| Vendor Type | Function | Examples | Fee Model |
|-------------|----------|---------|-----------|
| **Subro Law Firms** | Litigation, demand, arbitration | Regional panels | Contingency (25–33%) or hourly |
| **Subro Outsource** | End-to-end subro management | Copart Subrogation, CSC | Contingency (15–25%) |
| **Salvage Auctions** | Vehicle salvage sales | Copart, IAA | Commission (seller + buyer fees) |
| **Arbitration Forums** | Inter-company arbitration | Arbitration Forums Inc. | Filing fees ($50–$200) |
| **Data Providers** | Adverse party identification | LexisNexis, ISO | Subscription + per-search |
| **Skip Tracing** | Locate uninsured adverse parties | Various | Per-locate fee ($20–$50) |
| **Valuation Services** | Vehicle/property ACV | CCC, Mitchell, JD Power | Per-valuation fee |
| **Investigation** | Accident reconstruction, forensics | Regional experts | Hourly ($150–$500) |

---

## 23. Technology Platform Requirements

### 23.1 Subrogation Management System Requirements

| Category | Requirement | Priority |
|----------|------------|----------|
| **Identification** | Automated subro identification using rules + ML | Must Have |
| **Identification** | Integration with claims system for real-time scoring | Must Have |
| **Demand** | Template-based demand letter generation | Must Have |
| **Demand** | Automated demand tracking and follow-up | Must Have |
| **Arbitration** | AF Online / e-Subro Hub integration | Must Have |
| **Arbitration** | Electronic filing and decision import | Must Have |
| **Financials** | Recovery tracking and accounting | Must Have |
| **Financials** | Deductible reimbursement automation | Must Have |
| **Financials** | GL posting integration | Must Have |
| **Salvage** | Salvage vendor integration (Copart, IAA) | Must Have |
| **Salvage** | Total loss workflow automation | Must Have |
| **Workflow** | Configurable workflow with state machine | Must Have |
| **Workflow** | SOL tracking and automated alerts | Must Have |
| **Reporting** | Recovery metrics dashboard | Must Have |
| **Reporting** | Financial recovery reporting (monthly, quarterly) | Must Have |
| **Compliance** | Audit trail for all transactions | Must Have |
| **Compliance** | State-specific rule configuration | Should Have |
| **Analytics** | ML-based recovery probability scoring | Should Have |
| **Analytics** | Optimal recovery path recommendation | Nice to Have |
| **Mobile** | Field access for investigators | Nice to Have |

---

## 24. Sample Demand Data Formats

### 24.1 Demand Package API Payload

```json
{
  "demand_request": {
    "claim_id": "CLM-2024-001234",
    "subrogation_id": "SUB-2024-001234",
    "demand_type": "INITIAL_DEMAND",
    "template_id": "AUTO_COLLISION_STANDARD_V3",
    
    "applicant": {
      "carrier": "ABC Insurance Company",
      "address": "123 Insurance Blvd, Hartford, CT 06101",
      "contact": "Subrogation Unit",
      "phone": "800-555-1234",
      "email": "subrogation@abcins.com",
      "claim_number": "CLM-2024-001234",
      "insured_name": "John A. Doe",
      "policy_number": "PA-2024-12345678"
    },
    
    "adverse_party": {
      "name": "Jane B. Roe",
      "address": "456 Oak Street, Springfield, IL 62701",
      "carrier": "XYZ Insurance Company",
      "carrier_address": "789 Policy Lane, Chicago, IL 60601",
      "claim_number": "XYZ-CLM-2024-9876",
      "policy_number": "XYZ-PA-5678"
    },
    
    "loss_details": {
      "date": "2024-02-14",
      "time": "15:30",
      "location": "Intersection of Main St and Oak Ave, Springfield, IL",
      "description": "Adverse party ran red light and struck insured vehicle broadside.",
      "police_report": "SPD-2024-0214-1234",
      "weather": "Clear",
      "road_conditions": "Dry"
    },
    
    "liability_basis": "Respondent's insured violated traffic signal (625 ILCS 5/11-306), entering intersection on red and striking applicant's insured who had green light. Police report confirms red light violation. Two independent witnesses corroborate.",
    
    "damages": [
      {"type": "VEHICLE_REPAIR", "description": "Body repair per estimate", "amount": 8500.00},
      {"type": "RENTAL_VEHICLE", "description": "14 days Enterprise rental", "amount": 630.00},
      {"type": "TOWING", "description": "Scene to shop towing", "amount": 185.00}
    ],
    
    "financial_summary": {
      "total_paid": 8815.00,
      "deductible": 500.00,
      "total_demand": 9315.00,
      "demand_breakdown": {
        "carrier_portion": 8815.00,
        "deductible_portion": 500.00
      }
    },
    
    "response_deadline": "2024-04-15",
    "payment_instructions": {
      "payable_to": "ABC Insurance Company",
      "reference": "CLM-2024-001234",
      "mail_to": "ABC Insurance Company, Subrogation Unit, PO Box 12345, Hartford, CT 06101",
      "eft_available": true,
      "eft_instructions": "Contact subrogation@abcins.com for EFT details"
    },
    
    "attachments": [
      "police_report.pdf",
      "repair_estimate.pdf",
      "damage_photos.zip",
      "rental_receipt.pdf",
      "tow_receipt.pdf",
      "payment_proof.pdf"
    ]
  }
}
```

---

## Appendix: Glossary

| Term | Definition |
|------|-----------|
| **AF** | Arbitration Forums Inc. |
| **ACV** | Actual Cash Value |
| **SOL** | Statute of Limitations |
| **MSA** | Medicare Set-Aside |
| **MMSEA** | Medicare, Medicaid, and SCHIP Extension Act |
| **PIP** | Personal Injury Protection |
| **UM/UIM** | Uninsured/Underinsured Motorist |
| **EUO** | Examination Under Oath |
| **GL** | General Ledger |
| **GAAP** | Generally Accepted Accounting Principles |
| **SAP** | Statutory Accounting Principles |
| **IBNR** | Incurred But Not Reported |
| **LAE** | Loss Adjustment Expense |
| **DV** | Diminished Value |
| **OEM** | Original Equipment Manufacturer |
| **PDR** | Paintless Dent Repair |

---

*This document is part of the PnC Claims Encyclopedia. For related topics, see:*
- *Article 6: Claims Automation & Straight-Through Processing*
- *Article 7: AI/ML in Claims Processing*
- *Article 8: Fraud Detection & SIU Operations*
- *Article 10: Reserves & Financial Management*
