# Article 6: Process Flows - End-to-End Claims Lifecycle

## Complete BPMN-Ready Process Definitions for Every Life Claims Scenario

---

## 1. Introduction

This article provides exhaustive, architect-ready process flow definitions for every major life insurance claims scenario. These flows are designed to be directly translatable into BPMN 2.0 process definitions for workflow engines like Camunda, Pega, or Appian.

---

## 2. Master Claims Process (Happy Path)

### 2.1 Level 0: End-to-End Overview

```
┌─────────┐   ┌──────────┐   ┌──────────┐   ┌──────────┐   ┌──────────┐   ┌───────┐
│  FNOL   │──▶│ Document │──▶│Coverage  │──▶│ Benefit  │──▶│ Payment  │──▶│ Close │
│  Intake │   │ Mgmt     │   │Analysis  │   │ Calc &   │   │Processing│   │       │
│         │   │          │   │& Decision│   │ Approval │   │          │   │       │
└─────────┘   └──────────┘   └──────────┘   └──────────┘   └──────────┘   └───────┘
   Day 0       Day 0-30       Day 1-45       Day 1-5        Day 1-5       Day 0-3
```

### 2.2 Level 1: Detailed Happy Path

```
PROCESS: STANDARD_DEATH_CLAIM
├── START EVENT: Death Notification Received
│
├── PHASE 1: INTAKE (Day 0)
│   ├── Task: Receive FNOL (Channel: Phone/Web/Mail/Partner)
│   ├── Task: Validate caller/submitter identity
│   ├── Task: Perform policy lookup in PAS
│   ├── Gateway: Policy found?
│   │   ├── Yes → Continue
│   │   └── No → Task: Search alternate systems → Gateway: Found?
│   │       ├── Yes → Continue
│   │       └── No → Task: Create inquiry record → END (No Policy)
│   ├── Task: Create claim record
│   ├── Task: Check for duplicate/related claims
│   ├── Task: Perform initial triage (rules engine)
│   ├── Task: Generate dynamic document checklist
│   ├── Task: Assign to examiner (skill-based routing)
│   ├── Task: Send acknowledgment to claimant
│   └── Task: Notify reinsurance (if face > retention)
│
├── PHASE 2: DOCUMENT COLLECTION (Day 0-30)
│   ├── Task: Track required documents
│   ├── Receive: Death Certificate
│   │   ├── Task: Validate death certificate (certified, complete)
│   │   ├── Task: Extract data (OCR/IDP or manual)
│   │   └── Task: Match insured identity
│   ├── Receive: Claim Form
│   │   ├── Task: Validate claim form completeness
│   │   └── Task: Verify claimant/beneficiary information
│   ├── Receive: Proof of Identity
│   │   └── Task: Verify beneficiary identity
│   ├── Timer: Document follow-up (14 days)
│   │   └── Task: Send reminder letter/email for outstanding docs
│   ├── Timer: Second follow-up (28 days)
│   │   └── Task: Send second reminder, phone call attempt
│   ├── Gateway: All required documents received?
│   │   ├── Yes → Proceed to Phase 3
│   │   └── No → Continue waiting (with periodic follow-up)
│   └── Timer: Abandonment threshold (180 days)
│       └── Task: Close for insufficient documentation (with notice)
│
├── PHASE 3: COVERAGE ANALYSIS (Day 1-15)
│   ├── Task: Verify policy was in force at date of death
│   ├── Task: Verify premium status / grace period
│   ├── Task: Check contestability status
│   ├── Gateway: Within contestability period?
│   │   ├── Yes → SUB-PROCESS: Contestability Investigation
│   │   └── No → Continue
│   ├── Task: Check suicide exclusion
│   ├── Gateway: Suicide exclusion applies?
│   │   ├── Yes → SUB-PROCESS: Suicide Exclusion Processing
│   │   └── No → Continue
│   ├── Task: Analyze exclusions (AD&D, war, aviation, etc.)
│   ├── Task: Verify beneficiary designation
│   ├── Gateway: Beneficiary clear and unambiguous?
│   │   ├── Yes → Continue
│   │   └── No → SUB-PROCESS: Beneficiary Resolution
│   ├── Task: Check for assignments
│   ├── Task: Check for divorce/separation affecting beneficiary
│   └── Task: Document coverage determination
│
├── PHASE 4: BENEFIT CALCULATION (Day 1-3)
│   ├── Task: Calculate base death benefit
│   ├── Task: Calculate rider benefits (if applicable)
│   ├── Task: Calculate deductions (loans, premiums, ADB)
│   ├── Task: Calculate interest on benefit
│   ├── Task: Calculate premium refund (if applicable)
│   ├── Task: Allocate among beneficiaries
│   ├── Task: Calculate tax withholding (if applicable)
│   ├── Task: Verify calculation (four-eyes or system check)
│   └── Task: Document benefit calculation
│
├── PHASE 5: DECISION & APPROVAL (Day 1-5)
│   ├── Task: Examiner makes coverage/payment decision
│   ├── Gateway: Decision type?
│   │   ├── Approve → Continue to authority check
│   │   ├── Deny → SUB-PROCESS: Denial Processing
│   │   └── Partial → SUB-PROCESS: Partial Payment Processing
│   ├── Task: Check authority limits
│   ├── Gateway: Within examiner's authority?
│   │   ├── Yes → Continue
│   │   └── No → Task: Escalate to appropriate authority level
│   │       └── Task: Manager/VP reviews and approves/modifies
│   ├── Gateway: QA review required?
│   │   ├── Yes → Task: QA review
│   │   │   ├── Approved → Continue
│   │   │   └── Issues found → Task: Return to examiner for correction
│   │   └── No → Continue
│   └── Task: Authorize payment
│
├── PHASE 6: PAYMENT PROCESSING (Day 1-5)
│   ├── Task: Generate payment instruction
│   ├── Gateway: Payment method?
│   │   ├── EFT/ACH → Task: Submit ACH transaction
│   │   ├── Check → Task: Print and mail check
│   │   ├── Wire → Task: Submit wire transfer
│   │   └── Retained Asset → Task: Establish retained asset account
│   ├── Task: Generate payment confirmation letter
│   ├── Task: Generate tax forms (1099-INT, 1099-R if applicable)
│   ├── Task: Update general ledger
│   ├── Task: Update reinsurance accounting (if applicable)
│   └── Task: Send payment notification to beneficiary
│
├── PHASE 7: CLOSURE (Day 0-3 after payment)
│   ├── Task: Verify payment cleared/delivered
│   ├── Task: Ensure all documentation complete
│   ├── Task: Archive claim file
│   ├── Task: Update policy status in PAS (claim paid, policy terminated)
│   ├── Task: Generate close-out correspondence
│   ├── Task: Update analytics/reporting
│   └── Task: Close claim
│
└── END EVENT: Claim Closed
```

