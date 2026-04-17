# Migration & DR Flashcards

## AWS Solutions Architect Associate (SAA-C03) — Deck 9 of 9

---

### Card 1
**Q:** What are the 7 Rs of cloud migration?
**A:** **Retire** – decommission applications no longer needed. **Retain** – keep on-premises (not ready or not worth migrating). **Rehost** (lift-and-shift) – move as-is to cloud (EC2); fastest, minimal changes. **Relocate** – move to cloud without changes using VMware Cloud on AWS. **Replatform** (lift-tinker-and-shift) – minor optimizations (e.g., move to RDS instead of self-managed DB). **Repurchase** – switch to a SaaS product (e.g., move CRM to Salesforce). **Refactor/Re-architect** – redesign using cloud-native services (Lambda, DynamoDB); most effort but most benefit.

---

### Card 2
**Q:** What is AWS Database Migration Service (DMS)?
**A:** DMS migrates databases to AWS with minimal downtime. The source database remains operational during migration. Supports: **homogeneous** (Oracle → Oracle) and **heterogeneous** (Oracle → Aurora) migrations. Components: **Replication Instance** (EC2 that runs migration tasks), **Source/Target Endpoints**, **Migration Task** (full load, CDC, or both). **Change Data Capture (CDC)** enables continuous replication after the initial full load. Supports: on-premises → AWS, AWS → AWS, AWS → on-premises. Multi-AZ option for HA.

---

### Card 3
**Q:** What is the difference between DMS and AWS Schema Conversion Tool (SCT)?
**A:** **DMS** – migrates the **data** between databases. Handles full load + ongoing replication (CDC). Source stays operational. **SCT** – converts the **database schema** (tables, views, stored procedures, functions) from one engine to another (e.g., Oracle to PostgreSQL). SCT also converts application SQL code. Use together for heterogeneous migrations: SCT converts the schema first, then DMS migrates the data. For homogeneous migrations (same engine), SCT is not needed.

---

### Card 4
**Q:** What are the DMS migration types?
**A:** **Full load** – migrates all existing data from source to target in a single batch. **CDC (Change Data Capture)** – captures ongoing changes from the source and applies them to the target in near-real-time. **Full load + CDC** – initial full load followed by continuous CDC replication until cutover. Full load + CDC is the most common approach — it minimizes downtime. After initial sync, CDC keeps source and target in sync until you're ready to cut over.

---

### Card 5
**Q:** What is AWS Application Migration Service (MGN)?
**A:** MGN (formerly CloudEndure Migration) is the primary service for **rehosting** (lift-and-shift) migrations. It performs continuous block-level replication from source servers (physical, virtual, or cloud) to AWS. Process: install the replication agent → continuous replication to staging area → test instances → cutover (launch production instances). Supports: Windows and Linux. Minimal downtime (cutover in minutes). Handles OS, applications, and data. Replaces the older Server Migration Service (SMS).

---

### Card 6
**Q:** What is the difference between MGN and DMS?
**A:** **MGN (Application Migration Service)** – migrates **entire servers** (OS + applications + data); block-level replication; for rehosting. Think "lift-and-shift entire machines." **DMS** – migrates **databases** only; logical replication at the data/schema level; supports heterogeneous migrations; source stays online. Use MGN for migrating servers/VMs to EC2. Use DMS for migrating databases to RDS/Aurora/DynamoDB. They can be used together: MGN for application servers, DMS for databases.

---

### Card 7
**Q:** What is AWS DataSync and when should you use it?
**A:** DataSync automates and accelerates data transfer between on-premises storage (NFS, SMB, HDFS, self-managed object storage) and AWS storage services (S3, EFS, FSx). Also supports AWS-to-AWS transfers. Features: up to 10 Gbps throughput, built-in encryption, data integrity verification, bandwidth throttling, scheduling. Use for: one-time data migrations, recurring data processing workflows, replication for DR or HA. Agent-based (on-premises agent) or agentless (AWS-to-AWS). Not for database migration (use DMS).

---

