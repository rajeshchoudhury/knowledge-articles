# Practice Exam 34 - AWS Solutions Architect Associate (SAA-C03) - VERY HARD

## Data Analytics & Data Lake Deep Dive

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
DataLake Solutions Inc. is building an enterprise data lake. Raw data arrives in an S3 bucket in JSON format from 50 application sources. The data engineering team needs to automatically discover schemas, register them in a central metadata catalog, and make the data queryable via SQL without provisioning any servers. The schema discovery must run daily and handle schema changes across sources. Which architecture provides the MOST automated and lowest-maintenance solution?

A) Configure AWS Glue Crawlers to run on a daily schedule against the S3 raw data bucket, automatically populating the AWS Glue Data Catalog with table definitions and schema versions. Use Amazon Athena with the Glue Data Catalog as the metastore to run SQL queries directly against S3 data  
B) Write custom Python scripts on EC2 instances that read S3 files, infer schemas, and store them in a MySQL database. Use Presto on EMR to query the data  
C) Use Amazon Redshift COPY command to load all JSON data into Redshift tables, and query directly from Redshift  
D) Create AWS Lambda functions triggered by S3 events that parse each file and register schemas in a custom DynamoDB table, then use Athena with a custom connector to query  

---

### Question 2
A financial analytics company has a data lake in S3 with 200 TB of data spanning 5 business units. The compliance team mandates: (1) Analysts in the Trading unit can only see columns related to trade execution (not PII columns like SSN and account holder name), (2) The Risk unit can see all columns but only rows where risk_rating = 'HIGH', (3) Data Scientists can access all data but only in a sanitized format with PII columns hashed. Which service provides this level of fine-grained access control with the LEAST operational effort?

A) AWS Lake Formation with fine-grained access control — configure column-level permissions to exclude PII for Trading, row-level security filters for Risk, and cell-level security with data masking policies for Data Scientists. Register the S3 data locations with Lake Formation and manage all permissions centrally  
B) Create separate S3 buckets for each business unit with filtered/transformed copies of the data and manage access via S3 bucket policies  
C) Use Amazon Athena views with row-level filtering and create separate IAM roles for each unit  
D) Deploy Apache Ranger on an EMR cluster for fine-grained access control and integrate with the Glue Data Catalog  

---

### Question 3
A ride-sharing company ingests 500,000 GPS events per second from driver apps. Events must be enriched with geofence data, aggregated into 1-minute windows for surge pricing calculations, and the results must be available to the pricing API within 30 seconds of the window closing. The enrichment requires looking up a 10 GB geofence dataset. Which real-time processing architecture meets the latency requirement? **(Select TWO)**

A) Ingest GPS events into Amazon Kinesis Data Streams with sufficient shards to handle 500K events/second, then process with Amazon Managed Service for Apache Flink application that performs windowed aggregations and enriches events using a Flink side input loaded from S3 containing the geofence data  
B) Write the Flink application output (surge pricing results) to Amazon DynamoDB, which the pricing API queries directly with single-digit millisecond latency  
C) Use Amazon SQS to ingest events and process with Lambda functions that perform 1-minute aggregations  
D) Ingest into Kinesis Data Firehose directly and use Firehose's built-in data transformation to perform windowed aggregations  
E) Store enriched events in Amazon Redshift and have the pricing API query Redshift  

---

### Question 4
A healthcare analytics platform stores 5 years of patient records in S3 (500 TB) in Apache Parquet format, partitioned by year/month/hospital_id. The analytics team runs Athena queries against this data. They report that queries filtering by date range and hospital are fast, but queries filtering by diagnosis_code (a column inside the Parquet files) across all hospitals scan excessive amounts of data and cost thousands of dollars per query. Which optimization reduces query cost MOST significantly for diagnosis_code filtering?

A) Add diagnosis_code as a partition key by repartitioning the data using AWS Glue ETL jobs into a year/month/hospital_id/diagnosis_code partition scheme, then update the Glue Data Catalog to reflect the new partition structure  
B) Create a secondary index on the S3 objects using S3 Object Lambda  
C) Migrate all data from S3 to Amazon Redshift for better query performance  
D) Increase Athena workgroup DPU count for faster scanning  

---

### Question 5
A media company has an Amazon Redshift cluster with 10 TB of structured data. They also have 200 TB of semi-structured clickstream data in S3 in Parquet format. The BI team needs to run queries that join the Redshift warehouse tables with the S3 clickstream data without loading the clickstream data into Redshift. The queries must use standard SQL. Which approach enables this with the LEAST data movement?

A) Create Redshift Spectrum external tables pointing to the S3 clickstream data, registered in the AWS Glue Data Catalog, and write SQL queries in Redshift that join local Redshift tables with the Spectrum external tables  
B) Load all 200 TB of clickstream data into Redshift using the COPY command  
C) Export Redshift data to S3 and use Athena to query both datasets  
D) Use AWS Glue ETL to transform and load the clickstream data into Redshift nightly  

---

### Question 6
An e-commerce company processes order events using the following pipeline: producers → message broker → consumers → analytics. The team is evaluating Amazon MSK (Managed Streaming for Apache Kafka) vs. Amazon Kinesis Data Streams. Requirements: (1) Existing producers use the Apache Kafka client library, (2) Messages must be retained for 30 days for replay, (3) Average throughput is 100 MB/s with bursts to 500 MB/s, (4) The team wants minimal operational overhead. Which option BEST meets ALL requirements and why?

A) Amazon MSK because existing Kafka clients work without code changes, MSK supports up to indefinite retention (tiered storage), handles 500 MB/s burst with broker scaling, and is fully managed. MSK Serverless can further reduce operational overhead for variable throughput  
B) Amazon Kinesis Data Streams because it supports 365-day retention, the KPL/KCL can replace Kafka clients with minor changes, and on-demand mode handles throughput bursts  
C) Amazon Kinesis Data Streams because it is more cost-effective than MSK for all workloads  
D) Self-managed Kafka on EC2 for maximum compatibility with existing Kafka clients  

---

### Question 7
A company needs to query data from their transactional Amazon RDS PostgreSQL database and DynamoDB table alongside data in their S3 data lake, all from a single Athena query. The RDS database contains real-time customer profiles, DynamoDB has session data, and S3 has historical clickstream data. They cannot replicate the data into a single location due to freshness requirements. Which Athena feature enables this?

A) Athena Federated Query using pre-built Lambda connectors — deploy the Amazon Athena CloudFormation connector for PostgreSQL (querying RDS) and the DynamoDB connector, register them as data sources in Athena, and write SQL queries that join across all three data sources (S3 via Glue Catalog, RDS via PostgreSQL connector, DynamoDB via DynamoDB connector)  
B) Create materialized views in Athena that combine data from all three sources  
C) Use Athena CTAS (Create Table As Select) to materialize all data into S3 first, then query  
D) Configure VPC peering between Athena and RDS, then use standard JDBC connections in Athena queries  

---

### Question 8
A data engineering team operates an ETL pipeline using AWS Glue. The pipeline processes daily incremental files from S3 (5 GB/day). The Glue job currently reprocesses ALL historical data each run (now 2 TB total), causing escalating costs and processing times. Only new files since the last run need processing. Which Glue feature solves this without requiring custom tracking logic?

A) Enable AWS Glue job bookmarks, which automatically track which data has been processed in previous job runs by maintaining a state checkpoint. On each subsequent run, the job only processes files that are new or modified since the last bookmark, skipping previously processed data  
B) Use AWS Glue workflow triggers to schedule jobs only when new files arrive  
C) Configure S3 event notifications to trigger Lambda that records new file paths in DynamoDB, then read the DynamoDB table in the Glue job  
D) Partition the data by date and hardcode the date filter in the Glue job to process only today's partition  

---

### Question 9
A logistics company uses Amazon OpenSearch Service for log analytics. Their cluster indexes 2 TB of logs daily from 500 microservices. Logs must be searchable for 30 days, retained in cold storage for 1 year, and automatically deleted after 1 year. The operations team reports that the cluster is running out of storage and search performance is degrading as the index grows. Which combination of features optimizes both storage and performance? **(Select TWO)**

A) Configure OpenSearch Index State Management (ISM) policies to automatically transition indexes from hot nodes (gp3 EBS) to warm nodes (UltraWarm) after 7 days, then to cold storage after 30 days, and delete indexes after 1 year  
B) Enable OpenSearch UltraWarm for cost-effective storage of older indexes with on-demand access, and use cold storage backed by S3 for indexes beyond 30 days  
C) Increase the number of hot data nodes to accommodate the full year of data  
D) Use OpenSearch cross-cluster replication to distribute data across multiple clusters  
E) Compress all logs before indexing to reduce storage by 50%  

---

### Question 10
A financial services firm processes stock market tick data. The pipeline receives 1 million events/second, each event is 200 bytes. Events must be processed for real-time anomaly detection using windowed computations (tumbling and sliding windows), with anomaly alerts generated within 10 seconds. The team has Apache Flink expertise. Which architecture provides the LOWEST latency anomaly detection?

A) Ingest data into Amazon Kinesis Data Streams (with 200+ shards for the throughput), process with Amazon Managed Service for Apache Flink using tumbling and sliding window operators for anomaly detection, and publish alerts to Amazon SNS for immediate notification  
B) Ingest into Amazon Kinesis Data Firehose, buffer for 60 seconds, deliver to S3, and process with a Glue Spark Streaming job  
C) Ingest into Amazon SQS and process with a fleet of EC2 instances running custom anomaly detection code  
D) Ingest into Amazon MSK and process with Amazon EMR Spark Structured Streaming  

---

### Question 11
A retail company uses Amazon QuickSight for business intelligence. The data sources include: (1) A 5 TB Athena table in S3 with daily sales data, (2) A 500 GB Redshift cluster with inventory data, (3) An RDS MySQL database with supplier information. Dashboards must refresh every 15 minutes during business hours. Some dashboards are accessed by 500 concurrent users. Which QuickSight configuration optimizes both performance and cost? **(Select TWO)**

A) Import the Athena and Redshift data sources into QuickSight SPICE (Super-fast, Parallel, In-memory Calculation Engine) for sub-second dashboard performance, and schedule SPICE dataset refreshes every 15 minutes during business hours  
B) Configure QuickSight to use direct query mode for all data sources to always show real-time data  
C) Use QuickSight Q (natural language querying) to generate dashboards automatically instead of building them manually  
D) Configure the RDS MySQL data source for direct query mode (not SPICE) since supplier data changes infrequently, and use SPICE only for the frequently accessed sales and inventory datasets  
E) Deploy a separate QuickSight account for each department to isolate workloads  

---

### Question 12
A genomics research company stores raw sequencing files in S3 Glacier Deep Archive (500 TB). Researchers occasionally need to extract a small subset of data (specific gene sequences) from these archived files. Each file is 50 GB, but the relevant data is typically only 500 KB within each file. Restoring entire files is too expensive and slow. Which approach provides the MOST targeted data retrieval from archived objects?

A) Use S3 Glacier Select (formerly Glacier Select) to run SQL expressions directly against archived objects, extracting only the rows/columns matching the gene sequence criteria without restoring the entire object  
B) Restore all requested files from Glacier Deep Archive using bulk retrieval, process locally, and re-archive  
C) Migrate all data from Glacier Deep Archive to S3 Standard for faster access  
D) Use S3 Select on the archived objects (S3 Select works on all storage classes)  

