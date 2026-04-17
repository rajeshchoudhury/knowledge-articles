# Domain 3: Monitoring and Logging (15% of Exam)

## Overview

Domain 3 of the AWS Certified DevOps Engineer – Professional (DOP-C02) exam evaluates your ability to design and implement monitoring, logging, and observability strategies across AWS environments. This domain carries **15% of the total exam weight**. Amazon CloudWatch is the cornerstone service, but the exam also heavily tests AWS X-Ray for distributed tracing, AWS CloudTrail for API auditing, and cross-service integration patterns. You must understand how to build **centralized, multi-account logging architectures** and design alarm-driven automated remediation workflows.

The exam expects you to choose the most appropriate monitoring tool for a given scenario, configure alerting at the right granularity, and integrate monitoring signals with automated incident response. Expect questions that blend monitoring with CI/CD (canary deployments, rollback triggers) and security (unauthorized API calls, compliance auditing).

---

## 1. Amazon CloudWatch

CloudWatch is the unified monitoring and observability platform for AWS. It collects and tracks metrics, collects and monitors log files, sets alarms, and automatically reacts to changes in your AWS resources.

### 1.1 Metrics

**Namespaces**: Metrics are organized into namespaces. AWS services publish metrics to their own namespace (e.g., `AWS/EC2`, `AWS/RDS`, `AWS/ELB`). Custom namespaces are used for application metrics.

**Dimensions**: Name-value pairs that uniquely identify a metric. For example, `InstanceId` is a dimension for EC2 metrics. A metric can have up to **30 dimensions**.

**Statistics**: Aggregations over a specified time period. Available statistics:
- `SampleCount`, `Average`, `Sum`, `Minimum`, `Maximum`
- Percentiles: `p50`, `p90`, `p99`, etc. (available with high-resolution metrics)
- `tm()` (trimmed mean), `tc()` (trimmed count), `ts()` (trimmed sum) for trimmed statistics.

**Periods**: The length of time associated with a specific statistic. Must be a multiple of 60 seconds for standard-resolution metrics. Can be 1 second for high-resolution metrics.

**Resolution**:
- **Standard resolution**: 1-minute granularity. Default for AWS service metrics. Data retained for 15 days at 1-min resolution, 63 days at 5-min, 455 days at 1-hour.
- **High resolution**: 1-second granularity. Only for custom metrics published with `StorageResolution: 1`. Data retained for 3 hours at 1-sec, 15 days at 1-min, 63 days at 5-min, 455 days at 1-hour.

> **Key Points for the Exam**
> - EC2 basic monitoring publishes metrics every 5 minutes (free). Detailed monitoring publishes every 1 minute (charged).
> - EC2 does **not** natively publish memory or disk utilization metrics. You must use the **CloudWatch Agent** for these.
> - High-resolution custom metrics cost more but enable 1-second alarm evaluation.
> - CloudWatch retains metric data for 15 months (rolling), with decreasing resolution over time.

### 1.2 Custom Metrics

**PutMetricData API**: Publishes metric data points. You can publish:
- Individual data points
- Statistic sets (pre-aggregated: `SampleCount`, `Sum`, `Minimum`, `Maximum`)
- Values with associated counts (value arrays)

**Metric Math**: Combine metrics using mathematical expressions. Examples:
- `METRICS("m1") / METRICS("m2") * 100` for percentage calculations
- `IF(m1 > 100, m1, 0)` for conditional expressions
- `FILL(m1, 0)` to fill missing data points
- `ANOMALY_DETECTION_BAND(m1, 2)` for anomaly detection

**Search Expressions**: Dynamically find metrics using search patterns:
```
SEARCH('{AWS/EC2, InstanceId} MetricName="CPUUtilization"', 'Average', 300)
```

### 1.3 CloudWatch Alarms

Alarms watch a metric (or metric math expression) and perform actions based on the metric's value relative to a threshold.

**Alarm States:**
| State | Meaning |
|---|---|
| `OK` | Metric is within the defined threshold. |
| `ALARM` | Metric has breached the threshold. |
| `INSUFFICIENT_DATA` | Not enough data to determine state. Occurs when alarm is first created or when metric data stops flowing. |

**Alarm Actions**: Triggered on state transitions.
- **EC2 actions**: Stop, terminate, reboot, recover the instance.
- **Auto Scaling actions**: Scale out/in.
- **SNS notifications**: Send to topics for email, Lambda, SQS, HTTP/S endpoints.
- **Systems Manager OpsItems**: Create OpsItems automatically.
- **Lambda actions**: Invoke Lambda functions (via SNS or EventBridge).

