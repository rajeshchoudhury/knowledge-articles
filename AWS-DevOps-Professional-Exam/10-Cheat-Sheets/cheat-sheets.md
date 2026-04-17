# AWS DevOps Engineer Professional (DOP-C02) Cheat Sheets

> Quick-reference material for exam day review. Bookmark this file.

---

## Cheat Sheet 1: Deployment Strategies Comparison

| Strategy | How It Works | Rollback | Downtime | Cost | Speed | Risk | Supported Services |
|---|---|---|---|---|---|---|---|
| **In-Place** | Stop app, deploy new version on existing instances | Redeploy previous version (slow) | Yes (brief per instance) | Lowest | Fast | High | CodeDeploy (EC2), Elastic Beanstalk (All at Once) |
| **Rolling** | Deploy to instances in batches, one batch at a time | Redeploy previous version | No (reduced capacity) | Low | Medium | Medium | CodeDeploy (EC2), Elastic Beanstalk, ECS |
| **Rolling + Extra Batch** | Launch extra batch first to maintain full capacity during rolling update | Redeploy previous version | No (full capacity maintained) | Slightly higher | Medium | Medium | Elastic Beanstalk |
| **Blue/Green** | Full parallel environment; switch traffic all at once | Switch traffic back to blue (fast) | No | High (2x resources) | Fast switch | Low | CodeDeploy (EC2, ECS), Elastic Beanstalk (CNAME swap), Route 53, API Gateway |
| **Canary** | Small % of traffic to new version first, then all at once | Shift traffic back (fast) | No | Medium | Medium | Low | CodeDeploy (Lambda, ECS), API Gateway, AppMesh |
| **Linear** | Equal % traffic increments at equal intervals | Shift traffic back (fast) | No | Medium | Slow (gradual) | Lowest | CodeDeploy (Lambda, ECS) |
| **Immutable** | New instances in new ASG; replace old after health checks pass | Terminate new ASG (fast) | No | High (2x briefly) | Slow | Very Low | Elastic Beanstalk |
| **Traffic Splitting** | ALB weighted target groups — canary-style for Beanstalk | Shift traffic back | No | Medium | Medium | Low | Elastic Beanstalk |

### Key Decision Points
- **Need instant rollback?** → Blue/Green or Immutable
- **Minimize cost?** → In-Place or Rolling
- **Production with zero-downtime?** → Blue/Green, Canary, or Immutable
- **Lambda deployments?** → Canary or Linear (via CodeDeploy + Alias)
- **ECS deployments?** → Blue/Green (CodeDeploy), Rolling (ECS native)

---

## Cheat Sheet 2: CloudFormation Quick Reference

### Intrinsic Functions

| Function | Purpose | Syntax Example |
|---|---|---|
| `Ref` | Return resource ID or parameter value | `!Ref MyBucket` |
| `Fn::GetAtt` | Get resource attribute | `!GetAtt MyBucket.Arn` |
| `Fn::Join` | Join strings with delimiter | `!Join [ "-", [ "a", "b" ] ]` |
| `Fn::Sub` | String substitution | `!Sub "arn:aws:s3:::${BucketName}"` |
| `Fn::Select` | Select item from list | `!Select [ 0, !GetAZs "" ]` |
| `Fn::Split` | Split string into list | `!Split [ ",", "a,b,c" ]` |
| `Fn::FindInMap` | Lookup value in Mappings | `!FindInMap [ MapName, Key1, Key2 ]` |
| `Fn::ImportValue` | Import cross-stack output | `!ImportValue SharedVPCId` |
| `Fn::Base64` | Base64 encode | `!Base64 !Sub "#!/bin/bash\nyum update"` |
| `Fn::Cidr` | Generate CIDR blocks | `!Cidr [ !GetAtt VPC.CidrBlock, 6, 8 ]` |
| `Fn::GetAZs` | Get AZs for a region | `!GetAZs ""` (current region) |
| `Fn::Transform` | Call a macro | `"Fn::Transform": { "Name": "AWS::Include", "Parameters": {...} }` |
| `Fn::Length` | Get length of array | `!Length MyList` |
| `Fn::ToJsonString` | Convert object to JSON string | `!ToJsonString { key: value }` |

### Condition Functions

| Function | Purpose |
|---|---|
| `Fn::If` | If condition is true, return value A; else value B |
| `Fn::Equals` | Compare two values |
| `Fn::And` | Logical AND (2-10 conditions) |
| `Fn::Or` | Logical OR (2-10 conditions) |
| `Fn::Not` | Logical NOT |

### Pseudo Parameters

| Parameter | Returns |
|---|---|
| `AWS::AccountId` | Account ID (e.g., 123456789012) |
| `AWS::Region` | Current region (e.g., us-east-1) |
| `AWS::StackId` | Stack ID (full ARN) |
| `AWS::StackName` | Stack name |
| `AWS::URLSuffix` | Domain suffix (amazonaws.com) |
| `AWS::Partition` | Partition (aws, aws-cn, aws-us-gov) |
| `AWS::NotificationARNs` | List of SNS topic ARNs for stack notifications |
| `AWS::NoValue` | Removes a property (used with Fn::If) |

### Resource Attributes

| Attribute | Purpose | Key Details |
|---|---|---|
| `DependsOn` | Explicit dependency | Resource created after dependency; use when implicit dependencies aren't enough |
| `DeletionPolicy` | What happens on stack delete | `Delete` (default), `Retain`, `Snapshot` |
| `UpdateReplacePolicy` | What happens on resource replacement | `Delete` (default), `Retain`, `Snapshot` |
| `CreationPolicy` | Wait for signals on create | Used with ASG/EC2 + cfn-signal; set Count and Timeout |
| `UpdatePolicy` | How to handle updates | ASG rolling/replacing update, Lambda alias traffic shift |
| `Metadata` | Arbitrary metadata | Used by cfn-init (`AWS::CloudFormation::Init`) |
| `Condition` | Conditional resource creation | Reference a Condition defined in the Conditions section |

### Helper Scripts

