# Article 3: Claims Adjudication & Decision Engine

## The Core Logic of Life Insurance Claims Processing

---

## 1. Introduction

Claims adjudication is the heart of the life insurance claims process. It encompasses the entire spectrum of activities from initial document review through final benefit determination. For a solutions architect, this is where the most complex business rules, decision logic, and regulatory requirements converge.

This article provides an exhaustive examination of the adjudication process, the rules that govern decisions, the calculation engines required, and the architectural patterns that support accurate, auditable, and efficient claims processing.

---

## 2. Adjudication Process Overview

### 2.1 End-to-End Adjudication Flow

```
┌──────────────────────────────────────────────────────────────────────────┐
│                    CLAIMS ADJUDICATION PIPELINE                          │
├──────────────────────────────────────────────────────────────────────────┤
│                                                                          │
│  ┌──────────┐   ┌──────────┐   ┌──────────┐   ┌──────────┐            │
│  │ DOCUMENT  │──▶│ COVERAGE │──▶│ BENEFIT  │──▶│ DECISION │            │
│  │ REVIEW    │   │ ANALYSIS │   │CALCULATION│   │          │            │
│  └──────────┘   └──────────┘   └──────────┘   └──────────┘            │
│       │              │              │              │                     │
│       ▼              ▼              ▼              ▼                     │
│  ┌──────────┐   ┌──────────┐   ┌──────────┐   ┌──────────┐            │
│  │ Verify    │   │ Policy   │   │ Base     │   │ Approve  │            │
│  │ Death     │   │ In-Force │   │ Death    │   │ Deny     │            │
│  │ Certificate│  │ Check    │   │ Benefit  │   │ Partial  │            │
│  │ Validate  │   │ Contest. │   │ +Riders  │   │ Pend     │            │
│  │ Identity  │   │ Analysis │   │ -Loans   │   │ Refer    │            │
│  │ Check     │   │ Exclusion│   │ -Premium │   │          │            │
│  │ Completenes│  │ Analysis │   │ +Interest│   │          │            │
│  └──────────┘   │ Rider    │   │ Tax Calc │   └──────────┘            │
│                  │ Analysis │   └──────────┘        │                   │
│                  └──────────┘                       │                   │
│                                                     ▼                   │
│                                              ┌──────────┐              │
│                                              │ AUTHORITY │              │
│                                              │ & QUALITY │              │
│                                              │ CHECK     │              │
│                                              └──────────┘              │
│                                                     │                   │
│                                              ┌──────▼──────┐           │
│                                              │  PAYMENT    │           │
│                                              │  PROCESSING │           │
│                                              └─────────────┘           │
└──────────────────────────────────────────────────────────────────────────┘
```

---

## 3. Document Verification

### 3.1 Death Certificate Verification

The certified death certificate is the foundational document for every death claim.

#### 3.1.1 Data Elements Extracted from Death Certificate

| Section | Fields | Verification Points |
|---|---|---|
| **Decedent Information** | Legal name, SSN, DOB, Age, Sex, Race, Marital Status | Match to policy records |
| **Death Information** | Date of death, Time of death, County of death, Place of death (type: hospital, home, nursing home, etc.) | Confirm date for coverage and benefit calculations |
| **Cause of Death** | Immediate cause, Sequentially contributing causes, Other significant conditions, Manner of death | Coverage analysis (accident, suicide, exclusions) |
| **Certifier** | Certifying physician/ME/coroner name, license, date signed | Authenticity verification |
| **Disposition** | Burial, Cremation, Donation, Date of disposition | May flag timing concerns |
| **Filing Information** | State file number, Date filed, Registrar | Verify certified copy authenticity |

#### 3.1.2 Death Certificate Validation Rules

```
VALIDATION_RULES:
  1. AUTHENTICITY:
     - Is it a CERTIFIED copy (raised seal, stamped, or electronic certification)?
     - Is the file number present?
     - Is the registrar's signature/stamp present?
     - Is it from the appropriate vital records office?
     
  2. IDENTITY MATCH:
     - Does the name match the insured (allowing for common variations)?
     - Does the DOB match the policy?
     - Does the SSN match (if present on death certificate)?
     - Does the gender match?
     
  3. COMPLETENESS:
     - Is cause of death completed (not "PENDING")?
     - Is manner of death specified?
     - Is the date of death specific (not approximate)?
     - Is the certifier information complete?
     
  4. TIMELINESS:
     - Was the certificate filed within a reasonable time of death?
     - Are there any amendments or corrections noted?
     
  5. SPECIAL CIRCUMSTANCES:
     - "PENDING" cause of death → Request updated certificate
     - "UNDETERMINED" manner → May require investigation
     - Foreign death certificate → May need translation and apostille
     - Delayed registration → May need additional corroboration
```

### 3.2 Identity Verification of Claimant/Beneficiary

