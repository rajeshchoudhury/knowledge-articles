# Article 4: Data Standards in Life Insurance Claims

## ACORD, HL7, FHIR, NAIC, ISO 20022, and Industry Data Standards

---

## 1. Introduction

Life insurance claims processing requires the exchange of data between numerous systems, organizations, and regulatory bodies. Industry data standards provide the common language that enables interoperability. For a solutions architect, deep knowledge of these standards is essential for designing systems that can communicate effectively with the broader insurance ecosystem.

This article provides an exhaustive reference to every major data standard relevant to life insurance claims.

---

## 2. ACORD Standards

### 2.1 Overview

ACORD (Association for Cooperative Operations Research and Development) is the global standards-setting body for the insurance, reinsurance, and related financial services industries. ACORD standards are the backbone of insurance data exchange in North America and increasingly worldwide.

### 2.2 ACORD Standard Families

| Standard Family | Format | Primary Use | Claims Relevance |
|---|---|---|---|
| **ACORD Forms** | PDF/paper forms | Standardized insurance forms | Claim forms, APS forms |
| **ACORD AL3** | Fixed-length flat file | Legacy data exchange | Declining use, still in some legacy systems |
| **ACORD XML (Life)** | XML | Life insurance transactions | Primary standard for life claims data exchange |
| **ACORD JSON** | JSON | Modern API-based exchange | Emerging for real-time integrations |
| **ACORD Data Model** | Conceptual/logical model | Canonical data reference | Foundation for system design |
| **ACORD LOMA** | Various | Shared with LOMA for life standards | Life-specific coding standards |

### 2.3 ACORD Life XML Standard

The ACORD Life XML standard defines messages for life insurance transactions, including claims.

#### 2.3.1 Key Message Types for Claims

| Transaction Code | Message Type | Description |
|---|---|---|
| **1203** | OLI_TRANS_CLAIM_SUBMIT | Submit a new claim |
| **1204** | OLI_TRANS_CLAIM_STATUS | Claim status inquiry/update |
| **1205** | OLI_TRANS_CLAIM_PAYMENT | Claim payment notification |
| **1125** | OLI_TRANS_POLSVC | Policy service transaction (for claim-related policy changes) |
| **1122** | OLI_TRANS_INQPOL | Policy inquiry (for claim verification) |

#### 2.3.2 ACORD Life XML Claim Structure

