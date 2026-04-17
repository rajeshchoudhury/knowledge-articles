# Article 2: Claims Intake & First Notice of Loss (FNOL)

## The Critical First Step in Life Insurance Claims Processing

---

## 1. Introduction

First Notice of Loss (FNOL) is the initial notification to an insurance carrier that a covered event (typically the death of an insured) has occurred and that a claim is being submitted. This is the most critical touchpoint in the claims lifecycle for several reasons:

1. **It sets the regulatory clock** - State prompt payment statutes begin ticking
2. **It establishes the beneficiary's first impression** - A compassionate, efficient experience builds trust
3. **It determines downstream efficiency** - Accurate, complete intake reduces cycle time
4. **It creates the audit trail foundation** - All subsequent activity references back to FNOL

For architects, the FNOL subsystem must be designed for multi-channel ingestion, intelligent triage, data validation, and seamless handoff to the claims examination pipeline.

---

## 2. FNOL Channels

### 2.1 Channel Landscape

```
┌────────────────────────────────────────────────────────────────────┐
│                      FNOL INTAKE CHANNELS                          │
├────────────┬─────────────┬──────────┬────────────┬────────────────┤
│  PHONE     │  WEB PORTAL │  MOBILE  │  MAIL/FAX  │  THIRD-PARTY  │
│  (Call     │  (Self-     │  APP     │  (Physical │  (Funeral Home,│
│  Center)   │  Service)   │          │  Documents)│  Employer,     │
│            │             │          │            │  Hospital,     │
│            │             │          │            │  Agent/Broker) │
├────────────┴─────────────┴──────────┴────────────┴────────────────┤
│                    UNIFIED INTAKE ENGINE                            │
│  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐             │
│  │ Channel  │ │ Data     │ │ Document │ │ Duplicate│             │
│  │ Adapter  │ │Validation│ │ Receipt  │ │ Detection│             │
│  └──────────┘ └──────────┘ └──────────┘ └──────────┘             │
├────────────────────────────────────────────────────────────────────┤
│                    CLAIMS MANAGEMENT SYSTEM                         │
└────────────────────────────────────────────────────────────────────┘
```

### 2.2 Channel Details

#### 2.2.1 Telephone (Contact Center)
**Current State:** Still the most common channel (40–60% of FNOL)

**Process:**
1. Caller identifies themselves and the insured
2. Agent performs policy lookup (by policy number, name + DOB, SSN)
3. Agent collects basic claim information using guided script
4. System validates policy status in real-time
5. Agent explains required documents
6. Acknowledgment letter/email generated
7. Claim record created with initial data

**Architectural Requirements:**
- CTI (Computer Telephony Integration) for screen pop
- Real-time PAS integration for policy lookup
- Guided scripting engine (context-sensitive questions)
- Call recording and storage
- Warm transfer capability to specialized teams
- Multi-language support (IVR and live agent)
- Integration with workforce management (WFM) for call routing
- Sentiment analysis (real-time) for quality monitoring

**Data Captured:**
```json
{
  "fnol": {
    "caller": {
      "name": "Jane Smith",
      "relationship_to_insured": "Spouse",
      "phone": "555-123-4567",
      "email": "jane.smith@email.com",
      "address": { ... }
    },
    "insured": {
      "name": "John Smith",
      "date_of_birth": "1965-03-15",
      "ssn_last_four": "4567",
      "policy_number": "LIF-2020-001234"
    },
    "death_information": {
      "date_of_death": "2025-12-01",
      "place_of_death": "Memorial Hospital, Springfield, IL",
      "cause_of_death_description": "Heart attack",
      "manner_of_death": "Natural",
      "attending_physician": "Dr. Robert Johnson"
    },
    "channel": "PHONE",
    "agent_id": "CSR-1234",
    "call_reference": "CALL-2025-12-03-00456",
    "timestamp": "2025-12-03T10:30:00Z"
  }
}
```

#### 2.2.2 Web Portal (Self-Service)
**Current State:** Growing rapidly (20–35% of FNOL), preferred by younger demographics

**Process:**
1. User authenticates (registered beneficiary or new registration)
2. Guided claim filing wizard (multi-step form)
3. Real-time policy validation
4. Document upload capability (photos/scans)
5. E-signature for claim forms
6. Confirmation and tracking number provided
7. Status dashboard available immediately