```
BENEFICIARY VERIFICATION STEPS:
  1. IDENTITY CONFIRMATION:
     ├── Government-issued photo ID
     ├── SSN verification (against SSA or credit bureau)
     ├── Knowledge-Based Authentication (KBA)
     ├── Address verification
     └── Date of birth verification
     
  2. BENEFICIARY STATUS CONFIRMATION:
     ├── Match name to policy beneficiary designation
     ├── Verify relationship (if relationship-based designation)
     ├── Confirm beneficiary is alive (not deceased)
     ├── Check for irrevocable beneficiary restrictions
     ├── Review any beneficiary change history
     └── Check for divorce/separation affecting designation
     
  3. LEGAL AUTHORITY (when claimant ≠ beneficiary):
     ├── Power of Attorney documentation
     ├── Letters of Administration / Letters Testamentary
     ├── Court orders
     ├── Guardian/Conservator documentation
     └── Trust documentation and trustee authority
```

---

## 4. Coverage Analysis

### 4.1 Coverage Determination Decision Tree

```
START: Was the policy IN FORCE on the date of death?
│
├── YES → Was the insured within the CONTESTABILITY period?
│   │
│   ├── YES → Was there MATERIAL MISREPRESENTATION on the application?
│   │   │
│   │   ├── YES → RESCIND policy (return premiums)
│   │   │         [Requires thorough investigation and legal review]
│   │   │
│   │   └── NO → Coverage CONFIRMED (proceed to benefit calculation)
│   │
│   └── NO → Was the death by SUICIDE?
│       │
│       ├── YES → Is the death within the SUICIDE EXCLUSION period?
│       │   │
│       │   ├── YES → RETURN PREMIUMS ONLY (no death benefit)
│       │   │
│       │   └── NO → Coverage CONFIRMED (full benefit payable)
│       │
│       └── NO → Are there any other EXCLUSIONS that apply?
│           │
│           ├── YES → Analyze specific exclusion
│           │   ├── War exclusion
│           │   ├── Aviation exclusion
│           │   ├── Hazardous activity exclusion
│           │   ├── Commission of felony exclusion
│           │   └── [Product-specific exclusions]
│           │
│           └── NO → Coverage CONFIRMED (proceed to benefit calculation)
│
├── GRACE PERIOD → Policy premium was overdue but within grace period
│   │
│   └── Coverage CONFIRMED (deduct overdue premium from benefit)
│
├── LAPSED → Policy had lapsed before date of death
│   │
│   ├── Was REINSTATEMENT pending/in process?
│   │   ├── YES → Analyze reinstatement terms and timing
│   │   └── NO → Was there a NON-FORFEITURE option in effect?
│   │       ├── EXTENDED TERM → Was death within extended term period?
│   │       │   ├── YES → Pay extended term face amount
│   │       │   └── NO → No coverage
│   │       ├── REDUCED PAID-UP → Pay reduced face amount
│   │       └── AUTOMATIC PREMIUM LOAN → Treat as in-force with loan
│   │
│   └── NO COVERAGE (deny claim, return any applicable value)
│
└── TERMINATED → Policy was surrendered, matured, or cancelled
    │
    └── NO DEATH BENEFIT COVERAGE (may have other values payable)
```

### 4.2 Contestability Investigation

When a claim falls within the contestability period, the examiner must conduct a thorough investigation:

```
CONTESTABILITY INVESTIGATION WORKFLOW:
│
├── 1. OBTAIN ORIGINAL APPLICATION
│   ├── Retrieve from underwriting/policy file
│   ├── Review all questions and answers
│   ├── Identify all disclosed medical conditions
│   ├── Identify all disclosed medications
│   └── Note any attending physicians listed
│
├── 2. ORDER MEDICAL RECORDS
│   ├── APS from attending physician at time of application
│   ├── APS from attending physician at time of death
│   ├── Hospital records (last illness/death)
│   ├── Records from specialists mentioned on application
│   └── Records from physicians discovered in investigation
│
├── 3. OBTAIN ADDITIONAL DATA
│   ├── MIB (Medical Information Bureau) check
│   ├── Prescription drug history (Rx database)
│   ├── Motor vehicle report
│   ├── Prior insurance application history
│   └── CLUE report (claims history)
│
├── 4. COMPARE AND ANALYZE
│   ├── Compare cause of death to application disclosures
│   ├── Identify any undisclosed conditions that existed at application
│   ├── Determine if undisclosed conditions were MATERIAL
│   │   (Would disclosure have changed the underwriting decision?)
│   ├── Consider state-specific materiality standards
│   │   ├── "Contribute to cause of death" standard
│   │   ├── "Increase risk" standard
│   │   └── "Affect underwriting decision" standard
│   └── Document findings thoroughly
│
├── 5. DECISION
│   ├── NO MISREPRESENTATION FOUND → Pay claim
│   ├── IMMATERIAL MISREPRESENTATION → Pay claim
│   ├── MATERIAL MISREPRESENTATION → Options:
│   │   ├── RESCIND (void policy, return premiums)
│   │   ├── REFORM (adjust benefit to what correct premium would have purchased)
│   │   └── PAY WITH OFFSET (rare)
│   └── INSUFFICIENT EVIDENCE → May need to pay (burden is on carrier)
│
└── 6. LEGAL REVIEW (required for rescission)
    ├── Legal review of evidence and decision
    ├── State-specific legal requirements for rescission notice
    ├── Right to contest / appeal information for claimant
    └── Regulatory notification requirements
```

