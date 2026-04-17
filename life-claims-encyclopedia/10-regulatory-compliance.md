# Article 10: Regulatory Compliance & Audit Frameworks

## Navigating the Complex Regulatory Landscape of Life Insurance Claims

---

## 1. Introduction

Life insurance claims are among the most heavily regulated activities in the financial services industry. Carriers must navigate a patchwork of federal and state regulations, industry standards, and evolving expectations. For architects, regulatory compliance must be built into system design from the ground up - it cannot be bolted on as an afterthought.

---

## 2. US Regulatory Framework

### 2.1 State-Based Regulation

Insurance in the US is primarily regulated at the state level. This means 50+ jurisdictions with unique requirements.

```
REGULATORY HIERARCHY:
│
├── FEDERAL
│   ├── IRS (tax reporting)
│   ├── DOL / ERISA (employer-sponsored plans)
│   ├── HIPAA (medical information privacy)
│   ├── OFAC (sanctions screening)
│   ├── FinCEN (anti-money laundering)
│   └── FTC (consumer protection)
│
├── NAIC (National Association of Insurance Commissioners)
│   ├── Model Laws and Regulations
│   ├── Market Conduct Standards
│   ├── Financial Examination Standards
│   └── Solvency Requirements
│
├── STATE DEPARTMENTS OF INSURANCE (50 states + DC + territories)
│   ├── Unfair Claims Settlement Practices Act
│   ├── Prompt Payment Laws
│   ├── Claims Handling Regulations
│   ├── Unclaimed Property / Escheatment
│   ├── Death Master File Matching Requirements
│   ├── Privacy Regulations
│   ├── Market Conduct Examination Authority
│   └── Consumer Complaint Handling
│
└── INDUSTRY SELF-REGULATION
    ├── ACLI (American Council of Life Insurers) - Principles
    ├── LOMA / LIMRA - Best Practices
    └── NAIC Model Laws (voluntary adoption)
```

### 2.2 Key Regulatory Requirements by State (Selected Examples)

```
UNFAIR CLAIMS SETTLEMENT PRACTICES:
(Based on NAIC Model Unfair Claims Settlement Practices Act)

Required Carrier Actions:
1. Acknowledge receipt of claim within [10-15] days (varies by state)
2. Begin investigation within [10-15] days of notice
3. Affirm or deny claim within [30-60] days of proof of loss
4. Not misrepresent policy provisions
5. Not require unnecessary documentation
6. Provide reasonable explanation for denial
7. Not delay investigation/payment unreasonably
8. Not compel litigation by offering substantially less
9. Attempt in good faith to settle promptly
10. Provide forms and instructions promptly

STATE-SPECIFIC TIMING REQUIREMENTS (Examples):
┌──────────────┬─────────────────┬──────────────────┬─────────────────────┐
│ State        │ Acknowledgment  │ Decision Deadline │ Payment After       │
│              │ Deadline        │                   │ Approval            │
├──────────────┼─────────────────┼──────────────────┼─────────────────────┤
│ California   │ 15 days         │ 40 days           │ 30 days             │
│ Connecticut  │ 15 days         │ 30 days           │ 30 days             │
│ Florida      │ 14 days         │ 60 days           │ 20 days             │
│ Illinois     │ 15 days         │ 30 days           │ 30 days             │
│ New York     │ 15 business days│ 30 days           │ 30 days             │
│ Texas        │ 15 days         │ 45 days           │ 5 business days     │
│ Pennsylvania │ 10 days         │ 30 days           │ 30 days             │
│ Ohio         │ 15 days         │ 21 days           │ 30 days             │
│ Georgia      │ 15 days         │ 60 days           │ 15 days             │
│ New Jersey   │ 10 days         │ 30 days           │ 30 days             │
└──────────────┴─────────────────┴──────────────────┴─────────────────────┘
Note: These are representative; actual requirements may be more nuanced.
```

### 2.3 ERISA Claims Requirements

