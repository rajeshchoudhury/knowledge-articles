# Practice Exam 33 - AWS Solutions Architect Associate (SAA-C03) - VERY HARD

## Migration & Hybrid Cloud Deep Dive

### Instructions
- **65 questions** | **130 minutes** | Difficulty: **VERY HARD**
- Mix of multiple choice (single answer) and multiple response (select 2-3)
- Harder than the real SAA-C03 exam
- **Passing score: 720/1000**

### Domain Distribution
| Domain | Questions |
|--------|-----------|
| Security | ~20 |
| Resilient Architecture | ~17 |
| High-Performing Architecture | ~16 |
| Cost-Optimized Architecture | ~12 |

---

### Question 1
Meridian Financial Group is migrating 500 servers from three on-premises data centers to AWS. The company has completed an initial assessment using AWS Application Discovery Service with agentless discovery via the Discovery Connector. The CTO now requires dependency mapping between application tiers to plan migration waves. The agentless discovery data shows server utilization but lacks inter-server communication patterns. What should the solutions architect recommend to obtain complete dependency mapping while minimizing disruption to production workloads?

A) Deploy the AWS Application Discovery Agent on all 500 servers to collect network connection data, process utilization, and TCP/UDP traffic information, then use AWS Migration Hub to visualize application groupings  
B) Re-deploy the Discovery Connector with enhanced logging enabled and configure VPC Flow Logs on the AWS side to capture all traffic patterns  
C) Use AWS Migration Hub import functionality to upload manually collected netstat data from each server in CSV format  
D) Deploy Amazon CloudWatch agent on all on-premises servers and use CloudWatch ServiceLens to map dependencies  

---

### Question 2
A healthcare company is migrating an Oracle 11g database (4 TB, 200+ stored procedures, materialized views, and Oracle-specific PL/SQL packages) to Amazon Aurora PostgreSQL. The database serves a critical patient records application with a maximum allowable downtime of 2 hours. The DBA team has limited PostgreSQL experience. Which migration approach addresses ALL constraints? **(Select TWO)**

A) Use AWS Schema Conversion Tool (SCT) to convert the Oracle schema, stored procedures, and PL/SQL packages to PostgreSQL-compatible code, generating an assessment report highlighting items requiring manual conversion  
B) Use AWS Database Migration Service (DMS) with a full-load plus CDC replication task to migrate data while keeping the source Oracle database operational, performing a cutover during a 2-hour maintenance window  
C) Export the Oracle database using Oracle Data Pump, upload to S3, and import into Aurora PostgreSQL using the aws_s3 extension  
D) Use the AWS DMS Schema Conversion feature to automatically convert all PL/SQL stored procedures without any manual intervention  
E) Create an Aurora PostgreSQL read replica of the Oracle database for seamless migration  

---

### Question 3
Titan Manufacturing operates a factory floor with 2,000 IoT sensors generating 50 GB of data daily. The data must be processed locally for real-time quality control decisions (latency < 10ms) and also sent to AWS for long-term analytics. The factory has intermittent internet connectivity (available 18 hours/day on average). The company has 80 TB of historical sensor data that must be migrated to S3 within 2 weeks. The factory's internet bandwidth is 100 Mbps. Which combination of services addresses ALL requirements? **(Select THREE)**

A) Deploy AWS Snowball Edge Compute Optimized devices to migrate the 80 TB of historical data and run local Lambda functions for real-time quality control processing  
B) Use AWS IoT Greengrass on local compute hardware for real-time edge processing of sensor data with local ML inference  
C) Configure AWS DataSync agent on-premises to continuously sync new sensor data to S3 when internet connectivity is available  
D) Set up a Direct Connect connection for reliable data transfer  
E) Use Amazon Kinesis Video Streams to ingest all sensor data in real time  
F) Deploy AWS Outposts rack at the factory for all processing needs  

---

### Question 4
Global Retail Corp has 15 branch offices, each with a Windows-based file server (average 2 TB per location) integrated with on-premises Active Directory. Employees access file shares using SMB protocol. The company wants to migrate file storage to AWS while maintaining the same user experience — users must continue accessing files via mapped network drives with their existing AD credentials. Files older than 30 days are rarely accessed. Which architecture meets these requirements with the LOWEST operational overhead?

A) Deploy an Amazon FSx for Windows File Server Multi-AZ file system joined to the on-premises AD domain, and configure DFS Replication between on-premises servers and FSx  
B) Deploy AWS Storage Gateway File Gateway at each branch office as a VM appliance, join each gateway to the on-premises Active Directory domain, create SMB file shares backed by S3, and configure S3 Lifecycle policies to transition objects older than 30 days to S3 Glacier Instant Retrieval  
C) Set up Amazon WorkDocs with AD Connector at each branch for file access  
D) Deploy an S3 bucket with S3 File Gateway in each region, use IAM roles mapped to AD groups via AWS SSO for access control  

---

### Question 5
NexGen Telecom is building a multi-VPC architecture across 4 AWS regions with 20 VPCs per region. Each region also needs connectivity back to two on-premises data centers via dedicated 10 Gbps links. The company requires transitive routing between all VPCs across regions and deterministic network performance. The network team wants to minimize the number of individual connections to manage. Which architecture meets these requirements?

A) Establish AWS Direct Connect connections at two locations with Transit VIFs, attach them to Transit Gateways in each region, peer the Transit Gateways across regions using inter-region peering, and attach all VPCs to their regional Transit Gateway  
B) Create VPC peering connections between all VPCs across all regions, and set up Site-to-Site VPN connections from each VPC to the on-premises data centers  
C) Deploy a single Transit Gateway in us-east-1, attach all 80 VPCs from all regions to it, and use a single Direct Connect connection  
D) Use AWS Cloud WAN with a shared Direct Connect Gateway and VPN connections to each data center  

---

### Question 6
A multinational corporation operates a hybrid DNS architecture. Their on-premises DNS servers resolve internal domains (corp.internal) while Route 53 handles AWS-hosted domains (aws.company.com). On-premises applications need to resolve AWS private hosted zone records, and AWS workloads need to resolve on-premises internal domain records. The company uses Direct Connect for connectivity. Currently, DNS resolution fails in both directions. Which solution resolves bidirectional DNS resolution? **(Select TWO)**

A) Create Route 53 Resolver inbound endpoints in the VPC and configure on-premises DNS servers to forward queries for aws.company.com to the inbound endpoint IP addresses  
B) Create Route 53 Resolver outbound endpoints in the VPC and configure Resolver rules to forward queries for corp.internal to the on-premises DNS server IP addresses  
C) Enable DNS hostnames and DNS resolution on the VPC, then add the on-premises DNS server as a secondary DNS in the VPC DHCP options set  
D) Create a Route 53 public hosted zone for corp.internal and replicate all on-premises DNS records  
E) Configure Route 53 Resolver forwarding rules on the on-premises DNS servers directly  

---

### Question 7
Apex Digital Media is migrating 200 Windows Server 2016 VMs running IIS web applications with SQL Server 2017 backends from VMware vSphere to AWS. The migration must maintain application functionality without code changes. The team has a 6-month timeline. They want to use AWS Application Migration Service (MGN). The on-premises environment has a 1 Gbps internet connection shared across all business operations. The initial data replication for all servers totals approximately 60 TB. Which approach ensures successful migration within the timeline while minimizing impact on production network bandwidth? **(Select TWO)**

A) Install the AWS MGN replication agent on all servers simultaneously and configure bandwidth throttling to limit replication traffic to 400 Mbps during business hours, increasing to 800 Mbps during off-hours  
B) Divide the 200 servers into migration waves of 25-30 servers, stagger agent installations, and configure the staging area subnet in a dedicated VPC with appropriate replication server instance types  
C) Use AWS Snowball Edge to perform the initial data seed, then install MGN agents to handle ongoing incremental replication via CDC  
D) Set up a dedicated Direct Connect connection for MGN replication traffic, separate from business internet traffic  
E) Use AWS Server Migration Service (SMS) instead of MGN, as SMS supports VMware environments natively with incremental replication  

---

### Question 8
CloudFirst Corp is re-platforming a legacy .NET application stack consisting of IIS web servers, Windows services for background processing, and SQL Server 2019 databases. The application currently handles 10,000 concurrent users with auto-scaling needs. The CTO mandates reducing operational overhead while maintaining .NET compatibility. The application uses Windows-specific features including Windows Authentication and COM+ components. Which target architecture is MOST appropriate?

A) Deploy the web tier on AWS Elastic Beanstalk with a Windows Server platform, use Amazon SQS for background processing triggered by Lambda functions (.NET runtime), and migrate SQL Server to Amazon Aurora PostgreSQL  
B) Containerize the application in Windows containers on Amazon ECS with EC2 launch type (Windows AMIs), use Amazon RDS for SQL Server Multi-AZ for the database, and replace Windows services with ECS tasks for background processing  
C) Deploy on Amazon EKS with Windows node groups, migrate to Aurora MySQL, and rewrite Windows services as Linux-compatible microservices  
D) Lift-and-shift to EC2 Windows instances in an Auto Scaling group behind an ALB, maintain SQL Server on EC2, and keep Windows services running on the same EC2 instances  

---

### Question 9
A European bank processes mainframe COBOL batch jobs that generate daily regulatory reports. The mainframe lease expires in 18 months. The batch jobs process 2 million transactions nightly and generate reports required by multiple EU regulators. The bank cannot rewrite the application in a modern language due to the complexity of financial calculations embedded in 500,000 lines of COBOL code. Regulatory compliance requires that calculation logic remains verifiably identical after migration. Which migration approach is MOST suitable?

A) Use AWS Blu Age to automatically refactor the COBOL code into Java microservices, deploy on Amazon ECS Fargate, and implement automated testing to verify calculation parity with the mainframe output  
B) Rewrite all COBOL programs manually in Python and deploy on AWS Lambda for serverless batch processing  
C) Use Micro Focus Enterprise Server on Amazon EC2 to run the existing COBOL code unchanged in a mainframe-compatible runtime environment  
D) Convert all COBOL batch jobs to AWS Step Functions workflows with Lambda functions for each processing step  

---

### Question 10
QuickMove Logistics must evacuate its primary data center within 90 days due to a lease termination. The data center runs 800 VMs on VMware vSphere 7.0. The company has no prior AWS experience and cannot afford application downtime during migration. The IT team has 12 engineers with strong VMware expertise but limited AWS knowledge. Which approach enables the FASTEST migration while leveraging existing team skills?

A) Deploy VMware Cloud on AWS, use VMware HCX to perform live vMotion of all 800 VMs with zero downtime, then gradually re-architect applications to use native AWS services  
B) Use AWS Application Migration Service (MGN) to replicate all 800 VMs simultaneously to EC2 instances  
C) Export all VMs as OVA files, upload to S3, and use VM Import/Export to create AMIs  
D) Hire an AWS consulting partner to redesign all applications as cloud-native before migrating  

---

### Question 11
A pharmaceutical company must run clinical trial data processing workloads on-premises due to regulatory requirements that mandate data residency within their own facility. However, they want to use the same ECS APIs, task definitions, and container images they use in AWS. The on-premises environment runs RHEL 8 servers. The company also needs centralized monitoring of both on-premises and cloud workloads through a single pane of glass. Which solution meets these requirements?

A) Deploy Amazon ECS Anywhere by registering on-premises RHEL servers as ECS external instances, use the same task definitions with the EXTERNAL launch type, and configure CloudWatch agent on each instance for centralized monitoring  
B) Install Amazon EKS Distro on the on-premises servers, deploy workloads using Kubernetes manifests, and use Prometheus for monitoring  
C) Deploy AWS Outposts servers at the facility to run standard ECS workloads with native CloudWatch integration  
D) Set up a self-managed Kubernetes cluster on-premises and manually replicate ECS task definitions as Kubernetes deployments  

---

