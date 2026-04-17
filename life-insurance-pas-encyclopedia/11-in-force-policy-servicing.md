# Article 11: In-Force Policy Servicing

## Table of Contents

1. [Introduction & Scope](#1-introduction--scope)
2. [Policy Change Categories](#2-policy-change-categories)
3. [Beneficiary Management](#3-beneficiary-management)
4. [Policy Loans](#4-policy-loans)
5. [Withdrawals & Partial Surrenders](#5-withdrawals--partial-surrenders)
6. [Face Amount Changes](#6-face-amount-changes)
7. [Premium Changes](#7-premium-changes)
8. [Fund Transfers (Variable Products)](#8-fund-transfers-variable-products)
9. [1035 Exchange Processing](#9-1035-exchange-processing)
10. [Anniversary Processing](#10-anniversary-processing)
11. [Correspondence Generation](#11-correspondence-generation)
12. [Entity-Relationship Model](#12-entity-relationship-model)
13. [ACORD TXLife Change Request Messages](#13-acord-txlife-change-request-messages)
14. [BPMN Process Flows](#14-bpmn-process-flows)
15. [STP Rules for Auto-Processing](#15-stp-rules-for-auto-processing)
16. [Microservice Architecture](#16-microservice-architecture)
17. [Sample Payloads](#17-sample-payloads)
18. [Appendices](#18-appendices)

---

## 1. Introduction & Scope

In-force policy servicing is the operational backbone of any life insurance Policy Administration System (PAS). Once a policy is issued and placed in-force, it enters a lifecycle that may span decades. During that time, the policyholder, agent, or third party may request hundreds of distinct service transactions. A modern PAS must orchestrate these changes while maintaining actuarial integrity, regulatory compliance, tax qualification, and an auditable history.

### 1.1 Scope of In-Force Servicing

In-force servicing encompasses **every post-issue, pre-claim transaction** applied to a life insurance policy. The scope includes:

| Domain | Example Transactions |
|--------|---------------------|
| Administrative | Address change, name correction, agent of record change |
| Financial | Premium mode change, loan, withdrawal, face amount change |
| Ownership | Absolute assignment, collateral assignment, trust transfer |
| Beneficiary | Primary/contingent designation, irrevocable changes |
| Rider | Add rider, remove rider, exercise conversion privilege |
| Regulatory | 1035 exchange, Section 7702 compliance testing |
| Cyclical | Anniversary processing, dividend declaration, interest crediting |
| Correspondence | Annual statements, tax forms, required notices |

### 1.2 Guiding Principles

1. **Immutable Audit Trail**: Every transaction must produce an immutable audit record capturing the before-state, the after-state, the requestor, the authorizer, and the effective timestamp.
2. **Effective Date Discipline**: Transactions may be effective retroactively, currently, or future-dated. The PAS must support all three modes and correctly unwind/re-process dependent calculations.
3. **Tax Qualification Preservation**: Financial changes must be evaluated against Section 7702 (definition of life insurance), Section 7702A (MEC testing), and IRC Section 72 (taxation of distributions).
4. **Regulatory Compliance**: State-specific rules govern notice timing, free-look periods, and change requirements. The PAS must maintain a jurisdictional rule engine.
5. **Straight-Through Processing (STP)**: The majority of routine changes should be processed without human intervention. Only exception-based transactions require manual review.

### 1.3 Key Actors

```mermaid
graph LR
    PH[Policyholder] -->|Self-Service| Portal[Customer Portal]
    AG[Agent/Advisor] -->|Service Request| AgentPortal[Agent Portal]
    CSR[Customer Service Rep] -->|Contact Center| AdminUI[Admin UI]
    Portal --> API[Servicing API Gateway]
    AgentPortal --> API
    AdminUI --> API
    API --> Engine[Transaction Engine]
    Engine --> PAS[(Policy Admin System)]
    Engine --> Audit[(Audit Log)]
    Engine --> Correspondence[Correspondence Engine]
    Engine --> Tax[Tax Engine]
```

---

## 2. Policy Change Categories

### 2.1 Administrative Changes

Administrative changes modify non-financial attributes of the policy or associated parties. They are typically low-risk and high-volume, making them prime candidates for STP.

#### 2.1.1 Address Change

| Attribute | Detail |
|-----------|--------|
| **ACORD Transaction** | `OLI_TRANS_ADDRCHG` (tc="1001") |
| **Triggering Events** | Policyholder request, USPS NCOA update, returned mail |
| **Validation Rules** | USPS address standardization, OFAC screening on new address, state of issue impact assessment |
| **Downstream Impact** | Tax jurisdiction, premium tax state, regulatory correspondence routing |
| **STP Eligible** | Yes — auto-approve if USPS-validated and no OFAC hit |

**Address Change Data Model:**

```json
{
  "transactionType": "ADDRESS_CHANGE",
  "policyNumber": "LIF-2024-00012345",
  "effectiveDate": "2025-03-15",
  "requestedBy": {
    "partyId": "PTY-001",
    "role": "OWNER"
  },
  "addressChange": {
    "partyId": "PTY-001",
    "addressType": "RESIDENCE",
    "previousAddress": {
      "line1": "123 Main Street",
      "line2": "Apt 4B",
      "city": "Hartford",
      "state": "CT",
      "zip": "06103",
      "country": "US"
    },
    "newAddress": {
      "line1": "456 Oak Avenue",
      "line2": null,
      "city": "Boston",
      "state": "MA",
      "zip": "02108",
      "country": "US"
    },
    "uspsValidated": true,
    "ofacScreenResult": "CLEAR"
  }
}
```

**State-of-Issue Impact Assessment:**

When a policyholder moves to a new state, the PAS must evaluate:

- Whether the new state requires different non-forfeiture minimums
- Whether premium tax rates change
- Whether new state-specific notices are required (e.g., California Annual Privacy Notice)
- Whether replacement regulation differences affect pending transactions
- Whether the policy was issued in a community property state or the new state is one

#### 2.1.2 Name Change

| Attribute | Detail |
|-----------|--------|
| **ACORD Transaction** | `OLI_TRANS_NAMECHG` (tc="1002") |
| **Triggering Events** | Marriage, divorce, legal name change, name correction |
| **Required Documentation** | Court order, marriage certificate, divorce decree |
| **Validation Rules** | OFAC re-screening on new name, identity verification |
| **STP Eligible** | Conditional — auto-approve for corrections; manual review for legal name changes |

#### 2.1.3 Agent of Record Change

Agent of Record (AOR) changes are administratively simple but have significant downstream compensation implications.

```mermaid
flowchart TD
    A[AOR Change Request Received] --> B{Is Policy in Contest Period?}
    B -->|Yes| C[Reject - Policy in Underwriting/Contest]
    B -->|No| D{Does Current Agent Consent?}
    D -->|Yes| E[Process AOR Change]
    D -->|No| F{State Allows Without Consent?}
    F -->|Yes| G[Process with Notification]
    F -->|No| H[Reject - Agent Consent Required]
    E --> I[Update Agent Hierarchy]
    G --> I
    I --> J[Recalculate Commission Splits]
    J --> K[Notify Both Agents]
    K --> L[Update Agent Portal Access]
```

**Commission Impact Rules:**

| Scenario | Renewal Commission Assignment |
|----------|------------------------------|
| AOR change in policy year 1 | New agent receives renewals starting next period |
| AOR change in policy year 2+ | New agent receives renewals starting next period |
| AOR change with trail commission | Trails follow the policy to new agent |
| AOR change on group case | Master agent change affects certificate-level servicing |

#### 2.1.4 Contact Information Changes

Contact information changes include phone number, email address, and communication preference updates.

**Communication Preference Matrix:**

| Preference | Options | Regulatory Constraint |
|-----------|---------|----------------------|
| Delivery Method | Paper, Email, Portal | Some states require paper for specific notices (lapse, annual statement) |
| Language | English, Spanish, Chinese, etc. | Must honor state-mandated language accessibility |
| Frequency | Standard, Consolidated | Annual statements cannot be deferred beyond regulatory deadlines |
| Opt-In / Opt-Out | Marketing, Service, Regulatory | Regulatory communications cannot be opted out |

### 2.2 Financial Changes

Financial changes alter the monetary values, charges, or cash flows of a policy. They require rigorous actuarial and tax validation.

#### 2.2.1 Face Amount Increase

*(Detailed in Section 6.1)*

#### 2.2.2 Face Amount Decrease

*(Detailed in Section 6.2)*

#### 2.2.3 Premium Mode Change

A premium mode change alters the frequency of premium payments (annual → quarterly, monthly → semi-annual, etc.).

**Modal Factor Table (Typical):**

| Mode | Factor | Annualized Equivalent |
|------|--------|----------------------|
| Annual | 1.000 | Base premium × 1.000 |
| Semi-Annual | 0.520 | Base premium × 1.040 |
| Quarterly | 0.265 | Base premium × 1.060 |
| Monthly (Direct Bill) | 0.090 | Base premium × 1.080 |
| Monthly (PAC/EFT) | 0.0875 | Base premium × 1.050 |

**Premium Mode Change Processing:**

```mermaid
flowchart TD
    A[Premium Mode Change Request] --> B[Validate New Mode]
    B --> C{Minimum Premium Met?}
    C -->|No| D[Reject - Below Minimum]
    C -->|Yes| E[Calculate New Modal Premium]
    E --> F{Mid-Billing Cycle?}
    F -->|Yes| G[Pro-Rate Current Period]
    F -->|No| H[Apply at Next Billing Cycle]
    G --> I[Update Billing Schedule]
    H --> I
    I --> J[Generate Confirmation Letter]
    J --> K[Update Premium Receivable]
```

#### 2.2.4 Fund Transfer (Variable Products)

*(Detailed in Section 8)*

#### 2.2.5 Policy Loan

*(Detailed in Section 4)*

#### 2.2.6 Withdrawal / Partial Surrender

*(Detailed in Section 5)*

### 2.3 Ownership Changes

Ownership changes transfer legal control of the policy from one party to another. They are among the most complex servicing transactions due to their tax, legal, and regulatory implications.

#### 2.3.1 Absolute Assignment

An absolute assignment transfers all rights, title, and interest in the policy to a new owner. The previous owner retains no rights.

**Tax Implications:**

| Transfer Type | Tax Treatment |
|--------------|---------------|
| Gift (no consideration) | Gift tax rules apply; FMV of policy is the gift amount. Donor may need to file Form 709. |
| Sale (for consideration) | Transfer-for-value rule applies; death benefit may become partially taxable under IRC §101(a)(2) |
| Exception: Transfer to insured | Transfer-for-value exception — death benefit retains tax-free status |
| Exception: Transfer to partner of insured | Transfer-for-value exception |
| Exception: Transfer to partnership of insured | Transfer-for-value exception |
| Exception: Transfer to corporation of insured | Transfer-for-value exception |
| Carryover basis transfer | Original cost basis transfers to new owner |

**Absolute Assignment Processing:**

```json
{
  "transactionType": "ABSOLUTE_ASSIGNMENT",
  "policyNumber": "LIF-2024-00012345",
  "effectiveDate": "2025-06-01",
  "assignor": {
    "partyId": "PTY-001",
    "name": "John A. Smith",
    "ssn": "***-**-1234",
    "relationship": "INSURED_OWNER"
  },
  "assignee": {
    "partyId": "PTY-010",
    "name": "Smith Family Irrevocable Trust",
    "tin": "***-**-5678",
    "entityType": "TRUST",
    "trustee": "Jane B. Smith"
  },
  "consideration": {
    "type": "GIFT",
    "amount": 0.00,
    "transferForValueExceptionCode": "NONE"
  },
  "consentRequired": {
    "irrevocableBeneficiary": false,
    "collateralAssignee": false
  }
}
```

#### 2.3.2 Collateral Assignment

A collateral assignment pledges the policy as security for a debt. The assignee (lender) has a limited interest only up to the amount of the debt.

**Collateral Assignment Rules:**

1. **Partial Interest**: The lender's interest is limited to the outstanding loan balance.
2. **Death Benefit Priority**: Proceeds first satisfy the lender's interest; the remainder goes to the beneficiary.
3. **Policyholder Retains Rights**: The owner retains all other rights (loan, withdrawal, beneficiary change) subject to lender consent if required by the assignment form.
4. **Release**: When the debt is satisfied, the lender executes a release form.

**Collateral Assignment Data Model:**

```json
{
  "transactionType": "COLLATERAL_ASSIGNMENT",
  "policyNumber": "LIF-2024-00012345",
  "effectiveDate": "2025-04-01",
  "assignor": {
    "partyId": "PTY-001",
    "name": "John A. Smith"
  },
  "assignee": {
    "partyId": "PTY-020",
    "name": "First National Bank",
    "tin": "12-3456789",
    "entityType": "CORPORATION"
  },
  "assignmentDetails": {
    "debtAmount": 250000.00,
    "interestLimitedTo": "DEBT_AMOUNT",
    "lenderConsentRequiredForChanges": true,
    "releaseCondition": "DEBT_SATISFACTION"
  }
}
```

#### 2.3.3 Change of Ownership

A change of ownership is functionally similar to an absolute assignment but is typically used in specific scenarios:

- Divorce settlement (QDRO or property settlement)
- Corporate-owned to individually-owned (and vice versa)
- Key-person policy reassignment

**Divorce/QDRO Processing:**

```mermaid
flowchart TD
    A[Divorce Decree/QDRO Received] --> B[Verify Court Order Validity]
    B --> C{Policy Identified in Order?}
    C -->|No| D[Request Clarification]
    C -->|Yes| E{Transfer Type?}
    E -->|Full Transfer| F[Process Ownership Change]
    E -->|Split Value| G[Process Partial Surrender + New Policy]
    E -->|Beneficiary Change Only| H[Process Beneficiary Update]
    F --> I[Update Owner Record]
    I --> J[Update Tax ID for Future Reporting]
    J --> K[Incident to Divorce - No Tax Event per IRC §1041]
    K --> L[Generate Confirmation]
```

#### 2.3.4 Trust Assignment

Trust assignments transfer policy ownership into a trust vehicle. Common trust types include:

| Trust Type | Purpose | Tax Treatment |
|-----------|---------|---------------|
| Irrevocable Life Insurance Trust (ILIT) | Remove policy from insured's estate | Premiums may be gift-taxable; death benefit excluded from estate |
| Revocable Living Trust | Avoid probate | No gift tax; included in estate |
| Charitable Remainder Trust (CRT) | Charitable planning | Income tax deduction for charitable portion |
| Grantor Retained Annuity Trust (GRAT) | Estate planning with retained interest | Complex gift tax calculations |

### 2.4 Beneficiary Changes

*(Detailed in Section 3)*

### 2.5 Rider Changes

#### 2.5.1 Add Rider

Adding a rider to an in-force policy typically requires:

1. **Eligibility Check**: Is the rider available for the product at the insured's current attained age?
2. **Underwriting**: Some riders (e.g., Waiver of Premium, Accidental Death Benefit) require evidence of insurability.
3. **Premium Calculation**: Additional rider premium or COI charge calculation.
4. **Effective Date Determination**: Anniversary date or request date, depending on carrier rules.
5. **Section 7702 Re-test**: If the rider alters the death benefit or premium structure, a re-qualification may be needed.

#### 2.5.2 Remove Rider

Rider removal processing:

1. **Confirm Rider Is Optional**: Mandatory riders (e.g., some state-required riders) cannot be removed.
2. **Forfeiture of Benefits**: Any accumulated rider value (e.g., paid-up additions from a PUA rider) must be handled.
3. **Premium Adjustment**: Reduce the premium by the rider charge.
4. **Impact Assessment**: Removing a rider may affect policy guarantees. For example, removing a no-lapse guarantee rider terminates the no-lapse protection.

#### 2.5.3 Exercise Rider Privilege

Certain riders grant the policyholder the right to take specific actions:

| Rider | Exercise Action |
|-------|----------------|
| Conversion Privilege (Term) | Convert term policy to permanent insurance without evidence of insurability |
| Guaranteed Insurability Option (GIO) | Purchase additional insurance at specified ages/events without evidence |
| Accelerated Death Benefit (ADB) | Access a portion of the death benefit upon qualifying terminal/chronic illness |
| Waiver of Premium | Activate premium waiver upon qualifying disability |
| Return of Premium (ROP) | Elect return of premiums at specified date |
| Long-Term Care Rider | Begin claiming LTC benefits |

**Conversion Privilege Processing:**

```mermaid
flowchart TD
    A[Conversion Request Received] --> B{Within Conversion Period?}
    B -->|No| C[Reject - Outside Conversion Window]
    B -->|Yes| D{Insured Qualifies?}
    D -->|No| E[Reject - Age/Health Restriction]
    D -->|Yes| F[Select Target Permanent Product]
    F --> G[Calculate Permanent Premium at Original Age Class]
    G --> H{Original Rating Applied?}
    H -->|Yes| I[Apply Original Underwriting Class to New Policy]
    H -->|No| J[Apply Standard Rating]
    I --> K[Issue New Permanent Policy]
    J --> K
    K --> L[Terminate Original Term Policy]
    L --> M[Transfer Any CSV/Paid-Up Value]
    M --> N[Generate Conversion Confirmation Package]
```

---

## 3. Beneficiary Management

### 3.1 Beneficiary Designation Types

Beneficiary management is one of the most legally sensitive areas of policy servicing. Errors in beneficiary processing can result in litigation, regulatory action, and reputational damage.

#### 3.1.1 Revocable Beneficiary

- **Definition**: A beneficiary that the policy owner can change at any time without the beneficiary's consent.
- **Default**: Unless explicitly designated as irrevocable, all beneficiary designations are presumed revocable.
- **Owner Rights**: The owner retains full control over the policy, including the right to exercise policy loans, withdrawals, surrenders, and assignments.

#### 3.1.2 Irrevocable Beneficiary

- **Definition**: A beneficiary whose designation cannot be changed without the beneficiary's written consent.
- **Owner Restrictions**: The owner cannot exercise any policy right that would diminish the irrevocable beneficiary's interest without consent. This includes loans, withdrawals, surrenders, face amount decreases, and ownership changes.
- **Processing Requirement**: Every financial transaction on a policy with an irrevocable beneficiary must include a consent verification step.

**Irrevocable Beneficiary Consent Matrix:**

| Transaction | Consent Required? |
|------------|-------------------|
| Address Change | No |
| Premium Payment | No |
| Premium Mode Change | No |
| Policy Loan | **Yes** |
| Withdrawal/Partial Surrender | **Yes** |
| Face Amount Decrease | **Yes** |
| Full Surrender | **Yes** |
| Ownership Change | **Yes** |
| Beneficiary Change | **Yes** |
| Collateral Assignment | **Yes** |
| Fund Transfer (Variable) | Typically No (no value diminishment) |
| Face Amount Increase | No |

#### 3.1.3 Per Stirpes Distribution

- **Definition**: Benefits pass to the descendants of a deceased beneficiary in equal shares.
- **Example**: Policyholder names three children as equal beneficiaries per stirpes. If Child A predeceases, Child A's share passes to Child A's children (the policyholder's grandchildren).
- **Tracking Requirement**: The PAS must track the per stirpes designation per beneficiary line, not globally.

#### 3.1.4 Per Capita Distribution

- **Definition**: Benefits are divided equally among surviving beneficiaries only. A deceased beneficiary's share does not pass to their descendants but is redistributed among the surviving beneficiaries.
- **Example**: Same scenario — if Child A predeceases, the death benefit is split 50/50 between Child B and Child C.

#### 3.1.5 Trust as Beneficiary

- **Required Data**: Trust name, trust date, trustee name(s), trust TIN (if applicable).
- **Validation**: The PAS should validate that the trust exists and the designation matches the trust's legal name.
- **Payability**: At claim time, the trust must provide a copy of the trust agreement (or relevant sections) to verify the trustee's authority to receive funds.

#### 3.1.6 Estate as Beneficiary

- **Implication**: Proceeds become part of the insured's probate estate, subject to creditor claims and probate costs.
- **Default**: If no beneficiary is designated or all designated beneficiaries predecease, proceeds are typically paid to the estate.
- **Advisory**: Many carriers flag "estate" designations and recommend the policyholder consult an attorney.

#### 3.1.7 Minor as Beneficiary with UTMA Custodian

- **Requirement**: A minor cannot directly receive policy proceeds. A custodian must be designated under the Uniform Transfers to Minors Act (UTMA) or Uniform Gifts to Minors Act (UGMA).
- **Data Elements**: Minor's name, DOB, custodian name, custodian relationship, state of UTMA registration.
- **Age of Majority**: Varies by state (18 or 21). The custodianship terminates when the minor reaches the age of majority.

### 3.2 Beneficiary Share Allocation

The PAS must support flexible share allocation models:

**Share Allocation Rules:**

| Allocation Type | Description | Validation |
|----------------|-------------|------------|
| Percentage | Each beneficiary receives a specified percentage | Primary must total 100%; Contingent must total 100% |
| Equal Share | Benefits split equally among beneficiaries in a class | Automatic calculation at claim time |
| Specific Amount | A fixed dollar amount to one beneficiary, remainder to others | Must not exceed death benefit |
| Tiered | Multiple levels of contingent beneficiaries | Each tier must total 100% independently |

**Beneficiary Hierarchy:**

```mermaid
graph TD
    DB[Death Benefit] --> P{Primary Beneficiaries Alive?}
    P -->|Yes| PB[Pay Primary Beneficiaries per Designation]
    P -->|No - All Deceased| C{Contingent Beneficiaries Alive?}
    C -->|Yes| CB[Pay Contingent Beneficiaries per Designation]
    C -->|No - All Deceased| T{Tertiary Beneficiaries?}
    T -->|Yes| TB[Pay Tertiary Beneficiaries]
    T -->|No| E[Pay to Estate]
    PB --> PS{Per Stirpes?}
    PS -->|Yes| PSC[Deceased Primary's Share to Their Descendants]
    PS -->|No - Per Capita| PCC[Redistribute Among Surviving Primaries]
```

### 3.3 Simultaneous Death Provisions

When the insured and a beneficiary die simultaneously (common in accidents), the **Uniform Simultaneous Death Act (USDA)** or the **120-hour rule** governs proceeds distribution.

**Processing Logic:**

```pseudocode
function determinePayment(insured, beneficiary, deathDates):
    if abs(insured.deathDate - beneficiary.deathDate) <= 120_hours:
        // Treat beneficiary as having predeceased
        return nextInLine(beneficiary)
    else if beneficiary.deathDate > insured.deathDate:
        // Beneficiary survived; pay to beneficiary's estate
        return beneficiary.estate
    else:
        // Beneficiary predeceased
        return nextInLine(beneficiary)
```

### 3.4 Community Property State Rules

In community property states (Arizona, California, Idaho, Louisiana, Nevada, New Mexico, Texas, Washington, Wisconsin), the spouse has a community property interest in the policy if premiums were paid with community funds.

**Community Property Impact on Beneficiary Changes:**

| Scenario | Requirement |
|----------|-------------|
| Owner changes beneficiary from spouse to non-spouse | Spouse consent may be required |
| Owner surrenders policy | Spouse entitled to 50% of CSV |
| Owner takes loan | Spouse consent may be required depending on state |
| Divorce in community property state | Policy value is a community asset subject to division |

### 3.5 Divorce / QDRO Processing

Upon divorce, beneficiary designations are affected by state law:

- **Revocation-on-divorce states**: Automatically revoke the ex-spouse as beneficiary upon final divorce decree (majority of states).
- **Non-revocation states**: The ex-spouse remains beneficiary until the owner affirmatively changes the designation.
- **ERISA-governed plans**: Federal law may preempt state revocation-on-divorce statutes for group/employer-sponsored plans (see *Egelhoff v. Egelhoff*).

**PAS Processing:**

```mermaid
flowchart TD
    A[Divorce Notification Received] --> B{State Law on Beneficiary Revocation?}
    B -->|Auto-Revoke| C[Flag Beneficiary as Revoked by Operation of Law]
    C --> D[Notify Owner: Update Beneficiary Designation]
    B -->|No Auto-Revoke| E[Notify Owner: Beneficiary Unchanged]
    E --> F[Document Notification in Audit Trail]
    D --> F
    F --> G{Court Order Specifies Beneficiary?}
    G -->|Yes| H[Update per Court Order]
    G -->|No| I[Await Owner Instruction]
```

### 3.6 Beneficiary Address and Tax ID Collection

For death benefit payability and tax reporting:

- **Address**: Required for all beneficiaries at claim time. Ideally collected at designation time.
- **Tax ID (SSN/TIN)**: Required for 1099-INT reporting on interest paid on death benefit proceeds held under settlement options. Required for trust TIN if trust is beneficiary.
- **Best Practice**: Collect SSN/TIN and address at designation time to avoid delays at claim time.

### 3.7 Beneficiary Change Data Model

```json
{
  "transactionType": "BENEFICIARY_CHANGE",
  "policyNumber": "LIF-2024-00012345",
  "effectiveDate": "2025-07-01",
  "requestedBy": {
    "partyId": "PTY-001",
    "role": "OWNER"
  },
  "irrevocableBeneficiaryConsent": null,
  "previousBeneficiaries": {
    "primary": [
      {
        "partyId": "PTY-002",
        "name": "Mary Smith",
        "relationship": "SPOUSE",
        "sharePercent": 100.0,
        "designation": "REVOCABLE",
        "distribution": "PER_STIRPES"
      }
    ],
    "contingent": []
  },
  "newBeneficiaries": {
    "primary": [
      {
        "partyId": "PTY-002",
        "name": "Mary Smith",
        "relationship": "SPOUSE",
        "sharePercent": 50.0,
        "designation": "REVOCABLE",
        "distribution": "PER_STIRPES",
        "ssn": "***-**-5678",
        "dob": "1980-05-15"
      },
      {
        "partyId": "PTY-003",
        "name": "Smith Family Trust dated 03/01/2020",
        "relationship": "TRUST",
        "sharePercent": 50.0,
        "designation": "REVOCABLE",
        "distribution": null,
        "tin": "***-**-9999",
        "trusteeName": "Jane Smith"
      }
    ],
    "contingent": [
      {
        "partyId": "PTY-004",
        "name": "James Smith",
        "relationship": "CHILD",
        "sharePercent": 50.0,
        "designation": "REVOCABLE",
        "distribution": "PER_CAPITA",
        "utmaCustodian": null
      },
      {
        "partyId": "PTY-005",
        "name": "Emily Smith",
        "relationship": "CHILD",
        "sharePercent": 50.0,
        "designation": "REVOCABLE",
        "distribution": "PER_CAPITA",
        "utmaCustodian": {
          "custodianName": "Mary Smith",
          "custodianRelationship": "MOTHER",
          "utmaState": "CT",
          "minorDob": "2015-09-20"
        }
      }
    ]
  },
  "validationResults": {
    "primaryTotals100": true,
    "contingentTotals100": true,
    "irrevocableConsentRequired": false,
    "communityPropertyStateCheck": "NOT_APPLICABLE"
  }
}
```

---

## 4. Policy Loans

### 4.1 Loan Eligibility Determination

Policy loans are available on permanent life insurance products that accumulate cash value. Eligibility requirements:

| Criterion | Rule |
|-----------|------|
| **Product Type** | Whole Life, Universal Life, Variable Universal Life, Indexed Universal Life, Endowment |
| **Minimum Cash Value** | Cash surrender value must exceed a minimum threshold (e.g., $500) |
| **Policy Status** | Must be in-force (not lapsed, not in free-look, not in claim) |
| **Policy Age** | Some carriers require the policy to be in force for at least 1–3 years |
| **MEC Status** | Loans from MECs are taxable distributions; eligibility not affected, but tax treatment differs |
| **Assignment Status** | Collateral assignee consent may be required |
| **Irrevocable Beneficiary** | Consent may be required |

### 4.2 Maximum Loan Calculation

The maximum available loan is calculated as follows:

```
Maximum Loan = Cash Surrender Value
             - Existing Outstanding Loans
             - Accrued Loan Interest (if interest charged in arrears)
             - Minimum Required Cash Value Buffer
             - Surrender Charges (if applicable to loan base)
```

**Detailed Calculation Example:**

| Component | Amount |
|-----------|--------|
| Gross Cash Value | $150,000.00 |
| Less: Surrender Charge | ($5,000.00) |
| **Cash Surrender Value** | **$145,000.00** |
| Less: Existing Loan Balance | ($30,000.00) |
| Less: Accrued Loan Interest | ($1,200.00) |
| Less: Minimum Buffer (carrier-specific) | ($500.00) |
| **Maximum Available Loan** | **$113,300.00** |

### 4.3 Loan Interest Mechanics

#### 4.3.1 Fixed vs. Variable Loan Interest

| Type | Rate Determination | Typical Range |
|------|-------------------|---------------|
| **Fixed** | Stated in policy contract; cannot change | 5%–8% |
| **Variable** | Tied to Moody's Corporate Bond Index or similar benchmark; resets annually | 4%–8% (varies) |
| **Preferred (Wash Loan)** | For VUL/IUL policies after a specified period (typically 10+ years); loan interest rate equals the crediting rate | Net 0% cost |

#### 4.3.2 Interest Accrual: Advance vs. Arrears

**Advance Interest:**
- Interest for the full year is charged at the time the loan is made.
- Loan proceeds are reduced by the advance interest amount.
- Example: $10,000 loan at 5% advance interest → policyholder receives $9,500; $500 interest is prepaid.

**Arrears Interest:**
- Interest accrues daily and is due on the policy anniversary.
- If not paid, unpaid interest is capitalized (added to the loan principal).
- Example: $10,000 loan at 5% arrears interest → policyholder receives $10,000; $500 interest due at anniversary.

```pseudocode
function calculateLoanInterest(loanBalance, rate, method, daysSinceLastCalc):
    dailyRate = rate / 365
    accruedInterest = loanBalance * dailyRate * daysSinceLastCalc

    if method == "ADVANCE":
        // Interest already collected at loan origination
        return 0  // No additional accrual needed until anniversary
    else:  // ARREARS
        return accruedInterest
```

### 4.4 Loan Repayment Processing

Loan repayments can be made at any time, in any amount, without a fixed schedule.

**Repayment Application Rules:**

```mermaid
flowchart TD
    A[Loan Repayment Received] --> B{Designated as Loan Repayment?}
    B -->|Yes| C[Apply to Loan Account]
    B -->|No - Undesignated| D{Premium Currently Due?}
    D -->|Yes| E[Apply as Premium First]
    D -->|No| F[Apply as Loan Repayment]
    C --> G{Apply to Interest or Principal?}
    G --> H[Apply to Accrued Interest First]
    H --> I[Remainder Reduces Principal]
    I --> J[Recalculate Net Cash Value]
    J --> K[Update Loan Balance]
    K --> L[Generate Loan Repayment Confirmation]
```

**Loan Repayment Data Model:**

```json
{
  "transactionType": "LOAN_REPAYMENT",
  "policyNumber": "LIF-2024-00012345",
  "effectiveDate": "2025-08-15",
  "repaymentAmount": 5000.00,
  "application": {
    "toAccruedInterest": 1200.00,
    "toPrincipal": 3800.00
  },
  "loanBalanceBefore": 30000.00,
  "accruedInterestBefore": 1200.00,
  "loanBalanceAfter": 26200.00,
  "accruedInterestAfter": 0.00,
  "paymentMethod": "CHECK",
  "paymentReference": "CHK-00012345"
}
```

### 4.5 Automatic Premium Loan (APL)

APL is a policy provision that automatically takes a loan to pay the premium when the policyholder fails to pay by the end of the grace period.

**APL Processing Logic:**

```pseudocode
function processAPL(policy, premiumDue):
    if not policy.aplElected:
        return LAPSE_POLICY

    maxLoanAvailable = calculateMaxLoan(policy)

    if maxLoanAvailable >= premiumDue:
        createLoan(policy, premiumDue, "APL")
        applyPremium(policy, premiumDue, "APL_LOAN")
        sendNotice(policy, "APL_ACTIVATED", premiumDue)
        return POLICY_CONTINUES
    else if maxLoanAvailable > 0:
        // Partial APL - some carriers allow, some don't
        if policy.carrier.allowsPartialAPL:
            createLoan(policy, maxLoanAvailable, "APL_PARTIAL")
            remainingDue = premiumDue - maxLoanAvailable
            return PARTIAL_PAYMENT_APPLIED  // May still lapse
        else:
            return LAPSE_POLICY  // Insufficient for full premium
    else:
        return LAPSE_POLICY  // No loan value available
```

### 4.6 Loan Impact on Death Benefit

At the time of death, outstanding policy loans reduce the death benefit paid to beneficiaries:

```
Net Death Benefit = Gross Death Benefit
                  - Outstanding Loan Balance
                  - Accrued Loan Interest
```

**Example:**

| Component | Amount |
|-----------|--------|
| Gross Death Benefit | $500,000.00 |
| Outstanding Loan Balance | ($45,000.00) |
| Accrued Loan Interest | ($2,250.00) |
| **Net Death Benefit to Beneficiary** | **$452,750.00** |

### 4.7 Loan Impact on Cash Value

For UL/VUL/IUL products, the loan is typically segmented into a "loan collateral account" that earns a separate crediting rate.

**Dual Bucket Model:**

| Bucket | Description | Crediting Rate |
|--------|-------------|---------------|
| **Non-Loaned Fund** | Cash value not pledged as loan collateral | Standard declared rate / index credit |
| **Loaned Fund (Collateral)** | Cash value backing the loan | Typically lower (e.g., 2%–3%) or equal to loan rate for "wash loans" |

```
Total Account Value = Non-Loaned Fund Value + Loaned Fund Value
Net Cash Surrender Value = Total Account Value - Surrender Charges - Outstanding Loans
```

### 4.8 Loan Offset at Surrender/Lapse

When a policy is surrendered or lapses with an outstanding loan:

```
Taxable Gain = (Cash Surrender Value + Outstanding Loan Balance) - Cost Basis
```

The outstanding loan is treated as proceeds received, even though the policyholder does not receive additional cash. This is a common source of "phantom income" — a taxable event without corresponding cash to pay the tax.

### 4.9 Loan 1099-R Reporting

**Modified Endowment Contract (MEC):**
- Loans from MECs are treated as taxable distributions under IRC §72(e)(4)(A).
- The gain portion is taxed as ordinary income.
- A 10% penalty applies if the policyholder is under age 59½.
- 1099-R issued with Distribution Code 1 (early distribution) or Code 2 (early distribution, exception applies).

**Non-MEC:**
- Loans are generally not taxable events.
- Exception: If the policy lapses or is surrendered with an outstanding loan, the loan offset is a taxable event.
- 1099-R issued upon lapse/surrender showing the gain.

### 4.10 Preferred Loan Provisions (VUL/IUL)

Many VUL and IUL products offer "preferred loan" or "wash loan" provisions after a specified policy duration:

| Feature | Standard Loan | Preferred Loan |
|---------|--------------|----------------|
| **Availability** | From year 1 | Typically after year 10 |
| **Loan Interest Rate** | 5%–8% | 4%–5% |
| **Collateral Credit Rate** | 2%–3% | Equals loan interest rate |
| **Net Cost** | 2%–6% | 0% (wash) |
| **Arbitrage Opportunity** | Limited | Significant — enables tax-free retirement income strategy |

---

## 5. Withdrawals & Partial Surrenders

### 5.1 Partial Withdrawal Eligibility

| Criterion | Requirement |
|-----------|-------------|
| **Product Type** | Universal Life, Variable Universal Life, Indexed Universal Life (generally not available on traditional Whole Life) |
| **Minimum Withdrawal** | Carrier-specific (e.g., $500 or $1,000) |
| **Minimum Remaining CSV** | Must maintain minimum cash value after withdrawal (e.g., $500) |
| **Minimum Remaining Face Amount** | After face amount reduction, must meet minimum face amount (e.g., $25,000) |
| **Policy Age** | Some riders require a minimum duration before withdrawals (e.g., GMWB riders) |
| **MEC Test** | Withdrawal cannot cause a retroactive MEC determination |

### 5.2 Free Withdrawal Amount

Many products offer a "free withdrawal" amount — an annual amount that can be withdrawn without a contingent deferred sales charge (CDSC) or surrender charge penalty.

**Common Free Withdrawal Formulas:**

| Formula | Calculation |
|---------|-------------|
| 10% of premium paid | 10% × cumulative premiums |
| 10% of account value | 10% × current account value |
| Interest/earnings only | Account value minus premiums paid |
| Greater of | Max(10% of premiums, 10% of account value) |
| Cumulative unused | If not used in year 1, rolls to year 2 (some products) |

### 5.3 CDSC on Excess Withdrawal

When the withdrawal exceeds the free withdrawal amount, a CDSC or surrender charge applies to the excess.

**CDSC Schedule Example (Typical VUL):**

| Policy Year | CDSC % |
|-------------|--------|
| 1 | 8.0% |
| 2 | 7.5% |
| 3 | 7.0% |
| 4 | 6.0% |
| 5 | 5.0% |
| 6 | 4.0% |
| 7 | 3.0% |
| 8 | 2.0% |
| 9 | 1.0% |
| 10+ | 0.0% |

**Calculation:**

```pseudocode
function calculateCDSC(withdrawalAmount, freeWithdrawalAmount, policyYear, cdscSchedule):
    excessAmount = max(0, withdrawalAmount - freeWithdrawalAmount)
    cdscRate = cdscSchedule[policyYear]
    cdsc = excessAmount * cdscRate
    netWithdrawal = withdrawalAmount - cdsc
    return {
        grossWithdrawal: withdrawalAmount,
        freeAmount: freeWithdrawalAmount,
        excessAmount: excessAmount,
        cdscRate: cdscRate,
        cdscCharge: cdsc,
        netProceeds: netWithdrawal
    }
```

### 5.4 Cost Basis Allocation (FIFO/LIFO)

Under IRC §72, the tax treatment of withdrawals depends on the MEC status:

| Policy Type | Tax Ordering Rule | Effect |
|-------------|------------------|--------|
| **Non-MEC** | FIFO (First In, First Out) | Premiums (basis) come out first — tax-free until basis is exhausted |
| **MEC** | LIFO (Last In, First Out) | Gain comes out first — taxable from dollar one |

**FIFO Example (Non-MEC):**

| Component | Amount |
|-----------|--------|
| Total Premiums Paid (Cost Basis) | $80,000 |
| Current Account Value | $120,000 |
| Gain | $40,000 |
| Withdrawal Amount | $25,000 |
| Tax-Free Portion (from basis) | $25,000 |
| Taxable Portion | $0 |
| Remaining Basis | $55,000 |

**LIFO Example (MEC):**

| Component | Amount |
|-----------|--------|
| Total Premiums Paid (Cost Basis) | $80,000 |
| Current Account Value | $120,000 |
| Gain | $40,000 |
| Withdrawal Amount | $25,000 |
| Taxable Portion (from gain) | $25,000 |
| Tax-Free Portion | $0 |
| Remaining Gain | $15,000 |
| 10% Penalty (if under 59½) | $2,500 |

### 5.5 Tax Withholding

The PAS must apply federal and state tax withholding on taxable distributions:

| Type | Federal Withholding | State Withholding |
|------|-------------------|-------------------|
| Non-MEC withdrawal (within basis) | No withholding | No withholding |
| Non-MEC withdrawal (gain portion) | 10% default (can elect 0%) | Varies by state |
| MEC withdrawal | 10% default | Varies by state |
| MEC withdrawal (under 59½) | 10% + 10% penalty | Varies by state |

### 5.6 Withdrawal from Specific Funds/Segments

For variable and indexed products, the policyholder may direct withdrawals from specific sub-accounts or index segments.

**Fund-Specific Withdrawal Processing:**

```mermaid
flowchart TD
    A[Withdrawal Request] --> B{Specific Fund Directed?}
    B -->|Yes| C[Validate Fund Balance Sufficient]
    C -->|Yes| D[Process from Directed Fund]
    C -->|No| E[Process from Multiple Funds per Allocation]
    B -->|No| F{Withdrawal Allocation Method?}
    F -->|Pro-Rata| G[Withdraw from Each Fund Proportionally]
    F -->|Fixed Account First| H[Withdraw from Fixed Account, Then Sub-Accounts]
    F -->|Specific Order| I[Follow Carrier-Defined Fund Depletion Order]
    D --> J[Unit Sell Processing]
    G --> J
    H --> J
    I --> J
    J --> K[Calculate Tax Impact per Fund]
    K --> L[Update Fund Balances]
```

### 5.7 Withdrawal Impact on Riders/Guarantees

Withdrawals can significantly impact guaranteed benefits attached to variable and indexed products.

#### 5.7.1 GMDB (Guaranteed Minimum Death Benefit) Impact

| GMDB Type | Withdrawal Reduction Method |
|-----------|---------------------------|
| **Return of Premium** | Dollar-for-dollar reduction |
| **Ratchet (Annual Step-Up)** | Pro-rata reduction: GMDB × (1 - Withdrawal/AV before withdrawal) |
| **Roll-Up (Accumulation)** | Pro-rata reduction |

**Pro-Rata Reduction Example:**

```
Account Value Before Withdrawal = $200,000
GMDB Benefit Base = $250,000
Withdrawal Amount = $50,000
Withdrawal as % of AV = $50,000 / $200,000 = 25%
Pro-Rata GMDB Reduction = $250,000 × 25% = $62,500
New GMDB Benefit Base = $250,000 - $62,500 = $187,500
```

#### 5.7.2 GMWB (Guaranteed Minimum Withdrawal Benefit) Impact

The GMWB allows guaranteed annual withdrawals up to a specified percentage of the benefit base.

| Withdrawal Type | Impact on GMWB Benefit Base |
|----------------|---------------------------|
| **Within Guaranteed Amount** | No reduction to benefit base (or dollar-for-dollar, depending on contract) |
| **Excess Withdrawal** | Pro-rata reduction to benefit base |

**Excess Withdrawal Example:**

```
GMWB Benefit Base = $300,000
Guaranteed Annual Withdrawal = 5% × $300,000 = $15,000
Actual Withdrawal = $40,000
Excess = $40,000 - $15,000 = $25,000
Account Value Before Excess = $280,000 - $15,000 = $265,000
Pro-Rata Factor = $25,000 / $265,000 = 9.43%
GMWB Benefit Base Reduction = $300,000 × 9.43% = $28,302
New GMWB Benefit Base = $300,000 - $28,302 = $271,698
```

---

## 6. Face Amount Changes

### 6.1 Face Amount Increase

A face amount increase adds insurance coverage to an existing policy.

**Processing Flow:**

```mermaid
flowchart TD
    A[Face Amount Increase Request] --> B[Determine Increase Amount]
    B --> C{Guaranteed Insurability Option?}
    C -->|Yes - GIO Event| D[No Underwriting Required]
    C -->|No| E[Underwriting Required]
    E --> F{Evidence of Insurability}
    F --> G[Medical Exam / Labs / APS]
    G --> H{Underwriting Decision}
    H -->|Approved Standard| I[Apply Standard Rate]
    H -->|Approved Substandard| J[Apply Table Rating/Flat Extra]
    H -->|Declined| K[Reject Increase Request]
    D --> L[Calculate Additional Premium/COI]
    I --> L
    J --> L
    L --> M[Section 7702 Test - New Guideline Premium]
    M --> N[MEC Test - New 7-Pay Premium]
    N --> O{MEC Created?}
    O -->|Yes| P[Warn Policyholder - Offer to Withdraw Request]
    O -->|No| Q[Process Face Amount Increase]
    P --> R{Proceed Anyway?}
    R -->|Yes| Q
    R -->|No| S[Cancel Request]
    Q --> T[Update Death Benefit]
    T --> U[Recalculate COI Charges]
    U --> V[Update Billing]
    V --> W[Generate Endorsement/Rider]
    W --> X[Send Confirmation]
```

**Underwriting Requirements by Increase Amount:**

| Increase Amount | Typical Evidence Required |
|----------------|--------------------------|
| < $50,000 | Non-medical application (health questions only) |
| $50,000 – $249,999 | Paramedical exam + blood/urine |
| $250,000 – $999,999 | Full medical exam + labs + APS |
| ≥ $1,000,000 | Full medical + labs + APS + financial underwriting |

### 6.2 Face Amount Decrease

A face amount decrease reduces the insurance coverage amount.

**Key Considerations:**

1. **Minimum Face Amount**: The policy cannot be decreased below the product's minimum face amount (e.g., $25,000 or $50,000).
2. **Surrender Charge Implications**: Some products apply a surrender charge proportional to the face amount decrease.
3. **7-Pay Test Re-evaluation (MEC Test)**: A decrease in face amount triggers a MEC re-test. The 7-pay premium limit is recalculated based on the reduced face amount, and all premiums paid since issue are tested against this new limit.
4. **TEFRA/DEFRA Corridor Adjustment**: Under IRC §7702, the death benefit must maintain a minimum corridor over the cash value. A face amount decrease may push the policy outside the corridor, requiring adjustments.
5. **COI Recalculation**: Cost of insurance charges are recalculated based on the new net amount at risk.

**MEC Re-Test on Decrease:**

```pseudocode
function mecRetestOnDecrease(policy, newFaceAmount):
    new7PayPremium = calculate7PayPremium(
        product = policy.product,
        faceAmount = newFaceAmount,
        issueAge = policy.issueAge,
        riskClass = policy.riskClass,
        riders = policy.riders
    )

    // Sum all premiums paid in the current 7-pay period
    cumulativePremiums = sumPremiums(policy, since = policy.last7PayStartDate)

    // Cumulative 7-pay limit based on new face amount
    yearsSinceStart = yearsBetween(policy.last7PayStartDate, today())
    cumulativeLimit = new7PayPremium * min(yearsSinceStart, 7)

    if cumulativePremiums > cumulativeLimit:
        policy.mecStatus = "MEC"
        policy.mecEffectiveDate = effectiveDateOfDecrease
        notifyOwner("Policy has become a Modified Endowment Contract")
        return MEC_CREATED
    else:
        return MEC_NOT_CREATED
```

**TEFRA/DEFRA Corridor Check:**

The guideline premium test and cash value corridor test under IRC §7702:

| Attained Age | Minimum Death Benefit as % of CSV |
|-------------|----------------------------------|
| 0–40 | 250% |
| 41 | 243% |
| 45 | 215% |
| 50 | 185% |
| 55 | 150% |
| 60 | 130% |
| 65 | 120% |
| 70 | 115% |
| 75+ | 105% |

```pseudocode
function corridorTest(policy, newFaceAmount):
    corridorFactor = getCorridorFactor(policy.attainedAge)
    minimumDB = policy.cashValue * corridorFactor

    if newFaceAmount < minimumDB:
        // Face amount decrease would violate corridor
        return REJECT_DECREASE
    else:
        return ALLOW_DECREASE
```

---

## 7. Premium Changes

### 7.1 Premium Increase

For products with flexible premiums (UL, VUL, IUL), the policyholder can increase their planned periodic premium.

**Validation Checks:**

| Check | Rule |
|-------|------|
| **Guideline Annual Premium (GAP)** | Total premiums in the year cannot exceed the GAP under the guideline premium test |
| **Guideline Single Premium (GSP)** | Cumulative premiums cannot exceed the GSP |
| **7-Pay Premium** | Premiums in the 7-pay testing period cannot exceed the 7-pay limit (MEC test) |
| **TAMRA Testing** | IRC §7702A compliance — premiums must stay within the 7-pay corridor |

### 7.2 Premium Decrease

Premium decreases on UL products reduce the planned periodic premium. There is no minimum premium requirement for UL (though there is a practical minimum to keep the policy in force via monthly deductions).

### 7.3 Premium Suspension (UL)

UL products allow the policyholder to stop paying premiums entirely, provided the cash value is sufficient to cover monthly deductions (COI + expense charges + rider charges).

**Impact of Premium Suspension:**

```mermaid
flowchart TD
    A[Premium Suspension Requested] --> B[Calculate Monthly Deduction Rate]
    B --> C[Project Cash Value Depletion]
    C --> D{Years Until Lapse?}
    D -->|> 5 Years| E[Approve with Standard Warning]
    D -->|1-5 Years| F[Approve with Strong Warning]
    D -->|< 1 Year| G[Approve with Imminent Lapse Warning]
    E --> H[Update Billing to No-Bill]
    F --> H
    G --> H
    H --> I[Continue Monthly Deductions from CSV]
    I --> J{CSV > Monthly Deduction?}
    J -->|Yes| K[Continue In-Force]
    J -->|No| L[Begin Grace Period / APL / Lapse Process]
```

### 7.4 Premium Allocation Changes

For variable products, the policyholder directs how new premiums are allocated among sub-accounts.

**Premium Allocation Data Model:**

```json
{
  "transactionType": "PREMIUM_ALLOCATION_CHANGE",
  "policyNumber": "VUL-2024-00067890",
  "effectiveDate": "2025-09-01",
  "newAllocations": [
    { "fundCode": "SPIDX", "fundName": "S&P 500 Index Fund", "percent": 40.0 },
    { "fundCode": "INTGR", "fundName": "International Growth Fund", "percent": 20.0 },
    { "fundCode": "BOND", "fundName": "Bond Index Fund", "percent": 20.0 },
    { "fundCode": "FIXED", "fundName": "Fixed Account", "percent": 20.0 }
  ],
  "totalPercent": 100.0,
  "validationPassed": true
}
```

### 7.5 Excess Premium Handling

When premiums exceed the guideline premium limits, the PAS must take corrective action:

```mermaid
flowchart TD
    A[Premium Received] --> B{Exceeds Guideline Premium?}
    B -->|No| C[Accept and Apply]
    B -->|Yes| D{Exceeds 7-Pay Premium?}
    D -->|No| E[Accept - But Monitor 7702]
    D -->|Yes| F{MEC Already?}
    F -->|Yes| G[Accept - Already MEC]
    F -->|No| H[Return Excess Within 60-Day Window]
    H --> I{Owner Wants to Accept MEC?}
    I -->|Yes| J[Accept - Policy Becomes MEC]
    I -->|No| K[Refund Excess Premium]
```

### 7.6 Guideline Premium Test Management

The guideline premium test under IRC §7702 establishes two limits:

1. **Guideline Single Premium (GSP)**: The maximum single premium that could be paid into the policy.
2. **Guideline Annual Premium (GAP)**: The maximum level annual premium.

```pseudocode
function guidelinePremiumTest(policy, premiumPayment):
    // Cumulative test
    totalPremiums = policy.cumulativePremiums + premiumPayment
    gspLimit = calculateGSP(policy)
    gapCumulativeLimit = calculateCumulativeGAP(policy)

    if totalPremiums > gspLimit:
        return EXCEEDS_GSP  // Policy fails to qualify as life insurance
    
    if totalPremiums > gapCumulativeLimit:
        // Need to reduce death benefit or refund premium
        excessAmount = totalPremiums - gapCumulativeLimit
        return EXCEEDS_GAP(excessAmount)
    
    return WITHIN_LIMITS
```

---

## 8. Fund Transfers (Variable Products)

### 8.1 Transfer Request Processing

Fund transfers allow VUL/VA policyholders to move existing account value between sub-accounts.

**Transfer Types:**

| Type | Description |
|------|-------------|
| **Ad-hoc Transfer** | One-time transfer between funds |
| **Systematic Transfer** | Recurring transfers on a schedule (e.g., monthly dollar-cost averaging) |
| **Rebalancing Transfer** | Return all funds to target allocation percentages |
| **Model Portfolio Transfer** | Move to a pre-defined model allocation |

### 8.2 Transfer Restrictions

| Restriction | Typical Rule |
|------------|-------------|
| **Frequency Limit** | 12–15 free transfers per year; fee per excess transfer (e.g., $25) |
| **Minimum Transfer Amount** | $250 or 1% of fund balance, whichever is greater |
| **Minimum Fund Balance After Transfer** | $100 minimum remaining in any fund |
| **Fund Lock-Out** | After a transfer out, policyholder may be locked out of transferring back for 30 days (to prevent market timing) |
| **Fixed Account Restrictions** | Transfers out of the fixed account may be limited to 25% per year (book value protection) |
| **Equity Wash Rule** | Some carriers require transfers from equity to fixed to go through a bond fund first |

### 8.3 Systematic Transfer Programs

**Dollar-Cost Averaging (DCA):**

```json
{
  "transactionType": "SYSTEMATIC_TRANSFER_SETUP",
  "policyNumber": "VUL-2024-00067890",
  "program": "DOLLAR_COST_AVERAGING",
  "sourceAccount": "FIXED",
  "targetAccounts": [
    { "fundCode": "SPIDX", "percent": 50.0 },
    { "fundCode": "INTGR", "percent": 30.0 },
    { "fundCode": "BOND", "percent": 20.0 }
  ],
  "transferAmount": 2000.00,
  "frequency": "MONTHLY",
  "startDate": "2025-10-01",
  "endDate": null,
  "endCondition": "SOURCE_EXHAUSTED"
}
```

**Auto-Rebalancing:**

```json
{
  "transactionType": "SYSTEMATIC_TRANSFER_SETUP",
  "policyNumber": "VUL-2024-00067890",
  "program": "AUTO_REBALANCE",
  "targetAllocations": [
    { "fundCode": "SPIDX", "percent": 40.0 },
    { "fundCode": "INTGR", "percent": 20.0 },
    { "fundCode": "BOND", "percent": 20.0 },
    { "fundCode": "FIXED", "percent": 20.0 }
  ],
  "rebalanceFrequency": "QUARTERLY",
  "rebalanceTrigger": "SCHEDULE",
  "deviationThreshold": null,
  "nextRebalanceDate": "2025-12-31"
}
```

### 8.4 Fund Closure/Merger Processing

When a fund is closed or merged, the PAS must handle the transition:

```mermaid
flowchart TD
    A[Fund Closure/Merger Notification] --> B[Identify Affected Policies]
    B --> C[Map Old Fund to New Fund]
    C --> D[Generate Policyholder Notice - 30 Day Advance]
    D --> E{Policyholder Elects Alternative?}
    E -->|Yes| F[Process Transfer to Elected Fund]
    E -->|No Response| G[Process Transfer to Mapped Default Fund]
    F --> H[Update Premium Allocation if Old Fund Referenced]
    G --> H
    H --> I[Update Systematic Transfer Programs]
    I --> J[Update DCA Source/Target if Affected]
    J --> K[Generate Confirmation]
```

### 8.5 Unit Buy/Sell Processing

Fund transfers are executed through unit buy/sell transactions at the fund's unit value (price per unit) on the effective date.

```pseudocode
function processTransfer(policy, fromFund, toFund, amount, effectiveDate):
    // Get unit prices for the effective date
    fromUnitPrice = getUnitPrice(fromFund, effectiveDate)
    toUnitPrice = getUnitPrice(toFund, effectiveDate)

    // Calculate units to sell
    unitsSold = amount / fromUnitPrice

    // Validate sufficient units
    if unitsSold > policy.fundHolding[fromFund].units:
        raise InsufficientUnitsException

    // Calculate units to buy
    unitsBought = amount / toUnitPrice

    // Execute sell
    policy.fundHolding[fromFund].units -= unitsSold
    // Execute buy
    policy.fundHolding[toFund].units += unitsBought

    // Record transaction
    createTransferRecord(policy, fromFund, toFund, amount, 
                         unitsSold, unitsBought, effectiveDate)
```

---

## 9. 1035 Exchange Processing

### 9.1 Overview

A 1035 exchange (named after IRC §1035) allows tax-free replacement of one life insurance or annuity contract with another. The tax basis of the old contract transfers to the new contract.

**Eligible 1035 Exchanges:**

| From | To | Allowed? |
|------|----|----------|
| Life Insurance | Life Insurance | Yes |
| Life Insurance | Annuity | Yes (since TIPRA 2006) |
| Life Insurance | Long-Term Care | Yes (since PPA 2006) |
| Annuity | Annuity | Yes |
| Annuity | Long-Term Care | Yes (since PPA 2006) |
| Annuity | Life Insurance | **No** |
| Long-Term Care | Life Insurance | **No** |
| Long-Term Care | Annuity | **No** |

### 9.2 Incoming Exchange (Receiving Carrier Workflow)

```mermaid
flowchart TD
    A[New Application with 1035 Exchange] --> B[Underwrite New Policy]
    B --> C{Approved?}
    C -->|No| D[Decline - No Exchange]
    C -->|Yes| E[Send 1035 Exchange Paperwork to Releasing Carrier]
    E --> F[Include Absolute Assignment Form]
    F --> G[Include Replacement Forms per State Regulation]
    G --> H{State Requires Replacement Notice?}
    H -->|Yes| I[File Replacement Notice with State DOI]
    H -->|No| J[Continue Processing]
    I --> J
    J --> K[Await Funds from Releasing Carrier]
    K --> L{Funds Received?}
    L -->|Yes| M[Verify Amount Matches Expected]
    M --> N[Apply Funds to New Policy]
    N --> O[Record Cost Basis Transfer]
    O --> P[Issue New Policy - Exchange Effective Date]
    L -->|No - Follow Up| Q[Follow-Up with Releasing Carrier]
    Q --> K
```

### 9.3 Outgoing Exchange (Releasing Carrier Workflow)

```mermaid
flowchart TD
    A[1035 Exchange Request Received] --> B[Verify Absolute Assignment]
    B --> C[Verify Policyholder Signature]
    C --> D{All Documents Complete?}
    D -->|No| E[Request Missing Documents - NIGO]
    D -->|Yes| F[Calculate Surrender Value]
    F --> G{Outstanding Loans?}
    G -->|Yes| H[Include Loan Payoff in Calculation]
    G -->|No| I[Proceed]
    H --> I
    I --> J[Apply Surrender Charges if Any]
    J --> K[Calculate Net Transfer Amount]
    K --> L[Prepare 1035 Transfer Check - Payable to Receiving Carrier FBO Insured]
    L --> M[Prepare Cost Basis Statement]
    M --> N[Send Check + Basis Info to Receiving Carrier]
    N --> O[Terminate Old Policy]
    O --> P[No 1099-R for Qualifying 1035 Exchange]
```

### 9.4 Cost Basis Transfer

```json
{
  "exchangeType": "1035_OUTGOING",
  "releasingPolicy": "WL-2015-00054321",
  "receivingCarrier": "ABC Life Insurance Company",
  "receivingPolicy": "UL-2025-00098765",
  "financials": {
    "grossCashValue": 125000.00,
    "surrenderCharge": 3500.00,
    "outstandingLoan": 15000.00,
    "accruedLoanInterest": 750.00,
    "netTransferAmount": 105750.00,
    "costBasis": 85000.00,
    "cumulativeDividends": 12000.00,
    "previousExchangeBasis": 0.00
  },
  "costBasisToNewPolicy": 85000.00,
  "taxableEvent": false,
  "form1099Required": false
}
```

### 9.5 State Replacement Regulations

Most states have adopted some version of the NAIC Model Replacement Regulation. Key requirements:

| Requirement | Description |
|------------|-------------|
| **Replacement Notice** | Producer must provide a signed notice to the applicant |
| **Comparison Statement** | Side-by-side comparison of old and new policy benefits |
| **20-Day Free Look** | Extended free-look period for replacement policies (some states) |
| **Producing Agent Duty** | Agent must determine whether replacement is in the client's best interest |
| **Company Notification** | Replacing insurer must notify the existing insurer |
| **Conservation Letter** | Existing insurer may send a conservation letter to the policyholder |

---

## 10. Anniversary Processing

Anniversary processing encompasses all cyclical recalculations and updates that occur on each policy anniversary date.

### 10.1 Cost of Insurance Recalculation

For UL/VUL/IUL products, COI charges are recalculated annually based on the insured's attained age and the net amount at risk (NAR).

```pseudocode
function recalculateCOI(policy, anniversaryDate):
    attainedAge = policy.issueAge + policyYear(policy, anniversaryDate)
    netAmountAtRisk = policy.deathBenefit - policy.accountValue

    if netAmountAtRisk <= 0:
        return 0  // No mortality charge when AV exceeds DB

    // Look up mortality rate from the policy's COI table
    coiRate = policy.coiTable.getRate(
        attainedAge = attainedAge,
        gender = policy.insured.gender,
        riskClass = policy.riskClass,
        smokerStatus = policy.smokerStatus,
        policyYear = policyYear(policy, anniversaryDate)
    )

    monthlyCOI = (netAmountAtRisk / 1000) * (coiRate / 12)
    return monthlyCOI
```

### 10.2 Mortality Charge Updates

Mortality charges increase with age. The PAS stores the current-scale COI rates and guaranteed-maximum COI rates:

| Rate Type | Description |
|-----------|-------------|
| **Current Scale** | The rate the company currently charges; may be lower than guaranteed |
| **Guaranteed Maximum** | The contractual maximum rate; cannot be exceeded |

### 10.3 Expense Charge Updates

| Charge Type | Frequency | Typical Amount |
|------------|-----------|----------------|
| Per-policy administration charge | Monthly | $5–$15 |
| Per-thousand face amount charge | Monthly | $0.01–$0.10 per $1,000 |
| Premium load (front-end) | Per premium | 3%–10% of premium |
| Surrender charge | Per policy year | Decreasing schedule |
| Fund management fees (VUL) | Daily | 0.25%–2.0% annually |

### 10.4 Policy Value Recalculation

On anniversary, the PAS performs a comprehensive policy value recalculation:

```mermaid
flowchart TD
    A[Anniversary Date Reached] --> B[Recalculate COI Rate]
    B --> C[Recalculate Expense Charges]
    C --> D[Credit Interest/Dividends/Index Credits]
    D --> E[Process Rider Charges]
    E --> F[Advance Surrender Charge Schedule]
    F --> G[Recalculate Cash Surrender Value]
    G --> H[Perform Section 7702 Corridor Test]
    H --> I{Corridor Violated?}
    I -->|Yes| J[Increase Death Benefit to Maintain Corridor]
    I -->|No| K[Continue]
    J --> K
    K --> L[Recalculate Net Amount at Risk]
    L --> M[Generate Anniversary Statement]
    M --> N[Update Policy Valuation Record]
```

### 10.5 Dividend Declaration (Participating Whole Life)

For participating whole life policies, dividends are declared on each anniversary.

**Dividend Options:**

| Option | Description |
|--------|-------------|
| **Cash** | Dividend paid in cash to the policyholder |
| **Reduce Premium** | Dividend applied to reduce the next premium due |
| **Accumulate at Interest** | Dividend held in accumulation account earning declared rate |
| **Paid-Up Additions (PUA)** | Dividend purchases additional paid-up whole life insurance |
| **One-Year Term** | Dividend purchases one-year term insurance equal to the CSV |

### 10.6 Interest Crediting (Universal Life)

| Method | Description |
|--------|-------------|
| **Portfolio Rate** | Single declared rate applied to all UL policies |
| **New Money Rate** | Rate varies based on when premiums were received |
| **Banded Rate** | Different rates for different account value bands |
| **Guaranteed Minimum** | Contractual floor rate (e.g., 2%–4%) |

### 10.7 Index Segment Maturity (IUL)

For Indexed Universal Life, each index segment matures on its anniversary (typically 1-year point-to-point):

```pseudocode
function processIndexSegmentMaturity(segment):
    startValue = segment.indexStartValue
    endValue = getCurrentIndexValue(segment.indexType, segment.maturityDate)

    rawReturn = (endValue - startValue) / startValue

    // Apply cap
    cappedReturn = min(rawReturn, segment.capRate)

    // Apply floor
    flooredReturn = max(cappedReturn, segment.floorRate)

    // Apply participation rate
    creditedReturn = flooredReturn * segment.participationRate

    // Apply spread (if applicable)
    creditedReturn = max(0, creditedReturn - segment.spreadRate)

    // Calculate interest credit
    interestCredit = segment.segmentValue * creditedReturn

    // Create new segment for next term
    newSegment = createNewSegment(
        segmentValue = segment.segmentValue + interestCredit,
        indexType = segment.indexType,
        startDate = segment.maturityDate,
        maturityDate = segment.maturityDate + 1_year,
        capRate = getCurrentCapRate(segment.indexType),
        participationRate = getCurrentParticipationRate(segment.indexType),
        floorRate = segment.floorRate,  // Floor is guaranteed
        spreadRate = getCurrentSpreadRate(segment.indexType)
    )

    return {
        maturedSegment: segment,
        interestCredit: interestCredit,
        rawReturn: rawReturn,
        creditedReturn: creditedReturn,
        newSegment: newSegment
    }
```

### 10.8 Surrender Charge Schedule Advancement

Each policy year, the surrender charge decreases per the contractual schedule:

```json
{
  "surrenderChargeSchedule": [
    { "policyYear": 1, "chargePercent": 100.0, "chargePerThousand": 35.00 },
    { "policyYear": 2, "chargePercent": 90.0, "chargePerThousand": 31.50 },
    { "policyYear": 3, "chargePercent": 80.0, "chargePerThousand": 28.00 },
    { "policyYear": 4, "chargePercent": 70.0, "chargePerThousand": 24.50 },
    { "policyYear": 5, "chargePercent": 60.0, "chargePerThousand": 21.00 },
    { "policyYear": 6, "chargePercent": 50.0, "chargePerThousand": 17.50 },
    { "policyYear": 7, "chargePercent": 40.0, "chargePerThousand": 14.00 },
    { "policyYear": 8, "chargePercent": 30.0, "chargePerThousand": 10.50 },
    { "policyYear": 9, "chargePercent": 20.0, "chargePerThousand": 7.00 },
    { "policyYear": 10, "chargePercent": 10.0, "chargePerThousand": 3.50 },
    { "policyYear": 11, "chargePercent": 0.0, "chargePerThousand": 0.00 }
  ]
}
```

### 10.9 Rider Charge Anniversary Reset

Riders with annual charges are reset on the policy anniversary:

| Rider | Anniversary Action |
|-------|--------------------|
| Waiver of Premium | Re-evaluate disability status; recalculate waiver COI |
| Accidental Death Benefit | Recalculate ADB charge at new attained age |
| GMDB Rider | Step up benefit base if applicable; recalculate GMDB charge |
| GMWB Rider | Reset annual withdrawal allowance; recalculate GMWB charge |
| No-Lapse Guarantee | Test shadow account; reset annual premium requirement |

---

## 11. Correspondence Generation

### 11.1 Change Confirmation Letters

Every servicing transaction must generate a confirmation letter or electronic notification:

| Transaction | Confirmation Type | Timing |
|------------|-------------------|--------|
| Address Change | Letter/Email | Within 5 business days |
| Beneficiary Change | Letter | Within 5 business days |
| Loan Disbursement | Letter + Check | Same day if electronic; 3–5 days for paper |
| Withdrawal | Letter + Check/EFT | Same day if electronic |
| Face Amount Change | Endorsement + Letter | Within 10 business days |
| Fund Transfer | Confirmation Letter | Next business day |
| Premium Mode Change | Letter | Within 5 business days |
| Ownership Change | Letter to Old and New Owner | Within 10 business days |

### 11.2 Annual Statements

Annual statements are a regulatory requirement in all states. Content includes:

- Policy number, insured name, owner name
- Current death benefit
- Current cash value / account value
- Current surrender value
- Current loan balance and accrued interest
- Premiums paid during the year
- Cost of insurance charges deducted
- Expense charges deducted
- Interest credited / dividends applied
- Fund values and unit counts (variable products)
- Net amount at risk
- Surrender charge remaining
- MEC status
- 7702 compliance status

### 11.3 Required Notices

| Notice | Trigger | Regulatory Basis |
|--------|---------|-----------------|
| **Lapse Warning** | Premium not received by due date | State insurance code |
| **Grace Period Notice** | Grace period begins | State insurance code |
| **Premium Due Notice** | Premium billing cycle | Carrier practice |
| **Annual Report** | Policy anniversary | State regulation |
| **Annual Privacy Notice** | Annually (if required by state) | Gramm-Leach-Bliley Act |
| **Illustration Update** | Annually for certain products | NAIC Model Illustration Regulation |
| **Cost Basis Notification** | Upon MEC determination | IRC §7702A |
| **Market Value Adjustment Notice** | Before MVA-affected transaction | State regulation |

### 11.4 Tax Documents

| Document | Purpose | Filing Deadline |
|----------|---------|----------------|
| **1099-R** | Taxable distributions, surrenders, loan offsets | January 31 |
| **1099-INT** | Interest on death benefit proceeds held | January 31 |
| **5498** | IRA-funded life insurance premiums | May 31 |
| **1099-LTC** | Long-term care rider benefits | January 31 |

### 11.5 Regulatory Notices

| Notice | Trigger | State Variations |
|--------|---------|-----------------|
| **Replacement Notice** | 1035 exchange or external replacement | Most states have adopted NAIC model |
| **Free-Look Expiration** | End of free-look period | 10–30 days depending on state |
| **Rate Change Notice** | Term renewal premium change | Advance notice requirements vary |
| **Policy Conversion Deadline** | Approaching end of conversion period | Carrier best practice |

---

## 12. Entity-Relationship Model

### 12.1 Complete ERD for Policy Servicing Transactions

```mermaid
erDiagram
    POLICY ||--o{ SERVICE_TRANSACTION : has
    POLICY ||--o{ POLICY_PARTY : has
    POLICY ||--o{ BENEFICIARY_DESIGNATION : has
    POLICY ||--o{ POLICY_LOAN : has
    POLICY ||--o{ POLICY_RIDER : has
    POLICY ||--o{ FUND_HOLDING : has
    POLICY ||--o{ PREMIUM_ALLOCATION : has
    POLICY ||--o{ INDEX_SEGMENT : has
    POLICY ||--o{ SURRENDER_CHARGE_SCHEDULE : has
    POLICY ||--|| POLICY_VALUE : has
    POLICY ||--o{ CORRESPONDENCE : generates
    POLICY ||--o{ TAX_REPORTING : generates
    POLICY ||--o{ EXCHANGE_1035 : participates

    SERVICE_TRANSACTION ||--o{ TRANSACTION_DETAIL : contains
    SERVICE_TRANSACTION ||--|| TRANSACTION_STATUS : has
    SERVICE_TRANSACTION ||--o{ AUDIT_TRAIL : generates
    SERVICE_TRANSACTION ||--o{ APPROVAL_WORKFLOW : requires
    SERVICE_TRANSACTION ||--o{ DOCUMENT : has

    POLICY_PARTY ||--|{ PARTY : references
    POLICY_PARTY ||--o{ PARTY_ADDRESS : has
    POLICY_PARTY ||--o{ PARTY_CONTACT : has

    BENEFICIARY_DESIGNATION ||--o{ BENEFICIARY : contains
    BENEFICIARY ||--|| PARTY : references
    BENEFICIARY ||--o{ UTMA_CUSTODIAN : may_have

    POLICY_LOAN ||--o{ LOAN_TRANSACTION : has
    POLICY_LOAN ||--o{ LOAN_INTEREST_ACCRUAL : has

    FUND_HOLDING ||--|| FUND : references
    FUND_HOLDING ||--o{ UNIT_TRANSACTION : has

    INDEX_SEGMENT ||--|| INDEX_STRATEGY : references
    INDEX_SEGMENT ||--o{ INDEX_CREDIT_HISTORY : has

    POLICY_RIDER ||--|| RIDER_DEFINITION : references
    POLICY_RIDER ||--o{ RIDER_BENEFIT_RECORD : has

    POLICY {
        string policy_number PK
        string product_code FK
        date issue_date
        date effective_date
        string status
        decimal face_amount
        string death_benefit_option
        string premium_mode
        decimal planned_periodic_premium
        boolean mec_status
        date mec_effective_date
        boolean apl_elected
        string non_forfeiture_option
        string state_of_issue
        date maturity_date
    }

    SERVICE_TRANSACTION {
        string transaction_id PK
        string policy_number FK
        string transaction_type
        date request_date
        date effective_date
        string requested_by
        string status
        string stp_result
        string override_reason
        timestamp created_at
        timestamp completed_at
    }

    TRANSACTION_DETAIL {
        string detail_id PK
        string transaction_id FK
        string field_name
        string old_value
        string new_value
        string data_type
    }

    TRANSACTION_STATUS {
        string status_id PK
        string transaction_id FK
        string status_code
        timestamp status_date
        string updated_by
        string reason
    }

    AUDIT_TRAIL {
        string audit_id PK
        string transaction_id FK
        string event_type
        timestamp event_timestamp
        string user_id
        string ip_address
        string before_snapshot
        string after_snapshot
    }

    APPROVAL_WORKFLOW {
        string workflow_id PK
        string transaction_id FK
        string approval_level
        string approver_id
        string approval_status
        timestamp approval_date
        string comments
    }

    POLICY_PARTY {
        string policy_party_id PK
        string policy_number FK
        string party_id FK
        string role
        date effective_date
        date termination_date
    }

    PARTY {
        string party_id PK
        string party_type
        string first_name
        string last_name
        string entity_name
        string ssn_tin
        date date_of_birth
        string gender
    }

    PARTY_ADDRESS {
        string address_id PK
        string party_id FK
        string address_type
        string line1
        string line2
        string city
        string state
        string zip
        string country
        boolean is_current
    }

    BENEFICIARY_DESIGNATION {
        string designation_id PK
        string policy_number FK
        date effective_date
        string designation_class
        decimal total_share_percent
    }

    BENEFICIARY {
        string beneficiary_id PK
        string designation_id FK
        string party_id FK
        string beneficiary_type
        string designation_type
        string distribution_type
        decimal share_percent
        integer priority_sequence
    }

    UTMA_CUSTODIAN {
        string custodian_id PK
        string beneficiary_id FK
        string custodian_name
        string custodian_relationship
        string utma_state
        date minor_dob
    }

    POLICY_LOAN {
        string loan_id PK
        string policy_number FK
        date origination_date
        decimal original_amount
        decimal outstanding_balance
        decimal interest_rate
        string interest_method
        string loan_type
        string status
    }

    LOAN_TRANSACTION {
        string loan_txn_id PK
        string loan_id FK
        string transaction_type
        date transaction_date
        decimal amount
        decimal principal_portion
        decimal interest_portion
    }

    LOAN_INTEREST_ACCRUAL {
        string accrual_id PK
        string loan_id FK
        date accrual_date
        decimal accrued_amount
        decimal rate_used
        decimal balance_used
    }

    FUND_HOLDING {
        string holding_id PK
        string policy_number FK
        string fund_code FK
        decimal units
        decimal unit_value
        decimal market_value
        date as_of_date
    }

    FUND {
        string fund_code PK
        string fund_name
        string fund_type
        string fund_family
        decimal management_fee
        string status
        date inception_date
    }

    UNIT_TRANSACTION {
        string unit_txn_id PK
        string holding_id FK
        string transaction_type
        date transaction_date
        decimal units
        decimal unit_price
        decimal amount
    }

    INDEX_SEGMENT {
        string segment_id PK
        string policy_number FK
        string strategy_code FK
        date start_date
        date maturity_date
        decimal segment_value
        decimal index_start_value
        decimal index_end_value
        decimal cap_rate
        decimal floor_rate
        decimal participation_rate
        decimal spread_rate
        decimal credited_rate
        string status
    }

    INDEX_STRATEGY {
        string strategy_code PK
        string index_name
        string crediting_method
        integer term_years
        decimal current_cap
        decimal current_participation_rate
        decimal guaranteed_floor
    }

    POLICY_VALUE {
        string value_id PK
        string policy_number FK
        date as_of_date
        decimal account_value
        decimal cash_surrender_value
        decimal death_benefit
        decimal net_amount_at_risk
        decimal cost_basis
        decimal total_premiums_paid
        decimal total_coi_deducted
        decimal total_expense_charges
        decimal total_interest_credited
        decimal accumulated_dividends
    }

    PREMIUM_ALLOCATION {
        string allocation_id PK
        string policy_number FK
        string fund_code FK
        decimal allocation_percent
        date effective_date
    }

    POLICY_RIDER {
        string policy_rider_id PK
        string policy_number FK
        string rider_code FK
        date effective_date
        date termination_date
        string status
        decimal rider_face_amount
        decimal rider_charge
    }

    RIDER_DEFINITION {
        string rider_code PK
        string rider_name
        string rider_type
        decimal min_face_amount
        decimal max_face_amount
        boolean requires_underwriting
    }

    RIDER_BENEFIT_RECORD {
        string benefit_id PK
        string policy_rider_id FK
        date record_date
        decimal benefit_base
        decimal annual_benefit_amount
        decimal cumulative_benefits_paid
    }

    CORRESPONDENCE {
        string correspondence_id PK
        string policy_number FK
        string transaction_id FK
        string template_code
        string delivery_method
        date generation_date
        date sent_date
        string status
        string recipient_party_id
    }

    TAX_REPORTING {
        string tax_report_id PK
        string policy_number FK
        integer tax_year
        string form_type
        decimal gross_distribution
        decimal taxable_amount
        decimal federal_withholding
        decimal state_withholding
        string distribution_code
        date generation_date
        boolean filed
    }

    SURRENDER_CHARGE_SCHEDULE {
        string schedule_id PK
        string policy_number FK
        integer policy_year
        decimal charge_percent
        decimal charge_per_thousand
    }

    EXCHANGE_1035 {
        string exchange_id PK
        string policy_number FK
        string exchange_direction
        string counterparty_carrier
        string counterparty_policy
        date exchange_date
        decimal transfer_amount
        decimal cost_basis_transferred
        string status
    }

    DOCUMENT {
        string document_id PK
        string transaction_id FK
        string document_type
        string file_path
        date received_date
        string status
    }
```

### 12.2 Key Entity Descriptions

| Entity | Purpose | Approximate Row Count (per carrier) |
|--------|---------|-------------------------------------|
| POLICY | Master policy record | 1M–10M |
| SERVICE_TRANSACTION | Every servicing request | 50M–500M |
| TRANSACTION_DETAIL | Before/after values per field per transaction | 200M–2B |
| AUDIT_TRAIL | Immutable audit events | 500M–5B |
| BENEFICIARY_DESIGNATION | Current and historical beneficiary records | 5M–50M |
| POLICY_LOAN | Loan accounts | 2M–20M |
| FUND_HOLDING | Current fund positions (variable products) | 10M–100M |
| INDEX_SEGMENT | IUL index segments | 5M–50M |
| CORRESPONDENCE | Generated letters and notices | 100M–1B |

---

## 13. ACORD TXLife Change Request Messages

### 13.1 Overview

The ACORD TXLife standard defines XML messages for life insurance transactions. Key transaction types for servicing:

| ACORD Transaction Code | Description |
|----------------------|-------------|
| `OLI_TRANS_CHGADDR` (tc="508") | Address Change |
| `OLI_TRANS_CHGBENEFICIARY` (tc="510") | Beneficiary Change |
| `OLI_TRANS_CHGBILLING` (tc="511") | Billing Change |
| `OLI_TRANS_CHGFACEAMT` (tc="513") | Face Amount Change |
| `OLI_TRANS_LOAN` (tc="518") | Policy Loan |
| `OLI_TRANS_LOANPAY` (tc="519") | Loan Repayment |
| `OLI_TRANS_WITHDRAWAL` (tc="530") | Withdrawal/Partial Surrender |
| `OLI_TRANS_FUNDALLOCCHG` (tc="514") | Fund Allocation Change |
| `OLI_TRANS_FUNDTRANSFER` (tc="515") | Fund Transfer |
| `OLI_TRANS_CHGOWNER` (tc="512") | Ownership Change |
| `OLI_TRANS_SURRENDER` (tc="523") | Full Surrender |
| `OLI_TRANS_REINSTATE` (tc="522") | Reinstatement |
| `OLI_TRANS_1035EXCH` (tc="533") | 1035 Exchange |

### 13.2 Sample TXLife Beneficiary Change Request

```xml
<?xml version="1.0" encoding="UTF-8"?>
<TXLife xmlns="http://ACORD.org/Standards/Life/2"
        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        Version="2.43.00">
  <UserAuthRequest>
    <VendorApp>
      <VendorName>PASVendor</VendorName>
      <AppName>PolicyServiceApp</AppName>
      <AppVer>4.2.0</AppVer>
    </VendorApp>
  </UserAuthRequest>
  <TXLifeRequest>
    <TransRefGUID>TXN-2025-BEN-00012345</TransRefGUID>
    <TransType tc="510">Beneficiary Change</TransType>
    <TransExeDate>2025-07-01</TransExeDate>
    <TransExeTime>14:30:00</TransExeTime>
    <OLifE>
      <Holding id="Holding_1">
        <HoldingTypeCode tc="2">Policy</HoldingTypeCode>
        <Policy>
          <PolNumber>LIF-2024-00012345</PolNumber>
          <LineOfBusiness tc="1">Life</LineOfBusiness>
          <Life>
            <Coverage id="Cov_Base">
              <LifeParticipant id="Part_Bene1">
                <ParticipantName>
                  <FirstName>Mary</FirstName>
                  <LastName>Smith</LastName>
                </ParticipantName>
                <LifeParticipantRoleCode tc="34">Primary Beneficiary</LifeParticipantRoleCode>
                <BeneficiaryDesignation tc="1">Named Beneficiary</BeneficiaryDesignation>
                <BeneficiaryDistributionOption tc="1">Per Stirpes</BeneficiaryDistributionOption>
                <DistributionPct>50.00</DistributionPct>
              </LifeParticipant>
              <LifeParticipant id="Part_Bene2">
                <ParticipantName>
                  <LastName>Smith Family Trust dated 03/01/2020</LastName>
                </ParticipantName>
                <LifeParticipantRoleCode tc="34">Primary Beneficiary</LifeParticipantRoleCode>
                <BeneficiaryDesignation tc="1">Named Beneficiary</BeneficiaryDesignation>
                <DistributionPct>50.00</DistributionPct>
              </LifeParticipant>
              <LifeParticipant id="Part_ContBene1">
                <ParticipantName>
                  <FirstName>James</FirstName>
                  <LastName>Smith</LastName>
                </ParticipantName>
                <LifeParticipantRoleCode tc="35">Contingent Beneficiary</LifeParticipantRoleCode>
                <BeneficiaryDistributionOption tc="2">Per Capita</BeneficiaryDistributionOption>
                <DistributionPct>50.00</DistributionPct>
              </LifeParticipant>
              <LifeParticipant id="Part_ContBene2">
                <ParticipantName>
                  <FirstName>Emily</FirstName>
                  <LastName>Smith</LastName>
                </ParticipantName>
                <LifeParticipantRoleCode tc="35">Contingent Beneficiary</LifeParticipantRoleCode>
                <BeneficiaryDistributionOption tc="2">Per Capita</BeneficiaryDistributionOption>
                <DistributionPct>50.00</DistributionPct>
              </LifeParticipant>
            </Coverage>
          </Life>
        </Policy>
      </Holding>
    </OLifE>
  </TXLifeRequest>
</TXLife>
```

### 13.3 Sample TXLife Policy Loan Request

```xml
<?xml version="1.0" encoding="UTF-8"?>
<TXLife xmlns="http://ACORD.org/Standards/Life/2" Version="2.43.00">
  <TXLifeRequest>
    <TransRefGUID>TXN-2025-LOAN-00054321</TransRefGUID>
    <TransType tc="518">Loan</TransType>
    <TransExeDate>2025-08-15</TransExeDate>
    <OLifE>
      <Holding id="Holding_1">
        <Policy>
          <PolNumber>LIF-2024-00012345</PolNumber>
          <Life>
            <Coverage id="Cov_Base">
              <CoverageExtension>
                <LoanActivity>
                  <LoanActivityType tc="1">New Loan</LoanActivityType>
                  <RequestedLoanAmt>25000.00</RequestedLoanAmt>
                  <LoanIntRate>0.05</LoanIntRate>
                  <LoanIntType tc="1">Fixed</LoanIntType>
                  <DisbursementMethod tc="2">EFT</DisbursementMethod>
                  <BankAccountInfo>
                    <RoutingNum>021000089</RoutingNum>
                    <AcctNum>****5678</AcctNum>
                    <AcctType tc="1">Checking</AcctType>
                  </BankAccountInfo>
                </LoanActivity>
              </CoverageExtension>
            </Coverage>
          </Life>
        </Policy>
      </Holding>
    </OLifE>
  </TXLifeRequest>
</TXLife>
```

---

## 14. BPMN Process Flows

### 14.1 Beneficiary Change BPMN

```mermaid
flowchart TD
    Start([Start]) --> A[Receive Beneficiary Change Request]
    A --> B{Request Complete?}
    B -->|No| C[Return NIGO - Request Missing Info]
    C --> D[Await Corrected Request]
    D --> B
    B -->|Yes| E{Signature Valid?}
    E -->|No| F[Return NIGO - Signature Issue]
    F --> D
    E -->|Yes| G{Irrevocable Beneficiary on File?}
    G -->|Yes| H{Irrevocable Bene Consent Received?}
    H -->|No| I[Request Irrevocable Bene Consent]
    I --> D
    H -->|Yes| J[Validate Shares Total 100%]
    G -->|No| J
    J --> K{Shares Valid?}
    K -->|No| L[Return NIGO - Share Allocation Error]
    L --> D
    K -->|Yes| M[OFAC Screen New Beneficiaries]
    M --> N{OFAC Clear?}
    N -->|No| O[Escalate to Compliance]
    N -->|Yes| P[Update Beneficiary Records]
    P --> Q[Create Audit Trail Entry]
    Q --> R[Generate Confirmation Letter]
    R --> S([End])
```

### 14.2 Policy Loan BPMN

```mermaid
flowchart TD
    Start([Start]) --> A[Receive Loan Request]
    A --> B[Validate Policy Eligibility]
    B --> C{Eligible for Loan?}
    C -->|No| D[Reject - Not Eligible]
    D --> End1([End])
    C -->|Yes| E[Calculate Maximum Available Loan]
    E --> F{Requested ≤ Maximum?}
    F -->|No| G[Notify - Reduce to Maximum]
    G --> H{Owner Accepts Reduced Amount?}
    H -->|No| End2([End])
    H -->|Yes| I[Set Loan Amount to Maximum]
    F -->|Yes| I[Set Loan Amount to Requested]
    I --> J{Collateral Assignment?}
    J -->|Yes| K{Assignee Consent?}
    K -->|No| L[Request Assignee Consent]
    L --> M{Consent Received?}
    M -->|No| End3([End])
    M -->|Yes| N[Continue]
    J -->|No| N
    K -->|Yes| N
    N --> O{Irrevocable Beneficiary?}
    O -->|Yes| P{Bene Consent?}
    P -->|No| Q[Request Bene Consent]
    P -->|Yes| R[Continue]
    O -->|No| R
    R --> S{MEC Policy?}
    S -->|Yes| T[Calculate Tax Withholding on Loan]
    S -->|No| U[No Tax Impact]
    T --> V[Process Loan Disbursement]
    U --> V
    V --> W[Create Loan Record]
    W --> X[Debit Cash Value / Credit Loan Collateral Account]
    X --> Y[Generate Loan Disbursement]
    Y --> Z[Generate Confirmation & 1099 if Applicable]
    Z --> End4([End])
```

### 14.3 Withdrawal BPMN

```mermaid
flowchart TD
    Start([Start]) --> A[Receive Withdrawal Request]
    A --> B[Validate Eligibility]
    B --> C{Eligible?}
    C -->|No| D[Reject]
    C -->|Yes| E[Calculate Free Withdrawal Amount]
    E --> F{Withdrawal ≤ Free Amount?}
    F -->|Yes| G[No CDSC Applied]
    F -->|No| H[Calculate CDSC on Excess]
    G --> I[Calculate Tax Impact - FIFO or LIFO]
    H --> I
    I --> J{GMDB/GMWB Rider?}
    J -->|Yes| K[Calculate Rider Benefit Base Reduction]
    J -->|No| L[Continue]
    K --> L
    L --> M{Specific Fund Directed?}
    M -->|Yes| N[Process Fund-Specific Withdrawal]
    M -->|No| O[Process Pro-Rata Withdrawal]
    N --> P[Unit Sell Processing]
    O --> P
    P --> Q[Apply Tax Withholding]
    Q --> R[Disburse Net Amount]
    R --> S[Update Policy Values]
    S --> T[Generate 1099-R if Taxable]
    T --> U[Generate Confirmation]
    U --> End([End])
```

### 14.4 1035 Exchange BPMN (Outgoing)

```mermaid
flowchart TD
    Start([Start]) --> A[Receive 1035 Exchange Request]
    A --> B{All Documents Received?}
    B -->|No| C[Send NIGO Notice]
    C --> D[Await Documents]
    D --> B
    B -->|Yes| E[Verify Absolute Assignment]
    E --> F[Verify Signatures]
    F --> G{Valid?}
    G -->|No| H[Return to Requestor]
    G -->|Yes| I[Calculate Surrender Value]
    I --> J[Deduct Surrender Charges]
    J --> K[Offset Outstanding Loans]
    K --> L[Calculate Net Transfer Amount]
    L --> M[Prepare Check Payable to Receiving Carrier FBO Insured]
    M --> N[Prepare Cost Basis Statement]
    N --> O[Mail to Receiving Carrier]
    O --> P[Terminate Policy]
    P --> Q[No 1099-R for Qualifying Exchange]
    Q --> End([End])
```

---

## 15. STP Rules for Auto-Processing

### 15.1 STP Decision Framework

Straight-Through Processing (STP) enables the PAS to automatically approve and process servicing transactions without human intervention when all validation rules pass.

**STP Tiers:**

| Tier | Description | Example Transactions |
|------|-------------|---------------------|
| **Tier 1 - Full STP** | No human review; processed in real-time | Address change, premium allocation change, fund transfer, premium mode change |
| **Tier 2 - Conditional STP** | Auto-processed if specific conditions met | Beneficiary change (no irrevocable), loan (within limits), withdrawal (within free amount) |
| **Tier 3 - Assisted STP** | Auto-prepared but requires supervisor approval | Face amount decrease, ownership change, large loan |
| **Tier 4 - Manual** | Requires full manual review | Face amount increase (underwriting), 1035 exchange, irrevocable beneficiary changes |

### 15.2 STP Rule Configuration

```json
{
  "stpRules": [
    {
      "transactionType": "ADDRESS_CHANGE",
      "stpTier": 1,
      "conditions": [
        { "rule": "USPS_VALIDATED", "required": true },
        { "rule": "OFAC_CLEAR", "required": true },
        { "rule": "NO_PENDING_CLAIM", "required": true }
      ],
      "autoApprove": true,
      "maxProcessingTime": "REAL_TIME"
    },
    {
      "transactionType": "BENEFICIARY_CHANGE",
      "stpTier": 2,
      "conditions": [
        { "rule": "NO_IRREVOCABLE_BENEFICIARY", "required": true },
        { "rule": "SHARES_TOTAL_100", "required": true },
        { "rule": "ALL_BENE_OFAC_CLEAR", "required": true },
        { "rule": "VALID_SIGNATURE", "required": true },
        { "rule": "NO_COLLATERAL_ASSIGNMENT", "required": true }
      ],
      "autoApprove": true,
      "maxProcessingTime": "SAME_DAY"
    },
    {
      "transactionType": "POLICY_LOAN",
      "stpTier": 2,
      "conditions": [
        { "rule": "AMOUNT_WITHIN_MAX_LOAN", "required": true },
        { "rule": "NO_IRREVOCABLE_BENEFICIARY", "required": true },
        { "rule": "NO_COLLATERAL_ASSIGNMENT", "required": true },
        { "rule": "POLICY_NOT_IN_GRACE_PERIOD", "required": true },
        { "rule": "AMOUNT_UNDER_THRESHOLD", "threshold": 50000, "required": true }
      ],
      "autoApprove": true,
      "maxProcessingTime": "SAME_DAY"
    },
    {
      "transactionType": "FUND_TRANSFER",
      "stpTier": 1,
      "conditions": [
        { "rule": "WITHIN_TRANSFER_LIMIT", "required": true },
        { "rule": "FUND_OPEN", "required": true },
        { "rule": "MEETS_MINIMUM_BALANCE", "required": true },
        { "rule": "NOT_LOCKED_OUT", "required": true }
      ],
      "autoApprove": true,
      "maxProcessingTime": "REAL_TIME"
    },
    {
      "transactionType": "FACE_AMOUNT_INCREASE",
      "stpTier": 4,
      "conditions": [],
      "autoApprove": false,
      "requiresUnderwriting": true
    }
  ]
}
```

### 15.3 STP Processing Engine Pseudocode

```pseudocode
function processTransaction(transaction):
    // Load STP rules for this transaction type
    rules = loadSTPRules(transaction.type)

    if rules.stpTier == 4:
        return routeToManualQueue(transaction)

    // Evaluate each condition
    failedConditions = []
    for condition in rules.conditions:
        result = evaluateCondition(condition, transaction)
        if not result.passed:
            failedConditions.append(condition)

    if len(failedConditions) == 0:
        // All conditions passed - auto-approve
        if rules.stpTier <= 2:
            return autoProcess(transaction)
        else:
            return routeToSupervisorApproval(transaction)
    else:
        // STP failed - route to manual queue with failure reasons
        return routeToManualQueue(transaction, failedConditions)

function autoProcess(transaction):
    beginDBTransaction()
    try:
        applyChanges(transaction)
        createAuditRecord(transaction, "STP_AUTO_APPROVED")
        generateCorrespondence(transaction)
        commitDBTransaction()
        return SUCCESS
    except:
        rollbackDBTransaction()
        return routeToErrorQueue(transaction)
```

---

## 16. Microservice Architecture

### 16.1 Architecture Overview

```mermaid
graph TB
    subgraph "API Layer"
        GW[API Gateway]
        Auth[Auth Service]
    end

    subgraph "Service Layer"
        SVC[Servicing Orchestrator]
        TXN[Transaction Processor]
        VAL[Validation Engine]
        CALC[Calculation Engine]
        TAX[Tax Engine]
        CORR[Correspondence Service]
        AUDIT[Audit Service]
        WORK[Workflow Engine]
    end

    subgraph "Domain Services"
        BENE[Beneficiary Service]
        LOAN[Loan Service]
        WD[Withdrawal Service]
        FA[Face Amount Service]
        PREM[Premium Service]
        FUND[Fund Transfer Service]
        EXCH[Exchange Service]
        ANNIV[Anniversary Service]
    end

    subgraph "Data Layer"
        PDB[(Policy DB)]
        TDB[(Transaction DB)]
        ADB[(Audit DB)]
        DMS[(Document Store)]
        CACHE[(Redis Cache)]
    end

    subgraph "Integration Layer"
        MQ[Message Queue - Kafka]
        ESB[Event Bus]
    end

    subgraph "External"
        USPS[USPS API]
        OFAC[OFAC Screening]
        ACH[ACH/Payment Gateway]
        PRINT[Print Vendor]
        ACORD[ACORD Gateway]
    end

    GW --> Auth
    Auth --> SVC
    SVC --> TXN
    TXN --> VAL
    TXN --> CALC
    TXN --> TAX
    TXN --> CORR
    TXN --> AUDIT
    TXN --> WORK

    SVC --> BENE
    SVC --> LOAN
    SVC --> WD
    SVC --> FA
    SVC --> PREM
    SVC --> FUND
    SVC --> EXCH
    SVC --> ANNIV

    BENE --> PDB
    LOAN --> PDB
    WD --> PDB
    FA --> PDB
    PREM --> PDB
    FUND --> PDB
    EXCH --> PDB
    ANNIV --> PDB

    TXN --> TDB
    AUDIT --> ADB
    CORR --> DMS

    TXN --> MQ
    MQ --> ESB

    VAL --> USPS
    VAL --> OFAC
    LOAN --> ACH
    WD --> ACH
    CORR --> PRINT
    SVC --> ACORD

    TXN --> CACHE
```

### 16.2 Servicing Orchestrator

The Servicing Orchestrator is the central coordination service that manages the lifecycle of a servicing transaction.

**Responsibilities:**

1. **Transaction Intake**: Receives requests from all channels (portal, API, batch).
2. **Routing**: Determines which domain service handles the transaction.
3. **Sequencing**: Ensures dependent steps execute in order.
4. **Compensation**: If a step fails, orchestrates rollback of prior steps (saga pattern).
5. **Status Tracking**: Maintains transaction status visible to all channels.

**Technology Stack:**

| Component | Technology |
|-----------|-----------|
| Orchestration | Temporal.io or Camunda |
| API Protocol | REST + gRPC (internal) |
| Messaging | Apache Kafka |
| Caching | Redis |
| Database | PostgreSQL (OLTP) |
| Audit Store | Apache Cassandra or immutable append-only store |
| Search | Elasticsearch |
| Document Store | AWS S3 / Azure Blob |

### 16.3 Transaction Processor

The Transaction Processor executes the actual policy changes within a database transaction:

```pseudocode
class TransactionProcessor:
    function execute(transaction):
        // 1. Take snapshot of current policy state
        beforeState = snapshotPolicy(transaction.policyNumber)

        // 2. Acquire pessimistic lock on policy
        lock = acquireLock(transaction.policyNumber, timeout=30s)

        try:
            // 3. Execute domain-specific logic
            domainService = resolveDomainService(transaction.type)
            result = domainService.execute(transaction)

            // 4. Take snapshot of new policy state
            afterState = snapshotPolicy(transaction.policyNumber)

            // 5. Publish event
            publishEvent({
                transactionId: transaction.id,
                type: transaction.type,
                policyNumber: transaction.policyNumber,
                beforeState: beforeState,
                afterState: afterState,
                timestamp: now()
            })

            // 6. Create audit record
            auditService.record(transaction, beforeState, afterState)

            // 7. Trigger correspondence
            correspondenceService.generate(transaction, result)

            return result
        finally:
            releaseLock(lock)
```

### 16.4 Audit Trail Architecture

The audit trail must be **immutable**, **tamper-evident**, and **queryable**.

**Audit Record Schema:**

```json
{
  "auditId": "AUD-2025-00000001",
  "transactionId": "TXN-2025-BEN-00012345",
  "policyNumber": "LIF-2024-00012345",
  "eventType": "BENEFICIARY_CHANGE",
  "eventTimestamp": "2025-07-01T14:30:00.000Z",
  "userId": "CSR-0042",
  "userRole": "CUSTOMER_SERVICE_REP",
  "channel": "ADMIN_UI",
  "ipAddress": "10.0.1.42",
  "beforeState": {
    "primaryBeneficiaries": [
      { "name": "Mary Smith", "share": 100.0 }
    ],
    "contingentBeneficiaries": []
  },
  "afterState": {
    "primaryBeneficiaries": [
      { "name": "Mary Smith", "share": 50.0 },
      { "name": "Smith Family Trust", "share": 50.0 }
    ],
    "contingentBeneficiaries": [
      { "name": "James Smith", "share": 50.0 },
      { "name": "Emily Smith", "share": 50.0 }
    ]
  },
  "checksumSHA256": "a3f2b8c9d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9",
  "previousAuditChecksum": "b4c3d2e1f0a9b8c7d6e5f4a3b2c1d0e9f8a7b6c5"
}
```

**Blockchain-Style Chaining:**

Each audit record includes a SHA-256 hash of the previous audit record, creating a tamper-evident chain. Any modification to a historical audit record would break the chain.

---

## 17. Sample Payloads

### 17.1 REST API — Withdrawal Request

**Request:**

```http
POST /api/v2/policies/LIF-2024-00012345/withdrawals
Content-Type: application/json
Authorization: Bearer eyJhbGciOiJSUzI1NiIs...

{
  "requestedAmount": 15000.00,
  "effectiveDate": "2025-09-01",
  "withdrawalType": "PARTIAL_SURRENDER",
  "fundDirections": [
    { "fundCode": "SPIDX", "amount": 10000.00 },
    { "fundCode": "BOND", "amount": 5000.00 }
  ],
  "disbursementMethod": "EFT",
  "bankAccount": {
    "routingNumber": "021000089",
    "accountNumber": "****5678",
    "accountType": "CHECKING"
  },
  "taxWithholding": {
    "federalWithholdingElected": true,
    "federalWithholdingPercent": 10,
    "stateWithholdingElected": false
  },
  "requestedBy": {
    "partyId": "PTY-001",
    "role": "OWNER",
    "authenticationMethod": "MFA_VERIFIED"
  }
}
```

**Response:**

```json
{
  "transactionId": "TXN-2025-WD-00098765",
  "status": "APPROVED",
  "stpResult": "AUTO_PROCESSED",
  "effectiveDate": "2025-09-01",
  "details": {
    "grossWithdrawal": 15000.00,
    "freeWithdrawalUsed": 12000.00,
    "excessWithdrawal": 3000.00,
    "cdscCharge": 90.00,
    "taxableAmount": 0.00,
    "federalWithholding": 0.00,
    "stateWithholding": 0.00,
    "netDisbursement": 14910.00,
    "costBasisReduction": 14910.00,
    "remainingCostBasis": 65090.00,
    "fundDebits": [
      { "fundCode": "SPIDX", "units": 42.37, "amount": 10000.00 },
      { "fundCode": "BOND", "units": 196.85, "amount": 5000.00 }
    ],
    "riderImpact": {
      "gmdbBenefitBase": {
        "before": 250000.00,
        "reduction": 18750.00,
        "after": 231250.00,
        "method": "PRO_RATA"
      }
    }
  },
  "correspondence": {
    "confirmationId": "CORR-2025-00054321",
    "deliveryMethod": "EMAIL",
    "expectedDelivery": "2025-09-01"
  },
  "disbursement": {
    "method": "EFT",
    "expectedSettlement": "2025-09-03",
    "traceNumber": "ACH-2025-00012345"
  }
}
```

### 17.2 Kafka Event — Transaction Completed

```json
{
  "eventId": "EVT-2025-00000001",
  "eventType": "SERVICING_TRANSACTION_COMPLETED",
  "eventTimestamp": "2025-09-01T10:15:30.000Z",
  "source": "servicing-orchestrator",
  "policyNumber": "LIF-2024-00012345",
  "transactionId": "TXN-2025-WD-00098765",
  "transactionType": "WITHDRAWAL",
  "outcome": "SUCCESS",
  "impactedDomains": [
    "POLICY_VALUE",
    "FUND_HOLDINGS",
    "RIDER_BENEFITS",
    "TAX_REPORTING",
    "CORRESPONDENCE"
  ],
  "policyValueSnapshot": {
    "accountValue": 185000.00,
    "cashSurrenderValue": 178500.00,
    "deathBenefit": 500000.00,
    "outstandingLoans": 0.00,
    "costBasis": 65090.00
  }
}
```

---

## 18. Appendices

### Appendix A: Transaction Type Reference

| Code | Transaction Type | STP Tier | ACORD tc | Risk Level |
|------|-----------------|----------|----------|------------|
| ADR | Address Change | 1 | 508 | Low |
| NAM | Name Change | 2 | 1002 | Low |
| AOR | Agent of Record Change | 3 | — | Medium |
| BEN | Beneficiary Change | 2 | 510 | Medium |
| LN | Policy Loan | 2 | 518 | Medium |
| LNP | Loan Repayment | 1 | 519 | Low |
| WD | Withdrawal | 2 | 530 | Medium |
| FAI | Face Amount Increase | 4 | 513 | High |
| FAD | Face Amount Decrease | 3 | 513 | High |
| PMC | Premium Mode Change | 1 | 511 | Low |
| PAC | Premium Allocation Change | 1 | 514 | Low |
| FT | Fund Transfer | 1 | 515 | Low |
| OWN | Ownership Change | 4 | 512 | High |
| COL | Collateral Assignment | 3 | — | Medium |
| EXC | 1035 Exchange (Outgoing) | 4 | 533 | High |
| RDR | Rider Add | 3 | — | Medium |
| RDX | Rider Remove | 2 | — | Medium |
| RDX | Rider Exercise | 4 | — | High |
| SUR | Full Surrender | 3 | 523 | High |
| RST | Reinstatement | 4 | 522 | High |

### Appendix B: State-Specific Servicing Rules Matrix (Sample)

| Rule | CT | NY | CA | TX | FL |
|------|----|----|----|----|-----|
| Grace Period (Traditional) | 31 days | 31 days | 30 days | 31 days | 31 days |
| Grace Period (UL) | 61 days | 61 days | 61 days | 61 days | 61 days |
| Lapse Notice Required | Yes | Yes (60 days before) | Yes | Yes | Yes |
| Replacement Notice | Yes | Yes (enhanced) | Yes | Yes | Yes |
| Free-Look Period | 10 days | 10 days (20 for replacements) | 30 days (seniors) | 10 days | 14 days |
| Privacy Notice | Annual | Annual | Annual + specific CA privacy | Annual | Annual |
| Community Property | No | No | **Yes** | **Yes** | No |
| Divorce Auto-Revoke Bene | Yes | No | Yes | Yes | Yes |

### Appendix C: Glossary

| Term | Definition |
|------|-----------|
| **APL** | Automatic Premium Loan — policy provision to automatically borrow against cash value to pay premium |
| **CDSC** | Contingent Deferred Sales Charge — fee for early withdrawal |
| **COI** | Cost of Insurance — mortality charge deducted monthly in UL products |
| **CSV** | Cash Surrender Value — cash value minus surrender charges |
| **FIFO** | First In, First Out — tax basis recovery method for non-MEC policies |
| **GAP** | Guideline Annual Premium — Section 7702 annual premium limit |
| **GMDB** | Guaranteed Minimum Death Benefit — rider guaranteeing minimum death benefit on variable products |
| **GMWB** | Guaranteed Minimum Withdrawal Benefit — rider guaranteeing lifetime withdrawal amounts |
| **GSP** | Guideline Single Premium — Section 7702 single premium limit |
| **IUL** | Indexed Universal Life — UL with interest linked to market index |
| **LIFO** | Last In, First Out — tax basis recovery method for MEC policies |
| **MEC** | Modified Endowment Contract — policy that fails 7-pay test; taxed differently |
| **NAR** | Net Amount at Risk — death benefit minus cash value; basis for mortality charges |
| **NIGO** | Not In Good Order — incomplete or invalid servicing request |
| **PUA** | Paid-Up Additions — additional fully paid-up insurance purchased with dividends |
| **QDRO** | Qualified Domestic Relations Order — court order dividing retirement/insurance assets in divorce |
| **RPU** | Reduced Paid-Up — non-forfeiture option converting cash value to paid-up insurance at reduced face amount |
| **STP** | Straight-Through Processing — automated transaction processing without human intervention |
| **TAMRA** | Technical and Miscellaneous Revenue Act — established the MEC rules (IRC §7702A) |
| **TEFRA/DEFRA** | Tax Equity and Fiscal Responsibility Act / Deficit Reduction Act — established Section 7702 definition of life insurance |
| **TXLife** | ACORD XML message standard for life insurance transactions |
| **VUL** | Variable Universal Life — UL with sub-account investment options |

### Appendix D: References

1. **ACORD Standards**: ACORD TXLife XML Standard, Version 2.43.00
2. **IRC §72**: Annuities; Certain Proceeds of Endowment and Life Insurance Contracts
3. **IRC §101**: Certain Death Benefits
4. **IRC §1035**: Certain Exchanges of Insurance Policies
5. **IRC §7702**: Life Insurance Contract Defined
6. **IRC §7702A**: Modified Endowment Contract Defined
7. **NAIC Model Regulation 613**: Life Insurance and Annuities Replacement Model Regulation
8. **NAIC Model Regulation 582**: Standard Nonforfeiture Law for Life Insurance
9. **Standard Nonforfeiture Law**: Minimum cash value and nonforfeiture requirements
10. **Uniform Simultaneous Death Act**: Provisions for simultaneous death of insured and beneficiary
11. **NACHA Operating Rules**: ACH payment processing rules and formats
12. **PCI-DSS**: Payment Card Industry Data Security Standard

---

*This article is part of the Life Insurance PAS Architect's Encyclopedia. For related topics, see Article 12 (Premium Billing & Collection) and Article 13 (Policy Lapse, Reinstatement & Non-Forfeiture).*