| Script | Purpose | When to Use |
|---|---|---|
| `cfn-init` | Read metadata and configure instance | Install packages, create files, start services |
| `cfn-signal` | Signal success/failure to CloudFormation | Used with CreationPolicy or WaitCondition |
| `cfn-hup` | Detect metadata changes | Daemon that re-runs cfn-init when metadata changes |
| `cfn-get-metadata` | Retrieve metadata | Debugging; rarely used directly |

### cfn-init Metadata Structure (execution order is fixed)

```yaml
AWS::CloudFormation::Init:
  configSets:
    default:
      - install
      - configure
  install:
    packages:       # 1. Install packages (yum, apt, rpm, msi, python)
      yum:
        httpd: []
    groups:          # 2. Create groups
    users:           # 3. Create users
    sources:         # 4. Download and unpack archives
    files:           # 5. Create files (content, source, authentication)
      /etc/myapp/config.json:
        content: !Sub |
          { "region": "${AWS::Region}" }
        mode: "000644"
    commands:        # 6. Run commands (alphabetical order by key)
      01_command:
        command: "echo hello"
    services:        # 7. Enable/start services
      sysvinit:
        httpd:
          enabled: true
          ensureRunning: true
```

### Dynamic Reference Syntax

| Type | Syntax | Example |
|---|---|---|
| SSM Parameter | `{{resolve:ssm:name:version}}` | `{{resolve:ssm:/app/db-host:1}}` |
| SSM SecureString | `{{resolve:ssm-secure:name:version}}` | `{{resolve:ssm-secure:/app/db-pass:1}}` |
| Secrets Manager | `{{resolve:secretsmanager:id:SecretString:key:stage}}` | `{{resolve:secretsmanager:MySecret:SecretString:password::}}` |

### StackSet Key Concepts

- **Administrator account**: manages the StackSet
- **Target accounts**: receive stack instances
- **Permission models**: Self-managed (IAM roles) or Service-managed (AWS Organizations)
- **MaxConcurrentCount/Percentage**: how many accounts update simultaneously
- **FailureToleranceCount/Percentage**: how many failures allowed before stopping
- **Auto-deployment**: automatically deploy to new accounts added to an OU (Organizations only)
- **Stack instances**: a reference to a stack in a target account/region

---

## Cheat Sheet 3: Auto Scaling Quick Reference

### Scaling Policy Types

| Policy Type | How It Works | Cooldown? | Best For |
|---|---|---|---|
| **Target Tracking** | Maintain a metric at a target value | Built-in (no manual cooldown) | Most use cases; "set and forget" |
| **Step Scaling** | Scale in steps based on alarm breach size | No cooldown (reacts to size of breach) | Different scaling amounts for different thresholds |
| **Simple Scaling** | Scale by fixed amount on alarm | Yes (default 300s) | Legacy; avoid for new designs |
| **Scheduled Scaling** | Scale at specific date/time or cron | N/A | Predictable load patterns |
| **Predictive Scaling** | ML forecasts load, pre-scales | N/A | Cyclical patterns with 14+ days of data |

### Key Metrics for Scaling

| Metric | Typical Target | Notes |
|---|---|---|
| `CPUUtilization` | 40-70% | Most common; built-in for target tracking |
| `RequestCountPerTarget` | Varies | ALB metric; good for web apps |
| `NetworkIn` / `NetworkOut` | Varies | Network-bound workloads |
| `ApproximateNumberOfMessagesVisible` | Custom | SQS-based scaling (use backlog-per-instance) |
| Custom Metric | Custom | Any CloudWatch metric |

### Cooldown Behavior

- **Default cooldown**: 300 seconds (Simple Scaling only)
- During cooldown: ASG won't launch/terminate additional instances
- **Scale-in protection**: prevent specific instances from being terminated
- **Target Tracking / Step Scaling**: use built-in scaling adjustments; no manual cooldown needed
- Tip: Use a shorter cooldown for scale-out and longer for scale-in

### Lifecycle Hooks

| Event | Pending State | Use Case |
|---|---|---|
| `EC2_INSTANCE_LAUNCHING` | `Pending:Wait` → `Pending:Proceed` | Install software, register with service discovery, warm cache |
| `EC2_INSTANCE_TERMINATING` | `Terminating:Wait` → `Terminating:Proceed` | Drain connections, deregister, save logs, cleanup |

- Default timeout: 3600 seconds (1 hour); max: 172800 seconds (48 hours)
- Heartbeat: `RecordLifecycleActionHeartbeat` to extend the timeout
- Send `CONTINUE` to proceed or `ABANDON` to stop (for launching, instance is terminated)
- Notification targets: EventBridge (recommended), SNS, SQS

### Termination Policies (evaluated in order)

1. **AZ Balance**: first selects the AZ with most instances
2. Then applies chosen policy within that AZ:
   - `OldestLaunchConfiguration` / `OldestLaunchTemplate`
   - `OldestInstance`
   - `NewestInstance`
   - `ClosestToNextInstanceHour`
   - `AllocationStrategy` (for mixed instances)
   - `Default`: oldest launch config → closest to billing hour → random

### Instance Refresh

- Replaces instances to deploy updates (new AMI, user data, etc.)
- **MinHealthyPercentage**: minimum % of healthy instances during refresh (default 90%)
- **InstanceWarmup**: time to wait before counting a new instance as healthy
- **SkipMatching**: skip instances that already match desired configuration
- **Checkpoints**: pause at specified percentages for verification
- Triggers: manual start, or automatic on launch template change (with auto-rollback)

---

## Cheat Sheet 4: DR Strategy Comparison

| Strategy | RTO | RPO | Cost | Complexity | Key AWS Services |
|---|---|---|---|---|---|
| **Backup & Restore** | Hours | Hours | $ (lowest) | Low | AWS Backup, S3 CRR, EBS Snapshots, RDS Snapshots, DLM |
| **Pilot Light** | 10s of minutes | Minutes | $$ | Medium | RDS Read Replica (cross-region), AMIs, Route 53, minimal EC2/Aurora |
| **Warm Standby** | Minutes | Seconds–Minutes | $$$ | Medium-High | Aurora Global DB, ASG (scaled down), Route 53, ALB, DynamoDB Global Tables |
| **Multi-Site Active/Active** | Near-zero | Near-zero | $$$$ (highest) | High | DynamoDB Global Tables, Aurora Global DB, Route 53 (latency/failover), Global Accelerator, CloudFront |

