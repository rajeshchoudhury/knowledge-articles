# Architecture Diagrams for AWS DevOps Professional Exam

> Text-based architecture diagrams for key exam scenarios. Each diagram includes component explanations, data flow descriptions, key considerations, and related exam topics.

---

## Table of Contents

1. [Multi-Account CI/CD Pipeline](#1-multi-account-cicd-pipeline)
2. [Blue/Green Deployment with CodeDeploy and ALB](#2-bluegreen-deployment-with-codedeploy-and-alb)
3. [Multi-Region Active-Active Architecture](#3-multi-region-active-active-architecture)
4. [Centralized Logging Architecture](#4-centralized-logging-architecture)
5. [DR Strategies Visual Comparison](#5-dr-strategies-visual-comparison)
6. [Auto Scaling with SQS-Based Scaling](#6-auto-scaling-with-sqs-based-scaling)
7. [EventBridge Event-Driven Remediation](#7-eventbridge-event-driven-remediation)
8. [CloudFormation StackSets Across Organization](#8-cloudformation-stacksets-across-organization)
9. [Multi-Region DR with Route 53 Failover](#9-multi-region-dr-with-route-53-failover)
10. [ECS Blue/Green with CodeDeploy](#10-ecs-bluegreen-with-codedeploy)
11. [Config Rule Auto-Remediation](#11-config-rule-auto-remediation)
12. [Cross-Account CodePipeline](#12-cross-account-codepipeline)
13. [Canary Deployment with Lambda Aliases](#13-canary-deployment-with-lambda-aliases)
14. [Centralized Monitoring with CloudWatch Cross-Account](#14-centralized-monitoring-with-cloudwatch-cross-account)

---

## 1. Multi-Account CI/CD Pipeline

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                        TOOLING / SHARED SERVICES ACCOUNT                    │
│                                                                             │
│  ┌──────────┐     ┌──────────────┐     ┌────────────────┐                  │
│  │CodeCommit│────▶│ CodePipeline │────▶│   CodeBuild    │                  │
│  │  (Source) │     │              │     │  (Build+Test)  │                  │
│  └──────────┘     │  Stages:     │     └───────┬────────┘                  │
│                   │  1. Source    │             │                           │
│                   │  2. Build     │     ┌───────▼────────┐                  │
│                   │  3. Staging   │     │  ECR / S3      │                  │
│                   │  4. Approval  │     │ (Artifacts)    │                  │
│                   │  5. Prod      │     └───────┬────────┘                  │
│                   └──────┬───────┘             │                           │
│                          │                     │                           │
│    ┌─────────────────────┼─────────────────────┼───────────────────┐       │
│    │ KMS Key (shared)    │ S3 Artifact Bucket  │                   │       │
│    │ Cross-account       │ Cross-account       │                   │       │
│    │ access policy       │ bucket policy       │                   │       │
│    └─────────────────────┼─────────────────────┼───────────────────┘       │
└──────────────────────────┼─────────────────────┼───────────────────────────┘
                           │                     │
              ┌────────────┼─────────────────────┼────────────────┐
              │            │                     │                │
              ▼            ▼                     ▼                ▼
┌─────────────────────┐         ┌─────────────────────────────────────────┐
│  STAGING ACCOUNT    │         │  PRODUCTION ACCOUNT                     │
│                     │         │                                         │
│  IAM Role:          │         │  IAM Role:                              │
│  CrossAccountDeploy │         │  CrossAccountDeploy                     │
│  (trusts Tooling)   │         │  (trusts Tooling)                       │
│                     │         │                                         │
│  ┌───────────────┐  │         │  ┌──────────────┐   ┌───────────────┐  │
│  │ CloudFormation│  │         │  │Manual Approval│──▶│CloudFormation │  │
│  │ Stack Deploy  │  │         │  │  Gate (SNS)  │   │ Stack Deploy  │  │
│  └───────┬───────┘  │         │  └──────────────┘   └───────┬───────┘  │
│          │          │         │                              │          │
│  ┌───────▼───────┐  │         │  ┌──────────────────────────▼───────┐  │
│  │  ECS / EC2    │  │         │  │       ECS / EC2                  │  │
│  │  Application  │  │         │  │       Application                │  │
│  └───────────────┘  │         │  └──────────────────────────────────┘  │
└─────────────────────┘         └─────────────────────────────────────────┘
```

### Component Explanation

| Component | Purpose |
|---|---|
| **Tooling Account** | Central account hosting the pipeline, build, and artifact storage |
| **CodeCommit** | Source repository (could also be GitHub/GitLab via CodeStar Connections) |
| **CodePipeline** | Orchestrates the entire CI/CD flow across accounts |
| **CodeBuild** | Builds artifacts, runs tests, pushes to ECR |
| **KMS Key** | Shared encryption key with cross-account access for artifact encryption |
| **S3 Artifact Bucket** | Stores pipeline artifacts; bucket policy grants access to target accounts |
| **Cross-Account IAM Roles** | Roles in staging/prod accounts that the pipeline assumes via `sts:AssumeRole` |

### Data Flow

1. Developer pushes code to CodeCommit in the tooling account
2. CodePipeline triggers, CodeBuild builds and tests the artifact
3. Artifacts are stored in S3 (encrypted with shared KMS key)
4. Pipeline assumes a cross-account role in the staging account
5. CloudFormation deploys to staging using the artifact
6. After manual approval, pipeline assumes a role in the production account
7. CloudFormation deploys to production

### Key Considerations

- S3 bucket policy must grant `s3:GetObject` to both target account roles
- KMS key policy must allow `kms:Decrypt` from target account roles
- Cross-account roles must trust the tooling account's pipeline role
- Use `aws:SourceAccount` conditions in trust policies for security
- Pipeline execution role needs `sts:AssumeRole` for each target account

### Related Exam Topics

- Domain 1: SDLC Automation — Cross-account pipelines, artifact management
- Domain 5: Security — Cross-account IAM, KMS key policies
- Domain 3: IaC — CloudFormation deployments across accounts

---

## 2. Blue/Green Deployment with CodeDeploy and ALB

```
                         ┌──────────────┐
                         │   Route 53   │
                         │  DNS Record  │
                         └──────┬───────┘
                                │
                         ┌──────▼───────┐
                         │     ALB      │
                         │              │
                         │ Listener:443 │
                         └──┬────────┬──┘
                            │        │
              ┌─────────────┘        └─────────────┐
              │                                    │
     Production Traffic                    Test Traffic
     (Port 443)                            (Port 8443)
              │                                    │
    ┌─────────▼──────────┐          ┌──────────────▼─────────┐
    │  Target Group 1    │          │   Target Group 2       │
    │  (BLUE - Current)  │          │   (GREEN - New)        │
    │                    │          │                        │
    │ ┌────┐ ┌────┐     │          │ ┌────┐ ┌────┐         │
    │ │EC2 │ │EC2 │     │          │ │EC2 │ │EC2 │         │
    │ │ v1 │ │ v1 │     │          │ │ v2 │ │ v2 │         │
    │ └────┘ └────┘     │          │ └────┘ └────┘         │
    └────────────────────┘          └────────────────────────┘

    ┌───────────────────────────────────────────────────────┐
    │                    CodeDeploy                         │
    │                                                       │
    │  Deployment Steps:                                    │
    │  1. Provision GREEN target group with new version     │
    │  2. Run BeforeAllowTraffic hook (pre-traffic tests)   │
    │  3. Shift traffic: BLUE → GREEN                       │
    │  4. Run AfterAllowTraffic hook (post-traffic tests)   │
    │  5. Wait for termination timer                        │
    │  6. Terminate BLUE instances (or keep for rollback)   │
    │                                                       │
    │  Rollback Trigger:                                    │
    │  - CloudWatch Alarm (5xx errors, latency, etc.)       │
    │  - Manual rollback                                    │
    │  → Shifts traffic back to BLUE instantly              │
    └───────────────────────────────────────────────────────┘

    Traffic Shifting Options:
    ┌────────────────────────────────────────────────────────┐
    │ AllAtOnce         │ 100% shift immediately             │
    │ Canary10Percent5  │ 10% for 5 min, then 100%          │
    │ Linear10Percent1  │ +10% every 1 min until 100%       │
    │ Canary10Percent15 │ 10% for 15 min, then 100%         │
    │ Linear10Percent10 │ +10% every 10 min until 100%      │
    └────────────────────────────────────────────────────────┘
```

### Component Explanation

| Component | Purpose |
|---|---|
| **ALB** | Routes traffic between blue and green target groups |
| **Target Group 1 (Blue)** | Current production instances running version 1 |
| **Target Group 2 (Green)** | New instances running version 2 |
| **CodeDeploy** | Orchestrates traffic shifting and manages rollback |
| **Lifecycle Hooks** | BeforeAllowTraffic and AfterAllowTraffic run validation Lambda functions |
| **Test Listener (8443)** | Optional second listener for testing green before shifting production traffic |

### Data Flow

1. CodeDeploy creates green target group with new application version
2. Health checks verify green instances are healthy
3. BeforeAllowTraffic hook runs pre-traffic validation
4. ALB listener rule shifts traffic from blue to green (based on deployment config)
5. AfterAllowTraffic hook runs post-traffic validation
6. If CloudWatch alarm fires during the wait period, traffic shifts back to blue
7. After termination wait timer, blue instances are terminated

### Key Considerations

- Test listener (port 8443) allows QA to validate the green environment before any production traffic shifts
- CloudWatch alarms trigger automatic rollback — configure alarms on 5xx errors, latency, and custom metrics
- The original task set termination wait time determines how long blue runs alongside green
- Weighted target groups on ALB provide the traffic splitting mechanism

### Related Exam Topics

- Domain 1: SDLC Automation — Blue/Green deployments, deployment strategies
- Domain 6: HA/FT/DR — Zero-downtime deployments

---

## 3. Multi-Region Active-Active Architecture

```
                              ┌──────────────────┐
                              │    Route 53      │
                              │ Latency-Based    │
                              │ Routing + Health │
                              │    Checks        │
                              └────┬────────┬────┘
                                   │        │
                    ┌──────────────┘        └──────────────┐
                    │                                      │
                    ▼                                      ▼
    ┌───────────────────────────────┐  ┌───────────────────────────────┐
    │      US-EAST-1 (Primary)      │  │      EU-WEST-1 (Secondary)    │
    │                               │  │                               │
    │  ┌─────────────────────────┐  │  │  ┌─────────────────────────┐  │
    │  │      CloudFront         │  │  │  │      CloudFront         │  │
    │  │   (Edge Caching)        │  │  │  │   (Edge Caching)        │  │
    │  └───────────┬─────────────┘  │  │  └───────────┬─────────────┘  │
    │              │                │  │              │                │
    │  ┌───────────▼─────────────┐  │  │  ┌───────────▼─────────────┐  │
    │  │         ALB             │  │  │  │         ALB             │  │
    │  │  (Cross-Zone LB)        │  │  │  │  (Cross-Zone LB)        │  │
    │  └──┬──────────────────┬───┘  │  │  └──┬──────────────────┬───┘  │
    │     │                  │      │  │     │                  │      │
    │  ┌──▼───┐          ┌──▼───┐  │  │  ┌──▼───┐          ┌──▼───┐  │
    │  │ AZ-A │          │ AZ-B │  │  │  │ AZ-A │          │ AZ-B │  │
    │  │ ASG  │          │ ASG  │  │  │  │ ASG  │          │ ASG  │  │
    │  │ ECS  │          │ ECS  │  │  │  │ ECS  │          │ ECS  │  │
    │  └──────┘          └──────┘  │  │  └──────┘          └──────┘  │
    │                               │  │                               │
    │  ┌─────────────────────────┐  │  │  ┌─────────────────────────┐  │
    │  │  Aurora Global DB       │  │  │  │  Aurora Global DB       │  │
    │  │  (Primary - R/W)        │◀─┼──┼─▶│  (Secondary - Read)     │  │
    │  │  Writer + 2 Readers     │  │  │  │  2 Readers              │  │
    │  └─────────────────────────┘  │  │  └─────────────────────────┘  │
    │         Async Repl. (<1s)     │  │    Write Forwarding Enabled   │
    │                               │  │                               │
    │  ┌─────────────────────────┐  │  │  ┌─────────────────────────┐  │
    │  │  DynamoDB Global Table  │◀─┼──┼─▶│  DynamoDB Global Table  │  │
    │  │  (Active - R/W)         │  │  │  │  (Active - R/W)         │  │
    │  └─────────────────────────┘  │  │  └─────────────────────────┘  │
    │                               │  │                               │
    │  ┌─────────────────────────┐  │  │  ┌─────────────────────────┐  │
    │  │  ElastiCache Redis      │  │  │  │  ElastiCache Redis      │  │
    │  │  (Global Datastore)     │◀─┼──┼─▶│  (Global Datastore)     │  │
    │  └─────────────────────────┘  │  │  └─────────────────────────┘  │
    │                               │  │                               │
    │  ┌─────────────────────────┐  │  │  ┌─────────────────────────┐  │
    │  │  S3 Bucket              │  │  │  │  S3 Bucket              │  │
    │  │  (CRR Enabled)          │─────▶│  │  (CRR Replica)          │  │
    │  └─────────────────────────┘  │  │  └─────────────────────────┘  │
    └───────────────────────────────┘  └───────────────────────────────┘
```

### Component Explanation

| Component | Purpose |
|---|---|
| **Route 53 Latency Routing** | Directs users to the nearest region; health checks detect failures |
| **CloudFront** | Caches content at edge locations; reduces origin load |
| **ALB + ASG/ECS** | Application tier in each region with independent scaling |
| **Aurora Global Database** | Cross-region database replication (<1s lag); write forwarding allows secondary to accept writes |
| **DynamoDB Global Tables** | Multi-active replication; both regions can read and write |
| **ElastiCache Global Datastore** | Cross-region session/cache replication |
| **S3 CRR** | Object replication between regions for static assets |

### Data Flow

1. User DNS query resolved by Route 53 to the lowest-latency region
2. Request hits CloudFront edge, cache hit returns immediately
3. Cache miss forwarded to regional ALB → ECS/EC2 application
4. Application reads/writes to regional database (Aurora or DynamoDB)
5. Data replicates asynchronously to the other region
6. If one region fails, Route 53 health check triggers failover within TTL

### Key Considerations

- DynamoDB Global Tables use **last-writer-wins** conflict resolution — application must handle this
- Aurora write forwarding introduces slight latency for writes from the secondary region
- S3 CRR does NOT replicate existing objects — use Batch Replication
- Stateless application tier is critical — externalize sessions to ElastiCache/DynamoDB
- DNS TTL affects failover time — lower TTL = faster failover but more DNS queries

### Related Exam Topics

- Domain 6: HA/FT/DR — Multi-region HA, DR strategies
- Domain 2: Configuration Management — Consistent deployments across regions

---

## 4. Centralized Logging Architecture

```
┌──────────────────┐  ┌──────────────────┐  ┌──────────────────┐
│  Account A       │  │  Account B       │  │  Account C       │
│  (Workload)      │  │  (Workload)      │  │  (Workload)      │
│                  │  │                  │  │                  │
│ CloudWatch Logs  │  │ CloudWatch Logs  │  │ CloudWatch Logs  │
│ VPC Flow Logs    │  │ VPC Flow Logs    │  │ VPC Flow Logs    │
│ CloudTrail       │  │ CloudTrail       │  │ CloudTrail       │
│ Config           │  │ Config           │  │ Config           │
│ GuardDuty        │  │ GuardDuty        │  │ GuardDuty        │
│                  │  │                  │  │                  │
│ Kinesis Firehose │  │ Kinesis Firehose │  │ Kinesis Firehose │
│ Subscription     │  │ Subscription     │  │ Subscription     │
│ Filters          │  │ Filters          │  │ Filters          │
└────────┬─────────┘  └────────┬─────────┘  └────────┬─────────┘
         │                     │                     │
         └──────────┬──────────┘──────────┬──────────┘
                    │                     │
                    ▼                     ▼
┌───────────────────────────────────────────────────────────────┐
│                    CENTRAL LOGGING ACCOUNT                     │
│                                                               │
│  ┌─────────────────────────────────────────────────────────┐  │
│  │              Kinesis Data Firehose                       │  │
│  │         (Cross-account destination)                      │  │
│  └───────────┬──────────────────┬──────────────────────────┘  │
│              │                  │                              │
│              ▼                  ▼                              │
│  ┌───────────────────┐  ┌──────────────────────────────┐     │
│  │    S3 Bucket       │  │   OpenSearch Service         │     │
│  │  (Long-term        │  │   (Analysis & Dashboards)    │     │
│  │   Storage)         │  │                              │     │
│  │                    │  │  ┌────────────────────────┐  │     │
│  │ Lifecycle Policy:  │  │  │  Kibana / Dashboards   │  │     │
│  │ → IA after 30d     │  │  │  - Log search          │  │     │
│  │ → Glacier 90d      │  │  │  - Visualizations      │  │     │
│  │ → Delete 365d      │  │  │  - Alerting             │  │     │
│  │                    │  │  └────────────────────────┘  │     │
│  │ Object Lock for    │  │                              │     │
│  │ compliance         │  │  Index Lifecycle:            │     │
│  └───────────────────┘  │  → Hot: 7 days               │     │
│                          │  → Warm: 30 days             │     │
│                          │  → Cold: 90 days             │     │
│                          │  → Delete: 180 days          │     │
│                          └──────────────────────────────┘     │
│                                                               │
│  ┌─────────────────────────────────────────────────────────┐  │
│  │  CloudWatch Cross-Account Observability                  │  │
│  │  (Monitoring Dashboards for all accounts)                │  │
│  └─────────────────────────────────────────────────────────┘  │
│                                                               │
│  ┌─────────────────────────────────────────────────────────┐  │
│  │  Athena (Ad-hoc queries against S3 logs)                 │  │
│  │  + Glue Catalog for schema management                    │  │
│  └─────────────────────────────────────────────────────────┘  │
└───────────────────────────────────────────────────────────────┘

 Alternative Path (for CloudTrail):
 ┌────────────────────────────────────────────────────────────┐
 │ Organization Trail → Central S3 Bucket (organization-wide) │
 │ All accounts' API calls logged to one bucket automatically  │
 └────────────────────────────────────────────────────────────┘
```

### Component Explanation

| Component | Purpose |
|---|---|
| **CloudWatch Logs** | Collects application logs, Lambda logs, ECS logs from each account |
| **Subscription Filters** | Streams specific log groups to Kinesis Firehose in real-time |
| **Kinesis Data Firehose** | Buffers and delivers logs to S3 and OpenSearch |
| **S3** | Long-term, cost-effective log storage with lifecycle policies |
| **OpenSearch** | Near-real-time log analysis, dashboards, and alerting |
| **Athena** | Ad-hoc SQL queries against S3 log archives |
| **Organization Trail** | CloudTrail logs for all accounts to a central S3 bucket |

### Data Flow

1. Applications in workload accounts emit logs to CloudWatch Logs
2. Subscription filters on log groups stream logs to cross-account Kinesis Firehose
3. Firehose buffers logs and delivers to both S3 (archive) and OpenSearch (analysis)
4. OpenSearch ingests logs for real-time dashboards and alerting
5. S3 lifecycle policies manage long-term retention and cost optimization
6. Athena queries S3 for ad-hoc forensic analysis

### Key Considerations

- Cross-account log delivery requires destination policies on the Firehose/S3 bucket
- Organization Trail is the simplest way to centralize CloudTrail — one trail covers all accounts
- S3 Object Lock prevents log tampering for compliance
- Firehose can transform data with Lambda before delivery
- CloudWatch Logs Insights can query logs in-place without export

### Related Exam Topics

- Domain 4: Monitoring and Logging — Centralized logging, cross-account observability
- Domain 5: Security — Audit logging, log integrity, compliance

---

## 5. DR Strategies Visual Comparison

```
 BACKUP & RESTORE                 PILOT LIGHT
 ════════════════                 ═══════════
 Cost: $                          Cost: $$
 RTO: Hours                       RTO: 10s of minutes
 RPO: Hours                       RPO: Minutes

 Primary Region    DR Region      Primary Region    DR Region
 ┌────────────┐   ┌──────────┐   ┌────────────┐   ┌──────────┐
 │ ┌────────┐ │   │          │   │ ┌────────┐ │   │          │
 │ │  App   │ │   │  Nothing │   │ │  App   │ │   │ No App   │
 │ │ Servers│ │   │  Running │   │ │ Servers│ │   │ Servers  │
 │ └────────┘ │   │          │   │ └────────┘ │   │          │
 │ ┌────────┐ │   │ ┌──────┐ │   │ ┌────────┐ │   │ ┌──────┐ │
 │ │   DB   │─┼──▶│ │Backups│ │   │ │   DB   │─┼──▶│ │  DB  │ │
 │ │        │ │   │ │  (S3) │ │   │ │Primary │ │   │ │Replica│ │
 │ └────────┘ │   │ └──────┘ │   │ └────────┘ │   │ └──────┘ │
 │ ┌────────┐ │   │ ┌──────┐ │   │ ┌────────┐ │   │ ┌──────┐ │
 │ │  AMIs  │─┼──▶│ │ AMI  │ │   │ │  AMIs  │─┼──▶│ │ AMI  │ │
 │ │        │ │   │ │Copies │ │   │ │        │ │   │ │Copies │ │
 │ └────────┘ │   │ └──────┘ │   │ └────────┘ │   │ └──────┘ │
 └────────────┘   └──────────┘   └────────────┘   └──────────┘

 On Failover:                     On Failover:
 1. Launch infra from IaC         1. Scale up / launch app servers
 2. Restore DB from backup        2. Promote DB replica
 3. Update DNS                    3. Update DNS


 WARM STANDBY                     MULTI-SITE ACTIVE/ACTIVE
 ══════════════                   ═════════════════════════
 Cost: $$$                        Cost: $$$$
 RTO: Minutes                     RTO: Seconds (near zero)
 RPO: Seconds-Minutes             RPO: Near zero

 Primary Region    DR Region      Region 1          Region 2
 ┌────────────┐   ┌──────────┐   ┌────────────┐   ┌────────────┐
 │ ┌────────┐ │   │ ┌──────┐ │   │ ┌────────┐ │   │ ┌────────┐ │
 │ │  App   │ │   │ │ App  │ │   │ │  App   │ │   │ │  App   │ │
 │ │10 inst.│ │   │ │2 inst│ │   │ │10 inst.│ │   │ │10 inst.│ │
 │ └────────┘ │   │ └──────┘ │   │ └────────┘ │   │ └────────┘ │
 │ ┌────────┐ │   │ ┌──────┐ │   │ ┌────────┐ │   │ ┌────────┐ │
 │ │   DB   │─┼──▶│ │  DB  │ │   │ │   DB   │◀┼──▶│ │   DB   │ │
 │ │Primary │ │   │ │Replica│ │   │ │Active  │ │   │ │ Active │ │
 │ └────────┘ │   │ └──────┘ │   │ └────────┘ │   │ └────────┘ │
 │ ┌────────┐ │   │ ┌──────┐ │   │ ┌────────┐ │   │ ┌────────┐ │
 │ │  ALB   │ │   │ │ ALB  │ │   │ │  ALB   │ │   │ │  ALB   │ │
 │ └────────┘ │   │ └──────┘ │   │ └────────┘ │   │ └────────┘ │
 └────────────┘   └──────────┘   └────────────┘   └────────────┘

 On Failover:                     On Failover:
 1. Scale up DR to full capacity  1. Route 53 health check detects
 2. Promote DB if needed          2. DNS auto-routes to healthy region
 3. Switch DNS                    3. No manual intervention needed


 ═══════════════════════════════════════════════════════════════
 COMPARISON SUMMARY
 ═══════════════════════════════════════════════════════════════
 ┌──────────────┬──────┬────────────┬──────────┬──────────────┐
 │  Strategy    │ Cost │    RTO     │   RPO    │ DR Infra     │
 ├──────────────┼──────┼────────────┼──────────┼──────────────┤
 │ Backup/Restore│  $  │  Hours     │  Hours   │ None         │
 │ Pilot Light  │  $$ │  10s min   │  Minutes │ DB only      │
 │ Warm Standby │ $$$ │  Minutes   │  Sec-Min │ Scaled down  │
 │ Multi-Site   │ $$$$│  Seconds   │  ~Zero   │ Full prod    │
 └──────────────┴──────┴────────────┴──────────┴──────────────┘
```

### Key Considerations

- **Backup & Restore**: Only backups (snapshots, AMIs, S3 objects) exist in DR region. Everything must be rebuilt from scratch.
- **Pilot Light**: The "pilot light" is the database — always running and synchronized. Application servers are OFF (or ASG desired = 0).
- **Warm Standby**: A complete but miniaturized version of production. Can handle some traffic during normal operations.
- **Multi-Site**: Full production in both regions. Uses Route 53 latency or weighted routing. Highest cost and complexity.

### Related Exam Topics

- Domain 6: HA/FT/DR — DR strategy selection based on RTO/RPO/cost requirements

---

## 6. Auto Scaling with SQS-Based Scaling

```
                    ┌──────────────┐
                    │  Producers   │
                    │ (API Gateway │
                    │  / Lambda)   │
                    └──────┬───────┘
                           │
                    SendMessage
                           │
                    ┌──────▼───────┐
                    │  SQS Queue   │
                    │              │
                    │  Messages:   │
                    │  ████████░░  │    ◀── ApproximateNumberOfMessagesVisible
                    │              │
                    │  DLQ Config: │
                    │  maxReceive=3│
                    └──────┬───────┘
                           │
                    ReceiveMessage
                           │
         ┌─────────────────┼─────────────────┐
         │                 │                 │
    ┌────▼────┐      ┌────▼────┐      ┌────▼────┐
    │Consumer │      │Consumer │      │Consumer │
    │  EC2    │      │  EC2    │      │  EC2    │
    │Instance │      │Instance │      │Instance │
    └─────────┘      └─────────┘      └─────────┘
         │                 │                 │
         └─────────────────┼─────────────────┘
                           │
                    ┌──────▼───────┐
                    │     ASG      │
                    │  Min: 2      │
                    │  Max: 20     │
                    │  Desired: 3  │
                    └──────┬───────┘
                           │
               Target Tracking Policy
                           │
                    ┌──────▼───────────────────────┐
                    │  Custom CloudWatch Metric:    │
                    │                               │
                    │  BacklogPerInstance =          │
                    │  ApproxNumberOfMessages        │
                    │  ÷ RunningInstanceCount        │
                    │                               │
                    │  Target Value: 10              │
                    │  (10 messages per instance)    │
                    └───────────────────────────────┘

    Scaling Behavior:
    ┌────────────────────────────────────────────────────┐
    │  Queue has 100 msgs, 3 instances → 33 per instance │
    │  Target is 10 → Need 10 instances → Scale OUT      │
    │                                                    │
    │  Queue has 20 msgs, 10 instances → 2 per instance  │
    │  Target is 10 → Too many instances → Scale IN      │
    └────────────────────────────────────────────────────┘

    Dead Letter Queue:
    ┌──────────────┐
    │  DLQ         │     ┌───────────────────┐
    │  Failed msgs │────▶│ Lambda / Alarm    │
    │  for review  │     │ (process or alert)│
    └──────────────┘     └───────────────────┘
```

### Component Explanation

| Component | Purpose |
|---|---|
| **SQS Queue** | Buffers messages between producers and consumers; decouples components |
| **ASG** | Manages consumer EC2 fleet; scales based on queue depth |
| **Custom Metric** | `BacklogPerInstance` = messages / instances — the scaling signal |
| **Target Tracking Policy** | Maintains target backlog per instance; auto-adjusts fleet size |
| **DLQ** | Captures messages that fail processing after maxReceiveCount attempts |

### Data Flow

1. Producers send messages to SQS
2. Consumer instances poll SQS for messages
3. CloudWatch custom metric calculates backlog per instance
4. ASG target tracking scales in/out to maintain the target
5. Failed messages (after retries) go to the DLQ
6. A Lambda or alarm processes DLQ messages

### Key Considerations

- The custom metric must be published via a Lambda or CloudWatch agent — it's not built-in
- Set the SQS visibility timeout to at least 6x the Lambda/consumer processing time
- Enable long polling (`WaitTimeSeconds: 20`) to reduce empty receives and cost
- DLQ prevents poison pill messages from blocking the queue

### Related Exam Topics

- Domain 6: HA/FT/DR — Queue-based leveling, fault tolerance
- Domain 1: SDLC Automation — Event-driven architectures

---

## 7. EventBridge Event-Driven Remediation

```
    ┌────────────────────────────────────────────────────────────┐
    │                    EVENT SOURCES                            │
    ├────────────────────────────────────────────────────────────┤
    │                                                            │
    │  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐  │
    │  │EC2 State │  │ GuardDuty│  │  Config  │  │ Health   │  │
    │  │ Change   │  │ Finding  │  │Compliance│  │ Events   │  │
    │  └────┬─────┘  └────┬─────┘  └────┬─────┘  └────┬─────┘  │
    │       │             │             │             │          │
    └───────┼─────────────┼─────────────┼─────────────┼──────────┘
            │             │             │             │
            ▼             ▼             ▼             ▼
    ┌────────────────────────────────────────────────────────────┐
    │                    EventBridge                              │
    │                                                            │
    │  Rule 1: EC2 instance stopped unexpectedly                 │
    │  Pattern: {"source": ["aws.ec2"],                          │
    │            "detail-type": ["EC2 Instance State-change"],   │
    │            "detail": {"state": ["stopped"]}}               │
    │                                                            │
    │  Rule 2: Security group opened to 0.0.0.0/0               │
    │  Pattern: {"source": ["aws.config"],                       │
    │            "detail-type": ["Config Rules Compliance Change"]│
    │            "detail": {"newEvaluationResult":               │
    │              {"complianceType": ["NON_COMPLIANT"]}}}       │
    │                                                            │
    │  Rule 3: GuardDuty high-severity finding                   │
    │  Pattern: {"source": ["aws.guardduty"],                    │
    │            "detail": {"severity": [{"numeric": [">=", 7]}]}}│
    └────┬───────────┬──────────────┬───────────────┬────────────┘
         │           │              │               │
         ▼           ▼              ▼               ▼
    ┌─────────┐ ┌──────────┐ ┌───────────┐ ┌──────────────┐
    │ Lambda  │ │  SSM     │ │Step       │ │   SNS        │
    │ Auto-   │ │Automation│ │Functions  │ │ Notification │
    │ Remediate│ │ Runbook  │ │ Workflow  │ │ (Alert Team) │
    └────┬────┘ └────┬─────┘ └─────┬─────┘ └──────┬───────┘
         │           │             │               │
         ▼           ▼             ▼               ▼
    ┌─────────┐ ┌──────────┐ ┌───────────┐ ┌──────────────┐
    │Revoke SG│ │Restart   │ │Isolate    │ │PagerDuty/    │
    │ Rule    │ │Instance  │ │Instance + │ │Slack/Email   │
    │         │ │          │ │Forensics  │ │              │
    └─────────┘ └──────────┘ └───────────┘ └──────────────┘
```

### Component Explanation

| Component | Purpose |
|---|---|
| **Event Sources** | AWS services that emit events (EC2, GuardDuty, Config, Health) |
| **EventBridge** | Routes events to targets based on pattern matching rules |
| **Lambda** | Executes custom remediation logic (e.g., revoke security group rules) |
| **SSM Automation** | Runs predefined or custom runbooks for remediation |
| **Step Functions** | Orchestrates complex multi-step remediation workflows |
| **SNS** | Notifies operations teams via email, SMS, PagerDuty, or Slack |

### Data Flow

1. AWS service emits an event (e.g., Config detects non-compliant resource)
2. EventBridge evaluates the event against all rules
3. Matching rules trigger one or more targets
4. Targets execute remediation (Lambda removes bad SG rule, SSM restarts instance)
5. SNS sends notifications to the operations team
6. Step Functions orchestrates complex remediation with approval steps

### Key Considerations

- EventBridge rules use JSON event patterns for matching — very flexible
- Multiple targets per rule — remediate AND notify simultaneously
- SSM Automation runbooks provide pre-built remediation (e.g., `AWS-DisablePublicAccessForSecurityGroup`)
- Dead-letter queues on EventBridge rules capture failed invocations
- Cross-account event delivery via event bus policies

### Related Exam Topics

- Domain 4: Monitoring and Logging — Event-driven automation
- Domain 5: Security — Automated security remediation
- Domain 6: HA/FT/DR — Self-healing architectures

---

## 8. CloudFormation StackSets Across Organization

```
    ┌─────────────────────────────────────────────────────┐
    │              MANAGEMENT ACCOUNT                      │
    │                                                     │
    │  ┌───────────────────────────────────────────────┐  │
    │  │  CloudFormation StackSet                       │  │
    │  │                                               │  │
    │  │  Template: security-baseline.yaml              │  │
    │  │  Deployment Target: Organization Root OU       │  │
    │  │  Regions: [us-east-1, eu-west-1, ap-south-1]  │  │
    │  │                                               │  │
    │  │  Operation Settings:                           │  │
    │  │  - MaxConcurrentPercentage: 25%               │  │
    │  │  - FailureTolerancePercentage: 10%            │  │
    │  │  - RegionConcurrencyType: PARALLEL            │  │
    │  │                                               │  │
    │  │  Auto Deployment: ENABLED                      │  │
    │  │  (new accounts auto-receive the stack)         │  │
    │  └─────────────────────┬─────────────────────────┘  │
    │                        │                            │
    └────────────────────────┼────────────────────────────┘
                             │
              ┌──────────────┼──────────────┐
              │              │              │
    ┌─────────▼───┐  ┌──────▼──────┐  ┌───▼──────────┐
    │ Production  │  │ Development │  │  Security    │
    │    OU       │  │     OU      │  │    OU        │
    ├─────────────┤  ├─────────────┤  ├──────────────┤
    │ Account A   │  │ Account D   │  │ Account G    │
    │ Account B   │  │ Account E   │  │ (Log Archive)│
    │ Account C   │  │ Account F   │  │              │
    └──┬──────────┘  └──┬──────────┘  └──┬───────────┘
       │                │                │
       ▼                ▼                ▼
    Each account receives a Stack Instance:
    ┌──────────────────────────────────────────────────┐
    │  Stack Instance (per account, per region)        │
    │                                                  │
    │  Resources Created:                              │
    │  ├── IAM Roles (SecurityAudit, ReadOnly)         │
    │  ├── CloudTrail Trail                            │
    │  ├── Config Recorder + Rules                     │
    │  ├── GuardDuty Detector                          │
    │  ├── S3 Bucket Policies (deny public)            │
    │  ├── VPC Flow Logs                               │
    │  └── CloudWatch Alarms (root login, etc.)        │
    │                                                  │
    │  Stack Status: CREATE_COMPLETE                    │
    └──────────────────────────────────────────────────┘

    Auto-deployment when new account joins OU:
    ┌──────────┐     ┌──────────────┐     ┌──────────────┐
    │New Account│──▶│ Joins OU     │──▶│StackSet auto │
    │ Created   │    │              │    │deploys stack │
    └──────────┘     └──────────────┘    └──────────────┘
```

### Component Explanation

| Component | Purpose |
|---|---|
| **Management Account** | Hosts the StackSet definition and controls deployment |
| **StackSet** | Defines the template and deployment targets (OUs, regions) |
| **Stack Instances** | Individual stacks deployed in each account/region combination |
| **Auto Deployment** | Automatically deploys/removes stacks when accounts join/leave OUs |
| **Operation Settings** | Controls concurrency and failure tolerance during updates |

### Data Flow

1. Admin creates/updates StackSet in the management account
2. CloudFormation creates stack instances across target accounts and regions
3. StackSet respects MaxConcurrent and FailureTolerance settings
4. Each stack instance creates resources defined in the template
5. When a new account is added to an OU, auto-deployment triggers stack creation
6. Updates to the StackSet propagate to all stack instances

### Key Considerations

- **Service-managed permissions**: Uses Organizations; no need to create admin roles manually
- **Self-managed permissions**: Requires `AWSCloudFormationStackSetAdministrationRole` in admin account and `AWSCloudFormationStackSetExecutionRole` in each target account
- **Failure tolerance**: Critical for large deployments — prevents one account's failure from blocking all others
- **Region ordering**: Can deploy sequentially or in parallel across regions
- **Drift detection**: StackSets can detect when stack instances drift from the template

### Related Exam Topics

- Domain 3: IaC — StackSets, Organizations integration, multi-account deployments
- Domain 5: Security — Security baseline deployment across accounts

---

## 9. Multi-Region DR with Route 53 Failover

```
                         ┌──────────────────────┐
                         │      Route 53         │
                         │                      │
                         │  app.example.com      │
                         │  Failover Policy      │
                         │                      │
                         │  PRIMARY ──┐         │
                         │  SECONDARY─┼──┐      │
                         │            │  │      │
                         │  Health ◀──┘  │      │
                         │  Check       │      │
                         └──────┬───────┬──────┘
                                │       │
                 ┌──────────────┘       └──────────────┐
                 │ (Normal traffic)    (On failover)   │
                 ▼                                     ▼
┌────────────────────────────────┐ ┌────────────────────────────────┐
│     US-EAST-1 (PRIMARY)        │ │     EU-WEST-1 (DR)             │
│                                │ │                                │
│  ┌──────────────────────────┐  │ │  ┌──────────────────────────┐  │
│  │          ALB             │  │ │  │          ALB             │  │
│  └────────────┬─────────────┘  │ │  └────────────┬─────────────┘  │
│               │                │ │               │                │
│  ┌────────────▼─────────────┐  │ │  ┌────────────▼─────────────┐  │
│  │     ECS / EC2 (ASG)      │  │ │  │    ECS / EC2 (ASG)       │  │
│  │     Full Capacity        │  │ │  │    Min Capacity           │  │
│  │     Desired: 6           │  │ │  │    Desired: 2 (or 0)     │  │
│  └──────────────────────────┘  │ │  └──────────────────────────┘  │
│                                │ │                                │
│  ┌──────────────────────────┐  │ │  ┌──────────────────────────┐  │
│  │    Aurora (Writer)        │  │ │  │    Aurora (Reader)        │  │
│  │    Primary Cluster        │──┼─┼─▶│    Secondary Cluster     │  │
│  │                          │  │ │  │    (Async Repl <1s)      │  │
│  └──────────────────────────┘  │ │  └──────────────────────────┘  │
│                                │ │                                │
│  ┌──────────────────────────┐  │ │  ┌──────────────────────────┐  │
│  │    S3 (Primary)           │  │ │  │    S3 (Replica)           │  │
│  │    CRR Enabled ──────────┼──┼─┼─▶│                          │  │
│  └──────────────────────────┘  │ │  └──────────────────────────┘  │
└────────────────────────────────┘ └────────────────────────────────┘

FAILOVER SEQUENCE:
═══════════════════════════════════════════════════════════════
Step 1: Route 53 health check detects primary ALB failure
        (3 consecutive failures over 30 seconds)

Step 2: Route 53 updates DNS to point to DR region ALB
        (TTL determines propagation time)

Step 3: EventBridge triggers automation:
        ┌──────────────────────────────────────────────┐
        │  EventBridge Rule → Step Functions Workflow:  │
        │                                              │
        │  a) Scale up ASG in DR region (2 → 6)        │
        │  b) Promote Aurora secondary to primary      │
        │  c) Update application configuration         │
        │  d) Send SNS notification to ops team        │
        │  e) Create incident ticket                   │
        └──────────────────────────────────────────────┘

Step 4: DR region serving full production traffic
```

### Component Explanation

| Component | Purpose |
|---|---|
| **Route 53 Failover** | DNS-level failover from primary to secondary when health check fails |
| **Health Check** | Monitors the primary ALB endpoint every 10 seconds |
| **Aurora Global DB** | Cross-region database replication; secondary is promoted during failover |
| **Step Functions** | Orchestrates the failover automation (scale up, promote DB, notify) |
| **S3 CRR** | Keeps static assets synchronized between regions |

### Data Flow

Normal: All traffic → Primary Region via Route 53
Failover: Route 53 health check fails → DNS points to DR → Automation scales up DR

### Key Considerations

- DNS TTL affects failover speed — use 60 seconds or less for Route 53 failover records
- Aurora Global Database promotion makes the secondary a standalone cluster (breaks Global DB)
- Pre-configure AMIs, launch templates, and security groups in the DR region
- Test failover regularly using DRS drills or GameDay exercises
- Consider Global Accelerator instead of Route 53 for faster failover (no DNS caching)

### Related Exam Topics

- Domain 6: HA/FT/DR — DR strategies (Pilot Light/Warm Standby)
- Domain 1: SDLC Automation — Automated failover procedures

---

## 10. ECS Blue/Green with CodeDeploy

```
                    ┌───────────────────────┐
                    │    CodePipeline        │
                    │                       │
                    │ Source → Build → Deploy│
                    └───────────┬───────────┘
                                │
                    ┌───────────▼───────────┐
                    │    CodeDeploy          │
                    │    (ECS Blue/Green)    │
                    │                       │
                    │ AppSpec:              │
                    │  TaskDefinition: new  │
                    │  ContainerName: app   │
                    │  ContainerPort: 8080  │
                    └───────────┬───────────┘
                                │
                    ┌───────────▼───────────┐
                    │         ALB           │
                    │                       │
                    │  Prod Listener: 443   │
                    │  Test Listener: 8443  │
                    └───┬───────────────┬───┘
                        │               │
         Prod Traffic   │               │  Test Traffic
         (Port 443)     │               │  (Port 8443)
                        │               │
              ┌─────────▼────┐  ┌───────▼──────────┐
              │ Target Group │  │  Target Group     │
              │   BLUE       │  │    GREEN          │
              │  (Current)   │  │   (New Version)   │
              │              │  │                   │
              │ ┌──────────┐ │  │ ┌──────────────┐ │
              │ │ECS Task  │ │  │ │ ECS Task     │ │
              │ │  v1.0    │ │  │ │   v2.0       │ │
              │ │(Fargate) │ │  │ │ (Fargate)    │ │
              │ └──────────┘ │  │ └──────────────┘ │
              │ ┌──────────┐ │  │ ┌──────────────┐ │
              │ │ECS Task  │ │  │ │ ECS Task     │ │
              │ │  v1.0    │ │  │ │   v2.0       │ │
              │ └──────────┘ │  │ └──────────────┘ │
              └──────────────┘  └──────────────────┘

    DEPLOYMENT LIFECYCLE:
    ════════════════════════════════════════════════════

    Phase 1: Install
    ├── New task definition registered
    ├── Green task set created with new tasks
    └── Tasks pass health checks

    Phase 2: BeforeAllowTraffic (Hook)
    ├── Lambda function runs validation tests
    ├── Smoke tests against test listener (8443)
    └── If tests fail → deployment stops

    Phase 3: AllowTraffic
    ├── ALB shifts production listener from Blue → Green
    ├── Traffic shifting per deployment config:
    │   ├── CodeDeployDefault.ECSCanary10Percent5Minutes
    │   ├── CodeDeployDefault.ECSLinear10PercentEvery1Minutes
    │   └── CodeDeployDefault.ECSAllAtOnce
    └── CloudWatch alarms monitored for rollback triggers

    Phase 4: AfterAllowTraffic (Hook)
    ├── Lambda function runs post-deployment validation
    └── If tests fail → automatic rollback

    Phase 5: Original Task Set Termination
    ├── Wait period (configurable: 0-2880 minutes)
    ├── Blue tasks terminated after wait period
    └── During wait: rollback is instant (shift back to Blue)
```

### Component Explanation

| Component | Purpose |
|---|---|
| **CodeDeploy** | Manages ECS Blue/Green deployment lifecycle |
| **AppSpec file** | Defines task definition, container, port, and lifecycle hooks |
| **Blue Task Set** | Current production tasks running the old version |
| **Green Task Set** | New tasks running the updated version |
| **Test Listener** | Separate ALB listener for pre-production validation of green tasks |
| **Lifecycle Hooks** | Lambda functions that run validation at key deployment stages |
| **CloudWatch Alarms** | Trigger automatic rollback if error rates or latency spike |

### Data Flow

1. CodePipeline triggers CodeDeploy with new task definition
2. CodeDeploy creates green task set with new container image
3. Green tasks register with the green target group
4. Test listener routes to green for pre-production validation
5. BeforeAllowTraffic hook runs smoke tests
6. Production listener shifts traffic from blue to green
7. CloudWatch alarms monitor; rollback if alarms fire
8. After wait period, blue task set is terminated

### Key Considerations

- AppSpec file is YAML for ECS deployments (unlike JSON for EC2/Lambda)
- The test listener is optional but strongly recommended
- Termination wait time gives you a rollback window — set it to match your monitoring period
- CodeDeploy uses the ECS service's deployment controller type `CODE_DEPLOY` (not `ECS`)
- CloudWatch alarms must be in ALARM state to trigger rollback — ensure alarm thresholds are correct

### Related Exam Topics

- Domain 1: SDLC Automation — ECS deployment strategies, Blue/Green
- Domain 6: HA/FT/DR — Zero-downtime deployments, rollback

---

## 11. Config Rule Auto-Remediation

```
    ┌─────────────────────────────────────────────────────┐
    │                AWS Config                            │
    │                                                     │
    │  ┌───────────────────────────────────────────────┐  │
    │  │  Config Recorder                               │  │
    │  │  (Records all resource configurations)         │  │
    │  └───────────────────┬───────────────────────────┘  │
    │                      │                              │
    │  ┌───────────────────▼───────────────────────────┐  │
    │  │  Config Rules                                  │  │
    │  │                                               │  │
    │  │  ┌─────────────────────────────────────────┐  │  │
    │  │  │ Managed Rule:                           │  │  │
    │  │  │ s3-bucket-public-read-prohibited        │  │  │
    │  │  │ Trigger: Configuration changes          │  │  │
    │  │  └──────────────────┬──────────────────────┘  │  │
    │  │                     │                         │  │
    │  │  ┌──────────────────▼──────────────────────┐  │  │
    │  │  │ Custom Rule (Lambda-backed):            │  │  │
    │  │  │ custom-encryption-check                 │  │  │
    │  │  │ Trigger: Configuration changes          │  │  │
    │  │  └──────────────────┬──────────────────────┘  │  │
    │  │                     │                         │  │
    │  └─────────────────────┼─────────────────────────┘  │
    │                        │                            │
    │     Evaluation Result  │                            │
    │                        ▼                            │
    │  ┌─────────────────────────────────────────────┐    │
    │  │                                             │    │
    │  │   COMPLIANT        NON_COMPLIANT            │    │
    │  │   ✓ No action      ✗ Trigger remediation    │    │
    │  │                                             │    │
    │  └─────────────────────┬───────────────────────┘    │
    │                        │                            │
    └────────────────────────┼────────────────────────────┘
                             │
                  NON_COMPLIANT
                             │
              ┌──────────────▼──────────────┐
              │   Auto-Remediation Action    │
              │                             │
              │  ┌───────────────────────┐  │
              │  │ SSM Automation        │  │
              │  │ Document:             │  │
              │  │                       │  │
              │  │ AWS-DisableS3Bucket   │  │
              │  │ PublicReadWrite       │  │
              │  │                       │  │
              │  │ Parameters:           │  │
              │  │ - BucketName: auto    │  │
              │  │ - AutomationAssumeRole│  │
              │  └───────────┬───────────┘  │
              │              │              │
              │  Max Auto    │              │
              │  Remediation │              │
              │  Attempts: 3 │              │
              └──────────────┼──────────────┘
                             │
                             ▼
              ┌──────────────────────────────┐
              │  SSM Automation Execution     │
              │                              │
              │  Step 1: Get bucket details   │
              │  Step 2: Remove public ACL    │
              │  Step 3: Add block public     │
              │          access config        │
              │  Step 4: Verify compliance    │
              └──────────────┬───────────────┘
                             │
                             ▼
              ┌──────────────────────────────┐
              │  Config re-evaluates         │
              │                              │
              │  Result: COMPLIANT ✓         │
              │                              │
              │  SNS Notification sent       │
              │  to security team            │
              └──────────────────────────────┘
```

### Component Explanation

| Component | Purpose |
|---|---|
| **Config Recorder** | Continuously records resource configuration changes |
| **Config Rules** | Evaluate resources against compliance policies (managed or custom) |
| **Auto-Remediation** | Automatically fixes non-compliant resources using SSM Automation |
| **SSM Automation Document** | Defines the remediation steps (AWS provides pre-built documents) |
| **Remediation Attempts** | Max retries before raising an alarm for manual intervention |

### Data Flow

1. A resource configuration changes (e.g., S3 bucket ACL modified)
2. Config Recorder captures the change
3. Config Rule evaluates the new configuration
4. If NON_COMPLIANT, auto-remediation triggers SSM Automation
5. SSM Automation executes the remediation document
6. Config re-evaluates and confirms compliance
7. SNS notifies the security team of the event

### Key Considerations

- Remediation actions require an IAM role with permissions to modify resources
- Set remediation retry limits to avoid infinite loops
- Use custom SSM Automation documents for organization-specific policies
- Config Rules can be deployed across accounts via Organization conformance packs
- Manual remediation is also available (sends notification instead of auto-fixing)

### Related Exam Topics

- Domain 5: Security — Compliance automation, security controls
- Domain 4: Monitoring and Logging — Config rules and compliance monitoring

---

## 12. Cross-Account CodePipeline

```
┌─────────────────────────────────────────────────────────────┐
│              SOURCE ACCOUNT (Dev Team)                        │
│                                                             │
│  ┌────────────────┐                                         │
│  │  CodeCommit    │                                         │
│  │  Repository    │──── EventBridge Rule ────┐              │
│  └────────────────┘                          │              │
│                                              │              │
│  (Or GitHub via CodeStar Connection)         │              │
└──────────────────────────────────────────────┼──────────────┘
                                               │
                    Event: codecommit push      │
                                               ▼
┌─────────────────────────────────────────────────────────────┐
│              TOOLING ACCOUNT (CI/CD)                          │
│                                                             │
│  ┌──────────────────────────────────────────────────────┐   │
│  │                  CodePipeline                         │   │
│  │                                                      │   │
│  │  Stage 1: Source                                     │   │
│  │  ├── CodeCommit (cross-account role)                 │   │
│  │  └── Output → S3 Artifact Bucket (KMS encrypted)    │   │
│  │                                                      │   │
│  │  Stage 2: Build                                      │   │
│  │  ├── CodeBuild Project                               │   │
│  │  ├── Unit Tests + Build Artifact                     │   │
│  │  └── Push Docker Image to ECR                        │   │
│  │                                                      │   │
│  │  Stage 3: Deploy to Staging                          │   │
│  │  ├── AssumeRole → Staging Account                    │   │
│  │  └── CloudFormation / CodeDeploy                     │   │
│  │                                                      │   │
│  │  Stage 4: Integration Tests                          │   │
│  │  ├── CodeBuild runs tests against Staging            │   │
│  │  └── Report results                                  │   │
│  │                                                      │   │
│  │  Stage 5: Manual Approval                            │   │
│  │  └── SNS → Release Manager                           │   │
│  │                                                      │   │
│  │  Stage 6: Deploy to Production                       │   │
│  │  ├── AssumeRole → Production Account                 │   │
│  │  └── CloudFormation / CodeDeploy                     │   │
│  └──────────────────────────────────────────────────────┘   │
│                                                             │
│  ┌─────────────────────────┐  ┌──────────────────────────┐  │
│  │  S3 Artifact Bucket     │  │  KMS Key                 │  │
│  │  Bucket Policy allows:  │  │  Key Policy allows:      │  │
│  │  - Staging Account      │  │  - Staging Account       │  │
│  │  - Production Account   │  │  - Production Account    │  │
│  └─────────────────────────┘  └──────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
              │                              │
              │ AssumeRole                   │ AssumeRole
              ▼                              ▼
┌──────────────────────────┐  ┌──────────────────────────────┐
│   STAGING ACCOUNT        │  │   PRODUCTION ACCOUNT         │
│                          │  │                              │
│ IAM Role:                │  │ IAM Role:                    │
│ ┌──────────────────────┐ │  │ ┌────────────────────────┐   │
│ │CrossAccountDeployRole│ │  │ │CrossAccountDeployRole  │   │
│ │Trust: Tooling Account│ │  │ │Trust: Tooling Account  │   │
│ │Permissions:          │ │  │ │Permissions:            │   │
│ │- CloudFormation:*    │ │  │ │- CloudFormation:*      │   │
│ │- ECS:*               │ │  │ │- ECS:*                 │   │
│ │- S3:GetObject (artif)│ │  │ │- S3:GetObject (artif)  │   │
│ │- KMS:Decrypt         │ │  │ │- KMS:Decrypt           │   │
│ └──────────────────────┘ │  │ └────────────────────────┘   │
│                          │  │                              │
│ CloudFormation Stack     │  │ CloudFormation Stack         │
│ or CodeDeploy Deployment │  │ or CodeDeploy Deployment     │
└──────────────────────────┘  └──────────────────────────────┘
```

### Key Considerations

- The pipeline role needs `sts:AssumeRole` for all target account roles
- S3 bucket policy and KMS key policy must grant access to target accounts
- EventBridge can trigger cross-account pipelines — event buses must be configured
- Each target account's IAM role should follow least privilege
- Use `aws:SourceAccount` and `aws:SourceArn` conditions in trust policies

### Related Exam Topics

- Domain 1: SDLC Automation — Cross-account CI/CD
- Domain 5: Security — Cross-account IAM, resource policies

---

## 13. Canary Deployment with Lambda Aliases

```
    ┌────────────────────────────────────────────────────┐
    │                  API Gateway                        │
    │                                                    │
    │  Stage: prod                                       │
    │  Endpoint: https://api.example.com/orders          │
    └────────────────────┬───────────────────────────────┘
                         │
                         │ Invokes Lambda alias
                         ▼
    ┌────────────────────────────────────────────────────┐
    │              Lambda Function: orders                │
    │                                                    │
    │  Alias: "live"                                     │
    │  ┌──────────────────────────────────────────────┐  │
    │  │                                              │  │
    │  │  Version 5 (current) ◀───── 90% traffic      │  │
    │  │  Version 6 (canary)  ◀───── 10% traffic      │  │
    │  │                                              │  │
    │  └──────────────────────────────────────────────┘  │
    │                                                    │
    │  Versions:                                         │
    │  ┌────────┐ ┌────────┐ ┌────────┐ ┌────────┐     │
    │  │  v3    │ │  v4    │ │  v5    │ │  v6    │     │
    │  │(old)   │ │(old)   │ │(curr)  │ │(new)   │     │
    │  └────────┘ └────────┘ └────────┘ └────────┘     │
    └────────────────────────────────────────────────────┘

    ┌────────────────────────────────────────────────────┐
    │           CodeDeploy (Lambda)                       │
    │                                                    │
    │  Deployment Config:                                │
    │  ┌──────────────────────────────────────────────┐  │
    │  │ Canary10Percent5Minutes                      │  │
    │  │                                              │  │
    │  │ Timeline:                                    │  │
    │  │                                              │  │
    │  │ t=0m   ████░░░░░░  10% → v6, 90% → v5      │  │
    │  │        CloudWatch Alarm monitoring...        │  │
    │  │                                              │  │
    │  │ t=5m   ██████████  100% → v6 (if healthy)   │  │
    │  │        OR                                    │  │
    │  │ t=Xm   ░░░░░░░░░░  ROLLBACK → 100% v5      │  │
    │  │        (if alarm triggers)                   │  │
    │  └──────────────────────────────────────────────┘  │
    │                                                    │
    │  Pre/Post Traffic Hooks:                           │
    │  ┌──────────────────────────────────────────────┐  │
    │  │ BeforeAllowTraffic:                          │  │
    │  │   Lambda: run-smoke-tests                    │  │
    │  │   - Invoke v6 directly                       │  │
    │  │   - Validate response schema                 │  │
    │  │   - Check latency < threshold                │  │
    │  │                                              │  │
    │  │ AfterAllowTraffic:                           │  │
    │  │   Lambda: run-integration-tests              │  │
    │  │   - End-to-end API tests                     │  │
    │  │   - Database consistency checks              │  │
    │  └──────────────────────────────────────────────┘  │
    │                                                    │
    │  Rollback Alarms:                                  │
    │  ┌──────────────────────────────────────────────┐  │
    │  │ - Lambda Errors > 1% of invocations          │  │
    │  │ - Lambda Duration p99 > 3000ms               │  │
    │  │ - Custom: OrderFailureRate > 0.5%            │  │
    │  └──────────────────────────────────────────────┘  │
    └────────────────────────────────────────────────────┘
```

### Component Explanation

| Component | Purpose |
|---|---|
| **Lambda Alias** | Named pointer that can split traffic between two versions |
| **Lambda Versions** | Immutable snapshots of function code and configuration |
| **CodeDeploy** | Manages traffic shifting and monitors alarms for rollback |
| **Deployment Config** | Defines the canary/linear traffic shifting pattern |
| **Lifecycle Hooks** | Pre/post traffic Lambda functions for validation |
| **CloudWatch Alarms** | Trigger automatic rollback on error rate or latency spikes |

### Data Flow

1. New Lambda version is published (v6)
2. CodeDeploy starts canary deployment: 10% traffic to v6
3. BeforeAllowTraffic hook validates v6 with smoke tests
4. 10% of production traffic routes to v6 via the alias
5. CloudWatch alarms monitor error rates and latency
6. After 5 minutes (if healthy), 100% shifts to v6
7. If alarms fire, all traffic shifts back to v5 immediately

### Key Considerations

- API Gateway must point to the Lambda **alias**, not a specific version or $LATEST
- The alias provides the traffic-splitting mechanism — CodeDeploy updates the alias weights
- $LATEST is mutable and cannot be used for versioned deployments
- CodeDeploy AppSpec for Lambda is YAML with hooks and alias references
- Pre-traffic hooks can invoke the new version directly using the version ARN

### Related Exam Topics

- Domain 1: SDLC Automation — Lambda deployment strategies, canary deployments
- Domain 6: HA/FT/DR — Safe deployment practices

---

## 14. Centralized Monitoring with CloudWatch Cross-Account

```
    ┌──────────────────────────────────────────────────────────┐
    │                 MONITORING ACCOUNT (Central)              │
    │                                                          │
    │  ┌────────────────────────────────────────────────────┐  │
    │  │          CloudWatch Cross-Account Dashboard         │  │
    │  │                                                    │  │
    │  │  ┌──────────────┐ ┌──────────────┐ ┌───────────┐  │  │
    │  │  │ Account A    │ │ Account B    │ │ Account C │  │  │
    │  │  │ CPU: 45%     │ │ CPU: 72%     │ │ CPU: 31%  │  │  │
    │  │  │ Mem: 60%     │ │ Mem: 85% ⚠  │ │ Mem: 40%  │  │  │
    │  │  │ Errors: 0.1% │ │ Errors: 2.1%▲│ │ Errors: 0%│  │  │
    │  │  │ Latency: 45ms│ │ Latency:350ms│ │ Lat: 30ms │  │  │
    │  │  └──────────────┘ └──────────────┘ └───────────┘  │  │
    │  └────────────────────────────────────────────────────┘  │
    │                                                          │
    │  ┌────────────────────────────────────────────────────┐  │
    │  │       CloudWatch Cross-Account Alarms               │  │
    │  │                                                    │  │
    │  │  Composite Alarm: "Application Health"             │  │
    │  │  ├── Account A: ALB 5xx > 5%                       │  │
    │  │  ├── Account B: ALB 5xx > 5%                       │  │
    │  │  ├── Account C: ALB 5xx > 5%                       │  │
    │  │  └── IF ANY in ALARM → Trigger Actions             │  │
    │  │                                                    │  │
    │  │  Actions:                                          │  │
    │  │  ├── SNS → PagerDuty (on-call)                     │  │
    │  │  ├── SNS → Slack (#ops-alerts)                     │  │
    │  │  └── EventBridge → Lambda (auto-remediation)       │  │
    │  └────────────────────────────────────────────────────┘  │
    │                                                          │
    │  ┌────────────────────────────────────────────────────┐  │
    │  │    CloudWatch Synthetics (Canaries)                  │  │
    │  │                                                    │  │
    │  │  ┌──────────┐  ┌──────────┐  ┌──────────┐        │  │
    │  │  │Canary:   │  │Canary:   │  │Canary:   │        │  │
    │  │  │Homepage  │  │API Login │  │Checkout  │        │  │
    │  │  │Every 5m  │  │Every 5m  │  │Every 10m │        │  │
    │  │  │✓ Pass    │  │✓ Pass    │  │✗ FAIL    │        │  │
    │  │  └──────────┘  └──────────┘  └──────────┘        │  │
    │  └────────────────────────────────────────────────────┘  │
    │                                                          │
    │  ┌────────────────────────────────────────────────────┐  │
    │  │  ServiceLens / X-Ray Traces (Cross-Account)         │  │
    │  │                                                    │  │
    │  │  Request → API GW → Lambda → DynamoDB              │  │
    │  │            12ms     45ms      8ms                   │  │
    │  │  Total: 65ms                                        │  │
    │  └────────────────────────────────────────────────────┘  │
    └──────────────────────────────────────────────────────────┘
               ▲              ▲              ▲
               │              │              │
    Sharing    │   Sharing    │   Sharing    │
    Link       │   Link       │   Link       │
               │              │              │
    ┌──────────┴──┐ ┌────────┴────┐ ┌───────┴─────┐
    │ Account A   │ │ Account B   │ │ Account C   │
    │ (Source)    │ │ (Source)    │ │ (Source)    │
    │             │ │             │ │             │
    │ CloudWatch  │ │ CloudWatch  │ │ CloudWatch  │
    │ Agent on    │ │ Agent on    │ │ Agent on    │
    │ EC2/ECS     │ │ EC2/ECS     │ │ EC2/ECS     │
    │             │ │             │ │             │
    │ X-Ray SDK   │ │ X-Ray SDK   │ │ X-Ray SDK   │
    │ instrumented│ │ instrumented│ │ instrumented│
    │             │ │             │ │             │
    │ Cross-Acct  │ │ Cross-Acct  │ │ Cross-Acct  │
    │ Sharing     │ │ Sharing     │ │ Sharing     │
    │ Role:       │ │ Role:       │ │ Role:       │
    │ CloudWatch- │ │ CloudWatch- │ │ CloudWatch- │
    │ CrossAccount│ │ CrossAccount│ │ CrossAccount│
    │ SharingRole │ │ SharingRole │ │ SharingRole │
    └─────────────┘ └─────────────┘ └─────────────┘

    SETUP:
    ══════
    Monitoring Account:
    └── CloudWatch Settings → "Configure monitoring account"
        └── Creates a sink (OAM Sink)

    Source Accounts (A, B, C):
    └── CloudWatch Settings → "Link to monitoring account"
        └── Creates a link to the sink
        └── Shares: Metrics, Logs, Traces, Application Insights
```

### Component Explanation

| Component | Purpose |
|---|---|
| **Monitoring Account** | Central account that views metrics, logs, and traces from all source accounts |
| **OAM (Observability Access Manager)** | Creates sink (in monitoring account) and links (in source accounts) for sharing |
| **Cross-Account Dashboards** | Single pane of glass showing metrics from all accounts |
| **Composite Alarms** | Combine multiple alarms into a single "health" alarm |
| **Synthetics Canaries** | Automated browser/API tests that run on a schedule |
| **X-Ray Traces** | Distributed tracing across services and accounts |
| **ServiceLens** | Combines metrics, logs, and traces for service health views |

### Data Flow

1. Source accounts run CloudWatch agents and X-Ray SDKs
2. OAM links share metrics, logs, and traces with the monitoring account
3. Monitoring account dashboards display cross-account data
4. Composite alarms evaluate health across all accounts
5. Alarms trigger SNS notifications and EventBridge remediation
6. Synthetics canaries provide external user perspective on availability

### Key Considerations

- OAM requires setup in both monitoring (sink) and source (link) accounts
- CloudWatch cross-account sharing works within the same Region
- Composite alarms reduce alert noise by combining multiple signals
- Synthetics canaries can detect issues before users report them
- X-Ray service maps show inter-service dependencies and latency
- Use Organizations to deploy OAM links via StackSets or SCPs

### Related Exam Topics

- Domain 4: Monitoring and Logging — Cross-account observability, alarms, dashboards
- Domain 5: Security — Centralized security monitoring
- Domain 6: HA/FT/DR — Detecting failures for self-healing

---

*These diagrams represent common exam scenarios. Practice tracing data flows and identifying which components provide HA, FT, and DR capabilities in each architecture.*