---

### Question 13
A social media company exports their DynamoDB user activity table (100 GB, 500 million items) to S3 daily for analytics. The export must not impact production read/write performance. The exported data needs to be queryable in Athena in Parquet format. Currently, they use a Scan operation that throttles production traffic. Which approach exports data with ZERO impact on production performance?

A) Use the DynamoDB Export to S3 feature, which exports table data to S3 using point-in-time recovery (PITR) snapshots without consuming any read capacity from the table. Then use an AWS Glue ETL job to convert the exported DynamoDB JSON format to Parquet for Athena queries  
B) Create a DynamoDB Streams consumer Lambda function that writes all changes to S3 incrementally  
C) Use AWS Data Pipeline with a DynamoDB export activity that performs a full table scan during off-peak hours  
D) Enable DynamoDB on-demand capacity mode and perform a parallel Scan operation with a high segment count  

---

### Question 14
A company runs Apache Spark workloads for data transformation. The workloads run 6 hours daily, processing 10 TB of data. The team is evaluating three options: (1) Amazon EMR on EC2, (2) Amazon EMR on EKS, (3) AWS Glue. The workloads require custom Spark libraries, access to HDFS for intermediate shuffle data, and fine-grained control over Spark executor memory configuration. Cost optimization is the top priority. Which option is MOST suitable and why?

A) Amazon EMR on EC2 with a transient cluster (launched for each job and terminated after) using Spot Instances for task nodes and On-Demand for the master node. EMR provides HDFS on instance storage, full control over Spark configuration, and supports custom libraries via bootstrap actions. The transient pattern with Spot saves costs  
B) AWS Glue because it is serverless and requires no infrastructure management, automatically scaling workers  
C) Amazon EMR on EKS because it shares Kubernetes infrastructure with other workloads, reducing cluster sprawl  
D) Amazon EMR on EC2 with a persistent cluster running 24/7 to avoid cluster startup time  

---

### Question 15
An advertising technology company processes click events from 10,000 publisher websites. Events arrive via an HTTPS endpoint at 200,000 events/second. Each event is 1 KB. The events must be: (1) delivered to S3 in Parquet format within 5 minutes, (2) available for real-time counting in a dashboard, (3) enriched with publisher metadata from a DynamoDB table before storage. Which architecture handles ALL requirements? **(Select TWO)**

A) Use Amazon Kinesis Data Streams as the ingestion layer (200+ shards for throughput), with a Lambda consumer that enriches each event by looking up publisher metadata in DynamoDB and writes enriched events back to another Kinesis stream  
B) Connect Amazon Kinesis Data Firehose to the enrichment stream, configure Firehose to batch events and convert to Parquet format using the Glue Data Catalog table schema, with a 60-second buffer interval and delivery to S3  
C) Use API Gateway with Lambda to ingest events and write directly to S3  
D) Use Amazon SQS as the ingestion layer with Lambda consumers for enrichment  
E) Ingest events directly into Amazon Redshift Streaming Ingestion for real-time dashboard access  

---

### Question 16
A telecommunications company is building a data mesh architecture across 5 business units, each operating in their own AWS account. Each unit has their own data lake in S3 with Glue Data Catalog tables. The central data governance team needs to enable cross-account data sharing where: (1) Unit A can query Unit B's data without copying it, (2) Fine-grained permissions are enforced centrally, (3) A central audit trail tracks all data access. Which architecture implements a data mesh with centralized governance? **(Select TWO)**

A) Use AWS Lake Formation cross-account sharing to grant fine-grained permissions (table, column, row-level) from the producer account's Glue Data Catalog to the consumer account, with Lake Formation as the central governance layer  
B) Create resource links in the consumer account's Glue Data Catalog that point to the shared tables in the producer account, allowing Athena in the consumer account to query the producer's data in-place without copying  
C) Copy data between accounts using AWS DataSync and manage permissions with S3 bucket policies  
D) Set up cross-account IAM roles in each producer account and have consumers assume those roles to access data  
E) Create a single centralized AWS account with all data and have all business units query from there  

---

### Question 17
An IoT platform ingests sensor data from 50,000 industrial machines via AWS IoT Core. Each machine publishes a reading every second (50,000 messages/second). The data must be stored in a time-series database for real-time dashboards showing the last 24 hours of data, and in S3 for long-term historical analysis. Dashboard queries must return within 2 seconds. Which pipeline architecture is MOST efficient? **(Select TWO)**

A) Configure an IoT Core rule that routes messages to Amazon Kinesis Data Streams, then have a Lambda consumer write data to Amazon Timestream, which is optimized for time-series queries and provides sub-second query latency for recent data  
B) Configure a second IoT Core rule (or use Kinesis Data Firehose attached to the same Kinesis Data Stream) to deliver data to S3 in batched Parquet files for long-term storage  
C) Write all data directly from IoT Core to Amazon RDS PostgreSQL with TimescaleDB extension  
D) Store all data in DynamoDB with TTL for 24-hour expiration and S3 for historical  
E) Use Amazon OpenSearch Service for both real-time dashboards and long-term storage  

---

### Question 18
A data lake has 100 TB of data in S3 in CSV format across 10 million small files (average 10 KB each). Athena queries are extremely slow and expensive. The data team needs to optimize the data lake for query performance. Which sequence of transformations provides the GREATEST improvement in query performance? **(Select TWO)**

A) Use AWS Glue ETL jobs with the groupFiles/groupSize option to compact the 10 million small files into optimally-sized files (128 MB - 512 MB), dramatically reducing the S3 API overhead that dominates query time  
B) Convert the compacted CSV files to Apache Parquet format with Snappy compression using Glue ETL, enabling columnar reads (Athena only scans needed columns) and reducing data volume by 75-90% compared to CSV  
C) Enable S3 Intelligent-Tiering on all files to optimize storage costs  
D) Create an Athena workgroup with additional DPU allocation for faster processing  
E) Enable S3 Transfer Acceleration on the data lake bucket  

---

### Question 19
A sports betting company receives real-time odds updates from 20 data providers via different protocols (WebSocket, REST API, FTP). Updates arrive at 50,000 events/second during peak (live games). The company needs to: (1) Normalize all feeds into a standard format, (2) Detect anomalous odds movements within 5 seconds, (3) Store normalized data for 7 days of replayability, (4) Feed downstream consumers (mobile app backend, risk engine, reporting). Which architecture handles the heterogeneous ingestion and real-time processing requirements?

A) Deploy protocol-specific adapters (Lambda for REST, EC2 WebSocket clients, Transfer Family for FTP) that normalize events and publish to Amazon Kinesis Data Streams (7-day retention). Process with Amazon Managed Service for Apache Flink for anomaly detection using sliding windows, and enable Kinesis enhanced fan-out for multiple downstream consumers  
B) Use Amazon API Gateway to accept all protocols, forward to SQS, and process with Lambda  
C) Ingest all feeds into Amazon MSK and process with Kafka Streams on ECS containers  
D) Write all feeds directly to S3 and process with Athena on a 5-second schedule  

---

### Question 20
A company has an Amazon Redshift cluster with 20 TB of data. Nightly ETL jobs load 500 GB of new data via the COPY command from S3. After loading, the cluster performance degrades significantly for 2-3 hours due to data distribution key skew and stale statistics. Which post-load maintenance operations should be performed to restore optimal query performance? **(Select TWO)**

A) Run the VACUUM command to reclaim disk space from deleted rows and re-sort data according to the sort key definition, which restores the efficiency of zone map-based scan elimination  
B) Run the ANALYZE command to update table statistics so the Redshift query planner can generate optimal execution plans using current data distribution  
C) Resize the cluster by adding more nodes after each data load  
D) Run the UNLOAD command to export and reimport all data  
E) Drop and recreate all tables with fresh data loads  

---

### Question 21
A pharmaceutical company has genomic sequencing data in S3 (Parquet format, 50 TB). Researchers run complex analytics queries using Athena. Some queries join 10+ tables and process 5 TB+ of data per query. These complex queries frequently timeout or fail with "Query exhausted resources" errors. Standard Athena query execution cannot handle the workload. Which solution handles these complex, resource-intensive queries?

A) Use Amazon Athena provisioned capacity to allocate dedicated compute resources (DPUs) to a workgroup, providing consistent performance for resource-intensive queries that exceed the default Athena limits  
B) Migrate all data from S3 to Amazon Redshift for complex analytical queries  
C) Split each complex query into smaller queries and join results in the application layer  
D) Use Amazon EMR with Presto for direct S3 queries with more memory resources  

---

### Question 22
A streaming video platform generates 1 TB of viewing event data daily. The data must be analyzed for content recommendations. The current pipeline uses: S3 → Glue ETL → Redshift. The Glue ETL job takes 4 hours to process due to complex transformations (sessionization, content affinity scoring, collaborative filtering). The team wants to reduce processing time to under 1 hour while maintaining the Spark-based transformations. Which optimization strategy is MOST effective?

A) Tune the AWS Glue job by switching to G.2X worker type (with more memory per worker), increasing the number of workers with auto-scaling enabled, enabling Glue 4.0 (Spark 3.3) for improved performance, and partitioning the output data by date/content_category to optimize downstream Redshift queries  
B) Replace Glue with Amazon Kinesis Data Firehose for real-time transformation  
C) Rewrite all Spark transformations as SQL queries in Redshift and process the data after loading  
D) Use AWS Lambda Step Functions to parallelize the transformations across multiple Lambda invocations  

---

### Question 23
A company operates a centralized logging platform. Logs arrive from 1,000 EC2 instances via CloudWatch Logs (100 GB/day). The security team needs to search across all logs with sub-second latency for incident investigation. Logs must be retained for 90 days in the searchable system and 7 years in archive. The current CloudWatch Logs Insights queries take 30-60 seconds. Which architecture provides sub-second search performance?

A) Stream CloudWatch Logs to Amazon OpenSearch Service via a subscription filter, use OpenSearch for sub-second full-text search across all logs for the 90-day window, and configure OpenSearch Index State Management to delete indexes after 90 days. Separately, stream logs to S3 via Kinesis Data Firehose for 7-year archival with S3 Glacier Lifecycle policies  
B) Increase CloudWatch Logs Insights query performance by using more specific log group filters  
C) Export CloudWatch Logs to S3 daily and use Athena for search  
D) Deploy a self-managed Elasticsearch cluster on EC2 for better performance  

---

### Question 24
A retail company uses AWS Glue for ETL processing. Their Glue job reads from an RDS MySQL source, transforms the data, and writes to S3 in Parquet format. The job processes 100 GB of data but fails after 2 hours with an OutOfMemoryError. The current configuration uses 10 G.1X workers. What is the MOST likely cause and the BEST solution?

A) The job is trying to load the entire 100 GB dataset into memory at once. Solution: switch to G.2X worker type (which has 2x memory per worker), enable Glue job bookmarks for incremental processing, and use pushdown predicates to filter data at the source (JDBC) level rather than loading everything and filtering in Spark  
B) The Glue service has a hard limit of 100 GB. Solution: split the job into multiple smaller jobs  
C) The RDS MySQL instance is too small. Solution: upgrade the RDS instance type  
D) Parquet format requires more memory than CSV. Solution: output in CSV format instead  

---

