# Chapter 5: New Business & Application Processing in Annuities

## A Comprehensive Reference for Solution Architects

---

## Table of Contents

1. [Overview & Industry Context](#1-overview--industry-context)
2. [Application Intake Channels](#2-application-intake-channels)
3. [Application Data Requirements](#3-application-data-requirements)
4. [Suitability & Best Interest Review](#4-suitability--best-interest-review)
5. [Anti-Money Laundering (AML/KYC)](#5-anti-money-laundering-amlkyc)
6. [NIGO (Not In Good Order) Processing](#6-nigo-not-in-good-order-processing)
7. [Underwriting for Annuities](#7-underwriting-for-annuities)
8. [Premium Processing](#8-premium-processing)
9. [Policy Issue Process](#9-policy-issue-process)
10. [Replacement Processing](#10-replacement-processing)
11. [1035 Exchange Intake](#11-1035-exchange-intake)
12. [Pending Case Management](#12-pending-case-management)
13. [Broker-Dealer Integration](#13-broker-dealer-integration)
14. [Straight-Through Processing (STP)](#14-straight-through-processing-stp)
15. [System Architecture for New Business](#15-system-architecture-for-new-business)
16. [Data Models & Schema Patterns](#16-data-models--schema-patterns)
17. [Regulatory & Compliance Cross-Reference](#17-regulatory--compliance-cross-reference)
18. [SLA Targets & Operational Metrics](#18-sla-targets--operational-metrics)
19. [Glossary](#19-glossary)

---

## 1. Overview & Industry Context

### 1.1 The New Business Lifecycle

New business processing in the annuity domain encompasses every step from the moment a prospective policyholder expresses intent to purchase an annuity contract through to the point where the contract is issued, funded, and placed in-force on the administration system. This lifecycle is among the most complex in all of insurance, because annuities sit at the intersection of insurance regulation, securities law, tax law, and retirement planning.

A typical new business lifecycle proceeds through the following macro-stages:

```
┌─────────────┐    ┌─────────────┐    ┌──────────────┐    ┌──────────────┐
│  Application │───▶│  Compliance  │───▶│  Underwriting │───▶│   Premium    │
│    Intake    │    │   & Review   │    │  & Approval   │    │  Processing  │
└─────────────┘    └─────────────┘    └──────────────┘    └──────────────┘
                                                                  │
┌─────────────┐    ┌─────────────┐    ┌──────────────┐           │
│   In-Force   │◀──│   Policy     │◀──│   Contract    │◀──────────┘
│  Management  │    │   Delivery   │    │  Generation   │
└─────────────┘    └─────────────┘    └──────────────┘
```

### 1.2 Scale & Volume Considerations

A mid-to-large annuity carrier typically processes 50,000–200,000 new applications per year, with significant seasonal variation (spikes during Q4 and during tax season). Peak-day volumes can be 3–5x the daily average. The system architecture must accommodate:

- **Burst capacity**: Handling 3,000+ applications in a single day during peak periods
- **Multi-channel intake**: Paper, electronic, API-driven, call center, and DTCC submissions simultaneously
- **Regulatory variability**: 50+ state jurisdictions, each with unique requirements
- **Product complexity**: 20–100 active products on the shelf, each with distinct data requirements
- **Integration breadth**: 200+ broker-dealer firms, dozens of AML/KYC vendors, DTCC, state regulators

### 1.3 Key Performance Indicators

| Metric | Industry Benchmark | Best-in-Class |
|---|---|---|
| Application-to-issue cycle time | 7–14 business days | 1–3 business days |
| NIGO rate | 30–45% | 10–15% |
| Straight-through processing rate | 15–25% | 50–70% |
| First-touch resolution rate | 40–55% | 70–85% |
| Case abandonment rate | 8–15% | 3–5% |
| Cost per application processed | $150–$300 | $50–$100 |

### 1.4 Regulatory Framework Overview

Annuity new business processing is governed by an overlapping patchwork of regulations:

- **State insurance departments**: Product approval, form filing, replacement regulations, suitability
- **SEC / FINRA**: Registration (variable annuities), Reg BI, supervisory obligations
- **IRS**: Tax-qualified plan rules, 1035 exchange requirements, contribution limits
- **FinCEN / BSA**: AML/KYC, SAR reporting, CTR filing
- **NAIC Model Regulations**: Suitability (#275), Replacement (#613), Privacy
- **DOL**: Fiduciary rules for ERISA-qualified plans (when applicable)

---

## 2. Application Intake Channels

### 2.1 Paper Applications (Mailroom Processing)

#### 2.1.1 Physical Mailroom Operations

Paper applications still account for 20–40% of submissions at many carriers, particularly for Fixed and Fixed Indexed Annuity products where the agent demographic skews older.

**Inbound Mail Flow:**

```
┌──────────┐    ┌────────────┐    ┌───────────┐    ┌───────────┐
│  USPS /   │───▶│  Mailroom   │───▶│  Scanning  │───▶│  Quality   │
│  FedEx    │    │  Sort/Open  │    │  Station   │    │  Control   │
└──────────┘    └────────────┘    └───────────┘    └───────────┘
                                                         │
┌──────────┐    ┌────────────┐    ┌───────────┐         │
│  Work     │◀──│  Data       │◀──│  OCR/ICR   │◀────────┘
│  Queue    │    │  Validation │    │  Engine    │
└──────────┘    └────────────┘    └───────────┘
```

**Step-by-step process:**

1. **Receipt & Logging**: Mail arrives at a centralized PO Box or physical address. A mail manifest is created with date/time stamp, carrier tracking number, and preliminary classification (new business vs. service request vs. claims).
2. **Opening & Sorting**: Trained mailroom staff open envelopes, separate documents by type (application form, check, supplemental forms, replacement paperwork, suitability questionnaire), and apply batch control numbers.
3. **Prep for Scanning**: Documents are de-stapled, unfolded, repaired if torn, and placed in scanning order. Separator sheets with barcodes are inserted between document types. Each batch gets a batch header sheet.
4. **High-Speed Scanning**: Production scanners (Kodak i5850, Canon DR-G2140, Fujitsu fi-7900) capture images at 150+ pages per minute. Both front and back are scanned (duplex). Target resolution: 300 DPI for text, 200 DPI for forms with checkboxes.
5. **Image Quality Assurance**: Automated quality checks verify image clarity, skew correction, blank page removal, and completeness. Failed images are re-scanned.
6. **Document Classification**: AI/ML models or rules-based classifiers identify document types — application page 1, application page 2, suitability form, replacement form, check image, driver's license, etc.

**Technology Stack for Mailroom:**

| Component | Typical Vendors/Products |
|---|---|
| Production Scanners | Kodak Alaris, Canon, Fujitsu |
| Capture Platform | Kofax Capture, OpenText Captiva, ABBYY FlexiCapture |
| OCR/ICR Engine | ABBYY FineReader Engine, Kofax OmniPage, Google Document AI |
| Document Classification | Kofax Transformation, ABBYY Vantage, custom ML models |
| Image Repository | IBM FileNet, OpenText Documentum, Hyland OnBase |
| Workflow Engine | Pega, Appian, IBM BPM, custom BPM |

#### 2.1.2 OCR/ICR Data Extraction

Optical Character Recognition (OCR) handles printed text; Intelligent Character Recognition (ICR) handles handwritten text, which is common on paper annuity applications.

**Data Extraction Pipeline:**

```
┌──────────┐    ┌──────────────┐    ┌──────────────┐    ┌──────────────┐
│  Scanned  │───▶│  Pre-Process  │───▶│  Zone/Field  │───▶│  Character   │
│  Image    │    │  (deskew,     │    │  Detection   │    │  Recognition │
│           │    │   denoise)    │    │              │    │  (OCR/ICR)   │
└──────────┘    └──────────────┘    └──────────────┘    └──────────────┘
                                                              │
┌──────────┐    ┌──────────────┐    ┌──────────────┐         │
│  Indexed  │◀──│  Human       │◀──│  Confidence   │◀────────┘
│  Data     │    │  Verification │    │  Scoring     │
│  Record   │    │  (key-from-  │    │  & Flagging   │
│           │    │   image)     │    │              │
└──────────┘    └──────────────┘    └──────────────┘
```

**Field-level extraction details:**

- **Name fields** (ICR): Confidence thresholds of 70–85% typical for handwritten names. Anything below threshold routes to human verification queue (key-from-image).
- **SSN/TIN fields**: High-value, high-risk fields. Dual-pass extraction with independent OCR engines. Mismatch triggers mandatory human review.
- **Date fields**: Complex due to format variations (MM/DD/YYYY vs. MM-DD-YY). Parser must handle multiple formats and validate logical consistency (e.g., date of birth results in age 0–120).
- **Address fields**: Post-extraction USPS CASS validation to standardize and verify addresses.
- **Checkbox/Bubble fields**: OMR (Optical Mark Recognition) for product selection, yes/no questions, beneficiary type selection.
- **Signature detection**: Presence/absence detection (not verification). Machine learning models detect whether a signature field is signed or blank.
- **Dollar amounts**: Currency OCR with cross-validation against MICR line (for checks) or written-out amounts.

**Confidence Scoring & Routing:**

| Confidence Level | Action |
|---|---|
| 95–100% | Auto-accept, no human review |
| 80–94% | Accept with post-processing audit sampling (5–10%) |
| 60–79% | Route to key-from-image verification queue |
| Below 60% | Flag for full manual data entry |

**Integration Points:**
- Output feeds into the New Business workflow engine via XML/JSON message
- Images stored in ECM (Enterprise Content Management) with metadata linking to the case
- Extraction audit trail preserved for compliance

#### 2.1.3 Data Flow for Paper Applications

```
Paper App ──▶ Mailroom ──▶ Scan ──▶ OCR/ICR ──▶ Data Validation
    │                                                    │
    ▼                                                    ▼
  Check ──▶ Lockbox ──▶ MICR Read ──▶ Premium    Case Creation
    │                                Processing       │
    │                                    │             ▼
    └────────────────────────────────────┴──▶ NB Workflow Engine
                                                    │
                                              ┌─────┴──────┐
                                              ▼            ▼
                                          Suitability   AML/KYC
                                           Review       Screening
```

### 2.2 E-Applications

#### 2.2.1 Firelight (Insurance Technologies Corporation)

Firelight is the dominant e-application platform in the annuity industry, used by the majority of top-20 annuity carriers.

**Architecture Overview:**

```
┌───────────────────────────────────────────────────┐
│                    Firelight                       │
│  ┌──────────┐  ┌──────────┐  ┌──────────────┐    │
│  │  Agent    │  │  Form    │  │  Suitability  │    │
│  │  Portal   │  │  Engine  │  │  Module       │    │
│  └──────────┘  └──────────┘  └──────────────┘    │
│  ┌──────────┐  ┌──────────┐  ┌──────────────┐    │
│  │  E-Sig   │  │  Doc     │  │  Replacement  │    │
│  │  Module   │  │  Upload  │  │  Module       │    │
│  └──────────┘  └──────────┘  └──────────────┘    │
└───────────────────────────────────────────────────┘
         │              │              │
         ▼              ▼              ▼
    ┌──────────┐  ┌──────────┐  ┌──────────────┐
    │  Carrier  │  │  DTCC    │  │  Broker-     │
    │  NB API   │  │  ACORD   │  │  Dealer      │
    │           │  │  Gateway  │  │  Supervisory │
    └──────────┘  └──────────┘  └──────────────┘
```

**Key Integration Points:**

- **Inbound to Carrier**: Firelight submits completed application data via ACORD XML (typically ACORD Life 103 or TXLife standard) or proprietary JSON API to the carrier's new business intake service.
- **Product Rules**: Carrier publishes product rules, form definitions, and suitability questions to Firelight via configuration APIs or flat-file uploads. These govern which fields appear, validation rules, and conditional logic.
- **E-Signature**: Integrated e-signature (DocuSign, OneSpan) captures wet-equivalent signatures. Signature ceremony data (IP address, timestamp, authentication method) is transmitted alongside the application.
- **Real-time Validation**: Field-level validation occurs in real-time as the agent completes the application, dramatically reducing NIGO rates (typically 5–10% for e-apps vs. 30–45% for paper).
- **Document Upload**: Supporting documents (trust documents, entity formation papers, driver's license) can be uploaded and attached to the application.

**Data Flow:**

1. Agent logs into Firelight (SSO via SAML/OIDC, authenticated via broker-dealer or carrier credentials)
2. Agent selects product, enters applicant data, answers suitability questions
3. Firelight validates data in real-time against carrier-published product rules
4. If replacement is indicated, replacement comparison module activates
5. E-signature ceremony initiated (applicant signs on tablet/screen or receives email for remote signing)
6. Completed application package (data + images + signatures) submitted to carrier
7. Carrier intake service receives ACORD XML/JSON, validates, creates case in NB workflow
8. Acknowledgment returned to Firelight with carrier case number

**Technology Considerations:**

- Firelight is typically hosted as SaaS; carriers integrate via API
- ACORD TXLife XML is the dominant data standard but increasingly supplemented with JSON/REST
- Latency requirements: Carrier intake API should respond within 5 seconds for acknowledgment
- Payload sizes: 500KB–5MB typical (larger when document images are inline vs. referenced)

#### 2.2.2 iPipeline

iPipeline provides a competing e-application platform with strong presence in the independent agent/IMO (Insurance Marketing Organization) channel.

**Differentiating Features:**
- **iGO**: End-to-end e-application with embedded illustration generation
- **Resonant**: Distribution management and compensation platform
- **FormFire**: Employer-sponsored annuity enrollment

**Integration Pattern:**
- iPipeline typically uses ACORD XML for carrier submission
- Supports both synchronous (real-time validation) and asynchronous (batch) submission models
- Webhook-based status notification back to iPipeline from carrier

#### 2.2.3 DocuSign Integration

DocuSign serves both as a standalone e-signature platform and as an embedded component within e-application platforms.

**Standalone DocuSign Use Case:**
Some carriers allow agents to complete PDF-based applications in DocuSign, using DocuSign's form-filling and e-signature capabilities. The completed, signed document is then submitted to the carrier.

**Integration Architecture:**

```
Agent completes app in DocuSign
         │
         ▼
DocuSign Connect (webhook) ──▶ Carrier Integration Layer
         │                              │
         ▼                              ▼
  Signed PDF + Form Data        NB Intake Service
  (envelope complete event)          │
                                     ▼
                              OCR/Data Extraction
                              (if form data not structured)
                                     │
                                     ▼
                               Case Creation
```

**DocuSign Connect Configuration:**
- Events: `envelope-completed`, `recipient-completed`, `envelope-voided`
- Payload: Includes envelope metadata, recipient info, form field data (if PowerForms), and signed document URLs
- Authentication: HMAC signature validation on webhook payloads
- Retry policy: DocuSign retries failed deliveries for up to 24 hours

### 2.3 Broker-Dealer Submission

#### 2.3.1 Order Entry Integration

Large broker-dealers (wirehouses like Merrill Lynch, Morgan Stanley, UBS, Wells Fargo Advisors) have proprietary order entry systems that submit annuity applications directly to carriers.

**Typical Integration Pattern:**

```
┌─────────────────────────────────────┐
│       Broker-Dealer Platform        │
│  ┌──────────┐    ┌──────────────┐   │
│  │  Advisor  │───▶│  Supervisory │   │
│  │  Desktop  │    │  Review &    │   │
│  │  (Order   │    │  Approval    │   │
│  │   Entry)  │    │              │   │
│  └──────────┘    └──────────────┘   │
│                        │             │
│                        ▼             │
│                 ┌──────────────┐     │
│                 │  B/D Order   │     │
│                 │  Management  │     │
│                 │  System      │     │
│                 └──────────────┘     │
└─────────────────┬───────────────────┘
                  │
                  ▼ (ACORD XML / Proprietary API / DTCC)
         ┌──────────────────┐
         │  Carrier NB      │
         │  Intake Service  │
         └──────────────────┘
```

**Key Characteristics:**
- Pre-approved product shelf (only approved products can be submitted)
- Supervisory approval completed before submission to carrier (registered principal review for variable annuities)
- Commission grid and compensation already negotiated and codified
- Firm-level suitability overlay may apply additional restrictions beyond carrier and regulatory requirements
- NSCC/DTCC integration for standardized order submission

#### 2.3.2 DTCC / NSCC Application Entry

The Depository Trust & Clearing Corporation (DTCC), through its subsidiary National Securities Clearing Corporation (NSCC), provides standardized interfaces for annuity application submission via the **Insurance Processing Services (IPS)** platform.

**DTCC Services Relevant to New Business:**

| Service | Purpose |
|---|---|
| **Applications (APP)** | Standardized application data submission from distributor to carrier |
| **Commission & Compensation (C&C)** | Commission calculation and payment |
| **Financial Activity Reporting (FAR)** | Premium and financial transaction reporting |
| **Positions & Valuations (P&V)** | Contract positions and market values |
| **DTCC Insurance Profile Exchange (DIPE)** | Licensing and appointment verification |

**DTCC Application Submission Flow:**

1. Distributor submits application data via NSCC/DTCC in standardized ACORD-based format
2. DTCC validates message structure and routing
3. Carrier receives application data from DTCC feed (typically via SFTP or MQ-based connectivity)
4. Carrier processes through normal NB workflow
5. Status updates flow back through DTCC to distributor
6. Commission instructions flow through DTCC Commission & Compensation service

**Technical Integration:**
- **Connectivity**: DTCC provides several connectivity options — mainframe-to-mainframe (MQ), SFTP batch files, or web-based portal
- **Message Format**: ACORD Life XML standards, with DTCC-specific extensions
- **Processing Windows**: Batch processing with defined cutoff times; some services offer intra-day processing
- **STP Identifiers**: DTCC assigns unique identifiers (NSCC numbers) that link application, commission, and position records

### 2.4 Direct-to-Consumer Channel

#### 2.4.1 Online Application Portal

A growing but still small channel (5–10% of volume for most carriers). The applicant completes the application directly on the carrier's website or a digital platform.

**Architecture:**

```
┌──────────────────────────────────────────────┐
│            Consumer-Facing Web App            │
│  ┌────────┐  ┌────────┐  ┌───────────────┐   │
│  │ React/ │  │ Product │  │  Suitability   │   │
│  │ Angular│  │ Selector│  │  Questionnaire │   │
│  │ SPA    │  │        │  │               │   │
│  └────────┘  └────────┘  └───────────────┘   │
│  ┌────────┐  ┌────────┐  ┌───────────────┐   │
│  │ ID     │  │ E-Sign │  │  Payment       │   │
│  │ Verify │  │ Module │  │  (ACH/Wire)    │   │
│  └────────┘  └────────┘  └───────────────┘   │
└──────────────────┬───────────────────────────┘
                   │ REST API
                   ▼
          ┌──────────────────┐
          │  API Gateway      │
          │  (Rate Limiting,  │
          │   Auth, Logging)  │
          └────────┬─────────┘
                   │
          ┌────────┴─────────┐
          ▼                  ▼
  ┌──────────────┐   ┌──────────────┐
  │  Application  │   │  Identity    │
  │  Service      │   │  Verification│
  │  (Case CRUD)  │   │  Service     │
  └──────────────┘   └──────────────┘
```

**Identity Verification for D2C:**
- Knowledge-Based Authentication (KBA) via LexisNexis, TransUnion
- Document verification (upload driver's license, AI-based verification via Jumio, Onfido, Socure)
- Database verification (name/SSN/DOB/address match against credit bureau data)

**Unique Challenges:**
- No agent present to explain product features or gather suitability information
- Must capture suitability information directly from consumer with clear, plain-language questions
- Regulatory requirements around disclosure and illustration delivery must be handled electronically
- Abandonment rates are high (60–80%); must design for session persistence and resume capability

### 2.5 Call Center Applications

#### 2.5.1 Telephonic Application Process

Call center representatives (licensed agents) take applications over the phone. This channel is significant for direct-response marketing campaigns and for servicing existing customers purchasing additional annuities.

**Process Flow:**

1. **Caller authentication**: Verify identity (name, DOB, last 4 SSN, security questions)
2. **Needs analysis**: Scripted suitability questionnaire conducted verbally
3. **Product recommendation**: Based on suitability analysis, representative recommends product
4. **Application data capture**: Representative enters data into CRM/application system while on the call
5. **Disclosure delivery**: Required disclosures read verbally and/or emailed during the call
6. **Voice signature or e-signature**: Call is recorded (with consent); some states allow voice signature. Alternatively, e-signature link sent via email/SMS during the call.
7. **Premium arrangement**: ACH authorization captured or instructions for check/wire

**Technology Stack:**
- **CTI (Computer Telephony Integration)**: Genesys, Avaya, Amazon Connect
- **CRM**: Salesforce Financial Services Cloud, Microsoft Dynamics
- **Call Recording**: NICE, Verint (mandatory for compliance; recordings retained 5–7 years)
- **Screen Recording**: Optional but increasingly used for compliance evidence
- **Script Engine**: Guided selling scripts with branching logic based on responses

**Compliance Considerations:**
- All calls must be recorded and retained per state and FINRA requirements
- Telephonic disclosures must meet state-specific delivery requirements
- Some states have specific telephonic application statutes (e.g., telephonic replacement procedures)
- Two-party consent states require explicit recording consent at the start of the call

### 2.6 Channel Comparison Matrix

| Attribute | Paper | E-App (Firelight) | Broker-Dealer | D2C Online | Call Center | DTCC |
|---|---|---|---|---|---|---|
| **NIGO Rate** | 30–45% | 5–10% | 8–15% | 3–8% | 10–20% | 5–12% |
| **Avg Processing Time** | 10–15 days | 3–5 days | 3–7 days | 1–3 days | 5–7 days | 3–5 days |
| **STP Eligible** | Rarely | Often | Sometimes | Often | Sometimes | Sometimes |
| **Integration Complexity** | Low (scan/OCR) | Medium (API) | High (custom) | High (full stack) | Medium | Medium (DTCC std) |
| **Volume Share (industry avg)** | 25–35% | 30–40% | 15–25% | 3–8% | 5–10% | 10–20% |

---

## 3. Application Data Requirements

### 3.1 Owner Information

The contract owner is the person or entity with all rights under the annuity contract, including the right to make withdrawals, change beneficiaries (if revocable), and surrender the contract.

#### 3.1.1 Individual Owner

**Required Fields:**

| Field | Format | Validation Rules |
|---|---|---|
| First Name | Alpha + spaces, hyphens | 1–50 chars, no numeric |
| Middle Name/Initial | Alpha | 0–50 chars |
| Last Name | Alpha + spaces, hyphens | 1–50 chars, no numeric |
| Suffix | Enum (Jr, Sr, II, III, IV) | Optional |
| SSN/TIN | 9-digit numeric | Luhn-like validation, format XXX-XX-XXXX |
| Date of Birth | Date (MM/DD/YYYY) | Age 0–120; issue age within product limits |
| Gender | Enum (Male, Female, Non-binary) | Required for products with mortality-based benefits |
| Citizenship | Enum (US Citizen, Resident Alien, Non-Resident Alien) | Determines tax treatment and eligibility |
| Residential Address | Street, City, State, ZIP | USPS CASS validation; state determines tax jurisdiction |
| Mailing Address | Street, City, State, ZIP | Optional; defaults to residential if not provided |
| Phone Number | 10-digit + extension | At least one phone required |
| Email Address | Standard email format | Required for e-delivery; validated format |
| Driver's License / State ID | State + Number | Required for CIP/AML verification |
| Existing Customer Flag | Boolean | Cross-reference against policy admin system |

#### 3.1.2 Joint Owner

Joint ownership is permitted in most non-qualified annuity contracts. Both owners have equal rights.

**Additional Requirements for Joint Ownership:**
- All fields from individual owner required for second owner
- Joint ownership type: Joint Tenants with Rights of Survivorship (JTWROS), Tenants in Common (TIC), Community Property
- Not permitted on qualified contracts (IRA, 401k rollovers)
- Some products restrict joint ownership (e.g., certain living benefit riders)
- Both owners must meet age/state eligibility requirements
- Both owners must pass AML/KYC screening independently

#### 3.1.3 Trust Owner

Trust-owned annuities have complex data requirements because the trust is the legal owner, but natural persons must be identified for tax and AML purposes.

**Required Trust Information:**

| Field | Description |
|---|---|
| Trust Name | Full legal name of trust |
| Trust Date | Date the trust was established |
| Trust TIN | EIN if the trust has its own tax ID; otherwise grantor's SSN |
| Trust Type | Revocable Living Trust, Irrevocable Trust, Special Needs Trust, Charitable Trust, etc. |
| Trustee Name(s) | Individual(s) or entity serving as trustee; all trustees must be identified |
| Grantor/Settlor | Person who established the trust |
| Beneficiaries of Trust | Natural person beneficiaries (for "look-through" rules under IRC §72(s)) |
| Trust Document | Copy required; reviewed for annuity purchase authority and beneficiary designations |

**Architectural Consideration:**
The data model must support a polymorphic owner entity that can be an Individual, Joint (pair of Individuals), Trust, or Entity, each with distinct required attributes. A common pattern:

```json
{
  "owner": {
    "ownerType": "TRUST",
    "trust": {
      "trustName": "Smith Family Revocable Trust",
      "trustDate": "2015-03-15",
      "trustTIN": "XX-XXXXXXX",
      "trustType": "REVOCABLE_LIVING",
      "trustees": [
        {
          "individual": { "firstName": "John", "lastName": "Smith", "ssn": "..." },
          "trusteeType": "PRIMARY"
        }
      ],
      "grantors": [
        { "firstName": "John", "lastName": "Smith", "ssn": "..." }
      ]
    }
  }
}
```

#### 3.1.4 Entity Owner

Corporations, partnerships, LLCs, and other legal entities can own non-qualified annuity contracts, though the tax treatment is generally unfavorable (no tax deferral for non-natural persons under IRC §72(u) unless exceptions apply).

**Required Entity Information:**

| Field | Description |
|---|---|
| Entity Legal Name | Full registered name |
| Entity Type | Corporation, S-Corp, LLC, Partnership, Non-Profit, Government Entity |
| State of Formation | State where entity was organized |
| EIN | Employer Identification Number |
| Date of Formation | Date entity was established |
| Authorized Signer(s) | Individuals authorized to act on behalf of entity |
| Beneficial Owners | All individuals owning 25%+ (CDD Rule requirement) |
| Controlling Person | Individual with significant management responsibility |
| Formation Documents | Articles of incorporation, operating agreement, or similar |
| Board Resolution | Corporate resolution authorizing annuity purchase (if applicable) |

### 3.2 Annuitant Information

The annuitant is the person whose life is the measuring life for the annuity contract. The annuitant may or may not be the same as the owner.

**Required Fields:**
- Same demographic fields as owner (name, SSN, DOB, gender, address)
- Relationship to owner (Self, Spouse, Child, Other)
- If annuitant ≠ owner, insurable interest documentation may be required
- Joint annuitant option (for joint life payout options)
- Maximum/minimum issue age validation per product (typically 0–90, varies by product and rider)

### 3.3 Beneficiary Designations

Beneficiary designations determine who receives the death benefit proceeds upon the death of the owner (or annuitant, depending on contract terms).

#### 3.3.1 Beneficiary Types

**Primary Beneficiaries:**
- Receive proceeds first; must be exhausted before contingent beneficiaries receive anything
- Multiple primary beneficiaries share according to specified percentages (must total 100%)

**Contingent Beneficiaries:**
- Receive proceeds only if all primary beneficiaries predecease the owner/annuitant
- Also must total 100% among contingent beneficiaries

**Per Stirpes vs. Per Capita:**
- **Per Stirpes**: If a beneficiary predeceases, their share passes to their descendants
- **Per Capita**: If a beneficiary predeceases, their share is redistributed among surviving beneficiaries

**Beneficiary Data Model:**

```json
{
  "beneficiaries": [
    {
      "designationType": "PRIMARY",
      "beneficiaryType": "INDIVIDUAL",
      "individual": {
        "firstName": "Jane",
        "lastName": "Smith",
        "ssn": "XXX-XX-XXXX",
        "dateOfBirth": "1985-06-15",
        "relationship": "SPOUSE"
      },
      "percentage": 100.00,
      "distributionMethod": "PER_STIRPES",
      "irrevocable": false
    },
    {
      "designationType": "CONTINGENT",
      "beneficiaryType": "TRUST",
      "trust": {
        "trustName": "Smith Children's Trust",
        "trustTIN": "XX-XXXXXXX",
        "trustDate": "2018-01-01"
      },
      "percentage": 100.00,
      "distributionMethod": null,
      "irrevocable": false
    }
  ]
}
```

**Validation Rules:**
- Primary beneficiary percentages must sum to exactly 100%
- Contingent beneficiary percentages must sum to exactly 100%
- If beneficiary is a minor, custodial information under UTMA/UGMA may be required
- If beneficiary is a trust, trust name and TIN are mandatory
- If beneficiary is an entity (charity, estate), entity details required
- Irrevocable beneficiary designation requires beneficiary's consent for any future changes
- Spousal consent may be required for qualified contracts (ERISA/REA)

### 3.4 Agent/Producer Information

**Required Fields:**

| Field | Description | Validation |
|---|---|---|
| Producer Name | Licensed agent/representative | Match against appointment records |
| Producer NPN | National Producer Number | NIPR database lookup |
| Producer SSN/TIN | For commission payment | IRS W-9 on file |
| State License Number | State-specific license | Active license in contract state |
| Appointment Status | Carrier appointment | Must be active and in good standing |
| B/D Registration | FINRA CRD for variable products | Active registration required for VA/RILA |
| Writing Agent vs Servicing Agent | Commission split indicator | Determines compensation |
| Split Percentages | If multiple producers | Must total 100% |
| Agency/IMO Hierarchy | Upline hierarchy for override commissions | Match against distribution hierarchy |
| E&O Coverage | Errors & Omissions insurance | May require verification for certain products |

**Producer Validation Workflow:**

```
Producer Data Received
        │
        ▼
  ┌─────────────┐     ┌──────────────┐     ┌──────────────┐
  │  NPN Lookup  │────▶│  State License│────▶│  Appointment │
  │  (NIPR API)  │     │  Verification │     │  Verification │
  └─────────────┘     └──────────────┘     └──────────────┘
        │                    │                      │
        ▼                    ▼                      ▼
  Valid NPN?           Licensed in         Appointed with
  (Yes/No)             contract state?     this carrier?
        │                    │                      │
        └────────────────────┴──────────────────────┘
                             │
                    ┌────────┴────────┐
                    ▼                 ▼
              All Pass:          Any Fail:
              Continue           NIGO - Producer
                                 Licensing Issue
```

### 3.5 Product Selection Data

**Required Product Information:**
- Product code / product name
- Product type (Fixed, Fixed Indexed, Variable, RILA, Immediate, DIA)
- Contract type: Non-Qualified, Traditional IRA, Roth IRA, SEP IRA, SIMPLE IRA, 403(b), 401(a), 457(b), inherited IRA
- Optional rider selections (GLWB, GMDB, GMIB, GMAB, enhanced death benefit, nursing home waiver, return of premium)
- Rider election combinations must be validated against product rules (some riders are mutually exclusive)
- Annuitization option pre-selection (Life Only, Life with Period Certain, Joint Life, etc.) — typically selected later but may be captured at application
- Payout start date (for immediate annuities and DIAs)

### 3.6 Premium Details

| Field | Description |
|---|---|
| Initial Premium Amount | Dollar amount of first premium payment |
| Premium Type | Single Premium, Flexible Premium, Scheduled Premium |
| Payment Method | Check, Wire, ACH, 1035 Exchange, Rollover, Transfer |
| Source of Funds | Savings, Investment Proceeds, Inheritance, Retirement Plan Distribution, Insurance Proceeds, Sale of Property, Gift, Other |
| Minimum/Maximum Premium | Validate against product rules (e.g., $10,000 min, $1M max without home office approval) |
| Subsequent Premium Schedule | For flexible premium products: amount, frequency, payment method |
| Large Case Threshold | Premium amounts above threshold (often $1M or $5M) trigger additional underwriting |

### 3.7 Investment Allocation

For Variable Annuities, Fixed Indexed Annuities, and RILAs, the applicant must specify how the premium is allocated among investment options.

**Variable Annuity Allocation:**

```json
{
  "allocations": [
    { "fundCode": "EQILGC", "fundName": "Large Cap Growth", "percentage": 30.00 },
    { "fundCode": "EQIBAL", "fundName": "Balanced Fund", "percentage": 25.00 },
    { "fundCode": "EQIBND", "fundName": "Bond Fund", "percentage": 20.00 },
    { "fundCode": "EQIINT", "fundName": "International Fund", "percentage": 15.00 },
    { "fundCode": "FIXACC", "fundName": "Fixed Account", "percentage": 10.00 }
  ],
  "totalPercentage": 100.00,
  "dollarCostAveragingElection": {
    "elected": true,
    "sourceAccount": "FIXACC",
    "targetAllocations": [
      { "fundCode": "EQILGC", "percentage": 40.00 },
      { "fundCode": "EQIBAL", "percentage": 30.00 },
      { "fundCode": "EQIBND", "percentage": 30.00 }
    ],
    "frequency": "MONTHLY",
    "duration": 12
  }
}
```

**Validation Rules for Allocations:**
- All percentages must sum to exactly 100%
- Each allocation must meet minimum percentage (typically 1% or 5%)
- If a living benefit rider is elected, allocation models may be restricted (e.g., must choose from approved asset allocation models)
- If Dollar Cost Averaging (DCA) is elected, source and target accounts must be validated
- Fixed account allocation may have maximums (e.g., no more than 25% in fixed account with certain riders)

**Fixed Indexed Annuity Allocation:**

```json
{
  "allocations": [
    { "strategyCode": "SP500_PTP_CAP", "strategyName": "S&P 500 PTP with Cap", "percentage": 40.00 },
    { "strategyCode": "SP500_PTP_PR", "strategyName": "S&P 500 PTP with Participation Rate", "percentage": 30.00 },
    { "strategyCode": "FIXED_DECLARED", "strategyName": "Fixed Declared Rate", "percentage": 30.00 }
  ]
}
```

### 3.8 Replacement Information

If the applicant is replacing (surrendering or exchanging) an existing annuity or life insurance contract, additional data is required:

**Replacement Questionnaire Fields:**
- Is this application a replacement of existing life insurance or annuity? (Yes/No)
- Existing contract carrier name
- Existing contract/policy number
- Existing contract type (Life, Annuity — Fixed, Variable, etc.)
- Existing contract cash value / account value
- Existing contract surrender charges remaining (amount and schedule)
- Existing contract death benefit
- Existing contract living benefit (if any)
- Reason for replacement (free text or structured reasons)
- Agent's comparison of existing vs. proposed contract features

### 3.9 Suitability Data

Suitability data collection requirements have expanded significantly under Reg BI and the NAIC Model #275 updates.

**Required Suitability Information:**

| Category | Fields |
|---|---|
| **Financial Profile** | Annual household income, liquid net worth, total net worth, tax bracket, outstanding liabilities |
| **Investment Experience** | Years of investment experience; experience with: stocks, bonds, mutual funds, annuities, options, alternatives |
| **Investment Objectives** | Growth, Income, Capital Preservation, Tax Deferral, Death Benefit Protection, Lifetime Income |
| **Risk Tolerance** | Conservative, Moderately Conservative, Moderate, Moderately Aggressive, Aggressive |
| **Time Horizon** | Short-term (<3 years), Medium (3–10 years), Long-term (>10 years) |
| **Liquidity Needs** | Percentage of liquid assets this annuity represents, anticipated liquidity needs in next 5–10 years |
| **Insurance Needs** | Existing insurance coverage, life insurance in force, existing annuities, long-term care coverage |
| **Tax Status** | Filing status, state of residence for tax purposes |
| **Source of Funds** | Where the money is coming from (see premium details) |
| **Intended Use** | Retirement income, accumulation, wealth transfer, other |
| **Existing Products Held** | Number and type of existing annuity/life insurance products |
| **Special Circumstances** | Legal proceedings, bankruptcy, financial hardship |

---

## 4. Suitability & Best Interest Review

### 4.1 Regulation Best Interest (Reg BI)

Reg BI, adopted by the SEC in June 2019, establishes a "best interest" standard of conduct for broker-dealers and their associated persons when making recommendations of securities (including variable annuities and RILAs) to retail customers.

#### 4.1.1 Four Component Obligations

**1. Disclosure Obligation:**
- File and deliver Form CRS (Customer Relationship Summary)
- Provide disclosure of material facts about the recommendation, including fees, costs, type and scope of services, conflicts of interest
- System must track delivery and acknowledgment of Form CRS
- Timing: At or before the time of recommendation, and at point of sale

**2. Care Obligation:**
- Exercise reasonable diligence, care, and skill when making a recommendation
- Understand the potential risks, rewards, and costs of the recommendation
- Have a reasonable basis to believe the recommendation is in the retail customer's best interest based on the customer's investment profile
- Have a reasonable basis to believe that a series of recommended transactions is not excessive

**System Implementation:**

```
┌──────────────────────────────────────────────┐
│           Suitability Rules Engine            │
│                                              │
│  ┌───────────┐  ┌───────────┐  ┌─────────┐  │
│  │ Customer  │  │ Product   │  │ Compare │  │
│  │ Profile   │  │ Attributes│  │ & Score │  │
│  │ Scoring   │  │ Scoring   │  │         │  │
│  └─────┬─────┘  └─────┬─────┘  └────┬────┘  │
│        │              │              │        │
│        └──────────────┴──────────────┘        │
│                       │                       │
│                       ▼                       │
│              ┌────────────────┐               │
│              │   Best Interest │               │
│              │   Determination │               │
│              │   (Pass/Fail/   │               │
│              │    Review)      │               │
│              └────────────────┘               │
└──────────────────────────────────────────────┘
```

**3. Conflict of Interest Obligation:**
- Establish, maintain, and enforce policies and procedures to identify and at minimum disclose, or mitigate or eliminate, conflicts of interest
- Must address conflicts arising from compensation practices (differential compensation, sales contests, quotas, non-cash compensation)
- System must track agent compensation differential between recommended product and alternatives

**4. Compliance Obligation:**
- Establish, maintain, and enforce policies and procedures reasonably designed to achieve compliance with Reg BI
- Includes training, supervision, and documentation
- System must provide audit trail of compliance activities

#### 4.1.2 System Requirements for Reg BI

| Requirement | Implementation |
|---|---|
| Form CRS delivery tracking | Document management + delivery confirmation workflow |
| Customer investment profile capture | Structured suitability questionnaire in application intake |
| Reasonable basis analysis | Rules engine scoring product fit against customer profile |
| Cost comparison | Product comparison engine with fee/cost analysis |
| Conflict of interest disclosure | Compensation differential calculation and disclosure generation |
| Documentation & record-keeping | Audit trail of all suitability analysis, recommendations, and disclosures |
| Supervisor review workflow | Escalation queue for flagged recommendations |

### 4.2 NAIC Model Regulation #275

The NAIC Suitability in Annuity Transactions Model Regulation (#275), substantially revised in 2020, establishes a best interest standard for all annuity recommendations (not just securities). This applies to fixed and fixed indexed annuities that are not subject to SEC/FINRA jurisdiction.

#### 4.2.1 Key Requirements

**Producer Obligations:**
- Act in the consumer's best interest at the time of recommendation without placing the producer's or insurer's financial interest ahead of the consumer's interest
- Comparable care, skill, and diligence standard
- Must consider reasonably available alternatives

**Safe Harbor Provisions:**
- Compliance with comparable standards (e.g., SEC Reg BI) provides a safe harbor
- Carrier must establish and maintain a supervision system
- Carrier must perform suitability review if the producer did not make a recommendation

**System Requirements:**
- Suitability questionnaire must capture all NAIC-required data points
- Automated scoring must evaluate consumer profile against product characteristics
- Supervisor review queue for flagged transactions
- Record retention for duration of contract plus applicable statute of limitations

#### 4.2.2 State Adoption Status

The model regulation must be adopted by each state individually. As of 2026, most states have adopted the 2020 version, but implementation details vary:

- Some states added specific disclosure language requirements
- Some states added training hour requirements
- Some states added firm-level reporting obligations
- A few states have adopted more stringent standards than the model

**Architectural Implication:**
The suitability rules engine must be state-configurable. Rules, disclosures, and workflows must vary by the state of issue (determined by owner's state of residence).

```
Suitability Rule Structure:
├── Federal Rules (Reg BI - for registered products)
│   ├── Disclosure requirements
│   ├── Care obligation scoring
│   └── Conflict of interest checks
├── NAIC Model #275 (baseline for non-registered products)
│   ├── Best interest standard
│   ├── Consumer profile requirements
│   └── Safe harbor conditions
└── State-Specific Overlays (per state of issue)
    ├── Alabama: [specific rules]
    ├── Alaska: [specific rules]
    ├── ...
    └── Wyoming: [specific rules]
```

### 4.3 Automated Suitability Scoring

#### 4.3.1 Scoring Algorithm Design

A suitability scoring engine typically evaluates multiple dimensions and produces both a composite score and dimension-specific flags.

**Dimension Scoring Model:**

| Dimension | Weight | Scoring Logic |
|---|---|---|
| **Age Appropriateness** | 15% | Score based on issue age vs. product surrender period. Penalty if surrender period extends beyond age 80. |
| **Liquidity Ratio** | 20% | Premium as % of liquid net worth. Flag if >50%. Hard stop if >75% (absent documented justification). |
| **Risk Alignment** | 20% | Compare stated risk tolerance with product risk profile. Mismatch reduces score. |
| **Time Horizon Match** | 15% | Compare stated time horizon with product surrender period and benefit availability. |
| **Investment Objective Fit** | 15% | Compare stated objectives with product features (income rider = income objective, etc.) |
| **Existing Coverage** | 10% | Consider existing annuity holdings. Excessive concentration or multiple replacement flags reduce score. |
| **Cost Reasonableness** | 5% | Total product cost relative to peer products. Outlier costs flagged. |

**Composite Score Ranges:**

| Score Range | Action |
|---|---|
| 90–100 | Auto-approve (if no individual dimension flags) |
| 70–89 | Standard review (supervisor reviews documentation) |
| 50–69 | Enhanced review (senior supervisor or compliance review) |
| Below 50 | Decline or require written justification and compliance sign-off |

#### 4.3.2 Exception Handling

When automated scoring produces a flag or low score:

1. **Auto-generated follow-up request**: System creates a requirements item requesting additional documentation (e.g., "Please provide written explanation for liquidity ratio exceeding 50%")
2. **Supervisor queue**: Case routed to supervisory review queue with score details and dimension flags highlighted
3. **Compliance escalation**: If score below threshold or if specific hard-flag conditions met (e.g., senior investor, replacement, high concentration), case escalated to compliance review queue
4. **Documentation**: All scoring inputs, calculations, and outcomes preserved as part of the case audit trail

### 4.4 Supervisor Review Workflow

```
┌──────────────┐     ┌──────────────┐     ┌──────────────┐
│ Auto-Scoring │────▶│  Routing      │────▶│  Queue        │
│ Complete     │     │  Engine       │     │  Assignment   │
└──────────────┘     └──────────────┘     └──────────────┘
                                                 │
                            ┌────────────────────┤
                            ▼                    ▼
                     ┌──────────────┐     ┌──────────────┐
                     │  Level 1      │     │  Level 2      │
                     │  Supervisor   │     │  Compliance   │
                     │  Review       │     │  Review       │
                     └──────────────┘     └──────────────┘
                            │                    │
                     ┌──────┴──────┐      ┌──────┴──────┐
                     ▼      ▼      ▼      ▼      ▼      ▼
                  Approve  Return  Reject  Approve Return Reject
                     │    to Agent   │       │   to L1    │
                     │      │        │       │     │      │
                     ▼      │        ▼       ▼     │      ▼
                 Continue   │    Decline  Continue  │   Decline
                 Processing │    Case    Processing │   Case
                            ▼                      ▼
                    Agent Corrects           L1 Reviews
                    & Resubmits             & Resubmits
```

**SLA Targets for Suitability Review:**
- Level 1 Supervisor Review: 2 business hours from queue assignment
- Level 2 Compliance Review: 4 business hours from queue assignment
- Return to Agent: 1 business day for response
- Total suitability review cycle: Should not exceed 2 business days

---

## 5. Anti-Money Laundering (AML/KYC)

### 5.1 Customer Identification Program (CIP)

Under the USA PATRIOT Act and FinCEN regulations (31 CFR 1025), insurance companies that issue annuities are required to maintain a CIP to verify the identity of each customer at the time of account opening.

#### 5.1.1 Minimum CIP Requirements

**For Natural Persons (Individuals):**

| Data Element | Requirement | Verification Method |
|---|---|---|
| Full Legal Name | Required | Documentary (gov't ID) or non-documentary (database) |
| Date of Birth | Required | Documentary or non-documentary |
| Residential Address | Required | Documentary or non-documentary |
| SSN/TIN | Required for US persons | SSN validation, TIN matching |

**For Non-Natural Persons (Entities):**

| Data Element | Requirement | Verification Method |
|---|---|---|
| Entity Legal Name | Required | Documentary (formation documents) |
| Principal Place of Business | Required | Documentary or non-documentary |
| EIN | Required | IRS EIN verification |
| Controlling Person(s) | Required (CDD Rule) | Identity verification of all controllers |
| Beneficial Owners (25%+) | Required (CDD Rule) | Identity verification of all 25%+ owners |

#### 5.1.2 Verification Methods

**Documentary Verification:**
- Government-issued photo ID (driver's license, passport, state ID)
- For entities: certified articles of incorporation, partnership agreement, trust instrument
- Document images captured and stored in ECM
- AI-based document authentication (Jumio, Onfido, Socure) can detect fraudulent documents

**Non-Documentary Verification:**
- Consumer report data (LexisNexis, TransUnion, Experian)
- Public records databases
- Financial reference checks (bank account verification)
- Knowledge-Based Authentication (KBA)

**Verification Decision Matrix:**

```
┌─────────────────────┐
│  CIP Data Collected  │
└──────────┬──────────┘
           │
           ▼
  ┌────────────────────┐     ┌───────────────────┐
  │  Documentary        │     │  Non-Documentary   │
  │  Verification       │     │  Verification      │
  │  (ID Document       │     │  (Database Match)  │
  │   Provided?)        │     │                    │
  └─────────┬──────────┘     └────────┬──────────┘
            │                         │
       ┌────┴────┐              ┌─────┴─────┐
       ▼         ▼              ▼           ▼
    Valid    Invalid/      Match Found  No Match
    Doc      Expired           │           │
       │         │              │           ▼
       │         ▼              │     Additional
       │    Request New         │     Steps Required
       │    Document            │     (manual review,
       │                        │      call customer)
       ▼                        ▼
  ┌─────────────────────────────────────┐
  │  CIP Verification Complete          │
  │  Record: method, date, result,      │
  │  document details                   │
  └─────────────────────────────────────┘
```

### 5.2 Customer Due Diligence (CDD)

CDD goes beyond CIP identity verification to understand the nature and purpose of the customer relationship and to assess risk.

#### 5.2.1 Risk Rating Model

Each customer is assigned a risk rating that determines the level of ongoing monitoring and due diligence required.

**Risk Factors:**

| Factor | Low Risk | Medium Risk | High Risk |
|---|---|---|---|
| **Product Type** | Fixed annuity, SPIA | Fixed indexed, RILA | Variable annuity (large) |
| **Premium Amount** | Under $100K | $100K–$500K | Over $500K |
| **Customer Age** | 45–70 | 30–44 or 71–85 | Under 30 or over 85 |
| **Source of Funds** | Savings, 1035 exchange | Investment proceeds, inheritance | Sale of business, foreign source |
| **Geography** | US domestic, low-risk state | US domestic, high-risk area | International nexus |
| **Customer Type** | Individual, joint | Trust | Complex entity, PEP |
| **Transaction Pattern** | Single premium | Periodic premiums | Multiple large premiums, frequent changes |

**Composite Risk Score Calculation:**
- Each factor scored 1 (low), 2 (medium), or 3 (high)
- Weighted composite calculated
- Thresholds: Low (below 1.5), Medium (1.5–2.2), High (above 2.2)
- High-risk automatically triggers Enhanced Due Diligence (EDD)

#### 5.2.2 CDD for Legal Entity Customers (FinCEN CDD Rule)

The FinCEN CDD Rule (effective May 2018) requires covered financial institutions to identify and verify:

1. **Beneficial owners**: Each individual who, directly or indirectly, owns 25% or more of the equity interests of the legal entity
2. **Control person**: A single individual with significant responsibility to control, manage, or direct the legal entity (e.g., CEO, CFO, Managing Partner)

**Data Collection:**

```json
{
  "entityCDD": {
    "beneficialOwners": [
      {
        "individual": {
          "firstName": "Robert",
          "lastName": "Johnson",
          "dateOfBirth": "1960-08-22",
          "ssn": "XXX-XX-XXXX",
          "address": { "street": "...", "city": "...", "state": "...", "zip": "..." }
        },
        "ownershipPercentage": 60.0,
        "verificationMethod": "DOCUMENTARY",
        "verificationDate": "2024-03-15"
      }
    ],
    "controlPerson": {
      "individual": {
        "firstName": "Robert",
        "lastName": "Johnson",
        "title": "Managing Member"
      },
      "verificationMethod": "NON_DOCUMENTARY",
      "verificationDate": "2024-03-15"
    }
  }
}
```

### 5.3 Enhanced Due Diligence (EDD)

EDD is triggered for high-risk customers and involves additional scrutiny beyond standard CDD.

**EDD Triggers:**
- Customer risk rating of "High"
- Premium exceeding carrier-defined threshold (e.g., $1M+)
- PEP (Politically Exposed Person) status identified
- Adverse media screening hit
- Geographic risk (foreign nexus, high-risk jurisdiction)
- Unusual transaction pattern
- OFAC near-match requiring investigation

**EDD Procedures:**
1. **Source of Wealth investigation**: Understand how the customer accumulated their wealth (not just the immediate source of funds)
2. **Enhanced documentation**: Request additional documentation (bank statements, tax returns, brokerage statements)
3. **Management approval**: Senior AML officer must approve relationship
4. **Ongoing monitoring**: Elevated monitoring frequency and lower thresholds for suspicious activity review
5. **Periodic review**: Re-evaluation at defined intervals (e.g., annually for high-risk)

### 5.4 OFAC Screening

The Office of Foreign Assets Control (OFAC) maintains lists of sanctioned individuals, entities, and countries. Annuity carriers must screen all parties to a transaction against OFAC lists.

#### 5.4.1 Screening Points

Screening must occur at multiple points in the lifecycle:

| Screening Point | Parties Screened | Timing |
|---|---|---|
| Application intake | Owner, joint owner, annuitant, beneficiaries, trustees, authorized signers | At case creation |
| Policy issue | All parties | Before contract issuance |
| Beneficiary change | New beneficiaries | At time of change |
| Death claim | Claimants, payees | At claim processing |
| Ongoing (batch) | All in-force policyholders | Daily or weekly batch |
| OFAC list update | All in-force policyholders | When new OFAC list published |

#### 5.4.2 Screening Technology

**Name Matching Algorithms:**
- Exact match (baseline)
- Fuzzy matching (Soundex, Metaphone, Levenshtein distance)
- Transliteration matching (for names transliterated from non-Latin scripts)
- Alias matching (against known aliases on OFAC SDN list)

**Vendor Integration:**

| Vendor | Product | Integration Pattern |
|---|---|---|
| NICE Actimize | SAM (Sanctions and AML Monitoring) | Real-time API + batch |
| LexisNexis | Bridger Insight XG | Real-time API + batch |
| Dow Jones | Risk & Compliance | API + data feed |
| Refinitiv | World-Check | API + batch |
| Accuity (now LexisNexis) | Firco Compliance Link | Real-time API |

**Screening Result Handling:**

```
Name Submitted for Screening
         │
         ▼
  ┌──────────────┐
  │  Screening   │
  │  Engine      │
  └──────┬───────┘
         │
    ┌────┴────┐
    ▼         ▼
 No Match   Potential Match
    │         │
    ▼         ▼
 Continue   ┌──────────────┐
 Processing │  Analyst      │
            │  Review       │
            │  Queue        │
            └──────┬───────┘
                   │
              ┌────┴────┐
              ▼         ▼
          True Match  False Positive
              │         │
              ▼         ▼
         ┌──────────┐  Clear & Document
         │  Escalate │  Continue Processing
         │  to BSA   │
         │  Officer  │
         └──────────┘
              │
              ▼
         Block Transaction
         File SAR if applicable
```

### 5.5 PEP Screening

Politically Exposed Persons (PEPs) present elevated money laundering risk due to their position and influence.

**PEP Categories:**
- Foreign PEPs: Current or former senior foreign political figures
- Domestic PEPs: Current or former senior domestic political figures
- International Organization PEPs: Senior officials of major international organizations
- PEP family members: Immediate family of PEPs
- Close associates: Known close associates of PEPs

**PEP Screening Integration:**
- Screened during initial application and periodically during the life of the contract
- PEP databases: Dow Jones, LexisNexis WorldCompliance, Refinitiv World-Check
- PEP status triggers Enhanced Due Diligence automatically
- PEP matches require senior management approval to proceed

### 5.6 Suspicious Activity Reporting (SAR)

**SAR Filing Triggers for Annuity New Business:**
- Application involves known or suspected criminal activity
- Transaction has no apparent business or lawful purpose
- Premium funded from suspicious source
- Customer provides false or inconsistent identification
- Application appears to be structured to avoid reporting thresholds
- OFAC or PEP match confirmed as true positive

**SAR Filing Thresholds:**
- No minimum dollar threshold for SAR filing — file if activity is suspicious regardless of amount
- However, FinCEN guidance suggests heightened scrutiny for transactions above $5,000
- SAR must be filed within 30 calendar days of initial detection (60 days if no suspect identified and additional time needed)

**System Requirements:**
- SAR case management system (integrated with or separate from AML platform)
- Automated SAR narrative generation (template-based with investigator input)
- FinCEN BSA E-Filing integration for electronic SAR submission
- SAR confidentiality controls (SAR existence cannot be disclosed to subject)
- 5-year retention requirement for SARs and supporting documentation

### 5.7 Currency Transaction Reporting (CTR)

While less common in annuity new business (most premiums are paid by check, wire, or ACH), CTR filing is required for cash transactions exceeding $10,000.

**CTR Requirements:**
- File FinCEN Form 112 (CTR) for cash transactions exceeding $10,000 in a single business day
- "Cash" includes currency (bills and coins) but generally NOT checks, wire transfers, or ACH
- Multiple cash transactions by or on behalf of the same person that aggregate to more than $10,000 in a single day must also be reported
- CTR filed within 15 calendar days of the transaction

### 5.8 AML Vendor Integration Architecture

```
┌─────────────────────────────────────────────────────────┐
│                  Carrier AML Platform                    │
│                                                         │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌────────┐ │
│  │  Case     │  │  Rules   │  │  Alert   │  │  SAR   │ │
│  │  Mgmt     │  │  Engine  │  │  Queue   │  │  Filing│ │
│  └──────────┘  └──────────┘  └──────────┘  └────────┘ │
│       │              │              │            │       │
│       └──────────────┴──────────────┴────────────┘       │
│                          │                               │
└──────────────────────────┼───────────────────────────────┘
                           │
              ┌────────────┼────────────┐
              ▼            ▼            ▼
    ┌──────────────┐ ┌──────────┐ ┌──────────────┐
    │  OFAC/PEP    │ │  Identity │ │  Transaction │
    │  Screening   │ │  Verify   │ │  Monitoring  │
    │  (Actimize/  │ │  (LexNex/ │ │  (Actimize/  │
    │   Bridger)   │ │  Experian)│ │   SAS)       │
    └──────────────┘ └──────────┘ └──────────────┘
```

**Integration Patterns:**
- **Real-time API**: For screening at application intake — low latency (<3 seconds) required
- **Batch Processing**: For periodic re-screening of entire in-force book — nightly or weekly
- **Event-driven**: For triggered screening (e.g., beneficiary change, large withdrawal)
- **Data Feed**: For list updates (OFAC publishes updates multiple times per month)

---

## 6. NIGO (Not In Good Order) Processing

### 6.1 Common NIGO Reasons

NIGO is the single largest driver of processing delays and poor customer experience in annuity new business. Understanding and systematically addressing NIGO is critical.

#### 6.1.1 NIGO Taxonomy

| Category | Specific NIGO Reasons | Frequency |
|---|---|---|
| **Missing Signatures** | Owner signature missing, Annuitant signature missing, Agent signature missing, Spousal consent missing, Trustee signature missing | 20–25% of all NIGOs |
| **Missing Information** | Beneficiary DOB, Beneficiary SSN, Owner address incomplete, Investment allocation missing, Source of funds not indicated | 15–20% |
| **Invalid/Inconsistent Data** | SSN doesn't match name (per CIP check), Age exceeds product limits, Address doesn't validate, Premium below minimum | 10–15% |
| **Missing Forms** | Suitability questionnaire not included, Replacement form missing, Transfer/rollover form missing, Trust certification missing | 12–18% |
| **Producer Issues** | Agent not licensed in state, Agent not appointed with carrier, Agent E&O expired, Agent registration lapsed (VA) | 8–12% |
| **Suitability Concerns** | Liquidity concentration too high, Risk tolerance mismatch, Surrender period extends beyond age 85, Replacement without adequate justification | 5–10% |
| **Payment Issues** | Check not signed, Check made out incorrectly, Check amount doesn't match application, ACH authorization incomplete | 5–8% |
| **Product Issues** | Product not available in state, Rider combination not valid, Allocation doesn't sum to 100%, Fund no longer available | 3–5% |

### 6.2 Automated NIGO Detection

#### 6.2.1 Rules Engine Design

The NIGO detection rules engine runs immediately upon case creation and continuously as requirements are fulfilled.

**Rule Categories:**

```
NIGO Rules Engine
├── Completeness Rules (data presence)
│   ├── Required field null checks
│   ├── Required form presence checks
│   └── Required signature presence checks
│
├── Validity Rules (data correctness)
│   ├── Format validations (SSN, phone, email, ZIP)
│   ├── Range validations (age, premium amount)
│   ├── Cross-field consistency (allocation sums, beneficiary percentages)
│   └── External validations (address CASS, SSN verification)
│
├── Eligibility Rules (product/regulatory)
│   ├── Product availability by state
│   ├── Age eligibility by product/rider
│   ├── Premium limits by product
│   ├── Rider combination validity
│   └── Producer licensing/appointment
│
└── Compliance Rules (regulatory)
    ├── Suitability scoring thresholds
    ├── Replacement disclosure requirements
    ├── AML/KYC verification requirements
    └── State-specific form requirements
```

**Rule Implementation Pattern:**

```json
{
  "ruleId": "NIGO-SIG-001",
  "ruleName": "Owner Signature Required",
  "category": "COMPLETENESS",
  "subcategory": "SIGNATURE",
  "severity": "HARD_STOP",
  "condition": "application.ownerSignature IS NULL OR application.ownerSignature.present = false",
  "nigoReason": "Owner signature is missing",
  "nigoCode": "SIG_OWNER_MISSING",
  "correspondenceTemplate": "TMPL_REQ_OWNER_SIG",
  "autoResolvable": false,
  "applicableChannels": ["PAPER", "CALL_CENTER"],
  "notes": "E-app channel enforces signature at submission; not applicable to e-app"
}
```

#### 6.2.2 NIGO Scoring

Each case receives an NIGO severity score that influences processing priority:

| NIGO Severity | Description | SLA Impact |
|---|---|---|
| **Hard Stop** | Cannot proceed until resolved (missing signature, failed AML) | Blocks all processing |
| **Soft Stop** | Can proceed with parts of processing but cannot issue (missing beneficiary SSN) | Blocks issuance |
| **Warning** | Non-blocking but should be resolved (non-standard spelling, minor format issue) | Flagged for review |

### 6.3 NIGO Correspondence Generation

When NIGO items are identified, the system generates correspondence to the appropriate party (agent, applicant, broker-dealer).

**Correspondence Workflow:**

```
NIGO Items Identified
        │
        ▼
  ┌─────────────────┐
  │  Aggregate NIGO  │
  │  Items by        │
  │  Recipient       │
  └────────┬────────┘
           │
    ┌──────┴──────┐
    ▼             ▼
 Agent Items  Applicant Items
    │             │
    ▼             ▼
 ┌──────────┐  ┌──────────┐
 │ Generate  │  │ Generate  │
 │ Agent     │  │ Applicant │
 │ Letter    │  │ Letter    │
 └──────────┘  └──────────┘
    │             │
    ▼             ▼
 ┌──────────┐  ┌──────────┐
 │ Deliver   │  │ Deliver   │
 │ (Email/   │  │ (Mail/    │
 │  Portal)  │  │  Email)   │
 └──────────┘  └──────────┘
```

**Delivery Channels for NIGO Correspondence:**
- Agent portal notification (preferred — fastest)
- Agent email with PDF attachment
- Broker-dealer supervisory portal notification
- Applicant email (if email on file and consent given)
- Applicant physical mail (last resort — adds 5–7 days)

**Template Management:**
- Document composition engine (OpenText Exstream, Messagepoint, Quadient Inspire)
- State-specific language inserts
- Multi-language support (English, Spanish at minimum)
- Dynamic content based on NIGO reason codes
- ADA/accessibility compliant output

### 6.4 NIGO Aging and Escalation

**Aging Tiers:**

| Age (Business Days) | Status | Action |
|---|---|---|
| 0–5 | Active | Initial NIGO correspondence sent; awaiting response |
| 6–10 | Follow-up | Second correspondence sent (email + portal reminder) |
| 11–15 | Escalation | Phone follow-up attempt; supervisor notified |
| 16–20 | At Risk | Third correspondence; case flagged as at-risk for abandonment |
| 21–30 | Critical | Final notice sent; regulatory time limits may apply |
| 31–45 | Pre-Close | Applicant informed case will be closed if not resolved |
| 46+ | Close/Return Premium | Case closed; premium returned to applicant with explanation letter |

**State Regulatory Considerations:**
- Some states mandate that carriers must process or formally decline an application within a specified timeframe (e.g., 30–45 days)
- If premium is held in escrow, interest may accrue and must be credited upon return
- Replacement regulations may have specific timelines for processing replacement transactions

### 6.5 NIGO Resolution Workflow

```
NIGO Item Pending
       │
       ▼
 ┌─────────────┐
 │  Response    │
 │  Received    │
 │  (document,  │
 │   data, sig) │
 └──────┬──────┘
        │
        ▼
 ┌─────────────┐       ┌─────────────┐
 │  Match to    │──────▶│  Validate   │
 │  NIGO Item   │       │  Response   │
 │  (auto or    │       │  Completeness│
 │   manual)    │       │  & Accuracy  │
 └─────────────┘       └──────┬──────┘
                              │
                     ┌────────┴────────┐
                     ▼                 ▼
               Resolved           Still NIGO
                     │                 │
                     ▼                 ▼
               Close NIGO        Update NIGO
               Item; Check       Item; Send
               If All Items      New Correspondence
               Resolved          for Remaining
                     │             Issues
                     ▼
               All Resolved?
               ┌─────┴─────┐
               ▼           ▼
             Yes          No
               │           │
               ▼           ▼
         Advance Case   Wait for
         to Next Step   Remaining Items
```

### 6.6 NIGO Analytics and Reporting

**Key NIGO Metrics:**

| Metric | Description | Target |
|---|---|---|
| Overall NIGO Rate | % of applications received NIGO | <15% |
| NIGO Rate by Channel | Broken down by intake channel | Paper <35%, E-app <10% |
| NIGO Rate by Reason | Top NIGO reasons ranked by frequency | Tracking and trending |
| NIGO Resolution Time | Average days to resolve NIGO items | <5 business days |
| NIGO Recurrence Rate | % of cases that go NIGO multiple times | <10% |
| NIGO-to-Abandonment Rate | % of NIGO cases that result in abandonment | <15% |
| NIGO by Producer | Top NIGO-producing agents (for training) | Targeted coaching |
| NIGO by Product | NIGO rates by product type | Product form improvement |
| NIGO by Broker-Dealer | NIGO rates by distributing firm | Firm-level coaching |

---

## 7. Underwriting for Annuities

### 7.1 Overview of Annuity Underwriting

Unlike life insurance, where medical underwriting is the primary focus, annuity underwriting is primarily **financial** in nature. The insurer is concerned with:

- **Anti-selection risk**: Is the applicant purchasing the annuity specifically because they have information about their life expectancy that would disadvantage the insurer?
- **Suitability risk**: Is the product appropriate for the customer?
- **AML risk**: Are the funds from a legitimate source?
- **Concentration risk**: Does this policy create excessive exposure for the insurer?
- **Fraud risk**: Is the application fraudulent?

### 7.2 Financial Underwriting

#### 7.2.1 Large Case Thresholds

| Premium Amount | Underwriting Level |
|---|---|
| Under $250,000 | Standard (automated rules only) |
| $250,000–$999,999 | Enhanced (automated + manual review of financials) |
| $1,000,000–$4,999,999 | Large Case (dedicated underwriter review) |
| $5,000,000+ | Jumbo Case (senior underwriter + reinsurance review) |

These thresholds vary by carrier and product type.

#### 7.2.2 Financial Underwriting Requirements by Tier

**Standard Tier ($0–$249K):**
- Source of funds declaration on application
- Automated CIP/AML screening
- Suitability questionnaire review
- No additional financial documentation required

**Enhanced Tier ($250K–$999K):**
- All standard requirements plus:
- Verification of source of funds (may request brokerage statement, bank statement, or 1035 exchange documentation)
- Review of total in-force business with this carrier (concentration check)
- Income and net worth reasonableness review

**Large Case Tier ($1M–$4.99M):**
- All enhanced requirements plus:
- Detailed source of funds documentation (bank/brokerage statements, tax returns, closing documents for property sale)
- Financial questionnaire (detailed Q&A about financial situation, purpose of purchase, existing assets)
- Carrier's financial underwriting worksheet completed by underwriter
- May require phone interview with applicant
- Actuarial review for products with guaranteed lifetime benefits

**Jumbo Case Tier ($5M+):**
- All large case requirements plus:
- Comprehensive financial disclosure (full financial statement, multiple years of tax returns)
- Reinsurance review and approval (reinsurer may have separate requirements)
- Home office actuarial sign-off
- Executive management awareness/approval
- Enhanced AML due diligence
- May require in-person meeting or video interview

### 7.3 Medical Underwriting

Medical underwriting is not standard for annuity contracts, but is required in specific scenarios:

#### 7.3.1 Scenarios Requiring Medical Review

| Scenario | Reason | Typical Requirements |
|---|---|---|
| **Enhanced Death Benefit Rider** | Rider provides death benefit in excess of account value; anti-selection risk | Simplified health questionnaire; paramedical exam for large cases |
| **Guaranteed Lifetime Withdrawal Benefit (GLWB)** | Insurer guarantees income for life; longevity risk | Health attestation; may require medical records for very large cases |
| **Substandard/Impaired Risk Annuity** | Customer seeks higher payout rate based on reduced life expectancy | Full medical underwriting (APS, lab tests) |
| **Longevity Annuity (DIA/QLAC)** | Deferred income annuity with long deferral period | Health questionnaire; age-dependent additional requirements |

#### 7.3.2 Medical Underwriting Data Sources

- **Application health questions**: Simplified questionnaire (5–10 yes/no questions)
- **MIB (Medical Information Bureau)**: Code-based medical history check
- **Prescription drug history**: Milliman IntelliScript, ExamOne
- **Motor vehicle records**: LexisNexis
- **Attending Physician Statements (APS)**: For impaired risk annuities
- **Paramedical exam**: For large cases with enhanced death benefits

### 7.4 Automated Underwriting Rules Engine

**Rules Engine Architecture:**

```
┌─────────────────────────────────────────────────────┐
│              Underwriting Rules Engine               │
│                                                     │
│  ┌─────────────┐  ┌─────────────┐  ┌────────────┐  │
│  │  Financial   │  │  Medical    │  │  Fraud     │  │
│  │  Rules       │  │  Rules      │  │  Detection │  │
│  │  Module      │  │  Module     │  │  Module    │  │
│  └──────┬──────┘  └──────┬──────┘  └─────┬──────┘  │
│         │                │               │          │
│         └────────────────┴───────────────┘          │
│                          │                          │
│                          ▼                          │
│                 ┌────────────────┐                   │
│                 │  Decision      │                   │
│                 │  Engine        │                   │
│                 │  (Approve/     │                   │
│                 │   Refer/       │                   │
│                 │   Decline)     │                   │
│                 └────────────────┘                   │
└─────────────────────────────────────────────────────┘
```

**Decision Outcomes:**

| Decision | Criteria | Next Step |
|---|---|---|
| **Auto-Approve** | All rules pass, no flags, premium under auto-approve threshold | Proceed to premium processing |
| **Refer to Underwriter** | One or more soft flags, premium in enhanced tier, medical questions flagged | Queue for underwriter review |
| **Refer to Senior UW** | Multiple flags, premium in large case tier, complex entity ownership | Queue for senior underwriter |
| **Decline** | Hard stop rule triggered (e.g., OFAC match, premium exceeds absolute maximum, product not available in state) | Generate decline letter |
| **Incomplete** | Missing required underwriting information | Generate requirements request |

### 7.5 Underwriting by Product Type

| Product Type | Financial UW Intensity | Medical UW Intensity | Typical Auto-Approve Threshold |
|---|---|---|---|
| SPIA (Immediate Annuity) | Medium (source of funds) | None (standard) / Full (impaired risk) | $500K |
| DIA (Deferred Income Annuity) | Medium | Low (health attestation) | $500K |
| Fixed Annuity (MYGA) | Low-Medium | None | $1M |
| Fixed Indexed Annuity | Medium | Low (if living benefit elected) | $500K |
| Variable Annuity (no riders) | Medium | None | $500K |
| Variable Annuity (w/ GLWB) | Medium-High | Low-Medium | $250K |
| RILA (Registered Index-Linked) | Medium | Low (if living benefit elected) | $500K |

---

## 8. Premium Processing

### 8.1 Check Processing

#### 8.1.1 Lockbox Operations

Most carriers use a bank lockbox service for receiving premium checks, which accelerates processing by 1–3 days compared to carrier mailroom processing.

**Lockbox Processing Flow:**

```
Check Received at Lockbox PO Box
         │
         ▼
  Bank Opens & Sorts Mail
         │
         ▼
  Check Scanned (MICR + Image)
         │
         ▼
  Data Captured:
  ├── Payee name validation
  ├── Check amount (CAR/LAR)
  ├── Check date
  ├── Routing/Account number
  ├── Memo line (policy # reference)
  └── Remittance document data
         │
         ▼
  Deposit to Carrier's Account
  (Same-day or next-day availability)
         │
         ▼
  Transmission File to Carrier:
  ├── Check images (TIFF/JPEG)
  ├── MICR data
  ├── Extracted amount
  ├── Remittance data
  └── Batch totals
         │
         ▼
  Carrier Intake System:
  ├── Match to pending case (by remittance data, memo line, or manual match)
  ├── Validate amount vs. application
  ├── Post to escrow/suspense account
  └── Update case status
```

**Lockbox Vendors:**
- JPMorgan Chase Treasury Services
- Bank of America Merrill Lynch
- Wells Fargo Treasury Management
- US Bank Wholesale Lockbox

#### 8.1.2 Remote Deposit Capture (RDC)

For paper applications received at the carrier mailroom (not lockbox), checks are processed via Remote Deposit Capture:

1. Check scanned at carrier facility using RDC-enabled scanner
2. Check image transmitted to carrier's bank electronically
3. Bank processes deposit based on image
4. Physical check retained for specified period then destroyed

**Check Validation Rules:**
- Check payable to carrier (correct legal entity name)
- Check amount matches application premium amount (tolerance: exact match or within $0.01)
- Check dated within 180 days (not stale-dated)
- Check not post-dated beyond current date
- Single-party or two-party check from acceptable source (personal check, cashier's check, money order — not third-party checks typically)
- Check amount within product premium limits

### 8.2 Wire Transfer Processing

**Wire Processing Flow:**

```
Sending Bank initiates Fedwire/SWIFT transfer
         │
         ▼
  Carrier's Bank receives wire
         │
         ▼
  Wire posted to Carrier's operating account
         │
         ▼
  Bank transmits wire notification to Carrier:
  ├── Wire reference number
  ├── Sending bank / ABA
  ├── Originator name
  ├── Amount
  ├── Reference/memo field
  └── Date/time
         │
         ▼
  Carrier Wire Matching System:
  ├── Auto-match to pending case (by reference field, name, amount)
  ├── If no match: Route to manual matching queue
  ├── If matched: Post to case, validate amount
  └── Update case status
```

**Wire-Specific Requirements:**
- Wire originator must match applicant or an approved funding source
- Wire reference field should contain application/case number
- Third-party wires require additional documentation and AML review
- International wires trigger enhanced AML screening
- Wire amounts exceeding certain thresholds ($100K+) may require additional approval

### 8.3 ACH Processing

**ACH Authorization Flow:**

```
Applicant Provides ACH Authorization
(Bank name, routing #, account #, account type)
         │
         ▼
  Carrier Validates ACH Information:
  ├── Micro-deposit verification (2 small deposits, applicant confirms amounts)
  │   OR
  ├── Instant account verification (Plaid, Yodlee, MX)
  │   OR
  └── Pre-note validation (zero-dollar test transaction)
         │
         ▼
  ACH Debit Originated via NACHA:
  ├── Standard entry class: PPD (personal) or CCD (corporate)
  ├── Settlement: T+1 or T+2
  └── Carrier's ODFI submits to ACH network
         │
         ▼
  Funds Settled
         │
         ▼
  Post to Case / Apply Premium
         │
    ┌────┴────┐
    ▼         ▼
 Success    Return/NSF
    │         │
    ▼         ▼
 Continue   NIGO: Payment Failed
 Processing  ├── Notify agent/applicant
             ├── Hold case processing
             └── Request alternative payment
```

**ACH Return Handling:**
- ACH returns arrive 2–5 business days after origination
- Common return codes: R01 (Insufficient Funds), R02 (Account Closed), R03 (No Account), R04 (Invalid Account Number)
- Return triggers NIGO status on case
- Repeated ACH failures may trigger fraud/AML review

### 8.4 1035 Exchange Incoming

A 1035 exchange allows the tax-free transfer of an existing life insurance or annuity contract to a new annuity contract (IRC §1035).

#### 8.4.1 Full 1035 Exchange

**Process Flow:**

```
Application received indicating 1035 exchange
         │
         ▼
  Generate Transfer/Exchange Letter (TEL):
  ├── Existing carrier name and address
  ├── Existing policy number
  ├── Owner information
  ├── Request to surrender and transfer proceeds
  ├── Carrier-specific transfer forms (if required by existing carrier)
  └── Tax information transfer request (cost basis)
         │
         ▼
  Mail/Fax TEL to Existing Carrier
         │
         ▼
  Existing Carrier Processes Surrender:
  ├── Validate signature and authorization
  ├── Calculate surrender value (less any applicable charges)
  ├── Determine cost basis
  └── Issue check payable to "New Carrier FBO [Owner Name]"
         │
         ▼
  Check Received by New Carrier
  (Typically 2–6 weeks from TEL submission)
         │
         ▼
  Post 1035 Exchange Premium:
  ├── Validate check is FBO (For Benefit Of) correct owner
  ├── Record cost basis from existing carrier
  ├── Apply premium to contract
  ├── Calculate gain/loss for tracking
  └── Activate contract
```

#### 8.4.2 Partial 1035 Exchange

A partial 1035 exchange transfers only a portion of the existing contract's value.

**Additional Complexity:**
- Not all carriers accept or process partial 1035 exchanges
- IRS requirements: Must qualify as an exchange (not a withdrawal followed by a new purchase)
- Existing carrier may have minimum retention requirements
- Cost basis must be prorated between the exchanged and retained portions
- Some states have specific regulations around partial exchanges

### 8.5 Rollover Processing

#### 8.5.1 Direct Trustee-to-Trustee Transfer

The most tax-efficient method for moving qualified retirement funds into an annuity.

**Process Flow:**

```
Application indicates rollover from qualified plan
         │
         ▼
  Generate Transfer Request to Existing Custodian/Trustee:
  ├── Existing plan name and account number
  ├── Custodian name and address
  ├── Owner/participant information
  ├── Request for direct transfer to new carrier as trustee
  ├── Account type (Traditional IRA, Roth IRA, 401k, 403b, etc.)
  └── Full or partial transfer amount
         │
         ▼
  Existing Custodian Processes Transfer:
  ├── Validate authorization
  ├── Liquidate positions (if necessary)
  ├── Issue check payable to "New Carrier as Trustee FBO [Participant Name]"
  │   OR
  └── Wire/ACH transfer to new carrier's custodial account
         │
         ▼
  Funds Received by New Carrier:
  ├── Match to pending case
  ├── Validate qualified money source
  ├── Record transfer type (direct trustee-to-trustee)
  ├── No tax withholding required
  └── Apply to contract as rollover premium
```

#### 8.5.2 60-Day Indirect Rollover

The participant receives the distribution personally and has 60 calendar days to roll it into a new qualified account.

**Key Differences from Direct Transfer:**
- Distribution check payable directly to participant
- 20% mandatory federal tax withholding (for employer plan distributions)
- Participant must contribute full pre-withholding amount to new carrier within 60 days
- Participant responsible for recovering withheld taxes via tax return
- One indirect rollover per 12-month period (IRA-to-IRA)
- System must validate 60-day window and document the rollover

### 8.6 Premium Allocation to Investment Options

**Allocation Processing:**

```
Premium Funds Received & Validated
         │
         ▼
  Determine Effective Date:
  ├── E-app: Date application signed (if funds received within X days)
  ├── Paper: Date funds received (or application date, per product rules)
  ├── 1035/Rollover: Date funds received from existing carrier
  └── Product-specific rules may override
         │
         ▼
  Apply Allocation Percentages:
  ├── Calculate dollar allocation per sub-account/strategy
  ├── Determine NAV/unit price as of effective date (VA)
  │   OR
  ├── Determine crediting rate as of effective date (FIA)
  ├── Purchase units/shares (VA)
  │   OR
  └── Establish index strategy segments (FIA)
         │
         ▼
  Record Initial Account Values:
  ├── Account value by sub-account/strategy
  ├── Total account value
  ├── Death benefit base (typically = initial premium)
  ├── Living benefit base (if rider elected)
  └── Free withdrawal base
```

### 8.7 Premium Tax Calculation

Several states impose a premium tax on annuity considerations. The tax varies by state and may depend on the type of annuity.

**Premium Tax Summary (Illustrative — Rates Change):**

| State | Tax Rate | Applicability |
|---|---|---|
| California | 2.35% | All annuity premiums (deferred), rate varies for immediate |
| Maine | 2.00% | All annuity premiums |
| South Dakota | 1.25% on first $500K, varying thereafter | Modified premium tax |
| Wyoming | 1.00% | All annuity premiums |
| Most other states | 0% on annuity premiums | Premium tax on life insurance only |

**System Implementation:**
- Premium tax calculated based on owner's state of residence (issue state)
- Tax tables maintained as configurable reference data
- Tax may be deducted from premium before allocation or billed separately
- Carrier remits premium tax to state on behalf of policyholder
- Tax calculation audit trail maintained

---

## 9. Policy Issue Process

### 9.1 Contract Generation

#### 9.1.1 Document Composition Architecture

The annuity contract is a legal document consisting of multiple components assembled dynamically based on the product, riders, state, and owner information.

**Contract Components:**

```
Annuity Contract Document
├── Cover Page (Contract Number, Owner Name, Product Name)
├── Contract Specifications Page
│   ├── Owner/Annuitant information
│   ├── Premium amount and date
│   ├── Product details
│   ├── Rider elections
│   ├── Beneficiary designations
│   └── Agent information
├── Base Contract Form
│   ├── Definitions
│   ├── General Provisions
│   ├── Death Benefit Provisions
│   ├── Annuity Payout Provisions
│   ├── Withdrawal Provisions
│   ├── Surrender Provisions
│   └── Tax Provisions
├── Rider Forms (one per elected rider)
│   ├── GLWB Rider
│   ├── GMDB Rider
│   ├── Nursing Home Waiver Rider
│   └── Return of Premium Rider
├── State-Specific Endorsements
│   ├── State amendment form (modifies base contract per state law)
│   └── State-required disclosures
├── Investment Option Prospectus Reference (VA)
│   └── Or Fund Fact Sheets (FIA)
└── Required Disclosures
    ├── Buyer's Guide to Annuities
    ├── Fee/Expense Summary
    ├── Free Look Notice
    └── Privacy Notice
```

**Document Composition Technology:**

| Vendor | Product | Pattern |
|---|---|---|
| OpenText | Exstream | Template-based; rules-driven assembly |
| Quadient | Inspire | Interactive + batch document generation |
| Messagepoint | SmartCOMM | Content-managed correspondence |
| Adobe | Experience Manager | PDF-based document assembly |
| Custom | HTML/PDF generation | Headless Chrome, wkhtmltopdf, Apache FOP |

**Composition Process:**

```
Issue Decision: APPROVED
         │
         ▼
  Document Assembly Request:
  ├── Product code
  ├── State of issue
  ├── Rider codes
  ├── Variable data (owner, premium, allocations, etc.)
  └── Delivery preference (print/electronic)
         │
         ▼
  Template Resolution:
  ├── Select base contract template (by product + state)
  ├── Select rider templates (by rider code + state)
  ├── Select endorsement templates (by state)
  ├── Select disclosure templates (by product + state)
  └── Resolve version (effective date-based versioning)
         │
         ▼
  Document Composition Engine:
  ├── Merge variable data into templates
  ├── Apply conditional logic (e.g., suppress sections based on product features)
  ├── Calculate page numbers, table of contents
  ├── Apply branding, formatting
  └── Generate output (PDF, print-ready)
         │
         ▼
  Quality Assurance:
  ├── Automated checks (page count, variable data presence, watermark removal)
  ├── Spot-check sampling by operations
  └── Store final document in ECM
```

### 9.2 Welcome Kit Assembly

The welcome kit is the package delivered to the new contract owner. Contents vary by carrier, product, and delivery method.

**Typical Welcome Kit Contents:**

| Document | Required/Optional | Notes |
|---|---|---|
| Welcome Letter | Required | Personalized; summarizes key contract details |
| Contract/Certificate | Required | The legal annuity contract |
| Specifications Page | Required | Variable data summary |
| Free Look Notice | Required | Informs of cancellation right; state-specific language |
| Buyer's Guide | Required (most states) | NAIC Annuity Buyer's Guide or carrier equivalent |
| Privacy Notice | Required | Annual privacy notice per Gramm-Leach-Bliley |
| Investment Summary | Required (VA/FIA) | Sub-account prospectus summary or index strategy descriptions |
| Fee Schedule | Required | Complete schedule of all fees and charges |
| Beneficiary Confirmation | Recommended | Separate confirmation of beneficiary designations |
| Online Access Instructions | Recommended | How to register for the policyholder web portal |
| Contact Information Card | Recommended | Customer service phone, web, mailing address |

### 9.3 Delivery Requirements

**Delivery Methods:**

| Method | Applicability | Timeline | Tracking |
|---|---|---|---|
| **E-Delivery** | If applicant consented to electronic delivery | Immediate upon issue | Email delivery receipt, portal access log |
| **USPS Priority Mail** | Standard physical delivery | 3–5 business days | USPS tracking number |
| **FedEx/UPS** | Large cases or expedited requests | 1–2 business days | Carrier tracking number |
| **Agent Delivery** | Agent requested to deliver personally | Variable | Agent delivery receipt required |
| **Registered Mail** | If required by state or product | 5–7 business days | Signature confirmation |

**E-Delivery Consent Requirements:**
- ESIGN Act (Electronic Signatures in Global and National Commerce Act) requires:
  - Consent to receive electronic records
  - Disclosure of hardware/software requirements
  - Right to withdraw consent
  - Right to request paper copy
- Consent typically captured during the application process
- System must maintain consent records and honor withdrawal of consent

### 9.4 Free-Look Period Management

The free-look period (also called "right to examine" or "cooling-off period") gives the contract owner the right to cancel the contract and receive a full refund within a specified number of days after delivery.

**Free-Look Rules:**

| Jurisdiction | Standard Free-Look | Senior Free-Look (65+) | Replacement Free-Look |
|---|---|---|---|
| NAIC Model | 10 days | 30 days (recommended) | 30 days |
| California | 10 days | 30 days | 30 days |
| New York | 10 days (20 for VA) | 60 days | 60 days |
| Florida | 14 days | 21 days | 21 days |
| Texas | 10 days | 20 days | 20 days |

**System Requirements for Free-Look:**
- Track delivery date (start of free-look period)
- Calculate free-look expiration date (based on state, owner age, replacement status)
- During free-look period:
  - Flag contract as "in free-look" status
  - If market-value adjustment (MVA) applies, hold in interim account
  - If variable annuity, track investment gain/loss during free-look
- Free-look cancellation processing:
  - Full premium refund (some states: account value if VA with market loss)
  - State-specific refund calculation rules
  - Cancel contract, reverse all accounting entries

### 9.5 Policy Activation & Initial Values

**Initial Values Setup:**

```
Contract Issued
     │
     ▼
Set Initial Values:
├── Contract Number: Assigned (format: carrier prefix + sequence + check digit)
├── Issue Date: Effective date of contract
├── Contract Status: "Issued" → "Active" (after free-look expiration)
├── Account Value: Initial premium (less any applicable premium tax)
├── Death Benefit Base:
│   ├── Standard DB: Account value
│   ├── Return of Premium DB: Initial premium
│   ├── Enhanced DB: May include step-up schedule or percentage enhancement
│   └── Rider-specific DB base: Per rider terms
├── Living Benefit Base (if rider elected):
│   ├── GLWB Benefit Base: Typically = initial premium; may include bonus
│   ├── GMIB Benefit Base: Per rider terms
│   └── GMAB Benefit Base: Per rider terms
├── Surrender Charge Schedule: Based on product and premium date
├── Free Withdrawal Amount: Typically 10% of account value per contract year
├── Withdrawal Charge-Free Amount: Per product terms
├── Cost Basis:
│   ├── Non-qualified: Premium amount
│   ├── 1035 exchange: Transferred cost basis from prior contract
│   ├── Qualified (IRA): $0 (fully taxable on distribution)
│   └── Roth IRA: Premium amount (contributions = basis)
├── RMD Requirements:
│   ├── If Traditional IRA and owner age ≥ 73: Set up RMD schedule
│   ├── If Inherited IRA: Set up stretch or 10-year payout schedule
│   └── If Roth IRA: Generally no RMD during owner's lifetime
└── Systematic Program Setup:
    ├── Dollar Cost Averaging: If elected, set up DCA schedule
    ├── Automatic Rebalancing: If elected, set frequency and targets
    └── Systematic Withdrawals: If elected at issue (uncommon for new business)
```

---

## 10. Replacement Processing

### 10.1 NAIC Model Replacement Regulation (#613)

The NAIC Model Regulation on Replacement of Life Insurance and Annuities establishes requirements when an existing life insurance or annuity contract is being replaced.

#### 10.1.1 Definition of Replacement

A replacement is any transaction in which a new policy or contract is purchased and, in connection with that purchase, an existing policy or contract is:
- Lapsed, forfeited, surrendered, or otherwise terminated
- Converted to reduced paid-up insurance, continued as extended term insurance, or otherwise reduced in value by the use of nonforfeiture benefits
- Amended so as to reduce benefits or the term for which coverage would otherwise remain in force
- Reissued with any reduction in cash value
- Used in a financed purchase (pledged, assigned, or borrowed against)

#### 10.1.2 Agent/Producer Duties

1. **Determine if replacement is involved**: Ask the applicant whether the new purchase involves replacement of existing coverage
2. **Complete replacement forms**: If replacement, complete required comparison forms
3. **Provide required notices**: Deliver replacement notice to applicant
4. **Leave copies**: Leave copies of all completed forms with the applicant
5. **Submit to carrier**: Submit all replacement documentation with the application

#### 10.1.3 Carrier Duties (Replacing Insurer)

1. **Verify replacement information**: Review replacement forms for completeness and accuracy
2. **Notify existing insurer**: Send notification to the existing carrier within specified timeframe (typically 3–5 business days of receiving the application)
3. **Maintain records**: Retain replacement documentation for specified period (typically 5 years or until conclusion of next examination)
4. **Monitor agent activity**: Track replacement ratios by agent for supervisory purposes

#### 10.1.4 Carrier Duties (Existing Insurer / Duty to Preserve)

Upon receiving replacement notification:
1. **Contact the policyholder**: Existing carrier must attempt to conserve the existing contract
2. **Provide comparison**: May provide information comparing existing and proposed coverage
3. **Process in a timely manner**: Must process the surrender/exchange within regulatory timeframes
4. **Cannot unduly delay**: Regulatory prohibition against intentionally delaying 1035 transfers

### 10.2 Replacement Form Processing

**Data on Replacement Comparison Form:**

| Data Element | Source |
|---|---|
| **Existing Contract** | |
| Carrier name | Applicant/Agent |
| Policy number | Applicant/Agent |
| Product type | Applicant/Agent |
| Issue date | Applicant/Agent |
| Premium paid | Applicant/Agent |
| Current cash/account value | Existing carrier (or applicant statement) |
| Current death benefit | Applicant/Agent |
| Surrender charges remaining | Applicant/Agent or existing carrier |
| Existing riders and guarantees | Applicant/Agent |
| Current annual fees/charges | Applicant/Agent |
| Loan balance (if any) | Applicant/Agent |
| **Proposed Contract** | |
| All product features, fees, benefits | Auto-populated from product master |
| Comparison analysis | Agent's written comparison |
| Reason for replacement | Agent's written explanation |

### 10.3 Internal vs. External Replacement

**Internal Replacement** (existing contract with the same carrier):
- Subject to carrier's internal replacement guidelines, which are often more restrictive than regulatory minimums
- Typically requires additional justification (why not just modify the existing contract?)
- May trigger clawback of original commission to agent who sold the existing contract
- Subject to internal replacement review committee
- Some carriers prohibit internal replacements within a defined period (e.g., 36 months) unless customer initiates without agent solicitation

**External Replacement** (replacing a contract from a different carrier):
- Standard replacement regulation applies
- Notification to existing carrier required
- Full comparison documentation required
- Less carrier-specific restriction but subject to suitability scrutiny

### 10.4 State-Specific Replacement Variations

| State | Notable Variation |
|---|---|
| **New York** | Reg 60: Comprehensive replacement regulation with specific comparison format, mandatory conservation effort by existing insurer |
| **California** | Specific replacement form requirements, additional senior protections |
| **Texas** | Modified replacement definition, specific agent training requirements |
| **Florida** | Senior-specific replacement protections (age 65+) |
| **Pennsylvania** | Replacement definition includes "financing" transactions |

**System Architecture Implication:**
The replacement processing module must be highly state-configurable, with:
- State-specific form templates
- State-specific notification letter templates
- State-specific timing requirements (for sending notifications)
- State-specific comparison data requirements
- Configurable rules for when replacement triggers additional review

---

## 11. 1035 Exchange Intake

### 11.1 Paperwork Requirements

A 1035 exchange requires coordination between the new carrier (receiving carrier) and the existing carrier (transferring carrier).

**Required Documents:**

| Document | Purpose | Source |
|---|---|---|
| New annuity application | Establishing the new contract | Applicant + Agent |
| 1035 Exchange Request Form | Authorizing the tax-free exchange | Applicant signature |
| Transfer/Exchange Letter | Instructions to existing carrier | Generated by new carrier |
| Existing Carrier's Transfer Form | Some carriers require their own form | Existing carrier (downloaded or requested) |
| Replacement forms (if applicable) | Regulatory compliance | Agent + Applicant |
| Cost basis documentation | Tax reporting | Existing carrier provides |
| Absolute Assignment (if needed) | Transfer of ownership for certain contract types | Applicant signature |

### 11.2 Transfer Letter to Existing Carrier

The transfer letter (also called Transfer of Exchange Letter or TEL) is the formal request to the existing carrier to surrender the existing contract and transfer the proceeds.

**Transfer Letter Content:**

```
[Carrier Letterhead]

Date: [Current Date]

To: [Existing Carrier Name]
    [Existing Carrier Address]
    Attention: 1035 Exchange / Transfer Processing

RE: 1035 Tax-Free Exchange Request
    Existing Policy Number: [Policy Number]
    Owner: [Owner Name]
    Owner SSN: [Last 4 digits]

Dear Sir/Madam:

We have received an application for a new annuity contract from the above-named 
owner, who has requested a tax-free exchange pursuant to IRC Section 1035.

Please process a [FULL / PARTIAL ($Amount)] surrender of the above policy and 
issue a check payable to:

    [New Carrier Legal Name]
    FBO [Owner Full Name]

Please mail the check to:
    [New Carrier Address]
    Attention: 1035 Exchange Processing
    Reference: [New Application/Case Number]

Please include with the check:
    1. Cost basis information (total premiums paid, amounts previously withdrawn)
    2. Gain/loss calculation
    3. Surrender charge calculation (if applicable)
    4. Any outstanding loan balance deducted

[Signature block for authorized carrier representative]

Enclosures:
- Signed 1035 Exchange Request Form
- [Any additional existing carrier-required forms]
```

### 11.3 Follow-Up and Tracking

1035 exchanges are notoriously slow, often taking 2–6 weeks or more for the existing carrier to process. Systematic follow-up is critical.

**Follow-Up Schedule:**

| Business Days Since TEL Sent | Action |
|---|---|
| 0 | TEL sent to existing carrier; case enters "Awaiting 1035 Funds" status |
| 7 | First follow-up: Call to existing carrier to confirm receipt and expected timeline |
| 14 | Second follow-up: Call/fax to existing carrier requesting status update |
| 21 | Escalation: Written follow-up with escalation to existing carrier's management |
| 30 | Agent notification: Inform agent of delay; request agent assist with existing carrier |
| 45 | Regulatory referral consideration: If existing carrier is unreasonably delaying |
| 60 | Applicant notification: Inform applicant of status and options |

**Tracking System Requirements:**
- 1035 exchange tracking dashboard
- Automated follow-up task generation based on aging
- Integration with carrier contact management for call logging
- Existing carrier response tracking (acknowledged, in process, check issued, check received)
- Expected receipt date tracking with SLA monitoring

### 11.4 Cost Basis Transfer

When a 1035 exchange is completed, the cost basis of the old contract carries over to the new contract. This is critical for accurate tax reporting on future distributions.

**Cost Basis Scenarios:**

| Scenario | Cost Basis in New Contract |
|---|---|
| Full 1035, no prior withdrawals | Total premiums paid into old contract |
| Full 1035, prior withdrawals taken | Total premiums paid minus withdrawals attributed to basis (LIFO for non-qualified) |
| Partial 1035 | Pro-rata share of basis transferred |
| 1035 from life insurance to annuity | Net premiums paid minus dividends received (may differ from annuity-to-annuity calculation) |
| Multiple 1035 chains | Cumulative basis tracking across all prior exchanges |

**System Data Model for Cost Basis:**

```json
{
  "costBasis": {
    "totalBasis": 250000.00,
    "basisSource": "1035_EXCHANGE",
    "priorContractInfo": {
      "priorCarrier": "ABC Insurance Company",
      "priorPolicyNumber": "A12345678",
      "priorIssueDate": "2015-06-01",
      "priorTotalPremiums": 275000.00,
      "priorWithdrawals": 25000.00,
      "priorGainWithdrawn": 0.00,
      "priorBasisWithdrawn": 25000.00,
      "transferredBasis": 250000.00,
      "transferDate": "2024-03-20",
      "exchangeType": "FULL_1035"
    },
    "basisHistory": [
      {
        "date": "2015-06-01",
        "type": "INITIAL_PREMIUM",
        "amount": 200000.00,
        "cumulativeBasis": 200000.00
      },
      {
        "date": "2018-01-15",
        "type": "ADDITIONAL_PREMIUM",
        "amount": 75000.00,
        "cumulativeBasis": 275000.00
      },
      {
        "date": "2022-09-01",
        "type": "WITHDRAWAL_BASIS_REDUCTION",
        "amount": -25000.00,
        "cumulativeBasis": 250000.00
      },
      {
        "date": "2024-03-20",
        "type": "1035_TRANSFER",
        "amount": 250000.00,
        "cumulativeBasis": 250000.00,
        "note": "Basis carried forward per IRC 1035"
      }
    ]
  }
}
```

---

## 12. Pending Case Management

### 12.1 Case Status Tracking

A robust case status model is essential for tracking the progress of each application through the new business pipeline.

**Case Status State Machine:**

```
              ┌──────────────────────────────────────────────────────┐
              │                                                      │
              ▼                                                      │
┌──────────┐     ┌──────────┐     ┌──────────┐     ┌──────────┐    │
│ RECEIVED  │────▶│ IN REVIEW │────▶│ APPROVED  │────▶│  ISSUED  │    │
└──────────┘     └──────────┘     └──────────┘     └──────────┘    │
     │                │                │                │            │
     │                │                │                │            │
     ▼                ▼                │                ▼            │
┌──────────┐     ┌──────────┐        │          ┌──────────┐      │
│   NIGO    │────▶│ PENDING   │────────┘          │ FREE LOOK│──────┘
│           │     │ UW/SUIT   │                   │          │ (cancel)
└──────────┘     └──────────┘                   └──────────┘
     │                │                                │
     │                │                                ▼
     ▼                ▼                          ┌──────────┐
┌──────────┐     ┌──────────┐                   │  ACTIVE   │
│ ABANDONED │     │ DECLINED  │                   │ (IN FORCE)│
└──────────┘     └──────────┘                   └──────────┘
     │                │
     ▼                ▼
┌──────────┐     ┌──────────┐
│ CLOSED -  │     │ CLOSED -  │
│ PREMIUM   │     │ DECLINED  │
│ RETURNED  │     │           │
└──────────┘     └──────────┘
```

**Detailed Status Definitions:**

| Status | Sub-Status | Description |
|---|---|---|
| RECEIVED | DATA_ENTRY | Application received, initial data entry in progress |
| RECEIVED | QC_REVIEW | Data entry complete, quality control review in progress |
| NIGO | NIGO_PENDING | NIGO items identified, correspondence sent, awaiting response |
| NIGO | NIGO_PARTIAL_RESOLVE | Some NIGO items resolved, others still pending |
| IN_REVIEW | SUITABILITY_REVIEW | Under suitability/best interest review |
| IN_REVIEW | AML_REVIEW | Under AML/KYC review |
| IN_REVIEW | UW_REVIEW | Under financial or medical underwriting review |
| IN_REVIEW | REPLACEMENT_REVIEW | Under replacement review |
| IN_REVIEW | COMPLIANCE_REVIEW | Escalated to compliance for review |
| PENDING_FUNDS | AWAITING_CHECK | Approved, awaiting premium check |
| PENDING_FUNDS | AWAITING_WIRE | Approved, awaiting wire transfer |
| PENDING_FUNDS | AWAITING_1035 | Approved, awaiting 1035 exchange proceeds |
| PENDING_FUNDS | AWAITING_ROLLOVER | Approved, awaiting rollover funds |
| APPROVED | PENDING_ISSUE | All requirements met, in issue processing queue |
| ISSUED | IN_FREE_LOOK | Contract issued, within free-look period |
| ISSUED | FREE_LOOK_CANCELLED | Contract cancelled during free-look period |
| ACTIVE | IN_FORCE | Contract fully active, past free-look period |
| DECLINED | SUITABILITY | Declined due to suitability concerns |
| DECLINED | AML | Declined due to AML issues |
| DECLINED | UW | Declined due to underwriting issues |
| ABANDONED | TIMEOUT | Case closed due to inactivity/aging |
| ABANDONED | APPLICANT_WITHDREW | Applicant requested withdrawal |

### 12.2 Pending Requirements Tracking

Each case maintains a list of requirements that must be satisfied before the case can advance.

**Requirements Data Model:**

```json
{
  "caseId": "NB-2024-00012345",
  "requirements": [
    {
      "requirementId": "REQ-001",
      "category": "SIGNATURE",
      "description": "Owner signature on application page 5",
      "status": "OUTSTANDING",
      "dateIdentified": "2024-03-15",
      "dateCorrespondenceSent": "2024-03-15",
      "correspondenceMethod": "EMAIL",
      "correspondenceRecipient": "AGENT",
      "dueDate": "2024-03-25",
      "priority": "HIGH",
      "blocksIssuance": true,
      "autoDetected": true,
      "nigoRuleId": "NIGO-SIG-001"
    },
    {
      "requirementId": "REQ-002",
      "category": "FUNDS",
      "description": "1035 exchange funds from ABC Insurance",
      "status": "IN_PROGRESS",
      "dateIdentified": "2024-03-15",
      "transferLetterSentDate": "2024-03-16",
      "expectedReceiptDate": "2024-04-15",
      "followUpDates": ["2024-03-23", "2024-03-30"],
      "priority": "MEDIUM",
      "blocksIssuance": true,
      "autoDetected": true
    },
    {
      "requirementId": "REQ-003",
      "category": "AML",
      "description": "OFAC screening - potential match requiring analyst review",
      "status": "UNDER_REVIEW",
      "dateIdentified": "2024-03-15",
      "assignedTo": "AML_ANALYST_QUEUE",
      "priority": "HIGH",
      "blocksIssuance": true,
      "autoDetected": true
    }
  ],
  "issuanceReady": false,
  "outstandingCount": 3,
  "resolvedCount": 5,
  "totalRequirements": 8
}
```

### 12.3 Automated Follow-Up

**Follow-Up Engine Architecture:**

```
┌──────────────────────────────────────────────┐
│            Automated Follow-Up Engine          │
│                                               │
│  ┌───────────────┐    ┌────────────────────┐  │
│  │  Scheduling    │    │  Template          │  │
│  │  Engine        │    │  Management        │  │
│  │  (Cron/Event)  │    │                    │  │
│  └───────┬───────┘    └────────┬───────────┘  │
│          │                     │               │
│          ▼                     ▼               │
│  ┌───────────────┐    ┌────────────────────┐  │
│  │  Case Query    │    │  Correspondence    │  │
│  │  (Identify     │    │  Generation        │  │
│  │   follow-up    │    │                    │  │
│  │   candidates)  │    │                    │  │
│  └───────┬───────┘    └────────┬───────────┘  │
│          │                     │               │
│          └─────────┬───────────┘               │
│                    ▼                           │
│           ┌────────────────┐                   │
│           │  Delivery       │                   │
│           │  (Email, Portal,│                   │
│           │   SMS, Mail)    │                   │
│           └────────────────┘                   │
└──────────────────────────────────────────────┘
```

**Follow-Up Rules (Examples):**

| Trigger | Action | Recipient | Channel |
|---|---|---|---|
| NIGO item age > 5 business days | Send follow-up reminder | Agent | Email + Portal |
| NIGO item age > 10 business days | Send second reminder + phone task | Agent | Email + Phone Task |
| 1035 funds not received after 14 days | Call existing carrier for status | Internal Operations | Task Queue |
| 1035 funds not received after 30 days | Notify agent and applicant | Agent + Applicant | Email |
| Suitability review pending > 4 hours | Escalate to supervisor | Supervisor | Work Queue |
| Case age > 30 days, still pending | Generate at-risk report entry | Management | Dashboard/Report |
| Case age > 45 days, still pending | Pre-close notice | Agent + Applicant | Formal Letter |

### 12.4 Case Aging Analytics

**Aging Dashboard Metrics:**

| Metric | Calculation | Alert Threshold |
|---|---|---|
| Average case age (all open cases) | Sum of case ages / count of open cases | >10 business days |
| Case age distribution | Histogram of cases by age buckets (0–5, 6–10, 11–15, 16–20, 21–30, 31–45, 46+) | >15% in 21+ bucket |
| Average time in current status | Time since last status change | >5 days in any review status |
| Longest pending case | Maximum age of any open case | >60 days |
| Cases at risk of abandonment | Cases >30 days with outstanding requirements | Increasing trend |
| Throughput (cases issued per day/week) | Count of cases moving to ISSUED status | Below target |
| Cycle time by channel | Average RECEIVED-to-ISSUED by intake channel | Varies by channel |
| Cycle time by product | Average RECEIVED-to-ISSUED by product type | Varies by product |
| Cycle time by requirement type | Average time to resolve specific requirement types | >5 days for any type |

### 12.5 Case Abandonment Handling

**Abandonment Process:**

```
Case Identified as Abandoned Candidate
(Age > threshold, outstanding requirements, no activity)
         │
         ▼
  Final Notice Generation:
  ├── "Intent to Close" letter to applicant and agent
  ├── Lists outstanding requirements
  ├── Provides deadline (typically 15 days) to respond
  └── Explains premium return process
         │
         ▼
  Wait for Response (15 days)
         │
    ┌────┴────┐
    ▼         ▼
 Response   No Response
 Received     │
    │         ▼
    ▼    Close Case:
 Resume  ├── Set status to ABANDONED
 Processing ├── Calculate premium refund
    │      ├── Include any interest earned while held
           ├── Generate refund check or ACH credit
           ├── Generate closing letter to applicant
           ├── Notify agent
           └── Update pipeline reporting
```

**Premium Return Requirements:**
- Premium held in escrow earns interest at carrier-declared rate
- Interest must be credited upon return (some states mandate minimum interest rate)
- Check issued payable to applicant (or returned via original payment method)
- 1099-INT generated for interest exceeding $10
- For 1035/rollover funds, special handling to avoid tax consequences

### 12.6 Pipeline Reporting

**Daily Pipeline Report Structure:**

```
NEW BUSINESS PIPELINE REPORT - [Date]

SUMMARY:
├── Total Open Cases:           1,247
├── New Cases Today:              87
├── Cases Issued Today:           63
├── Cases Abandoned/Closed Today:  12
├── Premium in Pipeline:    $432.7M
└── Average Case Age:          8.3 days

STATUS BREAKDOWN:
├── RECEIVED:           142  (11.4%)
├── NIGO:               387  (31.0%)
├── IN REVIEW:          218  (17.5%)
│   ├── Suitability:     89
│   ├── AML:             43
│   ├── Underwriting:    52
│   └── Compliance:      34
├── PENDING FUNDS:      289  (23.2%)
│   ├── Awaiting Check:  67
│   ├── Awaiting Wire:   23
│   ├── Awaiting 1035:  156
│   └── Awaiting Rollover: 43
├── APPROVED/PENDING ISSUE: 211  (16.9%)
└── AT RISK (>30 days):   87   (7.0%)

AGING DISTRIBUTION:
├── 0-5 days:    389  (31.2%)
├── 6-10 days:   321  (25.7%)
├── 11-15 days:  198  (15.9%)
├── 16-20 days:  142  (11.4%)
├── 21-30 days:  110   (8.8%)
├── 31-45 days:   62   (5.0%)
└── 46+ days:     25   (2.0%)
```

---

## 13. Broker-Dealer Integration

### 13.1 Selling Agreements

A selling agreement (or distribution agreement) is the legal contract between the annuity carrier (manufacturer) and the broker-dealer (distributor) that governs the terms under which the broker-dealer can sell the carrier's products.

**Selling Agreement Data Elements Relevant to Systems:**

| Element | System Impact |
|---|---|
| Approved product list | Product shelf configuration — which products the B/D can sell |
| Commission schedules | Commission grid by product, premium band, qualification level |
| Suitability overlay requirements | Additional suitability rules beyond carrier and regulatory requirements |
| Supervisory requirements | Approval workflow configuration (which transactions require OSJ approval) |
| Data exchange agreements | Technical integration specifications (API, DTCC, file-based) |
| Service level commitments | SLA configuration for processing B/D submissions |
| Training requirements | Agent qualification tracking and enforcement |
| Marketing material approval | Content management integration |

### 13.2 Product Shelf Management

**Product Shelf Configuration:**

```json
{
  "brokerDealer": {
    "bdId": "BD-12345",
    "bdName": "National Securities Corp",
    "productShelf": [
      {
        "productCode": "VA-GROWTH-2024",
        "productName": "Growth Variable Annuity",
        "approvalStatus": "APPROVED",
        "effectiveDate": "2024-01-01",
        "expirationDate": null,
        "approvedStates": ["ALL_EXCEPT_NY"],
        "approvedRiders": ["GLWB-PLUS", "GMDB-ENHANCED"],
        "restrictedRiders": ["GMIB-LEGACY"],
        "minimumPremium": 25000,
        "maximumPremium": 2000000,
        "commissionScheduleId": "COMM-VA-GROWTH-BD12345",
        "firmSpecificSuitabilityRules": ["SUIT-BD12345-001", "SUIT-BD12345-002"],
        "trainingRequired": true,
        "trainingCompletionRequired": true
      }
    ]
  }
}
```

### 13.3 Order Entry Integration

**Integration Patterns by Broker-Dealer Type:**

| B/D Type | Typical Integration | Data Format | Frequency |
|---|---|---|---|
| Wirehouse (Merrill, Morgan Stanley) | Proprietary API or DTCC | Carrier-specific or ACORD XML | Real-time or batch |
| Regional B/D | DTCC or e-app platform | ACORD XML | Batch (daily) |
| Independent B/D | E-app platform (Firelight, iPipeline) | ACORD XML or JSON | Real-time |
| RIA/Hybrid | Direct or e-app platform | Varies | Real-time |
| Bank B/D | Proprietary or e-app platform | Varies | Batch or real-time |

### 13.4 Supervisory Approval Workflows

For registered products (Variable Annuities, RILAs), FINRA requires that a registered principal (Series 24 or 26) review and approve each transaction before submission to the carrier.

**Supervisory Review Levels:**

```
Transaction Submitted by Registered Representative
         │
         ▼
  ┌──────────────────┐
  │  Automated        │
  │  Pre-Screening    │
  │  (B/D Rules       │
  │   Engine)         │
  └────────┬─────────┘
           │
      ┌────┴────┐
      ▼         ▼
   Auto-     Flagged for
   Approve   Manual Review
   (low risk)     │
      │           ▼
      │    ┌──────────────┐
      │    │  Branch/OSJ   │
      │    │  Supervisor   │
      │    │  (Registered  │
      │    │   Principal)  │
      │    └──────┬───────┘
      │           │
      │      ┌────┴────┐
      │      ▼         ▼
      │   Approve   Escalate to
      │      │      Home Office
      │      │         │
      │      │         ▼
      │      │   ┌──────────────┐
      │      │   │  B/D Home     │
      │      │   │  Office       │
      │      │   │  Compliance   │
      │      │   └──────┬───────┘
      │      │          │
      │      │     ┌────┴────┐
      │      │     ▼         ▼
      │      │  Approve   Reject
      │      │     │         │
      └──────┴─────┘         ▼
             │          Return to Rep
             ▼          with explanation
      Submit to Carrier
```

### 13.5 Firm-Level Suitability Overlays

Many broker-dealers impose additional suitability requirements beyond the regulatory minimum and the carrier's own requirements.

**Common Firm-Level Overlays:**

| Overlay Rule | Description | Example |
|---|---|---|
| Maximum age restriction | Firm restricts maximum issue age below product maximum | Product allows 90; firm restricts to 80 |
| Concentration limits | Maximum percentage of liquid net worth in annuities | 50% maximum (firm-specific) |
| Product restrictions | Firm may not allow certain products or riders | No L-share products for investors over 70 |
| Enhanced suitability questionnaire | Additional questions beyond standard | Additional risk tolerance assessment |
| Account type restrictions | Firm may restrict certain account types | No non-qualified variable annuities for investors under certain net worth |
| Replacement restrictions | Enhanced replacement review | Mandatory supervisor approval for all replacements |

### 13.6 Commission Grid Management

**Commission Data Model:**

```json
{
  "commissionGrid": {
    "gridId": "COMM-VA-GROWTH-BD12345",
    "productCode": "VA-GROWTH-2024",
    "brokerDealerId": "BD-12345",
    "effectiveDate": "2024-01-01",
    "schedules": [
      {
        "shareClass": "B-SHARE",
        "commissionType": "FIRST_YEAR",
        "tiers": [
          { "premiumMin": 0, "premiumMax": 99999.99, "rate": 5.50 },
          { "premiumMin": 100000, "premiumMax": 499999.99, "rate": 5.00 },
          { "premiumMin": 500000, "premiumMax": 999999.99, "rate": 4.50 },
          { "premiumMin": 1000000, "premiumMax": null, "rate": 4.00 }
        ]
      },
      {
        "shareClass": "B-SHARE",
        "commissionType": "TRAIL",
        "tiers": [
          { "year": 2, "rate": 0.25 },
          { "year": 3, "rate": 0.25 },
          { "year": 4, "rate": 0.25 },
          { "yearMin": 5, "yearMax": null, "rate": 0.25 }
        ]
      },
      {
        "shareClass": "L-SHARE",
        "commissionType": "FIRST_YEAR",
        "tiers": [
          { "premiumMin": 0, "premiumMax": null, "rate": 3.50 }
        ]
      },
      {
        "shareClass": "L-SHARE",
        "commissionType": "TRAIL",
        "tiers": [
          { "year": 2, "rate": 0.50 },
          { "yearMin": 3, "yearMax": null, "rate": 0.50 }
        ]
      }
    ],
    "overrides": [
      {
        "level": "IMO",
        "entityId": "IMO-67890",
        "overrideRate": 1.00,
        "commissionType": "FIRST_YEAR"
      },
      {
        "level": "GA",
        "entityId": "GA-11111",
        "overrideRate": 0.50,
        "commissionType": "FIRST_YEAR"
      }
    ],
    "chargebacks": {
      "chargebackPeriodMonths": 12,
      "chargebackSchedule": [
        { "monthMin": 0, "monthMax": 6, "chargebackRate": 100 },
        { "monthMin": 7, "monthMax": 12, "chargebackRate": 50 }
      ]
    }
  }
}
```

---

## 14. Straight-Through Processing (STP)

### 14.1 STP Definition & Goals

Straight-Through Processing (STP) in annuity new business refers to the end-to-end automated processing of an application from receipt through policy issue without any manual intervention.

**STP Benefits:**
- Reduced processing cost ($10–$30 per STP case vs. $150–$300 for manually processed)
- Faster cycle time (same-day or next-day issue vs. 7–14 days)
- Improved customer experience
- Reduced error rates
- Scalability during peak volumes
- Competitive advantage in distribution

### 14.2 STP Eligibility Rules

**STP Eligibility Decision Tree:**

```
Application Received
         │
         ▼
  Channel = E-App?
  ├── No ──▶ NOT STP ELIGIBLE (paper requires manual data entry)
  └── Yes
         │
         ▼
  All required data present and valid?
  ├── No ──▶ NOT STP ELIGIBLE (NIGO)
  └── Yes
         │
         ▼
  Premium amount ≤ auto-approve threshold?
  ├── No ──▶ NOT STP ELIGIBLE (requires financial underwriting)
  └── Yes
         │
         ▼
  Suitability score ≥ auto-approve threshold?
  ├── No ──▶ NOT STP ELIGIBLE (requires suitability review)
  └── Yes
         │
         ▼
  AML/KYC screening clear (no hits)?
  ├── No ──▶ NOT STP ELIGIBLE (requires AML review)
  └── Yes
         │
         ▼
  No replacement involved?
  ├── No (replacement) ──▶ NOT STP ELIGIBLE (requires replacement review)
  └── Yes (no replacement)
         │
         ▼
  Producer licensed and appointed?
  ├── No ──▶ NOT STP ELIGIBLE (producer issue)
  └── Yes
         │
         ▼
  Funds received (ACH, check, wire)?
  ├── No (1035/Rollover) ──▶ NOT STP ELIGIBLE (awaiting funds)
  └── Yes
         │
         ▼
  Product available in state? All riders valid?
  ├── No ──▶ NOT STP ELIGIBLE (product/state issue)
  └── Yes
         │
         ▼
  ████████ STP ELIGIBLE ████████
  Auto-issue contract
```

### 14.3 STP Rates by Product Type

| Product Type | Typical STP Rate | Best-in-Class STP Rate | Key Barriers to STP |
|---|---|---|---|
| Fixed Annuity (MYGA) | 30–40% | 60–70% | 1035 exchanges (fund wait), paper apps, replacement |
| Fixed Indexed Annuity | 20–30% | 45–55% | Suitability complexity, replacement frequency, paper channel |
| Variable Annuity | 15–25% | 40–50% | Suitability review, replacement, B/D supervisory process |
| RILA | 20–30% | 45–55% | Similar to VA |
| SPIA/DIA | 25–35% | 50–60% | 1035 exchanges, large premium financial UW |

### 14.4 STP Exception Handling

When a case initially qualifies for STP but an exception occurs during automated processing:

**Exception Scenarios & Handling:**

| Exception | Detection Point | Handling |
|---|---|---|
| ACH return/NSF | After ACH origination | Auto-generate NIGO; notify agent; revert STP |
| Late document received | After initial assessment | Re-evaluate STP eligibility; may remain STP if doc resolves cleanly |
| Agent licensing lapse discovered after initial check | During issue processing | Hold issue; notify agent; create licensing requirement |
| Product filing delayed in state | During contract generation | Hold issue; queue for manual review |
| Document composition error | During contract generation | Route to operations for manual contract assembly |
| Concurrent application detected | During duplicate check | Route to underwriting for aggregate review |

### 14.5 STP Monitoring & Reporting

**Key STP Metrics:**

| Metric | Description | Target |
|---|---|---|
| STP Attempt Rate | % of cases evaluated for STP | 80%+ |
| STP Success Rate | % of STP-attempted cases that complete STP | 50%+ |
| STP Failure Reason Distribution | Breakdown of why cases fail STP | Trending toward fewer failures |
| STP Cycle Time | Time from receipt to issue for STP cases | <4 hours |
| STP Dollar Throughput | Total premium processed via STP | Increasing |
| STP Quality Score | % of STP-issued cases with post-issue errors | <1% |
| STP Savings | Cost savings vs. manual processing | Quantified quarterly |

---

## 15. System Architecture for New Business

### 15.1 High-Level Component Architecture

```
┌─────────────────────────────────────────────────────────────────────────┐
│                        NEW BUSINESS PLATFORM                            │
│                                                                         │
│  ┌───────────────────────────────────────────────────────────────────┐  │
│  │                     INTAKE LAYER                                  │  │
│  │  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌────────┐ │  │
│  │  │ E-App    │ │ Paper/   │ │ DTCC     │ │ D2C Web  │ │ Call   │ │  │
│  │  │ Adapter  │ │ Scan     │ │ Adapter  │ │ App      │ │ Center │ │  │
│  │  │ (Firelight│ │ Adapter  │ │          │ │          │ │ App    │ │  │
│  │  │  iPipeline│ │          │ │          │ │          │ │        │ │  │
│  │  │  DocuSign)│ │          │ │          │ │          │ │        │ │  │
│  │  └────┬─────┘ └────┬─────┘ └────┬─────┘ └────┬─────┘ └───┬────┘ │  │
│  └───────┼──────────────┼───────────┼────────────┼───────────┼──────┘  │
│          └──────────────┴───────────┴────────────┴───────────┘         │
│                                     │                                   │
│                                     ▼                                   │
│  ┌───────────────────────────────────────────────────────────────────┐  │
│  │                  CANONICAL DATA SERVICE                           │  │
│  │  (Normalizes all intake formats to canonical case model)          │  │
│  └──────────────────────────┬────────────────────────────────────────┘  │
│                             │                                           │
│                             ▼                                           │
│  ┌───────────────────────────────────────────────────────────────────┐  │
│  │                  ORCHESTRATION / WORKFLOW ENGINE                   │  │
│  │  (BPM: Pega, Appian, Camunda, or custom)                         │  │
│  │  ┌─────────────────────────────────────────────────────────────┐  │  │
│  │  │  Case Creation ──▶ Validation ──▶ Suitability ──▶ AML/KYC  │  │  │
│  │  │       ──▶ Underwriting ──▶ Premium ──▶ Issue ──▶ Delivery   │  │  │
│  │  └─────────────────────────────────────────────────────────────┘  │  │
│  └────────┬────────────┬────────────┬──────────────┬────────────────┘  │
│           │            │            │              │                    │
│           ▼            ▼            ▼              ▼                    │
│  ┌────────────┐ ┌──────────┐ ┌──────────┐ ┌─────────────┐            │
│  │ RULES      │ │ DOCUMENT │ │ INTEGRA- │ │ CASE        │            │
│  │ ENGINE     │ │ MGMT     │ │ TION HUB │ │ DATABASE    │            │
│  │            │ │ (ECM)    │ │          │ │             │            │
│  │ ┌────────┐ │ │          │ │ ┌──────┐ │ │ ┌─────────┐ │            │
│  │ │Suitab. │ │ │ ┌──────┐ │ │ │AML   │ │ │ │Case     │ │            │
│  │ │Rules   │ │ │ │Images│ │ │ │Vendor│ │ │ │State    │ │            │
│  │ ├────────┤ │ │ ├──────┤ │ │ ├──────┤ │ │ ├─────────┤ │            │
│  │ │UW Rules│ │ │ │Docs  │ │ │ │DTCC  │ │ │ │Require- │ │            │
│  │ ├────────┤ │ │ ├──────┤ │ │ ├──────┤ │ │ │ments    │ │            │
│  │ │NIGO    │ │ │ │Contra│ │ │ │Lockbox│ │ │ ├─────────┤ │            │
│  │ │Rules   │ │ │ │cts   │ │ │ ├──────┤ │ │ │Audit    │ │            │
│  │ ├────────┤ │ │ ├──────┤ │ │ │NIPR  │ │ │ │Trail    │ │            │
│  │ │Product │ │ │ │Corresp│ │ │ ├──────┤ │ │ └─────────┘ │            │
│  │ │Rules   │ │ │ │ondence│ │ │ │Bank  │ │ │             │            │
│  │ └────────┘ │ │ └──────┘ │ │ │APIs  │ │ │             │            │
│  └────────────┘ └──────────┘ │ └──────┘ │ └─────────────┘            │
│                              └──────────┘                             │
│                                                                        │
│  ┌───────────────────────────────────────────────────────────────────┐  │
│  │                    POLICY ADMIN SYSTEM INTERFACE                   │  │
│  │  (Issues contract on PAS: FAST, OIPA, LIDP, Sapiens, custom)     │  │
│  └───────────────────────────────────────────────────────────────────┘  │
│                                                                        │
│  ┌───────────────────────────────────────────────────────────────────┐  │
│  │                    ANALYTICS & REPORTING                          │  │
│  │  (Pipeline dashboards, STP metrics, NIGO analytics, SLA tracking) │  │
│  └───────────────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────────────┘
```

### 15.2 Technology Patterns

#### 15.2.1 Event-Driven Architecture

New business processing is inherently event-driven. Key events trigger downstream processing:

**Event Catalog:**

| Event | Publisher | Subscribers |
|---|---|---|
| `application.received` | Intake Service | Case Service, NIGO Engine, AML Service |
| `case.created` | Case Service | Workflow Engine, Notification Service |
| `nigo.identified` | NIGO Engine | Correspondence Service, Case Service |
| `nigo.resolved` | Case Service | Workflow Engine, STP Engine |
| `suitability.completed` | Suitability Engine | Workflow Engine, Case Service |
| `aml.screening.completed` | AML Service | Workflow Engine, Case Service |
| `underwriting.decision` | UW Engine | Workflow Engine, Case Service |
| `premium.received` | Premium Service | Workflow Engine, Case Service, Accounting |
| `premium.matched` | Premium Matching | Workflow Engine, Case Service |
| `contract.generated` | Document Service | Delivery Service, Case Service |
| `policy.issued` | Issue Service | PAS, Notification Service, Commission Service |
| `freelook.expired` | Timer Service | Case Service, PAS |

**Technology Stack for Event-Driven Processing:**

| Component | Options |
|---|---|
| Message Broker | Apache Kafka, Amazon MSK, Azure Event Hubs, RabbitMQ |
| Event Schema Registry | Confluent Schema Registry, AWS Glue Schema Registry |
| Event Processing | Apache Flink, Kafka Streams, AWS Lambda, Spring Cloud Stream |
| Saga Orchestration | Temporal.io, Camunda, AWS Step Functions, custom saga manager |

#### 15.2.2 Microservices Decomposition

**Recommended Service Boundaries:**

```
New Business Microservices
├── nb-intake-service         (Application receipt, normalization, case creation)
├── nb-case-service           (Case CRUD, status management, requirements tracking)
├── nb-workflow-service       (BPM orchestration, task routing, SLA management)
├── nb-suitability-service    (Suitability scoring, Reg BI compliance)
├── nb-aml-service            (CIP, CDD, OFAC, PEP screening, SAR management)
├── nb-underwriting-service   (Financial UW, medical UW, rules engine)
├── nb-premium-service        (Payment processing, matching, allocation)
├── nb-document-service       (Contract generation, correspondence, document management)
├── nb-producer-service       (Licensing, appointment, commission calculation)
├── nb-replacement-service    (Replacement detection, comparison, notification)
├── nb-1035-service           (1035 exchange management, follow-up, cost basis)
├── nb-notification-service   (Email, SMS, portal, mail notifications)
├── nb-analytics-service      (Reporting, dashboards, STP metrics)
└── nb-integration-service    (External system adapters: DTCC, AML vendors, banks)
```

#### 15.2.3 Database Strategy

| Service | Database Type | Rationale |
|---|---|---|
| Case Service | Relational (PostgreSQL, Oracle) | Complex queries, transactional integrity, reporting |
| Document Service | Object Storage (S3) + Metadata DB | Large binary objects, metadata search |
| AML Service | Graph Database (Neo4j) + Relational | Relationship analysis for suspicious activity |
| Analytics Service | Data Warehouse (Snowflake, Redshift) | OLAP queries, historical analysis |
| Workflow Service | Process DB (embedded in BPM) | Process state, task management |
| Rules Engine | Rules Repository (Drools, custom) | Version-controlled rule sets |
| Search/Lookup | Elasticsearch | Full-text search, fuzzy matching |

### 15.3 Scalability Considerations

#### 15.3.1 Horizontal Scaling

| Component | Scaling Strategy |
|---|---|
| Intake Services | Auto-scale based on message queue depth; partition by channel |
| Workflow Engine | Stateless workers with shared process state in DB; scale by task queue depth |
| Rules Engine | Stateless; rules cached in memory; scale by CPU utilization |
| AML Screening | Scale by screening request queue depth; batch optimization for bulk screening |
| Document Generation | Scale by generation queue depth; CPU-intensive; benefit from dedicated compute |
| Premium Matching | Scale by unmatched item queue depth |

#### 15.3.2 Performance Targets

| Operation | Target Latency | Throughput Target |
|---|---|---|
| Application intake (e-app) | <5 seconds for acknowledgment | 500 concurrent submissions |
| NIGO detection | <30 seconds after case creation | Process within intake flow |
| AML screening (real-time) | <3 seconds per name screen | 100 screens/second |
| Suitability scoring | <10 seconds per case | 50 scores/second |
| Contract generation | <60 seconds per contract | 100 contracts/hour |
| End-to-end STP | <15 minutes from receipt to issue | 200 STP cases/hour |
| Batch AML re-screening | Complete full book in <8 hours | 500K screens/night |

### 15.4 Async Processing Patterns

#### 15.4.1 Saga Pattern for New Business

The new business process is a long-running saga that may span minutes (STP) to weeks (complex cases with 1035 exchanges).

**Saga Steps:**

```
NB Saga (Orchestrated)
│
├── Step 1: Create Case
│   ├── Action: Persist case, assign case number
│   └── Compensation: Delete case (if saga fails early)
│
├── Step 2: Validate Application Data
│   ├── Action: Run NIGO rules, validate completeness
│   └── Compensation: Mark case as DATA_INVALID
│
├── Step 3: Screen AML/KYC
│   ├── Action: Submit to AML screening, wait for result
│   └── Compensation: None (screening is idempotent)
│
├── Step 4: Evaluate Suitability
│   ├── Action: Run suitability scoring engine
│   └── Compensation: None (scoring is idempotent)
│
├── Step 5: Underwriting
│   ├── Action: Run UW rules, queue for manual UW if needed
│   └── Compensation: None
│
├── Step 6: Process Premium
│   ├── Action: Match funds, post premium, allocate
│   └── Compensation: Reverse premium posting, return funds
│
├── Step 7: Generate Contract
│   ├── Action: Compose contract document
│   └── Compensation: Mark document as void
│
├── Step 8: Issue Policy
│   ├── Action: Create policy on PAS, activate
│   └── Compensation: Void policy on PAS
│
└── Step 9: Deliver Contract
    ├── Action: Send welcome kit
    └── Compensation: None (delivery cannot be un-sent)
```

#### 15.4.2 Outbox Pattern for Reliable Messaging

To ensure consistency between database state and published events:

```
┌─────────────┐     ┌──────────────┐     ┌──────────────┐
│  Service     │     │  Outbox      │     │  Message     │
│  Logic       │────▶│  Table       │────▶│  Broker      │
│  (DB TX)     │     │  (Same DB TX)│     │  (Kafka)     │
└─────────────┘     └──────────────┘     └──────────────┘

1. Service updates case status AND writes event to outbox table in same DB transaction
2. Outbox poller (or CDC via Debezium) reads outbox and publishes to Kafka
3. Guarantees at-least-once delivery of events
4. Consumers are idempotent
```

### 15.5 Security Architecture

**Security Layers:**

| Layer | Controls |
|---|---|
| **Network** | VPN/private connectivity to DTCC, B/D partners; TLS 1.2+ for all connections; WAF for public endpoints |
| **Authentication** | OAuth 2.0 / OIDC for API access; SAML for SSO with B/D partners; MFA for internal users |
| **Authorization** | RBAC (Role-Based Access Control); ABAC (Attribute-Based) for fine-grained data access (e.g., AML analyst can see AML data but not full SSN) |
| **Data Encryption** | AES-256 at rest; TLS 1.2+ in transit; HSM-managed keys for SSN/TIN encryption |
| **PII Protection** | SSN/TIN tokenization; data masking in non-production environments; PII audit logging |
| **Audit Trail** | Immutable audit log of all data access and modifications; retained per regulatory requirements |
| **Compliance** | SOC 2 Type II certified; PCI-DSS (if accepting payment cards, uncommon for annuities); state insurance data security regulations |

### 15.6 Disaster Recovery & Business Continuity

**RPO/RTO Targets:**

| Component | RPO (Recovery Point Objective) | RTO (Recovery Time Objective) |
|---|---|---|
| Case Database | Near-zero (synchronous replication) | <1 hour |
| Document Repository | <1 hour | <4 hours |
| Workflow Engine | <15 minutes | <2 hours |
| Message Broker | Near-zero (replicated topics) | <30 minutes |
| Integration Services | N/A (stateless) | <1 hour |

---

## 16. Data Models & Schema Patterns

### 16.1 Core Case Entity

```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "title": "NewBusinessCase",
  "type": "object",
  "properties": {
    "caseId": { "type": "string", "pattern": "^NB-\\d{4}-\\d{8}$" },
    "caseStatus": { "type": "string", "enum": ["RECEIVED", "NIGO", "IN_REVIEW", "PENDING_FUNDS", "APPROVED", "ISSUED", "ACTIVE", "DECLINED", "ABANDONED", "CLOSED"] },
    "caseSubStatus": { "type": "string" },
    "receivedDate": { "type": "string", "format": "date-time" },
    "receivedChannel": { "type": "string", "enum": ["PAPER", "E_APP_FIRELIGHT", "E_APP_IPIPELINE", "DTCC", "D2C_WEB", "CALL_CENTER", "BROKER_DEALER_API"] },
    "issueState": { "type": "string", "pattern": "^[A-Z]{2}$" },
    "product": { "$ref": "#/definitions/ProductSelection" },
    "owner": { "$ref": "#/definitions/Owner" },
    "jointOwner": { "$ref": "#/definitions/Owner" },
    "annuitant": { "$ref": "#/definitions/Annuitant" },
    "beneficiaries": { "type": "array", "items": { "$ref": "#/definitions/Beneficiary" } },
    "producers": { "type": "array", "items": { "$ref": "#/definitions/Producer" } },
    "premium": { "$ref": "#/definitions/PremiumDetails" },
    "allocations": { "type": "array", "items": { "$ref": "#/definitions/InvestmentAllocation" } },
    "suitability": { "$ref": "#/definitions/SuitabilityData" },
    "replacement": { "$ref": "#/definitions/ReplacementInfo" },
    "requirements": { "type": "array", "items": { "$ref": "#/definitions/Requirement" } },
    "amlScreening": { "$ref": "#/definitions/AMLScreeningResult" },
    "underwriting": { "$ref": "#/definitions/UnderwritingResult" },
    "suitabilityReview": { "$ref": "#/definitions/SuitabilityReviewResult" },
    "stpEligible": { "type": "boolean" },
    "stpResult": { "$ref": "#/definitions/STPResult" },
    "contractNumber": { "type": "string" },
    "issueDate": { "type": "string", "format": "date" },
    "freeLookExpirationDate": { "type": "string", "format": "date" },
    "auditTrail": { "type": "array", "items": { "$ref": "#/definitions/AuditEntry" } }
  }
}
```

### 16.2 ACORD Data Mapping

For e-application integrations, the ACORD TXLife standard is the dominant data exchange format. Key mapping considerations:

| ACORD Element | NB System Field | Notes |
|---|---|---|
| `OLifE.Party[PartyTypeCode='Person']` | Owner, Annuitant | Role determined by `Relation.RelationRoleCode` |
| `OLifE.Holding.Policy.ApplicationInfo` | Case metadata | Application date, signed date, channel |
| `OLifE.Holding.Policy.Annuity` | Product details | Product code, qualified plan type |
| `OLifE.Holding.Policy.Annuity.Rider` | Rider selections | Rider codes, options |
| `OLifE.Holding.Policy.Annuity.Payout` | Payout options | Annuitization elections |
| `OLifE.Holding.Banking` | Premium funding | ACH details, check info |
| `OLifE.Party.Address` | Address info | CASS-validated |
| `OLifE.Party.Phone` | Phone numbers | By type (home, work, mobile) |
| `OLifE.Party.EMailAddress` | Email | For e-delivery |
| `OLifE.Party.Risk.MedicalExam` | Medical UW data | If applicable |
| `OLifE.Holding.Investment` | Allocations | Sub-account / strategy allocations |

### 16.3 Integration Message Schemas

**Application Receipt Acknowledgment (Carrier to E-App Platform):**

```json
{
  "acknowledgment": {
    "sourceTransactionId": "FL-2024-00098765",
    "carrierCaseId": "NB-2024-00012345",
    "receivedTimestamp": "2024-03-15T14:30:00Z",
    "status": "RECEIVED",
    "validationResult": {
      "valid": true,
      "warnings": [
        {
          "code": "WARN-001",
          "message": "Beneficiary SSN not provided; will be requested as NIGO item"
        }
      ],
      "errors": []
    }
  }
}
```

**Status Update (Carrier to Distributor):**

```json
{
  "statusUpdate": {
    "carrierCaseId": "NB-2024-00012345",
    "distributorReferenceId": "FL-2024-00098765",
    "timestamp": "2024-03-16T09:00:00Z",
    "currentStatus": "NIGO",
    "currentSubStatus": "NIGO_PENDING",
    "outstandingRequirements": [
      {
        "requirementCode": "SIG_OWNER_MISSING",
        "description": "Owner signature required on application page 5",
        "priority": "HIGH"
      }
    ],
    "estimatedIssueDate": null,
    "nextActionBy": "AGENT"
  }
}
```

---

## 17. Regulatory & Compliance Cross-Reference

### 17.1 Federal Regulations

| Regulation | Agency | Applicability | New Business Impact |
|---|---|---|---|
| **Securities Act of 1933** | SEC | Variable annuities, RILAs | Registration, prospectus delivery |
| **Securities Exchange Act of 1934** | SEC | Broker-dealers selling VA/RILA | B/D registration, supervisory requirements |
| **Investment Company Act of 1940** | SEC | Separate accounts for VA | Fund registration, prospectus |
| **Regulation Best Interest** | SEC | All securities recommendations | Best interest standard, Form CRS, care obligation |
| **USA PATRIOT Act** | FinCEN | All annuity issuers | CIP, AML program, SAR reporting |
| **Bank Secrecy Act** | FinCEN | All annuity issuers | Record-keeping, CTR, SAR |
| **FinCEN CDD Rule** | FinCEN | All annuity issuers | Beneficial ownership for entities |
| **OFAC Regulations** | Treasury/OFAC | All annuity issuers | Sanctions screening |
| **IRC Section 72** | IRS | All annuities | Tax treatment, 10% penalty, RMD |
| **IRC Section 1035** | IRS | Tax-free exchanges | Exchange requirements, cost basis transfer |
| **IRC Section 408/408A** | IRS | IRA annuities | IRA contribution/distribution rules |
| **IRC Section 401(a)/403(b)** | IRS | Qualified plan annuities | Plan qualification, contribution limits |
| **ERISA** | DOL | Employer-sponsored plans | Fiduciary standards, spousal consent |
| **SECURE Act / SECURE 2.0** | IRS/DOL | All qualified annuities | RMD age changes, QLAC rules |
| **Gramm-Leach-Bliley Act** | Various | All insurers | Privacy notice requirements |
| **ESIGN Act** | FTC | Electronic applications | Electronic signature/delivery rules |

### 17.2 State Regulation Matrix (Key States)

| Requirement | NY | CA | TX | FL | PA |
|---|---|---|---|---|---|
| **Suitability standard** | Reg 187 (best interest) | Model #275 | Model #275 | Model #275 | Model #275 |
| **Free look (standard)** | 10 days (20 VA) | 10 days | 10 days | 14 days | 10 days |
| **Free look (senior)** | 60 days | 30 days | 20 days | 21 days | 30 days |
| **Replacement regulation** | Reg 60 | CA specific | TX specific | FL specific | PA specific |
| **Premium tax on annuities** | 0% | 2.35% | 0% | 0% | 0% |
| **Data security law** | DFS Reg 500 | CCPA/CPRA | TX Privacy Act | FL SB 262 | PA specific |
| **E-delivery rules** | UETA + state specific | UETA | UETA | UETA | UETA |
| **Special requirements** | Reg 60 replacement comparison, Reg 187 extensive documentation | Senior protections, CA-specific forms | Agent training requirements | Senior protections | Financing replacement provisions |

### 17.3 FINRA Rules (Variable Annuities & RILAs)

| Rule | Description | System Impact |
|---|---|---|
| **FINRA Rule 2111** | Suitability (being phased out in favor of Reg BI) | Suitability checks |
| **FINRA Rule 2330** | Members' Responsibilities Regarding Deferred Variable Annuities | Principal review, wait period, specific suitability factors |
| **FINRA Rule 3110** | Supervision | Supervisory review workflows |
| **FINRA Rule 2210** | Communications with the Public | Marketing material compliance |
| **FINRA Rule 4512** | Customer Account Information | Data retention requirements |
| **FINRA Rule 3310** | AML Compliance Program | AML program requirements |

---

## 18. SLA Targets & Operational Metrics

### 18.1 End-to-End SLA Framework

| Process Stage | SLA Target | Measurement Point |
|---|---|---|
| **Application Receipt to Case Creation** | Same business day | Timestamp of case creation vs. receipt |
| **NIGO Detection** | Within 1 business day of case creation | Time from case creation to NIGO notification sent |
| **NIGO Correspondence Delivery** | Same day as detection (email) / next day (portal) | Correspondence sent timestamp |
| **Suitability Review (auto)** | Within 2 hours of data completeness | Time from data complete to suitability decision |
| **Suitability Review (manual)** | Within 2 business days | Time in supervisor queue |
| **AML/KYC Screening** | Within 4 hours of case creation | Time from case creation to screening result |
| **AML Analyst Review (if hit)** | Within 1 business day | Time in analyst queue |
| **Financial Underwriting (standard)** | Within 1 business day | Time from case eligibility to UW decision |
| **Financial Underwriting (large case)** | Within 3 business days | Time from case eligibility to UW decision |
| **Premium Matching (check)** | Same business day as receipt | Time from lockbox receipt to case match |
| **Premium Matching (wire)** | Same business day as receipt | Time from wire notification to case match |
| **1035 Exchange Follow-Up** | Per follow-up schedule (see Section 11) | Adherence to scheduled follow-ups |
| **Contract Generation** | Within 4 hours of approval | Time from approval to contract PDF ready |
| **Policy Issue** | Same business day as all requirements met | Time from last requirement resolution to issue |
| **Welcome Kit Delivery (electronic)** | Same day as issue | Time from issue to e-delivery |
| **Welcome Kit Delivery (physical)** | Within 3 business days of issue | Ship date vs. issue date |
| **End-to-End (STP)** | Same day | Receipt to issue |
| **End-to-End (no 1035, no UW)** | 3–5 business days | Receipt to issue |
| **End-to-End (with 1035)** | 15–30 business days | Receipt to issue (driven by existing carrier) |

### 18.2 Operational Dashboard KPIs

**Real-Time Dashboard:**

| KPI | Display | Threshold (Red/Yellow/Green) |
|---|---|---|
| Open cases in pipeline | Count + trend | Red: >2000, Yellow: >1500, Green: <1500 |
| Cases received today | Count | Informational |
| Cases issued today | Count vs. target | Red: <50% target, Yellow: 50–80%, Green: >80% |
| STP rate (rolling 7 days) | Percentage | Red: <20%, Yellow: 20–40%, Green: >40% |
| NIGO rate (rolling 7 days) | Percentage | Red: >30%, Yellow: 20–30%, Green: <20% |
| Average case age | Days | Red: >12, Yellow: 8–12, Green: <8 |
| Cases in suitability review queue | Count + avg wait | Red: avg wait >4h, Yellow: 2–4h, Green: <2h |
| Cases in AML review queue | Count + avg wait | Red: avg wait >1d, Yellow: 4–24h, Green: <4h |
| Cases in UW review queue | Count + avg wait | Red: avg wait >3d, Yellow: 1–3d, Green: <1d |
| Unmatched premiums | Count + total $ | Red: >50 or >$5M, Yellow: >25, Green: <25 |
| Cases at risk (>30 days) | Count + % of pipeline | Red: >10%, Yellow: 5–10%, Green: <5% |

### 18.3 Quality Metrics

| Metric | Description | Target |
|---|---|---|
| Data entry accuracy rate | % of fields entered correctly (for paper/call center) | >99% |
| Post-issue error rate | % of issued contracts requiring correction | <1% |
| STP quality score | % of STP cases with no post-issue errors | >99.5% |
| Regulatory filing accuracy | % of regulatory filings (replacements, etc.) submitted correctly | >99.9% |
| Customer complaint rate (NB-related) | Complaints per 1000 new policies | <2 |
| NIGO false positive rate | % of NIGO items that were incorrectly identified | <5% |
| AML false positive rate | % of AML hits that are false positives | Carrier-specific, but tracking trend |

---

## 19. Glossary

| Term | Definition |
|---|---|
| **1035 Exchange** | Tax-free exchange of one annuity or life insurance contract for another, per IRC Section 1035 |
| **AML** | Anti-Money Laundering — regulatory framework to prevent money laundering and terrorist financing |
| **ACORD** | Association for Cooperative Operations Research and Development — industry data standards organization |
| **ACH** | Automated Clearing House — electronic funds transfer network |
| **APS** | Attending Physician Statement — medical records from physician |
| **BSA** | Bank Secrecy Act — federal law requiring financial institutions to assist government in detecting money laundering |
| **CDD** | Customer Due Diligence — process of verifying customer identity and assessing risk |
| **CIP** | Customer Identification Program — minimum identification requirements under PATRIOT Act |
| **CRD** | Central Registration Depository — FINRA database of registered representatives |
| **CTR** | Currency Transaction Report — FinCEN form filed for cash transactions over $10,000 |
| **DIA** | Deferred Income Annuity — annuity with income start date deferred beyond one year from purchase |
| **DTCC** | Depository Trust & Clearing Corporation — financial services infrastructure provider |
| **ECM** | Enterprise Content Management — document and image management platform |
| **EDD** | Enhanced Due Diligence — additional scrutiny for high-risk customers |
| **FBO** | For Benefit Of — designation on checks ensuring proceeds go to named individual/entity |
| **FIA** | Fixed Indexed Annuity — annuity with returns linked to market index but with downside protection |
| **FinCEN** | Financial Crimes Enforcement Network — bureau of US Treasury |
| **FINRA** | Financial Industry Regulatory Authority — self-regulatory organization for broker-dealers |
| **GLWB** | Guaranteed Lifetime Withdrawal Benefit — rider providing guaranteed income for life |
| **GMAB** | Guaranteed Minimum Accumulation Benefit — rider guaranteeing minimum account value |
| **GMDB** | Guaranteed Minimum Death Benefit — rider guaranteeing minimum death benefit amount |
| **GMIB** | Guaranteed Minimum Income Benefit — rider guaranteeing minimum annuitization value |
| **ICR** | Intelligent Character Recognition — technology for reading handwritten text |
| **IMO** | Insurance Marketing Organization — insurance distribution intermediary |
| **IRC** | Internal Revenue Code — US federal tax law |
| **KBA** | Knowledge-Based Authentication — identity verification using personal knowledge questions |
| **KYC** | Know Your Customer — customer identification and verification requirements |
| **MICR** | Magnetic Ink Character Recognition — technology for reading characters on checks |
| **MYGA** | Multi-Year Guaranteed Annuity — fixed annuity with guaranteed interest rate for multiple years |
| **NAIC** | National Association of Insurance Commissioners — organization of state insurance regulators |
| **NACHA** | National Automated Clearing House Association — governs ACH network |
| **NIGO** | Not In Good Order — application that is incomplete or has errors |
| **NIPR** | National Insurance Producer Registry — state insurance licensing database |
| **NPN** | National Producer Number — unique identifier for insurance producers |
| **NSCC** | National Securities Clearing Corporation — subsidiary of DTCC |
| **OCR** | Optical Character Recognition — technology for reading printed text from images |
| **OFAC** | Office of Foreign Assets Control — US Treasury bureau administering sanctions |
| **OMR** | Optical Mark Recognition — technology for reading checkboxes and bubbles |
| **OSJ** | Office of Supervisory Jurisdiction — FINRA-registered branch office |
| **PAS** | Policy Administration System — core system for managing insurance contracts |
| **PEP** | Politically Exposed Person — individual with elevated corruption/ML risk due to position |
| **QLAC** | Qualified Longevity Annuity Contract — DIA within a qualified plan, exempt from certain RMD rules |
| **RDC** | Remote Deposit Capture — electronic check deposit technology |
| **Reg BI** | Regulation Best Interest — SEC regulation establishing best interest standard |
| **RILA** | Registered Index-Linked Annuity — registered product with index-linked returns and buffer/floor protection |
| **RMD** | Required Minimum Distribution — mandatory annual distributions from qualified accounts |
| **SAR** | Suspicious Activity Report — filed with FinCEN when suspicious activity detected |
| **SDN** | Specially Designated Nationals — OFAC sanctions list |
| **SPIA** | Single Premium Immediate Annuity — annuity purchased with single premium, income starts immediately |
| **STP** | Straight-Through Processing — fully automated processing without manual intervention |
| **TEL** | Transfer/Exchange Letter — letter requesting 1035 exchange from existing carrier |
| **TIN** | Taxpayer Identification Number — SSN for individuals, EIN for entities |
| **TXLife** | ACORD standard for life and annuity data exchange |
| **UTMA/UGMA** | Uniform Transfer/Gifts to Minors Act — custodial account framework |
| **VA** | Variable Annuity — annuity with investment in securities sub-accounts |

---

*This document is intended as a comprehensive technical reference for solution architects designing and implementing new business processing systems in the annuity domain. It should be supplemented with carrier-specific requirements, current regulatory guidance, and vendor documentation for specific technology platforms. Regulatory requirements are subject to change; always verify current rules with legal and compliance counsel.*

---

**Document Version:** 1.0
**Last Updated:** April 2026
**Classification:** Internal — Technical Reference