**Evaluation Configuration:**
- **Period**: How long each evaluation data point covers.
- **Evaluation Periods**: Number of most recent periods to evaluate (e.g., 3).
- **Datapoints to Alarm**: How many of the evaluation periods must be breaching for the alarm to trigger (e.g., 2 out of 3). This provides `M out of N` alarm configuration.

**Treat Missing Data Options:**
| Option | Behavior |
|---|---|
| `missing` | Alarm maintains its current state when data is missing. |
| `notBreaching` | Missing data is treated as being within the threshold. |
| `breaching` | Missing data is treated as breaching the threshold. |
| `ignore` | Current state is maintained (same as `missing`). |

**Anomaly Detection**: CloudWatch can build a model of a metric's expected values using machine learning. Alarms can trigger when the metric value falls outside a configurable band around the expected value. Useful for metrics with regular patterns (e.g., CPU utilization during business hours).

**Composite Alarms**: Combine multiple alarms using Boolean logic (`AND`, `OR`, `NOT`). Reduce alarm noise by requiring multiple conditions to be true before taking action. Example: Only alert if both CPU is high AND request error rate is high.

> **Key Points for the Exam**
> - Know the "M out of N" alarm configuration (Datapoints to Alarm ≤ Evaluation Periods).
> - `treat missing data` options are frequently tested. Use `notBreaching` for metrics that may have gaps (e.g., error counts when there are no errors).
> - Composite alarms help reduce alarm fatigue and prevent false positives.
> - EC2 instance recovery action preserves instance ID, IP address, metadata, and placement group.
> - Alarms can directly trigger EC2 actions without Lambda intermediaries.

### 1.4 CloudWatch Logs

CloudWatch Logs centralizes log collection, storage, and analysis.

**Core Concepts:**
- **Log Groups**: Logical containers for logs. Define retention (1 day to 10 years, or indefinite), encryption (KMS), and access policies.
- **Log Streams**: Sequences of log events from the same source. Typically one stream per instance or Lambda invocation.
- **Log Events**: Individual log entries with a timestamp and message.

**Retention**: Configurable at the log group level. Default is **never expire**. Set retention to control costs.

**Encryption**: Log groups can be encrypted with a KMS key. Must configure KMS key policy to allow CloudWatch Logs service principal.

**Metric Filters**: Define patterns to extract metric values from log data. Creates a CloudWatch metric that can be alarmed on.
- Filter pattern syntax supports exact matches, JSON path extraction, space-delimited fields.
- Example: `[ip, id, user, timestamp, request, status_code=5*, size]` matches 5xx errors in Apache logs.
- Metric filters only process data published **after** the filter is created; they do not retroactively scan.

**Subscription Filters**: Real-time streaming of log data to destinations:
| Destination | Use Case |
|---|---|
| **Lambda** | Real-time processing, transformation, alerting |
| **Kinesis Data Firehose** | Delivery to S3, OpenSearch, Redshift, Splunk |
| **Kinesis Data Streams** | Real-time analytics, custom processing pipelines |
| **OpenSearch Service** | Log analytics and visualization with Kibana |

Each log group can have up to **2 subscription filters**.

**CloudWatch Logs Insights**: Interactive query language for log analysis.
- Query syntax: `fields`, `filter`, `stats`, `sort`, `limit`, `parse`, `display`
- Example:
```
fields @timestamp, @message
| filter @message like /ERROR/
| stats count(*) as errorCount by bin(30m)
| sort errorCount desc
| limit 20
```
- Supports querying multiple log groups simultaneously.
- Auto-discovers fields in JSON-formatted logs.
- **Not real-time** — queries scan stored log data.

**Cross-Account Log Data Sharing**: CloudWatch Logs supports cross-account subscription filters. A log group in Account A can send data to a Kinesis Data Stream or Kinesis Data Firehose in Account B via a destination resource with an access policy.

**Live Tail**: Real-time streaming view of log events as they are ingested. Interactive filtering with pattern matching. Useful for debugging in real time.

> **Key Points for the Exam**
> - Metric filters do not retroactively process old log data — they only apply to new events.
> - Maximum 2 subscription filters per log group.
> - Logs Insights is for ad-hoc querying; it is NOT a real-time alerting mechanism.
> - For real-time log processing, use subscription filters with Lambda or Kinesis.
> - Know how to construct Logs Insights queries (field extraction, filtering, aggregation).

### 1.5 CloudWatch Agent vs Unified Agent vs Logs Agent

