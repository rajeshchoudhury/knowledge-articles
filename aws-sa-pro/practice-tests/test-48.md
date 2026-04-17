# AWS Certified Solutions Architect - Professional (SAP-C02) Practice Test 48

## Enterprise Migration: Large-Scale Migration Programs, Mainframe Modernization, SAP on AWS, Windows Workloads, Licensing

**Test Focus:** Enterprise-scale migration strategies including large migration programs, mainframe modernization patterns, SAP workload migration, Windows workload optimization, and complex licensing scenarios on AWS.

**Exam Distribution:**
- Domain 1: Design Solutions for Organizational Complexity (~20 questions)
- Domain 2: Design for New Solutions (~22 questions)
- Domain 3: Continuous Improvement for Existing Solutions (~11 questions)
- Domain 4: Accelerate Workload Migration and Modernization (~9 questions)
- Domain 5: Cost-Optimized Architectures (~13 questions)

---

### Question 1
A large enterprise is planning to migrate 5,000 servers from 3 on-premises data centers to AWS over an 18-month period. The current environment includes a mix of Linux and Windows servers running various applications with complex interdependencies. The CTO wants to ensure the migration doesn't impact business operations. The company has limited AWS experience. What should be the FIRST step in the migration planning process?

A) Begin migrating the least critical applications to AWS to gain experience
B) Conduct a comprehensive discovery and assessment phase using AWS Application Discovery Service (both agentless and agent-based) to collect server configurations, performance data, and network dependencies, then use AWS Migration Hub to analyze the data and create application groupings based on dependencies
C) Engage AWS Professional Services to build a complete migration factory and begin migrating immediately
D) Set up AWS Landing Zone and start provisioning infrastructure for the target environment

**Correct Answer: B**
**Explanation:** For a 5,000-server migration, the first step must be comprehensive discovery and assessment. Option B is correct because: (1) Application Discovery Service agentless connector discovers VMware VMs and collects configuration data without installing agents; (2) Agent-based discovery collects detailed performance data, running processes, and network connections needed for dependency mapping; (3) Migration Hub aggregates discovery data and helps identify application groups based on network dependencies; (4) This data drives decisions about migration strategies (rehost, replatform, refactor) for each application group. Option A risks migrating without understanding dependencies. Option C skips the critical assessment phase. Option D is premature — the target architecture should be designed based on assessment findings.

---

### Question 2
A financial institution has a mainframe running IBM z/OS with 15,000 MIPS capacity. The mainframe runs COBOL batch processing jobs, CICS online transaction processing, and DB2 databases. The company wants to migrate off the mainframe within 3 years to reduce costs. The COBOL codebase contains 20 million lines of code. Which migration approach minimizes risk while achieving the 3-year timeline?

A) Rewrite all COBOL applications in Java using AWS Lambda and DynamoDB in a big-bang approach
B) Use AWS Mainframe Modernization service with the automated refactoring pattern (Blu Age) to convert COBOL to Java, deploy on ECS/EKS, migrate DB2 to Aurora PostgreSQL using AWS SCT, and implement the migration in waves starting with batch processing, then CICS transactions, then the database
C) Emulate the mainframe on EC2 using Micro Focus Enterprise Server, maintaining the existing COBOL code and JCL, while gradually refactoring individual applications to cloud-native services
D) Use AWS Mainframe Modernization with the replatform pattern (Micro Focus) to run existing COBOL code on AWS managed runtime, migrate DB2 to RDS, then incrementally refactor to cloud-native over time

**Correct Answer: D**
**Explanation:** For a 20M-line COBOL codebase with a 3-year timeline, Option D provides the optimal risk-minimized approach: (1) AWS Mainframe Modernization's replatform pattern preserves existing COBOL code, CICS transactions, and JCL, running them on the Micro Focus managed runtime on AWS; (2) This eliminates mainframe hardware costs immediately without code rewriting risk; (3) DB2 migration to RDS (PostgreSQL or SQL Server) using SCT/DMS provides a managed database; (4) Incremental refactoring after replatforming allows modernization at a sustainable pace. Option A's big-bang rewrite of 20M lines is extremely high-risk. Option B's automated refactoring (Blu Age) is faster but carries higher risk for 20M lines — automated conversion may introduce bugs in critical financial logic. Option C uses self-managed Micro Focus on EC2, adding operational overhead compared to the managed service.

---

### Question 3
An enterprise is running SAP S/4HANA on-premises with an HANA database of 8TB. They want to migrate to AWS to improve performance and reduce infrastructure costs. The current system supports 10,000 concurrent users during peak hours. Downtime must be limited to a maximum of 8 hours for the cutover window. Which migration approach meets the downtime requirement for SAP on AWS?

A) Perform a new SAP installation on AWS and manually migrate data using SAP export/import
B) Use SAP HANA System Replication (HSR) to replicate data from on-premises to AWS in real-time, then perform a planned takeover during the maintenance window, with the target being EC2 High Memory instances (e.g., u-24tb1.metal) certified for SAP HANA
C) Use AWS Server Migration Service (SMS) to replicate the SAP VMs to EC2
D) Use AWS Backint Agent for SAP HANA to backup the database to S3, restore on EC2 instances during the cutover window

**Correct Answer: B**
**Explanation:** For SAP S/4HANA migration with minimal downtime, Option B is correct: (1) SAP HANA System Replication provides real-time data replication from on-premises to AWS, keeping the target synchronized; (2) During the 8-hour maintenance window, the planned takeover is quick (minutes), as data is already synchronized; (3) EC2 High Memory instances (u-24tb1.metal with 24TB RAM) are SAP-certified for HANA and can handle 8TB database with room for growth; (4) This is SAP's recommended migration approach for minimizing downtime. Option A's export/import for 8TB would take far longer than 8 hours. Option C's SMS doesn't understand SAP application consistency requirements. Option D's backup/restore of 8TB from S3 would consume most of the 8-hour window and risk exceeding it.

---

### Question 4
A company is migrating 200 Windows Server workloads to AWS. The workloads include: 50 servers with Windows Server 2012 R2 (approaching end of life), 100 servers with Windows Server 2016, and 50 servers with Windows Server 2019. All servers use Microsoft SQL Server Standard Edition. The company currently uses Microsoft Volume Licensing with Software Assurance. Which migration strategy optimizes licensing costs?

A) Migrate all servers to EC2 with included Windows Server and SQL Server licenses (License Included pricing)
B) Deploy on EC2 Dedicated Hosts with Bring Your Own License (BYOL) for Windows Server and SQL Server using existing Software Assurance, upgrade the Windows Server 2012 R2 instances to 2019 using Software Assurance upgrade rights before migration, and right-size instances based on actual utilization data
C) Migrate to Amazon RDS for SQL Server to eliminate SQL Server licensing management, with EC2 License Included for Windows Server
D) Convert all workloads to Linux-based alternatives to eliminate Windows licensing costs entirely

**Correct Answer: B**
**Explanation:** Option B optimizes licensing costs for this enterprise scenario: (1) EC2 Dedicated Hosts enable BYOL for both Windows Server and SQL Server, which is significantly cheaper than License Included pricing at this scale (200 servers); (2) Software Assurance provides upgrade rights, allowing free upgrade from Windows Server 2012 R2 to 2019; (3) BYOL with Software Assurance on Dedicated Hosts maintains compliance with Microsoft licensing terms; (4) Right-sizing based on utilization data prevents over-provisioning; (5) Dedicated Hosts also provide visibility into physical core counts for license compliance. Option A's License Included pricing is significantly more expensive at scale. Option C's RDS for SQL Server still includes license costs and adds limitations. Option D is unrealistic for 200 Windows workloads in the migration timeframe.

---

### Question 5
A manufacturing company is migrating their production MES (Manufacturing Execution System) to AWS. The MES has strict latency requirements (< 10ms) to factory floor equipment communicating via OPC-UA protocol. The factory is located 100 miles from the nearest AWS region. The MES application runs on Windows Server with a SQL Server database. Which architecture meets the latency requirement?

A) Migrate the MES to EC2 instances in the nearest AWS region with Direct Connect for connectivity to the factory
B) Deploy AWS Outposts rack at the factory for the MES application, with connectivity to the AWS region for data lake analytics and backup, using AWS Systems Manager for management
C) Use AWS Local Zones near the factory for the MES deployment
D) Keep the MES on-premises and only migrate the analytics and reporting components to AWS

**Correct Answer: B**
**Explanation:** The 10ms latency requirement to factory floor equipment makes Option B the correct choice: (1) AWS Outposts deployed at the factory provides sub-millisecond latency to factory floor OPC-UA devices; (2) Outposts runs native AWS services (EC2, EBS, RDS) locally, supporting the Windows Server + SQL Server stack; (3) Connectivity to the AWS region enables centralized analytics, data lake, and backup; (4) Systems Manager provides unified management from the AWS console. Option A's Direct Connect from 100 miles away adds 2-5ms round-trip latency just for the physical distance, plus processing overhead, likely exceeding 10ms. Option C's Local Zones are AWS-operated and may not be close enough to the factory. Option D misses the opportunity to leverage cloud management for the MES.

---

### Question 6
A company is planning to migrate 10 petabytes of data from their on-premises data center to S3 as part of a data center closure. The migration must be completed within 6 months. Their current internet connection is 10 Gbps. Transfer over the internet alone would take approximately 93 days at full utilization. They also have 500TB of data that changes weekly and must be continuously synchronized. Which data migration strategy is MOST efficient?

A) Use AWS DataSync over the 10 Gbps internet connection, running continuously for 6 months
B) Order multiple AWS Snow Family devices (Snowball Edge Storage Optimized — 80TB each), ship in batches to transfer the bulk data (approximately 125 devices), while simultaneously setting up AWS DataSync over Direct Connect for the 500TB of frequently changing data, coordinating through AWS Migration Hub
C) Set up 10 Gbps AWS Direct Connect and transfer all data using DataSync
D) Use S3 Transfer Acceleration for all data transfer over the internet

**Correct Answer: B**
**Explanation:** For 10PB migration in 6 months, Option B uses a hybrid approach: (1) Snowball Edge devices for bulk transfer — 125 devices at 80TB each handles the 10PB, and multiple concurrent shipments can complete within the timeline; (2) DataSync over Direct Connect handles the 500TB of changing data that needs continuous synchronization; (3) This approach doesn't compete with production network traffic; (4) Migration Hub coordinates and tracks progress. Option A using internet alone would take 93 days at full utilization (impacting production traffic) and doesn't account for the changing data sync. Option C's Direct Connect alone at 10 Gbps would take 93 days plus provisioning time. Option D's S3 Transfer Acceleration doesn't significantly help at 10PB scale and still uses internet bandwidth.

---

### Question 7
A large enterprise is implementing a migration factory approach to migrate 3,000 servers over 12 months. They need to establish repeatable, automated migration processes with quality gates at each phase. The migration factory must support: automated server discovery, wave planning, automated migration execution, post-migration validation, and progress tracking. Which combination of AWS services forms the core of the migration factory?

A) AWS Migration Hub for tracking, CloudEndure Migration for server replication, AWS Service Catalog for standardized infrastructure provisioning, and AWS Config for post-migration validation
B) AWS Migration Hub for centralized tracking and orchestration, AWS Application Discovery Service for server discovery, AWS Migration Hub Orchestrator for automated wave execution with pre-built templates, AWS Application Migration Service (MGN) for automated server replication and cutover, and AWS Config rules for post-migration compliance validation
C) Third-party migration tools (CloudEndure, RiverMeadow) for replication, Jira for tracking, custom scripts for validation
D) AWS Database Migration Service for all migrations, CloudFormation for infrastructure provisioning, CloudWatch for monitoring

**Correct Answer: B**
**Explanation:** Option B provides the complete AWS migration factory stack: (1) Migration Hub centralizes tracking across all 3,000 servers and provides a single dashboard for progress; (2) Application Discovery Service automates server discovery with performance and dependency data; (3) Migration Hub Orchestrator provides pre-built migration workflow templates with automated steps and approval gates for wave-based migration; (4) Application Migration Service (MGN) provides automated, continuous block-level replication and one-click cutover — the successor to CloudEndure; (5) Config rules validate post-migration compliance (security groups, encryption, tagging). Option A uses CloudEndure which has been superseded by MGN. Option C uses third-party tools adding cost and complexity. Option D's DMS is for databases, not full server migration.

---

### Question 8
A company is migrating a legacy Oracle E-Business Suite (EBS) environment to AWS. The Oracle EBS runs on Oracle Linux with Oracle Database 19c RAC. The database is 5TB with 300 concurrent users. The application has customizations including 500 custom forms and 200 custom reports. Which migration strategy preserves the customizations while moving to AWS?

A) Rewrite the application using modern cloud-native services, converting custom forms to React applications and reports to Amazon QuickSight
B) Lift and shift Oracle EBS to EC2 using AWS Application Migration Service, deploy Oracle Database on EC2 with dedicated hosts for license compliance, maintain the existing Oracle Linux and EBS configuration, and use EBS-optimized instances for database performance
C) Migrate to SAP S/4HANA on AWS as a replacement for Oracle EBS
D) Migrate Oracle Database to Amazon Aurora PostgreSQL and rebuild the EBS application tier on ECS

**Correct Answer: B**
**Explanation:** For Oracle EBS with extensive customizations, Option B is the lowest-risk approach: (1) Lift and shift preserves all 500 custom forms and 200 custom reports without modification; (2) Application Migration Service handles the automated replication of the Oracle Linux servers; (3) Oracle Database on EC2 with Dedicated Hosts enables BYOL, maintaining licensing compliance for Oracle Database Enterprise Edition; (4) EBS-optimized instances with Provisioned IOPS EBS volumes provide the storage performance needed for Oracle Database; (5) The existing Oracle RAC configuration can be replicated on EC2. Option A's rewrite of 700+ custom components is a multi-year project. Option C changes the entire ERP platform, not a migration. Option D breaks Oracle EBS — the application is tightly coupled to Oracle Database and cannot run on Aurora PostgreSQL.

---

### Question 9
A company is migrating their .NET Framework 4.5 web applications from on-premises Windows Server 2012 R2 to AWS. The applications use Windows-specific features including Windows Authentication (Kerberos), MSMQ for messaging, and Windows Task Scheduler for batch jobs. The company wants to modernize where possible while minimizing application code changes. Which migration and modernization strategy is MOST appropriate?

A) Rewrite all applications in .NET Core on Linux to eliminate Windows dependencies, deploy on ECS with Fargate
B) Migrate to EC2 Windows instances as-is (rehost), then incrementally modernize: replace MSMQ with Amazon SQS using the AWS Message Processing Framework for .NET, replace Windows Task Scheduler with Amazon EventBridge Scheduler triggering Lambda/.NET functions, and integrate with AWS Managed Microsoft AD for Kerberos authentication
C) Deploy on AWS Elastic Beanstalk with Windows Server platform, maintaining all Windows-specific features
D) Containerize the .NET Framework applications in Windows containers on ECS, maintaining all Windows dependencies

**Correct Answer: B**
**Explanation:** Option B provides the optimal modernization path: (1) Initial rehost to EC2 provides an immediate win (data center exit) with minimal risk; (2) Replacing MSMQ with SQS using the AWS Message Processing Framework provides a compatible messaging abstraction with minimal code changes; (3) EventBridge Scheduler + Lambda replaces Windows Task Scheduler with serverless scheduling; (4) AWS Managed Microsoft AD provides Kerberos authentication compatible with Windows Authentication; (5) Incremental modernization avoids big-bang risk. Option A's complete rewrite from .NET Framework to .NET Core requires significant code changes, especially for Windows-specific features. Option C maintains all Windows dependencies without modernization. Option D's Windows containers on ECS are viable but don't address the modernization goal and Windows containers have limitations.

