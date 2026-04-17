# Practice Exam 22 - AWS Solutions Architect Associate (SAA-C03)

## Storage & Database Deep Dive

### Exam Details
- **Total Questions:** 65
- **Time Limit:** 130 minutes
- **Question Types:** Multiple choice and multiple response
- **Passing Score:** 720/1000

### Domain Distribution
| Domain | Questions |
|--------|-----------|
| Security | ~20 |
| Resilient Architecture | ~17 |
| High-Performing Technology | ~16 |
| Cost-Optimized Architecture | ~12 |

---

### Question 1
A company stores 500 TB of log data in Amazon S3 Standard. Analysis shows that data is actively accessed for the first 30 days, occasionally accessed during days 31-90, rarely accessed during days 91-365, and never accessed after 365 days. The company wants to minimize storage costs while maintaining retrieval capabilities for data up to 365 days old.

Which S3 lifecycle configuration minimizes costs?

A) Transition to S3 Standard-IA after 30 days, transition to S3 Glacier Flexible Retrieval after 90 days, and delete after 365 days.

B) Transition to S3 Intelligent-Tiering after 30 days, transition to S3 Glacier Deep Archive after 90 days, and delete after 365 days.

C) Transition to S3 One Zone-IA after 30 days, transition to S3 Glacier Instant Retrieval after 90 days, transition to S3 Glacier Flexible Retrieval after 180 days, and delete after 365 days.

D) Transition to S3 Standard-IA after 30 days, transition to S3 Glacier Instant Retrieval after 90 days, and delete after 365 days.

---

### Question 2
A company runs a MySQL database on Amazon RDS with a db.r5.2xlarge instance. The database handles 20,000 read IOPS and 5,000 write IOPS during peak hours. The current gp2 volume (1 TB) provides 3,000 baseline IOPS, causing significant performance degradation. The company needs consistent high IOPS performance.

Which EBS volume change addresses the IOPS requirement MOST cost-effectively?

A) Migrate from gp2 to gp3 with provisioned IOPS set to 16,000 and throughput of 1,000 MiB/s. gp3 allows provisioning up to 16,000 IOPS independently of volume size at a lower cost than io1/io2.

B) Migrate from gp2 to io2 with provisioned IOPS set to 25,000 to handle peak combined read/write IOPS with headroom.

C) Increase the gp2 volume size to 8.34 TB (25,002 IOPS at 3 IOPS/GB ratio) to achieve sufficient baseline IOPS.

D) Migrate from gp2 to io1 with provisioned IOPS set to 25,000. Add read replicas to offload read IOPS from the primary.

---

### Question 3
A company is using Amazon S3 with versioning enabled on a bucket that stores application configuration files. The bucket has accumulated millions of non-current (previous) object versions over three years, consuming 50 TB of storage. Current versions total only 2 TB. The company needs to reduce storage costs while keeping all current versions readily available and retaining non-current versions for 90 days for rollback purposes.

Which lifecycle configuration addresses this requirement?

A) Create a lifecycle rule to transition non-current versions to S3 Glacier Flexible Retrieval after 30 days and permanently delete non-current versions after 90 days (using NoncurrentVersionExpiration with NoncurrentDays set to 90).

B) Create a lifecycle rule to delete all non-current versions immediately (NoncurrentVersionExpiration with NoncurrentDays set to 0) and rely on S3 Cross-Region Replication for backup.

C) Disable versioning on the bucket to prevent new non-current versions, and manually delete old versions using a script.

D) Create a lifecycle rule to transition all objects (current and non-current) to S3 Glacier Deep Archive after 30 days to minimize costs.

---

### Question 4
A company is running a clustered database application on EC2 instances that requires shared block storage. The application needs the storage volume to be simultaneously attached to up to 4 EC2 instances in the same Availability Zone. The workload requires 10,000 IOPS with a 16 KB I/O size.

Which EBS configuration supports this requirement?

A) Use an io2 EBS volume with Multi-Attach enabled. io2 volumes support Multi-Attach, allowing attachment to up to 16 Nitro-based instances in the same AZ. Provision the volume with 10,000 IOPS.

B) Use a gp3 EBS volume with Multi-Attach enabled. Configure 10,000 provisioned IOPS on the gp3 volume.

C) Use Amazon EFS instead of EBS for shared storage across multiple instances with provisioned throughput mode.

D) Use an io1 EBS volume with Multi-Attach enabled and create a RAID 0 array across multiple volumes for higher IOPS.

---

### Question 5
A company has a data analytics workload that reads and writes large sequential files (each 1-50 GB). The workload runs on a cluster of 20 EC2 instances and requires a shared file system with at least 10 GB/s aggregate throughput. Data is temporary and can be regenerated if lost. Cost optimization is a priority.

Which storage solution provides the required performance at the LOWEST cost?

A) Amazon FSx for Lustre with a scratch file system. Scratch provides high throughput (up to 200 MB/s per TiB of storage) without data replication overhead, at a lower cost than persistent. Since data is temporary and can be regenerated, durability is not a concern.

B) Amazon FSx for Lustre with a persistent file system. Persistent provides data replication within the AZ for durability.

C) Amazon EFS with provisioned throughput mode set to 10 GB/s. EFS supports shared access across multiple instances.

D) Create an Amazon S3 bucket and use S3 as the primary data store. Mount S3 using a FUSE-based file system client for POSIX access.

---

### Question 6
A company is running Amazon Aurora MySQL with a primary instance and 5 read replicas. During peak hours, the read replicas are overwhelmed with traffic, but during off-peak hours, most replicas are idle. The company wants to automatically adjust the number of read replicas based on demand while keeping a minimum of 2 replicas available at all times.

Which configuration provides automatic scaling of Aurora read replicas?

A) Configure Aurora Auto Scaling with a target tracking scaling policy based on the average CPU utilization of the Aurora replicas. Set the minimum capacity to 2 and maximum to 15. Aurora will automatically add or remove replicas to maintain the target CPU utilization.

B) Create an Auto Scaling group for the Aurora read replicas and configure scaling policies based on CloudWatch metrics for database connections.

C) Use Aurora Serverless v2 for read replicas to automatically scale compute capacity based on demand, while keeping the primary instance as a provisioned instance.

D) Configure an AWS Lambda function triggered by CloudWatch alarms to add or remove Aurora read replicas using the RDS API based on CPU metrics.

---

### Question 7
A company needs to choose between RAID 0 and RAID 1 configurations for EBS volumes attached to an EC2 instance running a write-heavy transactional database. The database requires both high I/O performance and data durability at the instance level.

Which RAID configuration and rationale is correct?

A) RAID 0 (striping) provides the highest I/O performance by combining the IOPS and throughput of multiple volumes, but offers no redundancy — a single volume failure causes complete data loss. It is suitable for temporary data or when data is replicated at the application level.

B) RAID 1 (mirroring) writes identical data to two volumes simultaneously, providing data redundancy at the cost of halving usable capacity. It protects against single volume failure but does not improve write performance.

C) Use RAID 0 for this workload because EBS volumes already have built-in redundancy within the AZ, so additional RAID 1 mirroring is unnecessary. RAID 0 maximizes the I/O performance needed for the write-heavy database.

D) Use RAID 1 because it doubles both read and write performance while also providing redundancy, making it ideal for transactional databases.

---

### Question 8
A company stores 200 TB of genomic research data in Amazon S3. Scientists need to run complex queries against this data using standard SQL. The queries scan large portions of the dataset and typically return small result sets (under 1 MB). The queries are run approximately 10 times per day.

Which solution is MOST cost-effective for querying this data?

A) Use Amazon Athena to query the data directly in S3 using standard SQL. Store the data in Parquet or ORC columnar format with appropriate partitioning to minimize the amount of data scanned per query, reducing costs since Athena charges per TB scanned.

B) Load all 200 TB into an Amazon Redshift cluster with dense storage nodes. Use Redshift to run the SQL queries.

C) Create an Amazon RDS PostgreSQL instance with enough storage to hold the 200 TB dataset. Import the data and run SQL queries against RDS.

D) Load the data into Amazon DynamoDB and use PartiQL for SQL-compatible queries against the data.

---

### Question 9
A company is migrating from a self-managed Redis cluster to Amazon ElastiCache for Redis. The application uses Redis for both caching (80% of operations) and as a primary data store for session data (20% of operations). The cluster currently has 100 GB of data and handles 500,000 requests per second. The company needs high availability with automatic failover.

Which ElastiCache for Redis configuration meets these requirements? (Choose TWO)

A) Enable cluster mode (cluster mode enabled) to distribute data across multiple shards. This allows horizontal scaling beyond the memory limits of a single node and distributes the 500,000 requests/second across shards.

B) Configure Multi-AZ with automatic failover. Each shard should have at least one replica in a different AZ to ensure high availability.

C) Use cluster mode disabled with a single shard and a large node type (r6g.16xlarge) that has enough memory for 100 GB. Add 5 read replicas for read scaling.

D) Enable Redis Global Datastore for cross-region replication to achieve high availability.

E) Configure ElastiCache Serverless for Redis to automatically scale based on request volume without managing infrastructure.

---

### Question 10
A company stores financial documents in S3 with a requirement that objects must not be deleted or overwritten for 7 years. After the 7-year retention period, objects should be automatically deleted. The compliance team requires that even the root account cannot delete objects during the retention period.

Which S3 feature configuration meets these requirements?

A) Enable S3 Object Lock in Compliance mode with a retention period of 7 years. Add a lifecycle rule to delete objects after 7 years (2,555 days). In Compliance mode, no user, including the root account, can delete or overwrite the object version until the retention period expires.

B) Enable S3 Object Lock in Governance mode with a retention period of 7 years. Add a lifecycle rule to expire objects after 7 years. Governance mode prevents all deletions, including from the root account.

C) Enable versioning and create a bucket policy that denies s3:DeleteObject and s3:PutObject for all principals. Create a Lambda function to delete objects after 7 years.

D) Enable S3 Object Lock in Compliance mode with a Legal Hold. Remove the Legal Hold after 7 years using a scheduled Lambda function.

---

### Question 11
A company runs an OLTP (Online Transaction Processing) application on Amazon Aurora PostgreSQL. The database handles 50,000 transactions per second. The company needs to run analytical queries on the same data without impacting OLTP performance. The analytical queries involve complex joins across multiple tables and full table scans.

Which approach allows analytical queries without impacting OLTP performance? (Choose TWO)

A) Create an Aurora read replica specifically for analytical queries. The replica receives data from the shared Aurora storage layer with minimal lag, isolating analytical query load from the primary.

B) Use Aurora zero-ETL integration with Amazon Redshift to automatically replicate data to Redshift for analytical queries. This eliminates the need for ETL pipelines while providing an optimized analytics engine.

C) Increase the primary instance size to handle both OLTP and analytical workloads on the same instance.

D) Export data nightly to Amazon S3 using Aurora's export feature and query with Athena. This provides complete isolation from the OLTP workload.

E) Create an Aurora Global Database secondary region for analytical queries to ensure complete OLTP isolation.

---

### Question 12
A company needs to select the appropriate Amazon EFS throughput mode for a content management system. The file system stores 500 GB of data. Traffic patterns show:
- Sustained throughput of 100 MB/s during business hours (10 hours/day)
- Burst requirements up to 500 MB/s for 30 minutes during daily batch processing
- Minimal traffic (under 10 MB/s) during off-hours

Which throughput mode is MOST cost-effective?

A) Elastic throughput mode. Elastic automatically scales throughput up and down based on workload demand, charging only for the throughput consumed. This handles both the sustained 100 MB/s and the 500 MB/s bursts without overprovisioning.

B) Bursting throughput mode. With 500 GB of data, the baseline throughput is 25 MB/s (50 KB/s per GB). Burst credits allow up to 100 MB/s, which is insufficient for the sustained 100 MB/s requirement during business hours.

C) Provisioned throughput mode set to 500 MB/s to handle the burst requirement. You pay for the provisioned throughput regardless of usage.

D) Provisioned throughput mode set to 100 MB/s for the sustained requirement, relying on burst credits for the 500 MB/s peaks.

---

### Question 13
A company is using DynamoDB for a social media application. The table has a partition key of UserID and a sort key of PostTimestamp. The table has 50 GB of data with provisioned capacity of 10,000 RCUs and 5,000 WCUs. The company notices that certain celebrity users with millions of followers cause hot partition issues when their posts are read simultaneously by many users.

Which approach BEST mitigates the hot partition problem? (Choose TWO)

A) Implement a write-sharding pattern by adding a random suffix (0-9) to the partition key for celebrity users' posts. When reading, execute 10 parallel queries and combine results. This distributes reads across multiple physical partitions.

B) Enable DynamoDB Adaptive Capacity, which automatically redistributes provisioned throughput to handle unevenly distributed workloads by isolating frequently accessed items on their own partitions.

C) Add a DynamoDB Accelerator (DAX) cluster in front of the table. DAX caches frequently accessed celebrity posts, reducing read pressure on the underlying DynamoDB partitions.

D) Increase the provisioned RCUs to 50,000 to ensure enough capacity across all partitions.

E) Create a Global Secondary Index (GSI) on PostTimestamp to distribute reads more evenly across partitions.

---

### Question 14
A company runs a PostgreSQL database on Amazon RDS with the following storage requirement: consistent 30,000 IOPS with sub-millisecond latency. The database size is 2 TB. The company recently noticed that their io1 volume occasionally hits its provisioned IOPS limit.

Which storage upgrade provides the BEST performance improvement?

A) Migrate to io2 Block Express volume. io2 Block Express supports up to 256,000 IOPS with sub-millisecond latency and provides 99.999% durability (compared to io1's 99.8-99.9%). Provision 30,000 IOPS with headroom for growth.

B) Migrate to gp3 and provision 16,000 IOPS. Use two gp3 volumes in RAID 0 for the combined 32,000 IOPS.

C) Stay on io1 and increase provisioned IOPS to 64,000. Enable io1 Multi-Attach for additional performance.

D) Migrate to gp3 and provision 16,000 IOPS. The gp3 baseline of 3,000 IOPS combined with provisioned gives adequate performance.

---

### Question 15
A company stores data in an S3 bucket with versioning enabled. They need to understand the S3 storage class transition rules. The architect is planning lifecycle transitions and needs to identify which transitions are allowed.

