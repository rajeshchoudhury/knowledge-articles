# Database Migration — AWS SAP-C02 Domain 3 Deep Dive

## Table of Contents
1. [Homogeneous vs Heterogeneous Migration](#1-homogeneous-vs-heterogeneous-migration)
2. [DMS Replication Instance Sizing](#2-dms-replication-instance-sizing)
3. [DMS Endpoints and Connections](#3-dms-endpoints-and-connections)
4. [Migration Types: Full Load vs CDC](#4-migration-types-full-load-vs-cdc)
5. [DMS Table Mappings](#5-dms-table-mappings)
6. [SCT Conversion Assessment Reports](#6-sct-conversion-assessment-reports)
7. [Oracle to Aurora PostgreSQL Migration](#7-oracle-to-aurora-postgresql-migration)
8. [SQL Server to Aurora MySQL Migration](#8-sql-server-to-aurora-mysql-migration)
9. [Oracle to DynamoDB Migration](#9-oracle-to-dynamodb-migration)
10. [MongoDB to DocumentDB Migration](#10-mongodb-to-documentdb-migration)
11. [Cassandra to Keyspaces Migration](#11-cassandra-to-keyspaces-migration)
12. [Mainframe DB to RDS Patterns](#12-mainframe-db-to-rds-patterns)
13. [Large Database Migration Strategies](#13-large-database-migration-strategies)
14. [Data Validation During Migration](#14-data-validation-during-migration)
15. [Minimal Downtime Migration Patterns](#15-minimal-downtime-migration-patterns)
16. [Blue-Green Database Migration](#16-blue-green-database-migration)
17. [Database Migration Testing Strategies](#17-database-migration-testing-strategies)
18. [Post-Migration Optimization](#18-post-migration-optimization)
19. [Exam Scenarios](#19-exam-scenarios)

---

## 1. Homogeneous vs Heterogeneous Migration

### 1.1 Homogeneous Migration (Same Engine)

**Definition:** Source and target databases use the same engine (e.g., MySQL → Aurora MySQL, Oracle → Oracle on RDS).

```
Homogeneous Migration:
┌──────────────┐         DMS          ┌──────────────┐
│ MySQL 8.0    │────────────────────▶  │ Aurora MySQL │
│ (on-premises)│    Full Load + CDC   │ (AWS)        │
└──────────────┘                      └──────────────┘

No SCT needed — schema is compatible
Native tools can also be used (mysqldump, pg_dump, Data Pump)
```

**Advantages:**
- No schema conversion required
- Can use native database tools as alternative
- Lower risk — same data types, SQL syntax
- DMS handles data transfer efficiently

**Native Tools Option:**

| Engine | Native Tool | Use Case |
|---|---|---|
| MySQL | `mysqldump` + `mysql` | Small databases (<10 GB) |
| MySQL | Percona XtraBackup | Large databases, minimal downtime |
| PostgreSQL | `pg_dump` + `pg_restore` | Small-medium databases |
| PostgreSQL | Logical replication | Minimal downtime, ongoing sync |
| Oracle | Data Pump (`expdp/impdp`) | Full export/import |
| Oracle | RMAN + Data Guard | Large databases, minimal downtime |
| SQL Server | Backup/Restore | Full database backup to S3 → restore |
| SQL Server | Log shipping | Minimal downtime |

### 1.2 Heterogeneous Migration (Different Engine)

**Definition:** Source and target databases use different engines (e.g., Oracle → Aurora PostgreSQL, SQL Server → Aurora MySQL).

```
Heterogeneous Migration:
                    Step 1: SCT                      Step 2: DMS
┌──────────────┐  ┌──────────────┐              ┌──────────────┐
│ Oracle       │  │ Convert      │              │ Aurora       │
│ (on-premises)│─▶│ Schema       │─▶ Apply ────▶│ PostgreSQL   │
│              │  │ (SCT tool)   │   Schema     │ (AWS)        │
└──────┬───────┘  └──────────────┘              └──────▲───────┘
       │                                                │
       └──────────── DMS (Data Migration) ─────────────┘
                   Full Load + CDC
```

**Required Steps:**
1. **SCT:** Convert schema (tables, views, stored procedures, functions, triggers)
2. **Manual:** Fix items SCT couldn't convert automatically
3. **SCT:** Apply converted schema to target database
4. **DMS:** Migrate data (Full Load + CDC for minimal downtime)
5. **Validate:** Compare source and target data
6. **Cutover:** Switch application connections

### 1.3 Comparison Table

| Aspect | Homogeneous | Heterogeneous |
|---|---|---|
| Schema Conversion | Not needed | SCT required |
| Data Types | Compatible | May need mapping |
| Stored Procedures | Compatible | Must be converted |
| SQL Syntax | Same | Different dialects |
| Risk Level | Low | Medium-High |
| Timeline | Shorter | Longer |
| Testing Effort | Lower | Higher |
| Tool Chain | DMS (or native) | SCT + DMS |

---

## 2. DMS Replication Instance Sizing

### 2.1 Instance Classes

| Instance Class | vCPUs | Memory | Network | Use Case |
|---|---|---|---|---|
| dms.t3.micro | 2 | 1 GB | Low | Testing only |
| dms.t3.medium | 2 | 4 GB | Moderate | Small DBs (<50 GB) |
| dms.t3.large | 2 | 8 GB | Moderate | Small-medium DBs |
| dms.r5.large | 2 | 16 GB | Up to 10 Gbps | Production (<1 TB) |
| dms.r5.xlarge | 4 | 32 GB | Up to 10 Gbps | Production (1-5 TB) |
| dms.r5.2xlarge | 8 | 64 GB | Up to 10 Gbps | Large DBs (5-10 TB) |
| dms.r5.4xlarge | 16 | 128 GB | Up to 10 Gbps | Very large DBs |
| dms.r5.8xlarge | 32 | 256 GB | 10 Gbps | Massive DBs, high CDC |
| dms.r5.12xlarge | 48 | 384 GB | 10 Gbps | Maximum throughput |
| dms.r5.16xlarge | 64 | 512 GB | 20 Gbps | Maximum scale |
| dms.r5.24xlarge | 96 | 768 GB | 25 Gbps | Maximum scale |

### 2.2 Sizing Guidelines

**Factors Affecting Size:**
1. **Database size:** Larger databases need more memory for caching
2. **Number of tables:** More tables = more parallel threads needed
3. **LOB (Large Object) columns:** Require significantly more memory
4. **CDC throughput:** High transaction rate needs more CPU/memory
5. **Number of tasks:** Each task consumes resources

**Sizing Formula (Rule of Thumb):**
```
Memory needed ≈ Database size × 0.01 + (LOB tables × 0.5 GB) + 4 GB base

Examples:
- 100 GB DB, no LOBs: ~5 GB → dms.r5.large (16 GB)
- 1 TB DB, 10 LOB tables: ~15 GB → dms.r5.xlarge (32 GB)
- 5 TB DB, 50 LOB tables: ~54 GB → dms.r5.2xlarge (64 GB)
- 20 TB DB, 100 LOB tables: ~254 GB → dms.r5.8xlarge (256 GB)
```

### 2.3 Storage Allocation

- DMS replication instance needs EBS storage for logs and cached changes
- **Minimum:** 50 GB
- **For CDC:** Allocate 50-100 GB for change caching
- **For Full Load:** Allocate storage ≈ largest table size × 1.5
- Auto-expand is NOT supported — provision enough upfront

### 2.4 Multi-AZ Considerations

```
Primary AZ (us-east-1a)           Standby AZ (us-east-1b)
┌──────────────────────┐         ┌──────────────────────┐
│  DMS Replication     │         │  DMS Replication     │
│  Instance (Active)   │◄───────▶│  Instance (Standby)  │
│                      │  Sync   │                      │
│  ┌────────┐          │         │  ┌────────┐          │
│  │ Task 1 │          │         │  │ (Ready) │          │
│  │ Task 2 │          │         │  │         │          │
│  └────────┘          │         │  └────────┘          │
└──────────────────────┘         └──────────────────────┘

Failover: Automatic, tasks resume from last checkpoint
Downtime: Brief (seconds to minutes)
```

> **Exam Tip:** Always recommend Multi-AZ DMS for production migrations. For large databases, size the replication instance generously — under-provisioning causes migration failures.

---

## 3. DMS Endpoints and Connections

### 3.1 Endpoint Configuration

**Source Endpoint:**
```json
{
  "EndpointIdentifier": "oracle-source",
  "EndpointType": "source",
  "EngineName": "oracle",
  "ServerName": "oracle.onprem.company.com",
  "Port": 1521,
  "Username": "dms_user",
  "Password": "***",
  "DatabaseName": "ORCL",
  "SslMode": "require",
  "ExtraConnectionAttributes": "addSupplementalLogging=Y"
}
```

**Target Endpoint:**
```json
{
  "EndpointIdentifier": "aurora-pg-target",
  "EndpointType": "target",
  "EngineName": "aurora-postgresql",
  "ServerName": "mydb.cluster-abc123.us-east-1.rds.amazonaws.com",
  "Port": 5432,
  "Username": "dms_user",
  "Password": "***",
  "DatabaseName": "mydb",
  "SslMode": "require"
}
```

### 3.2 Network Connectivity

```
Scenario 1: Source on-premises, DMS + Target in AWS VPC
┌─────────────────┐      VPN / Direct Connect      ┌─────────────────────┐
│  Source DB       │◄──────────────────────────────▶│  VPC                 │
│  (on-premises)   │                                │  ┌─────────────────┐│
│  Port: 1521      │                                │  │ DMS Replication ││
│                  │                                │  │ Instance        ││
└─────────────────┘                                │  └────────┬────────┘│
                                                    │           │         │
                                                    │  ┌────────▼────────┐│
                                                    │  │ Aurora Target   ││
                                                    │  │ (same VPC)     ││
                                                    │  └─────────────────┘│
                                                    └─────────────────────┘

Scenario 2: Source in different VPC
- Use VPC peering or Transit Gateway
- Security groups must allow DMS to connect to both source and target

Scenario 3: Source in different AWS account
- Use VPC peering across accounts
- IAM roles for cross-account access
```

### 3.3 SSL/TLS Connections

| Source/Target | SSL Support | Certificate |
|---|---|---|
| Oracle | SSL | Oracle Wallet |
| MySQL | SSL | CA certificate |
| PostgreSQL | SSL | CA certificate |
| SQL Server | SSL | CA certificate |
| Aurora | SSL | RDS CA bundle |
| S3 | HTTPS (default) | N/A |

### 3.4 Extra Connection Attributes

Important attributes by engine:

**Oracle Source:**
```
addSupplementalLogging=Y;          # Required for CDC
useLogMinerReader=N;               # Use Binary Reader instead
useBfile=Y;                        # For LOB columns
readTableSpaceName=Y;              # Include tablespace info
```

**MySQL Source:**
```
afterConnectScript=SET @@session.time_zone='+00:00';  # Normalize timezone
cleanSrcMetadataOnMismatch=true;   # Handle schema changes
```

**PostgreSQL Target:**
```
maxFileSize=1048576;               # Max CSV file size for COPY
```

---

## 4. Migration Types: Full Load vs CDC

### 4.1 Full Load

```
Full Load Process:
┌──────────┐      Read all rows      ┌──────────┐     Write all rows     ┌──────────┐
│  Source   │─────────────────────────▶│   DMS    │──────────────────────▶│  Target  │
│  Tables   │   SELECT * FROM table   │ Instance │   INSERT INTO table   │  Tables  │
└──────────┘                          └──────────┘                       └──────────┘

Timeline:
t=0                                                               t=N hours
├─── Full Load (read + write all data) ──────────────────────────┤
     Application WRITES cause data DRIFT (not captured!)
```

**Characteristics:**
- One-time bulk copy of all data
- **No change capture** — changes during load are missed
- Application must be stopped or read-only during migration
- Downtime = full load duration (hours for large DBs)

**When to Use:**
- Small databases that can be loaded quickly
- Databases with acceptable maintenance windows
- Test/dev environments
- One-time data copies

### 4.2 CDC Only (Change Data Capture)

```
CDC Only Process:
┌──────────┐    Transaction Log      ┌──────────┐     Apply changes     ┌──────────┐
│  Source   │────────────────────────▶│   DMS    │──────────────────────▶│  Target  │
│  (changes │    INSERT/UPDATE/       │ Instance │   INSERT/UPDATE/      │ (pre-    │
│   only)   │    DELETE               │  (CDC)   │   DELETE              │  loaded) │
└──────────┘                         └──────────┘                       └──────────┘

Prerequisite: Target already has initial data (loaded via native tools, S3, etc.)
```

**When to Use:**
- Initial data loaded by faster means (native tools, S3 bulk import)
- Resuming a previously failed migration
- Multiple sources converging to single target

### 4.3 Full Load + CDC (Most Common)

```
Full Load + CDC Process:

Phase 1: Full Load                     Phase 2: CDC (Continuous)
┌──────────┐    ┌──────────┐           ┌──────────┐    ┌──────────┐
│  Source   │───▶│   DMS    │──▶Target  │  Source   │───▶│   DMS    │──▶Target
│  (bulk    │    │ (loading)│           │ (changes)│    │  (CDC)   │
│   copy)   │    └──────────┘           │          │    └──────────┘
└──────────┘                           └──────────┘
                                        
Timeline:
t=0                    t=load done                   t=cutover
├── Full Load ─────────┤── CDC (catch up + ongoing) ─┤── Switch app ──▶
                       │                              │
                       │ CDC backlog catches up       │ Brief pause
                       │ to near real-time            │ Final sync
                       │                              │ DNS switch
                       │                              │
                       └──────────────────────────────┘
                         Application continues writing
                         to source (no downtime yet)

Actual downtime: Only during final cutover (minutes to ~1 hour)
```

**This is the most common migration pattern for minimal downtime.**

### 4.4 Migration Type Comparison

| Aspect | Full Load | CDC Only | Full Load + CDC |
|---|---|---|---|
| Initial Data | Yes | No (pre-loaded) | Yes |
| Ongoing Changes | No | Yes | Yes |
| Downtime | Full load duration | Cutover only | Cutover only |
| Complexity | Low | Medium | Medium |
| Use Case | Small DB, test | Pre-loaded | **Production (primary)** |
| Risk | Data drift | Must pre-load | Low |

---

## 5. DMS Table Mappings

### 5.1 Selection Rules

Define which schemas/tables to include or exclude.

```json
{
  "rules": [
    {
      "rule-type": "selection",
      "rule-id": "1",
      "rule-name": "include-all-sales",
      "object-locator": {
        "schema-name": "sales",
        "table-name": "%"
      },
      "rule-action": "include"
    },
    {
      "rule-type": "selection",
      "rule-id": "2",
      "rule-name": "exclude-temp-tables",
      "object-locator": {
        "schema-name": "sales",
        "table-name": "tmp_%"
      },
      "rule-action": "exclude"
    },
    {
      "rule-type": "selection",
      "rule-id": "3",
      "rule-name": "include-inventory-tables",
      "object-locator": {
        "schema-name": "inventory",
        "table-name": "product%"
      },
      "rule-action": "include",
      "load-order": 2
    }
  ]
}
```

**Wildcards:**
- `%` — matches zero or more characters
- `_` — matches exactly one character
- `\%` — literal percent sign
- `\_` — literal underscore

### 5.2 Transformation Rules

Change schema names, table names, column names, data types during migration.

```json
{
  "rules": [
    {
      "rule-type": "transformation",
      "rule-id": "10",
      "rule-name": "rename-schema",
      "rule-action": "rename",
      "rule-target": "schema",
      "object-locator": {
        "schema-name": "LEGACY_SALES"
      },
      "value": "sales"
    },
    {
      "rule-type": "transformation",
      "rule-id": "11",
      "rule-name": "add-column",
      "rule-action": "add-column",
      "rule-target": "column",
      "object-locator": {
        "schema-name": "sales",
        "table-name": "orders"
      },
      "value": "migration_timestamp",
      "data-type": {
        "type": "datetime",
        "precision": 6
      },
      "expression": "$AR_H_CHANGE_SEQ"
    },
    {
      "rule-type": "transformation",
      "rule-id": "12",
      "rule-name": "remove-column",
      "rule-action": "remove-column",
      "rule-target": "column",
      "object-locator": {
        "schema-name": "sales",
        "table-name": "orders",
        "column-name": "internal_notes"
      }
    },
    {
      "rule-type": "transformation",
      "rule-id": "13",
      "rule-name": "lowercase-all",
      "rule-action": "convert-lowercase",
      "rule-target": "schema",
      "object-locator": {
        "schema-name": "%"
      }
    }
  ]
}
```

**Available Transformation Actions:**
| Action | Target | Description |
|---|---|---|
| `rename` | schema, table, column | Change name |
| `remove-column` | column | Drop column from target |
| `add-column` | column | Add new column to target |
| `convert-lowercase` | schema, table, column | Lowercase names |
| `convert-uppercase` | schema, table, column | Uppercase names |
| `add-prefix` | schema, table, column | Add prefix to name |
| `remove-prefix` | schema, table, column | Remove prefix from name |
| `add-suffix` | schema, table, column | Add suffix to name |
| `remove-suffix` | schema, table, column | Remove suffix from name |
| `define-primary-key` | table | Define PK on target |
| `change-data-type` | column | Convert data type |

---

## 6. SCT Conversion Assessment Reports

### 6.1 Assessment Report Structure

```
┌─────────────────────────────────────────────────────────────┐
│              SCT Assessment Report                           │
├─────────────────────────────────────────────────────────────┤
│ Executive Summary                                            │
│ ├── Total objects: 1,247                                     │
│ ├── Auto-converted: 1,089 (87.3%)                           │
│ ├── Requires modification: 127 (10.2%)                       │
│ └── Cannot convert: 31 (2.5%)                               │
├─────────────────────────────────────────────────────────────┤
│ Conversion by Object Type                                    │
│ ┌─────────────┬───────┬────────┬─────────┬──────────┐      │
│ │ Object Type │ Total │  Auto  │ Partial │ Manual   │      │
│ ├─────────────┼───────┼────────┼─────────┼──────────┤      │
│ │ Tables      │  312  │  312   │    0    │    0     │      │
│ │ Views       │   89  │   82   │    5    │    2     │      │
│ │ Procedures  │  198  │  156   │   32    │   10     │      │
│ │ Functions   │   76  │   61   │   11    │    4     │      │
│ │ Triggers    │   45  │   38   │    5    │    2     │      │
│ │ Packages    │   34  │   12   │   14    │    8     │      │
│ │ Types       │   23  │   18   │    3    │    2     │      │
│ │ Sequences   │   67  │   67   │    0    │    0     │      │
│ │ Synonyms    │  125  │  125   │    0    │    0     │      │
│ │ Indexes     │  278  │  218   │   57    │    3     │      │
│ └─────────────┴───────┴────────┴─────────┴──────────┘      │
├─────────────────────────────────────────────────────────────┤
│ Action Items (Severity)                                      │
│ ├── 🔴 Critical (manual rewrite): 31 items                  │
│ │   ├── Oracle CONNECT BY (hierarchical queries): 8         │
│ │   ├── Oracle TYPE BODY (object types): 5                  │
│ │   ├── Oracle-specific built-in functions: 12              │
│ │   └── DBMS_LOB package usage: 6                           │
│ ├── 🟡 Medium (minor changes): 127 items                    │
│ │   ├── NVL → COALESCE: 45                                  │
│ │   ├── SYSDATE → CURRENT_TIMESTAMP: 23                     │
│ │   ├── ROWNUM → LIMIT/OFFSET: 34                           │
│ │   └── TO_DATE format changes: 25                          │
│ └── 🟢 Auto-converted: 1,089 items                          │
├─────────────────────────────────────────────────────────────┤
│ Estimated Effort: 45 person-days                             │
└─────────────────────────────────────────────────────────────┘
```

### 6.2 Common Conversion Challenges

| Oracle Feature | PostgreSQL Equivalent | Conversion Difficulty |
|---|---|---|
| PL/SQL | PL/pgSQL | Medium (mostly automatic) |
| Packages | Schemas + Functions | Medium (restructure needed) |
| CONNECT BY | Recursive CTEs | High (manual rewrite) |
| ROWNUM | LIMIT/OFFSET | Low (automatic) |
| NVL() | COALESCE() | Low (automatic) |
| SYSDATE | CURRENT_TIMESTAMP | Low (automatic) |
| DECODE() | CASE WHEN | Low (automatic) |
| Oracle sequences | PostgreSQL sequences | Low (automatic) |
| Materialized views | PostgreSQL mat. views | Medium |
| Oracle Text | PostgreSQL full-text search | High |
| Spatial (Oracle Spatial) | PostGIS | Medium |
| Oracle RAC | Aurora Multi-AZ | Architecture change |

---

## 7. Oracle to Aurora PostgreSQL Migration

### 7.1 Migration Architecture

```
Phase 1: Schema Conversion (SCT)
┌──────────────┐     ┌──────────────┐     ┌──────────────────┐
│  Oracle 19c  │────▶│     SCT      │────▶│  Aurora          │
│  Schema      │     │  (Desktop)   │     │  PostgreSQL      │
│  • Tables    │     │              │     │  Schema          │
│  • Views     │     │  Assessment  │     │  (converted)     │
│  • PL/SQL    │     │  + Convert   │     │                  │
│  • Triggers  │     │  + Apply     │     │                  │
└──────────────┘     └──────────────┘     └──────────────────┘

Phase 2: Data Migration (DMS Full Load + CDC)
┌──────────────┐     ┌──────────────┐     ┌──────────────────┐
│  Oracle 19c  │────▶│     DMS      │────▶│  Aurora          │
│  Data        │     │  Replication │     │  PostgreSQL      │
│  (5 TB)      │     │  Instance    │     │  Data            │
│              │     │  r5.2xlarge  │     │  (migrated)      │
└──────────────┘     └──────────────┘     └──────────────────┘

Phase 3: Application Migration
┌──────────────┐                          ┌──────────────────┐
│  Application │     Update connection    │  Application     │
│  (Oracle     │─────string, SQL ─────────▶│  (PostgreSQL     │
│   driver)    │     dialect changes      │   driver)        │
└──────────────┘                          └──────────────────┘
```

### 7.2 Step-by-Step Process

**Step 1: Pre-Migration Assessment**
- Install SCT and connect to Oracle source
- Run assessment report
- Review conversion complexity (target: >80% auto-conversion)
- Estimate manual effort for unconvertible objects

**Step 2: Schema Conversion**
```
Oracle → PostgreSQL Common Conversions:
──────────────────────────────────────────────────
Oracle                  →  PostgreSQL
──────────────────────────────────────────────────
NUMBER(10)             →  BIGINT
NUMBER(10,2)           →  NUMERIC(10,2)
VARCHAR2(100)          →  VARCHAR(100)
DATE                   →  TIMESTAMP
CLOB                   →  TEXT
BLOB                   →  BYTEA
RAW(16)                →  BYTEA
LONG                   →  TEXT
BOOLEAN (0/1)          →  BOOLEAN
SYS_GUID()            →  gen_random_uuid()
SYSDATE               →  CURRENT_TIMESTAMP
NVL(a,b)              →  COALESCE(a,b)
DECODE(x,1,'A',2,'B') →  CASE x WHEN 1 THEN 'A' ...
ROWNUM                 →  ROW_NUMBER() OVER()
CONNECT BY PRIOR       →  WITH RECURSIVE
||  (concat)           →  ||  (same)
──────────────────────────────────────────────────
```

**Step 3: Manual Conversions (Example)**

Oracle PL/SQL Package:
```sql
-- Oracle
CREATE OR REPLACE PACKAGE order_pkg AS
  PROCEDURE create_order(p_customer_id NUMBER, p_total NUMBER);
  FUNCTION get_order_total(p_order_id NUMBER) RETURN NUMBER;
END order_pkg;

CREATE OR REPLACE PACKAGE BODY order_pkg AS
  PROCEDURE create_order(p_customer_id NUMBER, p_total NUMBER) IS
  BEGIN
    INSERT INTO orders (customer_id, total, order_date)
    VALUES (p_customer_id, p_total, SYSDATE);
  END;
  
  FUNCTION get_order_total(p_order_id NUMBER) RETURN NUMBER IS
    v_total NUMBER;
  BEGIN
    SELECT total INTO v_total FROM orders WHERE order_id = p_order_id;
    RETURN v_total;
  END;
END order_pkg;
```

PostgreSQL equivalent:
```sql
-- PostgreSQL (no packages — use schema + functions)
CREATE SCHEMA order_pkg;

CREATE OR REPLACE FUNCTION order_pkg.create_order(
  p_customer_id BIGINT, p_total NUMERIC
) RETURNS VOID AS $$
BEGIN
  INSERT INTO orders (customer_id, total, order_date)
  VALUES (p_customer_id, p_total, CURRENT_TIMESTAMP);
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION order_pkg.get_order_total(
  p_order_id BIGINT
) RETURNS NUMERIC AS $$
DECLARE
  v_total NUMERIC;
BEGIN
  SELECT total INTO v_total FROM orders WHERE order_id = p_order_id;
  RETURN v_total;
END;
$$ LANGUAGE plpgsql;
```

**Step 4: DMS Configuration**
- Provision DMS replication instance (r5.2xlarge for 5 TB)
- Configure Oracle source endpoint with supplemental logging
- Configure Aurora PostgreSQL target endpoint
- Create task: Full Load + CDC
- Start migration

**Step 5: Cutover**
- Monitor CDC lag until near-zero
- Stop application writes to Oracle
- Wait for final CDC sync
- Switch application connection string to Aurora PostgreSQL
- Validate application functionality

### 7.3 Key Considerations

- **Supplemental logging** must be enabled on Oracle
- **Oracle Binary Reader** is faster than LogMiner for CDC
- **LOB columns** require `Full LOB mode` or `Limited LOB mode` (set max LOB size)
- **Sequences** — reset sequence values after full load
- **Triggers** — disable on target during migration, re-enable after

---

## 8. SQL Server to Aurora MySQL Migration

### 8.1 Key Differences to Handle

| SQL Server | Aurora MySQL | Notes |
|---|---|---|
| T-SQL | MySQL SQL | Major syntax differences |
| Stored procedures (T-SQL) | Stored procedures (MySQL) | Significant rewrite |
| IDENTITY columns | AUTO_INCREMENT | Automatic mapping |
| NVARCHAR | VARCHAR (UTF-8) | Character set handling |
| DATETIME2 | DATETIME(6) | Precision handling |
| UNIQUEIDENTIFIER | CHAR(36) or BINARY(16) | GUID handling |
| Schema.Table | Database.Table | Namespace model differs |
| Windows Auth | MySQL Auth | Authentication change |
| Linked servers | N/A | Architecture change |
| SSRS/SSIS | Custom / Glue / QuickSight | Reporting/ETL change |

### 8.2 Common T-SQL to MySQL Conversions

```sql
-- SQL Server T-SQL
SELECT TOP 10 * FROM orders WHERE order_date > GETDATE() - 30;

-- MySQL equivalent
SELECT * FROM orders WHERE order_date > DATE_SUB(NOW(), INTERVAL 30 DAY) LIMIT 10;

-- SQL Server: String concatenation
SELECT first_name + ' ' + last_name FROM customers;

-- MySQL: String concatenation
SELECT CONCAT(first_name, ' ', last_name) FROM customers;

-- SQL Server: ISNULL
SELECT ISNULL(phone, 'N/A') FROM customers;

-- MySQL: IFNULL or COALESCE
SELECT IFNULL(phone, 'N/A') FROM customers;
```

---

## 9. Oracle to DynamoDB Migration

### 9.1 When to Use This Pattern

- Relational data with simple access patterns
- High-scale read/write requirements
- Key-value or document-oriented data
- Moving from expensive Oracle licenses to pay-per-use

### 9.2 Data Modeling Transformation

```
Oracle (Relational)                    DynamoDB (NoSQL)
┌────────────────────────┐            ┌────────────────────────┐
│ orders                  │            │ Orders Table           │
│ ├── order_id (PK)       │            │ ├── PK: ORDER#123      │
│ ├── customer_id (FK)    │     ──▶    │ ├── SK: METADATA       │
│ ├── order_date          │            │ ├── customer_id        │
│ ├── total               │            │ ├── order_date         │
│ └── status              │            │ ├── total              │
├────────────────────────┤            │ └── status             │
│ order_items             │            │                        │
│ ├── item_id (PK)        │     ──▶    │ PK: ORDER#123          │
│ ├── order_id (FK)       │            │ SK: ITEM#1             │
│ ├── product_id          │            │ ├── product_id         │
│ ├── quantity            │            │ ├── quantity           │
│ └── price               │            │ └── price              │
└────────────────────────┘            └────────────────────────┘

Single Table Design: Both entities in one DynamoDB table
GSI on customer_id for "get all orders for customer" query
```

### 9.3 Migration Steps

1. **Analyze access patterns** (most critical step)
2. **Design DynamoDB table(s)** with partition key, sort key, and GSIs
3. **Use SCT** to map Oracle tables to DynamoDB tables
4. **Use DMS** to migrate data with transformation rules
5. **Refactor application** to use DynamoDB SDK instead of SQL

### 9.4 DMS Table Mapping for DynamoDB Target

```json
{
  "rules": [
    {
      "rule-type": "selection",
      "rule-id": "1",
      "rule-name": "select-orders",
      "object-locator": {
        "schema-name": "SALES",
        "table-name": "ORDERS"
      },
      "rule-action": "include"
    },
    {
      "rule-type": "object-mapping",
      "rule-id": "2",
      "rule-name": "map-to-dynamodb",
      "rule-action": "map-record-to-record",
      "object-locator": {
        "schema-name": "SALES",
        "table-name": "ORDERS"
      },
      "target-table-name": "Orders",
      "mapping-parameters": {
        "partition-key-name": "pk",
        "partition-key-type": "S",
        "sort-key-name": "sk",
        "sort-key-type": "S",
        "attribute-mappings": [
          {
            "target-attribute-name": "pk",
            "attribute-type": "scalar",
            "attribute-sub-type": "string",
            "value": "${ORDER_ID}"
          },
          {
            "target-attribute-name": "sk",
            "attribute-type": "scalar",
            "attribute-sub-type": "string",
            "value": "METADATA"
          }
        ]
      }
    }
  ]
}
```

---

## 10. MongoDB to DocumentDB Migration

### 10.1 Compatibility Considerations

Amazon DocumentDB is **MongoDB-compatible** but not identical:

| Feature | MongoDB | DocumentDB |
|---|---|---|
| Wire protocol | MongoDB 3.6, 4.0, 5.0 | MongoDB 3.6, 4.0, 5.0 compatible |
| Aggregation pipeline | Full support | Most stages supported |
| Transactions | Multi-document ACID | Multi-document ACID (4.0+) |
| Change streams | Yes | Yes |
| Sharding | Yes (native) | No (uses partitions internally) |
| Server-side JavaScript | Yes | No |
| $where operator | Yes | No |
| Text indexes | Yes | Limited |
| Graph queries ($graphLookup) | Yes | Yes |

### 10.2 Migration Methods

**Method 1: DMS (Recommended for minimal downtime)**
```
MongoDB (Source)              DMS                  DocumentDB (Target)
┌──────────────┐      ┌──────────────┐      ┌──────────────────┐
│  Replica Set │─────▶│  Full Load   │─────▶│  DocumentDB      │
│  or Sharded  │      │  + CDC       │      │  Cluster         │
│  Cluster     │      │              │      │                  │
└──────────────┘      └──────────────┘      └──────────────────┘
CDC uses MongoDB Change Streams (requires replica set)
```

**Method 2: mongodump/mongorestore**
```bash
# Export from MongoDB
mongodump --uri="mongodb://source:27017/mydb" --out=/backup/

# Import to DocumentDB
mongorestore --uri="mongodb://docdb-endpoint:27017/mydb" \
  --ssl --sslCAFile=rds-combined-ca-bundle.pem \
  /backup/
```

**Method 3: mongoimport/mongoexport (for individual collections)**

### 10.3 Key Migration Considerations

- DocumentDB requires **TLS connections** (always SSL)
- No server-side JavaScript → Rewrite `$where` queries
- Index differences → Review and test all indexes
- Connection string format differs (DocumentDB uses cluster endpoint)
- Driver compatibility → Use MongoDB driver 3.6+ compatible

---

## 11. Cassandra to Keyspaces Migration

### 11.1 Amazon Keyspaces Overview

Amazon Keyspaces (for Apache Cassandra) is a managed CQL-compatible database service.

### 11.2 Migration Methods

**Method 1: CQL COPY + cqlsh**
```bash
# Export from Cassandra
cqlsh source-host -e "COPY keyspace.table TO '/data/export.csv'"

# Import to Keyspaces
cqlsh keyspaces-endpoint --ssl -e "COPY keyspace.table FROM '/data/export.csv'"
```

**Method 2: Apache Spark with Spark-Cassandra-Connector**
```
Cassandra → Spark (read) → Spark (write) → Keyspaces
```

**Method 3: DMS (supports Cassandra as source, Keyspaces as target)**

### 11.3 Key Differences

| Feature | Apache Cassandra | Amazon Keyspaces |
|---|---|---|
| CQL | Full CQL 3.x | CQL 3.x compatible (most features) |
| Consistency levels | All levels | LOCAL_QUORUM (strong), ONE (eventual) |
| Lightweight transactions | Yes | Yes |
| TTL | Yes | Yes |
| UDTs | Yes | Limited |
| Materialized views | Yes | No |
| Counters | Yes | Yes |
| Storage-attached indexes | Yes (SAI) | No |
| Management | Self-managed | Fully managed |

---

## 12. Mainframe DB to RDS Patterns

### 12.1 Common Mainframe Databases

| Mainframe DB | Common Target | Migration Path |
|---|---|---|
| IBM Db2 for z/OS | Aurora PostgreSQL | SCT + DMS |
| IBM IMS DB | Aurora PostgreSQL / DynamoDB | Custom ETL |
| IBM VSAM | Aurora PostgreSQL / DynamoDB | Custom ETL / Micro Focus |
| ADABAS | Aurora PostgreSQL | Custom ETL |
| IDMS | Aurora PostgreSQL | Custom ETL |

### 12.2 IBM Db2 z/OS → Aurora PostgreSQL

```
Mainframe                   Midrange/Cloud              AWS
┌──────────────┐           ┌──────────────┐          ┌──────────────┐
│  Db2 z/OS    │  Unload   │  Staging     │   DMS    │  Aurora PG   │
│              │──────────▶│  (Db2 LUW    │─────────▶│              │
│              │  DSNTIAUL │   or CSV)    │          │              │
└──────────────┘           └──────────────┘          └──────────────┘

Alternative: Direct DMS connection to Db2 z/OS
(Requires IBM Data Server Driver on DMS instance)
```

### 12.3 Challenges

- **EBCDIC → ASCII encoding** — Character set conversion
- **Packed decimal → Numeric** — Data type mapping
- **COBOL copybooks** — Define record layouts for flat files
- **Hierarchical data (IMS)** → Relational or NoSQL modeling
- **VSAM files** → Custom parsing and loading
- **Referential integrity** — May not exist in mainframe (enforced in COBOL code)

---

## 13. Large Database Migration Strategies

### 13.1 Challenges with Large Databases (Multi-TB)

- **Full load duration:** 10 TB at 100 MB/s = ~28 hours
- **Network bandwidth:** May saturate network during migration
- **Source database impact:** Full load reads all data
- **Replication instance resources:** Need large instance
- **LOB columns:** Dramatically slow migration

### 13.2 Strategy 1: Parallel Full Load

```
Source Database (10 TB)
┌────────────────────────┐
│  Table A (3 TB)        │─── DMS Task 1 ──▶  Target Table A
│  Table B (2 TB)        │─── DMS Task 2 ──▶  Target Table B
│  Table C (2 TB)        │─── DMS Task 3 ──▶  Target Table C
│  Table D (1.5 TB)      │─── DMS Task 4 ──▶  Target Table D
│  Tables E-Z (1.5 TB)   │─── DMS Task 5 ──▶  Target Tables E-Z
└────────────────────────┘

Multiple DMS tasks on same or different replication instances
Each task migrates a subset of tables
Parallel execution reduces total time
```

**DMS Task Settings for Parallel Load:**
```json
{
  "FullLoadSettings": {
    "TargetTablePrepMode": "DO_NOTHING",
    "MaxFullLoadSubTasks": 16,
    "TransactionConsistencyTimeout": 600,
    "CommitRate": 50000
  }
}
```

### 13.3 Strategy 2: Native Tools + DMS CDC

```
Phase 1: Initial Load (Native Tools — fastest)
┌──────────────┐    Oracle Data Pump    ┌──────────────┐
│  Oracle 19c  │────────────────────────▶│  Oracle RDS  │
│  (10 TB)     │    (expdp/impdp)       │  (restored)  │
└──────────────┘    via S3 or Direct    └──────────────┘

Phase 2: CDC Sync (DMS)
┌──────────────┐    DMS CDC             ┌──────────────┐
│  Oracle 19c  │────────────────────────▶│  Oracle RDS  │
│  (changes    │    (catch up deltas)   │  (synced)    │
│   since t0)  │                        │              │
└──────────────┘                        └──────────────┘

Advantage: Native tools are often faster than DMS for bulk data
DMS CDC catches up changes made during native load
```

### 13.4 Strategy 3: Snowball Edge + DMS CDC

For databases too large for online transfer:

```
Phase 1: Bulk Data via Snowball Edge
┌──────────────┐    Export to    ┌──────────────┐    Ship to    ┌──────────┐
│  Source DB   │───────────────▶│  Snowball    │──────────────▶│  S3      │
│  (50 TB)     │    CSV/Parquet │  Edge        │    AWS        │  Bucket  │
└──────────────┘                └──────────────┘               └────┬─────┘
                                                                    │
Phase 2: Load S3 → Target                                         │
┌──────────────┐    COPY / Import                                  │
│  Target DB   │◀──────────────────────────────────────────────────┘
│  (Aurora/    │
│   Redshift)  │
└──────┬───────┘
       │
Phase 3: DMS CDC (sync changes since export)
       │
┌──────▼───────┐    DMS CDC          ┌──────────────┐
│  Target DB   │◀───────────────────│  Source DB   │
│  (synced)    │                     │  (changes)   │
└──────────────┘                     └──────────────┘
```

### 13.5 Strategy 4: Table-Level Partitioning

Split large tables into ranges for parallel migration:

```json
{
  "rules": [
    {
      "rule-type": "selection",
      "rule-id": "1",
      "rule-name": "orders-2020",
      "object-locator": {
        "schema-name": "sales",
        "table-name": "orders"
      },
      "rule-action": "include",
      "filters": [{
        "filter-type": "source",
        "column-name": "order_date",
        "filter-conditions": [{
          "filter-operator": "between",
          "value": "2020-01-01",
          "end-value": "2020-12-31"
        }]
      }]
    }
  ]
}
```

---

## 14. Data Validation During Migration

### 14.1 DMS Data Validation

**Enable in task settings:**
```json
{
  "ValidationSettings": {
    "EnableValidation": true,
    "ThreadCount": 5,
    "PartitionSize": 10000,
    "FailureMaxCount": 10000,
    "HandleCollationDiff": false,
    "RecordFailureDelayInMinutes": 5,
    "RecordSuspendDelayInMinutes": 30,
    "MaxKeyColumnSize": 8096,
    "TableFailureMaxCount": 1000,
    "ValidationOnly": false,
    "SkipLobColumns": false
  }
}
```

### 14.2 Validation Metrics

| Metric | Description |
|---|---|
| ValidationPendingRecords | Records not yet validated |
| ValidationFailedRecords | Records that don't match |
| ValidationSuspendedRecords | Records that can't be validated |
| ValidationState | Not enabled / Pending / Mismatched / Validated / Error |

### 14.3 Custom Validation Approaches

**Row Count Validation:**
```sql
-- Source (Oracle)
SELECT COUNT(*) FROM sales.orders;  -- Result: 5,234,567

-- Target (Aurora PostgreSQL)
SELECT COUNT(*) FROM sales.orders;  -- Result: 5,234,567  ✓
```

**Checksum Validation:**
```sql
-- Source: Calculate checksum of key columns
SELECT MD5(GROUP_CONCAT(order_id, customer_id, total ORDER BY order_id))
FROM orders;

-- Target: Same calculation — compare results
```

**Sample Data Validation:**
```sql
-- Compare random sample of 1000 records
SELECT * FROM orders WHERE order_id IN (
  SELECT order_id FROM orders ORDER BY DBMS_RANDOM.VALUE FETCH FIRST 1000 ROWS ONLY
);
-- Compare with target results
```

### 14.4 Validation Strategy

```
Validation Layers:
┌─────────────────────────────────────┐
│ Layer 1: Row Counts (automated)     │ ← Quick, catches major issues
├─────────────────────────────────────┤
│ Layer 2: DMS Validation (automated) │ ← Row-level hash comparison
├─────────────────────────────────────┤
│ Layer 3: Sample Data (manual/auto)  │ ← Spot-check critical data
├─────────────────────────────────────┤
│ Layer 4: Application Testing        │ ← End-to-end validation
├─────────────────────────────────────┤
│ Layer 5: Business Logic Validation  │ ← Domain experts verify reports
└─────────────────────────────────────┘
```

---

## 15. Minimal Downtime Migration Patterns

### 15.1 Pattern 1: DMS Full Load + CDC

Already covered in Section 4.3. This is the most common pattern.

**Achievable Downtime:** 15 minutes to 1 hour

### 15.2 Pattern 2: Native Replication + Cutover

```
For MySQL → Aurora MySQL:

Step 1: Create Aurora Read Replica of on-premises MySQL
┌──────────────┐     binlog replication      ┌──────────────┐
│  MySQL       │─────────────────────────────▶│  Aurora MySQL│
│  (primary)   │                              │  (replica)   │
└──────────────┘                              └──────────────┘

Step 2: Promote Aurora replica
┌──────────────┐         ╳                    ┌──────────────┐
│  MySQL       │─────────╳────────────────────│  Aurora MySQL│
│  (old)       │         ╳ (break replication)│  (promoted   │
└──────────────┘                              │   primary)   │
                                              └──────────────┘

Step 3: Point application to Aurora
```

**Achievable Downtime:** Seconds to minutes

### 15.3 Pattern 3: Dual-Write

```
Application writes to BOTH databases during transition:

┌──────────────┐     Write     ┌──────────────┐
│  Application │──────────────▶│  Source DB    │
│              │               └──────────────┘
│              │     Write     ┌──────────────┐
│              │──────────────▶│  Target DB   │
│              │               └──────────────┘
│              │     Read      ┌──────────────┐
│              │◀──────────────│  Source DB    │
└──────────────┘               └──────────────┘

Phase 1: Dual-write, read from source
Phase 2: Dual-write, read from target (validate)
Phase 3: Write/read from target only

Achievable Downtime: Zero (but complex implementation)
Complexity: HIGH — must handle write failures gracefully
```

---

## 16. Blue-Green Database Migration

### 16.1 Architecture

```
Blue Environment (Current Production)
┌──────────────────────────────────────────┐
│  Application Servers ──▶ Oracle DB       │
│  (Blue)                  (Primary)       │
└──────────────────────────────────────────┘
         │
    Route 53 / ALB ──── Points to Blue
         │
Green Environment (New on AWS)
┌──────────────────────────────────────────┐
│  Application Servers ──▶ Aurora PG       │
│  (Green)                 (Target)        │
│                                          │
│  DMS: Oracle ────CDC────▶ Aurora PG      │
│  (keeping in sync)                       │
└──────────────────────────────────────────┘

Cutover: Switch Route 53 / ALB from Blue to Green
Rollback: Switch back to Blue (DMS reverse CDC if needed)
```

### 16.2 Process

1. Set up Green environment with Aurora PostgreSQL
2. Convert schema using SCT and apply to Aurora
3. Start DMS Full Load + CDC to sync data
4. Deploy and test application on Green environment
5. Run parallel testing (both environments active)
6. During cutover window:
   - Verify CDC lag is zero
   - Switch traffic from Blue to Green (Route 53 weighted routing: 0% Blue → 100% Green)
   - Monitor Green environment
7. Keep Blue environment running for rollback (24-72 hours)
8. Decommission Blue after validation period

---

## 17. Database Migration Testing Strategies

### 17.1 Test Types

| Test Type | When | Duration | What |
|---|---|---|---|
| **Schema Validation** | After SCT conversion | Hours | All objects created correctly |
| **Data Validation** | After full load | Hours | Row counts, checksums, samples |
| **Application Testing** | After data load | Days | CRUD operations, queries, reports |
| **Performance Testing** | Before cutover | Days | Query performance, throughput |
| **Failover Testing** | Before cutover | Hours | Multi-AZ, backup/restore |
| **Rollback Testing** | Before cutover | Hours | Can we go back to source? |
| **Load Testing** | Before cutover | Days | Production-like traffic |
| **UAT** | Before cutover | Weeks | Business users validate |

### 17.2 Performance Testing Checklist

```
□ Top 50 queries by execution frequency — compare execution time
□ Top 20 queries by resource consumption — compare execution time
□ Batch jobs — compare completion time
□ Report generation — compare completion time
□ Concurrent user load — compare response times at 100%, 150%, 200% load
□ Write throughput — compare INSERT/UPDATE/DELETE rates
□ Connection handling — test max connections, connection pooling
□ Index effectiveness — EXPLAIN ANALYZE on critical queries
```

### 17.3 Rehearsal Migrations

- Perform at least **2-3 full rehearsal migrations** before production cutover
- Time each phase: full load, CDC catch-up, cutover steps
- Identify and fix issues in each rehearsal
- Final rehearsal should be **exact replica** of production cutover plan

---

## 18. Post-Migration Optimization

### 18.1 Immediate (Week 1)

- Monitor CloudWatch metrics (CPU, memory, connections, IOPS)
- Review slow query logs
- Optimize connection pooling (RDS Proxy)
- Verify backup configuration
- Set up alarms for critical metrics

### 18.2 Short-Term (Month 1)

- Right-size RDS instance based on actual utilization
- Optimize queries (PostgreSQL: EXPLAIN ANALYZE)
- Review and optimize indexes (pg_stat_user_indexes)
- Configure Performance Insights for ongoing analysis
- Set up automated maintenance windows

### 18.3 Long-Term (Months 2-6)

- Evaluate Aurora Serverless v2 for variable workloads
- Implement read replicas for read-heavy workloads
- Consider ElastiCache for query caching
- Optimize storage (Aurora auto-scaling storage)
- Implement reserved instances for cost savings
- Archive old data to S3 (via Aurora export or DMS)

---

## 19. Exam Scenarios

### Scenario 1: Oracle to Aurora PostgreSQL

**Question:** A company wants to migrate a 5 TB Oracle database with 200 stored procedures to Aurora PostgreSQL with minimal downtime. The current downtime window is 2 hours. What approach?

**Answer:**
1. Use **SCT** to convert schema and assess stored procedures
2. Manually convert unconvertible stored procedures
3. Apply schema to Aurora PostgreSQL
4. Use **DMS Full Load + CDC** for data migration
5. During 2-hour window: stop app, wait for CDC to catch up, switch connection string
6. Validate with row counts and sample data checks

---

### Scenario 2: 50 TB Oracle Data Warehouse to Redshift

**Question:** A company needs to migrate a 50 TB Oracle data warehouse to Amazon Redshift. Internet bandwidth is 500 Mbps. Downtime is acceptable for one weekend.

**Answer:**
1. Use **SCT** to convert data warehouse schema (tables, views, ETL procedures)
2. Use **SCT Data Extraction Agents** (parallel extraction to S3)
3. 50 TB at 500 Mbps ≈ 9 days (too slow for weekend)
4. Alternative: Use **Snowball Edge** (1 device = 80 TB) to ship data to S3
5. Load from S3 into Redshift using COPY command
6. Use DMS CDC for delta changes during weekend cutover

---

### Scenario 3: MongoDB to DocumentDB

**Question:** A company has a 500 GB MongoDB replica set. They want to migrate to DocumentDB with less than 15 minutes of downtime.

**Answer:**
1. Create DocumentDB cluster
2. Use **DMS Full Load + CDC** from MongoDB to DocumentDB
3. DMS uses MongoDB Change Streams for CDC (requires replica set — already have it)
4. Full load takes ~2-4 hours for 500 GB
5. CDC catches up to near real-time
6. During 15-min window: stop writes, verify sync, update connection string

---

### Scenario 4: Minimal Downtime MySQL Migration

**Question:** An e-commerce company runs MySQL 8.0 on-premises. They need to migrate to Aurora MySQL with zero downtime. The database is 200 GB.

**Answer:**
1. Set up **Aurora MySQL read replica** of on-premises MySQL using native binary log replication
2. Configure Direct Connect or VPN for network connectivity
3. Aurora replica stays in sync via binlog replication
4. When ready: promote Aurora replica to standalone
5. Update application connection string
6. **Near-zero downtime** — only the promotion time (seconds)

Alternative: DMS Full Load + CDC (downtime = cutover window of minutes)

---

### Scenario 5: Large-Scale Heterogeneous Migration

**Question:** A company has 30 Oracle databases (total 80 TB) across multiple applications. They want to migrate all to Aurora PostgreSQL within 12 months. What approach?

**Answer:**
1. **Assess:** Run SCT assessment on all 30 databases — identify conversion complexity
2. **Prioritize:** Group databases by complexity (easy → hard)
3. **Wave plan:**
   - Wave 1: 5 smallest, simplest databases (build team skills)
   - Wave 2-4: Medium databases, increasing complexity
   - Wave 5-6: Largest, most complex databases
4. **Each database:** SCT (schema) → DMS (Full Load + CDC) → Cutover
5. **Parallel execution:** Multiple databases migrating simultaneously
6. **Automation:** Standardize DMS task templates, validation scripts

---

> **Key Exam Tips Summary:**
> 1. **Homogeneous migration** (same engine) = DMS only, or native tools + DMS CDC
> 2. **Heterogeneous migration** (different engine) = SCT (schema) + DMS (data)
> 3. **Minimal downtime** = DMS Full Load + CDC (most common answer)
> 4. **Zero downtime MySQL** = Native binlog replication to Aurora replica → promote
> 5. **Large databases** = Parallel tasks, native tools for initial load, DMS for CDC
> 6. **Massive databases (50+ TB)** = Snowball Edge + DMS CDC
> 7. **Always validate** = DMS validation + row counts + sample data + application testing
> 8. **Right-size DMS** = Under-provisioned replication instance is the #1 cause of failure
> 9. **LOB columns** = Use Limited LOB mode with appropriate size limit
> 10. **Oracle CDC** = Binary Reader preferred over LogMiner for performance