### Strategy Selection Guide

| Requirement | Recommended Strategy |
|---|---|
| RTO/RPO: hours, lowest cost | Backup & Restore |
| RTO: < 30 min, budget-conscious | Pilot Light |
| RTO: < 10 min, mission-critical | Warm Standby |
| RTO/RPO: near-zero, cost not primary concern | Multi-Site Active/Active |
| Regulatory requirement for different region | Any cross-region strategy |
| Data sovereignty + DR | Multi-region with specific region selection |

### DR Services Quick Reference

| Service | DR Capability |
|---|---|
| **Aurora Global Database** | Cross-region, RPO ~1s, managed failover |
| **DynamoDB Global Tables** | Multi-region active-active, sub-second replication |
| **S3 CRR** | Cross-region async replication |
| **RDS Read Replica (cross-region)** | Promote to standalone for DR |
| **Elastic Disaster Recovery (DRS)** | Continuous block-level replication, RPO seconds |
| **Route 53 Failover** | DNS-based automatic failover |
| **Global Accelerator** | Anycast IP-based failover (faster than DNS) |
| **CloudFront Origin Failover** | Automatic origin failover on error codes |
| **AWS Backup** | Cross-region/cross-account backup copies |

---

## Cheat Sheet 5: CodeDeploy Lifecycle Hooks

### EC2/On-Premises — In-Place Deployment

```
(Start) 
  ↓
ApplicationStop            ← Run scripts to stop current app
  ↓
DownloadBundle             ← Download new revision (automatic, no hook)
  ↓
BeforeInstall              ← Pre-install tasks (backup, decrypt files)
  ↓
Install                    ← Copy files to destination (automatic, no hook)
  ↓
AfterInstall               ← Post-install config (permissions, restart)
  ↓
ApplicationStart           ← Start the application
  ↓
ValidateService            ← Verify deployment succeeded (health checks)
  ↓
(End)
```

**With Load Balancer (additional hooks):**
```
BeforeBlockTraffic         ← Before deregistering from LB
  ↓
BlockTraffic               ← Deregister from LB (automatic)
  ↓
AfterBlockTraffic          ← After deregistering from LB
  ↓
[... normal hooks above ...]
  ↓
BeforeAllowTraffic         ← Before registering with LB
  ↓
AllowTraffic               ← Register with LB (automatic)
  ↓
AfterAllowTraffic          ← After registering with LB
```

### EC2/On-Premises — Blue/Green Deployment

**On REPLACEMENT (green) instances:**
Same as in-place hooks above, plus traffic-shifting hooks.

**On ORIGINAL (blue) instances:**
Only `BeforeBlockTraffic`, `BlockTraffic`, `AfterBlockTraffic` run before termination.

### ECS (Blue/Green) Deployment

```
BeforeInstall              ← Before replacement task set is created
  ↓
Install                    ← Create replacement task set (automatic)
  ↓
AfterInstall               ← After replacement task set is created
  ↓
AllowTestTraffic           ← Route test traffic to replacement (automatic)
  ↓
AfterAllowTestTraffic      ← Run tests against replacement via test listener
  ↓
BeforeAllowTraffic         ← Before production traffic shifts
  ↓
AllowTraffic               ← Shift production traffic (automatic)
  ↓
AfterAllowTraffic          ← Verify production traffic on replacement
```

### Lambda Deployment

```
BeforeAllowTraffic         ← Run validation Lambda before traffic shift
  ↓
AllowTraffic               ← Shift traffic to new version (automatic)
  ↓
AfterAllowTraffic          ← Run validation Lambda after traffic shift
```

**Key Notes:**
- Hooks prefixed with "Before"/"After" are where you run custom scripts
- Steps without "Before"/"After" (Install, BlockTraffic, AllowTraffic, etc.) are automatic — no custom scripts
- ECS and Lambda hooks invoke Lambda functions (not scripts on instances)
- EC2 hooks run scripts specified in the appspec.yml

---

## Cheat Sheet 6: EventBridge Event Pattern Syntax

### Content Filtering Options

| Filter | Syntax | Matches |
|---|---|---|
| **Exact match** | `"detail-type": ["EC2 Instance State-change Notification"]` | Exact string value |
| **Prefix** | `"source": [{"prefix": "aws."}]` | Strings starting with "aws." |
| **Suffix** | `"filename": [{"suffix": ".png"}]` | Strings ending with ".png" |
| **Anything-but** | `"status": [{"anything-but": ["stopped"]}]` | Any value except "stopped" |
| **Anything-but prefix** | `"source": [{"anything-but": {"prefix": "aws."}}]` | Values NOT starting with "aws." |
| **Numeric (equals)** | `"price": [{"numeric": ["=", 100]}]` | Exactly 100 |
| **Numeric (range)** | `"price": [{"numeric": [">", 0, "<=", 100]}]` | Between 0 (excl) and 100 (incl) |
| **Exists** | `"detail.error": [{"exists": true}]` | Field is present |
| **Not exists** | `"detail.error": [{"exists": false}]` | Field is absent |
| **Equals-ignore-case** | `"status": [{"equals-ignore-case": "running"}]` | Case-insensitive match |
| **Wildcard** | `"key": [{"wildcard": "*.log"}]` | Glob-style match |
| **Multiple values (OR)** | `"state": ["running", "stopped"]` | Either value |
| **Multiple fields (AND)** | Multiple fields in pattern | All must match |
| **Combine filters** | `"x": [{"numeric": [">",0]}, {"numeric": ["<",100]}]` | OR between array items |

### Common Event Patterns

**EC2 Instance State Change:**
```json
{
  "source": ["aws.ec2"],
  "detail-type": ["EC2 Instance State-change Notification"],
  "detail": {
    "state": ["stopped", "terminated"]
  }
}
```

**CodePipeline Execution State Change:**
```json
{
  "source": ["aws.codepipeline"],
  "detail-type": ["CodePipeline Pipeline Execution State Change"],
  "detail": {
    "state": ["FAILED"]
  }
}
```