### 4.3 Exclusion Analysis

| Exclusion Type | Standard Provision | Analysis Required |
|---|---|---|
| **Suicide** | 1–2 year exclusion from issue date | Manner of death determination; state-specific periods |
| **War/Military Action** | Death in declared/undeclared war | Circumstances of military death; theater of operation |
| **Aviation** | Non-commercial aviation (varies) | Was insured pilot or crew? Commercial vs. private? |
| **Hazardous Activity** | Specific activities (varies by policy) | Was insured engaged in listed activity at time of death? |
| **Illegal Activity/Felony** | Death while committing felony | Criminal investigation results; conviction not required |
| **Intoxication/Substance** | Death caused by drug/alcohol use (some AD&D) | Toxicology results; proximate cause analysis |
| **Pre-existing Condition** | Conditions existing before policy (group) | Medical records review; definition of pre-existing |
| **Foreign Travel/Residence** | Death in excluded countries | Location at time of death; policy provisions |

---

## 5. Benefit Calculation Engine

### 5.1 Death Benefit Calculation Framework

```
BENEFIT CALCULATION:
│
├── 1. DETERMINE BASE DEATH BENEFIT
│   ├── Term Life: Face Amount stated in policy
│   │   ├── Level Term: Constant face amount
│   │   ├── Decreasing Term: Calculate based on schedule and policy year
│   │   └── Return of Premium: Face amount + return premium calculation
│   │
│   ├── Whole Life: Face Amount + adjustments
│   │   ├── Base face amount
│   │   ├── + Paid-Up Additions (PUA) face amount
│   │   ├── + Dividend additions face amount
│   │   ├── + Terminal dividend (if applicable)
│   │   └── Cash value is NOT added (subsumed by death benefit)
│   │
│   ├── Universal Life: Depends on death benefit option
│   │   ├── Option A (Level): Greater of (face amount) or (account value)
│   │   ├── Option B (Increasing): Face amount + account value
│   │   ├── Option C (Return of Premium): Face amount + total premiums paid
│   │   └── Account value frozen as of date of death
│   │
│   └── Variable UL: Face amount +/- investment performance
│       ├── Sub-account values frozen at date of death
│       ├── Determine applicable death benefit option
│       └── Apply GMDB floor if applicable
│
├── 2. ADD RIDER BENEFITS
│   ├── Accidental Death Benefit (AD&D rider)
│   │   ├── Verify death was accidental per policy definition
│   │   ├── Additional benefit amount (often equal to face amount)
│   │   └── Exclusions specific to AD&D rider
│   │
│   ├── Accelerated Death Benefit (if previously paid)
│   │   └── Reduce death benefit by amount previously accelerated
│   │       (plus any applicable interest/adjustments)
│   │
│   ├── Waiver of Premium (if claim arises during WoP period)
│   │   └── Ensure premiums were being waived correctly
│   │
│   ├── Children's Term Rider
│   │   └── If deceased is a covered child, pay rider benefit
│   │
│   ├── Spouse/Other Insured Rider
│   │   └── If deceased is covered under rider, pay rider benefit
│   │
│   └── Other Riders (product-specific)
│
├── 3. APPLY DEDUCTIONS
│   ├── Outstanding Policy Loans
│   │   ├── Loan principal
│   │   ├── Accrued loan interest (to date of death)
│   │   └── Calculate total loan indebtedness
│   │
│   ├── Overdue Premiums
│   │   ├── Premium due but unpaid (grace period death)
│   │   └── Pro-rata premium adjustment
│   │
│   ├── Premium Advance (if applicable)
│   │   └── Refund of unearned premium (credit to benefit)
│   │
│   ├── Assignments
│   │   ├── Collateral assignment: Pay assignee first, remainder to beneficiary
│   │   └── Absolute assignment: Pay assignee (assignee is effective owner)
│   │
│   └── Prior ADB Payment
│       └── Deduct previously accelerated amount plus adjustments
│
├── 4. ADD INTEREST
│   ├── State-mandated interest on death benefit
│   │   ├── From date of death (some states)
│   │   ├── From date proof of loss received (most states)
│   │   ├── Rate varies by state (statutory or policy rate)
│   │   └── Must comply with prompt payment statutes
│   │
│   └── Unearned premium refund
│       └── Premiums paid beyond date of death
│
├── 5. ALLOCATE AMONG BENEFICIARIES
│   ├── Primary beneficiaries (if alive and not disclaimed)
│   │   ├── Percentage allocation per designation
│   │   ├── Per stirpes distribution (if beneficiary predeceased)
│   │   └── Per capita distribution (if applicable)
│   │
│   ├── Contingent beneficiaries (if no surviving primary)
│   │   └── Same allocation logic
│   │
│   ├── Estate (if no surviving designated beneficiaries)
│   │   └── Pay to estate of insured
│   │
│   └── Interpleader (if conflicting claims)
│       └── Deposit with court
│
└── 6. TAX CALCULATIONS
    ├── Life insurance death benefit: Generally income tax-free (IRC §101(a))
    ├── Interest component: Taxable as ordinary income
    ├── Transfer for value: May trigger taxable portion
    ├── Estate tax implications: Included in estate if insured had incidents of ownership
    ├── ERISA plans: May have different tax treatment
    ├── Generate 1099-INT for interest portion
    └── Generate 1099-R for annuity death claims (gain is taxable)
```

