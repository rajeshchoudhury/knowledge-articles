# Monitoring and Observability — AWS SAP-C02 Domain 5

## Table of Contents
1. [CloudWatch Deep Dive](#1-cloudwatch-deep-dive)
2. [AWS X-Ray](#2-aws-x-ray)
3. [Amazon Managed Grafana and Prometheus](#3-amazon-managed-grafana-and-prometheus)
4. [AWS Health Dashboard](#4-aws-health-dashboard)
5. [EventBridge for Operational Events](#5-eventbridge-for-operational-events)
6. [CloudWatch vs Third-Party Tools](#6-cloudwatch-vs-third-party-tools)
7. [Observability Strategy — Three Pillars](#7-observability-strategy--three-pillars)
8. [Cross-Account/Cross-Region Monitoring](#8-cross-accountcross-region-monitoring)
9. [Exam Scenarios](#9-exam-scenarios)

---

## 1. CloudWatch Deep Dive

### 1.1 CloudWatch Metrics

**Standard vs Custom vs High-Resolution:**

| Type | Frequency | Cost | Source |
|---|---|---|---|
| **Standard** | 5-minute intervals (free) | Free | AWS services auto-publish |
| **Detailed Monitoring** | 1-minute intervals | $3.00/instance/month | EC2 detailed monitoring |
| **Custom** | 1-minute default | $0.30/metric/month | CloudWatch Agent, PutMetricData API |
| **High-Resolution** | 1-second intervals | Same as custom | Custom metrics with StorageResolution=1 |

**Key EC2 Metrics (Standard):**
| Metric | Description | NOT Available by Default |
|---|---|---|
| CPUUtilization | % CPU used | |
| NetworkIn/Out | Bytes transferred | |
| DiskReadOps/WriteOps | Disk I/O operations | |
| StatusCheckFailed | System/instance checks | |
| **Memory utilization** | RAM usage | **Requires CloudWatch Agent** |
| **Disk space** | Filesystem usage | **Requires CloudWatch Agent** |
| **Process count** | Running processes | **Requires CloudWatch Agent** |

### 1.2 CloudWatch Alarms

**Alarm States:** OK → ALARM → INSUFFICIENT_DATA

**Alarm Types:**

| Type | Description | Use Case |
|---|---|---|
| **Standard** | Single metric threshold | CPU > 80% |
| **Composite** | Combine multiple alarms with AND/OR | CPU > 80% AND Memory > 90% |
| **Anomaly Detection** | ML-based dynamic threshold | Detect unusual patterns |

**Composite Alarm Example:**
```
Composite Alarm: "ServiceDegraded"
├── Rule: ALARM("HighCPU") AND ALARM("HighLatency")
│
│   HighCPU:        CPUUtilization > 80% for 5 minutes
│   HighLatency:    TargetResponseTime > 2s for 5 minutes
│
│   Only fires when BOTH conditions are true
│   Reduces alert noise (CPU alone might not be a problem)
│
└── Action: SNS → PagerDuty (on-call engineer)
```

**Anomaly Detection:**
```
CloudWatch Anomaly Detection:
┌─────────────────────────────────────────────────────┐
│  ML model learns normal patterns:                    │
│  - Daily cycles (high during business hours)        │
│  - Weekly patterns (lower on weekends)              │
│  - Seasonal trends                                   │
│                                                      │
│  Normal band:  ═══════════╗                         │
│               ╱            ╚═══════╗                │
│  ════════════╝                      ╚═══════════    │
│                                                      │
│  Alert when metric goes OUTSIDE the band:           │
│                         ╔═╗ ← anomaly!              │
│               ═════════╗║ ║╔═══════╗                │
│              ╱          ╚╝ ╝        ╚═══════════    │
│  ═══════════╝                                       │
└─────────────────────────────────────────────────────┘
```

### 1.3 CloudWatch Dashboards

**Cross-Account/Cross-Region Dashboards:**
```
Central Monitoring Account Dashboard:
┌──────────────────────────────────────────────────────────┐
│  Organization Health Dashboard                            │
│  ┌─────────────────────────────────────────────────────┐│
│  │  Account: Production (us-east-1)                     ││
│  │  ├── EC2 CPU: 45% avg, 78% peak                    ││
│  │  ├── RDS: 3 instances, all healthy                  ││
│  │  └── ALB: 2,500 req/sec, 50ms latency              ││
│  ├─────────────────────────────────────────────────────┤│
│  │  Account: Production (eu-west-1)                     ││
│  │  ├── EC2 CPU: 35% avg, 60% peak                    ││
│  │  └── Aurora: 2 clusters, replication lag 5ms        ││
│  ├─────────────────────────────────────────────────────┤│
│  │  Account: Staging (us-east-1)                        ││
│  │  └── EC2 CPU: 15% avg (normal for staging)          ││
│  └─────────────────────────────────────────────────────┘│
└──────────────────────────────────────────────────────────┘

Setup: Enable cross-account observability using CloudWatch OAM
(Observability Access Manager)
```

### 1.4 CloudWatch Logs

**Key Components:**

| Component | Description |
|---|---|
| **Log Group** | Collection of log streams (e.g., /aws/lambda/my-function) |
| **Log Stream** | Sequence of events from a single source |
| **Log Event** | Individual log entry with timestamp |
| **Retention** | 1 day to 10 years (or never expire) |
| **Encryption** | KMS encryption at rest |

**Log Subscriptions:**
```
Log Group → Subscription Filter → Destination

Destinations:
├── Lambda function (real-time processing)
├── Kinesis Data Streams (real-time analytics)
├── Kinesis Data Firehose (near real-time to S3, OpenSearch, Redshift)
└── Another account's CW Logs (cross-account)

Example: Real-time error alerting
Log Group (/app/production)
  → Subscription Filter: { $.level = "ERROR" }
    → Lambda: Parse error, create OpsItem in Systems Manager
    → SNS: Alert on-call engineer
```

**Cross-Account Log Subscriptions:**
```
Account A (Source)                   Account B (Central Logging)
┌──────────────────┐               ┌──────────────────────┐
│  Log Groups       │               │  Kinesis Firehose    │
│  ├── /app/prod    │──Subscription─▶│  → S3 (centralized   │
│  ├── /app/staging │  Filter       │    log archive)      │
│  └── /aws/lambda  │               │  → OpenSearch        │
└──────────────────┘               │    (search/analytics) │
                                    └──────────────────────┘
```

### 1.5 CloudWatch Logs Insights

**Query Language:**
```
# Find the 10 most expensive Lambda invocations
fields @timestamp, @duration, @billedDuration, @memorySize, @maxMemoryUsed
| filter @type = "REPORT"
| sort @duration desc
| limit 10

# Count errors per hour
fields @timestamp, @message
| filter @message like /ERROR/
| stats count(*) as errorCount by bin(1h)

# Parse structured JSON logs
fields @timestamp, @message
| parse @message '{"requestId":"*","statusCode":*,"duration":*}' 
  as requestId, statusCode, duration
| filter statusCode >= 500
| stats count(*) as errors by bin(5m)

# Find P95 latency
fields @timestamp, duration
| stats pct(duration, 95) as p95 by bin(1h)
```

### 1.6 Metric Filters

Convert log data into CloudWatch metrics:

```
Log Entry: "2024-03-15 10:30:00 ERROR PaymentService - Payment failed for order 12345"

Metric Filter:
├── Filter Pattern: "ERROR PaymentService"
├── Metric Name: PaymentErrors
├── Metric Namespace: CustomApp
├── Metric Value: 1
└── Result: Increments PaymentErrors metric each time pattern matches

Then create alarm: PaymentErrors > 5 in 5 minutes → Alert
```

### 1.7 CloudWatch Contributor Insights

Analyzes log data to identify top contributors to system behavior:

```
Rule: "Top 10 IP addresses generating 5xx errors"
Log Group: /aws/apigateway/my-api
Key: $.sourceIP
Filter: { $.status >= 500 }

Output:
IP Address       5xx Count    % of Total
──────────────────────────────────────────
203.0.113.50     1,234        45%     ← Possible attack
198.51.100.23      456        17%
192.0.2.100        234         9%
...
```

### 1.8 CloudWatch Synthetics (Canaries)

```
Canary: Automated synthetic monitoring scripts that run on a schedule.

Types:
├── Heartbeat: Monitor URL availability
├── API: Test REST API endpoints
├── Broken Link Checker: Find broken links on website
├── Visual Monitoring: Screenshot comparison
├── GUI Workflow: Multi-step browser interactions (login, add to cart, checkout)

Architecture:
EventBridge Schedule (every 5 min)
  → Lambda (Node.js + Puppeteer/Selenium)
    → Access application URL
    → Record response time, status code, screenshots
    → Publish metrics to CloudWatch
    → Store artifacts in S3

Alarm if: 
  SuccessPercent < 100%
  Duration > 5000ms
```

### 1.9 CloudWatch RUM (Real User Monitoring)

- JavaScript snippet added to web application
- Captures real user experience: page load time, errors, sessions
- Tracks Web Vitals (LCP, FID, CLS)
- Segments by browser, device, geography

### 1.10 CloudWatch Evidently

- Feature flags and A/B testing
- Control feature rollout percentage
- Measure impact with CloudWatch metrics
- Automatic traffic splitting

### 1.11 CloudWatch Internet Monitor

- Monitors internet performance to your application
- Uses AWS global network data
- Alerts on internet connectivity issues affecting users
- Shows health by geography and ISP

### 1.12 CloudWatch Application Signals

- Automatic instrumentation for application monitoring
- Tracks SLIs (availability, latency, error rate)
- Service-level dashboards
- Integration with X-Ray for tracing

---

## 2. AWS X-Ray

### 2.1 Overview

Distributed tracing service for analyzing and debugging distributed applications.

### 2.2 Core Concepts

```
Trace: End-to-end request flow
┌─────────────────────────────────────────────────────────────┐
│ Trace ID: 1-67891234-abcdef012345678901234567              │
│                                                              │
│ Segment: API Gateway (50ms)                                 │
│ ├── Subsegment: Lambda invocation (45ms)                   │
│ │   ├── Subsegment: DynamoDB GetItem (10ms)                │
│ │   ├── Subsegment: S3 PutObject (15ms)                    │
│ │   └── Subsegment: External HTTP call (8ms)               │
│ │                                                            │
│ Segment: SNS Publish (5ms)                                  │
│ └── Segment: Lambda (notification) (30ms)                   │
│     └── Subsegment: SES SendEmail (20ms)                   │
└─────────────────────────────────────────────────────────────┘
```

| Concept | Description |
|---|---|
| **Trace** | End-to-end journey of a request through services |
| **Segment** | Data about work done by a single service |
| **Subsegment** | Granular timing for AWS SDK calls, HTTP calls, SQL queries |
| **Annotations** | Key-value pairs (indexed, searchable) |
| **Metadata** | Key-value pairs (not indexed, for debugging) |
| **Groups** | Filter traces by expression (e.g., fault = true) |
| **Sampling** | Control percentage of requests traced (reduce cost) |

### 2.3 Sampling Rules

```json
{
  "version": 2,
  "rules": [
    {
      "description": "Sample all errors",
      "host": "*",
      "http_method": "*",
      "url_path": "*",
      "fixed_target": 0,
      "rate": 1.0,
      "service_name": "*",
      "service_type": "*",
      "rule_name": "errors",
      "attributes": { "fault": "true" }
    },
    {
      "description": "Sample 5% of other requests",
      "host": "*",
      "http_method": "*",
      "url_path": "*",
      "fixed_target": 1,
      "rate": 0.05
    }
  ]
}
```

### 2.4 Service Map

```
X-Ray Service Map (Visual):

[Client] → [API Gateway] → [Lambda: OrderService]
                                    │
                    ┌───────────────┤───────────────┐
                    ▼               ▼               ▼
            [DynamoDB:        [S3: order-    [SNS: order-
             Orders]           files]         events]
                                                 │
                                                 ▼
                                          [Lambda: 
                                           NotifyService]
                                                 │
                                                 ▼
                                          [SES: email]

Color coding:
🟢 Green: Healthy (<1% errors, <500ms)
🟡 Yellow: Degraded (1-5% errors, 500ms-2s)
🔴 Red: Error (>5% errors, >2s)
⚪ Gray: No recent data
```

### 2.5 OpenTelemetry Integration

```
Application → AWS Distro for OpenTelemetry (ADOT) → X-Ray
                                                   → CloudWatch
                                                   → Third-party (Datadog, etc.)

ADOT Collector:
├── Receives: OpenTelemetry Protocol (OTLP) traces and metrics
├── Processes: Batch, filter, sample
└── Exports: X-Ray format, CloudWatch EMF, Prometheus remote write
```

> **Exam Tip:** X-Ray = distributed tracing for microservices. Annotations are indexed (searchable), metadata is not. Use sampling to control costs. Service map shows inter-service dependencies and health.

---

## 3. Amazon Managed Grafana and Prometheus

### 3.1 Amazon Managed Prometheus (AMP)

```
Kubernetes / ECS                     Amazon Managed Prometheus
┌─────────────────────┐           ┌──────────────────────────┐
│  Application Pods    │           │                          │
│  ┌────────────────┐ │           │  Prometheus-compatible   │
│  │ /metrics       │ │ Remote    │  storage + query         │
│  │ endpoint       │ │ Write     │                          │
│  └───────┬────────┘ │──────────▶│  • PromQL queries       │
│          │          │           │  • 150-day retention     │
│  ┌───────▼────────┐ │           │  • Multi-AZ HA          │
│  │ ADOT Collector │ │           │  • Auto-scaling         │
│  │ or Prometheus  │ │           │                          │
│  │ remote write   │ │           │  Alert Manager           │
│  └────────────────┘ │           │  (SNS integration)       │
└─────────────────────┘           └──────────────────────────┘
```

### 3.2 Amazon Managed Grafana (AMG)

```
Data Sources                Amazon Managed Grafana         Users
┌─────────────────┐       ┌──────────────────────┐      ┌──────┐
│ CloudWatch      │──────▶│                      │◀─────│ IAM  │
│ X-Ray           │──────▶│  Dashboards          │      │ SSO  │
│ Managed Prom    │──────▶│  Alerts              │      │      │
│ OpenSearch      │──────▶│  Panels              │      └──────┘
│ Timestream      │──────▶│  Plugins             │
│ Athena          │──────▶│                      │
│ Redshift        │──────▶│  Managed, auto-scale │
│ Third-party     │──────▶│  SSO with IAM IdC    │
└─────────────────┘       └──────────────────────┘
```

**Use Cases:**
- Unified dashboards across multiple data sources
- Kubernetes monitoring (Prometheus + Grafana native)
- IoT metrics visualization
- Business metrics dashboards
- Already using Grafana on-premises → migrate to managed

---

## 4. AWS Health Dashboard

### 4.1 Types

| Type | Scope | Description |
|---|---|---|
| **Service Health** | Global | Public status of all AWS services |
| **Personal Health** | Your account | Events affecting YOUR resources |
| **Organizational Health** | AWS Organization | Events across all member accounts |

### 4.2 Personal Health Dashboard Events

| Event Type | Description | Example |
|---|---|---|
| **Scheduled** | Planned maintenance | EC2 hardware maintenance |
| **Account Notification** | Account-specific | Service limit approaching |
| **Operational Issue** | Service degradation | EBS performance issue in us-east-1 |

### 4.3 Event-Driven Automation

```
AWS Health Event → EventBridge → Automated Response

Example: EC2 hardware maintenance notification
┌──────────────┐    ┌──────────────┐    ┌──────────────────────────┐
│ Health Event: │───▶│ EventBridge  │───▶│ Lambda: Auto-migrate     │
│ EC2 scheduled │    │ Rule:        │    │ 1. Stop instance         │
│ maintenance   │    │ source=health│    │ 2. Start on new hardware │
│               │    │ detail-type= │    │ 3. Verify health check   │
│               │    │ "AWS Health" │    │ 4. Notify team via SNS   │
└──────────────┘    └──────────────┘    └──────────────────────────┘
```

### 4.4 Organizational Health

```
Management Account
└── EventBridge: Aggregate health events from all member accounts
    ├── Account A: EBS volume degraded (us-east-1)
    ├── Account B: RDS maintenance scheduled (eu-west-1)
    └── Account C: No issues

Centralized health monitoring for the entire organization
```

> **Exam Tip:** Use EventBridge rules to automate responses to Health events. Organizational Health requires AWS Organizations and is enabled from the management account.

---

## 5. EventBridge for Operational Events

### 5.1 Event Sources for Operations

| Source | Event Type | Operational Use |
|---|---|---|
| EC2 | State change | Instance started/stopped/terminated |
| Auto Scaling | Launch/terminate | Scaling event tracking |
| ECS | Task state change | Container health monitoring |
| CodeDeploy | Deployment state | Deployment tracking |
| Config | Compliance change | Drift/compliance alerts |
| GuardDuty | Finding | Security incident response |
| Health | Service event | Automated maintenance response |
| Systems Manager | Automation status | Runbook tracking |
| CloudFormation | Stack status | Deployment monitoring |
| S3 | Object events | Data pipeline triggers |
| Trusted Advisor | Check status | Optimization alerts |

### 5.2 Event Pattern Examples

```json
// EC2 instance state change to "terminated"
{
  "source": ["aws.ec2"],
  "detail-type": ["EC2 Instance State-change Notification"],
  "detail": {
    "state": ["terminated"]
  }
}

// Config compliance change to NON_COMPLIANT
{
  "source": ["aws.config"],
  "detail-type": ["Config Rules Compliance Change"],
  "detail": {
    "newEvaluationResult": {
      "complianceType": ["NON_COMPLIANT"]
    }
  }
}

// GuardDuty high-severity finding
{
  "source": ["aws.guardduty"],
  "detail-type": ["GuardDuty Finding"],
  "detail": {
    "severity": [{ "numeric": [">=", 7] }]
  }
}
```

### 5.3 Operational Event Bus Architecture

```
┌──────────────────────────────────────────────────────────┐
│  Operational Event Bus (Custom)                           │
│                                                           │
│  Sources:                    Rules:            Targets:   │
│  ┌──────────┐                                             │
│  │CloudWatch│── Alarm state ──▶ Route to ──▶ Lambda      │
│  │  Alarms  │     change         │           (remediate)  │
│  └──────────┘                    │                        │
│  ┌──────────┐                    │                        │
│  │  Config  │── Non-compliant ──▶├──────────▶ SNS        │
│  └──────────┘                    │           (alert team) │
│  ┌──────────┐                    │                        │
│  │GuardDuty │── High severity ──▶├──────────▶ SSM        │
│  └──────────┘                    │           (automation) │
│  ┌──────────┐                    │                        │
│  │ Health   │── Maintenance ────▶└──────────▶ Incident   │
│  └──────────┘                               Manager     │
└──────────────────────────────────────────────────────────┘
```

---

## 6. CloudWatch vs Third-Party Tools

| Feature | CloudWatch | Datadog | New Relic | Prometheus/Grafana |
|---|---|---|---|---|
| **AWS native** | Yes | Integration | Integration | OSS/Managed |
| **Metrics** | Yes | Yes | Yes | Yes (Prometheus) |
| **Logs** | Yes | Yes | Yes | Loki |
| **Traces** | X-Ray | APM | APM | Jaeger/Tempo |
| **Cost** | Pay per use | Per host/month | Per GB | AMP/AMG costs |
| **Multi-cloud** | AWS only | Yes | Yes | Yes |
| **AI/ML** | Anomaly detection | Watchdog | AIOps | Basic |
| **Dashboards** | Good | Excellent | Good | Excellent (Grafana) |
| **Best for** | AWS-native | Multi-cloud, deep APM | Full-stack | K8s-heavy |

---

## 7. Observability Strategy — Three Pillars

### 7.1 The Three Pillars

```
┌──────────────────────────────────────────────────────────────┐
│                    OBSERVABILITY                               │
├────────────────┬─────────────────────┬───────────────────────┤
│    METRICS     │       LOGS          │      TRACES           │
│                │                     │                       │
│ What is        │ What happened       │ Where did it          │
│ happening?     │ in detail?          │ happen?               │
│                │                     │                       │
│ CloudWatch     │ CloudWatch Logs     │ X-Ray                │
│ Metrics        │ Log Insights        │ Service Map          │
│ Custom Metrics │ Subscription        │ ADOT                 │
│ Anomaly Detect │ Filters             │ Annotations          │
│ Contributor    │ Cross-account       │ Sampling             │
│ Insights       │                     │                       │
│                │                     │                       │
│ "CPU is at 95%"│ "NullPointerExcept" │ "DynamoDB call took  │
│                │ at OrderService.java│  500ms in GetItem"   │
│                │ line 42"            │                       │
└────────────────┴─────────────────────┴───────────────────────┘
```

### 7.2 Observability Maturity Model

```
Level 1: Basic Monitoring
├── Default CloudWatch metrics
├── Basic alarms (CPU, disk)
└── CloudTrail for audit

Level 2: Enhanced Monitoring
├── CloudWatch Agent (memory, disk)
├── Custom metrics (business KPIs)
├── Log aggregation and analysis
├── Basic dashboards
└── Alarm-based alerting

Level 3: Distributed Tracing
├── X-Ray tracing across services
├── Service maps
├── Correlation of metrics, logs, traces
├── Composite alarms
└── Anomaly detection

Level 4: Full Observability
├── SLIs/SLOs defined
├── Application Signals
├── Synthetic monitoring (Canaries)
├── RUM (Real User Monitoring)
├── Automated incident response
├── Cross-account/cross-region dashboards
└── ML-based anomaly detection and alerting
```

---

## 8. Cross-Account/Cross-Region Monitoring

### 8.1 CloudWatch Observability Access Manager (OAM)

```
Architecture:
┌────────────────────────────────────────────────────────┐
│  Monitoring Account (Central)                           │
│  ┌──────────────────────────────────────────────────┐  │
│  │  CloudWatch OAM Sink                              │  │
│  │  (receives metrics, logs, traces from sources)    │  │
│  │                                                    │  │
│  │  Unified dashboards across all accounts           │  │
│  │  Single pane of glass                             │  │
│  └──────────────────────────────────────────────────┘  │
└────────────────────────────────────────────────────────┘
         ▲               ▲               ▲
         │               │               │
┌────────┴──┐   ┌───────┴───┐   ┌──────┴──────┐
│ Source     │   │ Source     │   │ Source       │
│ Account A  │   │ Account B  │   │ Account C   │
│ (OAM Link) │   │ (OAM Link) │   │ (OAM Link)  │
│             │   │             │   │              │
│ Shares:     │   │ Shares:     │   │ Shares:      │
│ • Metrics   │   │ • Metrics   │   │ • Metrics    │
│ • Logs      │   │ • Logs      │   │ • Logs       │
│ • Traces    │   │ • Traces    │   │ • Traces     │
└─────────────┘   └─────────────┘   └──────────────┘
```

### 8.2 Cross-Region Dashboard

```yaml
# CloudWatch Dashboard definition
{
  "widgets": [
    {
      "type": "metric",
      "properties": {
        "region": "us-east-1",
        "metrics": [["AWS/EC2", "CPUUtilization", "InstanceId", "i-1234"]],
        "title": "US East - CPU"
      }
    },
    {
      "type": "metric",
      "properties": {
        "region": "eu-west-1",
        "metrics": [["AWS/EC2", "CPUUtilization", "InstanceId", "i-5678"]],
        "title": "EU West - CPU"
      }
    }
  ]
}
```

### 8.3 Centralized Logging Architecture

```
All Accounts (via Organization)
┌─────────────────────────────────────────────────────────────┐
│  Account A (us-east-1)                                       │
│  ├── CloudWatch Logs → Subscription → Kinesis Firehose      │
│                                           │                  │
│  Account B (eu-west-1)                    │                  │
│  ├── CloudWatch Logs → Subscription → Kinesis Firehose      │
│                                           │                  │
│  Account C (ap-southeast-1)               │                  │
│  ├── CloudWatch Logs → Subscription → Kinesis Firehose      │
│                                           ▼                  │
│                              ┌────────────────────┐         │
│                              │  Central Logging    │         │
│                              │  Account            │         │
│                              │  ┌──────────────┐  │         │
│                              │  │ S3 (archive)  │  │         │
│                              │  │ OpenSearch    │  │         │
│                              │  │ (search)      │  │         │
│                              │  │ Athena        │  │         │
│                              │  │ (ad-hoc query)│  │         │
│                              │  └──────────────┘  │         │
│                              └────────────────────┘         │
└─────────────────────────────────────────────────────────────┘
```

---

## 9. Exam Scenarios

### Scenario 1: Application Performance Monitoring

**Question:** A company runs a microservices application on ECS Fargate with API Gateway frontend. Users report intermittent slow responses. How should they identify the bottleneck?

**Answer:** **AWS X-Ray** for distributed tracing + **CloudWatch** for metrics.

1. Enable X-Ray tracing on API Gateway and Lambda/ECS services
2. X-Ray Service Map shows which service has high latency
3. Drill into slow traces to identify the specific subsegment (DynamoDB, external API, etc.)
4. Use CloudWatch Container Insights for ECS resource metrics
5. Set up X-Ray groups to filter traces with latency > 2s

---

### Scenario 2: Centralized Monitoring

**Question:** A company has 50 AWS accounts across 3 regions. They need a single dashboard to monitor all accounts. Engineers should be able to query logs from any account. What architecture?

**Answer:** **CloudWatch OAM** (Observability Access Manager) + centralized logging.

1. Designate one account as the monitoring account
2. Create OAM Sink in monitoring account
3. Create OAM Links in all 50 source accounts
4. Share metrics, logs, and traces to central account
5. Build cross-account dashboards in the monitoring account
6. Use CloudWatch Logs Insights for cross-account queries

---

### Scenario 3: Synthetic Monitoring

**Question:** A company needs to detect if their e-commerce checkout flow breaks before customers report it. The checkout involves login, add to cart, and payment. How?

**Answer:** **CloudWatch Synthetics Canaries** (GUI Workflow)

1. Create a canary script (Node.js with Puppeteer)
2. Script performs: Navigate → Login → Add item → Checkout → Verify
3. Schedule every 5 minutes
4. If any step fails or takes >10 seconds: ALARM
5. CloudWatch alarm triggers SNS → on-call notification
6. Screenshots stored in S3 for debugging

---

### Scenario 4: Log-Based Alerting

**Question:** An application writes structured JSON logs. The team needs an alarm when the payment error rate exceeds 5% of total payment requests in any 5-minute window. How?

**Answer:** **CloudWatch Metric Filters** + **Math Expressions**

1. Create Metric Filter 1: Count payment errors
   - Pattern: `{ $.service = "PaymentService" && $.status = "ERROR" }`
   - Metric: PaymentErrors
2. Create Metric Filter 2: Count all payment requests
   - Pattern: `{ $.service = "PaymentService" }`
   - Metric: PaymentRequests
3. Create CloudWatch Alarm with math expression:
   `METRICS("PaymentErrors") / METRICS("PaymentRequests") * 100 > 5`

---

### Scenario 5: Health Event Automation

**Question:** When AWS schedules EC2 maintenance, the company wants to automatically stop and start affected instances during their maintenance window to avoid disruption during business hours. How?

**Answer:** **AWS Health + EventBridge + Lambda**

```
AWS Health Event (EC2 scheduled maintenance)
  → EventBridge Rule (filter: aws.health, EC2 maintenance)
    → Lambda Function:
      1. Check if instance has tag "AutoMaintenance=true"
      2. If yes: Stop instance, wait, start instance
      3. Verify instance passes status checks
      4. Send SNS notification to team
```

---

> **Key Exam Tips Summary:**
> 1. **Memory/disk metrics** require CloudWatch Agent (not available by default)
> 2. **Composite alarms** = combine multiple alarms with AND/OR logic
> 3. **Anomaly detection** = ML-based dynamic thresholds
> 4. **Logs Insights** = query language for CloudWatch Logs
> 5. **Metric filters** = convert log patterns into metrics
> 6. **X-Ray** = distributed tracing; annotations are indexed, metadata is not
> 7. **X-Ray sampling** = control cost by tracing a percentage of requests
> 8. **Synthetics Canaries** = proactive monitoring before users report issues
> 9. **OAM** = cross-account observability (share metrics/logs/traces)
> 10. **EventBridge** = route operational events to automated responses
> 11. **Health Dashboard** = Personal (your resources), Organizational (all accounts)
> 12. **Managed Grafana + Prometheus** = Kubernetes-native monitoring on AWS
