# Underwriting Data Standards & Formats — Complete Technical Reference

> An exhaustive encyclopedia of every data standard, message format, code system, and schema used in term life insurance underwriting. Written for solution architects building automated underwriting systems that must ingest, normalize, and act on data from dozens of vendors and industry bodies.

---

## Table of Contents

1. [ACORD Standards for Life Insurance](#1-acord-standards-for-life-insurance)
2. [MIB (Medical Information Bureau)](#2-mib-medical-information-bureau)
3. [Prescription Drug Data (Rx)](#3-prescription-drug-data-rx)
4. [Lab Data Standards](#4-lab-data-standards)
5. [Motor Vehicle Reports (MVR)](#5-motor-vehicle-reports-mvr)
6. [Credit-Based Insurance Scores](#6-credit-based-insurance-scores)
7. [Electronic Health Records & FHIR](#7-electronic-health-records--fhir)
8. [Identity Verification Data](#8-identity-verification-data)
9. [MISMO & Reinsurance Data Standards](#9-mismo--reinsurance-data-standards)
10. [Emerging Standards](#10-emerging-standards)
11. [Data Governance for Underwriting](#11-data-governance-for-underwriting)
12. [Cross-Reference Tables — Vendor-to-Canonical Mapping](#12-cross-reference-tables--vendor-to-canonical-mapping)
13. [Appendix — Quick-Reference Cheat Sheet](#13-appendix--quick-reference-cheat-sheet)

---

## 1. ACORD Standards for Life Insurance

### 1.1 What Is ACORD?

ACORD (Association for Cooperative Operations Research and Development) is the global standards body for the insurance industry. Founded in 1970, ACORD publishes:

- **Data standards** — XML schemas (TXLife), JSON schemas, data dictionaries.
- **Forms** — Standardized paper/electronic application forms.
- **Code tables** — Enumerated value sets used across the industry.
- **Messaging standards** — Transaction types, request/response patterns.

For life insurance underwriting, the **TXLife** XML schema is the dominant standard. Every major vendor (ExamOne, MIB, Milliman, CRL, APPS) speaks TXLife either natively or via adapter.

### 1.2 TXLife XML Schema — Deep Dive

#### 1.2.1 Schema Organization

The TXLife schema is organized into a hierarchy:

```
TXLife (root)
├── UserAuthRequest / UserAuthResponse
├── TXLifeRequest (1..n)
│   ├── TransRefGUID
│   ├── TransType (tc value)
│   ├── TransSubType
│   ├── TransExeDate / TransExeTime
│   ├── OLifE
│   │   ├── SourceInfo
│   │   ├── Holding (1..n)
│   │   │   ├── Policy
│   │   │   │   ├── LifeOrAnnuityOrDisabilityHealthOrPropertyandCasualty
│   │   │   │   │   └── Life
│   │   │   │   │       ├── Coverage (1..n)
│   │   │   │   │       ├── FaceAmt
│   │   │   │   │       └── ...
│   │   │   │   ├── ApplicationInfo
│   │   │   │   └── RequirementInfo (1..n)
│   │   │   └── HoldingStatus
│   │   ├── Party (1..n)
│   │   │   ├── PersonOrOrganization
│   │   │   │   └── Person
│   │   │   │       ├── FirstName, LastName, BirthDate, Gender
│   │   │   │       └── ...
│   │   │   ├── Address (1..n)
│   │   │   ├── Phone (1..n)
│   │   │   ├── EMailAddress (1..n)
│   │   │   ├── Risk
│   │   │   │   ├── MedicalCondition (1..n)
│   │   │   │   ├── SubstanceUsage (1..n)
│   │   │   │   ├── FamilyHistory (1..n)
│   │   │   │   ├── LabTesting (1..n)
│   │   │   │   └── ...
│   │   │   └── Client
│   │   └── Relation (1..n)
│   └── ...
└── TXLifeResponse (1..n)
    ├── TransResult
    │   ├── ResultCode
    │   └── ResultInfo (1..n)
    └── OLifE (same structure)
```

#### 1.2.2 Key TransType Codes

| tc Value | TransType Name | Description |
|----------|---------------|-------------|
| 103 | New Application Submission | Initial application from distributor to carrier |
| 121 | Underwriting Status Update | Status change notification during UW process |
| 152 | Requirement Order | Order labs, MVR, MIB, APS |
| 153 | Requirement Result | Return results from a vendor |
| 228 | Policy Issue | Final policy issue notification |
| 501 | General Inquiry | Ad hoc data query |
| 511 | Case Status Request | Poll for current case status |
| 1122 | Reinsurance Application | Submit case to reinsurer |
| 1125 | Reinsurance Decision | Reinsurer's underwriting decision |

#### 1.2.3 Full XML Example — Application Submission (TransType 103)

```xml
<?xml version="1.0" encoding="UTF-8"?>
<TXLife xmlns="http://ACORD.org/Standards/Life/2"
        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:schemaLocation="http://ACORD.org/Standards/Life/2 TXLife2.43.00.xsd"
        Version="2.43.00">
  <UserAuthRequest>
    <UserLoginName>CARRIER_API_USER</UserLoginName>
    <UserPswd>
      <CryptType>NONE</CryptType>
      <Pswd>encrypted_token_here</Pswd>
    </UserPswd>
    <VendorApp>
      <VendorName tc="9999">AcmeDistributor</VendorName>
      <AppName>AcmeQuoteEngine</AppName>
      <AppVer>3.2.1</AppVer>
    </VendorApp>
  </UserAuthRequest>

  <TXLifeRequest PrimaryObjectID="Holding_1">
    <TransRefGUID>a1b2c3d4-e5f6-7890-abcd-ef1234567890</TransRefGUID>
    <TransType tc="103">New Application</TransType>
    <TransSubType tc="10301">Full Application</TransSubType>
    <TransExeDate>2026-04-16</TransExeDate>
    <TransExeTime>14:30:00-05:00</TransExeTime>
    <TransMode tc="2">Original</TransMode>

    <OLifE>
      <SourceInfo>
        <CreationDate>2026-04-16</CreationDate>
        <CreationTime>14:30:00-05:00</CreationTime>
        <SourceInfoName>AcmeDistributor</SourceInfoName>
      </SourceInfo>

      <!-- ======================= HOLDING ======================= -->
      <Holding id="Holding_1">
        <HoldingTypeCode tc="2">Policy</HoldingTypeCode>
        <HoldingStatus tc="3">Proposed</HoldingStatus>

        <Policy id="Policy_1">
          <PolNumber>PENDING-20260416-001</PolNumber>
          <LineOfBusiness tc="1">Life</LineOfBusiness>
          <ProductType tc="1">Term Life</ProductType>
          <ProductCode>TERM20_PREFERRED</ProductCode>
          <CarrierCode>ACME_LIFE</CarrierCode>
          <PlanName>Acme Preferred Term 20</PlanName>
          <PaymentMode tc="12">Monthly</PaymentMode>
          <PaymentMethod tc="7">EFT</PaymentMethod>
          <PaymentAmt>87.50</PaymentAmt>

          <Life>
            <FaceAmt>500000</FaceAmt>
            <QualPlanType tc="0">Non-Qualified</QualPlanType>

            <Coverage id="Coverage_1">
              <LifeCovTypeCode tc="1">Base</LifeCovTypeCode>
              <IndicatorCode tc="1">Base</IndicatorCode>
              <CurrentAmt>500000</CurrentAmt>
              <TermDate>2046-04-16</TermDate>
              <LivesType tc="1">Single Life</LivesType>
              <EffDate>2026-04-16</EffDate>
            </Coverage>

            <Coverage id="Coverage_2">
              <LifeCovTypeCode tc="12">Waiver of Premium</LifeCovTypeCode>
              <IndicatorCode tc="2">Rider</IndicatorCode>
              <CurrentAmt>500000</CurrentAmt>
            </Coverage>
          </Life>

          <ApplicationInfo>
            <TrackingID>DIST-TRK-2026-88421</TrackingID>
            <ApplicationType tc="1">New</ApplicationType>
            <FormalAppInd tc="1">true</FormalAppInd>
            <SignedDate>2026-04-16</SignedDate>
            <SubmissionDate>2026-04-16</SubmissionDate>
            <SubmissionType tc="3">Electronic</SubmissionType>
            <ApplicationJurisdiction tc="1">US</ApplicationJurisdiction>
            <ReplacementInd tc="0">false</ReplacementInd>
            <HOAssignedAppState tc="6">Colorado</HOAssignedAppState>
          </ApplicationInfo>

          <!-- ============= REQUIREMENT SPECIFICATIONS ============= -->
          <RequirementInfo id="Req_1">
            <ReqCode tc="1">Blood Profile</ReqCode>
            <ReqStatus tc="1">Outstanding</ReqStatus>
            <RequirementDetails>Full blood panel with HbA1c</RequirementDetails>
          </RequirementInfo>

          <RequirementInfo id="Req_2">
            <ReqCode tc="3">Urinalysis</ReqCode>
            <ReqStatus tc="1">Outstanding</ReqStatus>
          </RequirementInfo>

          <RequirementInfo id="Req_3">
            <ReqCode tc="25">MIB Check</ReqCode>
            <ReqStatus tc="2">Received</ReqStatus>
          </RequirementInfo>

          <RequirementInfo id="Req_4">
            <ReqCode tc="28">Motor Vehicle Report</ReqCode>
            <ReqStatus tc="1">Outstanding</ReqStatus>
          </RequirementInfo>

          <RequirementInfo id="Req_5">
            <ReqCode tc="34">Prescription History</ReqCode>
            <ReqStatus tc="2">Received</ReqStatus>
          </RequirementInfo>
        </Policy>
      </Holding>

      <!-- ======================= PARTIES ======================= -->
      <!-- Proposed Insured -->
      <Party id="Party_Insured">
        <PartyTypeCode tc="1">Person</PartyTypeCode>
        <GovtID>123-45-6789</GovtID>
        <GovtIDTC tc="1">SSN</GovtIDTC>
        <ResidenceState tc="6">Colorado</ResidenceState>
        <ResidenceCountry tc="1">US</ResidenceCountry>

        <Person>
          <FirstName>John</FirstName>
          <MiddleName>Robert</MiddleName>
          <LastName>Smith</LastName>
          <Prefix tc="1">Mr</Prefix>
          <Suffix/>
          <Gender tc="1">Male</Gender>
          <BirthDate>1988-07-15</BirthDate>
          <Age>37</Age>
          <Citizenship tc="1">US</Citizenship>
          <MarStat tc="1">Married</MarStat>
          <OccupClass tc="1">Professional</OccupClass>
          <SmokerStat tc="1">Never Smoked</SmokerStat>
          <Height2>
            <MeasureUnits tc="1">Inches</MeasureUnits>
            <MeasureValue>71</MeasureValue>
          </Height2>
          <Weight2>
            <MeasureUnits tc="3">Pounds</MeasureUnits>
            <MeasureValue>185</MeasureValue>
          </Weight2>
          <DriversLicenseNum>CO-123456789</DriversLicenseNum>
          <DriversLicenseState tc="6">Colorado</DriversLicenseState>
        </Person>

        <Address>
          <AddressTypeCode tc="1">Residence</AddressTypeCode>
          <Line1>123 Mountain View Drive</Line1>
          <Line2>Apt 4B</Line2>
          <City>Denver</City>
          <AddressStateTC tc="6">Colorado</AddressStateTC>
          <Zip>80202</Zip>
          <AddressCountryTC tc="1">US</AddressCountryTC>
        </Address>

        <Phone>
          <PhoneTypeCode tc="1">Home</PhoneTypeCode>
          <AreaCode>303</AreaCode>
          <DialNumber>5551234</DialNumber>
        </Phone>

        <EMailAddress>
          <EMailType tc="1">Personal</EMailType>
          <AddrLine>john.smith@email.com</AddrLine>
        </EMailAddress>

        <Employment>
          <EmployerName>Acme Technology Corp</EmployerName>
          <Occupation>Software Engineer</Occupation>
          <OccupClass tc="1">Professional</OccupClass>
          <AnnualIncome>145000</AnnualIncome>
        </Employment>

        <!-- ============= RISK INFORMATION ============= -->
        <Risk>
          <ExistingInsuranceInd tc="1">true</ExistingInsuranceInd>
          <ReplacementInd tc="0">false</ReplacementInd>
          <TobaccoInd tc="0">false</TobaccoInd>

          <MedicalCondition id="MC_1">
            <MedCondType tc="26">Elevated Cholesterol</MedCondType>
            <ConditionDescription>Total cholesterol 225, controlled with diet</ConditionDescription>
            <OnsetDate>2023-06-15</OnsetDate>
            <MedCondStatus tc="1">Active</MedCondStatus>
            <TreatmentInd tc="1">true</TreatmentInd>
          </MedicalCondition>

          <SubstanceUsage id="SU_1">
            <SubstanceType tc="1">Tobacco</SubstanceType>
            <SubstanceUsageStatus tc="3">Never Used</SubstanceUsageStatus>
          </SubstanceUsage>

          <SubstanceUsage id="SU_2">
            <SubstanceType tc="2">Alcohol</SubstanceType>
            <SubstanceUsageStatus tc="1">Current User</SubstanceUsageStatus>
            <SubstanceUsageFrequency tc="4">Weekly</SubstanceUsageFrequency>
            <SubstanceUsageQty>4</SubstanceUsageQty>
            <SubstanceUsageQtyUnits tc="42">Drinks</SubstanceUsageQtyUnits>
          </SubstanceUsage>

          <FamilyHistory id="FH_1">
            <FamilyMemberRelType tc="1">Father</FamilyMemberRelType>
            <FamilyMemberLiving tc="0">false</FamilyMemberLiving>
            <FamilyMemberDeathAge>72</FamilyMemberDeathAge>
            <FamilyMemberDeathCause tc="3">Heart Disease</FamilyMemberDeathCause>
          </FamilyHistory>

          <FamilyHistory id="FH_2">
            <FamilyMemberRelType tc="2">Mother</FamilyMemberRelType>
            <FamilyMemberLiving tc="1">true</FamilyMemberLiving>
            <FamilyMemberCurrentAge>68</FamilyMemberCurrentAge>
          </FamilyHistory>
        </Risk>

        <Client>
          <PrefLanguage tc="1">English</PrefLanguage>
        </Client>
      </Party>

      <!-- Beneficiary -->
      <Party id="Party_Beneficiary">
        <PartyTypeCode tc="1">Person</PartyTypeCode>
        <Person>
          <FirstName>Sarah</FirstName>
          <LastName>Smith</LastName>
          <Gender tc="2">Female</Gender>
          <BirthDate>1990-03-22</BirthDate>
        </Person>
      </Party>

      <!-- Owner (same as insured in this case) -->
      <Party id="Party_Owner">
        <PartyTypeCode tc="1">Person</PartyTypeCode>
      </Party>

      <!-- Agent/Producer -->
      <Party id="Party_Agent">
        <PartyTypeCode tc="1">Person</PartyTypeCode>
        <Person>
          <FirstName>Michael</FirstName>
          <LastName>Johnson</LastName>
        </Person>
        <Producer>
          <CarrierAppointment>
            <CompanyProducerID>AGT-88421</CompanyProducerID>
            <CarrierCode>ACME_LIFE</CarrierCode>
          </CarrierAppointment>
        </Producer>
      </Party>

      <!-- ======================= RELATIONS ======================= -->
      <Relation id="Rel_1"
                OriginatingObjectID="Holding_1"
                RelatedObjectID="Party_Insured"
                OriginatingObjectType="Holding"
                RelatedObjectType="Party">
        <RelationRoleCode tc="32">Insured</RelationRoleCode>
      </Relation>

      <Relation id="Rel_2"
                OriginatingObjectID="Holding_1"
                RelatedObjectID="Party_Owner"
                OriginatingObjectType="Holding"
                RelatedObjectType="Party">
        <RelationRoleCode tc="8">Owner</RelationRoleCode>
      </Relation>

      <Relation id="Rel_3"
                OriginatingObjectID="Holding_1"
                RelatedObjectID="Party_Beneficiary"
                OriginatingObjectType="Holding"
                RelatedObjectType="Party">
        <RelationRoleCode tc="34">Primary Beneficiary</RelationRoleCode>
        <InterestPercent>100</InterestPercent>
      </Relation>

      <Relation id="Rel_4"
                OriginatingObjectID="Holding_1"
                RelatedObjectID="Party_Agent"
                OriginatingObjectType="Holding"
                RelatedObjectType="Party">
        <RelationRoleCode tc="37">Agent</RelationRoleCode>
        <VolumeSharePct>100</VolumeSharePct>
      </Relation>
    </OLifE>
  </TXLifeRequest>
</TXLife>
```

#### 1.2.4 Full XML Example — Underwriting Status Update (TransType 121)

```xml
<?xml version="1.0" encoding="UTF-8"?>
<TXLife xmlns="http://ACORD.org/Standards/Life/2" Version="2.43.00">
  <TXLifeRequest PrimaryObjectID="Holding_1">
    <TransRefGUID>b2c3d4e5-f6a7-8901-bcde-f12345678901</TransRefGUID>
    <TransType tc="121">Underwriting Status Update</TransType>
    <TransExeDate>2026-04-18</TransExeDate>
    <TransExeTime>09:15:00-05:00</TransExeTime>

    <OLifE>
      <SourceInfo>
        <CreationDate>2026-04-18</CreationDate>
        <SourceInfoName>AcmeLifeUWEngine</SourceInfoName>
      </SourceInfo>

      <Holding id="Holding_1">
        <HoldingTypeCode tc="2">Policy</HoldingTypeCode>
        <HoldingStatus tc="12">Underwriting In Progress</HoldingStatus>

        <Policy id="Policy_1">
          <PolNumber>PENDING-20260416-001</PolNumber>

          <ApplicationInfo>
            <TrackingID>DIST-TRK-2026-88421</TrackingID>
            <ApplicationType tc="1">New</ApplicationType>
            <UnderwritingApproval tc="1000500003">Pending Review</UnderwritingApproval>
          </ApplicationInfo>

          <!-- Updated Requirement Statuses -->
          <RequirementInfo id="Req_1">
            <ReqCode tc="1">Blood Profile</ReqCode>
            <ReqStatus tc="2">Received</ReqStatus>
            <StatusDate>2026-04-17</StatusDate>
            <RequirementInfoUniqueID>LAB-2026-991234</RequirementInfoUniqueID>
            <FulfilledDate>2026-04-17</FulfilledDate>
            <ServiceProviderCode>EXAMONE</ServiceProviderCode>
          </RequirementInfo>

          <RequirementInfo id="Req_2">
            <ReqCode tc="3">Urinalysis</ReqCode>
            <ReqStatus tc="2">Received</ReqStatus>
            <StatusDate>2026-04-17</StatusDate>
            <FulfilledDate>2026-04-17</FulfilledDate>
            <ServiceProviderCode>EXAMONE</ServiceProviderCode>
          </RequirementInfo>

          <RequirementInfo id="Req_3">
            <ReqCode tc="25">MIB Check</ReqCode>
            <ReqStatus tc="2">Received</ReqStatus>
            <StatusDate>2026-04-16</StatusDate>
          </RequirementInfo>

          <RequirementInfo id="Req_4">
            <ReqCode tc="28">Motor Vehicle Report</ReqCode>
            <ReqStatus tc="2">Received</ReqStatus>
            <StatusDate>2026-04-17</StatusDate>
            <ServiceProviderCode>LEXISNEXIS</ServiceProviderCode>
          </RequirementInfo>

          <RequirementInfo id="Req_5">
            <ReqCode tc="34">Prescription History</ReqCode>
            <ReqStatus tc="2">Received</ReqStatus>
            <StatusDate>2026-04-16</StatusDate>
            <ServiceProviderCode>MILLIMAN</ServiceProviderCode>
          </RequirementInfo>

          <RequirementInfo id="Req_6">
            <ReqCode tc="22">Attending Physician Statement</ReqCode>
            <ReqStatus tc="1">Outstanding</ReqStatus>
            <RequestedDate>2026-04-18</RequestedDate>
            <ServiceProviderCode>PARAMEDS_APS</ServiceProviderCode>
            <RequirementDetails>APS ordered for cholesterol history</RequirementDetails>
          </RequirementInfo>
        </Policy>
      </Holding>

      <Party id="Party_Insured">
        <PartyTypeCode tc="1">Person</PartyTypeCode>
        <Person>
          <FirstName>John</FirstName>
          <LastName>Smith</LastName>
        </Person>

        <Risk>
          <LabTesting id="LabTest_1">
            <LabTestPerformedDate>2026-04-17</LabTestPerformedDate>
            <LabTestVendorCode>EXAMONE</LabTestVendorCode>
            <LabTestResult id="LTR_1">
              <TestCode tc="1101">Total Cholesterol</TestCode>
              <ResultValue>228</ResultValue>
              <UnitOfMeasure tc="mg/dL">mg/dL</UnitOfMeasure>
              <NormalRange>125-200</NormalRange>
              <AbnormalInd tc="1">true</AbnormalInd>
            </LabTestResult>
            <LabTestResult id="LTR_2">
              <TestCode tc="1102">HDL Cholesterol</TestCode>
              <ResultValue>55</ResultValue>
              <UnitOfMeasure tc="mg/dL">mg/dL</UnitOfMeasure>
              <NormalRange>40-60</NormalRange>
              <AbnormalInd tc="0">false</AbnormalInd>
            </LabTestResult>
            <LabTestResult id="LTR_3">
              <TestCode tc="1103">LDL Cholesterol</TestCode>
              <ResultValue>148</ResultValue>
              <UnitOfMeasure tc="mg/dL">mg/dL</UnitOfMeasure>
              <NormalRange>0-130</NormalRange>
              <AbnormalInd tc="1">true</AbnormalInd>
            </LabTestResult>
            <LabTestResult id="LTR_4">
              <TestCode tc="1110">Glucose (Fasting)</TestCode>
              <ResultValue>95</ResultValue>
              <UnitOfMeasure tc="mg/dL">mg/dL</UnitOfMeasure>
              <NormalRange>65-99</NormalRange>
              <AbnormalInd tc="0">false</AbnormalInd>
            </LabTestResult>
            <LabTestResult id="LTR_5">
              <TestCode tc="1112">HbA1c</TestCode>
              <ResultValue>5.4</ResultValue>
              <UnitOfMeasure tc="%">%</UnitOfMeasure>
              <NormalRange>4.0-5.6</NormalRange>
              <AbnormalInd tc="0">false</AbnormalInd>
            </LabTestResult>
          </LabTesting>
        </Risk>
      </Party>
    </OLifE>
  </TXLifeRequest>
</TXLife>
```

#### 1.2.5 Full XML Example — Policy Issue (TransType 228)

```xml
<?xml version="1.0" encoding="UTF-8"?>
<TXLife xmlns="http://ACORD.org/Standards/Life/2" Version="2.43.00">
  <TXLifeResponse>
    <TransRefGUID>c3d4e5f6-a7b8-9012-cdef-123456789012</TransRefGUID>
    <TransType tc="228">Policy Issue</TransType>
    <TransExeDate>2026-04-25</TransExeDate>
    <TransExeTime>16:00:00-05:00</TransExeTime>

    <TransResult>
      <ResultCode tc="1">Success</ResultCode>
      <ResultInfo>
        <ResultInfoCode tc="0">Success</ResultInfoCode>
        <ResultInfoDesc>Policy issued as applied for</ResultInfoDesc>
      </ResultInfo>
    </TransResult>

    <OLifE>
      <Holding id="Holding_1">
        <HoldingTypeCode tc="2">Policy</HoldingTypeCode>
        <HoldingStatus tc="2">Active</HoldingStatus>

        <Policy id="Policy_1">
          <PolNumber>ACME-TERM-2026-00045821</PolNumber>
          <LineOfBusiness tc="1">Life</LineOfBusiness>
          <ProductType tc="1">Term Life</ProductType>
          <ProductCode>TERM20_PREFERRED</ProductCode>
          <IssueDate>2026-04-25</IssueDate>
          <EffDate>2026-04-25</EffDate>
          <TermDate>2046-04-25</TermDate>
          <PolicyStatus tc="1">Active</PolicyStatus>
          <PaymentMode tc="12">Monthly</PaymentMode>
          <PaymentAmt>82.50</PaymentAmt>

          <Life>
            <FaceAmt>500000</FaceAmt>
            <Coverage id="Coverage_1">
              <LifeCovTypeCode tc="1">Base</LifeCovTypeCode>
              <CurrentAmt>500000</CurrentAmt>
              <EffDate>2026-04-25</EffDate>
              <TermDate>2046-04-25</TermDate>
            </Coverage>
          </Life>

          <ApplicationInfo>
            <TrackingID>DIST-TRK-2026-88421</TrackingID>
            <UnderwritingApproval tc="1">Approved</UnderwritingApproval>
            <UnderwritingClass tc="1">Preferred Non-Tobacco</UnderwritingClass>
          </ApplicationInfo>

          <UnderwritingResult>
            <UnderwritingResultReason tc="1">Standard Issue</UnderwritingResultReason>
            <UnderwritingDecisionDate>2026-04-25</UnderwritingDecisionDate>
            <FinalUnderwriterName>AutoUW Engine v4.2</FinalUnderwriterName>
            <STPIndicator>true</STPIndicator>
          </UnderwritingResult>
        </Policy>
      </Holding>

      <Party id="Party_Insured">
        <PartyTypeCode tc="1">Person</PartyTypeCode>
        <Person>
          <FirstName>John</FirstName>
          <LastName>Smith</LastName>
          <BirthDate>1988-07-15</BirthDate>
        </Person>
      </Party>

      <Relation id="Rel_1"
                OriginatingObjectID="Holding_1"
                RelatedObjectID="Party_Insured"
                OriginatingObjectType="Holding"
                RelatedObjectType="Party">
        <RelationRoleCode tc="32">Insured</RelationRoleCode>
      </Relation>
    </OLifE>
  </TXLifeResponse>
</TXLife>
```

### 1.3 ACORD Forms

#### 1.3.1 Key Forms for Term Life Underwriting

| Form # | Name | Usage |
|--------|------|-------|
| **ACORD 103** | Application for Life Insurance | Standard life application — Part 1 (general info) and Part 2 (medical history) |
| **ACORD 121** | Underwriting Requirements | Communication of evidence requirements between carrier, distributor, and vendor |
| **ACORD 125** | Commercial Insurance Application | Not life-specific; used for cross-sell context |
| **ACORD 130** | Workers Compensation Application | Not directly relevant; included for cross-reference |
| **ACORD 160** | HIV Consent | Authorization for HIV testing as part of lab panel |
| **ACORD 161** | Authorization for Release | HIPAA authorization for medical records |

#### 1.3.2 ACORD 103 — Structure Deep Dive

The ACORD 103 maps directly to TXLife XML elements:

| 103 Section | Description | TXLife Mapping |
|------------|-------------|----------------|
| Section A | Proposed Insured Info | `Party/Person` (name, DOB, SSN, gender) |
| Section B | Coverage Requested | `Holding/Policy/Life/Coverage` |
| Section C | Beneficiary | `Party` + `Relation` with `RelationRoleCode tc="34"` |
| Section D | Owner Information | `Party` + `Relation` with `RelationRoleCode tc="8"` |
| Section E | Employment & Income | `Party/Employment` |
| Section F | Existing Insurance | `Party/Risk/ExistingInsuranceInd` + separate `Holding` objects |
| Section G | Medical History Part 1 | `Party/Risk/MedicalCondition` |
| Section H | Medical History Part 2 | `Party/Risk/MedicalCondition` (additional detail) |
| Section I | Tobacco/Substance Use | `Party/Risk/SubstanceUsage` |
| Section J | Family History | `Party/Risk/FamilyHistory` |
| Section K | Aviation/Avocation | `Party/Risk/AviationExp`, `Party/Risk/AvocationRisk` |
| Section L | Agent Report | `Party[Producer]` observations |
| Section M | Signatures & Declarations | `ApplicationInfo/SignedDate` |

### 1.4 ACORD Code Tables (OLI_ Type Codes)

ACORD uses a system of **type codes** (tc values) for all enumerated fields. These are referred to with the prefix `OLI_` in documentation.

#### 1.4.1 Common Code Tables for Underwriting

**OLI_LU_GENDER — Gender Codes**

| tc Value | Description |
|----------|-------------|
| 1 | Male |
| 2 | Female |
| 3 | Unisex |

**OLI_LU_SMOKERSTAT — Tobacco Status**

| tc Value | Description |
|----------|-------------|
| 1 | Never Smoked |
| 2 | Current Smoker |
| 3 | Former Smoker |
| 4 | Smoker — Unknown Frequency |

**OLI_LU_MARSTAT — Marital Status**

| tc Value | Description |
|----------|-------------|
| 1 | Married |
| 2 | Single |
| 3 | Divorced |
| 4 | Widowed |
| 5 | Separated |
| 6 | Domestic Partner |

**OLI_LU_UWCLASS — Underwriting Classification**

| tc Value | Description |
|----------|-------------|
| 1 | Preferred Non-Tobacco |
| 2 | Preferred Tobacco |
| 3 | Standard Non-Tobacco |
| 4 | Standard Tobacco |
| 5 | Substandard / Rated |
| 6 | Super Preferred Non-Tobacco |
| 7 | Super Preferred Tobacco |

**OLI_LU_UWACTION — Underwriting Decision**

| tc Value | Description |
|----------|-------------|
| 1 | Approve as Applied |
| 2 | Approve with Modification |
| 3 | Decline |
| 4 | Postpone |
| 5 | Incomplete |
| 6 | Counter Offer |

**OLI_LU_REQCODE — Requirement Type Codes (partial)**

| tc Value | Description |
|----------|-------------|
| 1 | Blood Profile |
| 2 | EKG |
| 3 | Urinalysis |
| 5 | Paramedical Exam |
| 11 | Inspection Report |
| 22 | Attending Physician Statement |
| 25 | MIB Check |
| 28 | Motor Vehicle Report |
| 34 | Prescription History |
| 36 | Credit Report |
| 37 | Treadmill / Stress Test |
| 39 | Cognitive Assessment |
| 43 | Phone Interview |
| 50 | eApplication |
| 95 | Electronic Health Record |

**OLI_LU_REQSTAT — Requirement Status Codes**

| tc Value | Description |
|----------|-------------|
| 1 | Outstanding (ordered but not received) |
| 2 | Received |
| 3 | Waived |
| 4 | Cancelled |
| 5 | Complete |
| 6 | In Review |

**OLI_LU_STATE — US State/Territory Codes**

| tc Value | State |
|----------|-------|
| 1 | Alabama |
| 2 | Alaska |
| 3 | Arizona |
| 4 | Arkansas |
| 5 | California |
| 6 | Colorado |
| ... | (all 50 states + territories follow sequentially) |

### 1.5 ACORD JSON Emerging Standard

ACORD has released a **JSON-LD** based schema for modern API integrations. Key features:

- Based on JSON-LD (Linked Data) for semantic interoperability.
- Uses ACORD Data Dictionary as the vocabulary.
- RESTful API patterns instead of SOAP/XML.
- Still in early adoption (2024–2026+); most carriers still use TXLife XML.

#### 1.5.1 ACORD JSON Application Example (Simplified)

```json
{
  "@context": "https://standards.acord.org/json-ld/life/v1",
  "@type": "LifeApplication",
  "transactionId": "a1b2c3d4-e5f6-7890-abcd-ef1234567890",
  "transactionType": "NewApplication",
  "transactionDate": "2026-04-16T14:30:00-05:00",
  "holding": {
    "@type": "PolicyHolding",
    "status": "Proposed",
    "policy": {
      "policyNumber": "PENDING-20260416-001",
      "lineOfBusiness": "Life",
      "productType": "TermLife",
      "productCode": "TERM20_PREFERRED",
      "life": {
        "faceAmount": {
          "value": 500000,
          "currency": "USD"
        },
        "coverages": [
          {
            "coverageType": "Base",
            "amount": { "value": 500000, "currency": "USD" },
            "effectiveDate": "2026-04-16",
            "terminationDate": "2046-04-16"
          }
        ]
      },
      "applicationInfo": {
        "trackingId": "DIST-TRK-2026-88421",
        "applicationType": "New",
        "submissionDate": "2026-04-16",
        "submissionType": "Electronic",
        "jurisdiction": "US-CO"
      }
    }
  },
  "parties": [
    {
      "@type": "Person",
      "partyId": "Party_Insured",
      "role": "Insured",
      "governmentId": {
        "type": "SSN",
        "value": "123-45-6789"
      },
      "name": {
        "first": "John",
        "middle": "Robert",
        "last": "Smith"
      },
      "dateOfBirth": "1988-07-15",
      "gender": "Male",
      "tobaccoStatus": "NeverSmoked",
      "biometrics": {
        "heightInches": 71,
        "weightPounds": 185
      },
      "address": {
        "type": "Residence",
        "line1": "123 Mountain View Drive",
        "city": "Denver",
        "state": "CO",
        "postalCode": "80202",
        "country": "US"
      },
      "riskFactors": {
        "medicalConditions": [
          {
            "conditionType": "ElevatedCholesterol",
            "onsetDate": "2023-06-15",
            "status": "Active",
            "underTreatment": true
          }
        ],
        "familyHistory": [
          {
            "relationship": "Father",
            "living": false,
            "deathAge": 72,
            "causeOfDeath": "HeartDisease"
          }
        ]
      }
    },
    {
      "@type": "Person",
      "partyId": "Party_Beneficiary",
      "role": "PrimaryBeneficiary",
      "name": { "first": "Sarah", "last": "Smith" },
      "benefitPercentage": 100
    }
  ]
}
```

#### 1.5.2 Migration Path: TXLife XML to ACORD JSON

| Aspect | TXLife XML | ACORD JSON |
|--------|-----------|------------|
| **Transport** | SOAP / HTTPS POST | REST / HTTPS |
| **Schema** | XSD | JSON Schema + JSON-LD |
| **ID References** | `id` / `ObjectID` attributes | JSON `$ref` or embedded IDs |
| **Code Tables** | `tc` numeric values | Human-readable enum strings |
| **Adoption** | Universal (2000+) | Early adopters (2024+) |
| **Tooling** | Mature (JAXB, XMLBeans) | Modern (OpenAPI, Swagger) |
| **Recommended Approach** | Maintain for legacy vendors | Build for new integrations |

---

## 2. MIB (Medical Information Bureau)

### 2.1 Overview

The **MIB** (Medical Information Bureau, Inc.) is a not-for-profit membership corporation of ~400 life insurance companies in the US and Canada. MIB maintains a database of **coded medical conditions** reported by member companies during previous insurance applications. It is NOT a medical records repository — it contains only coded signals that an applicant disclosed or was found to have certain conditions during a prior insurance application process.

### 2.2 How MIB Works in Underwriting

```
┌─────────────┐     ┌─────────┐     ┌─────────────┐
│  Applicant   │────▶│ Carrier │────▶│   MIB DB    │
│ (John Smith) │     │  (UW)   │     │             │
└─────────────┘     └────┬────┘     └──────┬──────┘
                         │                  │
                    1. Submit inquiry  2. Return hits
                    (name, DOB, SSN)   (coded conditions)
                         │                  │
                    ┌────▼──────────────────▼────┐
                    │  Underwriter Reviews Hits   │
                    │  Compares to application    │
                    │  Orders follow-up if needed │
                    └────────────────────────────┘
```

**Key Principles:**

1. **Inquiry**: Every applicant for individually underwritten life insurance is checked against MIB.
2. **Hit**: If the applicant was previously coded by another member company, the inquiry returns one or more MIB codes.
3. **No Hit**: Absence of codes does NOT mean absence of conditions — only that no prior carrier coded them.
4. **Coding Obligation**: Member companies must report codes within 25 business days of discovering a significant medical condition or risk factor.
5. **Code Retention**: MIB codes are retained for **7 years** from the date of the most recent report.

### 2.3 MIB Code Structure

Each MIB code consists of:

```
[3-digit condition code] [1-digit severity indicator]
```

**Severity Indicators:**

| Severity | Meaning |
|----------|---------|
| 0 | Not rated or not otherwise classified |
| 1 | Mild / Minor |
| 2 | Moderate |
| 3 | Severe |
| 4 | Very Severe / Life-threatening |
| 5 | Additional information needed |

**Example:** `013 2` = Coronary Artery Disease (013), Moderate severity (2).

### 2.4 Complete MIB Code Category Reference

#### Cardiovascular Conditions (010–019)

| Code | Condition | Example Trigger |
|------|-----------|-----------------|
| 010 | Hypertension | BP consistently > 140/90 |
| 011 | Heart Murmur | Detected on paramedical exam |
| 012 | Cardiac Arrhythmia | Atrial fibrillation, PVCs |
| 013 | Coronary Artery Disease | History of angina, CAD diagnosis |
| 014 | Myocardial Infarction | Prior heart attack |
| 015 | Congestive Heart Failure | CHF diagnosis |
| 016 | Valvular Heart Disease | Mitral valve prolapse, aortic stenosis |
| 017 | Peripheral Vascular Disease | PAD diagnosis |
| 018 | Cerebrovascular Disease | TIA, stroke history |
| 019 | Other Cardiovascular | Cardiomyopathy, pericarditis |

#### Respiratory Conditions (020–029)

| Code | Condition | Example Trigger |
|------|-----------|-----------------|
| 020 | Asthma | Chronic asthma, inhaler use |
| 021 | COPD | Chronic bronchitis, emphysema |
| 022 | Pulmonary Fibrosis | Diagnosed fibrotic lung disease |
| 023 | Sleep Apnea | Diagnosed OSA, CPAP use |
| 024 | Pneumonia (recurrent) | Multiple hospitalizations |
| 025 | Tuberculosis | Active or latent TB |
| 026 | Sarcoidosis | Pulmonary sarcoidosis |
| 027 | Pulmonary Embolism | History of PE |
| 028 | Pulmonary Hypertension | Diagnosed PH |
| 029 | Other Respiratory | Interstitial lung disease |

#### Gastrointestinal Conditions (030–039)

| Code | Condition | Example Trigger |
|------|-----------|-----------------|
| 030 | GERD / Esophageal | Chronic reflux, Barrett's esophagus |
| 031 | Peptic Ulcer Disease | Gastric/duodenal ulcers |
| 032 | Inflammatory Bowel Disease | Crohn's disease, ulcerative colitis |
| 033 | Hepatitis | Hepatitis B or C |
| 034 | Cirrhosis | Liver cirrhosis from any cause |
| 035 | Pancreatitis | Acute or chronic pancreatitis |
| 036 | Gallbladder Disease | Cholecystitis, cholelithiasis |
| 037 | Gastrointestinal Bleeding | Upper or lower GI bleed |
| 038 | Liver Enzyme Elevation | Persistent ALT/AST elevation |
| 039 | Other GI | Celiac disease, diverticulitis |

#### Endocrine/Metabolic Conditions (040–049)

| Code | Condition | Example Trigger |
|------|-----------|-----------------|
| 040 | Diabetes Mellitus — Type 1 | Insulin-dependent diabetes |
| 041 | Diabetes Mellitus — Type 2 | Adult-onset diabetes |
| 042 | Thyroid Disorder | Hypo/hyperthyroidism |
| 043 | Obesity (Morbid) | BMI > 40 |
| 044 | Elevated Cholesterol | Total > 300 or LDL > 190 |
| 045 | Metabolic Syndrome | Multiple metabolic risk factors |
| 046 | Adrenal Disorder | Cushing's, Addison's |
| 047 | Pituitary Disorder | Acromegaly, prolactinoma |
| 048 | Gout | Chronic gout with treatment |
| 049 | Other Endocrine/Metabolic | Rare metabolic disorders |

#### Genitourinary Conditions (050–059)

| Code | Condition | Example Trigger |
|------|-----------|-----------------|
| 050 | Kidney Disease | Chronic kidney disease, nephritis |
| 051 | Kidney Stones (recurrent) | Multiple episodes |
| 052 | Prostate Disorder | BPH, elevated PSA |
| 053 | Urinary Tract Issues | Chronic UTIs, hematuria |
| 054 | Renal Failure | Dialysis, transplant |
| 055 | Proteinuria | Persistent protein in urine |
| 059 | Other Genitourinary | Bladder disorders |

#### Musculoskeletal Conditions (060–069)

| Code | Condition | Example Trigger |
|------|-----------|-----------------|
| 060 | Rheumatoid Arthritis | Diagnosed RA |
| 061 | Osteoarthritis (severe) | Joint replacement |
| 062 | Lupus / SLE | Systemic lupus erythematosus |
| 063 | Back Disorder | Chronic back pain, disc disease |
| 064 | Fibromyalgia | Diagnosed fibromyalgia |
| 065 | Multiple Sclerosis | Diagnosed MS |
| 069 | Other Musculoskeletal | Ankylosing spondylitis |

#### Neoplastic Conditions (070–079)

| Code | Condition | Example Trigger |
|------|-----------|-----------------|
| 070 | Malignant Neoplasm — Skin | Melanoma, non-melanoma skin cancer |
| 071 | Malignant Neoplasm — Breast | Breast cancer |
| 072 | Malignant Neoplasm — Lung | Lung cancer |
| 073 | Malignant Neoplasm — Colon | Colorectal cancer |
| 074 | Malignant Neoplasm — Prostate | Prostate cancer |
| 075 | Leukemia/Lymphoma | Blood cancers |
| 076 | Benign Neoplasm | Benign tumors requiring monitoring |
| 077 | Malignant Neoplasm — Other | Brain, kidney, liver, etc. |
| 079 | Neoplasm — Unspecified | Cancer type not specified |

#### Neurological/Psychiatric Conditions (080–099)

| Code | Condition | Example Trigger |
|------|-----------|-----------------|
| 080 | Epilepsy / Seizure | Seizure disorder |
| 081 | Migraine (severe) | Chronic migraine with treatment |
| 082 | Parkinson's Disease | Diagnosed PD |
| 083 | Alzheimer's / Dementia | Cognitive decline diagnosis |
| 084 | Neuropathy | Peripheral neuropathy |
| 090 | Depression | Major depressive disorder |
| 091 | Anxiety Disorder | Generalized anxiety, panic disorder |
| 092 | Bipolar Disorder | Diagnosed bipolar |
| 093 | Schizophrenia | Schizophrenia or schizoaffective |
| 094 | Substance Abuse — Alcohol | Alcohol use disorder |
| 095 | Substance Abuse — Drugs | Drug use disorder |
| 096 | Eating Disorder | Anorexia, bulimia |
| 097 | PTSD | Post-traumatic stress disorder |
| 098 | Suicide Attempt | History of attempt |
| 099 | Other Neurological/Psychiatric | ADHD, OCD (when severe) |

#### Non-Medical Risk Codes (100–120)

| Code | Condition | Example Trigger |
|------|-----------|-----------------|
| 100 | Hazardous Occupation | Mining, commercial fishing |
| 101 | Aviation (non-commercial) | Private pilot |
| 102 | Hazardous Avocation | Skydiving, rock climbing |
| 103 | Foreign Residence/Travel | Residence in high-risk country |
| 104 | DUI/DWI | Driving under influence |
| 105 | Criminal History | Felony conviction |
| 106 | Financial Risk | Bankruptcy, excessive coverage |
| 110 | Tobacco Use | Cigarettes, cigars, chewing tobacco |
| 111 | Marijuana Use | Regular cannabis use |
| 120 | HIV/AIDS | HIV positive status |

### 2.5 MIB Inquiry vs. Hit — Data Flow

```
INQUIRY REQUEST (Carrier → MIB)
┌─────────────────────────────────┐
│  Name: John Robert Smith        │
│  DOB: 1988-07-15                │
│  SSN: 123-45-6789               │
│  Gender: Male                   │
│  State: Colorado                │
│  Carrier Code: ACMELIFE         │
│  Inquiry Date: 2026-04-16       │
│  Policy Amount: $500,000        │
└─────────────────────────────────┘

INQUIRY RESPONSE (MIB → Carrier) — Hit Scenario
┌─────────────────────────────────────────────────────────┐
│  Match Found: YES                                       │
│  Match Confidence: HIGH (SSN + Name + DOB match)        │
│                                                         │
│  Code 1: 044-1  Elevated Cholesterol, Mild              │
│    Reported By: COMPANY_XYZ                             │
│    Report Date: 2024-02-15                              │
│    Application Date: 2024-01-20                         │
│                                                         │
│  Code 2: 010-1  Hypertension, Mild                      │
│    Reported By: COMPANY_XYZ                             │
│    Report Date: 2024-02-15                              │
│    Application Date: 2024-01-20                         │
│                                                         │
│  Follow-Up Code: NONE                                   │
│  Plan F Status: ENROLLED                                │
└─────────────────────────────────────────────────────────┘

INQUIRY RESPONSE (MIB → Carrier) — No Hit Scenario
┌─────────────────────────────────────────────────────────┐
│  Match Found: NO                                        │
│  No codes on file for this individual                   │
└─────────────────────────────────────────────────────────┘
```

### 2.6 TXLife Integration for MIB

#### 2.6.1 MIB Inquiry Request (within TXLife)

```xml
<TXLifeRequest>
  <TransRefGUID>mib-inquiry-001</TransRefGUID>
  <TransType tc="152">Requirement Order</TransType>
  <TransSubType tc="15225">MIB Inquiry</TransSubType>
  <TransExeDate>2026-04-16</TransExeDate>

  <OLifE>
    <Holding id="H1">
      <Policy>
        <PolNumber>PENDING-20260416-001</PolNumber>
        <RequirementInfo id="MIB_REQ_1">
          <ReqCode tc="25">MIB Check</ReqCode>
          <ReqStatus tc="1">Outstanding</ReqStatus>
          <RequestedDate>2026-04-16</RequestedDate>
        </RequirementInfo>
      </Policy>
    </Holding>

    <Party id="P1">
      <GovtID>123-45-6789</GovtID>
      <GovtIDTC tc="1">SSN</GovtIDTC>
      <Person>
        <FirstName>John</FirstName>
        <MiddleName>Robert</MiddleName>
        <LastName>Smith</LastName>
        <Gender tc="1">Male</Gender>
        <BirthDate>1988-07-15</BirthDate>
      </Person>
      <Address>
        <AddressStateTC tc="6">Colorado</AddressStateTC>
      </Address>
    </Party>

    <Relation OriginatingObjectID="H1" RelatedObjectID="P1">
      <RelationRoleCode tc="32">Insured</RelationRoleCode>
    </Relation>
  </OLifE>
</TXLifeRequest>
```

#### 2.6.2 MIB Hit Response (within TXLife)

```xml
<TXLifeResponse>
  <TransRefGUID>mib-response-001</TransRefGUID>
  <TransType tc="153">Requirement Result</TransType>
  <TransSubType tc="15325">MIB Result</TransSubType>
  <TransExeDate>2026-04-16</TransExeDate>

  <TransResult>
    <ResultCode tc="1">Success</ResultCode>
  </TransResult>

  <OLifE>
    <Holding id="H1">
      <Policy>
        <RequirementInfo id="MIB_REQ_1">
          <ReqCode tc="25">MIB Check</ReqCode>
          <ReqStatus tc="2">Received</ReqStatus>
          <FulfilledDate>2026-04-16</FulfilledDate>

          <!-- MIB-specific extension for coded hits -->
          <OLifEExtension VendorCode="MIB">
            <MIBInquiryResult>
              <MatchIndicator>true</MatchIndicator>
              <MatchConfidence>HIGH</MatchConfidence>
              <TotalCodesReturned>2</TotalCodesReturned>

              <MIBCodedHit sequence="1">
                <MIBCode>044</MIBCode>
                <MIBSeverity>1</MIBSeverity>
                <MIBCodeDescription>Elevated Cholesterol</MIBCodeDescription>
                <SeverityDescription>Mild</SeverityDescription>
                <ReportingCompanyCode>COMPANY_XYZ</ReportingCompanyCode>
                <ReportDate>2024-02-15</ReportDate>
                <ApplicationDate>2024-01-20</ApplicationDate>
              </MIBCodedHit>

              <MIBCodedHit sequence="2">
                <MIBCode>010</MIBCode>
                <MIBSeverity>1</MIBSeverity>
                <MIBCodeDescription>Hypertension</MIBCodeDescription>
                <SeverityDescription>Mild</SeverityDescription>
                <ReportingCompanyCode>COMPANY_XYZ</ReportingCompanyCode>
                <ReportDate>2024-02-15</ReportDate>
                <ApplicationDate>2024-01-20</ApplicationDate>
              </MIBCodedHit>

              <FollowUpCode>NONE</FollowUpCode>
              <PlanFStatus>ENROLLED</PlanFStatus>
            </MIBInquiryResult>
          </OLifEExtension>
        </RequirementInfo>
      </Policy>
    </Holding>
  </OLifE>
</TXLifeResponse>
```

### 2.7 MIB Follow-Up Codes

When an MIB hit indicates potentially significant information, the MIB may return follow-up codes instructing the carrier to obtain additional evidence before making an underwriting decision.

| Follow-Up Code | Meaning | Carrier Action Required |
|---------------|---------|------------------------|
| `NONE` | No follow-up required | Standard processing |
| `FU-APS` | Recommend APS | Order Attending Physician Statement |
| `FU-LAB` | Recommend Lab | Order blood/urine testing |
| `FU-EXAM` | Recommend Exam | Order paramedical or medical exam |
| `FU-MVR` | Recommend MVR | Order Motor Vehicle Report |
| `FU-PHONE` | Recommend Phone Interview | Conduct tele-interview |
| `FU-MULTI` | Multiple follow-ups | Combination of the above |

### 2.8 MIB Plan F

**MIB Plan F** is a follow-up service that helps carriers detect situations where an applicant may be applying to multiple companies simultaneously (potentially indicating adverse selection or fraud).

**How Plan F Works:**

1. When a carrier submits an MIB inquiry, MIB records the inquiry.
2. If another carrier inquires on the same individual within a configurable window (typically 60–90 days), both carriers are notified.
3. The notification does NOT disclose which other carrier inquired — only that another inquiry exists.

**Plan F Notification (within TXLife):**

```xml
<OLifEExtension VendorCode="MIB">
  <MIBPlanFNotification>
    <PlanFEnrolled>true</PlanFEnrolled>
    <ConcurrentInquiryDetected>true</ConcurrentInquiryDetected>
    <NumberOfConcurrentInquiries>1</NumberOfConcurrentInquiries>
    <InquiryWindowDays>90</InquiryWindowDays>
    <NotificationDate>2026-04-16</NotificationDate>
    <!-- Note: The identity of the other carrier is NOT disclosed -->
  </MIBPlanFNotification>
</OLifEExtension>
```

**Underwriting Action on Plan F Alert:**

- Increased scrutiny on financial justification.
- Verify total coverage across all carriers doesn't exceed financial guidelines.
- May trigger additional requirements (financial questionnaire, tax returns).

### 2.9 MIB Coding Obligation — Reporting Back

After underwriting is complete, the carrier must report relevant MIB codes back to MIB:

```xml
<TXLifeRequest>
  <TransRefGUID>mib-report-001</TransRefGUID>
  <TransType tc="152">Requirement Order</TransType>
  <TransSubType tc="15226">MIB Code Report</TransSubType>

  <OLifE>
    <Party id="P1">
      <GovtID>123-45-6789</GovtID>
      <GovtIDTC tc="1">SSN</GovtIDTC>
      <Person>
        <FirstName>John</FirstName>
        <LastName>Smith</LastName>
        <Gender tc="1">Male</Gender>
        <BirthDate>1988-07-15</BirthDate>
      </Person>

      <Risk>
        <OLifEExtension VendorCode="MIB">
          <MIBCodeReport>
            <MIBCodeSubmission sequence="1">
              <MIBCode>044</MIBCode>
              <MIBSeverity>1</MIBSeverity>
              <ConditionDescription>Elevated Cholesterol</ConditionDescription>
              <DiscoveryDate>2026-04-17</DiscoveryDate>
              <DiscoverySource>LabResults</DiscoverySource>
            </MIBCodeSubmission>
          </MIBCodeReport>
        </OLifEExtension>
      </Risk>
    </Party>
  </OLifE>
</TXLifeRequest>
```

---

## 3. Prescription Drug Data (Rx)

### 3.1 Overview

Prescription drug history (Rx data) has become one of the most impactful data sources in accelerated underwriting. It provides a 5–10 year history of medications filled by the applicant, revealing medical conditions, treatment compliance, and lifestyle risk factors that may not be disclosed on the application.

### 3.2 Primary Vendors

| Vendor | Product | Data Source | Coverage |
|--------|---------|-------------|----------|
| **Milliman** | IntelliScript | Pharmacy Benefit Managers (PBMs), retail pharmacies | ~85% of US prescriptions |
| **ExamOne** (Quest) | ScriptCheck | Same PBM/pharmacy network | ~85% of US prescriptions |
| **LexisNexis** | RxScore | Aggregated Rx data | Scoring-only (no detail) |

### 3.3 Milliman IntelliScript — Format Deep Dive

IntelliScript is the most widely used Rx data product in life insurance underwriting. It returns structured prescription fill history.

#### 3.3.1 IntelliScript Response Structure

```json
{
  "intelliScriptReport": {
    "reportId": "IS-2026-04-16-789012",
    "reportDate": "2026-04-16T14:35:00Z",
    "reportStatus": "Complete",
    "subject": {
      "firstName": "John",
      "lastName": "Smith",
      "dateOfBirth": "1988-07-15",
      "ssn": "***-**-6789",
      "matchConfidence": "HIGH"
    },
    "reportSummary": {
      "totalPrescriptions": 12,
      "uniqueMedications": 4,
      "dateRangeStart": "2021-04-01",
      "dateRangeEnd": "2026-04-15",
      "dataSourceCount": 3
    },
    "prescriptions": [
      {
        "fillSequence": 1,
        "fillDate": "2026-03-15",
        "drugName": "ATORVASTATIN CALCIUM",
        "brandName": "LIPITOR",
        "genericIndicator": "G",
        "ndc": "00071015523",
        "ndcFormatted": "0071-0155-23",
        "strength": "20 MG",
        "dosageForm": "TABLET",
        "quantity": 30,
        "daysSupply": 30,
        "refillNumber": 8,
        "prescriberName": "DR. JANE WILLIAMS",
        "prescriberNPI": "1234567890",
        "prescriberSpecialty": "Internal Medicine",
        "pharmacyName": "WALGREENS #12345",
        "pharmacyNPI": "9876543210",
        "pharmacyState": "CO",
        "therapeuticClassCode": "CV350",
        "therapeuticClassName": "Antihyperlipidemic - HMG CoA Reductase Inhibitors",
        "deaSchedule": "N/A",
        "payerType": "COMMERCIAL"
      },
      {
        "fillSequence": 2,
        "fillDate": "2026-02-12",
        "drugName": "ATORVASTATIN CALCIUM",
        "brandName": "LIPITOR",
        "genericIndicator": "G",
        "ndc": "00071015523",
        "strength": "20 MG",
        "dosageForm": "TABLET",
        "quantity": 30,
        "daysSupply": 30,
        "refillNumber": 7,
        "prescriberName": "DR. JANE WILLIAMS",
        "prescriberNPI": "1234567890",
        "prescriberSpecialty": "Internal Medicine",
        "pharmacyName": "WALGREENS #12345",
        "pharmacyNPI": "9876543210",
        "pharmacyState": "CO",
        "therapeuticClassCode": "CV350",
        "therapeuticClassName": "Antihyperlipidemic - HMG CoA Reductase Inhibitors",
        "deaSchedule": "N/A",
        "payerType": "COMMERCIAL"
      },
      {
        "fillSequence": 3,
        "fillDate": "2025-06-20",
        "drugName": "LISINOPRIL",
        "brandName": "ZESTRIL",
        "genericIndicator": "G",
        "ndc": "00310010530",
        "strength": "10 MG",
        "dosageForm": "TABLET",
        "quantity": 30,
        "daysSupply": 30,
        "refillNumber": 3,
        "prescriberName": "DR. JANE WILLIAMS",
        "prescriberNPI": "1234567890",
        "prescriberSpecialty": "Internal Medicine",
        "pharmacyName": "CVS PHARMACY #67890",
        "pharmacyNPI": "5678901234",
        "pharmacyState": "CO",
        "therapeuticClassCode": "CV800",
        "therapeuticClassName": "ACE Inhibitors",
        "deaSchedule": "N/A",
        "payerType": "COMMERCIAL"
      },
      {
        "fillSequence": 4,
        "fillDate": "2024-01-10",
        "drugName": "AMOXICILLIN",
        "brandName": "AMOXIL",
        "genericIndicator": "G",
        "ndc": "65862001705",
        "strength": "500 MG",
        "dosageForm": "CAPSULE",
        "quantity": 21,
        "daysSupply": 7,
        "refillNumber": 0,
        "prescriberName": "DR. MARK DAVIS",
        "prescriberNPI": "1111222233",
        "prescriberSpecialty": "Family Medicine",
        "pharmacyName": "WALGREENS #12345",
        "pharmacyNPI": "9876543210",
        "pharmacyState": "CO",
        "therapeuticClassCode": "AM100",
        "therapeuticClassName": "Penicillins",
        "deaSchedule": "N/A",
        "payerType": "COMMERCIAL"
      }
    ],
    "controlledSubstanceSummary": {
      "scheduleII": 0,
      "scheduleIII": 0,
      "scheduleIV": 0,
      "scheduleV": 0,
      "totalControlled": 0
    }
  }
}
```

#### 3.3.2 IntelliScript via TXLife (Requirement Result)

```xml
<RequirementInfo id="Rx_Result_1">
  <ReqCode tc="34">Prescription History</ReqCode>
  <ReqStatus tc="2">Received</ReqStatus>
  <FulfilledDate>2026-04-16</FulfilledDate>
  <ServiceProviderCode>MILLIMAN</ServiceProviderCode>

  <OLifEExtension VendorCode="MILLIMAN">
    <IntelliScriptResult>
      <ReportID>IS-2026-04-16-789012</ReportID>
      <MatchStatus>MATCH_HIGH</MatchStatus>
      <TotalPrescriptionCount>12</TotalPrescriptionCount>
      <UniqueDrugCount>4</UniqueDrugCount>
      <ControlledSubstanceCount>0</ControlledSubstanceCount>
      <DateRangeStart>2021-04-01</DateRangeStart>
      <DateRangeEnd>2026-04-15</DateRangeEnd>

      <PrescriptionDetail sequence="1">
        <FillDate>2026-03-15</FillDate>
        <DrugName>ATORVASTATIN CALCIUM</DrugName>
        <NDC>00071015523</NDC>
        <Strength>20 MG</Strength>
        <Quantity>30</Quantity>
        <DaysSupply>30</DaysSupply>
        <RefillNumber>8</RefillNumber>
        <TherapeuticClassCode>CV350</TherapeuticClassCode>
        <TherapeuticClassName>HMG CoA Reductase Inhibitors</TherapeuticClassName>
        <PrescriberSpecialty>Internal Medicine</PrescriberSpecialty>
      </PrescriptionDetail>
    </IntelliScriptResult>
  </OLifEExtension>
</RequirementInfo>
```

### 3.4 ExamOne ScriptCheck

ExamOne's ScriptCheck provides similar data with a slightly different structure. Key differences:

| Feature | IntelliScript | ScriptCheck |
|---------|--------------|-------------|
| **Vendor** | Milliman | ExamOne (Quest) |
| **Data Aggregation** | Milliman proprietary | Quest/ExamOne network |
| **Default History** | 5 years | 5 years |
| **Extended History** | Up to 10 years | Up to 7 years |
| **Delivery** | XML, JSON, PDF | XML, PDF |
| **Scoring** | Separate RxScore | Built-in ScriptScore |
| **TXLife Native** | Via OLifEExtension | Native TXLife mapping |

### 3.5 NDC (National Drug Code) System

The NDC is the universal product identifier for drugs in the US. It is a 10-digit or 11-digit code in three segments:

```
NDC Format: LLLL-PPPP-SS (labeler-product-package)

Segment 1: Labeler Code (4 or 5 digits)
  - Identifies the manufacturer, repacker, or distributor
  - Assigned by the FDA

Segment 2: Product Code (3 or 4 digits)
  - Identifies the drug, strength, dosage form
  - Assigned by the labeler

Segment 3: Package Code (1 or 2 digits)
  - Identifies the package size/type
  - Assigned by the labeler

Example: 0071-0155-23
  0071  = Pfizer (labeler)
  0155  = Atorvastatin 20mg Tablet (product)
  23    = Bottle of 90 (package)
```

**NDC Format Variations:**

| Format | Example | Usage |
|--------|---------|-------|
| 4-4-2 | 0071-0155-23 | Standard display |
| 5-3-2 | 00071-155-23 | FDA registration |
| 5-4-1 | 00071-0155-3 | Alternative |
| 11-digit (no dash) | 00071015523 | Database storage |

### 3.6 Therapeutic Class Codes

Rx data vendors use therapeutic classification systems to categorize drugs. The most common systems are:

#### 3.6.1 GPI (Generic Product Identifier) — Medi-Span

```
GPI Structure: XX-XX-XX-XX-XX-XX-XX (14 digits, 7 levels)

Level 1 (2 digits): Drug Group
Level 2 (2 digits): Drug Class
Level 3 (2 digits): Drug Sub-Class
Level 4 (2 digits): Drug Name
Level 5 (2 digits): Drug Name Extension
Level 6 (2 digits): Dosage Form
Level 7 (2 digits): Strength

Example: 39-40-00-20-10-03-20
  39    = Antihyperlipidemics (Drug Group)
  40    = HMG CoA Reductase Inhibitors (Drug Class)
  00    = (Sub-Class)
  20    = Atorvastatin (Drug Name)
  10    = Calcium (Extension)
  03    = Tablet (Dosage Form)
  20    = 20 MG (Strength)
```

#### 3.6.2 Key Therapeutic Classes for Underwriting

| Class Code | Class Name | Underwriting Signal |
|-----------|-----------|-------------------|
| CV350 | HMG CoA Reductase Inhibitors (Statins) | Hyperlipidemia — usually mild UW impact |
| CV800 | ACE Inhibitors | Hypertension — moderate UW impact |
| CV400 | Beta Blockers | Hypertension/cardiac — review needed |
| HS500 | Insulin | Diabetes — significant UW impact |
| HS851 | Sulfonylureas | Type 2 Diabetes — moderate UW impact |
| HS875 | Biguanides (Metformin) | Type 2 Diabetes or PCOS — context-dependent |
| CN300 | Opioid Analgesics | Pain management — high scrutiny |
| CN301 | Opioid Agonists (Suboxone) | Opioid use disorder — high scrutiny |
| CN400 | Anticonvulsants | Epilepsy or neuropathic pain |
| CN550 | Antidepressants — SSRIs | Depression/anxiety — mild to moderate |
| CN700 | Anxiolytics (Benzodiazepines) | Anxiety — moderate, check pattern |
| CN750 | Antipsychotics | Schizophrenia/bipolar — significant |
| RE200 | Bronchodilators | Asthma/COPD |
| BL110 | Anticoagulants | Blood clot history — significant |
| GU600 | Erectile Dysfunction | Usually benign unless cardiovascular |
| ON300 | Antineoplastic Agents | Cancer treatment — major UW impact |

### 3.7 Drug-to-Condition Mapping for Underwriting Rules

The core intelligence in Rx-based underwriting is mapping drugs to implied medical conditions. This is done via a **drug-condition inference table**.

#### 3.7.1 Mapping Approach

```
┌──────────────┐    ┌──────────────────┐    ┌──────────────────┐
│  NDC / Drug  │───▶│  Therapeutic     │───▶│  Implied         │
│  Name        │    │  Class           │    │  Condition(s)    │
└──────────────┘    └──────────────────┘    └──────────────────┘
                                                     │
                                                     ▼
                                            ┌──────────────────┐
                                            │  Underwriting    │
                                            │  Risk Category   │
                                            └──────────────────┘
```

#### 3.7.2 Sample Drug-Condition Mapping Table

| Drug (Generic) | Therapeutic Class | Primary Implied Condition | Secondary Conditions | UW Risk Signal |
|---------------|------------------|--------------------------|---------------------|---------------|
| Atorvastatin | Statin | Hyperlipidemia | Cardiovascular risk | Low-Moderate |
| Lisinopril | ACE Inhibitor | Hypertension | Heart failure, diabetic nephropathy | Moderate |
| Metformin | Biguanide | Type 2 Diabetes | PCOS, prediabetes | Moderate-High |
| Insulin Glargine | Insulin | Diabetes (Type 1 or advanced T2) | — | High |
| Metoprolol | Beta Blocker | Hypertension | Arrhythmia, CHF, migraine | Moderate |
| Levothyroxine | Thyroid Hormone | Hypothyroidism | — | Low |
| Sertraline | SSRI | Depression | Anxiety, OCD, PTSD | Low-Moderate |
| Alprazolam | Benzodiazepine | Anxiety | Panic disorder | Moderate |
| Oxycodone | Opioid | Chronic Pain | Injury, surgery, potential abuse | High |
| Warfarin | Anticoagulant | DVT/PE | Atrial fibrillation, prosthetic valve | High |
| Sumatriptan | Triptan | Migraine | — | Low |
| Albuterol | Bronchodilator | Asthma | COPD | Low-Moderate |
| Omeprazole | Proton Pump Inhibitor | GERD | Barrett's esophagus | Low |
| Tamoxifen | Antineoplastic | Breast Cancer | — | Very High |
| Buprenorphine | Opioid Agonist | Opioid Use Disorder | — | Very High |

#### 3.7.3 Rx Pattern Analysis Rules (Pseudocode)

```python
def analyze_rx_pattern(prescriptions: list[Prescription]) -> RxRiskAssessment:
    """
    Analyzes prescription fill patterns for underwriting risk signals.
    Returns risk assessment with implied conditions and flags.
    """
    assessment = RxRiskAssessment()

    chronic_drugs = group_by_drug(prescriptions)
    for drug_name, fills in chronic_drugs.items():
        drug_info = lookup_drug(drug_name)

        # Chronicity detection: 3+ fills in 12 months = chronic use
        recent_fills = [f for f in fills if f.fill_date > today() - timedelta(days=365)]
        is_chronic = len(recent_fills) >= 3

        # Dose escalation: check if strength has increased over time
        strengths = [parse_strength(f.strength) for f in sorted(fills, key=lambda x: x.fill_date)]
        dose_escalating = strengths[-1] > strengths[0] if len(strengths) > 1 else False

        # Specialist prescriber: certain specialties imply severity
        specialist_flags = {
            "Oncology": "CANCER_TREATMENT",
            "Cardiology": "CARDIAC_CONDITION",
            "Psychiatry": "MENTAL_HEALTH",
            "Endocrinology": "METABOLIC_CONDITION",
            "Neurology": "NEUROLOGICAL_CONDITION",
            "Pulmonology": "RESPIRATORY_CONDITION",
        }
        prescriber_flag = specialist_flags.get(fills[-1].prescriber_specialty)

        condition = map_drug_to_condition(drug_info)
        assessment.add_condition(
            condition=condition,
            drug=drug_name,
            is_chronic=is_chronic,
            dose_escalating=dose_escalating,
            prescriber_flag=prescriber_flag,
            fill_count=len(fills),
            last_fill_date=fills[-1].fill_date,
        )

    # Controlled substance analysis
    controlled = [p for p in prescriptions if p.dea_schedule in ("II", "III", "IV")]
    if controlled:
        assessment.controlled_substance_flag = True
        assessment.controlled_substance_count = len(controlled)
        # Multiple prescribers for same controlled substance = doctor shopping risk
        c2_prescribers = set(p.prescriber_npi for p in controlled if p.dea_schedule == "II")
        if len(c2_prescribers) > 2:
            assessment.add_flag("MULTIPLE_CONTROLLED_PRESCRIBERS")

    # Polypharmacy: 5+ chronic medications
    chronic_count = sum(1 for drug, fills in chronic_drugs.items()
                        if len([f for f in fills if f.fill_date > today() - timedelta(days=365)]) >= 3)
    if chronic_count >= 5:
        assessment.add_flag("POLYPHARMACY")

    # Gaps in fill pattern (non-compliance)
    for drug_name, fills in chronic_drugs.items():
        if is_maintenance_drug(drug_name):
            gaps = detect_fill_gaps(fills, expected_days_supply=30, max_gap_days=45)
            if gaps:
                assessment.add_flag("NON_COMPLIANCE", drug=drug_name, gap_count=len(gaps))

    return assessment
```

### 3.8 RxScore (LexisNexis)

RxScore is a **numeric score** (not a detailed prescription list) derived from Rx data. It predicts mortality risk on a scale.

| Score Range | Risk Category | Mortality Multiplier |
|------------|--------------|---------------------|
| 0–20 | Very Low Risk | 50–75% of standard |
| 21–40 | Low Risk | 75–95% of standard |
| 41–60 | Average Risk | 95–110% of standard |
| 61–80 | Elevated Risk | 110–150% of standard |
| 81–100 | High Risk | 150%+ of standard |

RxScore is often used as a **knockout** — applicants scoring below a threshold may bypass traditional paramedical exams. It does NOT provide prescription detail, making it useful for carriers that want mortality risk signal without handling detailed PHI.

---

## 4. Lab Data Standards

### 4.1 Overview

Lab results from blood and urine testing remain a cornerstone of fully underwritten term life insurance. Lab data is exchanged using HL7 messaging standards, LOINC codes for test identification, and vendor-specific formats.

### 4.2 HL7 ORU Message — Structure

The **HL7 ORU^R01** (Observation Result/Unsolicited) message is the standard for transmitting lab results. HL7 v2.x is the dominant version in production use.

#### 4.2.1 ORU Message Segments

| Segment | Name | Purpose |
|---------|------|---------|
| MSH | Message Header | Identifies sender, receiver, message type, timestamp |
| PID | Patient Identification | Patient demographics |
| PV1 | Patient Visit | Visit/encounter information |
| ORC | Common Order | Order control information |
| OBR | Observation Request | Test order/panel header |
| OBX | Observation Result | Individual test result (one per test) |
| NTE | Notes and Comments | Free-text comments |

#### 4.2.2 Full HL7 ORU^R01 Example — Underwriting Lab Panel

```
MSH|^~\&|EXAMONE_LAB|EXAMONE|ACME_UW_ENGINE|ACMELIFE|20260417143000-0500||ORU^R01^ORU_R01|MSG-2026041714300001|P|2.5.1|||AL|NE||ASCII|
PID|1||ACME-PAT-88421||Smith^John^Robert||19880715|M||2106-3|123 Mountain View Drive^^Denver^CO^80202^US||^PRN^PH^^^303^5551234|||||123-45-6789|CO-123456789|
PV1|1|O|||||1234567890^Williams^Jane^MD|||||||||||||ACME-VIS-001|
ORC|RE|ORD-2026-88421|LAB-2026-991234|||||20260417143000|||1234567890^Williams^Jane^MD|
OBR|1|ORD-2026-88421|LAB-2026-991234|24331-1^Comprehensive Metabolic Panel^LN|||20260417080000|||||||||1234567890^Williams^Jane^MD||||||20260417143000|||F|
OBX|1|NM|2093-3^Total Cholesterol^LN||228|mg/dL|125-200|H|||F|||20260417080000|EXAMONE_LAB|
OBX|2|NM|2085-9^HDL Cholesterol^LN||55|mg/dL|40-60|N|||F|||20260417080000|EXAMONE_LAB|
OBX|3|NM|13457-7^LDL Cholesterol (Calculated)^LN||148|mg/dL|0-130|H|||F|||20260417080000|EXAMONE_LAB|
OBX|4|NM|2571-8^Triglycerides^LN||125|mg/dL|0-150|N|||F|||20260417080000|EXAMONE_LAB|
OBX|5|NM|2345-7^Glucose (Fasting)^LN||95|mg/dL|65-99|N|||F|||20260417080000|EXAMONE_LAB|
OBX|6|NM|4548-4^Hemoglobin A1c^LN||5.4|%|4.0-5.6|N|||F|||20260417080000|EXAMONE_LAB|
OBX|7|NM|1742-6^ALT (SGPT)^LN||32|U/L|7-56|N|||F|||20260417080000|EXAMONE_LAB|
OBX|8|NM|1920-8^AST (SGOT)^LN||28|U/L|10-40|N|||F|||20260417080000|EXAMONE_LAB|
OBX|9|NM|6768-6^Alkaline Phosphatase^LN||68|U/L|44-147|N|||F|||20260417080000|EXAMONE_LAB|
OBX|10|NM|1975-2^Total Bilirubin^LN||0.8|mg/dL|0.1-1.2|N|||F|||20260417080000|EXAMONE_LAB|
OBX|11|NM|1751-7^Albumin^LN||4.2|g/dL|3.5-5.5|N|||F|||20260417080000|EXAMONE_LAB|
OBX|12|NM|3094-0^BUN^LN||15|mg/dL|6-24|N|||F|||20260417080000|EXAMONE_LAB|
OBX|13|NM|2160-0^Creatinine^LN||1.0|mg/dL|0.74-1.35|N|||F|||20260417080000|EXAMONE_LAB|
OBX|14|NM|33914-3^eGFR^LN||95|mL/min/1.73m2|>60|N|||F|||20260417080000|EXAMONE_LAB|
OBX|15|NM|2951-2^Sodium^LN||140|mEq/L|136-145|N|||F|||20260417080000|EXAMONE_LAB|
OBX|16|NM|2823-3^Potassium^LN||4.2|mEq/L|3.5-5.2|N|||F|||20260417080000|EXAMONE_LAB|
OBX|17|NM|17861-6^Calcium^LN||9.5|mg/dL|8.7-10.2|N|||F|||20260417080000|EXAMONE_LAB|
OBX|18|NM|2885-2^Total Protein^LN||7.2|g/dL|6.0-8.3|N|||F|||20260417080000|EXAMONE_LAB|
OBX|19|NM|718-7^Hemoglobin^LN||14.8|g/dL|12.0-17.5|N|||F|||20260417080000|EXAMONE_LAB|
OBR|2|ORD-2026-88421|LAB-2026-991235|24356-8^Urinalysis^LN|||20260417080000|||||||||1234567890^Williams^Jane^MD||||||20260417143000|||F|
OBX|20|ST|5767-9^Urine Appearance^LN||Clear||Clear|N|||F|||20260417080000|EXAMONE_LAB|
OBX|21|NM|5811-5^Urine Specific Gravity^LN||1.020||1.005-1.030|N|||F|||20260417080000|EXAMONE_LAB|
OBX|22|NM|2756-5^Urine pH^LN||6.0||5.0-8.0|N|||F|||20260417080000|EXAMONE_LAB|
OBX|23|ST|5804-0^Urine Protein^LN||Negative||Negative|N|||F|||20260417080000|EXAMONE_LAB|
OBX|24|ST|5792-7^Urine Glucose^LN||Negative||Negative|N|||F|||20260417080000|EXAMONE_LAB|
OBX|25|NM|14959-1^Urine Cotinine^LN||0|ng/mL|0-10|N|||F|||20260417080000|EXAMONE_LAB|
OBX|26|NM|5794-3^Urine Cocaine Metabolite^LN||0|ng/mL|0|N|||F|||20260417080000|EXAMONE_LAB|
OBX|27|ST|19659-2^Urine HIV Antibody^LN||Non-Reactive||Non-Reactive|N|||F|||20260417080000|EXAMONE_LAB|
NTE|1||All results final. Specimen integrity verified. Chain of custody maintained.|
```

#### 4.2.3 OBX Segment Field Breakdown

```
OBX|SEQ|TYPE|CODE^NAME^SYSTEM||VALUE|UNITS|RANGE|FLAG|||STATUS|||TIMESTAMP|LAB|

Field 1:  Set ID (sequence number)
Field 2:  Value Type (NM=numeric, ST=string, CE=coded entry)
Field 3:  Observation Identifier (LOINC code ^ name ^ coding system)
Field 4:  Observation Sub-ID (unused here)
Field 5:  Observation Value
Field 6:  Units of measure
Field 7:  Reference Range
Field 8:  Abnormal Flag (N=normal, H=high, L=low, HH=critical high, LL=critical low)
Field 9:  Probability (unused)
Field 10: Nature of Abnormal Test (unused)
Field 11: Observation Result Status (F=final, P=preliminary, C=corrected)
Field 12: Effective date of reference range (unused)
Field 13: User-defined access checks (unused)
Field 14: Date/time of observation
Field 15: Responsible observer (lab identifier)
```

### 4.3 LOINC Codes for Common Underwriting Labs

**LOINC** (Logical Observation Identifiers Names and Codes) is the universal standard for identifying medical laboratory observations. Every test result in HL7 messages is identified by a LOINC code.

#### 4.3.1 Lipid Panel

| LOINC Code | Test Name | Normal Range (UW) | UW Significance |
|-----------|-----------|-------------------|----------------|
| 2093-3 | Total Cholesterol | 125–200 mg/dL | >300 = significant rating |
| 2085-9 | HDL Cholesterol | >40 mg/dL (M), >50 (F) | Low HDL increases risk |
| 13457-7 | LDL Cholesterol (Calculated) | <130 mg/dL | >160 = rating likely |
| 2571-8 | Triglycerides | <150 mg/dL | >500 = significant |
| 9830-1 | Total/HDL Ratio | <4.5 (M), <4.0 (F) | Key composite metric |

#### 4.3.2 Glucose / Diabetes Panel

| LOINC Code | Test Name | Normal Range (UW) | UW Significance |
|-----------|-----------|-------------------|----------------|
| 2345-7 | Glucose (Fasting) | 65–99 mg/dL | >126 = diabetes criteria |
| 4548-4 | Hemoglobin A1c (HbA1c) | 4.0–5.6% | >6.5% = diabetes; 5.7–6.4% = prediabetes |
| 14771-0 | Fructosamine | 200–285 µmol/L | Supplement to HbA1c |
| 1558-6 | Fasting Glucose (plasma) | 65–99 mg/dL | Alternative fasting glucose |
| 2339-0 | Glucose (Random) | 65–140 mg/dL | >200 = significant |

#### 4.3.3 Liver Function Panel

| LOINC Code | Test Name | Normal Range (UW) | UW Significance |
|-----------|-----------|-------------------|----------------|
| 1742-6 | ALT (SGPT) | 7–56 U/L | >100 = hepatitis workup |
| 1920-8 | AST (SGOT) | 10–40 U/L | Elevated with alcohol |
| 6768-6 | Alkaline Phosphatase | 44–147 U/L | Bone/liver disease |
| 2324-2 | GGT (Gamma-GT) | 0–51 U/L | Alcohol marker |
| 1975-2 | Total Bilirubin | 0.1–1.2 mg/dL | Liver function |
| 1751-7 | Albumin | 3.5–5.5 g/dL | Liver synthetic function |
| 2885-2 | Total Protein | 6.0–8.3 g/dL | Nutritional/liver status |
| 1968-7 | Direct Bilirubin | 0.0–0.3 mg/dL | Obstructive vs. hepatocellular |

**Key UW Liver Rule:** AST/ALT ratio > 2.0 combined with elevated GGT is a strong signal for alcohol-related liver disease.

#### 4.3.4 Kidney Function Panel

| LOINC Code | Test Name | Normal Range (UW) | UW Significance |
|-----------|-----------|-------------------|----------------|
| 2160-0 | Creatinine | 0.74–1.35 mg/dL | Kidney function |
| 3094-0 | BUN | 6–24 mg/dL | Kidney/hydration |
| 33914-3 | eGFR (estimated) | >60 mL/min/1.73m² | <60 = CKD |
| 3097-3 | BUN/Creatinine Ratio | 10–20 | Pre-renal vs. renal |
| 14959-1 | Microalbumin (urine) | <30 mg/L | >30 = early kidney damage |

#### 4.3.5 Urine Drug Screen / Substance Markers

| LOINC Code | Test Name | Cutoff | UW Significance |
|-----------|-----------|--------|----------------|
| 14959-1 | Cotinine (urine) | 10 ng/mL | Tobacco use detection |
| 3426-4 | Cotinine (serum) | 10 ng/mL | Alternative tobacco marker |
| 5794-3 | Cocaine Metabolite (urine) | 300 ng/mL | Illicit drug use |
| 19659-2 | HIV-1/2 Antibody (urine) | Reactive/Non-Reactive | HIV status |
| 5643-2 | Marijuana (THC) (urine) | 50 ng/mL | Cannabis use |
| 3879-4 | Opiates (urine) | 2000 ng/mL | Opiate use |
| 19261-7 | Amphetamines (urine) | 1000 ng/mL | Stimulant use |
| 3694-7 | Methamphetamine (urine) | 1000 ng/mL | Meth use |
| 8098-6 | CDT (Carbohydrate-Deficient Transferrin) | <2.6% | Chronic alcohol marker |

#### 4.3.6 Additional Common Underwriting Labs

| LOINC Code | Test Name | Normal Range (UW) | UW Significance |
|-----------|-----------|-------------------|----------------|
| 718-7 | Hemoglobin | 12.0–17.5 g/dL | Anemia |
| 30313-1 | Hemoglobin (blood) | 12.0–17.5 g/dL | Alternative code |
| 789-8 | RBC Count | 4.1–5.9 M/µL | Blood disorders |
| 6690-2 | WBC Count | 3.4–10.8 K/µL | Infection/immune |
| 2951-2 | Sodium | 136–145 mEq/L | Electrolyte balance |
| 2823-3 | Potassium | 3.5–5.2 mEq/L | Cardiac risk if abnormal |
| 17861-6 | Calcium | 8.7–10.2 mg/dL | Parathyroid/cancer |
| 2157-6 | CK (Creatine Kinase) | 22–198 U/L | Muscle damage, MI |
| 30522-7 | Troponin I (High Sensitivity) | <0.04 ng/mL | Cardiac damage |
| 10886-0 | PSA (Prostate-Specific Antigen) | <4.0 ng/mL | Prostate cancer screening |
| 14685-2 | NT-proBNP | <125 pg/mL | Heart failure marker |
| 1986-9 | C-Reactive Protein (hs) | <3.0 mg/L | Inflammation/CV risk |

### 4.4 Lab Vendor Data Formats

#### 4.4.1 ExamOne (Quest Diagnostics)

ExamOne delivers results in multiple formats:

1. **HL7 v2.5.1 ORU^R01** — Primary electronic format (shown above).
2. **TXLife XML** — Mapped into `LabTesting/LabTestResult` elements.
3. **PDF Report** — Human-readable report for underwriter review.
4. **CSV/Flat File** — Legacy batch format for older systems.

**ExamOne TXLife Lab Result Mapping:**

```xml
<LabTesting id="LabTest_Blood">
  <LabTestPerformedDate>2026-04-17</LabTestPerformedDate>
  <LabTestVendorCode>EXAMONE</LabTestVendorCode>
  <LabTestSpecimenType tc="1">Blood</LabTestSpecimenType>
  <LabTestSpecimenCollectionDate>2026-04-17</LabTestSpecimenCollectionDate>
  <LabTestFastingInd tc="1">true</LabTestFastingInd>

  <LabTestResult id="LTR_Chol">
    <TestCode tc="1101">Total Cholesterol</TestCode>
    <LOINCCode>2093-3</LOINCCode>
    <TestDescription>Total Cholesterol</TestDescription>
    <ResultValue>228</ResultValue>
    <UnitOfMeasure>mg/dL</UnitOfMeasure>
    <NormalRange>125-200</NormalRange>
    <AbnormalInd tc="1">true</AbnormalInd>
    <AbnormalDirection tc="1">High</AbnormalDirection>
    <ResultStatus tc="1">Final</ResultStatus>
  </LabTestResult>

  <LabTestResult id="LTR_HbA1c">
    <TestCode tc="1112">HbA1c</TestCode>
    <LOINCCode>4548-4</LOINCCode>
    <TestDescription>Hemoglobin A1c</TestDescription>
    <ResultValue>5.4</ResultValue>
    <UnitOfMeasure>%</UnitOfMeasure>
    <NormalRange>4.0-5.6</NormalRange>
    <AbnormalInd tc="0">false</AbnormalInd>
    <ResultStatus tc="1">Final</ResultStatus>
  </LabTestResult>
</LabTesting>
```

#### 4.4.2 Quest Diagnostics (Direct)

Quest provides a slightly different schema for direct-to-carrier integrations:

```json
{
  "questLabReport": {
    "orderId": "QST-2026-88421",
    "accessionNumber": "Q2026041700123",
    "reportStatus": "FINAL",
    "collectionDate": "2026-04-17T08:00:00-05:00",
    "reportDate": "2026-04-17T14:30:00-05:00",
    "patient": {
      "patientId": "ACME-PAT-88421",
      "firstName": "John",
      "lastName": "Smith",
      "dob": "1988-07-15",
      "gender": "M"
    },
    "specimen": {
      "type": "BLOOD",
      "fastingStatus": "FASTING",
      "collectionMethod": "VENIPUNCTURE"
    },
    "panels": [
      {
        "panelCode": "24331-1",
        "panelName": "Comprehensive Metabolic Panel",
        "results": [
          {
            "loinc": "2093-3",
            "testName": "Total Cholesterol",
            "value": 228,
            "units": "mg/dL",
            "referenceRange": { "low": 125, "high": 200 },
            "flag": "H",
            "status": "FINAL"
          },
          {
            "loinc": "4548-4",
            "testName": "Hemoglobin A1c",
            "value": 5.4,
            "units": "%",
            "referenceRange": { "low": 4.0, "high": 5.6 },
            "flag": "N",
            "status": "FINAL"
          }
        ]
      }
    ]
  }
}
```

### 4.5 Underwriting Lab Normal Ranges — Extended Reference

Normal ranges for underwriting differ from clinical normal ranges because underwriters use ranges that correlate to mortality risk, not just disease diagnosis.

| Test | Clinical Normal | UW "Preferred" Range | UW "Standard" Range | UW "Rated" Threshold |
|------|----------------|---------------------|--------------------|--------------------|
| Total Cholesterol | 125–200 | <220 | 220–280 | >300 |
| HDL | >40 (M), >50 (F) | >50 (M), >55 (F) | 35–50 (M), 40–55 (F) | <35 |
| LDL | <130 | <130 | 130–160 | >190 |
| Triglycerides | <150 | <150 | 150–300 | >500 |
| Glucose (Fasting) | 65–99 | <100 | 100–125 | >126 |
| HbA1c | 4.0–5.6% | <5.7% | 5.7–6.4% | >6.5% |
| ALT | 7–56 | <45 | 45–90 | >100 |
| AST | 10–40 | <35 | 35–70 | >80 |
| GGT | 0–51 | <45 | 45–100 | >150 |
| Creatinine | 0.74–1.35 | <1.3 | 1.3–1.8 | >2.0 |
| eGFR | >60 | >90 | 60–89 | <60 |
| PSA | <4.0 | <2.5 | 2.5–4.0 | >4.0 |
| Cotinine | <10 (non-smoker) | <10 | N/A (binary) | >10 = tobacco rate |
| Build (BMI) | 18.5–24.9 | 18–27 | 27–35 | >40 |
| BP Systolic | <120 | <130 | 130–145 | >150 |
| BP Diastolic | <80 | <85 | 85–90 | >95 |

---

## 5. Motor Vehicle Reports (MVR)

### 5.1 Overview

Motor Vehicle Reports provide a 3–7 year history of an applicant's driving record, including violations, accidents, license status, and DUI/DWI offenses. MVRs are a strong predictor of mortality risk — reckless driving behavior correlates with overall risk-taking behavior and mortality.

### 5.2 MVR Data Sources

| Source | Coverage | Access Method |
|--------|----------|---------------|
| **LexisNexis** (C.L.U.E. Auto) | All 50 states + DC | API / Batch |
| **State DMV Direct** | Single state | Varies by state (online, batch, mail) |
| **TransUnion (TrueVision)** | Multi-state | API |
| **Verisk (ISO ClueAuto)** | Claims-based | API / Batch |

### 5.3 LexisNexis MVR Format

#### 5.3.1 MVR Response Structure (JSON)

```json
{
  "mvrReport": {
    "reportId": "MVR-2026-04-17-456789",
    "reportDate": "2026-04-17T10:00:00Z",
    "reportStatus": "Complete",
    "requestState": "CO",
    "subject": {
      "firstName": "John",
      "lastName": "Smith",
      "dateOfBirth": "1988-07-15",
      "licenseNumber": "CO-123456789",
      "licenseState": "CO",
      "matchConfidence": "HIGH"
    },
    "licenseInfo": {
      "licenseNumber": "CO-123456789",
      "licenseState": "CO",
      "licenseClass": "R",
      "licenseClassDescription": "Regular",
      "licenseStatus": "VALID",
      "issueDate": "2020-03-15",
      "expirationDate": "2028-07-15",
      "restrictions": [],
      "endorsements": []
    },
    "violations": [
      {
        "violationSequence": 1,
        "violationDate": "2024-08-12",
        "violationType": "MOVING",
        "violationCode": "SP20",
        "violationDescription": "Speeding 15-20 MPH over limit",
        "convictionDate": "2024-10-05",
        "points": 4,
        "fineAmount": 250.00,
        "state": "CO",
        "dispositionCode": "CONVICTED",
        "acdCode": "S92",
        "acdDescription": "Speeding - exceeded posted limit by 11-15 mph"
      }
    ],
    "accidents": [],
    "suspensions": [],
    "dui": [],
    "summary": {
      "totalViolations": 1,
      "totalAccidents": 0,
      "totalSuspensions": 0,
      "totalDUI": 0,
      "totalPoints": 4,
      "reportYears": 7,
      "cleanRecordInd": false,
      "majorViolationInd": false
    }
  }
}
```

#### 5.3.2 MVR via TXLife

```xml
<RequirementInfo id="MVR_Result_1">
  <ReqCode tc="28">Motor Vehicle Report</ReqCode>
  <ReqStatus tc="2">Received</ReqStatus>
  <FulfilledDate>2026-04-17</FulfilledDate>
  <ServiceProviderCode>LEXISNEXIS</ServiceProviderCode>

  <OLifEExtension VendorCode="LEXISNEXIS">
    <MVRResult>
      <ReportID>MVR-2026-04-17-456789</ReportID>
      <LicenseState>CO</LicenseState>
      <LicenseStatus>VALID</LicenseStatus>
      <LicenseClass>Regular</LicenseClass>
      <ReportYears>7</ReportYears>
      <TotalViolations>1</TotalViolations>
      <TotalAccidents>0</TotalAccidents>
      <TotalDUI>0</TotalDUI>
      <TotalSuspensions>0</TotalSuspensions>
      <MajorViolationInd>false</MajorViolationInd>

      <Violation sequence="1">
        <ViolationDate>2024-08-12</ViolationDate>
        <ViolationType>MOVING</ViolationType>
        <ACDCode>S92</ACDCode>
        <Description>Speeding 15-20 MPH over limit</Description>
        <Points>4</Points>
        <Disposition>CONVICTED</Disposition>
      </Violation>
    </MVRResult>
  </OLifEExtension>
</RequirementInfo>
```

### 5.4 ACD (AAMC Violation) Codes

The **ACD** (AAMC Code Dictionary) standardizes violation codes across all US states. Key categories:

#### 5.4.1 Major Violations (UW Impact: High)

| ACD Code | Description | UW Impact |
|----------|-------------|-----------|
| A20 | DUI — Alcohol | Decline or heavy rating |
| A21 | DUI — Drugs | Decline or heavy rating |
| A22 | DUI — Alcohol and Drugs | Decline |
| A25 | DUI — BAC ≥ 0.08% | Decline or heavy rating |
| A31 | Illegal possession of alcohol/drugs | Major rating |
| B01 | Hit and Run — Injury/Death | Decline |
| B02 | Hit and Run — Property Damage | Major rating |
| B19 | Driving while license suspended | Major rating |
| U03 | Vehicular manslaughter | Decline |
| U06 | Vehicular homicide | Decline |
| U07 | Motor vehicle used in felony | Decline |
| S95 | Reckless driving | Major rating |
| W00 | License withdrawal (general) | Major rating |

#### 5.4.2 Minor Violations (UW Impact: Low-Moderate)

| ACD Code | Description | UW Impact |
|----------|-------------|-----------|
| S92 | Speeding 11–15 mph over | Minor (1 occurrence = preferred eligible) |
| S93 | Speeding 16–20 mph over | Minor-Moderate |
| S94 | Speeding 21+ mph over | Moderate |
| M14 | Failure to signal | Negligible |
| M16 | Failure to yield | Minor |
| M40 | Following too closely | Minor |
| N01 | Failure to yield to pedestrian | Minor |
| E01 | Operating without equipment | Negligible |
| D29 | Violation of restriction | Minor |

### 5.5 MVR Scoring for Underwriting

| Scenario | Points | UW Action |
|----------|--------|-----------|
| Clean record (0 violations, 0 accidents, 7 years) | 0 | Preferred Plus eligible |
| 1 minor violation (e.g., speeding <20 over) | 1–2 | Preferred eligible |
| 2 minor violations | 3–4 | Standard |
| 1 major violation (e.g., reckless driving) | 5–8 | Substandard / Rated |
| 1 DUI (>3 years ago) | 8–12 | Substandard, minimum Table 4 |
| 1 DUI (<3 years ago) | 15+ | Decline or postpone |
| 2+ DUI (any timeframe) | 20+ | Decline |
| License suspension (current) | 10+ | Postpone until reinstated |
| At-fault accident with injury | 5–10 | Depends on severity |

### 5.6 State-Specific MVR Variations

| State | Report Years | Online Access | Special Notes |
|-------|-------------|--------------|---------------|
| California | 3 years | Yes | Privacy restrictions limit detail |
| New York | 4 years | Yes | Includes points system |
| Texas | 3–5 years | Yes | Standard format |
| Florida | 7 years | Yes | Includes crash reports |
| Pennsylvania | 5 years | Yes | Includes suspension history |
| Ohio | 3 years | Yes | Standard ACD codes |
| Illinois | 7 years | Yes | Includes court disposition |
| Colorado | 7 years | Yes | Points-based system |
| Georgia | 7 years | Yes | Includes accident fault |
| Virginia | 5 years | Yes | Safe driving points system |

---

## 6. Credit-Based Insurance Scores

### 6.1 Overview

Credit-based insurance scores (CBIS) are used by many life insurers as a mortality predictor. Studies show a statistically significant correlation between credit behavior and mortality risk. CBIS are NOT the same as FICO credit scores — they are specifically modeled for insurance mortality prediction.

**Regulatory Note:** CBIS use is prohibited in some states (California, Hawaii, Maryland, Massachusetts for some lines). Always check state-specific regulations.

### 6.2 LexisNexis Risk Classifier

The LexisNexis **Risk Classifier** is the most widely used credit-based insurance score for life underwriting.

| Score Range | Risk Category | Relative Mortality |
|------------|--------------|-------------------|
| 900–999 | Best | 50–65% of standard |
| 800–899 | Very Good | 65–80% of standard |
| 700–799 | Good | 80–95% of standard |
| 600–699 | Average | 95–110% of standard |
| 500–599 | Below Average | 110–135% of standard |
| 300–499 | Poor | 135–175% of standard |
| No Score | Insufficient Data | Neutral (no impact) |

#### 6.2.1 Risk Classifier Response

```json
{
  "lexisNexisRiskClassifier": {
    "reportId": "LNRC-2026-04-16-123456",
    "reportDate": "2026-04-16T14:40:00Z",
    "subject": {
      "firstName": "John",
      "lastName": "Smith",
      "ssn": "***-**-6789",
      "matchStatus": "MATCH"
    },
    "score": {
      "value": 845,
      "range": { "min": 300, "max": 999 },
      "riskCategory": "VeryGood",
      "reasonCodes": [
        {
          "code": "RC01",
          "description": "Length of credit history contributes positively"
        },
        {
          "code": "RC12",
          "description": "Low revolving credit utilization"
        },
        {
          "code": "RC22",
          "description": "No derogatory public records"
        },
        {
          "code": "RC09",
          "description": "Low number of recent credit inquiries"
        }
      ],
      "modelVersion": "LN-RC-4.0",
      "modelDate": "2025-01-01"
    },
    "fcraInfo": {
      "adverseActionRequired": false,
      "consumerReportUsed": true,
      "permissiblePurpose": "InsuranceUnderwriting",
      "consumerDisputeRightsNotice": true
    }
  }
}
```

### 6.3 TransUnion TrueRisk Life

TransUnion's **TrueRisk Life** is an alternative CBIS product specifically designed for life insurance mortality prediction.

| Score Range | Risk Tier | Description |
|------------|----------|-------------|
| 1–100 | Tier 1 (Best) | Lowest mortality risk |
| 101–200 | Tier 2 | Low risk |
| 201–300 | Tier 3 | Below average risk |
| 301–400 | Tier 4 | Average risk |
| 401–500 | Tier 5 | Above average risk |
| 501–600 | Tier 6 | Elevated risk |
| 601–700 | Tier 7 | High risk |
| 701–800 | Tier 8 | Very high risk |
| 801–997 | Tier 9 (Worst) | Highest mortality risk |
| 998 | No Score | Insufficient data |
| 999 | Deceased | Subject is deceased |

### 6.4 FCRA Compliance Requirements

The **Fair Credit Reporting Act (FCRA)** imposes strict requirements on the use of credit data in insurance underwriting:

| Requirement | Description | Implementation |
|------------|-------------|----------------|
| **Permissible Purpose** | Must have a valid insurance underwriting reason | Include purpose code in inquiry |
| **Adverse Action Notice** | Must notify consumer if credit data leads to unfavorable decision | Send notice within 30 days |
| **Reason Codes** | Must provide top 4 reason codes for adverse action | Include in notice |
| **Consumer Rights** | Must inform consumer of right to dispute | Include CRA contact info |
| **Pre-screening** | Special rules for firm offers of insurance | Follow pre-screen procedures |
| **Opt-Out** | Consumer can opt out of pre-screened offers | Honor opt-out list |
| **Disposal** | Must securely dispose of consumer report information | Shred/encrypt/delete |
| **Accuracy** | Must take reasonable steps to ensure accuracy | Validate matching criteria |

**FCRA Adverse Action Notice Template (Key Fields):**

```
NOTICE OF ADVERSE ACTION

Date: [Date]
To: [Applicant Name]

We regret to inform you that your application for life insurance has been
[declined / approved at other than the most favorable rate] based in
whole or in part on information obtained from a consumer reporting agency.

Consumer Reporting Agency:
  [LexisNexis / TransUnion]
  [Address]
  [Phone]

The consumer reporting agency did not make the decision to take adverse
action. You have the right to obtain a free copy of your consumer report
within 60 days and to dispute any inaccurate information.

Key Factors:
  1. [Reason Code 1 Description]
  2. [Reason Code 2 Description]
  3. [Reason Code 3 Description]
  4. [Reason Code 4 Description]

Your Rights Under the Fair Credit Reporting Act:
  [Standard FCRA rights disclosure]
```

### 6.5 Credit Score Integration in TXLife

```xml
<RequirementInfo id="Credit_Result_1">
  <ReqCode tc="36">Credit Report</ReqCode>
  <ReqStatus tc="2">Received</ReqStatus>
  <FulfilledDate>2026-04-16</FulfilledDate>
  <ServiceProviderCode>LEXISNEXIS</ServiceProviderCode>

  <OLifEExtension VendorCode="LEXISNEXIS">
    <CreditInsuranceScore>
      <ScoreValue>845</ScoreValue>
      <ScoreRangeMin>300</ScoreRangeMin>
      <ScoreRangeMax>999</ScoreRangeMax>
      <RiskCategory>VeryGood</RiskCategory>
      <ModelName>LN-RC-4.0</ModelName>
      <AdverseActionRequired>false</AdverseActionRequired>

      <ReasonCode sequence="1">
        <Code>RC01</Code>
        <Description>Length of credit history</Description>
      </ReasonCode>
      <ReasonCode sequence="2">
        <Code>RC12</Code>
        <Description>Low revolving utilization</Description>
      </ReasonCode>
    </CreditInsuranceScore>
  </OLifEExtension>
</RequirementInfo>
```

---

## 7. Electronic Health Records & FHIR

### 7.1 Overview

Electronic Health Records (EHR) data is the next frontier in underwriting data. The emergence of HL7 FHIR (Fast Healthcare Interoperability Resources) is making it possible to retrieve structured clinical data electronically — replacing the slow, paper-based APS (Attending Physician Statement) process.

### 7.2 Traditional APS vs. Electronic APS

| Aspect | Traditional APS | Electronic APS (EHR/FHIR) |
|--------|----------------|---------------------------|
| **Retrieval Time** | 15–45 days | Minutes to hours |
| **Cost** | $25–$75 per request | $5–$20 per request |
| **Format** | Paper / fax / scanned PDF | Structured data (FHIR JSON, CDA XML) |
| **Completeness** | Provider-dependent | System-dependent |
| **Consistency** | Highly variable | Standardized schema |
| **Scalability** | Poor | Excellent |

### 7.3 HL7 FHIR R4 for Underwriting

FHIR R4 (Release 4) is the current production-ready version. Key FHIR resources relevant to underwriting:

#### 7.3.1 Key FHIR Resources

| FHIR Resource | Underwriting Use | Data Extracted |
|--------------|-----------------|----------------|
| **Patient** | Demographics | Name, DOB, gender, address, identifiers |
| **Condition** | Medical history | Diagnoses (ICD-10), onset, status |
| **MedicationRequest** | Rx verification | Prescriptions, dosages, prescribers |
| **Observation** | Lab results, vitals | BP, weight, lab values, smoking status |
| **Procedure** | Surgical history | Surgeries, procedures, dates |
| **AllergyIntolerance** | Allergy list | Drug allergies, food allergies |
| **DiagnosticReport** | Test reports | Imaging, pathology, lab panels |
| **DocumentReference** | Clinical documents | CDA documents, notes, reports |
| **Encounter** | Visit history | Office visits, hospitalizations, ER visits |
| **FamilyMemberHistory** | Family history | Conditions in blood relatives |
| **Immunization** | Vaccination record | COVID, flu, childhood vaccines |

#### 7.3.2 FHIR Patient Resource Example

```json
{
  "resourceType": "Patient",
  "id": "patient-john-smith-12345",
  "meta": {
    "versionId": "3",
    "lastUpdated": "2026-04-10T08:30:00Z"
  },
  "identifier": [
    {
      "system": "http://hl7.org/fhir/sid/us-ssn",
      "value": "123-45-6789"
    },
    {
      "system": "urn:oid:2.16.840.1.113883.4.3.8",
      "value": "CO-123456789",
      "type": { "text": "Driver's License" }
    }
  ],
  "name": [
    {
      "use": "official",
      "family": "Smith",
      "given": ["John", "Robert"]
    }
  ],
  "gender": "male",
  "birthDate": "1988-07-15",
  "address": [
    {
      "use": "home",
      "line": ["123 Mountain View Drive", "Apt 4B"],
      "city": "Denver",
      "state": "CO",
      "postalCode": "80202",
      "country": "US"
    }
  ],
  "telecom": [
    {
      "system": "phone",
      "value": "303-555-1234",
      "use": "home"
    },
    {
      "system": "email",
      "value": "john.smith@email.com"
    }
  ],
  "maritalStatus": {
    "coding": [
      {
        "system": "http://terminology.hl7.org/CodeSystem/v3-MaritalStatus",
        "code": "M",
        "display": "Married"
      }
    ]
  }
}
```

#### 7.3.3 FHIR Condition Resource (Medical History)

```json
{
  "resourceType": "Bundle",
  "type": "searchset",
  "total": 2,
  "entry": [
    {
      "resource": {
        "resourceType": "Condition",
        "id": "condition-hyperlipidemia-001",
        "clinicalStatus": {
          "coding": [
            {
              "system": "http://terminology.hl7.org/CodeSystem/condition-clinical",
              "code": "active",
              "display": "Active"
            }
          ]
        },
        "verificationStatus": {
          "coding": [
            {
              "system": "http://terminology.hl7.org/CodeSystem/condition-ver-status",
              "code": "confirmed",
              "display": "Confirmed"
            }
          ]
        },
        "category": [
          {
            "coding": [
              {
                "system": "http://terminology.hl7.org/CodeSystem/condition-category",
                "code": "encounter-diagnosis"
              }
            ]
          }
        ],
        "code": {
          "coding": [
            {
              "system": "http://hl7.org/fhir/sid/icd-10-cm",
              "code": "E78.0",
              "display": "Pure hypercholesterolemia"
            },
            {
              "system": "http://snomed.info/sct",
              "code": "13644009",
              "display": "Hypercholesterolemia"
            }
          ],
          "text": "Elevated cholesterol"
        },
        "subject": {
          "reference": "Patient/patient-john-smith-12345"
        },
        "onsetDateTime": "2023-06-15",
        "recordedDate": "2023-06-15",
        "note": [
          {
            "text": "Total cholesterol 225, managed with diet modification and statin therapy"
          }
        ]
      }
    },
    {
      "resource": {
        "resourceType": "Condition",
        "id": "condition-hypertension-002",
        "clinicalStatus": {
          "coding": [
            {
              "system": "http://terminology.hl7.org/CodeSystem/condition-clinical",
              "code": "active"
            }
          ]
        },
        "verificationStatus": {
          "coding": [
            {
              "system": "http://terminology.hl7.org/CodeSystem/condition-ver-status",
              "code": "confirmed"
            }
          ]
        },
        "code": {
          "coding": [
            {
              "system": "http://hl7.org/fhir/sid/icd-10-cm",
              "code": "I10",
              "display": "Essential (primary) hypertension"
            }
          ]
        },
        "subject": {
          "reference": "Patient/patient-john-smith-12345"
        },
        "onsetDateTime": "2025-01-10"
      }
    }
  ]
}
```

#### 7.3.4 FHIR Observation (Lab Results)

```json
{
  "resourceType": "Observation",
  "id": "obs-cholesterol-total-001",
  "status": "final",
  "category": [
    {
      "coding": [
        {
          "system": "http://terminology.hl7.org/CodeSystem/observation-category",
          "code": "laboratory",
          "display": "Laboratory"
        }
      ]
    }
  ],
  "code": {
    "coding": [
      {
        "system": "http://loinc.org",
        "code": "2093-3",
        "display": "Cholesterol [Mass/volume] in Serum or Plasma"
      }
    ]
  },
  "subject": {
    "reference": "Patient/patient-john-smith-12345"
  },
  "effectiveDateTime": "2026-04-17T08:00:00-05:00",
  "issued": "2026-04-17T14:30:00-05:00",
  "valueQuantity": {
    "value": 228,
    "unit": "mg/dL",
    "system": "http://unitsofmeasure.org",
    "code": "mg/dL"
  },
  "interpretation": [
    {
      "coding": [
        {
          "system": "http://terminology.hl7.org/CodeSystem/v3-ObservationInterpretation",
          "code": "H",
          "display": "High"
        }
      ]
    }
  ],
  "referenceRange": [
    {
      "low": { "value": 125, "unit": "mg/dL" },
      "high": { "value": 200, "unit": "mg/dL" },
      "text": "125-200 mg/dL"
    }
  ]
}
```

### 7.4 CDA (Clinical Document Architecture)

CDA is an older HL7 standard for clinical documents. Many EHR systems still export in CDA format (specifically **C-CDA**, the Consolidated CDA).

#### 7.4.1 C-CDA Sections Relevant to Underwriting

| CDA Section | LOINC Section Code | Underwriting Use |
|-------------|-------------------|-----------------|
| Problem List | 11450-4 | Active/resolved diagnoses |
| Medications | 10160-0 | Current/past medications |
| Results | 30954-2 | Lab results |
| Vital Signs | 8716-3 | BP, weight, height, BMI |
| Procedures | 47519-4 | Surgical history |
| Social History | 29762-2 | Smoking, alcohol, occupation |
| Family History | 10157-6 | Family medical history |
| Allergies | 48765-2 | Drug/food allergies |
| Immunizations | 11369-6 | Vaccination history |
| Encounters | 46240-8 | Visit history |
| Plan of Care | 18776-5 | Ongoing treatment plans |

### 7.5 Emerging EHR Retrieval Vendors

| Vendor | Product | Data Format | EHR Coverage |
|--------|---------|-------------|-------------|
| **Veridion (Apriori)** | Electronic APS | C-CDA, FHIR | Epic, Cerner, Allscripts |
| **Human API** | Health Data API | FHIR R4 JSON | 300+ health systems |
| **Health Gorilla** | Clinical Data Network | FHIR, CDA | National network |
| **Ciox Health** | Electronic APS | CDA, PDF | Broad coverage |
| **Particle Health** | Clinical Data API | FHIR R4 | National frameworks |

---

## 8. Identity Verification Data

### 8.1 Overview

Identity verification is the first step in any underwriting process. Carriers must confirm the applicant is who they claim to be, screen against sanctions lists, and validate basic identity data.

### 8.2 KBA (Knowledge-Based Authentication)

KBA presents the applicant with questions derived from their credit/public records that only the real person should know.

#### 8.2.1 KBA Question Types

| Category | Example Question |
|----------|-----------------|
| Address History | "Which of the following streets have you lived on?" |
| Auto/Property | "What color is your 2022 Honda Civic?" |
| Financial | "Which bank holds your mortgage?" |
| Employment | "Which company did you work for in 2023?" |
| Education | "Which university did you attend?" |

#### 8.2.2 KBA Response Format

```json
{
  "kbaSession": {
    "sessionId": "KBA-2026-04-16-001",
    "transactionId": "TXN-88421",
    "subject": {
      "firstName": "John",
      "lastName": "Smith",
      "ssn": "***-**-6789",
      "dateOfBirth": "1988-07-15"
    },
    "result": {
      "status": "PASS",
      "score": 4,
      "questionsAsked": 5,
      "correctAnswers": 4,
      "passingThreshold": 3,
      "authenticationLevel": "HIGH",
      "riskIndicators": []
    },
    "questions": [
      {
        "questionId": "Q1",
        "questionText": "Which of the following streets have you lived on?",
        "choices": ["Oak Street", "Mountain View Drive", "Pine Avenue", "Elm Road", "None of the above"],
        "correctChoice": "Mountain View Drive",
        "selectedChoice": "Mountain View Drive",
        "correct": true
      },
      {
        "questionId": "Q2",
        "questionText": "In which county is your current residence?",
        "choices": ["Adams", "Denver", "Arapahoe", "Jefferson", "None of the above"],
        "correctChoice": "Denver",
        "selectedChoice": "Denver",
        "correct": true
      }
    ],
    "identityVerificationFlags": {
      "ssnValid": true,
      "ssnIssuedState": "CO",
      "ssnIssuedYearRange": "2000-2010",
      "ssnDeathMasterFileMatch": false,
      "addressVerified": true,
      "nameMatchConfidence": "HIGH"
    }
  }
}
```

### 8.3 SSN Validation

| Check | Method | Result |
|-------|--------|--------|
| **Format Validation** | Verify 9-digit format, no invalid area numbers (000, 666, 900–999) | Pass/Fail |
| **Death Master File (DMF)** | Check SSA Death Master File for deceased SSN | Match/No Match |
| **SSN Issuance** | Verify SSN was issued (not random) | Valid/Invalid |
| **Identity Consistency** | Cross-check SSN against name and DOB | Match/Mismatch |
| **Randomization Check** | Post-2011, SSNs are randomized (no area/group logic) | Informational |

### 8.4 OFAC (Office of Foreign Assets Control) Screening

OFAC screening is mandatory to ensure the applicant is not on a US government sanctions list.

#### 8.4.1 OFAC Data Lists

| List | Abbreviation | Contents |
|------|-------------|----------|
| Specially Designated Nationals | SDN | Individuals/entities owned/controlled by sanctioned countries |
| Consolidated Non-SDN | Non-SDN | Sectoral sanctions, foreign sanctions evaders |
| Entity List | EL | Commerce Department entity list |
| Denied Persons List | DPL | Denied export privileges |

#### 8.4.2 OFAC Screening Response

```json
{
  "ofacScreening": {
    "screeningId": "OFAC-2026-04-16-001",
    "screeningDate": "2026-04-16T14:30:00Z",
    "subject": {
      "firstName": "John",
      "lastName": "Smith",
      "dateOfBirth": "1988-07-15",
      "citizenship": "US"
    },
    "result": {
      "status": "CLEAR",
      "matchFound": false,
      "listsSearched": ["SDN", "NON-SDN", "ENTITY_LIST", "DPL"],
      "potentialMatches": [],
      "riskScore": 0,
      "riskLevel": "LOW"
    },
    "complianceInfo": {
      "regulatoryBasis": "31 CFR Part 501",
      "screeningProvider": "LexisNexis Bridger Insight",
      "modelVersion": "2026.1",
      "retentionDays": 2555
    }
  }
}
```

### 8.5 Identity Verification Integration in TXLife

```xml
<RequirementInfo id="ID_VERIFY_1">
  <ReqCode tc="50">Identity Verification</ReqCode>
  <ReqStatus tc="2">Received</ReqStatus>

  <OLifEExtension VendorCode="LEXISNEXIS">
    <IdentityVerification>
      <VerificationMethod>KBA</VerificationMethod>
      <VerificationResult>PASS</VerificationResult>
      <VerificationScore>4</VerificationScore>
      <VerificationDate>2026-04-16</VerificationDate>

      <SSNValidation>
        <SSNValid>true</SSNValid>
        <DeathMasterFileMatch>false</DeathMasterFileMatch>
        <SSNConsistentWithDOB>true</SSNConsistentWithDOB>
      </SSNValidation>

      <OFACScreening>
        <ScreeningResult>CLEAR</ScreeningResult>
        <MatchFound>false</MatchFound>
      </OFACScreening>
    </IdentityVerification>
  </OLifEExtension>
</RequirementInfo>
```

---

## 9. MISMO & Reinsurance Data Standards

### 9.1 MISMO (Mortgage Industry Standards Maintenance Organization)

While MISMO is primarily a mortgage industry standard, it is relevant to life insurance underwriting in two contexts:

1. **Financial underwriting** — verifying income/assets via mortgage data.
2. **Cross-industry data exchange** — some carriers use MISMO-formatted financial data for jumbo cases.

MISMO provides XML schemas for financial data that can supplement life underwriting for high-face-amount cases where financial justification is critical.

### 9.2 Reinsurance Data Standards

Reinsurance is fundamental to term life insurance — carriers cede risk on large cases to reinsurers. Data exchange between cedant (carrier) and reinsurer follows specific standards.

#### 9.2.1 ACORD Global Reinsurance Standard

ACORD provides a reinsurance-specific XML standard built on top of the TXLife framework.

**Reinsurance Application (TransType 1122):**

```xml
<TXLifeRequest>
  <TransRefGUID>reins-app-001</TransRefGUID>
  <TransType tc="1122">Reinsurance Application</TransType>
  <TransExeDate>2026-04-20</TransExeDate>

  <OLifE>
    <Holding id="H1">
      <Policy>
        <PolNumber>ACME-TERM-2026-00045821</PolNumber>
        <Life>
          <FaceAmt>500000</FaceAmt>
        </Life>

        <ReinsuranceInfo>
          <ReinsuranceType tc="1">Automatic</ReinsuranceType>
          <ReinsuranceBasis tc="1">YRT (Yearly Renewable Term)</ReinsuranceBasis>
          <CededAmount>250000</CededAmount>
          <RetainedAmount>250000</RetainedAmount>
          <TreatyNumber>TREATY-2026-001</TreatyNumber>
          <ReinsurerCode>SWISS_RE</ReinsurerCode>
          <CedantCode>ACME_LIFE</CedantCode>
        </ReinsuranceInfo>

        <ApplicationInfo>
          <UnderwritingClass tc="1">Preferred Non-Tobacco</UnderwritingClass>
          <UnderwritingApproval tc="1">Approved</UnderwritingApproval>
        </ApplicationInfo>
      </Policy>
    </Holding>

    <Party id="P1">
      <Person>
        <FirstName>John</FirstName>
        <LastName>Smith</LastName>
        <Gender tc="1">Male</Gender>
        <BirthDate>1988-07-15</BirthDate>
        <SmokerStat tc="1">Never Smoked</SmokerStat>
      </Person>
      <Risk>
        <MedicalCondition>
          <MedCondType tc="26">Elevated Cholesterol</MedCondType>
        </MedicalCondition>
      </Risk>
    </Party>

    <Relation OriginatingObjectID="H1" RelatedObjectID="P1">
      <RelationRoleCode tc="32">Insured</RelationRoleCode>
    </Relation>
  </OLifE>
</TXLifeRequest>
```

**Reinsurance Decision (TransType 1125):**

```xml
<TXLifeResponse>
  <TransRefGUID>reins-decision-001</TransRefGUID>
  <TransType tc="1125">Reinsurance Decision</TransType>

  <TransResult>
    <ResultCode tc="1">Success</ResultCode>
  </TransResult>

  <OLifE>
    <Holding id="H1">
      <Policy>
        <ReinsuranceInfo>
          <ReinsuranceDecision tc="1">Accepted</ReinsuranceDecision>
          <CededAmount>250000</CededAmount>
          <ReinsuranceClass tc="1">Preferred Non-Tobacco</ReinsuranceClass>
          <ReinsurancePremiumRate>0.65</ReinsurancePremiumRate>
          <ReinsurancePremiumBasis tc="1">Per Thousand</ReinsurancePremiumBasis>
          <DecisionDate>2026-04-20</DecisionDate>
          <ReinsurerUnderwriter>Auto-Accept System</ReinsurerUnderwriter>
        </ReinsuranceInfo>
      </Policy>
    </Holding>
  </OLifE>
</TXLifeResponse>
```

#### 9.2.2 Reinsurance Bordereau Format

A **bordereau** is a periodic report from cedant to reinsurer listing all ceded policies, premiums, and claims. Bordereaux are typically exchanged monthly or quarterly.

**Premium Bordereau (CSV/JSON):**

```json
{
  "bordereau": {
    "type": "PREMIUM",
    "period": "2026-Q1",
    "cedant": "ACME_LIFE",
    "reinsurer": "SWISS_RE",
    "treaty": "TREATY-2026-001",
    "currency": "USD",
    "submissionDate": "2026-04-15",
    "records": [
      {
        "policyNumber": "ACME-TERM-2026-00045821",
        "insuredName": "Smith, John R",
        "insuredDOB": "1988-07-15",
        "insuredGender": "M",
        "insuredState": "CO",
        "productCode": "TERM20_PREFERRED",
        "issueDate": "2026-04-25",
        "effectiveDate": "2026-04-25",
        "terminationDate": "2046-04-25",
        "faceAmount": 500000,
        "cededAmount": 250000,
        "retainedAmount": 250000,
        "underwritingClass": "PNT",
        "tobaccoStatus": "NT",
        "riskClass": "PREFERRED",
        "premiumMode": "MONTHLY",
        "grossPremium": 82.50,
        "cededPremium": 13.54,
        "reinsuranceBasis": "YRT",
        "duration": 1,
        "attainedAge": 37,
        "tableRating": 0,
        "flatExtraPerThousand": 0,
        "flatExtraDuration": 0,
        "substandard": false
      }
    ],
    "summary": {
      "totalRecords": 1,
      "totalCededFaceAmount": 250000,
      "totalCededPremium": 13.54
    }
  }
}
```

**Claims Bordereau:**

```json
{
  "bordereau": {
    "type": "CLAIMS",
    "period": "2026-Q1",
    "cedant": "ACME_LIFE",
    "reinsurer": "SWISS_RE",
    "treaty": "TREATY-2026-001",
    "records": [
      {
        "claimNumber": "CLM-2026-00123",
        "policyNumber": "ACME-TERM-2024-00012345",
        "insuredName": "Doe, Jane M",
        "insuredDOB": "1975-03-12",
        "insuredGender": "F",
        "dateOfDeath": "2026-02-28",
        "causeOfDeath": "Acute Myocardial Infarction",
        "causeOfDeathICD10": "I21.9",
        "deathCertificateNumber": "CO-2026-DC-45678",
        "faceAmount": 750000,
        "cededAmount": 500000,
        "claimAmount": 500000,
        "claimStatus": "PAID",
        "paymentDate": "2026-03-20",
        "policyDuration": 2,
        "contestabilityPeriod": false,
        "underwritingClass": "STD_NT",
        "issueAge": 49,
        "deathAge": 51
      }
    ],
    "summary": {
      "totalClaims": 1,
      "totalClaimAmount": 500000
    }
  }
}
```

### 9.3 Reinsurance Retention and Cession

| Concept | Description | Typical Values |
|---------|-------------|---------------|
| **Retention** | Amount of risk the cedant keeps | $250K–$5M per life |
| **Automatic Cession** | Risk automatically ceded under treaty (no individual approval) | Up to $10M–$25M |
| **Facultative Cession** | Large or unusual risks requiring individual reinsurer approval | >$25M or substandard |
| **YRT** | Yearly Renewable Term — premium increases with age | Most common for term |
| **Coinsurance** | Reinsurer shares proportionally in premiums and claims | Less common for term |

---

## 10. Emerging Standards

### 10.1 JSON Schemas for Modern Underwriting APIs

As carriers build modern microservice architectures, JSON-based API schemas are replacing XML-based messaging for internal and partner integrations.

#### 10.1.1 OpenAPI Specification for Underwriting Service

```yaml
openapi: 3.1.0
info:
  title: Underwriting Decision API
  version: 2.0.0
  description: RESTful API for automated underwriting decisions
paths:
  /api/v2/underwriting/cases:
    post:
      summary: Submit a new underwriting case
      operationId: createCase
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/UnderwritingCase'
      responses:
        '201':
          description: Case created successfully
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/CaseResponse'
        '400':
          description: Validation error
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorResponse'

  /api/v2/underwriting/cases/{caseId}/decision:
    get:
      summary: Get underwriting decision for a case
      operationId: getDecision
      parameters:
        - name: caseId
          in: path
          required: true
          schema:
            type: string
            format: uuid
      responses:
        '200':
          description: Decision retrieved
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/UnderwritingDecision'

components:
  schemas:
    UnderwritingCase:
      type: object
      required: [applicant, product, application]
      properties:
        applicant:
          $ref: '#/components/schemas/Applicant'
        product:
          $ref: '#/components/schemas/ProductRequest'
        application:
          $ref: '#/components/schemas/ApplicationInfo'
        evidenceResults:
          type: array
          items:
            $ref: '#/components/schemas/EvidenceResult'

    Applicant:
      type: object
      required: [firstName, lastName, dateOfBirth, gender, ssn]
      properties:
        firstName:
          type: string
          example: "John"
        lastName:
          type: string
          example: "Smith"
        dateOfBirth:
          type: string
          format: date
          example: "1988-07-15"
        gender:
          type: string
          enum: [Male, Female]
        ssn:
          type: string
          pattern: '^\d{3}-\d{2}-\d{4}$'
        tobaccoStatus:
          type: string
          enum: [NeverUsed, CurrentUser, FormerUser]
        heightInches:
          type: integer
          minimum: 36
          maximum: 96
        weightPounds:
          type: integer
          minimum: 50
          maximum: 700
        address:
          $ref: '#/components/schemas/Address'

    ProductRequest:
      type: object
      required: [productCode, faceAmount, termYears]
      properties:
        productCode:
          type: string
          example: "TERM20_PREFERRED"
        faceAmount:
          type: number
          example: 500000
        termYears:
          type: integer
          enum: [10, 15, 20, 25, 30]

    UnderwritingDecision:
      type: object
      properties:
        caseId:
          type: string
          format: uuid
        decision:
          type: string
          enum: [Approved, ApprovedWithModification, Declined, Postponed, Incomplete, CounterOffer]
        underwritingClass:
          type: string
          enum: [SuperPreferredNT, PreferredNT, StandardNT, PreferredT, StandardT, Substandard]
        tableRating:
          type: integer
          minimum: 0
          maximum: 16
        flatExtra:
          type: number
          description: "Flat extra per $1000 of coverage"
        temporaryFlatExtra:
          type: object
          properties:
            amountPerThousand:
              type: number
            durationYears:
              type: integer
        decisionDate:
          type: string
          format: date-time
        stpIndicator:
          type: boolean
        decisionReasons:
          type: array
          items:
            $ref: '#/components/schemas/DecisionReason'
        auditTrail:
          $ref: '#/components/schemas/AuditTrail'

    DecisionReason:
      type: object
      properties:
        category:
          type: string
          enum: [Medical, Financial, Lifestyle, Regulatory, DataQuality]
        code:
          type: string
        description:
          type: string
        impact:
          type: string
          enum: [Positive, Neutral, Negative, Knockout]
        debitCredits:
          type: integer
          description: "Debit/credit points applied"

    AuditTrail:
      type: object
      properties:
        rulesEngineVersion:
          type: string
        rulesExecuted:
          type: integer
        modelScores:
          type: array
          items:
            type: object
            properties:
              modelName:
                type: string
              modelVersion:
                type: string
              score:
                type: number
              percentile:
                type: integer
```

### 10.2 GraphQL for Underwriting

GraphQL enables flexible querying of underwriting data, letting consumers request exactly the fields they need.

#### 10.2.1 GraphQL Schema

```graphql
type Query {
  underwritingCase(id: ID!): UnderwritingCase
  searchCases(filter: CaseFilter!): CaseConnection!
  evidenceStatus(caseId: ID!): [EvidenceRequirement!]!
}

type Mutation {
  submitApplication(input: ApplicationInput!): UnderwritingCase!
  addEvidence(caseId: ID!, evidence: EvidenceInput!): EvidenceResult!
  requestDecision(caseId: ID!): UnderwritingDecision!
  overrideDecision(caseId: ID!, override: OverrideInput!): UnderwritingDecision!
}

type Subscription {
  caseStatusChanged(caseId: ID!): CaseStatusEvent!
  evidenceReceived(caseId: ID!): EvidenceReceivedEvent!
  decisionReady(caseId: ID!): DecisionReadyEvent!
}

type UnderwritingCase {
  id: ID!
  trackingId: String!
  status: CaseStatus!
  applicant: Applicant!
  product: ProductRequest!
  evidence: [EvidenceRequirement!]!
  decision: UnderwritingDecision
  createdAt: DateTime!
  updatedAt: DateTime!
  auditLog: [AuditEntry!]!
}

type Applicant {
  id: ID!
  firstName: String!
  lastName: String!
  dateOfBirth: Date!
  gender: Gender!
  age: Int!
  tobaccoStatus: TobaccoStatus!
  bmi: Float
  address: Address!
  riskFactors: RiskFactors!
}

type RiskFactors {
  medicalConditions: [MedicalCondition!]!
  familyHistory: [FamilyHistoryItem!]!
  substanceUse: [SubstanceUseItem!]!
  occupationRisk: OccupationRisk
  avocationRisk: [AvocationRisk!]!
}

type EvidenceRequirement {
  id: ID!
  type: EvidenceType!
  status: EvidenceStatus!
  vendor: String
  orderedDate: DateTime
  receivedDate: DateTime
  result: EvidenceResult
}

union EvidenceResult = LabResult | MIBResult | RxResult | MVRResult | CreditResult | EHRResult

type LabResult {
  vendorCode: String!
  collectionDate: DateTime!
  testResults: [LabTestResult!]!
}

type LabTestResult {
  loincCode: String!
  testName: String!
  value: Float!
  units: String!
  referenceRange: ReferenceRange!
  abnormalFlag: AbnormalFlag!
}

type MIBResult {
  matchFound: Boolean!
  hits: [MIBHit!]!
  planFAlert: Boolean!
}

type MIBHit {
  code: String!
  severity: Int!
  description: String!
  reportDate: Date!
}

type UnderwritingDecision {
  decision: DecisionType!
  underwritingClass: UnderwritingClass
  tableRating: Int
  flatExtra: Float
  stpIndicator: Boolean!
  decisionDate: DateTime!
  reasons: [DecisionReason!]!
}

enum CaseStatus {
  SUBMITTED
  IN_REVIEW
  AWAITING_EVIDENCE
  DECISION_PENDING
  APPROVED
  DECLINED
  WITHDRAWN
  POSTPONED
}

enum EvidenceType {
  LAB_BLOOD
  LAB_URINE
  MIB
  PRESCRIPTION_HISTORY
  MVR
  CREDIT_SCORE
  APS
  EHR
  PARAMEDICAL_EXAM
  PHONE_INTERVIEW
  IDENTITY_VERIFICATION
  OFAC_SCREENING
}

enum DecisionType {
  APPROVED
  APPROVED_WITH_MODIFICATION
  DECLINED
  POSTPONED
  INCOMPLETE
  COUNTER_OFFER
}

enum UnderwritingClass {
  SUPER_PREFERRED_NT
  PREFERRED_NT
  STANDARD_PLUS_NT
  STANDARD_NT
  PREFERRED_T
  STANDARD_T
  SUBSTANDARD
}

input CaseFilter {
  status: CaseStatus
  dateFrom: DateTime
  dateTo: DateTime
  agentId: String
  applicantName: String
  limit: Int = 25
  offset: Int = 0
}

input ApplicationInput {
  applicant: ApplicantInput!
  product: ProductInput!
  beneficiaries: [BeneficiaryInput!]!
  agentId: String!
}
```

#### 10.2.2 GraphQL Query Example

```graphql
query GetUnderwritingCase($caseId: ID!) {
  underwritingCase(id: $caseId) {
    id
    status
    applicant {
      firstName
      lastName
      age
      bmi
      tobaccoStatus
    }
    product {
      productCode
      faceAmount
      termYears
    }
    evidence {
      type
      status
      receivedDate
      result {
        ... on LabResult {
          testResults {
            loincCode
            testName
            value
            units
            abnormalFlag
          }
        }
        ... on MIBResult {
          matchFound
          hits {
            code
            severity
            description
          }
        }
        ... on RxResult {
          totalPrescriptions
          controlledSubstanceCount
          chronicConditionsInferred
        }
      }
    }
    decision {
      decision
      underwritingClass
      tableRating
      stpIndicator
      reasons {
        category
        description
        impact
      }
    }
  }
}
```

### 10.3 Event-Driven Architecture — CloudEvents & AsyncAPI

Modern underwriting systems are increasingly event-driven. Two emerging standards govern event schemas.

#### 10.3.1 CloudEvents for Underwriting Events

```json
{
  "specversion": "1.0",
  "type": "com.acmelife.underwriting.evidence.received",
  "source": "/underwriting/evidence-orchestrator",
  "id": "evt-2026-04-17-001",
  "time": "2026-04-17T14:30:00Z",
  "datacontenttype": "application/json",
  "subject": "case/a1b2c3d4-e5f6-7890",
  "data": {
    "caseId": "a1b2c3d4-e5f6-7890",
    "evidenceType": "LAB_BLOOD",
    "vendor": "EXAMONE",
    "status": "RECEIVED",
    "receivedAt": "2026-04-17T14:30:00Z",
    "resultSummary": {
      "totalTests": 19,
      "abnormalCount": 2,
      "criticalCount": 0
    }
  }
}
```

**Common Underwriting Event Types:**

| Event Type | Trigger | Consumers |
|-----------|---------|-----------|
| `application.submitted` | New application received | Case creation, evidence ordering |
| `evidence.ordered` | Evidence request sent to vendor | Tracking, SLA monitoring |
| `evidence.received` | Evidence result returned | Rules engine, case status update |
| `decision.rendered` | Underwriting decision made | Notification, policy issue, reinsurance |
| `case.status.changed` | Any case status transition | Dashboard, reporting, agent notification |
| `requirement.waived` | Evidence requirement waived by rules | Case status update, audit |
| `referral.created` | Case referred to human underwriter | Workbench, queue management |

#### 10.3.2 AsyncAPI Specification

```yaml
asyncapi: 2.6.0
info:
  title: Underwriting Events API
  version: 1.0.0
  description: Event-driven underwriting system events

channels:
  underwriting/evidence/received:
    description: Published when evidence is received from a vendor
    subscribe:
      operationId: onEvidenceReceived
      message:
        $ref: '#/components/messages/EvidenceReceivedEvent'

  underwriting/decision/rendered:
    description: Published when an underwriting decision is made
    subscribe:
      operationId: onDecisionRendered
      message:
        $ref: '#/components/messages/DecisionRenderedEvent'

  underwriting/case/status-changed:
    description: Published on any case status change
    subscribe:
      operationId: onCaseStatusChanged
      message:
        $ref: '#/components/messages/CaseStatusChangedEvent'

components:
  messages:
    EvidenceReceivedEvent:
      payload:
        type: object
        required: [caseId, evidenceType, vendor, status]
        properties:
          caseId:
            type: string
            format: uuid
          evidenceType:
            type: string
            enum: [LAB_BLOOD, LAB_URINE, MIB, RX, MVR, CREDIT, APS, EHR]
          vendor:
            type: string
          status:
            type: string
            enum: [RECEIVED, PARTIAL, ERROR]
          receivedAt:
            type: string
            format: date-time
          resultSummary:
            type: object

    DecisionRenderedEvent:
      payload:
        type: object
        required: [caseId, decision, decisionDate]
        properties:
          caseId:
            type: string
            format: uuid
          decision:
            type: string
            enum: [APPROVED, DECLINED, POSTPONED, COUNTER_OFFER, REFERRED]
          underwritingClass:
            type: string
          tableRating:
            type: integer
          stpIndicator:
            type: boolean
          decisionDate:
            type: string
            format: date-time
```

---

## 11. Data Governance for Underwriting

### 11.1 Overview

Underwriting data includes some of the most sensitive information categories: medical records (PHI), financial data, government identifiers (SSN), and consumer reports. Robust data governance is not optional — it is a regulatory, legal, and ethical mandate.

### 11.2 Data Classification for Underwriting

| Data Category | Classification | Examples | Regulatory Framework |
|--------------|---------------|----------|---------------------|
| **PHI (Protected Health Information)** | Highly Sensitive | Lab results, Rx history, APS, MIB codes, EHR data | HIPAA |
| **PII (Personally Identifiable Information)** | Sensitive | SSN, DOB, name, address, driver's license | State privacy laws, CCPA |
| **Consumer Report Data** | Sensitive / Regulated | Credit score, MVR | FCRA |
| **Financial Data** | Sensitive | Income, net worth, tax returns | State insurance regulations |
| **Application Data** | Confidential | Lifestyle questions, beneficiary info | State insurance regulations |
| **Underwriting Decision Data** | Internal Confidential | Risk scores, rule outcomes, debits/credits | Internal policy, actuarial standards |
| **Actuarial/Mortality Data** | Internal | Mortality tables, A/E ratios | Actuarial standards of practice |

### 11.3 HIPAA Compliance for Health Data

HIPAA (Health Insurance Portability and Accountability Act) governs PHI in underwriting.

#### 11.3.1 HIPAA Applicability to Life Insurance Underwriting

| HIPAA Component | Applicability | Notes |
|----------------|--------------|-------|
| **Privacy Rule** | Partially applies | Life insurers are not "covered entities" per se, but receive PHI from covered entities (labs, providers) |
| **Security Rule** | Applies to PHI received | Must protect electronic PHI (ePHI) with administrative, physical, and technical safeguards |
| **Authorization** | Required | Must obtain HIPAA authorization (ACORD 161) before accessing medical records |
| **Minimum Necessary** | Applies | Only request/access the minimum PHI needed for underwriting |
| **Business Associate Agreement** | Required with vendors | BAAs needed with ExamOne, Milliman, MIB, EHR vendors |
| **Breach Notification** | Applies | Must notify affected individuals and HHS of PHI breaches |

#### 11.3.2 HIPAA Technical Safeguards

| Safeguard | Requirement | Implementation |
|-----------|-------------|----------------|
| **Access Control** | Unique user IDs, emergency access procedures | RBAC, MFA, break-glass procedures |
| **Audit Controls** | Record and examine activity in PHI systems | Audit logging, SIEM integration |
| **Integrity Controls** | Protect ePHI from improper alteration | Checksums, digital signatures |
| **Transmission Security** | Encrypt ePHI in transit | TLS 1.2+, VPN for vendor connections |
| **Encryption at Rest** | Encrypt stored ePHI | AES-256, HSM for key management |

### 11.4 Data Retention Policies

| Data Type | Minimum Retention | Maximum Retention | Basis |
|-----------|------------------|-------------------|-------|
| Application data | Life of policy + 7 years | Life of policy + 10 years | State insurance regulations |
| Lab results | 7 years from decision | 10 years | HIPAA, state laws |
| MIB inquiry/response | 7 years | 7 years | MIB membership rules |
| Rx data | 7 years from decision | 10 years | HIPAA, state laws |
| MVR data | 3–7 years (state-dependent) | 10 years | FCRA, state DMV rules |
| Credit score data | Duration of underwriting only | Dispose after decision | FCRA disposal rule |
| APS / EHR records | Life of policy + 7 years | Life of policy + 10 years | HIPAA, contestability |
| Underwriting decision | Life of policy + 7 years | Indefinite (for mortality studies) | Actuarial need |
| Identity verification | 5 years | 7 years | BSA/AML, OFAC |
| Reinsurance bordereau | 10 years | Indefinite | Reinsurance treaty terms |
| Audit logs | 6 years | 10 years | HIPAA, SOX (if publicly traded) |

### 11.5 Encryption Standards

| Context | Standard | Algorithm | Key Size |
|---------|----------|-----------|----------|
| **Data at Rest** | AES | AES-256-GCM | 256-bit |
| **Data in Transit** | TLS | TLS 1.2 or 1.3 | 256-bit symmetric / 2048-bit RSA |
| **Database Encryption** | TDE | AES-256 | 256-bit |
| **Field-Level Encryption** | Application-layer | AES-256-GCM or ChaCha20-Poly1305 | 256-bit |
| **SSN/PII Tokenization** | Vault-based | Format-preserving (FPE) or random token | N/A |
| **Key Management** | HSM / KMS | RSA-2048 or ECDSA P-256 for wrapping | 256-bit (symmetric) |
| **Digital Signatures** | XML/JSON Signature | RSA-SHA256 or ECDSA-SHA256 | 2048-bit (RSA) |

### 11.6 PII Handling — Tokenization & Masking

```
TOKENIZATION FLOW:

┌───────────┐    ┌──────────────┐    ┌───────────────┐
│  Raw SSN  │───▶│  Token Vault │───▶│  Token ID     │
│ 123-45-6789│   │  (HSM-backed)│    │ tok_a1b2c3d4  │
└───────────┘    └──────────────┘    └───────────────┘

USAGE IN UNDERWRITING:
- Application database stores: tok_a1b2c3d4
- Only MIB/vendor integration layer de-tokenizes
- Audit logs show: tok_a1b2c3d4 (never raw SSN)
- Underwriter workbench shows: ***-**-6789 (masked)

MASKING RULES:
┌──────────────────┬──────────────┬───────────────────┐
│ Field            │ Storage      │ Display           │
├──────────────────┼──────────────┼───────────────────┤
│ SSN              │ Tokenized    │ ***-**-6789       │
│ DOB              │ Encrypted    │ **/**/1988        │
│ Driver's License │ Tokenized    │ CO-*****6789      │
│ Bank Account     │ Tokenized    │ ****4321          │
│ Lab Results      │ Encrypted    │ Full (authorized) │
│ MIB Codes        │ Encrypted    │ Full (authorized) │
│ Rx Details       │ Encrypted    │ Full (authorized) │
│ Address          │ Plaintext    │ Full              │
│ Name             │ Plaintext    │ Full              │
│ Phone            │ Encrypted    │ (303) ***-1234    │
│ Email            │ Encrypted    │ j***@email.com    │
└──────────────────┴──────────────┴───────────────────┘
```

### 11.7 Data Access Control Matrix

| Role | Application | Lab/PHI | MIB | Rx | MVR | Credit | Decision | Audit |
|------|------------|---------|-----|----|----|--------|----------|-------|
| **Applicant** | Own data | N/A | N/A | N/A | N/A | Own score | Own decision | N/A |
| **Agent** | View | N/A | N/A | N/A | N/A | N/A | View decision | N/A |
| **Auto-UW Engine** | Full | Full | Full | Full | Full | Full | Read/Write | Write |
| **Underwriter** | Full | Full | Full | Full | Full | View | Read/Write | Write |
| **UW Manager** | Full | Full | Full | Full | Full | View | Override | View |
| **Medical Director** | Full | Full | Full | Full | N/A | N/A | Override | View |
| **Actuary** | Aggregate | Aggregate | Aggregate | Aggregate | Aggregate | Aggregate | Aggregate | N/A |
| **Compliance** | Audit | Audit | Audit | Audit | Audit | Audit | Audit | Full |
| **IT/DevOps** | N/A (encrypted) | N/A (encrypted) | N/A (encrypted) | N/A (encrypted) | N/A (encrypted) | N/A (encrypted) | N/A | View |
| **Reinsurer** | Subset | Subset | Summary | Summary | Summary | N/A | View | N/A |

---

## 12. Cross-Reference Tables — Vendor-to-Canonical Mapping

### 12.1 Why Canonical Mapping Matters

Every vendor delivers data in their own format with their own codes. A canonical data model acts as the internal "lingua franca" that normalizes vendor-specific codes into a single, consistent representation for rules, scoring, and storage.

```
┌──────────────┐    ┌──────────────────┐    ┌──────────────────┐
│  ExamOne     │───▶│                  │    │                  │
│  Lab Codes   │    │   CANONICAL      │    │  Underwriting    │
├──────────────┤    │   DATA MODEL     │───▶│  Rules Engine    │
│  Quest       │───▶│                  │    │                  │
│  Lab Codes   │    │  (Internal)      │    └──────────────────┘
├──────────────┤    │                  │
│  MIB Codes   │───▶│                  │
├──────────────┤    │                  │
│  Rx NDC      │───▶│                  │
├──────────────┤    └──────────────────┘
│  MVR ACD     │───▶│                  │
│  Codes       │    │                  │
└──────────────┘    └──────────────────┘
```

### 12.2 Lab Code Cross-Reference: Vendor → LOINC → Canonical

| Vendor Test Code | Vendor Name | LOINC Code | Canonical Code | Canonical Name | UW Category |
|-----------------|-------------|-----------|---------------|---------------|-------------|
| EXAMONE-CHOL | ExamOne Total Cholesterol | 2093-3 | LAB_CHOL_TOTAL | Total Cholesterol | Lipid Panel |
| QUEST-TC | Quest Total Cholesterol | 2093-3 | LAB_CHOL_TOTAL | Total Cholesterol | Lipid Panel |
| EXAMONE-HDL | ExamOne HDL | 2085-9 | LAB_CHOL_HDL | HDL Cholesterol | Lipid Panel |
| QUEST-HDL | Quest HDL Direct | 2085-9 | LAB_CHOL_HDL | HDL Cholesterol | Lipid Panel |
| EXAMONE-LDL | ExamOne LDL (calc) | 13457-7 | LAB_CHOL_LDL | LDL Cholesterol | Lipid Panel |
| QUEST-LDL | Quest LDL (calc) | 13457-7 | LAB_CHOL_LDL | LDL Cholesterol | Lipid Panel |
| EXAMONE-TRIG | ExamOne Triglycerides | 2571-8 | LAB_TRIG | Triglycerides | Lipid Panel |
| EXAMONE-GLU | ExamOne Glucose (Fasting) | 2345-7 | LAB_GLUCOSE_FAST | Fasting Glucose | Diabetes |
| QUEST-GLUF | Quest Glucose, Fasting | 2345-7 | LAB_GLUCOSE_FAST | Fasting Glucose | Diabetes |
| EXAMONE-A1C | ExamOne HbA1c | 4548-4 | LAB_HBA1C | Hemoglobin A1c | Diabetes |
| QUEST-HBA1C | Quest Hemoglobin A1c | 4548-4 | LAB_HBA1C | Hemoglobin A1c | Diabetes |
| EXAMONE-ALT | ExamOne ALT | 1742-6 | LAB_ALT | ALT (SGPT) | Liver |
| EXAMONE-AST | ExamOne AST | 1920-8 | LAB_AST | AST (SGOT) | Liver |
| EXAMONE-GGT | ExamOne GGT | 2324-2 | LAB_GGT | GGT | Liver |
| EXAMONE-CREAT | ExamOne Creatinine | 2160-0 | LAB_CREATININE | Creatinine | Kidney |
| EXAMONE-EGFR | ExamOne eGFR | 33914-3 | LAB_EGFR | eGFR | Kidney |
| EXAMONE-COT | ExamOne Cotinine | 14959-1 | LAB_COTININE | Cotinine (Urine) | Substance |
| EXAMONE-COC | ExamOne Cocaine | 5794-3 | LAB_COCAINE | Cocaine Metabolite | Substance |
| EXAMONE-HIV | ExamOne HIV Ab | 19659-2 | LAB_HIV | HIV Antibody | Substance |
| EXAMONE-PSA | ExamOne PSA | 10886-0 | LAB_PSA | PSA | Cancer Screen |

### 12.3 MIB Code → ICD-10 → Canonical Condition Mapping

| MIB Code | MIB Description | ICD-10 Codes | Canonical Condition Code | Canonical Condition |
|----------|----------------|-------------|-------------------------|-------------------|
| 010 | Hypertension | I10, I11.x, I12.x | COND_HYPERTENSION | Hypertension |
| 013 | Coronary Artery Disease | I25.10, I25.11x | COND_CAD | Coronary Artery Disease |
| 014 | Myocardial Infarction | I21.x, I22.x | COND_MI | Myocardial Infarction |
| 020 | Asthma | J45.x | COND_ASTHMA | Asthma |
| 021 | COPD | J44.x | COND_COPD | COPD |
| 023 | Sleep Apnea | G47.33 | COND_SLEEP_APNEA | Obstructive Sleep Apnea |
| 033 | Hepatitis | B18.x (B/C) | COND_HEPATITIS | Hepatitis B/C |
| 040 | Diabetes Type 1 | E10.x | COND_DM_T1 | Diabetes Mellitus Type 1 |
| 041 | Diabetes Type 2 | E11.x | COND_DM_T2 | Diabetes Mellitus Type 2 |
| 044 | Elevated Cholesterol | E78.0, E78.5 | COND_HYPERLIPIDEMIA | Hyperlipidemia |
| 070 | Malignant Neoplasm — Skin | C43.x (melanoma) | COND_CANCER_SKIN | Skin Cancer |
| 071 | Malignant Neoplasm — Breast | C50.x | COND_CANCER_BREAST | Breast Cancer |
| 090 | Depression | F32.x, F33.x | COND_DEPRESSION | Major Depressive Disorder |
| 092 | Bipolar Disorder | F31.x | COND_BIPOLAR | Bipolar Disorder |
| 094 | Substance Abuse — Alcohol | F10.x | COND_ALCOHOL_USE | Alcohol Use Disorder |
| 095 | Substance Abuse — Drugs | F11.x–F16.x, F19.x | COND_DRUG_USE | Drug Use Disorder |
| 104 | DUI/DWI | N/A (non-medical) | RISK_DUI | DUI/DWI History |
| 110 | Tobacco Use | Z72.0, F17.x | RISK_TOBACCO | Tobacco Use |
| 120 | HIV/AIDS | B20, Z21 | COND_HIV | HIV Positive |

### 12.4 Rx Therapeutic Class → Canonical Condition Mapping

| Therapeutic Class Code | Therapeutic Class Name | Canonical Condition Code | Confidence | Notes |
|----------------------|----------------------|-------------------------|-----------|-------|
| CV350 | HMG CoA Reductase Inhibitors (Statins) | COND_HYPERLIPIDEMIA | HIGH | >90% used for cholesterol |
| CV800 | ACE Inhibitors | COND_HYPERTENSION | HIGH | Also used for CHF, diabetic nephropathy |
| CV400 | Beta Blockers | COND_HYPERTENSION | MEDIUM | Also for arrhythmia, migraine, anxiety |
| HS875 | Biguanides (Metformin) | COND_DM_T2 | HIGH | Also used for PCOS |
| HS500 | Insulin | COND_DM_T1 or COND_DM_T2 | HIGH | Check type based on other meds |
| CN550 | SSRIs | COND_DEPRESSION | MEDIUM | Also for anxiety, OCD, PTSD |
| CN700 | Benzodiazepines | COND_ANXIETY | MEDIUM | Also for insomnia, seizures |
| CN750 | Antipsychotics (Atypical) | COND_BIPOLAR or COND_SCHIZOPHRENIA | HIGH | Context-dependent |
| CN300 | Opioid Analgesics | COND_CHRONIC_PAIN | MEDIUM | Duration matters — acute vs. chronic |
| RE200 | Short-Acting Beta Agonists | COND_ASTHMA | HIGH | Rescue inhaler |
| RE300 | Inhaled Corticosteroids | COND_ASTHMA | HIGH | Maintenance therapy |
| BL110 | Anticoagulants (Warfarin, DOACs) | COND_AFIB or COND_DVT_PE | HIGH | Depends on other conditions |
| GU600 | PDE5 Inhibitors | COND_ED | MEDIUM | Benign unless cardiac meds also present |
| ON300 | Antineoplastic Agents | COND_CANCER | VERY HIGH | Active cancer treatment |
| AM100 | Penicillins | NONE | N/A | Acute infection — ignore for UW |
| AM800 | Fluoroquinolones | NONE | N/A | Acute infection — usually ignore |
| DE100 | Topical Corticosteroids | NONE | N/A | Skin conditions — usually ignore |

### 12.5 MVR Violation Code → Canonical Risk Mapping

| ACD Code | ACD Description | Canonical Risk Code | Risk Level | UW Points |
|----------|----------------|--------------------|-----------|-----------| 
| A20 | DUI — Alcohol | MVR_DUI_ALCOHOL | MAJOR | 15 |
| A21 | DUI — Drugs | MVR_DUI_DRUGS | MAJOR | 15 |
| A25 | DUI — BAC ≥ 0.08 | MVR_DUI_BAC | MAJOR | 15 |
| B01 | Hit and Run — Injury | MVR_HIT_RUN_INJURY | MAJOR | 20 |
| B19 | Driving While Suspended | MVR_SUSPENDED | MAJOR | 10 |
| S92 | Speeding 11–15 over | MVR_SPEED_MINOR | MINOR | 2 |
| S93 | Speeding 16–20 over | MVR_SPEED_MODERATE | MINOR | 3 |
| S94 | Speeding 21+ over | MVR_SPEED_MAJOR | MODERATE | 5 |
| S95 | Reckless Driving | MVR_RECKLESS | MAJOR | 8 |
| M16 | Failure to Yield | MVR_FTYR | MINOR | 1 |
| M40 | Following Too Closely | MVR_FOLLOWING | MINOR | 1 |
| U03 | Vehicular Manslaughter | MVR_MANSLAUGHTER | SEVERE | 25 |
| W00 | License Withdrawal | MVR_LIC_WITHDRAWAL | MAJOR | 10 |

### 12.6 Building a Code Mapping Service

```python
from dataclasses import dataclass
from enum import Enum
from typing import Optional


class VendorSource(Enum):
    EXAMONE = "EXAMONE"
    QUEST = "QUEST"
    MILLIMAN = "MILLIMAN"
    MIB = "MIB"
    LEXISNEXIS = "LEXISNEXIS"
    TRANSUNION = "TRANSUNION"
    FHIR = "FHIR"


class CanonicalCategory(Enum):
    LIPID = "LIPID"
    DIABETES = "DIABETES"
    LIVER = "LIVER"
    KIDNEY = "KIDNEY"
    CARDIAC = "CARDIAC"
    RESPIRATORY = "RESPIRATORY"
    MENTAL_HEALTH = "MENTAL_HEALTH"
    SUBSTANCE = "SUBSTANCE"
    CANCER = "CANCER"
    MUSCULOSKELETAL = "MUSCULOSKELETAL"
    NEUROLOGICAL = "NEUROLOGICAL"
    DRIVING = "DRIVING"
    FINANCIAL = "FINANCIAL"


@dataclass
class CodeMapping:
    vendor_source: VendorSource
    vendor_code: str
    vendor_description: str
    canonical_code: str
    canonical_description: str
    category: CanonicalCategory
    loinc_code: Optional[str] = None
    icd10_codes: Optional[list[str]] = None
    confidence: str = "HIGH"


class CanonicalCodeService:
    """
    Central service for mapping vendor-specific codes to the
    carrier's internal canonical code system.
    """

    def __init__(self):
        self._lab_mappings: dict[tuple[VendorSource, str], CodeMapping] = {}
        self._condition_mappings: dict[str, CodeMapping] = {}
        self._rx_mappings: dict[str, CodeMapping] = {}
        self._mvr_mappings: dict[str, CodeMapping] = {}
        self._load_mappings()

    def _load_mappings(self):
        lab_maps = [
            CodeMapping(VendorSource.EXAMONE, "EXAMONE-CHOL", "Total Cholesterol",
                       "LAB_CHOL_TOTAL", "Total Cholesterol", CanonicalCategory.LIPID,
                       loinc_code="2093-3"),
            CodeMapping(VendorSource.QUEST, "QUEST-TC", "Total Cholesterol",
                       "LAB_CHOL_TOTAL", "Total Cholesterol", CanonicalCategory.LIPID,
                       loinc_code="2093-3"),
            CodeMapping(VendorSource.EXAMONE, "EXAMONE-A1C", "HbA1c",
                       "LAB_HBA1C", "Hemoglobin A1c", CanonicalCategory.DIABETES,
                       loinc_code="4548-4"),
            CodeMapping(VendorSource.EXAMONE, "EXAMONE-ALT", "ALT",
                       "LAB_ALT", "ALT (SGPT)", CanonicalCategory.LIVER,
                       loinc_code="1742-6"),
            CodeMapping(VendorSource.EXAMONE, "EXAMONE-GGT", "GGT",
                       "LAB_GGT", "GGT", CanonicalCategory.LIVER,
                       loinc_code="2324-2"),
        ]
        for m in lab_maps:
            self._lab_mappings[(m.vendor_source, m.vendor_code)] = m

    def resolve_lab(self, vendor: VendorSource, vendor_code: str) -> Optional[CodeMapping]:
        return self._lab_mappings.get((vendor, vendor_code))

    def resolve_by_loinc(self, loinc_code: str) -> Optional[CodeMapping]:
        for mapping in self._lab_mappings.values():
            if mapping.loinc_code == loinc_code:
                return mapping
        return None

    def resolve_mib(self, mib_code: str) -> Optional[CodeMapping]:
        return self._condition_mappings.get(mib_code)

    def resolve_rx_class(self, therapeutic_class_code: str) -> Optional[CodeMapping]:
        return self._rx_mappings.get(therapeutic_class_code)

    def resolve_mvr(self, acd_code: str) -> Optional[CodeMapping]:
        return self._mvr_mappings.get(acd_code)
```

### 12.7 FHIR-to-Canonical Mapping

| FHIR Resource | FHIR Code System | FHIR Code | Canonical Code | Notes |
|--------------|-----------------|-----------|---------------|-------|
| Condition | ICD-10-CM | I10 | COND_HYPERTENSION | Direct mapping |
| Condition | ICD-10-CM | E11.65 | COND_DM_T2 | Type 2 with hyperglycemia |
| Condition | ICD-10-CM | E78.00 | COND_HYPERLIPIDEMIA | Pure hypercholesterolemia |
| Condition | SNOMED CT | 13644009 | COND_HYPERLIPIDEMIA | Hypercholesterolemia |
| Condition | SNOMED CT | 38341003 | COND_HYPERTENSION | Hypertensive disorder |
| Condition | SNOMED CT | 44054006 | COND_DM_T2 | Type 2 diabetes |
| Observation | LOINC | 2093-3 | LAB_CHOL_TOTAL | Total cholesterol |
| Observation | LOINC | 4548-4 | LAB_HBA1C | HbA1c |
| Observation | LOINC | 72166-2 | RISK_TOBACCO | Smoking status |
| MedicationRequest | RxNorm | 83367 | RX_ATORVASTATIN | Atorvastatin |
| MedicationRequest | RxNorm | 6809 | RX_METFORMIN | Metformin |
| MedicationRequest | RxNorm | 29046 | RX_LISINOPRIL | Lisinopril |

---

## 13. Appendix — Quick-Reference Cheat Sheet

### 13.1 Vendor Integration Summary

| Data Source | Primary Vendor(s) | Format | Protocol | Avg Response Time | Cost/Hit |
|------------|-------------------|--------|----------|-------------------|----------|
| Lab (Blood/Urine) | ExamOne, Quest | HL7 ORU, TXLife XML | SFTP, API | 24–48 hours | $30–$60 |
| MIB | MIB Inc. | TXLife XML | Secure API | 2–5 seconds | $2–$5 |
| Rx History | Milliman, ExamOne | JSON, TXLife XML | API | 5–15 seconds | $10–$20 |
| MVR | LexisNexis, State DMV | JSON, XML | API | 5–30 seconds | $5–$15 |
| Credit Score | LexisNexis, TransUnion | JSON, XML | API | 2–5 seconds | $3–$8 |
| EHR/FHIR | Human API, Health Gorilla | FHIR R4 JSON | REST API | Minutes to hours | $15–$40 |
| APS (Traditional) | CRL, Parameds Plus | PDF, CDA | Fax, mail, API | 15–45 days | $25–$75 |
| Identity (KBA) | LexisNexis | JSON | API | 1–3 seconds | $1–$3 |
| OFAC Screening | LexisNexis Bridger | JSON | API | 1–2 seconds | $0.50–$2 |

### 13.2 Standard Code Systems Reference

| Code System | Maintainer | Usage in UW | Example |
|------------|-----------|-------------|---------|
| **LOINC** | Regenstrief Institute | Lab test identification | 2093-3 = Total Cholesterol |
| **ICD-10-CM** | WHO / CMS | Diagnosis codes | E11.65 = Type 2 Diabetes |
| **SNOMED CT** | SNOMED International | Clinical terminology | 38341003 = Hypertension |
| **NDC** | FDA | Drug identification | 0071-0155-23 = Atorvastatin |
| **RxNorm** | NLM (NIH) | Drug normalization | 83367 = Atorvastatin |
| **ACD** | AAMVA | MVR violation codes | S92 = Speeding 11–15 over |
| **ACORD tc** | ACORD | Insurance data enumerations | tc="1" Gender = Male |
| **MIB Codes** | MIB Inc. | Insurance medical history | 044 = Elevated Cholesterol |
| **GPI** | Medi-Span | Drug classification | 39-40-00-20 = Atorvastatin |
| **CPT** | AMA | Procedure codes | 80053 = Comprehensive Metabolic Panel |
| **HL7 v2.x** | HL7 International | Lab messaging | ORU^R01 = Observation Result |
| **FHIR R4** | HL7 International | EHR interoperability | Condition, Observation, Patient |

### 13.3 TXLife TransType Quick Reference

| tc | Name | Direction | When Used |
|----|------|-----------|-----------|
| 103 | New Application | Distributor → Carrier | Application submission |
| 121 | UW Status Update | Carrier → Distributor | Status notification |
| 152 | Requirement Order | Carrier → Vendor | Order evidence |
| 153 | Requirement Result | Vendor → Carrier | Return evidence results |
| 228 | Policy Issue | Carrier → All | Policy issued notification |
| 501 | General Inquiry | Any | Ad hoc data query |
| 511 | Case Status Request | Distributor → Carrier | Status poll |
| 1122 | Reinsurance Application | Carrier → Reinsurer | Cede risk |
| 1125 | Reinsurance Decision | Reinsurer → Carrier | Accept/decline/modify |

### 13.4 Key Data Formats by Use Case

| Use Case | Primary Format | Fallback Format | Emerging Format |
|----------|---------------|-----------------|-----------------|
| Application Submission | TXLife XML (tc=103) | ACORD 103 (PDF) | ACORD JSON |
| Lab Results | HL7 ORU v2.5.1 | TXLife XML | FHIR Observation |
| MIB Inquiry/Response | TXLife XML | MIB Proprietary | — |
| Rx History | Milliman JSON / TXLife | ScriptCheck XML | FHIR MedicationRequest |
| MVR | LexisNexis JSON | State-specific flat file | — |
| Credit Score | Vendor JSON | TXLife OLifEExtension | — |
| EHR/APS | C-CDA (XML) | Scanned PDF | FHIR R4 Bundle |
| Identity/OFAC | Vendor JSON | XML | — |
| Reinsurance | TXLife XML | CSV Bordereau | ACORD Global Reinsurance |
| Events (internal) | CloudEvents JSON | Proprietary | AsyncAPI |
| API Specification | OpenAPI 3.x (YAML/JSON) | WSDL (SOAP) | GraphQL SDL |

### 13.5 Regulatory Compliance Checklist

| Regulation | Data Affected | Key Requirement | Penalty for Non-Compliance |
|-----------|--------------|-----------------|---------------------------|
| **HIPAA** | PHI (labs, Rx, APS, EHR, MIB) | Authorization, encryption, audit trails, BAAs | Up to $1.5M per violation category |
| **FCRA** | Consumer reports (credit, MVR) | Permissible purpose, adverse action notice, disposal | $100–$1,000 per violation + punitive damages |
| **GLBA** | All financial/insurance data | Privacy notices, safeguarding, opt-out rights | FTC enforcement, state AG action |
| **CCPA/CPRA** | PII (California residents) | Right to know, delete, opt-out of sale | $2,500–$7,500 per intentional violation |
| **State Insurance Laws** | All underwriting data | Unfair discrimination, genetic info restrictions, data use notices | Varies by state — fines, license action |
| **ADA / GINA** | Genetic information, disability | Cannot use genetic testing for UW (GINA), disability protections | Federal enforcement, lawsuits |
| **OFAC** | Identity data | Sanctions screening required | Criminal penalties, severe fines |
| **BSA/AML** | Identity data, financial data | Suspicious activity reporting, CDD | Criminal penalties |

---

> **Series Navigation**
>
> This article is Part 3 of the Term Life Insurance Underwriting series:
>
> - [Part 1: Term Underwriting Fundamentals](./01_TERM_UNDERWRITING_FUNDAMENTALS.md) — Complete domain encyclopedia covering risk assessment, classification, and rating from first principles.
> - [Part 2: Automated Underwriting Engine](./02_AUTOMATED_UNDERWRITING_ENGINE.md) — Architecture deep dive for building automated decisioning systems.
> - **Part 3: Underwriting Data Standards & Formats** *(this article)* — Every data standard, code system, and schema used in underwriting.
> - Part 4: Underwriting Rules & Decision Logic *(coming next)* — Comprehensive rules catalog, debit/credit systems, and decision tables.
> - Part 5: Regulatory & Compliance Framework *(coming soon)* — State-by-state regulations, fair underwriting, and audit requirements.
> - Part 6: Vendor Integration Playbook *(coming soon)* — Implementation guides for ExamOne, Milliman, MIB, LexisNexis, and more.
> - Part 7: Testing & Quality Assurance *(coming soon)* — Test strategies, synthetic data generation, and regression frameworks.
