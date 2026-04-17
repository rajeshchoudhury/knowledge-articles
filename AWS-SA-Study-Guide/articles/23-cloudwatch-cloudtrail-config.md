# CloudWatch, CloudTrail & Config

## Table of Contents

1. [Amazon CloudWatch Metrics](#amazon-cloudwatch-metrics)
2. [CloudWatch Alarms](#cloudwatch-alarms)
3. [CloudWatch Logs](#cloudwatch-logs)
4. [CloudWatch Logs Insights](#cloudwatch-logs-insights)
5. [CloudWatch Agents](#cloudwatch-agents)
6. [CloudWatch Dashboards](#cloudwatch-dashboards)
7. [Amazon EventBridge (CloudWatch Events)](#amazon-eventbridge-cloudwatch-events)
8. [CloudWatch Contributor Insights](#cloudwatch-contributor-insights)
9. [CloudWatch Synthetics](#cloudwatch-synthetics)
10. [CloudWatch ServiceLens & X-Ray](#cloudwatch-servicelens--x-ray)
11. [CloudWatch Application Insights](#cloudwatch-application-insights)
12. [CloudWatch Container Insights](#cloudwatch-container-insights)
13. [CloudWatch Anomaly Detection](#cloudwatch-anomaly-detection)
14. [AWS CloudTrail](#aws-cloudtrail)
15. [AWS Config](#aws-config)
16. [AWS Trusted Advisor](#aws-trusted-advisor)
17. [Config vs CloudTrail vs CloudWatch Comparison](#config-vs-cloudtrail-vs-cloudwatch-comparison)
18. [Common Exam Scenarios](#common-exam-scenarios)

---

## Amazon CloudWatch Metrics

### Overview

Amazon CloudWatch collects and tracks **metrics**, which are variables you can use to measure and monitor your resources and applications. Metrics are the fundamental concept in CloudWatch.

### Key Concepts

**Namespaces:**
- Metrics are grouped into namespaces to prevent aggregation of unrelated metrics
- AWS services use the format `AWS/<ServiceName>` (e.g., `AWS/EC2`, `AWS/ELB`, `AWS/RDS`)
- Custom metrics can use any namespace (but CANNOT start with `AWS/`)

**Dimensions:**
- A dimension is a name/value pair that uniquely identifies a metric
- Up to **30 dimensions** per metric
- Examples: `InstanceId=i-1234567890abcdef0`, `AutoScalingGroupName=my-asg`
- Same metric name with different dimensions = different metric data streams

**Timestamps:**
- Each data point has a timestamp
- Custom metric data can be sent up to **2 weeks in the past** and **2 hours in the future**

### Metric Resolution

| Resolution | Data Point Interval | Retention | Use Case |
|-----------|-------------------|-----------|----------|
| **Standard** | 1 minute (60 seconds) | 15 days at 1-min, 63 days at 5-min, 455 days at 1-hour | Default for AWS services |
| **High Resolution** | 1 second | 3 hours at 1-sec, 15 days at 1-min, 63 days at 5-min, 455 days at 1-hour | Custom metrics needing real-time monitoring |

**Data Retention:**
- Data points with period < 60 seconds: available for 3 hours
- Data points with period = 60 seconds: available for 15 days
- Data points with period = 300 seconds (5 min): available for 63 days
- Data points with period = 3600 seconds (1 hour): available for 455 days (15 months)

### Custom Metrics

**PutMetricData API:**
- Send custom metrics to CloudWatch
- Batch up to **1,000 metrics** per `PutMetricData` call (max 1 MB)
- Can include timestamp (or CloudWatch assigns current time)
- **StorageResolution**: 1 (high resolution) or 60 (standard)
- Accepts metric values as single values or **StatisticValues** (Sum, Minimum, Maximum, SampleCount)

**Common Custom Metrics:**
- Memory utilization (not provided by default for EC2)
- Disk space utilization (not provided by default for EC2)
- Number of processes running
- Application-specific metrics (request latency, error rates, queue depth)

### EC2 Default Metrics vs Custom Metrics

**Default EC2 Metrics (from hypervisor — no agent needed):**

| Metric | Description |
|--------|-------------|
| `CPUUtilization` | % of allocated compute units in use |
| `DiskReadOps` / `DiskWriteOps` | Read/write operations on instance store |
| `DiskReadBytes` / `DiskWriteBytes` | Bytes read/written to instance store |
| `NetworkIn` / `NetworkOut` | Network bytes in/out |
| `NetworkPacketsIn` / `NetworkPacketsOut` | Network packets in/out |
| `StatusCheckFailed` | Combination of instance and system status |
| `StatusCheckFailed_Instance` | Instance-level health check |
| `StatusCheckFailed_System` | System-level health check (hypervisor/hardware) |
| `StatusCheckFailed_AttachedEBS` | EBS connectivity check |
| `CPUCreditUsage` / `CPUCreditBalance` | T-instance credit metrics |
| `EBSReadOps` / `EBSWriteOps` | EBS operation counts |
| `EBSReadBytes` / `EBSWriteBytes` | EBS byte counts |

**NOT Available by Default (require CloudWatch Agent):**
- Memory utilization (`mem_used_percent`)
- Disk space utilization (`disk_used_percent`)
- Swap usage
- Number of processes
- Detailed per-process metrics

**Default Monitoring vs Detailed Monitoring:**

| Feature | Basic Monitoring | Detailed Monitoring |
|---------|-----------------|-------------------|
| **Period** | 5 minutes | 1 minute |
| **Cost** | Free | Additional charge |
| **Availability** | Default | Must be enabled |

### Cross-Account Metrics

- **Cross-account observability**: Share CloudWatch data across accounts
- **Monitoring account**: Receives metrics from source accounts
- **Source accounts**: Share metrics with the monitoring account
- Set up using CloudWatch cross-account observability in AWS Organizations
- View metrics from multiple accounts in a single dashboard

---

## CloudWatch Alarms

### Overview

CloudWatch Alarms watch a single metric or the result of a math expression and perform actions based on the metric value relative to a threshold over time.

### Alarm States

| State | Description |
|-------|-------------|
| **OK** | Metric is within the defined threshold |
| **ALARM** | Metric has breached the threshold |
| **INSUFFICIENT_DATA** | Not enough data to determine state (common at alarm creation) |

### Alarm Configuration

**Key Settings:**
- **Metric**: The CloudWatch metric to monitor
- **Statistic**: Average, Sum, Minimum, Maximum, p99, p95, etc.
- **Period**: Length of time to evaluate (60s, 300s, etc.)
- **Evaluation Periods**: Number of consecutive periods the metric must breach the threshold
- **Datapoints to Alarm**: Out of the evaluation periods, how many must be breaching (M out of N)
- **Threshold**: Static value or anomaly detection band
- **Comparison Operator**: GreaterThanThreshold, LessThanThreshold, GreaterThanOrEqualToThreshold, LessThanOrEqualToThreshold
- **Missing Data Treatment**: notBreaching, breaching, ignore, missing

**Example: "CPU > 80% for 3 out of 5 consecutive 5-minute periods"**
- Metric: CPUUtilization
- Statistic: Average
- Period: 300 seconds
- Evaluation Periods: 5
- Datapoints to Alarm: 3
- Threshold: 80
- Comparison: GreaterThanThreshold

### Alarm Actions

**EC2 Actions:**
- **Stop**: Stop the EC2 instance
- **Terminate**: Terminate the EC2 instance
- **Reboot**: Reboot the EC2 instance
- **Recover**: Recover the instance to a new host (same instance ID, IP, EBS volumes, instance metadata)

**Auto Scaling Actions:**
- Trigger scale-out or scale-in policies
- Step scaling, simple scaling, or target tracking

**SNS Actions:**
- Send notification to an SNS topic
- Subscribers can be email, SMS, Lambda, SQS, HTTP/HTTPS
- Use for alerting teams, triggering Lambda functions

**Systems Manager OpsCenter:**
- Create OpsItems in OpsCenter

**EventBridge:**
- Alarm state changes generate EventBridge events (for more complex workflows)

### Composite Alarms

Composite alarms combine multiple alarms using **AND** and **OR** logic:

- Reduce alarm noise by requiring multiple conditions
- Example: Alert only when BOTH CPU > 80% AND memory > 90%
- Can use up to 100 child alarms
- Actions fire only when the composite alarm state changes

**Use Case:**
```
Composite Alarm (AND):
  ├── Alarm 1: CPU Utilization > 80%
  └── Alarm 2: Memory Utilization > 90%
→ Only alerts when BOTH conditions are true
```

### Key Exam Points

- Alarms evaluate metrics **within a single region**
- EC2 instance **recover** action: Same IP, EBS, metadata; requires EBS-backed instance
- Use **composite alarms** to reduce alarm noise
- **Missing data treatment** is important for sparse metrics
- Alarm history is retained for **14 days**

---

## CloudWatch Logs

### Overview

CloudWatch Logs enables you to centralize logs from all your systems, applications, and AWS services in a single, highly scalable service.

### Core Concepts

**Log Groups:**
- A group of log streams that share the same retention, monitoring, and access control settings
- Name typically corresponds to the application or service (e.g., `/aws/lambda/my-function`, `/application/myapp`)
- Each log group has a **retention period** (1 day to 10 years, or never expire)
- **Encryption**: Optional encryption with KMS key (CMK)
- **Metric Filters**: Applied at the log group level

**Log Streams:**
- A sequence of log events that share the same source
- For EC2: typically one stream per instance per log file
- For Lambda: one stream per function invocation container
- Automatically created by the sending source

**Log Events:**
- A record of activity with a **timestamp** and raw **message**
- Maximum event size: **256 KB**

### Retention Settings

| Retention | Description |
|-----------|-------------|
| **1 day** | Minimum retention |
| **3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365 days** | Standard options |
| **400, 545, 731, 1096, 1827, 2192, 2557, 2922, 3653 days** | Extended options |
| **Never expire** | Default setting |

### Metric Filters

Metric Filters define search patterns to match terms, phrases, or values in log events and turn log data into CloudWatch metrics:

- **Filter Pattern**: Syntax to match log events (string matching, JSON matching)
- **Metric Value**: What value to publish when a match is found (typically 1 for counting)
- **Default Value**: Value when no match is found (typically 0)

**Examples:**
- Count 404 errors: Filter pattern `[ip, id, user, timestamp, request, status_code = 404, size]`
- Count specific strings: Filter pattern `"ERROR"` or `{ $.statusCode = 500 }`
- JSON matching: `{ $.latency > 1000 }` — find log events with latency over 1000ms

**Metric Filter → Alarm Pipeline:**
```
Log Events → Metric Filter → CloudWatch Metric → CloudWatch Alarm → SNS/Lambda
```

### Subscription Filters

Subscription Filters deliver a real-time stream of log events to a destination:

| Destination | Use Case |
|-------------|----------|
| **Kinesis Data Streams** | Real-time processing with custom consumers |
| **Kinesis Data Firehose** | Near real-time delivery to S3, Redshift, OpenSearch, Splunk |
| **AWS Lambda** | Real-time processing (transform, filter, alert) |

**Cross-Account Log Subscription:**
- Source account creates a subscription filter pointing to a destination in the destination account
- Destination account creates a subscription destination with a resource policy allowing the source account
- Use case: Centralized log processing in a dedicated logging account

**Key Limits:**
- Maximum **2 subscription filters** per log group
- Cannot subscribe to the same destination from the same log group with the same filter pattern

### Export to S3

- **CreateExportTask** API: One-time export of log data to S3
- **NOT real-time**: Takes up to 12 hours to become available
- Encrypted logs require S3 bucket policy allowing CloudWatch Logs
- For near real-time export: Use **Subscription Filters** with Kinesis Data Firehose → S3

### Log Insights Query Syntax

CloudWatch Logs Insights provides an interactive query language for log data:

```
fields @timestamp, @message
| filter @message like /ERROR/
| sort @timestamp desc
| limit 20
```

---

## CloudWatch Logs Insights

### Overview

CloudWatch Logs Insights is a fully managed, interactive, pay-per-query log analytics service. It enables you to search, analyze, and visualize log data using a purpose-built query language.

### Query Syntax

**Basic Commands:**

| Command | Description |
|---------|-------------|
| `fields` | Select specific fields to display |
| `filter` | Filter results based on conditions |
| `stats` | Aggregate data (count, sum, avg, min, max, percentile) |
| `sort` | Sort results by a field |
| `limit` | Limit the number of results |
| `parse` | Extract fields from log events using glob or regex |
| `display` | Control which fields appear in output |

**Automatically Discovered Fields:**
- `@timestamp` — Event timestamp
- `@message` — Raw log message
- `@logStream` — Log stream name
- `@log` — Log group identifier
- `@ingestionTime` — When the event was ingested

### Common Queries

**Find the 25 most recent errors:**
```
fields @timestamp, @message
| filter @message like /ERROR/
| sort @timestamp desc
| limit 25
```

**Count events per hour:**
```
stats count(*) as eventCount by bin(1h)
| sort eventCount desc
```

**Find top 10 most expensive Lambda invocations:**
```
filter @type = "REPORT"
| stats max(@duration) as maxDuration by @requestId
| sort maxDuration desc
| limit 10
```

**Parse and aggregate:**
```
parse @message "user=* action=* status=*" as user, action, status
| stats count(*) as requestCount by user, action
| sort requestCount desc
```

**Calculate percentiles:**
```
filter @type = "REPORT"
| stats avg(@duration) as avgDuration,
        pct(@duration, 95) as p95,
        pct(@duration, 99) as p99
        by bin(5m)
```

### Key Features

- Query multiple log groups simultaneously (up to 50)
- Auto-detects fields in JSON, Apache, and other formats
- Save queries for reuse
- Export results to CloudWatch Dashboards
- **Pricing**: $0.005 per GB of data scanned

---

## CloudWatch Agents

### CloudWatch Logs Agent (Legacy)

The older agent that can ONLY send logs to CloudWatch Logs:
- Single-purpose: log collection only
- Runs on Linux only
- Configuration via `awslogs.conf`
- **Deprecated** — use the unified CloudWatch Agent instead

### Unified CloudWatch Agent

The modern agent that collects both metrics AND logs:

**Capabilities:**
- Collect logs AND send to CloudWatch Logs
- Collect system-level metrics (memory, disk, swap, processes)
- Collect custom application metrics (StatsD, collectd)
- Runs on Linux, Windows, and macOS
- Works on EC2 instances and on-premises servers

**Configuration:**
- JSON configuration file
- Configuration stored in **SSM Parameter Store** for centralized management
- **Configuration wizard**: `amazon-cloudwatch-agent-config-wizard` generates the JSON config
- Configuration can include:
  - Which logs to collect and which log group to send to
  - Which system metrics to collect
  - Metric collection interval
  - Aggregation dimensions

**Metrics Collected by the Unified Agent:**

| Category | Metrics |
|----------|---------|
| **CPU** | Per-CPU or aggregated: time_active, time_idle, time_user, time_system, etc. |
| **Memory** | mem_used, mem_free, mem_used_percent, mem_cached, mem_available |
| **Disk** | disk_used, disk_free, disk_used_percent, disk_inodes_used |
| **Swap** | swap_used, swap_free, swap_used_percent |
| **Network** | net_bytes_sent, net_bytes_recv, net_packets_sent, net_err_in |
| **Processes** | processes_running, processes_sleeping, processes_total |
| **StatsD** | Custom application metrics via StatsD protocol |
| **collectd** | Custom application metrics via collectd protocol |

**Prerequisites:**
- IAM role with `CloudWatchAgentServerPolicy` (EC2) or IAM user credentials (on-premises)
- SSM Agent (if using SSM to manage configuration)
- Network access to CloudWatch Logs and CloudWatch Metrics endpoints

---

## CloudWatch Dashboards

### Overview

CloudWatch Dashboards are customizable home pages for monitoring resources in a single view.

### Key Features

- **Global service**: Dashboards can include widgets from any AWS region
- **Cross-account**: Can display metrics from multiple AWS accounts
- **Widget types**: Line charts, stacked area, number, gauge, bar, pie, text, log table, alarm status, explorer
- **Auto-refresh**: 10 seconds, 1 minute, 2 minutes, 5 minutes, 15 minutes
- **Time range**: Pre-defined (1h, 3h, 12h, 1d, 3d, 1w) or custom
- **Sharing**: Share dashboards publicly (anyone with the link), with specific email addresses, or via SSO
- **API/CLI**: Dashboards can be created and managed programmatically

**Pricing:**
- First 3 dashboards: Free (up to 50 metrics per dashboard)
- Additional dashboards: $3.00 per dashboard per month

**Cross-Account Cross-Region Dashboard:**
- View metrics from multiple accounts and regions in a single dashboard
- Requires cross-account observability setup
- Set up monitoring account and source accounts

---

## Amazon EventBridge (CloudWatch Events)

### Overview

Amazon EventBridge (formerly CloudWatch Events) is a **serverless event bus** that makes it easier to build event-driven applications. CloudWatch Events has been fully migrated to EventBridge — they use the same underlying service and API.

### Key Concepts

**Event Buses:**
- **Default event bus**: Receives events from AWS services automatically
- **Custom event buses**: Receive events from custom applications
- **Partner event buses**: Receive events from SaaS partners (Datadog, Zendesk, Auth0, etc.)

**Rules:**
- Match incoming events and route them to targets
- **Event Pattern**: JSON-based matching on event structure
- **Schedule**: Cron or rate expressions (replaces CloudWatch Events schedules)
- Up to **300 rules** per event bus (adjustable)
- A single rule can have up to **5 targets**

**Targets:**
Lambda, SQS, SNS, Kinesis Data Streams, Kinesis Data Firehose, Step Functions, ECS Tasks, SSM Run Command, SSM Automation, CodePipeline, CodeBuild, Batch, API Gateway, Redshift, SageMaker, EventBridge (cross-account/cross-region)

### Event Patterns

```json
{
  "source": ["aws.ec2"],
  "detail-type": ["EC2 Instance State-change Notification"],
  "detail": {
    "state": ["terminated", "stopped"]
  }
}
```

### EventBridge Scheduler

- Centralized scheduler for one-time or recurring tasks
- More powerful than simple EventBridge rules with schedule expressions
- Supports: At expression (one-time), Rate expression, Cron expression
- Built-in retry policies and dead-letter queues

### EventBridge Pipes

- Point-to-point integration between event sources and targets
- Sources: SQS, Kinesis, DynamoDB Streams, Managed Kafka, Self-managed Kafka
- Optional: Filtering, enrichment (Lambda, Step Functions, API Gateway, API Destination)
- Targets: Any EventBridge target

### Schema Registry

- Auto-discovers event schemas from event buses
- Download code bindings for your programming language
- Schema versioning

### Archive and Replay

- **Archive**: Store events from an event bus indefinitely or for a retention period
- **Replay**: Replay archived events to an event bus
- Use case: Reprocess events after fixing a bug, testing, disaster recovery

### Global Endpoints

- Route events to multiple regions for high availability
- Active-active or active-passive configurations
- Automatic failover when health checks fail

### Key Exam Points

- EventBridge is the **evolution** of CloudWatch Events (same API, more features)
- Use for **event-driven architectures** and **reactive workflows**
- **Cron scheduling**: EventBridge Schedule for serverless cron jobs (replaces CloudWatch Events rules)
- Partner integrations make it valuable for SaaS event processing
- Cross-account event routing: Event bus resource policy allows other accounts to put events

---

## CloudWatch Contributor Insights

### Overview

CloudWatch Contributor Insights helps you analyze log data and create time-series displays showing the **top-N contributors** to system performance.

### How It Works

- Define rules that match log fields using JSON
- Contributor Insights analyzes log groups in real-time
- Creates ranked lists of top contributors (top IP addresses, top URLs, top users, etc.)
- Built-in rules for AWS services (VPC Flow Logs, API Gateway, etc.)

### Use Cases

- **Top talkers**: Find IP addresses generating the most traffic
- **Heavy hitters**: Identify URLs with the most requests or errors
- **Noisy neighbors**: Find users consuming the most resources
- **Error analysis**: Top error-generating endpoints or users
- **Performance analysis**: URLs with the highest latency

### Key Exam Points

- Useful for identifying "who is causing the most impact" (top-N analysis)
- Works on CloudWatch Logs data
- Built-in rules for common AWS services
- Can create CloudWatch alarms on Contributor Insights metrics

---

## CloudWatch Synthetics

### Overview

CloudWatch Synthetics allows you to create **canary scripts** that monitor your endpoints and APIs. Canaries are configurable scripts that run on a schedule.

### How It Works

1. Create a **canary** (script) that tests your endpoint
2. Define a **schedule** (run every 1 minute, 5 minutes, etc.)
3. Canary runs on a **Lambda function** (managed by Synthetics)
4. Results include screenshots (for UI canaries), HAR files, logs, and metrics
5. **Alarms** can be created on canary metrics (success/failure)

### Canary Types (Blueprints)

| Blueprint | Description |
|-----------|-------------|
| **Heartbeat Monitor** | Check if a URL is reachable (HTTP GET) |
| **API Canary** | Test REST API endpoints (GET, POST, PUT, DELETE) |
| **Broken Link Checker** | Crawl a page and check all links |
| **Visual Monitoring** | Compare screenshots against a baseline (detect UI changes) |
| **Canary Recorder** | Use Chrome recorder to create canary scripts |
| **GUI Workflow Builder** | Test multi-step UI workflows (login, checkout) |

### Key Features

- **Node.js or Python** runtime
- Access to the full Puppeteer (Node.js) or Selenium (Python) framework
- Can navigate pages, fill forms, click buttons, take screenshots
- Integration with CloudWatch Alarms for alerting on failures
- Integration with X-Ray for tracing
- Can run in your VPC (for testing internal endpoints)

### Key Exam Points

- Use Synthetics for **proactive monitoring** (detect problems before users do)
- **Canary scripts** simulate user behavior
- Runs on a schedule (not triggered by events)
- Great for monitoring: website availability, API health, SSL certificate expiry, UI regressions

---

## CloudWatch ServiceLens & X-Ray

### ServiceLens

CloudWatch ServiceLens provides a **single place** to view the health, performance, and availability of your application:

- Combines CloudWatch metrics, logs, and traces into a unified view
- **Service Map**: Visual representation of services and their dependencies
- **Trace Map**: View distributed traces through your application
- Integration with X-Ray for distributed tracing

### AWS X-Ray

X-Ray provides **distributed tracing** for applications:

- Trace requests as they flow through microservices
- Identify performance bottlenecks and errors
- Visualize service dependencies with service maps
- Analyze latency distributions

**Key Concepts:**
- **Trace**: End-to-end path of a request
- **Segment**: Work done by a single service
- **Subsegment**: More granular work within a segment (e.g., external API call, database query)
- **Sampling**: Control how many requests are traced (reduce cost)
- **Groups**: Filter traces by expression
- **Annotations**: Key-value pairs indexed for search
- **Metadata**: Key-value pairs NOT indexed (additional context)

**X-Ray Integration:**
- Lambda, API Gateway, ECS, EKS, Elastic Beanstalk, EC2 (X-Ray daemon)
- Requires X-Ray SDK in application code
- X-Ray daemon collects and sends trace data

---

## CloudWatch Application Insights

### Overview

CloudWatch Application Insights provides **automated monitoring** for .NET and SQL Server applications, Java applications, and other common technology stacks.

### Key Features

- Automatically discovers and configures monitoring for application components
- Detects common application problems
- Creates automated dashboards
- Generates CloudWatch Alarms for detected issues
- Supports: IIS, .NET, SQL Server, Java, MySQL, PostgreSQL, SAP HANA, Oracle, and more
- Works with EC2, ECS, RDS, Lambda, DynamoDB, API Gateway, S3, SQS, SNS, Step Functions

### Key Exam Points

- Simplifies monitoring setup for complex applications
- Best for common enterprise application stacks (.NET, Java, SQL Server)
- Automated problem detection and alerting

---

## CloudWatch Container Insights

### Overview

CloudWatch Container Insights collects, aggregates, and summarizes **metrics and logs from containerized applications** and microservices.

### Supported Platforms

| Platform | Metrics Collected |
|----------|-------------------|
| **Amazon ECS** | CPU, memory, disk, network at task, service, and cluster level |
| **Amazon EKS** | CPU, memory, disk, network at pod, node, namespace, service, and cluster level |
| **Kubernetes on EC2** | Same as EKS |
| **AWS Fargate** | Task-level metrics |

### How It Works

- **ECS**: Enable Container Insights at the cluster level (account-level setting or per-cluster)
- **EKS**: Deploy the CloudWatch Agent as a DaemonSet
- **Enhanced Observability**: Use CloudWatch Agent with Fluent Bit for log collection
- Metrics are published to the `ContainerInsights` namespace
- Performance log events stored in CloudWatch Logs (queryable with Logs Insights)

### Metrics Available

- **Cluster**: CPU utilization, memory utilization, running task count, running pod count
- **Service/Deployment**: CPU, memory utilization, desired task count, running task count
- **Task/Pod**: CPU, memory utilization, network bytes
- **Node**: CPU, memory, disk, network utilization, number of pods

### Key Exam Points

- Container Insights is the go-to for **ECS and EKS monitoring**
- Provides both metrics and logs for containers
- For EKS, requires deploying a CloudWatch Agent DaemonSet
- For ECS on Fargate, Container Insights provides task-level metrics

---

## CloudWatch Anomaly Detection

### Overview

CloudWatch Anomaly Detection uses **machine learning** to continuously analyze metric data and create a **model of expected values** (anomaly detection band).

### How It Works

1. Enable anomaly detection on a CloudWatch metric
2. CloudWatch trains an ML model on 2 weeks of historical data
3. Model creates an **expected value band** that accounts for trends, hourly/daily/weekly patterns
4. When the metric value falls outside the band, it's flagged as anomalous
5. Create **anomaly detection alarms** that trigger when metrics are outside the band

### Key Features

- Automatically adjusts for seasonality (daily, weekly patterns)
- Accounts for trends (gradual increase/decrease)
- Handles metric changes (e.g., deployments that change baseline)
- Can exclude specific time periods from the model (e.g., known deployments)
- Works with any CloudWatch metric (AWS or custom)

### Use Cases

- Detect unusual CPU spikes that deviate from normal patterns
- Identify abnormal network traffic
- Alert on unexpected changes in error rates
- Monitor business metrics for anomalies

---

## AWS CloudTrail

### Overview

AWS CloudTrail provides **governance, compliance, and operational and risk auditing** of your AWS account. CloudTrail records AWS API calls as **events** and delivers them to an S3 bucket, CloudWatch Logs, or EventBridge.

### Event Types

| Event Type | Description | Default |
|------------|-------------|---------|
| **Management Events** | API calls that manage AWS resources (create, modify, delete). Also called "control plane operations" | Enabled by default |
| **Data Events** | API calls that operate ON resources (S3 GetObject, Lambda Invoke, DynamoDB GetItem). Also called "data plane operations" | **Disabled by default** (high volume, extra cost) |
| **Insights Events** | Detect unusual API activity patterns (unusual volume of API calls, error rates) | **Disabled by default** (extra cost) |

**Management Events Examples:**
- `CreateBucket`, `DeleteBucket`, `PutBucketPolicy` (S3)
- `RunInstances`, `TerminateInstances`, `AuthorizeSecurityGroupIngress` (EC2)
- `CreateUser`, `AttachRolePolicy`, `AssumeRole` (IAM)
- `CreateTrail`, `PutEventSelectors` (CloudTrail)

**Data Events Examples:**
- `s3:GetObject`, `s3:PutObject`, `s3:DeleteObject`
- `lambda:Invoke`
- `dynamodb:PutItem`, `dynamodb:GetItem`

**Insights Events:**
- Detect unusual **write** management API activity
- Establish a baseline of normal activity, then detect deviations
- Example: Sudden spike in `TerminateInstances` calls, unusual `RunInstances` volume

### Trail Types

| Trail Type | Description |
|------------|-------------|
| **Single-Region Trail** | Records events in the region where it's created only |
| **All-Region Trail** | Records events in **all regions** (recommended) |
| **Organization Trail** | Records events for **all accounts** in the organization (created from the management account or delegated administrator) |

**Best Practice:** Create an all-region trail that logs to a centralized S3 bucket.

### Log File Integrity Validation

CloudTrail can validate that log files have not been modified, deleted, or forged:

- **SHA-256 hashing**: Each log file is hashed
- **Digest files**: Hourly digest files contain hashes of all log files in that hour
- **Chain of trust**: Each digest file references the previous digest file (creating a chain)
- Use `aws cloudtrail validate-logs` CLI command to verify integrity
- Important for **forensics** and **compliance** (proving logs haven't been tampered with)

### CloudTrail Lake

CloudTrail Lake is a managed **data lake** for CloudTrail events:

- Store events for up to **7 years** (configurable retention)
- Query events using **SQL** syntax
- No need to configure S3 buckets, Athena, or Glue
- Supports management events, data events, Insights events, and non-API activity events
- Cross-account event collection
- **Event data stores**: Containers for events with retention and pricing configuration

**Query Example:**
```sql
SELECT eventTime, userIdentity.arn, eventName, requestParameters
FROM my-event-data-store
WHERE eventName = 'TerminateInstances'
AND eventTime > '2024-01-01 00:00:00'
ORDER BY eventTime DESC
```

### CloudTrail Event History

- Free 90-day history of management events
- Viewable in the CloudTrail Console
- Searchable by event name, resource type, user name, etc.
- Cannot be extended — to retain events longer, create a trail
- Data events and Insights events are NOT in Event History

### CloudTrail Integration

| Integration | Description |
|-------------|-------------|
| **S3** | Store log files in S3 with SSE-S3 or SSE-KMS encryption. Apply lifecycle rules for cost optimization |
| **CloudWatch Logs** | Deliver events to a log group for real-time monitoring and alerting via Metric Filters |
| **EventBridge** | React to specific API calls in real-time (fastest integration) |
| **SNS** | Notifications when new log files are delivered |
| **Athena** | Query CloudTrail logs in S3 using SQL |
| **Security Hub** | CloudTrail findings feed into Security Hub |

### Key Exam Points

- Event History: **90 days**, management events only, **free**
- Trails: Persist events to S3 (indefinitely), CloudWatch Logs, EventBridge
- Data events: **Disabled by default**, S3 object-level and Lambda invocations
- Organization trails: One trail for ALL accounts
- Log file integrity: Proves logs haven't been tampered with
- EventBridge: Fastest way to react to API calls
- CloudTrail Lake: SQL queries on events without managing infrastructure

---

## AWS Config

### Overview

AWS Config is a service that enables you to **assess, audit, and evaluate the configurations** of your AWS resources. It records configuration changes and evaluates them against desired configurations.

### Key Concepts

**Configuration Items (CIs):**
- A point-in-time record of the configuration of a resource
- Contains: resource type, ARN, tags, relationships, configuration data, metadata
- Stored in the **configuration history** for each resource
- Changes trigger recording of a new CI

**Configuration Recorder:**
- Records configuration changes for supported resource types
- Can record ALL resource types or SPECIFIC types
- **Must be enabled** for Config to work
- One recorder per region per account

**Delivery Channel:**
- Where Config sends configuration data
- **S3 bucket** (required): Configuration snapshots, configuration history files
- **SNS topic** (optional): Notifications of configuration changes and compliance status

### Config Rules

Config Rules evaluate whether your resources comply with desired configurations.

**AWS Managed Rules:**
- Pre-built rules by AWS (200+ rules)
- Examples:
  - `s3-bucket-server-side-encryption-enabled` — Check S3 bucket encryption
  - `restricted-ssh` — Check no security group allows SSH from 0.0.0.0/0
  - `ec2-instance-no-public-ip` — Check EC2 instances don't have public IPs
  - `rds-instance-public-access-check` — Check RDS instances aren't public
  - `cloudtrail-enabled` — Check CloudTrail is enabled
  - `iam-password-policy` — Check IAM password policy compliance
  - `ebs-optimized-instance` — Check if EBS optimization is enabled
  - `required-tags` — Check resources have required tags

**Custom Rules:**
- Evaluate compliance using **Lambda functions** (Custom Lambda Rules)
- Or using **Guard** (Custom Policy Rules) — declarative, no Lambda needed
- Trigger types:
  - **Configuration change**: Evaluates when a resource is created, changed, or deleted
  - **Periodic**: Evaluates on a schedule (1, 3, 6, 12, or 24 hours)

### Conformance Packs

- Collection of Config rules and remediation actions packaged as a single entity
- Defined as a YAML template
- Deploy across an organization with AWS Organizations
- Pre-built conformance packs: CIS Benchmarks, NIST, PCI DSS, HIPAA, etc.
- Custom conformance packs for organization-specific requirements

### Config Aggregator

Config Aggregator collects Config data from **multiple accounts and regions** into a single account:

- **Aggregator account**: The account that collects data (typically a central security account)
- **Source accounts**: Accounts that share their Config data
- **Authorization**: Source accounts must authorize the aggregator (or use Organizations for automatic authorization)
- View compliance status across the entire organization in one dashboard
- Query aggregated data with **Advanced Queries** (SQL-like syntax)

### Config Remediation

**Automatic Remediation:**
- Associate a remediation action with a Config rule
- When a resource is non-compliant, Config automatically triggers the remediation
- Uses **SSM Automation** runbooks as remediation actions
- Example: Non-compliant security group → SSM Automation removes the offending rule
- Retry configuration: Number of retries, retry interval

**Manual Remediation:**
- Same as automatic but requires manual trigger
- Review non-compliant resources before applying remediation

**Example Remediation Actions:**
- `AWS-DisablePublicAccessForSecurityGroup` — Remove 0.0.0.0/0 rules
- `AWS-EnableCloudTrail` — Enable CloudTrail
- `AWS-EnableS3BucketEncryption` — Enable S3 encryption
- Custom SSM Automation runbooks for organization-specific remediation

### Config Timeline

For each resource, Config maintains a timeline showing:
- Configuration changes over time
- Compliance status changes
- Related CloudTrail events (who made the change)
- Related Config rules and their evaluation results

### Compliance Dashboard

- Visual overview of compliance status across all rules
- Drill down by rule, resource type, or specific resource
- Historical compliance data
- Export compliance data for audits

### Key Exam Points

- Config answers: **"What changed?"** and **"Is it compliant?"**
- Requires **Configuration Recorder** and **Delivery Channel** (S3)
- Aggregators for **multi-account, multi-region** visibility
- Remediation uses **SSM Automation** runbooks
- Config is a **prerequisite** for Security Hub and Firewall Manager
- Config rules evaluate compliance, NOT prevent changes (detective, not preventive)

---

## AWS Trusted Advisor

### Overview

AWS Trusted Advisor provides **recommendations** across five categories to help you follow AWS best practices.

### Five Categories

| Category | What It Checks |
|----------|----------------|
| **Cost Optimization** | Idle resources, underutilized EC2, Reserved Instance optimization, unused EBS volumes |
| **Performance** | Overutilized resources, CloudFront optimization, EC2 instance type recommendations |
| **Security** | Open security groups, IAM usage, MFA on root, S3 bucket permissions, CloudTrail enabled |
| **Fault Tolerance** | AZ balance, RDS Multi-AZ, EBS snapshots, Route 53 health checks, Auto Scaling groups |
| **Service Limits** | Check how close you are to AWS service limits (quotas) |
| **Operational Excellence** | (Added category) Log and backup configurations |

### Access Levels

| Support Plan | Available Checks |
|-------------|-----------------|
| **Basic / Developer** | 7 core checks only (S3 bucket permissions, security groups, IAM use, MFA on root, EBS public snapshots, RDS public snapshots, service limits) |
| **Business / Enterprise / Enterprise On-Ramp** | ALL checks (50+ checks), API access, CloudWatch Alarms integration, weekly email notifications |

### Key Features

- **Refresh**: Checks are refreshed periodically (minimum once every 24 hours for most checks)
- **API Access**: Business+ support plans can use the Trusted Advisor API
- **CloudWatch Integration**: Business+ can set CloudWatch Alarms on Trusted Advisor metrics
- **EventBridge Integration**: React to Trusted Advisor check status changes
- **Organizational View**: View across all accounts in AWS Organizations (Business+ on management account)

### Key Exam Points

- Basic/Developer plan: Only **7 core security and service limit checks**
- Business/Enterprise: Full access to ALL checks + API + CloudWatch
- Use Trusted Advisor for **cost optimization** recommendations (idle ELBs, underutilized EC2)
- Use for **service limit** monitoring

---

## Config vs CloudTrail vs CloudWatch Comparison

| Feature | CloudWatch | CloudTrail | Config |
|---------|-----------|------------|--------|
| **Primary Purpose** | Monitor **performance** and **operational health** | Record **API activity** (who did what, when) | Track **configuration compliance** (is it configured correctly?) |
| **Question Answered** | "How is my resource performing?" | "Who made this change?" | "Is my resource compliant?" |
| **Data Type** | Metrics, Logs, Events | API call logs (events) | Configuration items, compliance status |
| **Real-Time** | Yes (metrics, alarms) | Near real-time (EventBridge) | Near real-time (change-triggered rules) |
| **Retention** | Metrics: up to 15 months; Logs: configurable | 90 days free (Event History); S3 for longer | 7 years (in delivery channel S3) |
| **Key Integration** | Alarms → SNS, EC2, ASG | EventBridge, S3, CloudWatch Logs | SSM Automation (remediation) |
| **Example** | Alert when CPU > 80% | Know who terminated an EC2 instance | Ensure all S3 buckets have encryption enabled |
| **Scope** | Resources, applications | API calls, user activity | Resource configurations |

**They Work Together:**
```
CloudTrail: "User X changed security group SG-123 at 2:00 PM"
Config:     "Security group SG-123 is now non-compliant (port 22 open to 0.0.0.0/0)"
CloudWatch: "EventBridge event triggered → Lambda function → remediation applied"
```

### The Investigation Flow

1. **CloudWatch Alarm** fires (e.g., unusual network traffic increase)
2. **CloudTrail** reveals who made changes (e.g., security group modified at 1:55 PM)
3. **Config** shows what the configuration looked like before and after the change
4. **Config Remediation** automatically reverts the change if non-compliant

---

## Common Exam Scenarios

### Scenario 1: Monitor EC2 Memory Usage

**Question**: A company needs to monitor memory usage on EC2 instances and receive alerts when memory exceeds 85%.

**Answer**: Install the **Unified CloudWatch Agent** on EC2 instances. Configure it to collect `mem_used_percent` metric. Create a **CloudWatch Alarm** on the `CWAgent/mem_used_percent` metric with a threshold of 85%. Set the alarm action to send notifications via **SNS**. Memory is NOT a default EC2 metric — requires the CloudWatch Agent.

### Scenario 2: Centralized Logging

**Question**: A company with 100 AWS accounts needs centralized logging with real-time analysis capability.

**Answer**: Use **CloudWatch Logs** with the Unified CloudWatch Agent on all instances. Set up **cross-account log subscription** to a central logging account. Use **Kinesis Data Firehose** subscription filter to deliver logs to a centralized **S3 bucket** for long-term storage. Use **CloudWatch Logs Insights** for real-time analysis across accounts.

### Scenario 3: Detect Unauthorized API Calls

**Question**: A security team wants to be alerted immediately when someone calls specific API actions (e.g., `DeleteTrail`, `StopLogging`).

**Answer**: Ensure **CloudTrail** is enabled with an all-region trail. Set up an **EventBridge rule** matching the specific API call event pattern. Target the rule to **SNS** for immediate notification. EventBridge provides the fastest response to API calls (seconds). Alternatively, deliver CloudTrail to CloudWatch Logs and use Metric Filters, but this is slower.

### Scenario 4: Ensure All S3 Buckets Are Encrypted

**Question**: A company must ensure all S3 buckets across 50 accounts have server-side encryption enabled and automatically fix non-compliant buckets.

**Answer**: Enable **AWS Config** across all accounts with a **Config Aggregator** in a central account. Deploy the managed rule `s3-bucket-server-side-encryption-enabled`. Configure **automatic remediation** using the SSM Automation runbook `AWS-EnableS3BucketEncryption`. The aggregator provides a single compliance dashboard across all accounts.

### Scenario 5: Cost Optimization Recommendations

**Question**: A company wants to identify underutilized EC2 instances and unused EBS volumes to reduce costs.

**Answer**: Use **AWS Trusted Advisor** (requires Business or Enterprise Support plan for full checks). Trusted Advisor checks for low-utilization EC2 instances and unattached EBS volumes. For EC2 right-sizing, also use **AWS Compute Optimizer** which provides more detailed recommendations based on CloudWatch metrics.

### Scenario 6: Compliance Audit Trail

**Question**: An auditor needs to prove that CloudTrail logs have not been tampered with over the past year.

**Answer**: Ensure CloudTrail has **log file integrity validation** enabled. Use the `aws cloudtrail validate-logs` CLI command to verify log file integrity using digest files. Store logs in an S3 bucket with **Object Lock** (WORM compliance) to prevent deletion. Enable **MFA Delete** on the S3 bucket for additional protection.

### Scenario 7: Real-Time Application Monitoring

**Question**: A company runs a microservices application and needs to identify which service is causing increased latency.

**Answer**: Use **AWS X-Ray** for distributed tracing to trace requests across microservices and identify bottleneck services. Integrate with **CloudWatch ServiceLens** for a unified view combining metrics, logs, and traces. Deploy X-Ray SDK in application code and X-Ray daemon on EC2 instances (or use Lambda/API Gateway built-in X-Ray support).

### Scenario 8: Who Changed the Security Group?

**Question**: A security group was modified and the team needs to find out who made the change and what was changed.

**Answer**: Check **CloudTrail** for the `AuthorizeSecurityGroupIngress`, `RevokeSecurityGroupIngress`, or `ModifySecurityGroupRules` API calls. CloudTrail shows WHO (IAM user/role), WHEN (timestamp), and WHAT (request parameters). Check **AWS Config** for the configuration timeline showing the before/after configuration of the security group.

### Scenario 9: Monitor Container Workloads

**Question**: A company runs ECS on Fargate and needs CPU and memory metrics at the task and cluster level.

**Answer**: Enable **CloudWatch Container Insights** for the ECS cluster (can be done at the account level or per-cluster). Container Insights automatically collects CPU, memory, network, and storage metrics at the cluster, service, and task level. View metrics in CloudWatch dashboards and set alarms on container-level metrics.

### Scenario 10: Proactive Endpoint Monitoring

**Question**: A company wants to monitor their e-commerce website's availability and detect broken links before customers report issues.

**Answer**: Create **CloudWatch Synthetics canaries** using the "Heartbeat Monitor" blueprint for availability checks and "Broken Link Checker" for link validation. Run canaries every 5 minutes. Set up CloudWatch Alarms on canary metrics for immediate alerting when endpoints fail. Synthetics is proactive monitoring — detects issues before users.

### Scenario 11: Detect Configuration Drift

**Question**: A company needs to know when resource configurations drift from their desired state and automatically remediate.

**Answer**: Use **AWS Config** with Config rules to define the desired configuration. When drift is detected (resource becomes non-compliant), Config triggers **automatic remediation** using SSM Automation runbooks. Use **EventBridge** to notify the team of non-compliance events. For CloudFormation-managed resources, use **CloudFormation Drift Detection**.

---

## Key Takeaways for the Exam

1. **CloudWatch Metrics**: EC2 default metrics do NOT include memory or disk — requires CloudWatch Agent
2. **CloudWatch Alarms**: Can trigger EC2 actions (stop, terminate, reboot, recover), ASG, SNS
3. **Composite Alarms**: Combine multiple alarms with AND/OR logic to reduce noise
4. **CloudWatch Logs**: Metric Filters turn logs into metrics → alarms; Subscription Filters for real-time streaming
5. **Logs Insights**: Pay-per-query SQL-like analysis of log data
6. **Unified CloudWatch Agent**: Collects both metrics (memory, disk) AND logs — replaces the old logs agent
7. **EventBridge**: Successor to CloudWatch Events — event bus for event-driven architectures
8. **Container Insights**: ECS/EKS monitoring for CPU, memory, network at task/pod/cluster level
9. **CloudTrail**: Who did what? 90-day free history; trails for long-term S3 storage; log integrity validation
10. **CloudTrail Data Events**: S3 object-level and Lambda invocations — disabled by default, extra cost
11. **CloudTrail Lake**: SQL queries on CloudTrail events without managing infrastructure
12. **Config**: Is it compliant? Configuration recorder + rules + remediation (SSM Automation)
13. **Config Aggregator**: Multi-account, multi-region compliance view
14. **Config is prerequisite** for Security Hub and Firewall Manager
15. **Trusted Advisor**: 7 core checks (Basic/Developer) vs ALL checks (Business/Enterprise)
