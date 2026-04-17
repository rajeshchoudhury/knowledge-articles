# Article 12: Payment Processing & Settlement in Life Claims

## End-to-End Financial Settlement Architecture

---

## 1. Introduction

Payment processing is the final and arguably most critical step in the claims lifecycle. Getting money to grieving beneficiaries accurately, securely, and promptly is both a regulatory obligation and the ultimate fulfillment of the insurance promise. This article covers every aspect of payment processing for life insurance claims.

---

## 2. Payment Methods

### 2.1 Payment Method Comparison

| Method | Speed | Cost | Security | Beneficiary Preference | Regulatory Notes |
|---|---|---|---|---|---|
| **Check** | 3-10 days (mail + clear) | Low ($1-3) | Medium (mail risk) | Declining | Still required as option |
| **ACH/EFT** | 1-3 business days | Very Low ($0.25-1) | High | Increasing rapidly | Bank account verification needed |
| **Same-Day ACH** | Same day | Low ($1-5) | High | Preferred for urgency | Amount limits may apply |
| **Wire Transfer** | Same day | High ($15-50) | High | For large amounts | Used for amounts >$1M typically |
| **Retained Asset Account** | Immediate (account established) | Medium | Medium | Mixed opinions | Regulatory scrutiny in some states |

### 2.2 Payment Method Selection Rules

```
PAYMENT METHOD DETERMINATION:

IF beneficiary.preferred_method = "EFT" AND bank_verified = true
  THEN method = "ACH"
  
ELSE IF amount > $1,000,000 AND beneficiary.preferred_method = "WIRE"
  THEN method = "WIRE"
  
ELSE IF beneficiary.preferred_method = "CHECK" OR bank_not_verified
  THEN method = "CHECK"
  
ELSE IF company_policy = "RETAINED_ASSET_DEFAULT" AND amount > threshold
  THEN method = "RETAINED_ASSET_ACCOUNT"
  NOTE: Some states restrict or prohibit RAA without explicit consent

ADDITIONAL RULES:
├── International beneficiary → Wire transfer (SWIFT)
├── Minor beneficiary → Check to guardian/custodian, or UTMA account
├── Trust beneficiary → Per trust documents
├── Estate → Check to estate (per letters testamentary)
├── Attorney → Check to attorney trust account (with proper authorization)
└── Multiple beneficiaries → Separate payment per beneficiary
```

---

## 3. Payment Processing Workflow

### 3.1 End-to-End Payment Flow

```
┌────────────┐   ┌────────────┐   ┌────────────┐   ┌────────────┐
│  AUTHORIZE  │──▶│  VALIDATE  │──▶│  EXECUTE   │──▶│  CONFIRM   │
│             │   │            │   │            │   │            │
│ -Decision   │   │ -Bank acct │   │ -ACH file  │   │ -Delivery  │
│  approved   │   │  verify    │   │ -Check print│   │  confirm   │
│ -Authority  │   │ -OFAC check│   │ -Wire inst │   │ -Return    │
│  check      │   │ -Payee     │   │ -GL post   │   │  handling  │
│ -Calc verify│   │  verify    │   │ -Reins post│   │ -Reconcile │
└────────────┘   │ -Tax calc  │   └────────────┘   └────────────┘
                 └────────────┘

DETAILED STEPS:

1. AUTHORIZATION
   ├── Verify claim decision is APPROVED
   ├── Verify benefit calculation is finalized
   ├── Verify payment amount matches calculation
   ├── Check examiner authority limits
   ├── Obtain supervisor approval if required
   ├── Generate payment authorization record
   └── Create payment instruction

2. PRE-PAYMENT VALIDATION
   ├── Bank account verification (for ACH/EFT)
   │   ├── Micro-deposit verification, OR
   │   ├── Pre-note validation, OR
   │   ├── Real-time bank account verification service
   │   └── NACHA-compliant formatting
   ├── OFAC/Sanctions screening
   │   ├── Screen payee against OFAC SDN list
   │   ├── Screen against other sanctions lists
   │   └── Document screening results
   ├── Payee identity confirmation
   │   ├── Name matches beneficiary on file
   │   ├── Tax ID validated (for 1099)
   │   └── Address current
   ├── Tax withholding calculation
   │   ├── Determine if withholding required
   │   ├── Apply W-4P elections if applicable
   │   └── Calculate withholding amount
   └── Duplicate payment prevention
       ├── Check for existing payments on this claim
       ├── Verify total payments don't exceed benefit
       └── Idempotency check on payment request

3. EXECUTION
   ├── ACH/EFT:
   │   ├── Generate NACHA-formatted ACH file
   │   ├── Submit to ACH processor
   │   ├── Receive ACH acknowledgment
   │   └── Monitor for ACH returns
   ├── CHECK:
   │   ├── Generate check request
   │   ├── Print check (secure printing)
   │   ├── Submit positive pay file to bank
   │   ├── Mail via USPS (certified if required)
   │   └── Track mail delivery
   ├── WIRE:
   │   ├── Generate wire transfer instruction
   │   ├── Submit to bank
   │   ├── Receive wire confirmation
   │   └── Verify receiving bank confirmation
   └── GENERAL:
       ├── Post to general ledger
       ├── Post to reinsurance system
       ├── Generate tax documents
       └── Update claim record

4. CONFIRMATION
   ├── Verify payment delivery/clearing
   ├── Send payment confirmation to beneficiary
   ├── Handle returns/rejections
   ├── Reconcile payment records
   └── Update claim status
```

