# Article 1: Life Insurance Claims Domain Overview & Taxonomy

## A Comprehensive Architect's Reference to the Life Insurance Claims Landscape

---

## 1. Introduction

Life insurance claims represent the fulfillment of the fundamental promise that an insurance carrier makes to its policyholders: financial protection upon the occurrence of a covered life event. For a solutions architect, understanding the claims domain in its entirety is essential to designing systems that are accurate, compliant, scalable, and humane in their treatment of beneficiaries during some of the most difficult moments of their lives.

This article provides a comprehensive taxonomy of the life insurance claims domain, establishes a shared vocabulary, maps the key entities and relationships, and frames the architectural concerns that drive system design.

---

## 2. The Life Insurance Claims Universe

### 2.1 What Is a Life Insurance Claim?

A life insurance claim is a formal request made by a beneficiary (or their representative) to an insurance carrier for the payment of benefits under the terms of a life insurance policy, triggered by the death of the insured person (or in some cases, a qualifying living benefit event).

### 2.2 Claim Types in Life Insurance

| Claim Type | Trigger Event | Typical Products | Complexity |
|---|---|---|---|
| **Death Claim** | Death of the insured | Term Life, Whole Life, Universal Life, Variable Life | Medium–High |
| **Accidental Death Claim** | Death by accident | AD&D riders, standalone AD&D | High (investigation-heavy) |
| **Accelerated Death Benefit (ADB)** | Terminal illness diagnosis | Term/Whole/UL with ADB rider | High (medical review) |
| **Waiver of Premium Claim** | Disability of the insured | Policies with WoP rider | Medium (ongoing verification) |
| **Maturity Claim** | Policy reaches maturity date | Endowment policies | Low |
| **Surrender Claim** | Policyholder surrenders | Whole Life, UL, VUL | Low–Medium |
| **Annuity Death Claim** | Death of annuitant | Fixed/Variable Annuities | Medium |
| **Double/Triple Indemnity** | Accidental death meeting specific criteria | Policies with indemnity riders | High |
| **Dismemberment Claim** | Loss of limb/sight/hearing | AD&D policies | High |
| **Critical Illness Claim** | Diagnosis of covered critical illness | CI riders or standalone | High (medical) |
| **Long-Term Care Claim** | Inability to perform ADLs | LTC riders on life policies | Very High (ongoing) |

### 2.3 Key Distinctions from P&C Claims

| Dimension | Life Insurance Claims | P&C Claims |
|---|---|---|
| **Frequency** | Lower frequency per policy | Higher frequency |
| **Severity** | Fixed (face amount) or formula-based | Variable, requires loss estimation |
| **Trigger** | Death or qualifying health event | Accident, natural disaster, theft |
| **Beneficiary** | Usually not the insured | Usually the insured/policyholder |
| **Investigation** | Contestability, cause of death, fraud | Damage assessment, liability |
| **Duration** | Typically single payout | May involve extended adjustment |
| **Emotional Context** | Death/grief of family members | Property loss, injury |
| **Regulatory Focus** | Unfair claims practices, escheatment | Prompt payment, good faith |

---

## 3. Domain Entity Model

### 3.1 Core Entities