---

## 3. Sub-Process: Contestability Investigation

```
SUB-PROCESS: CONTESTABILITY_INVESTIGATION
├── START
├── Task: Retrieve original application from underwriting file
├── Task: Order Attending Physician's Statement (APS) - application physicians
├── Task: Order APS - treating physician at time of death
├── Task: Order hospital records (last illness)
├── Task: Check MIB database
├── Task: Check prescription drug history (Rx database)
├── Parallel Gateway (wait for all):
│   ├── Receive: Application
│   ├── Receive: APS(s)
│   ├── Receive: Hospital records
│   ├── Receive: MIB results
│   └── Receive: Rx history
├── Task: Compare application disclosures to medical evidence
├── Task: Identify any undisclosed conditions
├── Gateway: Undisclosed conditions found?
│   ├── No → Output: COVERAGE_CONFIRMED
│   └── Yes → Continue materiality analysis
├── Task: Assess materiality of misrepresentation
│   ├── Submit undisclosed info to underwriting for re-evaluation
│   └── Receive underwriting opinion
├── Gateway: Was misrepresentation material?
│   ├── No (immaterial) → Output: COVERAGE_CONFIRMED
│   └── Yes (material) → Continue
├── Task: Legal review of evidence and proposed action
├── Gateway: Legal concurs with rescission?
│   ├── Yes → Task: Prepare rescission letter
│   │   ├── Task: Calculate premium return amount
│   │   ├── Task: Send rescission notice (state-specific format)
│   │   └── Output: RESCIND_POLICY
│   └── No → Task: Discuss alternatives (compromise, reform)
│       └── Output: NEGOTIATE_SETTLEMENT or COVERAGE_CONFIRMED
└── END
```