### Question 25
A gaming company collects player telemetry data from mobile games. The data arrives in Amazon Kinesis Data Streams at 100,000 events/second. Three independent consumer applications need to process the same stream: (1) Real-time leaderboard updater, (2) Anti-cheat detection engine, (3) Analytics aggregator that writes to S3. Consumer 2 (anti-cheat) requires the lowest possible latency. Currently, all three consumers share the standard 2 MB/s per-shard read throughput, causing high iterator age for consumer 2. Which solution provides dedicated throughput for the anti-cheat consumer?

A) Enable Kinesis Enhanced Fan-Out for the anti-cheat consumer, which provides a dedicated 2 MB/s per-shard throughput via HTTP/2 push-based delivery (SubscribeToShard API), independent of the other consumers who continue using the shared GetRecords API. This eliminates read contention  
B) Create three separate Kinesis Data Streams and use Lambda to fan-out events from the primary stream to all three  
C) Increase the number of shards to provide more aggregate read throughput  
D) Migrate all consumers to use Amazon MSK, which provides higher per-partition throughput  

---

### Question 26
A data engineering team manages an ETL pipeline that processes data from 50 different source systems. Each source has a different schema, delivery schedule, and data quality profile. They need: (1) Central tracking of all data pipeline dependencies, (2) Automatic retry of failed jobs, (3) Visual monitoring of pipeline status, (4) Ability to trigger downstream jobs only when all upstream dependencies are met. Which service provides orchestration of complex multi-step Glue-based ETL workflows?

A) Use AWS Glue Workflows to define the DAG (directed acyclic graph) of crawlers, jobs, and triggers. Configure conditional triggers that start downstream jobs only when specified upstream jobs complete successfully. Use the Glue Workflow console for visual monitoring and configure automatic retry counts on each job within the workflow  
B) Use Amazon MWAA (Managed Workflows for Apache Airflow) for full DAG orchestration with dependency management, retry logic, and visual monitoring  
C) Use AWS Step Functions to orchestrate Glue jobs with error handling and retry logic  
D) Write custom cron jobs on EC2 that check job completion status and trigger downstream jobs  

---

### Question 27
A company has 500 TB of historical data in S3 in JSON format. They want to migrate to Parquet for better query performance and cost savings with Athena. The conversion must complete within 1 week, be cost-optimized, and the converted data must be validated for completeness (same record count as source). Which approach is MOST efficient?

A) Use AWS Glue ETL jobs with auto-scaling workers (G.2X worker type), processing data in parallel by partitioning across multiple concurrent job runs. Enable the Glue job metrics to monitor DPU utilization. After conversion, run a validation Glue job that compares record counts between source JSON and target Parquet by querying both through the Glue Data Catalog with Athena  
B) Launch an EMR cluster with 100 nodes running 24/7 for the week and run a Spark conversion job  
C) Use Lambda functions triggered by S3 events to convert each file individually  
D) Use Athena CTAS (Create Table As Select) to create Parquet tables from the JSON source  

---

### Question 28
A financial services company runs Amazon Redshift with 50 concurrent users. Some users run simple dashboard queries (< 5 seconds), while others run complex analytical queries (30+ minutes) that consume cluster resources and slow down dashboard queries. The company needs to guarantee sub-5-second response for dashboard queries regardless of what analytical queries are running. Which Redshift feature addresses this?

A) Configure Redshift Workload Management (WLM) with automatic WLM enabled, creating separate queue configurations: a high-priority queue for dashboard queries with minimum concurrency and query priority set to HIGH, and a lower-priority queue for analytical queries with priority set to LOW. Automatic WLM dynamically allocates memory and concurrency based on workload  
B) Create two separate Redshift clusters — one for dashboards and one for analytics  
C) Use Redshift concurrency scaling to automatically add cluster capacity during peak periods, handling the overflow of analytical queries on temporary clusters  
D) Increase the cluster size to handle both workloads simultaneously  

---

### Question 29
A company uses Amazon Athena to query a 10 TB dataset partitioned by date (daily partitions for 3 years = 1,095 partitions). Adding a new day's partition requires running the MSCK REPAIR TABLE command, which takes 30+ minutes because it scans all partitions. What is the MOST efficient way to add new daily partitions?

A) Use the ALTER TABLE ADD PARTITION command to add only the new day's partition to the Glue Data Catalog, which takes seconds because it only registers the single new partition without scanning existing ones. Alternatively, use partition projection in Athena table properties to eliminate the need for partition management entirely  
B) Run MSCK REPAIR TABLE more frequently to keep partition discovery up to date  
C) Drop and recreate the table daily with all partitions  
D) Use a Glue Crawler to detect the new partition and update the Data Catalog  

---

### Question 30
A SaaS company stores multi-tenant analytics data in S3, organized as s3://data-lake/{tenant_id}/year={yyyy}/month={mm}/data.parquet. They use Athena for tenant-facing analytics dashboards. Each tenant can only query their own data. There are 10,000 tenants. Creating individual IAM policies for each tenant is impractical. Which approach provides scalable per-tenant data isolation in Athena?

A) Use AWS Lake Formation tag-based access control (LF-TBAC) — assign LF-Tags to data based on tenant_id, and map each tenant's IAM role to the appropriate LF-Tag permissions. Lake Formation enforces the tenant boundary transparently when Athena queries execute, regardless of the S3 path structure  
B) Create S3 bucket policies with conditions for each tenant's IAM role  
C) Use Athena named queries with hardcoded WHERE clauses for each tenant  
D) Create separate Glue databases per tenant with separate Athena workgroups  

---

### Question 31
A logistics company tracks package deliveries in real time. They need a dashboard showing: (1) Packages currently in transit (real-time count), (2) Average delivery time over the last 7 days (near real-time), (3) Year-over-year delivery trends (batch). The dashboard must update every 10 seconds for metric 1, every 5 minutes for metric 2, and daily for metric 3. Which architecture uses the MOST appropriate data store for each metric?

A) Use Amazon ElastiCache Redis for the real-time in-transit count (updated via Kinesis/Lambda), Amazon Timestream for the 7-day rolling average (ingested from Kinesis with automatic time-based aggregations), and Amazon Athena querying S3 for yearly trend analysis (with results cached in QuickSight SPICE)  
B) Use DynamoDB for all three metrics with different TTL configurations  
C) Use Amazon Redshift for all three metrics, relying on materialized views for the real-time count  
D) Use CloudWatch custom metrics for all three metrics at different resolutions  

---

### Question 32
An e-commerce company has a Kinesis Data Stream with 100 shards processing order events. They need to aggregate order totals per customer per hour and write the results to DynamoDB. A Lambda consumer processes the stream but experiences the following issues: (1) Some aggregations are duplicated, (2) Some events are processed out of order within the same customer, (3) Lambda throttling occurs during peak hours. Which combination of changes fixes ALL issues? **(Select TWO)**

A) Enable Lambda event source mapping with enhanced fan-out for dedicated throughput, configure the event source mapping with bisect-on-error and maximum retry settings, and increase the batch size for more efficient processing  
B) Implement idempotent writes using DynamoDB conditional expressions (e.g., attribute_not_exists or version checking) to prevent duplicate aggregations, and use the Kinesis sequence number as a deduplication key  
C) Increase the number of Kinesis shards from 100 to 500  
D) Use SQS between Kinesis and Lambda to buffer events  
E) Replace Lambda with EC2 instances running the KCL for consumer logic  

---

### Question 33
A data analytics company processes customer behavior data for 100 enterprise clients. Each client's data must be processed independently (no cross-contamination). The Glue ETL jobs share a common codebase but operate on client-specific data. The company currently maintains 100 separate Glue job definitions — one per client — which is an operational burden. Which approach reduces operational overhead while maintaining data isolation?

A) Use a single parameterized Glue job with job arguments (--client_id, --input_path, --output_path) that are passed at runtime via a Glue Workflow trigger or Step Functions state machine. Each execution processes one client's data based on the parameters, maintaining isolation through separate S3 paths and IAM role-based access control  
B) Maintain 100 separate Glue jobs but use CloudFormation templates to manage them  
C) Combine all client data into a single job run and filter by client_id within the Spark code  
D) Migrate from Glue to a self-managed Spark cluster for more flexibility  

---

### Question 34
A media company operates an Amazon OpenSearch cluster for real-time content search. The cluster has 10 data nodes (r6g.2xlarge) and stores 5 TB of active content metadata. Search queries must return within 200ms. The cluster CPU averages 80% during peak hours, and shard count has grown to 5,000 across 500 indexes (one per content category). Search latency has degraded to 2-3 seconds. What is the PRIMARY cause of performance degradation, and how should it be fixed?

A) The shard-to-node ratio is too high (500 shards per node), causing excessive overhead from shard management, query fan-out, and JVM heap pressure. Solution: consolidate the 500 category-specific indexes into fewer time-based indexes using index templates with appropriate shard counts (e.g., 1-2 shards per index for indexes under 50 GB), targeting 20-25 shards per node  
B) The r6g.2xlarge instances are too small. Solution: upgrade to r6g.4xlarge instances  
C) The data volume (5 TB) is too large for the cluster. Solution: move older data to S3  
D) OpenSearch Service has a hard limit on search latency. Solution: switch to a self-managed Elasticsearch cluster  

---

### Question 35
A company is implementing a real-time fraud detection system. Transaction events arrive at 10,000 per second. Each event must be scored against a machine learning model within 100ms. The ML model is updated daily. The system must handle model updates without downtime. The fraud scores must be stored for real-time dashboarding and 7-year compliance retention. Which architecture provides end-to-end real-time fraud detection? **(Select THREE)**

A) Ingest transactions into Amazon Kinesis Data Streams, process with a Lambda consumer that invokes a SageMaker real-time inference endpoint for fraud scoring, with the endpoint configured for auto-scaling and blue/green deployment for model updates  
B) Store fraud scores in Amazon DynamoDB for real-time dashboard access (sub-millisecond reads) with TTL set for 90 days  
C) Archive fraud scores from DynamoDB Streams via Kinesis Data Firehose to S3 in Parquet format with S3 Lifecycle policies transitioning to Glacier after 90 days for 7-year retention  
D) Use AWS Batch to process transactions in hourly micro-batches for fraud scoring  
E) Store all fraud scores exclusively in Amazon Redshift for both real-time and historical access  
F) Run the ML model directly in the Lambda function code without SageMaker  

---

### Question 36
A healthcare company stores patient records in an S3 data lake. The data is cataloged in AWS Glue Data Catalog. They need to enforce that: (1) Only the data engineering team can create or modify tables in the Glue Data Catalog, (2) Analysts can read table metadata but not modify it, (3) ML engineers can only access tables tagged as "ml-approved". The company uses AWS IAM Identity Center (SSO) for user management. Which access control model provides the MOST granular control?

A) Use AWS Lake Formation permissions in combination with the Glue Data Catalog. Grant the data engineering team database/table CREATE and ALTER permissions. Grant analysts DESCRIBE (metadata read) permissions. Use Lake Formation LF-Tags to tag tables as "ml-approved" and grant ML engineers SELECT permissions only on resources matching the "ml-approved" tag  
B) Create IAM policies for each group with specific glue:* action permissions  
C) Use S3 bucket policies to control access to the underlying data, which implicitly controls catalog access  
D) Deploy Apache Ranger on EMR for fine-grained access control on the Glue Catalog  

---

### Question 37
A company operates a data pipeline: API Gateway → Kinesis Data Firehose → S3. The data arriving is JSON but must be stored in Parquet format for Athena queries. Firehose must handle the JSON-to-Parquet conversion. Some source JSON records have nested objects and arrays. The Parquet schema must be defined in the Glue Data Catalog. Which configuration enables Firehose's built-in format conversion?

