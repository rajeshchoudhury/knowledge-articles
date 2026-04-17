# Annuity Illustrations and Projections

## A Comprehensive Technical Reference for Solution Architects

---

## Table of Contents

1. [What Are Annuity Illustrations](#1-what-are-annuity-illustrations)
2. [Regulatory Framework for Illustrations](#2-regulatory-framework-for-illustrations)
3. [AG49 Deep Dive](#3-ag49-deep-dive)
4. [Fixed Annuity Illustrations](#4-fixed-annuity-illustrations)
5. [Variable Annuity Illustrations](#5-variable-annuity-illustrations)
6. [FIA Illustrations](#6-fia-illustrations)
7. [Illustration Engine Architecture](#7-illustration-engine-architecture)
8. [Illustration Data Requirements](#8-illustration-data-requirements)
9. [Illustration Generation Workflow](#9-illustration-generation-workflow)
10. [In-Force Illustrations](#10-in-force-illustrations)
11. [Illustration Technology Stack](#11-illustration-technology-stack)
12. [Illustration Compliance](#12-illustration-compliance)
13. [Advanced Illustration Features](#13-advanced-illustration-features)

---

## 1. What Are Annuity Illustrations

### 1.1 Definition and Purpose

An annuity illustration is a personalized, numeric document that projects the future values of an annuity contract under specified assumptions. It serves as the primary decision-making tool for consumers evaluating annuity products and is simultaneously the most heavily regulated document in the annuity sales process.

From a systems perspective, an annuity illustration is the output of a multi-year financial projection engine that takes as inputs: client demographic data, premium amounts, product specifications, crediting strategy parameters, rider configurations, and economic assumptions — then produces year-by-year tabular projections of account values, surrender values, death benefits, and income streams under both guaranteed and non-guaranteed scenarios.

**Core purposes of annuity illustrations:**

- **Consumer disclosure**: Provide the prospective buyer with a clear, standardized picture of how the product may perform over time, including guaranteed minimums and projected values under current or hypothetical assumptions.
- **Regulatory compliance**: Satisfy mandated disclosure requirements at both the state and federal level before contract issuance.
- **Sales facilitation**: Enable agents and advisors to demonstrate product features, compare options, and support suitability determinations.
- **Suitability documentation**: Serve as evidence that the recommended product meets the client's stated financial objectives.
- **Record-keeping**: Create an auditable trail of what was presented to the consumer at the point of sale.
- **Product comparison**: Allow side-by-side evaluation of competing products or strategies within a single product.

### 1.2 Illustrations in the Sales Lifecycle

The illustration sits at the center of the annuity sales process and touches nearly every phase:

```
┌─────────────┐    ┌──────────────┐    ┌──────────────┐    ┌──────────────┐
│   Needs      │    │  Product     │    │ Illustration │    │  Application │
│   Analysis   │───▶│  Selection   │───▶│  Generation  │───▶│  Submission  │
└─────────────┘    └──────────────┘    └──────────────┘    └──────────────┘
                                              │
                                              ▼
                                       ┌──────────────┐
                                       │  Compliance   │
                                       │  Review       │
                                       └──────────────┘
                                              │
                                              ▼
                                       ┌──────────────┐
                                       │  Client       │
                                       │  Presentation │
                                       └──────────────┘
                                              │
                                              ▼
                                       ┌──────────────┐
                                       │  Signature &  │
                                       │  Storage      │
                                       └──────────────┘
```

**Pre-sale phase**: Agent runs multiple illustrations with different parameters (premium amounts, strategies, riders) to find the optimal product fit. These are exploratory and may never be presented to the client.

**Presentation phase**: A finalized illustration is generated and presented to the client, typically in PDF form. The client reviews the projections, asks questions, and the agent explains key elements.

**Application phase**: The specific illustration used in the sale is attached to the application. Many carriers require the illustration number to be recorded on the application form itself.

**Post-issue phase**: In-force illustrations are generated periodically (typically annually) or on request, showing how the contract is actually performing compared to original projections.

### 1.3 Types of Illustrations

#### 1.3.1 Pre-Sale Illustrations

Pre-sale illustrations are generated before a contract is purchased. They are the primary sales tool and are subject to the strictest regulatory requirements. Key characteristics:

- Must include both guaranteed and non-guaranteed (current) scenarios
- Must use rates and assumptions compliant with applicable regulations (AG49 for FIAs, NAIC Model #245 for fixed, SEC rules for VAs)
- Must include all mandatory disclosures and disclaimer language
- Must be signed by both the agent and the client if the sale proceeds
- Are typically generated through carrier-provided or third-party illustration software

#### 1.3.2 In-Force Illustrations

In-force illustrations are generated for existing contracts. They show projected future values based on current contract state (actual account value, current crediting rates, current rider values). Key differences from pre-sale:

- Start from actual current contract values rather than initial premium
- May show historical performance alongside future projections
- Used for annual policy reviews, 1035 exchange analysis, and replacement evaluations
- May be required annually by some state regulations
- Must reconcile with administrative system values

#### 1.3.3 Hypothetical Illustrations

Hypothetical illustrations show "what if" scenarios that deviate from standard illustration assumptions. Examples include:

- Illustrating the impact of additional premium payments
- Showing performance under different crediting strategies
- Projecting values under different withdrawal patterns
- Demonstrating the effect of a market downturn on VA guarantees

These must be clearly labeled as hypothetical and are subject to compliance review.

### 1.4 Illustration vs. Projection vs. Proposal

These terms are frequently confused but have distinct technical meanings in the annuity domain:

| Concept | Definition | Regulatory Status | Typical Content |
|---------|-----------|-------------------|-----------------|
| **Illustration** | A formal, regulated document projecting contract values under specified assumptions | Heavily regulated; must comply with NAIC Model #245, AG49, or SEC rules | Year-by-year value projections with guaranteed and non-guaranteed columns |
| **Projection** | A mathematical forecast of future values; the calculation engine output | The calculation underlying an illustration; not independently regulated | Raw numeric output from projection algorithms |
| **Proposal** | A sales presentation document that may contain illustration data plus additional marketing and educational content | Subject to advertising regulations; may not contain any values not in a compliant illustration | Illustration tables plus product summaries, feature explanations, comparison charts |

**For system architects**, the critical distinction is: the illustration engine produces projections; those projections are formatted into illustrations that comply with regulation; illustrations may be wrapped in proposals that add context. Each layer has different data, formatting, and compliance requirements.

### 1.5 Key Terminology

| Term | Definition |
|------|-----------|
| **Account Value (AV)** | The total value accumulated in the contract before surrender charges |
| **Surrender Value (SV)** | Account value minus applicable surrender charges; the amount available upon full surrender |
| **Cash Surrender Value (CSV)** | Synonym for surrender value; used interchangeably |
| **Death Benefit (DB)** | The amount payable to beneficiaries upon the annuitant's death |
| **Guaranteed Values** | Values calculated using the minimum guaranteed crediting rate and maximum charges |
| **Non-Guaranteed (Current) Values** | Values calculated using current (non-guaranteed) crediting rates and current charges |
| **Illustrated Rate** | The crediting rate used in the non-guaranteed column of an illustration |
| **Earned Rate** | The internal rate of return achieved by the contract over a specified period |
| **Ledger** | The year-by-year tabular output of an illustration |
| **Basis** | The total premiums paid into the contract (cost basis for tax purposes) |

---

## 2. Regulatory Framework for Illustrations

### 2.1 Overview of the Regulatory Landscape

Annuity illustrations exist within a multi-layered regulatory framework that varies by product type, distribution channel, and jurisdiction. The regulatory environment is one of the most complex areas in insurance technology and directly impacts illustration engine design.

```
┌─────────────────────────────────────────────────────────────────┐
│                    FEDERAL REGULATION                            │
│  ┌─────────────────────┐  ┌──────────────────────────────────┐  │
│  │  SEC (Variable       │  │  DOL (ERISA Plans,               │  │
│  │  Annuities)          │  │  Fiduciary Rule)                 │  │
│  └─────────────────────┘  └──────────────────────────────────┘  │
├─────────────────────────────────────────────────────────────────┤
│                    NAIC MODEL REGULATIONS                        │
│  ┌──────────────┐  ┌──────────────┐  ┌───────────────────────┐  │
│  │  Model #245  │  │  AG49/A/B    │  │  Suitability Model    │  │
│  │  (Disclosure)│  │  (FIA Illus) │  │  (Best Interest)      │  │
│  └──────────────┘  └──────────────┘  └───────────────────────┘  │
├─────────────────────────────────────────────────────────────────┤
│                    STATE-LEVEL REGULATION                        │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │  50 states + DC + territories, each with adoption         │   │
│  │  variations of NAIC models, plus state-specific rules     │   │
│  └──────────────────────────────────────────────────────────┘   │
├─────────────────────────────────────────────────────────────────┤
│                    CARRIER-LEVEL REQUIREMENTS                    │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │  Internal compliance standards that may exceed              │   │
│  │  regulatory minimums                                        │   │
│  └──────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────┘
```

### 2.2 NAIC Annuity Disclosure Model Regulation (#245)

The NAIC Annuity Disclosure Model Regulation (Model #245) is the foundational regulatory framework for annuity illustrations in the United States. Originally adopted in 1996 and amended multiple times, it establishes minimum disclosure standards that states adopt (often with modifications).

#### 2.2.1 Scope and Applicability

Model #245 applies to all individual deferred annuity contracts, both qualified and non-qualified. It generally does NOT apply to:

- Immediate annuities (SPIAs) — though some states extend requirements
- Group annuity contracts
- Variable annuities registered under the Securities Act of 1933 (these fall under SEC jurisdiction)
- Structured settlements

#### 2.2.2 Key Requirements

**Disclosure document at or before the point of sale:**

The regulation mandates that a written disclosure document be provided to the prospective buyer at or before the time of application. This document must include:

1. **Generic name of the contract** (e.g., "Flexible Premium Deferred Annuity")
2. **Company name and administrative office address**
3. **Description of the contract and its features**, including:
   - Guaranteed and non-guaranteed elements
   - Surrender charge schedule
   - Free withdrawal provisions
   - Death benefit provisions
   - Annuitization options
4. **Tax implications** and potential penalties for early withdrawal
5. **Statement of annual fees and charges** in dollar or percentage terms
6. **Buyer's Guide** — a standardized educational document

**Illustration-specific requirements under Model #245:**

When an illustration is used in the sale:

- It must show values on both a **guaranteed basis** and a **current (non-guaranteed) basis**
- The guaranteed basis must use the minimum guaranteed interest rate and maximum contractual charges
- The non-guaranteed basis must use current rates and charges, which **cannot exceed** the rates currently being credited
- Illustrations must show year-by-year values for at least 10 years, and at minimum through the end of the surrender charge period
- Values must be shown for: **Account Value, Surrender Value, and Death Benefit**
- The illustration must include the **annual premium or single premium** amount
- A **narrative summary** must explain the guaranteed and non-guaranteed elements

#### 2.2.3 State Adoption Variations

No state has adopted Model #245 exactly as written. Common variations include:

| State | Notable Variation |
|-------|-------------------|
| **New York** | Reg 47 (11 NYCRR 53) — more stringent disclosure requirements; requires specific format and content; mandates delivery receipt |
| **California** | Requires additional suitability disclosures tied to illustration; mandates specific senior-focused disclosures for age 65+ |
| **Texas** | Requires illustrations to be filed with the Department of Insurance; imposes additional formatting requirements |
| **Florida** | Mandates illustration delivery at least 5 days before the free-look period expires; requires additional replacement disclosures |
| **Connecticut** | Requires enhanced fee disclosure in illustrations; mandates comparison illustrations for replacements |

**Architectural implication**: Illustration systems must support state-specific rendering templates, disclosure language, and formatting rules. A single illustration engine must produce state-compliant output for all 50+ jurisdictions.

### 2.3 SEC Requirements for Variable Annuity Illustrations

Variable annuities are securities regulated by the SEC under the Securities Act of 1933 and the Investment Company Act of 1940. This creates a parallel and sometimes conflicting regulatory framework.

#### 2.3.1 Prospectus as Primary Disclosure

For variable annuities, the prospectus is the legally mandated disclosure document. However, illustrations supplement the prospectus by providing personalized projections.

#### 2.3.2 SEC Hypothetical Performance Requirements

The SEC does not permit illustrations of variable annuities to show projected performance based on actual historical sub-account returns. Instead:

- Illustrations must use **hypothetical gross rates of return** (e.g., 0%, 6%, 10%)
- The 0% scenario is mandatory to show the impact of fees in a flat market
- Returns must be applied **uniformly** across all projection years (no sequence-of-returns scenarios in standard illustrations)
- All fees and charges must be deducted from the gross return to show the net impact
- The illustration must prominently disclose that returns are hypothetical and not predictive

#### 2.3.3 FINRA Rules

FINRA (Financial Industry Regulatory Authority) overlays additional requirements for broker-dealer distributed variable annuities:

- **FINRA Rule 2210** (Communications with the Public): Illustrations are considered "correspondence" or "retail communications" depending on distribution method
- **FINRA Rule 2330** (Variable Annuity Transactions): Requires suitability review before illustration can be used
- Prohibits projections that are "misleading" even if mathematically accurate
- Requires balanced presentation of risks and potential returns

### 2.4 Illustration Certification Requirements

Most states require that annuity illustrations be "certified" — meaning that a qualified actuary or authorized officer of the insurance company has certified that the illustration:

1. Is based on the company's current portfolio crediting methodology
2. Uses rates that do not exceed the maximum permissible illustrated rates
3. Accurately reflects all contractual charges and fees
4. Has been generated by approved illustration software
5. Complies with all applicable state and federal regulations

The certification is typically embedded in the illustration as a footer or separate page. From a systems perspective, the illustration engine must:

- Include certification language as a configurable element
- Track the actuary/officer who certified each product's illustration assumptions
- Version-control the certification — when rates change, recertification is required
- Prevent generation of illustrations using uncertified assumptions

### 2.5 NAIC Suitability in Annuity Transactions Model Regulation

While not directly an illustration regulation, the NAIC Suitability Model (updated to the "Best Interest" model in 2020) significantly impacts illustrations because:

- The illustration must support the suitability determination
- Agents must document why the illustrated product is suitable for the client
- The illustration serves as evidence in suitability examinations
- Comparison illustrations are increasingly expected as part of best-interest documentation

---

## 3. AG49 Deep Dive

### 3.1 Background and Purpose

Actuarial Guideline 49 (AG49), formally titled "The Application of the Life Illustrations Model Regulation to Policies with Index-Based Interest," is the single most impactful regulation on Fixed Indexed Annuity (FIA) illustrations. It was adopted by the NAIC in 2015 and has since undergone two major revisions (AG49-A in 2020 and AG49-B in 2023).

Before AG49, FIA illustrations were inconsistent across carriers. Some used cherry-picked historical periods to show maximum returns, while others used conservative assumptions. The resulting disparity made product comparison nearly impossible and led to consumer confusion and potential mis-selling.

AG49 standardized the methodology for calculating the maximum rate that can be illustrated for index-linked crediting strategies.

### 3.2 AG49 Original (2015) — Core Requirements

#### 3.2.1 The Fundamental Limitation

AG49 established that the maximum illustrated crediting rate for any index account must be calculated using a disciplined, formulaic methodology tied to historical index performance and the crediting mechanism of the product.

**The two key constraints:**

1. **The Illustrated Rate cannot exceed 145% of the annual net investment earnings rate** of the statutory general account assets backing the FIA
2. **The Illustrated Rate is capped by the geometric mean of the historical lookback** applied to the specific crediting strategy

#### 3.2.2 Calculation Methodology — Lookback Period

The lookback calculation works as follows:

**Step 1: Determine the lookback period**
- Use a 25-year lookback of the applicable index (e.g., S&P 500)
- The 25-year period ends on December 31 of the prior calendar year

**Step 2: Calculate hypothetical annual credits**
For each year in the 25-year lookback:

- Apply the **current** cap rate, participation rate, and/or spread to the actual index returns for that year
- This yields 25 hypothetical annual index credits

**Step 3: Calculate the geometric mean**

```
Geometric Mean = [(1 + r₁) × (1 + r₂) × ... × (1 + r₂₅)]^(1/25) - 1
```

Where `rₙ` is the hypothetical index credit for year `n`, subject to the floor (typically 0%).

**Step 4: Apply the 145% earned rate cap**

The maximum illustrated rate is the **lesser of**:
- The geometric mean from Step 3
- 145% of the annual net investment earnings rate on the general account

#### 3.2.3 Worked Example

Consider an FIA with an S&P 500 annual point-to-point strategy, with:
- Current cap rate: 10%
- Floor: 0%
- No participation rate or spread

For the 25-year lookback (hypothetical simplified data):

```
Year  | S&P 500 Return | Applied Cap | Credited Rate
------+----------------+-------------+--------------
  1   |     28.6%      |    10%      |    10.0%
  2   |     21.0%      |    10%      |    10.0%
  3   |     -9.1%      |     0%      |     0.0%
  4   |    -11.9%      |     0%      |     0.0%
  5   |    -22.1%      |     0%      |     0.0%
  6   |     28.7%      |    10%      |    10.0%
  7   |     10.9%      |    10%      |    10.0%
  8   |      4.9%      |     4.9%    |     4.9%
  9   |     15.8%      |    10%      |    10.0%
 10   |      5.5%      |     5.5%    |     5.5%
 11   |    -37.0%      |     0%      |     0.0%
 12   |     26.5%      |    10%      |    10.0%
 13   |     15.1%      |    10%      |    10.0%
 14   |      2.1%      |     2.1%    |     2.1%
 15   |     16.0%      |    10%      |    10.0%
 16   |     32.4%      |    10%      |    10.0%
 17   |     13.7%      |    10%      |    10.0%
 18   |      1.4%      |     1.4%    |     1.4%
 19   |     12.0%      |    10%      |    10.0%
 20   |     21.8%      |    10%      |    10.0%
 21   |    -4.4%       |     0%      |     0.0%
 22   |     31.5%      |    10%      |    10.0%
 23   |     18.4%      |    10%      |    10.0%
 24   |     28.7%      |    10%      |    10.0%
 25   |    -18.1%      |     0%      |     0.0%

Geometric Mean = [(1.10)(1.10)(1.00)(1.00)(1.00)(1.10)(1.10)(1.049)
                  (1.10)(1.055)(1.00)(1.10)(1.10)(1.021)(1.10)(1.10)
                  (1.10)(1.014)(1.10)(1.10)(1.00)(1.10)(1.10)(1.10)
                  (1.00)]^(1/25) - 1

Geometric Mean ≈ 6.23%
```

If the carrier's general account earned rate is 4.5%:
- 145% × 4.5% = 6.525%
- Maximum illustrated rate = min(6.23%, 6.525%) = **6.23%**

#### 3.2.4 The Earned Rate Cap — 145% Rule

The 145% earned rate cap is the constraint that the maximum illustrated credited rate for the non-guaranteed column cannot exceed 145% of the statutory general account earned rate. This prevents carriers from illustrating unrealistically high rates even if the lookback calculation would support them.

The general account earned rate is calculated from the carrier's statutory financial statements:

```
Annual Net Investment Earnings Rate = Net Investment Income / Mean Invested Assets
```

Where:
- Net Investment Income = Gross investment income minus investment expenses
- Mean Invested Assets = Average of beginning and ending invested assets for the year

This calculation must be performed annually and the illustration engine updated when new rates are certified.

### 3.3 AG49-A (2020) — Addressing Benchmark Index Accounts

#### 3.3.1 The Problem AG49-A Solved

After AG49 was adopted, the FIA market saw explosive growth in "proprietary" or "benchmark" indices — indices specifically designed for use in FIA crediting strategies. Examples include:

- S&P MARC 5% Index
- Barclays Trailblazer Sector 5 Index
- BNP Paribas Multi-Asset Diversified 5 Index
- Credit Suisse Momentum Index

These indices were engineered with volatility-controlled mechanisms that produced high lookback geometric means under AG49's formula, even when applied with very high caps or uncapped participation rates. This allowed carriers to illustrate rates significantly higher than traditional S&P 500-based strategies, even if the expected future returns were comparable.

#### 3.3.2 Key AG49-A Changes

**Benchmark Index Account Definition:**
AG49-A defined a "Benchmark Index Account" as any index account where the crediting strategy uses an index that is different from a "plain vanilla" index like the S&P 500, Dow Jones, NASDAQ-100, or Russell 2000.

**Account Value Allocation Limitations:**
For illustration purposes, no more than a specified percentage of premium can be allocated to benchmark index accounts. The benchmark account illustrated rate is limited to:

```
Max Illustrated Rate (Benchmark) = Max Illustrated Rate (S&P 500 Account) + 50 bps
```

This means if the S&P 500 annual point-to-point account's maximum illustrated rate is 6.00%, the benchmark index account can illustrate no more than 6.50%.

**Bonus Product Limitations:**
AG49-A also addressed "bonus" products (products that add a bonus to premium or account value). For products with bonuses:

- The bonus cannot increase the illustrated income in any year compared to a similar product without the bonus
- Bonus products must illustrate using a reduced credited rate to offset the cost of the bonus

#### 3.3.3 AG49-A Implementation Requirements

For illustration engines:

1. **Index classification**: Each index must be classified as "benchmark" or "non-benchmark" in the product configuration
2. **Rate linkage**: Benchmark index illustrated rates must be dynamically linked to the non-benchmark index rate for the same product
3. **Bonus offset calculation**: Products with premium bonuses must reduce the illustrated rate to offset the bonus cost, calculated as:

```
Adjusted Rate = Standard Rate - Bonus Offset

Where Bonus Offset = Annual Amortization of Bonus Cost over the surrender charge period
```

### 3.4 AG49-B (2023) — Further Tightening

#### 3.4.1 The Problem AG49-B Solved

Despite AG49-A's limitations, carriers found new ways to illustrate high rates. Two primary mechanisms:

1. **Multiplier features**: Index accounts with multipliers (e.g., 110% of index credit) were being illustrated at the multiplied rate, significantly inflating projections
2. **Still-high benchmark rates**: The 50 bps spread over the S&P 500 account was insufficient to prevent misleading illustrations

#### 3.4.2 Key AG49-B Changes

**Multiplier Limitation:**
Multipliers can only be reflected in the guaranteed column (at the guaranteed multiplier rate), NOT in the non-guaranteed illustrated column. This is the single most impactful change of AG49-B:

```
Pre-AG49-B:  Illustrated Rate = Lookback Rate × Multiplier (e.g., 6% × 1.10 = 6.60%)
Post-AG49-B: Illustrated Rate = Lookback Rate (without multiplier, e.g., 6.00%)
             Guaranteed column may reflect guaranteed multiplier
```

**Benchmark Index Account Further Restrictions:**
AG49-B reduced the maximum spread for benchmark index accounts:

```
Max Illustrated Rate (Benchmark) = Max Illustrated Rate (S&P 500 Account) + 0 bps
```

Effectively, benchmark index accounts can no longer illustrate higher than the standard S&P 500 annual point-to-point account.

**Income Illustration Restrictions:**
AG49-B imposed new restrictions on income rider illustrations:

- The illustrated income must be shown on both the guaranteed and non-guaranteed basis
- The non-guaranteed income illustration cannot assume future crediting rates exceed the AG49-calculated maximum illustrated rate
- Riders with "income doublers" or enhanced income features must clearly distinguish between standard and enhanced income scenarios

#### 3.4.3 AG49-B Calculation Summary

Post-AG49-B, the maximum illustrated rate for any index account in an FIA is:

```
Max Illustrated Rate = min(
    Geometric Mean of 25-year lookback (using current parameters, without multipliers),
    145% of General Account Earned Rate,
    S&P 500 Annual PTP Account Rate (for benchmark indices)
)
```

### 3.5 AG49 Implementation Architecture

For a system architect building an AG49-compliant illustration engine:

```
┌─────────────────────────────────────────────────────────────────┐
│                    AG49 RATE CALCULATION ENGINE                  │
│                                                                 │
│  ┌───────────────────┐    ┌───────────────────────────────────┐ │
│  │ Historical Index   │    │  Product Configuration            │ │
│  │ Data Repository    │    │  - Index classification           │ │
│  │ - Daily/monthly    │    │  - Cap rates                      │ │
│  │   index values     │    │  - Participation rates            │ │
│  │ - 25+ year history │    │  - Spreads                        │ │
│  │ - Multiple indices │    │  - Floors                         │ │
│  └────────┬──────────┘    │  - Multipliers                    │ │
│           │                │  - Bonus features                 │ │
│           │                └───────────┬───────────────────────┘ │
│           │                            │                         │
│           ▼                            ▼                         │
│  ┌─────────────────────────────────────────────────────────────┐ │
│  │              LOOKBACK CALCULATION MODULE                     │ │
│  │                                                             │ │
│  │  For each index account:                                    │ │
│  │  1. Retrieve 25 years of index data                        │ │
│  │  2. Calculate annual index returns                          │ │
│  │  3. Apply current cap/par/spread/floor                      │ │
│  │  4. Calculate geometric mean                                │ │
│  │  5. Apply AG49-B multiplier exclusion                       │ │
│  │  6. Apply AG49-A benchmark cap                              │ │
│  │  7. Apply 145% earned rate cap                              │ │
│  └──────────────────────────┬──────────────────────────────────┘ │
│                             │                                    │
│                             ▼                                    │
│  ┌─────────────────────────────────────────────────────────────┐ │
│  │           MAXIMUM ILLUSTRATED RATE OUTPUT                    │ │
│  │                                                             │ │
│  │  Per-account maximum rates, certified annually              │ │
│  └─────────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────┘
```

**Key architectural considerations:**

1. **Index data management**: Must maintain 25+ years of daily or monthly index values for every index used across all products. Data must be sourced from authoritative providers (Bloomberg, ICE, S&P Global).

2. **Annual recalculation**: Maximum illustrated rates must be recalculated at least annually when new index data is available (typically January of each year).

3. **Rate certification workflow**: Recalculated rates must go through an actuarial certification process before being used in the illustration engine.

4. **Version control**: The engine must maintain a history of maximum illustrated rates by effective date, so that illustrations generated on different dates use the correct rates.

5. **Audit trail**: Every rate calculation must be fully auditable — inputs, intermediate calculations, and final output must be logged and retrievable.

---

## 4. Fixed Annuity Illustrations

### 4.1 Overview

Fixed annuity illustrations are the simplest category of annuity illustrations because the crediting mechanism is straightforward: a declared interest rate applied to the account value. However, "simple" is relative — there are still significant complexities around guaranteed vs. non-guaranteed elements, multi-year rate structures, and surrender charge interactions.

### 4.2 Guaranteed vs. Non-Guaranteed Elements

Every fixed annuity illustration must present two parallel projections:

**Guaranteed Column:**
- Uses the **minimum guaranteed interest rate** specified in the contract (e.g., 1.00%, 1.50%, 2.00%)
- Applies the **maximum contractual charges** (if any)
- Applies the **full surrender charge schedule**
- Represents the absolute worst-case scenario for the policyholder
- This is the floor — actual values cannot be less than guaranteed values

**Non-Guaranteed (Current) Column:**
- Uses the **current declared rate** (e.g., 4.50%, 5.00%)
- Applies **current charges** (typically the same as maximum for fixed annuities)
- Still applies the surrender charge schedule
- Represents the "if things stay as they are" scenario
- Prominently disclosed as non-guaranteed

### 4.3 MYGA (Multi-Year Guaranteed Annuity) Illustrations

MYGAs have a unique illustration structure because the rate is guaranteed for a specific period (typically 3, 5, 7, or 10 years).

**MYGA Illustration Structure:**

```
Year | Premium | Guar Rate | Account Value | Surr Charge | Surrender Value
─────┼─────────┼───────────┼───────────────┼─────────────┼────────────────
  1  | 100,000 |   4.50%   |    104,500    |    8.00%    |     96,140
  2  |       0 |   4.50%   |    109,203    |    7.00%    |    101,558
  3  |       0 |   4.50%   |    114,117    |    6.00%    |    107,270
  4  |       0 |   4.50%   |    119,252    |    5.00%    |    113,289
  5  |       0 |   4.50%   |    124,618    |    4.00%    |    119,633
  6  |       0 |   *2.50%  |    127,734    |    3.00%    |    123,902
  7  |       0 |   *2.50%  |    130,927    |    2.00%    |    128,308
  8  |       0 |   *2.50%  |    134,200    |    1.00%    |    132,858
  9  |       0 |   *2.50%  |    137,555    |    0.00%    |    137,555
 10  |       0 |   *2.50%  |    141,004    |    0.00%    |    141,004
```

*Asterisk indicates non-guaranteed renewal rate (years 6+ are at a hypothetical renewal rate; guaranteed column would use the minimum guaranteed rate, often 1.00%).*

**MYGA illustration complexities for architects:**

1. **Rate period transitions**: The illustration must clearly delineate the guaranteed rate period from the renewal rate period
2. **Renewal rate assumptions**: The non-guaranteed column must use a defensible renewal rate assumption (typically the current renewal rate, not the initial guaranteed rate)
3. **Market value adjustment (MVA)**: Many MYGAs include MVAs during the guarantee period — the illustration may need to show MVA impact scenarios
4. **Laddering**: Some illustrations show MYGA ladder strategies (multiple MYGAs with staggered maturity dates)

### 4.4 Surrender Value Projections

Surrender value calculation is a core component of every fixed annuity illustration:

```
Surrender Value = Account Value × (1 - Surrender Charge %) - MVA Adjustment (if applicable)
```

The surrender charge schedule is contractual and must be reflected year-by-year:

```
Year:           1     2     3     4     5     6     7     8     9    10
Surr Charge:  8.0%  7.0%  6.0%  5.0%  4.0%  3.0%  2.0%  1.0%  0.0%  0.0%
```

**Free withdrawal provision**: Most fixed annuities allow a penalty-free withdrawal of 10% of account value (or premium) annually. Illustrations must account for this when showing partial withdrawal scenarios.

### 4.5 Death Benefit Projections

For fixed annuities, the standard death benefit is typically the greater of:
- Account value
- Minimum guaranteed account value
- Total premiums paid (in some products, only during the surrender charge period)

```
Death Benefit = max(Account Value, Minimum Guaranteed Value, Premium Paid*)
```

*Premium-based death benefit is product-specific and may only apply during certain periods.

Death benefit projections must be shown in a separate column of the illustration ledger, year-by-year.

### 4.6 Fixed Annuity Illustration Calculation Algorithm

```
For each projection year y (y = 1 to maturity or age 100/120):

  // Calculate credited interest
  IF product_type = "MYGA" AND y <= guarantee_period:
      credited_rate = guaranteed_MYGA_rate
  ELSE:
      credited_rate = current_declared_rate  // non-guaranteed column
      // OR
      credited_rate = minimum_guaranteed_rate  // guaranteed column
  END IF

  // Beginning of year account value
  IF y = 1:
      bov = premium - premium_charges (if any)
  ELSE:
      bov = prior_year_eov
  END IF

  // Apply interest
  interest_credited = bov × credited_rate

  // Apply annual charges (if any — rare for fixed annuities)
  annual_charges = bov × annual_charge_rate

  // End of year values
  eov_account_value = bov + interest_credited - annual_charges - withdrawals(y)

  // Surrender value
  surrender_charge_pct = surrender_schedule[y]
  eov_surrender_value = eov_account_value × (1 - surrender_charge_pct)

  // Death benefit
  eov_death_benefit = max(eov_account_value, minimum_death_benefit_formula)

  // Store results
  ledger[y] = {
      year: y,
      age: client_age + y,
      premium: premium_paid_in_year(y),
      interest_credited: interest_credited,
      account_value: eov_account_value,
      surrender_charge_pct: surrender_charge_pct,
      surrender_value: eov_surrender_value,
      death_benefit: eov_death_benefit
  }

NEXT y
```

---

## 5. Variable Annuity Illustrations

### 5.1 Overview

Variable annuity (VA) illustrations are fundamentally different from fixed and indexed annuity illustrations because the contract owner bears the investment risk. The account value fluctuates based on the performance of underlying sub-accounts (mutual fund-like investment options). This introduces uncertainty that makes illustration significantly more complex.

### 5.2 Hypothetical Performance Scenarios

SEC and FINRA regulations require VA illustrations to use hypothetical, uniform gross rates of return rather than historical or projected returns. The standard scenarios are:

| Scenario | Gross Return | Purpose |
|----------|-------------|---------|
| **Scenario 1 (Floor)** | 0% | Shows the impact of fees in a flat market |
| **Scenario 2 (Moderate)** | 6% | Represents moderate long-term growth |
| **Scenario 3 (Optimistic)** | 10% | Shows potential in a strong market |

Some carriers also include a negative return scenario (e.g., -10%) to illustrate downside risk.

### 5.3 Fee Impact Illustrations

VA fee illustrations are critical because VAs have a complex, layered fee structure:

```
Total Annual Cost = M&E Charge + Administrative Fee + Sub-Account Fees +
                    Rider Charges + Distribution Charges (12b-1)

Example:
  Mortality & Expense (M&E):        1.25%
  Administrative Fee:                0.15%
  Sub-Account Average Expense:       0.75%
  GLWB Rider:                        1.10%
  Distribution (12b-1):              0.25%
  ─────────────────────────────────────────
  Total Annual Cost:                 3.50%
```

The illustration must show the **net** impact of all fees on account value:

```
Net Return = Gross Hypothetical Return - Total Annual Cost

At 6% gross:  Net Return = 6.00% - 3.50% = 2.50%
At 0% gross:  Net Return = 0.00% - 3.50% = -3.50%  (account value declines)
```

### 5.4 VA Illustration Ledger — Sample Output

```
Variable Annuity Illustration — Hypothetical 6% Gross Return
Premium: $200,000 | Owner Age: 60 | M&E: 1.25% | Admin: 0.15%
Sub-Account Fees: 0.75% | GLWB Rider: 1.10% | Total: 3.25%

Year | Age | Premium | Gross   | Total  | Net    | Account  | Surr   | Surrender | Death   | GLWB     | Annual
     |     |         | Return  | Fees   | Return | Value    | Chg %  | Value     | Benefit | Ben Base | Income
─────┼─────┼─────────┼─────────┼────────┼────────┼──────────┼────────┼───────────┼─────────┼──────────┼────────
  1  |  61 | 200,000 | 12,000  |  6,500 |  5,500 | 205,500  | 7.00%  | 191,115   | 212,000 | 214,000  |      0
  2  |  62 |       0 | 12,330  |  6,679 |  5,651 | 211,151  | 6.00%  | 198,482   | 218,785 | 228,980  |      0
  3  |  63 |       0 | 12,669  |  6,862 |  5,807 | 216,958  | 5.00%  | 206,110   | 225,764 | 245,009  |      0
  4  |  64 |       0 | 13,017  |  7,051 |  5,967 | 222,925  | 4.00%  | 214,008   | 232,944 | 262,160  |      0
  5  |  65 |       0 | 13,376  |  7,245 |  6,130 | 229,055  | 3.00%  | 222,183   | 240,335 | 280,511  |      0
  6  |  66 |       0 | 13,743  |  7,444 |  6,299 | 235,354  | 2.00%  | 230,647   | 247,943 | 300,147  |      0
  7  |  67 |       0 | 14,121  |  7,649 |  6,472 | 241,826  | 1.00%  | 239,408   | 255,778 | 321,157  |      0
  8  |  68 |       0 | 14,510  |  7,859 |  6,650 | 248,476  | 0.00%  | 248,476   | 263,848 | 343,638  |      0
  9  |  69 |       0 | 14,909  |  8,075 |  6,833 | 255,310  | 0.00%  | 255,310   | 272,160 | 367,693  |      0
 10  |  70 |       0 | 15,319  |  8,298 |  7,021 | 262,330  | 0.00%  | 262,330   | 280,724 | 393,431  | 19,706
 11  |  71 |       0 | 14,557  |  7,903 |  6,655 | 249,280  | 0.00%  | 249,280   | 280,724 | 393,431  | 19,706
 ...
```

### 5.5 Guaranteed Benefit Illustrations

The most complex aspect of VA illustrations is projecting the values of guaranteed living and death benefit riders. Each guarantee type requires its own projection logic:

#### 5.5.1 GMDB (Guaranteed Minimum Death Benefit) Illustrations

GMDB variants and their projection formulas:

**Return of Premium (ROP):**
```
GMDB = max(Account Value, Total Premiums - Partial Withdrawals)
```

**Highest Anniversary Value (HAV):**
```
GMDB = max(Account Value, Highest Account Value on Any Contract Anniversary)
```

Note: For illustration purposes, the HAV is computed from the hypothetical scenario. Under a 6% gross scenario, the HAV generally equals the current account value (because it's continuously growing). Under a 0% scenario, the HAV is the initial premium.

**Ratchet and Roll-Up:**
```
GMDB = max(Account Value, max(Highest Anniversary Value, Premium × (1 + roll_up_rate)^years))
```

Roll-up rate is typically 5-7% compounded annually, subject to a maximum age (often 80).

#### 5.5.2 GMWB (Guaranteed Minimum Withdrawal Benefit) Illustrations

GMWB projections track a "benefit base" separate from the account value:

```
For each year:
    benefit_base = max(benefit_base_prior, account_value)  // ratchet
    // OR
    benefit_base = benefit_base_prior × (1 + roll_up_rate)  // roll-up during deferral
    
    guaranteed_withdrawal = benefit_base × withdrawal_percentage
    
    // After withdrawals begin:
    account_value = account_value - withdrawal
    
    // Even if account_value reaches $0:
    // Withdrawals continue at guaranteed_withdrawal amount for life
```

#### 5.5.3 GLWB (Guaranteed Lifetime Withdrawal Benefit) Illustrations

GLWB is the most popular VA rider. Its illustration requires tracking:

1. **Benefit base**: Subject to roll-up during deferral and ratchet features
2. **Withdrawal percentage**: Based on age at first withdrawal (step-up schedule)
3. **Income phase**: Guaranteed annual withdrawal for life, even if account value is depleted
4. **Step-up features**: Periodic benefit base increases based on account value growth

```
GLWB Withdrawal Percentage Schedule (Example):
Age at First Withdrawal | Single Life % | Joint Life %
────────────────────────┼───────────────┼─────────────
       59½ - 64         |     4.00%     |    3.50%
       65 - 69          |     5.00%     |    4.50%
       70 - 74          |     5.50%     |    5.00%
       75 - 79          |     6.00%     |    5.50%
       80+              |     6.50%     |    6.00%
```

**GLWB Illustration Algorithm:**

```
// Deferral Phase
For each year y until withdrawal_start_year:
    IF roll_up_feature:
        benefit_base = benefit_base × (1 + roll_up_rate)
    END IF
    
    IF ratchet_feature AND account_value > benefit_base:
        benefit_base = account_value
    END IF
    
    rider_charge = account_value × rider_charge_rate
    account_value = account_value × (1 + net_return) - rider_charge

// Income Phase
withdrawal_pct = lookup_withdrawal_pct(age_at_first_withdrawal, life_type)
annual_income = benefit_base × withdrawal_pct

For each year y from withdrawal_start_year:
    account_value = account_value × (1 + net_return) - rider_charge - annual_income
    
    IF account_value < 0:
        account_value = 0
        // Income continues at annual_income (guaranteed for life)
    END IF
    
    // Step-up check (if applicable)
    IF step_up_feature AND anniversary AND account_value > benefit_base:
        benefit_base = account_value
        annual_income = benefit_base × withdrawal_pct
    END IF
```

#### 5.5.4 GMIB (Guaranteed Minimum Income Benefit) Illustrations

GMIB guarantees a minimum annuitization value. Its illustration must show:

1. **Guaranteed annuitization base**: Grows at the GMIB roll-up rate (typically 5-6%)
2. **Annuitization factors**: The guaranteed annuity purchase rates at various ages
3. **Projected annual income**: Calculated from the annuitization base and factors

```
GMIB Annuitization Value = GMIB Base × Annuity Factor

Where:
  GMIB Base = Premium × (1 + roll_up_rate)^deferral_years
  Annuity Factor = Guaranteed factor based on age and payout type
  
Example:
  Premium: $200,000
  Roll-up rate: 5%
  Deferral period: 10 years
  GMIB Base at year 10: $200,000 × (1.05)^10 = $325,779
  Annuity Factor at age 70 (life only): 7.50 per $1,000
  Annual Income: $325,779 / 1,000 × 7.50 × 12 = $29,320/year
```

### 5.6 Sub-Account Allocation Impact

VA illustrations can show different allocation strategies and their impact:

- **Conservative allocation**: Higher bond allocation, lower illustrated gross return (e.g., 5%)
- **Moderate allocation**: Balanced stock/bond allocation, moderate return (e.g., 6%)
- **Aggressive allocation**: Higher equity allocation, higher illustrated return (e.g., 8%)

Each allocation may have different sub-account expense ratios, affecting net returns.

---

## 6. FIA Illustrations

### 6.1 Overview

Fixed Indexed Annuity (FIA) illustrations are the most complex illustration type in the annuity domain. They must comply with AG49 (and its revisions), handle multiple crediting strategies with varying parameters, project income rider values, and present results that are both compliant and comprehensible to consumers.

### 6.2 Index Credit Illustration Methodology

FIA illustrations project future index credits using the AG49-calculated maximum illustrated rate. The key principle is that the same illustrated rate is applied uniformly to each future year — there is no year-to-year variation in the non-guaranteed illustration.

**This is a critical distinction**: Unlike a stochastic model that might show variable returns, the regulatory illustration uses a flat, constant rate for every year.

```
Illustration Approach for Index Credits:
Year 1:  Illustrated Rate = 6.23%  (AG49 maximum)
Year 2:  Illustrated Rate = 6.23%
Year 3:  Illustrated Rate = 6.23%
...
Year 30: Illustrated Rate = 6.23%
```

### 6.3 Cap / Participation Rate / Spread Scenarios

FIAs use various crediting mechanisms, and the illustration must accurately reflect each:

#### 6.3.1 Cap Rate Strategy

```
Index Credit = min(Index Return, Cap Rate), floored at 0%

If Cap = 10% and Index Return = 15%:  Credit = 10%
If Cap = 10% and Index Return = 7%:   Credit = 7%
If Cap = 10% and Index Return = -5%:  Credit = 0%
```

#### 6.3.2 Participation Rate Strategy

```
Index Credit = max(Index Return × Participation Rate, 0%)

If Par Rate = 50% and Index Return = 20%:  Credit = 10%
If Par Rate = 50% and Index Return = 8%:   Credit = 4%
If Par Rate = 50% and Index Return = -10%: Credit = 0%
```

#### 6.3.3 Spread (Margin) Strategy

```
Index Credit = max(Index Return - Spread, 0%)

If Spread = 3% and Index Return = 12%:  Credit = 9%
If Spread = 3% and Index Return = 5%:   Credit = 2%
If Spread = 3% and Index Return = -2%:  Credit = 0%
```

#### 6.3.4 Combined Strategy (Cap + Participation + Spread)

Some strategies combine multiple mechanisms:

```
Index Credit = max(min(Index Return × Participation Rate, Cap Rate) - Spread, 0%)
```

### 6.4 Historical Lookback Illustrations

Some carriers provide supplemental illustrations showing how the product would have performed using actual historical index returns. These are permissible ONLY as supplements to the standard AG49-compliant illustration and must:

- Be clearly labeled as historical and not predictive
- Show the full lookback period (not cherry-picked periods)
- Apply current (not historical) product parameters (caps, par rates, spreads)
- Include years where the index credit would have been 0% (floor)

```
Historical Lookback Supplement — S&P 500 Annual Point-to-Point
Cap Rate: 9.50% | Floor: 0% | Premium: $100,000

Year | Calendar | S&P 500  | Applied | Index  | Cumulative
     |   Year   | Return   | Cap     | Credit | AV
─────┼──────────┼──────────┼─────────┼────────┼──────────
  1  |   1999   |  21.04%  |  9.50%  |  9.50% | 109,500
  2  |   2000   |  -9.10%  |  9.50%  |  0.00% | 109,500
  3  |   2001   | -11.89%  |  9.50%  |  0.00% | 109,500
  4  |   2002   | -22.10%  |  9.50%  |  0.00% | 109,500
  5  |   2003   |  28.68%  |  9.50%  |  9.50% | 119,903
  6  |   2004   |  10.88%  |  9.50%  |  9.50% | 131,293
  7  |   2005   |   4.91%  |  9.50%  |  4.91% | 137,738
  8  |   2006   |  15.79%  |  9.50%  |  9.50% | 150,823
  9  |   2007   |   5.49%  |  9.50%  |  5.49% | 159,104
 10  |   2008   | -37.00%  |  9.50%  |  0.00% | 159,104
 11  |   2009   |  26.46%  |  9.50%  |  9.50% | 174,219
 12  |   2010   |  15.06%  |  9.50%  |  9.50% | 190,770
 ...
```

### 6.5 Multiple Index Strategy Illustrations

Most FIAs offer multiple index strategies that can be combined. The illustration must handle allocation across strategies:

```
Premium: $200,000
Allocation:
  - S&P 500 Annual PTP (Cap 9.50%): 50% ($100,000)
  - S&P 500 Monthly Sum Cap (Cap 2.50%/mo): 25% ($50,000)
  - Fixed Account (3.00% guaranteed): 25% ($50,000)

Illustrated Rates (per AG49):
  - S&P 500 Annual PTP: 6.23%
  - S&P 500 Monthly Sum Cap: 5.87%
  - Fixed Account: 3.00%

Blended Illustrated Rate = (50% × 6.23%) + (25% × 5.87%) + (25% × 3.00%)
                         = 3.115% + 1.4675% + 0.75%
                         = 5.33%
```

The illustration engine must project each strategy independently and then combine them for the total contract-level projection.

### 6.6 Bonus Illustrations

FIA bonuses come in several forms, each with distinct illustration treatment:

#### 6.6.1 Premium Bonus

```
Account Value at Issue = Premium + (Premium × Bonus %)

Example: $100,000 premium with 10% bonus
Account Value Day 1 = $100,000 + $10,000 = $110,000
```

However, AG49-A requires that the illustration offset the bonus cost:

```
Adjusted Illustrated Rate = Standard AG49 Rate - Bonus Offset

Where Bonus Offset ≈ Bonus % / Surrender Charge Period (simplified)
Example: 10% bonus / 10-year surrender = 1.00% annual offset
If standard rate = 6.23%, adjusted rate = 5.23%
```

#### 6.6.2 Vesting Bonus

Some bonuses vest over time (e.g., 10% bonus that vests 10% per year over 10 years):

```
Year 1:  Vested Bonus = $10,000 × 10% = $1,000
Year 2:  Vested Bonus = $10,000 × 20% = $2,000
...
Year 10: Vested Bonus = $10,000 × 100% = $10,000
```

The illustration must show both the total account value (including unvested bonus) and the surrender value (which may exclude unvested bonus portions).

#### 6.6.3 Interest Bonus

Some FIAs add a bonus to each year's index credit:

```
Total Credit = Index Credit + Interest Bonus

Example: If Index Credit = 5% and Interest Bonus = 1%, Total Credit = 6%
```

Post-AG49-B, interest bonuses applied as multipliers cannot be reflected in the non-guaranteed illustrated column.

### 6.7 Income Rider Illustrations

Income riders are the most popular feature on FIAs and their illustration is complex:

#### 6.7.1 Income Rider Components

```
┌───────────────────────────────────────────────────┐
│              INCOME RIDER ANATOMY                  │
│                                                    │
│  Income Benefit Base (IBB)                         │
│  ├── Initial value = Premium (or Premium + Bonus)  │
│  ├── During deferral:                              │
│  │   ├── Roll-up: IBB × (1 + roll_up_rate)        │
│  │   └── Ratchet: max(IBB, Account Value)          │
│  └── At income start:                              │
│      └── IBB is frozen (no further growth)         │
│                                                    │
│  Income Percentage                                 │
│  ├── Based on age at first withdrawal              │
│  ├── Single vs. Joint life                         │
│  └── May include bonus income features             │
│                                                    │
│  Annual Income = IBB × Income Percentage           │
└───────────────────────────────────────────────────┘
```

#### 6.7.2 Roll-Up Rate Projections

The income benefit base typically grows at a guaranteed roll-up rate during the deferral period:

```
Income Benefit Base Projection:
Premium: $200,000 | Roll-up Rate: 7.00% (simple or compound)

Compound Roll-Up:
Year  | Age | IBB (Compound)
──────┼─────┼───────────────
  0   |  55 |    200,000
  1   |  56 |    214,000
  2   |  57 |    228,980
  3   |  58 |    245,009
  4   |  59 |    262,160
  5   |  60 |    280,511
  6   |  61 |    300,147
  7   |  62 |    321,157
  8   |  63 |    343,638
  9   |  64 |    367,693
 10   |  65 |    393,431

Simple Roll-Up:
Year  | Age | IBB (Simple)
──────┼─────┼──────────────
  0   |  55 |    200,000
  1   |  56 |    214,000
  2   |  57 |    228,000
  3   |  58 |    242,000
  4   |  59 |    256,000
  5   |  60 |    270,000
  6   |  61 |    284,000
  7   |  62 |    298,000
  8   |  63 |    312,000
  9   |  64 |    326,000
 10   |  65 |    340,000
```

#### 6.7.3 Income Percentage Schedules

```
Typical Income Percentage Schedule:
Age at First | Single Life | Joint Life
Withdrawal   | Percentage  | Percentage
─────────────┼─────────────┼───────────
   55 - 59   |    3.75%    |   3.25%
   60 - 64   |    4.25%    |   3.75%
   65 - 69   |    5.00%    |   4.50%
   70 - 74   |    5.50%    |   5.00%
   75 - 79   |    6.00%    |   5.50%
   80+       |    6.50%    |   6.00%
```

#### 6.7.4 Complete Income Rider Illustration

```
FIA Income Rider Illustration
Premium: $200,000 | Age: 55 | Income Start: Age 65
Roll-up Rate: 7.00% compound | Income %: 5.00% (Single Life at 65)
AG49 Illustrated Rate: 6.23% | Rider Charge: 1.00% of IBB

Year | Age | Account  | Surr    | Income   | Annual  | Cumulative
     |     | Value    | Value   | Ben Base | Income  | Income
─────┼─────┼──────────┼─────────┼──────────┼─────────┼───────────
  1  |  56 | 210,460  | 193,623 | 214,000  |       0 |         0
  2  |  57 | 221,565  | 208,271 | 228,980  |       0 |         0
  3  |  58 | 233,340  | 223,687 | 245,009  |       0 |         0
  4  |  59 | 245,813  | 239,914 | 262,160  |       0 |         0
  5  |  60 | 259,014  | 256,424 | 280,511  |       0 |         0
  6  |  61 | 272,975  | 270,245 | 300,147  |       0 |         0
  7  |  62 | 287,730  | 284,853 | 321,157  |       0 |         0
  8  |  63 | 303,317  | 303,317 | 343,638  |       0 |         0
  9  |  64 | 319,773  | 319,773 | 367,693  |       0 |         0
 10  |  65 | 337,140  | 337,140 | 393,431  | 19,672  |    19,672
 11  |  66 | 337,489  | 337,489 | 393,431  | 19,672  |    39,343
 12  |  67 | 337,831  | 337,831 | 393,431  | 19,672  |    59,015
 13  |  68 | 338,167  | 338,167 | 393,431  | 19,672  |    78,687
 14  |  69 | 338,496  | 338,496 | 393,431  | 19,672  |    98,358
 15  |  70 | 338,819  | 338,819 | 393,431  | 19,672  |   118,030
 ...
 25  |  80 | 340,812  | 340,812 | 393,431  | 19,672  |   315,146
 30  |  85 | 341,789  | 341,789 | 393,431  | 19,672  |   413,504
 35  |  90 | 342,728  | 342,728 | 393,431  | 19,672  |   511,863
```

Income at age 65: $393,431 × 5.00% = $19,672/year

**Key architectural note**: The income rider charge is typically deducted from the account value, not the income benefit base. This means the account value can decrease while the income benefit base grows. The illustration must accurately model this divergence.

### 6.8 FIA Illustration Calculation Engine — Pseudocode

```
FUNCTION generate_fia_illustration(params):
    // Initialization
    account_value = params.premium + bonus_amount(params)
    surrender_value = 0
    income_benefit_base = params.premium + bonus_ibb(params)
    income_active = false
    cumulative_income = 0
    
    // Get AG49-compliant illustrated rate per strategy
    FOR EACH strategy IN params.allocation_strategies:
        strategy.illustrated_rate = get_ag49_rate(strategy)
    END FOR
    
    // Calculate blended rate
    blended_rate = 0
    FOR EACH strategy IN params.allocation_strategies:
        blended_rate += strategy.allocation_pct × strategy.illustrated_rate
    END FOR
    
    // Year-by-year projection
    FOR year = 1 TO params.projection_years:
        age = params.client_age + year
        
        // --- GUARANTEED COLUMN ---
        guar_credited = account_value_guar × params.min_guaranteed_rate
        account_value_guar = account_value_guar + guar_credited
        
        // Rider charge (guaranteed column)
        IF params.has_income_rider:
            guar_rider_charge = income_benefit_base_guar × params.rider_charge_rate
            account_value_guar = account_value_guar - guar_rider_charge
        END IF
        
        // --- NON-GUARANTEED (CURRENT) COLUMN ---
        credited_interest = account_value × blended_rate
        account_value = account_value + credited_interest
        
        // Rider charge (non-guaranteed column)
        IF params.has_income_rider:
            rider_charge = income_benefit_base × params.rider_charge_rate
            account_value = account_value - rider_charge
            
            // IBB growth (deferral phase)
            IF NOT income_active:
                IF params.rollup_type = "compound":
                    income_benefit_base = income_benefit_base × (1 + params.rollup_rate)
                ELSE:  // simple
                    income_benefit_base = income_benefit_base + (params.initial_ibb × params.rollup_rate)
                END IF
                
                // Ratchet
                IF params.has_ratchet AND account_value > income_benefit_base:
                    income_benefit_base = account_value
                END IF
            END IF
            
            // Income start
            IF age >= params.income_start_age AND NOT income_active:
                income_active = true
                income_pct = lookup_income_pct(age, params.life_type)
                annual_income = income_benefit_base × income_pct
            END IF
            
            // Income withdrawal
            IF income_active:
                account_value = max(account_value - annual_income, 0)
                cumulative_income = cumulative_income + annual_income
            END IF
        END IF
        
        // Surrender value
        surr_charge_pct = params.surrender_schedule[year]
        surrender_value = account_value × (1 - surr_charge_pct)
        
        // Death benefit
        death_benefit = calculate_death_benefit(account_value, params)
        
        // Store ledger row
        ledger.append({
            year, age, account_value, surrender_value,
            death_benefit, income_benefit_base,
            annual_income, cumulative_income,
            credited_interest, rider_charge
        })
    END FOR
    
    RETURN ledger
END FUNCTION
```

---

## 7. Illustration Engine Architecture

### 7.1 High-Level Architecture

The illustration engine is the computational core of the annuity illustration system. It must handle multiple product types, comply with varying regulations, and produce accurate, auditable results at scale.

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                         ILLUSTRATION PLATFORM                               │
│                                                                             │
│  ┌─────────────┐   ┌──────────────┐   ┌──────────────┐   ┌──────────────┐  │
│  │  Web UI /    │   │  Agent       │   │  API         │   │  Batch       │  │
│  │  Illustrator │   │  Desktop App │   │  Gateway     │   │  Processing  │  │
│  └──────┬──────┘   └──────┬───────┘   └──────┬───────┘   └──────┬───────┘  │
│         │                  │                   │                  │          │
│         └──────────────────┴───────────────────┴──────────────────┘          │
│                                    │                                        │
│                                    ▼                                        │
│  ┌─────────────────────────────────────────────────────────────────────┐    │
│  │                     ILLUSTRATION API LAYER                          │    │
│  │                                                                     │    │
│  │  ┌─────────────────┐  ┌──────────────────┐  ┌──────────────────┐   │    │
│  │  │  Request         │  │  Validation &    │  │  Response        │   │    │
│  │  │  Handling         │  │  Authorization   │  │  Formatting      │   │    │
│  │  └─────────────────┘  └──────────────────┘  └──────────────────┘   │    │
│  └────────────────────────────────┬────────────────────────────────────┘    │
│                                   │                                         │
│                                   ▼                                         │
│  ┌─────────────────────────────────────────────────────────────────────┐    │
│  │                    CALCULATION ENGINE                                │    │
│  │                                                                     │    │
│  │  ┌───────────────┐  ┌──────────────┐  ┌──────────────────────────┐ │    │
│  │  │  Product       │  │  Scenario    │  │  Projection Engine       │ │    │
│  │  │  Configuration │  │  Manager     │  │  ┌────────────────────┐  │ │    │
│  │  │  Engine        │  │              │  │  │  Fixed Annuity     │  │ │    │
│  │  └───────┬───────┘  └──────┬───────┘  │  │  Module            │  │ │    │
│  │          │                  │          │  ├────────────────────┤  │ │    │
│  │          │                  │          │  │  FIA Module        │  │ │    │
│  │          │                  │          │  │  (AG49 compliant)  │  │ │    │
│  │          │                  │          │  ├────────────────────┤  │ │    │
│  │          │                  │          │  │  VA Module         │  │ │    │
│  │          │                  │          │  │  (SEC compliant)   │  │ │    │
│  │          │                  │          │  ├────────────────────┤  │ │    │
│  │          │                  │          │  │  SPIA/DIA Module   │  │ │    │
│  │          └──────────────────┤          │  ├────────────────────┤  │ │    │
│  │                             │          │  │  Rider Projection  │  │ │    │
│  │                             │          │  │  Engine            │  │ │    │
│  │                             │          │  ├────────────────────┤  │ │    │
│  │                             │          │  │  Tax Calculation   │  │ │    │
│  │                             │          │  │  Module            │  │ │    │
│  │                             ▼          │  └────────────────────┘  │ │    │
│  │                    ┌──────────────┐    └──────────────────────────┘ │    │
│  │                    │  AG49 Rate   │                                 │    │
│  │                    │  Calculator  │                                 │    │
│  │                    └──────────────┘                                 │    │
│  └────────────────────────────────────────────────────────────────────┘    │
│                                   │                                         │
│                                   ▼                                         │
│  ┌─────────────────────────────────────────────────────────────────────┐    │
│  │                    OUTPUT GENERATION LAYER                           │    │
│  │                                                                     │    │
│  │  ┌──────────────┐  ┌──────────────┐  ┌──────────────────────────┐  │    │
│  │  │  PDF          │  │  Interactive │  │  Data Export             │  │    │
│  │  │  Generator    │  │  Web Display │  │  (JSON/XML/CSV)          │  │    │
│  │  └──────────────┘  └──────────────┘  └──────────────────────────┘  │    │
│  └─────────────────────────────────────────────────────────────────────┘    │
│                                                                             │
│  ┌─────────────────────────────────────────────────────────────────────┐    │
│  │                    DATA LAYER                                        │    │
│  │                                                                     │    │
│  │  ┌──────────────┐  ┌──────────────┐  ┌──────────────────────────┐  │    │
│  │  │  Product      │  │  Index       │  │  Illustration            │  │    │
│  │  │  Repository   │  │  Data Store  │  │  Storage                 │  │    │
│  │  └──────────────┘  └──────────────┘  └──────────────────────────┘  │    │
│  └─────────────────────────────────────────────────────────────────────┘    │
└─────────────────────────────────────────────────────────────────────────────┘
```

### 7.2 Calculation Engine Design

#### 7.2.1 Core Design Principles

1. **Product-agnostic core**: The projection engine should use a common framework that can be configured for any product type through product specification files, not hardcoded logic.

2. **Strategy pattern for crediting mechanisms**: Each crediting method (fixed, indexed cap, indexed participation, indexed spread) should be implemented as a pluggable strategy.

3. **Rider projection as composable modules**: Riders modify the core projection. Each rider type (GLWB, GMDB, etc.) should be a composable module that hooks into the projection loop.

4. **Dual-column architecture**: Every calculation must run in parallel for guaranteed and non-guaranteed scenarios.

5. **Deterministic reproducibility**: Given the same inputs and the same product configuration version, the engine must produce identical outputs every time.

#### 7.2.2 Product Configuration Schema

The product configuration is the data-driven specification that tells the engine how to project a specific product. It should be stored as structured data (JSON/XML/database records), not as code.

```json
{
  "product_id": "FIA-2024-ACCUMULATOR-PLUS",
  "product_type": "FIA",
  "effective_date": "2024-01-01",
  "version": "3.2",
  "certification": {
    "actuary": "John Smith, FSA, MAAA",
    "certification_date": "2024-01-15",
    "expiration_date": "2025-01-14"
  },
  "premium_rules": {
    "min_premium": 25000,
    "max_premium": 2000000,
    "min_issue_age": 0,
    "max_issue_age": 85,
    "premium_types": ["single", "flexible"],
    "qualified_types": ["NQ", "IRA", "Roth_IRA", "401k_rollover"]
  },
  "crediting_strategies": [
    {
      "strategy_id": "SP500-ANN-PTP-CAP",
      "strategy_name": "S&P 500 Annual Point-to-Point with Cap",
      "index": "SP500",
      "index_classification": "non_benchmark",
      "crediting_method": "annual_point_to_point",
      "cap_rate": {
        "current": 0.095,
        "guaranteed_minimum": 0.01
      },
      "participation_rate": {
        "current": 1.00,
        "guaranteed_minimum": 1.00
      },
      "spread": {
        "current": 0.00,
        "guaranteed_maximum": 0.00
      },
      "floor": 0.00,
      "multiplier": {
        "current": 1.00,
        "guaranteed_minimum": 1.00
      },
      "ag49_max_illustrated_rate": 0.0623,
      "min_allocation_pct": 0.00,
      "max_allocation_pct": 1.00
    },
    {
      "strategy_id": "FIXED-ACCOUNT",
      "strategy_name": "Fixed Interest Account",
      "crediting_method": "fixed_declared",
      "current_rate": 0.030,
      "guaranteed_minimum_rate": 0.010,
      "min_allocation_pct": 0.00,
      "max_allocation_pct": 1.00
    }
  ],
  "surrender_schedule": {
    "years": [1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
    "charges": [0.09, 0.09, 0.08, 0.07, 0.06, 0.05, 0.04, 0.03, 0.02, 0.01]
  },
  "free_withdrawal": {
    "type": "percentage_of_account_value",
    "percentage": 0.10,
    "available_after_year": 1
  },
  "death_benefit": {
    "type": "account_value",
    "minimum": "premium_less_withdrawals"
  },
  "bonus": {
    "type": "premium_bonus",
    "bonus_percentage": 0.08,
    "vesting_schedule": [0.0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0],
    "applies_to_income_benefit_base": true
  },
  "available_riders": [
    {
      "rider_id": "GLWB-INCOME-PLUS",
      "rider_type": "GLWB",
      "rider_charge_rate": 0.0100,
      "charge_basis": "income_benefit_base",
      "rollup_rate": 0.07,
      "rollup_type": "compound",
      "rollup_max_years": 20,
      "rollup_max_age": 85,
      "income_pct_schedule": {
        "single": [
          {"age_range": [55, 59], "pct": 0.0375},
          {"age_range": [60, 64], "pct": 0.0425},
          {"age_range": [65, 69], "pct": 0.0500},
          {"age_range": [70, 74], "pct": 0.0550},
          {"age_range": [75, 79], "pct": 0.0600},
          {"age_range": [80, 120], "pct": 0.0650}
        ],
        "joint": [
          {"age_range": [55, 59], "pct": 0.0325},
          {"age_range": [60, 64], "pct": 0.0375},
          {"age_range": [65, 69], "pct": 0.0450},
          {"age_range": [70, 74], "pct": 0.0500},
          {"age_range": [75, 79], "pct": 0.0550},
          {"age_range": [80, 120], "pct": 0.0600}
        ]
      },
      "ratchet_feature": true,
      "step_up_frequency": "annual"
    }
  ],
  "state_availability": {
    "available_states": ["ALL"],
    "excluded_states": ["NY"],
    "ny_version": "FIA-2024-ACCUMULATOR-PLUS-NY"
  }
}
```

#### 7.2.3 Strategy Pattern for Crediting Mechanisms

```
┌─────────────────────────────────────┐
│     CreditingStrategy (Interface)    │
│                                     │
│  + calculateCredit(                 │
│      indexReturn: decimal,          │
│      params: StrategyParams         │
│    ): decimal                       │
│                                     │
│  + getGuaranteedRate(): decimal     │
│  + getIllustratedRate(): decimal    │
└──────────────┬──────────────────────┘
               │
    ┌──────────┼──────────┬──────────────────┐
    │          │          │                  │
    ▼          ▼          ▼                  ▼
┌────────┐ ┌────────┐ ┌────────────┐ ┌──────────────┐
│ Fixed  │ │ Cap    │ │ Particip.  │ │ Spread       │
│ Rate   │ │ Rate   │ │ Rate       │ │ Strategy     │
│Strategy│ │Strategy│ │ Strategy   │ │              │
└────────┘ └────────┘ └────────────┘ └──────────────┘
```

Each crediting strategy implements a common interface:

```python
class CreditingStrategy:
    def calculate_credit(self, index_return, params):
        raise NotImplementedError
    
    def get_guaranteed_rate(self):
        raise NotImplementedError
    
    def get_illustrated_rate(self):
        raise NotImplementedError

class CapRateStrategy(CreditingStrategy):
    def calculate_credit(self, index_return, params):
        raw_credit = min(index_return, params.cap_rate)
        return max(raw_credit, params.floor)  # Apply floor
    
    def get_guaranteed_rate(self):
        return self.params.guaranteed_minimum_rate
    
    def get_illustrated_rate(self):
        return self.params.ag49_max_illustrated_rate

class ParticipationRateStrategy(CreditingStrategy):
    def calculate_credit(self, index_return, params):
        raw_credit = index_return * params.participation_rate
        if params.cap_rate:
            raw_credit = min(raw_credit, params.cap_rate)
        return max(raw_credit, params.floor)
    
class SpreadStrategy(CreditingStrategy):
    def calculate_credit(self, index_return, params):
        raw_credit = index_return - params.spread
        if params.cap_rate:
            raw_credit = min(raw_credit, params.cap_rate)
        return max(raw_credit, params.floor)
```

### 7.3 Scenario Management

The illustration engine must support multiple projection scenarios:

| Scenario Type | Description | Typical Usage |
|---------------|-------------|---------------|
| **Guaranteed** | Uses minimum guaranteed rates and maximum charges | Required in every illustration |
| **Current/Non-Guaranteed** | Uses current rates and current charges | Required in every illustration |
| **Mid-Point** | Uses rate halfway between guaranteed and current | Optional, some carriers include |
| **Custom Rate** | User-specified rate for what-if analysis | Agent-initiated exploratory |
| **Historical** | Uses actual historical index returns | Supplemental only (AG49 compliant) |
| **Stochastic** | Monte Carlo simulation with random returns | Advanced analysis, not for standard illustration |

**Scenario management architecture:**

```json
{
  "scenario_set": {
    "illustration_id": "ILL-2024-001234",
    "scenarios": [
      {
        "scenario_id": "GUARANTEED",
        "type": "guaranteed",
        "description": "Minimum Guaranteed Values",
        "assumptions": {
          "crediting_rate_type": "guaranteed_minimum",
          "charge_type": "maximum",
          "rider_charge_type": "maximum"
        }
      },
      {
        "scenario_id": "CURRENT",
        "type": "non_guaranteed",
        "description": "Current Non-Guaranteed Values",
        "assumptions": {
          "crediting_rate_type": "ag49_illustrated",
          "charge_type": "current",
          "rider_charge_type": "current"
        }
      }
    ]
  }
}
```

### 7.4 Multi-Year Projection Algorithm

The core projection loop processes each year sequentially, maintaining state across years:

```
FUNCTION multi_year_projection(initial_state, product_config, scenario, years):
    state = initial_state
    results = []
    
    FOR year = 1 TO years:
        // Phase 1: Beginning-of-year processing
        state = process_premium_payments(state, year)
        state = process_bonus_credits(state, year, product_config)
        
        // Phase 2: Interest/credit calculation
        FOR EACH strategy IN state.allocations:
            IF scenario.type = "guaranteed":
                credit = strategy.get_guaranteed_rate()
            ELSE:
                credit = strategy.get_illustrated_rate()
            END IF
            strategy.account_value *= (1 + credit)
        END FOR
        
        state.total_account_value = SUM(strategy.account_value for all strategies)
        
        // Phase 3: Charge deductions
        state = deduct_annual_charges(state, product_config, scenario)
        state = deduct_rider_charges(state, product_config, scenario)
        
        // Phase 4: Rider processing
        FOR EACH rider IN state.active_riders:
            state = rider.process_year(state, year, scenario)
        END FOR
        
        // Phase 5: Withdrawal processing
        IF state.scheduled_withdrawals[year] > 0:
            state = process_withdrawal(state, year)
        END IF
        
        // Phase 6: End-of-year calculations
        state.surrender_value = calculate_surrender_value(state, year, product_config)
        state.death_benefit = calculate_death_benefit(state, year, product_config)
        
        // Phase 7: Tax calculations (if applicable)
        IF state.tax_qualification = "NQ":
            state.tax_impact = calculate_tax_impact(state, year)
        END IF
        
        results.append(state.snapshot())
    END FOR
    
    RETURN results
END FUNCTION
```

### 7.5 Cash Flow Modeling

Cash flow modeling is essential for income-focused illustrations. The engine must track:

```
┌────────────────────────────────────────────────────────────┐
│                  ANNUAL CASH FLOW MODEL                     │
│                                                            │
│  INFLOWS:                                                  │
│  ├── Premium payments                                      │
│  ├── Premium bonuses                                       │
│  ├── Interest/index credits                                │
│  └── Interest bonuses                                      │
│                                                            │
│  OUTFLOWS:                                                 │
│  ├── Rider charges                                         │
│  ├── Administrative fees                                   │
│  ├── Systematic withdrawals (income)                       │
│  ├── Ad hoc withdrawals                                    │
│  ├── Surrender charges (on withdrawals exceeding free %)   │
│  └── Tax withholding (if applicable)                       │
│                                                            │
│  NET CASH FLOW = INFLOWS - OUTFLOWS                        │
│  END-OF-YEAR AV = BEGINNING AV + NET CASH FLOW             │
└────────────────────────────────────────────────────────────┘
```

### 7.6 Tax Impact Modeling

Tax treatment varies significantly based on the qualification status of the annuity:

#### 7.6.1 Non-Qualified (NQ) Annuities

```
Taxation Rules:
- Earnings are tax-deferred until withdrawal
- Withdrawals follow LIFO (Last In, First Out) — earnings withdrawn first
- Earnings withdrawn before age 59½ subject to 10% penalty
- Gain = Account Value - Cost Basis (total premiums paid)

Tax on Withdrawal:
IF withdrawal_amount <= gain:
    taxable_amount = withdrawal_amount  // 100% taxable
ELSE:
    taxable_amount = gain  // Only gain portion is taxable
    return_of_premium = withdrawal_amount - gain  // Not taxable
END IF

tax_owed = taxable_amount × marginal_tax_rate
IF age < 59.5:
    penalty = taxable_amount × 0.10
END IF
```

#### 7.6.2 Qualified (IRA/401k) Annuities

```
Taxation Rules:
- All withdrawals are 100% taxable as ordinary income
- RMD (Required Minimum Distribution) rules apply at age 73+
- 10% early withdrawal penalty before age 59½

Tax on Withdrawal:
taxable_amount = withdrawal_amount  // 100% of withdrawal is taxable
tax_owed = taxable_amount × marginal_tax_rate
```

#### 7.6.3 Roth IRA Annuities

```
Taxation Rules:
- Qualified distributions are 100% tax-free (after age 59½ and 5-year holding)
- Non-qualified distributions: return of contributions first (tax-free), then earnings (taxable)
- No RMD requirement for Roth IRA
```

#### 7.6.4 Tax Impact in Illustration Output

```
Tax-Adjusted Illustration (Non-Qualified, 24% Tax Bracket)
Premium: $200,000 | Current Account Value: $250,000 | Gain: $50,000

Year | Age | Account  | Annual    | Taxable  | Tax      | Net After
     |     | Value    | Withdrawal| Amount   | (24%)    | Tax Income
─────┼─────┼──────────┼───────────┼──────────┼──────────┼──────────
 10  |  65 | 337,140  |  19,672   | 19,672   |  4,721   |  14,951
 11  |  66 | 337,489  |  19,672   | 19,672   |  4,721   |  14,951
 ...
 17  |  72 | 339,123  |  19,672   | 19,672   |  4,721   |  14,951
 18  |  73 | 339,467  |  19,672   |  6,532*  |  1,568   |  18,104
```

*After cumulative withdrawals exceed the gain, subsequent withdrawals are partially return of premium (non-taxable).

### 7.7 Comparison Illustrations

Comparison illustrations are increasingly important for best-interest compliance. The engine must support:

#### 7.7.1 Product vs. Product Comparison

```
Side-by-Side Product Comparison
Client: Age 55, $200,000 Single Premium, Income at Age 65

                    | Product A            | Product B
                    | (Carrier Alpha)      | (Carrier Beta)
────────────────────┼──────────────────────┼──────────────────────
Illustrated Rate    | 6.23%                | 5.98%
Premium Bonus       | 8%                   | 10%
Surrender Period    | 10 years             | 12 years
Rider Charge        | 1.00% of IBB         | 0.95% of AV
Roll-up Rate        | 7% compound          | 6.5% compound
Income % at 65      | 5.00%                | 5.25%
────────────────────┼──────────────────────┼──────────────────────
AV at Year 10       | $337,140             | $328,450
IBB at Year 10      | $393,431             | $380,613
Annual Income       | $19,672              | $19,982
Income by Age 85    | $413,504             | $419,017
Income by Age 90    | $511,863             | $518,855
Surr Value Year 5   | $256,424             | $242,190
Break-even Year     | Year 8               | Year 10
```

#### 7.7.2 Strategy vs. Strategy Comparison

```
Strategy Comparison Within Product
Product: FIA Accumulator Plus | Premium: $200,000

Strategy              | Illus Rate | AV Year 10 | AV Year 20
──────────────────────┼────────────┼────────────┼───────────
100% S&P 500 Ann PTP  | 6.23%      | $365,412   | $667,891
50/50 PTP + Fixed     | 4.62%      | $331,280   | $548,916
100% Monthly Sum Cap  | 5.87%      | $354,623   | $628,513
70/30 PTP + Fixed     | 5.26%      | $346,193   | $599,254
```

---

## 8. Illustration Data Requirements

### 8.1 Input Data Specification

The illustration engine requires a comprehensive set of input data to produce accurate projections. This section defines the complete data model.

#### 8.1.1 Client Demographics

```json
{
  "client": {
    "primary_owner": {
      "first_name": "string",
      "last_name": "string",
      "date_of_birth": "date (YYYY-MM-DD)",
      "age": "integer (calculated or provided)",
      "gender": "M | F | U",
      "state_of_residence": "string (2-char state code)",
      "tax_bracket": "decimal (optional, for tax-impact illustrations)",
      "smoker_status": "NS | SM (for mortality-related calculations)"
    },
    "joint_owner": {
      "first_name": "string (optional)",
      "last_name": "string (optional)",
      "date_of_birth": "date (optional)",
      "age": "integer (optional)",
      "gender": "M | F | U (optional)",
      "relationship": "spouse | other"
    },
    "annuitant": {
      "same_as_owner": "boolean",
      "first_name": "string (if different from owner)",
      "last_name": "string",
      "date_of_birth": "date",
      "age": "integer",
      "gender": "M | F | U"
    },
    "beneficiary": {
      "primary": [
        {
          "name": "string",
          "relationship": "string",
          "percentage": "decimal",
          "type": "individual | trust | estate | charity"
        }
      ],
      "contingent": []
    }
  }
}
```

#### 8.1.2 Premium and Product Selection

```json
{
  "premium": {
    "initial_premium": "decimal",
    "premium_type": "single | flexible | scheduled",
    "scheduled_premiums": [
      {
        "year": "integer",
        "amount": "decimal"
      }
    ],
    "premium_source": "new_money | 1035_exchange | ira_rollover | roth_conversion",
    "existing_basis": "decimal (for 1035 exchanges)",
    "existing_gain": "decimal (for 1035 exchanges)"
  },
  "product_selection": {
    "carrier_id": "string",
    "product_id": "string",
    "product_version": "string",
    "state_variation": "string (e.g., NY, CA, or standard)"
  },
  "tax_qualification": {
    "type": "NQ | IRA | Roth_IRA | 401k_rollover | 403b | SEP_IRA | SIMPLE_IRA",
    "existing_ira_value": "decimal (for RMD calculations)",
    "roth_conversion_year": "integer (optional)"
  }
}
```

#### 8.1.3 Strategy Allocation

```json
{
  "allocation": {
    "strategies": [
      {
        "strategy_id": "SP500-ANN-PTP-CAP",
        "allocation_percentage": 0.50,
        "allocation_amount": 100000
      },
      {
        "strategy_id": "FIXED-ACCOUNT",
        "allocation_percentage": 0.50,
        "allocation_amount": 100000
      }
    ],
    "rebalance_frequency": "none | annual | on_anniversary",
    "dollar_cost_averaging": {
      "enabled": false,
      "source_strategy": "FIXED-ACCOUNT",
      "target_strategies": [],
      "dca_period_months": 12
    }
  }
}
```

#### 8.1.4 Rider Selection

```json
{
  "riders": [
    {
      "rider_id": "GLWB-INCOME-PLUS",
      "rider_type": "GLWB",
      "elected": true,
      "income_start_age": 65,
      "life_type": "single | joint",
      "withdrawal_frequency": "annual | semi_annual | quarterly | monthly"
    },
    {
      "rider_id": "ENHANCED-DEATH-BENEFIT",
      "rider_type": "enhanced_db",
      "elected": false
    }
  ]
}
```

#### 8.1.5 Withdrawal Schedule

```json
{
  "withdrawals": {
    "systematic_withdrawals": {
      "start_year": 10,
      "start_age": 65,
      "type": "rider_income | fixed_amount | fixed_percentage | rmd",
      "amount": 0,
      "percentage": 0,
      "frequency": "annual | monthly",
      "increase_rate": 0.00,
      "end_year": null,
      "end_age": null
    },
    "ad_hoc_withdrawals": [
      {
        "year": 5,
        "amount": 10000,
        "reason": "free_withdrawal_test"
      }
    ]
  }
}
```

#### 8.1.6 Illustration Parameters

```json
{
  "illustration_parameters": {
    "illustration_type": "pre_sale | in_force | hypothetical",
    "projection_years": 45,
    "projection_end_age": 100,
    "scenarios": ["guaranteed", "non_guaranteed", "midpoint"],
    "include_historical_supplement": false,
    "include_tax_impact": true,
    "include_comparison": false,
    "comparison_product_id": null,
    "output_format": "pdf | web | json | all",
    "state_for_compliance": "CA",
    "agent": {
      "agent_id": "AGT-001234",
      "agent_name": "Jane Smith",
      "agency_name": "Smith Financial Group",
      "agent_license_state": "CA",
      "agent_license_number": "0A12345"
    }
  }
}
```

### 8.2 Output Data Specification

#### 8.2.1 Year-by-Year Projection Table (Ledger)

The ledger is the core output. Each row represents one contract year:

```json
{
  "ledger": {
    "metadata": {
      "illustration_id": "ILL-2024-001234",
      "generation_timestamp": "2024-03-15T14:30:00Z",
      "product_name": "FIA Accumulator Plus",
      "carrier_name": "Alpha Life Insurance Company",
      "product_version": "3.2",
      "ag49_rate_effective_date": "2024-01-01"
    },
    "scenarios": {
      "guaranteed": {
        "rows": [
          {
            "year": 1,
            "age": 56,
            "beginning_account_value": 200000.00,
            "premium_paid": 200000.00,
            "bonus_credited": 16000.00,
            "interest_credited": 2160.00,
            "rider_charge": 2314.00,
            "withdrawal": 0.00,
            "end_account_value": 215846.00,
            "surrender_charge_pct": 0.09,
            "surrender_value": 196420.00,
            "death_benefit": 216000.00,
            "income_benefit_base": 231120.00,
            "annual_income": 0.00,
            "cumulative_income": 0.00,
            "cumulative_premium": 200000.00,
            "internal_rate_of_return": -0.018
          }
        ]
      },
      "non_guaranteed": {
        "rows": [
          {
            "year": 1,
            "age": 56,
            "beginning_account_value": 200000.00,
            "premium_paid": 200000.00,
            "bonus_credited": 16000.00,
            "interest_credited": 13451.00,
            "rider_charge": 2314.00,
            "withdrawal": 0.00,
            "end_account_value": 227137.00,
            "surrender_charge_pct": 0.09,
            "surrender_value": 206695.00,
            "death_benefit": 227137.00,
            "income_benefit_base": 231120.00,
            "annual_income": 0.00,
            "cumulative_income": 0.00,
            "cumulative_premium": 200000.00,
            "internal_rate_of_return": 0.034
          }
        ]
      }
    }
  }
}
```

#### 8.2.2 Summary Values

```json
{
  "summary": {
    "guaranteed": {
      "account_value_year_5": 228412.00,
      "account_value_year_10": 257890.00,
      "account_value_year_20": 312456.00,
      "surrender_value_year_5": 216791.00,
      "surrender_value_year_10": 257890.00,
      "annual_income_at_65": 12345.00,
      "total_income_to_age_85": 246900.00,
      "total_income_to_age_90": 308625.00,
      "internal_rate_of_return_year_10": 0.0125,
      "internal_rate_of_return_year_20": 0.0098,
      "breakeven_year": 8
    },
    "non_guaranteed": {
      "account_value_year_5": 289014.00,
      "account_value_year_10": 387140.00,
      "account_value_year_20": 598234.00,
      "surrender_value_year_5": 274563.00,
      "surrender_value_year_10": 387140.00,
      "annual_income_at_65": 19672.00,
      "total_income_to_age_85": 413504.00,
      "total_income_to_age_90": 511863.00,
      "internal_rate_of_return_year_10": 0.0452,
      "internal_rate_of_return_year_20": 0.0518,
      "breakeven_year": 4
    }
  }
}
```

#### 8.2.3 Intermediate Calculation Data (Audit Trail)

For compliance and debugging, the engine should store intermediate calculations:

```json
{
  "audit_trail": {
    "ag49_rate_calculation": {
      "index": "SP500",
      "lookback_start_date": "1999-01-01",
      "lookback_end_date": "2023-12-31",
      "annual_returns": [0.2104, -0.091, -0.1189, ...],
      "applied_credits": [0.095, 0.0, 0.0, ...],
      "geometric_mean": 0.0623,
      "general_account_earned_rate": 0.045,
      "earned_rate_cap": 0.06525,
      "final_max_illustrated_rate": 0.0623,
      "benchmark_classification": "non_benchmark",
      "multiplier_adjustment": "none (AG49-B compliant)"
    },
    "year_by_year_calculations": [
      {
        "year": 1,
        "strategy_credits": [
          {"strategy_id": "SP500-ANN-PTP-CAP", "alloc_pct": 0.50, "credited_rate": 0.0623, "credited_amount": 6230.00},
          {"strategy_id": "FIXED-ACCOUNT", "alloc_pct": 0.50, "credited_rate": 0.030, "credited_amount": 3000.00}
        ],
        "blended_rate": 0.0462,
        "bonus_calculation": {"type": "premium", "percentage": 0.08, "amount": 16000.00, "vested_amount": 0.00},
        "rider_charge_calculation": {"basis": "income_benefit_base", "ibb": 231120.00, "rate": 0.01, "charge": 2311.20},
        "surrender_charge_calculation": {"year": 1, "rate": 0.09, "av": 227137.00, "charge": 20442.33}
      }
    ]
  }
}
```

### 8.3 Data Validation Rules

The illustration engine must enforce extensive input validation:

```
VALIDATION RULES:

1. Age Validation:
   - Issue age must be within product min/max issue age
   - If joint owner, both ages must be within rider eligibility
   - Annuitant age used for income calculations (may differ from owner)

2. Premium Validation:
   - Premium >= product minimum
   - Premium <= product maximum
   - For qualified plans: premium <= applicable IRS limits
   - For 1035 exchanges: existing basis must be provided

3. Allocation Validation:
   - Sum of allocation percentages must equal 100%
   - Each strategy allocation must be within strategy min/max
   - Dollar Cost Averaging validation: DCA source must be fixed account

4. Rider Validation:
   - Rider compatibility check (some riders are mutually exclusive)
   - Rider eligibility by age and premium
   - Income start age must be >= minimum allowed
   - Joint rider requires joint owner information

5. State Validation:
   - Product available in client's state
   - State-specific variations applied
   - Agent licensed in client's state

6. Withdrawal Validation:
   - Systematic withdrawals cannot exceed free withdrawal amount (warning)
   - Withdrawal start age reasonable for qualified plans (RMD considerations)
   - Total withdrawals cannot exceed account value (in guaranteed scenario, this triggers rider coverage)

7. Regulatory Validation:
   - AG49 compliance check on illustrated rates
   - State-specific illustration requirements satisfied
   - Illustration certification is current (not expired)
```

---

## 9. Illustration Generation Workflow

### 9.1 End-to-End Workflow

The illustration generation process spans multiple systems and stakeholders:

```
┌──────────┐    ┌──────────────┐    ┌──────────────┐    ┌──────────────┐
│  Agent/   │    │ Illustration │    │ Calculation  │    │   Output     │
│  Advisor  │    │   Platform   │    │   Engine     │    │  Generation  │
└────┬─────┘    └──────┬───────┘    └──────┬───────┘    └──────┬───────┘
     │                 │                    │                    │
     │  1. Login &     │                    │                    │
     │  select product │                    │                    │
     │────────────────▶│                    │                    │
     │                 │                    │                    │
     │  2. Enter       │                    │                    │
     │  client data    │                    │                    │
     │────────────────▶│                    │                    │
     │                 │                    │                    │
     │  3. Configure   │                    │                    │
     │  illustration   │                    │                    │
     │────────────────▶│                    │                    │
     │                 │  4. Validate &     │                    │
     │                 │  submit request    │                    │
     │                 │───────────────────▶│                    │
     │                 │                    │                    │
     │                 │                    │  5. Run projection │
     │                 │                    │  (guaranteed)      │
     │                 │                    │──────────┐         │
     │                 │                    │◀─────────┘         │
     │                 │                    │                    │
     │                 │                    │  6. Run projection │
     │                 │                    │  (non-guaranteed)  │
     │                 │                    │──────────┐         │
     │                 │                    │◀─────────┘         │
     │                 │                    │                    │
     │                 │  7. Return         │                    │
     │                 │  calculation       │                    │
     │                 │  results           │                    │
     │                 │◀──────────────────│                    │
     │                 │                    │                    │
     │                 │  8. Generate       │                    │
     │                 │  output            │                    │
     │                 │───────────────────────────────────────▶│
     │                 │                    │                    │
     │                 │                    │    9. PDF/Web      │
     │                 │◀───────────────────────────────────────│
     │                 │                    │                    │
     │  10. Preview &  │                    │                    │
     │  review         │                    │                    │
     │◀────────────────│                    │                    │
     │                 │                    │                    │
     │  11. Approve &  │                    │                    │
     │  sign           │                    │                    │
     │────────────────▶│                    │                    │
     │                 │                    │                    │
     │                 │  12. Store &       │                    │
     │                 │  track             │                    │
     │                 │──────────┐         │                    │
     │                 │◀─────────┘         │                    │
     │                 │                    │                    │
```

### 9.2 Illustration Parameter Entry

The user interface for illustration parameter entry must be designed for efficiency while ensuring all required data is captured:

**Step 1: Client Information**
```
┌─────────────────────────────────────────────────────────────┐
│                  Client Information                          │
│                                                             │
│  Owner Name:    [John Smith                              ]  │
│  Date of Birth: [03/15/1969]    Age: [55]                   │
│  Gender:        (•) Male  ( ) Female                        │
│  State:         [California ▼]                              │
│                                                             │
│  Joint Owner:   [ ] Yes  [•] No                             │
│  Annuitant:     [•] Same as Owner  [ ] Different            │
└─────────────────────────────────────────────────────────────┘
```

**Step 2: Product & Premium**
```
┌─────────────────────────────────────────────────────────────┐
│                  Product & Premium                           │
│                                                             │
│  Carrier:       [Alpha Life Insurance ▼]                    │
│  Product:       [FIA Accumulator Plus ▼]                    │
│  Premium:       [$200,000.00                             ]  │
│  Premium Type:  (•) Single Premium  ( ) Flexible            │
│  Tax Status:    [Non-Qualified ▼]                            │
│  Source:        (•) New Money  ( ) 1035 Exchange             │
│                 ( ) IRA Rollover  ( ) Roth Conversion        │
└─────────────────────────────────────────────────────────────┘
```

**Step 3: Strategy Allocation**
```
┌─────────────────────────────────────────────────────────────┐
│                  Strategy Allocation                         │
│                                                             │
│  Strategy                          | Alloc %  | Illus Rate  │
│  ──────────────────────────────────┼──────────┼──────────── │
│  S&P 500 Annual PTP Cap (9.50%)   | [50%]    | 6.23%       │
│  S&P 500 Monthly Sum Cap (2.50%)  | [25%]    | 5.87%       │
│  Fixed Account (3.00%)            | [25%]    | 3.00%       │
│  ──────────────────────────────────┼──────────┼──────────── │
│  TOTAL                            | 100%     | 5.33%       │
│                                                             │
│  [ ] Enable Dollar Cost Averaging                           │
└─────────────────────────────────────────────────────────────┘
```

**Step 4: Rider Selection**
```
┌─────────────────────────────────────────────────────────────┐
│                  Rider Selection                             │
│                                                             │
│  [✓] Income Plus GLWB Rider                                 │
│      Rider Charge: 1.00% of Income Benefit Base             │
│      Roll-up Rate: 7.00% Compound                           │
│      Income Start Age: [65]                                 │
│      Life Type: (•) Single  ( ) Joint                       │
│                                                             │
│  [ ] Enhanced Death Benefit Rider                           │
│      Rider Charge: 0.25% of Account Value                   │
│                                                             │
│  [ ] Nursing Home Waiver (Included at no charge)            │
└─────────────────────────────────────────────────────────────┘
```

**Step 5: Withdrawal Schedule**
```
┌─────────────────────────────────────────────────────────────┐
│                  Withdrawal Schedule                         │
│                                                             │
│  Systematic Withdrawals:                                    │
│  (•) Rider Income (GLWB Maximum)                            │
│  ( ) Fixed Amount: [$_________/year]                        │
│  ( ) Fixed Percentage: [____%/year]                         │
│  ( ) RMD (IRS Required Minimum Distribution)                │
│  ( ) None                                                   │
│                                                             │
│  Start Age/Year: [65] / [Year 10]                           │
│  Frequency: [Annual ▼]                                      │
│  Annual Increase: [0.00%]                                   │
│                                                             │
│  Ad Hoc Withdrawals:                                        │
│  Year [__] Amount [$_________] [+ Add]                      │
└─────────────────────────────────────────────────────────────┘
```

### 9.3 Calculation Processing

Once parameters are submitted, the calculation engine processes the illustration through these stages:

```
Stage 1: INPUT VALIDATION (< 100ms)
├── Validate all input fields
├── Check product availability for state
├── Verify rider eligibility
├── Validate allocation percentages
└── Return validation errors (if any)

Stage 2: PRODUCT CONFIGURATION LOAD (< 200ms)
├── Load product specification from repository
├── Load current AG49 rates
├── Load surrender charge schedule
├── Load rider specifications
└── Apply state-specific overrides

Stage 3: GUARANTEED SCENARIO PROJECTION (< 500ms)
├── Initialize state with guaranteed assumptions
├── Run multi-year projection loop
├── Calculate rider values (guaranteed)
├── Store guaranteed ledger
└── Calculate guaranteed summary values

Stage 4: NON-GUARANTEED SCENARIO PROJECTION (< 500ms)
├── Initialize state with current assumptions
├── Run multi-year projection loop
├── Calculate rider values (non-guaranteed)
├── Store non-guaranteed ledger
└── Calculate non-guaranteed summary values

Stage 5: SUPPLEMENTAL CALCULATIONS (< 300ms)
├── Calculate IRR for key years
├── Calculate breakeven year
├── Calculate tax impact (if requested)
├── Generate comparison data (if requested)
└── Calculate income gap analysis (if requested)

Stage 6: COMPLIANCE VALIDATION (< 200ms)
├── Verify illustrated rates within AG49 limits
├── Verify mandatory disclosures included
├── Verify state-specific requirements met
├── Log compliance check results
└── Generate compliance warnings (if any)

Total expected processing time: < 2 seconds
```

### 9.4 Output Formatting

#### 9.4.1 PDF Generation

PDF is the most common output format for annuity illustrations. The PDF must follow carrier-specific templates while complying with regulatory formatting requirements.

**PDF Structure (Typical 15-25 page document):**

```
Page 1:     Cover Page
            - Carrier logo and name
            - Product name
            - Client name and date
            - Agent name and license information
            - Illustration number

Page 2:     Important Notices and Disclosures
            - "This is an illustration, not a contract"
            - Guaranteed vs. non-guaranteed explanation
            - AG49 disclosure (for FIAs)
            - State-specific disclaimers

Page 3:     Illustration Summary
            - Client information
            - Product details
            - Premium and allocation summary
            - Rider summary
            - Key projected values at years 5, 10, 15, 20

Pages 4-8:  Non-Guaranteed Ledger
            - Year-by-year projection table
            - Columns: Year, Age, Premium, Interest/Credit,
              Account Value, Surrender Charge, Surrender Value,
              Death Benefit, Income Benefit Base, Annual Income,
              Cumulative Income

Pages 9-13: Guaranteed Ledger
            - Same structure as non-guaranteed but with
              guaranteed assumptions

Page 14:    Rider Detail Page
            - Income rider specifics
            - Income benefit base growth schedule
            - Income percentage table
            - Rider charge detail

Page 15:    Fee Summary
            - All charges and fees itemized
            - Surrender charge schedule
            - Rider charges
            - Annual fees (if any)

Page 16:    Supplemental Illustrations (if applicable)
            - Historical lookback results
            - Tax impact schedule
            - Comparison summary

Page 17:    Narrative Summary
            - Plain-language explanation of key features
            - Description of guaranteed vs. non-guaranteed elements
            - Risk factors and considerations

Page 18:    Signature Page
            - Client acknowledgment text
            - Client signature line and date
            - Agent signature line and date
            - Agent certification statement
```

**PDF generation technology considerations:**

| Technology | Pros | Cons | Typical Use |
|------------|------|------|-------------|
| **iText/OpenPDF** | Precise layout control, mature | Java-centric, licensing costs (iText) | Carrier-built systems |
| **Apache PDFBox** | Open source, Java | Lower-level API | Custom engines |
| **wkhtmltopdf** | HTML-to-PDF, flexible templates | Performance at scale, rendering inconsistencies | Rapid prototyping |
| **Puppeteer/Playwright** | Modern HTML rendering, CSS support | Resource-intensive, Node.js dependency | Web-first platforms |
| **Jasper Reports** | Template-based, WYSIWYG designer | Complex setup, Java-centric | Enterprise reporting |
| **DocRaptor/Prince** | Professional CSS-to-PDF, pixel-perfect | SaaS cost, external dependency | High-quality output |

#### 9.4.2 Interactive Web Display

Modern illustration platforms increasingly offer interactive web-based illustration viewers:

```
┌─────────────────────────────────────────────────────────────────┐
│  Interactive Illustration Viewer                                 │
│                                                                 │
│  ┌─────────────────────────────────────────────────────────┐    │
│  │                                                         │    │
│  │     [Line Chart: Account Value Over Time]               │    │
│  │                                                         │    │
│  │     ───── Non-Guaranteed (Current)                      │    │
│  │     - - - Guaranteed                                    │    │
│  │     ····· Income (if applicable)                        │    │
│  │                                                         │    │
│  └─────────────────────────────────────────────────────────┘    │
│                                                                 │
│  Scenario: [Non-Guaranteed ▼]  Year Range: [1] to [45]         │
│                                                                 │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │  Interactive Ledger Table (sortable, filterable)          │   │
│  │  Year | Age | AV      | SV      | DB      | Income      │   │
│  │  ─────┼─────┼─────────┼─────────┼─────────┼─────────    │   │
│  │    1  |  56 | 227,137 | 206,695 | 227,137 |       0     │   │
│  │    2  |  57 | 251,890 | 234,258 | 251,890 |       0     │   │
│  │   ... | ... | ...     | ...     | ...     |   ...       │   │
│  └──────────────────────────────────────────────────────────┘   │
│                                                                 │
│  [Download PDF]  [Email to Client]  [Save]  [Compare]           │
└─────────────────────────────────────────────────────────────────┘
```

### 9.5 Illustration Storage and Retrieval

Every generated illustration must be stored for compliance and retrieval purposes:

```json
{
  "illustration_record": {
    "illustration_id": "ILL-2024-001234",
    "illustration_number": "A2024-03-15-001234",
    "generation_timestamp": "2024-03-15T14:30:00Z",
    "status": "generated | presented | signed | archived | voided",
    "product_info": {
      "carrier_id": "ALPHA",
      "product_id": "FIA-2024-ACCUMULATOR-PLUS",
      "product_version": "3.2"
    },
    "client_info": {
      "client_id": "CLT-005678",
      "owner_name": "John Smith",
      "owner_age": 55,
      "state": "CA"
    },
    "agent_info": {
      "agent_id": "AGT-001234",
      "agent_name": "Jane Smith",
      "agency_id": "AGY-00567"
    },
    "input_parameters_hash": "sha256:abc123...",
    "input_parameters_blob": "{...full input JSON...}",
    "output_data": {
      "ledger_guaranteed_hash": "sha256:def456...",
      "ledger_nonguaranteed_hash": "sha256:ghi789...",
      "summary_values": "{...summary JSON...}"
    },
    "documents": {
      "pdf_url": "s3://illustrations/2024/03/ILL-2024-001234.pdf",
      "pdf_hash": "sha256:jkl012...",
      "signed_pdf_url": null
    },
    "compliance": {
      "ag49_compliant": true,
      "state_compliant": true,
      "certification_version": "CERT-2024-01",
      "compliance_warnings": [],
      "review_status": "auto_approved",
      "reviewer_id": null
    },
    "lifecycle": {
      "created_at": "2024-03-15T14:30:00Z",
      "presented_at": null,
      "signed_at": null,
      "application_number": null,
      "voided_at": null,
      "void_reason": null,
      "retention_expiry": "2034-03-15T14:30:00Z"
    }
  }
}
```

**Storage requirements:**

- **Retention period**: Most states require 5-10 years; many carriers retain for life of the policy plus 5-10 years
- **Immutability**: Once generated, an illustration cannot be modified — only voided and regenerated
- **Reproducibility**: The system must be able to recreate the exact same illustration from stored inputs (requiring version control of product configurations and rates)
- **Search and retrieval**: Must support lookup by illustration number, client name, agent ID, application number, date range, and product

### 9.6 Illustration Tracking and Compliance Reporting

The illustration platform must provide comprehensive tracking and reporting capabilities:

```
┌─────────────────────────────────────────────────────────────────┐
│  Illustration Activity Dashboard                                 │
│                                                                 │
│  Today's Illustrations:          142                            │
│  Pending Compliance Review:       12                            │
│  Signed/Completed:                89                            │
│  Voided:                           3                            │
│                                                                 │
│  Top Products Illustrated:                                      │
│  1. FIA Accumulator Plus          45 (31.7%)                    │
│  2. MYGA Select 5-Year            32 (22.5%)                    │
│  3. FIA Income Builder            28 (19.7%)                    │
│  4. VA Diversified Growth         21 (14.8%)                    │
│  5. Other                         16 (11.3%)                    │
│                                                                 │
│  Compliance Alerts:                                             │
│  ⚠ Agent AGT-002345: 5 illustrations without signed apps        │
│  ⚠ Product FIA-LEGACY-2022: Certification expiring in 15 days  │
│  ⚠ State NY: New disclosure requirement effective 04/01/2024    │
└─────────────────────────────────────────────────────────────────┘
```

**Key compliance reports:**

| Report | Purpose | Frequency |
|--------|---------|-----------|
| **Illustration-to-Application Ratio** | Track how many illustrations result in applications | Weekly |
| **Rate Compliance Report** | Verify all illustrations used compliant rates | Daily/Real-time |
| **Agent Activity Report** | Track illustration activity by agent | Monthly |
| **Product Illustration Volume** | Volume of illustrations by product | Monthly |
| **State Filing Report** | Track illustrations by state for regulatory reporting | Quarterly |
| **Unsigned Illustration Audit** | Identify illustrations presented but not signed | Weekly |
| **Replacement Analysis Report** | Track 1035 exchange and replacement illustrations | Monthly |

---

## 10. In-Force Illustrations

### 10.1 Purpose and Requirements

In-force illustrations serve existing policyholders by projecting future values based on the current state of their contract. They bridge the gap between what was projected at the point of sale and what has actually occurred.

**Key use cases:**

1. **Annual policy reviews**: Showing the client how their contract has performed and what to expect going forward
2. **Withdrawal planning**: Helping clients determine optimal withdrawal timing and amounts
3. **Replacement analysis**: Evaluating whether to replace the existing contract with a new one
4. **1035 exchange evaluation**: Comparing the existing contract's future projections with a new product
5. **Beneficiary planning**: Updating death benefit projections based on current values
6. **Rider evaluation**: Assessing whether income riders or other optional features are performing as expected

### 10.2 Actual-to-Illustrated Comparison

A critical feature of in-force illustrations is comparing actual performance to the original illustration:

```
In-Force Policy Review — Actual vs. Original Illustration
Policy Number: ANN-2019-00567 | Issue Date: 03/15/2019 | Current Date: 03/15/2024
Product: FIA Accumulator Plus | Issue Age: 50 | Current Age: 55
Original Premium: $200,000

Year | Age | Original     | Original     | ACTUAL       | Variance
     |     | Illustrated  | Guaranteed   | Account      | (Actual vs
     |     | AV           | AV           | Value        | Illustrated)
─────┼─────┼──────────────┼──────────────┼──────────────┼────────────
  1  |  51 |    212,460   |    202,000   |    208,340   |   -1.94%
  2  |  52 |    225,695   |    204,020   |    208,340   |   -7.69%
  3  |  53 |    239,752   |    206,060   |    222,891   |   -7.03%
  4  |  54 |    254,681   |    208,121   |    241,567   |   -5.15%
  5  |  55 |    270,534   |    210,202   |    256,423   |   -5.22%
```

**Forward projection from current values:**

```
Forward Projection from Current Values
Starting Account Value: $256,423 (Actual as of 03/15/2024)
Income Benefit Base: $280,511 (Actual as of 03/15/2024)

Year | Age | Non-Guar AV  | Guaranteed AV | Surr Value  | IBB       | Income
─────┼─────┼──────────────┼───────────────┼─────────────┼───────────┼────────
  6  |  56 |    272,398   |    258,987    |   264,826   |  300,147  |      0
  7  |  57 |    289,367   |    261,577    |   283,580   |  321,157  |      0
  8  |  58 |    307,385   |    264,193    |   304,311   |  343,638  |      0
  9  |  59 |    326,509   |    266,835    |   326,509   |  367,693  |      0
 10  |  60 |    346,800   |    269,503    |   346,800   |  393,431  |      0
 11  |  61 |    347,134   |    270,198    |   347,134   |  393,431  | 19,672
 ...
```

### 10.3 Policy Review Illustrations

A comprehensive policy review illustration includes:

1. **Policy snapshot**: Current account value, surrender value, death benefit, rider values
2. **Historical performance**: Actual credited rates and values since inception
3. **Forward projection**: Future values based on current assumptions
4. **Income analysis**: Projected income stream and how it compares to the original illustration
5. **Surrender analysis**: Current and projected surrender values, including penalty-free period timing
6. **Action items**: Recommendations based on the review (e.g., "Consider starting income withdrawals")

### 10.4 Replacement Analysis Illustrations

When a client is considering replacing an existing annuity with a new one, the illustration must show:

```
Replacement Analysis — Existing vs. Proposed
Client: John Smith, Age 65

                          | EXISTING CONTRACT    | PROPOSED CONTRACT
                          | (In-Force Values)    | (New Illustration)
──────────────────────────┼──────────────────────┼──────────────────────
Current Account Value     |    $256,423          |    N/A
Surrender Value Today     |    $256,423          |    N/A
Surrender Charge Remain.  |    0 years           |    10 years
Transfer Amount (1035)    |    $256,423          |    $256,423 (premium)
Cost Basis                |    $200,000          |    $200,000 (carries over)
──────────────────────────┼──────────────────────┼──────────────────────
Current Illustrated Rate  |    4.85%             |    6.23%
Income Benefit Base       |    $280,511          |    $256,423 + bonus
Annual Income at 65       |    $15,428           |    $18,456
──────────────────────────┼──────────────────────┼──────────────────────
AV Year 5                 |    $321,456          |    $345,890
AV Year 10                |    $398,234          |    $467,123
Income to Age 85          |    $308,560          |    $369,120
Income to Age 90          |    $385,700          |    $461,400
──────────────────────────┼──────────────────────┼──────────────────────
Break-even Year           |    N/A               |    Year 4
Cumulative Income Adv.    |    N/A               |    $60,560 by age 85
```

### 10.5 1035 Exchange Comparison Illustrations

A 1035 exchange is a tax-free transfer from one annuity to another. The illustration system must handle the unique aspects of 1035 exchanges:

**Tax basis carryover**: The cost basis from the existing contract carries over to the new contract:

```
1035 Exchange Tax Analysis:
Existing Contract:
  Account Value:   $256,423
  Cost Basis:      $200,000
  Gain:            $56,423

New Contract (1035 Exchange):
  Premium:         $256,423
  Cost Basis:      $200,000  (carried over from existing)
  Gain at Issue:   $56,423   (carried over from existing)
```

**Surrender charge reset warning**: The illustration must prominently disclose that the client will enter a new surrender charge period:

```
⚠ IMPORTANT DISCLOSURE:
By completing this 1035 exchange, you will be subject to a NEW
surrender charge schedule. Your current contract has $0 in surrender
charges. The proposed contract has the following schedule:
Year:  1    2    3    4    5    6    7    8    9   10
Rate:  9%   9%   8%   7%   6%   5%   4%   3%   2%   1%
```

### 10.6 In-Force Illustration Architecture

In-force illustrations require integration with the policy administration system:

```
┌──────────────────┐     ┌───────────────────┐     ┌──────────────────┐
│  Policy Admin    │     │  In-Force          │     │  Illustration    │
│  System          │     │  Illustration      │     │  Engine          │
│                  │     │  Service           │     │                  │
│  - Current AV    │     │                    │     │                  │
│  - Current CSV   │     │  1. Fetch policy   │     │                  │
│  - Current IBB   │────▶│     data           │     │                  │
│  - History       │     │                    │     │                  │
│  - Rider values  │     │  2. Transform to   │     │                  │
│  - Credited rates│     │     illustration   │────▶│  3. Project from │
│  - Withdrawals   │     │     input format   │     │     current      │
│                  │     │                    │     │     values        │
│                  │     │  4. Merge with     │◀────│                  │
│                  │     │     history        │     │  5. Return       │
│                  │     │                    │     │     projections   │
│                  │     │  6. Generate       │     │                  │
│                  │     │     output         │     │                  │
│                  │     │                    │     │                  │
└──────────────────┘     └───────────────────┘     └──────────────────┘
```

**Key data mapping challenges:**

- Policy admin systems store data in formats optimized for administration, not illustration
- Fund values, rider values, and credited rate histories must be extracted and transformed
- Historical credited rates may not map directly to illustration engine assumptions
- In-force values must be reconciled before projection (any mismatch must be flagged)

---

## 11. Illustration Technology Stack

### 11.1 Illustration Platforms Overview

The annuity illustration technology landscape includes carrier-built systems, third-party platforms, and industry utilities:

#### 11.1.1 iPipeline (Now Roper Technologies / ISGN)

**Overview**: iPipeline is one of the largest insurance technology platforms, providing illustration tools across life, annuity, and long-term care products.

**Key products**:
- **Illustration Engine**: Multi-carrier illustration calculation engine
- **iGO e-App**: Electronic application integrated with illustrations
- **LifePipe**: Distribution platform connecting carriers to distributors

**Architecture**:
- Cloud-hosted SaaS platform
- API-based integration with carrier and distributor systems
- Supports embedded illustration within distributor portals
- PDF and web-based output

**Strengths**: Broad carrier coverage, integrated e-app, established distribution network
**Limitations**: Legacy architecture in some components, customization limits

#### 11.1.2 Ebix/Annuity.net (Now rebranded)

**Overview**: Annuity.net is a multi-carrier annuity illustration and comparison platform used by independent distributors.

**Key capabilities**:
- Multi-carrier illustration comparison
- Side-by-side product comparison
- Agent-facing web portal
- Compliance workflow integration

**Architecture**:
- Web-based platform
- Carrier-provided calculation engines (in many cases)
- Standardized input/output interfaces
- Integration with distributor CRM and order entry systems

#### 11.1.3 CANNEX

**Overview**: CANNEX is a financial technology firm providing annuity pricing, illustration, and comparison data. It's particularly strong in income annuity (SPIA/DIA) and MYGA comparison.

**Key capabilities**:
- Real-time annuity rate aggregation (SPIA, DIA, MYGA, FIA income)
- API-based access to illustration data
- Multi-carrier comparison engine
- Income analysis tools

**Architecture**:
- RESTful API-first design
- Carrier data feeds (daily rate updates)
- Calculation engine for standardized comparisons
- Embeddable widgets for distributor platforms

**CANNEX API example (simplified)**:

```
GET /api/v2/annuity/quotes
?product_type=SPIA
&premium=200000
&owner_age=65
&owner_gender=M
&state=CA
&payout_type=life_only
&start_type=immediate

Response:
{
  "quotes": [
    {
      "carrier": "Alpha Life",
      "product": "Immediate Income Annuity",
      "monthly_income": 1234.56,
      "annual_income": 14814.72,
      "am_best_rating": "A+",
      "payout_rate": 7.41%
    },
    ...
  ]
}
```

#### 11.1.4 Carrier-Built Illustration Systems

Many large carriers build their own illustration systems:

**Advantages of carrier-built:**
- Full control over product configuration and calculation logic
- Deep integration with carrier admin systems
- Ability to implement complex product features immediately
- No dependency on third-party platform timelines

**Disadvantages of carrier-built:**
- High development and maintenance cost
- Must independently maintain regulatory compliance
- Limited multi-carrier comparison capability
- Agent training overhead for each carrier's unique system

**Common carrier-built architecture:**

```
┌─────────────────────────────────────────────────────────────────┐
│  Carrier Illustration System                                     │
│                                                                 │
│  ┌───────────────┐  ┌───────────────┐  ┌─────────────────────┐  │
│  │  Angular/React │  │  .NET/Java    │  │  SQL Server /       │  │
│  │  Front-End     │  │  API Layer    │  │  Oracle Database     │  │
│  └───────┬───────┘  └───────┬───────┘  └──────────┬──────────┘  │
│          │                  │                      │             │
│          │           ┌──────┴────────┐             │             │
│          │           │  Calculation  │             │             │
│          └──────────▶│  Engine       │◀────────────┘             │
│                      │  (C#/Java)    │                           │
│                      └──────┬────────┘                           │
│                             │                                    │
│                      ┌──────┴────────┐                           │
│                      │  PDF          │                           │
│                      │  Generator    │                           │
│                      └───────────────┘                           │
└─────────────────────────────────────────────────────────────────┘
```

### 11.2 PDF Generation Engines

PDF generation is a critical component of any illustration system. The choice of PDF engine significantly impacts output quality, performance, and maintainability.

**Template-based approach (recommended for most implementations):**

```
┌─────────────────────────────────────────────────────────┐
│  Template-Based PDF Generation Pipeline                  │
│                                                         │
│  1. Data Model      2. Template Engine    3. PDF Output  │
│  ┌──────────┐       ┌──────────────┐     ┌───────────┐  │
│  │ Ledger   │       │ HTML/CSS     │     │ PDF       │  │
│  │ Data     │──────▶│ Templates    │────▶│ Renderer  │  │
│  │ (JSON)   │       │ (Handlebars/ │     │ (Puppeteer│  │
│  │          │       │  Thymeleaf/  │     │  /Prince/ │  │
│  │          │       │  Razor)      │     │  wkhtmlto │  │
│  └──────────┘       └──────────────┘     │  pdf)     │  │
│                                          └───────────┘  │
│                                                         │
│  Benefits:                                              │
│  - Templates are maintainable by non-developers         │
│  - CSS controls styling and layout                      │
│  - State-specific templates easily managed               │
│  - Rapid iteration on design changes                    │
└─────────────────────────────────────────────────────────┘
```

**Direct PDF composition approach (for highest performance and precision):**

```
┌─────────────────────────────────────────────────────────┐
│  Direct PDF Composition Pipeline                         │
│                                                         │
│  1. Data Model      2. Layout Engine     3. PDF Writer   │
│  ┌──────────┐       ┌──────────────┐     ┌───────────┐  │
│  │ Ledger   │       │ Programmatic │     │ iText /   │  │
│  │ Data     │──────▶│ Layout       │────▶│ PDFBox    │  │
│  │ (Objects)│       │ (Code-based  │     │ Direct    │  │
│  │          │       │  positioning)│     │ Output    │  │
│  └──────────┘       └──────────────┘     └───────────┘  │
│                                                         │
│  Benefits:                                              │
│  - Pixel-perfect control                                │
│  - Highest performance (no rendering engine overhead)   │
│  - Smallest file sizes                                  │
│  - Best for high-volume batch generation                │
└─────────────────────────────────────────────────────────┘
```

### 11.3 Interactive Web-Based Illustrators

Modern illustration platforms are shifting toward interactive web experiences:

**Technology stack for web-based illustrations:**

| Layer | Technology Options | Purpose |
|-------|-------------------|---------|
| **Front-end framework** | React, Angular, Vue.js | Interactive UI for parameter entry and result display |
| **Charting library** | D3.js, Highcharts, Chart.js, Recharts | Visualization of projection data |
| **Table library** | AG Grid, Handsontable, TanStack Table | Interactive ledger display with sorting and filtering |
| **State management** | Redux, MobX, Zustand | Managing complex illustration state |
| **API layer** | REST or GraphQL | Communication with calculation engine |
| **Real-time updates** | WebSockets, Server-Sent Events | Live recalculation as parameters change |

**Interactive features that enhance the illustration experience:**

1. **Slider-based parameter adjustment**: Change premium, income start age, or allocation and see results update in real time
2. **What-if scenarios**: Toggle scenarios on/off on the same chart to compare
3. **Drill-down tables**: Click on any year to see detailed calculations
4. **Income gap analysis overlay**: Show Social Security and other income sources alongside annuity income
5. **Print-optimized views**: CSS print styles that produce compliant PDF-like output from the web view
6. **Responsive design**: Illustrations viewable on tablet devices for in-person client meetings

### 11.4 Mobile Illustration Tools

Mobile illustration capabilities are essential for field agents:

**Mobile-specific considerations:**

- **Offline capability**: Agents need to generate illustrations in locations without reliable internet. This requires local calculation engines and cached product configurations.
- **Touch-optimized input**: Larger touch targets, swipe navigation between illustration sections
- **Simplified parameter entry**: Quick-entry modes with common defaults
- **E-signature integration**: Capture client signatures directly on the mobile device
- **Sync and upload**: Illustrations generated offline must sync to the central platform when connectivity is restored

**Mobile architecture:**

```
┌────────────────────────────────────────────────────────────┐
│  Mobile Illustration App                                    │
│                                                            │
│  ┌─────────────────┐   ┌────────────────────────────────┐  │
│  │  Native UI       │   │  Local Calculation Engine       │  │
│  │  (iOS/Android)   │   │  (embedded, offline-capable)    │  │
│  │  OR              │   │                                │  │
│  │  React Native /  │   │  Product configs cached        │  │
│  │  Flutter         │   │  locally                        │  │
│  └────────┬────────┘   └─────────────┬──────────────────┘  │
│           │                          │                      │
│           ▼                          ▼                      │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  Local Storage (SQLite / Realm)                      │   │
│  │  - Product configurations (synced periodically)      │   │
│  │  - Generated illustrations (pending sync)            │   │
│  │  - Client data (encrypted)                           │   │
│  └──────────────────────┬──────────────────────────────┘   │
│                         │                                   │
│                         ▼                                   │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  Sync Service                                        │   │
│  │  - Upload completed illustrations                    │   │
│  │  - Download product config updates                   │   │
│  │  - Download AG49 rate updates                        │   │
│  │  - Conflict resolution                               │   │
│  └─────────────────────────────────────────────────────┘   │
└────────────────────────────────────────────────────────────┘
```

### 11.5 API-Driven Illustration Services

The industry is moving toward API-first illustration architectures that allow carriers and distributors to embed illustration capabilities in any application:

**REST API design for illustration services:**

```
POST /api/v1/illustrations
    Body: { illustration_request }
    Response: { illustration_id, status, result_data }

GET /api/v1/illustrations/{id}
    Response: { illustration_record }

GET /api/v1/illustrations/{id}/pdf
    Response: application/pdf binary

GET /api/v1/illustrations/{id}/ledger
    Query: scenario=guaranteed|non_guaranteed
    Response: { ledger_rows[] }

POST /api/v1/illustrations/{id}/compare
    Body: { comparison_illustration_id }
    Response: { comparison_data }

GET /api/v1/products
    Query: carrier_id, product_type, state
    Response: { products[] }

GET /api/v1/products/{id}/strategies
    Response: { strategies[] with current rates and AG49 limits }

POST /api/v1/illustrations/batch
    Body: { illustration_requests[] }
    Response: { batch_id, status }

GET /api/v1/illustrations/batch/{batch_id}
    Response: { results[] }
```

**API authentication and authorization:**

```
Authorization model:
- Carrier admin: Full access to all illustrations for their products
- Distributor admin: Access to illustrations generated by their agents
- Agent: Access only to illustrations they generated
- Compliance officer: Read-only access to all illustrations for audit
- API integration: Service account with scoped permissions

Authentication:
- OAuth 2.0 with JWT tokens
- API key + secret for service-to-service
- MFA required for compliance and admin roles
```

---

## 12. Illustration Compliance

### 12.1 Illustration Review and Approval Workflow

Depending on the carrier and distribution channel, illustrations may require review before they can be presented to clients:

```
┌──────────┐     ┌───────────┐     ┌──────────────┐     ┌──────────────┐
│  Agent    │     │ Auto-     │     │  Compliance  │     │  Approved    │
│  Creates  │────▶│ Screening │────▶│  Manual      │────▶│  for         │
│  Illus    │     │  Rules    │     │  Review      │     │  Presentation│
└──────────┘     └─────┬─────┘     └──────┬───────┘     └──────────────┘
                       │                   │
                       │  PASS             │  PASS
                       │  (auto-approve)   │  (manual approve)
                       │                   │
                       │  FAIL             │  FAIL
                       ▼                   ▼
                 ┌───────────┐     ┌──────────────┐
                 │  Flagged  │     │  Rejected    │
                 │  for      │     │  (agent must │
                 │  Review   │     │   revise)    │
                 └───────────┘     └──────────────┘
```

**Auto-screening rules (examples):**

```
Rule 1: RATE_COMPLIANCE
  IF illustrated_rate > AG49_maximum_rate THEN REJECT
  
Rule 2: PREMIUM_SUITABILITY
  IF premium > client_liquid_net_worth × 0.50 THEN FLAG_FOR_REVIEW

Rule 3: SURRENDER_PERIOD_AGE
  IF client_age + surrender_period > 75 THEN FLAG_FOR_REVIEW

Rule 4: REPLACEMENT_DETECTION
  IF premium_source = "1035_exchange" THEN FLAG_FOR_REVIEW

Rule 5: HIGH_VALUE
  IF premium > 500000 THEN FLAG_FOR_REVIEW

Rule 6: SENIOR_CLIENT
  IF client_age >= 65 THEN APPLY_SENIOR_REVIEW_RULES

Rule 7: INCOME_START_DELAY
  IF income_start_age - client_age > 15 THEN FLAG_FOR_REVIEW
  (Long deferral may not be suitable)

Rule 8: BONUS_RECAPTURE
  IF product_has_bonus AND illustration_shows_surrender_before_vesting
  THEN ADD_WARNING_DISCLOSURE
```

### 12.2 Illustration Filing with States

Some states require that illustration formats and/or specific illustrations be filed with the state insurance department:

| Filing Requirement | Description |
|-------------------|-------------|
| **Format filing** | The carrier must file the illustration format (template) with the state before it can be used. The state may approve, reject, or require modifications. |
| **Material filing** | Some states require that illustration software or calculation methodologies be filed for review. |
| **Replacement filing** | Illustrations used in replacement transactions may need to be filed with the state along with replacement forms. |
| **Annual certification** | Some states require annual certification that illustration software produces compliant output. |

**State filing management in the system:**

```json
{
  "state_filing_record": {
    "filing_id": "FIL-2024-001234",
    "state": "TX",
    "filing_type": "illustration_format",
    "product_id": "FIA-2024-ACCUMULATOR-PLUS",
    "submitted_date": "2024-01-15",
    "filing_status": "approved",
    "approval_date": "2024-02-10",
    "effective_date": "2024-03-01",
    "expiration_date": "2025-03-01",
    "filing_documents": [
      "illustration_template_v3.2.pdf",
      "calculation_methodology.pdf",
      "actuarial_certification.pdf"
    ],
    "conditions": [
      "Must include Texas-specific disclosure on page 2",
      "Must use 14pt font minimum for guaranteed/non-guaranteed headers"
    ]
  }
}
```

### 12.3 Illustration Audit Trail

Every illustration system must maintain a comprehensive audit trail for regulatory examinations:

```
Audit Trail Event Types:

1. ILLUSTRATION_GENERATED
   - Timestamp, user ID, input parameters, product version
   
2. ILLUSTRATION_VIEWED
   - Timestamp, user ID, view type (screen/PDF)
   
3. ILLUSTRATION_MODIFIED
   - N/A (illustrations are immutable — new illustration generated)
   
4. ILLUSTRATION_PRESENTED
   - Timestamp, presentation method (in-person, email, web portal)
   
5. ILLUSTRATION_SIGNED
   - Timestamp, signer identity, signature method (wet/e-sign)
   
6. ILLUSTRATION_ATTACHED_TO_APP
   - Timestamp, application number, attachment method
   
7. ILLUSTRATION_VOIDED
   - Timestamp, user ID, reason code, replacement illustration ID
   
8. ILLUSTRATION_COMPLIANCE_REVIEWED
   - Timestamp, reviewer ID, review result, notes
   
9. PRODUCT_CONFIG_UPDATED
   - Timestamp, old version, new version, change description
   
10. AG49_RATES_UPDATED
    - Timestamp, old rates, new rates, certification reference
```

**Audit trail storage requirements:**

- Immutable append-only log
- Minimum 10-year retention (most carriers retain indefinitely)
- Tamper-proof (hash-chaining or blockchain-like integrity)
- Queryable by illustration ID, agent ID, client, date range, event type

### 12.4 Advertisement vs. Illustration Distinction

This distinction is critical for compliance and has system design implications:

| Characteristic | Advertisement | Illustration |
|---------------|---------------|--------------|
| **Audience** | General public | Specific individual |
| **Personalization** | Generic or hypothetical | Based on actual client data |
| **Regulation** | NAIC Model #570 (Advertisements) | NAIC Model #245 (Disclosure) |
| **Approval** | Must be pre-approved by compliance | May be auto-approved or post-reviewed |
| **Distribution** | Mass media, websites, mailers | One-to-one agent-to-client |
| **Content** | May show product features, sample rates | Must show personalized projections |
| **Filing** | Must be filed with state (in most states) | Format filed; individual illustrations generally not filed |

**System implications:**

- The illustration system must clearly distinguish between advertisements and illustrations in its output
- Content that combines advertising material with illustration data (proposals) must comply with both sets of rules
- A document that includes personalized projections is an illustration, regardless of what it's called

### 12.5 Social Media and Digital Illustration Rules

The increasing use of digital channels creates new compliance challenges:

**Rules for digital illustration sharing:**

1. **Email delivery**: Illustrations sent via email must be secure (encrypted) and the email itself must not contain illustration data in the body — only as a secure attachment or link
2. **Web portal sharing**: Illustrations shared via web portals must be behind authenticated access
3. **Social media**: FINRA and state regulations generally prohibit sharing personalized illustrations on social media platforms. Generic product information is permitted with appropriate disclaimers
4. **Screen sharing**: Illustrations presented via video conference/screen sharing are treated the same as in-person presentations — the compliance requirements are identical
5. **Text/messaging**: Illustration data should never be shared via text message or messaging apps
6. **Client portals**: In-force illustrations displayed on client-facing portals must include all required disclosures

---

## 13. Advanced Illustration Features

### 13.1 Monte Carlo Simulation

Monte Carlo simulation provides a probabilistic view of future outcomes by running thousands of random return scenarios, rather than the single deterministic scenario used in standard illustrations.

#### 13.1.1 Methodology

```
Monte Carlo Simulation for Annuity Illustration:

1. DEFINE return distribution parameters:
   - Expected return (mean): μ
   - Volatility (standard deviation): σ
   - Distribution type: normal, lognormal, or historical bootstrap

2. FOR simulation = 1 TO num_simulations (typically 10,000):
   FOR year = 1 TO projection_years:
       // Generate random return
       random_return = generate_random(distribution, μ, σ)
       
       // Apply to annuity crediting mechanism
       IF product_type = "FIA":
           // Apply cap, floor, par rate to random return
           index_credit = apply_crediting_mechanism(random_return, params)
       ELSE IF product_type = "VA":
           // Apply random return directly (minus fees)
           net_return = random_return - total_fees
       END IF
       
       // Update account value
       account_value = project_one_year(account_value, index_credit, ...)
   END FOR
   
   // Store simulation result
   results[simulation] = {final_av, final_income, etc.}
   END FOR

3. ANALYZE results:
   - Sort results by final account value
   - Calculate percentiles: 5th, 10th, 25th, 50th, 75th, 90th, 95th
   - Calculate probability of specific outcomes (e.g., P(income lasts to age 90))
   - Calculate expected value (mean of all simulations)
```

#### 13.1.2 Monte Carlo Output Visualization

```
Monte Carlo Simulation Results — FIA Accumulator Plus
Premium: $200,000 | 10,000 Simulations | 30-Year Horizon

Percentile | AV Year 10 | AV Year 20 | AV Year 30 | Income to 85
───────────┼────────────┼────────────┼────────────┼─────────────
   95th    |   $412,345 |   $698,234 | $1,189,567 |    $623,450
   75th    |   $356,789 |   $534,567 |    $812,345 |    $498,234
   50th    |   $312,456 |   $423,789 |    $589,012 |    $402,567
   25th    |   $271,234 |   $334,567 |    $412,345 |    $312,890
    5th    |   $228,901 |   $242,345 |    $267,890 |    $212,456

Probability of Income Lasting to:
  Age 85:   94.3%
  Age 90:   87.6%
  Age 95:   78.2%
  Age 100:  65.4%

Probability of Account Depletion Before Age 85:  5.7%
```

#### 13.1.3 Monte Carlo Implementation Considerations

**Performance**: 10,000 simulations × 30 years × multiple strategies = millions of calculations. Optimization strategies:

- **Vectorized computation**: Use NumPy/BLAS for matrix-based calculations instead of nested loops
- **Parallel processing**: Distribute simulations across CPU cores or GPU
- **Pre-computed scenarios**: Cache common scenario sets for reuse
- **Variance reduction techniques**: Antithetic variates, stratified sampling to reduce required simulation count
- **Progressive rendering**: Show preliminary results after 1,000 simulations, refine with more

**Correlation handling**: When simulating multiple indices simultaneously:

```
Multi-Index Correlation Matrix:
             | S&P 500 | NASDAQ | Russell | Bonds
─────────────┼─────────┼────────┼─────────┼──────
S&P 500      |  1.00   |  0.89  |  0.92   | -0.15
NASDAQ       |  0.89   |  1.00  |  0.85   | -0.20
Russell 2000 |  0.92   |  0.85  |  1.00   | -0.10
Bonds        | -0.15   | -0.20  | -0.10   |  1.00

Use Cholesky decomposition to generate correlated random returns:
L = cholesky(correlation_matrix)
correlated_returns = L × independent_random_returns
```

### 13.2 Stochastic Modeling for VA Guarantees

Stochastic modeling is critical for accurately assessing the cost and value of VA guaranteed living benefits. While standard illustrations use flat rate assumptions, stochastic models capture the impact of return volatility and sequence-of-returns risk.

#### 13.2.1 Risk-Neutral vs. Real-World Scenarios

| Scenario Type | Purpose | Usage |
|--------------|---------|-------|
| **Risk-Neutral** | Pricing and reserving of guarantees | Actuarial/finance — not shown to consumers |
| **Real-World** | Realistic projection of future outcomes | Consumer-facing Monte Carlo illustrations |

#### 13.2.2 Stochastic Scenario Generation

The American Academy of Actuaries prescribes stochastic scenario generators for VA reserve calculations. For illustration purposes, simplified generators are acceptable:

**Geometric Brownian Motion (GBM):**

```
S(t+1) = S(t) × exp[(μ - σ²/2)Δt + σ√(Δt) × Z]

Where:
  S(t) = index value at time t
  μ = expected return (drift)
  σ = volatility
  Δt = time step (1 year for annual illustration)
  Z = standard normal random variable
```

**Regime-switching model (for more realistic simulations):**

```
Two-regime model:
Regime 1 (Bull): μ₁ = 12%, σ₁ = 15%
Regime 2 (Bear): μ₂ = -5%, σ₂ = 25%

Transition probabilities:
P(Bull→Bull) = 0.90,  P(Bull→Bear) = 0.10
P(Bear→Bear) = 0.75,  P(Bear→Bull) = 0.25
```

#### 13.2.3 GLWB Value-at-Risk Analysis

Stochastic modeling reveals the conditions under which GLWB guarantees become valuable:

```
GLWB Guarantee Analysis:
10,000 stochastic scenarios, 30-year projection

Scenario Outcomes:
- Guarantee never triggered (AV > 0 throughout):        7,234 (72.3%)
- Guarantee triggered briefly (AV = 0 for < 5 years):     1,456 (14.6%)
- Guarantee provides significant benefit (AV = 0, 5+ yrs):  1,310 (13.1%)

Expected Guarantee Value: $34,567
Expected Rider Charges Paid: $28,901
Net Expected Benefit: $5,666

Breakeven Probability (Guarantee Value > Charges): 38.2%
```

### 13.3 Income Gap Analysis

Income gap analysis is a holistic planning tool that integrates annuity illustration with the client's overall retirement income picture:

```
Income Gap Analysis — Client: John Smith, Age 55, Retirement at 65

Income Sources:                  | Monthly   | Annual    | Start Age | End
─────────────────────────────────┼───────────┼───────────┼───────────┼─────
Social Security (estimated)      | $2,861    | $34,332   |    67     | Life
Pension                          | $1,500    | $18,000   |    65     | Life
401(k) Systematic Withdrawal    | $2,000    | $24,000   |    65     |  90
Part-time Income                 | $1,500    | $18,000   |    65     |  70
─────────────────────────────────┼───────────┼───────────┼───────────┼─────
Total Income (at age 67)        | $7,861    | $94,332   |           |
─────────────────────────────────┼───────────┼───────────┼───────────┼─────
Retirement Income Need           | $8,500    | $102,000  |    65     | Life
─────────────────────────────────┼───────────┼───────────┼───────────┼─────
INCOME GAP (at age 67)          | ($639)    | ($7,668)  |           |
INCOME GAP (at age 71, no PT)   | ($2,139)  | ($25,668) |           |

Annuity Solution:
FIA with GLWB Rider
Premium: $200,000 (from savings)
Income at Age 65: $19,672/year ($1,639/month)

Revised Income (with annuity):
At age 65: $7,861 + $1,639 = $9,500/month (SURPLUS: $1,000/month)
At age 71: $6,361 + $1,639 = $8,000/month (SURPLUS: ($500)/month — minor gap)
At age 90: $4,361 + $1,639 = $6,000/month (GAP: ($2,500)/month — consider inflation)
```

### 13.4 Social Security Optimization Integration

Advanced illustration platforms integrate Social Security claiming optimization with annuity illustrations:

```
Social Security Claiming Strategy Comparison:

Strategy 1: Claim at 62                Strategy 2: Claim at 67 (FRA)
Monthly: $2,147                        Monthly: $3,068
Annual:  $25,764                       Annual:  $36,816
                                       
Strategy 3: Claim at 70                Strategy 4: Delay to 70 + Annuity Bridge
Monthly: $3,804                        Monthly: $3,804 (starting at 70)
Annual:  $45,648                       Annuity bridge income age 65-70:
                                       $20,000/year from FIA GLWB

Breakeven Analysis:
Claim 62 vs 67: Breakeven at age 78
Claim 62 vs 70: Breakeven at age 80
Strategy 4 NPV advantage: $45,234 (assuming 3% discount rate, age 90 horizon)
```

The illustration system can model the "bridge strategy" where annuity income fills the gap between retirement and optimal Social Security claiming age.

### 13.5 Tax Planning Integration

#### 13.5.1 Tax Bracket Management

```
Tax-Efficient Withdrawal Strategy Illustration:

Client: Age 65 | Filing: Married Filing Jointly | 2024 Tax Brackets
Retirement Assets:
  - 401(k)/IRA: $800,000
  - Roth IRA: $200,000
  - Non-Qualified Annuity: $300,000 (basis: $200,000)
  - Taxable Brokerage: $500,000
  - Social Security: $36,816/year

Annual Income Need: $100,000

Tax-Optimized Withdrawal Sequence:
Year | SS Income | IRA WD   | Annuity WD | Roth WD | Taxable | Total    | Eff Tax
─────┼───────────┼──────────┼────────────┼─────────┼─────────┼──────────┼────────
  1  | $36,816   | $25,000  | $20,000    | $0      | $18,184 | $100,000 | 12.8%
  2  | $36,816   | $25,000  | $20,000    | $0      | $18,184 | $100,000 | 12.8%
  ...
  8  | $36,816   | $25,000  | $20,000    | $0      | $18,184 | $100,000 | 11.2%*
  9  | $36,816   | $38,184  | $0**       | $25,000 | $0      | $100,000 | 14.1%
 ...
```

*Lower rate because annuity gain has been exhausted — withdrawals are now return of premium (non-taxable)

**Annuity depleted — switch to Roth to manage bracket

#### 13.5.2 Roth Conversion Analysis

```
Roth Conversion Illustration:
Scenario: Convert $50,000/year from IRA to Roth IRA during ages 65-69 (before RMD)

Year | Age | IRA     | Convert  | Tax on   | Roth    | Total    | Tax
     |     | Balance | to Roth  | Convert  | Balance | Wealth   | Savings
─────┼─────┼─────────┼──────────┼──────────┼─────────┼──────────┼────────
  1  |  65 | 750,000 | 50,000   | 11,000   | 50,000  | 800,000  |
  2  |  66 | 735,000 | 50,000   | 11,000   | 103,000 | 838,000  |
  3  |  67 | 719,250 | 50,000   | 11,000   | 159,180 | 878,430  |
  4  |  68 | 702,713 | 50,000   | 11,000   | 218,731 | 921,444  |
  5  |  69 | 685,348 | 50,000   | 11,000   | 281,855 | 967,203  |
  ...
 15  |  79 | 423,456 |    0     |    0     | 512,345 | 935,801  | $42,345
```

The illustration shows that Roth conversions in the "gap years" before Social Security and RMDs can reduce lifetime tax burden. An annuity can provide income during conversion years to avoid tapping converted funds.

### 13.6 Estate Planning Illustrations

#### 13.6.1 Annuity in Estate Planning

```
Estate Planning Illustration:
Client: Age 70 | Spouse: Age 68 | Estate: $5,000,000

Scenario A: No Annuity
  Estate at death (age 85):
    Taxable estate: $5,000,000 + growth
    Estimated estate tax: $0 (under exemption)
    Income tax on IRAs to heirs: $280,000 (10-year SECURE Act distribution)

Scenario B: With Annuity ($500,000 from IRA to Annuity)
  Annuity provides guaranteed income during lifetime
  At death:
    Remaining annuity value passes to beneficiary
    Beneficiary receives death benefit: $500,000+
    Annuity stretch over 10 years per SECURE Act
    Income tax more controllable due to annuity structure

Comparison:
  Scenario A lifetime income: $312,000 (from IRA withdrawals)
  Scenario B lifetime income: $345,000 (from annuity GLWB — guaranteed)
  Scenario A residual to heirs: $412,345
  Scenario B residual to heirs: $389,123
  Net advantage of B: $9,778 (higher income + slightly lower residual)
```

#### 13.6.2 Charitable Gift Annuity Illustration

```
Charitable Gift Annuity Illustration:
Donor: Age 75 | Gift: $100,000 | Charity: XYZ Foundation

ACGA Suggested Rate (age 75): 6.6%
Annual Income: $6,600
Tax-free portion (for 12.1 years): $2,971/year
Taxable portion: $3,629/year
Charitable deduction: $39,234
Tax savings from deduction (24% bracket): $9,416

Year | Age | Annual   | Tax-Free | Taxable  | After-Tax
     |     | Income   | Portion  | Portion  | Income
─────┼─────┼──────────┼──────────┼──────────┼──────────
  1  |  76 |  $6,600  |  $2,971  |  $3,629  |  $5,729
  2  |  77 |  $6,600  |  $2,971  |  $3,629  |  $5,729
 ...
 13  |  88 |  $6,600  |  $0      |  $6,600  |  $5,016
 ...
 20  |  95 |  $6,600  |  $0      |  $6,600  |  $5,016
```

### 13.7 Multi-Product Comparison

Advanced illustration platforms enable sophisticated multi-product comparisons:

```
Multi-Product Comparison Dashboard
Client: Age 55 | Premium: $200,000 | Goal: Retirement Income at 65

Product Type    | Carrier      | Product          | Ann Income | AV Age 85 | Guar?
────────────────┼──────────────┼──────────────────┼────────────┼───────────┼──────
FIA + GLWB      | Alpha Life   | Accumulator Plus | $19,672    | $340,812  | Yes
FIA + GLWB      | Beta Ins     | Growth Builder   | $18,456    | $328,456  | Yes
VA + GLWB       | Gamma Fin    | Diversified Edge | $21,345    | $312,567* | Yes
MYGA + SPIA     | Delta Life   | 5-yr MYGA→SPIA   | $17,890    | $0        | Yes
Systematic WD   | N/A          | Balanced Fund    | $16,000    | $456,789* | No
SPIA (immediate)| Alpha Life   | Immediate Income | $14,800    | $0        | Yes

* Variable — not guaranteed
```

**Product comparison algorithm:**

```
For each product in comparison set:
    1. Run illustration with standardized parameters
    2. Calculate key metrics:
       - Annual income at target age
       - Total income to ages 85, 90, 95
       - Account value at key ages
       - Internal rate of return at key years
       - Breakeven year (vs. leaving money in savings)
       - Probability of income lasting to age 90 (for non-guaranteed)
    3. Rank products by each metric
    4. Generate weighted score based on client priorities

Weighting example:
  Income maximization priority:
    Income amount: 40%, Income guarantee: 30%, Legacy: 15%, Liquidity: 15%
  
  Legacy priority:
    Legacy value: 40%, Income amount: 25%, Income guarantee: 20%, Liquidity: 15%
  
  Balanced priority:
    Income amount: 25%, Income guarantee: 25%, Legacy: 25%, Liquidity: 25%
```

### 13.8 Inflation-Adjusted Illustrations

Standard illustrations show nominal values. Advanced illustrations add inflation-adjusted (real) values:

```
Inflation-Adjusted Illustration
Assumed Inflation Rate: 3.0%

Year | Age | Nominal   | Real (Today's | Nominal    | Real
     |     | AV        | Dollars) AV   | Income     | Income
─────┼─────┼───────────┼───────────────┼────────────┼────────────
  1  |  56 | $212,460  | $206,272      | $0         | $0
  5  |  60 | $259,014  | $223,438      | $0         | $0
 10  |  65 | $337,140  | $250,839      | $19,672    | $14,638
 15  |  70 | $339,567  | $218,231      | $19,672    | $12,641
 20  |  75 | $341,234  | $189,189      | $19,672    | $10,907
 25  |  80 | $340,812  | $163,024      | $19,672    | $9,415
 30  |  85 | $339,456  | $140,223      | $19,672    | $8,128
```

This visualization powerfully demonstrates the erosion of purchasing power and motivates discussion about income growth features, inflation riders, or supplemental strategies.

### 13.9 Sequence-of-Returns Risk Illustration

For variable annuities and withdrawal scenarios, sequence-of-returns risk is critical:

```
Sequence-of-Returns Risk Illustration
Same average return (6%), different sequences

Scenario A: Good returns early, bad returns late
Year returns: 15%, 12%, 10%, 8%, 6%, 4%, 2%, 0%, -2%, -7%
Average: 4.8%

Scenario B: Bad returns early, good returns later
Year returns: -7%, -2%, 0%, 2%, 4%, 6%, 8%, 10%, 12%, 15%
Average: 4.8%

With $20,000 annual withdrawal starting year 1:

Year | Scenario A AV | Scenario B AV | Difference
─────┼───────────────┼───────────────┼───────────
  0  |    $200,000   |    $200,000   |    $0
  1  |    $210,000   |    $166,000   |  $44,000
  2  |    $212,800   |    $142,680   |  $70,120
  3  |    $211,880   |    $122,680   |  $89,200
  4  |    $208,630   |    $105,214   |  $103,416
  5  |    $201,228   |    $89,422    |  $111,806
  ...
 10  |    $139,456   |    $62,345    |  $77,111
```

This illustration demonstrates why guaranteed income riders have value — they protect against the sequence-of-returns risk that can devastate retirement portfolios.

### 13.10 Illustration Engine Performance and Scalability

For architects building illustration systems that must handle enterprise-scale loads:

#### 13.10.1 Performance Benchmarks

```
Target Performance Metrics:

Single illustration generation:
  - Simple (Fixed/MYGA): < 200ms
  - Standard (FIA + riders): < 500ms
  - Complex (FIA + multiple riders + tax): < 1 second
  - VA with guarantees: < 1.5 seconds
  - Monte Carlo (10,000 sims): < 10 seconds

PDF generation:
  - Standard illustration PDF: < 2 seconds
  - Multi-product comparison PDF: < 5 seconds

Throughput:
  - Concurrent illustrations: 100+ simultaneous users
  - Batch generation: 10,000+ illustrations per hour
  - API response time (P95): < 3 seconds
  - API response time (P99): < 5 seconds
```

#### 13.10.2 Scalability Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                  SCALABLE ILLUSTRATION PLATFORM                  │
│                                                                 │
│  ┌───────────────┐                                              │
│  │  Load Balancer │                                              │
│  │  (ALB/NLB)     │                                              │
│  └───────┬───────┘                                              │
│          │                                                       │
│  ┌───────┴──────────────────────────────────────┐               │
│  │  API Gateway (rate limiting, auth, routing)   │               │
│  └───────┬──────────────────────────────────────┘               │
│          │                                                       │
│  ┌───────┴──────────────────────────────────────┐               │
│  │  Calculation Engine Cluster                    │               │
│  │  ┌────────┐ ┌────────┐ ┌────────┐            │               │
│  │  │ Node 1 │ │ Node 2 │ │ Node N │  (auto-    │               │
│  │  │        │ │        │ │        │   scaling)  │               │
│  │  └────────┘ └────────┘ └────────┘            │               │
│  └───────┬──────────────────────────────────────┘               │
│          │                                                       │
│  ┌───────┴──────────────────────────────────────┐               │
│  │  Async Queue (for batch & PDF generation)     │               │
│  │  (Amazon SQS / RabbitMQ / Kafka)              │               │
│  └───────┬──────────────────────────────────────┘               │
│          │                                                       │
│  ┌───────┴──────────────────────────────────────┐               │
│  │  PDF Generation Workers                       │               │
│  │  ┌────────┐ ┌────────┐ ┌────────┐            │               │
│  │  │Worker 1│ │Worker 2│ │Worker N│ (auto-     │               │
│  │  │        │ │        │ │        │  scaling)  │               │
│  │  └────────┘ └────────┘ └────────┘            │               │
│  └──────────────────────────────────────────────┘               │
│                                                                 │
│  Data Stores:                                                   │
│  ┌────────────────┐ ┌─────────────┐ ┌──────────────────────┐   │
│  │ Product Config  │ │ Index Data  │ │ Illustration Store   │   │
│  │ (Redis Cache +  │ │ (TimeSeries │ │ (S3 + DynamoDB/      │   │
│  │  PostgreSQL)    │ │  DB)        │ │  PostgreSQL)         │   │
│  └────────────────┘ └─────────────┘ └──────────────────────┘   │
└─────────────────────────────────────────────────────────────────┘
```

#### 13.10.3 Caching Strategy

```
Cache Layers:

Layer 1: Product Configuration Cache (Redis/In-Memory)
  - TTL: 24 hours (or until product config update event)
  - Key: product_id + version
  - Eviction: LRU

Layer 2: AG49 Rate Cache (Redis/In-Memory)
  - TTL: Until next annual rate update
  - Key: product_id + strategy_id + rate_effective_date
  - Eviction: On rate update event

Layer 3: Index Data Cache (Redis/In-Memory)
  - TTL: 24 hours
  - Key: index_id + date_range
  - Pre-warmed daily

Layer 4: Illustration Result Cache (Redis)
  - TTL: 1 hour (for repeat calculations with same inputs)
  - Key: SHA-256 hash of all input parameters
  - Eviction: LRU
  - Note: Only for identical-input repeat requests (e.g., PDF re-generation)

Layer 5: PDF Cache (S3/CDN)
  - TTL: Permanent (PDFs are immutable)
  - Key: illustration_id
  - Retrieval: Direct S3 signed URL or CDN
```

### 13.11 Testing Illustration Engines

Illustration engine testing is critical because errors can result in regulatory violations and consumer harm.

#### 13.11.1 Test Categories

```
1. UNIT TESTS:
   - Individual crediting strategy calculations
   - Surrender charge calculations
   - Rider value calculations
   - Tax calculations
   - AG49 rate calculations

2. INTEGRATION TESTS:
   - Full illustration generation end-to-end
   - API endpoint testing
   - PDF generation and content verification
   - Database storage and retrieval

3. REGRESSION TESTS:
   - "Golden file" testing: Compare output against certified reference illustrations
   - Each product version must have a set of reference illustrations with known outputs
   - Any change to the engine must produce identical output for existing product versions

4. ACTUARIAL VALIDATION:
   - Independent verification by qualified actuary
   - Sample illustrations checked against manual calculations
   - AG49 rate calculations verified against independent spreadsheet models

5. COMPLIANCE TESTS:
   - Rate limit enforcement (AG49 max rate not exceeded)
   - Disclosure presence verification (all required text present)
   - State-specific requirement validation
   - PDF content verification (automated text extraction and checking)

6. PERFORMANCE TESTS:
   - Load testing under peak concurrent users
   - Throughput testing for batch generation
   - Latency testing at P95 and P99
   - Memory and CPU profiling under load

7. CROSS-PRODUCT CONSISTENCY TESTS:
   - Same client with similar products should produce logically consistent results
   - Guaranteed values must always be <= non-guaranteed values (sanity check)
   - Values must be monotonically consistent (e.g., AV at year 10 >= AV at year 9 if no withdrawals)
```

#### 13.11.2 Golden File Testing Pattern

```
// Golden file test structure
test("FIA Accumulator Plus - Standard Illustration", () => {
    // Load certified reference inputs
    const inputs = loadTestInputs("FIA-ACC-PLUS-REF-001.json");
    
    // Run illustration engine
    const result = engine.generateIllustration(inputs);
    
    // Load certified reference outputs
    const expected = loadGoldenFile("FIA-ACC-PLUS-REF-001-EXPECTED.json");
    
    // Compare every value in the ledger
    for (let year = 1; year <= 45; year++) {
        expect(result.guaranteed[year].account_value)
            .toBeCloseTo(expected.guaranteed[year].account_value, 2);  // within $0.01
        expect(result.guaranteed[year].surrender_value)
            .toBeCloseTo(expected.guaranteed[year].surrender_value, 2);
        expect(result.non_guaranteed[year].account_value)
            .toBeCloseTo(expected.non_guaranteed[year].account_value, 2);
        // ... all columns
    }
    
    // Verify summary values
    expect(result.summary.non_guaranteed.annual_income_at_65)
        .toBeCloseTo(expected.summary.non_guaranteed.annual_income_at_65, 2);
});
```

### 13.12 Emerging Trends in Annuity Illustrations

#### 13.12.1 Real-Time Interactive Illustrations

The industry is moving away from batch-generated PDFs toward real-time interactive experiences:

- **Sliders and dials** that let clients adjust parameters and see immediate results
- **Interactive charts** with hover-over details for each projection year
- **Scenario comparison** with drag-and-drop scenario ordering
- **Goal-based illustration** that starts with the desired outcome and back-solves for required premium

#### 13.12.2 AI-Enhanced Illustrations

Emerging AI capabilities in illustration systems:

- **Recommendation engines**: Suggest optimal product, strategy, and rider combinations based on client profile
- **Natural language summaries**: AI-generated plain-language explanations of illustration results
- **Anomaly detection**: Flag illustrations that appear unusual or potentially unsuitable
- **Predictive analytics**: Use historical data to predict which illustrations are most likely to result in applications

#### 13.12.3 Blockchain for Illustration Integrity

Some carriers are exploring blockchain technology for:

- **Immutable audit trails**: Illustration generation events recorded on a distributed ledger
- **Smart contract compliance**: Automated verification that illustrations comply with regulations
- **Cross-carrier comparison verification**: Standardized, verifiable illustration data for multi-carrier comparison

#### 13.12.4 Regulatory Technology (RegTech) Integration

- **Automated compliance monitoring**: Real-time monitoring of all generated illustrations against current regulatory requirements
- **Regulatory change management**: Automated detection and implementation of regulatory changes (new AG49 amendments, state regulation updates)
- **Regulatory reporting automation**: Automated generation and submission of required regulatory reports

### 13.13 Illustration Data Model — Entity Relationship Diagram

For database architects, the complete illustration data model:

```
┌──────────────────┐       ┌──────────────────┐
│   CARRIER         │       │   PRODUCT         │
│──────────────────│       │──────────────────│
│ carrier_id (PK)  │──────▶│ product_id (PK)  │
│ name             │  1:N  │ carrier_id (FK)  │
│ am_best_rating   │       │ product_name     │
│ naic_code        │       │ product_type     │
│ state            │       │ effective_date   │
└──────────────────┘       │ version          │
                           │ status           │
                           └────────┬─────────┘
                                    │ 1:N
                           ┌────────┴─────────┐
                           │ PRODUCT_VERSION   │
                           │──────────────────│
                           │ version_id (PK)  │
                           │ product_id (FK)  │
                           │ effective_date   │
                           │ certification_id │
                           │ config_json      │
                           └────────┬─────────┘
                                    │ 1:N
┌──────────────────┐       ┌────────┴─────────┐
│   CLIENT          │       │   ILLUSTRATION    │
│──────────────────│       │──────────────────│
│ client_id (PK)   │──────▶│ illus_id (PK)    │
│ first_name       │  1:N  │ illus_number     │
│ last_name        │       │ client_id (FK)   │
│ dob              │       │ agent_id (FK)    │
│ gender           │       │ product_ver (FK) │
│ state            │       │ type             │
└──────────────────┘       │ status           │
                           │ created_at       │
┌──────────────────┐       │ input_params     │
│   AGENT           │──────▶│ premium          │
│──────────────────│  1:N  │ state            │
│ agent_id (PK)    │       └────────┬─────────┘
│ name             │                │ 1:N
│ license_state    │       ┌────────┴─────────┐
│ license_number   │       │  ILLUS_SCENARIO   │
│ agency_id (FK)   │       │──────────────────│
└──────────────────┘       │ scenario_id (PK) │
                           │ illus_id (FK)    │
                           │ scenario_type    │
                           └────────┬─────────┘
                                    │ 1:N
                           ┌────────┴─────────┐
                           │  LEDGER_ROW       │
                           │──────────────────│
                           │ row_id (PK)      │
                           │ scenario_id (FK) │
                           │ year             │
                           │ age              │
                           │ account_value    │
                           │ surrender_value  │
                           │ death_benefit    │
                           │ income_ben_base  │
                           │ annual_income    │
                           │ cumulative_income│
                           │ interest_credited│
                           │ rider_charge     │
                           │ withdrawal       │
                           └──────────────────┘

┌──────────────────┐       ┌──────────────────┐
│  ILLUS_DOCUMENT   │       │  AUDIT_LOG        │
│──────────────────│       │──────────────────│
│ doc_id (PK)      │       │ log_id (PK)      │
│ illus_id (FK)    │       │ illus_id (FK)    │
│ doc_type (pdf)   │       │ event_type       │
│ storage_url      │       │ timestamp        │
│ content_hash     │       │ user_id          │
│ created_at       │       │ details_json     │
└──────────────────┘       └──────────────────┘

┌──────────────────┐       ┌──────────────────┐
│ AG49_RATE         │       │ INDEX_DATA        │
│──────────────────│       │──────────────────│
│ rate_id (PK)     │       │ index_id (PK)    │
│ product_id (FK)  │       │ index_name       │
│ strategy_id      │       │ date             │
│ effective_date   │       │ close_value      │
│ max_illus_rate   │       │ return_period    │
│ lookback_geo_mean│       │ return_value     │
│ earned_rate_cap  │       └──────────────────┘
│ certification_id │
└──────────────────┘
```

### 13.14 Glossary of Illustration-Specific Terms

| Term | Definition |
|------|-----------|
| **AG49** | Actuarial Guideline 49 — NAIC regulation governing FIA illustration rates |
| **Benchmark Index** | An index specifically designed for use in FIA crediting strategies, as opposed to broad market indices |
| **Blended Rate** | The weighted average illustrated rate across multiple allocation strategies |
| **Breakeven Year** | The year in which the surrender value first exceeds the total premium paid |
| **Certification** | Actuarial sign-off that illustration assumptions and calculations are compliant |
| **Current Assumptions** | Non-guaranteed rates and charges currently in effect |
| **Earned Rate** | The internal rate of return on the insurer's general account investments |
| **Free Withdrawal** | The amount that can be withdrawn annually without surrender charges (typically 10% of AV) |
| **Geometric Mean** | The compound average annual return, used in AG49 lookback calculations |
| **Golden File** | A certified reference illustration output used for regression testing |
| **Guaranteed Column** | The column in an illustration showing values under worst-case guaranteed assumptions |
| **IBB** | Income Benefit Base — the notional value used to calculate guaranteed income |
| **Illustrated Rate** | The crediting rate used in the non-guaranteed column, subject to AG49 limits |
| **In-Force** | Pertaining to an existing, active contract (as opposed to a prospective one) |
| **IRR** | Internal Rate of Return — the annualized return earned on the contract |
| **Ledger** | The year-by-year tabular projection in an illustration |
| **Lookback Period** | The 25-year historical period used in AG49 rate calculations |
| **M&E** | Mortality and Expense charge — a fee in variable annuities |
| **Model #245** | NAIC Annuity Disclosure Model Regulation |
| **MVA** | Market Value Adjustment — an adjustment to surrender value based on interest rate changes |
| **Non-Guaranteed Column** | The column showing values under current (non-guaranteed) assumptions |
| **PTP** | Point-to-Point — an FIA crediting method based on index change between two dates |
| **Ratchet** | A feature that locks in a higher benefit base when account value exceeds the current base |
| **RMD** | Required Minimum Distribution — IRS-mandated withdrawals from qualified accounts |
| **Roll-Up** | Guaranteed growth rate applied to an income or death benefit base during deferral |
| **Scenario** | A set of assumptions under which an illustration is projected |
| **SECURE Act** | Setting Every Community Up for Retirement Enhancement Act — impacts beneficiary distribution rules |
| **Surrender Charge** | A fee assessed upon early withdrawal or surrender of the contract |
| **1035 Exchange** | A tax-free transfer from one annuity or life insurance contract to another |

---

## Summary and Architectural Recommendations

### Key Takeaways for Solution Architects

1. **Illustration is a regulated output, not just a calculation**: Every aspect of the illustration system — from rates to formatting to storage — must be designed with regulatory compliance as a first-class concern.

2. **Product configuration must be data-driven**: Hardcoding product logic leads to unmaintainable systems. Use a flexible product specification schema that allows new products and features to be configured without code changes.

3. **AG49 is the most complex regulatory requirement**: Build the AG49 rate calculation engine as a separate, independently testable, and auditable module. Version-control the rates and maintain full audit trails.

4. **Dual-column architecture is non-negotiable**: Every projection must run under both guaranteed and non-guaranteed assumptions simultaneously. This is a fundamental architectural constraint that must be designed in from the start.

5. **Immutability and auditability**: Once an illustration is generated, it must be immutable. Every event in the illustration lifecycle must be logged. The system must be able to reproduce any historical illustration.

6. **State-specific compliance adds significant complexity**: The illustration system must support 50+ jurisdictional variations in content, format, and disclosure requirements.

7. **Performance matters**: Agents expect near-instant illustration generation. Architect for sub-second calculation times and 2-3 second end-to-end response times. Use caching aggressively.

8. **Testing must be actuarially validated**: Standard software testing is necessary but not sufficient. Illustration engines must also pass actuarial validation using certified reference calculations.

9. **The illustration is not a standalone system**: It must integrate with policy administration, CRM, e-application, compliance, and reporting systems. API-first design is essential.

10. **Plan for regulatory change**: AG49 has been amended twice in 8 years. Build the system to accommodate new regulations without architectural overhaul. Externalize rules, rates, and formatting as configurable elements.

---

*This document is intended for technical reference by solution architects and developers building systems in the annuity illustration domain. It does not constitute legal, actuarial, or financial advice. Consult qualified legal and actuarial professionals for regulatory compliance guidance.*