---

## 4. Sub-Process: Accidental Death (AD&D) Claim

```
SUB-PROCESS: AD_AND_D_CLAIM
├── START: AD&D rider identified on policy
├── Task: Review manner of death on death certificate
├── Gateway: Manner of death = ACCIDENT?
│   ├── No (Natural, Suicide, etc.) → Output: AD&D_NOT_PAYABLE
│   └── Yes or Undetermined → Continue
├── Task: Request police report / accident report
├── Task: Request autopsy report (if performed)
├── Task: Request toxicology report
├── Task: Review all evidence
├── Task: Analyze policy definition of "accident"
│   ├── Review: Was death caused solely and directly by accident?
│   ├── Review: Did death occur within policy time limit (e.g., 365 days)?
│   ├── Review: Were there contributing non-accidental factors?
│   └── Review: Do any AD&D exclusions apply?
├── Gateway: AD&D exclusions apply?
│   ├── Intoxication exclusion → Check toxicology against policy definition
│   ├── Illegal activity exclusion → Review police report
│   ├── Self-inflicted exclusion → Review evidence
│   ├── War/military exclusion → Review circumstances
│   ├── Aviation exclusion → Review if pilot/crew, commercial vs. private
│   └── No exclusions → Continue
├── Gateway: Was death accidental per policy definition?
│   ├── Yes → Task: Calculate AD&D benefit amount
│   │   ├── Full AD&D benefit (death)
│   │   ├── Or scheduled benefit (dismemberment - if applicable)
│   │   └── Output: AD&D_BENEFIT_PAYABLE
│   ├── No → Output: AD&D_NOT_PAYABLE (base death benefit still payable)
│   └── Unclear → Task: Refer to medical director for opinion
│       └── Task: Refer to legal if needed
└── END
```

---

## 5. Sub-Process: Beneficiary Resolution

```
SUB-PROCESS: BENEFICIARY_RESOLUTION
├── START: Beneficiary designation is unclear or disputed
├── Task: Retrieve all beneficiary change forms from policy history
├── Task: Review current beneficiary designation on file
├── Gateway: What is the issue?
│
├── BRANCH A: Predeceased Beneficiary
│   ├── Task: Verify beneficiary predeceased the insured
│   ├── Gateway: Per stirpes or per capita designation?
│   │   ├── Per stirpes → Task: Identify descendants of predeceased beneficiary
│   │   │   └── Task: Allocate predeceased beneficiary's share to descendants
│   │   ├── Per capita → Task: Reallocate among surviving beneficiaries equally
│   │   └── Not specified → Apply state default rule
│   └── Output: BENEFICIARY_DETERMINED
│
├── BRANCH B: Simultaneous Death
│   ├── Task: Apply Uniform Simultaneous Death Act (or state equivalent)
│   ├── Task: Determine if insured or beneficiary died first
│   │   └── If cannot determine → Treat beneficiary as predeceased
│   └── Output: BENEFICIARY_DETERMINED
│
├── BRANCH C: Divorce / Separation
│   ├── Task: Review divorce decree / settlement agreement
│   ├── Task: Determine state law on divorce and beneficiary revocation
│   │   ├── Many states: Divorce automatically revokes ex-spouse as beneficiary
│   │   ├── Some states: Divorce does NOT affect beneficiary designation
│   │   └── ERISA plans: Federal law may preempt state law
│   ├── Gateway: ERISA plan?
│   │   ├── Yes → Federal law applies (Slayer case law, ERISA preemption)
│   │   └── No → State law applies
│   └── Output: BENEFICIARY_DETERMINED or INTERPLEADER
│
├── BRANCH D: Competing Claims
│   ├── Task: Multiple parties claim beneficiary status
│   ├── Task: Review all evidence (designation forms, wills, court orders)
│   ├── Gateway: Can rightful beneficiary be determined?
│   │   ├── Yes → Output: BENEFICIARY_DETERMINED
│   │   └── No → Task: Recommend interpleader action
│   │       ├── Task: Engage legal department
│   │       ├── Task: File interpleader with court
│   │       ├── Task: Deposit funds with court
│   │       └── Output: INTERPLEADER_FILED
│
├── BRANCH E: Minor Beneficiary
│   ├── Task: Verify beneficiary is under 18
│   ├── Gateway: Custodian/Guardian designated?
│   │   ├── Yes → Task: Verify custodian/guardian identity and authority
│   │   └── No → Task: Require court-appointed guardian
│   │       └── Or: Apply UTMA/UGMA provisions (state-specific limits)
│   ├── Gateway: Payment amount > UTMA limit?
│   │   ├── Yes → Task: Require guardianship proceedings
│   │   └── No → Task: Pay to custodian under UTMA
│   └── Output: BENEFICIARY_DETERMINED
│
├── BRANCH F: No Named Beneficiary / Estate
│   ├── Task: Verify no surviving named beneficiaries
│   ├── Task: Review policy succession clause
│   │   └── Typical: spouse → children → parents → estate
│   ├── Task: Pay to estate of insured
│   ├── Task: Require Letters Testamentary / Letters of Administration
│   └── Output: ESTATE_PAYMENT
│
└── END
```