### Question 12
DataSovereign GmbH, a German financial services firm, must ensure that specific workloads processing German customer PII remain within a facility they physically control while still having sub-millisecond latency to AWS services in eu-central-1. They need to run Amazon RDS, Amazon ECS, and use Application Load Balancers. Their compliance team requires that AWS hardware be installed in their own data center. Which solution meets ALL requirements?

A) Deploy an AWS Outposts rack in their data center, run RDS on Outposts, ECS on Outposts, and ALB on Outposts, with a low-latency connection back to the parent region eu-central-1  
B) Use AWS Local Zones in Frankfurt for low-latency workloads and configure VPN tunnels to their data center  
C) Deploy workloads in eu-central-1 with a Direct Connect dedicated connection and encrypt all data in transit  
D) Use AWS Wavelength zones deployed at a nearby telecom provider's edge location in Germany  

---

### Question 13
VividStream Media produces live 4K video content and needs real-time video editing capabilities. Their editors located in Los Angeles require sub-5ms latency to GPU-accelerated rendering instances. The nearest AWS Region (us-west-2 in Oregon) introduces 15-20ms latency. The company needs NVIDIA GPU instances (G5 or equivalent) and Amazon FSx for Lustre for shared high-speed storage. Which solution provides the LOWEST latency for the LA-based editors?

A) Deploy GPU instances and FSx for Lustre in the AWS Local Zone in Los Angeles (us-west-2-lax-1), connect editors directly to the Local Zone resources over the local network  
B) Deploy GPU instances in us-west-2, use AWS Global Accelerator to reduce latency to sub-5ms  
C) Set up a Direct Connect connection from the LA office to us-west-2, request a dedicated 100 Gbps link  
D) Deploy on-premises GPU servers and use AWS Outposts for FSx for Lustre storage  

---

### Question 14
SwiftRide, a ride-sharing startup, is building a feature that processes driver location updates and matches riders to nearby drivers. The feature requires single-digit millisecond processing at the mobile network edge to minimize location update latency for riders on 5G networks. The application is containerized and needs access to the carrier's 5G network directly. Which AWS infrastructure option is MOST appropriate?

A) Deploy the matching service on Amazon ECS in an AWS Wavelength Zone attached to the 5G carrier's network, using Wavelength-specific subnets for direct carrier integration  
B) Deploy in the nearest AWS Local Zone and use carrier-grade NAT for 5G traffic  
C) Deploy in the parent AWS Region with AWS Global Accelerator using the carrier's IP address pool  
D) Use Amazon CloudFront Lambda@Edge to process location updates at edge locations nearest to 5G towers  

---

### Question 15
A company with 5,000 employees is migrating to AWS and must decide on an identity strategy. Their on-premises Active Directory has 3 forests with trust relationships. Requirements: (1) AWS applications need LDAP authentication, (2) Amazon RDS for SQL Server needs Windows Authentication, (3) Amazon WorkSpaces needs AD integration, (4) The company wants to maintain their on-premises AD as the primary identity source with NO user or schema replication to the cloud. Which AD integration approach is CORRECT?

A) Deploy AWS Directory Service AD Connector in AWS, pointing to the on-premises AD via Direct Connect, which proxies all authentication requests to on-premises without storing any directory data in AWS  
B) Deploy AWS Managed Microsoft AD with a one-way trust relationship to the on-premises AD, replicate a subset of users to AWS  
C) Deploy AWS Managed Microsoft AD with a two-way forest trust to the on-premises AD forests  
D) Configure SAML-based federation with on-premises AD FS for all services  

---

### Question 16
An insurance company is migrating a 10 TB Oracle Data Warehouse to Amazon Redshift. The warehouse has complex ETL processes using Oracle-specific SQL extensions, 500+ materialized views, and Oracle partitioning. The business requires that the migrated warehouse produces identical query results. Migration must complete within 3 months. Which approach is MOST effective? **(Select TWO)**

A) Use AWS Schema Conversion Tool (SCT) to convert the Oracle Data Warehouse schema to Redshift, reviewing the conversion assessment report for items requiring manual SQL rewriting  
B) Use AWS DMS with a full-load task to migrate the data from Oracle to Redshift, handling data type mappings and large object conversions  
C) Export all Oracle tables as CSV files to S3 and use the Redshift COPY command to load them  
D) Use AWS Glue to automatically replicate the Oracle materialized views as Glue jobs  
E) Create Oracle database links from Redshift to query Oracle data directly during migration  

---

### Question 17
A global e-commerce company wants to implement a blue/green deployment strategy for a major database migration from MySQL 5.7 on EC2 to Aurora MySQL 3.0. The database is 2 TB with 50,000 transactions per second at peak. They need the ability to instantly roll back to the original MySQL 5.7 database if issues are detected within 4 hours of cutover. Which approach provides the safest migration with instant rollback capability?

A) Create an Aurora MySQL read replica of the EC2 MySQL instance using binary log replication, promote the Aurora replica as the new primary during cutover, and maintain reverse replication from Aurora back to the EC2 MySQL instance for rollback capability  
B) Use AWS DMS with full-load plus CDC from MySQL on EC2 to Aurora MySQL, stop CDC during cutover and redirect application connections. For rollback, set up a reverse DMS task from Aurora back to EC2 MySQL  
C) Take a snapshot of the MySQL database, restore it as an Aurora MySQL cluster, and keep the original EC2 MySQL instance running. Use Route 53 weighted routing to gradually shift traffic  
D) Use mysqldump to export the database during a maintenance window and import into Aurora MySQL  

---

### Question 18
A media company has a hybrid architecture with workloads in us-east-1 and an on-premises data center. They are expanding to eu-west-1 and ap-southeast-1. Each region will have 10 VPCs. All VPCs must communicate with each other and with the on-premises data center. The company already has a 10 Gbps Direct Connect connection in us-east-1. They need to extend on-premises connectivity to all three regions WITHOUT provisioning additional physical Direct Connect connections. Which architecture achieves this? **(Select TWO)**

A) Create a Direct Connect Gateway and associate it with Transit Gateways in all three regions, using the existing Direct Connect connection with Transit VIFs  
B) Configure inter-region Transit Gateway peering between us-east-1, eu-west-1, and ap-southeast-1 to enable transitive routing between all VPCs across regions  
C) Set up VPC peering between every pair of VPCs across all three regions  
D) Create VPN connections from the on-premises data center to each region over the internet  
E) Use a single Transit VIF connected to a single Transit Gateway, then attach all VPCs from all regions to that single Transit Gateway  

---

### Question 19
A financial services company uses AWS Application Migration Service (MGN) to migrate 50 Windows servers. During testing, they discover that 10 servers with large databases (500 GB+ each) are consuming excessive bandwidth during initial replication, degrading production network performance. The staging area is configured in a public subnet. The security team also raises concerns about replication data traversing the public internet. How should the solutions architect address BOTH issues? **(Select TWO)**

A) Configure MGN replication bandwidth throttling on each server's replication agent to cap the data transfer rate during business hours  
B) Move the MGN staging area to a private subnet and establish a Site-to-Site VPN or Direct Connect for replication traffic, so data does not traverse the public internet  
C) Increase the internet bandwidth at the on-premises data center to accommodate the replication traffic  
D) Disable initial replication and rely only on CDC for incremental changes  
E) Use AWS Transfer Family SFTP endpoints to replicate server data to S3 instead of using MGN  

---

### Question 20
A company with strict compliance requirements is migrating SAP HANA workloads to AWS. The SAP HANA database requires 6 TB of memory, dedicated host tenancy for licensing compliance, and consistent sub-microsecond storage latency. The compliance team mandates that the physical host is not shared with any other AWS customer. Which instance configuration meets ALL requirements?

A) High-Memory instances (u-6tb1.metal) on Dedicated Hosts with Amazon EBS io2 Block Express volumes  
B) x2idn.metal instances in a placement group on Dedicated Instances with instance store NVMe  
C) r6i.metal instances on Dedicated Hosts with Amazon FSx for Lustre  
D) u-6tb1.112xlarge on On-Demand instances with gp3 EBS volumes in a spread placement group  

---

### Question 21
A logistics company operates a fleet management application that must work during internet outages at warehouse locations. The application runs in containers and needs access to DynamoDB and S3 APIs locally. When connectivity is restored, data must automatically synchronize with the cloud. The warehouse has standard server hardware running Amazon Linux 2. Which architecture provides the MOST seamless offline capability?

A) Deploy AWS IoT Greengrass on the warehouse servers with Greengrass connectors for local DynamoDB-compatible access using the stream manager for S3 synchronization when connectivity returns  
B) Deploy Amazon ECS Anywhere on the warehouse servers, run a local DynamoDB instance in a container, and write custom sync scripts  
C) Install AWS Outposts servers at each warehouse for fully managed local AWS services  
D) Pre-download all data to local SQLite databases and build custom REST APIs that replicate to DynamoDB on reconnection  

---

### Question 22
A company is designing a disaster recovery strategy for its multi-tier application spanning two AWS Regions. The application uses Aurora MySQL, ElastiCache Redis, and ECS Fargate. The business mandates RPO of 1 second and RTO of 5 minutes. During normal operations, the DR region should serve read traffic. The company also requires that the DNS failover happens automatically based on application-level health checks (not just TCP checks). Which combination provides the MOST reliable failover? **(Select THREE)**

A) Deploy Aurora Global Database with the secondary cluster in the DR region configured with 2 reader instances to serve read traffic  
B) Configure ElastiCache Global Datastore for Redis to replicate cache data to the DR region  
C) Create Route 53 health checks that invoke a Lambda function to verify application-level health (e.g., test login flow, database connectivity), and configure failover routing policies  
D) Use AWS Global Accelerator with endpoint health checks for automatic failover  
E) Configure CloudWatch cross-region alarms to trigger an EventBridge rule that manually updates Route 53 records  
F) Deploy ElastiCache clusters independently in each region and warm them on failover  

---

### Question 23
A media company processes large video files (average 50 GB each). Editors upload files to an on-premises NAS, and transcoding jobs run overnight. The company wants to move transcoding to AWS while keeping the upload experience unchanged for editors. New files should be available in S3 within 15 minutes of being saved to the NAS. Completed transcoded files must be accessible from the NAS for editor review. Which solution provides bidirectional synchronization with minimal latency?

A) Deploy AWS Storage Gateway File Gateway on-premises, configure an SMB/NFS share backed by an S3 bucket, use S3 event notifications to trigger MediaConvert transcoding jobs, write output to a separate S3 prefix that the File Gateway automatically reflects back to the on-premises share via RefreshCache API invocations on a schedule  
B) Use AWS DataSync to copy files from NAS to S3 every 15 minutes, transcode in AWS, and run a reverse DataSync task for completed files  
C) Set up AWS Transfer Family with SFTP to upload files, configure S3 event triggers for transcoding, and sync back via SFTP  
D) Use rsync scripts running on a cron job to sync files between NAS and an EC2 instance with an EBS volume  

---

### Question 24
OceanView Hotels has 200 properties worldwide, each with a local Active Directory domain controller. The corporate IT team wants to deploy Amazon WorkSpaces at each property for front-desk staff. Each property must authenticate against its local AD. The company cannot deploy additional AD infrastructure at each property. The total user count is 3,000 (15 per property). Which solution minimizes infrastructure and cost while meeting authentication requirements?

A) Deploy one AD Connector per property in the nearest AWS Region, pointing to each property's local AD via Site-to-Site VPN, and provision WorkSpaces in each Region  
B) Deploy a single AWS Managed Microsoft AD in a central region, establish trust relationships with all 200 property AD domains, and use WorkSpaces with cross-region redirection  
C) Consolidate all 200 property ADs into a single on-premises AD forest, deploy AD Connector in AWS, and provision all WorkSpaces centrally  
D) Deploy one AD Connector in a single region pointing to a global AD management server, with VPN connections to all properties  

---

### Question 25
A SaaS company hosts a multi-tenant application. Each tenant's data is stored in a separate DynamoDB table. The company has 500 tenants and is growing. The operations team reports difficulty managing 500+ DynamoDB tables. A new requirement mandates that each tenant can only access their own data, and a "super admin" role can access all tenant data. IAM policies are becoming unmanageable. Which approach simplifies management while enforcing tenant isolation? **(Select TWO)**