**Architectural Requirements:**
- Responsive web design (mobile-friendly)
- Identity verification / authentication (Knowledge-Based Authentication, ID verification)
- Progressive form validation
- Document upload with virus scanning and format validation
- E-signature integration (DocuSign, Adobe Sign, etc.)
- Real-time policy lookup API
- Session persistence (save and resume)
- WCAG 2.1 AA accessibility compliance
- Multi-language support
- CAPTCHA / bot protection
- SSL/TLS encryption

**UX Considerations:**
- Empathetic tone and messaging
- Clear progress indicators
- Minimal required fields at intake (collect essentials, request details later)
- Help text and tooltips for insurance terminology
- Live chat or callback option for assistance
- Document checklist with examples of acceptable documents
- Mobile camera integration for document capture

#### 2.2.3 Mobile Application
**Current State:** Emerging channel (5–15% of FNOL)

**Additional Capabilities Beyond Web:**
- Push notifications for status updates
- Camera-native document capture
- Biometric authentication (Face ID, fingerprint)
- GPS-tagged document photos
- Offline mode with sync
- Native share functionality for collecting documents from others

#### 2.2.4 Mail / Fax
**Current State:** Declining but still significant (15–25% of FNOL), especially for older demographics

**Process:**
1. Physical mail/fax received in mail room
2. Documents scanned and digitized
3. OCR/IDP extracts key data
4. Claim record created (may be manual or automated)
5. Documents indexed and attached to claim
6. Acknowledgment sent to return address

**Architectural Requirements:**
- High-volume scanning infrastructure
- OCR/IDP pipeline (see Article 8)
- Document classification (death certificate vs. claim form vs. correspondence)
- Data extraction and validation
- Workflow for manual review of low-confidence extractions
- Mail room tracking (date received stamp is legally significant)

#### 2.2.5 Third-Party Notification

**Sources:**
- **Funeral Homes**: Some states require/encourage funeral home notification; emerging digital partnerships
- **Employers**: For group life policies, HR department initiates claim
- **Hospitals / Healthcare Facilities**: May notify upon patient death
- **Agents / Brokers**: Field force reports death of client
- **Attorneys**: Estate attorneys filing on behalf of estate
- **DMF Matching**: Proactive identification through death record databases (see Section 7)

**Architectural Requirements:**
- B2B integration (API, EDI, SFTP)
- Partner portal for employers and funeral homes
- ACORD messaging standards
- Bulk filing capability (for group claims from catastrophic events)
- Partner authentication and authorization

---

## 3. FNOL Data Model

### 3.1 Core FNOL Data Elements

```
┌─────────────────────────────────────────────────────────────────┐
│                        FNOL RECORD                               │
├─────────────────────────────────────────────────────────────────┤
│ HEADER                                                           │
│   - FNOL ID (system-generated unique identifier)                │
│   - Received Date/Time                                           │
│   - Channel (Phone, Web, Mail, Mobile, ThirdParty)              │
│   - Agent/User ID                                                │
│   - Source System                                                │
│                                                                  │
│ CLAIMANT INFORMATION                                             │
│   - Name (First, Middle, Last, Suffix)                          │
│   - Relationship to Insured                                      │
│   - Contact Information (Phone, Email, Address)                  │
│   - Preferred Contact Method                                     │
│   - Preferred Language                                           │
│   - Representative/Attorney (if applicable)                      │
│                                                                  │
│ INSURED INFORMATION                                              │
│   - Name (First, Middle, Last, Suffix)                          │
│   - Date of Birth                                                │
│   - SSN (full or last 4)                                        │
│   - Policy Number(s)                                             │
│                                                                  │
│ LOSS INFORMATION                                                 │
│   - Date of Death                                                │
│   - Place of Death (Facility, City, State, Country)             │
│   - Cause of Death (as reported by claimant)                    │
│   - Manner of Death (Natural, Accident, Suicide, Homicide,     │
│     Undetermined, Pending)                                       │
│   - Attending Physician (Name, Phone, Address)                   │
│   - Was Death Accidental? (Y/N/Unknown)                         │
│   - Was an Autopsy Performed? (Y/N/Unknown)                     │
│   - Is there a Police/Accident Report? (Y/N/Unknown)            │
│   - Was the Insured Employed at Time of Death?                  │
│   - Military Service Status at Time of Death                     │
│                                                                  │
│ POLICY REFERENCE                                                 │
│   - Policy Number                                                │
│   - Product Type (retrieved from PAS)                            │
│   - Policy Status (retrieved from PAS)                          │
│   - Face Amount (retrieved from PAS)                             │
│   - Riders (retrieved from PAS)                                  │
│   - Beneficiary Designations (retrieved from PAS)               │
│   - Contestability Status (calculated)                           │
│   - Suicide Exclusion Status (calculated)                        │
│                                                                  │
│ DOCUMENT TRACKING                                                │
│   - Required Documents Checklist                                 │
│   - Documents Received                                           │
│   - Documents Outstanding                                        │
│                                                                  │
│ INITIAL ASSESSMENT                                               │
│   - Complexity Score                                             │
│   - Auto-Adjudication Eligibility                               │
│   - Fraud Score                                                  │
│   - Estimated Benefit Amount                                     │
│   - Routing Recommendation                                       │
└─────────────────────────────────────────────────────────────────┘
```

