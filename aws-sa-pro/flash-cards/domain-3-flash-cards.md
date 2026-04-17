# Domain 3 - Migration Planning Flash Cards

## AWS Certified Solutions Architect - Professional (SAP-C02)

**Topics:** 7 Rs, migration phases, CAF, MGN, DMS, SCT, DataSync, Snow Family, Transfer Family, database migration patterns, application modernization, hybrid architectures, Outposts, VMware Cloud, ECS/EKS Anywhere

---

### Card 1
**Q:** What are the 7 Rs of cloud migration?
**A:** (1) **Retire** – decommission; no longer needed. (2) **Retain** – keep on-premises (not ready to migrate). (3) **Rehost** (lift and shift) – move as-is to AWS (EC2). Fastest. (4) **Relocate** – move to AWS without changes (VMware Cloud on AWS). (5) **Replatform** (lift, tinker, and shift) – minor optimizations (e.g., move to RDS instead of self-managed DB). (6) **Repurchase** – move to a different product (SaaS). (7) **Refactor/Re-architect** – redesign using cloud-native services (serverless, microservices). Each R represents a different balance of effort, cost, and optimization.

---

### Card 2
**Q:** What are the three phases of AWS migration?
**A:** (1) **Assess** – understand current state, build business case. Tools: Migration Evaluator (formerly TSO Logic), Application Discovery Service. (2) **Mobilize** – plan migration, build foundation. Address gaps in organization, process, technology. Set up landing zone (Control Tower), establish migration patterns, train teams, pilot migrations. (3) **Migrate and Modernize** – execute migrations at scale, optimize workloads, leverage cloud-native services. Use Migration Hub for tracking. Iterative process with each wave of applications.

---

### Card 3
**Q:** What is the AWS Cloud Adoption Framework (CAF)?
**A:** CAF provides guidance for cloud adoption across six perspectives: (1) **Business** – business value, ROI. (2) **People** – organizational change, training, culture. (3) **Governance** – risk management, compliance, portfolio management. (4) **Platform** – architecture, provisioning, CI/CD. (5) **Security** – identity, detection, infrastructure protection. (6) **Operations** – monitoring, incident management, continuity. Each perspective identifies capabilities needed for successful adoption. Mapped to transformation domains: Technology, Process, Organization, Product.

---

### Card 4
**Q:** What is AWS Migration Hub?
**A:** Migration Hub provides a single location to track migration progress across AWS migration tools. Features: (1) Discover (using Application Discovery Service). (2) Assess (using Migration Evaluator). (3) Migrate (track progress from MGN, DMS, and partner tools). (4) **Refactor Spaces** – manage refactoring to microservices (creates API Gateway + Lambda routing). (5) **Orchestrator** – automate and orchestrate migration workflows. (6) **Strategy Recommendations** – ML-based recommendations for migration strategy (R) per application. Single pane of glass for the entire migration.

---

### Card 5
**Q:** What is AWS Application Discovery Service?
**A:** Application Discovery Service collects information about on-premises servers for migration planning. Two methods: (1) **Agentless discovery** (via Discovery Connector on VMware) – collects VM metadata, utilization data. Less detail but easier setup. (2) **Agent-based discovery** (Discovery Agent on each server) – collects detailed data: CPU, memory, disk, network, running processes, network connections between servers. Data stored in Migration Hub. Use the dependency mapping to group servers into applications. Helps determine migration order and strategy.

---

### Card 6
**Q:** What is AWS Application Migration Service (MGN)?
**A:** MGN (formerly CloudEndure Migration) automates lift-and-shift (rehost) migrations. How it works: (1) Install replication agent on source servers. (2) Agent continuously replicates data to AWS (block-level). (3) Test by launching test instances from replicated data. (4) Cutover: launch production instances from the latest replication state. Supports: physical, virtual, and cloud servers. Minimal downtime (continuous replication). Supports Windows and Linux. Handles OS and application-level conversion automatically. Recommended over Server Migration Service (SMS).

---

### Card 7
**Q:** What is the difference between AWS MGN and AWS SMS?
**A:** **MGN** (Application Migration Service): continuous block-level replication, agent-based, supports physical/virtual/cloud servers, faster cutover (minutes of downtime), supports any source OS/hypervisor, recommended for all new migrations. **SMS** (Server Migration Service): incremental snapshot-based replication (VMware, Hyper-V, Azure VMs only), agentless (via connector), longer cutover time. SMS is effectively deprecated; AWS recommends MGN for all migration scenarios. MGN provides live replication; SMS provides periodic snapshots.

---

### Card 8
**Q:** What is AWS Database Migration Service (DMS)?
**A:** DMS migrates databases to AWS with minimal downtime. Supports: homogeneous (Oracle → Oracle) and heterogeneous (Oracle → Aurora) migrations. Features: continuous data replication (CDC – Change Data Capture), schema conversion (via SCT), multi-AZ for HA, validation, CloudWatch monitoring. Source/target support: on-premises, EC2, RDS, Aurora, Redshift, S3, DynamoDB, OpenSearch, DocumentDB, Neptune, Kinesis, Kafka. DMS Serverless auto-scales capacity. Use SCT for heterogeneous schema conversion before DMS migration.

---

### Card 9
**Q:** What is the difference between DMS full load and CDC replication?
**A:** **Full load**: migrates all existing data from source to target in bulk. Source remains operational during migration. Creates tables on target and loads data. **CDC (Change Data Capture)**: captures ongoing changes from the source database's transaction log and applies them to the target. **Combined**: full load + CDC = migrate existing data, then apply ongoing changes for continuous sync. This enables minimal-downtime migrations: full load first, CDC keeps target in sync, cutover when ready. CDC continues replicating until you stop it.

---

### Card 10
**Q:** What is AWS Schema Conversion Tool (SCT)?
**A:** SCT converts database schemas from one engine to another (e.g., Oracle → PostgreSQL, SQL Server → Aurora MySQL). It converts: tables, views, stored procedures, functions, triggers, indexes, sequences, data types, and application SQL. Generates an assessment report showing: conversion complexity, manual effort required, action items. SCT also converts ETL code (from SSIS, Oracle Data Integrator) and application SQL embedded in code. Use SCT before DMS for heterogeneous migrations. SCT is a free downloadable tool.

---

### Card 11
**Q:** What are the key considerations for heterogeneous database migration?
**A:** Steps: (1) Use SCT to assess conversion complexity and generate assessment report. (2) Convert schema using SCT (may require manual intervention for complex stored procedures). (3) Use DMS with full load + CDC for data migration. (4) Test application compatibility (SQL dialect differences). Key challenges: stored procedure conversion, data type mapping (e.g., Oracle NUMBER to PostgreSQL NUMERIC), proprietary features (Oracle RAC, partitioning), character set differences, sequence handling, and application-level SQL changes.

