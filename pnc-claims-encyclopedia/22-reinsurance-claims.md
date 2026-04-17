# Reinsurance & Claims: Complete Operations Guide

## Table of Contents

1. [Reinsurance Fundamentals for Claims](#1-reinsurance-fundamentals-for-claims)
2. [Treaty Reinsurance Types](#2-treaty-reinsurance-types)
3. [Facultative Reinsurance](#3-facultative-reinsurance)
4. [Reinsurance Program Structure and Claims Impact](#4-reinsurance-program-structure-and-claims-impact)
5. [Claims Notification Requirements](#5-claims-notification-requirements)
6. [Treaty Claims Notification Triggers](#6-treaty-claims-notification-triggers)
7. [Facultative Claims Notification](#7-facultative-claims-notification)
8. [Reinsurance Claims Data Requirements](#8-reinsurance-claims-data-requirements)
9. [Loss Bordereaux Reporting](#9-loss-bordereaux-reporting)
10. [ACORD Reinsurance Messaging Standards](#10-acord-reinsurance-messaging-standards)
11. [Reinsurance Claims Workflow](#11-reinsurance-claims-workflow)
12. [Reserve Posting for Reinsurance](#12-reserve-posting-for-reinsurance)
13. [Reinsurance Payment Processing](#13-reinsurance-payment-processing)
14. [Treaty Claims Accounting](#14-treaty-claims-accounting)
15. [Excess of Loss Claims](#15-excess-of-loss-claims)
16. [Catastrophe Excess of Loss](#16-catastrophe-excess-of-loss)
17. [Aggregate Treaties](#17-aggregate-treaties)
18. [Commutation](#18-commutation)
19. [London Market Claims Processing](#19-london-market-claims-processing)
20. [Lloyd's Claims](#20-lloyds-claims)
21. [Reinsurance Disputes and Arbitration](#21-reinsurance-disputes-and-arbitration)
22. [Subrogation and Salvage in Reinsurance](#22-subrogation-and-salvage-in-reinsurance)
23. [Large Loss Management](#23-large-loss-management)
24. [Reinsurance Claims Data Model](#24-reinsurance-claims-data-model)
25. [Integration: Primary Claims and Reinsurance Systems](#25-integration-primary-claims-and-reinsurance-systems)
26. [Reinsurance Accounting System Integration](#26-reinsurance-accounting-system-integration)
27. [Financial Reporting for Ceded Claims](#27-financial-reporting-for-ceded-claims)
28. [Collateral and Trust Account Management](#28-collateral-and-trust-account-management)
29. [Reinsurance Recoverable Tracking](#29-reinsurance-recoverable-tracking)
30. [Reinsurance Claims Reporting Dashboards](#30-reinsurance-claims-reporting-dashboards)
31. [Technology Platforms](#31-technology-platforms)
32. [Performance Metrics](#32-performance-metrics)

---

## 1. Reinsurance Fundamentals for Claims

### 1.1 What Is Reinsurance

Reinsurance is insurance purchased by an insurance company (the cedent or ceding company) from another insurance company (the reinsurer) to transfer a portion of risk. From a claims perspective, reinsurance determines how loss costs are shared between the primary carrier and its reinsurers.

```
REINSURANCE RELATIONSHIP:
+------------------------------------------------------------------+
|                                                                  |
|  POLICYHOLDER                                                    |
|       |                                                          |
|       | (policy contract)                                        |
|       v                                                          |
|  PRIMARY INSURER (Cedent)                                        |
|       |                                                          |
|       | (reinsurance contract)                                    |
|       v                                                          |
|  REINSURER                                                       |
|       |                                                          |
|       | (retrocession contract)                                   |
|       v                                                          |
|  RETROCESSIONAIRE                                                |
|                                                                  |
|  KEY PRINCIPLES:                                                 |
|  - Policyholder has no direct relationship with reinsurer        |
|  - Cedent remains fully liable to policyholder                   |
|  - Reinsurance is a separate contract between insurer/reinsurer  |
|  - "Follow the fortunes" / "Follow the settlements" doctrines   |
|  - Utmost good faith (uberrima fides) between parties           |
|                                                                  |
+------------------------------------------------------------------+
```

### 1.2 Why Reinsurance Matters for Claims

| Claims Impact Area | Description |
|-------------------|-------------|
| **Reserve Posting** | Claims reserves must be split into gross, ceded, and net components |
| **Payment Processing** | Large payments may trigger reinsurance recovery |
| **Notification** | Claims exceeding thresholds must be reported to reinsurers |
| **Large Loss Management** | Reinsurers may be involved in claims decisions |
| **Financial Reporting** | Ceded reserves and recoverables affect financial statements |
| **Cash Flow** | Reinsurance recoveries affect liquidity and cash management |
| **Settlement Authority** | Large settlements may require reinsurer consent |

### 1.3 Key Terminology

```
REINSURANCE CLAIMS TERMINOLOGY:
+------------------------------------------------------------------+
| Term                  | Definition                                 |
+------------------------------------------------------------------+
| Cedent/Ceding Co.     | Primary insurer that buys reinsurance      |
| Reinsurer             | Company providing reinsurance coverage      |
| Retrocession          | Reinsurance of reinsurance                 |
| Retention             | Amount kept by cedent before RI applies    |
| Cession               | Amount of risk transferred to reinsurer    |
| Treaty                | Automatic reinsurance for a class of risks |
| Facultative           | Individual risk reinsurance placement       |
| Bordereaux            | Detailed listing of premiums/losses ceded  |
| Cash Call             | Request for reinsurance payment            |
| Commutation           | Agreement to terminate reinsurance contract|
| Follow the Fortunes   | Reinsurer follows cedent's claims decisions|
| Net Retention         | Amount of risk retained by cedent          |
| Gross Loss            | Total loss before reinsurance              |
| Net Loss              | Loss after reinsurance recoveries          |
| Ceded Loss            | Portion of loss transferred to reinsurers  |
| ALAE                  | Allocated Loss Adjustment Expense          |
| ULAE                  | Unallocated Loss Adjustment Expense        |
| ECO                   | Extra-Contractual Obligations              |
| XPL                   | Excess of Policy Limits                    |
+------------------------------------------------------------------+
```

---

## 2. Treaty Reinsurance Types

### 2.1 Proportional (Pro-Rata) Treaties

```
PROPORTIONAL TREATY TYPES:
+====================================================================+
|                                                                    |
|  QUOTA SHARE TREATY                                                |
|  +--------------------------------------------------------------+  |
|  |                                                              |  |
|  |  Fixed percentage of every risk is ceded                     |  |
|  |  Example: 40% Quota Share                                    |  |
|  |                                                              |  |
|  |  Policy limit: $1,000,000                                    |  |
|  |  Cedent retains: 60% = $600,000                              |  |
|  |  Reinsurer share: 40% = $400,000                             |  |
|  |                                                              |  |
|  |  Claim of $500,000:                                          |  |
|  |  Cedent pays: $300,000 (60%)                                 |  |
|  |  Reinsurer pays: $200,000 (40%)                              |  |
|  |                                                              |  |
|  |  CHARACTERISTICS:                                            |  |
|  |  - Simple to administer                                      |  |
|  |  - Proportional premium sharing                              |  |
|  |  - Ceding commission paid by reinsurer                       |  |
|  |  - Every claim has reinsurance participation                  |  |
|  |  - Used for: surplus relief, capacity, new market entry      |  |
|  |                                                              |  |
|  +--------------------------------------------------------------+  |
|                                                                    |
|  SURPLUS SHARE TREATY                                              |
|  +--------------------------------------------------------------+  |
|  |                                                              |  |
|  |  Cession based on multiples of cedent's retention line       |  |
|  |  Only risks exceeding the line are ceded                     |  |
|  |                                                              |  |
|  |  Example: Line = $500K, 9-line surplus treaty                |  |
|  |  Maximum cession: $4,500,000 (9 × $500K)                    |  |
|  |  Maximum capacity: $5,000,000 (line + surplus)               |  |
|  |                                                              |  |
|  |  Risk A: $2,000,000 policy limit                             |  |
|  |    Cedent retains: $500,000 (1 line)                         |  |
|  |    Ceded: $1,500,000 (3 lines)                               |  |
|  |    Ceded %: 75%                                              |  |
|  |                                                              |  |
|  |  Risk B: $400,000 policy limit                               |  |
|  |    Cedent retains: $400,000 (< 1 line, no cession)           |  |
|  |    Ceded: $0                                                 |  |
|  |                                                              |  |
|  |  Claim on Risk A for $800,000:                               |  |
|  |    Cedent pays: $200,000 (25%)                               |  |
|  |    Reinsurer pays: $600,000 (75%)                            |  |
|  |                                                              |  |
|  |  CHARACTERISTICS:                                            |  |
|  |  - More complex administration                               |  |
|  |  - Cession varies by risk size                               |  |
|  |  - Better leverage of capacity                               |  |
|  |  - Small risks entirely retained                             |  |
|  |                                                              |  |
|  +--------------------------------------------------------------+  |
|                                                                    |
+====================================================================+
```

### 2.2 Non-Proportional (Excess of Loss) Treaties

```
EXCESS OF LOSS TREATY TYPES:
+====================================================================+
|                                                                    |
|  PER RISK EXCESS OF LOSS (Working Layer XOL)                       |
|  +--------------------------------------------------------------+  |
|  |                                                              |  |
|  |  Reinsurer pays when a SINGLE RISK loss exceeds retention    |  |
|  |  Example: $500K xs $500K per risk                            |  |
|  |                                                              |  |
|  |  Retention: $500,000 (cedent pays first $500K)               |  |
|  |  Limit: $500,000 (reinsurer pays up to $500K excess)         |  |
|  |                                                              |  |
|  |  Claim of $800,000 on single risk:                           |  |
|  |    Cedent pays: $500,000 (retention)                         |  |
|  |    Reinsurer pays: $300,000 ($800K - $500K retention)        |  |
|  |                                                              |  |
|  |  Claim of $1,200,000 on single risk:                         |  |
|  |    Cedent pays: $500K retention + $200K excess above limit   |  |
|  |    Reinsurer pays: $500,000 (limit)                          |  |
|  |                                                              |  |
|  +--------------------------------------------------------------+  |
|                                                                    |
|  PER OCCURRENCE EXCESS OF LOSS (Cat XOL)                           |
|  +--------------------------------------------------------------+  |
|  |                                                              |  |
|  |  Reinsurer pays when AGGREGATE losses from a single          |  |
|  |  OCCURRENCE exceed the retention                              |  |
|  |                                                              |  |
|  |  Example: $10M xs $5M per occurrence                         |  |
|  |                                                              |  |
|  |  Hurricane causing $12M in losses across many policies:      |  |
|  |    Cedent pays: $5M (retention) + $0 (under limit)           |  |
|  |    Reinsurer pays: $7M ($12M - $5M retention)                |  |
|  |                                                              |  |
|  |  Hurricane causing $20M in losses:                           |  |
|  |    Cedent pays: $5M retention + $5M excess above limit       |  |
|  |    Reinsurer pays: $10M (limit)                              |  |
|  |                                                              |  |
|  +--------------------------------------------------------------+  |
|                                                                    |
|  AGGREGATE EXCESS OF LOSS (Stop Loss)                              |
|  +--------------------------------------------------------------+  |
|  |                                                              |  |
|  |  Reinsurer pays when TOTAL annual losses exceed attachment   |  |
|  |  point (expressed as loss ratio or dollar amount)             |  |
|  |                                                              |  |
|  |  Example: 80% xs 60% annual aggregate (loss ratio basis)     |  |
|  |                                                              |  |
|  |  Annual premium: $10,000,000                                 |  |
|  |  Attachment: 60% LR = $6,000,000                             |  |
|  |  Limit: 80% LR = $8,000,000                                 |  |
|  |                                                              |  |
|  |  If annual losses = $11,000,000 (110% LR):                  |  |
|  |    Cedent pays: $6M + $3M above limit = $9M                 |  |
|  |    Reinsurer pays: $8M - $6M = ??? NO...                     |  |
|  |                                                              |  |
|  |    Attachment: $6M (60% of $10M premium)                     |  |
|  |    Limit: $8M (80% × $10M = $8M in additional losses)       |  |
|  |    Cedent pays: $6M (below attachment) + ($11M-$6M-$8M=$0)  |  |
|  |    Actually: $6M retention + ($11M-$14M)=excess is $0        |  |
|  |    Reinsurer pays: $5M ($11M - $6M, capped at $8M)          |  |
|  |    Cedent net: $6M                                           |  |
|  |                                                              |  |
|  +--------------------------------------------------------------+  |
|                                                                    |
+====================================================================+
```

---

## 3. Facultative Reinsurance

### 3.1 Facultative Placement

```
FACULTATIVE REINSURANCE PROCESS:
+------------------------------------------------------------------+
|                                                                  |
|  WHAT IS FACULTATIVE:                                            |
|  ├── Individual risk-by-risk reinsurance placement               |
|  ├── Cedent chooses to offer; reinsurer chooses to accept        |
|  ├── Each placement results in a Facultative Certificate         |
|  ├── Used for: large/unusual risks, treaty exclusions, overflow  |
|  └── Higher administrative burden than treaty                    |
|                                                                  |
|  PLACEMENT FLOW:                                                 |
|  ├── 1. Underwriter identifies need for fac placement            |
|  ├── 2. Submission to fac broker or direct to reinsurer          |
|  ├── 3. Reinsurer evaluates risk and quotes terms                |
|  ├── 4. Negotiation and binding                                  |
|  ├── 5. Certificate issued                                       |
|  └── 6. Claims notification per certificate terms                |
|                                                                  |
|  CERTIFICATE DATA:                                               |
|  +------------------------------------------------------------+  |
|  | Field                    | Description                      |  |
|  +------------------------------------------------------------+  |
|  | Certificate Number       | Unique identifier                |  |
|  | Cedent                   | Primary insurer name             |  |
|  | Reinsurer                | Reinsurer name(s) and shares     |  |
|  | Type                     | Proportional or Excess           |  |
|  | Underlying Policy        | Policy number and insured        |  |
|  | Risk Description         | Nature and location of risk      |  |
|  | Ceded Share / Layer      | % ceded or XOL layer             |  |
|  | Effective/Expiry Dates   | Coverage period                  |  |
|  | Premium                  | Ceded premium amount             |  |
|  | Ceding Commission        | Commission % (proportional)      |  |
|  | Claims Notification      | Notification threshold           |  |
|  | Claims Agreement         | Claims cooperation clause        |  |
|  | Arbitration              | Dispute resolution mechanism     |  |
|  +------------------------------------------------------------+  |
|                                                                  |
+------------------------------------------------------------------+
```

### 3.2 Facultative vs Treaty Claims Handling

| Aspect | Treaty | Facultative |
|--------|--------|-------------|
| Notification | Threshold-based; batch reporting | Individual claim notification |
| Reinsurer Involvement | Limited (usually follow the fortunes) | May require claims cooperation |
| Settlement Authority | Cedent controls (within treaty terms) | May need reinsurer consent |
| Reporting | Bordereaux (monthly/quarterly) | Individual claim reporting |
| Recovery | Through bordereaux or cash calls | Individual billing per certificate |
| Documentation | Summarized | Detailed claim file sharing |
| Claims Agreement | Standardized treaty terms | Certificate-specific terms |

---

## 4. Reinsurance Program Structure and Claims Impact

### 4.1 Typical Reinsurance Program

```
SAMPLE REINSURANCE PROGRAM STRUCTURE:
+====================================================================+
|                                                                    |
|  Layer 4: $20M xs $30M Cat XOL (Per Occurrence)                   |
|  +---------+--------+--------+--------+---------+                  |
|  | Swiss Re| Munich | Hannov | SCOR   | Partner |                  |
|  | 30%     | 25%    | 20%    | 15%    | 10%     |                  |
|  +---------+--------+--------+--------+---------+                  |
|  $50M ............................................................  |
|                                                                    |
|  Layer 3: $15M xs $15M Cat XOL (Per Occurrence)                   |
|  +---------+--------+--------+---------+                           |
|  | Swiss Re| Munich | SCOR   | Everest |                           |
|  | 35%     | 30%    | 20%    | 15%     |                           |
|  +---------+--------+--------+---------+                           |
|  $30M ............................................................  |
|                                                                    |
|  Layer 2: $10M xs $5M Cat XOL (Per Occurrence)                    |
|  +---------+--------+--------+                                     |
|  | Swiss Re| Gen Re | RenRe  |                                     |
|  | 40%     | 35%    | 25%    |                                     |
|  +---------+--------+--------+                                     |
|  $15M ............................................................  |
|                                                                    |
|  Layer 1: $3M xs $2M Per Risk XOL                                 |
|  +---------+--------+                                              |
|  | Gen Re  | Munich |                                              |
|  | 60%     | 40%    |                                              |
|  +---------+--------+                                              |
|  $5M .............................................................  |
|                                                                    |
|  Retention: $2M per risk / $5M per occurrence                     |
|  ╔════════════════════════════════════════════╗                     |
|  ║  CEDENT RETENTION                          ║                     |
|  ╚════════════════════════════════════════════╝                     |
|  $0  .............................................................  |
|                                                                    |
|  ADDITIONALLY:                                                     |
|  40% Quota Share on first $2M (shared retention)                  |
|  Various Facultative certificates for large individual risks       |
|                                                                    |
+====================================================================+
```

### 4.2 Claims Flow Through Program

```
LOSS FLOW THROUGH REINSURANCE PROGRAM:
+------------------------------------------------------------------+
|                                                                  |
|  SCENARIO: Single risk fire loss = $4,500,000                    |
|                                                                  |
|  Step 1: Gross Loss                                              |
|  Total claim: $4,500,000                                         |
|                                                                  |
|  Step 2: Quota Share (40% on first $2M)                          |
|  QS applies to first $2,000,000:                                 |
|    Cedent: $1,200,000 (60%)                                      |
|    QS Reinsurer: $800,000 (40%)                                  |
|                                                                  |
|  Step 3: Per Risk XOL ($3M xs $2M)                               |
|  Net loss to cedent after QS on first $2M: $3,700,000            |
|  Actually: $4,500,000 gross - $800,000 QS recovery = $3,700,000  |
|                                                                  |
|  XOL applies to GROSS loss per risk:                              |
|  $4,500,000 gross loss on single risk                            |
|  XOL layer: $3M xs $2M                                           |
|  XOL recovery: $2,500,000 ($4.5M - $2M retention, capped at $3M)|
|                                                                  |
|  NOTE: Treaty terms specify whether QS applies before or after   |
|  XOL ("netting down" provisions vary by contract)                |
|                                                                  |
|  Step 4: Net Retained Loss                                       |
|  Gross: $4,500,000                                               |
|  Less QS recovery: ($800,000)                                    |
|  Less XOL recovery: ($2,500,000)                                 |
|  Net retained: $1,200,000                                        |
|                                                                  |
+------------------------------------------------------------------+
```

---

## 5. Claims Notification Requirements

### 5.1 Notification Obligations

```
REINSURANCE CLAIMS NOTIFICATION FRAMEWORK:
+------------------------------------------------------------------+
|                                                                  |
|  CONTRACTUAL NOTIFICATION REQUIREMENTS:                          |
|  ├── Prompt notice of claims likely to involve reinsurance       |
|  ├── Specific thresholds trigger mandatory notification          |
|  ├── Failure to notify can jeopardize recovery                   |
|  └── "As soon as reasonably practicable" standard                |
|                                                                  |
|  TYPICAL THRESHOLD TRIGGERS:                                     |
|  +------------------------------------------------------------+  |
|  | Treaty Type       | Notification Trigger                    |  |
|  +------------------------------------------------------------+  |
|  | Quota Share        | Often: all claims above $X threshold   |  |
|  |                    | or monthly bordereaux reporting         |  |
|  | Surplus Share      | All claims on ceded risks > threshold  |  |
|  | Per Risk XOL       | Reserves > 50-75% of retention         |  |
|  | Cat XOL            | Event likely to exceed retention        |  |
|  | Aggregate XOL      | Aggregate tracking; notice when likely  |  |
|  |                    | to reach attachment point              |  |
|  | Facultative        | Per certificate terms; often immediate |  |
|  +------------------------------------------------------------+  |
|                                                                  |
|  NOTIFICATION CONTENT:                                           |
|  ├── Claim number and identification                             |
|  ├── Date of loss / occurrence                                   |
|  ├── Policy information (number, limits, insured)                |
|  ├── Description of loss / occurrence                            |
|  ├── Current reserves (gross, ceded, net)                        |
|  ├── Payments to date (gross, ceded, net)                        |
|  ├── Applicable reinsurance contract(s)                          |
|  ├── Estimated ultimate loss                                     |
|  ├── Coverage issues or disputes                                 |
|  └── Subrogation or salvage potential                            |
|                                                                  |
+------------------------------------------------------------------+
```

### 5.2 Notification Timing

| Scenario | Timing Requirement | Best Practice |
|----------|-------------------|---------------|
| Large individual loss | Within 7-30 days of knowledge | Immediate verbal, written within 7 days |
| Catastrophe event | Within 48-72 hours of event | Preliminary notice within 24 hours |
| Reserve increase above threshold | Within 30 days of reserve change | Immediate notification |
| Settlement exceeding threshold | Before settlement execution | Pre-settlement notice and consultation |
| Litigation filing | Within 30 days of service | Immediate upon attorney involvement |
| Coverage dispute | Upon identification | Prompt notice |

---

## 6. Treaty Claims Notification Triggers

### 6.1 Threshold Monitoring

```
TREATY NOTIFICATION TRIGGER SYSTEM:
+------------------------------------------------------------------+
|                                                                  |
|  AUTOMATED MONITORING:                                           |
|  ├── Every reserve change checked against treaty thresholds      |
|  ├── Every payment checked against treaty thresholds             |
|  ├── Aggregate tracking for cat and stop-loss treaties           |
|  ├── Event aggregation monitoring for occurrence treaties        |
|  └── Alerts generated when thresholds approached or breached     |
|                                                                  |
|  THRESHOLD TYPES:                                                |
|  +------------------------------------------------------------+  |
|  | Type              | Example                | Action          |  |
|  +------------------------------------------------------------+  |
|  | Informational     | Reserve > $250K        | Info notice     |  |
|  | Reporting         | Reserve > 50% of       | Formal report   |  |
|  |                   | retention              |                 |  |
|  | Consultation      | Reserve > 75% of       | Seek input      |  |
|  |                   | retention              |                 |  |
|  | Authorization     | Settlement > $X or     | Get approval    |  |
|  |                   | > retention            |                 |  |
|  +------------------------------------------------------------+  |
|                                                                  |
|  MONITORING DATA FLOW:                                           |
|                                                                  |
|  Claims System → Reserve/Payment Change Event                    |
|       ↓                                                          |
|  Reinsurance Module: Check all applicable treaties               |
|       ↓                                                          |
|  Compare gross incurred vs treaty thresholds                     |
|       ↓                                                          |
|  Threshold breached? → Generate notification                     |
|       ↓                                                          |
|  Route to RI claims analyst for review and transmission          |
|       ↓                                                          |
|  Transmit to reinsurer(s) via email/portal/EDI                   |
|       ↓                                                          |
|  Log notification in reinsurance system                          |
|                                                                  |
+------------------------------------------------------------------+
```

---

## 7. Facultative Claims Notification

### 7.1 Certificate-Level Notification

```
FACULTATIVE CLAIMS NOTIFICATION:
+------------------------------------------------------------------+
|                                                                  |
|  NOTIFICATION PROCESS:                                           |
|  ├── Each fac certificate has specific notification terms        |
|  ├── Typically requires prompt notice of any claim               |
|  ├── Claims cooperation clause may require:                     |
|  │   ├── Copy of all claim correspondence                       |
|  │   ├── Prior approval for settlements above threshold          |
|  │   ├── Right to associate in defense                          |
|  │   └── Regular status reports                                 |
|  └── Failure to comply: potential coverage dispute               |
|                                                                  |
|  FAC NOTIFICATION CONTENT:                                       |
|  ├── Certificate number                                         |
|  ├── Underlying policy number and insured name                  |
|  ├── Claim number                                               |
|  ├── Date of loss                                               |
|  ├── Description of claim                                       |
|  ├── Current status                                             |
|  ├── Gross reserves and payments                                 |
|  ├── Ceded share calculation                                     |
|  ├── Anticipated reinsurance recovery                            |
|  ├── Defense counsel (if appointed)                              |
|  ├── Coverage issues                                             |
|  └── Recommended action/strategy                                 |
|                                                                  |
|  APPROVAL REQUIREMENTS:                                          |
|  ├── Settlements exceeding $ threshold                           |
|  ├── Extra-contractual exposure                                  |
|  ├── Coverage opinions / disclaimers                             |
|  └── Appointment of coverage counsel                             |
|                                                                  |
+------------------------------------------------------------------+
```

---

## 8. Reinsurance Claims Data Requirements

### 8.1 Core Data Elements

```
REINSURANCE CLAIMS DATA REQUIREMENTS:
+------------------------------------------------------------------+
| Category              | Data Elements                             |
+------------------------------------------------------------------+
| CLAIM IDENTIFICATION  | - Claim number                            |
|                       | - Occurrence/event number                 |
|                       | - Policy number                           |
|                       | - Insured name                            |
|                       | - Date of loss                            |
|                       | - Date reported                           |
|                       | - State/jurisdiction                      |
|                       | - Line of business                        |
|                       | - Cause of loss                           |
+------------------------------------------------------------------+
| COVERAGE              | - Policy effective/expiry dates           |
|                       | - Policy limits                           |
|                       | - Deductible/SIR                          |
|                       | - Coverage type                           |
|                       | - Coverage issues/disputes                |
+------------------------------------------------------------------+
| FINANCIAL (GROSS)     | - Gross paid loss                         |
|                       | - Gross paid ALAE                         |
|                       | - Gross outstanding loss reserve          |
|                       | - Gross outstanding ALAE reserve          |
|                       | - Gross incurred (paid + outstanding)     |
|                       | - Salvage and subrogation received        |
|                       | - Salvage and subrogation anticipated     |
+------------------------------------------------------------------+
| FINANCIAL (CEDED)     | - Treaty/certificate identification       |
|                       | - Ceded paid loss                         |
|                       | - Ceded paid ALAE                         |
|                       | - Ceded outstanding loss reserve          |
|                       | - Ceded outstanding ALAE reserve          |
|                       | - Ceded incurred                          |
|                       | - Net retained loss                       |
|                       | - Net retained ALAE                       |
+------------------------------------------------------------------+
| REINSURANCE SPECIFIC  | - Treaty/contract number                  |
|                       | - Treaty year                             |
|                       | - Reinsurer name(s) and shares            |
|                       | - Retention amount                        |
|                       | - Ceded percentage or layer               |
|                       | - Recovery calculation                    |
|                       | - Notification date                       |
|                       | - Notification status                     |
+------------------------------------------------------------------+
| CLAIM STATUS          | - Current claim status                    |
|                       | - Open/closed date                        |
|                       | - Adjuster name                           |
|                       | - Litigation status                       |
|                       | - Settlement status                       |
+------------------------------------------------------------------+
```

---

## 9. Loss Bordereaux Reporting

### 9.1 Bordereaux Overview

```
LOSS BORDEREAUX STRUCTURE:
+------------------------------------------------------------------+
|                                                                  |
|  WHAT IS A BORDEREAUX:                                           |
|  ├── Detailed listing of individual claims ceded to reinsurer    |
|  ├── Reporting vehicle for proportional treaties primarily       |
|  ├── May be used for XOL treaties for paid losses                |
|  ├── Submitted on agreed schedule (monthly or quarterly)         |
|  └── Basis for reinsurance accounting and settlement             |
|                                                                  |
|  TYPES OF BORDEREAUX:                                            |
|  ├── Premium Bordereaux: lists ceded premiums by policy          |
|  ├── Outstanding Loss Bordereaux: current reserves by claim      |
|  ├── Paid Loss Bordereaux: payments made during period           |
|  └── Combined Bordereaux: all of the above in one report        |
|                                                                  |
+------------------------------------------------------------------+

LOSS BORDEREAUX FIELD LAYOUT:
+------------------------------------------------------------------+
| #  | Field                  | Type     | Description             |
+------------------------------------------------------------------+
| 1  | Reporting Period       | DATE     | Month/quarter reported   |
| 2  | Treaty Number          | VARCHAR  | Reinsurance contract ID  |
| 3  | Treaty Year            | INTEGER  | Treaty effective year    |
| 4  | Reinsurer Code         | VARCHAR  | Reinsurer identifier     |
| 5  | Reinsurer Share %      | DECIMAL  | Participation percentage |
| 6  | Claim Number           | VARCHAR  | Primary claim ID         |
| 7  | Policy Number          | VARCHAR  | Underlying policy        |
| 8  | Insured Name           | VARCHAR  | Named insured            |
| 9  | Date of Loss           | DATE     | Occurrence date          |
| 10 | Date Reported          | DATE     | Date claim reported      |
| 11 | State                  | CHAR(2)  | Jurisdiction             |
| 12 | LOB Code               | VARCHAR  | Line of business         |
| 13 | Cause of Loss          | VARCHAR  | Peril/cause code         |
| 14 | Claim Status           | VARCHAR  | Open/Closed              |
| 15 | Gross Paid Loss        | DECIMAL  | Total gross loss paid    |
| 16 | Gross Paid ALAE        | DECIMAL  | Total gross ALAE paid    |
| 17 | Gross O/S Loss Reserve | DECIMAL  | Outstanding loss reserve |
| 18 | Gross O/S ALAE Reserve | DECIMAL  | Outstanding ALAE reserve |
| 19 | Gross Incurred Loss    | DECIMAL  | Paid + Outstanding       |
| 20 | Gross Incurred ALAE    | DECIMAL  | Paid + Outstanding ALAE  |
| 21 | Gross Salvage/Subro    | DECIMAL  | Recoveries received      |
| 22 | Ceded Paid Loss        | DECIMAL  | Ceded loss paid          |
| 23 | Ceded Paid ALAE        | DECIMAL  | Ceded ALAE paid          |
| 24 | Ceded O/S Loss         | DECIMAL  | Ceded outstanding loss   |
| 25 | Ceded O/S ALAE         | DECIMAL  | Ceded outstanding ALAE   |
| 26 | Ceded Incurred Loss    | DECIMAL  | Ceded total incurred     |
| 27 | Ceded Incurred ALAE    | DECIMAL  | Ceded total incurred ALAE|
| 28 | Movement Paid Loss     | DECIMAL  | Change this period       |
| 29 | Movement Paid ALAE     | DECIMAL  | Change this period       |
| 30 | Movement O/S Loss      | DECIMAL  | Reserve change           |
| 31 | Currency               | CHAR(3)  | ISO currency code        |
+------------------------------------------------------------------+
```

### 9.2 Bordereaux Production Architecture

```
BORDEREAUX GENERATION FLOW:
+------------------------------------------------------------------+
|                                                                  |
|  Claims System                                                   |
|       ↓                                                          |
|  Extract claims data for reporting period                        |
|       ↓                                                          |
|  Apply treaty allocation rules:                                  |
|  ├── Identify applicable treaty for each claim                   |
|  ├── Calculate ceded share per treaty terms                      |
|  ├── Apply retention and limit calculations                      |
|  └── Handle multi-treaty participation                           |
|       ↓                                                          |
|  Generate bordereaux by:                                         |
|  ├── Treaty number                                               |
|  ├── Reinsurer (separate report per participant)                 |
|  ├── Treaty year                                                 |
|  └── Currency                                                    |
|       ↓                                                          |
|  Validation:                                                     |
|  ├── Reconcile ceded totals to general ledger                    |
|  ├── Verify treaty participation percentages                     |
|  ├── Check for missing or duplicate claims                       |
|  └── Validate calculations (ceded = gross × share %)            |
|       ↓                                                          |
|  Deliver to reinsurers:                                          |
|  ├── Reinsurance portal upload                                   |
|  ├── SFTP/email with encrypted file                              |
|  ├── ACORD messaging (for standards-compliant partners)          |
|  └── Broker submission (for brokered placements)                 |
|                                                                  |
+------------------------------------------------------------------+
```

---

## 10. ACORD Reinsurance Messaging Standards

### 10.1 ACORD Standards Overview

```
ACORD REINSURANCE DATA STANDARDS:
+------------------------------------------------------------------+
|                                                                  |
|  ACORD GLOBAL REINSURANCE AND LARGE COMMERCIAL (GRLC):          |
|  ├── XML-based messaging standard                               |
|  ├── Covers treaty and facultative transactions                  |
|  ├── Supports claims, accounting, and contract messaging         |
|  └── Adopted by major reinsurers and brokers                    |
|                                                                  |
|  KEY MESSAGE TYPES FOR CLAIMS:                                   |
|  +------------------------------------------------------------+  |
|  | Message Type          | Description                         |  |
|  +------------------------------------------------------------+  |
|  | ClaimNotification     | Initial notice to reinsurer         |  |
|  | ClaimMovement         | Reserve/payment updates             |  |
|  | ClaimBordereaux       | Periodic loss bordereaux            |  |
|  | CashCall              | Request for payment from reinsurer  |  |
|  | ClaimSettlement       | Settlement details                  |  |
|  | PremiumBordereaux     | Premium reporting                   |  |
|  | TechnicalAccount      | Treaty accounting statement         |  |
|  +------------------------------------------------------------+  |
|                                                                  |
|  JCLA (Joint Claims Liaison Agreement):                          |
|  ├── Standard claims reporting format in London market           |
|  ├── Defines minimum data requirements                          |
|  └── Supports electronic claims file (ECF) submissions          |
|                                                                  |
+------------------------------------------------------------------+
```

### 10.2 Sample ACORD Claim Notification (Simplified XML)

```xml
<?xml version="1.0" encoding="UTF-8"?>
<ClaimNotification xmlns="http://www.acord.org/standards/reinsurance">
  <Header>
    <SenderId>CEDENT001</SenderId>
    <ReceiverId>REINSURER001</ReceiverId>
    <CreationDate>2025-04-16</CreationDate>
    <MessageId>CN-2025-001234</MessageId>
  </Header>
  <ContractReference>
    <ContractId>TR-2025-PROP-001</ContractId>
    <ContractType>Treaty</ContractType>
    <ContractYear>2025</ContractYear>
    <SectionRef>Section A - Property XOL</SectionRef>
  </ContractReference>
  <ClaimDetails>
    <ClaimNumber>CLM-2025-045678</ClaimNumber>
    <PolicyNumber>POL-2025-112233</PolicyNumber>
    <InsuredName>ABC Manufacturing Corp</InsuredName>
    <DateOfLoss>2025-03-15</DateOfLoss>
    <DateReported>2025-03-16</DateReported>
    <LossDescription>Fire at warehouse facility causing
      structural damage and business interruption</LossDescription>
    <CauseOfLoss>Fire</CauseOfLoss>
    <StateOfLoss>TX</StateOfLoss>
    <LineOfBusiness>Commercial Property</LineOfBusiness>
  </ClaimDetails>
  <FinancialDetails currency="USD">
    <GrossPaidLoss>500000.00</GrossPaidLoss>
    <GrossPaidALAE>75000.00</GrossPaidALAE>
    <GrossOutstandingLoss>2500000.00</GrossOutstandingLoss>
    <GrossOutstandingALAE>150000.00</GrossOutstandingALAE>
    <GrossIncurredLoss>3000000.00</GrossIncurredLoss>
    <GrossIncurredALAE>225000.00</GrossIncurredALAE>
    <Retention>1000000.00</Retention>
    <CededLoss>2000000.00</CededLoss>
    <CededALAE>225000.00</CededALAE>
    <SubrogationPotential>250000.00</SubrogationPotential>
  </FinancialDetails>
  <ReinsurerParticipation>
    <Reinsurer name="Swiss Re" share="0.40"/>
    <Reinsurer name="Munich Re" share="0.35"/>
    <Reinsurer name="Hannover Re" share="0.25"/>
  </ReinsurerParticipation>
</ClaimNotification>
```

---

## 11. Reinsurance Claims Workflow

### 11.1 End-to-End Process

```
REINSURANCE CLAIMS LIFECYCLE:
+====================================================================+
|                                                                    |
|  1. NOTIFICATION                                                   |
|  ┌──────────────────────────────────────────────────────────┐      |
|  │ Claim events trigger reinsurance notification            │      |
|  │ ├── New claim exceeding threshold                        │      |
|  │ ├── Reserve increase above reporting level               │      |
|  │ ├── Large payment or settlement                          │      |
|  │ └── Catastrophe event declaration                        │      |
|  └──────────────────────────────────────────────────────────┘      |
|       ↓                                                            |
|  2. RESERVE POSTING (CEDED)                                        |
|  ┌──────────────────────────────────────────────────────────┐      |
|  │ Calculate and post ceded reserves                        │      |
|  │ ├── Apply treaty/fac terms to gross reserves              │      |
|  │ ├── Allocate across applicable treaties                   │      |
|  │ ├── Calculate per-reinsurer share                         │      |
|  │ └── Post to reinsurance sub-ledger                        │      |
|  └──────────────────────────────────────────────────────────┘      |
|       ↓                                                            |
|  3. PAYMENT / CASH CALL                                            |
|  ┌──────────────────────────────────────────────────────────┐      |
|  │ When gross payments made, calculate and request RI recovery│      |
|  │ ├── Proportional: automatic calculation per cession %      │      |
|  │ ├── XOL: once retention exhausted, bill excess to RI      │      |
|  │ ├── Generate cash call or debit to RI current account     │      |
|  │ └── Track payment status and aging                        │      |
|  └──────────────────────────────────────────────────────────┘      |
|       ↓                                                            |
|  4. RECOVERY                                                       |
|  ┌──────────────────────────────────────────────────────────┐      |
|  │ Receive reinsurance payments                              │      |
|  │ ├── Apply to reinsurance recoverable                      │      |
|  │ ├── Update ceded paid and outstanding                     │      |
|  │ ├── Reconcile to cash call / bordereaux                   │      |
|  │ └── Post to general ledger                                │      |
|  └──────────────────────────────────────────────────────────┘      |
|       ↓                                                            |
|  5. REPORTING                                                      |
|  ┌──────────────────────────────────────────────────────────┐      |
|  │ Ongoing reporting to reinsurers                           │      |
|  │ ├── Monthly/quarterly bordereaux                          │      |
|  │ ├── Large loss status reports                             │      |
|  │ ├── Treaty accounting statements                          │      |
|  │ └── Annual treaty reconciliation                          │      |
|  └──────────────────────────────────────────────────────────┘      |
|       ↓                                                            |
|  6. COMMUTATION (Optional, end of treaty life)                     |
|  ┌──────────────────────────────────────────────────────────┐      |
|  │ Negotiate final settlement of all outstanding claims       │      |
|  │ ├── Calculate commutation value                           │      |
|  │ ├── Agree terms with reinsurer                            │      |
|  │ ├── Execute commutation agreement                         │      |
|  │ └── Release all future obligations                        │      |
|  └──────────────────────────────────────────────────────────┘      |
|                                                                    |
+====================================================================+
```

---

## 12. Reserve Posting for Reinsurance

### 12.1 Gross/Ceded/Net Reserve Framework

```
RESERVE COMPONENTS:
+------------------------------------------------------------------+
|                                                                  |
|  GROSS RESERVE = Total reserve before reinsurance                |
|  CEDED RESERVE = Portion recoverable from reinsurer(s)           |
|  NET RESERVE   = Gross - Ceded (retained by cedent)              |
|                                                                  |
|  EXAMPLE:                                                        |
|  Gross reserve: $5,000,000                                       |
|  40% Quota Share ceded: $2,000,000                               |
|  Net reserve: $3,000,000                                         |
|                                                                  |
|  RESERVE CATEGORIES:                                             |
|  +------------------------------------------------------------+  |
|  | Category           | Gross    | Ceded    | Net      |       |  |
|  +------------------------------------------------------------+  |
|  | Case Reserve Loss  | 3,000,000| 1,200,000| 1,800,000|       |  |
|  | Case Reserve ALAE  |   500,000|   200,000|   300,000|       |  |
|  | IBNR Loss          | 1,200,000|   480,000|   720,000|       |  |
|  | IBNR ALAE          |   300,000|   120,000|   180,000|       |  |
|  | TOTAL              | 5,000,000| 2,000,000| 3,000,000|       |  |
|  +------------------------------------------------------------+  |
|                                                                  |
|  CEDED RESERVE CALCULATION BY TREATY TYPE:                       |
|                                                                  |
|  QUOTA SHARE:                                                    |
|  Ceded = Gross × QS Percentage                                  |
|                                                                  |
|  SURPLUS SHARE:                                                  |
|  Ceded = Gross × (Ceded Share / Total Risk)                     |
|  (Share varies by policy)                                        |
|                                                                  |
|  PER RISK XOL:                                                   |
|  Ceded = MAX(0, MIN(Limit, Gross - Retention))                  |
|                                                                  |
|  PER OCCURRENCE XOL:                                             |
|  Ceded = MAX(0, MIN(Limit, Aggregate Occurrence Gross - Ret))   |
|                                                                  |
+------------------------------------------------------------------+
```

### 12.2 Ceded Reserve Posting Rules

```
CEDED RESERVE POSTING ENGINE:
+------------------------------------------------------------------+
|                                                                  |
|  ON EVERY GROSS RESERVE CHANGE:                                  |
|  ├── 1. Identify all applicable reinsurance contracts            |
|  ├── 2. For each contract (in priority order):                   |
|  │   ├── Calculate ceded reserve per contract terms              |
|  │   ├── Apply retention / attachment point                      |
|  │   ├── Apply limit / cap                                       |
|  │   ├── Calculate per-reinsurer share                           |
|  │   └── Post ceded reserve entries                              |
|  ├── 3. Handle treaty overlap / stacking                         |
|  ├── 4. Update net reserve (Gross - sum of all Ceded)            |
|  ├── 5. Generate GL entries (ceded reserve + RI recoverable)     |
|  └── 6. Update reinsurance notification tracking                 |
|                                                                  |
|  TREATY STACKING EXAMPLE:                                        |
|  ├── Gross reserve: $8,000,000                                   |
|  ├── Layer 1: $3M xs $2M XOL → Ceded: $3,000,000               |
|  ├── Layer 2: $5M xs $5M XOL → Ceded: $3,000,000               |
|  ├── Layer 3: $10M xs $10M XOL → Ceded: $0 (not reached)       |
|  ├── Total ceded: $6,000,000                                    |
|  └── Net retained: $2,000,000 (retention) + $0 = $2,000,000     |
|                                                                  |
+------------------------------------------------------------------+
```

---

## 13. Reinsurance Payment Processing

### 13.1 Payment Flow

```
REINSURANCE PAYMENT PROCESSING:
+------------------------------------------------------------------+
|                                                                  |
|  PROPORTIONAL TREATY PAYMENTS:                                   |
|  ├── Cedent makes gross payment to claimant                      |
|  ├── Ceded share calculated automatically                        |
|  ├── Added to bordereaux for period                              |
|  ├── Net settlement through quarterly account                    |
|  └── Premium, losses, commissions netted                         |
|                                                                  |
|  XOL TREATY PAYMENTS (Cash Call):                                |
|  ├── Cedent makes gross payment exceeding retention              |
|  ├── Cash call generated for excess amount                       |
|  ├── Cash call sent to reinsurer(s) with documentation           |
|  ├── Reinsurer reviews and approves                              |
|  ├── Payment received from reinsurer                             |
|  └── Applied to reinsurance recoverable account                  |
|                                                                  |
|  CASH CALL CONTENT:                                              |
|  +------------------------------------------------------------+  |
|  | Field                    | Description                      |  |
|  +------------------------------------------------------------+  |
|  | Cash Call Number         | Unique identifier                |  |
|  | Treaty Reference         | Contract number and year         |  |
|  | Claim Number             | Primary claim reference          |  |
|  | Date of Loss             | Occurrence date                  |  |
|  | Gross Paid (cumulative)  | Total gross paid to date         |  |
|  | Retention Applied        | Retention amount                 |  |
|  | Ceded Paid (prior)       | Previously recovered             |  |
|  | Current Cash Call Amount  | Amount being billed              |  |
|  | Reinsurer Share %        | This reinsurer's participation   |  |
|  | Amount Due This RI       | Cash call × share %             |  |
|  | Supporting Documentation | Loss report, proof of payment    |  |
|  | Payment Instructions     | Wire/ACH details                 |  |
|  | Due Date                 | Expected payment date            |  |
|  +------------------------------------------------------------+  |
|                                                                  |
+------------------------------------------------------------------+
```

### 13.2 Settlement Accounting

```
SETTLEMENT ACCOUNTING EXAMPLE (Quarterly QS):
+------------------------------------------------------------------+
|                                                                  |
|  QUARTERLY ACCOUNT STATEMENT:                                    |
|  Treaty: 40% Quota Share Property                                |
|  Period: Q1 2025                                                 |
|  Reinsurer: Swiss Re (100% of ceded share)                      |
|                                                                  |
|  +------------------------------------------------------------+  |
|  | Item                              | Debit    | Credit     |  |
|  +------------------------------------------------------------+  |
|  | Ceded Written Premium              |          | 4,000,000  |  |
|  | Ceding Commission (30%)            | 1,200,000|            |  |
|  | Ceded Paid Losses                  | 1,500,000|            |  |
|  | Ceded Paid ALAE                    |   200,000|            |  |
|  | Salvage/Subrogation Return         |          |    50,000  |  |
|  | Portfolio Transfer In              |          |         0  |  |
|  | Portfolio Transfer Out             |         0|            |  |
|  +------------------------------------------------------------+  |
|  | Net Balance                        |          | 1,150,000  |  |
|  +------------------------------------------------------------+  |
|                                                                  |
|  Net amount DUE FROM REINSURER: $1,150,000                       |
|  (Credit balance = reinsurer owes cedent)                        |
|                                                                  |
+------------------------------------------------------------------+
```

---

## 14. Treaty Claims Accounting

### 14.1 Sliding Scale Commission

```
SLIDING SCALE COMMISSION CALCULATION:
+------------------------------------------------------------------+
|                                                                  |
|  CONCEPT: Commission rate varies based on loss ratio             |
|  Better loss experience = higher commission                      |
|  Worse loss experience = lower commission                        |
|                                                                  |
|  EXAMPLE TABLE:                                                  |
|  +------------------------------------------------------------+  |
|  | Loss Ratio Range | Commission Rate | Calculation             |  |
|  +------------------------------------------------------------+  |
|  | 0% - 40%         | 35%             | Maximum commission      |  |
|  | 40% - 45%        | 33%             | Sliding                 |  |
|  | 45% - 50%        | 30%             | Sliding                 |  |
|  | 50% - 55%        | 27%             | Provisional rate        |  |
|  | 55% - 60%        | 24%             | Sliding                 |  |
|  | 60% - 65%        | 21%             | Sliding                 |  |
|  | 65%+             | 18%             | Minimum commission      |  |
|  +------------------------------------------------------------+  |
|                                                                  |
|  FORMULA:                                                        |
|  Loss Ratio = (Incurred Losses + ALAE) / Earned Premium         |
|  Commission = f(Loss Ratio) per sliding scale table              |
|  Adjustment = (New Commission - Provisional Commission) × EP     |
|                                                                  |
|  Claims system must accurately track ceded losses to enable      |
|  sliding scale calculations. Late reserve adjustments directly   |
|  impact commission amounts.                                      |
|                                                                  |
+------------------------------------------------------------------+
```

---

## 15. Excess of Loss Claims

### 15.1 Retention Application

```
XOL RETENTION APPLICATION:
+------------------------------------------------------------------+
|                                                                  |
|  PER RISK XOL: $3M xs $2M                                       |
|                                                                  |
|  Claim A: $4,000,000 on single risk                             |
|  ├── Retention: $2,000,000 (cedent pays)                        |
|  ├── Ceded to XOL: $2,000,000 ($4M - $2M, within $3M limit)    |
|  └── Above XOL limit: $0                                        |
|                                                                  |
|  Claim B: $6,000,000 on single risk                             |
|  ├── Retention: $2,000,000 (cedent pays)                        |
|  ├── Ceded to XOL: $3,000,000 (limit)                           |
|  └── Above XOL limit: $1,000,000 (cedent retains or next layer) |
|                                                                  |
|  ALAE TREATMENT OPTIONS:                                         |
|  ├── ALAE included in the loss (pro rata with loss)              |
|  │   → $4M claim + $500K ALAE = $4.5M → XOL recovery on $4.5M  |
|  ├── ALAE in addition to loss                                    |
|  │   → $4M claim triggers $2M XOL recovery                      |
|  │   → $500K ALAE: reinsurer pays proportional share            |
|  └── ALAE excluded                                               |
|      → Only indemnity counts against retention and limit         |
|                                                                  |
+------------------------------------------------------------------+
```

### 15.2 Reinstatement Calculations

```
REINSTATEMENT PROVISIONS:
+------------------------------------------------------------------+
|                                                                  |
|  WHAT IS REINSTATEMENT:                                          |
|  ├── When an XOL loss exhausts the limit, the limit must be     |
|  │   "reinstated" for future losses during the treaty period     |
|  ├── Reinstatement may be at additional premium                  |
|  └── Number of reinstatements specified in treaty                |
|                                                                  |
|  EXAMPLE:                                                        |
|  Treaty: $5M xs $5M, 1 reinstatement at 100%                    |
|  Annual premium: $500,000                                        |
|                                                                  |
|  Loss 1: $8M (ceded $3M to layer, $2M limit remaining)          |
|  Reinstatement premium owed for $3M used:                        |
|    RP = Premium × (Amount Used / Limit) × RI Rate                |
|    RP = $500,000 × ($3M / $5M) × 100% = $300,000               |
|                                                                  |
|  Loss 2: $12M (ceded $5M to remaining limit + reinstated limit)  |
|    First: uses remaining $2M from original limit                 |
|    Then: uses $3M from reinstated limit                          |
|    Reinstatement premium for $3M:                                |
|    RP = $500,000 × ($3M / $5M) × 100% = $300,000               |
|                                                                  |
|  Loss 3: $7M (only $2M remaining in reinstated limit)            |
|    Ceded: $2M (remaining reinstated)                             |
|    No further reinstatements available                           |
|    Cedent retains $5M excess = uninsured                         |
|                                                                  |
|  REINSTATEMENT DATA TRACKING:                                    |
|  ├── Original limit amount                                      |
|  ├── Limit utilized                                              |
|  ├── Limit remaining                                             |
|  ├── Number of reinstatements available/used                     |
|  ├── Reinstatement premium rate                                  |
|  ├── Reinstatement premium charged                               |
|  └── Effective limit at any point in time                        |
|                                                                  |
+------------------------------------------------------------------+
```

---

## 16. Catastrophe Excess of Loss

### 16.1 Event Definition and Hours Clause

```
CATASTROPHE XOL CONCEPTS:
+------------------------------------------------------------------+
|                                                                  |
|  EVENT DEFINITION:                                               |
|  ├── A single catastrophic event (hurricane, earthquake, etc.)   |
|  ├── All losses from a single event aggregated as one occurrence |
|  ├── The "hours clause" defines the time window for aggregation  |
|  └── Losses across multiple policies counted together            |
|                                                                  |
|  HOURS CLAUSE:                                                   |
|  ├── Defines maximum time period for event aggregation           |
|  ├── Typical periods:                                            |
|  │   ├── Windstorm/Hurricane: 72-168 hours                      |
|  │   ├── Earthquake: 72-168 hours                               |
|  │   ├── Flood: 72-168 hours                                    |
|  │   ├── Terrorism: 72-168 hours                                |
|  │   └── Riot/Civil Commotion: 72 hours                         |
|  ├── Cedent may choose start time to maximize recovery           |
|  └── One event = one occurrence for treaty purposes              |
|                                                                  |
|  EVENT AGGREGATION EXAMPLE:                                      |
|  Hurricane makes landfall over 72-hour period:                   |
|  ├── 500 property claims totaling $50M gross                     |
|  ├── 200 auto claims totaling $5M gross                          |
|  ├── 50 liability claims totaling $2M gross                      |
|  ├── Total event aggregate: $57M                                 |
|  ├── Cat XOL: $40M xs $10M                                      |
|  ├── Retention: $10M                                             |
|  ├── Ceded to Cat XOL: $40M ($57M - $10M, capped at $40M)       |
|  └── Cedent retains: $10M + $7M excess = $17M                   |
|                                                                  |
+------------------------------------------------------------------+
```

### 16.2 Event Aggregation in Claims System

```
EVENT AGGREGATION ARCHITECTURE:
+------------------------------------------------------------------+
|                                                                  |
|  1. CAT EVENT DECLARATION                                        |
|  ├── Catastrophe management declares event                       |
|  ├── Assign event code and description                           |
|  ├── Define geographic/temporal boundaries                       |
|  └── System creates CAT event record                             |
|                                                                  |
|  2. CLAIM-TO-EVENT ASSOCIATION                                   |
|  ├── Claims coded with CAT event code at FNOL                    |
|  ├── Batch assignment for existing claims in affected area       |
|  ├── Automated geo-coding against event boundaries               |
|  └── Manual review for borderline claims                         |
|                                                                  |
|  3. AGGREGATE MONITORING                                         |
|  ├── Real-time aggregation of all claims per event               |
|  ├── Dashboard: total gross incurred by event                    |
|  ├── Comparison against Cat XOL retention                        |
|  ├── Estimated ultimate loss by event                            |
|  └── Alert when approaching/exceeding retention                  |
|                                                                  |
|  4. CAT XOL RECOVERY CALCULATION                                 |
|  ├── Sum gross incurred for all claims in event                  |
|  ├── Apply per-occurrence Cat XOL terms                          |
|  ├── Calculate ceded recovery per layer                          |
|  ├── Allocate across reinsurers by share                         |
|  └── Generate cash calls                                        |
|                                                                  |
+------------------------------------------------------------------+
```

---

## 17. Aggregate Treaties

### 17.1 Attachment Point Tracking

```
AGGREGATE TREATY MONITORING:
+------------------------------------------------------------------+
|                                                                  |
|  ANNUAL AGGREGATE XOL (STOP LOSS):                               |
|  ├── Monitors cumulative losses over the treaty period           |
|  ├── Attachment: total losses must exceed threshold              |
|  ├── May be expressed as dollar amount or loss ratio             |
|  ├── Treaty "burns through" when attachment exceeded             |
|  └── Coverage limited by aggregate limit                         |
|                                                                  |
|  TRACKING REQUIREMENTS:                                          |
|  +------------------------------------------------------------+  |
|  | Data Point              | Frequency  | Source               |  |
|  +------------------------------------------------------------+  |
|  | Subject earned premium   | Monthly    | Accounting system    |  |
|  | Cumulative paid losses   | Monthly    | Claims system        |  |
|  | Cumulative O/S reserves  | Monthly    | Claims system        |  |
|  | Incurred losses          | Monthly    | Claims system        |  |
|  | Loss ratio               | Monthly    | Calculated           |  |
|  | Distance to attachment   | Monthly    | Calculated           |  |
|  | Estimated ultimate loss  | Quarterly  | Actuarial            |  |
|  | Projected attachment     | Quarterly  | Actuarial            |  |
|  +------------------------------------------------------------+  |
|                                                                  |
|  DASHBOARD METRICS:                                              |
|  ├── Current loss ratio vs attachment point                      |
|  ├── Projected year-end loss ratio                               |
|  ├── Probability of attachment (based on development patterns)   |
|  ├── Expected recovery amount                                    |
|  └── Remaining limit available                                   |
|                                                                  |
+------------------------------------------------------------------+
```

---

## 18. Commutation

### 18.1 Commutation Process

```
COMMUTATION OVERVIEW:
+------------------------------------------------------------------+
|                                                                  |
|  WHAT IS COMMUTATION:                                            |
|  ├── Agreement to terminate a reinsurance contract               |
|  ├── Reinsurer pays lump sum to extinguish future obligations    |
|  ├── Cedent assumes all future liability on ceded claims         |
|  └── Typically for older treaties with remaining reserves        |
|                                                                  |
|  WHEN TO COMMUTE:                                                |
|  ├── Treaty is in runoff with declining activity                 |
|  ├── Reinsurer credit concerns (get cash now vs. future)        |
|  ├── Simplify administration                                    |
|  ├── Release collateral/trust funds                              |
|  ├── Reinsurer exiting market or in runoff                       |
|  └── Both parties agree it's economically beneficial             |
|                                                                  |
|  COMMUTATION CALCULATION:                                        |
|  ├── 1. Identify all outstanding claims on the treaty            |
|  ├── 2. Calculate ceded outstanding reserves                     |
|  ├── 3. Apply actuarial development factors                      |
|  ├── 4. Discount to present value                                |
|  ├── 5. Add IBNR estimates for ceded business                    |
|  ├── 6. Add ULAE loading                                         |
|  ├── 7. Apply risk margin (negotiated)                           |
|  └── 8. Agree final commutation value                            |
|                                                                  |
|  EXAMPLE CALCULATION:                                            |
|  +------------------------------------------------------------+  |
|  | Component                | Cedent     | Reinsurer  |        |  |
|  |                          | Estimate   | Estimate   |        |  |
|  +------------------------------------------------------------+  |
|  | Ceded O/S Case Reserves  | 5,000,000  | 4,500,000  |        |  |
|  | Ceded IBNR               | 2,000,000  | 1,500,000  |        |  |
|  | ULAE Loading (5%)        |   350,000  |   300,000  |        |  |
|  | Subtotal                 | 7,350,000  | 6,300,000  |        |  |
|  | PV Discount (3%, 3yr)    | (640,000)  | (550,000)  |        |  |
|  | Risk Margin              |            |  (500,000) |        |  |
|  | Estimated Value          | 6,710,000  | 5,250,000  |        |  |
|  +------------------------------------------------------------+  |
|  | Negotiated Settlement    |       5,800,000          |        |  |
|  +------------------------------------------------------------+  |
|                                                                  |
+------------------------------------------------------------------+
```

### 18.2 Commutation Data Requirements

| Data Element | Description |
|-------------|-------------|
| Treaty identification | Contract number, year, section |
| Open claims list | All claims with outstanding reserves |
| Claim detail | Paid, reserved, incurred per claim |
| Loss development | Actuarial development to ultimate |
| IBNR estimates | Ceded IBNR by treaty year |
| Payment patterns | Historical payout pattern |
| Discount rate | Agreed discount rate for PV calc |
| Tax considerations | Tax impact of commutation |
| Collateral held | Trust, LOC, funds withheld balances |

---

## 19. London Market Claims Processing

### 19.1 London Market Structure

```
LONDON MARKET CLAIMS ECOSYSTEM:
+------------------------------------------------------------------+
|                                                                  |
|  KEY COMPONENTS:                                                 |
|                                                                  |
|  MRC (Market Reform Contract):                                   |
|  ├── Standardized contract document for London market            |
|  ├── Contains all coverage terms and conditions                  |
|  ├── "Slip" is the binding document                              |
|  └── Multiple (re)insurers sign the slip with their line/share   |
|                                                                  |
|  ECF (Electronic Claims File):                                   |
|  ├── Electronic platform for claims processing                   |
|  ├── Replaced paper claims files                                 |
|  ├── Managed by Xchanging (now DXC Technology)                   |
|  ├── Used for: claims notification, agreement, settlement        |
|  └── All London market carriers access same system               |
|                                                                  |
|  CLASS (Claims Loss Advice and Settlement System):               |
|  ├── Settlement and accounting system                            |
|  ├── Processes claim transactions between parties                |
|  ├── Integrated with central settlement (bureau settlements)     |
|  └── Handles multi-currency processing                           |
|                                                                  |
|  VITESSE:                                                        |
|  ├── Next-generation electronic claims platform                  |
|  ├── Replacing/supplementing ECF                                 |
|  ├── API-driven for better integration                           |
|  └── Supports straight-through processing                        |
|                                                                  |
|  BROKER:                                                         |
|  ├── Central role in London market claims                        |
|  ├── Broker presents claims to market                            |
|  ├── Negotiates with lead underwriter                            |
|  ├── Obtains agreement from following market                     |
|  └── Processes settlement through bureau or direct               |
|                                                                  |
+------------------------------------------------------------------+
```

### 19.2 London Market Claims Process

```
LONDON MARKET CLAIMS WORKFLOW:
+------------------------------------------------------------------+
|                                                                  |
|  1. LOSS NOTIFICATION                                            |
|  ├── Cedent notifies broker of loss                              |
|  ├── Broker prepares claims presentation                         |
|  └── Claim entered into ECF/Vitesse                              |
|                                                                  |
|  2. CLAIMS AGREEMENT                                             |
|  ├── Lead underwriter reviews and agrees claim                   |
|  ├── Following market presented with agreed terms                |
|  ├── Each market agrees their share                              |
|  ├── Claims Agreement Parties (CAP) concept:                     |
|  │   ├── Lead agrees on behalf of following market               |
|  │   ├── OR specific markets reserved right to agree individually|
|  │   └── Percentage agreement threshold (e.g., 75%)             |
|  └── Disputed claims: arbitration or litigation                  |
|                                                                  |
|  3. SETTLEMENT                                                   |
|  ├── Bureau settlement (XIS - Xchanging Ins Services):           |
|  │   ├── Central settlement system                               |
|  │   ├── Each market's share calculated and settled              |
|  │   └── Net settlement through bureau account                   |
|  ├── Direct settlement:                                          |
|  │   ├── Broker collects from each market directly               |
|  │   └── Used for some non-bureau business                       |
|  └── Currency: typically GBP, USD, EUR, CAD                      |
|                                                                  |
|  4. ACCOUNTING                                                   |
|  ├── Settlement processed through CLASS                          |
|  ├── Each market's account debited/credited                      |
|  ├── Monthly/quarterly statements reconciled                     |
|  └── Trust fund requirements for certain markets                 |
|                                                                  |
+------------------------------------------------------------------+
```

---

## 20. Lloyd's Claims

### 20.1 Lloyd's Claims Agreement Parties

```
LLOYD'S CLAIMS PROCESSING:
+------------------------------------------------------------------+
|                                                                  |
|  CLAIMS AGREEMENT PARTIES (CAP):                                 |
|  ├── Lead underwriter has primary claims authority               |
|  ├── "Slipleader" typically manages claims for all               |
|  ├── Following underwriters may delegate authority to lead       |
|  ├── Claims Scheme:                                              |
|  │   ├── Single Claims Agreement Party (SCAP): one party agrees |
|  │   ├── Dual Claims Agreement Party (DCAP): two parties agree  |
|  │   └── Multi Claims Agreement Party: multiple must agree      |
|  └── Expert Fee arrangements for complex claims                  |
|                                                                  |
|  EXPERT FEE ARRANGEMENTS:                                        |
|  ├── Independent expert engaged for complex claims               |
|  ├── Expert advises all market participants                      |
|  ├── Fees shared proportionally across slip                      |
|  ├── Used for: large/complex property, marine, aviation          |
|  └── Expert has no binding authority (advisory only)             |
|                                                                  |
|  LLOYD'S PERFORMANCE MANAGEMENT:                                 |
|  ├── Monitoring of syndicate claims performance                  |
|  ├── Claims standards and procedures                             |
|  ├── Conduct of business requirements                            |
|  ├── Claims transformation program                               |
|  └── Oversight by Lloyd's Market Association (LMA)               |
|                                                                  |
+------------------------------------------------------------------+
```

---

## 21. Reinsurance Disputes and Arbitration

### 21.1 Common Dispute Areas

```
REINSURANCE CLAIMS DISPUTES:
+------------------------------------------------------------------+
|                                                                  |
|  COMMON DISPUTE AREAS:                                           |
|  ├── Late notice: reinsurer claims prejudice                     |
|  ├── Coverage allocation: how losses allocated to treaties       |
|  ├── Follow the fortunes: limits of cedent's discretion          |
|  ├── ECO/XPL: extra-contractual obligations liability            |
|  ├── Retention application: what constitutes "one risk/event"    |
|  ├── ALAE treatment: included in or addition to loss             |
|  ├── Hours clause: event window definition                       |
|  ├── Occurrence definition: aggregation of claims into events    |
|  ├── Commutation disagreements                                   |
|  └── Misrepresentation in original placement                     |
|                                                                  |
|  DISPUTE RESOLUTION MECHANISMS:                                  |
|  ├── Informal negotiation (most common first step)               |
|  ├── Mediation (increasingly used in reinsurance)                |
|  ├── Arbitration (traditional RI dispute resolution):            |
|  │   ├── Panel of 3 arbitrators (typically)                      |
|  │   ├── Each party selects 1; those 2 select umpire            |
|  │   ├── Governed by treaty arbitration clause                   |
|  │   ├── Often "honorable engagement" standard                   |
|  │   ├── Less formal than litigation                             |
|  │   └── Decision typically binding and final                    |
|  └── Litigation (less common; used when arbitration fails)       |
|                                                                  |
+------------------------------------------------------------------+
```

---

## 22. Subrogation and Salvage in Reinsurance

### 22.1 Reinsurer's Interest in Recoveries

```
SUBROGATION AND SALVAGE IN RI CONTEXT:
+------------------------------------------------------------------+
|                                                                  |
|  PRINCIPLE:                                                      |
|  ├── Reinsurers share proportionally in salvage and subrogation  |
|  ├── Cedent has duty to pursue reasonable recoveries             |
|  ├── Recoveries reduce gross loss, thus reducing ceded loss      |
|  └── Treaty terms specify how recoveries are shared              |
|                                                                  |
|  PROPORTIONAL TREATIES:                                          |
|  ├── Recoveries shared in same proportion as losses              |
|  ├── Example: 40% QS → reinsurer gets 40% of recoveries         |
|  └── Reflected on bordereaux as negative loss                    |
|                                                                  |
|  XOL TREATIES:                                                   |
|  ├── More complex recovery allocation                            |
|  ├── Recoveries typically reduce the loss from the top down      |
|  ├── Example: $5M loss, $3M xs $2M XOL, reinsurer paid $3M      |
|  │   Recovery of $1M → reduces XOL recovery by $1M              |
|  │   Reinsurer returns $1M to cedent                            |
|  ├── Alternative: recoveries reduce gross loss pro rata          |
|  └── Treaty wording controls                                    |
|                                                                  |
+------------------------------------------------------------------+
```

---

## 23. Large Loss Management

### 23.1 Large Loss Process with Reinsurer Involvement

```
LARGE LOSS MANAGEMENT WORKFLOW:
+------------------------------------------------------------------+
|                                                                  |
|  DECLARATION OF LARGE LOSS:                                      |
|  ├── Gross incurred exceeds predefined threshold                 |
|  ├── Automatic escalation in claims system                       |
|  ├── Assigned to senior adjuster / large loss team               |
|  └── Reinsurance notification triggered                          |
|                                                                  |
|  REINSURER INVOLVEMENT:                                          |
|  ├── NOTIFICATION: Immediate advise of large loss                |
|  ├── STATUS REPORTS: Regular updates (monthly minimum)           |
|  │   ├── Claim description and status                            |
|  │   ├── Reserves (gross, ceded, net)                            |
|  │   ├── Payments (gross, ceded, net)                            |
|  │   ├── Coverage analysis                                      |
|  │   ├── Liability assessment                                   |
|  │   ├── Litigation status                                      |
|  │   └── Settlement strategy                                    |
|  ├── CONSULTATION: Seek reinsurer input on:                      |
|  │   ├── Coverage opinions                                      |
|  │   ├── Defense strategy                                        |
|  │   ├── Reserve adequacy                                        |
|  │   └── Settlement authority                                    |
|  ├── SETTLEMENT APPROVAL:                                        |
|  │   ├── Pre-settlement notice for major settlements             |
|  │   ├── Reinsurer may have contractual approval rights          |
|  │   └── Best practice: consult before settling above retention  |
|  └── CASH CALLS: Request reinsurance payments as needed          |
|                                                                  |
+------------------------------------------------------------------+
```

---

## 24. Reinsurance Claims Data Model

### 24.1 Entity Relationship Model

```
REINSURANCE CLAIMS DATA MODEL:
+====================================================================+
|                                                                    |
|  +-------------------+          +---------------------+            |
|  | Treaty            |          | FacCertificate      |            |
|  +-------------------+          +---------------------+            |
|  | treaty_id (PK)    |          | certificate_id (PK) |            |
|  | treaty_number     |          | certificate_number  |            |
|  | treaty_type       |          | policy_id (FK)      |            |
|  | treaty_year       |          | reinsurer_id (FK)   |            |
|  | effective_date    |          | type (prop/XOL)     |            |
|  | expiry_date       |          | ceded_share         |            |
|  | line_of_business  |          | retention           |            |
|  | retention         |          | limit               |            |
|  | limit             |          | premium             |            |
|  | reinstatements    |          | ceding_commission   |            |
|  | notification_threshold|       | effective_date      |            |
|  +--------+----------+          | expiry_date         |            |
|           |                     +----------+----------+            |
|           |                                |                       |
|  +--------+----------+     +--------------+                        |
|  | TreatyParticipant  |     |                                      |
|  +-------------------+     |                                      |
|  | participant_id (PK)|     |                                      |
|  | treaty_id (FK)     |     |                                      |
|  | reinsurer_id (FK)  |     |                                      |
|  | share_pct          |     |                                      |
|  | signed_line        |     |                                      |
|  +-------------------+     |                                      |
|                             |                                      |
|  +-------------------+     |    +---------------------+            |
|  | ReinsurerParty     |<----+    | Claim (from Primary)|            |
|  +-------------------+          +---------------------+            |
|  | reinsurer_id (PK)  |         | claim_id (PK)       |            |
|  | name               |         | claim_number        |            |
|  | am_best_rating     |         | gross_incurred      |            |
|  | sp_rating          |         | gross_paid          |            |
|  | country            |         | gross_reserved      |            |
|  | naic_code          |         +----------+----------+            |
|  +-------------------+                    |                        |
|                                           |                        |
|  +----------------------------------------+---+                    |
|  | CededReserve                                |                    |
|  +--------------------------------------------+                    |
|  | ceded_reserve_id (PK)                      |                    |
|  | claim_id (FK)                               |                    |
|  | treaty_id (FK) OR certificate_id (FK)       |                    |
|  | reinsurer_id (FK)                           |                    |
|  | effective_date                              |                    |
|  | ceded_loss_reserve                          |                    |
|  | ceded_alae_reserve                          |                    |
|  | ceded_total_reserve                         |                    |
|  | retention_applied                           |                    |
|  | calculation_method                          |                    |
|  +--------------------------------------------+                    |
|                                                                    |
|  +--------------------------------------------+                    |
|  | CededPayment                                |                    |
|  +--------------------------------------------+                    |
|  | ceded_payment_id (PK)                      |                    |
|  | claim_id (FK)                               |                    |
|  | treaty_id (FK) OR certificate_id (FK)       |                    |
|  | reinsurer_id (FK)                           |                    |
|  | payment_date                                |                    |
|  | ceded_loss_paid                             |                    |
|  | ceded_alae_paid                             |                    |
|  | cash_call_number                            |                    |
|  | cash_call_status                            |                    |
|  | payment_received_date                       |                    |
|  | amount_received                             |                    |
|  +--------------------------------------------+                    |
|                                                                    |
|  +--------------------------------------------+                    |
|  | Bordereaux                                  |                    |
|  +--------------------------------------------+                    |
|  | bordereaux_id (PK)                         |                    |
|  | treaty_id (FK)                              |                    |
|  | reporting_period                            |                    |
|  | type (premium/loss/outstanding)             |                    |
|  | status (draft/final/sent/acknowledged)      |                    |
|  | generation_date                             |                    |
|  | sent_date                                   |                    |
|  | total_ceded_premium                         |                    |
|  | total_ceded_losses                          |                    |
|  | total_ceding_commission                     |                    |
|  | net_balance                                 |                    |
|  +--------------------------------------------+                    |
|                                                                    |
|  +--------------------------------------------+                    |
|  | Commutation                                 |                    |
|  +--------------------------------------------+                    |
|  | commutation_id (PK)                        |                    |
|  | treaty_id (FK)                              |                    |
|  | reinsurer_id (FK)                           |                    |
|  | commutation_date                            |                    |
|  | ceded_reserves_at_commutation               |                    |
|  | ceded_ibnr_at_commutation                   |                    |
|  | commutation_amount                          |                    |
|  | discount_rate                               |                    |
|  | status (negotiating/agreed/executed)        |                    |
|  +--------------------------------------------+                    |
|                                                                    |
+====================================================================+
```

### 24.2 SQL Schema for Key Tables

```sql
CREATE TABLE treaty (
    treaty_id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    treaty_number       VARCHAR(30) NOT NULL UNIQUE,
    treaty_name         VARCHAR(200),
    treaty_type         VARCHAR(20) NOT NULL CHECK (treaty_type IN (
                            'QUOTA_SHARE', 'SURPLUS_SHARE', 'PER_RISK_XOL',
                            'PER_OCC_XOL', 'CAT_XOL', 'AGGREGATE_XOL', 'STOP_LOSS')),
    treaty_year         INTEGER NOT NULL,
    effective_date      DATE NOT NULL,
    expiry_date         DATE NOT NULL,
    line_of_business    VARCHAR(50),
    retention           DECIMAL(15,2),
    limit_amount        DECIMAL(15,2),
    aggregate_limit     DECIMAL(15,2),
    ceding_commission   DECIMAL(5,4),
    sliding_scale_min   DECIMAL(5,4),
    sliding_scale_max   DECIMAL(5,4),
    provisional_commission DECIMAL(5,4),
    reinstatement_count INTEGER DEFAULT 0,
    reinstatement_rate  DECIMAL(5,4),
    notification_threshold DECIMAL(15,2),
    alae_treatment      VARCHAR(20) CHECK (alae_treatment IN (
                            'INCLUDED', 'IN_ADDITION', 'EXCLUDED')),
    hours_clause_hours  INTEGER,
    currency            CHAR(3) DEFAULT 'USD',
    status              VARCHAR(15) DEFAULT 'ACTIVE',
    broker_id           UUID,
    created_at          TIMESTAMP DEFAULT NOW(),
    updated_at          TIMESTAMP DEFAULT NOW()
);

CREATE TABLE ceded_reserve (
    ceded_reserve_id    UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    claim_id            UUID NOT NULL,
    treaty_id           UUID REFERENCES treaty(treaty_id),
    certificate_id      UUID,
    reinsurer_id        UUID NOT NULL,
    effective_date      TIMESTAMP NOT NULL DEFAULT NOW(),
    ceded_loss_reserve  DECIMAL(15,2) NOT NULL DEFAULT 0,
    ceded_alae_reserve  DECIMAL(15,2) NOT NULL DEFAULT 0,
    ceded_total_reserve DECIMAL(15,2) GENERATED ALWAYS AS (
                            ceded_loss_reserve + ceded_alae_reserve) STORED,
    gross_loss_at_calc  DECIMAL(15,2),
    retention_applied   DECIMAL(15,2),
    limit_applied       DECIMAL(15,2),
    share_pct_applied   DECIMAL(7,6),
    calculation_method  VARCHAR(30),
    created_by          VARCHAR(50),
    created_at          TIMESTAMP DEFAULT NOW()
);

CREATE TABLE ceded_payment (
    ceded_payment_id    UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    claim_id            UUID NOT NULL,
    treaty_id           UUID REFERENCES treaty(treaty_id),
    certificate_id      UUID,
    reinsurer_id        UUID NOT NULL,
    payment_date        DATE NOT NULL,
    ceded_loss_paid     DECIMAL(15,2) NOT NULL DEFAULT 0,
    ceded_alae_paid     DECIMAL(15,2) NOT NULL DEFAULT 0,
    ceded_total_paid    DECIMAL(15,2) GENERATED ALWAYS AS (
                            ceded_loss_paid + ceded_alae_paid) STORED,
    cash_call_number    VARCHAR(30),
    cash_call_date      DATE,
    cash_call_status    VARCHAR(20) CHECK (cash_call_status IN (
                            'GENERATED', 'SENT', 'ACKNOWLEDGED', 'PAID', 'DISPUTED')),
    payment_received_date DATE,
    amount_received     DECIMAL(15,2),
    currency            CHAR(3) DEFAULT 'USD',
    created_at          TIMESTAMP DEFAULT NOW()
);

CREATE TABLE bordereaux (
    bordereaux_id       UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    treaty_id           UUID NOT NULL REFERENCES treaty(treaty_id),
    reinsurer_id        UUID NOT NULL,
    reporting_period    DATE NOT NULL,
    bordereaux_type     VARCHAR(20) NOT NULL CHECK (bordereaux_type IN (
                            'PREMIUM', 'PAID_LOSS', 'OUTSTANDING', 'COMBINED')),
    status              VARCHAR(20) DEFAULT 'DRAFT' CHECK (status IN (
                            'DRAFT', 'REVIEWED', 'APPROVED', 'SENT', 'ACKNOWLEDGED')),
    generation_date     DATE,
    sent_date           DATE,
    total_records       INTEGER,
    total_ceded_premium DECIMAL(15,2) DEFAULT 0,
    total_ceded_losses  DECIMAL(15,2) DEFAULT 0,
    total_ceded_alae    DECIMAL(15,2) DEFAULT 0,
    total_ceding_commission DECIMAL(15,2) DEFAULT 0,
    net_balance         DECIMAL(15,2) DEFAULT 0,
    file_path           VARCHAR(500),
    created_at          TIMESTAMP DEFAULT NOW()
);

CREATE TABLE commutation (
    commutation_id      UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    treaty_id           UUID NOT NULL REFERENCES treaty(treaty_id),
    reinsurer_id        UUID NOT NULL,
    commutation_date    DATE,
    status              VARCHAR(20) DEFAULT 'PROPOSED' CHECK (status IN (
                            'PROPOSED', 'NEGOTIATING', 'AGREED', 'EXECUTED', 'CANCELLED')),
    ceded_os_at_commutation DECIMAL(15,2),
    ceded_ibnr_at_commutation DECIMAL(15,2),
    ulae_loading        DECIMAL(15,2),
    gross_commutation_value DECIMAL(15,2),
    discount_rate       DECIMAL(5,4),
    present_value       DECIMAL(15,2),
    risk_margin         DECIMAL(15,2),
    final_commutation_amount DECIMAL(15,2),
    effective_date      DATE,
    agreement_signed_date DATE,
    payment_date        DATE,
    notes               TEXT,
    created_at          TIMESTAMP DEFAULT NOW()
);
```

---

## 25. Integration: Primary Claims and Reinsurance Systems

### 25.1 Integration Architecture

```
CLAIMS-REINSURANCE INTEGRATION:
+====================================================================+
|                                                                    |
|  PRIMARY CLAIMS SYSTEM                  REINSURANCE SYSTEM         |
|  +------------------------+            +------------------------+  |
|  |                        |            |                        |  |
|  | Claims Processing      |   Events   | Treaty Management      |  |
|  | ├── FNOL               +----------->| ├── Treaty Registry    |  |
|  | ├── Investigation       |            | ├── Participant Mgmt   |  |
|  | ├── Reserve Mgmt        |  Queries   | ├── Coverage Lookup    |  |
|  | ├── Payment Processing  +<---------->| ├── Allocation Engine  |  |
|  | ├── Settlement          |            | ├── Bordereaux Gen     |  |
|  | └── Closure             |   Calcs    | ├── Cash Call Mgmt     |  |
|  |                        +<-----------+| ├── Accounting         |  |
|  +------------------------+            | └── Reporting          |  |
|                                        +------------------------+  |
|                                                                    |
|  INTEGRATION PATTERNS:                                             |
|                                                                    |
|  1. EVENT-DRIVEN (Preferred):                                      |
|     Claims System publishes domain events:                         |
|     ├── ClaimCreated → RI system checks treaty applicability       |
|     ├── ReserveChanged → RI system recalculates ceded reserves     |
|     ├── PaymentIssued → RI system calculates ceded payment         |
|     ├── ClaimClosed → RI system updates ceded status               |
|     └── CATEventDeclared → RI system initiates aggregation        |
|                                                                    |
|  2. API-BASED (Synchronous):                                      |
|     Claims System calls RI system APIs:                            |
|     ├── GET /treaties/{claim} → applicable treaties for claim      |
|     ├── POST /ceded-reserves → calculate ceded reserves            |
|     ├── POST /cash-calls → generate cash call                     |
|     └── GET /notifications → check notification requirements       |
|                                                                    |
|  3. BATCH (Bordereaux/Reporting):                                  |
|     ├── Nightly extract of claims data                             |
|     ├── Monthly bordereaux generation                              |
|     ├── Quarterly treaty accounting                                |
|     └── Annual statistical reporting                               |
|                                                                    |
+====================================================================+
```

### 25.2 Data Flow Diagram

```
CLAIMS-TO-REINSURANCE DATA FLOW:
+------------------------------------------------------------------+
|                                                                  |
|  CLAIM EVENT IN PRIMARY SYSTEM                                   |
|       │                                                          |
|       ├── New Claim Created                                      |
|       │   └── Check if policy has fac certificates               |
|       │       └── If yes → create fac claim record in RI system  |
|       │                                                          |
|       ├── Reserve Set/Changed                                    |
|       │   ├── Identify applicable treaties                       |
|       │   ├── For proportional: ceded = gross × share %          |
|       │   ├── For XOL: ceded = MAX(0, MIN(limit, gross - ret))   |
|       │   ├── Post ceded reserves by treaty and reinsurer        |
|       │   ├── Check notification thresholds                      |
|       │   └── Generate notification if threshold breached        |
|       │                                                          |
|       ├── Payment Made                                           |
|       │   ├── Calculate ceded payment per treaty                 |
|       │   ├── For XOL: if paid exceeds retention → cash call     |
|       │   ├── For proportional: add to bordereaux                |
|       │   └── Post ceded paid to RI sub-ledger                   |
|       │                                                          |
|       ├── Recovery Received (Salvage/Subrogation)                |
|       │   ├── Calculate reinsurer share of recovery              |
|       │   ├── Update ceded incurred                              |
|       │   └── May require return of funds to reinsurer           |
|       │                                                          |
|       └── Claim Closed                                           |
|           ├── Final ceded reserve = $0                            |
|           ├── Update cumulative ceded paid final                  |
|           └── Close reinsurance claim record                     |
|                                                                  |
+------------------------------------------------------------------+
```

---

## 26. Reinsurance Accounting System Integration

### 26.1 General Ledger Entries

```
REINSURANCE GL ENTRIES:
+------------------------------------------------------------------+
|                                                                  |
|  CEDED RESERVE POSTING:                                          |
|  DR: Reinsurance Recoverable on Paid Losses (Asset)              |
|  CR: Ceded Losses Incurred (Contra-Expense)                      |
|                                                                  |
|  CEDED PAYMENT:                                                  |
|  DR: Reinsurance Recoverable on Paid Losses                      |
|  CR: Ceded Paid Losses                                           |
|                                                                  |
|  REINSURANCE PAYMENT RECEIVED:                                   |
|  DR: Cash/Bank Account                                           |
|  CR: Reinsurance Recoverable on Paid Losses                      |
|                                                                  |
|  CEDED PREMIUM:                                                  |
|  DR: Ceded Premium (Contra-Revenue)                              |
|  CR: Amounts Due to Reinsurers (Liability)                       |
|                                                                  |
|  CEDING COMMISSION:                                              |
|  DR: Amounts Due to Reinsurers                                   |
|  CR: Ceding Commission Income (Revenue)                          |
|                                                                  |
+------------------------------------------------------------------+
```

---

## 27. Financial Reporting for Ceded Claims

### 27.1 Schedule F

```
SCHEDULE F (NAIC ANNUAL STATEMENT):
+------------------------------------------------------------------+
|                                                                  |
|  PURPOSE:                                                        |
|  ├── Report all reinsurance transactions                         |
|  ├── Demonstrate ability to recover reinsurance receivables      |
|  ├── Calculate provision for reinsurance (penalty for             |
|  │   unauthorized or slow-paying reinsurers)                     |
|  └── Required for all admitted carriers                          |
|                                                                  |
|  KEY PARTS:                                                      |
|  ├── Part 1: Assumed reinsurance                                 |
|  ├── Part 2: Portfolio reinsurance                               |
|  ├── Part 3: Ceded reinsurance (treaty and fac)                  |
|  │   ├── Reinsurer name and NAIC code                            |
|  │   ├── Effective dates                                         |
|  │   ├── Ceded premium                                           |
|  │   ├── Ceded losses paid                                       |
|  │   ├── Ceded losses outstanding                                |
|  │   ├── Ceded losses incurred                                   |
|  │   └── Recoverables on paid losses                             |
|  ├── Part 4: Aging of recoverables                               |
|  │   ├── 0-90 days                                               |
|  │   ├── 91-180 days                                             |
|  │   ├── Over 180 days                                           |
|  │   └── In dispute                                              |
|  ├── Part 5: Unauthorized reinsurance                            |
|  └── Part 6: Provision for reinsurance calculation               |
|                                                                  |
|  CREDIT FOR REINSURANCE:                                         |
|  ├── Authorized reinsurers: full credit on balance sheet         |
|  ├── Certified reinsurers: full or reduced credit per rating     |
|  ├── Unauthorized: credit only with collateral                   |
|  │   (trust fund, LOC, funds withheld)                           |
|  └── Provision penalty for slow-paying or non-collateralized     |
|                                                                  |
+------------------------------------------------------------------+
```

---

## 28. Collateral and Trust Account Management

### 28.1 Collateral Types

```
REINSURANCE COLLATERAL:
+------------------------------------------------------------------+
|                                                                  |
|  TYPES OF COLLATERAL:                                            |
|  +------------------------------------------------------------+  |
|  | Type              | Description                             |  |
|  +------------------------------------------------------------+  |
|  | Trust Fund        | Assets held in trust for cedent's       |  |
|  |                   | benefit; meets credit for RI requirement|  |
|  | Letter of Credit  | Bank-issued LOC payable on demand;      |  |
|  |                   | annual renewal; meets credit for RI     |  |
|  | Funds Withheld    | Cedent retains portion of ceded premium |  |
|  |                   | as de facto collateral                  |  |
|  | Cash Deposit      | Cash deposited with cedent              |  |
|  +------------------------------------------------------------+  |
|                                                                  |
|  COLLATERAL ADEQUACY MONITORING:                                 |
|  ├── Ceded reserves vs. collateral held                          |
|  ├── Regular (monthly/quarterly) adequacy testing                |
|  ├── Top-up requests when reserves exceed collateral             |
|  ├── Release when reserves decrease                              |
|  ├── LOC renewal tracking (ensure no gaps)                       |
|  └── Trust fund investment monitoring                            |
|                                                                  |
|  SYSTEM REQUIREMENTS:                                            |
|  ├── Track collateral by reinsurer and treaty                    |
|  ├── Calculate required collateral vs. available                 |
|  ├── Automated alerts for inadequacy or expiring LOCs            |
|  ├── Integration with investment management (trusts)             |
|  └── Reporting for Schedule F compliance                         |
|                                                                  |
+------------------------------------------------------------------+
```

---

## 29. Reinsurance Recoverable Tracking

### 29.1 Recoverable Management

```
RI RECOVERABLE TRACKING:
+------------------------------------------------------------------+
|                                                                  |
|  COMPONENTS OF REINSURANCE RECOVERABLES:                         |
|  ├── Recoverables on paid losses (billed to reinsurer)           |
|  ├── Recoverables on outstanding losses (case reserves)          |
|  ├── Recoverables on IBNR (actuarial estimate)                   |
|  └── Recoverables on paid ALAE                                   |
|                                                                  |
|  AGING TRACKING:                                                 |
|  +------------------------------------------------------------+  |
|  | Status            | Description            | Action          |  |
|  +------------------------------------------------------------+  |
|  | Current (0-30 d)  | Recently billed        | Monitor         |  |
|  | 31-60 days        | First follow-up        | Reminder        |  |
|  | 61-90 days        | Second follow-up       | Escalate        |  |
|  | 91-180 days       | Overdue                | Demand letter   |  |
|  | >180 days         | Significantly overdue  | Legal/offset    |  |
|  | In Dispute        | Reinsurer disputes     | Resolution      |  |
|  +------------------------------------------------------------+  |
|                                                                  |
|  BAD DEBT ASSESSMENT:                                            |
|  ├── Reinsurer financial strength monitoring                     |
|  │   ├── AM Best rating changes                                  |
|  │   ├── S&P/Moody's/Fitch ratings                              |
|  │   └── Regulatory actions                                     |
|  ├── Provision for uncollectible reinsurance                     |
|  ├── Concentration risk analysis                                 |
|  │   ├── Maximum exposure to single reinsurer                    |
|  │   ├── Top 10 reinsurer exposures                              |
|  │   └── Rating distribution of reinsurance panel                |
|  └── Commutation consideration for weak reinsurers              |
|                                                                  |
+------------------------------------------------------------------+
```

---

## 30. Reinsurance Claims Reporting Dashboards

### 30.1 Key Dashboard Views

```
REINSURANCE CLAIMS DASHBOARDS:
+------------------------------------------------------------------+
|                                                                  |
|  EXECUTIVE DASHBOARD:                                            |
|  ├── Gross vs Net incurred by line of business                   |
|  ├── Ceded loss ratio by treaty                                  |
|  ├── Reinsurance recovery rate                                   |
|  ├── Top 10 ceded claims by size                                 |
|  ├── Cat event aggregate vs retention                            |
|  └── Reinsurance program utilization                             |
|                                                                  |
|  TREATY PERFORMANCE DASHBOARD:                                   |
|  ├── Loss ratio by treaty year                                   |
|  ├── Sliding scale commission projection                         |
|  ├── Reinstatement utilization                                   |
|  ├── Claims frequency and severity by treaty                     |
|  └── Development patterns by treaty year                         |
|                                                                  |
|  RECOVERABLE MANAGEMENT DASHBOARD:                               |
|  ├── Total recoverables by reinsurer                             |
|  ├── Aging of recoverables (0-30, 31-60, 61-90, 91+, dispute)  |
|  ├── Collection rates and trends                                 |
|  ├── Disputed amounts by reinsurer                               |
|  └── Collateral adequacy by reinsurer                            |
|                                                                  |
|  NOTIFICATION COMPLIANCE DASHBOARD:                              |
|  ├── Claims requiring notification                               |
|  ├── Notifications pending vs sent                               |
|  ├── Timeliness of notifications                                 |
|  ├── Outstanding reinsurer inquiries                             |
|  └── Overdue status reports                                      |
|                                                                  |
|  BORDEREAUX MANAGEMENT DASHBOARD:                                |
|  ├── Bordereaux production schedule and status                   |
|  ├── Outstanding bordereaux by treaty/reinsurer                  |
|  ├── Reconciliation status                                       |
|  └── Historical bordereaux comparison                            |
|                                                                  |
+------------------------------------------------------------------+
```

---

## 31. Technology Platforms

### 31.1 Reinsurance Systems Landscape

```
REINSURANCE TECHNOLOGY PLATFORMS:
+------------------------------------------------------------------+
| Category             | Platforms                                  |
+------------------------------------------------------------------+
| Reinsurance Admin    | Swiss Re PULSE, Gen Re SMART,              |
|                      | SAP FS-RI, RMS RiskLink, DXC Xuber,       |
|                      | Sapiens ReinsuranceMaster, Majesco         |
+------------------------------------------------------------------+
| Cat Modeling         | RMS RiskLink, AIR Touchstone,              |
|                      | CoreLogic RQE, JBA Flood Model             |
+------------------------------------------------------------------+
| Accounting           | SAP, Oracle, Workday Financial,            |
|                      | IRIS (Ebix), SunGard                       |
+------------------------------------------------------------------+
| Claims Integration   | Guidewire ClaimCenter (RI module),          |
|                      | Duck Creek Claims, custom integration      |
+------------------------------------------------------------------+
| London Market        | ECF/Vitesse, CLASS, DXC Ins. Platform,      |
|                      | Sequel Eclipse                             |
+------------------------------------------------------------------+
| Data/Analytics       | Snowflake, Databricks, Power BI, Tableau,  |
|                      | SAS                                        |
+------------------------------------------------------------------+
| Integration          | MuleSoft, Dell Boomi, Apache Kafka,        |
|                      | ACORD messaging                            |
+------------------------------------------------------------------+
```

---

## 32. Performance Metrics

### 32.1 Reinsurance Claims KPIs

```
REINSURANCE CLAIMS PERFORMANCE METRICS:
+------------------------------------------------------------------+
|                                                                  |
|  FINANCIAL METRICS:                                              |
|  +------------------------------------------------------------+  |
|  | Metric                         | Target/Benchmark          |  |
|  +------------------------------------------------------------+  |
|  | Ceded Loss Ratio (by treaty)   | Per treaty plan           |  |
|  | Net Loss Ratio                 | < Gross LR after RI       |  |
|  | RI Recovery Rate               | % of gross recovered      |  |
|  | Cash Call Collection Time       | < 30 days from billing   |  |
|  | Recoverable Aging (% > 90 days)| < 5%                     |  |
|  | Disputed Recoverables          | < 2% of total             |  |
|  | Uncollectible Write-offs       | < 0.5% of ceded           |  |
|  | Commutation Savings            | NPV vs. continued runoff  |  |
|  +------------------------------------------------------------+  |
|                                                                  |
|  OPERATIONAL METRICS:                                            |
|  +------------------------------------------------------------+  |
|  | Metric                         | Target/Benchmark          |  |
|  +------------------------------------------------------------+  |
|  | Notification Timeliness         | > 95% within contractual |  |
|  | Bordereaux Production           | 100% on schedule         |  |
|  | Bordereaux Error Rate           | < 1% of records          |  |
|  | Cash Call Processing Time       | < 5 business days        |  |
|  | Ceded Reserve Accuracy          | Within ± 5% of ultimate  |  |
|  | Treaty Accounting Timeliness    | < 30 days after period   |  |
|  | Reinsurer Inquiry Response Time | < 5 business days        |  |
|  | Collateral Adequacy             | 100% compliant           |  |
|  +------------------------------------------------------------+  |
|                                                                  |
+------------------------------------------------------------------+
```

---

## Summary

Reinsurance claims operations represent a critical function that bridges the primary claims organization and the reinsurance program. For a solutions architect, the key design considerations are:

1. **Real-time ceded reserve calculation** — every gross reserve change must instantly cascade to ceded calculations
2. **Treaty matching engine** — automated identification of applicable treaties for each claim
3. **Multi-treaty stacking** — correct application of layered reinsurance programs
4. **Bordereaux automation** — reliable, reconciled periodic reporting
5. **Cash call management** — efficient billing and tracking of XOL recoveries
6. **Notification compliance** — automated threshold monitoring and alert generation
7. **Financial integration** — seamless GL posting of ceded reserves and recoverables
8. **Collateral monitoring** — continuous adequacy tracking and alert systems
9. **Event aggregation** — catastrophe claims aggregation for per-occurrence treaties
10. **Multi-currency support** — London market and international reinsurance processing

The data model must maintain the full audit trail of ceded reserves, payments, and recoveries while supporting the complex calculations required by diverse treaty structures.
