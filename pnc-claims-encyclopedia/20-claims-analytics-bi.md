# Claims Analytics, Business Intelligence & Reporting

## Table of Contents

1. [Analytics Maturity Model for Claims](#1-analytics-maturity-model-for-claims)
2. [Claims Data Warehouse Architecture](#2-claims-data-warehouse-architecture)
3. [Claims Data Lake Architecture](#3-claims-data-lake-architecture)
4. [Key Claims Metrics & KPIs](#4-key-claims-metrics--kpis)
5. [Operational Dashboards](#5-operational-dashboards)
6. [Executive Reporting](#6-executive-reporting)
7. [Advanced Analytics Use Cases](#7-advanced-analytics-use-cases)
8. [Real-Time Analytics & Streaming](#8-real-time-analytics--streaming)
9. [BI Technology Stack](#9-bi-technology-stack)
10. [Analytics Platform Architecture (Cloud)](#10-analytics-platform-architecture-cloud)
11. [Data Governance for Claims Analytics](#11-data-governance-for-claims-analytics)
12. [Self-Service Analytics](#12-self-service-analytics-for-business-users)
13. [Embedded Analytics](#13-embedded-analytics-in-claims-applications)
14. [Reporting Automation & Distribution](#14-reporting-automation--distribution)
15. [Sample Dashboard Designs](#15-sample-dashboard-designs-with-metrics-layouts)
16. [Claims Analytics Data Model (ERD)](#16-claims-analytics-data-model-complete-erd)

---

## 1. Analytics Maturity Model for Claims

### Four Levels of Analytics Maturity

```
+===================================================================+
|              ANALYTICS MATURITY MODEL FOR CLAIMS                    |
+===================================================================+
|                                                                     |
|  LEVEL 4: PRESCRIPTIVE                                  Value      |
|  +-------------------------------------------------------------+  |
|  | "What SHOULD we do?"                                  ▲      |  |
|  |                                                       |      |  |
|  | - Automated adjuster assignment optimization          |      |  |
|  | - AI-recommended settlement amounts                   |      |  |
|  | - Automated triage and routing decisions               |      |  |
|  | - Dynamic reserve recommendations                     |      |  |
|  | - Proactive fraud intervention                        |      |  |
|  | - Automated STP eligibility decisions                 |      |  |
|  |                                                       |      |  |
|  | Technology: Optimization algorithms, decision engines, |      |  |
|  |             reinforcement learning, causal inference   |      |  |
|  +-------------------------------------------------------------+  |
|                                                       |             |
|  LEVEL 3: PREDICTIVE                                  |             |
|  +-------------------------------------------------------------+  |
|  | "What WILL happen?"                                  |      |  |
|  |                                                       |      |  |
|  | - Claim severity prediction at FNOL                   |      |  |
|  | - Litigation propensity scoring                        |      |  |
|  | - Fraud probability scoring                            |      |  |
|  | - Claim duration/closure prediction                    |      |  |
|  | - Reserve adequacy prediction                          |      |  |
|  | - Customer churn prediction post-claim                 |      |  |
|  | - Subrogation recovery probability                     |      |  |
|  |                                                       |      |  |
|  | Technology: ML models (gradient boosting, neural nets), |      |  |
|  |             feature engineering, model pipelines       |      |  |
|  +-------------------------------------------------------------+  |
|                                                       |             |
|  LEVEL 2: DIAGNOSTIC                                  |             |
|  +-------------------------------------------------------------+  |
|  | "WHY did it happen?"                                  |      |  |
|  |                                                       |      |  |
|  | - Root cause analysis of high-severity claims          |      |  |
|  | - Driver analysis for reserve development              |      |  |
|  | - Attribution analysis for cycle time variance         |      |  |
|  | - Segmentation analysis for claim patterns             |      |  |
|  | - Correlation analysis (weather vs. claims)            |      |  |
|  | - Vendor performance drill-down                        |      |  |
|  |                                                       |      |  |
|  | Technology: Statistical analysis, drill-down dashboards,|      |  |
|  |             cohort analysis, A/B testing               |      |  |
|  +-------------------------------------------------------------+  |
|                                                       |             |
|  LEVEL 1: DESCRIPTIVE                                 |             |
|  +-------------------------------------------------------------+  |
|  | "What HAPPENED?"                                      |      |  |
|  |                                                       |      |  |
|  | - Claim counts, payments, reserves                     |      |  |
|  | - Loss ratio reporting                                 |      |  |
|  | - Cycle time reporting                                 |      |  |
|  | - Open claim inventory                                 |      |  |
|  | - Adjuster workload reporting                          |      |  |
|  | - Standard regulatory reports                          |      |  |
|  |                                                       |      |  |
|  | Technology: SQL queries, static reports, basic         |      |  |
|  |             dashboards, spreadsheets                   |      |  |
|  +-------------------------------------------------------------+  |
|                                                                     |
+===================================================================+
```

### Maturity Assessment Dimensions

| Dimension | Level 1 | Level 2 | Level 3 | Level 4 |
|-----------|---------|---------|---------|---------|
| Data infrastructure | Spreadsheets, operational DB queries | Data warehouse | Data lake + warehouse | Real-time + ML platform |
| Analytics team | Business analysts | + Data analysts | + Data scientists | + ML engineers |
| Tools | Excel, basic BI | Tableau/Power BI | + Python/R, ML | + MLOps, AutoML |
| Data quality | Ad hoc | Monitored | Governed | Automated quality |
| Decision support | Reports | Interactive dashboards | Predictive scores | Automated decisions |
| Time to insight | Days–weeks | Hours–days | Minutes–hours | Real-time |

---

## 2. Claims Data Warehouse Architecture

### Dimensional Model (Star Schema)

```
+===================================================================+
|              CLAIMS DATA WAREHOUSE - STAR SCHEMA                    |
+===================================================================+
|                                                                     |
|                     +-------------------+                           |
|                     |   DateDim          |                           |
|                     | - date_key (PK)   |                           |
|                     | - full_date       |                           |
|                     | - year            |                           |
|                     | - quarter         |                           |
|                     | - month           |                           |
|                     | - week            |                           |
|                     | - day_of_week     |                           |
|                     | - is_holiday      |                           |
|                     | - fiscal_year     |                           |
|                     | - fiscal_quarter  |                           |
|                     +--------+----------+                           |
|                              |                                      |
|  +-------------------+       |       +-------------------+          |
|  | CoverageDim       |       |       | CauseOfLossDim    |          |
|  | - coverage_key(PK)|       |       | - col_key (PK)    |          |
|  | - coverage_type   |       |       | - cause_code      |          |
|  | - coverage_code   |       |       | - cause_desc      |          |
|  | - LOB             |       |       | - peril_group     |          |
|  | - sub_LOB         |       |       | - peril_category  |          |
|  | - product         |       |       | - is_cat_peril    |          |
|  +--------+----------+       |       +--------+----------+          |
|           |                  |                |                      |
|           |    +-------------+--------+       |                     |
|           |    |                      |       |                     |
|           |    |    FACT TABLES       |       |                     |
|           |    |                      |       |                     |
|  +--------+----+----+  +-------------+-------+---+                 |
|  |   ClaimFact       |  |   PaymentFact           |                 |
|  | - claim_key (PK)  |  | - payment_key (PK)      |                 |
|  | - date_key (FK)   |  | - claim_key (FK)        |                 |
|  | - coverage_key(FK)|  | - date_key (FK)         |                 |
|  | - col_key (FK)    |  | - coverage_key (FK)     |                 |
|  | - adjuster_key(FK)|  | - adjuster_key (FK)     |                 |
|  | - geo_key (FK)    |  | - vendor_key (FK)       |                 |
|  | - policy_key (FK) |  | - payment_type          |                 |
|  | - claim_number    |  | - cost_type             |                 |
|  | - loss_date       |  | - payment_amount        |                 |
|  | - reported_date   |  | - recovery_amount       |                 |
|  | - closed_date     |  | - net_payment           |                 |
|  | - status          |  | - check_number          |                 |
|  | - incurred        |  +--------------------------+                 |
|  | - paid            |                                               |
|  | - reserved        |  +----------------------------+               |
|  | - IBNR_reserve    |  |   ReserveFact              |               |
|  | - recovery        |  | - reserve_key (PK)        |               |
|  | - net_incurred    |  | - claim_key (FK)          |               |
|  | - claim_count     |  | - date_key (FK)           |               |
|  | - open_flag       |  | - coverage_key (FK)       |               |
|  | - closed_flag     |  | - reserve_type            |               |
|  | - suit_flag       |  | - reserve_amount          |               |
|  | - cat_flag        |  | - prior_reserve           |               |
|  | - fraud_flag      |  | - reserve_change          |               |
|  | - subro_flag      |  | - posted_by               |               |
|  | - cycle_days      |  +----------------------------+               |
|  +-------------------+                                              |
|           |                  +----------------------------+          |
|           |                  |   ActivityFact             |          |
|  +--------+----------+      | - activity_key (PK)       |          |
|  | AdjusterDim       |      | - claim_key (FK)          |          |
|  | - adjuster_key(PK)|      | - date_key (FK)           |          |
|  | - adjuster_id     |      | - adjuster_key (FK)       |          |
|  | - adjuster_name   |      | - activity_type           |          |
|  | - team            |      | - activity_status         |          |
|  | - supervisor      |      | - duration_minutes        |          |
|  | - office          |      | - is_customer_facing      |          |
|  | - specialty       |      | - channel                 |          |
|  | - hire_date       |      +----------------------------+          |
|  | - certification   |                                              |
|  +-------------------+      +-------------------+                   |
|                              | GeographyDim     |                   |
|  +-------------------+      | - geo_key (PK)   |                   |
|  | PolicyDim         |      | - zip_code       |                   |
|  | - policy_key (PK) |      | - city           |                   |
|  | - policy_number   |      | - county         |                   |
|  | - policy_type     |      | - state          |                   |
|  | - insured_name    |      | - region         |                   |
|  | - effective_date  |      | - country        |                   |
|  | - expiration_date |      | - latitude       |                   |
|  | - premium         |      | - longitude      |                   |
|  | - agency          |      | - msa            |                   |
|  | - channel         |      | - territory      |                   |
|  +-------------------+      +-------------------+                   |
|                                                                     |
+===================================================================+
```

### Fact Table DDL

```sql
CREATE TABLE fact_claim (
    claim_key           BIGINT          PRIMARY KEY,
    claim_number        VARCHAR(20)     NOT NULL,
    loss_date_key       INTEGER         NOT NULL REFERENCES dim_date(date_key),
    reported_date_key   INTEGER         NOT NULL REFERENCES dim_date(date_key),
    closed_date_key     INTEGER         REFERENCES dim_date(date_key),
    coverage_key        INTEGER         NOT NULL REFERENCES dim_coverage(coverage_key),
    cause_of_loss_key   INTEGER         NOT NULL REFERENCES dim_cause_of_loss(col_key),
    adjuster_key        INTEGER         REFERENCES dim_adjuster(adjuster_key),
    geography_key       INTEGER         NOT NULL REFERENCES dim_geography(geo_key),
    policy_key          INTEGER         NOT NULL REFERENCES dim_policy(policy_key),

    claim_status        VARCHAR(20)     NOT NULL,
    is_open             BOOLEAN         NOT NULL,
    is_closed           BOOLEAN         NOT NULL,
    is_reopened         BOOLEAN         DEFAULT FALSE,
    is_litigated        BOOLEAN         DEFAULT FALSE,
    is_cat              BOOLEAN         DEFAULT FALSE,
    is_fraud_referred   BOOLEAN         DEFAULT FALSE,
    is_subro_eligible   BOOLEAN         DEFAULT FALSE,
    is_total_loss       BOOLEAN         DEFAULT FALSE,

    incurred_amount     DECIMAL(15,2)   NOT NULL DEFAULT 0,
    paid_amount         DECIMAL(15,2)   NOT NULL DEFAULT 0,
    outstanding_reserve DECIMAL(15,2)   NOT NULL DEFAULT 0,
    ibnr_reserve        DECIMAL(15,2)   DEFAULT 0,
    salvage_recovery    DECIMAL(15,2)   DEFAULT 0,
    subro_recovery      DECIMAL(15,2)   DEFAULT 0,
    deductible_amount   DECIMAL(15,2)   DEFAULT 0,
    net_incurred        DECIMAL(15,2)   NOT NULL DEFAULT 0,
    alae_paid           DECIMAL(15,2)   DEFAULT 0,
    alae_reserve        DECIMAL(15,2)   DEFAULT 0,

    claim_count         INTEGER         DEFAULT 1,
    claimant_count      INTEGER         DEFAULT 1,
    exposure_count      INTEGER         DEFAULT 1,

    cycle_time_days     INTEGER,
    fnol_to_contact_hours INTEGER,
    fnol_to_inspection_days INTEGER,
    fnol_to_first_payment_days INTEGER,
    inspection_to_estimate_days INTEGER,

    nps_score           INTEGER,
    csat_score          INTEGER,

    cat_event_id        VARCHAR(20),
    fraud_score         DECIMAL(5,2),
    severity_prediction DECIMAL(15,2),
    litigation_probability DECIMAL(5,4),

    etl_load_date       TIMESTAMP       NOT NULL,
    etl_batch_id        VARCHAR(20)     NOT NULL
);

CREATE TABLE fact_payment (
    payment_key         BIGINT          PRIMARY KEY,
    claim_key           BIGINT          NOT NULL REFERENCES fact_claim(claim_key),
    payment_date_key    INTEGER         NOT NULL REFERENCES dim_date(date_key),
    coverage_key        INTEGER         NOT NULL REFERENCES dim_coverage(coverage_key),
    adjuster_key        INTEGER         REFERENCES dim_adjuster(adjuster_key),
    vendor_key          INTEGER         REFERENCES dim_vendor(vendor_key),
    payee_key           INTEGER         REFERENCES dim_payee(payee_key),

    payment_type        VARCHAR(20)     NOT NULL,
    cost_type           VARCHAR(30)     NOT NULL,
    cost_category       VARCHAR(30),
    payment_method      VARCHAR(20),

    gross_amount        DECIMAL(15,2)   NOT NULL,
    deductible_applied  DECIMAL(15,2)   DEFAULT 0,
    recovery_offset     DECIMAL(15,2)   DEFAULT 0,
    net_amount          DECIMAL(15,2)   NOT NULL,

    is_indemnity        BOOLEAN,
    is_expense          BOOLEAN,
    is_recovery         BOOLEAN,
    is_subrogation      BOOLEAN,
    is_salvage          BOOLEAN,

    check_number        VARCHAR(20),
    payment_status      VARCHAR(20),

    etl_load_date       TIMESTAMP       NOT NULL,
    etl_batch_id        VARCHAR(20)     NOT NULL
);

CREATE TABLE fact_reserve (
    reserve_key         BIGINT          PRIMARY KEY,
    claim_key           BIGINT          NOT NULL REFERENCES fact_claim(claim_key),
    transaction_date_key INTEGER        NOT NULL REFERENCES dim_date(date_key),
    coverage_key        INTEGER         NOT NULL REFERENCES dim_coverage(coverage_key),
    adjuster_key        INTEGER         REFERENCES dim_adjuster(adjuster_key),

    reserve_type        VARCHAR(20)     NOT NULL,
    cost_type           VARCHAR(30)     NOT NULL,

    reserve_amount      DECIMAL(15,2)   NOT NULL,
    prior_reserve       DECIMAL(15,2)   NOT NULL DEFAULT 0,
    reserve_change      DECIMAL(15,2)   NOT NULL,

    reason_code         VARCHAR(20),
    posted_by           VARCHAR(50),
    approved_by         VARCHAR(50),

    etl_load_date       TIMESTAMP       NOT NULL,
    etl_batch_id        VARCHAR(20)     NOT NULL
);

CREATE TABLE fact_activity (
    activity_key        BIGINT          PRIMARY KEY,
    claim_key           BIGINT          NOT NULL REFERENCES fact_claim(claim_key),
    activity_date_key   INTEGER         NOT NULL REFERENCES dim_date(date_key),
    adjuster_key        INTEGER         REFERENCES dim_adjuster(adjuster_key),

    activity_type       VARCHAR(30)     NOT NULL,
    activity_status     VARCHAR(20)     NOT NULL,
    priority            VARCHAR(10),

    created_timestamp   TIMESTAMP       NOT NULL,
    due_timestamp       TIMESTAMP,
    completed_timestamp TIMESTAMP,

    duration_minutes    INTEGER,
    is_overdue          BOOLEAN         DEFAULT FALSE,
    is_customer_facing  BOOLEAN         DEFAULT FALSE,
    channel             VARCHAR(20),

    etl_load_date       TIMESTAMP       NOT NULL,
    etl_batch_id        VARCHAR(20)     NOT NULL
);
```

### Dimension Table DDL

```sql
CREATE TABLE dim_date (
    date_key            INTEGER         PRIMARY KEY,
    full_date           DATE            NOT NULL,
    year                SMALLINT        NOT NULL,
    quarter             SMALLINT        NOT NULL,
    month               SMALLINT        NOT NULL,
    month_name          VARCHAR(20)     NOT NULL,
    week_of_year        SMALLINT        NOT NULL,
    day_of_month        SMALLINT        NOT NULL,
    day_of_week         SMALLINT        NOT NULL,
    day_name            VARCHAR(20)     NOT NULL,
    is_weekend          BOOLEAN         NOT NULL,
    is_holiday          BOOLEAN         NOT NULL,
    holiday_name        VARCHAR(50),
    fiscal_year         SMALLINT        NOT NULL,
    fiscal_quarter      SMALLINT        NOT NULL,
    fiscal_month        SMALLINT        NOT NULL
);

CREATE TABLE dim_coverage (
    coverage_key        INTEGER         PRIMARY KEY,
    coverage_type       VARCHAR(30)     NOT NULL,
    coverage_code       VARCHAR(10)     NOT NULL,
    coverage_name       VARCHAR(100)    NOT NULL,
    line_of_business    VARCHAR(30)     NOT NULL,
    sub_lob             VARCHAR(30),
    product_name        VARCHAR(100),
    is_first_party      BOOLEAN,
    is_third_party      BOOLEAN,
    is_property         BOOLEAN,
    is_casualty         BOOLEAN,
    effective_date      DATE            NOT NULL,
    expiration_date     DATE
);

CREATE TABLE dim_cause_of_loss (
    col_key             INTEGER         PRIMARY KEY,
    cause_code          VARCHAR(10)     NOT NULL,
    cause_description   VARCHAR(100)    NOT NULL,
    peril_group         VARCHAR(30)     NOT NULL,
    peril_category      VARCHAR(30),
    is_cat_peril        BOOLEAN         DEFAULT FALSE,
    is_weather_related  BOOLEAN         DEFAULT FALSE,
    is_liability        BOOLEAN         DEFAULT FALSE,
    iso_cause_code      VARCHAR(10),
    effective_date      DATE            NOT NULL,
    expiration_date     DATE
);

CREATE TABLE dim_adjuster (
    adjuster_key        INTEGER         PRIMARY KEY,
    adjuster_id         VARCHAR(20)     NOT NULL,
    adjuster_name       VARCHAR(100)    NOT NULL,
    adjuster_type       VARCHAR(20),
    team_name           VARCHAR(50),
    supervisor_name     VARCHAR(100),
    office_location     VARCHAR(100),
    state               VARCHAR(2),
    specialty           VARCHAR(30),
    hire_date           DATE,
    certification       TEXT[],
    authority_level     VARCHAR(20),
    is_active           BOOLEAN         DEFAULT TRUE,
    effective_date      DATE            NOT NULL,
    expiration_date     DATE
);

CREATE TABLE dim_geography (
    geo_key             INTEGER         PRIMARY KEY,
    zip_code            VARCHAR(10)     NOT NULL,
    city                VARCHAR(100),
    county              VARCHAR(100),
    state_code          VARCHAR(2)      NOT NULL,
    state_name          VARCHAR(50)     NOT NULL,
    region              VARCHAR(30),
    country             VARCHAR(2)      DEFAULT 'US',
    latitude            DECIMAL(9,6),
    longitude           DECIMAL(9,6),
    msa_code            VARCHAR(10),
    msa_name            VARCHAR(100),
    territory_code      VARCHAR(10),
    time_zone           VARCHAR(30)
);

CREATE TABLE dim_policy (
    policy_key          INTEGER         PRIMARY KEY,
    policy_number       VARCHAR(20)     NOT NULL,
    policy_type         VARCHAR(30)     NOT NULL,
    product_name        VARCHAR(100),
    insured_name        VARCHAR(200),
    effective_date      DATE,
    expiration_date     DATE,
    annual_premium      DECIMAL(12,2),
    deductible          DECIMAL(10,2),
    total_insured_value DECIMAL(15,2),
    agency_name         VARCHAR(200),
    agency_code         VARCHAR(20),
    distribution_channel VARCHAR(30),
    policy_tenure_years INTEGER,
    is_renewal          BOOLEAN,
    state               VARCHAR(2)
);
```

### Slowly Changing Dimensions (SCD)

| Dimension | SCD Type | Rationale |
|-----------|----------|-----------|
| Date | Type 0 (fixed) | Dates never change |
| Coverage | Type 2 (historical) | Coverage types/products change over time, need history |
| Cause of Loss | Type 1 (overwrite) | Corrections only, no need for history |
| Adjuster | Type 2 (historical) | Track team/supervisor changes over time |
| Geography | Type 1 (overwrite) | Zip/city corrections, no material history need |
| Policy | Type 2 (historical) | Policy changes at renewal need historical tracking |

### ETL/ELT Pipeline

```
+===================================================================+
|              ETL/ELT PIPELINE FOR CLAIMS DATA WAREHOUSE             |
+===================================================================+
|                                                                     |
|  SOURCE SYSTEMS                                                    |
|  +-------------------------------------------------------------+  |
|  | Claims System | Policy Admin | Billing | Vendor Systems      |  |
|  | (Guidewire)   | (PAS)        | System  | (CCC, Xactimate)   |  |
|  +------+--------+------+-------+----+----+------+--------------+  |
|         |               |            |           |                  |
|         v               v            v           v                  |
|  EXTRACT LAYER                                                     |
|  +-------------------------------------------------------------+  |
|  | CDC (Change Data Capture) / Incremental Extract              |  |
|  | - Debezium (Kafka Connect) for real-time CDC                |  |
|  | - Scheduled incremental for batch sources                   |  |
|  | - Full extract for small reference tables                   |  |
|  +-------------------------------------------------------------+  |
|         |                                                          |
|         v                                                          |
|  RAW/STAGING LAYER (Data Lake)                                     |
|  +-------------------------------------------------------------+  |
|  | S3 / Azure Data Lake / GCS                                  |  |
|  | - Raw data in source format (Parquet/Delta)                 |  |
|  | - Partitioned by date                                       |  |
|  | - Full audit trail of all extractions                       |  |
|  +-------------------------------------------------------------+  |
|         |                                                          |
|         v                                                          |
|  TRANSFORM LAYER                                                   |
|  +-------------------------------------------------------------+  |
|  | dbt (data build tool) / Spark / Stored Procedures           |  |
|  |                                                              |  |
|  | Transformations:                                             |  |
|  | 1. Data cleansing (nulls, formatting, dedup)                |  |
|  | 2. Business rules (status derivation, categorization)       |  |
|  | 3. Calculation (cycle time, incurred, net)                   |  |
|  | 4. Dimension lookup and key assignment                      |  |
|  | 5. SCD processing (Type 2 dimensions)                       |  |
|  | 6. Fact table population                                    |  |
|  | 7. Aggregation tables (daily, monthly, quarterly)           |  |
|  | 8. Data quality checks and validation                       |  |
|  +-------------------------------------------------------------+  |
|         |                                                          |
|         v                                                          |
|  DATA WAREHOUSE                                                    |
|  +-------------------------------------------------------------+  |
|  | Redshift / Snowflake / BigQuery / Synapse                   |  |
|  | - Star schema (facts + dimensions)                          |  |
|  | - Materialized views for common aggregations                |  |
|  | - Query optimization (sort keys, distribution keys)         |  |
|  +-------------------------------------------------------------+  |
|         |                                                          |
|         v                                                          |
|  SEMANTIC LAYER                                                    |
|  +-------------------------------------------------------------+  |
|  | Looker (LookML) / dbt Metrics / AtScale                    |  |
|  | - Business-friendly metric definitions                      |  |
|  | - Consistent calculations across all reports                |  |
|  | - Access control and data masking                           |  |
|  +-------------------------------------------------------------+  |
|         |                                                          |
|         v                                                          |
|  CONSUMPTION LAYER                                                 |
|  +-------------------------------------------------------------+  |
|  | Tableau / Power BI / Looker / Custom Dashboards             |  |
|  | Excel / Jupyter / Python / R                                |  |
|  +-------------------------------------------------------------+  |
|                                                                     |
+===================================================================+
```

---

## 3. Claims Data Lake Architecture

### Zone Architecture

```
+===================================================================+
|              CLAIMS DATA LAKE ARCHITECTURE                          |
+===================================================================+
|                                                                     |
|  RAW ZONE (Bronze)                                                 |
|  +-------------------------------------------------------------+  |
|  | Purpose: Exact copy of source data, immutable                |  |
|  | Format: Parquet / Avro / JSON / CSV (as extracted)           |  |
|  | Retention: Indefinite (or per governance)                    |  |
|  | Governance: Cataloged, encrypted, access-controlled          |  |
|  |                                                              |  |
|  | Data Sources:                                                |  |
|  | ├── claims_system/                                           |  |
|  | │   ├── claims/ (incremental, daily)                         |  |
|  | │   ├── payments/ (incremental, daily)                       |  |
|  | │   ├── reserves/ (incremental, daily)                       |  |
|  | │   ├── activities/ (incremental, daily)                     |  |
|  | │   └── documents/ (metadata only)                           |  |
|  | ├── policy_system/                                           |  |
|  | │   ├── policies/ (daily snapshot)                           |  |
|  | │   └── endorsements/ (incremental)                          |  |
|  | ├── vendor_data/                                             |  |
|  | │   ├── ccc_estimates/                                       |  |
|  | │   ├── xactimate_estimates/                                 |  |
|  | │   └── iso_claimsearch/                                     |  |
|  | ├── weather_data/                                            |  |
|  | │   ├── noaa/                                                |  |
|  | │   └── dtn/                                                 |  |
|  | └── unstructured/                                            |  |
|  |     ├── claim_notes/ (text)                                  |  |
|  |     ├── call_transcripts/ (text)                             |  |
|  |     └── emails/ (text)                                       |  |
|  +-------------------------------------------------------------+  |
|                           |                                         |
|                           v                                         |
|  CURATED ZONE (Silver)                                             |
|  +-------------------------------------------------------------+  |
|  | Purpose: Cleaned, standardized, enriched data               |  |
|  | Format: Parquet / Delta Lake / Iceberg                      |  |
|  | Quality: Schema enforced, quality checks applied            |  |
|  |                                                              |  |
|  | Transformations:                                             |  |
|  | - Deduplication                                              |  |
|  | - Null handling                                              |  |
|  | - Type casting and formatting                                |  |
|  | - Referential integrity checks                               |  |
|  | - Business rule application                                  |  |
|  | - Cross-source joining                                       |  |
|  +-------------------------------------------------------------+  |
|                           |                                         |
|                           v                                         |
|  ANALYTICS ZONE (Gold)                                             |
|  +-------------------------------------------------------------+  |
|  | Purpose: Business-ready analytics datasets                  |  |
|  | Format: Star schema tables, feature stores, ML datasets     |  |
|  |                                                              |  |
|  | Datasets:                                                    |  |
|  | - Dimensional model (star schema for DW)                     |  |
|  | - Aggregated metrics (daily, monthly, quarterly)             |  |
|  | - ML feature store (features for models)                     |  |
|  | - Reporting datasets (pre-computed for dashboards)           |  |
|  | - Ad hoc analysis datasets                                   |  |
|  +-------------------------------------------------------------+  |
|                                                                     |
+===================================================================+
```

---

## 4. Key Claims Metrics & KPIs

### Exhaustive KPI Catalog

#### Volume Metrics

| Metric | Definition | Calculation | Typical Target |
|--------|-----------|-------------|---------------|
| Claim frequency | Claims per policy | Total claims / earned policies | Varies by LOB |
| New claims (FNOL) | New claims reported in period | Count(FNOL) where reported_date in period | Trend monitoring |
| Open claim inventory | Total open claims at point in time | Count(claims) where status = 'OPEN' | Trend monitoring |
| Closure rate | % of claims closed in period | Closed in period / (Open at start + new in period) | > 100% of new |
| Reopening rate | % of closed claims reopened | Reopened / closed in prior 12 months | < 5% |
| Claims per adjuster | Workload per adjuster | Open claims / active adjusters | 80–150 (varies) |

#### Financial Metrics

| Metric | Definition | Calculation | Typical Target |
|--------|-----------|-------------|---------------|
| Claim severity | Avg paid per claim | Total paid / closed claim count | Varies by LOB |
| Pure loss ratio | Losses / earned premium | (Incurred losses) / (Earned premium) | 55%–70% |
| Loss ratio | Losses + LAE / earned premium | (Incurred + ALAE + ULAE) / Earned premium | 65%–80% |
| Paid-to-incurred ratio | Payments vs. total incurred | Paid / (Paid + Outstanding) | 0.5–0.8 (increases toward 1.0) |
| Reserve adequacy | Actual vs. initial reserve | (Final paid / Initial reserve) - 1 | +/- 10% |
| ALAE ratio | Allocated loss expense ratio | ALAE / (Indemnity paid + ALAE) | 8%–15% |
| ULAE ratio | Unallocated loss expense ratio | ULAE / (Incurred losses) | 5%–10% |
| Average reserve per claim | Average outstanding reserve | Total reserves / open claims | Varies by LOB |
| Incurred development | How incurred changes over time | Incurred at month N / Incurred at month 12 | Development pattern |

#### Cycle Time Metrics

| Metric | Definition | Calculation | Typical Target |
|--------|-----------|-------------|---------------|
| FNOL to close | Total claim lifecycle | close_date - reported_date | Varies by type |
| FNOL to first contact | Speed of adjuster contact | first_contact_date - reported_date | < 24 hours |
| FNOL to inspection | Speed to inspection | inspection_date - reported_date | < 5 days |
| FNOL to first payment | Speed to first payment | first_payment_date - reported_date | < 15 days |
| Inspection to estimate | Estimate turnaround | estimate_date - inspection_date | < 3 days |
| Estimate to settlement | Settlement speed | settlement_date - estimate_date | < 7 days |
| Settlement to payment | Payment speed | payment_date - settlement_date | < 3 days |

#### Recovery Metrics

| Metric | Definition | Calculation | Typical Target |
|--------|-----------|-------------|---------------|
| Subrogation identification rate | % of claims flagged for subro | Subro flagged / total claims | 15%–25% (auto) |
| Subrogation pursuit rate | % of identified subro pursued | Pursued / flagged | > 80% |
| Subrogation recovery rate | % of pursued subro recovered | Recovered $ / pursued $ | 40%–60% |
| Salvage recovery rate | Salvage $ / vehicle value | Salvage proceeds / pre-loss value | 15%–25% |
| Net recovery per claim | Avg recovery per claim | Total recoveries / claims with recovery | Varies |

#### Customer Metrics

| Metric | Definition | Calculation | Typical Target |
|--------|-----------|-------------|---------------|
| NPS (Net Promoter Score) | Likelihood to recommend | %Promoters - %Detractors | > 40 |
| CSAT | Customer satisfaction | Avg survey score (1-5) | > 4.0 |
| CES (Customer Effort Score) | Ease of claims experience | Avg effort score (1-7, lower=easier) | < 3.0 |
| First-contact resolution | Resolved on first interaction | FCR / total interactions | > 70% |
| DOI complaint rate | Regulatory complaints | Complaints / 1000 claims | < 2 |
| Digital adoption rate | % using digital channels | Digital FNOL / total FNOL | > 50% |

#### Adjuster Productivity

| Metric | Definition | Calculation | Typical Target |
|--------|-----------|-------------|---------------|
| Claims handled per adjuster | Volume per adjuster | Total claims worked / FTE adjusters | 80–150 |
| Closures per month | Monthly closure rate | Closures per adjuster per month | 15–30 |
| Inspections per day | Daily inspection volume | Inspections per adjuster per day | 3–6 (field), 8–12 (virtual) |
| Touch time ratio | Active work vs. elapsed time | Active hours / calendar hours | > 65% |
| Quality audit score | QA review results | Avg quality score per adjuster | > 4.0/5.0 |

#### Vendor Performance

| Metric | Definition | Calculation | Typical Target |
|--------|-----------|-------------|---------------|
| IA cycle time | Assignment to report delivery | Report date - assignment date | < 5 days |
| DRP cycle time | Keys-to-keys repair time | Return date - drop-off date | < 7 days |
| DRP customer satisfaction | Post-repair CSI | Avg CSI survey score | > 4.5/5 |
| Rental utilization | Avg rental days | Total rental days / claims with rental | < 14 days |
| Supplement rate | % requiring supplements | Supplemented / total estimates | < 15% |

#### Automation & STP

| Metric | Definition | Calculation | Typical Target |
|--------|-----------|-------------|---------------|
| STP rate | Straight-through processing | STP claims / total eligible claims | > 20% |
| Auto-adjudication rate | Claims settled without human review | Auto-adjudicated / total claims | > 10% |
| Digital FNOL rate | Claims filed digitally | Digital FNOL / total FNOL | > 50% |
| Touchless close rate | Claims closed without adjuster intervention | Touchless / total closures | > 5% |
| AI triage accuracy | AI triage vs. actual outcome | Correctly triaged / total triaged | > 85% |

---

## 5. Operational Dashboards

### Claims Manager Dashboard

```
+===================================================================+
|  CLAIMS MANAGER DASHBOARD                           [Auto Refresh] |
+===================================================================+
|                                                                     |
|  MY TEAM: Southeast Property Team | Period: October 2024           |
|                                                                     |
|  KEY METRICS                                                       |
|  +----------+ +----------+ +----------+ +----------+ +----------+ |
|  | Open     | | New MTD  | | Closed   | | Avg Cycle| | NPS      | |
|  | Claims   | |          | | MTD      | | Time     | |          | |
|  |   847    | |   234    | |   198    | | 18.5 days| |   32     | |
|  | ▼ -3%    | | ▲ +12%   | | ▼ -5%    | | ▲ +1.2d  | | ▼ -3    | |
|  +----------+ +----------+ +----------+ +----------+ +----------+ |
|                                                                     |
|  ADJUSTER WORKLOAD                                                 |
|  +-------------------------------------------------------------+  |
|  | Adjuster        | Open | Overdue | Avg Cycle | Quality | NPS |  |
|  |-----------------|------|---------|-----------|---------|-----|  |
|  | S. Johnson      |   42 |    3    |   15.2 d  |   4.5   |  45 |  |
|  | M. Garcia       |   38 |    1    |   16.8 d  |   4.3   |  38 |  |
|  | R. Patel        |   45 |    7    |   22.1 d  |   3.8   |  22 |  |
|  | T. Williams     |   51 |   12    |   24.5 d  |   3.5   |  15 |  |
|  | K. Chen         |   35 |    0    |   14.3 d  |   4.7   |  52 |  |
|  +-------------------------------------------------------------+  |
|                                                                     |
|  SLA COMPLIANCE                                                    |
|  +-------------------------------------------------------------+  |
|  | SLA                          | Target | Actual | Status      |  |
|  |------------------------------|--------|--------|-------------|  |
|  | Contact within 24 hrs        |   95%  |  92%   | ⚠ Warning  |  |
|  | Inspection within 5 days     |   90%  |  88%   | ⚠ Warning  |  |
|  | Payment within 30 days       |   85%  |  91%   | ✅ On Track  |  |
|  | Correspondence within 14 days|   95%  |  97%   | ✅ On Track  |  |
|  | DOI complaints < 2/1000      |  <2.0  |  1.4   | ✅ On Track  |  |
|  +-------------------------------------------------------------+  |
|                                                                     |
|  AGING INVENTORY                                                   |
|  +-------------------------------------------------------------+  |
|  | Age Bucket     | Count | % of Total | Incurred    | Trend   |  |
|  |----------------|-------|------------|-------------|---------|  |
|  | 0-30 days      |  312  |    37%     | $4.2M       | ▲       |  |
|  | 31-60 days     |  245  |    29%     | $6.8M       | ━       |  |
|  | 61-90 days     |  142  |    17%     | $5.1M       | ▼       |  |
|  | 91-180 days    |   98  |    12%     | $8.9M       | ▲       |  |
|  | 181-365 days   |   35  |     4%     | $4.3M       | ━       |  |
|  | 365+ days      |   15  |     2%     | $6.7M       | ▲       |  |
|  +-------------------------------------------------------------+  |
|                                                                     |
+===================================================================+
```

### Financial/Reserves Dashboard

```
+===================================================================+
|  FINANCIAL / RESERVES DASHBOARD                    Period: Q4 2024 |
+===================================================================+
|                                                                     |
|  LOSS RATIO TRENDING                                               |
|  +-------------------------------------------------------------+  |
|  |  80% |                                                       |  |
|  |  75% |    X                                                  |  |
|  |  70% |  X   X        X                                      |  |
|  |  65% |        X   X     X   X                                |  |
|  |  60% |                       X   X   X                       |  |
|  |  55% |                                  X                    |  |
|  |  50% |                                                       |  |
|  |      +--+--+--+--+--+--+--+--+--+--+--+-->                 |  |
|  |       Q1 Q2 Q3 Q4 Q1 Q2 Q3 Q4 Q1 Q2 Q3 Q4                |  |
|  |       2022         2023         2024                        |  |
|  +-------------------------------------------------------------+  |
|                                                                     |
|  FINANCIAL SUMMARY                                                 |
|  +-------------------------------------------------------------+  |
|  | Metric              | Current Period | Prior Period | Change |  |
|  |---------------------|---------------|-------------|---------|  |
|  | Earned Premium      | $245.6M       | $228.3M     | +7.6%  |  |
|  | Incurred Losses     | $152.3M       | $148.7M     | +2.4%  |  |
|  | ALAE                | $18.9M        | $17.2M      | +9.9%  |  |
|  | ULAE                | $12.1M        | $11.8M      | +2.5%  |  |
|  | Loss Ratio          | 62.0%         | 65.1%       | -3.1pp |  |
|  | Combined Ratio      | 74.8%         | 77.8%       | -3.0pp |  |
|  | Salvage Recovery    | $8.2M         | $7.5M       | +9.3%  |  |
|  | Subro Recovery      | $12.4M        | $11.1M      | +11.7% |  |
|  | Net Incurred        | $131.7M       | $130.1M     | +1.2%  |  |
|  +-------------------------------------------------------------+  |
|                                                                     |
|  RESERVE DEVELOPMENT (CALENDAR YEAR)                               |
|  +-------------------------------------------------------------+  |
|  | Accident Year | Initial | Current | Dev.    | Dev. %        |  |
|  |---------------|---------|---------|---------|---------------|  |
|  | 2020          | $180M   | $172M   | ($8M)   | -4.4% (fav)  |  |
|  | 2021          | $195M   | $198M   | $3M     | +1.5% (adv)  |  |
|  | 2022          | $210M   | $215M   | $5M     | +2.4% (adv)  |  |
|  | 2023          | $225M   | $228M   | $3M     | +1.3% (adv)  |  |
|  | 2024          | $240M   | $240M   | $0M     | 0.0%         |  |
|  +-------------------------------------------------------------+  |
|                                                                     |
|  LARGE LOSS REPORT (Incurred > $500K)                              |
|  +-------------------------------------------------------------+  |
|  | Claim #        | Type     | Incurred | Reserve | Status     |  |
|  |----------------|----------|----------|---------|------------|  |
|  | CLM-2024-001   | Comm Prop| $3.2M    | $2.8M   | Open       |  |
|  | CLM-2024-015   | Auto BI  | $2.1M    | $1.5M   | Litigated  |  |
|  | CLM-2024-089   | HO Prop  | $1.8M    | $0.9M   | Open       |  |
|  | CLM-2024-102   | WC       | $1.2M    | $0.8M   | Open       |  |
|  | CLM-2024-156   | Comm Liab| $0.9M    | $0.6M   | Litigated  |  |
|  +-------------------------------------------------------------+  |
|                                                                     |
+===================================================================+
```

---

## 6. Executive Reporting

### Loss Ratio Analysis

```
Loss Ratio Decomposition:

  Gross Loss Ratio = (Incurred Losses + ALAE) / Earned Premium

  Components:
    Frequency component = (Claim Count / Earned Policies) × Trend
    Severity component  = (Avg Paid per Claim) × Trend
    Reserve component   = (Outstanding Reserves / Earned Premium)
    IBNR component      = (IBNR Estimate / Earned Premium)

  Example:
    Earned Premium:        $245.6M
    Paid Losses:           $98.7M
    Outstanding Reserves:  $53.6M
    IBNR:                  $18.9M
    ALAE:                  $18.9M
    ────────────────────────────────
    Total Incurred:        $171.2M
    ALAE:                  $18.9M
    Total Incurred + ALAE: $190.1M
    
    Loss Ratio:            77.4%
      - Paid:              40.2%
      - Outstanding:       21.8%
      - IBNR:              7.7%
      - ALAE:              7.7%
```

### Combined Ratio

```
Combined Ratio = Loss Ratio + Expense Ratio

Where:
  Loss Ratio = (Incurred Losses + ALAE) / Earned Premium
  Expense Ratio = (ULAE + Underwriting Expenses + Commission) / Written Premium

Example:
  Loss Ratio:                 77.4%
  ULAE Ratio:                  4.9%
  Other Underwriting Expenses:  8.2%
  Commission Ratio:            12.5%
  ─────────────────────────────────
  Combined Ratio:             103.0%  (underwriting loss)

Industry Targets:
  Combined Ratio < 100%: Underwriting profit
  Combined Ratio = 95%: Top quartile performance
  Combined Ratio = 100%: Breakeven on underwriting
  Combined Ratio > 100%: Underwriting loss (may be offset by investment income)
```

---

## 7. Advanced Analytics Use Cases

### 7.1 Severity Prediction at FNOL

```
+-------------------------------------------------------------------+
|              SEVERITY PREDICTION MODEL                              |
+-------------------------------------------------------------------+
|                                                                     |
|  Model: Gradient Boosted Trees (XGBoost / LightGBM)               |
|  Target: Ultimate claim severity (total paid at close)             |
|  Training: 500K+ closed claims with features at FNOL stage        |
|                                                                     |
|  Feature Importance (Top 20):                                      |
|  +---------+----------------------------------------------+------+ |
|  | Rank    | Feature                                      | SHAP | |
|  +---------+----------------------------------------------+------+ |
|  |    1    | Coverage type                                | 0.18 | |
|  |    2    | Cause of loss code                           | 0.14 | |
|  |    3    | Injury indicator at FNOL                     | 0.12 | |
|  |    4    | Vehicle age                                  | 0.08 | |
|  |    5    | Policy limit                                 | 0.07 | |
|  |    6    | Number of claimants                          | 0.06 | |
|  |    7    | Geographic territory                         | 0.05 | |
|  |    8    | Weather severity at loss location            | 0.04 | |
|  |    9    | Time of day of loss                          | 0.03 | |
|  |   10    | Insured tenure (years)                       | 0.03 | |
|  |   11    | Prior claim count (3 years)                  | 0.03 | |
|  |   12    | Police report indicator                      | 0.02 | |
|  |   13    | Tow indicator                                | 0.02 | |
|  |   14    | Description text embedding (NLP)             | 0.02 | |
|  |   15    | Day of week                                  | 0.02 | |
|  |   16    | Deductible amount                            | 0.01 | |
|  |   17    | Vehicle value                                | 0.01 | |
|  |   18    | Distance from home                           | 0.01 | |
|  |   19    | Speed at impact (telematics)                 | 0.01 | |
|  |   20    | Airbag deployment                            | 0.01 | |
|  +---------+----------------------------------------------+------+ |
|                                                                     |
|  Model Performance:                                                |
|  - RMSE: $4,250 (test set)                                        |
|  - MAE: $2,100 (test set)                                         |
|  - R²: 0.72                                                       |
|  - Within 20% of actual: 68% of claims                            |
|  - Within 50% of actual: 91% of claims                            |
|                                                                     |
|  Deployment:                                                       |
|  - Real-time scoring at FNOL via API                               |
|  - Model retrained monthly on rolling 24-month window              |
|  - A/B testing framework for model versions                        |
|  - Champion/challenger model deployment                            |
|                                                                     |
+-------------------------------------------------------------------+
```

### 7.2 Litigation Propensity Model

| Feature Category | Features | Weight |
|-----------------|----------|--------|
| Claim characteristics | Injury severity, coverage type, multi-vehicle, disputed liability | 35% |
| Claimant characteristics | Attorney representation, prior litigation history, location | 25% |
| Financial | Severity to limit ratio, time to first payment, reserve adequacy | 20% |
| Operational | Adjuster experience, response time, communication frequency | 10% |
| External | Jurisdiction venue, local attorney advertising, judicial climate | 10% |

### 7.3 Settlement Optimization

```
Objective: Recommend optimal settlement amount that minimizes total
           claim cost (settlement + defense cost + risk of adverse
           outcome if litigated).

Decision Framework:
  
  Expected Litigation Cost =
    P(litigation) × [E(defense costs) + P(adverse verdict) × E(verdict amount)]

  Optimal Settlement Range:
    Lower bound = E(claim value) - Negotiation cushion
    Upper bound = Expected Litigation Cost

  IF settlement_offer < Expected Litigation Cost
    THEN settlement is economically favorable
  
  Model outputs:
    - Recommended settlement range ($X - $Y)
    - Confidence interval
    - Risk factors that could shift outcome
    - Comparable settlements (peer analysis)
```

### 7.4 Fraud Detection Analytics

```
Fraud Detection Pipeline:

  1. RULE-BASED FLAGS (deterministic)
     - Prior claim frequency > 3 in 2 years
     - Claim filed < 30 days after policy inception
     - Loss occurred in high-fraud zip code
     - Medical treatment inconsistent with injury description
     - Claimant has known fraud ring association

  2. ML SCORING (probabilistic)
     - Model: Ensemble (XGBoost + Neural Network + Isolation Forest)
     - Features: 200+ from claim, policy, claimant, external data
     - Output: Fraud probability score (0-100)
     - Threshold: > 80 = Refer to SIU, 50-80 = Flag for review

  3. NETWORK ANALYSIS (relationship-based)
     - Graph database (Neo4j) linking:
       - Claimants, attorneys, medical providers, shops
     - Identify fraud rings: clusters of connected entities
       appearing in multiple suspicious claims
     - Anomaly detection on graph structure

  4. TEXT ANALYTICS (unstructured data)
     - Analyze claim notes for deceptive language patterns
     - Analyze medical narratives for inconsistencies
     - Compare claimant statements across claims
     - Sentiment analysis of recorded statements
```

---

## 8. Real-Time Analytics & Streaming

### Event-Driven Analytics Architecture

```
+===================================================================+
|              REAL-TIME ANALYTICS ARCHITECTURE                       |
+===================================================================+
|                                                                     |
|  EVENT SOURCES                                                     |
|  +-------------------------------------------------------------+  |
|  | Claims System → CDC (Debezium) → Kafka Topics               |  |
|  |   - claim.created                                           |  |
|  |   - claim.updated                                           |  |
|  |   - payment.created                                         |  |
|  |   - reserve.changed                                         |  |
|  |   - activity.completed                                      |  |
|  |   - document.received                                       |  |
|  |   - correspondence.sent                                     |  |
|  +-------------------------------------------------------------+  |
|                           |                                         |
|                           v                                         |
|  STREAM PROCESSING                                                 |
|  +-------------------------------------------------------------+  |
|  | Apache Flink / Kafka Streams / Spark Streaming              |  |
|  |                                                              |  |
|  | Processing Jobs:                                            |  |
|  | 1. Real-time claim count aggregation (1-min windows)        |  |
|  | 2. Running financial totals (5-min windows)                 |  |
|  | 3. SLA violation detection (event-time processing)          |  |
|  | 4. Anomaly detection (statistical, sliding window)          |  |
|  | 5. Real-time fraud scoring (enrichment + scoring)           |  |
|  | 6. CAT claim volume monitoring                              |  |
|  +-------------------------------------------------------------+  |
|                           |                                         |
|              +------------+-----------+                             |
|              |                        |                             |
|              v                        v                             |
|  REAL-TIME STORE              ALERTING ENGINE                      |
|  +------------------+    +------------------------+                |
|  | Redis / Druid /  |    | Alert Conditions:      |                |
|  | ClickHouse       |    | - FNOL volume > 2x     |                |
|  |                  |    |   normal (possible CAT) |                |
|  | - Latest metrics |    | - SLA breach imminent   |                |
|  | - Rolling aggr.  |    | - Large loss (> $500K)  |                |
|  | - Time series    |    | - Fraud score > 90      |                |
|  +--------+---------+    | - Reserve change > $100K|                |
|           |              +------------------------+                |
|           v                                                        |
|  REAL-TIME DASHBOARDS                                              |
|  +-------------------------------------------------------------+  |
|  | WebSocket push to browser dashboards                        |  |
|  | - Command center displays                                   |  |
|  | - Manager dashboards                                        |  |
|  | - Executive KPI monitors                                    |  |
|  +-------------------------------------------------------------+  |
|                                                                     |
+===================================================================+
```

### Real-Time Alert Configuration

```json
{
  "alertRules": [
    {
      "ruleId": "ALERT-001",
      "name": "CAT Volume Surge",
      "condition": "fnol_count_1hr > (avg_fnol_1hr_trailing_7d * 3)",
      "severity": "CRITICAL",
      "channels": ["PagerDuty", "Slack #claims-ops", "Email CAT-team"],
      "cooldown": 3600,
      "description": "FNOL volume exceeds 3x normal - possible CAT event"
    },
    {
      "ruleId": "ALERT-002",
      "name": "Large Loss",
      "condition": "reserve_amount > 500000",
      "severity": "HIGH",
      "channels": ["Email claims-leadership", "Slack #large-loss"],
      "cooldown": 0,
      "description": "Large loss detected - immediate management notification"
    },
    {
      "ruleId": "ALERT-003",
      "name": "SLA Breach Warning",
      "condition": "claims_approaching_sla_breach > 50 AND time_to_breach < 24h",
      "severity": "WARNING",
      "channels": ["Slack #claims-ops", "Email team-leads"],
      "cooldown": 7200,
      "description": "Multiple claims approaching SLA breach deadline"
    },
    {
      "ruleId": "ALERT-004",
      "name": "Payment Anomaly",
      "condition": "payment_amount > (avg_severity_for_type * 5)",
      "severity": "HIGH",
      "channels": ["Email claims-finance", "Slack #fraud-alerts"],
      "cooldown": 0,
      "description": "Payment significantly exceeds expected severity"
    }
  ]
}
```

---

## 9. BI Technology Stack

### BI Tool Comparison

| Feature | Tableau | Power BI | Looker | QlikSense |
|---------|---------|----------|--------|-----------|
| **Vendor** | Salesforce | Microsoft | Google | Qlik |
| **Deployment** | Cloud + Desktop | Cloud + Desktop | Cloud only | Cloud + on-prem |
| **Data modeling** | In-tool + live | Power Query, DAX | LookML (code) | Associative engine |
| **Visualization** | Excellent | Very good | Good | Excellent |
| **Self-service** | Excellent | Excellent | Good (requires LookML) | Good |
| **Embedded analytics** | Good (Embedded) | Excellent (Power BI Embedded) | Excellent (Looker Embed) | Good |
| **Real-time** | Good (live connect) | Good (DirectQuery) | Good (live) | Good (direct) |
| **Governance** | Good | Excellent (M365 integration) | Excellent (LookML) | Good |
| **Cost** | $$$ ($70/user/mo Creator) | $$ ($10/user/mo Pro) | $$$ (platform pricing) | $$$ ($30/user/mo) |
| **Learning curve** | Moderate | Low-Moderate | High (LookML) | Moderate |
| **Claims vertical** | Strong community | Strong adoption | Growing | Moderate |
| **Mobile** | Good | Excellent | Good | Good |

---

## 10. Analytics Platform Architecture (Cloud)

### AWS Architecture

```
+===================================================================+
|              AWS ANALYTICS PLATFORM FOR CLAIMS                      |
+===================================================================+
|                                                                     |
|  SOURCE LAYER                                                      |
|  +-------------------------------------------------------------+  |
|  | RDS (Claims DB) → DMS → S3 Raw Zone                         |  |
|  | Kafka → Kinesis Data Firehose → S3 Raw Zone                  |  |
|  | API (vendor data) → Lambda → S3 Raw Zone                     |  |
|  +-------------------------------------------------------------+  |
|                                                                     |
|  STORAGE LAYER                                                     |
|  +-------------------------------------------------------------+  |
|  | S3 Data Lake                                                 |  |
|  | ├── raw/ (Bronze - source format)                            |  |
|  | ├── curated/ (Silver - cleaned, Delta Lake format)           |  |
|  | └── analytics/ (Gold - star schema, aggregations)            |  |
|  +-------------------------------------------------------------+  |
|                                                                     |
|  PROCESSING LAYER                                                  |
|  +-------------------------------------------------------------+  |
|  | AWS Glue / EMR (Spark) / Lambda                              |  |
|  | - ETL jobs (Glue Studio or custom Spark)                     |  |
|  | - Data quality checks (Great Expectations / Deequ)           |  |
|  | - Schema management (Glue Data Catalog)                      |  |
|  +-------------------------------------------------------------+  |
|                                                                     |
|  WAREHOUSE LAYER                                                   |
|  +-------------------------------------------------------------+  |
|  | Amazon Redshift Serverless                                   |  |
|  | - Star schema tables                                        |  |
|  | - Materialized views                                        |  |
|  | - Redshift Spectrum (query S3 directly)                     |  |
|  +-------------------------------------------------------------+  |
|                                                                     |
|  ML LAYER                                                          |
|  +-------------------------------------------------------------+  |
|  | Amazon SageMaker                                             |  |
|  | - Feature Store (claim features for ML)                      |  |
|  | - Model Training (XGBoost, DeepAR, AutoML)                  |  |
|  | - Model Registry (versioning, approval)                     |  |
|  | - Endpoints (real-time scoring)                              |  |
|  | - Batch Transform (bulk scoring)                             |  |
|  +-------------------------------------------------------------+  |
|                                                                     |
|  VISUALIZATION LAYER                                               |
|  +-------------------------------------------------------------+  |
|  | Amazon QuickSight / Tableau / Power BI                      |  |
|  | - Dashboards (operational, executive, CAT)                   |  |
|  | - Embedded analytics (in claims application)                |  |
|  | - Scheduled reports (email distribution)                    |  |
|  +-------------------------------------------------------------+  |
|                                                                     |
|  GOVERNANCE LAYER                                                  |
|  +-------------------------------------------------------------+  |
|  | AWS Lake Formation                                           |  |
|  | - Data catalog                                               |  |
|  | - Fine-grained access control                               |  |
|  | - Column-level security (PII masking)                       |  |
|  | - Audit logging                                              |  |
|  +-------------------------------------------------------------+  |
|                                                                     |
+===================================================================+
```

### Azure Architecture

```
+===================================================================+
|              AZURE ANALYTICS PLATFORM FOR CLAIMS                    |
+===================================================================+
|                                                                     |
|  SOURCE → Azure Data Factory (ADF) → ADLS Gen2 (Raw)              |
|                                                                     |
|  PROCESSING:                                                       |
|  Azure Databricks (Spark + Delta Lake)                             |
|    - Bronze → Silver → Gold medallion architecture                 |
|    - Unity Catalog for governance                                  |
|                                                                     |
|  WAREHOUSE:                                                        |
|  Azure Synapse Analytics                                           |
|    - Dedicated SQL Pool (star schema)                              |
|    - Serverless SQL Pool (ad hoc queries on lake)                  |
|    - Synapse Link for Cosmos DB (real-time operational analytics)  |
|                                                                     |
|  ML:                                                               |
|  Azure Machine Learning                                            |
|    - Automated ML                                                  |
|    - MLflow integration                                            |
|    - Managed endpoints                                             |
|                                                                     |
|  VISUALIZATION:                                                    |
|  Power BI                                                          |
|    - DirectQuery to Synapse                                        |
|    - Import mode for dashboards                                    |
|    - Power BI Embedded for claims app                              |
|                                                                     |
|  GOVERNANCE:                                                       |
|  Microsoft Purview                                                 |
|    - Data catalog                                                  |
|    - Data classification                                           |
|    - Lineage tracking                                              |
|                                                                     |
+===================================================================+
```

---

## 11. Data Governance for Claims Analytics

### Data Quality Framework

| Dimension | Definition | Measurement | Target |
|-----------|-----------|-------------|--------|
| Completeness | All required fields populated | % of non-null required fields | > 99% |
| Accuracy | Data matches source of truth | Sample audit comparison | > 99.5% |
| Timeliness | Data available within SLA | Time from source change to warehouse | < 4 hours |
| Consistency | Same value across systems | Cross-system reconciliation | > 99% |
| Uniqueness | No duplicate records | Duplicate detection | 0 duplicates |
| Validity | Values within expected ranges | Range/format validation | > 99.5% |

### Data Quality Rules for Claims

```json
{
  "dataQualityRules": {
    "fact_claim": [
      {
        "ruleId": "DQ-001",
        "column": "claim_number",
        "rule": "NOT_NULL",
        "severity": "CRITICAL",
        "action": "REJECT_RECORD"
      },
      {
        "ruleId": "DQ-002",
        "column": "incurred_amount",
        "rule": "incurred_amount >= 0",
        "severity": "CRITICAL",
        "action": "REJECT_RECORD"
      },
      {
        "ruleId": "DQ-003",
        "column": "incurred_amount",
        "rule": "incurred_amount = paid_amount + outstanding_reserve",
        "severity": "HIGH",
        "action": "FLAG_AND_ALERT"
      },
      {
        "ruleId": "DQ-004",
        "column": "loss_date_key",
        "rule": "loss_date <= reported_date",
        "severity": "HIGH",
        "action": "FLAG_AND_ALERT"
      },
      {
        "ruleId": "DQ-005",
        "column": "cycle_time_days",
        "rule": "cycle_time_days >= 0 AND cycle_time_days < 3650",
        "severity": "MEDIUM",
        "action": "FLAG_FOR_REVIEW"
      },
      {
        "ruleId": "DQ-006",
        "column": "claim_count",
        "rule": "SUM(claim_count) reconciles to source system within 0.1%",
        "severity": "CRITICAL",
        "action": "HALT_ETL_AND_ALERT"
      }
    ]
  }
}
```

### PII Management in Analytics

| PII Field | Masking Strategy | Analytics Access | Raw Access |
|-----------|-----------------|-----------------|------------|
| SSN | Hash (SHA-256 with salt) | Hashed only | Restricted |
| Name | Pseudonymize or suppress | Suppressed | Restricted |
| Address | Generalize to zip code | Zip only | Restricted |
| Phone | Suppress | Not available | Restricted |
| Email | Suppress | Not available | Restricted |
| Date of Birth | Generalize to age band | Age band | Restricted |
| Policy Number | Tokenize | Tokenized | Authorized |
| Claim Number | Available | Available | Available |

---

## 12. Self-Service Analytics for Business Users

### Self-Service Capabilities

| Capability | Tool | Users | Governance |
|-----------|------|-------|------------|
| Dashboard creation | Tableau / Power BI | Business analysts | Certified data sources only |
| Ad hoc querying | Redshift SQL / Athena | Data analysts | Read-only, row-level security |
| Report scheduling | Tableau / Power BI | Managers | Pre-built report templates |
| Data exploration | Tableau Prep / Power Query | Analysts | Curated datasets |
| Metric definition | Looker (LookML) / dbt Metrics | Data team only | Code-reviewed, version-controlled |
| Natural language query | Tableau Ask Data / Power BI Q&A | All business users | Curated semantic model |
| Excel connectivity | ODBC/Live Connect | All users | Governed data sources |

---

## 13. Embedded Analytics in Claims Applications

### Embedding Architecture

```
+-------------------------------------------------------------------+
|              EMBEDDED ANALYTICS ARCHITECTURE                        |
+-------------------------------------------------------------------+
|                                                                     |
|  Claims Application (Guidewire ClaimCenter)                        |
|       |                                                             |
|       | Claim context (claim #, adjuster, LOB, etc.)               |
|       v                                                             |
|  +---------------------+                                           |
|  | Claims UI           |                                           |
|  | (embedded iframe or  |                                           |
|  |  component)          |                                           |
|  |                      |                                           |
|  | +------------------+ |                                           |
|  | | Embedded         | |                                           |
|  | | Dashboard        | |                                           |
|  | | (Filtered to     | |                                           |
|  | |  current claim   | |                                           |
|  | |  context)        | |                                           |
|  | +------------------+ |                                           |
|  +----------+----------+                                           |
|             |                                                       |
|  +----------v----------+                                           |
|  | BI Embedding Service |                                           |
|  | (Tableau Embedded /  |                                           |
|  |  Power BI Embedded / |                                           |
|  |  Looker Embedded)    |                                           |
|  |                      |                                           |
|  | - SSO authentication |                                           |
|  | - Context filtering  |                                           |
|  | - RLS (row-level     |                                           |
|  |   security)          |                                           |
|  +----------+----------+                                           |
|             |                                                       |
|  +----------v----------+                                           |
|  | Analytics Data Store |                                           |
|  | (Redshift / Synapse) |                                           |
|  +---------------------+                                           |
|                                                                     |
+-------------------------------------------------------------------+
```

### Embedded Analytics Use Cases

| Location in Claims App | Analytics Content | User |
|----------------------|-------------------|------|
| Claim detail page | Claim timeline, similar claims, severity prediction | Adjuster |
| FNOL intake | Fraud score, coverage verification, STP eligibility | FNOL handler |
| Reserve review | Reserve adequacy, comparable claims, development pattern | Adjuster/Supervisor |
| Manager workbench | Team performance, SLA status, workload balance | Claims manager |
| Vendor assignment | Vendor scorecard, capacity, performance history | Assignment team |
| SIU referral | Fraud indicators, network graph, red flags | SIU investigator |
| Financial review | Claim financials, payment history, reserve history | Finance analyst |

---

## 14. Reporting Automation & Distribution

### Report Distribution Architecture

```
+-------------------------------------------------------------------+
|              REPORTING AUTOMATION & DISTRIBUTION                    |
+-------------------------------------------------------------------+
|                                                                     |
|  REPORT CATALOG                                                    |
|  +-------------------------------------------------------------+  |
|  | ID      | Report Name                | Frequency | Format   |  |
|  |---------|----------------------------|-----------|----------|  |
|  | RPT-001 | Daily Claims Dashboard     | Daily 7AM | Dashboard|  |
|  | RPT-002 | Weekly Loss Ratio          | Mon 8AM   | PDF+Email|  |
|  | RPT-003 | Monthly Executive Summary  | 1st of mo | PPT+Email|  |
|  | RPT-004 | Quarterly Reserve Review   | Q end +5d | Excel    |  |
|  | RPT-005 | Annual Statutory Report    | Annual    | NAIC fmt |  |
|  | RPT-006 | Daily SLA Compliance       | Daily 6AM | Dashboard|  |
|  | RPT-007 | Weekly CAT Status          | When active| Dashboard|  |
|  | RPT-008 | Monthly Adjuster Scorecard | 5th of mo | PDF+Email|  |
|  | RPT-009 | Quarterly Vendor Review    | Q end +10d| PPT      |  |
|  | RPT-010 | Monthly Fraud Referral     | 3rd of mo | Secure   |  |
|  +-------------------------------------------------------------+  |
|                                                                     |
|  AUTOMATION ENGINE                                                 |
|  +-------------------------------------------------------------+  |
|  | Scheduler: Airflow / Prefect / cron                          |  |
|  |                                                              |  |
|  | Job Flow:                                                    |  |
|  | 1. Trigger (schedule or event)                               |  |
|  | 2. Execute report query                                      |  |
|  | 3. Render output (PDF, Excel, PPT, HTML)                    |  |
|  | 4. Apply branding and formatting                             |  |
|  | 5. Distribute via:                                           |  |
|  |    - Email (with attachment or link)                         |  |
|  |    - Portal (publish to report library)                      |  |
|  |    - SFTP (for regulatory filings)                          |  |
|  |    - Slack/Teams (notification with link)                   |  |
|  | 6. Log delivery and access                                   |  |
|  +-------------------------------------------------------------+  |
|                                                                     |
+-------------------------------------------------------------------+
```

---

## 15. Sample Dashboard Designs with Metrics Layouts

### Adjuster Performance Scorecard

```
+===================================================================+
|  ADJUSTER SCORECARD: Sarah Johnson          Period: October 2024   |
+===================================================================+
|                                                                     |
|  OVERALL SCORE: 4.3 / 5.0                    Rank: 5 of 42       |
|                                                                     |
|  +---------------------------+  +-----------------------------+    |
|  | VOLUME                    |  | QUALITY                     |    |
|  | Open Claims:      42      |  | QA Audit Score:   4.5/5     |    |
|  | Closed MTD:       14      |  | Supplement Rate:  8%        |    |
|  | New MTD:          16      |  | Reopening Rate:   2%        |    |
|  | Inspections MTD:  22      |  | Reserve Accuracy: +5%       |    |
|  +---------------------------+  +-----------------------------+    |
|                                                                     |
|  +---------------------------+  +-----------------------------+    |
|  | TIMELINESS                |  | CUSTOMER                    |    |
|  | Avg Contact Time:  8 hrs  |  | NPS:              45        |    |
|  | Avg Inspect Time:  3.2 d  |  | CSAT:             4.6       |    |
|  | Avg Cycle Time:   15.2 d  |  | Complaints:       0         |    |
|  | Overdue Tasks:     3      |  | Compliments:      3         |    |
|  +---------------------------+  +-----------------------------+    |
|                                                                     |
|  TREND (6-Month)                                                   |
|  +-------------------------------------------------------------+  |
|  | Metric      | May  | Jun  | Jul  | Aug  | Sep  | Oct        |  |
|  |-------------|------|------|------|------|------|------------|  |
|  | Closures    |  12  |  15  |  13  |  16  |  14  |  14 (MTD)  |  |
|  | Cycle Time  | 16.1 | 14.8 | 15.5 | 14.2 | 15.0 | 15.2      |  |
|  | NPS         |  42  |  48  |  44  |  50  |  46  |  45        |  |
|  | Quality     | 4.3  | 4.5  | 4.4  | 4.6  | 4.5  | 4.5       |  |
|  +-------------------------------------------------------------+  |
|                                                                     |
+===================================================================+
```

### SIU/Fraud Dashboard

```
+===================================================================+
|  SIU / FRAUD DASHBOARD                              October 2024   |
+===================================================================+
|                                                                     |
|  +----------+ +----------+ +----------+ +----------+ +----------+ |
|  | Referrals| | Open     | | Confirmed| | Savings  | | Detection| |
|  | MTD      | | Invest.  | | Fraud MTD| | MTD      | | Rate     | |
|  |    34    | |    67    | |    12    | |  $1.2M   | |   2.8%   | |
|  | ▲ +15%   | | ▼ -3%    | | ▲ +20%   | | ▲ +25%   | | ▲ +0.3%  | |
|  +----------+ +----------+ +----------+ +----------+ +----------+ |
|                                                                     |
|  REFERRAL SOURCES                    FRAUD TYPE DISTRIBUTION       |
|  +---------------------------+      +---------------------------+  |
|  | AI/ML Scoring:     45%    |      | Staged Accident:   25%    |  |
|  | Adjuster Referral: 25%    |      | Inflated Damage:   20%    |  |
|  | ClaimSearch Flag:  15%    |      | False BI:          18%    |  |
|  | Rules Engine:      10%    |      | Arson:             12%    |  |
|  | SIU Proactive:      5%    |      | Phantom Vehicle:    8%    |  |
|  +---------------------------+      | Other:             17%    |  |
|                                     +---------------------------+  |
|                                                                     |
+===================================================================+
```

---

## 16. Claims Analytics Data Model (Complete ERD)

### Analytics ERD Summary

```
+===================================================================+
|              CLAIMS ANALYTICS - ENTITY RELATIONSHIP DIAGRAM         |
+===================================================================+
|                                                                     |
|  FACT TABLES (Center)          DIMENSION TABLES (Surrounding)      |
|                                                                     |
|  +------------------+          +------------------+                 |
|  | fact_claim       |--------->| dim_date         |                 |
|  | (1 row per claim)|--------->| dim_coverage     |                 |
|  |                  |--------->| dim_cause_of_loss|                 |
|  |                  |--------->| dim_adjuster     |                 |
|  |                  |--------->| dim_geography    |                 |
|  |                  |--------->| dim_policy       |                 |
|  +--------+---------+          +------------------+                 |
|           |                                                         |
|  +--------v---------+          +------------------+                 |
|  | fact_payment     |--------->| dim_vendor       |                 |
|  | (1 row per pmt)  |--------->| dim_payee        |                 |
|  +------------------+          +------------------+                 |
|                                                                     |
|  +------------------+                                               |
|  | fact_reserve     |          +------------------+                 |
|  | (1 row per txn)  |          | dim_cat_event    |                 |
|  +------------------+          +------------------+                 |
|                                                                     |
|  +------------------+          +------------------+                 |
|  | fact_activity    |          | dim_fraud_indicator|                |
|  | (1 row per act)  |          +------------------+                 |
|  +------------------+                                               |
|                                                                     |
|  AGGREGATE TABLES                                                  |
|  +------------------+                                               |
|  | agg_daily_claims |   (Pre-aggregated for dashboard performance) |
|  | agg_monthly_fin  |                                               |
|  | agg_adjuster_perf|                                               |
|  | agg_vendor_perf  |                                               |
|  +------------------+                                               |
|                                                                     |
+===================================================================+
```

### Aggregate Table DDL

```sql
CREATE TABLE agg_daily_claims (
    date_key            INTEGER         NOT NULL REFERENCES dim_date(date_key),
    coverage_key        INTEGER         NOT NULL REFERENCES dim_coverage(coverage_key),
    geography_key       INTEGER         NOT NULL REFERENCES dim_geography(geo_key),
    cause_of_loss_key   INTEGER         NOT NULL REFERENCES dim_cause_of_loss(col_key),

    new_claim_count     INTEGER         DEFAULT 0,
    closed_claim_count  INTEGER         DEFAULT 0,
    reopened_claim_count INTEGER        DEFAULT 0,
    open_claim_count    INTEGER         DEFAULT 0,

    total_incurred      DECIMAL(15,2)   DEFAULT 0,
    total_paid          DECIMAL(15,2)   DEFAULT 0,
    total_reserved      DECIMAL(15,2)   DEFAULT 0,
    total_recovery      DECIMAL(15,2)   DEFAULT 0,
    net_incurred        DECIMAL(15,2)   DEFAULT 0,

    avg_severity        DECIMAL(15,2),
    avg_cycle_time_days DECIMAL(8,1),
    avg_contact_hours   DECIMAL(8,1),

    stp_claim_count     INTEGER         DEFAULT 0,
    litigated_count     INTEGER         DEFAULT 0,
    fraud_referred_count INTEGER        DEFAULT 0,
    cat_claim_count     INTEGER         DEFAULT 0,

    PRIMARY KEY (date_key, coverage_key, geography_key, cause_of_loss_key)
);

CREATE TABLE agg_monthly_financial (
    year_month          VARCHAR(7)      NOT NULL,
    coverage_key        INTEGER         NOT NULL REFERENCES dim_coverage(coverage_key),
    geography_key       INTEGER         NOT NULL REFERENCES dim_geography(geo_key),

    earned_premium      DECIMAL(15,2),
    written_premium     DECIMAL(15,2),
    incurred_losses     DECIMAL(15,2),
    paid_losses         DECIMAL(15,2),
    outstanding_reserves DECIMAL(15,2),
    ibnr_reserves       DECIMAL(15,2),
    alae_incurred       DECIMAL(15,2),
    ulae_incurred       DECIMAL(15,2),
    salvage_recovery    DECIMAL(15,2),
    subrogation_recovery DECIMAL(15,2),
    net_incurred        DECIMAL(15,2),

    loss_ratio          DECIMAL(7,4),
    expense_ratio       DECIMAL(7,4),
    combined_ratio      DECIMAL(7,4),

    claim_count         INTEGER,
    avg_severity        DECIMAL(15,2),
    closure_rate        DECIMAL(7,4),

    PRIMARY KEY (year_month, coverage_key, geography_key)
);

CREATE TABLE agg_adjuster_performance (
    year_month          VARCHAR(7)      NOT NULL,
    adjuster_key        INTEGER         NOT NULL REFERENCES dim_adjuster(adjuster_key),

    claims_handled      INTEGER         DEFAULT 0,
    claims_closed       INTEGER         DEFAULT 0,
    claims_opened       INTEGER         DEFAULT 0,
    open_inventory      INTEGER         DEFAULT 0,
    overdue_activities  INTEGER         DEFAULT 0,

    avg_cycle_time_days DECIMAL(8,1),
    avg_contact_hours   DECIMAL(8,1),
    avg_inspection_days DECIMAL(8,1),
    avg_payment_days    DECIMAL(8,1),

    total_paid          DECIMAL(15,2),
    avg_severity        DECIMAL(15,2),
    reserve_accuracy    DECIMAL(7,4),

    quality_score       DECIMAL(5,2),
    supplement_rate     DECIMAL(7,4),
    reopening_rate      DECIMAL(7,4),

    nps_score           INTEGER,
    csat_score          DECIMAL(3,1),
    complaint_count     INTEGER         DEFAULT 0,

    overall_score       DECIMAL(5,2),
    rank_in_team        INTEGER,
    rank_in_department  INTEGER,

    PRIMARY KEY (year_month, adjuster_key)
);

CREATE TABLE agg_vendor_performance (
    year_month          VARCHAR(7)      NOT NULL,
    vendor_key          INTEGER         NOT NULL,
    vendor_type         VARCHAR(30)     NOT NULL,

    assignments_received INTEGER        DEFAULT 0,
    assignments_completed INTEGER       DEFAULT 0,
    assignments_outstanding INTEGER     DEFAULT 0,

    avg_cycle_time_days DECIMAL(8,1),
    avg_quality_score   DECIMAL(5,2),
    avg_customer_sat    DECIMAL(5,2),
    sla_met_percentage  DECIMAL(7,4),

    total_invoiced      DECIMAL(15,2),
    total_paid          DECIMAL(15,2),
    avg_cost_per_assignment DECIMAL(10,2),

    supplement_rate     DECIMAL(7,4),
    callback_rate       DECIMAL(7,4),
    error_rate          DECIMAL(7,4),

    overall_score       DECIMAL(5,2),

    PRIMARY KEY (year_month, vendor_key)
);
```

---

## Appendix A: Claims Analytics Glossary

| Term | Definition |
|------|-----------|
| ALAE | Allocated Loss Adjustment Expense - costs assignable to a specific claim |
| AY | Accident Year - claims grouped by date of loss |
| CY | Calendar Year - financial transactions in a calendar year |
| IBNR | Incurred But Not Reported - reserve for claims not yet reported |
| Loss Ratio | Incurred losses divided by earned premium |
| Combined Ratio | Loss ratio plus expense ratio |
| Severity | Average claim payment amount |
| Frequency | Number of claims per unit of exposure |
| Development | How claim values change over time from initial to ultimate |
| Triangle | Actuarial tool showing claim development over time |
| ULAE | Unallocated Loss Adjustment Expense - overhead costs |
| Earned Premium | Premium portion for which coverage has been provided |
| Written Premium | Total premium for policies issued in period |
| PY | Policy Year - claims grouped by policy effective date |
| RY | Report Year - claims grouped by report date |

---

## Appendix B: Sample SQL Queries

### Loss Ratio by Coverage and Month

```sql
SELECT
    d.year,
    d.month_name,
    c.line_of_business,
    c.coverage_name,
    SUM(f.incurred_amount) AS incurred,
    SUM(f.alae_paid + f.alae_reserve) AS alae,
    SUM(p.earned_premium) AS earned_premium,
    CASE
        WHEN SUM(p.earned_premium) > 0
        THEN (SUM(f.incurred_amount) + SUM(f.alae_paid + f.alae_reserve))
             / SUM(p.earned_premium) * 100
        ELSE 0
    END AS loss_ratio_pct
FROM fact_claim f
JOIN dim_date d ON f.loss_date_key = d.date_key
JOIN dim_coverage c ON f.coverage_key = c.coverage_key
JOIN dim_policy p ON f.policy_key = p.policy_key
WHERE d.year = 2024
GROUP BY d.year, d.month, d.month_name, c.line_of_business, c.coverage_name
ORDER BY d.month, c.line_of_business;
```

### Adjuster Performance Ranking

```sql
SELECT
    a.adjuster_name,
    a.team_name,
    COUNT(CASE WHEN f.is_closed THEN 1 END) AS claims_closed,
    AVG(f.cycle_time_days) AS avg_cycle_days,
    AVG(f.nps_score) AS avg_nps,
    SUM(f.paid_amount) / NULLIF(COUNT(CASE WHEN f.is_closed THEN 1 END), 0) AS avg_severity,
    RANK() OVER (
        PARTITION BY a.team_name
        ORDER BY AVG(f.cycle_time_days) ASC
    ) AS cycle_time_rank
FROM fact_claim f
JOIN dim_adjuster a ON f.adjuster_key = a.adjuster_key
JOIN dim_date d ON f.reported_date_key = d.date_key
WHERE d.year = 2024 AND d.month = 10
    AND a.is_active = TRUE
GROUP BY a.adjuster_name, a.team_name
HAVING COUNT(*) >= 10
ORDER BY avg_cycle_days ASC;
```

### Claims Aging Inventory

```sql
SELECT
    CASE
        WHEN DATEDIFF(day, d.full_date, CURRENT_DATE) BETWEEN 0 AND 30 THEN '0-30 days'
        WHEN DATEDIFF(day, d.full_date, CURRENT_DATE) BETWEEN 31 AND 60 THEN '31-60 days'
        WHEN DATEDIFF(day, d.full_date, CURRENT_DATE) BETWEEN 61 AND 90 THEN '61-90 days'
        WHEN DATEDIFF(day, d.full_date, CURRENT_DATE) BETWEEN 91 AND 180 THEN '91-180 days'
        WHEN DATEDIFF(day, d.full_date, CURRENT_DATE) BETWEEN 181 AND 365 THEN '181-365 days'
        ELSE '365+ days'
    END AS age_bucket,
    COUNT(*) AS claim_count,
    SUM(f.outstanding_reserve) AS total_reserves,
    AVG(f.incurred_amount) AS avg_incurred
FROM fact_claim f
JOIN dim_date d ON f.reported_date_key = d.date_key
WHERE f.is_open = TRUE
GROUP BY
    CASE
        WHEN DATEDIFF(day, d.full_date, CURRENT_DATE) BETWEEN 0 AND 30 THEN '0-30 days'
        WHEN DATEDIFF(day, d.full_date, CURRENT_DATE) BETWEEN 31 AND 60 THEN '31-60 days'
        WHEN DATEDIFF(day, d.full_date, CURRENT_DATE) BETWEEN 61 AND 90 THEN '61-90 days'
        WHEN DATEDIFF(day, d.full_date, CURRENT_DATE) BETWEEN 91 AND 180 THEN '91-180 days'
        WHEN DATEDIFF(day, d.full_date, CURRENT_DATE) BETWEEN 181 AND 365 THEN '181-365 days'
        ELSE '365+ days'
    END
ORDER BY MIN(DATEDIFF(day, d.full_date, CURRENT_DATE));
```

---

*This article is part of the PnC Claims Encyclopedia. For related topics, see Article 16 (Catastrophe Claims), Article 17 (Vendor Ecosystem), and Article 19 (Customer Experience).*
