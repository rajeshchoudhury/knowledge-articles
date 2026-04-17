# Migration & DR Question Bank

**AWS Solutions Architect Associate (SAA-C03) — Topic-Wise Practice**
**Total Questions: 30**

---

### Question 1
A company wants to migrate a legacy on-premises application to AWS with minimal code changes. They want to leverage managed services where possible but keep the same architecture. Which migration strategy (from the 7 Rs) does this describe?

A) Rehost (Lift and Shift)
B) Replatform (Lift, Tinker, and Shift)
C) Refactor / Re-architect
D) Retire

**Answer: B**
**Explanation:** Replatforming involves making targeted optimizations during migration without changing the core architecture. For example, moving from self-managed MySQL to RDS MySQL. Rehosting (A) moves with zero changes. Refactoring (C) involves significant redesign. Retire (D) means decommissioning the application.

---

### Question 2
A company has 200 on-premises servers to migrate to AWS. They want to perform an automated lift-and-shift migration with minimal downtime. The servers run a mix of Windows and Linux. What tool should the architect recommend?

A) AWS Database Migration Service (DMS)
B) AWS Application Migration Service (MGN)
C) AWS DataSync
D) VM Import/Export

**Answer: B**
**Explanation:** AWS Application Migration Service (MGN) automates lift-and-shift migrations by continuously replicating servers to AWS. It supports Windows and Linux and provides minimal downtime cutover. DMS (A) is for database migration. DataSync (C) is for data transfer. VM Import/Export (D) is manual and doesn't provide continuous replication.

---

### Question 3
A company is migrating an Oracle database to Amazon Aurora PostgreSQL. The database uses Oracle-specific features like PL/SQL stored procedures and Oracle-native data types. What tools should the architect use for this heterogeneous migration?

A) AWS DMS only
B) AWS Schema Conversion Tool (SCT) to convert the schema, then AWS DMS for data migration
C) Native Oracle export/import tools
D) AWS DataSync for data transfer

**Answer: B**
**Explanation:** For heterogeneous migrations (different database engines), AWS SCT converts the database schema, stored procedures, and application code from the source to the target engine. DMS then migrates the data with optional ongoing replication. DMS alone (A) migrates data but doesn't convert schema/procedures. Oracle native tools (C) don't work with PostgreSQL. DataSync (D) is for file transfer.

---

### Question 4
A company's RPO (Recovery Point Objective) is 1 hour and RTO (Recovery Time Objective) is 4 hours for their critical application. They have a limited DR budget. Which DR strategy is the MOST cost-effective while meeting these requirements?

A) Multi-site active-active
B) Warm standby
C) Pilot light
D) Backup and restore

**Answer: C**
**Explanation:** Pilot light keeps core components (database replication) running in the DR region with minimal infrastructure. It can be scaled up to full production within the 4-hour RTO. RPO of 1 hour is achievable with continuous database replication. Backup and restore (D) is cheapest but may not meet the 4-hour RTO for large systems. Warm standby (B) has higher costs with always-running scaled-down infrastructure. Multi-site (A) is the most expensive.

---

### Question 5
A company has an RTO of 15 minutes and RPO of near-zero for their mission-critical application. They need the DR site to be able to handle production traffic immediately upon failover. Which DR strategy should the architect implement?

A) Backup and restore
B) Pilot light
C) Warm standby
D) Multi-site active-active

**Answer: D**
**Explanation:** Multi-site active-active runs the full application in both the primary and DR regions simultaneously. Traffic is distributed across both regions, so failover is near-instantaneous (RTO ~minutes) with near-zero RPO (synchronous or near-synchronous replication). Warm standby (C) requires scaling up. Pilot light (B) requires provisioning. Backup and restore (A) has the longest RTO.

---

### Question 6
A company has 50 TB of data on-premises that needs to be migrated to S3 within a week. Their internet bandwidth is 1 Gbps, which is shared with production traffic. They can only use 30% of the bandwidth for migration. What is the BEST migration method?

A) AWS DataSync over the internet
B) AWS Snowball Edge Storage Optimized
C) S3 multipart upload
D) Direct Connect with a dedicated 10 Gbps link

**Answer: B**
**Explanation:** At 300 Mbps effective bandwidth (30% of 1 Gbps), transferring 50 TB would take approximately 15.5 days — exceeding the 1-week deadline. A Snowball Edge device (80 TB capacity) can be shipped, loaded, and returned within a week. DataSync (A) and multipart upload (C) are limited by the available bandwidth. Direct Connect (D) takes weeks to provision.

