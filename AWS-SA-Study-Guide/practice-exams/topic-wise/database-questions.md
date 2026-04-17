# Database Question Bank

**AWS Solutions Architect Associate (SAA-C03) — Topic-Wise Practice**
**Total Questions: 30**

---

### Question 1
A company runs a web application with an RDS MySQL database. The application experiences heavy read traffic during business hours. The primary instance CPU is at 85%. Write operations are minimal. What should the architect recommend to reduce the load on the primary instance?

A) Upgrade to a larger RDS instance type
B) Create one or more RDS Read Replicas and direct read traffic to them
C) Enable RDS Multi-AZ deployment
D) Migrate to DynamoDB

**Answer: B**
**Explanation:** RDS Read Replicas offload read traffic from the primary instance. The application can direct reads to replicas, reducing CPU load on the primary. Scaling up (A) is more expensive and has limits. Multi-AZ (C) is for high availability and doesn't serve read traffic (the standby is not directly accessible). Migrating to DynamoDB (D) requires significant application changes.

---

### Question 2
A company's RDS instance hosts a critical production database. They need to ensure automatic failover with minimal data loss in case of an AZ failure. What should the architect configure?

A) RDS Read Replica in another AZ with manual promotion
B) RDS Multi-AZ deployment
C) RDS automated backups with cross-region copy
D) RDS snapshot every hour

**Answer: B**
**Explanation:** RDS Multi-AZ creates a synchronous standby replica in a different AZ. Failover is automatic (typically 60-120 seconds) with minimal data loss. Read Replicas (A) use asynchronous replication and require manual promotion. Automated backups (C) and snapshots (D) help with recovery but don't provide automatic failover.

---

### Question 3
A company is designing a globally distributed application that requires single-digit millisecond reads and writes with automatic multi-region replication. What database should the architect recommend?

A) RDS MySQL with cross-region Read Replicas
B) Amazon Aurora Global Database
C) DynamoDB Global Tables
D) Amazon ElastiCache Global Datastore

**Answer: C**
**Explanation:** DynamoDB Global Tables provide multi-region, multi-active replication with single-digit millisecond performance for both reads and writes in each region. Aurora Global Database (B) provides fast reads globally but writes must go to the primary region. RDS Read Replicas (A) are read-only and have higher replication lag. ElastiCache (D) is a cache, not a primary database.

---

### Question 4
A company has a DynamoDB table with provisioned capacity. The table receives 10,000 strongly consistent reads per second, each reading items of 4 KB. How many Read Capacity Units (RCU) are needed?

A) 5,000 RCU
B) 10,000 RCU
C) 20,000 RCU
D) 40,000 RCU

**Answer: B**
**Explanation:** For strongly consistent reads: 1 RCU = 1 read/second for items up to 4 KB. Each read is exactly 4 KB, so each needs 1 RCU. 10,000 reads/second × 1 RCU = 10,000 RCU. If these were eventually consistent reads, the answer would be 5,000 RCU (each RCU supports 2 eventually consistent reads per second).

---

### Question 5
A company needs 5,000 writes per second to a DynamoDB table. Each item is 2.5 KB. How many Write Capacity Units (WCU) are needed?

A) 5,000 WCU
B) 10,000 WCU
C) 15,000 WCU
D) 2,500 WCU

**Answer: C**
**Explanation:** For writes: 1 WCU = 1 write/second for items up to 1 KB. Each 2.5 KB item rounds up to 3 KB, requiring 3 WCU per write. 5,000 writes/second × 3 WCU = 15,000 WCU. Write capacity is always calculated based on 1 KB units, rounded up.

---

### Question 6
A company runs an e-commerce platform and needs a database that can handle highly variable traffic — from 100 requests/second during off-peak to 10,000 requests/second during flash sales. They want to minimize costs and management overhead. What should the architect recommend?

A) DynamoDB with provisioned capacity and Auto Scaling
B) DynamoDB with on-demand capacity mode
C) RDS Aurora with Auto Scaling Read Replicas
D) ElastiCache in front of RDS

**Answer: B**
**Explanation:** DynamoDB on-demand capacity automatically scales to handle any level of traffic without capacity planning. You pay per request. For highly variable traffic with peaks 100x the baseline, on-demand mode is ideal. Provisioned with Auto Scaling (A) has limits on how fast it can scale and may not handle sudden spikes. Aurora (C) and ElastiCache (D) add complexity.

