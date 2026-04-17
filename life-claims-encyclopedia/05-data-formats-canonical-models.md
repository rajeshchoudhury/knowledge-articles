# Article 5: Data Formats & Canonical Data Models for Life Claims

## Designing the Information Architecture for Claims Systems

---

## 1. Introduction

A canonical data model (CDM) is the single, authoritative representation of business data within an enterprise. For life insurance claims, the CDM must represent every entity, relationship, and attribute needed to process claims from intake through settlement. This article provides a complete reference for designing the data architecture of a claims system.

---

## 2. Canonical Data Model Design Principles

### 2.1 Core Principles

| Principle | Description | Application |
|---|---|---|
| **Single Source of Truth** | One authoritative definition of each entity | Claim record is the SSOT for claim status |
| **Standards Alignment** | Align with ACORD, FHIR where applicable | Use ACORD type codes as basis for enumerations |
| **Temporal Modeling** | Track state changes over time | Claim status history, beneficiary designation history |
| **Jurisdiction Awareness** | Support multi-state/multi-country variations | State-specific fields, configurable business rules |
| **Product Agnostic** | Support all life product types | Flexible enough for Term, Whole Life, UL, VUL, Annuity |
| **Extensibility** | Support new fields without schema breaks | Extension mechanisms for carrier-specific attributes |
| **Audit Trail** | Every change must be traceable | Who, what, when, why for all modifications |
| **Data Lineage** | Track where data originated | Source system, timestamp, confidence score |

---

## 3. Core Entity Schemas

### 3.1 Claim Entity