### 5.2 Detailed Calculation Examples

#### Example 1: Simple Term Life Claim

```
Policy: 20-Year Level Term
Face Amount: $500,000
Issue Date: 2018-01-15
Date of Death: 2025-06-20
Policy Status: In Force (premium current)
Beneficiary: Spouse (100% primary)
Loans: None
Riders: None

CALCULATION:
  Base Death Benefit:           $500,000.00
  + Rider Benefits:             $      0.00
  - Deductions:                 $      0.00
  = Gross Benefit:              $500,000.00
  + Interest (from date proof   
    received to payment date):  $    410.96  (30 days @ 5% state rate)
  = Total Payable:              $500,410.96
  
  Tax Withholding: None (death benefit tax-free)
  1099-INT: $410.96 (interest portion)
  Net Payment to Beneficiary:   $500,410.96
```

#### Example 2: Whole Life with Loans and Multiple Beneficiaries

```
Policy: Participating Whole Life
Face Amount: $250,000
Paid-Up Additions: $35,000
Dividend Accumulations: $12,500
Terminal Dividend: $3,200
Policy Loan: $45,000 principal + $2,100 accrued interest
Issue Date: 2010-03-01
Date of Death: 2025-08-15
Overdue Premium: $0

Beneficiaries:
  Primary: Child A (50%), Child B (50%)

CALCULATION:
  Base Face Amount:             $250,000.00
  + PUA Face Amount:            $ 35,000.00
  + Dividend Accumulations:     $ 12,500.00
  + Terminal Dividend:          $  3,200.00
  = Gross Death Benefit:        $300,700.00
  
  - Policy Loan Principal:     ($ 45,000.00)
  - Accrued Loan Interest:     ($  2,100.00)
  = Net Death Benefit:          $253,600.00
  
  + Interest on benefit:        $    348.22  (20 days @ 5%)
  = Total Payable:              $253,948.22
  
  Allocation:
    Child A (50%):              $126,974.11
    Child B (50%):              $126,974.11
```

#### Example 3: Universal Life with Option B

```
Policy: Universal Life, Death Benefit Option B (Increasing)
Specified Amount: $400,000
Account Value (at DOD): $87,500
Issue Date: 2015-06-01
Date of Death: 2025-11-30
ADB Previously Paid: $100,000
Policy Loan: $0

CALCULATION:
  Specified Amount:             $400,000.00
  + Account Value:              $ 87,500.00
  = Gross Death Benefit (Opt B):$487,500.00
  
  - ADB Previously Paid:       ($100,000.00)
  - ADB Adjustment/Interest:   ($  5,200.00)  (per ADB rider terms)
  = Net Death Benefit:          $382,300.00
  
  + Interest:                   $    524.38
  = Total Payable:              $382,824.38
```

---

## 6. Decision Rules Engine

### 6.1 Architecture of the Decision Engine