---

### Question 7
A company is migrating their SQL Server database from on-premises to RDS SQL Server. They want to minimize downtime during the migration. The database is 500 GB. What approach should the architect take?

A) Use native SQL Server backup/restore to S3, then restore on RDS
B) Use AWS DMS with full load and ongoing CDC (Change Data Capture) replication
C) Use AWS Snowball to transfer the database files
D) Manually recreate the database schema and INSERT data

**Answer: B**
**Explanation:** DMS with full load plus CDC migrates the initial 500 GB and then continuously replicates changes. During cutover, the application switches to RDS with minimal data lag. Native backup/restore (A) requires downtime during restore and doesn't capture changes during migration. Snowball (C) is for large offline data transfers. Manual recreation (D) is time-consuming and error-prone.

---

### Question 8
A company is evaluating their application portfolio for cloud migration. They have identified several applications that are no longer needed. Which of the 7 Rs applies to these applications?

A) Retire
B) Retain
C) Rehost
D) Repurchase

**Answer: A**
**Explanation:** Retire means decommissioning applications that are no longer useful or needed. This reduces the migration scope and operational costs. Retain (B) means keeping them on-premises as-is. Rehost (C) means lifting and shifting. Repurchase (D) means replacing with a SaaS solution.

---

### Question 9
A company currently uses a self-hosted CRM application on-premises. They decide to move to Salesforce (a SaaS offering) instead of migrating the existing application to AWS. Which migration strategy does this represent?

A) Rehost
B) Replatform
C) Repurchase
D) Refactor

**Answer: C**
**Explanation:** Repurchase (also called "drop and shop") means moving from a self-hosted application to a SaaS/commercial off-the-shelf product. Moving from a self-hosted CRM to Salesforce is a classic repurchase. Rehost (A) moves the same application. Replatform (B) makes targeted optimizations. Refactor (D) redesigns the architecture.

---

### Question 10
A company runs a disaster recovery site on AWS using the warm standby strategy. The DR environment runs a scaled-down version of the production environment. When a disaster is declared, what steps need to happen?

A) Restore from S3 backups and launch new instances
B) Scale up the existing resources (increase instance sizes, add instances to ASGs) and update DNS to point to the DR region
C) Launch all new infrastructure from CloudFormation templates
D) Promote read replicas and deploy application code

**Answer: B**
**Explanation:** Warm standby has a fully functional but scaled-down environment running. During failover, you scale it up to production capacity (increase ASG desired counts, resize instances) and update Route 53 DNS to direct traffic to the DR region. You don't need to restore from backups (A) or launch from scratch (C) because the infrastructure is already running.

---

### Question 11
A company wants to use AWS Backup to centrally manage backups for their RDS databases, EBS volumes, EFS file systems, and DynamoDB tables. They need cross-region backup copies for disaster recovery. What should the architect configure?

A) Individual backup scripts for each service
B) AWS Backup with a backup plan, resource assignments, and cross-region copy rules
C) CloudFormation to create snapshots and copy them
D) Lambda functions triggered by CloudWatch Events for each service

**Answer: B**
**Explanation:** AWS Backup provides a centralized, policy-based backup solution that supports RDS, EBS, EFS, DynamoDB, and more. Backup plans define schedules, retention, and cross-region copy rules. It's a single, managed service that replaces custom scripts. Individual scripts (A), CloudFormation (C), and Lambda functions (D) are fragmented, custom solutions.

---

### Question 12
A company is running their application in `us-east-1` with an RDS MySQL Multi-AZ deployment. For disaster recovery, they need a database copy in `eu-west-1`. The RPO must be less than 5 minutes. What should the architect configure?

A) RDS automated backups with cross-region copy
B) RDS cross-region Read Replica in `eu-west-1`
C) AWS DMS for continuous replication to an RDS instance in `eu-west-1`
D) Manual snapshots copied to `eu-west-1` hourly

**Answer: B**
**Explanation:** RDS cross-region Read Replicas use asynchronous replication with typical lag of seconds to minutes, meeting the 5-minute RPO. The replica can be promoted to a standalone database during DR. Automated backup copies (A) have a daily RPO at best. DMS (C) works but is more complex for same-engine replication. Manual snapshots (D) have hourly RPO.

---

### Question 13
A company is designing a multi-region architecture and wants to use Route 53 for DNS failover. When the primary region becomes unhealthy, traffic should automatically route to the secondary region. What Route 53 configuration is needed?

