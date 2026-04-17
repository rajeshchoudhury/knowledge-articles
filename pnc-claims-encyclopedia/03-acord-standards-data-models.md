# ACORD Standards, Data Formats & Industry Data Models

> **Audience:** Solutions Architects designing and building Property & Casualty claims systems.
> **Version:** 1.0 | **Last Updated:** 2026-04-16

---

## Table of Contents

1. [History and Purpose of ACORD](#1-history-and-purpose-of-acord)
2. [ACORD Forms Relevant to Claims](#2-acord-forms-relevant-to-claims)
3. [ACORD XML Standards for Claims](#3-acord-xml-standards-for-claims)
4. [ACORD AL3 Format](#4-acord-al3-format)
5. [ACORD Property & Casualty Data Model](#5-acord-property--casualty-data-model)
6. [Field-by-Field Breakdown of Key ACORD Claims Messages](#6-field-by-field-breakdown-of-key-acord-claims-messages)
7. [ISO ClaimSearch Integration](#7-iso-claimsearch-integration)
8. [ISO Electronic Claim File (ECF)](#8-iso-electronic-claim-file-ecf)
9. [NAIC Data Call Formats](#9-naic-data-call-formats)
10. [NCCI EDI for Workers Compensation](#10-ncci-edi-for-workers-compensation)
11. [Healthcare Data Formats for Injury Claims](#11-healthcare-data-formats-for-injury-claims)
12. [MISMO for Mortgage-Related Property Claims](#12-mismo-for-mortgage-related-property-claims)
13. [JSON/REST API Representations](#13-jsonrest-api-representations)
14. [Code Lists and Reference Data](#14-code-lists-and-reference-data)
15. [Sample XML Payloads](#15-sample-xml-payloads)
16. [Data Mapping: ACORD to Internal Models](#16-data-mapping-acord-to-internal-models)
17. [Canonical Data Model Design](#17-canonical-data-model-design)

---

## 1. History and Purpose of ACORD

### 1.1 History

| Year | Milestone |
|---|---|
| 1970 | ACORD founded by a group of independent insurance agents to reduce paperwork |
| 1972 | First ACORD forms published (standardized paper forms for agent-company communication) |
| 1980s | AL3 (Agency/Company interface) electronic data standard developed |
| 1998 | ACORD XML standards initiative launched |
| 2001 | ACORD XML P&C v1.0 released |
| 2004 | ACORD becomes a global standards body (Life, Reinsurance, London Market) |
| 2008 | ACORD Framework introduced (linking forms, XML, data model) |
| 2010s | ACORD PC Data Model becomes the reference data model for the P&C industry |
| 2019 | ACORD accelerates API/JSON standards development |
| 2020s | ACORD continues to evolve with cloud-native, event-driven, and API-first standards |

### 1.2 Purpose and Scope

ACORD serves as the **global standards-setting body** for the insurance, reinsurance, and related financial services industries. Its mission is to facilitate the development of open consensus data standards and implementation solutions.

Key areas:

- **Forms** — standardized paper/PDF forms used across the industry
- **Data Standards** — XML schemas, AL3 flat-file formats, and emerging JSON/API standards
- **Data Model** — the PC Data Model, a canonical reference model for all insurance data
- **Implementation Guides** — guidance for how to use the standards in practice
- **Certification** — testing and certification for standards compliance

### 1.3 Why ACORD Matters for Claims Systems

| Concern | ACORD's Role |
|---|---|
| Data Exchange | Standard schemas for exchanging claims data between carriers, agents, TPAs, vendors |
| Interoperability | Enables plug-and-play integration between systems from different vendors |
| Regulatory Reporting | Many regulators reference ACORD data structures |
| Vendor Integration | Estimatics platforms, ISO ClaimSearch, and other vendors use ACORD-based formats |
| Data Migration | ACORD data model serves as a neutral schema for migrating between claims systems |
| Industry Benchmarking | Consistent data definitions enable meaningful cross-company comparisons |

---

## 2. ACORD Forms Relevant to Claims

### 2.1 Key ACORD Claims Forms

| Form Number | Form Name | Purpose | Lines of Business |
|---|---|---|---|
| ACORD 1 | Property Loss Notice | Report a property loss to the carrier | Homeowners, Commercial Property, Dwelling, Farm |
| ACORD 2 | Automobile Loss Notice | Report an auto loss to the carrier | Personal Auto, Commercial Auto |
| ACORD 3 | General Liability / Umbrella Notice of Occurrence/Claim | Report a GL or umbrella claim | CGL, Umbrella, Excess |
| ACORD 4 | Workers Compensation — First Report of Injury | Report a work-related injury | Workers Compensation |
| ACORD 5 | Professional Liability Claim/Incident Report | Report a professional liability claim | E&O, D&O, EPLI |
| ACORD 6 | Crime Loss Notice | Report a crime/fidelity loss | Crime, Fidelity |
| ACORD 7 | Inland Marine Loss Notice | Report an inland marine loss | Inland Marine |
| ACORD 19 | Additional Claim Information | Supplement to initial claim forms | All lines |
| ACORD 36 | Property Loss — Proof of Loss | Formal sworn proof of loss statement | Property |
| ACORD 68 | Property Claim Summary | Summary of property claim for reporting | Property |
| ACORD 132 | Property Loss Summary | Detailed property loss schedule | Commercial Property |

### 2.2 ACORD 1 — Property Loss Notice — Field Breakdown

| Section | Fields | Description |
|---|---|---|
| Agency Information | Agency Name, Code, Phone, Contact | Reporting agent/broker information |
| Carrier Information | Company Name, NAIC Code, Policy Number | Insuring carrier and policy |
| Insured Information | Named Insured, Mailing Address | Policyholder identification |
| Loss/Occurrence | Date, Time, Location, Description | When, where, and what happened |
| Type of Loss | Checkboxes: Fire, Lightning, Windstorm, Hail, Explosion, Theft, Vandalism, Water Damage, Other | Cause of loss classification |
| Property Damage | Building Damage (Y/N), Contents Damage (Y/N), Description of Damage | What was damaged |
| Estimated Loss | Building, Contents, Time Element | Dollar estimates |
| Additional Details | Police/Fire Report, Witnesses, Other Insurance, Mortgage Info | Supporting information |
| Coverage | Coverages Applied For / In Force | Which coverages may apply |

### 2.3 ACORD 2 — Automobile Loss Notice — Field Breakdown

| Section | Fields | Description |
|---|---|---|
| Agency/Carrier | Same as ACORD 1 | Identifying information |
| Named Insured | Name, Address, Phone, DOB | Policyholder |
| Loss/Occurrence | Date, Time, Location (Street, City, State, ZIP) | Accident details |
| Description of Accident | Narrative field | What happened |
| Insured Vehicle | Year, Make, Model, VIN, License Plate, State, Body Type | Vehicle identification |
| Driver of Insured Vehicle | Name, DOB, DL Number, State, Relationship to Insured | Who was driving |
| Damage to Insured Vehicle | Location on Vehicle, Description, Estimate Amount, Drivable? | Damage details |
| Other Vehicle | Year, Make, Model, VIN, License Plate, Owner, Driver, Insurance Info | Other party vehicle |
| Other Vehicle Damage | Location, Description, Estimate | Other vehicle damage |
| Injured Persons | Name, Address, DOB, Nature of Injury, Relationship, Hospitalized? | Each injured person |
| Witnesses | Name, Address, Phone | Witness information |
| Police Report | Department, Report Number, Officer | Law enforcement info |
| Authorities Contacted | Police, Fire, EMS | Which authorities responded |

---

## 3. ACORD XML Standards for Claims

### 3.1 ACORD XML Architecture

```
ACORD XML Standard Structure:
│
├── Namespace: http://www.ACORD.org/standards/PC_Surety/ACORD1/xml/
│
├── Message Types (Claims-Relevant):
│   ├── ClaimsSvc_RQ / ClaimsSvc_RS (Claims Service Request/Response)
│   │   ├── ClaimNotificationAddRq / Rs (FNOL)
│   │   ├── ClaimInquiryRq / Rs (Claim Status Inquiry)
│   │   ├── ClaimSearchRq / Rs (Search for Claims)
│   │   ├── ClaimStatusUpdateRq / Rs (Status Change)
│   │   ├── ClaimPaymentAddRq / Rs (Payment)
│   │   └── ClaimReserveUpdateRq / Rs (Reserve Change)
│   │
│   ├── PolicySvc_RQ / PolicySvc_RS (Policy Inquiry from Claims)
│   │   └── PolicyInquiryRq / Rs
│   │
│   └── InsuranceSvcRq / InsuranceSvcRs (Generic Service Wrapper)
│
├── Core Components:
│   ├── ClaimsOccurrence (Occurrence/incident)
│   ├── ClaimsParty (Parties to the claim)
│   ├── ClaimFeature (Coverage exposure)
│   ├── ClaimsPayment (Payment transaction)
│   ├── ReserveInfo (Reserve details)
│   ├── AutoLossInfo (Auto-specific loss information)
│   ├── PropertyLossInfo (Property-specific loss information)
│   ├── CasualtyLossInfo (Liability-specific loss information)
│   ├── WCLossInfo (Workers comp-specific loss information)
│   └── InjuryInfo (Injury details)
│
└── Supporting Components:
    ├── Addr (Address)
    ├── Communications (Phone, Email)
    ├── NameInfo (Person/Organization name)
    ├── CurrencyAmt (Money amounts)
    ├── ItemInfo (Property items)
    └── CodeList references (hundreds of enumerated code lists)
```

### 3.2 ACORD XML Claim Message Structure

```xml
<!-- Simplified ACORD XML Claims Message Structure -->
<ACORD>
  <SignonRq>
    <SignonPswd>
      <CustId>
        <SPName>InsuranceCarrier</SPName>
        <CustLoginId>claimsystem01</CustLoginId>
      </CustId>
      <CustPswd>
        <Pswd>[encrypted]</Pswd>
      </CustPswd>
    </SignonPswd>
    <ClientDt>2026-04-16T10:30:00</ClientDt>
    <CustLangPref>en-US</CustLangPref>
    <ClientApp>
      <Org>AcmeInsurance</Org>
      <Name>ClaimsCore</Name>
      <Version>5.2</Version>
    </ClientApp>
  </SignonRq>
  
  <InsuranceSvcRq>
    <RqUID>a1b2c3d4-e5f6-7890-abcd-ef1234567890</RqUID>
    
    <ClaimsSvc>
      <!-- Specific claim message goes here -->
      <!-- e.g., ClaimNotificationAddRq, ClaimInquiryRq, etc. -->
    </ClaimsSvc>
    
  </InsuranceSvcRq>
</ACORD>
```

### 3.3 Key XML Message Types

#### ClaimNotificationAddRq (FNOL Submission)

| Element | Type | Required | Description |
|---|---|---|---|
| `RqUID` | String | Yes | Unique request identifier |
| `TransactionRequestDt` | DateTime | Yes | Date/time of the request |
| `TransactionEffectiveDt` | Date | No | Effective date of the notification |
| `ClaimsOccurrence` | Complex | Yes | Main occurrence/loss details |
| `ClaimsOccurrence/ItemIdInfo/OtherIdentifier` | String | No | Reference numbers |
| `ClaimsOccurrence/LossDt` | Date | Yes | Date of loss |
| `ClaimsOccurrence/LossTm` | Time | No | Time of loss |
| `ClaimsOccurrence/LossDesc` | String | Yes | Loss description narrative |
| `ClaimsOccurrence/Addr` | Complex | Yes | Loss location address |
| `ClaimsOccurrence/CauseOfLossCd` | Code | Yes | ACORD/ISO cause of loss code |
| `ClaimsOccurrence/LossConditionCd` | Code | No | Loss condition code |
| `ClaimsOccurrence/CatastropheCd` | Code | No | Catastrophe identifier |
| `Policy` | Complex | Yes | Policy information |
| `Policy/PolicyNumber` | String | Yes | Policy number |
| `Policy/LOBCd` | Code | Yes | Line of business code |
| `ClaimsParty` | Complex | Yes (1+) | Parties involved |
| `ClaimsParty/ClaimsPartyInfo/ClaimsPartyRoleCd` | Code | Yes | Role (Insured, Claimant, Witness, etc.) |
| `ClaimsParty/NameInfo` | Complex | Yes | Name details |
| `ClaimsParty/Addr` | Complex | No | Address |
| `ClaimsParty/Communications` | Complex | No | Phone, email |
| `AutoLossInfo` | Complex | Cond | Auto-specific (required for auto claims) |
| `PropertyLossInfo` | Complex | Cond | Property-specific (required for property claims) |
| `CasualtyLossInfo` | Complex | Cond | Liability-specific |
| `InjuryInfo` | Complex | No | Injury details per injured party |

#### ClaimInquiryRq (Claim Status Inquiry)

| Element | Type | Required | Description |
|---|---|---|---|
| `RqUID` | String | Yes | Unique request identifier |
| `ClaimNumber` | String | Yes* | Claim number to look up |
| `PolicyNumber` | String | Yes* | OR policy number to find claims |
| `LossDt` | Date | No | Filter by loss date |
| `ClaimStatusCd` | Code | No | Filter by status |
| `ItemIdInfo` | Complex | No | Other identifiers |
| *Note: ClaimNumber OR PolicyNumber required | | | |

#### ClaimInquiryRs (Claim Status Response)

| Element | Type | Description |
|---|---|---|
| `MsgStatusCd` | Code | Success, Error, Partial |
| `MsgStatusDesc` | String | Status description |
| `ClaimsOccurrence` | Complex | Full occurrence details |
| `ClaimNumber` | String | Claim number |
| `ClaimStatusCd` | Code | Current claim status |
| `ClaimFeature[]` | Complex | Array of features/exposures |
| `ClaimFeature/FeatureNumber` | String | Feature identifier |
| `ClaimFeature/CoverageCd` | Code | Coverage code |
| `ClaimFeature/FeatureStatusCd` | Code | Feature status |
| `ReserveInfo[]` | Complex | Reserve details per feature |
| `ClaimsPayment[]` | Complex | Payment details |
| `ClaimsParty[]` | Complex | Party details |
| `ClaimsActivity[]` | Complex | Activity/diary details |

---

## 4. ACORD AL3 Format

### 4.1 AL3 Overview

AL3 (Agency/Company interface Level 3) is a **fixed-length, flat-file format** used primarily for communication between agencies and carriers. While increasingly replaced by XML and APIs, AL3 is still in widespread use.

### 4.2 AL3 Record Structure

```
AL3 Record Format:
┌────────────────────────────────────────────────────────┐
│ Field              │ Positions  │ Length │ Description   │
├────────────────────┼────────────┼────────┼───────────────┤
│ Record Type ID     │ 1-4        │ 4      │ Transaction   │
│                    │            │        │ type code     │
│ Data Element ID    │ 5-8        │ 4      │ Field ID      │
│ Data Content       │ 9-end      │ Varies │ Actual data   │
└────────────────────────────────────────────────────────┘

Key AL3 Transaction Types for Claims:
  CLAI — Claim record
  CLAM — Claim amount
  CLAP — Claim party
  CLAV — Claim vehicle
  CLAD — Claim damage
  CLAE — Claim expense
  CLAN — Claim narrative
```

### 4.3 AL3 Example — Claim Transaction

```
CLAI0001CLM-2026-001234                    ← Claim Number
CLAI0002PA                                 ← Line of Business (Personal Auto)
CLAI0003202603151430                       ← Loss Date/Time (2026-03-15 14:30)
CLAI0004ABC123456                          ← Policy Number
CLAI0010COLLISION                          ← Claim Type
CLAI0011OPEN                               ← Claim Status
CLAI0020SMITH, JOHN A                      ← Named Insured
CLAI0021123 MAIN ST                        ← Insured Address
CLAI0022ANYTOWN                            ← City
CLAI002305                                 ← State (CA)
CLAI002490210                              ← ZIP
CLAP0001INS                                ← Party Role: Insured
CLAP0002SMITH, JOHN A                      ← Party Name
CLAV00011HGBH41JXMN109186                 ← VIN
CLAV00022022                               ← Year
CLAV0003HONDA                              ← Make
CLAV0004CIVIC                              ← Model
CLAM0001000004200                          ← Reserve Amount ($4,200)
CLAN0001INSURED VEH REAR-ENDED AT RED LIGHT← Narrative
```

---

## 5. ACORD Property & Casualty Data Model

### 5.1 PC Data Model Overview

The ACORD PC Data Model is a **comprehensive, industry-standard logical data model** that defines entities, attributes, and relationships for the entire P&C insurance domain.

```
ACORD PC Data Model — Claims Section Entity Map:

┌───────────────┐     ┌───────────────┐     ┌───────────────┐
│   Agreement    │     │   Claim       │     │  Occurrence   │
│ (Policy)       │◄───│               │───►│               │
│               │     │  ClaimId      │     │  OccurrenceId │
│  AgreementId  │     │  ClaimNumber  │     │  OccurrenceDt │
│  LOBCd        │     │  StatusCd     │     │  Description  │
│  EffDt        │     │  TypeCd       │     │  LocationRef  │
│  ExpDt        │     │  JurisdCd     │     │  CauseCd      │
└───────────────┘     └───┬───────────┘     └───────────────┘
                          │
          ┌───────────────┼───────────────┐
          │               │               │
  ┌───────▼──────┐ ┌─────▼───────┐ ┌─────▼──────┐
  │  ClaimFeature│ │  ClaimParty │ │  Financial  │
  │              │ │             │ │  Transaction│
  │  FeatureId   │ │  PartyId    │ │             │
  │  CoverageCd  │ │  RoleCd     │ │  TxnId      │
  │  StatusCd    │ │  NameInfo   │ │  TxnTypeCd  │
  │  ClaimantRef │ │  Addr       │ │  Amount     │
  │  ReserveAmt  │ │  Comms      │ │  PayeRef    │
  │  PaidAmt     │ │  InjuryInfo │ │  FeatureRef │
  └──────────────┘ └─────────────┘ └─────────────┘
```

### 5.2 Key Entity Descriptions

| Entity | ACORD Name | Description | Key Attributes |
|---|---|---|---|
| Policy | Agreement | The insurance contract | AgreementId, PolicyNumber, LOBCd, EffDt, ExpDt, StatusCd |
| Coverage | AgreementCoverage | Coverage within a policy | CoverageCd, LimitAmt, DeductibleAmt, EffDt |
| Occurrence | ClaimsOccurrence | The incident/event | OccurrenceId, OccurrenceDt, LocationAddr, CauseOfLossCd |
| Claim | Claim | The claim record | ClaimId, ClaimNumber, StatusCd, TypeCd, ReportDt |
| Feature | ClaimFeature | Coverage exposure | FeatureId, CoverageCd, StatusCd, ReserveAmt, PaidAmt |
| Party | Party | Person or organization | PartyId, PartyTypeCd, NameInfo, Addr, Communications |
| Claim Party | ClaimsParty | Party in context of claim | ClaimsPartyRoleCd, InjuryInfo, RepresentedByRef |
| Payment | ClaimsPayment | Payment transaction | PaymentId, Amount, PayeeName, PaymentMethodCd, StatusCd |
| Reserve | ReserveInfo | Reserve record | ReserveTypeCd, Amount, AsOfDt, ChangeDt |
| Activity | ClaimsActivity | Task/diary | ActivityTypeCd, DueDt, StatusCd, AssignedTo |
| Document | DocumentInfo | Associated document | DocTypeCd, FileName, MIMEContentTypeCd, StorageRef |
| Note | Remark | Note/comment | RemarkText, CreatedDt, AuthorName |
| Vehicle | VehicleInfo | Vehicle details | VIN, ModelYear, Manufacturer, Model, BodyTypeCd |
| Property | PropertyInfo | Property details | Addr, ConstructionCd, YearBuilt, SquareFootage |
| Injury | InjuryInfo | Injury details | BodyPartCd, InjuryNatureCd, InjurySeverityCd |

### 5.3 Data Model Relationships

| Parent Entity | Child Entity | Relationship | Cardinality |
|---|---|---|---|
| Agreement | AgreementCoverage | Policy has coverages | 1:N |
| Agreement | Claim | Policy has claims | 1:N |
| ClaimsOccurrence | Claim | Occurrence has claims | 1:N |
| Claim | ClaimFeature | Claim has features | 1:N |
| Claim | ClaimsParty | Claim has parties | 1:N |
| Claim | ClaimsPayment | Claim has payments | 1:N |
| Claim | ClaimsActivity | Claim has activities | 1:N |
| Claim | DocumentInfo | Claim has documents | 1:N |
| Claim | Remark | Claim has notes | 1:N |
| ClaimFeature | ReserveInfo | Feature has reserves | 1:N |
| ClaimFeature | ClaimsPayment | Feature has payments | 1:N |
| ClaimsParty | InjuryInfo | Party has injuries | 1:N |
| ClaimsParty | VehicleInfo | Party has vehicles | 0:N |

---

## 6. Field-by-Field Breakdown of Key ACORD Claims Messages

### 6.1 ClaimNotificationAddRq — Complete Field Reference

```
ClaimNotificationAddRq
│
├── RqUID (String, Required)
│   Unique identifier for this request message
│   Format: UUID v4
│   Example: "f47ac10b-58cc-4372-a567-0e02b2c3d479"
│
├── TransactionRequestDt (DateTime, Required)
│   When this request was generated
│   Format: ISO 8601
│   Example: "2026-04-16T14:30:00-05:00"
│
├── TransactionEffectiveDt (Date, Optional)
│   Effective date of the notification
│
├── Producer (Complex, Optional)
│   ├── ProducerInfo
│   │   ├── ContractNumber (String) — Agency/broker contract number
│   │   └── ProducerRoleCd (Code) — Agent, Broker, MGA
│   ├── NameInfo
│   │   └── CommlName/CommercialName (String) — Agency name
│   ├── Addr (Complex) — Agency address
│   └── Communications (Complex) — Agency phone/email
│
├── InsuredOrPrincipal (Complex, Required)
│   ├── GeneralPartyInfo
│   │   ├── NameInfo
│   │   │   ├── PersonName
│   │   │   │   ├── Surname (String, Required)
│   │   │   │   ├── GivenName (String, Required)
│   │   │   │   └── MiddleName (String, Optional)
│   │   │   └── OR CommlName/CommercialName (String)
│   │   ├── Addr
│   │   │   ├── Addr1 (String)
│   │   │   ├── Addr2 (String)
│   │   │   ├── City (String)
│   │   │   ├── StateProvCd (Code)
│   │   │   ├── PostalCode (String)
│   │   │   └── CountryCd (Code)
│   │   └── Communications
│   │       ├── PhoneInfo
│   │       │   ├── PhoneTypeCd (Code) — Phone, Mobile, Fax
│   │       │   └── PhoneNumber (String)
│   │       └── EmailInfo/EmailAddr (String)
│   └── InsuredOrPrincipalInfo
│       ├── InsuredOrPrincipalRoleCd (Code) — Insured, Additional Insured
│       └── PersonInfo
│           ├── BirthDt (Date)
│           ├── GenderCd (Code)
│           └── OccupationDesc (String)
│
├── Policy (Complex, Required)
│   ├── PolicyNumber (String, Required)
│   ├── LOBCd (Code, Required) — AUTOP, HOME, CPKGE, CGL, WC, etc.
│   ├── CompanyProductCd (Code, Optional)
│   ├── EffectiveDt (Date)
│   ├── ExpirationDt (Date)
│   ├── MiscParty (Complex) — Carrier information
│   │   ├── MiscPartyInfo/MiscPartyRoleCd (Code) — Carrier
│   │   └── NameInfo/CommlName (String) — Carrier name
│   └── PolicyStatusCd (Code) — Active, Cancelled, Expired
│
├── ClaimsOccurrence (Complex, Required)
│   ├── ItemIdInfo
│   │   ├── AgencyId (String) — Agency reference number
│   │   └── OtherIdentifier (String) — Other reference numbers
│   ├── LossDt (Date, Required) — Date of loss
│   ├── LossTm (Time, Optional) — Time of loss
│   ├── ReportedDt (DateTime, Required) — When reported to carrier
│   ├── ReportedToInsurer (Boolean) — Explicit flag
│   ├── LossDesc (String, Required) — Narrative description of loss
│   ├── Addr (Complex, Required) — Loss location
│   │   ├── Addr1, City, StateProvCd, PostalCode, CountryCd
│   │   └── County (String) — Important for jurisdiction
│   ├── CauseOfLossCd (Code, Required) — ISO cause of loss code
│   ├── LossConditionCd (Code) — Additional condition code
│   ├── CatastropheCd (String) — CAT event code
│   ├── ReportedToPoliceInd (Boolean) — Police report filed?
│   ├── PoliceRptInfo (Complex) — Police report details
│   │   ├── PoliceRptNum (String)
│   │   ├── PoliceDeptName (String)
│   │   └── InvestigatingOfficer (String)
│   └── WitnessInfo (Complex, 0:N) — Witness details
│       ├── NameInfo/PersonName
│       ├── Addr
│       └── Communications
│
├── ClaimsParty (Complex, 1:N, Required)
│   ├── ClaimsPartyInfo
│   │   ├── ClaimsPartyRoleCd (Code, Required)
│   │   │   Values: Insured, Claimant, Driver, Passenger, 
│   │   │           Pedestrian, Witness, OtherParty
│   │   ├── InvolvedPartyTypeCd (Code) — Person, Organization
│   │   └── SuitFiledInd (Boolean)
│   ├── GeneralPartyInfo (Complex) — Name, Address, Communications
│   ├── PersonInfo (Complex)
│   │   ├── BirthDt, GenderCd, MaritalStatusCd, OccupationDesc
│   │   └── DriversLicenseInfo
│   │       ├── DriversLicenseNumber (String)
│   │       └── StateProvCd (Code)
│   ├── InjuryInfo (Complex, 0:N) — Per injured party
│   │   ├── InjuredInd (Boolean)
│   │   ├── BodyPartCd (Code)
│   │   ├── InjuryNatureCd (Code)
│   │   ├── InjurySeverityCd (Code)
│   │   ├── TransportedToHospitalInd (Boolean)
│   │   ├── HospitalName (String)
│   │   └── DeathInd (Boolean)
│   └── InsuranceInfo (Complex) — Other party's insurance
│       ├── InsurerName (String)
│       ├── PolicyNumber (String)
│       └── ClaimNumber (String)
│
├── AutoLossInfo (Complex, Conditional — Auto Claims)
│   ├── VehicleInfo (Complex, 1:N)
│   │   ├── VehIdentificationNumber (String, Required) — VIN
│   │   ├── ModelYear (Integer, Required)
│   │   ├── Manufacturer (String, Required)
│   │   ├── Model (String, Required)
│   │   ├── BodyTypeCd (Code)
│   │   ├── VehColorCd (Code)
│   │   ├── OdometerReading (Integer)
│   │   ├── Registration
│   │   │   ├── RegistrationNumber (String)
│   │   │   └── StateProvCd (Code)
│   │   ├── OwnerRef (Reference) — Link to ClaimsParty
│   │   ├── DriverRef (Reference) — Link to ClaimsParty
│   │   └── VehDamageInfo (Complex)
│   │       ├── DamageDesc (String)
│   │       ├── PointOfImpactCd (Code) — Front, Rear, LeftSide, RightSide
│   │       ├── DamageEstimateAmt (Currency)
│   │       ├── DrivableInd (Boolean)
│   │       ├── AirbagDeployedInd (Boolean)
│   │       └── TowedInd (Boolean)
│   ├── AccidentDesc (String) — Detailed accident description
│   ├── NumberOfVehicles (Integer)
│   ├── IntersectionInd (Boolean)
│   ├── RoadConditionCd (Code)
│   ├── WeatherConditionCd (Code)
│   └── LightConditionCd (Code)
│
├── PropertyLossInfo (Complex, Conditional — Property Claims)
│   ├── PropertyInfo (Complex)
│   │   ├── Addr (Complex)
│   │   ├── ConstructionCd (Code) — Frame, Masonry, etc.
│   │   ├── YearBuilt (Integer)
│   │   ├── SquareFootage (Integer)
│   │   ├── OccupancyCd (Code) — OwnerOccupied, Tenant, Vacant
│   │   ├── RoofTypeCd (Code)
│   │   └── NumberOfStories (Integer)
│   ├── PropertyDamageInfo (Complex)
│   │   ├── DamageDesc (String)
│   │   ├── DamagedAreaDesc (String)
│   │   ├── HabitableInd (Boolean)
│   │   ├── SecurityCompromisedInd (Boolean)
│   │   └── EmergencyRepairsNeededInd (Boolean)
│   ├── BuildingDamageEstimateAmt (Currency)
│   ├── ContentsDamageEstimateAmt (Currency)
│   └── TimeDamageEstimateAmt (Currency) — Business income loss
│
└── CasualtyLossInfo (Complex, Conditional — Liability Claims)
    ├── PremisesDesc (String)
    ├── ActivityCausingLoss (String)
    ├── DefectOrCondition (String)
    ├── PriorIncidentsInd (Boolean)
    └── MedicalPaymentRequestedInd (Boolean)
```

---

## 7. ISO ClaimSearch Integration

### 7.1 Overview

ISO ClaimSearch (Verisk) is the insurance industry's **central claims database** containing **billions** of claims records contributed by participating insurers.

### 7.2 Integration Architecture

```
┌───────────────┐                    ┌──────────────────────┐
│ CLAIMS SYSTEM  │  ACORD XML / API  │  ISO ClaimSearch      │
│                │──────────────────►│                      │
│  FNOL Process  │                    │  - Match on party     │
│  SIU Process   │                    │  - Match on vehicle   │
│                │◄──────────────────│  - Match on property  │
│  Match Results │  Match Report      │  - Prior claims hx    │
│  Display/Flag  │                    │  - Alert flags        │
└───────────────┘                    └──────────────────────┘
```

### 7.3 ClaimSearch Submission Fields

| Category | Fields | Purpose |
|---|---|---|
| Claim Info | Claim number, loss date, cause of loss, claim status | Identify the claim |
| Insured | Name (last/first), DOB, SSN, address, phone | Match on insured |
| Claimant | Name, DOB, SSN, address, phone | Match on claimants |
| Vehicle | VIN, year, make, model, license plate | Match on vehicles |
| Property | Address, property type | Match on property |
| Provider | Medical provider, repair shop | Pattern detection |
| Attorney | Attorney name, firm | Pattern detection |
| Financial | Reserve amount, paid amount, claim type | Severity matching |

### 7.4 ClaimSearch Match Report Fields

| Field | Description |
|---|---|
| Match Type | Person, Vehicle, Address, Phone, SSN |
| Match Score | Confidence level of the match |
| Prior Claim Number | Claim number from matching carrier |
| Prior Claim Date | Date of prior matched claim |
| Prior Carrier | Which insurer had the prior claim |
| Prior Claim Type | Type of prior claim |
| Prior Claim Status | Status of prior claim |
| Alert Flags | Frequency alert, severity alert, pattern alert |
| Number of Prior Claims | Total prior claim count for matched entity |

---

## 8. ISO Electronic Claim File (ECF)

### 8.1 ECF Overview

The ISO Electronic Claim File is a standardized format for electronic exchange of comprehensive claim file data between carriers, TPAs, and reinsurers.

### 8.2 ECF Sections

| Section | Content | Purpose |
|---|---|---|
| Header | File ID, sender, receiver, generation date | File routing |
| Policy | Policy number, term, coverages, limits, deductibles | Coverage context |
| Claim | Claim number, loss date, cause, description, status | Core claim data |
| Parties | All parties with roles, contact info, attorneys | Party management |
| Vehicles | VIN, make, model, damage, estimates | Auto claim data |
| Property | Address, construction, damage, estimates | Property claim data |
| Injuries | Body part, nature, treatment, providers | Injury data |
| Financials | Reserves (by type), payments (by type), recoveries | Financial summary |
| Activities | Diary items, tasks, investigation activities | Work management |
| Notes | Adjuster notes, correspondence log | Narrative |
| Documents | Document index with references | Document manifest |

---

## 9. NAIC Data Call Formats

### 9.1 Overview

The NAIC periodically issues **data calls** requiring insurers to submit claims and other data for regulatory analysis. These can be routine (annual statement) or ad-hoc (market conduct, catastrophe).

### 9.2 Annual Statement — Schedule P (Loss Reserve)

| Column | Description |
|---|---|
| Line of Business | NAIC line code |
| Accident Year | Year of loss occurrence |
| Incurred Losses | Paid + Outstanding Reserves |
| Paid Losses | Cumulative paid losses |
| Outstanding Reserves | Case reserves + IBNR |
| ALAE Incurred | Allocated expense incurred |
| ALAE Paid | Allocated expense paid |
| Salvage | Salvage recoveries |
| Subrogation | Subrogation recoveries |
| Development by Year | Triangular development of losses over 10 years |

### 9.3 Market Conduct Data Calls

Common data call fields:

| Field Category | Fields |
|---|---|
| Claim Identification | Claim number, policy number, claimant name |
| Timing | Loss date, report date, acknowledge date, decision date, payment date |
| Amounts | Reserve, paid, denied amount |
| Status | Current status, closed/open, denial reason |
| Communication | Date of each communication, type, direction |
| Compliance | SLA adherence, regulatory violations |

### 9.4 Catastrophe Data Calls

| Field | Description |
|---|---|
| CAT Event Code | PCS serial number or state-defined code |
| Claims Reported | Total FNOLs for this event |
| Claims Open | Currently open claims |
| Claims Closed | Total closed claims |
| Claims Closed w/Payment | Closed with at least one payment |
| Claims Closed w/o Payment | Closed without payment |
| Incurred Losses | Total incurred (reserves + paid) |
| Paid Losses | Total paid |
| Outstanding Reserves | Total outstanding |
| Geographic Distribution | By county/ZIP |

---

## 10. NCCI EDI for Workers Compensation

### 10.1 NCCI EDI Overview

NCCI (and state-specific bureaus) requires electronic reporting of workers' compensation claims data. The WCIO (Workers Compensation Insurance Organizations) defines the EDI standards.

### 10.2 Key EDI Transactions

| Transaction | IAIABC Code | Description |
|---|---|---|
| First Report of Injury | FROI (148) | Initial injury report to state/NCCI |
| Subsequent Report of Injury | SROI (148) | Ongoing claim status updates |
| Medical Bill | MEDI | Medical treatment data |
| Proof of Coverage | POC | Policy verification |

### 10.3 FROI Record Layout (Simplified)

| Segment | Fields | Description |
|---|---|---|
| Header | Sender ID, Receiver ID, Transaction Date | Routing information |
| Claim Admin | TPA/Carrier ID, Claim Admin Address | Who is administering |
| Employer | Employer Name, FEIN, Address, SIC/NAICS, Policy Number | Employer information |
| Employee | Name, DOB, SSN, Gender, Hire Date, Occupation, Class Code | Injured worker |
| Injury | Date of Injury, Time, Cause Code, Nature Code, Body Part Code, Injury Description | What happened |
| Disability | Date Disability Began, Return to Work Date, Type of Disability | Lost time details |
| Wage | Average Weekly Wage, Days Worked per Week, Full Wages Paid for Date of Injury | Compensation basis |
| Jurisdiction | State Code, Jurisdiction Claim Number | State-specific |
| Benefits | Benefit Type, Weekly Rate, Start Date | Benefit calculations |

### 10.4 SROI Maintenance Type Codes

| MTC | Description | When Filed |
|---|---|---|
| 00 | Original | Initial FROI |
| 01 | Denial | Claim denied |
| 02 | Initial Payment | First indemnity payment |
| 04 | Suspension/Reinstatement | Benefits suspended or reinstated |
| AP | Acquired/Transferred | Claim transferred to new administrator |
| AU | Audit/Correction | Correcting previously reported data |
| CA | Change in Benefits | Benefit type or rate change |
| CB | Combined Settlements | Multiple benefit types settled |
| EP | Employer Paid | Employer-paid claim |
| FN | Final | Final payment/closure |
| IP | Interim Payment | Periodic indemnity payment |
| PY | Lump Sum Payment | Lump sum settlement |
| RB | Reopened Claim | Previously closed claim reopened |
| S1-S9 | Settlements | Various settlement types |

### 10.5 NCCI Classification Codes (Sample)

| Code | Description | Hazard Group |
|---|---|---|
| 8810 | Clerical Office Employees | A |
| 8742 | Salespersons - Outside | B |
| 5191 | Office Machine Installation | D |
| 5403 | Carpentry - Residential | F |
| 5022 | Masonry | F |
| 8017 | Retail Store | C |
| 7380 | Drivers/Chauffeurs | E |
| 3632 | Machine Shop | E |
| 9014 | Janitorial | C |
| 7720 | Police Officers | F |

---

## 11. Healthcare Data Formats for Injury Claims

### 11.1 Relevant X12 Transactions

| Transaction | X12 Code | Description | Claims Usage |
|---|---|---|---|
| Health Care Claim | 837 | Submit medical bills | Receive medical bills for PIP/WC/MedPay |
| Health Care Payment | 835 | Payment and remittance advice | Send medical payment explanations |
| Claim Status Request/Response | 276/277 | Check status of medical bills | Providers checking payment status |
| Authorization Request/Response | 278 | Prior authorization for treatment | WC treatment pre-authorization |
| Eligibility Inquiry/Response | 270/271 | Verify insurance eligibility | Verify WC/PIP coverage |

### 11.2 837 (Health Care Claim) Key Elements

| Loop/Segment | Element | Description |
|---|---|---|
| ST | Transaction Set Header | Identifies 837P (Professional) or 837I (Institutional) |
| 1000A | Submitter | Medical provider/billing service |
| 1000B | Receiver | Insurance company claims system |
| 2000A | Billing Provider | Provider NPI, Tax ID, address |
| 2010AA | Billing Provider Name | Provider name details |
| 2000B | Subscriber | Patient/insured details |
| 2010BA | Subscriber Name | Name, DOB, gender, SSN |
| 2300 | Claim Info | Claim amount, DRG, admission date, date of service, facility code |
| 2310 | Referring/Rendering Provider | Treating physician NPI |
| 2400 | Service Line | CPT/HCPCS code, charge amount, date of service, units, modifier |
| 2430 | Line Adjudication | Prior payer adjudication (if secondary) |

### 11.3 835 (Health Care Payment/Remittance) Key Elements

| Segment | Element | Description |
|---|---|---|
| BPR | Financial Info | Payment amount, payment method, bank routing |
| TRN | Reassociation Trace | Payment trace number |
| N1 | Payee/Payer | Insurance company and provider identification |
| CLP | Claim Payment | Claim-level payment information |
| SVC | Service Payment | Service-line-level payment (CPT code, charged, paid, adjustment) |
| CAS | Adjustments | Adjustment reason codes (contractual, deductible, coinsurance) |
| DTM | Dates | Service dates, adjudication date |

### 11.4 Medical Code Systems

| Code System | Purpose | Example |
|---|---|---|
| ICD-10-CM | Diagnosis codes | S32.010A (Wedge compression fracture of first lumbar vertebra, initial) |
| CPT | Procedure codes (physicians) | 99213 (Office visit, established patient, moderate complexity) |
| HCPCS | Healthcare services/supplies | L0450 (TLSO, custom molded) |
| NDC | Drug/pharmaceutical codes | 00002-7510-01 (specific drug product) |
| Revenue Codes | Facility charges | 0120 (Room and Board - Semi-private) |
| Place of Service | Where service rendered | 11 (Office), 21 (Inpatient Hospital), 23 (ER) |
| DRG | Diagnosis Related Group | 470 (Major hip and knee joint replacement) |

---

## 12. MISMO for Mortgage-Related Property Claims

### 12.1 Overview

MISMO (Mortgage Industry Standards Maintenance Organization) defines data standards for the mortgage industry. When property claims involve mortgaged properties, claims systems must interface with mortgage servicers using MISMO-aligned data.

### 12.2 Claims-Mortgage Integration Points

| Integration Point | Data Exchanged | Direction |
|---|---|---|
| Loss Payee Notification | Claim filed notification with property/loss details | Claims → Mortgage Servicer |
| Two-Party Check Endorsement | Check issued jointly; mortgage servicer must endorse | Claims → Mortgage Servicer |
| Inspection Request | Mortgage servicer may request property inspection | Mortgage Servicer → Claims |
| Repair Progress | Update on repair status and inspections | Claims → Mortgage Servicer |
| Final Payment Release | Release of held funds after repairs verified | Mortgage Servicer → Claims |

### 12.3 MISMO-Relevant Data Elements

| Element | Description |
|---|---|
| MortgageLoanNumber | Unique loan identifier |
| MortgageeClause | Name and address of mortgage company as it appears on policy |
| PropertyAddress | Standardized property address |
| LoanBalance | Outstanding mortgage balance |
| LossPayeeType | First Mortgagee, Second Mortgagee, Contract Purchaser |
| InsuranceClaimNumber | Cross-reference to insurance claim |
| PropertyInspectionResults | Condition assessment |

---

## 13. JSON/REST API Representations

### 13.1 Modern Claims API Design Principles

```
API Design Principles for Claims:

1. RESTful resource-oriented design
2. JSON as primary data format
3. ACORD-aligned field names where practical
4. Versioned APIs (URL or header-based)
5. OAuth 2.0 / OpenID Connect for authentication
6. Pagination for list endpoints
7. HATEOAS links for navigation
8. Webhook/event notifications for async updates
9. Idempotency keys for payment/financial operations
10. Comprehensive error responses with ACORD-aligned error codes
```

### 13.2 Claims API Resource Model

```
REST API Endpoints:

Claims
  POST   /api/v1/claims                    — Create claim (FNOL)
  GET    /api/v1/claims                    — Search/list claims
  GET    /api/v1/claims/{claimId}          — Get claim details
  PATCH  /api/v1/claims/{claimId}          — Update claim
  POST   /api/v1/claims/{claimId}/close    — Close claim
  POST   /api/v1/claims/{claimId}/reopen   — Reopen claim

Features
  GET    /api/v1/claims/{claimId}/features
  POST   /api/v1/claims/{claimId}/features
  GET    /api/v1/claims/{claimId}/features/{featureId}
  PATCH  /api/v1/claims/{claimId}/features/{featureId}

Parties
  GET    /api/v1/claims/{claimId}/parties
  POST   /api/v1/claims/{claimId}/parties
  GET    /api/v1/claims/{claimId}/parties/{partyId}
  PATCH  /api/v1/claims/{claimId}/parties/{partyId}

Reserves
  GET    /api/v1/claims/{claimId}/features/{featureId}/reserves
  POST   /api/v1/claims/{claimId}/features/{featureId}/reserves

Payments
  GET    /api/v1/claims/{claimId}/payments
  POST   /api/v1/claims/{claimId}/payments
  GET    /api/v1/claims/{claimId}/payments/{paymentId}
  POST   /api/v1/claims/{claimId}/payments/{paymentId}/approve
  POST   /api/v1/claims/{claimId}/payments/{paymentId}/void

Activities
  GET    /api/v1/claims/{claimId}/activities
  POST   /api/v1/claims/{claimId}/activities
  PATCH  /api/v1/claims/{claimId}/activities/{activityId}

Notes
  GET    /api/v1/claims/{claimId}/notes
  POST   /api/v1/claims/{claimId}/notes

Documents
  GET    /api/v1/claims/{claimId}/documents
  POST   /api/v1/claims/{claimId}/documents      — Upload
  GET    /api/v1/claims/{claimId}/documents/{docId}
  GET    /api/v1/claims/{claimId}/documents/{docId}/content

Policy Verification
  GET    /api/v1/policies/{policyNumber}/verify?lossDate=2026-03-15
  GET    /api/v1/policies/{policyNumber}/coverages
```

### 13.3 JSON Claim Object — Complete Schema

```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "title": "Claim",
  "type": "object",
  "properties": {
    "claimId": {
      "type": "string",
      "format": "uuid",
      "description": "System-generated unique identifier"
    },
    "claimNumber": {
      "type": "string",
      "maxLength": 20,
      "description": "Business-facing claim number"
    },
    "occurrenceId": {
      "type": "string",
      "format": "uuid"
    },
    "policyNumber": {
      "type": "string"
    },
    "lineOfBusiness": {
      "type": "string",
      "enum": ["AUTOP", "HOME", "COMMAUTO", "COMMPROP", "CGL", "WC", "PROFLIAB", "UMBRELLA", "INLANDMAR", "CRIME"]
    },
    "claimType": {
      "type": "string"
    },
    "status": {
      "type": "string",
      "enum": ["OPEN", "CLOSED", "REOPENED"]
    },
    "subStatus": {
      "type": "string"
    },
    "lossDate": {
      "type": "string",
      "format": "date-time"
    },
    "reportDate": {
      "type": "string",
      "format": "date-time"
    },
    "closeDate": {
      "type": "string",
      "format": "date-time"
    },
    "catastropheCode": {
      "type": "string"
    },
    "causeOfLoss": {
      "type": "object",
      "properties": {
        "code": { "type": "string" },
        "description": { "type": "string" }
      }
    },
    "lossLocation": {
      "$ref": "#/definitions/Address"
    },
    "lossDescription": {
      "type": "string",
      "maxLength": 4000
    },
    "jurisdiction": {
      "type": "string",
      "maxLength": 2
    },
    "assignedAdjuster": {
      "$ref": "#/definitions/UserReference"
    },
    "supervisor": {
      "$ref": "#/definitions/UserReference"
    },
    "financialSummary": {
      "type": "object",
      "properties": {
        "totalIncurred": { "type": "number" },
        "totalPaid": { "type": "number" },
        "totalReserve": { "type": "number" },
        "totalRecovery": { "type": "number" },
        "netIncurred": { "type": "number" }
      }
    },
    "flags": {
      "type": "object",
      "properties": {
        "litigation": { "type": "boolean" },
        "fraud": { "type": "boolean" },
        "subrogation": { "type": "boolean" },
        "catastrophe": { "type": "boolean" },
        "largeLoss": { "type": "boolean" }
      }
    },
    "features": {
      "type": "array",
      "items": { "$ref": "#/definitions/Feature" }
    },
    "parties": {
      "type": "array",
      "items": { "$ref": "#/definitions/ClaimParty" }
    },
    "metadata": {
      "type": "object",
      "properties": {
        "createdBy": { "type": "string" },
        "createdDate": { "type": "string", "format": "date-time" },
        "modifiedBy": { "type": "string" },
        "modifiedDate": { "type": "string", "format": "date-time" },
        "version": { "type": "integer" }
      }
    },
    "_links": {
      "type": "object",
      "description": "HATEOAS navigation links"
    }
  },
  "definitions": {
    "Address": {
      "type": "object",
      "properties": {
        "line1": { "type": "string" },
        "line2": { "type": "string" },
        "city": { "type": "string" },
        "stateCode": { "type": "string" },
        "postalCode": { "type": "string" },
        "countyName": { "type": "string" },
        "countryCode": { "type": "string" }
      }
    },
    "UserReference": {
      "type": "object",
      "properties": {
        "userId": { "type": "string" },
        "displayName": { "type": "string" }
      }
    },
    "Feature": {
      "type": "object",
      "properties": {
        "featureId": { "type": "string", "format": "uuid" },
        "featureNumber": { "type": "string" },
        "coverageCode": { "type": "string" },
        "coverageDescription": { "type": "string" },
        "claimantPartyId": { "type": "string" },
        "featureType": { "type": "string", "enum": ["FIRST_PARTY", "THIRD_PARTY"] },
        "status": { "type": "string" },
        "financials": {
          "type": "object",
          "properties": {
            "lossReserve": { "type": "number" },
            "expenseReserve": { "type": "number" },
            "lossPaid": { "type": "number" },
            "expensePaid": { "type": "number" },
            "totalIncurred": { "type": "number" },
            "recoveryAmount": { "type": "number" },
            "deductibleApplied": { "type": "number" }
          }
        }
      }
    },
    "ClaimParty": {
      "type": "object",
      "properties": {
        "partyId": { "type": "string", "format": "uuid" },
        "role": { "type": "string" },
        "isPrimary": { "type": "boolean" },
        "person": { "$ref": "#/definitions/Person" },
        "organization": { "$ref": "#/definitions/Organization" },
        "address": { "$ref": "#/definitions/Address" },
        "phone": { "type": "string" },
        "email": { "type": "string" },
        "representedBy": { "type": "string", "format": "uuid" },
        "injuries": {
          "type": "array",
          "items": { "$ref": "#/definitions/Injury" }
        }
      }
    },
    "Person": {
      "type": "object",
      "properties": {
        "firstName": { "type": "string" },
        "middleName": { "type": "string" },
        "lastName": { "type": "string" },
        "dateOfBirth": { "type": "string", "format": "date" },
        "gender": { "type": "string" }
      }
    },
    "Organization": {
      "type": "object",
      "properties": {
        "name": { "type": "string" },
        "taxId": { "type": "string" }
      }
    },
    "Injury": {
      "type": "object",
      "properties": {
        "bodyPartCode": { "type": "string" },
        "injuryNatureCode": { "type": "string" },
        "severityCode": { "type": "string" },
        "description": { "type": "string" },
        "hospitalized": { "type": "boolean" }
      }
    }
  }
}
```

---

## 14. Code Lists and Reference Data

### 14.1 ISO Cause of Loss Codes (Selected)

| Code | Description | Lines |
|---|---|---|
| 01 | Fire | Property, Auto |
| 02 | Lightning | Property |
| 03 | Windstorm/Hurricane | Property |
| 04 | Hail | Property, Auto |
| 05 | Explosion | Property |
| 06 | Riot/Civil Commotion | Property |
| 07 | Aircraft/Vehicle impact | Property |
| 08 | Smoke | Property |
| 09 | Vandalism | Property, Auto |
| 10 | Theft/Burglary | Property, Auto |
| 11 | Water Damage (sudden/accidental) | Property |
| 12 | Weight of Ice/Snow | Property |
| 13 | Freezing of Plumbing | Property |
| 14 | Collapse | Property |
| 15 | Glass Breakage | Property |
| 20 | Collision with another vehicle | Auto |
| 21 | Collision with fixed object | Auto |
| 22 | Rollover/Overturn | Auto |
| 23 | Comprehensive - Animal | Auto |
| 24 | Comprehensive - Flood | Auto |
| 25 | Comprehensive - Theft | Auto |
| 26 | Comprehensive - Vandalism | Auto |
| 27 | Comprehensive - Glass | Auto |
| 28 | Comprehensive - Falling Object | Auto |
| 29 | Comprehensive - Fire | Auto |
| 30 | Slip/Trip/Fall | GL |
| 31 | Assault/Battery | GL |
| 32 | Product Defect | GL |
| 33 | Professional Error | E&O |
| 40 | Strain/Sprain | WC |
| 41 | Cut/Laceration | WC |
| 42 | Fracture | WC |
| 43 | Contusion/Bruise | WC |
| 44 | Burn | WC |
| 45 | Caught In/Between | WC |
| 46 | Fall from Elevation | WC |
| 47 | Struck By Object | WC |
| 48 | Motor Vehicle Accident (work) | WC |
| 49 | Repetitive Motion | WC |
| 50 | Exposure to Toxic Substance | WC |

### 14.2 ISO Coverage Codes (Selected)

| Code | Description | Line |
|---|---|---|
| BI | Bodily Injury Liability | Auto |
| PD | Property Damage Liability | Auto |
| COLL | Collision | Auto |
| COMP | Comprehensive | Auto |
| UMBI | Uninsured Motorist BI | Auto |
| UIMBI | Underinsured Motorist BI | Auto |
| UMPD | Uninsured Motorist PD | Auto |
| PIP | Personal Injury Protection | Auto |
| MEDPAY | Medical Payments | Auto, HO |
| RENT | Rental Reimbursement | Auto |
| TOW | Towing & Labor | Auto |
| COV_A | Dwelling | HO |
| COV_B | Other Structures | HO |
| COV_C | Personal Property | HO |
| COV_D | Loss of Use | HO |
| COV_E | Personal Liability | HO |
| COV_F | Medical Payments to Others | HO |
| BLDG | Building | CP |
| BPP | Business Personal Property | CP |
| BUSINC | Business Income | CP |
| EXTRAEXP | Extra Expense | CP |
| CGL_A | BI & PD Liability | CGL |
| CGL_B | Personal & Advertising Injury | CGL |
| CGL_C | Medical Payments | CGL |
| WC_MED | Medical | WC |
| WC_IND | Indemnity | WC |
| WC_VOC | Vocational Rehab | WC |
| EL | Employers Liability | WC |

### 14.3 Body Part Codes (NCCI/WCIO)

| Code | Description |
|---|---|
| 10 | Head (Multiple) |
| 11 | Skull |
| 12 | Brain |
| 13 | Ear(s) |
| 14 | Eye(s) |
| 15 | Nose |
| 16 | Teeth |
| 17 | Mouth |
| 18 | Face |
| 20 | Neck |
| 30 | Upper Extremities (Multiple) |
| 31 | Shoulder(s) |
| 32 | Upper Arm |
| 33 | Elbow |
| 34 | Lower Arm |
| 35 | Wrist |
| 36 | Hand |
| 37 | Finger(s) |
| 38 | Thumb |
| 40 | Trunk (Multiple) |
| 41 | Upper Back |
| 42 | Lower Back |
| 43 | Disc |
| 44 | Chest |
| 45 | Abdomen |
| 46 | Pelvis |
| 47 | Sacrum/Coccyx |
| 48 | Internal Organs |
| 50 | Lower Extremities (Multiple) |
| 51 | Hip |
| 52 | Upper Leg |
| 53 | Knee |
| 54 | Lower Leg |
| 55 | Ankle |
| 56 | Foot |
| 57 | Toe(s) |
| 58 | Great Toe |
| 60 | Whole Body / Multiple |
| 63 | Lungs |
| 64 | Heart |
| 65 | Spinal Cord |
| 90 | Insufficient Info |
| 91 | No Physical Injury |

### 14.4 Injury Nature Codes (NCCI/WCIO)

| Code | Description |
|---|---|
| 10 | Specific Injury - Not Otherwise Classified |
| 13 | Angina Pectoris |
| 14 | Asphyxiation |
| 15 | Burn |
| 16 | Concussion |
| 17 | Contusion |
| 18 | Crushing |
| 19 | Dislocation |
| 20 | Electric Shock |
| 21 | Enucleation |
| 22 | Foreign Body |
| 23 | Fracture |
| 24 | Freezing/Frostbite |
| 25 | Hearing Loss |
| 26 | Heat Prostration |
| 27 | Hernia |
| 28 | Infection |
| 30 | Inflammation |
| 31 | Laceration |
| 32 | Myocardial Infarction |
| 33 | Poisoning (Systemic) |
| 34 | Puncture |
| 35 | Radiation |
| 36 | Rupture |
| 37 | Severance |
| 38 | Sprain/Strain |
| 40 | Syncope |
| 41 | Vascular |
| 42 | Vision Loss |
| 52 | Carpal Tunnel |
| 53 | COVID-19 |
| 58 | Mental Disorder |
| 59 | Mental Stress |
| 60 | Occupational Disease |
| 70 | Loss of Hearing |
| 71 | Dermatitis |
| 72 | Mental Disorder |
| 73 | Respiratory |
| 80 | Multiple Physical Injuries |
| 90 | Insufficient Info |
| 91 | No Physical Injury |

---

## 15. Sample XML Payloads

### 15.1 Sample 1: Auto Collision FNOL (ClaimNotificationAddRq)

```xml
<?xml version="1.0" encoding="UTF-8"?>
<ACORD xmlns="http://www.ACORD.org/standards/PC_Surety/ACORD1/xml/">
  <SignonRq>
    <SignonPswd>
      <CustId>
        <SPName>AcmeInsurance</SPName>
        <CustLoginId>claimsapi</CustLoginId>
      </CustId>
    </SignonPswd>
    <ClientDt>2026-04-16T14:30:00-05:00</ClientDt>
    <ClientApp>
      <Org>AcmeInsurance</Org>
      <Name>ClaimsCore</Name>
      <Version>5.2</Version>
    </ClientApp>
  </SignonRq>

  <InsuranceSvcRq>
    <RqUID>a1b2c3d4-e5f6-7890-abcd-ef1234567890</RqUID>
    <ClaimsSvc>
      <ClaimNotificationAddRq>
        <RqUID>f47ac10b-58cc-4372-a567-0e02b2c3d479</RqUID>
        <TransactionRequestDt>2026-04-16T14:30:00-05:00</TransactionRequestDt>

        <Policy>
          <PolicyNumber>PAP-2026-001234</PolicyNumber>
          <LOBCd>AUTOP</LOBCd>
          <EffectiveDt>2026-01-15</EffectiveDt>
          <ExpirationDt>2026-07-15</ExpirationDt>
        </Policy>

        <InsuredOrPrincipal>
          <GeneralPartyInfo>
            <NameInfo>
              <PersonName>
                <Surname>Smith</Surname>
                <GivenName>John</GivenName>
                <MiddleName>A</MiddleName>
              </PersonName>
            </NameInfo>
            <Addr>
              <Addr1>123 Main Street</Addr1>
              <City>Anytown</City>
              <StateProvCd>CA</StateProvCd>
              <PostalCode>90210</PostalCode>
            </Addr>
            <Communications>
              <PhoneInfo>
                <PhoneTypeCd>Phone</PhoneTypeCd>
                <PhoneNumber>+15551234567</PhoneNumber>
              </PhoneInfo>
              <EmailInfo>
                <EmailAddr>john.smith@email.com</EmailAddr>
              </EmailInfo>
            </Communications>
          </GeneralPartyInfo>
        </InsuredOrPrincipal>

        <ClaimsOccurrence>
          <LossDt>2026-04-15</LossDt>
          <LossTm>17:45:00</LossTm>
          <ReportedDt>2026-04-16T08:15:00-05:00</ReportedDt>
          <LossDesc>Insured vehicle rear-ended by another vehicle while stopped at red light at intersection of Elm St and Oak Ave. Insured reports moderate rear-end damage to vehicle. No injuries to insured. Other driver complained of neck pain.</LossDesc>
          <Addr>
            <Addr1>Intersection of Elm St and Oak Ave</Addr1>
            <City>Anytown</City>
            <StateProvCd>CA</StateProvCd>
            <PostalCode>90210</PostalCode>
            <County>Los Angeles</County>
          </Addr>
          <CauseOfLossCd>20</CauseOfLossCd>
          <ReportedToPoliceInd>true</ReportedToPoliceInd>
          <PoliceRptInfo>
            <PoliceRptNum>2026-APD-045678</PoliceRptNum>
            <PoliceDeptName>Anytown Police Department</PoliceDeptName>
          </PoliceRptInfo>
        </ClaimsOccurrence>

        <ClaimsParty>
          <ClaimsPartyInfo>
            <ClaimsPartyRoleCd>Insured</ClaimsPartyRoleCd>
          </ClaimsPartyInfo>
          <GeneralPartyInfo>
            <NameInfo>
              <PersonName>
                <Surname>Smith</Surname>
                <GivenName>John</GivenName>
              </PersonName>
            </NameInfo>
          </GeneralPartyInfo>
          <PersonInfo>
            <BirthDt>1985-06-15</BirthDt>
            <GenderCd>M</GenderCd>
          </PersonInfo>
        </ClaimsParty>

        <ClaimsParty>
          <ClaimsPartyInfo>
            <ClaimsPartyRoleCd>Claimant</ClaimsPartyRoleCd>
          </ClaimsPartyInfo>
          <GeneralPartyInfo>
            <NameInfo>
              <PersonName>
                <Surname>Johnson</Surname>
                <GivenName>Robert</GivenName>
              </PersonName>
            </NameInfo>
            <Addr>
              <Addr1>456 Oak Lane</Addr1>
              <City>Anytown</City>
              <StateProvCd>CA</StateProvCd>
              <PostalCode>90211</PostalCode>
            </Addr>
          </GeneralPartyInfo>
          <InjuryInfo>
            <InjuredInd>true</InjuredInd>
            <BodyPartCd>20</BodyPartCd>
            <InjuryNatureCd>38</InjuryNatureCd>
            <InjurySeverityCd>Minor</InjurySeverityCd>
            <TransportedToHospitalInd>false</TransportedToHospitalInd>
          </InjuryInfo>
          <InsuranceInfo>
            <InsurerName>StateWide Insurance Co</InsurerName>
            <PolicyNumber>SW-PAP-789012</PolicyNumber>
          </InsuranceInfo>
        </ClaimsParty>

        <AutoLossInfo>
          <VehicleInfo>
            <VehIdentificationNumber>1HGBH41JXMN109186</VehIdentificationNumber>
            <ModelYear>2024</ModelYear>
            <Manufacturer>Honda</Manufacturer>
            <Model>Civic</Model>
            <BodyTypeCd>Sedan</BodyTypeCd>
            <OdometerReading>28500</OdometerReading>
            <Registration>
              <RegistrationNumber>8ABC123</RegistrationNumber>
              <StateProvCd>CA</StateProvCd>
            </Registration>
            <DriverRef>ClaimsParty_1</DriverRef>
            <OwnerRef>ClaimsParty_1</OwnerRef>
            <VehDamageInfo>
              <DamageDesc>Moderate rear-end damage. Bumper, trunk lid, tail lights, rear quarter panels affected.</DamageDesc>
              <PointOfImpactCd>Rear</PointOfImpactCd>
              <DamageEstimateAmt>
                <Amt>4500.00</Amt>
                <CurCd>USD</CurCd>
              </DamageEstimateAmt>
              <DrivableInd>true</DrivableInd>
              <AirbagDeployedInd>false</AirbagDeployedInd>
              <TowedInd>false</TowedInd>
            </VehDamageInfo>
          </VehicleInfo>

          <VehicleInfo>
            <VehIdentificationNumber>2T1BR32E15C461234</VehIdentificationNumber>
            <ModelYear>2023</ModelYear>
            <Manufacturer>Toyota</Manufacturer>
            <Model>Corolla</Model>
            <BodyTypeCd>Sedan</BodyTypeCd>
            <DriverRef>ClaimsParty_2</DriverRef>
            <OwnerRef>ClaimsParty_2</OwnerRef>
            <VehDamageInfo>
              <DamageDesc>Front bumper, hood damage from impact.</DamageDesc>
              <PointOfImpactCd>Front</PointOfImpactCd>
              <DrivableInd>true</DrivableInd>
            </VehDamageInfo>
          </VehicleInfo>

          <NumberOfVehicles>2</NumberOfVehicles>
          <IntersectionInd>true</IntersectionInd>
          <WeatherConditionCd>Clear</WeatherConditionCd>
          <LightConditionCd>Daylight</LightConditionCd>
          <RoadConditionCd>Dry</RoadConditionCd>
        </AutoLossInfo>

      </ClaimNotificationAddRq>
    </ClaimsSvc>
  </InsuranceSvcRq>
</ACORD>
```

### 15.2 Sample 2: Property Loss FNOL (Homeowner Water Damage)

```xml
<ClaimNotificationAddRq>
  <RqUID>b2c3d4e5-f6a7-8901-bcde-f23456789012</RqUID>
  <TransactionRequestDt>2026-04-16T09:00:00-05:00</TransactionRequestDt>

  <Policy>
    <PolicyNumber>HO3-2026-005678</PolicyNumber>
    <LOBCd>HOME</LOBCd>
    <EffectiveDt>2025-12-01</EffectiveDt>
    <ExpirationDt>2026-12-01</ExpirationDt>
  </Policy>

  <InsuredOrPrincipal>
    <GeneralPartyInfo>
      <NameInfo>
        <PersonName>
          <Surname>Williams</Surname>
          <GivenName>Sarah</GivenName>
          <MiddleName>M</MiddleName>
        </PersonName>
      </NameInfo>
      <Addr>
        <Addr1>789 Maple Drive</Addr1>
        <City>Springfield</City>
        <StateProvCd>IL</StateProvCd>
        <PostalCode>62701</PostalCode>
      </Addr>
      <Communications>
        <PhoneInfo>
          <PhoneTypeCd>Mobile</PhoneTypeCd>
          <PhoneNumber>+12175551234</PhoneNumber>
        </PhoneInfo>
      </Communications>
    </GeneralPartyInfo>
  </InsuredOrPrincipal>

  <ClaimsOccurrence>
    <LossDt>2026-04-14</LossDt>
    <LossTm>23:30:00</LossTm>
    <ReportedDt>2026-04-15T07:00:00-05:00</ReportedDt>
    <LossDesc>Insured discovered water in kitchen at approximately 11:30 PM. Source was a burst pipe under the kitchen sink. Water had been flowing for estimated 2-3 hours. Kitchen floor (hardwood), lower cabinets, baseboards, and drywall are water damaged. Some personal property in lower cabinets damaged.</LossDesc>
    <Addr>
      <Addr1>789 Maple Drive</Addr1>
      <City>Springfield</City>
      <StateProvCd>IL</StateProvCd>
      <PostalCode>62701</PostalCode>
      <County>Sangamon</County>
    </Addr>
    <CauseOfLossCd>13</CauseOfLossCd>
  </ClaimsOccurrence>

  <PropertyLossInfo>
    <PropertyInfo>
      <Addr>
        <Addr1>789 Maple Drive</Addr1>
        <City>Springfield</City>
        <StateProvCd>IL</StateProvCd>
        <PostalCode>62701</PostalCode>
      </Addr>
      <ConstructionCd>Frame</ConstructionCd>
      <YearBuilt>1998</YearBuilt>
      <SquareFootage>2200</SquareFootage>
      <OccupancyCd>OwnerOccupied</OccupancyCd>
      <NumberOfStories>2</NumberOfStories>
    </PropertyInfo>
    <PropertyDamageInfo>
      <DamageDesc>Kitchen hardwood floor buckled, lower kitchen cabinets warped, baseboards damaged, drywall water stained up to 18 inches. Contents in lower cabinets (pots, pans, small appliances) affected.</DamageDesc>
      <DamagedAreaDesc>Kitchen (first floor)</DamagedAreaDesc>
      <HabitableInd>true</HabitableInd>
      <EmergencyRepairsNeededInd>true</EmergencyRepairsNeededInd>
    </PropertyDamageInfo>
    <BuildingDamageEstimateAmt>
      <Amt>15000.00</Amt>
      <CurCd>USD</CurCd>
    </BuildingDamageEstimateAmt>
    <ContentsDamageEstimateAmt>
      <Amt>2000.00</Amt>
      <CurCd>USD</CurCd>
    </ContentsDamageEstimateAmt>
  </PropertyLossInfo>

</ClaimNotificationAddRq>
```

### 15.3 Sample 3: ClaimInquiryRs (Status Response)

```xml
<ClaimInquiryRs>
  <RsUID>c3d4e5f6-a7b8-9012-cdef-345678901234</RsUID>
  <MsgStatusCd>Success</MsgStatusCd>
  
  <ClaimNumber>CLM-2026-001234</ClaimNumber>
  <ClaimStatusCd>Open</ClaimStatusCd>
  <ClaimSubStatusCd>Investigation</ClaimSubStatusCd>
  
  <Policy>
    <PolicyNumber>PAP-2026-001234</PolicyNumber>
    <LOBCd>AUTOP</LOBCd>
    <EffectiveDt>2026-01-15</EffectiveDt>
    <ExpirationDt>2026-07-15</ExpirationDt>
    <PolicyStatusCd>Active</PolicyStatusCd>
  </Policy>

  <ClaimsOccurrence>
    <LossDt>2026-04-15</LossDt>
    <CauseOfLossCd>20</CauseOfLossCd>
    <CatastropheCd/>
    <LossDesc>Rear-end collision at intersection.</LossDesc>
  </ClaimsOccurrence>

  <ClaimFeature>
    <FeatureNumber>001</FeatureNumber>
    <CoverageCd>COLL</CoverageCd>
    <CoverageDesc>Collision</CoverageDesc>
    <FeatureTypeCd>FirstParty</FeatureTypeCd>
    <FeatureStatusCd>Open</FeatureStatusCd>
    <ReserveInfo>
      <ReserveTypeCd>Loss</ReserveTypeCd>
      <Amt>4500.00</Amt>
    </ReserveInfo>
    <ReserveInfo>
      <ReserveTypeCd>Expense</ReserveTypeCd>
      <Amt>0.00</Amt>
    </ReserveInfo>
    <PaidAmt>0.00</PaidAmt>
  </ClaimFeature>

  <ClaimFeature>
    <FeatureNumber>002</FeatureNumber>
    <CoverageCd>BI</CoverageCd>
    <CoverageDesc>Bodily Injury Liability</CoverageDesc>
    <FeatureTypeCd>ThirdParty</FeatureTypeCd>
    <FeatureStatusCd>Open</FeatureStatusCd>
    <ClaimantRef>Party_2</ClaimantRef>
    <ReserveInfo>
      <ReserveTypeCd>Loss</ReserveTypeCd>
      <Amt>15000.00</Amt>
    </ReserveInfo>
    <ReserveInfo>
      <ReserveTypeCd>Expense</ReserveTypeCd>
      <Amt>3000.00</Amt>
    </ReserveInfo>
    <PaidAmt>0.00</PaidAmt>
  </ClaimFeature>

  <FinancialSummary>
    <TotalIncurred>22500.00</TotalIncurred>
    <TotalPaid>0.00</TotalPaid>
    <TotalReserve>22500.00</TotalReserve>
    <TotalRecovery>0.00</TotalRecovery>
  </FinancialSummary>

  <AssignedAdjuster>
    <NameInfo>
      <PersonName>
        <Surname>Garcia</Surname>
        <GivenName>Maria</GivenName>
      </PersonName>
    </NameInfo>
    <AdjusterNumber>ADJ-5678</AdjusterNumber>
  </AssignedAdjuster>
</ClaimInquiryRs>
```

### 15.4 Sample 4: Claim Payment Request

```xml
<ClaimsPaymentAddRq>
  <RqUID>d4e5f6a7-b8c9-0123-defa-456789012345</RqUID>
  <TransactionRequestDt>2026-04-20T11:00:00-05:00</TransactionRequestDt>
  
  <ClaimNumber>CLM-2026-001234</ClaimNumber>
  <FeatureNumber>001</FeatureNumber>
  
  <ClaimsPayment>
    <PaymentTypeCd>Loss</PaymentTypeCd>
    <PaymentCategoryCd>Indemnity</PaymentCategoryCd>
    <PaymentMethodCd>Check</PaymentMethodCd>
    <Amt>3800.00</Amt>
    <CurCd>USD</CurCd>
    
    <PayeeInfo>
      <NameInfo>
        <CommlName>
          <CommercialName>Precision Auto Body</CommercialName>
        </CommlName>
      </NameInfo>
      <Addr>
        <Addr1>100 Auto Repair Blvd</Addr1>
        <City>Anytown</City>
        <StateProvCd>CA</StateProvCd>
        <PostalCode>90210</PostalCode>
      </Addr>
      <TaxIdentity>
        <TaxIdTypeCd>FEIN</TaxIdTypeCd>
        <TaxId>95-1234567</TaxId>
      </TaxIdentity>
    </PayeeInfo>
    
    <PaymentMemo>Collision repair - estimate #EST-2026-001234. $4,300 estimate less $500 deductible.</PaymentMemo>
    <InvoiceNumber>INV-2026-9876</InvoiceNumber>
    <ServiceFromDt>2026-04-18</ServiceFromDt>
    <ServiceToDt>2026-04-20</ServiceToDt>
    <TaxReportableInd>true</TaxReportableInd>
    <TaxFormTypeCd>1099-NEC</TaxFormTypeCd>
  </ClaimsPayment>
</ClaimsPaymentAddRq>
```

### 15.5 Sample 5: Workers Comp FROI (ACORD/EDI Format)

```xml
<ClaimNotificationAddRq>
  <RqUID>e5f6a7b8-c9d0-1234-efab-567890123456</RqUID>
  <TransactionRequestDt>2026-04-16T16:00:00-05:00</TransactionRequestDt>

  <Policy>
    <PolicyNumber>WC-2026-009876</PolicyNumber>
    <LOBCd>WC</LOBCd>
    <EffectiveDt>2026-01-01</EffectiveDt>
    <ExpirationDt>2027-01-01</ExpirationDt>
  </Policy>

  <InsuredOrPrincipal>
    <GeneralPartyInfo>
      <NameInfo>
        <CommlName>
          <CommercialName>Springfield Manufacturing Inc</CommercialName>
        </CommlName>
      </NameInfo>
      <Addr>
        <Addr1>500 Industrial Parkway</Addr1>
        <City>Springfield</City>
        <StateProvCd>IL</StateProvCd>
        <PostalCode>62702</PostalCode>
      </Addr>
    </GeneralPartyInfo>
    <InsuredOrPrincipalInfo>
      <BusinessInfo>
        <FEIN>37-1234567</FEIN>
        <SICCd>3444</SICCd>
      </BusinessInfo>
    </InsuredOrPrincipalInfo>
  </InsuredOrPrincipal>

  <ClaimsOccurrence>
    <LossDt>2026-04-15</LossDt>
    <LossTm>10:30:00</LossTm>
    <ReportedDt>2026-04-15T14:00:00-05:00</ReportedDt>
    <LossDesc>Employee was lifting 50lb box of metal parts from ground level to a shelf approximately 4 feet high. Employee felt sudden sharp pain in lower back and was unable to continue working. Reported to supervisor immediately.</LossDesc>
    <Addr>
      <Addr1>500 Industrial Parkway, Warehouse B</Addr1>
      <City>Springfield</City>
      <StateProvCd>IL</StateProvCd>
      <PostalCode>62702</PostalCode>
    </Addr>
    <CauseOfLossCd>40</CauseOfLossCd>
  </ClaimsOccurrence>

  <ClaimsParty>
    <ClaimsPartyInfo>
      <ClaimsPartyRoleCd>Claimant</ClaimsPartyRoleCd>
    </ClaimsPartyInfo>
    <GeneralPartyInfo>
      <NameInfo>
        <PersonName>
          <Surname>Martinez</Surname>
          <GivenName>Carlos</GivenName>
        </PersonName>
      </NameInfo>
      <Addr>
        <Addr1>234 Elm Street</Addr1>
        <City>Springfield</City>
        <StateProvCd>IL</StateProvCd>
        <PostalCode>62703</PostalCode>
      </Addr>
    </GeneralPartyInfo>
    <PersonInfo>
      <BirthDt>1988-03-22</BirthDt>
      <GenderCd>M</GenderCd>
      <MaritalStatusCd>Married</MaritalStatusCd>
      <OccupationDesc>Warehouse Associate</OccupationDesc>
    </PersonInfo>
    <InjuryInfo>
      <InjuredInd>true</InjuredInd>
      <BodyPartCd>42</BodyPartCd>
      <InjuryNatureCd>38</InjuryNatureCd>
      <InjurySeverityCd>Moderate</InjurySeverityCd>
      <TransportedToHospitalInd>false</TransportedToHospitalInd>
      <DeathInd>false</DeathInd>
    </InjuryInfo>
  </ClaimsParty>

  <WCLossInfo>
    <EmployerInfo>
      <EmployerName>Springfield Manufacturing Inc</EmployerName>
      <FEIN>37-1234567</FEIN>
      <NumEmployees>150</NumEmployees>
      <NCCIClassCd>3632</NCCIClassCd>
    </EmployerInfo>
    <EmployeeInfo>
      <HireDt>2020-06-01</HireDt>
      <OccupationDesc>Warehouse Associate</OccupationDesc>
      <EmploymentStatusCd>FullTime</EmploymentStatusCd>
      <DaysWorkedPerWeek>5</DaysWorkedPerWeek>
    </EmployeeInfo>
    <WageInfo>
      <AverageWeeklyWage>
        <Amt>920.00</Amt>
        <CurCd>USD</CurCd>
      </AverageWeeklyWage>
      <FullWagesPaidDOI>true</FullWagesPaidDOI>
    </WageInfo>
    <DisabilityInfo>
      <DateDisabilityBegan>2026-04-16</DateDisabilityBegan>
      <ReturnToWorkDt/>
      <DisabilityTypeCd>TTD</DisabilityTypeCd>
    </DisabilityInfo>
    <JurisdictionCd>IL</JurisdictionCd>
    <JurisdictionClaimNumber/>
    <MedicalAuthorizationInd>true</MedicalAuthorizationInd>
    <InitialTreatmentCd>MinorByEmployerPhysician</InitialTreatmentCd>
  </WCLossInfo>

</ClaimNotificationAddRq>
```

---

## 16. Data Mapping: ACORD to Internal Models

### 16.1 Mapping Table — ACORD XML to Internal Claims Database

| ACORD XML Path | Internal Field | Transform |
|---|---|---|
| `ClaimNotificationAddRq/RqUID` | `fnol_request_id` | Direct mapping |
| `Policy/PolicyNumber` | `claim.policy_number` | Direct mapping |
| `Policy/LOBCd` | `claim.line_of_business` | Code mapping (AUTOP→PA, HOME→HO) |
| `ClaimsOccurrence/LossDt` + `LossTm` | `claim.loss_date` | Combine date + time to datetime |
| `ClaimsOccurrence/ReportedDt` | `claim.report_date` | Direct mapping |
| `ClaimsOccurrence/LossDesc` | `claim.loss_description` | Direct mapping |
| `ClaimsOccurrence/Addr/*` | `claim.loss_location_*` | Map each address component |
| `ClaimsOccurrence/CauseOfLossCd` | `claim.cause_of_loss` | Direct mapping (ISO codes) |
| `ClaimsOccurrence/CatastropheCd` | `claim.catastrophe_code` | Direct mapping |
| `ClaimsParty/ClaimsPartyInfo/ClaimsPartyRoleCd` | `claim_party.party_role` | Code mapping |
| `ClaimsParty/GeneralPartyInfo/NameInfo/PersonName/Surname` | `party.last_name` | Direct mapping |
| `ClaimsParty/GeneralPartyInfo/NameInfo/PersonName/GivenName` | `party.first_name` | Direct mapping |
| `ClaimsParty/GeneralPartyInfo/Addr/*` | `party.address_*` | Map each component |
| `ClaimsParty/PersonInfo/BirthDt` | `party.date_of_birth` | Direct mapping |
| `ClaimsParty/InjuryInfo/BodyPartCd` | `feature.body_part_code` | Direct mapping |
| `ClaimsParty/InjuryInfo/InjuryNatureCd` | `feature.nature_of_injury_code` | Direct mapping |
| `AutoLossInfo/VehicleInfo/VehIdentificationNumber` | `vehicle.vin` | Direct mapping |
| `AutoLossInfo/VehicleInfo/ModelYear` | `vehicle.year` | Direct mapping |
| `AutoLossInfo/VehicleInfo/Manufacturer` | `vehicle.make` | Direct mapping |
| `AutoLossInfo/VehicleInfo/Model` | `vehicle.model` | Direct mapping |
| `AutoLossInfo/VehicleInfo/VehDamageInfo/PointOfImpactCd` | `vehicle.point_of_impact` | Direct mapping |
| `AutoLossInfo/VehicleInfo/VehDamageInfo/DrivableInd` | `vehicle.drivable` | Boolean |
| `PropertyLossInfo/PropertyInfo/ConstructionCd` | `property.construction_type` | Code mapping |
| `PropertyLossInfo/PropertyInfo/YearBuilt` | `property.year_built` | Direct mapping |
| `PropertyLossInfo/PropertyDamageInfo/HabitableInd` | `property.habitability_status` | Map to Habitable/Uninhabitable |

### 16.2 Transformation Considerations

| Scenario | Approach |
|---|---|
| Missing optional fields | Apply defaults or leave null; document which fields are required vs. optional in your system |
| Code value mismatches | Maintain code mapping tables; unknown codes logged and queued for review |
| Multiple party roles | Create separate `claim_party` records; one `party` can have multiple `claim_party` records per claim |
| Nested addresses | Flatten to individual fields in relational model |
| Date/time formats | Normalize to UTC internally; store original timezone offset |
| Currency amounts | Ensure consistent decimal precision (2 decimal places for USD) |
| VIN validation | Apply VIN check-digit validation; flag invalid VINs |
| Enumerated code lists | Validate against maintained reference data tables; reject or flag unknown codes |

---

## 17. Canonical Data Model Design

### 17.1 Canonical Data Model Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                  CANONICAL DATA MODEL (CDM)                      │
│                                                                  │
│  Purpose: A single, normalized representation of claims data     │
│  that all systems map to/from. Decouples source systems from     │
│  target systems.                                                 │
│                                                                  │
│  ┌──────────┐    ┌──────────────┐    ┌──────────┐               │
│  │ Source A  │───►│              │───►│ Target X │               │
│  │ (ACORD    │    │  CANONICAL   │    │ (Claims  │               │
│  │  XML)     │    │  DATA MODEL  │    │  System) │               │
│  └──────────┘    │              │    └──────────┘               │
│  ┌──────────┐    │  Single      │    ┌──────────┐               │
│  │ Source B  │───►│  Source of   │───►│ Target Y │               │
│  │ (AL3)     │    │  Truth for   │    │ (Data    │               │
│  └──────────┘    │  Data        │    │  Warehouse│               │
│  ┌──────────┐    │  Structure   │    └──────────┘               │
│  │ Source C  │───►│              │    ┌──────────┐               │
│  │ (JSON API)│    │              │───►│ Target Z │               │
│  └──────────┘    └──────────────┘    │ (Vendor  │               │
│                                      │  System) │               │
│                                      └──────────┘               │
│                                                                  │
│  Benefits:                                                       │
│  ✓ N+M integrations instead of N×M                              │
│  ✓ Single place to enforce data quality                         │
│  ✓ Easier to add new sources/targets                            │
│  ✓ Clear ownership of data definitions                          │
│  ✓ Consistent reporting across all systems                      │
└─────────────────────────────────────────────────────────────────┘
```

### 17.2 CDM Design Principles

| Principle | Description |
|---|---|
| **Industry-Aligned** | Base CDM on ACORD PC Data Model; extend where needed |
| **Normalized** | 3NF minimum; avoid redundancy; use reference data tables for codes |
| **Extensible** | Support custom fields/attributes without schema changes (EAV or JSON columns) |
| **Versioned** | Track schema version; support backward compatibility |
| **Documented** | Every entity, attribute, and relationship documented with business meaning |
| **Governed** | Data steward ownership; change management process for modifications |
| **Platform-Agnostic** | Logical model independent of physical implementation (RDBMS, NoSQL, etc.) |
| **Event-Friendly** | Design supports event-driven architecture (entity state changes as events) |

### 17.3 CDM Entity Summary

| CDM Entity | ACORD Equivalent | Key Purpose |
|---|---|---|
| `cdm.Claim` | Claim | Central claims entity |
| `cdm.Occurrence` | ClaimsOccurrence | Incident that triggered claims |
| `cdm.Policy` | Agreement | Policy reference (from PAS) |
| `cdm.Coverage` | AgreementCoverage | Coverage details |
| `cdm.Feature` | ClaimFeature | Coverage exposure within claim |
| `cdm.Party` | Party | Person or organization |
| `cdm.ClaimParty` | ClaimsParty | Party's role in a claim |
| `cdm.Reserve` | ReserveInfo | Reserve transactions |
| `cdm.Payment` | ClaimsPayment | Payment transactions |
| `cdm.Activity` | ClaimsActivity | Tasks and diary items |
| `cdm.Note` | Remark | Notes and correspondence log |
| `cdm.Document` | DocumentInfo | Document references |
| `cdm.Vehicle` | VehicleInfo | Vehicle details |
| `cdm.Property` | PropertyInfo | Property details |
| `cdm.Injury` | InjuryInfo | Injury details |
| `cdm.Subrogation` | (Custom) | Subrogation tracking |
| `cdm.Litigation` | (Custom) | Litigation tracking |
| `cdm.ReferenceCode` | (CodeList) | All reference/lookup codes |

### 17.4 CDM Implementation Patterns

| Pattern | When to Use | Implementation |
|---|---|---|
| **Shared Database** | Monolithic claims system | CDM is the operational database |
| **Integration Hub** | ESB/iPaaS-based integration | CDM in the integration layer; transforms in/out |
| **Event Store** | Event-driven microservices | CDM defines event payload schemas |
| **Data Lake CDM** | Analytics and reporting | CDM defines the curated/conformed layer |
| **API Contract** | API-first architecture | CDM defines request/response schemas (OpenAPI) |

---

*End of Article 3 — ACORD Standards, Data Formats & Industry Data Models*