```
ERISA (Employee Retirement Income Security Act) CLAIMS PROCEDURE:
(Applies to most employer-sponsored group life plans)

KEY REQUIREMENTS:
1. Claims must be decided within 90 days of receipt
   └── One 90-day extension with written notice
   
2. Denial notice must contain:
   ├── Specific reason(s) for denial
   ├── Reference to specific plan provisions
   ├── Description of additional material needed and why
   ├── Description of plan's review procedures and time limits
   ├── Statement of right to bring civil action under §502(a)
   └── If internal rule relied upon, provide rule or statement
       that it was relied upon and copy available on request

3. Appeal process:
   ├── Claimant has at least 60 days to file appeal
   ├── Must allow submission of written comments, documents, records
   ├── Must provide relevant documents on request
   ├── Review must consider all information (not just initial evidence)
   ├── Decision by fiduciary who did NOT make initial determination
   └── Appeal decision within 60 days

4. ERISA Preemption:
   ├── ERISA preempts state insurance laws for ERISA plans
   ├── State prompt payment laws generally do NOT apply to ERISA plans
   ├── State unfair claims practices acts generally do NOT apply
   └── Remedies are limited to plan benefits + fees
   
IMPORTANT: ERISA vs. NON-ERISA determination affects:
├── Which regulations apply
├── Which timeframes apply
├── What information must be in denial letters
├── What appeal procedures are required
├── What litigation rules apply
└── Whether state bad faith claims are available
```

---

## 3. Unclaimed Property / Escheatment

### 3.1 Regulatory Requirements

```
UNCLAIMED PROPERTY COMPLIANCE:

BACKGROUND:
├── Multi-state market conduct exams (2009+) revealed carriers
│   were not paying claims on policies where insured had died
├── Settlement agreements required carriers to:
│   ├── Match in-force policies against death databases
│   ├── Proactively identify deceased policyholders
│   ├── Make good-faith efforts to locate beneficiaries
│   └── Escheat unclaimed benefits to states
└── Many states have since enacted legislation codifying requirements

KEY REQUIREMENTS BY STATE (examples):
┌─────────────────────────────────────────────────────────────────────┐
│ Requirement                              │ Typical Standard         │
├──────────────────────────────────────────┼──────────────────────────┤
│ DMF matching frequency                   │ Monthly or quarterly     │
│ Response to match (initiate search)      │ 90 days                  │
│ Good-faith effort to locate beneficiary  │ Multiple attempts        │
│ Dormancy period before escheatment       │ 3-5 years (varies)       │
│ Reporting to state                       │ Annual filing            │
│ Interest on delayed payments             │ State-specified rate     │
│ Record retention                         │ 7-10 years               │
│ Audit trail of search efforts            │ Comprehensive            │
└──────────────────────────────────────────┴──────────────────────────┘

SYSTEM REQUIREMENTS:
├── Batch DMF matching engine (monthly/quarterly)
├── Match confidence scoring and review workflow
├── Beneficiary search tracking and documentation
├── Contact attempt logging (all channels)
├── State-specific dormancy period management
├── Unclaimed property reporting generation
├── Escheatment payment processing
├── Audit trail for all activities
└── Reporting to management and regulators
```

---

## 4. Privacy and Data Protection

### 4.1 HIPAA Compliance

```
HIPAA REQUIREMENTS FOR LIFE CLAIMS:

COVERED ENTITY STATUS:
├── Life insurers are generally NOT covered entities under HIPAA
├── BUT life insurers handle PHI and may be business associates
├── AND many states have adopted HIPAA-like privacy requirements
├── Best practice: Treat medical information as PHI regardless

WHEN HIPAA DIRECTLY APPLIES:
├── Group health/life combined plans
├── When carrier is also a health insurer
├── When carrier receives data from covered entities (hospitals, doctors)
└── Business associate relationships

PRACTICAL REQUIREMENTS:
├── Obtain valid authorization before requesting medical records
├── Minimum necessary standard (only request what's needed)
├── Secure storage of medical information
├── Access controls limiting who can view medical records
├── Audit trail of all access to medical information
├── Secure transmission of medical records
├── Proper disposal when no longer needed
└── Breach notification procedures
```

### 4.2 State Privacy Laws