```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "title": "LifeInsuranceClaim",
  "type": "object",
  "properties": {
    "claimId": {
      "type": "string",
      "description": "Unique claim identifier",
      "pattern": "^CLM-[0-9]{4}-[0-9]{5,8}$"
    },
    "claimType": {
      "type": "string",
      "enum": ["DEATH", "ACCIDENTAL_DEATH", "ACCELERATED_DEATH_BENEFIT", 
               "WAIVER_OF_PREMIUM", "MATURITY", "SURRENDER", "ANNUITY_DEATH",
               "DISMEMBERMENT", "CRITICAL_ILLNESS"]
    },
    "claimStatus": {
      "type": "string",
      "enum": ["REPORTED", "PENDING_DOCUMENTS", "UNDER_REVIEW", "SIU_REFERRAL",
               "APPROVED", "DENIED", "CONTESTED", "PAYMENT_PROCESSING", "PAID",
               "CLOSED", "REOPENED"]
    },
    "claimSubStatus": {
      "type": "string",
      "description": "Detailed sub-status within the main status"
    },
    "priority": {
      "type": "string",
      "enum": ["STANDARD", "EXPEDITED", "URGENT"]
    },
    "complexityTier": {
      "type": "integer",
      "minimum": 1,
      "maximum": 4
    },
    "stpEligible": {
      "type": "boolean"
    },
    "dates": {
      "type": "object",
      "properties": {
        "dateOfLoss": { "type": "string", "format": "date" },
        "dateReported": { "type": "string", "format": "date-time" },
        "dateReceived": { "type": "string", "format": "date" },
        "dateAllDocsReceived": { "type": "string", "format": "date" },
        "dateDecisionMade": { "type": "string", "format": "date" },
        "datePaymentIssued": { "type": "string", "format": "date" },
        "dateClosed": { "type": "string", "format": "date" },
        "stateDueDate": { "type": "string", "format": "date" },
        "interestStartDate": { "type": "string", "format": "date" }
      }
    },
    "lossInformation": { "$ref": "#/definitions/LossInformation" },
    "policyReference": { "$ref": "#/definitions/PolicyReference" },
    "claimants": {
      "type": "array",
      "items": { "$ref": "#/definitions/Claimant" }
    },
    "beneficiaryAllocations": {
      "type": "array",
      "items": { "$ref": "#/definitions/BeneficiaryAllocation" }
    },
    "benefitCalculation": { "$ref": "#/definitions/BenefitCalculation" },
    "documents": {
      "type": "array",
      "items": { "$ref": "#/definitions/ClaimDocument" }
    },
    "payments": {
      "type": "array",
      "items": { "$ref": "#/definitions/ClaimPayment" }
    },
    "activities": {
      "type": "array",
      "items": { "$ref": "#/definitions/ClaimActivity" }
    },
    "flags": { "$ref": "#/definitions/ClaimFlags" },
    "assignment": { "$ref": "#/definitions/ExaminerAssignment" },
    "jurisdiction": {
      "type": "object",
      "properties": {
        "stateOfPolicy": { "type": "string" },
        "stateOfDeath": { "type": "string" },
        "stateOfResidence": { "type": "string" },
        "governingState": { "type": "string" },
        "erisaApplicable": { "type": "boolean" }
      }
    },
    "reinsurance": { "$ref": "#/definitions/ReinsuranceInfo" },
    "metadata": {
      "type": "object",
      "properties": {
        "createdBy": { "type": "string" },
        "createdDate": { "type": "string", "format": "date-time" },
        "lastModifiedBy": { "type": "string" },
        "lastModifiedDate": { "type": "string", "format": "date-time" },
        "version": { "type": "integer" },
        "sourceSystem": { "type": "string" },
        "sourceChannel": { "type": "string" }
      }
    }
  },
  "definitions": {
    "LossInformation": {
      "type": "object",
      "properties": {
        "dateOfDeath": { "type": "string", "format": "date" },
        "timeOfDeath": { "type": "string", "format": "time" },
        "placeOfDeath": {
          "type": "object",
          "properties": {
            "facilityName": { "type": "string" },
            "facilityType": { 
              "type": "string", 
              "enum": ["HOSPITAL", "HOME", "NURSING_HOME", "ER", "DOA", "OTHER"] 
            },
            "city": { "type": "string" },
            "state": { "type": "string" },
            "country": { "type": "string" },
            "county": { "type": "string" }
          }
        },
        "causeOfDeath": {
          "type": "object",
          "properties": {
            "immediateCause": { "type": "string" },
            "icdCode": { "type": "string" },
            "sequentialCauses": {
              "type": "array",
              "items": {
                "type": "object",
                "properties": {
                  "cause": { "type": "string" },
                  "icdCode": { "type": "string" },
                  "interval": { "type": "string" }
                }
              }
            },
            "otherSignificantConditions": { "type": "string" }
          }
        },
        "mannerOfDeath": {
          "type": "string",
          "enum": ["NATURAL", "ACCIDENT", "SUICIDE", "HOMICIDE", 
                   "UNDETERMINED", "PENDING"]
        },
        "autopsyPerformed": { "type": "boolean" },
        "autopsyFindingsAvailable": { "type": "boolean" },
        "tobaccoContributory": { "type": "boolean" },
        "pregnancyRelated": { "type": "boolean" },
        "injuryDetails": {
          "type": "object",
          "properties": {
            "injuryDate": { "type": "string", "format": "date" },
            "injuryPlace": { "type": "string" },
            "injuryDescription": { "type": "string" },
            "transportationRelated": { "type": "boolean" }
          }
        },
        "certifier": {
          "type": "object",
          "properties": {
            "name": { "type": "string" },
            "title": { "type": "string" },
            "licenseNumber": { "type": "string" },
            "certifierType": { 
              "type": "string", 
              "enum": ["ATTENDING_PHYSICIAN", "MEDICAL_EXAMINER", "CORONER"] 
            }
          }
        },
        "deathCertificateNumber": { "type": "string" },
        "deathCertificateState": { "type": "string" }
      }
    },
    "PolicyReference": {
      "type": "object",
      "properties": {
        "policyNumber": { "type": "string" },
        "productType": {
          "type": "string",
          "enum": ["TERM_LEVEL", "TERM_DECREASING", "TERM_ART", "TERM_ROP",
                   "WHOLE_LIFE", "WHOLE_LIFE_LP", "WHOLE_LIFE_SP",
                   "UNIVERSAL_LIFE", "GUARANTEED_UL", "INDEXED_UL", 
                   "VARIABLE_UL", "VARIABLE_LIFE",
                   "SURVIVORSHIP", "GROUP_TERM", "GROUP_UL",
                   "FIXED_ANNUITY", "VARIABLE_ANNUITY", "INDEXED_ANNUITY"]
        },
        "policyStatusAtDeath": { "type": "string" },
        "issueDate": { "type": "string", "format": "date" },
        "effectiveDate": { "type": "string", "format": "date" },
        "faceAmount": { "type": "number" },
        "deathBenefitOption": { "type": "string" },
        "accountValue": { "type": "number" },
        "cashSurrenderValue": { "type": "number" },
        "loanBalance": { "type": "number" },
        "loanInterestAccrued": { "type": "number" },
        "premiumsDue": { "type": "number" },
        "lastPremiumDate": { "type": "string", "format": "date" },
        "contestabilityStatus": {
          "type": "string",
          "enum": ["WITHIN_PERIOD", "BEYOND_PERIOD"]
        },
        "suicideExclusionStatus": {
          "type": "string",
          "enum": ["WITHIN_PERIOD", "BEYOND_PERIOD"]
        },
        "reinstatementDate": { "type": "string", "format": "date" },
        "riders": {
          "type": "array",
          "items": {
            "type": "object",
            "properties": {
              "riderType": { "type": "string" },
              "riderStatus": { "type": "string" },
              "benefitAmount": { "type": "number" },
              "effectiveDate": { "type": "string", "format": "date" }
            }
          }
        },
        "assignments": {
          "type": "array",
          "items": {
            "type": "object",
            "properties": {
              "assignmentType": { "type": "string", "enum": ["ABSOLUTE", "COLLATERAL"] },
              "assigneeName": { "type": "string" },
              "assignmentDate": { "type": "string", "format": "date" },
              "assignmentAmount": { "type": "number" }
            }
          }
        },
        "operatingCompany": { "type": "string" },
        "administrationSystem": { "type": "string" }
      }
    },
    "BenefitCalculation": {
      "type": "object",
      "properties": {
        "calculationDate": { "type": "string", "format": "date-time" },
        "calculatedBy": { "type": "string" },
        "baseBenefit": { "type": "number" },
        "riderBenefits": {
          "type": "array",
          "items": {
            "type": "object",
            "properties": {
              "riderType": { "type": "string" },
              "amount": { "type": "number" }
            }
          }
        },
        "totalGrossBenefit": { "type": "number" },
        "deductions": {
          "type": "object",
          "properties": {
            "loanBalance": { "type": "number" },
            "loanInterest": { "type": "number" },
            "overduePremium": { "type": "number" },
            "priorAdbPayment": { "type": "number" },
            "assignmentAmount": { "type": "number" },
            "otherDeductions": { "type": "number" },
            "totalDeductions": { "type": "number" }
          }
        },
        "netBenefit": { "type": "number" },
        "interestOnBenefit": {
          "type": "object",
          "properties": {
            "rate": { "type": "number" },
            "fromDate": { "type": "string", "format": "date" },
            "toDate": { "type": "string", "format": "date" },
            "amount": { "type": "number" }
          }
        },
        "premiumRefund": { "type": "number" },
        "totalPayable": { "type": "number" },
        "taxWithholding": { "type": "number" },
        "netPayment": { "type": "number" }
      }
    },
    "ClaimDocument": {
      "type": "object",
      "properties": {
        "documentId": { "type": "string" },
        "documentType": {
          "type": "string",
          "enum": ["DEATH_CERTIFICATE", "CLAIM_FORM", "APS", "HOSPITAL_RECORDS",
                   "POLICE_REPORT", "AUTOPSY_REPORT", "TOXICOLOGY_REPORT",
                   "CORONER_REPORT", "EMPLOYER_STATEMENT", "PROOF_OF_IDENTITY",
                   "PROBATE_DOCUMENTS", "TRUST_DOCUMENTS", "ASSIGNMENT_DOCS",
                   "HIPAA_AUTHORIZATION", "CORRESPONDENCE", "OTHER"]
        },
        "documentStatus": {
          "type": "string",
          "enum": ["REQUIRED", "REQUESTED", "RECEIVED", "VALIDATED", 
                   "ACCEPTED", "REJECTED", "WAIVED", "NOT_APPLICABLE"]
        },
        "receivedDate": { "type": "string", "format": "date" },
        "dmsReference": { "type": "string" },
        "ocrConfidenceScore": { "type": "number" },
        "extractedData": { "type": "object" },
        "validationResults": {
          "type": "array",
          "items": {
            "type": "object",
            "properties": {
              "rule": { "type": "string" },
              "result": { "type": "string", "enum": ["PASS", "FAIL", "WARNING"] },
              "message": { "type": "string" }
            }
          }
        }
      }
    },
    "Claimant": {
      "type": "object",
      "properties": {
        "claimantId": { "type": "string" },
        "personInfo": { "$ref": "#/definitions/PersonInfo" },
        "relationshipToInsured": { "type": "string" },
        "beneficiaryDesignation": {
          "type": "string",
          "enum": ["PRIMARY", "CONTINGENT", "TERTIARY", "ESTATE", "OTHER"]
        },
        "contactPreference": {
          "type": "string",
          "enum": ["EMAIL", "PHONE", "MAIL"]
        },
        "preferredLanguage": { "type": "string" },
        "representedByAttorney": { "type": "boolean" },
        "attorneyInfo": { "type": "object" },
        "identityVerified": { "type": "boolean" },
        "identityVerificationMethod": { "type": "string" }
      }
    },
    "PersonInfo": {
      "type": "object",
      "properties": {
        "firstName": { "type": "string" },
        "middleName": { "type": "string" },
        "lastName": { "type": "string" },
        "suffix": { "type": "string" },
        "dateOfBirth": { "type": "string", "format": "date" },
        "ssn": { "type": "string" },
        "gender": { "type": "string", "enum": ["MALE", "FEMALE", "OTHER"] },
        "addresses": { "type": "array" },
        "phones": { "type": "array" },
        "emails": { "type": "array" }
      }
    },
    "BeneficiaryAllocation": {
      "type": "object",
      "properties": {
        "beneficiaryId": { "type": "string" },
        "personInfo": { "$ref": "#/definitions/PersonInfo" },
        "designationType": { "type": "string" },
        "allocationType": { "type": "string", "enum": ["PERCENTAGE", "EQUAL_SHARE", "SPECIFIC_AMOUNT"] },
        "percentage": { "type": "number" },
        "amount": { "type": "number" },
        "perStirpes": { "type": "boolean" },
        "isMinor": { "type": "boolean" },
        "guardianInfo": { "type": "object" },
        "isTrust": { "type": "boolean" },
        "trustInfo": { "type": "object" },
        "paymentMethod": { "type": "string" },
        "bankingInfo": { "type": "object" }
      }
    },
    "ClaimPayment": {
      "type": "object",
      "properties": {
        "paymentId": { "type": "string" },
        "paymentType": {
          "type": "string",
          "enum": ["DEATH_BENEFIT", "RIDER_BENEFIT", "INTEREST", "PREMIUM_REFUND",
                   "RETURN_OF_PREMIUM", "SUPPLEMENTAL", "VOID_REISSUE"]
        },
        "payeeId": { "type": "string" },
        "grossAmount": { "type": "number" },
        "taxWithholding": { "type": "number" },
        "netAmount": { "type": "number" },
        "paymentMethod": {
          "type": "string",
          "enum": ["CHECK", "EFT_ACH", "WIRE", "RETAINED_ASSET_ACCOUNT"]
        },
        "paymentStatus": {
          "type": "string",
          "enum": ["PENDING", "AUTHORIZED", "ISSUED", "CLEARED", "VOIDED", 
                   "STOPPED", "RETURNED", "ESCHEATTED"]
        },
        "paymentDate": { "type": "string", "format": "date" },
        "checkNumber": { "type": "string" },
        "eftReference": { "type": "string" },
        "form1099Type": { "type": "string" },
        "form1099Amount": { "type": "number" }
      }
    },
    "ClaimActivity": {
      "type": "object",
      "properties": {
        "activityId": { "type": "string" },
        "activityType": {
          "type": "string",
          "enum": ["TASK", "NOTE", "COMMUNICATION", "SYSTEM_EVENT", 
                   "STATUS_CHANGE", "DOCUMENT_ACTION", "PAYMENT_ACTION",
                   "ASSIGNMENT_CHANGE", "ESCALATION", "QA_REVIEW"]
        },
        "description": { "type": "string" },
        "createdBy": { "type": "string" },
        "createdDate": { "type": "string", "format": "date-time" },
        "dueDate": { "type": "string", "format": "date" },
        "completedDate": { "type": "string", "format": "date-time" },
        "status": { "type": "string" },
        "priority": { "type": "string" },
        "assignedTo": { "type": "string" }
      }
    },
    "ClaimFlags": {
      "type": "object",
      "properties": {
        "contestable": { "type": "boolean" },
        "suicideExclusionApplicable": { "type": "boolean" },
        "siuReferral": { "type": "boolean" },
        "litigation": { "type": "boolean" },
        "interpleader": { "type": "boolean" },
        "highValue": { "type": "boolean" },
        "regulatoryComplaint": { "type": "boolean" },
        "reinsuranceNotificationRequired": { "type": "boolean" },
        "erisaGovernedPlan": { "type": "boolean" },
        "foreignDeath": { "type": "boolean" },
        "minorBeneficiary": { "type": "boolean" },
        "stoliSuspected": { "type": "boolean" }
      }
    },
    "ExaminerAssignment": {
      "type": "object",
      "properties": {
        "examinerId": { "type": "string" },
        "examinerName": { "type": "string" },
        "examinerLevel": { "type": "string" },
        "assignmentDate": { "type": "string", "format": "date-time" },
        "teamId": { "type": "string" },
        "supervisorId": { "type": "string" }
      }
    },
    "ReinsuranceInfo": {
      "type": "object",
      "properties": {
        "reinsured": { "type": "boolean" },
        "treaties": {
          "type": "array",
          "items": {
            "type": "object",
            "properties": {
              "treatyNumber": { "type": "string" },
              "treatyType": { "type": "string" },
              "reinsurer": { "type": "string" },
              "retentionAmount": { "type": "number" },
              "cededAmount": { "type": "number" },
              "notificationDate": { "type": "string", "format": "date" },
              "recoveryAmount": { "type": "number" },
              "recoveryDate": { "type": "string", "format": "date" }
            }
          }
        }
      }
    }
  }
}
```