A) Consolidate all tenant data into a single DynamoDB table using a composite primary key with tenant ID as the partition key, and use IAM policy conditions with dynamodb:LeadingKeys to restrict each tenant to rows matching their tenant ID  
B) Implement DynamoDB fine-grained access control using IAM policy conditions on dynamodb:LeadingKeys for the consolidated table, and create a separate IAM role for the super admin without the LeadingKeys condition  
C) Keep 500 separate tables and use AWS Organizations SCPs to control access  
D) Move to Amazon RDS with PostgreSQL Row-Level Security (RLS) for tenant isolation  
E) Use Amazon Cognito identity pools to generate temporary credentials with IAM policies scoped to each tenant's partition key prefix  

---

### Question 26
A gaming company runs a real-time leaderboard system on ElastiCache for Redis. The current single-node r6g.2xlarge instance handles 200,000 reads/second but frequently experiences memory pressure at 80% utilization during tournaments. The application uses Redis Sorted Sets for leaderboard rankings. During peak events, the node has hit 100% memory and evicted keys. The company needs to scale to 1 million reads/second during major tournaments without data loss. Which scaling approach is MOST appropriate?

A) Enable Redis Cluster Mode on the ElastiCache cluster with 5 shards and 2 replicas per shard, redistributing the Sorted Sets across shards using hash tags for related leaderboards, and configure read replicas for read scaling  
B) Upgrade to the largest available r6g.16xlarge instance to handle all traffic on a single node  
C) Deploy multiple standalone Redis clusters behind an application-level load balancer  
D) Switch to DynamoDB with DAX for leaderboard functionality  

---

### Question 27
A healthcare company must migrate its HIPAA-regulated application from on-premises to AWS. The application stores Protected Health Information (PHI) in a SQL Server database and uses file shares for medical imaging files (DICOM format). Requirements: (1) PHI must be encrypted at rest with keys that the company controls and can audit, (2) All access to PHI must be logged, (3) The company must be able to immediately revoke access to all PHI without deleting data, (4) Network traffic containing PHI must not traverse the public internet. Which architecture meets ALL requirements? **(Select THREE)**

A) Use AWS KMS customer managed keys (CMK) for encryption, with key policies granting access only to authorized roles and CloudTrail logging all KMS API calls  
B) Deploy Amazon RDS for SQL Server with encryption enabled using the KMS CMK, enable RDS activity logging, and configure the RDS instance in a private subnet  
C) Store medical images in S3 with SSE-KMS encryption, enable S3 access logging and CloudTrail data events for the bucket, and use a VPC endpoint (Gateway) for S3 access  
D) Use S3 SSE-S3 (AES-256) encryption for medical images to simplify key management  
E) Connect to on-premises via Site-to-Site VPN over the internet for database migration  
F) Immediately revoke access by disabling the KMS CMK, which instantly prevents decryption of all PHI across RDS and S3  

---

### Question 28
A company operates a legacy Oracle RAC (Real Application Clusters) database with shared storage on Oracle ASM. The database supports an ERP application with 99.99% availability requirements. The RAC configuration provides both high availability and horizontal read scaling. Which AWS architecture provides equivalent functionality? **(Select TWO)**

A) Deploy Amazon Aurora PostgreSQL with multiple reader instances behind a reader endpoint, providing horizontal read scaling similar to Oracle RAC reader nodes  
B) Configure Aurora with Multi-AZ deployment (writer in one AZ, readers in different AZs) for high availability equivalent to Oracle RAC failover  
C) Deploy Oracle RAC on EC2 using placement groups and Amazon FSx for ONTAP as shared storage  
D) Use Amazon RDS for Oracle Multi-AZ with a single standby instance for equivalent functionality  
E) Deploy multiple standalone RDS Oracle instances with application-level sharding  

---

### Question 29
A data analytics company processes 10 TB of clickstream data daily. The raw data lands in S3, undergoes ETL processing, and is loaded into Redshift for reporting. The ETL process currently runs on a Hadoop cluster on-premises and takes 6 hours. The company wants to migrate the ETL pipeline to AWS and reduce processing time to under 2 hours while minimizing operational overhead. The ETL logic includes complex Spark transformations. Which approach is MOST appropriate?

A) Use AWS Glue with Spark ETL jobs, leveraging Glue auto-scaling and G.2X worker types for memory-intensive transformations, reading from S3 and writing directly to Redshift using the Glue Redshift connector  
B) Deploy Amazon EMR on EC2 with a persistent cluster running Spark, sized with memory-optimized instances, and maintain it 24/7  
C) Rewrite all Spark transformations as AWS Lambda functions triggered by S3 events  
D) Use Amazon Kinesis Data Firehose to transform data in-flight and load into Redshift  

---

### Question 30
A company is implementing AWS Landing Zone for a new multi-account strategy. They need to set up networking that ensures all internet-bound traffic from workload accounts passes through a centralized inspection VPC with third-party firewall appliances. The design must support 50+ VPCs across 3 Regions. Which architecture enforces centralized internet egress? **(Select TWO)**

A) Deploy a Transit Gateway in each region with a centralized inspection VPC attached. Configure Transit Gateway route tables so that all default routes (0.0.0.0/0) from spoke VPC attachments point to the inspection VPC attachment  
B) In the inspection VPC, deploy third-party firewall appliances behind a Gateway Load Balancer, and configure Transit Gateway appliance mode for the inspection VPC attachment  
C) Use AWS Network Firewall in each spoke VPC for distributed inspection  
D) Remove internet gateways from all spoke VPCs and use VPC peering to route traffic through the inspection VPC  
E) Configure NAT gateways in each spoke VPC and use security groups to restrict outbound traffic  

---

### Question 31
Stratosphere Analytics operates a data lake on S3 with 500 TB of data. They currently use Athena for ad-hoc queries but are experiencing slow performance on queries that scan large datasets. The data is stored in JSON format across 2 million small files (average 250 KB each). Query performance is 10x slower than expected. Which combination of optimizations will yield the GREATEST performance improvement? **(Select TWO)**

A) Convert the JSON data to Apache Parquet format using AWS Glue ETL jobs, applying Snappy compression to reduce data scanning  
B) Consolidate the 2 million small files into larger files (128 MB - 1 GB) using AWS Glue compaction jobs with the groupFiles and groupSize parameters  
C) Enable S3 Transfer Acceleration on the data lake bucket  
D) Increase the number of Athena DPU (Data Processing Units) using the provisioned capacity feature  
E) Create an Amazon CloudFront distribution in front of the S3 bucket to cache query results  

---

### Question 32
A financial services firm needs to run containerized trading algorithms. The containers require: (1) GPU access for ML inference, (2) persistent storage that survives container restarts, (3) the ability to scale from 5 containers to 500 containers within 60 seconds during market volatility, (4) containers must be isolated at the hardware level for security. Which compute platform meets ALL requirements?

A) Amazon ECS on EC2 with GPU-optimized instances (p4d.24xlarge) using Cluster Auto Scaling with capacity providers, EBS volumes mounted via the ECS volume plugin, and instances launched as Dedicated Instances for hardware isolation  
B) Amazon EKS on Fargate with GPU support, EFS for persistent storage, and Fargate isolation  
C) Amazon ECS on Fargate with GPU support, EFS for persistent storage, and Fargate-level isolation  
D) AWS Lambda with container image support, using Lambda layers for GPU libraries  

---

### Question 33
A company uses AWS Organizations with 100 accounts. The security team must ensure that ALL S3 buckets across ALL accounts are encrypted with customer managed KMS keys (no SSE-S3 allowed). They also need to detect and auto-remediate any non-compliant buckets within 1 hour. Which approach provides BOTH preventive and detective controls? **(Select TWO)**

A) Create an SCP attached to the Organization root that denies s3:PutObject when the encryption header is not aws:kms, and denies s3:CreateBucket when default encryption is not configured with a CMK  
B) Deploy an AWS Config rule (using a conformance pack deployed via CloudFormation StackSets) across all accounts that checks for S3 bucket encryption with CMK, with automatic remediation using SSM Automation documents that enable CMK encryption on non-compliant buckets  
C) Use AWS Security Hub with the S3 encryption finding type, manually review findings weekly  
D) Enable Amazon Macie across all accounts to detect unencrypted S3 buckets  
E) Use IAM policies in each account to deny unencrypted S3 operations  

---

### Question 34
A company runs a critical PostgreSQL database on Amazon RDS. The database experiences heavy read traffic (90% reads, 10% writes) during business hours and batch processing (80% writes) overnight. During business hours, read latency must be under 5ms. The database is 500 GB. The current db.r6g.2xlarge instance is at 85% CPU during peak hours. Which optimization strategy provides the BEST read performance during business hours while handling overnight batch writes cost-effectively?

A) Create 3 RDS read replicas, configure the application to use the reader endpoint for read traffic during business hours, and use the writer instance for overnight batch processing. Scale down one replica during overnight hours when read traffic is minimal  
B) Upgrade to db.r6g.4xlarge to handle peak load on a single instance  
C) Migrate to Aurora PostgreSQL with auto-scaling read replicas (min 1, max 5) configured to scale based on CPU utilization, using the Aurora reader endpoint for read traffic  
D) Add an ElastiCache Redis cluster in front of the database for all read traffic  

---

### Question 35
An e-commerce company is planning a migration of 300 servers to AWS. During the planning phase using AWS Application Discovery Service, they identified 15 application groups. Three application groups have complex dependencies between them and cannot be migrated independently. The migration team wants to visualize server dependencies and plan migration waves. Which approach provides the MOST comprehensive migration planning? **(Select TWO)**

A) Use the AWS Migration Hub console to view the network dependency map generated from Application Discovery Agent data, identifying inter-server communication patterns and grouping servers into application groups  
B) Create migration waves in AWS Migration Hub, placing the three interdependent application groups in the same migration wave, and validating with a test migration to a non-production environment  
C) Use AWS CloudFormation to template the on-premises infrastructure and replicate it in AWS  
D) Manually draw architecture diagrams and plan migration waves in a spreadsheet  
E) Use AWS Migration Evaluator to generate a business case instead of dependency mapping  

---

### Question 36
A company runs an application on EC2 instances behind an Application Load Balancer. The application requires sticky sessions because it stores user session data in local memory. During a scaling event, users with active sessions on terminated instances lose their session. The company wants to eliminate session stickiness while maintaining session persistence. What is the BEST approach?

A) Externalize session data to an ElastiCache Redis cluster with Multi-AZ enabled, remove ALB sticky sessions, and configure the application to read/write session data from Redis using the session ID stored in a client-side cookie  
B) Enable ALB sticky sessions with a longer duration (24 hours) and configure the Auto Scaling group to use a termination policy that protects instances with active sessions  
C) Store session data in DynamoDB using the DynamoDB Session Handler, configure TTL on session records, and remove sticky sessions from the ALB  
D) Use Network Load Balancer instead of ALB because NLB maintains persistent TCP connections  

---

### Question 37
A healthcare SaaS provider serves 50 hospital clients. Each hospital's data must be completely isolated in separate AWS accounts within an AWS Organization. All hospitals need access to a shared services VPC (hosting centralized logging, monitoring, and a container registry). Each hospital account has 3 VPCs (production, staging, development). The company currently manages 150 VPC peering connections and is struggling with operational complexity. Which architecture reduces management overhead? **(Select TWO)**

A) Deploy an AWS Transit Gateway and attach all hospital VPCs and the shared services VPC, using Transit Gateway route tables to control which hospital VPCs can communicate with the shared services VPC while preventing inter-hospital communication  
B) Use AWS Resource Access Manager (RAM) to share the Transit Gateway across all hospital accounts in the Organization, allowing each account to attach their VPCs  
C) Use AWS PrivateLink to create VPC endpoints for each shared service  
D) Deploy a hub-and-spoke VPN mesh using AWS Client VPN  
E) Keep VPC peering but automate management with CloudFormation StackSets  

