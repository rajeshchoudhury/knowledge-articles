# Annuity Product Types: A Comprehensive Deep Dive

> **Audience:** Solution Architects building systems in the annuities domain
> **Scope:** Exhaustive reference covering every major annuity product type, their mechanics, data models, calculation engines, regulatory requirements, and technology implications.

---

## Table of Contents

1. [Fixed Annuities](#1-fixed-annuities)
2. [Variable Annuities](#2-variable-annuities)
3. [Fixed Indexed Annuities (FIA)](#3-fixed-indexed-annuities-fia)
4. [Registered Index-Linked Annuities (RILA)](#4-registered-index-linked-annuities-rila)
5. [Immediate Annuities (SPIA)](#5-immediate-annuities-spia)
6. [Deferred Income Annuities (DIA)](#6-deferred-income-annuities-dia)
7. [Qualified vs Non-Qualified Annuities](#7-qualified-vs-non-qualified-annuities)
8. [Guaranteed Living Benefits](#8-guaranteed-living-benefits)
9. [Guaranteed Death Benefits](#9-guaranteed-death-benefits)
10. [Group Annuities](#10-group-annuities)
11. [System Architecture Implications](#11-system-architecture-implications)
12. [Appendix: Cross-Product Comparison Matrix](#12-appendix-cross-product-comparison-matrix)

---

## 1. Fixed Annuities

### 1.1 Overview

Fixed annuities are insurance contracts that guarantee a minimum rate of interest on contributions and, at annuitization, a fixed stream of payments. The insurer bears all investment risk; the contract owner receives a deterministic crediting rate. Assets backing fixed annuities reside in the insurer's **general account**, making the product's guarantees dependent on the insurer's claims-paying ability.

From a systems perspective, fixed annuities are the simplest product type to model, but the variety of sub-types introduces significant complexity in rate management, surrender charge schedules, and bonus recapture logic.

### 1.2 Sub-Types of Fixed Annuities

| Sub-Type | Description | Typical Term | Rate Mechanism | Regulatory Filing |
|---|---|---|---|---|
| **Traditional Fixed** | Declares a current crediting rate (often annually), subject to a minimum guarantee | Open-ended (surrender period 5–10 yr) | Declared rate, renewable | State insurance department |
| **Multi-Year Guarantee (MYGA)** | Locks in a guaranteed rate for the full surrender period | 3, 5, 7, 10 years | Fixed for term | State insurance department |
| **Market Value Adjustment (MVA)** | Applies a positive or negative adjustment to surrenders based on interest-rate changes | 5–10 years | Declared rate + MVA formula | State insurance department (may require SEC no-action) |
| **CD-Type** | Bank-issued or insurance-issued, mimics certificate of deposit mechanics | 1–10 years | Fixed for term | State insurance dept (insurance) or OCC/FDIC (bank) |
| **Bonus Fixed** | Provides an upfront premium bonus, often with longer surrender periods | 7–10 years | Declared rate + bonus credit | State insurance department |

### 1.3 Traditional Fixed Annuities

#### 1.3.1 Crediting Rate Mechanism

The crediting rate on a traditional fixed annuity is **declared** by the insurer, typically on an annual basis, though some contracts declare rates monthly or quarterly. The declared rate applies to the **accumulated value** of the contract.

**Accumulated Value Calculation:**

```
AV(t) = AV(t-1) × (1 + r_declared / n)^n + Premiums(t) - Withdrawals(t) - Charges(t)
```

Where:
- `AV(t)` = Accumulated value at time t
- `r_declared` = Annual declared crediting rate
- `n` = Compounding frequency (typically 365 for daily compounding)
- `Premiums(t)` = Net premiums received during period
- `Withdrawals(t)` = Gross withdrawals taken during period
- `Charges(t)` = Any applicable contract charges

#### 1.3.2 Minimum Guaranteed Rate

Every fixed annuity contract specifies a **minimum guaranteed interest rate (MGIR)**. This is a floor below which the crediting rate can never fall, regardless of market conditions.

| Issue Era | Typical MGIR | Regulatory Context |
|---|---|---|
| Pre-2000 | 3.0% – 4.0% | State nonforfeiture laws (SNFL) based on Moody's index |
| 2000–2010 | 1.5% – 3.0% | Revised SNFL |
| 2010–2020 | 1.0% – 2.0% | Low-rate environment |
| 2020–present | 0.25% – 1.0% | NAIC model regulation allows 0.15% minimum |

**Standard Nonforfeiture Law (SNFL) Interaction:**

The MGIR is governed by state nonforfeiture laws. The NAIC Standard Nonforfeiture Law for Individual Deferred Annuities specifies that the minimum rate must be at least the lesser of:
- 1% (or state-specific floor), or
- A rate tied to the 5-year Constant Maturity Treasury (CMT) yield minus 1.25%, with a floor of 0.15%

**Data Model Consideration:**
```
CONTRACT_RATE_HISTORY {
  contract_id          VARCHAR(20)   PK
  effective_date       DATE          PK
  rate_type            ENUM('DECLARED','MINIMUM','BONUS')
  annual_rate          DECIMAL(8,6)
  compounding_method   ENUM('DAILY','MONTHLY','ANNUAL')
  rate_source          VARCHAR(50)   -- e.g., 'BOARD_DECLARED', 'SNFL_MINIMUM'
  expiration_date      DATE
}
```

#### 1.3.3 Renewal Rate Process

The renewal rate process is one of the most critical business processes for fixed annuity administration:

1. **Investment yield analysis** — The investment department calculates the earned rate on the supporting asset portfolio (typically investment-grade bonds, mortgage-backed securities, commercial mortgage loans).
2. **Spread target determination** — Management sets a target spread (typically 150–250 bps) over the crediting rate.
3. **Competitive analysis** — Rates are benchmarked against competitor products and alternative savings vehicles.
4. **Board/committee approval** — Rate declarations typically require approval from a pricing committee or the board.
5. **Rate segmentation** — Rates may vary by:
   - Issue year cohort (band)
   - Premium amount tier
   - Distribution channel
   - State of issue
   - Surrender charge period remaining
6. **System propagation** — Approved rates are loaded into the administration system.
7. **Policyholder notification** — Required notice of rate changes (timing varies by state; typically 30–45 days before anniversary).

**Rate Segmentation Data Model:**

```
CREDITING_RATE_SCHEDULE {
  schedule_id          INT           PK
  product_code         VARCHAR(10)
  effective_date       DATE
  expiration_date      DATE
  issue_year_start     INT
  issue_year_end       INT
  premium_tier_min     DECIMAL(15,2)
  premium_tier_max     DECIMAL(15,2)
  channel_code         VARCHAR(10)
  state_code           VARCHAR(2)
  surrender_year_min   INT
  surrender_year_max   INT
  declared_rate        DECIMAL(8,6)
  approval_date        DATE
  approved_by          VARCHAR(50)
}
```

#### 1.3.4 General Account Investment Strategy

The general account portfolio backing fixed annuities typically consists of:

| Asset Class | Typical Allocation | Duration | Purpose |
|---|---|---|---|
| Investment-grade corporate bonds | 35–50% | 5–8 years | Core yield |
| Government/agency bonds | 10–20% | 3–7 years | Liquidity, safety |
| Mortgage-backed securities (MBS) | 10–20% | 3–10 years (effective) | Yield enhancement |
| Commercial mortgage loans | 10–15% | 5–10 years | Yield, diversification |
| Asset-backed securities | 5–10% | 2–5 years | Yield, diversification |
| Alternative investments | 0–5% | Varies | Yield enhancement |
| Short-term/cash equivalents | 2–5% | < 1 year | Liquidity management |

The asset-liability management (ALM) process is critical: the insurer must match the duration, convexity, and cash flow profile of the asset portfolio to the projected liability cash flows.

### 1.4 Multi-Year Guarantee Annuities (MYGA)

#### 1.4.1 Mechanics

MYGAs guarantee a fixed interest rate for the entire surrender charge period. They are the insurance equivalent of a bank CD.

**Key Characteristics:**

| Attribute | Typical Value |
|---|---|
| Guarantee period | 3, 5, 7, or 10 years |
| Rate type | Fixed for full term |
| Premium type | Single premium (most common) or flexible premium (first-year only) |
| Surrender charges | Declining schedule, often reaching 0% at end of guarantee period |
| Free withdrawal | 10% of accumulated value per year, penalty-free |
| Minimum premium | $5,000 – $25,000 |
| Maximum premium | $1,000,000 – $5,000,000 (varies, may require underwriting above threshold) |

**Post-Guarantee-Period Options:**

At the end of the guarantee period, the contract owner typically has several options:
1. **Renew** — Enter a new guarantee period at the then-current rate
2. **Annuitize** — Convert to an income stream
3. **1035 Exchange** — Tax-free transfer to another annuity
4. **Full surrender** — Withdraw all funds (no surrender charge)
5. **Partial withdrawal** — Access funds as needed

**MYGA Data Model:**

```
MYGA_CONTRACT {
  contract_id              VARCHAR(20)   PK
  product_code             VARCHAR(10)
  issue_date               DATE
  guarantee_period_years   INT
  guaranteed_rate          DECIMAL(8,6)
  guarantee_start_date     DATE
  guarantee_end_date       DATE
  renewal_period_number    INT           -- 0 = initial, 1+ = renewals
  post_guarantee_mgir      DECIMAL(8,6)
  maturity_date            DATE
}
```

#### 1.4.2 Surrender Schedule

A typical MYGA surrender schedule:

| Contract Year | 3-Year MYGA | 5-Year MYGA | 7-Year MYGA | 10-Year MYGA |
|---|---|---|---|---|
| 1 | 3% | 5% | 7% | 10% |
| 2 | 2% | 4% | 6% | 9% |
| 3 | 1% | 3% | 5% | 8% |
| 4 | 0% | 2% | 4% | 7% |
| 5 | — | 1% | 3% | 6% |
| 6 | — | 0% | 2% | 5% |
| 7 | — | — | 1% | 4% |
| 8 | — | — | 0% | 3% |
| 9 | — | — | — | 2% |
| 10 | — | — | — | 1% |
| 11 | — | — | — | 0% |

**Surrender Charge Data Model:**

```
SURRENDER_SCHEDULE {
  product_code         VARCHAR(10)   PK
  schedule_version     INT           PK
  contract_year        INT           PK
  surrender_pct        DECIMAL(5,4)
  effective_date       DATE
  applies_to           ENUM('PREMIUM','ACCUMULATED_VALUE','EXCESS_OVER_FREE')
}

SURRENDER_FREE_AMOUNT {
  product_code         VARCHAR(10)   PK
  schedule_version     INT           PK
  free_withdrawal_type ENUM('PERCENT_AV','PERCENT_PREMIUM','INTEREST_ONLY','RMD')
  free_pct             DECIMAL(5,4)
  cumulative_or_annual ENUM('ANNUAL','CUMULATIVE')
  rmd_eligible         BOOLEAN
}
```

### 1.5 Market Value Adjustment (MVA) Annuities

#### 1.5.1 MVA Mechanics

An MVA annuity adjusts the surrender value up or down based on changes in interest rates since the contract was issued. If rates have risen since issue, the MVA is negative (reducing surrender value); if rates have fallen, the MVA is positive (increasing surrender value).

**MVA Formula (Common Implementation):**

```
MVA Factor = [(1 + i_issue) / (1 + i_current)]^n - 1
```

Where:
- `i_issue` = Reference rate at contract issue (e.g., Treasury yield for the contract's term)
- `i_current` = Current reference rate for the remaining term
- `n` = Number of years remaining in the guarantee period

**Example:**
- Contract issued with 5-year guarantee, reference rate at issue = 4.00%
- After 2 years, current 3-year reference rate = 5.00%
- MVA Factor = [(1.04) / (1.05)]^3 - 1 = (0.990476)^3 - 1 = -2.84%
- If AV = $100,000, surrender charge = 3%: Surrender Value = $100,000 × (1 - 0.03) × (1 - 0.0284) = $94,244

**Alternate MVA Formula (Used by some carriers):**

```
MVA Factor = (i_issue - i_current) × n × Adjustment_Scalar
```

Where `Adjustment_Scalar` is a product-specific parameter (typically between 0.5 and 1.0).

**Important System Considerations:**
- MVA calculations require real-time or daily access to reference interest rates
- The reference rate index must be specified in the contract and stored in the system
- MVA applies to surrenders during the guarantee period but typically NOT at the end of the guarantee period, upon death, or upon annuitization
- Some states prohibit or restrict MVAs (check state approval status)

**MVA Data Model:**

```
MVA_PARAMETERS {
  contract_id          VARCHAR(20)   PK
  reference_index      VARCHAR(30)   -- e.g., 'CMT_5YR', 'TREASURY_MATCHING'
  issue_reference_rate DECIMAL(8,6)
  formula_type         ENUM('COMPOUND','LINEAR','CUSTOM')
  adjustment_scalar    DECIMAL(5,4)
  mva_floor            DECIMAL(5,4)  -- e.g., -10% maximum negative adjustment
  mva_cap              DECIMAL(5,4)  -- e.g., +10% maximum positive adjustment
  exempt_on_death      BOOLEAN
  exempt_on_annuitize  BOOLEAN
  exempt_at_term_end   BOOLEAN
}

REFERENCE_RATE_HISTORY {
  rate_date            DATE          PK
  index_code           VARCHAR(30)   PK
  rate_value           DECIMAL(8,6)
  source               VARCHAR(50)
}
```

### 1.6 CD-Type Annuities

CD-type annuities are the simplest fixed annuity structure, closely mirroring bank certificates of deposit but with tax-deferred growth and insurance guarantees.

| Feature | CD-Type Annuity | Bank CD |
|---|---|---|
| Guarantee | State guaranty association | FDIC insurance |
| Tax treatment | Tax-deferred | Taxable annually |
| Guarantee limit | $100K–$500K (varies by state) | $250K per depositor per bank |
| Early withdrawal penalty | Surrender charge + possible MVA | Early withdrawal penalty (typically 3–6 months interest) |
| Issuer | Insurance company | Bank/credit union |
| Regulatory oversight | State insurance department | OCC, FDIC, state banking |
| Probate | Named beneficiary avoids probate | May be subject to probate |

### 1.7 Bonus Features on Fixed Annuities

Many fixed annuities offer premium bonuses — an upfront credit added to the contract value upon receipt of premium.

**Bonus Mechanics:**

```
Initial AV = Premium × (1 + Bonus_Rate)
```

**Typical Bonus Structure:**

| Bonus Rate | Surrender Period | Bonus Recapture | Vesting |
|---|---|---|---|
| 1% | 7 years | No recapture | Immediate |
| 3% | 9 years | Declining recapture over 9 years | Vests over 9 years |
| 5% | 10 years | Full recapture if surrendered year 1, declining | Vests over 10 years |
| 8–10% | 10–14 years | Aggressive recapture schedule | Vests over full period |

**Bonus Recapture Formula:**

```
Recapture_Amount = Bonus_Amount × Recapture_Pct(year)
Surrender_Value = AV - Surrender_Charge - Recapture_Amount
```

**Bonus Data Model:**

```
BONUS_DEFINITION {
  product_code         VARCHAR(10)   PK
  bonus_version        INT           PK
  bonus_type           ENUM('PREMIUM_BONUS','INTEREST_BONUS','PERSISTENCY_BONUS')
  bonus_rate           DECIMAL(5,4)
  applies_to           ENUM('FIRST_YEAR_PREMIUM','ALL_PREMIUMS','ACCUMULATED_VALUE')
  vesting_schedule     VARCHAR(100)  -- JSON array of vesting percentages by year
  recapture_schedule   VARCHAR(100)  -- JSON array of recapture percentages by year
  bonus_account_type   ENUM('BLENDED','SEPARATE_BUCKET')
}
```

### 1.8 Fixed Annuity — Key Attributes to Store

| Attribute Category | Key Fields | Notes |
|---|---|---|
| **Contract Header** | contract_id, product_code, issue_date, issue_state, owner_id, annuitant_id, beneficiary_ids | Standard across all annuity types |
| **Financial** | total_premiums, accumulated_value, surrender_value, cash_value, loan_balance | AV and SV differ due to surrender charges |
| **Rate Info** | current_declared_rate, minimum_guarantee_rate, bonus_rate, rate_effective_date | Rate history must be maintained |
| **Surrender** | surrender_charge_schedule_id, current_surrender_pct, free_withdrawal_remaining, surrender_charge_basis | Basis can be premium or AV |
| **Bonus** | bonus_amount, vested_bonus, recapture_amount, bonus_schedule_id | Track vested vs unvested separately |
| **MVA** | mva_applicable, reference_index, issue_reference_rate, current_mva_factor | Only for MVA products |
| **Status** | contract_status, status_date, maturity_date, annuitization_date | Statuses: Active, Surrendered, Annuitized, Death Claim, etc. |
| **Tax** | qualified_type, cost_basis, tax_year_gain, 1099_amount | Critical for tax reporting |

### 1.9 Fixed Annuity — Regulatory Requirements

| Requirement | Details |
|---|---|
| **State filing** | Product must be filed and approved in each state of sale |
| **Nonforfeiture compliance** | Must comply with Standard Nonforfeiture Law (SNFL) |
| **Illustration requirements** | Must comply with NAIC Annuity Disclosure Model Regulation |
| **Suitability** | Must comply with NAIC Suitability in Annuity Transactions Model Regulation (updated 2020, "best interest" standard) |
| **Free look period** | 10–30 days depending on state and owner age |
| **Annual statement** | Must provide annual statement showing premiums, interest credited, withdrawals, charges, and current values |
| **RMD processing** | Must support Required Minimum Distribution calculations for qualified contracts |
| **1099-R reporting** | Must issue 1099-R for taxable distributions |
| **State guaranty association** | Coverage limits vary by state ($100K–$500K) |

### 1.10 Fixed Annuity — Distribution Channels

| Channel | Typical Products | Compensation Model |
|---|---|---|
| Independent agents/IMO | MYGA, traditional fixed, FIA | Commission (1–6% of premium) |
| Banks/credit unions | CD-type, MYGA | Fee or reduced commission |
| Wirehouses/broker-dealers | MYGA (limited) | Fee-based or commission |
| Direct-to-consumer | MYGA, simple fixed | No commission (reduced pricing) |
| Registered investment advisors | MYGA (fee-based share class) | Advisory fee (no commission) |

---

## 2. Variable Annuities

### 2.1 Overview

Variable annuities (VAs) are insurance contracts that allow the contract owner to invest in a range of **sub-accounts** (analogous to mutual funds) within a tax-deferred wrapper. Unlike fixed annuities, the investment risk is borne by the contract owner — the accumulated value fluctuates with market performance. VAs are **securities** and must be registered with the SEC under the Securities Act of 1933 and the Investment Company Act of 1940.

Variable annuities are among the most complex financial products to administer, combining insurance product features (death benefits, living benefits, annuitization options) with investment management capabilities (fund selection, rebalancing, dollar-cost averaging).

### 2.2 Regulatory Framework

| Regulatory Body | Requirement |
|---|---|
| **SEC** | Registration of the separate account as a unit investment trust; prospectus delivery |
| **FINRA** | Broker-dealer registration; suitability obligations; supervisory requirements |
| **State Insurance Dept** | Insurance product filing; reserve requirements; guaranty fund participation |
| **DOL** (for qualified) | Fiduciary requirements for retirement plan sales |

### 2.3 Separate Account vs General Account

The distinction between the separate account and general account is fundamental:

| Characteristic | Separate Account | General Account |
|---|---|---|
| **Ownership** | Assets held in trust for contract owners | Assets owned by the insurer |
| **Investment risk** | Borne by contract owner | Borne by insurer |
| **Creditor protection** | Insulated from insurer's general creditors | Subject to insurer's creditor claims |
| **Investment selection** | Contract owner selects from available sub-accounts | Insurer manages portfolio |
| **Valuation** | Daily NAV calculation | Book value or amortized cost |
| **Regulation** | SEC-registered (Investment Company Act of 1940) | State insurance regulation only |
| **Accounting** | Mark-to-market (fair value) | Statutory accounting (SAP) or GAAP |
| **Use in VA** | Funds sub-account investments | Funds fixed account option, guarantees |

**System Architecture Note:** A VA administration system must maintain two parallel valuation engines — one for separate account (daily NAV-based) and one for general account (declared-rate-based). The general account component of a VA (the "fixed account option") is administered identically to a fixed annuity crediting mechanism.

### 2.4 Sub-Account Structure

Each sub-account in a variable annuity invests in an underlying mutual fund (often called a "funding vehicle" or "portfolio"). The sub-account is a division of the separate account.

**Unit Value Mechanics:**

```
Units_Purchased = Premium_Allocated / Unit_Value_at_Purchase
Current_Value = Units_Held × Current_Unit_Value
```

**Unit Value Calculation:**

```
Unit_Value(t) = Unit_Value(t-1) × (1 + Net_Fund_Return(t))
Net_Fund_Return(t) = Gross_Fund_Return(t) - M&E_Daily_Rate - Admin_Fee_Daily_Rate
```

**Sub-Account Data Model:**

```
SUB_ACCOUNT_DEFINITION {
  sub_account_id       VARCHAR(15)   PK
  sub_account_name     VARCHAR(100)
  underlying_fund_id   VARCHAR(15)   -- CUSIP or internal fund ID
  fund_family          VARCHAR(50)
  asset_class          ENUM('EQUITY_LARGE','EQUITY_MID','EQUITY_SMALL','EQUITY_INTL',
                            'FIXED_INCOME','MONEY_MARKET','BALANCED','SPECIALTY',
                            'TARGET_DATE','ALTERNATIVE')
  inception_date       DATE
  termination_date     DATE
  prospectus_objective VARCHAR(500)
  morningstar_category VARCHAR(50)
  expense_ratio        DECIMAL(6,5)  -- underlying fund expense ratio
  available_for_new    BOOLEAN
}

SUB_ACCOUNT_UNIT_VALUE {
  sub_account_id       VARCHAR(15)   PK
  valuation_date       DATE          PK
  unit_value           DECIMAL(12,6)
  daily_return         DECIMAL(10,8)
  nav_per_share        DECIMAL(12,6) -- underlying fund NAV
  units_outstanding    DECIMAL(18,6)
}

CONTRACT_SUB_ACCOUNT_POSITION {
  contract_id          VARCHAR(20)   PK
  sub_account_id       VARCHAR(15)   PK
  units_held           DECIMAL(18,6)
  current_value        DECIMAL(15,2)
  cost_basis           DECIMAL(15,2)
  allocation_pct       DECIMAL(5,4)  -- target allocation
  last_transaction_date DATE
}
```

### 2.5 Investment Options / Fund Lineup

A typical variable annuity offers 30–100+ sub-account options spanning multiple asset classes:

| Asset Class | Typical Sub-Account Count | Examples |
|---|---|---|
| US Large Cap Equity | 5–10 | Growth, Value, Blend, Index |
| US Mid Cap Equity | 3–5 | Growth, Value, Index |
| US Small Cap Equity | 3–5 | Growth, Value, Index |
| International Equity | 3–8 | Developed, Emerging, Global |
| Fixed Income | 5–10 | Government, Corporate, High Yield, International, TIPS |
| Money Market | 1–2 | Government, Prime |
| Balanced/Allocation | 3–5 | Conservative, Moderate, Aggressive |
| Target Date | 5–10 | 2025, 2030, 2035, ... 2060 |
| Specialty/Alternative | 2–5 | Real Estate, Commodities, Managed Volatility |

**Managed Volatility Funds:** Many modern VAs include managed volatility sub-accounts that automatically reduce equity exposure when market volatility spikes. These are particularly common in products with guaranteed living benefits, as they help manage the insurer's hedge costs.

### 2.6 Prospectus Requirements

As registered securities, VAs require:

| Document | Content | Update Frequency |
|---|---|---|
| **Contract prospectus** | Product features, charges, investment options, risks, death/living benefits | Annual update (supplement as needed) |
| **Fund prospectus** | Investment objective, strategy, risks, expenses for each underlying fund | Annual update |
| **Statement of Additional Information (SAI)** | Detailed financial statements, portfolio holdings, governance | Annual |
| **Semi-annual report** | Fund performance, portfolio holdings | Semi-annual |

**System Implication:** The administration system must track prospectus version control and ensure that illustrations, confirmations, and annual statements reference the correct prospectus edition. Document management integration is essential.

### 2.7 Fee Structure

Variable annuity fees are multi-layered:

#### 2.7.1 Mortality & Expense (M&E) Risk Charge

The M&E charge compensates the insurer for:
- **Mortality risk** — The risk that the death benefit guarantee will exceed the account value
- **Expense risk** — The risk that actual administrative expenses will exceed what can be recovered from other charges
- **Profit margin** — A portion of M&E represents insurer profit

| M&E Level | Annual Rate | Daily Rate | Typical Product |
|---|---|---|---|
| Low | 0.50% – 0.80% | 0.00137% – 0.00219% | B-share or fee-based |
| Standard | 1.00% – 1.30% | 0.00274% – 0.00356% | Traditional L-share |
| High | 1.40% – 1.65% | 0.00384% – 0.00452% | Older legacy products |

**M&E Deduction Calculation (Daily):**

```
Daily_M&E = Account_Value × (Annual_M&E_Rate / 365)
Unit_Value_After_M&E = Unit_Value_Before_M&E × (1 - Annual_M&E_Rate / 365)
```

#### 2.7.2 Administrative Fees

| Fee Type | Typical Amount | Deduction Method |
|---|---|---|
| Annual contract charge | $30 – $50 flat fee | Deducted on contract anniversary (waived above threshold, e.g., $50K AV) |
| Administrative fee (asset-based) | 0.10% – 0.25% annual | Deducted daily from unit value |
| Distribution/12b-1 fee | 0.00% – 0.25% annual | Included in fund expense ratio |

#### 2.7.3 Fund Management Fees

The underlying fund's expense ratio is deducted at the fund level, not the contract level:

| Fund Type | Typical Expense Ratio |
|---|---|
| Index fund | 0.10% – 0.35% |
| Actively managed equity | 0.50% – 1.00% |
| Actively managed bond | 0.40% – 0.75% |
| Target date | 0.30% – 0.80% |
| Managed volatility | 0.50% – 0.90% |

**Total Cost Stack Example:**

```
M&E Risk Charge:                    1.25%
Administrative Fee (asset-based):   0.15%
Average Fund Expense Ratio:         0.70%
GLWB Rider Fee:                     1.00%
                                   ------
Total Annual Cost:                  3.10%
```

#### 2.7.4 Fee Data Model

```
PRODUCT_FEE_SCHEDULE {
  product_code         VARCHAR(10)   PK
  fee_version          INT           PK
  fee_type             ENUM('ME_CHARGE','ADMIN_FLAT','ADMIN_ASSET_BASED',
                            'RIDER_CHARGE','SURRENDER_CHARGE','TRANSFER_FEE',
                            'FUND_EXPENSE')  PK
  fee_subtype          VARCHAR(30)   -- e.g., rider name for RIDER_CHARGE
  annual_rate          DECIMAL(8,6)  -- for asset-based fees
  flat_amount          DECIMAL(10,2) -- for flat fees
  deduction_frequency  ENUM('DAILY','MONTHLY','QUARTERLY','ANNUALLY')
  deduction_basis      ENUM('ACCOUNT_VALUE','BENEFIT_BASE','PREMIUM','UNITS')
  waiver_threshold     DECIMAL(15,2) -- AV threshold for waiver
  effective_date       DATE
  expiration_date      DATE
}
```

### 2.8 Step-Up Provisions

Many VA contracts allow the contract owner to "step up" or "reset" certain guarantee features:

**Death Benefit Step-Up:**
- Resets the guaranteed death benefit to the current (higher) account value
- Typically available on each contract anniversary
- May increase M&E charges or be limited by age (e.g., not available after age 80)

**Living Benefit Step-Up:**
- Resets the benefit base to the current (higher) account value
- May restart the roll-up period
- May change the rider fee rate
- May change the withdrawal percentage schedule

**Step-Up Logic (Pseudo-code):**
```
IF contract_anniversary AND step_up_eligible:
    IF current_AV > current_death_benefit_base:
        new_death_benefit_base = current_AV
        step_up_date = anniversary_date
        IF step_up_increases_fee:
            new_me_rate = updated_me_rate_schedule
    ELSE:
        death_benefit_base unchanged
```

### 2.9 Dollar Cost Averaging (DCA)

DCA is a systematic investment program that transfers a fixed dollar amount from a source sub-account (typically money market) to one or more target sub-accounts at regular intervals.

| Parameter | Typical Values |
|---|---|
| Source account | Money market or fixed account |
| Target accounts | Any available sub-accounts |
| Frequency | Monthly (most common), quarterly, semi-annually |
| Duration | 6, 12, 18, or 24 months |
| Transfer amount | Fixed dollar or percentage of remaining source balance |
| Auto-termination | When source balance depleted or program term ends |

**DCA Data Model:**

```
DCA_PROGRAM {
  contract_id          VARCHAR(20)   PK
  program_id           INT           PK
  source_sub_account   VARCHAR(15)
  start_date           DATE
  end_date             DATE
  frequency            ENUM('MONTHLY','QUARTERLY','SEMI_ANNUAL')
  total_amount         DECIMAL(15,2)
  remaining_amount     DECIMAL(15,2)
  status               ENUM('ACTIVE','COMPLETED','CANCELLED')
}

DCA_TARGET_ALLOCATION {
  contract_id          VARCHAR(20)   PK
  program_id           INT           PK
  target_sub_account   VARCHAR(15)   PK
  allocation_pct       DECIMAL(5,4)
  transfer_amount      DECIMAL(15,2)
}
```

### 2.10 Automatic Rebalancing

Automatic rebalancing periodically realigns the contract's sub-account allocations to the target allocation model.

**Rebalancing Process:**

1. On the rebalancing date, calculate current allocation percentages
2. Compare to target allocation
3. If deviation exceeds threshold (if applicable), execute transfers
4. Generate confirmation/statement

| Parameter | Typical Values |
|---|---|
| Frequency | Quarterly, semi-annually, annually |
| Trigger type | Calendar-based or threshold-based (e.g., ±5% deviation) |
| Allocation model | Owner-selected or advisor-managed |
| Tax implications | None (tax-deferred inside annuity) |

### 2.11 Asset Allocation Models

Many VAs offer pre-built asset allocation models:

| Model | Equity/Fixed | Target Risk Level | Typical Holder Profile |
|---|---|---|---|
| Conservative | 20/80 | Low | Near or in retirement, risk-averse |
| Moderately Conservative | 40/60 | Low-Medium | Early retirement, moderate risk |
| Moderate | 60/40 | Medium | 10+ years to retirement |
| Moderately Aggressive | 75/25 | Medium-High | 15+ years to retirement |
| Aggressive | 90/10 | High | Long time horizon, high risk tolerance |

### 2.12 Variable Annuity — Key Attributes to Store

| Category | Key Fields |
|---|---|
| **Contract** | contract_id, product_code, issue_date, issue_state, share_class, prospectus_version |
| **Positions** | sub_account_id, units_held, current_value, cost_basis (per sub-account) |
| **Fees** | m_e_rate, admin_fee_rate, rider_charges[], current_total_expense |
| **Guarantees** | death_benefit_base, death_benefit_type, living_benefit_base, living_benefit_type |
| **Programs** | dca_program_details, rebalancing_schedule, allocation_model_id |
| **Surrender** | surrender_schedule_id, current_surrender_pct, free_withdrawal_remaining |
| **Performance** | inception_to_date_return, ytd_return, trailing_1yr_return |

### 2.13 Variable Annuity — Calculation Engine Requirements

| Calculation | Frequency | Complexity |
|---|---|---|
| **Daily valuation** | Daily (business days) | High — requires NAV feed, unit accounting |
| **M&E deduction** | Daily | Medium — asset-based daily rate applied to AV |
| **Death benefit** | Daily (for tracking) | Medium — compare AV to various DB formulas |
| **Living benefit** | Daily or on-event | Very High — depends on benefit type |
| **Surrender value** | On-demand | Medium — AV minus surrender charges |
| **RMD calculation** | Annually | Medium — prior year-end fair market value |
| **Cost basis tracking** | Per transaction | High — FIFO or specific identification |
| **Performance reporting** | Monthly/quarterly | Medium — time-weighted return calculations |

---

## 3. Fixed Indexed Annuities (FIA)

### 3.1 Overview

Fixed Indexed Annuities (FIAs), also called Equity-Indexed Annuities (EIAs), are fixed annuity contracts where the crediting rate is linked to the performance of an external market index (e.g., S&P 500). The contract owner participates in a portion of the index's upside while being protected from downside losses by a guaranteed floor (typically 0%).

FIAs are **not securities** — they are regulated as insurance products by state insurance departments. This distinction is critical for system architecture: FIAs do not require daily NAV-based valuation but instead use periodic index crediting calculations.

### 3.2 How FIA Crediting Works — Conceptual Model

The FIA crediting mechanism involves several interacting parameters:

```
Index_Credit = MAX(Floor, f(Index_Return, Participation_Rate, Cap, Spread))
```

Where the function `f()` depends on the specific crediting method. The key components:

| Component | Description | Typical Range |
|---|---|---|
| **Index Return** | Change in the index value over the crediting period | -40% to +40% |
| **Participation Rate** | Percentage of the index return credited | 25% to 150%+ |
| **Cap** | Maximum crediting rate for the period | 3% to 12%+ |
| **Spread/Margin** | Deducted from the index return before crediting | 0% to 5% |
| **Floor** | Minimum crediting rate (downside protection) | 0% (most common), sometimes -10% for buffer products |

### 3.3 Index Crediting Methods

#### 3.3.1 Annual Point-to-Point (APP)

The most common and simplest crediting method. Compares the index value at the start and end of the annual crediting period.

**Formula:**

```
Index_Return = (Index_End - Index_Start) / Index_Start

With Cap:
Credited_Rate = MIN(Cap, MAX(Floor, Index_Return × Participation_Rate))

With Spread:
Credited_Rate = MAX(Floor, (Index_Return × Participation_Rate) - Spread)

With Cap AND Spread:
Credited_Rate = MAX(Floor, MIN(Cap, Index_Return × Participation_Rate) - Spread)
```

**Example (Cap-based):**
- Index Start: 4,000
- Index End: 4,500
- Index Return: (4,500 - 4,000) / 4,000 = 12.5%
- Participation Rate: 100%
- Cap: 8%
- Floor: 0%
- Credited Rate: MIN(8%, MAX(0%, 12.5% × 100%)) = **8.0%**

**Example (Spread-based):**
- Same index return: 12.5%
- Participation Rate: 100%
- Spread: 3.0%
- Floor: 0%
- Credited Rate: MAX(0%, (12.5% × 100%) - 3.0%) = **9.5%**

**Example (Negative market):**
- Index Return: -15%
- Any parameters
- Credited Rate: MAX(0%, ...) = **0.0%** (floor protection)

#### 3.3.2 Monthly Point-to-Point (MPP)

Calculates index returns monthly, applies a monthly cap, and sums the capped monthly returns.

**Formula:**

```
Monthly_Return(m) = (Index_Month_End(m) - Index_Month_End(m-1)) / Index_Month_End(m-1)
Capped_Monthly_Return(m) = MIN(Monthly_Cap, MAX(Monthly_Floor, Monthly_Return(m)))
Annual_Credit = SUM(Capped_Monthly_Return(m)) for m = 1 to 12
Credited_Rate = MAX(Annual_Floor, Annual_Credit)
```

**Key Characteristics:**
- Monthly caps are typically much lower than annual caps (e.g., 2.0% – 3.5% monthly)
- Monthly floors can be 0% (each month protected) or uncapped on the downside (only the annual floor provides protection)
- Negative months reduce the sum, potentially resulting in 0% credit for the year even if the index was up

**Example:**

| Month | Index Return | Monthly Cap (2.5%) | Capped Return |
|---|---|---|---|
| Jan | +3.2% | 2.5% | +2.5% |
| Feb | -1.5% | n/a (no monthly floor) | -1.5% |
| Mar | +2.1% | 2.5% | +2.1% |
| Apr | -0.8% | n/a | -0.8% |
| May | +1.5% | 2.5% | +1.5% |
| Jun | +4.0% | 2.5% | +2.5% |
| Jul | -2.3% | n/a | -2.3% |
| Aug | +1.8% | 2.5% | +1.8% |
| Sep | -3.1% | n/a | -3.1% |
| Oct | +2.7% | 2.5% | +2.5% |
| Nov | +1.9% | 2.5% | +1.9% |
| Dec | +0.5% | 2.5% | +0.5% |
| **Sum** | **+10.0%** | | **+7.6%** |

Annual Floor = 0%, so Credited Rate = MAX(0%, 7.6%) = **7.6%**

#### 3.3.3 Monthly Average

Uses the average of monthly index values compared to the starting index value.

**Formula:**

```
Monthly_Values = [Index(1), Index(2), ..., Index(12)]
Average_Index = MEAN(Monthly_Values)
Index_Return = (Average_Index - Index_Start) / Index_Start
Credited_Rate = MAX(Floor, MIN(Cap, Index_Return × Participation_Rate))
```

**Characteristics:**
- The averaging smooths out volatility
- In strongly trending markets (up or down), the average will lag the point-to-point return
- Typically offered with higher caps or participation rates to compensate for the averaging effect
- Simple to calculate but can underperform in strong bull markets

**Mathematical Note:** For a linearly trending market, the monthly average return will be approximately half the point-to-point return. This is because the average of a linear sequence equals the midpoint.

#### 3.3.4 Daily Averaging

Averages daily index closing values over the crediting period.

**Formula:**

```
Daily_Values = [Index(d1), Index(d2), ..., Index(d_n)] for all trading days
Average_Index = MEAN(Daily_Values)
Index_Return = (Average_Index - Index_Start) / Index_Start
Credited_Rate = MAX(Floor, MIN(Cap, Index_Return × Participation_Rate))
```

**Characteristics:**
- Even smoother than monthly averaging
- Requires daily index data feed
- Rarely offered as a primary strategy in modern products
- Most useful in highly volatile markets

#### 3.3.5 Performance Trigger / Threshold

A newer crediting approach where the contract earns a fixed rate if the index performance meets a threshold.

**Formula:**

```
IF Index_Return > Trigger_Threshold (e.g., 0%):
    Credited_Rate = Declared_Trigger_Rate (e.g., 5.0%)
ELSE:
    Credited_Rate = Floor (e.g., 0%)
```

**Characteristics:**
- Binary outcome: either the trigger rate or the floor
- Does not matter how much the index went up (even +0.01% earns the full trigger rate)
- Insurer uses binary options to hedge
- Increasingly popular due to simplicity

### 3.4 Index Options

#### 3.4.1 Standard Market Indices

| Index | Ticker | Description | Use in FIAs |
|---|---|---|---|
| S&P 500 | SPX | US large-cap equity benchmark | Most common; available in nearly all FIAs |
| Russell 2000 | RUT | US small-cap equity benchmark | Common secondary option |
| NASDAQ-100 | NDX | US large-cap tech-heavy | Growing in popularity |
| MSCI EAFE | MXEA | International developed markets | Common for diversification |
| EURO STOXX 50 | SX5E | European large-cap | Occasional option |
| Hang Seng | HSI | Hong Kong large-cap | Rare in US FIAs |
| 10-Year US Treasury | N/A | Fixed income benchmark | Used in some multi-asset strategies |

#### 3.4.2 Custom/Hybrid Indices

A rapidly growing trend in FIA design is the use of **proprietary or custom indices** created by investment banks. These indices combine multiple asset classes with algorithmic allocation rules.

| Index Family | Creator | Description | Volatility Target |
|---|---|---|---|
| S&P MARC 5% | S&P/Goldman Sachs | Multi-Asset Risk Control | 5% |
| Barclays Trailblazer 5 | Barclays | Multi-asset with momentum | 5% |
| Credit Suisse Momentum | Credit Suisse | Equity momentum strategy | 5% |
| J.P. Morgan Mozaic II | J.P. Morgan | Multi-asset factor-based | 5% |
| BNP Paribas Multi-Asset Diversified 5 | BNP Paribas | Multi-asset, risk parity | 5% |
| Fidelity AIM Dividend | Fidelity | High-dividend equity | N/A |
| PIMCO Tactical Balanced ER | PIMCO | Balanced strategy | N/A |
| BlackRock iBLD Claria | BlackRock | Multi-factor allocation | 5% |

#### 3.4.3 Volatility-Controlled Indices

Volatility-controlled indices are particularly important for FIA hedging. These indices use a built-in mechanism to reduce exposure when volatility rises:

**Volatility Control Mechanism:**

```
IF Realized_Volatility > Target_Volatility:
    Equity_Allocation = Target_Volatility / Realized_Volatility
ELSE:
    Equity_Allocation = 1.0 (or up to a leverage cap)

Index_Return = Equity_Allocation × Underlying_Return + (1 - Equity_Allocation) × Cash_Return
```

**Example:**
- Target volatility: 5%
- Current realized volatility: 20%
- Equity allocation: 5% / 20% = 25%
- Underlying equity return: +10%
- Cash return: +0.5%
- Controlled index return: 25% × 10% + 75% × 0.5% = **2.875%**

**Why Insurers Favor These:**
- Lower hedging costs (options on low-volatility indices are cheaper)
- Allows higher caps and participation rates to be offered
- More predictable hedging outcomes
- However, they limit upside in strong equity markets

### 3.5 FIA Crediting Strategy Data Model

```
FIA_CREDITING_STRATEGY {
  strategy_id          VARCHAR(15)   PK
  product_code         VARCHAR(10)
  strategy_name        VARCHAR(100)
  crediting_method     ENUM('ANNUAL_PTP','MONTHLY_PTP','MONTHLY_AVG','DAILY_AVG',
                            'PERFORMANCE_TRIGGER','TWO_YEAR_PTP','MULTI_YEAR_PTP')
  index_code           VARCHAR(30)
  term_months          INT           -- 12, 24, 36, etc.
  parameter_type       ENUM('CAP','SPREAD','PARTICIPATION','TRIGGER_RATE')
  has_cap              BOOLEAN
  has_spread           BOOLEAN
  has_participation    BOOLEAN
  floor_rate           DECIMAL(6,5)
  monthly_cap          DECIMAL(6,5)  -- for MPP
  monthly_floor        DECIMAL(6,5)  -- for MPP (NULL = no monthly floor)
}

FIA_STRATEGY_RATES {
  strategy_id          VARCHAR(15)   PK
  effective_date       DATE          PK
  cap_rate             DECIMAL(6,5)
  participation_rate   DECIMAL(6,5)
  spread_rate          DECIMAL(6,5)
  trigger_rate         DECIMAL(6,5)
  minimum_cap          DECIMAL(6,5)  -- contractual minimum
  minimum_participation DECIMAL(6,5)
  maximum_spread       DECIMAL(6,5)
  rate_source          VARCHAR(30)   -- 'DECLARED', 'CONTRACTUAL_MIN'
}

FIA_CONTRACT_STRATEGY_ALLOCATION {
  contract_id          VARCHAR(20)   PK
  strategy_id          VARCHAR(15)   PK
  allocation_amount    DECIMAL(15,2)
  allocation_pct       DECIMAL(5,4)
  term_start_date      DATE
  term_end_date        DATE
  index_start_value    DECIMAL(15,6)
  current_index_value  DECIMAL(15,6)
  interim_credit       DECIMAL(15,2) -- only for some designs
  locked_credit        DECIMAL(15,2) -- credit locked at term end
  term_number          INT
}
```

### 3.6 Renewal Rate Mechanics

At the end of each crediting term (typically annually), the insurer sets new crediting parameters (cap, participation rate, spread) for the next term:

**Renewal Process:**
1. **Option budget calculation** — The insurer determines the option budget (typically 2–4% of AV) available to purchase hedging instruments
2. **Hedge pricing** — The cost of options on each index is evaluated based on current market conditions (implied volatility, interest rates)
3. **Parameter setting** — Given the option budget, the insurer determines what cap, participation rate, or spread can be offered
4. **Competitive analysis** — Parameters are compared to competitors
5. **Approval and loading** — New rates are approved and loaded into the administration system
6. **Contract owner notification** — Required notice of new crediting parameters
7. **Reallocation window** — Contract owners may reallocate among available strategies during an annual window

**Contractual Minimums:**
Every FIA must specify contractual minimum crediting parameters:

| Parameter | Typical Contractual Minimum |
|---|---|
| Minimum Cap | 1.0% – 3.0% |
| Minimum Participation Rate | 5% – 25% |
| Maximum Spread | 8% – 12% |
| Floor Rate | 0% |

### 3.7 FIA — Accumulated Value Calculation

The accumulated value of an FIA tracks across multiple "buckets" — one for each crediting strategy plus a fixed account option:

```
Total_AV = SUM(Strategy_AV(i) for all strategies) + Fixed_Account_AV

Strategy_AV(i) after term end = Strategy_AV_Start(i) × (1 + Credited_Rate(i))
```

**During a term (interim value):** Some FIA contracts calculate an interim value that reflects partial-period index performance, often with a vesting factor:

```
Interim_Value = Strategy_AV_Start × (1 + Interim_Credit × Vesting_Factor)
```

Where Vesting_Factor may be 0 (no interim credit) or a schedule like:
- Month 1–3: 0%
- Month 4–6: 25%
- Month 7–9: 50%
- Month 10–12: 75%

### 3.8 FIA — Surrender Schedule

FIA surrender schedules tend to be longer than MYGA surrender schedules due to the higher commission structure:

| Year | Typical FIA Surrender Charge |
|---|---|
| 1 | 9% – 10% |
| 2 | 9% |
| 3 | 8% |
| 4 | 7% |
| 5 | 6% |
| 6 | 5% |
| 7 | 4% |
| 8 | 3% |
| 9 | 2% |
| 10 | 1% |
| 11+ | 0% |

### 3.9 FIA — Regulatory and Compliance

| Topic | Details |
|---|---|
| **Classification** | Insurance product (NOT a security under the Harkin Amendment/Dodd-Frank Rule 151A) |
| **Regulatory body** | State insurance departments |
| **Illustration regulation** | NAIC Annuity Illustrations Model Regulation; AG 49 / AG 49-A / AG 49-B govern illustrated rates |
| **AG 49-A (2020)** | Limits illustrated rates for FIAs; requires use of a 145% × 10-year Treasury benchmark for standard indices and a lookback for non-proprietary volatility-controlled indices |
| **AG 49-B (2024)** | Further restricts illustrations for products with proprietary or hybrid indices; introduces the "index-based benchmark" |
| **Suitability** | NAIC Best Interest standard; state-specific requirements |
| **Producer licensing** | Insurance license required (no securities license needed for non-registered FIA) |

### 3.10 FIA — Technology Implications

| System Component | Requirement |
|---|---|
| **Index data feed** | Daily close prices for all supported indices (standard and custom) |
| **Crediting engine** | Must support multiple crediting methods, each with different formulas |
| **Rate management** | Manage declared rates (caps, participation, spreads) by strategy, with effective dates |
| **Allocation engine** | Support multi-strategy allocation and annual reallocation |
| **Interim value calculator** | Calculate interim values for surrender, death benefit, and statement purposes |
| **Illustration system** | AG 49-A / AG 49-B compliant illustration generation |
| **Anniversary processing** | Batch processing to lock crediting at term end and start new terms |

---

## 4. Registered Index-Linked Annuities (RILA)

### 4.1 Overview

Registered Index-Linked Annuities (RILAs), also known as **structured annuities**, **buffered annuities**, or **index-variable annuities**, are a hybrid product type that sits between variable annuities and fixed indexed annuities. Unlike FIAs, RILAs expose the contract owner to **some** downside risk in exchange for greater upside potential.

RILAs are **registered securities** (like VAs) and must be sold with a prospectus. They are registered under the Securities Act of 1933 and typically issued through a separate account.

### 4.2 Buffer vs Floor Mechanisms

The defining characteristic of a RILA is how it handles negative index returns:

#### 4.2.1 Buffer Mechanism

The insurer absorbs losses up to a specified buffer percentage; the contract owner bears losses beyond the buffer.

**Formula:**

```
IF Index_Return >= 0:
    Credited_Rate = MIN(Cap, Index_Return × Participation_Rate)
ELSE IF Index_Return >= -Buffer:
    Credited_Rate = 0%  (insurer absorbs the loss)
ELSE:
    Credited_Rate = Index_Return + Buffer  (owner bears loss beyond buffer)
```

**Example (10% Buffer, 15% Cap):**

| Index Return | Credited Rate | Explanation |
|---|---|---|
| +20% | +15.0% | Capped at 15% |
| +10% | +10.0% | Full participation below cap |
| +5% | +5.0% | Full participation below cap |
| 0% | 0.0% | No gain, no loss |
| -5% | 0.0% | Within buffer — insurer absorbs |
| -10% | 0.0% | At buffer boundary — insurer absorbs |
| -15% | -5.0% | Owner bears -15% + 10% buffer = -5% |
| -30% | -20.0% | Owner bears -30% + 10% buffer = -20% |
| -50% | -40.0% | Owner bears -50% + 10% buffer = -40% |

Common buffer levels: **10%, 15%, 20%, 25%, 30%**

#### 4.2.2 Floor Mechanism

The floor limits the maximum loss the contract owner can experience, regardless of how far the index falls.

**Formula:**

```
IF Index_Return >= 0:
    Credited_Rate = MIN(Cap, Index_Return × Participation_Rate)
ELSE:
    Credited_Rate = MAX(Floor, Index_Return)
```

**Example (-10% Floor, 12% Cap):**

| Index Return | Credited Rate | Explanation |
|---|---|---|
| +20% | +12.0% | Capped at 12% |
| +10% | +10.0% | Full participation |
| 0% | 0.0% | No gain, no loss |
| -5% | -5.0% | Owner bears full loss (above floor) |
| -10% | -10.0% | At floor — maximum loss |
| -15% | -10.0% | Floor protection limits loss to -10% |
| -50% | -10.0% | Floor protection limits loss to -10% |

Common floor levels: **-5%, -10%, -15%, -20%**

#### 4.2.3 Buffer vs Floor Comparison

| Feature | Buffer | Floor |
|---|---|---|
| **How downside is absorbed** | Insurer absorbs first X% of loss | Owner bears first X% of loss, insurer absorbs rest |
| **Best for** | Markets with small to moderate declines | Markets with severe declines |
| **Worst scenario** | Large declines (owner exposed to most of loss) | Small to moderate declines (owner bears full loss) |
| **Typical upside** | Higher caps (insurer takes less risk) | Lower caps (insurer takes more risk) |
| **Cost to insurer** | Lower (put spread) | Higher (deep out-of-money put) |
| **Hedging instrument** | Long put at buffer strike, short put at 0 | Long put at floor strike |

### 4.3 Segment Periods

RILAs operate on defined **segment periods** (also called **terms** or **crediting periods**):

| Segment Duration | Common? | Description |
|---|---|---|
| 1 year | Very common | Annual segment, similar to FIA term |
| 2 years | Common | Biennial crediting |
| 3 years | Common | Triennial crediting |
| 5 years | Less common | Longer commitment for higher caps |
| 6 years | Rare | Longest typical segment |

At the end of each segment, the index return is calculated, the buffer/floor is applied, and the credited amount is locked in. The contract owner then selects parameters for the next segment.

**Segment Data Model:**

```
RILA_SEGMENT {
  contract_id          VARCHAR(20)   PK
  segment_id           INT           PK
  index_code           VARCHAR(30)
  segment_start_date   DATE
  segment_end_date     DATE
  segment_duration_months INT
  protection_type      ENUM('BUFFER','FLOOR')
  protection_level     DECIMAL(5,4)  -- e.g., 0.10 for 10% buffer
  cap_rate             DECIMAL(6,5)
  participation_rate   DECIMAL(6,5)
  index_start_value    DECIMAL(15,6)
  index_end_value      DECIMAL(15,6)
  segment_return       DECIMAL(8,6)
  credited_return      DECIMAL(8,6)
  beginning_value      DECIMAL(15,2)
  ending_value         DECIMAL(15,2)
  status               ENUM('ACTIVE','MATURED','SURRENDERED','DEATH_CLAIM')
}
```

### 4.4 Interim Value Calculations

Unlike FIAs (where interim values are often simplified), RILA interim values attempt to approximate the fair value of the contract at any point during the segment. This is critical because the contract owner bears downside risk, and the interim value must reflect that risk.

**Interim Value Approach:**

```
Interim_Value = Beginning_Segment_Value + Proxy_Value

Proxy_Value ≈ Mark-to-Market of the embedded derivative position:
  = Value of (Long Call + Short Call at Cap) + Value of (Protection Put Structure)
  
Simplified Approximation:
  Interim_Value = Beginning_Value × (1 + Interim_Index_Return × Interim_Factor - Interim_Fee)
```

**Key Considerations:**
- Interim values can be LESS than the beginning value (since the owner bears risk)
- Interim values are path-dependent and difficult to calculate precisely
- Some carriers use Black-Scholes-based approximations; others use simpler pro-rata methods
- Prospectus must disclose the interim value methodology
- The interim value determines the surrender value, death benefit, and transfer value during a segment

**Interim Value Data Model:**

```
RILA_INTERIM_VALUATION {
  contract_id          VARCHAR(20)   PK
  segment_id           INT           PK
  valuation_date       DATE          PK
  index_current_value  DECIMAL(15,6)
  interim_index_return DECIMAL(8,6)
  interim_proxy_value  DECIMAL(15,2)
  interim_contract_value DECIMAL(15,2)
  calculation_method   ENUM('BLACK_SCHOLES','PRO_RATA','CARRIER_PROPRIETARY')
  days_elapsed         INT
  days_remaining       INT
}
```

### 4.5 RILA vs FIA vs VA Comparison

| Feature | FIA | RILA | VA |
|---|---|---|---|
| **Registration** | Insurance product only | SEC-registered security | SEC-registered security |
| **Downside risk** | None (0% floor) | Partial (buffer/floor) | Full market risk |
| **Upside potential** | Limited (cap/spread) | Moderate (higher caps) | Full market participation |
| **Underlying** | General account + options | Separate account | Separate account (sub-accounts) |
| **Prospectus** | No | Yes | Yes |
| **FINRA oversight** | No | Yes | Yes |
| **Licensing** | Insurance only | Insurance + Series 6/7 | Insurance + Series 6/7 |
| **Typical cap (1-yr segment)** | 5–10% | 10–25% | N/A (no cap) |
| **Guarantees available** | GLWB, GMWB (insurance) | Limited (some offer riders) | Full suite (GLWB, GMWB, GMIB, GMAB) |
| **Complexity** | High | Very High | Very High |
| **Administration system** | Insurance admin | Hybrid (insurance + securities) | Securities/insurance hybrid |

### 4.6 RILA — Technology Implications

| Requirement | Details |
|---|---|
| **Daily interim valuation** | Unlike FIA, interim values must reflect market risk — requires pricing model |
| **Segment management** | Each contract may have multiple overlapping segments with different parameters |
| **Prospectus compliance** | All illustrations, statements, and communications require prospectus-compliant language |
| **FINRA reporting** | Sales supervision, trade reporting, suitability documentation |
| **Hedging integration** | Close integration with the insurer's derivatives desk for hedge management |
| **Confirmations** | Must issue trade confirmations for segment initiations (similar to VA purchase confirmations) |

---

## 5. Immediate Annuities (SPIA)

### 5.1 Overview

A Single Premium Immediate Annuity (SPIA) converts a lump-sum premium into a guaranteed stream of income payments, beginning within one annuity period (typically 30 days to 13 months) after purchase. SPIAs are "pay-in-once, pay-out-forever (or for a period)" products.

SPIAs are the purest expression of the insurance risk-pooling concept: those who die earlier effectively subsidize those who live longer (this is the **mortality credit**).

### 5.2 Payout Options

| Payout Option | Description | Payments Stop When | Beneficiary Receives |
|---|---|---|---|
| **Life Only** | Payments for the annuitant's lifetime | Annuitant dies | Nothing |
| **Life with Period Certain** | Payments for life, but guaranteed for a minimum period (5, 10, 15, 20 years) | Later of: annuitant death or end of certain period | Remaining certain-period payments |
| **Joint Life** | Payments for two lives (e.g., spouses) | Both annuitants die | Nothing (if no certain period) |
| **Joint Life with Period Certain** | Payments for two lives with guaranteed minimum period | Later of: second death or end of certain period | Remaining certain-period payments |
| **Joint Life with Survivor Reduction** | Full payment while both alive; reduced payment (50%, 67%, 75%) after first death | Both annuitants die | Nothing |
| **Installment Refund** | Payments for life; if annuitant dies before total payments equal the premium, remaining payments continue to beneficiary | Later of: annuitant death or cumulative payments ≥ premium | Remaining installments until premium refunded |
| **Cash Refund** | Payments for life; if annuitant dies before total payments equal the premium, a lump-sum is paid to beneficiary | Annuitant dies (lump sum settles) | Premium minus cumulative payments as lump sum |
| **Period Certain Only** | Fixed number of payments; no life contingency | End of certain period | Remaining payments if owner dies |
| **Temporary Life** | Payments for life but limited to a maximum period | Earlier of: annuitant death or end of period | Nothing |

#### 5.2.1 Payout Option Data Model

```
SPIA_CONTRACT {
  contract_id          VARCHAR(20)   PK
  product_code         VARCHAR(10)
  purchase_date        DATE
  premium_amount       DECIMAL(15,2)
  payout_option        ENUM('LIFE_ONLY','LIFE_PERIOD_CERTAIN','JOINT_LIFE',
                            'JOINT_LIFE_CERTAIN','JOINT_SURVIVOR_REDUCTION',
                            'INSTALLMENT_REFUND','CASH_REFUND','PERIOD_CERTAIN',
                            'TEMPORARY_LIFE')
  payout_frequency     ENUM('MONTHLY','QUARTERLY','SEMI_ANNUAL','ANNUAL')
  payout_amount        DECIMAL(12,2)
  first_payment_date   DATE
  certain_period_months INT
  survivor_reduction_pct DECIMAL(5,4)
  annuitant_id         VARCHAR(20)
  joint_annuitant_id   VARCHAR(20)   -- NULL if not joint
  cola_rate            DECIMAL(5,4)  -- cost-of-living adjustment rate (if applicable)
  cola_type            ENUM('NONE','FIXED_PCT','CPI_LINKED')
  total_payments_made  DECIMAL(15,2)
  remaining_certain_payments INT
  status               ENUM('PAYING','CERTAIN_PERIOD_ONLY','COMPLETED','COMMUTED')
}
```

### 5.3 Mortality Tables

SPIA pricing depends heavily on mortality assumptions. Key tables:

| Table | Year | Use | Description |
|---|---|---|---|
| **Annuity 2000** | 2000 | Statutory reserves | NAIC-mandated basic table with Projection Scale G |
| **2012 IAM** | 2012 | Pricing/valuation | Individual Annuity Mortality table with Projection Scale G2 |
| **2012 IAR** | 2012 | Reserving | Individual Annuity Reserve table |
| **GAM-83** | 1983 | Legacy | Group Annuity Mortality |
| **RP-2014** | 2014 | Pension plans | Retirement Plans mortality |
| **SOA 2015 VBT** | 2015 | Valuation | Valuation Basic Table |
| **2017 CSO** | 2017 | Life insurance | Commissioners Standard Ordinary (not for annuities) |

**Mortality Improvement Projections:**
Mortality tables are static, but mortality improvements are modeled using projection scales:

```
q(x, t) = q(x, base_year) × (1 - improvement_rate(x))^(t - base_year)
```

Where:
- `q(x, t)` = Probability of death at age x in year t
- `q(x, base_year)` = Base table mortality rate
- `improvement_rate(x)` = Annual mortality improvement at age x (from projection scale)

**Gender-Distinct vs Unisex Pricing:**
- Individual SPIAs typically use gender-distinct rates (females receive lower per-dollar payouts due to longer life expectancy)
- Some states require unisex rates for employer-sponsored plans
- For system design, always support both gender-distinct and unisex rate tables

### 5.4 Payout Factor Calculations

The payout factor determines the periodic payment amount per $1,000 of premium.

#### 5.4.1 Life Only Payout Factor

**Present Value of Life Annuity Due:**

```
ä(x) = Σ (v^t × t_p_x) for t = 0 to ω-x

Where:
  v = 1 / (1 + i)  (discount factor)
  i = pricing interest rate
  t_p_x = probability of survival from age x to age x+t
  ω = terminal age of the mortality table

Payout_Factor = Premium / (ä(x) × payment_frequency_factor)
Monthly_Payment = Premium × (1 / (12 × ä(x) × (1 - (11/24) × d)))
```

Where `d = i / (1 + i)` is the discount rate and the `(11/24)` factor converts from an annual annuity-due to a monthly annuity.

#### 5.4.2 Life with Period Certain

```
ä(x, n) = ä(n|) + (v^n × n_p_x × ä(x+n))

Where:
  ä(n|) = present value of annuity-certain for n years
  v^n × n_p_x = survival-discounted value at end of certain period
  ä(x+n) = present value of life annuity starting at age x+n
```

#### 5.4.3 Joint Life Payout Factor

```
ä(x,y) = Σ (v^t × t_p_x × t_p_y) for t = 0 to max(ω-x, ω-y)

Joint Life with Survivor Reduction:
ä_joint = ä(x,y) + k × (ä(x) + ä(y) - 2 × ä(x,y))

Where k = survivor reduction fraction (e.g., 0.5 for 50% to survivor)
```

### 5.5 Exclusion Ratio for Tax Purposes

For non-qualified SPIAs, a portion of each payment is a tax-free return of the original investment (premium). The **exclusion ratio** determines this tax-free portion.

**Exclusion Ratio Calculation (Simplified):**

```
Exclusion_Ratio = Investment_in_Contract / Expected_Return

Expected_Return = Annual_Payment × Expected_Number_of_Payments

For Life Annuity:
  Expected_Number_of_Payments = Life_Expectancy (from IRS Table V or Table VI)

For Period Certain:
  Expected_Number_of_Payments = Certain_Period_in_Years × Payment_Frequency

Tax_Free_Portion = Payment × Exclusion_Ratio
Taxable_Portion = Payment - Tax_Free_Portion
```

**Example:**
- Premium: $100,000
- Monthly payment: $550
- Annual payment: $6,600
- Annuitant age at start: 65
- Life expectancy (IRS Table V): 20 years
- Expected return: $6,600 × 20 = $132,000
- Exclusion ratio: $100,000 / $132,000 = 75.76%
- Tax-free per payment: $550 × 0.7576 = $416.68
- Taxable per payment: $550 - $416.68 = $133.32

**After the expected return period:** Once the total tax-free amount returned equals the investment in the contract, all subsequent payments are **fully taxable**.

**Exclusion Ratio Data Model:**

```
SPIA_TAX_TRACKING {
  contract_id              VARCHAR(20)  PK
  investment_in_contract   DECIMAL(15,2)
  expected_return          DECIMAL(15,2)
  exclusion_ratio          DECIMAL(8,6)
  annuity_start_date       DATE
  total_excluded_to_date   DECIMAL(15,2)
  remaining_exclusion      DECIMAL(15,2)
  exclusion_exhausted_date DATE
  tax_table_used           VARCHAR(20)  -- 'IRS_TABLE_V', 'IRS_TABLE_VI'
  irs_life_expectancy      DECIMAL(5,2)
}
```

### 5.6 SPIA — Key System Requirements

| Requirement | Details |
|---|---|
| **Payment generation** | Automated payment generation on schedule (monthly, quarterly, etc.) |
| **Payment method** | ACH direct deposit, check, wire |
| **Death notification processing** | Determine if beneficiary payments continue (certain period, refund) |
| **Tax reporting** | 1099-R with correct taxable/non-taxable split based on exclusion ratio |
| **COLA adjustments** | Increase payments per CPI or fixed percentage schedule |
| **Commutation** | Calculate present value of remaining payments for lump-sum settlement |
| **Mortality verification** | Periodic proof-of-life processes |
| **State unclaimed property** | Track returned payments and initiate escheatment process |

---

## 6. Deferred Income Annuities (DIA)

### 6.1 Overview

A Deferred Income Annuity (DIA), also called a **longevity annuity**, is a single-premium product that begins income payments at a future date, typically 2 to 40 years after purchase. DIAs leverage **longevity credits** — the mortality discount from the deferral period — to provide higher payout rates than SPIAs purchased at the same future age.

### 6.2 Longevity Credits

The mathematical foundation of DIAs is the **mortality discount** or **longevity credit**:

```
DIA_Payout_Factor = SPIA_Payout_Factor(at_income_age) / Survival_Probability(to_income_age)
```

Since `Survival_Probability < 1`, the DIA payout factor is always **higher** than the SPIA factor at the same age. This is because those who die during the deferral period forfeit their premium (in the simplest case), and their forfeited funds subsidize the survivors.

**Example:**
- Age 55, purchases DIA with income starting at age 80
- Probability of surviving from 55 to 80: approximately 65%
- SPIA factor at age 80: $10.50 per $1,000 monthly
- DIA effective factor: $10.50 / 0.65 = $16.15 per $1,000 monthly
- Plus: 25 years of interest accumulation on the premium

This combination of mortality credits and interest accumulation makes DIAs extremely efficient for longevity protection.

### 6.3 Payout Start Date Mechanics

| Feature | Details |
|---|---|
| **Minimum deferral** | 2 years (13 months minimum for most) |
| **Maximum deferral** | 30–40 years |
| **Income start date** | Specified at purchase; typically a birthday or contract anniversary |
| **Flexibility** | Some contracts allow a window (e.g., start income between age 75 and 85) |
| **Acceleration** | Some contracts allow earlier start at a reduced payout |
| **Delay** | Some contracts allow later start at an increased payout |

### 6.4 Death Benefit During Deferral

A critical product design question is what happens if the annuitant dies during the deferral period:

| Option | Description | Impact on Payout | Premium Cost |
|---|---|---|---|
| **No death benefit** (pure DIA) | Premium is forfeited | Highest payout (full mortality credit) | Lowest |
| **Return of premium** | Beneficiary receives original premium | Moderate payout reduction | Higher |
| **Return of premium + interest** | Beneficiary receives premium accumulated at a stated rate | Significant payout reduction | Even higher |
| **Cash refund at income start** | If annuitant dies after income starts, beneficiary receives premium less payments already made | Moderate reduction | Standard |
| **Period certain** | Income guaranteed for X years even if annuitant dies | Moderate reduction | Standard |
| **Installment refund** | Payments continue to beneficiary until total payments ≥ premium | Moderate reduction | Standard |

### 6.5 Commutation Provisions

Some DIAs include a **commutation benefit** allowing the contract owner to surrender the contract for a lump sum during the deferral period.

**Commutation Value Calculation:**

```
Commutation_Value = Premium × Commutation_Factor(year)

Typical Commutation Factor Schedule:
  Year 1: 92%
  Year 2: 93%
  Year 3: 94%
  ...
  Year 10: 100%+ (may include some accumulated interest)
```

Alternatively, the commutation value may be calculated as:

```
Commutation_Value = Present_Value_of_Future_Payments × Discount_Factor
```

Where the discount factor reflects the insurer's unwinding cost.

### 6.6 DIA Data Model

```
DIA_CONTRACT {
  contract_id            VARCHAR(20)   PK
  product_code           VARCHAR(10)
  purchase_date          DATE
  premium_amount         DECIMAL(15,2)
  income_start_date      DATE
  payout_option          ENUM('LIFE_ONLY','LIFE_PERIOD_CERTAIN','JOINT_LIFE',
                              'INSTALLMENT_REFUND','CASH_REFUND')
  projected_payout       DECIMAL(12,2) -- monthly income at start date
  payout_frequency       ENUM('MONTHLY','QUARTERLY','SEMI_ANNUAL','ANNUAL')
  deferral_death_benefit ENUM('NONE','RETURN_PREMIUM','RETURN_PREMIUM_INTEREST',
                              'CASH_REFUND','INSTALLMENT_REFUND')
  commutation_available  BOOLEAN
  commutation_schedule   VARCHAR(200) -- JSON or reference to schedule table
  annuitant_age_at_purchase INT
  annuitant_age_at_income   INT
  contract_status        ENUM('DEFERRAL','PAYING','DEATH_CLAIM_DEFERRAL',
                              'DEATH_CLAIM_PAYOUT','COMMUTED','COMPLETED')
  qlac_eligible          BOOLEAN       -- Qualifying Longevity Annuity Contract
}
```

### 6.7 Qualifying Longevity Annuity Contracts (QLAC)

QLACs are a special category of DIA purchased within qualified retirement plans (IRA, 401(k), etc.) that receive favorable RMD treatment.

| QLAC Rule | Requirement |
|---|---|
| **Maximum premium** | Lesser of $200,000 (indexed, was $125K pre-SECURE 2.0) or 25% of account balance |
| **Latest income start** | Age 85 |
| **RMD exclusion** | QLAC value excluded from RMD calculation until income begins |
| **Return of premium** | Must offer return-of-premium death benefit option |
| **No cash value** | Cannot have commutation or cash surrender features |
| **Reporting** | Insurer must file Form 1098-QA and provide annual statement to contract owner |
| **SECURE Act 2.0** | Eliminated the 25% limit, retained $200,000 cap (indexed for inflation) |

---

## 7. Qualified vs Non-Qualified Annuities

### 7.1 Overview

The tax qualification status of an annuity fundamentally affects taxation, contribution limits, distribution rules, and RMD requirements. Systems must handle both qualified and non-qualified contracts, each with distinct processing logic.

### 7.2 Non-Qualified (NQ) Annuities

Non-qualified annuities are purchased with after-tax dollars. Key tax characteristics:

| Feature | NQ Treatment |
|---|---|
| **Contributions** | Not tax-deductible |
| **Growth** | Tax-deferred |
| **Withdrawals** | LIFO — gains come out first (taxable as ordinary income) |
| **Cost basis** | Total premiums paid (after-tax) |
| **Exclusion ratio (annuitization)** | Applies — each payment split between return of basis and taxable gain |
| **10% penalty** | Applies to taxable portion of distributions before age 59½ |
| **RMDs** | Not required |
| **Death benefit taxation** | Beneficiary pays ordinary income tax on gain over cost basis |
| **1035 Exchange** | Tax-free exchange to another annuity, LTC, or life insurance |
| **Step-up in basis at death** | No — annuities do NOT receive a step-up in basis |

### 7.3 Traditional IRA Annuities

| Feature | IRA Annuity Treatment |
|---|---|
| **Contribution limits** | $7,000/year ($8,000 if 50+) (2024); may be deductible |
| **Growth** | Tax-deferred |
| **Distributions** | Fully taxable as ordinary income (if fully deductible contributions) |
| **Cost basis** | Non-deductible contributions tracked on Form 8606 |
| **10% penalty** | Before age 59½ (exceptions: 72(t), disability, etc.) |
| **RMDs** | Required beginning at age 73 (SECURE 2.0: age 75 starting 2033) |
| **Beneficiary** | Subject to SECURE Act 10-year distribution rule (exceptions for EDBs) |
| **Spousal rollover** | Surviving spouse can treat as own IRA |

### 7.4 Roth IRA Annuities

| Feature | Roth IRA Annuity Treatment |
|---|---|
| **Contributions** | After-tax (not deductible) |
| **Growth** | Tax-free (if qualified distribution) |
| **Qualified distributions** | Tax-free and penalty-free after age 59½ AND 5-year holding period |
| **Non-qualified distributions** | Contributions first (tax-free), then earnings (taxable + penalty) |
| **RMDs** | NOT required for original owner (SECURE 2.0 eliminated Roth 401k RMDs too) |
| **Beneficiary** | Tax-free distributions but subject to 10-year rule |
| **Roth conversion** | Can convert traditional IRA annuity to Roth (taxable event) |

### 7.5 403(b) Tax-Sheltered Annuity (TSA)

| Feature | 403(b) TSA Treatment |
|---|---|
| **Eligible employers** | Public schools, 501(c)(3) organizations |
| **Contribution limits** | $23,000 employee deferral ($30,500 if 50+) (2024); employer match additional |
| **Investment options** | Annuities and mutual funds (custodial accounts) |
| **Special catch-up** | 15-year service catch-up (up to $3,000/year additional) |
| **Distributions** | Taxable as ordinary income |
| **Hardship withdrawals** | Available under certain conditions |
| **Loans** | Permitted (subject to plan provisions) |
| **RMDs** | Required beginning at age 73 (75 in 2033) |
| **90-24 transfers** | Can transfer between 403(b) providers without employer consent |
| **Incidental benefit rule** | Life insurance inside 403(b) limited by incidental benefit rule |

### 7.6 401(k) and 401(a) Annuities

| Feature | Details |
|---|---|
| **401(k) deferral limit** | $23,000 ($30,500 if 50+) (2024) |
| **401(a) total limit** | $69,000 or 100% of compensation (2024) |
| **Annuity as investment** | Annuity can be an investment option within the plan |
| **Annuity as distribution** | Plan can distribute benefits as an annuity (required for defined benefit) |
| **QJSA/QPSA requirements** | Qualified joint and survivor annuity; qualified pre-retirement survivor annuity |
| **Fiduciary considerations** | ERISA fiduciary rules apply to annuity selection |
| **Portability** | Can roll over to IRA or another plan at separation |
| **SECURE Act annuity portability** | Allows in-plan annuity to be distributed in-kind if option eliminated from plan |

### 7.7 Pension Plan Annuities

Defined benefit pension plans often use group annuity contracts for benefit distribution:

| Feature | Details |
|---|---|
| **Pension risk transfer (PRT)** | Employer purchases group annuity to transfer pension obligations |
| **Buy-out** | Full transfer of pension liability to insurer |
| **Buy-in** | Insurer investment backs pension promises; plan retains liability |
| **Longevity swap** | Insurer assumes longevity risk only |
| **Section 417(e) rates** | IRC section governing lump-sum conversions |
| **PBGC** | Pension Benefit Guaranty Corporation provides backstop |

### 7.8 Tax Treatment Comparison Matrix

| Feature | Non-Qualified | Traditional IRA | Roth IRA | 403(b) | 401(k) |
|---|---|---|---|---|---|
| **Contributions deductible?** | No | Maybe | No | Yes (pre-tax) | Yes (pre-tax) |
| **Growth** | Tax-deferred | Tax-deferred | Tax-free | Tax-deferred | Tax-deferred |
| **Distribution taxation** | Gain only | Full amount | Tax-free* | Full amount | Full amount |
| **10% early penalty** | Yes (on gain) | Yes | Yes (on earnings) | Yes | Yes |
| **RMD required** | No | Yes (73/75) | No (owner) | Yes | Yes |
| **RMD start age** | N/A | 73/75 | N/A | 73/75 | 73/75 |
| **1035 exchange** | Yes | N/A (rollover) | N/A (rollover) | N/A | N/A |
| **Rollover** | No | Yes | Yes | Yes | Yes |
| **Stretch for beneficiary** | 5 yr or annuitize | 10-year rule | 10-year rule | 10-year rule | 10-year rule |
| **Spousal rollover** | No | Yes | Yes | Yes | Yes |
| **Creditor protection** | Varies by state | Federal (ERISA-like) | Federal | ERISA | ERISA |

*Qualified distribution after 59½ and 5-year holding period.

### 7.9 Tax Qualification Data Model

```
CONTRACT_TAX_QUALIFICATION {
  contract_id          VARCHAR(20)   PK
  tax_status           ENUM('NQ','TRAD_IRA','ROTH_IRA','SEP_IRA','SIMPLE_IRA',
                            '403B','401K','401A','457B','PENSION','QLAC','INHERITED_IRA',
                            'INHERITED_ROTH','INHERITED_NQ')
  plan_id              VARCHAR(20)   -- for employer-sponsored
  plan_name            VARCHAR(100)
  employer_ein         VARCHAR(10)
  contribution_year    INT
  annual_contribution  DECIMAL(12,2)
  cumulative_contributions DECIMAL(15,2)
  cost_basis           DECIMAL(15,2) -- after-tax amount (NQ, Roth, non-deductible IRA)
  rmd_begin_date       DATE
  rmd_begin_age        INT
  qlac_amount          DECIMAL(15,2) -- if QLAC
  beneficiary_stretch_type ENUM('SPOUSE','EDB','NON_EDB','MINOR_CHILD','DISABLED')
  inherited_date       DATE
  inherited_from_dod   DATE          -- date of death of original owner
  five_year_clock_start DATE         -- for Roth 5-year rule
}
```

### 7.10 RMD Calculation Requirements

Required Minimum Distribution calculations are a major system requirement:

**RMD Formula:**

```
RMD(year) = Account_Value(Dec_31_prior_year) / Life_Expectancy_Factor(age)
```

| Table | Used For | Source |
|---|---|---|
| **Uniform Lifetime Table** | Most IRA owners (unmarried or spouse not >10 years younger) | IRS Pub 590-B |
| **Joint Life and Last Survivor Table** | Spouse sole beneficiary >10 years younger | IRS Pub 590-B |
| **Single Life Expectancy Table** | Beneficiaries (inherited IRAs) | IRS Pub 590-B |

**Updated Tables (effective 2022):** The SECURE Act and subsequent regulations updated the life expectancy tables, increasing factors and reducing RMD amounts.

**System Requirements for RMD:**
1. Track fair market value as of December 31 for each qualified contract
2. Calculate RMD based on appropriate table and owner's age/birthday
3. Support aggregation (IRA owner can take total IRA RMD from any IRA)
4. Report FMV on Form 5498 (box 5)
5. Report RMD amount on Form 5498 (box 12b)
6. Handle first-year deferral (can delay first RMD to April 1 of following year)
7. Support systematic RMD payments
8. Handle QLAC exclusion from FMV for RMD purposes
9. Handle inherited IRA/beneficiary RMD rules (10-year rule, exceptions)

---

## 8. Guaranteed Living Benefits

### 8.1 Overview

Guaranteed Living Benefits (GLBs) are optional riders attached to deferred annuities (primarily VAs and FIAs) that provide guarantees on income, withdrawals, or account value while the contract owner is alive. These riders are the most complex features in annuity administration and represent the most significant actuarial, hedging, and system challenges.

### 8.2 Guaranteed Minimum Withdrawal Benefit (GMWB)

#### 8.2.1 Mechanics

The GMWB guarantees that the contract owner can withdraw a total amount at least equal to their original investment, regardless of investment performance, through a series of periodic withdrawals over time.

**Key Parameters:**

| Parameter | Typical Value |
|---|---|
| **Benefit base** | Initial premium (may include bonus) |
| **Annual withdrawal amount** | Typically 5–7% of benefit base |
| **Guarantee period** | Until benefit base is exhausted (14–20 years at 5–7%) |
| **Step-up** | Benefit base resets to higher of: current AV or current benefit base (annual ratchet) |
| **Rider fee** | 0.50% – 1.25% of benefit base annually |

**GMWB Mechanics:**

```
Year 0: Premium = $100,000, Benefit_Base = $100,000
Annual_Withdrawal_Amount = 7% × $100,000 = $7,000/year
Maximum_Guaranteed_Withdrawal = $100,000 (over 14.3 years at $7,000/year)

IF Account_Value > 0:
    Withdrawal comes from Account_Value (reduces AV)
    Benefit_Base reduces by withdrawal amount
ELSE IF Account_Value = 0 AND Benefit_Base > 0:
    Insurer funds remaining guaranteed withdrawals
    This is the "guarantee in action"
```

### 8.3 Guaranteed Lifetime Withdrawal Benefit (GLWB)

#### 8.3.1 Mechanics

The GLWB is the most popular living benefit rider. It guarantees a stream of withdrawals for the contract owner's **lifetime**, regardless of account value performance.

**Key Parameters:**

| Parameter | Description | Typical Values |
|---|---|---|
| **Benefit Base (BB)** | The notional value used to calculate withdrawal amounts; NOT a cash value | Initial premium, grows via roll-up and/or step-ups |
| **Roll-Up Rate** | Rate at which BB grows during the accumulation phase (before withdrawals begin) | 4% – 8% simple or compound; subject to maximum BB or duration |
| **Roll-Up Period** | Maximum period for roll-up | 10–20 years |
| **Step-Up (Ratchet)** | BB resets to higher of current AV or current BB on each anniversary | Annual, automatic or elected |
| **Withdrawal Percentage** | Percentage of BB available as annual lifetime withdrawal | Varies by age at first withdrawal |
| **Rider Fee** | Annual charge, deducted from AV | 0.75% – 1.50% of BB (or AV) |
| **Excess Withdrawal** | Withdrawal above the guaranteed amount | Proportionally reduces BB |

#### 8.3.2 Withdrawal Percentages by Age

| Age at First Withdrawal | Single Life % | Joint Life % |
|---|---|---|
| 55–59 | 3.50% – 4.00% | 3.00% – 3.50% |
| 60–64 | 4.00% – 5.00% | 3.50% – 4.50% |
| 65–69 | 5.00% – 5.50% | 4.50% – 5.00% |
| 70–74 | 5.50% – 6.00% | 5.00% – 5.50% |
| 75–79 | 6.00% – 6.50% | 5.50% – 6.00% |
| 80+ | 6.50% – 7.00% | 6.00% – 6.50% |

#### 8.3.3 Roll-Up Mechanics

**Simple Roll-Up:**

```
BB(t) = BB(0) + BB(0) × Roll_Up_Rate × t
```

**Compound Roll-Up:**

```
BB(t) = BB(0) × (1 + Roll_Up_Rate)^t
```

**Example (Compound 6% for 10 years):**

```
BB(0) = $100,000
BB(10) = $100,000 × (1.06)^10 = $179,085

Withdrawal at age 65 (5.0%): $179,085 × 5.0% = $8,954/year
```

**Roll-Up Maximum:**
Many contracts cap the BB at 2× or 2.5× the initial premium:

```
BB(t) = MIN(BB(0) × (1 + Roll_Up_Rate)^t, BB(0) × Max_Multiplier)
```

#### 8.3.4 Step-Up (Ratchet) Mechanics

On each contract anniversary:

```
IF AV(anniversary) > BB(current):
    BB(new) = AV(anniversary)
    -- Some contracts: rider fee may increase, withdrawal % may change
    -- Some contracts: roll-up timer resets
ELSE:
    BB remains unchanged
```

#### 8.3.5 Excess Withdrawal Impact

Excess withdrawals (amounts above the guaranteed annual withdrawal) reduce the benefit base **proportionally**, not dollar-for-dollar:

**Proportional Reduction Formula:**

```
Excess_Amount = Total_Withdrawal - Annual_Guaranteed_Withdrawal
Reduction_Ratio = Excess_Amount / (AV_Before_Withdrawal - Annual_Guaranteed_Withdrawal)
BB_After = BB_Before × (1 - Reduction_Ratio)
```

**Example:**
- BB = $200,000, AV = $150,000, Annual GW = $10,000
- Owner withdraws $50,000 total
- Excess = $50,000 - $10,000 = $40,000
- Reduction_Ratio = $40,000 / ($150,000 - $10,000) = 28.57%
- BB_After = $200,000 × (1 - 0.2857) = $142,860
- AV_After = $150,000 - $50,000 = $100,000

**If AV goes to zero from excess withdrawal:**
- BB may be reduced to zero (contract terminated)
- Some contracts have an "account value depletion protection" — if AV goes to zero solely from guaranteed withdrawals (not excess), the guarantee continues

#### 8.3.6 GLWB Data Model

```
GLWB_RIDER {
  contract_id            VARCHAR(20)   PK
  rider_code             VARCHAR(10)
  rider_effective_date   DATE
  benefit_base           DECIMAL(15,2)
  initial_benefit_base   DECIMAL(15,2)
  roll_up_rate           DECIMAL(6,5)
  roll_up_type           ENUM('SIMPLE','COMPOUND')
  roll_up_end_date       DATE
  roll_up_max_multiplier DECIMAL(4,2)
  step_up_type           ENUM('AUTOMATIC','ELECTED','NONE')
  step_up_frequency      ENUM('ANNUAL','TRIENNIAL','QUINQUENNIAL')
  withdrawal_pct         DECIMAL(5,4)
  withdrawal_age_band    VARCHAR(10)  -- e.g., '65-69'
  annual_withdrawal_amount DECIMAL(12,2)
  coverage_type          ENUM('SINGLE','JOINT')
  joint_annuitant_id     VARCHAR(20)
  rider_fee_rate         DECIMAL(6,5)
  rider_fee_basis        ENUM('BENEFIT_BASE','ACCOUNT_VALUE','HIGHER_OF')
  rider_fee_frequency    ENUM('QUARTERLY','ANNUALLY')
  first_withdrawal_date  DATE
  cumulative_withdrawals DECIMAL(15,2)
  cumulative_excess_withdrawals DECIMAL(15,2)
  status                 ENUM('ACCUMULATION','WITHDRAWAL','AV_DEPLETED_PAYING',
                              'TERMINATED','DEATH_CLAIM')
}

GLWB_BENEFIT_BASE_HISTORY {
  contract_id            VARCHAR(20)   PK
  effective_date         DATE          PK
  event_type             ENUM('INITIAL','ROLL_UP','STEP_UP','EXCESS_REDUCTION',
                              'PREMIUM_ADDITION','RESET','ENHANCEMENT')
  prior_bb               DECIMAL(15,2)
  new_bb                 DECIMAL(15,2)
  trigger_value          DECIMAL(15,2) -- e.g., AV at step-up
  notes                  VARCHAR(200)
}
```

### 8.4 Guaranteed Minimum Income Benefit (GMIB)

#### 8.4.1 Mechanics

The GMIB guarantees that, at a future date, the contract owner can annuitize at rates that will provide a minimum income amount, regardless of account performance.

**Key Difference from GLWB:** The GMIB requires **annuitization** — the contract owner must convert to an irrevocable income stream to exercise the guarantee. The GLWB provides guaranteed withdrawals without annuitization.

**Parameters:**

| Parameter | Typical Value |
|---|---|
| **Benefit base** | Initial premium |
| **Roll-up rate** | 5% – 7% compound |
| **Waiting period** | 7–10 years before exercisable |
| **Annuitization rates** | Guaranteed purchase rates specified in the rider |
| **Exercise window** | Annually after waiting period, on anniversary |

**GMIB Calculation:**

```
Step 1: Determine Benefit Base at Exercise
  BB = MAX(AV, Premium × (1 + Roll_Up_Rate)^n)

Step 2: Apply Guaranteed Annuity Purchase Rates
  IF BB > AV:
    Guaranteed_Income = BB × Guaranteed_Annuity_Factor
    -- Annuity factor based on rider's guaranteed purchase rates (often less favorable than current market)
  ELSE:
    Owner can simply annuitize at current AV using current market rates
    -- No need to exercise GMIB if AV > BB

Step 3: Determine if Exercise is Beneficial
  Compare: BB × Guaranteed_Factor vs AV × Current_Market_Factor
  Exercise GMIB only if guarantee provides more income
```

### 8.5 Guaranteed Minimum Accumulation Benefit (GMAB)

#### 8.5.1 Mechanics

The GMAB guarantees that after a specified period (typically 10 years), the account value will be at least equal to a guaranteed minimum (typically the original premium or premium enhanced by a roll-up).

**Parameters:**

| Parameter | Typical Value |
|---|---|
| **Guarantee period** | 10 years (most common) |
| **Guaranteed amount** | Original premium (or premium × 1.0x to 1.5x) |
| **Trigger** | At end of guarantee period, if AV < Guaranteed_Amount |
| **Adjustment** | Insurer adds to AV to bring it up to guaranteed amount |
| **Renewability** | Some contracts allow a second 10-year period |

**GMAB Calculation:**

```
At end of guarantee period:
IF AV < Guaranteed_Amount:
    Insurer_Top_Up = Guaranteed_Amount - AV
    AV(new) = AV + Insurer_Top_Up
ELSE:
    No action needed (market performed well enough)
```

### 8.6 Living Benefit Comparison Matrix

| Feature | GMWB | GLWB | GMIB | GMAB |
|---|---|---|---|---|
| **Guarantee type** | Total withdrawal amount | Lifetime income | Annuitization income | Account value |
| **Duration** | Until BB exhausted | Lifetime | After waiting period | Fixed period (10 yr) |
| **Requires annuitization** | No | No | Yes | No |
| **Withdrawal flexibility** | Scheduled amounts | Scheduled % of BB | N/A until exercised | Full access (but may reduce guarantee) |
| **Roll-up available** | Sometimes | Yes (common) | Yes | Sometimes |
| **Step-up available** | Yes | Yes | Sometimes | N/A |
| **Excess withdrawal impact** | Proportional BB reduction | Proportional BB reduction | May reduce guaranteed income | May void guarantee |
| **Typical rider fee** | 0.50% – 1.00% | 0.75% – 1.50% | 0.50% – 1.25% | 0.25% – 0.75% |
| **Popularity (current)** | Low | Very High | Low (declining) | Low |
| **Primary use case** | Systematic withdrawals | Retirement income | High minimum income | Principal protection |
| **Product attachment** | VA, FIA | VA, FIA | VA | VA |

### 8.7 Reset Provisions

Many living benefit riders include a **reset** or **step-up** feature that allows the contract owner to "reset" the rider, typically by:

1. Resetting the benefit base to the current (higher) AV
2. Restarting the roll-up period
3. Potentially changing to a new rider fee schedule
4. Potentially changing the withdrawal percentage

**Reset Considerations:**
- Resets are typically available on contract anniversaries
- Some resets are automatic; others require election
- Resets may increase the rider fee rate (new series of riders often have higher fees)
- Age limits may apply (e.g., reset not available after age 80)
- The "stepping up" of AV may restart any waiting period for GMIB

### 8.8 Living Benefit — Rider Charges

Rider charges are critical for both the policyholder and the insurer's profitability:

**Charge Deduction Methods:**

| Method | Description | Timing |
|---|---|---|
| **Deducted from AV** | Direct reduction to account value | Quarterly or annually |
| **Deducted from units** | Surrender of sub-account units | Daily or quarterly |
| **Included in M&E** | Bundled into the base M&E charge | Daily |

**Charge Basis:**

| Basis | Formula | Impact |
|---|---|---|
| **Account Value** | Charge = AV × Rider_Fee_Rate | Charge decreases if AV declines (aligns with insurer risk) |
| **Benefit Base** | Charge = BB × Rider_Fee_Rate | Charge stays high even if AV declines (more punitive to owner, more protective for insurer) |
| **Higher of AV or BB** | Charge = MAX(AV, BB) × Rider_Fee_Rate | Conservative approach |
| **Net Amount at Risk (NAR)** | Charge = (BB - AV) × Rate (if BB > AV) | Most risk-aligned but complex |

---

## 9. Guaranteed Death Benefits

### 9.1 Overview

Guaranteed Death Benefits (GDBs) provide a minimum amount payable to beneficiaries upon the annuitant's or owner's death. Unlike life insurance, annuity death benefits are generally funded from the contract's account value or a separate insurance charge, not from a standalone mortality pool.

### 9.2 Death Benefit Types

#### 9.2.1 Standard Death Benefit (Return of Account Value)

The most basic death benefit — pays the current account value at the time of death.

```
Death_Benefit = Account_Value(date_of_death)
```

No additional cost; this is the default in virtually all annuity contracts.

#### 9.2.2 Return of Premium (ROP)

Guarantees that beneficiaries receive at least the total premiums paid, less any prior withdrawals.

```
Death_Benefit = MAX(Account_Value, Total_Premiums - Cumulative_Withdrawals)
```

**Adjusted for Withdrawals:**
Some contracts reduce the ROP guarantee dollar-for-dollar for withdrawals; others use a proportional reduction:

**Dollar-for-Dollar:**
```
ROP_Guarantee = Total_Premiums - Total_Withdrawals
```

**Proportional:**
```
Withdrawal_Ratio = Withdrawal_Amount / AV_Before_Withdrawal
ROP_Guarantee(new) = ROP_Guarantee(old) × (1 - Withdrawal_Ratio)
```

#### 9.2.3 Highest Anniversary Value (HAV) / Annual Ratchet

The death benefit equals the highest account value on any contract anniversary, adjusted for subsequent premiums and withdrawals.

```
HAV = MAX(AV(anniversary_1), AV(anniversary_2), ..., AV(anniversary_n))

Death_Benefit = MAX(Current_AV, HAV_adjusted_for_withdrawals)
```

**Typical Restrictions:**
- Ratchet stops at a certain age (e.g., 80 or 85)
- After the age limit, death benefit is frozen at the last ratchet value
- Withdrawals reduce the HAV proportionally

#### 9.2.4 Ratchet Plus Roll-Up Combination

Some enhanced death benefits combine an annual ratchet with a guaranteed growth rate (roll-up):

```
Roll_Up_DB = Total_Premiums × (1 + Roll_Up_Rate)^n - Proportional_Withdrawal_Adjustment
HAV_DB = MAX(AV(anniversary_1), ..., AV(anniversary_n)) - Proportional_Withdrawal_Adjustment

Death_Benefit = MAX(Current_AV, Roll_Up_DB, HAV_DB)
```

**Roll-Up Rates:** Typically 3% – 7% per year, with a cap (e.g., 200% of premium).

#### 9.2.5 Enhanced Earnings Death Benefit

This benefit adds a percentage of the contract's gain to the standard death benefit:

```
Gain = MAX(0, AV - Total_Premiums)
Enhancement = Gain × Enhancement_Pct (e.g., 25%, 40%)
Death_Benefit = AV + Enhancement
```

**Variations:**
- Enhancement may be capped (e.g., $25,000 or $50,000 maximum enhancement)
- Enhancement percentage may vary by age at death
- Some contracts enhance the net gain (AV minus premium); others enhance total AV

### 9.3 Spousal Continuation

When the owner/annuitant dies and the surviving spouse is the beneficiary, most contracts offer a **spousal continuation** option:

| Feature | Spousal Continuation | Standard Beneficiary |
|---|---|---|
| **Contract status** | Continues in force | Must be settled (lump sum, annuitize, or 5/10-year distribution) |
| **Tax treatment** | No taxable event at continuation | Death benefit may be partially taxable |
| **Death benefit** | May step up to current AV | N/A (contract settled) |
| **Living benefits** | Continue under rider terms (may reset) | Terminate at owner death |
| **Ownership** | Spouse becomes new owner | N/A |
| **Beneficiary** | Spouse names new beneficiary | N/A |

**Spousal Continuation Process:**
1. Death notification received
2. Verify spousal beneficiary status
3. Determine if death benefit exceeds AV
4. If DB > AV, add the "death benefit enhancement" to AV
5. Reset death benefit base to new AV
6. Transfer ownership to surviving spouse
7. Update beneficiary designations
8. Continue rider benefits per rider terms
9. No 1099-R issued at continuation (tax-deferred)

### 9.4 Death Benefit Data Model

```
DEATH_BENEFIT_DEFINITION {
  product_code           VARCHAR(10)   PK
  db_type                ENUM('STANDARD_AV','RETURN_OF_PREMIUM','HIGHEST_ANNIVERSARY',
                              'RATCHET_ROLLUP','ENHANCED_EARNINGS','GREATER_OF',
                              'PERCENT_PREMIUM_GROWTH')  PK
  db_version             INT           PK
  roll_up_rate           DECIMAL(6,5)  -- for roll-up types
  roll_up_cap_pct        DECIMAL(5,4)  -- max as % of premium
  enhancement_pct        DECIMAL(5,4)  -- for enhanced earnings
  enhancement_cap        DECIMAL(12,2) -- dollar cap on enhancement
  ratchet_max_age        INT           -- age at which ratchet freezes
  rider_fee_rate         DECIMAL(6,5)
  rider_fee_basis        ENUM('AV','DB_BASE','NAR')
  withdrawal_adjustment  ENUM('DOLLAR_FOR_DOLLAR','PROPORTIONAL')
  spousal_continuation   BOOLEAN
  step_up_on_continuation BOOLEAN
}

CONTRACT_DEATH_BENEFIT {
  contract_id            VARCHAR(20)   PK
  db_type                VARCHAR(30)
  current_db_amount      DECIMAL(15,2)
  rop_base               DECIMAL(15,2)
  hav_base               DECIMAL(15,2)
  rollup_base            DECIMAL(15,2)
  enhanced_earnings_base DECIMAL(15,2)
  last_ratchet_date      DATE
  last_ratchet_value     DECIMAL(15,2)
  ratchet_frozen         BOOLEAN
  ratchet_frozen_date    DATE
}

DEATH_BENEFIT_RATCHET_HISTORY {
  contract_id            VARCHAR(20)   PK
  anniversary_date       DATE          PK
  anniversary_av         DECIMAL(15,2)
  prior_hav              DECIMAL(15,2)
  new_hav                DECIMAL(15,2)
  ratchet_applied        BOOLEAN
}
```

### 9.5 Death Benefit Settlement Options

When the annuitant/owner dies, the beneficiary typically has these settlement options:

| Option | Description | Tax Treatment |
|---|---|---|
| **Lump sum** | Immediate full payment | Gain over cost basis taxed as ordinary income in year received |
| **5-year rule** | Distribute entire balance within 5 years of death | Flexible timing; all must be distributed by end of 5th year |
| **10-year rule (SECURE Act)** | Distribute entire balance within 10 years | Applies to most non-spouse beneficiaries |
| **Annuitization** | Convert to life annuity over beneficiary's life expectancy | Taxed under exclusion ratio; spread over life |
| **Spousal continuation** | Spouse continues contract as new owner | No immediate tax; deferred |
| **Inherited annuity** | Maintain account; take distributions over time | Subject to SECURE Act rules |

### 9.6 Death Claim Processing — System Requirements

| Step | System Requirement |
|---|---|
| **1. Death notification** | Record date of death, cause (if relevant for contestability), source of notification |
| **2. Verification** | Match death certificate, verify contract status, check contestability period |
| **3. DB calculation** | Calculate all applicable death benefit amounts; determine highest |
| **4. Beneficiary verification** | Confirm beneficiary designation, verify identity, check for competing claims |
| **5. Settlement election** | Present options to beneficiary; record election |
| **6. Tax calculation** | Determine taxable gain (DB amount minus cost basis) |
| **7. Payment processing** | Issue payment per elected method (lump sum, annuitize, etc.) |
| **8. Tax reporting** | Issue 1099-R with appropriate distribution code |
| **9. Rider termination** | Terminate all riders; process final rider charges |
| **10. Contract closure** | Update contract status; archive records |

---

## 10. Group Annuities

### 10.1 Overview

Group annuities are contracts issued to an employer, plan sponsor, or other entity for the benefit of a group of participants. They differ from individual annuities in contract structure, administration, regulation, and system requirements.

### 10.2 Group Variable Annuity (GVA) Contracts

Group variable annuities are used primarily in employer-sponsored retirement plans (401(k), 403(b), 457):

| Feature | Group VA | Individual VA |
|---|---|---|
| **Contract holder** | Employer/plan sponsor | Individual |
| **Participants** | Multiple employees/members | Single contract owner |
| **Customization** | Fund lineup customized for plan | Standard product fund lineup |
| **Fees** | Negotiated; often lower | Published schedule |
| **Death benefit** | Plan-defined | Product-defined |
| **Living benefits** | Rarely offered | Commonly available |
| **Regulatory** | ERISA + SEC + state insurance | SEC + state insurance |
| **Recordkeeping** | Carrier may serve as recordkeeper | Standard admin system |
| **Compliance** | Plan-level testing, ERISA reporting | Individual suitability |

### 10.3 Guaranteed Investment Contracts (GICs)

A GIC is a group annuity contract that guarantees a fixed rate of return for a specified period on a lump-sum deposit.

#### 10.3.1 Traditional (Bullet) GIC

| Feature | Details |
|---|---|
| **Structure** | Lump-sum deposit, guaranteed rate, lump-sum maturity |
| **Term** | 1–5 years (typically) |
| **Rate** | Fixed for the full term |
| **Issuer** | Insurance company general account |
| **Credit risk** | Full exposure to issuer's claims-paying ability |
| **Accounting** | Carried at book value (contract value) in the plan |
| **Liquidity** | Typically no early withdrawal; some allow benefit-responsive withdrawals |

#### 10.3.2 Window GIC

A GIC that accepts deposits over a "window" period (e.g., 3 months) rather than as a single lump sum.

| Feature | Details |
|---|---|
| **Deposit period** | 1–6 months (deposit window) |
| **Rate** | Same guaranteed rate for all deposits within the window |
| **Term** | 1–5 years from the end of the deposit window |
| **Use case** | Plans that receive periodic contributions (payroll deposits) |

#### 10.3.3 Participating GIC

| Feature | Details |
|---|---|
| **Structure** | Minimum guaranteed rate plus participation in portfolio performance |
| **Upside** | Additional crediting if portfolio exceeds minimum |
| **Downside** | Floor at minimum guaranteed rate |
| **Transparency** | Insurer may share portfolio composition and performance |

### 10.4 Stable Value Funds / Wraps

Stable value is the most common fixed-income option in defined contribution plans. It uses **wrap contracts** to maintain book value accounting for a portfolio of bonds.

#### 10.4.1 Synthetic GIC Structure

```
Stable Value Fund = Bond Portfolio (at market value) + Wrap Contract(s)

The Wrap Contract provides:
  - Book value guarantee for benefit-responsive withdrawals
  - Smoothing of market-to-book ratio through crediting rate formula
```

**Crediting Rate Formula (Standard):**

```
Crediting_Rate = Yield_of_Portfolio × (Market_Value / Book_Value) × Duration_Adjustment

More precisely:
CR = [(MV / BV) ^ (1 / Duration)] × (1 + Yield) - 1
```

Where:
- `MV` = Current market value of the bond portfolio
- `BV` = Book value (accumulated contributions plus credited interest minus withdrawals)
- `Duration` = Weighted average duration of the portfolio
- `Yield` = Yield-to-maturity of the portfolio

When MV < BV (e.g., rising rate environment), the crediting rate is below the portfolio yield, gradually bringing BV back toward MV over time. When MV > BV, the crediting rate exceeds the yield.

#### 10.4.2 Wrap Provider Types

| Provider Type | Examples | Wrap Fee |
|---|---|---|
| Insurance company | MetLife, Prudential, TIAA | 10–25 bps |
| Bank | JP Morgan, State Street, Bank of America | 8–20 bps |
| Combined | Multiple wraps on same portfolio | 15–30 bps total |

#### 10.4.3 Benefit-Responsive Events

Wrap contracts typically cover withdrawals that are "benefit-responsive" — initiated by plan participants for legitimate reasons:

| Benefit-Responsive | Non-Benefit-Responsive |
|---|---|
| Participant withdrawals/distributions | Employer-directed transfers |
| Participant-directed transfers to other plan options | Plan termination (may be covered at a discount) |
| Loans | Investment manager change (may have restrictions) |
| Hardship withdrawals | Competing fund addition |
| RMDs | Spin-off of plan segment |

### 10.5 Plan-Level vs Participant-Level Recordkeeping

| Model | Description | Use Case | System Requirements |
|---|---|---|---|
| **Plan-level (unallocated)** | Single contract with aggregate accounting; plan sponsor or TPA allocates to participants | Small plans, GICs | Simpler; track aggregate deposits and withdrawals |
| **Participant-level (allocated)** | Each participant has an individual certificate or sub-account within the group contract | Large plans, 403(b), recordkeeping platforms | Complex; full individual accounting, fund transfers, beneficiary tracking |

**Participant-Level Data Model:**

```
GROUP_CONTRACT {
  contract_id            VARCHAR(20)   PK
  plan_id                VARCHAR(20)
  plan_name              VARCHAR(100)
  plan_type              ENUM('401K','403B','457B','DB','PENSION_RISK_TRANSFER')
  contract_type          ENUM('GVA','GIC','SYNTHETIC_GIC','STABLE_VALUE','DA')
  effective_date         DATE
  plan_sponsor_name      VARCHAR(100)
  plan_sponsor_ein       VARCHAR(10)
  total_assets           DECIMAL(18,2)
  participant_count      INT
}

PARTICIPANT_ACCOUNT {
  contract_id            VARCHAR(20)   PK
  participant_id         VARCHAR(20)   PK
  ssn_encrypted          VARBINARY(256)
  enrollment_date        DATE
  account_balance        DECIMAL(15,2)
  vested_balance         DECIMAL(15,2)
  money_type_breakout    JSON          -- pre-tax, Roth, employer match, etc.
  investment_elections    JSON          -- current allocation percentages
  beneficiary_designation JSON
  loan_balance           DECIMAL(12,2)
  deferral_pct           DECIMAL(5,4)
  status                 ENUM('ACTIVE','TERMINATED','RETIRED','DECEASED','SUSPENDED')
}

MONEY_TYPE_DEFINITION {
  money_type_code        VARCHAR(10)   PK
  money_type_name        VARCHAR(50)   -- 'Employee Pre-Tax', 'Employer Match', 'Roth', etc.
  source                 ENUM('EMPLOYEE','EMPLOYER','ROLLOVER')
  tax_status             ENUM('PRE_TAX','AFTER_TAX','ROTH')
  vesting_schedule_id    VARCHAR(10)
  forfeiture_eligible    BOOLEAN
}
```

### 10.6 Group Annuity — Regulatory Requirements

| Regulation | Requirement |
|---|---|
| **ERISA** | Fiduciary standards, reporting (5500), disclosure, prohibited transactions |
| **DOL** | Fee disclosure (408(b)(2)), participant fee disclosure (404a-5), fiduciary rule |
| **IRS** | Plan qualification, contribution limits, RMD, nondiscrimination testing |
| **SEC** | Registration of group VA separate accounts |
| **State insurance** | Filing of group annuity contracts, reserve requirements |
| **PPA 2006** | QDIA (Qualified Default Investment Alternative) provisions |
| **SECURE Act** | Lifetime income illustrations, annuity portability, safe harbor for annuity selection |

---

## 11. System Architecture Implications

### 11.1 Data Model Differences by Product Type

Each annuity product type requires distinct data structures. The table below summarizes the major data entity differences:

| Data Entity | Fixed | MYGA | VA | FIA | RILA | SPIA | DIA | Group |
|---|---|---|---|---|---|---|---|---|
| **Contract header** | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| **Rate history** | ✓ | ✓ | — | ✓ | — | — | — | ✓ (GIC) |
| **Sub-account positions** | — | — | ✓ | — | — | — | — | ✓ (GVA) |
| **Unit accounting** | — | — | ✓ | — | — | — | — | ✓ (GVA) |
| **Index strategy allocations** | — | — | — | ✓ | ✓ | — | — | — |
| **Segment tracking** | — | — | — | — | ✓ | — | — | — |
| **Payout schedule** | — | — | — | — | — | ✓ | ✓ (future) | ✓ (pension) |
| **Exclusion ratio** | — | — | — | — | — | ✓ | ✓ | — |
| **Living benefit rider** | — | — | ✓ | ✓ | Limited | — | — | — |
| **Death benefit tracking** | ✓ | ✓ | ✓ | ✓ | ✓ | — | ✓ | ✓ |
| **MVA parameters** | Maybe | Maybe | — | — | — | — | — | — |
| **Surrender schedule** | ✓ | ✓ | ✓ | ✓ | ✓ | — | — | — |
| **Bonus tracking** | Maybe | Maybe | — | Maybe | — | — | — | — |
| **Participant accounts** | — | — | — | — | — | — | — | ✓ |
| **Wrap contracts** | — | — | — | — | — | — | — | ✓ (SV) |
| **Fee schedule** | Simple | Simple | Complex | Medium | Medium | — | — | Complex |
| **Prospectus tracking** | — | — | ✓ | — | ✓ | — | — | ✓ (GVA) |
| **Cost basis tracking** | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |

### 11.2 Calculation Engine Requirements

The calculation engine is the heart of any annuity administration system. Requirements vary dramatically by product type:

#### 11.2.1 Fixed/MYGA Calculation Engine

| Calculation | Complexity | Frequency | Notes |
|---|---|---|---|
| Interest crediting | Low | Daily/Monthly | Apply declared rate |
| Surrender value | Low | On-demand | AV minus surrender charge |
| MVA (if applicable) | Medium | On-demand | Requires reference rate lookup |
| Bonus vesting | Low | On anniversary | Apply vesting schedule |
| Free withdrawal tracking | Low | Per transaction | Track annual allowance |
| RMD | Medium | Annual | Per IRS tables |

#### 11.2.2 Variable Annuity Calculation Engine

| Calculation | Complexity | Frequency | Notes |
|---|---|---|---|
| Daily valuation | High | Every business day | NAV × units for each sub-account |
| M&E deduction | Medium | Daily | Apply daily rate to AV |
| Living benefit tracking | Very High | Daily/On-event | Multiple formulas, path-dependent |
| Death benefit tracking | High | Daily | Ratchet logic, roll-up |
| DCA transfers | Medium | Per schedule | Source → target unit exchanges |
| Rebalancing | Medium | Per schedule | Multi-sub-account transfers |
| Surrender value | High | On-demand | AV minus all applicable charges |
| Cost basis | High | Per transaction | Lot-level tracking possible |
| Performance reporting | High | Monthly/Quarterly | Time-weighted returns |

#### 11.2.3 FIA Calculation Engine

| Calculation | Complexity | Frequency | Notes |
|---|---|---|---|
| Index crediting | Very High | Per term end (batch) | Multiple methods, formulas, parameters |
| Interim value | High | On-demand/daily | Partial-period index performance |
| Strategy allocation | Medium | Annually | Reallocation processing |
| Rate management | High | Ongoing | Cap/participation/spread rate changes |
| Fixed account crediting | Low | Daily/Monthly | Standard interest crediting |
| Illustration engine | Very High | On-demand | AG 49-A/B compliance |
| Surrender value | Medium | On-demand | AV minus surrender charge |

#### 11.2.4 RILA Calculation Engine

| Calculation | Complexity | Frequency | Notes |
|---|---|---|---|
| Segment valuation | Very High | Daily | Option pricing model for interim value |
| Buffer/floor application | High | At segment maturity | Apply protection mechanism |
| Multi-segment tracking | High | Ongoing | Overlapping segments with different parameters |
| Interim surrender value | Very High | On-demand | Mark-to-market approximation |
| Prospectus compliance | High | Ongoing | All calculations must match prospectus formulas |

#### 11.2.5 SPIA/DIA Calculation Engine

| Calculation | Complexity | Frequency | Notes |
|---|---|---|---|
| Payout factor | Very High (at issue) | Once (at pricing) | Mortality tables, discount rates, options |
| Payment generation | Low | Per schedule | Recurring payment processing |
| Exclusion ratio | Medium | Once (at issue) | IRS tables and calculations |
| Tax tracking | Medium | Per payment | Track excluded vs taxable amounts |
| COLA adjustments | Low | Annually | Apply fixed or CPI-linked increase |
| Commutation value | High | On-demand | PV of remaining payments |
| Mortality verification | Low | Annually | Proof-of-life processing |

### 11.3 Architecture Patterns by Product Type

#### 11.3.1 Event-Driven Architecture

All annuity products benefit from an event-driven architecture, but the event types differ:

| Product | Key Events |
|---|---|
| **Fixed/MYGA** | PremiumReceived, InterestCredited, SurrenderRequested, RenewalRateSet, AnniversaryReached, MaturityReached |
| **VA** | PremiumReceived, TradeExecuted, NAVUpdated, M&EDeducted, RebalanceTriggered, BenefitBaseStepUp, WithdrawalProcessed |
| **FIA** | PremiumReceived, TermStarted, IndexCredited, TermMatured, StrategyReallocated, RateRenewed |
| **RILA** | PremiumReceived, SegmentInitiated, InterimValuationCalculated, SegmentMatured, BufferApplied |
| **SPIA** | PremiumReceived, PaymentGenerated, PaymentSent, DeathNotified, CertainPeriodExpired |
| **DIA** | PremiumReceived, DeferralAnniversary, IncomeStarted, PaymentGenerated, DeathDuringDeferral |

#### 11.3.2 Microservice Decomposition

A recommended microservice decomposition for a multi-product annuity platform:

| Service | Responsibility | Products Served |
|---|---|---|
| **Contract Service** | Contract lifecycle, status management, owner/beneficiary data | All |
| **Valuation Service** | Daily valuation, unit accounting, NAV processing | VA, RILA, Group VA |
| **Crediting Service** | Interest crediting, index crediting, rate management | Fixed, MYGA, FIA |
| **Segment Service** | RILA segment management and interim valuation | RILA |
| **Benefit Service** | Living and death benefit calculation and tracking | VA, FIA, RILA |
| **Payout Service** | Payment generation, scheduling, exclusion ratio tracking | SPIA, DIA, annuitized contracts |
| **Transaction Service** | Deposits, withdrawals, transfers, exchanges | All |
| **Fee Service** | Fee calculation, deduction, tracking | VA, RILA, all products with riders |
| **Tax Service** | Cost basis tracking, 1099/5498 reporting, RMD calculations | All |
| **Illustration Service** | Regulatory-compliant illustration generation | All deferred products |
| **Document Service** | Statements, confirmations, prospectus management | All |
| **Compliance Service** | Suitability, regulatory reporting, state filing management | All |
| **Group Plan Service** | Plan-level accounting, participant management, compliance testing | Group products |

### 11.4 Regulatory Reporting Differences

| Report/Filing | Fixed/MYGA | VA | FIA | RILA | SPIA/DIA | Group |
|---|---|---|---|---|---|---|
| **1099-R** | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| **5498** | ✓ (qualified) | ✓ (qualified) | ✓ (qualified) | ✓ (qualified) | — | ✓ |
| **1099-QA (QLAC)** | — | — | — | — | ✓ (DIA/QLAC) | — |
| **SEC N-PORT** | — | ✓ | — | ✓ | — | ✓ (GVA) |
| **SEC N-CEN** | — | ✓ | — | ✓ | — | ✓ (GVA) |
| **State annual statement** | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| **Statutory reserves** | AG 33 | AG 43 | AG 35 | AG 43 | Annuity reserve | Various |
| **GAAP reserves** | ASC 944 | ASC 944 | ASC 944 | ASC 944 | ASC 944 | ASC 944 |
| **LDTI (ASU 2018-12)** | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| **Risk-Based Capital (RBC)** | C-3 Phase I | C-3 Phase II | C-3 Phase I/II | C-3 Phase II | C-3 Phase I | Various |
| **Form 5500** | — | — | — | — | — | ✓ |
| **SAR** | — | — | — | — | — | ✓ |
| **408(b)(2) fee disclosure** | — | — | — | — | — | ✓ |
| **404a-5 participant disclosure** | — | — | — | — | — | ✓ |

### 11.5 Illustration Requirements per Product Type

| Product | Illustration Standard | Key Requirements |
|---|---|---|
| **Fixed/MYGA** | NAIC Annuity Disclosure Model | Show guaranteed and non-guaranteed values; current and minimum rate scenarios |
| **VA** | FINRA Rule 2210; SEC prospectus | Hypothetical returns (usually 0%, 6%, 10%); show impact of all fees |
| **FIA** | AG 49-A / AG 49-B | Illustrated rate limited to 145% of 10-year Treasury; disciplined current scale for Vol-controlled indices |
| **RILA** | SEC prospectus | Show range of outcomes under various index return scenarios; buffer/floor impact |
| **SPIA** | NAIC Annuity Disclosure | Show payout options, payment amounts, comparison to alternatives |
| **DIA** | NAIC Annuity Disclosure / QLAC rules | Show income start date options, payout amounts, QLAC reporting if applicable |
| **Group** | ERISA/DOL requirements | Plan-level fee disclosure, participant-level benefit illustration |

#### 11.5.1 AG 49-A / AG 49-B — Key Rules for FIA Illustrations

| Rule | AG 49-A (2020) | AG 49-B (2024) |
|---|---|---|
| **Benchmark** | 145% × 10-year CMT average | Same for standard indices |
| **Non-proprietary VCI** | 10-year lookback geometric average | Same |
| **Proprietary index** | Not specifically addressed | Limited to 50% of non-proprietary index illustrated rate + 50% fixed account rate |
| **Bonus products** | Enhanced return cannot exceed non-bonus product illustration | Same |
| **Loan illustration** | Must show impact of fixed loan provision | Same |

### 11.6 Technology Stack Recommendations

| Layer | Recommendation | Rationale |
|---|---|---|
| **Database** | PostgreSQL or Oracle with partitioning | High-volume transaction data; complex queries; regulatory auditability |
| **Event Streaming** | Apache Kafka or AWS Kinesis | Event-driven processing; decoupled microservices; replayability |
| **Calculation Engine** | Java/Kotlin or C# (for complex math); potentially Python for actuarial models | Performance, precision (BigDecimal), testability |
| **API Layer** | REST + gRPC | REST for external consumers; gRPC for inter-service communication |
| **Batch Processing** | Apache Spark or Spring Batch | Daily valuation, anniversary processing, reporting |
| **Caching** | Redis | Rate lookups, index values, frequently accessed contract data |
| **Document Generation** | Apache POI, JasperReports, or LaTeX | Regulatory-compliant statements and illustrations |
| **Data Warehouse** | Snowflake or Databricks | Actuarial analysis, regulatory reporting, business intelligence |
| **Audit Trail** | Immutable event log (Kafka + cold storage) | Regulatory requirement — every calculation must be auditable |

### 11.7 Integration Points

A comprehensive annuity platform requires integration with many external systems:

| Integration | Direction | Frequency | Data |
|---|---|---|---|
| **Fund NAV feed** | Inbound | Daily | Sub-account unit values (VA, RILA) |
| **Index data feed** | Inbound | Daily | Index closing values (FIA, RILA) |
| **Reference rate feed** | Inbound | Daily | Treasury yields, CMT rates (MVA, FIA pricing) |
| **Payment processor** | Outbound | Per transaction | ACH, wire, check payments |
| **Tax reporting (IRS)** | Outbound | Annual + corrections | 1099-R, 5498, 1098-QA files |
| **State regulatory filings** | Outbound | Annual/Quarterly | Statutory reporting, market conduct |
| **Reinsurer** | Outbound | Monthly/Quarterly | Ceded risk data, claim notifications |
| **Hedging system** | Bi-directional | Daily/Real-time | Guarantee exposures, hedge positions |
| **CRM** | Bi-directional | Real-time | Agent/advisor data, sales tracking |
| **E-application** | Inbound | Real-time | New business submissions |
| **Imaging/ECM** | Bi-directional | Per event | Document storage and retrieval |
| **Compliance/AML** | Bi-directional | Per event | Suspicious activity, OFAC screening |
| **State guaranty association** | Outbound | Annual | Premium and reserve data |
| **DTCC/NSCC** | Bi-directional | Daily | ACATS transfers, commissions (for registered products) |
| **Morningstar/analytics** | Inbound | Daily/Monthly | Fund ratings, performance data |

### 11.8 Common Data Quality Challenges

| Challenge | Products Affected | Mitigation |
|---|---|---|
| **Backdated transactions** | All | Support effective-date processing; recalculate forward |
| **Rate mismatches** | Fixed, FIA | Automated rate verification; dual-control rate entry |
| **Unit rounding** | VA, RILA | Define rounding rules (6+ decimals); reconcile daily |
| **Withdrawal ordering** | NQ with cost basis | Enforce LIFO for NQ; track each premium layer |
| **Beneficiary data quality** | All | Regular beneficiary verification campaigns |
| **Index data corrections** | FIA, RILA | Support index value corrections and recalculation |
| **Fund ticker changes** | VA | Mapping table for fund reorganizations, mergers |
| **State-specific rules** | All | Rule engine with state-override capability |

### 11.9 Performance and Scalability Considerations

| Scenario | Scale | Approach |
|---|---|---|
| **Daily VA valuation** | 500K–5M contracts × 30 sub-accounts | Parallel batch; partition by contract cohort |
| **FIA anniversary processing** | 1M+ contracts on anniversary date | Staggered processing; pre-calculate where possible |
| **RMD calculation** | All qualified contracts annually | Batch in December; incremental recalcs for late transactions |
| **SPIA payment generation** | 200K+ monthly payments | Batch payment file generation; ACH file formatting |
| **Death claim processing** | 10K–50K claims/year | Workflow-driven; STP where possible |
| **1099-R generation** | All contracts with distributions | Annual batch; correction processing Jan–March |
| **Illustration generation** | On-demand; hundreds/day | Stateless calculation service; cacheable inputs |

### 11.10 Security and Compliance

| Requirement | Implementation |
|---|---|
| **PII protection** | Encrypt SSN, DOB, financial data at rest and in transit |
| **SOC 2 compliance** | Access controls, audit logging, change management |
| **Data retention** | Retain records for life of contract + 7 years (minimum) |
| **Audit trail** | Every financial transaction and calculation must be auditable |
| **Access control** | Role-based; segregation of duties for rate changes, payments |
| **Disaster recovery** | RPO < 1 hour, RTO < 4 hours for critical processing |
| **NIST framework** | Align with NIST Cybersecurity Framework |
| **State data privacy** | Comply with state insurance data privacy laws (NAIC model law) |

---

## 12. Appendix: Cross-Product Comparison Matrix

### 12.1 Product Feature Comparison

| Feature | Fixed | MYGA | VA | FIA | RILA | SPIA | DIA | Group |
|---|---|---|---|---|---|---|---|---|
| **SEC registered** | No | No | Yes | No | Yes | No | No | Some |
| **Investment risk** | Insurer | Insurer | Owner | Insurer | Shared | Insurer | Insurer | Varies |
| **Upside potential** | Declared rate | Guaranteed rate | Unlimited | Capped/limited | Moderate (capped) | N/A | N/A | Varies |
| **Downside protection** | Full | Full | None | Full (0% floor) | Partial (buffer/floor) | N/A | N/A | Varies |
| **Surrender charges** | Yes | Yes | Yes | Yes | Yes | N/A | Maybe | Some |
| **Living benefits** | Limited | No | Yes | Yes | Limited | N/A | N/A | No |
| **Death benefit** | Yes | Yes | Yes | Yes | Yes | Limited | Yes | Yes |
| **Annuitization** | Available | Available | Available | Available | Available | Immediate | Deferred | Available |
| **Typical issue age** | 0–90 | 18–85 | 0–85 | 0–80 | 18–80 | 50–90 | 40–80 | N/A |
| **Typical premium** | $10K+ | $5K+ | $10K+ | $10K+ | $25K+ | $10K+ | $10K+ | Plan-level |
| **Licensing required** | Insurance | Insurance | Ins + Series 6/7 | Insurance | Ins + Series 6/7 | Insurance | Insurance | Varies |
| **Compensation** | Commission | Commission | Commission/Fee | Commission | Commission/Fee | Commission | Commission | Fee/Commission |

### 12.2 Regulatory Classification Matrix

| Aspect | Fixed/MYGA | FIA | VA | RILA | SPIA/DIA |
|---|---|---|---|---|---|
| **Federal securities law** | Exempt | Exempt (Harkin) | 1933 Act, 1940 Act | 1933 Act | Exempt |
| **State insurance law** | Yes | Yes | Yes | Yes | Yes |
| **FINRA** | No | No | Yes | Yes | No |
| **Prospectus required** | No | No | Yes | Yes | No |
| **Suitability standard** | NAIC Best Interest | NAIC Best Interest | FINRA + NAIC | FINRA + NAIC | NAIC Best Interest |
| **Illustration model** | NAIC disclosure | AG 49-A/B | SEC/FINRA | SEC/FINRA | NAIC disclosure |
| **Reserve standard** | AG 33 | AG 35 | AG 43 (VA CARVM) | AG 43 | Annuity reserve |
| **RBC requirement** | C-3 Phase I | C-3 Phase I/II | C-3 Phase II | C-3 Phase II | C-3 Phase I |

### 12.3 Distribution Channel Matrix

| Channel | Fixed | MYGA | VA | FIA | RILA | SPIA | DIA |
|---|---|---|---|---|---|---|---|
| **Independent agents** | ✓ | ✓ | — | ✓ | — | ✓ | ✓ |
| **IMO/FMO** | ✓ | ✓ | — | ✓ | — | ✓ | ✓ |
| **Broker-dealer (wirehouse)** | — | ✓ | ✓ | — | ✓ | ✓ | ✓ |
| **Bank** | ✓ | ✓ | ✓ | ✓ | — | ✓ | — |
| **RIA (fee-based)** | — | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| **Direct-to-consumer** | ✓ | ✓ | — | — | — | ✓ | — |
| **Worksite/employer** | — | — | — | — | — | — | — |

### 12.4 Commission Structure Comparison

| Product | Typical Trail (bps) | Typical Upfront | Breakeven Period |
|---|---|---|---|
| **Fixed (traditional)** | 25–50 bps | 1–3% of premium | 1–2 years |
| **MYGA** | 0 bps (typically no trail) | 0.5–2.0% of premium | < 1 year |
| **VA (A-share)** | 25 bps | 4–6% of premium | 3–5 years |
| **VA (B-share)** | 25 bps | 5–7% of premium | 4–6 years |
| **VA (L-share)** | 25 bps | 3–4% of premium | 2–3 years |
| **VA (advisory/I-share)** | 0 bps | 0% | N/A (advisory fee) |
| **FIA** | 25–50 bps | 5–7% of premium | 5–7 years |
| **RILA** | 25 bps | 1.5–3.0% of premium | 2–4 years |
| **SPIA** | 0–25 bps | 1–3% of premium | 1–3 years |
| **DIA** | 0–25 bps | 2–4% of premium | 2–4 years |

### 12.5 Unified Contract Data Model (Conceptual ERD)

Below is a conceptual entity relationship summary for a unified annuity platform:

```
CONTRACT (1)
  ├── OWNER (1..*)
  ├── ANNUITANT (1..2)
  ├── BENEFICIARY (0..*)
  ├── PREMIUM (1..*)
  ├── WITHDRAWAL (0..*)
  ├── SURRENDER_SCHEDULE (1)
  ├── TAX_QUALIFICATION (1)
  │
  ├── [Fixed/MYGA specific]
  │   ├── RATE_HISTORY (1..*)
  │   ├── BONUS_TRACKING (0..1)
  │   └── MVA_PARAMETERS (0..1)
  │
  ├── [VA specific]
  │   ├── SUB_ACCOUNT_POSITION (1..*)
  │   ├── DCA_PROGRAM (0..*)
  │   ├── REBALANCE_SCHEDULE (0..1)
  │   └── FEE_SCHEDULE (1)
  │
  ├── [FIA specific]
  │   ├── STRATEGY_ALLOCATION (1..*)
  │   ├── CREDITING_HISTORY (1..*)
  │   └── RATE_RENEWAL_HISTORY (1..*)
  │
  ├── [RILA specific]
  │   ├── SEGMENT (1..*)
  │   ├── SEGMENT_VALUATION (1..*)
  │   └── PROTECTION_PARAMETERS (1..*)
  │
  ├── [SPIA/DIA specific]
  │   ├── PAYOUT_SCHEDULE (1)
  │   ├── PAYMENT_HISTORY (0..*)
  │   └── EXCLUSION_RATIO (1)
  │
  ├── [Rider/Benefit]
  │   ├── LIVING_BENEFIT_RIDER (0..*)
  │   │   ├── BENEFIT_BASE_HISTORY (1..*)
  │   │   └── WITHDRAWAL_TRACKING (0..*)
  │   └── DEATH_BENEFIT (1)
  │       └── RATCHET_HISTORY (0..*)
  │
  └── [Operational]
      ├── TRANSACTION_HISTORY (0..*)
      ├── CORRESPONDENCE (0..*)
      ├── DOCUMENT (0..*)
      └── AUDIT_LOG (0..*)
```

### 12.6 Glossary of Key Terms

| Term | Definition |
|---|---|
| **Accumulated Value (AV)** | Current value of the contract, including premiums, interest/gains, minus withdrawals and charges |
| **Annuitant** | The person whose life determines annuity payments; may or may not be the contract owner |
| **Annuitization** | Irrevocable conversion of accumulated value into a guaranteed income stream |
| **Benefit Base (BB)** | Notional value used to calculate living benefit guaranteed amounts; not a cash value |
| **Buffer** | Percentage of index loss absorbed by the insurer in a RILA |
| **Cap** | Maximum crediting rate for an index-linked strategy |
| **Cost Basis** | The after-tax amount invested; used to determine taxable gain on distributions |
| **Crediting Rate** | The interest rate or index-linked return applied to the contract value |
| **Exclusion Ratio** | Fraction of each annuity payment that is a tax-free return of investment |
| **Floor** | Minimum crediting rate (or maximum loss in a RILA) |
| **Free Look** | Period after purchase during which the contract can be returned for a full refund |
| **General Account** | The insurer's main investment portfolio backing fixed-rate obligations |
| **GLWB** | Guaranteed Lifetime Withdrawal Benefit — lifetime income guarantee rider |
| **GMAB** | Guaranteed Minimum Accumulation Benefit — minimum account value guarantee rider |
| **GMDB** | Guaranteed Minimum Death Benefit |
| **GMIB** | Guaranteed Minimum Income Benefit — minimum annuitization income guarantee rider |
| **GMWB** | Guaranteed Minimum Withdrawal Benefit — total withdrawal guarantee rider |
| **M&E Charge** | Mortality and Expense risk charge, deducted from VA sub-accounts |
| **Mortality Credit** | The economic benefit of risk pooling; those who die early subsidize those who live longer |
| **MVA** | Market Value Adjustment — adjustment to surrender value based on interest rate changes |
| **MYGA** | Multi-Year Guarantee Annuity — fixed rate for a defined period |
| **NAV** | Net Asset Value — per-unit value of a sub-account or mutual fund |
| **Participation Rate** | Percentage of index return credited to the contract |
| **QLAC** | Qualifying Longevity Annuity Contract — DIA with favorable RMD treatment |
| **RILA** | Registered Index-Linked Annuity — structured/buffered annuity |
| **RMD** | Required Minimum Distribution — mandatory distribution from qualified accounts |
| **Roll-Up** | Guaranteed growth rate applied to the benefit base during the accumulation phase |
| **Separate Account** | Segregated investment account holding VA sub-account assets |
| **Spread/Margin** | Amount deducted from index return before crediting in an FIA |
| **Step-Up/Ratchet** | Resetting a guarantee base to the current (higher) account value |
| **Sub-Account** | A division of a VA separate account that invests in a specific underlying fund |
| **Surrender Charge** | Penalty for early withdrawal, typically declining over time |
| **Surrender Value** | Accumulated value minus surrender charges and any applicable MVA |
| **1035 Exchange** | Tax-free exchange of one annuity (or life insurance) contract for another |

---

*This document serves as a comprehensive reference for solution architects designing and building systems in the annuities domain. Each product type introduces unique data modeling, calculation, regulatory, and operational requirements that must be carefully addressed in any enterprise annuity platform.*

*Last updated: April 2026*
