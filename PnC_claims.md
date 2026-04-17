# Property & Casualty (P&C) Claims Processing — The Definitive Guide

> A comprehensive reference covering end-to-end claims lifecycle, data standards, technical architecture, workflows, and product strategy. Designed to prepare Product Owners, Business Analysts, and technologists for leadership roles in P&C insurance claims organizations.

---

## Table of Contents

1. [Industry Overview](#1-industry-overview)
2. [Claims Lifecycle — End to End](#2-claims-lifecycle--end-to-end)
3. [Lines of Business (LOBs)](#3-lines-of-business-lobs)
4. [Claims Organization & Roles](#4-claims-organization--roles)
5. [First Notice of Loss (FNOL)](#5-first-notice-of-loss-fnol)
6. [Claims Investigation & Adjustment](#6-claims-investigation--adjustment)
7. [Reserving](#7-reserving)
8. [Litigation Management](#8-litigation-management)
9. [Subrogation & Recovery](#9-subrogation--recovery)
10. [Settlement & Payment](#10-settlement--payment)
11. [Fraud Detection (SIU)](#11-fraud-detection-siu)
12. [Catastrophe (CAT) Claims](#12-catastrophe-cat-claims)
13. [Data Standards & Industry Formats](#13-data-standards--industry-formats)
14. [Technical Architecture & Platforms](#14-technical-architecture--platforms)
15. [Integrations & Ecosystem](#15-integrations--ecosystem)
16. [Regulatory & Compliance](#16-regulatory--compliance)
17. [Key Metrics & KPIs](#17-key-metrics--kpis)
18. [AI, ML & Advanced Analytics in Claims](#18-ai-ml--advanced-analytics-in-claims)
19. [Product Owner Responsibilities in Claims](#19-product-owner-responsibilities-in-claims)
20. [Common Use Cases & User Stories](#20-common-use-cases--user-stories)
21. [Interview Preparation — Key Concepts & Questions](#21-interview-preparation--key-concepts--questions)
22. [Glossary](#22-glossary)

---

## 1. Industry Overview

### What is P&C Insurance?

Property and Casualty (P&C) insurance — also called General Insurance or Non-Life Insurance outside the US — protects policyholders against financial losses arising from damage to property (Property) or legal liability for injuries/damages caused to third parties (Casualty/Liability).

### The Claims Function

Claims is the **fulfillment arm** of the insurance promise. When a policyholder experiences a covered loss, the claims organization investigates, evaluates, and settles the claim. It is the single largest cost center for any P&C carrier, typically consuming **60–80% of every premium dollar** collected (known as the **loss ratio**).

### Why Claims Matters to Product Owners

- **Customer Experience**: 87% of policyholders say the claims experience determines whether they renew (J.D. Power).
- **Financial Impact**: A 1-point improvement in the loss ratio on a $5B book of business = $50M to the bottom line.
- **Regulatory Scrutiny**: Every US state Department of Insurance monitors claims handling practices; violations lead to fines, market conduct exams, and consent orders.
- **Data Richness**: Claims systems generate massive structured and unstructured data — the foundation for predictive analytics, fraud detection, and pricing feedback loops.

### The Combined Ratio

```
Combined Ratio = Loss Ratio + Expense Ratio

Loss Ratio     = (Incurred Losses + LAE) / Earned Premium
Expense Ratio  = Underwriting Expenses / Written Premium
```

A combined ratio below 100% means the insurer is making an underwriting profit. Claims directly drives the loss ratio.

---

## 2. Claims Lifecycle — End to End

The claims lifecycle is a multi-stage process that begins when a loss event occurs and ends when the claim file is closed. Each stage has defined inputs, outputs, decision gates, and system interactions.

### 2.1 High-Level Flow

```
┌──────────┐    ┌──────────┐    ┌───────────┐    ┌───────────┐    ┌──────────┐    ┌─────────┐
│  Loss    │───▶│  FNOL    │───▶│ Triage &  │───▶│ Investiga-│───▶│ Reserving│───▶│ Evalua- │
│  Event   │    │  Intake  │    │ Assignment│    │   tion    │    │          │    │  tion   │
└──────────┘    └──────────┘    └───────────┘    └───────────┘    └──────────┘    └─────────┘
                                                                                       │
                                                                                       ▼
┌──────────┐    ┌──────────┐    ┌───────────┐    ┌───────────┐    ┌──────────┐    ┌─────────┐
│  Close   │◀───│ Recovery │◀───│ Payment / │◀───│  Settle-  │◀───│ Negotia- │◀───│ Coverage│
│          │    │ Subro    │    │ Disburse  │    │   ment    │    │  tion    │    │ Decision│
└──────────┘    └──────────┘    └───────────┘    └───────────┘    └──────────┘    └─────────┘
```

### 2.2 Detailed Stage Descriptions

| Stage | Description | Key Actors | System Touchpoints |
|-------|------------|------------|-------------------|
| **Loss Event** | The insured peril occurs (accident, fire, storm, slip-and-fall). | Policyholder, Third Party | None (external event) |
| **FNOL** | First Notice of Loss is reported via phone, web, mobile app, agent, or ACORD form. | Policyholder, Agent, Call Center Rep | Claims System, IVR, Portal, Mobile App |
| **Triage & Assignment** | Claim is scored for complexity/severity and routed to the appropriate adjuster or team. | Claims Supervisor, Rules Engine | Claims System, Workload Balancer |
| **Coverage Verification** | Policy is reviewed to confirm the loss is covered, within policy period, and no exclusions apply. | Adjuster, Coverage Counsel | Policy Admin System (PAS), Claims System |
| **Investigation** | Facts of loss are gathered: statements, police reports, photos, scene inspections, expert reports. | Adjuster, Field Inspector, SIU | Claims System, Vendor Management, Telematics |
| **Reserving** | Financial estimate of the claim's ultimate cost is established and updated throughout the life of the claim. | Adjuster, Actuary, Reserve Committee | Claims System, Actuarial Models |
| **Evaluation** | Damages are quantified: property damage estimates, medical specials, lost wages, general damages. | Adjuster, Appraiser, Medical Reviewer | Estimating Tools (Mitchell, CCC, Xactimate) |
| **Negotiation** | Settlement discussions with claimant, attorney, or public adjuster. | Adjuster, Claimant Attorney | Claims System, Correspondence |
| **Settlement** | Agreement on payment amount; release/settlement agreement executed. | Adjuster, Claimant | Claims System, Document Management |
| **Payment** | Funds disbursed via check, EFT, or virtual card. | Claims Accounting, Adjuster | Payment System, Bank, Treasury |
| **Subrogation/Recovery** | Pursue recovery from at-fault third parties or their insurers. | Subro Unit, Arbitration Forums | Subro Management System, Arbitration Forums |
| **Close** | Claim file is closed; all financials are finalized. | Adjuster, Supervisor | Claims System |
| **Reopen** | Claim may be reopened if new information or supplemental damages arise. | Adjuster | Claims System |

---

## 3. Lines of Business (LOBs)

Claims processing varies significantly by line of business. A Product Owner must understand the nuances of each.

### 3.1 Personal Lines

| LOB | Coverage | Claims Characteristics |
|-----|----------|----------------------|
| **Personal Auto** | Collision, Comprehensive, Liability (BI/PD), UM/UIM, PIP/MedPay, Rental, Towing | High volume, high automation potential, telematics data, photo-based AI estimation |
| **Homeowners (HO)** | Dwelling, Other Structures, Personal Property, Loss of Use, Liability | Weather-driven CAT surges, contractor management, contents inventories, mold/water complexity |
| **Renters** | Personal Property, Liability, Loss of Use | Lower severity, higher frequency, simple adjustment |
| **Personal Umbrella** | Excess Liability over Auto + HO | Triggered by large BI claims, litigation-heavy |

### 3.2 Commercial Lines

| LOB | Coverage | Claims Characteristics |
|-----|----------|----------------------|
| **Commercial Auto** | Fleet vehicles, Hired/Non-owned Auto, Trucking | DOT regulations, fleet safety data, MCS-90 endorsements |
| **Commercial Property** | Buildings, BPP, Business Income, Equipment Breakdown | Large loss potential, business interruption calculations, forensic accounting |
| **General Liability (GL)** | Premises Liability, Products Liability, Completed Operations | Long-tail claims, litigation-driven, medical record reviews |
| **Workers' Compensation** | Medical, Indemnity (TTD/TPD/PTD/PPD), Vocational Rehab, Death Benefits | State-specific fee schedules, Return-to-Work programs, Medicare Set-Asides, NCCI |
| **Commercial Umbrella/Excess** | Excess over GL, Auto, Employers Liability | Large limits, follow-form, complex coverage triggers |
| **Professional Liability (E&O)** | Errors & Omissions for professionals | Claims-made policies, defense-within-limits, consent-to-settle clauses |
| **Directors & Officers (D&O)** | Management liability | Securities class actions, Side A/B/C coverage, Severability |
| **Cyber Liability** | Data breach, ransomware, business interruption, regulatory fines | Incident response coordination, forensics vendors, notification costs |
| **Marine / Inland Marine** | Cargo, Hull, Builders Risk, Contractors Equipment | Admiralty law, general average, salvage |
| **Surety** | Contract Bonds, Commercial Bonds | Bond principal default, performance completion, indemnity agreements |

### 3.3 Specialty / Emerging

- **Parametric Insurance**: Claims triggered automatically by predefined index (e.g., earthquake magnitude, rainfall amount) — no adjustment needed.
- **Embedded Insurance**: Claims initiated from partner platforms (e.g., ride-share, e-commerce).
- **Usage-Based Insurance (UBI)**: Telematics data directly informs liability determination and severity.
- **Microinsurance**: High-volume, low-severity, fully automated straight-through processing.

---

## 4. Claims Organization & Roles

### 4.1 Organizational Structure

```
                    ┌──────────────────┐
                    │   Chief Claims   │
                    │     Officer      │
                    └────────┬─────────┘
           ┌─────────────────┼─────────────────────┐
           │                 │                      │
  ┌────────▼──────┐  ┌──────▼───────┐   ┌─────────▼────────┐
  │  VP Personal  │  │VP Commercial │   │  VP Claims Ops   │
  │    Lines      │  │   Lines      │   │  & Technology    │
  └────────┬──────┘  └──────┬───────┘   └─────────┬────────┘
           │                │                      │
    ┌──────┼──────┐  ┌──────┼──────┐        ┌─────┼──────┐
    │      │      │  │      │      │        │     │      │
  Auto   Prop  Liab GL    WC   Spec     SIU   Subro   CAT
```

### 4.2 Key Roles

| Role | Responsibility |
|------|---------------|
| **Claims Adjuster (Inside/Desk)** | Handles claims remotely: contacts claimants, reviews documentation, makes coverage/liability/damage decisions, negotiates settlements. |
| **Field Adjuster** | Physically inspects loss sites, vehicles, injuries. Increasingly supplemented by virtual inspections. |
| **Claims Examiner** | Senior adjuster handling complex/high-value claims. Common in liability and WC. |
| **Claims Supervisor/Manager** | Oversees a team of adjusters, reviews reserves, approves authority-exceeding payments. |
| **Special Investigations Unit (SIU)** | Investigates suspected fraud, conducts Examinations Under Oath (EUOs), coordinates with law enforcement. |
| **Subrogation Specialist** | Identifies and pursues recovery from responsible third parties. |
| **Litigation Manager** | Manages claims in suit, selects and supervises defense counsel, controls legal spend. |
| **Catastrophe (CAT) Adjuster** | Deployed to disaster zones for high-volume property claims; often independent contractors. |
| **Claims Nurse / Medical Case Manager** | Reviews medical records, manages treatment plans in WC and complex BI claims. |
| **Total Loss Specialist** | Handles vehicle total loss valuations using CCC/Mitchell data. |
| **Claims Product Owner** | Defines and prioritizes the claims technology backlog, translates business needs into user stories, measures outcomes. |
| **Claims Business Analyst** | Elicits requirements, maps processes, supports UAT, writes specifications. |
| **Actuary (Claims)** | Develops reserve models, triangulation analyses, ultimate loss projections. |
| **Vendor Manager** | Manages relationships with IMEs, repair shops, restoration companies, legal counsel panels. |

---

## 5. First Notice of Loss (FNOL)

FNOL is the most critical moment in the claims journey — it sets the tone for the customer experience and determines downstream processing efficiency.

### 5.1 FNOL Channels

| Channel | Volume Share (Industry Avg) | Characteristics |
|---------|---------------------------|----------------|
| **Phone (Call Center)** | 40–50% | Highest cost per intake; richest information capture; declining share |
| **Web Portal** | 15–25% | Self-service; structured data collection; growing rapidly |
| **Mobile App** | 10–20% | Photo/video capture; GPS location; push notifications; fastest growing |
| **Agent-Reported** | 10–15% | Agent uses carrier portal or ACORD form; relationship-driven |
| **Email/Fax** | 5–10% | Unstructured; requires manual processing or NLP extraction |
| **Third-Party / EDI** | 5–10% | ACORD, ISO ClaimSearch, law enforcement feeds, eCLAIMS |
| **Chat / Virtual Assistant** | 2–5% | AI-powered; handles simple claims; escalates complex ones |
| **IoT / Telematics Auto-FNOL** | <2% | Crash detection triggers automatic FNOL; emerging capability |

### 5.2 FNOL Data Elements

A comprehensive FNOL captures the following data (mapped to ACORD standards):

**Claim Header**
- Claim Number (system-generated)
- Policy Number
- Date of Loss / Time of Loss
- Date Reported
- Reported By (Insured, Agent, Third Party, Attorney)
- Loss Location (Address, GPS coordinates)
- Loss Description (free text + structured codes)
- Catastrophe Code (if applicable)
- Jurisdiction / State

**Cause of Loss Codes (ISO/ACORD)**
- Fire, Lightning, Windstorm, Hail, Explosion, Smoke, Vandalism, Theft, Water Damage, Collapse, Falling Objects, Vehicle Impact, Earthquake, Flood, etc.
- Auto: Collision, Comprehensive, Hit-and-Run, Glass, Animal Strike, Mechanical Breakdown

**Claimant Information**
- Named Insured details
- Additional claimant(s) — passengers, pedestrians, property owners
- Claimant type: First Party, Third Party, Subrogation
- Contact information, Attorney representation status

**Vehicle Information (Auto)**
- VIN, Year, Make, Model, Mileage
- Pre-loss condition
- Point of impact
- Driveable status
- Location of vehicle

**Property Information (Property)**
- Dwelling type, Construction, Year Built
- Damage description by room/area
- Emergency mitigation performed
- Contractor engaged

**Injury Information**
- Body part injured (ICD-10 codes)
- Nature of injury
- Treatment status (ER, hospitalization, ongoing)
- Lost time from work

**Other Parties**
- Other driver/owner information
- Other vehicle information
- Witnesses
- Police report number and jurisdiction

### 5.3 FNOL Automation & Straight-Through Processing (STP)

Modern carriers aim for **Straight-Through Processing** — claims that are filed, triaged, adjusted, and paid without human intervention.

**STP Eligibility Criteria (Example — Personal Auto Glass)**
- Single-vehicle, glass-only claim
- No injuries
- Policy in force, coverage confirmed
- No prior fraud indicators
- Below a dollar threshold (e.g., $2,500)
- Repair vs. Replace decision automated via vendor rules

**STP Rates by LOB**
| LOB | Current STP Rate | Target STP Rate |
|-----|-----------------|----------------|
| Auto Glass | 60–80% | 90%+ |
| Auto Collision (simple) | 15–25% | 40% |
| Homeowners (small water) | 10–20% | 35% |
| Workers' Comp (medical-only) | 20–35% | 50% |
| Commercial Property | <5% | 15% |

### 5.4 FNOL Triage & Segmentation

After intake, claims are segmented using rules engines or ML models:

**Complexity Tiers**
| Tier | Criteria | Handling |
|------|----------|---------|
| **Fast Track** | Low severity, clear liability, no injuries or minor soft tissue only | Junior adjuster or auto-adjudication |
| **Standard** | Moderate severity, liability questions, property + injury | Experienced adjuster |
| **Complex** | High severity, disputed liability, multiple claimants, litigation likely | Senior examiner, coverage counsel |
| **Major/Severe** | Catastrophic injury, fatality, large commercial loss, excess layer involvement | Specialized unit, executive oversight |

**Segmentation Variables**
- Loss type and cause code
- Estimated severity (predictive model score)
- Litigation propensity score
- Fraud score (SIU referral flag)
- Geographic jurisdiction (litigation climate)
- Claimant representation status
- Policy type and limits
- Prior claim history

---

## 6. Claims Investigation & Adjustment

### 6.1 Investigation Activities

| Activity | Description | LOBs |
|----------|------------|------|
| **Recorded Statement** | Adjuster takes a recorded account of the loss from insured and/or claimant. | All |
| **Scene Inspection** | Physical visit to loss location; increasingly replaced by drone/satellite imagery for property. | Property, GL, Auto (complex) |
| **Police / Fire Report** | Official report obtained to establish facts, parties, and preliminary fault. | Auto, Property, GL |
| **Photo/Video Documentation** | Damage photos from insured (mobile upload), field adjuster, or drone. | All |
| **Medical Records Review** | Obtain and review medical records and bills for injury claims. | Auto BI, WC, GL |
| **Independent Medical Exam (IME)** | Carrier-ordered exam by independent physician to verify injury, treatment, and causation. | WC, Auto BI, GL |
| **Expert Retention** | Engineers (origin & cause), accident reconstructionists, economists, vocational experts, forensic accountants. | Complex claims across LOBs |
| **Index Bureau Search** | ISO ClaimSearch query to identify prior claims, multiple filings, or suspicious patterns. | All |
| **Social Media Investigation** | Open-source intelligence (OSINT) to verify claimant activity levels, especially in BI/WC. | BI, WC, GL |
| **Surveillance** | Physical or digital surveillance of claimant in suspected fraud or exaggeration cases. | WC, BI, GL |
| **Examination Under Oath (EUO)** | Formal examination of insured; a policy condition in most first-party policies. | Property (suspected fraud), Auto |
| **Appraisal** | Independent valuation of property damage when insured and carrier disagree on amount. | Property, Auto |

### 6.2 Liability Determination (Auto)

**Negligence Framework**
- **Contributory Negligence**: Claimant barred if any fault (4 states + DC)
- **Pure Comparative Negligence**: Damages reduced by claimant's fault percentage (13 states)
- **Modified Comparative (50% Bar)**: Claimant barred if 50%+ at fault (12 states)
- **Modified Comparative (51% Bar)**: Claimant barred if 51%+ at fault (21 states)

**Liability Decision Inputs**
- Police report
- Recorded statements
- Physical evidence / point of impact
- Witness statements
- Traffic laws / right-of-way rules
- Accident reconstruction (complex cases)
- Telematics / dash-cam data

**Liability Codes**
```
Code   Description
─────  ─────────────────────────
100-0  Insured fully at fault
0-100  Other party fully at fault
50-50  Equal fault
75-25  Insured majority at fault
WNE    Word vs. No Evidence
Deny   No liability / coverage denial
```

### 6.3 Damage Evaluation

**Auto Physical Damage**

| Concept | Description |
|---------|------------|
| **Estimate** | Line-by-line repair cost using labor rates, parts prices, paint/materials. Written in CCC ONE, Mitchell, or Audatex. |
| **Supplement** | Additional damage discovered during repair; requires re-inspection or photo review. |
| **Total Loss** | Repair cost exceeds threshold (typically 70–80% of ACV). Vehicle valued using CCC Valuescope, Mitchell WorkCenter, or JD Power. |
| **Actual Cash Value (ACV)** | Replacement cost minus depreciation. Comparable vehicle analysis using local market data. |
| **Diminished Value** | Post-repair loss in market value. Required in some states (Georgia, etc.). |
| **Rental / Loss of Use** | Substitute transportation during repair or replacement period. |
| **Salvage** | Carrier takes ownership of totaled vehicle; sold through Copart, IAA, or direct channels. |

**Property Damage (Homeowners)**

| Tool | Vendor | Use |
|------|--------|-----|
| **Xactimate** | Verisk/Xactware | Industry-standard estimating for structural and contents damage. Uses local labor/material pricing. |
| **Symbility (now CoreLogic)** | CoreLogic | Cloud-based property estimating, collaboration between carrier and contractor. |
| **ClaimXperience** | Verisk | Virtual collaboration platform for remote inspections and policyholder self-service. |
| **HOVER** | HOVER | Smartphone-based exterior measurement using 3D modeling. |
| **EagleView** | EagleView | Aerial imagery and roof measurement reports. |

**Bodily Injury Evaluation**

| Component | Description |
|-----------|------------|
| **Medical Specials** | Total medical expenses: ER, surgery, physical therapy, diagnostics, prescriptions. |
| **Lost Wages** | Documented income loss during recovery. Requires employer verification. |
| **General Damages (Pain & Suffering)** | Non-economic damages. Evaluated using multiplier method (specials × factor), per diem method, or jury verdict research. |
| **Colossus / Claims Outcome Advisor** | Automated BI evaluation tools that analyze injury details and produce settlement ranges. |
| **ISO ClaimSearch Medical** | Verifies medical provider billing patterns and claimant history. |
| **Verdict & Settlement Research** | Jury Verdict Reporter, LexisNexis Verdict & Settlement Analyzer — benchmarking tools for litigation-value claims. |

---

## 7. Reserving

Reserves are the financial estimate of the insurer's ultimate liability for a claim. Accurate reserving is critical for financial reporting, reinsurance, and regulatory compliance.

### 7.1 Reserve Types

| Reserve Type | Definition |
|-------------|-----------|
| **Case Reserve (Indemnity)** | Adjuster's estimate of the claim payment amount. |
| **Expense Reserve (ALAE/ULAE)** | Estimated costs to adjust the claim: defense counsel fees, expert fees, IME costs. ALAE = Allocated Loss Adjustment Expense. ULAE = Unallocated Loss Adjustment Expense. |
| **IBNR (Incurred But Not Reported)** | Actuarial estimate of claims that have occurred but not yet been reported. Critical for financial statements. |
| **IBNER (Incurred But Not Enough Reserved)** | Actuarial adjustment for development on known claims. |
| **Salvage & Subrogation Reserve** | Estimated recoveries that offset paid losses. |
| **Bulk / Formula Reserve** | System-generated initial reserve based on claim type, severity score, and historical averages. Used at FNOL before adjuster review. |

### 7.2 Reserve Best Practices

- **Initial Reserve**: Set within 24–48 hours of FNOL based on available facts.
- **Staircase Reserving**: Avoid incremental "staircase" increases. Set reserves at ultimate anticipated value.
- **Reserve Reviews**: Mandatory review cadence — 30/60/90 days and at every significant diary event.
- **Authority Levels**: Tiered authority (e.g., Adjuster: $50K, Supervisor: $250K, Manager: $500K, VP: $1M+, Reserve Committee: $5M+).
- **Reserve Adequacy**: Actuarial review of reserve adequacy quarterly; triangulation analysis (chain-ladder, Bornhuetter-Ferguson, Cape Cod methods).

### 7.3 Actuarial Methods

| Method | Description | Best For |
|--------|------------|----------|
| **Chain-Ladder (Development)** | Uses historical loss development patterns to project ultimate losses from current data. | Mature LOBs with stable development patterns |
| **Bornhuetter-Ferguson** | Blends expected loss ratio with actual emergence. Less sensitive to early development volatility. | Immature accident years, long-tail lines |
| **Cape Cod** | Similar to BF but derives expected losses from the data itself. | Smaller portfolios |
| **Frequency-Severity** | Projects claim counts and average costs separately. | When count and severity trends diverge |
| **Paid vs. Incurred** | Runs methods on both paid and incurred data for validation. | Cross-checking reserve estimates |

### 7.4 Loss Triangles

Loss triangles (development triangles) are the fundamental data structure for actuarial reserving:

```
Accident   Development Period (Months)
  Year     12      24      36      48      60    Ultimate
──────── ────── ─────── ─────── ─────── ────── ─────────
  2021    45,000  72,000  85,000  91,000  94,000   96,000
  2022    48,000  78,000  90,000  95,000    ???      ???
  2023    52,000  82,000    ???     ???      ???      ???
  2024    50,000    ???     ???     ???      ???      ???
```

Development factors are calculated column-to-column and applied to project the "???" cells.

---

## 8. Litigation Management

### 8.1 When Claims Enter Litigation

A claim enters litigation when:
- A **Demand Letter** is received from claimant's attorney exceeding the carrier's evaluation.
- A **Summons and Complaint** is served on the insured.
- The claim involves **coverage disputes** requiring declaratory judgment.
- **Bad faith** allegations are made against the carrier.

### 8.2 Litigation Workflow

```
Suit Received ──▶ Conflict Check ──▶ Counsel Assignment ──▶ Answer Filed
      │                                      │
      ▼                                      ▼
Litigation Plan ◀────────────────── Initial Case Assessment
      │
      ▼
Discovery Phase ──▶ Depositions ──▶ Expert Reports ──▶ Mediation ──▶ Trial/Settlement
      │                                                     │
      ▼                                                     ▼
IME / DME                                            MSA (Medicare Set-Aside)
                                                     if applicable
```

### 8.3 Legal Spend Management

| Metric | Description |
|--------|------------|
| **Legal Bill Review** | Every defense counsel invoice reviewed against Litigation Management Guidelines (LMGs). Automated via tools like Tymetrix, Legal Tracker, CounselLink. |
| **Alternative Fee Arrangements (AFAs)** | Flat fees, capped fees, contingency-based fees replacing hourly billing. |
| **Panel Counsel** | Preferred attorney firms vetted and rated by carrier. Tiered: routine, complex, trial, appellate. |
| **Average Defense Cost** | Tracked by LOB, jurisdiction, claim complexity. Benchmark: $15K–$25K for standard auto BI; $50K–$100K+ for complex GL. |
| **Indemnity-to-Expense Ratio** | Target varies by LOB; healthy ratio for standard lines is 4:1 to 6:1. |

### 8.4 Medicare Compliance (MMSEA Section 111)

The Medicare, Medicaid, and SCHIP Extension Act of 2007 (Section 111) requires:
- **Mandatory reporting** of settlements, judgments, and awards involving Medicare beneficiaries to CMS.
- **Query** process to determine if claimant is a Medicare beneficiary before settlement.
- **Conditional Payment** recovery by Medicare for medical expenses it paid that should be paid by the liability carrier.
- **Medicare Set-Aside (MSA)** arrangements for Workers' Comp and some liability settlements to protect Medicare's future interests.
- **Responsible Reporting Entity (RRE)** registration and quarterly electronic reporting to CMS.

---

## 9. Subrogation & Recovery

### 9.1 Subrogation Defined

Subrogation is the carrier's right to recover claim payments from the party legally responsible for the loss. It is a significant profit lever — industry-wide, subrogation recoveries represent **5–15% of total paid losses**.

### 9.2 Subrogation Workflow

```
Claim Payment ──▶ Subro Identification ──▶ Demand to At-Fault Party/Carrier
      │                                            │
      ▼                                            ▼
Auto-Referral          ┌─────────────────── Response Received?
Rules Engine           │         │                  │
                       No        Partial            Full
                       │         │                  │
                       ▼         ▼                  ▼
                  Arbitration  Negotiate         Close Recovery
                  (AF / UMPIRE)  Settlement
```

### 9.3 Arbitration Forums

| Forum | Use Case |
|-------|----------|
| **Arbitration Forums, Inc. (AF)** | Inter-company arbitration for auto subrogation disputes. Binding on members. |
| **Special Arbitration** | Property subrogation disputes. |
| **UMPIRE** | Used for uninsured motorist property damage disputes. |

### 9.4 Key Recovery Types

- **Subrogation**: Recovery from at-fault third party or their insurer.
- **Salvage**: Sale of damaged property (e.g., totaled vehicles via Copart/IAA auctions).
- **Deductible Recovery**: Recovering insured's deductible on their behalf during subrogation.
- **Contribution**: Recovery from co-insurers or additional insureds on shared obligations.
- **Reinsurance Recovery**: Recovery from reinsurers under treaty or facultative agreements.

---

## 10. Settlement & Payment

### 10.1 Settlement Types

| Type | Description |
|------|------------|
| **Lump Sum** | Single payment resolving all damages. Most common for auto PD and simple BI. |
| **Structured Settlement** | Periodic payments (annuity) for large BI/WC claims. Tax advantages for claimant. Purchased from life insurers. |
| **Partial Payment / Advance** | Interim payment to claimant before final settlement (e.g., emergency living expenses). |
| **Workers' Comp Indemnity Payments** | Ongoing weekly/bi-weekly payments based on wage replacement formula. |
| **Medical-Only Payment** | Direct payment to healthcare providers. |
| **Compromise & Release (C&R)** | Lump-sum WC settlement closing out future medical and indemnity obligations. |
| **Stipulation with Request for Award** | WC settlement leaving future medical open. |

### 10.2 Payment Methods

| Method | Speed | Cost | Use Case |
|--------|-------|------|----------|
| **Check** | 5–10 days | $3–$8 per check | Traditional; declining |
| **ACH / EFT** | 1–3 days | $0.25–$1.00 | Growing standard for indemnity |
| **Virtual Card (vCard)** | Instant | Rebate-generating | Vendor payments (shops, contractors) |
| **Push-to-Debit** | Minutes | $1–$3 | Expedited claimant payments |
| **Wire Transfer** | Same day | $15–$30 | Large settlements |
| **Digital Wallet** | Instant | $1–$2 | Mobile-first claimant payments |

### 10.3 Payment Controls

- **Authority Matrix**: Payment limits by adjuster role and claim severity tier.
- **Duplicate Payment Detection**: System check for same payee + amount + date combinations.
- **OFAC Screening**: Every payee checked against Office of Foreign Assets Control sanctions list.
- **1099 Reporting**: IRS Form 1099-MISC issued for non-WC claim payments exceeding $600 to claimants.
- **Two-Party Checks**: Payments for auto PD include lienholder; property claims include mortgagee.

---

## 11. Fraud Detection (SIU)

### 11.1 Fraud Types

| Type | Description | Example |
|------|------------|---------|
| **Hard Fraud** | Intentional, planned scheme to defraud insurer. | Staged accident, arson-for-profit, phantom vehicle |
| **Soft Fraud** | Opportunistic exaggeration of legitimate claim. | Inflated damage estimate, pre-existing damage claimed as new |
| **Provider Fraud** | Healthcare provider or repair shop submits false/inflated bills. | Upcoding, phantom treatments, inflated labor hours |
| **Premium Fraud** | Misrepresentation on application to lower premium. | Garaging out-of-state, straw purchases |
| **Organized Fraud Rings** | Coordinated networks of claimants, attorneys, providers. | Medical mill referral networks, staged accident rings |

### 11.2 Fraud Detection Methods

| Method | Description |
|--------|------------|
| **Rules-Based Scoring** | Business rules flag claims matching known fraud patterns (e.g., new policy + large loss + financial distress). |
| **Predictive Modeling** | ML models trained on historical fraud outcomes; continuous learning. |
| **Social Network Analysis (SNA)** | Graph analytics identifying connections between claimants, providers, attorneys, and witnesses across multiple claims. |
| **Text Mining / NLP** | Analysis of adjuster notes, recorded statements, and correspondence for deception indicators. |
| **Image Analytics** | AI detection of photo manipulation, recycled photos, or inconsistent damage patterns. |
| **ISO ClaimSearch** | Industry-shared database of claims and claimant history; flags multiple filings and suspicious patterns. |
| **NICB (National Insurance Crime Bureau)** | Industry organization providing investigative support, analytics, and law enforcement liaison. |

### 11.3 SIU Metrics

| Metric | Benchmark |
|--------|-----------|
| **SIU Referral Rate** | 5–10% of all claims |
| **Confirmed Fraud Rate** | 1–3% of all claims |
| **Fraud Savings Ratio** | $3–$8 saved per $1 invested in SIU |
| **Average Time to Close SIU File** | 90–180 days |
| **Denial Rate on SIU-Investigated Claims** | 40–60% |

---

## 12. Catastrophe (CAT) Claims

### 12.1 CAT Event Classification

| Category | Insured Loss Threshold | Examples |
|----------|----------------------|----------|
| **PCS-Designated CAT** | ≥$25M insured losses, ≥significant # of policyholders | Named storms, tornadoes, wildfires, hail events |
| **Major CAT** | >$1B insured losses | Hurricane Ian ($60B+), Hurricane Katrina ($80B+), 2025 LA Wildfires |
| **Mega CAT** | >$10B insured losses | Once-in-a-generation events |
| **Non-Weather CAT** | Varies | Earthquakes, civil unrest, pandemics (BI disputes) |

### 12.2 CAT Operations Workflow

```
Event Forecast ──▶ CAT Team Activation ──▶ Policyholder Outreach ──▶ Triage Incoming FNOL
       │                   │                        │                         │
       ▼                   ▼                        ▼                         ▼
Pre-position         Deploy Field              Geo-fence                Auto-assign
Resources            CAT Adjusters             Affected Policies        by Severity
       │                   │                        │                         │
       ▼                   ▼                        ▼                         ▼
Vendor               Temporary Claims          Mass Communication      Virtual vs.
Activation           Offices / Mobile Units    (Email/SMS/Push)        Field Triage
```

### 12.3 CAT-Specific Challenges

- **Volume Surge**: 10x–100x normal intake volume within hours. Requires elastic capacity.
- **Independent Adjusters (IAs)**: Carriers contract IA firms (Crawford, Sedgwick, Engle Martin) to supplement staff. Managed via vendor platforms.
- **Managed Repair Programs**: Pre-approved contractor networks to expedite repairs and control costs.
- **Advance Payments**: Regulatory and competitive pressure to issue advance payments quickly.
- **Demand Surge**: Material and labor costs spike post-CAT; estimating tools must adjust.
- **Government Interaction**: FEMA coordination, National Flood Insurance Program (NFIP) administration, state emergency declarations affecting claims handling timelines.
- **Public Adjusters**: Policyholders in CAT zones frequently hire PAs who take 10–20% of settlement; carriers must negotiate with PAs.
- **Anti-Concurrent Causation**: Coverage disputes when multiple perils (wind vs. flood) cause damage simultaneously.

---

## 13. Data Standards & Industry Formats

### 13.1 ACORD (Association for Cooperative Operations Research and Development)

ACORD is the **de facto global standard** for insurance data exchange.

**Key ACORD Standards**

| Standard | Format | Use |
|----------|--------|-----|
| **ACORD Forms** | PDF/Paper | Standardized paper forms (ACORD 1 — Property Loss Notice, ACORD 2 — Auto Loss Notice, ACORD 19 — Commercial Property, etc.) |
| **ACORD AL3** | Flat file | Legacy data exchange for Personal Lines. Fixed-length records with defined field positions. |
| **ACORD XML** | XML | Structured electronic data exchange. Namespaces for Claims, Policy, Party, etc. |
| **ACORD JSON** | JSON | Modern API-based data exchange. RESTful architecture. |
| **ACORD Global Reinsurance Standard** | XML/CSV | Reinsurance bordereau and claims data exchange (GRLC, GRRC). |
| **ACORD ELANY** | XML | Excess Line filing for New York. |
| **ACORD eDocs** | XML | Document metadata standards for imaging/content management. |
| **ACORD Reference Tables** | Code lists | Standardized code values for LOBs, cause of loss, coverage types, etc. |

**ACORD XML Claims Message Structure**

```xml
<?xml version="1.0" encoding="UTF-8"?>
<ACORD xmlns="http://www.ACORD.org/standards/PC_Surety/ACORD1/xml/">
  <SignonRq>
    <ClientApp>
      <Org>CarrierXYZ</Org>
      <Name>ClaimsSystem</Name>
      <Version>4.0</Version>
    </ClientApp>
  </SignonRq>
  <ClaimsSvcRq>
    <ClaimsNotificationAddRq>
      <RqUID>550e8400-e29b-41d4-a716-446655440000</RqUID>
      <TransactionRequestDt>2026-04-16</TransactionRequestDt>
      <PolicyNumber>HO-2024-001234</PolicyNumber>
      <LOBCd>HOME</LOBCd>
      <ClaimsOccurrence>
        <LossDt>2026-04-14</LossDt>
        <LossTm>14:30:00</LossTm>
        <LossDesc>Wind damage to roof and siding from severe thunderstorm</LossDesc>
        <CatastropheCd>PCS-2026-1234</CatastropheCd>
        <Addr>
          <Addr1>123 Main Street</Addr1>
          <City>Springfield</City>
          <StateProvCd>IL</StateProvCd>
          <PostalCode>62701</PostalCode>
        </Addr>
        <CauseOfLossCd>WIND</CauseOfLossCd>
      </ClaimsOccurrence>
      <ClaimsParty>
        <ClaimsPartyInfo>
          <ClaimsPartyRoleCd>INSURED</ClaimsPartyRoleCd>
          <PersonName>
            <GivenName>John</GivenName>
            <Surname>Smith</Surname>
          </PersonName>
          <PhoneInfo>
            <PhoneNumber>217-555-0123</PhoneNumber>
          </PhoneInfo>
        </ClaimsPartyInfo>
      </ClaimsParty>
    </ClaimsNotificationAddRq>
  </ClaimsSvcRq>
</ACORD>
```

### 13.2 ISO / Verisk Standards

| Standard | Description |
|----------|------------|
| **ISO ClaimSearch** | Industry-shared all-claims database. Real-time matching for fraud detection, SIU referral, and subrogation identification. |
| **ISO Electronic Claim Filing (eCLAIMS)** | Electronic claim data exchange between carriers (especially for auto subrogation and arbitration). |
| **ISO Statistical Reporting** | Statutory statistical data filed with state regulators through ISO/AAIS. Unit and financial data for ratemaking. |
| **ISO Commercial Lines Codes** | Class codes, territory codes, cause-of-loss codes used across the industry. |
| **PCS (Property Claim Services)** | Catastrophe designation and tracking service. Each CAT event gets a PCS serial number. |

### 13.3 NCCI (National Council on Compensation Insurance)

NCCI sets standards for Workers' Compensation:

| Standard | Description |
|----------|------------|
| **WCIO (Workers Compensation Insurance Organizations)** | Data reporting standards for WC across all states. |
| **WCSTAT** | Statistical plan for reporting WC data to NCCI/state bureaus. |
| **Unit Statistical Plan** | Individual claim-level data reported for ratemaking. |
| **Financial Call** | Financial data reporting for WC insurers. |
| **NCCI Class Codes** | Industry classification codes (e.g., 8810 — Clerical, 5183 — Plumbing, 7380 — Chauffeurs). |
| **Experience Rating** | Individual employer experience modification factor based on claim history. Uses USP data. |

### 13.4 EDI Standards

| Standard | Use |
|----------|-----|
| **ANSI X12 837** | Healthcare claim submission (medical bills in WC). |
| **ANSI X12 835** | Healthcare payment/remittance advice. |
| **ANSI X12 834** | Benefit enrollment. |
| **HL7 / FHIR** | Healthcare data interoperability (emerging in insurance for medical record exchange). |
| **ICD-10-CM** | Medical diagnosis codes used in injury claims. |
| **CPT Codes** | Medical procedure codes used in bill review. |

### 13.5 Other Data Standards

| Standard | Description |
|----------|------------|
| **VIN (ISO 3779)** | 17-character Vehicle Identification Number standard. |
| **CIECA (Collision Industry Electronic Commerce Association)** | BMS (Business Message Suite) standard for electronic communication in auto collision repair ecosystem. |
| **EMS (Electronic Messaging Standard)** | Used by CCC, Mitchell, and Audatex for estimate data exchange. |
| **ORC (Open Repair Conformity)** | Emerging standard for repair procedure documentation and compliance. |
| **MISMO** | Mortgage industry data standard (relevant for property claims involving mortgagee interests). |

### 13.6 Data Formats in Claims Systems

| Format | Use Case |
|--------|----------|
| **JSON** | Modern API communication, mobile app data, microservices. |
| **XML** | ACORD message exchange, legacy integrations, statutory filing. |
| **CSV/TSV** | Bulk data extracts, reporting, reinsurance bordereaux. |
| **Fixed-Width (EBCDIC/ASCII)** | Legacy mainframe data exchange (AL3, WCSTAT). |
| **PDF** | Policy documents, correspondence, demand letters, settlement releases. |
| **TIFF/JPEG/PNG** | Scanned documents, damage photos, police reports. |
| **DICOM** | Medical imaging (rare but relevant in WC/BI). |
| **Parquet/ORC** | Columnar formats for analytics data lakes. |
| **Avro** | Event streaming (Kafka) serialization for real-time claims events. |
| **Protocol Buffers (Protobuf)** | High-performance microservice communication. |

---

## 14. Technical Architecture & Platforms

### 14.1 Core Claims Platforms

| Platform | Vendor | Architecture | Strengths |
|----------|--------|-------------|-----------|
| **Guidewire ClaimCenter** | Guidewire | Java-based, on-prem or Guidewire Cloud (AWS) | Market leader; deep configurability; strong ecosystem. Used by top-20 carriers. |
| **Duck Creek Claims** | Duck Creek (Vista Equity) | .NET, SaaS-first | Modern SaaS; low-code configuration; strong API layer. |
| **Majesco ClaimVantage** | Majesco | Cloud-native, microservices | Fast implementation; digital-first; mid-market focus. |
| **Snapsheet** | Snapsheet | Cloud-native, API-first | Virtual claims platform; strong photo AI and self-service. |
| **Origami Risk** | Origami (Fineos) | Cloud-native SaaS | RMIS + Claims for large self-insured organizations and TPAs. |
| **Insurity Claims** | Insurity | Cloud-based | Strong in specialty lines. |
| **Sapiens ClaimsPro** | Sapiens | Component-based | Flexible; good for complex LOBs. |
| **One Inc** | One Inc | Cloud | Claims payment platform; integrates with all major claims systems. |
| **Mitchell (Enlyte)** | Enlyte | Cloud/SaaS | Auto physical damage and WC medical ecosystems; now merged with Mitchell + Coventry + Genex. |
| **CCC Intelligent Solutions** | CCC | Cloud/SaaS | Auto claims ecosystem: estimating, total loss, parts, AI-powered workflow. |
| **Verisk Xactware** | Verisk | Cloud/Desktop | Property estimating (Xactimate), aerial imagery, pricing data. |
| **Custom / Legacy** | In-house | Mainframe (COBOL/DB2), Client-Server | Still used by many large carriers for legacy books. Modernization a major initiative. |

### 14.2 Guidewire ClaimCenter — Deep Dive

Guidewire ClaimCenter is the most widely used claims platform, so a Product Owner should understand its architecture:

**Core Data Model**

```
Claim
 ├── ClaimInfo (LossDate, ReportedDate, LOBCode, JurisdictionState)
 ├── Policy (retrieved from PolicyCenter or external PAS via plugin)
 ├── Exposures (one per coverage + claimant combination)
 │    ├── Coverage (CoverageType, DeductibleAmount, Limit)
 │    ├── Claimant (Person or Company entity)
 │    └── Transactions
 │         ├── ReserveSet (Reserves by CostType + CostCategory)
 │         ├── Payments (CheckSet → Check → Payment lines)
 │         └── Recoveries (RecoverySet → Recovery lines)
 ├── Activities (tasks/diary for adjusters)
 ├── Notes (adjuster notes, system notes)
 ├── Documents (linked to document management system)
 ├── ClaimContacts (all parties: insured, claimant, witness, attorney, vendor)
 ├── Incidents (VehicleIncident, PropertyIncident, InjuryIncident, etc.)
 ├── ServiceRequests (vendor assignments: appraisals, IMEs, repairs)
 └── SubrogationSummary (subro details, responsible parties)
```

**Key Technical Concepts**

| Concept | Description |
|---------|------------|
| **GOSU** | Guidewire's proprietary scripting language (similar to Java). Used for business rules, validations, and custom logic. Being replaced by Cloud API + JavaScript. |
| **PCF (Page Configuration Files)** | XML-based UI configuration files for screen layout and behavior. |
| **Plugins** | Integration points for external systems (messaging, geocoding, document management, payment). |
| **Workflows** | Configurable multi-step processes (e.g., approval workflows, assignment workflows). |
| **Business Rules** | Validation rules, pre-update rules, visibility rules. |
| **Batch Processes** | Scheduled jobs for escalation, bulk close, statute tracking, financials. |
| **Guidewire Cloud API** | RESTful API layer for headless/API-first integrations. JSON-based. |
| **Integration Gateway** | Cloud-based integration layer replacing traditional messaging plugins. |
| **Jutro Digital Platform** | Guidewire's React-based front-end framework for modern UI experiences. |

### 14.3 Reference Architecture — Modern Claims Platform

```
┌─────────────────────────────────────────────────────────────────────────┐
│                         PRESENTATION LAYER                             │
│  ┌────────────┐  ┌────────────┐  ┌────────────┐  ┌────────────────┐   │
│  │ Adjuster   │  │ Self-Svc   │  │ Agent      │  │ Mobile App     │   │
│  │ Desktop    │  │ Portal     │  │ Portal     │  │ (iOS/Android)  │   │
│  │ (React/    │  │ (React)    │  │ (React)    │  │ (React Native) │   │
│  │  Angular)  │  │            │  │            │  │                │   │
│  └─────┬──────┘  └─────┬──────┘  └─────┬──────┘  └───────┬────────┘   │
│        └────────────────┴──────────────┴──────────────────┘            │
│                              │  API Gateway (Kong / AWS API GW)       │
├──────────────────────────────┼──────────────────────────────────────────┤
│                         API / SERVICE LAYER                            │
│  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────────┐│
│  │ FNOL     │ │ Claims   │ │ Payment  │ │ Document │ │ Assignment   ││
│  │ Service  │ │ Mgmt     │ │ Service  │ │ Service  │ │ Service      ││
│  │          │ │ Service  │ │          │ │          │ │              ││
│  └──────────┘ └──────────┘ └──────────┘ └──────────┘ └──────────────┘│
│  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────────┐│
│  │ Reserve  │ │ Subro    │ │ SIU/Fraud│ │ Vendor   │ │ Notification ││
│  │ Service  │ │ Service  │ │ Service  │ │ Mgmt     │ │ Service      ││
│  │          │ │          │ │          │ │ Service  │ │              ││
│  └──────────┘ └──────────┘ └──────────┘ └──────────┘ └──────────────┘│
├──────────────────────────────────────────────────────────────────────────┤
│                         EVENT / MESSAGING LAYER                        │
│         ┌──────────────────────────────────────────────────┐           │
│         │   Apache Kafka / AWS EventBridge / Azure SB      │           │
│         │   Topics: claim.created, claim.updated,          │           │
│         │   payment.requested, reserve.changed,            │           │
│         │   fraud.score.computed, document.uploaded         │           │
│         └──────────────────────────────────────────────────┘           │
├──────────────────────────────────────────────────────────────────────────┤
│                         DATA LAYER                                     │
│  ┌────────────┐  ┌────────────┐  ┌────────────┐  ┌──────────────────┐ │
│  │ Claims DB  │  │ Document   │  │ Analytics  │  │ ML Model        │ │
│  │ (Postgres/ │  │ Store (S3/ │  │ (Snowflake/│  │ Registry        │ │
│  │  Oracle/   │  │  Azure     │  │  Databricks│  │ (MLflow/         │ │
│  │  SQL Svr)  │  │  Blob)     │  │  /Redshift)│  │  SageMaker)     │ │
│  └────────────┘  └────────────┘  └────────────┘  └──────────────────┘ │
├──────────────────────────────────────────────────────────────────────────┤
│                         INFRASTRUCTURE                                 │
│  ┌────────────┐  ┌────────────┐  ┌────────────┐  ┌──────────────────┐ │
│  │ Kubernetes │  │ CI/CD      │  │ Monitoring │  │ Security        │ │
│  │ (EKS/AKS/ │  │ (Jenkins/  │  │ (Datadog/  │  │ (IAM, Vault,   │ │
│  │  GKE)     │  │  GitLab)   │  │  Splunk)   │  │  WAF)           │ │
│  └────────────┘  └────────────┘  └────────────┘  └──────────────────┘ │
└──────────────────────────────────────────────────────────────────────────┘
```

### 14.4 Supporting Technology Components

| Component | Products / Technologies |
|-----------|----------------------|
| **Document Management** | Hyland OnBase, OpenText, Alfresco, AWS S3 + metadata DB |
| **Business Rules Engine** | Drools, ILOG (IBM ODM), Guidewire GOSU, Appian |
| **Workflow / BPM** | Camunda, Appian, Pega, Guidewire Workflows |
| **Correspondence / Templates** | Thunderhead (OpenText Exstream), Quadient, Docmosis |
| **OCR / Intelligent Document Processing** | ABBYY, Kofax, AWS Textract, Azure Document Intelligence, Google Document AI |
| **Communication (CPaaS)** | Twilio, Vonage, Bandwidth — SMS, voice, push notifications |
| **CRM** | Salesforce Financial Services Cloud, Microsoft Dynamics 365 |
| **Reporting / BI** | Tableau, Power BI, Looker, Qlik |
| **Data Integration / ETL** | Informatica, Talend, dbt, Apache Airflow, AWS Glue |
| **API Management** | Kong, Apigee, MuleSoft, AWS API Gateway |
| **Identity & Access** | Okta, Azure AD, Ping Identity |
| **Telephony / Contact Center** | Genesys, Five9, NICE inContact, AWS Connect |

---

## 15. Integrations & Ecosystem

### 15.1 Core Integration Map

```
                              ┌──────────────────┐
                              │   CLAIMS SYSTEM   │
                              │   (ClaimCenter)   │
                              └────────┬─────────┘
            ┌────────────────────────┬──┴───────────────────────────┐
            │                        │                               │
    ┌───────▼──────┐       ┌────────▼────────┐            ┌────────▼────────┐
    │  Policy Admin │       │  Billing System  │            │  Reinsurance    │
    │  System (PAS) │       │                  │            │  System         │
    │  - Coverage   │       │  - Payment status│            │  - Treaty cede  │
    │  - Limits     │       │  - Premium data  │            │  - Facultative  │
    │  - Deductible │       │  - Cancellation  │            │  - Bordereaux   │
    └──────────────┘       └─────────────────┘            └─────────────────┘
            │                        │                               │
    ┌───────▼──────┐       ┌────────▼────────┐            ┌────────▼────────┐
    │  ISO Claim   │       │  Payment/        │            │  Financial /    │
    │  Search      │       │  Disbursement    │            │  GL System      │
    │  - Fraud chk │       │  - Check print   │            │  - SAP, Oracle  │
    │  - Prior hx  │       │  - EFT/ACH       │            │  - Reserve      │
    │  - SIU refer │       │  - vCard         │            │    postings     │
    └──────────────┘       └─────────────────┘            └─────────────────┘
            │                        │                               │
    ┌───────▼──────┐       ┌────────▼────────┐            ┌────────▼────────┐
    │  Estimating  │       │  Vendor Mgmt    │            │  Regulatory     │
    │  Platforms   │       │                  │            │  Reporting      │
    │  - CCC       │       │  - IA firms     │            │  - NAIC         │
    │  - Mitchell  │       │  - Body shops   │            │  - State filings│
    │  - Xactimate │       │  - Contractors   │            │  - Sec 111 CMS  │
    │  - EagleView │       │  - Legal counsel │            │  - ISO Stat     │
    └──────────────┘       └─────────────────┘            └─────────────────┘
```

### 15.2 Key Integration Patterns

| Pattern | Use Case |
|---------|----------|
| **Request-Reply (Sync API)** | Coverage verification, address validation, VIN decode, OFAC check |
| **Event-Driven (Async)** | Claim created/updated notifications, fraud score computation, reserve change events |
| **Batch / File Transfer** | Statistical reporting (ISO, NCCI), reinsurance bordereaux, regulatory filings, bulk payment files |
| **Webhook / Callback** | Payment status updates, vendor assignment completion, estimate delivery |
| **Pub/Sub** | Real-time event streaming to analytics, dashboards, downstream consumers |
| **ETL / ELT** | Claims data warehouse loading, BI reporting, actuarial data mart population |

### 15.3 Third-Party Data Enrichment

| Data Source | Provider | Use in Claims |
|-------------|----------|--------------|
| **Weather Data** | DTN, Weather Source, IBM Weather | CAT validation, cause of loss verification |
| **Aerial Imagery** | EagleView, Nearmap, Google Earth | Roof condition assessment, pre-loss vs. post-loss comparison |
| **Telematics** | OEM data (Ford, GM), Cambridge Mobile Telematics, LexisNexis Telematics | Speed, braking, impact severity, location at time of loss |
| **Police Reports** | LexisNexis Coplogic, Carfax, state DOTs | Automated police report retrieval for auto claims |
| **Medical Bill Review** | Mitchell MCR, Coventry, CorVel, Rising Medical Solutions | Fee schedule compliance, utilization review, cost containment |
| **Prescription Drug Data** | PDMP (state databases), pharmacy benefit managers | WC drug utilization monitoring |
| **Property Data** | CoreLogic, ATTOM, Zillow | Property value, construction details, permit history, hazard scores |
| **Credit / Financial** | LexisNexis, TransUnion, Experian | Financial stress indicators for fraud scoring |
| **Motor Vehicle Records** | State DMVs via LexisNexis, Verisk | Driver history, license status, vehicle registration |
| **Geospatial / Mapping** | Google Maps, HERE, Esri | Loss location validation, proximity analysis, catastrophe mapping |

---

## 16. Regulatory & Compliance

### 16.1 State Insurance Regulation

Insurance is regulated **state by state** in the US (McCarran-Ferguson Act). Each state Department of Insurance (DOI) establishes:

- **Unfair Claims Practices Acts (UCPA)**: Based on NAIC model act; defines prohibited claims handling behaviors.
- **Prompt Payment Laws**: Deadlines for acknowledging claims (typically 15 days), making coverage decisions (typically 30 days), and issuing payments (varies 30–60 days).
- **Fair Claims Settlement Practices**: Requirements for investigation thoroughness, communication frequency, and settlement reasonableness.

### 16.2 Key Regulatory Requirements

| Requirement | Description |
|-------------|------------|
| **Timely Acknowledgement** | Claims must be acknowledged within 15 business days (most states). |
| **Timely Investigation** | Investigation must be completed promptly; status updates to insured every 30 days (some states require 45 days). |
| **Timely Payment** | Payment within 30 days of settlement agreement (most states). Some states impose penalties/interest for late payment. |
| **Written Denial** | Coverage denials must be in writing, citing specific policy language. |
| **Reservation of Rights (ROR)** | If coverage is uncertain, carrier must issue an ROR letter promptly, specifying the coverage issues. |
| **Market Conduct Exams** | DOI audits of claims files to ensure compliance with state regulations. Random sampling or complaint-triggered. |
| **Consumer Complaint Response** | DOI-forwarded complaints must be responded to within 15–30 days. |
| **Large Loss Reporting** | Claims exceeding thresholds must be reported to reinsurers and sometimes regulators. |
| **Anti-Fraud Reporting** | Many states require carriers to report suspected fraud to the state fraud bureau. |

### 16.3 Federal Regulations Affecting Claims

| Regulation | Impact |
|------------|--------|
| **MMSEA Section 111** | Medicare secondary payer reporting (see Section 8.4). |
| **OFAC** | Sanctions screening before every payment. |
| **FCRA** | Fair Credit Reporting Act — governs use of consumer credit data in claims/SIU. |
| **ADA** | Americans with Disabilities Act — accessibility requirements for digital claims channels. |
| **HIPAA** | Health data privacy for WC and medical claims handling. |
| **Dodd-Frank** | Federal Insurance Office (FIO) monitoring, systemic risk assessment. |
| **TRIA** | Terrorism Risk Insurance Act — federal backstop affecting terrorism-related claims. |
| **NFIP** | National Flood Insurance Program — WYO (Write Your Own) carriers handle flood claims per FEMA rules. |

### 16.4 Compliance Data & Diary Management

Claims systems must track regulatory deadlines:

```
Diary Type              Trigger                  Deadline
─────────────────────── ──────────────────────── ──────────────
Acknowledgement Letter  FNOL received            +15 calendar days
Coverage Decision       Investigation complete   +30 calendar days (varies)
Status Update to        No activity on file      Every 30 days
  Insured/Claimant
Payment After           Settlement agreed        +30 calendar days
  Settlement
ROR Letter              Coverage issue identified ASAP (typically +15 days)
SIU Referral            Fraud indicators flagged  +5 business days
Statute of Limitations  Claim opened              Track by jurisdiction
```

---

## 17. Key Metrics & KPIs

### 17.1 Operational Metrics

| Metric | Definition | Benchmark |
|--------|-----------|-----------|
| **Cycle Time** | Days from FNOL to claim closure. | Auto PD: 15–30 days; Auto BI: 120–365 days; WC: 30–90 days (medical-only) |
| **Touch Time** | Total adjuster time spent actively working a claim. | Target: minimize via automation |
| **FNOL-to-Contact Time** | Time from FNOL to first contact with insured/claimant. | Target: <4 hours (fast track), <24 hours (standard) |
| **Pending Claims Inventory** | Total open claims per adjuster. | Personal Auto: 125–175; Commercial: 80–120; WC: 100–150 |
| **Closure Rate** | Claims closed per adjuster per month. | Varies by LOB; typically 25–50/month |
| **Reopen Rate** | % of closed claims that are reopened. | Target: <5% |
| **STP Rate** | % of claims processed without human intervention. | Best-in-class: 30–40% (Auto), emerging for other LOBs |
| **Litigation Rate** | % of claims entering litigation. | Auto BI: 15–25%; GL: 30–50% |
| **Customer Satisfaction (CSAT/NPS)** | Post-claim survey scores. | NPS target: 50+; CSAT: 4.0+/5.0 |

### 17.2 Financial Metrics

| Metric | Definition | Benchmark |
|--------|-----------|-----------|
| **Loss Ratio** | Incurred losses / Earned premium. | Target: 55–65% (varies by LOB) |
| **LAE Ratio** | Loss Adjustment Expense / Earned premium. | Target: 8–12% |
| **Severity** | Average paid per closed claim. | Highly LOB-dependent |
| **Frequency** | Claims per 100 policies (or per $1M premium). | Trending metric for pricing feedback |
| **Pure Premium** | Frequency × Severity. | Core pricing input |
| **Reserve Accuracy** | Actual paid vs. initial/latest reserve. | Target: within ±5% at aggregate level |
| **Development Factor** | How much reserves change over time (by accident year and maturity). | Stable factors indicate good reserving |
| **Subrogation Recovery Rate** | Subrogation collected / Subrogation potential. | Target: 60–80% |
| **Salvage Recovery** | Salvage proceeds as % of total loss payments. | Auto: 15–25% |

### 17.3 Quality Metrics

| Metric | Definition | Measurement |
|--------|-----------|-------------|
| **File Quality Audit Score** | Score from structured claims file review. | Monthly random sample; score 1–5 on documentation, investigation, reserving, etc. |
| **Leakage** | Overpayment or underpayment relative to optimal. | Measured via closed-claim audits or re-inspection studies. Industry estimate: 5–15% of paid losses. |
| **Regulatory Complaints** | DOI complaints per 1,000 claims. | Target: <1 per 1,000 |
| **Denied Claim Appeals** | % of denied claims that are overturned on appeal. | Target: <10% |

---

## 18. AI, ML & Advanced Analytics in Claims

### 18.1 Use Cases by Claims Stage

| Stage | AI/ML Application | Maturity |
|-------|-------------------|----------|
| **FNOL** | NLP extraction from unstructured intake (emails, voicemails, chat); auto-population of claim fields | Production |
| **FNOL** | Photo AI for damage assessment (auto PD) — classify damage, estimate severity | Production |
| **Triage** | Predictive severity scoring to route claims to appropriate tier | Production |
| **Triage** | Attorney involvement prediction (flag high-risk claims early) | Production |
| **Fraud** | ML-based fraud scoring (supervised + unsupervised models) | Production |
| **Fraud** | Social network analysis (graph neural networks) for organized ring detection | Emerging |
| **Fraud** | Computer vision for photo manipulation detection and recycled photo identification | Production |
| **Investigation** | Satellite / aerial imagery change detection for property claims (pre-loss vs. post-loss) | Production |
| **Investigation** | Telematics-based liability and severity determination | Emerging |
| **Reserving** | ML-driven individual claim reserve prediction (replacing formula reserves) | Emerging |
| **Evaluation** | AI-assisted damage estimation from photos (auto PD — CCC, Tractable, Claim Genius) | Production |
| **Evaluation** | NLP-based medical record summarization and ICD-10 coding | Emerging |
| **Settlement** | Optimal settlement range recommendation (BI evaluation models) | Emerging |
| **Subrogation** | Auto-identification of subrogation potential at FNOL using loss details and police reports | Production |
| **Customer Experience** | Conversational AI / chatbots for claim status, document upload, scheduling | Production |
| **Quality** | Automated file review / leakage detection using ML on adjuster notes and financials | Emerging |

### 18.2 Computer Vision in Claims

**Auto Physical Damage**
1. Claimant uploads photos via mobile app.
2. AI model identifies damaged components (bumper, fender, hood, etc.).
3. Damage severity classified (minor, moderate, severe, total loss).
4. Preliminary estimate generated automatically.
5. Adjuster reviews AI output and finalizes.

**Property Claims**
1. Aerial/satellite imagery compared pre-loss vs. post-loss.
2. Damage area (sq ft) calculated for roof, siding, etc.
3. Used to validate or supplement field/virtual inspection.

**Vendors**: Tractable, CCC Intelligent Solutions, Claim Genius, Hi Marley (communication AI), Snapsheet.

### 18.3 Generative AI in Claims (2024–2026 Emerging)

| Application | Description |
|-------------|------------|
| **Adjuster Note Summarization** | LLM summarizes lengthy claim notes into actionable bullet points. |
| **Correspondence Drafting** | Auto-generate ROR letters, denial letters, settlement offers using policy language and claim facts. |
| **Coverage Analysis** | LLM reads policy wording and maps it to loss facts to identify applicable coverages and potential exclusions. |
| **Medical Record Summarization** | LLM extracts key diagnoses, treatments, and prognosis from medical records. |
| **Deposition Preparation** | Summarize discovery documents and generate suggested deposition questions. |
| **Knowledge Assistant** | Adjuster-facing chatbot answering policy, procedure, and regulatory questions in real-time. |
| **Code Generation** | Generating business rules, reports, and test cases for claims system configuration. |

### 18.4 Data Science Infrastructure

```
┌──────────────┐     ┌──────────────┐     ┌──────────────┐     ┌──────────────┐
│  Data Sources│────▶│  Feature     │────▶│  Model       │────▶│  Model       │
│  (Claims DB, │     │  Store       │     │  Training    │     │  Serving     │
│   3rd Party) │     │  (Feast/     │     │  (SageMaker/ │     │  (Real-time  │
│              │     │   Tecton)    │     │   Databricks)│     │   API)       │
└──────────────┘     └──────────────┘     └──────────────┘     └──────────────┘
                                                │                      │
                                                ▼                      ▼
                                          ┌──────────────┐     ┌──────────────┐
                                          │  Experiment  │     │  Monitoring  │
                                          │  Tracking    │     │  & Drift     │
                                          │  (MLflow)    │     │  Detection   │
                                          └──────────────┘     └──────────────┘
```

---

## 19. Product Owner Responsibilities in Claims

### 19.1 Core PO Accountabilities

| Accountability | Activities |
|---------------|------------|
| **Vision & Strategy** | Define the claims product vision aligned with business goals; create and communicate the product roadmap; identify opportunities for automation, digitization, and customer experience improvement. |
| **Backlog Management** | Own the product backlog; write user stories with acceptance criteria; prioritize based on business value, regulatory urgency, and technical feasibility; groom and refine stories with the development team. |
| **Stakeholder Management** | Liaise between Claims Operations, IT, Actuarial, Legal, Compliance, and UX; facilitate consensus on priorities; manage expectations on delivery timelines. |
| **Requirements Elicitation** | Conduct workshops, interviews, and process mapping sessions with adjusters, supervisors, and business SMEs; translate business needs into technical requirements. |
| **Sprint Ceremonies** | Participate in Sprint Planning, Daily Standups, Sprint Reviews, and Retrospectives; accept or reject completed stories against acceptance criteria. |
| **Data-Driven Decisions** | Define and monitor product KPIs; use data to validate hypotheses, measure feature adoption, and inform prioritization; champion A/B testing and experimentation. |
| **Regulatory Awareness** | Stay current on state regulatory changes, DOI bulletins, and compliance requirements that impact claims system functionality. |
| **Vendor Coordination** | Work with Guidewire, CCC, Mitchell, Verisk, and other vendors on releases, upgrades, and integration requirements. |

### 19.2 User Story Examples

**FNOL Self-Service**
```
As a policyholder,
I want to file a claim through the mobile app by uploading photos and
  answering guided questions,
So that I can initiate my claim immediately without waiting on hold.

Acceptance Criteria:
- [ ] Policyholder can authenticate via policy number + DOB or app login
- [ ] Guided flow captures: date/time of loss, loss description, cause of
      loss, photos (min 4), contact info, police report number (if applicable)
- [ ] Claim number generated and displayed immediately upon submission
- [ ] Confirmation email/SMS sent within 60 seconds
- [ ] FNOL data flows to ClaimCenter and creates a Claim entity
- [ ] Triage score computed and adjuster assigned within 5 minutes
```

**Reserve Automation**
```
As a claims supervisor,
I want the system to auto-set initial reserves based on predictive models
  at FNOL,
So that adjuster workload is reduced and initial reserves are more accurate.

Acceptance Criteria:
- [ ] ML model scores each new claim within 2 minutes of FNOL creation
- [ ] Model output includes predicted severity range (P10, P50, P90)
- [ ] P50 value used as initial case reserve
- [ ] Adjuster can override auto-reserve with documented reason
- [ ] Override rate tracked as a KPI (target: <25%)
- [ ] Model performance monitored monthly (MAE, bias, calibration)
```

**Fraud Scoring**
```
As an SIU analyst,
I want every new claim to be scored by the fraud detection model and
  high-risk claims flagged for my review,
So that I can prioritize my investigation workload effectively.

Acceptance Criteria:
- [ ] Fraud score (0–1000) computed within 5 minutes of FNOL
- [ ] Claims scoring ≥750 auto-flagged as "SIU Referral"
- [ ] Claims scoring 500–749 flagged as "SIU Watch"
- [ ] SIU dashboard shows queue sorted by score with key risk factors
- [ ] False positive rate monitored (target: <40% for ≥750 tier)
```

### 19.3 Product Roadmap Themes

| Theme | Horizon | Initiatives |
|-------|---------|------------|
| **Digital Self-Service** | Near-term | Mobile FNOL, claim status tracker, digital document upload, chatbot-assisted FNOL |
| **Straight-Through Processing** | Near-term | Auto-adjudication rules for simple claims, photo AI estimation, virtual inspections |
| **Intelligent Triage** | Near-term | ML-based severity prediction, litigation propensity scoring, assignment optimization |
| **Adjuster Enablement** | Mid-term | Unified desktop, integrated communication hub, AI-assisted notes, guided workflows |
| **Advanced Fraud** | Mid-term | Graph analytics, real-time scoring, photo forensics, social media monitoring |
| **Predictive Reserving** | Mid-term | ML reserve models replacing formula reserves, actuarial integration |
| **Customer Experience** | Mid-term | Omnichannel communication, proactive status updates, digital payments, NPS optimization |
| **Legacy Modernization** | Long-term | Mainframe migration to cloud-native platform, data migration, API-first architecture |
| **Parametric / Embedded** | Long-term | Auto-triggering claims from IoT/parametric data, embedded insurance partner integrations |
| **Generative AI** | Long-term | LLM-powered coverage analysis, correspondence generation, adjuster knowledge assistant |

### 19.4 Agile in Claims Technology

| Practice | Claims-Specific Consideration |
|----------|------------------------------|
| **Sprint Length** | 2 weeks is standard; 3 weeks for Guidewire projects due to configuration complexity. |
| **Definition of Done** | Must include: code review, unit tests, integration tests, UAT sign-off, compliance review (if regulatory), documentation update, performance testing (if applicable). |
| **PI Planning (SAFe)** | Many large carriers use SAFe; Claims is typically one Agile Release Train (ART) with 8–12 teams. |
| **Feature Toggles** | Critical for claims — rollout features by state, LOB, or adjuster group to manage regulatory risk. |
| **Technical Debt** | Guidewire upgrades create significant tech debt; PO must balance feature work with upgrade/modernization. |
| **Environments** | Typically: DEV → SIT → UAT → STAGING → PROD. Claims requires realistic test data (anonymized). |

---

## 20. Common Use Cases & User Stories

### 20.1 Auto First-Party Collision Claim

**Scenario**: Insured rear-ended at a traffic light.

| Step | Action | System |
|------|--------|--------|
| 1 | Insured files FNOL via mobile app; uploads 6 photos of vehicle damage. | Mobile App → ClaimCenter |
| 2 | AI photo analysis classifies damage as moderate rear-end; estimated repair $4,200. | Tractable / CCC AI |
| 3 | Triage engine scores claim as Fast Track (low severity, clear liability, no injury). | Rules Engine |
| 4 | System verifies policy is active, Collision coverage in force, $500 deductible. | PAS Integration |
| 5 | Auto-assignment to Fast Track adjuster pool. | Assignment Engine |
| 6 | Adjuster reviews AI estimate, confirms, creates Exposure with $4,200 reserve. | ClaimCenter |
| 7 | Insured selects DRP body shop; assignment sent electronically. | CCC / Mitchell |
| 8 | Shop completes repairs; submits final invoice ($4,350 with supplement). | EMS / CIECA |
| 9 | Adjuster approves supplement; payment of $3,850 ($4,350 - $500 deductible) issued. | Payment System |
| 10 | Subro team sends demand to at-fault carrier for $4,350 + rental. | Subro System |
| 11 | Recovery received; $500 deductible refunded to insured. | ClaimCenter |
| 12 | Claim closed. Total cycle time: 14 days. | ClaimCenter |

### 20.2 Homeowners Water Damage Claim

**Scenario**: Burst pipe causes water damage to kitchen and basement.

| Step | Action | System |
|------|--------|--------|
| 1 | Insured calls agent who reports FNOL; emergency mitigation company dispatched. | Call Center → ClaimCenter |
| 2 | Claim created; initial formula reserve $15,000 based on cause/LOB. | ClaimCenter |
| 3 | Virtual inspection scheduled; insured walks adjuster through damage via video. | ClaimXperience / Zoom |
| 4 | Adjuster identifies: drywall removal, cabinet replacement, flooring replacement, mold testing. | ClaimCenter |
| 5 | Xactimate estimate prepared: $22,500 RCV; $18,700 ACV (depreciation on flooring/cabinets). | Xactimate |
| 6 | Advance payment of $10,000 issued for emergency living expenses (ALE). | Payment System |
| 7 | ACV payment issued: $18,700 - $1,000 deductible = $17,700. | Payment System |
| 8 | Insured hires contractor; completes repairs; submits receipts for recoverable depreciation. | Document Upload |
| 9 | Depreciation holdback released: $3,800 upon proof of repair. | Payment System |
| 10 | Total paid: $31,500 (including ALE). Claim closed. | ClaimCenter |

### 20.3 Workers' Compensation Lost-Time Claim

**Scenario**: Warehouse worker injures back lifting heavy box.

| Step | Action | System |
|------|--------|--------|
| 1 | Employer reports injury via online portal within 24 hours. | Employer Portal → ClaimCenter |
| 2 | Claim created; jurisdiction = Ohio; class code = 7219 (Trucking). | ClaimCenter |
| 3 | Three-point contact completed: Employer, Employee, Treating Physician contacted within 24 hours. | ClaimCenter |
| 4 | Medical authorization issued for treating physician; initial appointment confirmed. | Utilization Review |
| 5 | Adjuster determines compensability; Temporary Total Disability (TTD) payments initiated. | ClaimCenter |
| 6 | TTD rate calculated: 2/3 of AWW ($950/week × 2/3 = $633.33/week), subject to state max ($1,115 in OH). | ClaimCenter |
| 7 | Nurse case manager assigned; creates return-to-work plan with employer. | Medical Case Mgmt |
| 8 | MRI reveals herniated disc; surgery recommended. Pre-authorization reviewed. | Utilization Review |
| 9 | Surgery performed; post-op recovery monitored; PT authorized (3x/week, 8 weeks). | Medical Bill Review |
| 10 | Employee reaches MMI (Maximum Medical Improvement) at 6 months. | IME / Treating MD |
| 11 | Permanent Partial Disability (PPD) rating assigned: 12% whole person. | IME |
| 12 | PPD settlement calculated per Ohio schedule; lump sum or installments negotiated. | ClaimCenter |
| 13 | Medicare Set-Aside (MSA) required (employee is 62, near Medicare eligible). | MSA Vendor |
| 14 | Settlement approved by Ohio BWC. | State Filing |
| 15 | Claim closed. Total incurred: $185,000 (medical $95K, indemnity $75K, expense $15K). | ClaimCenter |

### 20.4 Commercial General Liability — Slip and Fall

**Scenario**: Customer slips on wet floor in insured's retail store; suffers broken hip.

| Step | Action | System |
|------|--------|--------|
| 1 | Store manager reports incident to broker; broker submits ACORD GL Loss Notice. | Broker Portal → ClaimCenter |
| 2 | Claim triaged as Complex (broken hip = high severity; potential litigation). | Triage Engine |
| 3 | Assigned to senior GL examiner; initial reserve set at $150,000 (indemnity + expense). | ClaimCenter |
| 4 | Investigation: recorded statements, surveillance footage reviewed, incident report obtained. | ClaimCenter |
| 5 | Liability analysis: floor maintenance log reviewed; wet floor sign was posted but fell over. Comparative negligence potential: 80% insured / 20% claimant. | Adjuster Analysis |
| 6 | Claimant retains personal injury attorney; demand letter received for $500,000. | Correspondence |
| 7 | Reserve increased to $250,000 to reflect attorney involvement and demand. | ClaimCenter |
| 8 | Medical records obtained: hip surgery, 3-month rehab, $85,000 in medical specials. | Medical Review |
| 9 | Colossus / evaluation model produces settlement range: $120K–$180K. | Evaluation Tool |
| 10 | Negotiation with claimant attorney: initial offer $110K, counter $350K. | Adjuster |
| 11 | Mediation scheduled; settled at $165,000 (within evaluation range). | Mediation |
| 12 | Release signed; Medicare conditional payment check completed; MMSEA Section 111 reported. | Compliance |
| 13 | Payment issued via wire transfer to claimant attorney's trust account. | Payment System |
| 14 | Claim closed. Total incurred: $192,000 (indemnity $165K, expense $27K). | ClaimCenter |

### 20.5 Cyber Liability — Ransomware Attack

**Scenario**: Mid-size company's systems encrypted by ransomware; $2M ransom demanded.

| Step | Action | System |
|------|--------|--------|
| 1 | Insured calls 24/7 cyber hotline; FNOL created with high-priority flag. | Hotline → ClaimCenter |
| 2 | Breach coach (attorney) engaged immediately; attorney-client privilege established. | Panel Counsel |
| 3 | Forensics vendor deployed (CrowdStrike / Mandiant) to contain and investigate. | Vendor Management |
| 4 | Coverage analysis: Cyber policy covers ransomware, BI, forensics, notification costs. Sublimits reviewed. | Coverage Counsel |
| 5 | Ransom negotiation specialist engaged; negotiates ransom down to $800K. | Vendor |
| 6 | Carrier approves ransom payment (after OFAC screening of threat actor group). | Authority / Compliance |
| 7 | Systems restored from backups + decryption key; BI period: 12 days. | Forensics Report |
| 8 | Business Income loss calculated: $1.2M (revenue loss + extra expense). | Forensic Accountant |
| 9 | Notification required: 50,000 customer records potentially exposed. | Privacy Counsel |
| 10 | Credit monitoring services engaged for affected individuals ($45/person). | Notification Vendor |
| 11 | Regulatory inquiries from 3 state AGs; defense costs covered under policy. | Regulatory |
| 12 | Total claim: $4.5M (ransom $800K, BI $1.2M, forensics $500K, notification $2.25M, legal $350K, crisis PR $100K). | ClaimCenter |

---

## 21. Interview Preparation — Key Concepts & Questions

### 21.1 Behavioral Questions for Claims PO

| Question | What They're Assessing | How to Answer |
|----------|----------------------|---------------|
| "Tell me about a time you had to prioritize competing stakeholder demands." | Stakeholder management, decision-making framework | Use STAR method; reference specific claims stakeholders (ops, legal, compliance, IT); show data-driven prioritization. |
| "Describe a product decision that didn't go as planned." | Resilience, learning agility, intellectual honesty | Acknowledge the miss; describe what you learned; show how you pivoted (e.g., feature adoption was low → conducted user research → redesigned). |
| "How do you handle a regulatory change that disrupts your roadmap?" | Regulatory awareness, agility, risk management | Show you understand DOI requirements; explain how you'd reprioritize backlog; reference specific regulations (prompt payment, MMSEA). |
| "Walk me through how you'd approach modernizing a legacy claims system." | Strategic thinking, technical understanding, change management | Discuss phased approach: assess → define target state → strangler fig pattern → data migration → parallel run → cutover. |
| "How do you measure success for a claims product?" | Metrics orientation, business acumen | Reference specific KPIs: cycle time, STP rate, NPS, loss ratio impact, adjuster productivity, leakage reduction. |

### 21.2 Technical / Domain Questions

| Question | Key Points to Cover |
|----------|-------------------|
| "Explain the claims lifecycle." | See Section 2; emphasize the circular nature (FNOL → investigate → reserve → evaluate → settle → pay → recover → close). |
| "What is ACORD and why does it matter?" | Industry data standard; enables electronic data interchange between carriers, agents, vendors; XML/JSON schemas; form standardization. |
| "How does reserving work?" | Case reserves (adjuster estimate) vs. bulk/formula vs. IBNR (actuarial); staircase reserving problem; reserve adequacy; authority levels. |
| "What is subrogation?" | Right of recovery; inter-company arbitration (Arbitration Forums); deductible recovery; salvage; impact on loss ratio. |
| "Explain STP and how you'd increase it." | Straight-Through Processing; rules-based auto-adjudication; AI estimation; criteria: coverage confirmed, no fraud flags, below threshold; measure: STP rate by LOB. |
| "What is the difference between ACV and RCV?" | ACV = Replacement Cost - Depreciation; RCV = full cost to replace/repair without depreciation deduction; RCV policies pay ACV upfront, then release depreciation holdback upon proof of repair. |
| "How does Medicare Section 111 affect claims?" | Must query for Medicare eligibility before settlement; report settlements to CMS; resolve conditional payments; consider MSAs for WC and certain liability settlements. |
| "What are the key differences between Claims-Made and Occurrence policies?" | Occurrence: coverage triggered by when loss occurs. Claims-Made: coverage triggered by when claim is reported. Tail coverage, retroactive dates, prior acts. |
| "How would you use AI in claims?" | Photo AI for damage estimation, NLP for FNOL intake, ML for fraud scoring, predictive models for triage/severity/reserves, GenAI for correspondence/coverage analysis. |
| "Describe the Guidewire ClaimCenter data model." | Claim → Exposures → Transactions (Reserves, Payments, Recoveries); Claim Contacts, Incidents, Activities, Notes, Documents; Policy integration. |

### 21.3 Product Strategy Questions

| Question | Framework for Answering |
|----------|------------------------|
| "If you had to reduce claims cycle time by 30%, what would you do?" | Analyze where time is spent (Pareto of delays); target highest-impact areas: (1) auto-assignment optimization, (2) digital FNOL to reduce data entry, (3) STP for eligible claims, (4) vendor turnaround SLAs, (5) real-time payment. |
| "How would you build a business case for a claims AI initiative?" | Quantify: current adjuster cost per claim × volume; AI can handle X% → FTE savings; reduced leakage (5–15% of paid losses); faster cycle time → better customer retention → premium retention value; implementation cost vs. 3-year ROI. |
| "What's your approach to managing a Guidewire upgrade?" | Understand what's changing (release notes); impact analysis on customizations; regression test plan; involve operations early for UAT; phased rollout; rollback plan; communicate to adjusters and train. |
| "How do you balance innovation with 'keeping the lights on'?" | Capacity allocation: 60% feature work, 20% tech debt/maintenance, 20% innovation. Protect innovation capacity. Use OKRs to tie innovation to business outcomes. |
| "Design a claims dashboard for a VP of Claims." | Key sections: (1) Open inventory trends, (2) Cycle time by LOB/segment, (3) Reserve adequacy, (4) Closure rate, (5) NPS/CSAT trends, (6) STP rate, (7) Litigation rate, (8) Large loss watch list, (9) CAT event tracker. Drill-down capability by geography, LOB, adjuster team. |

### 21.4 Scenario-Based Questions

**Scenario 1: CAT Event Response**

> "A Category 4 hurricane is forecast to make landfall in Florida in 48 hours. You're the Claims PO. What do you do?"

**Answer Framework:**
1. **Pre-landfall (T-48 to T-0):** Activate CAT playbook; ensure system capacity scaled (cloud auto-scaling); pre-load CAT code in claims system; draft policyholder outreach communications; confirm IA firm contracts activated; ensure Xactimate pricing databases updated for Florida; coordinate with vendor management on contractor availability.
2. **Post-landfall (T+0 to T+7):** Monitor FNOL volume hourly; ensure IVR messages updated; deploy chatbot FNOL for simple claims; activate self-service FNOL prominently on website/app; coordinate with CAT team on field deployment; set up geo-fenced assignment rules; issue advance payments per company/regulatory guidelines.
3. **Sustained Response (T+7 to T+90):** Monitor adjuster workload; backlog management dashboard; coordinate supplemental estimate handling; manage public adjuster interactions; track regulatory deadlines (Florida has specific CAT claims handling timeframes); report on CAT claim metrics daily to executives.
4. **Closeout (T+90+):** Monitor closure rate; identify and escalate stalled claims; initiate demand surge analysis; capture lessons learned; contribute to pricing feedback loop.

**Scenario 2: Fraud Ring Detection**

> "Your SIU team suspects an organized fraud ring involving a medical clinic, an attorney, and multiple claimants in Auto BI. How would you leverage technology?"

**Answer Framework:**
1. Social Network Analysis: Graph database (Neo4j) mapping relationships between claimants, clinic, attorney, and witnesses across claims.
2. Pattern Detection: Identify common elements — same clinic, same attorney, similar injury patterns, geographic clustering, timing patterns.
3. Predictive Model Enhancement: Retrain fraud model with ring-specific features.
4. ISO ClaimSearch: Cross-reference all linked parties across industry claims.
5. NICB Referral: Coordinate with National Insurance Crime Bureau.
6. Outcome Tracking: Measure savings from ring disruption; feed outcomes back to model.

---

## 22. Glossary

| Term | Definition |
|------|-----------|
| **ACV** | Actual Cash Value — replacement cost minus depreciation |
| **ACORD** | Association for Cooperative Operations Research and Development — insurance data standards body |
| **ALE** | Additional Living Expenses — coverage for temporary housing/food when home is uninhabitable |
| **ALAE** | Allocated Loss Adjustment Expense — costs assignable to a specific claim (defense counsel, experts) |
| **AWW** | Average Weekly Wage — basis for workers' compensation indemnity calculations |
| **BI** | Bodily Injury — physical injury to a person |
| **BMS** | Business Message Suite — CIECA standard for auto repair ecosystem messaging |
| **CAT** | Catastrophe — large-scale loss event affecting many policyholders |
| **CIECA** | Collision Industry Electronic Commerce Association |
| **CMS** | Centers for Medicare & Medicaid Services |
| **COPE** | Construction, Occupancy, Protection, Exposure — property risk assessment factors |
| **DRP** | Direct Repair Program — network of preferred auto body shops |
| **EUO** | Examination Under Oath — formal sworn examination of insured |
| **FNOL** | First Notice of Loss — initial report of a claim |
| **IBNR** | Incurred But Not Reported — actuarial reserve for unreported claims |
| **IME** | Independent Medical Examination |
| **LAE** | Loss Adjustment Expense — cost of adjusting claims |
| **LOB** | Line of Business |
| **MCS-90** | Federal motor carrier financial responsibility endorsement |
| **MMI** | Maximum Medical Improvement — point at which further recovery is not expected |
| **MMSEA** | Medicare, Medicaid, and SCHIP Extension Act |
| **MSA** | Medicare Set-Aside — funds set aside to protect Medicare's future interests |
| **NAIC** | National Association of Insurance Commissioners |
| **NCCI** | National Council on Compensation Insurance |
| **NICB** | National Insurance Crime Bureau |
| **NPS** | Net Promoter Score — customer loyalty metric |
| **OFAC** | Office of Foreign Assets Control — US Treasury sanctions list |
| **PAS** | Policy Administration System |
| **PCS** | Property Claim Services — Verisk's CAT tracking unit |
| **PD** | Property Damage |
| **PIP** | Personal Injury Protection — no-fault auto coverage |
| **PPD** | Permanent Partial Disability |
| **PTD** | Permanent Total Disability |
| **RCV** | Replacement Cost Value — full cost to replace without depreciation |
| **ROR** | Reservation of Rights — letter preserving carrier's right to deny coverage |
| **RRE** | Responsible Reporting Entity — entity required to report to CMS under Section 111 |
| **SIU** | Special Investigations Unit — fraud investigation team |
| **STP** | Straight-Through Processing — fully automated claim handling |
| **TPA** | Third-Party Administrator — outsourced claims handling organization |
| **TTD** | Temporary Total Disability |
| **TPD** | Temporary Partial Disability |
| **UCPA** | Unfair Claims Practices Act |
| **ULAE** | Unallocated Loss Adjustment Expense — overhead costs not tied to specific claims |
| **UM/UIM** | Uninsured / Underinsured Motorist coverage |
| **USP** | Unit Statistical Plan — claim-level data reported for ratemaking |
| **VIN** | Vehicle Identification Number |
| **WC** | Workers' Compensation |
| **WCIO** | Workers Compensation Insurance Organizations |
| **WYO** | Write Your Own — private insurers writing federal flood insurance |

---

## Appendix A: Recommended Reading & Resources

| Resource | Type | Description |
|----------|------|------------|
| **ACORD Standards** (acord.org) | Standard | Official data standard documentation |
| **Guidewire Education** (education.guidewire.com) | Training | ClaimCenter configuration and development courses |
| **CPCU (Chartered Property Casualty Underwriter)** | Designation | THE premier P&C insurance designation; deep claims content in CPCU 530 |
| **AIC (Associate in Claims)** | Designation | The Institutes' claims-specific designation |
| **Insurance Journal / Insurance Business America** | Publication | Industry news and analysis |
| **J.D. Power Claims Satisfaction Study** | Research | Annual benchmarking study on claims customer experience |
| **McKinsey Insurance Practice** | Research | Thought leadership on claims transformation and AI |
| **Celent / Novarica** | Analyst | Technology advisory firms specializing in insurance IT |
| **NAIC Model Laws** | Regulatory | Model acts and regulations adopted by states |
| **Arbitration Forums** (arbfile.org) | Industry | Inter-company dispute resolution |

## Appendix B: Common Claims System Configuration Items

A Product Owner should be familiar with these configurable elements in a modern claims system:

| Configuration Area | Examples |
|-------------------|----------|
| **LOB / Policy Type Mapping** | Map policy types to claim types and available coverages |
| **Cause of Loss Codes** | Define available cause-of-loss values by LOB |
| **Coverage Types** | Configure which coverages create which exposure types |
| **Reserve Types** | Define cost types (Indemnity, Expense) and cost categories (Body Injury, Property Damage, Medical, etc.) |
| **Authority Limits** | Set payment and reserve authority by role, LOB, and claim segment |
| **Assignment Rules** | Configure auto-assignment based on LOB, geography, severity, adjuster capacity |
| **Segmentation Rules** | Define triage criteria for Fast Track, Standard, Complex, Severe |
| **Validation Rules** | Enforce business rules (e.g., reserve required before payment, coverage verification before exposure creation) |
| **Activity Patterns** | Define automated task creation (diary entries) at claim creation, exposure creation, status changes |
| **Financials Rollup** | Configure how exposure-level financials aggregate to claim-level |
| **Status Codes** | Define claim and exposure lifecycle statuses (Open, ReOpen, Closed) |
| **Document Templates** | Configure letter templates for correspondence (acknowledgement, ROR, denial, settlement) |
| **Batch Processes** | Schedule automated processes (escalation, statute tracking, reserve review reminders) |
| **User Roles & Permissions** | Define what each role can see and do in the system |
| **Integration Endpoints** | Configure connections to PAS, payment systems, vendor platforms, analytics |

---

*This guide was prepared as a comprehensive reference for P&C Claims technology professionals, with particular focus on the Product Owner role. It reflects industry practices, standard terminology, and current technology trends as of 2026.*
