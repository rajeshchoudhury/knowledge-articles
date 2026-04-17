# Practice Exam 20 - AWS Solutions Architect Associate (SAA-C03)

## Focus: Migration & Hybrid Architectures

## Instructions
- **Total Questions:** 65
- **Time Limit:** 130 minutes
- **Question Types:** Mix of multiple choice (1 correct answer) and multiple response (2 or more correct answers)
- **Passing Score:** 720/1000
- **Domains Covered:**
  - Domain 1: Design Secure Architectures (~20 questions)
  - Domain 2: Design Resilient Architectures (~17 questions)
  - Domain 3: Design High-Performing Architectures (~16 questions)
  - Domain 4: Design Cost-Optimized Architectures (~12 questions)

> Multiple response questions are clearly marked with "Select TWO" or "Select THREE." All other questions have exactly one correct answer.

---

### Question 1
A large retail company is planning to migrate 200 on-premises virtual machines to AWS. The company wants to perform a lift-and-shift migration with minimal changes to the applications. The migration must include automated testing to verify that applications work correctly on AWS before cutover. The company needs to minimize downtime during the migration.

Which migration service should a solutions architect recommend?

A) AWS Server Migration Service (SMS) to replicate VMs to AWS as AMIs  
B) AWS Application Migration Service (AWS MGN) to perform continuous block-level replication and automated launch testing  
C) VM Import/Export to convert VM images to AMIs and launch EC2 instances  
D) AWS DataSync to transfer the VM disk images to S3 and create AMIs from the images  

---

### Question 2
A manufacturing company has a 50 TB Oracle database running on-premises. The company wants to migrate the database to Amazon Aurora PostgreSQL. The database must remain operational during the migration with less than 1 hour of downtime for cutover. The database receives approximately 500 write transactions per second.

Which migration approach should a solutions architect recommend?

A) Use AWS DMS with a full load task to migrate all data, then perform a cutover when complete  
B) Use AWS Schema Conversion Tool (SCT) to convert the schema, then use AWS DMS with full load plus change data capture (CDC) for continuous replication until cutover  
C) Export the Oracle database to CSV files, upload to S3, and import into Aurora PostgreSQL using the aws_s3 extension  
D) Use a native Oracle Data Pump export, transfer to S3 via AWS Snowball, and restore into Aurora PostgreSQL  

---

### Question 3
A financial services company has 500 TB of data in an on-premises data center. The company has a 1 Gbps internet connection and needs to transfer all data to Amazon S3 within 4 weeks. The data includes historical transaction records that are accessed infrequently once migrated but must be available within hours if needed.

Which combination of solutions should a solutions architect recommend? (Select TWO.)

A) Use AWS Snowball Edge devices to transfer the data to S3, ordering multiple devices in parallel  
B) Transfer data over the 1 Gbps internet connection using AWS DataSync  
C) Set up a 10 Gbps AWS Direct Connect connection for the data transfer  
D) Store the migrated data in S3 Glacier Flexible Retrieval storage class  
E) Store the migrated data in S3 Standard-Infrequent Access storage class  

---

### Question 4
A healthcare company has on-premises file servers that store medical images. Clinicians need to access recent images (last 30 days) with low latency from on-premises systems, while older images can be stored in AWS with retrieval times of up to several hours. The company wants to reduce on-premises storage costs while keeping the solution transparent to end users.

Which solution should a solutions architect recommend?

A) Deploy AWS Storage Gateway File Gateway on-premises to store all files in S3, with local caching for frequently accessed files and S3 lifecycle policies to move older data to S3 Glacier  
B) Use AWS DataSync to continuously replicate all files to S3 and delete on-premises copies older than 30 days  
C) Deploy a NetApp Cloud Volumes ONTAP instance in AWS and configure cross-site replication  
D) Use Amazon FSx for Windows File Server with a nightly backup of on-premises files  

---

### Question 5
A company has established a hybrid network connectivity between its on-premises data center and AWS using a single AWS Direct Connect connection. The network team is concerned about the reliability of the connection. If the Direct Connect link fails, the company needs a backup path that can be established quickly and provide reasonable bandwidth.

Which backup connectivity approach is MOST cost-effective while meeting reliability requirements?

A) Provision a second Direct Connect connection through a different Direct Connect location  
B) Configure a site-to-site VPN connection over the internet as a backup, with BGP routing to enable automatic failover  
C) Use AWS CloudHub to connect multiple on-premises sites for redundancy  
D) Deploy AWS Direct Connect Gateway with multiple virtual interfaces for redundancy  

---

### Question 6
A company is running Active Directory (AD) on-premises for user authentication. The company is migrating workloads to AWS and needs AWS-hosted EC2 instances to join the on-premises AD domain. The company also wants to use the same AD credentials for AWS Management Console access. The network between on-premises and AWS uses Direct Connect.

Which combination of solutions should a solutions architect recommend? (Select TWO.)

A) Deploy AWS Managed Microsoft AD in the AWS VPC and establish a two-way trust relationship with the on-premises AD  
B) Deploy AD Connector in the AWS VPC to proxy authentication requests to the on-premises AD  
C) Configure AWS IAM Identity Center (SSO) with the AD source for AWS Management Console access  
D) Create individual IAM users for each AD user and synchronize passwords using a custom Lambda function  
E) Install a domain controller on an EC2 instance and manually configure replication with on-premises AD  

---

### Question 7
A company has on-premises applications that resolve internal DNS names for both on-premises and AWS resources. The company has migrated several applications to AWS VPCs. On-premises applications need to resolve DNS names of resources in AWS VPCs, and AWS applications need to resolve DNS names of on-premises resources. The company uses a private hosted zone in Route 53 for AWS resources.

Which solution enables bidirectional DNS resolution?

A) Configure Route 53 Resolver with inbound endpoints (for on-premises to resolve AWS DNS) and outbound endpoints (for AWS to resolve on-premises DNS) with forwarding rules  
B) Deploy a custom DNS server on EC2 in the VPC that forwards queries between on-premises DNS and Route 53  
C) Configure the VPC DHCP options set to point to the on-premises DNS servers  
D) Use Route 53 public hosted zones for all resources and configure on-premises DNS to forward to Route 53 public endpoints  

---

### Question 8
A media company has 200 TB of video content stored on-premises on NFS file servers. The company wants to make this content accessible from both on-premises production systems and AWS-based transcoding workloads. The solution must provide a unified namespace and avoid storing duplicate copies of the full dataset in both locations.

Which solution should a solutions architect recommend?

A) Use AWS DataSync to copy all content to Amazon S3 and access from both locations  
B) Deploy AWS Storage Gateway File Gateway on-premises to present an NFS mount backed by S3, and access the same S3 bucket from AWS workloads  
C) Use Amazon FSx for Lustre linked to an S3 bucket with DataSync for initial migration  
D) Set up a third-party NFS server on EC2 and replicate data from on-premises using rsync  

---

### Question 9
A company is migrating a three-tier web application from on-premises to AWS. The application consists of web servers, application servers, and a MySQL database. The company wants to re-platform the database to a managed service while keeping the web and application tiers on EC2 instances initially. The database has stored procedures and triggers that must continue to work.

Which database migration target should a solutions architect recommend?

A) Amazon Aurora MySQL with full compatibility for MySQL stored procedures and triggers  
B) Amazon DynamoDB with Lambda functions replacing stored procedures  
C) Amazon RDS for PostgreSQL with manually converted stored procedures  
D) Amazon Redshift for both transactional and analytical workloads  

---

### Question 10
A global insurance company has 5,000 VMware virtual machines across three data centers. The company wants to assess all workloads before migration, identify dependencies between servers, and create migration wave plans. The company needs right-sizing recommendations for EC2 instance types.

Which combination of AWS services should the solutions architect use for migration planning? (Select TWO.)

A) AWS Application Discovery Service with Agentless Collector for VMware environments to discover server configurations and dependencies  
B) AWS Migration Hub to centralize migration tracking and create wave plans based on discovered dependencies  
C) AWS Trusted Advisor to recommend EC2 instance types for each workload  
D) Amazon Inspector to scan on-premises servers for migration compatibility  
E) AWS Cost Explorer to estimate monthly costs for each migrated server  

---

### Question 11
A company operates a data center with 100 physical servers. The company plans to migrate to AWS over the next 18 months. During the migration period, some applications will run on-premises while others run on AWS. Applications in both environments need to communicate with low latency and consistent network performance. The company expects to transfer 50 TB of data per month between environments.

Which networking solution should a solutions architect recommend?

A) Use multiple site-to-site VPN connections bonded together for higher bandwidth  
B) Establish a 10 Gbps AWS Direct Connect dedicated connection with a private virtual interface  
C) Use AWS Transit Gateway with VPN attachments for all cross-environment communication  
D) Set up AWS PrivateLink endpoints for each application that needs cross-environment access  

---

### Question 12
A company has a legacy mainframe application that processes batch transactions. The company wants to modernize the application incrementally while keeping the mainframe operational during the transition. The batch processing logic is in COBOL programs and the data is stored in VSAM files.

Which modernization approach should a solutions architect recommend as the FIRST step?

A) Rewrite the entire COBOL application in Java and deploy on Amazon ECS  
B) Use AWS Mainframe Modernization service with the automated refactoring pattern to convert COBOL to Java, or the re-platform pattern to run COBOL workloads in a managed runtime on AWS  
C) Migrate the VSAM data to DynamoDB and update the COBOL programs to use DynamoDB API calls  
D) Use AWS Lambda to replace individual COBOL batch programs one at a time  

---

### Question 13
A company runs Docker containers on-premises using Docker Compose for orchestration. The containers run a microservices application with 15 services. The company wants to migrate to AWS with minimal changes to the container images. The team wants a managed orchestration platform but does not have Kubernetes expertise.

Which migration target should a solutions architect recommend?

A) Amazon ECS with Fargate launch type, using ECS task definitions translated from Docker Compose files  
B) Amazon EKS with managed node groups and Helm charts for deployment  
C) Deploy containers directly on EC2 instances using Docker Compose  
D) Use AWS App Runner for all 15 microservices  

---

### Question 14
A company has a 10 TB PostgreSQL database running on-premises that needs to be migrated to Amazon RDS for PostgreSQL. The company can tolerate up to 4 hours of downtime for the migration. The database has large objects (LOBs) averaging 50 MB each.

Which migration approach is MOST straightforward?

A) Use pg_dump and pg_restore to perform a full database backup and restore to RDS PostgreSQL  
B) Use AWS DMS with full load migration and configure the LOB settings to handle large objects  
C) Use AWS SCT to extract data to S3 and load into RDS using the aws_s3 extension  
D) Set up native PostgreSQL logical replication between on-premises and RDS PostgreSQL  

---

### Question 15
A company has a 200 TB data warehouse running on Oracle Exadata on-premises. The company wants to migrate to Amazon Redshift. The data must be transferred within 2 weeks. After migration, the company needs to verify data integrity by comparing row counts and checksums between source and target.

Which migration approach should a solutions architect recommend?

A) Use AWS DMS with a Redshift target endpoint and full load task for the migration, with DMS data validation for integrity verification  
B) Export Oracle data to flat files, ship them using AWS Snowball, and use the COPY command to load into Redshift  
C) Use AWS Glue to read from Oracle and write to Redshift  
D) Use Amazon Kinesis Data Firehose to stream data from Oracle to Redshift  

---

### Question 16
A company is performing a phased migration of on-premises applications to AWS. During Phase 1, the on-premises Oracle database will remain on-premises while the application tier moves to EC2 in AWS. The application servers need to connect to the on-premises Oracle database securely with low latency. In Phase 2, the database will be migrated to AWS.

Which solution provides secure, low-latency connectivity during Phase 1?

A) Configure the application on EC2 to connect to the on-premises Oracle database over a site-to-site VPN connection  
B) Establish an AWS Direct Connect connection with a private virtual interface to the VPC, enabling direct connectivity to the on-premises database over a private network  
C) Expose the Oracle database through a public endpoint and secure it with SSL/TLS  
D) Replicate the Oracle database to RDS using DMS to eliminate the cross-network dependency during Phase 1  

---

### Question 17
A company is migrating an on-premises Windows application that uses an SMB file share. The application servers will be migrated to EC2 instances. The company needs a fully managed Windows-compatible file system with Active Directory integration for access control. The file system must support multi-AZ deployment for high availability.

Which solution should a solutions architect recommend?

A) Amazon FSx for Windows File Server configured as a Multi-AZ deployment with AD integration  
B) Amazon EFS mounted on Windows EC2 instances using an NFS client  
C) Amazon S3 with a Storage Gateway File Gateway providing SMB access  
D) Amazon EBS volumes shared between EC2 instances using multi-attach  

---