---

## 4. Database Design Patterns

### 4.1 Relational Schema (Core Tables)

```sql
-- Core Claim Table
CREATE TABLE claim (
    claim_id            VARCHAR(20) PRIMARY KEY,
    claim_type          VARCHAR(30) NOT NULL,
    claim_status        VARCHAR(30) NOT NULL,
    claim_sub_status    VARCHAR(50),
    priority            VARCHAR(20) DEFAULT 'STANDARD',
    complexity_tier     INTEGER,
    stp_eligible        BOOLEAN DEFAULT FALSE,
    date_of_loss        DATE NOT NULL,
    date_reported       TIMESTAMP NOT NULL,
    date_received       DATE,
    date_all_docs       DATE,
    date_decision       DATE,
    date_payment        DATE,
    date_closed         DATE,
    state_due_date      DATE,
    interest_start_date DATE,
    policy_number       VARCHAR(30) NOT NULL,
    governing_state     VARCHAR(2),
    erisa_applicable    BOOLEAN DEFAULT FALSE,
    created_by          VARCHAR(50),
    created_date        TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    modified_by         VARCHAR(50),
    modified_date       TIMESTAMP,
    version             INTEGER DEFAULT 1
);

-- Claim Status History (Event Sourcing)
CREATE TABLE claim_status_history (
    history_id          BIGSERIAL PRIMARY KEY,
    claim_id            VARCHAR(20) REFERENCES claim(claim_id),
    previous_status     VARCHAR(30),
    new_status          VARCHAR(30) NOT NULL,
    change_reason       TEXT,
    changed_by          VARCHAR(50) NOT NULL,
    changed_date        TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    system_notes        TEXT
);

-- Loss Information
CREATE TABLE claim_loss_info (
    claim_id                VARCHAR(20) PRIMARY KEY REFERENCES claim(claim_id),
    date_of_death           DATE NOT NULL,
    time_of_death           TIME,
    place_facility_name     VARCHAR(200),
    place_facility_type     VARCHAR(30),
    place_city              VARCHAR(100),
    place_state             VARCHAR(2),
    place_country           VARCHAR(3),
    place_county            VARCHAR(100),
    cause_immediate         VARCHAR(500),
    cause_icd_code          VARCHAR(10),
    manner_of_death         VARCHAR(20),
    autopsy_performed       BOOLEAN,
    autopsy_findings_avail  BOOLEAN,
    certifier_name          VARCHAR(200),
    certifier_type          VARCHAR(30),
    death_cert_number       VARCHAR(50),
    death_cert_state        VARCHAR(2)
);

-- Claimant / Beneficiary
CREATE TABLE claim_party (
    party_id            BIGSERIAL PRIMARY KEY,
    claim_id            VARCHAR(20) REFERENCES claim(claim_id),
    party_role          VARCHAR(30) NOT NULL, -- CLAIMANT, BENEFICIARY, ASSIGNEE
    first_name          VARCHAR(100),
    middle_name         VARCHAR(100),
    last_name           VARCHAR(100),
    suffix              VARCHAR(10),
    date_of_birth       DATE,
    ssn_encrypted       VARCHAR(256), -- encrypted at rest
    gender              VARCHAR(10),
    relationship        VARCHAR(50),
    designation_type    VARCHAR(20), -- PRIMARY, CONTINGENT
    allocation_pct      DECIMAL(5,2),
    per_stirpes         BOOLEAN DEFAULT FALSE,
    is_minor            BOOLEAN DEFAULT FALSE,
    is_trust            BOOLEAN DEFAULT FALSE,
    identity_verified   BOOLEAN DEFAULT FALSE,
    payment_method      VARCHAR(20),
    address_line1       VARCHAR(200),
    address_line2       VARCHAR(200),
    city                VARCHAR(100),
    state               VARCHAR(2),
    zip                 VARCHAR(10),
    country             VARCHAR(3),
    phone               VARCHAR(20),
    email               VARCHAR(200)
);

-- Benefit Calculation
CREATE TABLE claim_benefit_calc (
    calc_id             BIGSERIAL PRIMARY KEY,
    claim_id            VARCHAR(20) REFERENCES claim(claim_id),
    calc_date           TIMESTAMP NOT NULL,
    calc_by             VARCHAR(50),
    calc_version        INTEGER,
    is_final            BOOLEAN DEFAULT FALSE,
    base_benefit        DECIMAL(15,2),
    rider_benefits      DECIMAL(15,2),
    total_gross         DECIMAL(15,2),
    loan_deduction      DECIMAL(15,2),
    loan_interest_ded   DECIMAL(15,2),
    premium_deduction   DECIMAL(15,2),
    adb_deduction       DECIMAL(15,2),
    assignment_ded      DECIMAL(15,2),
    other_deductions    DECIMAL(15,2),
    total_deductions    DECIMAL(15,2),
    net_benefit         DECIMAL(15,2),
    interest_rate       DECIMAL(5,4),
    interest_from       DATE,
    interest_to         DATE,
    interest_amount     DECIMAL(15,2),
    premium_refund      DECIMAL(15,2),
    total_payable       DECIMAL(15,2),
    tax_withholding     DECIMAL(15,2),
    net_payment         DECIMAL(15,2)
);

-- Documents
CREATE TABLE claim_document (
    document_id         BIGSERIAL PRIMARY KEY,
    claim_id            VARCHAR(20) REFERENCES claim(claim_id),
    document_type       VARCHAR(50) NOT NULL,
    document_status     VARCHAR(20) NOT NULL,
    requested_date      DATE,
    received_date       DATE,
    validated_date      DATE,
    dms_reference       VARCHAR(200),
    file_name           VARCHAR(500),
    file_size           BIGINT,
    mime_type           VARCHAR(100),
    ocr_confidence      DECIMAL(5,2),
    rejection_reason    TEXT,
    waiver_reason       TEXT,
    waiver_authorized_by VARCHAR(50)
);

-- Payments
CREATE TABLE claim_payment (
    payment_id          BIGSERIAL PRIMARY KEY,
    claim_id            VARCHAR(20) REFERENCES claim(claim_id),
    party_id            BIGINT REFERENCES claim_party(party_id),
    payment_type        VARCHAR(30),
    payment_status      VARCHAR(20),
    gross_amount        DECIMAL(15,2),
    tax_withholding     DECIMAL(15,2),
    net_amount          DECIMAL(15,2),
    payment_method      VARCHAR(20),
    payment_date        DATE,
    check_number        VARCHAR(20),
    eft_reference       VARCHAR(50),
    bank_routing        VARCHAR(9),
    bank_account_enc    VARCHAR(256), -- encrypted
    voided_date         DATE,
    void_reason         TEXT,
    form_1099_type      VARCHAR(10),
    form_1099_amount    DECIMAL(15,2)
);

-- Activities / Audit Trail
CREATE TABLE claim_activity (
    activity_id         BIGSERIAL PRIMARY KEY,
    claim_id            VARCHAR(20) REFERENCES claim(claim_id),
    activity_type       VARCHAR(30) NOT NULL,
    description         TEXT,
    created_by          VARCHAR(50) NOT NULL,
    created_date        TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    due_date            DATE,
    completed_date      TIMESTAMP,
    status              VARCHAR(20),
    priority            VARCHAR(20),
    assigned_to         VARCHAR(50),
    parent_activity_id  BIGINT REFERENCES claim_activity(activity_id)
);

-- Flags
CREATE TABLE claim_flags (
    claim_id            VARCHAR(20) PRIMARY KEY REFERENCES claim(claim_id),
    contestable         BOOLEAN DEFAULT FALSE,
    suicide_exclusion   BOOLEAN DEFAULT FALSE,
    siu_referral        BOOLEAN DEFAULT FALSE,
    litigation          BOOLEAN DEFAULT FALSE,
    interpleader        BOOLEAN DEFAULT FALSE,
    high_value          BOOLEAN DEFAULT FALSE,
    reg_complaint       BOOLEAN DEFAULT FALSE,
    reinsurance_notify  BOOLEAN DEFAULT FALSE,
    erisa_governed      BOOLEAN DEFAULT FALSE,
    foreign_death       BOOLEAN DEFAULT FALSE,
    minor_beneficiary   BOOLEAN DEFAULT FALSE,
    stoli_suspected     BOOLEAN DEFAULT FALSE
);

-- Examiner Assignment
CREATE TABLE claim_assignment (
    assignment_id       BIGSERIAL PRIMARY KEY,
    claim_id            VARCHAR(20) REFERENCES claim(claim_id),
    examiner_id         VARCHAR(50) NOT NULL,
    assignment_date     TIMESTAMP NOT NULL,
    unassignment_date   TIMESTAMP,
    assignment_reason   TEXT,
    is_current          BOOLEAN DEFAULT TRUE
);
```