---

### Card 12
**Q:** What is AWS DataSync?
**A:** DataSync automates data transfer between on-premises storage and AWS (or between AWS services). Speeds: up to 10 Gbps per agent. Supports: NFS, SMB, HDFS, self-managed object storage → S3, EFS, FSx. Also: S3 ↔ S3, EFS ↔ EFS cross-region. Features: automatic encryption (TLS), data integrity validation, bandwidth throttling, scheduling, filtering, task reporting. Agent runs on-premises as a VM. Use for: initial data migration, ongoing data synchronization, data processing workflows. Up to 10x faster than open-source tools.

---

### Card 13
**Q:** When do you choose DataSync vs. Storage Gateway vs. Snow Family?
**A:** **DataSync**: online data transfer/sync. Best for: initial migration (fast), scheduled ongoing sync, large datasets over good network. **Storage Gateway**: hybrid cloud storage integration. Best for: ongoing hybrid access (on-prem apps need cloud-backed storage), backup, tiering. Not primarily a migration tool. **Snow Family**: offline data transfer. Best for: limited/no network bandwidth, massive datasets (10s-100s TB), air-gapped environments, edge computing. Rule of thumb: if network transfer would take > 1 week, consider Snow. DataSync for online, Snow for offline.

---

### Card 14
**Q:** What is the AWS Snow Family and when do you use each device?
**A:** (1) **Snowcone** (8-14 TB): small, portable. For edge data collection and limited migration. Runs EC2 and DataSync. (2) **Snowball Edge Storage Optimized** (80 TB): standard data migration. S3-compatible. EC2 compute capability. (3) **Snowball Edge Compute Optimized** (80 TB + 104 vCPUs + optional GPU): edge computing-heavy workloads (ML inference, video processing). (4) **Snowmobile** (100 PB): exabyte-scale migration. Decision factors: data volume, bandwidth, timeline, compute needs. 10 TB over 1 Gbps ≈ 1 day online; 100 TB might justify Snowball.

---

### Card 15
**Q:** How does Snowball Edge integrate with AWS services?
**A:** Snowball Edge runs local services: (1) **S3-compatible storage** – applications read/write locally. (2) **EC2 instances** – run compute workloads (AMIs pre-loaded). (3) **Lambda functions** – event-driven processing. (4) **IoT Greengrass** – IoT at the edge. (5) **OpsHub** – GUI for management. (6) **DataSync agent** – for data transfer. Workflow: order device → load data → ship to AWS → AWS imports to S3. For migration: copy data to Snowball → ship → data appears in S3. Encrypted with KMS. Tamper-evident, GPS-tracked. Clustering supported for larger capacity.

---

### Card 16
**Q:** What is AWS Transfer Family and its migration use cases?
**A:** Transfer Family provides managed SFTP/FTPS/FTP/AS2 servers backed by S3 or EFS. Migration use cases: (1) Replace on-premises SFTP servers with managed service. (2) Partner data exchange (keep existing SFTP workflows). (3) Gradual migration—partners continue using SFTP while you modernize backend to S3. Authentication: service-managed users, AD integration, or custom identity provider (Lambda-based for existing user databases). Supports VPC endpoints for private access. Eliminates server patching and management.

---

### Card 17
**Q:** What are the common database migration patterns?
**A:** Patterns: (1) **Homogeneous** (same engine): DMS full load + CDC. Simple. (2) **Heterogeneous** (different engine): SCT schema conversion + DMS data migration. More complex. (3) **Consolidation**: multiple databases → one (e.g., many MySQL → single Aurora). Use DMS with multiple tasks. (4) **Fan-out**: one database → multiple targets (e.g., Oracle → Aurora for OLTP + Redshift for analytics). (5) **Continuous replication**: ongoing CDC for hybrid operation during migration period. (6) **Blue/green**: maintain both, switch traffic when ready.

---

### Card 18
**Q:** How do you migrate an Oracle database to Aurora PostgreSQL?
**A:** Steps: (1) **Assess** – use SCT assessment report to identify conversion complexity (stored procedures, packages, data types). (2) **Convert schema** – use SCT to convert DDL. Manually convert complex PL/SQL to PL/pgSQL. Use Babelfish for Aurora PostgreSQL if migrating from SQL Server. (3) **Migrate data** – DMS full load + CDC. Configure LOB handling mode. (4) **Test** – application SQL compatibility, performance, data validation. (5) **Cutover** – stop application writes, let CDC catch up, switch connection string. (6) **Optimize** – tune Aurora parameters.

---

### Card 19
**Q:** What is Babelfish for Aurora PostgreSQL?
**A:** Babelfish enables Aurora PostgreSQL to understand T-SQL (SQL Server dialect) and TDS protocol (SQL Server wire protocol). Applications using SQL Server can connect to Aurora PostgreSQL with minimal code changes. Benefits: avoid expensive SQL Server licensing, use open-source PostgreSQL, reduced migration effort for SQL Server applications. Limitations: not 100% T-SQL compatible (check compatibility), some stored procedures may need modification. Run both PostgreSQL and T-SQL endpoints simultaneously on the same Aurora cluster.

---

### Card 20
**Q:** What is AWS Elastic Disaster Recovery (formerly CloudEndure DR)?
**A:** Elastic Disaster Recovery provides continuous replication of on-premises/cloud servers to AWS for DR. Agent-based, block-level replication. RPO: seconds (continuous replication). RTO: minutes (launch recovery instances). Features: automated failover/failback, non-disruptive DR drills, point-in-time recovery, supports physical/virtual/cloud. Pricing: per source server per hour (much cheaper than maintaining standby infrastructure). Different from Backup: Elastic DR provides near-instant recovery of full servers; Backup restores data from snapshots.

---

### Card 21
**Q:** What are the four DR strategies and their RPO/RTO characteristics?
**A:** (1) **Backup & Restore**: RPO hours, RTO hours. Cheapest. Backup data, restore when needed. (2) **Pilot Light**: RPO minutes, RTO tens of minutes. Core infrastructure running (DB replicated), other components off. Scale up on failover. (3) **Warm Standby**: RPO seconds, RTO minutes. Scaled-down full copy running. Scale up on failover. (4) **Multi-Site Active/Active**: RPO near-zero, RTO near-zero. Full production in both regions. Most expensive. Route 53 distributes traffic. Choose based on business RTO/RTO requirements vs. cost tolerance.