| Feature | CloudWatch Logs Agent (old) | CloudWatch Unified Agent (current) |
|---|---|---|
| Metrics | No | Yes (memory, disk, CPU, network, process) |
| Logs | Yes | Yes |
| Configuration | Config file | JSON/SSM Parameter Store (wizard available) |
| StatsD/collectd | No | Yes |
| Windows support | No | Yes |
| Status | Legacy (deprecated) | **Recommended** |

The **CloudWatch Agent** (also called "unified agent") is the recommended agent. It publishes both metrics and logs. Configuration can be stored in SSM Parameter Store for centralized management across instances.

> **Key Points for the Exam**
> - The CloudWatch Agent is the ONLY way to get memory and disk metrics from EC2 into CloudWatch.
> - Agent configuration can be managed centrally via SSM Parameter Store.
> - The old "CloudWatch Logs Agent" is deprecated — always choose the unified CloudWatch Agent.

### 1.6 CloudWatch Dashboards

**Dashboards** are customizable home pages for monitoring resources.

- **Cross-account dashboards**: View metrics from multiple accounts in a single dashboard (requires cross-account access via an IAM role in the sharing account).
- **Cross-region dashboards**: Include widgets showing metrics from different regions.
- **Automatic dashboards**: AWS provides pre-built dashboards for services like EC2, ELB, and RDS.
- **Widget types**: Line graphs, stacked area, number, text, log insights queries, alarm status.
- Dashboards are **global** resources — they can display data from any region.

### 1.7 CloudWatch Events / Amazon EventBridge

EventBridge (evolved from CloudWatch Events) is a serverless event bus that routes events from sources to targets based on rules.

**Event Sources:**
- AWS services (auto-generated events: state changes, API calls)
- Custom applications (via `PutEvents` API)
- SaaS partners (Datadog, PagerDuty, Auth0, etc.)
- Scheduled events (cron or rate expressions)

**Event Patterns**: JSON-based matching rules. Match on:
- `source` (e.g., `aws.ec2`)
- `detail-type` (e.g., `EC2 Instance State-change Notification`)
- `detail` fields with exact match, prefix, numeric comparison, exists/absent, or anything-but matching.

**Targets**: Over 20 target types:
- Lambda, Step Functions, ECS tasks, CodePipeline, CodeBuild
- SNS, SQS, Kinesis Data Streams, Kinesis Data Firehose
- SSM Automation, SSM Run Command, SSM OpsItems
- API Gateway, Redshift, CloudWatch Logs
- Another event bus (cross-account, cross-region)

**Event Buses:**
- **Default event bus**: Receives events from AWS services.
- **Custom event buses**: For application-specific events.
- **Partner event buses**: For SaaS integrations.

**Schema Registry**: Automatically discovers and stores event schemas. Generates code bindings (Java, Python, TypeScript) from schemas.

**Archive and Replay**: Archive events for a specified retention period. Replay archived events to an event bus for testing, debugging, or disaster recovery.

**Cross-Account/Cross-Region Event Routing**: Send events from one account/region to an event bus in another account/region. Requires resource-based policy on the target event bus.

> **Key Points for the Exam**
> - EventBridge is the successor to CloudWatch Events. Prefer EventBridge for new architectures.
> - Event patterns support content-based filtering (prefix, numeric ranges, IP address matching, exists).
> - Cross-account event routing requires a resource-based policy on the destination event bus.
> - Archive and Replay is unique to EventBridge — enables testing with production event shapes.
> - EventBridge can trigger CodePipeline, making it ideal for event-driven CI/CD.
> - **Default event bus** events (like EC2 state changes) cannot be sent to custom event buses directly; you create rules on the default bus.

### 1.8 CloudWatch Synthetics (Canaries)

Synthetics creates **canaries** — configurable scripts that run on a schedule to monitor endpoints and APIs.

- **Blueprints**: Pre-built canary templates (heartbeat monitor, API canary, broken link checker, GUI workflow, visual monitoring).
- **Scripts**: Written in Node.js or Python using the Synthetics runtime. Can take screenshots, check HTTP status codes, measure latency, and validate response content.
- **Scheduling**: Run canaries every 1 minute to every 12 hours.
- **Integration**: Canary results are stored in S3 (screenshots, HAR files, logs). Metrics are published to CloudWatch for alarming. Failed canaries can trigger EventBridge events.

**Visual Monitoring**: Compares screenshots with a baseline image and detects visual regressions.

> **Key Points for the Exam**
> - Canaries proactively detect issues before users report them.
> - Use canaries to validate that endpoints are healthy after deployments (common exam pattern with canary deployments).
> - Canaries can run within a VPC to test private endpoints.