### Question 18
A company has a 500 TB data lake on-premises stored across HDFS clusters. The company wants to migrate the data lake to Amazon S3 and continue using Apache Spark workloads. The migration must be completed within 6 weeks. The company has a 10 Gbps Direct Connect connection already established.

Which migration approach should a solutions architect recommend?

A) Use AWS DataSync to transfer data from the HDFS cluster to S3 over the Direct Connect connection  
B) Use the S3 DistCp (distributed copy) tool from the existing Hadoop cluster to copy data to S3 over Direct Connect  
C) Order multiple AWS Snowball Edge devices to physically ship the data  
D) Use AWS Transfer Family to SFTP data from on-premises to S3  

---

### Question 19
A global retail company is migrating its e-commerce platform to AWS. The migration must follow a phased approach over 12 months. The company has identified 500 servers grouped into 50 application stacks. Dependencies between application stacks have been mapped. The company needs to track migration progress across all application stacks and teams.

Which AWS service provides centralized migration tracking and orchestration?

A) AWS CloudFormation StackSets for deploying resources across accounts  
B) AWS Migration Hub for centralized migration tracking with integration to AWS MGN and DMS  
C) AWS Service Catalog for standardized resource provisioning  
D) AWS Organizations for managing migration across multiple accounts  

---

### Question 20
A company has an on-premises Oracle database with 2 TB of data and uses Oracle-specific features including materialized views, database links, and Oracle Text. The company wants to migrate to a managed AWS database service and is willing to refactor the application to remove Oracle-specific dependencies.

Which combination of steps should a solutions architect recommend for the database migration? (Select TWO.)

A) Use AWS Schema Conversion Tool (SCT) to analyze the Oracle schema, identify incompatible features, and generate a conversion report showing what requires manual remediation  
B) Use AWS DMS to migrate the data with schema conversion handled automatically during the data migration  
C) Migrate to Amazon Aurora PostgreSQL using DMS for data migration after remediating the schema conversion issues identified by SCT  
D) Migrate to Amazon RDS for Oracle to avoid any schema changes  
E) Use Amazon Neptune for the database since it supports complex relationships like database links  

---

### Question 21
A company has a 1 Gbps internet connection to their on-premises data center. They need to perform an initial bulk transfer of 80 TB to AWS S3, followed by ongoing daily incremental transfers of approximately 500 GB. The initial transfer must be completed within 2 weeks.

Which combination of solutions should a solutions architect recommend? (Select TWO.)

A) Use AWS Snowball for the initial 80 TB bulk transfer  
B) Transfer the initial 80 TB over the internet connection using AWS DataSync  
C) Use AWS DataSync over the internet for ongoing daily 500 GB incremental transfers  
D) Use AWS Snowball for ongoing daily transfers  
E) Set up AWS Direct Connect for the ongoing daily transfers  

---

### Question 22
A company operates an on-premises VMware vSphere environment. The company wants to extend its VMware workloads to AWS without changing the VMware tools and processes their operations team uses. Some workloads should run in AWS for disaster recovery, while others need burst capacity during peak periods.

Which solution should a solutions architect recommend?

A) Use VM Import/Export to convert VMware VMs to AMIs and run them on EC2  
B) Use VMware Cloud on AWS to run VMware workloads natively on AWS infrastructure with vCenter management  
C) Install ESXi on EC2 bare metal instances and manually manage the VMware environment  
D) Use AWS Application Migration Service to migrate VMware VMs to EC2 instances  

---

### Question 23
A company is migrating a legacy application that uses a shared Oracle database accessed by multiple application teams. Different teams need different columns from the same large tables. After migration, the company wants to provide each team with access to only their relevant data in near-real-time.

Which approach should a solutions architect recommend?

A) Migrate the Oracle database to Aurora PostgreSQL and create database views for each team  
B) Use AWS DMS with table and column mapping to create separate target tables in different databases for each team  
C) Migrate to Aurora PostgreSQL and use DMS CDC to replicate relevant subsets of data to separate DynamoDB tables per team  
D) Export team-specific data to S3 and let each team query their data using Amazon Athena  

---

### Question 24
A company wants to set up a disaster recovery solution for their on-premises applications. The company has an RPO of 1 hour and an RTO of 4 hours. The on-premises environment consists of 50 servers running various Linux and Windows workloads. The DR solution must be cost-effective during normal operations.

Which disaster recovery strategy should a solutions architect recommend?

A) Pilot light — keep critical core infrastructure running in AWS (database replicas) and use AWS MGN for continuous server replication, launching full infrastructure only during a DR event  
B) Multi-site active-active — run the full application stack in both on-premises and AWS simultaneously  
C) Backup and restore — take daily backups of all servers and store them in S3, restore from backups during a DR event  
D) Warm standby — maintain a scaled-down but fully functional copy of the environment running in AWS at all times  

---

### Question 25
A company has an on-premises tape backup system that stores 500 TB of archived data. The company wants to eliminate the physical tape infrastructure and move the archive to AWS. The backup software currently writes to tape libraries using the iSCSI protocol. The company wants to minimize changes to their existing backup processes.

Which solution should a solutions architect recommend?

A) Use AWS Storage Gateway Tape Gateway to present virtual tape libraries (VTL) to the backup software via iSCSI, storing virtual tapes in S3 and archiving to S3 Glacier  
B) Use AWS DataSync to transfer tape contents to S3 Glacier  
C) Use AWS Snowball to ship the tape data to S3 and configure S3 lifecycle policies for archiving  
D) Set up an NFS mount point using Storage Gateway File Gateway and reconfigure the backup software to write to NFS  

---

### Question 26
A company is performing a database migration from on-premises SQL Server to Amazon Aurora MySQL. The company wants to minimize application changes during the migration. The SQL Server database uses T-SQL stored procedures, SSIS packages for ETL, and SQL Server Reporting Services (SSRS).

Which combination of actions should a solutions architect recommend? (Select TWO.)

A) Use AWS SCT to convert T-SQL stored procedures to MySQL-compatible syntax and generate an assessment report for items requiring manual conversion  
B) Replace SSIS packages with AWS Glue ETL jobs for data transformation  
C) Migrate to Amazon RDS for SQL Server instead to avoid application changes  
D) Use AWS DMS to migrate the data with automatic stored procedure conversion  
E) Rebuild SSRS reports using Amazon QuickSight  

---

### Question 27
A company has a hybrid architecture where on-premises applications send messages to applications running on AWS. The messaging system must support point-to-point and publish-subscribe patterns, work with existing JMS (Java Message Service) client libraries, and operate across the hybrid network.

Which AWS messaging service should a solutions architect recommend?

A) Amazon SQS for point-to-point and Amazon SNS for publish-subscribe  
B) Amazon MQ with an ActiveMQ or RabbitMQ broker configured with network of brokers spanning on-premises and AWS  
C) Amazon Kinesis Data Streams for all messaging patterns  
D) Amazon EventBridge for event-driven messaging between on-premises and AWS  

---

### Question 28
A company is migrating 50 databases of various engines (MySQL, PostgreSQL, SQL Server, and Oracle) to AWS managed database services. The company wants to use a single migration tool that supports all source and target engines. Some databases are homogeneous migrations (same engine) and others are heterogeneous (different engine).

Which approach should a solutions architect take?

A) Use AWS DMS for all migrations — for homogeneous migrations, DMS handles both schema and data. For heterogeneous migrations, use AWS SCT first for schema conversion, then DMS for data migration  
B) Use native database tools (mysqldump, pg_dump, etc.) for homogeneous migrations and DMS only for heterogeneous migrations  
C) Use AWS DMS for all migrations without any schema conversion tool  
D) Use AWS Glue for all database migrations as it supports all database engines  

---

### Question 29
A company is planning to migrate a legacy application that uses Windows file shares and depends on NTFS permissions, shadow copies, and DFS namespaces. The application must run on EC2 instances after migration. The file system must support these Windows-native features.

Which storage solution should a solutions architect recommend?

A) Amazon FSx for Windows File Server, which natively supports NTFS permissions, shadow copies, and DFS namespaces  
B) Amazon EFS with Windows-compatible mode enabled  
C) Amazon S3 with Storage Gateway File Gateway configured for SMB access  
D) Amazon EBS volumes with NTFS formatted file systems attached to each EC2 instance  

---

### Question 30
A company is migrating an on-premises Hadoop cluster (100 nodes) with 500 TB of data in HDFS. The company uses Apache Hive for SQL queries, Apache Spark for data processing, and Apache HBase for NoSQL storage. The company wants to minimize re-engineering while moving to managed AWS services.

Which combination of target services should a solutions architect recommend? (Select THREE.)

A) Amazon EMR for Apache Spark and Apache Hive workloads  
B) Amazon S3 as the replacement for HDFS storage  
C) Amazon DynamoDB as the replacement for Apache HBase  
D) Amazon Redshift as the replacement for Apache Hive  
E) Amazon EBS volumes as the replacement for HDFS storage  
F) Amazon Kinesis as the replacement for Apache HBase  

---

### Question 31
A company has a Direct Connect connection that handles production traffic between on-premises and AWS. The company needs to add a backup connection that activates automatically when the primary Direct Connect link fails. The backup must be operational within minutes and the company wants to minimize ongoing costs.

Which backup solution should a solutions architect recommend?

A) A second Direct Connect connection at the same Direct Connect location  
B) AWS Site-to-Site VPN over the internet configured as a backup with lower BGP priority than Direct Connect  
C) AWS CloudFront as a proxy for on-premises to AWS traffic during outages  
D) AWS Global Accelerator to route traffic when Direct Connect fails  

---

### Question 32
A logistics company is migrating its fleet management system from on-premises to AWS. The system includes a PostgreSQL database (5 TB), a Redis cache cluster, application servers, and a real-time GPS tracking component. The company wants to minimize downtime and migrate components in the correct dependency order.

Which migration sequence should a solutions architect recommend?

A) Migrate the application servers first, then the database, then Redis, and finally the GPS tracking component  
B) Migrate the database first using DMS with CDC, then the Redis cache, then the application servers, and finally switch DNS to point to AWS  
C) Migrate all components simultaneously using AWS MGN for servers and DMS for the database  
D) Migrate the GPS tracking component first as it is the most critical  

---

### Question 33
A company has an on-premises application that generates 100 GB of log data daily. The logs are analyzed using Elasticsearch and Kibana. The company wants to migrate the logging infrastructure to AWS while maintaining the same analysis tools. The company also needs 90 days of hot storage and 365 days of warm storage for compliance.

Which solution should a solutions architect recommend?

A) Amazon OpenSearch Service with UltraWarm storage for warm data and hot nodes for recent data, with index lifecycle management policies  
B) Amazon CloudWatch Logs with Logs Insights for analysis  
C) Amazon S3 with Amazon Athena for log analysis  
D) Amazon Kinesis Data Analytics for real-time log analysis  

---

### Question 34
A company operates a multi-tier application on-premises with strict compliance requirements. All data must be encrypted in transit and at rest. During migration to AWS, the company needs to ensure that data transferred between on-premises and AWS is encrypted, and all data stored in AWS is encrypted using customer-managed keys.

Which combination of solutions ensures encryption compliance? (Select TWO.)

A) Use AWS Direct Connect with MACsec encryption or Site-to-Site VPN (IPsec) for encrypting data in transit between on-premises and AWS  
B) Use AWS KMS customer-managed keys (CMKs) for encrypting EBS volumes, S3 buckets, RDS instances, and other storage services  
C) Use SSL/TLS certificates on application load balancers for encrypting data in transit  
D) Enable AWS CloudTrail to encrypt all data in transit automatically  
E) Use AWS Certificate Manager to encrypt data at rest in S3  

---

### Question 35
A company is migrating a Windows-based application that uses Microsoft SQL Server with Always On Availability Groups for high availability. The company wants an equivalent high-availability setup on AWS with automatic failover and minimal management overhead.

Which solution should a solutions architect recommend?

A) Amazon RDS for SQL Server Multi-AZ deployment with automatic failover  
B) SQL Server on EC2 instances with Always On Availability Groups configured across multiple AZs  
C) Amazon Aurora MySQL with Multi-AZ replicas  
D) Amazon RDS for SQL Server with read replicas for high availability  

---

### Question 36
A company is migrating a large enterprise application with 200 servers and 30 databases. The company wants to automate the migration process and track the status of each server and database migration. Multiple teams are working on different application groups simultaneously.

Which combination of AWS services provides centralized automation and tracking? (Select TWO.)

A) AWS Application Migration Service (MGN) for automated server replication and migration  
B) AWS Migration Hub for centralized progress tracking and grouping servers into application groups  
C) AWS CloudFormation for automating the migration of servers  
D) AWS Systems Manager for migrating databases  
E) AWS Control Tower for migration governance  

