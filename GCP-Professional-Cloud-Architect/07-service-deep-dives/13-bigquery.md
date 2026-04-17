# Service Deep Dive — BigQuery

## Overview
- Serverless, columnar data warehouse.
- PB-scale, SQL (GoogleSQL) + legacy SQL.
- Separates **storage** and **compute (slots)**.

## Architecture
- Managed Colossus storage.
- Dremel execution engine, tree architecture.
- Storage API (Read/Write) for Beam / Spark.

## Datasets
- Regional / multi-regional / bi-regional (US, EU).
- Access control at dataset, table, column (policy tags), row (row-level policies).
- **Authorized views** / **authorized datasets** / **authorized routines**.

## Tables
- Partition by ingestion time, DATE, TIMESTAMP, integer range.
- Cluster by up to 4 columns.
- **Require partition filter** forces filter (prevents full scan).
- **External tables** over GCS (Parquet, ORC, Avro, JSON, CSV), BigLake for governance.
- **Materialized views** for accelerated aggregates.
- **Table snapshots** / clones (COW).
- **Time travel** 2–7d; snapshot immutable up to 7y.

## Pricing modes
- **On-demand**: $6.25/TB scanned (after free 1 TB/month/region).
- **Editions**: Standard, Enterprise, Enterprise Plus.
- **Slot reservations**: commit 1y or 3y; autoscaler adds overflow slots.
- **Storage**: active vs long-term (~50% cheaper after 90d untouched).

## Loading data
- Batch: bq load, Storage API (Write), BQ DTS.
- Streaming: Storage Write API (default), legacy streamingInserts.
- Federated queries: GCS, Cloud SQL, Bigtable, Spanner via external connection.

## Governance
- **Policy tags** + Data Catalog / Dataplex.
- **Column-level access**, **data masking** (masked columns).
- **Row-level security** via ROW ACCESS POLICY.
- **Dataplex Lineage**, **Data Quality**, **Discovery**.

## Performance
- **BI Engine**: in-memory layer for sub-second dashboards (reservations).
- Materialized views, clustering.
- Avoid `SELECT *`; use only necessary columns.
- Large joins: use partitioning + clustering + approximate functions.
- **Query caching** (24h per query).

## ML
- **BigQuery ML**: train models (linear, logistic, DNN, AutoML, XGBoost, K-means, ARIMA, time-series, matrix factorization) via SQL.
- Integrates with Vertex AI for deployment.

## Cross-cloud
- **BigQuery Omni**: query AWS S3 or Azure Blob from BigQuery, data stays in cloud of origin.
- **Analytics Hub**: share datasets across organizations.

## Security
- Default encryption + CMEK (Enterprise / Enterprise Plus).
- VPC-SC perimeter (BQ fully supported).
- Audit logs (Data Access logs optional but common).

## Exam cues
- Partition + cluster + require filter for cost control.
- BI Engine for dashboards.
- Editions autoscaler for spiky workloads.
- Storage Write API for exactly-once streaming.
- Analytics Hub for data sharing (replaces legacy dataset sharing).
- Omni for cross-cloud analytics.