### 1.9 CloudWatch RUM (Real User Monitoring)

Collects and analyzes client-side performance data from real user sessions in web applications.

- Captures page load times, JavaScript errors, HTTP errors, Core Web Vitals.
- Requires a JavaScript snippet embedded in the web application.
- Data is viewable in the CloudWatch console with filters by browser, device, country, session.
- Integrates with X-Ray for end-to-end tracing (client → backend).

### 1.10 CloudWatch Container Insights

Provides monitoring and troubleshooting for containerized applications on ECS and EKS.

- Collects metrics at the cluster, node, pod, task, and service level.
- Automatically discovers containers and collects metrics (CPU, memory, disk, network).
- **Enhanced observability** (EKS): Accelerated compute metrics, Kubernetes control plane metrics.
- For ECS on EC2: Requires CloudWatch Agent as a daemon task.
- For ECS on Fargate: Enable Container Insights at the cluster level.
- For EKS: Use the CloudWatch Observability EKS add-on or Fluent Bit for logs.

### 1.11 CloudWatch Application Insights

Automatically sets up monitoring for .NET and SQL Server applications, Java applications, and other application stacks. Detects anomalies and correlates related metrics and log patterns into unified "problems."

### 1.12 Contributor Insights

Analyzes log data to create time-series contributor data. Identifies the top-N contributors (e.g., top IP addresses making API calls, top URLs with errors). Uses rules to match log fields and create real-time rankings.

### 1.13 ServiceLens

Provides a unified view of health, performance, and availability by integrating CloudWatch, X-Ray, and health dashboards. Visualizes dependencies between services using X-Ray service maps annotated with CloudWatch metrics and alarms.

### 1.14 Embedded Metric Format (EMF)

Allows you to embed custom metrics within structured log events. CloudWatch automatically extracts the metrics without requiring separate `PutMetricData` API calls. Useful for Lambda and containerized applications.

```json
{
  "_aws": {
    "Timestamp": 1234567890,
    "CloudWatchMetrics": [{
      "Namespace": "MyApp",
      "Dimensions": [["Service", "Environment"]],
      "Metrics": [{"Name": "ProcessingTime", "Unit": "Milliseconds"}]
    }]
  },
  "Service": "OrderService",
  "Environment": "Production",
  "ProcessingTime": 42
}
```

**Benefits**: Reduces API calls, enables high-cardinality metrics, combines metrics with log context.

### 1.15 CloudWatch Internet Monitor

Monitors internet availability and performance between users and AWS-hosted applications. Uses AWS's internet measurements to detect reachability issues, latency increases, and ISP-level problems. No instrumentation needed — just specify the resources to monitor (CloudFront distributions, VPCs, WorkSpaces).

---

## 2. AWS X-Ray

X-Ray provides distributed tracing for analyzing and debugging production applications, particularly microservice architectures.

### 2.1 Core Concepts

| Concept | Description |
|---|---|
| **Trace** | An end-to-end request path across services. A collection of segments. Each trace has a unique **trace ID**. |
| **Segment** | Data about work done by a single service for a request. Contains service name, request/response details, timing, and subsegments. |
| **Subsegment** | More granular breakdown within a segment (e.g., individual DynamoDB call, external HTTP call, SQL query). |
| **Annotations** | Key-value pairs with **string, number, or boolean** values. **Indexed** for searching and filtering. Max 50 per trace. |
| **Metadata** | Key-value pairs with **any** values (objects, arrays). **Not indexed** — for additional data not used in search. |
| **Groups** | Filter expressions that define a collection of traces. Groups have their own service maps and metrics. |

> **Key Points for the Exam**
> - **Annotations** are indexed and searchable. Use for values you need to filter on (user ID, order ID, environment).
> - **Metadata** is NOT indexed. Use for supplementary data (full request bodies, detailed error info).
> - Know the difference — exam questions often test annotation vs. metadata choice.

### 2.2 Sampling Rules

Sampling controls the volume of traces collected to manage costs.

- **Default rule**: 1 request per second + 5% of additional requests.
- **Custom rules**: Define sampling rate per service, URL path, HTTP method, etc.
- **Reservoir**: Fixed number of requests per second to sample (guarantees minimum traces).
- **Rate**: Percentage of additional requests beyond the reservoir to sample.

Sampling rules can be configured centrally (X-Ray console/API) and are downloaded by the SDK. No deployment needed to change sampling.

### 2.3 X-Ray Daemon

