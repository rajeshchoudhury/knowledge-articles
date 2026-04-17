# 16. Data Warehouse & Analytics for Annuities

## Executive Summary

Annuity carriers sit on one of the richest data ecosystems in financial services—contract-level cashflows spanning decades, rider utilization patterns, mortality and lapse experience, commission hierarchies, suitability evidence, and regulatory filings across 50+ jurisdictions. Yet most organizations struggle to unify this data into a coherent, trusted analytical platform. This article provides a solution architect's blueprint for designing, building, and governing a modern data warehouse and analytics capability purpose-built for the annuities domain.

We cover everything from classical dimensional modeling of annuity facts and dimensions, through ETL/ELT architecture for extracting data from policy administration systems, to modern lakehouse platforms, predictive analytics, and regulatory reporting pipelines. The guidance is implementation-grade: dimensional model specifications, sample SQL, KPI definitions, architecture decision records, and governance frameworks are all included.

---

## Table of Contents

1. [Analytics Landscape for Annuities](#1-analytics-landscape-for-annuities)
2. [Data Warehouse Architecture](#2-data-warehouse-architecture)
3. [Key Data Domains & Data Marts](#3-key-data-domains--data-marts)
4. [ETL/ELT Architecture](#4-etlelt-architecture)
5. [Key Performance Indicators (KPIs)](#5-key-performance-indicators-kpis)
6. [Actuarial Analytics](#6-actuarial-analytics)
7. [Predictive Analytics](#7-predictive-analytics)
8. [Regulatory Reporting Analytics](#8-regulatory-reporting-analytics)
9. [Modern Data Platform Architecture](#9-modern-data-platform-architecture)
10. [Reporting & Visualization](#10-reporting--visualization)
11. [Data Governance for Analytics](#11-data-governance-for-analytics)
12. [Architecture Recommendations & Decision Records](#12-architecture-recommendations--decision-records)

---

## 1. Analytics Landscape for Annuities

### 1.1 Why Annuities Are Analytically Complex

Annuities are among the most analytically demanding products in financial services. A single variable annuity contract can generate data across:

- **Product definition**: fund options, rider elections, fee schedules, surrender charge schedules, step-up rules
- **Financial transactions**: premium payments, fund transfers, withdrawals, systematic withdrawal programs, dollar-cost averaging, rebalancing, RMDs
- **Valuations**: daily sub-account NAVs, guaranteed benefit base calculations, reserve calculations under multiple accounting regimes (STAT, GAAP, IFRS 17)
- **Distribution**: commission schedules, trailing commissions, override hierarchies, producer licensing
- **Compliance**: suitability documentation, state-specific disclosures, best-interest evaluations
- **Lifecycle events**: death claims, annuitization elections, maturity processing, 1035 exchanges

A mid-size annuity carrier with 500,000 inforce contracts and 20 sub-account options per VA contract can easily generate 10+ million valuation records per day. This scale, combined with the regulatory requirement to retain data for decades, makes a well-architected data warehouse not just a nice-to-have but a critical piece of infrastructure.

### 1.2 Business Intelligence Needs

Business intelligence for an annuity carrier covers multiple functional areas, each with distinct data requirements, latency expectations, and analytical sophistication.

| Functional Area | Primary Questions | Data Latency | Analytical Complexity |
|---|---|---|---|
| Executive Management | How is the book performing? Are we hitting plan? | Daily/Weekly | Low-Medium |
| Sales & Distribution | Which products/channels are growing? Where is pipeline? | Daily | Medium |
| Actuarial | Are our assumptions holding? What are emerging trends? | Monthly/Quarterly | Very High |
| Finance & Accounting | What are our reserves? What is the P&L impact? | Daily/Monthly | High |
| Operations | What is our service level? Where are bottlenecks? | Near-real-time | Medium |
| Compliance | Are we meeting regulatory requirements? What are risk indicators? | Daily/Weekly | Medium-High |
| Investment | How are sub-accounts performing? What is the asset allocation? | Daily | High |
| IT & Data Engineering | Is the data platform healthy? Are SLAs being met? | Real-time | Medium |

### 1.3 Operational Analytics

Operational analytics focus on the day-to-day execution of annuity business processes:

**New Business Processing**
- Application-to-issue cycle times by product, channel, and state
- Not-in-good-order (NIGO) rates by reason code and distributor
- Straight-through-processing (STP) rates
- Pending inventory aging analysis
- Underwriting decision distributions

**Policy Servicing**
- Transaction processing volumes and turnaround times by transaction type
- Call center metrics: average handle time, first-call resolution, abandonment rates
- Correspondence volumes and processing times
- Error rates and rework metrics
- Digital self-service adoption rates

**Claims Processing**
- Death claim processing cycle times
- Annuitization election processing
- Maturity processing volumes
- Claim documentation completeness rates

### 1.4 Actuarial Analytics

Actuarial analytics represent the most computationally intensive and methodologically sophisticated analytical workload:

- **Experience studies**: mortality, lapse, partial withdrawal, annuitization, rider utilization
- **Assumption setting and validation**: comparing assumed vs. actual experience
- **Product profitability**: analysis of profitability by product, vintage, distribution channel
- **Reserve calculations**: statutory, GAAP, IFRS 17 reserve computations
- **Capital modeling**: RBC calculations, economic capital, stochastic projections
- **Asset adequacy testing**: cash flow testing under multiple scenarios

### 1.5 Financial Analytics

Financial analytics span multiple accounting regimes and reporting requirements:

- **Revenue analysis**: fee income by source (M&E, rider charges, surrender charges, fund management fees)
- **Expense analysis**: acquisition costs, maintenance costs, claim costs, overhead allocation
- **Investment income**: earned rates, spread analysis, asset-liability matching
- **Reserve movements**: reserve adequacy, unlocking impacts, assumption changes
- **Profitability**: product-level, channel-level, and entity-level P&L
- **GAAP/STAT/IFRS reconciliation**: differences between accounting bases

### 1.6 Compliance Analytics

Compliance analytics are driven by regulatory requirements and risk management needs:

- **Suitability analysis**: deficiency rates, remediation tracking, pattern detection
- **AML/KYC**: suspicious activity monitoring, large transaction reporting, OFAC screening results
- **Market conduct**: complaint trends, replacement activity monitoring, churning detection
- **Regulatory filing**: state filing compliance, NAIC data call readiness
- **Best Interest compliance**: Reg BI and state-level best interest standard adherence

### 1.7 Distribution Analytics

Distribution analytics focus on the producer and channel management ecosystem:

- **Producer productivity**: premium per producer, policies per producer, activity rates
- **Commission analysis**: commission expense ratios, override costs, trail commission projections
- **Channel analysis**: performance comparison across IMOs, wirehouses, banks, direct
- **Recruiting and retention**: new producer onboarding, producer attrition, reactivation
- **Territory analysis**: geographic production patterns, market penetration

### 1.8 Customer Analytics

Customer analytics aim to understand and improve the policyholder experience:

- **Customer segmentation**: behavioral, demographic, and value-based segments
- **Lifetime value**: projected future revenue and cost streams per customer
- **Retention analysis**: surrender and lapse propensity, at-risk customer identification
- **Cross-sell/upsell**: propensity modeling for additional products or riders
- **Journey analysis**: touchpoint mapping, channel preference analysis
- **Satisfaction**: NPS tracking, complaint analysis, service quality metrics

### 1.9 Key Stakeholders and Their Analytical Needs

```
┌──────────────────────────────────────────────────────────────────────┐
│                    ANNUITY ANALYTICS STAKEHOLDER MAP                  │
├─────────────────┬──────────────────────┬─────────────────────────────┤
│ Stakeholder     │ Primary Analytics    │ Key Deliverables            │
├─────────────────┼──────────────────────┼─────────────────────────────┤
│ CEO / Board     │ Strategic KPIs       │ Monthly board deck,         │
│                 │ Market position      │ strategic scorecards        │
├─────────────────┼──────────────────────┼─────────────────────────────┤
│ CFO / Finance   │ Financial reporting  │ GAAP/STAT financials,       │
│                 │ Profitability        │ variance analysis, forecasts│
├─────────────────┼──────────────────────┼─────────────────────────────┤
│ Chief Actuary   │ Experience studies   │ Assumption packages,        │
│                 │ Reserve adequacy     │ valuation datasets          │
├─────────────────┼──────────────────────┼─────────────────────────────┤
│ CRO / Risk      │ Risk metrics         │ RBC dashboards, stress      │
│                 │ Capital adequacy     │ test results, risk appetite │
├─────────────────┼──────────────────────┼─────────────────────────────┤
│ Head of Sales   │ Sales performance    │ Pipeline reports, channel   │
│                 │ Channel management   │ scorecards, comp reports    │
├─────────────────┼──────────────────────┼─────────────────────────────┤
│ COO / Ops       │ Service levels       │ SLA dashboards, capacity    │
│                 │ Processing metrics   │ planning, quality reports   │
├─────────────────┼──────────────────────┼─────────────────────────────┤
│ CCO / Compliance│ Regulatory filings   │ Filing status, suitability  │
│                 │ Conduct risk         │ reports, audit evidence     │
├─────────────────┼──────────────────────┼─────────────────────────────┤
│ CIO / CTO       │ Platform health      │ Data quality dashboards,    │
│                 │ Data governance      │ pipeline monitoring, SLAs   │
├─────────────────┼──────────────────────┼─────────────────────────────┤
│ Investment Mgmt │ Portfolio analytics  │ ALM reports, fund perf,     │
│                 │ ALM                  │ duration matching reports   │
└─────────────────┴──────────────────────┴─────────────────────────────┘
```

---

## 2. Data Warehouse Architecture

### 2.1 Enterprise Data Warehouse Design for Annuities

An enterprise data warehouse (EDW) for an annuity carrier must integrate data from dozens of source systems into a unified, historical, non-volatile repository. The architecture must accommodate:

- **Long time horizons**: annuity contracts can span 40+ years from issue to final payout
- **Multiple accounting regimes**: STAT, GAAP, IFRS 17, Tax, Economic
- **High dimensionality**: every fact can be sliced by contract, product, fund, agent, state, time, and more
- **Regulatory auditability**: the ability to reproduce any report as of any point-in-time
- **Mixed workloads**: from simple dashboards to multi-hour actuarial extracts

#### Architectural Layers

```
┌──────────────────────────────────────────────────────────────────┐
│                     PRESENTATION LAYER                            │
│  Dashboards │ Self-Service BI │ Ad-Hoc Queries │ Data Products   │
├──────────────────────────────────────────────────────────────────┤
│                     SEMANTIC LAYER                                │
│  Business Metrics │ KPI Definitions │ Data Models │ Access Rules  │
├──────────────────────────────────────────────────────────────────┤
│                     DATA MART LAYER                               │
│  Sales │ Finance │ Actuarial │ Operations │ Compliance │ Agent   │
├──────────────────────────────────────────────────────────────────┤
│                     INTEGRATED LAYER                              │
│  Conformed Dimensions │ Enterprise Fact Tables │ History          │
├──────────────────────────────────────────────────────────────────┤
│                     STAGING LAYER                                 │
│  Raw Extracts │ Data Quality │ Deduplication │ Standardization    │
├──────────────────────────────────────────────────────────────────┤
│                     SOURCE SYSTEMS                                │
│  PAS │ Illustration │ Commission │ DTCC │ CRM │ GL │ Claims     │
└──────────────────────────────────────────────────────────────────┘
```

### 2.2 Dimensional Modeling

Dimensional modeling (Kimball methodology) is the foundation for annuity analytics. The approach organizes data into fact tables (measures/metrics) and dimension tables (descriptive context), optimized for query performance and business understanding.

#### 2.2.1 Star Schema

A star schema places a fact table at the center, directly joined to denormalized dimension tables. This is the preferred approach for most annuity data marts because:

- Queries are simple (few joins)
- Performance is excellent (optimized for columnar storage engines)
- Business users can understand the model intuitively

```
                          ┌──────────────┐
                          │ dim_product  │
                          │──────────────│
                          │ product_key  │
                          │ product_code │
                          │ product_name │
                          │ product_type │
                          │ rider_options│
                          └──────┬───────┘
                                 │
┌──────────────┐    ┌───────────┴───────────┐    ┌──────────────┐
│  dim_agent   │    │  fact_new_business     │    │  dim_date    │
│──────────────│    │───────────────────────│    │──────────────│
│ agent_key    │────│ contract_key (FK)     │────│ date_key     │
│ agent_id     │    │ product_key (FK)      │    │ calendar_date│
│ agent_name   │    │ agent_key (FK)        │    │ fiscal_year  │
│ agent_level  │    │ date_key (FK)         │    │ fiscal_qtr   │
│ imo_name     │    │ state_key (FK)        │    │ month_name   │
│ channel      │    │ party_key (FK)        │    │ week_number  │
└──────────────┘    │ premium_amount        │    └──────────────┘
                    │ commission_amount     │
                    │ policy_count          │
┌──────────────┐    │ is_replacement_flag   │    ┌──────────────┐
│ dim_contract │    │ stp_flag              │    │ dim_state    │
│──────────────│    └───────────┬───────────┘    │──────────────│
│ contract_key │                │                │ state_key    │
│ contract_num │────────────────┘                │ state_code   │
│ issue_date   │                                 │ state_name   │
│ status       │                                 │ region       │
│ maturity_date│                                 │ naic_zone    │
└──────────────┘                                 └──────────────┘
```

#### 2.2.2 Snowflake Schema

A snowflake schema normalizes dimension tables into sub-dimensions. This is appropriate for annuity dimensions with deep hierarchies:

```
┌────────────────┐     ┌────────────────┐     ┌────────────────┐
│ dim_sub_account│────→│ dim_fund_family │────→│dim_asset_class │
│────────────────│     │────────────────│     │────────────────│
│ sub_acct_key   │     │ fund_family_key│     │ asset_class_key│
│ fund_ticker    │     │ family_name    │     │ class_name     │
│ fund_name      │     │ fund_company   │     │ risk_level     │
│ fund_family_key│     │ asset_class_key│     └────────────────┘
│ inception_date │     └────────────────┘
│ expense_ratio  │
└────────────────┘
```

Use snowflake schemas selectively for:
- Fund/sub-account hierarchies (fund → fund family → asset class)
- Agent hierarchies (agent → agency → IMO → channel)
- Geography hierarchies (zip → county → state → region → NAIC zone)
- Product hierarchies (plan code → product series → product line → LOB)

#### 2.2.3 Hybrid Approach (Recommended)

In practice, the recommended approach for annuity warehouses is a **hybrid**: star schemas for most dimensions with selective snowflaking for deeply hierarchical dimensions. Modern columnar engines (Snowflake, BigQuery, Redshift, Databricks) handle join performance well, so the traditional performance argument for pure star schemas is less compelling.

### 2.3 Fact Table Types

#### 2.3.1 Transaction Fact Tables

Transaction fact tables record individual business events at the atomic grain. Each row represents one discrete event.

**fact_financial_transaction**

| Column | Type | Description |
|---|---|---|
| transaction_key | BIGINT (SK) | Surrogate key |
| contract_key | INT (FK) | → dim_contract |
| product_key | INT (FK) | → dim_product |
| transaction_type_key | INT (FK) | → dim_transaction_type |
| agent_key | INT (FK) | → dim_agent |
| party_key | INT (FK) | → dim_party |
| effective_date_key | INT (FK) | → dim_date |
| process_date_key | INT (FK) | → dim_date |
| sub_account_key | INT (FK) | → dim_sub_account |
| state_key | INT (FK) | → dim_state |
| transaction_amount | DECIMAL(18,2) | Dollar amount |
| unit_quantity | DECIMAL(18,6) | Units (for VA) |
| unit_price | DECIMAL(12,6) | NAV per unit |
| fee_amount | DECIMAL(18,2) | Associated fees |
| tax_withholding_amount | DECIMAL(18,2) | Tax withheld |
| surrender_charge_amount | DECIMAL(18,2) | Surrender charge |
| mva_adjustment_amount | DECIMAL(18,2) | Market value adj |

**Grain**: One row per financial transaction per sub-account (for VAs) or per contract (for FAs/FIAs).

**Common transaction types**: Initial premium, additional premium, systematic withdrawal, ad-hoc withdrawal, RMD, fund transfer in, fund transfer out, death benefit payment, annuity payment, surrender, 1035 exchange, free look refund, dollar-cost averaging, auto-rebalancing, M&E charge, rider charge, administrative fee.

#### 2.3.2 Periodic Snapshot Fact Tables

Periodic snapshot tables capture the state of the business at regular intervals (daily, monthly, quarterly).

**fact_contract_monthly_snapshot**

| Column | Type | Description |
|---|---|---|
| snapshot_key | BIGINT (SK) | Surrogate key |
| contract_key | INT (FK) | → dim_contract |
| product_key | INT (FK) | → dim_product |
| snapshot_date_key | INT (FK) | → dim_date (month-end) |
| agent_key | INT (FK) | → dim_agent |
| state_key | INT (FK) | → dim_state |
| account_value | DECIMAL(18,2) | Total account value |
| cash_surrender_value | DECIMAL(18,2) | Net of surrender charges |
| guaranteed_benefit_base | DECIMAL(18,2) | GMWB/GMIB benefit base |
| death_benefit_amount | DECIMAL(18,2) | Current death benefit |
| net_amount_at_risk | DECIMAL(18,2) | Death benefit - AV |
| cumulative_premium | DECIMAL(18,2) | Total premiums paid |
| cumulative_withdrawals | DECIMAL(18,2) | Total withdrawals taken |
| annualized_fee_income | DECIMAL(18,2) | Projected annual fees |
| surrender_charge_pct | DECIMAL(8,4) | Current SC percentage |
| contract_duration_months | INT | Months since issue |
| is_in_surrender_period | BOOLEAN | Still in SC period? |
| is_rmd_eligible | BOOLEAN | Owner age >= 73? |
| withdrawal_utilization_pct | DECIMAL(8,4) | % of allowed WD taken |

**Grain**: One row per contract per month-end date.

This is arguably the most important fact table in an annuity warehouse because it enables point-in-time analysis of the entire inforce book.

#### 2.3.3 Accumulating Snapshot Fact Tables

Accumulating snapshot tables track the lifecycle of a process with multiple milestones.

**fact_new_business_pipeline**

| Column | Type | Description |
|---|---|---|
| application_key | BIGINT (SK) | Surrogate key |
| contract_key | INT (FK) | → dim_contract (when issued) |
| product_key | INT (FK) | → dim_product |
| agent_key | INT (FK) | → dim_agent |
| app_received_date_key | INT (FK) | → dim_date |
| app_complete_date_key | INT (FK) | → dim_date |
| suitability_approved_date_key | INT (FK) | → dim_date |
| underwriting_complete_date_key | INT (FK) | → dim_date |
| funding_received_date_key | INT (FK) | → dim_date |
| contract_issued_date_key | INT (FK) | → dim_date |
| contract_delivered_date_key | INT (FK) | → dim_date |
| free_look_expired_date_key | INT (FK) | → dim_date |
| applied_premium | DECIMAL(18,2) | Requested premium |
| issued_premium | DECIMAL(18,2) | Actual issued premium |
| nigo_count | INT | Times returned NIGO |
| current_status | VARCHAR(30) | Current pipeline status |
| days_to_issue | INT | Calculated cycle time |
| days_in_current_status | INT | Aging metric |

**Grain**: One row per application, updated as it progresses through milestones.

### 2.4 Dimension Tables

#### 2.4.1 Contract Dimension (dim_contract)

The contract dimension is the central dimension in annuity analytics. It must capture both current state and historical changes.

| Column | Type | Description |
|---|---|---|
| contract_key | INT (SK) | Surrogate key |
| contract_number | VARCHAR(20) | Business key |
| contract_status | VARCHAR(20) | Active, Surrendered, Death Claim, Annuitized, Matured, Lapsed |
| product_key | INT (FK) | → dim_product |
| issue_date | DATE | Contract issue date |
| maturity_date | DATE | Contract maturity date |
| application_date | DATE | Application received date |
| effective_date | DATE | Contract effective date |
| qualified_status | VARCHAR(10) | Qualified (IRA, 401k) or Non-Qualified |
| tax_qualification_code | VARCHAR(10) | IRA, ROTH, 401K, NQ, 403B, etc. |
| issue_state | VARCHAR(2) | State of issue |
| replacement_indicator | CHAR(1) | Is this a replacement? |
| exchange_1035_indicator | CHAR(1) | Via 1035 exchange? |
| surrender_charge_schedule | VARCHAR(50) | SC schedule identifier |
| free_look_period_days | INT | Free look period |
| annuitization_date | DATE | If annuitized |
| annuity_payout_option | VARCHAR(30) | Life, Period Certain, etc. |
| death_benefit_type | VARCHAR(30) | Standard, Enhanced, Ratchet, etc. |
| gmwb_rider_flag | BOOLEAN | Has GMWB rider? |
| gmib_rider_flag | BOOLEAN | Has GMIB rider? |
| gmab_rider_flag | BOOLEAN | Has GMAB rider? |
| glwb_rider_flag | BOOLEAN | Has GLWB rider? |
| rop_rider_flag | BOOLEAN | Has Return of Premium DB? |
| nursing_home_waiver_flag | BOOLEAN | Has NH waiver? |
| systematic_withdrawal_flag | BOOLEAN | On systematic WD program? |
| dca_flag | BOOLEAN | On dollar-cost averaging? |
| auto_rebalance_flag | BOOLEAN | On auto-rebalancing? |
| row_effective_date | DATE | SCD Type 2 effective date |
| row_expiration_date | DATE | SCD Type 2 expiration date |
| is_current_row | BOOLEAN | Current version? |

#### 2.4.2 Party Dimension (dim_party)

The party dimension represents all individuals and entities associated with contracts.

| Column | Type | Description |
|---|---|---|
| party_key | INT (SK) | Surrogate key |
| party_id | VARCHAR(20) | Business key |
| party_role | VARCHAR(20) | Owner, Annuitant, Beneficiary, Joint Owner |
| person_type | VARCHAR(10) | Individual or Entity |
| first_name | VARCHAR(50) | First name (PII) |
| last_name | VARCHAR(50) | Last name (PII) |
| date_of_birth | DATE | DOB (for age calculations) |
| gender | CHAR(1) | M/F/U |
| ssn_hash | VARCHAR(64) | Hashed SSN (PII protection) |
| marital_status | VARCHAR(20) | Marital status |
| mailing_state | VARCHAR(2) | State of residence |
| mailing_zip | VARCHAR(10) | ZIP code |
| email_address | VARCHAR(100) | Email (PII) |
| phone_number | VARCHAR(20) | Phone (PII) |
| accredited_investor_flag | BOOLEAN | Accredited investor? |
| risk_tolerance | VARCHAR(20) | Conservative, Moderate, Aggressive |
| investment_objective | VARCHAR(30) | Growth, Income, Preservation |
| annual_income_range | VARCHAR(20) | Income bracket |
| net_worth_range | VARCHAR(20) | Net worth bracket |
| tax_bracket | VARCHAR(10) | Tax bracket |

#### 2.4.3 Product Dimension (dim_product)

| Column | Type | Description |
|---|---|---|
| product_key | INT (SK) | Surrogate key |
| product_code | VARCHAR(20) | Business key (plan code) |
| product_name | VARCHAR(100) | Marketing name |
| product_series | VARCHAR(50) | Product series |
| product_line | VARCHAR(30) | VA, FIA, FA, MYGA, SPIA, DIA |
| product_type | VARCHAR(20) | Accumulation, Payout, Hybrid |
| product_generation | VARCHAR(10) | Gen 1, Gen 2, etc. |
| filing_state | VARCHAR(2) | State where filed |
| effective_date | DATE | Product availability date |
| close_date | DATE | Product close date (if closed) |
| is_open_for_new_business | BOOLEAN | Currently available? |
| min_premium | DECIMAL(12,2) | Minimum initial premium |
| max_premium | DECIMAL(12,2) | Maximum premium allowed |
| min_issue_age | INT | Minimum issue age |
| max_issue_age | INT | Maximum issue age |
| surrender_period_years | INT | Length of surrender period |
| me_rate | DECIMAL(8,4) | M&E charge rate |
| admin_fee | DECIMAL(8,2) | Annual admin fee |
| available_riders | VARCHAR(500) | Comma-separated rider list |
| fund_count | INT | Number of available funds |
| crediting_method | VARCHAR(50) | For FIA: point-to-point, monthly avg, etc. |
| index_options | VARCHAR(500) | For FIA: S&P 500, Russell 2000, etc. |
| guaranteed_minimum_rate | DECIMAL(8,4) | Minimum guaranteed rate |

#### 2.4.4 Agent/Producer Dimension (dim_agent)

| Column | Type | Description |
|---|---|---|
| agent_key | INT (SK) | Surrogate key |
| agent_id | VARCHAR(20) | Business key |
| agent_npn | VARCHAR(15) | National Producer Number |
| agent_name | VARCHAR(100) | Full name |
| agent_type | VARCHAR(20) | Individual, Agency, Entity |
| agent_status | VARCHAR(20) | Active, Terminated, Suspended |
| licensing_state | VARCHAR(2) | Primary licensing state |
| appointment_date | DATE | Carrier appointment date |
| termination_date | DATE | Termination date (if applicable) |
| agency_name | VARCHAR(100) | Parent agency |
| imo_name | VARCHAR(100) | IMO/BGA affiliation |
| broker_dealer_name | VARCHAR(100) | B/D affiliation |
| distribution_channel | VARCHAR(30) | Independent, Wirehouse, Bank, Direct |
| commission_level | VARCHAR(10) | Commission schedule level |
| series_6_flag | BOOLEAN | Has Series 6? |
| series_7_flag | BOOLEAN | Has Series 7? |
| series_65_flag | BOOLEAN | Has Series 65? |
| insurance_license_flag | BOOLEAN | Has insurance license? |
| e_and_o_expiration_date | DATE | E&O insurance expiration |
| aml_training_date | DATE | Last AML training |
| suitability_training_date | DATE | Last suitability training |
| row_effective_date | DATE | SCD Type 2 |
| row_expiration_date | DATE | SCD Type 2 |
| is_current_row | BOOLEAN | Current version? |

#### 2.4.5 Date Dimension (dim_date)

The date dimension for annuity analytics requires insurance-specific attributes:

| Column | Type | Description |
|---|---|---|
| date_key | INT (SK) | YYYYMMDD format |
| calendar_date | DATE | Full date |
| day_of_week | VARCHAR(10) | Monday, Tuesday, etc. |
| day_of_month | INT | 1-31 |
| day_of_year | INT | 1-366 |
| week_of_year | INT | ISO week number |
| month_number | INT | 1-12 |
| month_name | VARCHAR(15) | January, February, etc. |
| quarter_number | INT | 1-4 |
| calendar_year | INT | YYYY |
| fiscal_year | INT | Insurance fiscal year |
| fiscal_quarter | INT | Insurance fiscal quarter |
| fiscal_month | INT | Insurance fiscal month |
| is_business_day | BOOLEAN | Excludes weekends/holidays |
| is_market_open | BOOLEAN | NYSE trading day? |
| is_month_end | BOOLEAN | Last business day of month |
| is_quarter_end | BOOLEAN | Last business day of quarter |
| is_year_end | BOOLEAN | Last business day of year |
| naic_reporting_period | VARCHAR(10) | NAIC reporting period |
| rmd_deadline_flag | BOOLEAN | RMD distribution deadline |
| tax_filing_deadline_flag | BOOLEAN | Tax filing deadline |

#### 2.4.6 Geography Dimension (dim_geography)

| Column | Type | Description |
|---|---|---|
| geography_key | INT (SK) | Surrogate key |
| state_code | VARCHAR(2) | State abbreviation |
| state_name | VARCHAR(50) | Full state name |
| state_fips_code | VARCHAR(2) | FIPS code |
| county_name | VARCHAR(100) | County |
| county_fips_code | VARCHAR(5) | County FIPS |
| zip_code | VARCHAR(10) | ZIP code |
| cbsa_code | VARCHAR(10) | CBSA/MSA code |
| region | VARCHAR(20) | Northeast, Southeast, etc. |
| naic_zone | VARCHAR(10) | NAIC zone designation |
| insurance_department | VARCHAR(100) | State DOI name |
| domiciliary_state_flag | BOOLEAN | Company domicile state? |
| best_interest_standard | VARCHAR(30) | Suitability standard in effect |
| replacement_regulation | VARCHAR(50) | Applicable replacement reg |

### 2.5 Slowly Changing Dimensions (SCD)

Annuity data requires careful SCD handling because of the long-lived nature of contracts and the need for historical point-in-time analysis.

#### SCD Type 1 (Overwrite)

Use for corrections and attributes where history is not needed:
- Agent phone number or email
- Data entry corrections
- Reference data updates (ZIP code to state mappings)

#### SCD Type 2 (Add New Row)

Use for attributes where history must be preserved:
- Contract status changes (Active → Surrendered)
- Agent status changes (Active → Terminated)
- Agent affiliation changes (IMO reassignment)
- Product availability changes (Open → Closed)
- Owner address changes (affects state of residence for tax/regulatory purposes)

Implementation pattern:

```sql
-- SCD Type 2 implementation for dim_contract
-- When a contract status changes from 'Active' to 'Surrendered':

-- Step 1: Expire the current row
UPDATE dim_contract
SET row_expiration_date = CURRENT_DATE - INTERVAL '1 day',
    is_current_row = FALSE
WHERE contract_number = 'ANN-2024-001234'
  AND is_current_row = TRUE;

-- Step 2: Insert new current row
INSERT INTO dim_contract (
    contract_number, contract_status, product_key,
    issue_date, /* ... other attributes ... */
    row_effective_date, row_expiration_date, is_current_row
)
VALUES (
    'ANN-2024-001234', 'Surrendered', 42,
    '2024-01-15', /* ... other attributes ... */
    CURRENT_DATE, '9999-12-31', TRUE
);
```

#### SCD Type 3 (Add New Column)

Use sparingly for tracking a single previous value:
- Previous agent assignment (for re-papering analysis)
- Previous owner state (for tax jurisdiction change analysis)

#### SCD Type 6 (Hybrid 1+2+3)

Useful for annuity attributes where both current and historical values are frequently needed:

```sql
-- SCD Type 6 example for agent dimension
-- Tracks current channel, historical channel, and channel effective date
SELECT
    agent_key,
    agent_id,
    current_distribution_channel,    -- Type 1: always current
    historical_distribution_channel, -- Type 2: as-of row
    channel_effective_date,          -- Type 3: when change occurred
    row_effective_date,
    row_expiration_date
FROM dim_agent;
```

### 2.6 Conformed Dimensions

Conformed dimensions are dimensions shared across multiple fact tables and data marts, ensuring consistent analysis. For annuity analytics, the critical conformed dimensions are:

| Conformed Dimension | Used By | Conformance Challenge |
|---|---|---|
| dim_date | All fact tables | Fiscal year definition varies by entity |
| dim_contract | Transactions, snapshots, claims, compliance | PAS may use different contract IDs than DTCC |
| dim_product | All fact tables | Product codes differ between PAS and illustration system |
| dim_agent | Sales, commission, compliance | Agent ID may differ between commission and PAS |
| dim_party | Transactions, claims, compliance | Party matching across systems (SSN-based) |
| dim_geography | All fact tables | ZIP-to-state mapping consistency |

**Conformed Dimension Bus Matrix:**

```
                    dim_    dim_      dim_     dim_    dim_    dim_      dim_
                    date  contract  product   agent   party   geo    sub_acct
                    ----  --------  -------   -----   -----   ---    --------
fact_new_business    X       X         X        X       X      X
fact_transaction     X       X         X        X       X      X        X
fact_monthly_snap    X       X         X        X              X        X
fact_commission      X       X         X        X                       
fact_claim           X       X         X                X      X
fact_compliance      X       X         X        X       X      X
fact_call_center     X       X                          X      
fact_fund_perf       X                                                  X
```

---

## 3. Key Data Domains & Data Marts

### 3.1 Contract/Policy Data Mart

The contract data mart is the foundational mart that provides a unified view of the annuity inforce book.

**Key Entities:**
- Contracts (policies)
- Contract riders
- Contract fund allocations
- Contract status history
- Contract beneficiary designations

**Grain:** One row per contract per month-end date (for the snapshot) or one row per contract (for the current view).

**Key Measures:**
- Account value
- Cash surrender value
- Guaranteed benefit base (GMWB, GMIB, GMAB)
- Death benefit amount
- Net amount at risk
- Cumulative premiums
- Cumulative withdrawals
- Annualized fee income
- Duration in months
- Surrender charge percentage

**Key Dimensions:**
- Contract, Product, Agent, Date, State, Party, Sub-Account, Rider Type

**Sample Query — Inforce Summary by Product Line:**

```sql
SELECT
    p.product_line,
    p.product_name,
    d.calendar_year,
    d.quarter_number,
    COUNT(DISTINCT s.contract_key)        AS contract_count,
    SUM(s.account_value)                  AS total_account_value,
    SUM(s.guaranteed_benefit_base)        AS total_benefit_base,
    SUM(s.net_amount_at_risk)             AS total_nar,
    SUM(s.annualized_fee_income)          AS total_annual_fees,
    AVG(s.contract_duration_months)       AS avg_duration_months,
    SUM(CASE WHEN s.is_in_surrender_period THEN 1 ELSE 0 END) 
        * 100.0 / COUNT(*)               AS pct_in_surrender_period
FROM fact_contract_monthly_snapshot s
JOIN dim_product p ON s.product_key = p.product_key
JOIN dim_date d ON s.snapshot_date_key = d.date_key
WHERE d.is_month_end = TRUE
  AND d.calendar_year = 2025
GROUP BY p.product_line, p.product_name, d.calendar_year, d.quarter_number
ORDER BY p.product_line, d.quarter_number;
```

### 3.2 Financial Transactions Data Mart

**Key Entities:**
- Financial transactions (premiums, withdrawals, transfers, fees, claims)
- Transaction reversals and adjustments
- Tax withholdings
- Surrender charges assessed

**Grain:** One row per financial transaction per sub-account (for variable products).

**Key Measures:**
- Transaction amount (gross)
- Net transaction amount
- Fee amount
- Tax withholding amount
- Surrender charge amount
- Market value adjustment amount
- Unit quantity
- Unit price (NAV)

**Key Dimensions:**
- Contract, Product, Transaction Type, Agent, Date (effective and process), Sub-Account, State, Party

**Sample Query — Monthly Cash Flow Analysis:**

```sql
WITH monthly_flows AS (
    SELECT
        d.calendar_year,
        d.month_number,
        p.product_line,
        tt.transaction_category,
        SUM(CASE WHEN tt.flow_direction = 'INFLOW' 
            THEN ft.transaction_amount ELSE 0 END)   AS inflows,
        SUM(CASE WHEN tt.flow_direction = 'OUTFLOW' 
            THEN ft.transaction_amount ELSE 0 END)   AS outflows
    FROM fact_financial_transaction ft
    JOIN dim_date d ON ft.effective_date_key = d.date_key
    JOIN dim_product p ON ft.product_key = p.product_key
    JOIN dim_transaction_type tt ON ft.transaction_type_key = tt.transaction_type_key
    WHERE d.calendar_year = 2025
    GROUP BY d.calendar_year, d.month_number, p.product_line, tt.transaction_category
)
SELECT
    calendar_year,
    month_number,
    product_line,
    SUM(inflows)                        AS total_inflows,
    SUM(outflows)                       AS total_outflows,
    SUM(inflows) - SUM(outflows)        AS net_flows,
    SUM(inflows) / NULLIF(SUM(outflows), 0) AS flow_ratio
FROM monthly_flows
GROUP BY calendar_year, month_number, product_line
ORDER BY product_line, month_number;
```

### 3.3 Agent/Producer Data Mart

**Key Entities:**
- Agent/producer master
- Agent hierarchy (agent → agency → IMO → channel)
- Agent licensing and appointments
- Commission schedules
- Commission transactions
- Agent production history

**Grain:** One row per agent per month (for the snapshot), one row per commission payment (for transactions).

**Key Measures:**
- First-year commission paid
- Renewal/trail commission paid
- Override commission paid
- Bonus commission paid
- Premium production
- Policy count
- Persistency rate (13-month, 25-month)
- Number of active contracts
- Average premium per contract

**Key Dimensions:**
- Agent, Agent Hierarchy, Product, Date, State, Commission Type, Commission Level

**Sample Query — Top Producers by Channel:**

```sql
SELECT
    a.distribution_channel,
    a.imo_name,
    a.agent_name,
    a.agent_id,
    COUNT(DISTINCT nb.application_key)     AS app_count,
    SUM(nb.issued_premium)                 AS total_premium,
    AVG(nb.days_to_issue)                  AS avg_cycle_time,
    SUM(nb.issued_premium) / NULLIF(COUNT(DISTINCT nb.application_key), 0) 
                                           AS avg_premium_per_app,
    SUM(CASE WHEN nb.nigo_count > 0 THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*)                AS nigo_rate_pct
FROM fact_new_business_pipeline nb
JOIN dim_agent a ON nb.agent_key = a.agent_key
JOIN dim_date d ON nb.contract_issued_date_key = d.date_key
WHERE d.calendar_year = 2025
  AND a.is_current_row = TRUE
  AND nb.current_status = 'ISSUED'
GROUP BY a.distribution_channel, a.imo_name, a.agent_name, a.agent_id
ORDER BY total_premium DESC
LIMIT 100;
```

### 3.4 Customer Data Mart

**Key Entities:**
- Customer master (deduplicated across contracts)
- Customer household
- Customer contact history
- Customer preferences
- Customer risk profile

**Grain:** One row per customer (for the customer master) or one row per customer per product holding (for the relationship view).

**Key Measures:**
- Total relationship value (all contracts)
- Number of contracts held
- Tenure (years as customer)
- Customer lifetime value (projected)
- Contact frequency
- Digital engagement score
- Cross-sell opportunity score
- Lapse risk score

**Key Dimensions:**
- Customer, Age Band, Gender, State, Risk Tolerance, Investment Objective, Customer Segment

**Sample Query — Customer Segmentation:**

```sql
WITH customer_summary AS (
    SELECT
        p.party_key,
        p.party_id,
        DATE_PART('year', AGE(CURRENT_DATE, p.date_of_birth)) AS age,
        p.risk_tolerance,
        p.investment_objective,
        p.mailing_state,
        COUNT(DISTINCT c.contract_key)       AS contract_count,
        SUM(s.account_value)                 AS total_av,
        MIN(c.issue_date)                    AS first_issue_date,
        MAX(c.issue_date)                    AS latest_issue_date,
        DATE_PART('year', AGE(CURRENT_DATE, MIN(c.issue_date))) AS tenure_years
    FROM dim_party p
    JOIN fact_contract_monthly_snapshot s ON p.party_key = s.party_key
    JOIN dim_contract c ON s.contract_key = c.contract_key
    JOIN dim_date d ON s.snapshot_date_key = d.date_key
    WHERE p.party_role = 'OWNER'
      AND p.is_current_row = TRUE
      AND c.is_current_row = TRUE
      AND c.contract_status = 'Active'
      AND d.calendar_date = (SELECT MAX(calendar_date) FROM dim_date WHERE is_month_end)
    GROUP BY p.party_key, p.party_id, p.date_of_birth, 
             p.risk_tolerance, p.investment_objective, p.mailing_state
)
SELECT
    CASE 
        WHEN age < 40 THEN 'Under 40'
        WHEN age BETWEEN 40 AND 54 THEN '40-54'
        WHEN age BETWEEN 55 AND 64 THEN '55-64'
        WHEN age BETWEEN 65 AND 74 THEN '65-74'
        WHEN age >= 75 THEN '75+'
    END AS age_band,
    risk_tolerance,
    COUNT(*) AS customer_count,
    AVG(total_av) AS avg_total_av,
    AVG(contract_count) AS avg_contracts,
    AVG(tenure_years) AS avg_tenure_years,
    SUM(total_av) AS segment_total_av
FROM customer_summary
GROUP BY 1, risk_tolerance
ORDER BY 1, risk_tolerance;
```

### 3.5 Product Data Mart

**Key Entities:**
- Product master
- Product riders
- Product fund options (sub-accounts)
- Product fee schedules
- Product surrender charge schedules
- Product availability by state
- Product rate history (for fixed/FIA)

**Grain:** One row per product (for master), one row per product per state (for availability), one row per product per date (for rate history).

**Key Measures:**
- Products available for new business
- Fund options per product
- Rider attachment rates
- Average premium by product
- Sales volume by product
- Product profitability metrics

### 3.6 Claims Data Mart

**Key Entities:**
- Death claims
- Annuitization elections
- Maturity events
- Disability/confinement waiver claims
- Nursing home waiver claims

**Grain:** One row per claim event.

**Key Measures:**
- Claim amount (death benefit paid, annuitization value)
- Excess death benefit (death benefit - account value)
- Processing cycle time
- Claim documentation completeness
- Claim denial rate
- Average days from death to notification
- Average days from notification to payment

**Key Dimensions:**
- Contract, Product, Claimant (Party), Date (event, notification, payment), State, Claim Type, Cause of Death (for mortality studies)

### 3.7 Compliance Data Mart

**Key Entities:**
- Suitability reviews
- Replacement tracking
- AML alerts and SARs
- Complaints
- Market conduct examination data
- Regulatory filings
- Best Interest evaluations

**Grain:** One row per compliance event (suitability review, complaint, AML alert, etc.).

**Key Measures:**
- Suitability deficiency rate
- Suitability review cycle time
- AML alert volume and escalation rate
- SAR filing count
- Complaint count by category
- Complaint resolution time
- Replacement rate
- Regulatory filing on-time rate

**Key Dimensions:**
- Contract, Agent, Date, State, Compliance Event Type, Severity, Resolution Status

---

## 4. ETL/ELT Architecture

### 4.1 Source System Landscape

An annuity carrier typically has the following source systems feeding the data warehouse:

```
┌──────────────────────────────────────────────────────────────────┐
│                    SOURCE SYSTEM LANDSCAPE                        │
├──────────────────┬───────────────────────────────────────────────┤
│ System           │ Key Data                                      │
├──────────────────┼───────────────────────────────────────────────┤
│ Policy Admin     │ Contracts, transactions, valuations, riders,  │
│ System (PAS)     │ beneficiaries, fund allocations               │
├──────────────────┼───────────────────────────────────────────────┤
│ Illustration     │ Illustrations, projections, product specs,    │
│ System           │ rate tables, fund performance                 │
├──────────────────┼───────────────────────────────────────────────┤
│ Commission       │ Commission schedules, payments, hierarchies,  │
│ System           │ overrides, chargebacks                        │
├──────────────────┼───────────────────────────────────────────────┤
│ DTCC / NSCC      │ Applications (ACORD), transfers (ACAT),       │
│                  │ positions, commissions (via DTCC)             │
├──────────────────┼───────────────────────────────────────────────┤
│ CRM              │ Customer interactions, leads, tasks,          │
│                  │ correspondence, complaints                    │
├──────────────────┼───────────────────────────────────────────────┤
│ General Ledger   │ Account balances, journal entries, trial      │
│                  │ balance, subledger details                    │
├──────────────────┼───────────────────────────────────────────────┤
│ Actuarial System │ Reserves, assumptions, experience study       │
│ (MoSes, AXIS)   │ data, cash flow projections                   │
├──────────────────┼───────────────────────────────────────────────┤
│ Investment       │ Fund NAVs, asset allocations, benchmark       │
│ Platform         │ returns, fund expenses                        │
├──────────────────┼───────────────────────────────────────────────┤
│ Compliance       │ Suitability records, AML alerts, SARs,        │
│ System           │ regulatory filings, complaints                │
├──────────────────┼───────────────────────────────────────────────┤
│ Document Mgmt    │ Applications, forms, correspondence,          │
│                  │ statements, confirmations                     │
├──────────────────┼───────────────────────────────────────────────┤
│ Call Center      │ Call records, IVR logs, chat transcripts,     │
│ / Contact Center │ agent notes, quality scores                   │
├──────────────────┼───────────────────────────────────────────────┤
│ Digital Platform │ Web portal activity, mobile app usage,        │
│                  │ e-delivery preferences, self-service logs     │
└──────────────────┴───────────────────────────────────────────────┘
```

### 4.2 Extraction Patterns

#### 4.2.1 Full Extract

Full extracts pull the complete dataset from a source table on each run. Use for:
- Reference data tables (product, agent, state)
- Small lookup tables
- Systems that don't support incremental extraction
- Periodic full reconciliation runs

```
Schedule: Daily (reference data), Weekly (reconciliation)
Volume: Thousands to low millions of rows
Pattern: TRUNCATE + LOAD or SWAP partition
```

#### 4.2.2 Incremental Extract

Incremental extracts pull only changed data since the last extraction. Methods include:

**Timestamp-based:**
```sql
-- Extract changed contracts since last run
SELECT *
FROM source_pas.contract
WHERE last_modified_timestamp > :last_extract_timestamp
  AND last_modified_timestamp <= :current_extract_timestamp;
```

**Sequence-based:**
```sql
-- Extract new transactions since last sequence
SELECT *
FROM source_pas.financial_transaction
WHERE transaction_sequence_id > :last_extracted_sequence_id;
```

**Audit table-based:**
```sql
-- Extract from PAS audit/change log
SELECT c.*
FROM source_pas.contract c
INNER JOIN source_pas.audit_log a 
    ON c.contract_id = a.entity_id
WHERE a.entity_type = 'CONTRACT'
  AND a.change_timestamp > :last_extract_timestamp;
```

#### 4.2.3 Change Data Capture (CDC)

CDC captures row-level changes from source system transaction logs. This is the preferred approach for near-real-time integration.

**Log-based CDC (recommended):**
- Tools: Debezium, AWS DMS, Oracle GoldenGate, Attunity/Qlik Replicate
- Reads database transaction logs (redo logs, WAL, binlog)
- Zero impact on source system performance
- Captures INSERT, UPDATE, DELETE operations with before/after images

**CDC pipeline architecture:**

```
┌─────────┐    ┌──────────┐    ┌─────────┐    ┌───────────┐    ┌──────────┐
│   PAS   │───→│ Debezium │───→│  Kafka  │───→│  Flink /  │───→│   DW     │
│   DB    │    │ Connector│    │  Topic  │    │  Spark    │    │ Staging  │
└─────────┘    └──────────┘    └─────────┘    │ Streaming │    └──────────┘
                                              └───────────┘
```

**CDC message structure (Debezium format):**

```json
{
  "before": {
    "contract_id": "ANN-2024-001234",
    "contract_status": "Active",
    "account_value": 150000.00
  },
  "after": {
    "contract_id": "ANN-2024-001234",
    "contract_status": "Surrendered",
    "account_value": 0.00
  },
  "source": {
    "connector": "oracle",
    "db": "pas_prod",
    "table": "CONTRACT",
    "ts_ms": 1706745600000
  },
  "op": "u",
  "ts_ms": 1706745600123
}
```

### 4.3 Transformation Rules

Annuity data transformations fall into several categories:

#### 4.3.1 Data Standardization

```sql
-- Standardize contract status codes across source systems
CASE source_system
    WHEN 'PAS' THEN
        CASE pas_status_code
            WHEN 'A'  THEN 'Active'
            WHEN 'S'  THEN 'Surrendered'
            WHEN 'DC' THEN 'Death Claim'
            WHEN 'AN' THEN 'Annuitized'
            WHEN 'M'  THEN 'Matured'
            WHEN 'L'  THEN 'Lapsed'
            WHEN 'FL' THEN 'Free Look Cancel'
        END
    WHEN 'DTCC' THEN
        CASE dtcc_status_code
            WHEN '01' THEN 'Active'
            WHEN '02' THEN 'Surrendered'
            WHEN '03' THEN 'Death Claim'
            -- ...
        END
END AS contract_status
```

#### 4.3.2 Business Rule Calculations

```sql
-- Calculate net amount at risk for death benefit
GREATEST(0, death_benefit_amount - account_value) AS net_amount_at_risk;

-- Calculate surrender charge amount
account_value * surrender_charge_schedule_lookup(
    product_code, 
    DATEDIFF('month', issue_date, CURRENT_DATE)
) AS surrender_charge_amount;

-- Calculate cash surrender value
account_value - surrender_charge_amount - mva_adjustment AS cash_surrender_value;

-- Calculate withdrawal utilization rate (for GMWB riders)
CASE 
    WHEN annual_allowed_withdrawal > 0 
    THEN ytd_withdrawals / annual_allowed_withdrawal
    ELSE 0 
END AS withdrawal_utilization_pct;

-- Calculate contract duration bucket
CASE 
    WHEN contract_duration_months < 12 THEN '0-1 Year'
    WHEN contract_duration_months < 36 THEN '1-3 Years'
    WHEN contract_duration_months < 60 THEN '3-5 Years'
    WHEN contract_duration_months < 84 THEN '5-7 Years'
    WHEN contract_duration_months < 120 THEN '7-10 Years'
    ELSE '10+ Years'
END AS duration_bucket;
```

#### 4.3.3 Surrogate Key Assignment

```sql
-- Surrogate key lookup/assignment during load
INSERT INTO dim_contract (contract_key, contract_number, ...)
SELECT
    COALESCE(
        existing.contract_key,
        NEXTVAL('seq_contract_key')
    ) AS contract_key,
    stg.contract_number,
    ...
FROM staging_contract stg
LEFT JOIN dim_contract existing
    ON stg.contract_number = existing.contract_number
    AND existing.is_current_row = TRUE;
```

#### 4.3.4 Data Enrichment

```sql
-- Enrich contract with derived attributes
SELECT
    c.*,
    -- Age calculations
    DATE_PART('year', AGE(CURRENT_DATE, owner.date_of_birth)) AS owner_current_age,
    DATE_PART('year', AGE(c.issue_date, owner.date_of_birth)) AS owner_issue_age,
    DATE_PART('year', AGE(CURRENT_DATE, annuitant.date_of_birth)) AS annuitant_current_age,
    
    -- RMD eligibility
    CASE WHEN c.qualified_status != 'NQ' 
         AND DATE_PART('year', AGE(CURRENT_DATE, owner.date_of_birth)) >= 73
    THEN TRUE ELSE FALSE END AS is_rmd_eligible,
    
    -- Surrender period status
    CASE WHEN DATEDIFF('year', c.issue_date, CURRENT_DATE) < p.surrender_period_years
    THEN TRUE ELSE FALSE END AS is_in_surrender_period,
    
    -- In-the-money status for guaranteed benefits
    CASE WHEN c.guaranteed_benefit_base > c.account_value
    THEN TRUE ELSE FALSE END AS is_benefit_itm
FROM contract c
JOIN party owner ON c.owner_party_id = owner.party_id
JOIN party annuitant ON c.annuitant_party_id = annuitant.party_id
JOIN product p ON c.product_code = p.product_code;
```

### 4.4 Data Quality Checks

Data quality is critical in annuity analytics because errors can cascade into incorrect reserves, misstated financials, and regulatory issues.

#### 4.4.1 Quality Rules Framework

```
┌──────────────────────────────────────────────────────────────────┐
│                  DATA QUALITY RULES FRAMEWORK                     │
├──────────────────┬────────────┬───────────────────────────────────┤
│ Rule Category    │ Severity   │ Examples                          │
├──────────────────┼────────────┼───────────────────────────────────┤
│ Completeness     │ Critical   │ Contract number is not null       │
│                  │            │ Account value is not null          │
│                  │            │ Issue date is not null             │
├──────────────────┼────────────┼───────────────────────────────────┤
│ Validity         │ Critical   │ Contract status is in valid set   │
│                  │            │ Product code exists in dim_product│
│                  │            │ State code is valid 2-letter code │
├──────────────────┼────────────┼───────────────────────────────────┤
│ Consistency      │ High       │ CSV ≤ Account Value               │
│                  │            │ Issue date ≤ effective date        │
│                  │            │ Owner age at issue ≥ min issue age│
├──────────────────┼────────────┼───────────────────────────────────┤
│ Reasonableness   │ Medium     │ Account value between $0 and $50M│
│                  │            │ Premium amount between $0 and $10M│
│                  │            │ Owner age between 0 and 120       │
├──────────────────┼────────────┼───────────────────────────────────┤
│ Uniqueness       │ Critical   │ Contract number is unique in PAS  │
│                  │            │ Transaction ID is unique           │
├──────────────────┼────────────┼───────────────────────────────────┤
│ Timeliness       │ High       │ Daily extract received by 6 AM    │
│                  │            │ NAV feed received by market close  │
├──────────────────┼────────────┼───────────────────────────────────┤
│ Referential      │ Critical   │ Every transaction references      │
│ Integrity        │            │ valid contract                    │
│                  │            │ Every contract references valid    │
│                  │            │ product                            │
├──────────────────┼────────────┼───────────────────────────────────┤
│ Cross-system     │ High       │ PAS contract count matches DW     │
│ Reconciliation   │            │ PAS total AV matches DW total AV  │
│                  │            │ Commission system totals match     │
└──────────────────┴────────────┴───────────────────────────────────┘
```

#### 4.4.2 Reconciliation Queries

```sql
-- Daily reconciliation: PAS vs. Data Warehouse account values
WITH pas_totals AS (
    SELECT
        product_code,
        COUNT(*) AS pas_contract_count,
        SUM(account_value) AS pas_total_av
    FROM staging_pas_daily_extract
    WHERE contract_status = 'A'
    GROUP BY product_code
),
dw_totals AS (
    SELECT
        p.product_code,
        COUNT(*) AS dw_contract_count,
        SUM(s.account_value) AS dw_total_av
    FROM fact_contract_monthly_snapshot s
    JOIN dim_product p ON s.product_key = p.product_key
    JOIN dim_date d ON s.snapshot_date_key = d.date_key
    JOIN dim_contract c ON s.contract_key = c.contract_key
    WHERE d.calendar_date = CURRENT_DATE
      AND c.contract_status = 'Active'
      AND c.is_current_row = TRUE
    GROUP BY p.product_code
)
SELECT
    COALESCE(p.product_code, d.product_code) AS product_code,
    p.pas_contract_count,
    d.dw_contract_count,
    p.pas_contract_count - COALESCE(d.dw_contract_count, 0) AS count_diff,
    p.pas_total_av,
    d.dw_total_av,
    p.pas_total_av - COALESCE(d.dw_total_av, 0) AS av_diff,
    ABS(p.pas_total_av - COALESCE(d.dw_total_av, 0)) / NULLIF(p.pas_total_av, 0) * 100 
        AS av_diff_pct
FROM pas_totals p
FULL OUTER JOIN dw_totals d ON p.product_code = d.product_code
WHERE ABS(COALESCE(p.pas_contract_count, 0) - COALESCE(d.dw_contract_count, 0)) > 0
   OR ABS(COALESCE(p.pas_total_av, 0) - COALESCE(d.dw_total_av, 0)) > 0.01
ORDER BY ABS(COALESCE(p.pas_total_av, 0) - COALESCE(d.dw_total_av, 0)) DESC;
```

### 4.5 Loading Strategies

#### 4.5.1 Full Refresh

```
Approach: TRUNCATE target table, INSERT all records
Use when:  Dimension tables < 1M rows, weekly reconciliation
Pros:      Simple, no CDC complexity, guarantees consistency
Cons:      Slow for large tables, requires source full extract
```

#### 4.5.2 Incremental/Delta Load (Merge/Upsert)

```sql
-- MERGE pattern for incremental loading into fact table
MERGE INTO fact_financial_transaction tgt
USING staging_transaction src
ON tgt.source_transaction_id = src.transaction_id
   AND tgt.source_system = 'PAS'
WHEN MATCHED AND src.last_modified > tgt.last_modified THEN
    UPDATE SET
        tgt.transaction_amount = src.transaction_amount,
        tgt.unit_quantity = src.unit_quantity,
        tgt.last_modified = src.last_modified,
        tgt.etl_update_timestamp = CURRENT_TIMESTAMP
WHEN NOT MATCHED THEN
    INSERT (source_transaction_id, source_system, contract_key, 
            product_key, transaction_amount, ...)
    VALUES (src.transaction_id, 'PAS', 
            dim_contract_lookup(src.contract_number),
            dim_product_lookup(src.product_code),
            src.transaction_amount, ...);
```

#### 4.5.3 Partition Swap

For large fact tables (daily snapshots), partition swap is the preferred loading strategy:

```sql
-- Load daily snapshot using partition swap
-- Step 1: Load into staging partition
INSERT INTO fact_daily_snapshot_staging
SELECT /* ... transformation logic ... */
FROM source_data;

-- Step 2: Swap partition
ALTER TABLE fact_contract_daily_snapshot
    EXCHANGE PARTITION p_20250131
    WITH TABLE fact_daily_snapshot_staging;
```

### 4.6 ETL Orchestration

#### 4.6.1 Daily ETL Pipeline (Typical Schedule)

```
┌─────────────────────────────────────────────────────────────────────┐
│                   DAILY ETL PIPELINE SCHEDULE                        │
├────────┬────────────────────────────────────────────────────────────┤
│ Time   │ Activity                                                   │
├────────┼────────────────────────────────────────────────────────────┤
│ 01:00  │ PAS end-of-day processing completes                       │
│ 01:30  │ Extract: PAS contract/transaction files generated          │
│ 02:00  │ Extract: NAV feed received from fund companies             │
│ 02:30  │ Stage: Raw files loaded to staging area                    │
│ 03:00  │ Quality: Data quality rules executed on staging data       │
│ 03:30  │ Transform: Business rules applied, surrogate keys assigned │
│ 04:30  │ Load: Dimensions loaded (SCD processing)                   │
│ 05:00  │ Load: Transaction facts loaded (incremental)               │
│ 05:30  │ Load: Daily snapshot facts loaded (partition swap)          │
│ 06:00  │ Reconcile: PAS-to-DW reconciliation executed               │
│ 06:30  │ Aggregate: Pre-computed aggregations refreshed              │
│ 07:00  │ Validate: Business validation rules checked                │
│ 07:15  │ Notify: Data quality scorecard published                   │
│ 07:30  │ Available: Data mart ready for business users               │
├────────┼────────────────────────────────────────────────────────────┤
│ 08:00  │ Reports: Scheduled reports generated and distributed        │
│ 09:00  │ Commission: Commission system extract (separate pipeline)   │
│ 10:00  │ DTCC: DTCC/NSCC files processed (received overnight)       │
└────────┴────────────────────────────────────────────────────────────┘
```

#### 4.6.2 ETL Tool Recommendations

| Tool Category | Options | Recommendation |
|---|---|---|
| Orchestration | Airflow, Dagster, Prefect, AWS Step Functions | **Airflow** (industry standard) or **Dagster** (modern, asset-based) |
| Batch ETL | dbt, Spark, Informatica, Talend | **dbt** (SQL-first, version-controlled transformations) |
| Streaming | Kafka + Flink, Kafka Streams, Spark Structured Streaming | **Kafka + Flink** for CDC; **Spark Streaming** if already on Spark |
| CDC | Debezium, AWS DMS, Qlik Replicate | **Debezium** (open source) or **AWS DMS** (managed) |
| Data Quality | Great Expectations, dbt tests, Soda, Monte Carlo | **Great Expectations** or **dbt tests** integrated in pipeline |
| File Transfer | SFTP, AWS Transfer Family, MFT tools | **AWS Transfer Family** or enterprise MFT for DTCC/carrier files |

### 4.7 Near-Real-Time Data Integration

Some analytical use cases require near-real-time data:

| Use Case | Latency Requirement | Approach |
|---|---|---|
| Account value inquiries | Minutes | CDC → Kafka → materialized view |
| Fraud detection | Seconds | Streaming event processing |
| Call center context | Minutes | CDC → Kafka → operational data store |
| Dashboard refresh | 15-30 minutes | Micro-batch ETL |
| Trading/NAV updates | End of day | Batch feed with market-close trigger |
| Commission calculations | Hours | Near-real-time batch |

---

## 5. Key Performance Indicators (KPIs)

### 5.1 Sales KPIs

| KPI | Definition | Formula | Target (Example) |
|---|---|---|---|
| **New Business Premium** | Total premium on newly issued contracts | SUM(premium) WHERE status = 'Issued' | $5B annually |
| **Application Count** | Number of applications received | COUNT(DISTINCT application_id) | 50,000/year |
| **Placement Rate** | % of applications that become issued policies | Issued / (Issued + Declined + Withdrawn) | > 85% |
| **STP Rate** | % of apps processed straight-through without manual intervention | Auto-processed / Total processed | > 60% |
| **NIGO Rate** | % of applications Not In Good Order on first submission | NIGO apps / Total apps | < 15% |
| **Average Premium** | Average premium per issued contract | Total premium / Issued contracts | $150,000 |
| **Cycle Time** | Average days from application to issue | AVG(issue_date - app_date) | < 7 days |
| **Net Flow** | Inflows minus outflows | Premiums - Surrenders - Withdrawals | Positive |
| **Sales by Channel** | Premium broken down by distribution channel | SUM(premium) GROUP BY channel | Varies |
| **Product Mix** | Percentage of sales by product line | Product premium / Total premium | Varies |

```sql
-- Sales KPI Dashboard Query
SELECT
    d.fiscal_year,
    d.fiscal_quarter,
    d.month_name,
    p.product_line,
    a.distribution_channel,
    
    -- Volume KPIs
    COUNT(DISTINCT nb.application_key)                           AS app_count,
    COUNT(DISTINCT CASE WHEN nb.current_status = 'ISSUED' 
          THEN nb.application_key END)                           AS issued_count,
    
    -- Premium KPIs
    SUM(CASE WHEN nb.current_status = 'ISSUED' 
        THEN nb.issued_premium ELSE 0 END)                      AS total_premium,
    AVG(CASE WHEN nb.current_status = 'ISSUED' 
        THEN nb.issued_premium END)                              AS avg_premium,
    
    -- Quality KPIs
    COUNT(DISTINCT CASE WHEN nb.current_status = 'ISSUED' 
          THEN nb.application_key END) * 100.0 
        / NULLIF(COUNT(DISTINCT nb.application_key), 0)         AS placement_rate,
    
    SUM(CASE WHEN nb.nigo_count = 0 AND nb.current_status = 'ISSUED'
        THEN 1 ELSE 0 END) * 100.0
        / NULLIF(COUNT(DISTINCT CASE WHEN nb.current_status = 'ISSUED'
          THEN nb.application_key END), 0)                      AS stp_rate,
    
    SUM(CASE WHEN nb.nigo_count > 0 THEN 1 ELSE 0 END) * 100.0
        / NULLIF(COUNT(*), 0)                                   AS nigo_rate,
    
    -- Speed KPIs
    AVG(nb.days_to_issue)                                       AS avg_days_to_issue,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY nb.days_to_issue) AS median_days_to_issue
    
FROM fact_new_business_pipeline nb
JOIN dim_date d ON nb.app_received_date_key = d.date_key
JOIN dim_product p ON nb.product_key = p.product_key
JOIN dim_agent a ON nb.agent_key = a.agent_key
WHERE d.fiscal_year = 2025
GROUP BY d.fiscal_year, d.fiscal_quarter, d.month_name, 
         p.product_line, a.distribution_channel
ORDER BY d.fiscal_quarter, d.month_name;
```

### 5.2 Servicing KPIs

| KPI | Definition | Target |
|---|---|---|
| **Transaction Volume** | Count of servicing transactions processed | Track trend |
| **Turnaround Time** | Average days from request to completion | < 3 days |
| **Error Rate** | % of transactions with errors/rework | < 1% |
| **First-Call Resolution** | % of calls resolved without callback | > 80% |
| **Average Handle Time** | Average duration of service calls | < 8 minutes |
| **Abandonment Rate** | % of calls abandoned before answer | < 5% |
| **Digital Adoption** | % of transactions via self-service | > 40% |
| **Customer Satisfaction (CSAT)** | Post-interaction survey score | > 4.2/5.0 |
| **NPS** | Net Promoter Score | > 30 |
| **Correspondence Backlog** | Outstanding correspondence items | < 2-day backlog |

### 5.3 Financial KPIs

| KPI | Definition | Target |
|---|---|---|
| **Total Account Value** | Sum of all inforce account values | Track growth |
| **Total Assets Under Management** | AV plus separate account assets | Track growth |
| **Fee Income** | M&E + rider charges + admin fees | Track vs. plan |
| **Surrender Rate** | % of AV surrendered during period | < 8% annually |
| **Lapse Rate** | % of contracts that lapse or surrender | < 6% annually |
| **Persistency (13-month)** | % of contracts still inforce after 13 months | > 92% |
| **Persistency (25-month)** | % of contracts still inforce after 25 months | > 88% |
| **Mortality Experience** | Actual/Expected mortality ratio | 95-105% |
| **Expense Ratio** | Total expenses / Total AV | < 25 bps |
| **Net Amount at Risk** | Total NAR across all death benefits | Track vs. reserves |
| **Benefit Utilization** | % of GMWB contracts taking withdrawals | Track trend |
| **Spread** | Earned rate - Credited rate (for fixed) | > 150 bps |

```sql
-- Financial KPI: Monthly Surrender Analysis
WITH surrender_analysis AS (
    SELECT
        d.calendar_year,
        d.month_number,
        p.product_line,
        
        -- Beginning of month values
        SUM(CASE WHEN d_bom.is_month_end AND d_bom.month_number = d.month_number - 1
            THEN bom.account_value ELSE 0 END) AS bom_av,
        
        -- Surrender activity
        SUM(CASE WHEN tt.transaction_type_code = 'SURRENDER' 
            THEN ft.transaction_amount ELSE 0 END) AS surrender_amount,
        COUNT(DISTINCT CASE WHEN tt.transaction_type_code = 'SURRENDER' 
            THEN ft.contract_key END) AS surrender_count,
        
        -- Surrender charge collected
        SUM(CASE WHEN tt.transaction_type_code = 'SURRENDER'
            THEN ft.surrender_charge_amount ELSE 0 END) AS sc_collected,
        
        -- Duration analysis of surrenders
        AVG(CASE WHEN tt.transaction_type_code = 'SURRENDER'
            THEN c.contract_duration_months END) AS avg_surrender_duration
            
    FROM fact_financial_transaction ft
    JOIN dim_date d ON ft.effective_date_key = d.date_key
    JOIN dim_product p ON ft.product_key = p.product_key
    JOIN dim_transaction_type tt ON ft.transaction_type_key = tt.transaction_type_key
    JOIN dim_contract c ON ft.contract_key = c.contract_key AND c.is_current_row = TRUE
    LEFT JOIN fact_contract_monthly_snapshot bom ON ft.contract_key = bom.contract_key
    LEFT JOIN dim_date d_bom ON bom.snapshot_date_key = d_bom.date_key
    WHERE d.calendar_year = 2025
    GROUP BY d.calendar_year, d.month_number, p.product_line
)
SELECT
    *,
    surrender_amount / NULLIF(bom_av, 0) * 100 AS surrender_rate_pct,
    sc_collected / NULLIF(surrender_amount, 0) * 100 AS avg_sc_pct
FROM surrender_analysis
ORDER BY product_line, month_number;
```

### 5.4 Distribution KPIs

| KPI | Definition | Target |
|---|---|---|
| **Agent Productivity** | Premium per active producing agent | > $500K |
| **Active Producer Count** | Agents with ≥1 sale in trailing 12 months | Track trend |
| **Commission Expense Ratio** | Total commissions / Total premium | < 6% for VA |
| **Trail Commission Ratio** | Trail commissions / Total AV | Track vs. plan |
| **Agent Retention** | % of producing agents still active after 12 months | > 75% |
| **Channel Performance** | Premium by channel (IMO, wirehouse, bank, direct) | Varies |
| **Top Producer Concentration** | % of premium from top 10% of agents | < 50% |
| **New Agent Onboarding** | Time from appointment to first sale | < 90 days |
| **Compensation Yield** | Total compensation / Premium | < 7% |

### 5.5 Compliance KPIs

| KPI | Definition | Target |
|---|---|---|
| **Suitability Deficiency Rate** | % of reviews with deficiencies | < 3% |
| **Suitability Review Cycle Time** | Days from submission to approval | < 2 days |
| **AML Alert Volume** | Count of AML alerts generated | Track trend |
| **SAR Filing Count** | Suspicious Activity Reports filed | Track trend |
| **Alert-to-SAR Rate** | % of alerts escalated to SAR | < 10% |
| **Complaint Rate** | Complaints per 1,000 contracts inforce | < 2.0 |
| **Complaint Resolution Time** | Average days to resolve complaint | < 30 days |
| **Replacement Rate** | % of new business that is replacement | < 15% |
| **Regulatory Filing Timeliness** | % of filings submitted on time | 100% |
| **Training Compliance** | % of agents with current training | > 98% |

---

## 6. Actuarial Analytics

### 6.1 Experience Studies

Experience studies compare actual outcomes against expected (assumed) outcomes and are the foundation of actuarial analytics.

#### 6.1.1 Mortality Experience Study

**Data requirements:**
- Inforce seriatim file (contract-level detail as of each valuation date)
- Death claim records with date of death
- Exposure calculation: lives and amounts exposed to mortality risk
- Expected mortality basis: 2012 IAM, VBT 2015, or company-specific tables

```sql
-- Mortality experience study data extract
WITH exposure AS (
    SELECT
        s.contract_key,
        c.contract_number,
        p.product_line,
        party.gender,
        DATE_PART('year', AGE(d.calendar_date, party.date_of_birth)) AS attained_age,
        DATE_PART('year', AGE(d.calendar_date, c.issue_date)) AS policy_year,
        c.qualified_status,
        s.account_value,
        s.death_benefit_amount,
        s.net_amount_at_risk,
        1.0 / 12.0 AS exposure_months,  -- monthly contribution
        -- Look up expected mortality rate (qx) from standard table
        mort_table.qx AS expected_qx,
        mort_table.qx / 12.0 AS expected_monthly_qx
    FROM fact_contract_monthly_snapshot s
    JOIN dim_contract c ON s.contract_key = c.contract_key AND c.is_current_row = TRUE
    JOIN dim_product p ON s.product_key = p.product_key
    JOIN dim_party party ON s.party_key = party.party_key 
        AND party.party_role = 'ANNUITANT'
    JOIN dim_date d ON s.snapshot_date_key = d.date_key
    LEFT JOIN mortality_table mort_table 
        ON party.gender = mort_table.gender
        AND DATE_PART('year', AGE(d.calendar_date, party.date_of_birth)) = mort_table.age
    WHERE d.calendar_date BETWEEN '2020-01-01' AND '2024-12-31'
      AND c.contract_status = 'Active'
),
deaths AS (
    SELECT
        cl.contract_key,
        cl.claim_amount,
        cl.date_of_death,
        cl.cause_of_death_category
    FROM fact_claim cl
    WHERE cl.claim_type = 'DEATH'
      AND cl.date_of_death BETWEEN '2020-01-01' AND '2024-12-31'
)
SELECT
    e.product_line,
    e.gender,
    CASE 
        WHEN e.attained_age < 50 THEN '< 50'
        WHEN e.attained_age BETWEEN 50 AND 59 THEN '50-59'
        WHEN e.attained_age BETWEEN 60 AND 69 THEN '60-69'
        WHEN e.attained_age BETWEEN 70 AND 79 THEN '70-79'
        WHEN e.attained_age BETWEEN 80 AND 89 THEN '80-89'
        ELSE '90+'
    END AS age_band,
    e.qualified_status,
    
    -- Exposure
    COUNT(DISTINCT e.contract_key) AS exposed_lives,
    SUM(e.net_amount_at_risk * e.exposure_months) AS amount_exposed,
    
    -- Actual deaths
    COUNT(DISTINCT d.contract_key) AS actual_death_count,
    SUM(d.claim_amount) AS actual_death_claims,
    
    -- Expected deaths
    SUM(e.expected_monthly_qx) AS expected_deaths,
    SUM(e.expected_monthly_qx * e.net_amount_at_risk) AS expected_death_claims,
    
    -- A/E ratios
    COUNT(DISTINCT d.contract_key) * 1.0 / NULLIF(SUM(e.expected_monthly_qx), 0) 
        AS ae_ratio_count,
    SUM(COALESCE(d.claim_amount, 0)) / NULLIF(SUM(e.expected_monthly_qx * e.net_amount_at_risk), 0) 
        AS ae_ratio_amount

FROM exposure e
LEFT JOIN deaths d ON e.contract_key = d.contract_key 
    AND DATE_TRUNC('month', d.date_of_death) = DATE_TRUNC('month', 
        (SELECT calendar_date FROM dim_date WHERE date_key = e.snapshot_date_key))
GROUP BY e.product_line, e.gender, 3, e.qualified_status
ORDER BY e.product_line, e.gender, 3;
```

#### 6.1.2 Lapse Experience Study

```sql
-- Lapse/Surrender experience study
WITH inforce_exposure AS (
    SELECT
        s.contract_key,
        p.product_line,
        p.product_code,
        c.qualified_status,
        FLOOR(DATEDIFF('month', c.issue_date, d.calendar_date) / 12.0) + 1 
            AS policy_year,
        CASE WHEN s.is_in_surrender_period THEN 'In SC' ELSE 'Post SC' END 
            AS sc_status,
        CASE 
            WHEN s.account_value <= 0 THEN 'Zero AV'
            WHEN s.account_value < 25000 THEN '<$25K'
            WHEN s.account_value < 100000 THEN '$25K-$100K'
            WHEN s.account_value < 250000 THEN '$100K-$250K'
            WHEN s.account_value < 500000 THEN '$250K-$500K'
            ELSE '$500K+'
        END AS av_band,
        -- ITM status for guaranteed benefits
        CASE 
            WHEN s.guaranteed_benefit_base > s.account_value * 1.1 THEN 'Deep ITM'
            WHEN s.guaranteed_benefit_base > s.account_value THEN 'ITM'
            WHEN s.guaranteed_benefit_base > s.account_value * 0.9 THEN 'ATM'
            ELSE 'OTM'
        END AS itm_status,
        1.0 / 12.0 AS exposure_fraction
    FROM fact_contract_monthly_snapshot s
    JOIN dim_contract c ON s.contract_key = c.contract_key AND c.is_current_row = TRUE
    JOIN dim_product p ON s.product_key = p.product_key
    JOIN dim_date d ON s.snapshot_date_key = d.date_key
    WHERE d.calendar_date BETWEEN '2020-01-01' AND '2024-12-31'
      AND c.contract_status IN ('Active', 'Surrendered', 'Lapsed')
),
lapses AS (
    SELECT DISTINCT
        contract_key,
        effective_date_key
    FROM fact_financial_transaction ft
    JOIN dim_transaction_type tt ON ft.transaction_type_key = tt.transaction_type_key
    WHERE tt.transaction_type_code IN ('SURRENDER', 'LAPSE')
)
SELECT
    ie.product_line,
    ie.policy_year,
    ie.sc_status,
    ie.av_band,
    ie.itm_status,
    ie.qualified_status,
    SUM(ie.exposure_fraction) AS total_exposure,
    COUNT(DISTINCT l.contract_key) AS lapse_count,
    COUNT(DISTINCT l.contract_key) / NULLIF(SUM(ie.exposure_fraction), 0) 
        AS crude_lapse_rate
FROM inforce_exposure ie
LEFT JOIN lapses l ON ie.contract_key = l.contract_key
GROUP BY ie.product_line, ie.policy_year, ie.sc_status, 
         ie.av_band, ie.itm_status, ie.qualified_status
ORDER BY ie.product_line, ie.policy_year;
```

#### 6.1.3 Rider Utilization Study

For guaranteed living benefit riders (GMWB/GLWB), utilization experience is critical:

- **Withdrawal utilization rate**: % of eligible contracts taking withdrawals
- **Withdrawal efficiency**: actual withdrawals vs. maximum allowed
- **Timing**: when do policyholders begin exercising their benefit?
- **Behavior segmentation**: systematic vs. ad-hoc, full vs. partial utilization

### 6.2 Assumption Setting

Experience studies feed into assumption setting, which is a core actuarial function. The data warehouse supports this by providing:

- **Historical experience data**: 5-10+ years of experience, stratified by key risk factors
- **Credibility analysis**: sufficient exposure for reliable rate estimates
- **Trend analysis**: directional changes in experience over time
- **Predictive factors**: which variables are most predictive of each risk

### 6.3 Product Profitability Analysis

```sql
-- Product profitability analysis (simplified)
WITH product_economics AS (
    SELECT
        p.product_line,
        p.product_code,
        p.product_name,
        COUNT(DISTINCT s.contract_key) AS inforce_count,
        SUM(s.account_value) AS total_av,
        
        -- Revenue components
        SUM(s.account_value * p.me_rate / 12) AS monthly_me_income,
        SUM(CASE WHEN c.gmwb_rider_flag OR c.glwb_rider_flag 
            THEN s.account_value * 0.01 / 12 ELSE 0 END) AS monthly_rider_income,
        SUM(CASE WHEN s.account_value > 50000 
            THEN 0 ELSE p.admin_fee / 12 END) AS monthly_admin_fees,
        
        -- Cost components  
        SUM(s.net_amount_at_risk * 0.001 / 12) AS monthly_mortality_cost,
        SUM(CASE WHEN c.gmwb_rider_flag 
            THEN GREATEST(0, s.guaranteed_benefit_base - s.account_value) * 0.002 / 12
            ELSE 0 END) AS monthly_rider_cost_estimate

    FROM fact_contract_monthly_snapshot s
    JOIN dim_contract c ON s.contract_key = c.contract_key AND c.is_current_row = TRUE
    JOIN dim_product p ON s.product_key = p.product_key
    JOIN dim_date d ON s.snapshot_date_key = d.date_key
    WHERE d.calendar_date = '2025-03-31'
      AND c.contract_status = 'Active'
    GROUP BY p.product_line, p.product_code, p.product_name
)
SELECT
    *,
    (monthly_me_income + monthly_rider_income + monthly_admin_fees) AS total_monthly_revenue,
    (monthly_mortality_cost + monthly_rider_cost_estimate) AS total_monthly_cost,
    (monthly_me_income + monthly_rider_income + monthly_admin_fees) 
        - (monthly_mortality_cost + monthly_rider_cost_estimate) AS monthly_margin,
    ((monthly_me_income + monthly_rider_income + monthly_admin_fees) 
        - (monthly_mortality_cost + monthly_rider_cost_estimate))
        / NULLIF(total_av, 0) * 12 * 10000 AS margin_bps_annualized
FROM product_economics
ORDER BY total_av DESC;
```

### 6.4 Reserve Calculation Data Support

The data warehouse provides the seriatim (contract-level) data required for reserve calculations across multiple accounting bases:

**Statutory Reserves (CARVM/AG 33/AG 43/VM-21):**
- Contract-level inforce data with all riders and elections
- Guaranteed benefit base values
- Fund allocation by sub-account
- Historical fund returns for scenario generation
- Standard scenario parameters from NAIC

**GAAP Reserves (ASC 944 / LDTI):**
- Contract-level cashflow projections
- Cohort groupings for LDTI
- Market risk benefit (MRB) fair value data
- Discount rate curves
- Actual vs. expected experience for unlocking

**IFRS 17 Reserves:**
- Contract grouping by profitability and cohort
- Contractual service margin (CSM) calculations
- Risk adjustment data
- Best estimate liability components

### 6.5 Inforce Reporting

The monthly inforce report is a cornerstone actuarial deliverable. The data warehouse produces a seriatim extract with:

```
CONTRACT-LEVEL INFORCE EXTRACT FIELDS:
─────────────────────────────────────
Contract identification
  - Contract number, issue date, effective date, status
  - Product code, plan code, product generation
  
Owner/Annuitant demographics  
  - Owner gender, DOB, issue age, attained age
  - Annuitant gender, DOB, issue age, attained age
  - Joint annuitant (if applicable)
  - State of issue, state of residence
  
Financial values
  - Account value (total and by sub-account)
  - Cash surrender value
  - Cumulative premiums, cumulative withdrawals
  
Rider information
  - Rider type, rider effective date
  - Guaranteed benefit base
  - Maximum annual withdrawal amount
  - Step-up history
  - Withdrawal utilization to date
  
Death benefit
  - Death benefit type (standard, enhanced, ratchet, roll-up)
  - Current death benefit amount
  - Net amount at risk
  
Fee information
  - M&E rate, rider charge rate
  - Admin fee waiver status
  - Current surrender charge percentage
  
Fund allocation
  - Sub-account allocations (ticker, units, value)
  - Fixed account balance (if applicable)
  - Dollar-cost averaging status
  - Auto-rebalance elections
  
Qualification
  - Tax qualification (IRA, Roth, NQ, 403b, etc.)
  - RMD status, RMD amount
  - Annuitization required date
```

---

## 7. Predictive Analytics

### 7.1 Lapse Prediction Models

Lapse prediction is the highest-impact predictive analytics use case for annuity carriers because surrenders directly affect AUM, fee revenue, and reserve adequacy.

#### 7.1.1 Feature Engineering

```python
# Key features for annuity lapse prediction
features = {
    # Contract characteristics
    "contract_duration_months": "Time since issue",
    "is_in_surrender_period": "Binary: still in SC period",
    "surrender_charge_pct": "Current surrender charge percentage",
    "months_to_sc_expiry": "Months until SC period ends",
    "product_line": "VA, FIA, FA, MYGA (categorical)",
    "qualified_status": "IRA, NQ, Roth, etc. (categorical)",
    
    # Financial features
    "account_value": "Current account value",
    "account_value_log": "Log-transformed AV",
    "gain_loss_pct": "(AV - Cumulative Premium) / Cumulative Premium",
    "cash_surrender_value": "AV minus surrender charges",
    "csv_to_premium_ratio": "CSV / Cumulative Premium",
    
    # Guaranteed benefit features (for VA with riders)
    "has_gmwb": "Binary: has guaranteed withdrawal rider",
    "benefit_base_to_av_ratio": "Benefit base / AV (ITM indicator)",
    "is_benefit_itm": "Binary: benefit base > AV",
    "itm_depth": "Max(0, benefit_base - AV) / AV",
    "withdrawal_utilization_pct": "YTD withdrawals / max allowed",
    "has_started_withdrawals": "Binary: has ever taken WD from rider",
    
    # Market features
    "sp500_return_3m": "S&P 500 3-month trailing return",
    "sp500_return_12m": "S&P 500 12-month trailing return",
    "sp500_volatility_30d": "30-day realized volatility",
    "interest_rate_10y": "10-year Treasury yield",
    "rate_change_12m": "Change in 10Y rate over 12 months",
    
    # Behavioral features
    "recent_withdrawal_count": "Withdrawals in last 6 months",
    "recent_call_count": "Service calls in last 6 months",
    "recent_web_login_count": "Web portal logins in last 3 months",
    "recent_address_change": "Binary: address changed in last 12 months",
    "recent_beneficiary_change": "Binary: bene changed in last 12 months",
    "systematic_withdrawal_active": "Binary: on SWP",
    
    # Agent features
    "agent_tenure_years": "Agent years with carrier",
    "agent_is_active": "Binary: agent still active",
    "agent_replacement_rate": "Historical replacement rate",
    "distribution_channel": "IMO, wirehouse, bank (categorical)",
    
    # Demographic features (owner)
    "owner_age": "Current age of owner",
    "owner_gender": "M/F",
    "owner_state": "State of residence (categorical)",
    "is_rmd_eligible": "Binary: owner age >= 73",
}
```

#### 7.1.2 Model Architecture

Recommended approach: **Gradient Boosted Trees (XGBoost/LightGBM)** for the primary model, with a **Survival Analysis** model (Cox proportional hazards or Random Survival Forest) for time-to-event prediction.

```
┌─────────────────────────────────────────────────────────────────┐
│              LAPSE PREDICTION MODEL ARCHITECTURE                 │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  ┌──────────┐    ┌──────────┐    ┌───────────┐    ┌──────────┐ │
│  │ Feature  │───→│  Model   │───→│  Score    │───→│  Action  │ │
│  │  Store   │    │ Pipeline │    │ Delivery  │    │  Engine  │ │
│  └──────────┘    └──────────┘    └───────────┘    └──────────┘ │
│       │               │               │                │        │
│  Monthly         XGBoost +        Batch: DW        Retention    │
│  seriatim        Survival         table             campaigns   │
│  extract         analysis         API: REST         Agent       │
│  + market        Ensemble                           alerts      │
│  data                                               Pricing     │
│                                                     adjustments │
└─────────────────────────────────────────────────────────────────┘
```

#### 7.1.3 Model Training Data Preparation

```sql
-- Training dataset for lapse prediction (12-month forward-looking)
WITH training_base AS (
    SELECT
        s.contract_key,
        s.snapshot_date_key,
        d.calendar_date AS observation_date,
        
        -- Target variable: did contract lapse/surrender in next 12 months?
        CASE WHEN EXISTS (
            SELECT 1 FROM fact_financial_transaction ft
            JOIN dim_transaction_type tt ON ft.transaction_type_key = tt.transaction_type_key
            JOIN dim_date fd ON ft.effective_date_key = fd.date_key
            WHERE ft.contract_key = s.contract_key
              AND tt.transaction_type_code IN ('SURRENDER', 'LAPSE')
              AND fd.calendar_date BETWEEN d.calendar_date 
                  AND d.calendar_date + INTERVAL '12 months'
        ) THEN 1 ELSE 0 END AS lapsed_12m,
        
        -- Features (subset shown)
        s.account_value,
        s.cash_surrender_value,
        s.guaranteed_benefit_base,
        s.contract_duration_months,
        s.is_in_surrender_period,
        s.surrender_charge_pct,
        s.withdrawal_utilization_pct,
        c.qualified_status,
        p.product_line,
        DATE_PART('year', AGE(d.calendar_date, party.date_of_birth)) AS owner_age,
        party.gender AS owner_gender,
        a.distribution_channel
        
    FROM fact_contract_monthly_snapshot s
    JOIN dim_date d ON s.snapshot_date_key = d.date_key
    JOIN dim_contract c ON s.contract_key = c.contract_key AND c.is_current_row = TRUE
    JOIN dim_product p ON s.product_key = p.product_key
    JOIN dim_party party ON s.party_key = party.party_key AND party.party_role = 'OWNER'
    JOIN dim_agent a ON s.agent_key = a.agent_key AND a.is_current_row = TRUE
    WHERE d.is_month_end = TRUE
      AND d.calendar_date BETWEEN '2019-01-31' AND '2023-12-31'
      AND c.contract_status = 'Active'
)
SELECT * FROM training_base;
```

### 7.2 Cross-Sell/Upsell Models

Predict which existing customers are most likely to purchase additional products or add riders.

**Target variable**: Did the customer purchase a new contract or add a rider within 6 months?

**Key features unique to cross-sell:**
- Number of existing contracts (wallet share)
- Total relationship value
- Product gaps (has VA but no FA, or vice versa)
- Recent life events (age milestones, address change)
- Agent relationship strength (multi-product agent)
- Digital engagement level

### 7.3 Fraud Detection Models

Annuity fraud patterns to detect:

| Fraud Pattern | Detection Approach | Key Signals |
|---|---|---|
| **Identity fraud** | Anomaly detection on application data | Mismatched demographics, velocity checks |
| **Agent churning** | Pattern analysis on replacements | High replacement rate, short duration surrenders |
| **Elder financial abuse** | Behavioral anomaly detection | Unusual withdrawal patterns, POA changes, beneficiary changes |
| **Money laundering** | Transaction pattern analysis | Structuring, rapid fund movement, unusual premium patterns |
| **Death claim fraud** | Document analysis + data validation | Timing anomalies, documentation inconsistencies |

```sql
-- Fraud detection: Agent churning indicator
SELECT
    a.agent_id,
    a.agent_name,
    a.distribution_channel,
    COUNT(DISTINCT CASE WHEN nb.is_replacement_flag = 'Y' 
          THEN nb.application_key END) AS replacement_count,
    COUNT(DISTINCT nb.application_key) AS total_app_count,
    COUNT(DISTINCT CASE WHEN nb.is_replacement_flag = 'Y' 
          THEN nb.application_key END) * 100.0 
        / NULLIF(COUNT(DISTINCT nb.application_key), 0) AS replacement_rate,
    
    -- Average duration of replaced contracts
    AVG(CASE WHEN nb.is_replacement_flag = 'Y' 
        THEN replaced_contract.contract_duration_months END) AS avg_replaced_duration,
    
    -- Replaced contracts still in surrender period
    SUM(CASE WHEN nb.is_replacement_flag = 'Y' 
         AND replaced_contract.is_in_surrender_period 
        THEN 1 ELSE 0 END) * 100.0 
        / NULLIF(COUNT(DISTINCT CASE WHEN nb.is_replacement_flag = 'Y' 
          THEN nb.application_key END), 0) AS pct_replaced_in_sc
    
FROM fact_new_business_pipeline nb
JOIN dim_agent a ON nb.agent_key = a.agent_key AND a.is_current_row = TRUE
LEFT JOIN dim_contract replaced_contract 
    ON nb.replaced_contract_key = replaced_contract.contract_key
JOIN dim_date d ON nb.app_received_date_key = d.date_key
WHERE d.calendar_year >= 2024
GROUP BY a.agent_id, a.agent_name, a.distribution_channel
HAVING COUNT(DISTINCT nb.application_key) >= 10
   AND COUNT(DISTINCT CASE WHEN nb.is_replacement_flag = 'Y' 
         THEN nb.application_key END) * 100.0 
       / NULLIF(COUNT(DISTINCT nb.application_key), 0) > 30
ORDER BY replacement_rate DESC;
```

### 7.4 Customer Lifetime Value (CLV) Models

CLV for annuity customers has unique characteristics:

- **Very long time horizons**: 20-40+ years of potential fee income
- **High upfront costs**: commissions and acquisition costs are front-loaded
- **Uncertain duration**: lapse risk makes future fees uncertain
- **Tail risk**: guaranteed benefits create potential large future costs
- **Multiple value streams**: M&E fees, rider charges, investment spread, admin fees

**CLV calculation framework:**

```
CLV = Σ(t=1 to T) [
    (Expected Fee Income_t - Expected Claims_t - Expected Expenses_t) 
    × Survival Probability_t 
    × Discount Factor_t
]

Where:
- Expected Fee Income_t = AV_t × fee_rate
- Expected Claims_t = Expected mortality cost + Expected rider cost
- Expected Expenses_t = Per-policy maintenance expense
- Survival Probability_t = Probability of not lapsing through period t
- Discount Factor_t = 1 / (1 + r)^t
```

### 7.5 Agent Attrition Prediction

Predict which agents are at risk of becoming unproductive or terminating their relationship.

**Key features:**
- Recent production trend (declining volumes)
- Commission income trend
- Activity recency (days since last submission)
- Competitive intelligence signals
- Training engagement
- Service interaction patterns

### 7.6 Model Deployment Patterns

```
┌──────────────────────────────────────────────────────────────────┐
│                MODEL DEPLOYMENT ARCHITECTURE                      │
├──────────────────────────────────────────────────────────────────┤
│                                                                   │
│  BATCH SCORING (Most common for annuity models)                   │
│  ┌──────────┐    ┌──────────┐    ┌──────────┐    ┌──────────┐   │
│  │ Monthly  │───→│  Model   │───→│  Score   │───→│  DW      │   │
│  │ Seriatim │    │  Server  │    │  Results │    │  Table   │   │
│  │ Extract  │    │(MLflow)  │    │          │    │          │   │
│  └──────────┘    └──────────┘    └──────────┘    └──────────┘   │
│                                                                   │
│  REAL-TIME SCORING (Fraud, application risk)                      │
│  ┌──────────┐    ┌──────────┐    ┌──────────┐    ┌──────────┐   │
│  │ API      │───→│  Model   │───→│  Score   │───→│  Decision│   │
│  │ Request  │    │  Service │    │  +       │    │  Engine  │   │
│  │          │    │ (SageMaker│   │  Explain │    │          │   │
│  │          │    │  /Vertex)│    │          │    │          │   │
│  └──────────┘    └──────────┘    └──────────┘    └──────────┘   │
│                                                                   │
│  EMBEDDED SCORING (Within ETL pipeline)                           │
│  ┌──────────┐    ┌──────────┐    ┌──────────┐                    │
│  │ dbt /    │───→│ Python   │───→│  Score   │                    │
│  │ Spark    │    │ UDF with │    │  Column  │                    │
│  │ Pipeline │    │  model   │    │  in Fact │                    │
│  └──────────┘    └──────────┘    └──────────┘                    │
│                                                                   │
└──────────────────────────────────────────────────────────────────┘
```

---

## 8. Regulatory Reporting Analytics

### 8.1 NAIC Statutory Reporting

The NAIC requires extensive data submissions from all licensed annuity carriers. The data warehouse must support:

#### 8.1.1 Annual Statement Schedules

| Schedule | Description | Data Source in DW |
|---|---|---|
| Schedule A | Real estate investments | Investment data mart |
| Schedule B | Mortgage loans | Investment data mart |
| Schedule D | Bonds and stocks | Investment data mart |
| Schedule DB | Derivatives | Investment data mart |
| Schedule S | Reinsurance | Reinsurance data mart |
| Exhibit 5 | Aggregate reserves | Actuarial data mart + contract snapshot |
| Exhibit 6 | Capital and surplus | Financial data mart |
| Exhibit 7 | Deposits | Contract/transaction data mart |

#### 8.1.2 NAIC Data Calls

Carriers receive periodic data calls requesting specific information. Common data calls relevant to annuities:

- **Variable Annuity Guaranteed Benefits Data Call**: Detailed data on guaranteed living and death benefits
- **Market Conduct Annual Statement (MCAS)**: Complaint data, replacement data, claims data
- **Experience Reporting**: Mortality, morbidity, lapse experience data

### 8.2 Risk-Based Capital (RBC) Data Support

The RBC calculation requires data from multiple domains:

```
┌──────────────────────────────────────────────────────────────────┐
│                    RBC CALCULATION DATA FLOW                      │
├──────────────────────────────────────────────────────────────────┤
│                                                                   │
│  C-1 (Asset Risk)                                                 │
│  └──→ Investment portfolio data, credit ratings, concentrations   │
│                                                                   │
│  C-2 (Insurance Risk)                                             │
│  └──→ Net amount at risk, mortality tables, claim experience      │
│                                                                   │
│  C-3 (Interest Rate Risk)                                         │
│  └──→ Asset/liability cash flows, duration matching, option risk  │
│       For VAs: AG 43 / VM-21 stochastic scenarios                 │
│                                                                   │
│  C-4 (Business Risk)                                              │
│  └──→ Premium volume, expense data, growth metrics                │
│                                                                   │
│  Covariance Adjustment                                            │
│  └──→ Correlation factors across risk categories                  │
│                                                                   │
│  RBC Ratio = Total Adjusted Capital / Authorized Control Level    │
│  Target: > 300% (Company Action Level)                            │
└──────────────────────────────────────────────────────────────────┘
```

### 8.3 Market Conduct Analysis

Market conduct data helps carriers prepare for and respond to regulatory examinations:

```sql
-- Market conduct examination readiness: Replacement analysis
SELECT
    d.calendar_year,
    g.state_code,
    g.state_name,
    
    -- Total new business
    COUNT(DISTINCT nb.application_key) AS total_applications,
    SUM(CASE WHEN nb.current_status = 'ISSUED' 
        THEN nb.issued_premium ELSE 0 END) AS total_issued_premium,
    
    -- Replacement activity
    COUNT(DISTINCT CASE WHEN nb.is_replacement_flag = 'Y' 
          THEN nb.application_key END) AS replacement_count,
    SUM(CASE WHEN nb.is_replacement_flag = 'Y' AND nb.current_status = 'ISSUED'
        THEN nb.issued_premium ELSE 0 END) AS replacement_premium,
    
    -- Replacement rates
    COUNT(DISTINCT CASE WHEN nb.is_replacement_flag = 'Y' 
          THEN nb.application_key END) * 100.0
        / NULLIF(COUNT(DISTINCT nb.application_key), 0) AS replacement_rate_count,
    SUM(CASE WHEN nb.is_replacement_flag = 'Y' AND nb.current_status = 'ISSUED'
        THEN nb.issued_premium ELSE 0 END) * 100.0
        / NULLIF(SUM(CASE WHEN nb.current_status = 'ISSUED' 
            THEN nb.issued_premium ELSE 0 END), 0) AS replacement_rate_premium,
    
    -- Internal vs External replacements
    COUNT(DISTINCT CASE WHEN nb.is_replacement_flag = 'Y' 
          AND nb.replaced_carrier = 'INTERNAL'
          THEN nb.application_key END) AS internal_replacement_count,
    COUNT(DISTINCT CASE WHEN nb.is_replacement_flag = 'Y' 
          AND nb.replaced_carrier != 'INTERNAL'
          THEN nb.application_key END) AS external_replacement_count,
    
    -- Suitability review results
    COUNT(DISTINCT CASE WHEN cs.has_deficiency 
          THEN nb.application_key END) AS suitability_deficiency_count,
    COUNT(DISTINCT CASE WHEN cs.has_deficiency 
          THEN nb.application_key END) * 100.0
        / NULLIF(COUNT(DISTINCT nb.application_key), 0) AS suitability_deficiency_rate

FROM fact_new_business_pipeline nb
JOIN dim_date d ON nb.app_received_date_key = d.date_key
JOIN dim_geography g ON nb.state_key = g.geography_key
LEFT JOIN fact_compliance_suitability cs ON nb.application_key = cs.application_key
WHERE d.calendar_year IN (2023, 2024, 2025)
GROUP BY d.calendar_year, g.state_code, g.state_name
ORDER BY g.state_code, d.calendar_year;
```

### 8.4 Complaint Trend Analysis

```sql
-- Complaint trend analysis for regulatory monitoring
SELECT
    d.calendar_year,
    d.quarter_number,
    complaint_category,
    complaint_subcategory,
    p.product_line,
    g.state_code,
    
    COUNT(*) AS complaint_count,
    COUNT(*) * 1000.0 / NULLIF(inforce.contract_count, 0) AS complaints_per_1000,
    AVG(resolution_days) AS avg_resolution_days,
    SUM(CASE WHEN escalated_to_doi THEN 1 ELSE 0 END) AS doi_escalation_count,
    SUM(CASE WHEN financial_remedy_amount > 0 THEN 1 ELSE 0 END) AS remediation_count,
    SUM(financial_remedy_amount) AS total_remediation_amount

FROM fact_complaint fc
JOIN dim_date d ON fc.received_date_key = d.date_key
JOIN dim_product p ON fc.product_key = p.product_key
JOIN dim_geography g ON fc.state_key = g.geography_key
LEFT JOIN (
    SELECT product_line, COUNT(DISTINCT contract_key) AS contract_count
    FROM fact_contract_monthly_snapshot s
    JOIN dim_product p ON s.product_key = p.product_key
    JOIN dim_date d ON s.snapshot_date_key = d.date_key
    WHERE d.calendar_date = (SELECT MAX(calendar_date) FROM dim_date WHERE is_month_end)
    GROUP BY product_line
) inforce ON p.product_line = inforce.product_line
GROUP BY d.calendar_year, d.quarter_number, complaint_category, 
         complaint_subcategory, p.product_line, g.state_code, inforce.contract_count
ORDER BY d.calendar_year, d.quarter_number, complaint_count DESC;
```

### 8.5 State-Specific Reporting

Each state has unique reporting requirements. The data warehouse must support:

- **California AB 2756**: Enhanced annuity suitability requirements
- **New York Regulation 187**: Best interest standard (pre-dates SEC Reg BI)
- **Various state data calls**: Premium tax reports, abandoned property, unclaimed benefits
- **Guaranty fund assessments**: Data for state guaranty fund assessment calculations

### 8.6 ORSA (Own Risk and Solvency Assessment)

ORSA requires enterprise risk data aggregation:

- **Insurance risk**: mortality, longevity, lapse, expense, catastrophe
- **Market risk**: equity, interest rate, credit spread, currency, real estate
- **Credit risk**: counterparty, reinsurance, investment default
- **Operational risk**: process failures, systems, external events
- **Liquidity risk**: cash flow projections, stress scenarios
- **Strategic risk**: competitive position, regulatory changes

The data warehouse provides the historical data foundation for ORSA risk quantification and scenario analysis.

---

## 9. Modern Data Platform Architecture

### 9.1 Data Lake Architecture

A modern annuity analytics platform supplements or replaces the traditional data warehouse with a data lake or lakehouse architecture.

#### 9.1.1 Data Lake Zones

```
┌──────────────────────────────────────────────────────────────────┐
│                    DATA LAKE ZONE ARCHITECTURE                    │
├──────────────────────────────────────────────────────────────────┤
│                                                                   │
│  RAW / BRONZE ZONE (S3: s3://annuity-lake/raw/)                  │
│  ┌────────────────────────────────────────────────────────┐      │
│  │ Exact copy of source data, immutable, append-only      │      │
│  │ Formats: CSV, JSON, Avro, Parquet (as received)        │      │
│  │ Retention: 7+ years (regulatory requirement)           │      │
│  │ Partitioned by: source_system / date / entity_type     │      │
│  │ Examples:                                               │      │
│  │   raw/pas/contracts/2025/01/31/contracts.parquet       │      │
│  │   raw/dtcc/applications/2025/01/31/apps.json           │      │
│  │   raw/nav_feeds/2025/01/31/nav_daily.csv              │      │
│  └────────────────────────────────────────────────────────┘      │
│                          │                                        │
│                          ▼                                        │
│  CURATED / SILVER ZONE (s3://annuity-lake/curated/)              │
│  ┌────────────────────────────────────────────────────────┐      │
│  │ Cleaned, deduplicated, conformed, and validated         │      │
│  │ Format: Delta Lake / Iceberg (Parquet + transaction log)│      │
│  │ Schema-enforced, quality-checked                        │      │
│  │ Partitioned by: business date, product line             │      │
│  │ Examples:                                               │      │
│  │   curated/contract_master/ (Delta table)               │      │
│  │   curated/financial_transactions/ (Delta table)        │      │
│  │   curated/daily_valuations/ (Delta table)              │      │
│  └────────────────────────────────────────────────────────┘      │
│                          │                                        │
│                          ▼                                        │
│  CONSUMPTION / GOLD ZONE (s3://annuity-lake/consumption/)        │
│  ┌────────────────────────────────────────────────────────┐      │
│  │ Business-ready dimensional models, aggregations, KPIs   │      │
│  │ Format: Delta Lake / Iceberg, also materialized in DW   │      │
│  │ Optimized for query patterns of specific user groups    │      │
│  │ Examples:                                               │      │
│  │   consumption/sales_mart/                              │      │
│  │   consumption/actuarial_seriatim/                      │      │
│  │   consumption/financial_reporting/                     │      │
│  │   consumption/compliance_mart/                         │      │
│  └────────────────────────────────────────────────────────┘      │
│                                                                   │
└──────────────────────────────────────────────────────────────────┘
```

### 9.2 Lakehouse Pattern

The lakehouse pattern combines the flexibility of data lakes with the performance and governance of data warehouses. For annuity analytics, the recommended lakehouse stack is:

#### Option A: Databricks Lakehouse

```
┌──────────────────────────────────────────────────────────────────┐
│                   DATABRICKS LAKEHOUSE FOR ANNUITIES              │
├──────────────────────────────────────────────────────────────────┤
│                                                                   │
│  Storage: S3 / ADLS with Delta Lake format                       │
│  Compute: Databricks Runtime (Spark-based)                       │
│  SQL: Databricks SQL Warehouses (for BI workloads)               │
│  ML: MLflow for model lifecycle management                       │
│  Governance: Unity Catalog                                       │
│                                                                   │
│  Key capabilities for annuities:                                  │
│  - Delta Lake ACID transactions for reliable ETL                  │
│  - Time travel for regulatory point-in-time queries               │
│  - Structured Streaming for CDC ingestion                         │
│  - Photon engine for fast SQL analytics                           │
│  - MLflow for lapse/fraud model management                        │
│  - Unity Catalog for PII governance                               │
│                                                                   │
│  ┌─────────┐    ┌──────────┐    ┌──────────┐    ┌──────────┐   │
│  │ Bronze  │───→│  Silver  │───→│   Gold   │───→│  ML /    │   │
│  │ (Raw)   │    │ (Clean)  │    │  (Marts) │    │  BI      │   │
│  └─────────┘    └──────────┘    └──────────┘    └──────────┘   │
│       │              │               │                │          │
│   Delta Lake    Delta Lake      Delta Lake       Databricks     │
│   tables        tables          tables           SQL + MLflow   │
└──────────────────────────────────────────────────────────────────┘
```

#### Option B: Snowflake + dbt

```
┌──────────────────────────────────────────────────────────────────┐
│                 SNOWFLAKE + dbt FOR ANNUITIES                     │
├──────────────────────────────────────────────────────────────────┤
│                                                                   │
│  Storage: Snowflake managed storage (micro-partitions)           │
│  Compute: Snowflake virtual warehouses (auto-scaling)            │
│  Transformation: dbt (SQL-first, version-controlled)             │
│  ML: Snowpark for Python-based ML workloads                      │
│  Governance: Snowflake data governance features                  │
│                                                                   │
│  Key capabilities for annuities:                                  │
│  - Zero-copy cloning for dev/test environments                    │
│  - Time travel (up to 90 days) for point-in-time queries         │
│  - Automatic clustering for large fact tables                     │
│  - Semi-structured data support (VARIANT for ACORD XML/JSON)     │
│  - Data sharing for distributor/reinsurer analytics               │
│  - Snowpark for actuarial model execution                         │
│                                                                   │
│  ┌───────────┐    ┌──────────┐    ┌──────────┐                  │
│  │ External  │───→│ dbt      │───→│ Snowflake│                  │
│  │ Stages    │    │ Models   │    │  Tables  │                  │
│  │(S3/ADLS)  │    │          │    │          │                  │
│  └───────────┘    └──────────┘    └──────────┘                  │
│       │                │               │                         │
│   Raw files       Bronze→Silver→   Consumption                   │
│   (Parquet,       Gold             layer for BI                  │
│    CSV, JSON)     transformations  and analytics                 │
└──────────────────────────────────────────────────────────────────┘
```

### 9.3 Streaming Analytics

Real-time or near-real-time analytics for annuity use cases:

```
┌──────────────────────────────────────────────────────────────────┐
│                 STREAMING ANALYTICS ARCHITECTURE                  │
├──────────────────────────────────────────────────────────────────┤
│                                                                   │
│  Sources:                                                         │
│  ┌────────┐ ┌────────┐ ┌────────┐ ┌────────┐ ┌────────┐        │
│  │  PAS   │ │  Web   │ │  Call  │ │  DTCC  │ │  NAV   │        │
│  │ (CDC)  │ │ Portal │ │ Center │ │ Events │ │ Feeds  │        │
│  └───┬────┘ └───┬────┘ └───┬────┘ └───┬────┘ └───┬────┘        │
│      │          │          │          │          │               │
│      ▼          ▼          ▼          ▼          ▼               │
│  ┌──────────────────────────────────────────────────────┐       │
│  │                 Apache Kafka                          │       │
│  │  Topics:                                              │       │
│  │    annuity.contracts.cdc                              │       │
│  │    annuity.transactions.cdc                           │       │
│  │    annuity.web.clickstream                            │       │
│  │    annuity.calls.events                               │       │
│  │    annuity.dtcc.applications                          │       │
│  │    annuity.nav.daily                                  │       │
│  └─────────┬──────────┬──────────┬──────────────────────┘       │
│            │          │          │                                │
│            ▼          ▼          ▼                                │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐                      │
│  │  Flink   │  │  Flink   │  │  Flink   │                      │
│  │  Fraud   │  │  Real-   │  │  Event   │                      │
│  │  Detect  │  │  Time    │  │  Enrich  │                      │
│  │          │  │  KPIs    │  │  + Load  │                      │
│  └──────────┘  └──────────┘  └──────────┘                      │
│       │              │              │                             │
│       ▼              ▼              ▼                             │
│  Alert         Real-time        Delta Lake /                     │
│  System        Dashboard        Snowflake                        │
│                                 (near-RT)                        │
└──────────────────────────────────────────────────────────────────┘
```

**Streaming use cases in annuity analytics:**

| Use Case | Kafka Topic | Flink Job | Output |
|---|---|---|---|
| Fraud detection | transactions.cdc | Pattern matching, velocity checks | Alerts to compliance |
| Real-time AV | transactions.cdc + nav.daily | Running balance calculation | API / dashboard |
| App status tracking | dtcc.applications | Status enrichment | CRM / agent portal |
| SLA monitoring | All operational topics | Elapsed time calculations | Operations dashboard |
| Call center context | calls.events + contracts.cdc | Customer 360 assembly | Agent desktop |

### 9.4 Cloud Data Warehouse Comparison

| Capability | Snowflake | Databricks | BigQuery | Redshift |
|---|---|---|---|---|
| **Annuity-specific strengths** | |||
| Semi-structured (ACORD XML) | Excellent (VARIANT) | Good (JSON) | Good (JSON) | Limited |
| Time travel (PIT queries) | Up to 90 days | Unlimited (Delta) | 7 days | Manual snapshots |
| Data sharing (distributors) | Excellent | Good | Good | Limited |
| ML/Actuarial workloads | Good (Snowpark) | Excellent (Spark ML) | Good (BigQuery ML) | Limited |
| **General capabilities** | |||
| Separation of compute/storage | Yes | Yes | Yes | Partial (RA3) |
| Auto-scaling | Yes | Yes | Yes (serverless) | Yes (serverless) |
| Concurrency handling | Multi-cluster | SQL warehouses | Slots | WLM queues |
| Cost model | Credits/compute | DBUs | Slots/on-demand | Node-hours |
| Ecosystem | Broad | Broad | Google-centric | AWS-centric |
| **Recommendation** | Best overall DW | Best for ML/actuarial | Best if on GCP | Legacy/cost-sensitive |

### 9.5 Data Mesh Principles Applied to Annuities

Data mesh decomposes the monolithic data platform into domain-oriented data products, each owned by the domain team.

```
┌──────────────────────────────────────────────────────────────────┐
│              DATA MESH FOR ANNUITY CARRIER                        │
├──────────────────────────────────────────────────────────────────┤
│                                                                   │
│  DOMAIN: New Business & Distribution                              │
│  Owner: Sales Operations team                                     │
│  Data Products:                                                   │
│    - New business pipeline (applications → issue)                 │
│    - Agent/producer master                                        │
│    - Channel performance metrics                                  │
│                                                                   │
│  DOMAIN: Policy Administration                                    │
│  Owner: Operations team                                           │
│  Data Products:                                                   │
│    - Contract inforce master                                      │
│    - Financial transactions                                       │
│    - Servicing activity                                            │
│                                                                   │
│  DOMAIN: Finance & Actuarial                                      │
│  Owner: Actuarial / Finance team                                  │
│  Data Products:                                                   │
│    - Seriatim valuation files                                     │
│    - Reserve datasets                                             │
│    - Experience study extracts                                    │
│    - Financial reporting packages                                 │
│                                                                   │
│  DOMAIN: Compliance & Risk                                        │
│  Owner: Compliance team                                           │
│  Data Products:                                                   │
│    - Suitability review data                                      │
│    - AML monitoring data                                          │
│    - Regulatory filing packages                                   │
│    - Complaint data                                               │
│                                                                   │
│  DOMAIN: Investment                                               │
│  Owner: Investment management team                                │
│  Data Products:                                                   │
│    - Fund performance                                             │
│    - Sub-account NAVs                                             │
│    - Asset allocation                                             │
│                                                                   │
│  FEDERATED GOVERNANCE                                             │
│  ┌────────────────────────────────────────────────────┐          │
│  │ Global policies: PII handling, retention, naming    │          │
│  │ Data catalog: Unity Catalog / Atlan / Alation       │          │
│  │ Quality SLAs: Each domain publishes quality metrics  │          │
│  │ Interoperability: Conformed dimensions as contracts  │          │
│  └────────────────────────────────────────────────────┘          │
│                                                                   │
└──────────────────────────────────────────────────────────────────┘
```

**Key data mesh principles for annuities:**

1. **Domain ownership**: The team that generates the data owns the data product. The PAS team owns the contract and transaction data products, not the central data team.

2. **Data as a product**: Each data product has an SLA, documentation, quality guarantees, and a defined interface (schema).

3. **Self-serve infrastructure**: A central platform team provides the tools (Databricks/Snowflake, Kafka, dbt, Airflow) that domain teams use to build their data products.

4. **Federated computational governance**: Global policies (PII masking, naming standards, conformed dimension specs) are centrally defined but locally enforced.

### 9.6 Data Catalog and Metadata Management

A data catalog is essential for a complex annuity analytics platform. It provides:

**Technical metadata:**
- Schema definitions, data types, constraints
- Lineage (source → staging → curated → consumption)
- Freshness (when was the data last updated?)
- Volume (how many rows, partitions, files?)

**Business metadata:**
- Business glossary (what does "account value" mean exactly?)
- Data ownership (who is the steward for contract data?)
- Usage patterns (who queries this table and how often?)
- Quality scores (what is the data quality SLA and current score?)

**Recommended catalog tools:**

| Tool | Strengths | Best For |
|---|---|---|
| **Atlan** | Modern, active metadata, collaboration | Enterprise-wide catalog |
| **Alation** | Strong BI integration, data governance | BI-heavy environments |
| **Unity Catalog** (Databricks) | Native Delta Lake integration, fine-grained access | Databricks shops |
| **AWS Glue Catalog** | S3/Athena integration, serverless | AWS-native stacks |
| **DataHub** (open source) | Extensible, community-driven | Cost-conscious teams |
| **OpenMetadata** (open source) | Modern, API-first, good lineage | Open-source preference |

---

## 10. Reporting & Visualization

### 10.1 Executive Dashboards

Executive dashboards provide C-suite visibility into the annuity business. They should be updated daily and show trailing performance with trend indicators.

**Key executive dashboard components:**

```
┌──────────────────────────────────────────────────────────────────┐
│              ANNUITY EXECUTIVE DASHBOARD                          │
├──────────────────────────────────────────────────────────────────┤
│                                                                   │
│  TOP ROW: KEY METRICS (large KPI tiles with trend arrows)        │
│  ┌─────────┐ ┌─────────┐ ┌─────────┐ ┌─────────┐ ┌─────────┐  │
│  │ Total   │ │ YTD New │ │ Net     │ │ Lapse   │ │ RBC     │  │
│  │ AUM     │ │ Biz     │ │ Flows   │ │ Rate    │ │ Ratio   │  │
│  │ $85.2B  │ │ $4.1B   │ │ +$1.2B  │ │ 5.8%   │ │ 425%    │  │
│  │ ▲ 3.2%  │ │ ▲ 8.1%  │ │ ▲ 15%  │ │ ▼ 0.3% │ │ ▲ 12pt  │  │
│  └─────────┘ └─────────┘ └─────────┘ └─────────┘ └─────────┘  │
│                                                                   │
│  MIDDLE ROW: TREND CHARTS                                        │
│  ┌─────────────────────┐ ┌─────────────────────────────────┐    │
│  │ Monthly Premium     │ │ Product Mix (Stacked Area)       │    │
│  │ vs Plan (Bar+Line)  │ │ VA | FIA | FA | MYGA             │    │
│  └─────────────────────┘ └─────────────────────────────────┘    │
│                                                                   │
│  BOTTOM ROW: DETAIL TABLES                                       │
│  ┌─────────────────────┐ ┌─────────────────────────────────┐    │
│  │ Channel Performance │ │ Top 10 States by Premium         │    │
│  │ (sortable table)    │ │ (map + table)                    │    │
│  └─────────────────────┘ └─────────────────────────────────┘    │
│                                                                   │
└──────────────────────────────────────────────────────────────────┘
```

### 10.2 Operational Dashboards

Operational dashboards are used by operations managers and supervisors throughout the day:

**New Business Pipeline Dashboard:**
- Applications received today/this week
- Current pipeline inventory by status
- Aging analysis (applications in each status > SLA)
- NIGO analysis by reason code
- STP rate trending
- Cycle time distribution

**Servicing Dashboard:**
- Transaction queue depth by type
- Transactions processed today vs. target
- Average turnaround time (real-time)
- Error rate today
- Workforce utilization
- Correspondence backlog

**Call Center Dashboard:**
- Calls in queue (real-time)
- Average wait time (real-time)
- Calls handled today
- Average handle time
- First-call resolution rate
- Abandonment rate

### 10.3 Self-Service BI

Self-service BI enables business users to create their own analyses without depending on the data team. For annuity analytics, this requires:

**Semantic layer:**
A semantic model that translates physical database structures into business-friendly terms:
- "Account Value" instead of `fact_monthly_snap.acct_val_amt`
- "Product Type" instead of `dim_product.prod_line_cd`
- Pre-defined measures with correct aggregation rules (SUM for AV, AVG for rates)
- Row-level security (users only see contracts in their jurisdiction)

**Governed datasets:**
Pre-built, validated datasets for common analytical needs:
- Sales analysis dataset (new business + agent + product + state + date)
- Inforce analysis dataset (snapshot + contract + product + state + date)
- Transaction analysis dataset (transactions + contract + product + date)
- Agent analysis dataset (agent + commission + production)

**Tools for self-service BI in annuity context:**

| Tool | Strengths | Considerations |
|---|---|---|
| **Tableau** | Best visualizations, strong community | Expensive at scale, governance challenges |
| **Power BI** | Cost-effective, strong Microsoft integration | Performance with large datasets |
| **Looker** | Strong semantic layer (LookML), governed | Steeper learning curve |
| **Sigma** | Spreadsheet-like interface, direct cloud DW connection | Newer product |
| **ThoughtSpot** | Natural language search interface | Limited customization |

### 10.4 Embedded Analytics

Embed analytics directly into operational systems for contextual decision-making:

- **Agent portal**: Embed book-of-business dashboard showing each agent's inforce, production, commission, and persistency
- **Customer service desktop**: Embed contract summary, recent transactions, and risk indicators into the service representative's screen
- **Underwriting workbench**: Embed suitability analytics and risk scores into the review workflow
- **Management console**: Embed real-time operational KPIs into the manager's dashboard

### 10.5 Report Distribution and Scheduling

| Report | Audience | Frequency | Format | Distribution |
|---|---|---|---|---|
| Executive Scorecard | C-suite, Board | Monthly | PDF + Interactive | Email + Portal |
| Sales Flash Report | Sales leadership | Daily | Dashboard | Portal |
| Inforce Summary | Finance, Actuarial | Monthly | Excel + Dashboard | Email + SharePoint |
| Agent Statement | Agents | Monthly/Quarterly | PDF | Agent portal / Mail |
| Regulatory Package | Compliance, DOI | Quarterly/Annual | Formatted reports | Filing system |
| Experience Study | Actuarial | Quarterly | Excel + Statistical | Internal |
| Data Quality Report | Data Engineering | Daily | Dashboard + Email | Automated alert |
| Reconciliation Report | Finance, IT | Daily | Excel | Email |

---

## 11. Data Governance for Analytics

### 11.1 Data Lineage

Data lineage tracks the end-to-end journey of data from source to consumption. For annuity analytics, lineage is critical for:

- **Regulatory compliance**: Demonstrating the provenance of reported numbers
- **Impact analysis**: Understanding what breaks when a source system changes
- **Root cause analysis**: Tracing data quality issues back to their source
- **Audit support**: Proving that reported data is derived from authoritative sources

**Lineage levels:**

```
COLUMN-LEVEL LINEAGE EXAMPLE:
────────────────────────────────────────────────────────────────

Source: PAS.CONTRACT.ACCT_VAL_AMT
  │
  ▼
Staging: STG_PAS_CONTRACT.account_value_raw
  │ (Quality check: NOT NULL, >= 0, <= 50,000,000)
  ▼
Silver: CURATED.CONTRACT_MASTER.account_value
  │ (Transformation: converted from cents to dollars, rounded to 2 decimals)
  ▼
Gold: CONSUMPTION.FACT_CONTRACT_MONTHLY_SNAPSHOT.account_value
  │ (Aggregation: point-in-time value as of snapshot_date)
  ▼
Report: Executive Dashboard → "Total AUM" KPI
  (Aggregation: SUM across all active contracts)
```

**Lineage tools:**

| Tool | Integration | Approach |
|---|---|---|
| dbt lineage | dbt projects | Automatic from SQL references |
| Unity Catalog lineage | Databricks | Automatic from Spark jobs |
| OpenLineage | Airflow, Spark, dbt | Open standard, cross-tool |
| Atlan/Alation | Multiple | Automated + manual enrichment |
| Monte Carlo | Multiple | Automated discovery |

### 11.2 Data Quality Monitoring

#### 11.2.1 Quality Dimensions for Annuity Data

| Dimension | Definition | Example Check | Threshold |
|---|---|---|---|
| **Completeness** | % of required fields populated | Contract number is not null | 100% |
| **Accuracy** | Data correctly represents reality | AV matches PAS balance | 99.99% |
| **Consistency** | Same data yields same result across views | DW AV = PAS AV = Statement AV | 100% |
| **Timeliness** | Data available when needed | Daily data available by 7 AM | 99% |
| **Uniqueness** | No unintended duplicates | One active row per contract | 100% |
| **Validity** | Values conform to business rules | Status in valid set | 100% |

#### 11.2.2 Quality Monitoring Implementation

```sql
-- Data quality monitoring: Daily quality scorecard
WITH quality_checks AS (
    -- Completeness checks
    SELECT 'Completeness' AS dimension,
           'Contract number not null' AS check_name,
           COUNT(*) AS total_records,
           SUM(CASE WHEN contract_number IS NULL THEN 1 ELSE 0 END) AS failed_records
    FROM staging_contract
    
    UNION ALL
    
    SELECT 'Completeness', 'Account value not null',
           COUNT(*),
           SUM(CASE WHEN account_value IS NULL THEN 1 ELSE 0 END)
    FROM staging_contract
    WHERE contract_status = 'A'
    
    UNION ALL
    
    -- Validity checks
    SELECT 'Validity', 'Contract status in valid set',
           COUNT(*),
           SUM(CASE WHEN contract_status NOT IN ('A','S','DC','AN','M','L','FL') 
               THEN 1 ELSE 0 END)
    FROM staging_contract
    
    UNION ALL
    
    -- Consistency checks
    SELECT 'Consistency', 'CSV <= Account Value',
           COUNT(*),
           SUM(CASE WHEN cash_surrender_value > account_value + 0.01 
               THEN 1 ELSE 0 END)
    FROM staging_contract
    WHERE contract_status = 'A'
    
    UNION ALL
    
    -- Reasonableness checks
    SELECT 'Reasonableness', 'Account value between 0 and 50M',
           COUNT(*),
           SUM(CASE WHEN account_value < 0 OR account_value > 50000000 
               THEN 1 ELSE 0 END)
    FROM staging_contract
    WHERE contract_status = 'A'
    
    UNION ALL
    
    -- Referential integrity
    SELECT 'Referential Integrity', 'Product code exists in product master',
           COUNT(*),
           SUM(CASE WHEN NOT EXISTS (
               SELECT 1 FROM dim_product p 
               WHERE p.product_code = sc.product_code
           ) THEN 1 ELSE 0 END)
    FROM staging_contract sc
)
SELECT
    dimension,
    check_name,
    total_records,
    failed_records,
    (total_records - failed_records) * 100.0 / NULLIF(total_records, 0) AS pass_rate,
    CASE 
        WHEN failed_records = 0 THEN 'PASS'
        WHEN (total_records - failed_records) * 100.0 / total_records > 99.9 THEN 'WARN'
        ELSE 'FAIL'
    END AS status
FROM quality_checks
ORDER BY status DESC, dimension;
```

#### 11.2.3 Great Expectations Example

```python
# Great Expectations suite for annuity contract data
import great_expectations as gx

context = gx.get_context()

suite = context.add_expectation_suite("annuity_contract_quality")

# Completeness
suite.add_expectation(
    gx.expectations.ExpectColumnValuesToNotBeNull(column="contract_number")
)
suite.add_expectation(
    gx.expectations.ExpectColumnValuesToNotBeNull(
        column="account_value",
        condition_parser="pandas",
        row_condition='contract_status=="Active"'
    )
)

# Validity
suite.add_expectation(
    gx.expectations.ExpectColumnValuesToBeInSet(
        column="contract_status",
        value_set=["Active", "Surrendered", "Death Claim", 
                   "Annuitized", "Matured", "Lapsed", "Free Look Cancel"]
    )
)
suite.add_expectation(
    gx.expectations.ExpectColumnValuesToBeInSet(
        column="product_line",
        value_set=["VA", "FIA", "FA", "MYGA", "SPIA", "DIA"]
    )
)

# Reasonableness
suite.add_expectation(
    gx.expectations.ExpectColumnValuesToBeBetween(
        column="account_value", min_value=0, max_value=50_000_000
    )
)
suite.add_expectation(
    gx.expectations.ExpectColumnValuesToBeBetween(
        column="owner_age_at_issue", min_value=0, max_value=100
    )
)

# Uniqueness
suite.add_expectation(
    gx.expectations.ExpectCompoundColumnsToBeUnique(
        column_list=["contract_number", "snapshot_date"]
    )
)

# Volume / shape
suite.add_expectation(
    gx.expectations.ExpectTableRowCountToBeBetween(
        min_value=400_000, max_value=600_000  # expected inforce range
    )
)
```

### 11.3 Data Dictionary / Business Glossary

A business glossary ensures consistent understanding of key terms across the organization. Critical annuity terms to define:

| Term | Business Definition | Calculation | Source of Truth |
|---|---|---|---|
| **Account Value** | The current market value of all sub-account holdings plus any fixed account balance for a contract | SUM(sub_account_units × NAV) + fixed_account_balance | PAS daily valuation |
| **Cash Surrender Value** | The amount a policyholder would receive upon full surrender | Account Value - Surrender Charge - MVA + Free Credit | PAS calculation |
| **Net Amount at Risk** | The excess of death benefit over account value | MAX(0, Death Benefit - Account Value) | DW calculated |
| **Guaranteed Benefit Base** | The base amount used to calculate guaranteed living benefit payments | Complex: varies by rider type; typically MAX of premiums, step-ups, roll-ups | PAS rider valuation |
| **Persistency** | The percentage of contracts remaining inforce after a specified period | Contracts inforce at end / Contracts inforce at beginning of period | DW calculated |
| **Lapse Rate** | The annualized rate at which contracts terminate (surrender or lapse) | (Surrenders + Lapses in period) / (Average inforce in period) | DW calculated |
| **Net Flow** | The difference between money coming in and going out | Premiums - Surrenders - Withdrawals - Death Claims | DW calculated |
| **M&E Charge** | Mortality and Expense risk charge assessed on variable annuity account value | Account Value × M&E Rate / 365 (daily) | PAS charge schedule |
| **STP Rate** | Straight-Through Processing rate; percentage of transactions requiring no manual intervention | Auto-processed / Total processed | Workflow system |
| **NIGO Rate** | Not In Good Order rate; percentage of submissions returned for corrections | NIGO submissions / Total submissions | New business system |

### 11.4 PII Handling in Analytics

Annuity data contains extensive PII that must be protected:

**PII elements in annuity data:**
- Social Security Number (SSN)
- Full name (first, middle, last)
- Date of birth
- Address (street, city, state, ZIP)
- Phone number, email address
- Bank account information (for EFT)
- Financial information (income, net worth, account values)
- Beneficiary information

**Protection strategies:**

| Strategy | Implementation | Use Case |
|---|---|---|
| **Tokenization** | Replace SSN with non-reversible token | Cross-system party matching |
| **Hashing** | SHA-256 hash of SSN | Deduplication, without reversibility |
| **Masking** | Show only last 4 of SSN (***-**-1234) | Customer service displays |
| **Encryption** | AES-256 encryption at rest | Stored PII in warehouse |
| **Dynamic masking** | Role-based runtime masking | BI tool access based on role |
| **Generalization** | Birth year instead of DOB, ZIP3 instead of ZIP5 | Analytical datasets |
| **Row-level security** | Users see only their jurisdiction/segment | Multi-tenant access |

**Implementation in Snowflake (dynamic masking):**

```sql
-- Create masking policy for SSN
CREATE OR REPLACE MASKING POLICY ssn_mask AS (val STRING) 
RETURNS STRING ->
    CASE
        WHEN CURRENT_ROLE() IN ('COMPLIANCE_ADMIN', 'CLAIMS_PROCESSOR') THEN val
        WHEN CURRENT_ROLE() IN ('OPERATIONS_ANALYST') THEN '***-**-' || RIGHT(val, 4)
        ELSE '***-**-****'
    END;

-- Apply masking policy to column
ALTER TABLE dim_party 
MODIFY COLUMN ssn SET MASKING POLICY ssn_mask;

-- Create masking policy for DOB (generalize to birth year for analytics)
CREATE OR REPLACE MASKING POLICY dob_mask AS (val DATE) 
RETURNS DATE ->
    CASE
        WHEN CURRENT_ROLE() IN ('COMPLIANCE_ADMIN', 'CLAIMS_PROCESSOR') THEN val
        WHEN CURRENT_ROLE() IN ('ACTUARY', 'DATA_SCIENTIST') THEN val  -- need exact DOB
        ELSE DATE_TRUNC('YEAR', val)  -- only birth year
    END;

ALTER TABLE dim_party 
MODIFY COLUMN date_of_birth SET MASKING POLICY dob_mask;
```

### 11.5 Data Access Controls

**Role-based access model for annuity analytics:**

```
┌──────────────────────────────────────────────────────────────────┐
│                DATA ACCESS CONTROL MATRIX                         │
├─────────────────┬────────┬────────┬────────┬────────┬───────────┤
│ Role            │Contract│Financial│ PII   │Actuarial│Compliance │
│                 │ Data   │  Data  │ Data   │ Data   │  Data     │
├─────────────────┼────────┼────────┼────────┼────────┼───────────┤
│ Executive       │ Agg    │ Agg    │ None   │ Agg    │ Agg       │
│ Finance Analyst │ Detail │ Detail │ Masked │ Detail │ Summary   │
│ Actuary         │ Detail │ Detail │ DOB/Age│ Detail │ None      │
│ Operations Mgr  │ Detail │ Summary│ Masked │ None   │ None      │
│ Compliance Ofc  │ Detail │ Detail │ Full   │ None   │ Full      │
│ Sales Analyst   │ Summary│ None   │ None   │ None   │ None      │
│ Agent (external)│ Own    │ Own    │ Own    │ None   │ None      │
│ Data Scientist  │ Detail │ Detail │ DOB/Age│ Detail │ Masked    │
│ Data Engineer   │ Schema │ Schema │ None   │ Schema │ Schema    │
├─────────────────┼────────┼────────┼────────┼────────┼───────────┤
│ Legend:                                                           │
│ Full = All data  │ Detail = Row-level  │ Agg = Aggregated only   │
│ Masked = PII masked  │ Own = Own records only  │ None = No access│
│ DOB/Age = DOB but no SSN  │ Schema = Structure only, no data    │
└──────────────────────────────────────────────────────────────────┘
```

### 11.6 Data Retention in Warehouse

Annuity data retention must balance storage costs with regulatory and business requirements:

| Data Category | Minimum Retention | Recommendation | Rationale |
|---|---|---|---|
| **Contract master** | Life of contract + 10 years | Life + 15 years | Tax reporting, litigation |
| **Financial transactions** | 7 years after contract termination | Life + 10 years | Regulatory, tax |
| **Compliance records** | 7-10 years (varies by state) | 10 years | Regulatory examination |
| **AML/SAR records** | 5 years from filing | 7 years | BSA/AML requirements |
| **Suitability records** | 6 years (FINRA) / varies | 10 years | Reg BI, state requirements |
| **Experience study data** | 10+ years minimum | Unlimited | Actuarial credibility |
| **Daily snapshots** | 7 years detailed | Detailed 7 years, aggregated forever | Balance storage/analytics |
| **Raw source extracts** | 3-5 years | 5 years in lake | Reprocessing capability |
| **Audit trails** | 7 years | 10 years | Regulatory examination |

**Tiered storage strategy:**

```
HOT  (0-2 years):    Cloud DW native storage, full query performance
                     SSD-backed, auto-clustered, indexed
                     
WARM (2-7 years):    Cloud DW with lower-tier storage, or external tables
                     S3 Intelligent Tiering, queryable but slower
                     
COLD (7+ years):     S3 Glacier / Azure Archive, retrievable for audits
                     Parquet files, catalog metadata retained
                     Accessible within hours for regulatory requests
```

### 11.7 Regulatory Data Requirements

Key regulatory data requirements that influence warehouse design:

| Regulation | Data Requirement | Impact on DW |
|---|---|---|
| **NAIC Model Regulation 275** | Retain suitability documentation | Store suitability analysis data |
| **Reg BI (SEC)** | Document basis for best interest recommendations | Store recommendation evidence |
| **BSA/AML** | Transaction monitoring, SAR filing data | Real-time transaction analytics |
| **NAIC Market Conduct** | Complaint, replacement, claims data | Historical trend analysis |
| **LDTI (ASC 944)** | Cohort-level reserve data, MRB fair values | Actuarial data mart |
| **VM-21 / AG 43** | Stochastic scenario data, CTE calculations | Large-scale scenario storage |
| **IFRS 17** | Contract grouping, CSM calculations | International reporting mart |
| **State-specific** | Various state data calls and filing requirements | State-specific reporting views |
| **NAIC System for Electronic Rates & Forms Filing** | Product filing data | Product data mart |
| **IRS Form 1099-R/5498** | Distribution and contribution reporting | Tax reporting data mart |

---

## 12. Architecture Recommendations & Decision Records

### 12.1 Target Architecture (Recommended)

For a mid-to-large annuity carrier building a modern analytics platform, the recommended architecture is:

```
┌──────────────────────────────────────────────────────────────────────────┐
│                 RECOMMENDED ANNUITY ANALYTICS ARCHITECTURE               │
├──────────────────────────────────────────────────────────────────────────┤
│                                                                          │
│  ┌─── SOURCE SYSTEMS ───────────────────────────────────────────────┐   │
│  │ PAS │ Illustration │ Commission │ DTCC │ CRM │ GL │ Web Portal  │   │
│  └──┬──────┬──────────┬───────────┬──────┬─────┬─────┬─────────────┘   │
│     │      │          │           │      │     │     │                   │
│  ┌──▼──────▼──────────▼───────────▼──────▼─────▼─────▼─────────────┐   │
│  │              INGESTION LAYER                                     │   │
│  │  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐       │   │
│  │  │ Debezium │  │  File    │  │  API     │  │ Streaming│       │   │
│  │  │ CDC      │  │  Ingest  │  │  Ingest  │  │  Ingest  │       │   │
│  │  └────┬─────┘  └────┬─────┘  └────┬─────┘  └────┬─────┘       │   │
│  │       └──────────────┴─────────────┴──────────────┘             │   │
│  │                          │                                       │   │
│  │                    Apache Kafka                                   │   │
│  └──────────────────────────┬───────────────────────────────────────┘   │
│                             │                                           │
│  ┌──────────────────────────▼───────────────────────────────────────┐   │
│  │              DATA LAKE (S3 / ADLS)                               │   │
│  │  ┌──────────┐    ┌──────────┐    ┌──────────┐                  │   │
│  │  │  BRONZE  │───→│  SILVER  │───→│   GOLD   │                  │   │
│  │  │  (Raw)   │    │ (Curated)│    │  (Marts) │                  │   │
│  │  │  Delta   │    │  Delta   │    │  Delta   │                  │   │
│  │  └──────────┘    └──────────┘    └──────────┘                  │   │
│  └──────────────────────────┬───────────────────────────────────────┘   │
│                             │                                           │
│  ┌──────────────────────────▼───────────────────────────────────────┐   │
│  │              COMPUTE LAYER                                       │   │
│  │  ┌──────────────────┐    ┌──────────────────┐                   │   │
│  │  │   Databricks     │    │   Snowflake      │                   │   │
│  │  │   (ML, Heavy     │    │   (SQL Analytics, │                  │   │
│  │  │    ETL, Actuarial│    │    BI Serving,    │                  │   │
│  │  │    Workloads)    │    │    Self-Service)  │                  │   │
│  │  └──────────────────┘    └──────────────────┘                   │   │
│  └──────────────────────────┬───────────────────────────────────────┘   │
│                             │                                           │
│  ┌──────────────────────────▼───────────────────────────────────────┐   │
│  │              ORCHESTRATION & GOVERNANCE                           │   │
│  │  ┌────────┐ ┌────────┐ ┌──────────┐ ┌────────────┐ ┌────────┐ │   │
│  │  │Airflow/│ │  dbt   │ │ Great    │ │  Unity     │ │MLflow  │ │   │
│  │  │Dagster │ │        │ │ Expect.  │ │  Catalog   │ │        │ │   │
│  │  └────────┘ └────────┘ └──────────┘ └────────────┘ └────────┘ │   │
│  └──────────────────────────┬───────────────────────────────────────┘   │
│                             │                                           │
│  ┌──────────────────────────▼───────────────────────────────────────┐   │
│  │              CONSUMPTION LAYER                                    │   │
│  │  ┌────────┐ ┌────────┐ ┌──────────┐ ┌─────────┐ ┌───────────┐ │   │
│  │  │Tableau │ │Power BI│ │ Jupyter  │ │ API     │ │ Embedded  │ │   │
│  │  │        │ │        │ │ Notebooks│ │ Layer   │ │ Analytics │ │   │
│  │  └────────┘ └────────┘ └──────────┘ └─────────┘ └───────────┘ │   │
│  └──────────────────────────────────────────────────────────────────┘   │
│                                                                          │
└──────────────────────────────────────────────────────────────────────────┘
```

### 12.2 Architecture Decision Records (ADRs)

#### ADR-001: Cloud Data Warehouse Selection

**Context**: Need a primary cloud data warehouse for annuity analytics serving 200+ business users across actuarial, finance, operations, sales, and compliance.

**Decision**: Use **Snowflake** as the primary SQL analytics engine, complemented by **Databricks** for ML and heavy ETL workloads.

**Rationale**:
- Snowflake excels at concurrent BI queries with auto-scaling warehouses
- Snowflake's VARIANT type handles semi-structured ACORD XML/JSON natively
- Snowflake time travel supports regulatory point-in-time queries
- Databricks provides superior Spark-based processing for actuarial batch jobs and ML pipelines
- Both integrate well with S3/Delta Lake as the storage layer
- Data sharing capability enables secure analytics sharing with distributors

**Consequences**:
- Two compute engines to manage (but different strengths)
- Need data sync strategy between Databricks-processed data and Snowflake serving layer
- Higher overall platform cost vs. single-engine approach, offset by workload optimization

#### ADR-002: Table Format Selection

**Context**: Need a table format for the data lake that supports ACID transactions, time travel, schema evolution, and efficient query performance.

**Decision**: Use **Delta Lake** as the primary table format.

**Rationale**:
- Native support in Databricks with Photon acceleration
- Snowflake can read Delta Lake tables via external tables or Delta Sharing
- ACID transactions ensure data consistency during complex ETL
- Time travel enables regulatory point-in-time reconstruction
- Schema evolution handles source system changes gracefully
- Z-ordering optimizes query patterns (e.g., queries by contract_number, product_code)

**Alternatives considered**:
- Apache Iceberg: Strong open-source community, but Delta Lake has better Databricks integration
- Apache Hudi: Strong for CDC use cases, but smaller ecosystem

#### ADR-003: ETL Framework Selection

**Context**: Need a transformation framework for building and maintaining 100+ data models across bronze, silver, and gold layers.

**Decision**: Use **dbt** for SQL-based transformations with **Spark/Databricks** for complex non-SQL transformations.

**Rationale**:
- dbt provides version-controlled, testable, documented SQL transformations
- dbt's built-in testing framework supports data quality as part of the build
- dbt's documentation generation creates a living data dictionary
- dbt's lineage graph provides automatic dependency tracking
- Spark handles workloads that don't fit in SQL (ML feature engineering, complex actuarial calculations, Python-based transformations)

#### ADR-004: Dimensional Modeling vs. Data Vault

**Context**: Need a modeling approach for the integrated layer of the data warehouse.

**Decision**: Use **Kimball dimensional modeling** (star/snowflake schemas) for the gold/consumption layer. Use a **staging/curated approach** (not full Data Vault) for the silver layer.

**Rationale**:
- Dimensional modeling is well-understood by business users and BI tools
- Annuity data naturally fits dimensional models (contracts, products, agents, dates)
- The majority of analytical queries benefit from the star schema query pattern
- Full Data Vault adds complexity without proportional benefit for this use case
- The bronze/silver/gold layering provides the historization and auditability benefits often cited for Data Vault

#### ADR-005: CDC vs. Batch Extraction

**Context**: Need to determine the primary data extraction approach from the PAS and other source systems.

**Decision**: Use **CDC (Debezium + Kafka)** for the PAS and commission systems; use **batch extraction** for reference data and less frequently changing sources.

**Rationale**:
- CDC provides near-real-time data for operational use cases (call center, fraud detection)
- CDC is more efficient for high-volume transaction data (millions of rows/day)
- CDC captures all intermediate states, not just end-of-day snapshots
- Batch extraction is simpler and sufficient for reference data (product, agent master)
- Hybrid approach optimizes for both freshness and simplicity

#### ADR-006: Slowly Changing Dimension Strategy

**Context**: Need to define the SCD approach for key dimensions in the annuity warehouse.

**Decision**: Use **SCD Type 2** for contract, agent, and party dimensions. Use **SCD Type 1** for reference dimensions (product, geography).

**Rationale**:
- Annuity contracts have multi-decade lifecycles; historical tracking is essential
- Agent affiliations change (IMO moves, channel changes) and must be tracked for historical commission analysis
- Party address changes affect tax jurisdiction and must be historically tracked
- Product and geography dimensions change infrequently and don't need row-level history
- SCD Type 2 provides full point-in-time reconstruction capability required by regulators

### 12.3 Sizing and Performance Guidelines

#### Data Volume Estimates (Mid-Size Carrier)

| Object | Row Count (Est.) | Growth Rate | Storage (Est.) |
|---|---|---|---|
| dim_contract (current) | 500,000 | 5%/year | 500 MB |
| dim_contract (all versions) | 2,000,000 | 10%/year | 2 GB |
| dim_party | 1,500,000 | 5%/year | 1 GB |
| dim_agent | 100,000 | 3%/year | 100 MB |
| dim_product | 500 | Minimal | 1 MB |
| dim_date | 50,000 | 365 rows/year | 5 MB |
| fact_financial_transaction | 500,000,000 | 50M/year | 200 GB |
| fact_contract_daily_snapshot | 180,000,000/year | 500K × 365 | 500 GB/year |
| fact_contract_monthly_snapshot | 6,000,000/year | 500K × 12 | 20 GB/year |
| fact_new_business_pipeline | 200,000 | 10%/year | 200 MB |
| fact_commission | 50,000,000 | 5M/year | 20 GB |

#### Performance Optimization Recommendations

**Clustering/partitioning strategy:**

```sql
-- Snowflake clustering for large fact tables
ALTER TABLE fact_financial_transaction
CLUSTER BY (effective_date_key, product_key, contract_key);

ALTER TABLE fact_contract_monthly_snapshot
CLUSTER BY (snapshot_date_key, product_key);

-- Databricks Z-ordering for Delta Lake tables
OPTIMIZE fact_financial_transaction
ZORDER BY (effective_date_key, contract_key, product_key);

OPTIMIZE fact_contract_monthly_snapshot
ZORDER BY (snapshot_date_key, product_key);
```

**Materialized views for common queries:**

```sql
-- Materialized view: Monthly inforce summary by product
CREATE MATERIALIZED VIEW mv_monthly_inforce_summary AS
SELECT
    d.calendar_year,
    d.month_number,
    d.calendar_date AS snapshot_date,
    p.product_line,
    p.product_name,
    COUNT(DISTINCT s.contract_key)    AS contract_count,
    SUM(s.account_value)              AS total_av,
    SUM(s.guaranteed_benefit_base)    AS total_benefit_base,
    SUM(s.net_amount_at_risk)         AS total_nar,
    SUM(s.annualized_fee_income)      AS total_fee_income,
    AVG(s.contract_duration_months)   AS avg_duration,
    SUM(CASE WHEN s.is_in_surrender_period THEN 1 ELSE 0 END) AS in_sc_count,
    SUM(CASE WHEN s.is_rmd_eligible THEN 1 ELSE 0 END) AS rmd_eligible_count
FROM fact_contract_monthly_snapshot s
JOIN dim_date d ON s.snapshot_date_key = d.date_key
JOIN dim_product p ON s.product_key = p.product_key
WHERE d.is_month_end = TRUE
GROUP BY d.calendar_year, d.month_number, d.calendar_date,
         p.product_line, p.product_name;
```

### 12.4 Implementation Roadmap

A phased implementation approach is recommended:

```
PHASE 1: Foundation (Months 1-4)
────────────────────────────────
- Stand up cloud infrastructure (Snowflake/Databricks, S3, Kafka)
- Implement bronze/silver data lake layers for PAS data
- Build core dimensions: contract, product, agent, date, party
- Build fact_contract_monthly_snapshot (inforce view)
- Build fact_financial_transaction (transaction history)
- Implement daily reconciliation (PAS vs. DW)
- Deploy data quality framework (Great Expectations / dbt tests)
- Deliver: Inforce dashboard, basic sales reporting

PHASE 2: Analytics Foundation (Months 4-7)
────────────────────────────────────────────
- Integrate commission system and DTCC feeds
- Build agent/producer data mart
- Build new business pipeline fact (accumulating snapshot)
- Build sales analytics dashboards
- Build operational dashboards (servicing, call center)
- Implement self-service BI layer (semantic model)
- Deliver: Sales dashboards, agent book-of-business, ops dashboards

PHASE 3: Financial & Actuarial (Months 7-10)
─────────────────────────────────────────────
- Build financial reporting data mart (GL integration)
- Build actuarial seriatim extract pipeline
- Build experience study data infrastructure
- Build compliance data mart (suitability, AML, complaints)
- Implement regulatory reporting views
- Deliver: Financial reporting, actuarial extracts, compliance reports

PHASE 4: Advanced Analytics (Months 10-14)
──────────────────────────────────────────────
- Implement lapse prediction model
- Implement fraud detection pipeline
- Build customer lifetime value model
- Build cross-sell/upsell propensity models
- Implement real-time streaming analytics (CDC → Kafka → Flink)
- Deliver: ML-powered insights, real-time dashboards

PHASE 5: Data Mesh & Maturity (Months 14-18)
──────────────────────────────────────────────
- Decompose into domain-owned data products
- Implement data catalog (Atlan / Unity Catalog)
- Implement comprehensive data lineage
- Build data quality monitoring and alerting
- Implement data mesh governance framework
- Deliver: Self-service data products, governed data marketplace
```

### 12.5 Cost Estimation Framework

| Component | Annual Cost Range (Mid-Size Carrier) | Key Cost Drivers |
|---|---|---|
| Snowflake compute + storage | $200K - $600K | Warehouse sizes, concurrency, storage volume |
| Databricks compute | $150K - $400K | Cluster sizes, ML workloads, interactive notebooks |
| S3 / ADLS storage | $20K - $50K | Data volume, tiering strategy |
| Kafka (managed, e.g., Confluent) | $50K - $150K | Throughput, retention, connectors |
| BI tool licenses (Tableau/Power BI) | $100K - $300K | User count, license tier |
| Data catalog (Atlan/Alation) | $50K - $150K | User count, features |
| Data quality (Monte Carlo/GE) | $50K - $100K | Table count, check frequency |
| Orchestration (managed Airflow) | $20K - $50K | DAG count, compute |
| **Total platform cost** | **$640K - $1.8M** | |
| **Personnel (5-8 person data team)** | **$800K - $1.5M** | Market, seniority, location |
| **Grand total** | **$1.4M - $3.3M** | |

### 12.6 Key Success Factors

1. **Executive sponsorship**: Secure C-level sponsorship from CFO or COO who will champion data-driven decision-making.

2. **Domain expertise**: Ensure the data engineering team includes (or has access to) annuity domain experts who understand the business semantics of contract data, rider mechanics, and regulatory requirements.

3. **Data quality first**: Invest heavily in data quality monitoring and reconciliation from day one. Poor data quality will undermine user trust and make the platform irrelevant.

4. **Incremental delivery**: Deliver value every 2-3 months rather than attempting a big-bang multi-year warehouse project. Start with the inforce snapshot and basic sales reporting, then expand.

5. **Self-service enablement**: The goal is not to build reports—it is to build a platform that enables business users to answer their own questions. Invest in the semantic layer, data catalog, and training.

6. **Regulatory alignment**: Engage compliance and legal teams early. Regulatory reporting requirements should drive retention policies, PII handling, and audit trail design decisions.

7. **Source system partnership**: Establish formal SLAs with PAS, commission, and DTCC teams for data delivery, quality, and change notification. Source system changes are the number one cause of warehouse failures.

8. **Testing automation**: Implement automated data testing at every layer (staging, curated, consumption) using tools like dbt tests and Great Expectations. Manual testing does not scale.

---

## Appendix A: Glossary of Annuity Analytics Terms

| Term | Definition |
|---|---|
| **A/E Ratio** | Actual-to-Expected ratio, comparing observed experience to assumed experience |
| **AUM** | Assets Under Management; total market value of assets managed |
| **CARVM** | Commissioners' Annuity Reserve Valuation Method; statutory reserve standard |
| **CDC** | Change Data Capture; technique for capturing incremental changes from source databases |
| **CLV/CLtV** | Customer Lifetime Value; projected total value of a customer relationship |
| **CSM** | Contractual Service Margin; IFRS 17 concept representing unearned profit |
| **CTE** | Conditional Tail Expectation; risk measure used in VM-21 reserve calculations |
| **DCA** | Dollar-Cost Averaging; systematic investment program |
| **DTCC** | Depository Trust & Clearing Corporation; central securities depository |
| **ELT** | Extract, Load, Transform; modern pattern loading raw data before transforming |
| **ETL** | Extract, Transform, Load; traditional pattern transforming data before loading |
| **FIA** | Fixed Indexed Annuity; annuity with returns linked to an index with minimum guarantees |
| **GMAB** | Guaranteed Minimum Accumulation Benefit; rider guaranteeing minimum AV |
| **GMDB** | Guaranteed Minimum Death Benefit; rider guaranteeing minimum death benefit |
| **GMIB** | Guaranteed Minimum Income Benefit; rider guaranteeing minimum annuitization income |
| **GMWB/GLWB** | Guaranteed Minimum/Lifetime Withdrawal Benefit; rider guaranteeing withdrawal amounts |
| **ITM** | In-The-Money; when guarantee value exceeds account value |
| **LDTI** | Long-Duration Targeted Improvements; GAAP accounting standard update (ASU 2018-12) |
| **M&E** | Mortality and Expense risk charge; base fee on variable annuities |
| **MRB** | Market Risk Benefit; LDTI concept for fair-valuing certain guarantees |
| **MVA** | Market Value Adjustment; adjustment to surrender value based on interest rate changes |
| **MYGA** | Multi-Year Guaranteed Annuity; fixed annuity with guaranteed rate for multiple years |
| **NAIC** | National Association of Insurance Commissioners |
| **NAR** | Net Amount at Risk; excess of guaranteed benefit over account value |
| **NAV** | Net Asset Value; per-unit value of a fund/sub-account |
| **NIGO** | Not In Good Order; application/request with errors or missing information |
| **NSCC** | National Securities Clearing Corporation; subsidiary of DTCC |
| **ORSA** | Own Risk and Solvency Assessment; enterprise risk management framework |
| **PAS** | Policy Administration System; core system of record for annuity contracts |
| **RBC** | Risk-Based Capital; regulatory capital requirement methodology |
| **RMD** | Required Minimum Distribution; mandatory withdrawals from qualified accounts |
| **SCD** | Slowly Changing Dimension; technique for handling dimension changes over time |
| **SPIA** | Single Premium Immediate Annuity; annuity that begins payments immediately |
| **STP** | Straight-Through Processing; automated processing without manual intervention |
| **VA** | Variable Annuity; annuity with account value linked to investment sub-accounts |
| **VM-21** | Valuation Manual section 21; requirements for variable annuity statutory reserves |

## Appendix B: Sample dbt Model Structure

```
annuity_analytics/
├── dbt_project.yml
├── models/
│   ├── staging/                          # 1:1 with source tables
│   │   ├── stg_pas_contract.sql
│   │   ├── stg_pas_transaction.sql
│   │   ├── stg_pas_rider.sql
│   │   ├── stg_pas_fund_allocation.sql
│   │   ├── stg_commission_payment.sql
│   │   ├── stg_dtcc_application.sql
│   │   ├── stg_nav_daily.sql
│   │   └── _staging_sources.yml
│   ├── intermediate/                     # Business logic, joins
│   │   ├── int_contract_enriched.sql
│   │   ├── int_party_deduplicated.sql
│   │   ├── int_transaction_classified.sql
│   │   ├── int_agent_hierarchy.sql
│   │   └── int_fund_performance.sql
│   ├── marts/                            # Business-ready models
│   │   ├── dim_contract.sql
│   │   ├── dim_product.sql
│   │   ├── dim_agent.sql
│   │   ├── dim_party.sql
│   │   ├── dim_date.sql
│   │   ├── dim_geography.sql
│   │   ├── dim_sub_account.sql
│   │   ├── dim_transaction_type.sql
│   │   ├── fact_financial_transaction.sql
│   │   ├── fact_contract_monthly_snapshot.sql
│   │   ├── fact_new_business_pipeline.sql
│   │   ├── fact_commission.sql
│   │   ├── fact_claim.sql
│   │   └── fact_compliance_event.sql
│   ├── analytics/                        # KPIs and aggregations
│   │   ├── kpi_sales_monthly.sql
│   │   ├── kpi_surrender_analysis.sql
│   │   ├── kpi_persistency.sql
│   │   ├── kpi_agent_productivity.sql
│   │   ├── rpt_inforce_summary.sql
│   │   ├── rpt_experience_study_mortality.sql
│   │   └── rpt_compliance_scorecard.sql
│   └── ml_features/                      # Feature store for ML
│       ├── features_lapse_prediction.sql
│       ├── features_fraud_detection.sql
│       └── features_cross_sell.sql
├── tests/
│   ├── generic/
│   │   ├── test_account_value_positive.sql
│   │   ├── test_csv_lte_av.sql
│   │   └── test_reconciliation_pas_dw.sql
│   └── singular/
│       ├── assert_contract_count_reasonable.sql
│       └── assert_no_orphan_transactions.sql
├── macros/
│   ├── surrogate_key.sql
│   ├── scd_type_2.sql
│   ├── date_spine.sql
│   └── quality_checks.sql
├── seeds/
│   ├── seed_transaction_type_mapping.csv
│   ├── seed_state_reference.csv
│   └── seed_mortality_table_vbt2015.csv
└── snapshots/
    ├── snapshot_contract.sql              # dbt snapshot for SCD Type 2
    └── snapshot_agent.sql
```

## Appendix C: Reference Architecture Patterns

### Pattern 1: Point-in-Time Query

A common regulatory requirement is reconstructing the state of data as of a specific historical date.

```sql
-- Reconstruct inforce book as of December 31, 2023
SELECT
    c.contract_number,
    c.contract_status,
    p.product_name,
    s.account_value,
    s.guaranteed_benefit_base,
    a.agent_name,
    a.distribution_channel
FROM fact_contract_monthly_snapshot s
JOIN dim_contract c 
    ON s.contract_key = c.contract_key
    AND '2023-12-31' BETWEEN c.row_effective_date AND c.row_expiration_date
JOIN dim_product p ON s.product_key = p.product_key
JOIN dim_agent a 
    ON s.agent_key = a.agent_key
    AND '2023-12-31' BETWEEN a.row_effective_date AND a.row_expiration_date
JOIN dim_date d ON s.snapshot_date_key = d.date_key
WHERE d.calendar_date = '2023-12-31';
```

### Pattern 2: Cohort Analysis

Track a cohort of contracts issued in the same period through their lifecycle.

```sql
-- Cohort analysis: 2022 Q1 new business retention curve
WITH cohort AS (
    SELECT
        c.contract_key,
        c.contract_number,
        p.product_line,
        c.issue_date
    FROM dim_contract c
    JOIN dim_product p ON c.product_key = p.product_key
    WHERE c.issue_date BETWEEN '2022-01-01' AND '2022-03-31'
      AND c.is_current_row = TRUE
),
monthly_status AS (
    SELECT
        co.product_line,
        DATEDIFF('month', co.issue_date, d.calendar_date) AS months_since_issue,
        COUNT(DISTINCT co.contract_key) AS cohort_size,
        COUNT(DISTINCT CASE WHEN cs.contract_status = 'Active' 
              THEN co.contract_key END) AS still_active
    FROM cohort co
    CROSS JOIN dim_date d
    LEFT JOIN dim_contract cs
        ON co.contract_key = cs.contract_key
        AND d.calendar_date BETWEEN cs.row_effective_date AND cs.row_expiration_date
    WHERE d.is_month_end = TRUE
      AND d.calendar_date BETWEEN '2022-01-31' AND '2025-03-31'
    GROUP BY co.product_line, DATEDIFF('month', co.issue_date, d.calendar_date)
)
SELECT
    product_line,
    months_since_issue,
    cohort_size,
    still_active,
    still_active * 100.0 / cohort_size AS retention_rate
FROM monthly_status
ORDER BY product_line, months_since_issue;
```

### Pattern 3: Waterfall Analysis (AV Movement)

Decompose changes in total account value into contributing factors.

```sql
-- Account value waterfall: Q1 2025
WITH q_start AS (
    SELECT SUM(account_value) AS start_av
    FROM fact_contract_monthly_snapshot s
    JOIN dim_date d ON s.snapshot_date_key = d.date_key
    WHERE d.calendar_date = '2024-12-31'
),
q_flows AS (
    SELECT
        SUM(CASE WHEN tt.transaction_category = 'PREMIUM' 
            THEN ft.transaction_amount ELSE 0 END) AS premiums,
        SUM(CASE WHEN tt.transaction_category = 'WITHDRAWAL'
            THEN ft.transaction_amount ELSE 0 END) AS withdrawals,
        SUM(CASE WHEN tt.transaction_category = 'SURRENDER'
            THEN ft.transaction_amount ELSE 0 END) AS surrenders,
        SUM(CASE WHEN tt.transaction_category = 'DEATH_CLAIM'
            THEN ft.transaction_amount ELSE 0 END) AS death_claims,
        SUM(CASE WHEN tt.transaction_category = 'FEE'
            THEN ft.transaction_amount ELSE 0 END) AS fees
    FROM fact_financial_transaction ft
    JOIN dim_transaction_type tt ON ft.transaction_type_key = tt.transaction_type_key
    JOIN dim_date d ON ft.effective_date_key = d.date_key
    WHERE d.calendar_date BETWEEN '2025-01-01' AND '2025-03-31'
),
q_end AS (
    SELECT SUM(account_value) AS end_av
    FROM fact_contract_monthly_snapshot s
    JOIN dim_date d ON s.snapshot_date_key = d.date_key
    WHERE d.calendar_date = '2025-03-31'
)
SELECT
    qs.start_av AS "Beginning AV (12/31/24)",
    qf.premiums AS "+ Premiums",
    -qf.withdrawals AS "- Withdrawals",
    -qf.surrenders AS "- Surrenders",
    -qf.death_claims AS "- Death Claims",
    -qf.fees AS "- Fees",
    (qe.end_av - qs.start_av - qf.premiums + qf.withdrawals 
     + qf.surrenders + qf.death_claims + qf.fees) AS "Market Movement (implied)",
    qe.end_av AS "Ending AV (3/31/25)"
FROM q_start qs, q_flows qf, q_end qe;
```

---

*This article is part of the Annuities Encyclopedia series. It provides a comprehensive reference for solution architects building data warehouse and analytics capabilities for annuity insurance carriers. The patterns, models, and recommendations are based on industry best practices and should be adapted to each organization's specific scale, technology landscape, and regulatory environment.*