A) Enable Firehose data format conversion, select Apache Parquet as the output format, specify the Glue database and table that defines the target Parquet schema (including handling of nested structures via Struct and Array types in the Glue table definition). Firehose uses the Glue schema to deserialize incoming JSON and serialize into Parquet with Snappy compression  
B) Add a Firehose data transformation Lambda function that converts JSON to Parquet using a Python library  
C) Configure Firehose to deliver JSON to S3, then run a scheduled Glue ETL job to convert JSON to Parquet  
D) Use the Kinesis Agent on the source servers to convert to Parquet before sending to Firehose  

---

### Question 38
A data warehouse team runs Amazon Redshift with 10 dc2.8xlarge nodes. The cluster stores 30 TB of data but queries against fact tables joined with dimension tables are slow. The largest fact table (orders) has 5 billion rows distributed using KEY distribution on customer_id. However, most queries filter by order_date and join to a small dimension table (products, 50,000 rows). What distribution and sort key changes would MOST improve query performance? **(Select TWO)**

A) Change the products dimension table to use ALL distribution style so that a complete copy exists on every node, eliminating data redistribution during joins with the fact table  
B) Add order_date as the sort key on the orders fact table, enabling zone-map-based scan elimination for date-range queries — Redshift can skip blocks that don't contain the target date range  
C) Change the orders table distribution style from KEY(customer_id) to EVEN distribution  
D) Remove the sort key entirely to speed up data loading  
E) Change the products table to KEY distribution on product_id  

---

### Question 39
A company uses Amazon Athena for ad-hoc SQL queries on S3 data. They are concerned about runaway queries that scan the entire 50 TB data lake, resulting in unexpected costs ($250+ per query). They need to: (1) Limit maximum data scanned per query, (2) Track per-team query costs, (3) Prevent specific users from running queries during maintenance windows. Which combination of Athena features provides these controls? **(Select TWO)**

A) Create Athena Workgroups per team, configure each workgroup with a per-query data scan limit (e.g., 1 TB maximum), which automatically cancels queries that would exceed the threshold. Use workgroup-level CloudWatch metrics and cost allocation tags for per-team cost tracking  
B) Use Athena query result reuse to reduce redundant scans and costs across teams  
C) Configure IAM policies with time-based conditions (aws:CurrentTime) to deny athena:StartQueryExecution during maintenance windows for specific users/roles  
D) Use S3 Requester Pays to charge each team for their own data scans  
E) Set billing alarms in CloudWatch to alert when Athena costs exceed a threshold  

---

### Question 40
A company has a multi-account data lake architecture. The central data lake account stores curated data in S3. Analytics accounts in 3 regions need to query this data using Athena. Cross-region S3 access charges are significant. Queries from eu-west-1 and ap-southeast-1 analysts against us-east-1 S3 data add $5,000/month in data transfer costs. Which approach reduces cross-region data transfer costs for Athena queries?

A) Use S3 Cross-Region Replication to replicate the most frequently queried datasets to S3 buckets in eu-west-1 and ap-southeast-1, and configure Athena in each region to query their local S3 replica. Use S3 Replication Time Control (RTC) if data freshness within 15 minutes is required  
B) Use Amazon CloudFront to cache S3 data in edge locations near the analysts  
C) Set up VPC endpoints for S3 in each region to eliminate data transfer costs  
D) Compress all data using ZSTD compression to reduce the data transferred cross-region  

---

### Question 41
A company processes 1 TB of CSV data daily using AWS Glue. The Glue job reads from S3, performs deduplication, data cleansing, and dimensional lookups, then writes to Redshift. The job uses 50 G.1X workers and takes 3 hours. The team notices that 60% of the job time is spent on the deduplication step, which uses a groupByKey operation on a column with high cardinality (100 million unique values). What optimization reduces the deduplication processing time?

A) Switch to G.2X worker type to double the memory per worker (reducing disk spills during the shuffle-heavy groupByKey operation), increase the Spark shuffle partition count (spark.sql.shuffle.partitions) to better parallelize the deduplication across workers, and consider using Spark's dropDuplicates instead of groupByKey for more efficient deduplication  
B) Increase the number of G.1X workers from 50 to 200  
C) Split the CSV file into smaller files before processing  
D) Replace the Glue job with a Lambda function that processes each row individually  

---

### Question 42
A data platform team supports 200 data analysts who write Athena queries. Many analysts write inefficient queries — using SELECT * instead of selecting specific columns, not leveraging partitions, and scanning entire tables. The monthly Athena bill is $50,000. Without restricting analyst access, which measures reduce Athena costs MOST effectively? **(Select TWO)**

A) Convert all data from CSV/JSON to Apache Parquet with Snappy compression — Parquet's columnar format means SELECT * is far less impactful, and even inefficient queries scan significantly less data (typically 75-90% reduction compared to CSV)  
B) Enable Athena query result reuse, which automatically returns cached results for identical queries executed within the reuse window, avoiding repeated data scans  
C) Create Athena saved queries with optimal WHERE clauses and encourage analysts to use them  
D) Restrict all analysts to a single Athena workgroup with a 100 MB per-query scan limit  
E) Migrate from Athena to Amazon Redshift Serverless to reduce query costs  

---

### Question 43
A streaming analytics company processes real-time stock market data. They need to detect complex event patterns such as: "Alert when the same stock has three consecutive price drops exceeding 2% each, within a 5-minute window." The detection must trigger within 1 second of the pattern completing. Which processing framework is BEST suited for this complex event processing (CEP) requirement?

A) Amazon Managed Service for Apache Flink, using Flink's CEP library (FlinkCEP) which provides a pattern API specifically designed for detecting complex sequences of events within windows. Flink's low-latency event-at-a-time processing model meets the 1-second detection requirement  
B) Amazon Kinesis Data Analytics SQL with tumbling windows and conditional aggregations  
C) AWS Lambda processing Kinesis Data Streams records with a DynamoDB state store for pattern tracking  
D) Amazon EMR Spark Structured Streaming with custom pattern matching logic  

---

### Question 44
A company uses Amazon Redshift and needs to implement data masking so that: (1) Customer service agents see only the last 4 digits of credit card numbers, (2) Marketing analysts see hashed email addresses, (3) Data engineers see all data unmasked. All three roles query the same tables. Which approach implements dynamic data masking in Redshift?

A) Create Redshift views that use CASE statements and system-level functions (e.g., current_user, has_database_privilege) to return masked or unmasked data based on the querying user's role. For credit cards: CASE WHEN current_user IN ('engineer1',...) THEN cc_number ELSE 'XXXX-' || RIGHT(cc_number, 4) END. Grant each user group access only to the appropriate view  
B) Create three copies of each table with different masking levels and grant access accordingly  
C) Use Redshift Dynamic Data Masking (DDM) policies to define masking rules per column per role, attaching policies that mask credit card numbers and hash emails based on the querying user's role group  
D) Implement masking in the application layer before displaying data to users  

---

### Question 45
A media company collects clickstream data from their website (10 TB/day) and stores it in an S3 data lake. They need to compute the following metrics daily: (1) Unique visitors (cardinality estimation), (2) Session duration distribution (percentile calculations), (3) Page-view sequences (sessionization using window functions). The computations must complete within 2 hours. Which compute engine handles these efficiently on S3 data?

A) AWS Glue with PySpark — use Spark's approx_count_distinct for cardinality estimation, percentile_approx for session duration distribution, and Spark SQL window functions (LAG, LEAD, ROW_NUMBER with PARTITION BY session_id ORDER BY timestamp) for sessionization. Glue auto-scaling with G.2X workers handles the 10 TB volume  
B) Amazon Athena with standard SQL for all three computations  
C) Amazon Redshift Serverless using COPY to load data first, then run analytical queries  
D) AWS Lambda functions processing S3 objects individually for each metric  

---

### Question 46
An enterprise has deployed a data lake and wants to track data lineage — understanding where data came from, what transformations were applied, and where it flows downstream. They use AWS Glue for ETL, S3 for storage, and Athena/Redshift for analytics. Which approach provides data lineage tracking?

A) Enable AWS Glue Data Quality and use Glue workflow monitoring to track input/output datasets for each job. Use CloudTrail to log Glue API calls showing job parameters. For comprehensive lineage, integrate with the open-source OpenLineage framework via Glue's Spark environment, emitting lineage events to a lineage store like Amazon Neptune or DataHub  
B) Use AWS Glue Data Catalog comments and tags to manually document data lineage  
C) Use Amazon CloudWatch Logs to trace data flow through the pipeline  
D) Rely on S3 access logs to track which jobs accessed which data  

---

### Question 47
A weather analytics company stores 10 years of weather data (200 TB) in S3 in Parquet format, partitioned by station_id/year/month/day. They run Athena queries that filter by geographic bounding box (latitude/longitude ranges). Despite having partition pruning on date, queries still scan excessive data because geographic filtering happens AFTER the data is read. How can they optimize geographic queries?

A) Add a geohash column to the data, partition or sort by geohash prefix, so that geographic bounding box queries can be converted to geohash range filters that enable partition pruning or Parquet row-group skipping. Use a Glue ETL job to compute geohash values and repartition the data by station_id/geohash/year/month  
B) Create a secondary index on latitude and longitude columns in S3  
C) Use Amazon Location Service to pre-compute geographic regions and store as partitions  
D) Switch from Athena to Amazon Redshift with spatial data types for geographic queries  

---

### Question 48
A company operates a multi-region data analytics platform. Data is generated in us-east-1, eu-west-1, and ap-southeast-1. Analysts in each region need to query both local and remote data. Cross-region data transfer costs are excessive. The data totals 100 TB per region. Which architecture minimizes cross-region query costs while maintaining query freshness? **(Select TWO)**

A) Deploy Amazon Redshift clusters in each region with Redshift data sharing — the producer cluster in each region shares its data with consumer clusters in other regions, enabling cross-cluster queries without physically copying data. Cross-region data sharing uses compressed transfer to minimize costs  
B) Use S3 Cross-Region Replication for frequently queried datasets (not the full 100 TB) and deploy Athena workgroups in each region to query local replicas  
C) Use a single Redshift cluster in one region and have all analysts query remotely  
D) Set up VPN connections between regions to reduce data transfer costs  
E) Create a central data warehouse that aggregates all data nightly  

---

### Question 49
A company ingests JSON data into Kinesis Data Firehose bound for S3. The JSON contains a field "event_type" with 20 possible values. The analytics team wants the S3 data automatically organized into separate prefixes by event_type (e.g., s3://bucket/event_type=click/, s3://bucket/event_type=purchase/) for efficient Athena partition pruning. How can Firehose achieve this dynamic partitioning?

A) Enable Firehose Dynamic Partitioning with inline parsing — configure a JQ expression to extract the event_type field from the JSON payload, and use the extracted value in the S3 prefix configuration (e.g., event_type=!{partitionKeyFromQuery:event_type}/year=!{timestamp:yyyy}/). Firehose automatically routes records to the correct S3 prefix based on the extracted partition key  
B) Use a Firehose data transformation Lambda function to move records to different S3 prefixes  
C) Deliver all data to a single S3 prefix and use a Glue Crawler to add partitions based on the event_type column inside the files  
D) Create 20 separate Firehose delivery streams, one per event type, with different S3 prefix configurations  