### Card 8
**Q:** How does Snow Family sizing work for data migration?
**A:** **Snowcone** – 8 TB HDD or 14 TB SSD; for small edge/remote data collection. **Snowball Edge Storage Optimized** – 80 TB usable; for medium data transfers. **Snowball Edge Compute Optimized** – 42 TB; when edge computing is also needed. **Snowmobile** – up to 100 PB per truck; for data center-scale migrations. Rule of thumb: if network transfer at available bandwidth would take **more than 1 week**, consider Snow Family. Multiple devices can be used in parallel. Each device has tamper-evident, 256-bit encryption, and chain-of-custody tracking.

---

### Card 9
**Q:** What are the four main Disaster Recovery strategies in order of RTO?
**A:** From **slowest to fastest** RTO (and cheapest to most expensive): 1) **Backup & Restore** – backup data to S3/Glacier; restore when needed; RTO: hours. 2) **Pilot Light** – core infrastructure running at minimum (e.g., DB replication); scale up on disaster; RTO: 10s of minutes. 3) **Warm Standby** – scaled-down but fully functional copy; scale up on disaster; RTO: minutes. 4) **Multi-Site / Hot Standby** – full production in 2+ regions; instant failover; RTO: near-zero, real-time. Cost increases with lower RTO.

---

### Card 10
**Q:** What is the Backup & Restore DR strategy?
**A:** The simplest and cheapest DR strategy. Data is regularly backed up to S3 (or Glacier for cost savings). AMIs and CloudFormation templates are stored. On disaster: restore from backups, launch infrastructure from templates. **RPO**: depends on backup frequency (hours to daily). **RTO**: hours (time to restore and provision). Use for: non-critical workloads, cost-sensitive environments. Key AWS services: S3, Glacier, EBS Snapshots, RDS automated backups, AWS Backup. Automated backups reduce RPO.

---

### Card 11
**Q:** What is the Pilot Light DR strategy?
**A:** Pilot Light keeps the **minimum core infrastructure** running in the DR region — typically just database replication (RDS Multi-AZ cross-region read replica or Aurora Global Database). Application servers, load balancers, and other components are pre-configured (AMIs, templates, DNS records) but **not running**. On disaster: promote the DB replica, scale up application tier from AMIs/ASG, switch DNS. **RPO**: near-zero (continuous replication). **RTO**: 10s of minutes (time to provision and start app servers).

---

### Card 12
**Q:** What is the Warm Standby DR strategy?
**A:** Warm Standby runs a **scaled-down but fully functional** copy of the production environment in the DR region. The application is running but at minimum capacity (smaller instances, fewer instances). DB is replicated. On disaster: scale up to production size (ASG adjusts, larger instances) and switch DNS. **RPO**: near-zero (continuous replication). **RTO**: minutes (infrastructure is already running, just needs scaling). More expensive than Pilot Light but faster recovery. Good for business-critical workloads.

---

### Card 13
**Q:** What is the Multi-Site / Hot Standby DR strategy?
**A:** Multi-Site runs **full production capacity** in two or more regions simultaneously. Both regions actively handle traffic (active-active using Route 53 weighted or latency-based routing). Data is replicated in near-real-time (Aurora Global Database, DynamoDB Global Tables). On disaster: Route 53 health checks detect failure and route all traffic to the healthy region. **RPO**: near-zero. **RTO**: near-zero (automatic failover). Most expensive but provides the best availability. Use for mission-critical, zero-downtime requirements.

---

### Card 14
**Q:** What is RPO and RTO?
**A:** **RPO (Recovery Point Objective)** – the maximum acceptable amount of data loss measured in time. Example: RPO of 1 hour means you can tolerate losing up to 1 hour of data. Determines backup frequency. **RTO (Recovery Time Objective)** – the maximum acceptable downtime after a disaster. Example: RTO of 15 minutes means the system must be operational within 15 minutes. Determines the DR strategy complexity. Lower RPO/RTO = higher cost and complexity. The exam frequently asks you to choose solutions based on RPO/RTO requirements.

---