---

## 4. Tax Processing

### 4.1 Tax Decision Matrix

| Claim Type | Taxable? | Form | Withholding | Notes |
|---|---|---|---|---|
| **Death Benefit (Life)** | No (generally) | None | None | IRC §101(a) exclusion |
| **Interest on Death Benefit** | Yes | 1099-INT | Optional (per W-4P) | Only the interest portion |
| **Annuity Death Benefit** | Partially | 1099-R | Yes (20% default) | Gain = benefit - investment |
| **ADB (Terminal Illness)** | No | 1099-LTC | None | IRC §101(g) |
| **ADB (Chronic Illness)** | Varies | 1099-LTC | None | Per diem limits |
| **Retained Asset Interest** | Yes | 1099-INT | Optional | Interest earned in RAA |
| **Transfer for Value** | Partially | 1099-R | Yes | Gain portion taxable |
| **EOLI** | Varies | Various | Varies | Complex rules (IRC §101(j)) |

### 4.2 1099 Processing

```
1099 PROCESSING WORKFLOW:

DURING YEAR:
├── At payment time: Record 1099-reportable amounts
├── Track payee TIN (SSN/EIN) 
├── Track payee name and address
├── Handle TIN solicitation if not on file
├── B-Notice processing for incorrect TINs
└── Backup withholding if TIN not provided (28%)

YEAR-END:
├── January: Generate 1099 forms
│   ├── 1099-INT: Interest payments
│   ├── 1099-R: Annuity/retirement distributions
│   ├── 1099-LTC: Long-term care and ADB payments
│   └── 1099-MISC: Other reportable payments
├── January 31: Mail forms to recipients
├── February 28: File with IRS (paper)
│   └── March 31: File with IRS (electronic)
├── Corrections: File corrected 1099s as needed
└── Respond to IRS inquiries (B-Notices, CP2100)

TAX WITHHOLDING RULES:
├── 1099-R (Annuity distributions):
│   ├── Default: 20% federal withholding (eligible rollover)
│   ├── Or: 10% if non-eligible rollover
│   ├── Beneficiary can elect different amount on W-4P
│   └── State withholding per state requirements
├── 1099-INT (Interest):
│   ├── No mandatory withholding (unless backup)
│   ├── Beneficiary can request voluntary withholding
│   └── Backup withholding: 24% if TIN not provided
└── 1099-LTC:
    └── No withholding required
```

---

## 5. Special Payment Scenarios

### 5.1 Multiple Beneficiary Payments

```
SCENARIO: Three primary beneficiaries (40%, 35%, 25%)
Total Benefit: $500,000

ALLOCATION:
  Beneficiary A (40%): $200,000
  Beneficiary B (35%): $175,000
  Beneficiary C (25%): $125,000

INTEREST (calculated on each share separately):
  State interest rate: 5% per annum
  Days: 30 days from proof of loss to payment
  
  Beneficiary A interest: $200,000 × 5% × (30/365) = $821.92
  Beneficiary B interest: $175,000 × 5% × (30/365) = $719.18
  Beneficiary C interest: $125,000 × 5% × (30/365) = $513.70

SEPARATE PAYMENTS:
  Beneficiary A: $200,821.92 (EFT)
  Beneficiary B: $175,719.18 (Check)
  Beneficiary C: $125,513.70 (EFT)

SEPARATE 1099-INT:
  Beneficiary A: 1099-INT for $821.92
  Beneficiary B: 1099-INT for $719.18
  Beneficiary C: 1099-INT for $513.70
```