### 4.2 Event Store Design (for Event Sourcing)

```sql
CREATE TABLE claim_events (
    event_id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    claim_id            VARCHAR(20) NOT NULL,
    event_type          VARCHAR(100) NOT NULL,
    event_version       INTEGER NOT NULL,
    event_data          JSONB NOT NULL,
    metadata            JSONB,
    created_by          VARCHAR(50) NOT NULL,
    created_date        TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    correlation_id      UUID,
    causation_id        UUID
);

CREATE INDEX idx_claim_events_claim ON claim_events(claim_id, event_version);
CREATE INDEX idx_claim_events_type ON claim_events(event_type, created_date);

-- Example Events:
-- CLAIM_REPORTED, DOCUMENT_RECEIVED, DOCUMENT_VALIDATED,
-- COVERAGE_VERIFIED, BENEFIT_CALCULATED, DECISION_MADE,
-- PAYMENT_AUTHORIZED, PAYMENT_ISSUED, CLAIM_CLOSED,
-- EXAMINER_ASSIGNED, SIU_REFERRED, QA_COMPLETED
```

---

## 5. Data Classification and Security

### 5.1 Data Sensitivity Classification

| Classification | Data Elements | Protection Requirements |
|---|---|---|
| **PII - High Sensitivity** | SSN, Bank accounts, Tax ID | Encrypted at rest and in transit, masked in UI, access logged |
| **PII - Medium Sensitivity** | Name, DOB, Address, Phone, Email | Encrypted at rest, access controlled |
| **PHI (Protected Health Info)** | Medical records, Cause of death, APS, Diagnoses | HIPAA compliant, encrypted, minimum necessary access, audit logged |
| **Financial** | Benefit amounts, Payment amounts, Policy values | Access controlled, reconciled |
| **Operational** | Claim status, Activity notes, Tasks | Standard access control |
| **Public** | Claim statistics (aggregated), General process info | Minimal restrictions |