---

### Question 10
A global enterprise is migrating 500 databases (mix of Oracle, SQL Server, MySQL, and PostgreSQL) to AWS as part of a data center consolidation. 300 databases can use the same engine on RDS. 100 Oracle and 50 SQL Server databases have complex schemas with stored procedures that could benefit from conversion to open-source engines. 50 databases require heterogeneous migration (different engine on AWS). What is the MOST efficient approach to migrate all 500 databases?

A) Migrate all databases to Aurora PostgreSQL using AWS DMS with continuous replication
B) Use AWS DMS for homogeneous migrations (300 databases to RDS same-engine), AWS Schema Conversion Tool (SCT) for schema assessment and conversion of the 100+50 Oracle/SQL Server databases to Aurora PostgreSQL, DMS for data migration with ongoing replication, and engage AWS Database Freedom Program for the complex heterogeneous migrations, using Migration Hub to track all 500 database migrations
C) Hire a consulting firm to manually migrate all databases over 24 months
D) Use AWS Database Migration Service for all 500 databases, regardless of engine changes

**Correct Answer: B**
**Explanation:** Option B provides a structured approach for 500 databases: (1) DMS homogeneous migration for the 300 same-engine databases is straightforward — same engine on RDS with continuous replication for minimal downtime cutover; (2) SCT assesses the 150 databases that could change engines, generating conversion assessment reports showing effort required; (3) SCT converts schemas, stored procedures, and functions from Oracle/SQL Server to PostgreSQL, identifying manual conversion items; (4) The Database Freedom Program provides AWS expert assistance for complex heterogeneous migrations; (5) Migration Hub provides centralized tracking across all 500 migrations. Option A ignores that 300 databases don't need engine changes. Option C is unnecessarily expensive and slow. Option D doesn't account for the schema conversion needed for heterogeneous migrations.

---

### Question 11
A company is migrating a mainframe CICS application to AWS. The application processes 50,000 transactions per second with sub-second response times. It uses VSAM files for data storage, CICS queues for inter-program communication, and BMS maps for the screen interface. Users access the application through 3270 terminal emulators. Which modernization approach preserves the transaction processing characteristics?

A) Rewrite the entire application as microservices on EKS with DynamoDB for data storage
B) Use AWS Mainframe Modernization with the Blu Age refactoring engine to automatically convert COBOL/CICS programs to Java microservices, VSAM files to Aurora PostgreSQL tables, CICS queues to Amazon SQS, and BMS maps to modern web interfaces, deploying on ECS with auto-scaling to maintain the 50K TPS throughput
C) Run the CICS application on Micro Focus Enterprise Server on EC2 (replatform), gradually exposing CICS transactions as REST APIs using API Gateway for new digital channels
D) Migrate to a commercial off-the-shelf (COTS) transaction processing system on AWS

**Correct Answer: C**
**Explanation:** For a mission-critical 50K TPS CICS application, Option C provides the safest modernization path: (1) Micro Focus Enterprise Server on EC2 preserves the CICS runtime behavior exactly, maintaining the 50K TPS throughput; (2) Existing COBOL programs, VSAM files, and BMS maps run without modification; (3) The CICS-to-REST API gateway approach (via Micro Focus API layer or API Gateway integration) enables new digital channels without modifying the core application; (4) This preserves sub-second response times while gradually modernizing the interface layer. Option A's complete rewrite is extremely high-risk for a 50K TPS system. Option B's automated refactoring may not preserve the exact transaction processing semantics and introduces potential bugs at scale. Option D requires business process redesign.

---

### Question 12
A company has 1,000 VMware VMs that need to be migrated to AWS. They want to maintain their existing VMware management tools and processes during the transition. Some workloads will remain on VMware while others will be migrated to native EC2. The migration will take 18 months. Which approach provides the MOST seamless VMware-to-AWS transition?

A) Use AWS Application Migration Service (MGN) to replicate all VMs to EC2 instances
B) Deploy VMware Cloud on AWS for the initial migration, running VMware workloads natively on AWS infrastructure, then selectively migrate individual VMs from VMware Cloud on AWS to native EC2 using VMware HCX or MGN over the 18-month period, maintaining VMware vCenter management throughout
C) Use AWS Server Migration Service to migrate VMs in waves
D) Re-create all VMware VMs as EC2 instances using CloudFormation templates

**Correct Answer: B**
**Explanation:** Option B provides the smoothest VMware transition: (1) VMware Cloud on AWS runs the full VMware stack (vSphere, vSAN, NSX) on dedicated AWS infrastructure, enabling immediate VM migration using familiar VMware tools (vMotion, HCX); (2) VMware management tools (vCenter, vRealize) continue working unchanged; (3) VMs run natively on VMware infrastructure initially, then can be selectively migrated to EC2 when ready; (4) This hybrid approach supports the 18-month timeline with workloads gradually moving to native EC2; (5) VMware Cloud on AWS provides direct connectivity to native AWS services. Option A forces all workloads to EC2 immediately, disrupting VMware management processes. Option C's SMS is being deprecated in favor of MGN. Option D requires manual recreation without automated migration tools.

---

### Question 13
An insurance company needs to modernize their batch processing system that currently runs on an IBM mainframe. The batch processing runs nightly, processing 500 million records across 2,000 batch jobs with complex dependencies (JCL-defined). Total processing time is 6 hours. The batch window cannot be extended. Which modernization approach maintains the batch processing window?

A) Convert all batch jobs to AWS Lambda functions orchestrated by Step Functions
B) Use AWS Mainframe Modernization (Micro Focus) to run existing JCL and COBOL batch programs on EC2, replacing mainframe I/O operations with S3 and RDS, using AWS Batch for job scheduling and dependency management to replace the mainframe job scheduler (JES2/JES3)
C) Rewrite batch jobs as Apache Spark jobs on Amazon EMR
D) Convert batch processing to real-time streaming using Kinesis Data Streams

**Correct Answer: B**
**Explanation:** Option B preserves batch processing while modernizing the infrastructure: (1) Micro Focus runtime executes existing COBOL batch programs without code changes; (2) S3 replaces mainframe datasets (VSAM, sequential files) for batch I/O; (3) RDS replaces DB2 for database operations; (4) AWS Batch replaces the mainframe job scheduler, maintaining the 2,000 job dependency graph with DAG-based scheduling; (5) EC2 instances can be sized to match or exceed mainframe processing power, maintaining the 6-hour window; (6) AWS Batch auto-scales compute resources during the batch window and releases them afterward. Option A's Lambda has execution limits that may not suit long-running batch jobs. Option C requires rewriting 2,000 jobs in Spark. Option D fundamentally changes the processing model, requiring application redesign.

---

### Question 14
A government agency is migrating their IT infrastructure to AWS GovCloud. They have 2,000 servers with a mix of classified (IL4/IL5) and unclassified workloads. The migration must maintain FedRAMP High compliance throughout. Data cannot transit over the public internet during migration. Which migration approach meets the security requirements?

A) Use AWS Application Migration Service with data replication over Direct Connect to GovCloud, establish a dedicated Direct Connect connection from the government data center to a GovCloud region, implement encryption in transit using TLS for all replication traffic, and use AWS Migration Hub in GovCloud for tracking
B) Use AWS Snowball Edge devices to physically transport data to the GovCloud region, then use MGN for incremental replication
C) Establish a VPN connection to GovCloud and use MGN for migration
D) Use AWS DataSync over the internet with encryption for data transfer to GovCloud

**Correct Answer: A**
**Explanation:** For FedRAMP High compliance with no public internet transit, Option A is correct: (1) Direct Connect provides dedicated, private network connectivity from the government data center to GovCloud, ensuring data never traverses the public internet; (2) MGN (Application Migration Service) handles continuous block-level replication over the Direct Connect path; (3) TLS encryption on top of Direct Connect provides defense in depth; (4) Migration Hub in GovCloud provides a FedRAMP-compliant tracking interface; (5) GovCloud maintains FedRAMP High authorization throughout. Option B's Snowball can work for initial data but creates a logistics challenge for 2,000 servers and doesn't support continuous replication. Option C's VPN uses the public internet which violates the requirement. Option D explicitly uses the internet.

---

### Question 15
A company is migrating their SAP Business Warehouse (BW) on Oracle to SAP BW/4HANA on AWS. The current BW has 12TB of data. They want to use this migration as an opportunity to implement SAP BW on HANA for the first time. The migration must include data archiving to reduce the HANA database size, as HANA is licensed per GB of memory. Which approach optimizes the SAP BW migration to HANA on AWS?

A) Lift and shift the existing Oracle-based BW to AWS, then perform the BW to BW/4HANA conversion
B) Perform SAP Data Management Optimization (DMO) with System Move using SAP SUM tool, which combines the database migration (Oracle to HANA), Unicode conversion if needed, and BW/4HANA conversion in a single downtime window, archive historical data using SAP ILM before migration to reduce HANA memory requirements, deploy on EC2 x2idn instances (memory-optimized) sized for the post-archival database size
C) Create a new BW/4HANA installation on AWS and manually recreate all BW objects
D) Use AWS DMS to migrate Oracle data to HANA on EC2

**Correct Answer: B**
**Explanation:** Option B is the SAP-recommended approach for this scenario: (1) DMO with System Move combines database migration, system conversion, and infrastructure migration in a single procedure, minimizing downtime windows; (2) SAP SUM (Software Update Manager) automates the technical conversion process; (3) Data archiving with SAP ILM before migration is critical — reducing 12TB by archiving historical data (potentially to 4-6TB) directly reduces HANA license costs since HANA is licensed per GB; (4) EC2 x2idn instances are memory-optimized and SAP-certified for HANA; (5) Sizing based on post-archival database size minimizes EC2 instance costs. Option A requires two separate downtimes (migration then conversion). Option C loses all BW configuration and history. Option D doesn't handle the BW/4HANA conversion.

---

### Question 16
A company is running Microsoft SharePoint Server 2019 on-premises with 5,000 users. The SharePoint farm includes 10 web front-end servers, 4 application servers, and a SQL Server 2019 Always On availability group. They want to migrate to AWS while maintaining the SharePoint Server deployment (not moving to SharePoint Online). Which architecture provides high availability for SharePoint on AWS?

A) Single EC2 instance running all SharePoint roles with RDS SQL Server for the database
B) SharePoint web front-ends on EC2 instances across 2 AZs behind an Application Load Balancer, application servers on EC2 in 2 AZs, SQL Server on EC2 with Always On Availability Groups across 2 AZs using Windows Server Failover Clustering (WSFC), AWS Managed Microsoft AD for Active Directory, and S3 for BLOB storage using Remote BLOB Storage (RBS)
C) SharePoint on Amazon WorkSpaces for all users
D) SharePoint on a single AZ with regular EBS snapshots for disaster recovery

**Correct Answer: B**
**Explanation:** Option B provides enterprise-grade HA for SharePoint on AWS: (1) Web front-ends across 2 AZs behind ALB provide load distribution and fault tolerance for the web tier; (2) Application servers in 2 AZs provide redundancy for SharePoint services; (3) SQL Server Always On AG across AZs with WSFC provides database HA — this is Microsoft's recommended HA approach for SQL Server; (4) AWS Managed Microsoft AD provides the Active Directory services SharePoint requires; (5) S3 with RBS offloads large BLOBs from SQL Server to S3, reducing database size and leveraging S3's durability. Option A has no redundancy. Option C's WorkSpaces doesn't run SharePoint. Option D's single AZ has no fault tolerance.

---

### Question 17
An enterprise with 50,000 Windows desktops wants to migrate to a virtual desktop solution on AWS. The current environment includes: Windows 10 Enterprise desktops, Microsoft Office 365 Pro Plus, line-of-business applications, and USB peripheral support for specialized hardware (scanners, printers). Users are distributed across 20 offices globally. Which solution provides the MOST cost-effective virtual desktop experience?

A) Amazon WorkSpaces with Windows 10 BYOL bundles across regions near each office, WorkSpaces Web Access for remote users, Amazon WorkDocs for file sharing
B) Amazon AppStream 2.0 for application streaming, with local thin clients at each office
C) Amazon WorkSpaces Core with Windows 10 BYOL in regions near major office clusters, WorkSpaces Thin Client devices for standardized endpoint experience, Amazon FSx for Windows File Server for shared storage, USB peripheral redirection enabled, and Reserved WorkSpaces pricing for the base 50,000 desktops
D) Citrix Virtual Apps on EC2 instances across regions, with Citrix ADC for load balancing

**Correct Answer: C**
**Explanation:** For 50,000 desktops globally, Option C is most cost-effective: (1) WorkSpaces Core provides persistent virtual desktops at a lower price point than standard WorkSpaces; (2) BYOL for Windows 10 Enterprise uses existing Microsoft licensing, avoiding additional costs; (3) WorkSpaces Thin Client devices provide a simple, consistent endpoint with built-in peripheral support; (4) FSx for Windows File Server provides fully managed shared storage compatible with Windows; (5) USB peripheral redirection supports scanners and printers; (6) Reserved pricing for 50,000 desktops provides significant cost savings (up to 50% vs. monthly pricing); (7) Regional deployment near office clusters minimizes latency. Option A is similar but standard WorkSpaces is more expensive than Core. Option B's AppStream is for application streaming, not full desktops. Option D adds Citrix licensing costs.

---

### Question 18
A company is migrating a legacy mainframe application that uses IMS (Information Management System) hierarchical database. The database contains 2TB of data organized in 50 hierarchical segments with parent-child relationships. The application performs both online (OLTP) queries traversing the hierarchy and batch processing that scans large portions of the database. Which AWS database service BEST maps to the IMS hierarchical data model while supporting both OLTP and batch access patterns?

A) Amazon DynamoDB with composite keys modeling the hierarchy (PK=root segment, SK=path#child)
B) Amazon Neptune for graph-based hierarchical data modeling, with Gremlin queries for hierarchy traversal and SPARQL for batch analytical queries
C) Amazon Aurora PostgreSQL with recursive CTEs for hierarchical queries and JSONB columns for variable segment structures
D) Amazon DocumentDB for hierarchical document storage, with nested documents representing the hierarchy

**Correct Answer: A**
**Explanation:** Option A best maps the IMS hierarchical model to AWS: (1) DynamoDB's composite key design (PK=root_key, SK=segment_path#child_key) naturally models IMS's hierarchical segment structure; (2) Parent-child traversal uses Query operations with SK begins_with(path) to efficiently retrieve subtrees; (3) OLTP access patterns (single record lookup, parent-child navigation) map directly to DynamoDB's Get/Query operations; (4) Batch processing uses DynamoDB's Scan with parallel scan for large-scale data processing; (5) DynamoDB handles both OLTP (single-digit millisecond) and batch (high throughput) workloads. Option B's Neptune adds complexity for what is essentially a key-based hierarchical lookup. Option C's recursive CTEs work but relational databases aren't optimal for hierarchical data. Option D's DocumentDB limits document size to 16MB, potentially problematic for deep hierarchies with large segments.

---

### Question 19
A company is migrating their Oracle Database Enterprise Edition (10TB) to AWS. The database uses Oracle-specific features including: Partitioning, Advanced Compression, Real Application Clusters (RAC), Data Guard, and Oracle Text (full-text search). The company wants to reduce licensing costs by migrating to an open-source database. Which migration approach addresses the Oracle-specific feature dependencies?