---

### Question 37
A company has an on-premises application that processes sensitive financial data. The company is migrating to AWS but regulatory requirements mandate that certain data processing must occur on-premises. The application on AWS needs to access the on-premises processing service with low latency and high security.

Which hybrid architecture should a solutions architect recommend?

A) AWS Outposts rack deployed in the on-premises data center for the sensitive processing, connected to the AWS Region for other workloads  
B) AWS Local Zones for running the sensitive workload closer to the on-premises data center  
C) Use Direct Connect with a private VIF to connect AWS workloads to the on-premises processing service, ensuring all traffic stays on private networks  
D) Use a public-facing API with mutual TLS for the on-premises processing service  

---

### Question 38
A company has a legacy monolithic application running on a single large server. The application handles user authentication, order management, inventory, and reporting. The company wants to modernize incrementally. The first phase involves extracting the reporting functionality into a separate AWS service while keeping the rest of the monolith on-premises.

Which approach should a solutions architect recommend?

A) Use AWS DMS with CDC to replicate the on-premises database to an Aurora replica in AWS, and build the reporting service on AWS reading from the replica  
B) Set up a nightly data export from on-premises to S3 and use Athena for reporting  
C) Migrate the entire monolith to EC2 before extracting any components  
D) Use API Gateway with Lambda to create a reporting API that queries the on-premises database directly  

---

### Question 39
A company is performing a cutover for migrating a critical business application from on-premises to AWS. The application uses a PostgreSQL database being migrated with AWS DMS. The cutover must support rollback if issues are discovered within 48 hours of migration.

Which cutover strategy should a solutions architect recommend?

A) Stop the on-premises application, complete DMS final sync, start the AWS application, and delete the on-premises environment immediately  
B) Configure DMS bidirectional replication before cutover. During cutover, redirect traffic to AWS. If rollback is needed within 48 hours, reverse DMS replication direction and redirect traffic back to on-premises  
C) Keep the on-premises environment running in parallel during cutover. Use DMS CDC to continue replicating from the new AWS database back to on-premises. If rollback is needed, redirect traffic back to on-premises  
D) Take a final backup of the on-premises database before cutover and store it in S3. If rollback is needed, restore the backup to on-premises  

---

### Question 40
A company has multiple AWS accounts and on-premises data centers connected via Direct Connect. The company is migrating additional workloads and needs to connect 15 VPCs across 3 AWS accounts to the on-premises data center through the Direct Connect connection. Currently, each VPC has its own virtual private gateway.

Which solution simplifies the network architecture?

A) Use AWS Direct Connect Gateway associated with a Transit Gateway to connect all VPCs and on-premises through a single Direct Connect connection  
B) Create 15 private virtual interfaces on the Direct Connect connection, one for each VPC  
C) Use VPC peering between all 15 VPCs and connect only one VPC to Direct Connect  
D) Deploy a third-party virtual router in each VPC to manage routing  

---

### Question 41
A company is migrating a SaaS application from on-premises to AWS. The application serves 500 customers, each with their own database (PostgreSQL). The company wants to reduce the operational overhead of managing 500 individual databases after migration.

Which solution should a solutions architect recommend?

A) Migrate all 500 databases to a single large Amazon RDS PostgreSQL instance with schema-level isolation  
B) Use Amazon Aurora PostgreSQL with the Aurora Serverless v2 capacity type for each tenant database, managed through automation  
C) Consolidate all tenant data into a single DynamoDB table with tenant-based partition keys  
D) Deploy each database on a separate EC2 instance for maximum isolation  

---

### Question 42
A company is migrating a Windows application that depends on a Microsoft SQL Server database with complex T-SQL stored procedures, CLR assemblies, and linked servers. The company has attempted to use AWS SCT to convert the stored procedures but found that 60% of the code requires manual conversion. The timeline is aggressive and the company cannot afford extensive refactoring.

Which migration approach should a solutions architect recommend?

A) Migrate to Amazon RDS for SQL Server, which supports T-SQL stored procedures and CLR assemblies natively  
B) Migrate to Aurora PostgreSQL and invest in converting the 60% manually  
C) Migrate to DynamoDB and rewrite all stored procedures as Lambda functions  
D) Keep the database on-premises and only migrate the application tier to AWS  

---

### Question 43
A media company has 2 PB of video archive data stored on-premises in a tape library. The company wants to migrate this archive to AWS for long-term storage. The data is accessed approximately once per year for legal or compliance purposes, and retrieval within 12 hours is acceptable. The company wants the lowest possible storage cost.

Which migration and storage approach should a solutions architect recommend?

A) Use multiple AWS Snowball Edge devices to transfer data to S3, then apply S3 Glacier Deep Archive storage class  
B) Use AWS DataSync to transfer data to S3 Standard, then apply lifecycle policies to transition to S3 Glacier  
C) Use AWS Direct Connect to transfer data to S3 Glacier Flexible Retrieval  
D) Use AWS Snowmobile to transfer the 2 PB dataset to S3 Glacier Deep Archive  

---

### Question 44
A company has completed migrating 100 servers to AWS using AWS MGN. Now the company wants to optimize costs by right-sizing the migrated EC2 instances. During the migration, the company used the same instance sizes as their on-premises servers, which were often over-provisioned.

Which approach should a solutions architect recommend for post-migration optimization?

A) Use AWS Compute Optimizer to analyze CloudWatch metrics and get right-sizing recommendations for EC2 instances  
B) Manually review CloudWatch CPU and memory metrics for each instance and downsize accordingly  
C) Use AWS Trusted Advisor to identify idle instances and terminate them  
D) Switch all instances to t3.micro to minimize costs  

---

### Question 45
A company is migrating an on-premises application that uses Oracle GoldenGate for real-time data replication between two Oracle databases. The company wants to replace GoldenGate with an AWS-native solution after migrating to Aurora PostgreSQL.

Which AWS service provides equivalent CDC (change data capture) functionality?

A) AWS DMS with ongoing replication (CDC) tasks between Aurora PostgreSQL instances  
B) Aurora PostgreSQL native logical replication between clusters  
C) AWS Glue with scheduled ETL jobs  
D) Amazon Kinesis Data Streams for change event streaming  

---

### Question 46
A company has an on-premises Redis cluster used for application caching and session management. The company is migrating the application to AWS and needs to migrate the Redis data with minimal downtime. The Redis cluster contains 100 GB of data.

Which migration approach should a solutions architect recommend?

A) Set up Amazon ElastiCache for Redis and use the Redis SLAVEOF/REPLICAOF command to replicate from on-premises Redis to ElastiCache, then promote ElastiCache to primary  
B) Export the Redis RDB snapshot, upload to S3, and import into ElastiCache for Redis  
C) Use AWS DMS to migrate from Redis to ElastiCache  
D) Rebuild the cache by warming ElastiCache from the application after migration  

---

### Question 47
A company is migrating a Java application from on-premises WebSphere Application Server to AWS. The company wants to move away from commercial middleware and adopt open-source alternatives on AWS. The application uses JMS for messaging, JNDI for directory services, and EJBs for business logic.

Which migration approach should a solutions architect recommend?

A) Re-platform to Apache Tomcat on EC2 instances, replace JMS with Amazon MQ (ActiveMQ), and refactor EJBs to Spring Boot microservices  
B) Deploy WebSphere on EC2 instances for a direct lift-and-shift  
C) Migrate directly to Lambda functions and replace all components  
D) Use AWS Elastic Beanstalk with the WebSphere platform  

---

### Question 48
A company is migrating its on-premises Kubernetes cluster (50 nodes, 200 pods) to AWS. The company wants to maintain Kubernetes-native workflows and tooling. The cluster runs both stateless web services and stateful databases. The company wants to minimize operational overhead for the Kubernetes control plane.

Which combination of solutions should a solutions architect recommend? (Select TWO.)

A) Amazon EKS with managed node groups for compute, reducing control plane operational overhead  
B) Amazon ECS with Fargate for all workloads to eliminate node management  
C) Amazon EBS CSI driver for persistent volumes used by stateful workloads  
D) Amazon S3 for persistent storage of database workloads  
E) Self-managed Kubernetes on EC2 instances for maximum control  

---

### Question 49
A financial company has an on-premises Oracle RAC (Real Application Clusters) database that requires shared storage. The company wants to migrate to AWS. The application requires the multi-node clustering capability for high availability and performance.

Which migration approach should a solutions architect recommend?

A) Migrate to Amazon Aurora with Multi-AZ deployment, which provides equivalent shared storage and high availability without RAC  
B) Deploy Oracle RAC on EC2 instances using FSx for ONTAP as shared storage  
C) Migrate to Amazon RDS for Oracle with Multi-AZ and read replicas  
D) Migrate to Amazon DynamoDB for better horizontal scaling  

---

### Question 50
A company has completed the migration of its web application to AWS. The application runs on EC2 instances behind an ALB. After migration, the company notices that the application's performance is worse than on-premises. Database query latency has increased, and the application occasionally times out when accessing on-premises services that haven't been migrated yet.

Which combination of actions should a solutions architect take to optimize post-migration performance? (Select TWO.)

A) Enable Enhanced Networking on the EC2 instances and ensure they are in the same AZ as the RDS database  
B) Implement Amazon ElastiCache to reduce database query latency for frequently accessed data  
C) Increase the EC2 instance sizes to compensate for the performance gap  
D) Use CloudFront to cache all database queries  
E) Add an additional Direct Connect connection to improve bandwidth for on-premises service access  

---

### Question 51
A company is planning a multi-phase migration of 1,000 servers. Phase 1 will migrate 200 servers that have no dependencies on other systems. Phase 2 will migrate 500 servers that depend on databases being migrated simultaneously. Phase 3 will migrate 300 servers that depend on the servers in Phase 2.

Which approach ensures each phase is properly validated before proceeding to the next?

A) Migrate all phases simultaneously using AWS MGN to minimize overall migration time  
B) Execute each phase sequentially, validating application functionality after each phase through automated testing and user acceptance testing before proceeding to the next phase  
C) Migrate Phase 3 first since it has the most dependencies, ensuring they work before migrating Phase 1 and 2  
D) Use a canary deployment approach, migrating 10% of servers in each phase first  

---

### Question 52
A company is migrating a .NET application from on-premises Windows servers to AWS. The application uses Windows Services for background processing, IIS for web hosting, and SQL Server for the database. The company wants to modernize where possible while maintaining .NET compatibility.

Which target architecture should a solutions architect recommend?

A) Deploy the web tier on AWS Elastic Beanstalk with the .NET platform, migrate background services to Lambda functions where possible, and use RDS for SQL Server  
B) Rewrite the entire application in Node.js and deploy on Lambda  
C) Deploy the entire application on a single large Windows EC2 instance  
D) Use Amazon Lightsail for the web application and database  

---

### Question 53
A company's on-premises environment has 50 TB of data in an NFS file system that is actively used by applications. The company needs to migrate this data to Amazon EFS while maintaining read access to the data during migration. The migration must complete within 1 week.

Which solution should a solutions architect recommend?

A) Use AWS DataSync with a source agent on-premises to incrementally transfer data from NFS to EFS while applications continue reading from the NFS source  
B) Mount the EFS file system on-premises using Direct Connect and manually copy files  
C) Use rsync over VPN to copy files from NFS to EFS  
D) Take the NFS offline, create a snapshot, and restore it to EFS  

---

### Question 54
A company has migrated most of its infrastructure to AWS but still runs some legacy applications on-premises that cannot be migrated. These legacy applications need to communicate with AWS-hosted applications. The company wants to use AWS services (like SQS, SNS, and Secrets Manager) from on-premises applications without routing traffic through the public internet.

Which solution should a solutions architect recommend?

A) Use AWS PrivateLink with VPC interface endpoints accessible over Direct Connect or VPN to access AWS services privately from on-premises  
B) Configure VPC gateway endpoints for all AWS services  
C) Use a NAT Gateway in the VPC to route on-premises traffic to AWS services  
D) Set up a proxy server on EC2 that on-premises applications use to access AWS services  

---

### Question 55
A company is migrating a clustered application that uses multicast networking for node discovery and communication. AWS VPCs do not natively support multicast. The application cannot be modified to use unicast.

Which solution should a solutions architect recommend?

A) Use AWS Transit Gateway with multicast support enabled to handle multicast traffic between EC2 instances  
B) Use overlay network software on EC2 instances to emulate multicast over unicast  
C) Deploy the application on AWS Outposts where multicast is supported  
D) Use Elastic Fabric Adapter (EFA) for multicast support  

---

### Question 56
A company has an on-premises data center with applications that use a shared LDAP directory for authentication. During migration to AWS, some applications will run on AWS while others remain on-premises. Both sets of applications must authenticate against the same directory.

