# AWS Certified Solutions Architect - Professional (SAP-C02) Practice Test 13

**Focus Areas:** Data Lake, Lake Formation, Glue, Athena, Redshift Spectrum, QuickSight
**Time Limit:** 180 minutes
**Total Questions:** 75
**Passing Score:** 750/1000

---

## Domain Distribution
- Domain 1 – Organizational Complexity: Questions 1–20
- Domain 2 – Design New Solutions: Questions 21–42
- Domain 3 – Continuous Improvement: Questions 43–53
- Domain 4 – Migration: Questions 54–62
- Domain 5 – Cost Optimization: Questions 63–75

---

### Question 1

A multinational corporation has data analysts across five AWS accounts. The central data team manages a data lake in a shared analytics account. Analysts need to query the data lake using Athena in their own accounts, but the data team must control which tables and columns each account's analysts can access. All access changes must be centrally managed.

Which approach provides centralized cross-account data access control?

A. Use AWS Lake Formation cross-account data sharing. Register the data lake S3 location in Lake Formation in the analytics account. Create Lake Formation permissions that grant table-level and column-level access to specific IAM roles in each analyst account. Analysts use the shared catalog tables directly from their accounts.

B. Create S3 bucket policies granting cross-account access to specific prefixes. Share the Glue Data Catalog using AWS RAM. Control column access through Athena workgroup query restrictions.

C. Replicate the data lake to S3 buckets in each analyst account. Use Lake Formation in each account for local access control.

D. Create IAM roles in the analytics account for each analyst team. Analysts assume these roles to query the data lake from their accounts.

**Correct Answer: A**

**Explanation:** Lake Formation cross-account sharing provides centralized governance with fine-grained permissions. The data team manages all access from the analytics account, granting table-level and column-level permissions to external account principals. Analysts see shared tables in their local Glue Data Catalog without managing S3 permissions. Lake Formation handles the underlying S3 and Glue permissions automatically. Option B requires managing S3 policies and Glue catalog sharing separately without column-level control. Option C creates data duplication and decentralized governance. Option D requires analysts to switch accounts, which breaks their local workflows.

---

### Question 2

A company has a data lake with 500 tables registered in AWS Glue Data Catalog. The data governance team needs to implement a tagging system where tables and columns are tagged with sensitivity levels (public, internal, confidential, restricted), and access is granted based on tag values rather than individual table/column grants.

Which feature enables this tag-based access control?

A. Use Lake Formation Tag-Based Access Control (LF-TBAC). Define LF-Tags for sensitivity levels and assign them to databases, tables, and columns. Create data permissions that grant access based on tag values (e.g., grant SELECT on all resources tagged sensitivity=internal to the analyst IAM role).

B. Create resource tags on Glue Data Catalog tables and use IAM policies with tag-based conditions to control access.

C. Implement a custom Lambda authorizer that checks tags on resources before allowing Athena queries.

D. Use AWS Resource Groups to group tables by sensitivity level and grant IAM permissions per resource group.

**Correct Answer: A**

**Explanation:** Lake Formation Tag-Based Access Control (LF-TBAC) is purpose-built for this use case. LF-Tags are metadata labels assigned to databases, tables, and columns. Permissions are defined as expressions (e.g., "grant SELECT where sensitivity IN (public, internal)"), which automatically apply to any resource matching the tag criteria. When new tables are added with appropriate tags, permissions apply automatically. Option B—IAM tag-based conditions don't support Glue Data Catalog column-level access. Option C is a custom solution that adds latency and maintenance overhead. Option D—Resource Groups don't integrate with Glue Data Catalog or Lake Formation permissions.

---

### Question 3

A company runs AWS Glue ETL jobs that process 10TB of raw data daily from S3, transforming it into Parquet format for analytics. The Glue jobs are configured with 50 DPUs and take 4 hours to complete. The data arrives continuously throughout the day, but analysts only need updated data every hour.

Which Glue optimization reduces processing time while maintaining hourly freshness?

A. Convert the batch Glue ETL job to a Glue Streaming ETL job that processes data continuously using micro-batches. Configure the streaming job to read from S3 using a manifest file updated by S3 event notifications, processing only new files.

B. Enable Glue job bookmarks to process only new data since the last job run. Schedule the job hourly using Glue Triggers. Use the Glue auto-scaling feature to dynamically allocate DPUs based on data volume.

C. Increase the DPU count from 50 to 200 to process the 10TB faster in a single batch run.

D. Split the data into 24 hourly partitions and run 24 parallel Glue jobs, one per partition.

**Correct Answer: B**

**Explanation:** Glue job bookmarks track which data has been processed, enabling incremental processing on each hourly run. Instead of reprocessing 10TB, each hourly run processes only the new data (~417GB/hour). Auto-scaling dynamically adjusts DPUs based on the data volume per run, optimizing cost. Hourly scheduling via Glue Triggers ensures data freshness. Option A (streaming) adds complexity for an hourly freshness requirement—streaming is more appropriate for sub-minute latency. Option C (more DPUs) processes faster but still reprocesses all 10TB. Option D creates operational complexity with 24 jobs.

---

### Question 4

A company's data lake spans three AWS accounts: raw data (ingestion account), curated data (analytics account), and reporting data (BI account). AWS Glue crawlers in the ingestion account discover raw data schemas. The analytics account needs to access raw data tables for ETL, and the BI account needs to access curated tables for dashboards.

Which architecture provides centralized catalog management with cross-account access?

A. Designate the analytics account as the Lake Formation administrator. Register all S3 locations (across accounts) in the analytics account's Lake Formation. Use Lake Formation cross-account permissions to share specific tables with the ingestion and BI accounts. Run Glue crawlers in the analytics account with cross-account S3 access.

B. Run Glue crawlers in each account to create local catalogs. Use AWS RAM to share the catalogs between accounts. Merge the catalogs manually.

C. Create a centralized Glue Data Catalog in the analytics account. Use Glue resource policies to allow cross-account crawler access from the ingestion account and query access from the BI account.

D. Replicate all data to the analytics account using S3 replication. Run all crawlers and ETL in the analytics account.

**Correct Answer: A**

**Explanation:** Centralizing Lake Formation in the analytics account provides a single governance point for the entire data lake. Lake Formation can register S3 locations from other accounts (using cross-account IAM roles), manage the unified catalog, and grant cross-account permissions at table/column/row level. The ingestion account gets permissions to register new data, and the BI account gets read-only access to curated tables. Option B creates fragmented catalogs requiring manual synchronization. Option C (Glue resource policies) provides basic cross-account access but lacks Lake Formation's fine-grained governance features. Option D creates unnecessary data copies.

---

### Question 5

An organization needs to implement data quality checks in their data lake pipeline. Raw data arrives in S3, is processed by Glue ETL, and stored as curated Parquet files. The team needs to validate that: no null values exist in required columns, numeric values fall within expected ranges, and referential integrity is maintained between related datasets.

Which approach provides integrated data quality validation?

A. Use AWS Glue Data Quality rules within the Glue ETL job. Define Data Quality rules (IsComplete, ColumnValues, ReferentialIntegrity) in the Glue job. Configure the job to either quarantine or fail when quality checks fail. Publish quality metrics to CloudWatch.

B. Create a separate Lambda function that runs after the Glue job to validate the output Parquet files using pandas.

C. Use Great Expectations library deployed on an EMR cluster to run data quality checks as a separate pipeline stage.

D. Write custom Spark code within the Glue job to perform validation checks and log results to DynamoDB.

**Correct Answer: A**

**Explanation:** AWS Glue Data Quality is a native feature that integrates directly into Glue ETL jobs. It supports declarative rules (IsComplete for null checks, ColumnValues for range validation, ReferentialIntegrity for cross-dataset validation) that run as part of the ETL job. Failed records can be routed to a quarantine location, and quality metrics are published to CloudWatch for monitoring. No additional infrastructure is needed. Option B (Lambda + pandas) can't efficiently process large datasets. Option C (Great Expectations on EMR) adds infrastructure management. Option D (custom Spark) requires maintaining custom validation code.

---

### Question 6

A company has a data lake with 200TB of data in S3, cataloged in the Glue Data Catalog. Multiple teams run Athena queries. The security team discovers that a junior analyst accidentally queried a table containing PII data. They need to implement fine-grained access control where access is granted based on the user's IAM role and the data sensitivity.

Which solution provides the MOST comprehensive access control?

A. Implement Lake Formation permissions that grant database, table, and column-level access based on IAM roles. Enable Lake Formation for Athena by setting the data catalog to use Lake Formation permissions instead of IAM-only policies. Revoke the IAMAllowedPrincipals grant on sensitive tables.

B. Create separate S3 buckets for each sensitivity level and use bucket policies to restrict access.

C. Use Athena workgroups with query result encryption and limit which tables can be queried per workgroup.

D. Create IAM policies for each analyst role that deny access to specific S3 prefixes containing PII data.

**Correct Answer: A**

**Explanation:** Lake Formation provides centralized, fine-grained access control integrated with Athena. By revoking the IAMAllowedPrincipals default grant, all access must be explicitly granted through Lake Formation. Column-level permissions can hide PII columns from unauthorized roles while allowing access to non-PII columns in the same table. This is managed centrally without restructuring the data lake. Option B requires restructuring data by sensitivity level. Option C (workgroups) can't control table/column access. Option D (S3 IAM policies) can't provide column-level control and is complex to maintain at scale.

---

### Question 7

A financial services company builds a data lake that must comply with GDPR. They need to track which datasets contain personal data, who accessed the data, and be able to delete specific individual's data across all datasets (right to erasure). The data lake has 1,000 datasets in S3.

Which combination of services addresses these GDPR requirements? (Choose TWO.)

A. Use AWS Glue Data Catalog with Lake Formation to tag datasets containing personal data. Enable Lake Formation audit logging to track all data access (who accessed what, when). Use CloudTrail Lake for long-term access log retention.

B. Use Amazon Macie to scan S3 buckets and automatically identify datasets containing PII. Create a PII inventory with Macie's data classification results.

C. Use S3 Object Lock in governance mode to prevent accidental deletion of personal data while allowing authorized right-to-erasure operations.

D. Use Amazon Comprehend to scan all datasets for personal data identification.

E. Create a DynamoDB table that manually tracks which datasets contain personal data.

**Correct Answer: A, B**

**Explanation:** Amazon Macie (B) automatically scans S3 buckets using machine learning to identify PII (names, addresses, credit card numbers, etc.), creating a comprehensive inventory of personal data across 1,000 datasets. Lake Formation (A) provides data access tracking through audit logs (who queried which tables/columns) and centralized governance with LF-Tags for marking PII datasets. For right-to-erasure, Lake Formation's catalog integration helps locate all datasets containing an individual's data. Option C (Object Lock) prevents deletion, which contradicts right-to-erasure. Option D (Comprehend) is for natural language processing, not structured data PII detection. Option E is manual and error-prone.

---

### Question 8

A company uses Amazon Redshift as their data warehouse and needs to extend analytics to include data stored in S3 without loading it into Redshift. The data in S3 is in Parquet format, partitioned by date and region, and cataloged in the Glue Data Catalog.

Which approach allows Redshift users to query S3 data alongside Redshift tables?

A. Use Redshift Spectrum by creating an external schema in Redshift that references the Glue Data Catalog database. Create external tables that map to the S3 data. Analysts write SQL joins between Redshift local tables and Spectrum external tables.

B. Use the COPY command to load the S3 data into Redshift tables before joining.

C. Create a materialized view in Redshift that references the S3 data through a Lambda UDF.

D. Use Amazon Athena federated query to join Redshift tables with S3 data.

**Correct Answer: A**

**Explanation:** Redshift Spectrum allows querying S3 data directly from Redshift using external tables. By mapping the external schema to the Glue Data Catalog, Redshift automatically inherits the table definitions, partitioning, and statistics. Analysts can write standard SQL that joins local Redshift tables (hot data) with Spectrum external tables (cold S3 data) in a single query. Partition pruning on date and region minimizes the data scanned. Option B (COPY) requires loading all data into Redshift, consuming storage and time. Option C is not a valid Redshift feature. Option D works from the Athena side but not from Redshift.

---

### Question 9

A company needs to build a real-time dashboard showing sales metrics updated every minute. Raw transaction data lands in S3 via Kinesis Data Firehose every 60 seconds. The dashboard must show aggregated metrics: total sales by region, top products, and hourly trends. Amazon QuickSight is the BI tool.

Which architecture provides near-real-time dashboard updates?

A. Configure Kinesis Data Firehose to deliver data to S3 in Parquet format with 60-second buffering. Use a Glue crawler scheduled every 5 minutes to update partitions. Configure QuickSight with a direct query data source connected to Athena. Set the dashboard auto-refresh to every minute.

B. Configure Kinesis Data Firehose to deliver to S3. Use Athena as the QuickSight data source with SPICE dataset scheduled to refresh every 15 minutes.

C. Write Firehose data directly to Redshift using the Redshift data API. Connect QuickSight to Redshift with direct query mode and auto-refresh.

D. Use Kinesis Data Analytics to aggregate metrics in real-time. Write aggregated results to DynamoDB. Connect QuickSight to DynamoDB.

**Correct Answer: A**