**Config Compliance Change:**
```json
{
  "source": ["aws.config"],
  "detail-type": ["Config Rules Compliance Change"],
  "detail": {
    "newEvaluationResult": {
      "complianceType": ["NON_COMPLIANT"]
    }
  }
}
```

**GuardDuty Finding (High Severity):**
```json
{
  "source": ["aws.guardduty"],
  "detail-type": ["GuardDuty Finding"],
  "detail": {
    "severity": [{"numeric": [">=", 7]}]
  }
}
```

**CloudFormation Stack Status:**
```json
{
  "source": ["aws.cloudformation"],
  "detail-type": ["CloudFormation Stack Status Change"],
  "detail": {
    "status-details": {
      "status": ["CREATE_FAILED", "ROLLBACK_COMPLETE", "DELETE_FAILED"]
    }
  }
}
```

**Health Event:**
```json
{
  "source": ["aws.health"],
  "detail-type": ["AWS Health Event"],
  "detail": {
    "service": ["EC2"],
    "eventTypeCategory": ["scheduledChange"]
  }
}
```

**S3 Object Created (via CloudTrail):**
```json
{
  "source": ["aws.s3"],
  "detail-type": ["AWS API Call via CloudTrail"],
  "detail": {
    "eventSource": ["s3.amazonaws.com"],
    "eventName": ["PutObject", "CompleteMultipartUpload"]
  }
}
```

---

## Cheat Sheet 7: IAM Policy Evaluation Logic

### Single-Account Policy Evaluation Flow

```
Request comes in
       ↓
1. Start with IMPLICIT DENY (everything denied by default)
       ↓
2. Evaluate all applicable policies:
   ├── SCP (if in an Organization)
   ├── Resource-based policy
   ├── Permission boundary
   ├── Session policy (if assumed role / federated)
   └── Identity-based policy (user/group/role policies)
       ↓
3. Is there an EXPLICIT DENY in ANY policy?
   ├── YES → ★ DENY (explicit deny always wins)
   └── NO → continue
       ↓
4. Is there an SCP?
   ├── YES → Does SCP ALLOW?
   │    ├── NO → ★ DENY
   │    └── YES → continue
   └── NO → continue
       ↓
5. Is there a resource-based policy that allows?
   ├── YES → ★ ALLOW (for same-account; acts as both identity + resource grant)
   └── NO → continue
       ↓
6. Is there a permission boundary?
   ├── YES → Does boundary ALLOW?
   │    ├── NO → ★ DENY
   │    └── YES → continue
   └── NO → continue
       ↓
7. Is there a session policy?
   ├── YES → Does session policy ALLOW?
   │    ├── NO → ★ DENY
   │    └── YES → continue
   └── NO → continue
       ↓
8. Does identity-based policy ALLOW?
   ├── YES → ★ ALLOW
   └── NO → ★ DENY (implicit)
```

### Cross-Account Policy Evaluation

```
Account A (requester) → Account B (resource owner)

Both must allow the action:
  Account A: Identity-based policy must ALLOW
  Account B: Resource-based policy must ALLOW

Exception: IAM Role in Account B
  - Account A: Identity-based policy must ALLOW sts:AssumeRole
  - Account B: Role trust policy must ALLOW Account A
  - Only the ROLE's policies apply (not Account A's identity policies)
```

### SCP + IAM Interaction

- SCPs affect ALL users and roles in member accounts (including root user of member accounts)
- SCPs do NOT affect the management account
- SCPs do NOT affect service-linked roles
- Effective permissions = SCP ∩ Identity Policy ∩ Permission Boundary
- SCPs are evaluated at every level of the OU hierarchy (intersection of all)

### Key Policy Evaluation Rules

| Rule | Detail |
|---|---|
| Explicit Deny always wins | Overrides any Allow in any policy |
| Default is implicit deny | Must have explicit Allow somewhere |
| SCP is a guardrail | Does not grant permissions, only limits |
| Permission boundary is a guardrail | Does not grant permissions, only limits |
| Resource policy can grant directly | In same account, can serve as sole Allow |
| Cross-account requires both sides | Identity policy + resource policy (or trust policy for roles) |
| Condition keys narrow scope | Evaluated within the policy they're in |

---

## Cheat Sheet 8: CloudWatch Quick Reference

### Metric Resolution and Retention

| Resolution | Period | Retention | Type |
|---|---|---|---|
| High resolution | 1 second | 3 hours | Custom metrics only (`StorageResolution=1`) |
| Standard | 60 seconds | 15 days | Default for AWS services |
| — | 5 minutes | 63 days | Auto-aggregated |
| — | 1 hour | 455 days (15 months) | Auto-aggregated |

### Alarm Evaluation

| Setting | Options |
|---|---|
| **Period** | Evaluation period (e.g., 300 seconds) |
| **Evaluation Periods** | Number of periods to evaluate (e.g., 3) |
| **Datapoints to Alarm** | How many of those periods must breach (e.g., 2 of 3) |
| **Treat Missing Data** | `missing` (current state), `notBreaching`, `breaching`, `ignore` |
| **Alarm States** | `OK`, `ALARM`, `INSUFFICIENT_DATA` |
| **Actions** | SNS, Auto Scaling, EC2 (stop/terminate/reboot/recover), Systems Manager |

### Log Filter Pattern Syntax

**Space-delimited logs:**
```
[ip, id, user, timestamp, request, status_code = 5*, size]
```

**JSON logs:**
```
{ $.statusCode = 500 }
{ $.latency > 1000 }
{ $.user.name = "admin" }
{ $.statusCode != 200 && $.latency > 500 }
```

**Simple text matching:**
```
"ERROR"                           # Contains ERROR
?"ERROR" ?"WARN"                  # ERROR or WARN
"ERROR" -"404"                    # ERROR but not 404
%ERROR\s+\d{3}%                   # Regex pattern (% delimiters)
```

### CloudWatch Logs Insights Query Syntax