A) Simple routing with two records
B) Failover routing policy with health checks on the primary endpoint
C) Weighted routing with 100% to primary and 0% to secondary
D) Latency-based routing with both regions

**Answer: B**
**Explanation:** Failover routing policy with health checks creates a primary and secondary record. Route 53 health checks monitor the primary endpoint. When the health check fails, traffic automatically routes to the secondary record (DR region). Simple routing (A) doesn't support failover. Weighted routing (C) at 0% would never send traffic to secondary. Latency-based (D) routes based on latency, not health.

---

### Question 14
A company is performing a large-scale migration of 500 servers to AWS. They need to plan the migration in waves, track migration progress, and identify application dependencies. What tool should the architect use?

A) AWS Application Discovery Service and AWS Migration Hub
B) AWS CloudFormation
C) AWS DataSync
D) AWS Control Tower

**Answer: A**
**Explanation:** AWS Application Discovery Service discovers on-premises servers, their configurations, performance data, and network dependencies. AWS Migration Hub provides a single dashboard to track migration progress across multiple migration tools (MGN, DMS). CloudFormation (B) deploys infrastructure. DataSync (C) transfers data. Control Tower (D) manages multi-account environments.

---

### Question 15
A company has a hybrid architecture with workloads on both on-premises and AWS. They want a unified backup solution that covers both environments and stores backups in AWS. What should the architect recommend?

A) AWS Backup for AWS resources and custom scripts for on-premises
B) AWS Backup with AWS Storage Gateway for on-premises data backup to AWS
C) Third-party backup software only
D) rsync to S3 for on-premises data

**Answer: B**
**Explanation:** AWS Backup supports AWS native services directly and can back up on-premises data through AWS Storage Gateway (Volume Gateway and Tape Gateway). This provides a unified backup solution. Custom scripts (A) and rsync (D) are fragmented approaches. Third-party software (C) doesn't leverage AWS Backup's centralized management.

---

### Question 16
A company wants to migrate their on-premises VMware VMs to AWS. They want to keep using their existing VMware tools and processes during migration and eventually run natively on EC2. What service should the architect recommend?

A) AWS Application Migration Service (MGN)
B) VMware Cloud on AWS for initial lift, then migrate to native EC2
C) VM Import/Export
D) AWS Snowball Edge for VM transfer

**Answer: A**
**Explanation:** AWS MGN (Application Migration Service) supports migration from VMware environments to EC2. It installs an agent on source VMs, continuously replicates data, and performs automated cutover to native EC2 instances. VMware Cloud on AWS (B) keeps workloads on VMware, which is more expensive. VM Import/Export (C) is manual. Snowball (D) is for offline data transfer.

---

### Question 17
A company operates a well-architected application on AWS. During a recent review, they scored poorly on the "Cost Optimization" pillar. Which of the following actions would address this?

A) Implement Multi-AZ deployments for all databases
B) Right-size EC2 instances, use Reserved Instances for steady-state workloads, and implement auto-scaling for variable workloads
C) Add more security groups and NACLs
D) Enable CloudTrail in all regions

**Answer: B**
**Explanation:** The Cost Optimization pillar of the Well-Architected Framework focuses on running systems at the lowest cost. Right-sizing eliminates over-provisioned resources, Reserved Instances reduce compute costs for predictable workloads, and Auto Scaling matches capacity to demand. Multi-AZ (A) is Reliability pillar. Security groups (C) are Security pillar. CloudTrail (D) is Operational Excellence.

---

### Question 18
A company has an on-premises Oracle Data Warehouse that they want to migrate to AWS. The data warehouse is 20 TB and uses complex ETL processes. They want a cloud-native solution. What should the architect recommend?

A) Rehost Oracle on EC2
B) Use AWS SCT to convert the schema to Amazon Redshift, and DMS to migrate the data
C) Migrate to RDS Oracle
D) Use S3 and Athena as the data warehouse replacement

**Answer: B**
**Explanation:** AWS SCT can convert Oracle Data Warehouse schemas (including stored procedures and ETL logic where possible) to Amazon Redshift. DMS migrates the data. Redshift is AWS's cloud-native data warehouse designed for OLAP workloads. Rehosting on EC2 (A) or RDS (C) doesn't reduce licensing costs. S3/Athena (D) is for ad-hoc queries, not a full data warehouse replacement.

---

### Question 19
A company's Well-Architected review identified that their application has a single point of failure in the database tier. Which Well-Architected pillar is this concern related to, and what should the architect recommend?

