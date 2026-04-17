# AWS Certified Solutions Architect - Professional (SAP-C02) Practice Test 33

## Logging, Monitoring, Observability (CloudWatch Advanced, X-Ray, CloudTrail Analysis, Log Aggregation)

**Time Limit: 180 minutes | 75 Questions | Passing Score: 75%**

---

### Question 1
A company operates a microservices architecture with 40 services running on ECS Fargate. Users report intermittent slowness that lasts 2-5 minutes and occurs randomly throughout the day. The engineering team cannot reproduce the issue. Individual service dashboards show normal metrics. The architect needs to implement a solution to identify the root cause of these transient performance issues.

A) Enable AWS X-Ray tracing across all 40 services to create a service map and identify latency bottlenecks in the request path
B) Increase CloudWatch metric resolution to 1-second intervals for all services
C) Add more logging statements to each service for better debugging
D) Use CloudWatch Container Insights to monitor ECS task-level metrics

**Correct Answer: A**
**Explanation:** AWS X-Ray provides distributed tracing that follows a request as it traverses multiple microservices. The service map visualizes dependencies between all 40 services and highlights which service is causing latency. X-Ray traces capture timing for each segment (service) and subsegment (database call, API call), enabling identification of which service or dependency is the bottleneck during the intermittent slowness. Option B increases metric granularity but individual service metrics are already normal—the issue is likely a cascading cross-service problem. Option C adds noise without cross-service correlation. Option D provides container metrics but not request-level tracing across services.

---

### Question 2
A company needs to aggregate CloudWatch Logs from 15 AWS accounts in an organization into a central logging account for security analysis. Logs include VPC Flow Logs, CloudTrail logs, and application logs. The central account receives approximately 5 TB of logs per day. The architect must design a cost-effective, scalable log aggregation solution.

A) Use CloudWatch Logs subscription filters in each account to stream logs to a Kinesis Data Stream in the central account, then use Kinesis Data Firehose to deliver to S3
B) Use CloudWatch cross-account observability to share log groups from all accounts with the central monitoring account
C) Configure each account to send logs directly to S3 in the central account using S3 bucket policies
D) Use CloudWatch Logs subscription filters in each account to forward to a Kinesis Data Firehose in the central account, delivering to S3 with partitioning by account ID and log type

**Correct Answer: D**
**Explanation:** Kinesis Data Firehose in the central account provides the most cost-effective delivery at 5 TB/day. Subscription filters in each account stream matching logs to the cross-account Firehose delivery stream. Firehose handles buffering, compression (GZIP), and delivery to S3 with dynamic partitioning by account ID and log type for efficient querying. At 5 TB/day, Firehose costs ~$175/day ($0.035/GB) vs. Kinesis Data Streams which would require many shards. Option A adds unnecessary Kinesis Data Streams cost. Option B provides a shared view but doesn't aggregate into a central data store. Option C doesn't support streaming log delivery—CloudWatch Logs can't write directly to cross-account S3.

---

### Question 3
A company uses CloudWatch Alarms to monitor their production environment. They have 500 alarms across 50 services. The operations team receives 200+ alarm notifications daily, many of which are transient spikes that resolve within 30 seconds. This alarm fatigue causes the team to miss genuine issues. How should the architect reduce noise while maintaining alerting for real problems?

A) Increase all alarm evaluation periods from 1 minute to 5 minutes to filter out transient spikes
B) Use CloudWatch composite alarms that combine multiple related alarms and only trigger when a combination of conditions indicates a genuine issue
C) Reduce the number of alarms to only the most critical 50
D) Route all alarms through an SNS topic to a Lambda function that implements debouncing logic before notifying the team

**Correct Answer: B**
**Explanation:** Composite alarms combine multiple alarms using AND/OR logic. For example, a composite alarm triggers only when BOTH "high error rate" AND "high latency" alarms are in ALARM state simultaneously, filtering out isolated transient spikes. This dramatically reduces noise while maintaining sensitivity to genuine multi-symptom issues. A composite alarm for each service might combine CPU, error rate, and latency—only alerting when multiple indicators suggest a real problem. Option A masks short but severe issues. Option C loses visibility into important metrics. Option D adds custom code to maintain but is a viable secondary approach.

---

### Question 4
A company's CloudTrail logs show that someone deleted an S3 bucket containing critical production data. The CloudTrail event shows the IAM user "admin-user" performed the DeleteBucket action, but multiple people share this IAM user's credentials. The architect needs to determine who actually performed the deletion and prevent this situation in the future.

A) Enable CloudTrail log file integrity validation and use the source IP address in the CloudTrail event to identify the person, then implement individual IAM users with MFA for each person
B) Check the CloudTrail event for the session issuer and access key ID, cross-reference with AWS SSO (IAM Identity Center) sign-in events, and migrate to individual federated identities
C) Enable S3 server access logging to identify who deleted the bucket
D) Use Amazon Detective to analyze the activity associated with the admin-user's credentials

**Correct Answer: B**
**Explanation:** If the company uses AWS SSO/Identity Center, each person's federated session has a unique session identifier and role session name that appears in CloudTrail. Cross-referencing the access key ID and session information with Identity Center sign-in events can identify the individual. Going forward, migrating to individual federated identities (each person gets their own identity) ensures every action is attributable to a specific person. Option A—source IP may identify the office/VPN but not the individual if they share a network. Option C—S3 access logs don't capture IAM identity details beyond what CloudTrail provides. Option D—Detective helps with investigation but doesn't solve the shared credentials problem.

---

### Question 5
A company runs a Lambda-based API that processes 10,000 requests per minute. They need to track the end-to-end latency of each request as it flows through API Gateway → Lambda → DynamoDB → Lambda (async processing) → SQS → Lambda (consumer). X-Ray is enabled but traces for the async portion (SQS → Lambda consumer) appear as separate traces, making it impossible to correlate the full request flow.

A) Use X-Ray trace ID propagation by passing the trace header through SQS message attributes, and the downstream Lambda consumer reads and uses the original trace ID
B) Implement custom correlation IDs in application logs and use CloudWatch Logs Insights to join the traces
C) Use X-Ray groups to automatically group related traces
D) Enable active tracing on the SQS queue to automatically propagate trace context

**Correct Answer: A**
**Explanation:** X-Ray trace context doesn't automatically propagate through SQS (it's an async boundary). The solution is to manually propagate the X-Ray trace header by including it as an SQS message attribute (e.g., "AWSTraceHeader"). The consuming Lambda reads this attribute and creates a new segment with the original trace ID as the parent, linking the async processing back to the original trace. This creates a complete end-to-end trace across the async boundary. Option B works for correlation but doesn't create a unified X-Ray trace. Option C—groups filter traces by criteria but don't link separate traces. Option D—SQS doesn't have "active tracing" as a queue feature.

---

### Question 6
A company needs to monitor their multi-account, multi-region AWS environment from a single pane of glass. They have 20 accounts across 4 regions. The monitoring team needs to view CloudWatch metrics, logs, and traces from all accounts in one dashboard. What is the most operationally efficient approach?

A) Use CloudWatch cross-account observability with a central monitoring account designated as the monitoring account and all other accounts as source accounts
B) Create CloudWatch dashboards in each account and use a third-party tool to aggregate them
C) Replicate all CloudWatch metrics and logs to a central account using Lambda functions
D) Use Amazon Managed Grafana with CloudWatch as a data source, configured with cross-account IAM roles

**Correct Answer: A**
**Explanation:** CloudWatch cross-account observability (launched 2022) is purpose-built for this use case. You designate one account as the monitoring account and configure the others as source accounts (via Organization-level configuration for all 20 accounts). The monitoring account can view metrics, logs, and traces from all source accounts in CloudWatch dashboards, without duplicating data. It supports cross-account metric math, log insights queries, and X-Ray traces. Option B requires managing multiple tools. Option C duplicates data and adds cost. Option D works but requires deploying and managing Grafana infrastructure, while native CloudWatch cross-account is built-in.

---

### Question 7
A company's application logs contain sensitive PII data (credit card numbers, social security numbers) that must not be stored in CloudWatch Logs due to compliance requirements. The application generates 100 GB of logs per day. The architect needs to implement log filtering that removes PII before logs are stored, without modifying the application code.

A) Use CloudWatch Logs data protection policies to automatically detect and mask PII data types (credit card numbers, SSNs) in log groups
B) Use a CloudWatch Logs subscription filter to stream logs to a Lambda function that strips PII, then writes sanitized logs to a new log group
C) Configure the CloudWatch Logs agent to filter PII patterns using regular expressions before sending logs
D) Use Amazon Macie to scan CloudWatch Logs for PII and delete matching log entries

**Correct Answer: A**
**Explanation:** CloudWatch Logs data protection policies (launched 2022) provide managed PII detection and masking directly within CloudWatch Logs. You configure data identifiers (credit card numbers, SSNs, etc.) on a log group, and CloudWatch automatically detects and masks matching patterns in real-time. Masked data appears as asterisks in the logs. Audit findings can be sent to S3 or Firehose. No application changes needed. Option B works but adds Lambda costs and complexity for 100 GB/day (~$4,000/month in Lambda execution). Option C—the CloudWatch agent doesn't support PII-aware filtering. Option D—Macie scans S3, not CloudWatch Logs.

---

### Question 8
A company has a containerized application on EKS with 200 pods across 20 nodes. They need to implement comprehensive observability covering metrics (CPU, memory, network, custom application metrics), logs (container logs, application logs), and traces (distributed tracing). The architect needs to recommend a unified observability stack.

A) Use Amazon CloudWatch Container Insights for metrics, Fluent Bit for log collection to CloudWatch Logs, and AWS X-Ray SDK for distributed tracing
B) Use Amazon Managed Service for Prometheus for metrics, Amazon Managed Grafana for visualization, AWS Distro for OpenTelemetry (ADOT) for traces and metrics collection, and Fluent Bit for logs to CloudWatch Logs
C) Deploy self-managed Prometheus, Grafana, and Jaeger on the EKS cluster
D) Use only CloudWatch Container Insights for all three pillars of observability

**Correct Answer: B**
**Explanation:** This provides a comprehensive, managed observability stack: **Amazon Managed Prometheus** handles metrics (supports PromQL, auto-scales, integrates with Kubernetes service discovery for custom metrics). **ADOT (AWS Distro for OpenTelemetry)** collects both metrics and traces using the OpenTelemetry standard—future-proof and vendor-neutral. **Fluent Bit** efficiently collects container and application logs, forwarding to CloudWatch Logs. **Amazon Managed Grafana** provides unified visualization across all three signals (metrics from Prometheus, logs from CloudWatch, traces from X-Ray). Option A works but doesn't leverage Prometheus for Kubernetes-native metric collection. Option C requires self-managing the observability stack. Option D—Container Insights provides metrics and logs but limited tracing.

---

### Question 9
A company's CloudTrail logs show unusual API activity: hundreds of DescribeInstances calls from an IAM role used by an EC2 instance. The instance runs a monitoring application that should only make a few API calls per minute. The security team suspects credential exfiltration. How should the architect investigate and respond?

A) Use Amazon Detective to analyze the IAM role's API activity patterns, identify anomalous behavior, and trace the source of the unusual calls
B) Immediately rotate the IAM role's temporary credentials by stopping and starting the EC2 instance
C) Use CloudTrail Lake to query the historical API activity pattern for this role and compare recent activity against the baseline
D) Use Amazon GuardDuty findings which would have detected unusual API call patterns for the IAM role, and implement GuardDuty automated remediation

**Correct Answer: D**
**Explanation:** Amazon GuardDuty monitors CloudTrail events and learns baseline API call patterns for each IAM principal. Unusual volume or patterns of API calls trigger findings like "Recon:IAMUser/MaliciousIPCaller.Custom" or "Discovery:IAMUser/AnomalousBehavior." For automated remediation: GuardDuty finding → EventBridge rule → Step Functions/Lambda that isolates the instance (modify security group to deny all traffic) and revokes the role's active sessions. This provides both detection and automated response. Option A provides investigation tools but not automatic detection. Option B only rotates credentials without investigation. Option C provides historical analysis but no real-time detection.

---

### Question 10
A company processes financial transactions and must retain all application logs for 7 years for compliance. The application generates 500 GB of logs per day. Logs older than 90 days are rarely accessed but must be searchable within 24 hours when needed for audits. The architect must optimize log storage costs.

A) Store all logs in CloudWatch Logs with a 7-year retention period
B) Store logs in CloudWatch Logs with 90-day retention, use a subscription filter to deliver logs to S3 via Kinesis Data Firehose, and use S3 lifecycle policies to transition to Glacier after 90 days; use Athena for querying archived logs
C) Store all logs directly in S3 Standard and use Athena for all queries
D) Use Amazon OpenSearch Service for all log storage with UltraWarm and Cold storage tiers