A background process that listens for UDP traffic on port 2000, buffers segments, and sends them to the X-Ray API in batches.

- **EC2**: Install and run as a background process.
- **ECS**: Run as a sidecar container in the task definition.
- **Elastic Beanstalk**: Enabled via configuration option.
- **On-premises**: Can be installed on any Linux/Windows machine.

The daemon needs IAM permissions (`xray:PutTraceSegments`, `xray:PutTelemetryRecords`).

### 2.4 X-Ray SDK Instrumentation

The X-Ray SDK provides automatic and manual instrumentation:

**Automatic instrumentation**:
- HTTP clients (outgoing HTTP calls)
- AWS SDK calls
- SQL queries

**Manual instrumentation**:
- Custom subsegments for arbitrary code blocks
- Adding annotations and metadata
- Setting user for the segment

**Supported languages**: Java, Node.js, Python, Go, .NET, Ruby.

### 2.5 X-Ray with AWS Services

| Service | How X-Ray Integrates |
|---|---|
| **Lambda** | Enable active tracing in function configuration. X-Ray SDK is included in the runtime. No daemon needed. |
| **API Gateway** | Enable tracing in the stage settings. API Gateway creates segments for each request. |
| **ECS/EKS** | Run X-Ray daemon as a sidecar container. Application sends segments to the sidecar. |
| **Elastic Beanstalk** | Enable X-Ray in environment configuration. Daemon runs automatically. |
| **App Runner** | Built-in X-Ray support, configurable via service settings. |
| **SNS/SQS** | X-Ray propagates trace headers through message attributes for asynchronous tracing. |

### 2.6 Service Maps

Visual representation of your application's architecture. Shows services and their connections with:
- Average latency
- Request counts
- Error/fault rates
- Health status (green/yellow/red)

### 2.7 Trace Analysis and Filtering

- **Filter expressions**: `annotation.userId = "user123"`, `service("payment-service") { fault = true }`, `responseTime > 5`
- **Trace timeline**: Visual breakdown of request processing across all services.
- **Analytics**: Visualize response time distribution, compare trace groups, identify outliers.

### 2.8 X-Ray Insights

Automatically detects anomalies in application performance:
- Significant increases in fault rates, error rates, or response times.
- Identifies the root cause service.
- Generates notifications via EventBridge.

> **Key Points for the Exam**
> - Lambda: Enable "Active Tracing" — no daemon needed.
> - ECS: X-Ray daemon runs as a sidecar container.
> - API Gateway: Enable per-stage tracing.
> - Annotations are indexed and filterable; metadata is not.
> - Sampling rules control cost by limiting trace volume.
> - X-Ray propagates trace context across synchronous (HTTP) and asynchronous (SQS/SNS) services.

---

## 3. AWS CloudTrail

CloudTrail records API activity in your AWS account, providing a complete audit trail of who did what, when, and from where.

### 3.1 Event Types

| Event Type | What It Records | Default |
|---|---|---|
| **Management Events** | Control plane operations (CreateBucket, RunInstances, AttachRolePolicy) | Enabled by default (free for one copy) |
| **Data Events** | Data plane operations (S3 GetObject/PutObject, Lambda Invoke, DynamoDB GetItem/PutItem) | Disabled by default (must be explicitly enabled; charged) |
| **Insights Events** | Unusual API activity (spikes in write management events, errors). Uses machine learning. | Disabled by default (charged) |

### 3.2 Trail Types

- **Single-region trail**: Records events only in the region where it's created.
- **Multi-region trail**: Records events in **all regions**. Best practice.
- **Organization trail**: A multi-region trail that applies to all accounts in an AWS Organization. Created from the management account.

### 3.3 Log File Validation

CloudTrail provides **log file integrity validation** (digest files).
- A digest file is created every hour, containing hashes of the log files delivered during that hour.
- Digest files are signed with a private key.
- You can validate that logs have not been tampered with using `aws cloudtrail validate-logs`.
- This provides non-repudiation for security and compliance.

### 3.4 CloudTrail Lake

CloudTrail Lake is a managed **event data store** for long-term querying and analysis.

- **Event data stores**: Repositories that hold CloudTrail events. Configure retention (up to 7 years or longer with custom pricing).
- **SQL queries**: Query events using SQL syntax directly in the console or API.
- **Federation**: Query event data stores from Athena without copying data.
- Supports management events, data events, Config items, Insights events, and non-AWS events.
- Replaces the pattern of "CloudTrail → S3 → Athena" for simple queries.

### 3.5 CloudTrail Integrations