**Explanation:** Kinesis Firehose delivers data to S3 every 60 seconds in Parquet (efficient for Athena). A frequent Glue crawler updates partitions so Athena sees new data. QuickSight in direct query mode (not SPICE) queries Athena on every dashboard refresh, showing the latest data. Auto-refresh at 1-minute intervals provides near-real-time updates. Option B (SPICE with 15-minute refresh) doesn't meet the per-minute requirement. Option C works but Firehose-to-Redshift requires additional configuration and Redshift costs. Option D—QuickSight doesn't natively connect to DynamoDB.

---

### Question 10

A company has a centralized data lake managed by the data platform team. Analysts across 10 business units request new datasets weekly. The current process requires the platform team to manually create Glue tables, set Lake Formation permissions, and notify analysts. This creates a 2-week backlog.

Which approach accelerates dataset provisioning?

A. Implement a self-service data catalog using AWS Service Catalog. Create Service Catalog products that package Glue crawler creation, Lake Formation permission grants, and notification via SNS. Business unit admins launch products to register and share new datasets. Lake Formation's delegated permissions model allows designated admins to grant access within their scope.

B. Give all analysts full Lake Formation administrator access so they can register and share datasets themselves.

C. Automate dataset provisioning using a Step Functions workflow triggered by a DynamoDB-backed request form. The workflow runs Glue crawlers, creates Lake Formation permissions based on predefined policies, and notifies requestors.

D. Pre-create permissions for all analysts on all current and future tables to eliminate the request process.

**Correct Answer: C**

**Explanation:** A Step Functions workflow provides automated, governed self-service. The request form captures dataset details (S3 location, access requirements), the workflow validates the request, runs Glue crawlers to create table definitions, applies Lake Formation permissions based on the requestor's business unit and the data's sensitivity tags, and notifies the requestor. This reduces provisioning from 2 weeks to minutes while maintaining governance. Option A (Service Catalog) works but is less flexible for custom access policies. Option B grants excessive permissions, violating least privilege. Option D pre-granting access to all tables violates data governance principles.

---

### Question 11

A company needs to synchronize their Glue Data Catalog across two AWS Regions for disaster recovery. The primary Region runs all ETL jobs and serves as the source of truth. The DR Region must have an up-to-date catalog so analysts can switch Regions during a failover.

Which approach keeps the catalog synchronized?

A. Use AWS Glue Data Catalog replication to automatically replicate catalog changes from the primary to the DR Region. Configure replication at the database level for specific databases that need DR.

B. Export the Glue Data Catalog daily using the GetTables API and import it to the DR Region using BatchCreatePartition and CreateTable APIs via a Lambda function.

C. Use S3 Cross-Region Replication for the data and run identical Glue crawlers in both Regions to independently discover schemas.

D. Use AWS CloudFormation to define all catalog resources and deploy the same template in both Regions.

**Correct Answer: A**

**Explanation:** AWS Glue Data Catalog replication provides native cross-Region catalog synchronization. Changes (table creation, schema updates, partition additions) in the primary Region automatically replicate to the target Region with minimal lag. This ensures the DR Region has an up-to-date catalog without custom synchronization logic. Option B (API-based export/import) has a daily lag and requires custom code. Option C (independent crawlers) can produce different schemas if data changes between crawler runs. Option D (CloudFormation) only handles initial deployment, not ongoing changes.

---

### Question 12

A company uses Athena to query a data lake with 500 tables. Queries have become slower because the Glue Data Catalog contains millions of partitions. A single table has 2 million partitions partitioned by year/month/day/hour.

Which optimization improves partition-heavy table query performance? (Choose TWO.)

A. Enable Athena partition projection for the table. Define the partition schema (year, month, day, hour) with ranges and projection types (integer, date). Athena calculates partition locations mathematically instead of querying the Glue Data Catalog.

B. Use the MSCK REPAIR TABLE command more frequently to update partitions.

C. Reduce the partition granularity from hourly to daily, consolidating data into daily partitions using a Glue ETL job.

D. Enable Glue Data Catalog indexes on partition key columns to speed up partition pruning queries.

E. Increase the Athena workgroup DPU allocation for faster partition listing.

**Correct Answer: A, C**

**Explanation:** Partition projection (A) eliminates the need to query the Glue Data Catalog for partition metadata. Athena uses the defined projection rules to calculate partition locations mathematically, which is instantaneous regardless of partition count. This eliminates the partition listing bottleneck. Reducing granularity to daily (C) reduces partition count from 2M to ~83K (2M/24), which helps all tools that interact with the partitions. Option B (MSCK REPAIR) adds partitions but doesn't improve query performance. Option D—Glue Data Catalog doesn't support indexes on partitions. Option E—Athena workgroup DPU allocation doesn't affect partition listing speed.

---

### Question 13

A company has a QuickSight deployment with 500 users across 10 departments. Each department should only see dashboards and analyses relevant to their department. The company uses Active Directory for user authentication.

Which QuickSight configuration provides department-level access control?

A. Configure QuickSight with Active Directory integration. Create QuickSight groups mapped to AD groups (one per department). Share dashboards and datasets with the corresponding QuickSight groups. Use row-level security (RLS) on datasets to filter data by department based on the user's group membership.

B. Create separate QuickSight accounts per department for complete isolation.

C. Use QuickSight namespaces (one per department) for multi-tenant isolation. Each namespace has its own users, groups, and resources that are invisible to other namespaces.

D. Create a single QuickSight dashboard with 10 tabs and use parameter controls for department filtering.

**Correct Answer: C**

**Explanation:** QuickSight namespaces provide complete isolation between departments. Each namespace has its own user pool, groups, dashboards, datasets, and analyses. Users in one namespace cannot see or access resources in another. Combined with AD integration, users are automatically placed in their department's namespace. This provides the strongest isolation for a multi-department environment. Option A (groups + RLS) provides data filtering but doesn't isolate dashboard visibility. Option B (separate accounts) adds billing and management complexity. Option D (tabs) doesn't restrict access at all.

---

### Question 14

A company builds a data pipeline: raw JSON data in S3 → Glue ETL → curated Parquet in S3 → Athena queries. The raw data contains nested JSON structures up to 5 levels deep. The Glue crawler correctly detects the schema, but the nested structures cause complex and slow Athena queries.

Which transformation approach in Glue ETL BEST handles deeply nested JSON?

A. Use Glue's Relationalize transform to flatten nested JSON structures into separate relational tables. This converts nested arrays and objects into individual tables with foreign key relationships, making them queryable with standard SQL joins in Athena.

B. Write custom PySpark code in the Glue job to manually extract each nested field using explode and getItem operations.

C. Use Athena's UNNEST function to flatten nested structures at query time instead of during ETL.

D. Store the JSON data as-is in Parquet format and use Athena's dot notation to query nested fields.

**Correct Answer: A**

**Explanation:** Glue's Relationalize transform automatically flattens complex nested JSON into relational tables. It handles nested arrays by creating separate tables with join keys, and nested objects by flattening field names with prefixes. This is a single-step transformation that produces clean, denormalized tables optimized for SQL queries. Athena performs better on flat Parquet files than deeply nested structures. Option B (custom PySpark) requires significant code for 5-level nesting. Option C (UNNEST at query time) adds complexity and latency to every query. Option D (dot notation) works for simple nesting but becomes unwieldy at 5 levels and doesn't support efficient partition pruning on nested fields.

---

### Question 15

A company uses Amazon Redshift as their primary data warehouse. They want to implement workload management to ensure that short dashboard queries are not blocked by long-running ETL queries. The cluster has 10 dc2.large nodes.

Which Redshift feature achieves this?

A. Enable automatic workload management (auto WLM) and create separate query queues: a "short-query" queue with higher priority and a "ETL" queue with lower priority. Configure short-query acceleration (SQA) to automatically route queries predicted to run under 5 seconds to the short-query queue.

B. Create two Redshift clusters: one for dashboards and one for ETL. Use data sharing between clusters.

C. Configure concurrency scaling to add transient clusters during periods of high demand.

D. Use Redshift Serverless for dashboard queries and provisioned Redshift for ETL.

**Correct Answer: A**

**Explanation:** Auto WLM with Short Query Acceleration automatically identifies short-running queries and routes them to a fast lane, preventing them from queuing behind long ETL operations. SQA uses machine learning to predict query runtime and short-circuits the normal queue for queries under the configured threshold. This requires no manual query classification. Option B (separate clusters) works but doubles infrastructure cost. Option C (concurrency scaling) adds capacity but doesn't prioritize short queries. Option D adds operational complexity with two different Redshift endpoints.

---

### Question 16

A company needs to build a data lake that ingests data from 30 different sources: 10 relational databases (MySQL, PostgreSQL, Oracle), 10 SaaS applications (Salesforce, SAP, ServiceNow), and 10 streaming sources (IoT, clickstream, logs). The data must be cataloged with consistent schemas.

Which ingestion architecture handles all source types?

A. Use AWS Glue connections for relational databases (JDBC connections). Use Amazon AppFlow for SaaS applications (native connectors for Salesforce, SAP, ServiceNow). Use Amazon Kinesis Data Firehose for streaming sources. All three deliver data to S3 in the raw layer. Run Glue crawlers to catalog all ingested data in the Glue Data Catalog.

B. Use AWS DMS for all 30 sources—DMS supports relational databases, SaaS applications, and streaming sources.

C. Build custom Lambda functions for each source using source-specific APIs.

D. Use Apache NiFi on EMR for all source types with custom processors for each source.

**Correct Answer: A**

**Explanation:** This architecture uses the right tool for each source type: Glue connections provide native JDBC connectivity to relational databases with schema detection; AppFlow provides managed, no-code connectors for popular SaaS applications (Salesforce, SAP, ServiceNow) with scheduled or event-driven flows; Kinesis Firehose handles streaming data with buffering and format conversion. All deliver to S3 where Glue crawlers create a unified catalog. Option B—DMS doesn't support most SaaS applications natively. Option C (custom Lambda) requires significant development for 30 sources. Option D (NiFi) adds operational overhead for cluster management.

---

### Question 17

A company runs Athena queries against a 100TB data lake. Monthly Athena costs are $15,000 based on data scanned. Analysts frequently run the same exploratory queries during the day, scanning the same data repeatedly.

Which combination of optimizations reduces Athena query costs? (Choose TWO.)

A. Convert data from CSV to Parquet or ORC columnar format. Columnar formats allow Athena to read only the required columns, reducing data scanned by 80-90% for typical analytical queries.

B. Implement S3 data partitioning based on commonly filtered columns (date, region, product). Use WHERE clauses that align with partition keys to enable partition pruning.

C. Enable Athena query result reuse so identical queries return cached results without scanning data again.

D. Use Athena workgroup with a per-query data scan limit of 1TB to prevent expensive queries.

E. Compress the data using gzip to reduce the total data size in S3.

**Correct Answer: A, B**

**Explanation:** Converting to columnar formats (A) reduces data scanned dramatically because Athena only reads the columns referenced in the query. For a query selecting 5 of 50 columns, data scanned drops by ~90%. Partitioning (B) allows Athena to skip entire directories of data when the WHERE clause matches partition keys. For example, a query filtering date='2024-01-15' in a date-partitioned table only scans that day's data, not the entire 100TB. Combined, these can reduce data scanned (and costs) by 95%+. Option C—Athena query result reuse exists but has limitations and doesn't address the fundamental data scanning cost. Option D limits cost but degrades the user experience. Option E (gzip) helps but less than columnar formats.

---

### Question 18

A company operates a Redshift cluster that needs to query both local Redshift tables and tables in an external Glue Data Catalog managed by Lake Formation. Lake Formation permissions must be enforced when Redshift queries the external tables.

Which configuration enables Lake Formation governance for Redshift Spectrum queries?

A. Enable Lake Formation governance for Redshift by registering the Redshift cluster as a Lake Formation resource. Create an IAM role for Redshift Spectrum that is granted specific Lake Formation permissions on the external tables. Enable the "Use Lake Formation credentials" option on the external schema.

B. Grant the Redshift cluster's IAM role direct S3 access to the data lake. Lake Formation permissions are automatically enforced through the Glue Data Catalog.

C. Create a separate IAM role with S3 permissions matching the Lake Formation grants. Assign this role to the Redshift cluster.

D. Use Redshift data sharing to share the Lake Formation-governed tables with the Redshift cluster.

**Correct Answer: A**

**Explanation:** Enabling Lake Formation governance for Redshift Spectrum requires registering the integration and configuring the external schema to use Lake Formation credentials. When this is enabled, Redshift Spectrum queries check Lake Formation permissions before accessing data, and column-level permissions from Lake Formation are enforced. The IAM role used for Spectrum receives temporary, scoped-down credentials from Lake Formation for each query. Option B—without explicit Lake Formation integration, Redshift uses the IAM role's S3 permissions directly, bypassing Lake Formation. Option C doesn't enforce Lake Formation's fine-grained permissions. Option D—data sharing is for Redshift-to-Redshift, not Lake Formation external tables.

---

### Question 19

A company has a data lake that processes data from multiple countries. GDPR requires that European data stays in EU Regions, while CCPA requires California data to have specific access controls. The data lake currently stores all data in us-east-1 in a single S3 bucket.

Which architecture ensures regulatory compliance?

A. Create separate S3 buckets in eu-west-1 for European data and us-east-1 for other data. Use Lake Formation in each Region with LF-Tags to classify data by regulatory regime (GDPR, CCPA). Configure cross-Region Lake Formation governance where the central team manages permissions. Use Glue ETL jobs with data routing logic based on the data origin country.