**Correct Answer: B**
**Explanation:** This tiered approach optimizes costs: **Hot tier (0-90 days):** CloudWatch Logs provides real-time querying with Logs Insights at $0.50/GB ingestion. **Warm tier (90 days - 7 years):** S3 storage via Firehose at ~$0.023/GB/month (Standard) transitioning to Glacier at ~$0.004/GB/month. Athena queries archived logs on demand ($5/TB scanned). At 500 GB/day: CloudWatch: 500 GB × $0.50 = $250/day ingestion + storage. S3/Glacier long-term: ~$1.8 million for 7 years at Glacier pricing, much cheaper than CloudWatch at $0.03/GB/month (~$38M for 7 years). Option A costs ~$38M over 7 years for CloudWatch storage alone. Option C loses real-time query capabilities. Option D—OpenSearch is expensive for long-term archival.

---

### Question 11
A company uses CloudWatch Logs Insights to analyze application logs. A common query searches for all ERROR logs from a specific service in the last 24 hours and counts them by error type. The query takes 45 seconds to run because it scans 200 GB of logs. The architect needs to reduce query time.

A) Use CloudWatch Logs Insights with the `parse` command to extract structured fields and reduce scan volume
B) Implement CloudWatch Metric Filters that extract error counts by type in real-time, and query the resulting CloudWatch Metrics instead of raw logs
C) Switch to structured JSON logging and use the `filter` command early in the query to reduce the scan scope, and limit the query to specific log streams
D) Increase the number of CloudWatch Logs Insights concurrent queries

**Correct Answer: C**
**Explanation:** CloudWatch Logs Insights performs a full scan of the selected log groups and time range. To reduce scan time: (1) Structured JSON logging allows efficient field-level filtering (CloudWatch auto-discovers JSON fields). (2) Using `filter` as the first command in the query pipeline allows CloudWatch to skip non-matching records early. (3) Targeting specific log streams (e.g., only the relevant service's streams) instead of the entire log group reduces the data scanned. Together, these can reduce the 200 GB scan to perhaps 20 GB, cutting query time to ~4.5 seconds. Option A—`parse` extracts fields but doesn't reduce scan volume (all records are still read). Option B works for pre-defined metrics but loses the flexibility of ad-hoc queries. Option D doesn't reduce individual query time.

---

### Question 12
A company needs to detect and alert on AWS account-level security issues in real-time: root account usage, IAM policy changes, security group modifications, S3 bucket policy changes, and CloudTrail configuration changes. What is the most comprehensive approach?

A) Create CloudWatch Metric Filters for each event type in the CloudTrail log group, create alarms on each metric, and notify via SNS
B) Use Amazon EventBridge rules to match specific CloudTrail management events and route to SNS for alerting
C) Use AWS Config rules to detect non-compliant configurations and SNS for alerting
D) Use GuardDuty for all security monitoring and alerting

**Correct Answer: B**
**Explanation:** EventBridge natively integrates with CloudTrail management events, providing real-time alerting without the need for CloudWatch Metric Filters. Event patterns match specific API calls (e.g., {"source": ["aws.iam"], "detail-type": ["AWS API Call via CloudTrail"], "detail": {"eventName": ["CreatePolicy", "DeletePolicy", "AttachRolePolicy"]}}). Multiple rules can cover all required event types, each routing to SNS for notification. This is simpler and faster than Metric Filters. Option A works but requires creating and maintaining regex-based Metric Filters for each event type—more complex. Option C detects configuration drift but not real-time API events (Config evaluations have delays). Option D detects threats but not all the listed administrative events.

---

### Question 13
A company runs a multi-tier application and needs to implement canary testing for their production endpoints. The canaries should check: (1) API availability every 5 minutes, (2) multi-step user workflows (login → search → checkout), and (3) visual regression of the web UI. The architect must implement this monitoring.

A) Use Amazon CloudWatch Synthetics canaries with heartbeat monitoring for API availability, API canary blueprints for multi-step workflows, and visual monitoring for UI regression
B) Use AWS Lambda scheduled functions that perform HTTP health checks every 5 minutes
C) Use Route 53 health checks for endpoint monitoring
D) Deploy a third-party monitoring solution like Datadog Synthetic Monitoring

**Correct Answer: A**
**Explanation:** CloudWatch Synthetics provides all three capabilities natively: **Heartbeat canaries** perform HTTP/HTTPS availability checks on configurable schedules (every 5 minutes). **API canary blueprints** support multi-step test scripts using Node.js or Python to simulate user workflows (login → search → checkout), checking response codes and content at each step. **Visual monitoring** takes screenshots and compares against baselines to detect UI regressions. All results feed into CloudWatch (metrics, logs, artifacts), integrating with alarms and dashboards. Option B handles basic health checks but not multi-step workflows or visual monitoring. Option C provides simple endpoint monitoring. Option D adds external dependency and cost.

---

### Question 14
A company uses X-Ray for distributed tracing. They notice that their X-Ray costs are escalating because they're tracing 100% of requests (5 million requests per day). Most traces show normal behavior. The architect needs to reduce costs while maintaining visibility into performance issues.

A) Reduce the sampling rate to 5% of all requests
B) Use X-Ray sampling rules to trace 100% of requests with errors or high latency (reservoir of 1 per second + 5% rate), and reduce sampling for normal requests to 1%
C) Disable X-Ray and rely on CloudWatch metrics for monitoring
D) Sample only during business hours when the team is monitoring

**Correct Answer: B**
**Explanation:** X-Ray sampling rules allow intelligent sampling. Configure a rule with a reservoir (guaranteed traces per second) and a rate (percentage of additional traces). For error detection: create a high-priority rule that traces 100% of requests matching error conditions (using the rule's service name, URL path, or HTTP method). For normal traffic: use the default rule with a 1% rate (50,000 traces/day from 5 million requests—still statistically significant). The reservoir of 1 per second ensures minimum coverage during low-traffic periods. This can reduce trace volume by 95%+ while maintaining full visibility into problems. Option A blindly reduces all sampling. Option C loses tracing benefits. Option D creates monitoring gaps.

---

### Question 15
A company stores VPC Flow Logs in CloudWatch Logs for security analysis. They need to identify: (1) top talkers (IPs with most traffic), (2) rejected connections (potential attacks), and (3) unusual port usage. The daily flow log volume is 50 GB. The architect needs an efficient analysis approach.

A) Use CloudWatch Logs Insights queries to analyze flow logs directly in CloudWatch
B) Export flow logs to S3 in Parquet format, create an AWS Glue table, and use Amazon Athena for SQL-based analysis with partition pruning
C) Import flow logs into Amazon OpenSearch Service for interactive analysis and visualization
D) Use Amazon Detective which automatically analyzes VPC Flow Logs for security insights

**Correct Answer: B**
**Explanation:** For 50 GB/day of flow logs, Athena with Parquet-formatted data in S3 is the most cost-effective and performant approach. VPC Flow Logs can be delivered directly to S3 in Parquet format (columnar, compressed—reduces volume to ~10 GB). Athena scans only the columns needed for each query ($5/TB scanned). Partitioning by date, region, and account enables partition pruning. Example queries: `SELECT srcaddr, SUM(bytes) FROM flow_logs WHERE day='2024-01-15' GROUP BY srcaddr ORDER BY 2 DESC LIMIT 10` for top talkers. Option A works for ad-hoc queries but CloudWatch Logs Insights at 50 GB/day is expensive (~$25/query scanning all data). Option C is expensive to run continuously. Option D provides automated analysis but less flexibility for custom queries.

---

### Question 16
A company implements CloudWatch anomaly detection on their application's latency metric. The model initially generates many false positive alarms during expected traffic pattern changes (e.g., weekend vs. weekday, monthly batch jobs). How should the architect tune the anomaly detection to reduce false positives while maintaining sensitivity to genuine anomalies?

A) Increase the anomaly detection band width to 3 standard deviations to make the model more tolerant
B) Exclude known time periods (batch job hours) from the anomaly detection evaluation, and allow 2-3 weeks for the model to learn the weekly and monthly patterns before enabling alarms
C) Switch from anomaly detection to static threshold alarms
D) Use metric math to subtract the expected baseline before applying anomaly detection

**Correct Answer: B**
**Explanation:** CloudWatch anomaly detection uses machine learning that adapts to patterns over time (daily, weekly, monthly seasonality). Two tuning actions help: (1) Allow 2-3 weeks of training data so the model learns weekday/weekend patterns and monthly batch patterns. (2) Exclude specific time ranges when known batch jobs run, so the model doesn't need to account for extreme but expected spikes. After training, the model generates appropriate bands that accommodate recurring patterns. Option A reduces sensitivity across the board, missing genuine anomalies. Option C loses the benefits of adaptive thresholds. Option D adds complexity without addressing the root cause.

---

### Question 17
A company's security team needs real-time visibility into which IAM users and roles are performing actions across their AWS accounts, with the ability to search and visualize this data. CloudTrail management events across 30 accounts generate 2 GB/day. They need to retain searchable data for 90 days. What is the most cost-effective solution?

A) Use CloudTrail Lake to aggregate events from all 30 accounts with a 90-day retention event data store
B) Send CloudTrail logs to CloudWatch Logs in each account and use cross-account observability to query centrally
C) Use Amazon OpenSearch Service with a 90-day index lifecycle
D) Send CloudTrail events to S3 and query with Athena

**Correct Answer: A**
**Explanation:** CloudTrail Lake provides a managed, SQL-queryable event data store purpose-built for CloudTrail events. It supports cross-account event collection (via Organization trails), provides 90-day retention natively (7-year and custom retention also available), and allows SQL queries against structured CloudTrail events. At 2 GB/day × 90 days = 180 GB stored, the cost is approximately $2.50/GB ingestion = $5/day + $0.005/GB-month retained. Total: ~$150/month ingestion + ~$1/month retention = ~$151/month. Option B—CloudWatch Logs at $0.50/GB ingestion costs $1/day but querying 90 days of data is slower and more expensive. Option C—OpenSearch is expensive ($200+/month for a minimal cluster). Option D requires managing S3 lifecycle and Glue catalog.

---

### Question 18
A company's application uses Lambda functions that occasionally experience cold starts, causing P99 latency spikes to 5 seconds (normal P99 is 200ms). The team needs to monitor cold start frequency, measure cold start duration, and set up alerts when cold start rates exceed 5% of invocations. How should the architect implement this monitoring?

A) Use CloudWatch Lambda Insights which automatically captures cold start metrics including frequency and duration
B) Add custom instrumentation in the Lambda function to detect cold starts (using a global variable initialized once) and publish a custom CloudWatch metric
C) Use X-Ray traces to identify cold start segments (the "Initialization" subsegment) and create CloudWatch alarms based on X-Ray trace data
D) Use Lambda Provisioned Concurrency and eliminate cold starts entirely

**Correct Answer: A**
**Explanation:** CloudWatch Lambda Insights is a Lambda extension that automatically collects enhanced metrics including `init_duration` (cold start duration). It distinguishes between cold starts and warm invocations, providing `cold_start_count` metrics. You can create alarms on the ratio of cold starts to total invocations. Lambda Insights also provides CPU, memory, network, and disk metrics for each invocation. Option B works but requires custom code in every Lambda function. Option C—X-Ray captures Initialization segments but creating alarms from X-Ray data requires custom metric extraction. Option D eliminates cold starts but doesn't address the monitoring requirement and adds cost.

---

### Question 19
A company migrated 200 on-premises applications to AWS. Each application produces logs in different formats (Apache logs, Windows Event Logs, custom JSON, plaintext). The company needs a centralized logging solution that handles format differences and provides full-text search across all log sources. What should the architect recommend?

A) Use CloudWatch Logs with unified agent configured for each log format, with Logs Insights for querying
B) Use Amazon OpenSearch Service with Logstash (or Amazon OpenSearch Ingestion) for log parsing and normalization, Kibana/OpenSearch Dashboards for search and visualization
C) Send all logs to S3 and use Athena for querying
D) Use CloudWatch Logs with subscription filters to Lambda functions that normalize log formats before storing in a central log group

**Correct Answer: B**
**Explanation:** OpenSearch with a log parsing pipeline is best for heterogeneous log formats requiring full-text search. OpenSearch Ingestion (managed Logstash alternative) or Logstash can parse diverse formats using grokk patterns, JSON filters, and custom parsers, normalizing them into a common schema before indexing. OpenSearch provides powerful full-text search across all normalized logs with sub-second query times. OpenSearch Dashboards provides visualization and interactive exploration. Option A—CloudWatch Logs handles multiple formats but Logs Insights querying across different formats is challenging. Option C—Athena works for structured data but full-text search across mixed formats is cumbersome. Option D adds complexity and still has cross-format querying challenges.

---

### Question 20
A company needs to monitor the health and performance of their Direct Connect connections and AWS Transit Gateway. They need to track: connection state changes, BGP session status, data throughput, and packet loss. Alerts should fire when any connection degrades. What monitoring approach should the architect implement?