Which solution should a solutions architect recommend?

A) Deploy AWS Managed Microsoft AD in AWS and configure it with a trust relationship to the on-premises LDAP directory, enabling both environments to authenticate  
B) Replicate the LDAP directory to an EC2 instance and maintain synchronization manually  
C) Migrate all applications to AWS immediately to avoid the hybrid authentication challenge  
D) Use Amazon Cognito User Pools as the directory for both on-premises and AWS applications  

---

### Question 57
A company has a 10 PB dataset on-premises that needs to be migrated to AWS S3. The company has a 10 Gbps Direct Connect connection. The data is stored across multiple NAS devices. A network calculation shows that the transfer would take approximately 100 days over Direct Connect.

Which migration approach should a solutions architect recommend?

A) Use AWS Snowmobile to transfer the 10 PB dataset in a single shipment  
B) Use multiple AWS Snowball Edge devices in parallel, with each device handling a portion of the dataset  
C) Increase the Direct Connect connection to 100 Gbps and transfer over the network  
D) Use AWS DataSync with multiple agents to maximize Direct Connect throughput  

---

### Question 58
A company has completed a database migration from on-premises Oracle to Amazon Aurora PostgreSQL using AWS DMS. After migration, the company discovers that some application queries are running slower on Aurora than on Oracle. The queries involve complex joins and subqueries.

Which combination of actions should a solutions architect recommend for post-migration optimization? (Select TWO.)

A) Analyze slow queries using Aurora PostgreSQL Performance Insights and pg_stat_statements to identify problematic queries  
B) Review and optimize the query execution plans, as the PostgreSQL optimizer may choose different plans than Oracle  
C) Increase the Aurora instance size to match the Oracle server specifications  
D) Migrate back to Oracle since PostgreSQL cannot match Oracle performance  
E) Switch to DynamoDB for better query performance  

---

### Question 59
A company is planning a migration that involves moving a web application to AWS. The application currently uses an on-premises load balancer, two web servers, two application servers, and a database cluster. The company wants to implement blue/green deployment for the migration cutover.

Which approach enables a blue/green deployment for the migration?

A) Use Route 53 weighted routing to gradually shift traffic from the on-premises (blue) environment to the AWS (green) environment, with the ability to shift 100% back to on-premises if issues arise  
B) Update the DNS record to point directly to the AWS ALB and remove the on-premises environment  
C) Use CloudFront with two origins (on-premises and AWS) and use origin failover  
D) Implement a hardware load balancer that splits traffic between on-premises and AWS  

---

### Question 60
A company is migrating from an on-premises MongoDB cluster to AWS. The company wants a managed, MongoDB-compatible database service that supports the same MongoDB drivers and APIs. The database stores 2 TB of data and handles 10,000 read operations and 5,000 write operations per second.

Which target database service should a solutions architect recommend?

A) Amazon DocumentDB (with MongoDB compatibility) for a managed MongoDB-compatible database  
B) Amazon DynamoDB with the DynamoDB Streams for change events  
C) Amazon RDS for PostgreSQL with the JSONB data type  
D) MongoDB Community Edition installed on EC2 instances  

---

### Question 61
A company has an on-premises data warehouse that runs complex analytical queries. The company wants to migrate to AWS but maintain the ability to query data using standard SQL. The data warehouse stores 50 TB of structured data and handles 200 concurrent analytical queries during peak hours.

Which migration target should a solutions architect recommend?

A) Amazon Redshift with RA3 nodes for compute-storage separation, concurrency scaling for handling peak query loads, and Redshift Spectrum for querying data in S3  
B) Amazon RDS for PostgreSQL with read replicas for analytical queries  
C) Amazon Aurora MySQL with parallel query for analytical workloads  
D) Amazon Athena for all analytical queries on data stored in S3  

---

### Question 62
A company is migrating a content management system (CMS) to AWS. The CMS stores assets in a file system and metadata in a MySQL database. The system handles 50,000 page views per hour. After migration, the company wants to improve performance and reduce page load times globally.

Which architecture should a solutions architect recommend?

A) EC2 instances for the CMS behind an ALB, Amazon RDS for MySQL with read replicas, Amazon S3 for asset storage, and CloudFront for global content delivery  
B) A single large EC2 instance with local SSD storage for both assets and the database  
C) AWS Lambda for the CMS, DynamoDB for metadata, and S3 for assets  
D) Amazon Lightsail for the CMS with built-in CDN  

---

### Question 63
A company migrated its application to AWS 6 months ago. The migration was a lift-and-shift to EC2 instances. The company now wants to reduce costs. CloudWatch metrics show that most instances use less than 20% CPU on average, some instances only run during business hours, and the application has a predictable baseline with occasional spikes.

Which combination of cost optimization strategies should a solutions architect recommend? (Select THREE.)

A) Use AWS Compute Optimizer to right-size instances based on actual utilization  
B) Purchase Reserved Instances or Savings Plans for the predictable baseline workload  
C) Use Auto Scaling with scheduled scaling for business-hours-only workloads and dynamic scaling for spike handling  
D) Migrate all instances to Spot Instances for maximum savings  
E) Increase instance sizes to reduce the number of instances needed  
F) Move all workloads to Lambda functions  

---

### Question 64
A company is performing a heterogeneous database migration from Microsoft SQL Server to Amazon Aurora PostgreSQL. The application uses SSIS packages for ETL processes, SQL Server Agent jobs for scheduling, and SQL Server Reporting Services for business reports.

Which combination of AWS services should replace these SQL Server-specific features? (Select THREE.)

A) AWS Glue for ETL processes to replace SSIS packages  
B) Amazon EventBridge (CloudWatch Events) with Lambda for job scheduling to replace SQL Server Agent  
C) Amazon QuickSight for business reporting to replace SSRS  
D) Amazon Kinesis for ETL processes  
E) AWS Step Functions for reporting  
F) Amazon SQS for job scheduling  

---

### Question 65
A company has completed the migration of all workloads to AWS. The company still has a Direct Connect connection to the old data center, which is being decommissioned. The company needs to plan the decommission of the hybrid connectivity while ensuring no services are disrupted.

Which sequence of steps should a solutions architect recommend?

A) Immediately terminate the Direct Connect connection to stop incurring costs  
B) Verify that no traffic flows over the Direct Connect connection using VPC Flow Logs and Direct Connect metrics, remove Direct Connect-dependent routes and DNS entries, decommission the virtual interfaces, and finally terminate the Direct Connect connection  
C) Migrate the Direct Connect connection to a VPN and then decommission the VPN  
D) Keep the Direct Connect connection active indefinitely as a backup  

---

## Answer Key

### Question 1
**Correct Answer: B**

**Explanation:** AWS Application Migration Service (AWS MGN) is the primary recommended service for lift-and-shift migrations. It performs continuous block-level replication of source servers to AWS, maintaining data synchronization. MGN supports automated launch testing — you can launch test instances in AWS to verify applications work correctly before the actual cutover. This minimizes downtime because the cutover only requires a final data sync and DNS change.

- **Why A is incorrect:** AWS Server Migration Service (SMS) has been superseded by AWS MGN. SMS replicated at the VM level (requiring VMware/Hyper-V agents) and had longer replication cycles.
- **Why C is incorrect:** VM Import/Export is a manual, one-time process. It doesn't support continuous replication or automated testing, resulting in longer downtime.
- **Why D is incorrect:** DataSync is for transferring files/data to storage services (S3, EFS, FSx), not for migrating entire virtual machines.

---

### Question 2
**Correct Answer: B**

**Explanation:** This is a heterogeneous migration (Oracle → Aurora PostgreSQL), which requires schema conversion. AWS SCT converts the Oracle schema (tables, indexes, stored procedures) to PostgreSQL-compatible syntax. AWS DMS with full load + CDC first migrates all existing data, then continuously replicates ongoing changes. During cutover, the application switches to Aurora PostgreSQL with less than 1 hour of downtime (only the time to stop writes, final sync, and redirect the application).

- **Why A is incorrect:** DMS full load without CDC requires stopping writes at the source during the entire data transfer, which could take hours or days for 50 TB, far exceeding the 1-hour downtime requirement.
- **Why C is incorrect:** CSV export/import doesn't handle schema conversion, stored procedures, or ongoing changes. It also requires significant downtime for the full export/import cycle.
- **Why D is incorrect:** Oracle Data Pump format cannot be restored into Aurora PostgreSQL (different engine). Snowball adds physical shipping time. This approach doesn't support continuous replication for minimal downtime.

---

### Question 3
**Correct Answer: A, D**

**Explanation:** At 1 Gbps, transferring 500 TB would take approximately 46 days (500 TB × 8 bits / 1 Gbps / 86,400 seconds), exceeding the 4-week deadline. AWS Snowball Edge devices (A) can transfer up to 80 TB each. Ordering 7+ devices in parallel allows the transfer within the timeframe. S3 Glacier Flexible Retrieval (D) is appropriate for infrequently accessed data that needs retrieval within hours (3-5 hours standard retrieval), matching the "available within hours" requirement at lower cost than S3 Standard.

- **Why B is incorrect:** 1 Gbps internet cannot transfer 500 TB in 4 weeks. Even at theoretical maximum throughput, it would take over 46 days.
- **Why C is incorrect:** A new Direct Connect connection takes weeks to provision (physical cross-connect installation), making it infeasible within the 4-week timeline.
- **Why E is incorrect:** S3 Standard-IA charges higher storage costs than Glacier Flexible Retrieval. Since the data is accessed infrequently and hours-level retrieval is acceptable, Glacier Flexible Retrieval is more cost-effective.

---

### Question 4
**Correct Answer: A**

**Explanation:** AWS Storage Gateway File Gateway presents an NFS/SMB file interface on-premises while storing files in S3. Its local cache keeps frequently accessed files (recent 30 days) available with low latency. S3 lifecycle policies automatically transition older files to S3 Glacier for cost savings. This is transparent to end users — they access files through the same NFS/SMB mount point regardless of where the data is stored.

- **Why B is incorrect:** DataSync is a data transfer service, not a caching solution. Deleting on-premises copies removes local access capability, and there's no local caching layer for low-latency access to recent files.
- **Why C is incorrect:** NetApp Cloud Volumes adds third-party cost and complexity. It doesn't natively integrate with S3 lifecycle policies for automatic archiving.
- **Why D is incorrect:** FSx for Windows File Server is an AWS-hosted file system, not a hybrid caching solution. It doesn't provide on-premises low-latency access or automatic archiving to Glacier.

---

### Question 5
**Correct Answer: B**

**Explanation:** A site-to-site VPN connection over the internet provides a cost-effective backup for Direct Connect. VPN can be established within minutes (vs. weeks for a new Direct Connect). BGP routing between Direct Connect and VPN enables automatic failover — Direct Connect is preferred (lower BGP local preference/higher weight) when available, and traffic automatically routes through VPN when Direct Connect fails.

- **Why A is incorrect:** A second Direct Connect connection provides the highest resilience but is significantly more expensive (monthly port fees, cross-connect charges). The question asks for the most cost-effective backup.
- **Why C is incorrect:** CloudHub connects multiple on-premises sites to AWS but doesn't address the single Direct Connect reliability concern. It requires multiple VPN connections.
- **Why D is incorrect:** Direct Connect Gateway connects multiple VPCs to Direct Connect but doesn't provide link redundancy. Multiple virtual interfaces on the same physical connection don't protect against link failure.

---

### Question 6
**Correct Answer: B, C**

**Explanation:** AD Connector (B) is a directory gateway that proxies AD authentication requests from AWS to the on-premises AD over the Direct Connect connection. EC2 instances can join the on-premises domain through AD Connector without deploying a full AD in AWS. AWS IAM Identity Center (C) integrates with AD (through AD Connector or Managed AD) to provide federated access to the AWS Management Console using on-premises AD credentials.

- **Why A is incorrect:** AWS Managed Microsoft AD with a two-way trust works but is more expensive and complex than AD Connector for this use case. AD Connector is sufficient when the goal is to proxy authentication to existing on-premises AD.
- **Why D is incorrect:** Creating individual IAM users defeats the purpose of AD integration. Password synchronization via Lambda is insecure and doesn't provide true federation.
- **Why E is incorrect:** Installing a domain controller on EC2 requires manual configuration, maintenance, and patching of Windows Server and AD — defeating the purpose of using a managed service.

---

### Question 7
**Correct Answer: A**

**Explanation:** Route 53 Resolver endpoints provide bidirectional DNS resolution in hybrid environments. Inbound endpoints accept DNS queries from on-premises resolvers and forward them to Route 53 (allowing on-premises to resolve AWS private hosted zone records). Outbound endpoints forward DNS queries from AWS to on-premises DNS servers (allowing VPC resources to resolve on-premises DNS names). Forwarding rules define which domains are forwarded where.

