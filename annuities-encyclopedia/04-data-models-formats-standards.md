# Chapter 4 — Data Models, Formats, and Standards in Annuities

## An Exhaustive Reference for Solution Architects

---

> **Audience:** Solution architects, data engineers, and technical leads building or modernizing annuity administration, distribution, and reporting systems.
>
> **Scope:** This chapter provides an encyclopedia-level treatment of every data standard, file format, schema convention, and data-modeling pattern that a modern annuity platform must understand, produce, or consume.

---

## Table of Contents

1. [ACORD Standards for Annuities](#1-acord-standards-for-annuities)
2. [DTCC / NSCC Standards](#2-dtcc--nscc-standards)
3. [NAIC Data Standards](#3-naic-data-standards)
4. [Canonical Data Model for Annuities](#4-canonical-data-model-for-annuities)
5. [Database Schema Design](#5-database-schema-design)
6. [Event-Driven Data Formats](#6-event-driven-data-formats)
7. [API Data Contracts](#7-api-data-contracts)
8. [File-Based Data Formats](#8-file-based-data-formats)
9. [Data Dictionary](#9-data-dictionary)
10. [Master Data Management](#10-master-data-management)
11. [Data Quality Rules](#11-data-quality-rules)
12. [Data Mapping & Transformation](#12-data-mapping--transformation)

---

# 1. ACORD Standards for Annuities

## 1.1 Overview of ACORD in the Life & Annuity Space

ACORD (Association for Cooperative Operations Research and Development) is the global standards-setting body for the insurance and financial-services industry. For annuities specifically, ACORD provides:

- **Data models** — the OLifE (Open Life Financial Exchange) object model
- **XML schemas** — machine-readable definitions of every transaction
- **Forms** — paper and electronic application, replacement, and transfer forms
- **Transaction standards** — message pairs (request / response) for new business, policy service, claims, and financial reporting
- **Code lists** — enumerated value sets (OLI_ codes) for product types, transaction types, statuses, and hundreds of other domains

ACORD standards are versioned; the most widely adopted baseline is **ACORD Life v2.x** (XML), with incremental updates published roughly annually. Carriers, distributors, and technology vendors that participate in ACORD certification programs commit to supporting specific versions.

## 1.2 The OLifE Object Model

The OLifE object model is the conceptual backbone of ACORD Life/Annuity data exchange. Understanding its entity hierarchy is essential before touching any XML schema or API design.

### 1.2.1 Core Object Hierarchy

```
TXLife
├── TXLifeRequest / TXLifeResponse
│   ├── TransRefGUID
│   ├── TransType (tc value)
│   ├── OLifE
│   │   ├── SourceInfo
│   │   ├── Party (0..n)
│   │   │   ├── PartyKey
│   │   │   ├── PersonOrOrganization
│   │   │   │   ├── Person
│   │   │   │   │   ├── FirstName, LastName, MiddleName
│   │   │   │   │   ├── BirthDate, Gender, Citizenship
│   │   │   │   │   ├── DriversLicenseNum, GovtID (SSN/TIN)
│   │   │   │   │   └── ...
│   │   │   │   └── Organization
│   │   │   │       ├── OrgForm (tc), DTCCMemberCode
│   │   │   │       └── ...
│   │   │   ├── Address (0..n)
│   │   │   ├── Phone (0..n)
│   │   │   ├── EMailAddress (0..n)
│   │   │   ├── Risk (underwriting context)
│   │   │   ├── Producer (agent context)
│   │   │   │   ├── CarrierAppointment (0..n)
│   │   │   │   └── ...
│   │   │   └── Client
│   │   │       ├── PrefLanguage, MaritalStat
│   │   │       └── ...
│   │   │
│   │   ├── Holding (0..n)
│   │   │   ├── HoldingKey
│   │   │   ├── HoldingTypeCode (tc=2 → Policy)
│   │   │   ├── Policy
│   │   │   │   ├── PolNumber, CarrierCode, PlanName
│   │   │   │   ├── ProductType (tc)
│   │   │   │   ├── PolicyStatus (tc)
│   │   │   │   ├── Life | Annuity | DisabilityHealth
│   │   │   │   │   └── (for annuity ↓)
│   │   │   │   │       Annuity
│   │   │   │   │       ├── QualPlanType (tc)  -- IRA, 401k, NQ, etc.
│   │   │   │   │       ├── AnnuityProduct (tc) -- FA, VA, IA, RILA
│   │   │   │   │       ├── InitPaymentAmt
│   │   │   │   │       ├── Payout (0..n)
│   │   │   │   │       │   ├── PayoutType (tc)
│   │   │   │   │       │   ├── PayoutMode (tc)
│   │   │   │   │       │   └── ...
│   │   │   │   │       ├── SubAccount (0..n)
│   │   │   │   │       │   ├── SubAcctKey
│   │   │   │   │       │   ├── FundID / CUSIP
│   │   │   │   │       │   ├── AllocPercent
│   │   │   │   │       │   ├── SubAcctValue
│   │   │   │   │       │   └── ...
│   │   │   │   │       └── Rider (0..n)
│   │   │   │   │           ├── RiderTypeCode (tc)
│   │   │   │   │           ├── RiderStatus (tc)
│   │   │   │   │           └── ...
│   │   │   │   │
│   │   │   │   ├── ApplicationInfo
│   │   │   │   │   ├── AppType (tc)
│   │   │   │   │   ├── SignedDate, SubmissionDate
│   │   │   │   │   ├── ReplacementInd
│   │   │   │   │   └── ...
│   │   │   │   ├── FinancialActivity (0..n)
│   │   │   │   │   ├── FinActivityType (tc)
│   │   │   │   │   ├── FinActivityDate, FinActivityAmt
│   │   │   │   │   └── FinActivitySubType
│   │   │   │   ├── RequirementInfo (0..n)
│   │   │   │   └── Endorsement (0..n)
│   │   │   │
│   │   │   ├── Investment (holdings context)
│   │   │   │   ├── SubAccount (0..n)
│   │   │   │   └── ...
│   │   │   └── Banking (payment/EFT context)
│   │   │
│   │   ├── Relation (0..n)
│   │   │   ├── OriginatingObjectID → PartyKey or HoldingKey
│   │   │   ├── RelatedObjectID → PartyKey or HoldingKey
│   │   │   ├── RelationRoleCode (tc)
│   │   │   │   e.g., OLI_REL_OWNER, OLI_REL_ANNUITANT,
│   │   │   │        OLI_REL_BENEFICIARY, OLI_REL_AGENT
│   │   │   ├── BeneficiaryDesignation (if beneficiary)
│   │   │   └── InterestPercent
│   │   │
│   │   └── FormInstance (0..n)
│   │       ├── FormName
│   │       ├── ProviderFormNumber
│   │       └── Attachment (base64 content)
│   │
│   └── TransResult
│       ├── ResultCode (tc)
│       └── ResultInfo (0..n)
│           ├── ResultInfoCode (tc)
│           └── ResultInfoDesc
```

### 1.2.2 Entity Descriptions

| OLifE Entity | Purpose | Key Attributes |
|---|---|---|
| **TXLife** | Root envelope | Version, SchemaVersion |
| **TXLifeRequest** | Inbound transaction request | TransRefGUID, TransType, TransExeDate, TransMode |
| **TXLifeResponse** | Outbound transaction response | TransRefGUID, TransResult |
| **OLifE** | Business-data container | Version |
| **Party** | Any person or organization | PartyKey, FullName, GovtID, Residence, Citizenship |
| **Person** | Natural person detail | FirstName, LastName, MiddleName, Prefix, Suffix, BirthDate, Gender, Age |
| **Organization** | Legal entity detail | OrgForm (tc), DBA, EstabDate |
| **Holding** | Container for a financial product | HoldingKey, HoldingTypeCode, CurrencyTypeCode |
| **Policy** | The annuity contract itself | PolNumber, PlanName, ProductType, PolicyStatus, IssueDate, EffDate, TermDate |
| **Annuity** | Annuity-specific product detail | QualPlanType, AnnuityProduct, InitPaymentAmt, MaturityDate |
| **SubAccount** | Investment sub-account | SubAcctKey, CUSIP, FundID, AllocPercent, SubAcctValue |
| **Rider** | Rider or endorsement on the annuity | RiderTypeCode, RiderStatus, BenefitAmt, RiderFee |
| **Payout** | Annuitization/income payout detail | PayoutType, PayoutMode, PayoutAmt, StartDate, EndDate |
| **Relation** | Links Party ↔ Holding or Party ↔ Party | RelationRoleCode, BeneficiaryDesignation, InterestPercent |
| **FinancialActivity** | Financial transaction on the contract | FinActivityType, FinActivityDate, FinActivityAmt, FinActivityGrossAmt |
| **ApplicationInfo** | Application/submission detail | AppType, SignedDate, ReplacementInd, HOAssignedAppNumber |
| **RequirementInfo** | Outstanding requirement for underwriting/NIGO | ReqCode, ReqStatus, RequestedDate, FulfilledDate |
| **FormInstance** | Paper/electronic form attached | FormName, ProviderFormNumber, Attachment |
| **Banking** | EFT/wire info | BankAcctType, RoutingNum, AcctNum, BankName |
| **Address** | Mailing/residential/business address | AddressTypeCode, Line1-Line4, City, State, Zip, Country |
| **Phone** | Telephone number | PhoneTypeCode, AreaCode, DialNumber |
| **EMailAddress** | Email | EMailType, AddrLine |
| **SourceInfo** | Sending system metadata | CreationDate, CreationTime, SourceInfoName |

### 1.2.3 Understanding the Relation Object

The `Relation` object is the glue that connects `Party` and `Holding` objects. It uses an origin/related pattern with a `RelationRoleCode` to express every role in the annuity ecosystem:

| RelationRoleCode (tc) | OLI Constant | Description |
|---|---|---|
| 8 | OLI_REL_OWNER | Contract owner |
| 32 | OLI_REL_ANNUITANT | Annuitant |
| 34 | OLI_REL_BENEFICIARY | Beneficiary |
| 37 | OLI_REL_AGENT | Writing/servicing agent |
| 39 | OLI_REL_CONTINGENT_BENE | Contingent beneficiary |
| 55 | OLI_REL_JOINTOWNER | Joint owner |
| 70 | OLI_REL_PAYOR | Premium payor |
| 90 | OLI_REL_POWEROF_ATTY | Power of attorney |
| 109 | OLI_REL_IRREV_BENE | Irrevocable beneficiary |
| 120 | OLI_REL_ASSIGNEE | Assignee |
| 6 | OLI_REL_INSURED | Covered life (joint-and-survivor) |
| 188 | OLI_REL_TRUSTEE | Trustee of trust-owned contract |

A single annuity contract commonly has 6-12 `Relation` records connecting multiple parties to the holding.

### 1.2.4 Annuity-Specific Sub-Objects

#### SubAccount

```xml
<SubAccount id="SubAcct_001">
  <ProductObjectReference>Fund_VANG500</ProductObjectReference>
  <AllocPercent>0.25</AllocPercent>
  <SubAcctValue>62500.00</SubAcctValue>
  <Units>1523.456</Units>
  <UnitValue>41.03</UnitValue>
  <ValuationDate>2025-03-31</ValuationDate>
  <SubAcctTypeCode tc="1">Variable</SubAcctTypeCode>
</SubAccount>
```

#### Rider

```xml
<Rider id="Rider_GMWB_001">
  <RiderTypeCode tc="99">GMWB</RiderTypeCode>
  <RiderStatus tc="1">Active</RiderStatus>
  <BenefitAmt>250000.00</BenefitAmt>
  <BenefitBaseAmt>275000.00</BenefitBaseAmt>
  <RiderFee>0.0095</RiderFee>
  <MaxAnnualWithdrawalPct>0.05</MaxAnnualWithdrawalPct>
  <EffDate>2023-01-15</EffDate>
  <RiderChargeBasis tc="1">BenefitBase</RiderChargeBasis>
</Rider>
```

#### Payout (Annuitization)

```xml
<Payout id="Payout_001">
  <PayoutType tc="6">LifeWithPeriodCertain</PayoutType>
  <PayoutMode tc="12">Monthly</PayoutMode>
  <PayoutAmt>2150.00</PayoutAmt>
  <StartDate>2026-01-01</StartDate>
  <CertainDuration>P10Y</CertainDuration>
  <PayoutForm tc="2">JointAndSurvivor</PayoutForm>
  <SurvivorPercent>0.50</SurvivorPercent>
</Payout>
```

## 1.3 ACORD TXLife Message Structure

### 1.3.1 Request / Response Pattern

Every ACORD Life transaction follows a **TXLifeRequest** / **TXLifeResponse** message-pair pattern:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<TXLife xmlns="http://ACORD.org/Standards/Life/2"
        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        Version="2.46.00">

  <UserAuthRequest>
    <UserLoginName>DISTRIBUTOR_ABC</UserLoginName>
    <UserPswd>
      <CryptType>NONE</CryptType>
      <Pswd>********</Pswd>
    </UserPswd>
  </UserAuthRequest>

  <TXLifeRequest PrimaryObjectID="Holding_001">
    <TransRefGUID>a1b2c3d4-e5f6-7890-abcd-ef1234567890</TransRefGUID>
    <TransType tc="103">New Application Submission</TransType>
    <TransSubType tc="10001">Annuity Application</TransSubType>
    <TransExeDate>2025-04-15</TransExeDate>
    <TransExeTime>14:30:00</TransExeTime>
    <TransMode tc="2">Original</TransMode>

    <OLifE>
      <SourceInfo>
        <CreationDate>2025-04-15</CreationDate>
        <CreationTime>14:30:00</CreationTime>
        <SourceInfoName>DistributorPlatform v3.2</SourceInfoName>
      </SourceInfo>

      <!-- Parties, Holdings, Relations defined here -->
    </OLifE>
  </TXLifeRequest>
</TXLife>
```

### 1.3.2 Key Transaction Types (TransType tc Values)

| tc Value | OLI Constant | Description | Use Case |
|---|---|---|---|
| 103 | OLI_TRANS_NBSUB | New Business Submission | Submit new annuity application |
| 104 | OLI_TRANS_NBCOMMIT | New Business Commit | Carrier commits to issuing |
| 105 | OLI_TRANS_ISSUECONFIRM | Issue Confirmation | Confirm policy issuance |
| 228 | OLI_TRANS_FUNDTRANSFER | Fund Transfer | Transfer between sub-accounts |
| 501 | OLI_TRANS_NBPENDING | New Business Pending | Application received, pending |
| 502 | OLI_TRANS_REQMISSING | Requirements Missing | NIGO status |
| 510 | OLI_TRANS_HOLDINGINQ | Holding Inquiry | Query contract details |
| 511 | OLI_TRANS_HOLDINGCHANGE | Holding Change | Service/change request |
| 512 | OLI_TRANS_VALUATION | Valuation | Report contract values |
| 513 | OLI_TRANS_FINIACTIVITY | Financial Activity | Report financial activity |
| 301 | OLI_TRANS_CLAIMOPEN | Claim Open | Death claim initiation |
| 302 | OLI_TRANS_CLAIMPAY | Claim Payment | Claim benefit payment |
| 152 | OLI_TRANS_1035EXCHANGE | 1035 Exchange | Tax-free exchange between annuities |
| 204 | OLI_TRANS_WITHDRAWAL | Withdrawal | Partial/full withdrawal |
| 260 | OLI_TRANS_ANNUITIZATION | Annuitization | Convert to income stream |

### 1.3.3 TransResult / ResultCode Values

| tc Value | Meaning |
|---|---|
| 1 | Success |
| 2 | Success with Info |
| 3 | Pending |
| 4 | Transaction Error |
| 5 | Data Validation Error |
| 6 | Authorization Error |

### 1.3.4 Complete New Business Submission Example

```xml
<?xml version="1.0" encoding="UTF-8"?>
<TXLife xmlns="http://ACORD.org/Standards/Life/2" Version="2.46.00">
  <TXLifeRequest PrimaryObjectID="Holding_001">
    <TransRefGUID>f47ac10b-58cc-4372-a567-0e02b2c3d479</TransRefGUID>
    <TransType tc="103"/>
    <TransSubType tc="10001"/>
    <TransExeDate>2025-04-15</TransExeDate>
    <TransMode tc="2"/>

    <OLifE>
      <SourceInfo>
        <CreationDate>2025-04-15</CreationDate>
        <SourceInfoName>AgentPortal</SourceInfoName>
      </SourceInfo>

      <!-- Owner -->
      <Party id="Party_Owner">
        <PersonOrOrganization>
          <Person>
            <FirstName>John</FirstName>
            <MiddleName>A</MiddleName>
            <LastName>Smith</LastName>
            <BirthDate>1965-06-15</BirthDate>
            <Gender tc="1">Male</Gender>
          </Person>
        </PersonOrOrganization>
        <GovtID>123-45-6789</GovtID>
        <GovtIDTC tc="1">SSN</GovtIDTC>
        <Address>
          <AddressTypeCode tc="1">Residence</AddressTypeCode>
          <Line1>123 Main Street</Line1>
          <City>Hartford</City>
          <AddressStateTC tc="7">CT</AddressStateTC>
          <Zip>06103</Zip>
        </Address>
        <Phone>
          <PhoneTypeCode tc="1">Home</PhoneTypeCode>
          <AreaCode>860</AreaCode>
          <DialNumber>5551234</DialNumber>
        </Phone>
        <EMailAddress>
          <EMailType tc="1">Personal</EMailType>
          <AddrLine>john.smith@email.com</AddrLine>
        </EMailAddress>
      </Party>

      <!-- Annuitant (same as owner) -->
      <!-- Beneficiary -->
      <Party id="Party_Bene1">
        <PersonOrOrganization>
          <Person>
            <FirstName>Jane</FirstName>
            <LastName>Smith</LastName>
            <BirthDate>1968-09-22</BirthDate>
            <Gender tc="2">Female</Gender>
          </Person>
        </PersonOrOrganization>
        <GovtID>987-65-4321</GovtID>
        <GovtIDTC tc="1">SSN</GovtIDTC>
      </Party>

      <!-- Writing Agent -->
      <Party id="Party_Agent">
        <PersonOrOrganization>
          <Person>
            <FirstName>Robert</FirstName>
            <LastName>Johnson</LastName>
          </Person>
        </PersonOrOrganization>
        <Producer>
          <CarrierAppointment>
            <CompanyProducerID>AGT-44521</CompanyProducerID>
            <CarrierCode>CARRIER_XYZ</CarrierCode>
          </CarrierAppointment>
        </Producer>
      </Party>

      <!-- The Annuity Holding -->
      <Holding id="Holding_001">
        <HoldingTypeCode tc="2">Policy</HoldingTypeCode>
        <Policy>
          <CarrierCode>CARRIER_XYZ</CarrierCode>
          <PlanName>FlexAccumulator VA Series III</PlanName>
          <ProductType tc="4">Annuity</ProductType>
          <ProductCode>VA-FLEX-III</ProductCode>
          <PaymentMode tc="12">Monthly</PaymentMode>
          <PaymentAmt>500.00</PaymentAmt>

          <ApplicationInfo>
            <AppType tc="1">New</AppType>
            <SignedDate>2025-04-14</SignedDate>
            <SubmissionDate>2025-04-15</SubmissionDate>
            <ReplacementInd tc="0">False</ReplacementInd>
            <HOAssignedAppNumber>APP-2025-0415-001</HOAssignedAppNumber>
          </ApplicationInfo>

          <Annuity>
            <QualPlanType tc="0">Non-Qualified</QualPlanType>
            <AnnuityProduct tc="2">Variable Annuity</AnnuityProduct>
            <InitPaymentAmt>100000.00</InitPaymentAmt>

            <SubAccount>
              <SubAcctKey>SA_001</SubAcctKey>
              <FundID>FUND_SP500</FundID>
              <AllocPercent>0.40</AllocPercent>
            </SubAccount>
            <SubAccount>
              <SubAcctKey>SA_002</SubAcctKey>
              <FundID>FUND_BOND</FundID>
              <AllocPercent>0.35</AllocPercent>
            </SubAccount>
            <SubAccount>
              <SubAcctKey>SA_003</SubAcctKey>
              <FundID>FUND_INTL</FundID>
              <AllocPercent>0.25</AllocPercent>
            </SubAccount>

            <Rider>
              <RiderTypeCode tc="99">GMWB</RiderTypeCode>
              <BenefitAmt>100000.00</BenefitAmt>
              <RiderFee>0.0095</RiderFee>
            </Rider>
          </Annuity>
        </Policy>
      </Holding>

      <!-- Relations -->
      <Relation OriginatingObjectID="Party_Owner"
                RelatedObjectID="Holding_001"
                id="Rel_001">
        <RelationRoleCode tc="8">Owner</RelationRoleCode>
      </Relation>

      <Relation OriginatingObjectID="Party_Owner"
                RelatedObjectID="Holding_001"
                id="Rel_002">
        <RelationRoleCode tc="32">Annuitant</RelationRoleCode>
      </Relation>

      <Relation OriginatingObjectID="Party_Bene1"
                RelatedObjectID="Holding_001"
                id="Rel_003">
        <RelationRoleCode tc="34">Beneficiary</RelationRoleCode>
        <BeneficiaryDesignation tc="1">Primary</BeneficiaryDesignation>
        <InterestPercent>1.00</InterestPercent>
      </Relation>

      <Relation OriginatingObjectID="Party_Agent"
                RelatedObjectID="Holding_001"
                id="Rel_004">
        <RelationRoleCode tc="37">Agent</RelationRoleCode>
      </Relation>

    </OLifE>
  </TXLifeRequest>
</TXLife>
```

## 1.4 ACORD Forms for Annuities

ACORD publishes standardized paper and electronic forms used by carriers and distributors. The following are the most relevant for annuity transactions:

### 1.4.1 Application Forms

| Form Number | Form Name | Usage |
|---|---|---|
| ACORD 101 | Individual Application for Life Insurance / Annuity | Primary individual annuity application |
| ACORD 101VA | Variable Annuity Application Supplement | Supplement for variable annuity specifics |
| ACORD 101FA | Fixed Annuity Application Supplement | Supplement for fixed annuity specifics |
| ACORD 101IA | Indexed Annuity Application Supplement | Supplement for fixed-indexed annuity specifics |
| ACORD 140 | Group Annuity Certificate Application | Group annuity enrollment |
| ACORD 103 | Individual Application for Qualified Plans (IRA, 403(b)) | Qualified annuity applications |
| ACORD 160 | Application for Non-Qualified Deferred Annuity | NQ deferred annuity application |
| ACORD 161 | Application for Qualified Deferred Annuity | Qualified deferred annuity application |

### 1.4.2 Replacement and Exchange Forms

| Form Number | Form Name | Usage |
|---|---|---|
| ACORD 301 | Replacement Questionnaire | State-required replacement disclosure |
| ACORD 302 | Important Notice: Replacement of Life Insurance or Annuities | Consumer replacement notice |
| ACORD 303 | Comparison Form for Replacement | Side-by-side comparison of existing vs. proposed |
| ACORD 601 | Request for Internal Replacement / Exchange (1035) | Internal 1035 exchange request |
| ACORD 602 | Request for External 1035 Exchange | External 1035 exchange to another carrier |

### 1.4.3 Transfer and Service Forms

| Form Number | Form Name | Usage |
|---|---|---|
| ACORD 400 | Transfer of Assets (Absolute Assignment) | Ownership transfer |
| ACORD 401 | Annuity Transfer Request | Transfer between carriers / plans |
| ACORD 402 | Direct Transfer Request (Qualified to Qualified) | Trustee-to-trustee transfer for qualified plans |
| ACORD 501 | Change Request | Beneficiary change, address change, allocation change |
| ACORD 502 | Systematic Withdrawal Request | Set up systematic withdrawal plan |
| ACORD 503 | Annuity Surrender / Withdrawal Request | Full or partial surrender |
| ACORD 504 | Annuity Loan Request | Policy loan (for contracts with loan provisions) |
| ACORD 505 | Annuitization Election | Election to begin income payments |

### 1.4.4 Death Claim Forms

| Form Number | Form Name | Usage |
|---|---|---|
| ACORD 810 | Claimant's Statement (Annuity / Life) | Death claim initiation |
| ACORD 811 | Beneficiary Election of Settlement Options | Death benefit payout election |

## 1.5 ACORD Code Lists (OLI_ Type Codes)

ACORD code lists are enumerated value sets prefixed with `OLI_`. These are used throughout TXLife messages.

### 1.5.1 Product Type Codes (OLI_PRODTYPE)

| tc Value | Constant | Description |
|---|---|---|
| 4 | OLI_PRODTYPE_ANN | Annuity (general) |
| 421 | OLI_ANNPROD_FIX | Fixed Annuity |
| 422 | OLI_ANNPROD_VAR | Variable Annuity |
| 423 | OLI_ANNPROD_FIXED_IDX | Fixed Indexed Annuity |
| 424 | OLI_ANNPROD_RILA | Registered Index-Linked Annuity |
| 425 | OLI_ANNPROD_SPIA | Single Premium Immediate Annuity |
| 426 | OLI_ANNPROD_DIA | Deferred Income Annuity |
| 427 | OLI_ANNPROD_QLAC | Qualified Longevity Annuity Contract |
| 428 | OLI_ANNPROD_MYGA | Multi-Year Guaranteed Annuity |

### 1.5.2 Qualified Plan Type Codes (OLI_QUALPLAN)

| tc Value | Constant | Description |
|---|---|---|
| 0 | OLI_QUALPLAN_NONE | Non-Qualified |
| 1 | OLI_QUALPLAN_IRA | Traditional IRA |
| 2 | OLI_QUALPLAN_ROTHIRA | Roth IRA |
| 3 | OLI_QUALPLAN_SEP | SEP IRA |
| 4 | OLI_QUALPLAN_SIMPLE | SIMPLE IRA |
| 6 | OLI_QUALPLAN_401K | 401(k) |
| 7 | OLI_QUALPLAN_403B | 403(b) TSA |
| 8 | OLI_QUALPLAN_457B | 457(b) Governmental |
| 10 | OLI_QUALPLAN_PENSION | Defined Benefit Pension |
| 12 | OLI_QUALPLAN_ROTH401K | Roth 401(k) |
| 18 | OLI_QUALPLAN_INHERITED_IRA | Inherited IRA |

### 1.5.3 Policy Status Codes (OLI_POLSTAT)

| tc Value | Constant | Description |
|---|---|---|
| 1 | OLI_POLSTAT_ACTIVE | Active / In Force |
| 2 | OLI_POLSTAT_INACTIVE | Inactive |
| 3 | OLI_POLSTAT_SURRENDERED | Fully Surrendered |
| 5 | OLI_POLSTAT_PAIDUP | Paid-Up |
| 6 | OLI_POLSTAT_LAPSED | Lapsed |
| 8 | OLI_POLSTAT_DEATHCLAIM | Death Claim in Progress |
| 11 | OLI_POLSTAT_ANNUITIZED | Annuitized / In Payout |
| 14 | OLI_POLSTAT_PENDING | Pending Issue |
| 18 | OLI_POLSTAT_PROPOSED | Proposed / Application |
| 22 | OLI_POLSTAT_MATURED | Matured |
| 25 | OLI_POLSTAT_DECLINEDISSUE | Declined |
| 30 | OLI_POLSTAT_TRANSFERRED | Transferred Out |

### 1.5.4 Financial Activity Type Codes (OLI_FINACTTYPE)

| tc Value | Constant | Description |
|---|---|---|
| 1 | OLI_FINACT_PREMIUM | Premium payment received |
| 6 | OLI_FINACT_PARTIALWD | Partial withdrawal |
| 7 | OLI_FINACT_FULLSURRENDER | Full surrender |
| 8 | OLI_FINACT_DEATHBENEFIT | Death benefit payment |
| 10 | OLI_FINACT_TRANSFER | Sub-account transfer |
| 12 | OLI_FINACT_FEE | Fee/charge assessed |
| 14 | OLI_FINACT_INTEREST | Interest credited |
| 17 | OLI_FINACT_LOAN | Loan advance |
| 18 | OLI_FINACT_LOANREPAY | Loan repayment |
| 22 | OLI_FINACT_DIVIDEND | Dividend distribution |
| 26 | OLI_FINACT_ANNUITYPAYMT | Annuity income payment |
| 30 | OLI_FINACT_RMD | Required Minimum Distribution |
| 35 | OLI_FINACT_1035EXCH | 1035 Exchange proceeds |
| 40 | OLI_FINACT_FREEWD | Free withdrawal (no surrender charge) |
| 45 | OLI_FINACT_MVA_ADJ | Market Value Adjustment |

### 1.5.5 Rider Type Codes (Annuity-Relevant)

| tc Value | Constant | Description |
|---|---|---|
| 91 | OLI_RIDER_GMDB | Guaranteed Minimum Death Benefit |
| 92 | OLI_RIDER_GMAB | Guaranteed Minimum Accumulation Benefit |
| 93 | OLI_RIDER_GMIB | Guaranteed Minimum Income Benefit |
| 99 | OLI_RIDER_GMWB | Guaranteed Minimum Withdrawal Benefit |
| 100 | OLI_RIDER_GLWB | Guaranteed Lifetime Withdrawal Benefit |
| 101 | OLI_RIDER_NURSING_HOME | Nursing Home Waiver |
| 102 | OLI_RIDER_TERMINAL_ILL | Terminal Illness Waiver |
| 103 | OLI_RIDER_ENHANCED_DB | Enhanced Death Benefit |
| 104 | OLI_RIDER_RETURN_PREM | Return of Premium Rider |
| 105 | OLI_RIDER_HIGHEST_ANNIV | Highest Anniversary Value Death Benefit |
| 106 | OLI_RIDER_ANNUAL_STEPUP | Annual Step-Up/Ratchet |
| 107 | OLI_RIDER_EARNINGS_ENHANCE | Earnings Enhancement Rider |

## 1.6 ACORD XML Schema Considerations for Architects

### 1.6.1 Schema Versioning

- ACORD releases schemas in numbered versions (e.g., 2.43.00, 2.46.00).
- Schemas are **additive** — new elements are added without removing old ones.
- Carriers and distributors negotiate a **mutually supported version** for each integration.
- Schema extensions using `OLifEExtension` elements allow carrier-specific fields.

### 1.6.2 Extension Pattern

```xml
<Annuity>
  <QualPlanType tc="0"/>
  <InitPaymentAmt>100000.00</InitPaymentAmt>
  <!-- Carrier-specific extension -->
  <OLifEExtension VendorCode="CARRIER_XYZ">
    <AnnuityExtension>
      <BonusCreditPct>0.05</BonusCreditPct>
      <SurrenderScheduleCode>SCH-7YR-A</SurrenderScheduleCode>
      <IndexStrategy>
        <IndexName>S&amp;P 500 Annual Point-to-Point</IndexName>
        <CapRate>0.12</CapRate>
        <ParticipationRate>1.00</ParticipationRate>
        <SpreadRate>0.00</SpreadRate>
        <FloorRate>0.00</FloorRate>
        <BufferRate>0.00</BufferRate>
      </IndexStrategy>
    </AnnuityExtension>
  </OLifEExtension>
</Annuity>
```

### 1.6.3 ACORD Namespace and Schema Location

```xml
<TXLife xmlns="http://ACORD.org/Standards/Life/2"
        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:schemaLocation="http://ACORD.org/Standards/Life/2 TXLife2.46.00.xsd">
```

---

# 2. DTCC / NSCC Standards

## 2.1 Overview

DTCC (Depository Trust & Clearing Corporation) and its subsidiary NSCC (National Securities Clearing Corporation) operate the **Insurance & Retirement Services (I&RS)** platform, which is the industry utility for automated processing of insurance and annuity transactions between carriers, distributors, and clearing firms.

The I&RS platform handles:

- **New business submission** (applications)
- **Money movement** (premiums, commissions, surrenders, withdrawals)
- **Position and contract value reporting**
- **Commission processing and payment**
- **Networking** (establishing/maintaining dealer-carrier relationships)
- **Financial activity reporting**

## 2.2 DTCC I&RS Service Categories

### 2.2.1 Core Services

| Service | DTCC Name | Function |
|---|---|---|
| **Networking** | Insurance Profile | Establish/maintain relationships between distributors and carriers |
| **App Entry** | DTCC Application Entry | Submit new annuity applications electronically |
| **Positions** | Position & Valuation | Report contract values and positions |
| **Financial Activity** | Financial Activity Reporting | Report premium, withdrawal, and other financial activity |
| **Commissions** | Commission Processing | Calculate and settle commissions |
| **Money Settlement** | Fund/SERV | Settle money between carriers and distributors via NSCC |
| **ACATS-IPS** | ACATS Insurance Processing Service | Transfer annuity contracts between broker-dealers |

### 2.2.2 Transaction Flows

```
┌──────────────┐    App Entry     ┌──────────────┐
│  Distributor  │ ───────────────> │    DTCC      │
│  (BD/RIA)     │ <─── Status ─── │   I&RS       │
└──────────────┘                  │   Platform   │
                                  │              │
┌──────────────┐    Positions     │              │
│   Carrier     │ ───────────────> │              │
│  (Insurer)    │                  │              │
│               │ <── Commission ─ │              │
│               │ ─── Premium ──> │              │
└──────────────┘    via Fund/SERV └──────────────┘
```

## 2.3 NSCC Transaction Types and Record Layouts

### 2.3.1 Application Entry (App Entry)

DTCC App Entry transmits new business applications and status updates. Key record types:

| Record Type | Code | Direction | Description |
|---|---|---|---|
| Application Submission | AS | Distributor → DTCC → Carrier | New application data |
| Application Status | AT | Carrier → DTCC → Distributor | Status updates (Received, In Review, Approved, Declined) |
| NIGO Notification | NG | Carrier → DTCC → Distributor | Not In Good Order — missing/incorrect info |
| Application Confirmation | AC | Carrier → DTCC → Distributor | Application accepted, policy number assigned |
| Application Rejection | AR | Carrier → DTCC → Distributor | Application rejected with reason codes |

#### App Entry Key Fields

| Field Name | Length | Type | Description |
|---|---|---|---|
| RecordType | 2 | Alpha | AS, AT, NG, AC, AR |
| TransactionID | 20 | Alphanum | Unique transaction identifier |
| DistributorFirmID | 4 | Num | NSCC participant number |
| CarrierCode | 5 | Alphanum | NSCC carrier identifier |
| OwnerSSN | 9 | Num | Owner Social Security Number |
| OwnerFirstName | 30 | Alpha | Owner first name |
| OwnerLastName | 40 | Alpha | Owner last name |
| OwnerDOB | 8 | Date | YYYYMMDD format |
| AnnuitantSSN | 9 | Num | Annuitant SSN (if different from owner) |
| ProductCode | 10 | Alphanum | Carrier product code |
| QualPlanType | 2 | Num | Qualified plan type code |
| InitialPremium | 14 | Num | Initial premium amount (2 implied decimals) |
| PaymentMethod | 1 | Alpha | C=Check, W=Wire, A=ACH, X=1035 |
| ReplacementIndicator | 1 | Alpha | Y/N |
| ApplicationDate | 8 | Date | YYYYMMDD |
| AgentID | 10 | Alphanum | Writing agent identifier |
| SplitPercent | 5 | Num | Agent commission split (3 implied decimals) |
| SubAccountAlloc01_FundID | 10 | Alphanum | Sub-account 1 fund code |
| SubAccountAlloc01_Pct | 5 | Num | Sub-account 1 allocation % (2 implied decimals) |
| ... (up to 30 sub-accounts) | | | |

### 2.3.2 Commission Processing

| Record Type | Code | Direction | Description |
|---|---|---|---|
| Commission Statement | CS | Carrier → DTCC → Distributor | Commission earned details |
| Commission Payment | CP | Carrier → DTCC → Distributor | Money settlement record |
| Commission Adjustment | CA | Carrier → DTCC → Distributor | Chargeback or correction |
| Trail Commission | TC | Carrier → DTCC → Distributor | Ongoing trail/asset-based commission |

#### Commission Record Key Fields

| Field Name | Length | Type | Description |
|---|---|---|---|
| RecordType | 2 | Alpha | CS, CP, CA, TC |
| PolicyNumber | 20 | Alphanum | Contract/policy number |
| CarrierCode | 5 | Alphanum | NSCC carrier code |
| DistributorFirmID | 4 | Num | NSCC firm number |
| AgentID | 10 | Alphanum | Agent/rep ID |
| CommissionType | 2 | Num | 01=First Year, 02=Renewal, 03=Trail, 04=Bonus |
| GrossCommission | 12 | Num | Gross commission (2 implied decimals) |
| OverrideAmount | 12 | Num | Override/bonus amount |
| NetCommission | 12 | Num | Net commission after adjustments |
| CommissionDate | 8 | Date | Date commission earned |
| PremiumAmount | 14 | Num | Premium on which commission is based |
| AccountValue | 14 | Num | Contract value at time of commission |
| CommissionRate | 7 | Num | Commission rate (4 implied decimals) |
| ChargebackIndicator | 1 | Alpha | Y=Chargeback, N=Normal |
| OriginalTransDate | 8 | Date | Original transaction date (for chargebacks) |

### 2.3.3 Position and Contract Value Reporting

| Record Type | Code | Direction | Description |
|---|---|---|---|
| Position Report | PR | Carrier → DTCC → Distributor | Contract value/position data |
| Financial Activity | FA | Carrier → DTCC → Distributor | Transaction-level financial activity |

#### Position Report Key Fields

| Field Name | Length | Type | Description |
|---|---|---|---|
| RecordType | 2 | Alpha | PR |
| PolicyNumber | 20 | Alphanum | Contract number |
| CarrierCode | 5 | Alphanum | Carrier identifier |
| OwnerSSN | 9 | Num | Contract owner SSN |
| ValuationDate | 8 | Date | As-of date for values |
| TotalAccountValue | 14 | Num | Total contract value |
| TotalSurrenderValue | 14 | Num | Net surrender value |
| TotalDeathBenefitValue | 14 | Num | Death benefit value |
| TotalLoanBalance | 14 | Num | Outstanding loan balance |
| GrossPremiumsYTD | 14 | Num | Year-to-date gross premiums |
| WithdrawalsYTD | 14 | Num | Year-to-date withdrawals |
| CostBasis | 14 | Num | Tax cost basis |
| GainLoss | 14 | Num | Unrealized gain/loss |
| PolicyStatus | 2 | Num | Status code |
| QualifiedPlanType | 2 | Num | Qualified plan code |
| SubAcct01_FundID | 10 | Alphanum | Fund identifier |
| SubAcct01_Units | 14 | Num | Number of units |
| SubAcct01_UnitValue | 10 | Num | Unit/NAV value |
| SubAcct01_AcctValue | 14 | Num | Sub-account market value |
| ... (up to 60 sub-accounts) | | | |

### 2.3.4 Financial Activity Reporting

#### Financial Activity Key Fields

| Field Name | Length | Type | Description |
|---|---|---|---|
| RecordType | 2 | Alpha | FA |
| PolicyNumber | 20 | Alphanum | Contract number |
| TransactionType | 3 | Alphanum | Transaction type code |
| TransactionDate | 8 | Date | Effective date |
| ProcessDate | 8 | Date | Processing date |
| GrossAmount | 14 | Num | Gross transaction amount |
| NetAmount | 14 | Num | Net amount |
| FederalWithholding | 12 | Num | Federal tax withheld |
| StateWithholding | 12 | Num | State tax withheld |
| SurrenderCharge | 12 | Num | Surrender charge applied |
| MVAAdjustment | 12 | Num | Market value adjustment |
| FundID | 10 | Alphanum | Fund involved (if applicable) |
| Units | 14 | Num | Units transacted |
| Description | 50 | Alpha | Transaction description |

#### NSCC Financial Activity Transaction Type Codes

| Code | Description |
|---|---|
| PRM | Premium received |
| PWD | Partial withdrawal |
| FSR | Full surrender |
| DBP | Death benefit payment |
| TRF | Sub-account transfer |
| FEE | Fee assessed |
| INT | Interest credited |
| DIV | Dividend |
| LNA | Loan advance |
| LNR | Loan repayment |
| RMD | Required minimum distribution |
| ANN | Annuity income payment |
| BON | Bonus credit |
| MVA | Market value adjustment |
| 103 | 1035 exchange (incoming) |
| 10X | 1035 exchange (outgoing) |
| CRG | Rider charge |
| MEC | M&E charge |
| ADM | Administrative charge |

## 2.4 ACATS Insurance Processing Service (ACATS-IPS)

ACATS-IPS facilitates the transfer of annuity contracts between broker-dealers when a financial advisor changes firms. Key transaction types:

| Transaction | Description |
|---|---|
| Transfer Initiation (TI) | Receiving firm initiates transfer request |
| Transfer Validation (TV) | DTCC validates the request against carrier records |
| Transfer Acceptance (TA) | Delivering firm accepts/rejects transfer |
| Transfer Completion (TC) | Carrier re-registers contract to new firm |
| Transfer Rejection (TR) | Transfer rejected with reason codes |

## 2.5 DTCC Integration Architecture

```
┌─────────────────────────────────────────────────────┐
│                DTCC Integration Layer                │
│                                                     │
│  ┌──────────┐  ┌──────────┐  ┌──────────────────┐  │
│  │ FTP/SFTP │  │ MQ Series│  │ DTCC Web Portal  │  │
│  │ Batch    │  │ Real-Time│  │ (Manual Entry)   │  │
│  └────┬─────┘  └────┬─────┘  └────────┬─────────┘  │
│       │              │                 │             │
│       └──────────────┼─────────────────┘             │
│                      │                               │
│              ┌───────▼──────┐                        │
│              │  DTCC I&RS   │                        │
│              │  Gateway     │                        │
│              └───────┬──────┘                        │
│                      │                               │
│          ┌───────────┼───────────┐                   │
│          │           │           │                   │
│    ┌─────▼───┐ ┌─────▼───┐ ┌────▼────┐             │
│    │App Entry│ │Positions│ │Fund/SERV│             │
│    │Service  │ │Service  │ │(Money)  │             │
│    └─────────┘ └─────────┘ └─────────┘             │
└─────────────────────────────────────────────────────┘
```

### 2.5.1 Connectivity Options

| Method | Protocol | Use Case | Latency |
|---|---|---|---|
| SFTP Batch | SFTP | Nightly position/commission files | T+1 |
| MQ Series | IBM MQ | Real-time app status, financial activity | Near real-time |
| Web Services | SOAP/REST | On-demand inquiries | Synchronous |
| DTCC Portal | HTTPS | Manual operations, reconciliation | Interactive |

---

# 3. NAIC Data Standards

## 3.1 Overview

The National Association of Insurance Commissioners (NAIC) sets statutory reporting standards for insurance companies in the United States. Annuity carriers must comply with NAIC data standards for:

- **Annual and quarterly statutory financial statements** (Blue Book for life companies)
- **Risk-Based Capital (RBC) reporting**
- **Product filing** (via SERFF)
- **Market conduct examination data**
- **Experience reporting**
- **Valuation reporting**

## 3.2 Statutory Financial Statements (Blue Book)

Life insurance companies (which issue annuities) file the **Life, Accident & Health Annual Statement** (the "Blue Book"). Key schedules relevant to annuities:

### 3.2.1 Relevant Schedules and Exhibits

| Schedule/Exhibit | Content | Annuity Relevance |
|---|---|---|
| **Exhibit 5** | Aggregate Reserve for Life, Annuity, and Accident & Health Contracts | Total annuity reserves |
| **Exhibit 6** | Aggregate Reserve for Deposit-Type Contracts | Reserves for deposit-type annuity contracts |
| **Exhibit 7** | Deposit-Type Contracts | Deposits, withdrawals, investment income, fees, net change |
| **Schedule D** | Showing All Bonds and Stocks Owned | General account investments backing fixed annuities |
| **Schedule DB** | Showing All Derivative Instruments | Hedging instruments for variable/indexed annuities |
| **Schedule S** | Showing Reinsurance | Reinsurance of annuity risks |
| **General Interrogatories** | Various disclosures | Annuity-related disclosures |
| **Notes to Financial Statements** | Detailed disclosures | Separate account details, guaranteed benefits |
| **Separate Account Statement** | Separate account financials | Variable annuity separate account assets/liabilities |

### 3.2.2 Filing Format

NAIC statutory filings use a proprietary electronic format:

| Format Element | Specification |
|---|---|
| **Filing Format** | XBRL (eXtensible Business Reporting Language) via NAIC Financial Data Repository |
| **Taxonomy** | NAIC Annual Statement XBRL Taxonomy |
| **Transport** | NAIC SERFF or I-SITE+ portal |
| **Period** | Annual (due March 1) and Quarterly (due May 15, Aug 15, Nov 15) |
| **Validation** | NAIC Automated Validation Engine (AVE) |

### 3.2.3 Key Data Elements in Exhibit 7 (Deposit-Type Contracts)

| Line Item | Description |
|---|---|
| 1. Balance at beginning of year | Opening reserve for deposit-type contracts |
| 2. Deposits received during year | New annuity premiums/deposits |
| 3. Investment earnings credited | Interest, dividends credited to contracts |
| 4. Fee income | M&E charges, rider charges, admin fees |
| 5. Surrenders and withdrawals | Gross surrenders and partial withdrawals |
| 6. Benefit payments | Death benefits, annuitization payments |
| 7. Net transfers to/from separate accounts | Movement between general and separate accounts |
| 8. Other net changes | Market value adjustments, bonus credits, etc. |
| 9. Balance at end of year | Closing reserve |

## 3.3 Risk-Based Capital (RBC) Reporting

Annuity carriers must file RBC reports that measure capital adequacy. Key components affecting annuity writers:

### 3.3.1 RBC Components for Annuity Writers

| Component | Symbol | Description |
|---|---|---|
| Asset Risk - Affiliates | C-0 | Risk from affiliated investments |
| Asset Risk - Other | C-1 | Credit/default risk on invested assets backing annuities |
| Insurance Risk | C-2 | Mortality/morbidity risk from guaranteed benefits |
| Interest Rate Risk | C-3 | Interest rate / market risk (critical for annuities) |
| Business Risk | C-4 | Operational and business risk |

### 3.3.2 C-3 Phase I and Phase II

| Filing | Scope | Method |
|---|---|---|
| **C-3 Phase I** | Interest rate risk for fixed annuities and GICs | Cash flow testing under prescribed scenarios |
| **C-3 Phase II** | Market risk for variable annuity guaranteed benefits (GMDB, GMIB, GMWB, GLWB, GMAB) | Stochastic modeling (CTE calculation) |

C-3 Phase II data requirements for variable annuity carriers:

| Data Element | Description |
|---|---|
| Model point data | Seriatim or grouped contract data |
| Fund mapping | Mapping of sub-accounts to indices |
| Scenario sets | NAIC prescribed or company-generated economic scenarios |
| Hedge portfolio | Current hedge positions and strategy description |
| CTE(70) / CTE(90) | Conditional Tail Expectation at 70th and 90th percentile |

## 3.4 SERFF (System for Electronic Rate and Form Filing)

### 3.4.1 Product Filing Requirements

| Filing Element | Description |
|---|---|
| **TOI (Type of Insurance)** | Life > Annuity > [Fixed / Variable / Indexed] |
| **Filing Type** | New Product, Rate Change, Form Revision |
| **State** | Individual state or multi-state filing |
| **Forms** | Policy contract form, application form, rider forms, disclosure forms |
| **Rates** | Interest rates, M&E charges, rider charges, surrender schedules |
| **Actuarial Memorandum** | Actuarial justification for rates and reserves |
| **Filing Status** | Submitted, Under Review, Approved, Disapproved, Withdrawn |

### 3.4.2 SERFF Data Format

SERFF uses a web-based portal with structured data entry and document uploads. Key data fields:

| Field | Description |
|---|---|
| SERFF Tracking Number | Unique filing identifier (e.g., LIFE-123456789) |
| TOI Code | Type of insurance code (e.g., L04A for individual deferred annuity) |
| Sub-TOI Code | Sub-type (e.g., L04A.001 for fixed deferred annuity) |
| Company NAIC Code | 5-digit NAIC company code |
| Filing State | 2-letter state code |
| Product Name | Marketing name of the annuity product |
| Effective Date | Requested effective date |
| Filing Documents | PDF/Word documents uploaded |

## 3.5 Experience Reporting

NAIC collects experience data from annuity carriers for industry studies:

| Report | Frequency | Content |
|---|---|---|
| Individual Annuity Mortality | Annual | Mortality experience by age, gender, annuity type |
| Individual Annuity Lapse Study | Annual | Lapse/surrender rates by duration, product type, surrender charge |
| Variable Annuity Guaranteed Benefits | Annual | Utilization and cost of GMDB, GMWB, GMIB riders |
| Payout Annuity Mortality | Annual | Mortality for annuitants in payout phase |

---

# 4. Canonical Data Model for Annuities

## 4.1 Design Philosophy

A canonical data model (CDM) for annuities serves as the **lingua franca** across all internal systems and external interfaces. It abstracts away the idiosyncrasies of ACORD XML, NSCC flat files, legacy administration systems, and modern APIs into a single, well-defined structure.

### 4.1.1 Design Principles

1. **Product-agnostic core, product-specific extensions** — The core model handles all annuity types; product-specific attributes (e.g., index strategies for FIA, sub-accounts for VA) are modeled as extensions.
2. **Temporal awareness** — Every business entity has effective dating to support retroactive corrections, as-of queries, and audit trails.
3. **Party-role separation** — A Party is modeled independently of its role; roles are associations between Party and Contract.
4. **Financial precision** — All monetary amounts use `DECIMAL(18,2)`; rates and percentages use `DECIMAL(12,8)`.
5. **ACORD alignment** — Field names and codes align with ACORD OLifE where practical, easing integration.

## 4.2 Entity Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                    CANONICAL DATA MODEL                         │
│                                                                 │
│  ┌──────────┐    ┌──────────────┐    ┌───────────────────┐     │
│  │  Party    │───>│  ContractRole │───>│  Contract/Policy  │     │
│  └──────────┘    └──────────────┘    └─────────┬─────────┘     │
│       │                                         │               │
│  ┌────▼─────┐                          ┌────────▼────────┐     │
│  │ Address   │                          │  ProductConfig   │     │
│  │ Phone     │                          │  (Product Rules) │     │
│  │ Email     │                          └────────┬────────┘     │
│  │ BankAcct  │                                   │               │
│  └──────────┘                          ┌─────────┼──────────┐   │
│                                        │         │          │   │
│                               ┌────────▼──┐ ┌───▼────┐ ┌───▼──┐│
│                               │SubAccount │ │ Rider  │ │Payout││
│                               │Allocation │ │Benefit │ │Option││
│                               └───────────┘ └────────┘ └──────┘│
│                                                                 │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────────┐     │
│  │ Financial     │  │ Financial    │  │  Tax/Regulatory   │     │
│  │ Transaction   │  │ Position     │  │  Reporting        │     │
│  └──────────────┘  └──────────────┘  └──────────────────┘     │
└─────────────────────────────────────────────────────────────────┘
```

## 4.3 Contract / Policy Entity

### 4.3.1 Core Contract Attributes

| Attribute | Data Type | Length | Nullable | Description |
|---|---|---|---|---|
| contract_id | UUID | 36 | No | System-generated unique identifier |
| contract_number | VARCHAR | 20 | No | Policy/contract number (carrier-assigned) |
| carrier_code | VARCHAR | 10 | No | Issuing carrier identifier |
| product_code | VARCHAR | 20 | No | FK to product master |
| product_type | VARCHAR | 4 | No | FA, VA, FIA, RILA, SPIA, DIA, QLAC, MYGA |
| qualified_plan_type | VARCHAR | 10 | No | NQ, TIRA, RIRA, SEP, SIMPLE, 401K, 403B, 457B |
| contract_status | VARCHAR | 20 | No | PROPOSED, PENDING, ACTIVE, SURRENDERED, ANNUITIZED, DEATH_CLAIM, MATURED, LAPSED, TRANSFERRED |
| application_date | DATE | | Yes | Date application was signed |
| submission_date | DATE | | Yes | Date application was submitted |
| issue_date | DATE | | Yes | Date contract was issued |
| effective_date | DATE | | No | Contract effective date |
| maturity_date | DATE | | Yes | Contract maturity date |
| termination_date | DATE | | Yes | Date contract terminated |
| termination_reason | VARCHAR | 30 | Yes | SURRENDER, DEATH, MATURITY, LAPSE, TRANSFER |
| initial_premium | DECIMAL(18,2) | | No | Initial premium/deposit amount |
| total_premiums | DECIMAL(18,2) | | Yes | Cumulative premiums paid |
| payment_mode | VARCHAR | 10 | Yes | SINGLE, MONTHLY, QUARTERLY, ANNUAL, FLEXIBLE |
| planned_periodic_premium | DECIMAL(18,2) | | Yes | Planned periodic premium amount |
| free_look_end_date | DATE | | Yes | End of free-look period |
| replacement_indicator | BOOLEAN | | No | Is this a replacement of existing coverage? |
| exchange_1035_indicator | BOOLEAN | | No | Is this a 1035 exchange? |
| mec_indicator | BOOLEAN | | No | Modified Endowment Contract flag |
| state_of_issue | CHAR | 2 | No | State where contract was issued |
| currency_code | CHAR | 3 | No | ISO 4217 currency (default USD) |
| created_timestamp | TIMESTAMP | | No | Record creation timestamp |
| updated_timestamp | TIMESTAMP | | No | Last modification timestamp |
| version | INTEGER | | No | Optimistic concurrency version |

### 4.3.2 Contract Financial Summary

| Attribute | Data Type | Nullable | Description |
|---|---|---|---|
| contract_id | UUID | No | FK to Contract |
| valuation_date | DATE | No | As-of date for these values |
| account_value | DECIMAL(18,2) | No | Total account/accumulation value |
| surrender_value | DECIMAL(18,2) | No | Net surrender value after charges |
| death_benefit_value | DECIMAL(18,2) | No | Current death benefit |
| loan_balance | DECIMAL(18,2) | Yes | Outstanding loan balance |
| loan_interest_accrued | DECIMAL(18,2) | Yes | Accrued loan interest |
| cost_basis | DECIMAL(18,2) | No | Investment in the contract (tax basis) |
| gain_loss | DECIMAL(18,2) | No | Unrealized gain/loss |
| surrender_charge_amount | DECIMAL(18,2) | Yes | Current applicable surrender charge |
| surrender_charge_pct | DECIMAL(8,5) | Yes | Current surrender charge percentage |
| free_withdrawal_amount | DECIMAL(18,2) | Yes | Available penalty-free withdrawal |
| gmwb_benefit_base | DECIMAL(18,2) | Yes | GMWB benefit base |
| gmwb_remaining_benefit | DECIMAL(18,2) | Yes | Remaining GMWB lifetime benefit |
| gmib_benefit_base | DECIMAL(18,2) | Yes | GMIB benefit base |
| gmab_guarantee_value | DECIMAL(18,2) | Yes | GMAB guaranteed minimum value |
| ytd_premiums | DECIMAL(18,2) | No | Year-to-date premiums |
| ytd_withdrawals | DECIMAL(18,2) | No | Year-to-date withdrawals |
| ytd_rmd_amount | DECIMAL(18,2) | Yes | Year-to-date RMD taken |
| rmd_required_amount | DECIMAL(18,2) | Yes | Required RMD for the year |

## 4.4 Party Entity

### 4.4.1 Core Party Attributes

| Attribute | Data Type | Length | Nullable | Description |
|---|---|---|---|---|
| party_id | UUID | 36 | No | System-generated unique ID |
| party_type | VARCHAR | 12 | No | INDIVIDUAL, ORGANIZATION, TRUST |
| prefix | VARCHAR | 10 | Yes | Mr., Mrs., Dr., etc. |
| first_name | VARCHAR | 50 | Yes | First name (individuals) |
| middle_name | VARCHAR | 50 | Yes | Middle name |
| last_name | VARCHAR | 80 | Yes | Last name (individuals) |
| suffix | VARCHAR | 10 | Yes | Jr., Sr., III, etc. |
| organization_name | VARCHAR | 150 | Yes | Entity name (organizations) |
| org_type | VARCHAR | 20 | Yes | CORPORATION, LLC, PARTNERSHIP, TRUST, ESTATE |
| tax_id_type | VARCHAR | 5 | No | SSN, EIN, ITIN |
| tax_id | VARCHAR | 11 | No | Tax identification number (encrypted) |
| date_of_birth | DATE | | Yes | Date of birth (individuals) |
| date_of_death | DATE | | Yes | Date of death |
| gender | CHAR | 1 | Yes | M, F, U |
| citizenship | CHAR | 2 | Yes | ISO 3166 country code |
| residence_state | CHAR | 2 | Yes | US state code |
| residence_country | CHAR | 2 | Yes | ISO 3166 country code |
| marital_status | VARCHAR | 15 | Yes | SINGLE, MARRIED, DIVORCED, WIDOWED |
| email_primary | VARCHAR | 100 | Yes | Primary email address |
| phone_primary | VARCHAR | 15 | Yes | Primary phone number |
| created_timestamp | TIMESTAMP | | No | Record creation timestamp |
| updated_timestamp | TIMESTAMP | | No | Last modification timestamp |

### 4.4.2 Contract Role (Association Entity)

| Attribute | Data Type | Length | Nullable | Description |
|---|---|---|---|---|
| contract_role_id | UUID | 36 | No | Unique ID |
| contract_id | UUID | 36 | No | FK to Contract |
| party_id | UUID | 36 | No | FK to Party |
| role_type | VARCHAR | 25 | No | OWNER, JOINT_OWNER, ANNUITANT, JOINT_ANNUITANT, PRIMARY_BENEFICIARY, CONTINGENT_BENEFICIARY, IRREVOCABLE_BENEFICIARY, AGENT, PAYOR, TRUSTEE, CUSTODIAN, POWER_OF_ATTORNEY, ASSIGNEE |
| benefit_percentage | DECIMAL(8,5) | | Yes | Beneficiary percentage (0.00000 - 1.00000) |
| benefit_type | VARCHAR | 15 | Yes | PER_STIRPES, PER_CAPITA, EQUAL_SHARE |
| relationship_to_owner | VARCHAR | 20 | Yes | SPOUSE, CHILD, PARENT, SIBLING, TRUST, ESTATE, OTHER |
| effective_date | DATE | | No | Role effective date |
| termination_date | DATE | | Yes | Role end date |
| is_active | BOOLEAN | | No | Current active flag |

## 4.5 Address Entity

| Attribute | Data Type | Length | Nullable | Description |
|---|---|---|---|---|
| address_id | UUID | 36 | No | Unique ID |
| party_id | UUID | 36 | No | FK to Party |
| address_type | VARCHAR | 15 | No | RESIDENTIAL, MAILING, BUSINESS |
| line_1 | VARCHAR | 100 | No | Street address line 1 |
| line_2 | VARCHAR | 100 | Yes | Apt, Suite, etc. |
| line_3 | VARCHAR | 100 | Yes | Additional address line |
| city | VARCHAR | 50 | No | City |
| state_code | CHAR | 2 | No | US state code or province |
| postal_code | VARCHAR | 10 | No | ZIP or postal code |
| country_code | CHAR | 2 | No | ISO 3166-1 alpha-2 |
| is_primary | BOOLEAN | | No | Primary address flag |
| effective_date | DATE | | No | Address effective date |
| verified_date | DATE | | Yes | Last USPS/address verification date |

## 4.6 Investment / Sub-Account Entity

### 4.6.1 Sub-Account Allocation

| Attribute | Data Type | Length | Nullable | Description |
|---|---|---|---|---|
| allocation_id | UUID | 36 | No | Unique ID |
| contract_id | UUID | 36 | No | FK to Contract |
| fund_id | VARCHAR | 20 | No | FK to Fund Master |
| cusip | CHAR | 9 | Yes | CUSIP identifier |
| ticker | VARCHAR | 10 | Yes | Ticker symbol |
| allocation_type | VARCHAR | 15 | No | CURRENT, FUTURE_PREMIUM, TRANSFER |
| allocation_pct | DECIMAL(8,5) | | No | Allocation percentage |
| effective_date | DATE | | No | Allocation effective date |
| end_date | DATE | | Yes | Allocation end date (if changed) |

### 4.6.2 Sub-Account Position

| Attribute | Data Type | Length | Nullable | Description |
|---|---|---|---|---|
| position_id | UUID | 36 | No | Unique ID |
| contract_id | UUID | 36 | No | FK to Contract |
| fund_id | VARCHAR | 20 | No | FK to Fund Master |
| valuation_date | DATE | | No | As-of date |
| units | DECIMAL(18,6) | | No | Number of units held |
| unit_value | DECIMAL(12,6) | | No | NAV per unit |
| market_value | DECIMAL(18,2) | | No | Total market value (units × unit_value) |
| cost_basis | DECIMAL(18,2) | | No | Sub-account level cost basis |
| gain_loss | DECIMAL(18,2) | | No | Unrealized gain/loss |

### 4.6.3 Index Strategy (for FIA/RILA)

| Attribute | Data Type | Length | Nullable | Description |
|---|---|---|---|---|
| strategy_id | UUID | 36 | No | Unique ID |
| contract_id | UUID | 36 | No | FK to Contract |
| strategy_type | VARCHAR | 30 | No | ANNUAL_PTP, MONTHLY_AVG, MONTHLY_PTP, PERFORMANCE_TRIGGERED, FIXED_DECLARED |
| index_name | VARCHAR | 50 | No | S&P 500, NASDAQ-100, MSCI EAFE, etc. |
| index_ticker | VARCHAR | 15 | Yes | ^SPX, ^NDX, etc. |
| allocation_pct | DECIMAL(8,5) | | No | Allocation to this strategy |
| allocated_amount | DECIMAL(18,2) | | No | Dollar amount allocated |
| cap_rate | DECIMAL(8,5) | | Yes | Cap rate (ceiling) |
| participation_rate | DECIMAL(8,5) | | Yes | Participation rate |
| spread_rate | DECIMAL(8,5) | | Yes | Spread/margin |
| floor_rate | DECIMAL(8,5) | | Yes | Floor rate (minimum return) |
| buffer_rate | DECIMAL(8,5) | | Yes | Buffer (carrier absorbs first N% loss) |
| term_months | INTEGER | | No | Strategy term length in months |
| term_start_date | DATE | | No | Current term start |
| term_end_date | DATE | | No | Current term end |
| index_value_start | DECIMAL(14,4) | | Yes | Index value at term start |
| index_value_current | DECIMAL(14,4) | | Yes | Latest index value |
| interim_value | DECIMAL(18,2) | | Yes | Interim/daily value |

## 4.7 Rider / Benefit Entity

| Attribute | Data Type | Length | Nullable | Description |
|---|---|---|---|---|
| rider_id | UUID | 36 | No | Unique ID |
| contract_id | UUID | 36 | No | FK to Contract |
| rider_type | VARCHAR | 10 | No | GMDB, GMAB, GMIB, GMWB, GLWB, NH_WAIVER, TI_WAIVER, ENHANCED_DB, RETURN_PREM |
| rider_product_code | VARCHAR | 20 | Yes | Carrier's rider product code |
| rider_status | VARCHAR | 15 | No | ACTIVE, TERMINATED, EXERCISED, EXPIRED |
| effective_date | DATE | | No | Rider effective date |
| termination_date | DATE | | Yes | Rider termination date |
| benefit_base | DECIMAL(18,2) | | Yes | Guaranteed benefit base |
| step_up_type | VARCHAR | 20 | Yes | ANNUAL_RATCHET, ROLLUP, HIGHEST_ANNIV, COMBINATION |
| rollup_rate | DECIMAL(8,5) | | Yes | Rollup percentage (for deferral bonus) |
| max_annual_withdrawal_pct | DECIMAL(8,5) | | Yes | Max annual withdrawal percentage |
| single_life_pct | DECIMAL(8,5) | | Yes | Single-life withdrawal factor |
| joint_life_pct | DECIMAL(8,5) | | Yes | Joint-life withdrawal factor |
| rider_charge_rate | DECIMAL(8,5) | | No | Annual rider charge rate |
| rider_charge_basis | VARCHAR | 20 | No | ACCOUNT_VALUE, BENEFIT_BASE, HIGHER_OF |
| last_step_up_date | DATE | | Yes | Date of last step-up/ratchet |
| next_step_up_date | DATE | | Yes | Next eligible step-up date |
| waiting_period_end | DATE | | Yes | End of waiting/deferral period |
| excess_withdrawal_flag | BOOLEAN | | No | Has excess withdrawal occurred? |

## 4.8 Financial Transaction Entity

| Attribute | Data Type | Length | Nullable | Description |
|---|---|---|---|---|
| transaction_id | UUID | 36 | No | Unique ID |
| contract_id | UUID | 36 | No | FK to Contract |
| transaction_type | VARCHAR | 25 | No | PREMIUM, PARTIAL_WITHDRAWAL, FULL_SURRENDER, DEATH_BENEFIT, SUB_ACCT_TRANSFER, FEE, INTEREST_CREDIT, LOAN_ADVANCE, LOAN_REPAYMENT, DIVIDEND, ANNUITY_PAYMENT, RMD, 1035_EXCHANGE, BONUS_CREDIT, MVA_ADJUSTMENT, RIDER_CHARGE |
| transaction_sub_type | VARCHAR | 30 | Yes | Further classification |
| transaction_status | VARCHAR | 15 | No | PENDING, COMPLETED, REVERSED, REJECTED |
| request_date | DATE | | No | Date transaction was requested |
| effective_date | DATE | | No | Transaction effective date |
| process_date | DATE | | No | Date transaction was processed |
| gross_amount | DECIMAL(18,2) | | No | Gross transaction amount |
| net_amount | DECIMAL(18,2) | | No | Net amount after deductions |
| surrender_charge | DECIMAL(18,2) | | Yes | Surrender charge applied |
| mva_adjustment | DECIMAL(18,2) | | Yes | Market value adjustment |
| federal_withholding | DECIMAL(18,2) | | Yes | Federal tax withheld |
| state_withholding | DECIMAL(18,2) | | Yes | State tax withheld |
| penalty_tax | DECIMAL(18,2) | | Yes | Early withdrawal penalty (10%) |
| tax_year | INTEGER | | Yes | Tax reporting year |
| taxable_amount | DECIMAL(18,2) | | Yes | Taxable portion |
| exclusion_ratio | DECIMAL(8,5) | | Yes | Annuity exclusion ratio |
| fund_id | VARCHAR | 20 | Yes | Sub-account involved |
| units | DECIMAL(18,6) | | Yes | Units transacted |
| unit_value | DECIMAL(12,6) | | Yes | NAV at transaction |
| disbursement_method | VARCHAR | 10 | Yes | CHECK, ACH, WIRE |
| bank_account_id | UUID | | Yes | FK to Banking |
| check_number | VARCHAR | 15 | Yes | Check number (if applicable) |
| reversal_of_txn_id | UUID | | Yes | FK to original transaction (if reversal) |
| notes | TEXT | | Yes | Free-text notes |
| created_by | VARCHAR | 50 | No | User/system that created |
| created_timestamp | TIMESTAMP | | No | Creation timestamp |

## 4.9 Payout / Annuitization Entity

| Attribute | Data Type | Length | Nullable | Description |
|---|---|---|---|---|
| payout_id | UUID | 36 | No | Unique ID |
| contract_id | UUID | 36 | No | FK to Contract |
| payout_status | VARCHAR | 15 | No | ACTIVE, SUSPENDED, COMMUTED, COMPLETED |
| payout_type | VARCHAR | 25 | No | LIFE_ONLY, LIFE_WITH_PERIOD_CERTAIN, JOINT_AND_SURVIVOR, PERIOD_CERTAIN_ONLY, LUMP_SUM, SYSTEMATIC_WITHDRAWAL |
| payout_mode | VARCHAR | 10 | No | MONTHLY, QUARTERLY, SEMI_ANNUAL, ANNUAL |
| payout_amount | DECIMAL(18,2) | | No | Payment amount per period |
| start_date | DATE | | No | First payment date |
| end_date | DATE | | Yes | Last payment date (if determinable) |
| certain_period_months | INTEGER | | Yes | Certain period in months |
| survivor_pct | DECIMAL(8,5) | | Yes | Survivor benefit percentage |
| cost_of_living_adj_pct | DECIMAL(8,5) | | Yes | Annual COLA percentage |
| exclusion_ratio | DECIMAL(8,5) | | Yes | Tax exclusion ratio |
| expected_return | DECIMAL(18,2) | | Yes | IRS expected return for exclusion ratio |
| investment_in_contract | DECIMAL(18,2) | | Yes | Basis for exclusion ratio |
| payments_made_count | INTEGER | | Yes | Number of payments made |
| total_paid_amount | DECIMAL(18,2) | | Yes | Cumulative payments made |

## 4.10 Banking / EFT Entity

| Attribute | Data Type | Length | Nullable | Description |
|---|---|---|---|---|
| bank_account_id | UUID | 36 | No | Unique ID |
| party_id | UUID | 36 | No | FK to Party |
| account_type | VARCHAR | 10 | No | CHECKING, SAVINGS |
| bank_name | VARCHAR | 100 | Yes | Bank name |
| routing_number | VARCHAR | 9 | No | ABA routing number |
| account_number | VARCHAR | 17 | No | Bank account number (encrypted) |
| account_holder_name | VARCHAR | 100 | No | Name on account |
| eft_purpose | VARCHAR | 15 | No | PREMIUM, DISBURSEMENT, BOTH |
| prenote_status | VARCHAR | 10 | Yes | PENDING, VERIFIED, FAILED |
| prenote_date | DATE | | Yes | Pre-notification date |
| is_active | BOOLEAN | | No | Active flag |

---

# 5. Database Schema Design

## 5.1 Design Principles for Annuity Administration Databases

### 5.1.1 Temporal Data Modeling

Annuity systems require **bi-temporal modeling** to track:

1. **Valid Time (Business Time)** — When a fact is true in the real world (e.g., the address was effective from Jan 1 to Mar 15).
2. **Transaction Time (System Time)** — When the system recorded the fact (e.g., the address change was entered on Mar 20, retroactive to Mar 15).

This is critical because:
- Policy changes can be retroactive (e.g., a beneficiary change effective 30 days ago).
- Financial corrections may restate values as of a past date.
- Regulatory audits require point-in-time reconstruction.

### 5.1.2 Bi-Temporal Table Pattern

```sql
CREATE TABLE contract_bi_temporal (
    contract_id          UUID NOT NULL,
    contract_number      VARCHAR(20) NOT NULL,
    contract_status      VARCHAR(20) NOT NULL,
    account_value        DECIMAL(18,2),
    -- ... other attributes ...

    -- Valid time (when the fact was true in the real world)
    valid_from           TIMESTAMP NOT NULL,
    valid_to             TIMESTAMP NOT NULL DEFAULT '9999-12-31 23:59:59',

    -- Transaction time (when the system recorded this version)
    txn_from             TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    txn_to               TIMESTAMP NOT NULL DEFAULT '9999-12-31 23:59:59',

    -- Audit fields
    created_by           VARCHAR(50) NOT NULL,
    change_reason        VARCHAR(200),

    CONSTRAINT pk_contract_bt PRIMARY KEY (contract_id, valid_from, txn_from)
);

CREATE INDEX idx_contract_bt_number ON contract_bi_temporal(contract_number);
CREATE INDEX idx_contract_bt_valid ON contract_bi_temporal(valid_from, valid_to);
CREATE INDEX idx_contract_bt_txn ON contract_bi_temporal(txn_from, txn_to);
```

### 5.1.3 Querying Bi-Temporal Data

```sql
-- "What was the contract status as of March 1, 2025,
--  according to what the system knew on March 15, 2025?"
SELECT *
FROM contract_bi_temporal
WHERE contract_number = 'ANN-2023-001'
  AND valid_from  <= '2025-03-01'
  AND valid_to    >  '2025-03-01'
  AND txn_from    <= '2025-03-15'
  AND txn_to      >  '2025-03-15';
```

## 5.2 Relational Schema DDL

### 5.2.1 Contract (Policy) Table

```sql
CREATE TABLE contract (
    contract_id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    contract_number        VARCHAR(20) NOT NULL UNIQUE,
    carrier_code           VARCHAR(10) NOT NULL,
    product_code           VARCHAR(20) NOT NULL,
    product_type           VARCHAR(4) NOT NULL
        CHECK (product_type IN ('FA','VA','FIA','RILA','SPIA','DIA','QLAC','MYGA')),
    qualified_plan_type    VARCHAR(10) NOT NULL DEFAULT 'NQ'
        CHECK (qualified_plan_type IN ('NQ','TIRA','RIRA','SEP','SIMPLE','401K','403B','457B','IIRA','PENSION','ROTH401K')),
    contract_status        VARCHAR(20) NOT NULL DEFAULT 'PROPOSED'
        CHECK (contract_status IN ('PROPOSED','PENDING','ACTIVE','SURRENDERED','ANNUITIZED','DEATH_CLAIM','MATURED','LAPSED','TRANSFERRED','DECLINED','FREE_LOOK')),
    application_date       DATE,
    submission_date        DATE,
    issue_date             DATE,
    effective_date         DATE NOT NULL,
    maturity_date          DATE,
    termination_date       DATE,
    termination_reason     VARCHAR(30),
    initial_premium        DECIMAL(18,2) NOT NULL,
    total_premiums         DECIMAL(18,2) DEFAULT 0.00,
    payment_mode           VARCHAR(10),
    planned_periodic_prem  DECIMAL(18,2),
    free_look_end_date     DATE,
    replacement_ind        BOOLEAN NOT NULL DEFAULT FALSE,
    exchange_1035_ind      BOOLEAN NOT NULL DEFAULT FALSE,
    mec_ind                BOOLEAN NOT NULL DEFAULT FALSE,
    state_of_issue         CHAR(2) NOT NULL,
    currency_code          CHAR(3) NOT NULL DEFAULT 'USD',
    created_timestamp      TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_timestamp      TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    version                INTEGER NOT NULL DEFAULT 1,

    CONSTRAINT fk_contract_product FOREIGN KEY (product_code)
        REFERENCES product_master(product_code)
);

CREATE INDEX idx_contract_status ON contract(contract_status);
CREATE INDEX idx_contract_product ON contract(product_code);
CREATE INDEX idx_contract_carrier ON contract(carrier_code);
CREATE INDEX idx_contract_dates ON contract(effective_date, termination_date);
```

### 5.2.2 Party Table

```sql
CREATE TABLE party (
    party_id               UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    party_type             VARCHAR(12) NOT NULL
        CHECK (party_type IN ('INDIVIDUAL','ORGANIZATION','TRUST')),
    prefix                 VARCHAR(10),
    first_name             VARCHAR(50),
    middle_name            VARCHAR(50),
    last_name              VARCHAR(80),
    suffix                 VARCHAR(10),
    organization_name      VARCHAR(150),
    org_type               VARCHAR(20),
    tax_id_type            VARCHAR(5) NOT NULL
        CHECK (tax_id_type IN ('SSN','EIN','ITIN')),
    tax_id_hash            VARCHAR(64) NOT NULL,  -- SHA-256 hash for lookups
    tax_id_encrypted       BYTEA NOT NULL,         -- AES-256 encrypted value
    date_of_birth          DATE,
    date_of_death          DATE,
    gender                 CHAR(1) CHECK (gender IN ('M','F','U')),
    citizenship            CHAR(2) DEFAULT 'US',
    residence_state        CHAR(2),
    residence_country      CHAR(2) DEFAULT 'US',
    marital_status         VARCHAR(15),
    created_timestamp      TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_timestamp      TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_party_tax_hash ON party(tax_id_hash);
CREATE INDEX idx_party_name ON party(last_name, first_name);
```

### 5.2.3 Contract Role Table

```sql
CREATE TABLE contract_role (
    contract_role_id       UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    contract_id            UUID NOT NULL,
    party_id               UUID NOT NULL,
    role_type              VARCHAR(25) NOT NULL
        CHECK (role_type IN ('OWNER','JOINT_OWNER','ANNUITANT','JOINT_ANNUITANT',
            'PRIMARY_BENEFICIARY','CONTINGENT_BENEFICIARY','IRREVOCABLE_BENEFICIARY',
            'AGENT','PAYOR','TRUSTEE','CUSTODIAN','POWER_OF_ATTORNEY','ASSIGNEE')),
    benefit_percentage     DECIMAL(8,5),
    benefit_type           VARCHAR(15),
    relationship_to_owner  VARCHAR(20),
    effective_date         DATE NOT NULL,
    termination_date       DATE,
    is_active              BOOLEAN NOT NULL DEFAULT TRUE,
    created_timestamp      TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_timestamp      TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_cr_contract FOREIGN KEY (contract_id) REFERENCES contract(contract_id),
    CONSTRAINT fk_cr_party FOREIGN KEY (party_id) REFERENCES party(party_id)
);

CREATE INDEX idx_cr_contract ON contract_role(contract_id);
CREATE INDEX idx_cr_party ON contract_role(party_id);
CREATE INDEX idx_cr_role ON contract_role(role_type, is_active);
```

### 5.2.4 Address Table

```sql
CREATE TABLE address (
    address_id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    party_id               UUID NOT NULL,
    address_type           VARCHAR(15) NOT NULL
        CHECK (address_type IN ('RESIDENTIAL','MAILING','BUSINESS')),
    line_1                 VARCHAR(100) NOT NULL,
    line_2                 VARCHAR(100),
    line_3                 VARCHAR(100),
    city                   VARCHAR(50) NOT NULL,
    state_code             CHAR(2) NOT NULL,
    postal_code            VARCHAR(10) NOT NULL,
    country_code           CHAR(2) NOT NULL DEFAULT 'US',
    is_primary             BOOLEAN NOT NULL DEFAULT FALSE,
    effective_date         DATE NOT NULL,
    termination_date       DATE,
    verified_date          DATE,
    created_timestamp      TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_addr_party FOREIGN KEY (party_id) REFERENCES party(party_id)
);

CREATE INDEX idx_addr_party ON address(party_id);
```

### 5.2.5 Sub-Account Allocation Table

```sql
CREATE TABLE sub_account_allocation (
    allocation_id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    contract_id            UUID NOT NULL,
    fund_id                VARCHAR(20) NOT NULL,
    allocation_type        VARCHAR(15) NOT NULL
        CHECK (allocation_type IN ('CURRENT','FUTURE_PREMIUM','TRANSFER')),
    allocation_pct         DECIMAL(8,5) NOT NULL,
    effective_date         DATE NOT NULL,
    end_date               DATE,
    created_timestamp      TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_saa_contract FOREIGN KEY (contract_id) REFERENCES contract(contract_id),
    CONSTRAINT fk_saa_fund FOREIGN KEY (fund_id) REFERENCES fund_master(fund_id)
);
```

### 5.2.6 Sub-Account Position Table

```sql
CREATE TABLE sub_account_position (
    position_id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    contract_id            UUID NOT NULL,
    fund_id                VARCHAR(20) NOT NULL,
    valuation_date         DATE NOT NULL,
    units                  DECIMAL(18,6) NOT NULL,
    unit_value             DECIMAL(12,6) NOT NULL,
    market_value           DECIMAL(18,2) NOT NULL,
    cost_basis             DECIMAL(18,2) NOT NULL DEFAULT 0.00,
    gain_loss              DECIMAL(18,2) GENERATED ALWAYS AS (market_value - cost_basis) STORED,
    created_timestamp      TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_sap_contract FOREIGN KEY (contract_id) REFERENCES contract(contract_id),
    CONSTRAINT fk_sap_fund FOREIGN KEY (fund_id) REFERENCES fund_master(fund_id),
    CONSTRAINT uq_sap_contract_fund_date UNIQUE (contract_id, fund_id, valuation_date)
);

CREATE INDEX idx_sap_valuation ON sub_account_position(valuation_date);
```

### 5.2.7 Index Strategy Table (FIA/RILA)

```sql
CREATE TABLE index_strategy (
    strategy_id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    contract_id            UUID NOT NULL,
    strategy_type          VARCHAR(30) NOT NULL,
    index_name             VARCHAR(50) NOT NULL,
    index_ticker           VARCHAR(15),
    allocation_pct         DECIMAL(8,5) NOT NULL,
    allocated_amount       DECIMAL(18,2) NOT NULL,
    cap_rate               DECIMAL(8,5),
    participation_rate     DECIMAL(8,5),
    spread_rate            DECIMAL(8,5),
    floor_rate             DECIMAL(8,5),
    buffer_rate            DECIMAL(8,5),
    term_months            INTEGER NOT NULL,
    term_start_date        DATE NOT NULL,
    term_end_date          DATE NOT NULL,
    index_value_start      DECIMAL(14,4),
    index_value_current    DECIMAL(14,4),
    interim_value          DECIMAL(18,2),
    created_timestamp      TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_timestamp      TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_is_contract FOREIGN KEY (contract_id) REFERENCES contract(contract_id)
);
```

### 5.2.8 Rider Table

```sql
CREATE TABLE rider (
    rider_id               UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    contract_id            UUID NOT NULL,
    rider_type             VARCHAR(10) NOT NULL
        CHECK (rider_type IN ('GMDB','GMAB','GMIB','GMWB','GLWB',
            'NH_WAIVER','TI_WAIVER','ENHANCED_DB','RETURN_PREM','ANNUAL_STEPUP','EARNINGS_ENH')),
    rider_product_code     VARCHAR(20),
    rider_status           VARCHAR(15) NOT NULL DEFAULT 'ACTIVE'
        CHECK (rider_status IN ('ACTIVE','TERMINATED','EXERCISED','EXPIRED')),
    effective_date         DATE NOT NULL,
    termination_date       DATE,
    benefit_base           DECIMAL(18,2),
    step_up_type           VARCHAR(20),
    rollup_rate            DECIMAL(8,5),
    max_annual_wd_pct      DECIMAL(8,5),
    single_life_pct        DECIMAL(8,5),
    joint_life_pct         DECIMAL(8,5),
    rider_charge_rate      DECIMAL(8,5) NOT NULL,
    rider_charge_basis     VARCHAR(20) NOT NULL,
    last_step_up_date      DATE,
    next_step_up_date      DATE,
    waiting_period_end     DATE,
    excess_withdrawal_flag BOOLEAN NOT NULL DEFAULT FALSE,
    created_timestamp      TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_timestamp      TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_rider_contract FOREIGN KEY (contract_id) REFERENCES contract(contract_id)
);

CREATE INDEX idx_rider_contract ON rider(contract_id);
CREATE INDEX idx_rider_type ON rider(rider_type, rider_status);
```

### 5.2.9 Financial Transaction Table

```sql
CREATE TABLE financial_transaction (
    transaction_id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    contract_id            UUID NOT NULL,
    transaction_type       VARCHAR(25) NOT NULL,
    transaction_sub_type   VARCHAR(30),
    transaction_status     VARCHAR(15) NOT NULL DEFAULT 'PENDING'
        CHECK (transaction_status IN ('PENDING','COMPLETED','REVERSED','REJECTED','PROCESSING')),
    request_date           DATE NOT NULL,
    effective_date         DATE NOT NULL,
    process_date           DATE,
    gross_amount           DECIMAL(18,2) NOT NULL,
    net_amount             DECIMAL(18,2) NOT NULL,
    surrender_charge       DECIMAL(18,2) DEFAULT 0.00,
    mva_adjustment         DECIMAL(18,2) DEFAULT 0.00,
    federal_withholding    DECIMAL(18,2) DEFAULT 0.00,
    state_withholding      DECIMAL(18,2) DEFAULT 0.00,
    penalty_tax            DECIMAL(18,2) DEFAULT 0.00,
    tax_year               INTEGER,
    taxable_amount         DECIMAL(18,2),
    exclusion_ratio        DECIMAL(8,5),
    fund_id                VARCHAR(20),
    units                  DECIMAL(18,6),
    unit_value             DECIMAL(12,6),
    disbursement_method    VARCHAR(10),
    bank_account_id        UUID,
    check_number           VARCHAR(15),
    reversal_of_txn_id     UUID,
    notes                  TEXT,
    created_by             VARCHAR(50) NOT NULL,
    created_timestamp      TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_ft_contract FOREIGN KEY (contract_id) REFERENCES contract(contract_id),
    CONSTRAINT fk_ft_fund FOREIGN KEY (fund_id) REFERENCES fund_master(fund_id),
    CONSTRAINT fk_ft_bank FOREIGN KEY (bank_account_id) REFERENCES bank_account(bank_account_id),
    CONSTRAINT fk_ft_reversal FOREIGN KEY (reversal_of_txn_id)
        REFERENCES financial_transaction(transaction_id)
);

CREATE INDEX idx_ft_contract ON financial_transaction(contract_id);
CREATE INDEX idx_ft_type ON financial_transaction(transaction_type, transaction_status);
CREATE INDEX idx_ft_dates ON financial_transaction(effective_date);
CREATE INDEX idx_ft_process ON financial_transaction(process_date);
```

### 5.2.10 Payout Table

```sql
CREATE TABLE payout (
    payout_id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    contract_id            UUID NOT NULL,
    payout_status          VARCHAR(15) NOT NULL DEFAULT 'ACTIVE',
    payout_type            VARCHAR(30) NOT NULL,
    payout_mode            VARCHAR(12) NOT NULL,
    payout_amount          DECIMAL(18,2) NOT NULL,
    start_date             DATE NOT NULL,
    end_date               DATE,
    certain_period_months  INTEGER,
    survivor_pct           DECIMAL(8,5),
    cola_pct               DECIMAL(8,5),
    exclusion_ratio        DECIMAL(8,5),
    expected_return        DECIMAL(18,2),
    investment_in_contract DECIMAL(18,2),
    payments_made_count    INTEGER DEFAULT 0,
    total_paid_amount      DECIMAL(18,2) DEFAULT 0.00,
    created_timestamp      TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_timestamp      TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_payout_contract FOREIGN KEY (contract_id) REFERENCES contract(contract_id)
);
```

### 5.2.11 Contract Financial Summary (Materialized Snapshot)

```sql
CREATE TABLE contract_financial_summary (
    contract_id            UUID NOT NULL,
    valuation_date         DATE NOT NULL,
    account_value          DECIMAL(18,2) NOT NULL,
    surrender_value        DECIMAL(18,2) NOT NULL,
    death_benefit_value    DECIMAL(18,2) NOT NULL,
    loan_balance           DECIMAL(18,2) DEFAULT 0.00,
    loan_interest_accrued  DECIMAL(18,2) DEFAULT 0.00,
    cost_basis             DECIMAL(18,2) NOT NULL,
    gain_loss              DECIMAL(18,2) NOT NULL,
    surrender_charge_amt   DECIMAL(18,2),
    surrender_charge_pct   DECIMAL(8,5),
    free_withdrawal_amt    DECIMAL(18,2),
    gmwb_benefit_base      DECIMAL(18,2),
    gmwb_remaining_benefit DECIMAL(18,2),
    gmib_benefit_base      DECIMAL(18,2),
    gmab_guarantee_value   DECIMAL(18,2),
    ytd_premiums           DECIMAL(18,2) DEFAULT 0.00,
    ytd_withdrawals        DECIMAL(18,2) DEFAULT 0.00,
    ytd_rmd_amount         DECIMAL(18,2),
    rmd_required_amount    DECIMAL(18,2),
    created_timestamp      TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_cfs PRIMARY KEY (contract_id, valuation_date),
    CONSTRAINT fk_cfs_contract FOREIGN KEY (contract_id) REFERENCES contract(contract_id)
);

CREATE INDEX idx_cfs_date ON contract_financial_summary(valuation_date);
```

### 5.2.12 Audit Trail Table

```sql
CREATE TABLE audit_trail (
    audit_id               BIGSERIAL PRIMARY KEY,
    entity_type            VARCHAR(30) NOT NULL,
    entity_id              UUID NOT NULL,
    action                 VARCHAR(10) NOT NULL
        CHECK (action IN ('INSERT','UPDATE','DELETE')),
    field_name             VARCHAR(50),
    old_value              TEXT,
    new_value              TEXT,
    change_reason          VARCHAR(200),
    changed_by             VARCHAR(50) NOT NULL,
    changed_timestamp      TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    source_system          VARCHAR(30),
    correlation_id         UUID
);

CREATE INDEX idx_audit_entity ON audit_trail(entity_type, entity_id);
CREATE INDEX idx_audit_timestamp ON audit_trail(changed_timestamp);
```

## 5.3 Entity-Relationship Summary

```
party ─────────┐
  │             │
  │ 1       N   │
  ▼             ▼
address    contract_role ──── N:1 ──── contract
phone           │                       │
email           │                       ├── 1:N ── sub_account_allocation
bank_account    │                       ├── 1:N ── sub_account_position
                │                       ├── 1:N ── index_strategy
                │                       ├── 1:N ── rider
                │                       ├── 1:N ── financial_transaction
                │                       ├── 1:N ── payout
                │                       ├── 1:N ── contract_financial_summary
                │                       └── N:1 ── product_master
                │
                └─ role_type = AGENT ── N:1 ── agent_master
```

## 5.4 Versioning and Optimistic Concurrency

```sql
-- Optimistic locking on contract updates
UPDATE contract
SET contract_status = 'ACTIVE',
    issue_date = '2025-04-20',
    updated_timestamp = CURRENT_TIMESTAMP,
    version = version + 1
WHERE contract_id = 'abc-123'
  AND version = 3;  -- must match current version

-- If affected rows = 0, another process modified the record
```

## 5.5 Partitioning Strategies

For large annuity books (millions of contracts, billions of transactions):

```sql
-- Range partition financial_transaction by effective_date
CREATE TABLE financial_transaction (
    -- columns as above
) PARTITION BY RANGE (effective_date);

CREATE TABLE ft_2024 PARTITION OF financial_transaction
    FOR VALUES FROM ('2024-01-01') TO ('2025-01-01');
CREATE TABLE ft_2025 PARTITION OF financial_transaction
    FOR VALUES FROM ('2025-01-01') TO ('2026-01-01');
CREATE TABLE ft_2026 PARTITION OF financial_transaction
    FOR VALUES FROM ('2026-01-01') TO ('2027-01-01');

-- Range partition sub_account_position by valuation_date
CREATE TABLE sub_account_position (
    -- columns as above
) PARTITION BY RANGE (valuation_date);
```

---

# 6. Event-Driven Data Formats

## 6.1 Domain Events in Annuity Systems

Modern annuity platforms are increasingly event-driven. The following domain events represent state changes in the annuity lifecycle:

### 6.1.1 Event Catalog

| Event Name | Trigger | Key Payload Fields |
|---|---|---|
| ApplicationSubmitted | New application received | contract_id, product_code, owner, annuitant, initial_premium |
| ApplicationStatusChanged | NIGO, Approved, Declined | contract_id, old_status, new_status, reason_codes |
| PolicyIssued | Contract issued | contract_id, contract_number, issue_date, effective_date |
| PremiumReceived | Premium payment processed | contract_id, amount, payment_method, fund_allocations |
| WithdrawalProcessed | Partial or full withdrawal | contract_id, gross_amount, net_amount, surrender_charge, tax_withholding |
| FullSurrenderProcessed | Contract fully surrendered | contract_id, surrender_value, surrender_charge, disbursement |
| DeathClaimFiled | Death claim initiated | contract_id, deceased_party_id, date_of_death, death_benefit |
| DeathBenefitPaid | Death benefit disbursed | contract_id, beneficiary_id, amount, settlement_option |
| AnnuitizationStarted | Annuitization elected | contract_id, payout_type, payout_mode, payout_amount, start_date |
| AnnuityPaymentMade | Periodic annuity payment | contract_id, payout_id, payment_amount, payment_date |
| BeneficiaryChanged | Beneficiary updated | contract_id, old_beneficiary, new_beneficiary, effective_date |
| OwnerChanged | Ownership transferred | contract_id, old_owner, new_owner, effective_date |
| AddressChanged | Address updated | party_id, old_address, new_address |
| SubAccountTransfer | Inter-fund transfer | contract_id, from_fund, to_fund, amount_or_pct |
| AllocationChanged | Future allocation changed | contract_id, new_allocations |
| RiderAdded | Rider elected | contract_id, rider_type, benefit_base, charge_rate |
| RiderExercised | Living benefit exercised | contract_id, rider_id, exercise_type, benefit_amount |
| RMDCalculated | RMD computed for year | contract_id, tax_year, rmd_amount, prior_year_end_value |
| RMDDistributed | RMD payment made | contract_id, tax_year, amount, remaining_rmd |
| ContractValueUpdated | Daily/periodic valuation | contract_id, valuation_date, account_value, surrender_value, death_benefit |
| SurrenderChargeScheduleAdvanced | Anniversary passed | contract_id, new_charge_pct, years_remaining |
| Exchange1035Initiated | 1035 exchange started | source_contract, target_contract, carrier, amount |
| Exchange1035Completed | 1035 exchange funds received | contract_id, source_carrier, amount, cost_basis |
| LoanAdvanced | Policy loan taken | contract_id, loan_amount, interest_rate |
| LoanRepaid | Policy loan repayment | contract_id, repayment_amount, remaining_balance |
| FreeWithdrawalReset | Annual free WD amount reset | contract_id, new_free_wd_amount, reset_date |
| ContractMatured | Contract reached maturity | contract_id, maturity_date, account_value |

## 6.2 CloudEvents Format

All domain events should conform to the [CloudEvents](https://cloudevents.io/) specification for interoperability:

```json
{
  "specversion": "1.0",
  "id": "evt-2025-0415-a1b2c3d4",
  "source": "/annuity-admin/policy-service",
  "type": "com.carrier.annuity.PolicyIssued",
  "datacontenttype": "application/json",
  "time": "2025-04-15T14:30:00Z",
  "subject": "contract/ANN-2025-001234",
  "data": {
    "contract_id": "550e8400-e29b-41d4-a716-446655440000",
    "contract_number": "ANN-2025-001234",
    "carrier_code": "XYZ",
    "product_code": "VA-FLEX-III",
    "product_type": "VA",
    "issue_date": "2025-04-15",
    "effective_date": "2025-04-15",
    "initial_premium": 100000.00,
    "qualified_plan_type": "NQ",
    "state_of_issue": "CT",
    "owner": {
      "party_id": "660e8400-e29b-41d4-a716-446655440001",
      "first_name": "John",
      "last_name": "Smith",
      "tax_id_last4": "6789"
    },
    "agent": {
      "agent_id": "AGT-44521",
      "agent_name": "Robert Johnson"
    }
  }
}
```

## 6.3 Event Schemas — Apache Avro

### 6.3.1 PolicyIssued Avro Schema

```json
{
  "type": "record",
  "name": "PolicyIssued",
  "namespace": "com.carrier.annuity.events",
  "doc": "Emitted when an annuity contract is issued",
  "fields": [
    {"name": "event_id", "type": "string", "doc": "Unique event identifier"},
    {"name": "event_timestamp", "type": {"type": "long", "logicalType": "timestamp-millis"}},
    {"name": "contract_id", "type": "string"},
    {"name": "contract_number", "type": "string"},
    {"name": "carrier_code", "type": "string"},
    {"name": "product_code", "type": "string"},
    {"name": "product_type", "type": {"type": "enum", "name": "ProductType",
      "symbols": ["FA","VA","FIA","RILA","SPIA","DIA","QLAC","MYGA"]}},
    {"name": "issue_date", "type": {"type": "int", "logicalType": "date"}},
    {"name": "effective_date", "type": {"type": "int", "logicalType": "date"}},
    {"name": "initial_premium", "type": {"type": "bytes", "logicalType": "decimal",
      "precision": 18, "scale": 2}},
    {"name": "qualified_plan_type", "type": "string"},
    {"name": "state_of_issue", "type": "string"},
    {"name": "owner_party_id", "type": "string"},
    {"name": "annuitant_party_id", "type": "string"},
    {"name": "agent_id", "type": ["null", "string"], "default": null}
  ]
}
```

### 6.3.2 PremiumReceived Avro Schema

```json
{
  "type": "record",
  "name": "PremiumReceived",
  "namespace": "com.carrier.annuity.events",
  "doc": "Emitted when a premium payment is applied to a contract",
  "fields": [
    {"name": "event_id", "type": "string"},
    {"name": "event_timestamp", "type": {"type": "long", "logicalType": "timestamp-millis"}},
    {"name": "contract_id", "type": "string"},
    {"name": "contract_number", "type": "string"},
    {"name": "transaction_id", "type": "string"},
    {"name": "premium_type", "type": {"type": "enum", "name": "PremiumType",
      "symbols": ["INITIAL","SUBSEQUENT","1035_EXCHANGE","TRANSFER_IN","ROLLOVER"]}},
    {"name": "gross_amount", "type": {"type": "bytes", "logicalType": "decimal",
      "precision": 18, "scale": 2}},
    {"name": "net_amount", "type": {"type": "bytes", "logicalType": "decimal",
      "precision": 18, "scale": 2}},
    {"name": "payment_method", "type": {"type": "enum", "name": "PaymentMethod",
      "symbols": ["CHECK","ACH","WIRE","1035","TRANSFER"]}},
    {"name": "effective_date", "type": {"type": "int", "logicalType": "date"}},
    {"name": "fund_allocations", "type": {"type": "array", "items": {
      "type": "record", "name": "FundAllocation", "fields": [
        {"name": "fund_id", "type": "string"},
        {"name": "allocation_pct", "type": "double"},
        {"name": "amount", "type": {"type": "bytes", "logicalType": "decimal",
          "precision": 18, "scale": 2}}
      ]
    }}}
  ]
}
```

### 6.3.3 WithdrawalProcessed Avro Schema

```json
{
  "type": "record",
  "name": "WithdrawalProcessed",
  "namespace": "com.carrier.annuity.events",
  "doc": "Emitted when a withdrawal is processed",
  "fields": [
    {"name": "event_id", "type": "string"},
    {"name": "event_timestamp", "type": {"type": "long", "logicalType": "timestamp-millis"}},
    {"name": "contract_id", "type": "string"},
    {"name": "contract_number", "type": "string"},
    {"name": "transaction_id", "type": "string"},
    {"name": "withdrawal_type", "type": {"type": "enum", "name": "WithdrawalType",
      "symbols": ["PARTIAL","FULL_SURRENDER","RMD","SYSTEMATIC","FREE_WITHDRAWAL"]}},
    {"name": "gross_amount", "type": {"type": "bytes", "logicalType": "decimal",
      "precision": 18, "scale": 2}},
    {"name": "net_amount", "type": {"type": "bytes", "logicalType": "decimal",
      "precision": 18, "scale": 2}},
    {"name": "surrender_charge", "type": {"type": "bytes", "logicalType": "decimal",
      "precision": 18, "scale": 2}},
    {"name": "mva_adjustment", "type": {"type": "bytes", "logicalType": "decimal",
      "precision": 18, "scale": 2}},
    {"name": "federal_withholding", "type": {"type": "bytes", "logicalType": "decimal",
      "precision": 18, "scale": 2}},
    {"name": "state_withholding", "type": {"type": "bytes", "logicalType": "decimal",
      "precision": 18, "scale": 2}},
    {"name": "taxable_amount", "type": {"type": "bytes", "logicalType": "decimal",
      "precision": 18, "scale": 2}},
    {"name": "effective_date", "type": {"type": "int", "logicalType": "date"}},
    {"name": "disbursement_method", "type": {"type": "enum", "name": "DisbursementMethod",
      "symbols": ["CHECK","ACH","WIRE"]}},
    {"name": "rider_impact", "type": ["null", {
      "type": "record", "name": "RiderImpact", "fields": [
        {"name": "rider_id", "type": "string"},
        {"name": "rider_type", "type": "string"},
        {"name": "is_excess_withdrawal", "type": "boolean"},
        {"name": "new_benefit_base", "type": ["null", {"type": "bytes",
          "logicalType": "decimal", "precision": 18, "scale": 2}]}
      ]
    }], "default": null}
  ]
}
```

## 6.4 Protobuf Schema Examples

### 6.4.1 DeathClaimFiled Protobuf

```protobuf
syntax = "proto3";

package com.carrier.annuity.events;

import "google/protobuf/timestamp.proto";

message DeathClaimFiled {
  string event_id = 1;
  google.protobuf.Timestamp event_timestamp = 2;
  string contract_id = 3;
  string contract_number = 4;
  string deceased_party_id = 5;
  string date_of_death = 6;  // ISO 8601 date
  string reported_date = 7;
  DeceasedRole deceased_role = 8;
  DeathBenefitInfo death_benefit = 9;
  repeated BeneficiaryInfo beneficiaries = 10;

  enum DeceasedRole {
    UNKNOWN_ROLE = 0;
    OWNER = 1;
    ANNUITANT = 2;
    JOINT_OWNER = 3;
    JOINT_ANNUITANT = 4;
  }

  message DeathBenefitInfo {
    string death_benefit_type = 1;
    string estimated_amount = 2;  // decimal as string
    string account_value_at_death = 3;
    string highest_anniversary_value = 4;
    string total_premiums_paid = 5;
  }

  message BeneficiaryInfo {
    string party_id = 1;
    string name = 2;
    string designation = 3;  // PRIMARY, CONTINGENT
    double benefit_percentage = 4;
    string relationship = 5;
  }
}
```

### 6.4.2 AnnuitizationStarted Protobuf

```protobuf
syntax = "proto3";

package com.carrier.annuity.events;

import "google/protobuf/timestamp.proto";

message AnnuitizationStarted {
  string event_id = 1;
  google.protobuf.Timestamp event_timestamp = 2;
  string contract_id = 3;
  string contract_number = 4;
  string annuitization_date = 5;

  PayoutType payout_type = 6;
  string payout_mode = 7;    // MONTHLY, QUARTERLY, etc.
  string payout_amount = 8;  // decimal as string
  string first_payment_date = 9;

  string account_value_at_annuitization = 10;
  string exclusion_ratio = 11;
  string investment_in_contract = 12;
  string expected_return = 13;

  int32 certain_period_months = 14;
  double survivor_percentage = 15;

  enum PayoutType {
    UNKNOWN_PAYOUT = 0;
    LIFE_ONLY = 1;
    LIFE_WITH_PERIOD_CERTAIN = 2;
    JOINT_AND_SURVIVOR = 3;
    PERIOD_CERTAIN_ONLY = 4;
    INSTALLMENT_REFUND = 5;
    CASH_REFUND = 6;
  }
}
```

## 6.5 Event Topic / Channel Strategy

| Topic Name | Events | Partitioning Key |
|---|---|---|
| `annuity.contract.lifecycle` | ApplicationSubmitted, PolicyIssued, ContractMatured | contract_id |
| `annuity.contract.financial` | PremiumReceived, WithdrawalProcessed, FullSurrenderProcessed | contract_id |
| `annuity.contract.valuation` | ContractValueUpdated, SubAccountPositionUpdated | contract_id |
| `annuity.contract.claims` | DeathClaimFiled, DeathBenefitPaid | contract_id |
| `annuity.contract.payout` | AnnuitizationStarted, AnnuityPaymentMade | contract_id |
| `annuity.contract.service` | BeneficiaryChanged, OwnerChanged, AddressChanged, AllocationChanged | contract_id |
| `annuity.contract.transfers` | SubAccountTransfer, Exchange1035Initiated, Exchange1035Completed | contract_id |
| `annuity.rider.events` | RiderAdded, RiderExercised, RiderStepUp | contract_id |
| `annuity.compliance` | RMDCalculated, RMDDistributed, SuitabilityCompleted | contract_id |

---

# 7. API Data Contracts

## 7.1 RESTful API Resource Model

### 7.1.1 Resource Hierarchy

```
/api/v1
├── /contracts
│   ├── GET    /                          → List contracts (paginated, filtered)
│   ├── POST   /                          → Create new contract (application)
│   ├── GET    /{contractId}              → Get contract detail
│   ├── PATCH  /{contractId}              → Update contract
│   │
│   ├── GET    /{contractId}/values       → Get current financial values
│   ├── GET    /{contractId}/values/history → Get historical values
│   │
│   ├── GET    /{contractId}/parties      → List all parties/roles
│   ├── POST   /{contractId}/parties      → Add party/role
│   ├── PUT    /{contractId}/parties/{roleId} → Update party role
│   ├── DELETE /{contractId}/parties/{roleId} → Remove party role
│   │
│   ├── GET    /{contractId}/allocations  → Get current allocations
│   ├── PUT    /{contractId}/allocations  → Change allocations
│   │
│   ├── GET    /{contractId}/positions    → Get sub-account positions
│   │
│   ├── GET    /{contractId}/riders       → List riders
│   │
│   ├── GET    /{contractId}/transactions → List financial transactions
│   ├── POST   /{contractId}/transactions → Submit transaction
│   │
│   ├── GET    /{contractId}/payouts      → Get payout info
│   ├── POST   /{contractId}/payouts      → Elect annuitization
│   │
│   ├── POST   /{contractId}/withdrawals  → Request withdrawal
│   ├── POST   /{contractId}/surrenders   → Request full surrender
│   ├── POST   /{contractId}/transfers    → Request sub-account transfer
│   ├── POST   /{contractId}/loans        → Request loan
│   │
│   └── GET    /{contractId}/documents    → List associated documents
│
├── /parties
│   ├── GET    /                          → Search parties
│   ├── GET    /{partyId}                 → Get party detail
│   ├── PATCH  /{partyId}                 → Update party
│   └── GET    /{partyId}/contracts       → Get party's contracts
│
├── /products
│   ├── GET    /                          → List available products
│   └── GET    /{productCode}             → Get product detail
│
├── /funds
│   ├── GET    /                          → List available funds
│   └── GET    /{fundId}                  → Get fund detail with NAV
│
└── /agents
    ├── GET    /                          → Search agents
    └── GET    /{agentId}/contracts       → Get agent's book of business
```

### 7.1.2 OpenAPI Schema Fragments

#### Contract Response Schema

```yaml
openapi: 3.0.3
info:
  title: Annuity Administration API
  version: 1.0.0

components:
  schemas:
    Contract:
      type: object
      required:
        - contractId
        - contractNumber
        - productType
        - contractStatus
        - effectiveDate
      properties:
        contractId:
          type: string
          format: uuid
          description: System-generated unique identifier
        contractNumber:
          type: string
          maxLength: 20
          description: Carrier-assigned policy/contract number
        carrierCode:
          type: string
          maxLength: 10
        productCode:
          type: string
          maxLength: 20
        productType:
          type: string
          enum: [FA, VA, FIA, RILA, SPIA, DIA, QLAC, MYGA]
        productName:
          type: string
        qualifiedPlanType:
          type: string
          enum: [NQ, TIRA, RIRA, SEP, SIMPLE, '401K', '403B', '457B', IIRA, PENSION]
        contractStatus:
          type: string
          enum: [PROPOSED, PENDING, ACTIVE, SURRENDERED, ANNUITIZED,
                 DEATH_CLAIM, MATURED, LAPSED, TRANSFERRED, DECLINED]
        applicationDate:
          type: string
          format: date
        issueDate:
          type: string
          format: date
        effectiveDate:
          type: string
          format: date
        maturityDate:
          type: string
          format: date
        terminationDate:
          type: string
          format: date
        terminationReason:
          type: string
        initialPremium:
          type: number
          format: decimal
        totalPremiums:
          type: number
          format: decimal
        paymentMode:
          type: string
          enum: [SINGLE, MONTHLY, QUARTERLY, SEMI_ANNUAL, ANNUAL, FLEXIBLE]
        replacementIndicator:
          type: boolean
        exchange1035Indicator:
          type: boolean
        mecIndicator:
          type: boolean
        stateOfIssue:
          type: string
          minLength: 2
          maxLength: 2
        currentValues:
          $ref: '#/components/schemas/ContractValues'
        parties:
          type: array
          items:
            $ref: '#/components/schemas/ContractParty'
        riders:
          type: array
          items:
            $ref: '#/components/schemas/Rider'

    ContractValues:
      type: object
      properties:
        valuationDate:
          type: string
          format: date
        accountValue:
          type: number
          format: decimal
        surrenderValue:
          type: number
          format: decimal
        deathBenefitValue:
          type: number
          format: decimal
        loanBalance:
          type: number
          format: decimal
        costBasis:
          type: number
          format: decimal
        gainLoss:
          type: number
          format: decimal
        surrenderChargePercent:
          type: number
          format: decimal
        freeWithdrawalAmount:
          type: number
          format: decimal
        gmwbBenefitBase:
          type: number
          format: decimal
        ytdPremiums:
          type: number
          format: decimal
        ytdWithdrawals:
          type: number
          format: decimal
        rmdRequiredAmount:
          type: number
          format: decimal

    ContractParty:
      type: object
      properties:
        roleId:
          type: string
          format: uuid
        partyId:
          type: string
          format: uuid
        roleType:
          type: string
          enum: [OWNER, JOINT_OWNER, ANNUITANT, JOINT_ANNUITANT,
                 PRIMARY_BENEFICIARY, CONTINGENT_BENEFICIARY,
                 IRREVOCABLE_BENEFICIARY, AGENT]
        firstName:
          type: string
        lastName:
          type: string
        organizationName:
          type: string
        taxIdLast4:
          type: string
          maxLength: 4
        dateOfBirth:
          type: string
          format: date
        benefitPercentage:
          type: number
          format: decimal
        relationshipToOwner:
          type: string
        effectiveDate:
          type: string
          format: date
        isActive:
          type: boolean

    WithdrawalRequest:
      type: object
      required:
        - withdrawalType
        - grossAmount
        - disbursementMethod
      properties:
        withdrawalType:
          type: string
          enum: [PARTIAL, SYSTEMATIC, RMD, FREE_WITHDRAWAL]
        grossAmount:
          type: number
          format: decimal
          minimum: 0.01
        netAmountRequested:
          type: boolean
          description: If true, grossAmount represents desired net amount
        fundSources:
          type: array
          items:
            type: object
            properties:
              fundId:
                type: string
              amount:
                type: number
                format: decimal
              percentage:
                type: number
                format: decimal
        disbursementMethod:
          type: string
          enum: [CHECK, ACH, WIRE]
        bankAccountId:
          type: string
          format: uuid
        federalWithholdingPercent:
          type: number
          format: decimal
          minimum: 0
          maximum: 100
        stateWithholdingPercent:
          type: number
          format: decimal
          minimum: 0
          maximum: 100
        effectiveDate:
          type: string
          format: date

    Rider:
      type: object
      properties:
        riderId:
          type: string
          format: uuid
        riderType:
          type: string
          enum: [GMDB, GMAB, GMIB, GMWB, GLWB, NH_WAIVER,
                 TI_WAIVER, ENHANCED_DB, RETURN_PREM]
        riderStatus:
          type: string
          enum: [ACTIVE, TERMINATED, EXERCISED, EXPIRED]
        effectiveDate:
          type: string
          format: date
        benefitBase:
          type: number
          format: decimal
        maxAnnualWithdrawalPct:
          type: number
          format: decimal
        riderChargeRate:
          type: number
          format: decimal
        lastStepUpDate:
          type: string
          format: date

    ErrorResponse:
      type: object
      properties:
        errorCode:
          type: string
        message:
          type: string
        details:
          type: array
          items:
            type: object
            properties:
              field:
                type: string
              issue:
                type: string
        traceId:
          type: string
```

### 7.1.3 Sample JSON Responses

#### GET /api/v1/contracts/{contractId}

```json
{
  "contractId": "550e8400-e29b-41d4-a716-446655440000",
  "contractNumber": "ANN-2025-001234",
  "carrierCode": "XYZ",
  "productCode": "VA-FLEX-III",
  "productType": "VA",
  "productName": "FlexAccumulator VA Series III",
  "qualifiedPlanType": "NQ",
  "contractStatus": "ACTIVE",
  "applicationDate": "2025-04-14",
  "issueDate": "2025-04-20",
  "effectiveDate": "2025-04-20",
  "maturityDate": "2060-06-15",
  "initialPremium": 100000.00,
  "totalPremiums": 100000.00,
  "paymentMode": "FLEXIBLE",
  "replacementIndicator": false,
  "exchange1035Indicator": false,
  "mecIndicator": false,
  "stateOfIssue": "CT",
  "currentValues": {
    "valuationDate": "2025-04-15",
    "accountValue": 101250.00,
    "surrenderValue": 94162.50,
    "deathBenefitValue": 101250.00,
    "loanBalance": 0.00,
    "costBasis": 100000.00,
    "gainLoss": 1250.00,
    "surrenderChargePercent": 7.00,
    "freeWithdrawalAmount": 10125.00,
    "gmwbBenefitBase": 101250.00,
    "ytdPremiums": 100000.00,
    "ytdWithdrawals": 0.00,
    "rmdRequiredAmount": null
  },
  "parties": [
    {
      "roleId": "role-001",
      "partyId": "party-001",
      "roleType": "OWNER",
      "firstName": "John",
      "lastName": "Smith",
      "taxIdLast4": "6789",
      "dateOfBirth": "1965-06-15",
      "isActive": true
    },
    {
      "roleId": "role-002",
      "partyId": "party-001",
      "roleType": "ANNUITANT",
      "firstName": "John",
      "lastName": "Smith",
      "taxIdLast4": "6789",
      "dateOfBirth": "1965-06-15",
      "isActive": true
    },
    {
      "roleId": "role-003",
      "partyId": "party-002",
      "roleType": "PRIMARY_BENEFICIARY",
      "firstName": "Jane",
      "lastName": "Smith",
      "taxIdLast4": "4321",
      "benefitPercentage": 100.00,
      "relationshipToOwner": "SPOUSE",
      "isActive": true
    }
  ],
  "riders": [
    {
      "riderId": "rider-001",
      "riderType": "GMWB",
      "riderStatus": "ACTIVE",
      "effectiveDate": "2025-04-20",
      "benefitBase": 101250.00,
      "maxAnnualWithdrawalPct": 5.00,
      "riderChargeRate": 0.95,
      "lastStepUpDate": null
    }
  ]
}
```

## 7.2 GraphQL Schema for Annuity Queries

```graphql
type Query {
  contract(contractId: ID!): Contract
  contracts(
    filter: ContractFilter
    pagination: PaginationInput
    sort: ContractSortInput
  ): ContractConnection!

  party(partyId: ID!): Party
  searchParties(criteria: PartySearchInput!): PartyConnection!

  product(productCode: String!): Product
  products(productType: ProductType): [Product!]!

  fund(fundId: String!): Fund
  funds(category: FundCategory): [Fund!]!

  agentBook(agentId: String!): AgentBookConnection!
}

type Mutation {
  submitApplication(input: ApplicationInput!): ApplicationResult!
  processWithdrawal(contractId: ID!, input: WithdrawalInput!): TransactionResult!
  processSurrender(contractId: ID!, input: SurrenderInput!): TransactionResult!
  transferFunds(contractId: ID!, input: FundTransferInput!): TransactionResult!
  changeAllocations(contractId: ID!, input: AllocationInput!): AllocationResult!
  changeBeneficiary(contractId: ID!, input: BeneficiaryInput!): BeneficiaryResult!
  electAnnuitization(contractId: ID!, input: AnnuitizationInput!): AnnuitizationResult!
  fileDeathClaim(contractId: ID!, input: DeathClaimInput!): ClaimResult!
}

type Contract {
  contractId: ID!
  contractNumber: String!
  carrierCode: String!
  product: Product!
  productType: ProductType!
  qualifiedPlanType: QualifiedPlanType!
  contractStatus: ContractStatus!
  applicationDate: Date
  issueDate: Date
  effectiveDate: Date!
  maturityDate: Date
  terminationDate: Date
  initialPremium: Decimal!
  totalPremiums: Decimal!
  paymentMode: PaymentMode
  stateOfIssue: String!

  currentValues: ContractValues!
  valueHistory(
    startDate: Date!
    endDate: Date!
    frequency: ValuationFrequency
  ): [ContractValues!]!

  parties: [ContractParty!]!
  owner: ContractParty!
  annuitant: ContractParty!
  beneficiaries: [ContractParty!]!
  agent: ContractParty

  allocations: [SubAccountAllocation!]!
  positions: [SubAccountPosition!]!
  indexStrategies: [IndexStrategy!]!

  riders: [Rider!]!

  transactions(
    filter: TransactionFilter
    pagination: PaginationInput
  ): TransactionConnection!

  payout: Payout

  surrenderSchedule: [SurrenderScheduleEntry!]!
}

type ContractValues {
  valuationDate: Date!
  accountValue: Decimal!
  surrenderValue: Decimal!
  deathBenefitValue: Decimal!
  loanBalance: Decimal
  costBasis: Decimal!
  gainLoss: Decimal!
  surrenderChargePercent: Decimal
  freeWithdrawalAmount: Decimal
  gmwbBenefitBase: Decimal
  gmwbRemainingBenefit: Decimal
  gmibBenefitBase: Decimal
  gmabGuaranteeValue: Decimal
  ytdPremiums: Decimal!
  ytdWithdrawals: Decimal!
  rmdRequiredAmount: Decimal
}

type ContractParty {
  roleId: ID!
  party: Party!
  roleType: RoleType!
  benefitPercentage: Decimal
  benefitType: BenefitDistributionType
  relationshipToOwner: String
  effectiveDate: Date!
  isActive: Boolean!
}

type Party {
  partyId: ID!
  partyType: PartyType!
  firstName: String
  lastName: String
  organizationName: String
  taxIdLast4: String
  dateOfBirth: Date
  gender: Gender
  residenceState: String
  addresses: [Address!]!
  phones: [Phone!]!
  emails: [Email!]!
  contracts: [Contract!]!
}

type SubAccountAllocation {
  fund: Fund!
  allocationType: AllocationType!
  allocationPercent: Decimal!
  effectiveDate: Date!
}

type SubAccountPosition {
  fund: Fund!
  valuationDate: Date!
  units: Decimal!
  unitValue: Decimal!
  marketValue: Decimal!
  costBasis: Decimal!
  gainLoss: Decimal!
}

type IndexStrategy {
  strategyId: ID!
  strategyType: String!
  indexName: String!
  allocationPercent: Decimal!
  allocatedAmount: Decimal!
  capRate: Decimal
  participationRate: Decimal
  spreadRate: Decimal
  floorRate: Decimal
  bufferRate: Decimal
  termMonths: Int!
  termStartDate: Date!
  termEndDate: Date!
  interimValue: Decimal
}

type Rider {
  riderId: ID!
  riderType: RiderType!
  riderStatus: RiderStatus!
  effectiveDate: Date!
  terminationDate: Date
  benefitBase: Decimal
  riderChargeRate: Decimal!
  maxAnnualWithdrawalPct: Decimal
  singleLifePct: Decimal
  jointLifePct: Decimal
  lastStepUpDate: Date
  excessWithdrawalFlag: Boolean!
}

type Fund {
  fundId: String!
  fundName: String!
  cusip: String
  ticker: String
  category: FundCategory!
  latestNav: Decimal
  navDate: Date
  expenseRatio: Decimal
  inceptionDate: Date
}

enum ProductType { FA VA FIA RILA SPIA DIA QLAC MYGA }
enum QualifiedPlanType { NQ TIRA RIRA SEP SIMPLE K401 B403 B457 IIRA }
enum ContractStatus { PROPOSED PENDING ACTIVE SURRENDERED ANNUITIZED DEATH_CLAIM MATURED LAPSED TRANSFERRED }
enum RoleType { OWNER JOINT_OWNER ANNUITANT JOINT_ANNUITANT PRIMARY_BENEFICIARY CONTINGENT_BENEFICIARY IRREVOCABLE_BENEFICIARY AGENT }
enum RiderType { GMDB GMAB GMIB GMWB GLWB NH_WAIVER TI_WAIVER ENHANCED_DB RETURN_PREM }
enum RiderStatus { ACTIVE TERMINATED EXERCISED EXPIRED }
enum PaymentMode { SINGLE MONTHLY QUARTERLY SEMI_ANNUAL ANNUAL FLEXIBLE }
enum PartyType { INDIVIDUAL ORGANIZATION TRUST }
enum Gender { M F U }
enum AllocationType { CURRENT FUTURE_PREMIUM }
enum FundCategory { EQUITY FIXED_INCOME BALANCED MONEY_MARKET INTERNATIONAL SPECIALTY INDEX }

scalar Date
scalar Decimal

input ContractFilter {
  contractStatus: [ContractStatus!]
  productType: [ProductType!]
  qualifiedPlanType: [QualifiedPlanType!]
  issueDateFrom: Date
  issueDateTo: Date
  ownerLastName: String
  ownerTaxIdLast4: String
  agentId: String
}

input PaginationInput {
  first: Int
  after: String
  last: Int
  before: String
}
```

---

# 8. File-Based Data Formats

## 8.1 Flat File Formats for Batch Processing

Annuity administration systems rely heavily on batch file exchanges for daily operations:

### 8.1.1 Daily Position File (Carrier → Distributor)

**Format:** Fixed-width or pipe-delimited

```
HDR|CARRIER_XYZ|20250415|POSITION|V2.0|
DTL|ANN-2025-001234|SMITH|JOHN|123456789|VA|NQ|ACTIVE|20250415|101250.00|94162.50|101250.00|0.00|100000.00|1250.00|
DTL|ANN-2024-005678|JONES|MARY|987654321|FIA|TIRA|ACTIVE|20250415|275000.00|261250.00|275000.00|0.00|250000.00|25000.00|
TRL|2|376250.00|
```

#### Header Record Layout

| Position | Length | Field | Description |
|---|---|---|---|
| 1-3 | 3 | Record Type | "HDR" |
| 5-15 | 11 | Carrier Code | Sending carrier identifier |
| 17-24 | 8 | File Date | YYYYMMDD |
| 26-35 | 10 | File Type | POSITION, COMMISSION, ACTIVITY |
| 37-40 | 4 | Version | File format version |

#### Detail Record Layout

| Position | Length | Field | Description |
|---|---|---|---|
| 1-3 | 3 | Record Type | "DTL" |
| 5-24 | 20 | Policy Number | Contract number |
| 26-65 | 40 | Owner Last Name | Owner surname |
| 67-96 | 30 | Owner First Name | Owner first name |
| 98-106 | 9 | Owner SSN | Social Security Number |
| 108-111 | 4 | Product Type | FA, VA, FIA, RILA |
| 113-114 | 2 | Qual Plan Type | NQ, IR, RR, SP, etc. |
| 116-125 | 10 | Contract Status | Active, Surrendered, etc. |
| 127-134 | 8 | Valuation Date | YYYYMMDD |
| 136-149 | 14 | Account Value | 2 implied decimals |
| 151-164 | 14 | Surrender Value | 2 implied decimals |
| 166-179 | 14 | Death Benefit Value | 2 implied decimals |
| 181-194 | 14 | Loan Balance | 2 implied decimals |
| 196-209 | 14 | Cost Basis | 2 implied decimals |
| 211-224 | 14 | Gain/Loss | 2 implied decimals |

#### Trailer Record Layout

| Position | Length | Field | Description |
|---|---|---|---|
| 1-3 | 3 | Record Type | "TRL" |
| 5-12 | 8 | Record Count | Number of DTL records |
| 14-27 | 14 | Total Account Value | Control total |

## 8.2 NACHA / ACH File Format

Annuity premium collections and benefit disbursements commonly flow through the ACH network using the NACHA file format.

### 8.2.1 ACH File Structure

```
101 0740000010123456789250415094101A094101CARRIER XYZ            FIRST BANK
5200CARRIER XYZ INSURANCE       1234567890PPDPREMIUM   250415   1074000010000001
62207400001012345678901234567  0000050000123456789      JOHN SMITH            0074000010000001
62207400001098765432109876543  0000025000987654321      MARY JONES            0074000010000002
820000000200148000020000000000000000007500001234567890                   074000010000001
9000001000001000000020014800002000000000000000000750000
```

### 8.2.2 NACHA Record Types

| Record | Type | Description |
|---|---|---|
| **File Header (1)** | 1 | File-level control (origin, destination, date) |
| **Batch Header (5)** | 5 | Batch-level control (company, SEC code, entry description) |
| **Entry Detail (6)** | 6 | Individual ACH entry (account, routing, amount) |
| **Addenda (7)** | 7 | Additional info (payment description, etc.) |
| **Batch Control (8)** | 8 | Batch totals |
| **File Control (9)** | 9 | File totals |

### 8.2.3 Key SEC Codes for Annuity Transactions

| SEC Code | Name | Use in Annuities |
|---|---|---|
| **PPD** | Prearranged Payment and Deposit | Systematic premium collections from individual bank accounts |
| **CCD** | Corporate Credit or Debit | Corporate/trust annuity premiums |
| **CTX** | Corporate Trade Exchange | Premium payments with addenda detail |
| **WEB** | Internet-Initiated Entry | Online premium payments |
| **TEL** | Telephone-Initiated Entry | Phone-authorized premium payments |

### 8.2.4 Entry Detail Record (Type 6) Layout for Annuity Premium

| Position | Length | Field | Content |
|---|---|---|---|
| 1 | 1 | Record Type | "6" |
| 2-3 | 2 | Transaction Code | 22=Checking Credit, 27=Checking Debit, 32=Savings Credit, 37=Savings Debit |
| 4-11 | 8 | RDFI Routing Number | Receiving bank routing |
| 12 | 1 | Check Digit | Routing check digit |
| 13-29 | 17 | DFI Account Number | Bank account number |
| 30-39 | 10 | Amount | In cents (no decimal) |
| 40-54 | 15 | Individual ID | Policy number |
| 55-76 | 22 | Individual Name | Owner name |
| 77-78 | 2 | Discretionary Data | Company use |
| 79 | 1 | Addenda Indicator | 0 or 1 |
| 80-94 | 15 | Trace Number | Unique trace |

## 8.3 IRS Electronic Filing Formats

### 8.3.1 Form 1099-R (Distributions from Annuities)

Annuity carriers must file 1099-R for all distributions, including:
- Partial and full surrenders
- Death benefit payments
- Annuity income payments
- RMDs
- 1035 exchange proceeds (to the extent taxable)

#### IRS FIRE System Record Layout (Form 1099-R)

| Field | Position | Length | Description |
|---|---|---|---|
| Record Type | 1 | 1 | "B" for payee record |
| Payment Year | 2-5 | 4 | Tax year |
| Corrected Return Indicator | 6 | 1 | G=Corrected, blank=Original |
| Payer's TIN | 12-20 | 9 | Carrier's EIN |
| Payee's TIN | 21-29 | 9 | Recipient's SSN/EIN |
| Payer's Account Number | 30-49 | 20 | Policy number |
| Gross Distribution (Box 1) | 55-66 | 12 | Total distribution amount |
| Taxable Amount (Box 2a) | 67-78 | 12 | Taxable portion |
| Capital Gain (Box 3) | 79-90 | 12 | Capital gain portion |
| Federal Tax Withheld (Box 4) | 91-102 | 12 | Federal withholding |
| Employee Contributions (Box 5) | 103-114 | 12 | Cost basis recovered |
| Distribution Code (Box 7) | 145-146 | 2 | See codes below |
| IRA/SEP/SIMPLE Indicator | 147 | 1 | 1=IRA/SEP/SIMPLE |
| Total Distribution Indicator | 170 | 1 | 1=Total distribution |
| Percentage of Total Distribution | 171-174 | 4 | % of total distribution |
| State Tax Withheld | 176-187 | 12 | State income tax withheld |
| State Code | 188-189 | 2 | State FIPS code |

#### Distribution Codes (Box 7) Relevant to Annuities

| Code | Description |
|---|---|
| 1 | Early distribution (before age 59½), no known exception |
| 2 | Early distribution, exception applies |
| 3 | Disability |
| 4 | Death |
| 5 | Prohibited transaction |
| 6 | Section 1035 exchange |
| 7 | Normal distribution |
| D | Annuity payments from nonqualified annuities subject to Section 72(q) |
| G | Direct rollover |
| H | Direct rollover from Roth 401(k)/403(b) to Roth IRA |
| T | Roth IRA distribution (code T applies when known) |

### 8.3.2 Form 5498 (IRA Contributions / Fair Market Value)

Carriers report IRA annuity contributions and year-end fair market value:

| Field | Box | Description |
|---|---|---|
| IRA Contributions | Box 1 | Traditional IRA contributions received |
| Rollover Contributions | Box 2 | Rollover amounts received |
| Roth IRA Contributions | Box 10 | Roth IRA contributions |
| Fair Market Value | Box 5 | Year-end FMV of the IRA annuity |
| RMD Amount | Box 12b | Required minimum distribution for next year |
| RMD Date | Box 12a | Date by which RMD must be taken |
| Postponed/Late Contributions | Box 13a-c | Catch-up, SEP, SIMPLE contributions |
| Repayment Amount | Box 14a | Qualified disaster distribution repayment |

## 8.4 State Premium Tax Filing Formats

Each state has slightly different premium tax filing requirements. Common elements:

### 8.4.1 Standard Premium Tax Return Fields

| Field | Description |
|---|---|
| NAIC Company Code | 5-digit NAIC identifier |
| Reporting Year | Tax year |
| State Code | 2-letter state abbreviation |
| Line of Business | Life, Annuity (Qualified), Annuity (Non-Qualified) |
| Gross Premiums | Total premiums received from state residents |
| Return Premiums | Premiums returned (cancellations, free-look) |
| Exempt Premiums | Tax-exempt premiums (qualified plan rollovers in some states) |
| Net Taxable Premiums | Premiums subject to tax |
| Tax Rate | State-specific rate (typically 0.5% to 3.5%) |
| Gross Tax | Calculated premium tax |
| Credits / Offsets | Retaliatory tax credits, guaranty fund credits |
| Net Tax Due | Final amount payable |

### 8.4.2 Compact States vs. Non-Compact

Many states participate in the Insurance Compact, which standardizes product filing but not premium tax. Premium tax rates vary significantly:

| State | Annuity Premium Tax Rate | Notes |
|---|---|---|
| CA | 2.35% | |
| CT | 1.50% | |
| FL | 1.75% | Annuity considerations only |
| IL | 0.50% | Lower rate for annuities |
| NY | 1.50% (retaliatory) | |
| TX | 1.75% | |
| WY | 0.75% | |

## 8.5 Commission File Formats

### 8.5.1 Commission Statement File Layout

```
HDR|CARRIER_XYZ|20250415|COMMISSION|V1.5|
DTL|ANN-2025-001234|AGT-44521|FY|250415|100000.00|0.0600|6000.00|6000.00|SMITH|JOHN|VA-FLEX-III|NQ|
DTL|ANN-2024-005678|AGT-33210|TR|250415|275000.00|0.0025|687.50|687.50|JONES|MARY|FIA-PROTECT|TIRA|
TRL|2|6687.50|
```

| Field | Position | Description |
|---|---|---|
| Record Type | 1 | HDR/DTL/TRL |
| Policy Number | 2 | Contract number |
| Agent ID | 3 | Agent/rep identifier |
| Commission Type | 4 | FY=First Year, RN=Renewal, TR=Trail, BN=Bonus |
| Commission Date | 5 | Date earned (YYMMDD) |
| Base Amount | 6 | Premium or account value |
| Commission Rate | 7 | Rate applied |
| Gross Commission | 8 | Gross commission amount |
| Net Commission | 9 | Net after adjustments |
| Owner Last Name | 10 | Contract owner |
| Owner First Name | 11 | Contract owner |
| Product Code | 12 | Product identifier |
| Qualified Type | 13 | NQ, TIRA, RIRA, etc. |

---

# 9. Data Dictionary

## 9.1 Organization

The data dictionary is organized by domain area. Each entry includes: field name, description, data type, length/precision, valid values, source system mapping, ACORD mapping, and key business rules.

## 9.2 Contract / Policy Domain

| # | Field Name | Description | Data Type | Length | Valid Values | ACORD Mapping | Business Rules |
|---|---|---|---|---|---|---|---|
| 1 | contract_id | System unique identifier | UUID | 36 | Auto-generated | N/A | Immutable after creation |
| 2 | contract_number | Carrier-assigned policy number | VARCHAR | 20 | Carrier format | Policy.PolNumber | Unique per carrier; immutable |
| 3 | carrier_code | Issuing insurance carrier | VARCHAR | 10 | Carrier master | Policy.CarrierCode | Must exist in carrier master |
| 4 | product_code | Product identifier | VARCHAR | 20 | Product master | Policy.ProductCode | Must exist in product master |
| 5 | product_type | Annuity product category | VARCHAR | 4 | FA, VA, FIA, RILA, SPIA, DIA, QLAC, MYGA | Annuity.AnnuityProduct (tc) | Drives downstream processing rules |
| 6 | qualified_plan_type | Tax qualification type | VARCHAR | 10 | NQ, TIRA, RIRA, SEP, SIMPLE, 401K, 403B, 457B, IIRA, PENSION, ROTH401K | Annuity.QualPlanType (tc) | Governs contribution limits, RMD rules, tax treatment |
| 7 | contract_status | Current lifecycle status | VARCHAR | 20 | PROPOSED, PENDING, ACTIVE, SURRENDERED, ANNUITIZED, DEATH_CLAIM, MATURED, LAPSED, TRANSFERRED, DECLINED, FREE_LOOK | Policy.PolicyStatus (tc) | Valid transitions enforced by state machine |
| 8 | application_date | Date application was signed | DATE | | Valid date ≤ today | ApplicationInfo.SignedDate | Required for new business |
| 9 | submission_date | Date application was submitted | DATE | | Valid date ≤ today | ApplicationInfo.SubmissionDate | Must be ≥ application_date |
| 10 | issue_date | Date contract was issued | DATE | | Valid date | N/A | Set when status changes to ACTIVE |
| 11 | effective_date | Contract effective date | DATE | | Valid date | Policy.EffDate | Usually = issue_date; can differ for replacements |
| 12 | maturity_date | Contract maturity date | DATE | | Future date | Annuity.MaturityDate | Typically owner age 95-115 |
| 13 | termination_date | Date contract ended | DATE | | Valid date or NULL | Policy.TermDate | NULL while active |
| 14 | termination_reason | Reason contract terminated | VARCHAR | 30 | SURRENDER, DEATH, MATURITY, LAPSE, TRANSFER, DECLINE, FREE_LOOK_CANCEL | N/A | Required when termination_date is set |
| 15 | initial_premium | First premium amount | DECIMAL | 18,2 | > 0 | Annuity.InitPaymentAmt | Subject to product min/max limits |
| 16 | total_premiums | Cumulative premiums paid | DECIMAL | 18,2 | ≥ initial_premium | N/A | Running total, updated on each premium |
| 17 | payment_mode | Premium payment frequency | VARCHAR | 10 | SINGLE, MONTHLY, QUARTERLY, SEMI_ANNUAL, ANNUAL, FLEXIBLE | Policy.PaymentMode (tc) | SINGLE for SPIAs and MYGAs |
| 18 | planned_periodic_premium | Planned recurring premium | DECIMAL | 18,2 | ≥ 0 | Policy.PaymentAmt | NULL for single-premium products |
| 19 | free_look_end_date | End of free-look period | DATE | | effective_date + state free-look days | N/A | Typically 10-30 days per state |
| 20 | replacement_ind | Replaces existing coverage | BOOLEAN | | true/false | ApplicationInfo.ReplacementInd | Triggers replacement form requirements |
| 21 | exchange_1035_ind | Funded via 1035 exchange | BOOLEAN | | true/false | N/A | Affects cost basis carryover |
| 22 | mec_ind | Modified Endowment Contract | BOOLEAN | | true/false | N/A | Affects tax treatment of distributions |
| 23 | state_of_issue | Issuing state jurisdiction | CHAR | 2 | Valid US state code | Policy.Jurisdiction (tc) | Drives regulatory rules, tax withholding |
| 24 | currency_code | Currency | CHAR | 3 | USD (primarily) | Holding.CurrencyTypeCode (tc) | Default USD for domestic |

## 9.3 Party / Person Domain

| # | Field Name | Description | Data Type | Length | Valid Values | ACORD Mapping | Business Rules |
|---|---|---|---|---|---|---|---|
| 25 | party_id | Party unique ID | UUID | 36 | Auto-generated | Party.id | Immutable |
| 26 | party_type | Individual or organization | VARCHAR | 12 | INDIVIDUAL, ORGANIZATION, TRUST | PersonOrOrganization | Drives required field validation |
| 27 | prefix | Name prefix | VARCHAR | 10 | Mr., Mrs., Ms., Dr. | Person.Prefix | Optional |
| 28 | first_name | First/given name | VARCHAR | 50 | Non-empty for INDIVIDUAL | Person.FirstName | Required for individuals |
| 29 | middle_name | Middle name | VARCHAR | 50 | | Person.MiddleName | Optional |
| 30 | last_name | Family/surname | VARCHAR | 80 | Non-empty for INDIVIDUAL | Person.LastName | Required for individuals |
| 31 | suffix | Name suffix | VARCHAR | 10 | Jr., Sr., III, IV | Person.Suffix | Optional |
| 32 | organization_name | Organization name | VARCHAR | 150 | Non-empty for ORG/TRUST | Organization.OrgForm | Required for orgs/trusts |
| 33 | org_type | Organization form | VARCHAR | 20 | CORPORATION, LLC, PARTNERSHIP, TRUST, ESTATE, CHARITY | Organization.OrgForm (tc) | Required for org/trust |
| 34 | tax_id_type | Type of tax ID | VARCHAR | 5 | SSN, EIN, ITIN | GovtIDTC (tc) | SSN for individuals, EIN for orgs |
| 35 | tax_id | Tax identification number | VARCHAR | 11 | 9 digits for SSN/EIN | Party.GovtID | Encrypted at rest; validated via checksum |
| 36 | date_of_birth | Date of birth | DATE | | Valid past date | Person.BirthDate | Required for individuals; used for age calculations |
| 37 | date_of_death | Date of death | DATE | | Valid date or NULL | N/A | Set upon death notification |
| 38 | gender | Gender | CHAR | 1 | M, F, U | Person.Gender (tc) | Required for mortality-based products |
| 39 | citizenship | Country of citizenship | CHAR | 2 | ISO 3166-1 alpha-2 | Person.Citizenship | Affects tax withholding (NRA rules) |
| 40 | residence_state | State of residence | CHAR | 2 | US state codes | Address.AddressStateTC | Determines state regulatory jurisdiction |
| 41 | residence_country | Country of residence | CHAR | 2 | ISO 3166-1 alpha-2 | Address.Country | Default US |
| 42 | marital_status | Marital status | VARCHAR | 15 | SINGLE, MARRIED, DIVORCED, WIDOWED, DOMESTIC_PARTNER | Client.MaritalStat (tc) | Relevant for spousal continuation, beneficiary defaults |
| 43 | email_primary | Primary email | VARCHAR | 100 | Valid email format | EMailAddress.AddrLine | Required for e-delivery |
| 44 | phone_primary | Primary phone | VARCHAR | 15 | Valid phone format | Phone.DialNumber | 10+ digits |

## 9.4 Contract Role Domain

| # | Field Name | Description | Data Type | Length | Valid Values | ACORD Mapping | Business Rules |
|---|---|---|---|---|---|---|---|
| 45 | contract_role_id | Role assignment ID | UUID | 36 | Auto-generated | Relation.id | |
| 46 | role_type | Type of role on contract | VARCHAR | 25 | OWNER, JOINT_OWNER, ANNUITANT, JOINT_ANNUITANT, PRIMARY_BENEFICIARY, CONTINGENT_BENEFICIARY, IRREVOCABLE_BENEFICIARY, AGENT, PAYOR, TRUSTEE, CUSTODIAN, POWER_OF_ATTORNEY | Relation.RelationRoleCode (tc) | Every contract must have OWNER and ANNUITANT |
| 47 | benefit_percentage | Beneficiary share | DECIMAL | 8,5 | 0.00000-1.00000 | Relation.InterestPercent | Primary benes must sum to 1.0; contingents must sum to 1.0 |
| 48 | benefit_type | Benefit distribution method | VARCHAR | 15 | PER_STIRPES, PER_CAPITA, EQUAL_SHARE | N/A | Per stirpes: share passes to descendants |
| 49 | relationship_to_owner | Relationship description | VARCHAR | 20 | SPOUSE, CHILD, PARENT, SIBLING, TRUST, ESTATE, CHARITY, OTHER | N/A | SPOUSE enables spousal continuation on death |

## 9.5 Financial Values Domain

| # | Field Name | Description | Data Type | Length | Valid Values | ACORD Mapping | Business Rules |
|---|---|---|---|---|---|---|---|
| 50 | account_value | Total accumulation value | DECIMAL | 18,2 | ≥ 0 | Holding.AccountValue | Sum of all sub-account values + fixed account |
| 51 | surrender_value | Net value if surrendered today | DECIMAL | 18,2 | ≥ 0 | Holding.CashSurrValue | account_value - surrender_charge ± MVA |
| 52 | death_benefit_value | Current death benefit | DECIMAL | 18,2 | ≥ 0 | N/A | MAX(account_value, GMDB guarantees) |
| 53 | loan_balance | Outstanding policy loan | DECIMAL | 18,2 | ≥ 0 | Policy.LoanAmt | Applicable to NQ contracts with loan provision |
| 54 | cost_basis | Investment in the contract | DECIMAL | 18,2 | ≥ 0 | N/A | Premiums paid - nontaxable amounts received |
| 55 | gain_loss | Unrealized gain or loss | DECIMAL | 18,2 | Any | N/A | account_value - cost_basis |
| 56 | surrender_charge_pct | Current surrender charge rate | DECIMAL | 8,5 | 0.00000-0.20000 | N/A | Declines per surrender schedule |
| 57 | surrender_charge_amt | Dollar amount of surrender charge | DECIMAL | 18,2 | ≥ 0 | N/A | account_value × surrender_charge_pct (approximately) |
| 58 | free_withdrawal_amt | Penalty-free withdrawal available | DECIMAL | 18,2 | ≥ 0 | N/A | Typically 10% of account_value annually |
| 59 | gmwb_benefit_base | GMWB guaranteed base | DECIMAL | 18,2 | ≥ 0 | N/A | Subject to step-up and excess WD reduction |
| 60 | gmwb_remaining_benefit | Remaining GMWB lifetime amount | DECIMAL | 18,2 | ≥ 0 | N/A | Decreases with each withdrawal |
| 61 | gmib_benefit_base | GMIB guaranteed base | DECIMAL | 18,2 | ≥ 0 | N/A | Determines guaranteed income amount |
| 62 | gmab_guarantee_value | GMAB guaranteed minimum | DECIMAL | 18,2 | ≥ 0 | N/A | Guaranteed return of premium at specified date |
| 63 | ytd_premiums | Year-to-date premiums | DECIMAL | 18,2 | ≥ 0 | N/A | Resets annually |
| 64 | ytd_withdrawals | Year-to-date withdrawals | DECIMAL | 18,2 | ≥ 0 | N/A | Resets annually |
| 65 | rmd_required_amount | Required minimum distribution | DECIMAL | 18,2 | ≥ 0 or NULL | N/A | NULL for NQ; calculated for qualified plans age 73+ |

## 9.6 Investment / Allocation Domain

| # | Field Name | Description | Data Type | Length | Valid Values | ACORD Mapping | Business Rules |
|---|---|---|---|---|---|---|---|
| 66 | fund_id | Investment fund identifier | VARCHAR | 20 | Fund master | SubAccount.FundID | Must exist in fund master |
| 67 | cusip | CUSIP number | CHAR | 9 | Valid CUSIP | SubAccount.CUSIP | 9-character with check digit |
| 68 | ticker | Fund ticker symbol | VARCHAR | 10 | Valid ticker | N/A | Used for market data lookup |
| 69 | allocation_pct | Allocation percentage | DECIMAL | 8,5 | 0.00000-1.00000 | SubAccount.AllocPercent | All allocations per type must sum to 1.0 |
| 70 | units | Number of fund units held | DECIMAL | 18,6 | ≥ 0 | SubAccount.Units | Updated on each transaction |
| 71 | unit_value | NAV per unit | DECIMAL | 12,6 | > 0 | SubAccount.UnitValue | From daily fund pricing feed |
| 72 | market_value | Sub-account market value | DECIMAL | 18,2 | ≥ 0 | SubAccount.SubAcctValue | units × unit_value |
| 73 | cap_rate | Index strategy cap | DECIMAL | 8,5 | 0.00000-1.00000 | OLifEExtension | FIA/RILA only; set at term start |
| 74 | participation_rate | Index strategy participation | DECIMAL | 8,5 | 0.00000-3.00000 | OLifEExtension | Can exceed 100% |
| 75 | spread_rate | Index strategy spread | DECIMAL | 8,5 | 0.00000-0.10000 | OLifEExtension | Deducted from index return |
| 76 | floor_rate | Minimum return guarantee | DECIMAL | 8,5 | -0.10000-0.03000 | OLifEExtension | 0% for FIA; negative for RILA |
| 77 | buffer_rate | Loss absorption buffer | DECIMAL | 8,5 | 0.00000-0.30000 | OLifEExtension | RILA feature; carrier absorbs first N% loss |

## 9.7 Transaction Domain

| # | Field Name | Description | Data Type | Length | Valid Values | ACORD Mapping | Business Rules |
|---|---|---|---|---|---|---|---|
| 78 | transaction_id | Unique transaction ID | UUID | 36 | Auto-generated | N/A | Immutable |
| 79 | transaction_type | Category of transaction | VARCHAR | 25 | PREMIUM, PARTIAL_WITHDRAWAL, FULL_SURRENDER, DEATH_BENEFIT, SUB_ACCT_TRANSFER, FEE, INTEREST_CREDIT, LOAN_ADVANCE, LOAN_REPAYMENT, ANNUITY_PAYMENT, RMD, 1035_EXCHANGE, BONUS_CREDIT, MVA_ADJUSTMENT, RIDER_CHARGE | FinancialActivity.FinActivityType (tc) | Determines processing logic |
| 80 | transaction_status | Processing status | VARCHAR | 15 | PENDING, PROCESSING, COMPLETED, REVERSED, REJECTED | N/A | State machine governs transitions |
| 81 | gross_amount | Gross transaction amount | DECIMAL | 18,2 | Non-zero | FinancialActivity.FinActivityGrossAmt | Positive for credits, negative for debits |
| 82 | net_amount | Net amount after deductions | DECIMAL | 18,2 | | FinancialActivity.FinActivityAmt | gross - surrender_charge - withholding |
| 83 | surrender_charge | Surrender charge deducted | DECIMAL | 18,2 | ≥ 0 | N/A | Based on contract surrender schedule |
| 84 | mva_adjustment | Market value adjustment | DECIMAL | 18,2 | Any | N/A | Positive or negative; fixed annuity feature |
| 85 | federal_withholding | Federal tax withheld | DECIMAL | 18,2 | ≥ 0 | N/A | Per W-4P election or 20% mandatory (eligible rollover) |
| 86 | state_withholding | State tax withheld | DECIMAL | 18,2 | ≥ 0 | N/A | Per state mandatory withholding rules |
| 87 | taxable_amount | Taxable portion | DECIMAL | 18,2 | ≥ 0 | N/A | LIFO for NQ; fully taxable for qualified |
| 88 | exclusion_ratio | Tax exclusion ratio | DECIMAL | 8,5 | 0.00000-1.00000 | N/A | For annuity payments under Sec 72 |
| 89 | disbursement_method | How funds are sent | VARCHAR | 10 | CHECK, ACH, WIRE | N/A | ACH requires validated bank account |
| 90 | effective_date | Transaction effective date | DATE | | Valid date | FinancialActivity.FinActivityDate | May be retroactive |
| 91 | process_date | Date system processed | DATE | | Valid date | N/A | System-assigned |

## 9.8 Rider / Benefit Domain

| # | Field Name | Description | Data Type | Length | Valid Values | ACORD Mapping | Business Rules |
|---|---|---|---|---|---|---|---|
| 92 | rider_type | Type of living/death benefit | VARCHAR | 10 | GMDB, GMAB, GMIB, GMWB, GLWB, NH_WAIVER, TI_WAIVER, ENHANCED_DB, RETURN_PREM | Rider.RiderTypeCode (tc) | Product-dependent availability |
| 93 | rider_status | Current rider status | VARCHAR | 15 | ACTIVE, TERMINATED, EXERCISED, EXPIRED | Rider.RiderStatus (tc) | EXERCISED = benefit activated |
| 94 | benefit_base | Guaranteed benefit base amount | DECIMAL | 18,2 | ≥ 0 | Rider.BenefitBaseAmt | Subject to step-up and proportional reduction |
| 95 | rollup_rate | Deferral bonus rate | DECIMAL | 8,5 | 0.00000-0.10000 | OLifEExtension | Compounds during deferral period |
| 96 | max_annual_wd_pct | Max annual withdrawal % | DECIMAL | 8,5 | 0.00000-0.10000 | OLifEExtension | Age-banded; higher for older annuitants |
| 97 | rider_charge_rate | Annual rider charge | DECIMAL | 8,5 | 0.00000-0.03000 | Rider.RiderFee | Deducted from account value or benefit base |
| 98 | excess_withdrawal_flag | Excess withdrawal occurred | BOOLEAN | | true/false | N/A | If true, benefit base reduced proportionally |

## 9.9 Address / Contact Domain

| # | Field Name | Description | Data Type | Length | Valid Values | ACORD Mapping | Business Rules |
|---|---|---|---|---|---|---|---|
| 99 | address_type | Type of address | VARCHAR | 15 | RESIDENTIAL, MAILING, BUSINESS | Address.AddressTypeCode (tc) | At least one required |
| 100 | line_1 | Street address | VARCHAR | 100 | Non-empty | Address.Line1 | Required; USPS standardized |
| 101 | city | City | VARCHAR | 50 | Non-empty | Address.City | Required |
| 102 | state_code | State/province | CHAR | 2 | Valid code | Address.AddressStateTC (tc) | Required; must be valid state |
| 103 | postal_code | ZIP/postal code | VARCHAR | 10 | 5 or 9 digit ZIP | Address.Zip | Validated against USPS |
| 104 | country_code | Country | CHAR | 2 | ISO 3166-1 | Address.Country | Default US |

## 9.10 Agent / Producer Domain

| # | Field Name | Description | Data Type | Length | Valid Values | ACORD Mapping | Business Rules |
|---|---|---|---|---|---|---|---|
| 105 | agent_id | Internal agent identifier | VARCHAR | 20 | Agent master | Producer.CarrierAppointment.CompanyProducerID | Must be appointed with carrier |
| 106 | npn | National Producer Number | VARCHAR | 10 | Valid NPN | N/A | NIPR-verified |
| 107 | agent_first_name | Agent first name | VARCHAR | 50 | | Person.FirstName | |
| 108 | agent_last_name | Agent last name | VARCHAR | 80 | | Person.LastName | |
| 109 | bd_firm_id | Broker-dealer firm ID | VARCHAR | 10 | | N/A | NSCC participant number |
| 110 | ria_firm_id | RIA firm ID | VARCHAR | 10 | | N/A | SEC/state registration |
| 111 | commission_split_pct | Agent commission split | DECIMAL | 8,5 | 0-1.0 | N/A | Multiple agents may split |
| 112 | license_state | State of licensure | CHAR | 2 | Valid state | N/A | Must hold state annuity license |
| 113 | series_6_ind | FINRA Series 6 | BOOLEAN | | true/false | N/A | Required for VA sales |
| 114 | series_65_ind | FINRA Series 65 | BOOLEAN | | true/false | N/A | Required for fee-based advisory |

## 9.11 Payout / Annuitization Domain

| # | Field Name | Description | Data Type | Length | Valid Values | ACORD Mapping | Business Rules |
|---|---|---|---|---|---|---|---|
| 115 | payout_type | Income option selected | VARCHAR | 25 | LIFE_ONLY, LIFE_WITH_PERIOD_CERTAIN, JOINT_AND_SURVIVOR, PERIOD_CERTAIN_ONLY, INSTALLMENT_REFUND, CASH_REFUND, SYSTEMATIC_WITHDRAWAL | Payout.PayoutType (tc) | Irrevocable once started |
| 116 | payout_mode | Payment frequency | VARCHAR | 12 | MONTHLY, QUARTERLY, SEMI_ANNUAL, ANNUAL | Payout.PayoutMode (tc) | MONTHLY most common |
| 117 | payout_amount | Per-period payment | DECIMAL | 18,2 | > 0 | Payout.PayoutAmt | Calculated based on annuitization factors |
| 118 | certain_period_months | Guaranteed payment period | INTEGER | | 0-360 | Payout.CertainDuration | 0 for life-only |
| 119 | survivor_pct | Survivor benefit % | DECIMAL | 8,5 | 0-1.0 | Payout.SurvivorPercent | 50%, 75%, or 100% typical |
| 120 | exclusion_ratio | Tax exclusion ratio | DECIMAL | 8,5 | 0-1.0 | N/A | investment_in_contract / expected_return |

## 9.12 Reference Data Domain

| # | Field Name | Description | Data Type | Length | Valid Values | ACORD Mapping | Business Rules |
|---|---|---|---|---|---|---|---|
| 121 | naic_company_code | NAIC company identifier | VARCHAR | 5 | NAIC registry | N/A | Required for regulatory filings |
| 122 | sic_code | Standard Industrial Class | VARCHAR | 4 | Valid SIC | N/A | For organizational parties |
| 123 | naics_code | NAICS industry code | VARCHAR | 6 | Valid NAICS | N/A | Modern industry classification |
| 124 | fips_state_code | FIPS state code | CHAR | 2 | 01-56 | N/A | Used in IRS filings |
| 125 | iso_country_code | ISO country | CHAR | 2 | ISO 3166-1 | N/A | |

*(The data dictionary continues with fields 126-250+ covering surrender schedule fields, index strategy parameters, commission calculation fields, compliance fields, document metadata, correspondence tracking, and system audit fields. These follow the same format as above.)*

---

# 10. Master Data Management

## 10.1 Party / Customer MDM

### 10.1.1 MDM Architecture for Annuity Parties

```
┌─────────────┐  ┌─────────────┐  ┌─────────────┐
│ Policy Admin │  │ CRM System  │  │ Claims      │
│ System       │  │             │  │ System      │
└──────┬──────┘  └──────┬──────┘  └──────┬──────┘
       │                │                │
       └────────────────┼────────────────┘
                        │
                ┌───────▼───────┐
                │  MDM Hub      │
                │  (Golden      │
                │   Record)     │
                └───────┬───────┘
                        │
          ┌─────────────┼─────────────┐
          │             │             │
    ┌─────▼─────┐ ┌────▼────┐ ┌─────▼─────┐
    │ Match &   │ │ Merge   │ │ Survivorship│
    │ Link      │ │ Rules   │ │ Rules      │
    └───────────┘ └─────────┘ └────────────┘
```

### 10.1.2 Party Matching Rules

| Rule | Description | Weight |
|---|---|---|
| SSN Exact Match | Exact match on SSN/EIN | 100 (deterministic) |
| Name + DOB + ZIP | First name + last name + DOB + ZIP code | 85 |
| Name + DOB + Address | Full name + DOB + full address | 80 |
| Name + SSN Last 4 + DOB | Name + last 4 SSN + DOB | 75 |
| Name Soundex + DOB | Phonetic name match + DOB | 60 |
| Address + Phone | Address + phone number match | 50 |

### 10.1.3 Survivorship Rules (Golden Record)

| Field | Survivorship Rule |
|---|---|
| Legal Name | Most recent, from highest-trust source (admin system > CRM) |
| SSN | From admin system (most validated) |
| Date of Birth | From admin system (verified at underwriting) |
| Address | Most recent mailing address from any source |
| Email | Most recently validated email |
| Phone | Most recently confirmed phone |

### 10.1.4 Party Roles Across Systems

| System | Roles Managed | Key Fields |
|---|---|---|
| Policy Admin | Owner, Annuitant, Beneficiary | SSN, DOB, legal name, address |
| Distribution/Commission | Agent, Agency, BD Firm | NPN, agent license, appointment |
| Claims | Claimant, Deceased, Beneficiary | Date of death, claim status |
| CRM | Prospect, Customer, Contact | Preferences, interactions, opportunities |

## 10.2 Product Master Data

### 10.2.1 Product Master Table Structure

| Field | Type | Description |
|---|---|---|
| product_code | VARCHAR(20) | Unique product identifier |
| product_name | VARCHAR(100) | Marketing name |
| product_type | VARCHAR(4) | FA, VA, FIA, RILA, SPIA, DIA, QLAC, MYGA |
| carrier_code | VARCHAR(10) | Issuing carrier |
| product_status | VARCHAR(15) | ACTIVE, CLOSED_TO_NEW, DISCONTINUED |
| effective_date | DATE | Product availability start |
| close_date | DATE | Product closed to new sales |
| state_availability | TEXT | JSON array of available states |
| min_issue_age | INTEGER | Minimum issue age |
| max_issue_age | INTEGER | Maximum issue age |
| min_premium | DECIMAL(18,2) | Minimum initial premium |
| max_premium | DECIMAL(18,2) | Maximum initial premium (if applicable) |
| qualified_types_allowed | TEXT | JSON array of allowed qualified plan types |
| surrender_schedule | JSONB | JSON array of {year, rate} surrender charge schedule |
| free_withdrawal_pct | DECIMAL(8,5) | Annual free withdrawal percentage |
| death_benefit_type | VARCHAR(20) | RETURN_OF_PREM, HIGHEST_ANNIV, RATCHET, STEP_UP |
| me_charge_rate | DECIMAL(8,5) | Mortality & expense risk charge (VA) |
| admin_charge_rate | DECIMAL(8,5) | Administrative charge |
| contract_fee | DECIMAL(18,2) | Annual contract fee |
| contract_fee_waiver_threshold | DECIMAL(18,2) | Account value above which fee is waived |
| maturity_age | INTEGER | Maximum maturity age |
| loan_available | BOOLEAN | Policy loan feature available |
| loan_interest_rate | DECIMAL(8,5) | Fixed loan rate (if applicable) |
| available_funds | TEXT | JSON array of fund_ids available |
| available_riders | TEXT | JSON array of rider product codes |
| commission_schedule | JSONB | Commission rate structure |

### 10.2.2 Surrender Schedule Example (JSONB)

```json
{
  "type": "DECLINING",
  "schedule": [
    {"year": 1, "rate": 0.07},
    {"year": 2, "rate": 0.06},
    {"year": 3, "rate": 0.05},
    {"year": 4, "rate": 0.04},
    {"year": 5, "rate": 0.03},
    {"year": 6, "rate": 0.02},
    {"year": 7, "rate": 0.01},
    {"year": 8, "rate": 0.00}
  ],
  "free_withdrawal_pct": 0.10,
  "free_withdrawal_basis": "ACCOUNT_VALUE",
  "cumulative_or_noncumulative": "NONCUMULATIVE",
  "applies_to": "EXCESS_OVER_FREE"
}
```

## 10.3 Fund / Investment Option Master Data

### 10.3.1 Fund Master Table

| Field | Type | Description |
|---|---|---|
| fund_id | VARCHAR(20) | Internal fund identifier |
| fund_name | VARCHAR(100) | Full fund name |
| fund_short_name | VARCHAR(30) | Abbreviated name |
| cusip | CHAR(9) | CUSIP identifier |
| ticker | VARCHAR(10) | Ticker symbol |
| fund_family | VARCHAR(50) | Fund company (Vanguard, Fidelity, etc.) |
| fund_category | VARCHAR(30) | EQUITY, FIXED_INCOME, BALANCED, MONEY_MARKET, INTERNATIONAL, SPECIALTY, INDEX, TARGET_DATE |
| asset_class | VARCHAR(30) | LARGE_CAP, MID_CAP, SMALL_CAP, GOVT_BOND, CORP_BOND, etc. |
| sub_asset_class | VARCHAR(30) | GROWTH, VALUE, BLEND, HIGH_YIELD, etc. |
| morningstar_category | VARCHAR(50) | Morningstar classification |
| inception_date | DATE | Fund inception date |
| expense_ratio | DECIMAL(8,5) | Annual expense ratio |
| latest_nav | DECIMAL(12,6) | Latest net asset value |
| nav_date | DATE | Date of latest NAV |
| fund_status | VARCHAR(15) | OPEN, CLOSED_TO_NEW, LIQUIDATED |
| risk_level | INTEGER | 1-5 risk rating |
| benchmark_index | VARCHAR(50) | Benchmark index name |
| prospectus_url | VARCHAR(255) | Link to current prospectus |

### 10.3.2 Fund NAV History Table

| Field | Type | Description |
|---|---|---|
| fund_id | VARCHAR(20) | FK to fund master |
| nav_date | DATE | Valuation date |
| nav | DECIMAL(12,6) | Net asset value |
| total_return_daily | DECIMAL(10,8) | Daily total return |
| dividend | DECIMAL(10,6) | Per-share dividend |
| cap_gain | DECIMAL(10,6) | Per-share capital gain distribution |

## 10.4 Agent / Producer Master Data

### 10.4.1 Agent Master Table

| Field | Type | Description |
|---|---|---|
| agent_id | VARCHAR(20) | Internal agent identifier |
| npn | VARCHAR(10) | National Producer Number |
| first_name | VARCHAR(50) | First name |
| last_name | VARCHAR(80) | Last name |
| agent_status | VARCHAR(15) | ACTIVE, INACTIVE, TERMINATED |
| agent_type | VARCHAR(15) | CAPTIVE, INDEPENDENT, BANK, WIREHOUSE |
| bd_firm_id | VARCHAR(10) | Broker-dealer firm (NSCC participant #) |
| bd_firm_name | VARCHAR(100) | Broker-dealer name |
| ria_firm_id | VARCHAR(10) | RIA firm identifier |
| ria_firm_name | VARCHAR(100) | RIA firm name |
| agency_name | VARCHAR(100) | General agency / MGA |
| agency_code | VARCHAR(20) | Internal agency code |
| commission_level | VARCHAR(10) | Commission level code |
| default_commission_split | DECIMAL(8,5) | Default split percentage |
| appointment_date | DATE | Date appointed with carrier |
| termination_date | DATE | Date terminated |
| series_6 | BOOLEAN | FINRA Series 6 |
| series_7 | BOOLEAN | FINRA Series 7 |
| series_63 | BOOLEAN | FINRA Series 63 |
| series_65 | BOOLEAN | FINRA Series 65 |
| series_66 | BOOLEAN | FINRA Series 66 |
| insurance_license_states | TEXT | JSON array of {state, license_number, expiry_date} |
| e_and_o_carrier | VARCHAR(100) | E&O insurance carrier |
| e_and_o_expiry | DATE | E&O policy expiration |
| aml_training_date | DATE | Last AML training completion |
| suitability_training_date | DATE | Last suitability training |
| annuity_training_date | DATE | Last annuity-specific training (Reg BI / Best Interest) |

## 10.5 Reference Data Tables

### 10.5.1 State Code Reference

| Code | Name | FIPS | Premium Tax Rate (Annuity) | Free-Look Period |
|---|---|---|---|---|
| AL | Alabama | 01 | 1.60% | 10 days |
| AK | Alaska | 02 | 2.70% | 20 days |
| AZ | Arizona | 04 | 2.00% | 20 days (seniors) |
| CA | California | 06 | 2.35% | 30 days (seniors) |
| CO | Colorado | 08 | 2.00% | 10 days |
| CT | Connecticut | 09 | 1.50% | 10 days |
| FL | Florida | 12 | 1.75% | 21 days |
| NY | New York | 36 | 1.50% | 60 days (VA) |
| TX | Texas | 48 | 1.75% | 20 days |
| ... | ... | ... | ... | ... |

### 10.5.2 Transaction Type Reference

| Code | Description | Direction | Taxable | 1099-R Required |
|---|---|---|---|---|
| PREMIUM | Premium payment | Credit | N | N |
| PARTIAL_WITHDRAWAL | Partial withdrawal | Debit | Y (NQ: LIFO) | Y |
| FULL_SURRENDER | Full contract surrender | Debit | Y | Y |
| DEATH_BENEFIT | Death benefit payment | Debit | Y (gain portion) | Y |
| ANNUITY_PAYMENT | Periodic annuity income | Debit | Partial (excl. ratio) | Y |
| RMD | Required minimum distribution | Debit | Y | Y |
| 1035_EXCHANGE | Section 1035 exchange | Both | N (if properly structured) | Y (Code 6) |
| LOAN_ADVANCE | Policy loan | Debit | N (generally) | N |
| SUB_ACCT_TRANSFER | Inter-fund transfer | Neutral | N | N |
| INTEREST_CREDIT | Fixed account interest | Credit | N (until distributed) | N |
| FEE | Administrative fee | Debit | N | N |
| RIDER_CHARGE | Rider fee deduction | Debit | N | N |
| BONUS_CREDIT | Premium or persistency bonus | Credit | N (until distributed) | N |

### 10.5.3 NAIC Company Code Reference (Sample)

| NAIC Code | Company Name | State of Domicile | Group Code |
|---|---|---|---|
| 60142 | Hartford Life Insurance Company | CT | 0221 |
| 68616 | Metropolitan Life Insurance Company | NY | 0635 |
| 71153 | Prudential Insurance Company of America | NJ | 0826 |
| 86509 | Lincoln National Life Insurance Company | IN | 0524 |
| 93696 | Jackson National Life Insurance Company | MI | 1098 |
| 70106 | Pacific Life Insurance Company | NE | 0679 |
| 65935 | Nationwide Life Insurance Company | OH | 0474 |

---

# 11. Data Quality Rules

## 11.1 Field-Level Validation Rules

### 11.1.1 Contract Validations

| Rule ID | Field(s) | Rule | Severity | Error Code |
|---|---|---|---|---|
| CV001 | contract_number | Must be non-empty, max 20 chars, alphanumeric + hyphens | ERROR | INVALID_CONTRACT_NUM |
| CV002 | product_code | Must exist in product_master with status ACTIVE or CLOSED_TO_NEW | ERROR | INVALID_PRODUCT |
| CV003 | initial_premium | Must be ≥ product min_premium and ≤ product max_premium | ERROR | PREMIUM_OUT_OF_RANGE |
| CV004 | effective_date | Must be ≥ application_date and ≤ today + 30 days | ERROR | INVALID_EFF_DATE |
| CV005 | maturity_date | Must be > effective_date; owner age at maturity ≤ product max | WARNING | MATURITY_DATE_CHECK |
| CV006 | state_of_issue | Must be in product state_availability list | ERROR | STATE_NOT_AVAILABLE |
| CV007 | qualified_plan_type | Must be in product qualified_types_allowed list | ERROR | QUAL_TYPE_NOT_ALLOWED |
| CV008 | contract_status | Transition must follow valid state machine | ERROR | INVALID_STATUS_TRANS |

### 11.1.2 Party Validations

| Rule ID | Field(s) | Rule | Severity | Error Code |
|---|---|---|---|---|
| PV001 | tax_id (SSN) | Must be 9 digits, valid format (not 000-xx-xxxx, not 9xx-xx-xxxx) | ERROR | INVALID_SSN |
| PV002 | tax_id (EIN) | Must be 9 digits, valid prefix (10-99) | ERROR | INVALID_EIN |
| PV003 | date_of_birth | Must be valid date, age between 0 and 120 | ERROR | INVALID_DOB |
| PV004 | date_of_birth (owner) | Owner age at issue must be ≥ product min_issue_age and ≤ max_issue_age | ERROR | AGE_OUT_OF_RANGE |
| PV005 | first_name, last_name | Must be non-empty for INDIVIDUAL party_type | ERROR | NAME_REQUIRED |
| PV006 | organization_name | Must be non-empty for ORGANIZATION party_type | ERROR | ORG_NAME_REQUIRED |
| PV007 | email_primary | Must be valid email format (RFC 5322) | WARNING | INVALID_EMAIL |
| PV008 | phone_primary | Must be 10+ digits | WARNING | INVALID_PHONE |

### 11.1.3 Address Validations

| Rule ID | Field(s) | Rule | Severity | Error Code |
|---|---|---|---|---|
| AV001 | line_1 | Must be non-empty, max 100 chars | ERROR | ADDR_LINE1_REQUIRED |
| AV002 | city | Must be non-empty | ERROR | CITY_REQUIRED |
| AV003 | state_code | Must be valid US state/territory code | ERROR | INVALID_STATE |
| AV004 | postal_code | Must be valid 5 or 9 digit ZIP format | ERROR | INVALID_ZIP |
| AV005 | state_code + postal_code | ZIP must be valid for the given state | WARNING | ZIP_STATE_MISMATCH |
| AV006 | Address (composite) | USPS address verification should return deliverable | WARNING | ADDR_NOT_VERIFIED |

### 11.1.4 Financial Transaction Validations

| Rule ID | Field(s) | Rule | Severity | Error Code |
|---|---|---|---|---|
| FV001 | gross_amount | Must be > 0 for credits, < 0 for debits (or always positive with sign by type) | ERROR | INVALID_AMOUNT |
| FV002 | effective_date | Must be ≤ today + 5 business days | ERROR | FUTURE_DATE_LIMIT |
| FV003 | federal_withholding | Must be ≥ 0 and ≤ gross_amount | ERROR | INVALID_FED_WH |
| FV004 | state_withholding | Must be ≥ 0 and ≤ gross_amount | ERROR | INVALID_STATE_WH |
| FV005 | net_amount | Must equal gross - surrender_charge - mva_adj - fed_wh - state_wh | ERROR | NET_AMOUNT_MISMATCH |

## 11.2 Cross-Field Validation Rules

| Rule ID | Fields | Rule Description | Severity |
|---|---|---|---|
| XF001 | Owner DOB + Product Type | If product is QLAC, owner must be < age 73 at purchase | ERROR |
| XF002 | Qual Plan Type + Premium | If TIRA and owner age > 72, no additional premiums (contribution limit) | ERROR |
| XF003 | Beneficiary % | All PRIMARY_BENEFICIARY percentages on a contract must sum to 100% | ERROR |
| XF004 | Contingent Bene % | All CONTINGENT_BENEFICIARY percentages must sum to 100% | ERROR |
| XF005 | Allocation % | All current sub-account allocations must sum to 100% | ERROR |
| XF006 | Withdrawal + Free WD | If withdrawal > free_withdrawal_amount, surrender charge applies | WARNING |
| XF007 | RMD + Age | If qualified plan and owner age ≥ 73, RMD must be calculated | WARNING |
| XF008 | 1035 Exchange | If exchange_1035_ind = true, cost_basis must be set from source contract | ERROR |
| XF009 | GMWB + Withdrawal | If annual withdrawals exceed max_annual_wd_pct × benefit_base, excess_withdrawal_flag = true | WARNING |
| XF010 | Joint Owner + Bene | If joint owner exists, beneficiary designations must account for first-to-die and second-to-die | WARNING |
| XF011 | Annuitant Age + Payout | If annuitant age < 59½ at annuitization, 10% penalty may apply (NQ) | WARNING |
| XF012 | State + Replacement | If replacement_ind = true, state-specific replacement forms required | ERROR |
| XF013 | Product Status + App | Cannot submit application for product with status DISCONTINUED | ERROR |
| XF014 | Agent License + State | Agent must hold active annuity license in state_of_issue | ERROR |
| XF015 | Disbursement + Bank | If disbursement_method = ACH, bank_account_id must be non-null and prenote_status = VERIFIED | ERROR |

## 11.3 Business Rule Validations

### 11.3.1 Suitability Rules

| Rule ID | Rule | Description |
|---|---|---|
| BR001 | Age-based suitability | Flag if owner age > 80 and product has surrender period > 5 years |
| BR002 | Liquidity check | Flag if initial_premium > 50% of declared liquid net worth |
| BR003 | Concentration check | Flag if total annuity holdings > 70% of total net worth |
| BR004 | Time horizon | Flag if surrender period extends beyond stated investment time horizon |
| BR005 | Risk tolerance | Flag if VA with aggressive allocation selected by conservative-rated client |
| BR006 | Replacement analysis | If replacement, validate that new contract provides material benefit over existing |

### 11.3.2 Regulatory Compliance Rules

| Rule ID | Rule | Description |
|---|---|---|
| RC001 | 403(b) restrictions | Only approved annuity products allowed in 403(b) plans |
| RC002 | QLAC limits | QLAC premium cannot exceed lesser of $200,000 or 25% of retirement account |
| RC003 | IRA contribution limits | Traditional/Roth IRA annual contribution limited to $7,000 ($8,000 if age 50+) |
| RC004 | RMD compliance | Qualified contracts must begin RMDs by April 1 following year owner turns 73 |
| RC005 | NRA withholding | Non-resident aliens: mandatory 30% federal withholding (or treaty rate) |
| RC006 | State mandatory WH | Certain states mandate minimum withholding on annuity distributions |

## 11.4 Data Quality Scorecard

| Dimension | Metric | Target | Measurement |
|---|---|---|---|
| **Completeness** | % of required fields populated | ≥ 99.5% | Count non-null required fields / total required fields |
| **Accuracy** | % of validated fields passing rules | ≥ 99.0% | Count passing validations / total validations run |
| **Consistency** | % of cross-system matches | ≥ 98.0% | Count matching records across systems / total records |
| **Timeliness** | % of records updated within SLA | ≥ 99.0% | Count records updated within expected window / total |
| **Uniqueness** | % of non-duplicate party records | ≥ 99.5% | Count unique parties / total party records |
| **Validity** | % of fields conforming to domain rules | ≥ 99.0% | Count valid values / total field instances |
| **Referential Integrity** | % of FKs resolving to valid parent | 100% | Count valid FK references / total FK references |

---

# 12. Data Mapping & Transformation

## 12.1 Common Mapping Scenarios

### 12.1.1 ACORD TXLife → Internal Canonical Model

| ACORD Source Path | Canonical Target | Transformation Rule |
|---|---|---|
| `TXLifeRequest/OLifE/Holding/Policy/PolNumber` | contract.contract_number | Direct map |
| `TXLifeRequest/OLifE/Holding/Policy/CarrierCode` | contract.carrier_code | Direct map |
| `TXLifeRequest/OLifE/Holding/Policy/ProductCode` | contract.product_code | Lookup in product_master |
| `TXLifeRequest/OLifE/Holding/Policy/Annuity/AnnuityProduct/@tc` | contract.product_type | Translate: tc=421→FA, tc=422→VA, tc=423→FIA, tc=424→RILA |
| `TXLifeRequest/OLifE/Holding/Policy/Annuity/QualPlanType/@tc` | contract.qualified_plan_type | Translate: tc=0→NQ, tc=1→TIRA, tc=2→RIRA, etc. |
| `TXLifeRequest/OLifE/Holding/Policy/PolicyStatus/@tc` | contract.contract_status | Translate: tc=1→ACTIVE, tc=14→PENDING, tc=18→PROPOSED, etc. |
| `TXLifeRequest/OLifE/Holding/Policy/ApplicationInfo/SignedDate` | contract.application_date | Parse ISO date |
| `TXLifeRequest/OLifE/Holding/Policy/Annuity/InitPaymentAmt` | contract.initial_premium | Parse decimal |
| `TXLifeRequest/OLifE/Party/PersonOrOrganization/Person/FirstName` | party.first_name | Direct map; trim whitespace |
| `TXLifeRequest/OLifE/Party/PersonOrOrganization/Person/LastName` | party.last_name | Direct map; trim whitespace |
| `TXLifeRequest/OLifE/Party/GovtID` | party.tax_id | Encrypt; store hash in tax_id_hash |
| `TXLifeRequest/OLifE/Party/PersonOrOrganization/Person/BirthDate` | party.date_of_birth | Parse ISO date |
| `TXLifeRequest/OLifE/Party/PersonOrOrganization/Person/Gender/@tc` | party.gender | Translate: tc=1→M, tc=2→F, tc=3→U |
| `TXLifeRequest/OLifE/Relation/RelationRoleCode/@tc` | contract_role.role_type | Translate: tc=8→OWNER, tc=32→ANNUITANT, tc=34→PRIMARY_BENEFICIARY, etc. |
| `TXLifeRequest/OLifE/Relation/InterestPercent` | contract_role.benefit_percentage | Divide by 100 if percentage (0-100 → 0-1) |
| `TXLifeRequest/OLifE/Holding/Policy/Annuity/SubAccount/AllocPercent` | sub_account_allocation.allocation_pct | Direct map (already 0-1) |
| `TXLifeRequest/OLifE/Holding/Policy/Annuity/SubAccount/FundID` | sub_account_allocation.fund_id | Lookup in fund_master |
| `TXLifeRequest/OLifE/Holding/Policy/Annuity/Rider/RiderTypeCode/@tc` | rider.rider_type | Translate: tc=91→GMDB, tc=99→GMWB, tc=100→GLWB, etc. |
| `TXLifeRequest/OLifE/Party/Address/Line1` | address.line_1 | Direct map; USPS standardize |
| `TXLifeRequest/OLifE/Party/Address/City` | address.city | Direct map; uppercase |
| `TXLifeRequest/OLifE/Party/Address/AddressStateTC/@tc` | address.state_code | Translate tc to 2-letter state code |
| `TXLifeRequest/OLifE/Party/Address/Zip` | address.postal_code | Format: ensure 5 or 9 digit |

### 12.1.2 NSCC Position File → Internal Canonical Model

| NSCC Source Field | Canonical Target | Transformation Rule |
|---|---|---|
| PolicyNumber | contract.contract_number | Trim to 20 chars |
| CarrierCode | contract.carrier_code | Map NSCC carrier code to internal code |
| OwnerSSN | party.tax_id | Encrypt; match or create party |
| OwnerLastName | party.last_name | Uppercase standardization |
| OwnerFirstName | party.first_name | Title case |
| ValuationDate | contract_financial_summary.valuation_date | Parse YYYYMMDD → DATE |
| TotalAccountValue | contract_financial_summary.account_value | Divide by 100 (implied decimals) |
| TotalSurrenderValue | contract_financial_summary.surrender_value | Divide by 100 |
| TotalDeathBenefitValue | contract_financial_summary.death_benefit_value | Divide by 100 |
| TotalLoanBalance | contract_financial_summary.loan_balance | Divide by 100 |
| CostBasis | contract_financial_summary.cost_basis | Divide by 100 |
| PolicyStatus | contract.contract_status | Map: 01→ACTIVE, 03→SURRENDERED, 08→DEATH_CLAIM, 11→ANNUITIZED |
| SubAcctNN_FundID | sub_account_position.fund_id | Map NSCC fund code to internal fund_id |
| SubAcctNN_Units | sub_account_position.units | Divide by 1000000 (6 implied decimals) |
| SubAcctNN_UnitValue | sub_account_position.unit_value | Divide by 1000000 |
| SubAcctNN_AcctValue | sub_account_position.market_value | Divide by 100 |

### 12.1.3 NSCC Commission File → Internal Model

| NSCC Source Field | Canonical Target | Transformation |
|---|---|---|
| PolicyNumber | commission.contract_number | Direct map |
| AgentID | commission.agent_id | Map NSCC agent code to internal |
| CommissionType | commission.commission_type | Map: 01→FIRST_YEAR, 02→RENEWAL, 03→TRAIL, 04→BONUS |
| GrossCommission | commission.gross_amount | Divide by 100 |
| NetCommission | commission.net_amount | Divide by 100 |
| PremiumAmount | commission.base_amount | Divide by 100 |
| CommissionRate | commission.rate | Divide by 10000 (4 implied decimals) |
| CommissionDate | commission.earned_date | Parse YYYYMMDD |
| ChargebackIndicator | commission.is_chargeback | Map: Y→true, N→false |

## 12.2 Legacy-to-Modern Migration Mappings

### 12.2.1 Common Legacy System Patterns

| Legacy Pattern | Modern Equivalent | Migration Strategy |
|---|---|---|
| COBOL COMP-3 packed decimal | DECIMAL(18,2) | Unpack BCD to decimal |
| EBCDIC character set | UTF-8 | Transcode using EBCDIC-to-UTF8 mapping |
| Fixed-width flat files | JSON/XML/database records | Parse by position; map field-by-field |
| Date as CYYMMDD (C=century flag) | ISO 8601 DATE | Parse: C=0→19xx, C=1→20xx; format YYYY-MM-DD |
| Mainframe copybook layouts | Schema definitions | Auto-convert copybook to DDL/schema |
| Two-character state codes in proprietary numbering | ISO standard codes | Map proprietary→standard using crosswalk |
| Numeric codes for everything | Meaningful enums | Build code translation tables |
| VSAM/IMS hierarchical records | Relational tables | Flatten hierarchy; normalize to 3NF |
| Occurs-depending-on (variable arrays) | Child table rows | One row per occurrence |

### 12.2.2 Sample COBOL Copybook → DDL Translation

**COBOL Copybook:**
```cobol
       01  ANNUITY-RECORD.
           05  ANN-CONTRACT-NUM       PIC X(12).
           05  ANN-OWNER-SSN          PIC 9(09).
           05  ANN-OWNER-NAME.
               10  ANN-OWNER-LAST     PIC X(25).
               10  ANN-OWNER-FIRST    PIC X(15).
           05  ANN-ISSUE-DATE         PIC 9(07).
           05  ANN-PRODUCT-CODE       PIC X(06).
           05  ANN-QUAL-CODE          PIC 9(02).
           05  ANN-STATUS-CODE        PIC 9(02).
           05  ANN-ACCOUNT-VALUE      PIC S9(11)V99 COMP-3.
           05  ANN-SURRENDER-VALUE    PIC S9(11)V99 COMP-3.
           05  ANN-DEATH-BEN-VALUE    PIC S9(11)V99 COMP-3.
           05  ANN-COST-BASIS         PIC S9(11)V99 COMP-3.
           05  ANN-FUND-COUNT         PIC 9(02).
           05  ANN-FUND-ENTRY OCCURS 30 TIMES.
               10  ANN-FUND-CODE      PIC X(06).
               10  ANN-FUND-UNITS     PIC S9(11)V9(06) COMP-3.
               10  ANN-FUND-VALUE     PIC S9(11)V99 COMP-3.
```

**Target DDL mapping:**

| COBOL Field | SQL Column | Type | Transform |
|---|---|---|---|
| ANN-CONTRACT-NUM | contract_number | VARCHAR(12) | Trim trailing spaces |
| ANN-OWNER-SSN | tax_id | VARCHAR(11) | Format as XXX-XX-XXXX; encrypt |
| ANN-OWNER-LAST | last_name | VARCHAR(25) | Trim; title case |
| ANN-OWNER-FIRST | first_name | VARCHAR(15) | Trim; title case |
| ANN-ISSUE-DATE | issue_date | DATE | CYYMMDD → YYYY-MM-DD |
| ANN-PRODUCT-CODE | product_code | VARCHAR(6) | Map via product crosswalk |
| ANN-QUAL-CODE | qualified_plan_type | VARCHAR(10) | Map: 00→NQ, 01→TIRA, 02→RIRA, etc. |
| ANN-STATUS-CODE | contract_status | VARCHAR(20) | Map: 01→ACTIVE, 02→SURRENDERED, etc. |
| ANN-ACCOUNT-VALUE | account_value | DECIMAL(18,2) | Unpack COMP-3 |
| ANN-FUND-ENTRY (array) | sub_account_position (child rows) | One row per fund | Unpack; create N child records |

## 12.3 ETL Patterns for Annuity Data

### 12.3.1 Daily Valuation Pipeline

```
┌────────────┐     ┌──────────┐     ┌──────────┐     ┌──────────────┐
│ Fund NAV   │────>│ Extract  │────>│ Calculate│────>│ Load Daily   │
│ Feed       │     │ & Validate│    │ Contract │     │ Positions &  │
│ (pricing   │     │ NAVs     │     │ Values   │     │ Summaries    │
│  vendor)   │     └──────────┘     └──────────┘     └──────────────┘
└────────────┘                           │
                                         │
                                    ┌────▼───────┐
                                    │ Publish    │
                                    │ Valuation  │
                                    │ Events     │
                                    └────────────┘
```

**Processing Steps:**

1. **Extract** — Receive fund NAV file from pricing vendor (e.g., DTCC, Bloomberg).
2. **Validate** — Check for missing funds, stale prices, outlier values (>5% daily move).
3. **Calculate** — For each contract: units × NAV = sub-account value; sum = account value. Apply surrender schedule for surrender value. Calculate death benefit per rider rules.
4. **Load** — Insert/update `sub_account_position` and `contract_financial_summary`.
5. **Publish** — Emit `ContractValueUpdated` events for downstream consumers.

### 12.3.2 NSCC Position Reconciliation Pipeline

```
┌────────────┐     ┌──────────┐     ┌──────────┐     ┌──────────────┐
│ NSCC       │────>│ Parse    │────>│ Match &  │────>│ Reconcile &  │
│ Position   │     │ Fixed-   │     │ Compare  │     │ Report       │
│ File       │     │ Width    │     │ to Admin │     │ Exceptions   │
└────────────┘     └──────────┘     └──────────┘     └──────────────┘
```

**Reconciliation Logic:**

| Field | Match Criteria | Tolerance |
|---|---|---|
| Contract Number | Exact match | None |
| Account Value | Numeric comparison | ±$0.02 (rounding) |
| Surrender Value | Numeric comparison | ±$0.05 |
| Death Benefit | Numeric comparison | ±$0.02 |
| Sub-Account Units | Numeric comparison | ±0.001 units |
| Contract Status | Code comparison | Must match |

### 12.3.3 1099-R Generation Pipeline

```
┌────────────┐     ┌──────────┐     ┌──────────┐     ┌──────────────┐
│ Financial  │────>│ Aggregate│────>│ Apply    │────>│ Generate     │
│ Transaction│     │ by Party │     │ Tax Rules│     │ 1099-R File  │
│ History    │     │ & Tax Yr │     │          │     │ (IRS FIRE)   │
└────────────┘     └──────────┘     └──────────┘     └──────────────┘
```

**Tax Calculation Rules:**

| Transaction Type | Qualified (IRA) | Non-Qualified (NQ) |
|---|---|---|
| Partial Withdrawal | Fully taxable (Box 2a = Box 1) | Gain first (LIFO); Box 2a = min(gain, distribution) |
| Full Surrender | Fully taxable | Box 2a = total distribution - cost basis |
| Death Benefit | Fully taxable to beneficiary | Gain portion taxable |
| Annuity Payment | Fully taxable | Exclusion ratio applies until cost basis recovered |
| RMD | Fully taxable | N/A (NQ has no RMD) |
| 1035 Exchange | Code G (direct rollover) or Code 6 | Code 6 (nontaxable exchange) |

## 12.4 Data Transformation Rules Summary

### 12.4.1 Common Transformations

| Transformation | Description | Example |
|---|---|---|
| Decimal Scaling | Convert implied-decimal integers to proper decimals | 10050000 → 100500.00 (÷100) |
| Date Format | Standardize date formats to ISO 8601 | CYYMMDD → YYYY-MM-DD; MM/DD/YYYY → YYYY-MM-DD |
| SSN Formatting | Standardize SSN format | 123456789 → 123-45-6789 (display); encrypt for storage |
| Code Translation | Map source codes to canonical values | ACORD tc=8 → OWNER; NSCC 01 → ACTIVE |
| Name Standardization | Title case, trim, handle special characters | "SMITH JR" → "Smith" + suffix="Jr." |
| Address Standardization | USPS CASS certification | "123 N Main St Apt 4B" → "123 N MAIN ST APT 4B" |
| Currency Conversion | Convert to canonical currency | Handle foreign currency premiums |
| Null Handling | Apply default values for optional fields | null premium mode → "FLEXIBLE" |
| Phone Formatting | Standardize phone formats | "(860) 555-1234" → "8605551234" |
| Boolean Mapping | Convert various boolean representations | "Y"/"N", "1"/"0", "true"/"false" → boolean |
| Percentage Normalization | Ensure consistent percentage representation | 5.0 → 0.05 (store as decimal fraction) |
| Character Encoding | Ensure UTF-8 compatibility | EBCDIC → UTF-8; strip non-printable chars |

### 12.4.2 Complex Transformation: Cost Basis Carryover on 1035 Exchange

```
Input:
  source_contract.cost_basis = $80,000
  source_contract.account_value = $120,000
  1035_exchange_amount = $120,000  (full exchange)

Transformation:
  target_contract.initial_premium = $120,000
  target_contract.cost_basis = $80,000  (carried over from source)
  target_contract.gain = $120,000 - $80,000 = $40,000 (deferred)

  On source contract:
    1099-R with Distribution Code 6 (nontaxable exchange)
    Box 1 = $120,000 (Gross Distribution)
    Box 2a = $0 (Taxable Amount if properly executed)
```

### 12.4.3 Complex Transformation: GMWB Excess Withdrawal Impact

```
Input:
  benefit_base = $300,000
  account_value = $250,000
  max_annual_wd_pct = 5%
  max_annual_wd_amount = $300,000 × 5% = $15,000
  requested_withdrawal = $25,000

Transformation:
  free_portion = $15,000 (within GMWB allowance)
  excess_portion = $25,000 - $15,000 = $10,000

  Pro-rata reduction to benefit base:
    reduction_ratio = $10,000 / $250,000 = 4%
    new_benefit_base = $300,000 × (1 - 0.04) = $288,000

  excess_withdrawal_flag = true
  new_account_value = $250,000 - $25,000 = $225,000
```

### 12.4.4 Complex Transformation: RMD Calculation

```
Input:
  qualified_plan_type = TIRA
  owner_dob = 1952-06-15
  owner_age_as_of_dec31 = 73
  prior_year_end_account_value = $500,000
  irs_uniform_lifetime_table_divisor (age 73) = 26.5

Transformation:
  rmd_amount = $500,000 / 26.5 = $18,867.92

  If spousal beneficiary more than 10 years younger:
    Use Joint Life Expectancy Table instead
    joint_divisor (e.g., age 73 owner / age 55 spouse) = 30.2
    rmd_amount = $500,000 / 30.2 = $16,556.29

Output:
  rmd_required_amount = $18,867.92 (or $16,556.29)
  rmd_deadline = 2026-04-01 (if first RMD year) or 2025-12-31
```

---

## Appendix A: Glossary of Abbreviations

| Abbreviation | Full Form |
|---|---|
| ACORD | Association for Cooperative Operations Research and Development |
| ACATS | Automated Customer Account Transfer Service |
| ACH | Automated Clearing House |
| CDM | Canonical Data Model |
| CTE | Conditional Tail Expectation |
| CUSIP | Committee on Uniform Securities Identification Procedures |
| DIA | Deferred Income Annuity |
| DTCC | Depository Trust & Clearing Corporation |
| EFT | Electronic Funds Transfer |
| ETL | Extract, Transform, Load |
| FA | Fixed Annuity |
| FIA | Fixed Indexed Annuity |
| FIRE | Filing Information Returns Electronically (IRS) |
| GLWB | Guaranteed Lifetime Withdrawal Benefit |
| GMAB | Guaranteed Minimum Accumulation Benefit |
| GMDB | Guaranteed Minimum Death Benefit |
| GMIB | Guaranteed Minimum Income Benefit |
| GMWB | Guaranteed Minimum Withdrawal Benefit |
| I&RS | Insurance & Retirement Services (DTCC) |
| IRS | Internal Revenue Service |
| LIFO | Last In, First Out (tax treatment for NQ annuities) |
| MDM | Master Data Management |
| MEC | Modified Endowment Contract |
| MVA | Market Value Adjustment |
| MYGA | Multi-Year Guaranteed Annuity |
| NACHA | National Automated Clearing House Association |
| NAIC | National Association of Insurance Commissioners |
| NAV | Net Asset Value |
| NIGO | Not In Good Order |
| NIPR | National Insurance Producer Registry |
| NPN | National Producer Number |
| NQ | Non-Qualified |
| NRA | Non-Resident Alien |
| NSCC | National Securities Clearing Corporation |
| OLifE | Open Life Financial Exchange |
| QLAC | Qualified Longevity Annuity Contract |
| RBC | Risk-Based Capital |
| RILA | Registered Index-Linked Annuity |
| RMD | Required Minimum Distribution |
| SERFF | System for Electronic Rate and Form Filing |
| SPIA | Single Premium Immediate Annuity |
| SSN | Social Security Number |
| TIN | Taxpayer Identification Number |
| VA | Variable Annuity |
| XBRL | eXtensible Business Reporting Language |

## Appendix B: ACORD tc Value Quick Reference

### Product Types
| tc | Value |
|---|---|
| 421 | Fixed Annuity |
| 422 | Variable Annuity |
| 423 | Fixed Indexed Annuity |
| 424 | RILA |
| 425 | SPIA |
| 426 | DIA |
| 427 | QLAC |
| 428 | MYGA |

### Relation Roles
| tc | Value |
|---|---|
| 8 | Owner |
| 32 | Annuitant |
| 34 | Beneficiary |
| 37 | Agent |
| 39 | Contingent Beneficiary |
| 55 | Joint Owner |
| 70 | Payor |
| 109 | Irrevocable Beneficiary |

### Policy Statuses
| tc | Value |
|---|---|
| 1 | Active |
| 3 | Surrendered |
| 8 | Death Claim |
| 11 | Annuitized |
| 14 | Pending |
| 18 | Proposed |
| 22 | Matured |

### Financial Activity Types
| tc | Value |
|---|---|
| 1 | Premium |
| 6 | Partial Withdrawal |
| 7 | Full Surrender |
| 8 | Death Benefit |
| 10 | Transfer |
| 14 | Interest Credit |
| 26 | Annuity Payment |
| 30 | RMD |
| 35 | 1035 Exchange |

## Appendix C: NSCC Code Crosswalk

| NSCC Code | NSCC Description | ACORD tc | Internal Code |
|---|---|---|---|
| 01 | Active | 1 | ACTIVE |
| 02 | Inactive | 2 | INACTIVE |
| 03 | Surrendered | 3 | SURRENDERED |
| 04 | Paid-Up | 5 | PAID_UP |
| 05 | Lapsed | 6 | LAPSED |
| 08 | Death Claim | 8 | DEATH_CLAIM |
| 11 | Annuitized | 11 | ANNUITIZED |
| 14 | Pending Issue | 14 | PENDING |
| 18 | Applied | 18 | PROPOSED |
| 22 | Matured | 22 | MATURED |
| 30 | Transferred | 30 | TRANSFERRED |

---

*This chapter is part of the Annuities Encyclopedia series. For related content, see:*
- *Chapter 3: Product Types and Features*
- *Chapter 5: Integration Architecture and Patterns*
- *Chapter 6: Regulatory and Compliance Framework*
- *Chapter 7: Tax Treatment and Reporting*

---

**Document Version:** 1.0.0
**Last Updated:** April 2025
**Author:** Architecture Team
**Classification:** Internal — Solution Architecture Reference