A) Use CloudWatch metrics for Direct Connect (ConnectionState, ConnectionBpsIngress/Egress) and Transit Gateway (BytesIn/Out, PacketsIn/Out, PacketDropCountBlackhole), with alarms on each metric
B) Use VPC Flow Logs to monitor traffic through the Transit Gateway
C) Use AWS Network Manager with integrated CloudWatch dashboards for network topology visualization and health monitoring
D) Both A and C together provide comprehensive network monitoring

**Correct Answer: D**
**Explanation:** Both approaches are complementary: (A) CloudWatch metrics provide granular, real-time monitoring of Direct Connect and Transit Gateway with alarms for immediate alerting on degradation. Key metrics include ConnectionState (up/down), BGP status, throughput (BpsIngress/Egress), and packet drops. (C) AWS Network Manager provides a global network view, topology visualization, event correlation, and integrates with CloudWatch. It shows the entire network topology (Direct Connect, VPNs, Transit Gateways) on a single dashboard and correlates network events. Together they provide both alerting (CloudWatch) and visualization/topology (Network Manager). Option B—VPC Flow Logs capture IP-level traffic details but not connection health or BGP status.

---

### Question 21
A company uses Amazon CloudWatch to monitor their production environment. They have a Lambda function that processes orders and writes to DynamoDB. The function currently logs to CloudWatch Logs using unstructured text: `logger.info(f"Processing order {order_id} for customer {customer_id}")`. The team struggles to extract meaningful insights from these logs. How should the architect improve the logging strategy?

A) Switch to structured JSON logging with embedded metric format (EMF) to simultaneously generate both searchable logs and CloudWatch metrics from a single log statement
B) Switch to structured JSON logging and create CloudWatch Metric Filters to extract metrics
C) Continue with text logging but add more detail to each line
D) Use Lambda PowerTools for standardized logging

**Correct Answer: A**
**Explanation:** CloudWatch Embedded Metric Format (EMF) allows Lambda functions to embed metric data within structured JSON log entries. A single log statement produces both a searchable log entry AND a CloudWatch metric, eliminating the need for separate Metric Filters. Example: `{"order_id": "123", "customer_id": "456", "processing_time_ms": 250, "_aws": {"Timestamp": ..., "CloudWatchMetrics": [{"Namespace": "OrderProcessing", "Dimensions": [["ServiceName"]], "Metrics": [{"Name": "ProcessingTime", "Unit": "Milliseconds"}]}]}}`. This creates a "ProcessingTime" metric automatically while maintaining searchable structured logs. Option B requires separate Metric Filter management. Option D is a good complement (Lambda PowerTools supports EMF) but doesn't specify the EMF approach.

---

### Question 22
A company needs to analyze CloudTrail events to detect potential security threats. They need to identify: (1) IAM users who accessed resources outside their normal working hours, (2) API calls from unusual geographic locations, (3) privilege escalation patterns (user modifying their own IAM policies). What combination of services provides the best detection? (Select TWO)

A) Amazon GuardDuty for automated threat detection of unusual API activity and geographic anomalies
B) Amazon Detective for deep investigation of detected threats with interactive visualizations
C) AWS CloudTrail Insights for detecting unusual API call volumes
D) Amazon Macie for detecting sensitive data access patterns
E) AWS Security Hub for aggregating findings from all security services

**Correct Answer: A, B**
**Explanation:** (A) GuardDuty uses ML to automatically detect the described threats: unusual API call patterns (outside working hours), API calls from unusual IP addresses/geographic locations, and IAM-related threats including privilege escalation attempts. It continuously analyzes CloudTrail, VPC Flow Logs, and DNS logs. (B) Detective provides deep investigation capabilities—when GuardDuty generates a finding, Detective enables the security team to visualize the user's historical activity patterns, related entities, and the full scope of the potential compromise through interactive graphs and timelines. Option C detects volume anomalies but not the specific threats described. Option D focuses on S3 data classification, not API activity. Option E aggregates findings but doesn't generate them.

---

### Question 23
A company's application runs on Auto Scaling EC2 instances. After a deployment, instances intermittently crash and are replaced by the Auto Scaling group. The team needs to investigate the crashed instances, but they're terminated before anyone can access them. How should the architect enable post-mortem analysis of crashed instances?

A) Configure the Auto Scaling group to use lifecycle hooks on instance termination, allowing a Lambda function to capture logs, memory dumps, and system state to S3 before the instance is terminated
B) Disable Auto Scaling group health checks to keep unhealthy instances running
C) Configure Auto Scaling to suspend the ReplaceUnhealthy process during investigation
D) Use EC2 Instance Connect to SSH into instances before they terminate

**Correct Answer: A**
**Explanation:** Auto Scaling lifecycle hooks on the `EC2_INSTANCE_TERMINATING` transition pause the termination process, keeping the instance in a "Terminating:Wait" state for up to 48 hours (configurable). During this window, a Lambda function (or SSM Automation) can: collect CloudWatch Logs, capture an EBS snapshot, copy crash dumps and application logs to S3, and then signal to complete the lifecycle action. This provides forensic data without affecting the Auto Scaling group's ability to launch replacement instances. Option B stops the ASG from maintaining healthy capacity. Option C requires manual intervention and affects availability. Option D is race-condition dependent and instances may not be reachable.

---

### Question 24
A company operates a data processing pipeline that consists of S3 → Lambda → SQS → EC2 Worker Fleet → RDS. They need to track the processing status of each record through the entire pipeline, including the time spent in each stage, and generate a real-time dashboard showing pipeline health. What should the architect implement?

A) Use X-Ray to trace each record through the pipeline, with custom X-Ray segments for the SQS wait time and EC2 processing
B) Publish custom CloudWatch metrics at each stage (using EMF from Lambda and custom metrics from EC2), create a CloudWatch dashboard with pipeline stage latency widgets
C) Use Step Functions to orchestrate the pipeline and leverage its built-in execution history for monitoring
D) Log timestamps at each stage to CloudWatch Logs and use Logs Insights to calculate stage durations

**Correct Answer: B**
**Explanation:** Custom CloudWatch metrics at each stage provide real-time pipeline monitoring. At each stage: Lambda publishes using EMF (records ingested, processing time), a metric for SQS queue depth (ApproximateNumberOfMessagesVisible is built-in), EC2 workers publish processing time and throughput metrics. A CloudWatch dashboard displays: records/minute at each stage, per-stage latency (P50, P99), queue depth, and end-to-end latency. Alarms on each stage metric detect bottlenecks immediately. Option A—X-Ray is for request-level tracing, not pipeline-level metrics; it also doesn't handle the EC2 worker fleet well. Option C requires re-architecting the pipeline. Option D provides analysis but not real-time dashboards.

---

### Question 25
A company uses CloudWatch Logs and needs to set up real-time alerting when their application logs contain the pattern "FATAL ERROR: database connection pool exhausted." The alert must trigger within 30 seconds of the log message appearing and must include the full log context (5 lines before and after the matching line). What approach should the architect take?

A) Create a CloudWatch Metric Filter that matches the pattern and triggers an alarm, which invokes an SNS topic → Lambda function that queries CloudWatch Logs for context
B) Use a CloudWatch Logs subscription filter matching the pattern, sending to a Lambda function that captures context lines from CloudWatch Logs and sends an alert via SNS
C) Use CloudWatch Logs Insights with a scheduled query running every 30 seconds
D) Use Amazon EventBridge with CloudWatch Logs as a source, matching the pattern

**Correct Answer: B**
**Explanation:** A subscription filter provides near-real-time log delivery to Lambda when the pattern matches. The Lambda function receives the matching log event, uses the CloudWatch Logs API (GetLogEvents with the timestamp range around the match) to fetch the surrounding context (5 lines before and after), and sends the enriched alert via SNS with the full context included. This achieves sub-30-second alerting with context. Option A adds delay: Metric Filter → alarm evaluation period (minimum 60 seconds) → SNS → Lambda. Option C—Logs Insights queries are ad-hoc, not real-time subscriptions. Option D—EventBridge doesn't support CloudWatch Logs content-based pattern matching directly.

---

### Question 26
A company has a multi-region application with CloudWatch dashboards in each region. The operations team wants a single global dashboard that shows the health of all regions side by side. How should the architect implement this?

A) Create a CloudWatch dashboard in us-east-1 that uses cross-region metric references to display metrics from all regions
B) Replicate metrics from all regions to us-east-1 using Lambda functions and display them on a single dashboard
C) Use Amazon Managed Grafana with data sources configured for CloudWatch in each region
D) Both A and C are valid; A is simpler for CloudWatch-only metrics, C is better for multi-source observability

**Correct Answer: D**
**Explanation:** Both approaches work: (A) CloudWatch natively supports cross-region dashboards. A dashboard in us-east-1 can display widgets referencing metrics from any region by specifying the region in the metric source. This is the simplest option for CloudWatch metrics only. (C) Amazon Managed Grafana can connect to CloudWatch in multiple regions as separate data sources, providing a richer visualization experience with panels showing metrics from different regions, and it can also integrate non-CloudWatch data sources (Prometheus, OpenSearch, etc.). For pure CloudWatch metrics, option A is simpler. For multi-source observability, option C is more powerful.

---

### Question 27
A company runs a batch processing job that processes 10 million records nightly. They need to monitor the job's progress in real-time and alert if the processing rate drops below 100,000 records per minute (indicating a problem that would prevent completion before the 6 AM deadline). Which CloudWatch metric approach provides the most accurate monitoring?

A) Publish a custom CloudWatch metric for "RecordsProcessed" every minute using the COUNT statistic, and create an alarm on the RATE of change using metric math
B) Publish a custom CloudWatch metric for "ProcessingRate" (records/minute) every minute, and alarm when it drops below 100,000
C) Use CloudWatch Logs and count log entries per minute using a Metric Filter
D) Use a CloudWatch dashboard with manual monitoring during the batch window

**Correct Answer: B**
**Explanation:** Publishing the processing rate directly as a custom metric is the most straightforward and accurate approach. The batch job calculates records processed per minute and publishes that value. A simple threshold alarm (< 100,000) triggers when the rate drops. This is more reliable than calculating rates from cumulative counters (Option A), which requires metric math and can produce noisy derivatives. Example: `cloudwatch.put_metric_data(Namespace='BatchJob', MetricName='ProcessingRate', Value=records_this_minute, Unit='Count/Second')`. Option A requires DIFF metric math and is more complex. Option C is indirect and requires well-structured logs. Option D provides no automated alerting.

---

### Question 28
A company has an API Gateway REST API that processes 1 million requests per day. They need to track: per-endpoint latency percentiles (P50, P90, P99), error rates by HTTP status code, and request volume patterns. They also need to identify which API keys are generating the most errors. What monitoring setup should the architect implement?

A) Enable API Gateway detailed CloudWatch metrics (per-method/per-resource/per-stage), enable access logging to CloudWatch Logs with custom format including API key, and use CloudWatch Logs Insights for API key analysis
B) Enable basic API Gateway CloudWatch metrics and use X-Ray for per-endpoint latency
C) Implement custom logging in the Lambda backend functions
D) Use API Gateway's built-in dashboard for all monitoring needs

**Correct Answer: A**
**Explanation:** Detailed CloudWatch metrics (enabled by setting `metricsEnabled` at the method level) provide per-endpoint (resource + method) latency and error metrics with percentile statistics (P50, P90, P99). Access logging to CloudWatch Logs with a custom log format captures the API key ID, response status, latency, and request details for each request. CloudWatch Logs Insights queries can then aggregate errors by API key: `filter status >= 400 | stats count() by apiKeyId | sort count desc`. Option B—basic metrics are aggregated across all endpoints and don't provide per-endpoint breakdowns. Option C misses API Gateway-level metrics (integration latency vs gateway latency). Option D—API Gateway has limited built-in analytics.

---

### Question 29
A company receives alerts when CloudWatch metrics breach thresholds, but the operations team often cannot determine the impact because they lack business context. For example, a CPU alarm fires but the team doesn't know if the affected service handles payment processing or static content. The architect needs to add business context to monitoring.

A) Use CloudWatch metric dimensions to tag services with business context (service-tier: critical/standard, business-function: payments/content)
B) Add business context information to CloudWatch alarm descriptions
C) Implement a CMDB (Configuration Management Database) that maps AWS resources to business services, and enrich alarm notifications with CMDB lookups via Lambda
D) Use AWS Systems Manager OpsCenter to link alarms to operational items with business context, and send enriched notifications to the operations team