B. Keep all data in us-east-1 and use Lake Formation column-level security to restrict access based on data origin.

C. Create IAM policies that restrict API calls to specific Regions based on the user's location.

D. Encrypt European data with a separate KMS key and use key policy-based access control.

**Correct Answer: A**

**Explanation:** Regulatory compliance requires physical data residency—European data must reside in EU Regions for GDPR. Separate S3 buckets in eu-west-1 for EU data and us-east-1 for other data satisfies residency requirements. LF-Tags classify data by regulatory regime, enabling policy-based access control (GDPR data requires consent tracking, CCPA data requires specific disclosure). Glue ETL jobs route incoming data to the correct Region based on origin. Option B doesn't address data residency—GDPR requires data to be stored in the EU. Option C restricts API access by Region but doesn't ensure data residency. Option D (encryption) doesn't address data residency requirements.

---

### Question 20

A large enterprise uses Athena across 50 accounts in an AWS Organization. They need to enforce consistent Athena configuration: query result encryption, query result location in a centralized S3 bucket, and maximum data scan limits per query. New accounts must automatically receive these configurations.

Which approach enforces organization-wide Athena governance?

A. Use AWS Organizations SCPs to deny athena:StartQueryExecution unless the workgroup is a centrally managed workgroup. Deploy Athena workgroups via CloudFormation StackSets to all accounts with the required configurations (result encryption, centralized S3 location, data scan limits). Configure the workgroups to override client-side settings.

B. Create an Athena configuration in each account manually and use AWS Config rules to check compliance.

C. Use a Lambda function triggered by new account creation to configure Athena settings in each account.

D. Configure Athena settings at the organization level using the Athena console.

**Correct Answer: A**

**Explanation:** CloudFormation StackSets deploy standardized Athena workgroups to all accounts (current and future) in the organization. Workgroups configured to override client-side settings enforce encryption, result location, and scan limits regardless of analyst preferences. The SCP ensures analysts must use the managed workgroup by denying queries submitted without the workgroup specified. This is preventive, automated, and covers new accounts. Option B is reactive and requires manual setup. Option C handles new accounts but not existing ones. Option D—Athena doesn't have organization-level settings.

---

### Question 21

A company is building a customer 360 data platform that consolidates customer data from CRM (Salesforce), support tickets (Zendesk), web analytics (Google Analytics), and transaction data (RDS MySQL). The platform must provide a unified customer view with consistent customer IDs across all sources.

Which architecture provides entity resolution and unified customer profiles?

A. Use Amazon AppFlow to ingest data from Salesforce and Zendesk. Use Kinesis Data Firehose for Google Analytics events. Use AWS DMS for RDS MySQL. All data lands in S3. Use AWS Entity Resolution to match and link customer records across sources using rule-based and ML-based matching. Store resolved customer profiles in DynamoDB for real-time access and S3 for analytics.

B. Write custom Glue ETL jobs with fuzzy matching logic to link customer records across sources.

C. Use Amazon Comprehend to extract customer entities from all data sources and match them.

D. Import all data into Amazon Neptune graph database and use graph queries to resolve customer identities.

**Correct Answer: A**

**Explanation:** AWS Entity Resolution provides managed entity matching that links records from different sources to the same customer. It supports rule-based matching (exact match on email, phone) and ML-based matching (fuzzy matching on names, addresses). AppFlow, Firehose, and DMS handle the diverse source types. The resolved profiles are stored in DynamoDB for real-time application access and S3 for analytical queries via Athena. Option B (custom fuzzy matching) is complex to build and maintain accurately. Option C (Comprehend) is for NLP entity extraction, not record matching. Option D (Neptune) can model relationships but doesn't provide matching capabilities.

---

### Question 22

A company needs to design a data lake architecture that supports both batch analytics (Athena, Redshift Spectrum) and real-time analytics (sub-second query latency). The data includes 5TB of historical data and 100GB of new data daily. Real-time queries focus on the last 24 hours of data.

Which architecture supports both use cases?

A. Implement a Lambda architecture: batch layer stores all data in S3 as Parquet (queried by Athena/Redshift Spectrum), speed layer writes recent data to DynamoDB or OpenSearch (for sub-second queries). A Glue ETL job periodically promotes speed layer data to the batch layer.

B. Store all data in Amazon Redshift with materialized views for real-time queries.

C. Use Amazon Timestream for all data with built-in warm and cold storage tiers.

D. Store all data in S3 and use Athena with SPICE acceleration for real-time queries.

**Correct Answer: A**

**Explanation:** The Lambda architecture separates batch and real-time processing optimally. Historical data in S3 as Parquet provides cost-effective storage for batch analytics (Athena/Redshift Spectrum). Recent data in DynamoDB (sub-millisecond reads) or OpenSearch (sub-second complex queries) serves real-time dashboard needs. A scheduled Glue ETL job moves data from the speed layer to the batch layer, maintaining a unified view. Option B (all in Redshift) is expensive for 5TB+ and Redshift isn't optimized for sub-second point lookups. Option C (Timestream) is for time-series data only. Option D—SPICE has refresh delays and size limits, not true real-time.

---

### Question 23

A media company stores 500TB of video metadata in their data lake. Analysts run complex analytical queries that join 10+ tables with aggregations and window functions. Athena queries timeout after 30 minutes. The company needs better performance for complex analytical queries.

Which solution improves complex query performance?

A. Use Amazon Redshift Serverless for the complex analytical queries. Load frequently joined dimension tables into Redshift, and use Redshift Spectrum for the large fact tables remaining in S3. Redshift's distributed query engine handles complex joins and aggregations more efficiently than Athena for this workload pattern.

B. Pre-compute the join results using Glue ETL into a denormalized table that Athena can query without joins.

C. Increase the Athena timeout limit and use larger DPU allocations with Athena provisioned capacity.

D. Migrate all 500TB into Redshift managed storage for the fastest query performance.

**Correct Answer: A**

**Explanation:** Redshift Serverless provides a distributed query engine optimized for complex joins, aggregations, and window functions without managing cluster infrastructure. Dimension tables loaded into Redshift local storage benefit from distribution keys and sort keys for optimal join performance. Large fact tables remain in S3, queried through Spectrum, avoiding storage costs. Redshift handles multi-table joins and window functions more efficiently than Athena's serverless engine. Option B (denormalization) works but creates massive data duplication for 10+ table joins. Option C—Athena has inherent limitations for very complex queries. Option D (full Redshift load) is extremely expensive for 500TB.

---

### Question 24

A company collects IoT sensor data from 10,000 devices, each sending readings every 5 seconds. They need to: store raw data for 7 years, enable SQL queries on recent data (last 30 days), and generate QuickSight dashboards showing trends.

Which data architecture handles the ingestion volume and retention requirements?

A. Use AWS IoT Core to ingest sensor data. Configure IoT Rules to route data simultaneously to: Kinesis Data Firehose → S3 (Parquet, partitioned by date) for long-term storage, and Amazon Timestream for recent data queries. Connect QuickSight to Timestream for real-time dashboards. Use S3 lifecycle policies to transition data older than 90 days to Glacier.

B. Ingest all data directly to DynamoDB with TTL for 30-day retention and S3 export for long-term storage.

C. Send all data to Kinesis Data Streams → Glue Streaming ETL → Redshift for all queries and storage.

D. Store all data in Amazon OpenSearch Service with index lifecycle management for retention.

**Correct Answer: A**

**Explanation:** This architecture optimizes for each requirement: IoT Core handles 10,000 devices at 5-second intervals (2,000 msg/sec). Firehose delivers to S3 in Parquet for cost-effective 7-year retention with lifecycle policies for tiered storage. Timestream is purpose-built for time-series data with built-in time-based retention (30-day memory store, longer magnetic store). QuickSight natively connects to Timestream for real-time dashboards. Option B—DynamoDB is expensive for time-series at this scale. Option C—Redshift for 7-year raw storage is costly. Option D—OpenSearch is expensive for long-term retention.

---

### Question 25

A retail company needs to implement a product recommendation engine using their data lake. The data lake contains purchase history (500M records), product catalog (1M products), and customer profiles (10M customers). Recommendations must be generated daily and served in real-time.

Which architecture generates and serves recommendations?

A. Use Amazon Personalize with data imported from the data lake. Configure a Personalize dataset group with interactions (purchases), items (products), and users (customers). Train a recommendation model using the USER_PERSONALIZATION recipe. Export recommendations to DynamoDB for real-time serving through API Gateway.

B. Write a custom collaborative filtering algorithm using Glue ETL and store results in S3.

C. Use Amazon SageMaker to train a custom recommendation model on EMR-processed data. Deploy the model on a SageMaker endpoint for real-time inference.

D. Use Redshift ML to train a recommendation model directly in Redshift and create a SQL function for predictions.

**Correct Answer: A**

**Explanation:** Amazon Personalize is a managed recommendation service that handles model training, optimization, and deployment. Importing data from the data lake (purchase history as interactions, products as items, customers as users) into Personalize enables sophisticated recommendation algorithms without ML expertise. The USER_PERSONALIZATION recipe automatically selects the best algorithm. Batch recommendations exported to DynamoDB provide single-digit millisecond serving latency for real-time API responses. Option B (custom algorithm) requires ML expertise and ongoing maintenance. Option C (SageMaker) works but requires custom model development. Option D—Redshift ML doesn't support recommendation algorithms natively.

---

### Question 26

A company needs to implement change data capture (CDC) from an Amazon Aurora MySQL database to their S3 data lake. The CDC must capture inserts, updates, and deletes with minimal impact on the source database. The data in S3 must reflect the current state of each record.

Which pipeline implements CDC with current-state views?

A. Enable Aurora MySQL binary log replication. Use AWS DMS with CDC mode to capture changes and write them to S3 in Parquet format. Use a Glue ETL job with DynamicFrame.mergeDynamicFrame to merge CDC changes into a current-state table, handling inserts, updates, and deletes to maintain a Type 1 slowly changing dimension.

B. Create an Aurora MySQL trigger on each table that writes change events to an SQS queue. Lambda functions process the queue and update S3.

C. Use Aurora's native export to S3 feature to export full table snapshots daily.

D. Configure Aurora to write query logs, then parse the logs to extract DML operations.

**Correct Answer: A**

**Explanation:** DMS CDC mode reads the Aurora MySQL binary log with minimal performance impact (read replicas can be used). CDC records in S3 include the operation type (INSERT, UPDATE, DELETE) and the record data. The Glue ETL job merges these changes into the current-state table—applying updates and deletes to existing records and inserting new ones. This maintains an accurate point-in-time view. Option B (triggers) impacts database performance and requires trigger maintenance per table. Option C (full export) is daily, not real-time CDC. Option D (query logs) is unreliable and doesn't capture all changes.

---

### Question 27

A company builds a data mesh architecture where each business domain owns their data products. The central platform team provides shared infrastructure (S3, Glue, Lake Formation). Each domain team needs to publish data products that other domains can discover, request access to, and consume.

Which architecture implements a data mesh on AWS?

A. Each domain uses their own AWS account. Data products are registered as Glue Data Catalog tables with standardized metadata (descriptions, schemas, SLAs, data quality scores). Lake Formation enables cross-account sharing—domain teams grant access to their data products. Amazon DataZone provides a business data catalog where consumers discover, request, and get governed access to data products across domains.

B. Create a central Redshift data warehouse where all domains load their data products. Consumers query the central warehouse.

C. Use a single AWS account with separate S3 prefixes per domain. All teams share the same Glue Data Catalog.

D. Deploy Apache Kafka as the data sharing mechanism between domains using MSK.

**Correct Answer: A**

**Explanation:** Amazon DataZone implements the data mesh pattern on AWS. It provides a business data catalog where domain teams publish data products with metadata, quality information, and access policies. Consumers discover products, submit access requests, and receive governed access through approval workflows. Lake Formation handles the underlying cross-account permissions. Each domain owns their account and data products, maintaining autonomy while the platform provides shared governance. Option B (central warehouse) is the opposite of data mesh—it centralizes rather than federate. Option C (single account) doesn't provide domain isolation. Option D (Kafka) is for streaming, not a data mesh implementation.

---

### Question 28

A healthcare company needs to de-identify patient data in their data lake before making it available to analysts. The data contains structured (CSV, Parquet) and unstructured (clinical notes in text files) data. PII includes names, dates of birth, Social Security numbers, and medical record numbers.

Which approach provides comprehensive de-identification?

A. Use AWS Glue with a custom transform that calls Amazon Comprehend Medical to detect PHI entities in unstructured text and a Glue sensitive data detection transform for structured data. Replace detected PII with tokens or redact. Store the mapping in a separate encrypted DynamoDB table for re-identification if needed.

B. Write regex patterns in a Glue ETL job to find and replace common PII patterns.

C. Use Amazon Macie to scan and redact PII from all data lake files.

D. Apply S3 Object Lambda to dynamically redact PII when data is accessed instead of transforming stored data.

**Correct Answer: A**

**Explanation:** Comprehend Medical specifically detects PHI (Protected Health Information) entities in clinical text—names, dates, SSNs, medical record numbers, and other HIPAA-relevant entities. For structured data, Glue's sensitive data detection transform identifies PII patterns in CSV/Parquet columns. The combined approach handles both data types. Tokenization with a mapping table allows authorized re-identification while protecting privacy. Option B (regex) misses complex PII patterns and doesn't handle unstructured clinical text well. Option C—Macie detects PII but doesn't transform/redact data. Option D (Object Lambda) adds latency to every access and requires implementing redaction logic.