### 3.2 Required vs. Optional Fields at FNOL

**Minimum Required (to create a claim):**
- Claimant name and contact information
- Insured name (or policy number)
- Date of death (or approximate)
- Relationship of claimant to insured

**Highly Desirable (to begin processing):**
- Policy number
- Insured date of birth or SSN
- Place of death
- Cause of death
- Claimant's beneficiary status

**Optional (collected later if not available):**
- Physician information
- Autopsy details
- Accident/police report information
- Employment status
- Detailed cause of death

---

## 4. Policy Verification at FNOL

### 4.1 Real-Time Policy Lookup

Upon receiving FNOL, the system must immediately verify the policy:

```
FNOL Received
     │
     ▼
┌─────────────────┐     ┌────────────────────┐
│ Policy Lookup    │────▶│ Policy Admin System │
│ (by number, name,│     │ (PAS)              │
│  SSN, DOB)      │◀────│                    │
└────────┬────────┘     └────────────────────┘
         │
         ▼
┌─────────────────┐
│ Validate:        │
│ - Policy exists  │
│ - Insured matches│
│ - Status check   │
│ - Coverage check │
└────────┬────────┘
         │
    ┌────┴─────┐
    │          │
    ▼          ▼
 VALID      INVALID
    │          │
    ▼          ▼
 Continue   Review:
 Processing  - Lapsed?
             - Wrong policy?
             - No policy found?
             - Deceased mismatch?
```

### 4.2 Policy Status Assessment

| Policy Status | Claim Action |
|---|---|
| **In Force** | Proceed normally |
| **Grace Period** | Proceed; premium may be deducted from benefit |
| **Lapsed (within reinstatement period)** | Check if death occurred before lapse; check reinstatement pending |
| **Lapsed (beyond reinstatement)** | Likely deny; verify lapse date vs. death date |
| **Paid-Up** | Proceed; verify paid-up face amount |
| **Extended Term** | Proceed if death within extended term period |
| **Reduced Paid-Up** | Proceed; use reduced face amount |
| **Surrendered** | No death benefit; verify surrender date vs. death date |
| **Matured** | Maturity benefit may be payable, not death benefit |
| **Pending Issue** | Check if coverage was bound; conditional receipt analysis |
| **Pending Reinstatement** | Complex analysis required |
| **Converted** | Identify new policy; process under new policy |

### 4.3 Contestability & Suicide Analysis