### Card 15
**Q:** How do RPO and RTO map to DR strategies?
**A:** **Backup & Restore** – RPO: hours; RTO: hours (24+). **Pilot Light** – RPO: minutes; RTO: 10s of minutes. **Warm Standby** – RPO: seconds-minutes; RTO: minutes. **Multi-Site Active-Active** – RPO: near-zero; RTO: near-zero (automatic). When the exam gives an RPO of "1 hour" and an RTO of "several hours" → Backup & Restore is sufficient. RPO "near-zero" with RTO "under 1 minute" → Multi-Site. Match the DR strategy to the stated RPO/RTO while minimizing cost.

---

### Card 16
**Q:** What are the six pillars of the AWS Well-Architected Framework?
**A:** 1) **Operational Excellence** – run and monitor systems to deliver business value; automate changes; respond to events. 2) **Security** – protect data, systems, and assets; identity management; detective controls. 3) **Reliability** – recover from failures; meet demand; mitigate disruptions. 4) **Performance Efficiency** – use computing resources efficiently; right-size; adopt new technologies. 5) **Cost Optimization** – avoid unnecessary costs; understand spending; optimize over time. 6) **Sustainability** – minimize environmental impact of cloud workloads.

---

### Card 17
**Q:** What is the Reliability pillar of the Well-Architected Framework?
**A:** The Reliability pillar focuses on ensuring a workload performs its intended function correctly and consistently. Key design principles: **Automatically recover from failure** (health checks, auto-recovery), **Test recovery procedures** (Game Days, chaos engineering), **Scale horizontally** (distribute requests across multiple resources), **Stop guessing capacity** (auto-scaling), **Manage change through automation** (IaC, CI/CD). Key services: Multi-AZ, Auto Scaling, ELB, Route 53 health checks, CloudFormation, S3 (11 nines durability).

---

### Card 18
**Q:** What is Aurora Global Database failover?
**A:** **Managed planned failover** – used for controlled scenarios (region migration, DR testing). Promotes a secondary region to primary with **no data loss** (RPO = 0). The old primary becomes a secondary. Takes a few minutes. **Unplanned failover** (detach and promote) – used during actual disasters. Detach a secondary region and promote it to standalone. **RPO typically < 1 second** (based on replication lag). RTO < 1 minute. After promotion, you must recreate the Global Database relationship. Update application endpoints.

---

### Card 19
**Q:** How does DynamoDB Global Tables support DR?
**A:** DynamoDB Global Tables provide **active-active** replication across multiple regions. Each replica is a fully functional read-write table. Replication latency is typically < 1 second. If a region goes down, applications can be redirected to any other region immediately. **RPO**: near-zero (asynchronous replication). **RTO**: near-zero (other replicas are already active). Conflict resolution: last-writer-wins by timestamp. Applications should use region-specific endpoints or Global Tables-aware routing.

---

### Card 20
**Q:** What is AWS Elastic Disaster Recovery (DRS)?
**A:** AWS DRS (formerly CloudEndure Disaster Recovery) provides continuous block-level replication of on-premises or cloud servers to AWS. It maintains a lightweight staging area in the target AWS region. On disaster: launch full-capacity recovery instances in minutes. **RPO**: seconds (continuous replication). **RTO**: minutes (launch from replicated data). Supports Windows and Linux. Use for: disaster recovery of on-premises data centers to AWS, or cross-region DR within AWS. Lower cost than Warm Standby because staging resources are minimal.

---

### Card 21
**Q:** What is AWS Backup?
**A:** AWS Backup is a centralized, fully managed backup service. Supports: EC2 (AMIs), EBS, RDS, Aurora, DynamoDB, EFS, FSx, Storage Gateway, S3, Neptune, DocumentDB, and VMware on-premises. Features: **Backup Plans** (schedules, retention, lifecycle to cold storage), **Backup Vault** (encrypted storage with access policies, vault lock for WORM compliance), **Cross-Region Backup**, **Cross-Account Backup** (via Organizations), **PITR** for supported services. Centralizes backup management instead of per-service backup configuration.

---