---

### Question 38
A company is migrating a large Oracle database (15 TB) to Aurora PostgreSQL. The database has 300+ stored procedures with Oracle-specific PL/SQL syntax, sequences, synonyms, and materialized views. AWS Schema Conversion Tool (SCT) reports that 60% of stored procedures can be automatically converted, 30% require simple modifications, and 10% cannot be automatically converted. What is the CORRECT approach for the 10% that cannot be auto-converted?

A) Use the SCT assessment report to identify the specific Oracle features used in the unconvertible procedures, manually rewrite them in PL/pgSQL or as AWS Lambda functions callable via Aurora's aws_lambda extension, and use SCT's action items as a conversion checklist  
B) Keep the Oracle database running alongside Aurora and route queries for unconvertible procedures to Oracle  
C) Use AWS DMS to replicate the stored procedure logic by mirroring Oracle transaction patterns  
D) Replace all stored procedures with application-layer business logic in the application code  

---

### Question 39
NovaTech has an on-premises Kafka cluster processing 500,000 events per second for their real-time analytics platform. The cluster requires frequent capacity planning, OS patching, and manual broker rebalancing. They want to migrate to AWS with minimal application code changes while eliminating operational overhead. The Kafka producers and consumers use the standard Apache Kafka client libraries. Strict message ordering per partition is required. Which migration target is MOST suitable?

A) Amazon Managed Streaming for Apache Kafka (MSK) with provisioned capacity, configured with the same number of brokers and partition count, allowing existing Kafka clients to connect by updating the bootstrap server endpoints  
B) Amazon Kinesis Data Streams with enhanced fan-out, rewriting producers and consumers to use the Kinesis SDK  
C) Amazon SQS FIFO queues with message group IDs mapped to Kafka partition keys  
D) Self-managed Kafka on EC2 instances using the same AMI as the on-premises brokers  

---

### Question 40
A global investment bank requires that all AWS API calls across 20 accounts are logged, tamper-proof, and retained for 7 years. The logs must be searchable within 30 seconds for active investigations. Logs older than 90 days only need to be retrievable within 12 hours. The security team in a central account must have exclusive access to these logs — individual account administrators must not be able to view, modify, or delete them. Which architecture meets ALL requirements? **(Select THREE)**

A) Create an Organization trail in AWS CloudTrail that logs all accounts to a centralized S3 bucket in a dedicated log archive account  
B) Configure the S3 bucket policy to deny delete actions from all principals except the security team's IAM role, and enable S3 Object Lock in Compliance mode with a 7-year retention period  
C) Set up CloudTrail Lake in the log archive account for searchable query capability on recent logs, and configure S3 Lifecycle policies to transition objects older than 90 days to S3 Glacier Deep Archive  
D) Use CloudWatch Logs in each account with a 7-year retention period  
E) Enable CloudTrail Insights in each individual account for search capability  
F) Store all logs in Amazon DynamoDB with TTL for automatic deletion after 7 years  

---

### Question 41
A company is building a multi-region active-active application. The application writes to DynamoDB in both us-east-1 and eu-west-1 simultaneously. Users are routed to the nearest region via Route 53 latency-based routing. The company needs to handle the scenario where the same item is updated in both regions within the same second. Which DynamoDB feature and conflict resolution strategy should be used?

A) DynamoDB Global Tables (version 2019.11.21) which uses last-writer-wins reconciliation based on timestamps, and design the application to handle eventual consistency between regions with idempotent write operations  
B) DynamoDB Streams with a custom Lambda function that implements application-level conflict resolution using vector clocks  
C) DynamoDB Transactions across regions to ensure atomic writes in both regions simultaneously  
D) DynamoDB Accelerator (DAX) clusters in both regions to prevent write conflicts  

---

### Question 42
A company runs a batch processing system that processes 100,000 jobs daily. Each job takes 5-30 minutes and requires 4 vCPUs and 8 GB memory. Jobs are independent and can run in any order. The company pays for 24/7 running EC2 instances that are only 40% utilized. Which architecture provides the MOST cost-effective solution while handling burst capacity?

A) Use AWS Batch with a managed compute environment using Spot Instances as the primary capacity, with a secondary On-Demand compute environment for jobs that fail on Spot due to interruptions, leveraging AWS Batch's built-in retry logic  
B) Use an Auto Scaling group of On-Demand instances with step scaling policies based on SQS queue depth  
C) Deploy Amazon ECS on Fargate Spot for all batch jobs with retry logic in the application  
D) Use AWS Lambda with 10 GB memory and 15-minute timeout for each job  

---

### Question 43
A company is designing a network architecture for a regulated environment. Requirements: (1) All traffic between VPCs must be inspected by a third-party firewall appliance, (2) The firewall must see the original source and destination IPs, (3) Traffic must not be asymmetrically routed, (4) The solution must scale to handle 50 Gbps of inter-VPC traffic. Which architecture meets ALL requirements?

A) Deploy Gateway Load Balancer (GWLB) in a centralized security VPC with firewall appliances as targets, create GWLB endpoints in each spoke VPC, and configure Transit Gateway with appliance mode enabled on the security VPC attachment to prevent asymmetric routing  
B) Deploy Network Load Balancer in the security VPC with firewall appliances, configure Transit Gateway to route through the NLB  
C) Use AWS Network Firewall in a centralized VPC and route all inter-VPC traffic through it via Transit Gateway  
D) Deploy firewall appliances in each spoke VPC and use VPC peering for direct traffic flow  

---

### Question 44
A startup is building a serverless application. The architecture uses API Gateway → Lambda → DynamoDB. The application has an endpoint that receives 50,000 requests/second during peak. Each Lambda invocation takes 200ms and writes one item to DynamoDB. The Lambda function is in a VPC because it needs to access an ElastiCache cluster. During load testing, the team observes intermittent "Rate exceeded" errors and connection timeouts to ElastiCache. What are the MOST likely causes and solutions? **(Select TWO)**

A) Lambda functions in a VPC require ENIs in subnets; the subnets are running out of available IP addresses. Solution: ensure the Lambda subnets have sufficiently large CIDR ranges (e.g., /18 or /17) to support 50,000 concurrent ENI allocations  
B) The Lambda concurrent execution limit is being reached. Solution: request a concurrency limit increase from AWS Support and configure provisioned concurrency for the function to reduce cold start connection timeouts  
C) DynamoDB is throttling writes. Solution: switch DynamoDB to on-demand capacity mode  
D) The API Gateway REST API has a default throttle limit of 10,000 requests/second. Solution: request a throttle limit increase through AWS Support  
E) ElastiCache node is overloaded. Solution: deploy a larger Memcached cluster  

---

### Question 45
An enterprise is deploying AWS Control Tower for their multi-account setup. They need custom guardrails that prevent: (1) Any account from creating public-facing load balancers, (2) Deletion of VPC Flow Logs, (3) Modification of CloudTrail configuration. These rules must apply to ALL accounts, including new accounts provisioned through Account Factory. Which implementation approach is CORRECT?

A) Create custom Service Control Policies (SCPs) that deny elasticloadbalancing:CreateLoadBalancer when the scheme is internet-facing, deny logs:DeleteLogGroup for VPC flow log groups, and deny cloudtrail:StopLogging and cloudtrail:DeleteTrail. Register these as custom Control Tower controls or attach them to the OUs managed by Control Tower  
B) Create AWS Config rules for each requirement and deploy them via Control Tower customizations  
C) Implement these restrictions using IAM permission boundaries in the Account Factory template  
D) Use AWS Systems Manager State Manager to continuously remediate non-compliant resources  

---

### Question 46
A video streaming company uses Amazon CloudFront to deliver content globally. They notice that 30% of their content requests result in cache misses because they have 5 different cache behaviors with varying TTLs, query string configurations, and header forwarding. The origin (ALB) is receiving 3x more traffic than expected. Which combination of optimizations reduces origin load? **(Select TWO)**

A) Standardize the cache key policy across cache behaviors — only include necessary query strings and headers using a CloudFront Cache Policy. Remove the Host header and unnecessary custom headers from the cache key to increase cache hit ratio  
B) Enable Origin Shield in the region closest to the origin (ALB) to add an additional caching layer that consolidates requests from all edge locations before reaching the origin  
C) Increase the TTL on all cache behaviors to 24 hours regardless of content type  
D) Deploy additional origins in multiple regions using Route 53 latency-based routing  
E) Switch from ALB to Network Load Balancer to reduce origin processing time  

---

### Question 47
A company runs a data pipeline that ingests CSV files into S3, transforms them using AWS Glue, and loads the results into Amazon Redshift. The pipeline processes 500 new files daily. Recently, some files arrive with schema changes (new columns, renamed columns, different data types) that cause Glue jobs to fail. The team wants the pipeline to handle schema evolution gracefully without manual intervention. Which approach handles schema evolution MOST effectively?

A) Enable AWS Glue Schema Registry with schema auto-detection, configure Glue Crawlers to run before each ETL job to update the Glue Data Catalog with new schema versions, and use Glue DynamicFrames with the resolveChoice transform to handle data type conflicts and the applyMapping transform to handle renamed columns  
B) Implement strict schema validation using S3 Event Notifications that trigger a Lambda function to reject files that don't match the expected schema  
C) Use Amazon Kinesis Data Firehose with format conversion to automatically handle schema changes  
D) Write custom PySpark code on Amazon EMR to handle every possible schema variation  

---

### Question 48
A retail company wants to implement a canary deployment for their microservices running on Amazon ECS with Fargate. They need to route 5% of traffic to the new version, monitor error rates and latency for 30 minutes, and automatically roll back if error rates exceed 2%. Which approach provides AUTOMATED canary deployment with rollback?

A) Use AWS App Mesh with virtual routers to split traffic between two ECS task sets (95/5), integrate with CloudWatch alarms monitoring error rates, and use AWS CodeDeploy ECS deployment with a canary deployment configuration (Canary10Percent5Minutes) that automatically rolls back on alarm trigger  
B) Use ALB weighted target groups with manual percentage adjustment and CloudWatch dashboard monitoring  
C) Deploy two separate ECS services behind the same ALB, manually shift listener rules based on CloudWatch metrics  
D) Use Route 53 weighted routing to split traffic between two ALBs, each routing to different ECS services  

---

### Question 49
A company has a DynamoDB table with 50 GB of data that is used for both transactional processing (OLTP) and reporting (OLAP). The OLTP workload requires single-digit millisecond reads and writes. The OLAP workload runs complex aggregation queries that scan large portions of the table and are degrading OLTP performance due to consumed read capacity. Which architecture separates OLTP and OLAP workloads MOST effectively?

A) Enable DynamoDB Streams to capture all changes, use a Lambda function to write changes to an S3 bucket in Parquet format via Kinesis Data Firehose, catalog the S3 data with AWS Glue, and run OLAP queries using Amazon Athena against the S3 data  
B) Create a DynamoDB global secondary index specifically for reporting queries  
C) Enable DynamoDB on-demand capacity mode to handle both workloads  
D) Export the DynamoDB table to S3 using the DynamoDB Export to S3 feature daily, and run Athena queries against the export  

---

### Question 50
A manufacturing company has sensors in 3 factories generating 1 million events per second. Each event is 1 KB. Events must be processed in real time for anomaly detection (within 30 seconds), stored for 7 days for hot analysis, and archived for 5 years. The anomaly detection requires running windowed SQL queries on the stream. Which architecture handles ALL requirements? **(Select TWO)**

A) Ingest events using Amazon Kinesis Data Streams with sufficient shards (each shard supports 1 MB/s input), and use Amazon Managed Service for Apache Flink (formerly Kinesis Data Analytics for Apache Flink) to run windowed SQL queries for real-time anomaly detection  
B) Configure Kinesis Data Firehose connected to the Kinesis Data Stream to deliver raw events to S3 with a 7-day S3 Lifecycle policy transitioning to S3 Glacier Deep Archive for 5-year retention  
C) Use Amazon SQS to ingest all events and process with Lambda for anomaly detection  
D) Use Amazon Managed Streaming for Apache Kafka (MSK) with a 7-day retention period and Kafka Connect S3 Sink for archival  
E) Use IoT Core for ingestion and IoT Analytics for real-time processing  