```xml
<?xml version="1.0" encoding="UTF-8"?>
<TXLife xmlns="http://ACORD.org/Standards/Life/2">
  <TXLifeRequest>
    <TransRefGUID>a1b2c3d4-e5f6-7890-abcd-ef1234567890</TransRefGUID>
    <TransType tc="1203">Claim Submit</TransType>
    <TransExeDate>2025-12-03</TransExeDate>
    <TransExeTime>10:30:00</TransExeTime>
    
    <OLifE>
      <!-- POLICY INFORMATION -->
      <Holding id="Policy_1">
        <HoldingTypeCode tc="2">Policy</HoldingTypeCode>
        <Policy>
          <PolNumber>LIF-2020-001234</PolNumber>
          <ProductType tc="1">Life</ProductType>
          <PolicyStatus tc="1">Active</PolicyStatus>
          <EffDate>2020-01-15</EffDate>
          <FaceAmt>500000.00</FaceAmt>
          
          <Life>
            <Coverage>
              <IndicatorCode tc="1">Base</IndicatorCode>
              <CurrentAmt>500000.00</CurrentAmt>
              <LifeParticipant>
                <ParticipantName>John Smith</ParticipantName>
                <LifeParticipantRoleCode tc="1">Insured</LifeParticipantRoleCode>
              </LifeParticipant>
            </Coverage>
          </Life>
        </Policy>
      </Holding>
      
      <!-- CLAIM INFORMATION -->
      <Claim>
        <ClaimNumber>CLM-2025-00789</ClaimNumber>
        <ClaimType tc="1">Death Claim</ClaimType>
        <ClaimStatus tc="1">Submitted</ClaimStatus>
        <DateOfClaim>2025-12-01</DateOfClaim>
        <ReceivedDate>2025-12-03</ReceivedDate>
        
        <!-- Loss/Death Information -->
        <LossInfo>
          <LossDate>2025-12-01</LossDate>
          <CauseOfLoss tc="1">Natural</CauseOfLoss>
          <MannerOfDeath tc="1">Natural</MannerOfDeath>
          <PlaceOfDeath>Memorial Hospital, Springfield, IL</PlaceOfDeath>
          <DeathCertificateNumber>2025-IL-12345</DeathCertificateNumber>
        </LossInfo>
        
        <!-- Claimant Information -->
        <ClaimParty>
          <PartyTypeCode tc="1">Person</PartyTypeCode>
          <ClaimPartyRoleCode tc="1">Claimant</ClaimPartyRoleCode>
          <Person>
            <FirstName>Jane</FirstName>
            <LastName>Smith</LastName>
            <BirthDate>1967-05-22</BirthDate>
            <GovtID>987-65-4321</GovtID>
            <GovtIDTC tc="1">SSN</GovtIDTC>
          </Person>
          <Address>
            <Line1>123 Main Street</Line1>
            <City>Springfield</City>
            <AddressState tc="IL">Illinois</AddressState>
            <Zip>62701</Zip>
          </Address>
          <Phone>
            <PhoneTypeCode tc="1">Home</PhoneTypeCode>
            <AreaCode>217</AreaCode>
            <DialNumber>5551234</DialNumber>
          </Phone>
          <EMailAddress>
            <AddrLine>jane.smith@email.com</AddrLine>
          </EMailAddress>
        </ClaimParty>
        
        <!-- Payment Preference -->
        <ClaimPayment>
          <PaymentMethodCode tc="2">EFT</PaymentMethodCode>
          <Banking>
            <BankName>First National Bank</BankName>
            <RoutingNum>123456789</RoutingNum>
            <AccountNum>9876543210</AccountNum>
            <BankAcctType tc="1">Checking</BankAcctType>
          </Banking>
        </ClaimPayment>
      </Claim>
      
      <!-- INSURED PERSON (Deceased) -->
      <Party id="Insured_1">
        <PartyTypeCode tc="1">Person</PartyTypeCode>
        <Person>
          <FirstName>John</FirstName>
          <LastName>Smith</LastName>
          <BirthDate>1965-03-15</BirthDate>
          <GovtID>123-45-6789</GovtID>
          <GovtIDTC tc="1">SSN</GovtIDTC>
          <Gender tc="1">Male</Gender>
        </Person>
      </Party>
    </OLifE>
  </TXLifeRequest>
</TXLife>
```

### 2.4 ACORD Type Codes (TC) for Claims

ACORD uses numeric Type Codes (tc) to standardize enumerated values:

| Domain | Example TCs | Values |
|---|---|---|
| **ClaimType** | tc="1" Death, tc="2" Disability, tc="3" AD&D, tc="4" ADB | Identifies type of claim |
| **ClaimStatus** | tc="1" Submitted, tc="2" Pending, tc="3" Under Review, tc="4" Approved, tc="5" Denied, tc="6" Paid, tc="7" Closed | Lifecycle status |
| **MannerOfDeath** | tc="1" Natural, tc="2" Accident, tc="3" Suicide, tc="4" Homicide, tc="5" Undetermined, tc="6" Pending Investigation | How the person died |
| **CauseOfLoss** | Various codes for specific causes | What caused the death |
| **PaymentMethod** | tc="1" Check, tc="2" EFT/ACH, tc="3" Wire Transfer | How to pay the beneficiary |
| **BeneficiaryType** | tc="1" Primary, tc="2" Contingent, tc="3" Tertiary | Beneficiary priority |
| **PolicyStatus** | tc="1" Active, tc="2" Lapsed, tc="3" Surrendered, tc="4" Paid-Up, tc="5" Extended Term | Policy state at time of claim |
| **RelationshipRole** | tc="1" Spouse, tc="2" Child, tc="3" Parent, tc="4" Sibling, tc="5" Other Family, tc="6" Trust, tc="7" Estate | Claimant's relationship |

