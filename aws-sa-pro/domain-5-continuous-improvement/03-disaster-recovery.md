# Disaster Recovery — AWS SAP-C02 Domain 5

## Table of Contents
1. [DR Concepts](#1-dr-concepts)
2. [DR Strategies](#2-dr-strategies)
3. [DR for Each Strategy by Service](#3-dr-for-each-strategy-by-service)
4. [AWS Elastic Disaster Recovery (DRS)](#4-aws-elastic-disaster-recovery-drs)
5. [AWS Backup Cross-Region Cross-Account](#5-aws-backup-cross-region-cross-account)
6. [Multi-Region Architecture Patterns](#6-multi-region-architecture-patterns)
7. [Chaos Engineering — AWS Fault Injection Simulator](#7-chaos-engineering--aws-fault-injection-simulator)
8. [DR Testing Strategies](#8-dr-testing-strategies)
9. [DR Automation](#9-dr-automation)
10. [Route 53 Application Recovery Controller](#10-route-53-application-recovery-controller)
11. [Exam Scenarios](#11-exam-scenarios)

---

## 1. DR Concepts

### 1.1 Key Definitions

| Term | Definition |
|---|---|
| **RPO (Recovery Point Objective)** | Maximum acceptable data loss measured in time. "How much data can we afford to lose?" |
| **RTO (Recovery Time Objective)** | Maximum acceptable downtime. "How quickly must we recover?" |
| **MTTR (Mean Time to Recovery)** | Average time to restore service after failure |
| **MTBF (Mean Time Between Failures)** | Average time between system failures |
| **BIA (Business Impact Analysis)** | Assessment of financial/operational impact of downtime |

### 1.2 RPO and RTO Visualization

```
                    ← RPO →                ← RTO →
Data Loss Window                Recovery Window
◀──────────────────▶              ◀──────────────────▶

─────────────────┬──────────────┬───────────────────────
                 │              │
            Last Backup     Disaster      Service
            / Replctn       Occurs        Restored
                 │              │
                 │  Data lost   │  Downtime
                 │  during this │  during this
                 │  window      │  window
```

### 1.3 RPO/RTO vs Cost Trade-off

```
Cost ▲
     │                                    ★ Multi-Site
     │                               ★ Active/Active
     │                          ★ Warm Standby
     │                     ★ Pilot Light
     │              ★ Backup & Restore
     │
     └──────────────────────────────────────▶ Recovery Speed
       Hours          Minutes        Seconds   (Lower RTO)
```

---

## 2. DR Strategies

### 2.1 Backup and Restore

**RPO:** Hours | **RTO:** Hours (up to 24 hours)

```
Primary Region (us-east-1)              DR Region (us-west-2)
┌──────────────────────────┐          ┌──────────────────────────┐
│  ┌──────┐ ┌──────────┐  │          │                          │
│  │ EC2  │ │   RDS    │  │          │  S3 (backups/snapshots)  │
│  │      │ │          │  │  Backup  │  ├── EBS snapshots       │
│  └──────┘ └──────────┘  │──────────▶│  ├── RDS snapshots       │
│  ┌──────┐ ┌──────────┐  │  Cross-  │  ├── AMIs                │
│  │ EBS  │ │   S3     │  │  Region  │  └── S3 CRR data         │
│  └──────┘ └──────────┘  │  Copy    │                          │
└──────────────────────────┘          │  On disaster:           │
                                      │  1. Restore from backup │
                                      │  2. Launch EC2 from AMI │
                                      │  3. Restore RDS         │
                                      │  4. Update DNS          │
                                      └──────────────────────────┘

Cost: Lowest (only storage costs for backups)
Recovery: Slow (must rebuild entire infrastructure)
```

**Steps During Recovery:**
1. Restore RDS from cross-region snapshot (30-60 min for large DBs)
2. Launch EC2 instances from cross-region AMIs
3. Restore EBS volumes from snapshots
4. Configure networking (VPC, security groups, load balancers)
5. Update Route 53 to point to DR region
6. Validate application functionality

### 2.2 Pilot Light

**RPO:** Minutes | **RTO:** Tens of minutes

```
Primary Region (us-east-1)              DR Region (us-west-2)
┌──────────────────────────┐          ┌──────────────────────────┐
│  ┌──────┐ ┌──────────┐  │          │  ┌──────────────────┐    │
│  │ EC2  │ │   RDS    │  │  Cross-  │  │ RDS Read Replica │    │
│  │ (10) │ │ (Primary)│  │  Region  │  │ (standby, tiny)  │    │
│  └──────┘ └──────────┘  │  Replctn │  └──────────────────┘    │
│  ┌──────┐ ┌──────────┐  │──────────▶│                          │
│  │ ALB  │ │   S3     │  │          │  AMIs ready (not running)│
│  └──────┘ └──────────┘  │          │  ALB configured (idle)   │
└──────────────────────────┘          │  ASG: min=0, desired=0  │
                                      │                          │
                                      │  On disaster:            │
                                      │  1. Promote RDS replica  │
                                      │  2. Scale ASG to 10      │
                                      │  3. Update DNS           │
                                      └──────────────────────────┘

Cost: Low (running: RDS replica + minimal infra)
Recovery: Moderate (promote replica + scale compute)
```

**Key Components Running:**
- RDS read replica (continuously replicated)
- Core infrastructure (VPC, subnets, security groups, IAM) pre-deployed
- AMIs registered in DR region
- ASG defined but scaled to 0

**Key Components NOT Running:**
- EC2 instances (launched on failover)
- Load balancers (may be pre-created but with no targets)

### 2.3 Warm Standby

**RPO:** Seconds | **RTO:** Minutes

```
Primary Region (us-east-1)              DR Region (us-west-2)
┌──────────────────────────┐          ┌──────────────────────────┐
│  ┌──────┐ ┌──────────┐  │          │  ┌──────┐ ┌──────────┐  │
│  │ EC2  │ │   RDS    │  │  Cross-  │  │ EC2  │ │ RDS      │  │
│  │ (10) │ │ (Primary)│  │  Region  │  │ (2)  │ │ (Replica)│  │
│  └──────┘ └──────────┘  │  Replctn │  └──────┘ └──────────┘  │
│  ┌──────┐ ┌──────────┐  │──────────▶│  ┌──────┐              │
│  │ ALB  │ │   S3     │  │          │  │ ALB  │ (reduced)    │
│  └──────┘ └──────────┘  │          │  └──────┘              │
│                          │          │  ASG: min=2 (scaled-down)│
│  Route 53: PRIMARY       │          │                          │
└──────────────────────────┘          │  On disaster:            │
                                      │  1. Promote RDS replica  │
                                      │  2. Scale ASG: 2 → 10   │
                                      │  3. Update DNS           │
                                      └──────────────────────────┘

Cost: Medium (reduced-size environment running 24/7)
Recovery: Fast (scale up existing, promote replica)
```

### 2.4 Multi-Site Active/Active

**RPO:** Near zero | **RTO:** Near zero

```
Region 1 (us-east-1)                    Region 2 (eu-west-1)
┌──────────────────────────┐          ┌──────────────────────────┐
│  ┌──────┐ ┌──────────┐  │          │  ┌──────┐ ┌──────────┐  │
│  │ EC2  │ │ Aurora   │  │ Global   │  │ EC2  │ │ Aurora   │  │
│  │ (10) │ │ Global DB│  │ Database │  │ (10) │ │ Global DB│  │
│  └──────┘ └──────────┘  │ Replctn  │  └──────┘ └──────────┘  │
│  ┌──────┐ ┌──────────┐  │◀────────▶│  ┌──────┐ ┌──────────┐  │
│  │ ALB  │ │DynamoDB  │  │ Global   │  │ ALB  │ │DynamoDB  │  │
│  └──────┘ │Glbl Table│  │ Tables   │  └──────┘ │Glbl Table│  │
│           └──────────┘  │◀────────▶│           └──────────┘  │
└──────────────────────────┘          └──────────────────────────┘
         ▲                                       ▲
         └────────────┬──────────────────────────┘
                      │
              Route 53 (latency or weighted routing)
              Global Accelerator

Cost: Highest (full environments in both regions)
Recovery: Automatic (Route 53 failover or Global Accelerator)
```

### 2.5 Strategy Comparison Table

| Strategy | RPO | RTO | Cost | Complexity |
|---|---|---|---|---|
| **Backup & Restore** | Hours | Hours (up to 24h) | $ | Low |
| **Pilot Light** | Minutes | 10-30 minutes | $$ | Medium |
| **Warm Standby** | Seconds | Minutes | $$$ | Medium-High |
| **Active/Active** | Near zero | Near zero | $$$$ | High |

---

## 3. DR for Each Strategy by Service

### 3.1 Compute DR

| Strategy | Compute Approach |
|---|---|
| **Backup/Restore** | Cross-region AMI copies; launch on demand |
| **Pilot Light** | AMIs in DR region; ASG with min=0 (scale on failover) |
| **Warm Standby** | Scaled-down ASG running (e.g., 20% of primary capacity) |
| **Active/Active** | Full-scale ASG in both regions with Route 53/Global Accelerator |

### 3.2 Database DR

| Database | Backup/Restore | Pilot Light | Warm Standby | Active/Active |
|---|---|---|---|---|
| **Aurora** | Cross-region backup | Aurora cross-region replica | Aurora Global Database (read) | Aurora Global Database (write forwarding) |
| **RDS** | Cross-region snapshot | Cross-region read replica | Cross-region read replica | N/A (use Aurora Global) |
| **DynamoDB** | On-demand backup + restore | Point-in-time recovery | Global Tables (eventual) | Global Tables (multi-master) |
| **ElastiCache** | Backup → restore in DR | Global Datastore (read) | Global Datastore (read) | Global Datastore (promote) |

**Aurora Global Database:**
```
Primary Region                          Secondary Region
┌────────────────────────┐            ┌────────────────────────┐
│ Aurora Cluster          │            │ Aurora Cluster          │
│ ├── Writer (primary)    │  Dedicated │ ├── Reader (secondary)  │
│ ├── Reader 1            │  replication│ ├── Reader 1           │
│ └── Reader 2            │  <1 second │ └── Reader 2           │
│                         │────────────▶│                        │
│ Write here              │   lag      │ Read-only (normally)   │
└────────────────────────┘            │                        │
                                       │ On failover:           │
                                       │ Promote to read-write  │
                                       │ RTO < 1 minute         │
                                       │ RPO < 1 second         │
                                       └────────────────────────┘
```

### 3.3 Storage DR

| Storage | DR Mechanism | RPO |
|---|---|---|
| **S3** | Cross-Region Replication (CRR) | Minutes (async) |
| **EBS** | Cross-region snapshot copy (automated via DLM) | Hours (snapshot frequency) |
| **EFS** | AWS Backup cross-region | Hours (backup frequency) |
| **FSx** | Cross-region backup | Hours |

### 3.4 Networking DR

| Component | DR Approach |
|---|---|
| **Route 53** | Failover routing policy (active-passive) or latency-based (active-active) |
| **Global Accelerator** | Automatic failover to healthy endpoints |
| **VPC** | Pre-created in DR region (same CIDR design) |
| **Direct Connect** | Separate DX in DR region or DX Gateway |

---

## 4. AWS Elastic Disaster Recovery (DRS)

### 4.1 Architecture

```
Source Environment                    AWS (DR Region)
┌─────────────────┐                ┌──────────────────────────────┐
│ Source Server    │                │  Staging Area (Subnet)        │
│ ┌─────────────┐ │   Continuous   │  ┌─────────────────────────┐ │
│ │ DRS Agent   │ │   Block-Level  │  │ Replication Server     │ │
│ │ (replctn)   │─┼──Replication──▶│  │ (lightweight EC2)      │ │
│ └─────────────┘ │   TCP 1500     │  │ + EBS (low-cost gp3)   │ │
│                 │                │  └─────────────────────────┘ │
│  On-Premises,   │                │                              │
│  AWS, or Other  │                │  On Drill/Failover:          │
│  Cloud          │                │  ┌─────────────────────────┐ │
└─────────────────┘                │  │ Recovery Instance       │ │
                                   │  │ (right-sized EC2)       │ │
                                   │  │ Boot from latest point  │ │
                                   │  │ in time                 │ │
                                   │  └─────────────────────────┘ │
                                   └──────────────────────────────┘
```

### 4.2 Key Features

| Feature | Description |
|---|---|
| **Continuous replication** | Block-level replication (RPO: seconds) |
| **Point-in-time recovery** | Select any point up to the configured retention |
| **Non-disruptive drills** | Test failover without affecting production |
| **Automated failover** | Launch recovery instances from latest replication |
| **Failback** | Reverse replication back to primary after recovery |
| **Multi-server** | Coordinate recovery of multiple servers (launch order) |

### 4.3 Failover Process

```
Normal Operation:
Source → Continuous replication → DRS staging (EBS snapshots)

Failover:
1. Initiate failover (console or API)
2. DRS creates point-in-time snapshot
3. Launches recovery instances from snapshot
4. Recovery instances boot with latest data
5. Validate application functionality
6. Update DNS to point to recovery instances

Failback (after primary is restored):
1. Install DRS agent on recovered instances
2. Reverse replication: AWS → Primary site
3. When synced: cut back to primary
4. Resume normal replication: Primary → AWS
```

### 4.4 DRS vs Backup/Restore

| Feature | DRS | Backup/Restore |
|---|---|---|
| RPO | Seconds | Hours |
| RTO | Minutes | Hours |
| Replication | Continuous, real-time | Periodic snapshots |
| Cost | DRS service + staging storage | Snapshot storage only |
| Drill capability | Non-disruptive, anytime | Must restore to test |
| Failback | Built-in | Manual |

> **Exam Tip:** DRS is for server-level DR (replaces CloudEndure DR). It provides continuous replication with RPO in seconds. Best for pilot light and warm standby strategies.

---

## 5. AWS Backup Cross-Region Cross-Account

### 5.1 Architecture

```
AWS Backup Vault (Primary Region)          AWS Backup Vault (DR Region)
┌────────────────────────────────┐       ┌────────────────────────────────┐
│  Backup Plans:                  │       │  Cross-Region Copy:            │
│  ├── Daily (retain 30 days)    │       │  ├── EBS snapshots             │
│  ├── Weekly (retain 90 days)   │ Copy  │  ├── RDS snapshots             │
│  └── Monthly (retain 1 year)   │──────▶│  ├── EFS backups               │
│                                 │       │  ├── DynamoDB backups          │
│  Supported Resources:           │       │  └── FSx backups               │
│  ├── EC2 (AMI + EBS)           │       │                                │
│  ├── EBS volumes               │       │  Cross-Account Copy:           │
│  ├── RDS / Aurora              │ Copy  │  (to separate DR account)      │
│  ├── DynamoDB                  │──────▶│                                │
│  ├── EFS                       │       │  Vault Lock:                   │
│  ├── FSx                       │       │  Immutable backups (WORM)     │
│  ├── S3                        │       │  Compliance mode / Legal hold  │
│  ├── Neptune / DocumentDB      │       │                                │
│  └── Storage Gateway           │       └────────────────────────────────┘
└────────────────────────────────┘
```

### 5.2 Backup Plans

```json
{
  "BackupPlanName": "Production-DR",
  "Rules": [
    {
      "RuleName": "DailyBackup",
      "ScheduleExpression": "cron(0 2 * * ? *)",
      "TargetBackupVaultName": "primary-vault",
      "Lifecycle": {
        "DeleteAfterDays": 30,
        "MoveToColdStorageAfterDays": 7
      },
      "CopyActions": [
        {
          "DestinationBackupVaultArn": "arn:aws:backup:us-west-2:123456:backup-vault:dr-vault",
          "Lifecycle": {
            "DeleteAfterDays": 30
          }
        }
      ]
    }
  ]
}
```

### 5.3 Vault Lock

- **Governance Mode:** Prevents deletion by most users; root user can remove lock
- **Compliance Mode:** NOBODY can delete backups (WORM — Write Once Read Many)
- Meets regulatory requirements (SEC Rule 17a-4, FINRA, HIPAA)
- Once locked in compliance mode: CANNOT be changed or removed

---

## 6. Multi-Region Architecture Patterns

### 6.1 Active-Passive

```
Primary (us-east-1): Active — handles ALL traffic
DR (us-west-2): Passive — standby, receives replicated data

Route 53 Failover Routing:
  Primary record: A → ALB-us-east-1 (health check active)
  Secondary record: A → ALB-us-west-2 (failover target)

Failover trigger:
  Route 53 health check fails on primary
  → Automatically routes to secondary
```

### 6.2 Active-Active

```
Both regions handle traffic simultaneously:

Route 53 Latency-Based Routing:
  us-east-1 → ALB-us-east-1 (US users)
  eu-west-1 → ALB-eu-west-1 (EU users)

Data Sync:
  DynamoDB Global Tables (multi-master)
  Aurora Global Database (write forwarding)
  S3 Cross-Region Replication

Conflict Resolution:
  DynamoDB: Last writer wins
  Aurora: Write forwarding to primary
  S3: Latest version wins
```

### 6.3 Data Consistency Challenges

```
Active-Active Conflict Scenario:

User A (us-east-1):  UPDATE inventory SET qty = qty - 1 WHERE id = 123
User B (eu-west-1):  UPDATE inventory SET qty = qty - 1 WHERE id = 123

If both happen at same time:
├── DynamoDB Global Tables: Last writer wins (eventual consistency)
│   Result: qty decreased by 1 (one update lost!)
│   Solution: Use conditional writes or atomic counters
│
├── Aurora Global Database: Write forwarding
│   All writes go to primary region
│   No conflict (serialized at primary)
│   Trade-off: Write latency for remote region

Best practice: Use DynamoDB atomic counters for inventory
  SET qty = qty - 1 (atomic, no conflict)
```

---

## 7. Chaos Engineering — AWS Fault Injection Simulator

### 7.1 Overview

AWS FIS lets you run controlled chaos experiments to test system resilience.

### 7.2 Supported Fault Injections

| Target | Actions | Description |
|---|---|---|
| **EC2** | Stop, terminate, reboot instances | Test instance failure handling |
| **EC2** | CPU/memory/disk stress | Test performance under stress |
| **ECS** | Stop tasks, drain containers | Test container resilience |
| **EKS** | Delete pods, node drain | Test Kubernetes resilience |
| **RDS** | Failover, reboot | Test database failover |
| **Network** | Disrupt connectivity (blackhole, latency) | Test network partition |
| **IAM** | Inject error responses | Test permission issues |
| **S3** | Inject error responses | Test storage failure handling |

### 7.3 Experiment Template

```json
{
  "description": "Test AZ failure resilience",
  "targets": {
    "ec2-instances": {
      "resourceType": "aws:ec2:instance",
      "selectionMode": "ALL",
      "resourceTags": { "Environment": "staging" },
      "filters": [
        { "path": "Placement.AvailabilityZone", "values": ["us-east-1a"] }
      ]
    }
  },
  "actions": {
    "stop-instances": {
      "actionId": "aws:ec2:stop-instances",
      "targets": { "Instances": "ec2-instances" },
      "parameters": { "startInstancesAfterDuration": "PT10M" }
    }
  },
  "stopConditions": [
    {
      "source": "aws:cloudwatch:alarm",
      "value": "arn:aws:cloudwatch:...:alarm:HighErrorRate"
    }
  ],
  "roleArn": "arn:aws:iam::...:role/FISExperimentRole"
}
```

### 7.4 Chaos Engineering Best Practices

1. **Start small:** Single instance, then AZ, then region
2. **Staging first:** Test in non-production before production
3. **Stop conditions:** Auto-stop if impact exceeds threshold
4. **Observe:** Monitor dashboards during experiments
5. **Gradual:** Increase blast radius over time
6. **Document:** Record findings, fix issues, retest

---

## 8. DR Testing Strategies

### 8.1 Test Types

| Type | Description | Frequency | Risk |
|---|---|---|---|
| **Walkthrough** | Team reviews DR plan on paper | Monthly | None |
| **Tabletop** | Simulate scenario, discuss response | Quarterly | None |
| **Functional** | Test individual components (restore backup) | Monthly | Low |
| **DR Drill** | Full failover to DR (non-production) | Quarterly | Low |
| **Full Failover** | Actual production failover to DR | Annually | Medium |

### 8.2 DR Drill Process

```
1. Pre-Drill Preparation (Week before)
   ├── Notify stakeholders
   ├── Verify replication is current
   ├── Review runbook
   └── Set up monitoring

2. Execute Drill
   ├── Initiate failover (Route 53 switch)
   ├── Verify DR environment health
   ├── Test application functionality
   ├── Test integrations (external APIs, etc.)
   └── Measure actual RTO

3. Validation
   ├── All endpoints accessible?
   ├── Data consistent? (compare timestamps)
   ├── Performance acceptable?
   └── External integrations working?

4. Failback
   ├── Reverse the failover
   ├── Verify primary region health
   └── Resume normal operations

5. Post-Drill Review
   ├── Actual RTO vs target RTO
   ├── Issues encountered
   ├── Runbook updates needed
   └── Action items for improvement
```

---

## 9. DR Automation

### 9.1 CloudFormation StackSets for DR

```
DR Infrastructure Pre-deployed via StackSets:

Management Account
└── StackSet: "DR-Infrastructure"
    ├── Stack Instance: us-west-2 (DR region)
    │   ├── VPC + Subnets
    │   ├── Security Groups
    │   ├── IAM Roles
    │   ├── ALB (idle)
    │   └── ASG (min=0)
    └── Parameters: DRMode=standby

On Failover: Update StackSet parameters
    └── Parameters: DRMode=active
        ├── ASG min → 10
        ├── ALB → add targets
        └── Route 53 → switch
```

### 9.2 Step Functions DR Orchestration

```
Step Functions: DR Failover Workflow

Start → Validate Replication Status
         │
         ├── Promote Aurora Global Database
         │   (detach secondary, promote to primary)
         │
         ├── Scale Up ASG (parallel)
         │   ├── Web tier: 0 → 10 instances
         │   ├── App tier: 0 → 5 instances
         │   └── Worker tier: 0 → 3 instances
         │
         ├── Wait for Instances to Pass Health Checks
         │
         ├── Update Route 53 Records
         │   (switch to DR region endpoints)
         │
         ├── Run Validation Tests
         │   ├── API health check
         │   ├── Database connectivity
         │   └── Sample transactions
         │
         ├── Choice: All Tests Pass?
         │   ├── Yes → Notify: "Failover Complete"
         │   └── No → Notify: "Failover Issues - Manual Intervention Required"
         │
         └── End
```

### 9.3 EventBridge + Lambda Automation

```
Automated DR Trigger:

CloudWatch Alarm (all primary health checks failed for 5 min)
  → EventBridge Rule
    → Lambda: ValidatePrimaryDown()
      ├── Check from multiple vantage points
      ├── Confirm not a monitoring false positive
      └── If confirmed down:
          → Step Functions: Execute DR Failover Workflow
          → SNS: Alert DR team
          → Incident Manager: Create P1 incident
```

---

## 10. Route 53 Application Recovery Controller

### 10.1 Overview

Route 53 ARC provides readiness checks and routing controls for application failover.

### 10.2 Components

```
Route 53 Application Recovery Controller:

┌──────────────────────────────────────────────────────────┐
│  Readiness Checks                                         │
│  ├── Check: Auto Scaling Group (us-east-1) — READY ✓    │
│  ├── Check: RDS (us-east-1) — READY ✓                   │
│  ├── Check: Auto Scaling Group (us-west-2) — READY ✓    │
│  ├── Check: RDS (us-west-2) — READY ✓                   │
│  └── Overall Readiness: READY ✓                          │
├──────────────────────────────────────────────────────────┤
│  Routing Controls                                         │
│  ├── us-east-1-cell: ON (traffic flowing)                │
│  ├── us-west-2-cell: OFF (standby)                       │
│  │                                                        │
│  │  Failover: Toggle routing controls                    │
│  │  us-east-1-cell: OFF                                  │
│  │  us-west-2-cell: ON                                   │
├──────────────────────────────────────────────────────────┤
│  Safety Rules                                             │
│  ├── AtLeastOneCell: At least one cell must be ON        │
│  ├── MinHealthyPercentage: >50% of cells must be healthy │
│  └── Prevents accidental full outage                     │
└──────────────────────────────────────────────────────────┘
```

### 10.3 Readiness Checks

| Resource Type | What It Checks |
|---|---|
| Auto Scaling Group | Capacity, launch config matches, health checks |
| EC2 | Instance count, health status |
| RDS | Multi-AZ, backup enabled, storage, replicas match |
| DynamoDB | Table exists, GSIs match, capacity mode |
| NLB / ALB | Listeners, target groups, health checks |
| Route 53 | Health checks configured |
| Lambda | Function exists, concurrency configured |

### 10.4 Routing Controls

```
Route 53 Health Checks → Routing Controls → DNS Records

Normal: 
  us-east-1 routing control = ON → Route 53 returns us-east-1 IPs
  us-west-2 routing control = OFF → Route 53 does NOT return us-west-2 IPs

Failover:
  us-east-1 routing control = OFF → Route 53 stops returning us-east-1 IPs
  us-west-2 routing control = ON → Route 53 returns us-west-2 IPs

Safety Rules prevent:
  Both OFF (would cause total outage)
  Switching when DR region is not ready
```

> **Exam Tip:** Route 53 ARC is for controlled, safe regional failover. Readiness checks verify DR is ready. Routing controls manage traffic flow. Safety rules prevent accidental outages.

---

## 11. Exam Scenarios

### Scenario 1: RPO/RTO Requirements

**Question:** A company requires RPO of 1 hour and RTO of 4 hours for their application. They want to minimize cost. Which DR strategy?

**Answer:** **Backup and Restore**

**Reasoning:**
- RPO 1 hour → Hourly backups (automated snapshots with cross-region copy)
- RTO 4 hours → Acceptable for restore from snapshots + launch infrastructure
- Lowest cost option that meets requirements
- Use AWS Backup with hourly schedule and cross-region copy rules

---

### Scenario 2: Near-Zero RPO/RTO

**Question:** A financial trading platform requires RPO < 1 second and RTO < 1 minute. What architecture?

**Answer:** **Multi-Site Active/Active**

**Architecture:**
1. Aurora Global Database (RPO < 1 second, cross-region replication)
2. DynamoDB Global Tables (multi-master for session/cache data)
3. Full compute infrastructure in both regions
4. Route 53 latency-based routing or Global Accelerator
5. Route 53 ARC for controlled failover
6. S3 Cross-Region Replication for static assets

---

### Scenario 3: DR for On-Premises to AWS

**Question:** A company wants to set up DR on AWS for their on-premises VMware environment. They need RPO of 15 minutes and RTO of 30 minutes. What solution?

**Answer:** **AWS Elastic Disaster Recovery (DRS)**

1. Install DRS agent on on-premises servers
2. Continuous block-level replication to AWS (RPO: seconds)
3. Staging area uses low-cost EC2 + EBS
4. On failover: Launch right-sized recovery instances (RTO: minutes)
5. Non-disruptive drills available for testing
6. Failback supported after primary site is restored

---

### Scenario 4: Database DR Strategy

**Question:** A company runs Aurora PostgreSQL in us-east-1. They need the database available in us-west-2 with < 1 second RPO and < 1 minute RTO. Read traffic should be served from both regions. What solution?

**Answer:** **Aurora Global Database**

- Primary cluster in us-east-1 (read/write)
- Secondary cluster in us-west-2 (read-only, < 1 second replication lag)
- On failover: promote secondary to read-write (< 1 minute)
- Read traffic distributed to both regions via Route 53 latency routing
- Storage-level replication (not binlog) — more efficient

---

### Scenario 5: Chaos Engineering

**Question:** A company wants to validate their application can survive an AZ failure in us-east-1. How should they test?

**Answer:** **AWS Fault Injection Simulator (FIS)**

1. Create experiment template targeting EC2 instances in us-east-1a
2. Action: Stop all EC2 instances in AZ 1a
3. Stop condition: CloudWatch alarm if error rate > 5%
4. Run in staging first, then production during low-traffic period
5. Validate: Auto Scaling launches replacements in AZ 1b/1c, ALB health checks route around failed AZ
6. Measure actual RTO

---

### Scenario 6: Immutable Backups for Compliance

**Question:** A healthcare company must retain backups for 7 years with guaranteed immutability (cannot be deleted, even by administrators). What solution?

**Answer:** **AWS Backup Vault Lock** (Compliance Mode)

1. Create backup vault with Vault Lock in Compliance Mode
2. Set retention: 2,555 days (7 years)
3. Once locked: NO ONE can delete backups (not even root)
4. Configure backup plan with cross-region copy for geographic redundancy
5. Meets HIPAA, SEC 17a-4, and other regulatory requirements

---

> **Key Exam Tips Summary:**
> 1. **Backup/Restore** = cheapest, highest RTO/RPO (hours)
> 2. **Pilot Light** = DB replicated, compute ready to launch (minutes)
> 3. **Warm Standby** = scaled-down environment running (minutes)
> 4. **Active/Active** = full environments, near-zero RTO/RPO ($$$)
> 5. **Aurora Global Database** = < 1 second RPO, < 1 minute RTO for DB failover
> 6. **DynamoDB Global Tables** = multi-master, active-active across regions
> 7. **DRS (Elastic Disaster Recovery)** = continuous replication for server DR
> 8. **AWS Backup Vault Lock** = immutable backups for compliance
> 9. **FIS** = chaos engineering to test resilience
> 10. **Route 53 ARC** = safe, controlled failover with readiness checks and safety rules
> 11. **S3 CRR** = cross-region replication for object storage DR
> 12. **Always test DR** = non-disruptive drills quarterly, full failover annually