---

### Question 7
A company needs a relational database that is MySQL-compatible, provides up to 5x better performance than standard MySQL, and offers automatic storage scaling. What should the architect recommend?

A) RDS MySQL with Provisioned IOPS
B) Amazon Aurora MySQL
C) MySQL on EC2 with EBS Auto Scaling
D) Amazon Redshift

**Answer: B**
**Explanation:** Amazon Aurora is MySQL and PostgreSQL compatible, delivers up to 5x MySQL performance and 3x PostgreSQL performance, and automatically scales storage from 10 GB to 128 TB. RDS MySQL (A) uses standard MySQL. MySQL on EC2 (C) requires manual management. Redshift (D) is a data warehouse, not an OLTP database.

---

### Question 8
A company needs to cache frequently accessed database query results to reduce latency and database load. The cache must support complex data structures and automatic failover. What should the architect recommend?

A) ElastiCache for Memcached
B) ElastiCache for Redis with cluster mode
C) DynamoDB Accelerator (DAX)
D) CloudFront caching

**Answer: B**
**Explanation:** ElastiCache for Redis supports complex data structures (sorted sets, lists, hashes), persistence, and automatic failover with Multi-AZ. Cluster mode adds sharding for scalability. Memcached (A) is simpler but doesn't support complex data types or automatic failover. DAX (C) is specifically for DynamoDB, not general database caching. CloudFront (D) is a CDN, not a database cache.

---

### Question 9
A company runs DynamoDB for their application. They need to capture a real-time stream of all changes (inserts, updates, deletes) to items in the table and process them for analytics. What should the architect enable?

A) DynamoDB Auto Scaling
B) DynamoDB Streams with a Lambda function consumer
C) DynamoDB Global Tables
D) DynamoDB Accelerator (DAX)

**Answer: B**
**Explanation:** DynamoDB Streams captures a time-ordered sequence of item-level changes (insert, modify, delete) in a DynamoDB table. Lambda can process the stream in near real-time. Auto Scaling (A) manages capacity. Global Tables (C) provide multi-region replication. DAX (D) is an in-memory cache.

---

### Question 10
A company runs a PostgreSQL database on-premises and wants to migrate to AWS with minimal downtime. The database is 2 TB and serves live traffic. What should the architect recommend?

A) Use `pg_dump`/`pg_restore` during a maintenance window
B) Use AWS Database Migration Service (DMS) with continuous replication (CDC)
C) Manually export the data to CSV and import into RDS
D) Use AWS Snowball to transfer the database

**Answer: B**
**Explanation:** AWS DMS supports continuous replication (Change Data Capture) which migrates the initial data and then continuously replicates ongoing changes. This enables near-zero downtime migration. `pg_dump` (A) requires downtime during the dump and restore. CSV export (C) is manual and slow. Snowball (D) is for data transfer, not live database migration.

---

### Question 11
A company runs Aurora MySQL and needs to handle a sudden read spike during a product launch. They need read capacity to scale automatically. What feature should the architect use?

A) Aurora Auto Scaling for Read Replicas
B) Aurora Serverless v2
C) Manual addition of Read Replicas
D) Both A and B are valid approaches

**Answer: D**
**Explanation:** Aurora Auto Scaling automatically adds or removes Read Replicas based on CloudWatch metrics (like CPU utilization or connections). Aurora Serverless v2 automatically scales the compute capacity of the database itself, including read capacity. Both are valid approaches depending on the architecture. Manual scaling (C) is not automatic and doesn't respond to sudden spikes.

---

### Question 12
A company needs a data warehouse solution that can analyze petabytes of structured data using standard SQL. They currently use multiple data sources including S3, RDS, and DynamoDB. What should the architect recommend?

A) Amazon Athena
B) Amazon Redshift
C) Amazon RDS with larger instances
D) Amazon EMR with Hive

**Answer: B**
**Explanation:** Amazon Redshift is a fully managed data warehouse designed for OLAP queries on petabyte-scale structured data. It integrates with multiple data sources through Redshift Spectrum (for S3) and federated queries (for RDS and other sources). Athena (A) is serverless SQL on S3 but not optimized for complex data warehouse queries. RDS (C) is not a data warehouse. EMR (D) is more complex to manage.

---

### Question 13
A company has an application that needs to perform complex graph queries to identify relationships between users, products, and transactions for fraud detection. What database should the architect recommend?