### Card 22
**Q:** What is AWS Backup Vault Lock?
**A:** Backup Vault Lock enforces a WORM (Write Once Read Many) policy on a backup vault. Once locked, backups in the vault **cannot be deleted** by any user, including the root account, until the retention period expires. Two modes: **Governance mode** – users with specific permissions can remove the lock. **Compliance mode** – once locked, it **cannot be changed or deleted** (irreversible). Use for: regulatory compliance, ransomware protection, ensuring backup integrity. Applied at the vault level.

---

### Card 23
**Q:** What is a multi-region architecture pattern for high availability?
**A:** Active-active: deploy in 2+ regions with Route 53 routing (latency, weighted, or failover). Database: Aurora Global Database or DynamoDB Global Tables. Static assets: S3 with CRR, CloudFront with multiple origins. Compute: independent ASGs in each region. State: externalize to ElastiCache Global Datastore or DynamoDB. Session: store in DynamoDB or ElastiCache (not sticky sessions). Monitoring: centralized via CloudWatch cross-account or Security Hub. DNS failover using Route 53 health checks for automatic traffic shifting.

---

### Card 24
**Q:** What is Amazon Route 53 Application Recovery Controller (ARC)?
**A:** ARC provides readiness checks and routing controls for application failover across AWS Regions and AZs. **Readiness checks** – continuously monitor that your recovery environment (target region) is configured correctly and ready to handle traffic. **Routing controls** – highly available data plane for switching traffic between regions (using Route 53 health checks). Routing controls operate on a separate, redundant infrastructure to ensure they work even during AWS failures. Use for: controlled and reliable multi-region failover.

---

### Card 25
**Q:** What is the difference between HA and DR?
**A:** **High Availability (HA)** – the ability of a system to remain operational with minimal downtime. Typically within a region using Multi-AZ. Goal: prevent outages. Examples: Multi-AZ RDS, ALB across AZs, ASG. **Disaster Recovery (DR)** – the ability to recover from a catastrophic failure (region outage, natural disaster). Typically cross-region. Goal: recover from outages. Examples: Aurora Global Database, S3 CRR, Pilot Light. HA prevents single points of failure; DR prepares for worst-case scenarios. They complement each other.

---

### Card 26
**Q:** What is the HA pattern for each compute service?
**A:** **EC2** – ASG across multiple AZs with ELB; placement groups for performance. **ECS/EKS** – tasks distributed across AZs; ELB for load distribution. **Lambda** – inherently HA across AZs within a region; multi-region requires explicit setup. **RDS** – Multi-AZ deployment (synchronous standby). **Aurora** – storage replicates 6 copies across 3 AZs; failover < 30s. **DynamoDB** – data replicated across 3 AZs; Global Tables for multi-region. **S3** – 11 nines durability, data stored across 3+ AZs.

---

### Card 27
**Q:** What is the ElastiCache Global Datastore?
**A:** ElastiCache Global Datastore for Redis provides cross-region replication. One primary cluster (read/write) and up to 2 secondary clusters (read-only) in different regions. Replication lag is typically < 1 second. On disaster: promote a secondary to primary. Use for: cross-region read scaling and disaster recovery. The primary cluster handles writes; secondary clusters handle local reads. Requires Redis engine version 5.0.6+. Promotes the DR story for applications using ElastiCache Redis.

---

### Card 28
**Q:** How do you implement DR for S3?
**A:** **Cross-Region Replication (CRR)** – automatically replicate objects to a bucket in another region. **S3 Replication Time Control** – guarantees 99.99% of objects replicated within 15 minutes. **Versioning** – protect against accidental deletes. **S3 Object Lock** – prevent deletion (compliance). **S3 event notifications** – trigger workflows on replication events. For RPO: CRR with RTC provides ~15-minute RPO. For critical data, combine with AWS Backup and lifecycle policies. Static website hosting can serve as a DR failover site.

---