---

### Question 51
A company runs a web application on EC2 instances behind an ALB. The security team discovers that the application is vulnerable to SQL injection and cross-site scripting (XSS) attacks. They also need to block requests from specific countries (North Korea, Iran) and rate-limit requests to 2,000 per 5 minutes per IP address. The solution must be deployable within 24 hours. Which approach provides the MOST comprehensive protection?

A) Associate AWS WAF with the ALB, deploy the AWS Managed Rules Core Rule Set (CRS) and SQL Database rule groups for SQL injection and XSS protection, create a geo-match rule to block traffic from specified countries, and add a rate-based rule with a threshold of 2,000 per 5 minutes  
B) Deploy a third-party WAF appliance on EC2 in front of the ALB within 24 hours  
C) Configure ALB security groups to block specific IP ranges from targeted countries  
D) Use AWS Shield Advanced with custom DDoS protections for all attack types  

---

### Question 52
A company is designing a solution to process credit card payments. They must comply with PCI DSS. The card data flows from the customer's browser through an ALB to EC2 instances in private subnets. The company needs to store credit card numbers for recurring billing but minimize the scope of PCI DSS compliance. Which architecture BEST reduces PCI scope? **(Select TWO)**

A) Implement tokenization — use a dedicated PCI-compliant tokenization service (e.g., third-party or a minimal set of EC2 instances in an isolated PCI VPC) to replace credit card numbers with tokens before the data reaches the main application tier  
B) Store the actual card numbers encrypted with AWS KMS in the main application's DynamoDB table, and rely on encryption at rest for PCI compliance  
C) Ensure only the tokenization service and its supporting infrastructure (the isolated PCI VPC) are in the PCI DSS scope, while the main application VPC handles only tokens and is outside of PCI scope  
D) Store credit card data in S3 with SSE-S3 encryption to satisfy PCI requirements  
E) Process all payments client-side using JavaScript to avoid server-side PCI scope entirely  

---

### Question 53
A financial services company runs Amazon Aurora PostgreSQL with a 2 TB database. They need a point-in-time recovery test every quarter. The test requires restoring the database to a specific second and validating data integrity, which takes 4 hours. During the test, the restored database must be accessible for validation queries but not impact the production database performance. The company wants to minimize cost of quarterly testing. Which approach is MOST cost-effective?

A) Use Aurora's point-in-time recovery to restore to a new Aurora cluster, perform the 4-hour validation using a smaller instance class (e.g., db.r6g.large instead of the production db.r6g.4xlarge), then delete the restored cluster immediately after validation  
B) Create an Aurora clone for point-in-time testing since cloning is instantaneous and cost-effective  
C) Use Aurora Backtrack to roll the production database to the desired point in time, run validation queries, then backtrack forward to the present  
D) Restore from an automated snapshot to a new RDS PostgreSQL (not Aurora) instance for cost savings  

---

### Question 54
An IoT company has 100,000 devices publishing MQTT messages to AWS IoT Core. Each device publishes once per minute. The messages must be processed by three independent downstream systems: (1) real-time alerting, (2) device state management in DynamoDB, (3) long-term storage in S3. Devices occasionally reconnect and republish messages, causing duplicates. Which architecture ensures reliable delivery to all three systems while handling duplicates?

A) Configure three IoT Core rules — one that triggers a Lambda function for alerting, one that uses the DynamoDB action to update device state using the device ID as the partition key (which naturally handles duplicates via upsert), and one that routes to Kinesis Data Firehose for batched delivery to S3 with deduplication handled by the partition key in S3 prefix naming  
B) Route all messages to a single SQS FIFO queue with content-based deduplication, then fan out to three Lambda consumers  
C) Send all messages to Amazon SNS with three subscriptions — Lambda, Kinesis, and SQS  
D) Write all messages to a single Kinesis Data Stream with three independent Kinesis Client Library (KCL) consumers  

---

### Question 55
A company needs to deploy an application that requires exactly 8 EC2 instances spread across exactly 2 Availability Zones (4 per AZ) in us-east-1. If one AZ fails, the application can tolerate running with 4 instances temporarily but must launch 4 replacement instances in a third AZ within 5 minutes. Which Auto Scaling configuration achieves this?

A) Create an Auto Scaling group with min=8, max=12, desired=8, across 3 AZs (us-east-1a, 1b, 1c) with AZ rebalancing enabled. The ASG will initially distribute instances across available AZs, and if one AZ becomes impaired, it automatically launches replacement instances in the remaining healthy AZs within minutes  
B) Create two separate Auto Scaling groups (one per AZ) with min=4, max=4, desired=4, and a CloudWatch alarm that triggers a Lambda function to create a third ASG in a backup AZ on failure  
C) Create an Auto Scaling group with min=8, desired=8, max=8, in only 2 AZs. Configure a CloudWatch alarm on the AZ health metric to modify the ASG to add a third AZ  
D) Create a single Auto Scaling group with min=4, max=8, desired=8 in 3 AZs, relying on default rebalancing  

---

### Question 56
A company has a serverless application using API Gateway, Lambda, and DynamoDB. They experience the following pattern: at 8:00 AM daily, traffic spikes from 100 to 10,000 requests/second within 2 minutes. Users report timeouts during this spike. Lambda cold starts average 3 seconds due to VPC attachment and a large deployment package (250 MB). DynamoDB uses provisioned capacity and shows throttling during the spike. Which combination of optimizations addresses ALL performance issues? **(Select THREE)**

A) Configure Lambda provisioned concurrency to pre-warm 500 instances before the daily spike using Application Auto Scaling with a scheduled scaling action at 7:55 AM  
B) Reduce the Lambda deployment package size by using Lambda layers for shared libraries and keeping only the function-specific code in the deployment package  
C) Switch DynamoDB to on-demand capacity mode to handle unpredictable traffic spikes without throttling, or configure auto-scaling with target tracking set to a lower utilization target (e.g., 50%) to scale more aggressively  
D) Move the Lambda function out of the VPC since it only needs DynamoDB and API Gateway access (both accessible via public endpoints or VPC endpoints without requiring VPC attachment)  
E) Enable API Gateway caching for all endpoints  
F) Increase the Lambda timeout to 5 minutes to prevent timeout errors  

---

### Question 57
A company operates a legacy message queue using IBM MQ on-premises. The queue processes financial transactions that require strict FIFO ordering and exactly-once delivery within message groups. There are 500 message groups with variable throughput per group. The company wants to migrate to AWS with minimal application code changes. The IBM MQ client libraries are deeply embedded in the producer and consumer applications. Which migration path requires the LEAST code changes?

A) Deploy Amazon MQ with the ActiveMQ or RabbitMQ engine type, as Amazon MQ supports JMS and standard messaging protocols (AMQP, STOMP, MQTT, OpenWire) that IBM MQ clients can be configured to use with minimal library changes to the connection factory configuration  
B) Migrate to Amazon SQS FIFO queues, rewriting producers and consumers to use the AWS SDK  
C) Deploy a self-managed IBM MQ instance on EC2 to maintain full compatibility  
D) Use Amazon Kinesis Data Streams and rewrite the application to use the Kinesis Producer Library (KPL)  

---

### Question 58
A company is implementing a data classification and protection strategy for S3. They have 10,000 buckets across 50 accounts. Requirements: (1) Automatically discover and classify PII (credit cards, SSNs, passport numbers) in all buckets, (2) Generate weekly compliance reports, (3) Alert the security team in real time when PII is detected in a bucket not approved for PII storage. Which service combination meets ALL requirements?

A) Enable Amazon Macie across all accounts via AWS Organizations integration, configure Macie custom data identifiers for specific PII patterns, create automated classification jobs on a weekly schedule, use Macie findings published to EventBridge to trigger SNS notifications for PII detected in non-approved buckets  
B) Deploy custom Lambda functions that use regex patterns to scan S3 objects for PII  
C) Use AWS Config rules to check S3 bucket policies for public access, which indicates PII exposure risk  
D) Enable Amazon GuardDuty S3 protection for all accounts, which automatically classifies PII  

---

### Question 59
A company has an existing multi-tier application: web servers in public subnets, application servers in private subnets, and RDS in isolated subnets. The security team discovers that the application servers are making outbound calls to third-party APIs on the internet via a NAT Gateway. They want to restrict outbound traffic to ONLY the approved third-party API domains while maintaining internet access for AWS service endpoints. Which solution provides domain-level filtering for outbound traffic?

A) Deploy AWS Network Firewall in the private subnet's route path with stateful rules that use HTTP/HTTPS domain-based filtering to allow only the approved third-party API FQDNs, while permitting traffic to AWS service endpoints via VPC endpoints (Gateway for S3/DynamoDB, Interface for other services)  
B) Configure security group outbound rules on the application servers to only allow traffic to the IP addresses of the approved third-party APIs  
C) Replace the NAT Gateway with a proxy server (e.g., Squid) on EC2 and configure it as a forward proxy with domain-based allow lists  
D) Use AWS WAF on the NAT Gateway to filter outbound traffic by domain  

---

### Question 60
A company is migrating a complex Oracle database environment that includes Oracle GoldenGate for real-time replication between the primary database and a reporting database. The primary database will be migrated to Aurora PostgreSQL. The reporting workload runs complex analytical queries. What is the BEST target architecture for the reporting workload?

A) Use Aurora PostgreSQL with read replicas for the primary workload, and configure Amazon Redshift as the reporting target with AWS DMS CDC to replicate changes from Aurora to Redshift in near real-time for analytical queries  
B) Create multiple Aurora PostgreSQL read replicas sized for analytical queries  
C) Set up a separate Aurora PostgreSQL cluster with DMS full-load replication running nightly  
D) Use Amazon Athena with Federated Query to run analytical queries directly against the Aurora PostgreSQL database  

---

### Question 61
A government agency is deploying a classified workload that requires FIPS 140-2 Level 3 validated HSMs for cryptographic key management. The agency needs to encrypt data in Amazon S3 and Amazon RDS, using keys that are stored exclusively in HSMs they control. AWS KMS meets FIPS 140-2 Level 3 only for certain operations. Which approach meets the FIPS 140-2 Level 3 requirement for ALL key storage?

A) Deploy AWS CloudHSM clusters, create and manage encryption keys within the CloudHSM cluster (which provides FIPS 140-2 Level 3 validated HSMs), use CloudHSM client-side encryption for S3 objects, and configure RDS to use CloudHSM as a custom key store for KMS  
B) Use AWS KMS with customer managed keys, which are FIPS 140-2 Level 3 validated by default  
C) Deploy on-premises HSM appliances and use VPN to connect them to AWS for encryption operations  
D) Use S3 SSE-S3 and RDS default encryption, which automatically meet FIPS 140-2 Level 3  

---

### Question 62
A large enterprise is using AWS Control Tower to manage 200+ accounts. They need to implement a self-service mechanism for development teams to provision new AWS accounts with pre-configured networking (VPC, subnets, Transit Gateway attachment), security baselines (GuardDuty, Config, CloudTrail), and IAM roles. The provisioning must be repeatable and complete within 30 minutes. Which approach provides the MOST automated self-service account provisioning?

A) Use Control Tower Account Factory with AWS Service Catalog, combined with Customizations for AWS Control Tower (CfCT) that deploys CloudFormation StackSets for networking, security baselines, and IAM roles automatically when a new account is created via Account Factory  
B) Write a custom Lambda function that uses the Organizations CreateAccount API and then runs a series of CLI commands to configure each service  
C) Create detailed runbooks for operations teams to manually provision and configure each new account  
D) Use Terraform Cloud with a custom provider to create accounts and deploy infrastructure  

---