**Correct Answer: C**
**Explanation:** A CMDB provides the richest business context: it maps AWS resource ARNs to business services, owners, criticality levels, SLA requirements, and escalation paths. When an alarm fires (via SNS), a Lambda function queries the CMDB, enriches the notification with business context (e.g., "ALARM: High CPU on payment-service-prod | Business Impact: HIGH - Affects $50K/hour in transactions | Owner: payments-team@company.com | Runbook: https://..."), and forwards the enriched notification. Option A adds basic dimensions but has a 30-dimension limit and can't capture rich context. Option B is static and must be manually maintained for 500+ alarms. Option D is useful for operational workflows but doesn't enrich real-time notifications.

---

### Question 30
A company needs to audit all data access to their S3 buckets containing sensitive financial data. They need to know who accessed which objects, when, and from where (source IP). CloudTrail data events are enabled but the volume is 100 GB/day due to high S3 API activity. The architect needs a cost-effective way to analyze this data access audit trail.

A) Keep CloudTrail data events in CloudWatch Logs and use Logs Insights for queries
B) Configure CloudTrail to deliver data events directly to an S3 bucket (not CloudWatch Logs) in JSON format, and use Athena with partition projection for cost-effective querying
C) Use S3 Server Access Logging instead of CloudTrail data events for lower cost
D) Use Amazon Macie to monitor S3 data access patterns

**Correct Answer: B**
**Explanation:** At 100 GB/day, CloudTrail data events directly to S3 is the most cost-effective approach. CloudTrail delivers JSON files to S3, organized by date/region/account (natural partitioning). Athena queries with partition projection enable fast, cost-effective queries ($5/TB scanned). For example: `SELECT useridentity.arn, requestparameters.bucketName, requestparameters.key, eventtime, sourceipaddress FROM cloudtrail_logs WHERE eventname = 'GetObject' AND year='2024' AND month='01' AND day='15'`. At 100 GB/day, CloudWatch Logs ingestion would cost $50/day ($1,500/month) vs S3 storage at ~$0.023/GB ($69/month). Option A is 20x more expensive. Option C—S3 access logs have less detail than CloudTrail and aren't guaranteed delivery. Option D monitors data classification, not access patterns.

---

### Question 31
A company's application running on EC2 publishes custom metrics to CloudWatch. The application emits 500 unique metric names with 3 dimensions each. The team is surprised by the CloudWatch custom metrics bill of $150/month. They expected it to be lower. What is causing the high cost, and how should the architect optimize it?

A) Each unique combination of metric name + dimensions is a separate custom metric; reduce dimensions or use fewer unique values to reduce the number of unique metric combinations
B) The cost is from PutMetricData API calls; batch metrics in fewer API calls
C) Switch from custom metrics to CloudWatch Logs with Metric Filters for lower cost
D) Reduce the metric resolution from high resolution (1 second) to standard (1 minute)

**Correct Answer: A**
**Explanation:** CloudWatch charges $0.30 per custom metric per month. With 500 metric names × 3 dimensions, if each dimension has multiple values, the unique metric count explodes. For example, 500 metrics × 10 dimension-value combinations = 5,000 unique metrics × $0.30 = $1,500/month. To optimize: (1) Reduce the number of dimensions—only include dimensions essential for filtering/aggregation. (2) Use fewer unique dimension values (group similar values). (3) Consider which metrics truly need all three dimensions vs. a subset. The pricing is per unique metric (not per API call or per data point). Option B—API call costs are negligible compared to metric storage. Option C changes the architecture significantly. Option D reduces resolution but not the number of unique metrics.

---

### Question 32
A company has a Step Functions workflow that orchestrates a complex business process. They need to monitor: (1) execution success/failure rates, (2) which states fail most often, (3) average execution duration, and (4) be alerted when the error rate exceeds 5%. What should the architect configure?

A) Use Step Functions' built-in CloudWatch metrics (ExecutionsFailed, ExecutionsSucceeded, ExecutionTime) and create alarms on the error rate using metric math
B) Add custom logging in each Lambda function to track state success/failure
C) Use X-Ray integration with Step Functions for execution monitoring
D) Query Step Functions execution history API and publish custom metrics

**Correct Answer: A**
**Explanation:** Step Functions automatically publishes CloudWatch metrics: `ExecutionsFailed`, `ExecutionsSucceeded`, `ExecutionsStarted`, `ExecutionTime`, `ExecutionThrottled`, and state-level metrics. For error rate alerting, use CloudWatch metric math: `METRICS("m1") / METRICS("m2") * 100` where m1 = ExecutionsFailed and m2 = ExecutionsStarted, alarm when > 5%. State-level metrics identify which states fail most. ExecutionTime provides duration statistics (Average, P50, P99). All of this is available without any custom code. Option B requires modifying Lambda functions. Option C provides trace-level detail but not aggregate metrics. Option D adds unnecessary custom work when native metrics exist.

---

### Question 33
A company has a real-time fraud detection system that must process transactions within 100 milliseconds. They need to monitor the P99 latency and alert if it exceeds 100ms. The system uses Lambda functions. Standard CloudWatch metric resolution (1-minute periods) is too coarse to detect brief latency spikes. What should the architect do?

A) Use CloudWatch high-resolution custom metrics (1-second resolution) to publish latency for each transaction, and create an alarm with a 10-second evaluation period
B) Use X-Ray traces with percentile sampling to monitor P99 latency
C) Log latency to CloudWatch Logs and use Metric Filters with a 10-second period
D) Use Lambda Extensions to collect and report latency metrics at higher frequency

**Correct Answer: A**
**Explanation:** CloudWatch high-resolution custom metrics support 1-second granularity. The Lambda function publishes each transaction's latency as a custom metric with `StorageResolution=1`. A CloudWatch alarm configured with a 10-second period evaluates the P99 statistic of the high-resolution metric, detecting brief latency spikes that would be averaged out in 1-minute periods. At 1-second resolution, even a 5-second spike of high latency is captured. Option B—X-Ray provides latency traces but creating real-time alarms from X-Ray data requires additional work. Option C—Metric Filters don't support sub-minute periods. Option D—Lambda Extensions can collect metrics but still need to publish them; the key is the CloudWatch high-resolution metric capability.

---

### Question 34
A company has 50 AWS accounts and needs to ensure CloudTrail is enabled in all accounts and cannot be disabled by individual account administrators. How should the architect enforce this?

A) Use AWS Organizations with an organization trail that logs events from all member accounts to a central S3 bucket in the management account
B) Create individual trails in each account using CloudFormation StackSets
C) Use SCPs to deny CloudTrail StopLogging and DeleteTrail actions in all member accounts, combined with an organization trail
D) Use AWS Config rules to detect when CloudTrail is disabled and automatically re-enable it

**Correct Answer: C**
**Explanation:** Two complementary controls: (1) An organization trail in the management account automatically logs events from all 50 member accounts. Individual account admins don't need to (and can't) manage this trail. (2) An SCP denying `cloudtrail:StopLogging` and `cloudtrail:DeleteTrail` prevents account admins from disabling or deleting any trails, including account-level trails. Together, these ensure continuous, tamper-proof logging across the organization. Option A provides the trail but doesn't prevent disabling. Option B deploys trails but admins could delete them. Option D detects and remedies but has a gap between detection and remediation.

---

### Question 35
A company's web application experiences periodic 504 Gateway Timeout errors reported by users. The architecture is: CloudFront → ALB → EC2 (Auto Scaling). CloudWatch metrics show no CPU or memory issues on EC2 instances. The architect needs to pinpoint where the timeout occurs. What monitoring data should they analyze?

A) CloudFront access logs (showing origin response time), ALB access logs (showing target response time and processing time), and EC2 application logs
B) VPC Flow Logs to check for network issues between the ALB and EC2
C) CloudWatch metrics for ALB Latency and EC2 NetworkPacketsOut
D) X-Ray traces through the CloudFront → ALB → EC2 path

**Correct Answer: A**
**Explanation:** Analyzing access logs at each tier isolates the timeout source: **CloudFront access logs** show `time-to-first-byte` and `origin-response-time`—if origin-response-time is high, the issue is behind CloudFront. **ALB access logs** show `target_processing_time` (time EC2 took to respond), `request_processing_time` (ALB overhead), and `response_processing_time`. If `target_processing_time` is high, the issue is in the EC2 application; if `request_processing_time` is high, it's ALB-level. **EC2 application logs** reveal what the application was doing during slow requests. This three-tier log analysis pinpoints the exact bottleneck. Option B—flow logs show connection data but not HTTP-level timing. Option C provides aggregate latency but not per-request breakdown. Option D works but requires X-Ray to be enabled and may not cover CloudFront.

---

### Question 36
A company needs to implement centralized logging for their serverless application (API Gateway, Lambda, DynamoDB, Step Functions, SQS). Each service generates different types of logs. The architect must ensure all logs are correlated for end-to-end request tracing. What logging strategy should be implemented?

A) Generate a unique request ID at API Gateway, propagate it through all services via headers and context, include it in all log statements, and use CloudWatch Logs Insights to query across log groups using the request ID
B) Use X-Ray for all tracing and don't implement custom logging
C) Send all logs to a single CloudWatch Logs log group for easier searching
D) Use Lambda PowerTools for structured logging in Lambda only

**Correct Answer: A**
**Explanation:** A correlation ID (request ID) is the foundation of distributed tracing in serverless architectures. API Gateway generates a request ID (`$context.requestId`), passed to Lambda via the event. Lambda includes it in all logs and passes it as a message attribute to SQS, Step Functions input, and DynamoDB metadata. Every log statement includes this ID. CloudWatch Logs Insights can query across multiple log groups: `fields @timestamp, @message | filter requestId = "abc-123" | sort @timestamp`. This provides end-to-end visibility for any request. Option B—X-Ray traces don't capture custom business logic logs. Option C—mixing all logs in one group loses log group-level isolation and filtering. Option D only covers Lambda, not the full chain.

---

### Question 37
A company uses CloudWatch Container Insights for their EKS cluster. They notice high memory usage on certain nodes but can't determine which pods are consuming the most memory. The Container Insights dashboard shows node-level metrics but not pod-level breakdowns. What should the architect do?

A) Use CloudWatch Container Insights performance log events which include pod-level metrics; query with CloudWatch Logs Insights: `stats avg(MemoryUtilization) by PodName | sort avg_MemoryUtilization desc`
B) Deploy Prometheus with a custom Grafana dashboard for pod-level metrics
C) SSH into the nodes and run `kubectl top pods` for real-time memory usage
D) Use the EKS console's built-in pod-level monitoring

**Correct Answer: A**
**Explanation:** CloudWatch Container Insights collects performance log events in CloudWatch Logs that include granular pod-level metrics (CPU, memory, network, filesystem for each pod). These are stored in the `/aws/containerinsights/{cluster-name}/performance` log group. CloudWatch Logs Insights queries against these logs can break down memory by pod: `stats avg(MemoryUtilization) as avg_mem by PodName, Namespace | filter Type="Pod" | sort avg_mem desc | limit 20`. This provides the pod-level breakdown without additional infrastructure. Option B adds infrastructure to manage. Option C is manual and ephemeral. Option D has limited metrics compared to Container Insights logs.

---

### Question 38
A company has a compliance requirement to detect any changes to their AWS infrastructure within 5 minutes and automatically revert unauthorized changes. For example, if someone opens port 22 to 0.0.0.0/0 in a security group, it must be automatically reverted within 5 minutes. What should the architect implement?

A) Use AWS Config rules with automatic remediation using SSM Automation documents that revert the security group to its compliant state
B) Use CloudTrail with a CloudWatch Events rule that detects AuthorizeSecurityGroupIngress events, triggering a Lambda function that checks and reverts non-compliant changes
C) Use GuardDuty to detect security group changes and respond automatically
D) Both A and B work; A is preferred for configuration drift detection while B is preferred for real-time event-based remediation

**Correct Answer: D**
**Explanation:** Both approaches are valid with different strengths: (A) AWS Config rules continuously evaluate resource configuration. A custom or managed rule checks security groups against the compliance policy. When non-compliant, automatic remediation triggers an SSM Automation document that removes the offending rule. Config evaluations typically run within minutes of a change. (B) EventBridge (CloudWatch Events) with CloudTrail integration provides near-real-time (<1 minute) event-driven detection. A rule matches `AuthorizeSecurityGroupIngress` events, and a Lambda function immediately evaluates and reverts non-compliant changes. Option B is faster (seconds vs minutes) while Option A provides continuous compliance posture monitoring. Together, they provide defense in depth.

---

### Question 39
A company runs a Lambda function that processes SQS messages. During peak load, the function occasionally times out after the configured 30-second limit. The team needs to understand what the function is doing during these timeouts—specifically which external API call or database query is blocking. Standard CloudWatch metrics show invocation duration but not internal breakdown. What should the architect implement?

A) Enable X-Ray active tracing on the Lambda function and add X-Ray SDK annotations for each external call (DynamoDB, API calls, S3), providing subsegment-level timing
B) Increase Lambda timeout to 5 minutes and log the total execution time
C) Add console.log timestamps before and after each external call
D) Use Lambda Insights for detailed function profiling