- **Why B is incorrect:** A custom DNS server on EC2 requires managing DNS infrastructure (patching, scaling, HA). Route 53 Resolver provides this functionality as a managed service.
- **Why C is incorrect:** Setting DHCP options to on-premises DNS would break Route 53 private hosted zone resolution for VPC resources. You'd lose the ability to resolve AWS-specific DNS names.
- **Why D is incorrect:** Public hosted zones expose internal DNS records to the internet, violating security best practices. Private resources should use private hosted zones with Route 53 Resolver for hybrid resolution.

---

### Question 8
**Correct Answer: B**

**Explanation:** Storage Gateway File Gateway provides an NFS interface on-premises that is backed by S3. On-premises applications access files through the NFS mount (with local caching), while AWS workloads access the same files directly from the S3 bucket. This provides a unified namespace without duplicating the full 200 TB dataset.

- **Why A is incorrect:** DataSync copies data to S3 but creates a one-directional transfer. On-premises applications would need to be reconfigured to access data differently, and any changes made in S3 aren't automatically reflected on-premises.
- **Why C is incorrect:** FSx for Lustre is high-performance file storage in AWS, not a hybrid solution. It doesn't provide an on-premises access point.
- **Why D is incorrect:** A third-party NFS server on EC2 requires managing infrastructure and creates a separate copy of data in AWS, leading to duplication and synchronization challenges.

---

### Question 9
**Correct Answer: A**

**Explanation:** Amazon Aurora MySQL is fully compatible with MySQL and supports stored procedures, triggers, and other MySQL features. Since the on-premises database is MySQL, this is a homogeneous migration (MySQL → Aurora MySQL) that requires no schema conversion. Aurora provides managed infrastructure with automatic scaling, backups, and Multi-AZ high availability.

- **Why B is incorrect:** DynamoDB is a NoSQL database that doesn't support stored procedures or triggers natively. Replacing them with Lambda functions requires significant application refactoring.
- **Why C is incorrect:** Migrating from MySQL to PostgreSQL is a heterogeneous migration requiring schema conversion and stored procedure rewriting — unnecessary complexity when Aurora MySQL exists.
- **Why D is incorrect:** Redshift is an analytical data warehouse, not a transactional database. It doesn't support stored procedures or triggers in the same way as MySQL.

---

### Question 10
**Correct Answer: A, B**

**Explanation:** AWS Application Discovery Service (A) with the Agentless Collector integrates with VMware vCenter to automatically discover server configurations (CPU, memory, disk, network), running processes, and network dependencies without installing agents on each VM. AWS Migration Hub (B) aggregates discovery data and migration status from multiple tools (MGN, DMS), enabling centralized wave planning based on discovered dependencies and progress tracking.