| Integration | Purpose |
|---|---|
| **CloudWatch Logs** | Stream CloudTrail events to CloudWatch Logs for metric filters and real-time alerting. E.g., alert on root account login, unauthorized API calls, security group changes. |
| **EventBridge** | Trigger automated responses to API calls. E.g., auto-remediate when someone creates a public S3 bucket. |
| **S3** | Long-term storage with lifecycle policies. Compress and archive to Glacier. Query with Athena. |
| **Athena** | Run SQL queries against CloudTrail logs stored in S3. Pre-built table DDL available. |

> **Key Points for the Exam**
> - Multi-region, organization-wide trails are the recommended configuration.
> - Data events (S3, Lambda, DynamoDB) must be explicitly enabled and incur additional costs.
> - CloudTrail Insights detects unusual API **call volume** and **error rate** patterns.
> - Log file validation (digest files) ensures tamper-proof audit logs.
> - CloudTrail → CloudWatch Logs → Metric Filter → Alarm is the classic pattern for detecting security-relevant API calls.
> - CloudTrail Lake simplifies event querying without needing S3 + Athena setup.

---

## 4. Amazon OpenSearch Service

Amazon OpenSearch Service (successor to Amazon Elasticsearch Service) provides managed search and analytics.

### 4.1 Index Management

- **Indices**: Collections of JSON documents. Analogous to a database table.
- **Index State Management (ISM)**: Automate index lifecycle (rollover by size/age, delete old indices, move to warm/cold storage).
- **UltraWarm** and **Cold storage**: Cost-effective tiers for infrequently accessed data.

### 4.2 OpenSearch Dashboards (Kibana)

Visualization and dashboarding tool bundled with OpenSearch. Create:
- Time-series visualizations
- Pie charts, bar charts, data tables
- Saved searches and dashboards
- Anomaly detection visualizations

### 4.3 Log Analytics Patterns

Common architecture: **CloudWatch Logs → Subscription Filter → Kinesis Data Firehose → OpenSearch**

This pattern enables:
- Near-real-time log analytics
- Full-text search across log data
- Interactive dashboards for operations teams
- Alerting on log patterns

Also supports direct streaming from **Kinesis Data Streams** and **S3** (via snapshot and restore or OpenSearch ingestion pipelines).

### 4.4 Integration with CloudWatch Logs

CloudWatch Logs can stream data directly to OpenSearch via subscription filters:
1. Create a subscription filter on the log group.
2. Select the OpenSearch domain as the destination.
3. CloudWatch Logs creates a Lambda function to transform and load data.
4. Data flows in near-real-time to OpenSearch for indexing and visualization.

> **Key Points for the Exam**
> - OpenSearch is the go-to service for log analytics with interactive dashboards.
> - Subscription filter → OpenSearch is a common exam pattern.
> - UltraWarm and Cold storage reduce costs for historical log data.
> - OpenSearch is NOT the same as CloudWatch Logs Insights — use OpenSearch when you need full-text search, complex aggregations, or rich dashboards.

---

## 5. AWS Config (Monitoring Aspect)

AWS Config continuously monitors and records resource configurations, enabling compliance assessment and change tracking.

### 5.1 Configuration Items and Recorder

- **Configuration Item (CI)**: A point-in-time view of a resource's attributes. Records the resource type, ID, ARN, creation time, configuration, relationships, and associated tags.
- **Configuration Recorder**: The component that records CIs. Must be started to begin recording. Can record all resource types or a subset.
- **Configuration History**: A collection of CIs for a resource over time (stored in S3).
- **Configuration Snapshot**: A collection of CIs for all recorded resources at a point in time.

### 5.2 Config Rules

Rules evaluate whether resource configurations comply with desired settings.

**Managed Rules**: Pre-built rules provided by AWS (150+):
- `s3-bucket-server-side-encryption-enabled`
- `ec2-instance-no-public-ip`
- `rds-instance-public-access-check`
- `encrypted-volumes`
- `required-tags`
- `cloudformation-stack-drift-detection-check`

**Custom Rules**: Two types:
- **Lambda-based**: A Lambda function evaluates the resource configuration and returns `COMPLIANT` or `NON_COMPLIANT`.
- **Guard-based**: Use CloudFormation Guard syntax for simpler, code-free rules.

**Trigger types**:
- **Configuration changes**: Rule evaluates when a relevant resource configuration changes.
- **Periodic**: Rule evaluates on a schedule (1 hour, 3 hours, 6 hours, 12 hours, 24 hours).

### 5.3 Conformance Packs