---

### Question 29

A company uses QuickSight for business intelligence across 1,000 users. They need to embed QuickSight dashboards into their customer-facing web application. Each customer should only see their own data. The web application authenticates users through Cognito.

Which embedding architecture provides secure multi-tenant dashboards?

A. Use QuickSight's anonymous embedding with row-level security. Generate embedding URLs using the GenerateEmbedUrlForAnonymousUser API with session tags that map to the customer ID from the Cognito token. Configure row-level security on the dataset to filter data based on the session tag value.

B. Create a separate QuickSight dashboard per customer and generate unique embedding URLs for each.

C. Use QuickSight's registered user embedding, creating a QuickSight user for each of the 1,000 customers.

D. Generate static dashboard images per customer and serve them from S3.

**Correct Answer: A**

**Explanation:** Anonymous embedding with session tags is designed for customer-facing dashboards at scale. The API generates time-limited embedding URLs with session tags (e.g., customer_id=12345) derived from the Cognito authentication context. Row-level security rules filter the dataset to show only rows matching the session tag value. One dashboard serves all customers with data isolation enforced at the query level. Option B (per-customer dashboards) doesn't scale to 1,000+ customers. Option C (registered users) requires QuickSight Enterprise licenses per user, which is expensive for external users. Option D (static images) loses interactivity and is hard to maintain.

---

### Question 30

A company needs to build an ETL pipeline that extracts data from a third-party REST API, transforms it, and loads it into S3. The API returns paginated JSON responses (100 records per page) and the total dataset is 10 million records. The pipeline runs daily.

Which approach efficiently handles the paginated API ingestion?

A. Use a Glue Python Shell job that handles pagination, making iterative API calls and writing accumulated data to S3 in batches. Use the requests library for API calls and boto3 for S3 writes. Implement error handling and checkpointing for resume capability.

B. Use Amazon AppFlow with a custom connector for the REST API.

C. Create a Lambda function that recursively invokes itself for each page and writes results to S3.

D. Use Step Functions with a Map state that calls Lambda functions in parallel, one per page.

**Correct Answer: A**

**Explanation:** A Glue Python Shell job provides a managed environment for API-based extraction. Python Shell jobs support custom libraries (requests), run for up to 48 hours (sufficient for 100,000 pages), and scale with DPU allocation. Batch writing to S3 (e.g., every 10,000 records) is efficient. Checkpointing (tracking the last successful page in DynamoDB) enables resume on failure. Option B—AppFlow supports specific SaaS connectors, not arbitrary REST APIs without custom development. Option C (recursive Lambda) risks exceeding invocation limits and lacks state management. Option D (Step Functions Map) works but requires knowing the total page count upfront and has step execution limits.

---

### Question 31

A company uses AWS Glue to process data, but Glue jobs frequently fail due to out-of-memory errors when processing skewed data (a few partition keys have 100x more data than others). The jobs are configured with 100 DPUs.

Which approach handles data skew in Glue ETL?

A. Enable Glue auto-scaling, which dynamically adds DPUs when executor memory pressure is detected. Additionally, use Glue's groupFiles option to balance file sizes across partitions, and add a repartition step in the ETL script before the memory-intensive transformation to redistribute data evenly across workers.

B. Increase the DPU count from 100 to 500 to provide more memory per executor.

C. Split the Glue job into multiple jobs, each processing a subset of partition keys.

D. Switch from Glue to EMR for better control over Spark configuration.

**Correct Answer: A**

**Explanation:** Glue auto-scaling dynamically adjusts DPUs based on workload demands, adding capacity during skewed partition processing. The groupFiles option consolidates small files and balances large ones across workers. Repartitioning before heavy operations distributes data evenly across executors, preventing single-executor memory exhaustion. This addresses skew at multiple levels. Option B (more DPUs) adds uniform capacity but doesn't help if skew concentrates data on specific executors. Option C (splitting jobs) is operationally complex. Option D (EMR) provides more control but adds infrastructure management overhead.

---

### Question 32

A company needs to implement a slowly changing dimension (SCD Type 2) in their data lake. The dimension table tracks customer addresses over time—when an address changes, the old record should be marked as inactive with an end date, and a new record is inserted. The data lake uses S3 with Parquet format.

Which approach implements SCD Type 2 in a data lake?

A. Use Apache Iceberg table format with Glue Data Catalog integration. Iceberg supports row-level updates and inserts (MERGE INTO) that can atomically update old records' end dates and insert new records. Use Athena or Spark on Glue to execute MERGE statements. Iceberg maintains time travel capability for auditing.

B. Implement SCD Type 2 by creating a new Parquet file for each change and using a Glue ETL job to periodically compact and reconcile files.

C. Use DynamoDB for the dimension table with versioned items, queried alongside S3 data using Athena's federated query.

D. Store each version as a separate partition in S3 (partitioned by version number) and use Athena to query the latest version.

**Correct Answer: A**

**Explanation:** Apache Iceberg on AWS provides ACID transactions and row-level operations on S3 data. The MERGE INTO statement can match existing records, update end dates on changed records, and insert new versions in a single atomic operation. Iceberg's time travel allows querying historical dimension values at any point in time—essential for SCD Type 2 auditing. Glue Data Catalog integration provides native metadata management. Option B (manual file management) is error-prone and doesn't support atomic updates. Option C (DynamoDB) adds cost and complexity for a dimension table. Option D (version partitioning) doesn't support efficient current-state queries.

---

### Question 33

A company has an Athena query that joins a 10TB fact table with a 500MB dimension table. The query takes 15 minutes because Athena scans the entire fact table for the join. The fact table is partitioned by date but the join key is customer_id.

Which optimization improves this join performance?

A. Use bucketing on the fact table by customer_id. Recreate the fact table with BUCKETED BY (customer_id) INTO 256 BUCKETS using Glue ETL. This allows Athena to read only the matching buckets during the join, dramatically reducing data scanned.

B. Create a materialized view in Athena that pre-computes the join results.

C. Increase the Athena workgroup's concurrent query limit to process the join faster.

D. Load the 500MB dimension table into Athena's memory using a WITH clause common table expression.

**Correct Answer: A**

**Explanation:** Bucketing on the join key (customer_id) physically co-locates records with the same customer_id in the same bucket files. When joining, Athena only needs to read the matching buckets from both tables instead of scanning the entire 10TB fact table. With 256 buckets, each bucket contains approximately 39GB, and a single-customer join reads only that bucket. This is the most effective optimization for join-heavy queries on large tables. Option B—Athena doesn't support traditional materialized views. Option C (concurrency) doesn't affect single-query performance. Option D—CTEs don't load data into memory; they're syntactic sugar.

---

### Question 34

A company is designing a QuickSight dashboard strategy for 5 business units. Each unit needs 20 dashboards. The data engineering team creates the datasets, but each business unit should be able to create and manage their own analyses and dashboards without affecting other units.

Which QuickSight governance model supports this?

A. Create a QuickSight folder structure: shared datasets folder (managed by data engineering with read-only access for business units) and per-unit folders (each unit has full control). Grant each business unit's QuickSight group owner permissions on their folder and viewer permissions on the shared datasets folder. Use QuickSight API to automate folder and permission management.

B. Give each business unit QuickSight admin access and let them manage everything.

C. The data engineering team creates all 100 dashboards and business units submit change requests.

D. Create separate QuickSight accounts per business unit with cross-account dataset sharing.

**Correct Answer: A**

**Explanation:** QuickSight folders provide a governance model that separates concerns: the data engineering team manages shared datasets (read-only to business units), while each business unit has full control over their own folder for analyses and dashboards. This enables self-service analytics within governed boundaries. The QuickSight API automates folder structure provisioning for consistency. Option B grants excessive permissions. Option C creates a bottleneck (the data engineering team becomes a dashboard factory). Option D (separate accounts) adds unnecessary administrative overhead.

---

### Question 35

A company needs to process 1TB of CSV data daily through a complex ETL pipeline with 10 transformation steps. Each step depends on the previous step's output. If any step fails, the pipeline should retry that step up to 3 times before failing. The team needs visibility into each step's status and the ability to rerun from the failed step.

Which orchestration approach BEST manages this pipeline?

A. Use AWS Step Functions with a sequential state machine. Each state invokes a Glue ETL job for one transformation step. Configure retry policies (maxAttempts: 3, exponential backoff) on each state. Use Step Functions' built-in execution history for status visibility and the RedrivExecution API to restart from the failed step.

B. Use Glue Workflows to orchestrate the 10 Glue jobs sequentially with triggers between each job.

C. Use Apache Airflow (MWAA) DAG with task dependencies and retry configurations.

D. Chain the Glue jobs using S3 event notifications—each job's output triggers the next job.

**Correct Answer: A**

**Explanation:** Step Functions provides native retry policies per state, execution history visualization, and the ability to restart from a failed state (redrive). Each Glue job invocation is wrapped in a Task state with customizable retry (3 attempts, exponential backoff). The visual workflow shows real-time status of each step. RedriveExecution restarts from the exact failed step without re-running completed steps. Option B (Glue Workflows) supports basic retry but lacks the granular control and redrive capability. Option C (MWAA) works but adds infrastructure management overhead. Option D (S3 events) doesn't provide retry or restart-from-failure capabilities.

---

### Question 36

A company ingests real-time clickstream data using Kinesis Data Firehose and writes to S3. They need to query this data with Athena, but Firehose creates thousands of small files (5MB each) daily, causing slow query performance. The data must remain queryable within 5 minutes of ingestion.

Which approach optimizes file sizes while maintaining freshness?

A. Configure Kinesis Data Firehose with dynamic partitioning enabled and a 128MB buffer size with a 300-second buffer interval. Use S3 event notifications to trigger a Lambda function that compacts small files into larger Parquet files using Athena CTAS (CREATE TABLE AS SELECT) queries on a scheduled basis.

B. Increase the Firehose buffer size to 128MB and buffer interval to 900 seconds (15 minutes) to create fewer, larger files.

C. Use a Glue ETL job scheduled every hour to compact small files into larger Parquet files in a separate "optimized" S3 prefix. Point Athena queries at the optimized prefix.

D. Configure Firehose to write to a staging S3 location. Use Glue Streaming ETL to read from the staging location and write compacted files to the query location.

**Correct Answer: A**

**Explanation:** Increasing the Firehose buffer to 128MB/300 seconds creates larger initial files, reducing the small file problem at ingestion. Dynamic partitioning writes files to the correct partition paths automatically. Periodic compaction (via Lambda-triggered CTAS) consolidates remaining small files into optimally sized Parquet files (128-256MB) for Athena performance. The 5-minute freshness is maintained because the raw files are immediately queryable. Option B (15-minute buffer) violates the 5-minute freshness requirement. Option C (hourly compaction) creates a 1-hour staleness for the optimized view. Option D adds streaming ETL complexity.

---

### Question 37

A company uses Amazon Redshift for data warehousing and wants to implement a data vault modeling approach for their enterprise data model. The data vault consists of Hubs (business keys), Links (relationships), and Satellites (descriptive attributes with history).

Which Redshift features optimize data vault performance?

A. Use Redshift's distribution styles strategically: EVEN distribution for Hub tables (broadly joined), KEY distribution on Links using the hub hash key for co-located joins, and AUTO distribution for Satellite tables. Use sort keys on the load timestamp for Satellites to optimize point-in-time queries. Use materialized views for common business vault transformations.

B. Store all data vault tables in a single schema with no distribution or sort key optimization.

C. Use Redshift Spectrum to keep all data vault tables in S3 for flexibility.

D. Use temporary tables for all hub and link resolution, materializing only the final business views.

**Correct Answer: A**

**Explanation:** Strategic distribution in Redshift optimizes data vault patterns: KEY distribution on Links ensures Hub-Link joins are co-located on the same nodes (avoiding shuffle). Sort keys on Satellite load timestamps optimize the frequent point-in-time query pattern (finding the most recent satellite record for a given hub key at a specific time). Materialized views pre-compute common business vault transformations (e.g., joining Hubs + Links + Satellites into business objects), avoiding expensive query-time joins. Option B wastes Redshift's distribution optimization. Option C (Spectrum) is too slow for frequent star-join patterns in data vaults. Option D (temp tables) adds ETL complexity.

---

### Question 38

A company has a data lake with 100TB of data. They want to enable full-text search across all documents and structured data for compliance and investigation purposes. Searches must return results within seconds and support complex Boolean queries.

Which search architecture integrates with the data lake?

A. Deploy Amazon OpenSearch Service and ingest data from S3 using a Lambda function triggered by S3 events. Index documents and structured data in OpenSearch. Use OpenSearch Dashboards for search interface. For large historical data, use a Glue ETL job to batch-index existing data.

B. Use Athena's LIKE queries for text search across all tables.

C. Enable Amazon Kendra on the data lake S3 bucket for intelligent document search.

D. Use Amazon CloudSearch for the full-text search requirement.

**Correct Answer: A**

**Explanation:** Amazon OpenSearch Service provides full-text search with complex Boolean queries, fuzzy matching, and sub-second response times. Lambda triggered by S3 events provides near-real-time indexing of new data. Glue ETL handles the initial 100TB bulk indexing. OpenSearch supports structured query DSL for complex Boolean expressions and aggregations needed for compliance investigations. Option B—Athena LIKE queries perform full table scans and are very slow for text search on 100TB. Option C (Kendra) is for enterprise search with NLP, not complex Boolean compliance queries. Option D (CloudSearch) is limited in scale and feature set compared to OpenSearch.