```sql
-- Filter and display fields
fields @timestamp, @message
| filter @message like /ERROR/
| sort @timestamp desc
| limit 20

-- Stats and aggregation
stats count(*) as errorCount by bin(30m)
| filter @message like /ERROR/

-- Parse structured logs
parse @message "user=* action=* status=*" as user, action, status
| stats count(*) by user, action

-- Percentile
stats avg(duration) as avgDur, pct(duration, 95) as p95 by operation
```

### CloudWatch Agent Comparison

| Feature | CloudWatch Logs Agent (Legacy) | CloudWatch Agent (Unified/Current) |
|---|---|---|
| Logs | Yes | Yes |
| Metrics (OS-level) | No | Yes (RAM, disk, swap, netstat, processes, CPU per-core) |
| StatsD / collectd | No | Yes |
| Configuration | Config file | JSON config (wizard available, store in SSM Parameter Store) |
| Windows | No | Yes |
| Status | Deprecated | Current — always use this one |
| Prometheus | No | Yes (container environments) |

### Key CloudWatch Features

| Feature | Purpose |
|---|---|
| **Metric Filter** | Extract metrics from log events |
| **Subscription Filter** | Stream logs to Kinesis, Lambda, OpenSearch (max 2 per log group) |
| **Contributor Insights** | Top-N contributors to a metric |
| **Anomaly Detection** | ML-based expected value bands |
| **Composite Alarms** | Combine alarms with AND/OR/NOT |
| **Synthetics (Canaries)** | Scripted monitoring of endpoints |
| **Embedded Metric Format** | Embed metrics in structured log JSON |
| **Container Insights** | ECS/EKS cluster-level metrics |
| **Cross-Account Observability** | OAM — share metrics/logs/traces across accounts |

---

## Cheat Sheet 9: Key Service Limits

### CodePipeline

| Limit | Value |
|---|---|
| Pipelines per region | 1,000 (soft) |
| Stages per pipeline | 50 |
| Actions per stage | 50 |
| Custom actions per region | 50 |
| Webhooks per region | 300 |
| Manual approval timeout | 7 days (default), max 7 days |
| Artifact size (S3) | 5 GB (per artifact) |

### CodeBuild

| Limit | Value |
|---|---|
| Concurrent builds | 60 (soft) |
| Build timeout | 5 min – 8 hours (default 60 min) |
| Queued builds timeout | 8 hours |
| Build spec file size | 64 KB |
| Environment variables | 200 per project |

### CodeDeploy

| Limit | Value |
|---|---|
| Applications per account | 1,000 |
| Deployment groups per application | 1,000 |
| Concurrent deployments per account | 100 |
| Instances per deployment | Unlimited (in-place), varies (blue/green) |
| Lifecycle event timeout | 3,600 seconds (1 hour) default |
| AppSpec file size | 5 MB (YAML/JSON) |

### CloudFormation

| Limit | Value |
|---|---|
| Stacks per account | 2,000 (soft) |
| Resources per stack | 500 |
| Outputs per stack | 200 |
| Parameters per stack | 200 |
| Mappings per stack | 200 |
| Template body size (inline) | 51,200 bytes |
| Template body size (S3) | 1 MB |
| Stack sets per admin account | 100 |
| Stack instances per stack set | 2,000 |

### Lambda

| Limit | Value |
|---|---|
| Concurrent executions | 1,000 (soft, per region) |
| Memory | 128 MB – 10,240 MB |
| Timeout | 900 seconds (15 minutes) |
| Deployment package (zipped) | 50 MB (direct), 250 MB (unzipped), 10 GB (container image) |
| Environment variables | 4 KB total |
| /tmp storage | 512 MB – 10,240 MB |
| Layers | 5 per function |

### SQS

| Limit | Value |
|---|---|
| Message size | 256 KB (use Extended Client / S3 for larger) |
| Message retention | 1 min – 14 days (default 4 days) |
| Visibility timeout | 0 – 12 hours (default 30 seconds) |
| Long polling wait | 0 – 20 seconds |
| FIFO throughput | 300 msg/sec (3,000 with batching) |
| Standard throughput | Nearly unlimited |
| DLQ maxReceiveCount | 1 – 1,000 |
| In-flight messages (Standard) | 120,000 |
| In-flight messages (FIFO) | 20,000 |

### SNS

| Limit | Value |
|---|---|
| Topics per account | 100,000 (soft) |
| Subscriptions per topic | 12,500,000 |
| Message size | 256 KB |
| Filter policies per topic | 200 |
| FIFO throughput | 300 msg/sec (3,000 with batching) |

---

## Cheat Sheet 10: Comparison Tables

### SNS vs SQS vs EventBridge vs Kinesis

| Feature | SNS | SQS | EventBridge | Kinesis Data Streams |
|---|---|---|---|---|
| **Model** | Pub/Sub | Queue | Event Bus | Stream |
| **Delivery** | Push to subscribers | Pull (consumer polls) | Push to targets | Pull (consumers poll) |
| **Ordering** | FIFO topic only | FIFO queue only | Best effort (or ordered via Pipes) | Per-shard ordering |
| **Persistence** | No (deliver and forget) | Yes (up to 14 days) | Archive/replay available | Yes (1–365 days) |
| **Consumers** | Multiple (fan-out) | Single consumer group | Multiple targets per rule | Multiple consumers (enhanced fan-out) |
| **Throughput** | High | Standard: unlimited, FIFO: 300/sec | Varies by bus type | Unlimited (add shards) |
| **Filtering** | Subscription filter policy | N/A (consumer filters) | Event pattern matching | N/A (consumer filters) |
| **Replay** | No | No | Yes (archive/replay) | Yes (within retention) |
| **Best For** | Fan-out notifications | Decoupling, buffering | Event-driven routing, SaaS | Real-time analytics, high-volume |

### CloudFormation vs CDK vs Terraform