### Card 29
**Q:** What is AWS Migration Hub?
**A:** Migration Hub provides a single location to track the progress of application migrations across multiple AWS tools. It integrates with: MGN (Application Migration Service), DMS, and partner tools. Features: **discovery** (discover on-premises inventory using Application Discovery Service), **grouping** (organize servers into applications), **tracking** (monitor migration progress per application). Migration Hub doesn't perform migrations — it's a central dashboard. Migration Hub Orchestrator provides predefined workflow templates for common migration patterns.

---

### Card 30
**Q:** What is AWS Application Discovery Service?
**A:** Application Discovery Service collects data about on-premises servers for migration planning. Two modes: **Agentless Discovery** (via Discovery Connector — a VMware vCenter OVA) – collects VM inventory, configuration, CPU/memory/disk utilization. **Agent-based Discovery** (install agents on servers) – collects detailed data including network connections, running processes, and system performance. Data feeds into Migration Hub for dependency mapping and migration planning. Helps identify which servers can be grouped and migrated together.

---

### Card 31
**Q:** What is AWS Transfer Family?
**A:** AWS Transfer Family provides managed SFTP, FTPS, FTP, and AS2 protocol endpoints for transferring files into and out of **S3** or **EFS**. Use for: migrating file transfer workflows to AWS without changing client applications. Features: custom identity providers (AD, Lambda), VPC endpoint support, custom hostnames with Route 53, IAM-based access control, CloudWatch/CloudTrail integration. Clients continue using their existing SFTP/FTPS clients while files are stored in S3/EFS.

---

### Card 32
**Q:** What is the AWS Snow Family ordering and data transfer workflow?
**A:** 1) **Order** – request a Snow device via the console. 2) **Receive** – device arrives preconfigured and encrypted. 3) **Connect & Load** – connect to your network, install the Snowball client or OpsHub, transfer data. 4) **Ship back** – send to AWS using the prepaid shipping label. 5) **Import to S3** – AWS imports data into your designated S3 bucket. 6) **Verify** – confirm data in S3. 7) **Wipe** – AWS securely erases the device. For export: you order, AWS loads data from S3, ships to you. Each device is tamper-resistant with 256-bit encryption.

---

### Card 33
**Q:** What is the difference between DataSync and Storage Gateway for ongoing data transfer?
**A:** **DataSync** – designed for **data migration and scheduled transfers**; moves data between on-premises and AWS (or AWS-to-AWS); agent-based; high throughput; validates data integrity; use for one-time migrations or recurring sync jobs. **Storage Gateway** – designed for **hybrid cloud storage**; provides on-premises access to cloud storage with local caching; ongoing, continuous use; protocols: NFS, SMB, iSCSI. Think DataSync = move data TO AWS. Storage Gateway = bridge between on-premises and AWS for ongoing access.

---

### Card 34
**Q:** What is RDS cross-region read replica for DR?
**A:** RDS read replicas can be created in **different regions** for MySQL, PostgreSQL, and MariaDB. They use asynchronous replication. For DR: promote the cross-region read replica to a standalone DB instance in the DR region. **RPO**: depends on replication lag (typically seconds to minutes). **RTO**: minutes (promote and update application). After promotion, the replica becomes an independent database (replication stops). Combine with Route 53 failover for automated DNS switching. Aurora Global Database is preferred for Aurora workloads.

---

### Card 35
**Q:** What is the difference between RTO and MTTR?
**A:** **RTO (Recovery Time Objective)** – the maximum tolerable time the business can survive without the IT system after a disaster. It's a **business requirement**. **MTTR (Mean Time To Recovery/Repair)** – the average actual time to restore a system after failure. It's a **measured metric**. Your MTTR should be **less than** your RTO. If your MTTR exceeds your RTO, you need to invest in faster recovery mechanisms (better DR strategy, automation, runbooks).

---

### Card 36
**Q:** How do you automate DR failover?
**A:** Key automation components: **Route 53 health checks** – detect endpoint failure and trigger DNS failover automatically. **CloudWatch Alarms + EventBridge** – detect failure metrics and trigger Lambda functions for remediation. **ASG** – automatically replace failed instances. **RDS Multi-AZ** – automatic database failover. **Step Functions** – orchestrate complex failover workflows. **SSM Automation runbooks** – execute predefined recovery steps. **AWS Backup** – scheduled, automated backups. Full automation = Multi-Site Active-Active with Route 53 health checks.