Which of the following S3 lifecycle transitions is NOT allowed?

A) S3 Standard-IA to S3 One Zone-IA

B) S3 Standard to S3 Intelligent-Tiering

C) S3 Glacier Flexible Retrieval to S3 Standard

D) S3 Standard to S3 Glacier Deep Archive

---

### Question 16
A company is designing a data lake on Amazon S3 that will store 5 PB of data. Different datasets have different access patterns:
- Dataset A (500 TB): Accessed frequently, unpredictable patterns
- Dataset B (2 PB): Accessed quarterly for compliance reporting
- Dataset C (1 PB): Accessed once a year for audits, 12-hour retrieval acceptable
- Dataset D (1.5 PB): Never accessed after initial storage, 48-hour retrieval acceptable, must be retained for 10 years

Which storage class assignment minimizes costs?

A) Dataset A: S3 Intelligent-Tiering, Dataset B: S3 Standard-IA, Dataset C: S3 Glacier Flexible Retrieval, Dataset D: S3 Glacier Deep Archive

B) Dataset A: S3 Standard, Dataset B: S3 Standard-IA, Dataset C: S3 Glacier Instant Retrieval, Dataset D: S3 Glacier Flexible Retrieval

C) Dataset A: S3 Intelligent-Tiering, Dataset B: S3 Glacier Instant Retrieval, Dataset C: S3 Glacier Flexible Retrieval, Dataset D: S3 Glacier Deep Archive

D) All datasets in S3 Intelligent-Tiering to automatically optimize costs based on access patterns

---

### Question 17
A company runs an Amazon Redshift cluster for their data warehouse. The current cluster uses dc2.8xlarge nodes (dense compute). Queries have become slower as data volume has grown to 50 TB. The workload involves complex analytical queries with large table joins, and the company needs to improve query performance without significantly increasing costs.

Which Redshift optimization strategy provides the BEST performance improvement? (Choose TWO)

A) Switch to RA3 nodes with managed storage. RA3 nodes separate compute from storage, use local SSD cache for frequently accessed data, and automatically tier cold data to S3. This provides better price-performance for large datasets.

B) Review and optimize the distribution style for large tables. Change frequently joined tables from KEY distribution (if they share a common join column) to ensure data locality, or use AUTO distribution to let Redshift optimize.

C) Add more dc2.8xlarge nodes to the cluster to increase total memory and compute for parallel query processing.

D) Migrate the data from Redshift to Amazon RDS PostgreSQL for better query performance on complex joins.

E) Enable Redshift Spectrum to query cold data directly in S3, keeping only hot data in the Redshift cluster.

---

### Question 18
A company is migrating a MongoDB workload to AWS. The application has the following requirements:
- Document data model with nested JSON structures
- Sub-millisecond read latency for frequently accessed items
- Strong consistency for write operations
- Ability to scale to millions of requests per second
- Global tables for multi-region deployment

Which AWS database service BEST meets these requirements?

A) Amazon DynamoDB with DAX for caching. DynamoDB supports document data model with JSON, provides single-digit millisecond latency (microsecond with DAX), offers strongly consistent reads, scales to millions of requests per second, and supports global tables for multi-region replication.

B) Amazon DocumentDB (with MongoDB compatibility) for document data model support with provisioned read replicas for scaling.

C) Amazon DynamoDB without DAX. DynamoDB alone provides sub-millisecond latency and meets all other requirements.

D) Amazon ElastiCache for Redis with JSON module support for document storage, combined with persistence for durability.

---

### Question 19
A company runs a MySQL 8.0 database on Amazon RDS with a Multi-AZ deployment. The database stores 5 TB of data and the company requires a recovery point objective (RPO) of 1 hour and a recovery time objective (RTO) of 15 minutes. The company also needs to perform daily exports of the database to S3 for analytics.

Which backup and recovery strategy meets these requirements?

A) Enable automated backups with a retention period of 7 days. RDS automated backups occur daily and transaction logs are backed up every 5 minutes, providing an RPO of 5 minutes (better than the 1-hour requirement). For recovery, restore from the automated backup to a point in time within 15 minutes (RTO). Use RDS snapshot export to S3 for daily analytics exports.

B) Create manual snapshots every hour using a Lambda function triggered by EventBridge. Restore from the most recent snapshot for recovery. Use mysqldump for daily S3 exports.

C) Use RDS automated backups with a 35-day retention period. Disable Multi-AZ to reduce costs since backups provide sufficient protection. Use AWS DMS for daily exports to S3.

D) Enable automated backups and additionally create cross-region read replicas. Promote the read replica in case of a regional failure. Use the read replica for analytics queries.

---

### Question 20
A company has an Aurora PostgreSQL cluster with 2 TB of data. They need to encrypt the database, but the existing cluster was created without encryption. Aurora does not support enabling encryption on an existing unencrypted cluster.

What is the correct procedure to encrypt the existing Aurora cluster?

A) Create an unencrypted snapshot of the Aurora cluster. Copy the snapshot and enable encryption (specify a KMS key) during the copy operation. Restore a new Aurora cluster from the encrypted snapshot. Update the application endpoint to point to the new encrypted cluster.

B) Modify the existing Aurora cluster to enable encryption. Aurora will encrypt the data in-place without requiring a new cluster.

C) Use AWS DMS to replicate data from the unencrypted cluster to a new encrypted Aurora cluster in real-time, then switch over.

D) Enable encryption at the storage volume level using EBS encryption, which automatically encrypts the underlying Aurora storage.

---

### Question 21
A company stores sensitive medical images in Amazon S3. The images must be encrypted at rest using customer-managed keys, and the company needs the ability to rotate the encryption keys annually. Different departments should use different encryption keys, and the company needs to audit all key usage.

Which encryption approach meets ALL requirements?

A) Use S3 server-side encryption with AWS KMS customer managed keys (SSE-KMS). Create separate CMKs for each department. Enable automatic key rotation (annually) on each CMK. Use CloudTrail to audit all KMS key usage including S3 encryption/decryption operations.

B) Use S3 server-side encryption with S3-managed keys (SSE-S3). Create separate S3 buckets per department for key isolation. Configure key rotation through S3 settings.

C) Use S3 client-side encryption with application-managed keys. Store the keys in AWS Secrets Manager with automatic rotation configured.

D) Use S3 server-side encryption with customer-provided keys (SSE-C). Manage key rotation manually and store keys in AWS Systems Manager Parameter Store.

---

### Question 22
A company operates a time-series database for IoT sensor data. The data characteristics are:
- 100,000 sensors write data every second (100K writes/sec)
- Each data point is 1 KB
- Data older than 24 hours is only used for aggregated analysis
- Data older than 30 days is only accessed for compliance, within hours
- Total data growth: 8 TB per day

Which architecture handles the ingestion, storage, and lifecycle management MOST efficiently?

A) Use Amazon Timestream for ingestion and recent data storage. Timestream automatically moves data from the memory store (recent, fast access) to the magnetic store (older, cost-effective) based on a configurable retention period. Export data older than 30 days to S3 in Glacier Flexible Retrieval for long-term compliance.

B) Use DynamoDB with a TTL of 24 hours for hot data. Create a DynamoDB stream to export expiring data to S3 for long-term storage. Use Athena for analysis of archived data.

C) Use Amazon Kinesis Data Streams for ingestion into an Amazon RDS PostgreSQL database with TimescaleDB extension. Create a cron job to archive old data to S3.

D) Use Amazon Aurora MySQL for all data storage. Partition tables by date and drop old partitions after archiving to S3 Glacier.

---

### Question 23
A company uses Amazon DynamoDB for an e-commerce product catalog. The table has the following access patterns:
1. Get product by ProductID (primary key lookup) — 10,000 requests/sec
2. List products by Category sorted by Price — 5,000 requests/sec
3. Search products by Brand and filter by Price range — 2,000 requests/sec
4. Get products by SellerId sorted by ListingDate — 3,000 requests/sec

Which DynamoDB table design and index strategy efficiently supports ALL access patterns?

A) Table primary key: ProductID (partition key). Create three GSIs: (1) GSI with Category as partition key and Price as sort key, (2) GSI with Brand as partition key and Price as sort key, (3) GSI with SellerId as partition key and ListingDate as sort key.

B) Table primary key: Category (partition key) and ProductID (sort key). Create two GSIs for Brand+Price and SellerId+ListingDate lookups.

C) Table primary key: ProductID (partition key) and Category (sort key). Create two GSIs: one for Brand+Price and one for SellerId+ListingDate. Use Scan with FilterExpression for Category+Price queries.

D) Use a single table with a composite primary key and overloaded GSIs. Use a PK of "PRODUCT#ProductID" and SK of "METADATA" for items. Create one GSI that is overloaded to handle all three secondary access patterns.

---

### Question 24
A company needs to migrate a 10 TB Oracle database to Amazon Aurora PostgreSQL. The migration must minimize downtime. The Oracle database has complex stored procedures, triggers, and custom functions that need to be converted to PostgreSQL syntax.

Which migration approach minimizes downtime and addresses schema conversion?

A) Use the AWS Schema Conversion Tool (SCT) to convert the Oracle schema, stored procedures, and functions to PostgreSQL syntax. Use AWS DMS for the initial full load and ongoing Change Data Capture (CDC) replication. Cut over to Aurora PostgreSQL when replication lag is minimal.

B) Export the Oracle database using Data Pump, upload to S3, and import into Aurora PostgreSQL. Manually convert stored procedures and functions.

C) Use AWS DMS for a one-time full load migration. Stop the source database during migration to ensure consistency. Manually rewrite stored procedures after migration.

D) Create an Aurora PostgreSQL read replica of the Oracle database for real-time replication, then promote the replica during cutover.

---

### Question 25
A company stores files in Amazon EFS that are accessed by a fleet of EC2 instances. The company has noticed that throughput has dropped below acceptable levels during business hours. The current file system size is 100 GB, which in Bursting throughput mode provides only 5 MB/s baseline throughput (50 KB/s per GB). The workload requires a consistent 200 MB/s.

Which change addresses the throughput issue with the LEAST cost?

A) Switch to Elastic throughput mode. Elastic charges only for throughput used and can scale up to the file system's maximum throughput. Since the workload is consistent during business hours and low at night, Elastic avoids paying for provisioned throughput during off-hours.

B) Switch to Provisioned throughput mode and set it to 200 MB/s. This guarantees 200 MB/s regardless of file system size.

C) Add additional dummy data to the file system to increase its size to 4 TB, which would provide 200 MB/s baseline throughput in Bursting mode (50 KB/s × 4,000 GB = 200 MB/s).

D) Migrate from EFS to FSx for Lustre for higher throughput at a lower cost per MB/s.

---

### Question 26
A company is designing a DynamoDB table for a gaming leaderboard. Requirements:
- Store player scores with PlayerID, GameID, Score, and Timestamp
- Query top 100 scores per game (global leaderboard)
- Query a specific player's scores across all games
- Support atomic score updates
- Handle 50,000 writes per second during peak gaming hours

Which table design and features address ALL requirements?

A) Table: PlayerID (partition key), GameID (sort key). GSI: GameID (partition key), Score (sort key) for leaderboard queries. Use DynamoDB on-demand capacity mode for peak traffic handling. Use UpdateItem with atomic counter for score updates.

B) Table: GameID (partition key), Score (sort key). This directly supports leaderboard queries. Create a GSI with PlayerID as partition key for player-specific queries.

C) Table: PlayerID (partition key), Timestamp (sort key). Use Scan operations with filters for leaderboard and game-specific queries. Provision 50,000 WCUs for peak traffic.

D) Table: GameID (partition key), PlayerID (sort key). Store scores as a list attribute on the GameID item. Use UpdateExpression to modify the list.

---

### Question 27
A company runs Amazon Aurora MySQL as their primary database. They need a disaster recovery solution that provides:
- RPO of less than 1 second
- RTO of less than 1 minute
- Automatic failover to a different AWS Region
- Read capacity in the DR region during normal operations

Which Aurora feature meets ALL requirements?

A) Aurora Global Database. It provides cross-region replication with less than 1 second lag (RPO < 1 second), automatic planned failover and manual unplanned failover to the secondary region (RTO typically under 1 minute for planned), and the secondary cluster can serve read traffic during normal operations.

B) Aurora cross-region read replica with manual promotion. This provides read capacity in the DR region but requires manual intervention for failover.

C) Aurora with automated backups and cross-region snapshot copy. Restore from snapshot in the DR region when needed.

D) Aurora Multi-AZ with cross-region backup replication. Multi-AZ provides automatic failover within a region but not across regions.

---

### Question 28
A company uses S3 for storing application logs. They have configured a lifecycle policy to transition objects from S3 Standard to S3 Glacier Flexible Retrieval after 60 days. The company now realizes they occasionally need to access objects between 30-60 days old, and these retrievals are incurring high costs due to S3 Standard pricing.

Which modification to the lifecycle policy reduces costs while maintaining accessibility? (Choose TWO)

A) Add a transition to S3 Standard-IA at 30 days before the Glacier transition at 60 days. Standard-IA is cheaper than Standard for infrequently accessed data and provides immediate retrieval.

B) Keep the minimum storage duration requirement in mind: objects must remain in Standard-IA for at least 30 days before transitioning to another class, so the Standard-IA transition at 30 days and Glacier at 60 days works correctly (30 days in IA before Glacier).

C) Transition directly from S3 Standard to S3 Glacier Flexible Retrieval at 30 days instead of 60 days to save costs sooner. Use Glacier Expedited retrieval when access is needed.

D) Replace the entire policy with S3 Intelligent-Tiering, which has no retrieval fees and automatically moves objects to IA tiers after 30 days of non-access.

E) Add a transition to S3 One Zone-IA at 30 days to save more than Standard-IA. Objects between 30-60 days don't need multi-AZ resilience.

---

### Question 29
A company needs to select a database for an application that requires:
- ACID transactions across multiple tables
- Complex SQL queries with joins across 10+ tables
- Automatic storage scaling up to 128 TB
- Up to 15 read replicas with minimal replication lag
- Automatic failover with no data loss

Which database service meets ALL requirements?