| Feature | CloudFormation | CDK | Terraform |
|---|---|---|---|
| **Language** | YAML/JSON | TypeScript, Python, Java, C#, Go | HCL |
| **State** | Managed by AWS (stack) | CloudFormation (synthesizes to CFN) | State file (S3 + DynamoDB for remote) |
| **Provider** | AWS only | AWS only (synthesizes to CFN) | Multi-cloud |
| **Abstraction** | Low (resource-level) | High (L1/L2/L3 constructs) | Medium (modules) |
| **Drift Detection** | Built-in | Via CloudFormation | `terraform plan` |
| **Loops/Conditions** | Limited (Conditions, Fn::If) | Full programming language | for_each, count, conditionals |
| **Testing** | cfn-lint, CloudFormation Guard | assertions, snapshot tests | `terraform validate`, Sentinel |
| **When to use** | AWS-native, enterprise governance | Complex logic, reusable patterns | Multi-cloud, existing Terraform expertise |

### Config vs CloudTrail vs CloudWatch

| Feature | AWS Config | CloudTrail | CloudWatch |
|---|---|---|---|
| **What it tracks** | Resource configuration state | API calls (who did what) | Metrics, logs, alarms |
| **Focus** | Compliance and configuration | Audit and governance | Operational monitoring |
| **Key output** | Configuration items, compliance | Event history, log files | Metrics, dashboards, alarms |
| **Time aspect** | Configuration timeline (state over time) | Event log (who, when, what) | Real-time metrics and logs |
| **Remediation** | Auto-remediation (SSM Automation) | N/A (detection only) | Alarms → actions (SNS, ASG, Lambda) |
| **Example** | "Is this S3 bucket encrypted?" | "Who created this S3 bucket?" | "What's the CPU usage?" |

### ECS vs EKS vs Lambda

| Feature | ECS | EKS | Lambda |
|---|---|---|---|
| **Orchestration** | AWS proprietary | Kubernetes | AWS managed |
| **Compute** | EC2 or Fargate | EC2 or Fargate | Managed |
| **Scaling** | Service Auto Scaling | HPA, Karpenter, Cluster Autoscaler | Automatic (concurrent executions) |
| **Max runtime** | Unlimited | Unlimited | 15 minutes |
| **Startup** | Seconds (Fargate: ~30s) | Seconds (Fargate: ~30s) | Milliseconds (cold start: seconds) |
| **Pricing** | Per EC2/Fargate resource | Per EC2/Fargate + $0.10/hr control plane | Per request + duration |
| **When to use** | Containers, AWS-native | Kubernetes ecosystem, portability | Event-driven, short tasks, serverless |

### SSM Parameter Store vs Secrets Manager

| Feature | Parameter Store | Secrets Manager |
|---|---|---|
| **Cost** | Free (Standard), paid (Advanced) | ~$0.40/secret/month |
| **Auto-rotation** | No (use Lambda manually) | Yes (built-in Lambda rotation) |
| **Size** | 4 KB (Standard), 8 KB (Advanced) | 64 KB |
| **Cross-region replication** | No | Yes |
| **Hierarchy/path** | Yes (`/app/prod/db-host`) | No (flat naming) |
| **Versioning** | Yes | Yes |
| **Encryption** | Optional (SecureString with KMS) | Always encrypted (KMS) |
| **CloudFormation dynamic ref** | `{{resolve:ssm:}}` / `{{resolve:ssm-secure:}}` | `{{resolve:secretsmanager:}}` |
| **When to use** | Config values, non-rotating secrets | Credentials that need rotation |

### Elastic Beanstalk vs OpsWorks vs CloudFormation

| Feature | Elastic Beanstalk | OpsWorks | CloudFormation |
|---|---|---|---|
| **Abstraction** | Highest (PaaS) | Medium (configuration management) | Lowest (IaC) |
| **Config tool** | AWS-managed | Chef / Puppet | Declarative templates |
| **Target user** | Developers (deploy and run) | Ops teams (configure instances) | Infrastructure engineers |
| **Customization** | .ebextensions, platform hooks | Chef recipes / Puppet manifests | Full resource control |
| **Scaling** | Built-in Auto Scaling | Layer-based scaling | You define ASG resources |
| **When to use** | Simple web apps, quick deployment | Chef/Puppet shops, layered architectures | Full control, any AWS resource |

### CodePipeline vs Jenkins

| Feature | CodePipeline | Jenkins |
|---|---|---|
| **Type** | Managed CI/CD orchestrator | Self-hosted CI/CD server |
| **Infrastructure** | Serverless | You manage servers/agents |
| **Build execution** | Delegates to CodeBuild/others | Runs on Jenkins agents |
| **Plugins** | AWS integrations + custom actions | 1800+ plugins |
| **Cost** | Per pipeline per month | Free (open source) + infra cost |
| **Scaling** | Automatic | Manual (add agents) |
| **When to use** | AWS-native CI/CD, simple orchestration | Complex builds, multi-cloud, existing Jenkins |

### Standard SQS vs FIFO SQS

| Feature | Standard | FIFO |
|---|---|---|
| **Throughput** | Nearly unlimited | 300 msg/sec (3,000 with batching) |
| **Ordering** | Best-effort | Strict (within message group) |
| **Delivery** | At-least-once | Exactly-once |
| **Deduplication** | None | Content-based or MessageDeduplicationId |
| **Message Groups** | N/A | MessageGroupId (parallel ordered processing) |
| **Queue name** | Any | Must end with `.fifo` |
| **DLQ type** | Must be Standard | Must be FIFO |
| **SNS compatibility** | Standard or FIFO topic | FIFO topic only |

### ALB vs NLB vs GLB

| Feature | ALB | NLB | GLB |
|---|---|---|---|
| **Layer** | 7 (HTTP/HTTPS) | 4 (TCP/UDP/TLS) | 3 (IP packets) |
| **Routing** | Path, host, header, query, method, source IP | Port-based | N/A (transparently routes all traffic) |
| **Performance** | Good | Ultra-low latency, millions req/sec | Inline appliance inspection |
| **Static IP** | No (use Global Accelerator) | Yes (Elastic IP per AZ) | N/A |
| **Health checks** | HTTP/HTTPS | TCP, HTTP, HTTPS | HTTP, HTTPS, TCP |
| **WebSockets** | Yes | Yes | N/A |
| **Use case** | Web apps, microservices, API routing | TCP-heavy, gaming, IoT, extreme performance | Security appliances (firewalls, IDS/IPS) |
| **Target types** | Instance, IP, Lambda | Instance, IP, ALB | Instance, IP |
| **Cross-zone** | Enabled by default | Disabled by default | N/A |