**Correct Answer: A**
**Explanation:** X-Ray active tracing with the X-Ray SDK provides subsegment-level timing for each external call. The SDK automatically instruments AWS SDK calls (DynamoDB, S3, SQS) and can be used to create custom subsegments for HTTP calls to external APIs. Each subsegment shows start time, duration, and any errors. For timed-out invocations, X-Ray traces show exactly which subsegment was in progress when the timeout occurred. Annotations (key-value pairs) and metadata can add context. Option B only extends the timeout without providing debugging info. Option C is manual, verbose, and logs may not flush if the function times out. Option D provides resource utilization but not per-call timing.

---

### Question 40
A company runs an application that uses multiple AWS services across 5 regions. They need a unified view of operational health that shows: service health per region, active incidents, and automated remediation status. The architect must design an operations dashboard.

A) Create a CloudWatch dashboard with cross-region widgets showing key metrics from all regions
B) Use AWS Systems Manager OpsCenter with operational insights aggregated from all regions, integrated with CloudWatch, Config, and Incident Manager
C) Use AWS Health Dashboard API to programmatically check service health and display on a custom dashboard
D) Use AWS Systems Manager Explorer for a multi-account, multi-region operational data aggregation view, combined with OpsCenter for incident management

**Correct Answer: D**
**Explanation:** Systems Manager Explorer provides a customizable operational data dashboard aggregating data across accounts and regions: OpsData summaries, Config compliance, EC2 instances status, patch compliance, and more. OpsCenter manages operational issues (OpsItems) with automated remediation via Automation runbooks. Together they provide: service health visualization (Explorer), active incident tracking (OpsCenter with Incident Manager integration), and automated remediation status (Automation execution history). This is the most comprehensive native operations dashboard. Option A shows metrics but lacks incident management. Option B is a subset. Option C only shows AWS service health, not application health.

---

### Question 41
A company's CloudWatch bill has increased by 300% over the past 6 months. They have 200 log groups generating 2 TB of logs per day. After analysis, 60% of the logs are DEBUG level from development Lambda functions that were accidentally deployed with verbose logging to production. How should the architect reduce CloudWatch Logs costs?

A) Delete all DEBUG log groups
B) Implement log-level filtering in the application code to only emit WARN and above in production, set shorter retention periods for non-critical log groups, and use CloudWatch Logs data access policies to prevent verbose logging in production
C) Move all logs to S3 using Kinesis Data Firehose and cancel CloudWatch Logs
D) Use CloudWatch Logs Insights instead of storing logs to reduce costs

**Correct Answer: B**
**Explanation:** A multi-pronged approach: (1) Set environment variables (LOG_LEVEL=WARN) in production Lambda functions so they only emit WARN/ERROR/FATAL messages, eliminating 60% of log volume (1.2 TB/day saved × $0.50/GB = $600/day savings). (2) Set appropriate retention periods: 30 days for most log groups, 7 days for high-volume non-critical logs, 90+ days for compliance-required logs. (3) Implement CI/CD checks that prevent DEBUG-level logging in production deployments. This addresses both the immediate cost and the root cause. Option A deletes historical logs that may be needed. Option C loses real-time querying capability. Option D—Logs Insights queries logs already ingested; it doesn't reduce ingestion costs.

---

### Question 42
A company needs to monitor the performance of their Amazon RDS PostgreSQL database. They need to identify: slow queries, lock contention, wait events, and resource bottlenecks. The DBA team is small and needs a managed solution. What should the architect recommend?

A) Enable RDS Performance Insights with 7-day retention (free tier) to identify top SQL queries, wait events, and resource bottlenecks, and enable Enhanced Monitoring for OS-level metrics
B) Enable the PostgreSQL pg_stat_statements extension and query it manually
C) Use CloudWatch RDS metrics (CPUUtilization, ReadIOPS, WriteIOPS) for all monitoring needs
D) Deploy a third-party database monitoring tool on an EC2 instance

**Correct Answer: A**
**Explanation:** RDS Performance Insights provides: (1) A visual dashboard showing database load broken down by wait events (CPU, I/O, Lock, IPC), SQL queries, hosts, and users. (2) Top SQL queries ranked by database load, with query plans. (3) Wait event analysis showing what queries are waiting for (lock contention, I/O waits). The 7-day retention is free. Combined with Enhanced Monitoring (OS-level metrics: CPU, memory, file system, network at 1-60 second granularity), this provides comprehensive database observability. Option B provides query stats but no visualization or wait event analysis. Option C provides high-level metrics but can't identify slow queries or lock contention. Option D adds operational overhead.

---

### Question 43
A company runs a real-time bidding (RTB) platform that processes 50,000 requests per second with a strict 100ms SLA. They need to monitor the percentage of requests exceeding 100ms and alert when more than 1% of requests breach the SLA in any 1-minute window. How should the architect implement this SLA monitoring?

A) Publish request latency as a CloudWatch custom metric and use extended statistics (p99) with an alarm
B) Publish a custom CloudWatch metric "SLABreach" with value 1 for breaches and 0 for compliant requests, use metric math to calculate the breach percentage, and alarm when it exceeds 1%
C) Use an ALB's TargetResponseTime metric percentile statistic with a CloudWatch alarm
D) Log all request latencies to CloudWatch Logs and use a Metric Filter to count breaches, then alarm on the count

**Correct Answer: B**
**Explanation:** Publishing individual SLA breach/compliance events as CloudWatch metric data points enables precise percentage calculations. The metric "SLABreach" receives a data point for each request: 1 if latency > 100ms, 0 if compliant. Using metric math: `SUM(SLABreach) / SAMPLE_COUNT(SLABreach) * 100` calculates the breach percentage over any evaluation period. An alarm triggers when this exceeds 1%. At 50,000 requests/second, this is more efficient than analyzing P99 (Option A—P99 at 100ms means more than 1% exceeded, but p99 doesn't give the exact percentage). Option C—ALB percentiles work but don't give exact breach percentages. Option D—at 50,000 RPS, log-based monitoring is expensive and slower.

---

### Question 44
A company migrated to AWS and the security team requires that all AWS API calls are logged and tamper-proof. They also need to detect if logging is ever interrupted. What comprehensive CloudTrail configuration should the architect implement?

A) Enable a multi-region CloudTrail trail with log file integrity validation, deliver logs to an S3 bucket with Object Lock (WORM), enable CloudTrail Insights for unusual activity detection, and create a CloudWatch alarm on CloudTrail's own delivery errors
B) Enable CloudTrail in each region separately and aggregate logs with S3 replication
C) Enable CloudTrail and deliver to CloudWatch Logs only
D) Use AWS Config to monitor CloudTrail configuration

**Correct Answer: A**
**Explanation:** Comprehensive CloudTrail setup: (1) Multi-region trail captures API calls in all regions (current and future). (2) Log file integrity validation creates hash chains—any tampering is detectable. (3) S3 Object Lock (Compliance mode) makes logs immutable—no one (including root) can delete them during the retention period. (4) CloudTrail Insights detects unusual API activity patterns. (5) CloudWatch alarm on CloudTrail's `CloudTrailMetrics.DeliveryError` metric detects if log delivery is interrupted. This provides complete, tamper-proof audit trail with gap detection. Option B misses new regions and lacks integrity validation. Option C misses S3 delivery (long-term storage) and integrity validation. Option D detects config changes but doesn't address log tamper-proofing.

---

### Question 45
A company uses Amazon OpenSearch Service for log analytics. Their 30-day log retention totals 10 TB. They need to reduce costs while maintaining the ability to search recent logs (last 7 days) quickly and older logs (7-30 days) with acceptable performance. What storage tiering should the architect implement?

A) Use OpenSearch UltraWarm for 7-30 day data and hot storage for 0-7 day data, with Index State Management (ISM) policies to automatically transition indices
B) Delete logs older than 7 days to reduce storage
C) Use a single hot storage tier with smaller instance types
D) Move all logs to S3 and use OpenSearch direct queries from S3

**Correct Answer: A**
**Explanation:** OpenSearch storage tiers optimize cost/performance: **Hot storage** (0-7 days): SSD-backed instances for fast queries on recent data. **UltraWarm** (7-30 days): S3-backed warm storage that costs ~90% less than hot storage, with acceptable query performance for less frequently accessed data. Index State Management (ISM) policies automatically transition indices from hot to UltraWarm based on age (e.g., after 7 days). This can reduce storage costs by 60-80% while maintaining searchability. Option B loses 23 days of compliance data. Option C doesn't reduce costs. Option D loses real-time search capability in OpenSearch.

---

### Question 46
A company needs to implement real-time log analysis that detects patterns across multiple log sources simultaneously. For example, they want to detect when: (1) a failed login attempt in CloudTrail is followed by (2) a new security group rule in the same account within 5 minutes, which together indicate a potential security breach. What should the architect use?

A) CloudWatch Logs Insights scheduled queries that join across log groups
B) Amazon OpenSearch with cross-cluster search and alerting rules
C) Amazon EventBridge rules with pattern matching across multiple event sources
D) Amazon Security Lake with Amazon Athena for cross-source correlation, combined with EventBridge for real-time alerting on specific CloudTrail event patterns

**Correct Answer: D**
**Explanation:** This cross-source correlation requires: (1) **Amazon Security Lake** normalizes and centralizes security logs (CloudTrail, VPC Flow Logs, etc.) in Open Cybersecurity Schema Framework (OCSF) format, enabling cross-source analysis. (2) **Athena** queries Security Lake for complex correlation patterns: finding failed logins followed by security group changes within 5-minute windows. (3) **EventBridge** provides real-time detection of individual high-risk events. For the described use case, GuardDuty would also detect this pattern natively (UnauthorizedAccess findings), but the general approach for custom cross-source correlation is Security Lake + Athena. Option A—Logs Insights can't join across log groups in a single query. Option B requires running OpenSearch. Option C matches individual events, not temporal patterns across sources.

---

### Question 47
A company's operations team receives CloudWatch alarm notifications via SNS email. They want to enhance the notification to include: (1) a link to the relevant CloudWatch dashboard, (2) the last 5 values of the metric, (3) suggested remediation actions, and (4) the on-call engineer's contact information from PagerDuty. How should the architect implement these enriched notifications?

A) Customize the SNS email template to include all the required information
B) Configure the CloudWatch alarm to trigger a Lambda function that queries CloudWatch for recent metric data, constructs an enriched notification with dashboard links and remediation actions, looks up the PagerDuty on-call schedule, and sends the notification via SNS/email
C) Use AWS Chatbot to send enriched notifications to Slack/Teams
D) Use CloudWatch alarm descriptions to embed all static information

**Correct Answer: B**
**Explanation:** A Lambda enrichment function provides maximum customization: (1) Construct CloudWatch dashboard URLs dynamically from the alarm's namespace and metric name. (2) Use GetMetricData API to fetch the last 5 data points. (3) Look up remediation actions from a DynamoDB table mapped by alarm name. (4) Query PagerDuty's API for the current on-call engineer. (5) Format everything into a rich HTML email and send via SES or SNS. This creates actionable, contextual notifications that help the team respond faster. Option A—SNS email templates have limited customization. Option C—Chatbot provides basic notifications but not the custom enrichment described. Option D only handles static information.

---

### Question 48
A company has enabled VPC Flow Logs, CloudTrail, and GuardDuty across 20 accounts. They need to investigate a security incident where an EC2 instance in one account may have been compromised and used to access resources in other accounts. The security team needs to trace the attacker's lateral movement across accounts. What tool should the architect recommend?

A) Amazon Detective, which automatically correlates data from VPC Flow Logs, CloudTrail, and GuardDuty across accounts to visualize lateral movement
B) Manual analysis of CloudTrail logs from all 20 accounts
C) GuardDuty multi-account findings analysis
D) AWS Security Hub cross-account findings dashboard

**Correct Answer: A**
**Explanation:** Amazon Detective is purpose-built for security investigation across accounts. It automatically ingests and correlates VPC Flow Logs, CloudTrail, and GuardDuty findings, creating a behavior graph that links entities (IP addresses, IAM roles, EC2 instances) across accounts. For lateral movement investigation: Detective visualizes which resources the compromised instance communicated with, which IAM roles were assumed cross-account, and the timeline of activities. Interactive drill-down shows the full attack path. Option B is time-consuming and error-prone across 20 accounts. Option C shows findings but doesn't provide investigation visualizations. Option D aggregates findings but doesn't enable deep investigation.

---

### Question 49
A company runs a machine learning training pipeline on SageMaker. Training jobs run for 2-12 hours. They need to monitor training progress (loss function, accuracy metrics) in real-time and alert if a training job appears to be diverging (loss increasing over time). What should the architect implement?