A) Amazon Aurora (MySQL or PostgreSQL compatible). Aurora supports ACID transactions, complex SQL joins, automatically scales storage up to 128 TB, supports up to 15 read replicas with typical replication lag under 20ms (shared storage architecture), and provides automatic failover with zero data loss.

B) Amazon RDS MySQL with Multi-AZ. RDS supports ACID transactions and SQL joins, but storage scales to 64 TB maximum and supports up to 5 read replicas.

C) Amazon DynamoDB with transactions enabled. DynamoDB supports transactions but doesn't support traditional SQL joins or complex relational queries.

D) Amazon Redshift for complex SQL queries with joins. Redshift supports complex queries but is optimized for analytics, not OLTP, and doesn't support automatic failover.

---

### Question 30
A company is designing an archival solution for 500 TB of historical data. The data must be retained for 10 years and will likely never be accessed. In the rare event of access, the company can wait up to 48 hours for data retrieval. The company wants to minimize storage costs.

Which storage solution provides the LOWEST cost?

A) Amazon S3 Glacier Deep Archive. It is the lowest-cost storage class in AWS, designed for data that is rarely accessed and where retrieval times of 12-48 hours are acceptable. Standard retrieval is within 12 hours, and Bulk retrieval within 48 hours.

B) Amazon S3 Glacier Flexible Retrieval. It provides retrieval within 3-5 hours at a slightly higher cost than Deep Archive.

C) Amazon S3 Glacier Instant Retrieval. It provides millisecond retrieval but costs more than other Glacier tiers.

D) Store data on magnetic tape using AWS Storage Gateway (Tape Gateway) and archive virtual tapes to a Virtual Tape Shelf (VTS) backed by S3 Glacier Deep Archive.

---

### Question 31
A company is evaluating Amazon ElastiCache for a high-throughput application. They need to cache 500 GB of data with the following requirements:
- Data must be distributed across nodes for scalability
- The cache must survive node failures without data loss
- The application needs to perform complex queries (intersections, unions) on cached data sets
- Sub-millisecond response times

Which ElastiCache configuration is appropriate?

A) ElastiCache for Redis with cluster mode enabled. Create a cluster with multiple shards (each shard has a primary and replica nodes for high availability). Redis cluster mode distributes data across shards using hash slots, supports complex data structures and operations (SUNION, SINTER), and provides sub-millisecond latency.

B) ElastiCache for Memcached with multiple nodes. Memcached supports distributed caching with consistent hashing and provides sub-millisecond latency.

C) ElastiCache for Redis with cluster mode disabled and a single large node (r6g.16xlarge) that supports 500+ GB. Add replicas for availability.

D) ElastiCache for Redis Serverless to automatically scale and distribute data across nodes.

---

### Question 32
A company's application uses Amazon RDS PostgreSQL with a 1 TB gp2 volume. The application occasionally needs burst IOPS during month-end reporting but runs at low IOPS during normal operations. The gp2 volume provides 3,000 baseline IOPS (3 IOPS/GB × 1,000 GB) and burst up to 3,000 IOPS (already at maximum baseline). Month-end reports require 10,000 IOPS for approximately 4 hours.

Which approach addresses the periodic high IOPS requirement MOST cost-effectively?

A) Migrate from gp2 to gp3 and configure 10,000 provisioned IOPS. gp3 provides a baseline of 3,000 IOPS for free and allows provisioning additional IOPS independently of volume size, at a lower per-IOPS cost than io1/io2. You pay for 7,000 additional IOPS (10,000 - 3,000 baseline).

B) Increase the gp2 volume size to 3.34 TB (10,002 IOPS at 3 IOPS/GB) to achieve 10,000 baseline IOPS.

C) Migrate to io1 with 10,000 provisioned IOPS for guaranteed performance during month-end.

D) Create a read replica on a separate instance with higher IOPS capacity and route month-end reporting queries to the replica.

---

### Question 33
A company is using Amazon DynamoDB Global Tables for a multi-region e-commerce application. The table is replicated across us-east-1, eu-west-1, and ap-southeast-1. A customer places an order in eu-west-1 and immediately queries for the order from us-east-1.

What consistency behavior should the application expect?

A) DynamoDB Global Tables provides eventual consistency for cross-region reads. The order written in eu-west-1 may not be immediately visible in us-east-1. Replication typically completes within 1 second, but the application should be designed to handle eventual consistency for cross-region reads. Strongly consistent reads are only available within the same region where the write occurred.

B) DynamoDB Global Tables provides strong consistency across all regions. The order will be immediately visible in us-east-1 after being written in eu-west-1.

C) DynamoDB Global Tables uses a consensus protocol that guarantees the order is visible in all regions within 100 milliseconds.

D) The read in us-east-1 will fail with a ConsistencyError until replication completes.

---

### Question 34
A company needs to choose between Amazon FSx for Windows File Server and Amazon FSx for Lustre for a new workload. The workload involves Windows-based applications that require SMB protocol access, Active Directory integration, and NTFS file system features. The workload handles mixed file sizes and needs consistent performance.

Which FSx option and configuration is correct?

A) Amazon FSx for Windows File Server. It provides native SMB protocol support, integrates with AWS Managed Microsoft AD or self-managed AD, supports NTFS features (ACLs, shadow copies, DFS), and offers SSD and HDD storage options for different performance needs.

B) Amazon FSx for Lustre with a Windows-compatible driver. Configure Lustre to support SMB protocol and Active Directory authentication.

C) Amazon FSx for Windows File Server with Multi-AZ deployment for high availability. Configure with SSD storage for consistent performance and enable automatic backups.

D) Both A and C are correct, with C being the more complete answer.

---

### Question 35
A company stores 100 TB of data in Amazon S3 Standard. They want to analyze the access patterns of all objects to determine which storage class is most cost-effective for each object. The company has millions of objects with varying access patterns.

Which S3 feature provides this analysis?

A) Enable S3 Storage Class Analysis on the bucket. It monitors access patterns for 30 days or more and provides recommendations for when to transition objects to Standard-IA or One Zone-IA based on actual access frequency.

B) Enable S3 Storage Lens to get organization-wide visibility into object storage usage and activity trends, including recommendations for cost optimization.

C) Enable S3 Inventory to generate a daily or weekly CSV listing all objects and their storage classes. Manually analyze the inventory reports.

D) Use Amazon Macie to analyze data access patterns and recommend storage class transitions.

---

### Question 36
A company needs a database solution for a write-heavy application that generates:
- 200,000 writes per second
- Each write is 1 KB
- Read requirements: 50,000 eventually consistent reads per second
- Total data size will grow to 20 TB
- Data model is key-value with simple lookups by primary key

Which database solution handles this workload MOST cost-effectively?

A) Amazon DynamoDB with on-demand capacity mode. DynamoDB natively supports the key-value access pattern, scales to handle millions of requests per second, and on-demand mode automatically adjusts to the traffic pattern without capacity planning. For sustained high traffic, provisioned capacity with auto-scaling may be more cost-effective.

B) Amazon Aurora MySQL with a Multi-AZ deployment and multiple read replicas for read scaling.

C) Amazon ElastiCache for Redis cluster mode enabled as the primary database with persistence enabled.

D) Amazon RDS PostgreSQL on a db.r6g.16xlarge instance with io2 volumes for write performance.

---

### Question 37
A company uses Amazon Aurora PostgreSQL and needs to share database snapshots with other AWS accounts for development and testing. The production database contains sensitive customer PII (Personally Identifiable Information). The company must ensure that shared snapshots do not contain PII.

Which approach securely shares database snapshots without PII?

A) Create an Aurora clone of the production database. Run data masking/anonymization scripts on the clone to remove or obfuscate PII. Take a snapshot of the anonymized clone and share it with the target accounts.

B) Share the production snapshot directly with the target accounts and use IAM policies to restrict access to PII columns.

C) Export the Aurora database to S3 using Aurora's export feature. Use AWS Glue to transform and mask PII data. Import the masked data into a new Aurora cluster in the target accounts.

D) Create a cross-account Aurora read replica in the target accounts. Use database-level views to filter out PII columns from the replica.

---

### Question 38
A company uses Amazon S3 to store objects with the following requirements:
- Objects in the "finance/" prefix must be encrypted with a specific KMS key (Key-A)
- Objects in the "hr/" prefix must be encrypted with a different KMS key (Key-B)
- All other objects must be encrypted with the default S3-managed key (SSE-S3)
- Uploads that don't comply with these encryption requirements must be rejected

Which configuration enforces these encryption requirements?

A) Create an S3 bucket policy with conditions that deny PutObject requests for the "finance/" prefix unless the request includes SSE-KMS with Key-A, deny PutObject for "hr/" prefix unless SSE-KMS with Key-B is specified, and set the default bucket encryption to SSE-S3 for all other objects.

B) Configure three separate buckets — one for finance, one for HR, and one for everything else — each with its own default encryption configuration.

C) Set default bucket encryption to SSE-KMS with Key-A. Use Lambda triggers to re-encrypt objects uploaded to "hr/" with Key-B and objects in other prefixes with SSE-S3.

D) Use S3 Object Lambda to intercept PutObject requests and apply the correct encryption key based on the prefix.

---

### Question 39
A company runs a data lake with the following storage layout on S3:
- Raw zone: 50 TB, accessed daily for ETL processing
- Processed zone: 200 TB, accessed weekly for analytics
- Curated zone: 30 TB, accessed multiple times daily by business users
- Archive zone: 500 TB, accessed annually for compliance

The company wants to optimize storage costs. What is the estimated monthly storage cost savings from moving each zone to the most appropriate storage class compared to keeping everything in S3 Standard?

A) Raw zone: S3 Standard (frequent daily access warrants Standard), Processed zone: S3 Standard-IA (weekly access is infrequent), Curated zone: S3 Standard (frequent daily access), Archive zone: S3 Glacier Deep Archive (annual access). Approximate savings: ~60-70% on total storage costs.

B) All zones in S3 Intelligent-Tiering to automatically optimize costs without managing individual transitions.

C) Raw zone: S3 Standard-IA, Processed zone: S3 Glacier Instant Retrieval, Curated zone: S3 Standard, Archive zone: S3 Glacier Flexible Retrieval. Approximate savings: ~50%.

D) Raw zone: S3 One Zone-IA, Processed zone: S3 One Zone-IA, Curated zone: S3 Standard, Archive zone: S3 Glacier Deep Archive. Maximum savings by using One Zone-IA where possible.

---

### Question 40
A company has an Amazon Redshift cluster and needs to query data that resides both in the Redshift cluster (recent hot data, 5 TB) and in Amazon S3 (historical cold data, 500 TB in Parquet format). The queries frequently need to join hot and cold data.

Which Redshift feature enables querying data across both storage locations?

A) Amazon Redshift Spectrum. It allows you to query data directly in S3 using Redshift SQL, joining it with data in local Redshift tables. Create external tables pointing to the S3 data and use them in queries alongside local tables. Redshift Spectrum uses separate compute resources that scale independently.

B) Use COPY command to load S3 data into temporary Redshift tables before running the join query, then drop the temporary tables.

C) Create a Redshift federated query to Amazon Athena, which queries the S3 data. Join the Athena results with local Redshift tables.

D) Use Amazon Redshift data sharing to share the S3 data location with the Redshift cluster for direct access.

---

### Question 41
A company is designing a storage solution for a high-performance computing (HPC) application. The application requires:
- POSIX-compliant shared file system
- 100 GB/s aggregate throughput
- Sub-millisecond latency
- Tight integration with S3 for data staging
- Short-term storage (computation completes in 24-48 hours)

Which storage solution meets ALL requirements?

A) Amazon FSx for Lustre scratch file system with an S3 data repository association. Lustre scratch provides the highest throughput (up to 200 MB/s per TiB), sub-millisecond latency, POSIX compliance, and direct S3 integration for importing/exporting data. Scratch is cost-effective for temporary data.

B) Amazon EFS with Max I/O performance mode and provisioned throughput. EFS provides POSIX compliance and S3 integration through DataSync.

C) Amazon FSx for Lustre persistent file system for maximum data durability during the 24-48 hour computation.

D) Multiple EBS io2 volumes in RAID 0 configuration attached to each instance for maximum throughput.

---

### Question 42
A company needs to store session data for a web application with the following requirements:
- Sub-millisecond read/write latency
- Automatic expiration of sessions after 30 minutes of inactivity
- High availability across multiple AZs
- Support for up to 1 million concurrent sessions
- Each session is approximately 5 KB

Which solution meets ALL requirements?

A) Amazon DynamoDB with TTL (Time to Live) enabled. Set the TTL attribute to the session expiration timestamp (current time + 30 minutes, updated on each access). DynamoDB provides single-digit millisecond latency, scales automatically, and is replicated across 3 AZs for high availability. On-demand capacity handles variable session loads.

B) Amazon ElastiCache for Redis with a cluster mode enabled configuration. Use Redis EXPIRE command to set 30-minute TTL on session keys. Configure Multi-AZ with automatic failover for high availability.

C) Amazon RDS MySQL with an in-memory table for session storage. Configure a scheduled event to delete expired sessions every minute.

D) Amazon S3 with a lifecycle rule to expire objects after 30 minutes. Use S3 Event Notifications to clean up expired sessions.

---

### Question 43
A company runs an Aurora MySQL cluster and needs to perform online DDL operations (adding columns, creating indexes) on a large table (500 million rows) without impacting application performance. The table receives 10,000 transactions per second.

Which approach minimizes the impact on application performance?

A) Use Aurora's fast DDL (instant DDL) feature for supported operations like adding nullable columns. For index creation, Aurora supports online DDL using the ALGORITHM=INPLACE option, which avoids table copying and allows concurrent DML operations during the index build.

B) Create a new Aurora clone, perform the DDL on the clone, then switch the application to the clone.

C) Stop all write operations using a maintenance window, perform the DDL, and then resume operations.

D) Create a read replica, perform DDL on the replica, then promote the replica to primary and redirect the application.

---

### Question 44
A company stores confidential documents in S3 and requires that deleted objects can be recovered for up to 30 days. The company also wants to protect against accidental bucket deletion. However, they want to permanently remove objects older than 365 days.

Which combination of S3 features provides this protection? (Choose THREE)

A) Enable S3 Versioning to retain previous versions of objects when they are deleted (delete markers are placed, but previous versions remain)