---

## 6. Sub-Process: SIU Investigation

```
SUB-PROCESS: SIU_INVESTIGATION
├── START: SIU referral triggered
├── Task: Create investigation case
├── Task: Assign SIU investigator
├── Task: Review referral reason and all claim documentation
├── Task: Develop investigation plan
│
├── INVESTIGATION ACTIVITIES (parallel as needed):
│   ├── Task: Database searches
│   │   ├── Public records
│   │   ├── Criminal history
│   │   ├── Financial records
│   │   ├── Prior insurance applications
│   │   ├── Social media
│   │   └── Industry fraud databases
│   ├── Task: Obtain additional records
│   │   ├── Detailed medical records
│   │   ├── Financial records
│   │   ├── Phone records
│   │   └── Travel records
│   ├── Task: Conduct interviews
│   │   ├── Beneficiary(ies)
│   │   ├── Family members
│   │   ├── Physicians
│   │   ├── Employer
│   │   ├── Neighbors / associates
│   │   └── Witnesses
│   ├── Task: Obtain official reports
│   │   ├── Full police report
│   │   ├── Autopsy/coroner report
│   │   ├── Fire marshal report
│   │   └── OSHA report (if workplace)
│   └── Task: Scene investigation (if warranted)
│
├── Task: Compile investigation report
├── Task: SIU makes recommendation
├── Gateway: Investigation finding?
│   ├── NO FRAUD FOUND → Output: RETURN_TO_CLAIMS (normal processing)
│   ├── FRAUD SUSPECTED → Continue
│   └── INCONCLUSIVE → Task: Determine if sufficient to decide
│
├── Task: Review with legal
├── Gateway: Action determination?
│   ├── DENY CLAIM → Task: Prepare denial with documentation
│   ├── RESCIND POLICY → Task: Prepare rescission documentation
│   ├── REFER TO LAW ENFORCEMENT → Task: File report with authorities
│   ├── PAY CLAIM (insufficient evidence) → Output: RETURN_TO_CLAIMS
│   └── COMPROMISE → Task: Negotiate settlement
│
└── END
```

---

## 7. Sub-Process: Denial Processing

```
SUB-PROCESS: DENIAL_PROCESSING
├── START: Decision to deny claim
├── Task: Document denial reason(s) thoroughly
├── Task: Legal review of denial (mandatory for most carriers)
├── Task: Prepare denial letter
│   ├── Include: Specific reason(s) for denial
│   ├── Include: Relevant policy provisions
│   ├── Include: Appeal rights and process
│   ├── Include: Time limits for appeal
│   ├── Include: Right to legal representation
│   └── Include: State-specific regulatory information
├── Task: Determine state-specific denial requirements
│   ├── Some states require specific language
│   ├── Some states require copy to agent/broker
│   ├── Some states require DOI notification for certain denials
│   └── ERISA plans have specific ERISA notice requirements
├── Task: Send denial letter (certified mail if required)
├── Task: Notify agent/broker (if applicable)
├── Task: Update claim status to DENIED
├── Task: Release any reserves
├── Timer: Appeal period monitoring
│   └── If appeal received → SUB-PROCESS: APPEAL_PROCESSING
└── END
```