---

### Question 50
A data engineering team has a Glue ETL job that reads from a JDBC source (Amazon RDS PostgreSQL, 500 GB database). The job takes 6 hours because it reads all data through a single JDBC connection. The RDS instance has adequate capacity and 16 vCPUs. How can the data read performance be improved?

A) Configure the Glue JDBC connection to use parallel reads by specifying the hashfield (or hashexpression) option to partition the data across multiple Spark partitions/threads, enabling concurrent JDBC reads from the RDS instance. Set the hashpartitions parameter to a value matching the RDS instance's vCPU count (e.g., 16) for optimal parallelism  
B) Increase the Glue job DPU count from 10 to 100  
C) Migrate from RDS PostgreSQL to Aurora PostgreSQL for faster reads  
D) Export the RDS data to S3 using pg_dump and read from S3 in the Glue job instead  

---

### Question 51
A company's data lake stores sensitive customer data alongside non-sensitive operational data. They need to implement a data governance framework that: (1) Discovers and tags sensitive data automatically, (2) Enforces access policies based on data sensitivity, (3) Provides audit logs of all data access, (4) Works across 10 AWS accounts. Which combination of services implements this governance framework? **(Select THREE)**

A) Deploy Amazon Macie across all 10 accounts via AWS Organizations to automatically discover and classify sensitive data in S3, generating sensitivity findings that identify PII, financial data, and credentials  
B) Use AWS Lake Formation to enforce access policies based on data sensitivity by applying LF-Tags (e.g., sensitivity=high, sensitivity=low) to tables and columns, and granting permissions based on these tags across accounts  
C) Enable AWS CloudTrail data events for S3 across all accounts to log every GetObject, PutObject, and DeleteObject API call, providing a complete audit trail of all data access  
D) Use AWS Config rules to discover sensitive data patterns in S3  
E) Use S3 bucket policies across all 10 accounts for access control  
F) Use Amazon GuardDuty for data classification  

---

### Question 52
A financial analytics firm runs Amazon Redshift with 5 ra3.4xlarge nodes (managed storage). Their data volume has grown to 100 TB but query performance remains acceptable for most queries. However, during month-end reporting (3 days per month), 50 additional analysts need concurrent access, and queries queue for 30+ minutes. The firm doesn't want to permanently resize the cluster. Which approach handles the temporary workload spike MOST cost-effectively?

A) Enable Redshift concurrency scaling, which automatically adds temporary cluster capacity when queues form due to high concurrency. Concurrency scaling clusters are billed per-second only when active and include 1 hour of free credits per main cluster node per day. This handles the 3-day spike without permanent infrastructure changes  
B) Manually resize the cluster to 15 nodes before month-end and resize back after  
C) Create a snapshot, restore it to a larger cluster for month-end, and delete it after  
D) Use Redshift Serverless for the month-end reporting workload  

---

### Question 53
A company operates an Amazon MSK cluster with 6 brokers (kafka.m5.2xlarge). Producers publish 200 MB/s of log data. The cluster uses 3-way replication. Consumers include a real-time processing application and a Firehose connector to S3. The team notices that consumer lag is increasing during peak hours and broker disk utilization is at 85%. Which combination of actions alleviates the performance issues? **(Select TWO)**

A) Enable MSK tiered storage to automatically offload older log segments from broker local storage to S3, reducing disk utilization and allowing brokers to retain more data without running out of space  
B) Increase the number of partitions for high-throughput topics and add 2 more brokers to distribute the load, reducing per-broker CPU and network utilization. Rebalance partitions across the expanded broker set  
C) Increase the replication factor from 3 to 5 for better durability  
D) Reduce the number of consumer groups to decrease broker load  
E) Switch to kafka.t3.small instances for cost savings  

---

### Question 54
A company needs to build a recommendation engine that processes user interaction data stored in S3. The processing involves: (1) Feature engineering (aggregating user behavior), (2) Training a collaborative filtering model, (3) Generating recommendations for 10 million users, (4) Storing recommendations for serving via API. The entire pipeline must run daily. Which architecture balances performance and cost?

A) Use AWS Glue for feature engineering (Spark-based aggregations), Amazon SageMaker for model training (using a managed training job with Spot Instances), SageMaker Batch Transform for generating predictions for 10 million users, and store results in DynamoDB with a Lambda-backed API Gateway for serving recommendations  
B) Use Amazon EMR for all steps — feature engineering, training, prediction, and storage  
C) Use SageMaker for all steps including feature engineering, training, and batch prediction  
D) Process everything with Lambda functions orchestrated by Step Functions  

---

### Question 55
A retail company has a QuickSight dashboard that queries a 2 TB Athena dataset. The dashboard has 500 active users and displays 20 visualizations. Users report that the dashboard takes 30+ seconds to load because each visualization triggers a separate Athena query. How can dashboard load performance be improved to under 5 seconds?

A) Import the dataset into QuickSight SPICE, which stores the data in a super-fast, in-memory columnar store optimized for dashboard queries. SPICE eliminates the need for Athena queries during dashboard rendering, providing sub-second response for visualizations. Schedule SPICE refreshes at the required frequency  
B) Create pre-aggregated materialized views in Athena and have QuickSight query those  
C) Increase Athena workgroup DPU allocation for the QuickSight service role  
D) Split the dashboard into 20 separate dashboards, each with one visualization  

---

### Question 56
A company's data lake receives data in multiple formats: CSV, JSON, Avro, and Parquet. The data arrives in a "landing zone" S3 bucket. They want to standardize all data into Parquet format in a "curated zone" bucket. The pipeline must handle 500 new files per hour, each between 1 MB and 10 GB. Schema validation must ensure each file conforms to the expected schema before conversion. Which architecture provides robust format standardization with schema validation?

A) Use AWS Glue ETL jobs with Glue Schema Registry for schema validation — register the expected schema for each data source in the Schema Registry, configure the Glue job to validate incoming data against the registered schema (rejecting non-conforming records to a dead-letter path), convert valid records to Parquet, and write to the curated zone. Trigger jobs via S3 event notifications → EventBridge → Glue Workflow  
B) Use Lambda functions triggered by S3 events to convert each file  
C) Use Kinesis Data Firehose with format conversion for all file types  
D) Run a daily Glue Crawler on the landing zone and then a Glue job to convert everything  

---

### Question 57
A biotech company runs Amazon EMR to process genomic data. Their Spark jobs read 50 TB of sequencing data from S3, perform CPU-intensive transformations, and write results back to S3. The cluster runs for 8 hours daily. Current configuration: 1 m5.xlarge master, 20 r5.4xlarge core nodes, all On-Demand. The monthly bill is $45,000. Which cost optimization strategy reduces costs while maintaining reliability? **(Select TWO)**

A) Use EMR Instance Fleets with a mix of instance types (r5.4xlarge, r5.2xlarge, r5a.4xlarge, m5.4xlarge) for core and task nodes, enabling Spot Instance diversification. Allocate a minimum On-Demand capacity for core nodes (to protect HDFS) and use Spot Instances for task nodes that only run Spark executors  
B) Enable EMRFS S3 for all data storage (instead of HDFS on core nodes), allowing the use of Spot Instances for ALL worker nodes since there's no HDFS data loss risk. This maximizes Spot usage and reduces cost by 60-70%  
C) Switch to Reserved Instances for the entire cluster to save 30-40%  
D) Reduce the number of core nodes from 20 to 5 and accept longer processing times  
E) Switch from Spark to MapReduce for lower memory consumption  

---

### Question 58
A company uses Amazon Kinesis Data Streams for real-time event processing. Their stream has 50 shards. A Lambda consumer processes events and writes to DynamoDB. During a traffic spike, the Kinesis IteratorAge metric spikes to 5 minutes (indicating consumer lag). The Lambda function takes 500ms per batch of 100 records. What is the MOST effective way to reduce the IteratorAge?

A) Increase the Lambda event source mapping parallelization factor from the default of 1 to 10, which allows up to 10 concurrent Lambda invocations per shard. This increases the consumer throughput from 50 concurrent invocations to 500, dramatically reducing the processing backlog without needing to increase the number of shards  
B) Increase the number of Kinesis shards from 50 to 200  
C) Increase the Lambda function timeout from 1 minute to 5 minutes  
D) Switch from Lambda to an EC2-based KCL consumer  

---

### Question 59
A company has a hybrid analytics architecture. On-premises Hadoop processes data alongside AWS EMR and Athena. They want to enable Athena queries against on-premises HDFS data without moving it to S3. The on-premises data center is connected via Direct Connect. Is this possible, and if so, how?

A) Use Athena Federated Query with a custom Lambda connector that reads from the on-premises HDFS cluster via the Direct Connect connection. Deploy the Lambda function in a VPC with access to the Direct Connect-connected subnet, and implement the Athena Query Federation SDK to translate Athena queries into HDFS file reads  
B) Athena can only query S3 data and Glue Data Catalog sources; querying on-premises HDFS is not possible  
C) Create an S3 mount point on the HDFS cluster using s3fs, then register it in the Glue Data Catalog  
D) Use AWS DataSync to continuously replicate HDFS data to S3 and query with Athena  

---

### Question 60
A company has an Athena query that scans a 10 TB table but only needs data from the last 7 days. The table is partitioned by date. The analyst's query is: SELECT * FROM events WHERE event_date > '2026-04-10'. However, Athena is still scanning the entire table. What is the MOST likely cause?

A) The event_date column being filtered is a regular column inside the Parquet files, NOT a partition key. The WHERE clause filters on this column after reading the data, not during partition pruning. Solution: the partition key is likely named differently (e.g., dt or year/month/day), and the query should filter on the partition key column. Alternatively, verify that the Glue Data Catalog table definition has event_date listed as a partition column  
B) Athena has a bug that ignores partition pruning for date-based filters  
C) The S3 bucket has versioning enabled, causing Athena to scan old object versions  
D) The Glue Crawler hasn't updated partition metadata. Solution: run MSCK REPAIR TABLE  

---

### Question 61
A company wants to implement a real-time data quality monitoring system for their data lake. Data arrives continuously from 100 sources into S3. They need to: (1) Validate data against predefined quality rules (completeness, uniqueness, referential integrity), (2) Alert when quality drops below thresholds, (3) Quarantine bad records, (4) Track quality metrics over time. Which approach provides automated data quality monitoring?

A) Use AWS Glue Data Quality rules — define DQDL (Data Quality Definition Language) rules within Glue ETL jobs to validate completeness, uniqueness, and referential integrity. Configure the Glue job to route failing records to a quarantine S3 prefix and passing records to the curated zone. Publish quality metrics to CloudWatch for dashboarding and alerting when thresholds are breached  
B) Write custom validation Lambda functions for each data source that check quality rules  
C) Use Amazon Macie to monitor data quality in S3 buckets  
D) Deploy Great Expectations on an EMR cluster for data quality validation  

---

### Question 62
A data warehouse team needs to load data from S3 into Amazon Redshift as quickly as possible. The data consists of 1,000 gzip-compressed CSV files in S3, each approximately 1 GB. The Redshift cluster has 10 nodes. What is the optimal COPY command configuration for maximum load performance? **(Select TWO)**