B) Create a lifecycle rule to permanently delete non-current versions after 30 days (NoncurrentVersionExpiration with NoncurrentDays: 30) and delete current versions after 365 days (Expiration with Days: 365)

C) Enable MFA Delete on the bucket to require multi-factor authentication for permanent version deletions and bucket deletion

D) Create a bucket policy that denies s3:DeleteBucket for all principals except a specific admin role

E) Enable S3 Object Lock in Governance mode with a 30-day retention period on all objects

F) Use Cross-Region Replication to copy all objects to a backup bucket for additional protection

---

### Question 45
A company has a DynamoDB table with the following throughput pattern:
- Daytime (12 hours): 50,000 RCUs, 20,000 WCUs
- Nighttime (12 hours): 5,000 RCUs, 2,000 WCUs
- Occasional unpredictable spikes of 100,000 RCUs for 30 minutes

Which capacity mode MOST cost-effectively handles this pattern?

A) Provisioned capacity with Auto Scaling. Set minimum capacity to handle nighttime traffic (5,000 RCU / 2,000 WCU) and maximum to handle spikes (100,000 RCU / 25,000 WCU). Auto Scaling adjusts capacity based on utilization targets. This is more cost-effective than on-demand for predictable sustained traffic patterns.

B) On-demand capacity mode. It automatically handles all traffic levels without capacity planning and adjusts instantly to spikes. Pay per request.

C) Provisioned capacity without Auto Scaling. Set capacity to 100,000 RCUs / 25,000 WCUs to handle peak traffic at all times.

D) Reserved capacity for the daytime baseline with on-demand for spikes. Use DynamoDB reserved capacity pricing for the predictable 50,000 RCU / 20,000 WCU.

---

### Question 46
A company is designing a multi-tier application architecture with the following database requirements:
- Tier 1 (User sessions): Sub-millisecond latency, 10,000 reads/sec, key-value access pattern, data expires in 24 hours
- Tier 2 (Product catalog): Single-digit millisecond latency, complex queries with joins, 500 GB data
- Tier 3 (Order history): Write-heavy, 50,000 writes/sec, simple queries by customer ID, 10 TB data
- Tier 4 (Analytics): Complex aggregations across all data, batch processing, 100 TB

Which combination of databases is MOST appropriate? (Choose FOUR)

A) Tier 1: Amazon ElastiCache for Redis (sub-millisecond key-value with TTL support)

B) Tier 2: Amazon Aurora PostgreSQL (relational with complex joins, managed scaling)

C) Tier 3: Amazon DynamoDB (high write throughput, key-value/document with simple queries)

D) Tier 4: Amazon Redshift (columnar storage optimized for complex analytical queries)

E) Tier 1: Amazon DynamoDB (single-digit millisecond, not sub-millisecond)

F) Tier 2: Amazon DynamoDB (does not support complex SQL joins)

G) Tier 3: Amazon Aurora MySQL (may struggle with 50,000 writes/sec consistently)

H) Tier 4: Amazon RDS PostgreSQL (not optimized for analytical queries at 100 TB scale)

---

### Question 47
A company is using Amazon S3 Intelligent-Tiering for a bucket with 50 TB of data. The data consists of 10 million objects. The company is reviewing their costs and notices Intelligent-Tiering monitoring fees.

Which statement about S3 Intelligent-Tiering pricing is correct?

A) S3 Intelligent-Tiering charges a small monthly monitoring and automation fee per object (currently $0.0025 per 1,000 objects monitored). There are no retrieval fees when objects move between tiers. The service automatically moves objects between Frequent Access, Infrequent Access (after 30 days), and Archive tiers based on access patterns.

B) S3 Intelligent-Tiering has no additional fees beyond storage costs. The monitoring is included in the storage price.

C) S3 Intelligent-Tiering charges retrieval fees when objects are moved from Infrequent Access back to Frequent Access, similar to S3 Standard-IA.

D) S3 Intelligent-Tiering monitoring fees are charged per GB of storage, not per object.

---

### Question 48
A company has a workload that requires an EBS volume providing 100,000 IOPS with a volume size of 500 GB. The application runs on a Nitro-based EC2 instance.

Which EBS volume type can meet this IOPS requirement?

A) io2 Block Express. It supports up to 256,000 IOPS and up to 64 TB volume size. The IOPS-to-volume-size ratio can be up to 1,000:1 (vs. 500:1 for standard io2), so a 500 GB volume can achieve up to 500,000 IOPS with Block Express. Requires Nitro-based instances.

B) Standard io2. It supports up to 64,000 IOPS with a 500:1 IOPS-to-volume ratio. A 500 GB volume can only achieve 64,000 IOPS (500 × 500 ÷ 500... actually 500 GB × 500 IOPS/GB = 250,000 but capped at 64,000). This does not meet 100,000 IOPS.

C) gp3 with maximum provisioned IOPS. gp3 supports up to 16,000 IOPS, which is insufficient for 100,000 IOPS.

D) io1 with maximum provisioned IOPS. io1 supports up to 64,000 IOPS, which is insufficient for 100,000 IOPS.

---

### Question 49
A company stores data in Amazon S3 and wants to transition objects to cheaper storage classes using lifecycle rules. The following rules must be configured:
1. Transition from Standard to Standard-IA after 30 days
2. Transition from Standard-IA to Glacier Flexible Retrieval after 60 days
3. Transition from Glacier Flexible Retrieval to Glacier Deep Archive after 180 days
4. Delete objects after 365 days

What are the constraints the architect must consider? (Choose TWO)

A) Objects must be stored for a minimum of 30 days in S3 Standard before transitioning to S3 Standard-IA. The lifecycle rule's 30-day transition satisfies this constraint.

B) Objects must remain in S3 Standard-IA for a minimum of 30 days before transitioning to another class. Since the transition to Glacier is at day 60 (30 days after Standard-IA transition), this constraint is satisfied.

C) There is no minimum storage duration constraint for S3 Standard. Objects can be transitioned to any class immediately after creation.

D) S3 Glacier Flexible Retrieval has a minimum storage duration of 90 days. Objects transitioned at day 60 must stay in Glacier until day 150, meaning the Deep Archive transition at day 180 satisfies this constraint.

E) Objects cannot be transitioned directly from S3 Standard-IA to Glacier Deep Archive; they must pass through Glacier Flexible Retrieval first.

---

### Question 50
A company runs a mission-critical Oracle database on Amazon RDS. The database requires:
- 99.99% availability
- Automatic failover with no data loss
- Cross-AZ data replication
- Support for up to 80,000 IOPS

Which RDS configuration meets these requirements?

A) RDS Multi-AZ deployment with a db.r5.24xlarge instance and io2 EBS volumes provisioned with 80,000 IOPS. Multi-AZ provides synchronous replication to a standby in a different AZ, automatic failover (typically 60-120 seconds), and zero data loss during failover.

B) RDS with two read replicas in different AZs for high availability. Promote a read replica if the primary fails.

C) RDS Single-AZ with automated backups every 5 minutes. Restore from the latest backup in case of failure.

D) RDS Multi-AZ with gp3 volumes provisioned to 16,000 IOPS and enable read replicas for additional IOPS.

---

### Question 51
A company wants to implement a caching strategy for their API responses. The cache requirements are:
- Cache API responses for 5 minutes
- Invalidate specific cache entries when underlying data changes
- Support cache entries up to 1 MB in size
- Cache must survive instance failures
- Sub-millisecond read latency

Which caching solution meets ALL requirements?

A) Amazon ElastiCache for Redis with cluster mode enabled and Multi-AZ. Use SET with EX (expiration in seconds) set to 300 for 5-minute TTL. Use DEL command for targeted invalidation. Redis supports values up to 512 MB. Multi-AZ provides failover resilience.

B) Amazon CloudFront with custom cache policies set to 5-minute TTL. Use CloudFront invalidation API for specific path invalidation.

C) Amazon ElastiCache for Memcached with multiple nodes. Use SET with expiration flag for TTL. Memcached supports values up to 1 MB (default, extendable to 128 MB with slab configuration).

D) Amazon DynamoDB with DAX (DynamoDB Accelerator) for microsecond caching with TTL attributes.

---

### Question 52
A company needs to migrate 50 TB of data from an on-premises NFS file server to Amazon EFS. The data must be transferred over an existing 1 Gbps Direct Connect connection. The company needs the migration to complete within 7 days, and files must maintain their original permissions, timestamps, and symbolic links.

Which migration tool is MOST appropriate?

A) AWS DataSync. It is purpose-built for transferring data between on-premises storage and AWS storage services (including EFS). DataSync preserves file metadata (permissions, timestamps, symlinks), can saturate a 1 Gbps connection (~10 TB/day throughput), and completing 50 TB in 5 days over 1 Gbps is achievable. DataSync uses a software agent installed on-premises.

B) AWS Transfer Family (SFTP/FTP) to upload files from the NFS server to EFS via an SFTP endpoint.

C) Use rsync over the Direct Connect connection to copy files from the on-premises NFS server to EFS mounted on an EC2 instance.

D) AWS Storage Gateway File Gateway to create a cached copy of the NFS data, then migrate to EFS.

---

### Question 53
A company uses Amazon Aurora PostgreSQL with a large database (10 TB). They need to create an exact copy of the production database for testing purposes. The copy must be available within minutes, not hours. The test team needs full read/write access to the copy without impacting production.

Which approach creates the copy FASTEST?

A) Use Aurora cloning. Aurora clone creates a copy of the database cluster using a copy-on-write protocol. The clone is available within minutes regardless of database size, and changes to the clone do not affect the original. The clone initially shares the same underlying storage, with new pages allocated only when data is modified.

B) Create an Aurora snapshot and restore it to a new cluster. Snapshots of 10 TB databases take hours to restore.

C) Create an Aurora read replica and promote it to a standalone cluster. Promotion takes time and temporarily impacts the primary.

D) Use AWS DMS to create a real-time copy of the database to a new Aurora cluster. DMS full load of 10 TB takes many hours.

---

### Question 54
A company is designing a DynamoDB table and needs to estimate capacity requirements. The application has the following characteristics:
- Average item size: 4 KB
- Required strongly consistent reads: 10,000 per second
- Required writes: 5,000 per second
- Read pattern: mostly point reads (GetItem)

How many RCUs and WCUs should be provisioned?

A) RCUs: 10,000. Each strongly consistent read of up to 4 KB consumes 1 RCU. 10,000 reads/sec × 1 RCU = 10,000 RCUs. WCUs: 5,000. Each write of up to 1 KB consumes 1 WCU. Items are 4 KB, so each write consumes 4 WCUs. 5,000 writes/sec × 4 WCUs = 20,000 WCUs.

B) RCUs: 5,000. Each strongly consistent read of up to 4 KB consumes 0.5 RCU. WCUs: 20,000. Each write of 4 KB consumes 4 WCUs.

C) RCUs: 20,000. Each strongly consistent read of 4 KB consumes 2 RCUs. WCUs: 5,000. Each write of up to 4 KB consumes 1 WCU.

D) RCUs: 10,000. Each strongly consistent read of up to 4 KB consumes 1 RCU. WCUs: 20,000. Each write of up to 1 KB consumes 1 WCU, and each 4 KB item requires 4 WCUs per write.

---

### Question 55
A company has an Amazon RDS MySQL database that has grown to 16 TB. Performance has degraded significantly, and the company is considering migration options. The application uses complex SQL queries and requires ACID compliance.

Which migration path provides the MOST performance improvement with the LEAST application changes?

A) Migrate from RDS MySQL to Amazon Aurora MySQL. Aurora is MySQL-compatible (minimal application changes needed), provides up to 5x throughput improvement over standard MySQL, scales storage automatically up to 128 TB, and its distributed storage system provides better I/O performance.

B) Migrate from RDS MySQL to Amazon DynamoDB for better scalability. Rewrite queries to use DynamoDB's query API.

C) Vertically scale the RDS MySQL instance to the largest available instance type (db.r6g.16xlarge) with io2 volumes.

D) Migrate from RDS MySQL to Amazon Redshift for better performance on large datasets and complex queries.

---

### Question 56
A company needs to store and query graph data representing relationships between 10 million users, their connections, and their interactions on a social network. Common queries include:
- Find friends of friends (2-hop relationships)
- Find the shortest path between two users
- Recommend connections based on mutual friends

Which database service is BEST suited for this workload?

A) Amazon Neptune. Neptune is a graph database service that supports property graph (Gremlin) and RDF (SPARQL) query languages. It is optimized for traversing relationships, finding shortest paths, and making recommendations based on graph patterns — all key requirements for social network queries.

B) Amazon DynamoDB with a GSI on user relationships. Model the graph as an adjacency list in DynamoDB items.

C) Amazon RDS PostgreSQL with recursive CTEs for graph traversal queries.

D) Amazon OpenSearch Service with nested documents representing user relationships.

---

### Question 57
A company needs to implement database-level encryption for Amazon RDS PostgreSQL. They require:
- Encryption of data at rest (storage, backups, snapshots, read replicas)
- Encryption of data in transit between the application and the database
- Encryption of specific sensitive columns (e.g., Social Security numbers) even from database administrators

Which combination of features meets ALL requirements? (Choose THREE)

A) Enable RDS encryption at rest using AWS KMS. This encrypts the underlying storage, automated backups, snapshots, and read replicas.

B) Configure the RDS instance to require SSL/TLS connections by setting the rds.force_ssl parameter to 1. Distribute the RDS CA certificate to application clients.

C) Use PostgreSQL's pgcrypto extension to encrypt sensitive column values at the application level before storing in the database, with encryption keys managed in AWS KMS or Secrets Manager.

D) Use AWS CloudHSM to manage encryption keys for RDS encryption at rest, providing exclusive single-tenant key management.

E) Enable Amazon RDS Transparent Data Encryption (TDE) for column-level encryption.

F) Use SSL certificates on the EC2 application servers but not on the RDS connection, since RDS encrypts data in transit by default.

---

### Question 58
A company is evaluating Amazon Aurora Serverless v2 for a development/testing environment that has highly variable workload patterns:
- Idle for 16 hours per day (nights and weekends)
- Light usage (2-5 ACUs) for 4 hours per day
- Heavy usage (30-50 ACUs) for 4 hours per day during testing
- Occasional burst to 100 ACUs for load testing (once per week)