### Question 63
A company has a complex application with 50 microservices running on Amazon EKS. Inter-service communication uses a mix of synchronous HTTP calls and asynchronous messaging. The operations team cannot quickly identify the root cause of latency spikes because they lack visibility into request flows across services. They need distributed tracing, a service map, and latency analysis. Which observability solution provides the MOST comprehensive visibility with the LEAST operational overhead?

A) Instrument the microservices with the AWS X-Ray SDK (or OpenTelemetry SDK with X-Ray exporter), deploy the X-Ray daemon as a DaemonSet on EKS, use the X-Ray service map to visualize inter-service communication patterns, and use trace analytics to identify latency bottlenecks  
B) Deploy a self-managed Jaeger tracing cluster on EKS for distributed tracing  
C) Add structured logging to all services and use CloudWatch Logs Insights to correlate requests across services  
D) Use VPC Flow Logs to analyze inter-service network traffic patterns  

---

### Question 64
A company uses AWS Direct Connect with a dedicated 10 Gbps connection for all AWS traffic. Their business-critical SAP application requires guaranteed bandwidth of 5 Gbps during business hours, while other applications share the remaining bandwidth. The company also needs a backup path that activates within seconds if the Direct Connect connection fails. Which architecture meets these requirements? **(Select TWO)**

A) Create two Direct Connect Virtual Interfaces (VIFs) on the same connection — a private VIF for SAP traffic and a separate private VIF for other traffic. This alone does NOT provide bandwidth guarantees, so additionally configure QoS/traffic shaping on the on-premises router to prioritize SAP traffic with 5 Gbps guaranteed bandwidth  
B) Configure a Site-to-Site VPN connection over the internet as a backup path, with BGP routes configured so that Direct Connect is preferred (higher local preference) and VPN is used only when Direct Connect routes are withdrawn  
C) Create a second 10 Gbps Direct Connect connection at a different location for redundancy and use LAG (Link Aggregation Group) for bandwidth  
D) Use AWS Global Accelerator to prioritize SAP traffic over the Direct Connect connection  
E) Configure Direct Connect Gateway traffic metering to reserve 5 Gbps for the SAP VIF  

---

### Question 65
A startup is building a multi-tenant SaaS platform on AWS. They expect to grow from 10 to 10,000 tenants over 3 years. The platform stores documents, processes them with ML models, and serves results via an API. Early tenants require dedicated database isolation, while smaller tenants can share resources. The architecture must support per-tenant billing, noisy-neighbor prevention, and cost optimization as they scale. Which architecture BEST balances isolation, scalability, and cost? **(Select THREE)**

A) Implement a tiered tenant model: Premium tenants get dedicated Aurora clusters in dedicated VPCs, Standard tenants share an Aurora cluster with row-level isolation using tenant ID columns and PostgreSQL Row-Level Security (RLS)  
B) Use Amazon API Gateway with usage plans and API keys per tenant for rate limiting (noisy-neighbor prevention) and metered billing  
C) Deploy a single large RDS instance for all tenants with application-level access control  
D) Store documents in S3 with per-tenant prefixes, use S3 Storage Lens and Cost Allocation Tags for per-tenant cost tracking  
E) Deploy a dedicated AWS account per tenant from day one for all 10,000 expected tenants  
F) Use a single API Gateway without usage plans and rely on application-level rate limiting  

---

## Answer Key

### Question 1
**Correct Answer: A**

The AWS Application Discovery Agent (installed directly on servers) collects detailed information including network connections, process data, and inter-server communication patterns needed for dependency mapping. The agentless Discovery Connector only captures basic server configuration and utilization data from VMware vCenter — it cannot map inter-server dependencies. AWS Migration Hub then visualizes the collected dependency data to help plan migration waves. Option B is incorrect because VPC Flow Logs are for AWS VPCs, not on-premises traffic. Option D is incorrect because CloudWatch ServiceLens works for AWS-hosted services, not on-premises servers.

### Question 2
**Correct Answers: A, B**

AWS SCT is specifically designed to convert database schemas, stored procedures, and application code from one database engine to another (Oracle PL/SQL to PostgreSQL PL/pgSQL). It produces a detailed assessment report showing what can be auto-converted and what requires manual effort. AWS DMS with full-load plus CDC enables data migration with minimal downtime — it performs an initial bulk copy and then continuously replicates changes until cutover. Option C (Data Pump export) would require downtime for the entire export/import cycle, exceeding the 2-hour window for a 4 TB database. Option D is incorrect because SCT cannot automatically convert ALL stored procedures — it generates action items for manual conversion. Option E is invalid as Aurora cannot be a read replica of Oracle.

### Question 3
**Correct Answers: A, B, C**

Snowball Edge Compute Optimized handles the 80 TB historical data transfer (at 100 Mbps, transferring 80 TB over the internet would take ~74 days, exceeding the 2-week deadline). Its compute capability supports local Lambda functions. IoT Greengrass provides real-time edge processing with sub-10ms latency using local ML inference, which is critical for the quality control requirement. DataSync efficiently synchronizes new data to S3 and handles intermittent connectivity by resuming transfers. Direct Connect (D) takes weeks to provision and doesn't solve the local processing requirement. Kinesis Video Streams (E) is for video, not general sensor data. Outposts (F) is expensive and doesn't solve the historical data migration.

### Question 4
**Correct Answer: B**

Storage Gateway File Gateway provides SMB shares backed by S3, with Active Directory integration for Windows authentication. It caches frequently accessed files locally at each branch while storing all data in S3. The S3 Lifecycle policy handles the cold data tiering requirement. This approach requires no changes to user experience (mapped drives still work) and minimal operational overhead. Option A (FSx + DFS Replication) adds significant complexity. Option C (WorkDocs) doesn't provide traditional SMB file share access. Option D doesn't properly integrate with AD for transparent Windows authentication.

### Question 5
**Correct Answer: A**

This architecture uses Transit Gateway for scalable VPC connectivity within each region, Direct Connect with Transit VIFs for on-premises connectivity, and Transit Gateway inter-region peering for cross-region transitive routing. Transit VIFs enable connecting a Direct Connect connection to a Transit Gateway. The Transit Gateway provides transitive routing (unlike VPC peering). Inter-region peering extends this across regions. Option B (full mesh VPC peering) doesn't scale and doesn't support transitive routing. Option C is wrong because you cannot attach VPCs from other regions to a single Transit Gateway. Option D is less optimal — while Cloud WAN is valid, the question specifies deterministic performance, and Direct Connect with Transit VIFs is the established pattern.

### Question 6
**Correct Answers: A, B**

Route 53 Resolver inbound endpoints receive DNS queries forwarded from on-premises DNS servers — this allows on-premises to resolve AWS private hosted zone records. Resolver outbound endpoints forward DNS queries from AWS to on-premises DNS servers — this allows AWS workloads to resolve on-premises domains. Together, they provide bidirectional hybrid DNS resolution. Option C is incorrect because adding on-premises DNS to DHCP options would break AWS private hosted zone resolution. Option D defeats the purpose of private DNS. Option E is incorrect because Resolver rules are configured in AWS, not on on-premises servers.

### Question 7
**Correct Answers: A, B**

MGN replication agents can be configured with bandwidth throttling (using `--bandwidth-throttling` during installation) to control the impact on production networks. Configuring different throttle rates for business vs. off-hours balances migration speed with production impact. Dividing servers into migration waves prevents overwhelming the network with 60 TB of simultaneous initial replication, and the staging area subnet configuration in a dedicated VPC with appropriate replication server sizing ensures efficient replication infrastructure. Option C is incorrect because Snowball Edge cannot seed MGN — they are separate migration tools. Option D (Direct Connect) takes weeks to provision and adds significant cost. Option E is incorrect because SMS is deprecated in favor of MGN.

### Question 8
**Correct Answer: B**

Windows containers on ECS with EC2 launch type (Windows AMIs) support Windows-specific features like COM+ components. RDS for SQL Server Multi-AZ provides managed database with Windows Authentication support. ECS tasks can replace Windows services for background processing. Option A fails because Aurora PostgreSQL doesn't support Windows Authentication, and Lambda doesn't support COM+ components. Option C fails because migrating to Aurora MySQL and rewriting as Linux services contradicts the requirement to maintain .NET compatibility with Windows features. Option D (lift-and-shift) doesn't reduce operational overhead as mandated.

### Question 9
**Correct Answer: A**

AWS Blu Age is specifically designed for mainframe modernization, automatically converting COBOL code to Java. The automated conversion maintains the logic integrity of financial calculations, and the resulting Java microservices can be tested against mainframe output for verification. ECS Fargate provides a managed runtime. Option B (manual rewrite in Python) introduces enormous risk and cost for 500,000 lines of code. Option C (Micro Focus on EC2) is a valid re-host approach but doesn't modernize the application. Option D (Step Functions + Lambda) requires a complete rewrite.

### Question 10
**Correct Answer: A**

VMware Cloud on AWS is purpose-built for this scenario: it runs native VMware vSphere on AWS bare metal, enabling live vMotion from on-premises VMware to AWS with zero downtime. The existing VMware team can use their existing skills immediately. HCX (Hybrid Cloud Extension) enables bulk migration and live vMotion. This is the fastest path with 800 VMs and a 90-day deadline. Option B (MGN for 800 VMs simultaneously) would overwhelm bandwidth. Option C (OVA export/import) requires significant downtime per VM. Option D delays migration beyond the 90-day deadline.

### Question 11
**Correct Answer: A**

ECS Anywhere allows registering external (on-premises) instances as ECS capacity using the EXTERNAL launch type. The same ECS task definitions, APIs, and container images work on both cloud and on-premises instances. CloudWatch agent on external instances sends metrics and logs to CloudWatch for centralized monitoring. Option B (EKS Distro) uses Kubernetes, not ECS APIs. Option C (Outposts servers) is valid but significantly more expensive than ECS Anywhere for this use case. Option D doesn't use native ECS APIs.

### Question 12
**Correct Answer: A**

AWS Outposts rack is the only option that places AWS-managed hardware in the customer's own data center. It supports RDS, ECS, and ALB on Outposts, with a low-latency (dedicated fiber) connection to the parent AWS Region. This meets the data residency requirement of having hardware physically controlled by the company. Option B (Local Zones) is AWS-operated, not in the customer's data center. Option C doesn't meet the physical control requirement. Option D (Wavelength) is at telecom provider locations.

### Question 13
**Correct Answer: A**

AWS Local Zones in Los Angeles (us-west-2-lax-1) place compute and storage infrastructure within the city, providing single-digit millisecond latency from local locations. They support GPU instances and FSx for Lustre. This is the purpose-built solution for ultra-low-latency workloads in specific metro areas. Option B (Global Accelerator) cannot reduce latency below network physics (15-20ms to Oregon). Option C (Direct Connect) still traverses the distance to Oregon. Option D doesn't provide FSx for Lustre on Outposts.

### Question 14
**Correct Answer: A**

AWS Wavelength Zones are infrastructure deployments embedded directly within 5G carrier networks (Verizon, Vodafone, etc.). They provide single-digit millisecond latency for applications that need to be at the mobile network edge. ECS is supported in Wavelength Zones. This is the only option that provides direct carrier network integration for 5G traffic. Option B (Local Zones) is not embedded in the carrier network. Option C (Global Accelerator) doesn't provide carrier-edge processing. Option D (Lambda@Edge) runs at CloudFront POPs, not at the mobile network edge.

### Question 15
**Correct Answer: A**

AD Connector is a proxy that forwards authentication requests to the on-premises Active Directory without caching or replicating any directory data in AWS. It supports LDAP, Windows Authentication for RDS, and WorkSpaces integration. The key requirement is "NO user or schema replication to the cloud," which eliminates Managed Microsoft AD (which creates a new directory in AWS). However, AD Connector has limitations — it doesn't support multi-forest trust relationships natively. The question specifies using AD Connector for its proxy-only behavior. Option C (Managed Microsoft AD with trust) would replicate directory data. Option D (SAML) doesn't support LDAP authentication or Windows Authentication for RDS.

### Question 16
**Correct Answers: A, B**