A collection of Config rules and remediation actions packaged as a YAML template. Deploy conformance packs across an organization using StackSets for consistent compliance assessment.

### 5.4 Remediation Actions

Config rules can trigger automatic remediation via SSM Automation documents:
- **Auto remediation**: Automatically executed when a resource is non-compliant.
- **Manual remediation**: Triggered manually by an operator.
- **Retries**: Configure the number of retry attempts and the retry interval.

**Common pattern**: Config rule detects a public S3 bucket → triggers SSM Automation → Lambda function removes public access.

### 5.5 Aggregators

A **multi-account, multi-region aggregator** collects Config data from multiple accounts and regions into a single aggregator account. Provides a centralized view of compliance status across the organization.

### 5.6 Advanced Queries

SQL-like query interface to search current configuration data across resources. Example:
```sql
SELECT
  resourceId, resourceType, configuration.instanceType
WHERE
  resourceType = 'AWS::EC2::Instance'
  AND configuration.instanceType = 't2.micro'
```

> **Key Points for the Exam**
> - Config rules evaluate compliance; they don't prevent non-compliant changes.
> - Auto-remediation with SSM Automation is the exam-preferred pattern for drift remediation.
> - Conformance packs enable organization-wide compliance deployment.
> - Aggregators provide a centralized compliance dashboard across multi-account environments.
> - Config records **what** changed. CloudTrail records **who** changed it. Together they provide a complete audit trail.

---

## 6. VPC Flow Logs

VPC Flow Logs capture information about IP traffic going to and from network interfaces.

### 6.1 Log Format

Default fields include: version, account-id, interface-id, srcaddr, dstaddr, srcport, dstport, protocol, packets, bytes, start, end, action (ACCEPT/REJECT), log-status.

Custom formats can include additional fields: vpc-id, subnet-id, instance-id, tcp-flags, type, pkt-srcaddr, pkt-dstaddr, region, az-id, flow-direction, traffic-path.

### 6.2 Publishing Destinations

| Destination | Use Case |
|---|---|
| **CloudWatch Logs** | Real-time analysis with metric filters and Logs Insights queries. |
| **S3** | Long-term storage, cost-effective, query with Athena. |
| **Kinesis Data Firehose** | Near-real-time delivery to OpenSearch, Splunk, etc. |

### 6.3 Analysis Patterns

**With Athena**: Create an external table over S3 flow log data and run SQL queries:
```sql
SELECT srcaddr, dstaddr, dstport, COUNT(*) as cnt
FROM vpc_flow_logs
WHERE action = 'REJECT'
GROUP BY srcaddr, dstaddr, dstport
ORDER BY cnt DESC
LIMIT 20;
```

**With CloudWatch Logs Insights**:
```
filter action = "REJECT"
| stats count(*) as rejectCount by srcAddr, dstAddr, dstPort
| sort rejectCount desc
| limit 20
```

> **Key Points for the Exam**
> - Flow logs do NOT capture: DNS traffic to Route 53 Resolver, DHCP traffic, traffic to instance metadata (169.254.169.254), NTP traffic, Windows license activation traffic.
> - Flow logs can be created at the VPC, subnet, or ENI level.
> - Flow logs are NOT real-time — there is a delay of several minutes.
> - S3 + Athena is the cost-effective pattern for large-scale flow log analysis.

---

## 7. Centralized Logging Architecture

### 7.1 Multi-Account Logging Strategies

The exam frequently tests centralized logging in multi-account environments.

**Recommended Architecture:**
1. **Dedicated logging account**: A central account that aggregates all logs.
2. **CloudTrail**: Organization trail delivers logs to S3 in the logging account.
3. **CloudWatch Logs**: Cross-account subscription filters or cross-account CloudWatch agent delivery.
4. **AWS Config**: Aggregator in the central account collects compliance data from all member accounts.
5. **VPC Flow Logs**: Delivered to a centralized S3 bucket or CloudWatch Logs.

### 7.2 Log Aggregation Patterns

**Pattern 1: CloudWatch Logs → Kinesis Data Firehose → S3**
- Near-real-time delivery to S3.
- Firehose handles batching, compression, and encryption.
- Athena queries S3 for analysis.
- Cost-effective for large-scale log storage.

**Pattern 2: CloudWatch Logs → Kinesis Data Firehose → OpenSearch**
- Real-time log analytics with rich dashboards.
- Firehose transforms data (optional Lambda transformation).
- OpenSearch provides full-text search and alerting.

**Pattern 3: CloudWatch Logs → Lambda → Custom Destination**
- Subscription filter invokes Lambda for processing.
- Lambda can route to Splunk, Datadog, or any custom endpoint.
- Good for transformation and enrichment.