---

## 8. Process: Accelerated Death Benefit (ADB) Claim

```
PROCESS: ACCELERATED_DEATH_BENEFIT
├── START: ADB claim submitted (terminal illness)
├── PHASE 1: INTAKE
│   ├── Task: Verify ADB rider exists on policy
│   ├── Task: Verify policy is in force
│   ├── Task: Create ADB claim record
│   └── Task: Request required documentation
│
├── PHASE 2: MEDICAL REVIEW
│   ├── Receive: Attending physician's certification of terminal illness
│   ├── Receive: Medical records supporting diagnosis
│   ├── Task: Medical director reviews diagnosis
│   ├── Gateway: Terminal illness confirmed?
│   │   ├── Yes → Continue
│   │   ├── No → Task: Deny ADB claim (life policy unaffected)
│   │   └── Insufficient info → Task: Request additional records
│   ├── Task: Verify life expectancy meets policy definition
│   │   └── Typically: 6 months, 12 months, or 24 months depending on rider
│   └── Task: Document medical determination
│
├── PHASE 3: BENEFIT CALCULATION
│   ├── Task: Determine maximum ADB amount per rider terms
│   │   ├── Typically: 25%-100% of face amount
│   │   └── May be limited by state law
│   ├── Task: Apply discount/lien formula
│   │   ├── Discount for early payment (actuarial calculation)
│   │   └── Or lien against future death benefit
│   ├── Task: Calculate impact on remaining death benefit
│   ├── Task: Determine tax implications
│   │   ├── Generally tax-free if terminally ill (IRC §101(g))
│   │   ├── May be taxable if chronically ill (per diem limits)
│   │   └── 1099-LTC may be required
│   └── Task: Present options to policyholder
│
├── PHASE 4: APPROVAL & PAYMENT
│   ├── Task: Policyholder elects ADB amount
│   ├── Task: Obtain irrevocable beneficiary consent (if applicable)
│   ├── Task: Process payment
│   ├── Task: Adjust policy records (reduced death benefit)
│   ├── Task: Generate 1099-LTC (if required)
│   └── Task: Update reinsurance
│
└── END: ADB Paid, Policy Continues with Reduced Benefit
```

---

## 9. Process: Waiver of Premium Claim

```
PROCESS: WAIVER_OF_PREMIUM
├── START: WoP claim submitted (disability)
├── PHASE 1: INITIAL CLAIM
│   ├── Task: Verify WoP rider exists
│   ├── Task: Verify policy is in force
│   ├── Task: Verify insured meets definition of disability
│   │   ├── "Own occupation" definition (unable to perform own job)
│   │   ├── "Any occupation" definition (unable to perform any job)
│   │   └── Elimination/waiting period (typically 6 months)
│   ├── Task: Request physician certification of disability
│   ├── Task: Request employer statement
│   └── Task: Medical director review
│
├── PHASE 2: APPROVAL
│   ├── Gateway: Disability meets policy definition?
│   │   ├── Yes → Continue
│   │   └── No → Deny WoP claim
│   ├── Task: Approve waiver
│   ├── Task: Waive premiums from date of disability
│   ├── Task: Refund premiums paid during elimination period (if applicable)
│   └── Task: Update policy to WoP status
│
├── PHASE 3: ONGOING MONITORING
│   ├── Timer: Annual recertification (or per policy terms)
│   ├── Task: Request updated medical evidence
│   ├── Gateway: Disability continues?
│   │   ├── Yes → Continue waiver, schedule next review
│   │   └── No → Task: Terminate waiver, resume premium billing
│   ├── Gateway: Insured reached maximum WoP age (typically 65)?
│   │   ├── Yes → Task: Terminate waiver, determine paid-up status
│   │   └── No → Continue monitoring
│   └── Loop back to timer
│
└── END: Waiver terminated (recovery, age limit, or death)
```