AWS SCT is the recommended tool for converting Oracle Data Warehouse schemas to Redshift, including handling Oracle-specific SQL extensions, partitioning strategies, and materialized views (converted to Redshift materialized views or CTAS patterns). The assessment report identifies what requires manual intervention. DMS handles the actual data migration with appropriate type mappings. Option C (CSV export) loses data type fidelity and doesn't handle LOBs well. Option D is incorrect because Glue cannot replicate materialized view logic. Option E is fictional — Redshift cannot create database links to Oracle.

### Question 17
**Correct Answer: A**

Creating an Aurora MySQL read replica from the EC2 MySQL instance using native binary log replication provides continuous synchronization. After promotion, configuring reverse binlog replication from Aurora back to the EC2 MySQL instance gives instant rollback capability (just redirect connections back). Option B (DMS reverse task) would take time to set up and doesn't provide instant rollback. Option C (snapshot restore) creates a point-in-time copy without CDC, meaning data written after snapshot creation is lost. Option D (mysqldump) requires extended downtime.

### Question 18
**Correct Answers: A, B**

A Direct Connect Gateway can be associated with Transit Gateways in multiple regions, enabling a single physical Direct Connect connection to reach all regions. Transit VIFs connect to the Direct Connect Gateway, which then routes to the appropriate Transit Gateway. Inter-region Transit Gateway peering enables transitive routing between VPCs across different regions. Option C (full mesh VPC peering for 30 VPCs) doesn't scale. Option D (VPN over internet) doesn't provide deterministic performance. Option E is wrong because a single Transit Gateway cannot span multiple regions.

### Question 19
**Correct Answers: A, B**

MGN replication bandwidth throttling controls the data transfer rate, preventing replication from consuming excessive production bandwidth. Moving the staging area to a private subnet and using VPN/Direct Connect addresses the security concern about data traversing the public internet. Option C doesn't address the security concern. Option D would result in never completing the migration. Option E isn't compatible with MGN.

### Question 20
**Correct Answer: A**

High Memory instances (u-6tb1.metal) provide 6 TB of RAM required for SAP HANA. Dedicated Hosts ensure the physical server is not shared with other customers (licensing compliance and regulatory requirement). EBS io2 Block Express volumes provide sub-microsecond latency for storage-intensive SAP HANA workloads. Option B (x2idn.metal) has 2 TB max memory, insufficient. Option C (r6i.metal) has only 1 TB memory. Option D uses the right instance but Dedicated Instances don't guarantee the same physical host exclusivity as Dedicated Hosts.

### Question 21
**Correct Answer: A**

AWS IoT Greengrass provides edge computing with local Lambda execution and includes connectors that can proxy DynamoDB and S3 API calls locally. The Greengrass Stream Manager handles store-and-forward synchronization when connectivity is restored. This provides seamless offline capability with automatic sync. Option B requires custom sync logic. Option C (Outposts) requires constant connectivity to the parent region and is expensive. Option D requires significant custom development.

### Question 22
**Correct Answers: A, B, C**

Aurora Global Database provides RPO < 1 second with storage-level replication and allows the secondary region to serve read traffic. ElastiCache Global Datastore replicates Redis data cross-region with sub-second latency. Route 53 health checks with Lambda-based calculators enable application-level health verification (not just TCP), ensuring intelligent failover. Option D (Global Accelerator) uses TCP health checks, not application-level. Option E is reactive and slower. Option F loses cache warmth during failover, impacting RTO.

### Question 23
**Correct Answer: A**

Storage Gateway File Gateway provides a transparent NFS/SMB share backed by S3, handling bidirectional access. S3 events trigger MediaConvert for automated transcoding. The RefreshCache API (called on a schedule or via S3 event → Lambda) ensures completed files appear on the local share. This provides the seamless editor experience. Option B (DataSync every 15 minutes) introduces delays and doesn't provide the transparent file share experience. Option C and D require more operational overhead and don't maintain the NAS user experience.

### Question 24
**Correct Answer: A**

AD Connector is lightweight (no domain controllers deployed in AWS), requires no additional AD infrastructure at properties, and proxies authentication to the existing local AD via VPN. With one AD Connector per property in the nearest region, WorkSpaces authenticate against local AD. This minimizes infrastructure while meeting per-property authentication. Option B (single Managed Microsoft AD with 200 trusts) is complex and expensive. Option C requires a massive AD consolidation project. Option D won't work because AD Connector connects to a specific AD domain.

### Question 25
**Correct Answers: A, B**

Consolidating into a single table with tenant ID as the partition key simplifies management from 500+ tables to one. DynamoDB fine-grained access control using the `dynamodb:LeadingKeys` condition restricts each tenant to rows where the partition key matches their tenant ID. The super admin role's IAM policy omits the LeadingKeys condition, granting access to all items. Option C (SCPs) doesn't provide row-level DynamoDB access control. Option D requires a complete database migration. Option E (Cognito) can complement but doesn't solve the table consolidation.

### Question 26
**Correct Answer: A**

Redis Cluster Mode distributes data across shards, scaling both memory and throughput. With 5 shards and 2 replicas per shard, you get 5x the memory and read replicas provide additional read throughput. Hash tags `{leaderboard_id}` ensure related keys stay on the same shard. Option B (vertical scaling) has a ceiling and doesn't address 1M reads/second. Option C (application-level load balancing) adds complexity and inconsistency. Option D (DynamoDB) doesn't natively support sorted sets efficiently.

### Question 27
**Correct Answers: A, B, C**

KMS CMKs provide customer-controlled encryption with full CloudTrail audit trails (requirement 1 and 2). RDS in a private subnet with activity logging satisfies PHI storage and access logging (requirement 2 and 4). S3 with SSE-KMS, access logging, and VPC endpoint ensures encrypted storage, audit trail, and no public internet traversal (requirements 1, 2, and 4). Disabling the CMK (Option F) would revoke access to ALL encrypted data (requirement 3). Option D (SSE-S3) doesn't provide customer-controlled keys. Option E (VPN over internet) violates requirement 4.

### Question 28
**Correct Answers: A, B**

Aurora PostgreSQL with multiple reader instances behind a reader endpoint provides horizontal read scaling similar to Oracle RAC reader nodes. Aurora Multi-AZ (with readers in different AZs) provides automatic failover with 99.99% availability SLA. Together, they replicate Oracle RAC's dual benefits of HA and read scaling. Option C is possible but introduces operational complexity of managing RAC on EC2. Option D (RDS Oracle Multi-AZ) only provides HA, not horizontal read scaling. Option E requires application-level sharding complexity.

### Question 29
**Correct Answer: A**

AWS Glue with Spark jobs handles complex transformations natively, auto-scaling adjusts worker count dynamically, and G.2X workers provide sufficient memory for intensive ETL. Glue is serverless, minimizing operational overhead. The Glue Redshift connector writes directly to Redshift efficiently. Option B (persistent EMR cluster) has higher operational overhead and cost. Option C (Lambda) can't handle complex Spark transformations or process 10 TB. Option D (Firehose) doesn't support complex Spark transformations.

### Question 30
**Correct Answers: A, B**

Transit Gateway with route tables directing default routes through the inspection VPC centralizes egress. Gateway Load Balancer with firewall appliances provides transparent inline inspection. Appliance mode on the Transit Gateway attachment ensures traffic symmetry (both directions flow through the same firewall instance). Option C (Network Firewall per VPC) is distributed, not centralized. Option D (VPC peering) doesn't support transitive routing. Option E (NAT Gateways per VPC) provides no inspection.

### Question 31
**Correct Answers: A, B**

