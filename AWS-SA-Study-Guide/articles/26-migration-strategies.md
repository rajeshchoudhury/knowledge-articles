# Migration Strategies & Services

## Table of Contents

1. [Cloud Migration Phases](#cloud-migration-phases)
2. [The 7 Rs of Migration](#the-7-rs-of-migration)
3. [AWS Migration Hub](#aws-migration-hub)
4. [Application Discovery Service](#application-discovery-service)
5. [Application Migration Service (AWS MGN)](#application-migration-service-aws-mgn)
6. [AWS Server Migration Service (SMS)](#aws-server-migration-service-sms)
7. [Database Migration Service (DMS)](#database-migration-service-dms)
8. [Schema Conversion Tool (SCT)](#schema-conversion-tool-sct)
9. [DMS Ongoing Replication](#dms-ongoing-replication)
10. [AWS Migration Evaluator](#aws-migration-evaluator)
11. [CloudEndure Migration](#cloudendure-migration)
12. [VM Import/Export](#vm-importexport)
13. [Migration Patterns](#migration-patterns)
14. [Total Cost of Ownership](#total-cost-of-ownership)
15. [Common Exam Scenarios](#common-exam-scenarios)

---

## Cloud Migration Phases

### Overview

AWS defines a structured approach to cloud migration that consists of four phases. Understanding these phases helps frame migration discussions on the exam.

### Phase 1: Assess (Migration Readiness Assessment)

**Objective:** Understand the current state and build a business case for migration.

**Activities:**
- Identify business drivers for migration
- Assess organizational readiness (skills, processes, governance)
- Discover existing IT portfolio (applications, infrastructure, dependencies)
- Evaluate Total Cost of Ownership (TCO) comparison
- Define migration objectives and success criteria

**AWS Tools:**
- **AWS Migration Evaluator** (formerly TSO Logic): Build business case with data-driven cost projections
- **Application Discovery Service**: Discover on-premises servers, applications, and dependencies
- **AWS Migration Hub**: Central tracking dashboard

### Phase 2: Mobilize (Planning and Proof of Concept)

**Objective:** Create a detailed migration plan and validate through pilots.

**Activities:**
- Establish a Migration Center of Excellence (CCoE/Cloud Foundation Team)
- Create landing zone (multi-account structure, networking, security baseline)
- Design migration wave plan (which applications migrate in which order)
- Perform proof-of-concept migrations
- Train teams on AWS services
- Refine the business case with PoC learnings

**AWS Tools:**
- **AWS Control Tower**: Set up multi-account landing zone
- **AWS Organizations**: Account management
- **CloudFormation StackSets**: Deploy baseline configurations

### Phase 3: Migrate (Execute Migrations)

**Objective:** Execute the migration plan in waves.

**Activities:**
- Execute migration waves (groups of applications migrated together)
- Perform testing and validation after each migration
- Optimize migrated workloads
- Decommission on-premises resources
- Track progress in Migration Hub

**AWS Tools:**
- **Application Migration Service (MGN)**: Server replication and cutover
- **Database Migration Service (DMS)**: Database migration
- **Schema Conversion Tool (SCT)**: Database schema conversion
- **Snow Family**: Large data transfer
- **DataSync**: File/storage migration

### Phase 4: Modernize (Optimize and Innovate)

**Objective:** Optimize migrated workloads and adopt cloud-native services.

**Activities:**
- Right-size compute resources
- Adopt managed services (RDS instead of self-managed DB)
- Containerize applications (ECS, EKS)
- Adopt serverless (Lambda, API Gateway)
- Implement CI/CD pipelines
- Implement advanced monitoring and automation

**AWS Tools:**
- **Compute Optimizer**: Right-sizing recommendations
- **Trusted Advisor**: Optimization recommendations
- **AWS App2Container**: Containerize existing applications
- **AWS Microservice Extractor**: Decompose monoliths

---

## The 7 Rs of Migration

### Overview

The 7 Rs define different migration strategies based on the desired outcome, effort, and business requirements. Each application should be evaluated to determine the most appropriate strategy.

### 1. Rehost (Lift and Shift)

**Description:** Move applications to AWS **as-is**, without making changes to the application code or architecture.

**How It Works:**
- Replicate servers from on-premises to AWS (EC2 instances)
- Same OS, same application stack, same configuration
- Use automated tools for replication

**AWS Tools:**
- AWS Application Migration Service (MGN)
- VM Import/Export

**Advantages:**
- Fastest migration path
- Lowest risk (no code changes)
- Easiest to execute at scale
- Quick wins for data center exit

**Disadvantages:**
- Doesn't leverage cloud-native benefits
- May carry over inefficient architectures
- Cost optimization opportunities limited initially

**Best For:**
- Large-scale migrations with tight deadlines
- Applications that need to move quickly (data center lease expiring)
- Applications that work well as-is and don't need re-architecting
- Legacy applications with limited documentation

**Example:** Migrate 200 Windows servers running IIS and SQL Server to EC2 instances with the same configuration.

### 2. Replatform (Lift, Tinker, and Shift)

**Description:** Make a **few cloud optimizations** during migration without changing the core architecture.

**How It Works:**
- Migrate the application with targeted changes
- Replace specific components with managed AWS services
- Core architecture and code remain mostly the same

**Common Replatforming Changes:**
- Database: Self-managed MySQL on EC2 → Amazon RDS MySQL
- Caching: Self-managed Memcached → ElastiCache
- Search: Self-managed Elasticsearch → Amazon OpenSearch Service
- Message queue: Self-managed RabbitMQ → Amazon MQ
- Load balancer: Hardware LB → Application Load Balancer
- Storage: NFS → Amazon EFS

**Advantages:**
- Some cloud benefits (managed services, reduced operational overhead)
- Relatively low risk (minimal code changes)
- Moderate effort
- Immediate operational improvements

**Disadvantages:**
- Doesn't fully leverage cloud-native capabilities
- May still carry architectural limitations

**Best For:**
- Applications where specific components have clear managed-service alternatives
- Databases that benefit from managed services (automated backups, Multi-AZ)
- Applications where operational overhead reduction is a priority

**Example:** Migrate a web application to EC2 but move the database from self-managed PostgreSQL to RDS PostgreSQL.

### 3. Repurchase (Drop and Shop)

**Description:** Move to a **different product**, typically a SaaS solution.

**How It Works:**
- Replace the existing application with a commercial off-the-shelf (COTS) or SaaS product
- Data migration from old system to new system
- User training and change management

**Examples:**
- Self-hosted CRM → Salesforce
- Self-hosted email → Microsoft 365 or Google Workspace
- Self-hosted HR system → Workday
- Self-hosted ERP → SAP on AWS or Oracle Cloud
- Self-hosted CMS → WordPress.com or Drupal Cloud
- Self-hosted source control → GitHub or GitLab SaaS

**Advantages:**
- Eliminates infrastructure management entirely
- Often provides better features than self-hosted solutions
- Regular updates and security patches from vendor
- Predictable subscription pricing

**Disadvantages:**
- Potential data migration complexity
- Loss of customization capabilities
- Vendor lock-in
- Higher per-user licensing costs
- User retraining required

**Best For:**
- Applications where better SaaS alternatives exist
- Non-differentiating applications (email, CRM, HR)
- Applications where maintenance cost exceeds the value

### 4. Refactor / Re-architect

**Description:** Redesign the application using **cloud-native features** and architectures.

**How It Works:**
- Rewrite the application to leverage AWS-native services
- Adopt microservices architecture
- Use serverless, containers, managed services
- Fundamental code and architecture changes

**Common Refactoring Patterns:**
- Monolith → Microservices (ECS, EKS, Lambda)
- Relational database → DynamoDB (for appropriate use cases)
- On-premises message queue → SQS, SNS, EventBridge
- Batch processing → Step Functions, Lambda
- File processing → S3 Events + Lambda
- Static website → S3 + CloudFront
- REST APIs → API Gateway + Lambda

**Advantages:**
- Maximum cloud benefit (scalability, resilience, cost optimization)
- Best performance and cost efficiency long-term
- Enables innovation and rapid feature delivery
- Fully leverages AWS ecosystem

**Disadvantages:**
- Highest effort and cost upfront
- Highest risk (rewriting code)
- Requires cloud-native skills
- Longest migration timeline

**Best For:**
- Strategic applications that differentiate the business
- Applications needing significant scalability improvements
- Applications where current architecture is a bottleneck
- When long-term cloud optimization is prioritized over speed

**Example:** Rewrite a monolithic Java application as microservices running on ECS Fargate with DynamoDB, SQS, and API Gateway.

### 5. Retire

**Description:** **Decommission** applications that are no longer needed.

**How It Works:**
- Identify applications that serve no business purpose
- Verify no dependencies exist
- Archive data if needed (compliance/regulatory requirements)
- Decommission servers and infrastructure

**When to Retire:**
- Redundant applications (multiple apps doing the same thing)
- Applications with no active users
- Applications replaced by other systems
- End-of-life applications

**Benefits:**
- Reduce migration scope and cost
- Simplify IT portfolio
- Reduce licensing costs
- Reduce security attack surface

**Example:** During discovery, identify 50 servers running legacy applications that no business unit uses. Retire them instead of migrating.

### 6. Retain (Revisit Later)

**Description:** Keep applications **on-premises** for now and revisit migration later.

**Reasons to Retain:**
- Recently purchased hardware with long depreciation schedule
- Compliance or regulatory restrictions preventing cloud migration
- Application nearing end-of-life (not worth migrating)
- Complex dependencies that require more planning
- Unresolved licensing issues (e.g., Oracle licensing complexities)
- Latency-sensitive applications requiring proximity to on-premises systems

**Approach:**
- Document the decision and reasons
- Set a future date to re-evaluate
- May run in a hybrid configuration temporarily

### 7. Relocate (Hypervisor-Level Lift and Shift)

**Description:** Move infrastructure to AWS **at the hypervisor level** without purchasing new hardware, re-writing applications, or modifying existing operations.

**How It Works:**
- Migrate VMware-based workloads to **VMware Cloud on AWS**
- No changes to applications, OS, or VMware tooling
- Same VMware tools, skills, and processes

**AWS Service:** VMware Cloud on AWS

**Advantages:**
- Fastest migration for VMware environments
- No application changes needed
- Same operational model (vSphere, vSAN, NSX)
- Extend or migrate entire VMware environments

**Best For:**
- Organizations heavily invested in VMware
- Need to quickly exit a data center while maintaining VMware operations
- Hybrid cloud with consistent VMware management

---

## AWS Migration Hub

### Overview

AWS Migration Hub provides a **single location** to track the progress of application migrations across multiple AWS tools.

### Key Features

**Migration Tracking:**
- Central dashboard showing migration status for all applications
- Track migrations from multiple tools: MGN, DMS, CloudEndure
- Group servers by application for holistic view
- Migration status: Not started, In progress, Completed

**Strategy Recommendations:**
- Analyzes your on-premises environment
- Recommends migration strategy (7 Rs) for each application
- Based on server utilization, dependencies, and patterns
- Integration with Application Discovery Service data

**Refactor Spaces:**
- Create and manage APIs that route traffic between on-premises and AWS
- Enables **strangler fig pattern** for incremental migration
- Route specific API paths to AWS while others remain on-premises
- Gradually shift traffic as microservices are migrated

### Key Exam Points

- Migration Hub is a **tracking** service (not a migration tool itself)
- Single pane of glass for all migrations
- Strategy recommendations help choose the right R for each application
- Refactor Spaces enables incremental migration patterns

---

## Application Discovery Service

### Overview

AWS Application Discovery Service helps you **plan migration projects** by automatically discovering on-premises servers, collecting configuration and usage data, and mapping dependencies.

### Discovery Methods

#### Agentless Discovery (Discovery Connector)

**How It Works:**
- Deploy an OVA (Open Virtual Appliance) in your VMware vCenter environment
- The Discovery Connector communicates with vCenter to collect data
- No software installed on individual servers

**Data Collected:**
- VM inventory: hostname, IP addresses, MAC addresses
- Resource allocation: CPU cores, memory, disk
- Performance data: CPU utilization, memory utilization, disk I/O, network I/O
- VM-to-host mapping

**Limitations:**
- **VMware only** (requires vCenter)
- No dependency mapping
- No application-level data
- No data about processes or network connections

#### Agent-Based Discovery (Discovery Agent)

**How It Works:**
- Install the Discovery Agent on each server (Windows, Linux)
- Agent collects detailed data about the server

**Data Collected:**
- Everything from agentless PLUS:
- **Network connections**: Inbound and outbound connections between servers
- **Running processes**: Application processes and their resource usage
- **Dependency mapping**: Which servers communicate with which
- OS details, installed software

**Advantages over Agentless:**
- Works on any platform (not just VMware)
- Dependency mapping is critical for migration planning
- Process-level visibility
- More accurate performance data

### Data Export and Integration

- Data stored in **AWS Application Discovery Service database**
- Export to CSV or use the **Discovery Data API**
- Integrates with **Migration Hub** for migration tracking
- Integrates with **AWS Migration Hub Strategy Recommendations**
- Can export to **Amazon Athena** for SQL-based analysis (via S3)

### Key Exam Points

- **Agentless** (Discovery Connector): VMware only, no dependency mapping, less detailed
- **Agent-based** (Discovery Agent): Any platform, dependency mapping, process-level detail
- Use agent-based for **dependency mapping** (critical for migration planning)
- Data feeds into **Migration Hub** for tracking and strategy recommendations

---

## Application Migration Service (AWS MGN)

### Overview

AWS Application Migration Service (MGN) is the **primary recommended service** for lift-and-shift (rehost) migrations to AWS. It replaces CloudEndure Migration and AWS Server Migration Service (SMS).

### How It Works

**Continuous Block-Level Replication:**

```
On-Premises Server                    AWS
┌─────────────┐      Replication     ┌──────────────────┐
│  Source      │ ──────────────────→  │  Staging Area     │
│  Server     │    (continuous,       │  (lightweight EC2  │
│             │     block-level)      │   + EBS volumes)  │
└─────────────┘                      └──────────────────┘
                                             │
                                     Test/Cutover
                                             │
                                     ┌──────────────────┐
                                     │  Target Instance  │
                                     │  (production EC2) │
                                     └──────────────────┘
```

1. **Install Replication Agent** on source servers
2. **Continuous replication** begins: Block-level replication of all data to staging area in AWS
3. **Staging area**: Lightweight EC2 instances and EBS volumes that hold replicated data
4. **Test**: Launch test instances from replicated data (non-disruptive to source)
5. **Cutover**: Launch production instances and switch traffic to AWS
6. **Finalize**: Decommission source servers

### Key Features

**Supported Sources:**
- Physical servers
- VMware, Hyper-V, and other virtualization platforms
- Other cloud providers (Azure, GCP)
- Supported OS: Windows Server 2003+, Amazon Linux, Ubuntu, RHEL, CentOS, SUSE, Debian, Fedora, Oracle Linux

**Replication:**
- Block-level continuous replication (not snapshot-based)
- Compressed and encrypted data transfer
- Bandwidth throttling available
- Replication to any AWS Region
- Minimal impact on source server performance

**Testing:**
- Non-disruptive testing at any time
- Launch test instances without affecting replication or source
- Multiple test iterations before cutover
- Custom launch templates for test and production instances

**Cutover:**
- Short cutover window (minutes)
- Automated instance launch and configuration
- Post-launch scripts for customization
- Option to launch in specific subnets, security groups, with specific instance types

**Post-Migration:**
- Right-sizing recommendations
- Modernization recommendations
- Integration with Application Migration Service console

### Network Requirements

- Replication agent communicates outbound on **TCP 1500** to replication servers
- HTTPS (443) to MGN API endpoints
- Replication data is encrypted in transit
- VPN or Direct Connect recommended for bandwidth and security

### Key Exam Points

- MGN is the **current recommended** tool for server migration (replaces SMS and CloudEndure)
- **Continuous block-level replication** ensures near-zero data loss
- **Non-disruptive testing** before cutover
- Short cutover window (minutes of downtime)
- Supports physical, virtual, and cross-cloud migrations

---

## AWS Server Migration Service (SMS)

### Overview

AWS SMS is a **legacy** server migration service that has been **replaced by AWS MGN**.

### How It Worked

- Used a **SMS Connector** (OVA) deployed in VMware environment
- Replicated VM images as AMIs to AWS on a schedule
- **Incremental replication**: Only changed blocks replicated after initial sync
- Replication intervals: Every 1–24 hours
- **NOT continuous** replication (unlike MGN)
- Maximum of 90 days of replication

### Why It's Being Replaced

| Feature | SMS | MGN |
|---------|-----|-----|
| **Replication** | Incremental, scheduled (hourly) | Continuous, block-level |
| **RPO** | Hours (depends on schedule) | Seconds (continuous) |
| **Testing** | Limited | Non-disruptive at any time |
| **Platform Support** | VMware only | Physical, virtual, cross-cloud |
| **Cutover** | Longer window | Minutes |

### Key Exam Points

- SMS is **deprecated** — if you see it on the exam, know that MGN is the replacement
- If the question asks about "current recommended service for server migration," the answer is **MGN**
- SMS may still appear in questions about older migration patterns

---

## Database Migration Service (DMS)

### Overview

AWS Database Migration Service (DMS) helps you migrate databases to AWS quickly and securely. The source database remains fully operational during migration, minimizing downtime.

### Key Concepts

**Replication Instance:**
- An EC2 instance that runs the DMS replication software
- Processes the data migration between source and target
- Size based on data volume and transaction rate

**Replication Instance Sizing:**

| Instance Class | Use Case |
|---------------|----------|
| **dms.t3.micro/small/medium** | Small databases, testing, development |
| **dms.r5.large/xlarge** | Medium production databases |
| **dms.r5.2xlarge/4xlarge** | Large databases with high transaction rates |
| **dms.r5.8xlarge/12xlarge/16xlarge/24xlarge** | Very large databases, complex migrations |

**Key sizing factors:**
- Table count and average row size
- Transaction rate on the source
- LOB (Large Object) column usage
- Network bandwidth between source and target

### Source and Target Engines

**Source Engines:**
- Oracle, Microsoft SQL Server, MySQL, MariaDB, PostgreSQL, MongoDB, SAP ASE, IBM Db2
- Amazon RDS, Amazon Aurora, Amazon S3
- Azure SQL Database
- Cassandra (target only supported as Amazon Keyspaces)

**Target Engines:**
- All source engines PLUS:
- Amazon Redshift, Amazon DynamoDB, Amazon S3
- Amazon OpenSearch Service, Amazon Kinesis Data Streams
- Amazon Neptune, Amazon DocumentDB
- Amazon Keyspaces (Managed Cassandra)
- Redis (Amazon ElastiCache, Amazon MemoryDB)
- Babelfish (Aurora PostgreSQL)

### Migration Types

| Type | Description | Use Case |
|------|-------------|----------|
| **Full Load** | Migrate all existing data from source to target | One-time migration |
| **CDC (Change Data Capture)** | Capture ongoing changes from the source after initial load | Continuous replication |
| **Full Load + CDC** | Full load followed by ongoing CDC | Migration with minimal downtime |

**Full Load + CDC Workflow:**
1. DMS performs full load of existing data
2. While full load runs, CDC captures changes on the source
3. After full load completes, CDC applies captured changes
4. CDC continues replicating changes in near real-time
5. At cutover, stop the source and wait for CDC to catch up
6. Switch applications to the target

### Homogeneous vs Heterogeneous Migration

**Homogeneous Migration (same engine):**
```
Oracle → Oracle on RDS
MySQL → MySQL on RDS/Aurora
PostgreSQL → PostgreSQL on RDS/Aurora
SQL Server → SQL Server on RDS
```
- DMS handles the migration directly
- No schema conversion needed (or minimal changes)
- Straightforward migration

**Heterogeneous Migration (different engines):**
```
Oracle → PostgreSQL on Aurora
SQL Server → MySQL on RDS
Oracle → DynamoDB
```
- Requires **Schema Conversion Tool (SCT)** to convert the schema first
- SCT converts: Tables, views, stored procedures, functions, triggers, data types
- DMS handles the data migration
- Two-step process: SCT (schema) → DMS (data)

### DMS Multi-AZ

- Enable Multi-AZ for the replication instance
- Provides high availability for the replication instance
- Synchronous replication to a standby in another AZ
- Automatic failover if the primary replication instance fails
- Recommended for production migrations

### Key Features

**Table Mapping and Selection Rules:**
- Select which schemas, tables, or columns to migrate
- Transform data during migration (rename schemas, tables, columns)
- Filter rows based on conditions

**Data Validation:**
- Compare source and target data after migration
- Row count, data comparison
- Validation report showing mismatches

**Monitoring:**
- CloudWatch metrics for replication instance and tasks
- Task-level metrics: CDC latency, throughput, table statistics
- CloudWatch Logs for detailed replication logs

**Encryption:**
- SSL/TLS encryption for data in transit
- KMS encryption for replication instance storage
- Certificate management for SSL connections

---

## Schema Conversion Tool (SCT)

### Overview

AWS Schema Conversion Tool (SCT) converts database schemas from one engine to another, primarily used for **heterogeneous migrations**.

### How It Works

1. **Connect to source database** and analyze schema
2. **Assessment report**: SCT generates a report showing:
   - Percentage of schema that can be converted automatically
   - Items requiring manual conversion
   - Complexity rating for each object
3. **Convert schema**: SCT converts tables, views, stored procedures, functions, triggers
4. **Apply to target**: Apply the converted schema to the target database
5. **Manual remediation**: Fix objects that couldn't be automatically converted

### Assessment Report

The SCT assessment report is critical for migration planning:

**Conversion Categories:**
- **Green**: Automatic conversion (no manual work)
- **Yellow**: Simple manual changes needed
- **Red**: Complex manual changes needed (may require rewriting)
- **Blue**: Not supported in the target engine

**Report Contents:**
- Object-by-object conversion status
- Estimated effort for manual conversions
- Recommendations for target engine alternatives
- Executive summary for management reporting

### SCT Data Extraction Agents

For very large databases, SCT can use **data extraction agents**:
- Extract data in parallel from the source
- Store in S3 as intermediate format
- Load into the target database
- Used with DMS for large-scale migrations
- Particularly useful for data warehouse migrations to Redshift

### Supported Conversions

| Source | Target |
|--------|--------|
| Oracle | PostgreSQL (Aurora), MySQL (Aurora), MariaDB |
| SQL Server | PostgreSQL (Aurora), MySQL (Aurora), MariaDB |
| Oracle/SQL Server (DW) | Amazon Redshift |
| Teradata | Amazon Redshift |
| Netezza | Amazon Redshift |
| Greenplum | Amazon Redshift |
| HPE Vertica | Amazon Redshift |
| MySQL/PostgreSQL | PostgreSQL (Aurora), MySQL (Aurora) |
| Apache Cassandra | Amazon DynamoDB, Amazon Keyspaces |

### Key Exam Points

- SCT converts **schema only** — DMS migrates the data
- Use SCT for **heterogeneous** migrations (different engines)
- Assessment report helps estimate migration effort and complexity
- SCT is a **desktop application** (runs on your machine, not in AWS)
- For homogeneous migrations, SCT is generally NOT needed

---

## DMS Ongoing Replication

### Overview

DMS can provide **ongoing replication** (CDC) for hybrid architectures and continuous data synchronization.

### Use Cases

**Hybrid Architecture:**
- Keep databases synchronized between on-premises and AWS during migration period
- Gradual migration: Some applications use on-premises DB, others use AWS DB
- Fallback capability: If AWS migration fails, on-premises DB has current data

**Continuous Replication:**
- Real-time data warehouse loading: Replicate OLTP changes to Redshift
- Cross-region replication: Replicate database changes across regions
- Analytics: Stream database changes to S3, OpenSearch, or Kinesis
- Archive: Replicate to S3 for long-term storage

**Multi-Source to Single Target:**
- Consolidate multiple databases into one target
- Useful for data warehouse consolidation

### CDC Details

**Source Requirements:**
- Source database must have change tracking enabled
- MySQL/MariaDB: Binary logging (binlog) enabled
- PostgreSQL: Logical replication enabled
- Oracle: Supplemental logging enabled
- SQL Server: MS-Replication or MS-CDC enabled

**CDC Latency:**
- Typically seconds to minutes
- Depends on transaction volume, replication instance size, and network
- Monitor with CloudWatch `CDCLatencySource` and `CDCLatencyTarget` metrics

---

## AWS Migration Evaluator

### Overview

AWS Migration Evaluator (formerly **TSO Logic**) is a migration assessment service that helps build a **data-driven business case** for migration.

### How It Works

1. **Data Collection**: Install the Migration Evaluator collector on-premises (agentless) or import data from existing tools (ServiceNow, Application Discovery Service, etc.)
2. **Analysis**: Migration Evaluator analyzes compute, storage, and licensing data
3. **Business Case Report**: Generates a detailed report comparing:
   - Current on-premises costs (TCO)
   - Projected AWS costs (multiple scenarios)
   - Licensing optimization opportunities
   - Recommended migration strategies

### Report Contents

- **Current State Analysis**: Inventory of servers, utilization patterns, licensing
- **Cost Comparison**: On-premises vs AWS for different migration strategies
- **Right-Sizing**: Recommended AWS instance types based on actual utilization
- **Licensing Optimization**: Opportunities to reduce licensing costs (BYOL, license-included)
- **Quick Wins**: Low-hanging fruit for immediate migration
- **Multi-Year Projections**: 3-year and 5-year cost comparisons

### Key Exam Points

- Migration Evaluator builds the **business case** for migration
- Uses actual utilization data (not theoretical capacity)
- Helps choose between on-demand, Reserved Instances, and Savings Plans
- Free service — AWS provides the assessment at no charge
- Results feed into Migration Hub for tracking

---

## CloudEndure Migration

### Overview

CloudEndure Migration was a free, automated lift-and-shift migration service. It has been **integrated into AWS Application Migration Service (MGN)**.

### CloudEndure vs MGN Comparison

| Feature | CloudEndure | MGN |
|---------|------------|-----|
| **Status** | Deprecated / Integrated into MGN | Current recommended service |
| **Console** | Separate CloudEndure console | AWS Console integrated |
| **Pricing** | Free | Free (for replication; standard EC2 charges after) |
| **Replication** | Continuous, block-level | Continuous, block-level |
| **Management** | Third-party feel | Native AWS integration |
| **IAM** | Separate credentials | AWS IAM |
| **Monitoring** | CloudEndure console | CloudWatch, CloudTrail |
| **Automation** | API-based | AWS-native APIs, CloudFormation |

### Key Exam Points

- If you see "CloudEndure" on the exam, understand it does the same thing as MGN
- **MGN is the replacement** — AWS recommends MGN for all new migrations
- Both provide continuous block-level replication with minimal downtime cutover

---

## VM Import/Export

### Overview

VM Import/Export enables you to import virtual machine images from your existing environment to Amazon EC2 as AMIs, and export them back.

### VM Import

**Supported Formats:**
- VMware: VMDK, OVA
- Microsoft Hyper-V: VHD, VHDX
- Citrix Xen: VHD
- Raw format

**Supported OS:**
- Windows Server 2003+
- Red Hat Enterprise Linux, CentOS, Ubuntu, Debian, SUSE, Fedora, Oracle Linux

**How It Works:**
1. Upload VM image to S3
2. Use `aws ec2 import-image` CLI command
3. AWS converts the image to an AMI
4. Launch EC2 instances from the AMI

### VM Export

**Export EC2 instances** back to on-premises:
- Export to VMDK, VHD, or OVA format
- Export to S3, then download
- Only instances originally imported via VM Import can be exported (with exceptions)

### Key Exam Points

- VM Import/Export is for **one-time migrations** (not continuous replication)
- Good for creating AMIs from existing VMs
- For ongoing migrations, use **MGN** instead
- Works with multiple hypervisor formats

---

## Migration Patterns

### Database Migration Strategies

**Same-Engine Migration (Homogeneous):**
```
1. DMS Full Load + CDC
2. Test target database
3. Cutover: Switch connection string
4. Monitor and verify
```

**Cross-Engine Migration (Heterogeneous):**
```
1. SCT: Convert schema and generate assessment report
2. Apply converted schema to target
3. Fix manual conversion items
4. DMS Full Load + CDC for data migration
5. Test target database
6. Cutover: Switch connection string
7. Monitor and verify
```

**Oracle to Aurora PostgreSQL (Common Exam Pattern):**
1. Run SCT assessment report to estimate effort
2. SCT converts schema (tables, views, procedures)
3. Manual remediation for unconvertible objects
4. DMS with Full Load + CDC migrates data
5. Application code changes for PostgreSQL compatibility
6. Testing phase (parallel run)
7. Cutover with minimal downtime

### Large Data Migration Pattern

**Scenario**: Migrate 50 TB of data from on-premises to S3.

**Option 1: Network Transfer (if bandwidth allows)**
- 1 Gbps connection: ~5 days
- 10 Gbps connection: ~12 hours
- Use DataSync for efficient, accelerated transfer

**Option 2: Snow Family + DMS (if bandwidth limited)**
```
1. Order Snowball Edge (80 TB capacity)
2. Load 50 TB of data onto Snowball
3. Ship to AWS → Data loaded into S3
4. Use DMS to capture changes that occurred during shipping
5. DMS CDC catches up incremental changes
6. Cutover when CDC latency is zero
```

**Bandwidth Calculation:**
```
Data Size: 50 TB = 400,000 Gb
Available Bandwidth: 1 Gbps (assuming 80% utilization = 0.8 Gbps)
Transfer Time: 400,000 / 0.8 = 500,000 seconds ≈ 5.8 days
```

If transfer time exceeds acceptable window → use Snow Family.

### Live Migration Pattern (Minimal Downtime)

```
1. Set up MGN replication (continuous block-level)
2. Wait for initial sync to complete
3. Perform non-disruptive test launches
4. Validate test instances
5. Schedule cutover window
6. Stop applications on source
7. Wait for final replication sync (minutes)
8. Launch production instances in AWS
9. Update DNS/load balancer to point to AWS
10. Verify applications are working
11. Decommission source (after observation period)
```

---

## Total Cost of Ownership

### TCO Considerations

**On-Premises Costs to Include:**
- Server hardware (purchase, refresh cycles)
- Storage hardware (SAN, NAS)
- Network hardware (switches, routers, firewalls)
- Data center costs (space, power, cooling, physical security)
- Software licensing (OS, database, middleware)
- Staffing (sys admins, DBAs, network engineers)
- Maintenance and support contracts
- Disaster recovery infrastructure

**AWS Costs to Include:**
- Compute (EC2, Lambda, containers)
- Storage (EBS, S3, EFS)
- Database (RDS, Aurora, DynamoDB)
- Network (data transfer, Direct Connect)
- Migration costs (one-time)
- Training costs (one-time)
- Staff costs (potentially reduced but not zero)

### AWS Tools for TCO

| Tool | Purpose |
|------|---------|
| **Migration Evaluator** | Data-driven TCO comparison using actual utilization |
| **AWS Pricing Calculator** | Estimate monthly AWS costs for specific architectures |
| **Compute Optimizer** | Right-sizing recommendations to reduce costs |
| **Trusted Advisor** | Ongoing cost optimization recommendations |
| **Cost Explorer** | Analyze actual AWS spending after migration |

---

## Common Exam Scenarios

### Scenario 1: Migrate 500 Servers Quickly

**Question**: A company needs to migrate 500 servers from their data center to AWS as quickly as possible. The data center lease expires in 6 months.

**Answer**: Use **Rehost (Lift and Shift)** strategy with **AWS Application Migration Service (MGN)**. Install the replication agent on all servers. MGN continuously replicates server data to AWS. Perform test launches for validation. Execute wave-based cutovers. Use **Migration Hub** to track progress across all 500 servers. This is the fastest approach with minimal application changes.

### Scenario 2: Migrate Oracle Database to Aurora PostgreSQL

**Question**: A company wants to migrate their Oracle database to Amazon Aurora PostgreSQL to reduce licensing costs.

**Answer**: This is a **heterogeneous migration** requiring:
1. **Schema Conversion Tool (SCT)**: Convert Oracle schema to PostgreSQL (tables, views, stored procedures)
2. Review the SCT **assessment report** for manual conversion items
3. **DMS with Full Load + CDC**: Migrate data with minimal downtime
4. Application code changes for PostgreSQL compatibility
5. Parallel testing before cutover

### Scenario 3: Migrate 80 TB to S3 with 100 Mbps Internet

**Question**: A company needs to migrate 80 TB of data to S3. They have a 100 Mbps internet connection.

**Answer**: Calculate transfer time: 80 TB = 640,000 Gb ÷ 0.1 Gbps (with 80% utilization = 0.08 Gbps) = 8,000,000 seconds ≈ **92 days**. This is too long. Use **AWS Snowball Edge** (80 TB capacity). Order one device, load data, ship to AWS. For incremental changes during shipping, use **DataSync** or **DMS** (for databases) to capture changes. Total time: ~1–2 weeks (shipping + loading).

### Scenario 4: Migrate Self-Managed MySQL to RDS

**Question**: A company runs MySQL on EC2 and wants to move to RDS MySQL for reduced operational overhead.

**Answer**: This is a **Replatform** strategy with **homogeneous migration**. Use **DMS with Full Load + CDC** directly (no SCT needed since it's MySQL to MySQL). DMS replicates data while the source remains operational. Cutover involves switching the application connection string to the RDS endpoint. Minimal downtime.

### Scenario 5: Decide Migration Strategy for Multiple Applications

**Question**: During discovery, the team found: (A) an old CRM system, (B) a legacy app with 5 users, (C) a core business application, (D) a simple web portal.

**Answer**:
- **(A) Old CRM**: **Repurchase** — Replace with Salesforce or HubSpot SaaS
- **(B) Legacy app with 5 users**: **Retire** — Decommission if not business-critical
- **(C) Core business application**: **Refactor** — Re-architect to cloud-native for competitive advantage
- **(D) Simple web portal**: **Rehost** — Lift and shift to EC2, then consider replatforming later

### Scenario 6: Continuous Database Replication for Analytics

**Question**: A company needs to replicate their production RDS MySQL database changes in real-time to Amazon Redshift for analytics.

**Answer**: Use **DMS with CDC (ongoing replication)**. Create a DMS replication instance. Configure the source as RDS MySQL and the target as Redshift. Set migration type to **CDC only** (assuming initial load is done). DMS continuously captures changes from MySQL binlog and applies them to Redshift. Monitor CDC latency with CloudWatch.

### Scenario 7: Discover Server Dependencies Before Migration

**Question**: Before migrating, a company needs to understand which servers communicate with each other to plan migration waves.

**Answer**: Use **Application Discovery Service** with the **agent-based** approach (Discovery Agent). Agents collect network connection data between servers, running processes, and performance metrics. This creates a dependency map showing which servers communicate, enabling grouping into migration waves (servers that depend on each other migrate together). Data is viewable in **Migration Hub**.

### Scenario 8: Build Business Case for Migration

**Question**: A CTO needs a cost comparison between keeping servers on-premises vs. migrating to AWS, with right-sizing recommendations.

**Answer**: Use **AWS Migration Evaluator**. Install the agentless collector on-premises to capture actual server utilization data. Migration Evaluator analyzes CPU, memory, and storage usage, compares against AWS pricing (on-demand, RI, Savings Plans), and generates a detailed business case report with projected savings, right-sizing recommendations, and licensing optimization opportunities.

### Scenario 9: VMware Workload Migration

**Question**: A company runs 200 VMs on VMware and wants to migrate to AWS while continuing to use VMware management tools.

**Answer**: Use the **Relocate** strategy with **VMware Cloud on AWS**. This allows migrating VMware workloads at the hypervisor level without application changes. Same vSphere, vSAN, and NSX tools. Alternatively, for moving off VMware, use **MGN** to rehost VMs as EC2 instances.

### Scenario 10: Zero-Downtime Database Migration

**Question**: A mission-critical database migration requires absolutely zero downtime.

**Answer**: Use **DMS with Full Load + CDC**:
1. Full Load migrates existing data while source stays operational
2. CDC continuously replicates changes from source to target
3. Applications continue using the source database throughout
4. When CDC latency is near zero, cutover is just a connection string change
5. For the brief moment of switching, use the application's connection pool retry logic
6. For absolute zero downtime, implement application-level dual-write or use Route 53 DNS failover with TTL management

---

## Key Takeaways for the Exam

1. **7 Rs**: Rehost, Replatform, Repurchase, Refactor, Retire, Retain, Relocate
2. **Rehost** = Lift and shift (MGN), fastest, lowest risk
3. **Replatform** = Lift, tinker, shift (e.g., self-managed DB → RDS)
4. **Repurchase** = Drop and shop (e.g., self-hosted CRM → Salesforce)
5. **Refactor** = Re-architect for cloud-native (highest effort, highest benefit)
6. **Retire** = Decommission unused applications
7. **Retain** = Keep on-premises for now
8. **Relocate** = VMware Cloud on AWS (hypervisor-level migration)
9. **MGN** = Current recommended tool for server migration (replaces SMS and CloudEndure)
10. **DMS** = Database migration; Full Load, CDC, or Full Load + CDC
11. **SCT** = Schema conversion for heterogeneous migrations (different engines)
12. **Homogeneous** migration (same engine) = DMS only; **Heterogeneous** = SCT + DMS
13. **Application Discovery Service**: Agentless (VMware only, no dependencies) vs Agent-based (any platform, dependency mapping)
14. **Migration Hub** = Central tracking dashboard for all migrations
15. **Migration Evaluator** = Build data-driven business case for migration
16. **Snow Family** for large data transfers when network bandwidth is insufficient
17. **Bandwidth calculation**: Data (Gb) ÷ Available bandwidth (Gbps) = Transfer time (seconds)
