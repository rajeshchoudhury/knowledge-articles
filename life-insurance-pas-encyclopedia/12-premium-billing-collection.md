# Article 12: Premium Billing & Collection

## Table of Contents

1. [Introduction & Scope](#1-introduction--scope)
2. [Billing Modes & Modal Premium Calculation](#2-billing-modes--modal-premium-calculation)
3. [Billing Methods](#3-billing-methods)
4. [Billing Cycle Management](#4-billing-cycle-management)
5. [Premium Collection & Payment Application](#5-premium-collection--payment-application)
6. [Grace Period Processing](#6-grace-period-processing)
7. [Electronic Payment Processing](#7-electronic-payment-processing)
8. [List Billing (Group/Worksite)](#8-list-billing-groupworksite)
9. [Premium Accounting](#9-premium-accounting)
10. [Flexible Premium (UL/VUL/IUL)](#10-flexible-premium-ulvuliul)
11. [Dunning and Collection](#11-dunning-and-collection)
12. [Entity-Relationship Model](#12-entity-relationship-model)
13. [NACHA/ACH File Format Specification](#13-nachaach-file-format-specification)
14. [ACORD Billing-Related Messages](#14-acord-billing-related-messages)
15. [Architecture](#15-architecture)
16. [Batch Job Design for Billing Cycles](#16-batch-job-design-for-billing-cycles)
17. [Sample Payloads](#17-sample-payloads)
18. [Appendices](#18-appendices)

---

## 1. Introduction & Scope

Premium billing and collection is the revenue engine of a life insurance company. Every dollar of premium income flows through the billing subsystem, making it one of the most mission-critical components of the Policy Administration System (PAS). Errors in billing lead to policy lapses, regulatory violations, customer complaints, and revenue leakage.

### 1.1 Scope

This article covers the end-to-end lifecycle of premium billing and collection:

```mermaid
graph LR
    A[Premium Calculation] --> B[Bill Generation]
    B --> C[Bill Delivery]
    C --> D[Payment Collection]
    D --> E[Payment Matching]
    E --> F[Payment Application]
    F --> G[Accounting & Reconciliation]
    G --> H[Grace Period Management]
    H --> I[Dunning & Collection]
```

### 1.2 Product-Specific Billing Characteristics

| Product Type | Billing Nature | Premium Flexibility | Key Challenges |
|-------------|---------------|--------------------|----|
| **Term Life** | Fixed scheduled premium | None — fixed for term period | Renewal premium shock, lapse management |
| **Whole Life** | Fixed scheduled premium | None — level premium | Dividend offset, paid-up additions |
| **Universal Life (UL)** | Flexible premium | High — any amount, any time | No-lapse premium tracking, 7702 compliance |
| **Variable UL (VUL)** | Flexible premium | High | Fund allocation of premiums, 7702 compliance |
| **Indexed UL (IUL)** | Flexible premium | High | Segment allocation, target premium tracking |
| **Group/Worksite** | List billing | Varies by certificate | Reconciliation complexity, enrollment changes |

### 1.3 Regulatory Framework

Premium billing is governed by multiple regulatory bodies:

| Regulator | Area | Key Requirements |
|-----------|------|-----------------|
| State DOI | Grace period, notice requirements | State-specific grace period duration; mandatory lapse notices |
| IRS | Section 7702, 7702A | Premium limits for tax qualification |
| NACHA | ACH processing | Operating rules for electronic payments |
| PCI Council | Credit card payments | PCI-DSS compliance for card data |
| State Premium Tax | Tax on premiums collected | Varies 0%–4% by state |
| NAIC | Model regulations | Standardized frameworks adopted by states |

---

## 2. Billing Modes & Modal Premium Calculation

### 2.1 Billing Modes

The billing mode determines the frequency of premium payments.

| Mode | Payments/Year | Description |
|------|--------------|-------------|
| **Annual** | 1 | Single payment covers the full policy year |
| **Semi-Annual** | 2 | Two payments per policy year |
| **Quarterly** | 4 | Four payments per policy year |
| **Monthly** | 12 | Twelve payments per policy year |

### 2.2 Modal Factor Calculation

Modal factors convert the annual premium into periodic payments. They include a loading factor to compensate the insurer for the loss of investment income from deferred payments and additional administrative costs.

**Standard Modal Factor Table:**

| Mode | Typical Factor Range | Common Factor | Annual Equivalent Loading |
|------|---------------------|---------------|--------------------------|
| Annual | 1.000 | 1.000 | 0.0% |
| Semi-Annual | 0.510 – 0.525 | 0.520 | 4.0% |
| Quarterly | 0.260 – 0.270 | 0.265 | 6.0% |
| Monthly (Direct Bill) | 0.0875 – 0.0917 | 0.0900 | 8.0% |
| Monthly (PAC/EFT) | 0.0850 – 0.0875 | 0.0875 | 5.0% |

**Modal Premium Calculation:**

```pseudocode
function calculateModalPremium(annualPremium, mode, billingMethod):
    modalFactors = {
        ANNUAL: 1.000,
        SEMI_ANNUAL: 0.520,
        QUARTERLY: 0.265,
        MONTHLY_DIRECT: 0.0900,
        MONTHLY_PAC: 0.0875,
        MONTHLY_EFT: 0.0875
    }

    if mode == MONTHLY and billingMethod in [PAC, EFT]:
        factor = modalFactors.MONTHLY_PAC
    elif mode == MONTHLY:
        factor = modalFactors.MONTHLY_DIRECT
    else:
        factor = modalFactors[mode]

    modalPremium = annualPremium * factor

    // Round to nearest cent
    modalPremium = round(modalPremium, 2)

    return modalPremium
```

**Example Calculation:**

| Annual Premium | Mode | Factor | Modal Premium | Annual Total | Loading |
|---------------|------|--------|---------------|-------------|---------|
| $2,400.00 | Annual | 1.000 | $2,400.00 | $2,400.00 | $0.00 |
| $2,400.00 | Semi-Annual | 0.520 | $1,248.00 | $2,496.00 | $96.00 |
| $2,400.00 | Quarterly | 0.265 | $636.00 | $2,544.00 | $144.00 |
| $2,400.00 | Monthly (Direct) | 0.090 | $216.00 | $2,592.00 | $192.00 |
| $2,400.00 | Monthly (PAC) | 0.0875 | $210.00 | $2,520.00 | $120.00 |

### 2.3 Billing Frequency Change Processing

When a policyholder changes their billing mode, the PAS must handle the transition:

```mermaid
flowchart TD
    A[Mode Change Request] --> B{Current Mode?}
    B --> C[Calculate New Modal Premium]
    C --> D{Mid-Period Transition?}
    D -->|Yes| E[Pro-Rate Current Period]
    E --> F[Calculate Credit or Debit for Transition]
    F --> G[Apply to Next Bill]
    D -->|No| H[Apply at Next Anniversary or Period Start]
    G --> I[Update Billing Schedule]
    H --> I
    I --> J[Regenerate Future Bills]
    J --> K[Cancel Outstanding Future Bills Under Old Mode]
    K --> L[Generate Confirmation Notice]
    L --> M[Update PAC/EFT Schedule if Applicable]
```

**Pro-Ration Example:**

Policyholder changes from Annual to Quarterly mid-year:

| Component | Calculation | Amount |
|-----------|-------------|--------|
| Annual premium paid | | $2,400.00 |
| Days into policy year | 182 of 365 | |
| Earned premium | $2,400 × (182/365) | $1,196.71 |
| Unearned premium credit | $2,400 − $1,196.71 | $1,203.29 |
| Remaining quarterly premiums (2 remaining) | $636.00 × 2 | $1,272.00 |
| Net due at transition | $1,272.00 − $1,203.29 | $68.71 |

---

## 3. Billing Methods

### 3.1 Direct Billing (Paper Invoice)

Traditional paper billing remains common, especially for older policyholders.

**Paper Bill Lifecycle:**

| Step | Timing | Description |
|------|--------|-------------|
| Bill generation | T − 30 days | Bill generated 30 days before due date |
| Print and mail | T − 28 days | Sent to print vendor; mailed within 48 hours |
| Bill arrives | T − 21 days | Typical USPS delivery |
| Payment due | T | Due date on bill |
| Payment received | T + 0 to T + 10 | Payment arrives at lockbox |
| Grace period begins | T + 1 | Premium not received by due date |
| Grace period ends | T + 31 | Policy lapses if premium not received |

**Paper Bill Content:**

- Policyholder name and address
- Policy number
- Premium amount due
- Due date
- Grace period end date
- Payment coupon with OCR-scannable policy number
- Return envelope
- Agent information
- Payment options (check, money order, online, phone)

### 3.2 Electronic Notice

Electronic billing notices are delivered via email or customer portal.

**E-Notice Advantages:**

| Advantage | Metric |
|-----------|--------|
| Cost savings | 80%–90% reduction vs. paper |
| Delivery speed | Instantaneous vs. 7–10 days |
| Payment speed | Average 5 days faster than paper |
| Environmental | Eliminates paper, printing, postage |
| Tracking | Open/read receipts, click tracking |

**Opt-In Requirements:**

- E-SIGN Act (Federal) and UETA (State) govern electronic delivery consent.
- The policyholder must affirmatively opt in to electronic notices.
- The carrier must maintain the ability to revert to paper if electronic delivery fails.
- Some states require paper for specific notices (e.g., lapse warnings in New York).

### 3.3 Pre-Authorized Check (PAC) / Electronic Funds Transfer (EFT)

PAC/EFT is the most common billing method for individual life insurance.

**PAC/EFT Setup Data:**

```json
{
  "billingMethod": "PAC",
  "policyNumber": "LIF-2024-00012345",
  "bankAccount": {
    "bankName": "First National Bank",
    "routingNumber": "021000089",
    "accountNumber": "****5678",
    "accountType": "CHECKING",
    "accountHolderName": "John A. Smith"
  },
  "schedule": {
    "frequency": "MONTHLY",
    "draftDay": 15,
    "amount": 210.00,
    "startDate": "2025-01-15",
    "endDate": null
  },
  "authorization": {
    "signatureDate": "2024-12-15",
    "authorizationType": "WRITTEN",
    "cancellationTerms": "30_DAY_WRITTEN_NOTICE"
  }
}
```

### 3.4 Credit/Debit Card Billing

Credit card billing is less common for life insurance but growing, particularly for online purchases.

**PCI-DSS Requirements:**

| Requirement | Description |
|------------|-------------|
| **Tokenization** | Never store raw card numbers; use tokens from payment processor |
| **Encryption** | All card data encrypted in transit (TLS 1.2+) and at rest (AES-256) |
| **Network Segmentation** | Cardholder data environment isolated from other systems |
| **Access Control** | Strict role-based access; principle of least privilege |
| **Audit Logging** | All access to cardholder data logged and monitored |
| **Vulnerability Management** | Regular scans and penetration testing |
| **Incident Response** | Documented breach response plan |

**Card Payment Data Model:**

```json
{
  "billingMethod": "CREDIT_CARD",
  "policyNumber": "LIF-2024-00012345",
  "paymentToken": "tok_1234567890abcdef",
  "cardInfo": {
    "lastFour": "4567",
    "cardBrand": "VISA",
    "expirationMonth": 12,
    "expirationYear": 2027,
    "cardholderName": "JOHN A SMITH"
  },
  "schedule": {
    "frequency": "MONTHLY",
    "chargeDay": 15,
    "amount": 210.00
  },
  "pciCompliance": {
    "tokenProvider": "STRIPE",
    "tokenCreated": "2024-12-15T10:30:00Z",
    "rawCardDataStored": false,
    "encryptionStandard": "AES-256"
  }
}
```

### 3.5 List Billing (Group/Worksite)

*(Detailed in Section 8)*

### 3.6 Payroll Deduction

Payroll deduction is common for worksite/voluntary insurance products.

**Processing Flow:**

```mermaid
flowchart TD
    A[Employer Payroll Cycle] --> B[Carrier Provides Premium Schedule]
    B --> C[Employer Deducts from Employee Paychecks]
    C --> D[Employer Remits Lump Sum to Carrier]
    D --> E[Carrier Receives Remittance File]
    E --> F[Parse Employee-Level Detail]
    F --> G{Match to Certificates?}
    G -->|Yes| H[Apply Premiums to Individual Certificates]
    G -->|No| I[Suspense Unmatched Amounts]
    H --> J[Reconcile Total Received vs Expected]
    I --> J
    J --> K{Balanced?}
    K -->|Yes| L[Post to Accounting]
    K -->|No| M[Generate Discrepancy Report]
    M --> N[Research and Resolve]
```

### 3.7 Government Allotment

Government allotment is a billing method for military and federal employees where premiums are deducted from government pay.

| Feature | Detail |
|---------|--------|
| **Eligible Policyholders** | Active duty military, federal employees, retirees |
| **Deduction Source** | DFAS (Defense Finance and Accounting Service) or OPM |
| **File Format** | Specific government remittance formats |
| **Timing** | Monthly, aligned with government pay cycles |
| **Change Processing** | Allotment start/stop requests routed through government portals |

### 3.8 Bank Draft

Bank draft billing involves the carrier drafting the policyholder's bank account on a scheduled date.

**Draft vs. PAC:**

| Feature | PAC | Bank Draft |
|---------|-----|------------|
| Initiation | Carrier initiates ACH debit | Carrier initiates ACH debit |
| Authorization | Written PAC authorization form | Bank draft authorization form |
| Timing | Specific day of month | Specific day of month |
| Failure Handling | ACH return codes | ACH return codes |
| Key Difference | Carrier controls timing | Essentially same as PAC in modern practice |

---

## 4. Billing Cycle Management

### 4.1 Bill Generation Timing

Bills must be generated in advance of the due date to allow for delivery and payment processing time.

**Advance Billing Cycles:**

| Billing Method | Advance Generation | Rationale |
|---------------|-------------------|-----------|
| Paper (USPS) | 30–35 days before due date | Printing + USPS delivery + payment time |
| Email notice | 15–20 days before due date | Instant delivery + payment time |
| PAC/EFT | 10 days before draft date | File submission to NACHA + processing |
| Credit card | 5–7 days before charge date | Authorization + processing |
| List bill | 30–45 days before due date | Employer processing time |

### 4.2 Billing Run Scheduling

The billing engine operates on a daily batch cycle, processing all policies with upcoming premium due dates.

**Daily Billing Run Schedule:**

```mermaid
gantt
    title Daily Billing Run Schedule
    dateFormat HH:mm
    axisFormat %H:%M

    section Pre-Processing
    Identify Due Policies        :a1, 01:00, 30min
    Calculate Premium Amounts    :a2, after a1, 45min
    Apply Dividends/Offsets      :a3, after a2, 30min

    section Bill Generation
    Generate Paper Bills         :b1, after a3, 60min
    Generate E-Notices           :b2, after a3, 30min
    Generate PAC/EFT Files       :b3, after a3, 45min

    section Transmission
    Send to Print Vendor         :c1, after b1, 15min
    Send Email Notices           :c2, after b2, 15min
    Submit ACH Files to NACHA    :c3, after b3, 15min

    section Post-Processing
    Update Billing Records       :d1, after c3, 30min
    Generate Billing Report      :d2, after d1, 15min
    Exception Report             :d3, after d2, 15min
```

### 4.3 Bill Due Date Calculation

```pseudocode
function calculateBillDueDate(policy, billingCycle):
    if policy.premiumMode == ANNUAL:
        dueDate = policy.anniversaryDate
    elif policy.premiumMode == SEMI_ANNUAL:
        dueDate = policy.anniversaryDate + (billingCycle * 6_months)
    elif policy.premiumMode == QUARTERLY:
        dueDate = policy.anniversaryDate + (billingCycle * 3_months)
    elif policy.premiumMode == MONTHLY:
        dueDate = policy.monthlyBillDay  // Day of month

    // Adjust for weekends and holidays
    if isWeekend(dueDate) or isHoliday(dueDate):
        dueDate = nextBusinessDay(dueDate)

    return dueDate
```

### 4.4 Batch Billing vs. On-Demand

| Type | Description | Use Case |
|------|-------------|----------|
| **Batch Billing** | All bills for a cycle generated in a single batch run | Standard billing operations |
| **On-Demand Billing** | Individual bill generated upon request | Reinstatement, mid-cycle changes, customer request |

---

## 5. Premium Collection & Payment Application

### 5.1 Payment Matching

Payment matching is the process of associating received payments with the correct policy and premium due.

**Payment Sources:**

```mermaid
graph TD
    subgraph "Payment Sources"
        LB[Lockbox - Check/Money Order]
        ACH[ACH/EFT Returns]
        CC[Credit Card Processor]
        WEB[Online Portal]
        IVR[IVR Phone Payment]
        WIRE[Wire Transfer]
        PAY[Payroll Deduction File]
    end

    subgraph "Payment Processing"
        MATCH[Payment Matching Engine]
        SUSP[Suspense Account]
        APP[Payment Application Engine]
    end

    subgraph "Destinations"
        POL[(Policy Premium Account)]
        LOAN[(Loan Repayment Account)]
        MISC[(Miscellaneous Receivable)]
    end

    LB --> MATCH
    ACH --> MATCH
    CC --> MATCH
    WEB --> MATCH
    IVR --> MATCH
    WIRE --> MATCH
    PAY --> MATCH

    MATCH -->|Matched| APP
    MATCH -->|Unmatched| SUSP
    SUSP -->|Research & Match| APP

    APP --> POL
    APP --> LOAN
    APP --> MISC
```

**Matching Logic:**

```pseudocode
function matchPayment(payment):
    // Level 1: Exact match on policy number
    if payment.policyNumber:
        policy = lookupPolicy(payment.policyNumber)
        if policy and policy.hasPremiumDue():
            return match(payment, policy)

    // Level 2: Match on payor information
    if payment.payorSSN or payment.payorName:
        policies = searchByPayor(payment.payorSSN, payment.payorName)
        if len(policies) == 1:
            return match(payment, policies[0])
        elif len(policies) > 1:
            return matchByAmount(payment, policies)

    // Level 3: Match on check/reference number
    if payment.checkNumber or payment.referenceNumber:
        policy = lookupByReference(payment.checkNumber)
        if policy:
            return match(payment, policy)

    // Level 4: Match by amount
    policies = searchByExactAmount(payment.amount)
    if len(policies) == 1:
        return match(payment, policies[0])

    // No match found — route to suspense
    return routeToSuspense(payment)
```

### 5.2 Payment Application Rules

When a payment is received, it must be applied according to a defined priority hierarchy:

**Payment Application Priority:**

| Priority | Application Target | Description |
|----------|-------------------|-------------|
| 1 | **Current premium due** | Apply to the oldest unpaid premium first |
| 2 | **Past-due premiums** | Apply to any premiums in arrears |
| 3 | **Loan interest** | Apply to accrued but unpaid loan interest |
| 4 | **APL repayment** | Repay any automatic premium loan |
| 5 | **Policy loan repayment** | Reduce outstanding loan balance |
| 6 | **Advance premium** | Hold as advance premium for future periods |
| 7 | **Suspense** | Hold in suspense for disposition |

**Payment Application Engine:**

```pseudocode
function applyPayment(policy, payment):
    remainingAmount = payment.amount
    applications = []

    // Priority 1: Current premium due
    if policy.currentPremiumDue > 0:
        applied = min(remainingAmount, policy.currentPremiumDue)
        applications.append({
            target: "CURRENT_PREMIUM",
            amount: applied,
            premiumDueDate: policy.currentPremiumDueDate
        })
        remainingAmount -= applied

    // Priority 2: Past-due premiums
    for pastDue in policy.pastDuePremiums:
        if remainingAmount <= 0: break
        applied = min(remainingAmount, pastDue.amount)
        applications.append({
            target: "PAST_DUE_PREMIUM",
            amount: applied,
            premiumDueDate: pastDue.dueDate
        })
        remainingAmount -= applied

    // Priority 3: Loan interest
    if remainingAmount > 0 and policy.hasOutstandingLoan():
        accruedInterest = policy.loan.accruedInterest
        applied = min(remainingAmount, accruedInterest)
        applications.append({
            target: "LOAN_INTEREST",
            amount: applied
        })
        remainingAmount -= applied

    // Priority 4: APL repayment
    if remainingAmount > 0 and policy.hasAPLBalance():
        applied = min(remainingAmount, policy.aplBalance)
        applications.append({
            target: "APL_REPAYMENT",
            amount: applied
        })
        remainingAmount -= applied

    // Priority 5: Loan principal
    if remainingAmount > 0 and policy.hasOutstandingLoan():
        applied = min(remainingAmount, policy.loan.principalBalance)
        applications.append({
            target: "LOAN_PRINCIPAL",
            amount: applied
        })
        remainingAmount -= applied

    // Priority 6: Advance premium
    if remainingAmount > 0:
        if policy.acceptsAdvancePremium():
            applications.append({
                target: "ADVANCE_PREMIUM",
                amount: remainingAmount
            })
            remainingAmount = 0
        else:
            // Flexible premium products — apply as additional premium
            applications.append({
                target: "ADDITIONAL_PREMIUM",
                amount: remainingAmount
            })
            remainingAmount = 0

    return applications
```

### 5.3 Over-Payment Handling

When a payment exceeds the amount due:

| Scenario | Handling |
|----------|---------|
| **Fixed premium product** | Hold as advance premium for next period; refund if excessive |
| **Flexible premium (UL/VUL)** | Apply as additional premium (subject to 7702 limits) |
| **Significant overpayment** | Contact policyholder; hold in suspense pending instruction |
| **Final payment (policy terminating)** | Refund overpayment by check or EFT |

### 5.4 Under-Payment Handling

When a payment is less than the amount due:

| Scenario | Handling |
|----------|---------|
| **Within tolerance (e.g., ≤ $5)** | Accept as full payment; write off difference |
| **Partial payment** | Apply to oldest premium; bill remainder |
| **Significantly short** | Hold in suspense; send notice for remaining balance |
| **Multiple partial payments** | Accumulate until full premium satisfied |

**Tolerance Configuration:**

```json
{
  "paymentTolerances": {
    "underpayment": {
      "absoluteThreshold": 5.00,
      "percentageThreshold": 2.0,
      "action": "ACCEPT_AS_FULL",
      "writeOffGLAccount": "6200-00-PREMIUM-WRITEOFF"
    },
    "overpayment": {
      "absoluteThreshold": 10.00,
      "percentageThreshold": 5.0,
      "action": "HOLD_AS_ADVANCE",
      "refundThreshold": 500.00,
      "autoRefund": false
    }
  }
}
```

### 5.5 Misapplied Payment Correction

When a payment is applied to the wrong policy or the wrong premium period, a correction workflow is triggered:

```mermaid
flowchart TD
    A[Misapplication Identified] --> B[Create Reversal Transaction]
    B --> C[Reverse from Incorrect Policy/Period]
    C --> D[Apply to Correct Policy/Period]
    D --> E{Grace Period Impact?}
    E -->|Yes - Lapse Reversed| F[Reinstate Lapsed Policy]
    E -->|No| G[Continue]
    F --> G
    G --> H[Update Accounting Entries]
    H --> I[Notify Affected Policyholders]
    I --> J[Create Audit Trail]
```

### 5.6 Suspense Account Management

The suspense account holds unmatched or unidentifiable payments pending resolution.

**Suspense Account Rules:**

| Rule | Description |
|------|-------------|
| **Aging** | Suspense items aged daily; escalated at 15, 30, 60, 90 days |
| **Auto-Match Retry** | System re-attempts matching daily as new data arrives |
| **Research Workflow** | Assigns suspense items to research queue after 5 days |
| **Escheatment** | After state-mandated period (typically 3–5 years), unclaimed funds escheated to state |
| **Reporting** | Daily suspense balance report; monthly trending analysis |

**Suspense Account Data Model:**

```json
{
  "suspenseId": "SUSP-2025-00000123",
  "paymentDate": "2025-03-15",
  "amount": 450.00,
  "paymentMethod": "CHECK",
  "payorName": "John Smith",
  "checkNumber": "1234",
  "bankRouting": "021000089",
  "lockboxId": "LBX-001",
  "batchId": "BATCH-2025-0315-001",
  "matchAttempts": [
    {
      "attemptDate": "2025-03-15",
      "method": "POLICY_NUMBER",
      "result": "NO_MATCH",
      "reason": "No policy number on check"
    },
    {
      "attemptDate": "2025-03-15",
      "method": "PAYOR_NAME",
      "result": "MULTIPLE_MATCH",
      "matchedPolicies": ["LIF-2024-00012345", "LIF-2020-00098765"]
    }
  ],
  "status": "PENDING_RESEARCH",
  "assignedTo": "RESEARCH_TEAM",
  "agingDays": 5,
  "escalationLevel": 1
}
```

### 5.7 Unidentified Payment Processing

Payments with no identifiable policy number or payor information:

```pseudocode
function processUnidentifiedPayment(payment):
    // Attempt 1: OCR scan of check images for policy number
    ocrResult = ocrScanCheck(payment.checkImageFront)
    if ocrResult.policyNumber:
        return attemptMatch(payment, ocrResult.policyNumber)

    // Attempt 2: Search by payor bank account
    if payment.bankRoutingNumber and payment.bankAccountNumber:
        policies = searchByBankAccount(payment.bankRoutingNumber, 
                                        payment.bankAccountNumber)
        if policies:
            return attemptMatchByAccount(payment, policies)

    // Attempt 3: Search by check amount and expected premium
    policies = searchByExactAmount(payment.amount, tolerance=0.01)
    if len(policies) == 1:
        return match(payment, policies[0])

    // Attempt 4: Fuzzy name search
    if payment.payorName:
        policies = fuzzyNameSearch(payment.payorName, threshold=0.85)
        if len(policies) == 1:
            return match(payment, policies[0])

    // All attempts failed — hold in suspense
    return createSuspenseEntry(payment, reason="UNIDENTIFIED")
```

---

## 6. Grace Period Processing

### 6.1 Grace Period Duration

The grace period is the window after the premium due date during which the policy remains in force even though the premium has not been paid.

**Grace Period Duration by Product Type and State:**

| Product Type | Standard Duration | State Variations |
|-------------|-------------------|-----------------|
| **Term Life** | 31 days | NY: 31 days; some states: 30 days |
| **Whole Life** | 31 days | Standard per NAIC model |
| **Universal Life** | 61 days | Extended to allow monthly deductions from CSV |
| **Variable UL** | 61 days | Same as UL |
| **Indexed UL** | 61 days | Same as UL |
| **Group Life** | 31 days | Per master contract and state law |

### 6.2 Grace Period Notices

**Notice Timeline:**

```mermaid
gantt
    title Grace Period Notice Timeline (Traditional Product)
    dateFormat YYYY-MM-DD
    axisFormat %m/%d

    section Billing
    Premium Due Date        :milestone, m1, 2025-01-15, 0d
    Bill Sent (30 days prior) :b1, 2024-12-16, 2025-01-15

    section Grace Period
    Grace Period Start      :gp1, 2025-01-16, 2025-02-14
    Grace Period Notice Sent :milestone, m2, 2025-01-20, 0d
    Final Notice Sent       :milestone, m3, 2025-02-01, 0d
    Grace Period End        :milestone, m4, 2025-02-14, 0d

    section Lapse
    Policy Lapses          :milestone, m5, 2025-02-15, 0d
    Lapse Notice Sent      :milestone, m6, 2025-02-18, 0d
```

**State-Specific Notice Requirements:**

| State | Notice Requirement | Timing |
|-------|--------------------|--------|
| **New York** | Must mail notice to owner and assignee at least 15 days before lapse | 15 days before grace period end |
| **California** | Notice of pending lapse required | Before grace period end |
| **Connecticut** | Written notice to insured and assignee | 30 days before lapse |
| **Florida** | Notice required for policies > 2 years old | Before lapse |
| **Texas** | Notice to insured, owner, assignee | Before lapse |
| **Illinois** | Senior policyholder (60+) notification to designated person | Before lapse |

### 6.3 Grace Period Interest/COI Deductions

During the grace period, the policy remains in force, but the insurer continues to incur mortality and expense costs.

**For Traditional Products:**
- If the insured dies during the grace period, the death benefit is paid minus the unpaid premium.

**For UL Products:**
- Monthly deductions continue from the cash value.
- If the cash value is insufficient for the monthly deduction, the grace period begins.

```pseudocode
function processULGracePeriod(policy, monthlyDeductionDate):
    monthlyDeduction = calculateMonthlyDeduction(policy)

    if policy.accountValue >= monthlyDeduction:
        deductFromAccountValue(policy, monthlyDeduction)
        return POLICY_IN_FORCE
    else:
        // Insufficient account value — check no-lapse guarantee
        if policy.hasNoLapseGuarantee and isNoLapseActive(policy):
            // Keep policy in force via no-lapse guarantee
            deductFromAccountValue(policy, policy.accountValue)  // Take what's available
            return POLICY_IN_FORCE_VIA_GUARANTEE
        else:
            // Begin grace period
            startGracePeriod(policy)
            sendGracePeriodNotice(policy)
            return GRACE_PERIOD_STARTED
```

### 6.4 Lapse Date Determination

```pseudocode
function determineLapseDate(policy):
    if policy.productType in [TERM, WHOLE_LIFE]:
        gracePeriodDays = getGracePeriod(policy.stateOfIssue, policy.productType)
        lapseDate = policy.premiumDueDate + gracePeriodDays
    elif policy.productType in [UL, VUL, IUL]:
        gracePeriodDays = 61  // Standard UL grace period
        firstFailedDeductionDate = policy.firstFailedMonthlyDeduction
        lapseDate = firstFailedDeductionDate + gracePeriodDays
    
    // Adjust for non-business day
    if not isBusinessDay(lapseDate):
        lapseDate = nextBusinessDay(lapseDate)

    return lapseDate
```

### 6.5 Extended Grace Periods

**Military Extension (SCRA):**

Under the Servicemembers Civil Relief Act (SCRA):
- Active duty military members are entitled to protection from policy lapse.
- Grace period may be extended for the period of military service plus 2 years.
- Interest rate on premiums capped at 6%.

**Disaster Extensions:**

| Event Type | Extension | Authority |
|-----------|-----------|-----------|
| FEMA-declared disaster | 30–90 days | State DOI emergency orders |
| State of emergency | Varies | Governor's executive orders |
| Pandemic | Varies | State DOI bulletins |

### 6.6 CARES Act Provisions

The CARES Act (2020) and similar emergency legislation provided:

- Extended grace periods for affected policyholders
- Suspension of policy lapses
- Premium payment deferral provisions
- Waiver of late fees and penalties

**PAS Implementation:**

```json
{
  "emergencyProvision": {
    "name": "CARES_ACT_2020",
    "effectiveDate": "2020-03-27",
    "expirationDate": "2020-12-31",
    "provisions": [
      {
        "type": "GRACE_PERIOD_EXTENSION",
        "extensionDays": 90,
        "eligibilityCriteria": "POLICYHOLDER_ATTESTATION_OF_HARDSHIP"
      },
      {
        "type": "LAPSE_SUSPENSION",
        "suspensionPeriod": "2020-03-27_TO_2020-12-31",
        "autoReinstateOnPayment": true
      },
      {
        "type": "PREMIUM_DEFERRAL",
        "maxDeferralMonths": 6,
        "interestOnDeferral": 0.0
      }
    ]
  }
}
```

---

## 7. Electronic Payment Processing

### 7.1 ACH Origination

The carrier originates ACH debits (pull payments) from policyholder bank accounts for PAC/EFT billing.

**ACH Processing Timeline:**

| Day | Event |
|-----|-------|
| T − 2 | Carrier creates ACH file and submits to ODFI (Originating Depository Financial Institution) |
| T − 1 | ODFI forwards to ACH operator (Federal Reserve or EPN) |
| T | Settlement date — funds transferred from policyholder's bank (RDFI) to carrier's bank (ODFI) |
| T + 1 | Carrier receives settlement confirmation |
| T + 2 | Return window opens (RDFI may return for certain reason codes) |
| T + 5 | Standard return deadline (most return codes) |
| T + 60 | Extended return deadline (unauthorized transactions — R10) |

### 7.2 NACHA File Format

*(Detailed in Section 13)*

### 7.3 ACH Return Codes and Handling

**Common ACH Return Codes:**

| Return Code | Description | Carrier Response | Retry? |
|------------|-------------|-----------------|--------|
| **R01** | Insufficient Funds | Re-attempt in 3 business days | Yes (1 retry) |
| **R02** | Account Closed | Suspend PAC; notify policyholder | No |
| **R03** | No Account/Unable to Locate | Suspend PAC; verify account info | No |
| **R04** | Invalid Account Number | Suspend PAC; request corrected info | No |
| **R05** | Unauthorized Debit to Consumer Account | Suspend PAC; investigate; NACHA rules apply | No |
| **R06** | Returned per ODFI's Request | Investigate internally | Case-by-case |
| **R07** | Authorization Revoked by Customer | Suspend PAC; send paper bill | No |
| **R08** | Payment Stopped | Suspend PAC; notify policyholder | No |
| **R09** | Uncollected Funds | Re-attempt in 5 business days | Yes (1 retry) |
| **R10** | Customer Advises Unauthorized | Suspend PAC; investigate; fraud risk | No |
| **R16** | Account Frozen | Suspend PAC; notify policyholder | No |
| **R20** | Non-Transaction Account | Suspend PAC; request new account | No |
| **R29** | Corporate Customer Advises Not Authorized | Suspend PAC; investigate | No |

**ACH Return Processing Logic:**

```pseudocode
function processACHReturn(returnRecord):
    policy = lookupPolicy(returnRecord.policyNumber)
    returnCode = returnRecord.returnReasonCode

    // Reverse the payment application
    reversePayment(policy, returnRecord.originalAmount, returnRecord.originalDate)

    if returnCode in ["R01", "R09"]:
        // Insufficient funds — eligible for retry
        if policy.achRetryCount < MAX_RETRIES:
            scheduleRetry(policy, daysToWait=3)
            policy.achRetryCount += 1
            sendNotice(policy, "PAYMENT_RETURNED_RETRY_SCHEDULED")
        else:
            suspendPAC(policy)
            sendNotice(policy, "PAC_SUSPENDED_MULTIPLE_RETURNS")
            beginGracePeriodIfApplicable(policy)

    elif returnCode in ["R02", "R03", "R04", "R20"]:
        // Account issue — PAC cannot continue
        suspendPAC(policy)
        switchToDirectBill(policy)
        sendNotice(policy, "PAC_SUSPENDED_ACCOUNT_ISSUE")
        beginGracePeriodIfApplicable(policy)

    elif returnCode in ["R07", "R08", "R10"]:
        // Authorization issue — stop all PAC activity
        terminatePAC(policy)
        switchToDirectBill(policy)
        sendNotice(policy, "PAC_TERMINATED_AUTHORIZATION")
        if returnCode == "R10":
            flagForFraudReview(policy)

    // Update accounting
    createReversalEntry(policy, returnRecord)
    updatePremiumReceivable(policy)
```

### 7.4 ACH Retry Rules

NACHA rules govern when and how many times a carrier can retry a failed ACH debit:

| Rule | Requirement |
|------|-------------|
| **Maximum retries** | 2 retries for R01 (insufficient funds) within 180 days |
| **Timing** | At least 1 business day between retry attempts |
| **Notation** | Retry must use same Standard Entry Class Code |
| **Same amount** | Retry must be for same amount as original |
| **Prohibited retries** | Cannot retry for R02, R03, R04, R07, R08, R10 |

### 7.5 Credit Card Processing

**Credit Card Payment Flow:**

```mermaid
sequenceDiagram
    participant PAS as PAS Billing Engine
    participant PG as Payment Gateway
    participant PN as Card Network (Visa/MC)
    participant IB as Issuing Bank

    PAS->>PG: Charge Request (token, amount)
    PG->>PN: Authorization Request
    PN->>IB: Authorization Request
    IB->>PN: Authorization Response (Approved/Declined)
    PN->>PG: Authorization Response
    PG->>PAS: Authorization Result

    alt Approved
        PAS->>PAS: Record Authorized Payment
        Note over PG,IB: End of day batch settlement
        PG->>PN: Settlement/Capture
        PN->>IB: Settlement
        IB->>PN: Settlement Confirmation
        PN->>PG: Settlement Confirmation
        PG->>PAS: Settlement Confirmation
        PAS->>PAS: Apply Payment to Policy
    else Declined
        PAS->>PAS: Record Decline
        PAS->>PAS: Send Decline Notification
        PAS->>PAS: Begin Alternative Payment Process
    end
```

**Decline Codes and Handling:**

| Decline Code | Description | Action |
|-------------|-------------|--------|
| 05 | Do Not Honor | Retry once; if declined again, request new card |
| 14 | Invalid Card Number | Request new card information |
| 41 | Lost Card | Do not retry; request new card |
| 43 | Stolen Card | Do not retry; flag for review |
| 51 | Insufficient Funds | Retry in 3 days |
| 54 | Expired Card | Request updated expiration |
| 65 | Activity Limit Exceeded | Retry next day |

### 7.6 Recurring Payment Management

**Recurring Payment Lifecycle:**

```mermaid
statediagram-v2
    [*] --> Setup : Authorization Received
    Setup --> Active : Validated & Scheduled
    Active --> Active : Successful Payment
    Active --> RetryPending : Payment Failed
    RetryPending --> Active : Retry Successful
    RetryPending --> Suspended : Max Retries Exceeded
    Suspended --> Active : New Payment Info Received
    Active --> Cancelled : Owner Request
    Active --> Terminated : Policy Terminated
    Suspended --> Cancelled : Owner Request
    Suspended --> Terminated : Policy Lapse
    Cancelled --> [*]
    Terminated --> [*]
```

### 7.7 Payment Method Changes

When a policyholder changes their payment method (e.g., check to EFT, EFT to credit card):

```json
{
  "transactionType": "PAYMENT_METHOD_CHANGE",
  "policyNumber": "LIF-2024-00012345",
  "effectiveDate": "2025-04-01",
  "previousMethod": {
    "type": "PAC",
    "bankRouting": "021000089",
    "bankAccountLastFour": "5678"
  },
  "newMethod": {
    "type": "CREDIT_CARD",
    "cardToken": "tok_abc123def456",
    "cardLastFour": "4567",
    "cardBrand": "VISA",
    "cardExpiration": "12/2027"
  },
  "transitionHandling": {
    "cancelExistingPAC": true,
    "lastPACDraftDate": "2025-03-15",
    "firstCardChargeDate": "2025-04-15",
    "gapCoverage": "NO_GAP"
  }
}
```

---

## 8. List Billing (Group/Worksite)

### 8.1 Master Bill Generation

List billing consolidates premiums for multiple certificates (individuals) under a single group policy into a master bill.

**Master Bill Structure:**

```json
{
  "listBill": {
    "billId": "LB-2025-00000456",
    "masterPolicyNumber": "GRP-2024-00001000",
    "policyholderName": "Acme Corporation",
    "billingPeriod": "2025-04-01_TO_2025-04-30",
    "dueDate": "2025-04-01",
    "generationDate": "2025-03-01",
    "summary": {
      "totalLives": 342,
      "totalPremium": 45678.50,
      "employerContribution": 30452.33,
      "employeeContribution": 15226.17,
      "adjustments": -1250.00,
      "netAmountDue": 44428.50
    },
    "certificateDetail": [
      {
        "certificateNumber": "CERT-001",
        "employeeName": "Jane Doe",
        "employeeId": "EMP-12345",
        "coverageType": "EMPLOYEE_PLUS_FAMILY",
        "basicLifePremium": 45.00,
        "adndPremium": 12.50,
        "voluntaryLifePremium": 67.30,
        "totalPremium": 124.80,
        "employerPortion": 45.00,
        "employeePortion": 79.80,
        "status": "ACTIVE",
        "effectiveDate": "2024-01-01"
      },
      {
        "certificateNumber": "CERT-002",
        "employeeName": "John Roe",
        "employeeId": "EMP-12346",
        "coverageType": "EMPLOYEE_ONLY",
        "basicLifePremium": 22.50,
        "adndPremium": 6.25,
        "voluntaryLifePremium": 0.00,
        "totalPremium": 28.75,
        "employerPortion": 22.50,
        "employeePortion": 6.25,
        "status": "ACTIVE",
        "effectiveDate": "2024-01-01"
      }
    ]
  }
}
```

### 8.2 Enrollment Changes

List billing must accommodate ongoing enrollment changes:

| Change Type | Description | Billing Impact |
|------------|-------------|----------------|
| **New Enrollment** | New employee added | Pro-rated premium for partial month |
| **Termination** | Employee terminated | Pro-rated credit for remaining month |
| **Coverage Change** | Employee changes coverage tier | Premium adjustment |
| **Salary Change** | For salary-based premiums | Premium recalculation |
| **Age Band Change** | Employee enters new age band | Rate change |
| **Status Change** | Active → Leave of Absence | Premium waiver or continuation rules |
| **Dependent Add** | Employee adds dependent | Additional premium |
| **Dependent Remove** | Employee removes dependent | Premium reduction |

**Enrollment Change Processing:**

```mermaid
flowchart TD
    A[Enrollment Change File Received] --> B[Parse Change Records]
    B --> C{Change Type?}
    C -->|New Enrollment| D[Validate Eligibility]
    D --> E[Calculate Pro-Rated Premium]
    C -->|Termination| F[Determine Effective Date]
    F --> G[Calculate Pro-Rated Credit]
    C -->|Coverage Change| H[Validate New Coverage]
    H --> I[Calculate Premium Difference]
    C -->|Salary Change| J[Recalculate Premium]
    E --> K[Update Master Bill]
    G --> K
    I --> K
    J --> K
    K --> L[Generate Adjustment Report]
    L --> M[Send Updated Bill to Employer]
```

### 8.3 Premium Reconciliation

Group premium reconciliation is complex and error-prone.

**Reconciliation Process:**

```pseudocode
function reconcileListBill(masterBill, paymentReceived):
    expectedAmount = masterBill.netAmountDue
    receivedAmount = paymentReceived.amount
    variance = receivedAmount - expectedAmount

    if abs(variance) < TOLERANCE:
        // Within tolerance — accept as full payment
        applyFullPayment(masterBill, paymentReceived)
        return RECONCILED

    elif variance > 0:
        // Overpayment
        applyFullPayment(masterBill, paymentReceived)
        createCreditMemo(masterBill, variance)
        return RECONCILED_WITH_CREDIT

    else:
        // Underpayment
        shortfall = abs(variance)
        if shortfall / expectedAmount < 0.02:
            // Less than 2% short — accept with exception
            applyPartialPayment(masterBill, paymentReceived)
            createShortPayReport(masterBill, shortfall)
            return RECONCILED_WITH_SHORTFALL
        else:
            // Significant shortfall — investigate
            applyPartialPayment(masterBill, paymentReceived)
            createReconciliationException(masterBill, shortfall)
            return NEEDS_INVESTIGATION
```

### 8.4 Self-Administered vs. Insurer-Administered

| Feature | Self-Administered | Insurer-Administered |
|---------|-------------------|---------------------|
| **Bill Generation** | Employer generates own schedule | Carrier generates detailed bill |
| **Payment** | Employer remits lump sum | Employer pays per bill |
| **Enrollment Updates** | Employer sends periodic file | Carrier maintains enrollment |
| **Reconciliation** | More complex — employer's records may not match | Carrier's records are authoritative |
| **Common For** | Large groups (500+ lives) | Small to mid-size groups |

### 8.5 Premium Waiver for Disabled Members

When a group member becomes disabled:

| Provision | Description |
|-----------|-------------|
| **Waiver of Premium** | Premium waived during disability; coverage continues |
| **Premium Payment** | Employer stops paying premium for disabled member |
| **Billing Adjustment** | Carrier removes disabled member from list bill |
| **Duration** | Typically for the duration of disability, up to a maximum age (e.g., 65) |
| **Evidence** | Proof of disability required; periodic re-certification |

---

## 9. Premium Accounting

### 9.1 Premium Receivable Tracking

The PAS must maintain a detailed premium receivable ledger:

```json
{
  "premiumReceivable": {
    "policyNumber": "LIF-2024-00012345",
    "asOfDate": "2025-04-15",
    "entries": [
      {
        "dueDate": "2025-04-15",
        "premiumType": "MODAL_PREMIUM",
        "grossAmount": 210.00,
        "dividendOffset": 0.00,
        "netAmountDue": 210.00,
        "amountReceived": 0.00,
        "balance": 210.00,
        "status": "DUE",
        "agingBucket": "CURRENT"
      },
      {
        "dueDate": "2025-03-15",
        "premiumType": "MODAL_PREMIUM",
        "grossAmount": 210.00,
        "dividendOffset": 0.00,
        "netAmountDue": 210.00,
        "amountReceived": 210.00,
        "balance": 0.00,
        "status": "PAID",
        "paymentDate": "2025-03-12",
        "agingBucket": null
      }
    ],
    "totalOutstanding": 210.00,
    "agingSummary": {
      "current": 210.00,
      "past30": 0.00,
      "past60": 0.00,
      "past90": 0.00,
      "past90Plus": 0.00
    }
  }
}
```

### 9.2 Earned vs. Unearned Premium

**Earned Premium:**
Premium recognized as revenue for the coverage period that has elapsed.

**Unearned Premium:**
Premium received but not yet earned, representing future coverage.

```pseudocode
function calculateEarnedPremium(policy, asOfDate):
    for each premiumPayment in policy.premiumPayments:
        coverageStartDate = premiumPayment.coveragePeriodStart
        coverageEndDate = premiumPayment.coveragePeriodEnd
        totalDays = daysBetween(coverageStartDate, coverageEndDate)

        if asOfDate >= coverageEndDate:
            earnedDays = totalDays
        elif asOfDate >= coverageStartDate:
            earnedDays = daysBetween(coverageStartDate, asOfDate)
        else:
            earnedDays = 0

        earnedPortion = premiumPayment.amount * (earnedDays / totalDays)
        unearnedPortion = premiumPayment.amount - earnedPortion

        premiumPayment.earnedPremium = earnedPortion
        premiumPayment.unearnedPremium = unearnedPortion
```

### 9.3 Premium Income Recognition

**GAAP vs. Statutory Accounting:**

| Aspect | GAAP (ASC 944) | Statutory (SAP) |
|--------|---------------|-----------------|
| **Recognition Timing** | Earned over coverage period | When due from policyholder |
| **Advance Premium** | Deferred revenue until earned | Premium received in advance liability |
| **Unearned Premium Reserve** | Required | Required |
| **First-Year Premium** | Partially deferred for acquisition costs | Recognized when due |

### 9.4 Fractional Premium Loading

Fractional premium loading compensates the insurer for:

1. **Lost investment income**: Premiums paid in installments are received later than annual premiums.
2. **Administrative cost**: More frequent billing increases processing costs.
3. **Lapse risk**: Monthly payers have higher lapse rates than annual payers.

**Loading Calculation:**

```
Fractional Loading = (Annualized Modal Premium - Annual Premium) / Annual Premium × 100%
```

| Mode | Typical Loading |
|------|----------------|
| Semi-Annual | 3%–5% |
| Quarterly | 5%–8% |
| Monthly (Direct) | 6%–10% |
| Monthly (PAC/EFT) | 4%–6% |

### 9.5 Premium Tax by State

Premium tax is levied by each state on premiums collected from policyholders in that state.

**Premium Tax Rate Table (Sample):**

| State | Life Premium Tax Rate | Retaliatory? |
|-------|--------------------|-------------|
| Alabama | 2.30% | Yes |
| California | 2.35% | Yes |
| Connecticut | 1.50% | Yes |
| Florida | 1.75% | Yes |
| Illinois | 0.50% (domestic) / 2.00% (foreign) | Yes |
| Massachusetts | 2.00% | Yes |
| New York | 1.50% (0.8% for certain) | Yes |
| Ohio | 1.40% | Yes |
| Texas | 1.75% | Yes |
| Wyoming | 0.75% | Yes |

**Retaliatory Tax:**
If State A charges a higher tax rate on State B domiciled companies than State B charges on State A domiciled companies, State B will charge the higher State A rate (retaliation). The PAS must track the domicile state of the insurer and calculate the applicable retaliatory rate.

### 9.6 DAC Tax Tracking

Deferred Acquisition Cost (DAC) tax under IRC §848 requires life insurance companies to capitalize a portion of acquisition costs related to premiums:

| Premium Category | DAC Capitalization Rate |
|-----------------|------------------------|
| Life insurance premiums | 7.7% (reduced from prior rates per TCJA 2017) |
| Annuity premiums | 1.75% |
| Group life premiums | 2.05% |

### 9.7 Reinsurance Premium Cession

For policies with reinsurance, a portion of the premium is ceded to the reinsurer.

```pseudocode
function calculateReinsurancePremium(policy, grossPremium):
    reinsuranceAgreements = getReinsuranceAgreements(policy)

    for agreement in reinsuranceAgreements:
        if agreement.type == "QUOTA_SHARE":
            cededPremium = grossPremium * agreement.cessionPercent
        elif agreement.type == "SURPLUS":
            retainedAmount = min(policy.faceAmount, agreement.retentionLimit)
            cededAmount = policy.faceAmount - retainedAmount
            cededPremium = grossPremium * (cededAmount / policy.faceAmount)
        elif agreement.type == "YRT":
            cededNAR = policy.netAmountAtRisk * agreement.cessionPercent
            yrtRate = agreement.rateTable.getRate(policy.attainedAge, policy.riskClass)
            cededPremium = (cededNAR / 1000) * yrtRate

        // Apply ceding commission
        cedingCommission = cededPremium * agreement.cedingCommissionRate
        netCededPremium = cededPremium - cedingCommission

        recordCession(policy, agreement, cededPremium, cedingCommission, netCededPremium)
```

---

## 10. Flexible Premium (UL/VUL/IUL)

### 10.1 Target Premium

The target premium is a suggested premium level that provides an acceptable level of coverage and value accumulation. It is not a contractual requirement but serves as a benchmark.

**Target Premium Uses:**

| Use | Description |
|-----|-------------|
| **Commission basis** | Target premium often determines the first-year commission rate |
| **Illustration basis** | Target is the default premium shown in policy illustrations |
| **Billing prompt** | Used as the default billing amount |
| **7702 reference** | Typically set near the guideline annual premium |

### 10.2 Minimum Premium

The minimum premium for UL products is the smallest amount needed to keep the policy in force for the current month.

```pseudocode
function calculateMinimumPremium(policy):
    // Monthly deductions
    coi = calculateCOI(policy)
    expenseCharge = calculateExpenseCharge(policy)
    riderCharges = calculateRiderCharges(policy)
    totalMonthlyDeduction = coi + expenseCharge + riderCharges

    // If current account value covers deductions, minimum premium = $0
    if policy.accountValue >= totalMonthlyDeduction:
        return 0.00
    else:
        return totalMonthlyDeduction - policy.accountValue
```

### 10.3 No-Lapse Premium

The no-lapse premium is the cumulative premium amount that must be paid to maintain the no-lapse guarantee.

**No-Lapse Guarantee Testing:**

```pseudocode
function testNoLapseGuarantee(policy):
    // Shadow account tracks no-lapse premium sufficiency
    cumulativePremiumsPaid = sumAllPremiums(policy, sinceIssue=True)
    cumulativeNoLapsePremiumRequired = policy.noLapseTable.getCumulativeRequired(
        policyYear = currentPolicyYear(policy)
    )

    if cumulativePremiumsPaid >= cumulativeNoLapsePremiumRequired:
        return NO_LAPSE_ACTIVE
    else:
        // Check catch-up provision
        shortfall = cumulativeNoLapsePremiumRequired - cumulativePremiumsPaid
        if shortfall <= policy.noLapseCatchUpLimit:
            sendNotice(policy, "NO_LAPSE_CATCH_UP_REQUIRED", shortfall)
            return NO_LAPSE_AT_RISK
        else:
            return NO_LAPSE_EXPIRED
```

### 10.4 Planned Periodic Premium

The planned periodic premium (PPP) is the amount the policyholder commits to pay on a regular schedule.

```json
{
  "plannedPeriodicPremium": {
    "policyNumber": "UL-2024-00098765",
    "annualAmount": 6000.00,
    "mode": "MONTHLY",
    "modalAmount": 500.00,
    "billingMethod": "EFT",
    "draftDay": 15,
    "premiumAllocation": [
      { "fundCode": "FIXED", "percent": 60.0 },
      { "fundCode": "SPIDX", "percent": 40.0 }
    ],
    "effectiveDate": "2024-01-15",
    "lastChangeDate": "2024-12-01"
  }
}
```

### 10.5 Unscheduled Additional Premium

Unscheduled additional premiums are ad-hoc payments above the planned premium.

**Processing Rules:**

1. **Section 7702 Test**: Verify the additional premium does not cause the policy to fail the guideline premium test.
2. **MEC Test**: Verify the additional premium does not cause the policy to become a Modified Endowment Contract (exceed the 7-pay test limit).
3. **Premium Allocation**: Apply per the current premium allocation percentages (unless the policyholder directs otherwise).
4. **Commission**: Excess/additional premiums may earn different commission rates than target premiums.

### 10.6 Guideline Premium Test (Section 7702)

The guideline premium test establishes maximum premiums to qualify as life insurance:

```pseudocode
function guidelinePremiumTest(policy, newPremium):
    // Calculate cumulative premiums including the new payment
    cumulativePremiums = policy.totalPremiumsPaid + newPremium

    // Guideline Single Premium (GSP) — maximum single premium
    gsp = calculateGSP(
        deathBenefit = policy.deathBenefit,
        issueAge = policy.issueAge,
        gender = policy.gender,
        riskClass = policy.riskClass,
        guaranteedInterestRate = policy.guaranteedInterestRate,
        mortalityTable = policy.mortalityTable  // Typically 2001 CSO or 2017 CSO
    )

    // Guideline Annual Premium (GAP) — level annual premium
    gap = calculateGAP(
        deathBenefit = policy.deathBenefit,
        issueAge = policy.issueAge,
        gender = policy.gender,
        riskClass = policy.riskClass,
        guaranteedInterestRate = policy.guaranteedInterestRate,
        mortalityTable = policy.mortalityTable,
        endowmentAge = 100  // or 121 per 2017 CSO
    )

    // Cumulative GAP limit
    policyYears = yearsSinceIssue(policy)
    cumulativeGAPLimit = gap * policyYears

    // Test
    if cumulativePremiums > gsp:
        return FAILS_GSP  // Critical — policy cannot qualify as life insurance
    elif cumulativePremiums > cumulativeGAPLimit:
        return EXCEEDS_GAP  // Need to increase death benefit or refund excess
    else:
        return WITHIN_LIMITS
```

### 10.7 Section 7702A MEC Test

```pseudocode
function mecTest(policy, newPremium):
    sevenPayPremium = calculate7PayPremium(
        deathBenefit = policy.currentDeathBenefit,
        issueAge = policy.issueAge,
        gender = policy.gender,
        riskClass = policy.riskClass,
        riders = policy.riders
    )

    // Determine current 7-pay testing period
    currentPeriod = get7PayPeriod(policy)

    // Sum premiums in current testing period
    periodPremiums = sumPremiums(policy, since=currentPeriod.startDate) + newPremium

    // Cumulative limit
    yearsInPeriod = yearsSince(currentPeriod.startDate)
    cumulativeLimit = sevenPayPremium * min(yearsInPeriod, 7)

    if periodPremiums > cumulativeLimit:
        return MEC_VIOLATION
    else:
        return WITHIN_7PAY_LIMIT
```

### 10.8 Over-Funding Prevention

The PAS must prevent premium payments that would disqualify the policy:

```mermaid
flowchart TD
    A[Premium Payment Received] --> B[Calculate Total Premiums YTD]
    B --> C{Exceeds Guideline Annual Premium?}
    C -->|No| D{Exceeds 7-Pay Limit?}
    D -->|No| E[Accept Premium]
    D -->|Yes| F{Already MEC?}
    F -->|Yes| G[Accept Premium - Already MEC]
    F -->|No| H[Alert: Will Become MEC]
    H --> I{Owner Consents to MEC?}
    I -->|Yes| J[Accept Premium - Mark as MEC]
    I -->|No| K[Return Excess Premium]
    C -->|Yes| L{Can Increase DB to Maintain Corridor?}
    L -->|Yes| M[Increase DB + Accept Premium]
    L -->|No| N[Reject Excess Premium]
    E --> O[Apply to Policy]
    G --> O
    J --> O
    M --> O
```

---

## 11. Dunning and Collection

### 11.1 Payment Reminder Sequence

**Dunning Timeline:**

| Day | Action | Channel |
|-----|--------|---------|
| T − 30 | Premium bill generated | Paper/Email |
| T − 10 | Payment reminder | Email/SMS |
| T (Due Date) | Premium due | — |
| T + 5 | First reminder: "Payment Past Due" | Email |
| T + 10 | Second reminder: "Urgent — Premium Past Due" | Paper + Email |
| T + 15 | Grace period warning: "Policy at Risk" | Paper (certified in some states) |
| T + 25 | Final notice: "Policy Will Lapse in X Days" | Paper (certified) |
| T + 31 | Policy lapses | Lapse notice mailed |
| T + 45 | Reinstatement offer | Paper + Email |
| T + 90 | Collection review | Internal |

### 11.2 Final Notice

The final lapse notice must comply with state-specific requirements:

| State | Requirement | Timing |
|-------|-------------|--------|
| **New York (Reg 68)** | Notice to owner AND any assignee of record; must specify amount due, due date, and consequences | At least 15 days before lapse |
| **Connecticut** | Written notice to insured and any assignee | 30 days before termination |
| **California** | Notice of pending lapse | 30 days before lapse for seniors |
| **Illinois** | Designation of person (for age 60+) who must also receive notice | Before lapse |
| **Florida** | Notice of premium delinquency | Before lapse |

### 11.3 Lapse Notice Requirements

After the policy lapses, the carrier must send a lapse notification:

**Lapse Notice Content:**

- Policy has lapsed effective [date]
- Non-forfeiture option elected (if applicable)
- Cash surrender value available (if applicable)
- Reinstatement provisions and deadlines
- Evidence of insurability requirements for reinstatement
- Contact information for questions

### 11.4 Reinstatement Offers

Post-lapse reinstatement offers encourage lapsed policyholders to reactivate coverage:

```json
{
  "reinstatementOffer": {
    "policyNumber": "LIF-2024-00012345",
    "lapseDate": "2025-02-15",
    "offerDate": "2025-03-01",
    "expirationDate": "2025-05-15",
    "reinstatementRequirements": {
      "backPremiumsDue": 420.00,
      "backInterest": 3.50,
      "totalAmountDue": 423.50,
      "evidenceOfInsurability": "HEALTH_STATEMENT_ONLY",
      "reinstatedEffectiveDate": "CURRENT_DATE",
      "contestabilityPeriodReset": true
    },
    "offerMessage": "Your policy lapsed on 02/15/2025. You may reinstate within 3 years by paying back premiums and providing satisfactory evidence of insurability."
  }
}
```

### 11.5 Collection Agency Referral

For policies with outstanding premium loans that exceed the cash value, or for cases where refund overpayments were not returned:

| Criterion | Rule |
|-----------|------|
| **Referral Threshold** | Debt > $500 and > 180 days outstanding |
| **Excluded Cases** | Active litigation, bankruptcy, deceased insured |
| **Agency Requirements** | Licensed in debtor's state; compliant with FDCPA |
| **Carrier Liability** | Carrier remains liable for agency's actions |

---

## 12. Entity-Relationship Model

### 12.1 Complete ERD for Billing and Payment

```mermaid
erDiagram
    POLICY ||--o{ BILLING_SCHEDULE : has
    POLICY ||--o{ PREMIUM_DUE : generates
    POLICY ||--o{ PAYMENT : receives
    POLICY ||--|| BILLING_PREFERENCE : has
    POLICY ||--o{ PAYMENT_METHOD : has
    POLICY ||--o{ PREMIUM_RECEIVABLE : tracks
    POLICY ||--o{ PREMIUM_ACCOUNTING : produces

    BILLING_SCHEDULE ||--o{ BILLING_RUN_DETAIL : processed_in
    BILLING_RUN ||--o{ BILLING_RUN_DETAIL : contains
    BILLING_RUN ||--o{ BILL : generates

    BILL ||--o{ BILL_LINE_ITEM : contains
    BILL ||--|| PREMIUM_DUE : corresponds_to

    PAYMENT ||--o{ PAYMENT_APPLICATION : split_into
    PAYMENT ||--|| PAYMENT_BATCH : part_of
    PAYMENT ||--o{ ACH_TRANSACTION : may_have
    PAYMENT ||--o{ CARD_TRANSACTION : may_have

    PAYMENT_BATCH ||--|| LOCKBOX_FILE : sourced_from

    ACH_TRANSACTION ||--o{ ACH_RETURN : may_have
    ACH_FILE ||--o{ ACH_TRANSACTION : contains

    SUSPENSE_ACCOUNT ||--o{ SUSPENSE_ENTRY : contains
    SUSPENSE_ENTRY ||--o{ MATCH_ATTEMPT : has

    LIST_BILL ||--o{ LIST_BILL_DETAIL : contains
    LIST_BILL ||--|| MASTER_POLICY : for

    PREMIUM_ACCOUNTING ||--o{ GL_ENTRY : generates
    PREMIUM_ACCOUNTING ||--o{ REINSURANCE_CESSION : generates
    PREMIUM_ACCOUNTING ||--|| PREMIUM_TAX_RECORD : generates

    GRACE_PERIOD ||--|| POLICY : for
    GRACE_PERIOD ||--o{ GRACE_NOTICE : generates

    DUNNING_SEQUENCE ||--|| POLICY : for
    DUNNING_SEQUENCE ||--o{ DUNNING_NOTICE : generates

    POLICY {
        string policy_number PK
        string product_code FK
        string status
        decimal annual_premium
        string premium_mode
        date next_premium_due_date
        boolean auto_premium_loan
    }

    BILLING_SCHEDULE {
        string schedule_id PK
        string policy_number FK
        string billing_mode
        integer billing_day
        date next_bill_date
        decimal modal_premium
        string billing_method
        boolean active
    }

    BILLING_PREFERENCE {
        string preference_id PK
        string policy_number FK
        string delivery_method
        string language
        boolean paperless_enrolled
        string email_address
    }

    PAYMENT_METHOD {
        string method_id PK
        string policy_number FK
        string method_type
        boolean is_primary
        boolean is_active
        date effective_date
        date termination_date
    }

    PREMIUM_DUE {
        string premium_due_id PK
        string policy_number FK
        date due_date
        decimal amount_due
        decimal amount_paid
        decimal balance
        string status
        string premium_type
    }

    BILL {
        string bill_id PK
        string policy_number FK
        string premium_due_id FK
        date generation_date
        date due_date
        decimal amount
        string delivery_method
        string status
        date sent_date
    }

    BILL_LINE_ITEM {
        string line_item_id PK
        string bill_id FK
        string charge_type
        string description
        decimal amount
    }

    PAYMENT {
        string payment_id PK
        string policy_number FK
        decimal amount
        date payment_date
        date received_date
        string payment_method
        string payment_source
        string reference_number
        string status
    }

    PAYMENT_APPLICATION {
        string application_id PK
        string payment_id FK
        string premium_due_id FK
        string application_type
        decimal amount
        date application_date
    }

    PAYMENT_BATCH {
        string batch_id PK
        date batch_date
        string source
        integer payment_count
        decimal total_amount
        string status
    }

    LOCKBOX_FILE {
        string file_id PK
        string lockbox_id
        date file_date
        integer record_count
        decimal total_amount
        string status
    }

    ACH_FILE {
        string file_id PK
        date creation_date
        string file_type
        string direction
        integer entry_count
        decimal total_amount
        string status
        string nacha_batch_number
    }

    ACH_TRANSACTION {
        string ach_txn_id PK
        string file_id FK
        string payment_id FK
        string routing_number
        string account_number_masked
        string account_type
        decimal amount
        date effective_date
        string trace_number
        string status
    }

    ACH_RETURN {
        string return_id PK
        string ach_txn_id FK
        string return_code
        string return_reason
        date return_date
        decimal return_amount
        string action_taken
    }

    CARD_TRANSACTION {
        string card_txn_id PK
        string payment_id FK
        string token
        string card_last_four
        string card_brand
        decimal amount
        string authorization_code
        string status
        date transaction_date
    }

    SUSPENSE_ACCOUNT {
        string account_id PK
        decimal current_balance
        date last_updated
    }

    SUSPENSE_ENTRY {
        string entry_id PK
        string account_id FK
        string payment_id FK
        decimal amount
        date entry_date
        string status
        integer aging_days
        string assigned_to
    }

    MATCH_ATTEMPT {
        string attempt_id PK
        string entry_id FK
        date attempt_date
        string method
        string result
        string matched_policy
    }

    LIST_BILL {
        string list_bill_id PK
        string master_policy_number FK
        date billing_period_start
        date billing_period_end
        date due_date
        decimal total_amount
        integer total_lives
        string status
    }

    LIST_BILL_DETAIL {
        string detail_id PK
        string list_bill_id FK
        string certificate_number
        string employee_name
        string employee_id
        decimal premium_amount
        string status
    }

    PREMIUM_RECEIVABLE {
        string receivable_id PK
        string policy_number FK
        date due_date
        decimal original_amount
        decimal balance
        string aging_bucket
        string status
    }

    PREMIUM_ACCOUNTING {
        string accounting_id PK
        string policy_number FK
        string payment_id FK
        date accounting_date
        decimal gross_premium
        decimal earned_premium
        decimal unearned_premium
        decimal premium_tax
        decimal dac_tax
    }

    GL_ENTRY {
        string entry_id PK
        string accounting_id FK
        string gl_account
        string debit_credit
        decimal amount
        date posting_date
        string description
    }

    PREMIUM_TAX_RECORD {
        string tax_record_id PK
        string policy_number FK
        string state
        integer tax_year
        decimal premium_amount
        decimal tax_rate
        decimal tax_amount
        boolean retaliatory
    }

    REINSURANCE_CESSION {
        string cession_id PK
        string policy_number FK
        string treaty_id
        decimal ceded_premium
        decimal ceding_commission
        decimal net_ceded
        date cession_date
    }

    GRACE_PERIOD {
        string grace_id PK
        string policy_number FK
        date start_date
        date end_date
        integer duration_days
        string status
        string trigger_reason
    }

    GRACE_NOTICE {
        string notice_id PK
        string grace_id FK
        string notice_type
        date generation_date
        date sent_date
        string delivery_method
        string status
    }

    DUNNING_SEQUENCE {
        string sequence_id PK
        string policy_number FK
        date start_date
        string current_step
        string status
    }

    DUNNING_NOTICE {
        string notice_id PK
        string sequence_id FK
        string notice_type
        integer step_number
        date scheduled_date
        date sent_date
        string status
    }

    BILLING_RUN {
        string run_id PK
        date run_date
        string run_type
        integer policies_processed
        decimal total_billed
        string status
        timestamp start_time
        timestamp end_time
    }

    BILLING_RUN_DETAIL {
        string detail_id PK
        string run_id FK
        string policy_number FK
        string schedule_id FK
        decimal amount_billed
        string result
    }

    MASTER_POLICY {
        string master_policy_number PK
        string group_name
        string billing_type
        string administration_type
        integer total_certificates
    }
```

---

## 13. NACHA/ACH File Format Specification

### 13.1 ACH File Structure

A NACHA ACH file consists of the following record types:

```
┌─────────────────────────────────────────┐
│ File Header Record (Type 1)             │
├─────────────────────────────────────────┤
│ Batch Header Record (Type 5)            │
├─────────────────────────────────────────┤
│   Entry Detail Record (Type 6)          │
│   Entry Detail Record (Type 6)          │
│   Entry Detail Record (Type 6)          │
│   Addenda Record (Type 7) [optional]    │
├─────────────────────────────────────────┤
│ Batch Control Record (Type 8)           │
├─────────────────────────────────────────┤
│ File Control Record (Type 9)            │
└─────────────────────────────────────────┘
```

### 13.2 Record Format Details

**File Header Record (Type 1):**

| Position | Length | Field Name | Content |
|----------|--------|-----------|---------|
| 1 | 1 | Record Type Code | "1" |
| 2–3 | 2 | Priority Code | "01" |
| 4–13 | 10 | Immediate Destination | Routing number of receiving bank |
| 14–23 | 10 | Immediate Origin | Company's routing number or IRS ID |
| 24–29 | 6 | File Creation Date | YYMMDD |
| 30–33 | 4 | File Creation Time | HHMM |
| 34 | 1 | File ID Modifier | "A"–"Z", "0"–"9" |
| 35–37 | 3 | Record Size | "094" |
| 38–39 | 2 | Blocking Factor | "10" |
| 40 | 1 | Format Code | "1" |
| 41–63 | 23 | Immediate Destination Name | Bank name |
| 64–86 | 23 | Immediate Origin Name | Company name |
| 87–94 | 8 | Reference Code | Optional |

**Batch Header Record (Type 5):**

| Position | Length | Field Name | Content |
|----------|--------|-----------|---------|
| 1 | 1 | Record Type Code | "5" |
| 2–4 | 3 | Service Class Code | "200" (mixed), "220" (credits only), "225" (debits only) |
| 5–20 | 16 | Company Name | Carrier name |
| 21–40 | 20 | Company Discretionary Data | Optional |
| 41–50 | 10 | Company Identification | Tax ID or assigned ID |
| 51–53 | 3 | Standard Entry Class Code | "PPD" (personal), "CCD" (corporate) |
| 54–63 | 10 | Company Entry Description | "PREMIUM" |
| 64–69 | 6 | Company Descriptive Date | YYMMDD |
| 70–75 | 6 | Effective Entry Date | YYMMDD |
| 76–78 | 3 | Settlement Date | Blank (filled by ACH operator) |
| 79 | 1 | Originator Status Code | "1" |
| 80–87 | 8 | Originating DFI Identification | Routing number |
| 88–94 | 7 | Batch Number | Sequential |

**Entry Detail Record (Type 6):**

| Position | Length | Field Name | Content |
|----------|--------|-----------|---------|
| 1 | 1 | Record Type Code | "6" |
| 2–3 | 2 | Transaction Code | "27" (checking debit), "37" (savings debit) |
| 4–11 | 8 | Receiving DFI Identification | Bank routing (first 8 digits) |
| 12 | 1 | Check Digit | 9th digit of routing number |
| 13–29 | 17 | DFI Account Number | Policyholder's account number |
| 30–39 | 10 | Amount | In cents (e.g., 0000021000 = $210.00) |
| 40–54 | 15 | Individual Identification Number | Policy number |
| 55–76 | 22 | Individual Name | Policyholder name |
| 77–78 | 2 | Discretionary Data | Optional |
| 79 | 1 | Addenda Record Indicator | "0" (no addenda) or "1" (has addenda) |
| 80–94 | 15 | Trace Number | Unique identifier |

### 13.3 Sample NACHA File

```
101 021000089 123456789 2503150800A094101FIRST NATIONAL BANK    ACME LIFE INSURANCE CO  REF00001
5225ACME LIFE INS CO                    1234567890PPDPREMIUM   250315250317   1021000080000001
627021000089 12345678901234   0000021000LIF202400012345     SMITH JOHN A            00021000080000001
627021000089 98765432101234   0000035000LIF202400054321     DOE JANE B              00021000080000002
627031000053 55555666677777   0000015000LIF202400098765     JONES ROBERT C          00031000050000003
82250000030052000142000000000710000000000000001234567890                    021000080000001
9000001000001000000030052000142000000000710000000000000
```

### 13.4 ACH Return File Processing

Return files follow the same format but include addenda records with return reason codes:

```
101 123456789 021000089 2503180800A094101ACME LIFE INSURANCE CO  FIRST NATIONAL BANK    REF00001
5225ACME LIFE INS CO                    1234567890PPDPREMIUM   250315250317   1021000080000001
626021000089 12345678901234   0000021000LIF202400012345     SMITH JOHN A            10021000080000001
799R01021000080000001                                                           0021000080000001
82250000020021000089000000000210000000000000001234567890                    021000080000001
9000001000001000000020021000089000000000210000000000000
```

The addenda record (Type 7, starting with "799") contains:
- Positions 4–6: Return Reason Code (e.g., "R01")
- Positions 7–21: Original trace number
- Positions 22–79: Additional return information

---

## 14. ACORD Billing-Related Messages

### 14.1 ACORD Transaction Types for Billing

| ACORD Transaction | tc Code | Description |
|-------------------|---------|-------------|
| `OLI_TRANS_PREMIUMPAY` | tc="505" | Premium Payment |
| `OLI_TRANS_CHGBILLING` | tc="511" | Billing Change |
| `OLI_TRANS_BILLINQUIRY` | tc="554" | Billing Inquiry |
| `OLI_TRANS_PREMIUMDUENOTICE` | tc="556" | Premium Due Notice |
| `OLI_TRANS_GRACEPERIODNOTICE` | tc="558" | Grace Period Notice |

### 14.2 Sample ACORD Premium Payment Message

```xml
<?xml version="1.0" encoding="UTF-8"?>
<TXLife xmlns="http://ACORD.org/Standards/Life/2" Version="2.43.00">
  <TXLifeRequest>
    <TransRefGUID>TXN-2025-PREM-00099999</TransRefGUID>
    <TransType tc="505">Premium Payment</TransType>
    <TransExeDate>2025-03-15</TransExeDate>
    <OLifE>
      <Holding id="Holding_1">
        <Policy>
          <PolNumber>LIF-2024-00012345</PolNumber>
          <Life>
            <Premium>
              <PaymentAmt>210.00</PaymentAmt>
              <PaymentMode tc="4">Monthly</PaymentMode>
              <PaymentMethod tc="7">EFT/PAC</PaymentMethod>
              <PaymentDueDate>2025-03-15</PaymentDueDate>
              <BankHoldingInfo>
                <RoutingTransitNum>021000089</RoutingTransitNum>
                <AccountNumber>****5678</AccountNumber>
                <AcctHolderName>John A. Smith</AcctHolderName>
                <BankAcctType tc="1">Checking</BankAcctType>
              </BankHoldingInfo>
            </Premium>
          </Life>
        </Policy>
      </Holding>
    </OLifE>
  </TXLifeRequest>
</TXLife>
```

### 14.3 Sample ACORD Billing Change Message

```xml
<?xml version="1.0" encoding="UTF-8"?>
<TXLife xmlns="http://ACORD.org/Standards/Life/2" Version="2.43.00">
  <TXLifeRequest>
    <TransRefGUID>TXN-2025-BILL-00088888</TransRefGUID>
    <TransType tc="511">Billing Change</TransType>
    <TransExeDate>2025-04-01</TransExeDate>
    <ChangeSubType tc="1">Billing Mode Change</ChangeSubType>
    <OLifE>
      <Holding id="Holding_1">
        <Policy>
          <PolNumber>LIF-2024-00012345</PolNumber>
          <Life>
            <Premium>
              <PaymentMode tc="4">Monthly</PaymentMode>
              <PaymentMethod tc="7">EFT/PAC</PaymentMethod>
              <ModalPremAmt>210.00</ModalPremAmt>
            </Premium>
          </Life>
        </Policy>
      </Holding>
      <Holding id="Holding_1_Prior">
        <Policy>
          <PolNumber>LIF-2024-00012345</PolNumber>
          <Life>
            <Premium>
              <PaymentMode tc="2">Quarterly</PaymentMode>
              <PaymentMethod tc="2">Direct Bill</PaymentMethod>
              <ModalPremAmt>636.00</ModalPremAmt>
            </Premium>
          </Life>
        </Policy>
      </Holding>
    </OLifE>
  </TXLifeRequest>
</TXLife>
```

---

## 15. Architecture

### 15.1 Billing Engine Architecture

```mermaid
graph TB
    subgraph "Billing Engine"
        BM[Billing Manager]
        BG[Bill Generator]
        PS[Payment Scheduler]
        PE[Premium Calculator]
        TM[Tolerance Manager]
    end

    subgraph "Payment Gateway Integration"
        PGW[Payment Gateway Adapter]
        ACH_P[ACH Processor]
        CC_P[Card Processor]
        LBX[Lockbox Processor]
    end

    subgraph "Reconciliation Engine"
        RE[Reconciliation Manager]
        PM[Payment Matcher]
        SA[Suspense Account Manager]
        EH[Exception Handler]
    end

    subgraph "External Systems"
        NACHA[NACHA/ACH Network]
        STRIPE[Card Network]
        LBOX[Lockbox Bank]
        PRINT[Print Vendor]
        EMAIL[Email Service]
    end

    subgraph "Data Stores"
        BDB[(Billing DB)]
        PDB[(Payment DB)]
        SDB[(Suspense DB)]
        GL[(General Ledger)]
    end

    subgraph "Event Bus"
        KAFKA[Apache Kafka]
    end

    BM --> BG
    BM --> PS
    BM --> PE
    BM --> TM

    PGW --> ACH_P
    PGW --> CC_P
    PGW --> LBX

    ACH_P --> NACHA
    CC_P --> STRIPE
    LBX --> LBOX

    RE --> PM
    RE --> SA
    RE --> EH

    BG --> BDB
    BG --> PRINT
    BG --> EMAIL
    PS --> PGW
    PM --> PDB
    SA --> SDB
    RE --> GL

    BM --> KAFKA
    PGW --> KAFKA
    RE --> KAFKA
```

### 15.2 Payment Gateway Integration

**Payment Gateway Adapter Pattern:**

```pseudocode
interface PaymentGateway:
    function initiatePayment(paymentRequest) -> PaymentResult
    function checkPaymentStatus(transactionId) -> PaymentStatus
    function processRefund(refundRequest) -> RefundResult
    function handleReturn(returnRecord) -> ReturnResult

class ACHGateway implements PaymentGateway:
    function initiatePayment(request):
        achEntry = createACHEntry(request)
        addToBatch(achEntry)
        return PendingResult(achEntry.traceNumber)

    function handleReturn(returnRecord):
        originalPayment = lookupByTraceNumber(returnRecord.originalTrace)
        processReturn(originalPayment, returnRecord.returnCode)
        return ReturnResult(returnRecord)

class CardGateway implements PaymentGateway:
    function initiatePayment(request):
        token = request.paymentToken
        authResult = stripeClient.charge(token, request.amount)
        if authResult.approved:
            return ApprovedResult(authResult.transactionId)
        else:
            return DeclinedResult(authResult.declineCode)
```

### 15.3 Reconciliation Engine

The reconciliation engine ensures that all premiums billed, collected, and applied are in balance.

**Daily Reconciliation Process:**

```mermaid
flowchart TD
    A[Start Daily Reconciliation] --> B[Gather All Payments Received Today]
    B --> C[Gather All Payments Applied Today]
    C --> D[Gather All Reversals/Returns Today]
    D --> E[Calculate Balances]
    E --> F{Payments = Applications + Suspense + Returns?}
    F -->|Yes| G[Reconciliation Balanced]
    F -->|No| H[Investigate Discrepancy]
    H --> I[Generate Exception Report]
    G --> J[Post to General Ledger]
    J --> K[Generate Reconciliation Report]
    I --> K
    K --> L[Archive Daily Records]
```

**Reconciliation Checkpoints:**

| Checkpoint | Verification |
|-----------|-------------|
| **Cash Receipts** | Total deposited = Total in payment system |
| **Payment Application** | Total applied = Total to individual policies |
| **Suspense** | Opening balance + additions - resolutions = Closing balance |
| **Premium Receivable** | Billed - Collected - Waivers = Outstanding |
| **GL Balance** | Premium income account = Sum of applied premiums |

---

## 16. Batch Job Design for Billing Cycles

### 16.1 Batch Job Architecture

```mermaid
graph TB
    subgraph "Job Scheduler (Apache Airflow / Control-M)"
        SCH[Job Scheduler]
    end

    subgraph "Billing Batch Jobs"
        J1[Bill Generation Job]
        J2[ACH File Generation Job]
        J3[Payment Application Job]
        J4[ACH Return Processing Job]
        J5[Grace Period Processing Job]
        J6[Lapse Processing Job]
        J7[Reconciliation Job]
        J8[Dunning Job]
        J9[Suspense Aging Job]
        J10[Premium Accounting Job]
    end

    subgraph "Monitoring"
        MON[Job Monitor Dashboard]
        ALERT[Alerting System]
    end

    SCH --> J1
    SCH --> J2
    SCH --> J3
    SCH --> J4
    SCH --> J5
    SCH --> J6
    SCH --> J7
    SCH --> J8
    SCH --> J9
    SCH --> J10

    J1 --> MON
    J2 --> MON
    J3 --> MON
    J7 --> MON
    MON --> ALERT
```

### 16.2 Batch Job Specifications

**Job 1: Bill Generation**

```json
{
  "jobName": "BILL_GENERATION",
  "schedule": "DAILY_0100",
  "description": "Generate bills for all policies with upcoming due dates",
  "steps": [
    {
      "step": 1,
      "name": "IDENTIFY_POLICIES",
      "query": "SELECT * FROM billing_schedule WHERE next_bill_date <= CURRENT_DATE + advance_days AND active = true",
      "estimatedRecords": 50000,
      "timeout": "30min"
    },
    {
      "step": 2,
      "name": "CALCULATE_PREMIUMS",
      "action": "For each policy, calculate modal premium including any adjustments (dividend offset, rider changes, modal factor changes)",
      "parallelism": 10,
      "timeout": "60min"
    },
    {
      "step": 3,
      "name": "GENERATE_BILLS",
      "action": "Create bill records, generate print-ready documents or email templates",
      "timeout": "45min"
    },
    {
      "step": 4,
      "name": "TRANSMIT_BILLS",
      "action": "Send paper bills to print vendor; send email notices; queue bills for portal display",
      "timeout": "30min"
    },
    {
      "step": 5,
      "name": "UPDATE_SCHEDULES",
      "action": "Advance next_bill_date for each processed billing schedule",
      "timeout": "15min"
    }
  ],
  "errorHandling": {
    "policyLevelFailure": "SKIP_AND_LOG",
    "systemFailure": "HALT_AND_ALERT",
    "retryPolicy": {
      "maxRetries": 3,
      "retryInterval": "5min"
    }
  },
  "monitoring": {
    "expectedDuration": "2h30m",
    "warningThreshold": "3h",
    "criticalThreshold": "4h",
    "successCriteria": "processedCount / expectedCount >= 0.99"
  }
}
```

**Job 2: ACH File Generation**

```json
{
  "jobName": "ACH_FILE_GENERATION",
  "schedule": "DAILY_0300",
  "dependency": "BILL_GENERATION",
  "description": "Generate NACHA-formatted ACH files for PAC/EFT payments",
  "steps": [
    {
      "step": 1,
      "name": "IDENTIFY_ACH_PAYMENTS",
      "query": "SELECT * FROM billing_schedule WHERE billing_method IN ('PAC', 'EFT') AND next_draft_date = CURRENT_DATE + 2",
      "estimatedRecords": 25000
    },
    {
      "step": 2,
      "name": "CREATE_ACH_ENTRIES",
      "action": "Build ACH entry detail records with routing numbers, account numbers, and amounts"
    },
    {
      "step": 3,
      "name": "CREATE_NACHA_FILE",
      "action": "Assemble file header, batch headers, entry details, batch controls, and file control records"
    },
    {
      "step": 4,
      "name": "VALIDATE_FILE",
      "action": "Verify hash totals, entry counts, and file format compliance"
    },
    {
      "step": 5,
      "name": "TRANSMIT_TO_ODFI",
      "action": "Securely transmit NACHA file to Originating Depository Financial Institution via SFTP"
    }
  ]
}
```

**Job 3: Payment Application**

```json
{
  "jobName": "PAYMENT_APPLICATION",
  "schedule": "DAILY_0800_1200_1600",
  "description": "Process and apply received payments from all sources",
  "steps": [
    {
      "step": 1,
      "name": "INGEST_PAYMENT_FILES",
      "sources": ["LOCKBOX", "ACH_SETTLEMENT", "CARD_SETTLEMENT", "WIRE_FEED"],
      "action": "Parse and normalize payment records from all sources"
    },
    {
      "step": 2,
      "name": "MATCH_PAYMENTS",
      "action": "Execute payment matching engine against outstanding premium receivables"
    },
    {
      "step": 3,
      "name": "APPLY_MATCHED",
      "action": "Apply matched payments to policies per application priority rules"
    },
    {
      "step": 4,
      "name": "ROUTE_UNMATCHED",
      "action": "Route unmatched payments to suspense account with match attempt details"
    },
    {
      "step": 5,
      "name": "POST_ACCOUNTING",
      "action": "Generate GL entries for all applied payments"
    }
  ]
}
```

### 16.3 Batch Job Dependency Graph

```mermaid
graph LR
    J1[Bill Generation<br/>01:00] --> J2[ACH File Gen<br/>03:00]
    J2 --> J3a[Payment App<br/>08:00]
    J3a --> J3b[Payment App<br/>12:00]
    J3b --> J3c[Payment App<br/>16:00]
    J3c --> J7[Reconciliation<br/>18:00]
    J4[ACH Return Processing<br/>10:00] --> J7
    J5[Grace Period Processing<br/>02:00] --> J6[Lapse Processing<br/>05:00]
    J6 --> J8[Dunning<br/>06:00]
    J7 --> J10[Premium Accounting<br/>20:00]
    J9[Suspense Aging<br/>07:00] --> J7
```

---

## 17. Sample Payloads

### 17.1 REST API — Generate Bill On-Demand

**Request:**

```http
POST /api/v2/billing/bills/generate
Content-Type: application/json
Authorization: Bearer eyJhbGciOiJSUzI1NiIs...

{
  "policyNumber": "LIF-2024-00012345",
  "billType": "ON_DEMAND",
  "reason": "REINSTATEMENT_BILLING",
  "premiumsDue": [
    {
      "dueDate": "2025-02-15",
      "amount": 210.00,
      "type": "BACK_PREMIUM"
    },
    {
      "dueDate": "2025-03-15",
      "amount": 210.00,
      "type": "BACK_PREMIUM"
    },
    {
      "dueDate": "2025-04-15",
      "amount": 210.00,
      "type": "CURRENT_PREMIUM"
    }
  ],
  "interestOnBackPremiums": 8.75,
  "totalAmountDue": 638.75,
  "deliveryMethod": "EMAIL"
}
```

**Response:**

```json
{
  "billId": "BILL-2025-00000789",
  "policyNumber": "LIF-2024-00012345",
  "generationDate": "2025-04-10",
  "dueDate": "2025-04-25",
  "totalAmountDue": 638.75,
  "lineItems": [
    { "description": "Back Premium - Feb 2025", "amount": 210.00 },
    { "description": "Back Premium - Mar 2025", "amount": 210.00 },
    { "description": "Current Premium - Apr 2025", "amount": 210.00 },
    { "description": "Interest on Back Premiums", "amount": 8.75 }
  ],
  "deliveryStatus": {
    "method": "EMAIL",
    "sentTo": "john.smith@email.com",
    "sentDate": "2025-04-10T08:30:00Z",
    "status": "DELIVERED"
  }
}
```

### 17.2 Kafka Event — Payment Applied

```json
{
  "eventId": "EVT-2025-PAY-00000456",
  "eventType": "PREMIUM_PAYMENT_APPLIED",
  "eventTimestamp": "2025-03-15T14:30:00.000Z",
  "source": "payment-application-engine",
  "policyNumber": "LIF-2024-00012345",
  "paymentId": "PAY-2025-00000789",
  "details": {
    "paymentAmount": 210.00,
    "paymentMethod": "PAC",
    "paymentDate": "2025-03-15",
    "applications": [
      {
        "type": "MODAL_PREMIUM",
        "premiumDueDate": "2025-03-15",
        "amount": 210.00
      }
    ],
    "premiumStatus": {
      "nextDueDate": "2025-04-15",
      "nextAmountDue": 210.00,
      "paidToDate": "2025-04-14"
    }
  }
}
```

---

## 18. Appendices

### Appendix A: Premium Mode Factor Reference

| Product Type | Annual | Semi-Annual | Quarterly | Monthly (Direct) | Monthly (PAC) |
|-------------|--------|-------------|-----------|-------------------|---------------|
| Term 10 | 1.000 | 0.520 | 0.265 | 0.090 | 0.0875 |
| Term 20 | 1.000 | 0.520 | 0.265 | 0.090 | 0.0875 |
| Term 30 | 1.000 | 0.520 | 0.265 | 0.090 | 0.0875 |
| Whole Life | 1.000 | 0.515 | 0.262 | 0.088 | 0.0860 |
| UL (Target) | 1.000 | 0.520 | 0.265 | 0.090 | 0.0875 |
| VUL (Target) | 1.000 | 0.520 | 0.265 | 0.090 | 0.0875 |

### Appendix B: ACH Return Code Complete Reference

| Code | Description | Time Limit | Retry? |
|------|-------------|-----------|--------|
| R01 | Insufficient Funds | 2 banking days | Yes (max 2) |
| R02 | Account Closed | 2 banking days | No |
| R03 | No Account/Unable to Locate | 2 banking days | No |
| R04 | Invalid Account Number Structure | 2 banking days | No |
| R05 | Unauthorized Debit to Consumer Account | 60 calendar days | No |
| R06 | Returned per ODFI's Request | 2 banking days | Case-by-case |
| R07 | Authorization Revoked by Customer | 60 calendar days | No |
| R08 | Payment Stopped | 2 banking days | No |
| R09 | Uncollected Funds | 2 banking days | Yes |
| R10 | Customer Advises Unauthorized | 60 calendar days | No |
| R11 | Check Truncation Entry Return | 2 banking days | No |
| R12 | Branch Sold to Another DFI | 2 banking days | No |
| R13 | Invalid ACH Routing Number | 2 banking days | No |
| R14 | Representative Payee Deceased | 2 banking days | No |
| R15 | Beneficiary or Account Holder Deceased | 2 banking days | No |
| R16 | Account Frozen | 2 banking days | No |
| R17 | File Record Edit Criteria | 2 banking days | No |
| R20 | Non-Transaction Account | 2 banking days | No |
| R21 | Invalid Company Identification | 2 banking days | No |
| R22 | Invalid Individual ID Number | 2 banking days | No |
| R23 | Credit Entry Refused by Receiver | 2 banking days | No |
| R24 | Duplicate Entry | 2 banking days | No |
| R29 | Corporate Customer Advises Not Authorized | 2 banking days | No |

### Appendix C: Billing Metrics & KPIs

| KPI | Target | Measurement |
|-----|--------|-------------|
| **STP Rate** | > 95% | Payments auto-applied / Total payments |
| **Suspense Rate** | < 3% | Payments to suspense / Total payments |
| **Suspense Aging** | < 5 days average | Average days items remain in suspense |
| **ACH Return Rate** | < 2% | ACH returns / Total ACH originations |
| **Collection Rate** | > 97% | Premiums collected / Premiums billed |
| **Lapse Rate (Billing-related)** | < 3% | Lapses due to non-payment / Total in-force |
| **Bill Generation SLA** | 100% | Bills generated on time per schedule |
| **Payment Processing SLA** | 99.9% | Payments processed same day received |
| **Reconciliation Balance** | 100% | Daily reconciliation balanced without exceptions |

### Appendix D: Glossary

| Term | Definition |
|------|-----------|
| **CARES Act** | Coronavirus Aid, Relief, and Economic Security Act — emergency legislation providing premium relief |
| **DAC Tax** | Deferred Acquisition Cost tax — IRC §848 requirement to capitalize acquisition costs |
| **EFT** | Electronic Funds Transfer — generic term for electronic payment |
| **GAP** | Guideline Annual Premium — Section 7702 annual premium limit |
| **GSP** | Guideline Single Premium — Section 7702 single premium limit |
| **Lockbox** | Bank-operated facility for receiving and processing check payments |
| **MEC** | Modified Endowment Contract — policy failing the 7-pay test |
| **Modal Premium** | Premium amount due per billing period (annual, semi-annual, quarterly, monthly) |
| **NACHA** | National Automated Clearing House Association — governs ACH network |
| **NIGO** | Not In Good Order — incomplete transaction |
| **ODFI** | Originating Depository Financial Institution — bank initiating ACH transactions |
| **PAC** | Pre-Authorized Check — recurring bank draft authorization |
| **PCI-DSS** | Payment Card Industry Data Security Standard |
| **PPD** | Prearranged Payment and Deposit — ACH entry class for consumer accounts |
| **RDFI** | Receiving Depository Financial Institution — bank receiving ACH transactions |
| **SCRA** | Servicemembers Civil Relief Act — military payment protections |
| **Suspense** | Holding account for unmatched or unidentified payments |

### Appendix E: References

1. **NACHA Operating Rules** (2025 Edition): Rules governing ACH payment processing
2. **PCI-DSS v4.0**: Payment Card Industry Data Security Standard
3. **IRC §7702**: Life Insurance Contract Defined
4. **IRC §7702A**: Modified Endowment Contract Defined
5. **IRC §848**: Capitalization of Certain Policy Acquisition Expenses
6. **ACORD TXLife Standard**: Version 2.43.00 — Billing-related message types
7. **NAIC Model #613**: Life Insurance and Annuities Replacement Model Regulation
8. **E-SIGN Act (15 U.S.C. §7001)**: Electronic signatures and records
9. **UETA**: Uniform Electronic Transactions Act (state-level adoption)
10. **SCRA (50 U.S.C. §3901)**: Servicemembers Civil Relief Act
11. **FDCPA (15 U.S.C. §1692)**: Fair Debt Collection Practices Act
12. **Gramm-Leach-Bliley Act**: Financial privacy requirements

---

*This article is part of the Life Insurance PAS Architect's Encyclopedia. For related topics, see Article 11 (In-Force Policy Servicing) and Article 13 (Policy Lapse, Reinstatement & Non-Forfeiture).*