A) Migrate directly to Aurora PostgreSQL using DMS, accepting the loss of Oracle-specific features
B) Use AWS SCT to assess the migration complexity, identify Oracle-specific feature mappings: Partitioning → PostgreSQL native partitioning, Advanced Compression → Aurora storage compression, RAC → Aurora Multi-AZ with read replicas, Data Guard → Aurora Global Database, Oracle Text → Amazon OpenSearch Service for full-text search, then perform a phased migration using DMS with ongoing replication
C) Migrate to Amazon RDS for Oracle to maintain all features, reducing only hardware costs
D) Migrate to Amazon Redshift for analytics workloads and Aurora PostgreSQL for OLTP

**Correct Answer: B**
**Explanation:** Option B provides a comprehensive Oracle-to-open-source migration: (1) SCT assessment identifies all Oracle-specific dependencies and conversion effort; (2) PostgreSQL native partitioning (range, list, hash) replaces Oracle Partitioning; (3) Aurora's storage layer provides automatic compression; (4) Aurora Multi-AZ + read replicas replace RAC's HA/scalability (note: Aurora doesn't support multi-master writes like RAC, but read scaling is comparable); (5) Aurora Global Database replaces Data Guard for DR; (6) OpenSearch Service replaces Oracle Text for full-text search, requiring application-level changes for search queries; (7) DMS with ongoing replication enables minimal-downtime cutover. Option A ignores the feature mapping analysis. Option C doesn't reduce licensing costs (Oracle EE licenses still required). Option D splits the database unnecessarily.

---

### Question 20
A large enterprise is implementing a migration landing zone for their 5,000-server migration. The landing zone must support: multi-account structure, centralized networking, security baselines, identity federation with their existing Active Directory, and automated account provisioning for application teams. Which approach establishes the landing zone MOST efficiently?

A) Manually create AWS accounts and configure networking, security, and IAM in each account
B) AWS Control Tower for automated landing zone setup with guardrails, Account Factory for automated account provisioning, AWS Organizations with SCPs for policy enforcement, Transit Gateway for centralized networking, IAM Identity Center with AD Connector for identity federation, and AWS Config for continuous compliance monitoring
C) AWS CloudFormation templates for all landing zone components, deployed manually
D) Third-party landing zone tool (Terraform Enterprise) for all infrastructure provisioning

**Correct Answer: B**
**Explanation:** Option B provides the most efficient enterprise landing zone: (1) Control Tower automates the setup of a multi-account environment with best-practice security baselines and guardrails; (2) Account Factory enables self-service account provisioning for application teams with pre-configured security and networking; (3) Organizations with SCPs enforce policies across all accounts centrally; (4) Transit Gateway provides hub-and-spoke networking across all accounts; (5) IAM Identity Center with AD Connector federates existing Active Directory identities; (6) Config provides continuous compliance monitoring against the security baseline. Option A is manual and error-prone at scale. Option C requires building and maintaining custom templates. Option D introduces third-party complexity.

---

### Question 21
A company is migrating their IBM WebSphere application servers to AWS. The applications are Java EE enterprise applications using EJBs, JMS messaging, and JDBC data sources. The company wants to reduce application server licensing costs. Which migration strategy reduces costs while minimizing application changes?

A) Migrate WebSphere applications to Amazon ECS containers running Open Liberty (the open-source version of WebSphere Liberty), which supports the same Java EE APIs, configured with Amazon MQ for JMS messaging and RDS for JDBC data sources
B) Rewrite all applications as Spring Boot microservices on Lambda
C) Deploy WebSphere on EC2 with BYOL
D) Migrate to Apache Tomcat on EC2, rewriting EJB components as plain Java classes

**Correct Answer: A**
**Explanation:** Option A minimizes both cost and application changes: (1) Open Liberty is the open-source version of WebSphere Liberty and supports the same Java EE / Jakarta EE APIs (EJBs, JMS, JDBC); (2) Existing Java EE applications can run on Open Liberty with minimal or no code changes; (3) ECS containers provide scalable deployment without application server license costs; (4) Amazon MQ (ActiveMQ or RabbitMQ) provides managed JMS messaging; (5) RDS provides managed JDBC-compatible databases. This eliminates WebSphere licensing while maintaining application compatibility. Option B's complete rewrite is a major effort. Option C still requires WebSphere licenses. Option D requires rewriting EJB components, which is significant work.

---

### Question 22
A telecommunications company needs to migrate their billing system from Oracle Exadata to AWS. The database is 30TB with extreme I/O requirements: 2 million IOPS and 50 GB/s throughput during billing runs. The billing application uses Oracle PL/SQL extensively with 5,000 stored procedures. Which AWS architecture provides comparable I/O performance?

A) Amazon RDS for Oracle on the largest available instance with Provisioned IOPS storage
B) Oracle Database on EC2 i3en.metal instances (high storage density with NVMe SSDs) with Oracle ASM for storage management, deployed in a RAC configuration across 2 AZs for high availability, with the 5,000 stored procedures maintained as-is
C) Migrate to Aurora PostgreSQL with io2 Block Express storage for high IOPS
D) Amazon Redshift for the billing data warehouse with stored procedures converted to Redshift SQL

**Correct Answer: B**
**Explanation:** For Exadata-level I/O performance, Option B is correct: (1) EC2 i3en.metal instances provide up to 8 × 7.5TB NVMe SSDs with extremely high IOPS and throughput, approaching Exadata performance; (2) Oracle ASM (Automatic Storage Management) stripes data across NVMe drives, maximizing I/O performance; (3) RAC configuration across AZs provides high availability comparable to Exadata's HA features; (4) All 5,000 PL/SQL stored procedures run without modification on Oracle on EC2; (5) The i3en instance's local NVMe storage provides the 2M+ IOPS needed. Option A's RDS for Oracle has IOPS limits that don't match Exadata requirements. Option C's Aurora PostgreSQL requires rewriting 5,000 PL/SQL procedures. Option D changes the architecture from OLTP to data warehouse.

---

### Question 23
A company has a hybrid architecture where some applications remain on-premises and some have migrated to AWS. They need bi-directional Active Directory integration between on-premises AD and AWS. On-premises applications need to authenticate against AWS-hosted AD, and AWS applications need to authenticate against on-premises AD. Users should have a single sign-on experience. Which Active Directory architecture supports this?

A) AWS Managed Microsoft AD in AWS with a two-way forest trust to the on-premises AD, AD Connector as an additional proxy for specific use cases, DNS conditional forwarding between on-premises DNS and Route 53 Resolver, and Direct Connect for reliable connectivity
B) Extend the on-premises AD to EC2 domain controllers in AWS using AD replication over VPN
C) AWS Managed Microsoft AD with a one-way trust (on-premises trusts AWS), AD Connector for the reverse direction
D) Replace on-premises AD with AWS Managed Microsoft AD and use VPN for on-premises application authentication

**Correct Answer: A**
**Explanation:** Option A provides the correct bi-directional AD architecture: (1) AWS Managed Microsoft AD provides a fully managed AD in AWS; (2) Two-way forest trust enables both directions — on-premises apps authenticate against AWS AD, and AWS apps authenticate against on-premises AD; (3) AD Connector can be used alongside Managed AD for specific scenarios like proxying authentication to on-premises; (4) DNS conditional forwarding ensures name resolution works in both directions; (5) Direct Connect provides reliable, low-latency connectivity for AD replication and authentication traffic. Option B works but requires managing EC2-based domain controllers. Option C's one-way trust only supports one direction at a time. Option D disrupts on-premises operations.

---

### Question 24
A company is migrating their SAS (Statistical Analysis System) analytics workloads from on-premises to AWS. The SAS environment includes SAS Base, SAS Enterprise Guide, SAS Visual Analytics, and SAS Grid Manager for distributed processing. Current infrastructure is 20 grid nodes with 50TB of analytics data. Which AWS architecture supports SAS workloads?

A) Rewrite SAS programs in Python using Amazon SageMaker
B) Deploy SAS on EC2 instances using SAS-certified AMIs, with SAS Grid Manager on EC2 for distributed processing, Amazon FSx for Lustre for high-performance shared storage (replacing the on-premises shared filesystem), S3 as the data lake with FSx for Lustre lazy loading from S3, and auto-scaling grid nodes using EC2 Auto Scaling for cost optimization during non-peak hours
C) Use Amazon EMR with Spark to replace SAS processing
D) Deploy SAS on a single large EC2 instance with EBS storage

**Correct Answer: B**
**Explanation:** Option B provides the correct SAS on AWS architecture: (1) SAS certifies specific EC2 instance types and AMIs for their products; (2) SAS Grid Manager on EC2 distributes workloads across grid nodes, maintaining the same parallel processing model; (3) FSx for Lustre provides the high-performance POSIX-compliant shared filesystem SAS requires (SAS programs use direct file I/O); (4) FSx for Lustre's lazy loading from S3 enables access to the 50TB data lake without pre-staging all data; (5) Auto-scaling grid nodes reduces costs during off-peak hours (SAS workloads are often cyclical). Option A requires rewriting analytics, which is impractical for complex SAS programs. Option C replaces SAS entirely, requiring skill retraining. Option D has no distributed processing capability.

---

### Question 25
A company migrating to AWS has 200 Microsoft SQL Server databases across various editions (Express, Standard, Enterprise). They want to consolidate and optimize licensing costs. The databases range from 10MB to 5TB, with varying workload patterns. Which approach provides the MOST cost-effective SQL Server deployment on AWS?

A) Migrate all databases to Amazon RDS for SQL Server Enterprise Edition for maximum compatibility
B) Assess each database's feature requirements: migrate databases using only basic features to RDS SQL Server Express or Web Edition (much lower licensing cost), migrate databases needing Standard features to RDS SQL Server Standard Edition, migrate databases with Enterprise features to EC2 with BYOL on Dedicated Hosts using existing Enterprise licenses, and consolidate small databases onto shared RDS instances using multiple databases per instance
C) Migrate all databases to Aurora PostgreSQL to eliminate SQL Server licensing entirely
D) Use Amazon RDS for SQL Server Standard Edition for all databases

**Correct Answer: B**
**Explanation:** Option B optimizes costs through right-licensing: (1) Assessing feature requirements prevents over-licensing — many databases use only basic features and can run on Express (free) or Web Edition (significantly cheaper); (2) Standard Edition handles most enterprise needs at lower cost than Enterprise; (3) BYOL on Dedicated Hosts for Enterprise databases uses existing licenses; (4) Consolidating small databases onto shared RDS instances reduces per-instance costs. This tiered approach can reduce SQL Server licensing costs by 60-80%. Option A over-provisions every database with Enterprise Edition. Option C requires rewriting application queries and stored procedures. Option D over-provisions databases that only need Express features.

---

### Question 26
A company needs to migrate their IBM MQ messaging infrastructure to AWS. The current setup has 50 queue managers handling 100,000 messages per second with guaranteed delivery. Applications rely on specific IBM MQ features including: message groups, message properties, selectors, dead-letter queues, and transactional messaging. The migration must maintain message ordering and transactional guarantees. Which approach maintains IBM MQ compatibility?

A) Replace IBM MQ with Amazon SQS and SNS, rewriting application messaging code
B) Deploy Amazon MQ with the ActiveMQ engine, mapping IBM MQ concepts to JMS equivalents
C) Deploy IBM MQ on EC2 instances with high-availability configuration (RDQM - Replicated Data Queue Manager) across Availability Zones, using EBS gp3 volumes for queue storage, and gradually introduce Amazon MQ or SQS for new applications while maintaining IBM MQ for legacy compatibility
D) Use Amazon Kinesis Data Streams to replace all messaging

**Correct Answer: C**
**Explanation:** Option C provides the safest migration path for complex IBM MQ environments: (1) IBM MQ on EC2 maintains 100% compatibility with all IBM MQ-specific features (message groups, properties, selectors, DLQ, transactions); (2) RDQM provides high availability across AZs with automatic failover; (3) EBS gp3 volumes provide configurable IOPS and throughput for queue storage; (4) Maintaining IBM MQ for existing applications avoids rewriting 50 queue managers' worth of messaging logic; (5) New applications can use Amazon MQ or SQS, gradually reducing IBM MQ dependency. Option A requires rewriting all messaging code — SQS doesn't support message groups or selectors. Option B's ActiveMQ doesn't support all IBM MQ features. Option D's Kinesis is a streaming platform, not a message broker.

---

### Question 27
A company is planning a data center migration with 3,000 servers. They need to determine the optimal migration strategy (the 7 Rs) for each application. The portfolio includes: 500 simple web servers (stateless), 200 complex Java applications, 100 legacy mainframe applications, 50 commercial packaged applications, and 2,150 supporting infrastructure servers. How should they categorize applications for migration?

A) Rehost all 3,000 servers using AWS MGN
B) Categorize as follows: (1) Retire — identify unused servers from the 2,150 infrastructure group using utilization data from Application Discovery Service; (2) Retain — keep legacy mainframe applications on-premises temporarily; (3) Rehost — 500 web servers and supporting infrastructure using MGN; (4) Replatform — 200 Java applications to Elastic Beanstalk or ECS; (5) Repurchase — 50 commercial applications to SaaS equivalents; (6) Refactor — select high-value applications for cloud-native redesign; and prioritize based on business value and migration complexity
C) Refactor all applications for cloud-native architecture
D) Move everything to EC2 instances without any optimization

**Correct Answer: B**
**Explanation:** Option B applies the 7 Rs migration framework correctly: (1) Retire eliminates unnecessary servers — typically 10-20% of data center servers are unused or underutilized; (2) Retain keeps applications that can't be migrated yet (mainframe) for later phases; (3) Rehost (lift and shift) for stateless web servers and infrastructure is fast and low-risk; (4) Replatform Java applications to managed services reduces operational overhead; (5) Repurchase commercial applications as SaaS eliminates infrastructure management; (6) Refactor high-value applications maximizes cloud benefits. This structured approach optimizes the overall migration portfolio. Option A applies one strategy to all, missing optimization opportunities. Option C is too expensive and time-consuming for 3,000 servers. Option D provides no optimization.

---

### Question 28
A pharmaceutical company is migrating their drug discovery computational chemistry workloads to AWS. The workloads involve running molecular dynamics simulations that require: thousands of CPU cores running for days, GPU acceleration for specific simulation phases, a shared parallel filesystem for intermediate results, and the ability to scale from 0 to 10,000 cores within minutes. Cost efficiency is critical as these are research workloads. Which architecture supports these computational requirements?

A) Amazon EC2 hpc7a instances with EFA (Elastic Fabric Adapter) for tightly coupled simulations, P5 instances for GPU phases, Amazon FSx for Lustre for shared parallel filesystem, AWS Batch for job scheduling with Spot instances for cost optimization, and dynamic scaling based on job queue depth
B) Lambda functions for distributed computation
C) Single large EC2 instance with maximum CPU cores
D) Amazon SageMaker for running simulations as training jobs

**Correct Answer: A**
**Explanation:** Option A provides the optimal HPC architecture for drug discovery: (1) hpc7a instances are purpose-built for HPC with high core counts and EFA for low-latency inter-node communication; (2) P5 instances provide GPU acceleration for simulation phases requiring it; (3) FSx for Lustre provides the high-performance parallel filesystem needed for intermediate results (POSIX-compliant, high throughput); (4) AWS Batch manages job scheduling with complex dependencies across thousands of nodes; (5) Spot instances reduce costs by 60-90% for interruptible simulation phases; (6) Batch dynamically scales from 0 to 10,000 cores based on queue depth. Option B's Lambda can't run multi-day simulations. Option C can't scale to thousands of cores. Option D's SageMaker is for ML training, not molecular dynamics.