| State | Law | Key Requirements |
|---|---|---|
| California | CCPA / CPRA | Consumer data rights, privacy notices, opt-out rights |
| New York | DFS Cybersecurity Regulation (23 NYCRR 500) | Cybersecurity program, data protection, incident reporting |
| Multiple States | NAIC Insurance Data Security Model Law | Data security program, incident response, notification |
| Colorado | Colorado Privacy Act | Consumer data rights, data protection assessments |
| Virginia | CDPA | Consumer data rights, data protection |

---

## 5. Compliance Architecture

### 5.1 Building Compliance Into Claims Systems

```
┌──────────────────────────────────────────────────────────────────────┐
│                    COMPLIANCE ARCHITECTURE                            │
├──────────────────────────────────────────────────────────────────────┤
│                                                                       │
│  ┌────────────────────────────────────────────────────────────┐     │
│  │                  REGULATORY RULES ENGINE                    │     │
│  │                                                              │     │
│  │  ┌────────────┐ ┌────────────┐ ┌────────────┐              │     │
│  │  │ State      │ │ Federal    │ │ Product    │              │     │
│  │  │ Rules      │ │ Rules      │ │ Rules      │              │     │
│  │  │ (50+)      │ │ (ERISA,IRS)│ │ (by type)  │              │     │
│  │  └────────────┘ └────────────┘ └────────────┘              │     │
│  │                                                              │     │
│  │  Rules Include:                                              │     │
│  │  ├── Timing requirements (ack, decision, payment)           │     │
│  │  ├── Notice content requirements                             │     │
│  │  ├── Interest calculation rates and triggers                │     │
│  │  ├── Denial letter requirements                              │     │
│  │  ├── Appeal procedure requirements                          │     │
│  │  ├── Escheatment dormancy periods                           │     │
│  │  └── Reporting requirements                                  │     │
│  └────────────────────────────────────────────────────────────┘     │
│                              │                                        │
│  ┌────────────────────────────────────────────────────────────┐     │
│  │                  COMPLIANCE MONITORING                       │     │
│  │                                                              │     │
│  │  ┌────────────┐ ┌────────────┐ ┌────────────┐              │     │
│  │  │ SLA Timer  │ │ Audit      │ │ Compliance │              │     │
│  │  │ Service    │ │ Logger     │ │ Dashboard  │              │     │
│  │  │            │ │            │ │            │              │     │
│  │  │ Tracks:    │ │ Captures:  │ │ Shows:     │              │     │
│  │  │ - Ack due  │ │ - All state│ │ - Overdue  │              │     │
│  │  │ - Decision │ │   changes  │ │   claims   │              │     │
│  │  │   due      │ │ - Who/When │ │ - SLA      │              │     │
│  │  │ - Payment  │ │ - System   │ │   breaches │              │     │
│  │  │   due      │ │   events   │ │ - Trends   │              │     │
│  │  │ - Follow-up│ │ - Reasons  │ │ - Risk     │              │     │
│  │  │   due      │ │            │ │   areas    │              │     │
│  │  └────────────┘ └────────────┘ └────────────┘              │     │
│  └────────────────────────────────────────────────────────────┘     │
│                                                                       │
└──────────────────────────────────────────────────────────────────────┘
```

### 5.2 SLA Timer Service Design