---

### Question 39

A financial company needs to implement data lineage tracking for their data lake. They must be able to trace how any piece of data in a dashboard was derived—from the raw source through all transformations to the final visualization. This is required for regulatory auditing.

Which approach provides comprehensive data lineage?

A. Use AWS Glue Data Catalog's built-in lineage feature combined with Amazon DataZone for business-level lineage. Glue ETL jobs automatically record input/output relationships in the Data Catalog. DataZone provides a visual lineage graph showing data flow from source to dashboard. Supplement with QuickSight's data source metadata for dashboard-level lineage.

B. Create a custom lineage tracking system using a DynamoDB table that records source-target relationships for each ETL job.

C. Use Apache Atlas deployed on EMR for data lineage management.

D. Enable CloudTrail logging on all data-related API calls and reconstruct lineage from the audit logs.

**Correct Answer: A**

**Explanation:** Glue Data Catalog captures technical lineage automatically when Glue ETL jobs run—recording which tables/partitions were read and written. DataZone provides business-level lineage with visual graphs showing data flow across domains and transformations. This combination provides end-to-end lineage from raw source through ETL transformations to curated tables. QuickSight metadata links dashboards back to their data sources. Option B is custom and requires manual maintenance. Option C (Apache Atlas) requires EMR cluster management. Option D (CloudTrail) records API calls but doesn't capture data transformation lineage.

---

### Question 40

A company has 50 analysts running Athena queries. During peak hours (9-11 AM), query queuing causes 5-minute waits. Off-peak queries run instantly. The company needs consistent query performance during peaks without over-provisioning for off-peak.

Which Athena configuration addresses this?

A. Use Athena provisioned capacity with a reservation for peak hours. Create a capacity reservation that provides dedicated DPUs during 9-11 AM using a scheduled scaling approach. Assign the reservation to the analytics workgroup. Off-peak queries use on-demand capacity.

B. Split analysts into multiple workgroups with per-workgroup query concurrency limits to prevent queue overload.

C. Pre-compute common query results into materialized tables during off-peak hours.

D. Redirect peak-hour queries to Redshift Serverless for additional capacity.

**Correct Answer: A**

**Explanation:** Athena provisioned capacity provides dedicated compute resources that eliminate query queuing. A capacity reservation during peak hours (9-11 AM) ensures consistent performance for the analytics workgroup. Off-peak, queries use on-demand capacity, avoiding constant provisioning costs. Scheduled capacity changes align with the predictable peak pattern. Option B (workgroup splitting) distributes the problem but doesn't add capacity. Option C (pre-computation) helps for repeated queries but doesn't address ad-hoc queries. Option D (Redshift) adds architectural complexity.

---

### Question 41

A company needs to build a data quality dashboard that monitors the health of their data lake. The dashboard should show: freshness (when was data last updated), completeness (percentage of null values), uniqueness (duplicate record rates), and accuracy (values within expected ranges). Metrics should be tracked over time.

Which architecture provides automated data quality monitoring?

A. Implement AWS Glue Data Quality ruleset evaluations scheduled on each dataset. Export evaluation results to S3 in JSON format. Use a Glue ETL job to aggregate quality metrics into a DynamoDB table. Connect QuickSight to DynamoDB (via Athena federated query) for the data quality dashboard with historical trend visualizations.

B. Write custom SQL queries in Athena for each quality metric and schedule them with Lambda. Store results in DynamoDB.

C. Use Amazon Macie to scan all datasets for data quality issues.

D. Deploy Great Expectations on an EC2 instance with a custom dashboard.

**Correct Answer: A**

**Explanation:** Glue Data Quality provides built-in rules for freshness (IsComplete, ColumnValues), completeness (IsComplete), uniqueness (IsUnique), and accuracy (ColumnValues, ColumnCorrelation). Scheduled evaluations run automatically after ETL jobs. Results include pass/fail per rule with detailed metrics. Storing results in DynamoDB enables historical trending, and QuickSight dashboards provide executive visibility into data lake health. Option B (custom SQL) requires maintaining all quality check logic manually. Option C—Macie detects sensitive data, not general data quality. Option D requires infrastructure management.

---

### Question 42

A company has a data lake on S3 with data managed using the Apache Hudi table format. They discover that deleting records (for GDPR compliance) is extremely slow—each delete operation rewrites entire Parquet files. The table has 10TB of data with 100 partitions.

Which optimization improves delete performance in Hudi?

A. Switch from Hudi's Copy-on-Write (COW) table type to Merge-on-Read (MOR). MOR writes deletes as log files that are merged asynchronously during compaction, making individual delete operations near-instantaneous. Schedule asynchronous compaction during off-peak hours using a Glue ETL job.

B. Increase the Glue job DPU count to perform deletes faster.

C. Repartition the data into smaller partitions so less data is rewritten per delete.

D. Switch from Hudi to plain Parquet and implement deletes by rewriting only the affected files using Athena CTAS.

**Correct Answer: A**

**Explanation:** Hudi's Copy-on-Write rewrites entire Parquet files for each delete, which is slow for large files. Merge-on-Read (MOR) appends delete markers as log files—deletes are instantaneous because no data rewriting occurs. The actual file compaction (merging logs with base files) happens asynchronously during scheduled compaction, which can be offloaded to off-peak hours. Read queries merge the base files with log files on-the-fly. Option B (more DPUs) speeds up the rewrite but doesn't change the fundamental approach. Option C (smaller partitions) helps marginally. Option D (plain Parquet) loses ACID guarantees and upsert capabilities.

---

### Question 43

A company has been running a data lake for 2 years. The Glue Data Catalog has grown to 2,000 tables, but analysis reveals that 60% of tables are unused (no queries in 6 months). The unused tables still incur crawler costs and confuse analysts who search the catalog. The team needs to clean up the catalog without accidentally removing tables that are still needed.

Which approach safely identifies and removes unused tables?

A. Enable Athena query logging and Glue job audit logs in CloudTrail. Query CloudTrail Lake to identify all tables referenced in Athena queries and Glue jobs over the last 6 months. Cross-reference with the Glue Data Catalog table list to identify unused tables. Mark unused tables with an LF-Tag (status=deprecated) and notify table owners. After a 30-day grace period, archive table definitions to S3 and delete from the catalog.

B. Delete all tables that haven't been updated by crawlers in 6 months.

C. Use the Glue Data Catalog's built-in table usage analytics to identify unused tables.

D. Ask each team to manually identify which tables they use and delete the rest.

**Correct Answer: A**

**Explanation:** CloudTrail captures all Athena query executions and Glue job runs, providing a definitive record of table usage. Querying CloudTrail Lake identifies which tables were actually referenced. The deprecation period (LF-Tag + 30-day grace period) prevents accidental removal of tables used by ad-hoc processes or infrequent queries. Archiving table definitions before deletion enables recovery if needed. Option B assumes that crawler activity indicates usage—unused tables might still be crawled. Option C doesn't exist as a native feature. Option D is unreliable and time-consuming.

---

### Question 44

A company's Glue ETL jobs process data in Apache Parquet format. Job runtime has increased from 30 minutes to 3 hours over the past year as data volume grew from 100GB to 2TB daily. The jobs are configured with 50 DPUs (G.1X worker type).

Which combination of optimizations reduces job runtime? (Choose TWO.)

A. Switch from G.1X to G.2X worker type, which provides double the memory and CPU per worker. Memory-intensive Parquet operations benefit from larger worker sizes.

B. Enable Glue auto-scaling, which dynamically adjusts the number of workers based on the workload. Auto-scaling adds workers during heavy transformations and removes them during light stages.

C. Reduce the DPU count to 25 to decrease parallelism overhead.

D. Switch from Parquet to CSV format for intermediate processing to reduce serialization overhead.

E. Partition the input data into 24 hourly files instead of daily files.

**Correct Answer: A, B**

**Explanation:** Larger worker types (A) provide more memory per executor, which is critical for Parquet processing (columnar format requires significant memory for compression/decompression). With 2TB daily, G.2X workers prevent out-of-memory executor failures and reduce spill-to-disk, improving performance. Auto-scaling (B) dynamically allocates workers—more during shuffle-heavy operations (joins, aggregations) and fewer during simple transformations. This optimizes both performance and cost. Option C reduces parallelism, slowing the job. Option D—CSV is less efficient than Parquet for analytical processing. Option E doesn't address the processing efficiency.

---

### Question 45

A company uses Redshift for analytics. Query performance has degraded over time. The EXPLAIN plan shows that most queries perform nested loop joins instead of hash joins, and large tables have significant unsorted data.

Which Redshift maintenance operations improve performance? (Choose TWO.)

A. Run VACUUM on tables with unsorted rows to re-sort data according to the sort key. Vacuum reclaims space from deleted rows and restores the sort order, enabling zone map-based query optimization.

B. Run ANALYZE to update table statistics. Outdated statistics cause the query optimizer to choose suboptimal execution plans (like nested loop joins instead of hash joins).

C. Increase the cluster size by adding more nodes.

D. Drop and recreate all tables with new distribution keys.

E. Enable auto-vacuum and disable manual vacuum operations.

**Correct Answer: A, B**

**Explanation:** VACUUM (A) re-sorts data within sort key order, enabling Redshift's zone maps to efficiently skip blocks during scans. Unsorted data forces full block scans. ANALYZE (B) updates the statistics that the query planner uses to choose join strategies. Without accurate statistics, the planner may choose nested loop joins (O(n²)) instead of hash joins (O(n)) because it misjudges table sizes. Together, these maintenance operations typically restore original query performance. Option C (more nodes) is expensive and doesn't address the root cause. Option D is extreme and causes downtime. Option E—auto-vacuum doesn't replace the need for initial VACUUM/ANALYZE.

---

### Question 46

A company runs Athena queries against a partitioned S3 data lake. A common query pattern filters by date (partition key) and customer_id (non-partition column). Even with partition pruning on date, queries still scan all data within the selected partitions because customer_id requires a full scan within each partition.

Which optimization reduces intra-partition scanning for customer_id filters?

A. Use Apache Iceberg table format with the data sorted by customer_id within each partition. Iceberg maintains column statistics (min/max) per data file in its metadata. Athena uses these statistics to skip files that don't contain the target customer_id, dramatically reducing data scanned.

B. Add customer_id as a second partition key to create more granular partitions.

C. Create a separate index table in DynamoDB that maps customer_id to S3 file locations.

D. Use Athena's TABLESAMPLE feature to scan only a sample of data per partition.

**Correct Answer: A**

**Explanation:** Iceberg maintains detailed column statistics (min, max, null count) per data file in its metadata layer. When data is sorted by customer_id within partitions, files contain non-overlapping ranges of customer_id values. Athena reads Iceberg metadata to identify which files could contain the target customer_id and skips all others. For a targeted customer_id query, this can reduce data scanned from 100% to <1% of the partition. Option B (additional partition) creates too many small partitions with a high-cardinality column. Option C is a custom solution requiring maintenance. Option D (TABLESAMPLE) returns incomplete results.

---

### Question 47

A company uses AWS Glue crawlers to maintain their data catalog. They have 500 crawlers running on various schedules. Crawler runs are taking longer and some fail due to memory limitations. Monthly Glue crawler costs are $2,000.

Which approach reduces crawler costs and improves reliability?

A. Replace crawlers with Glue schema inference during ETL jobs. When Glue ETL jobs process data, they can infer schemas and automatically create/update Data Catalog tables. For new data sources, use AWS Glue CreateTable API calls with schema definitions from the data source metadata. This eliminates separate crawler runs.

B. Increase the crawler memory allocation by configuring crawler properties.

C. Reduce crawler frequency from every hour to once daily for all crawlers.

D. Consolidate all 500 crawlers into a single crawler that targets all S3 paths.

**Correct Answer: A**

**Explanation:** Embedding schema management into ETL jobs eliminates separate crawler runs entirely. Glue ETL jobs can: infer schema from data, create/update Glue Data Catalog tables via API, and add partitions as they process data. For known schemas (most production data), using CreateTable/UpdateTable API calls with predefined schemas is more reliable than crawler inference. This saves 100% of crawler costs ($2,000/month). Option B—crawler memory isn't directly configurable. Option C reduces frequency but may miss schema changes. Option D creates a single point of failure with increased memory pressure.

---

### Question 48

A company's data lake uses S3 with Parquet format. They notice that query performance varies significantly—some queries on the same table take 2 seconds while others take 30 seconds. Investigation reveals that Parquet files range from 1MB to 2GB in size due to varying input batch sizes.

Which approach normalizes file sizes for consistent query performance?

A. Implement an S3 data compaction pipeline using a scheduled Glue ETL job that identifies partitions with suboptimal file sizes (too small or too large). The job reads all files in a partition, repartitions the data into target file sizes (128-256MB), and writes back to the same partition using Iceberg's rewrite_data_files operation.

B. Configure Firehose to always write exactly 128MB files.

C. Set Spark's maxRecordsPerFile parameter during initial writes to control file sizes.

D. Use S3 batch operations to split large files and merge small files.

**Correct Answer: A**