---

### Question 29
A company is migrating their Informatica PowerCenter ETL platform (50 ETL workflows, 500 mappings) to AWS. The ETL processes data from Oracle, SQL Server, and flat files, loading into a data warehouse. They want to reduce ETL licensing costs. Which migration approach is MOST appropriate?

A) Migrate Informatica PowerCenter to EC2 with BYOL, maintaining the existing ETL workflows
B) Convert all Informatica mappings to AWS Glue ETL jobs using the AWS Glue Studio visual editor, replacing Oracle/SQL Server sources with RDS, flat file sources with S3, and the data warehouse with Amazon Redshift, using AWS Glue Data Catalog for metadata management
C) Replace Informatica with Apache Airflow (MWAA) for orchestration and custom Python scripts for ETL logic
D) Use AWS DMS for all ETL operations, replacing Informatica entirely

**Correct Answer: B**
**Explanation:** Option B provides a complete Informatica replacement: (1) AWS Glue ETL replaces Informatica PowerCenter's core functionality — visual mapping design, ETL execution, and job scheduling; (2) Glue Studio visual editor provides a low-code interface similar to Informatica's mapping designer; (3) Glue natively connects to RDS (Oracle, SQL Server), S3 (flat files), and Redshift (data warehouse); (4) Glue Data Catalog replaces Informatica's metadata repository; (5) Glue is serverless, eliminating both licensing and infrastructure costs. Option A maintains Informatica licensing costs. Option C requires writing custom ETL code for each mapping. Option D is for database migration, not full ETL with transformations.

---

### Question 30
A company is performing a large-scale migration and discovers that 30% of their applications have unclear ownership, undocumented dependencies, and no current support contracts. These "dark" applications represent a significant risk to the migration timeline. How should the solutions architect handle these applications?

A) Migrate them as-is to EC2 using MGN and deal with issues post-migration
B) Exclude them from the migration scope entirely
C) Implement a structured triage process: use Application Discovery Service agent-based discovery to identify actual usage (CPU, memory, network connections), analyze network flow data to map dependencies, conduct stakeholder interviews to identify business owners, classify each application as: (1) actively used → assign owner and include in migration, (2) minimally used → candidate for retirement with business validation, (3) unused → retire with 30-day notification period, and document all decisions in Migration Hub
D) Delay the entire migration until all applications are documented

**Correct Answer: C**
**Explanation:** Option C provides a structured approach to the common "dark application" challenge: (1) Agent-based discovery reveals actual application usage through performance data — many "dark" apps are actually unused; (2) Network dependency mapping shows which applications communicate with which, even without documentation; (3) Stakeholder interviews identify business owners who can make disposition decisions; (4) The three-way classification (active/minimal/unused) enables informed decisions; (5) 30-day notification for retirement gives stakeholders time to claim ownership; (6) Migration Hub documents all decisions for audit purposes. Option A risks migrating unnecessary applications and unknown issues. Option B delays migration with no resolution path. Option D delays the entire program for a minority of applications.

---

### Question 31
A financial services company needs to migrate their core banking platform from IBM AIX (POWER architecture) to AWS. The platform runs on 20 AIX LPAR (Logical Partitions) with 100TB of data across Oracle and IBM DB2 databases. Applications are written in C, C++, and Java. Which migration approach handles the architecture change from POWER to x86?

A) Use AWS Application Migration Service to directly replicate AIX servers to EC2
B) For Java applications: recompile on Linux x86 and deploy on EC2 (Java bytecode is platform-independent). For C/C++ applications: recompile on Linux x86 with necessary code modifications for endianness and platform-specific APIs, deploy on EC2. Migrate Oracle databases to RDS or EC2, DB2 databases to Aurora PostgreSQL using SCT/DMS. Test extensively in a parallel-run environment before cutover.
C) Run AIX in a virtual machine on EC2
D) Rewrite all applications in Python for AWS Lambda

**Correct Answer: B**
**Explanation:** Migrating from AIX/POWER to Linux/x86 requires different approaches per language: (1) Java applications are largely portable since the JVM abstracts the platform — recompilation on Linux x86 with testing is typically sufficient; (2) C/C++ applications need recompilation on Linux x86, with potential code changes for endianness differences (POWER is big-endian, x86 is little-endian) and AIX-specific system calls; (3) Oracle on EC2 or RDS maintains database compatibility; (4) DB2 to Aurora PostgreSQL reduces licensing costs (DB2 on Linux x86 is also an option); (5) Parallel-run testing validates the platform migration before cutover. Option A's MGN can't replicate AIX to x86. Option C's AIX can't run in a VM on x86 hardware. Option D is an unrealistic rewrite scope.

---

### Question 32
A company is migrating from a traditional three-tier architecture to microservices on AWS. The monolithic application has 500,000 lines of code, 50 modules, and a single Oracle database. They want to use the Strangler Fig pattern for incremental migration. Which approach implements the Strangler Fig pattern effectively?

A) Rewrite the entire application as microservices, deploy on EKS, and switch over in one release
B) Deploy the monolith on EC2, place an Application Load Balancer in front, incrementally extract modules as microservices (Lambda/ECS), route specific URL paths from the ALB to new microservices while maintaining the monolith for unextracted modules, decompose the database using event sourcing and the Database-per-Service pattern as services are extracted, use Amazon EventBridge for inter-service communication
C) Fork the code repository and maintain two parallel applications during migration
D) Extract all 50 modules simultaneously as microservices

**Correct Answer: B**
**Explanation:** Option B correctly implements the Strangler Fig pattern: (1) The monolith continues running on EC2, handling all unextracted functionality; (2) ALB acts as the routing layer (the "strangler"), directing specific paths to new microservices; (3) Modules are extracted one at a time as independent microservices — high-value, loosely-coupled modules first; (4) Database decomposition follows service extraction — each new microservice gets its own database, with event-driven synchronization back to the monolith's database during transition; (5) EventBridge enables loose coupling between services; (6) The monolith gradually "shrinks" as modules are extracted. Option A is a big-bang approach, not Strangler Fig. Option C doubles maintenance burden. Option D extracts all modules at once, losing the incremental benefit.

---

### Question 33
A manufacturing company is migrating their SCADA (Supervisory Control and Data Acquisition) system to AWS. The SCADA system monitors and controls industrial equipment across 50 factory sites. The system requires: sub-100ms communication with PLCs (Programmable Logic Controllers), historical data storage for 10 years, alerting on threshold breaches, and centralized monitoring dashboards. Which architecture supports SCADA on AWS?

A) Migrate the SCADA server directly to EC2 in the nearest AWS region
B) Deploy AWS IoT Greengrass at each factory site for local SCADA data collection and PLC communication (sub-100ms), IoT Core for cloud ingestion, Amazon Timestream for time-series data storage with tiered retention (magnetic store for long-term), Amazon Managed Grafana for monitoring dashboards, and IoT Events for threshold-based alerting
C) Use Amazon Kinesis for data collection, DynamoDB for storage, and CloudWatch for alerting
D) Keep SCADA on-premises and replicate data to S3 for analytics only

**Correct Answer: B**
**Explanation:** Option B provides a cloud-native SCADA architecture: (1) IoT Greengrass at each factory provides the sub-100ms local communication with PLCs — SCADA protocols (Modbus, OPC-UA) run on the Greengrass device; (2) IoT Core aggregates data from all 50 sites to the cloud; (3) Timestream provides purpose-built time-series storage with magnetic store for long-term (10-year) retention at low cost; (4) Managed Grafana provides rich industrial monitoring dashboards; (5) IoT Events evaluates threshold breaches and triggers alerts. Option A's EC2 in a remote region can't meet sub-100ms PLC communication. Option C's Kinesis/DynamoDB isn't optimized for time-series SCADA data. Option D misses the modernization opportunity.

---

### Question 34
A company is migrating their Citrix XenApp environment (5,000 users, 100 published applications) to AWS. Users access published applications including Microsoft Office, custom LOB applications, and specialized engineering tools (some requiring GPU). Which AWS service provides the MOST direct replacement for Citrix application publishing?

A) Amazon WorkSpaces for all users with full desktop experience
B) Amazon AppStream 2.0 for application streaming with fleet types matching workload requirements: general-purpose fleet for Office and LOB applications, graphics-design fleet for engineering tools requiring GPU, elastic fleets for on-demand scaling during peak hours, and AppStream 2.0 image builder for application packaging
C) Deploy Citrix Virtual Apps on EC2, maintaining the existing Citrix infrastructure
D) Amazon WorkSpaces Web for all applications through a web browser

**Correct Answer: B**
**Explanation:** Option B provides the most direct Citrix XenApp replacement: (1) AppStream 2.0 is purpose-built for application streaming, directly replacing Citrix's published application model; (2) General-purpose fleet handles Office and LOB applications cost-effectively; (3) Graphics-design fleet provides GPU-powered instances for engineering tools; (4) Elastic fleets provide on-demand scaling without persistent fleet management, reducing costs during off-peak; (5) Image builder packages applications similarly to Citrix's application publishing; (6) Users access applications via web browser or native client. Option A's WorkSpaces provides full desktops, which is over-provisioned when users only need published applications. Option C maintains Citrix licensing costs. Option D's WorkSpaces Web is limited to web applications.

---

### Question 35
A company is migrating a legacy TIBCO BusinessWorks integration platform (200 integration processes connecting 50 systems) to AWS. The integrations include: REST/SOAP API calls, file transfers, message queue integrations, database integrations, and scheduled batch processes. Which AWS services replace the TIBCO functionality?

A) Rewrite all integrations as Lambda functions triggered by EventBridge
B) Deploy TIBCO BusinessWorks on EC2, maintaining the existing integration processes
C) AWS Step Functions for process orchestration replacing TIBCO process flows, Amazon API Gateway for REST/SOAP API management, AWS Transfer Family for managed file transfers, Amazon MQ for message queue integrations (JMS/AMQP), AWS Glue for database integrations and ETL, and EventBridge Scheduler for scheduled batch processes
D) Amazon AppFlow for all integrations between SaaS applications

**Correct Answer: C**
**Explanation:** Option C maps each TIBCO capability to an AWS service: (1) Step Functions replaces TIBCO process orchestration with visual workflow design and error handling; (2) API Gateway handles REST API management and can proxy SOAP services; (3) Transfer Family provides managed SFTP/FTPS/FTP for file transfer integrations; (4) Amazon MQ provides JMS/AMQP messaging compatibility with TIBCO EMS connections; (5) Glue handles database integrations and ETL transformations; (6) EventBridge Scheduler replaces TIBCO's job scheduling. This provides a comprehensive serverless/managed replacement. Option A oversimplifies 200 complex integration processes. Option B maintains TIBCO licensing. Option D only covers SaaS-to-SaaS integrations, not the full scope.

---

### Question 36
A company wants to migrate their Oracle WebLogic application servers to AWS. They run 30 WebLogic domains with clustered deployments serving Java EE applications. The applications use WebLogic-specific features including: WebLogic JMS, WebLogic clustering with session replication, WebLogic security providers, and WebLogic web services. The company wants to reduce licensing costs. What is the recommended migration approach?

A) Deploy WebLogic on EC2 with BYOL
B) Migrate applications from WebLogic to Apache Tomcat, rewriting WebLogic-specific features
C) Containerize WebLogic applications using Oracle's WebLogic Image Tool, deploy on Amazon EKS, use Oracle's WebLogic Kubernetes Operator for lifecycle management, replace WebLogic JMS with Amazon MQ, and replace WebLogic session replication with ElastiCache for Redis session management
D) Migrate to AWS Elastic Beanstalk with Tomcat platform

**Correct Answer: C**
**Explanation:** Option C modernizes WebLogic deployments while reducing costs: (1) WebLogic Image Tool creates optimized container images for WebLogic applications; (2) WebLogic Kubernetes Operator manages WebLogic domains on EKS, handling clustering, scaling, and lifecycle; (3) EKS provides the container orchestration platform; (4) Amazon MQ replaces WebLogic JMS for messaging (JMS-compatible); (5) ElastiCache for Redis provides distributed session management, replacing WebLogic's session replication; (6) Containerization enables auto-scaling and better resource utilization. While WebLogic licensing is still needed for the runtime, the containerized approach reduces the number of licenses needed through better resource utilization and right-sizing. Option A maintains full licensing costs. Option B requires extensive rewrites. Option D's Tomcat doesn't support WebLogic-specific features.

---

### Question 37
A company has 500 databases of varying types (Oracle, SQL Server, MySQL, PostgreSQL, MongoDB, Cassandra) that need to be migrated to AWS. They need to minimize the total migration time while ensuring data consistency. The databases range from 1GB to 10TB. Some have high change rates (10,000 changes per second) while others are nearly static. Which migration strategy optimizes the overall migration timeline?

A) Migrate all databases sequentially using DMS, starting with the smallest
B) Categorize databases by size and change rate: (1) Small static databases (< 100GB, low change rate) → AWS DMS full load with downtime cutover (bulk migration, simple); (2) Medium databases → DMS with ongoing replication for minimal downtime cutover; (3) Large databases (> 1TB) → AWS DMS with ongoing replication, started early to allow initial sync time; (4) High change rate databases → DMS with ongoing replication using parallel load and partitioned large tables; (5) NoSQL databases (MongoDB, Cassandra) → DMS or native tools (mongodump, sstableloader), and run all migration streams in parallel using multiple DMS replication instances
C) Use native database backup/restore for all databases
D) Use AWS Snowball for data transfer of all databases

**Correct Answer: B**
**Explanation:** Option B optimizes the migration timeline through parallelization and appropriate tooling: (1) Categorization by size/change rate determines the right DMS configuration per database; (2) Starting large databases early gives them time to complete initial synchronization while smaller databases are migrated; (3) Parallel migration streams across multiple DMS replication instances maximize throughput; (4) Ongoing replication for high-change-rate databases maintains synchronization until cutover; (5) DMS parallel load and table partitioning speed up initial loads for large tables; (6) Native tools for NoSQL databases may be more efficient than DMS. Option A's sequential approach wastes time. Option C's backup/restore requires downtime for every database. Option D's Snowball doesn't handle ongoing replication for the cutover.

---

### Question 38
A company is migrating their disaster recovery environment to AWS. Currently, they maintain a secondary data center for DR with identical infrastructure (warm standby). The DR environment costs $2M annually. The primary data center has 500 servers. RPO requirement is 1 hour, RTO is 4 hours. Which AWS DR strategy significantly reduces costs while meeting RPO/RTO?

A) Replicate all 500 servers to EC2 using MGN, keep them running at minimum capacity (pilot light)
B) Use AWS Elastic Disaster Recovery (DRS) for continuous block-level replication of all 500 servers to AWS, with launch configurations pre-defined for right-sized EC2 instances, automated recovery with failover orchestration, and periodic DR drills to validate RTO — only paying for minimal staging resources until a DR event, with full resources launched on demand during failover
C) Set up automated AMI creation every hour and CloudFormation templates for infrastructure
D) Keep the secondary data center and add AWS as an additional DR layer