---

### Card 22
**Q:** How do you decide between Rehost, Replatform, and Refactor migration strategies?
**A:** **Rehost** when: time pressure, need to migrate quickly, application works as-is, plan to optimize later, limited cloud expertise. **Replatform** when: easy optimizations available (e.g., RDS instead of EC2 MySQL, Elastic Beanstalk instead of manual deployment), moderate effort for significant benefit. **Refactor** when: need cloud-native benefits (auto-scaling, serverless), application is a strategic asset, willing to invest time/resources, significant performance/cost improvements possible. Most organizations start with rehost/replatform, then refactor over time.

---

### Card 23
**Q:** What is AWS Outposts and its migration use cases?
**A:** Outposts extends AWS infrastructure to on-premises. Migration use cases: (1) **Data residency** – keep data on-premises for regulatory compliance while using AWS services. (2) **Low latency** – applications requiring single-digit ms latency to on-premises systems. (3) **Local data processing** – process data locally before sending results to cloud. (4) **Migration stepping stone** – run workloads on Outposts first, then move to cloud. (5) **Hybrid consistency** – use same APIs, tools, and services on-premises and in cloud. Outposts connects to a parent AWS region via high-bandwidth link.

---

### Card 24
**Q:** What is VMware Cloud on AWS?
**A:** VMware Cloud on AWS runs VMware SDDC (vSphere, vSAN, NSX, vCenter) on dedicated bare-metal AWS infrastructure. Migration use cases: (1) **Relocate** – move VMware VMs to AWS without conversion (same VMware tools). (2) **Extend data center** – hybrid VMware environment spanning on-premises and AWS. (3) **DR** – use as DR target for on-premises VMware. Benefits: no application changes, retain VMware expertise, access AWS services from VMs. Managed jointly by VMware and AWS. Billed hourly per host. Supports HCX for live VM migration.

---

### Card 25
**Q:** How does VMware HCX enable VM migration to VMware Cloud on AWS?
**A:** HCX (Hybrid Cloud Extension) provides: (1) **Bulk migration** – vMotion-based, minimal downtime. (2) **Live migration (vMotion)** – zero downtime, live memory state transfer. (3) **Cold migration** – powered-off VMs. (4) **Replication Assisted vMotion** – for large VMs or high-latency links. (5) **Network extension** – stretch L2 networks between on-premises and cloud (VMs keep their IPs). HCX abstracts the complexity of network and compute migration. Supports bi-directional migration.

---

### Card 26
**Q:** What is Amazon ECS Anywhere?
**A:** ECS Anywhere extends ECS to manage containers on customer-managed infrastructure (on-premises servers, other clouds). Install the SSM Agent and ECS Agent on your servers. Register them as EXTERNAL launch type in your ECS cluster. Use the same ECS console, CLI, and APIs to deploy and manage tasks. Benefits: consistent container orchestration across cloud and on-premises, leverage existing hardware, gradual migration path. Limitations: no Fargate on-premises, must manage infrastructure, networking is customer's responsibility.

---

### Card 27
**Q:** What is Amazon EKS Anywhere?
**A:** EKS Anywhere runs Kubernetes on-premises using the same EKS distribution. Deployment: on VMware vSphere, bare metal, Nutanix, or CloudStack. Features: Kubernetes conformant, EKS Distro (same K8s distribution as EKS), optional EKS Connector (view on-premises clusters in EKS console), Flux-based GitOps, curated packages (Prometheus, Fluentd, etc.). Use when: need Kubernetes on-premises with path to EKS migration, want consistent K8s experience across environments, regulatory requirements for on-premises compute.

---

### Card 28
**Q:** What is AWS Migration Evaluator?
**A:** Migration Evaluator (formerly TSO Logic) provides a business case for AWS migration. It: (1) Collects data from on-premises (agentless collector or manual import). (2) Analyzes current infrastructure costs (compute, storage, licensing, facilities). (3) Projects AWS costs with right-sizing recommendations. (4) Generates a directional business case report showing: current costs vs. AWS costs, potential savings, migration timeline recommendations. Free service. Useful for: executive buy-in, budgeting, identifying quick wins. Works with Application Discovery Service data.

---

### Card 29
**Q:** How do you handle large-scale data migration (petabyte+) to AWS?
**A:** Options: (1) **AWS Snowball/Snowmobile** – physical transfer. 80 TB per Snowball Edge, 100 PB per Snowmobile. (2) **Multiple Snowball devices** in parallel for PB-scale. (3) **Direct Connect** – dedicated 10-100 Gbps link for continuous transfer. 100 TB over 10 Gbps ≈ 1 day. (4) **DataSync over DX** – accelerated online transfer. (5) **Hybrid approach** – Snowball for initial bulk load + DX/DataSync for incremental sync. Decision factors: total data volume, available bandwidth, timeline, whether data changes during migration. Often combine offline (bulk) + online (incremental).

---

### Card 30
**Q:** What is the migration process for a large enterprise with 1,000+ applications?
**A:** (1) **Discovery & Assessment** – Application Discovery Service (agents on all servers), dependency mapping, group servers into applications. (2) **Prioritize & Plan** – categorize by 7 Rs, identify migration waves (groups of apps to migrate together), address dependencies. (3) **Build Landing Zone** – Control Tower, networking, security baselines. (4) **Execute Waves** – start with simple apps (build experience), increase complexity. Use MGN for rehost, DMS for databases. (5) **Optimize** – right-size, modernize (replatform/refactor) post-migration. Track via Migration Hub.

---

### Card 31
**Q:** What is AWS Mainframe Modernization?
**A:** Mainframe Modernization provides tools and services for migrating mainframe workloads to AWS. Two patterns: (1) **Replatform** – using Micro Focus runtime, run COBOL/JCL workloads on AWS managed infrastructure with minimal code changes. (2) **Refactor** – using Blu Age, automatically convert mainframe code (COBOL, PL/I, RPG) to modern Java-based applications. Features: managed runtime environment, deployment automation, data replication from mainframe, testing tools. Addresses mainframe skills shortage and high licensing costs.

---

### Card 32
**Q:** What is the strangler fig pattern for application modernization?
**A:** The strangler fig pattern gradually replaces a monolithic application with microservices. Approach: (1) Build new features as microservices. (2) Route new traffic to the new service (using API Gateway or ALB path-based routing). (3) Incrementally migrate existing functionality to microservices. (4) Eventually retire the monolith when all functionality is migrated. Benefits: reduces risk (no big-bang rewrite), delivers value incrementally, allows learning. AWS services: API Gateway, ALB routing, Lambda, ECS/EKS for new services. Migration Hub Refactor Spaces orchestrates this pattern.