```python
class ComplianceSLATimer:
    """Manages regulatory compliance deadlines for claims."""
    
    def calculate_deadlines(self, claim):
        state = claim.governing_state
        claim_type = claim.claim_type
        is_erisa = claim.erisa_applicable
        
        if is_erisa:
            return self.erisa_deadlines(claim)
        
        state_config = self.get_state_config(state)
        
        return {
            'acknowledgment_due': self.add_business_days(
                claim.date_reported,
                state_config.ack_days
            ),
            'investigation_start_due': self.add_business_days(
                claim.date_reported,
                state_config.investigation_start_days
            ),
            'decision_due': self.add_calendar_days(
                claim.date_all_docs_received or claim.date_reported,
                state_config.decision_days
            ),
            'payment_due_after_approval': self.add_business_days(
                claim.date_decision,
                state_config.payment_days
            ),
            'interest_start_date': self.calculate_interest_start(
                claim, state_config
            ),
            'extension_notice_due': self.add_calendar_days(
                claim.date_reported,
                state_config.extension_notice_days
            ),
            'follow_up_notice_due': self.calculate_follow_up_dates(
                claim, state_config
            )
        }
    
    def erisa_deadlines(self, claim):
        return {
            'initial_decision_due': self.add_calendar_days(
                claim.date_received, 90
            ),
            'extension_if_needed': self.add_calendar_days(
                claim.date_received, 180  # 90 + 90 extension
            ),
            'appeal_filing_deadline': self.add_calendar_days(
                claim.denial_date, 60  # minimum per ERISA
            ),
            'appeal_decision_due': self.add_calendar_days(
                claim.appeal_received_date, 60
            )
        }
    
    def check_compliance(self, claim):
        """Check if claim is in compliance with all deadlines."""
        deadlines = self.calculate_deadlines(claim)
        today = datetime.now().date()
        violations = []
        warnings = []
        
        for deadline_name, deadline_date in deadlines.items():
            if deadline_date and today > deadline_date:
                if not self.is_deadline_met(claim, deadline_name):
                    violations.append({
                        'deadline': deadline_name,
                        'due_date': deadline_date,
                        'days_overdue': (today - deadline_date).days,
                        'regulatory_risk': 'HIGH'
                    })
            elif deadline_date and (deadline_date - today).days <= 5:
                warnings.append({
                    'deadline': deadline_name,
                    'due_date': deadline_date,
                    'days_remaining': (deadline_date - today).days
                })
        
        return {
            'compliant': len(violations) == 0,
            'violations': violations,
            'warnings': warnings
        }
```

---

## 6. Market Conduct Examinations

### 6.1 What Examiners Look For

```
MARKET CONDUCT EXAMINATION FOCUS AREAS:

1. CLAIMS HANDLING PRACTICES
   ├── Timeliness of acknowledgment
   ├── Timeliness of investigation
   ├── Timeliness of decision
   ├── Timeliness of payment
   ├── Adequacy of documentation
   ├── Accuracy of benefit calculations
   ├── Compliance with policy provisions
   └── Fairness of claims decisions

2. DENIAL PRACTICES
   ├── Denial rate compared to industry
   ├── Adequacy of denial reasons
   ├── Compliance with denial notice requirements
   ├── Appeal process compliance
   └── Pattern of unfair denials

3. DMF/UNCLAIMED PROPERTY
   ├── Frequency and completeness of DMF matching
   ├── Thoroughness of beneficiary search
   ├── Documentation of search efforts
   ├── Timeliness of escheatment
   └── Accuracy of unclaimed property reporting

4. CONSUMER COMPLAINTS
   ├── Complaint handling procedures
   ├── Timeliness of complaint response
   ├── Resolution of complaints
   └── Patterns in complaint types

5. DATA INTEGRITY
   ├── Accuracy of claim records
   ├── Completeness of documentation
   ├── System controls and audit trails
   └── Data retention compliance

PREPARATION TIPS FOR ARCHITECTS:
├── Ensure every claim action is timestamped and attributed
├── Build reports that can quickly demonstrate compliance
├── Design data extraction capabilities for examiner requests
├── Maintain complete audit trails for all claims
├── Build SLA monitoring dashboards
└── Ensure regulatory reporting capabilities are built-in
```

---

## 7. Tax Compliance

### 7.1 Tax Reporting Requirements

