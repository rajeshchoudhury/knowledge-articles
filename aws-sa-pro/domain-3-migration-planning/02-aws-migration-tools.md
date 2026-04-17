# AWS Migration Tools — AWS SAP-C02 Domain 3 Deep Dive

## Table of Contents
1. [AWS Migration Hub](#1-aws-migration-hub)
2. [AWS Application Discovery Service](#2-aws-application-discovery-service)
3. [AWS Application Migration Service (MGN)](#3-aws-application-migration-service-mgn)
4. [AWS Server Migration Service (SMS)](#4-aws-server-migration-service-sms)
5. [AWS Database Migration Service (DMS)](#5-aws-database-migration-service-dms)
6. [AWS Schema Conversion Tool (SCT)](#6-aws-schema-conversion-tool-sct)
7. [AWS DataSync](#7-aws-datasync)
8. [AWS Transfer Family](#8-aws-transfer-family)
9. [AWS Snow Family](#9-aws-snow-family)
10. [CloudEndure Migration](#10-cloudendure-migration)
11. [VM Import/Export](#11-vm-importexport)
12. [Migration Tool Selection Decision Framework](#12-migration-tool-selection-decision-framework)
13. [Exam Scenarios](#13-exam-scenarios)

---

## 1. AWS Migration Hub

### 1.1 Overview

AWS Migration Hub provides a **single place to discover, plan, and track** application migrations to AWS. It aggregates data from multiple migration tools into a unified view.

### 1.2 Key Features

| Feature | Description |
|---|---|
| **Unified Dashboard** | Single pane of glass for all migrations |
| **Strategy Recommendations** | Uses discovery data to recommend 7 Rs |
| **Application Grouping** | Group servers into logical applications |
| **Progress Tracking** | Track migration status per application |
| **Integration** | Connects with MGN, DMS, CloudEndure |
| **Refactor Spaces** | Manage refactoring with incremental approach |

### 1.3 Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    AWS Migration Hub                          │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────────┐  │
│  │  Discovery    │  │   Strategy   │  │    Tracking      │  │
│  │  (ADS data)   │  │  Recommend.  │  │  (MGN, DMS,     │  │
│  │              │  │              │  │   CloudEndure)   │  │
│  └──────┬───────┘  └──────┬───────┘  └──────┬───────────┘  │
│         │                 │                 │               │
│         ▼                 ▼                 ▼               │
│  ┌─────────────────────────────────────────────────────┐   │
│  │              Unified Migration Dashboard              │   │
│  │  • Server inventory    • Application groups           │   │
│  │  • Migration status    • Timeline tracking            │   │
│  │  • Dependency maps     • Cost estimation              │   │
│  └─────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
         │                    │                    │
         ▼                    ▼                    ▼
┌──────────────┐    ┌──────────────┐    ┌──────────────┐
│  Application │    │  Database    │    │     AWS      │
│  Migration   │    │  Migration   │    │   Migration  │
│  Service     │    │  Service     │    │   Evaluator  │
│  (MGN)       │    │  (DMS)       │    │              │
└──────────────┘    └──────────────┘    └──────────────┘
```

### 1.4 Migration Hub Refactor Spaces

Used for managing incremental application refactoring:

- **Environment:** Container for application resources
- **Application:** Represents a refactoring project
- **Service:** API endpoint routing (can split traffic between legacy and new)
- **Route:** Maps URL paths to different services (strangler fig pattern)

```
Internet → API Gateway → Refactor Spaces Route
                              │
                    ┌─────────┴─────────┐
                    │                    │
              /api/v1/orders       /api/v1/users
              (Legacy monolith)    (New microservice
               via NLB)            on Lambda)
```

> **Exam Tip:** Migration Hub is the **tracking** and **coordination** layer. It doesn't perform the actual migration — it integrates with tools that do.

---

## 2. AWS Application Discovery Service

### 2.1 Overview

Collects information about on-premises servers to help plan migration: configuration, usage, and behavior data.

### 2.2 Two Discovery Modes

| Feature | Agentless Discovery | Agent-Based Discovery |
|---|---|---|
| **How** | OVA deployed in VMware vCenter | Agent installed on each server |
| **Platform** | VMware VMs only | Physical, VM, any OS |
| **Connector** | Discovery Connector (OVA) | Discovery Agent |
| **Data Collected** | VM inventory, config, utilization (CPU/RAM/disk) | Detailed config, utilization, running processes, network connections |
| **Network Dependencies** | No | **Yes** — TCP connections mapped |
| **OS Support** | N/A (hypervisor level) | Linux, Windows |
| **Performance Impact** | None on VMs | Minimal |
| **Use Case** | Quick inventory of VMware estate | Deep dependency mapping |

### 2.3 Agentless Discovery (Discovery Connector)

```
On-Premises VMware Environment
┌─────────────────────────────────────────┐
│  vCenter Server                          │
│  ┌──────┐ ┌──────┐ ┌──────┐ ┌──────┐   │
│  │ VM 1 │ │ VM 2 │ │ VM 3 │ │ VM 4 │   │
│  └──────┘ └──────┘ └──────┘ └──────┘   │
│                                          │
│  ┌───────────────────────┐               │
│  │  Discovery Connector  │──── vCenter ──┘
│  │  (OVA appliance)      │     API queries
│  └───────────┬───────────┘
│              │ HTTPS
└──────────────┼───────────────────────────┘
               │
               ▼
    ┌─────────────────────┐
    │ AWS Application      │
    │ Discovery Service    │
    │ (Migration Hub)      │
    └─────────────────────┘
```

**Collected Data:**
- VM inventory (name, host, OS, IP, MAC)
- Resource allocation (CPU cores, RAM, disk)
- Utilization metrics (CPU, RAM, disk I/O — 15-min intervals)
- VMware tags and attributes

### 2.4 Agent-Based Discovery (Discovery Agent)

```
On-Premises Servers
┌─────────────┐  ┌─────────────┐  ┌─────────────┐
│  Server 1    │  │  Server 2    │  │  Server 3    │
│  ┌────────┐  │  │  ┌────────┐  │  │  ┌────────┐  │
│  │ Agent  │  │  │  │ Agent  │  │  │  │ Agent  │  │
│  └───┬────┘  │  │  └───┬────┘  │  │  └───┬────┘  │
└──────┼───────┘  └──────┼───────┘  └──────┼───────┘
       │                 │                 │
       └────────────┬────┴─────────────────┘
                    │ HTTPS (Port 443)
                    ▼
         ┌─────────────────────┐
         │ AWS Application      │
         │ Discovery Service    │
         └──────────┬──────────┘
                    │
                    ▼
         ┌─────────────────────┐
         │ Migration Hub        │
         │ • Server inventory   │
         │ • Dependency maps    │
         │ • Network topology   │
         └─────────────────────┘
```

**Additional Data (beyond agentless):**
- Running processes (name, PID, command line)
- Network connections (source IP:port → destination IP:port)
- TCP/UDP connection maps → **dependency visualization**
- System performance data (higher fidelity)

### 2.5 Data Export and Analysis

- Data stored in Migration Hub for 2 years
- Export to S3 as CSV
- Analyze with Amazon Athena
- Visualize with Amazon QuickSight
- Import into Migration Hub Strategy Recommendations

> **Exam Tip:** "Identify application dependencies" or "map network connections" → Agent-based discovery. "Quick inventory of VMware VMs" → Agentless discovery.

---

## 3. AWS Application Migration Service (MGN)

### 3.1 Overview

AWS MGN is the **primary recommended service** for lift-and-shift (rehost) migrations to AWS. It replaces both CloudEndure Migration and AWS Server Migration Service (SMS).

### 3.2 Architecture

```
Source Environment                              AWS Target
┌────────────────┐                         ┌──────────────────┐
│  Source Server  │                         │  Staging Area     │
│  ┌───────────┐ │                         │  (Subnet)         │
│  │ MGN Agent │ │   Continuous             │  ┌──────────────┐ │
│  │ (replctn) │─┼── Block-Level ──────────┼─▶│ Replication  │ │
│  └───────────┘ │   Replication            │  │ Server (EC2) │ │
│                │   (TCP 1500)             │  │ + EBS Volumes│ │
│  OS: Linux/    │                         │  └──────────────┘ │
│  Windows       │                         │                    │
└────────────────┘                         │  (Low-cost instances│
                                           │   e.g., t3.small)  │
                                           └────────┬───────────┘
                                                    │
                                              Test / Cutover
                                                    │
                                                    ▼
                                           ┌──────────────────┐
                                           │  Target Instance  │
                                           │  (Right-sized     │
                                           │   EC2 Instance)   │
                                           │                    │
                                           │  Converted boot   │
                                           │  volume + drivers │
                                           └──────────────────┘
```

### 3.3 How MGN Works

**Step-by-Step Process:**

1. **Install Agent:** Install the AWS Replication Agent on each source server
2. **Initial Sync:** Full block-level copy of all disks to staging area (EBS volumes)
3. **Continuous Replication:** Ongoing block-level changes replicated in near real-time
4. **Launch Test Instance:** Test the migrated server in isolated test subnet
5. **Validate:** Run validation tests against the test instance
6. **Cutover:** Launch the final production instance
7. **Finalize:** Switch DNS/load balancers, decommission source

### 3.4 Key Components

| Component | Description |
|---|---|
| **Replication Agent** | Installed on source servers; captures block-level changes |
| **Replication Server** | Lightweight EC2 instance in staging area receiving data |
| **Staging Area** | Dedicated subnet with replication servers and EBS volumes |
| **Launch Template** | Defines target instance type, VPC, subnet, security groups |
| **Launch Settings** | Test and cutover configurations |
| **Lifecycle States** | Not ready → Ready for testing → Test in progress → Ready for cutover → Cutover in progress → Cutover complete |
| **Post-Launch Actions** | SSM documents executed after launch (install software, run scripts) |

### 3.5 Replication Details

| Setting | Options |
|---|---|
| **Replication Server Type** | Default: t3.small (auto-scales based on load) |
| **EBS Volume Type** | Low cost: gp2/gp3 (staging), target can be different |
| **Bandwidth Throttling** | Configurable per source server (Mbps) |
| **Data Routing** | Direct (internet) or via VPN/Direct Connect |
| **Encryption** | In-transit: TLS 1.2; At-rest: EBS encryption |
| **Replication Port** | TCP 1500 |

### 3.6 Testing

```
Test Launch Flow:
┌──────────┐    ┌──────────────┐    ┌───────────────┐    ┌──────────┐
│ Launch    │───▶│ EC2 Instance │───▶│ Run Post-     │───▶│ Validate │
│ Test      │    │ Created from │    │ Launch        │    │ (Manual  │
│ Instance  │    │ EBS Snapshot │    │ Actions (SSM) │    │ or Auto) │
└──────────┘    └──────────────┘    └───────────────┘    └──────────┘
                                                                │
                                                     ┌──────────▼──────────┐
                                                     │ Mark as "Ready for  │
                                                     │ Cutover" or "Retest"│
                                                     └─────────────────────┘
```

**Test Best Practices:**
- Launch test instances in isolated subnet (no production traffic)
- Validate application functionality, connectivity, performance
- Run automated smoke tests via Systems Manager Run Command
- Test with production-like data if possible
- Repeat testing if source server changes significantly

### 3.7 Cutover Process

```
Cutover Window (Example: 2-hour maintenance window)
─────────────────────────────────────────────────────
t=0:00  Stop application on source server
t=0:05  Final replication sync completes (delta only)
t=0:10  Launch cutover instance from latest snapshot
t=0:15  Post-launch actions execute (SSM)
t=0:25  Validate application on new EC2 instance
t=0:35  Update DNS / Load Balancer to point to new instance
t=0:45  Monitor for issues
t=1:30  Declare cutover successful or rollback
t=2:00  Window closes
─────────────────────────────────────────────────────
Actual downtime: ~35 minutes (stop source → DNS switch)
```

### 3.8 Supported Source Environments

| Environment | Supported |
|---|---|
| Physical servers | Yes |
| VMware | Yes |
| Hyper-V | Yes |
| KVM | Yes |
| Azure VMs | Yes |
| GCP VMs | Yes |
| Other cloud | Yes |
| Windows Server 2003+ | Yes |
| Linux (most distros) | Yes |

> **Exam Tip:** MGN is the **go-to answer** for rehost migrations. Key differentiators: continuous block-level replication, supports physical and virtual, minimal downtime cutover, automated driver injection.

---

## 4. AWS Server Migration Service (SMS)

### 4.1 Overview (Legacy)

AWS SMS is the **predecessor to MGN** and is now in maintenance mode. New migrations should use MGN.

### 4.2 SMS vs MGN Comparison

| Feature | SMS (Legacy) | MGN (Current) |
|---|---|---|
| **Replication** | Incremental snapshots (scheduled) | Continuous block-level |
| **Source** | VMware, Hyper-V, Azure only | Physical + all virtual + cloud |
| **Agent** | Agentless (connector OVA) | Agent on each server |
| **Downtime** | Longer (snapshot-based) | Minimal (continuous replication) |
| **Testing** | Manual AMI launch | Integrated test workflow |
| **Automation** | Limited | Full lifecycle automation |
| **Application Grouping** | Application-level grouping | Yes, with wave management |
| **Post-Launch** | Manual | SSM-based automation |
| **Status** | Maintenance mode | **Recommended** |

> **Exam Tip:** If the exam mentions "SMS," understand it's legacy. For new migrations, always choose MGN. If a question specifically asks about agentless VM migration, SMS used a connector OVA, but MGN is still preferred.

---

## 5. AWS Database Migration Service (DMS)

### 5.1 Overview

AWS DMS migrates databases to AWS with minimal downtime. Supports homogeneous (same engine) and heterogeneous (different engines) migrations.

### 5.2 Architecture

```
Source Database                  AWS DMS                      Target Database
┌──────────────┐    ┌──────────────────────────┐    ┌──────────────────┐
│  Oracle      │    │  Replication Instance     │    │  Aurora          │
│  on-premises │◀──▶│  ┌──────────────────────┐│◀──▶│  PostgreSQL      │
│              │    │  │  Replication Task     ││    │  (RDS)           │
│  Source      │    │  │  ┌────────┐ ┌──────┐ ││    │                  │
│  Endpoint    │◀───│──│──│ Table  │ │ CDC  │ ││───▶│  Target          │
│              │    │  │  │Mapping │ │Engine│ ││    │  Endpoint        │
│              │    │  │  └────────┘ └──────┘ ││    │                  │
└──────────────┘    │  └──────────────────────┘│    └──────────────────┘
                    │                          │
                    │  EC2 Instance             │
                    │  (dms.r5.xlarge etc.)     │
                    └──────────────────────────┘
```

### 5.3 Core Components

#### Replication Instance
- **What:** EC2 instance that runs the replication tasks
- **Sizing:** dms.t3.medium to dms.r5.24xlarge
- **Multi-AZ:** Supported for high availability
- **Storage:** Allocated storage for caching and logs

| Instance Class | Use Case |
|---|---|
| dms.t3.medium | Small databases, testing |
| dms.r5.large | Production, single database <1TB |
| dms.r5.xlarge | Production, databases 1-5TB |
| dms.r5.2xlarge | Large databases 5-10TB |
| dms.r5.4xlarge+ | Very large databases, high CDC throughput |

#### Source and Target Endpoints
- Connection info: hostname, port, username, password, SSL
- Engine-specific settings
- Extra connection attributes

**Supported Sources:**
| Source | Versions |
|---|---|
| Oracle | 10.2+, 11g, 12c, 18c, 19c, 21c |
| SQL Server | 2005+ |
| MySQL | 5.5+ |
| PostgreSQL | 9.4+ |
| MariaDB | 10.0.24+ |
| MongoDB | 3.x, 4.x, 5.x |
| SAP ASE | 12.5+ |
| IBM Db2 | 9.7+ |
| Amazon S3 | (as source) |
| Amazon Aurora | All versions |

**Supported Targets:**
| Target | Notes |
|---|---|
| Aurora MySQL/PostgreSQL | Most common target |
| RDS (all engines) | MySQL, PostgreSQL, Oracle, SQL Server, MariaDB |
| Amazon Redshift | Data warehouse |
| Amazon DynamoDB | NoSQL |
| Amazon S3 | Data lake / archive |
| Amazon OpenSearch | Search / analytics |
| Amazon Kinesis Data Streams | Streaming |
| Amazon Neptune | Graph database |
| Amazon DocumentDB | MongoDB-compatible |
| Amazon Keyspaces | Cassandra-compatible |
| Redis (ElastiCache) | In-memory |

#### Replication Tasks

**Three Migration Types:**

| Type | Description | Use Case |
|---|---|---|
| **Full Load** | One-time bulk copy of all data | Small databases, can afford downtime |
| **CDC Only** | Capture and replicate only changes | Already loaded data via other means |
| **Full Load + CDC** | Bulk copy then continuous replication | **Most common** — minimal downtime |

### 5.4 Change Data Capture (CDC)

CDC captures changes from the source database transaction log and applies them to the target in near real-time.

```
Source Database Transaction Flow:
┌──────────┐     ┌──────────────┐     ┌──────────────┐
│ INSERT   │────▶│ Transaction  │────▶│ DMS CDC      │
│ UPDATE   │     │ Log / WAL    │     │ Engine       │
│ DELETE   │     │ / Redo Log   │     │              │
└──────────┘     └──────────────┘     └──────┬───────┘
                                              │
                                              ▼
                                     ┌──────────────┐
                                     │ Target DB     │
                                     │ (near real-   │
                                     │  time apply)  │
                                     └──────────────┘
```

**CDC Requirements by Source:**

| Source DB | CDC Mechanism | Requirement |
|---|---|---|
| Oracle | LogMiner or Binary Reader | Supplemental logging enabled |
| SQL Server | MS-CDC or MS-Replication | CDC enabled on database |
| MySQL | Binary log (binlog) | binlog_format = ROW |
| PostgreSQL | Logical replication | wal_level = logical |
| MongoDB | Change Streams | Replica set or sharded cluster |

### 5.5 Table Mappings

Table mappings define which tables to migrate and how to transform them.

**Selection Rules (JSON):**
```json
{
  "rules": [
    {
      "rule-type": "selection",
      "rule-id": "1",
      "rule-name": "include-sales-tables",
      "object-locator": {
        "schema-name": "sales",
        "table-name": "%"
      },
      "rule-action": "include"
    },
    {
      "rule-type": "selection",
      "rule-id": "2",
      "rule-name": "exclude-audit-tables",
      "object-locator": {
        "schema-name": "sales",
        "table-name": "audit_%"
      },
      "rule-action": "exclude"
    }
  ]
}
```

**Transformation Rules:**
```json
{
  "rules": [
    {
      "rule-type": "transformation",
      "rule-id": "3",
      "rule-name": "rename-schema",
      "rule-action": "rename",
      "rule-target": "schema",
      "object-locator": {
        "schema-name": "legacy_sales"
      },
      "value": "sales"
    },
    {
      "rule-type": "transformation",
      "rule-id": "4",
      "rule-name": "convert-lowercase",
      "rule-action": "convert-lowercase",
      "rule-target": "column",
      "object-locator": {
        "schema-name": "%",
        "table-name": "%",
        "column-name": "%"
      }
    }
  ]
}
```

### 5.6 Data Validation

DMS can validate migrated data by comparing source and target:

```
Validation Process:
Source Table          Target Table         Comparison
┌──────────┐        ┌──────────┐        ┌───────────────┐
│ Row Hash │◄──────▶│ Row Hash │───────▶│ Match?        │
│ COUNT(*) │        │ COUNT(*) │        │ Row counts    │
│ Checksums│        │ Checksums│        │ Data values   │
└──────────┘        └──────────┘        └───────────────┘
```

- Enabled per task via `ValidationSettings`
- Validates row counts and data values
- Reports: `ValidationPendingRecords`, `ValidationFailedRecords`, `ValidationSuspendedRecords`
- View in DMS console or CloudWatch

### 5.7 Multi-AZ DMS

```
Primary AZ                      Standby AZ
┌──────────────────┐           ┌──────────────────┐
│ DMS Replication  │           │ DMS Replication  │
│ Instance         │◄─────────▶│ Instance         │
│ (Active)         │  Sync     │ (Standby)        │
│                  │ Replctn   │                  │
│ - Tasks run here │           │ - Auto failover  │
│ - Endpoints conn │           │ - Same task state │
└──────────────────┘           └──────────────────┘
```

- Automatic failover to standby in different AZ
- No data loss during failover
- Recommended for production migrations

> **Exam Tip:** DMS is the go-to for database migration. Key exam topics: Full Load + CDC for minimal downtime, table mappings for selective migration, Multi-AZ for HA, and knowing which engines are supported as source/target.

---

## 6. AWS Schema Conversion Tool (SCT)

### 6.1 Overview

SCT converts database schema from one engine to another. Essential for **heterogeneous** migrations (e.g., Oracle → PostgreSQL, SQL Server → MySQL).

### 6.2 What SCT Converts

| Source → Target | Converts |
|---|---|
| Oracle → Aurora PostgreSQL | Tables, views, stored procedures (PL/SQL → PL/pgSQL), triggers, functions, sequences, types, synonyms |
| Oracle → Aurora MySQL | Tables, views, procedures, triggers, functions |
| SQL Server → Aurora MySQL | Tables, views, procedures (T-SQL → MySQL), triggers, functions |
| SQL Server → Aurora PostgreSQL | Tables, views, procedures, triggers |
| Oracle → DynamoDB | Tables → DynamoDB tables (with key design) |
| Teradata → Redshift | Tables, views, procedures, macros |
| Netezza → Redshift | Tables, views, procedures |

### 6.3 Migration Assessment Report

SCT generates a detailed assessment report before conversion:

```
Assessment Report Example:
──────────────────────────────────────────────────
Source: Oracle 19c (Schema: SALES)
Target: Aurora PostgreSQL 14

Object Type        Total   Auto    Manual   Effort
                          Convert  Convert  (Days)
──────────────────────────────────────────────────
Tables              245     245       0       0
Views                67      62       5       3
Stored Procedures   134      98      36      15
Functions            45      38       7       4
Triggers             23      20       3       2
Packages             12       4       8      12
Types                 8       5       3       2
Sequences            34      34       0       0
Synonyms             56      56       0       0
──────────────────────────────────────────────────
Total               624     562      62      38
Auto-Convert Rate:         90.1%
Estimated Manual Effort:   38 person-days
```

**Action Items (Color Coded):**
- 🟢 **Green:** Automatically converted (no manual effort)
- 🟡 **Yellow:** Can be converted with minor manual changes
- 🔴 **Red:** Cannot be automatically converted; requires significant rewrite

### 6.4 Data Extraction Agents

For large databases, SCT can use **data extraction agents** to extract data from the source and load it into S3, then into the target:

```
Source Database          SCT Data Extraction         AWS
┌──────────────┐        ┌───────────────────┐       ┌────────────┐
│  Oracle      │        │  Extraction Agent  │       │  Amazon S3 │
│  (10TB)      │───────▶│  (on-premises EC2  │──────▶│  (staging) │
│              │        │   or physical)     │       └─────┬──────┘
└──────────────┘        │                   │              │
                        │  Parallel extract  │              ▼
                        │  & compress        │       ┌────────────┐
                        └───────────────────┘       │  Target DB │
                                                     │  (Redshift,│
                                                     │   Aurora)  │
                                                     └────────────┘
```

**Use Case:** Migrating a 20TB Teradata data warehouse to Redshift:
1. SCT converts schema (tables, views, procedures)
2. Data extraction agents extract data in parallel (16 agents)
3. Data lands in S3 in compressed format
4. COPY command loads data from S3 into Redshift
5. DMS handles ongoing CDC for delta changes

> **Exam Tip:** SCT is used **before** DMS for heterogeneous migrations. SCT converts the schema, DMS moves the data. For homogeneous migrations (e.g., MySQL → Aurora MySQL), SCT is not needed.

---

## 7. AWS DataSync

### 7.1 Overview

AWS DataSync is a **data transfer service** that simplifies, automates, and accelerates moving data between on-premises storage and AWS storage services, or between AWS storage services.

### 7.2 Architecture

```
On-Premises                                    AWS
┌──────────────────┐                    ┌──────────────────┐
│  NFS Server      │                    │  Amazon S3       │
│  SMB File Share  │                    │  Amazon EFS      │
│  HDFS Cluster    │                    │  Amazon FSx      │
│  Self-managed    │                    │                  │
│  Object Storage  │                    │                  │
└────────┬─────────┘                    └────────▲─────────┘
         │                                       │
    ┌────▼────────┐        Internet/         ┌───┴──────────┐
    │  DataSync   │        Direct Connect    │  DataSync    │
    │  Agent      │◄──────────────────────▶  │  Service     │
    │  (VM on-    │        TLS encrypted     │  Endpoint    │
    │   premises) │        Up to 10 Gbps     │  (ENI in VPC │
    └─────────────┘        per agent         │   or public) │
                                             └──────────────┘
```

### 7.3 Key Components

| Component | Description |
|---|---|
| **Agent** | VM deployed on-premises (VMware ESXi, KVM, Hyper-V, or EC2 for cloud-to-cloud) |
| **Location** | Source or destination (NFS, SMB, HDFS, S3, EFS, FSx, self-managed object storage) |
| **Task** | Defines what to transfer, from where, to where, and how |
| **Task Execution** | Individual run of a task |

### 7.4 Supported Locations

| Location Type | As Source | As Destination |
|---|---|---|
| NFS | Yes | Yes |
| SMB | Yes | Yes |
| HDFS | Yes | No |
| Self-managed Object Storage | Yes | No |
| Amazon S3 (all classes) | Yes | Yes |
| Amazon EFS | Yes | Yes |
| Amazon FSx for Windows | Yes | Yes |
| Amazon FSx for Lustre | Yes | Yes |
| Amazon FSx for OpenZFS | Yes | Yes |
| Amazon FSx for NetApp ONTAP | Yes | Yes |
| Snowcone | Yes | Yes |

### 7.5 Transfer Performance

| Configuration | Throughput |
|---|---|
| Single agent, single task | Up to 10 Gbps |
| Multiple agents, single task | Scales linearly |
| Over internet | Limited by bandwidth |
| Over Direct Connect (10 Gbps) | Up to 10 Gbps per agent |

**Performance Features:**
- Parallel, multi-threaded transfers
- Compression and inline deduplication
- TLS encryption in transit
- Bandwidth throttling (configurable)
- Automatic retry on transient errors

### 7.6 Filtering and Scheduling

**Include/Exclude Filters:**
```
Task Configuration:
  Include patterns: /data/2024/*, /data/2025/*
  Exclude patterns: *.tmp, *.log, /data/*/archive/*
```

**Scheduling:**
- Cron-based scheduling (e.g., every hour, every day at 2 AM)
- Minimum interval: 1 hour
- Incremental transfer: Only changed files transferred

### 7.7 DataSync vs Other Transfer Tools

| Feature | DataSync | S3 Transfer Acceleration | Snow Family |
|---|---|---|---|
| **Use Case** | NFS/SMB → AWS, AWS → AWS | Client → S3 uploads | Large offline transfer |
| **Speed** | Up to 10 Gbps/agent | Faster S3 uploads | Limited by shipping |
| **Online** | Yes | Yes | No (offline) |
| **Protocol** | NFS, SMB, HDFS, S3 | S3 API (HTTP) | Physical device |
| **Recurring** | Yes (scheduled) | Per-upload | No (one-time) |
| **Agent** | Required on-prem | No agent | Device shipped |

> **Exam Tip:** DataSync = online, automated, recurring file/object transfers (NFS/SMB to S3/EFS). It's NOT for database migration (use DMS) or block-level replication (use MGN).

---

## 8. AWS Transfer Family

### 8.1 Overview

Managed file transfer service supporting **SFTP, FTPS, FTP, and AS2** protocols with S3 or EFS as backend storage.

### 8.2 Architecture

```
External Partners / Users              AWS Transfer Family         Storage Backend
┌──────────────┐                    ┌────────────────────┐      ┌────────────┐
│  SFTP Client │───SFTP:22─────────▶│  Transfer Server   │─────▶│ Amazon S3  │
│              │                    │  (endpoint)        │      └────────────┘
├──────────────┤                    │                    │      ┌────────────┐
│  FTPS Client │───FTPS:990────────▶│  • Authentication  │─────▶│ Amazon EFS │
│              │                    │  • Authorization   │      └────────────┘
├──────────────┤                    │  • Audit logging   │
│  FTP Client  │───FTP:21──────────▶│  • Encryption      │
│              │                    │                    │
├──────────────┤                    │                    │
│  AS2 Partner │───AS2:443─────────▶│  (EDI / B2B)       │
└──────────────┘                    └────────────────────┘
```

### 8.3 Endpoint Types

| Endpoint Type | Public IP | VPC | Use Case |
|---|---|---|---|
| **Public** | Yes (AWS-owned) | No | Internet-facing SFTP |
| **VPC (internal)** | No | Yes (ENI) | Internal VPC access |
| **VPC (internet-facing)** | Yes (EIP) | Yes (ENI) | Internet + VPC with static IP |

### 8.4 Identity Providers

| Provider | Description |
|---|---|
| **Service Managed** | Users managed in Transfer Family console; SSH keys |
| **AWS Directory Service** | Microsoft AD or AD Connector |
| **Custom (Lambda)** | Lambda function authenticates against any IdP |
| **Custom (API Gateway)** | API Gateway + Lambda for complex auth |

### 8.5 Protocols Deep Dive

| Protocol | Port | Encryption | Use Case |
|---|---|---|---|
| **SFTP** | 22 | SSH | Most common; secure file transfer |
| **FTPS** | 990/21 | TLS | Legacy FTP clients needing encryption |
| **FTP** | 21 | None | Internal VPC only (no internet) |
| **AS2** | 443 | S/MIME + TLS | EDI/B2B supply chain (healthcare, retail) |

> **Exam Tip:** Transfer Family = replacing self-managed SFTP/FTP servers. Common scenario: "Company has SFTP server for partner file exchange, wants to migrate to AWS" → AWS Transfer Family with S3 backend and custom Lambda IdP for existing user database.

---

## 9. AWS Snow Family

### 9.1 Overview

Physical devices for offline data transfer and edge computing when network transfer is impractical.

### 9.2 Device Comparison

| Feature | Snowcone | Snowball Edge Storage Optimized | Snowball Edge Compute Optimized | Snowmobile |
|---|---|---|---|---|
| **Storage** | 8 TB HDD or 14 TB SSD | 80 TB usable | 42 TB HDD or 28 TB NVMe | 100 PB |
| **Compute** | 2 vCPUs, 4 GB RAM | 40 vCPUs, 80 GB RAM | 104 vCPUs, 416 GB RAM | N/A |
| **GPU** | No | No | Optional (NVIDIA V100) | N/A |
| **Weight** | 4.5 lbs (2 kg) | 49.7 lbs (22.3 kg) | 49.7 lbs (22.3 kg) | Semi-truck |
| **DataSync Agent** | **Built-in** | No (use S3 API) | No (use S3 API) | N/A |
| **Edge Computing** | IoT Greengrass, EC2 | EC2, Lambda, IoT | EC2, Lambda, IoT, EKS Anywhere | N/A |
| **Clustering** | No | Up to 5-15 | Up to 5-15 | N/A |
| **Network** | 10 Gbps | 25/100 Gbps | 25/100 Gbps | Dedicated fiber |
| **Encryption** | 256-bit AES | 256-bit AES | 256-bit AES | 256-bit AES |
| **Power** | USB-C or battery | Standard AC | Standard AC | Generator |
| **Use Case** | Remote, harsh, small | Large data transfer | ML inference at edge | Exabyte-scale |

### 9.3 Snowcone Deep Dive

**Two Variants:**
- **Snowcone (HDD):** 8 TB usable storage
- **Snowcone SSD:** 14 TB usable NVMe SSD storage

**Key Features:**
- Smallest and most portable Snow device
- Built-in DataSync agent for online transfer (when connected to network)
- Can collect data offline, then ship to AWS, OR use DataSync over network
- Runs EC2 instances and IoT Greengrass at the edge
- Battery-powered option for field use

**Use Cases:**
- Military/defense field operations
- Healthcare in remote clinics
- Factory floor data collection
- Drone/vehicle data collection

### 9.4 Snowball Edge Storage Optimized

**Capacity:** 80 TB usable (out of 100+ TB raw)

**Compute:** 40 vCPUs, 80 GB RAM → run EC2 instances locally

**Key Features:**
- S3-compatible endpoint on device
- Cluster 5-15 devices for increased storage and durability
- Local compute for preprocessing data before shipping
- NFS interface for easy integration

**Use Cases:**
- Large data transfer (10-80 TB per device)
- Data center decommissioning
- Factory data collection with preprocessing
- Content distribution to remote locations

### 9.5 Snowball Edge Compute Optimized

**Capacity:** 42 TB HDD or 28 TB NVMe SSD

**Compute:** 104 vCPUs, 416 GB RAM, optional NVIDIA V100 GPU

**Key Features:**
- Most powerful compute option
- Supports EKS Anywhere for containerized workloads
- GPU for ML inference at the edge
- Long-term deployments (1-3 years)

**Use Cases:**
- ML inference at the edge (computer vision, NLP)
- Video transcoding at remote locations
- Industrial IoT analytics
- Disconnected military/defense applications

### 9.6 Snowmobile

**Capacity:** 100 PB per Snowmobile (45-foot shipping container)

**Use Cases:**
- Exabyte-scale data center migrations
- Video library migrations (media companies)
- Seismic data transfer (oil & gas)
- Genomics data (research institutions)

### 9.7 When to Use Each — Data Transfer Time Guide

```
Data to      Network         Online Transfer Time    Snow Device
Transfer     Bandwidth       (Theoretical)           Recommendation
─────────────────────────────────────────────────────────────────
10 TB        100 Mbps        ~10 days                Snowcone
10 TB        1 Gbps          ~1 day                  Online (DataSync)
50 TB        100 Mbps        ~50 days                Snowball Edge
50 TB        1 Gbps          ~5 days                 Online or Snowball
100 TB       1 Gbps          ~10 days                Snowball Edge (x2)
500 TB       1 Gbps          ~50 days                Snowball Edge (x7)
1 PB         10 Gbps         ~10 days                Snowball Edge (x13)
10 PB        10 Gbps         ~100 days               Snowball Edge cluster
100 PB       10 Gbps         ~1000 days              Snowmobile
```

**Rule of Thumb:**
- **< 10 TB + good bandwidth** → Online transfer (DataSync, S3 Transfer Acceleration)
- **10-80 TB or limited bandwidth** → Snowball Edge Storage Optimized
- **Need edge compute** → Snowball Edge Compute Optimized
- **< 14 TB + harsh/remote environment** → Snowcone
- **> 10 PB** → Snowmobile

### 9.8 Ordering and Data Transfer Process

```
Step 1: Order            Step 2: Receive         Step 3: Load Data
┌──────────┐           ┌──────────┐            ┌──────────┐
│ AWS      │           │ Device   │            │ Connect  │
│ Console  │──────────▶│ Shipped  │───────────▶│ to LAN   │
│ Order    │  2-5 days │ to Site  │            │ Copy data│
└──────────┘           └──────────┘            └──────┬───┘
                                                       │
Step 6: Data Available  Step 5: Ship Back     Step 4: Ready
┌──────────┐           ┌──────────┐            ┌──────┴───┐
│ Data in  │◀──────────│ Ship to  │◀───────────│ Power off│
│ S3 bucket│  1-2 days │ AWS      │  2-5 days  │ Prepare  │
│          │  process  │ facility │  shipping  │ for ship │
└──────────┘           └──────────┘            └──────────┘

Total turnaround: ~1-2 weeks
```

> **Exam Tip:** Snow Family decision = data volume + network bandwidth + edge compute needs. "60TB of data, 100 Mbps internet connection" → Snowball Edge (online would take ~60 days). "ML inference at edge, disconnected" → Snowball Edge Compute Optimized.

---

## 10. CloudEndure Migration

### 10.1 Overview (Legacy)

CloudEndure Migration was a free migration tool acquired by AWS. **Now replaced by AWS Application Migration Service (MGN).**

### 10.2 Key Differences from MGN

| Feature | CloudEndure (Legacy) | MGN (Current) |
|---|---|---|
| **Console** | Separate CloudEndure console | AWS Management Console |
| **Integration** | Limited AWS service integration | Full integration (CloudWatch, SSM, etc.) |
| **IAM** | Separate IAM | AWS IAM |
| **API** | CloudEndure API | AWS API |
| **Billing** | Free | Free (pay for target resources) |
| **Status** | End of life (2024) | **Active, recommended** |

> **Exam Tip:** If CloudEndure appears in the exam, treat it the same as MGN in terms of capabilities (continuous replication, minimal downtime). But for new migrations, always select MGN.

---

## 11. VM Import/Export

### 11.1 Overview

Import virtual machine images (VMDK, VHD, OVA) to EC2 AMIs. Export EC2 instances to VMDK/VHD.

### 11.2 Supported Formats

| Format | Platform |
|---|---|
| VMDK | VMware |
| VHD / VHDX | Hyper-V |
| OVA | Open Virtualization |
| RAW | Any |

### 11.3 Process

```
On-Premises                              AWS
┌──────────────┐                    ┌──────────────┐
│  Export VM    │   Upload to S3    │  S3 Bucket   │
│  as VMDK     │──────────────────▶│  (VM image)  │
│              │                    └──────┬───────┘
└──────────────┘                           │
                                    import-image API
                                           │
                                           ▼
                                    ┌──────────────┐
                                    │  EC2 AMI     │
                                    │  (converted) │
                                    └──────┬───────┘
                                           │
                                    Launch Instance
                                           │
                                           ▼
                                    ┌──────────────┐
                                    │  EC2 Instance│
                                    └──────────────┘
```

**CLI Example:**
```bash
aws ec2 import-image \
  --description "My Server Image" \
  --disk-containers "file://containers.json"
```

### 11.4 When to Use

- One-off VM imports (not large-scale)
- Creating AMIs from existing VM images
- Hybrid environments requiring VM export from AWS
- Disaster recovery: import VM backups to AWS

> **Exam Tip:** VM Import/Export is for one-off VM image conversions. For ongoing or large-scale migrations, use MGN. For database migrations, use DMS.

---

## 12. Migration Tool Selection Decision Framework

### 12.1 Tool Selection Matrix

| Migration Need | Primary Tool | Secondary Tool |
|---|---|---|
| **Server rehost (lift & shift)** | MGN | VM Import/Export |
| **VMware to VMware Cloud on AWS** | VMware HCX (vMotion) | MGN |
| **Database migration (same engine)** | DMS (Full Load + CDC) | Native tools (mysqldump, pg_dump) |
| **Database migration (different engine)** | SCT + DMS | Manual schema conversion + DMS |
| **Large data transfer (10-80 TB)** | Snowball Edge | DataSync (if bandwidth allows) |
| **Massive data transfer (>10 PB)** | Snowmobile | Multiple Snowball Edge |
| **Ongoing file sync (NFS/SMB → S3)** | DataSync | Storage Gateway |
| **SFTP server replacement** | AWS Transfer Family | EC2 + SFTP (self-managed) |
| **Application discovery** | Application Discovery Service | Migration Hub + manual inventory |
| **Migration tracking** | Migration Hub | Spreadsheets (not recommended) |
| **Edge computing + data transfer** | Snowball Edge Compute | Snowcone |
| **Schema conversion** | SCT | Manual |
| **Data warehouse migration** | SCT + DMS or SCT extraction agents | Redshift direct load from S3 |

### 12.2 Decision Flow

```
What are you migrating?
│
├── Servers/VMs ──────────────────────▶ MGN (rehost)
│                                       VMware HCX (relocate)
│
├── Databases ────────────────────────▶ Same engine? → DMS
│                                       Diff engine? → SCT + DMS
│
├── Files/Objects ────────────────────▶ Online + recurring? → DataSync
│                                       Online + SFTP? → Transfer Family
│                                       Offline + large? → Snow Family
│
├── Data Warehouse ───────────────────▶ SCT + DMS or
│                                       SCT extraction agents + S3 + Redshift
│
└── Applications (SaaS replacement) ──▶ Repurchase (no tool needed)
```

### 12.3 Bandwidth-Based Data Transfer Decision

```
Data Size vs. Available Bandwidth:

                    10 Mbps   100 Mbps   1 Gbps    10 Gbps
  ┌─────────────────────────────────────────────────────────┐
  │ 1 TB     │ 10 days  │ 1 day    │ 2 hrs   │ 15 min    │ → DataSync
  │ 10 TB    │ 100 days │ 10 days  │ 1 day   │ 2.5 hrs   │ → DataSync or Snowball
  │ 50 TB    │ 500 days │ 50 days  │ 5 days  │ 12 hrs    │ → Snowball Edge
  │ 100 TB   │ 1000 days│ 100 days │ 10 days │ 1 day     │ → Snowball Edge
  │ 500 TB   │ ∞        │ 500 days │ 50 days │ 5 days    │ → Multiple Snowball
  │ 10 PB    │ ∞        │ ∞        │ 1000 days│ 100 days │ → Snowmobile
  └─────────────────────────────────────────────────────────┘
  
  Shaded = Online transfer impractical → Use Snow Family
```

---

## 13. Exam Scenarios

### Scenario 1: Choosing the Right Data Transfer Method

**Question:** A company needs to transfer 60 TB of archival data to S3 Glacier. Their internet connection is 100 Mbps. They need the data in AWS within 2 weeks. What should they use?

**Answer:** **AWS Snowball Edge Storage Optimized**

**Reasoning:**
- 60 TB over 100 Mbps = ~55 days (too slow)
- Snowball Edge holds 80 TB → 1 device sufficient
- Order → Ship → Load → Ship back → Process = ~1-2 weeks
- Data loaded to S3, then lifecycle policy moves to Glacier

---

### Scenario 2: Continuous File Synchronization

**Question:** A company needs to continuously sync a 10 TB NFS file share from their data center to Amazon S3 for analytics. They have a 1 Gbps Direct Connect connection. Changes happen daily. What tool?

**Answer:** **AWS DataSync**

**Reasoning:**
- NFS → S3 = DataSync's primary use case
- Incremental sync (only changes) = efficient
- Scheduled task (daily) = built-in scheduling
- 1 Gbps Direct Connect = sufficient bandwidth
- DataSync agent deployed on-premises

---

### Scenario 3: Database Migration with Minimal Downtime

**Question:** A company is migrating a 5 TB Oracle database to Aurora PostgreSQL. The database must have less than 1 hour of downtime. What approach?

**Answer:** **AWS SCT (schema conversion) + AWS DMS (Full Load + CDC)**

**Reasoning:**
- Heterogeneous migration (Oracle → PostgreSQL) = SCT for schema
- SCT converts PL/SQL to PL/pgSQL, generates assessment report
- DMS Full Load copies initial 5 TB of data
- DMS CDC captures ongoing changes during full load
- When caught up: brief cutover window to switch applications
- Downtime only during final switchover (~30-60 minutes)

---

### Scenario 4: Replacing an SFTP Server

**Question:** A healthcare company has an on-premises SFTP server used by 500 trading partners to exchange EDI files. They want to migrate this to AWS. Partners must keep the same SFTP workflow. What solution?

**Answer:** **AWS Transfer Family (SFTP protocol)** with:
- VPC endpoint with Elastic IP (static IP for partners)
- S3 backend for file storage
- Custom Lambda identity provider (migrate existing user database)
- CloudWatch logging for audit compliance
- S3 event notifications → Lambda → process EDI files

---

### Scenario 5: Edge Computing with Data Collection

**Question:** A mining company needs to process sensor data at a remote mine with no internet connectivity. They need ML inference locally and periodic data transfer to AWS (every 2 weeks). What solution?

**Answer:** **AWS Snowball Edge Compute Optimized** with GPU

**Reasoning:**
- No internet → offline device required
- ML inference → GPU compute (NVIDIA V100)
- Periodic data transfer → ship device every 2 weeks, get new one
- Run EC2 instances locally for data processing
- 42 TB HDD storage for 2 weeks of sensor data

---

### Scenario 6: Large-Scale Server Migration

**Question:** A company is migrating 2,000 servers from their data center to AWS over 12 months. They need to track progress and manage the migration across multiple teams. What tools should they use for the overall migration program?

**Answer:**
1. **AWS Application Discovery Service** (agent-based) — Discover servers, map dependencies
2. **AWS Migration Hub** — Track overall migration progress, group into applications
3. **AWS Application Migration Service (MGN)** — Rehost servers (primary migration tool)
4. **AWS DMS** — Migrate databases
5. **AWS SCT** — Convert database schemas (if heterogeneous)

**Architecture:**
```
Discovery (Month 1-2)          Migration (Month 3-12)
┌────────────────┐            ┌────────────────┐
│ ADS Agents on  │            │ MGN Agents on  │
│ 2,000 servers  │            │ servers (waves)│
└───────┬────────┘            └───────┬────────┘
        │                             │
        ▼                             ▼
┌────────────────┐            ┌────────────────┐
│ Migration Hub  │            │ Migration Hub  │
│ (inventory +   │────────────│ (track status) │
│  dependency    │            │                │
│  mapping)      │            │                │
└────────────────┘            └────────────────┘
```

---

> **Key Exam Tips Summary:**
> 1. **MGN** = Default for server rehost (replaces SMS and CloudEndure)
> 2. **DMS** = Database migration (supports Full Load, CDC, or both)
> 3. **SCT** = Schema conversion for heterogeneous database migration (used WITH DMS)
> 4. **DataSync** = Online file/object transfer (NFS/SMB → S3/EFS)
> 5. **Transfer Family** = Managed SFTP/FTPS/FTP/AS2 server
> 6. **Snowball Edge** = Offline data transfer (10-80 TB per device) + edge compute
> 7. **Snowcone** = Small, portable (8-14 TB) + edge compute + DataSync agent
> 8. **Snowmobile** = Massive data transfer (up to 100 PB)
> 9. **Migration Hub** = Tracking layer (doesn't migrate, tracks migration)
> 10. **Application Discovery Service** = Inventory and dependency mapping (agent for dependencies, agentless for VMware inventory)