Which statement about Aurora Serverless v2 is correct for this use case?

A) Aurora Serverless v2 scales between a configured minimum and maximum ACU range (e.g., 0.5 to 128 ACUs). It scales in increments of 0.5 ACU and adjusts within seconds based on demand. You pay for the ACUs consumed per second. For this variable workload, it is cost-effective compared to provisioned instances that would need to handle the peak 100 ACU load.

B) Aurora Serverless v2 can scale to zero ACUs during idle periods, completely eliminating costs during the 16 idle hours.

C) Aurora Serverless v2 takes 5-10 minutes to scale up, making it unsuitable for the sudden burst to 100 ACUs during load testing.

D) Aurora Serverless v2 has a maximum capacity of 64 ACUs, which cannot handle the 100 ACU burst requirement.

---

### Question 59
A company operates a data warehouse on Amazon Redshift. They need to load data from multiple sources:
- Real-time clickstream data from Kinesis Data Streams
- Daily CSV files (50 GB each) from S3
- Hourly extracts from an Amazon RDS PostgreSQL database

Which loading strategy is MOST efficient for each data source? (Choose THREE)

A) Use Amazon Kinesis Data Firehose to deliver clickstream data directly to Redshift with micro-batch loading (minimum 60-second buffer)

B) Use the Redshift COPY command to load CSV files from S3. Split files into multiple smaller files (matching the number of slices in the cluster) for parallel loading.

C) Use Redshift Federated Query to directly query the RDS PostgreSQL database from Redshift without needing to extract and load the data.

D) Use AWS DMS to continuously replicate the clickstream data from Kinesis to Redshift.

E) Load CSV files row by row using INSERT statements through a JDBC connection for maximum control.

F) Use pg_dump to export from RDS PostgreSQL and pg_restore to import into Redshift.

---

### Question 60
A company stores 10 PB of data across multiple S3 buckets in a single account. They need comprehensive visibility into:
- Total storage usage across all buckets
- Cost breakdown by storage class
- Data protection metrics (versioning, encryption, replication status)
- Activity metrics (request counts by bucket)
- Recommendations for cost optimization

Which S3 feature provides this organization-wide visibility?

A) Amazon S3 Storage Lens. It provides organization-wide visibility into object storage usage, activity, and cost-efficiency. It includes dashboards with metrics for storage, cost, data protection, access patterns, and performance, plus actionable recommendations.

B) Amazon S3 Inventory reports combined with Amazon QuickSight for visualization.

C) AWS Cost Explorer with S3-specific filtering for cost analysis.

D) Enable S3 server access logging on all buckets and analyze logs with Amazon Athena.

---

### Question 61
A company has a DynamoDB table with the following characteristics:
- Partition key: CustomerID
- Sort key: OrderDate
- Table size: 500 GB
- The company needs to efficiently query orders across all customers for a specific date range (e.g., all orders from last month)

Which DynamoDB feature supports this cross-partition query efficiently?

A) Create a Global Secondary Index (GSI) with a different partition key. Use a GSI with a computed attribute (e.g., YYYY-MM) as the partition key and OrderDate as the sort key. This allows querying all orders for a specific month efficiently across all customers. Distribute the GSI partition key to avoid hot partitions.

B) Use a Scan operation with a FilterExpression on OrderDate. This reads the entire table and filters results, which is inefficient but functional.

C) Use a Query operation with OrderDate as the key condition. This only works within a single partition (CustomerID) and cannot query across all customers.

D) Create a Local Secondary Index (LSI) with OrderDate as an alternate sort key. This allows querying by date within each partition.

---

### Question 62
A company needs to implement a backup strategy for their Amazon DynamoDB tables that allows:
- Point-in-time recovery to any second in the last 35 days
- Full table backups for long-term retention
- Cross-region backup copies for disaster recovery
- Backup of tables with global tables (multi-region) configuration

Which combination of features provides comprehensive backup coverage? (Choose TWO)

A) Enable DynamoDB Point-in-Time Recovery (PITR). It provides continuous backups with the ability to restore to any second within the last 35 days with no impact on table performance.

B) Use AWS Backup for DynamoDB to create scheduled full backups with retention policies. AWS Backup supports cross-region copy of DynamoDB backups and works with tables that have global tables configuration.

C) Use DynamoDB Streams with a Lambda function to continuously replicate changes to an S3 bucket for long-term backup retention.

D) Create manual DynamoDB on-demand backups using a scheduled Lambda function. Use S3 Cross-Region Replication for cross-region copies.

E) Export DynamoDB tables to S3 using the native DynamoDB Export to S3 feature and replicate S3 data across regions.

---

### Question 63
A company is migrating a Windows-based file server to AWS. The file server stores 10 TB of data and serves 500 users via SMB (Server Message Block) protocol. The company requires:
- Active Directory integration for authentication
- Support for Windows ACLs and NTFS permissions
- Automatic daily backups with 30-day retention
- High availability across multiple AZs

Which storage solution meets ALL requirements?

A) Amazon FSx for Windows File Server with Multi-AZ deployment. FSx for Windows natively supports SMB protocol, integrates with Active Directory (AWS Managed AD or self-managed), preserves Windows ACLs and NTFS permissions, provides automatic daily backups with configurable retention, and Multi-AZ deployment ensures high availability.

B) Amazon EFS with a Windows EC2 instance acting as an SMB gateway. Configure the EC2 instance to authenticate against Active Directory.

C) Amazon S3 with AWS Storage Gateway (File Gateway) configured for SMB access. File Gateway supports Active Directory and maps SMB shares to S3 buckets.

D) Amazon FSx for Lustre with a Windows-compatible driver for high-performance file access.

---

### Question 64
A company has an application that writes 5,000 objects per second to an S3 bucket. Each object is 100 KB. The application uses a key naming pattern of: YYYY/MM/DD/HH/MM/SS/random-uuid.json. The company notices throttling (503 Slow Down errors) during peak write periods.

Which approach resolves the throttling issue?

A) S3 automatically supports at least 3,500 PUT requests per second per prefix. The current key pattern creates unique prefixes per second (YYYY/MM/DD/HH/MM/SS/), distributing requests across many prefixes. However, all writes within a second share one prefix. Adding a hash prefix (e.g., hex-hash/YYYY/...) distributes writes across multiple prefixes, increasing total throughput. S3 can scale to thousands of requests per prefix, so also check if the bucket is new and needs time to scale.

B) Enable S3 Transfer Acceleration to increase the upload speed and avoid throttling.

C) Increase the request rate gradually over 15-30 minutes to allow S3 to scale its underlying partitions. S3 automatically scales but needs time for sudden traffic increases.

D) Switch to multipart uploads for all objects to reduce the number of PUT requests.

---

### Question 65
A company runs a large-scale analytics platform and needs to choose between Amazon Redshift and Amazon Athena for their primary query engine. Their requirements are:
- Query 500 TB of data stored in S3 (Parquet format)
- Run complex queries with joins across 20+ tables
- Execute queries concurrently from 200 users
- Queries run throughout the day (not ad-hoc)
- Sub-second query response for frequently run dashboards

Which service is MOST appropriate and why?

A) Amazon Redshift with RA3 nodes and Redshift Spectrum for S3 data. Redshift provides a persistent compute layer optimized for complex queries and concurrent users. RA3 nodes cache frequently accessed data on local SSDs for sub-second dashboard performance. Redshift Spectrum queries cold data in S3 while joining with local hot data. Workload Management (WLM) manages 200 concurrent users efficiently.

B) Amazon Athena. Athena queries S3 data directly in Parquet format with no infrastructure to manage. However, Athena is better suited for ad-hoc queries and may not provide sub-second response times for complex joins on 500 TB.

C) Amazon Athena with provisioned capacity. Athena's provisioned capacity provides dedicated compute resources for consistent performance.

D) Both Redshift and Athena together — Athena for ad-hoc queries and Redshift for scheduled dashboard queries.

---

## Answer Key

### Answer 1
**Correct Answer: A**

This lifecycle configuration matches the access patterns: Standard-IA for occasional access (30-90 days) costs less than Standard while providing immediate retrieval, Glacier Flexible Retrieval for rare access (90-365 days) is significantly cheaper with retrieval in 3-5 hours, and deletion after 365 days when data is no longer needed.

**Why other options are wrong:**
- **B:** Glacier Deep Archive after 90 days may be too aggressive — retrieval takes 12+ hours, which may not be suitable for data that's "rarely accessed" (implying it IS accessed sometimes).
- **C:** One Zone-IA sacrifices durability (single AZ) for cost savings. For 500 TB of log data, the risk of AZ failure may not be acceptable. Adding Glacier Instant Retrieval at 90 days costs more than Flexible Retrieval when access is rare.
- **D:** Glacier Instant Retrieval is more expensive than Glacier Flexible Retrieval. If data is "rarely accessed" between 90-365 days, Flexible Retrieval's lower storage cost is better.

---

### Answer 2
**Correct Answer: A**

gp3 allows provisioning up to 16,000 IOPS and 1,000 MiB/s throughput independently of volume size. For the majority of the workload (20,000 read IOPS can be partially offset by read replicas), gp3 at 16,000 IOPS is significantly cheaper than io2 at 25,000 IOPS. The RDS read replicas handle read IOPS, reducing the primary instance's IOPS requirement.

**Why other options are wrong:**
- **B:** io2 at 25,000 IOPS is more expensive per IOPS than gp3. It's justified only when IOPS requirements exceed 16,000 on a single volume.
- **C:** Increasing gp2 to 8.34 TB is wasteful — paying for storage you don't need just to get IOPS. gp3 decouples IOPS from storage size.
- **D:** io1 has lower durability (99.8-99.9%) than io2 (99.999%) and similar pricing. Read replicas can help but io1 is still more expensive than gp3 for this IOPS level.

---

### Answer 3
**Correct Answer: A**

Transitioning non-current versions to Glacier after 30 days reduces storage costs for versions between 30-90 days old. NoncurrentVersionExpiration at 90 days permanently deletes versions older than 90 days, freeing the bulk of the 50 TB storage. Current versions remain in Standard for immediate access.

**Why other options are wrong:**
- **B:** Immediately deleting all non-current versions removes rollback capability. CRR doesn't provide the same granular version-level rollback.
- **C:** Disabling versioning doesn't remove existing non-current versions and loses the protection versioning provides for future changes.
- **D:** Transitioning current versions to Deep Archive makes them inaccessible for immediate use, violating the requirement to keep current versions "readily available."

---

### Answer 4
**Correct Answer: A**

io2 volumes support Multi-Attach, allowing attachment to up to 16 Nitro-based instances in the same AZ. This meets the requirement for shared block storage with 4 instances and 10,000 IOPS.

**Why other options are wrong:**
- **B:** gp3 volumes do NOT support Multi-Attach. Only io1 and io2 volume types support Multi-Attach.
- **C:** EFS is a file system (NFS), not block storage. Clustered databases requiring shared block storage (like Oracle RAC) typically need block-level access.
- **D:** RAID 0 with Multi-Attach doesn't make sense — RAID 0 stripes across volumes on a single host. Multi-Attach already provides shared access.

---

### Answer 5
**Correct Answer: A**

FSx for Lustre scratch file systems provide the highest throughput (200 MB/s per TiB of storage provisioned) at the lowest cost. 50 TiB of scratch storage provides 10 GB/s throughput. Scratch doesn't replicate data (lower cost), which is acceptable since data can be regenerated.

**Why other options are wrong:**
- **B:** Persistent Lustre provides data replication within the AZ, adding cost for durability that isn't needed for temporary data.
- **C:** EFS provisioned throughput at 10 GB/s would be extremely expensive ($60,000/month for throughput alone). EFS is not designed for HPC burst throughput.
- **D:** S3 with FUSE-based mounting provides extremely poor POSIX performance with high latency and cannot approach 10 GB/s aggregate throughput.

---

### Answer 6
**Correct Answer: A**

Aurora Auto Scaling uses Application Auto Scaling to automatically adjust the number of Aurora Replicas based on a target tracking policy (e.g., average CPU utilization at 70%). The minimum and maximum capacity settings ensure at least 2 replicas during low demand and up to 15 during peak.

**Why other options are wrong:**
- **B:** Aurora replicas are not managed by EC2 Auto Scaling groups. Aurora has its own auto-scaling mechanism.
- **C:** Aurora Serverless v2 can be used for read replicas, but the question asks about automatically adjusting the number of replicas, which is what Aurora Auto Scaling does.
- **D:** Lambda-based scaling is custom and less reliable than native Aurora Auto Scaling. It also introduces delay and complexity.

---

### Answer 7
**Correct Answer: C**

RAID 0 is the better choice because EBS volumes already provide built-in redundancy (data is replicated within the AZ). RAID 1's additional mirroring at the instance level is redundant with EBS's native durability. RAID 0 maximizes I/O performance by striping across volumes.

**Why other options are wrong:**
- **A:** While technically correct about RAID 0's characteristics, the recommendation is wrong — it says RAID 0 is only suitable for temporary data, ignoring EBS's built-in redundancy.
- **B:** Technically correct about RAID 1's characteristics but the recommendation is wrong for this context — RAID 1 adds unnecessary redundancy on top of EBS's native durability.
- **D:** RAID 1 does NOT double write performance. Write operations must be written to both mirrored volumes. Only read performance can potentially improve.

---

### Answer 8
**Correct Answer: A**

Amazon Athena is serverless and charges $5 per TB scanned. With columnar format (Parquet/ORC) and partitioning, query scans can be reduced by 90%+. For 10 queries/day with efficient partitioning scanning ~1 TB each, the cost is ~$50/day. No infrastructure to manage.

**Why other options are wrong:**
- **B:** A Redshift cluster for 200 TB would require many RA3 nodes at significant cost ($10,000+/month), unjustified for only 10 queries per day.
- **C:** RDS PostgreSQL cannot handle 200 TB (max storage is 64 TB) and is not designed for analytical workloads at this scale.
- **D:** DynamoDB is not designed for SQL queries with large scans. Loading 200 TB into DynamoDB would be extremely expensive.

---

### Answer 9
**Correct Answer: A, B**