---

### Card 33
**Q:** What is AWS Migration Hub Refactor Spaces?
**A:** Refactor Spaces manages the infrastructure for incremental refactoring (strangler fig pattern). It creates: (1) A multi-account environment for microservices. (2) API Gateway as the front door (routing entry point). (3) Network fabric (Transit Gateway-based) connecting accounts. (4) Route management – configure which URL paths go to legacy vs. new services. As you build new microservices, add routes to redirect traffic from the monolith. Simplifies the networking and routing complexity of incremental modernization.

---

### Card 34
**Q:** How do you migrate Windows workloads to AWS?
**A:** Options: (1) **Rehost** – MGN to EC2. License-included AMIs or BYOL. (2) **Replatform** – move .NET apps to Elastic Beanstalk or ECS (Windows containers). Move SQL Server to RDS for SQL Server. (3) **Re-architect** – modernize to Linux/.NET Core on Lambda/ECS. Move SQL Server to Aurora PostgreSQL (via Babelfish). Tools: **Porting Assistant for .NET** – analyzes .NET Framework apps and estimates porting effort to .NET Core (Linux). **End of Support Migration Program (EMP)** – run legacy Windows Server apps on newer OS.

---

### Card 35
**Q:** What is the difference between online and offline migration approaches?
**A:** **Online migration**: data transfers over the network while source remains operational. Tools: DMS (database), MGN (servers), DataSync (storage), S3 Transfer Acceleration. Pros: minimal downtime, continuous sync. Cons: depends on bandwidth, can take long for large data. **Offline migration**: physical data transfer using devices. Tools: Snowball, Snowmobile. Pros: independent of bandwidth, fast for large volumes. Cons: device transit time (days), not real-time. Often combined: offline for bulk + online for incremental sync.

---

### Card 36
**Q:** What is AWS DMS Fleet Advisor?
**A:** DMS Fleet Advisor is a free tool that inventories and assesses on-premises database and analytics servers for migration to AWS. It: (1) Discovers database servers on your network (auto-discovery). (2) Collects metadata: engine versions, sizes, features used, dependencies. (3) Generates migration recommendations: target AWS service, migration complexity, potential issues. (4) Creates inventory reports. Use early in migration planning to understand the database landscape and prioritize migration order. Complements Application Discovery Service for database-specific assessment.

---

### Card 37
**Q:** How do you migrate from MongoDB to Amazon DocumentDB?
**A:** Approaches: (1) **DMS** – continuous migration with CDC. Supports full load + ongoing replication. (2) **mongodump/mongorestore** – native MongoDB tools. Full export/import. Requires downtime. (3) **mongoreplay** – replay production traffic against DocumentDB for testing. Steps: assess compatibility (some MongoDB features not supported), create DocumentDB cluster, migrate data via DMS, validate data, test application, cutover. Key considerations: index creation, authentication method changes, unsupported features (certain aggregation operators).

---

### Card 38
**Q:** What is AWS Application Transformation?
**A:** AWS offers multiple application transformation services: (1) **Microservice Extractor for .NET** – identifies microservice candidates in .NET monoliths, helps extract and deploy to AWS. (2) **App2Container** – containerizes existing Java/ASP.NET applications on-premises or on EC2. Generates Dockerfile, ECS/EKS artifacts, and deployment pipeline. (3) **Porting Assistant for .NET** – assesses .NET Framework apps for porting to .NET Core (Linux). These tools accelerate the modernization step after initial lift-and-shift.

---

### Card 39
**Q:** What is the cutover process for a database migration using DMS?
**A:** Steps: (1) Run DMS full load to migrate existing data. (2) Enable CDC to capture ongoing changes. (3) Monitor replication lag until it approaches zero. (4) **Freeze** application writes to source (brief downtime starts). (5) Wait for DMS to apply final CDC changes (lag = 0). (6) Validate data in target database. (7) Switch application connection strings to target. (8) **Resume** application (downtime ends). (9) Monitor for issues. (10) Keep source database available for rollback period. Total downtime: minutes (depends on final CDC catch-up). Use DMS validation to verify data integrity.

---

### Card 40
**Q:** How do you migrate a self-managed Elasticsearch cluster to Amazon OpenSearch?
**A:** Approaches: (1) **Snapshot and restore** – take snapshot of source cluster, store in S3, restore in OpenSearch. Simple but requires downtime. (2) **Reindex from remote** – OpenSearch pulls data from source cluster. Source must be accessible. Near-zero downtime possible. (3) **Logstash** – read from source, write to OpenSearch. Flexible transformation. (4) **Custom application** – for complex transformations. Considerations: version compatibility, index mapping compatibility, plugin differences, security model migration, client library updates.

---

### Card 41
**Q:** What is the difference between DMS and native database replication tools?
**A:** **DMS**: supports heterogeneous migrations (different engines), managed service, no source database changes needed, schema conversion (with SCT), multiple targets, built-in validation. Limitations: some features not supported (certain data types, stored procedures execution). **Native tools** (MySQL replication, PostgreSQL logical replication, Oracle Data Guard): better performance for homogeneous migrations, support all features, lower latency. Choose DMS for: heterogeneous migrations, multi-target, managed service. Choose native for: same-engine migration needing full feature support.

---

### Card 42
**Q:** What is the recommended approach for migrating SAP workloads to AWS?
**A:** SAP on AWS options: (1) **Rehost** – SAP on EC2 with certified instance types (x2idn, u-series for HANA). Use MGN or SAP-native tools (SWPM). (2) **Replatform** – move SAP HANA to EC2, leverage EFS/FSx for shared storage, RDS for non-HANA databases. (3) **AWS Launch Wizard for SAP** – automates SAP deployment (HANA, NetWeaver) following best practices. (4) **Backint Agent for SAP HANA** – backup HANA to S3 directly. Certified instances support up to 24 TiB RAM for HANA. AWS and SAP partnership ensures ongoing certification.

---

### Card 43
**Q:** What are the network requirements for AWS MGN?
**A:** MGN requirements: (1) **Port 443 outbound** from source servers to MGN service endpoint (for API communication). (2) **Port 1500 outbound** from source to replication server in AWS (for data replication). (3) Replication server in VPC with appropriate security groups. (4) Sufficient bandwidth for initial sync + ongoing changes. (5) Staging area subnet with internet access or VPC endpoints. Options for connectivity: public internet, VPN, Direct Connect. For large migrations, Direct Connect recommended for consistent bandwidth. Throttling available to limit bandwidth consumption.