- **Why C is incorrect:** Trusted Advisor provides best practice recommendations for existing AWS resources, not right-sizing recommendations for on-premises workloads being migrated.
- **Why D is incorrect:** Amazon Inspector scans for software vulnerabilities in AWS workloads. It doesn't assess on-premises servers for migration compatibility.
- **Why E is incorrect:** Cost Explorer analyzes existing AWS spend. It doesn't estimate costs for workloads that haven't been migrated yet (that's done through AWS Pricing Calculator or Migration Evaluator).

---

### Question 11
**Correct Answer: B**

**Explanation:** A 10 Gbps AWS Direct Connect dedicated connection provides the bandwidth needed for 50 TB/month of data transfer (~15 Mbps sustained, well within 10 Gbps). Direct Connect provides consistent network performance and lower latency than internet-based connections. A private virtual interface connects directly to the VPC, keeping traffic off the public internet.

- **Why A is incorrect:** VPN connections share internet bandwidth and are subject to internet variability. Bonding VPN connections doesn't reliably provide the consistent performance needed for application-to-application communication.
- **Why C is incorrect:** Transit Gateway with VPN still relies on internet-based VPN connections, which don't provide the consistent, low-latency performance that Direct Connect offers.
- **Why D is incorrect:** PrivateLink provides access to specific AWS services or endpoints, not general network connectivity between on-premises and AWS applications.

---

### Question 12
**Correct Answer: B**

**Explanation:** AWS Mainframe Modernization service supports two patterns: automated refactoring (converting COBOL to Java using Blu Age) and re-platforming (running COBOL workloads in a managed runtime like Micro Focus). Both approaches allow incremental modernization while keeping the mainframe operational. The service handles VSAM data conversion to relational databases or cloud-native storage.

- **Why A is incorrect:** A complete rewrite from COBOL to Java is the highest risk and most time-consuming approach. It's not recommended as a first step for incremental modernization.
- **Why C is incorrect:** COBOL programs cannot natively call DynamoDB APIs. This approach requires rewriting COBOL data access layers, which is a significant change.
- **Why D is incorrect:** Lambda functions cannot run COBOL programs. Replacing individual COBOL batch programs with Lambda requires a complete rewrite of each program.

---

### Question 13
**Correct Answer: A**

**Explanation:** Amazon ECS with Fargate is ideal for teams without Kubernetes expertise. ECS provides managed container orchestration, and Fargate eliminates the need to manage underlying EC2 instances. Docker Compose files can be translated to ECS task definitions using tools like `ecs-cli compose` or the ECS Compose-X project, minimizing changes to container images.

- **Why B is incorrect:** EKS requires Kubernetes expertise, which the team lacks. Helm charts and Kubernetes manifests have a steeper learning curve than ECS task definitions.
- **Why C is incorrect:** Running Docker Compose on EC2 doesn't provide the managed orchestration features (auto-recovery, service discovery, load balancing integration) that the team needs.
- **Why D is incorrect:** App Runner is designed for simple, single-container web services. It doesn't support the complex multi-service architecture with 15 interdependent microservices that require service discovery and inter-service networking.

---

### Question 14
**Correct Answer: A**

**Explanation:** For a homogeneous PostgreSQL migration with 4 hours of acceptable downtime, pg_dump/pg_restore is the most straightforward approach. At 10 TB, the dump and restore can be completed within the downtime window using parallel dump/restore options. This is a native PostgreSQL tool that handles all objects including LOBs natively.

- **Why B is incorrect:** DMS with full load works but handling 50 MB LOBs requires special configuration (full LOB mode), which significantly slows the migration. pg_dump/pg_restore handles LOBs natively without special configuration.
- **Why C is incorrect:** SCT data extraction to S3 adds unnecessary steps for a homogeneous migration. SCT is primarily for heterogeneous migrations.
- **Why D is incorrect:** PostgreSQL logical replication has limitations with large objects and requires additional setup. pg_dump/pg_restore is simpler for a one-time migration with acceptable downtime.

---

### Question 15
**Correct Answer: A**

**Explanation:** AWS DMS supports Oracle as a source and Redshift as a target. A full load task transfers the 200 TB dataset. DMS includes built-in data validation that compares row counts, checksums, and data types between source and target tables. For 200 TB within 2 weeks, DMS can be configured with multiple replication instances for parallel migration of different tables.

- **Why B is incorrect:** Exporting to flat files and shipping via Snowball adds significant time (device shipping, data export/import). Loading flat files into Redshift requires manual validation implementation.
- **Why C is incorrect:** AWS Glue can read from Oracle, but it requires additional setup for large-scale data transfer and doesn't include built-in data validation between source and target.
- **Why D is incorrect:** Kinesis Data Firehose is for streaming data, not bulk data warehouse migration. It doesn't support Oracle as a source.

---

### Question 16
**Correct Answer: B**

**Explanation:** AWS Direct Connect with a private virtual interface provides dedicated, consistent network connectivity between the VPC and the on-premises data center. It offers lower latency than VPN (no encryption overhead, dedicated bandwidth) and keeps traffic on a private network. This is essential for database connectivity where consistent latency directly impacts application performance.

- **Why A is incorrect:** VPN over the internet has variable latency and throughput because it shares internet bandwidth. For database connectivity requiring low, consistent latency, Direct Connect is superior.
- **Why C is incorrect:** Exposing the database through a public endpoint is a security risk, especially for a financial services company. Even with SSL/TLS, the database should not be internet-accessible.
- **Why D is incorrect:** Migrating the database in Phase 1 contradicts the phased migration plan. The question specifically states the database remains on-premises during Phase 1.

---

### Question 17
**Correct Answer: A**

**Explanation:** Amazon FSx for Windows File Server is a fully managed Windows file system that provides native SMB protocol support, NTFS file system, and Active Directory integration. Multi-AZ deployment provides automatic failover to a standby file system in a different AZ, ensuring high availability. It's the direct replacement for on-premises Windows file shares.

- **Why B is incorrect:** Amazon EFS is a Linux file system that uses NFS protocol. While Windows can mount NFS shares, it doesn't provide native SMB/Windows ACL support or AD integration.
- **Why C is incorrect:** Storage Gateway with S3 provides SMB access but doesn't support native Windows features like DFS, shadow copies, or the full NTFS permission model. It's a hybrid solution, not a direct file server replacement.
- **Why D is incorrect:** EBS multi-attach is only supported for io1/io2 volumes and requires a cluster-aware file system. It doesn't provide SMB/Windows file sharing capabilities or AD integration.

---

### Question 18
**Correct Answer: A**

**Explanation:** AWS DataSync supports HDFS as a source location and S3 as a destination. With an existing 10 Gbps Direct Connect, DataSync can transfer data at high speed (DataSync can use the full bandwidth). For 500 TB over 10 Gbps, the transfer takes approximately 5 days at 80% utilization, well within 6 weeks. DataSync handles task scheduling, integrity verification, and incremental transfers.

- **Why B is incorrect:** S3 DistCp works but requires managing the Hadoop cluster's resources for the copy operation. It competes with production workloads for cluster resources and requires more manual coordination than DataSync.
- **Why C is incorrect:** With 10 Gbps Direct Connect already established, Snowball devices add unnecessary shipping delays. Network transfer is faster when sufficient bandwidth exists.
- **Why D is incorrect:** Transfer Family (SFTP) is not designed for bulk HDFS-to-S3 migration. It's for file transfer using SFTP/FTPS/FTP protocols.

---

### Question 19
**Correct Answer: B**

**Explanation:** AWS Migration Hub provides a centralized dashboard for tracking migration progress across multiple tools and teams. It integrates with AWS MGN (for server migrations), AWS DMS (for database migrations), and partner migration tools. Migration Hub allows grouping servers into applications, tracking each application's migration status, and providing visibility across all 50 application stacks.

- **Why A is incorrect:** CloudFormation StackSets deploys infrastructure across accounts but doesn't track migration progress or provide migration-specific workflows.
- **Why C is incorrect:** Service Catalog provides standardized resource provisioning but doesn't track migration progress.
- **Why D is incorrect:** Organizations manages account governance, not migration tracking.

---

### Question 20
**Correct Answer: A, C**

**Explanation:** AWS SCT (A) analyzes the Oracle schema and generates a detailed conversion report showing which objects convert automatically and which require manual remediation (materialized views, database links, Oracle Text). This is essential for planning the refactoring effort. Aurora PostgreSQL via DMS (C) is the target service after schema conversion issues are addressed. DMS handles the actual data migration from Oracle to Aurora PostgreSQL.

- **Why B is incorrect:** DMS does not automatically convert schemas for heterogeneous migrations. It migrates data, not schema definitions or stored procedures. SCT must be used first.
- **Why D is incorrect:** Migrating to RDS for Oracle avoids refactoring but retains Oracle licensing costs and doesn't align with the goal of removing Oracle-specific dependencies.
- **Why E is incorrect:** Amazon Neptune is a graph database, not a replacement for Oracle relational databases. Database links are Oracle-specific features, not graph relationships.

---

### Question 21
**Correct Answer: A, C**

**Explanation:** At 1 Gbps, transferring 80 TB would take approximately 7.4 days at maximum throughput, which is tight for 2 weeks and risky with real-world throughput. AWS Snowball (A) for the initial bulk transfer is reliable and predictable — each device holds up to 80 TB and shipping typically takes 5-7 days. For ongoing 500 GB daily transfers (C), AWS DataSync over the 1 Gbps internet can transfer 500 GB in approximately 1.1 hours, which is well within a day. DataSync handles scheduling, integrity verification, and incremental transfers.

- **Why B is incorrect:** While 80 TB could theoretically be transferred over 1 Gbps in 7.4 days, this assumes 100% utilization. Real-world throughput is typically 60-80%, pushing the timeline beyond 2 weeks.
- **Why D is incorrect:** Snowball for daily 500 GB transfers is impractical — shipping takes days, making it infeasible for daily operations.
- **Why E is incorrect:** Direct Connect for 500 GB daily is over-engineered. The 1 Gbps internet connection can handle 500 GB in about 1 hour, making Direct Connect's cost unnecessary for this volume.

---

### Question 22
**Correct Answer: B**

**Explanation:** VMware Cloud on AWS runs VMware vSphere, vSAN, and NSX on dedicated AWS infrastructure. Operations teams can continue using familiar VMware tools (vCenter, vMotion, etc.) without changes. It supports DR (vSphere Replication/Site Recovery Manager) and burst capacity (auto-scaling SDDC clusters) natively. Workloads can vMotion between on-premises and AWS seamlessly.

- **Why A is incorrect:** VM Import/Export converts VMware VMs to AMIs, but the resulting EC2 instances don't run on VMware infrastructure. Operations teams would need to learn AWS tools, which contradicts the requirement.
- **Why C is incorrect:** ESXi on EC2 bare metal is not supported or recommended by VMware. VMware Cloud on AWS is the supported, managed solution.
- **Why D is incorrect:** MGN migrates VMs to EC2 instances, not to VMware infrastructure on AWS. The operations team would need to change their tools and processes.

---

### Question 23
**Correct Answer: A**

**Explanation:** Migrating to Aurora PostgreSQL and creating database views per team is the simplest approach. Views provide logical data isolation — each team sees only the columns and rows they need. Views are efficient (no data duplication), support fine-grained access control, and provide near-real-time access since they query the underlying table directly.

- **Why B is incorrect:** DMS table/column mapping creates separate physical copies of data, increasing storage costs and introducing replication lag for near-real-time access. Managing multiple DMS tasks adds operational overhead.
- **Why C is incorrect:** Replicating to separate DynamoDB tables requires schema redesign (relational to NoSQL), introduces additional services, and adds replication lag.
- **Why D is incorrect:** S3 exports are not near-real-time. Even with frequent exports, there's inherent latency, and Athena has higher query latency than Aurora for interactive queries.

---

### Question 24
**Correct Answer: A**

**Explanation:** Pilot light with AWS MGN provides a cost-effective DR strategy meeting 1-hour RPO and 4-hour RTO. AWS MGN continuously replicates servers to AWS (maintaining sub-hour RPO). During normal operations, only the pilot light runs (database replicas, minimal infrastructure). During a DR event, MGN launches full-sized EC2 instances from the replicated data within the 4-hour RTO window.

- **Why B is incorrect:** Multi-site active-active provides the lowest RPO/RTO but is the most expensive option. It runs full production infrastructure in both locations, which is overkill for a 1-hour RPO / 4-hour RTO requirement.
- **Why C is incorrect:** Backup and restore relies on periodic backups (daily), giving a 24-hour RPO at best. Restoring 50 servers from backups could take 8+ hours, exceeding the 4-hour RTO.
- **Why D is incorrect:** Warm standby maintains a scaled-down but running environment, which is more expensive than pilot light. It provides faster RTO but costs more during normal operations than is necessary for a 4-hour RTO requirement.

---

### Question 25
**Correct Answer: A**

**Explanation:** Storage Gateway Tape Gateway presents a virtual tape library (VTL) interface to backup software using iSCSI protocol — identical to how physical tape libraries work. The backup software requires no changes. Virtual tapes are stored in S3 and automatically archived to S3 Glacier (for archived tapes), significantly reducing storage costs compared to physical tape infrastructure.

- **Why B is incorrect:** DataSync is a data transfer service, not a tape emulation solution. It doesn't provide the iSCSI/VTL interface that backup software expects.
- **Why C is incorrect:** Snowball physically transfers data but doesn't replace the ongoing tape backup workflow. The backup software needs a VTL interface for daily operations.
- **Why D is incorrect:** Reconfiguring backup software from tape to NFS requires changes to existing backup processes, which the question says should be minimized.

---

### Question 26
**Correct Answer: A, B**

**Explanation:** AWS SCT (A) converts T-SQL stored procedures to MySQL syntax, generating a report showing what converts automatically and what needs manual intervention. This is essential for the heterogeneous migration (SQL Server → Aurora MySQL). AWS Glue (B) replaces SSIS packages for ETL — it supports similar data transformation workflows with a serverless, managed service, and can read from and write to databases, S3, and other data stores.

- **Why C is incorrect:** Migrating to RDS for SQL Server avoids the complexity but doesn't achieve the goal of migrating to Aurora MySQL. It also retains SQL Server licensing costs.
- **Why D is incorrect:** DMS does not convert stored procedures. It migrates data only. Schema and code conversion requires SCT.
- **Why E is incorrect:** While QuickSight can replace SSRS, the question asks for the migration steps (schema conversion and ETL replacement), which are the most critical first steps. QuickSight integration can come later.

---

### Question 27
**Correct Answer: B**

**Explanation:** Amazon MQ supports ActiveMQ and RabbitMQ, both of which are JMS-compatible message brokers. Amazon MQ provides managed broker infrastructure with support for point-to-point (queues) and publish-subscribe (topics) patterns. The network of brokers feature allows connecting on-premises brokers with AWS-hosted brokers for hybrid messaging over Direct Connect or VPN.

- **Why A is incorrect:** SQS and SNS are cloud-native services that don't support JMS client libraries. Applications using JMS would require code changes to use the SQS/SNS SDKs.
- **Why C is incorrect:** Kinesis is a streaming data service, not a message broker. It doesn't support JMS or traditional messaging patterns.
- **Why D is incorrect:** EventBridge is a serverless event bus that doesn't support JMS. It's designed for event-driven architectures, not legacy JMS messaging integration.

---

### Question 28
**Correct Answer: A**

**Explanation:** AWS DMS supports all the mentioned source and target engines (MySQL, PostgreSQL, SQL Server, Oracle). For homogeneous migrations, DMS handles both schema replication and data migration. For heterogeneous migrations, AWS SCT converts the schema first (structures, data types, code objects), then DMS migrates the data. This provides a unified tool for all 50 database migrations.

- **Why B is incorrect:** Using native tools for each engine type requires managing multiple different tools and processes, increasing complexity for a 50-database migration.
- **Why C is incorrect:** DMS without SCT works for homogeneous migrations but will miss schema incompatibilities in heterogeneous migrations (different data types, stored procedures, etc.).
- **Why D is incorrect:** AWS Glue is an ETL service, not a database migration tool. It doesn't handle schema conversion, CDC, or the full range of database migration requirements.

---

### Question 29
**Correct Answer: A**

**Explanation:** Amazon FSx for Windows File Server natively supports all the listed Windows features: NTFS permissions (full ACL support), shadow copies (previous versions), and DFS namespaces. It integrates with Active Directory for access control and provides a fully managed Windows file system that's compatible with existing Windows applications.

- **Why B is incorrect:** EFS is a Linux file system (NFS protocol). There is no "Windows-compatible mode" for EFS.
- **Why C is incorrect:** Storage Gateway File Gateway provides basic SMB access to S3 but doesn't support advanced Windows features like shadow copies or DFS namespaces.
- **Why D is incorrect:** Individual EBS volumes cannot be shared between instances (except io1/io2 multi-attach with cluster-aware file systems). This doesn't provide a shared file system with Windows features.

---

### Question 30
**Correct Answer: A, B, C**

**Explanation:** Amazon EMR (A) provides managed Hadoop ecosystem including Apache Spark and Apache Hive, allowing the company to run existing workloads with minimal changes. Amazon S3 (B) replaces HDFS as the storage layer — EMR natively reads/writes to S3 (EMRFS), which provides better durability, scalability, and cost efficiency than HDFS. Amazon DynamoDB (C) is the recommended replacement for HBase — it provides a similar key-value/wide-column NoSQL data model and integrates with EMR for analytics.

- **Why D is incorrect:** Redshift is a columnar analytical warehouse, not a direct replacement for Hive. Hive runs on EMR with SQL-on-Hadoop, and the migration would require significant query and schema changes.
- **Why E is incorrect:** EBS volumes as HDFS replacement don't provide the durability, scalability, or cost benefits of S3. S3 is the standard HDFS replacement for EMR clusters.
- **Why F is incorrect:** Kinesis is a streaming data service, not a NoSQL database. It doesn't replace HBase's key-value storage capabilities.

---

### Question 31
**Correct Answer: B**

**Explanation:** A Site-to-Site VPN over the internet is the most cost-effective backup for Direct Connect. VPN can be established within minutes (configuration only, no physical installation). BGP routing enables automatic failover — Direct Connect routes have higher BGP preference, so traffic uses Direct Connect when available. When Direct Connect fails, BGP automatically routes traffic through the VPN.

- **Why A is incorrect:** A second Direct Connect at the same location doesn't protect against location-level failures. Even at a different location, it's significantly more expensive than VPN for a backup connection.
- **Why C is incorrect:** CloudFront is a CDN for content delivery, not a network connectivity backup solution.
- **Why D is incorrect:** Global Accelerator improves internet-facing application performance but doesn't provide private connectivity between on-premises and AWS VPCs.

---

### Question 32
**Correct Answer: B**

**Explanation:** The correct migration sequence starts with the database (B) because it's the foundational dependency. Migrating PostgreSQL with DMS + CDC first allows continuous replication — the on-premises application continues writing to the on-premises database while changes replicate to Aurora PostgreSQL. Next, migrate Redis to ElastiCache. Then migrate application servers and configure them to use the new Aurora and ElastiCache endpoints. Finally, switch DNS to direct traffic to the AWS ALB, and stop DMS replication after validation.

- **Why A is incorrect:** Migrating application servers before the database means they'd need to connect to the on-premises database over the network, adding latency and complexity.
- **Why C is incorrect:** Simultaneous migration of all components increases risk and complexity. If any component fails, the entire migration must be rolled back.
- **Why D is incorrect:** The GPS tracking component depends on other system components. Migrating it first without its dependencies would likely cause it to fail.

---

### Question 33
**Correct Answer: A**

**Explanation:** Amazon OpenSearch Service (the successor to Elasticsearch Service) is compatible with Elasticsearch and Kibana (OpenSearch Dashboards). UltraWarm provides cost-effective warm storage for older indices (365 days), while hot nodes serve recent data (90 days). Index lifecycle management (ISM) policies automatically transition indices from hot to warm storage based on age.

- **Why B is incorrect:** CloudWatch Logs with Insights doesn't provide the same Elasticsearch/Kibana experience the team is accustomed to. Migration would require learning new tools and rewriting dashboards.
- **Why C is incorrect:** S3 with Athena provides SQL-based log querying but doesn't replicate the Elasticsearch/Kibana visual analysis and dashboard experience.
- **Why D is incorrect:** Kinesis Data Analytics is for real-time stream processing, not log storage and analysis with retention policies.

---

### Question 34
**Correct Answer: A, B**

**Explanation:** Direct Connect with MACsec or VPN with IPsec (A) encrypts data in transit between on-premises and AWS. MACsec provides Layer 2 encryption on Direct Connect, while VPN provides IPsec encryption over the internet. AWS KMS customer-managed keys (B) encrypt data at rest across all AWS storage services — EBS volumes, S3 buckets, RDS instances, etc. — with full customer control over key management and rotation.

- **Why C is incorrect:** SSL/TLS on ALBs encrypts client-to-ALB traffic but doesn't address the on-premises to AWS transit encryption or data-at-rest encryption requirements.
- **Why D is incorrect:** CloudTrail logs API calls for auditing. It doesn't encrypt data in transit.
- **Why E is incorrect:** ACM manages SSL/TLS certificates for HTTPS endpoints. It doesn't encrypt data at rest in S3.

---

### Question 35
**Correct Answer: A**

**Explanation:** Amazon RDS for SQL Server Multi-AZ deployment provides automatic failover equivalent to Always On Availability Groups but fully managed. AWS handles the synchronous replication to a standby in a different AZ and automatic DNS failover. This requires zero management of the underlying clustering technology.

- **Why B is incorrect:** SQL Server on EC2 with Always On requires managing the OS, SQL Server instances, Windows Server Failover Clustering, and AG configuration. This has significantly more operational overhead than managed RDS Multi-AZ.
- **Why C is incorrect:** Aurora MySQL is a different database engine (MySQL, not SQL Server). The application would require conversion.
- **Why D is incorrect:** RDS read replicas provide read scaling but don't provide automatic failover for high availability. Read replicas are asynchronous and don't replace Multi-AZ for HA.

---

### Question 36
**Correct Answer: A, B**

**Explanation:** AWS MGN (A) automates server replication — it continuously replicates source servers to AWS and provides automated launch, testing, and cutover capabilities. Migration Hub (B) provides a centralized dashboard that integrates with MGN and DMS, showing the status of each server and database migration. It supports grouping servers into application groups and tracking progress per group and per team.

- **Why C is incorrect:** CloudFormation automates infrastructure provisioning but doesn't handle the actual migration of existing servers (replication, cutover).
- **Why D is incorrect:** Systems Manager manages and configures existing servers. It doesn't provide database migration capabilities.
- **Why E is incorrect:** Control Tower sets up and governs a multi-account AWS environment. It's not a migration tracking service.

---

### Question 37
**Correct Answer: C**

**Explanation:** Direct Connect with a private virtual interface provides a dedicated, private connection between AWS and on-premises. All traffic stays on private networks (no internet traversal), meeting the security requirement. The low latency of Direct Connect ensures the AWS application can access the on-premises processing service efficiently. This is the standard hybrid architecture for connecting AWS workloads to on-premises services.

- **Why A is incorrect:** AWS Outposts places AWS infrastructure on-premises, but the question asks about connecting AWS-hosted workloads to on-premises services, not running AWS services on-premises. Outposts would be appropriate if the goal was to run AWS services on-premises.
- **Why B is incorrect:** Local Zones extend AWS infrastructure to metropolitan areas, not to the company's on-premises data center. They don't provide connectivity to on-premises services.
- **Why D is incorrect:** A public-facing API exposes the sensitive processing service to the internet, violating the regulatory requirement for private, secure access.

---

### Question 38
**Correct Answer: A**

**Explanation:** DMS with CDC creates a near-real-time replica of the on-premises database in Aurora on AWS. The reporting service can be built on AWS reading from the Aurora replica without impacting the production monolith. CDC ensures the replica stays current with minimal lag. This is a common "strangle the monolith" first step — extract read-heavy workloads first.

- **Why B is incorrect:** Nightly data exports introduce a 24-hour lag, making reports stale. For business reporting, near-real-time data is typically required.
- **Why C is incorrect:** Migrating the entire monolith first is a "big bang" approach that contradicts the incremental modernization requirement.
- **Why D is incorrect:** Lambda querying the on-premises database directly creates tight coupling and adds cross-network latency. It also increases load on the production database.

---

### Question 39
**Correct Answer: C**

**Explanation:** Keeping the on-premises environment running in parallel provides a safe rollback path. DMS CDC replicating from the AWS database back to on-premises ensures the on-premises database stays current with any changes made on AWS after cutover. If rollback is needed within 48 hours, traffic can be redirected back to on-premises with the database fully up to date.

- **Why A is incorrect:** Deleting the on-premises environment immediately eliminates the rollback capability. This is never recommended for critical applications.
- **Why B is incorrect:** DMS doesn't natively support bidirectional replication. While it can replicate in one direction, setting up "reverse replication" requires careful configuration. Option C's approach of maintaining reverse CDC is the standard pattern.
- **Why D is incorrect:** Restoring from a pre-cutover backup means losing all transactions processed on AWS during the 48 hours. This could result in significant data loss.

---

### Question 40
**Correct Answer: A**

**Explanation:** AWS Transit Gateway acts as a hub connecting all 15 VPCs. Direct Connect Gateway associates with Transit Gateway, allowing the single Direct Connect connection to reach all VPCs through one Transit VIF (transit virtual interface). This replaces 15 individual virtual private gateways with a single, scalable architecture.

- **Why B is incorrect:** Direct Connect supports a maximum of 50 private VIFs per connection, but managing 15 individual VIFs (one per VPC) is operationally complex and doesn't scale well.
- **Why C is incorrect:** VPC peering doesn't support transitive routing. Traffic from on-premises to VPC-A cannot transit through VPC-A's peering to reach VPC-B.
- **Why D is incorrect:** Third-party routers add cost, complexity, and management overhead. Transit Gateway provides this functionality as a managed service.

---

### Question 41
**Correct Answer: B**

**Explanation:** Aurora Serverless v2 with per-tenant databases provides both isolation and reduced overhead. Aurora Serverless v2 automatically scales compute capacity based on demand (scaling to near zero when idle), reducing costs for low-traffic tenants. Automation (CloudFormation, CDK, or scripts) manages database creation and configuration, reducing the operational burden of managing 500 databases.

- **Why A is incorrect:** A single large RDS instance with 500 schemas creates a single point of failure and scaling bottleneck. One tenant's heavy workload affects all others. Schema-level isolation is weaker than database-level isolation.
- **Why C is incorrect:** Consolidating relational data from 500 PostgreSQL databases into DynamoDB requires complete application rewrite and schema redesign.
- **Why D is incorrect:** 500 separate EC2 instances is the highest operational overhead option — patching, monitoring, and scaling each instance individually.

---

### Question 42
**Correct Answer: A**

**Explanation:** Amazon RDS for SQL Server supports T-SQL stored procedures, CLR assemblies (via the clr enabled option), and linked servers natively. This is a homogeneous migration (SQL Server → SQL Server) that preserves all existing database features without code changes. Given the aggressive timeline and 60% manual conversion requirement for PostgreSQL, staying on SQL Server is the pragmatic choice.

- **Why B is incorrect:** With 60% requiring manual conversion and an aggressive timeline, the refactoring effort is too risky and time-consuming.
- **Why C is incorrect:** Rewriting stored procedures as Lambda functions with DynamoDB is a complete re-architecture, not a migration. This would take significantly longer than any other option.
- **Why D is incorrect:** Keeping the database on-premises creates ongoing cross-network latency, doesn't benefit from managed services, and maintains on-premises infrastructure.

---

### Question 43
**Correct Answer: A**

**Explanation:** For 2 PB, multiple Snowball Edge devices (or potentially AWS Snowmobile — but Snowball Edge at scale is typically recommended for sub-10 PB) provide the fastest physical transfer. S3 Glacier Deep Archive offers the lowest storage cost (~$1/TB/month) and supports retrieval within 12 hours (standard retrieval), matching the annual access pattern and retrieval time requirement.

- **Why B is incorrect:** Transferring 2 PB over the network with DataSync would take an extremely long time even with 10 Gbps, and S3 Standard is unnecessarily expensive for archive data.
- **Why C is incorrect:** Direct Connect transfer of 2 PB would take months. Glacier Flexible Retrieval is more expensive than Deep Archive for data accessed once per year.
- **Why D is incorrect:** AWS Snowmobile is designed for 10+ PB datasets. For 2 PB, multiple Snowball Edge devices are more practical and available. Snowmobile requires significant logistics coordination.

---

### Question 44
**Correct Answer: A**

**Explanation:** AWS Compute Optimizer analyzes historical CloudWatch metrics (CPU, memory, network, disk I/O) and uses machine learning to recommend optimal EC2 instance types and sizes. After 6 months of running, Compute Optimizer has sufficient data to provide accurate recommendations, potentially saving 25-50% on over-provisioned instances.

- **Why B is incorrect:** Manual review of CloudWatch metrics for 100 instances is time-consuming and error-prone. Compute Optimizer automates this analysis with ML-driven recommendations.
- **Why C is incorrect:** Trusted Advisor identifies idle instances but doesn't provide granular right-sizing recommendations for active instances.
- **Why D is incorrect:** Switching all instances to t3.micro would cause application failures. Right-sizing must be based on actual workload requirements, not arbitrary instance size selection.

---

### Question 45
**Correct Answer: A**

**Explanation:** AWS DMS with ongoing replication (CDC) provides change data capture functionality similar to Oracle GoldenGate. DMS can continuously replicate changes from a source Aurora PostgreSQL instance to a target Aurora PostgreSQL instance, capturing inserts, updates, and deletes in near-real-time. This is the most direct replacement for GoldenGate's CDC functionality.

- **Why B is incorrect:** Aurora PostgreSQL native logical replication works for same-engine replication but has limitations compared to DMS CDC (e.g., DDL changes, conflict resolution, monitoring). DMS provides more robust CDC with built-in monitoring and error handling.
- **Why C is incorrect:** Glue scheduled ETL provides batch processing, not real-time change data capture. This introduces significant latency compared to CDC.
- **Why D is incorrect:** Kinesis Data Streams is a streaming platform but doesn't natively capture database changes. You'd need to build custom CDC logic or use DMS to feed Kinesis.

---

### Question 46
**Correct Answer: B**

**Explanation:** Exporting an RDB snapshot from the on-premises Redis cluster and importing it into ElastiCache for Redis is the most straightforward approach for a 100 GB dataset. The RDB snapshot captures the entire Redis dataset at a point in time. After uploading to S3, ElastiCache can create a new cluster by restoring from the RDB file. The brief downtime covers the time between the snapshot and application switchover.

- **Why A is incorrect:** ElastiCache for Redis doesn't support SLAVEOF/REPLICAOF commands to replicate from an external (on-premises) Redis instance. ElastiCache manages replication internally.
- **Why C is incorrect:** AWS DMS doesn't support Redis as a source or target for database migration.
- **Why D is incorrect:** Rebuilding the cache from the application means the cache starts empty, causing a "cache stampede" where all requests hit the database simultaneously, potentially causing an outage.

---

### Question 47
**Correct Answer: A**

**Explanation:** Re-platforming from WebSphere to open-source alternatives eliminates commercial licensing costs. Apache Tomcat on EC2 runs Java web applications without WebSphere licensing. Amazon MQ with ActiveMQ provides JMS-compatible messaging as a managed service. Refactoring EJBs to Spring Boot microservices modernizes the application architecture while maintaining Java compatibility.

- **Why B is incorrect:** Lift-and-shift of WebSphere to EC2 maintains expensive commercial licensing costs and doesn't modernize the application.
- **Why C is incorrect:** Migrating directly to Lambda requires a complete rewrite of the JMS messaging, JNDI lookups, and EJB components, which is extremely high effort.
- **Why D is incorrect:** Elastic Beanstalk doesn't support WebSphere as a platform. It supports Tomcat for Java applications.

---

### Question 48
**Correct Answer: A, C**

**Explanation:** Amazon EKS with managed node groups (A) provides a managed Kubernetes control plane (no control plane operational overhead) with managed node groups that automate EC2 node provisioning, patching, and updates. The EBS CSI driver (C) provides persistent volume support for stateful workloads (databases), enabling Kubernetes PersistentVolumeClaims to be backed by EBS volumes with proper lifecycle management.

- **Why B is incorrect:** ECS is a different container orchestration platform. The company wants to maintain Kubernetes-native workflows and tooling, making EKS the appropriate choice.
- **Why D is incorrect:** S3 is object storage, not suitable for persistent volumes used by databases that require block-level storage with consistent I/O performance.
- **Why E is incorrect:** Self-managed Kubernetes on EC2 requires managing the control plane (etcd, API server, scheduler), which contradicts the requirement to minimize operational overhead.

---

### Question 49
**Correct Answer: A**

**Explanation:** Amazon Aurora provides a shared distributed storage layer (up to 128 TB) across multiple AZs, similar to Oracle RAC's shared storage concept. Aurora supports up to 15 read replicas with automatic failover to any replica, providing multi-node high availability. While Aurora doesn't use Oracle RAC's architecture, it provides equivalent high availability and often better performance through its distributed storage design.

- **Why B is incorrect:** While Oracle RAC on EC2 with shared storage is technically possible, it requires managing the RAC configuration, shared storage, and clustering — significant operational overhead compared to Aurora's managed approach.
- **Why C is incorrect:** RDS for Oracle doesn't support RAC. Multi-AZ provides failover but not the multi-node active processing that RAC offers.
- **Why D is incorrect:** DynamoDB is a NoSQL database. Migrating from Oracle RAC (relational) to DynamoDB requires a complete application redesign.

---

### Question 50
**Correct Answer: A, B**

**Explanation:** Enhanced Networking (A) provides higher bandwidth, lower latency, and lower jitter between EC2 instances. Placing instances in the same AZ as RDS reduces cross-AZ latency for database calls. ElastiCache (B) reduces database query latency by caching frequently accessed data in memory, reducing the number of queries hitting the database. These two optimizations address the most common post-migration performance issues.

- **Why C is incorrect:** Increasing instance sizes without understanding the root cause wastes money. The performance issue is network latency and database query patterns, not compute capacity.
- **Why D is incorrect:** CloudFront caches HTTP responses from web applications, not database queries. Database queries are internal backend operations.
- **Why E is incorrect:** The question mentions on-premises services that "haven't been migrated yet," which is a temporary dependency. Adding a Direct Connect connection is expensive for a temporary problem. Migrating the remaining services would be a better long-term solution.

---

### Question 51
**Correct Answer: B**

**Explanation:** Sequential phase execution with validation ensures each phase is stable before the next phase introduces new dependencies. Phase 1 (200 independent servers) validates the migration process and tools. Phase 2 (500 servers + databases) validates complex migrations with dependencies. Phase 3 (300 servers depending on Phase 2) can only succeed if Phase 2 is validated. Automated testing and UAT at each checkpoint reduce risk.

- **Why A is incorrect:** Simultaneous migration of all 1,000 servers maximizes risk. If any phase has issues, it could affect all other phases due to dependencies.
- **Why C is incorrect:** Migrating Phase 3 first is impossible because it depends on Phase 2 servers that haven't been migrated yet.
- **Why D is incorrect:** A canary approach (10% first) adds complexity within each phase and may not reveal dependency issues that only appear when all servers in a phase are migrated.

---

### Question 52
**Correct Answer: A**

**Explanation:** Elastic Beanstalk with the .NET platform provides managed IIS hosting for the web tier with auto-scaling and load balancing. Lambda functions can replace stateless Windows Services for background processing (scheduled tasks, event-driven processing), reducing compute costs. RDS for SQL Server provides a managed database with built-in backups, patching, and Multi-AZ support.

- **Why B is incorrect:** Rewriting in Node.js is a complete application rebuild, not a migration/modernization. This has the highest risk and longest timeline.
- **Why C is incorrect:** A single large EC2 instance is a direct lift-and-shift without any modernization. It has no high availability, auto-scaling, or managed services.
- **Why D is incorrect:** Lightsail is designed for simple workloads and doesn't support the .NET platform features, background services, or SQL Server managed databases needed here.

---

### Question 53
**Correct Answer: A**

**Explanation:** AWS DataSync with an on-premises agent performs high-speed, incremental data transfers from NFS to EFS. Applications continue reading from the NFS source during the transfer (DataSync uses read-only access). DataSync handles scheduling, integrity verification, bandwidth throttling, and incremental sync (only changed files after the initial transfer). For 50 TB over a 1-week window, DataSync optimizes the transfer.

- **Why B is incorrect:** Mounting EFS on-premises requires Direct Connect or VPN, and manual copying of 50 TB is slow and error-prone without DataSync's optimization and verification.
- **Why C is incorrect:** rsync over VPN is significantly slower than DataSync for large transfers. DataSync uses a purpose-built protocol that outperforms rsync for large datasets.
- **Why D is incorrect:** Taking NFS offline prevents application access during migration, violating the requirement to maintain read access during migration.

---

### Question 54
**Correct Answer: A**

**Explanation:** AWS PrivateLink with VPC interface endpoints creates private connections to AWS services within the VPC. When combined with Direct Connect or VPN, on-premises applications route traffic through the private connection to the VPC, then through interface endpoints to access AWS services (SQS, SNS, Secrets Manager) without using the public internet. This keeps all traffic on private networks.

- **Why B is incorrect:** VPC gateway endpoints only support S3 and DynamoDB. They don't support SQS, SNS, or Secrets Manager.
- **Why C is incorrect:** NAT Gateway enables VPC resources to access the internet. It doesn't provide private access from on-premises to AWS services.
- **Why D is incorrect:** A proxy server works but adds operational overhead (managing, scaling, securing the proxy). PrivateLink provides this functionality as a managed service.

---

### Question 55
**Correct Answer: A**

**Explanation:** AWS Transit Gateway supports multicast routing. When multicast is enabled on a Transit Gateway, EC2 instances can join multicast groups and send/receive multicast traffic. This allows the application to use multicast for node discovery and communication without modification.

- **Why B is incorrect:** Overlay network software adds complexity and may not perfectly emulate all multicast behaviors that the application depends on.
- **Why C is incorrect:** Outposts runs on AWS infrastructure within the customer's data center but multicast support depends on Transit Gateway configuration, not Outposts specifically.
- **Why D is incorrect:** EFA provides high-performance networking for HPC/ML workloads. It doesn't provide multicast support.

---

### Question 56
**Correct Answer: A**

**Explanation:** AWS Managed Microsoft AD deployed in AWS with a trust relationship to the on-premises LDAP/AD directory enables both environments to authenticate against either directory. AWS applications authenticate through the Managed AD in AWS (low latency), which trusts the on-premises AD. On-premises applications continue authenticating against the on-premises directory. Users have a single set of credentials that works in both environments.

- **Why B is incorrect:** Manual replication of LDAP to EC2 requires custom synchronization logic, introduces security risks (credential handling), and has high operational overhead.
- **Why C is incorrect:** Migrating all applications immediately contradicts the company's incremental migration approach and may not be technically feasible.
- **Why D is incorrect:** Cognito User Pools is designed for customer-facing applications, not enterprise LDAP integration. It doesn't natively integrate with on-premises LDAP for existing application authentication.

---

### Question 57
**Correct Answer: B**

**Explanation:** At 10 PB, using multiple Snowball Edge devices in parallel is the most practical approach. Each Snowball Edge device holds up to 80 TB of usable storage. With approximately 125 devices, the data can be loaded and shipped in waves. While this is logistically complex, it's significantly faster than 100+ days of network transfer. Each wave can be loaded concurrently from different NAS devices.

- **Why A is incorrect:** Snowmobile is designed for extremely large transfers (typically 10-100 PB), but its availability is limited, requires long lead time, and the logistics may not justify it for exactly 10 PB, which is at the lower threshold. Snowball Edge devices in parallel offer more flexibility.
- **Why C is incorrect:** 100 Gbps Direct Connect is not widely available and takes months to provision. Even at 100 Gbps, 10 PB would take approximately 10 days at full throughput, which is feasible but the provisioning time makes this impractical.
- **Why D is incorrect:** Even maximizing the 10 Gbps Direct Connect throughput with multiple DataSync agents, the transfer takes ~100 days, which may exceed the company's timeline.

---

### Question 58
**Correct Answer: A, B**

**Explanation:** Performance Insights with pg_stat_statements (A) identifies specific slow queries, their frequency, wait events, and resource consumption. This pinpoints exactly which queries need optimization. Reviewing execution plans (B) is critical because PostgreSQL's query optimizer uses different statistics and algorithms than Oracle's. Queries may need hints, index adjustments, or rewriting to perform optimally with PostgreSQL's cost-based optimizer.

- **Why C is incorrect:** Simply increasing instance size is a brute-force approach that may not address the root cause (suboptimal query plans). It increases costs without guaranteeing performance improvement.
- **Why D is incorrect:** Post-migration query optimization is a normal and expected part of heterogeneous database migrations. Migrating back is an extreme measure when query tuning can resolve performance issues.
- **Why E is incorrect:** DynamoDB is a NoSQL database that doesn't support the complex joins and subqueries mentioned. It would require a complete application redesign.

---

### Question 59
**Correct Answer: A**

**Explanation:** Route 53 weighted routing enables blue/green deployment by controlling the percentage of DNS traffic directed to each environment. Start with 100% on-premises (blue), then gradually shift traffic to AWS (green) — 10%, 25%, 50%, 100%. If issues arise at any point, shift traffic back to 100% on-premises immediately by updating the weights. This provides a controlled, reversible cutover.

- **Why B is incorrect:** Directly updating DNS to the AWS ALB is a "big bang" cutover without traffic control or gradual rollout. Rollback requires another DNS change with TTL propagation delay.
- **Why C is incorrect:** CloudFront origin failover is designed for high availability (primary/secondary origin), not gradual traffic shifting. It doesn't provide percentage-based traffic control.
- **Why D is incorrect:** A hardware load balancer requires managing physical infrastructure and doesn't leverage AWS-native capabilities for traffic management.

---

### Question 60
**Correct Answer: A**

**Explanation:** Amazon DocumentDB provides MongoDB compatibility with support for MongoDB 3.6, 4.0, and 5.0 APIs. Existing MongoDB drivers and application code work with DocumentDB without modification. DocumentDB handles the performance requirements (10K reads, 5K writes/second) with its distributed storage engine and provides managed features like automatic scaling, backups, and Multi-AZ high availability.

- **Why B is incorrect:** DynamoDB is a key-value/document database but doesn't support MongoDB APIs or drivers. The application would require significant code changes.
- **Why C is incorrect:** PostgreSQL with JSONB can store documents but doesn't support MongoDB query syntax or drivers. Significant application changes would be needed.
- **Why D is incorrect:** MongoDB on EC2 requires managing the database infrastructure (patching, backups, scaling, replication), which is what the company wants to avoid by using a managed service.

---

### Question 61
**Correct Answer: A**

**Explanation:** Amazon Redshift with RA3 nodes separates compute from storage, allowing independent scaling. Concurrency scaling automatically adds additional cluster capacity during peak query periods, handling the 200 concurrent analytical queries without performance degradation. Redshift Spectrum enables querying data directly in S3 without loading it into Redshift, useful for cold data or data lake integration.

- **Why B is incorrect:** RDS for PostgreSQL is a transactional database, not optimized for analytical queries on 50 TB datasets with 200 concurrent users. It lacks columnar storage and MPP (massively parallel processing).
- **Why C is incorrect:** Aurora MySQL with parallel query improves analytical performance but doesn't match Redshift's purpose-built columnar storage, compression, and MPP architecture for data warehouse workloads.
- **Why D is incorrect:** Athena is serverless SQL on S3 but has higher per-query costs at this scale and doesn't provide the same performance as Redshift for complex analytical queries with 200 concurrent users.

---

### Question 62
**Correct Answer: A**

**Explanation:** This architecture re-platforms each component to its optimal AWS service. EC2 behind ALB handles the CMS application tier with auto-scaling. RDS for MySQL with read replicas offloads read-heavy queries. S3 stores assets (images, videos, documents) with virtually unlimited scalability. CloudFront caches both static assets from S3 and dynamic content from the ALB at edge locations globally, reducing page load times.

- **Why B is incorrect:** A single EC2 instance provides no high availability, no scalability, and local SSD storage means data loss if the instance fails.
- **Why C is incorrect:** Most CMS platforms (WordPress, Drupal) are not designed to run on Lambda. The CMS application requires persistent processes and file system access that Lambda doesn't support well.
- **Why D is incorrect:** Lightsail is designed for simple applications and doesn't support the enterprise features (ALB, read replicas, CloudFront integration, Auto Scaling) needed for 50,000 page views per hour.

---

### Question 63
**Correct Answer: A, B, C**

**Explanation:** Compute Optimizer (A) analyzes actual utilization data and recommends optimal instance types, addressing the under-20% CPU utilization. Reserved Instances or Savings Plans (B) provide up to 72% savings for the predictable baseline workload. Auto Scaling with scheduled and dynamic scaling (C) ensures business-hours workloads run only when needed and can handle traffic spikes with the right number of instances.

- **Why D is incorrect:** Spot Instances can be interrupted with 2-minute notice. Using them for all instances (including business-critical ones) creates reliability risks. Spot should be used selectively for fault-tolerant workloads.
- **Why E is incorrect:** Larger instances don't reduce costs — they typically increase them. The problem is over-provisioning, not insufficient instance count.
- **Why F is incorrect:** Moving all workloads to Lambda requires complete application re-architecture, which is not a post-migration optimization. Lambda may not be suitable for all workload types.

---

### Question 64
**Correct Answer: A, B, C**

**Explanation:** AWS Glue (A) replaces SSIS packages for ETL — it provides visual ETL design, supports PySpark and Python, and can read from/write to databases, S3, and other data stores. EventBridge with Lambda (B) replaces SQL Server Agent — EventBridge provides scheduled events (cron expressions) that trigger Lambda functions for job execution, monitoring, and alerting. Amazon QuickSight (C) replaces SSRS — it provides business intelligence reporting, dashboards, and scheduled report delivery (email subscriptions).

- **Why D is incorrect:** Kinesis is a streaming data service for real-time data ingestion, not a replacement for SSIS batch ETL processes.
- **Why E is incorrect:** Step Functions orchestrates workflows but doesn't provide the reporting, visualization, or dashboard capabilities that SSRS offers.
- **Why F is incorrect:** SQS is a message queuing service. It can trigger processing but doesn't provide the scheduling, job management, and monitoring capabilities of SQL Server Agent.

---

### Question 65
**Correct Answer: B**

**Explanation:** The correct decommission sequence starts with verification: check VPC Flow Logs and Direct Connect CloudWatch metrics to confirm no traffic is flowing. Then remove dependencies: update route tables to remove Direct Connect routes, update DNS entries pointing to on-premises resources, and verify applications don't depend on the connection. Then decommission virtual interfaces. Finally, terminate the Direct Connect connection and the physical cross-connect.

- **Why A is incorrect:** Immediately terminating the connection without verification could disrupt services that still depend on it (forgotten applications, DNS entries, background processes).
- **Why C is incorrect:** Migrating to VPN before decommissioning adds unnecessary cost and complexity. If no traffic flows over Direct Connect, there's nothing to migrate.
- **Why D is incorrect:** Keeping the connection active indefinitely incurs unnecessary monthly costs (port fees, cross-connect charges) for a decommissioned data center.

---

*End of Practice Exam 20*