### 5.2 Data Masking Rules

```
MASKING RULES BY ROLE:
  EXAMINER:
    SSN: Show last 4 (***-**-6789)
    Bank Account: Show last 4 (****3210)
    Full Name: Visible
    Medical Records: Visible (HIPAA authorized)
    
  CUSTOMER SERVICE:
    SSN: Show last 4
    Bank Account: Fully masked
    Full Name: Visible
    Medical Records: Not accessible
    
  MANAGER/SUPERVISOR:
    SSN: Show last 4
    Bank Account: Show last 4
    Full Name: Visible
    Medical Records: Visible
    
  AUDITOR:
    SSN: Visible (audit function)
    Bank Account: Visible (audit function)
    Full Name: Visible
    Medical Records: Visible
    
  API/EXTERNAL:
    SSN: Never exposed
    Bank Account: Never exposed
    Full Name: First initial + Last name
    Medical Records: Never exposed
```

---

## 6. Data Quality Framework

### 6.1 Quality Dimensions

| Dimension | Definition | Claims Example | Measurement |
|---|---|---|---|
| **Accuracy** | Data correctly represents the real world | Death date matches death certificate | Error rate per field |
| **Completeness** | All required data is present | All required docs received | % complete at each stage |
| **Consistency** | Data agrees across systems | Policy number same in PAS and claims | Cross-system discrepancy rate |
| **Timeliness** | Data is available when needed | Death cert available for review | Average lag time |
| **Validity** | Data conforms to defined formats/ranges | State code is valid 2-letter code | Validation failure rate |
| **Uniqueness** | No unintended duplicates | One claim per insured per death event | Duplicate detection rate |