---

### Card 44
**Q:** What is AWS Wavelength and its use case in migration?
**A:** Wavelength extends AWS compute/storage to 5G carrier networks for ultra-low latency (single-digit ms) to mobile devices. Not primarily a migration tool, but relevant when: modernizing applications that need edge/mobile ultra-low latency (AR/VR, game streaming, autonomous vehicles, real-time inference). Migration consideration: applications currently running in on-premises edge locations near cell towers can be migrated to Wavelength Zones. Resources deployed in Wavelength Zones connect back to the parent AWS region.

---

### Card 45
**Q:** How do you migrate Redis/Memcached to ElastiCache?
**A:** For **Redis**: (1) Create ElastiCache Redis cluster. (2) Use Redis native replication—configure ElastiCache as replica of source. (3) Promote ElastiCache when in sync. Or: use RDB backup file → restore into ElastiCache. (4) For online migration: ElastiCache supports online migration from self-managed Redis (configure as replica). For **Memcached**: no native migration tool. Export data via application (dump and reload) or let cache warm up naturally (lazy loading). DMS does NOT support ElastiCache as a target. Minimal downtime possible with Redis replication approach.

---

### Card 46
**Q:** What is the AWS Prescriptive Guidance library?
**A:** AWS Prescriptive Guidance provides detailed migration and modernization patterns. Includes: step-by-step guides for specific migration scenarios (e.g., Oracle to Aurora, SAP to EC2, .NET to containers), architecture patterns, best practices, decision trees. Organized by: migration patterns, modernization patterns, operations patterns. Each guide includes: architecture diagrams, prerequisites, tools, detailed steps, and troubleshooting. Free resource. Essential reference for SA Pro exam scenarios requiring specific migration approaches.

---

### Card 47
**Q:** What are DMS replication instance considerations?
**A:** DMS replication instance sizing: (1) **Instance class** – determines CPU/memory. Larger for complex transformations, LOB handling, or many tables. (2) **Storage** – enough for cached changes and logs during migration. (3) **Multi-AZ** – enable for production migrations (HA). (4) **Network** – same VPC/region as target for best performance. (5) **Replication instance class** – dms.t3 (dev/test) to dms.r6i (production). Consider: table parallelism (FullLoadSubTasks), LOB mode (full vs. limited), and task settings. Monitor: CPU, memory, swap, storage, replication lag via CloudWatch.

---

### Card 48
**Q:** What is the process for migrating a Windows File Server to FSx for Windows?
**A:** Steps: (1) Create FSx for Windows File Server (choose Single-AZ or Multi-AZ, storage type, throughput). (2) Join FSx to your AD (AWS Managed AD, self-managed AD, or AD Connector). (3) Migrate data using **AWS DataSync** (preserves permissions, timestamps, ACLs) or **Robocopy** (Windows native, run from EC2 or on-premises). (4) Configure DNS CNAME to point file share name to FSx endpoint. (5) Update Group Policies if needed. (6) Test access and permissions. DataSync is recommended for large migrations.

---

### Card 49
**Q:** What is the difference between DMS migration types?
**A:** DMS task types: (1) **Full load only** – migrate all existing data. Good for: initial loads, small databases, acceptable downtime. (2) **CDC only** – capture and apply only ongoing changes. Good for: keeping an existing full-load target in sync. (3) **Full load + CDC** – migrate existing data, then apply ongoing changes. Good for: minimal-downtime migrations (most common). CDC uses: source database transaction logs (Oracle LogMiner/Binary Reader, MySQL binlog, PostgreSQL logical replication). Source must have: transaction logging enabled, sufficient log retention.

---

### Card 50
**Q:** What considerations are important when migrating to a multi-account AWS environment?
**A:** Considerations: (1) **Account structure** – OUs by environment, business unit, or compliance boundary. (2) **Networking** – Transit Gateway for connectivity, VPC design, IP address planning (avoid overlaps). (3) **Identity** – IAM Identity Center for human access, cross-account roles for automation. (4) **Shared services** – central logging, DNS, security tooling, CI/CD. (5) **Data migration** – where does data land? Cross-account access patterns. (6) **Governance** – SCPs, Config rules, tagging strategy. (7) **Cost allocation** – per-account billing, cost allocation tags. Plan before migrating.

---

### Card 51
**Q:** How do you migrate an on-premises Hadoop cluster to AWS?
**A:** Options: (1) **Rehost** – EMR cluster with HDFS or EMRFS (S3-backed). Migrate data using DataSync or DistCp to S3. (2) **Replatform** – EMR with EMRFS (decouple storage from compute). Replace HBase with DynamoDB. Replace Hive Metastore with Glue Data Catalog. (3) **Refactor** – replace MapReduce/Spark jobs with Glue ETL. Replace Hive queries with Athena. Use Lake Formation for governance. Data migration: DistCp from HDFS to S3, or DataSync, or Snow Family for large datasets. Consider: job compatibility, schema migration, data format optimization (Parquet/ORC).

---

### Card 52
**Q:** What is AWS Application Composer?
**A:** Application Composer (formerly part of SAM Accelerate) provides a visual drag-and-drop interface for designing serverless applications. You visually connect services (Lambda, API Gateway, DynamoDB, S3, SNS, SQS, Step Functions, EventBridge) and it generates CloudFormation/SAM templates. Useful for: modernization/refactoring phase—design new microservices visually, generate IaC templates, and deploy. Reduces the barrier to building serverless architectures during application modernization.

---

### Card 53
**Q:** What is the role of a landing zone in migration?
**A:** A landing zone is the foundational multi-account environment that must be set up BEFORE migration begins. It includes: (1) Account structure (Organizations, OUs). (2) Identity and access (IAM Identity Center, federated access). (3) Networking (Transit Gateway, VPCs, DNS, DX/VPN). (4) Security baselines (GuardDuty, Config, CloudTrail, Security Hub). (5) Logging (centralized logging account). (6) Governance (SCPs, tag policies). (7) Cost management (billing, budgets). Without a proper landing zone, migrations lack governance, security, and organizational structure.

---

### Card 54
**Q:** How do you handle DNS during migration?
**A:** DNS considerations: (1) **Hybrid DNS** – Route 53 Resolver with inbound/outbound endpoints. On-premises DNS forwards AWS domains to inbound endpoint; Route 53 forwards on-premises domains via outbound endpoint. (2) **Low-TTL** – set low TTL on DNS records before cutover for fast failover. (3) **Weighted routing** – gradually shift traffic from on-premises to AWS (canary migration). (4) **Private Hosted Zones** – for internal AWS resources. (5) **DNS cutover** – update public DNS records to point to AWS resources. Keep old records briefly for rollback.