---

## Cheat Sheet 11: Key AWS CLI Commands for DevOps

### CodePipeline

```bash
# List pipelines
aws codepipeline list-pipelines

# Get pipeline state
aws codepipeline get-pipeline-state --name MyPipeline

# Start pipeline execution
aws codepipeline start-pipeline-execution --name MyPipeline

# Approve/reject manual approval
aws codepipeline put-approval-result \
  --pipeline-name MyPipeline \
  --stage-name Approval \
  --action-name ManualApproval \
  --result summary="Approved",status="Approved" \
  --token <token>

# Retry failed stage
aws codepipeline retry-stage-execution \
  --pipeline-name MyPipeline \
  --stage-name Deploy \
  --pipeline-execution-id <id> \
  --retry-mode FAILED_ACTIONS

# Get pipeline definition
aws codepipeline get-pipeline --name MyPipeline
```

### CodeBuild

```bash
# Start a build
aws codebuild start-build --project-name MyProject

# Start build with overrides
aws codebuild start-build --project-name MyProject \
  --environment-variables-override name=ENV,value=prod,type=PLAINTEXT

# List builds for a project
aws codebuild list-builds-for-project --project-name MyProject

# Get build details
aws codebuild batch-get-builds --ids <build-id>

# Stop a running build
aws codebuild stop-build --id <build-id>
```

### CodeDeploy

```bash
# Create deployment
aws deploy create-deployment \
  --application-name MyApp \
  --deployment-group-name MyDG \
  --s3-location bucket=my-bucket,key=app.zip,bundleType=zip

# Get deployment status
aws deploy get-deployment --deployment-id <id>

# Stop a deployment
aws deploy stop-deployment --deployment-id <id> --auto-rollback-enabled

# List deployments
aws deploy list-deployments --application-name MyApp

# Register on-premises instance
aws deploy register-on-premises-instance \
  --instance-name MyServer \
  --iam-session-arn <arn>
```

### CloudFormation

```bash
# Create stack
aws cloudformation create-stack \
  --stack-name MyStack \
  --template-body file://template.yaml \
  --parameters ParameterKey=Env,ParameterValue=prod \
  --capabilities CAPABILITY_IAM CAPABILITY_NAMED_IAM

# Update stack
aws cloudformation update-stack --stack-name MyStack --template-body file://template.yaml

# Create change set
aws cloudformation create-change-set \
  --stack-name MyStack \
  --change-set-name MyChangeSet \
  --template-body file://template.yaml

# Execute change set
aws cloudformation execute-change-set --change-set-name MyChangeSet --stack-name MyStack

# Detect drift
aws cloudformation detect-stack-drift --stack-name MyStack
aws cloudformation describe-stack-drift-detection-status --stack-drift-detection-id <id>

# Delete stack
aws cloudformation delete-stack --stack-name MyStack

# Wait for stack creation
aws cloudformation wait stack-create-complete --stack-name MyStack

# Validate template
aws cloudformation validate-template --template-body file://template.yaml

# List stack resources
aws cloudformation list-stack-resources --stack-name MyStack

# Enable termination protection
aws cloudformation update-termination-protection \
  --enable-termination-protection --stack-name MyStack
```

### Systems Manager (SSM)

```bash
# Get parameter
aws ssm get-parameter --name /app/db-host --with-decryption

# Put parameter
aws ssm put-parameter --name /app/db-host --value "mydb.endpoint.com" \
  --type SecureString --overwrite

# Run command
aws ssm send-command \
  --document-name "AWS-RunShellScript" \
  --targets "Key=tag:Environment,Values=Production" \
  --parameters 'commands=["yum update -y"]'

# Get command output
aws ssm get-command-invocation \
  --command-id <id> \
  --instance-id <id>

# Start automation
aws ssm start-automation-execution \
  --document-name "AWS-RestartEC2Instance" \
  --parameters "InstanceId=i-1234567890"

# List associations
aws ssm list-associations

# Describe instance information
aws ssm describe-instance-information
```

---

## Cheat Sheet 12: Exam Day Quick Review

### Top 50 Facts to Remember