A) Amazon DynamoDB
B) Amazon Neptune
C) Amazon RDS MySQL
D) Amazon DocumentDB

**Answer: B**
**Explanation:** Amazon Neptune is a fully managed graph database that supports both property graph (Gremlin) and RDF (SPARQL) models. It's ideal for relationship-heavy queries like fraud detection, social networking, and recommendation engines. DynamoDB (A) is key-value/document. RDS (C) is relational. DocumentDB (D) is document-oriented (MongoDB-compatible).

---

### Question 14
A company is using ElastiCache for Redis to cache session data for their web application. They need the cache to survive an AZ failure without data loss. What should the architect configure?

A) ElastiCache Redis with cluster mode enabled
B) ElastiCache Redis with Multi-AZ and automatic failover enabled
C) ElastiCache Memcached with multiple nodes across AZs
D) Redis backups to S3 every 5 minutes

**Answer: B**
**Explanation:** ElastiCache Redis with Multi-AZ and automatic failover replicates data synchronously to a standby in another AZ. If the primary fails, it automatically promotes the replica. Cluster mode (A) adds sharding but doesn't alone ensure AZ failover. Memcached (C) doesn't support replication or persistence. Redis backups (D) provide RPO of 5 minutes, not zero data loss.

---

### Question 15
A company needs to store and query JSON documents with flexible schemas. Their existing application uses MongoDB. They want a fully managed, AWS-native service that is API-compatible with MongoDB. What should the architect recommend?

A) Amazon DynamoDB
B) Amazon DocumentDB
C) Amazon RDS for PostgreSQL with JSONB
D) Amazon Neptune

**Answer: B**
**Explanation:** Amazon DocumentDB is MongoDB-compatible (supports MongoDB 3.6, 4.0, and 5.0 APIs) and is fully managed. It's designed for storing, querying, and indexing JSON documents. DynamoDB (A) is key-value/document but not MongoDB-compatible. RDS PostgreSQL with JSONB (C) works but isn't purpose-built for document workloads. Neptune (D) is a graph database.

---

### Question 16
A company has an Aurora MySQL database with a primary instance and two read replicas. The primary instance fails. What happens?

A) The application experiences downtime until a new primary is manually promoted
B) Aurora automatically promotes one of the read replicas to become the new primary
C) Aurora creates a new primary instance from the last backup
D) Both read replicas become writable

**Answer: B**
**Explanation:** Aurora automatically promotes a read replica to become the new primary, typically within 30 seconds. The replica with the highest priority (lowest tier number) is promoted first. No manual intervention is needed. Aurora doesn't create from backup (C) when replicas exist. Only one replica is promoted (D).

---

### Question 17
A company needs to perform ad-hoc SQL queries on data stored in S3 without loading it into a database. The queries are infrequent (a few times per month). What is the MOST cost-effective solution?

A) Load data into Amazon Redshift and query it
B) Use Amazon Athena to query data directly in S3
C) Load data into RDS and run queries
D) Use Amazon EMR with Presto

**Answer: B**
**Explanation:** Amazon Athena is a serverless query service that analyzes data directly in S3 using standard SQL. You pay only per query (per TB of data scanned). For infrequent queries, this is the most cost-effective as there's no infrastructure to maintain. Redshift (A) and RDS (C) require provisioned resources. EMR (D) has cluster costs.

---

### Question 18
A company is building a real-time leaderboard for their mobile game. The leaderboard requires sub-millisecond read latency and needs to support sorted rankings that update frequently. What combination should the architect recommend?

A) RDS MySQL with indexed queries
B) DynamoDB for game data with ElastiCache Redis Sorted Sets for the leaderboard
C) Amazon S3 with Athena for querying
D) Amazon Neptune for ranking relationships

**Answer: B**
**Explanation:** Redis Sorted Sets natively support leaderboard operations (add score, get rank, get top-N) with sub-millisecond latency. DynamoDB stores the game data. This is a classic architecture for real-time leaderboards. RDS (A) has higher latency for sorted queries at scale. S3/Athena (C) is not real-time. Neptune (D) is for graph relationships, not sorted rankings.

---

### Question 19
A company runs an RDS Oracle database with a license included. They are paying high licensing costs and want to reduce them. The application uses Oracle-specific features like PL/SQL. What migration path should the architect evaluate?