---

### Card 55
**Q:** What is the migration strategy for stateful applications?
**A:** Challenges: session state, local storage, in-memory caches. Strategies: (1) **Externalize state** – move sessions to ElastiCache Redis or DynamoDB. (2) **Sticky sessions** – ALB session affinity (short-term fix, not ideal). (3) **Shared storage** – EFS or FSx for shared file systems. (4) **Database** – store state in RDS/Aurora. (5) **S3** – for larger state objects. For migration: first rehost (lift and shift with sticky sessions), then replatform (externalize state to ElastiCache/DynamoDB). This is a common exam pattern: how to make a stateful app horizontally scalable.

---

### Card 56
**Q:** What is the AWS Well-Architected Migration Lens?
**A:** The Migration Lens provides best practices specific to migration workloads. Key areas: (1) **Operational readiness** – team training, runbooks, monitoring. (2) **Migration-specific security** – cross-account access, encryption in transit, temporary elevated permissions. (3) **Performance** – baseline before migration, benchmark after. (4) **Cost** – migration tooling costs, parallel running costs, right-sizing post-migration. (5) **Reliability** – rollback plans, testing, validation. Provides questions and best practices for each Well-Architected pillar in the migration context.

---

### Card 57
**Q:** How do you migrate Oracle RAC to AWS?
**A:** Options: (1) **Rehost** – Oracle RAC on EC2. Requires BYOL. Use dedicated hosts for licensing. Complex: cluster setup, shared storage (EBS Multi-Attach or FSx for ONTAP). (2) **Replatform** – Oracle single instance on RDS or EC2 (drop RAC, use Multi-AZ for HA). Simpler but requires application testing for non-RAC behavior. (3) **Refactor** – migrate to Aurora. Use SCT for schema conversion + DMS for data migration. Most cost-effective long-term but highest migration effort. Decision factors: licensing cost, timeline, application dependency on RAC-specific features.

---

### Card 58
**Q:** What is AWS Trusted Advisor's role during migration?
**A:** Trusted Advisor helps during and after migration: (1) **Service limits** – ensure you won't hit quotas when launching migrated resources (EC2, VPCs, EIPs, etc.). Request increases proactively. (2) **Security** – identify overly permissive security groups, public S3 buckets, missing MFA. (3) **Cost optimization** – identify over-provisioned resources post-migration, recommend right-sizing. (4) **Fault tolerance** – ensure Multi-AZ for databases, cross-AZ for EC2, backup configurations. Run Trusted Advisor checks as part of post-migration validation.

---

### Card 59
**Q:** What is the difference between DMS and DataSync for data migration?
**A:** **DMS**: migrates DATABASE data. Supports schema conversion, change data capture (CDC), continuous replication. Sources/targets: relational databases, NoSQL, data warehouses, S3 (as source or target). **DataSync**: migrates FILE and OBJECT data. Supports NFS, SMB, HDFS, S3, EFS, FSx. Handles file permissions, timestamps, metadata. Up to 10 Gbps throughput. Use DMS for databases; use DataSync for file servers, NAS, and HDFS. They serve different data types and are often used together in migrations.

---

### Card 60
**Q:** How do you migrate a legacy three-tier web application to AWS?
**A:** Progressive approach: (1) **Rehost** (Wave 1) – MGN to move web/app servers to EC2, DMS to migrate database to RDS. Set up ALB, Auto Scaling. (2) **Replatform** (Wave 2) – move to managed services: Elastic Beanstalk or ECS for app tier, Aurora for database, ElastiCache for sessions, S3 + CloudFront for static content. (3) **Refactor** (Wave 3) – decompose into microservices: API Gateway + Lambda for APIs, DynamoDB for appropriate tables, SQS for async processing, Step Functions for workflows.

---

### Card 61
**Q:** What is AWS Local Zones and their migration relevance?
**A:** Local Zones are AWS infrastructure extensions placed close to population centers for single-digit millisecond latency. Use cases for migration: (1) Real-time applications currently on-premises near end users can migrate to Local Zones. (2) Gaming, media production, machine learning inference at the edge. (3) Hybrid architectures where some workloads need low latency. Resources: EC2, EBS, ELB, RDS, ECS. Local Zones connect to a parent AWS region. Fewer services available than full regions. Suitable for latency-sensitive portions of migrated applications.

---

### Card 62
**Q:** What are the key considerations for migrating encrypted data?
**A:** Considerations: (1) **In-transit encryption** – DMS supports SSL/TLS to source and target. DataSync encrypts in transit (TLS). Snow devices use 256-bit encryption. (2) **At-rest encryption** – enable encryption on target (RDS, S3, EBS, EFS). KMS key management: create keys before migration, cross-account key access if needed. (3) **Re-encryption** – data encrypted with on-premises keys must be re-encrypted with AWS KMS keys. (4) **Key migration** – import existing key material into KMS (CMK with imported key material) or use CloudHSM. (5) **Compliance** – maintain encryption requirements throughout the migration process.

---

### Card 63
**Q:** What is the process for migrating Active Directory to AWS?
**A:** Options: (1) **AWS Managed Microsoft AD** – deploy in AWS, create trust with on-premises AD. Users authenticate to either. Gradually move resources. Eventually remove trust and on-premises AD. (2) **AD Connector** – proxy to on-premises AD. No AD on AWS. Requires persistent connectivity. (3) **Extend on-premises AD** – deploy additional domain controllers on EC2 in AWS VPC. Same AD forest/domain. Requires VPN/DX. Replication handles sync. Choose based on: connectivity reliability, independence from on-premises, management preference.

---

### Card 64
**Q:** How do you validate data integrity after a database migration?
**A:** Validation methods: (1) **DMS Validation** – built-in feature that compares source and target row counts and values. Reports mismatches. (2) **Row count comparison** – basic but catches major issues. (3) **Checksum comparison** – hash-based comparison of source and target tables. (4) **Application-level testing** – run queries against both databases and compare results. (5) **AWS DMS Data Validation task** – validates at table level during and after migration. (6) **Custom scripts** – compare specific business-critical data. Always include validation as a formal migration step before cutover.

---

### Card 65
**Q:** What is AWS Migration Competency Partners?
**A:** AWS Migration Competency Partners are APN (AWS Partner Network) partners validated by AWS for migration expertise. They: (1) Have demonstrated migration experience. (2) Follow AWS migration best practices. (3) Are audited by AWS. (4) Offer planning, execution, and optimization services. For the exam: recognize that large enterprise migrations often involve partners. AWS provides programs like MAP (Migration Acceleration Program) that include credits, tools, and partner support. MAP provides consulting, migration tools, and AWS credits based on migration commitment.