A) Performance Efficiency — use a larger database instance
B) Reliability — implement Multi-AZ deployment and Read Replicas
C) Security — encrypt the database
D) Operational Excellence — implement monitoring

**Answer: B**
**Explanation:** The Reliability pillar focuses on the ability of a system to recover from failures and meet demand. A single point of failure in the database tier is a reliability concern. Multi-AZ provides automatic failover, and Read Replicas provide additional redundancy. Performance (A) is about efficient resource use. Security (C) is about protecting data. Operational Excellence (D) is about managing operations.

---

### Question 20
A company is migrating 100 TB of NFS data from on-premises to Amazon EFS. The migration must complete within 2 weeks with data integrity verification. They have a 1 Gbps Direct Connect link. What should the architect use?

A) rsync over the Direct Connect link
B) AWS DataSync with the DataSync agent on-premises, transferring over the Direct Connect link
C) AWS Snowball Edge
D) S3 Transfer Acceleration

**Answer: B**
**Explanation:** AWS DataSync transfers data at high speed (up to 10 Gbps with appropriate network bandwidth) with built-in data integrity verification. At 1 Gbps, 100 TB takes about 9.3 days, fitting within the 2-week window. DataSync supports EFS as a destination. rsync (A) lacks AWS-native integrity verification. Snowball (C) targets S3, not EFS directly. S3 Transfer Acceleration (D) is for S3.

---

### Question 21
A company has a DR strategy where they replicate the database to the DR region and keep minimal compute resources (AMIs and launch templates) ready to be launched. What DR strategy is this?

A) Backup and restore
B) Pilot light
C) Warm standby
D) Multi-site active-active

**Answer: B**
**Explanation:** Pilot light keeps the core infrastructure components running (database replication) in the DR region with everything else prepared to be launched quickly (AMIs, templates). When a disaster occurs, you provision the remaining resources. Backup and restore (A) has no running resources in DR. Warm standby (C) has a fully functional scaled-down environment. Multi-site (D) runs full production in both regions.

---

### Question 22
A company is migrating a SQL Server database to Aurora PostgreSQL. During the AWS SCT assessment, 30% of the stored procedures cannot be automatically converted. What should the architect recommend?

A) Abandon the migration to Aurora and stay on SQL Server
B) Manually convert the remaining 30% of stored procedures to PostgreSQL and continue the migration
C) Use DMS to migrate the data and ignore the stored procedures
D) Run SQL Server and Aurora in parallel permanently

**Answer: B**
**Explanation:** SCT provides an assessment showing what percentage of code can be automatically converted and what requires manual intervention. The 30% that can't be auto-converted must be manually rewritten in PostgreSQL. This is expected in heterogeneous migrations. Abandoning (A) misses the cost and performance benefits. Ignoring procedures (C) breaks application functionality. Permanent parallel running (D) is costly.

---

### Question 23
A company uses AWS Snow Family for an offline data migration. They have 500 TB to transfer and need the fastest option. Which device should they choose?

A) AWS Snowcone (8 TB)
B) AWS Snowball Edge Storage Optimized (80 TB each, order 7 devices)
C) AWS Snowmobile (up to 100 PB)
D) Use multiple Snowcones

**Answer: B**
**Explanation:** For 500 TB, ordering multiple Snowball Edge Storage Optimized devices (each holding 80 TB, so 7 devices) provides a good balance of capacity and logistics. Snowmobile (C) is designed for 10 PB+ and involves a literal 45-foot shipping container — overkill for 500 TB. Snowcone (A, D) devices are too small (8 TB each, requiring 63+ devices), making logistics impractical.

---

### Question 24
A company runs a critical application with an RTO of 1 hour and RPO of 15 minutes. They need the DR solution to be cost-effective. Currently, the production environment has 10 EC2 instances, an ALB, and an Aurora MySQL database. What DR architecture should the architect implement?

A) Full multi-site deployment with identical infrastructure
B) Warm standby with a smaller Auto Scaling group (2 instances), ALB, and Aurora cross-region replica
C) Pilot light with Aurora cross-region replica only and pre-configured AMIs
D) Backup and restore with daily S3 backups

**Answer: B**
**Explanation:** Warm standby meets the 1-hour RTO by having a fully functional but scaled-down environment (2 instances vs. 10). Aurora cross-region replica provides near-zero RPO. During failover, scale the ASG to 10 instances and promote the Aurora replica. Pilot light (C) may not meet the 1-hour RTO for full provisioning. Multi-site (A) is expensive. Backup/restore (D) likely exceeds the 1-hour RTO.