```
┌──────────────────────────────────────────────────────────────────────┐
│                      CLAIMS DECISION ENGINE                          │
├──────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  ┌────────────────────────────────────────────────────────────┐     │
│  │                    RULES REPOSITORY                         │     │
│  │  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐     │     │
│  │  │ Coverage │ │ Benefit  │ │ Exclusion│ │ Routing  │     │     │
│  │  │ Rules    │ │ Calc     │ │ Rules    │ │ Rules    │     │     │
│  │  │          │ │ Rules    │ │          │ │          │     │     │
│  │  └──────────┘ └──────────┘ └──────────┘ └──────────┘     │     │
│  │  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐     │     │
│  │  │ State-   │ │ Product- │ │ Authority│ │ Fraud    │     │     │
│  │  │ Specific │ │ Specific │ │ Rules    │ │ Detection│     │     │
│  │  │ Rules    │ │ Rules    │ │          │ │ Rules    │     │     │
│  │  └──────────┘ └──────────┘ └──────────┘ └──────────┘     │     │
│  └────────────────────────────────────────────────────────────┘     │
│                              │                                       │
│                              ▼                                       │
│  ┌────────────────────────────────────────────────────────────┐     │
│  │                    EXECUTION ENGINE                          │     │
│  │                                                              │     │
│  │  Input:  Claim Data + Policy Data + Documents + External    │     │
│  │  Process: Evaluate rules in priority order                  │     │
│  │  Output:  Decision + Explanation + Required Actions         │     │
│  │                                                              │     │
│  │  Features:                                                   │     │
│  │  ├── Rule versioning (effective dates)                      │     │
│  │  ├── Rule conflict resolution (priority, specificity)       │     │
│  │  ├── Explanation generation (audit trail)                   │     │
│  │  ├── What-if analysis (testing mode)                        │     │
│  │  ├── State-specific rule selection                          │     │
│  │  └── Product-specific rule selection                        │     │
│  └────────────────────────────────────────────────────────────┘     │
│                                                                      │
└──────────────────────────────────────────────────────────────────────┘
```

### 6.2 Rule Categories and Examples

#### 6.2.1 Coverage Rules

```
RULE: POLICY_IN_FORCE_CHECK
  Priority: 1 (highest - must be evaluated first)
  Input: policy.status, policy.premium_status, death_date
  Logic:
    IF policy.status = "IN_FORCE" AND policy.premium_status = "CURRENT"
      THEN coverage = CONFIRMED
    ELSE IF policy.status = "IN_FORCE" AND policy.premium_status = "GRACE_PERIOD"
      THEN coverage = CONFIRMED, flag = "DEDUCT_OVERDUE_PREMIUM"
    ELSE IF policy.status = "LAPSED"
      THEN evaluate NON_FORFEITURE_OPTIONS
    ELSE IF policy.status = "PENDING_REINSTATEMENT"
      THEN evaluate REINSTATEMENT_ANALYSIS
    ELSE
      THEN coverage = DENIED, reason = "POLICY_NOT_IN_FORCE"

RULE: CONTESTABILITY_CHECK
  Priority: 2
  Input: policy.issue_date, death_date, policy.reinstatement_date, state_code
  Logic:
    contest_period = lookup_state_contest_period(state_code) -- typically 2 years
    effective_date = MAX(policy.issue_date, policy.reinstatement_date)
    
    IF months_between(effective_date, death_date) <= contest_period_months
      THEN flag = "CONTESTABLE"
           required_actions = [
             "ORDER_APPLICATION",
             "ORDER_APS",
             "CHECK_MIB",
             "CHECK_RX_HISTORY",
             "ASSIGN_SENIOR_EXAMINER"
           ]
    -- Note: Reinstatement restarts contestability in most states

RULE: SUICIDE_EXCLUSION_CHECK
  Priority: 3
  Input: manner_of_death, policy.issue_date, death_date, state_code
  Logic:
    suicide_period = lookup_state_suicide_period(state_code) -- 1-2 years
    
    IF manner_of_death IN ("SUICIDE", "SELF-INFLICTED")
      AND months_between(policy.issue_date, death_date) <= suicide_period_months
      THEN decision = "RETURN_PREMIUMS_ONLY"
           benefit = SUM(premiums_paid)
```

#### 6.2.2 State-Specific Rules

```
RULE: STATE_INTEREST_CALCULATION
  Varies by State:
  
  STATE: NEW_YORK
    interest_start = date_of_death
    interest_rate = higher of (policy_rate, current_rate_per_superintendent)
    penalty_after = 30 days from proof_of_loss_received
    
  STATE: CALIFORNIA
    interest_start = date_insurer_receives_due_proof_of_loss
    interest_rate = 10% per annum (after 30-day period)
    penalty_after = 30 days from due_proof_received
    
  STATE: TEXAS
    interest_start = date_claim_received
    interest_rate = 18% per annum (if not paid within 60 days)
    penalty_after = 60 days from claim_received (if no valid reason for delay)
    
  STATE: FLORIDA
    interest_start = date_insured_died
    interest_rate = per insurance code
    penalty_after = 60 days from filing proof of loss

RULE: STATE_PROMPT_PAYMENT
  STATE: CONNECTICUT
    requirement: Must pay within 30 days of receipt of proof of loss
    penalty: Interest at rate established by Insurance Commissioner
    
  STATE: ILLINOIS  
    requirement: Must pay within 30 days of receipt of satisfactory proof of loss
    penalty: Interest at 9% per annum
    
  STATE: NEW_JERSEY
    requirement: Must pay within 60 days of receipt of proof of loss
    penalty: Interest at 10% per annum
```

#### 6.2.3 Authority Rules