A) Use SageMaker built-in metric emission to CloudWatch, creating CloudWatch dashboards for training metrics and anomaly detection alarms on the loss metric
B) Use SageMaker Debugger with built-in rules that detect issues like loss not decreasing, vanishing gradients, and overfitting, with automatic CloudWatch alarms and SNS notifications
C) Log metrics to CloudWatch from the training script and monitor manually
D) Use SageMaker Experiments to track training metrics post-hoc

**Correct Answer: B**
**Explanation:** SageMaker Debugger provides built-in rules specifically designed for ML training monitoring: `LossNotDecreasing` detects when the loss function stops decreasing, `VanishingGradient` detects gradient issues, `Overfit` detects train/validation divergence. Debugger runs these rules in real-time alongside training, triggers CloudWatch alarms, and can automatically stop unprofitable training jobs (saving compute costs). It requires minimal configuration—just specifying which rules to enable. Option A provides basic metric monitoring but doesn't have ML-specific anomaly detection. Option C is manual and lacks automated rules. Option D is for post-training analysis, not real-time monitoring.

---

### Question 50
A company has CloudWatch alarms across 200 AWS resources. When multiple related alarms fire simultaneously (e.g., database issue causes API errors, which causes frontend timeouts), the team receives 30+ individual notifications. They need a way to group related alarms and identify the root cause. What should the architect implement?

A) Use CloudWatch composite alarms to create hierarchical alarm trees where infrastructure alarms suppress application alarms
B) Use Amazon DevOps Guru to automatically detect and group related anomalies and identify the root cause
C) Use CloudWatch Alarm suppression to manually suppress downstream alarms
D) Route all alarms to a Lambda function that implements correlation logic using time-window-based grouping

**Correct Answer: B**
**Explanation:** Amazon DevOps Guru uses ML to automatically correlate related operational anomalies (CloudWatch metrics, logs, events) and groups them into "insights." When the database issue causes a cascade (database → API → frontend), DevOps Guru identifies the database as the root cause and presents a single insight rather than 30+ individual alarms. It provides: anomaly grouping, root cause identification, related resource visualization, and remediation recommendations. Option A requires manually designing the alarm hierarchy. Option C requires knowing which alarms to suppress in advance. Option D requires building custom ML-like correlation logic.

---

### Question 51
A company needs to audit and monitor all changes to their CloudFormation stacks across the organization. They want to detect: unauthorized stack modifications, drift from intended configurations, and failed stack operations. What combination provides comprehensive CloudFormation monitoring?

A) CloudTrail events for CloudFormation API calls, AWS Config rules for CloudFormation drift detection, and CloudWatch Events (EventBridge) rules for stack status changes
B) CloudFormation stack events log for monitoring
C) CloudTrail alone for all CloudFormation monitoring
D) AWS Config with a custom rule that checks CloudFormation template compliance

**Correct Answer: A**
**Explanation:** Three complementary monitoring layers: (1) **CloudTrail** captures WHO performed CloudFormation operations (CreateStack, UpdateStack, DeleteStack) and from where (source IP, assumed role). (2) **AWS Config** with the `cloudformation-stack-drift-detection-check` managed rule periodically detects when actual resource configurations drift from the template, catching manual changes. (3) **EventBridge** rules match CloudFormation stack status change events (`CREATE_FAILED`, `UPDATE_ROLLBACK_COMPLETE`, `DELETE_IN_PROGRESS`) for real-time alerting on operational issues. Together they provide: audit trail (CloudTrail), configuration compliance (Config drift), and operational monitoring (EventBridge). Options B, C, D each cover only one dimension.

---

### Question 52
A company's application experiences a gradual performance degradation over several days—response time increases from 200ms to 2 seconds over a week. Individual CloudWatch metrics (CPU, memory, network) show gradual increases but never breach any threshold. The team needs to detect this type of slow degradation proactively. What should the architect implement?

A) Lower the CloudWatch alarm thresholds so they trigger earlier in the degradation
B) Use CloudWatch anomaly detection on key performance metrics, which learns the normal pattern and alerts when the trend deviates from the expected band
C) Implement trending analysis: use CloudWatch metric math with METRICS expressions to calculate the rate of change (derivative) of latency, and alarm when the rate of increase exceeds a threshold
D) Use Amazon DevOps Guru which automatically detects gradual anomalies that static thresholds miss

**Correct Answer: D**
**Explanation:** Amazon DevOps Guru uses ML to analyze CloudWatch metrics and detect anomalous patterns, including gradual degradation that doesn't breach static thresholds. It learns the normal baseline and detects when metrics trend abnormally—even if no individual metric breaches a threshold. For a week-long gradual degradation, DevOps Guru would identify the trend after several days and generate a proactive insight with likely root causes and related resources. Option A—lowering thresholds causes false positives during normal traffic variations. Option B works for individual metrics but doesn't correlate across multiple metrics. Option C requires knowing which metric to watch and defining what rate is abnormal.

---

### Question 53
A company has 1,000 Lambda functions across their organization. They need to identify functions that are: (1) over-provisioned (allocated more memory than needed), (2) under-provisioned (would run faster with more memory), and (3) not using their allocated concurrency. What tool should the architect use?

A) CloudWatch Lambda Insights with custom dashboards for each function
B) AWS Compute Optimizer, which analyzes Lambda function CloudWatch metrics and provides memory and concurrency optimization recommendations
C) AWS Cost Explorer to analyze Lambda costs per function
D) Manually profile each function with AWS Lambda Power Tuning

**Correct Answer: B**
**Explanation:** AWS Compute Optimizer analyzes Lambda function metrics (memory utilization, execution duration, invocation count) over time and provides specific recommendations: "Function X is over-provisioned at 1024 MB—reduce to 256 MB for 60% cost savings" or "Function Y would complete 40% faster with 512 MB instead of 128 MB." It handles all 1,000 functions automatically without manual profiling. Option A requires creating 1,000 custom dashboards. Option C shows costs but not optimization opportunities. Option D is excellent for individual function tuning but doesn't scale to 1,000 functions.

---

### Question 54
A company runs a critical application and needs to implement automated incident management. When a production issue is detected, the system should: create an incident record, page the on-call engineer, start a chat channel for collaboration, track the timeline, and automatically run diagnostic scripts. What AWS service combination should the architect use?

A) CloudWatch Alarms → SNS → PagerDuty integration with manual incident tracking
B) CloudWatch Alarms → AWS Incident Manager (part of Systems Manager), which provides automated incident creation, escalation plans, chat channels (via AWS Chatbot), runbook execution (SSM Automation), and timeline tracking
C) CloudWatch Alarms → Lambda → Custom incident management system
D) Use third-party incident management exclusively (PagerDuty/OpsGenie)

**Correct Answer: B**
**Explanation:** AWS Incident Manager provides end-to-end incident management natively: (1) **Response plans** define what happens when an alarm triggers: create an incident, engage responders, start a chat channel. (2) **Escalation plans** page the on-call engineer and escalate if no response. (3) **AWS Chatbot integration** creates a dedicated Slack/Teams channel for incident collaboration. (4) **SSM Automation runbooks** execute diagnostic scripts automatically (check logs, capture system state, scale resources). (5) **Timeline** automatically tracks all actions taken during the incident. Option A requires manual steps and third-party integration. Option C requires building custom tools. Option D doesn't integrate natively with AWS services.

---

### Question 55
A company has a data pipeline that processes events from Kinesis Data Streams to Lambda to DynamoDB. They notice that some events are being processed twice (Lambda retry on failure). They need to monitor and alert on the duplicate processing rate. How should the architect implement this?

A) Use X-Ray to identify duplicate trace IDs
B) Implement idempotency tracking in DynamoDB: write a dedup record for each event ID. Monitor the ConditionalCheckFailedException metric (which occurs when a duplicate event attempts to write an already-existing record), and create a CloudWatch alarm when the rate exceeds a threshold
C) Monitor the Lambda Errors metric as a proxy for duplicate processing
D) Count events in Kinesis and events written to DynamoDB; the difference indicates duplicates

**Correct Answer: B**
**Explanation:** The idempotency pattern with DynamoDB conditional writes provides both duplicate prevention AND monitoring. Each event processing attempts a ConditionalPutItem (PutItem with ConditionExpression "attribute_not_exists(eventId)"). First processing succeeds; duplicate attempts throw ConditionalCheckFailedException. CloudWatch natively exposes the ConditionalCheckFailedException count as a DynamoDB metric. An alarm on this metric directly measures the duplicate rate. Option A—X-Ray doesn't track duplicate event processing. Option C—Lambda errors include all error types, not just duplicates. Option D—timing differences between pipeline stages make this comparison unreliable.

---

### Question 56
A company needs to ensure their CloudWatch Logs are exported to S3 for long-term archival in near-real-time (within 5 minutes). They currently use CloudWatch Logs export tasks (CreateExportTask API) but find them unreliable—exports fail intermittently and the team often discovers gaps in the exported data. What should the architect do?

A) Schedule more frequent export tasks using EventBridge
B) Replace export tasks with a CloudWatch Logs subscription filter delivering to Kinesis Data Firehose, which delivers to S3 with configurable buffering (size/time) and guaranteed delivery
C) Use AWS Backup for CloudWatch Logs
D) Manually monitor export task failures and retry

**Correct Answer: B**
**Explanation:** Subscription filters with Kinesis Data Firehose provide reliable, near-real-time log delivery to S3. Firehose buffers data and delivers based on configurable thresholds (size: 1-128 MB, time: 60-900 seconds). Key advantages over export tasks: (1) Near-real-time delivery (minutes, not hours). (2) Automatic retry on delivery failures. (3) Partitioning by date/hour for efficient querying. (4) Compression (GZIP) for cost savings. (5) No gaps—subscription filters receive all log events as they're ingested. Export tasks (CreateExportTask) are designed for one-time or periodic bulk exports and have concurrency limits. Option A doesn't fix the reliability issues. Option C doesn't support CloudWatch Logs export. Option D is not scalable.

---

### Question 57
A company uses AWS X-Ray and notices that their service map shows a microservice with a high error rate, but the errors only occur for specific customer segments. They need to analyze X-Ray data to understand which customer segments are affected and what distinguishes failing requests from successful ones. How should they approach this?

A) Add X-Ray annotations for customer segment, plan type, and region on each trace, then use X-Ray filter expressions and the X-Ray Analytics console to compare failing vs. successful traces across these dimensions
B) Grep CloudWatch Logs for error messages and correlate with customer data
C) Export X-Ray traces to S3 and analyze with Athena
D) Use X-Ray groups to separate customer segments and compare error rates

**Correct Answer: A**
**Explanation:** X-Ray annotations are indexed key-value pairs searchable via filter expressions. By annotating each trace with customer metadata (segment, plan, region), the X-Ray Analytics console can compare trace distributions: filter `annotation.customer_segment = "enterprise"` vs. `annotation.customer_segment = "free"` to see error rate differences. The response time distribution view shows whether errors correlate with specific segments. Filter expressions like `service("payment-service") AND annotation.plan_type = "premium" AND error = true` isolate the exact failure patterns. Option B doesn't leverage X-Ray's built-in analytics. Option C adds unnecessary steps. Option D would require creating a group per segment, which doesn't scale.

---

### Question 58
A company has implemented comprehensive monitoring but suffers from "dashboard overload"—they have 50+ CloudWatch dashboards that no one regularly reviews. The architect needs to streamline monitoring to ensure important issues are detected without relying on human dashboard review. What approach should be implemented?

A) Consolidate all dashboards into 3-5 key dashboards and schedule regular review meetings
B) Implement a "monitoring pyramid": automated alarms at the base (high coverage, detect all issues), composite alarms in the middle (reduce noise, correlate symptoms), and a single executive health dashboard at the top (overall system health)
C) Replace dashboards with pure alert-based monitoring
D) Use Amazon Managed Grafana with automated reporting

**Correct Answer: B**
**Explanation:** The monitoring pyramid provides layered observability: **Base layer (automated alarms):** Individual CloudWatch alarms on all important metrics across all services. These run 24/7 and detect issues automatically—no human review needed. **Middle layer (composite alarms):** Group related individual alarms to reduce noise and identify genuine multi-symptom issues. For example, a "payment-health" composite alarm combines payment service CPU, error rate, and database latency alarms. **Top layer (executive dashboard):** A single dashboard showing the status of all composite alarms—green (healthy) or red (issue). One glance shows system health. This eliminates the need to review 50 dashboards while maintaining comprehensive monitoring. Option A still requires human review. Option C loses visual troubleshooting capability. Option D improves visualization but doesn't address the fundamental monitoring strategy.

---

### Question 59
A company needs to implement log correlation between their on-premises applications and AWS-hosted microservices. On-premises applications log to files, while AWS services use CloudWatch Logs. The team needs a single search interface across both environments.