Cluster mode enabled (A) distributes 100 GB across multiple shards, allowing horizontal scaling of both memory and throughput. Multi-AZ with automatic failover (B) ensures high availability — if a primary node fails, a replica in another AZ is automatically promoted.

**Why other options are wrong:**
- **C:** A single shard has limited throughput (one primary for writes). 500,000 requests/second may exceed single-shard capacity.
- **D:** Global Datastore provides cross-region replication but doesn't address within-region high availability as directly as Multi-AZ.
- **E:** While Serverless is a valid option, the question asks about specific configurations, and the combination of A+B provides the explicit control needed.

---

### Answer 10
**Correct Answer: A**

Object Lock in Compliance mode prevents anyone — including the root account — from deleting or overwriting objects until the retention period expires. This is the strictest protection mode, meeting the compliance requirement. A lifecycle rule handles automatic deletion after 7 years.

**Why other options are wrong:**
- **B:** Governance mode allows users with special permissions (s3:BypassGovernanceRetention) to override the lock. It does NOT prevent root account deletion.
- **C:** Bucket policies can be modified by the root account, so this doesn't prevent root account deletion. It's also operationally complex.
- **D:** Legal Hold doesn't have an automatic expiration. It must be manually removed, creating operational risk if the Lambda function fails.

---

### Answer 11
**Correct Answer: A, B**

Aurora read replicas (A) share the same storage layer as the primary, providing near-zero replication lag. Directing analytical queries to a dedicated replica isolates the workload from OLTP. Aurora zero-ETL with Redshift (B) automatically replicates data to Redshift without building ETL pipelines, providing a purpose-built analytics engine that's completely isolated from Aurora.

**Why other options are wrong:**
- **C:** Scaling the primary instance doesn't isolate analytical workloads. Complex analytical queries would still contend with OLTP transactions for CPU and memory.
- **D:** Nightly exports create a 24-hour data lag, which may not be acceptable for analytics requiring fresh data.
- **E:** Global Database is designed for DR, not analytics isolation. The cross-region latency adds unnecessary complexity.

---

### Answer 12
**Correct Answer: A**

Elastic throughput mode automatically scales throughput based on demand, and you pay only for what you use. This is ideal for workloads with variable patterns — it handles both the sustained 100 MB/s and the 500 MB/s burst without over-provisioning.

**Why other options are wrong:**
- **B:** Bursting mode with 500 GB provides only 25 MB/s baseline, far below the 100 MB/s sustained requirement. Burst credits cannot sustain 100 MB/s for 10 hours.
- **C:** Provisioning 500 MB/s means paying for that capacity 24/7, including the 14 hours of low/no traffic. This is significantly more expensive than Elastic.
- **D:** Provisioned at 100 MB/s doesn't handle the 500 MB/s burst requirement. Burst credits on top of provisioned throughput may not be sufficient.

---

### Answer 13
**Correct Answer: A, C**

Write-sharding (A) distributes reads for hot items across multiple physical partitions, directly addressing the hot partition issue. DAX (C) caches frequently read items in memory, serving reads at microsecond latency without hitting DynamoDB partitions at all. This is especially effective for celebrity posts that are read repeatedly.

**Why other options are wrong:**
- **B:** Adaptive Capacity is automatically enabled and helps, but it has limits. It cannot fully mitigate extreme hot partition scenarios with millions of simultaneous reads to the same partition.
- **D:** Increasing total RCUs distributes capacity across all partitions but doesn't solve the hot partition problem if one partition key receives disproportionate traffic.
- **E:** A GSI on PostTimestamp doesn't help — celebrity posts would still be hot in the GSI, and the access pattern is by user, not by time.

---

### Answer 14
**Correct Answer: A**

io2 Block Express provides the highest IOPS (up to 256,000), sub-millisecond latency, and 99.999% durability. It's the best upgrade from io1 for consistent high-IOPS workloads that need performance headroom.

**Why other options are wrong:**
- **B:** gp3 is capped at 16,000 IOPS per volume. RAID 0 with two gp3 volumes is not supported with RDS (RDS manages its own storage).
- **C:** io1 Multi-Attach is for EC2, not RDS. RDS doesn't support Multi-Attach configurations. Also, Multi-Attach doesn't increase IOPS; it shares access.
- **D:** gp3 at 16,000 IOPS is only half the required 30,000 IOPS.

---

### Answer 15
**Correct Answer: C**

You CANNOT transition objects from S3 Glacier Flexible Retrieval back to S3 Standard using lifecycle rules. Lifecycle transitions only flow in one direction — from higher-cost to lower-cost tiers (waterfall model). To move data from Glacier back to Standard, you must restore the object and then copy it to a new object in Standard.

**Why other options are wrong:**
- **A:** Standard-IA to One Zone-IA IS an allowed transition.
- **B:** Standard to Intelligent-Tiering IS an allowed transition.
- **D:** Standard to Glacier Deep Archive IS an allowed transition (direct skip is permitted).

---

### Answer 16
**Correct Answer: A**

Dataset A (S3 Intelligent-Tiering) optimizes costs for unpredictable access patterns automatically. Dataset B (Standard-IA) is cost-effective for quarterly access with immediate retrieval when needed. Dataset C (Glacier Flexible Retrieval) suits annual access with acceptable 3-12 hour retrieval. Dataset D (Deep Archive) is the cheapest option for data that is never accessed, with 48-hour retrieval being acceptable.

**Why other options are wrong:**
- **B:** Glacier Instant Retrieval for Dataset B is more expensive than Standard-IA per GB when access is quarterly (not rare enough to justify). Glacier Flexible Retrieval for Dataset D is more expensive than Deep Archive.
- **C:** Glacier Instant Retrieval for quarterly data (B) is more expensive than Standard-IA. The difference from A is Dataset B.
- **D:** Intelligent-Tiering for all datasets would work but has per-object monitoring fees on 5 PB (billions of objects), potentially costing more than targeted storage class assignment.

---

### Answer 17
**Correct Answer: A, B**

RA3 nodes (A) separate compute from storage, use local SSD cache for hot data, and automatically offload cold data to S3. This provides better price-performance for 50 TB compared to dense compute nodes. Distribution style optimization (B) ensures data locality for joins, reducing inter-node data shuffling — a primary cause of slow complex queries.

**Why other options are wrong:**
- **C:** Adding more dc2 nodes increases cost linearly. The fundamental issue may be data distribution, not compute capacity.
- **D:** RDS PostgreSQL is an OLTP database, not a data warehouse. It lacks columnar storage, compression, and MPP architecture needed for analytical queries.
- **E:** Spectrum is useful for extending to S3 but doesn't improve performance of queries on data already in Redshift.

---

### Answer 18
**Correct Answer: A**

DynamoDB supports document data model (JSON), provides single-digit millisecond latency (microsecond with DAX for cached reads), offers strongly consistent reads, scales to millions of requests per second, and supports global tables. DAX adds the sub-millisecond read caching layer.

**Why other options are wrong:**
- **B:** DocumentDB provides strong MongoDB compatibility but doesn't support global tables for multi-region replication, and scaling to millions of requests per second requires significant provisioning.
- **C:** DynamoDB without DAX provides single-digit millisecond latency, not sub-millisecond as required.
- **D:** ElastiCache for Redis is primarily a cache, not a primary database. It lacks the durability, global tables, and serverless scaling of DynamoDB.

---

### Answer 19
**Correct Answer: A**

RDS automated backups with transaction log backup every 5 minutes exceed the 1-hour RPO requirement. Point-in-time recovery to any second within the retention period provides fine-grained recovery. Restore creates a new DB instance, typically completing within 15 minutes for most database sizes (meeting RTO). Snapshot export to S3 handles the analytics requirement.

**Why other options are wrong:**
- **B:** Manual snapshots every hour via Lambda adds operational complexity. Snapshots are point-in-time, so RPO could be up to 1 hour (vs. 5 minutes with automated backups).
- **C:** Disabling Multi-AZ removes automatic failover protection, increasing RTO significantly.
- **D:** Cross-region read replicas are for DR, not for meeting the stated RPO/RTO within a region. Using a replica for analytics is valid but not the primary backup strategy.

---

### Answer 20
**Correct Answer: A**

This is the documented procedure for encrypting an unencrypted Aurora cluster: snapshot → copy with encryption → restore. The copy snapshot operation creates an encrypted copy using the specified KMS key. The restored cluster is fully encrypted.

**Why other options are wrong:**
- **B:** Aurora does NOT support enabling encryption on an existing unencrypted cluster in-place. This operation is not supported.
- **C:** DMS works but is more complex, slower, and requires ongoing replication management compared to the snapshot copy approach.
- **D:** Aurora doesn't use EBS volumes directly. Aurora has its own distributed storage system, and you cannot enable EBS encryption separately on Aurora storage.

---

### Answer 21
**Correct Answer: A**

SSE-KMS with customer managed keys provides: customer-controlled encryption keys per department, automatic annual key rotation (AWS manages key material rotation while maintaining the same key ID), and CloudTrail logging of all KMS API calls for auditing.

**Why other options are wrong:**
- **B:** SSE-S3 uses AWS-managed keys that cannot be separated by department or audited at the key-usage level. Key rotation is managed by AWS without customer control.
- **C:** Client-side encryption adds application complexity and doesn't provide the same audit trail as KMS. Key management in Secrets Manager adds another layer to manage.
- **D:** SSE-C requires the customer to send the encryption key with every request. Key rotation is manual and error-prone. No CloudTrail audit of key usage (only S3 API calls).

---

### Answer 22
**Correct Answer: A**

Amazon Timestream is purpose-built for IoT time-series data. Its dual-store architecture (memory for recent data, magnetic for older data) matches the access pattern perfectly. Automatic data lifecycle management moves data between stores based on retention policies. Exporting to Glacier for long-term compliance is straightforward.

**Why other options are wrong:**
- **B:** DynamoDB with TTL works but requires custom architecture for the data lifecycle. DynamoDB Streams to S3 adds complexity and cost for 8 TB/day throughput.
- **C:** RDS PostgreSQL cannot handle 100,000 writes/second consistently and becomes expensive at this scale.
- **D:** Aurora MySQL has write throughput limitations and doesn't natively support time-series optimizations like automatic data tiering.

---

### Answer 23
**Correct Answer: A**

ProductID as partition key efficiently supports the primary lookup (pattern 1). Three GSIs efficiently support the remaining three access patterns, each with the appropriate partition and sort key combination for the specific query pattern.

**Why other options are wrong:**
- **B:** Category as partition key makes product-by-ID lookups inefficient (would need a GSI or Scan).
- **C:** Scan operations are always inefficient for large tables. Category+Price queries should use a GSI, not filtered scans.
- **D:** Overloaded GSIs add complexity and are harder to optimize for throughput. For SAA-C03 level, straightforward GSIs per access pattern is the recommended approach.

---

### Answer 24
**Correct Answer: A**

AWS SCT handles the complex schema conversion (stored procedures, triggers, functions) from Oracle to PostgreSQL. AWS DMS provides initial full load and ongoing CDC replication, which minimizes downtime — the application cuts over when replication lag is minimal, resulting in near-zero downtime.

**Why other options are wrong:**
- **B:** Data Pump export/import requires significant downtime (hours for 10 TB). Manual stored procedure conversion is error-prone without SCT assistance.
- **C:** Stopping the source database during migration causes extended downtime. Manual procedure rewriting after migration means the application isn't functional until complete.
- **D:** Aurora PostgreSQL cannot be a read replica of an Oracle database. Read replicas require the same database engine.

---

### Answer 25
**Correct Answer: A**

Elastic throughput mode charges only for throughput actually consumed, scaling automatically up to the file system's maximum. Since the workload is 200 MB/s during business hours and minimal at night, Elastic avoids the 24/7 cost of provisioned throughput while meeting the performance requirement.

**Why other options are wrong:**
- **B:** Provisioned at 200 MB/s costs a fixed amount 24/7 ($1,200/month for 200 MB/s), even during off-hours when throughput is minimal.
- **C:** Adding 3.9 TB of dummy data is wasteful and absurd as a production solution. You'd pay for 4 TB of storage you don't need.
- **D:** FSx for Lustre requires application changes (different mount protocol) and is designed for HPC, not general-purpose file serving.

---

### Answer 26
**Correct Answer: A**

PlayerID/GameID as the primary key supports player-specific queries. The GSI on GameID/Score enables efficient leaderboard queries (sorted by score within each game). On-demand capacity handles the variable 50,000 writes/sec peaks. DynamoDB's atomic counters (UpdateItem with ADD) support atomic score updates.

**Why other options are wrong:**
- **B:** GameID/Score as primary key means two players with the same score conflict on the sort key. Also, Score is a dynamic attribute, not ideal as a sort key.
- **C:** Scan operations are expensive and slow for 500 GB tables. Provisioning 50,000 WCUs permanently is wasteful if peak hours are limited.
- **D:** Storing scores as a list in a single item has a 400 KB item size limit, which can't hold millions of player scores for a popular game.

---

### Answer 27
**Correct Answer: A**

Aurora Global Database provides: cross-region replication with typically <1 second lag (RPO), planned failover completes in under 1 minute (RTO), automatic managed failover to the secondary region, and the secondary cluster serves read traffic during normal operations.

**Why other options are wrong:**
- **B:** Cross-region read replicas require manual promotion and lack automatic failover to the secondary region.
- **C:** Snapshot-based recovery has RPO equal to the last snapshot interval and RTO of hours (snapshot restore time).
- **D:** Multi-AZ is within a single region and doesn't provide cross-region DR.

---

### Answer 28
**Correct Answer: A, B**

Adding Standard-IA at 30 days (A) reduces costs for data between 30-60 days. The minimum 30-day duration constraint (B) is satisfied because objects transition to IA at day 30 and to Glacier at day 60, staying in IA for exactly 30 days.

**Why other options are wrong:**
- **C:** Transitioning to Glacier at 30 days means objects between 30-60 days need Expedited retrieval ($10/request), which is expensive for "occasional" access.
- **D:** Intelligent-Tiering could work but has per-object monitoring fees and doesn't provide the explicit cost control of defined lifecycle rules.
- **E:** One Zone-IA has reduced durability (single AZ). For compliance/business data, this risk may not be acceptable.