---

## 10. Process: Group Life Death Claim

```
PROCESS: GROUP_LIFE_DEATH_CLAIM
├── START: Group life death notification
├── PHASE 1: EMPLOYER NOTIFICATION
│   ├── Receive: Employer's Statement of Death
│   │   ├── Employee information
│   │   ├── Last day worked
│   │   ├── Employment status at death
│   │   ├── Coverage amount / benefit formula
│   │   ├── Beneficiary on file with employer
│   │   └── Continuation/conversion status
│   ├── Task: Verify group policy is in force
│   ├── Task: Verify employee was covered under group policy
│   │   ├── Actively at work requirement
│   │   ├── Eligibility waiting period
│   │   ├── Evidence of insurability (if required for amounts > guaranteed issue)
│   │   └── COBRA/continuation provisions
│   └── Task: Determine benefit amount
│       ├── Flat benefit (e.g., $50,000)
│       ├── Salary multiple (e.g., 2x annual salary)
│       ├── Graduated schedule
│       └── Voluntary/supplemental amounts
│
├── PHASE 2: STANDARD CLAIMS PROCESSING
│   ├── (Follow standard death claim process)
│   └── Additional considerations:
│       ├── ERISA applicability (most employer-sponsored plans)
│       ├── ERISA claim procedures and appeal requirements
│       ├── ERISA time limits (different from state law)
│       ├── Facility of payment clause
│       └── Conversion/portability rights (if death during conversion period)
│
├── PHASE 3: ERISA-SPECIFIC REQUIREMENTS
│   ├── Task: Provide ERISA-compliant notice
│   ├── Task: Full and fair review within 90 days
│   │   └── (45-day extension with notice if needed)
│   ├── If denied → Task: Provide ERISA-specific denial notice
│   │   ├── Specific reasons for denial
│   │   ├── Plan provisions on which denial is based
│   │   ├── Description of additional information needed
│   │   ├── Description of appeal procedures
│   │   └── Statement of right to bring civil action under ERISA §502(a)
│   └── If appealed → Task: Process appeal per ERISA requirements
│       ├── Different reviewer than initial decision
│       ├── De novo review of all evidence
│       └── Decision within 60 days of appeal
│
└── END
```

---

## 11. Process: Proactive Claim (DMF Match)

```
PROCESS: PROACTIVE_CLAIM_DMF_MATCH
├── START: DMF matching identifies deceased policyholder
├── PHASE 1: MATCH VERIFICATION
│   ├── Task: Review match confidence score
│   ├── Gateway: Confidence level?
│   │   ├── HIGH (SSN + Name + DOB match) → Auto-confirm
│   │   ├── MEDIUM (Partial match) → Manual review
│   │   │   ├── Task: Compare additional data points
│   │   │   └── Gateway: Confirmed? → Yes/No
│   │   └── LOW → Task: Manual review with additional verification
│   ├── Gateway: Match confirmed?
│   │   ├── Yes → Continue
│   │   └── No → Task: Document as false positive → END
│   └── Task: Create proactive claim record
│
├── PHASE 2: BENEFICIARY SEARCH
│   ├── Task: Retrieve beneficiary from policy records
│   ├── Task: Verify beneficiary contact information
│   ├── Gateway: Valid contact information available?
│   │   ├── Yes → Proceed to notification
│   │   └── No → Continue searching
│   ├── Task: Search carrier records (other policies, service history)
│   ├── Task: Search public records (LexisNexis, Accurint)
│   ├── Task: Search published obituaries
│   ├── Task: Contact agent of record
│   ├── Task: Contact last known address (mail)
│   ├── Gateway: Beneficiary located?
│   │   ├── Yes → Continue
│   │   └── No → Continue searching (minimum effort requirements)
│   ├── Timer: Search period (per state requirements)
│   └── Gateway: Beneficiary found within search period?
│       ├── Yes → Continue
│       └── No → SUB-PROCESS: ESCHEATMENT_PROCESSING
│
├── PHASE 3: BENEFICIARY NOTIFICATION
│   ├── Task: Send initial notification letter
│   │   ├── Inform of death benefit
│   │   ├── Provide claim filing instructions
│   │   └── Include claim forms
│   ├── Timer: First follow-up (30 days)
│   │   └── Task: Send follow-up letter
│   ├── Timer: Second follow-up (60 days)
│   │   └── Task: Attempt phone contact
│   ├── Timer: Third follow-up (90 days)
│   │   └── Task: Send certified letter
│   ├── Gateway: Beneficiary responds?
│   │   ├── Yes → Proceed with normal claims processing
│   │   └── No → Continue follow-up per state requirements
│   └── Timer: Final follow-up threshold
│       └── Gateway: Response received?
│           ├── Yes → Normal processing
│           └── No → SUB-PROCESS: ESCHEATMENT_PROCESSING
│
└── END
```

