# Article 13: Reinsurance & Claims Recovery

## Managing Risk Transfer and Financial Recovery in Life Claims

---

## 1. Introduction

Reinsurance is the mechanism by which life insurance carriers transfer portions of their mortality risk to reinsurers. When a death claim occurs, the claims system must determine if reinsurance applies, calculate the recovery amount, notify the reinsurer, and manage the financial recovery. For large face amounts, reinsurance recovery can represent millions of dollars per claim.

---

## 2. Reinsurance Fundamentals for Claims

### 2.1 Reinsurance Types Relevant to Claims

| Type | Description | Claims Impact |
|---|---|---|
| **Automatic/Treaty** | Pre-agreed coverage for blocks of policies meeting criteria | Automatic notification and recovery per treaty terms |
| **Facultative** | Individual risk placement for specific policies | Each policy has unique reinsurance terms |
| **Proportional (Quota Share)** | Reinsurer takes fixed percentage of risk | Calculate percentage of claim |
| **Proportional (Surplus Share)** | Reinsurer takes amount above carrier retention | Calculate excess over retention |
| **Non-Proportional (XOL)** | Excess of Loss - reinsurer pays above threshold | Aggregate threshold analysis |
| **YRT (Yearly Renewable Term)** | Reinsurance on net amount at risk, renewed annually | NAR calculation at time of death |
| **Coinsurance** | Reinsurer shares proportionally in all policy elements | Full proportional sharing |
| **Mod-Co (Modified Coinsurance)** | Similar to coinsurance but reserves stay with cedant | Reserve and claim sharing |

### 2.2 Key Reinsurance Concepts for Claims

```
RETENTION: Amount of risk the carrier retains
  Example: Carrier retention = $500,000
           Face amount = $2,000,000
           Reinsured amount = $1,500,000

NET AMOUNT AT RISK (NAR): For YRT reinsurance
  NAR = Death Benefit - Cash Value (or Reserve)
  Example: Face amount = $1,000,000
           Cash value at death = $150,000
           NAR = $850,000
           If retention on NAR = $250,000
           Reinsured NAR = $600,000

CESSION: The portion of risk transferred to reinsurer
  Example: 40% quota share
           Face amount = $500,000
           Cession = $200,000

MULTIPLE REINSURERS:
  Example: Face amount = $5,000,000
           Carrier retention: $500,000
           Reinsurer A: $2,000,000
           Reinsurer B: $1,500,000
           Reinsurer C: $1,000,000
```

---

## 3. Claims Reinsurance Process Flow

```
REINSURANCE CLAIMS PROCESS:
│
├── 1. IDENTIFY REINSURANCE AT FNOL
│   ├── Query reinsurance system for policy
│   ├── Retrieve treaty/facultative information
│   ├── Determine retention and cession(s)
│   ├── Flag claim for reinsurance processing
│   └── Notify reinsurance team
│
├── 2. REINSURER NOTIFICATION
│   ├── Generate claim notification to reinsurer(s)
│   │   ├── Within treaty-specified timeframe
│   │   ├── Typically within 30-90 days of claim
│   │   └── Immediate notification for large claims
│   ├── Include required information:
│   │   ├── Insured name, DOB, DOD, gender
│   │   ├── Policy number and product type
│   │   ├── Face amount and NAR
│   │   ├── Cause and manner of death
│   │   ├── Retention and cession amounts
│   │   ├── Contestability status
│   │   └── Treaty/facultative reference
│   └── Document notification in claim file
│
├── 3. REINSURER PARTICIPATION IN INVESTIGATION
│   ├── For contestable claims:
│   │   ├── Share investigation findings with reinsurer
│   │   ├── Reinsurer may request additional investigation
│   │   ├── Reinsurer may participate in decision
│   │   └── Joint decision on rescission/compromise
│   ├── For large/complex claims:
│   │   ├── Reinsurer may assign own examiner
│   │   ├── Reinsurer review of benefit calculation
│   │   └── Reinsurer concurrence on decision
│   └── For SIU-referred claims:
│       ├── Share SIU findings
│       ├── Coordinate investigation activities
│       └── Joint decision on fraud determination
│
├── 4. CLAIM DECISION
│   ├── Notify reinsurer of decision (approve/deny)
│   ├── Reinsurer concurrence (per treaty terms)
│   ├── If dispute → Arbitration per treaty
│   └── Document reinsurer agreement
│
├── 5. RECOVERY CALCULATION
│   ├── Calculate ceded amount per treaty terms
│   ├── For proportional: Percentage × claim amount
│   ├── For YRT: Calculate reinsured NAR at DOD
│   ├── For XOL: Aggregate analysis against attachment
│   ├── Interest per treaty terms
│   └── Generate recovery invoice/bordereau
│
├── 6. RECOVERY BILLING
│   ├── Submit claim to reinsurer
│   │   ├── Claim bordereaux (periodic)
│   │   ├── Individual claim submission (large claims)
│   │   └── Electronic submission (ACORD, proprietary)
│   ├── Include supporting documentation:
│   │   ├── Death certificate
│   │   ├── Claim form
│   │   ├── Benefit calculation
│   │   ├── Investigation report (if applicable)
│   │   └── Treaty/fac certificate reference
│   └── Track receivable
│
├── 7. RECOVERY RECEIPT
│   ├── Receive payment from reinsurer
│   ├── Match to claim and treaty
│   ├── Post to accounting
│   │   ├── DR: Cash
│   │   ├── CR: Reinsurance Recoverable
│   │   └── CR: Reinsurance Claim Recovery (if different)
│   ├── Reconcile against expected amount
│   └── Resolve discrepancies
│
└── 8. REPORTING
    ├── Treaty-level reporting
    ├── Reinsurer account statements
    ├── GAAP/STAT financial reporting
    └── Regulatory reporting (Schedule S)
```