A) Install the CloudWatch agent on on-premises servers to forward logs to CloudWatch Logs, then use CloudWatch Logs Insights for unified search
B) Use Amazon OpenSearch Service with Filebeat on on-premises servers and Fluentd/Fluent Bit for AWS services, all feeding into OpenSearch for unified search and visualization
C) Use AWS DataSync to copy on-premises log files to S3 and query with Athena alongside CloudWatch Logs exported to S3
D) Use syslog forwarding from on-premises to a centralized server in AWS

**Correct Answer: B**
**Explanation:** OpenSearch provides the most robust unified search experience: **On-premises**: Filebeat (lightweight log shipper) collects logs from files and ships to OpenSearch (via Amazon OpenSearch Ingestion or direct). **AWS**: Fluent Bit DaemonSet/sidecar collects container/application logs, and CloudWatch Logs subscription filters can also stream to OpenSearch. OpenSearch provides: full-text search across all sources, interactive dashboards (OpenSearch Dashboards), alerting, and anomaly detection. A unified index allows cross-environment queries. Option A works for AWS-centric monitoring but requires on-premises servers to reach CloudWatch API endpoints. Option C has high latency (batch copy, not real-time). Option D is a partial solution without search capabilities.

---

### Question 60
A company needs to track API usage patterns for their REST API served by API Gateway. They want to: identify peak usage times, track which endpoints are most popular, monitor average request sizes, and detect unusual usage patterns (potential abuse). The API serves 10 million requests per day.

A) Enable API Gateway access logging to CloudWatch Logs in JSON format, then use CloudWatch Logs Insights for analysis and CloudWatch Contributor Insights for top-N analysis
B) Use API Gateway built-in usage plans and API keys for tracking
C) Analyze API Gateway CloudWatch metrics (Count, Latency, 4xxError, 5xxError) only
D) Build a custom analytics pipeline with Kinesis Data Analytics

**Correct Answer: A**
**Explanation:** API Gateway access logging in JSON format captures: timestamp, HTTP method, resource path, status code, response length, latency, and API key per request. **CloudWatch Logs Insights** enables rich analysis: peak usage (`stats count() by bin(1h)`), popular endpoints (`stats count() by resourcePath | sort count desc`), average request sizes (`stats avg(responseLength) by resourcePath`). **CloudWatch Contributor Insights** automatically identifies top-N contributors (top callers, top endpoints, top error sources) and detects unusual patterns. Together they provide comprehensive API analytics without custom infrastructure. Option B tracks per-key quotas but not the detailed analytics described. Option C provides aggregate metrics only. Option D is over-engineered for this use case.

---

### Question 61
A company operates a high-frequency trading system where every millisecond of latency matters. They need to monitor network latency between their EC2 instances and AWS services (DynamoDB, SQS) with sub-millisecond accuracy. Standard CloudWatch metrics don't provide this granularity. What should the architect implement?

A) Use VPC Flow Logs with maximum capture window for network timing analysis
B) Implement application-level latency instrumentation using high-resolution timers in the application code, publishing custom CloudWatch metrics at 1-second resolution
C) Use AWS CloudWatch Network Monitor for monitoring paths to AWS services
D) Use the AWS SDK's built-in metric publishing feature which captures per-call latency for all AWS service interactions

**Correct Answer: D**
**Explanation:** The AWS SDK (v2 for Java, v3 for JavaScript/Python) includes built-in metric publishers that capture per-call latency metrics: `ApiCallDuration`, `MarshallingDuration`, `CredentialsFetchDuration`, `ServiceCallDuration`, `RetryCount`, etc. These are emitted with microsecond precision and can be published to CloudWatch as custom metrics. This provides the most accurate measurement of actual service call latency from the application's perspective, including network, serialization, and processing time. Option A—VPC Flow Logs don't capture application-layer latency. Option B works but requires custom instrumentation. Option C monitors network paths, not application-to-service latency.

---

### Question 62
A company has enabled Amazon GuardDuty across 50 accounts in their organization. GuardDuty generates approximately 100 findings per day. The security team wants to: (1) automatically remediate critical findings, (2) create JIRA tickets for high-severity findings, and (3) aggregate all findings for reporting. What architecture should the architect design?

A) GuardDuty → EventBridge rule matching critical findings → Lambda for auto-remediation; EventBridge rule matching high-severity findings → Lambda → JIRA API; GuardDuty → Security Hub for aggregation and reporting
B) GuardDuty → SNS topic → Lambda for all processing
C) GuardDuty → CloudWatch Logs → Metric Filters for alerting
D) Manual review of GuardDuty console daily

**Correct Answer: A**
**Explanation:** A tiered response architecture: (1) **Auto-remediation**: EventBridge rule matches critical GuardDuty findings (e.g., `{"source": ["aws.guardduty"], "detail": {"severity": [{"numeric": [">=", 7]}]}}`) and triggers a Lambda function that performs automated remediation (isolate compromised instance, revoke compromised credentials, block malicious IPs). (2) **JIRA integration**: Another EventBridge rule matches high-severity findings and triggers a Lambda that creates JIRA tickets via the JIRA API with finding details. (3) **Aggregation**: Security Hub aggregates GuardDuty findings from all 50 accounts, providing centralized dashboards and compliance reporting. This provides automated, prioritized, and documented security response. Option B routes everything through a single Lambda, creating a complex function. Options C and D lack automation.

---

### Question 63
A company's application logs include request IDs that should be unique but occasionally duplicate request IDs appear, indicating a retry that wasn't caught by the deduplication logic. The team needs to identify the frequency and pattern of these duplicates from 100 GB of daily logs. What is the most efficient analysis approach?

A) Use CloudWatch Logs Insights query: `stats count() as cnt by requestId | filter cnt > 1 | sort cnt desc`
B) Export logs to S3 and use Athena: `SELECT requestId, COUNT(*) as cnt FROM logs GROUP BY requestId HAVING COUNT(*) > 1`
C) Write a Lambda function that reads all logs and counts duplicates in memory
D) Both A and B work; A is simpler for ad-hoc analysis, B is cheaper for repeated analysis at this volume

**Correct Answer: D**
**Explanation:** Both approaches work with different trade-offs: **(A) CloudWatch Logs Insights** runs the query directly against CloudWatch Logs. At 100 GB, it costs $0.005/GB = $0.50 per query and runs in seconds. Great for ad-hoc, one-time analysis. **(B) Athena** queries logs in S3 (if already exported). With Parquet compression (100 GB → ~20 GB), it costs $5/TB × 0.02 TB = $0.10 per query. Better for repeated analysis, and the data is already in S3 for archival. For a one-time investigation, Logs Insights (A) is simpler. For a recurring analysis on large volumes, Athena (B) is more cost-effective. Option C is impractical for 100 GB in Lambda's memory constraints.

---

### Question 64
A company wants to implement Service Level Objectives (SLOs) for their application. The SLO states: "99.9% of API requests should respond within 500ms, measured over a 30-day rolling window." The architect needs to implement SLO monitoring with an error budget calculation. How should this be designed?

A) Use a CloudWatch alarm with a 500ms latency threshold at P99.9
B) Implement a custom SLO tracking system: use CloudWatch Metric Filters to count requests > 500ms ("bad events") and total requests ("valid events"), use CloudWatch metric math to calculate the error budget remaining (allowed bad events - actual bad events), create an alarm when the error budget drops below 10%
C) Use Amazon Managed Service for Prometheus with Grafana SLO dashboards
D) Use AWS Service Level Agreements as the SLO framework

**Correct Answer: B**
**Explanation:** SLO monitoring with error budgets requires: (1) **Count bad events**: Metric Filter counting requests where latency > 500ms. (2) **Count total events**: Metric Filter counting all requests. (3) **Calculate error budget**: Over a 30-day window, the SLO allows 0.1% bad events. For 10M requests/month, the error budget is 10,000 bad events. Use metric math: `error_budget_remaining = (0.001 * total_events) - bad_events`. (4) **Alarm on budget burn rate**: Alert when the error budget consumption rate suggests the budget will be exhausted before the 30-day window ends. This provides a proactive SLO management system. Option A gives a point-in-time check, not a rolling window error budget. Option C is valid but requires deploying Prometheus/Grafana. Option D—AWS SLAs are AWS's commitments, not customer SLOs.

---

### Question 65
A company's application uses ElastiCache Redis. They need to monitor: cache hit ratio, memory usage, eviction rate, and connection count. They want alerts when the cache hit ratio drops below 80% (indicating the cache is ineffective) and when evictions occur (indicating memory pressure). What should the architect configure?

A) Use CloudWatch metrics for ElastiCache: CacheHitRate (calculated from CacheHits / (CacheHits + CacheMisses) using metric math), BytesUsedForCache, Evictions, and CurrConnections, with alarms on hit rate and evictions
B) Monitor ElastiCache using Redis INFO command output
C) Use CloudWatch Container Insights for ElastiCache monitoring
D) Deploy a Redis monitoring sidecar container

**Correct Answer: A**
**Explanation:** ElastiCache publishes key metrics to CloudWatch: `CacheHits` and `CacheMisses` (use metric math: `m1 / (m1 + m2) * 100` for hit rate), `BytesUsedForCache` (memory usage), `Evictions` (items evicted due to memory pressure), `CurrConnections` (active client connections). Create alarms: (1) Cache hit rate < 80% using metric math alarm. (2) Evictions > 0 as a warning, > 100/minute as critical (indicating significant memory pressure). The dashboard shows trends in all four metrics for capacity planning. Option B requires managing connections to Redis and custom metric publishing. Option C is for containers, not ElastiCache. Option D adds unnecessary infrastructure.

---

### Question 66
A company has a serverless application and wants to implement comprehensive error tracking. When a Lambda function throws an unhandled exception, they want: the full stack trace, the input event that caused the error, related X-Ray trace, and a link to the relevant CloudWatch Logs. All of this should be visible in a single interface. What should the architect recommend?

A) Use CloudWatch Lambda Insights combined with X-Ray
B) Use AWS Lambda Powertools combined with X-Ray for structured error logging that includes event context, then use CloudWatch ServiceLens to correlate logs, metrics, and traces in a single view
C) Send all errors to an SNS topic for manual investigation
D) Use Sentry or Datadog for Lambda error tracking

**Correct Answer: B**
**Explanation:** Lambda Powertools provides structured logging with automatic inclusion of the Lambda context, correlation IDs, and error details (stack traces). When combined with X-Ray active tracing, CloudWatch ServiceLens brings everything together: it correlates CloudWatch Logs (with the full stack trace and event), CloudWatch Metrics (error count, duration), and X-Ray traces (request path, subsegment timing) into a single interface. Clicking on a trace shows the associated logs and metrics. This provides the complete error investigation experience described. Option A provides metrics and traces but not structured error logging. Option C requires manual correlation. Option D adds external dependencies.

---

### Question 67
A company runs a data lake on S3 with Athena for queries. They need to monitor Athena query performance: execution times, data scanned, failed queries, and cost per query. They also want to alert when a single query scans more than 1 TB of data (costing > $5). What monitoring approach should the architect implement?

A) Use Athena's built-in query history and metrics in the AWS console
B) Enable CloudTrail data events for Athena, create EventBridge rules for query completion events, extract query statistics (data scanned, execution time) via Lambda, publish as CloudWatch custom metrics, and alarm when data scanned exceeds 1 TB
C) Use CloudWatch metrics for Athena (EngineExecutionTime, TotalExecutionTime, DataScannedInBytes) and create an alarm on DataScannedInBytes exceeding 1 TB per query
D) Query the Athena query execution history table with Athena itself

**Correct Answer: B**
**Explanation:** Athena publishes limited CloudWatch metrics at the workgroup level (aggregate). For per-query monitoring: EventBridge captures Athena query state change events (`SUCCEEDED`, `FAILED`). Each event includes query execution ID. A Lambda function calls `GetQueryExecution` to get detailed statistics (data scanned, execution time, query string). It publishes per-query custom CloudWatch metrics and triggers an alarm when a single query scans > 1 TB. This provides per-query granularity. Option A is manual, not automated. Option C has workgroup-level aggregate metrics, not per-query. Option D creates recursive dependency.

---

### Question 68
A company needs to implement a log retention strategy across their AWS environment. Different log types have different retention requirements: security logs (7 years), application logs (90 days), debug logs (7 days), and VPC Flow Logs (1 year). They have 500 CloudWatch Logs log groups. How should the architect enforce these retention policies consistently?

A) Manually set retention periods on each log group
B) Use a Lambda function triggered daily that categorizes log groups by naming convention (e.g., `/security/`, `/app/`, `/debug/`, `/vpc-flow/`) and applies the appropriate retention period using the PutRetentionPolicy API
C) Use AWS Organizations SCP to enforce log retention
D) Use AWS Config custom rule that checks log group retention periods and auto-remediates non-compliant groups using SSM Automation

