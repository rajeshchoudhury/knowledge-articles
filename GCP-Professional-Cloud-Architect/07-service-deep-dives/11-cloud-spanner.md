# Service Deep Dive — Cloud Spanner

## Overview
- Horizontally scalable, strongly consistent relational DB.
- **TrueTime** provides external consistency (linearizable).
- GoogleSQL or PostgreSQL dialect.

## Architecture
- Instance (config + nodes/PUs) → databases → tables.
- **Config**: regional (e.g., `regional-us-central1`) or multi-region (`nam3`, `nam6`, `nam-eur-asia1`, `eur3`).
- **Nodes** or **Processing Units** (100 PU = 1 node).
- Compute decoupled from storage; resize online.
- Replicas: 3 per region (regional); multi-region = additional read-only replicas + 2 witness replicas.

## SLA
- Regional: 99.99%.
- Multi-region: 99.999%.

## Throughput
- ~10K QPS/node read, ~2K QPS/node write (typical).
- Data size ~10 TB/node recommended.

## Schema design
- **Interleaved tables** group child with parent for locality.
- Avoid hot keys (monotonic PKs). Use UUID or hashed timestamp.
- **Secondary indexes** with **STORING** to avoid extra fetch.
- **Foreign keys** supported (within same DB).
- Schema changes online (columns, tables, indexes).

## Features
- **Change streams** for CDC → BigQuery / Pub/Sub.
- **Backups** (same/cross-region) + PITR (7d).
- **Data Boost**: serverless compute for federated queries without OLTP impact.
- **Spanner Graph**, **Full-text search**, **Vector search** (recent).
- **Dataflow / Beam connectors**.

## Security
- CMEK.
- Private Service Connect / VPC-SC.
- IAM fine-grained per database.

## Exam cues
- Pick Spanner when:
  - Global strong consistency needed (finance, inventory).
  - Workload exceeds Cloud SQL scale.
  - Need 99.999% SLA.
- Avoid when:
  - Workload small / cost-sensitive (consider Cloud SQL).
  - Need full PG extensions / oracle-specific features.