**Pattern 4: Direct S3 Delivery**
- Many services deliver logs directly to S3 (ALB access logs, CloudFront logs, S3 access logs, Redshift audit logs).
- Use S3 event notifications + Lambda for processing.
- Query with Athena for ad-hoc analysis.

### 7.3 Cross-Account CloudWatch Access

- **Cross-account CloudWatch dashboards**: Share metrics and alarms across accounts using an IAM role.
- **Cross-account CloudWatch Logs**: Use a subscription filter with a Kinesis Data Stream destination in the central account. Configure a resource policy on the destination to allow the source account.
- **CloudWatch Observability Access Manager (OAM)**: A newer feature that enables cross-account observability. Create a **monitoring account** (sink) and **source accounts** (linked). Share metrics, logs, and traces without complex IAM configurations.

> **Key Points for the Exam**
> - A dedicated logging account is an AWS best practice for multi-account environments.
> - CloudWatch Observability Access Manager (OAM) simplifies cross-account monitoring.
> - Organization trails are the standard for centralized API auditing.
> - Kinesis Data Firehose is the preferred mechanism for streaming logs to S3 or OpenSearch at scale.
> - Know the difference between real-time (Lambda, Kinesis) and batch (S3 + Athena) log analysis patterns.

---

## Summary: Choosing the Right Monitoring Tool

| Scenario | Best Tool |
|---|---|
| Metric monitoring and alerting | CloudWatch Alarms |
| Log analysis with ad-hoc queries | CloudWatch Logs Insights |
| Real-time log analytics with dashboards | OpenSearch Service |
| Distributed tracing for microservices | AWS X-Ray |
| API audit trail (who did what?) | AWS CloudTrail |
| Resource configuration compliance | AWS Config |
| Network traffic analysis | VPC Flow Logs + Athena |
| Synthetic endpoint monitoring | CloudWatch Synthetics |
| Real user browser performance | CloudWatch RUM |
| Container-level metrics | CloudWatch Container Insights |
| Event-driven automation | Amazon EventBridge |
| Cross-account centralized monitoring | CloudWatch OAM / Centralized logging account |

---

## Monitoring + DevOps Integration Patterns

### Deployment Monitoring
1. Deploy new version (Blue/Green, Canary, Rolling).
2. CloudWatch Alarms monitor error rates, latency, 5XX errors.
3. CloudWatch Synthetics canaries validate endpoints.
4. X-Ray traces identify slow or failing services.
5. If alarms trigger within monitoring period → automatic rollback (CloudFormation rollback triggers, CodeDeploy automatic rollback).

### Security Monitoring
1. CloudTrail captures all API activity.
2. CloudTrail → CloudWatch Logs → Metric Filter → Alarm on suspicious activity.
3. EventBridge rules trigger Lambda or SSM Automation for auto-remediation.
4. AWS Config rules ensure continuous compliance.
5. GuardDuty findings → EventBridge → Security Hub → PagerDuty/Slack notifications.

### Operational Monitoring
1. CloudWatch Agent collects system-level metrics and application logs.
2. Container Insights monitors ECS/EKS clusters.
3. Composite alarms reduce noise and identify correlated issues.
4. ServiceLens provides unified health views.
5. OpsCenter aggregates operational issues for tracking and resolution.

---

## Final Exam Preparation Checklist

- [ ] Can you configure a CloudWatch alarm with M-out-of-N evaluation and explain treat-missing-data options?
- [ ] Do you know the difference between CloudWatch Logs Insights (ad-hoc queries) and subscription filters (real-time streaming)?
- [ ] Can you design a metric filter pattern for extracting error counts from log data?
- [ ] Do you understand EventBridge event patterns, buses, and cross-account routing?
- [ ] Can you explain X-Ray annotations (indexed) vs. metadata (not indexed)?
- [ ] Do you know how X-Ray integrates with Lambda (active tracing), ECS (sidecar daemon), and API Gateway (stage setting)?
- [ ] Can you differentiate CloudTrail management events, data events, and insights events?
- [ ] Do you understand CloudTrail log file validation (digest files)?
- [ ] Can you design a centralized logging architecture for a multi-account organization?
- [ ] Do you know when to use OpenSearch vs. CloudWatch Logs Insights vs. Athena for log analysis?
- [ ] Can you configure auto-remediation with AWS Config + SSM Automation?
- [ ] Do you understand CloudWatch Synthetics canary use cases and integration with deployment pipelines?