```python
# Pseudocode for contestability/suicide assessment at FNOL

def assess_contestability(policy_issue_date, death_date, state_code):
    years_in_force = calculate_years(policy_issue_date, death_date)
    contest_period = get_state_contest_period(state_code)  # Usually 2 years
    
    if years_in_force < contest_period:
        return {
            "contestable": True,
            "action": "FLAG_FOR_INVESTIGATION",
            "priority": "HIGH",
            "required_actions": [
                "Order application from underwriting file",
                "Request APS for all physicians on application",
                "Compare cause of death with application disclosures",
                "Review MIB check results",
                "Consider pharmacy database check (Rx history)"
            ]
        }
    else:
        return {
            "contestable": False,
            "action": "PROCEED_NORMAL",
            "note": "Beyond contestability period"
        }

def assess_suicide_exclusion(policy_issue_date, death_date, 
                              manner_of_death, state_code):
    years_in_force = calculate_years(policy_issue_date, death_date)
    suicide_period = get_state_suicide_period(state_code)  # 1-2 years
    
    if manner_of_death in ["SUICIDE", "UNDETERMINED", "PENDING"]:
        if years_in_force < suicide_period:
            return {
                "exclusion_applies": True,
                "action": "RETURN_PREMIUMS_ONLY",
                "benefit": calculate_total_premiums_paid(policy),
                "required_evidence": [
                    "Death certificate with manner of death",
                    "Coroner/Medical Examiner report",
                    "Police report",
                    "Toxicology report"
                ]
            }
        else:
            return {
                "exclusion_applies": False,
                "action": "PROCEED_NORMAL",
                "note": "Beyond suicide exclusion period, full benefit payable"
            }
    return {"exclusion_applies": False, "action": "PROCEED_NORMAL"}
```

---

## 5. Intelligent Triage & Routing

### 5.1 Triage Decision Matrix

At FNOL, the system should automatically classify and route the claim:

```
┌──────────────────────────────────────────────────────────────────┐
│                    TRIAGE ENGINE                                   │
├──────────────────────────────────────────────────────────────────┤
│                                                                    │
│  INPUT FACTORS:                                                   │
│  ├── Policy Age (years since issue)                               │
│  ├── Cause of Death                                               │
│  ├── Manner of Death                                              │
│  ├── Face Amount                                                  │
│  ├── Number of Policies                                           │
│  ├── Beneficiary Complexity                                       │
│  ├── Product Type                                                 │
│  ├── Rider Coverage                                               │
│  ├── Prior Claims History                                         │
│  ├── Fraud Score (from predictive model)                         │
│  ├── Lapse/Reinstatement History                                 │
│  └── Special Flags (STOLI, assignment, litigation)               │
│                                                                    │
│  OUTPUT:                                                          │
│  ├── Complexity Tier (1-4)                                        │
│  ├── Examiner Assignment (skill-based routing)                   │
│  ├── STP Eligibility (Yes/No)                                    │
│  ├── Required Document Checklist                                  │
│  ├── Priority Level (Standard, Expedited, Urgent)                │
│  ├── SIU Referral Flag                                            │
│  ├── Reinsurance Notification Required                           │
│  └── Estimated Cycle Time                                        │
│                                                                    │
└──────────────────────────────────────────────────────────────────┘
```

### 5.2 Routing Rules Examples

```
RULE: STP_ELIGIBLE
  IF policy_age > 2 years
  AND manner_of_death = "NATURAL"
  AND beneficiary_count = 1
  AND beneficiary_designation = "REVOCABLE"
  AND face_amount <= $250,000
  AND no_outstanding_loans
  AND no_assignments
  AND no_fraud_indicators
  AND death_certificate_received
  AND all_required_docs_received
  THEN route_to = "AUTO_ADJUDICATION"

RULE: CONTESTABLE_CLAIM
  IF policy_age <= 2 years
  THEN route_to = "SENIOR_EXAMINER"
  AND flag = "CONTESTABLE"
  AND priority = "HIGH"
  AND additional_docs = ["APPLICATION", "APS", "MIB_REPORT"]

RULE: HIGH_VALUE_CLAIM
  IF face_amount > $1,000,000
  THEN route_to = "SENIOR_EXAMINER"
  AND flag = "HIGH_VALUE"
  AND notification = "REINSURANCE_TEAM"
  AND authority_level = "MANAGER_APPROVAL_REQUIRED"

RULE: ACCIDENTAL_DEATH
  IF manner_of_death = "ACCIDENT"
  AND rider_type includes "AD&D"
  THEN route_to = "AD&D_SPECIALIST"
  AND additional_docs = ["POLICE_REPORT", "ACCIDENT_REPORT", "AUTOPSY"]
  AND ad&d_benefit_calculation = TRUE

RULE: SUSPICIOUS_CLAIM
  IF fraud_score > THRESHOLD
  OR (policy_age < 2 years AND manner_of_death IN ["HOMICIDE", "UNDETERMINED"])
  OR (face_amount_recently_increased AND policy_age < 1 year)
  OR (multiple_policies_recent AND total_face > $2,000,000)
  THEN route_to = "SIU"
  AND flag = "INVESTIGATION_REQUIRED"
  AND priority = "URGENT"
```