---

### Question 25
A company is evaluating their on-premises applications for migration using the 7 Rs framework. They have an application that is tightly integrated with on-premises hardware (HSMs, specialized network appliances) and cannot currently be moved to the cloud. Which strategy applies?

A) Retire
B) Retain (Revisit)
C) Rehost
D) Relocate

**Answer: B**
**Explanation:** Retain (also called "Revisit") means keeping the application on-premises for now because it's not ready for migration due to dependencies, compliance, or technical constraints. It should be revisited in the future. Retire (A) means decommissioning. Rehost (C) and Relocate (D) involve moving to AWS, which isn't possible due to hardware dependencies.

---

### Question 26
A company uses AWS Elastic Disaster Recovery (DRS) for their DR strategy. How does DRS work to provide low RPO?

A) It takes hourly snapshots of the source servers
B) It continuously replicates data from source servers to a staging area in the DR region, and launches recovery instances on demand
C) It runs full copies of all servers in the DR region at all times
D) It backs up data to S3 and restores when needed

**Answer: B**
**Explanation:** AWS Elastic Disaster Recovery (formerly CloudEndure) continuously replicates source servers to lightweight staging area instances in the DR region. When a disaster occurs, recovery instances are launched within minutes using the replicated data. This provides sub-second RPO and minutes of RTO. It doesn't run full copies at all times (C), which would be costly. It's not snapshot-based (A) or backup-based (D).

---

### Question 27
A company is designing their architecture following the Well-Architected Framework. They want to ensure their application can automatically recover from component failures. Which design principle from the Reliability pillar should they implement?

A) Design for single-instance deployment with manual failover
B) Design for automatic recovery through health checks, auto-scaling, and multi-AZ deployment
C) Design for maximum performance on a single large instance
D) Design for minimum cost regardless of availability

**Answer: B**
**Explanation:** The Reliability pillar emphasizes automatic failure recovery through mechanisms like health checks (Route 53, ALB), auto-scaling (replace failed instances), and multi-AZ deployment (survive AZ failures). Single-instance (A) creates a single point of failure. Maximum performance (C) is the Performance Efficiency pillar. Minimum cost (D) is the Cost Optimization pillar.

---

### Question 28
A company has completed their migration to AWS and wants to optimize costs. They notice several EBS volumes are attached to stopped instances and have been idle for months. They also have unused Elastic IPs. What actions should the architect take?

A) Ignore them as they have minimal cost
B) Delete unused EBS volumes, release unused Elastic IPs, and use AWS Cost Explorer and Trusted Advisor to identify further optimization opportunities
C) Convert all instances to Reserved Instances
D) Move all data to S3 Glacier

**Answer: B**
**Explanation:** Post-migration optimization is critical. Unused EBS volumes incur storage charges, and unused Elastic IPs incur hourly charges. AWS Cost Explorer provides spending visibility, and Trusted Advisor identifies idle resources. Ignoring them (A) wastes money. Reserved Instances (C) don't address unused resources. Moving to Glacier (D) isn't relevant for EBS/EIP optimization.

---

### Question 29
A company wants to migrate their on-premises Hadoop cluster to AWS. They want a managed service that supports the same Hadoop ecosystem tools (Hive, Spark, HBase). What should the architect recommend?

A) Amazon Redshift
B) Amazon EMR (Elastic MapReduce)
C) AWS Glue
D) Amazon Kinesis

**Answer: B**
**Explanation:** Amazon EMR is a managed Hadoop framework that supports the full Hadoop ecosystem including HDFS, Hive, Spark, HBase, Presto, and more. It provides the most direct migration path for existing Hadoop workloads. Redshift (A) is a data warehouse. Glue (C) is serverless ETL. Kinesis (D) is for real-time streaming.

---

### Question 30
A company wants to ensure their AWS architecture follows the six pillars of the Well-Architected Framework. They want an automated way to review their workloads against best practices. What should the architect use?

A) AWS Trusted Advisor
B) AWS Well-Architected Tool
C) AWS Config conformance packs
D) AWS Security Hub

**Answer: B**
**Explanation:** The AWS Well-Architected Tool provides a structured way to review workloads against the six pillars (Operational Excellence, Security, Reliability, Performance Efficiency, Cost Optimization, and Sustainability). It generates improvement plans based on the review. Trusted Advisor (A) provides general recommendations. Config conformance packs (C) check resource compliance. Security Hub (D) focuses on security only.

---

*End of Migration & DR Question Bank*
