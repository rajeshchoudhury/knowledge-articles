# Article 13: Policy Lapse, Reinstatement & Non-Forfeiture

## Table of Contents

1. [Introduction & Scope](#1-introduction--scope)
2. [Lapse Processing](#2-lapse-processing)
3. [Non-Forfeiture Options](#3-non-forfeiture-options)
4. [Cash Surrender Processing](#4-cash-surrender-processing)
5. [Extended Term Insurance (ETI)](#5-extended-term-insurance-eti)
6. [Reduced Paid-Up Insurance (RPU)](#6-reduced-paid-up-insurance-rpu)
7. [Reinstatement](#7-reinstatement)
8. [Automatic Premium Loan (APL)](#8-automatic-premium-loan-apl)
9. [UL-Specific Lapse Mechanics](#9-ul-specific-lapse-mechanics)
10. [State-Specific Requirements](#10-state-specific-requirements)
11. [Entity-Relationship Model](#11-entity-relationship-model)
12. [State Decision Matrix](#12-state-decision-matrix)
13. [BPMN Process Flows](#13-bpmn-process-flows)
14. [Calculation Examples with Real Numbers](#14-calculation-examples-with-real-numbers)
15. [Architecture](#15-architecture)
16. [Sample Payloads](#16-sample-payloads)
17. [Appendices](#17-appendices)

---

## 1. Introduction & Scope

Policy lapse, reinstatement, and non-forfeiture processing represent the critical safety net of a life insurance Policy Administration System (PAS). These mechanisms protect both the policyholder's accumulated value and the insurer's contractual obligations when premium payments cease. The Standard Nonforfeiture Law, adopted in some form by all 50 states, mandates minimum benefits that must be available to policyholders who stop paying premiums on policies with cash value.

### 1.1 Scope

This article covers the end-to-end lifecycle from premium non-payment through policy termination or reinstatement:

```mermaid
graph LR
    A[Premium Due] --> B{Payment Received?}
    B -->|Yes| C[Policy Continues In-Force]
    B -->|No| D[Grace Period Begins]
    D --> E{Payment During Grace?}
    E -->|Yes| C
    E -->|No| F{APL Available?}
    F -->|Yes| G[APL Activated]
    G --> C
    F -->|No| H{Cash Value > 0?}
    H -->|Yes| I[Non-Forfeiture Option Elected]
    H -->|No| J[Policy Terminates - No Value]
    I --> K[ETI / RPU / Cash Surrender]
    J --> L[Reinstatement Window Opens]
    K --> L
```

### 1.2 Key Regulatory Framework

| Regulation | Description | Impact |
|-----------|-------------|--------|
| **Standard Nonforfeiture Law (NAIC Model #808)** | Establishes minimum cash values and nonforfeiture benefits | Mandates ETI/RPU/CSV calculations |
| **IRC §72** | Taxation of distributions from life insurance | Governs tax treatment of surrenders |
| **IRC §7702** | Definition of life insurance | Affects how cash values are structured |
| **IRC §7702A** | Modified Endowment Contract | Affects taxation of surrenders from MECs |
| **State Insurance Codes** | State-specific grace period and notice requirements | Varies by jurisdiction |
| **SCRA (50 U.S.C. §3901)** | Servicemembers Civil Relief Act | Extended protections for military |
| **NAIC Model #613** | Replacement regulation | Affects reinstatement vs. replacement decisions |

### 1.3 Key Terminology

| Term | Definition |
|------|-----------|
| **Lapse** | Termination of a policy due to non-payment of premium |
| **Grace Period** | Period after premium due date during which policy remains in force |
| **Non-Forfeiture Option** | Benefit available to policyholder upon lapse of a policy with cash value |
| **Cash Surrender Value (CSV)** | Cash value minus any applicable surrender charges |
| **Extended Term Insurance (ETI)** | Non-forfeiture option providing term coverage for the full face amount for a calculated duration |
| **Reduced Paid-Up (RPU)** | Non-forfeiture option providing permanent coverage at a reduced face amount |
| **Reinstatement** | Restoration of a lapsed policy to in-force status |
| **APL** | Automatic Premium Loan — automatic loan to pay premium before lapse |
| **Shadow Account** | Tracking account for no-lapse guarantee eligibility in UL products |

---

## 2. Lapse Processing

### 2.1 Grace Period Expiration

The grace period is the contractual window following a missed premium during which the policy remains in force. When the grace period expires without premium payment, the lapse process initiates.

**Grace Period Duration by Product Type:**

| Product Type | Typical Grace Period | Statutory Minimum |
|-------------|---------------------|-------------------|
| Term Life | 31 days | 30–31 days (state dependent) |
| Whole Life | 31 days | 30–31 days |
| Universal Life | 61 days | 61 days (from first failed monthly deduction) |
| Variable Universal Life | 61 days | 61 days |
| Indexed Universal Life | 61 days | 61 days |
| Group Life | 31 days | Per certificate and state |

### 2.2 Lapse Date Determination

The lapse date is the date on which the policy terminates due to non-payment.

```pseudocode
function determineLapseDate(policy):
    productType = policy.productType

    if productType in [TERM, WHOLE_LIFE, ENDOWMENT]:
        // Traditional products: lapse at end of grace period after premium due date
        premiumDueDate = policy.lastPremiumDueDate
        gracePeriodDays = getGracePeriod(policy.stateOfIssue, productType)
        lapseDate = addDays(premiumDueDate, gracePeriodDays)

    elif productType in [UL, VUL, IUL]:
        // UL products: lapse when account value insufficient AND grace period expires
        firstFailedDeductionDate = getFirstFailedMonthlyDeduction(policy)
        if firstFailedDeductionDate is null:
            return null  // No lapse condition
        gracePeriodDays = 61  // Standard UL grace period
        lapseDate = addDays(firstFailedDeductionDate, gracePeriodDays)

    // Check for no-lapse guarantee
    if policy.hasNoLapseGuarantee():
        if isNoLapseActive(policy, lapseDate):
            return null  // No-lapse guarantee prevents lapse

    // Check for APL election
    if policy.aplElected and policy.cashSurrenderValue > 0:
        aplResult = processAPL(policy)
        if aplResult == POLICY_CONTINUES:
            return null  // APL prevents lapse

    return lapseDate
```

### 2.3 Lapse Notice Requirements (State-Specific)

Every state requires specific notices before and after lapse. Failure to provide proper notice can invalidate the lapse.

**Pre-Lapse Notice Requirements:**

| State | Notice Requirement | Timing | Recipients |
|-------|--------------------|--------|-----------|
| **New York** | Written notice of premium due and consequences of non-payment | At least 15 days before lapse; at least 21 days before for policies > 1 year in force | Owner, assignee |
| **California** | Notice of pending lapse for senior citizens (60+) | 30 days before lapse | Owner, designated person |
| **Connecticut** | Notice of impending lapse | At least 30 days before termination | Owner, assignee |
| **Illinois** | Notice to designated third party for senior policyholders (60+) | Before lapse | Owner, designated person |
| **Florida** | Notice of premium delinquency | Reasonable time before lapse | Owner |
| **Texas** | Notice of lapse and reinstatement rights | Before and after lapse | Owner, assignee |
| **New Jersey** | Notice to owner and any irrevocable beneficiary | 10 days before lapse | Owner, irrevocable beneficiary |
| **Pennsylvania** | Notice of default in premium payment | Not less than 15 days notice | Owner |

### 2.4 Lapse With Value vs. Without Value

**Lapse With Value:**
When a policy lapses and has a positive cash surrender value, the non-forfeiture options apply.

```mermaid
flowchart TD
    A[Policy Lapses] --> B{Cash Surrender Value > 0?}
    B -->|Yes - Lapse With Value| C{Non-Forfeiture Option Elected?}
    C -->|Cash Surrender| D[Pay CSV to Owner]
    C -->|Extended Term| E[Convert to ETI]
    C -->|Reduced Paid-Up| F[Convert to RPU]
    C -->|No Election| G[Apply Default Non-Forfeiture Option]
    B -->|No - Lapse Without Value| H{Term Policy?}
    H -->|Yes| I[Policy Terminates - No Benefits]
    H -->|No| J[Policy Terminates - No Residual Value]
    I --> K[Reinstatement Window Opens]
    J --> K
    D --> K
    E --> K
    F --> K
    G --> K
```

**Lapse Without Value:**
- Term life policies (no cash value accumulation)
- Universal life policies where account value has been exhausted
- Policies in the first year or two before meaningful cash value accumulates

### 2.5 Term Policy Lapse

Term policies lapse simply — there is no cash value, no non-forfeiture options, and no surrender value.

**Term Lapse Processing:**

```pseudocode
function processTermLapse(policy):
    // Validate grace period has expired
    if not isGracePeriodExpired(policy):
        return ERROR("Grace period has not expired")

    // Set policy status to lapsed
    policy.status = LAPSED
    policy.lapseDate = determineLapseDate(policy)
    policy.terminationReason = "NONPAYMENT_PREMIUM"

    // Cancel any future billing
    cancelBilling(policy)

    // Generate lapse notice
    generateLapseNotice(policy, includeReinstatementRights=true)

    // Set reinstatement window
    policy.reinstatementExpiryDate = addYears(policy.lapseDate, 
        getReinstatementPeriod(policy.stateOfIssue))

    // Update agent records
    notifyAgent(policy, "POLICY_LAPSED")

    // Accounting entries
    reversePremiumReceivable(policy)
    recordLapseInActuarialSystem(policy)
```

### 2.6 UL Policy Lapse (Monthly Deduction Failure)

UL policies lapse through a different mechanism: the monthly cost of insurance and expense deductions exhaust the account value.

**UL Monthly Deduction Sequence:**

```mermaid
flowchart TD
    A[Monthly Anniversary Date] --> B[Calculate Monthly Deductions]
    B --> C[COI + Expense Charges + Rider Charges]
    C --> D{Account Value ≥ Total Deductions?}
    D -->|Yes| E[Deduct from Account Value]
    E --> F[Policy Continues In-Force]
    D -->|No| G{No-Lapse Guarantee Active?}
    G -->|Yes| H[Policy Continues via Guarantee]
    H --> I[Deduct Available Amount Only]
    G -->|No| J{APL Elected and CSV Available?}
    J -->|Yes| K[Process APL]
    K --> L{APL Covers Deduction?}
    L -->|Yes| F
    L -->|No| M[Begin 61-Day Grace Period]
    J -->|No| M
    M --> N{Premium Received During Grace?}
    N -->|Yes| O[Apply Premium + Continue]
    N -->|No| P{Grace Period Expired?}
    P -->|No| Q[Continue Grace Period]
    Q --> N
    P -->|Yes| R[Policy Lapses]
    R --> S[Apply Non-Forfeiture Option]
```

### 2.7 VUL Lapse (Account Value Exhaustion)

Variable Universal Life adds the complexity of market-dependent account values:

```pseudocode
function processVULMonthlyDeduction(policy, deductionDate):
    // Calculate total monthly deductions
    coi = calculateCOI(policy)
    expenseCharge = calculateExpenseCharge(policy)
    riderCharges = calculateRiderCharges(policy)
    fundManagementFees = calculateFundFees(policy)  // Deducted via NAV
    totalDeduction = coi + expenseCharge + riderCharges

    // Get current account value (market value of sub-accounts + fixed account)
    currentAV = calculateTotalAccountValue(policy, deductionDate)

    if currentAV >= totalDeduction:
        // Sufficient value — deduct per fund depletion order
        deductFromFunds(policy, totalDeduction, deductionDate)
        return POLICY_IN_FORCE
    else:
        // Insufficient — check no-lapse guarantee
        if isNoLapseActive(policy):
            deductAvailable(policy, min(currentAV, totalDeduction))
            return POLICY_IN_FORCE_VIA_GUARANTEE
        else:
            // Begin grace period
            if not policy.inGracePeriod:
                startGracePeriod(policy, deductionDate)
                sendGracePeriodNotice(policy)
            return GRACE_PERIOD_ACTIVE
```

### 2.8 No-Lapse Guarantee Mechanics

No-lapse guarantees (also called secondary guarantees) keep a UL/IUL policy in force even when the account value drops to zero, provided certain premium funding requirements are met.

**No-Lapse Guarantee Testing:**

```pseudocode
function testNoLapseGuarantee(policy, testDate):
    // Method 1: Cumulative premium test
    cumulativePremiumsPaid = sumAllPremiums(policy)
    requiredCumulativePremium = policy.noLapseTable.getRequired(
        policyYear = getPolicyYear(policy, testDate)
    )

    if cumulativePremiumsPaid >= requiredCumulativePremium:
        return NO_LAPSE_ACTIVE

    // Method 2: Shadow account test (alternative)
    shadowAccountValue = calculateShadowAccount(policy, testDate)
    if shadowAccountValue > 0:
        return NO_LAPSE_ACTIVE

    return NO_LAPSE_EXPIRED

function calculateShadowAccount(policy, testDate):
    // Shadow account uses guaranteed assumptions (not actual)
    shadowValue = 0

    for each month from issue to testDate:
        // Credits: premiums paid
        shadowValue += premiumPaid(month)

        // Debits: guaranteed COI, guaranteed expense charges
        guaranteedCOI = getGuaranteedCOIRate(policy, month) * getGuaranteedNAR(policy, month)
        guaranteedExpense = getGuaranteedExpenseCharge(policy, month)
        shadowValue -= (guaranteedCOI + guaranteedExpense)

        // Interest: shadow account interest rate (guaranteed minimum)
        shadowValue *= (1 + policy.shadowAccountInterestRate / 12)

    return max(shadowValue, 0)
```

**Shadow Account vs. Actual Account:**

| Feature | Actual Account Value | Shadow Account |
|---------|---------------------|---------------|
| **COI Rates** | Current scale (lower) | Guaranteed maximum (higher) |
| **Interest Rate** | Current declared / market | Guaranteed minimum |
| **Expense Charges** | Current scale | Guaranteed maximum |
| **Fund Performance** | Actual market performance | N/A (uses fixed rate) |
| **Purpose** | Determine actual policy value | Determine no-lapse eligibility |

---

## 3. Non-Forfeiture Options

### 3.1 Overview

The Standard Nonforfeiture Law requires that life insurance policies with cash value must provide at least one of three non-forfeiture options when premium payment ceases:

1. **Cash Surrender** — Pay the cash surrender value to the policyholder
2. **Extended Term Insurance (ETI)** — Use the CSV to purchase term insurance for the full face amount for a calculated period
3. **Reduced Paid-Up Insurance (RPU)** — Use the CSV to purchase a fully paid-up policy at a reduced face amount

### 3.2 Automatic Non-Forfeiture Selection Rules

Most policies designate a default non-forfeiture option that applies automatically if the policyholder does not make an affirmative election.

**Default Non-Forfeiture Option by Product:**

| Product Type | Typical Default | Rationale |
|-------------|----------------|-----------|
| Whole Life | Extended Term Insurance | Maintains full death benefit temporarily |
| 20-Pay Life | Extended Term Insurance | Maintains death benefit |
| Universal Life | Cash Surrender / Lapse | No statutory ETI/RPU for UL in most states |
| Variable Life | Extended Term Insurance | Per SEC/state requirements |
| Endowment | Cash Surrender | Near-maturity policies favor cash |

**Election Process:**

```mermaid
flowchart TD
    A[Policy Reaches Lapse Point] --> B{Owner Previously Elected Option?}
    B -->|Yes| C[Apply Elected Option]
    B -->|No| D{Policy Contract Specifies Default?}
    D -->|Yes| E[Apply Contract Default]
    D -->|No| F[Apply Statutory Default per State]
    C --> G[Process Non-Forfeiture Benefit]
    E --> G
    F --> G
    G --> H[Generate Non-Forfeiture Confirmation]
    H --> I[Notify Owner of Elected/Default Option]
    I --> J[Inform of Right to Change Election Within Window]
```

### 3.3 Non-Forfeiture Value Calculation

The minimum non-forfeiture value is calculated per the Standard Nonforfeiture Law:

```pseudocode
function calculateMinimumNonForfeitureValue(policy, asOfDate):
    // Per Standard Nonforfeiture Law (NAIC Model #808)

    // Step 1: Determine the adjusted premium
    adjustedPremium = calculateAdjustedPremium(policy)

    // Step 2: Calculate the present value of future adjusted premiums
    pvFutureAdjustedPremiums = calculatePV(
        payment = adjustedPremium,
        frequency = ANNUAL,
        startAge = policy.attainedAge,
        endAge = policy.maturityAge,
        interestRate = policy.nonForfeitureInterestRate,
        mortalityTable = policy.nonForfeitureMortalityTable
    )

    // Step 3: Calculate the present value of future benefits
    pvFutureBenefits = calculatePV(
        deathBenefit = policy.faceAmount,
        startAge = policy.attainedAge,
        endAge = policy.maturityAge,
        interestRate = policy.nonForfeitureInterestRate,
        mortalityTable = policy.nonForfeitureMortalityTable
    )

    // Step 4: Minimum non-forfeiture value
    minimumNFV = pvFutureBenefits - pvFutureAdjustedPremiums

    // Step 5: Apply surrender charge (if within surrender charge period)
    surrenderCharge = getSurrenderCharge(policy, asOfDate)

    netNFV = max(0, minimumNFV - surrenderCharge)

    return netNFV
```

**Non-Forfeiture Interest Rate:**

| Mortality Table Era | Maximum Non-Forfeiture Interest Rate |
|--------------------|-------------------------------------|
| 1980 CSO | 5.5% (adjusted for plan type) |
| 2001 CSO | 4.5% (typical; varies by state) |
| 2017 CSO | 3.5% (typical; varies by state) |

**Mortality Tables Used:**

| Table | Usage |
|-------|-------|
| **2001 CSO** | Non-forfeiture calculations for policies issued 2004–2019 |
| **2017 CSO** | Non-forfeiture calculations for policies issued 2020+ |
| **Composite** | Unisex blend where required |
| **Smoker/Non-smoker** | Separate tables for risk class differentiation |

### 3.4 Standard Non-forfeiture Law Compliance

The PAS must maintain compliance with the Standard Nonforfeiture Law:

| Requirement | Implementation |
|-------------|---------------|
| **Minimum cash value** | CSV must meet or exceed the statutory minimum at every duration |
| **Cash value table in contract** | Policy contract must include a table of guaranteed cash values |
| **Non-forfeiture benefit availability** | ETI, RPU, or CSV must be available at every duration after the first year (or first two years for certain policies) |
| **Timing** | Non-forfeiture values must be available within 6 months of the anniversary date |
| **Mortality basis** | Must use the NAIC-adopted mortality table (currently 2017 CSO) |
| **Interest rate** | Must not exceed the statutory maximum non-forfeiture interest rate |

---

## 4. Cash Surrender Processing

### 4.1 Cash Surrender Value Calculation

The cash surrender value is the amount the policyholder receives upon voluntarily terminating the policy.

```pseudocode
function calculateCashSurrenderValue(policy, asOfDate):
    // Step 1: Determine gross cash value
    if policy.productType == WHOLE_LIFE:
        grossCashValue = getGuaranteedCashValueFromTable(policy, asOfDate)
        // Add terminal dividend (if applicable)
        terminalDividend = calculateTerminalDividend(policy, asOfDate)
        grossCashValue += terminalDividend
        // Add paid-up additions value
        puaValue = calculatePUAValue(policy, asOfDate)
        grossCashValue += puaValue
        // Add dividend accumulations
        dividendAccumulations = policy.dividendAccumulationBalance
        grossCashValue += dividendAccumulations

    elif policy.productType in [UL, VUL, IUL]:
        grossCashValue = policy.accountValue

    // Step 2: Deduct surrender charge
    surrenderCharge = calculateSurrenderCharge(policy, asOfDate)

    // Step 3: Apply Market Value Adjustment (for products with MVA)
    mva = 0
    if policy.hasMVA:
        mva = calculateMVA(policy, asOfDate)

    // Step 4: Offset outstanding policy loans
    loanOffset = policy.outstandingLoanBalance + policy.accruedLoanInterest

    // Step 5: Premium tax refund (where applicable)
    premiumTaxRefund = calculatePremiumTaxRefund(policy, asOfDate)

    // Step 6: Calculate net surrender value
    netSurrenderValue = grossCashValue - surrenderCharge + mva - loanOffset + premiumTaxRefund

    return max(0, netSurrenderValue)
```

### 4.2 Surrender Charge Deduction

**Surrender Charge Schedule Example:**

| Policy Year | Surrender Charge % | Surrender Charge per $1,000 |
|-------------|-------------------|----------------------------|
| 1 | 100% of target premium | $35.00 |
| 2 | 90% | $31.50 |
| 3 | 80% | $28.00 |
| 4 | 70% | $24.50 |
| 5 | 60% | $21.00 |
| 6 | 50% | $17.50 |
| 7 | 40% | $14.00 |
| 8 | 30% | $10.50 |
| 9 | 20% | $7.00 |
| 10 | 10% | $3.50 |
| 11+ | 0% | $0.00 |

**Surrender Charge Calculation:**

```pseudocode
function calculateSurrenderCharge(policy, asOfDate):
    policyYear = getPolicyYear(policy, asOfDate)
    schedule = policy.surrenderChargeSchedule

    if policyYear > len(schedule):
        return 0  // Beyond surrender charge period

    chargeSpec = schedule[policyYear]

    if chargeSpec.method == "PERCENT_OF_TARGET_PREMIUM":
        return policy.targetPremium * chargeSpec.percent
    elif chargeSpec.method == "PER_THOUSAND_FACE":
        return (policy.faceAmount / 1000) * chargeSpec.perThousand
    elif chargeSpec.method == "PERCENT_OF_ACCOUNT_VALUE":
        return policy.accountValue * chargeSpec.percent
    elif chargeSpec.method == "PERCENT_OF_PREMIUMS_PAID":
        return policy.totalPremiumsPaid * chargeSpec.percent
```

### 4.3 Market Value Adjustment (MVA)

For products with MVA features (common in fixed annuities and some universal life products):

```pseudocode
function calculateMVA(policy, surrenderDate):
    // MVA adjusts the surrender value based on interest rate changes since issue
    originalRate = policy.guaranteedInterestRate
    currentRate = getCurrentTreasuryRate(policy.mvaBenchmark, surrenderDate)
    remainingYears = yearsBetween(surrenderDate, policy.maturityDate)

    // MVA formula (simplified)
    mvaFactor = ((1 + originalRate) / (1 + currentRate + policy.mvaSpread)) ^ remainingYears

    if mvaFactor > 1:
        // Interest rates dropped — MVA is positive (surrender value increases)
        mvaAdjustment = policy.accountValue * (mvaFactor - 1)
    else:
        // Interest rates rose — MVA is negative (surrender value decreases)
        mvaAdjustment = policy.accountValue * (mvaFactor - 1)
        // Apply MVA floor (typically cannot reduce below minimum surrender value)
        minimumSurrender = policy.minimumGuaranteedSurrenderValue
        mvaAdjustment = max(mvaAdjustment, minimumSurrender - policy.accountValue)

    return mvaAdjustment
```

### 4.4 Policy Loan Offset

When a policy is surrendered with an outstanding loan, the loan is offset against the cash value:

```
Net Surrender = Gross Cash Value - Surrender Charges ± MVA - Outstanding Loan - Accrued Loan Interest + Premium Tax Refund
```

**Tax Treatment of Loan Offset:**

The loan offset at surrender creates a taxable event:

```
Taxable Gain = Net Surrender Value + Outstanding Loan Balance - Cost Basis
```

This is "phantom income" — the policyholder receives the net surrender check but is taxed on the full gain including the loan offset.

### 4.5 Tax Withholding on Surrender

```pseudocode
function calculateSurrenderTaxWithholding(policy, netSurrenderValue):
    costBasis = policy.totalPremiumsPaid - policy.totalDividendsReceived
    loanOffset = policy.outstandingLoanBalance + policy.accruedLoanInterest
    totalProceeds = netSurrenderValue + loanOffset
    taxableGain = max(0, totalProceeds - costBasis)

    if taxableGain == 0:
        return { federalWithholding: 0, stateWithholding: 0 }

    // Federal withholding
    if policy.mecStatus:
        // MEC: LIFO — gain comes out first
        if policy.ownerAge < 59.5:
            federalRate = 0.10  // Default withholding
            penaltyRate = 0.10  // 10% early distribution penalty
        else:
            federalRate = 0.10
            penaltyRate = 0
    else:
        // Non-MEC: FIFO — basis comes out first
        federalRate = 0.10  // Default (owner can elect 0% or higher)
        penaltyRate = 0

    federalWithholding = taxableGain * federalRate
    penalty = taxableGain * penaltyRate

    // State withholding varies
    stateWithholding = calculateStateWithholding(
        policy.ownerState, taxableGain
    )

    return {
        totalProceeds: totalProceeds,
        costBasis: costBasis,
        taxableGain: taxableGain,
        federalWithholding: federalWithholding,
        earlyDistributionPenalty: penalty,
        stateWithholding: stateWithholding,
        netCheck: netSurrenderValue - federalWithholding - stateWithholding
    }
```

### 4.6 1099-R Generation

Upon surrender, the PAS must generate a 1099-R form:

```json
{
  "form1099R": {
    "taxYear": 2025,
    "payerInfo": {
      "name": "Acme Life Insurance Company",
      "tin": "06-1234567",
      "address": "100 Insurance Way, Hartford, CT 06103"
    },
    "recipientInfo": {
      "name": "John A. Smith",
      "ssn": "***-**-1234",
      "address": "456 Oak Avenue, Boston, MA 02108"
    },
    "policyNumber": "LIF-2024-00012345",
    "box1_grossDistribution": 120000.00,
    "box2a_taxableAmount": 35000.00,
    "box2b_taxableAmountNotDetermined": false,
    "box3_capitalGain": 0.00,
    "box4_federalTaxWithheld": 3500.00,
    "box5_employeeContributions": 85000.00,
    "box7_distributionCode": "7",
    "box9b_totalEmployeeContributions": 85000.00,
    "box14_stateTaxWithheld": 1750.00,
    "box15_statePayerNumber": "CT-98765",
    "box16_stateDistribution": 35000.00
  }
}
```

**Distribution Codes (Box 7):**

| Code | Description | Applicable Scenario |
|------|-------------|-------------------|
| **1** | Early distribution, no known exception | Under 59½, MEC |
| **2** | Early distribution, exception applies | Under 59½, disability |
| **4** | Death | Death benefit distribution |
| **7** | Normal distribution | Age 59½+, non-MEC surrender |
| **L** | Loans treated as distributions | MEC loan |
| **D** | Excess contributions plus earnings | Over-funding refund |

### 4.7 Surrender Effective Date Rules

| Rule | Description |
|------|-------------|
| **Current Date** | Most carriers process surrenders effective the date the request is received in good order |
| **End of Month** | Some carriers use end-of-month effective dates for accounting convenience |
| **Anniversary Date** | Surrender on or near the anniversary may use the anniversary date |
| **Post-Free-Look** | If within free-look period, full premium refund instead of surrender |
| **Backdating Prohibition** | Generally cannot backdate a surrender to avoid market losses |

---

## 5. Extended Term Insurance (ETI)

### 5.1 Calculation Methodology

Extended Term Insurance uses the net surrender value (cash surrender value after deducting any outstanding loans) to purchase a level term insurance policy for the **full original face amount** for the **maximum duration** possible.

```pseudocode
function calculateETI(policy, lapseDate):
    // Step 1: Determine net surrender value available for ETI
    csv = calculateCashSurrenderValue(policy, lapseDate)
    outstandingLoan = policy.outstandingLoanBalance + policy.accruedLoanInterest
    netSurrenderValue = csv  // Loans are already offset in CSV calculation

    if netSurrenderValue <= 0:
        return null  // No ETI available

    // Step 2: Determine the face amount for ETI
    etiFaceAmount = policy.faceAmount  // Full face amount

    // Step 3: Calculate the term duration
    // Use the net surrender value as a net single premium for term insurance
    attainedAge = getAttainedAge(policy.insured, lapseDate)

    // Binary search for maximum duration
    maxYears = policy.maturityAge - attainedAge
    etiDuration = 0

    for years in range(maxYears, 0, -1):
        for months in range(11, -1, -1):
            duration = years + months / 12
            nsp = calculateNetSinglePremiumForTerm(
                faceAmount = etiFaceAmount,
                attainedAge = attainedAge,
                gender = policy.insured.gender,
                duration = duration,
                mortalityTable = policy.nonForfeitureMortalityTable,
                interestRate = policy.nonForfeitureInterestRate
            )

            if nsp <= netSurrenderValue:
                etiDuration = duration
                etiExpiryDate = addYearsMonths(lapseDate, years, months)

                // Check if any excess remains
                excessValue = netSurrenderValue - nsp
                if excessValue > 0:
                    // Excess may purchase additional paid-up insurance
                    // or be used for other non-forfeiture benefits
                    pass

                return {
                    etiFaceAmount: etiFaceAmount,
                    etiDurationYears: years,
                    etiDurationMonths: months,
                    etiExpiryDate: etiExpiryDate,
                    netSurrenderValueUsed: nsp,
                    excessValue: excessValue,
                    mortalityBasis: policy.nonForfeitureMortalityTable,
                    interestBasis: policy.nonForfeitureInterestRate
                }

    return null  // Should not reach here if CSV > 0
```

### 5.2 ETI Face Amount Determination

The ETI face amount is always the **original death benefit** amount of the policy (less any outstanding loans which are treated separately). The duration varies based on available cash value.

### 5.3 ETI Expiry Date Calculation

The ETI expiry date is the date on which the extended term insurance coverage expires.

```
ETI Duration = f(Net Surrender Value, Face Amount, Attained Age, Mortality Table, Interest Rate)
```

Solved by finding the maximum `n` (years and months) such that:

```
Net Single Premium for n-year term at attained age ≤ Net Surrender Value
```

### 5.4 ETI Limitations

| Limitation | Description |
|-----------|-------------|
| **No Riders** | All riders terminate when ETI takes effect |
| **No Policy Loans** | Cannot take new loans against ETI coverage |
| **No Dividends** | ETI does not participate in dividends (even if original was participating) |
| **No Cash Value** | ETI has no further cash value accumulation |
| **No Premium Payments** | ETI is fully paid-up for its duration; no premiums accepted |
| **Conversion** | Some contracts allow conversion of ETI to reduced paid-up |
| **Death Benefit** | Fixed at the original face amount (less loans) |

### 5.5 Worked Example — ETI Calculation

**Given:**

| Parameter | Value |
|-----------|-------|
| Policy Type | Whole Life |
| Face Amount | $250,000 |
| Issue Age | 35 Male Non-Smoker |
| Current Attained Age | 55 |
| Cash Surrender Value | $62,500 |
| Outstanding Loans | $10,000 |
| Accrued Loan Interest | $500 |
| Mortality Table | 2017 CSO Male Non-Smoker |
| Non-Forfeiture Interest Rate | 3.5% |

**Calculation:**

| Step | Calculation | Result |
|------|-------------|--------|
| 1. Net Surrender Value | $62,500 − $10,000 − $500 | **$52,000** |
| 2. Net Single Premium for 1 year term at age 55 (per $1,000) | From mortality table / interest | $3.21 |
| 3. NSP for face amount for 1 year | $3.21 × 250 | $802.50 |
| 4. Iterate to find maximum duration | (trial and error using actuarial tables) | |
| 5. NSP for 22 years 4 months term at age 55 | (actuarial calculation) | $51,875 |
| 6. NSP for 22 years 5 months term at age 55 | (actuarial calculation) | $52,150 |
| 7. Maximum ETI duration | $52,000 covers 22 years 4 months | **22 years, 4 months** |
| 8. ETI Expiry Date | Lapse date + 22 years 4 months | **~July 2047** |
| 9. Excess value | $52,000 − $51,875 | **$125** |

**Result:**

```json
{
  "etiResult": {
    "originalPolicy": "WL-2015-00054321",
    "lapseDate": "2025-03-15",
    "faceAmount": 250000.00,
    "netSurrenderValueUsed": 51875.00,
    "durationYears": 22,
    "durationMonths": 4,
    "expiryDate": "2047-07-15",
    "excessValue": 125.00,
    "mortalityTable": "2017_CSO_MALE_NS",
    "interestRate": 0.035,
    "riders": "ALL_TERMINATED",
    "loanStatus": "OFFSET_AT_LAPSE",
    "dividendEligibility": false
  }
}
```

---

## 6. Reduced Paid-Up Insurance (RPU)

### 6.1 RPU Calculation Methodology

Reduced Paid-Up insurance uses the net surrender value to purchase a **fully paid-up whole life policy** at a **reduced face amount**.

```pseudocode
function calculateRPU(policy, lapseDate):
    // Step 1: Determine net surrender value
    csv = calculateCashSurrenderValue(policy, lapseDate)
    outstandingLoan = policy.outstandingLoanBalance + policy.accruedLoanInterest
    netSurrenderValue = csv

    if netSurrenderValue <= 0:
        return null

    // Step 2: Calculate net single premium per $1,000 for paid-up whole life
    attainedAge = getAttainedAge(policy.insured, lapseDate)

    nspPerThousand = calculateNetSinglePremiumForWholeLife(
        attainedAge = attainedAge,
        gender = policy.insured.gender,
        mortalityTable = policy.nonForfeitureMortalityTable,
        interestRate = policy.nonForfeitureInterestRate,
        maturityAge = policy.maturityAge  // Typically 100 or 121
    )

    // Step 3: Calculate reduced face amount
    rpuFaceAmount = (netSurrenderValue / nspPerThousand) * 1000
    rpuFaceAmount = roundDown(rpuFaceAmount, 0)  // Round down to whole dollar

    // Step 4: Calculate RPU cash value (should equal NSV initially)
    rpuInitialCashValue = netSurrenderValue

    return {
        rpuFaceAmount: rpuFaceAmount,
        rpuInitialCashValue: rpuInitialCashValue,
        originalFaceAmount: policy.faceAmount,
        reductionPercent: (1 - rpuFaceAmount / policy.faceAmount) * 100,
        mortalityBasis: policy.nonForfeitureMortalityTable,
        interestBasis: policy.nonForfeitureInterestRate,
        dividendEligible: policy.isParticipating,
        maturityDate: getMaturityDate(policy)
    }
```

### 6.2 RPU Face Amount Determination

The RPU face amount is determined by:

```
RPU Face Amount = (Net Surrender Value / Net Single Premium per $1,000 for Whole Life at Attained Age) × $1,000
```

### 6.3 RPU as Fully Paid-Up Contract

Once converted to RPU:

| Feature | Status |
|---------|--------|
| **Premium Payments** | None required — fully paid-up |
| **Cash Value** | Continues to accumulate at guaranteed rate |
| **Death Benefit** | Reduced face amount — payable upon death of insured |
| **Policy Loans** | Available against the RPU cash value |
| **Dividends** | Eligible if the original policy was participating |
| **Riders** | Most riders terminate; some may continue with modification |
| **Surrender** | Can surrender RPU at any time for its cash value |
| **Maturity** | Matures at the original maturity date; endowment value equals RPU face amount |

### 6.4 Dividend Eligibility for RPU

Participating whole life policies converted to RPU continue to be eligible for dividends:

**Dividend Options for RPU:**

| Option | Description |
|--------|-------------|
| Cash | Dividend paid in cash |
| Accumulate at Interest | Dividend held in accumulation account |
| Paid-Up Additions | Dividend purchases additional paid-up insurance (increases effective death benefit) |
| One-Year Term | Dividend purchases one-year term to supplement RPU death benefit |

### 6.5 Worked Example — RPU Calculation

**Given:**

| Parameter | Value |
|-----------|-------|
| Policy Type | Participating Whole Life |
| Original Face Amount | $250,000 |
| Issue Age | 35 Male Non-Smoker |
| Current Attained Age | 55 |
| Cash Surrender Value | $62,500 |
| Outstanding Loans | $10,000 |
| Accrued Loan Interest | $500 |
| Mortality Table | 2017 CSO Male Non-Smoker |
| Non-Forfeiture Interest Rate | 3.5% |
| Net Single Premium per $1,000 for WL at age 55 | $385.42 |

**Calculation:**

| Step | Calculation | Result |
|------|-------------|--------|
| 1. Net Surrender Value | $62,500 − $10,000 − $500 | **$52,000** |
| 2. NSP per $1,000 at age 55 | From actuarial table | **$385.42** |
| 3. RPU Face Amount | ($52,000 / $385.42) × $1,000 | **$134,895** |
| 4. Round down | | **$134,895** |
| 5. Reduction from original | ($250,000 − $134,895) / $250,000 | **46.04% reduction** |

**Result:**

```json
{
  "rpuResult": {
    "originalPolicy": "WL-2015-00054321",
    "lapseDate": "2025-03-15",
    "originalFaceAmount": 250000.00,
    "rpuFaceAmount": 134895.00,
    "reductionPercent": 46.04,
    "initialCashValue": 52000.00,
    "premiumsDue": 0.00,
    "dividendEligible": true,
    "maturityDate": "2055-06-15",
    "mortalityTable": "2017_CSO_MALE_NS",
    "interestRate": 0.035,
    "policyLoansAvailable": true,
    "riderStatus": {
      "waiverOfPremium": "TERMINATED",
      "accidentalDeath": "TERMINATED",
      "guaranteedInsurability": "TERMINATED"
    }
  }
}
```

### 6.6 Comparison: ETI vs. RPU

| Feature | Extended Term (ETI) | Reduced Paid-Up (RPU) |
|---------|--------------------|-----------------------|
| **Face Amount** | Full original amount | Reduced amount |
| **Duration** | Limited (calculated term) | Permanent (to maturity) |
| **Cash Value** | None | Continues to grow |
| **Policy Loans** | Not available | Available |
| **Dividends** | Not available | Available (if participating) |
| **Riders** | All terminated | Most terminated |
| **Best For** | Short-term protection need | Long-term, reduced coverage need |
| **Risk** | Coverage ends at expiry | Lower death benefit |

---

## 7. Reinstatement

### 7.1 Reinstatement Application Requirements

Reinstatement restores a lapsed policy to active, in-force status.

**Required Documentation:**

| Document | Purpose | Always Required? |
|----------|---------|-----------------|
| Reinstatement Application | Formal request | Yes |
| Health Statement/Questionnaire | Evidence of insurability | Yes (within first 30 days: may be waived) |
| Medical Exam (if required) | Full underwriting evidence | Depends on amount and time since lapse |
| Payment of Back Premiums | Cover lapsed period | Yes |
| Interest on Back Premiums | Compensate for lost investment income | Yes |
| Loan Restoration Payment | Restore any loans offset at lapse | Depends on policy status |
| Signed Declarations | Attestation of accuracy | Yes |

### 7.2 Reinstatement Period

The reinstatement period is the window during which the policyholder can apply to reinstate:

| Product Type | Typical Period | State Minimum |
|-------------|----------------|--------------|
| Term Life | 3 years | 3 years (varies) |
| Whole Life | 3–5 years | 3 years (varies) |
| Universal Life | 3–5 years | 3 years (varies) |
| Group Life | 31 days (typical) | Varies by state and certificate |

### 7.3 Evidence of Insurability Requirements

| Time Since Lapse | Typical Evidence Required |
|-----------------|--------------------------|
| 0–30 days | Premium only (some carriers waive evidence) |
| 31–90 days | Health statement/questionnaire |
| 91 days – 1 year | Health statement + paramedical exam |
| 1–3 years | Full medical exam + labs + APS |
| 3–5 years | Full medical + financial underwriting |
| 5+ years | Reinstatement generally not available; apply as new business |

### 7.4 Back Premium Calculation

```pseudocode
function calculateBackPremiums(policy, reinstatementDate):
    lapseDate = policy.lapseDate
    backPremiums = []
    totalBackPremium = 0

    // Calculate premiums that would have been due during the lapsed period
    currentDueDate = policy.lastPremiumDueDate  // Last premium that was not paid

    while currentDueDate <= reinstatementDate:
        if currentDueDate > lapseDate:
            // Only charge for the current premium going forward
            // Some carriers require premiums for the full lapsed period
            break

        premiumDue = policy.modalPremium
        backPremiums.append({
            dueDate: currentDueDate,
            amount: premiumDue
        })
        totalBackPremium += premiumDue
        currentDueDate = advanceByMode(currentDueDate, policy.premiumMode)

    // Current premium due
    currentPremium = policy.modalPremium
    totalBackPremium += currentPremium

    return {
        backPremiums: backPremiums,
        currentPremium: currentPremium,
        totalBackPremium: totalBackPremium
    }
```

### 7.5 Loan Restoration

If the policy had an outstanding loan that was offset at lapse:

```pseudocode
function calculateLoanRestoration(policy, reinstatementDate):
    if policy.loanOffsetAtLapse == 0:
        return { restorationRequired: false }

    // The policyholder must restore the loan to its pre-lapse state
    originalLoanBalance = policy.loanBalanceAtLapse
    originalAccruedInterest = policy.accruedInterestAtLapse

    // Calculate interest from lapse date to reinstatement date
    daysSinceLapse = daysBetween(policy.lapseDate, reinstatementDate)
    additionalInterest = originalLoanBalance * policy.loanInterestRate * daysSinceLapse / 365

    totalLoanRestoration = originalLoanBalance + originalAccruedInterest + additionalInterest

    return {
        restorationRequired: true,
        originalLoanBalance: originalLoanBalance,
        originalAccruedInterest: originalAccruedInterest,
        additionalInterest: additionalInterest,
        totalLoanRestoration: totalLoanRestoration,
        option: "RESTORE_OR_PAY_OFF"
    }
```

### 7.6 Interest Calculation on Back Premiums

```pseudocode
function calculateInterestOnBackPremiums(backPremiums, reinstatementDate, interestRate):
    totalInterest = 0

    for premium in backPremiums:
        daysOverdue = daysBetween(premium.dueDate, reinstatementDate)
        interest = premium.amount * interestRate * daysOverdue / 365
        totalInterest += interest

    return totalInterest
```

### 7.7 Reinstatement Effective Dating

| Method | Description | Tax Implication |
|--------|-------------|----------------|
| **Original Lapse Date** | Reinstates as if lapse never occurred | Continuous coverage; no break in policy year |
| **Current Date** | Reinstates effective the current date | May create a gap in coverage |
| **Most Common** | Effective upon approval and payment | Standard practice |

### 7.8 Contestability Period Reset

**Critical**: Reinstatement restarts the two-year contestability period.

```pseudocode
function handleContestabilityReset(policy, reinstatementDate):
    // Original contestability period
    originalContestEnd = addYears(policy.issueDate, 2)

    // If original contestability has not expired, it continues from issue
    // If it has expired, reinstatement creates a NEW contestability period
    if reinstatementDate > originalContestEnd:
        // New contestability period from reinstatement date
        policy.contestabilityEndDate = addYears(reinstatementDate, 2)
        policy.contestabilityType = "REINSTATEMENT"
        // Note: Only statements made in the reinstatement application
        // are subject to the new contestability period
    else:
        // Original contestability continues
        policy.contestabilityEndDate = originalContestEnd
```

### 7.9 Reinstatement Underwriting

```mermaid
flowchart TD
    A[Reinstatement Application Received] --> B{Within 30-Day Auto-Reinstate Window?}
    B -->|Yes| C{Premium Paid? Health Declaration OK?}
    C -->|Yes| D[Auto-Reinstate - No Underwriting]
    C -->|No| E[Standard Reinstatement Process]
    B -->|No| E
    E --> F{Within 90 Days of Lapse?}
    F -->|Yes| G[Health Statement Review]
    F -->|No| H{Within 1 Year?}
    H -->|Yes| I[Paramedical + Health Statement]
    H -->|No| J[Full Medical Underwriting]
    G --> K{Evidence Satisfactory?}
    I --> K
    J --> K
    K -->|Yes| L[Calculate Back Premiums + Interest]
    K -->|No| M[Decline Reinstatement]
    L --> N{Payment Received?}
    N -->|Yes| O[Reinstate Policy]
    N -->|No| P[Await Payment]
    O --> Q[Reset Contestability Period]
    Q --> R[Update Policy Status to In-Force]
    R --> S[Generate Reinstatement Confirmation]
    D --> Q
```

### 7.10 Automatic Reinstatement Provisions

Many policies include automatic reinstatement provisions:

**Automatic Reinstatement Criteria:**

| Criterion | Requirement |
|-----------|-------------|
| **Time Since Lapse** | Within 30 days of lapse (some carriers: 60 days) |
| **Premium Payment** | Full back premium(s) received |
| **Health Declaration** | Simple health statement or declaration of no changes |
| **No Claim Pending** | No death claim filed during lapsed period |
| **Owner Attestation** | Insured is alive and in substantially same health |

```pseudocode
function processAutomaticReinstatement(policy, payment, healthDeclaration):
    daysSinceLapse = daysBetween(policy.lapseDate, today())

    if daysSinceLapse > 30:
        return { eligible: false, reason: "BEYOND_AUTO_REINSTATE_WINDOW" }

    if payment.amount < policy.totalBackPremiumDue:
        return { eligible: false, reason: "INSUFFICIENT_PAYMENT" }

    if healthDeclaration.anyHealthChanges == true:
        return { eligible: false, reason: "HEALTH_CHANGES_REPORTED" }

    if hasDeathClaimFiled(policy):
        return { eligible: false, reason: "DEATH_CLAIM_FILED" }

    // All criteria met — auto-reinstate
    reinstatePolicy(policy, effectiveDate=policy.lapseDate)
    applyPayment(policy, payment)
    resetContestabilityIfNeeded(policy)
    generateConfirmation(policy, "AUTO_REINSTATEMENT")

    return { eligible: true, reinstated: true, effectiveDate: policy.lapseDate }
```

---

## 8. Automatic Premium Loan (APL)

### 8.1 APL Election

The Automatic Premium Loan provision is an optional feature that the policyholder elects (usually at application or subsequently by request). When elected, the carrier automatically takes a policy loan to pay the premium when the policyholder fails to pay by the end of the grace period.

**APL Election Data:**

```json
{
  "aplElection": {
    "policyNumber": "WL-2015-00054321",
    "elected": true,
    "electionDate": "2015-06-15",
    "electionMethod": "APPLICATION",
    "canBeChanged": true,
    "changeRequiresWrittenRequest": true
  }
}
```

### 8.2 Maximum APL Amount

The maximum APL amount is limited by the loan value of the policy:

```pseudocode
function calculateMaxAPL(policy):
    maxLoanAvailable = calculateMaxLoan(policy)
    premiumDue = policy.currentModalPremium

    if maxLoanAvailable >= premiumDue:
        return premiumDue  // Full premium can be covered
    else:
        // Some carriers allow partial APL, others don't
        if policy.carrier.allowsPartialAPL:
            return maxLoanAvailable
        else:
            return 0  // Cannot cover full premium — APL not activated
```

### 8.3 APL Processing Sequence

APL is processed **after** the grace period expires but **before** the policy lapses:

```mermaid
flowchart TD
    A[Grace Period Expires Without Payment] --> B{APL Elected?}
    B -->|No| C[Proceed to Non-Forfeiture / Lapse]
    B -->|Yes| D[Calculate Maximum Available Loan]
    D --> E{Max Loan ≥ Premium Due?}
    E -->|Yes| F[Create Policy Loan for Premium Amount]
    F --> G[Apply Loan Proceeds as Premium Payment]
    G --> H[Policy Continues In-Force]
    H --> I[Send APL Notification to Owner]
    I --> J[Warn: Continued APL Will Erode Cash Value]
    E -->|No| K{Partial APL Allowed?}
    K -->|Yes| L[Create Partial Loan]
    L --> M[Apply Partial Payment]
    M --> N{Remaining Premium Covered by Other Means?}
    N -->|No| C
    K -->|No| C
```

### 8.4 APL Exhaustion

When repeated APL loans exhaust the available loan value:

```pseudocode
function monitorAPLExhaustion(policy):
    if policy.aplActive:
        // Project future APL capacity
        currentLoanCapacity = calculateMaxLoan(policy)
        annualPremium = policy.annualPremium
        annualLoanInterest = (policy.outstandingLoanBalance * policy.loanInterestRate)
        annualCashValueGrowth = estimateAnnualCashValueGrowth(policy)

        netCapacityChangePerYear = annualCashValueGrowth - annualPremium - annualLoanInterest

        if netCapacityChangePerYear < 0:
            yearsUntilExhaustion = currentLoanCapacity / abs(netCapacityChangePerYear)
            if yearsUntilExhaustion < 3:
                sendWarningNotice(policy, "APL_EXHAUSTION_WARNING",
                    estimatedYearsRemaining = yearsUntilExhaustion)
```

### 8.5 APL Interaction with Death Benefit

Outstanding APL loans reduce the death benefit:

```
Net Death Benefit = Face Amount - Outstanding APL Loans - Regular Loans - Accrued Interest
```

### 8.6 APL vs. Non-Forfeiture Decision

When a policy cannot continue via APL, the system must determine the next action:

```mermaid
flowchart TD
    A[APL Cannot Cover Premium] --> B{Non-Forfeiture Option Elected?}
    B -->|Cash Surrender| C[Calculate CSV]
    C --> D[Pay CSV to Owner]
    D --> E[Policy Terminates]
    B -->|Extended Term| F[Calculate ETI Duration]
    F --> G[Convert to ETI]
    B -->|Reduced Paid-Up| H[Calculate RPU Face Amount]
    H --> I[Convert to RPU]
    B -->|No Election / Default| J{Default Option per Contract}
    J -->|ETI Default| F
    J -->|RPU Default| H
    J -->|CSV Default| C
```

---

## 9. UL-Specific Lapse Mechanics

### 9.1 Monthly Deduction Processing When Insufficient Cash Value

Universal Life policies have unique lapse mechanics because premiums are flexible and the policy is sustained by monthly deductions from the account value.

```pseudocode
function processULMonthlyDeduction(policy, deductionDate):
    // Calculate total monthly deduction
    coi = calculateMonthlyCOI(policy, deductionDate)
    adminCharge = policy.monthlyAdminCharge
    perThousandCharge = (policy.faceAmount / 1000) * policy.perThousandRate
    riderCharges = calculateMonthlyRiderCharges(policy)
    premiumLoad = 0  // Already deducted from incoming premiums

    totalDeduction = coi + adminCharge + perThousandCharge + riderCharges

    // Attempt to deduct
    if policy.accountValue >= totalDeduction:
        policy.accountValue -= totalDeduction
        recordDeduction(policy, deductionDate, totalDeduction, {
            coi: coi,
            admin: adminCharge,
            perThousand: perThousandCharge,
            riders: riderCharges
        })
        return DEDUCTION_SUCCESS
    else:
        // Insufficient funds
        availableValue = policy.accountValue

        // Check no-lapse guarantee first
        if isNoLapseActive(policy):
            // Deduct whatever is available
            policy.accountValue = max(0, policy.accountValue - totalDeduction)
            recordDeduction(policy, deductionDate, min(totalDeduction, availableValue), {
                status: "PARTIAL_DEDUCTION_NLG_ACTIVE"
            })
            return DEDUCTION_COVERED_BY_GUARANTEE

        // Check APL
        if policy.aplElected:
            loanAvailable = calculateMaxLoan(policy)
            shortfall = totalDeduction - availableValue
            if loanAvailable >= shortfall:
                createLoan(policy, shortfall, "APL")
                policy.accountValue -= totalDeduction
                policy.accountValue += shortfall  // Loan proceeds offset the deduction
                return DEDUCTION_COVERED_BY_APL

        // Begin grace period
        if not policy.inGracePeriod:
            policy.inGracePeriod = true
            policy.gracePeriodStartDate = deductionDate
            policy.gracePeriodEndDate = addDays(deductionDate, 61)
            sendGracePeriodNotice(policy)
            return GRACE_PERIOD_STARTED
        else:
            // Already in grace period — check if expired
            if deductionDate >= policy.gracePeriodEndDate:
                return LAPSE_TRIGGERED
            else:
                return GRACE_PERIOD_CONTINUES
```

### 9.2 No-Lapse Guarantee / Shadow Account Testing

```pseudocode
function performShadowAccountTest(policy, testDate):
    // Initialize shadow account at issue
    shadowValue = 0
    month = policy.issueDate

    while month <= testDate:
        // Credit: premiums paid in this month
        premiumPaid = getPremiumPaid(policy, month)
        shadowValue += premiumPaid

        // Debit: guaranteed COI at guaranteed rates
        guaranteedCOI = getGuaranteedCOIRate(policy, month)
        guaranteedNAR = policy.faceAmount - shadowValue  // Simplified
        guaranteedCOIDeduction = (guaranteedNAR / 1000) * guaranteedCOI / 12
        shadowValue -= max(0, guaranteedCOIDeduction)

        // Debit: guaranteed expense charges
        guaranteedExpense = getGuaranteedExpenseCharge(policy, month)
        shadowValue -= guaranteedExpense

        // Credit: shadow account interest (guaranteed minimum rate)
        shadowInterestRate = policy.shadowAccountInterestRate
        monthlyRate = shadowInterestRate / 12
        shadowValue *= (1 + monthlyRate)

        // Floor at zero
        shadowValue = max(0, shadowValue)

        month = addMonths(month, 1)

    return {
        shadowAccountValue: shadowValue,
        noLapseActive: shadowValue > 0,
        testDate: testDate
    }
```

### 9.3 Catch-Up Premium Provisions

Some UL products allow a "catch-up" premium to restore the no-lapse guarantee:

```json
{
  "catchUpProvision": {
    "policyNumber": "UL-2020-00076543",
    "noLapseStatus": "AT_RISK",
    "shadowAccountValue": -1250.00,
    "catchUpAmountRequired": 1250.00,
    "catchUpDeadline": "2025-12-31",
    "catchUpWindow": "NEXT_ANNIVERSARY",
    "instructions": "Pay the catch-up amount by the next policy anniversary to restore no-lapse guarantee protection."
  }
}
```

### 9.4 Lapse Protection Riders

Some products offer riders that provide additional lapse protection:

| Rider | Mechanism | Duration |
|-------|-----------|----------|
| **Overloan Protection** | Prevents lapse when outstanding loans approach account value | Typically after age 75 and policy year 15+ |
| **Lapse Protection Benefit** | Extends coverage for a limited period after account value depletion | 1–5 years |
| **Guaranteed Minimum Account Value** | Floor on account value regardless of market performance | Life of the policy |

---

## 10. State-Specific Requirements

### 10.1 State Variations in Grace Period

| State | Traditional Products | UL Products | Notes |
|-------|---------------------|-------------|-------|
| **Alabama** | 31 days | 61 days | Standard |
| **California** | 30 days | 60 days | 30-day minimum; senior protections |
| **Connecticut** | 31 days | 61 days | Enhanced notice requirements |
| **Florida** | 31 days | 61 days | Must provide reinstatement info in lapse notice |
| **Georgia** | 31 days | 61 days | Standard |
| **Illinois** | 31 days | 61 days | Senior designation for third-party notice |
| **Massachusetts** | 31 days | 61 days | Standard |
| **New Jersey** | 31 days | 61 days | Notice to irrevocable beneficiaries |
| **New York** | 31 days | 61 days | Most stringent notice requirements |
| **Ohio** | 31 days | 61 days | Standard |
| **Pennsylvania** | 31 days | 61 days | 15-day pre-lapse notice |
| **Texas** | 31 days | 61 days | Notice to assignees required |

### 10.2 State Variations in Notice Requirements

| State | Pre-Lapse Notice | Lapse Notice | Additional Recipients | Senior Provisions |
|-------|-----------------|-------------|----------------------|-------------------|
| **California** | Required | Required | Assignee | Designated person for age 60+ |
| **Connecticut** | 30 days before termination | Required | Assignee | None specific |
| **Florida** | Required | Required with reinstatement info | — | None specific |
| **Illinois** | Required | Required | Designated person for age 60+ | Third-party notification |
| **New Jersey** | Required | Required | Irrevocable beneficiary | None specific |
| **New York** | 15 days before lapse (21 days for policies > 1 year) | Required | Assignee | None specific |
| **Pennsylvania** | 15 days before default | Required | — | None specific |
| **Texas** | Required | Required | Assignee | None specific |

### 10.3 State Variations in Reinstatement Period

| State | Minimum Reinstatement Period | Notes |
|-------|------------------------------|-------|
| **Standard (NAIC Model)** | 3 years | Most states follow |
| **California** | 3 years | Standard |
| **Connecticut** | 3 years | Standard |
| **Illinois** | 3 years | Standard |
| **New York** | 3 years | Standard |
| **Texas** | 3 years | Some carriers offer 5 years |
| **Some States** | 5 years | Carrier may extend beyond statutory minimum |

### 10.4 State Non-Forfeiture Requirements

| State | Mortality Table Required | Interest Rate Maximum | Additional Requirements |
|-------|------------------------|-----------------------|------------------------|
| **All States (NAIC Model)** | 2017 CSO (for new policies) | 3.5%–4.5% (varies) | Minimum CSV schedule per Standard Nonforfeiture Law |
| **New York** | 2017 CSO | 4.0% | Stricter than NAIC model in certain aspects |
| **California** | 2017 CSO | State-specified | Standard |

---

## 11. Entity-Relationship Model

### 11.1 Complete ERD for Lapse/Reinstatement Processing

```mermaid
erDiagram
    POLICY ||--o{ LAPSE_EVENT : may_have
    POLICY ||--o{ REINSTATEMENT : may_have
    POLICY ||--|| NON_FORFEITURE_ELECTION : has
    POLICY ||--o{ APL_TRANSACTION : may_have
    POLICY ||--o{ SHADOW_ACCOUNT : may_have
    POLICY ||--o{ GRACE_PERIOD : may_enter
    POLICY ||--o{ LAPSE_NOTICE : receives
    POLICY ||--o{ SURRENDER_TRANSACTION : may_have

    LAPSE_EVENT ||--o{ NON_FORFEITURE_BENEFIT : triggers
    LAPSE_EVENT ||--o{ LAPSE_NOTICE : generates

    REINSTATEMENT ||--o{ REINSTATEMENT_REQUIREMENT : has
    REINSTATEMENT ||--|| REINSTATEMENT_UNDERWRITING : requires
    REINSTATEMENT ||--o{ BACK_PREMIUM : calculates

    NON_FORFEITURE_BENEFIT ||--o{ ETI_RECORD : may_create
    NON_FORFEITURE_BENEFIT ||--o{ RPU_RECORD : may_create
    NON_FORFEITURE_BENEFIT ||--o{ SURRENDER_TRANSACTION : may_create

    SURRENDER_TRANSACTION ||--o{ TAX_WITHHOLDING : calculates
    SURRENDER_TRANSACTION ||--|| FORM_1099R : generates

    SHADOW_ACCOUNT ||--o{ SHADOW_ACCOUNT_ENTRY : contains

    GRACE_PERIOD ||--o{ GRACE_NOTICE : generates

    POLICY {
        string policy_number PK
        string product_code FK
        string status
        date issue_date
        decimal face_amount
        decimal account_value
        decimal cash_surrender_value
        decimal outstanding_loan
        boolean apl_elected
        string non_forfeiture_option
        boolean has_no_lapse_guarantee
        date lapse_date
        string lapse_reason
    }

    LAPSE_EVENT {
        string lapse_id PK
        string policy_number FK
        date lapse_date
        string lapse_reason
        decimal cash_value_at_lapse
        decimal loan_balance_at_lapse
        string non_forfeiture_option_applied
        date reinstatement_expiry_date
        string status
    }

    GRACE_PERIOD {
        string grace_id PK
        string policy_number FK
        date start_date
        date end_date
        integer duration_days
        string trigger_event
        decimal premium_due
        string status
        boolean extended
        string extension_reason
    }

    GRACE_NOTICE {
        string notice_id PK
        string grace_id FK
        string notice_type
        date generation_date
        date sent_date
        string delivery_method
        string recipient
        string status
    }

    LAPSE_NOTICE {
        string notice_id PK
        string lapse_id FK
        string policy_number FK
        string notice_type
        date generation_date
        date sent_date
        string delivery_method
        string recipient
        string content_template
        boolean includes_reinstatement_info
        boolean includes_non_forfeiture_info
    }

    NON_FORFEITURE_ELECTION {
        string election_id PK
        string policy_number FK
        string elected_option
        date election_date
        string election_source
        boolean is_default
    }

    NON_FORFEITURE_BENEFIT {
        string benefit_id PK
        string lapse_id FK
        string policy_number FK
        string benefit_type
        date effective_date
        decimal net_surrender_value_used
        string calculation_basis
        string mortality_table
        decimal interest_rate
    }

    ETI_RECORD {
        string eti_id PK
        string benefit_id FK
        string policy_number FK
        decimal face_amount
        date start_date
        date expiry_date
        integer duration_years
        integer duration_months
        decimal net_single_premium_used
        string status
    }

    RPU_RECORD {
        string rpu_id PK
        string benefit_id FK
        string policy_number FK
        decimal original_face_amount
        decimal rpu_face_amount
        date effective_date
        decimal initial_cash_value
        boolean dividend_eligible
        string status
    }

    SURRENDER_TRANSACTION {
        string surrender_id PK
        string policy_number FK
        date surrender_date
        decimal gross_cash_value
        decimal surrender_charge
        decimal market_value_adjustment
        decimal loan_offset
        decimal premium_tax_refund
        decimal net_surrender_value
        decimal cost_basis
        decimal taxable_gain
        string disbursement_method
        string status
    }

    TAX_WITHHOLDING {
        string withholding_id PK
        string surrender_id FK
        decimal taxable_amount
        decimal federal_withholding
        decimal state_withholding
        decimal early_distribution_penalty
        string distribution_code
    }

    FORM_1099R {
        string form_id PK
        string surrender_id FK
        integer tax_year
        decimal box1_gross_distribution
        decimal box2a_taxable_amount
        decimal box4_federal_withheld
        decimal box5_employee_contributions
        string box7_distribution_code
        date generation_date
        boolean filed_with_irs
    }

    REINSTATEMENT {
        string reinstatement_id PK
        string policy_number FK
        string lapse_id FK
        date application_date
        date effective_date
        string status
        decimal back_premium_amount
        decimal interest_on_back_premium
        decimal loan_restoration_amount
        decimal total_amount_due
        boolean contestability_reset
        date new_contestability_end_date
    }

    REINSTATEMENT_REQUIREMENT {
        string requirement_id PK
        string reinstatement_id FK
        string requirement_type
        string status
        date due_date
        date fulfilled_date
        string document_id
    }

    REINSTATEMENT_UNDERWRITING {
        string uw_id PK
        string reinstatement_id FK
        string evidence_type
        string uw_class_result
        string decision
        date decision_date
        string underwriter_id
        string decline_reason
    }

    BACK_PREMIUM {
        string back_premium_id PK
        string reinstatement_id FK
        date original_due_date
        decimal premium_amount
        decimal interest_amount
        decimal total_due
    }

    APL_TRANSACTION {
        string apl_id PK
        string policy_number FK
        date apl_date
        decimal premium_amount
        decimal loan_created
        decimal accrued_interest
        string status
    }

    SHADOW_ACCOUNT {
        string shadow_id PK
        string policy_number FK
        decimal current_value
        date as_of_date
        boolean no_lapse_active
        decimal cumulative_premiums_required
        decimal cumulative_premiums_paid
    }

    SHADOW_ACCOUNT_ENTRY {
        string entry_id PK
        string shadow_id FK
        date entry_date
        string entry_type
        decimal amount
        decimal running_balance
        string description
    }
```

---

## 12. State Decision Matrix

### 12.1 Grace Period and Notice Decision Matrix

```json
{
  "stateDecisionMatrix": {
    "CT": {
      "gracePeriod": {
        "traditional": 31,
        "universalLife": 61,
        "group": 31
      },
      "notices": {
        "preLapse": {
          "required": true,
          "timing": "30_DAYS_BEFORE_TERMINATION",
          "recipients": ["OWNER", "ASSIGNEE"],
          "deliveryMethod": "WRITTEN",
          "content": ["PREMIUM_DUE", "CONSEQUENCES", "REINSTATEMENT_RIGHTS"]
        },
        "lapse": {
          "required": true,
          "timing": "WITHIN_10_DAYS_OF_LAPSE",
          "recipients": ["OWNER", "ASSIGNEE"],
          "content": ["LAPSE_EFFECTIVE_DATE", "NON_FORFEITURE_OPTIONS", "REINSTATEMENT_PROVISIONS"]
        },
        "seniorProvision": null
      },
      "reinstatement": {
        "minimumPeriod": 3,
        "periodUnit": "YEARS"
      }
    },
    "NY": {
      "gracePeriod": {
        "traditional": 31,
        "universalLife": 61,
        "group": 31
      },
      "notices": {
        "preLapse": {
          "required": true,
          "timing": "AT_LEAST_15_DAYS_BEFORE_LAPSE",
          "timingForPoliciesOver1Year": "AT_LEAST_21_DAYS_BEFORE_LAPSE",
          "recipients": ["OWNER", "ASSIGNEE_OF_RECORD"],
          "deliveryMethod": "WRITTEN_MAILED",
          "content": ["AMOUNT_DUE", "DUE_DATE", "CONSEQUENCES_OF_NONPAYMENT", "REINSTATEMENT_PROVISIONS"],
          "regulation": "NY_REG_68"
        },
        "lapse": {
          "required": true,
          "timing": "WITHIN_15_DAYS_OF_LAPSE",
          "recipients": ["OWNER", "ASSIGNEE"],
          "content": ["LAPSE_DATE", "CSV_AVAILABLE", "NON_FORFEITURE_OPTIONS", "REINSTATEMENT_RIGHTS"]
        },
        "seniorProvision": null
      },
      "reinstatement": {
        "minimumPeriod": 3,
        "periodUnit": "YEARS"
      }
    },
    "CA": {
      "gracePeriod": {
        "traditional": 30,
        "universalLife": 60,
        "group": 31
      },
      "notices": {
        "preLapse": {
          "required": true,
          "timing": "BEFORE_GRACE_PERIOD_END",
          "recipients": ["OWNER"],
          "deliveryMethod": "WRITTEN",
          "content": ["PREMIUM_DUE", "GRACE_PERIOD_END_DATE"]
        },
        "lapse": {
          "required": true,
          "recipients": ["OWNER"],
          "content": ["LAPSE_DATE", "REINSTATEMENT_PROVISIONS"]
        },
        "seniorProvision": {
          "applicableAge": 60,
          "requirement": "DESIGNATED_PERSON_NOTIFICATION",
          "noticeRecipients": ["OWNER", "DESIGNATED_PERSON"],
          "timing": "30_DAYS_BEFORE_LAPSE"
        }
      },
      "reinstatement": {
        "minimumPeriod": 3,
        "periodUnit": "YEARS"
      }
    },
    "IL": {
      "gracePeriod": {
        "traditional": 31,
        "universalLife": 61,
        "group": 31
      },
      "notices": {
        "preLapse": {
          "required": true,
          "recipients": ["OWNER"],
          "deliveryMethod": "WRITTEN"
        },
        "lapse": {
          "required": true,
          "recipients": ["OWNER"]
        },
        "seniorProvision": {
          "applicableAge": 60,
          "requirement": "THIRD_PARTY_NOTIFICATION",
          "noticeRecipients": ["OWNER", "DESIGNATED_THIRD_PARTY"],
          "timing": "BEFORE_LAPSE"
        }
      },
      "reinstatement": {
        "minimumPeriod": 3,
        "periodUnit": "YEARS"
      }
    },
    "TX": {
      "gracePeriod": {
        "traditional": 31,
        "universalLife": 61,
        "group": 31
      },
      "notices": {
        "preLapse": {
          "required": true,
          "recipients": ["OWNER", "ASSIGNEE"],
          "deliveryMethod": "WRITTEN"
        },
        "lapse": {
          "required": true,
          "recipients": ["OWNER", "ASSIGNEE"],
          "content": ["LAPSE_DATE", "REINSTATEMENT_RIGHTS"]
        },
        "seniorProvision": null
      },
      "reinstatement": {
        "minimumPeriod": 3,
        "periodUnit": "YEARS"
      }
    },
    "FL": {
      "gracePeriod": {
        "traditional": 31,
        "universalLife": 61,
        "group": 31
      },
      "notices": {
        "preLapse": {
          "required": true,
          "recipients": ["OWNER"],
          "content": ["PREMIUM_DELINQUENCY_NOTICE"]
        },
        "lapse": {
          "required": true,
          "recipients": ["OWNER"],
          "content": ["LAPSE_DATE", "REINSTATEMENT_INFO", "NON_FORFEITURE_OPTIONS"]
        },
        "seniorProvision": null
      },
      "reinstatement": {
        "minimumPeriod": 3,
        "periodUnit": "YEARS"
      }
    }
  }
}
```

---

## 13. BPMN Process Flows

### 13.1 Lapse Processing BPMN

```mermaid
flowchart TD
    Start([Start: Grace Period Expired]) --> A[Verify Grace Period Has Expired]
    A --> B{All Required Notices Sent?}
    B -->|No| C[Send Missing Notices]
    C --> D[Wait for Notice Compliance Period]
    D --> B
    B -->|Yes| E{APL Elected?}
    E -->|Yes| F[Attempt APL Processing]
    F --> G{APL Successful?}
    G -->|Yes| H[Policy Continues In-Force]
    G -->|No| I{Cash Surrender Value > 0?}
    E -->|No| I
    I -->|No| J[Lapse Without Value]
    J --> K[Set Status to LAPSED]
    K --> L[Generate Lapse Notice]
    L --> M[Open Reinstatement Window]
    I -->|Yes| N{Non-Forfeiture Option?}
    N -->|Cash Surrender| O[Process Cash Surrender]
    O --> P[Disburse Funds]
    P --> Q[Generate 1099-R]
    Q --> K
    N -->|Extended Term| R[Calculate ETI]
    R --> S[Convert to ETI Policy]
    S --> T[Set ETI Expiry Date]
    T --> U[Generate ETI Confirmation]
    U --> M
    N -->|Reduced Paid-Up| V[Calculate RPU]
    V --> W[Convert to RPU Policy]
    W --> X[Set RPU Face Amount]
    X --> Y[Generate RPU Confirmation]
    Y --> M
    N -->|Default - No Election| Z[Apply Default NF Option per Contract]
    Z --> N
    M --> End([End])
    H --> End
```

### 13.2 Reinstatement Processing BPMN

```mermaid
flowchart TD
    Start([Start: Reinstatement Request]) --> A[Verify Within Reinstatement Period]
    A --> B{Within Period?}
    B -->|No| C[Reject - Reinstatement Period Expired]
    C --> End1([End])
    B -->|Yes| D{Within Auto-Reinstate Window - 30 Days?}
    D -->|Yes| E[Simplified Processing]
    E --> F{Premium Paid and Health Declaration OK?}
    F -->|Yes| G[Auto-Reinstate]
    F -->|No| H[Standard Processing]
    D -->|No| H
    H --> I[Determine Evidence of Insurability Required]
    I --> J{Evidence Satisfactory?}
    J -->|Pending| K[Await Evidence]
    K --> J
    J -->|Declined| L[Reject Reinstatement]
    L --> End2([End])
    J -->|Approved| M[Calculate Financial Requirements]
    M --> N[Back Premiums + Interest + Loan Restoration]
    N --> O{Payment Received?}
    O -->|No| P[Await Payment]
    P --> O
    O -->|Yes| Q[Apply Payments]
    Q --> R[Restore Policy to In-Force]
    G --> R
    R --> S[Reset Contestability Period]
    S --> T[Restore Riders if Applicable]
    T --> U[Update All Policy Values]
    U --> V[Generate Reinstatement Confirmation]
    V --> W[Notify Agent]
    W --> End3([End])
```

### 13.3 Non-Forfeiture Election BPMN

```mermaid
flowchart TD
    Start([Start: Non-Forfeiture Triggered]) --> A[Retrieve Policyholder's NF Election]
    A --> B{Election on File?}
    B -->|Yes| C[Apply Elected Option]
    B -->|No| D[Apply Contract Default]
    C --> E{Which Option?}
    D --> E
    E -->|Cash Surrender| F[Calculate Net Surrender Value]
    F --> G[Deduct Surrender Charges]
    G --> H[Offset Outstanding Loans]
    H --> I[Calculate Tax Withholding]
    I --> J[Disburse Net Amount]
    J --> K[Generate 1099-R]
    K --> L[Terminate Policy]
    E -->|Extended Term| M[Calculate Available NSV for ETI]
    M --> N[Calculate NSP for Term at Attained Age]
    N --> O[Determine Maximum Duration]
    O --> P{Duration > 0?}
    P -->|Yes| Q[Create ETI Coverage Record]
    Q --> R[Terminate Riders]
    R --> S[Generate ETI Confirmation]
    P -->|No| T[Insufficient Value - Default to Cash Surrender]
    T --> F
    E -->|Reduced Paid-Up| U[Calculate Available NSV for RPU]
    U --> V[Calculate NSP for Whole Life at Attained Age]
    V --> W[Determine RPU Face Amount]
    W --> X{RPU Face > Minimum Face?}
    X -->|Yes| Y[Create RPU Coverage Record]
    Y --> Z[Update Policy to RPU Status]
    Z --> AA[Generate RPU Confirmation]
    X -->|No| AB[Insufficient Value - Default to Cash Surrender]
    AB --> F
    L --> End([End])
    S --> End
    AA --> End
```

---

## 14. Calculation Examples with Real Numbers

### 14.1 Complete ETI Calculation Example

**Policy Details:**

| Parameter | Value |
|-----------|-------|
| Product | Whole Life |
| Face Amount | $500,000 |
| Issue Age | 40 Male Non-Smoker |
| Issue Date | June 15, 2010 |
| Lapse Date | June 15, 2025 |
| Attained Age at Lapse | 55 |
| Annual Premium | $8,750 |
| Premiums Paid (15 years) | $131,250 |
| Guaranteed Cash Value at Year 15 | $98,500 |
| Accumulated Dividends | $12,750 |
| PUA Cash Value | $5,200 |
| Outstanding Loan | $20,000 |
| Accrued Loan Interest | $1,000 |
| Mortality Table | 2001 CSO Male Non-Smoker |
| Non-Forfeiture Interest Rate | 4.0% |

**Step-by-Step Calculation:**

| Step | Calculation | Amount |
|------|-------------|--------|
| 1. Gross Cash Value | $98,500 + $12,750 + $5,200 | **$116,450** |
| 2. Less: Surrender Charge (Year 15 = $0) | $0 | **$0** |
| 3. Cash Surrender Value | $116,450 − $0 | **$116,450** |
| 4. Less: Outstanding Loans | $20,000 + $1,000 | **$21,000** |
| 5. Net Surrender Value for ETI | $116,450 − $21,000 | **$95,450** |
| 6. Face Amount for ETI | Original face less loans: $500,000 − $20,000 | **$480,000** |
| 7. NSP per $1,000 at age 55 for various terms | (from actuarial tables) | |
| - 20 years | | $153.42 |
| - 25 years | | $206.18 |
| - 30 years | | $274.53 |
| 8. NSP for $480,000 face for 25 years | $206.18 × 480 | **$98,966.40** |
| 9. NSP for $480,000 face for 24 years | $198.75 × 480 | **$95,400.00** |
| 10. NSP for $480,000 face for 24y 1m | Interpolated | **$95,585.00** |
| 11. Maximum ETI Duration | 24 years, 0 months | **24 years** |
| 12. ETI Expiry Date | June 15, 2025 + 24 years | **June 15, 2049** |
| 13. Excess value | $95,450 − $95,400 | **$50** |

### 14.2 Complete RPU Calculation Example

**Using Same Policy Details as Above:**

| Step | Calculation | Amount |
|------|-------------|--------|
| 1. Net Surrender Value | (Same as ETI) | **$95,450** |
| 2. NSP per $1,000 for Paid-Up WL at age 55 | From 2001 CSO Male NS at 4.0% | **$385.42** |
| 3. RPU Face Amount | ($95,450 / $385.42) × $1,000 | **$247,629** |
| 4. Reduction from original | ($500,000 − $247,629) / $500,000 | **50.47%** |
| 5. RPU Initial Cash Value | Equals net surrender value | **$95,450** |
| 6. RPU at Maturity (Age 100) | Endowment for $247,629 | **$247,629** |
| 7. Dividend Eligibility | Original is participating | **Yes** |

### 14.3 Complete Cash Surrender Value Calculation

**Using Same Policy Details:**

| Step | Calculation | Amount |
|------|-------------|--------|
| 1. Gross Cash Value | $98,500 + $12,750 + $5,200 | **$116,450** |
| 2. Surrender Charge | Year 15 = 0% | **$0** |
| 3. CSV before loan offset | $116,450 − $0 | **$116,450** |
| 4. Outstanding Loan | $20,000 | **($20,000)** |
| 5. Accrued Loan Interest | $1,000 | **($1,000)** |
| 6. Net Surrender Value | $116,450 − $21,000 | **$95,450** |
| 7. Cost Basis | $131,250 − $12,750 (dividends received in cash) | **$118,500** |
| 8. Total Proceeds | $95,450 (check) + $21,000 (loan offset) | **$116,450** |
| 9. Taxable Gain | $116,450 − $118,500 | **$0 (loss)** |
| 10. Federal Withholding | 10% × $0 | **$0** |
| 11. Net Check to Owner | $95,450 − $0 | **$95,450** |

### 14.4 Reinstatement Calculation Example

**Policy Lapsed June 15, 2025. Reinstatement applied October 1, 2025.**

| Component | Calculation | Amount |
|-----------|-------------|--------|
| Monthly premium | $8,750 / 12 (monthly mode) | $729.17 |
| Back premiums (Jul, Aug, Sep) | 3 × $729.17 | **$2,187.50** |
| Current premium (Oct) | 1 × $729.17 | **$729.17** |
| Interest on back premiums | | |
| - Jul premium: 92 days at 5% | $729.17 × 0.05 × 92/365 | $9.19 |
| - Aug premium: 61 days at 5% | $729.17 × 0.05 × 61/365 | $6.09 |
| - Sep premium: 31 days at 5% | $729.17 × 0.05 × 31/365 | $3.10 |
| Total interest | | **$18.38** |
| Loan restoration (if applicable) | $20,000 + $1,000 + additional interest | **$21,420.83** |
| **Total due for reinstatement** | | **$24,355.88** |

---

## 15. Architecture

### 15.1 Lapse Processing Batch Job

```mermaid
graph TB
    subgraph "Nightly Batch Processing"
        J1[Grace Period Monitor Job]
        J2[APL Processing Job]
        J3[Lapse Execution Job]
        J4[NF Benefit Calculation Job]
        J5[Notice Generation Job]
        J6[Reinstatement Expiry Job]
    end

    subgraph "Real-Time Processing"
        R1[Reinstatement Intake Service]
        R2[Reinstatement Underwriting Service]
        R3[Reinstatement Payment Service]
        R4[Reinstatement Completion Service]
    end

    subgraph "Calculation Services"
        C1[ETI Calculator]
        C2[RPU Calculator]
        C3[CSV Calculator]
        C4[Shadow Account Calculator]
        C5[Back Premium Calculator]
    end

    subgraph "Data Stores"
        DB[(Policy DB)]
        ADB[(Audit DB)]
        DMS[(Document Store)]
    end

    subgraph "Integration"
        KAFKA[Apache Kafka]
        CORR[Correspondence Engine]
        TAX[Tax Reporting Engine]
        UW[Underwriting System]
    end

    J1 --> J2
    J2 --> J3
    J3 --> J4
    J4 --> J5
    J5 --> CORR

    J1 --> DB
    J2 --> DB
    J3 --> DB
    J4 --> C1
    J4 --> C2
    J4 --> C3
    J4 --> C4

    R1 --> R2
    R2 --> UW
    R2 --> R3
    R3 --> C5
    R3 --> R4
    R4 --> DB

    J3 --> KAFKA
    R4 --> KAFKA
    J3 --> TAX
    J3 --> ADB
    R4 --> ADB
```

### 15.2 Lapse Processing Batch Job Specification

```json
{
  "jobName": "NIGHTLY_LAPSE_PROCESSING",
  "schedule": "DAILY_0200",
  "description": "Process grace period expirations, APL, lapse, and non-forfeiture benefits",
  "steps": [
    {
      "step": 1,
      "name": "GRACE_PERIOD_MONITOR",
      "description": "Identify policies whose grace period expires today",
      "query": "SELECT * FROM grace_period WHERE end_date = CURRENT_DATE AND status = 'ACTIVE'",
      "action": "Flag for lapse processing",
      "timeout": "15min"
    },
    {
      "step": 2,
      "name": "APL_PROCESSING",
      "description": "Attempt APL for eligible policies before lapse",
      "filter": "Policies with APL elected and CSV > 0",
      "action": "Calculate max APL, create loan, apply premium",
      "onSuccess": "Remove from lapse queue",
      "onFailure": "Continue to lapse processing",
      "timeout": "30min"
    },
    {
      "step": 3,
      "name": "NO_LAPSE_GUARANTEE_TEST",
      "description": "Test shadow account for UL/IUL policies",
      "filter": "UL/IUL policies with no-lapse guarantee",
      "action": "Calculate shadow account value; if positive, prevent lapse",
      "timeout": "20min"
    },
    {
      "step": 4,
      "name": "LAPSE_EXECUTION",
      "description": "Execute lapse for remaining policies",
      "action": "Set status to LAPSED, record lapse event, cancel billing",
      "timeout": "30min"
    },
    {
      "step": 5,
      "name": "NON_FORFEITURE_PROCESSING",
      "description": "Apply non-forfeiture options for lapsed policies with value",
      "subSteps": [
        "Retrieve NF election",
        "Calculate CSV/ETI/RPU as applicable",
        "Apply elected or default option",
        "Generate appropriate records",
        "Generate 1099-R for cash surrenders"
      ],
      "timeout": "45min"
    },
    {
      "step": 6,
      "name": "NOTICE_GENERATION",
      "description": "Generate all required lapse notices per state rules",
      "action": "Apply state decision matrix, generate notices, queue for delivery",
      "timeout": "30min"
    },
    {
      "step": 7,
      "name": "REINSTATEMENT_EXPIRY",
      "description": "Close reinstatement window for policies past the reinstatement period",
      "query": "SELECT * FROM lapse_event WHERE reinstatement_expiry_date = CURRENT_DATE",
      "action": "Mark reinstatement as expired",
      "timeout": "10min"
    }
  ],
  "errorHandling": {
    "policyLevelError": "SKIP_AND_LOG",
    "systemError": "HALT_AND_ALERT",
    "retryPolicy": { "maxRetries": 3, "backoffMinutes": 5 }
  }
}
```

### 15.3 Reinstatement Workflow Service

```pseudocode
class ReinstatementService:
    function processReinstatement(request):
        // Step 1: Validate reinstatement eligibility
        policy = getPolicy(request.policyNumber)
        lapseEvent = getLatestLapseEvent(policy)

        if lapseEvent is null:
            raise PolicyNotLapsedException

        if today() > lapseEvent.reinstatementExpiryDate:
            raise ReinstatementPeriodExpiredException

        // Step 2: Determine evidence requirements
        daysSinceLapse = daysBetween(lapseEvent.lapseDate, today())
        evidenceRequired = determineEvidenceRequirement(daysSinceLapse, policy)

        // Step 3: Check if automatic reinstatement qualifies
        if daysSinceLapse <= 30 and request.healthDeclaration.noChanges:
            return processAutoReinstatement(policy, request)

        // Step 4: Standard reinstatement — submit to underwriting
        uwDecision = submitToUnderwriting(policy, request, evidenceRequired)

        if uwDecision.status == "PENDING":
            return createPendingReinstatement(policy, request, uwDecision)
        elif uwDecision.status == "APPROVED":
            return completeReinstatement(policy, request, uwDecision)
        else:
            return rejectReinstatement(policy, request, uwDecision)

    function completeReinstatement(policy, request, uwDecision):
        // Calculate financial requirements
        backPremiums = calculateBackPremiums(policy, today())
        interest = calculateInterestOnBackPremiums(backPremiums, today())
        loanRestoration = calculateLoanRestoration(policy, today())

        totalDue = backPremiums.total + interest + loanRestoration.amount

        // Verify payment
        if request.paymentAmount < totalDue:
            raise InsufficientPaymentException(totalDue, request.paymentAmount)

        // Execute reinstatement within transaction
        beginTransaction()
        try:
            // Restore policy
            policy.status = IN_FORCE
            policy.lapseDate = null

            // Apply back premiums
            for premium in backPremiums.items:
                applyPremium(policy, premium)

            // Restore loan if applicable
            if loanRestoration.required:
                restoreLoan(policy, loanRestoration)

            // Reset contestability
            if today() > addYears(policy.issueDate, 2):
                policy.contestabilityEndDate = addYears(today(), 2)
                policy.contestabilityType = "REINSTATEMENT"

            // Restore riders if applicable
            restoreEligibleRiders(policy)

            // Update billing schedule
            reactivateBilling(policy)

            commitTransaction()
        except:
            rollbackTransaction()
            raise

        // Post-reinstatement actions
        generateReinstatementConfirmation(policy)
        notifyAgent(policy, "REINSTATEMENT_COMPLETED")
        createAuditRecord(policy, "REINSTATEMENT", request, uwDecision)
        publishEvent("POLICY_REINSTATED", policy)

        return ReinstatementResult(SUCCESS, policy)
```

### 15.4 Non-Forfeiture Calculator Service

```pseudocode
class NonForfeitureCalculator:
    function calculateAllOptions(policy, asOfDate):
        csv = calculateCSV(policy, asOfDate)
        eti = calculateETI(policy, asOfDate)
        rpu = calculateRPU(policy, asOfDate)

        return {
            cashSurrender: {
                netSurrenderValue: csv.netValue,
                taxableGain: csv.taxableGain,
                federalWithholding: csv.withholding,
                netCheck: csv.netCheck
            },
            extendedTerm: {
                faceAmount: eti.faceAmount,
                durationYears: eti.years,
                durationMonths: eti.months,
                expiryDate: eti.expiryDate
            },
            reducedPaidUp: {
                faceAmount: rpu.faceAmount,
                reductionPercent: rpu.reductionPercent,
                dividendEligible: rpu.dividendEligible,
                initialCashValue: rpu.initialCashValue
            },
            defaultOption: policy.nonForfeitureElection or "ETI",
            calculationDate: asOfDate,
            mortalityTable: policy.nonForfeitureMortalityTable,
            interestRate: policy.nonForfeitureInterestRate
        }
```

---

## 16. Sample Payloads

### 16.1 REST API — Reinstatement Application

**Request:**

```http
POST /api/v2/policies/LIF-2024-00012345/reinstatements
Content-Type: application/json
Authorization: Bearer eyJhbGciOiJSUzI1NiIs...

{
  "reinstatementType": "STANDARD",
  "requestedEffectiveDate": "2025-10-01",
  "applicant": {
    "partyId": "PTY-001",
    "name": "John A. Smith",
    "ssn": "***-**-1234"
  },
  "healthDeclaration": {
    "noChangesInHealth": false,
    "detailedResponses": [
      {
        "question": "Have you been hospitalized in the last 12 months?",
        "answer": false
      },
      {
        "question": "Have you been diagnosed with any new medical condition?",
        "answer": false
      },
      {
        "question": "Are you currently taking any new medications?",
        "answer": true,
        "details": "Blood pressure medication (Lisinopril 10mg) started July 2025"
      }
    ]
  },
  "payment": {
    "amount": 3250.00,
    "method": "CHECK",
    "checkNumber": "5678",
    "bankRouting": "021000089"
  },
  "loanDisposition": "RESTORE_LOAN"
}
```

**Response:**

```json
{
  "reinstatementId": "RST-2025-00000456",
  "policyNumber": "LIF-2024-00012345",
  "status": "PENDING_UNDERWRITING",
  "lapseDate": "2025-06-15",
  "daysSinceLapse": 108,
  "evidenceRequired": "HEALTH_STATEMENT_PARAMEDICAL",
  "financialSummary": {
    "backPremiums": [
      { "dueDate": "2025-07-15", "amount": 729.17 },
      { "dueDate": "2025-08-15", "amount": 729.17 },
      { "dueDate": "2025-09-15", "amount": 729.17 }
    ],
    "currentPremium": { "dueDate": "2025-10-15", "amount": 729.17 },
    "interestOnBackPremiums": 18.38,
    "loanRestoration": 0.00,
    "totalAmountDue": 2935.06,
    "paymentReceived": 3250.00,
    "overpayment": 314.94,
    "overpaymentDisposition": "APPLY_TO_NEXT_PREMIUM"
  },
  "underwritingStatus": {
    "currentStep": "HEALTH_STATEMENT_REVIEW",
    "additionalEvidenceNeeded": ["PARAMEDICAL_EXAM"],
    "estimatedDecisionDate": "2025-10-15"
  },
  "nextSteps": [
    "Schedule paramedical exam via ExamOne at 1-800-XXX-XXXX",
    "Provide attending physician statement if requested"
  ]
}
```

### 16.2 REST API — Non-Forfeiture Options Inquiry

**Request:**

```http
GET /api/v2/policies/WL-2015-00054321/non-forfeiture-options?asOfDate=2025-06-15
Authorization: Bearer eyJhbGciOiJSUzI1NiIs...
```

**Response:**

```json
{
  "policyNumber": "WL-2015-00054321",
  "asOfDate": "2025-06-15",
  "policyDetails": {
    "productType": "WHOLE_LIFE",
    "faceAmount": 500000.00,
    "issueAge": 40,
    "attainedAge": 55,
    "issueDate": "2010-06-15",
    "mortalityTable": "2001_CSO_MALE_NS",
    "nonForfeitureInterestRate": 0.04
  },
  "currentValues": {
    "grossCashValue": 116450.00,
    "surrenderCharge": 0.00,
    "cashSurrenderValue": 116450.00,
    "outstandingLoan": 20000.00,
    "accruedLoanInterest": 1000.00,
    "netSurrenderValue": 95450.00,
    "costBasis": 118500.00
  },
  "options": {
    "cashSurrender": {
      "netSurrenderValue": 95450.00,
      "totalProceeds": 116450.00,
      "taxableGain": 0.00,
      "federalWithholding": 0.00,
      "stateWithholding": 0.00,
      "netCheckAmount": 95450.00
    },
    "extendedTermInsurance": {
      "faceAmount": 480000.00,
      "durationYears": 24,
      "durationMonths": 0,
      "expiryDate": "2049-06-15",
      "ridersIncluded": "NONE",
      "loanProvisions": "NOT_AVAILABLE",
      "dividends": "NOT_ELIGIBLE"
    },
    "reducedPaidUp": {
      "rpuFaceAmount": 247629.00,
      "reductionFromOriginal": "50.47%",
      "initialCashValue": 95450.00,
      "premiumsDue": 0.00,
      "dividendEligible": true,
      "policyLoansAvailable": true,
      "maturityDate": "2055-06-15"
    }
  },
  "currentElection": "EXTENDED_TERM",
  "electionChangeDeadline": "2025-07-15",
  "reinstatementEligible": true,
  "reinstatementDeadline": "2028-06-15"
}
```

### 16.3 Kafka Event — Policy Lapsed

```json
{
  "eventId": "EVT-2025-LAPSE-00000789",
  "eventType": "POLICY_LAPSED",
  "eventTimestamp": "2025-06-16T02:45:00.000Z",
  "source": "lapse-processing-batch",
  "policyNumber": "WL-2015-00054321",
  "details": {
    "lapseDate": "2025-06-15",
    "lapseReason": "NONPAYMENT_PREMIUM",
    "lastPremiumPaidDate": "2025-05-15",
    "gracePeriodStart": "2025-05-16",
    "gracePeriodEnd": "2025-06-15",
    "aplAttempted": true,
    "aplResult": "INSUFFICIENT_LOAN_VALUE",
    "cashValueAtLapse": 116450.00,
    "loanBalanceAtLapse": 21000.00,
    "nonForfeitureOptionApplied": "EXTENDED_TERM",
    "etiFaceAmount": 480000.00,
    "etiExpiryDate": "2049-06-15",
    "reinstatementWindow": {
      "startDate": "2025-06-16",
      "endDate": "2028-06-15"
    },
    "noticesGenerated": [
      { "type": "LAPSE_NOTICE", "recipient": "OWNER", "method": "PAPER" },
      { "type": "LAPSE_NOTICE", "recipient": "ASSIGNEE", "method": "PAPER" },
      { "type": "REINSTATEMENT_OFFER", "recipient": "OWNER", "method": "PAPER" }
    ]
  }
}
```

---

## 17. Appendices

### Appendix A: Non-Forfeiture Calculation Quick Reference

| Product | Cash Surrender | Extended Term | Reduced Paid-Up | Default Option |
|---------|---------------|---------------|-----------------|----------------|
| Term 10 | N/A (no CSV) | N/A | N/A | Lapse |
| Term 20 | N/A (no CSV) | N/A | N/A | Lapse |
| Term 30 (ROP) | Return of premium on lapse | N/A | N/A | Cash Surrender |
| Whole Life | CSV per contract table | Full face / calculated duration | Reduced face / permanent | ETI (most carriers) |
| 20-Pay Life | CSV per contract table | Full face / longer duration | Reduced face / permanent | ETI |
| Universal Life | Account value less surrender charge | Generally N/A (carrier-specific) | Generally N/A | Cash Surrender / Lapse |
| Variable UL | Account value (market) less SC | May be available | May be available | Cash Surrender |
| Indexed UL | Account value less SC | Generally N/A | Generally N/A | Cash Surrender |
| Endowment | CSV per contract table | Full face / calculated duration | Reduced face / endowment | Cash Surrender |

### Appendix B: Reinstatement Requirements Quick Reference

| Time Since Lapse | Evidence Required | Back Premium | Interest | Contestability |
|-----------------|-------------------|-------------|---------|---------------|
| 0–30 days | Health declaration only | Current premium only | None | Original continues |
| 31–90 days | Health questionnaire | All missed premiums + current | Statutory rate | May reset |
| 91 days – 1 year | Paramedical exam + questionnaire | All missed + current | Statutory rate | Resets |
| 1–3 years | Full medical + labs | All missed + current | Statutory rate | Resets |
| 3–5 years | Full medical + financial UW | All missed + current | Statutory rate | Resets |

### Appendix C: Shadow Account Interest Rate Reference

| Product Generation | Shadow Account Rate | Guarantee Duration |
|-------------------|--------------------|--------------------|
| IUL (2015–2020) | 3.0%–4.0% | To age 90–100 |
| IUL (2020–2025) | 2.0%–3.0% | To age 95–105 |
| IUL (2025+) | 1.5%–2.5% | To age 100–121 |
| GUL (Guaranteed UL) | 2.0%–3.0% | Lifetime |

### Appendix D: Glossary

| Term | Definition |
|------|-----------|
| **APL** | Automatic Premium Loan — automatic policy loan to pay premium |
| **Contestability Period** | Two-year period during which insurer can contest claims based on misrepresentation |
| **CSV** | Cash Surrender Value — cash value minus surrender charges |
| **ETI** | Extended Term Insurance — non-forfeiture option providing term coverage at full face amount |
| **GMDB** | Guaranteed Minimum Death Benefit — rider guarantee on variable products |
| **Lapse** | Policy termination due to non-payment of premium |
| **MEC** | Modified Endowment Contract — policy failing the IRC §7702A 7-pay test |
| **MVA** | Market Value Adjustment — surrender value adjustment based on interest rate changes |
| **NAR** | Net Amount at Risk — death benefit minus cash value |
| **NF** | Non-Forfeiture — benefits available upon policy lapse |
| **NLG** | No-Lapse Guarantee — secondary guarantee preventing lapse on UL products |
| **NSP** | Net Single Premium — one-time premium for a given benefit; used in ETI/RPU calculations |
| **RPU** | Reduced Paid-Up — non-forfeiture option providing permanent coverage at reduced face |
| **SCRA** | Servicemembers Civil Relief Act — federal law protecting military members |
| **Shadow Account** | Hypothetical account tracking no-lapse guarantee eligibility using guaranteed assumptions |

### Appendix E: Key Actuarial Formulas

**Net Single Premium for Term Insurance:**

```
NSP_term(x, n) = A^1_{x:n|} = Σ(k=0 to n-1) [ v^(k+1) × k_p_x × q_{x+k} ]
```

Where:
- `x` = attained age
- `n` = term in years
- `v` = discount factor = 1 / (1 + i)
- `k_p_x` = probability of surviving k years from age x
- `q_{x+k}` = probability of death in year k+1

**Net Single Premium for Whole Life:**

```
NSP_WL(x) = A_x = Σ(k=0 to ω-x-1) [ v^(k+1) × k_p_x × q_{x+k} ]
```

Where `ω` = limiting age of the mortality table (e.g., 121)

**ETI Duration Determination:**

Solve for `n` in:

```
CSV = NSP_term(x, n) × (Face Amount / 1000)
```

**RPU Face Amount Determination:**

```
RPU Face = CSV / NSP_WL(x) × 1000
```

### Appendix F: References

1. **NAIC Model #808**: Standard Nonforfeiture Law for Life Insurance
2. **IRC §72**: Annuities; Certain Proceeds of Endowment and Life Insurance Contracts
3. **IRC §7702**: Life Insurance Contract Defined
4. **IRC §7702A**: Modified Endowment Contract Defined
5. **2017 CSO Mortality Tables**: Commissioners Standard Ordinary mortality tables
6. **2001 CSO Mortality Tables**: Prior-generation mortality tables (still in use for older policies)
7. **SCRA (50 U.S.C. §3901)**: Servicemembers Civil Relief Act
8. **ACORD TXLife Standard**: Version 2.43.00 — Reinstatement and lapse message types
9. **NAIC Model #613**: Life Insurance and Annuities Replacement Model Regulation
10. **State Insurance Codes**: Individual state requirements for grace periods, notices, and reinstatement
11. **SOA (Society of Actuaries)**: Actuarial standards of practice for non-forfeiture calculations
12. **ASOP No. 2**: Nonforfeiture Benefits for Life Insurance Policies

---

*This article is part of the Life Insurance PAS Architect's Encyclopedia. For related topics, see Article 11 (In-Force Policy Servicing) and Article 12 (Premium Billing & Collection).*