### 5.3 Skill-Based Examiner Assignment

```
EXAMINER SKILLS MATRIX:
┌──────────────┬─────┬─────┬─────┬─────┬─────┬─────┐
│ Examiner     │ Std │ AD&D│ WoP │ ADB │ Cont│ High│
│              │Claim│     │     │     │ est │Value│
├──────────────┼─────┼─────┼─────┼─────┼─────┼─────┤
│ Jr Examiner  │  ✓  │     │     │     │     │     │
│ Examiner     │  ✓  │  ✓  │  ✓  │     │     │     │
│ Sr Examiner  │  ✓  │  ✓  │  ✓  │  ✓  │  ✓  │     │
│ Specialist   │  ✓  │  ✓  │  ✓  │  ✓  │  ✓  │  ✓  │
└──────────────┴─────┴─────┴─────┴─────┴─────┴─────┘

ASSIGNMENT ALGORITHM:
1. Determine required skill set based on claim characteristics
2. Filter eligible examiners by skill
3. Apply load balancing (current caseload)
4. Apply state/jurisdiction specialization
5. Apply product specialization
6. Consider geographic proximity for potential field investigation
7. Check examiner authority limits vs. face amount
8. Round-robin among qualified, available examiners
```

---

## 6. Document Requirements Engine

### 6.1 Dynamic Document Checklist

The required documents vary based on claim characteristics. The system should generate a dynamic checklist:

```
BASE REQUIREMENTS (All Death Claims):
├── Claimant's Statement / Proof of Death Form
├── Certified Death Certificate
└── Proof of Claimant Identity

CONDITIONAL REQUIREMENTS:
├── IF manner_of_death = "ACCIDENT"
│   ├── Police Report / Accident Report
│   ├── Autopsy Report
│   └── Toxicology Report
│
├── IF policy_age <= 2 years (contestable)
│   ├── Attending Physician's Statement (APS)
│   ├── Hospital Records (last illness)
│   └── HIPAA Authorization
│
├── IF beneficiary = MINOR
│   ├── Guardian/Custodian Documentation
│   └── Court Order (if required by state)
│
├── IF claimant ≠ named_beneficiary
│   ├── Letters of Administration
│   ├── Probate Documents
│   └── Court-Certified Copy of Will
│
├── IF assignment exists
│   ├── Original Assignment Document
│   └── Assignee Claim Form
│
├── IF policy_type = "GROUP"
│   ├── Employer's Statement
│   └── Enrollment/Eligibility Records
│
├── IF death occurred outside US
│   ├── Consular Report of Death Abroad (or equivalent)
│   ├── Translated Death Certificate
│   └── Apostille / Authentication
│
├── IF irrevocable_beneficiary AND beneficiary_predeceased
│   ├── Death Certificate of Predeceased Beneficiary
│   └── Documentation of per stirpes/per capita distribution
│
├── IF divorce_on_record
│   ├── Divorce Decree
│   └── Property Settlement Agreement
│
├── IF trust_beneficiary
│   ├── Trust Document (relevant pages)
│   └── Trustee Certification
│
└── IF multiple_policies
    └── Single claim form may cover all; verify each policy
```

### 6.2 Document Tracking States

```
Document Lifecycle:
  REQUIRED → REQUESTED → RECEIVED → VALIDATED → ACCEPTED
                                        │
                                        ▼
                                    REJECTED (re-request)
                                    
States:
  REQUIRED:   Document identified as needed for this claim
  REQUESTED:  Request sent to claimant/provider
  RECEIVED:   Document received but not yet reviewed
  VALIDATED:  Document reviewed and verified (content, authenticity)
  ACCEPTED:   Document accepted as meeting requirements
  REJECTED:   Document does not meet requirements (reason captured)
  WAIVED:     Document requirement waived (with authorization and reason)
  N/A:        Document not applicable for this claim
```