```
RULE: PAYMENT_AUTHORITY
  EXAMINER_LEVEL: JUNIOR
    max_authority: $100,000
    restrictions: 
      - Cannot process contestable claims
      - Cannot deny claims
      - Cannot process AD&D claims
    
  EXAMINER_LEVEL: STANDARD
    max_authority: $500,000
    restrictions:
      - Cannot deny claims without manager approval
      - Cannot process litigation claims
    
  EXAMINER_LEVEL: SENIOR
    max_authority: $2,000,000
    restrictions:
      - Cannot process claims > $2M without VP approval
      - Can deny claims (with documentation review)
    
  EXAMINER_LEVEL: MANAGER
    max_authority: $5,000,000
    
  EXAMINER_LEVEL: VP_CLAIMS
    max_authority: UNLIMITED
    
RULE: REFERRAL_AUTHORITY
  IF face_amount > examiner.max_authority
    THEN require_approval_from = next_authority_level
    
  IF decision = "DENY" AND examiner.level < "SENIOR"
    THEN require_approval_from = "MANAGER"
    
  IF decision = "RESCIND" 
    THEN require_approval_from = "LEGAL" AND "VP_CLAIMS"
```

---

## 7. Contestability Deep Dive

### 7.1 Material Misrepresentation Analysis

```
MATERIALITY ASSESSMENT FRAMEWORK:

1. IDENTIFY THE MISREPRESENTATION
   ├── What question was asked on the application?
   ├── What answer did the applicant provide?
   ├── What was the TRUE answer (from medical records, databases)?
   └── Is the discrepancy clearly documented?

2. DETERMINE MATERIALITY (varies by state law)
   
   Standard 1: "CONTRIBUTE TO CAUSE OF DEATH"
   ├── Would the undisclosed condition have contributed to the cause of death?
   ├── Most restrictive standard (insurer must show connection to death)
   └── States: Some jurisdictions
   
   Standard 2: "INCREASE THE RISK"
   ├── Would knowledge of the true facts have increased the assessed risk?
   ├── Moderate standard
   └── States: Some jurisdictions
   
   Standard 3: "AFFECT THE UNDERWRITING DECISION"  
   ├── Would the true facts have caused the insurer to:
   │   ├── Decline the application?
   │   ├── Charge a higher premium (rated)?
   │   ├── Exclude certain conditions?
   │   └── Offer a different product?
   ├── Most common standard
   └── States: Majority of jurisdictions
   
   Standard 4: "INTENT TO DECEIVE"
   ├── Did the applicant KNOWINGLY misrepresent?
   ├── Most insured-friendly standard
   └── States: Some jurisdictions

3. EVIDENCE GATHERING
   ├── Original application (signed by insured)
   ├── Medical records predating application
   ├── Prescription drug history predating application
   ├── MIB records
   ├── Prior insurance applications
   ├── Underwriting file (what was known at issue)
   └── Expert medical opinions

4. UNDERWRITING RE-EVALUATION
   ├── Submit undisclosed information to underwriting
   ├── Obtain underwriting opinion: "What would we have done?"
   │   ├── DECLINE → Supports rescission
   │   ├── RATE-UP → Supports reform (or rescission in some states)
   │   ├── ISSUE AS-IS → Immaterial, pay claim
   │   └── ISSUE WITH EXCLUSION → Supports partial denial
   └── Document the re-underwriting decision
```

### 7.2 Common Misrepresentation Scenarios

| Scenario | Application Question | Undisclosed Fact | Likely Materiality |
|---|---|---|---|
| Heart disease | "Have you been treated for heart disease?" | Had cardiac catheterization 6 months prior | Material (would likely rate or decline) |
| Cancer history | "Have you been diagnosed with cancer?" | Had skin cancer treated 3 years prior | Depends (type, staging, prognosis) |
| Tobacco use | "Have you used tobacco in last 12 months?" | Regular smoker, answered "No" | Material (significant rate difference) |
| Mental health | "Have you been treated for depression?" | On antidepressants for 2 years | May or may not be material (depends on severity, cause of death) |
| DUI history | "Have you had any DUI convictions?" | Two DUIs in past 5 years | Material if cause of death related; may still be material regardless |
| Hazardous activity | "Do you participate in aviation, skydiving?" | Licensed private pilot | Material (would likely add exclusion or rate) |
| Foreign travel | "Do you plan to travel to [listed countries]?" | Planned extended travel | Depends on destination and duration |

---

## 8. Automated Adjudication (Straight-Through Processing)

### 8.1 STP Decision Framework