**Correct Answer: B**
**Explanation:** Option B provides the most cost-effective DR solution: (1) Elastic Disaster Recovery continuously replicates block-level data to staging area EBS volumes in AWS, meeting the 1-hour RPO; (2) During normal operations, costs are minimal — only small staging instances and EBS storage for replication (not full-size EC2 instances); (3) Pre-defined launch configurations specify the right-sized EC2 instance types for each server during failover; (4) Automated failover orchestration launches full-size instances and connects them, meeting the 4-hour RTO; (5) Periodic DR drills validate the RTO without impacting production; (6) Cost savings compared to maintaining a full secondary data center can exceed 80%. Option A's pilot light approach with running servers costs more. Option C's hourly AMIs may not capture all changes (RPO risk). Option D maintains the expensive secondary DC.

---

### Question 39
A company is migrating their SAP environment to AWS and needs to implement a high-availability architecture for SAP S/4HANA. The environment includes: SAP Central Services (ASCS/ERS), SAP Application Servers, and SAP HANA database. RTO is 15 minutes and RPO is 0. Which HA architecture meets these requirements for SAP on AWS?

A) Single-AZ deployment with EBS snapshots for recovery
B) SAP ASCS/ERS in a Linux Pacemaker cluster across 2 AZs using Amazon EFS for shared filesystem, SAP Application Servers deployed across 2 AZs behind a Network Load Balancer, SAP HANA configured with synchronous System Replication (HSR) across 2 AZs with automatic failover using Pacemaker, and Route 53 private hosted zone for SAP virtual hostname resolution
C) SAP ASCS on a single EC2 instance with Auto Scaling group (min=1, max=1) for automatic recovery, HANA with asynchronous HSR
D) All SAP components in a single AZ with Cross-AZ EBS replication

**Correct Answer: B**
**Explanation:** Option B provides the SAP-recommended HA architecture on AWS: (1) ASCS/ERS Pacemaker cluster across AZs provides automatic failover for SAP Central Services; (2) EFS shared filesystem stores SAP transport directory and other shared data accessible from both AZs; (3) NLB distributes application server traffic and provides automatic health-check-based failover; (4) HANA synchronous HSR across AZs provides RPO=0 (zero data loss) with automatic failover via Pacemaker; (5) Route 53 private hosted zone manages SAP virtual hostnames for transparent failover. Option A's single-AZ has no HA. Option C's asynchronous HSR doesn't meet RPO=0. Option D doesn't exist as an AWS feature and single-AZ has AZ-level failure risk.

---

### Question 40
A company needs to migrate their on-premises Hadoop cluster (500 nodes, 5PB of data) to AWS. The cluster runs both batch MapReduce/Spark jobs and interactive Hive queries. The company wants to decouple storage from compute and reduce costs. Which architecture provides the equivalent capabilities?

A) Deploy a permanent EMR cluster with 500 nodes replicating the on-premises Hadoop cluster
B) Migrate data from HDFS to Amazon S3 (data lake), deploy transient EMR clusters for batch Spark/MapReduce jobs that scale based on workload and terminate when complete, Amazon EMR with Apache Hive on a persistent cluster sized for interactive query workload, Amazon Athena as an additional interactive query engine for ad-hoc queries directly on S3 data, and AWS Glue Data Catalog as the metastore shared across EMR and Athena
C) Use Amazon Redshift for all batch and interactive workloads
D) Deploy Amazon EMR on EKS for all workloads

**Correct Answer: B**
**Explanation:** Option B provides the optimal Hadoop-to-AWS migration: (1) S3 as the storage layer decouples storage from compute, enabling independent scaling and eliminating the 3x HDFS replication overhead; (2) Transient EMR clusters for batch jobs launch with the exact node count needed, process data, and terminate — dramatically reducing compute costs; (3) Persistent EMR with Hive provides interactive query capability for regular users; (4) Athena provides serverless ad-hoc queries for occasional users without provisioning infrastructure; (5) Glue Data Catalog provides a shared metastore (replacing the Hive metastore) accessible from all compute engines; (6) This architecture can reduce costs by 60-70% compared to a permanent 500-node cluster. Option A replicates the costly permanent cluster. Option C can't run MapReduce/Spark jobs. Option D limits flexibility compared to traditional EMR for diverse Hadoop workloads.

---

### Question 41
A company is migrating their email infrastructure from on-premises Microsoft Exchange Server (10,000 mailboxes) to AWS. They want to maintain compatibility with Outlook desktop clients and mobile devices. The company doesn't want to move to Microsoft 365 due to data sovereignty concerns. Which solution provides Exchange-compatible email hosting on AWS?

A) Amazon WorkMail for managed email hosting, with Amazon WorkMail Web Client for browser access and IMAP/EWS compatibility for Outlook, deployed in an AWS region that meets data sovereignty requirements, integrated with AWS Managed Microsoft AD for directory services
B) Deploy Microsoft Exchange Server on EC2 instances with Windows Server BYOL, RDS for SQL Server as the Exchange database, and maintain the existing Exchange management model
C) Use Amazon SES for sending and S3 for email storage
D) Migrate to a third-party hosted email solution on EC2

**Correct Answer: A**
**Explanation:** Option A provides managed Exchange-compatible email: (1) Amazon WorkMail is a managed email and calendaring service that provides EWS (Exchange Web Services) compatibility, which Outlook clients use; (2) WorkMail data stays in the chosen AWS region, satisfying data sovereignty requirements; (3) WorkMail supports migration from Exchange using the IMAP protocol or the Exchange Web Services migration tool; (4) AWS Managed Microsoft AD integration provides directory services compatible with the existing corporate directory; (5) WorkMail eliminates Exchange Server management overhead. Option B maintains the complexity of managing Exchange Server infrastructure. Option C's SES is for transactional email, not mailbox hosting. Option D doesn't provide the managed, AWS-native solution.

---

### Question 42
A company is migrating a real-time trading platform from co-located data center servers to AWS. The platform requires: ultra-low latency (< 100 microseconds for order matching), deterministic performance (no GC pauses, no hypervisor jitter), high-frequency network I/O (millions of packets per second), and kernel bypass networking. Which EC2 instance configuration meets these requirements?

A) C6i instances with enhanced networking
B) EC2 bare metal instances (e.g., c6i.metal) with Elastic Fabric Adapter (EFA) for kernel bypass networking, DPDK (Data Plane Development Kit) for user-space network processing, CPU pinning and NUMA-aware memory allocation configured in the application, real-time Linux kernel with tuned CPU isolation, and placement groups for cluster networking
C) P5 GPU instances for parallel processing acceleration
D) EC2 instances with Nitro System and SR-IOV enhanced networking

**Correct Answer: B**
**Explanation:** For ultra-low latency trading (sub-100 microsecond), Option B provides the required capabilities: (1) Bare metal instances eliminate hypervisor jitter — the application runs directly on hardware; (2) EFA provides kernel bypass networking, avoiding kernel network stack overhead; (3) DPDK enables user-space packet processing at millions of packets per second; (4) CPU pinning prevents context switching on critical cores; (5) NUMA-aware memory allocation ensures memory access consistency; (6) Real-time Linux kernel with CPU isolation provides deterministic scheduling; (7) Placement groups minimize inter-instance latency. Option A's virtualized instances have hypervisor overhead. Option C's GPU instances don't address the latency requirements. Option D still runs in a virtualized environment.

---

### Question 43
A company needs to migrate their Apache Kafka cluster (30 brokers, 50TB of data, 500 topics) to AWS. They currently process 2 million messages per second. The migration must be zero-downtime with no message loss. Which migration approach ensures zero-downtime Kafka migration?

A) Set up Amazon MSK cluster with equivalent capacity, use MirrorMaker 2.0 to replicate all topics from on-premises Kafka to MSK in real-time, gradually redirect producers to write to MSK, then redirect consumers to read from MSK, and decommission the on-premises cluster after verifying no lag in all consumer groups
B) Export Kafka data to S3 and reimport into MSK
C) Use AWS DMS to migrate Kafka topics to MSK
D) Create a new MSK cluster and have applications switch simultaneously during a maintenance window

**Correct Answer: A**
**Explanation:** Option A provides zero-downtime Kafka migration: (1) MSK cluster sized to match the 30-broker, 2M messages/second workload; (2) MirrorMaker 2.0 replicates all 500 topics in real-time with consumer group offset translation; (3) Gradual producer migration — each producer switches to MSK while MirrorMaker handles the transition period; (4) Consumer migration follows — consumers switch to MSK one at a time; (5) MirrorMaker's offset translation ensures consumers resume from the correct position on MSK; (6) Decommission on-premises only after verifying zero lag. This is the standard zero-downtime Kafka migration pattern. Option B's export/reimport would lose real-time data. Option C's DMS doesn't natively migrate Kafka topics. Option D's simultaneous switch risks message loss and coordination issues.

---

### Question 44
A company is evaluating whether to use AWS License Manager for managing their complex Microsoft licensing across 500 EC2 instances. They have a mix of: Windows Server Datacenter (unlimited VMs per physical host), SQL Server Enterprise (per-core licensing), Visual Studio Enterprise (per-user subscription), and .NET development tools. Which License Manager configuration correctly manages these license types?

A) Create a single license configuration for all Microsoft products
B) Create separate License Manager license configurations for each product: Windows Server Datacenter — tracked by number of instances on Dedicated Hosts (unlimited VMs per host), SQL Server Enterprise — tracked by vCPU count per instance with enforcement rules preventing deployment on instances exceeding the licensed core count, Visual Studio — tracked as per-user subscriptions not tied to instances, and configure automated discovery rules using AWS Systems Manager inventory to track software installations across all 500 instances
C) Manually track licenses in a spreadsheet and use License Manager for reporting only
D) Use AWS Marketplace for all Microsoft licensing to simplify management

**Correct Answer: B**
**Explanation:** Option B correctly configures License Manager for complex Microsoft licensing: (1) Windows Server Datacenter requires Dedicated Hosts tracking — the license covers unlimited VMs per physical host, so License Manager tracks Dedicated Host allocation; (2) SQL Server Enterprise per-core licensing requires tracking vCPU count per instance, with enforcement rules preventing deployment on over-licensed instances; (3) Visual Studio per-user subscriptions are tracked independently of instances; (4) Systems Manager inventory integration automatically discovers installed software, ensuring compliance; (5) Separate configurations per product prevent conflicting license rules. Option A can't handle different licensing models in one configuration. Option C doesn't leverage automation. Option D doesn't cover all licensing scenarios.

---

### Question 45
A company is migrating from a commercial relational database (Oracle) to Amazon DynamoDB as part of their modernization initiative. The Oracle database has a normalized schema with 80 tables, complex joins, and stored procedures. The application performs 20 different query patterns. Which approach provides a SAFE migration path from relational to DynamoDB?

A) Directly map Oracle tables to DynamoDB tables, one-to-one
B) Analyze all 20 access patterns using the application's query logs, design a DynamoDB single-table schema that supports all access patterns using composite keys and GSIs, use AWS DMS for data migration, implement the application data access layer changes in phases — first implementing the most frequently used access patterns, then progressively migrating remaining patterns while running both Oracle and DynamoDB in parallel
C) Migrate to Aurora PostgreSQL first, then migrate from Aurora to DynamoDB
D) Rewrite the entire application to use DynamoDB from scratch

**Correct Answer: B**
**Explanation:** Option B provides a safe, methodical relational-to-DynamoDB migration: (1) Access pattern analysis from query logs identifies exactly which queries need DynamoDB support — this is the most critical step in DynamoDB schema design; (2) Single-table design with composite keys models the denormalized access patterns efficiently; (3) GSIs support secondary access patterns; (4) DMS migrates data from Oracle to DynamoDB; (5) Phased application changes reduce risk — start with the most common patterns, validate, then continue; (6) Parallel running of Oracle and DynamoDB during transition provides a safety net. Option A's one-to-one table mapping doesn't work for DynamoDB (no joins). Option C adds an unnecessary intermediate step. Option D's complete rewrite is high-risk without the parallel running safety net.

---

### Question 46
A company is migrating their mainframe print spooling system to AWS. The current system processes 2 million print jobs daily, generating reports in AFP (Advanced Function Presentation) format. Reports are distributed to 500 printers, 200 email addresses, and archived for 7 years. Which architecture replaces the mainframe print spooling system?

A) Lambda functions processing print jobs directly to S3 for archival
B) AWS Step Functions orchestrating the print pipeline: S3 for incoming job storage → Lambda for AFP-to-PDF conversion using open-source transformation libraries → SNS for routing decisions (print, email, archive) → Amazon SES for email distribution → S3 with lifecycle policies for 7-year archival to Glacier → AWS IoT Core for printer management and job delivery → DynamoDB for job tracking and status
C) EC2 instances running CUPS (Common Unix Printing System) for print management
D) Amazon WorkDocs for document distribution and storage

**Correct Answer: B**
**Explanation:** Option B provides a comprehensive print modernization architecture: (1) Step Functions orchestrates the complex multi-step print pipeline; (2) AFP-to-PDF conversion modernizes the output format using open-source tools; (3) SNS-based routing handles the three distribution paths (print, email, archive); (4) SES provides managed email delivery for the 200 email destinations; (5) S3 with Glacier lifecycle handles 7-year archival at low cost; (6) IoT Core manages the 500 printers and delivers print jobs over standard protocols; (7) DynamoDB tracks job status for operational monitoring. Option A oversimplifies a complex print spooling system. Option C's CUPS doesn't handle the full pipeline (email, archival, AFP conversion). Option D doesn't handle print job management.

---

### Question 47
A company is performing a mass migration using AWS Application Migration Service (MGN). During testing, they discover that 50 servers have dependencies on specific IP addresses hardcoded in application configurations. Changing IP addresses post-migration would require modifying configurations across hundreds of files. How should the architect handle the IP address dependency?

A) Manually update all configuration files after migration
B) Configure the target VPC subnets to use the same CIDR ranges as the on-premises network, use MGN's launch template settings to assign specific private IP addresses matching the source servers' IP addresses, and validate IP assignments in test launches before the production cutover
C) Set up a DNS-based solution to map hostnames to new IP addresses
D) Use AWS PrivateLink to maintain the same IP addresses

**Correct Answer: B**
**Explanation:** Option B preserves IP addresses during migration: (1) VPC subnets can be configured with any RFC 1918 CIDR range, including ranges matching the on-premises network; (2) MGN launch templates allow specifying exact private IP addresses for target EC2 instances; (3) By matching the CIDR and assigning the same IPs, all hardcoded IP references continue to work without configuration changes; (4) Test launches validate that IP assignments are correct before production cutover; (5) This is the fastest approach for the 50 servers with IP dependencies. Option A's manual configuration changes across hundreds of files is error-prone and time-consuming. Option C requires applications to use hostnames (they're using IPs). Option D doesn't preserve specific private IP addresses.

---

### Question 48
A company is migrating their Teradata data warehouse (100TB, 50 nodes) to AWS. The warehouse runs complex analytical queries with 500 concurrent users. The company wants to maintain query performance while reducing costs. They use Teradata-specific SQL extensions extensively. Which migration approach balances compatibility and cost?

A) Migrate directly to Amazon Redshift, rewriting all Teradata-specific SQL
B) Deploy Teradata Vantage on EC2 with BYOL to maintain full SQL compatibility, while simultaneously setting up Amazon Redshift with AWS SCT to convert Teradata SQL to Redshift SQL, perform a parallel-run validation comparing query results between Teradata on EC2 and Redshift, and gradually migrate workloads from Teradata to Redshift, decommissioning Teradata when all queries are validated on Redshift
C) Migrate to Amazon EMR with Hive for SQL analytics
D) Use Amazon Athena for all data warehouse queries on data stored in S3