**Explanation:** A compaction pipeline normalizes file sizes across the data lake. The Glue ETL job reads suboptimal partitions and rewrites them with target file sizes (128-256MB), which is the optimal range for Athena/Spark. Using Iceberg's rewrite_data_files operation handles this atomically without affecting concurrent reads. Regular scheduling (daily or weekly) maintains optimal file sizes as new data arrives. Option B—Firehose can buffer to 128MB but doesn't control the exact output size across all ingestion paths. Option C only controls initial writes, not ongoing data from multiple sources. Option D—S3 batch operations don't support Parquet file splitting/merging.

---

### Question 49

A company has migrated from Redshift to Athena for most queries, but certain complex queries with multiple window functions and CTEs perform poorly on Athena. The queries involve heavy reshuffling of 50GB datasets.

Which approach improves these specific complex queries without maintaining a Redshift cluster?

A. Use Amazon Redshift Serverless for the complex analytical queries. Redshift Serverless spins up compute on-demand, executes the query against data in S3 (via Spectrum) or loaded from S3, and shuts down after the query completes. This provides Redshift's optimized query engine without cluster management.

B. Rewrite the queries to avoid window functions and CTEs, using subqueries instead.

C. Pre-compute the results using a Glue ETL job that mimics the query logic.

D. Use EMR with Spark SQL for the complex queries.

**Correct Answer: A**

**Explanation:** Redshift Serverless provides on-demand access to Redshift's distributed query engine—optimized for complex window functions, CTEs, and large reshuffles. It automatically provisions compute for the query and bills by RPU-hours consumed. Redshift's MPP architecture handles 50GB reshuffles more efficiently than Athena's serverless engine for this query pattern. No cluster management is needed. Option B (rewriting queries) may not be possible and often produces worse-performing alternatives. Option C (Glue pre-computation) works for known queries but not ad-hoc analytics. Option D (EMR Spark) requires cluster management.

---

### Question 50

A company has a Redshift cluster with 200 users. Some users run expensive queries that consume cluster resources and impact other users. The DBA needs to prevent individual queries from consuming more than 10% of cluster resources while allowing important ETL queries to use up to 50%.

Which Redshift feature provides this control?

A. Configure Redshift Automatic Workload Management with query monitoring rules (QMR). Create rules that abort or log queries exceeding resource thresholds (CPU time, disk I/O, rows returned). Define WLM queues with different concurrency and memory allocations: an ETL queue with 50% memory allocation and a user query queue with 10% per-query memory limit.

B. Use Redshift concurrency scaling to prevent resource contention between users.

C. Set a query timeout at the cluster level to prevent long-running queries.

D. Use Redshift Spectrum for user queries so they don't consume cluster resources.

**Correct Answer: A**

**Explanation:** WLM queues with query monitoring rules provide granular resource control. The ETL queue gets 50% of cluster memory with high priority, while the user query queue limits individual queries to 10% of cluster memory. QMR rules can automatically abort queries that exceed thresholds (CPU usage, execution time, rows scanned), preventing runaway queries from impacting the cluster. This provides differentiated resource allocation by workload type. Option B (concurrency scaling) adds capacity but doesn't limit individual query resource consumption. Option C (timeout) only limits time, not resource usage. Option D offloads to S3 but doesn't control resource allocation within the cluster.

---

### Question 51

A company uses QuickSight SPICE datasets with daily refreshes. Analysts complain that the dashboard data is stale by end-of-day because the refresh happens at midnight. The underlying data in S3 is updated every hour.

Which approach provides fresher data while maintaining SPICE performance?

A. Configure SPICE incremental refresh to run hourly. Incremental refresh adds only new data since the last refresh, making each refresh fast. Set the SPICE dataset to use the incremental refresh window based on a timestamp column. Full refresh runs weekly to reconcile any gaps.

B. Switch from SPICE to direct query mode for all dashboards.

C. Trigger SPICE refresh via the QuickSight API (CreateIngestion) from a Lambda function that runs after each hourly data update.

D. Create two datasets: a SPICE dataset for historical data and a direct query dataset for today's data. Union them in the analysis.

**Correct Answer: C**

**Explanation:** Triggering SPICE refresh via the API after each hourly data update ensures the dashboard reflects data that's at most 1 hour old. The Lambda function detects when new data lands in S3 (via S3 event or Glue job completion) and calls CreateIngestion to refresh the SPICE dataset. This maintains SPICE's fast query performance while providing hourly freshness. Option A—SPICE incremental refresh is available but not all dataset types support it smoothly. Option B (direct query) loses SPICE's sub-second performance. Option D adds complexity with the union approach and still requires managing two data sources.

---

### Question 52

A company uses Glue ETL to process data from multiple sources. Different sources have different schema evolution patterns—some add new columns, some rename columns, and some change data types. The Glue jobs break when schemas change.

Which approach handles schema evolution gracefully?

A. Use Glue Schema Registry to version schemas and validate compatibility. Configure Glue ETL jobs to use schema evolution strategies: ADD_NEW_COLUMNS for sources that add columns, and CAST_TO_TYPE for type changes. Use the Glue DynamicFrame's resolveChoice method to handle ambiguous types. Write to Iceberg tables that natively support schema evolution (add columns, rename, type widening).

B. Lock schemas by configuring Glue crawlers to not update existing table schemas.

C. Write custom validation code at the start of each ETL job that checks and handles schema differences.

D. Use Athena's schema-on-read capability to handle schema evolution without ETL changes.

**Correct Answer: A**

**Explanation:** Glue Schema Registry provides centralized schema versioning and compatibility checking (BACKWARD, FORWARD, FULL). ETL jobs can handle schema evolution programmatically: ADD_NEW_COLUMNS adds new fields to existing tables, resolveChoice handles ambiguous types from schema changes. Writing to Iceberg tables provides native schema evolution support—columns can be added, renamed, or have types widened without rewriting existing data. Option B (locking schemas) breaks when sources legitimately evolve. Option C (custom code) requires per-job maintenance. Option D (Athena schema-on-read) can read multiple schemas but doesn't transform or standardize data.

---

### Question 53

A company's data lake has grown to 500TB. They discovered that 30% of the data is redundant—identical datasets loaded multiple times due to ETL job failures and reruns. This wastes storage and confuses analysts with duplicate query results.

Which approach detects and removes duplicate data?

A. Implement data deduplication at the table level using Apache Iceberg's MERGE INTO statement. For each table, define the primary key columns and run a Glue ETL job that performs MERGE INTO to keep only the latest version of each record. For cross-table deduplication, use AWS Glue FindMatches ML transform to identify similar datasets and consolidate them.

B. Use S3 Intelligent-Tiering to automatically remove duplicate objects.

C. Compare file checksums across the data lake and delete duplicate files.

D. Run Athena DISTINCT queries to identify and remove duplicates.

**Correct Answer: A**

**Explanation:** Iceberg's MERGE INTO performs efficient deduplication at the record level—matching records by primary key and keeping the latest version. This handles the common case of ETL re-runs creating duplicate records. For cross-table deduplication (identifying entire datasets that are duplicates), Glue FindMatches uses ML to detect similar records even when they aren't exact matches. Together, these address both record-level and dataset-level duplication. Option B—Intelligent-Tiering doesn't detect or remove duplicates. Option C (checksums) only finds exact file duplicates, missing logical duplicates. Option D (DISTINCT queries) identifies duplicates but doesn't remove them from the underlying data.

---

### Question 54

A company has an on-premises Oracle data warehouse with 50TB of data and 200 ETL jobs running on Informatica. They want to migrate to AWS analytics services. The migration must be phased to minimize risk.

Which migration approach provides a phased transition?

A. Phase 1: Use AWS SCT to convert the Oracle schema to Redshift DDL and Informatica ETL to Glue ETL scripts. Use DMS to migrate the 50TB of data to Redshift. Phase 2: Run Oracle and Redshift in parallel, comparing query results for validation. Phase 3: Migrate reporting tools (e.g., to QuickSight). Phase 4: Decommission Oracle and Informatica after a soak period.

B. Migrate everything simultaneously—schema, data, ETL, and reporting—in a single weekend cutover.

C. First migrate only the data to S3, then rebuild ETL in Glue, then set up Redshift, and finally migrate reporting.

D. Use Amazon RDS for Oracle as an interim step, then migrate from RDS to Redshift.

**Correct Answer: A**

**Explanation:** The phased approach minimizes risk at each stage: SCT converts schema and ETL (Phase 1), DMS migrates data while both systems run (Phase 2 parallel validation ensures data accuracy), reporting migration follows (Phase 3), and Oracle is decommissioned only after thorough validation (Phase 4). This allows rollback at any phase. Option B (big-bang) is high risk for a 50TB warehouse with 200 ETL jobs. Option C doesn't leverage DMS for data migration and doesn't include parallel validation. Option D adds an unnecessary intermediate step that doesn't reduce migration complexity.

---

### Question 55

A company uses Teradata as their data warehouse and wants to migrate to Amazon Redshift. The Teradata database uses specific features: BTEQ scripts for data loading, Teradata-specific SQL functions, and FastExport for data extraction.

Which tools facilitate this migration?

A. Use AWS Schema Conversion Tool (SCT) to convert Teradata SQL and BTEQ scripts to Redshift SQL and Glue ETL scripts. Use SCT data extraction agents to extract data from Teradata in parallel and upload to S3. Use the Redshift COPY command to load data from S3 into Redshift tables.

B. Export data from Teradata using FastExport to flat files, manually convert SQL, and load into Redshift using the INSERT command.

C. Use AWS DMS to stream data directly from Teradata to Redshift with automatic schema conversion.

D. Deploy Amazon EMR and use Sqoop to extract data from Teradata and load into Redshift.

**Correct Answer: A**

**Explanation:** AWS SCT specifically supports Teradata-to-Redshift migration. It converts Teradata SQL syntax, BTEQ scripts, and stored procedures to Redshift equivalents and Glue ETL scripts. SCT data extraction agents perform parallel extraction from Teradata (faster than FastExport for large datasets), uploading directly to S3. COPY from S3 to Redshift is the most efficient loading method. Option B (manual conversion) is error-prone and labor-intensive. Option C—DMS supports Teradata as a source but doesn't convert Teradata-specific SQL or BTEQ scripts. Option D (Sqoop) requires EMR management and doesn't handle SQL conversion.

---

### Question 56

A company has a Hadoop-based data lake with data stored in HDFS across a 50-node EMR cluster. They want to migrate to an S3-based data lake to reduce costs and improve elasticity. The data includes Hive tables, Spark jobs, and Presto queries.

Which migration strategy preserves existing workloads?

A. Use S3DistCp to migrate data from HDFS to S3. Point the Hive metastore to the Glue Data Catalog (using the Glue-Hive compatibility connector). Modify Spark jobs to read/write from S3 instead of HDFS. Configure Presto/Trino to query the Glue Data Catalog for table definitions. Run compute on EMR clusters that start on-demand and terminate after jobs complete.

B. Use AWS DataSync to copy data from HDFS to S3, then rebuild all Hive tables and Spark jobs from scratch.

C. Use Amazon S3 as the HDFS-compatible file system using S3A connector without changing any queries or jobs.

D. Migrate directly from HDFS to Amazon Redshift for all analytics.

**Correct Answer: A**

**Explanation:** S3DistCp efficiently copies data from HDFS to S3 in parallel. The Glue Data Catalog serves as a drop-in replacement for the Hive metastore, so Hive queries work with minimal changes. Spark jobs need path changes from hdfs:// to s3://, but logic remains the same. Presto/Trino with Glue Catalog connector provides the same query interface. On-demand EMR clusters (rather than 24/7) reduce compute costs. Option B (DataSync) works for transfer but "rebuild from scratch" is unnecessary. Option C—S3A connector works but performance and consistency differ from HDFS. Option D ignores existing Hive/Spark/Presto workloads.

---

### Question 57

A company has a Microsoft SQL Server Analysis Services (SSAS) cube-based reporting system. They want to migrate to AWS analytics services. The cubes provide multi-dimensional analysis (OLAP) for business users who rely on pivot table-style exploration.

Which AWS service combination replaces SSAS functionality?

A. Migrate the underlying data to Redshift. Use Amazon QuickSight with SPICE for multi-dimensional analysis. QuickSight provides pivot table visualizations, drill-down/drill-up, and calculated fields that replicate SSAS cube browsing experience. For complex measures, use QuickSight calculated fields and custom SQL datasets.

B. Deploy SSAS on EC2 instances to maintain exact compatibility.

C. Use Amazon Athena with SQL queries to replace cube-based analysis.

D. Deploy Apache Kylin on EMR for OLAP cube functionality.

**Correct Answer: A**

**Explanation:** Redshift provides the analytical database backend replacing SQL Server's data warehouse. QuickSight with SPICE replaces SSAS cube browsing—it supports pivot tables, hierarchical drill-down, multiple dimensions, and calculated measures. SPICE's in-memory engine provides the same fast exploration experience as SSAS cubes. Calculated fields and custom SQL datasets handle complex measure definitions. This is fully managed, eliminating SSAS server maintenance. Option B (SSAS on EC2) is lift-and-shift without modernization benefits. Option C (Athena) doesn't provide the interactive cube-browsing experience. Option D (Apache Kylin) requires EMR cluster management.

---

### Question 58

A company uses AWS Glue to process data from Amazon Kinesis Data Streams. The streaming ETL job must process records within 10 seconds of arrival, enrich records by looking up reference data in DynamoDB, and write results to S3 in Parquet format.

Which Glue configuration optimizes this streaming pipeline?