```
┌──────────────────────────────────────────────────────────────────┐
│                 STP ELIGIBILITY ASSESSMENT                        │
├──────────────────────────────────────────────────────────────────┤
│                                                                    │
│  GATE 1: POLICY ELIGIBILITY                                      │
│  ├── ✓ Policy in force (status = ACTIVE, premium current)        │
│  ├── ✓ Beyond contestability period (>2 years from issue)        │
│  ├── ✓ Beyond suicide exclusion period                            │
│  ├── ✓ No pending policy changes/transactions                    │
│  ├── ✓ No outstanding loans > X% of face amount                  │
│  ├── ✓ No assignments (or simple collateral assignment)          │
│  └── ✓ Standard product type (not variable or complex rider)     │
│                                                                    │
│  GATE 2: BENEFICIARY ELIGIBILITY                                 │
│  ├── ✓ Single primary beneficiary (or simple split)              │
│  ├── ✓ Beneficiary is adult (>18)                                │
│  ├── ✓ Beneficiary designation is clear and unambiguous          │
│  ├── ✓ Beneficiary identity verified                              │
│  ├── ✓ No irrevocable beneficiary complications                  │
│  └── ✓ No known beneficiary disputes                              │
│                                                                    │
│  GATE 3: DEATH VERIFICATION                                       │
│  ├── ✓ Certified death certificate received                      │
│  ├── ✓ Cause of death completed (not "PENDING")                  │
│  ├── ✓ Manner of death = NATURAL                                  │
│  ├── ✓ Identity on death certificate matches policy              │
│  ├── ✓ Death occurred in US (or standard foreign jurisdiction)   │
│  └── ✓ No discrepancies in death certificate data                │
│                                                                    │
│  GATE 4: FRAUD / RISK SCREENING                                  │
│  ├── ✓ Fraud score below threshold                               │
│  ├── ✓ No SIU flags or prior investigations                     │
│  ├── ✓ No multiple recent policies on same insured               │
│  ├── ✓ No recent face amount increase                            │
│  ├── ✓ No STOLI indicators                                       │
│  └── ✓ Claim amount below auto-adjudication threshold            │
│                                                                    │
│  GATE 5: DOCUMENT COMPLETENESS                                    │
│  ├── ✓ All required documents received                           │
│  ├── ✓ Documents pass automated validation                       │
│  ├── ✓ Data extraction confidence above threshold                │
│  └── ✓ No conflicting information across documents               │
│                                                                    │
│  ALL GATES PASSED → PROCEED TO AUTO-PAYMENT                      │
│  ANY GATE FAILED → ROUTE TO HUMAN EXAMINER                       │
│                                                                    │
└──────────────────────────────────────────────────────────────────┘
```

### 8.2 STP Confidence Scoring

```
CONFIDENCE SCORE MODEL:

Component Scores (0-100):
  Policy Verification Score:     weight = 0.25
  Identity Verification Score:   weight = 0.20
  Document Verification Score:   weight = 0.20
  Death Verification Score:      weight = 0.20
  Fraud Risk Score (inverted):   weight = 0.15
  
  Composite Score = Σ(component_score × weight)
  
  STP Threshold = 85 (configurable)
  
  IF composite_score >= 85 AND all_gates_passed
    THEN eligible_for_STP = TRUE
  ELSE
    THEN eligible_for_STP = FALSE
    route_to_examiner = TRUE
    reason = list_of_failed_gates_and_low_scores
```

---

## 9. Quality Assurance and Audit

### 9.1 Pre-Payment Quality Review

```
QA REVIEW TRIGGER RULES:
  ALWAYS REVIEW:
  ├── All denials
  ├── All rescissions
  ├── Claims > $1,000,000
  ├── Claims paid to estate (no named beneficiary)
  ├── Claims with interpleader
  └── Claims with regulatory complaints
  
  SAMPLE REVIEW:
  ├── 10% random sample of all approved claims
  ├── 100% of new examiner claims (first 90 days)
  ├── 25% of claims within contestability period
  └── State-specific sampling requirements

QA CHECKLIST:
  □ Policy verification documented
  □ Beneficiary verification documented
  □ All required documents in file
  □ Death certificate verified (certified copy)
  □ Cause/manner of death assessed
  □ Contestability/suicide analysis completed (if applicable)
  □ Benefit calculation verified
  □ Deductions correctly applied
  □ Interest correctly calculated
  □ Beneficiary allocation correct
  □ Payment method confirmed
  □ Tax withholding correct (if applicable)
  □ Correspondence sent per requirements
  □ State-specific requirements met
  □ Reinsurance notification sent (if applicable)
  □ Authority limits complied with
  □ All system fields correctly populated
  □ Notes/documentation adequate for audit
```

### 9.2 Post-Payment Audit

| Audit Type | Frequency | Scope | Conducted By |
|---|---|---|---|
| **Internal QA** | Ongoing | Sample of all claims | QA Team |
| **Management Audit** | Monthly | Review QA findings, trends | Claims Management |
| **Compliance Audit** | Quarterly | Regulatory requirement adherence | Compliance |
| **Internal Audit** | Annual | Full process review | Internal Audit Dept |
| **External Audit** | As needed | Regulatory market conduct exam | State DOI / External Auditors |
| **Reinsurance Audit** | Per treaty | Claims above retention | Reinsurer |