---

## 7. Death Master File (DMF) & Proactive Claims

### 7.1 Regulatory Background

Following multi-state market conduct examinations (beginning ~2009), regulators have required life insurers to:

1. **Regularly match** their in-force policy books against death databases
2. **Proactively initiate** claims when a match is found
3. **Make good-faith efforts** to locate beneficiaries
4. **Escheat** unclaimed death benefits to the state after required dormancy period

### 7.2 DMF Matching Process

```
┌──────────────────────────────────────────────────────────────────┐
│                   DMF MATCHING PROCESS                            │
├──────────────────────────────────────────────────────────────────┤
│                                                                    │
│  1. OBTAIN DEATH DATA                                             │
│     ├── Social Security DMF (limited access post-2011)            │
│     ├── LexisNexis                                                │
│     ├── Informatica (RELX)                                        │
│     ├── State Vital Records                                       │
│     └── Other third-party death data providers                    │
│                                                                    │
│  2. MATCHING ENGINE                                               │
│     ├── Match on: SSN + Name + DOB                                │
│     ├── Fuzzy matching for name variations                        │
│     ├── Confidence scoring                                        │
│     ├── Threshold-based classification:                           │
│     │   ├── HIGH CONFIDENCE: SSN + Name + DOB all match          │
│     │   ├── MEDIUM: SSN + partial name match                     │
│     │   └── LOW: Name + DOB match only                           │
│     └── False positive filtering                                  │
│                                                                    │
│  3. MATCH REVIEW                                                  │
│     ├── Auto-confirm high confidence matches                     │
│     ├── Manual review of medium/low confidence                    │
│     ├── Additional validation (address, policy history)           │
│     └── Confirmed matches create proactive claim records          │
│                                                                    │
│  4. BENEFICIARY SEARCH                                            │
│     ├── Last known address from policy records                    │
│     ├── Insurance company records                                 │
│     ├── LexisNexis / Accurint searches                           │
│     ├── Public records databases                                  │
│     ├── Skip tracing services                                     │
│     ├── Published obituary search                                 │
│     └── Agent of record contact                                   │
│                                                                    │
│  5. BENEFICIARY NOTIFICATION                                      │
│     ├── Mail notification to last known address                   │
│     ├── Certified mail (return receipt requested)                 │
│     ├── Follow-up attempts (varies by state regulation)           │
│     └── Document all contact attempts                             │
│                                                                    │
│  6. ESCHEATMENT (if beneficiary not located)                      │
│     ├── Hold period (varies by state, typically 3-5 years)       │
│     ├── Report to state unclaimed property division               │
│     ├── Transfer funds to state                                   │
│     └── Maintain records for beneficiary claim against state      │
│                                                                    │
└──────────────────────────────────────────────────────────────────┘
```

### 7.3 Architectural Implications

- **Batch Processing**: DMF matching is typically a batch process (daily/weekly/monthly)
- **High Volume**: Millions of in-force records matched against millions of death records
- **Data Quality**: Name/SSN/DOB matching requires sophisticated algorithms
- **Audit Trail**: Every match, review, and contact attempt must be documented
- **Reporting**: Regulators require detailed reports on DMF matching activities
- **Performance**: Matching engine must handle large datasets efficiently
- **Integration**: Requires feed from PAS (in-force file) and death data providers

---

## 8. Duplicate Detection

### 8.1 Why Duplicates Occur

- Same death reported by multiple beneficiaries
- Same death reported through multiple channels (phone + web)
- DMF match creates record after beneficiary already filed
- Multiple policies for same insured trigger separate claims
- Re-submission after initial submission deemed incomplete

### 8.2 Detection Strategies

```
DUPLICATE DETECTION RULES:
1. EXACT MATCH:
   - Same policy number + same date of death = DEFINITE DUPLICATE
   
2. PROBABLE MATCH:
   - Same insured SSN + date of death within 1 day = PROBABLE DUPLICATE
   - Same insured name (fuzzy) + DOB + date of death = PROBABLE DUPLICATE
   
3. RELATED CLAIM:
   - Different policy number + same insured SSN + same date of death
     = RELATED CLAIM (multiple policies, not duplicate)
   - Flag for consolidated processing

ACTIONS:
  DEFINITE DUPLICATE → Auto-merge (add new claimant info to existing claim)
  PROBABLE DUPLICATE → Queue for manual review
  RELATED CLAIM → Link claims for coordinated processing
```