A) Ensure the number of files is a multiple of the number of Redshift slices (e.g., if 10 nodes with 16 slices each = 160 slices, use files that distribute evenly across slices) for parallel loading. The 1,000 files already exceed the slice count, so Redshift can parallelize the load effectively  
B) Use the MANIFEST file option to explicitly list the 1,000 S3 files, ensuring Redshift loads exactly the intended files. Set COMPUPDATE OFF and STATUPDATE OFF during the initial load to skip automatic compression analysis and statistics updates, which significantly speeds up the COPY operation  
C) Decompress all files before loading because Redshift cannot read compressed files  
D) Load files one at a time using sequential COPY commands for reliability  
E) Increase the COPY command's MAXERROR parameter to 100,000 to skip validation  

---

### Question 63
A company processes clickstream data using a Kinesis Data Streams → Lambda → DynamoDB pipeline. They need to exactly-once semantics for writing to DynamoDB, but Lambda may retry failed invocations, causing duplicate writes. The DynamoDB table tracks page view counts per user per URL. How can they ensure exactly-once counting despite Lambda retries?

A) Use DynamoDB conditional writes with an idempotency key — store the Kinesis sequence number of the last processed record in the DynamoDB item, and use a ConditionExpression that checks the sequence number before updating. If the sequence number has already been processed (duplicate retry), the conditional write fails gracefully, preventing double-counting  
B) Enable Lambda exactly-once delivery mode, which prevents retries entirely  
C) Use DynamoDB Streams to detect and reverse duplicate writes  
D) Set the Lambda event source mapping retry count to 0 to prevent retries  

---

### Question 64
A company has a data lake with 1 PB of data in S3. They use Athena for queries and want to implement comprehensive cost controls. Currently, some analysts accidentally run queries that scan the full petabyte, costing over $5,000 per query. Which comprehensive cost control strategy should be implemented? **(Select THREE)**

A) Create Athena workgroups per team with per-query data scan limits (e.g., 100 GB for analysts, 1 TB for data engineers, 5 TB for admins), which automatically cancel queries exceeding the threshold before incurring the full cost  
B) Convert all data to columnar format (Parquet/ORC) with appropriate partitioning, reducing the data scanned per query by 80-95% and proportionally reducing cost  
C) Enable Athena query result reuse to cache and return results for repeated queries without re-scanning S3 data  
D) Set up billing alarms only — they alert after the cost is incurred  
E) Restrict analyst access to Athena entirely and require all queries to go through a data engineering team  
F) Migrate the entire data lake to Amazon Redshift to avoid per-query scan pricing  

---

### Question 65
A global e-commerce company processes 50 TB of transaction data daily across 3 regions. They need a unified analytics platform that: (1) Supports real-time streaming analytics (< 1 minute latency), (2) Provides a SQL-based data warehouse for complex analytical queries, (3) Enables data scientists to run ML training on historical data, (4) Offers self-service BI dashboards, (5) Minimizes cross-region data transfer costs. Which end-to-end architecture meets ALL requirements? **(Select THREE)**

A) Deploy Amazon Kinesis Data Streams in each region for real-time ingestion, with Amazon Managed Service for Apache Flink for streaming analytics and real-time aggregations. Use Kinesis Data Firehose to deliver processed data to S3 data lakes in each region  
B) Deploy Amazon Redshift clusters in each region with cross-region data sharing, enabling analysts to query both local and remote data without full replication. Use Redshift ML for in-database ML model training on historical data  
C) Use Amazon QuickSight with SPICE for self-service BI dashboards, connecting to both Redshift (for warehouse queries) and Athena (for data lake queries), with QuickSight deployed in each region for low-latency dashboard access  
D) Use a single Amazon EMR cluster in us-east-1 for all processing across all regions  
E) Deploy a self-managed Apache Kafka cluster for streaming instead of Kinesis  
F) Use Amazon RDS for the data warehouse instead of Redshift  

---

## Answer Key

### Question 1
**Correct Answer: A**

AWS Glue Crawlers automatically discover schemas by sampling S3 data, inferring column names, data types, and nested structures, then populating the Glue Data Catalog. When schemas change, subsequent crawler runs detect and version the changes. Athena integrates natively with the Glue Data Catalog as its metastore, enabling serverless SQL queries on S3 data with zero provisioning. Option B requires managing EC2 infrastructure and a custom metadata store. Option C requires provisioning and loading a Redshift cluster (not serverless). Option D requires custom schema inference logic.

### Question 2
**Correct Answer: A**

AWS Lake Formation provides column-level, row-level, and cell-level security — all three granularity levels needed by the three business units. Column-level filtering hides PII from Trading. Row-level security filters rows for Risk. Cell-level security with data masking enables the hashed PII view for Data Scientists. All permissions are managed centrally in Lake Formation, not in individual S3 or IAM policies. Option B requires maintaining 5 copies of the data. Option C (Athena views) doesn't enforce permissions at the engine level. Option D requires managing EMR and Ranger separately.

### Question 3
**Correct Answers: A, B**

Kinesis Data Streams handles 500K events/second with sufficient shards. Apache Flink provides low-latency windowed processing with exactly-once semantics. Flink's side input (broadcast state pattern) efficiently enriches events with the 10 GB geofence dataset loaded into memory. DynamoDB provides the pricing API with single-digit millisecond reads for the surge pricing results. Option C (SQS + Lambda) doesn't support efficient windowed aggregations. Option D (Firehose) is for delivery, not real-time processing. Option E (Redshift) adds too much latency for the 30-second requirement.

### Question 4
**Correct Answer: A**

Adding diagnosis_code as a partition key enables Athena to prune partitions and only scan data matching the specified diagnosis code, instead of scanning all Parquet files and filtering afterward. This can reduce scanned data by 99%+ depending on selectivity. The Glue ETL job repartitions existing data into the new scheme. Option B (S3 indexing) doesn't exist natively. Option C is expensive and unnecessary. Option D doesn't reduce the amount of data scanned.

### Question 5
**Correct Answer: A**

Redshift Spectrum creates external tables that reference S3 data via the Glue Data Catalog. SQL queries can seamlessly join local Redshift tables with Spectrum external tables, with Redshift pushing predicate filters down to the Spectrum layer for efficient S3 scanning. No data movement required. Option B loads 200 TB into Redshift, which is expensive and time-consuming. Option C loses the Redshift local table advantage. Option D requires nightly loads and adds staleness.

### Question 6
**Correct Answer: A**

MSK runs Apache Kafka, so existing Kafka clients work with only bootstrap server endpoint changes (requirement 1). MSK supports tiered storage for cost-effective long-term retention beyond 30 days (requirement 2). MSK Serverless scales automatically to handle burst throughput (requirement 3). MSK is fully managed — no OS patching, broker management, or ZooKeeper maintenance (requirement 4). Option B requires rewriting all producers/consumers. Option C is not universally true. Option D eliminates operational benefits.

### Question 7
**Correct Answer: A**

Athena Federated Query allows querying multiple data sources in a single SQL statement using Lambda-based connectors. AWS provides pre-built connectors for PostgreSQL, MySQL, DynamoDB, and many other sources. These connectors run as Lambda functions in the user's VPC and translate Athena queries into source-specific queries. Option B doesn't exist in Athena. Option C requires materializing data (violating freshness requirement). Option D doesn't describe how Athena actually works.

### Question 8
**Correct Answer: A**

Glue job bookmarks maintain a persistent checkpoint of processed data. For S3 sources, bookmarks track which files (by path and modification timestamp) have been processed. Each subsequent run only processes new or modified files, eliminating redundant reprocessing. This is built into Glue — just enable it on the job configuration. Option B triggers on arrival but doesn't prevent reprocessing. Option C requires custom tracking infrastructure. Option D requires hardcoding dates and breaks on late-arriving data.

### Question 9
**Correct Answers: A, B**

ISM policies automate the lifecycle management of OpenSearch indexes — automatically moving data through hot, warm (UltraWarm), and cold tiers based on age. UltraWarm uses S3-backed storage at ~90% lower cost than hot nodes, while still providing on-demand search capability. Cold storage archives indexes to S3 with on-demand rehydration. Together, they keep only recent data on expensive hot nodes while retaining older data cost-effectively. Option C is expensive. Option D adds complexity. Option E doesn't reduce index overhead.

### Question 10
**Correct Answer: A**

Kinesis Data Streams handles 1M events/second (200 MB/s at 200 bytes each, requiring ~200 shards). Managed Apache Flink provides sub-second latency for windowed computations (tumbling and sliding windows) with the team's existing Flink expertise. SNS delivers alerts in real-time. Option B (Firehose 60-second buffer + Glue) adds minutes of latency. Option C (SQS) doesn't support windowed SQL. Option D (Spark Structured Streaming) has higher minimum latency than Flink.

### Question 11
**Correct Answers: A, D**

SPICE stores data in an in-memory columnar format, providing sub-second response for dashboard visualizations regardless of the number of concurrent users. Scheduling SPICE refreshes every 15 minutes meets the freshness requirement. Using direct query for infrequently changing supplier data avoids unnecessary SPICE capacity consumption. Option B (all direct query) would create unacceptable latency with 500 users. Option C doesn't address performance. Option E adds unnecessary account management overhead.

### Question 12
**Correct Answer: A**

S3 Glacier Select (now part of S3 Select functionality on Glacier storage classes) allows running SQL expressions against archived objects, retrieving only matching data without restoring the entire object. For a 50 GB file where only 500 KB is needed, this reduces cost and time dramatically. Option B (full restore) is expensive for 500 KB of useful data per 50 GB file. Option C (migrate all to Standard) is extremely expensive for 500 TB. Option D is incorrect — S3 Select doesn't work directly on Glacier Deep Archive class.

### Question 13
**Correct Answer: A**

The DynamoDB Export to S3 feature uses PITR (point-in-time recovery) snapshots, which means it reads from the backup subsystem — not from the production table's provisioned capacity. This provides ZERO impact on read/write performance. The exported DynamoDB JSON can then be converted to Parquet via Glue. Option B (Streams + Lambda) would process incrementally but requires a different architecture. Option C (Data Pipeline Scan) consumes read capacity. Option D (parallel Scan) still consumes read capacity, even with on-demand mode.

### Question 14
**Correct Answer: A**

EMR on EC2 provides full control over Spark configuration, HDFS for shuffle data (requirement), custom library support via bootstrap actions, and the most flexible instance selection. Transient clusters with Spot task nodes provide maximum cost savings. Option B (Glue) doesn't provide HDFS or fine-grained Spark configuration. Option C (EMR on EKS) provides shared infrastructure benefits but lacks native HDFS. Option D (persistent cluster) wastes money for 18 hours of idle time daily.

### Question 15
**Correct Answers: A, B**

Kinesis Data Streams with shards scaled for 200K events/second provides reliable ingestion. Lambda enrichment with DynamoDB lookups adds publisher metadata before storage. Firehose's built-in Parquet conversion using the Glue Data Catalog schema eliminates custom conversion code, and the buffer interval ensures delivery to S3 within 5 minutes. Option C (API Gateway + Lambda direct to S3) doesn't support the throughput. Option D (SQS) adds complexity for enrichment. Option E doesn't handle the enrichment requirement.

### Question 16
**Correct Answers: A, B**

Lake Formation cross-account sharing enables fine-grained permission grants from producer to consumer accounts. Resource links in the consumer's Glue Data Catalog create virtual references to shared tables, enabling Athena to query data in-place without copying. Together, they implement the data mesh pattern — distributed ownership with centralized governance. Option C (DataSync) requires data copying. Option D (cross-account roles) doesn't provide fine-grained access. Option E contradicts the data mesh principle.