### 6.2 Validation Rules

```
FIELD VALIDATION RULES:
  claim_id:
    - Format: CLM-YYYY-NNNNN
    - Unique across all claims
    
  date_of_death:
    - Must be a valid date
    - Must not be in the future
    - Must not be before insured's DOB
    - Must be on or after policy effective date (or within grace period)
    
  ssn:
    - Format: NNN-NN-NNNN (9 digits)
    - Must pass SSA validation algorithm
    - Must not be known test/invalid SSN (e.g., 000-xx-xxxx, xxx-00-xxxx)
    
  policy_number:
    - Must exist in PAS
    - Must match insured identity
    
  benefit_amount:
    - Must be >= 0
    - Must not exceed face amount + riders - deductions
    - Must match benefit calculation worksheet
    
  payment_amount:
    - Sum of all payments must equal total payable
    - Each payment must match beneficiary allocation
    
  state_code:
    - Must be valid US state/territory code
    - Must match policy jurisdiction or death location
```

---

## 7. Data Integration Patterns

### 7.1 Claims Data Flow Architecture

```
┌──────────────────────────────────────────────────────────────┐
│                    DATA INTEGRATION LAYER                      │
├──────────────────────────────────────────────────────────────┤
│                                                                │
│  SOURCE SYSTEMS          INTEGRATION          TARGET SYSTEMS  │
│                                                                │
│  ┌──────────┐     ┌──────────────┐     ┌──────────────┐     │
│  │   PAS    │────▶│              │────▶│ Claims DB    │     │
│  └──────────┘     │              │     └──────────────┘     │
│  ┌──────────┐     │   Enterprise │     ┌──────────────┐     │
│  │   CRM    │────▶│   Service    │────▶│ Data         │     │
│  └──────────┘     │   Bus /      │     │ Warehouse    │     │
│  ┌──────────┐     │   API        │     └──────────────┘     │
│  │  DMS     │────▶│   Gateway    │     ┌──────────────┐     │
│  └──────────┘     │              │────▶│ Reporting    │     │
│  ┌──────────┐     │              │     └──────────────┘     │
│  │ External │────▶│              │     ┌──────────────┐     │
│  │ Services │     │              │────▶│ Reinsurance  │     │
│  └──────────┘     └──────────────┘     │ System       │     │
│                                         └──────────────┘     │
│                                                                │
└──────────────────────────────────────────────────────────────┘
```

---

## 8. Summary

The data architecture is the foundation of every claims system. Key principles:

1. **Build a canonical data model** aligned with ACORD standards but tailored to your carrier's needs
2. **Consider event sourcing** for full audit trail and temporal queries
3. **Classify and protect data** based on sensitivity (PII, PHI, financial)
4. **Validate data aggressively** at every system boundary
5. **Design for extensibility** - new products and regulatory changes are constant
6. **Plan for data quality** measurement and remediation from day one
7. **Use JSON schemas** for API contracts and document validation
8. **Separate operational and analytical data stores** for performance

---

*Previous: [Article 4: Data Standards](04-data-standards.md)*
*Next: [Article 6: Process Flows - End-to-End Claims Lifecycle](06-process-flows.md)*