---

### Card 66
**Q:** What is the Migration Acceleration Program (MAP)?
**A:** MAP is an AWS program for enterprise-scale migrations. Provides: (1) **Migration methodology** – structured approach (Assess, Mobilize, Migrate & Modernize). (2) **AWS credits** – based on committed migration spend. (3) **Partner ecosystem** – access to competency partners. (4) **Tools and training** – migration tools, workshops, immersion days. (5) **Expert support** – AWS Professional Services and Solution Architects. Eligibility: typically for migrations involving significant annual AWS spend. Reduces cost and risk of large-scale migrations.

---

### Card 67
**Q:** How do you migrate a microservices application to AWS?
**A:** Approaches by complexity: (1) **Rehost containers** – lift Docker containers to ECS/EKS on EC2. (2) **Replatform** – move to Fargate (serverless containers). Minimal changes. (3) **Migrate to managed services** – replace self-managed service mesh with App Mesh, replace self-managed queues with SQS/SNS, replace self-managed API gateway with API Gateway. (4) **Leverage AWS networking** – Service Connect, Cloud Map for service discovery. Key considerations: container image registry (ECR), CI/CD pipeline migration, service discovery, logging/monitoring migration, secret management.

---

### Card 68
**Q:** What is the role of S3 as a migration staging area?
**A:** S3 serves as a central staging point in many migration patterns: (1) Database migration: DMS can write CDC files to S3 for lake-based targets. (2) File migration: DataSync/Snow Family deliver to S3 first. (3) Data transformation: stage raw data in S3, transform with Glue, load to target. (4) Large object migration: multipart upload, Transfer Acceleration. (5) Cross-region migration: S3 CRR to replicate data between regions. (6) Archive: S3 Glacier for migrated historical data. S3's durability (11 9s), scalability, and integration make it the universal staging layer.

---

### Card 69
**Q:** What is the downtime impact of different migration strategies?
**A:** Downtime by strategy: **Rehost with MGN**: minutes (continuous replication, quick cutover). **Database with DMS full load + CDC**: minutes (final CDC catch-up + connection switch). **Database with DMS full load only**: hours (depends on data volume, no CDC). **Snowball**: days (device transit + import time). **Storage Gateway**: near-zero (seamless hybrid access). **VMware Cloud + HCX live vMotion**: zero (live migration). **Blue/green deployment**: near-zero (Route 53/ALB switch). To minimize downtime: always use CDC for databases and continuous replication for servers.

---

### Card 70
**Q:** What are the considerations for migrating compliance-regulated workloads (HIPAA/PCI)?
**A:** Considerations: (1) **Shared responsibility** – understand what AWS covers vs. what you must configure. (2) **BAA/DPA** – sign AWS agreements (via Artifact). (3) **Encryption** – in transit and at rest, required for HIPAA/PCI. (4) **Access control** – audit trail (CloudTrail), least privilege (IAM). (5) **Network isolation** – VPC, private subnets, no public access for regulated data. (6) **Logging** – comprehensive logging, immutable storage (S3 Object Lock). (7) **Region selection** – ensure chosen region supports required compliance standards. (8) **Penetration testing** – AWS allows certain tests without pre-approval.

---

### Card 71
**Q:** How do you migrate Amazon WorkSpaces or virtual desktops to AWS?
**A:** For virtual desktop migration: (1) **From on-premises VDI** (Citrix, VMware Horizon) → AWS WorkSpaces or AppStream 2.0. (2) Migrate user profiles using FSx for Windows File Server (replicate profile data). (3) Integrate with existing AD (AD Connector or Managed AD trust). (4) Migration approach: deploy WorkSpaces in parallel, migrate users in waves, verify application compatibility. (5) For Citrix/VMware: also available on AWS EC2 (rehost the VDI platform). WorkSpaces supports both Windows and Amazon Linux desktops.

---

### Card 72
**Q:** What is the process for migrating to Amazon Aurora from MySQL/PostgreSQL?
**A:** Options: (1) **RDS snapshot migration** – if already on RDS MySQL/PostgreSQL: take snapshot, restore as Aurora. Downtime during snapshot/restore. (2) **Aurora read replica** – create an Aurora read replica of existing RDS MySQL. Promote when caught up. Minimal downtime. (3) **DMS** – for non-RDS sources or when replication isn't available. Full load + CDC. (4) **mysqldump/pg_dump** – native tools. More downtime. (5) **Aurora cloning** – instant copy from existing Aurora. Best path: RDS → Aurora read replica → promote (near-zero downtime for RDS MySQL sources).

---

### Card 73
**Q:** What is the difference between AWS Outposts and AWS Local Zones for hybrid architectures?
**A:** **Outposts**: AWS hardware in YOUR data center. You own the physical space. Full AWS services available. Connected to parent region via dedicated link. Use for: data residency, ultra-low latency to on-premises systems, local data processing. **Local Zones**: AWS hardware in AWS-managed locations near population centers. You don't manage physical infrastructure. Subset of AWS services. Use for: low-latency to end users in specific cities. Key difference: Outposts = your data center; Local Zones = AWS-managed edge locations.

---

### Card 74
**Q:** What migration considerations are specific to containerized applications?
**A:** Considerations: (1) **Image registry** – push images to ECR (from Docker Hub, private registries). (2) **Orchestration** – map Kubernetes manifests to EKS, Docker Compose to ECS task definitions. (3) **Networking** – VPC networking, service mesh, load balancers. (4) **Storage** – persistent volumes (EBS CSI driver for EKS, EFS). (5) **Secrets** – migrate to Secrets Manager or SSM Parameter Store. (6) **CI/CD** – migrate pipelines to CodePipeline or continue with Jenkins on EC2. (7) **Monitoring** – container-specific: Container Insights, Prometheus, X-Ray. (8) **Resource limits** – Fargate task sizing.

---

### Card 75
**Q:** How do you plan a migration wave?
**A:** Migration wave planning: (1) **Group by dependency** – co-migrate tightly coupled applications. Application Discovery Service maps dependencies. (2) **Order by complexity** – start simple (stateless web servers), build confidence, tackle complex workloads later. (3) **Wave size** – start small (5-10 servers), increase (50-100+ servers) as team gains experience. (4) **Testing window** – schedule waves with sufficient testing time. (5) **Rollback plan** – define for each wave. (6) **Success criteria** – define metrics (performance, latency, error rates). (7) **Communication plan** – stakeholder updates per wave.