---

## 4. Reinsurance Data Model

```json
{
  "reinsuranceClaim": {
    "claimId": "CLM-2025-00789",
    "policyNumber": "LIF-2020-001234",
    "cessions": [
      {
        "cessionId": "CESS-001",
        "treatyNumber": "TY-2020-AUTO-001",
        "treatyType": "YRT",
        "reinsurerCode": "SWISS-RE",
        "reinsurerName": "Swiss Re Life & Health",
        "retentionAmount": 500000,
        "cededAmount": 1500000,
        "cededPercentage": null,
        "netAmountAtRisk": 1400000,
        "reinsuredNAR": 900000,
        "notificationDate": "2025-12-05",
        "notificationMethod": "ELECTRONIC",
        "reinsurerClaimRef": "SR-2025-CLM-5678",
        "reinsurerConcurrence": "PENDING",
        "recoveryAmount": 900000,
        "recoveryStatus": "BILLED",
        "recoveryDate": null,
        "billedDate": "2025-12-20",
        "invoiceNumber": "INV-REIN-2025-001"
      },
      {
        "cessionId": "CESS-002",
        "treatyNumber": "FAC-2020-00456",
        "treatyType": "FACULTATIVE",
        "reinsurerCode": "MUNICH-RE",
        "reinsurerName": "Munich Re",
        "retentionAmount": 500000,
        "cededAmount": 500000,
        "reinsuredNAR": 500000,
        "recoveryAmount": 500000,
        "recoveryStatus": "BILLED"
      }
    ],
    "totalRetention": 500000,
    "totalCeded": 2000000,
    "totalRecoveryExpected": 1400000,
    "totalRecovered": 0
  }
}
```

---

## 5. Reinsurance Arbitration

When the cedant and reinsurer disagree on a claim decision, most treaties provide for arbitration:

```
ARBITRATION PROCESS:
1. Dispute identified (cedant and reinsurer disagree on coverage/amount)
2. Informal resolution attempt (per treaty requirements)
3. Formal arbitration initiated
   ├── Each party selects one arbitrator
   ├── Two arbitrators select an umpire
   └── Panel of three hears the case
4. Hearing conducted
   ├── Evidence presented
   ├── Witnesses examined
   └── Arguments made
5. Panel issues binding decision
6. Losing party pays costs (per treaty terms)

COMMON DISPUTE AREAS:
├── Rescission decision (reinsurer disagrees with rescission or non-rescission)
├── Benefit calculation methodology
├── Late notification penalty
├── Misrepresentation materiality standard
├── Coverage interpretation differences
└── Treaty terms interpretation
```

---

## 6. Summary

Reinsurance is a critical financial component of claims processing. Key principles for architects:

1. **Identify reinsurance early** - Flag reinsured claims at FNOL
2. **Automate notification** - Reinsurer notification should be triggered automatically when thresholds are met
3. **Track recovery lifecycle** - From notification through receipt and reconciliation
4. **Support multiple treaties** - A single claim may involve multiple reinsurers and treaty types
5. **Enable reinsurer collaboration** - Share investigation data per treaty requirements
6. **Reconcile rigorously** - Reinsurance recovery is a significant asset on the balance sheet

---

*Previous: [Article 12: Payment Processing](12-payment-processing.md)*
*Next: [Article 14: Analytics, Reporting & BI for Claims](14-analytics-reporting.md)*