### 5.2 Assignment Payments

```
SCENARIO: Collateral Assignment
Policy Face Amount: $300,000
Collateral Assignment to Bank: $150,000
Remaining to Beneficiary

PAYMENT SPLIT:
  1. Pay Assignee (Bank): $150,000
  2. Pay Beneficiary: $150,000 + interest
  
NOTE: 
  - Assignment amount may be exact or "amount of indebtedness"
  - Contact assignee to determine current indebtedness
  - Any excess over indebtedness goes to beneficiary
  - Different rules for absolute vs. collateral assignment
```

### 5.3 Interpleader Payments

```
SCENARIO: Disputed beneficiary → Interpleader
Benefit Amount: $500,000

PROCESS:
1. Carrier deposits benefit amount + interest with court
2. Carrier files interpleader complaint
3. Court determines rightful beneficiary
4. Court orders payment from deposited funds
5. Carrier is discharged from liability

PAYMENT:
  - Single payment to Clerk of Court
  - Include statutory interest
  - Carrier may deduct attorney fees (varies by jurisdiction)
  - No 1099 issued (court handles distribution tax reporting)
```

---

## 6. General Ledger Integration

### 6.1 Claims Accounting Entries

```
ACCOUNTING ENTRIES FOR CLAIM PAYMENT:

AT CLAIM REPORTING (Reserve Establishment):
  DR: Claim Expense (Income Statement)        $500,000
  CR: Claim Reserve (Liability - Balance Sheet) $500,000

AT CLAIM PAYMENT:
  DR: Claim Reserve (Liability)                $500,000
  CR: Cash / Claims Disbursement Account       $500,000

  DR: Interest Expense                         $    411
  CR: Cash / Claims Disbursement Account       $    411

IF RESERVE ADJUSTMENT NEEDED:
  DR: Claim Expense (if reserve increased)     $  X,XXX
  CR: Claim Reserve                            $  X,XXX
  
  OR
  
  DR: Claim Reserve                            $  X,XXX
  CR: Claim Expense (if reserve decreased)     $  X,XXX

REINSURANCE RECOVERY:
  DR: Reinsurance Recoverable (Asset)          $XXX,XXX
  CR: Reinsurance Claim Recovery (Income)      $XXX,XXX
```

---

## 7. Reconciliation

### 7.1 Payment Reconciliation Process

```
DAILY RECONCILIATION:
├── Match payment instructions to bank confirmations
├── Identify: Issued but not yet cleared
├── Identify: Cleared payments
├── Identify: Returned/rejected payments
├── Identify: Stale-dated checks (>180 days)
├── Calculate: Outstanding payment float
└── Report: Exceptions requiring action

MONTHLY RECONCILIATION:
├── Reconcile claims paid (system) vs. bank disbursements
├── Reconcile GL claim expense vs. payment register
├── Reconcile reinsurance recoveries
├── Reconcile tax withholdings to tax accounts
├── Investigate and resolve discrepancies
└── Management certification of reconciliation

ANNUAL RECONCILIATION:
├── Reconcile total claims paid to financial statements
├── Verify reserve adequacy (actual vs. estimated)
├── Reconcile 1099 reporting to payment records
├── Audit trail verification
└── Regulatory reporting reconciliation
```

---

## 8. Summary

Payment processing is the fulfillment of the insurance promise. Key architectural principles:

1. **Accuracy above all** - Every penny must be correct; benefit calculations must be auditable
2. **Security is paramount** - Financial transactions require the highest security standards
3. **Multiple payment methods** - Support check, ACH, wire, and alternative methods
4. **Tax compliance built-in** - 1099 tracking must be integral, not an afterthought
5. **Regulatory compliance** - Prompt payment laws, interest calculations, and escheatment
6. **Full reconciliation** - Daily, monthly, and annual reconciliation processes
7. **Idempotency** - Prevent duplicate payments through idempotency controls

---

*Previous: [Article 11: Integration Architecture](11-integration-architecture.md)*
*Next: [Article 13: Reinsurance & Claims Recovery](13-reinsurance-recovery.md)*