```
┌─────────────────────────────────────────────────────────────────────────┐
│                     LIFE CLAIMS DOMAIN MODEL                            │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  ┌──────────┐    ┌──────────────┐    ┌──────────────┐                  │
│  │  POLICY   │───▶│   INSURED    │    │  BENEFICIARY │                  │
│  │           │    │   (PERSON)   │    │   (PERSON)   │                  │
│  └─────┬────┘    └──────┬───────┘    └──────┬───────┘                  │
│        │                │                    │                           │
│        │         ┌──────▼───────┐           │                           │
│        │         │  DEATH EVENT │           │                           │
│        │         │  / TRIGGER   │           │                           │
│        │         └──────┬───────┘           │                           │
│        │                │                    │                           │
│        │         ┌──────▼───────────────────▼──────┐                   │
│        └────────▶│           CLAIM                  │                   │
│                  │  (ClaimID, Status, Type, Dates)  │                   │
│                  └──────┬──────────┬───────┬───────┘                   │
│                         │          │       │                            │
│              ┌──────────▼┐  ┌─────▼────┐ ┌▼──────────┐               │
│              │ DOCUMENTS  │  │ PAYMENTS │ │ ACTIVITIES │               │
│              │ (Evidence) │  │          │ │ (Tasks)    │               │
│              └────────────┘  └──────────┘ └───────────┘               │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

### 3.2 Detailed Entity Descriptions

#### 3.2.1 Policy
The policy is the contractual agreement between the carrier and the policyholder. It defines coverage terms, face amounts, riders, exclusions, and beneficiary designations.

**Key Attributes:**
- Policy Number (unique identifier)
- Product Type (Term, Whole Life, UL, VUL, IUL, etc.)
- Issue Date / Effective Date
- Face Amount / Death Benefit
- Policy Status (In-Force, Lapsed, Paid-Up, Extended Term, Reduced Paid-Up)
- Premium Status (Current, Grace Period, Lapsed)
- Contestability Period Status (Within 2 years, Beyond 2 years)
- Suicide Exclusion Period Status
- Riders (ADB, WoP, AD&D, CI, LTC, GPO, etc.)
- Beneficiary Designations (Primary, Contingent, Irrevocable, Revocable)
- Owner / Policyholder
- Assignment Status (Absolute, Collateral)
- Cash Value (for permanent products)
- Loan Balance
- Dividend Options (for participating policies)

#### 3.2.2 Insured Person
The individual whose life is covered by the policy.

**Key Attributes:**
- Full Legal Name
- Date of Birth
- Gender
- SSN/TIN
- Smoking Status (at issue)
- Underwriting Class
- Medical History (at issue)
- Occupation (at issue)
- Date of Death
- Cause of Death
- Place of Death
- Manner of Death (Natural, Accident, Suicide, Homicide, Undetermined)

#### 3.2.3 Beneficiary
The person(s) or entity(ies) designated to receive the death benefit.

**Key Attributes:**
- Full Legal Name
- Relationship to Insured
- Beneficiary Type (Primary, Contingent, Tertiary)
- Designation Type (Revocable, Irrevocable)
- Percentage Allocation
- Per Stirpes / Per Capita designation
- Minor Status (requires guardian/custodian)
- Trust Information (if applicable)
- Contact Information
- Tax ID (SSN/EIN)
- Bank Account Information (for EFT)

#### 3.2.4 Claim
The formal request for benefit payment.

**Key Attributes:**
- Claim Number
- Claim Type
- Claim Status (see State Machine below)
- Date of Loss (Date of Death)
- Date Reported (FNOL Date)
- Date Received (all required docs received)
- Claimant Information
- Assigned Examiner
- Benefit Amount Calculated
- Payment Method Requested
- Contestability Indicator
- Suicide Exclusion Indicator
- Fraud Indicators
- SIU Referral Flag
- Litigation Flag
- Reinsurance Notification Flag
- State of Jurisdiction

#### 3.2.5 Documents / Evidence
All supporting documentation required to process the claim.

**Key Documents:**
- Claimant's Statement (Proof of Death form)
- Certified Death Certificate
- Policy Document (original, if available)
- Attending Physician's Statement (APS)
- Hospital / Medical Records
- Autopsy Report
- Police Report / Accident Report
- Toxicology Report
- Coroner's Report
- Employer's Statement (for group policies)
- Proof of Identity (Beneficiary)
- Letters of Administration / Probate Documents
- Trust Documents
- Assignment Documents
- HIPAA Authorization
- Power of Attorney Documents
- Court Orders
- Interpleader Documents

#### 3.2.6 Payments
Financial transactions related to claim settlement.

**Key Attributes:**
- Payment ID
- Payment Type (Lump Sum, Installment, Interest, Retained Asset Account)
- Gross Amount
- Tax Withholding
- Net Amount
- Payment Method (Check, EFT/ACH, Wire, Retained Asset Account)
- Payee Information
- 1099 Reporting Information
- Payment Date
- Check Number / EFT Reference
- Voided/Stopped Indicator

#### 3.2.7 Activities / Tasks
Work items and audit trail entries.

**Key Attributes:**
- Activity ID
- Activity Type (Task, Note, Communication, System Event)
- Assigned To
- Due Date
- Priority
- Status
- Description
- Related Documents
- Timestamp
- User/System Identifier

---

## 4. Claim State Machine

```
                    ┌─────────────┐
                    │   REPORTED   │ (FNOL Received)
                    └──────┬──────┘
                           │
                    ┌──────▼──────┐
                    │   PENDING    │ (Awaiting Documents)
                    │  DOCUMENTS   │
                    └──────┬──────┘
                           │
                    ┌──────▼──────┐         ┌──────────────┐
                    │    UNDER     │────────▶│  SIU REFERRAL │
                    │   REVIEW     │◀────────│  (Investigation)│
                    └──────┬──────┘         └──────────────┘
                           │
              ┌────────────┼─────────────┐
              │            │             │
       ┌──────▼──────┐ ┌──▼────────┐ ┌──▼──────────┐
       │   APPROVED   │ │  DENIED   │ │  CONTESTED  │
       │              │ │           │ │  (Litigation)│
       └──────┬──────┘ └─────┬─────┘ └──────┬──────┘
              │              │               │
       ┌──────▼──────┐      │        ┌──────▼──────┐
       │  PAYMENT     │      │        │  SETTLEMENT │
       │  PROCESSING  │      │        │             │
       └──────┬──────┘      │        └──────┬──────┘
              │              │               │
       ┌──────▼──────┐      │               │
       │    PAID      │      │               │
       └──────┬──────┘      │               │
              │              │               │
              ▼              ▼               ▼
       ┌─────────────────────────────────────────┐
       │               CLOSED                     │
       └─────────────────────────────────────────┘
              │
       ┌──────▼──────┐
       │  REOPENED    │ (if new evidence surfaces)
       └─────────────┘