---

### Answer 29
**Correct Answer: A**

Aurora provides all listed features: ACID transactions, complex SQL with joins, automatic storage scaling to 128 TB, up to 15 read replicas with sub-20ms replication lag (shared storage), and automatic failover with zero data loss (synchronous replication to shared storage).

**Why other options are wrong:**
- **B:** RDS MySQL supports up to 64 TB storage (not 128 TB) and 5 read replicas with potentially higher replication lag (logical replication, not shared storage).
- **C:** DynamoDB doesn't support SQL joins. Its query model is fundamentally different from relational databases.
- **D:** Redshift is a data warehouse, not an OLTP database. It doesn't support automatic failover in the same way as Aurora.

---

### Answer 30
**Correct Answer: A**

S3 Glacier Deep Archive is AWS's lowest-cost storage class at approximately $0.00099/GB/month. For 500 TB, this is ~$500/month. The 12-48 hour retrieval time is acceptable per the requirements.

**Why other options are wrong:**
- **B:** Glacier Flexible Retrieval costs approximately $0.0036/GB/month — about 3.6x more expensive than Deep Archive.
- **C:** Glacier Instant Retrieval costs approximately $0.004/GB/month — about 4x more expensive than Deep Archive. The instant retrieval capability isn't needed.
- **D:** Tape Gateway with VTS backed by Deep Archive has similar storage costs but adds gateway infrastructure costs and complexity.

---

### Answer 31
**Correct Answer: A**

Redis cluster mode enabled distributes data across shards using hash slots, supports complex data structures and operations (sets, sorted sets with SUNION, SINTER), provides sub-millisecond latency, and each shard has replicas for failover resilience.

**Why other options are wrong:**
- **B:** Memcached doesn't support complex data structures (sets, sorted sets) needed for intersection/union operations. It also doesn't support persistence or replication.
- **C:** A single node (even r6g.16xlarge with ~400 GB) may not be sufficient for 500 GB. Also, single-shard architecture limits throughput scalability.
- **D:** Redis Serverless is a valid option but the question asks about specific configuration. The explicit configuration in A is more aligned with the exam format.

---

### Answer 32
**Correct Answer: A**

gp3 decouples IOPS from storage size. You get 3,000 baseline IOPS free and pay only for the additional 7,000 IOPS provisioned. This is cheaper than io1/io2 and doesn't waste storage like inflating gp2 volume size. The provisioned IOPS handles the month-end peak.

**Why other options are wrong:**
- **B:** Increasing gp2 to 3.34 TB means paying for 2.34 TB of unused storage permanently, which is more expensive than gp3's per-IOPS pricing.
- **C:** io1 at 10,000 IOPS is more expensive per IOPS than gp3. io1 is justified only when IOPS requirements exceed gp3's 16,000 IOPS maximum.
- **D:** Read replicas help with read-heavy reporting but don't improve write IOPS on the primary. Reporting often involves writes to temporary tables.

---

### Answer 33
**Correct Answer: A**

DynamoDB Global Tables uses asynchronous replication. Writes in one region are eventually consistent in other regions, typically within 1 second. Strongly consistent reads are only available in the region where the write was performed. Applications must be designed for eventual consistency when reading from a different region.

**Why other options are wrong:**
- **B:** Global Tables does NOT provide strong consistency across regions. Cross-region reads are always eventually consistent.
- **C:** There's no consensus protocol guaranteeing 100ms visibility. Replication is asynchronous with typical latency under 1 second but no hard guarantee.
- **D:** Reads don't fail with an error — they succeed but may return stale data (the order may not appear yet).

---

### Answer 34
**Correct Answer: D**

Both A and C are correct, with C being more complete. FSx for Windows (A) meets all the protocol and AD requirements. Multi-AZ deployment with SSD storage (C) adds high availability and consistent performance, making it the most complete answer.

**Why other options are wrong:**
- **B:** FSx for Lustre is a Linux-based file system designed for HPC workloads. It uses the Lustre protocol, not SMB, and doesn't integrate with Active Directory.
- **C alone is incomplete** without understanding that FSx for Windows is the right service, which A establishes.

---

### Answer 35
**Correct Answer: A**

S3 Storage Class Analysis monitors access patterns at the bucket, prefix, or tag level for 30+ days and recommends when to transition objects to Standard-IA based on access frequency. This directly addresses the need to analyze access patterns for storage class optimization.

**Why other options are wrong:**
- **B:** S3 Storage Lens provides broad metrics and trends but doesn't provide per-object access pattern analysis for storage class transition recommendations.
- **C:** S3 Inventory lists objects and metadata but doesn't analyze access patterns or make recommendations.
- **D:** Macie is for data security and privacy (PII detection), not storage optimization.

---

### Answer 36
**Correct Answer: A**

DynamoDB is purpose-built for key-value access patterns at massive scale. On-demand mode handles the 200,000 writes/sec without capacity planning. For sustained high throughput, provisioned capacity with auto-scaling can be more cost-effective. DynamoDB scales horizontally without upper limits on throughput.

**Why other options are wrong:**
- **B:** Aurora MySQL has write throughput limitations (~100,000 writes/sec max for simple inserts) and is more expensive at this scale for simple key-value access.
- **C:** ElastiCache Redis as a primary database lacks the durability guarantees of DynamoDB and requires manual scaling/sharding.
- **D:** A single RDS instance cannot handle 200,000 writes/sec regardless of instance type or EBS configuration.

---

### Answer 37
**Correct Answer: A**

Aurora cloning creates an isolated, writable copy. Data masking scripts remove PII from the clone. The snapshot of the anonymized clone can be safely shared. This ensures no PII leakage while providing a full database for testing.

**Why other options are wrong:**
- **B:** Sharing production snapshots exposes all data including PII. IAM policies cannot restrict access to specific database columns.
- **C:** Export to S3, transform with Glue, and reimport is complex and time-consuming. It's a valid approach but more operationally heavy than cloning.
- **D:** Cross-account Aurora read replicas don't exist as a feature. Views don't prevent direct table access by a determined user.

---

### Answer 38
**Correct Answer: A**

S3 bucket policies with conditional statements can enforce encryption requirements at the prefix level. Deny conditions on PutObject ensure non-compliant uploads are rejected. The default bucket encryption handles "all other objects" with SSE-S3.

**Why other options are wrong:**
- **B:** Separate buckets add management overhead and require application changes to target the correct bucket.
- **C:** Re-encrypting after upload means data briefly exists with the wrong encryption, violating the "reject non-compliant uploads" requirement.
- **D:** S3 Object Lambda intercepts GET requests, not PUT requests. It cannot enforce encryption on uploads.

---

### Answer 39
**Correct Answer: A**

This provides the optimal storage class for each access pattern: Standard for daily access (Raw, Curated), Standard-IA for weekly access (Processed), Deep Archive for annual access (Archive). Approximate pricing: Standard ~$0.023/GB, Standard-IA ~$0.0125/GB, Deep Archive ~$0.00099/GB. Moving 500 TB from Standard to Deep Archive alone saves ~$10,500/month.

**Why other options are wrong:**
- **B:** Intelligent-Tiering works but adds per-object monitoring fees on potentially billions of objects, and doesn't move to Deep Archive automatically for the archive zone.
- **C:** Standard-IA for Raw (daily access) incurs retrieval fees that may exceed Standard pricing. Glacier Instant for weekly access is more expensive than Standard-IA.
- **D:** One Zone-IA for Raw data risks data loss. One Zone-IA is not appropriate for data that's actively accessed and important.

---

### Answer 40
**Correct Answer: A**

Redshift Spectrum creates external tables pointing to S3 data and queries them using Redshift SQL. It joins S3 data with local Redshift tables seamlessly. Spectrum uses independent compute resources that don't affect the Redshift cluster's performance.

**Why other options are wrong:**
- **B:** Loading 500 TB into temporary tables is impractical — it would take hours and require enormous Redshift storage.
- **C:** Federated queries to Athena work but add an extra hop and complexity. Spectrum is the native, optimized solution for S3 data.
- **D:** Redshift data sharing is for sharing data between Redshift clusters, not for S3 access.

---

### Answer 41
**Correct Answer: A**

FSx for Lustre scratch provides the highest throughput (200 MB/s per TiB), sub-millisecond latency, POSIX compliance, and native S3 data repository integration. For 500 TiB of scratch storage, you get 100 GB/s throughput. Scratch is ideal for temporary HPC data.

**Why other options are wrong:**
- **B:** EFS Max I/O mode provides high throughput but cannot approach 100 GB/s. Provisioned throughput at 100 GB/s would be prohibitively expensive.
- **C:** Persistent Lustre provides unnecessary durability for 24-48 hour temporary data, at higher cost.
- **D:** EBS io2 volumes are per-instance and don't provide a shared file system. RAID 0 doesn't create shared storage.

---

### Answer 42
**Correct Answer: B**