1. **CodeDeploy EC2 hooks order**: ApplicationStop → DownloadBundle → BeforeInstall → Install → AfterInstall → ApplicationStart → ValidateService
2. **CodeDeploy for ECS** is Blue/Green only — no in-place
3. **CodeDeploy for Lambda** uses aliases + traffic shifting (Canary/Linear)
4. **cfn-signal** + **CreationPolicy** = wait for instance configuration to complete
5. **cfn-hup** = daemon that detects metadata changes and re-runs cfn-init
6. **CloudFormation DeletionPolicy: Snapshot** only works on EBS, RDS, Redshift, Neptune, DocumentDB
7. **StackSets** = deploy across accounts/regions; service-managed needs Organizations
8. **Change sets** preview changes but don't guarantee success
9. **Dynamic references** work for SSM, SSM-Secure, and Secrets Manager in CloudFormation templates
10. **CDK L1** = CfnXxx (direct CFN), **L2** = defaults + helpers, **L3** = patterns/multi-resource
11. **Elastic Beanstalk immutable** = new ASG, safest rollback, highest cost
12. **Elastic Beanstalk blue/green** = manual CNAME swap (not a deployment policy)
13. **Auto Scaling cooldown** applies only to Simple Scaling
14. **Target tracking** = most common scaling policy, automatically creates alarms
15. **Warm pools** = pre-initialized stopped instances for fast scale-out
16. **Lifecycle hooks** pause instances in Pending:Wait or Terminating:Wait
17. **Instance refresh** = rolling replacement, uses MinHealthyPercentage
18. **SQS visibility timeout** default = 30 seconds; set ≥ function timeout for Lambda
19. **SQS FIFO** = 300 msg/sec (3000 batched), must end with `.fifo`
20. **SNS FIFO** subscribers must be SQS FIFO
21. **Lambda reserved concurrency** = guarantees AND limits; set to 0 = throttled
22. **Lambda provisioned concurrency** = eliminates cold starts
23. **Lambda destinations** > DLQ (carry more context, support success+failure)
24. **Step Functions Standard** = max 1 year; **Express** = max 5 minutes
25. **EventBridge**: archive + replay for debugging
26. **EventBridge Pipes**: point-to-point (source → filter → enrich → target)
27. **CloudWatch high-resolution** = 1-second, custom metrics only
28. **CloudWatch metric retention**: 1-min=15 days, 5-min=63 days, 1-hr=455 days
29. **CloudWatch Logs**: max 2 subscription filters per log group
30. **CloudWatch Logs export to S3** is NOT real-time — use subscription filter + Firehose
31. **X-Ray annotations** = indexed (searchable); **metadata** = not indexed
32. **X-Ray sampling**: first request/second + 5% of additional (default)
33. **CloudTrail data events** are opt-in (not logged by default)
34. **CloudTrail log integrity** = digest files, validate with CLI
35. **Config rules** detect; **Config remediation** fixes (SSM Automation)
36. **Config conformance packs** = bundle of rules + remediation as YAML
37. **SCPs** don't affect the management account
38. **Permission boundaries** limit maximum permissions (intersection with identity policy)
39. **Explicit deny** always wins in IAM evaluation
40. **Control Tower guardrails**: preventive (SCP), detective (Config), proactive (CFN Hooks)
41. **Service Catalog launch constraint** = role that launches on behalf of user
42. **DR strategies cost order**: Backup/Restore < Pilot Light < Warm Standby < Multi-Site
43. **Aurora Global Database RPO** ≈ 1 second
44. **DynamoDB Global Tables** = multi-active, last-writer-wins
45. **Route 53 failover routing** requires health checks
46. **Global Accelerator** = faster failover than DNS (no TTL caching issue)
47. **ECS deployment circuit breaker** auto-rolls back failed rolling deployments
48. **SSM Patch Manager** uses Patch Baselines + Patch Groups + Maintenance Windows
49. **SSM State Manager** maintains desired state via Associations
50. **Secrets Manager** has auto-rotation; **Parameter Store** does not (natively)

### Common Wrong Answer Traps

| Trap | Why It's Wrong | Correct Answer |
|---|---|---|
| "Use CloudWatch Events" | Renamed/succeeded by EventBridge | Use EventBridge |
| "Use CloudWatch Logs Agent" | Deprecated | Use CloudWatch Agent (Unified) |
| "SCP grants permissions" | SCPs only restrict/allow, never grant | SCPs set maximum permissions boundary |
| "Use polling for CodePipeline source" | Polling is deprecated/not recommended | Use EventBridge triggers or webhooks |
| "CloudFormation stack policy grants update" | Stack policy only restricts by default | Stack policy denies all then you allow specific |
| "Blue/green is a Beanstalk deployment policy" | It's a manual process | CNAME swap between two environments |
| "DLQ receives failed sync Lambda invocations" | DLQ is for async only | Sync failures go back to caller |
| "Config fixes drift" | Config detects drift | Use SSM Automation for remediation |
| "Multi-AZ RDS standby is readable" | Standby is NOT readable | Use Read Replicas for read scaling |
| "Lambda@Edge has 15-min timeout" | Lambda@Edge limit is 30 seconds (viewer) / 30 seconds (origin) | Standard Lambda = 15 min; Edge = much shorter |
| "S3 CRR is synchronous" | It's asynchronous | S3 stores synchronously within the region |
| "CodeDeploy creates new instances for in-place" | In-place deploys to existing instances | Blue/Green creates new instances |

### Key Words That Hint at Specific Services

| Key Word/Phrase | Service |
|---|---|
| "who made the API call" / "audit" / "governance" | CloudTrail |
| "compliance" / "resource configuration" / "is it compliant" | AWS Config |
| "metric" / "alarm" / "dashboard" / "log query" | CloudWatch |
| "trace" / "latency" / "service map" / "distributed tracing" | X-Ray |
| "deploy to multiple accounts and regions" | CloudFormation StackSets |
| "deploy approved products" / "self-service provisioning" | Service Catalog |
| "desired state" / "configuration management" | SSM State Manager (or OpsWorks) |
| "patch instances" | SSM Patch Manager |
| "run commands on instances without SSH" | SSM Run Command |
| "scheduled scaling" / "predictive scaling" | Auto Scaling |
| "traffic shifting" / "canary" / "linear" (Lambda) | CodeDeploy + Lambda Alias |
| "block non-compliant actions before creation" | SCP (preventive) or CloudFormation Hooks (proactive) |
| "detect non-compliant after creation" | Config Rules (detective) |
| "central logging" / "all accounts" | Organization Trail, Config Aggregator |
| "prevent accidental deletion" | DeletionPolicy: Retain, Termination Protection |
| "wait for instance to be ready" | CreationPolicy + cfn-signal |
| "respond to events from AWS services" | EventBridge |
| "decouple" / "buffer" / "queue" | SQS |
| "fan-out" / "notify multiple subscribers" | SNS |
| "orchestrate workflow" / "state machine" | Step Functions |
| "container orchestration" | ECS or EKS |
| "serverless" / "event-driven function" | Lambda |
| "cross-region failover" / "DNS routing" | Route 53 |
| "near-zero RTO/RPO" / "active-active" | Multi-Site + DynamoDB Global Tables + Aurora Global |
| "continuous replication" / "block-level DR" | Elastic Disaster Recovery (DRS) |
| "chaos engineering" / "fault injection" | AWS Fault Injection Simulator (FIS) |
| "custom metrics from logs without PutMetricData" | Embedded Metric Format (EMF) |
| "automatic secret rotation" | Secrets Manager |
| "prevent region usage" | SCP with aws:RequestedRegion condition |
| "infrastructure as code with loops and conditions" | CDK (or Terraform) |

---

> **Exam Tip:** Read every answer choice carefully. Eliminate answers that use deprecated services (OpsWorks for new deployments, CloudWatch Events as a standalone service, Logs Agent). Look for the MOST operationally efficient and lowest-effort solution. When two answers seem correct, pick the one that is more automated and uses managed AWS services.
