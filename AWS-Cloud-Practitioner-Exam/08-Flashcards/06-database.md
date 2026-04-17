# Flashcards — Domain 3 (Databases)

Q: RDS engines?
A: MySQL, PostgreSQL, MariaDB, Oracle, SQL Server, IBM Db2, Amazon Aurora (MySQL/PG). #must-know

Q: What is Multi-AZ RDS (instance deployment)?
A: Synchronous standby replica in a second AZ for HA failover. #must-know

Q: Multi-AZ cluster deployment (RDS)?
A: 1 writer + 2 readable standbys across 3 AZs (MySQL/PG). #must-know

Q: Read replicas in RDS?
A: Async replicas for read scaling (up to 5); can be same- or cross-Region. #must-know

Q: RDS PITR retention?
A: Up to 35 days. #must-know

Q: RDS automated backups retention?
A: 0–35 days (0 disables; not recommended). #must-know

Q: RDS Proxy purpose?
A: Connection pooling; especially helpful with Lambda. #must-know

Q: What is RDS Custom?
A: RDS variant for Oracle/SQL Server where customer has OS/DB admin access. #must-know

Q: What is Aurora?
A: Cloud-native DB engine, MySQL- or PG-compatible, storage auto-expands, 6 copies across 3 AZs. #must-know

Q: Aurora MySQL performance vs stock MySQL?
A: Up to 5×. #must-know

Q: Aurora PostgreSQL performance vs stock PG?
A: Up to 3×. #must-know

Q: Max Aurora storage?
A: 128 TB (MySQL) / 256 TB (recent PG). #must-know

Q: Aurora replicas max?
A: 15. #must-know

Q: Aurora Serverless v2?
A: Fine-grained autoscaling measured in ACUs (Aurora Capacity Units). #must-know

Q: Aurora Global Database?
A: 1 primary + up to 5 secondary Regions, < 1 sec cross-Region replication lag. #must-know

Q: DynamoDB type?
A: Fully managed NoSQL KV + document. #must-know

Q: DynamoDB capacity modes?
A: On-Demand (pay per request) and Provisioned (RCU/WCU, optional auto-scaling). #must-know

Q: DynamoDB max item size?
A: 400 KB. #must-know

Q: What's DAX?
A: DynamoDB Accelerator — in-memory cache for DDB, µs reads. #must-know

Q: DynamoDB Global Tables?
A: Multi-Region multi-active replication. #must-know

Q: DynamoDB Streams retention?
A: 24 hours. #must-know

Q: DynamoDB PITR retention?
A: 35 days. #must-know

Q: DynamoDB TTL?
A: Auto-delete expired items by a timestamp attribute. #must-know

Q: ElastiCache engines?
A: Redis, Memcached (and new Valkey). #must-know

Q: MemoryDB differs from ElastiCache Redis how?
A: MemoryDB is durable (multi-AZ transaction log) — can be a primary DB. #must-know

Q: Which DB for graph?
A: Neptune. #must-know

Q: Which for MongoDB API?
A: DocumentDB. #must-know

Q: Which for Cassandra API?
A: Keyspaces. #must-know

Q: Which for time-series (IoT / metrics)?
A: Timestream. #must-know

Q: Ledger DB with cryptographic journal?
A: QLDB (being phased out; know the concept). #must-know

Q: Serverless PB-scale data warehouse?
A: Redshift Serverless. #must-know

Q: Query S3 with SQL serverlessly?
A: Athena. #must-know

Q: Redshift Spectrum purpose?
A: Query S3 data from a Redshift cluster. #must-know

Q: DMS purpose?
A: Online DB migrations with minimal downtime (homogeneous + heterogeneous). #must-know

Q: SCT purpose?
A: Convert schema + code for heterogeneous migrations. #must-know

Q: Aurora I/O-Optimized?
A: Pricing mode with predictable costs for I/O-heavy workloads. #must-know

Q: When to choose DynamoDB over RDS?
A: Need serverless, massive scale, flexible schema, very low latency; don't need joins/complex SQL. #must-know

Q: When to choose Aurora over RDS MySQL?
A: Need higher performance, better HA (6 copies/3 AZs), global active-active (Aurora Global DB), or scale. #must-know

Q: When is Aurora Serverless a fit?
A: Variable or unpredictable load, or dev/test where you don't want instances running 24/7. #must-know

Q: Minimum ACU for Aurora Serverless v2?
A: 0.5 (can pause to 0 on newer features). #must-know

Q: RDS free-tier engine / class?
A: db.t2/t3.micro 750 hours/month (one engine at a time). #must-know

Q: Max RDS storage for a single instance?
A: 64 TiB (engine-dependent; Aurora uses different storage model up to 128 TB). #must-know

Q: In-memory cache typical latencies?
A: Sub-millisecond. #must-know