```

### 4.1 State Definitions

| State | Description | Typical Duration | System Actions |
|---|---|---|---|
| **REPORTED** | FNOL received, claim initiated | 0–1 day | Create claim record, assign examiner, send acknowledgment |
| **PENDING_DOCUMENTS** | Awaiting required documentation | 5–30 days | Track outstanding docs, send reminders, update checklist |
| **UNDER_REVIEW** | All docs received, examiner reviewing | 5–30 days | Verify policy, validate documents, calculate benefits |
| **SIU_REFERRAL** | Referred to Special Investigations Unit | 30–180 days | Flag claim, assign investigator, request additional info |
| **APPROVED** | Claim approved for payment | 0–3 days | Calculate final amount, generate payment authorization |
| **DENIED** | Claim denied (with reason) | N/A | Generate denial letter, comply with state notification requirements |
| **CONTESTED** | Beneficiary disputes denial or amount | 30–365+ days | Engage legal, manage correspondence, track deadlines |
| **PAYMENT_PROCESSING** | Payment being processed | 1–5 days | Issue check/EFT, generate tax documents |
| **PAID** | Payment issued and confirmed | N/A | Confirm delivery, update accounting |
| **CLOSED** | Claim fully resolved | N/A | Archive documents, update analytics, release reserves |
| **REOPENED** | Closed claim reopened due to new info | Variable | Re-assess, assign examiner, resume investigation |

---

## 5. Product Taxonomy Deep Dive

### 5.1 Term Life Insurance
- **Level Term**: Fixed death benefit for a specified period (10, 15, 20, 30 years)
- **Decreasing Term**: Death benefit decreases over time (often tied to mortgage)
- **Annual Renewable Term (ART)**: Renews annually with increasing premiums
- **Return of Premium Term**: Returns premiums if insured survives the term
- **Convertible Term**: Can be converted to permanent insurance without evidence of insurability
- **Group Term Life**: Employer-sponsored, typically 1x–3x salary

**Claims Implications:**
- Simple benefit calculation (face amount)
- Conversion rights must be verified if claim occurs during conversion period
- Grace period analysis is critical (was policy in force at time of death?)
- Contestability and suicide exclusion periods are straightforward

### 5.2 Whole Life Insurance
- **Ordinary/Traditional Whole Life**: Fixed premiums, guaranteed cash value growth
- **Limited Payment Whole Life**: Premiums paid for limited period (e.g., 20-Pay, Paid-Up at 65)
- **Single Premium Whole Life**: Funded with one lump-sum payment
- **Participating Whole Life**: Eligible for dividends
- **Non-Participating Whole Life**: No dividends

**Claims Implications:**
- Death benefit may include terminal dividend
- Policy loans reduce death benefit
- Paid-up additions increase death benefit
- Dividend accumulations may be payable
- Cash value not separately payable at death (subsumed by death benefit)
- Reduced Paid-Up or Extended Term status affects benefit amount

### 5.3 Universal Life (UL)
- **Traditional UL**: Flexible premiums, interest-crediting rate
- **Guaranteed UL (GUL)**: Guaranteed death benefit to specified age
- **Indexed UL (IUL)**: Cash value tied to equity index performance
- **Variable UL (VUL)**: Cash value invested in sub-accounts
- **Survivorship/Second-to-Die UL**: Pays upon death of second insured

**Claims Implications:**
- Cost of Insurance (COI) deductions affect cash value
- Account value must be calculated precisely at date of death
- Death benefit option (Level vs. Increasing) affects payout
- Lapse/No-Lapse guarantee provisions require careful analysis
- VUL sub-account values must be frozen at date of death
- Secondary guarantee provisions may keep policy in force even with zero cash value
- Surrender charges may be relevant for living benefit claims

### 5.4 Annuity Death Claims
- **Fixed Annuities**: Guaranteed minimum rate
- **Variable Annuities**: Sub-account invested
- **Indexed Annuities**: Tied to market index

**Claims Implications:**
- Contract value vs. death benefit guarantee (GMDB)
- Highest anniversary value guarantees
- Step-up provisions
- Annuitization status (pre vs. post annuitization)
- Taxation differs significantly from life insurance (gain is taxable)
- Stretch provisions for non-spouse beneficiaries
- Required distribution rules

---

## 6. Organizational Taxonomy

### 6.1 Claims Department Structure

```
┌──────────────────────────────────────────────────────────────────┐
│                    VP / SVP of Claims                             │
├──────────┬──────────┬──────────┬──────────┬─────────────────────┤
│  Claims   │  Claims   │  SIU     │  Claims   │  Claims            │
│  Intake   │  Exam/    │  (Special│  Legal    │  Operations        │
│  Unit     │  Adjud.   │  Invest.)│          │  & Analytics       │
├──────────┼──────────┼──────────┼──────────┼─────────────────────┤
│ FNOL Reps │ Examiners │ SIU Inv. │ Attorneys │ Ops Analysts       │
│ Coord.    │ Sr Exam.  │ SIU Mgrs │ Paralegals│ Data Scientists    │
│           │ Med Dir.  │          │           │ QA Specialists     │
│           │ Tech Spec.│          │           │ Compliance Officers│
└──────────┴──────────┴──────────┴──────────┴─────────────────────┘
```

### 6.2 Roles and Responsibilities

| Role | Responsibilities | System Access Needs |
|---|---|---|
| **FNOL Representative** | Receive initial notification, create claim, request initial documents | Claim creation, policy lookup, document checklist |
| **Claims Examiner** | Review documentation, verify coverage, calculate benefits, make decisions | Full claim workspace, policy admin system, medical records, calculator |
| **Senior Claims Examiner** | Handle complex claims, authorize larger payments, mentor | All examiner access + authority limits, override capability |
| **Medical Director** | Review medical evidence, opine on cause of death, contestability | Medical records viewer, APS review, clinical databases |
| **SIU Investigator** | Investigate suspicious claims, gather evidence | Investigation case management, external databases, surveillance tools |
| **Claims Attorney** | Handle litigated claims, interpleader actions, regulatory responses | Legal case management, document management, court filing systems |
| **Quality Assurance** | Audit completed claims, ensure compliance | Read-only claim access, audit templates, reporting |
| **Claims Manager** | Oversee team performance, manage workload, escalations | Dashboard, reporting, assignment/routing tools |

---

## 7. Key Business Metrics

### 7.1 Operational KPIs

| Metric | Definition | Industry Benchmark |
|---|---|---|
| **Average Cycle Time** | Days from FNOL to payment | 5–15 days (simple), 30–90 days (complex) |
| **Pending Claim Inventory** | Open claims at any point in time | Varies by carrier size |
| **Claims Per Examiner** | Active claims per examiner | 80–150 |
| **First Contact Resolution** | % of claims resolved at first touch | 15–25% |
| **STP Rate** | % of claims processed without human intervention | 10–30% (industry moving toward 40–60%) |
| **Touch Count** | Average number of human touches per claim | 3–8 |
| **Document Completeness Rate** | % of claims received with all required docs | 30–50% |
| **Payment Accuracy** | % of payments issued with correct amount | 99.5%+ |
| **Denial Rate** | % of claims denied | 1–3% (life insurance) |
| **Reopened Rate** | % of closed claims that are reopened | <2% |
| **Customer Satisfaction (CSAT)** | Beneficiary satisfaction score | 70–85% |
| **Net Promoter Score (NPS)** | Willingness to recommend | 30–50 |
| **Escheatment Rate** | % of claims escheated to state | Should be minimized |
| **Litigation Rate** | % of claims entering litigation | <1% |
| **Regulatory Complaint Rate** | Complaints per 1000 claims | <5 |

### 7.2 Financial KPIs

| Metric | Definition |
|---|---|
| **Incurred Claims** | Total claims reported in a period |
| **Paid Claims** | Total claims paid in a period |
| **Claims Reserve** | Estimated liability for unpaid claims |
| **IBNR (Incurred But Not Reported)** | Estimated claims that have occurred but not yet reported |
| **Loss Ratio** | Claims paid / Premiums earned |
| **Claims Expense Ratio** | Claims operating costs / Claims paid |
| **Average Claim Size** | Total paid / Number of claims |
| **Reserve Adequacy** | Actual payments vs. initial reserve estimates |

---

## 8. Regulatory Landscape

### 8.1 Key Regulatory Bodies

| Jurisdiction | Body | Key Regulations |
|---|---|---|
| **US - State** | State Departments of Insurance | Unfair Claims Settlement Practices Acts, Prompt Payment Laws |
| **US - Federal** | IRS, DOL (for ERISA plans) | Tax reporting (1099-R, 1099-INT), ERISA preemption |
| **US - NAIC** | National Association of Insurance Commissioners | Model Laws, Market Conduct Standards |
| **EU** | EIOPA, National Regulators | Solvency II, IDD, GDPR |
| **UK** | FCA, PRA | Consumer Duty, ICOBS |
| **India** | IRDAI | Claims settlement guidelines, turnaround times |
| **Australia** | APRA, ASIC | Life Insurance Code of Practice |
| **Canada** | Provincial Regulators, OSFI | Provincial Insurance Acts |

### 8.2 Key US Regulatory Requirements

1. **Unfair Claims Settlement Practices (UCSPA)**
   - Cannot misrepresent policy provisions
   - Must acknowledge claims promptly (typically 10–15 days)
   - Must adopt reasonable standards for investigation
   - Must affirm or deny coverage within reasonable time
   - Cannot compel litigation by offering substantially less than amount due
   - Must provide prompt, fair settlement when liability is clear

2. **Prompt Payment Laws (vary by state)**
   - Typical requirement: 30–60 days from receipt of proof of loss
   - Interest penalties for late payment
   - Some states: 30 days from receipt of all required documentation

3. **Death Master File (DMF) / Unclaimed Property**
   - Carriers must proactively identify deceased policyholders
   - Must make good-faith efforts to locate beneficiaries
   - Must escheat unclaimed benefits to state after dormancy period
   - Regulations emerged from multi-state market conduct examinations

4. **Contestability Period**
   - Standard 2-year period from policy issue
   - Carrier may rescind policy for material misrepresentation
   - After 2 years, generally only fraud allows rescission
   - Some states limit to 1 year for group policies

5. **Suicide Exclusion**
   - Typically 2 years from policy issue (1 year in some states)
   - If insured dies by suicide within exclusion period, carrier returns premiums only
   - Does not apply after exclusion period expires

---

## 9. Technology Landscape

### 9.1 Core Systems

| System | Purpose | Key Vendors |
|---|---|---|
| **Policy Administration System (PAS)** | Policy lifecycle management, source of truth for coverage | EXL (LifePRO), Sapiens, Majesco, Oracle Insurance, DXC (CSC), EIS, Socotra |
| **Claims Management System** | End-to-end claims processing | Guidewire ClaimCenter (primarily P&C), Fineos, Sapiens, Majesco, DXC |
| **Document Management** | Store, index, retrieve documents | OnBase (Hyland), FileNet (IBM), Documentum (OpenText), Alfresco |
| **Workflow/BPM** | Orchestrate claims processes | Pega, Appian, Camunda, IBM BAW, Microsoft Power Automate |
| **Correspondence** | Generate letters, notices | Messagepoint, Quadient, Smart Communications, OpenText Exstream |
| **Payment Processing** | Issue checks, EFT, wire transfers | Internal GL, Payment platforms, Jack Henry, FIS |
| **Analytics/BI** | Reporting, dashboards, predictive | Tableau, Power BI, SAS, Snowflake, Databricks |
| **Fraud Detection** | Identify suspicious claims | SAS Fraud, FICO, Shift Technology, custom ML models |

### 9.2 Emerging Technologies

| Technology | Application in Claims |
|---|---|
| **AI/ML** | Automated document classification, fraud scoring, benefit calculation verification, chatbots |
| **OCR/IDP** | Extracting data from death certificates, medical records, claim forms |
| **RPA** | Automating repetitive data entry, cross-system data validation |
| **Blockchain** | Death verification networks, policy verification, cross-carrier coordination |
| **Cloud** | Scalable infrastructure, serverless processing, managed AI services |
| **Low-Code** | Rapid workflow customization, rule management UIs |
| **APIs** | Real-time integrations, open insurance initiatives, partner ecosystem |

---

## 10. Architectural Concerns and Quality Attributes

### 10.1 Key Quality Attributes for Claims Systems

| Quality Attribute | Importance | Rationale |
|---|---|---|
| **Accuracy** | Critical | Incorrect payments have financial and regulatory consequences |
| **Auditability** | Critical | Every decision must be traceable for regulatory examination |
| **Security** | Critical | PII, PHI, and financial data require stringent protection |
| **Compliance** | Critical | Multi-state/multi-jurisdiction regulatory requirements |
| **Availability** | High | Claims processing is time-sensitive and regulated |
| **Scalability** | Medium–High | Catastrophic events can cause claim spikes |
| **Performance** | Medium | Acceptable response times for examiner productivity |
| **Extensibility** | High | Frequent regulatory changes require adaptable rules |
| **Interoperability** | High | Must integrate with PAS, payment, document, external services |
| **Usability** | Medium–High | Examiner productivity and beneficiary self-service |
| **Maintainability** | High | Long-lived systems require sustainable architecture |

### 10.2 Cross-Cutting Architectural Concerns

1. **Data Governance**: Who owns claim data? How is PII/PHI managed across systems?
2. **Event Sourcing**: Should claim state changes be captured as immutable events?
3. **CQRS**: Separate read/write models for claims inquiry vs. processing?
4. **Multi-Tenancy**: Supporting multiple lines of business or operating companies?
5. **Regulatory Configuration**: How to manage 50+ state-specific rules without code changes?
6. **Legacy Integration**: How to modernize while coexisting with legacy PAS/mainframe?
7. **Data Lake/Warehouse**: How to consolidate claims data for analytics and reporting?
8. **Disaster Recovery**: RPO/RTO requirements for claims data?
9. **Data Residency**: Where can claims data be stored and processed (especially for global carriers)?
10. **Accessibility**: WCAG compliance for beneficiary-facing portals?

---

## 11. Industry Trends Shaping Claims Architecture

### 11.1 Proactive Claims (Death Notification Matching)
Carriers are increasingly required to proactively identify when policyholders have died, rather than waiting for beneficiary notification. This requires integration with the Social Security Death Master File (DMF), LexisNexis, and other death verification databases.

### 11.2 Digital-First Claims Experience
Beneficiaries expect digital submission, real-time status tracking, and electronic payment. Mobile-first design, e-signature, and digital document upload are becoming table stakes.

### 11.3 Straight-Through Processing (STP)
The holy grail of claims automation: processing a claim from intake to payment with zero human touches. Requires robust rules engines, automated document processing, and confidence-based routing.

### 11.4 Ecosystem Integration
Claims systems must participate in a broader ecosystem: funeral homes, hospitals, government databases, reinsurers, TPAs, financial advisors, and more. API-first design enables this.

### 11.5 Predictive Analytics
Using historical claims data to predict cycle times, identify fraud, forecast reserves, and optimize staffing. Machine learning models are increasingly embedded in claims workflows.

### 11.6 Parametric Life Insurance
Emerging products that trigger automatic payment upon verified death event without traditional claims process. Requires real-time death verification and automated payment infrastructure.

---

## 12. Claim Complexity Classification

Architects must design systems that handle claims of varying complexity efficiently. A common approach is to classify claims into tiers:

### Tier 1: Simple / Auto-Adjudicable
- Policy clearly in force
- Beyond contestability period
- Single, clearly identified beneficiary
- Death certificate matches insured
- Natural cause of death
- No outstanding policy loans or assignments
- No fraud indicators
- **Target: STP or minimal-touch processing**

### Tier 2: Moderate Complexity
- Multiple beneficiaries
- Minor beneficiary (requires custodian/guardian)
- Policy loan outstanding
- Recent lapse/reinstatement
- Conversion in progress
- Non-standard death certificate (foreign death, military)
- **Target: 1–2 examiner touches**

### Tier 3: Complex
- Within contestability period
- Suicide within exclusion period
- Accidental death (AD&D claim)
- Conflicting beneficiary designations
- Divorce decree affecting beneficiary
- ERISA plan complexities
- International death
- **Target: Senior examiner, possible medical/legal review**

### Tier 4: Highly Complex / Special Handling
- Suspected fraud
- Homicide investigation pending
- Interpleader action required
- Regulatory complaint or litigation
- High face amount (authority limits)
- Missing insured / presumed dead
- Stranger-Originated Life Insurance (STOLI) suspicion
- **Target: Dedicated team, legal involvement, extended timeline**

---

## 13. Glossary of Key Terms

| Term | Definition |
|---|---|
| **ADB** | Accelerated Death Benefit - living benefit paid upon terminal illness diagnosis |
| **AD&D** | Accidental Death & Dismemberment |
| **APS** | Attending Physician's Statement |
| **Beneficiary** | Person or entity designated to receive death benefit |
| **Claimant** | Person filing the claim (may be beneficiary or their representative) |
| **Contestability Period** | Period (typically 2 years) during which carrier can investigate and rescind |
| **COD** | Cause of Death |
| **DMF** | Death Master File (Social Security Administration) |
| **ERISA** | Employee Retirement Income Security Act (governs employer-sponsored plans) |
| **Escheatment** | Transfer of unclaimed property to the state |
| **Face Amount** | The death benefit amount stated in the policy |
| **FNOL** | First Notice of Loss - initial notification of a claim event |
| **GMDB** | Guaranteed Minimum Death Benefit (annuities) |
| **Grace Period** | Time after premium due date during which policy remains in force |
| **Incontestable Clause** | Policy provision limiting carrier's right to contest after specified period |
| **Interpleader** | Legal action to deposit funds with court when beneficiary dispute exists |
| **IBNR** | Incurred But Not Reported claims |
| **Material Misrepresentation** | False information on application that would have affected underwriting decision |
| **MOD** | Manner of Death (Natural, Accident, Suicide, Homicide, Undetermined) |
| **Per Stirpes** | Beneficiary designation where deceased beneficiary's share passes to their descendants |
| **Per Capita** | Beneficiary designation where shares are divided equally among surviving beneficiaries |
| **Proof of Loss** | Formal documentation submitted to support a claim |
| **Rescission** | Voiding a policy from inception due to material misrepresentation |
| **Retained Asset Account** | Interest-bearing account established for beneficiary in lieu of lump sum |
| **SIU** | Special Investigations Unit |
| **STOLI** | Stranger-Originated Life Insurance |
| **STP** | Straight-Through Processing |
| **Subrogation** | Right to recover from third party (rare in life insurance, more common in health) |
| **TPA** | Third-Party Administrator |
| **Unfair Claims Practices** | Statutory prohibitions against bad faith claims handling |
| **WoP** | Waiver of Premium |

---

## 14. Summary

The life insurance claims domain is a rich, complex business area that requires architects to balance:

- **Regulatory compliance** across multiple jurisdictions
- **Operational efficiency** through automation and straight-through processing
- **Human empathy** in designing beneficiary experiences
- **Data accuracy** in benefit calculations and payment processing
- **Security and privacy** for sensitive personal and medical information
- **Flexibility** to accommodate diverse products and business rules
- **Integration** with legacy systems and external services

The articles that follow in this encyclopedia will deep-dive into each of these areas, providing the detailed knowledge needed to architect world-class life insurance claims solutions.

---

*Next: [Article 2: Claims Intake & First Notice of Loss (FNOL)](02-claims-intake-fnol.md)*