Converting from JSON to Parquet provides columnar storage (Athena only reads needed columns, reducing scan volume by 80-90%) and Snappy compression further reduces data size. Consolidating millions of small files into larger ones eliminates the massive overhead of S3 GET requests and file-open operations (the "small file problem" is the #1 performance killer in data lakes). Option C (Transfer Acceleration) is for uploads, not queries. Option D adds cost without addressing root causes. Option E doesn't improve Athena query performance.

### Question 32
**Correct Answer: A**

ECS on EC2 is the only option that supports GPU instances (Fargate doesn't support GPUs), EBS volumes for persistent storage, Cluster Auto Scaling for rapid scaling, and Dedicated Instances for hardware isolation. Option B and C are incorrect because Fargate does not support GPU workloads. Option D is incorrect because Lambda doesn't support GPU access and has a 15-minute timeout.

### Question 33
**Correct Answers: A, B**

The SCP provides preventive control — it blocks non-CMK encryption at the API level before it happens. The AWS Config rule with auto-remediation provides detective control — it identifies existing non-compliant buckets and automatically fixes them. Together, they cover both prevention and detection. Option C (Security Hub) is detective-only without auto-remediation. Option D (Macie) discovers sensitive data, not encryption configuration. Option E (IAM policies) can be modified by account admins.

### Question 34
**Correct Answer: C**

Aurora PostgreSQL with auto-scaling read replicas dynamically adjusts the number of replicas based on demand. During business hours, replicas scale up for read traffic. During overnight batch processing, replicas scale down, saving costs. Aurora's reader endpoint automatically distributes read traffic. Option A requires manual scaling management. Option B (single larger instance) doesn't address read scaling. Option D (ElastiCache) helps but doesn't address the fundamental compute bottleneck.

### Question 35
**Correct Answers: A, B**

Migration Hub's network dependency map (populated by Discovery Agent data) visualizes inter-server communication patterns, enabling informed application grouping. Creating migration waves with interdependent groups in the same wave, followed by test migrations, ensures a validated migration plan. Option C doesn't address dependency mapping. Option D is manual and error-prone. Option E provides business case analysis, not dependency mapping.

### Question 36
**Correct Answer: A**

Externalizing session data to ElastiCache Redis (with Multi-AZ for durability) is the industry-standard approach. Any instance can serve any user because session data is centralized. Redis provides sub-millisecond latency for session reads. The session ID in a client cookie lets any server retrieve the correct session. Option B still loses sessions when instances are terminated. Option C (DynamoDB) works but has higher latency than Redis. Option D (NLB) doesn't solve the session persistence problem.

### Question 37
**Correct Answers: A, B**

Transit Gateway replaces 150 VPC peering connections with a single hub-and-spoke model. Route tables segment traffic — hospital VPCs can reach shared services but not other hospital VPCs. RAM enables cross-account Transit Gateway sharing within the Organization, so each account can self-service attach their VPCs. Option C (PrivateLink) doesn't provide general VPC connectivity. Option D (Client VPN) is for user access, not VPC-to-VPC. Option E (automated VPC peering) doesn't scale well.

### Question 38
**Correct Answer: A**

SCT's assessment report provides detailed information about why specific procedures couldn't be converted, including the Oracle-specific features used. Manually rewriting in PL/pgSQL or using Lambda via the aws_lambda extension are the recommended approaches for unconvertible code. Option B (maintaining Oracle alongside Aurora) adds permanent operational cost. Option C is incorrect — DMS migrates data, not stored procedure logic. Option D (removing all stored procedures) is a massive refactoring effort.

### Question 39
**Correct Answer: A**

Amazon MSK runs Apache Kafka, so existing Kafka client libraries work with minimal changes (update bootstrap server endpoints). It provides managed brokers, automatic recovery, and supports the same Kafka APIs. Provisioned capacity allows sizing similar to the on-premises cluster. Strict ordering per partition is native to Kafka. Option B requires complete application rewrite. Option C doesn't support Kafka protocols. Option D doesn't eliminate operational overhead.

### Question 40
**Correct Answers: A, B, C**

An Organization trail captures all API calls across all accounts to a centralized bucket. S3 Object Lock in Compliance mode prevents anyone (including root) from deleting logs for 7 years. CloudTrail Lake provides fast query capability for recent investigations, while S3 Lifecycle transitions older logs to Glacier Deep Archive (retrievable within 12 hours). The bucket policy denies access from non-security roles. Option D (CloudWatch Logs) doesn't provide organization-wide centralization. Option E (Insights) is for anomaly detection, not search. Option F (DynamoDB) is not suitable for log storage at this scale.

### Question 41
**Correct Answer: A**

DynamoDB Global Tables (version 2019.11.21) provides multi-region, active-active replication with automatic conflict resolution using last-writer-wins based on the item's timestamp. The application should be designed with idempotent operations to handle eventual consistency. Option B requires custom development. Option C is incorrect — DynamoDB Transactions don't span regions. Option D (DAX) is a cache layer and doesn't prevent write conflicts.

### Question 42
**Correct Answer: A**

AWS Batch is purpose-built for batch processing. Spot Instances provide up to 90% cost savings for fault-tolerant batch jobs. The secondary On-Demand environment catches jobs that fail due to Spot interruptions. AWS Batch handles job scheduling, scaling, and retry logic. Option B (On-Demand ASG) is significantly more expensive. Option C (Fargate Spot) has higher per-task cost than EC2 Spot for batch. Option D (Lambda) has a 15-minute timeout, insufficient for 30-minute jobs.

### Question 43
**Correct Answer: A**

Gateway Load Balancer transparently inserts firewall appliances into the traffic path, preserving source and destination IPs (unlike NLB which NATs). Transit Gateway appliance mode ensures traffic symmetry by routing return traffic through the same AZ as the request. GWLB scales to 50+ Gbps. Option B (NLB) performs NAT, losing original source IPs. Option C (Network Firewall) is valid but is AWS-managed and doesn't support third-party appliances. Option D (distributed firewalls) doesn't centralize inspection.

### Question 44
**Correct Answers: A, B**

Lambda in a VPC creates ENIs for each concurrent execution. At 50,000 concurrent invocations, thousands of ENIs are needed, and small subnets run out of IPs, causing connection failures. Larger subnets provide sufficient IPs. Provisioned concurrency pre-creates execution environments, eliminating cold starts and pre-establishing connections to ElastiCache. Option C may be a contributing factor but isn't the "most likely" given the symptoms. Option D (API Gateway limit) would show 429 errors, not timeouts. Option E doesn't explain the specific symptoms.

### Question 45
**Correct Answer: A**

SCPs provide preventive controls that apply to ALL principals in ALL accounts, including new accounts from Account Factory. SCPs denying specific actions are the MOST effective way to enforce organization-wide restrictions. They integrate seamlessly with Control Tower's OU structure. Option B (Config rules) provides detection and remediation but not prevention. Option C (permission boundaries) don't prevent root account actions. Option D (State Manager) is for configuration management, not policy enforcement.

### Question 46
**Correct Answers: A, B**

Normalizing cache keys (removing unnecessary headers/query strings) dramatically increases cache hit rates. Origin Shield adds a centralized caching layer — instead of each edge location independently requesting from the origin on a cache miss, Origin Shield consolidates these requests, significantly reducing origin load. Option C (blanket 24-hour TTL) would serve stale content. Option D adds origin complexity without improving cache hits. Option E changes protocol but doesn't reduce requests.

### Question 47
**Correct Answer: A**

Glue Schema Registry tracks schema versions. Crawlers update the Data Catalog with new schemas. DynamicFrames with resolveChoice handle data type conflicts gracefully, and applyMapping transforms handle column renames. This combination provides automatic schema evolution handling. Option B (rejecting files) prevents processing of valid data. Option C (Firehose) doesn't support complex schema evolution. Option D (custom EMR code) has high operational overhead.

### Question 48
**Correct Answer: A**

AWS CodeDeploy ECS deployment supports canary and linear deployment configurations with automatic rollback based on CloudWatch alarm triggers. App Mesh provides fine-grained traffic routing between ECS task sets. This combination provides fully automated canary deployment with intelligent rollback. Option B and C require manual monitoring and intervention. Option D (Route 53 weighted routing) is too coarse-grained for canary deployments.

### Question 49
**Correct Answer: A**

DynamoDB Streams → Lambda → Firehose → S3 (in Parquet) → Athena provides a real-time CDC pipeline that separates OLAP queries from the DynamoDB table entirely. Athena queries against S3 don't consume DynamoDB capacity. Option B (GSI) still consumes read capacity. Option C (on-demand mode) doesn't separate workloads. Option D (daily export) has up to 24-hour data staleness.

### Question 50
**Correct Answers: A, B**

Kinesis Data Streams handles 1 million events/second with sufficient shards (1,000 shards at 1,000 records/second/shard). Managed Service for Apache Flink provides windowed SQL for real-time anomaly detection. Firehose delivers to S3 with lifecycle policies for hot (S3 Standard) and archive (Glacier Deep Archive) tiers. Option C (SQS + Lambda) doesn't support windowed SQL analytics. Option D (MSK) is valid for ingestion but doesn't include the analytics engine. Option E (IoT Core + IoT Analytics) has throughput limitations.

### Question 51
**Correct Answer: A**

AWS WAF with Managed Rules provides immediate protection against SQL injection and XSS (CRS and SQLi rule groups). Geo-match rules block traffic by country. Rate-based rules throttle per-IP requests. All deployable within minutes via the console or CLI. Option B (third-party WAF) can't be deployed in 24 hours. Option C (security groups) can't block by country and don't inspect application layer. Option D (Shield Advanced) protects against DDoS, not SQL injection.

### Question 52
**Correct Answers: A, C**

Tokenization replaces sensitive card data with non-sensitive tokens before the data reaches the main application. Only the tokenization service handles actual card numbers, dramatically reducing PCI scope. The main application tier only handles tokens and is outside PCI DSS scope. Option B puts the entire application in PCI scope. Option D (SSE-S3) doesn't satisfy PCI requirements alone. Option E (client-side only) is impractical and still requires PCI compliance for the client-side code.

### Question 53
**Correct Answer: A**

Aurora point-in-time recovery restores to a specific second, meeting the quarterly test requirement. Using a smaller instance class for the 4-hour validation reduces cost. Deleting the cluster immediately after validation minimizes expense. Option B (Aurora clone) creates an instant copy of the current state, not a specific historical point in time. Option C (Backtrack on production) is extremely risky and impacts the production database. Option D (RDS PostgreSQL) would be slower and lacks Aurora-specific features.

### Question 54
**Correct Answer: A**

Three IoT Core rules provide independent, parallel delivery to all downstream systems. The DynamoDB action with the device ID as partition key naturally handles duplicates via upsert (overwriting existing items with the same key). Firehose batches data efficiently for S3. The Lambda function for alerting can implement deduplication via a deduplication cache. Option B (SQS FIFO) is limited in throughput. Option C (SNS) adds an unnecessary hop. Option D requires managing three independent KCL consumers.

### Question 55
**Correct Answer: A**

An ASG spanning 3 AZs with min=8, desired=8, max=12 initially distributes instances across available AZs. If one AZ fails, the ASG automatically detects unhealthy instances and launches replacements in healthy AZs within minutes (well under 5 minutes). AZ rebalancing ensures even distribution. Option B requires custom Lambda logic and has delayed response. Option C locks to 2 AZs and requires manual intervention. Option D with max=8 can't maintain 8 instances if one AZ fails.

### Question 56
**Correct Answers: A, B, C**

Provisioned concurrency with scheduled scaling pre-warms Lambda instances before the daily spike, eliminating cold starts. Reducing deployment package size reduces cold start initialization time. On-demand DynamoDB capacity mode auto-scales to handle traffic spikes without throttling. Option D is wrong because the function needs ElastiCache (which requires VPC). Option E doesn't address the root causes. Option F just masks timeout symptoms.

### Question 57
**Correct Answer: A**

Amazon MQ supports industry-standard messaging protocols (AMQP, STOMP, OpenWire, MQTT, WebSocket). IBM MQ clients can be reconfigured to use these standard protocols with minimal changes to the connection factory. ActiveMQ supports JMS which is commonly used by IBM MQ clients. This requires far fewer code changes than migrating to SQS or Kinesis. Option B (SQS FIFO) requires complete rewrite. Option C (self-managed IBM MQ) doesn't eliminate operational overhead. Option D (Kinesis) requires complete rewrite.

### Question 58
**Correct Answer: A**

Amazon Macie is purpose-built for discovering and classifying sensitive data in S3. Organization-wide deployment via AWS Organizations provides complete coverage. Custom data identifiers extend detection beyond built-in patterns. Automated classification jobs run on schedule. EventBridge integration with SNS enables real-time alerting. Option B (custom Lambda) requires massive development effort. Option C (Config rules) checks policies, not data content. Option D (GuardDuty) detects threats, not data classification.

### Question 59
**Correct Answer: A**

AWS Network Firewall supports stateful rules with domain-based filtering for HTTP/HTTPS traffic, allowing you to specify allowed FQDNs. VPC endpoints for AWS services eliminate the need for internet routing for AWS API calls. This provides precise domain-level control. Option B (security groups) only support IP-based rules, not domain names. Option C (Squid proxy) works but has higher operational overhead. Option D (WAF on NAT Gateway) is not possible — WAF can't be applied to NAT Gateways.

### Question 60
**Correct Answer: A**

Amazon Redshift is optimized for analytical queries (OLAP), unlike Aurora which is optimized for transactional workloads (OLTP). DMS CDC replicates changes from Aurora to Redshift in near real-time, providing up-to-date data for reporting without impacting Aurora performance. This replaces Oracle GoldenGate's role. Option B (Aurora read replicas) uses OLTP-optimized storage for OLAP queries. Option C (nightly full load) has stale data. Option D (Athena federated query) impacts Aurora performance.

### Question 61
**Correct Answer: A**

AWS CloudHSM provides FIPS 140-2 Level 3 validated HSMs that the customer fully controls. CloudHSM can serve as a custom key store for KMS, enabling KMS-integrated encryption (for RDS) while keys remain in Level 3 HSMs. Client-side encryption with CloudHSM handles S3. Option B is incorrect — KMS uses FIPS 140-2 Level 3 validated HSMs, but the question requires that the customer controls the HSMs exclusively. Option C (on-premises HSMs) introduces latency and complexity. Option D (SSE-S3/RDS default) doesn't use Level 3 HSMs.

### Question 62
**Correct Answer: A**

Control Tower Account Factory with Service Catalog provides the self-service portal. Customizations for Control Tower (CfCT) automatically deploys CloudFormation StackSets to new accounts, configuring networking, security, and IAM roles. This is fully automated and repeatable. Option B (custom Lambda) requires significant development and maintenance. Option C (manual runbooks) doesn't scale. Option D (Terraform) bypasses Control Tower governance.

### Question 63
**Correct Answer: A**

AWS X-Ray (or OpenTelemetry with X-Ray) provides distributed tracing, service maps, and latency analysis natively in AWS. The X-Ray daemon as a DaemonSet efficiently collects traces from all EKS pods. The service map visualizes microservice communication patterns. Trace analytics identifies latency bottlenecks. Option B (self-managed Jaeger) has high operational overhead. Option C (structured logging) doesn't provide distributed tracing. Option D (VPC Flow Logs) provides network data, not application-level tracing.

### Question 64
**Correct Answers: A, B**

Direct Connect doesn't natively provide bandwidth guarantees between VIFs. QoS/traffic shaping on the on-premises router prioritizes SAP traffic to guarantee 5 Gbps. A Site-to-Site VPN as backup with BGP configuration ensures automatic failover when Direct Connect routes are withdrawn. Option C (second DX connection) provides redundancy but not bandwidth prioritization. Option D (Global Accelerator) doesn't work with Direct Connect. Option E is fictional — Direct Connect Gateway doesn't offer traffic metering.

### Question 65
**Correct Answers: A, B, D**

The tiered model (dedicated Aurora for premium, shared Aurora with RLS for standard) balances isolation with cost. API Gateway usage plans provide per-tenant rate limiting and metered billing. S3 with per-tenant prefixes, Storage Lens, and Cost Allocation Tags enable per-tenant cost tracking. Option C (single RDS) doesn't provide any isolation. Option E (account-per-tenant for 10,000) is operationally impractical and expensive. Option F (no usage plans) lacks noisy-neighbor prevention.