---

## 9. FNOL Integration Architecture

### 9.1 Integration Points

```
┌────────────────────────────────────────────────────────────────────────┐
│                      FNOL INTEGRATION MAP                              │
├────────────────────────────────────────────────────────────────────────┤
│                                                                        │
│  INBOUND INTEGRATIONS                                                 │
│  ├── Policy Administration System (PAS)                               │
│  │   ├── Policy status and coverage verification                     │
│  │   ├── Beneficiary designation retrieval                           │
│  │   ├── Policy history (lapses, reinstatements, conversions)        │
│  │   └── Rider and endorsement details                               │
│  │                                                                    │
│  ├── Customer Relationship Management (CRM)                          │
│  │   ├── Customer contact information                                │
│  │   ├── Previous interactions and service history                   │
│  │   └── Agent/advisor relationship                                  │
│  │                                                                    │
│  ├── Death Verification Services                                     │
│  │   ├── DMF / SSDMF                                                 │
│  │   ├── LexisNexis mortality data                                   │
│  │   └── State vital records (emerging)                               │
│  │                                                                    │
│  ├── Identity Verification Services                                   │
│  │   ├── LexisNexis / Accurint                                       │
│  │   ├── Knowledge-Based Authentication (KBA)                        │
│  │   └── ID document verification (Jumio, Onfido)                    │
│  │                                                                    │
│  └── Fraud Detection Services                                        │
│      ├── Internal fraud scoring model                                │
│      ├── SIU database (prior investigations)                         │
│      └── Industry databases (NICB, CLUE for life)                    │
│                                                                        │
│  OUTBOUND INTEGRATIONS                                                │
│  ├── Document Management System                                      │
│  │   └── Store received documents, create claim folder               │
│  │                                                                    │
│  ├── Workflow / BPM Engine                                           │
│  │   └── Initiate claims workflow instance                           │
│  │                                                                    │
│  ├── Correspondence System                                           │
│  │   ├── Acknowledgment letter/email                                 │
│  │   └── Document request letter                                     │
│  │                                                                    │
│  ├── Notification Services                                           │
│  │   ├── Email/SMS to claimant                                       │
│  │   ├── Internal notifications (examiner, manager)                  │
│  │   └── Reinsurance notification (if threshold met)                 │
│  │                                                                    │
│  └── Analytics / Data Warehouse                                      │
│      └── FNOL event for reporting and analytics                      │
│                                                                        │
└────────────────────────────────────────────────────────────────────────┘
```

### 9.2 API Design for FNOL

```yaml
# FNOL API Specification (OpenAPI excerpt)
paths:
  /claims/fnol:
    post:
      summary: Submit First Notice of Loss
      operationId: submitFNOL
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/FNOLSubmission'
      responses:
        '201':
          description: FNOL successfully created
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/FNOLResponse'
        '400':
          description: Validation error
        '409':
          description: Duplicate claim detected

  /claims/fnol/{fnolId}:
    get:
      summary: Retrieve FNOL status
    put:
      summary: Update FNOL with additional information
    
  /claims/fnol/{fnolId}/documents:
    post:
      summary: Upload document for FNOL
      requestBody:
        content:
          multipart/form-data:
            schema:
              type: object
              properties:
                documentType:
                  type: string
                  enum: [DEATH_CERTIFICATE, CLAIM_FORM, APS, POLICE_REPORT, ...]
                file:
                  type: string
                  format: binary

components:
  schemas:
    FNOLSubmission:
      type: object
      required:
        - claimant
        - insured
        - lossInformation
      properties:
        claimant:
          $ref: '#/components/schemas/Claimant'
        insured:
          $ref: '#/components/schemas/InsuredPerson'
        lossInformation:
          $ref: '#/components/schemas/LossInformation'
        policyNumber:
          type: string
        channel:
          type: string
          enum: [PHONE, WEB, MOBILE, MAIL, FAX, THIRD_PARTY]
          
    FNOLResponse:
      type: object
      properties:
        claimNumber:
          type: string
        fnolId:
          type: string
        status:
          type: string
        requiredDocuments:
          type: array
          items:
            $ref: '#/components/schemas/RequiredDocument'
        assignedExaminer:
          type: string
        estimatedProcessingTime:
          type: string
        trackingUrl:
          type: string
```

