# RDS & Aurora Deep Dive

## Table of Contents

1. [Amazon RDS Overview](#amazon-rds-overview)
2. [RDS Database Engines](#rds-database-engines)
3. [RDS Instance Classes](#rds-instance-classes)
4. [RDS Storage Types](#rds-storage-types)
5. [RDS Multi-AZ Deployments](#rds-multi-az-deployments)
6. [RDS Read Replicas](#rds-read-replicas)
7. [Multi-AZ vs Read Replicas Comparison](#multi-az-vs-read-replicas-comparison)
8. [RDS Backup and Recovery](#rds-backup-and-recovery)
9. [RDS Encryption](#rds-encryption)
10. [RDS Proxy](#rds-proxy)
11. [RDS Custom](#rds-custom)
12. [RDS on Outposts](#rds-on-outposts)
13. [Amazon Aurora Overview](#amazon-aurora-overview)
14. [Aurora Storage Architecture](#aurora-storage-architecture)
15. [Aurora Replicas](#aurora-replicas)
16. [Aurora Endpoints](#aurora-endpoints)
17. [Aurora Serverless v2](#aurora-serverless-v2)
18. [Aurora Global Database](#aurora-global-database)
19. [Aurora Multi-Master](#aurora-multi-master)
20. [Aurora Machine Learning](#aurora-machine-learning)
21. [Aurora Backtrack](#aurora-backtrack)
22. [Aurora Cloning](#aurora-cloning)
23. [RDS Event Notifications](#rds-event-notifications)
24. [Performance Insights & Enhanced Monitoring](#performance-insights--enhanced-monitoring)
25. [RDS Parameter Groups & Option Groups](#rds-parameter-groups--option-groups)
26. [Common Exam Scenarios](#common-exam-scenarios)

---

## Amazon RDS Overview

Amazon Relational Database Service (RDS) is a managed relational database service that simplifies setup, operation, and scaling of databases in the cloud. AWS manages the underlying infrastructure—hardware provisioning, database setup, patching, and backups—allowing you to focus on application logic.

### What RDS Manages For You

- Operating system patching
- Database software installation and patching
- Automated backups and snapshots
- Monitoring and metrics
- Multi-AZ synchronous replication for high availability
- Read replicas for read scalability
- Storage auto-scaling
- Maintenance windows for updates

### What You CANNOT Do with RDS

- SSH into the underlying EC2 instance (except RDS Custom)
- Access the OS-level file system
- Install custom software on the host
- Modify database binaries directly

---

## RDS Database Engines

RDS supports six database engines, each with its own characteristics and licensing model.

### MySQL

- Open-source relational database
- Versions supported: MySQL 5.7, 8.0
- Maximum storage: 64 TiB
- Maximum read replicas: 5 (within RDS), up to 15 with Aurora MySQL
- Supports InnoDB storage engine (recommended)
- License: GPL (free, included in RDS pricing)

### PostgreSQL

- Advanced open-source relational database
- Versions supported: PostgreSQL 12 through 16
- Maximum storage: 64 TiB
- Supports advanced data types: JSON, arrays, hstore
- Strong support for geospatial data (PostGIS)
- License: PostgreSQL license (free, included in RDS pricing)

### MariaDB

- MySQL fork with enhanced features
- Versions supported: MariaDB 10.4 through 10.11
- Maximum storage: 64 TiB
- Thread pool for better concurrency
- Aria storage engine
- License: GPL (free, included in RDS pricing)

### Oracle

- Enterprise-grade commercial database
- Editions: Standard Edition Two (SE2), Enterprise Edition (EE)
- License models:
  - **License Included**: Oracle SE2 license included in hourly price
  - **BYOL (Bring Your Own License)**: Use existing Oracle licenses; available for all editions
- Maximum storage: 64 TiB
- Supports Oracle-specific features: RAC (only on RDS Custom), TDE, Oracle Data Guard
- Note: Multi-AZ uses Oracle Data Guard for standby replication

### SQL Server

- Microsoft's enterprise database
- Editions: Express, Web, Standard, Enterprise
- License models:
  - **License Included**: All editions available
  - **BYOL**: Enterprise Edition only
- Maximum storage: 16 TiB
- Supports SQL Server-specific features: SSRS, SSIS (via RDS Custom), Always On (Multi-AZ)
- Note: Multi-AZ uses SQL Server Always On Availability Groups (mirroring for older versions)

### Engine Selection Exam Tips

- If the question mentions "Oracle RAC" → RDS Custom or EC2 (not standard RDS)
- If "open-source" is a requirement → MySQL, PostgreSQL, or MariaDB
- If the question mentions "BYOL" → Oracle or SQL Server
- If PostgreSQL with massive scale is needed → Aurora PostgreSQL

---

## RDS Instance Classes

RDS instance classes determine the compute and memory capacity of your database instance.

### Standard Instance Classes (db.m)

- **db.m5**: General purpose, Intel Xeon Platinum
- **db.m6g**: General purpose, AWS Graviton2 (ARM-based, better price/performance)
- **db.m6i**: General purpose, 3rd Gen Intel Xeon
- **db.m7g**: General purpose, AWS Graviton3
- Best for: Most production workloads with balanced compute and memory

### Memory-Optimized Instance Classes (db.r)

- **db.r5**: Memory optimized, Intel Xeon Platinum
- **db.r6g**: Memory optimized, AWS Graviton2
- **db.r6i**: Memory optimized, 3rd Gen Intel Xeon
- **db.r7g**: Memory optimized, AWS Graviton3
- **db.x1, db.x2g**: Extreme memory (up to 4 TiB RAM)
- Best for: Memory-intensive workloads, large datasets, complex queries

### Burstable Instance Classes (db.t)

- **db.t3**: Burstable, Intel Xeon
- **db.t3.micro**: Free tier eligible (750 hours/month for 12 months)
- **db.t4g**: Burstable, Graviton2
- Uses CPU credit model (similar to EC2 burstable)
- Best for: Dev/test environments, small production workloads with variable CPU usage
- **Warning**: NOT recommended for production workloads with sustained high CPU

### Exam Tips on Instance Classes

- Graviton-based instances (suffix "g") provide up to 35% better price/performance
- For cost optimization questions, moving from Intel to Graviton is a valid answer
- Burstable instances (db.t) are cost-effective for intermittent workloads

---

## RDS Storage Types

RDS uses Amazon EBS volumes for database and log storage. Understanding storage types is critical for the exam.

### General Purpose SSD (gp2)

- Volume size: 20 GiB – 64 TiB
- Baseline IOPS: 3 IOPS per GiB (minimum 100 IOPS)
- Maximum IOPS: 16,000 (at 5,334 GiB and above)
- Burst capability: Up to 3,000 IOPS for volumes under 1,000 GiB
- Throughput: Up to 250 MiB/s
- **Key formula**: Baseline IOPS = Volume Size (GiB) × 3
- Cost: Charged per GiB provisioned per month

### General Purpose SSD (gp3)

- Volume size: 20 GiB – 64 TiB
- Baseline IOPS: 3,000 IOPS (regardless of volume size)
- Maximum IOPS: 16,000 (can be provisioned independently)
- Baseline throughput: 125 MiB/s
- Maximum throughput: 1,000 MiB/s
- **Key advantage over gp2**: IOPS and throughput are decoupled from storage size
- Cost: Lower baseline cost; IOPS and throughput charged separately if above baseline
- **Recommended** over gp2 for most workloads (better cost efficiency)

### Provisioned IOPS SSD (io1/io2)

- Volume size: 20 GiB – 64 TiB
- IOPS: 1,000 – 256,000 (io2 Block Express)
- Standard io1: Up to 64,000 IOPS
- IOPS-to-storage ratio: Up to 50:1 (io1) or 1,000:1 (io2 Block Express)
- Throughput: Up to 4,000 MiB/s (io2 Block Express)
- **Use case**: I/O-intensive workloads, consistent high IOPS (OLTP databases)
- **Multi-Attach** not available for RDS (only EC2)
- Best for: Production databases requiring predictable, sustained IOPS

### Magnetic (standard) — Previous Generation

- Volume size: 20 GiB – 3 TiB
- Maximum IOPS: ~100
- **NOT recommended** for new deployments
- Lowest cost storage option
- Still appears on exam as a distractor for cost optimization (but gp3 is better)

### Storage Auto Scaling

- Automatically scales storage when free space falls below 10%
- Must set **Maximum Storage Threshold**
- Scaling occurs when:
  - Free storage is less than 10% of allocated storage
  - Low-storage condition lasts at least 5 minutes
  - At least 6 hours have passed since last modification
- Supported for all storage types
- **Exam tip**: Enable storage auto scaling for unpredictable workloads to avoid running out of storage

### Storage Comparison Table

| Feature | gp2 | gp3 | io1/io2 | Magnetic |
|---------|-----|-----|---------|----------|
| Max Size | 64 TiB | 64 TiB | 64 TiB | 3 TiB |
| Max IOPS | 16,000 | 16,000 | 256,000 | ~100 |
| Baseline IOPS | 3/GiB | 3,000 | Provisioned | N/A |
| Throughput | 250 MiB/s | 1,000 MiB/s | 4,000 MiB/s | Low |
| Cost | $$ | $ | $$$$ | $ |
| Best For | General | General (new) | High IOPS | Legacy |

---

## RDS Multi-AZ Deployments

Multi-AZ provides high availability and durability for RDS database instances.

### How Multi-AZ Works

1. AWS provisions a **synchronous standby replica** in a different Availability Zone
2. The primary and standby share the same DNS endpoint
3. All writes to the primary are **synchronously replicated** to the standby
4. Standby is **NOT accessible** for reads or writes (it's purely for failover)
5. Automatic failover occurs by updating the DNS record to point to the standby

### Multi-AZ Failover Process

Failover is triggered automatically in these scenarios:
- Primary instance failure (hardware or software)
- OS patching on primary
- Network connectivity loss to primary
- AZ-level failure
- Manual failover (via reboot with failover option)

**Failover timeline**: Typically completes within 60-120 seconds. DNS TTL is set to 5 seconds by default.

### Multi-AZ Deployment Options

#### Single-Instance Multi-AZ (Classic)

- One primary + one standby in a different AZ
- Synchronous replication
- Standby is NOT readable
- Automatic DNS failover
- Available for all engines

#### Multi-AZ DB Cluster (New for MySQL and PostgreSQL)

- One writer instance + two reader instances across 3 AZs
- Uses **semisynchronous replication**
- Reader instances ARE readable (can serve read traffic)
- Provides up to 2x the write performance and faster failover (~35 seconds)
- Only available for MySQL 8.0.28+ and PostgreSQL 13.4+
- Uses a **cluster endpoint** (writer) and **reader endpoint**
- Transaction log-based replication (faster than traditional Multi-AZ)

### Multi-AZ Limitations

- Standby (classic) cannot serve read traffic
- Failover causes brief downtime (DNS propagation)
- Only spans two AZs within the same region (classic)
- Cannot use standby for backups (backups taken from primary, may cause I/O suspension on non-Multi-AZ)
- Actually, with Multi-AZ, backups are taken from the standby (reducing I/O impact on primary)
- Cross-region HA requires Read Replicas (not Multi-AZ)

### Multi-AZ Cost

- Roughly 2x the cost of a single-instance deployment (you pay for both instances)
- No additional charge for data replication between AZs

---

## RDS Read Replicas

Read Replicas provide enhanced performance and durability by creating read-only copies of your database.

### How Read Replicas Work

1. RDS creates a snapshot of the primary instance
2. A new instance is created from that snapshot
3. **Asynchronous replication** is established from the primary to the replica
4. All changes on the primary are asynchronously replicated
5. Applications can direct read queries to the replica's own endpoint
6. There may be **replication lag** (milliseconds to seconds typically)

### Read Replica Configuration

- **Maximum replicas**: Up to 5 for MySQL, MariaDB, PostgreSQL, Oracle; up to 15 for Aurora
- **Cross-AZ**: Supported (within same region)
- **Cross-Region**: Supported (additional data transfer charges apply)
- **Replica of a Replica**: Supported (chaining), but increases replication lag
- **Replica from Multi-AZ**: Supported (snapshot taken from standby to minimize impact)
- **Separate DNS endpoint** for each replica

### Read Replica Promotion

- A Read Replica can be **promoted to a standalone database instance**
- Promotion breaks the replication link permanently
- The promoted instance becomes a fully independent database
- Common use case: Disaster recovery — promote cross-region replica if primary region fails
- Promotion takes several minutes

### Read Replica Use Cases

1. **Read scaling**: Distribute read-heavy traffic across multiple replicas
2. **Reporting/Analytics**: Run complex queries against a replica without impacting production
3. **Disaster recovery**: Cross-region replica can be promoted if the primary region fails
4. **Migration**: Create a cross-region replica, promote it, switch application traffic

### Read Replica Network Cost

- **Same Region, same AZ**: Free (no data transfer charge)
- **Same Region, different AZ**: Free (within RDS, cross-AZ replication is free)
- **Cross-Region**: Data transfer charges apply (inter-region data transfer)

### Read Replica Requirements

- Automated backups must be enabled on the primary (retention period > 0)
- Source DB must be running a supported engine version
- For MySQL: InnoDB engine required (MyISAM not supported for replication)

---

## Multi-AZ vs Read Replicas Comparison

| Feature | Multi-AZ | Read Replicas |
|---------|----------|---------------|
| **Purpose** | High availability | Read scalability |
| **Replication** | Synchronous | Asynchronous |
| **Readable** | No (standby not accessible) | Yes (read-only) |
| **Region** | Same region only | Same or cross-region |
| **Endpoints** | Same DNS endpoint | Separate endpoint per replica |
| **Failover** | Automatic (DNS flip) | Manual (promotion) |
| **Max Count** | 1 standby (classic), 2 readers (cluster) | 5 (standard), 15 (Aurora) |
| **Replication Lag** | None (synchronous) | Possible (asynchronous) |
| **Backups Impact** | Taken from standby | Can be taken from replica |
| **Cost** | 2x (both instances) | Per replica instance |
| **Use Case** | Fault tolerance | Performance, DR |
| **Can Be Combined** | Yes | Yes |

**Key Exam Point**: Multi-AZ is for **availability**, Read Replicas are for **scalability**. You can have both enabled simultaneously (a Multi-AZ primary with Read Replicas).

---

## RDS Backup and Recovery

### Automated Backups

- **Retention period**: 0 to 35 days (0 disables automated backups)
- Default retention: 7 days
- Automated backups are taken during the **backup window** (configurable)
- Creates a storage volume snapshot of the entire DB instance
- Transaction logs are captured every 5 minutes
- Supports **Point-in-Time Recovery (PITR)** to any second within the retention period
- Backups are stored in S3 (managed by AWS, not visible in your S3 console)
- First snapshot is a full snapshot; subsequent snapshots are incremental
- For Multi-AZ: Backup taken from standby (no I/O suspension on primary)
- For Single-AZ: Brief I/O suspension during backup (may cause latency)

### Point-in-Time Recovery (PITR)

- Restores to any specific second within the backup retention period
- Creates a **new DB instance** (does not restore in-place)
- Uses the most recent daily backup + transaction logs to reconstruct the database state
- Recovery time depends on the amount of transaction log data to replay
- **Exam tip**: PITR always creates a new RDS instance with a new endpoint

### Manual Snapshots

- User-initiated snapshots
- Retained **indefinitely** (until manually deleted) — even after RDS instance deletion
- Can be shared with other AWS accounts or made public
- Can be copied to other regions
- Used for long-term backup retention beyond the 35-day automated backup limit
- **Exam tip**: If you need to retain a backup beyond 35 days, use manual snapshots

### Backup Strategy Exam Scenarios

- "Retain database backup for compliance for 7 years" → Manual snapshots (automated backups max 35 days)
- "Minimize cost for infrequently used database" → Take final snapshot, delete instance, restore when needed
- "Restore database to 3 hours ago" → PITR within retention period
- "Share database backup with another account" → Share manual snapshot

### Restoring from Backup

- Restoring always creates a **new DB instance**
- New instance has a new endpoint, new parameter group (default), new security group (default)
- You must update your application to point to the new endpoint
- The new instance gets the default parameter group and option group (you may need to re-associate custom ones)

---

## RDS Encryption

### Encryption at Rest

- Uses **AWS KMS** (Key Management Service) for encryption
- AES-256 encryption algorithm
- Encryption is defined at **creation time** (cannot enable on existing unencrypted DB without migration)
- Encrypts the underlying storage, automated backups, snapshots, and read replicas
- If the master is encrypted, all read replicas must be encrypted
- If the master is unencrypted, read replicas cannot be encrypted

### Encrypting an Unencrypted Database

This is a multi-step process (commonly tested on the exam):

1. Create a snapshot of the unencrypted database
2. Copy the snapshot and enable encryption on the copy
3. Restore a new database instance from the encrypted snapshot
4. Redirect application to the new (encrypted) database
5. Delete the old unencrypted database

### Encryption in Transit

- SSL/TLS connections supported for all engines
- To enforce SSL:
  - **PostgreSQL**: Set `rds.force_ssl = 1` in parameter group
  - **MySQL**: Execute `GRANT USAGE ON *.* TO 'user'@'%' REQUIRE SSL;`
  - **SQL Server**: Set `rds.force_ssl = 1` in parameter group
  - **Oracle**: Add SSL option to the option group
- Download the RDS root certificate from AWS to establish trust
- To verify SSL is being used, check the connection status in your client

### Transparent Data Encryption (TDE)

- Available for **Oracle** and **SQL Server** only
- Encrypts data before writing to storage, decrypts when reading
- Works alongside RDS encryption (can use both)
- Oracle TDE integrates with CloudHSM for key management
- SQL Server TDE managed through option groups

---

## RDS Proxy

Amazon RDS Proxy is a fully managed, highly available database proxy that sits between your application and your RDS database.

### How RDS Proxy Works

1. Application connects to RDS Proxy endpoint instead of the database directly
2. RDS Proxy maintains a **connection pool** to the database
3. Connections are reused efficiently, reducing database resource consumption
4. Supports failover-aware connections for Multi-AZ

### Key Features

- **Connection pooling**: Shares and reuses database connections
- **Reduced failover time**: Up to 66% faster failover for Multi-AZ
- **IAM authentication**: Enforce IAM authentication for database access
- **Secrets Manager integration**: Stores database credentials in Secrets Manager
- **Multiplexing**: Routes multiple application connections through fewer database connections

### When to Use RDS Proxy

1. **Lambda functions**: Lambda creates many short-lived connections that can overwhelm the database
   - Lambda + RDS without Proxy = connection exhaustion
   - Lambda + RDS Proxy = efficient connection management
2. **Applications with many connections**: Microservices architecture with many clients
3. **Unpredictable workloads**: Connection surges from auto-scaling applications
4. **Enhanced security**: Enforce IAM-based authentication, keep credentials in Secrets Manager

### RDS Proxy Configuration

- Deployed within your **VPC** (never publicly accessible)
- Supports RDS MySQL, RDS PostgreSQL, and Aurora (MySQL and PostgreSQL)
- Supports Multi-AZ for high availability of the proxy itself
- Compatible with most database clients (no code changes needed, just change the endpoint)
- Maximum connections to the database can be configured (percentage of max_connections)

### RDS Proxy with Lambda

- Lambda functions run inside a VPC to access RDS Proxy
- RDS Proxy is the **recommended pattern** for Lambda-to-RDS connectivity
- Without Proxy: Each Lambda invocation opens a new connection → connection exhaustion
- With Proxy: Lambda connects to Proxy → Proxy manages a pool of connections to RDS

### Exam Tips for RDS Proxy

- "Lambda functions timing out when connecting to RDS" → RDS Proxy
- "Too many database connections" → RDS Proxy
- "Reduce database failover time" → RDS Proxy
- "Enforce IAM authentication for database access" → RDS Proxy

---

## RDS Custom

RDS Custom provides the managed benefits of RDS combined with OS and database customization capabilities.

### Supported Engines

- **Oracle**: Oracle Database 12c, 19c (Enterprise Edition, BYOL only)
- **SQL Server**: SQL Server 2019 (Enterprise, Standard, Web editions)

### What RDS Custom Allows

- Full administrative access to the underlying **operating system**
- Access to the **database** with admin (DBA) privileges
- Install custom software, patches, and agents
- Modify the file system for features requiring OS-level changes
- Configure settings that aren't available through standard RDS parameter groups
- SSH or RDP into the host instance

### How It Works

- RDS Custom runs on an EC2 instance that appears in your account
- You can see the EC2 instance in the EC2 console
- AWS manages backups, patching, and high availability (if enabled)
- You can pause automation to make custom changes, then resume
- **Automation mode**: Full (AWS manages everything), Paused (you control temporarily)

### Use Cases

- Oracle applications requiring OS-level access (custom scripts, agents)
- SQL Server with SSIS, SSRS, or SSAS packages
- Applications requiring custom database patches not yet available in standard RDS
- Compliance requirements needing OS-level auditing agents

---

## RDS on Outposts

AWS Outposts extends AWS infrastructure to on-premises locations.

### Key Points

- Run RDS on AWS Outposts hardware in your data center
- Supports MySQL, PostgreSQL, SQL Server
- Provides local data residency
- Managed by AWS (patching, backups, etc.)
- Automated backups are stored on the Outpost (local S3 on Outposts)
- Multi-AZ **not supported** on Outposts (single Outpost = single location)
- Use cases: Low-latency access to on-premises applications, data residency requirements

---

## Amazon Aurora Overview

Amazon Aurora is a MySQL and PostgreSQL-compatible relational database built for the cloud that combines the performance and availability of high-end commercial databases with the simplicity and cost-effectiveness of open-source databases.

### Aurora vs Standard RDS

- **5x throughput** of MySQL on RDS
- **3x throughput** of PostgreSQL on RDS
- Up to **128 TiB** of auto-scaling storage (vs 64 TiB for RDS)
- Up to **15 read replicas** (vs 5 for RDS)
- **Faster failover**: Typically under 30 seconds
- **20% more expensive** than standard RDS, but much more efficient
- Built-in fault tolerance and self-healing storage

### Aurora Compatibility

- **Aurora MySQL**: Compatible with MySQL 5.7 and 8.0
- **Aurora PostgreSQL**: Compatible with PostgreSQL 12 through 16
- Existing MySQL and PostgreSQL applications work with Aurora with minimal changes
- Same drivers, tools, and applications can be used

---

## Aurora Storage Architecture

Aurora's storage is fundamentally different from standard RDS and is one of the most important concepts for the exam.

### Shared Cluster Storage Volume

- Aurora uses a **shared distributed storage volume**
- Storage is separate from compute (unlike RDS where each instance has its own EBS)
- All instances in the cluster (writer + readers) access the **same storage volume**

### Six Copies Across Three AZs

- Data is automatically replicated **6 times** across **3 Availability Zones**
- 2 copies in each AZ
- **Quorum model**:
  - Writes require 4 out of 6 copies (can tolerate loss of 1 AZ)
  - Reads require 3 out of 6 copies
- Self-healing: If a copy is corrupted, Aurora automatically repairs it using peer-to-peer replication

### 10 GB Segments (Protection Groups)

- Storage is divided into **10 GB segments** called protection groups
- Each segment is replicated 6 times
- If a segment fails, Aurora repairs it in approximately 10 seconds
- This architecture provides extremely fast recovery from disk failures

### Auto-Scaling Storage

- Storage automatically grows in **10 GB increments**
- Minimum: 10 GiB
- Maximum: **128 TiB**
- You do **not** need to provision storage in advance
- You only pay for storage that you use
- Storage cannot be scaled down (only up)

### Storage Performance

- Replication happens at the storage layer (not database engine layer)
- Minimal replication lag (typically < 10ms for replica lag)
- Storage I/O is distributed across many disks
- No need to provision IOPS (handled automatically)
- Aurora I/O-Optimized pricing option: pay more for instance, no I/O charges

---

## Aurora Replicas

### Aurora Replica vs MySQL Read Replica

Aurora supports two types of replicas:

| Feature | Aurora Replica | MySQL Read Replica |
|---------|---------------|--------------------|
| Number | Up to 15 | Up to 5 |
| Replication | Storage-level (shared volume) | Engine-level (binlog) |
| Replica Lag | Typically < 10ms | Seconds to minutes |
| Failover Target | Yes (automatic) | No (manual promotion) |
| Impact on Primary | None | Some performance impact |

### Aurora Replica Auto Scaling

- Configure auto scaling policies based on metrics (CPU utilization, connections)
- Aurora automatically adds or removes replicas based on demand
- Replicas are added from a configured instance class
- Scaling policy defines minimum and maximum number of replicas
- Target tracking: Set a target value for a metric (e.g., CPU < 70%)

### Aurora Priority Tiers

- Each Aurora replica has a **priority tier** (0 to 15)
- **Tier 0** is the highest priority for failover
- If multiple replicas share the same tier, Aurora promotes the one with the largest size
- Useful for controlling which replica becomes the writer during failover
- Example: Set a larger instance in tier 0 as the preferred failover target

### Failover Behavior

1. Aurora checks for existing replicas
2. Promotes the replica with the **lowest tier number**
3. If tier numbers are equal, promotes the **largest instance**
4. If no replicas exist, creates a new instance (takes longer)
5. Failover typically completes in **under 30 seconds**

---

## Aurora Endpoints

Aurora provides several endpoint types to manage connections efficiently.

### Cluster Endpoint (Writer Endpoint)

- Points to the current **primary (writer) instance**
- Automatically updated during failover
- Use for all **write operations** and DDL statements
- Format: `mydbcluster.cluster-xxxxxxxxxxxx.us-east-1.rds.amazonaws.com`

### Reader Endpoint

- Provides **load-balanced** connection across all Aurora replicas
- Uses round-robin DNS to distribute read traffic
- Automatically excludes the writer instance
- If no replicas exist, reader endpoint points to the writer
- Format: `mydbcluster.cluster-ro-xxxxxxxxxxxx.us-east-1.rds.amazonaws.com`

### Custom Endpoints

- User-defined endpoints that map to a **subset** of instances
- Use cases:
  - Direct analytical queries to larger instances
  - Separate reporting traffic from application traffic
  - Create endpoints for different application tiers
- When custom endpoints are defined, the **reader endpoint may not be usable** (depends on configuration)
- You can create multiple custom endpoints per cluster

### Instance Endpoints

- Direct connection to a **specific instance**
- Each instance has its own unique endpoint
- Useful for diagnostics or when you need to connect to a specific replica
- Not recommended for production application connections (no failover)

---

## Aurora Serverless v2

Aurora Serverless v2 provides on-demand, auto-scaling capacity for Aurora.

### How It Works

- Scales in increments of **Aurora Capacity Units (ACUs)**
- Each ACU provides approximately 2 GiB of memory + corresponding CPU and networking
- You configure a **minimum** and **maximum** ACU range
- Minimum: 0.5 ACU
- Maximum: 128 ACU
- Scales in increments of **0.5 ACU**
- Scaling is **near-instantaneous** (no cold starts like Serverless v1)

### Key Differences from Serverless v1

| Feature | Serverless v1 | Serverless v2 |
|---------|---------------|---------------|
| Scaling | Scale to 0 possible | Min 0.5 ACU |
| Scaling Speed | 5-50 seconds (cold start) | Near-instant |
| Multi-AZ | No | Yes |
| Read Replicas | No | Yes |
| Global Database | No | Yes |
| Fine-grained Scaling | 1 ACU increments | 0.5 ACU increments |

### Use Cases

- **Variable workloads**: Applications with unpredictable traffic patterns
- **Development/Test**: Low-cost environments that scale down when idle
- **Multi-tenant SaaS**: Different tenants with different usage patterns
- **Mixed workloads**: Combine provisioned writer with serverless readers
- **New applications**: When workload patterns are unknown

### Pricing

- Pay per ACU-hour consumed (prorated per second)
- No charge for storage I/O with I/O-Optimized
- Standard storage charges still apply

---

## Aurora Global Database

Aurora Global Database spans multiple AWS regions, enabling disaster recovery and low-latency global reads.

### Architecture

- **1 primary region**: Handles all write operations
- **Up to 5 secondary regions**: Read-only, with up to 16 replicas each
- Total: 1 primary + up to 80 read replicas across secondary regions
- Replication uses a dedicated infrastructure (not engine-level replication)
- **Replication lag**: Typically under 1 second cross-region

### RPO and RTO

- **RPO (Recovery Point Objective)**: Less than 1 second (< 1s)
- **RTO (Recovery Time Objective)**: Less than 1 minute (< 1 min)
- These are key numbers for the exam

### Failover (Managed Planned Failover vs Unplanned Failover)

**Managed Planned Failover** (switchover):
- Graceful operation with no data loss
- Used for operational maintenance, region migration
- Demotes the primary cluster to secondary
- Promotes a secondary cluster to primary
- RPO = 0 (no data loss)

**Unplanned Failover** (detach and promote):
- Used for disaster recovery when the primary region is unavailable
- Detach a secondary region and promote it to primary
- Some data loss possible (up to the replication lag)
- RPO < 1 second

### Use Cases

- **Disaster recovery**: Promote secondary region if primary fails
- **Low-latency global reads**: Users read from the closest region
- **Regional migration**: Move primary region with minimal downtime
- **Compliance**: Keep read replicas in specific regions for data residency

### Write Forwarding

- Secondary region replicas can forward write requests to the primary region
- Application in secondary region doesn't need to know the primary endpoint
- Adds latency (cross-region network trip for writes)
- Useful for simplifying global application architecture

---

## Aurora Multi-Master

**Note**: Aurora Multi-Master has been deprecated (since November 2023), but may still appear on the SAA-C03 exam.

### Key Concepts

- All instances in the cluster are **read/write**
- No single point of failure for writes
- If one writer fails, another writer immediately takes over
- Provides **continuous write availability** (no failover needed)
- Only supported for Aurora MySQL 5.6 (limited compatibility)
- Limited to **2 instances** in the same region

### When It Might Appear on Exam

- "Application requires continuous write availability with zero downtime for writes"
- "No single point of failure for write operations"
- Note: The exam may accept this as a valid answer for legacy scenarios

---

## Aurora Machine Learning

Aurora Machine Learning enables adding ML-based predictions to applications via SQL queries.

### Supported Services

- **Amazon SageMaker**: Custom ML models, any algorithm
- **Amazon Comprehend**: Sentiment analysis, language detection
- **Amazon Bedrock**: Generative AI models

### How It Works

1. Define an Aurora ML function that maps to a SageMaker/Comprehend endpoint
2. Call the function from SQL queries
3. Aurora handles data transfer to/from the ML service
4. Results are returned as part of the SQL query result

### Use Cases

- Fraud detection: Run predictions on transactions in real-time
- Sentiment analysis: Analyze customer feedback stored in the database
- Product recommendations: Generate recommendations from user behavior data
- Ad targeting: Score users for ad targeting based on database data

---

## Aurora Backtrack

Aurora Backtrack allows you to rewind your Aurora DB cluster to a specific point in time **without creating a new cluster**.

### How It Works

- Backtrack "rewinds" the database to the specified timestamp
- Does NOT create a new DB instance (unlike PITR)
- Operates **in-place** on the existing cluster
- Must be enabled at cluster creation time (cannot be enabled later)
- Requires specifying a **backtrack window** (maximum 72 hours)

### Backtrack vs PITR

| Feature | Backtrack | Point-in-Time Recovery |
|---------|-----------|----------------------|
| New instance? | No (in-place) | Yes (new cluster) |
| Speed | Seconds to minutes | Can take hours |
| Maximum window | 72 hours | Up to 35 days |
| Enable time | At creation only | Always available |
| Availability | Aurora MySQL only | All RDS/Aurora engines |

### Use Cases

- Quickly undo accidental data changes (wrong DELETE/UPDATE)
- Test data migrations with easy rollback
- Explore "what if" scenarios

### Limitations

- Only available for **Aurora MySQL** (not PostgreSQL)
- Must be enabled at cluster creation (cannot add later)
- Maximum backtrack window: 72 hours
- Not available for Aurora Global Database clusters
- Cross-region replicas are not backtracked (they remain at current state)

---

## Aurora Cloning

Aurora Cloning creates a new Aurora cluster from an existing one using a **copy-on-write protocol**.

### Copy-on-Write Protocol

1. The clone initially points to the **same underlying data pages** as the source
2. No data is copied at creation time (clone is created almost instantly)
3. When data is modified on either the source or clone, **only the changed pages are copied**
4. Over time, as more pages diverge, the clone gradually accumulates its own storage

### Key Characteristics

- **Near-instant creation**: No waiting for full data copy
- **Cost-effective**: Storage is shared until data diverges
- **Independent**: Clone is a fully independent cluster (changes don't affect source)
- **Same region only**: Clone must be in the same region as the source

### Use Cases

- **Testing and development**: Create a production clone for testing without impacting production
- **Running analytical queries**: Clone production data for analytics without affecting performance
- **Data recovery experimentation**: Clone to test recovery procedures
- **Production debugging**: Investigate issues against production data safely

### Clone vs Snapshot Restore

| Feature | Clone | Snapshot Restore |
|---------|-------|-----------------|
| Speed | Near-instant | Minutes to hours |
| Initial Storage | Shared (copy-on-write) | Full copy |
| Cost | Lower (shared pages) | Higher (full copy) |
| Region | Same region only | Can restore cross-region |
| Independence | Full | Full |

---

## RDS Event Notifications

### Overview

- RDS publishes events to **Amazon SNS** topics
- Events include: instance creation, modification, deletion, failover, backup, maintenance, etc.
- Can subscribe to specific event categories

### Event Categories

- **Availability**: Failover, restart, Multi-AZ changes
- **Backup**: Backup started, completed, failed
- **Configuration Change**: Parameter group, security group changes
- **Creation**: New instance, snapshot, replica creation
- **Deletion**: Instance or snapshot deletion
- **Failover**: Multi-AZ failover started, completed
- **Failure**: Instance failure, incompatible parameters
- **Maintenance**: Maintenance window, patching
- **Recovery**: Instance recovery
- **Restoration**: Restore from snapshot, PITR

### Event Notification Setup

1. Create an SNS topic
2. Subscribe to the topic (email, Lambda, SQS, HTTP, etc.)
3. Create an RDS event subscription specifying:
   - Source type (DB instance, DB cluster, snapshot, etc.)
   - Source identifiers (specific instances or "all")
   - Event categories to subscribe to

### Exam Tip

- RDS Event Notifications are **near real-time** (not guaranteed instant)
- For more detailed monitoring, use CloudWatch Events/EventBridge
- RDS events are also sent to EventBridge (more flexible routing)

---

## Performance Insights & Enhanced Monitoring

### Performance Insights

- **Free tier**: 7 days of performance data history
- **Paid**: Longer retention periods available
- Provides a dashboard to visualize database load
- **Key metric**: DB Load — measured in Average Active Sessions (AAS)
- Can identify:
  - Top SQL queries consuming resources
  - Top wait events (I/O, locks, CPU, etc.)
  - Top hosts/users generating load
- Dimensions: Waits, SQL, Hosts, Users, Databases
- **Counter Metrics**: OS and database-level metrics
- Available for all RDS engines and Aurora

### Enhanced Monitoring

- Provides **OS-level metrics** at granularity of 1 second (vs CloudWatch at 1 minute minimum)
- Metrics include: CPU, memory, file system, disk I/O per process
- Data sent to **CloudWatch Logs**
- Requires an IAM role for the RDS instance
- **Key difference from CloudWatch**: Enhanced Monitoring provides per-process detail
- Useful for identifying resource contention at the OS level

### CloudWatch Metrics for RDS

- **Standard metrics** (free, 1-minute granularity):
  - CPUUtilization
  - DatabaseConnections
  - FreeableMemory
  - ReadIOPS, WriteIOPS
  - ReadLatency, WriteLatency
  - FreeStorageSpace
  - ReplicaLag (for Read Replicas)
  - BurstBalance (for gp2)
- **Enhanced Monitoring**: OS-level metrics at 1-second granularity

### Monitoring Comparison

| Aspect | CloudWatch | Enhanced Monitoring | Performance Insights |
|--------|-----------|-------------------|---------------------|
| Level | Instance | OS processes | Database engine |
| Granularity | 1 min (5 min free) | 1 second | 1 second |
| Focus | Infrastructure | OS resources | Query performance |
| Data Store | CloudWatch Metrics | CloudWatch Logs | Performance Insights |

---

## RDS Parameter Groups & Option Groups

### Parameter Groups

- A collection of database engine configuration parameters
- Applied at the **instance level** or **cluster level** (Aurora)
- **Dynamic parameters**: Applied immediately without restart
- **Static parameters**: Require a reboot to take effect
- Default parameter group cannot be modified → create a custom one
- Common parameters:
  - `max_connections`: Maximum number of client connections
  - `innodb_buffer_pool_size`: Memory for InnoDB buffer pool (MySQL)
  - `shared_buffers`: Memory for shared buffers (PostgreSQL)
  - `rds.force_ssl`: Force SSL connections
- If you modify a parameter group that's already associated with instances, changes apply:
  - **Dynamic**: Immediately (or at next maintenance window if specified)
  - **Static**: After reboot

### DB Cluster Parameter Groups (Aurora)

- Applied to all instances in an Aurora cluster
- Contains parameters that affect the cluster as a whole
- Cluster parameters take precedence over instance parameters for shared settings

### Option Groups

- Provide **additional features** not available through parameter groups
- Engine-specific optional features
- Examples:
  - **Oracle**: TDE (Transparent Data Encryption), Oracle Enterprise Manager, APEX
  - **SQL Server**: TDE, SQL Server Audit, SSRS
  - **MySQL**: MariaDB Audit Plugin, memcached interface
- Applied at the instance level
- Default option group is empty (no options enabled)
- Modifying option groups can cause brief downtime

### Exam Tips

- "Need to change database configuration" → Parameter Groups
- "Need to enable TDE for Oracle" → Option Groups
- "Need to enforce SSL" → Parameter Groups (rds.force_ssl)
- "Custom parameter group not taking effect" → Check if reboot is required (static parameter)

---

## Common Exam Scenarios

### Scenario 1: High Availability Database

**Question**: A company needs a highly available MySQL database with automatic failover.

**Solution**: Use RDS MySQL with **Multi-AZ deployment**. This provides synchronous replication and automatic failover. For even better availability, use **Aurora MySQL** which provides faster failover (~30s) and 6-way replication across 3 AZs.

### Scenario 2: Read-Heavy Workload

**Question**: An application has a heavy read workload that is overwhelming the primary database.

**Solution**: Create **Read Replicas** to distribute read traffic. For up to 5 replicas, use standard RDS. For up to 15 replicas with automatic scaling, use **Aurora** with the reader endpoint for load-balanced reads.

### Scenario 3: Lambda + RDS Connection Issues

**Question**: Lambda functions connecting to RDS are failing due to "too many connections" errors.

**Solution**: Deploy **RDS Proxy** between Lambda and RDS. RDS Proxy provides connection pooling, reducing the number of connections to the database. Ensure Lambda is in a VPC and can reach RDS Proxy.

### Scenario 4: Encrypt an Existing Unencrypted Database

**Question**: You have an existing unencrypted RDS database that needs to be encrypted for compliance.

**Solution**:
1. Take a snapshot of the unencrypted database
2. Copy the snapshot with encryption enabled
3. Restore a new DB instance from the encrypted snapshot
4. Update application to use the new endpoint
5. Delete the old unencrypted instance

### Scenario 5: Cross-Region Disaster Recovery

**Question**: A company needs cross-region DR for their database with RPO < 1 second.

**Solution**: Use **Aurora Global Database**. It provides cross-region replication with RPO < 1 second and RTO < 1 minute. If the primary region fails, promote a secondary region.

### Scenario 6: Unpredictable Workload

**Question**: A new application has unpredictable workload patterns and the team doesn't know how to size the database.

**Solution**: Use **Aurora Serverless v2**. It automatically scales between a minimum and maximum ACU based on demand, with near-instant scaling. Ideal when workload patterns are unknown.

### Scenario 7: Accidental Data Deletion

**Question**: A developer accidentally deleted critical data. The team needs to quickly recover.

**Solution**:
- If Aurora MySQL with **Backtrack** enabled: Backtrack to before the deletion (fastest, in-place)
- If Backtrack not enabled: Use **Point-in-Time Recovery** to restore to a new cluster
- For standard RDS: Use **PITR** to restore to a new instance

### Scenario 8: Production-like Test Environment

**Question**: The team needs a production-like test environment quickly without impacting production performance.

**Solution**: Use **Aurora Cloning**. It creates a near-instant copy using copy-on-write, sharing storage with the source until data diverges. Minimal impact on production and fast to create.

### Scenario 9: Global Application with Local Reads

**Question**: A global application needs low-latency reads from multiple regions.

**Solution**: Use **Aurora Global Database** with secondary regions close to users. Each region has its own reader replicas. Writes go to the primary region; reads are served locally. Write forwarding can simplify the architecture.

### Scenario 10: Database Needs Custom OS Software

**Question**: An Oracle database requires custom software agents installed on the OS.

**Solution**: Use **RDS Custom for Oracle**. It provides full OS and database administrative access while still benefiting from RDS managed features like automated backups and patching.

### Scenario 11: Cost Optimization for Infrequently Used Database

**Question**: A development database is only used 8 hours per day. How to reduce costs?

**Solution**: Options include:
- **Aurora Serverless v2** with low minimum ACU (scales down when idle)
- For standard RDS: Stop the instance outside business hours (max 7 days before auto-restart)
- Take a snapshot, delete the instance, and restore when needed (most savings but more management overhead)

### Scenario 12: Database Performance Troubleshooting

**Question**: A database is experiencing slow queries and the team needs to identify the root cause.

**Solution**: Enable **Performance Insights** to identify top SQL queries, wait events, and load patterns. Enable **Enhanced Monitoring** for OS-level process-level details. Use CloudWatch alarms for proactive monitoring.

---

## Key Numbers to Remember for the Exam

| Feature | Value |
|---------|-------|
| RDS Max Storage | 64 TiB |
| Aurora Max Storage | 128 TiB |
| RDS Read Replicas | Up to 5 |
| Aurora Read Replicas | Up to 15 |
| Aurora Copies per AZ | 2 copies × 3 AZs = 6 total |
| Aurora Write Quorum | 4 of 6 |
| Aurora Read Quorum | 3 of 6 |
| Aurora Segment Size | 10 GB |
| Aurora Replica Lag | < 10ms typically |
| Aurora Failover Time | < 30 seconds |
| Aurora Global DB RPO | < 1 second |
| Aurora Global DB RTO | < 1 minute |
| Aurora Global Secondary Regions | Up to 5 |
| Aurora Backtrack Window | Up to 72 hours |
| RDS Backup Retention | 0-35 days |
| RDS Proxy Failover Improvement | Up to 66% faster |
| gp2 Baseline IOPS | 3 IOPS/GiB |
| gp3 Baseline IOPS | 3,000 |
| io1 Max IOPS | 64,000 |
| SQS Visibility Timeout Default | 30 seconds |

---

## Summary

- **RDS** = managed relational database, 6 engines, no SSH (except RDS Custom)
- **Multi-AZ** = high availability, synchronous, automatic failover
- **Read Replicas** = read scalability, asynchronous, manual promotion
- **Aurora** = cloud-native, 5x MySQL / 3x PostgreSQL performance, 6 copies across 3 AZs
- **Aurora Serverless v2** = auto-scaling, ACUs, ideal for variable workloads
- **Aurora Global Database** = cross-region, RPO < 1s, RTO < 1 min
- **RDS Proxy** = connection pooling, Lambda integration, faster failover
- **RDS Custom** = OS access for Oracle and SQL Server
- **Encryption** = KMS at rest, SSL/TLS in transit, encrypt via snapshot copy
- **Backups** = automated (up to 35 days), manual snapshots (indefinite), PITR
- **Aurora Backtrack** = in-place rewind (MySQL only, up to 72 hours)
- **Aurora Cloning** = instant copy via copy-on-write protocol