A) Migrate directly to Aurora PostgreSQL
B) Use AWS Schema Conversion Tool (SCT) to assess and convert the Oracle schema to Aurora PostgreSQL, then use DMS for data migration
C) Re-platform to DynamoDB
D) Move to RDS Oracle Bring Your Own License (BYOL)

**Answer: B**
**Explanation:** AWS SCT evaluates the Oracle schema and PL/SQL code, identifies conversion issues, and converts what it can to PostgreSQL. DMS then migrates the data. This heterogeneous migration reduces licensing costs. Direct migration (A) without SCT would miss conversion issues. DynamoDB (C) is a fundamentally different database type. BYOL (D) may reduce costs if they already have licenses but doesn't eliminate Oracle licensing.

---

### Question 20
A company has a DynamoDB table with a partition key of `UserID`. They notice that a small number of users (power users) generate significantly more traffic, causing hot partitions. What should the architect recommend?

A) Increase the provisioned capacity significantly
B) Add a random suffix to the partition key to distribute traffic more evenly
C) Switch to on-demand capacity mode
D) Use a sort key to spread the data

**Answer: B**
**Explanation:** Adding a random suffix (write sharding) distributes writes for hot partition keys across multiple physical partitions. For example, `UserID#1`, `UserID#2`, etc. Increasing capacity (A) doesn't solve the hot partition problem — the capacity is distributed across partitions but the hot partition still gets the same share. On-demand (C) adapts to total throughput but still has per-partition limits. Sort keys (D) don't affect partition distribution.

---

### Question 21
A company wants to create an Aurora PostgreSQL database that can handle a sudden increase from 0 to thousands of connections without manual intervention. The workload is unpredictable with long idle periods. What should the architect recommend?

A) Aurora Provisioned with a large instance
B) Aurora Serverless v2
C) Aurora Provisioned with Auto Scaling Read Replicas
D) RDS PostgreSQL with Multi-AZ

**Answer: B**
**Explanation:** Aurora Serverless v2 automatically scales compute capacity based on demand, scaling to zero (pause) during idle periods and scaling up to handle thousands of connections. It's ideal for unpredictable workloads. Provisioned (A) incurs costs during idle periods. Auto Scaling replicas (C) take time to add. RDS Multi-AZ (D) is for high availability, not scaling.

---

### Question 22
A company needs to migrate a 10 TB on-premises SQL Server database to AWS. They want to continue using SQL Server features. Downtime must be less than 30 minutes. What is the BEST migration strategy?

A) Backup and restore to RDS SQL Server
B) Use DMS with CDC for continuous replication to RDS SQL Server, then cut over
C) Use native SQL Server Always On to replicate to RDS
D) Export to CSV and import into Aurora

**Answer: B**
**Explanation:** DMS with Change Data Capture (CDC) performs a full initial load and then continuously replicates changes. During cutover, you stop the source, let DMS catch up (usually seconds), and switch the application. This achieves minimal downtime. Backup and restore (A) requires extended downtime for 10 TB. Native Always On (C) is not supported with RDS. CSV export (D) is impractical at 10 TB.

---

### Question 23
An application writes 1,000 items per second to DynamoDB. Each item is 400 bytes. The table uses on-demand capacity mode. After switching to provisioned capacity for cost savings, what WCU should be provisioned?

A) 400 WCU
B) 1,000 WCU
C) 1,400 WCU
D) 500 WCU

**Answer: B**
**Explanation:** Each WCU provides 1 write per second for items up to 1 KB. Each 400-byte item rounds up to 1 KB, requiring 1 WCU per write. 1,000 writes/second × 1 WCU = 1,000 WCU. The item size (400 bytes) is less than 1 KB, so it still consumes only 1 WCU per write.

---

### Question 24
A company has an Aurora MySQL database used for both OLTP transactions and complex analytical reports. The analytical queries are degrading OLTP performance. What should the architect recommend?

A) Increase the Aurora instance size
B) Use Aurora parallel query for analytical workloads
C) Create Aurora Read Replicas dedicated to analytics with a custom endpoint
D) Migrate analytical workloads to Redshift

**Answer: C**
**Explanation:** Creating dedicated Read Replicas for analytical queries with a custom reader endpoint isolates the workload from OLTP operations on the primary. Aurora parallel query (B) improves analytical performance but still uses the same cluster resources. Increasing instance size (A) is expensive and doesn't isolate workloads. Redshift (D) is ideal for analytics but requires data movement.