A. Use a Glue Streaming ETL job with a micro-batch window of 10 seconds. Use Glue DynamicFrame's merge operation to join streaming data with reference data from a DynamoDB DynamicFrame read. Configure the output to write Parquet files to S3 with checkpointing enabled for exactly-once processing.

B. Use a standard Glue ETL job triggered every 10 seconds by CloudWatch Events.

C. Use Lambda to process Kinesis records and write to S3.

D. Use Kinesis Data Firehose with a Lambda transformation for DynamoDB lookups.

**Correct Answer: A**

**Explanation:** Glue Streaming ETL natively reads from Kinesis Data Streams using micro-batches. A 10-second window groups records for efficient processing. DynamoDB reference data is read as a DynamicFrame and joined with the streaming data. Checkpointing ensures exactly-once processing semantics. The output writes optimally-sized Parquet files to S3. Option B (triggered batch jobs) has startup overhead that prevents 10-second SLA. Option C (Lambda) works but can't efficiently write optimized Parquet files or handle complex joins. Option D (Firehose) doesn't support DynamoDB enrichment natively.

---

### Question 59

A company is migrating from a SAS-based analytics platform to AWS. Their SAS programs include data preparation, statistical modeling, and report generation. Analysts are familiar with SAS programming but not Python or SQL.

Which migration path minimizes analyst retraining?

A. Migrate data preparation to AWS Glue (converted from SAS using SCT or manual rewrite). Train analysts on Amazon SageMaker Canvas for no-code/low-code ML modeling. Use QuickSight for report generation. Provide a phased training program that introduces AWS tools alongside familiar concepts.

B. Deploy SAS on EC2 instances to maintain the existing workflow without changes.

C. Convert all SAS programs to Python PySpark scripts running on Glue.

D. Replace SAS with R Studio on SageMaker for statistical analysis and retrain analysts in R.

**Correct Answer: A**

**Explanation:** SageMaker Canvas provides no-code ML that business analysts can use without programming—similar to SAS's point-and-click interface for statistical modeling. QuickSight replaces SAS report generation with visual dashboards. Data preparation moves to Glue (possibly requiring some retraining). A phased approach introduces new tools gradually. Option B (SAS on EC2) is lift-and-shift without modernization benefits and maintains SAS licensing costs. Option C (PySpark conversion) requires significant retraining. Option D (R Studio) requires learning a new programming language.

---

### Question 60

A company needs to migrate their Informatica PowerCenter ETL jobs to AWS Glue. They have 500 Informatica mappings with complex transformations including lookups, aggregations, SCD handling, and data quality checks.

Which approach accelerates the migration?

A. Use AWS Glue Studio's visual ETL editor to recreate the most common transformation patterns (lookups, aggregations, joins). For complex SCD handling, use Glue's code editor with PySpark. Prioritize migration by categorizing jobs into simple (visual ETL), medium (PySpark), and complex (custom development). Migrate in waves, starting with simple jobs.

B. Use AWS SCT to automatically convert all Informatica mappings to Glue scripts.

C. Deploy Informatica on EC2 to maintain existing jobs while gradually migrating to Glue.

D. Rebuild all 500 jobs from scratch in Glue without referencing Informatica mappings.

**Correct Answer: A**

**Explanation:** Glue Studio's visual ETL editor handles common transformation patterns (80% of typical ETL jobs) without code. Categorizing 500 jobs by complexity enables a phased migration—simple jobs migrate quickly via visual ETL, medium jobs use PySpark templates, and complex jobs get custom development attention. This accelerates migration by focusing effort where it's needed. Option B—SCT doesn't support Informatica-to-Glue conversion. Option C (Informatica on EC2) maintains licensing costs and delays migration. Option D (rebuild from scratch) ignores existing logic and is error-prone.

---

### Question 61

A company has an on-premises Elasticsearch cluster used for log analytics and full-text search on data lake content. They want to migrate to AWS while maintaining the search functionality and integrating with their S3 data lake.

Which migration provides the BEST integration?

A. Migrate to Amazon OpenSearch Service. Use a snapshot-and-restore approach: create an Elasticsearch snapshot from the on-premises cluster, store it in S3, and restore it to an OpenSearch domain. Configure S3 data ingestion using Lambda functions triggered by S3 events to index new data lake content. Use OpenSearch's S3-based indexing for cost-effective warm storage.

B. Deploy a self-managed Elasticsearch cluster on EC2 with the same configuration as on-premises.

C. Replace Elasticsearch with Amazon Athena for all search queries.

D. Use Amazon Kendra instead of OpenSearch for the search functionality.

**Correct Answer: A**

**Explanation:** OpenSearch Service is the managed successor to Elasticsearch on AWS. Snapshot-restore migrates existing data without re-indexing. Lambda-triggered indexing keeps the search index synchronized with new data lake content in S3. OpenSearch's UltraWarm and cold storage tiers (backed by S3) reduce costs for older data while maintaining searchability. This preserves existing Elasticsearch queries and dashboards. Option B (self-managed EC2) adds operational overhead. Option C—Athena can't replace full-text search with scoring, fuzzy matching, and aggregations. Option D (Kendra) is for enterprise search with NLP, not log analytics.

---

### Question 62

A company is migrating a Tableau Server deployment to Amazon QuickSight. They have 200 Tableau workbooks with complex calculations, parameters, and data blending from multiple sources. Business users rely heavily on Tableau's drag-and-drop analysis.

Which migration approach minimizes disruption?

A. Inventory all 200 workbooks, categorizing by complexity and user base. Migrate data sources first—connect QuickSight to the same databases and create SPICE datasets. Recreate the most-used dashboards (top 20%) in QuickSight first, using calculated fields to replicate Tableau calculations. Train power users on QuickSight's visual capabilities. Migrate remaining dashboards in waves based on priority.

B. Convert all Tableau workbooks to QuickSight using an automated conversion tool.

C. Run Tableau and QuickSight in parallel permanently, allowing users to choose their preferred tool.

D. Export all Tableau dashboards as PDFs and publish them as static content while rebuilding in QuickSight.

**Correct Answer: A**

**Explanation:** A phased, priority-based migration minimizes disruption. Starting with data source migration ensures QuickSight can access the same data. Focusing on the top 20% of dashboards first provides maximum user impact early. Calculated fields in QuickSight replicate most Tableau calculations. Training power users creates internal champions who help the broader migration. Wave-based dashboard migration allows learning and refinement. Option B—no automated Tableau-to-QuickSight conversion tool exists. Option C (permanent parallel) doubles licensing costs. Option D (PDFs) loses all interactivity.

---

### Question 63

A company runs Athena queries costing $12,000/month. Analysis shows that 70% of queries scan the same 20 tables, and 40% of those queries use identical WHERE clauses. The remaining queries are ad-hoc explorations.

Which combination of optimizations provides the GREATEST cost reduction? (Choose TWO.)

A. Enable Athena query result reuse for the workgroup. Identical queries within the TTL window return cached results without scanning data. Configure a 1-hour TTL matching the data refresh frequency.

B. Create pre-aggregated summary tables using scheduled Glue ETL jobs for the 20 most-queried tables. Redirect common queries to the smaller summary tables.

C. Purchase Athena provisioned capacity to get a lower per-query rate.

D. Convert all tables to Apache Iceberg format for better file pruning.

E. Migrate all queries to Redshift for better caching.

**Correct Answer: A, B**

**Explanation:** Query result reuse (A) eliminates data scanning for the 40% of identical queries, saving 40% of the common query costs (approximately $3,360/month). Pre-aggregated summary tables (B) reduce the data scanned for the remaining common queries—summarizing billions of rows into millions reduces scan volume by 90%+ for aggregate queries. Combined savings: approximately 60-70% ($7,200-$8,400/month). Option C (provisioned capacity) doesn't reduce data scanned. Option D (Iceberg) helps with file pruning but not for full-scan aggregate queries. Option E (Redshift) adds infrastructure costs.

---

### Question 64

A company has a Redshift cluster (3x ra3.xlplus nodes) that runs 24/7 costing $12,000/month. Usage analysis shows the cluster is actively queried only 12 hours per day (8 AM - 8 PM), and only heavy analytical queries are run on weekends for 4 hours.

Which approach provides the GREATEST cost reduction?

A. Migrate to Redshift Serverless, which charges only for compute (RPU-hours) consumed during actual query execution. Queries during off-hours consume zero RPUs. Configure a base RPU allocation for consistent query performance during peak hours.

B. Pause the Redshift cluster during off-hours using a Lambda function scheduled by EventBridge. Resume before business hours.

C. Switch to smaller nodes (ra3.large) and add concurrency scaling for peak hours.

D. Migrate entirely to Athena, which charges per query with no infrastructure cost.

**Correct Answer: A**

**Explanation:** Redshift Serverless charges only for RPUs consumed during active queries. During the 12 idle hours on weekdays and 20 idle hours on weekends, zero RPUs are consumed (zero cost). This typically results in 50-70% savings compared to a provisioned cluster for this usage pattern. Unlike pausing/resuming, queries are served immediately without cluster startup time. Option B (pause/resume) works but adds 5-10 minutes of startup delay and risks over/under timing. Option C (smaller nodes) still runs 24/7. Option D (Athena) requires query migration and may not handle complex queries as efficiently.

---

### Question 65

A company uses Kinesis Data Firehose to deliver data to S3 for their data lake. Monthly Firehose costs are $3,000 for 10TB of data ingestion. The data includes 60% raw log data that is rarely queried and 40% business event data that is queried frequently.

Which optimization reduces Firehose costs?

A. Configure separate Firehose delivery streams: one for business events (with Parquet conversion enabled and normal buffer settings) and one for raw logs (with gzip compression, larger buffer sizes, and S3 Intelligent-Tiering storage class). The split allows different optimization strategies per data type.

B. Replace Firehose with direct S3 PutObject calls from the application for all data.

C. Reduce the Firehose buffer interval to send data more frequently with smaller batches.

D. Enable Firehose server-side encryption to reduce the data size.

**Correct Answer: A**

**Explanation:** Splitting into separate streams allows per-type optimization. Business events get Parquet conversion (smaller files, better query performance but higher Firehose processing cost). Raw logs get simple gzip compression (reducing Firehose data processing charges per GB) with larger buffers (fewer PutObject calls to S3). Using Intelligent-Tiering for rarely-queried logs automatically moves them to cheaper storage tiers. Option B (direct PutObject) requires application changes and loses Firehose's automatic batching and format conversion. Option C (smaller buffers) creates more small files and increases S3 PUT costs. Option D—encryption doesn't reduce data size.

---

### Question 66

A company uses QuickSight with SPICE datasets. Monthly QuickSight costs are $5,000, split between $2,000 for user licenses and $3,000 for SPICE capacity. SPICE utilization shows that 30% of SPICE capacity stores datasets that aren't used in any active dashboard.

Which approach reduces QuickSight costs?

A. Audit SPICE dataset usage by reviewing QuickSight API logs and dashboard metadata. Delete unused SPICE datasets (30% savings on SPICE costs = $900/month). Switch rarely-accessed dashboards from SPICE to direct query mode. Downgrade inactive users from Author to Reader licenses ($5/month vs $24/month for Enterprise).

B. Delete all SPICE datasets and switch entirely to direct query mode.

C. Reduce the SPICE dataset refresh frequency from daily to weekly.

D. Upgrade to QuickSight Q for AI-powered cost optimization recommendations.

**Correct Answer: A**

**Explanation:** Multi-pronged optimization: deleting unused SPICE datasets saves $900/month immediately. Switching rarely-accessed dashboards to direct query mode frees additional SPICE capacity. Downgrading inactive users to Reader licenses reduces license costs (potential $500-1000 savings depending on inactive Author count). Total potential savings: $1,400-$1,900/month (28-38%). Option B (all direct query) degrades performance for active dashboards. Option C (weekly refresh) provides stale data. Option D—QuickSight Q is for natural language querying, not cost optimization.

---

### Question 67

A company's data lake processes 20TB of data daily using Glue ETL. Monthly Glue costs are $8,000. The team noticed that many jobs are over-provisioned—they allocate 100 DPUs but use only 30 DPUs on average. Some jobs have retry logic that restarts from scratch on failure, reprocessing already-completed data.

Which combination reduces Glue costs? (Choose TWO.)

A. Enable Glue auto-scaling for all jobs. Auto-scaling dynamically adjusts DPUs between the minimum and maximum based on workload demand, eliminating over-provisioning.

B. Implement Glue job bookmarks for incremental processing. When jobs fail and restart, bookmarks allow them to resume from the last checkpoint rather than reprocessing all data.

C. Switch all jobs from Glue Spark to Glue Python Shell for lower per-DPU costs.

D. Schedule all jobs during off-peak hours for lower DPU pricing.

E. Migrate from Glue to Lambda for all ETL processing.

**Correct Answer: A, B**

**Explanation:** Auto-scaling (A) reduces DPU allocation from 100 to the actual needed capacity (~30 on average), saving ~70% of compute costs. Job bookmarks (B) prevent reprocessing on job failures—retried jobs resume from the last successful checkpoint instead of starting from scratch, reducing both compute costs and processing time. Combined savings: 50-60% of the $8,000 monthly cost. Option C—Python Shell jobs can't handle the complex transformations that Spark jobs perform. Option D—Glue doesn't offer off-peak pricing. Option E—Lambda has limited processing capabilities for 20TB ETL.

---

### Question 68