---

## 12. Process: Escheatment (Unclaimed Property)

```
SUB-PROCESS: ESCHEATMENT_PROCESSING
├── START: Beneficiary not located or non-responsive
├── Task: Document all search and contact attempts
├── Task: Determine applicable state(s) for escheatment
│   ├── Primary: State of beneficiary's last known address
│   ├── Secondary: State of insurer's domicile
│   └── Consider: State where policy was delivered
├── Task: Determine dormancy period (state-specific, typically 3-5 years)
├── Timer: Hold until dormancy period expires
├── Task: Generate unclaimed property report
│   ├── Include: Policy/claim details
│   ├── Include: Beneficiary information
│   ├── Include: Benefit amount
│   └── Include: Search effort documentation
├── Task: Submit report to state unclaimed property division
├── Task: Transfer funds to state
├── Task: Update claim records
├── Task: Maintain records for future beneficiary inquiry
└── END: Funds Escheated
```

---

## 13. Process Metrics and SLAs

### 13.1 Target SLAs by Claim Type

| Claim Type | Target Cycle Time | Regulatory Requirement | STP Target |
|---|---|---|---|
| Simple Death (Tier 1) | 5–10 business days | 30–60 days (state-specific) | 50% |
| Standard Death (Tier 2) | 15–30 business days | 30–60 days | 20% |
| Complex Death (Tier 3) | 30–60 business days | 30–60 days (extensions allowed) | 0% |
| Highly Complex (Tier 4) | 60–180 business days | Extensions with notification | 0% |
| AD&D | 30–45 business days | 30–60 days | 10% |
| ADB (Accelerated Death) | 15–30 business days | Varies | 5% |
| Waiver of Premium | 30–60 business days | Varies | 5% |
| Group Life Death | 10–20 business days | ERISA: 90 days | 30% |

### 13.2 Process Measurement Points

```
KEY MEASUREMENT POINTS:
  T0:  FNOL received (clock starts)
  T1:  Acknowledgment sent
  T2:  All documents received
  T3:  Review begins
  T4:  Decision made
  T5:  Payment authorized
  T6:  Payment issued
  T7:  Payment confirmed/delivered
  T8:  Claim closed

CALCULATED METRICS:
  Intake Time:        T0 → T1
  Document Wait:      T1 → T2
  Review Time:        T2 → T4
  Payment Time:       T4 → T6
  Total Cycle Time:   T0 → T6
  Close Time:         T6 → T8
  Touch Count:        Number of human interactions T0 → T8
```

---

## 14. Summary

These process flows provide the blueprint for implementing a life claims workflow engine. Key principles:

1. **Design for the exception** - Happy paths are simple; complex scenarios drive architecture
2. **Build sub-processes** for reusability - Contestability, beneficiary resolution, SIU investigation are used across claim types
3. **Instrument every step** - Capture timestamps, actors, and decisions for audit and analytics
4. **Parameterize timers** - SLA timers must be configurable by state and claim type
5. **Plan for human override** - Automated decisions must allow human override with documentation
6. **Support parallel activities** - Document collection, investigation tasks can happen concurrently
7. **Design for long-running processes** - Some claims take months or years (SIU, litigation)

---

*Previous: [Article 5: Data Formats & Canonical Data Models](05-data-formats-canonical-models.md)*
*Next: [Article 7: Automation & Straight-Through Processing (STP)](07-automation-stp.md)*