**Correct Answer: D**
**Explanation:** AWS Config with a custom rule provides continuous compliance enforcement: the custom rule evaluates each CloudWatch Logs log group against the retention policy (based on naming convention or tags). Non-compliant log groups (e.g., a security log group with less than 7-year retention) are flagged and automatically remediated via SSM Automation that calls PutRetentionPolicy. This is continuous (not daily like Option B), auditable (Config provides compliance history), and handles new log groups automatically. Option A doesn't scale. Option B runs daily, missing interim changes. Option C—SCPs restrict API actions, they can't enforce specific retention values.

---

### Question 69
A company uses AWS X-Ray and notices that traces only show the Lambda function execution time but not the time spent in the SQS queue before the Lambda was invoked. The team needs to measure the total time from when a message is sent to SQS to when processing completes. How should they capture this end-to-end timing?

A) Enable X-Ray tracing on SQS (SQS has native X-Ray integration that tracks queue time)
B) Include the send timestamp as a message attribute, read it in the Lambda consumer, calculate queue wait time as a custom X-Ray subsegment, and publish it as a CloudWatch custom metric
C) Use the SQS ApproximateAgeOfOldestMessage CloudWatch metric as a proxy
D) Subtract SQS SendMessage API timestamp from Lambda invocation timestamp using CloudTrail events

**Correct Answer: B**
**Explanation:** SQS doesn't have native X-Ray integration for queue wait time. The solution: (1) The producer includes a timestamp (e.g., `SentTimestamp` as a message attribute or using the SQS-provided `SentTimestamp` attribute). (2) The Lambda consumer reads this timestamp and calculates `queue_wait_time = current_time - sent_timestamp`. (3) Add a custom X-Ray subsegment showing the queue wait time, linking it to the trace. (4) Publish the wait time as a CloudWatch custom metric for dashboarding and alerting. This provides both per-request visibility (X-Ray) and aggregate monitoring (CloudWatch metric). Option A—SQS doesn't have native X-Ray queue time tracking. Option C gives queue-level average, not per-message timing. Option D is imprecise and high-overhead.

---

### Question 70
A company has a critical production environment and needs to implement a "war room" experience for incident response. When a P1 incident is declared, the system should automatically: (1) create a dedicated Slack channel, (2) populate it with relevant dashboards and runbook links, (3) invite the on-call team, (4) start capturing a timeline of all actions taken, and (5) enable a "bridge call" for verbal coordination. What AWS service orchestrates this?

A) Amazon EventBridge with Lambda functions for each integration
B) AWS Systems Manager Incident Manager with response plans that define engagement (PagerDuty/on-call), chat channel (via AWS Chatbot for Slack), runbook automation (SSM Automation), and timeline recording
C) AWS Chatbot with SNS integration
D) Custom application using the Slack API and PagerDuty API

**Correct Answer: B**
**Explanation:** AWS Incident Manager orchestrates the full incident response lifecycle. A **response plan** defines: (1) Chat channel creation via AWS Chatbot (Slack/Teams). (2) Engagement plans that page the on-call team (direct integration with PagerDuty or native contacts). (3) Runbook execution via SSM Automation for automated diagnostics. (4) Automatic timeline recording of all actions, findings, and metric changes during the incident. When a CloudWatch alarm or EventBridge event triggers the response plan, all of these activate simultaneously. Post-incident, the timeline and metrics feed into an automated post-mortem analysis. Option A requires building everything custom. Option C provides chat notifications but not full incident orchestration. Option D requires significant custom development.

---

### Question 71
A company needs to monitor their AWS costs in real-time and alert when daily spending exceeds $5,000 or when a specific service cost spikes by 50% compared to the previous day. Standard AWS Budgets alerts have a delay of up to 12-24 hours. What should the architect implement for near-real-time cost monitoring?

A) Use AWS Cost Anomaly Detection which uses ML to identify unusual spending patterns and sends alerts within hours
B) Use CloudWatch billing metrics (EstimatedCharges) with alarms for daily threshold, and Cost Explorer API with a scheduled Lambda for day-over-day comparison
C) Use AWS Budgets with daily budgets
D) Query Cost and Usage Reports (CUR) with Athena on an hourly schedule

**Correct Answer: A**
**Explanation:** AWS Cost Anomaly Detection is purpose-built for this use case. It uses ML to establish spending baselines per service and account, automatically detecting anomalies (unusual spikes). It can alert via SNS or email with contextual information about which service, account, and usage type caused the anomaly. Detection typically occurs within hours (much faster than the 12-24 hour Budget delay). You can configure: minimum anomaly amount ($5,000), percentage increase threshold (50%), and monitoring dimensions (per-service, per-account). Option B requires custom Lambda for the comparison logic. Option C has the 12-24 hour delay mentioned. Option D requires managing CUR delivery and query infrastructure.

---

### Question 72
A company has CloudWatch Logs from 30 different applications. Each application team wants to query only their own logs but the central platform team needs to query across all applications. The architect needs to implement access control for CloudWatch Logs Insights. How should this be configured?

A) Create IAM policies that restrict each team's CloudWatch Logs Insights access to their specific log groups using resource-level permissions
B) Create separate AWS accounts for each application team
C) Use CloudWatch Logs Insights query history to audit who queries what
D) Create separate CloudWatch dashboards for each team with embedded queries

**Correct Answer: A**
**Explanation:** IAM resource-level permissions for CloudWatch Logs control which log groups each team can access. For application team A: `{"Effect": "Allow", "Action": ["logs:StartQuery", "logs:GetQueryResults"], "Resource": "arn:aws:logs:*:*:log-group:/apps/team-a/*"}`. For the platform team: `{"Effect": "Allow", "Action": ["logs:StartQuery", "logs:GetQueryResults"], "Resource": "arn:aws:logs:*:*:log-group:/apps/*"}`. This ensures each team can only query their own logs while the platform team has cross-application access. Option B is overkill for log access control. Option C provides audit but not access control. Option D provides pre-built queries but doesn't restrict ad-hoc access.

---

### Question 73
A company runs a complex event-driven architecture and needs to trace an event as it flows through: API Gateway → Lambda → EventBridge → 3 separate Lambda consumers → DynamoDB/S3/SQS. They need a unified view of the entire event flow, including all fan-out branches. What monitoring strategy provides this visibility?

A) Use X-Ray for all synchronous components and propagate trace context through EventBridge events using detail fields, with each consumer Lambda creating linked subsegments
B) Implement a custom correlation system with a unique event ID, log it at every stage, and use CloudWatch Logs Insights to reconstruct the flow
C) Use CloudWatch ServiceLens which automatically correlates API Gateway, Lambda, and downstream service traces
D) Both A and B together provide the most comprehensive visibility

**Correct Answer: D**
**Explanation:** X-Ray and custom correlation complement each other: **(A) X-Ray** provides automatic instrumentation for API Gateway → Lambda and visualizes the service map. For EventBridge fan-out, the trace context must be manually propagated (include the X-Ray trace header in the EventBridge event detail). Each consumer Lambda creates a new trace segment linked to the original trace via the propagated trace ID. **(B) Custom correlation** fills gaps: X-Ray traces expire after 30 days and may not capture business-level event details. A custom event ID logged at every stage with structured logging provides long-term traceability and business context. Together, you get real-time distributed tracing (X-Ray) plus long-term event audit trail (logs). Option C provides some automatic correlation but doesn't handle EventBridge fan-out.

---

### Question 74
A company has deployed CloudWatch Contributor Insights on their DynamoDB table. They notice that 5% of partition keys receive 95% of the read traffic (hot partition problem). The team needs to implement monitoring that automatically detects new hot partitions as access patterns change. What should the architect configure? (Select TWO)

A) Enable CloudWatch Contributor Insights rules for DynamoDB with ConsumedReadCapacityUnits grouped by partition key
B) Create a CloudWatch alarm on the Contributor Insights metric that triggers when any single partition key exceeds 10% of total read capacity
C) Use DynamoDB adaptive capacity and assume it handles hot partitions automatically
D) Monitor the DynamoDB ThrottledRequests metric for partition-level throttling
E) Use DynamoDB accelerator (DAX) to absorb hot partition read traffic

**Correct Answer: A, B**
**Explanation:** (A) Contributor Insights for DynamoDB provides real-time top-N analysis of the most accessed partition keys based on ConsumedReadCapacityUnits. It automatically identifies the hottest partitions without manual analysis. (B) Creating a CloudWatch alarm on Contributor Insights metrics detects when a new partition key becomes hot (>10% of total capacity), enabling proactive response before throttling occurs. Together, these provide automatic detection of changing hot partition patterns. Option C—adaptive capacity helps but doesn't alert the team. Option D detects throttling after it occurs (reactive, not proactive). Option E is a valid mitigation but doesn't address monitoring/detection.

---

### Question 75
A company is evaluating the total cost of their observability stack. They currently spend: $2,000/month on CloudWatch Logs ingestion, $500/month on CloudWatch Metrics, $300/month on X-Ray traces, $1,000/month on CloudWatch dashboards and alarms, and $200/month on CloudWatch Logs Insights queries. Total: $4,000/month. The company wants to reduce observability costs by 40% without losing critical monitoring capabilities. Which optimizations should the architect prioritize? (Select TWO)

A) Reduce CloudWatch Logs ingestion by filtering out DEBUG/INFO logs before sending (potentially saving 60% of $2,000 = $1,200/month)
B) Reduce X-Ray sampling rate from 100% to 5% (saving ~$285/month)
C) Delete unused CloudWatch dashboards and alarms (saving up to $500/month of the $1,000)
D) Switch from CloudWatch Metrics to Prometheus for custom metrics
E) Reduce CloudWatch Logs retention periods across all log groups

**Correct Answer: A, C**
**Explanation:** Target: $1,600/month savings (40% of $4,000). **(A) Log ingestion filtering:** CloudWatch Logs ingestion ($0.50/GB) is the largest cost. Filtering DEBUG/INFO logs (typically 60-80% of log volume) by adjusting application log levels to WARN/ERROR in production saves ~$1,200/month. This is the highest-impact optimization. **(C) Dashboard/alarm cleanup:** Organizations accumulate unused dashboards ($3/dashboard/month) and alarms ($0.10-$0.30/alarm/month). Auditing and removing unused ones can save $300-500/month. Together: $1,200 + $400 = $1,600/month (40% savings). Option B saves $285—helpful but smaller impact. Option D adds migration effort and may not save money (Prometheus infrastructure costs). Option E reduces storage costs (which are already low at $0.03/GB/month) with minimal savings.

---

## Answer Key

| Q | Answer | Q | Answer | Q | Answer | Q | Answer | Q | Answer |
|---|--------|---|--------|---|--------|---|--------|---|--------|
| 1 | A | 16 | B | 31 | A | 46 | D | 61 | D |
| 2 | D | 17 | A | 32 | A | 47 | B | 62 | A |
| 3 | B | 18 | A | 33 | A | 48 | A | 63 | D |
| 4 | B | 19 | B | 34 | C | 49 | B | 64 | B |
| 5 | A | 20 | D | 35 | A | 50 | B | 65 | A |
| 6 | A | 21 | A | 36 | A | 51 | A | 66 | B |
| 7 | A | 22 | A,B | 37 | A | 52 | D | 67 | B |
| 8 | B | 23 | A | 38 | D | 53 | B | 68 | D |
| 9 | D | 24 | B | 39 | A | 54 | B | 69 | B |
| 10 | B | 25 | B | 40 | D | 55 | B | 70 | B |
| 11 | C | 26 | D | 41 | B | 56 | B | 71 | A |
| 12 | B | 27 | B | 42 | A | 57 | A | 72 | A |
| 13 | A | 28 | A | 43 | B | 58 | B | 73 | D |
| 14 | B | 29 | C | 44 | A | 59 | B | 74 | A,B |
| 15 | B | 30 | B | 45 | A | 60 | A | 75 | A,C |

### Domain Distribution
- **Domain 1** (Organizational Complexity): Q2, Q6, Q7, Q12, Q17, Q19, Q20, Q26, Q34, Q40, Q44, Q46, Q48, Q54, Q59, Q62, Q68, Q70, Q72 → 19 questions
- **Domain 2** (New Solutions): Q1, Q3, Q5, Q8, Q9, Q13, Q15, Q21, Q24, Q25, Q27, Q28, Q33, Q36, Q42, Q43, Q47, Q49, Q50, Q57, Q64, Q66 → 22 questions
- **Domain 3** (Continuous Improvement): Q4, Q10, Q11, Q14, Q16, Q23, Q35, Q39, Q52, Q56, Q69 → 11 questions
- **Domain 4** (Migration & Modernization): Q18, Q22, Q29, Q37, Q38, Q45, Q51, Q55, Q58 → 9 questions
- **Domain 5** (Cost Optimization): Q30, Q31, Q32, Q41, Q53, Q60, Q61, Q63, Q65, Q67, Q71, Q73, Q75 → 13 questions