A company stores 200TB of data in their data lake. Storage costs are $4,600/month (all S3 Standard). Access analysis shows: 20% of data is actively queried (daily), 50% is queried occasionally (monthly), and 30% hasn't been accessed in over a year.

Which storage optimization provides the GREATEST savings?

A. Implement S3 Intelligent-Tiering with the Archive Access tier (90 days) and Deep Archive Access tier (180 days) enabled. Intelligent-Tiering automatically moves objects between access tiers based on usage patterns, with no retrieval fees when accessed from archive tiers.

B. Create lifecycle rules: transition data older than 30 days to S3 Glacier Instant Retrieval, and data older than 365 days to Glacier Deep Archive.

C. Move all data to S3 Standard-IA for a 40% reduction in storage costs.

D. Use S3 Storage Lens to identify and delete the 30% of never-accessed data.

**Correct Answer: A**

**Explanation:** S3 Intelligent-Tiering with archive tiers provides automatic, access-pattern-based optimization. Actively queried data stays in Frequent Access (~$0.023/GB). Occasionally accessed data automatically moves to Infrequent Access (~$0.0125/GB). Unaccessed data moves to Archive Access (~$0.0036/GB) after 90 days and Deep Archive (~$0.00099/GB) after 180 days. No retrieval fees means no cost penalty when archived data is accessed. Estimated savings: ~60% ($2,760/month). Option B (lifecycle rules) risks retrieval fees for occasionally accessed data in Glacier. Option C (Standard-IA) provides only 40% savings vs 60%+. Option D (delete data) may violate retention requirements.

---

### Question 69

A company uses AWS DMS to replicate data from multiple on-premises databases to S3 for their data lake. Monthly DMS costs are $5,000 for 10 replication instances running 24/7. However, 6 of the 10 instances handle databases that only need weekly full loads, not continuous replication.

Which optimization reduces DMS costs?

A. Convert the 6 weekly full-load instances to serverless DMS configurations. DMS Serverless provisions capacity only during active replication and scales to zero when idle. Schedule weekly full-load tasks using EventBridge. Keep the 4 continuous CDC instances running for real-time replication needs.

B. Consolidate all 10 replication instances into 2 larger instances to reduce per-instance costs.

C. Replace DMS with custom scripts running on Lambda for the weekly full loads.

D. Stop and restart the 6 instances weekly using Lambda functions.

**Correct Answer: A**

**Explanation:** DMS Serverless provisions replication capacity on-demand and scales to zero when no replication is active. For the 6 weekly full-load instances, this means paying only for the hours they're actively running (perhaps 4-8 hours per week vs 168 hours). Scheduled EventBridge rules trigger the weekly full loads. The 4 continuous CDC instances remain provisioned for constant replication. Estimated savings: ~50% of the $5,000 ($2,500/month). Option B (consolidation) risks resource contention and doesn't reduce idle time. Option C (Lambda scripts) can't handle database extraction efficiently. Option D (stop/start) adds management complexity and risks.

---

### Question 70

A company uses Amazon Redshift with ra3 nodes. They store 50TB of data but only 10TB is frequently accessed (hot data). The remaining 40TB is historical data queried quarterly for regulatory reporting.

Which Redshift storage optimization reduces costs?

A. Leverage Redshift's managed storage (ra3 nodes) which automatically tiers data between SSD (hot) and S3 (warm) based on access patterns. For the rarely-accessed 40TB, unload it to S3 and use Redshift Spectrum for quarterly queries, freeing managed storage. This reduces the required node count.

B. Keep all 50TB in Redshift managed storage—ra3 nodes automatically tier to S3 so no optimization is needed.

C. Move the 40TB of historical data to Glacier and restore it quarterly for reporting.

D. Partition all tables by date and drop old partitions, moving data to S3 with Redshift Spectrum for historical queries.

**Correct Answer: A**

**Explanation:** While ra3 managed storage does auto-tier to S3, the compute nodes are still sized for the full dataset. Explicitly unloading the 40TB to S3 and querying via Spectrum means you can potentially downsize the Redshift cluster (fewer nodes needed for 10TB hot data). Spectrum queries the S3 data on-demand during quarterly reporting without maintaining the compute capacity to handle it. This reduces both storage costs in Redshift and compute node costs. Option B (do nothing) doesn't realize the potential node reduction. Option C (Glacier) is too slow for ad-hoc quarterly queries. Option D is the right concept but partitioning alone doesn't reduce node count.

---

### Question 71

A company runs a Glue ETL pipeline that transforms data from CSV to Parquet. The pipeline runs 6 times daily, processing 500GB per run. Each run takes 40 minutes using 50 DPUs. Monthly Glue costs are $6,000.

Which optimization reduces costs without increasing processing time?

A. Use Glue Flex execution mode for non-urgent runs. Flex uses spare Glue capacity at a lower cost. Schedule 4 of the 6 daily runs as Flex (for non-time-critical loads) and keep 2 runs as Standard (for time-sensitive loads). Flex provides ~34% cost reduction per DPU-hour.

B. Reduce the DPU count to 25 and accept longer processing times.

C. Switch from Glue Spark to Glue Ray for better cost efficiency.

D. Run the pipeline once daily with a larger data volume instead of 6 times.

**Correct Answer: A**

**Explanation:** Glue Flex execution mode uses spare capacity at approximately 34% lower cost per DPU-hour. For non-time-critical runs (4 of 6), Flex provides the same processing capability at reduced cost. Time-sensitive runs remain Standard for guaranteed resource availability. This doesn't increase processing time—Flex jobs may start slightly slower but execute at the same speed. Estimated savings: 4/6 × 34% ≈ 22% ($1,320/month). Option B (fewer DPUs) increases job duration. Option C—Glue Ray is for Python workloads, not Spark ETL. Option D may not be feasible if downstream consumers need fresher data.

---

### Question 72

A company uses Amazon EMR for data processing. They run 5 clusters that operate 24/7, each with 1 master node and 10 core nodes (m5.2xlarge). Monthly EMR costs are $30,000. Workloads are batch jobs that run throughout the day with 40% idle time between jobs.

Which approach provides the GREATEST cost reduction?

A. Replace the 24/7 clusters with transient EMR clusters that launch for each job and terminate after completion. Use EMR on EKS or EMR Serverless for even more granular resource allocation. Use Spot Instances for task nodes. Store all data in S3 (not HDFS) to enable stateless clusters.

B. Purchase Reserved Instances for the master and core nodes for a 40% discount.

C. Switch from m5.2xlarge to m5.xlarge nodes and double the node count.

D. Add Auto Scaling to the core node group to reduce nodes during idle periods.

**Correct Answer: A**

**Explanation:** Transient clusters eliminate the 40% idle time completely—you only pay for compute during active job execution. EMR Serverless provides per-job billing without cluster management overhead. S3-based storage enables stateless clusters that launch, process, and terminate. Spot Instances for task nodes add further savings (60-90% off On-Demand). Combined savings: 60-75% of the $30,000 ($18,000-$22,500/month). Option B (RIs at 40%) saves $12,000 but still pays for idle time. Option C doesn't reduce idle waste. Option D (Auto Scaling) helps but still maintains minimum core nodes 24/7.

---

### Question 73

A company uses Amazon Redshift for BI queries. They have 10 BI dashboards that run identical queries every 15 minutes to refresh data. Each query scans 100GB of data. Monthly Redshift compute costs are impacted by these repetitive queries.

Which Redshift feature reduces the load from repetitive dashboard queries?

A. Use Redshift materialized views that auto-refresh on a schedule. The dashboard queries read from the materialized views (which are pre-computed and stored) instead of scanning the base tables. Configure auto-refresh to run every 15 minutes aligned with the dashboard refresh.

B. Enable Redshift result caching, which caches query results for identical queries.

C. Create Redshift data sharing to offload dashboard queries to a consumer cluster.

D. Use Redshift Spectrum to offload the scans to external compute.

**Correct Answer: A**

**Explanation:** Materialized views pre-compute and store query results physically. Dashboard queries reading from materialized views scan the pre-computed results (much smaller than 100GB base tables), dramatically reducing compute load. Auto-refresh every 15 minutes keeps the views current. For 10 dashboards with overlapping base queries, shared materialized views serve all dashboards. Option B (result caching) works for identical queries but cache invalidates on data changes. Option C (data sharing) moves load to another cluster (additional cost). Option D (Spectrum) still scans full data volume.

---

### Question 74

A company has an Athena workgroup with 100 analysts. Monthly Athena costs are $15,000. Usage analysis reveals that 5 analysts run queries scanning 100+ GB each, while the other 95 run queries scanning less than 1GB. The 5 heavy users account for 80% of total costs.

Which approach controls costs while maintaining analyst productivity?

A. Create two Athena workgroups: "standard" (95 analysts, per-query scan limit of 10GB) and "power" (5 analysts, per-query scan limit of 500GB with a monthly workgroup budget). Require power users to justify large queries and optimize their queries using partition pruning and columnar formats. Implement query review for queries exceeding 50GB.

B. Set a per-query data scan limit of 1GB for all analysts.

C. Move the 5 power users to Redshift and keep the 95 standard users on Athena.

D. Limit all analysts to 10 queries per day.

**Correct Answer: A**

**Explanation:** Differentiated workgroups address the cost distribution: standard workgroup protects 95% of users with reasonable limits, while the power workgroup allows necessary large queries with visibility and budgets. Per-query scan limits prevent accidental large scans (missing WHERE clauses). Monthly budgets provide cost predictability. Query review for large queries encourages optimization. Option B (1GB limit for all) blocks legitimate analytical work. Option C (Redshift for 5 users) adds infrastructure for a few users. Option D (query limits) is too restrictive and doesn't address scan volume.

---

### Question 75

A company uses AWS Glue, Athena, Redshift, and QuickSight for their analytics platform. Total monthly cost is $50,000. The CFO wants a 30% cost reduction. The team needs to identify where to focus optimization efforts.

Which approach provides the MOST efficient cost analysis?

A. Use AWS Cost Explorer with granular filtering by service, usage type, and linked account. Identify the top cost drivers. Use Glue and Athena cost allocation tags to attribute costs to specific pipelines and teams. Cross-reference with CloudWatch metrics (Glue DPU utilization, Athena data scanned, Redshift cluster utilization, QuickSight SPICE usage) to identify waste. Focus optimization on the largest waste areas first.

B. Review the monthly AWS bill and reduce the most expensive service proportionally.

C. Apply a 30% reduction target equally across all services.

D. Hire a consultant to review the architecture.

**Correct Answer: A**

**Explanation:** Cost Explorer with granular filtering identifies which specific resources drive costs. Cost allocation tags attribute costs to teams and pipelines, enabling accountability. Cross-referencing with utilization metrics reveals waste: under-utilized Redshift clusters, over-provisioned Glue DPUs, unoptimized Athena queries, and unused QuickSight SPICE. Prioritizing optimization by waste magnitude ensures the 30% target is achievable with focused effort. Option B (reduce biggest service) may cut essential resources. Option C (equal reduction) doesn't account for varying waste levels. Option D adds cost without guarantee of results.

---

## Answer Key

| Question | Answer | Domain |
|----------|--------|--------|
| 1 | A | D1 |
| 2 | A | D1 |
| 3 | B | D1 |
| 4 | A | D1 |
| 5 | A | D1 |
| 6 | A | D1 |
| 7 | A, B | D1 |
| 8 | A | D1 |
| 9 | A | D1 |
| 10 | C | D1 |
| 11 | A | D1 |
| 12 | A, C | D1 |
| 13 | C | D1 |
| 14 | A | D1 |
| 15 | A | D1 |
| 16 | A | D1 |
| 17 | A, B | D1 |
| 18 | A | D1 |
| 19 | A | D1 |
| 20 | A | D1 |
| 21 | A | D2 |
| 22 | A | D2 |
| 23 | A | D2 |
| 24 | A | D2 |
| 25 | A | D2 |
| 26 | A | D2 |
| 27 | A | D2 |
| 28 | A | D2 |
| 29 | A | D2 |
| 30 | A | D2 |
| 31 | A | D2 |
| 32 | A | D2 |
| 33 | A | D2 |
| 34 | A | D2 |
| 35 | A | D2 |
| 36 | A | D2 |
| 37 | A | D2 |
| 38 | A | D2 |
| 39 | A | D2 |
| 40 | A | D2 |
| 41 | A | D2 |
| 42 | A | D2 |
| 43 | A | D3 |
| 44 | A, B | D3 |
| 45 | A, B | D3 |
| 46 | A | D3 |
| 47 | A | D3 |
| 48 | A | D3 |
| 49 | A | D3 |
| 50 | A | D3 |
| 51 | C | D3 |
| 52 | A | D3 |
| 53 | A | D3 |
| 54 | A | D4 |
| 55 | A | D4 |
| 56 | A | D4 |
| 57 | A | D4 |
| 58 | A | D4 |
| 59 | A | D4 |
| 60 | A | D4 |
| 61 | A | D4 |
| 62 | A | D4 |
| 63 | A, B | D5 |
| 64 | A | D5 |
| 65 | A | D5 |
| 66 | A | D5 |
| 67 | A, B | D5 |
| 68 | A | D5 |
| 69 | A | D5 |
| 70 | A | D5 |
| 71 | A | D5 |
| 72 | A | D5 |
| 73 | A | D5 |
| 74 | A | D5 |
| 75 | A | D5 |