### Question 17
**Correct Answers: A, B**

Kinesis as a buffer decouples IoT Core from downstream processing. Timestream is purpose-built for time-series data with automatic data lifecycle management and sub-second query latency for recent data — ideal for 24-hour dashboards. Firehose delivers batched data to S3 in Parquet for efficient long-term storage. Option C (RDS) doesn't scale to 50K inserts/second easily. Option D (DynamoDB) is possible but Timestream is more efficient for time-series queries. Option E (OpenSearch) is expensive for long-term storage.

### Question 18
**Correct Answers: A, B**

Compacting 10 million small files into optimally-sized files eliminates the massive S3 API overhead (each file requires a separate GET request, and Athena has overhead per file). This alone can improve performance by 10-100x. Converting to Parquet enables columnar reads (only scanning needed columns) and Snappy compression reduces physical data size by 75-90%. Combined, these optimizations address the two biggest performance killers: small files and row-based format. Option C is about cost, not performance. Option D and E don't address root causes.

### Question 19
**Correct Answer: A**

Protocol-specific adapters handle the heterogeneous ingestion (WebSocket, REST, FTP each need different handling). Kinesis Data Streams provides 7-day retention for replayability and handles 50K events/second. Apache Flink provides the windowed computation for anomaly detection within 5 seconds. Enhanced fan-out provides dedicated throughput for each downstream consumer. Option B (API Gateway) can't handle WebSocket streams and FTP. Option C (MSK) is valid but adds complexity with protocol adapters. Option D (S3 + Athena) can't process in 5 seconds.

### Question 20
**Correct Answers: A, B**

VACUUM reclaims space from deleted/updated rows (Redshift uses an append-only model where updates create new rows) and re-sorts data, restoring the effectiveness of sort key-based zone maps for scan elimination. ANALYZE updates table statistics used by the query optimizer to generate efficient execution plans — stale statistics after large loads cause suboptimal query plans. Option C is expensive and doesn't address the root cause. Option D is disruptive and unnecessary. Option E destroys data and is impractical.

### Question 21
**Correct Answer: A**

Athena provisioned capacity (capacity reservations) allocates dedicated DPUs to a workgroup, providing consistent performance regardless of other workloads and enabling resource-intensive queries that would fail under the default shared capacity model. Option B (Redshift) requires data migration. Option C is fragile and adds application complexity. Option D (EMR Presto) has higher operational overhead than Athena provisioned capacity.

### Question 22
**Correct Answer: A**

G.2X workers provide 2x memory (32 GB vs 16 GB for G.1X), critical for memory-intensive Spark transformations like sessionization and collaborative filtering that require large shuffles and aggregations. Auto-scaling dynamically adjusts worker count. Glue 4.0 (Spark 3.3) includes significant performance improvements including adaptive query execution. Partitioned output optimizes downstream Redshift COPY. Option B (Firehose) doesn't support complex Spark transformations. Option C loses Spark's distributed processing advantage. Option D (Lambda) can't handle complex Spark logic.

### Question 23
**Correct Answer: A**

OpenSearch provides sub-second full-text search across large log volumes — purpose-built for log analytics with inverted indexes. Streaming from CloudWatch Logs via subscription filter provides near real-time indexing. ISM policies handle the 90-day retention in OpenSearch. Firehose to S3 with Glacier lifecycle handles 7-year archival. Option B doesn't fundamentally improve CW Logs Insights performance. Option C (Athena) provides seconds-to-minutes latency, not sub-second. Option D adds operational overhead versus managed OpenSearch.

### Question 24
**Correct Answer: A**

Loading 100 GB into 10 G.1X workers (16 GB memory each, 160 GB total but shared with Spark overhead) causes memory pressure. G.2X workers (32 GB each) double available memory. Glue job bookmarks enable incremental processing, preventing full-table reloads. Pushdown predicates filter data at the JDBC source, reducing the data volume transferred to Spark. Option B is a workaround, not a solution. Option C addresses the wrong component. Option D is incorrect — Parquet is actually more memory-efficient than CSV for columnar operations.

### Question 25
**Correct Answer: A**

Enhanced Fan-Out provides each registered consumer with a dedicated 2 MB/s per-shard throughput via HTTP/2 push delivery. This eliminates read contention between the three consumers. The anti-cheat engine gets its own dedicated pipe with lower latency (push vs. poll). Other consumers continue using the standard shared throughput. Option B adds complexity and cost. Option C increases throughput but doesn't eliminate contention between consumers sharing GetRecords. Option D doesn't specifically solve the read contention issue.

### Question 26
**Correct Answer: A**

Glue Workflows provide native DAG orchestration for Glue jobs and crawlers with conditional triggers (job A success → trigger job B), automatic retry, and visual monitoring — all within the Glue console. This is the simplest solution for Glue-centric ETL pipelines. Option B (MWAA/Airflow) is more powerful but adds significant overhead for purely Glue-based pipelines. Option C (Step Functions) works but lacks the native Glue integration. Option D is error-prone and not scalable.

### Question 27
**Correct Answer: A**

Glue auto-scaling with G.2X workers handles the memory-intensive Parquet conversion efficiently. Multiple concurrent job runs parallelize the 500 TB conversion. Glue metrics help monitor progress. The validation step using Athena to compare record counts ensures completeness. Option B (EMR 24/7) is more expensive. Option C (Lambda per file) is impractical at 500 TB scale. Option D (Athena CTAS) may timeout for very large datasets and doesn't support incremental processing.

### Question 28
**Correct Answer: A**

Redshift automatic WLM with queue priorities provides service-level guarantees. HIGH priority dashboard queries get resources first, while LOW priority analytical queries yield resources when needed. Automatic WLM dynamically adjusts concurrency and memory allocation. Option B doubles infrastructure cost. Option C handles concurrency but doesn't prioritize between query types. Option D is expensive and doesn't address query prioritization.

### Question 29
**Correct Answer: A**

ALTER TABLE ADD PARTITION registers a single new partition in the Glue Data Catalog in seconds, without scanning existing partitions. Partition projection is even better — it eliminates partition management entirely by computing partition existence based on a formula, so no partition metadata needs to be maintained. Option B doesn't fix the slow scan problem. Option C is destructive and time-consuming. Option D (Glue Crawler) is slower than ALTER TABLE for a single known partition.

### Question 30
**Correct Answer: A**

Lake Formation Tag-Based Access Control (LF-TBAC) scales to any number of tenants by assigning tags to data resources and matching them to IAM role permissions. Instead of 10,000 individual policies, you create tags and tag-based permission grants. Lake Formation enforces access transparently during Athena query execution. Option B (10,000 bucket policies) is impractical. Option C (hardcoded queries) can be bypassed. Option D (10,000 databases) is operationally complex.

### Question 31
**Correct Answer: A**

Each metric uses the optimal data store: Redis for sub-second real-time counters (updated every 10 seconds), Timestream for time-series aggregations with automatic rollup (ideal for sliding 7-day windows), and Athena/SPICE for historical batch analytics. Option B (DynamoDB for everything) isn't optimal for time-series. Option C (Redshift) isn't ideal for real-time 10-second updates. Option D (CloudWatch) has limitations on custom metric dimensions and query flexibility.

### Question 32
**Correct Answers: A, B**

Enhanced fan-out eliminates read throttling during peak hours. Increased batch size improves processing efficiency. Idempotent writes using conditional expressions and sequence number tracking prevent duplicate aggregations caused by Lambda retries or Kinesis re-reads. The conditional expression ensures that reprocessed events don't double-count. Option C doesn't fix duplication or ordering. Option D adds latency. Option E increases operational overhead.

### Question 33
**Correct Answer: A**

A single parameterized Glue job eliminates 99 redundant job definitions. Job arguments (--client_id, etc.) customize each execution. Orchestration via Glue Workflow or Step Functions triggers parallel or sequential executions for each client. IAM role-based access and separate S3 paths maintain isolation. Option B still maintains 100 definitions. Option C risks cross-contamination. Option D increases operational overhead.

### Question 34
**Correct Answer: A**

The shard-to-node ratio of 500:1 (5,000 shards across 10 nodes) far exceeds OpenSearch's recommended maximum of 25 shards per GB of heap memory. Each shard consumes JVM heap for metadata, segment management, and query fan-out overhead. Reducing shard count by consolidating indexes dramatically reduces JVM pressure and query fan-out latency. Option B partially helps but doesn't address the root cause. Option C doesn't fix the shard overhead. Option D is unnecessary.

### Question 35
**Correct Answers: A, B, C**

Kinesis → Lambda → SageMaker endpoint provides a real-time scoring pipeline with < 100ms per inference. SageMaker blue/green deployment enables model updates without downtime. DynamoDB provides sub-millisecond reads for real-time dashboards. DynamoDB Streams → Firehose → S3 → Glacier handles the 7-year compliance retention with automatic lifecycle. Option D (Batch) doesn't meet real-time requirements. Option E (Redshift-only) doesn't provide real-time serving. Option F limits ML capabilities and model management.

### Question 36
**Correct Answer: A**

Lake Formation provides database, table, column, and tag-level permissions that integrate with the Glue Data Catalog. LF-Tags enable attribute-based access control (tagging tables as "ml-approved" and granting tag-based permissions). This is the most granular and maintainable approach for the described requirements. Option B (IAM policies) provides limited granularity for Glue. Option C (S3 policies) doesn't control catalog access. Option D (Ranger) adds operational overhead.

### Question 37
**Correct Answer: A**

Firehose natively supports data format conversion from JSON/CSV to Parquet/ORC using the Apache serialization/deserialization libraries. It uses the Glue Data Catalog table definition as the target schema for serialization, including handling nested Struct and Array types. No Lambda transformation is needed for format conversion. Option B adds Lambda cost and complexity. Option C adds latency and ETL overhead. Option D requires custom agent development.

### Question 38
**Correct Answers: A, B**

ALL distribution for the small products dimension table (50,000 rows) copies the entire table to every node, eliminating data redistribution during joins — the most impactful optimization for dimension-to-fact joins. Adding order_date as a sort key enables zone maps to skip data blocks that don't contain the target date range, dramatically reducing I/O for date-filtered queries. Option C (EVEN distribution) loses customer-based co-location. Option D hurts query performance. Option E (KEY on products) distributes a small table unnecessarily.

### Question 39
**Correct Answers: A, C**

Athena workgroups with per-query scan limits provide proactive cost protection — queries exceeding the limit are cancelled before incurring full cost. CloudWatch metrics per workgroup enable team-level cost tracking. IAM time-based conditions (aws:CurrentTime) can restrict Athena API access during maintenance windows. Option B helps but doesn't prevent runaway queries. Option D changes billing, not cost. Option E alerts after the fact.

### Question 40
**Correct Answer: A**

S3 Cross-Region Replication places copies of frequently queried datasets in the analyst's local region, eliminating cross-region data transfer during Athena queries. Replication is a one-time transfer cost, cheaper than repeated cross-region query scans. RTC ensures freshness within 15 minutes. Option B (CloudFront) doesn't reduce Athena scan costs. Option C (VPC endpoints) reduce cross-service, not cross-region, transfer. Option D (compression) reduces but doesn't eliminate cross-region transfer.

### Question 41
**Correct Answer: A**