**Correct Answer: B**
**Explanation:** Option B provides a safe migration path from Teradata: (1) Teradata Vantage on EC2 provides immediate data center exit with full SQL compatibility; (2) AWS SCT automates conversion of Teradata-specific SQL to Redshift-compatible SQL; (3) Parallel-run validation ensures query accuracy before decommissioning Teradata; (4) Gradual workload migration reduces risk; (5) Redshift provides similar analytical performance at a fraction of the cost; (6) This phased approach manages the risk of SQL compatibility issues. Option A's direct migration risks query failures from Teradata-specific SQL. Option C's EMR/Hive doesn't match Teradata's query performance for concurrent SQL users. Option D's Athena doesn't provide the consistent query performance needed for 500 concurrent users.

---

### Question 49
A company is migrating from their on-premises VMware vSphere environment and wants to continue using VMware tools during the migration. They have NSX-T for networking, vSAN for storage, and vRealize for operations management. 30% of workloads will eventually move to native AWS services, while 70% will continue on VMware infrastructure. Which approach provides the BEST transition path?

A) Migrate all workloads to EC2 using MGN
B) Deploy VMware Cloud on AWS (VMC), migrate workloads using VMware HCX (Hybrid Cloud Extension) for live vMotion with zero downtime, maintain vCenter/NSX-T/vRealize management consistency, connect VMC to native AWS services via the connected VPC, and progressively migrate the 30% of workloads from VMC to native EC2/EKS using MGN or application modernization
C) Set up VMware on EC2 bare metal instances manually
D) Use AWS Outposts with VMware for on-premises integration

**Correct Answer: B**
**Explanation:** Option B provides the optimal VMware transition: (1) VMware Cloud on AWS runs the full VMware stack (vSphere, vSAN, NSX-T) on AWS bare metal; (2) HCX enables live vMotion of VMs from on-premises to VMC with zero downtime; (3) vCenter, NSX-T, and vRealize continue managing workloads with the same operational model; (4) VMC's connected VPC provides direct access to native AWS services (S3, RDS, Lambda); (5) The 30% of workloads destined for native AWS can be migrated from VMC using MGN or modernization tools. Option A forces all workloads off VMware immediately. Option C requires manual VMware configuration on bare metal. Option D provides on-premises VMware integration but doesn't reduce data center footprint.

---

### Question 50
A company migrating to AWS needs to handle the migration of 50 applications with complex certificate management. Each application uses different SSL/TLS certificates from various certificate authorities. Some certificates are bound to specific IP addresses, and some use wildcard certificates. How should certificates be managed on AWS?

A) Import all existing certificates into AWS Certificate Manager (ACM) and associate them with load balancers and CloudFront distributions
B) Assess certificate requirements: (1) For public-facing services — provision new certificates from ACM (free, auto-renewing) for ALB, CloudFront, and API Gateway endpoints; (2) For certificates requiring specific CA — import third-party certificates to ACM with automated expiration monitoring via EventBridge; (3) For internal services — deploy ACM Private CA for internal certificate issuance; (4) For IP-bound certificates — review if migration to hostname-based certificates is possible, otherwise deploy certificates on EC2 instances directly; and set up CloudWatch alarms for certificate expiration
C) Continue using the same on-premises certificate management process for EC2-hosted applications
D) Use Let's Encrypt for all certificates with automated renewal on EC2 instances

**Correct Answer: B**
**Explanation:** Option B provides comprehensive certificate management for the migration: (1) ACM certificates for public services are free and auto-renewing, eliminating renewal management; (2) Imported third-party certificates in ACM enable centralized management with expiration monitoring; (3) ACM Private CA provides internal certificate management with automated issuance; (4) IP-bound certificates require special handling — ideally migrating to hostname-based, but can be deployed directly on EC2 if necessary; (5) EventBridge + CloudWatch monitoring prevents certificate expiration. Option A doesn't address the diversity of certificate types and can't import all certificate types to ACM. Option C doesn't leverage AWS certificate management. Option D's Let's Encrypt doesn't work for all use cases (internal services, client certificates).

---

### Question 51
A company is migrating their AS/400 (IBM iSeries) applications to AWS. The AS/400 runs RPG (Report Program Generator) applications with DB2 for i databases. The system processes 5,000 transactions per second for inventory management. Users access through 5250 terminal emulation. Which modernization approach for AS/400 workloads on AWS is MOST appropriate?

A) Rewrite all RPG programs in Python/Java on Lambda
B) Use a commercial AS/400 migration tool (such as Infinite i or Fresche Legacy) to convert RPG programs to Java or .NET, deploy on ECS/EKS, migrate DB2 for i to Aurora PostgreSQL using SCT/DMS, replace 5250 terminal interface with a web-based UI using React/Angular, and implement the migration incrementally using a strangler fig pattern
C) Run an AS/400 emulator on EC2
D) Migrate to SAP as a replacement for the AS/400 inventory system

**Correct Answer: B**
**Explanation:** Option B provides a practical AS/400 modernization path: (1) Commercial migration tools (Infinite i, Fresche) specialize in RPG-to-Java/.NET conversion with proven track records; (2) Converted applications deploy on modern platforms (ECS/EKS); (3) DB2 for i migration to Aurora PostgreSQL reduces licensing costs; (4) Web-based UI replaces the 5250 terminal interface, modernizing the user experience; (5) Strangler fig pattern enables incremental migration, reducing risk. Option A's complete rewrite of RPG programs is extremely high-risk and ignores decades of embedded business logic. Option C's emulation doesn't modernize and may have licensing issues. Option D's SAP replacement is a different application entirely.

---

### Question 52
A company is migrating their Windows-based .NET applications that use Windows Communication Foundation (WCF) services for inter-service communication. The WCF services use net.tcp binding and Windows Integrated Authentication. Which AWS-compatible replacement maintains the communication patterns?

A) Replace WCF with ASP.NET Core gRPC services on ECS, using AWS App Mesh for service discovery and mutual TLS, migrating from net.tcp to HTTP/2 protocol, and replacing Windows Authentication with AWS IAM roles for service-to-service authentication
B) Replace WCF with REST APIs using API Gateway and Lambda
C) Maintain WCF on EC2 Windows instances without changes
D) Replace WCF with Amazon SQS for all service communication

**Correct Answer: A**
**Explanation:** Option A provides the best WCF modernization path: (1) gRPC is Microsoft's recommended successor to WCF for service-to-service communication; (2) gRPC over HTTP/2 provides similar performance characteristics to WCF's net.tcp (binary serialization, streaming, bidirectional communication); (3) ECS provides scalable container hosting; (4) App Mesh provides service discovery and mTLS, replacing WCF's security features; (5) IAM roles for service-to-service authentication replaces Windows Integrated Authentication in a cloud-native way. Option B's REST APIs lose the binary efficiency and streaming capabilities of WCF. Option C maintains the dependency on Windows and WCF without modernization. Option D changes the communication pattern from synchronous RPC to asynchronous messaging.

---

### Question 53
A company is migrating their Oracle Fusion Middleware platform to AWS. The middleware includes Oracle SOA Suite, Oracle Service Bus, and Oracle Business Process Management. These components integrate 30 backend systems and handle 50,000 service calls per minute. Which AWS architecture replaces the Oracle middleware?

A) Deploy Oracle Fusion Middleware on EC2 instances with BYOL
B) Replace Oracle SOA Suite with AWS Step Functions for service orchestration, Amazon API Gateway for service bus functionality (API management, routing, transformation), Amazon EventBridge for event-driven integration patterns, AWS Lambda for service adapters connecting to the 30 backend systems, and Amazon MQ for systems requiring message-oriented middleware
C) Use a single API Gateway as a pass-through proxy for all service calls
D) Replace with MuleSoft Anypoint Platform on EC2

**Correct Answer: B**
**Explanation:** Option B replaces each Oracle middleware component with AWS-native services: (1) Step Functions replaces SOA Suite's orchestration engine for complex service workflows; (2) API Gateway replaces Oracle Service Bus for API management, request routing, and transformation; (3) EventBridge replaces event-driven integration patterns; (4) Lambda service adapters connect to each backend system with appropriate protocol handling; (5) Amazon MQ provides JMS/AMQP messaging for systems requiring it. Option A maintains Oracle middleware licensing. Option C oversimplifies the middleware's orchestration and transformation capabilities. Option D introduces another commercial platform with licensing costs.

---

### Question 54
A company is running Microsoft Dynamics 365 Finance and Operations on-premises and wants to migrate to AWS. The application requires SQL Server Enterprise Edition, Windows Server, and Active Directory. The production environment needs 99.99% availability. Which architecture provides enterprise-grade Dynamics 365 on AWS?

A) Single EC2 instance with SQL Server Express
B) Application tier: EC2 Windows instances across 2 AZs behind ALB with Auto Scaling, Batch tier: separate EC2 instances for batch processing, Database tier: SQL Server Enterprise on EC2 with Always On Availability Groups across 2 AZs (Dedicated Hosts for BYOL), Active Directory: AWS Managed Microsoft AD with multi-AZ deployment, Storage: FSx for Windows File Server for shared document storage, and monitoring with CloudWatch custom metrics for Dynamics-specific KPIs
C) Deploy on Amazon RDS for SQL Server with Multi-AZ for the database tier only
D) Use Amazon WorkSpaces for user access to an on-premises Dynamics deployment

**Correct Answer: B**
**Explanation:** Option B provides enterprise-grade Dynamics 365 architecture: (1) Multi-AZ application tier with ALB and Auto Scaling provides high availability and scalability; (2) Separate batch processing tier prevents batch workloads from impacting interactive users; (3) SQL Server Enterprise on EC2 with Always On AG provides database HA with automatic failover; (4) Dedicated Hosts enable BYOL for SQL Server Enterprise licensing; (5) Managed AD provides the required Active Directory services with built-in HA; (6) FSx for Windows File Server provides managed CIFS-compatible shared storage; (7) This architecture supports 99.99% availability across all tiers. Option A has no HA. Option C only addresses the database tier. Option D doesn't actually migrate Dynamics to AWS.

---

### Question 55
A company is modernizing their legacy ETL processes that currently run on IBM DataStage. The DataStage environment has 300 jobs with complex data transformations including: SCD (Slowly Changing Dimensions) processing, data quality rules, and complex lookup transformations. Which approach migrates DataStage jobs to AWS with minimal rewriting?

A) Rewrite all 300 jobs as custom Python scripts
B) Use AWS Glue with custom transforms: convert DataStage jobs using AWS Glue Studio's visual ETL interface for standard transformations, implement SCD Type 2 logic using Glue's custom PySpark scripts, replace DataStage data quality stages with AWS Glue Data Quality, use AWS Glue's lookup transform for reference data lookups, and migrate incrementally — run DataStage and Glue in parallel, validating output data matches before switching each job
C) Deploy IBM DataStage on EC2 with BYOL
D) Use Amazon Redshift stored procedures to replace all ETL logic

**Correct Answer: B**
**Explanation:** Option B provides a methodical DataStage-to-Glue migration: (1) Glue Studio visual interface provides a similar drag-and-drop ETL design experience to DataStage; (2) Standard transformations (joins, aggregations, filters) map directly to Glue transforms; (3) SCD Type 2 processing is implemented with custom PySpark scripts in Glue (a common pattern); (4) Glue Data Quality replaces DataStage's quality stages with rule-based validation; (5) Glue lookup transforms handle reference data enrichment; (6) Parallel running ensures data accuracy before decommissioning each DataStage job. Option A's manual rewriting of 300 jobs is extremely labor-intensive. Option C maintains DataStage licensing. Option D shifts ETL to the database, which isn't scalable.

---

### Question 56
A company is migrating their VMware-based Windows workloads and discovers that 20% of their Windows Server licenses are non-compliant (running on more cores than licensed). The total shortfall is 500 core licenses of Windows Server Standard. They want to become compliant during the migration. Which approach resolves the licensing compliance gap?

A) Purchase additional Windows Server licenses before migration
B) During the migration assessment phase, use AWS License Manager integrated with Systems Manager inventory to identify exactly which servers are non-compliant and by how much, then: for servers that are over-provisioned, right-size EC2 instances to match the actual workload (reducing core count to within licensed limits), for servers requiring full current capacity, use EC2 License Included pricing (which includes Windows Server licensing) to eliminate the compliance gap, and for remaining servers, use BYOL on Dedicated Hosts where existing licenses cover the core count
C) Ignore the licensing issue since AWS handles Windows licensing
D) Migrate all servers to Linux to eliminate Windows licensing requirements

**Correct Answer: B**
**Explanation:** Option B resolves the compliance gap as part of the migration: (1) License Manager with Systems Manager identifies exactly which servers are non-compliant and the specific core count shortfall; (2) Right-sizing over-provisioned servers reduces core count to within licensed limits — many servers are over-provisioned for their actual workload; (3) License Included EC2 pricing for the remaining non-compliant servers provides AWS-managed Windows licensing, eliminating the compliance gap; (4) BYOL on Dedicated Hosts for properly licensed servers maintains the existing licensing investment; (5) This blended approach optimizes overall licensing costs. Option A buys licenses for a potentially temporary situation. Option C doesn't resolve the compliance issue (AWS License Included would, but BYOL on standard instances wouldn't). Option D is unrealistic for Windows-dependent workloads.

---

### Question 57
A company is migrating a large-scale SAP landscape including: SAP S/4HANA (Production, QA, Development), SAP BW/4HANA, SAP Solution Manager, SAP PI/PO (Process Integration), and SAP Fiori. The entire landscape has 50 SAP systems across 200 EC2 instances. Which approach automates the SAP landscape deployment on AWS?

A) Manually deploy each SAP system on EC2 instances
B) Use AWS Launch Wizard for SAP to automate the deployment of the SAP landscape with: pre-validated SAP HANA and SAP application configurations, automated sizing recommendations based on SAP benchmarks (SAPS), infrastructure as code templates for each system tier, automated high-availability configuration (Pacemaker, HANA SR), and integration with SAP's provisioning tools for application-level configuration
C) Use CloudFormation templates from scratch for each SAP system
D) Use Terraform modules for SAP deployment

**Correct Answer: B**
**Explanation:** Option B uses the purpose-built tool for SAP on AWS: (1) AWS Launch Wizard for SAP automates the complex deployment of SAP systems following AWS and SAP best practices; (2) Pre-validated configurations ensure SAP-certified instance types and storage configurations; (3) SAPS-based sizing recommendations right-size infrastructure for each system's workload; (4) Automated HA configuration handles the complex Pacemaker/HANA System Replication setup that would otherwise require deep expertise; (5) Infrastructure as Code templates enable repeatable deployments across Production/QA/Dev environments. Option A is error-prone for 200 instances. Option C requires deep SAP-on-AWS expertise to build correct templates. Option D similarly requires custom module development.

---

### Question 58
A company is migrating their on-premises Kubernetes clusters (500 pods, 50 services) to Amazon EKS. The cluster uses custom admission controllers, Helm charts, Istio service mesh, Prometheus monitoring, and persistent volumes (NFS-backed). Which migration approach handles the complex Kubernetes ecosystem?