---

### Question 25
A company needs to implement a caching strategy for their RDS database. They want to cache database queries that are read-heavy. The cache should automatically invalidate when the underlying data changes. What pattern should the architect implement?

A) Write-through cache with ElastiCache
B) Lazy loading (cache-aside) with ElastiCache and TTL
C) Write-behind cache with ElastiCache
D) Read-through cache with no invalidation

**Answer: B**
**Explanation:** Lazy loading (cache-aside) loads data into the cache on cache miss and sets a TTL for eventual consistency. This is the most common pattern for read-heavy workloads with RDS. Write-through (A) updates cache on every write, which is more consistent but slows writes. Write-behind (C) writes to cache first and asynchronously to the database, risking data loss. No invalidation (D) serves stale data.

---

### Question 26
A company has a DynamoDB table used for an IoT application. They need to automatically delete items that are older than 24 hours to control costs. What should the architect use?

A) DynamoDB Streams with Lambda to delete old items
B) DynamoDB Time to Live (TTL) on a timestamp attribute
C) A scheduled Lambda function to scan and delete old items
D) DynamoDB Auto Scaling to manage item count

**Answer: B**
**Explanation:** DynamoDB TTL automatically deletes expired items based on a timestamp attribute, at no additional cost (no WCU consumed). Items are typically deleted within 48 hours of expiration. Streams with Lambda (A) is unnecessary complexity. Scheduled scans (C) consume RCU/WCU and are expensive. Auto Scaling (D) manages capacity, not item deletion.

---

### Question 27
A company runs a multi-region active-active application. They need their relational database to support writes in multiple regions with conflict resolution. What should the architect recommend?

A) RDS MySQL with cross-region Read Replicas (promote on failover)
B) Aurora Global Database with write forwarding
C) DynamoDB Global Tables
D) Aurora MySQL with bidirectional replication using external tools

**Answer: C**
**Explanation:** DynamoDB Global Tables provide multi-region, multi-active replication where writes can occur in any region with last-writer-wins conflict resolution. Aurora Global Database (B) supports write forwarding but all writes still go to the primary region. RDS Read Replicas (A) are read-only in secondary regions. Custom bidirectional replication (D) is complex and error-prone.

---

### Question 28
A company is evaluating whether to use RDS or Aurora for their PostgreSQL workload. The database handles 50,000 read operations per second and must survive the loss of two copies of data without affecting reads. What should they choose?

A) RDS PostgreSQL with Multi-AZ
B) Amazon Aurora PostgreSQL
C) RDS PostgreSQL with Read Replicas
D) PostgreSQL on EC2 with custom replication

**Answer: B**
**Explanation:** Aurora stores 6 copies of data across 3 AZs. It can survive the loss of 2 copies without affecting reads (and 3 copies without affecting writes). Aurora also supports up to 15 Read Replicas for handling 50,000 reads/second. RDS Multi-AZ (A) has only 2 copies and the standby isn't readable. RDS Read Replicas (C) don't provide the same storage durability. EC2 (D) requires manual management.

---

### Question 29
A company has a DynamoDB table and wants to create a secondary index that uses a different partition key and sort key from the base table. They need the index to be maintained asynchronously. What type of index should they create?

A) Local Secondary Index (LSI)
B) Global Secondary Index (GSI)
C) Both LSI and GSI work equally
D) DynamoDB doesn't support secondary indexes with different partition keys

**Answer: B**
**Explanation:** Global Secondary Indexes (GSI) can have a different partition key and sort key from the base table and are maintained asynchronously (eventually consistent). Local Secondary Indexes (LSI) share the same partition key as the base table and can only have a different sort key. LSIs must be created at table creation time. GSIs can be added anytime.

---

### Question 30
A company needs to run Redshift queries on data stored in S3 without loading it into Redshift tables. They want to join this S3 data with data already in their Redshift cluster. What feature should they use?

A) COPY command to load S3 data first
B) Redshift Spectrum
C) Redshift Federated Query
D) S3 Select

**Answer: B**
**Explanation:** Redshift Spectrum allows querying data directly in S3 using external tables, without loading it into Redshift. You can join external S3 data with local Redshift tables in the same query. COPY (A) loads data into Redshift. Federated Query (C) queries operational databases like RDS and Aurora, not S3. S3 Select (D) filters within individual S3 objects, not for joining with Redshift data.

---

*End of Database Question Bank*