ElastiCache for Redis with cluster mode and TTL provides sub-millisecond latency (vs. DynamoDB's single-digit millisecond), native TTL support with EXPIRE command, Multi-AZ for high availability, and cluster mode distributes 1 million sessions across shards.

While DynamoDB (A) is also a valid answer, Redis provides true sub-millisecond latency which better meets the strict requirement.

**Why other options are wrong:**
- **C:** RDS MySQL is not designed for sub-millisecond session storage. Scheduled deletion is less efficient than native TTL.
- **D:** S3 doesn't provide sub-millisecond latency. Lifecycle rules have a minimum granularity of 1 day, not 30 minutes.

---

### Answer 43
**Correct Answer: A**

Aurora supports instant DDL for operations like adding nullable columns — it modifies only the table metadata and completes in sub-seconds regardless of table size. For index creation, ALGORITHM=INPLACE builds the index without copying the table and allows concurrent read/write operations.

**Why other options are wrong:**
- **B:** Aurora cloning creates a copy, but switching the application to the clone requires DNS/endpoint changes and data synchronization for writes that occurred during the DDL operation.
- **C:** Stopping writes during maintenance causes downtime, violating the "minimize impact" requirement.
- **D:** Promoting a read replica requires DNS changes and there's a replication lag window where data could be lost.

---

### Answer 44
**Correct Answer: A, B, C**

Versioning (A) enables recovery of deleted objects by retaining previous versions. Lifecycle rules (B) automate the retention and deletion policies — non-current versions expire after 30 days, current versions after 365 days. MFA Delete (C) prevents accidental or malicious permanent deletion of versions and bucket deletion.

**Why other options are wrong:**
- **D:** A bucket policy is useful but weaker than MFA Delete — policies can be modified by anyone with policy management permissions.
- **E:** Object Lock Governance mode adds complexity and is unnecessary when versioning + MFA Delete + lifecycle rules cover all requirements.
- **F:** CRR adds cost and complexity without directly addressing the stated requirements.

---

### Answer 45
**Correct Answer: A**

Provisioned capacity with Auto Scaling is most cost-effective for predictable patterns with defined peaks. The sustained daytime traffic (12 hours) benefits from provisioned pricing (cheaper than on-demand per request). Auto Scaling handles the transition between day/night and spikes by adjusting capacity based on utilization targets.

**Why other options are wrong:**
- **B:** On-demand is typically 5-6x more expensive per request than provisioned capacity for sustained, predictable traffic. It's better for truly unpredictable workloads.
- **C:** Provisioning for peak at all times wastes capacity during the 12 nighttime hours.
- **D:** DynamoDB reserved capacity provides further savings but is a separate pricing mechanism, not a capacity mode. The question asks about capacity modes.

---

### Answer 46
**Correct Answer: A, B, C, D**

ElastiCache for Redis (A) provides sub-millisecond key-value access with TTL — ideal for sessions. Aurora PostgreSQL (B) provides relational queries with complex joins for the product catalog. DynamoDB (C) handles high write throughput for order history with simple queries. Redshift (D) is optimized for complex analytical queries at 100 TB scale.

**Why other options are wrong:**
- **E:** DynamoDB provides single-digit millisecond latency, not sub-millisecond as Tier 1 requires.
- **F:** DynamoDB doesn't support SQL joins, which Tier 2 requires.
- **G:** Aurora may struggle with sustained 50,000 writes/sec for Tier 3.
- **H:** RDS PostgreSQL is not optimized for analytical queries at 100 TB scale for Tier 4.

---

### Answer 47
**Correct Answer: A**

S3 Intelligent-Tiering charges a monthly monitoring and automation fee per object. There are no retrieval fees when objects are accessed from any tier (they're automatically moved back to Frequent Access tier). The service automatically manages tier transitions based on access patterns.

**Why other options are wrong:**
- **B:** There IS an additional monitoring fee beyond storage costs. It's small but exists.
- **C:** There are NO retrieval fees in Intelligent-Tiering when objects move back to Frequent Access. This is a key differentiator from Standard-IA.
- **D:** Monitoring fees are per object, not per GB of storage.

---

### Answer 48
**Correct Answer: A**

io2 Block Express supports up to 256,000 IOPS with a 1,000:1 IOPS-to-GB ratio. A 500 GB volume can achieve up to 500,000 IOPS (but capped at 256,000). 100,000 IOPS is well within limits. Requires Nitro-based instances (which is specified in the question).

**Why other options are wrong:**
- **B:** Standard io2 is capped at 64,000 IOPS per volume, which is below the 100,000 IOPS requirement.
- **C:** gp3 is capped at 16,000 IOPS — far below the requirement.
- **D:** io1 is capped at 64,000 IOPS — also below the requirement.

---

### Answer 49
**Correct Answer: A, D**

Objects must be in Standard for a minimum of 30 days before transitioning to Standard-IA (A). Glacier Flexible Retrieval has a minimum storage duration of 90 days (D). Objects transitioned at day 60 are billed for 90 days minimum in Glacier regardless, and the Deep Archive transition at day 180 (120 days after entering Glacier) exceeds the minimum, so no penalty.

**Why other options are wrong:**
- **B:** While correct about the 30-day IA minimum, the Standard-IA minimum is about billing (you're charged for 30 days regardless), not a hard block on transitions.
- **C:** While there's no minimum duration for Standard, the constraint for transitioning TO Standard-IA (minimum 128 KB object size and 30-day minimum before transition) is the relevant constraint.
- **E:** Objects CAN transition directly from Standard-IA to Glacier Deep Archive. They don't need to pass through Glacier Flexible Retrieval first.

---

### Answer 50
**Correct Answer: A**

Multi-AZ with io2 volumes provides: synchronous replication to a standby in a different AZ (zero data loss), automatic failover (60-120 seconds), io2 supports up to 64,000 IOPS (or io2 Block Express for up to 256,000 IOPS), and RDS Multi-AZ provides 99.95% SLA.

**Why other options are wrong:**
- **B:** Read replicas use asynchronous replication and don't provide automatic failover. Manual promotion introduces data loss risk and longer RTO.
- **C:** Single-AZ with backups has RPO equal to the backup interval and RTO of hours (restore from backup).
- **D:** gp3 max IOPS is 16,000, far below the 80,000 IOPS requirement. Read replicas don't add IOPS to the primary.

---

### Answer 51
**Correct Answer: A**

Redis supports: TTL per key (EX for seconds), targeted invalidation (DEL/UNLINK for specific keys), values up to 512 MB, cluster mode with Multi-AZ for high availability and sub-millisecond latency.

**Why other options are wrong:**
- **B:** CloudFront caching is for HTTP responses at edge locations, not arbitrary API response caching at the application level. CloudFront invalidation is path-based, not key-based, and takes time to propagate.
- **C:** Memcached doesn't support replication or persistence. Node failures cause data loss.
- **D:** DAX is tightly coupled to DynamoDB and cannot cache arbitrary API responses. It caches DynamoDB reads specifically.

---

### Answer 52
**Correct Answer: A**

AWS DataSync is purpose-built for data migration to AWS storage services. It preserves file metadata (permissions, timestamps, symlinks, ACLs), provides automated data transfer scheduling, bandwidth throttling, and data validation. Over 1 Gbps, theoretical max is ~10.8 TB/day; 50 TB can transfer in ~5 days.

**Why other options are wrong:**
- **B:** AWS Transfer Family is for SFTP/FTP transfers and doesn't natively support NFS-to-EFS migration or metadata preservation.
- **C:** rsync works but is slower than DataSync (single-threaded vs. multi-threaded), doesn't provide automated scheduling, and requires manual monitoring.
- **D:** Storage Gateway is for hybrid storage access, not bulk migration. It would be slow and isn't designed for one-time data transfer.

---

### Answer 53
**Correct Answer: A**

Aurora cloning uses a copy-on-write protocol — it creates a new cluster that shares the same underlying storage as the original. The clone is available in minutes regardless of database size (even 10 TB). Only modified pages are written to new storage, making it extremely fast and storage-efficient initially.

**Why other options are wrong:**
- **B:** Restoring a 10 TB snapshot takes hours as all data must be copied to new storage.
- **C:** Promoting a read replica removes it from the replication topology and temporarily impacts the primary during the promotion process.
- **D:** DMS full load of 10 TB takes many hours and requires provisioning a replication instance.

---

### Answer 54
**Correct Answer: D**

RCUs: 10,000. For strongly consistent reads, each read of up to 4 KB consumes 1 RCU. 10,000 reads/sec × 1 RCU = 10,000 RCUs. WCUs: 20,000. Each write of up to 1 KB consumes 1 WCU. A 4 KB item requires ⌈4/1⌉ = 4 WCUs per write. 5,000 writes/sec × 4 WCU = 20,000 WCUs.

**Why other options are wrong:**
- **A:** Gets RCUs correct but incorrectly states WCUs as 5,000 (miscalculates write units).
- **B:** Strongly consistent reads of 4 KB consume 1 RCU (not 0.5). 0.5 RCU per 4 KB applies to eventually consistent reads.
- **C:** Strongly consistent reads of 4 KB consume 1 RCU (not 2). 2 RCUs would be for 8 KB reads. WCU calculation of 1 per 4 KB write is wrong.

---

### Answer 55
**Correct Answer: A**

Aurora MySQL is wire-compatible with MySQL, requiring minimal to no application changes. Aurora's distributed storage architecture provides up to 5x throughput improvement over standard MySQL, auto-scales to 128 TB, and handles the 16 TB dataset efficiently.

**Why other options are wrong:**
- **B:** Migrating to DynamoDB requires rewriting all SQL queries and application logic — maximum application changes.
- **C:** Vertical scaling provides limited improvement and is more expensive. It doesn't address the fundamental storage architecture limitations of standard MySQL.
- **D:** Redshift is optimized for OLAP (analytical queries), not OLTP. Migrating an OLTP application to Redshift would require significant application changes and wouldn't handle transactional workloads well.

---

### Answer 56
**Correct Answer: A**

Amazon Neptune is a purpose-built graph database that excels at relationship traversal queries (friends-of-friends), pathfinding (shortest path), and pattern matching (mutual friends). Graph databases are fundamentally more efficient at these operations than relational or NoSQL databases.

**Why other options are wrong:**
- **B:** DynamoDB adjacency lists can model graphs but traversal queries (especially multi-hop) require multiple round trips and become expensive and complex.
- **C:** Recursive CTEs in PostgreSQL work for graph queries but become extremely slow for multi-hop traversals on large graphs (10 million nodes).
- **D:** OpenSearch is a search engine, not a graph database. Nested documents don't efficiently represent graph relationships.

---

### Answer 57
**Correct Answer: A, B, C**

KMS encryption at rest (A) covers storage, backups, snapshots, and replicas. Forced SSL/TLS (B) encrypts data in transit between the application and database. pgcrypto column-level encryption (C) protects specific sensitive values even from DBAs who have database access but not the encryption keys.

**Why other options are wrong:**
- **D:** CloudHSM for RDS encryption is possible but adds significant complexity and cost. Standard KMS meets most requirements.
- **E:** TDE is available for Oracle and SQL Server on RDS, not PostgreSQL.
- **F:** RDS does NOT encrypt in transit by default. SSL/TLS must be explicitly configured and enforced.

---

### Answer 58
**Correct Answer: A**

Aurora Serverless v2 scales between configured minimum and maximum ACU values in 0.5 ACU increments. It charges per ACU-second consumed. Scaling is rapid (seconds), handling the variable workload patterns efficiently.

**Why other options are wrong:**
- **B:** Aurora Serverless v2 does NOT scale to zero. The minimum is 0.5 ACU. Only Aurora Serverless v1 could scale to zero (but v1 had a cold start delay).
- **C:** Serverless v2 scales within seconds, not minutes. It's designed for rapid scaling.
- **D:** Serverless v2 supports up to 128 ACUs maximum, well above the 100 ACU requirement.

---

### Answer 59
**Correct Answer: A, B, C**

Kinesis Data Firehose (A) natively delivers streaming data to Redshift with configurable buffering. COPY from S3 (B) is Redshift's most efficient bulk loading mechanism, and splitting files matches cluster parallelism. Federated Query (C) eliminates the need to extract and load RDS data — Redshift queries it directly.

**Why other options are wrong:**
- **D:** DMS to Redshift works but Firehose is the native, simpler integration for Kinesis to Redshift.
- **E:** Row-by-row INSERT is extremely slow for 50 GB files. COPY is orders of magnitude faster.
- **F:** pg_restore doesn't work with Redshift — Redshift is not PostgreSQL, despite sharing SQL syntax.

---

### Answer 60
**Correct Answer: A**

S3 Storage Lens provides a comprehensive dashboard with 60+ metrics covering storage usage, cost, data protection, access patterns, and activity. It works across all buckets in an account (or entire Organization) and provides free and paid tiers with advanced metrics and recommendations.

**Why other options are wrong:**
- **B:** S3 Inventory + QuickSight requires custom setup for visualization and doesn't provide built-in recommendations.
- **C:** Cost Explorer shows cost data but not data protection metrics, access patterns, or storage optimization recommendations.
- **D:** Server access logs with Athena provides access pattern data but not storage metrics, cost analysis, or data protection metrics.

---

### Answer 61
**Correct Answer: A**

A GSI with a computed date attribute as the partition key and OrderDate as sort key allows efficient cross-partition queries for a specific date range. Using YYYY-MM (or similar bucketing) as the partition key distributes queries across partitions while enabling range queries on OrderDate.

**Why other options are wrong:**
- **B:** Scan operations read the entire 500 GB table and filter results — extremely expensive and slow.
- **C:** Query operations work only within a single partition key value. You can't query across all CustomerIDs in the base table.
- **D:** LSIs share the base table's partition key (CustomerID). They allow alternate sort keys within a partition but can't query across all customers.

---

### Answer 62
**Correct Answer: A, B**

PITR (A) provides continuous backups with second-level granularity for the last 35 days. AWS Backup (B) provides scheduled backups with retention policies, cross-region copy capabilities, and centralized backup management — covering long-term retention and cross-region DR.

**Why other options are wrong:**
- **C:** DynamoDB Streams to Lambda to S3 is custom and complex, adding operational overhead for backup management.
- **D:** Manual on-demand backups via Lambda lack the cross-region copy and retention policy management that AWS Backup provides natively.
- **E:** DynamoDB Export to S3 is for analytics (full table export in Parquet/CSV), not for backup and restore purposes.

---

### Answer 63
**Correct Answer: A**

FSx for Windows File Server Multi-AZ provides: native SMB support, Active Directory integration (AWS Managed AD or self-managed), Windows ACLs and NTFS permissions, automatic daily backups with configurable retention (up to 90 days), and Multi-AZ for high availability with automatic failover.

**Why other options are wrong:**
- **B:** EFS uses NFS protocol, not SMB. Adding a Windows gateway EC2 instance increases complexity and introduces a single point of failure.
- **C:** File Gateway with SMB supports AD but stores data in S3, which changes the storage model. It doesn't provide the same NTFS permission fidelity as FSx for Windows.
- **D:** FSx for Lustre is a Linux file system using the Lustre protocol. It doesn't support SMB or Active Directory.

---

### Answer 64
**Correct Answer: C**

S3 automatically partitions bucket key prefixes to handle high request rates but needs time to scale for sudden traffic increases. Gradually increasing the request rate gives S3 time to add partitions. S3 supports 3,500 PUT and 5,500 GET requests per second per prefix, and it automatically scales to handle higher rates, but sudden spikes above baseline may cause temporary throttling.

**Why other options are wrong:**
- **A:** While adding a hash prefix can help distribute requests, S3's current architecture can handle 3,500+ PUTs per prefix automatically. The key naming pattern already uses unique per-second prefixes.
- **B:** Transfer Acceleration improves upload speed from distant locations but doesn't address S3 partition throttling.
- **D:** Multipart uploads are for large objects (>100 MB recommended). At 100 KB per object, multipart upload is inappropriate and wouldn't reduce request count.

---

### Answer 65
**Correct Answer: A**

Redshift with RA3 nodes provides: persistent compute optimized for complex multi-table joins, local SSD cache for sub-second dashboard queries, Spectrum for seamless S3 data access, and Workload Management (WLM) for handling 200 concurrent users. For sustained, complex analytical workloads with high concurrency and sub-second requirements, Redshift is the better choice.

**Why other options are wrong:**
- **B:** Athena is serverless and great for ad-hoc queries but struggles with sub-second response on complex joins across 500 TB. High concurrency (200 users) can lead to query queuing.
- **C:** Athena provisioned capacity improves consistency but still lacks the local caching and query optimization of Redshift for repeated complex queries.
- **D:** While using both is architecturally valid, the question asks for the MOST appropriate single choice for the described workload.

---

## Summary

| Question | Answer | Domain |
|----------|--------|--------|
| 1 | A | Cost-Optimized Architecture |
| 2 | A | High-Performing Technology |
| 3 | A | Cost-Optimized Architecture |
| 4 | A | High-Performing Technology |
| 5 | A | Cost-Optimized Architecture |
| 6 | A | Resilient Architecture |
| 7 | C | High-Performing Technology |
| 8 | A | Cost-Optimized Architecture |
| 9 | A, B | Resilient Architecture |
| 10 | A | Security |
| 11 | A, B | High-Performing Technology |
| 12 | A | Cost-Optimized Architecture |
| 13 | A, C | High-Performing Technology |
| 14 | A | High-Performing Technology |
| 15 | C | High-Performing Technology |
| 16 | A | Cost-Optimized Architecture |
| 17 | A, B | High-Performing Technology |
| 18 | A | High-Performing Technology |
| 19 | A | Resilient Architecture |
| 20 | A | Security |
| 21 | A | Security |
| 22 | A | High-Performing Technology |
| 23 | A | High-Performing Technology |
| 24 | A | Resilient Architecture |
| 25 | A | Cost-Optimized Architecture |
| 26 | A | High-Performing Technology |
| 27 | A | Resilient Architecture |
| 28 | A, B | Cost-Optimized Architecture |
| 29 | A | Resilient Architecture |
| 30 | A | Cost-Optimized Architecture |
| 31 | A | High-Performing Technology |
| 32 | A | Cost-Optimized Architecture |
| 33 | A | Resilient Architecture |
| 34 | D | Security |
| 35 | A | Cost-Optimized Architecture |
| 36 | A | High-Performing Technology |
| 37 | A | Security |
| 38 | A | Security |
| 39 | A | Cost-Optimized Architecture |
| 40 | A | High-Performing Technology |
| 41 | A | High-Performing Technology |
| 42 | B | High-Performing Technology |
| 43 | A | Resilient Architecture |
| 44 | A, B, C | Security |
| 45 | A | Cost-Optimized Architecture |
| 46 | A, B, C, D | High-Performing Technology |
| 47 | A | Security |
| 48 | A | High-Performing Technology |
| 49 | A, D | Security |
| 50 | A | Resilient Architecture |
| 51 | A | Resilient Architecture |
| 52 | A | Resilient Architecture |
| 53 | A | Resilient Architecture |
| 54 | D | High-Performing Technology |
| 55 | A | Resilient Architecture |
| 56 | A | High-Performing Technology |
| 57 | A, B, C | Security |
| 58 | A | Cost-Optimized Architecture |
| 59 | A, B, C | High-Performing Technology |
| 60 | A | Security |
| 61 | A | High-Performing Technology |
| 62 | A, B | Resilient Architecture |
| 63 | A | Resilient Architecture |
| 64 | C | High-Performing Technology |
| 65 | A | High-Performing Technology |