---

### Card 37
**Q:** What is AWS Fault Injection Simulator (FIS)?
**A:** FIS is a managed chaos engineering service that lets you inject failures into AWS workloads to test resilience. Supported actions: terminate EC2 instances, throttle EBS/S3, disrupt network connectivity, inject Lambda errors, stress CPU/memory, create API errors. Experiments are defined with targets (resources), actions (faults), and stop conditions (safety guards). Integrates with CloudWatch for monitoring. Use for: validating DR plans, testing auto-recovery, preparing for Game Days, and verifying architectural assumptions.

---

### Card 38
**Q:** What is a Game Day in the context of DR?
**A:** A Game Day is a planned exercise where teams simulate real-world failure scenarios to test incident response procedures, DR plans, and system resilience. AWS recommends regular Game Days as part of the Reliability pillar. Activities: simulate region failures, database crashes, DDoS attacks, or mass deployment failures. Tools: AWS FIS for controlled fault injection. Benefits: identify gaps in runbooks, improve team coordination, validate monitoring and alerting, build confidence in recovery procedures.

---

### Card 39
**Q:** What are the data transfer speed considerations for migration?
**A:** **Internet** – limited by your bandwidth; 1 Gbps = ~10 TB/day. **Direct Connect** – dedicated 1/10/100 Gbps; ~10-100 TB/day; weeks to provision. **Snowball Edge** – 80 TB per device; ship in ~1 week including transit; use when transfer would take > 1 week over network. **Snowmobile** – 100 PB per container; for massive data centers. **DataSync over DX** – up to 10 Gbps. Calculate: `(Data volume in TB × 8 × 1024) / (bandwidth in Gbps × 86400) = days`. If > 7 days, consider offline transfer.

---

### Card 40
**Q:** What is the Well-Architected Operational Excellence pillar?
**A:** Operational Excellence focuses on running and monitoring systems to deliver business value and continually improve processes. Key principles: **Perform operations as code** (CloudFormation, CDK). **Make frequent, small, reversible changes**. **Refine operations procedures frequently**. **Anticipate failure** (pre-mortem analysis). **Learn from all operational failures**. Key services: CloudFormation, Config, CloudTrail, CloudWatch, X-Ray, Systems Manager, CodePipeline, EventBridge.

---

### Card 41
**Q:** What is the Well-Architected Security pillar?
**A:** The Security pillar focuses on protecting information, systems, and assets. Key principles: **Implement a strong identity foundation** (least privilege, IAM). **Enable traceability** (CloudTrail, Config, VPC Flow Logs). **Apply security at all layers** (VPC, subnet, instance, application). **Automate security best practices** (Config rules, Security Hub). **Protect data in transit and at rest** (KMS, ACM, TLS). **Keep people away from data** (eliminate direct access). **Prepare for security events** (incident response plan, GuardDuty).

---

### Card 42
**Q:** What is the Well-Architected Cost Optimization pillar?
**A:** Cost Optimization focuses on avoiding unnecessary costs. Key principles: **Implement cloud financial management** (Cost Explorer, Budgets). **Adopt a consumption model** (pay for what you use). **Measure overall efficiency** (cost per business outcome). **Stop spending money on undifferentiated heavy lifting** (managed services). **Analyze and attribute expenditure** (tagging, Cost Allocation Tags). Key services: Reserved Instances, Savings Plans, Spot Instances, S3 lifecycle policies, right-sizing (Compute Optimizer), Auto Scaling.

---

### Card 43
**Q:** What is the Well-Architected Performance Efficiency pillar?
**A:** Performance Efficiency focuses on using computing resources efficiently. Key principles: **Democratize advanced technologies** (use managed services). **Go global in minutes** (multi-region with CloudFront, Global Accelerator). **Use serverless architectures**. **Experiment more often**. **Consider mechanical sympathy** (use the right tool for the job). Key services: Auto Scaling, Lambda, ElastiCache, CloudFront, choosing the right instance type/database/storage based on workload characteristics.