### 2.5 ACORD Forms for Life Claims

| Form Number | Name | Purpose |
|---|---|---|
| **ACORD 800** | Life Insurance Claim | Standard claim form |
| **ACORD 801** | Attending Physician's Statement | Medical information from treating physician |
| **ACORD 802** | Employer's Statement | Group life claim employer certification |
| **ACORD 803** | Claimant's Authorization | HIPAA authorization and consent |
| **ACORD 810** | AD&D Claim | Accidental death/dismemberment claim |

---

## 3. HL7 and FHIR Standards

### 3.1 Relevance to Life Insurance Claims

Health Level Seven (HL7) standards are primarily used in healthcare, but they are increasingly relevant to life insurance claims for:

- Exchanging medical records (Attending Physician's Statements)
- Accessing Electronic Health Records (EHR) for contestability investigations
- Death notification from healthcare facilities
- Accelerated Death Benefit and Critical Illness claim medical evidence

### 3.2 HL7 V2.x Messages

Legacy HL7 V2 messages that may be encountered:

| Message Type | Trigger | Relevance |
|---|---|---|
| **ADT (Admit/Discharge/Transfer)** | Patient admitted, discharged, or died | Death notification from hospital |
| **ORU (Observation Result)** | Lab results, pathology | Toxicology, autopsy results |
| **MDM (Medical Document Management)** | Medical documents | Attending physician statements |

### 3.3 HL7 FHIR (Fast Healthcare Interoperability Resources)

FHIR is the modern standard for healthcare data exchange and is increasingly adopted for insurance-healthcare interoperability.

#### 3.3.1 FHIR Resources Relevant to Life Claims

| FHIR Resource | Claims Use Case |
|---|---|
| **Patient** | Insured person demographics, matching to death records |
| **Practitioner** | Attending physician identification |
| **Condition** | Medical conditions (for ADB, CI, contestability) |
| **Procedure** | Medical procedures (for investigation) |
| **Observation** | Lab results, vital signs |
| **DiagnosticReport** | Autopsy, toxicology reports |
| **DocumentReference** | Medical document references |
| **Composition** | Structured medical summaries |
| **Claim** | FHIR Claim resource (primarily health insurance, but evolving) |
| **MedicationRequest** | Prescription history (contestability investigation) |

#### 3.3.2 FHIR Patient Resource Example (for Death Notification)

```json
{
  "resourceType": "Patient",
  "id": "insured-12345",
  "identifier": [
    {
      "type": {
        "coding": [
          {
            "system": "http://terminology.hl7.org/CodeSystem/v2-0203",
            "code": "SS"
          }
        ]
      },
      "system": "http://hl7.org/fhir/sid/us-ssn",
      "value": "123-45-6789"
    }
  ],
  "name": [
    {
      "use": "official",
      "family": "Smith",
      "given": ["John", "Michael"]
    }
  ],
  "gender": "male",
  "birthDate": "1965-03-15",
  "deceasedDateTime": "2025-12-01T14:30:00-06:00",
  "address": [
    {
      "use": "home",
      "line": ["456 Oak Avenue"],
      "city": "Springfield",
      "state": "IL",
      "postalCode": "62701"
    }
  ]
}
```

#### 3.3.3 FHIR Integration Patterns for Claims

```
PATTERN 1: ELECTRONIC DEATH REGISTRATION SYSTEM (EDRS) INTEGRATION
  ├── State vital records offices are modernizing to FHIR
  ├── Real-time death notification via FHIR subscription
  ├── Replaces batch DMF matching with event-driven notification
  └── Standard: HL7 Vital Records Death Reporting FHIR IG

PATTERN 2: MEDICAL RECORDS RETRIEVAL
  ├── FHIR APIs on EHR systems (Epic, Cerner, etc.)
  ├── Patient Access API (CMS Interoperability Rule)
  ├── Retrieve conditions, medications, procedures
  └── Used for contestability investigation, ADB claims

PATTERN 3: PRESCRIPTION DRUG HISTORY
  ├── FHIR MedicationRequest resources
  ├── Pharmacy Benefit Manager (PBM) FHIR APIs
  ├── Used for contestability investigation
  └── Compare Rx history to application disclosures
```

### 3.4 ICD-10 (International Classification of Diseases)

ICD-10 codes are critical for life claims as they appear on death certificates and medical records.

| ICD-10 Category | Code Range | Examples Relevant to Claims |
|---|---|---|
| **Certain infectious diseases** | A00-B99 | HIV/AIDS, Tuberculosis |
| **Neoplasms** | C00-D49 | Cancer (all types) |
| **Diseases of circulatory system** | I00-I99 | Heart attack (I21), Stroke (I63), Heart failure (I50) |
| **Diseases of respiratory system** | J00-J99 | Pneumonia, COPD, COVID-19 |
| **External causes of morbidity** | V00-Y99 | Accidents (V-X), Assault (X92-Y09), Self-harm (X71-X83) |
| **Factors influencing health** | Z00-Z99 | Medical history factors |

---

## 4. NAIC Standards and Reporting

### 4.1 Overview

The National Association of Insurance Commissioners (NAIC) establishes standards that affect how carriers report and manage claims data.

### 4.2 NAIC Annual Statement

Life insurers must file an Annual Statement with the NAIC containing detailed claims data:

| Schedule/Exhibit | Content | Claims Data |
|---|---|---|
| **Exhibit 8** | Aggregate Reserve for Life Policies | Claims reserve data |
| **Exhibit 11** | Premiums and Annuity Considerations | Claims paid vs. premiums |
| **Schedule S** | Reinsurance | Reinsured claims |
| **General Interrogatories** | Operations questions | Claims operations info |

### 4.3 NAIC Market Conduct Standards

| Standard Area | Requirements |
|---|---|
| **Claims Handling** | Timeliness, fairness, documentation standards |
| **Unfair Claims Practices** | Prohibited practices in claims handling |
| **DMF Matching** | Requirements for proactive death notification matching |
| **Escheatment** | Unclaimed property reporting standards |
| **Complaint Handling** | Standards for handling regulatory complaints |

### 4.4 NAIC Coding Standards

| Code Set | Purpose | Examples |
|---|---|---|
| **NAIC Company Code** | Unique identifier for each insurer | 5-digit codes |
| **Line of Business Codes** | Classify insurance products | Life, Annuity, Health, etc. |
| **State Codes** | Jurisdiction identification | Two-letter state codes |
| **Transaction Codes** | Classify financial transactions | Premium, claim, dividend, etc. |

---

## 5. ISO 20022 Financial Messaging

### 5.1 Relevance to Life Claims

ISO 20022 is the global standard for financial messaging. It is relevant to life claims for:

- Payment processing (claim benefit payments)
- Bank account verification
- Wire transfer instructions
- International payment processing

### 5.2 Key ISO 20022 Message Types

| Message Type | Code | Use in Claims |
|---|---|---|
| **Customer Credit Transfer** | pain.001 | Initiate benefit payment (EFT/Wire) |
| **Payment Status Report** | pain.002 | Confirm payment status |
| **Bank-to-Customer Statement** | camt.053 | Reconcile claim payments |
| **Account Reporting** | camt.052 | Real-time payment confirmation |
| **Payment Return** | pacs.004 | Handle returned/rejected payments |

### 5.3 Payment Initiation Message (pain.001) Example

```xml
<Document xmlns="urn:iso:std:iso:20022:tech:xsd:pain.001.001.09">
  <CstmrCdtTrfInitn>
    <GrpHdr>
      <MsgId>CLAIM-PAY-2025-001234</MsgId>
      <CreDtTm>2025-12-05T10:00:00</CreDtTm>
      <NbOfTxs>1</NbOfTxs>
      <CtrlSum>500410.96</CtrlSum>
      <InitgPty>
        <Nm>ABC Life Insurance Company</Nm>
        <Id>
          <OrgId>
            <Othr>
              <Id>NAIC-12345</Id>
            </Othr>
          </OrgId>
        </Id>
      </InitgPty>
    </GrpHdr>
    <PmtInf>
      <PmtInfId>CLM-2025-00789-PAY</PmtInfId>
      <PmtMtd>TRF</PmtMtd>
      <NbOfTxs>1</NbOfTxs>
      <PmtTpInf>
        <SvcLvl>
          <Cd>NORM</Cd>
        </SvcLvl>
      </PmtTpInf>
      <ReqdExctnDt>
        <Dt>2025-12-06</Dt>
      </ReqdExctnDt>
      <Dbtr>
        <Nm>ABC Life Insurance Company</Nm>
      </Dbtr>
      <DbtrAcct>
        <Id>
          <IBAN>US33XXX1234567890123456789</IBAN>
        </Id>
      </DbtrAcct>
      <CdtTrfTxInf>
        <PmtId>
          <EndToEndId>CLM-2025-00789</EndToEndId>
        </PmtId>
        <Amt>
          <InstdAmt Ccy="USD">500410.96</InstdAmt>
        </Amt>
        <Cdtr>
          <Nm>Jane Smith</Nm>
        </Cdtr>
        <CdtrAcct>
          <Id>
            <Othr>
              <Id>9876543210</Id>
            </Othr>
          </Id>
        </CdtrAcct>
        <RmtInf>
          <Ustrd>Life Insurance Death Benefit - Policy LIF-2020-001234</Ustrd>
        </RmtInf>
      </CdtTrfTxInf>
    </PmtInf>
  </CstmrCdtTrfInitn>
</Document>
```

---

## 6. EDI (Electronic Data Interchange)

### 6.1 ANSI X12 Transaction Sets

While newer standards are emerging, EDI is still used in some legacy integrations:

| Transaction Set | Name | Claims Use |
|---|---|---|
| **820** | Payment Order/Remittance Advice | Claim payment remittance |
| **834** | Benefit Enrollment/Maintenance | Group life enrollment (affects coverage verification) |
| **837** | Healthcare Claim | Health-related claims (not primary for life death claims) |
| **997/999** | Functional Acknowledgment | Confirm receipt of EDI transactions |
| **Custom** | Carrier-specific formats | Legacy system integrations |

### 6.2 DTCC (Depository Trust & Clearing Corporation)

DTCC provides automated processing for insurance transactions:

| Service | Description | Claims Relevance |
|---|---|---|
| **DTCC Insurance & Retirement Services** | Automated processing between carriers and distributors | Commission and benefit processing |
| **NSCC** | National Securities Clearing Corporation | Variable life/annuity sub-account processing |

---

## 7. Death Reporting Standards

### 7.1 Vital Records / Death Certificate Standards

| Standard | Issuing Body | Description |
|---|---|---|
| **US Standard Certificate of Death** | NCHS/CDC | Standard format for US death certificates |
| **EDRS** | State vital records offices | Electronic Death Registration System standards |
| **IJE (Interjurisdictional Exchange)** | NCHS | Standard format for electronic death data exchange between states |
| **VRDR FHIR IG** | HL7 | Vital Records Death Reporting Implementation Guide (FHIR-based) |

### 7.2 IJE (Interjurisdictional Exchange) Format

The IJE format is a fixed-length record format used to exchange death data between jurisdictions:

```
IJE DEATH RECORD LAYOUT (Key Fields):
Position  Length  Field Name                  Example
1-12      12      State File Number           2025IL012345
13-16     4       Void Flag                   0000
17-20     4       Auxiliary State File Number  0000
...
60-69     10      Decedent's SSN              123456789
70-119    50      Decedent's Legal Name       SMITH, JOHN MICHAEL
120-127   8       Date of Death               20251201
128-135   8       Date of Birth               19650315
136       1       Sex                         M
...
200-249   50      Cause of Death Line A       ACUTE MYOCARDIAL INFARCTION
250-299   50      Cause of Death Line B       CORONARY ARTERY DISEASE
300-349   50      Cause of Death Line C       
350-399   50      Cause of Death Line D       
400       1       Manner of Death             N (Natural)
...
```

### 7.3 VRDR FHIR Implementation Guide

The emerging standard for electronic death reporting uses FHIR:

```json
{
  "resourceType": "Bundle",
  "type": "document",
  "entry": [
    {
      "resource": {
        "resourceType": "Composition",
        "type": {
          "coding": [
            {
              "system": "http://loinc.org",
              "code": "64297-5",
              "display": "Death certificate"
            }
          ]
        },
        "subject": {
          "reference": "Patient/decedent-12345"
        },
        "section": [
          {
            "code": {
              "coding": [
                {
                  "system": "http://build.fhir.org/ig/HL7/vrdr",
                  "code": "DecedentDemographics"
                }
              ]
            }
          },
          {
            "code": {
              "coding": [
                {
                  "system": "http://build.fhir.org/ig/HL7/vrdr",
                  "code": "DeathInvestigation"
                }
              ]
            }
          },
          {
            "code": {
              "coding": [
                {
                  "system": "http://build.fhir.org/ig/HL7/vrdr",
                  "code": "CauseOfDeath"
                }
              ]
            }
          }
        ]
      }
    }
  ]
}
```

---

## 8. Tax Reporting Standards

### 8.1 IRS Forms and Formats

| Form | Purpose | When Required |
|---|---|---|
| **1099-R** | Distributions from pensions, annuities, insurance contracts | Annuity death claims, taxable distributions |
| **1099-INT** | Interest income | Interest paid on delayed death benefit payments |
| **1099-LTC** | Long-term care and accelerated death benefits | Accelerated death benefit payments (over per diem limits) |
| **1099-MISC** | Miscellaneous income | Certain settlement payments |
| **5498** | IRA contribution information | Relevant for IRA beneficiary rollovers |

### 8.2 IRS Electronic Filing Standards

| Standard | Description |
|---|---|
| **FIRE System** | Filing Information Returns Electronically (IRS system for 1099 filing) |
| **Publication 1220** | Specifications for electronic filing of 1099 series |
| **TIN Matching** | IRS TIN matching service to verify SSN/EIN |

---

## 9. Reinsurance Data Standards

### 9.1 ACORD Reinsurance Standards

| Standard | Description |
|---|---|
| **ACORD RLC** | Reinsurance and Large Commercial standards |
| **ACORD RIMS** | Reinsurance messaging standards |
| **ACORD Reinsurance XML** | XML schema for reinsurance transactions |
| **ACORD Jv-Ins** | Joint venture insurance data exchange |

### 9.2 Reinsurance Claim Reporting Elements

```
REINSURANCE CLAIM REPORT:
  Treaty Information:
    - Treaty Number
    - Treaty Type (Proportional, Non-Proportional, Facultative)
    - Retention Amount
    - Cession Percentage or Amount
    
  Claim Information:
    - Claim Number
    - Policy Number
    - Insured Name, DOB, Gender
    - Date of Death
    - Cause of Death (ICD-10 coded)
    - Manner of Death
    - Gross Death Benefit
    - Net Amount at Risk
    - Reinsured Amount
    - Ceded Amount
    - Retained Amount
    
  Financial Information:
    - Gross Claim Payment
    - Reinsurance Recovery Expected
    - Date of Payment
    - Currency
```

---

## 10. MIB (Medical Information Bureau) Standards

### 10.1 MIB Codes

MIB maintains a database of medical information reported by member insurance companies. During contestability investigations, MIB data is critical.

| Category | Description |
|---|---|
| **Medical Condition Codes** | ~230 codes for medical conditions (proprietary) |
| **Non-Medical Codes** | Hazardous avocations, aviation, driving records, etc. |
| **Insurance Activity Codes** | Prior application activity with other carriers |

### 10.2 MIB Checking Service

```
MIB CHECK REQUEST:
  Input:
    - Insured Name (First, Last)
    - Date of Birth
    - Gender
    - SSN (optional)
    - State of Residence
  
  Output:
    - Matching MIB records
    - Condition codes
    - Reporting company codes (anonymized)
    - Date of report
    - Prior application activity
```

---

## 11. Data Standard Compliance Matrix

### 11.1 Standard Applicability by Claims Function

| Function | ACORD | FHIR/HL7 | ISO 20022 | NAIC | IRS | EDI |
|---|---|---|---|---|---|---|
| **FNOL** | Primary | — | — | — | — | — |
| **Policy Verification** | Primary | — | — | — | — | Legacy |
| **Medical Records** | — | Primary | — | — | — | — |
| **Death Verification** | Secondary | Emerging | — | — | — | — |
| **Benefit Calculation** | Internal | — | — | — | — | — |
| **Payment Processing** | — | — | Primary | — | — | Legacy |
| **Tax Reporting** | — | — | — | — | Primary | — |
| **Regulatory Reporting** | — | — | — | Primary | — | — |
| **Reinsurance** | Primary | — | — | — | — | — |
| **Fraud Investigation** | — | — | — | — | — | — |

---

## 12. Architectural Implications

### 12.1 Standard Adoption Strategy

```
RECOMMENDATION:
  1. ACORD XML/JSON as PRIMARY standard for insurance data exchange
  2. FHIR for healthcare/medical data integration
  3. ISO 20022 for payment processing
  4. NAIC standards for regulatory reporting
  5. IRS specifications for tax reporting
  
  CANONICAL DATA MODEL:
  ├── Build internal canonical model ALIGNED with ACORD
  ├── Create adapters/translators for each external standard
  ├── Version all standard implementations
  └── Plan for standard evolution (ACORD updates annually)
  
  INTEGRATION PATTERNS:
  ├── ACORD XML/JSON for B2B partner integrations
  ├── FHIR REST APIs for healthcare data
  ├── ISO 20022 via payment gateway
  ├── XBRL/NAIC via regulatory reporting engine
  └── IRS FIRE for tax filing
```

### 12.2 Data Transformation Architecture

```
┌──────────┐     ┌──────────────┐     ┌──────────────┐
│ External │     │ Translation  │     │  Internal    │
│ Standard │────▶│    Layer     │────▶│  Canonical   │
│ Format   │     │              │     │  Model       │
└──────────┘     │ ┌──────────┐│     └──────────────┘
                 │ │ ACORD    ││
                 │ │ Adapter  ││
                 │ └──────────┘│
                 │ ┌──────────┐│
                 │ │ FHIR     ││
                 │ │ Adapter  ││
                 │ └──────────┘│
                 │ ┌──────────┐│
                 │ │ ISO20022 ││
                 │ │ Adapter  ││
                 │ └──────────┘│
                 │ ┌──────────┐│
                 │ │ Legacy   ││
                 │ │ Adapter  ││
                 │ └──────────┘│
                 └──────────────┘
```

---

## 13. Summary

Data standards are the foundation of interoperable claims processing. Key takeaways for architects:

1. **ACORD is the primary standard** for insurance data exchange - build your canonical model aligned with ACORD
2. **FHIR is the emerging standard** for healthcare data - essential for medical records and death notification
3. **ISO 20022 is the payment standard** - adopt for all financial transactions
4. **NAIC standards drive regulatory reporting** - design reporting capabilities around NAIC requirements
5. **Plan for multiple standards** - no single standard covers all needs; build a translation layer
6. **Version your standard implementations** - standards evolve; your system must adapt
7. **ICD-10 coding is critical** - death certificates and medical records use ICD-10 extensively

---

*Previous: [Article 3: Claims Adjudication & Decision Engine](03-claims-adjudication-decision-engine.md)*
*Next: [Article 5: Data Formats & Canonical Data Models](05-data-formats-canonical-models.md)*
