# 08 — Analytics & Big Data on AWS

## Complete Guide for AWS Solutions Architect Professional (SAP-C02)

---

## Table of Contents

1. [Analytics Overview and Data Pipeline Architecture](#1-analytics-overview-and-data-pipeline-architecture)
2. [Kinesis Data Streams](#2-kinesis-data-streams)
3. [Kinesis Data Firehose](#3-kinesis-data-firehose)
4. [Amazon OpenSearch Service](#4-amazon-opensearch-service)
5. [Amazon Redshift](#5-amazon-redshift)
6. [Amazon Athena](#6-amazon-athena)
7. [AWS Glue](#7-aws-glue)
8. [Amazon EMR](#8-amazon-emr)
9. [AWS Lake Formation](#9-aws-lake-formation)
10. [Amazon QuickSight](#10-amazon-quicksight)
11. [Amazon MSK](#11-amazon-msk)
12. [Data Lake Architecture Patterns](#12-data-lake-architecture-patterns)
13. [Real-Time vs Batch vs Near-Real-Time Processing](#13-real-time-vs-batch-vs-near-real-time-processing)
14. [Exam Scenarios](#14-exam-scenarios)

---

## 1. Analytics Overview and Data Pipeline Architecture

### The Analytics Pipeline

Every analytics architecture on AWS follows this pattern:

```
┌──────────┐    ┌──────────┐    ┌──────────┐    ┌──────────┐    ┌──────────┐
│ COLLECT  │───▶│  STORE   │───▶│ PROCESS  │───▶│ ANALYZE  │───▶│VISUALIZE │
│          │    │          │    │          │    │          │    │          │
│ Kinesis  │    │ S3       │    │ Glue ETL │    │ Athena   │    │QuickSight│
│ IoT Core │    │ Redshift │    │ EMR      │    │ Redshift │    │ Grafana  │
│ DMS      │    │ DynamoDB │    │ Lambda   │    │ OpenSearch│   │ Custom   │
│ AppFlow  │    │ OpenSearch│   │ Kinesis  │    │ EMR      │    │ Dashboards│
│ Direct   │    │          │    │ Analytics│    │          │    │          │
│ Connect  │    │          │    │          │    │          │    │          │
└──────────┘    └──────────┘    └──────────┘    └──────────┘    └──────────┘
```

### Service Selection by Latency Requirement

| Latency | Pattern | AWS Services |
|---------|---------|-------------|
| **Real-time** (< 1 second) | Stream processing | Kinesis Data Streams, Lambda, MSK, OpenSearch |
| **Near-real-time** (seconds to minutes) | Micro-batch | Kinesis Firehose, Spark Streaming (EMR/Glue), Flink |
| **Batch** (minutes to hours) | ETL jobs | Glue ETL, EMR, Athena CTAS, Redshift COPY |

---

## 2. Kinesis Data Streams

### Architecture

```
┌──────────────────────────────────────────────────────────────────┐
│                    Kinesis Data Stream                             │
│                                                                   │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐         │
│  │ Shard 1  │  │ Shard 2  │  │ Shard 3  │  │ Shard N  │         │
│  │ 1MB/s in │  │ 1MB/s in │  │ 1MB/s in │  │ 1MB/s in │         │
│  │ 2MB/s out│  │ 2MB/s out│  │ 2MB/s out│  │ 2MB/s out│         │
│  └──────────┘  └──────────┘  └──────────┘  └──────────┘         │
│       ▲              ▲             ▲              ▲               │
│       │              │             │              │               │
│  Partition Key determines shard assignment (hash function)        │
└──────────────────────────────────────────────────────────────────┘
        ▲                                              │
        │                                              ▼
┌──────────────┐                              ┌──────────────────┐
│  Producers   │                              │  Consumers       │
│  - KPL       │                              │  - KCL           │
│  - SDK       │                              │  - Lambda        │
│  - Kinesis   │                              │  - Firehose      │
│    Agent     │                              │  - Kinesis Data  │
│  - IoT Core  │                              │    Analytics     │
└──────────────┘                              └──────────────────┘
```

### Shard Capacity

| Metric | Per Shard |
|--------|----------|
| **Write** | 1 MB/s or 1,000 records/s |
| **Read (shared)** | 2 MB/s across all consumers |
| **Read (enhanced fan-out)** | 2 MB/s **per consumer** |

**Example:** 10 shards = 10 MB/s write, 20 MB/s read (shared), or 20 MB/s per consumer (enhanced fan-out).

### Capacity Modes

| Mode | Description | Use Case |
|------|------------|----------|
| **Provisioned** | You specify shard count | Predictable workloads, cost control |
| **On-Demand** | Auto scales (up to 200 MB/s write, 400 MB/s read) | Variable/unpredictable workloads |

### Producers

**Kinesis Producer Library (KPL):**
- Batching (collection) — aggregates multiple user records into a single Kinesis record
- Compression
- Retry with backoff
- CloudWatch metrics integration
- **Introduces latency** due to `RecordMaxBufferedTime` (default 100ms)

**AWS SDK (PutRecord / PutRecords):**
- Direct, low-latency
- No batching
- Synchronous
- Use for low-volume or latency-sensitive producers

**Kinesis Agent:**
- Pre-built Java agent that monitors files and sends to Kinesis
- Useful for log file streaming from EC2

### Consumers

**Kinesis Client Library (KCL):**
- Manages shard leases via DynamoDB table (one worker per shard)
- Checkpointing (tracks position in stream)
- Handles resharding automatically
- Java library (with multi-language support via MultiLangDaemon)

**Lambda (Event Source Mapping):**
- Serverless consumer
- Batch size: 1–10,000 records
- Batch window: up to 5 minutes
- Parallelization factor: 1–10 (multiple Lambda invocations per shard)
- Bisect on function error (split batch in half for retry)
- Tumbling windows for aggregations (up to 15 minutes)

### Enhanced Fan-Out

```
SHARED CONSUMER (default):
Shard ──── 2 MB/s ──── shared across ALL consumers (GetRecords polling)

ENHANCED FAN-OUT:
Shard ──── 2 MB/s ──── Consumer A (SubscribeToShard, push via HTTP/2)
      ──── 2 MB/s ──── Consumer B
      ──── 2 MB/s ──── Consumer C
      (each gets dedicated 2 MB/s, ~70ms latency vs ~200ms)
```

| Feature | Shared (GetRecords) | Enhanced Fan-Out (SubscribeToShard) |
|---------|-------------------|-----------------------------------|
| Throughput per shard | 2 MB/s total for all | 2 MB/s per consumer |
| Latency | ~200ms | ~70ms |
| Model | Pull (polling) | Push (HTTP/2) |
| Max consumers | 5 GetRecords/s per shard | Up to 20 registered consumers |
| Cost | Included | Additional per-consumer charge |

### Resharding

| Operation | Description | Use Case |
|-----------|------------|----------|
| **Split** | One shard → two shards | Increase capacity (hot shard) |
| **Merge** | Two adjacent shards → one shard | Decrease capacity (reduce cost) |

Resharding is sequential — you can only split or merge one shard at a time. For large streams, this can take hours.

> **Exam Tip:** If a question mentions "hot partition" or uneven data distribution in Kinesis, the answer is to choose a better partition key (more cardinality) or split the hot shard.

---

## 3. Kinesis Data Firehose

### Architecture

```
┌──────────────┐     ┌──────────────────────────────────────────┐
│ Sources      │     │            Kinesis Data Firehose          │
│              │     │                                           │
│ Kinesis      │────▶│  ┌──────────┐  ┌──────────┐  ┌────────┐ │
│ Data Streams │     │  │ Buffer   │  │Transform │  │Deliver │ │
│              │     │  │ (size +  │  │(Lambda)  │  │(dest)  │ │
│ Direct PUT   │────▶│  │  time)   │──│          │──│        │ │
│ (SDK/Agent)  │     │  └──────────┘  └──────────┘  └────────┘ │
│              │     │                                           │
│ CloudWatch   │────▶│  Backup: ALL or FAILED records to S3     │
│ Logs         │     │                                           │
│              │     │  Dynamic Partitioning for S3              │
│ IoT Core     │────▶│                                           │
│              │     └──────────────────────────────────────────┘
│ MSK          │────▶          │
└──────────────┘               ▼
                     ┌──────────────────────────┐
                     │ Destinations             │
                     │ - Amazon S3              │
                     │ - Amazon Redshift (via S3)│
                     │ - Amazon OpenSearch       │
                     │ - Splunk                  │
                     │ - Datadog                 │
                     │ - New Relic               │
                     │ - HTTP Endpoint           │
                     │ - MongoDB Cloud           │
                     └──────────────────────────┘
```

### Buffering

Firehose buffers data before delivery:

| Setting | S3 | Redshift | OpenSearch |
|---------|------|----------|-----------|
| **Buffer size** | 1–128 MB | N/A (via S3) | 1–100 MB |
| **Buffer interval** | 60–900 seconds | N/A (via S3) | 60–900 seconds |

Whichever threshold is reached first triggers delivery. Smaller buffers = lower latency but more API calls.

### Lambda Transformations

```
Source → Firehose Buffer → Lambda Transform → Firehose → Destination

Lambda receives batch of records, returns:
{
  "records": [
    {
      "recordId": "abc123",
      "result": "Ok",           // Delivered
      "data": "base64-encoded-transformed-data"
    },
    {
      "recordId": "def456",
      "result": "Dropped",      // Discarded
      "data": "base64-encoded-data"
    },
    {
      "recordId": "ghi789",
      "result": "ProcessingFailed"  // Sent to error bucket
    }
  ]
}
```

Common transformations:
- Format conversion (JSON → Parquet/ORC)
- Data enrichment (lookup additional data)
- Filtering (drop irrelevant records)
- Compression

### Dynamic Partitioning

Partition data in S3 based on record content:

```
Input record: {"device_id": "123", "region": "us-east", "timestamp": "2026-04-16"}

S3 Output:
s3://bucket/year=2026/month=04/day=16/region=us-east/
s3://bucket/year=2026/month=04/day=16/region=eu-west/
```

Uses JQ expressions or Lambda to extract partition keys from records.

> **Exam Tip:** Firehose is the easiest way to get streaming data into S3, Redshift, or OpenSearch. If the question says "near-real-time delivery to S3" → Firehose. If it says "real-time processing" → Kinesis Data Streams + Lambda/KCL.

### Firehose vs Data Streams

| Feature | Data Streams | Firehose |
|---------|-------------|----------|
| **Latency** | Real-time (~200ms) | Near-real-time (60s–900s buffer) |
| **Consumers** | You build (KCL, Lambda) | Managed delivery to destinations |
| **Replay** | Yes (24h–365d retention) | No |
| **Scaling** | Shards (provisioned) or on-demand | Automatic |
| **Transformation** | Consumer-side | Built-in Lambda transform |
| **Format conversion** | Consumer-side | Built-in (JSON→Parquet/ORC) |
| **Ordering** | Per shard | No ordering guarantee |

---

## 4. Amazon OpenSearch Service

### Architecture

```
┌────────────────────────────────────────────────────────────────┐
│  OpenSearch Domain                                              │
│                                                                 │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │  Hot Nodes (data + compute)                               │   │
│  │  ┌────────┐  ┌────────┐  ┌────────┐                      │   │
│  │  │ Node 1 │  │ Node 2 │  │ Node 3 │  (SSD/EBS gp3)      │   │
│  │  │ Primary│  │ Primary│  │ Replica │                      │   │
│  │  │ shards │  │ shards │  │ shards  │                      │   │
│  │  └────────┘  └────────┘  └────────┘                      │   │
│  └──────────────────────────────────────────────────────────┘   │
│                                                                 │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │  UltraWarm Nodes (warm storage)                           │   │
│  │  Read-only, S3-backed, up to 90% cost reduction           │   │
│  │  For infrequently accessed data                           │   │
│  └──────────────────────────────────────────────────────────┘   │
│                                                                 │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │  Cold Storage (S3, cheapest, detached)                    │   │
│  │  Data detached from cluster. Reattach to UltraWarm       │   │
│  │  on demand. Lowest cost for archival.                     │   │
│  └──────────────────────────────────────────────────────────┘   │
│                                                                 │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │  Dedicated Master Nodes (3, for cluster management)       │   │
│  │  No data, only manage cluster state                       │   │
│  └──────────────────────────────────────────────────────────┘   │
└────────────────────────────────────────────────────────────────┘
```

### Storage Tiers

| Tier | Backed By | Latency | Cost | Use Case |
|------|----------|---------|------|----------|
| **Hot** | EBS (gp3/io1) | Milliseconds | $$$ | Active queries, dashboards, recent data |
| **UltraWarm** | S3 (cached locally) | Seconds | $ | Read-only, older data, compliance |
| **Cold** | S3 (detached) | Minutes (must reattach) | ¢ | Archival, rarely accessed |

### Cross-Cluster Replication

Replicate indices across domains for:
- Disaster recovery (cross-region)
- Geographic read proximity
- Centralized reporting across multiple domains

```
Domain A (us-east-1)  ──── replication ────▶  Domain B (eu-west-1)
  (leader index)                                (follower index, read-only)
```

### Fine-Grained Access Control (FGAC)

Supports role-based access at multiple levels:

| Level | Description |
|-------|------------|
| **Cluster** | Cluster-wide permissions (manage indices, snapshots) |
| **Index** | Per-index read/write/delete permissions |
| **Document** | Filter documents based on user attributes |
| **Field** | Restrict access to specific fields within documents |

Integrates with:
- IAM (request signing)
- SAML (Cognito, Okta, etc.)
- Internal user database

### OpenSearch Serverless

Fully managed, auto-scaling OpenSearch without managing domains:

| Feature | OpenSearch Service | OpenSearch Serverless |
|---------|-------------------|---------------------|
| **Capacity** | You choose instance types and count | Auto scales OCUs (OpenSearch Compute Units) |
| **Management** | Patches, upgrades, scaling | Fully managed |
| **Storage tiers** | Hot, UltraWarm, Cold | Automated |
| **Use Case** | Predictable workloads, full control | Variable workloads, operational simplicity |
| **Collection types** | N/A | Time series, Search, Vector search |

> **Exam Tip:** OpenSearch = log analytics + full-text search + dashboards. If the question mentions "log analysis," "search," or "Kibana/OpenSearch Dashboards," think OpenSearch. UltraWarm/Cold storage = cost optimization for older log data.

---

## 5. Amazon Redshift

### Architecture

```
┌────────────────────────────────────────────────────────────────┐
│  Redshift Cluster                                               │
│                                                                 │
│  ┌──────────────┐                                               │
│  │ Leader Node  │ ◀── SQL clients, BI tools, JDBC/ODBC         │
│  │ (query       │                                               │
│  │  planning,   │                                               │
│  │  aggregation)│                                               │
│  └──────┬───────┘                                               │
│         │                                                       │
│  ┌──────┼──────────────────────────────────┐                    │
│  │      ▼              ▼              ▼    │                    │
│  │ ┌──────────┐  ┌──────────┐  ┌──────────┐│                   │
│  │ │Compute   │  │Compute   │  │Compute   ││                   │
│  │ │Node 1    │  │Node 2    │  │Node N    ││                   │
│  │ │          │  │          │  │          ││                   │
│  │ │ Slices   │  │ Slices   │  │ Slices   ││                   │
│  │ │(parallel)│  │(parallel)│  │(parallel)││                   │
│  │ └──────────┘  └──────────┘  └──────────┘│                   │
│  │  Compute Nodes (MPP - Massively Parallel)│                   │
│  └─────────────────────────────────────────┘                    │
│                                                                 │
│  RA3 nodes: Managed storage (S3-backed, local SSD cache)        │
│  DC2 nodes: Dense compute (local SSD only)                      │
└────────────────────────────────────────────────────────────────┘
```

### Distribution Styles

How data is distributed across compute nodes — critical for query performance:

| Style | Description | Best For |
|-------|------------|----------|
| **EVEN** | Round-robin across all slices | Default; tables not joined or no clear join key |
| **KEY** | Rows with same key value go to same slice | Large fact tables joined on a common key (co-locate join data) |
| **ALL** | Full copy on every node | Small dimension tables (< 5M rows) frequently joined |
| **AUTO** | Redshift chooses and changes over time | New tables; let Redshift optimize |

```sql
CREATE TABLE orders (
  order_id BIGINT,
  customer_id BIGINT,
  order_date DATE,
  amount DECIMAL(10,2)
)
DISTSTYLE KEY
DISTKEY(customer_id)
SORTKEY(order_date);
```

### Sort Keys

Determine physical order of data on disk — critical for range queries and zone maps:

| Type | Description | Best For |
|------|------------|----------|
| **Compound** | Multi-column sort, prefix-based | Queries filter on leading columns (date, then region, then...) |
| **Interleaved** | Equal weight to all sort key columns | Queries filter on any combination of columns |

> **Exam Tip:** Compound sort keys are faster for leading-column queries. Interleaved sort keys are better when queries filter on different columns unpredictably but have higher VACUUM overhead.

### Redshift Spectrum

Query data directly in S3 without loading it into Redshift:

```
┌──────────────────┐         ┌──────────────────┐
│ Redshift Cluster │         │ S3 Data Lake     │
│                  │         │                  │
│ Local tables     │         │ Parquet/ORC/CSV  │
│ (hot data)       │         │ (cold/all data)  │
│                  │────────▶│                  │
│ SELECT * FROM    │ Spectrum│ Glue Data Catalog│
│ spectrum_schema  │  query  │ (table metadata) │
│ .external_table  │         │                  │
└──────────────────┘         └──────────────────┘
```

**Requirements:**
- External schema referencing Glue Data Catalog (or Hive metastore)
- S3 data in supported formats (Parquet, ORC, JSON, CSV, Avro, etc.)
- IAM role for Redshift to access S3

**Use cases:**
- Query historical data in S3 while keeping recent data in Redshift
- Join Redshift tables with S3 data
- Cost optimization (don't load all data into expensive Redshift storage)

### Concurrency Scaling

Automatically adds transient clusters to handle query bursts:

```
Normal Load:                    Peak Load:
┌──────────────┐               ┌──────────────┐
│ Main Cluster │               │ Main Cluster │
│ (handles all │               │              │
│  queries)    │               │              │
└──────────────┘               └──────┬───────┘
                                      │
                               ┌──────┼──────────┐
                               ▼      ▼          ▼
                         ┌──────┐ ┌──────┐ ┌──────┐
                         │Scale │ │Scale │ │Scale │
                         │Clust1│ │Clust2│ │Clust3│
                         └──────┘ └──────┘ └──────┘
                         (auto-provisioned, auto-removed)
```

- Free credits: 1 hour per day per cluster
- Scales read queries (SELECT); not write queries
- No data movement — scaling clusters access shared storage (RA3)

### Workload Management (WLM)

Control query prioritization and resource allocation:

| Mode | Description |
|------|------------|
| **Automatic WLM** | Redshift manages memory allocation and concurrency (recommended) |
| **Manual WLM** | You define queues with memory %, concurrency, timeout |

```
Queue: "BI Dashboards"    → Priority: High, Concurrency: 10
Queue: "Ad-hoc Queries"   → Priority: Normal, Concurrency: 5
Queue: "ETL Loads"        → Priority: Low, Concurrency: 2
Queue: "Superuser"        → Reserved for admin queries
```

### Data Sharing

Share live Redshift data across clusters without copying:

```
Producer Cluster ──── Data Share ────▶ Consumer Cluster
(writes data)        (read access)     (queries data, separate billing)
```

- Cross-account and cross-region supported
- Consumer sees real-time data (no ETL/copy)
- Works only with RA3 nodes

### Redshift Serverless

No cluster management, auto-scales, pay per query:

| Feature | Redshift Provisioned | Redshift Serverless |
|---------|---------------------|-------------------|
| **Capacity** | Node type and count | RPU (Redshift Processing Units) auto-scale |
| **Pricing** | Per-node per-hour | Per RPU-hour (only when queries run) |
| **Management** | Resize, WLM config, vacuuming | Minimal |
| **Use Case** | Predictable, steady workloads | Sporadic queries, development, new projects |

### Materialized Views

Pre-computed results for faster queries:

```sql
CREATE MATERIALIZED VIEW mv_daily_sales AS
SELECT date_trunc('day', order_date) as day,
       region,
       SUM(amount) as total_sales,
       COUNT(*) as order_count
FROM orders
GROUP BY 1, 2;

-- Auto-refresh or manual
REFRESH MATERIALIZED VIEW mv_daily_sales;
```

### Federated Query

Query operational databases directly from Redshift:

```
Redshift ──── Federated Query ────▶ RDS PostgreSQL
         ──── Federated Query ────▶ RDS MySQL
         ──── Federated Query ────▶ Aurora

JOIN live operational data with Redshift warehouse data
```

> **Exam Tip:** Redshift = data warehouse for structured/semi-structured data. KEY distribution = co-locate join data. Spectrum = query S3 data lake. Concurrency Scaling = handle bursts. Serverless = pay-per-query for variable workloads. RA3 = managed storage (preferred node type).

---

## 6. Amazon Athena

### Architecture

```
┌──────────────┐     ┌──────────────┐     ┌──────────────┐
│ SQL Client   │────▶│ Athena       │────▶│ S3           │
│ (console,    │     │ (Presto/     │     │ (data lake)  │
│  JDBC, SDK)  │     │  Trino)      │     │              │
└──────────────┘     │              │     └──────────────┘
                     │ Uses Glue    │
                     │ Data Catalog │
                     │ for metadata │
                     └──────────────┘
```

Athena is serverless, interactive SQL query engine for S3 data. You pay per query based on data scanned.

### Performance Optimization

**1. Partitioning** — reduce data scanned:

```
s3://bucket/logs/year=2026/month=04/day=16/
                /year=2026/month=04/day=15/
                /year=2026/month=03/day=01/

Query: WHERE year='2026' AND month='04'
→ Only scans April data, not entire dataset
```

**2. Columnar Formats** — read only needed columns:

| Format | Description | Compression | Best For |
|--------|------------|-------------|----------|
| **Parquet** | Columnar, schema embedded, splittable | Snappy (default), GZIP, ZSTD | Analytics queries (most common) |
| **ORC** | Columnar, optimized for Hive, splittable | ZLIB, Snappy | Hive ecosystem |
| **CSV/JSON** | Row-based, human-readable | GZIP, BZIP2, LZ4 | Simple, small datasets |
| **Avro** | Row-based, schema evolution | Snappy, Deflate | Streaming data with evolving schema |

**3. Compression:**

| Compression | Splittable | Ratio | Speed |
|-------------|-----------|-------|-------|
| **Snappy** | Yes (with Parquet/ORC) | Medium | Fast |
| **GZIP** | No (for CSV/JSON) | High | Slow |
| **ZSTD** | Yes (with Parquet) | High | Fast |
| **LZO** | Yes | Medium | Fast |

**4. File Sizing:**
- Too many small files (< 128 MB) = high overhead per file
- Too few large files = less parallelism
- Optimal: 128 MB – 512 MB per file

### CTAS (Create Table As Select)

Transform and materialize query results:

```sql
CREATE TABLE optimized_logs
WITH (
  format = 'PARQUET',
  external_location = 's3://bucket/optimized/',
  partitioned_by = ARRAY['year', 'month'],
  bucketed_by = ARRAY['user_id'],
  bucket_count = 10
)
AS SELECT
  user_id, event_type, timestamp,
  year(timestamp) as year,
  month(timestamp) as month
FROM raw_logs;
```

### Federated Query

Query data sources beyond S3:

```
Athena ──── Lambda Connector ────▶ DynamoDB
       ──── Lambda Connector ────▶ RDS/Aurora
       ──── Lambda Connector ────▶ Redshift
       ──── Lambda Connector ────▶ CloudWatch Logs
       ──── Lambda Connector ────▶ HBase (EMR)
       ──── Lambda Connector ────▶ Custom data source
```

### ACID Transactions with Apache Iceberg

Athena supports Apache Iceberg tables for:
- ACID transactions (INSERT, UPDATE, DELETE, MERGE)
- Time travel queries
- Schema evolution
- Hidden partitioning (no need to manage partition columns)
- Compaction

```sql
CREATE TABLE iceberg_orders (
  order_id BIGINT,
  customer_id BIGINT,
  amount DOUBLE,
  order_date DATE
)
LOCATION 's3://bucket/iceberg/orders/'
TBLPROPERTIES ('table_type' = 'ICEBERG');

-- ACID operations
INSERT INTO iceberg_orders VALUES (1, 100, 99.99, DATE '2026-04-16');
UPDATE iceberg_orders SET amount = 109.99 WHERE order_id = 1;
DELETE FROM iceberg_orders WHERE order_id = 1;

-- Time travel
SELECT * FROM iceberg_orders FOR TIMESTAMP AS OF TIMESTAMP '2026-04-15 00:00:00';
```

> **Exam Tip:** Athena cost optimization = Parquet/ORC + partitioning + compression + optimal file sizes. If the question says "reduce query costs on S3 data," these are the answers. Athena Iceberg = when you need UPDATE/DELETE on S3 data.

---

## 7. AWS Glue

### Deep Dive Components

*(Expanding beyond the integration article)*

### ETL Job Types

| Type | Engine | Use Case |
|------|--------|----------|
| **Spark** | Apache Spark (PySpark/Scala) | Large-scale ETL, complex transformations |
| **Python Shell** | Python 3 | Small datasets, simple scripts, API calls |
| **Ray** | Ray (distributed Python) | ML preprocessing, distributed Python |
| **Streaming** | Spark Structured Streaming | Real-time ETL from Kinesis/Kafka |

### Dynamic Frames

Glue's extension to Spark DataFrames — handles schema inconsistencies in semi-structured data:

```python
from awsglue.context import GlueContext
from awsglue.dynamicframe import DynamicFrame

glueContext = GlueContext(SparkContext.getOrCreate())

# Read from Data Catalog
datasource = glueContext.create_dynamic_frame.from_catalog(
    database="sales_db",
    table_name="raw_orders"
)

# ResolveChoice — handle type ambiguities
resolved = datasource.resolveChoice(
    choice="make_cols",
    specs=[("amount", "cast:double")]
)

# Relationalize — flatten nested structures
flattened = resolved.relationalize(
    root_table_name="orders",
    staging_path="s3://temp-bucket/staging/"
)

# Write to S3 as Parquet
glueContext.write_dynamic_frame.from_options(
    frame=resolved,
    connection_type="s3",
    connection_options={"path": "s3://output-bucket/orders/"},
    format="parquet"
)
```

### Job Bookmarks

Track processed data to avoid reprocessing:

```
Run 1: Process s3://bucket/data/file1.csv, file2.csv
  → Bookmark: {last_file: "file2.csv", last_timestamp: "2026-04-15T10:00:00"}

Run 2: Process s3://bucket/data/file3.csv (only new files)
  → Bookmark: {last_file: "file3.csv", last_timestamp: "2026-04-16T10:00:00"}
```

Supports S3 (new files) and JDBC (new rows based on bookmark keys).

### Glue Data Quality

Define and enforce data quality rules:

```python
# DQDL (Data Quality Definition Language)
rules = """
Rules = [
  RowCount between 1000 and 1000000,
  Completeness "customer_id" > 0.99,
  Uniqueness "order_id" > 0.99,
  ColumnValues "amount" > 0,
  ColumnValues "order_date" matches "\\d{4}-\\d{2}-\\d{2}",
  DataFreshness "order_date" <= 1 days
]
"""
```

### Glue Studio

Visual ETL authoring:
- Drag-and-drop ETL job creation
- Visual DAG editor
- Built-in transforms (filter, join, aggregate, custom SQL)
- Auto-generates PySpark code
- Job monitoring and debugging

> **Exam Tip:** Glue = serverless ETL + Data Catalog. Bookmarks = incremental processing. Dynamic Frames = handle messy semi-structured data. Data Catalog = central metastore for the entire analytics ecosystem.

---

## 8. Amazon EMR

### Architecture

```
┌──────────────────────────────────────────────────────────────┐
│  EMR Cluster                                                  │
│                                                               │
│  ┌──────────────┐                                             │
│  │ Master Node  │  (NameNode, ResourceManager, Hive, Presto)  │
│  └──────┬───────┘                                             │
│         │                                                     │
│  ┌──────┼──────────────────────────────────────┐              │
│  │      ▼              ▼              ▼        │              │
│  │ ┌──────────┐  ┌──────────┐  ┌──────────┐   │              │
│  │ │ Core     │  │ Core     │  │ Core     │   │              │
│  │ │ Node     │  │ Node     │  │ Node     │   │              │
│  │ │ (HDFS +  │  │ (HDFS +  │  │ (HDFS +  │   │              │
│  │ │  compute)│  │  compute)│  │  compute)│   │              │
│  │ └──────────┘  └──────────┘  └──────────┘   │              │
│  │  Core Node Group (always On-Demand)         │              │
│  └─────────────────────────────────────────────┘              │
│                                                               │
│  ┌─────────────────────────────────────────────┐              │
│  │ ┌──────────┐  ┌──────────┐  ┌──────────┐   │              │
│  │ │ Task     │  │ Task     │  │ Task     │   │              │
│  │ │ Node     │  │ Node     │  │ Node     │   │              │
│  │ │ (compute │  │ (compute │  │ (compute │   │              │
│  │ │  only)   │  │  only)   │  │  only)   │   │              │
│  │ └──────────┘  └──────────┘  └──────────┘   │              │
│  │  Task Node Group (Spot recommended)          │              │
│  └─────────────────────────────────────────────┘              │
└──────────────────────────────────────────────────────────────┘
```

### HDFS vs EMRFS

| Feature | HDFS | EMRFS (S3) |
|---------|------|-----------|
| **Storage** | Local to cluster nodes | Amazon S3 |
| **Persistence** | Lost when cluster terminates | Persistent |
| **Performance** | Lower latency (local) | Higher latency, but highly scalable |
| **Cost** | Pay for EC2 storage 24/7 | Pay for S3 storage (cheaper) |
| **Decoupling** | Compute + storage coupled | Compute and storage independent |
| **Best Practice** | Intermediate/temp data | Long-term data, input/output |

**Best practice:** Use EMRFS (S3) for input/output data and HDFS for intermediate shuffle data. This allows transient clusters.

### Instance Groups vs Instance Fleets

| Feature | Instance Groups | Instance Fleets |
|---------|----------------|----------------|
| **Instance types** | One type per group | Multiple types per fleet (up to 30) |
| **Spot strategy** | Single price | Allocation strategy (capacity-optimized, price-capacity-optimized) |
| **On-Demand + Spot** | Separate groups | Mixed within a fleet |
| **Use case** | Simple, predictable | Cost optimization, Spot flexibility |

### Spot Instance Best Practices for EMR

1. **Master node:** Always On-Demand (cluster fails if master is terminated)
2. **Core nodes:** On-Demand recommended (they store HDFS data) or use EMRFS to make them Spot-safe
3. **Task nodes:** Spot instances (compute only, no data loss if terminated)
4. **Instance fleets:** Use capacity-optimized allocation strategy
5. **Multiple instance types:** Diversify across AZs and types for Spot availability

### EMR Auto Scaling

| Type | Description |
|------|------------|
| **Managed Scaling** | EMR automatically scales based on workload metrics (recommended) |
| **Custom Auto Scaling** | CloudWatch metrics + scaling policies (legacy) |

Managed scaling parameters:
- **MinimumCapacityUnits**: Minimum cluster size
- **MaximumCapacityUnits**: Maximum cluster size
- **MaximumOnDemandCapacityUnits**: Cap on On-Demand (rest is Spot)
- **MaximumCoreCapacityUnits**: Cap on core nodes (rest are task nodes)

### EMR Serverless

Run Spark and Hive without managing clusters:

```
Submit Job → EMR Serverless → Auto-provisions workers → Job completes → Resources released
```

- Pay for vCPU and memory used during job execution
- Pre-initialized workers for faster startup
- No cluster management, patching, or sizing

### EMR on EKS

Run EMR workloads on Amazon EKS clusters:

```
┌────────────────────────────────┐
│  EKS Cluster                   │
│                                │
│  ┌─────────────┐  ┌──────────┐│
│  │ EMR Virtual │  │ Other K8s││
│  │ Cluster     │  │ Workloads││
│  │ (Spark)     │  │          ││
│  └─────────────┘  └──────────┘│
└────────────────────────────────┘
```

Benefits: share EKS infrastructure, Kubernetes-native scheduling, consolidate compute.

### EMR Studio

Jupyter-based IDE for data scientists and engineers:
- Collaborative notebooks
- Connect to EMR clusters or EMR Serverless
- Git integration
- Integrated with AWS SSO

> **Exam Tip:** EMR = Hadoop/Spark ecosystem (when you need Spark, Hive, Presto, HBase, Flink). EMRFS = decouple compute from storage (use S3). Transient clusters = process then terminate. EMR Serverless = simplest option for Spark/Hive jobs.

---

## 9. AWS Lake Formation

### Architecture

```
┌──────────────────────────────────────────────────────────────┐
│                   AWS Lake Formation                          │
│                                                               │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────────┐    │
│  │ Data Import  │  │ Glue Data    │  │ Access Control    │    │
│  │ (Blueprints) │  │ Catalog      │  │ (Fine-Grained)   │    │
│  │              │  │ (central     │  │                   │    │
│  │ S3, RDS,     │  │  metadata)   │  │ Database-level    │    │
│  │ DynamoDB,    │  │              │  │ Table-level       │    │
│  │ on-premises  │  │              │  │ Column-level      │    │
│  └──────────────┘  └──────────────┘  │ Row-level         │    │
│                                      │ Cell-level        │    │
│                                      │ Tag-based (LF-Tags)│   │
│                                      └──────────────────┘    │
│                                                               │
│  Consumers: Athena, Redshift Spectrum, EMR, Glue ETL          │
└──────────────────────────────────────────────────────────────┘
```

### Fine-Grained Access Control

Lake Formation replaces complex IAM policies with a centralized permission model:

```
BEFORE (S3 + IAM):
- S3 bucket policies per table
- IAM policies per user per table per column
- Glue Data Catalog resource policies
= 100s of policies to manage

AFTER (Lake Formation):
- GRANT SELECT ON TABLE orders TO user_analytics (column: order_id, amount)
- GRANT SELECT ON TABLE orders TO user_finance (all columns)
= Centralized, SQL-like grants
```

### Tag-Based Access Control (LF-Tags)

Assign tags to data lake resources and grant access based on tags:

```
LF-Tag: "classification" = ["public", "confidential", "restricted"]
LF-Tag: "department" = ["finance", "engineering", "hr"]

Resources:
  orders table → classification=confidential, department=finance
  products table → classification=public, department=engineering

Grants:
  Finance team → classification IN (public, confidential) AND department=finance
  Engineering → classification=public
```

Benefits: Scales better than per-resource grants for large data lakes.

### Governed Tables

Tables with automatic data compaction, deduplication, and ACID transactions:
- Built on Apache Iceberg
- Automatic storage optimization
- Row-level locking for concurrent writes

### Cross-Account Access

```
Account A (Data Lake Owner)         Account B (Consumer)
┌───────────────────────────┐       ┌──────────────────────┐
│ Lake Formation            │       │ Athena / EMR          │
│ ┌─────────────────────┐   │       │                      │
│ │ Grant to Account B  │───┼──────▶│ Query shared tables  │
│ │ (table/column level)│   │       │                      │
│ └─────────────────────┘   │       └──────────────────────┘
└───────────────────────────┘
```

Uses RAM (Resource Access Manager) under the hood.

### Data Filters

Row-level and cell-level security:

```sql
-- Row filter: analyst can only see their region's data
CREATE DATA FILTER region_filter
ON TABLE orders
WHERE region = 'us-east'
WITH COLUMN MASK amount TO 'REDACTED' WHEN role != 'finance';
```

> **Exam Tip:** Lake Formation = centralized governance for data lakes. If the question mentions "fine-grained access control across multiple analytics services," "column-level security," or "cross-account data sharing with governance," Lake Formation is the answer.

---

## 10. Amazon QuickSight

### Architecture

```
┌──────────────────────────────────────────────────────────────┐
│  Amazon QuickSight                                            │
│                                                               │
│  ┌──────────────┐     ┌──────────────┐     ┌──────────────┐  │
│  │ Data Sources │────▶│ SPICE Engine │────▶│ Dashboards   │  │
│  │              │     │ (in-memory)  │     │ & Analysis   │  │
│  │ - Athena     │     │              │     │              │  │
│  │ - Redshift   │     │ OR           │     │ Visuals:     │  │
│  │ - RDS/Aurora │     │              │     │ - Charts     │  │
│  │ - S3         │     │ Direct Query │     │ - Pivots     │  │
│  │ - OpenSearch │     │ (live)       │     │ - Maps       │  │
│  │ - Presto     │     │              │     │ - KPIs       │  │
│  │ - Timestream │     └──────────────┘     │ - ML Insights│  │
│  │ - SaaS       │                          └──────────────┘  │
│  └──────────────┘                                            │
└──────────────────────────────────────────────────────────────┘
```

### SPICE (Super-fast, Parallel, In-memory Calculation Engine)

- In-memory columnar storage
- Auto-refreshes data on schedule or on demand
- 10 GB per user (Standard), 500 GB per user (Enterprise)
- Massively faster than direct query for dashboards

### ML Insights

Built-in ML capabilities:
- **Anomaly detection** — detect unusual data points
- **Forecasting** — time-series predictions
- **Auto-narratives** — natural language summaries of data
- **Q** — natural language querying ("What were total sales last month?")

### Row-Level Security (RLS)

Control which rows users can see:

```
┌────────────────────────────────────────────────┐
│ Dataset: orders                                 │
│                                                 │
│ RLS Rules:                                      │
│ ┌──────────┬──────────────┬──────────────────┐  │
│ │ User     │ Column       │ Value            │  │
│ ├──────────┼──────────────┼──────────────────┤  │
│ │ alice    │ region       │ us-east          │  │
│ │ bob      │ region       │ eu-west          │  │
│ │ charlie  │ region       │ *  (all regions) │  │
│ └──────────┴──────────────┴──────────────────┘  │
└────────────────────────────────────────────────┘
```

### Column-Level Security (CLS)

Restrict which columns users can see in a dataset.

### Embedded Analytics

Embed QuickSight dashboards in your own applications:

```
Your Web App → QuickSight Embedding SDK → Embedded Dashboard (iframe)
                   │
                   ├── Anonymous embedding (public)
                   ├── Registered user embedding
                   └── Session-based embedding
```

> **Exam Tip:** QuickSight = serverless BI / visualization. SPICE = in-memory for fast dashboards. If the question mentions "dashboards," "business intelligence," or "visualize data from Athena/Redshift," QuickSight is the answer. Row-level security for multi-tenant dashboards.

---

## 11. Amazon MSK

*(Covered in detail in the Application Integration article — key analytics aspects below)*

### MSK for Analytics

MSK is commonly used as the **ingestion layer** in analytics pipelines:

```
Producers           MSK Cluster              Consumers
┌──────────┐       ┌──────────────┐         ┌──────────────┐
│ App Logs │──────▶│              │────────▶│ Kinesis      │
│ IoT Data │       │  Topic:      │         │ Firehose→S3  │
│ Click    │       │  events      │         ├──────────────┤
│ stream   │       │              │────────▶│ Spark on     │
└──────────┘       │  Topic:      │         │ EMR          │
                   │  metrics     │         ├──────────────┤
                   │              │────────▶│ Lambda       │
                   └──────────────┘         ├──────────────┤
                                            │ Flink on     │
                                            │ Managed      │
                                            │ Apache Flink │
                                            └──────────────┘
```

### MSK vs Kinesis for Analytics

| Scenario | Recommendation |
|----------|---------------|
| Existing Kafka ecosystem/skills | MSK |
| Simplest managed streaming | Kinesis |
| Need Kafka Connect connectors | MSK |
| Sub-second Lambda processing | Kinesis (Lambda event source mapping) |
| Open-source flexibility | MSK |
| AWS-native integration | Kinesis |

---

## 12. Data Lake Architecture Patterns

### Zones Architecture

```
┌──────────────────────────────────────────────────────────────────┐
│  S3 Data Lake                                                     │
│                                                                   │
│  ┌────────────────┐  ┌────────────────┐  ┌────────────────────┐  │
│  │  RAW / LANDING │  │  PROCESSED /   │  │  CURATED /         │  │
│  │  ZONE          │  │  CLEANSED ZONE │  │  CONSUMPTION ZONE  │  │
│  │                │  │                │  │                    │  │
│  │  s3://lake/    │  │  s3://lake/    │  │  s3://lake/        │  │
│  │  raw/          │  │  processed/    │  │  curated/          │  │
│  │                │  │                │  │                    │  │
│  │  - Original    │──│  - Cleaned     │──│  - Aggregated      │  │
│  │    format      │  │  - Deduplicated│  │  - Business-ready  │  │
│  │  - CSV, JSON,  │  │  - Validated   │  │  - Parquet format  │  │
│  │    XML, logs   │  │  - Parquet     │  │  - Partitioned     │  │
│  │  - Partitioned │  │  - Partitioned │  │  - Optimized for   │  │
│  │    by date     │  │  - Schema      │  │    query patterns  │  │
│  │                │  │    enforced    │  │                    │  │
│  └────────────────┘  └────────────────┘  └────────────────────┘  │
│         ▲                   ▲                     ▲               │
│         │                   │                     │               │
│    Ingest:             Transform:            Consume:             │
│    Firehose,           Glue ETL,             Athena,              │
│    DMS, AppFlow,       EMR, Lambda           Redshift Spectrum,   │
│    S3 Transfer                               QuickSight, ML      │
└──────────────────────────────────────────────────────────────────┘
```

### S3 Organization Best Practices

```
s3://company-data-lake/
├── raw/
│   ├── source=salesforce/
│   │   └── year=2026/month=04/day=16/
│   │       ├── part-0001.json
│   │       └── part-0002.json
│   ├── source=app-logs/
│   │   └── year=2026/month=04/day=16/hour=14/
│   │       ├── logs-0001.gz
│   │       └── logs-0002.gz
│   └── source=iot-sensors/
│       └── device_type=temperature/region=us-east/
│           └── year=2026/month=04/
├── processed/
│   ├── domain=orders/
│   │   └── year=2026/month=04/
│   │       ├── part-00001.snappy.parquet
│   │       └── part-00002.snappy.parquet
│   └── domain=customers/
│       └── snapshot_date=2026-04-16/
├── curated/
│   ├── domain=sales-analytics/
│   │   └── aggregation=daily/region=us-east/
│   └── domain=customer-360/
└── sandbox/
    └── user=analyst-alice/
```

### Metadata Management

```
┌──────────────────────────────────────────────────┐
│  Glue Data Catalog (central metadata store)       │
│                                                   │
│  ┌──────────────┐                                 │
│  │ Crawlers     │──── Auto-discover schema        │
│  └──────────────┘                                 │
│                                                   │
│  Databases:                                       │
│  ├── raw_db                                       │
│  │   ├── salesforce_contacts (CSV, s3://raw/...)  │
│  │   └── app_logs (JSON, s3://raw/...)            │
│  ├── processed_db                                 │
│  │   ├── orders (Parquet, s3://processed/...)     │
│  │   └── customers (Parquet, s3://processed/...)  │
│  └── curated_db                                   │
│      └── daily_sales (Parquet, s3://curated/...)  │
│                                                   │
│  Used by: Athena, Redshift Spectrum, EMR,         │
│           Lake Formation, Glue ETL                 │
└──────────────────────────────────────────────────┘
```

### Governance with Lake Formation

```
Data Steward → Lake Formation → Define who can access what data
                                  │
                     ┌────────────┼────────────┐
                     ▼            ▼            ▼
              Finance team:  Data Science:  Marketing:
              orders (all    orders         customers
              columns)       (column subset) (aggregated only)
```

---

## 13. Real-Time vs Batch vs Near-Real-Time Processing

### Comparison

| Aspect | Real-Time | Near-Real-Time | Batch |
|--------|-----------|---------------|-------|
| **Latency** | Milliseconds | Seconds to minutes | Minutes to hours |
| **Data freshness** | Current | Recent | Historical |
| **Processing model** | Stream | Micro-batch | Batch job |
| **Cost** | Higher (always running) | Medium | Lower (run on schedule) |
| **Complexity** | Higher (ordering, dedup) | Medium | Lower |

### AWS Service Mapping

| Pattern | Service Stack | Example Use Case |
|---------|--------------|-----------------|
| **Real-time** | Kinesis Data Streams → Lambda → DynamoDB | Fraud detection, real-time recommendations |
| **Real-time** | MSK → Flink → OpenSearch | Live dashboards, alerting |
| **Near-real-time** | Kinesis Firehose → S3 → Athena | Log analytics (1-minute delay acceptable) |
| **Near-real-time** | DynamoDB Streams → Lambda → OpenSearch | Search index sync |
| **Batch** | S3 → Glue ETL → Redshift | Nightly ETL, reporting |
| **Batch** | S3 → EMR (Spark) → S3 → Athena | ML feature engineering, large transformations |
| **Hybrid** | Kinesis → Firehose → S3 (near-RT) + Lambda (RT) | Dual processing: alerts in real-time, analytics in batch |

### Lambda Architecture (Exam Pattern)

```
┌───────────┐
│ Data      │──┬──▶ Speed Layer (real-time)
│ Source    │  │    Kinesis → Lambda → DynamoDB
│           │  │    (approximate, fast)
│           │  │
│           │  └──▶ Batch Layer (batch)
│           │       S3 → Glue/EMR → Redshift
│           │       (accurate, slow)
└───────────┘
                    Serving Layer merges both:
                    Query hot data from speed layer
                    Query historical from batch layer
```

### Kappa Architecture (Simplified)

```
┌───────────┐
│ Data      │──────▶ Stream Processing Layer
│ Source    │        Kinesis/MSK → Flink/Lambda
│           │        (single pipeline for both real-time and reprocessing)
│           │
│           │        Reprocess: replay stream from retention
└───────────┘
```

> **Exam Tip:** Lambda architecture = separate batch and speed layers (more complex, more accurate batch). Kappa = single stream layer (simpler, replay for reprocessing). Most exam answers lean toward simpler architectures unless specifically stated otherwise.

---

## 14. Exam Scenarios

### Scenario 1: Log Analytics Pipeline

**Question:** A company generates 10 TB of application logs daily. They need to query logs interactively within minutes of generation. They also need a 90-day searchable archive with dashboards. Budget is a concern.

**Answer:**
- **Ingest:** Kinesis Data Firehose (auto-scales, buffer to S3)
- **Transform:** Firehose Lambda transform to convert JSON → Parquet
- **Store:** S3 with partitioning by date/hour
- **Real-time search:** OpenSearch with UltraWarm for older data
- **Interactive query:** Athena on S3 (Parquet, partitioned)
- **Dashboards:** QuickSight (connected to Athena/OpenSearch)
- **Cost optimization:** Firehose dynamic partitioning, S3 lifecycle to Glacier after 90 days, OpenSearch cold storage

---

### Scenario 2: Data Warehouse Migration

**Question:** A company wants to migrate a 50 TB on-premises Oracle data warehouse to AWS. They need complex SQL analytics, BI dashboards, and the ability to query both warehouse data and a growing S3 data lake.

**Answer:**
- **Warehouse:** Amazon Redshift (RA3 nodes for managed storage)
- **Migration:** AWS SCT (Schema Conversion Tool) + DMS for data migration
- **S3 queries:** Redshift Spectrum (query S3 without loading)
- **Distribution:** KEY on most common join columns, ALL for small dimension tables
- **Sort:** Compound sort key on date columns for time-series queries
- **BI:** QuickSight with SPICE for dashboard performance
- **Concurrency:** Concurrency Scaling for peak query loads

---

### Scenario 3: Real-Time Fraud Detection

**Question:** A financial services company needs to analyze transactions in real-time (< 500ms) to detect fraud patterns. They process 100,000 transactions per second. Flagged transactions need immediate blocking and analyst review.

**Answer:**
- **Ingest:** Kinesis Data Streams (provisioned mode, 100+ shards for throughput)
- **Process:** Lambda with enhanced fan-out (dedicated 2 MB/s per consumer, ~70ms latency)
- **ML:** SageMaker real-time endpoint for fraud scoring
- **Alert:** If fraud score > threshold → SNS → block transaction + Lambda → DynamoDB (case record)
- **Analytics:** Second consumer → Firehose → S3 → Athena (post-hoc analysis)
- **Dashboard:** QuickSight for fraud metrics

---

### Scenario 4: Multi-Account Data Lake

**Question:** A large enterprise has 50 AWS accounts. Each account generates data that should be centralized in a data lake. Different teams need different access levels (some see all columns, some see only aggregated data). Cross-account data sharing is required.

**Answer:**
- **Central data lake:** S3 in a dedicated account
- **Ingestion:** Each account uses Firehose/Glue to write to central S3 (cross-account IAM roles)
- **Metadata:** Glue Data Catalog in central account
- **Governance:** AWS Lake Formation
  - LF-Tags for classification-based access
  - Column-level security for sensitive data
  - Cross-account sharing via RAM
  - Row-level filtering for multi-tenant data
- **Consumption:** Athena, Redshift Spectrum (all accounts query via Lake Formation grants)

---

### Scenario 5: IoT Data Pipeline

**Question:** An IoT platform has 1 million devices sending telemetry every 5 seconds. Data needs real-time alerting (device anomalies), near-real-time dashboards (5-minute aggregations), and batch analytics (daily reports). Total data is 5 TB/day.

**Answer:**
- **Ingest:** IoT Core → IoT Rules → Kinesis Data Streams
- **Real-time:** Kinesis → Lambda (anomaly detection) → SNS (alerts)
- **Near-real-time:** Kinesis → Firehose (5-minute buffer) → S3 (Parquet, partitioned by device_type/date/hour) → OpenSearch (dashboards)
- **Batch:** S3 raw → Glue ETL (daily job, bookmarks) → S3 curated → Athena → QuickSight
- **Cost:** Firehose for S3 delivery (cheapest path), Spot instances for EMR if needed, S3 lifecycle policies

---

### Scenario 6: Data Format Optimization

**Question:** An Athena query scanning a 10 TB dataset of JSON files costs $50 per query. How do you reduce cost by 90%?

**Answer:**
1. **Convert JSON → Parquet** (columnar, 75% smaller, Athena only reads needed columns)
2. **Partition** by date/region (only scan relevant partitions)
3. **Compress** with Snappy (further size reduction)
4. **Optimize file size** to 128-512 MB (reduce overhead)
5. **Use CTAS** to create optimized tables from raw data

Result: ~95% cost reduction (Parquet is 5-10x smaller than JSON + partition pruning eliminates most scans).

---

### Key Exam Tips Summary

| Topic | Key Point |
|-------|-----------|
| Kinesis Data Streams | Real-time, per-shard capacity, enhanced fan-out for multi-consumer |
| Kinesis Firehose | Near-real-time delivery to S3/Redshift/OpenSearch. Buffer size/time. |
| OpenSearch | Log analytics + search. Hot/UltraWarm/Cold tiers for cost. |
| Redshift | Data warehouse. KEY dist=co-locate joins. Spectrum=query S3. RA3=managed storage. |
| Athena | Serverless SQL on S3. Parquet + partitioning + compression = cost optimization. |
| Glue | ETL + Data Catalog (central metastore). Bookmarks for incremental. |
| EMR | Hadoop/Spark ecosystem. EMRFS=S3 (decouple compute). Spot for task nodes. |
| Lake Formation | Centralized data lake governance. Fine-grained access (column, row, tag-based). |
| QuickSight | Serverless BI. SPICE for performance. RLS for multi-tenant. |
| Data Lake Zones | Raw → Processed → Curated. Parquet for processed/curated. |
| Real-time vs Batch | Real-time = Kinesis+Lambda. Near-RT = Firehose. Batch = Glue/EMR. |
| Cost optimization | Columnar format (Parquet/ORC) + partitioning + compression = biggest wins |

---

*End of Article 08 — Analytics & Big Data*