---

### Card 44
**Q:** What is the Well-Architected Sustainability pillar?
**A:** The Sustainability pillar focuses on minimizing environmental impact. Key principles: **Understand your impact** (track resources and emissions). **Establish sustainability goals**. **Maximize utilization** (right-size, auto-scale). **Adopt new, efficient technologies** (managed services, serverless). **Use managed services** (AWS handles optimization). **Reduce downstream impact** (minimize data transfer, optimize data storage). Key practices: use Graviton processors (more efficient), right-size instances, delete unused resources, use efficient storage classes.

---

### Card 45
**Q:** What is AWS Compute Optimizer?
**A:** Compute Optimizer recommends optimal AWS resources based on historical utilization data. Analyzes: **EC2 instances** (right-sizing recommendations), **EBS volumes** (volume type and size), **Lambda functions** (memory configuration), **ECS on Fargate** (task CPU/memory sizing), **Auto Scaling Groups**. Uses ML to analyze CloudWatch metrics. Recommendations include: projected performance impact and estimated monthly savings. Requires CloudWatch metrics (at least 8 hours, 14 days recommended). Helps with both cost optimization and performance efficiency.

---

### Card 46
**Q:** What is the migration process using AWS MGN?
**A:** 1) **Install replication agent** on source servers. 2) Agent performs **continuous block-level replication** to a lightweight staging area in the target AWS region (low-cost EC2 + EBS). 3) **Test** – launch test instances from replicated data; validate functionality. 4) **Cutover** – when ready, launch cutover instances (production-sized); switch traffic. 5) **Finalize** – decommission source servers. Throughout the process, replication continues in the background. The staging area uses minimal resources to keep costs low.

---

### Card 47
**Q:** What is AWS DMS continuous replication (CDC) vs. one-time migration?
**A:** **One-time (full load)** – copies all data from source to target once. Requires downtime for cutover (source writes must be stopped to avoid data loss). Simple but not zero-downtime. **Continuous replication (CDC)** – after initial full load, DMS captures ongoing changes from the source transaction log and applies them to the target. Source remains fully operational. Cutover can happen when the target is caught up (replication lag near zero). Enables near-zero-downtime migrations.

---

### Card 48
**Q:** What is the AWS Well-Architected Tool?
**A:** The Well-Architected Tool (available in the AWS console) helps you review your architecture against the six Well-Architected pillars. Process: define a workload → answer questions for each pillar → receive a risk assessment (High Risk, Medium Risk, No Risk per question) → get improvement recommendations with links to documentation. Generates a report you can share with stakeholders. Can be re-run periodically to track improvement over time. It's a self-service review, not an audit.

---

### Card 49
**Q:** What is the difference between EBS snapshots and AMIs for DR?
**A:** **EBS Snapshots** – backup of a single EBS volume; incremental; can be copied cross-region; used to create new volumes. **AMIs** – template for launching entire EC2 instances; includes one or more EBS snapshots (one per volume) plus launch permissions and device mappings. For DR: use AMIs to quickly launch pre-configured instances in the DR region. Copy AMIs cross-region periodically. Use snapshots for data volume backup/restore. AMIs = faster instance recovery. Snapshots = data volume recovery.

---

### Card 50
**Q:** What is the recommended approach for a large-scale enterprise migration?
**A:** The AWS **Migration Acceleration Program (MAP)** framework: **Phase 1 – Assess** – use Application Discovery Service to inventory on-premises resources, analyze dependencies, build a business case (TCO analysis using Migration Evaluator). **Phase 2 – Mobilize** – create a migration plan, train teams, set up a landing zone (Control Tower), establish a migration factory process. **Phase 3 – Migrate & Modernize** – execute migrations using MGN (rehost), DMS (databases), refactoring where beneficial. Use Migration Hub to track progress. Iterate through waves of applications.

---

*End of Deck 9 — 50 cards*