A) Recreate all Kubernetes resources manually on EKS
B) Use EKS Blueprints (AWS CDK-based) to provision the EKS cluster with add-ons matching the current environment: Istio (or App Mesh as alternative), Amazon Managed Prometheus for monitoring, Amazon EFS CSI driver for NFS-compatible persistent volumes, migrate workloads using Velero (backup/restore) for stateful workloads and Helm chart redeployment for stateless services, validate custom admission controllers with EKS admission controller support, and use ArgoCD/Flux for GitOps-based deployment management
C) Use AWS App Runner for all containerized workloads
D) Migrate to ECS instead of EKS for simpler management

**Correct Answer: B**
**Explanation:** Option B provides a comprehensive EKS migration: (1) EKS Blueprints automate cluster setup with the required add-ons, matching the current ecosystem; (2) Amazon Managed Prometheus replaces self-hosted Prometheus with a managed service; (3) EFS CSI driver provides NFS-compatible persistent storage on EKS; (4) Velero handles backup/restore of stateful workloads including persistent volume data; (5) Helm chart redeployment for stateless services ensures configuration consistency; (6) Custom admission controllers work on EKS with proper configuration; (7) GitOps with ArgoCD/Flux provides declarative deployment management. Option A is manual and error-prone for 500 pods. Option C's App Runner doesn't support the complex Kubernetes ecosystem. Option D loses Kubernetes-native features the applications depend on.

---

### Question 59
A company with Microsoft Enterprise Agreement is migrating to AWS. They need to understand the licensing implications for: Windows Server, SQL Server, Microsoft Office, Remote Desktop Services (RDS CALs), and System Center. Which licensing consideration is MOST critical to understand?

A) All Microsoft licenses automatically transfer to AWS
B) Windows Server and SQL Server can be deployed with License Included (billed per-hour via AWS) or BYOL on Dedicated Hosts/Dedicated Instances (with Software Assurance and License Mobility), Microsoft Office requires separate licensing (SA with License Mobility for Office apps on EC2, or Microsoft 365 subscription), RDS CALs require per-user or per-device licenses and must be tracked separately, System Center can be deployed on Dedicated Hosts with BYOL, and License Manager must be configured to track and enforce compliance across all Microsoft products
C) Microsoft licensing doesn't apply on AWS
D) Only SQL Server licensing needs to be considered

**Correct Answer: B**
**Explanation:** Option B correctly identifies the complex Microsoft licensing landscape on AWS: (1) Windows Server and SQL Server have two options — License Included (simpler but more expensive) or BYOL with SA on Dedicated Hosts (cheaper but requires tracking); (2) Microsoft Office requires License Mobility with SA or Microsoft 365 — it cannot use AWS License Included; (3) RDS CALs are often overlooked but legally required for Remote Desktop access to Windows Server; (4) System Center can run on Dedicated Hosts under BYOL; (5) License Manager enforcement prevents accidental non-compliance. Option A is incorrect — licenses don't automatically transfer. Option C is incorrect — Microsoft licensing fully applies on AWS. Option D ignores the other Microsoft products.

---

### Question 60
A company is migrating their legacy COBOL applications from a Unisys ClearPath mainframe. Unlike IBM mainframes, ClearPath uses a different instruction set and operating system. The applications total 5 million lines of COBOL code with embedded SQL accessing a DMSII database. Which migration approach handles the ClearPath-specific platform?

A) Use AWS Mainframe Modernization directly (designed for IBM mainframes)
B) Engage a specialized migration partner (such as Astadia or Modern Systems) with ClearPath-specific automated code conversion tools that: convert ClearPath COBOL to standard COBOL or Java, migrate DMSII database to Aurora PostgreSQL or RDS, convert ClearPath-specific system calls to standard equivalents, deploy converted applications on EC2 or ECS, and validate through extensive parallel testing
C) Manually rewrite all COBOL programs in Python
D) Run a ClearPath emulator on EC2

**Correct Answer: B**
**Explanation:** ClearPath mainframe migration requires specialized handling: (1) AWS Mainframe Modernization is designed for IBM z/OS, not Unisys ClearPath; (2) Specialized migration partners have tools specifically for ClearPath COBOL conversion; (3) ClearPath COBOL has dialect differences from standard COBOL that require specialized conversion; (4) DMSII database migration requires specific tools (it's not DB2); (5) ClearPath system calls need platform-specific conversion logic; (6) Parallel testing validates the conversion accuracy. Option A's Mainframe Modernization doesn't support ClearPath. Option C's manual rewrite of 5 million lines is impractical. Option D's emulation may not be available or cost-effective.

---

### Question 61
A company is migrating 1,000 applications to AWS using a migration factory approach. They need to track the migration status of each application through stages: Discovery → Assessment → Planning → Migration → Validation → Cutover → Optimization. Each application involves multiple stakeholders (app owner, DBA, network engineer, security). Which tooling provides end-to-end migration tracking?

A) Jira for project management with manual status updates
B) AWS Migration Hub with application grouping, integrated with: AWS Application Discovery Service for automated discovery data, custom dashboards in Migration Hub for stage tracking, AWS Service Catalog for standardized provisioning templates per stage, Amazon CodeCatalyst for migration workflow automation, and CloudWatch dashboards with custom metrics for migration KPIs (migration velocity, success rate, rollback rate)
C) Microsoft Project with Gantt charts for tracking
D) AWS Migration Hub alone without additional tooling

**Correct Answer: B**
**Explanation:** Option B provides comprehensive migration factory tracking: (1) Migration Hub centralizes the tracking of all 1,000 applications with built-in stage tracking; (2) Application Discovery Service feeds automated server and dependency data; (3) Custom dashboards visualize migration progress across all stages; (4) Service Catalog provides standardized, approved templates for each migration stage (ensuring consistency across the factory); (5) CodeCatalyst automates migration workflows with built-in CI/CD capabilities; (6) CloudWatch custom metrics track factory KPIs essential for management reporting. Option A requires manual tracking for 1,000 apps. Option C doesn't integrate with AWS services. Option D lacks the automation and KPI tracking needed for a factory approach.

---

### Question 62
A company needs to migrate their Oracle Forms application to AWS. The application has 200 Oracle Forms screens, 100 Oracle Reports, and connects to an Oracle Database. Oracle Forms is a fat-client technology requiring Java Web Start. They want to modernize the user interface while maintaining backend compatibility. Which approach provides the BEST modernization path?

A) Keep Oracle Forms on EC2 with Dedicated Hosts BYOL
B) Replace Oracle Forms front-end with a modern web application (React/Angular) using REST APIs backed by API Gateway and Lambda functions that call Oracle Database stored procedures via RDS Proxy, replace Oracle Reports with Amazon QuickSight for analytics and JasperReports on ECS for operational reports, migrate Oracle Database to RDS for Oracle initially, and plan a phased migration to Aurora PostgreSQL
C) Use Amazon AppStream 2.0 to stream the existing Oracle Forms application
D) Rewrite the entire application as microservices from scratch

**Correct Answer: B**
**Explanation:** Option B provides a balanced modernization: (1) Modern web framework (React/Angular) replaces the outdated Oracle Forms fat-client UI; (2) API Gateway and Lambda provide a serverless API layer; (3) Lambda functions calling Oracle stored procedures via RDS Proxy preserve existing business logic while modernizing the interface; (4) QuickSight replaces Oracle Reports for analytics; (5) JasperReports on ECS handles operational reports requiring precise formatting; (6) RDS for Oracle initially maintains database compatibility; (7) Future Aurora PostgreSQL migration eliminates Oracle licensing. Option A doesn't modernize. Option C provides access but doesn't modernize the technology. Option D is too risky for 200 Forms and 100 Reports.

---

### Question 63
A large bank is migrating their core banking system and needs to maintain SWIFT connectivity for international payments. The current SWIFT infrastructure uses dedicated SWIFT hardware security modules (HSMs) and Alliance Lite2 software. They need to ensure uninterrupted SWIFT messaging during and after migration. Which architecture maintains SWIFT connectivity on AWS?

A) Deploy SWIFT Alliance Lite2 on EC2 instances with CloudHSM for hardware security, maintain SWIFT's dedicated network connectivity (SWIFTNet) through a co-location facility connected to AWS via Direct Connect, with a redundant configuration across 2 AZs for high availability and SWIFT's required business continuity compliance
B) Use Amazon SES to replace SWIFT messaging
C) Connect to SWIFT through a third-party cloud SWIFT service provider
D) Keep SWIFT infrastructure entirely on-premises with VPN connectivity to AWS

**Correct Answer: A**
**Explanation:** Option A maintains SWIFT connectivity on AWS correctly: (1) SWIFT Alliance Lite2 on EC2 provides the SWIFT messaging software in the cloud; (2) CloudHSM provides FIPS 140-2 Level 3 HSMs required by SWIFT for cryptographic key management; (3) SWIFTNet connectivity through a co-location facility (SWIFT requires connection through their certified connectivity partners) with Direct Connect to AWS; (4) Multi-AZ deployment meets SWIFT's business continuity requirements; (5) This architecture is SWIFT-compliant and has been validated by financial institutions. Option B's SES can't replace SWIFT's specialized financial messaging. Option C adds third-party dependency for critical payment infrastructure. Option D misses the migration opportunity.

---

### Question 64
A company is migrating their video surveillance system with 10,000 IP cameras to AWS for centralized monitoring. The cameras generate H.264/H.265 video streams at 2 Mbps each. The system requires: 30-day online storage for real-time playback, 1-year archival storage, video analytics (person detection, license plate recognition), and centralized monitoring console. Total bandwidth from all cameras is 20 Gbps. Which architecture handles the video surveillance requirements?

A) Stream all cameras directly to Amazon Kinesis Video Streams in a single region
B) Deploy AWS IoT Greengrass at each facility for local video buffering and analytics using Amazon Rekognition on Greengrass, stream only alert clips and metadata to the cloud via Kinesis Video Streams, use Amazon S3 for 30-day online storage with Glacier for 1-year archival, Amazon Rekognition Video for cloud-based analytics on alert clips, and Amazon Managed Grafana with Kinesis Video Streams WebRTC for the centralized monitoring console
C) Store all video on-premises with NVR (Network Video Recorder) devices and replicate to S3
D) Use Amazon IVS (Interactive Video Service) for video ingestion and playback

**Correct Answer: B**
**Explanation:** Option B addresses the bandwidth constraint: (1) 20 Gbps from all cameras can't practically be streamed to AWS continuously — Greengrass provides local buffering and processing; (2) Rekognition on Greengrass performs video analytics locally, reducing cloud bandwidth to only alert-relevant clips; (3) Kinesis Video Streams ingests the alert clips and metadata efficiently; (4) S3 provides cost-effective 30-day storage with lifecycle policies to Glacier for 1-year archival; (5) Rekognition Video performs advanced analytics on cloud-ingested clips; (6) Managed Grafana with KVS WebRTC provides the centralized monitoring console. Option A would require 20 Gbps of internet bandwidth, which is impractical. Option C doesn't leverage cloud analytics. Option D is for interactive live streaming, not surveillance.

---

### Question 65
A company is performing a mainframe COBOL-to-Java conversion using automated refactoring tools. After conversion, they discover that the generated Java code, while functionally correct, has poor performance — running 3x slower than the original COBOL. The performance degradation is primarily in batch processing loops and file I/O operations. How should the architect address the performance gap?

A) Accept the performance degradation as a trade-off of modernization
B) Rewrite the slow sections manually in optimized Java
C) Optimize the generated Java code by: replacing sequential file I/O with buffered batch operations using NIO, converting batch loops to use Java Streams with parallel processing where safe, implementing bulk database operations (batch INSERT/UPDATE) instead of row-by-row processing generated by the conversion tool, deploying on compute-optimized EC2 instances (C-series) with appropriate JVM tuning (heap size, GC algorithm), and profiling with Amazon CodeGuru Profiler to identify and address remaining hotspots
D) Run the Java code on more powerful hardware to compensate

**Correct Answer: C**
**Explanation:** Option C provides targeted performance optimization: (1) NIO-based buffered I/O replaces the sequential file operations that COBOL handles efficiently but generated Java does not; (2) Java Streams parallel processing leverages multi-core CPUs for batch loops (COBOL is inherently sequential); (3) Bulk database operations dramatically outperform row-by-row processing in Java; (4) Compute-optimized instances and JVM tuning address the runtime environment; (5) CodeGuru Profiler identifies specific bottlenecks in the generated code, enabling targeted optimization. Option A accepts unnecessary degradation. Option B's manual rewrite defeats the purpose of automated conversion. Option D's "throw hardware at it" approach is costly and doesn't address the root cause.

---

### Question 66
A government agency is migrating their classified workloads to AWS and needs to implement a security architecture that meets NIST 800-53 High Impact baseline controls. The architecture must include: boundary protection, intrusion detection, encryption of data at rest and in transit, continuous monitoring, and incident response automation. Which architecture implements these controls on AWS?

A) Standard VPC with security groups and NACLs, CloudTrail for logging
B) AWS GovCloud with: VPC with private subnets and AWS Network Firewall at VPC boundaries (boundary protection), Amazon GuardDuty and VPC Traffic Mirroring with IDS analysis for intrusion detection, KMS with CloudHSM backing for FIPS 140-2 Level 3 encryption at rest, TLS 1.2+ enforced for all in-transit data, AWS Security Hub with NIST 800-53 security standard enabled for continuous monitoring, and AWS Lambda-based automated incident response triggered by Security Hub findings
C) Commercial firewall appliances on EC2 for boundary protection, third-party IDS for intrusion detection
D) AWS Firewall Manager for all security controls

**Correct Answer: B**
**Explanation:** Option B implements the NIST 800-53 High Impact controls: (1) GovCloud provides the FedRAMP High authorized environment; (2) Network Firewall at VPC boundaries implements boundary protection (SC-7); (3) GuardDuty + VPC Traffic Mirroring provides intrusion detection (SI-4); (4) KMS with CloudHSM provides FIPS 140-2 Level 3 validated encryption (SC-28, SC-13); (5) TLS 1.2+ enforces in-transit encryption (SC-8); (6) Security Hub with NIST 800-53 standard continuously evaluates all controls (CA-7); (7) Lambda-based automated response implements incident handling (IR-4). Option A lacks the comprehensive control implementation. Option C introduces non-native components adding complexity. Option D doesn't implement all required controls.

---

### Question 67
A company is migrating from an on-premises Oracle Exadata to Amazon Redshift for their data warehousing needs. The current Exadata handles both OLTP and OLAP workloads with a single database. The migration must separate OLTP and OLAP workloads for optimal performance. How should the workloads be separated during migration?

A) Migrate everything to Redshift and handle both OLTP and OLAP
B) Use AWS SCT to analyze the Exadata workload and identify OLTP vs OLAP queries, migrate OLTP workloads to Aurora PostgreSQL (or RDS for Oracle for minimal changes), migrate OLAP workloads to Amazon Redshift, implement CDC (Change Data Capture) from Aurora to Redshift using DMS for near-real-time data synchronization, and use a Redshift Spectrum external schema pointing to S3 for historical data archival
C) Keep all workloads on a single RDS Oracle instance
D) Migrate to DynamoDB for OLTP and Athena for OLAP

**Correct Answer: B**
**Explanation:** Option B correctly separates and migrates the mixed workload: (1) SCT analysis identifies which queries/stored procedures are OLTP (short, transactional) vs OLAP (complex, analytical); (2) Aurora PostgreSQL handles the OLTP workload with ACID transactions and low latency; (3) Redshift handles the OLAP workload with columnar storage and massively parallel processing; (4) DMS CDC synchronizes data from Aurora to Redshift in near-real-time, keeping the analytical data current; (5) Redshift Spectrum provides cost-effective access to historical data in S3. This is the standard pattern for Exadata migration since Exadata's strength is handling mixed workloads on a single platform, which should be separated in the cloud. Option A can't handle OLTP on Redshift efficiently. Option C doesn't optimize for either workload. Option D requires application redesign for DynamoDB.