The groupByKey deduplication causes massive shuffle operations on 100M unique values, which spills to disk on G.1X workers with limited memory (16 GB). G.2X workers (32 GB) keep more data in memory, reducing disk spills. Increasing shuffle partitions distributes the shuffle data more evenly. dropDuplicates is optimized by Spark's Catalyst optimizer and avoids the full groupBy overhead. Option B (more G.1X workers) doesn't fix per-worker memory spills. Option C doesn't address the algorithm issue. Option D can't handle this workload.

### Question 42
**Correct Answers: A, B**

Parquet conversion provides the single largest cost reduction — even with SELECT *, Parquet's columnar format and compression reduce scanned data by 75-90% compared to CSV/JSON. This alone could reduce the $50,000 monthly bill to $5,000-12,500. Query result reuse returns cached results for identical repeated queries (common in dashboards and scheduled reports) without re-scanning. Option C is helpful but relies on voluntary adoption. Option D (100 MB limit) would break legitimate queries. Option E doesn't necessarily reduce costs.

### Question 43
**Correct Answer: A**

Apache Flink's CEP library (FlinkCEP) provides a dedicated Pattern API for defining complex event sequences with time-based constraints. It's specifically designed for patterns like "three consecutive events matching criteria within a time window." Flink's event-at-a-time processing provides sub-second detection latency. Option B (SQL tumbling windows) can't express sequential patterns. Option C (Lambda + DynamoDB) adds latency and complexity for pattern matching. Option D (Spark) has higher latency than Flink for event-level processing.

### Question 44
**Correct Answer: C**

Redshift Dynamic Data Masking (DDM) is the purpose-built feature for this use case. DDM policies define masking functions (partial masking, hashing, full masking) per column and attach them to roles. When a user queries the table, the masking policy is applied dynamically based on their role. No views or data duplication needed. Option A (views with CASE) works but is harder to maintain. Option B triples storage and maintenance. Option D doesn't protect data accessed through direct SQL.

### Question 45
**Correct Answer: A**

Glue PySpark provides all required functions: approx_count_distinct for efficient cardinality estimation (HyperLogLog algorithm), percentile_approx for distribution calculations, and window functions (LAG, LEAD, ROW_NUMBER partitioned by session) for sessionization. Glue auto-scaling with G.2X workers handles the 10 TB volume within 2 hours. Option B (Athena) may timeout on 10 TB complex transformations. Option C (Redshift) requires loading data first. Option D (Lambda) can't handle distributed analytics.

### Question 46
**Correct Answer: A**

Glue Data Quality provides rule-based validation, and Glue workflow monitoring tracks job I/O datasets. For comprehensive lineage, integrating OpenLineage (an open standard) via the Glue Spark environment captures detailed transformation lineage and emits events to a lineage backend (Neptune for graph queries or DataHub). Option B is manual and incomplete. Option C provides execution logs, not data lineage. Option D shows access patterns, not transformation lineage.

### Question 47
**Correct Answer: A**

Geohashing converts 2D coordinates into a 1D string where nearby locations share common prefixes. Partitioning by geohash prefix enables geographic bounding box queries to be converted into partition filters, enabling Athena to prune irrelevant geographic areas. Additionally, within Parquet files, sorting by geohash enables row-group skipping for finer-grained filtering. Option B (S3 indexes) don't exist. Option C (Location Service) doesn't solve the query optimization problem. Option D is expensive for 200 TB migration.

### Question 48
**Correct Answers: A, B**

Redshift data sharing enables cross-cluster queries without physically copying data — the producer cluster shares data at the storage level, and the consumer cluster reads it directly. This is more efficient than full replication. S3 CRR for frequently queried datasets provides local copies for Athena queries, avoiding repeated cross-region scans. Together, they minimize cross-region costs for both Redshift and Athena workloads. Option C forces all traffic cross-region. Option D doesn't reduce data transfer. Option E adds latency.

### Question 49
**Correct Answer: A**

Firehose Dynamic Partitioning uses inline JQ parsing or Lambda to extract partition keys from records, then routes records to S3 prefixes based on extracted values. The !{partitionKeyFromQuery:field} syntax in the S3 prefix template enables dynamic path generation. This eliminates post-delivery partitioning jobs. Option B adds Lambda cost and doesn't leverage built-in functionality. Option C requires post-processing. Option D is operationally impractical.

### Question 50
**Correct Answer: A**

By default, Glue reads JDBC sources through a single connection, which becomes the bottleneck. The hashfield/hashexpression option tells Glue to partition the data based on a hash of the specified column, creating multiple parallel JDBC connections. Setting hashpartitions to match the RDS vCPU count (16) maximizes parallelism without overloading the source. Option B (more DPUs) doesn't help if the JDBC read is the bottleneck. Option C doesn't fix the Glue connection issue. Option D adds a step but is a valid alternative approach.

### Question 51
**Correct Answers: A, B, C**

Macie provides automated sensitive data discovery and classification (requirement 1). Lake Formation with LF-Tags enforces access policies based on sensitivity tags (requirement 2). CloudTrail S3 data events provide a complete audit trail of all data access (requirement 3). All three services support multi-account deployment via Organizations (requirement 4). Option D (Config rules) doesn't discover data patterns inside objects. Option E (bucket policies) don't scale across 10 accounts. Option F (GuardDuty) detects threats, not data classification.

### Question 52
**Correct Answer: A**

Redshift concurrency scaling automatically spins up additional cluster capacity when query queues form. It handles temporary demand spikes without manual intervention and costs nothing when not in use (includes free credits). Perfect for predictable, short-duration spikes like month-end reporting. Option B requires manual intervention and causes downtime during resize. Option C adds operational complexity. Option D requires a separate endpoint and query routing logic.

### Question 53
**Correct Answers: A, B**

Tiered storage offloads older segments to S3, reducing broker disk utilization from 85% and preventing disk-full scenarios. Adding brokers and rebalancing partitions distributes the load, reducing per-broker CPU and network utilization that causes consumer lag. Option C (5-way replication) increases disk and network usage, worsening the problem. Option D reduces consumer parallelism. Option E downgrades broker capacity.

### Question 54
**Correct Answer: A**

Each component uses the optimal service: Glue for Spark-based feature engineering (serverless, cost-effective), SageMaker training with Spot Instances (60-90% savings on training compute), Batch Transform for generating 10M predictions (parallelized across instances), and DynamoDB for serving (sub-millisecond reads via API Gateway + Lambda). Option B uses EMR for everything, which is less optimal for ML. Option C uses SageMaker for feature engineering, which is less cost-effective than Glue. Option D can't handle ML training.

### Question 55
**Correct Answer: A**

SPICE stores data in a columnar, in-memory format optimized for dashboard queries. Once imported, visualizations query SPICE (not Athena), providing sub-second rendering. With 500 users, SPICE's architecture handles concurrent access efficiently. Scheduled refreshes keep data current. Option B helps but still queries Athena at render time. Option C doesn't fundamentally fix the per-visualization query problem. Option D worsens the user experience.

### Question 56
**Correct Answer: A**

Glue Schema Registry provides centralized schema management and validation. ETL jobs validate incoming data against registered schemas, routing non-conforming records to a dead-letter path. Glue handles the multi-format conversion (CSV, JSON, Avro → Parquet) natively. EventBridge → Glue Workflow triggers processing as files arrive. Option B (Lambda) has memory/timeout limits for large files. Option C (Firehose) doesn't support all formats for conversion. Option D (daily Crawler) introduces latency.

### Question 57
**Correct Answers: A, B**

Instance Fleets with Spot diversification across multiple instance types maximizes Spot availability and cost savings. Using EMRFS (S3) instead of HDFS eliminates the core node HDFS dependency, allowing ALL worker nodes to use Spot Instances — maximizing Spot usage for the greatest cost reduction (60-70%). Option C (Reserved Instances) locks in capacity for 24/7 billing on a cluster that runs only 8 hours/day. Option D extends processing time significantly. Option E reduces capabilities.

### Question 58
**Correct Answer: A**

The parallelization factor allows multiple concurrent Lambda invocations per shard. Increasing from 1 to 10 creates up to 500 concurrent invocations (50 shards × 10), dramatically increasing throughput. Each invocation processes events from a portion of the shard's data, maintaining ordering within each invocation. Option B (more shards) works but is more expensive. Option C doesn't increase throughput. Option D adds operational overhead.

### Question 59
**Correct Answer: A**

Athena Federated Query supports custom Lambda connectors that can read from any data source accessible to the Lambda function. A custom connector implementing the Athena Query Federation SDK can read HDFS data over the Direct Connect connection. While not a pre-built connector, the SDK enables this integration. Option B is incorrect — Federated Query extends Athena's reach. Option C is a workaround, not direct HDFS querying. Option D works but requires data movement.

### Question 60
**Correct Answer: A**

This is a common Athena pitfall. If event_date is a column inside the Parquet file (not a partition key), Athena must open every Parquet file to evaluate the WHERE clause. Partition pruning only works on actual partition columns defined in the table's PARTITIONED BY clause. The fix is to either query on the actual partition key or repartition the data with event_date as a partition key. Option B is incorrect — partition pruning works correctly. Option C is irrelevant. Option D would help if partitions aren't registered but doesn't explain full-table scans.

### Question 61
**Correct Answer: A**

Glue Data Quality with DQDL rules provides native data quality validation within the ETL pipeline. Rules check completeness, uniqueness, referential integrity, and custom expressions. Failed records can be routed to a quarantine path. CloudWatch integration enables monitoring and alerting. Option B (custom Lambda) requires significant development. Option C (Macie) is for sensitive data detection, not quality. Option D adds operational overhead with self-managed infrastructure.

### Question 62
**Correct Answers: A, B**

COPY performance scales with parallelism — having more files than slices ensures all slices participate in the load. A MANIFEST file ensures exactly the intended files are loaded (preventing accidental inclusion/exclusion). COMPUPDATE OFF and STATUPDATE OFF skip the automatic compression analysis pass and statistics update, which is the most time-consuming part of COPY for large loads (run ANALYZE separately after). Option C is incorrect — Redshift handles gzip decompression natively. Option D eliminates parallelism. Option E hides data issues.

### Question 63
**Correct Answer: A**

DynamoDB conditional expressions with the Kinesis sequence number as an idempotency key provide exactly-once semantics. Before updating, the condition checks whether the sequence number has already been processed. If it has (due to Lambda retry), the conditional write fails with a ConditionalCheckFailedException, which the Lambda function handles gracefully. Option B doesn't exist. Option C is reactive, not preventive. Option D risks data loss.

### Question 64
**Correct Answers: A, B, C**

Workgroup scan limits provide proactive cost protection by cancelling expensive queries before they complete. Columnar format with partitioning is the most impactful cost reduction — reducing scanned data by 80-95%. Query result reuse eliminates redundant scans for repeated queries. Together, these provide prevention (limits), reduction (format/partitioning), and elimination (caching). Option D is reactive. Option E is too restrictive. Option F changes the pricing model but may not reduce total cost.

### Question 65
**Correct Answers: A, B, C**

Kinesis + Flink + Firehose provides real-time streaming analytics with sub-minute latency in each region (requirement 1). Redshift with cross-region data sharing provides the SQL data warehouse with ML training capability while minimizing cross-region transfer (requirements 2, 3, 5). QuickSight with SPICE provides self-service BI dashboards with multi-region deployment (requirement 4). Option D (single EMR cluster) creates cross-region latency and transfer costs. Option E adds operational overhead. Option F (RDS) is not designed for analytical workloads.