---

## 10. Decision Outcomes

### 10.1 Outcome Types

| Outcome | Description | Required Actions |
|---|---|---|
| **APPROVE - Full Payment** | Full death benefit payable | Calculate benefit, process payment |
| **APPROVE - Partial Payment** | Portion of benefit payable (e.g., exclusion applies to rider) | Calculate applicable portion, explain partial payment |
| **DENY - Policy Not In Force** | Coverage had lapsed/terminated before death | Issue denial letter with appeal rights |
| **DENY - Exclusion Applies** | Death falls under a policy exclusion | Issue denial with specific exclusion cited |
| **DENY - Rescission** | Policy voided for material misrepresentation | Legal review required, return premiums, issue rescission letter |
| **DENY - Suicide Exclusion** | Death by suicide within exclusion period | Return premiums paid, issue denial letter |
| **PEND - Additional Info Needed** | Cannot make decision with current information | Request specific additional documents/info |
| **REFER - SIU** | Suspicious indicators warrant investigation | Transfer to SIU with referral memo |
| **REFER - Legal** | Legal complexity requires attorney involvement | Transfer to claims legal with summary |
| **REFER - Medical Director** | Medical complexity requires physician review | Send to medical director with records |
| **INTERPLEADER** | Conflicting claimants, cannot determine rightful payee | Engage legal, file interpleader action |
| **COMPROMISE** | Negotiated settlement (typically in contestability cases) | Legal negotiation, settlement agreement |

---

## 11. Architectural Recommendations

### 11.1 Rules Engine Selection Criteria

| Criterion | Importance | Notes |
|---|---|---|
| **Business User Authoring** | High | Claims managers should be able to modify rules without IT |
| **Version Control** | Critical | Rules must be versioned with effective dates |
| **Audit Trail** | Critical | Every rule evaluation must be logged |
| **Testing Framework** | High | Rules must be testable before deployment |
| **Performance** | Medium | Rules evaluation should complete in <1 second per claim |
| **State-Specific Parameterization** | High | Same rule logic, different parameters by state |
| **Product-Specific Configuration** | High | Rules vary by product type |
| **Integration** | High | Must integrate with claims workflow and data model |
| **Explanation Generation** | High | Must explain WHY a decision was reached |

### 11.2 Technology Options

| Approach | Pros | Cons | Examples |
|---|---|---|---|
| **BRMS (Business Rules Management System)** | Business user friendly, version control, testing | Cost, complexity, learning curve | Drools, IBM ODM, FICO Blaze Advisor, Corticon |
| **Decision Tables** | Simple, visual, easy to maintain | Limited complexity, scalability | Spreadsheet-driven, database tables |
| **Decision Model Notation (DMN)** | Standard notation, visual, executable | Requires DMN-compatible engine | Camunda, Red Hat, Signavio |
| **Custom Code** | Full flexibility, performance | Hard to maintain, no business user access | Java/Python rules in code |
| **Hybrid** | Balance of flexibility and governance | Complexity of multiple approaches | BRMS for core + code for edge cases |

### 11.3 Event-Driven Adjudication Pattern

```
Events Generated During Adjudication:
  CLAIM_DOCUMENTS_VERIFIED    → Triggers coverage analysis
  COVERAGE_CONFIRMED          → Triggers benefit calculation
  COVERAGE_DENIED             → Triggers denial workflow
  BENEFIT_CALCULATED          → Triggers decision review
  DECISION_APPROVED           → Triggers payment processing
  DECISION_DENIED             → Triggers denial notification
  AUTHORITY_EXCEEDED          → Triggers escalation workflow
  SIU_REFERRAL_TRIGGERED      → Triggers investigation workflow
  QA_REVIEW_REQUIRED          → Triggers QA workflow
  PAYMENT_AUTHORIZED          → Triggers payment execution
```

---

## 12. Summary

The claims adjudication and decision engine is the intellectual core of the claims system. Key architectural takeaways:

1. **Separate rules from code** - Business rules should be externalized and manageable by claims operations
2. **State-specific parameterization** - The same process with 50+ variations requires a robust configuration approach
3. **Full auditability** - Every decision must be explainable and traceable
4. **Authority controls** - Payment authority limits must be enforced systematically
5. **STP where appropriate** - Automate the simple to focus human expertise on the complex
6. **Calculation accuracy** - Benefit calculations must be precise to the penny
7. **Quality gates** - Build in pre-payment QA checkpoints
8. **Event-driven architecture** - Decouple adjudication steps for flexibility and scalability

---

*Previous: [Article 2: Claims Intake & FNOL](02-claims-intake-fnol.md)*
*Next: [Article 4: Data Standards - ACORD, HL7, FHIR, NAIC, ISO 20022](04-data-standards.md)*