---

### Question 68
A company is migrating their contact center from Avaya on-premises to AWS. The contact center handles 10,000 concurrent calls, has 5,000 agents across 20 locations, and uses complex IVR (Interactive Voice Response) flows with speech recognition. They need to maintain existing phone numbers and routing logic. Which migration approach provides a cloud-native contact center?

A) Deploy Avaya on EC2 instances
B) Migrate to Amazon Connect with: existing phone numbers ported to Connect, contact flows rebuilt using Connect's visual flow builder replicating existing IVR logic, Amazon Lex for speech recognition and natural language understanding in IVR, Amazon Polly for text-to-speech responses, AWS Lambda for custom business logic within contact flows, Amazon Connect Wisdom for agent assist with real-time knowledge recommendations, and Connect's soft-phone or partner CCP (Contact Control Panel) for agents
C) Use Amazon Chime SDK for the contact center platform
D) Deploy Genesys Cloud on AWS Marketplace

**Correct Answer: B**
**Explanation:** Option B provides a comprehensive Avaya-to-Connect migration: (1) Amazon Connect is a cloud-native contact center service that handles 10,000+ concurrent calls; (2) Phone number porting preserves existing numbers; (3) Connect's visual contact flow builder recreates IVR logic; (4) Amazon Lex provides advanced speech recognition and NLU, potentially improving on the existing IVR; (5) Polly provides natural-sounding text-to-speech; (6) Lambda enables custom integrations within contact flows (CRM lookups, database queries); (7) Connect Wisdom provides AI-powered agent assistance; (8) Connect's pay-per-use pricing eliminates hardware costs. Option A doesn't modernize. Option C's Chime SDK is for communications APIs, not a full contact center. Option D introduces third-party licensing.

---

### Question 69
A company is modernizing their legacy message-driven architecture built on IBM WebSphere MQ and wants to adopt event-driven patterns on AWS. The current architecture uses 200 queue definitions, point-to-point messaging for command operations, and pub/sub for event notifications. Message ordering is required for financial transactions. Which migration approach converts the queue-based architecture to event-driven?

A) Replace all MQ queues with Amazon SQS queues one-to-one
B) Redesign the architecture: replace point-to-point command queues with Amazon SQS FIFO queues (maintaining message ordering for financial transactions), replace pub/sub messaging with Amazon EventBridge for event-driven notifications with content-based routing, implement event schemas in EventBridge Schema Registry, use AWS Step Functions for complex message processing workflows that previously used message correlation, and deploy Amazon MQ (ActiveMQ) as a bridge for applications that can't be immediately changed
C) Use Amazon Kinesis Data Streams for all messaging
D) Deploy Amazon MQ (RabbitMQ) as a complete replacement for WebSphere MQ

**Correct Answer: B**
**Explanation:** Option B provides a thoughtful migration from queue-based to event-driven: (1) SQS FIFO queues replace point-to-point command queues with guaranteed ordering (critical for financial transactions); (2) EventBridge replaces pub/sub with richer event routing capabilities (content-based filtering, multiple targets); (3) Schema Registry provides governance for event formats; (4) Step Functions replace complex message correlation patterns with visual workflows; (5) Amazon MQ as a bridge enables incremental migration — applications that can't be changed immediately continue using JMS/AMQP. Option A just replicates queues without modernizing to event-driven. Option C's Kinesis is for streaming, not request/response messaging. Option D maintains queue-based architecture without event-driven modernization.

---

### Question 70
A company is migrating their on-premises Hadoop ecosystem (including Hive, Spark, HBase, and Oozie) to AWS. The cluster has 200 nodes, 2PB of HDFS data, and supports both batch and interactive workloads. They want to reduce costs by 60% while maintaining all capabilities. Which architecture achieves the cost reduction target?

A) Deploy a permanent 200-node EMR cluster replicating the on-premises setup
B) Decouple storage and compute: migrate HDFS to S3 (eliminating 3x replication overhead, saving 4PB of storage), replace permanent cluster with transient EMR clusters for Spark batch jobs (auto-terminated after completion), use EMR with persistent Hive metastore (Glue Data Catalog) for interactive Hive queries on a smaller always-on cluster, migrate HBase to Amazon HBase on EMR (or DynamoDB if access patterns allow), replace Oozie with Step Functions or MWAA for workflow orchestration, and use Spot instances for 90%+ of EMR compute
C) Use Athena for all Hive queries and eliminate EMR
D) Migrate to Amazon Redshift for all data processing

**Correct Answer: B**
**Explanation:** Option B achieves 60%+ cost reduction through multiple optimizations: (1) S3 replaces HDFS, eliminating 3x replication (2PB stored once vs 6PB), saving significant storage costs; (2) Transient EMR clusters for batch processing pay only for compute during actual processing, not 24/7; (3) Spot instances provide 60-90% discounts on compute; (4) Smaller always-on cluster for interactive queries costs less than 200 permanent nodes; (5) Glue Data Catalog provides a free, persistent Hive metastore; (6) Step Functions/MWAA replace Oozie without dedicated infrastructure. Combined savings: storage (~67% reduction), compute (~80% reduction with transient + Spot) = well over 60% total. Option A replicates costs without optimization. Option C can't handle all Spark/HBase workloads. Option D doesn't support all Hadoop ecosystem capabilities.

---

### Question 71
A company is migrating their SAP environment and needs to implement backups that meet SAP's certification requirements. The SAP HANA database is 4TB and requires point-in-time recovery capability. SAP Application servers need daily backups. What is the SAP-certified backup approach on AWS?

A) EBS snapshots only for all SAP components
B) For SAP HANA: AWS Backint Agent for SAP HANA for database-consistent backups directly to S3 with point-in-time recovery using HANA log backups, automated backup scheduling through SAP HANA cockpit or AWS Backup with SAP HANA support. For SAP Application Servers: AWS Backup for EC2 instance-level backups with daily scheduling and retention policies. Cross-region backup copy for DR compliance.
C) Third-party backup software on EC2 for all SAP backups
D) SAP HANA native backup to local disk with periodic S3 upload

**Correct Answer: B**
**Explanation:** Option B provides SAP-certified backup architecture: (1) AWS Backint Agent for SAP HANA is SAP-certified for HANA database backup directly to S3; (2) Backint integration provides database-consistent backups through SAP's backup framework; (3) HANA log backups to S3 enable point-in-time recovery to any second; (4) AWS Backup now supports SAP HANA for centralized backup management; (5) EC2 instance-level backups via AWS Backup handle application server backup; (6) Cross-region copy provides geographic protection. Option A's EBS snapshots aren't SAP-certified for HANA database consistency. Option C adds unnecessary third-party cost. Option D's local disk approach doesn't protect against instance failure.

---

### Question 72
A company is modernizing their legacy batch processing system that currently processes 1TB of data nightly in a sequential batch pipeline with 100 steps. Each step depends on the previous step's output. The total processing time is 8 hours, and the business wants to reduce it to 2 hours. The processing logic is in stored procedures and shell scripts. Which modernization approach achieves the 4x performance improvement?

A) Rewrite all 100 steps as Lambda functions chained by SQS
B) Analyze the 100-step pipeline for parallelization opportunities: identify steps that can run in parallel (typically after a fan-out step), implement using AWS Step Functions with Parallel states for independent steps and sequential Task states for dependent steps, convert stored procedures to Glue PySpark jobs for data-intensive steps (leveraging parallel processing), use Lambda for lightweight transformation steps, use S3 for inter-step data passing (replacing sequential file-based communication), and right-size each step's compute independently
C) Run the same batch pipeline on a larger EC2 instance
D) Use Amazon Redshift stored procedures to replace the entire pipeline

**Correct Answer: B**
**Explanation:** Option B achieves the 4x improvement through parallelization and right-sizing: (1) Analyzing the 100-step DAG identifies which steps can run in parallel — a typical 100-step pipeline often has 3-5 levels of depth when parallel paths are identified; (2) Step Functions orchestrates both parallel and sequential execution with visual monitoring; (3) Glue PySpark jobs distribute data processing across multiple workers for data-intensive steps; (4) Lambda handles lightweight steps with instant scaling; (5) S3 for inter-step data enables any step to read from multiple predecessors' outputs; (6) Independent compute sizing prevents bottlenecks (some steps need more CPU, others more memory). Option A's Lambda chain doesn't enable parallelization. Option C doesn't address the sequential bottleneck. Option D requires complete rewrite and Redshift may not support all processing types.

---

### Question 73
A company has a complex Active Directory forest with 5 domains serving 50,000 users. They're migrating to AWS and need to maintain AD functionality for both on-premises (during transition) and AWS workloads. The AD includes: Group Policy Objects (GPOs), DNS zones, DHCP scopes, certificate services (AD CS), and custom AD schema extensions. Which AD architecture supports the hybrid transition?

A) Deploy AD Connector for all AWS workloads
B) Deploy AWS Managed Microsoft AD as a new forest with a two-way trust to the on-premises forest, maintain on-premises domain controllers during transition, extend critical GPOs to AWS using Managed AD group policy management, migrate DNS zones to Route 53 Resolver with conditional forwarding rules, replace on-premises DHCP with VPC DHCP option sets, deploy ACM Private CA to replace on-premises AD CS functionality, and support custom schema extensions through Managed AD's schema management
C) Extend all 5 on-premises domain controllers to EC2 instances
D) Replace Active Directory with Amazon Cognito for all authentication

**Correct Answer: B**
**Explanation:** Option B provides comprehensive AD transition: (1) Managed AD with two-way trust enables bidirectional authentication between on-premises and AWS; (2) GPO management in Managed AD applies policies to AWS-joined resources; (3) Route 53 Resolver with conditional forwarding handles DNS resolution between on-premises and AWS; (4) VPC DHCP option sets replace DHCP scopes for AWS resources; (5) ACM Private CA replaces AD CS for certificate management; (6) Managed AD supports custom schema extensions; (7) During transition, both environments coexist through the trust relationship. Option A's AD Connector only proxies requests, doesn't provide GPO or DNS. Option C requires managing 5 EC2-based domain controllers. Option D can't replace AD's full functionality (GPOs, schema extensions).

---

### Question 74
A company is performing a phased migration of their data center and needs to implement a hybrid DNS solution. On-premises applications need to resolve AWS private DNS names, and AWS applications need to resolve on-premises DNS names. The on-premises DNS is Microsoft DNS integrated with Active Directory. The AWS environment has multiple VPCs with private hosted zones. Which DNS architecture provides seamless resolution across environments?

A) Manually configure DNS servers to forward requests between environments
B) Deploy Route 53 Resolver with: inbound endpoints in the hub VPC (for on-premises to AWS resolution) receiving DNS queries from on-premises DNS servers forwarded via conditional forwarders, outbound endpoints (for AWS to on-premises resolution) with forwarding rules for on-premises domain zones, Route 53 private hosted zones associated with all VPCs for AWS service discovery, VPC DNS resolution enabled in all VPCs, and Transit Gateway for network connectivity supporting DNS traffic between VPCs and on-premises
C) Deploy a BIND DNS server on EC2 for all DNS resolution
D) Use Route 53 public hosted zones for all DNS records

**Correct Answer: B**
**Explanation:** Option B provides enterprise-grade hybrid DNS: (1) Route 53 Resolver inbound endpoints accept DNS queries from on-premises, enabling on-premises applications to resolve AWS private DNS names; (2) Outbound endpoints with forwarding rules send queries for on-premises domains to on-premises DNS servers; (3) Private hosted zones provide AWS service discovery; (4) On-premises Microsoft DNS conditional forwarders point to the inbound endpoint IPs; (5) Transit Gateway enables DNS query traffic to flow between VPCs and on-premises; (6) This is the AWS-recommended hybrid DNS architecture. Option A requires manual configuration that doesn't scale. Option C adds operational overhead of managing BIND. Option D exposes internal DNS records publicly.

---

### Question 75
A company has completed migrating 3,000 servers to AWS and now needs to optimize the post-migration environment. Initial migration used 1:1 server-to-EC2 mapping without right-sizing. Monthly costs are 40% higher than expected. Which post-migration optimization strategy provides the MOST significant cost reduction?

A) Apply Reserved Instances for all EC2 instances
B) Implement a comprehensive optimization program: (1) Right-sizing — use AWS Compute Optimizer to identify over-provisioned instances and downsize (typically 30-40% of migrated instances are over-provisioned); (2) Purchasing strategy — Reserved Instances or Savings Plans for steady-state workloads, Spot instances for fault-tolerant workloads; (3) Storage optimization — use EBS volume type optimization (gp3 vs gp2, delete unused volumes); (4) Scheduling — implement AWS Instance Scheduler for non-production environments (stop instances outside business hours); (5) Architecture optimization — identify candidates for managed services (RDS, ElastiCache) or serverless (Lambda); and track savings using AWS Cost Explorer and budgets
C) Negotiate a larger Enterprise Discount Program with AWS
D) Move all workloads to the cheapest instance type (t3.micro)

**Correct Answer: B**
**Explanation:** Option B provides systematic cost optimization: (1) Compute Optimizer analyzes utilization and recommends right-sized instances — typically yields 20-30% savings; (2) RI/Savings Plans for steady workloads saves 30-72% vs on-demand; (3) EBS optimization (gp2→gp3 saves 20%, deleting unused volumes eliminates waste); (4) Instance Scheduler for dev/test environments stops instances during off-hours, saving 65% for those instances; (5) Managed services reduce operational overhead and often reduce costs; (6) Combined, these optimizations typically achieve 40-60% cost reduction. Option A applies RI without right-sizing first, potentially locking in over-provisioned instances. Option C doesn't address the architectural inefficiency. Option D would break applications with insufficient resources.

---

## Answer Key

| Q# | Answer | Q# | Answer | Q# | Answer | Q# | Answer | Q# | Answer |
|----|--------|----|--------|----|--------|----|--------|----|--------|
| 1  | B      | 16 | B      | 31 | B      | 46 | B      | 61 | B      |
| 2  | D      | 17 | C      | 32 | B      | 47 | B      | 62 | B      |
| 3  | B      | 18 | A      | 33 | B      | 48 | B      | 63 | A      |
| 4  | B      | 19 | B      | 34 | B      | 49 | B      | 64 | B      |
| 5  | B      | 20 | B      | 35 | C      | 50 | B      | 65 | C      |
| 6  | B      | 21 | A      | 36 | C      | 51 | B      | 66 | B      |
| 7  | B      | 22 | B      | 37 | B      | 52 | A      | 67 | B      |
| 8  | B      | 23 | A      | 38 | B      | 53 | B      | 68 | B      |
| 9  | B      | 24 | B      | 39 | B      | 54 | B      | 69 | B      |
| 10 | B      | 25 | B      | 40 | B      | 55 | B      | 70 | B      |
| 11 | C      | 26 | C      | 41 | A      | 56 | B      | 71 | B      |
| 12 | B      | 27 | B      | 42 | B      | 57 | B      | 72 | B      |
| 13 | B      | 28 | A      | 43 | A      | 58 | B      | 73 | B      |
| 14 | A      | 29 | B      | 44 | B      | 59 | B      | 74 | B      |
| 15 | B      | 30 | C      | 45 | B      | 60 | B      | 75 | B      |