---

## 10. FNOL Quality Metrics

| Metric | Definition | Target |
|---|---|---|
| **FNOL Completion Rate** | % of FNOL submissions that include all minimum required data | >90% |
| **Average FNOL Duration** | Time to complete FNOL intake | <15 min (phone), <20 min (web) |
| **Policy Match Rate** | % of FNOLs that match to a valid policy at intake | >95% |
| **Document Upload Rate at FNOL** | % of FNOLs with at least one document uploaded at intake | >40% (web/mobile) |
| **Duplicate Detection Rate** | % of duplicate submissions caught automatically | >95% |
| **FNOL Abandonment Rate** | % of web/mobile FNOLs started but not completed | <25% |
| **Channel Distribution** | % of FNOLs by channel | Track trend toward digital |
| **Auto-Triage Accuracy** | % of auto-triage decisions validated as correct | >90% |
| **Time to Acknowledgment** | Time from FNOL to acknowledgment sent to claimant | <24 hours |
| **First Contact Resolution** | % of simple claims paid at first contact | 5–15% (stretch goal) |

---

## 11. Architectural Patterns for FNOL

### 11.1 Event-Driven FNOL Architecture

```
Channel      │    API Gateway    │    Event Bus    │    Consumers
─────────────┼───────────────────┼─────────────────┼──────────────────
             │                   │                 │
Phone ──────▶│                   │  FNOL_RECEIVED  │──▶ Claim Creator
             │  POST /fnol  ────▶│  ──────────────▶│──▶ Policy Verifier
Web ────────▶│                   │                 │──▶ Document Tracker
             │  Validation   ────│  POLICY_        │──▶ Triage Engine
Mobile ─────▶│  Layer            │  VERIFIED       │──▶ Notification Svc
             │                   │  ──────────────▶│──▶ Analytics Sink
Mail/IDP ───▶│  Auth Layer  ────│                 │──▶ Fraud Scorer
             │                   │  CLAIM_TRIAGED  │──▶ Reinsurance Notifier
3rd Party ──▶│  Rate Limiting   │  ──────────────▶│──▶ Audit Logger
             │                   │                 │
```

### 11.2 Key Architectural Decisions

| Decision | Options | Recommendation |
|---|---|---|
| **Synchronous vs. Async FNOL** | Sync (immediate response) vs. Async (queue + callback) | Sync for web/phone (immediate claim number), Async for batch/mail |
| **FNOL as Separate Service** | Dedicated FNOL microservice vs. part of claims service | Separate service for scalability and independent deployment |
| **Event Sourcing** | Store FNOL as events vs. mutable record | Event sourcing recommended for full audit trail |
| **Policy Lookup** | Real-time API vs. cached policy data | Real-time API with cache for performance |
| **Document Storage** | Claims system DB vs. dedicated DMS | Dedicated DMS with metadata in claims DB |
| **Triage Engine** | Rules engine vs. ML model vs. hybrid | Hybrid: rules for deterministic logic, ML for scoring |

---

## 12. Summary

The FNOL process is the critical entry point for every life insurance claim. A well-architected FNOL system must:

1. **Accept claims from all channels** with a unified backend
2. **Validate and enrich data** in real-time from policy administration and external sources
3. **Generate dynamic document checklists** based on claim characteristics
4. **Intelligently triage and route** claims to the appropriate handler
5. **Detect duplicates** and related claims
6. **Support proactive claims** through DMF matching
7. **Provide immediate acknowledgment** and status tracking
8. **Capture comprehensive audit trail** from the very first moment
9. **Comply with state-specific** timing and notification requirements
10. **Deliver a compassionate experience** to grieving beneficiaries

---

*Previous: [Article 1: Domain Overview & Taxonomy](01-domain-overview-and-taxonomy.md)*
*Next: [Article 3: Claims Adjudication & Decision Engine](03-claims-adjudication-decision-engine.md)*