```
TAX REPORTING FOR LIFE CLAIMS:

DEATH BENEFITS:
├── Life insurance death benefit: Generally INCOME TAX-FREE (IRC §101(a))
├── EXCEPTION: Transfer for value → taxable gain
├── EXCEPTION: Employer-owned life insurance (EOLI) → may be taxable
├── Estate tax: Included in estate if insured owned policy
└── No 1099 typically issued for tax-free death benefit

INTEREST ON DEATH BENEFIT:
├── Interest paid on delayed payment IS TAXABLE
├── Issue 1099-INT for interest portion
├── State-specific interest rates and calculation methods
└── Report in year interest is paid

ANNUITY DEATH BENEFITS:
├── Taxable gain = Death benefit - Investment in contract
├── Issue 1099-R
├── Withholding may be required
├── Different rules for spouse vs. non-spouse beneficiary
├── Required minimum distribution rules may apply
└── Stretch provisions for non-spouse beneficiaries

ACCELERATED DEATH BENEFITS:
├── Generally tax-free if terminal illness (IRC §101(g))
├── Tax-free if chronically ill (up to per diem limit)
├── Issue 1099-LTC
├── Report to IRS regardless of taxability
└── Per diem limit indexed for inflation

IRS REPORTING TIMELINE:
├── 1099-INT: January 31 (to recipient), February 28 (to IRS)
├── 1099-R: January 31 (to recipient), February 28 (to IRS)
├── 1099-LTC: January 31 (to recipient), February 28 (to IRS)
├── Electronic filing extension: March 31
└── TIN solicitation: At time of claim, before payment
```

---

## 8. Audit Trail Design

### 8.1 Complete Audit Trail Requirements

```
AUDIT EVENT TYPES:
┌─────────────────────────┬──────────────────────────────────────────┐
│ Event Category          │ Specific Events to Capture               │
├─────────────────────────┼──────────────────────────────────────────┤
│ CLAIM LIFECYCLE         │ Created, Status Change, Closed, Reopened │
│ DOCUMENT                │ Received, Classified, Validated, Rejected│
│ ASSIGNMENT              │ Assigned, Reassigned, Escalated          │
│ DECISION                │ Coverage Decision, Benefit Calc,         │
│                         │ Approval, Denial, Rescission             │
│ PAYMENT                 │ Authorized, Issued, Voided, Returned     │
│ COMMUNICATION           │ Letter Sent, Email Sent, Call Made       │
│ DATA ACCESS             │ PHI Viewed, Record Accessed, Exported    │
│ DATA CHANGE             │ Any field modification                   │
│ SYSTEM                  │ Rule evaluation, STP decision, Fraud     │
│                         │ score, Auto-triage                       │
│ COMPLIANCE              │ SLA timer started, Deadline approaching, │
│                         │ Deadline missed, Extension granted       │
│ INVESTIGATION           │ SIU referral, Investigation activity,    │
│                         │ Finding, Recommendation                  │
│ QA                      │ Review assigned, Review completed,       │
│                         │ Issue found, Issue resolved              │
└─────────────────────────┴──────────────────────────────────────────┘

AUDIT RECORD SCHEMA:
{
  "eventId": "UUID",
  "timestamp": "ISO 8601 with timezone",
  "eventType": "CLAIM_STATUS_CHANGE",
  "eventCategory": "CLAIM_LIFECYCLE",
  "claimId": "CLM-2025-00789",
  "actor": {
    "userId": "examiner_jdoe",
    "role": "CLAIMS_EXAMINER",
    "ipAddress": "10.0.1.50",
    "sessionId": "sess_abc123"
  },
  "details": {
    "previousValue": "UNDER_REVIEW",
    "newValue": "APPROVED",
    "reason": "All documentation verified, coverage confirmed"
  },
  "systemContext": {
    "application": "claims-management-system",
    "version": "4.2.1",
    "environment": "PRODUCTION",
    "correlationId": "corr-xyz789"
  },
  "immutable": true,
  "tamperProof": "sha256:hash_of_event"
}
```

---

## 9. Summary

Regulatory compliance is not a feature - it is a fundamental design constraint for life claims systems. Key principles:

1. **Parameterize everything** - State-specific rules must be configurable, not coded
2. **Build SLA timers as a first-class service** - Regulatory deadlines are non-negotiable
3. **Audit everything** - If it's not logged, it didn't happen (from a regulator's perspective)
4. **Design for examination** - Build data extraction and reporting capabilities for regulators
5. **Separate ERISA from non-ERISA** - The rules are fundamentally different
6. **Stay current** - Regulations change; systems must adapt without major rebuilds
7. **Protect data** - PII and PHI protections must be designed in from the start

---

*Previous: [Article 9: Fraud Detection & SIU](09-fraud-detection-siu.md)*
*Next: [Article 11: Integration Architecture & API Design](11-integration-architecture.md)*