---

### Card 76
**Q:** What is AWS Migration Hub Strategy Recommendations?
**A:** Strategy Recommendations provides ML-based migration strategy recommendations for each application. It analyzes: source code (via source code analysis), application configuration, and infrastructure data. Outputs: recommended migration strategy (R), target AWS service, anti-pattern identification, and estimated complexity. Works with data from Application Discovery Service. Helps automate the decision of which R to apply to each application in a large portfolio, reducing manual assessment effort.

---

### Card 77
**Q:** How do you handle licensing during migration to AWS?
**A:** Licensing considerations: (1) **License-included** – use AWS-provided licenses (Windows, SQL Server on RDS, Linux). Included in hourly price. (2) **BYOL** – bring existing licenses. Requires: Dedicated Hosts (per-socket/per-core licenses), Dedicated Instances (some licenses), or License Manager tracking. (3) **License optimization** – use License Manager to track and enforce. (4) **Savings opportunities** – move from Oracle/SQL Server to Aurora/PostgreSQL (eliminate license cost). (5) **Mobility** – Microsoft License Mobility through SA for some products. Always consult licensing agreements.

---

### Card 78
**Q:** What is the process for migrating a data warehouse to Amazon Redshift?
**A:** Steps: (1) **Assess** – SCT assessment of source schema (Teradata, Oracle, Netezza, SQL Server). (2) **Convert schema** – SCT converts DDL, views, stored procedures, ETL. (3) **Migrate data** – DMS for ongoing replication, SCT data extractors for large tables (parallel extraction to S3 → COPY into Redshift). (4) **Optimize** – Redshift-specific tuning: distribution keys, sort keys, compression, VACUUM. (5) **Migrate BI tools** – connect QuickSight/Tableau to Redshift. (6) **Validate** – query result comparison. SCT data extractors handle TB-PB scale data better than DMS for data warehouse migrations.

---

### Card 79
**Q:** What are the anti-patterns to avoid during cloud migration?
**A:** Anti-patterns: (1) **Big bang** – migrating everything at once (too risky). Migrate in waves. (2) **Lift and shift everything** – some apps should be retired/repurchased/refactored. (3) **Ignoring dependencies** – migrating an app without its dependent services causes failures. (4) **No landing zone** – migrating before setting up proper governance/networking. (5) **Over-engineering** – refactoring everything when rehost is sufficient. (6) **No rollback plan** – must have a way back. (7) **Ignoring people/process** – technology alone doesn't succeed; train teams. (8) **Not right-sizing** – replicating on-premises sizing wastes money.

---

### Card 80
**Q:** What is the difference between Application Migration Service and Elastic Disaster Recovery?
**A:** Both use continuous block-level replication but serve different purposes. **MGN (Application Migration Service)**: for one-time migration. Migrate servers to AWS permanently. After cutover, remove source servers. **Elastic Disaster Recovery (DRS)**: ongoing DR. Continuously replicates for disaster scenarios. Supports failover AND failback. Keeps replication active long-term. You maintain source servers. Both use a lightweight agent and replication to staging area. Choose MGN for migration; choose DRS for ongoing disaster recovery of on-premises/cloud workloads.

---

### Card 81
**Q:** What is AWS App2Container?
**A:** App2Container (A2C) is a command-line tool that containerizes existing Java and .NET web applications running on-premises or on EC2. It: (1) Analyzes the running application and dependencies. (2) Generates a Dockerfile and container image. (3) Creates ECS/EKS deployment artifacts (task definition, Kubernetes manifests). (4) Optionally creates a CI/CD pipeline (CodePipeline). Steps: install A2C → discover applications (`a2c inventory`) → analyze (`a2c analyze`) → containerize (`a2c containerize`) → deploy. Simplifies the modernization path from traditional servers to containers.

---

### Card 82
**Q:** How do you migrate an on-premises data lake to AWS?
**A:** Steps: (1) **Data transfer** – DataSync for NAS/file storage, Snow Family for large volumes, DMS for databases, EMR DistCp for HDFS. (2) **Storage** – S3 as the central data lake storage. Convert to Parquet/ORC for analytics efficiency. (3) **Catalog** – Glue Crawlers to build the Data Catalog. (4) **Processing** – replace on-premises Spark with EMR or Glue ETL. (5) **Query** – Athena replaces Hive for ad-hoc SQL. (6) **Governance** – Lake Formation for access control. (7) **BI** – QuickSight or migrate existing BI tools. Adopt a zone-based architecture: raw → refined → curated.

---

### Card 83
**Q:** What is the recommended approach for migrating a monolithic application with a shared database?
**A:** Pattern: (1) **Phase 1**: Rehost the entire monolith (app + shared DB) to EC2 + RDS. (2) **Phase 2**: Decompose the database using the Database-per-Service pattern. Identify bounded contexts. Use DMS/CDC to keep new service databases in sync during transition. (3) **Phase 3**: Extract microservices one at a time (strangler fig). Each service gets its own database. Use API Gateway for routing. (4) **Phase 4**: Complete decomposition, retire the monolith. Key: don't try to decompose everything at once. The shared database is the hardest part to split.

---

### Card 84
**Q:** What are the post-migration optimization steps?
**A:** Steps: (1) **Right-size** – use Compute Optimizer, Trusted Advisor to identify over-provisioned resources. (2) **Cost optimize** – purchase RIs/Savings Plans for steady-state workloads, use Spot for fault-tolerant workloads. (3) **Modernize** – replatform databases (RDS/Aurora), containerize applications (ECS/EKS), adopt serverless where appropriate. (4) **Automate** – implement IaC (CloudFormation/CDK), CI/CD pipelines. (5) **Monitor** – CloudWatch dashboards, alarms, X-Ray tracing. (6) **Security review** – Security Hub, GuardDuty, Inspector assessments. (7) **Backup** – configure AWS Backup plans. (8) **Documentation** – update runbooks and architecture diagrams.

---

### Card 85
**Q:** How do you migrate DynamoDB data between AWS accounts or regions?
**A:** Methods: (1) **DynamoDB Export to S3** + **Import from S3** – export to S3 (PITR-based, no RCU consumed), import in target account/region. (2) **DMS** – continuous replication between DynamoDB tables (cross-account/region). (3) **DynamoDB Global Tables** – for cross-region (same account, ongoing multi-active replication). (4) **AWS Backup** – backup and restore cross-account or cross-region. (5) **Data Pipeline** – legacy approach, being replaced. (6) **Custom** – DynamoDB Streams → Lambda → target table. Best for one-time: Export/Import. Best for continuous: DMS or Global Tables.
