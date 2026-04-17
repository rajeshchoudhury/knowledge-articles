# AWS DevOps Engineer Professional (DOP-C02) — 8-Week Study Plan

> **Commitment:** 2–3 hours per day, 6 days per week (Sundays off or light review).
> **Total estimated study time:** ~120–144 hours.

---

## Overview of the 8-Week Schedule

| Week | Phase | Focus Domains | Hours |
|---|---|---|---|
| 1 | Foundation | Domain 1 – SDLC Automation (Part 1: CodePipeline, CodeBuild, CodeCommit) | 15–18 |
| 2 | Foundation | Domain 1 – SDLC Automation (Part 2: CodeDeploy, Deployment Strategies, Beanstalk) | 15–18 |
| 3 | Foundation | Domain 2 – Configuration Management and IaC | 15–18 |
| 4 | Foundation | Domain 3 – Monitoring and Logging | 15–18 |
| 5 | Deep Dive | Domain 5 – Incident and Event Response + Domain 4 – Policies and Standards | 15–18 |
| 6 | Deep Dive | Domain 6 – HA, Fault Tolerance, and DR | 15–18 |
| 7 | Practice | Full practice exams + weak-area review | 15–18 |
| 8 | Review & Cram | Targeted review, flash cards, final practice exam | 15–18 |

---

## Week 1: SDLC Automation — CI/CD Pipelines and Build

**Phase:** Foundation
**Domain:** 1 – SDLC Automation (22%)
**Goal:** Master CodePipeline, CodeBuild, CodeCommit, source integrations, and artifact management.

### Daily Breakdown

| Day | Topic | Activity | Time |
|---|---|---|---|
| Mon | CodeCommit | Read CodeCommit docs: repos, branches, triggers, notifications, PR workflows. Set up a repo with branch protection and an SNS notification trigger. | 2.5 h |
| Tue | CodePipeline Fundamentals | Read CodePipeline user guide (structure, stages, actions, transitions, manual approvals). Build a 3-stage pipeline (Source → Build → Deploy to S3). | 3 h |
| Wed | CodePipeline Advanced | Cross-account pipelines, cross-region actions, artifact stores (S3 + KMS), pipeline execution modes, V1 vs V2 pipeline types. Lab: build a cross-region pipeline. | 3 h |
| Thu | CodeBuild Deep Dive | buildspec.yml structure (phases, env, artifacts, cache, reports). Lab: build a Docker image, push to ECR, use S3 caching, generate test reports. | 3 h |
| Fri | CodeBuild Advanced + CodeArtifact | VPC access for CodeBuild, Secrets Manager integration, batch builds, custom build images. CodeArtifact: domains, repos, upstream repos. Lab: CodeBuild in VPC + CodeArtifact npm repo. | 3 h |
| Sat | Review + Practice Questions | Review all notes from the week. Answer 20 SDLC practice questions. Review explanations thoroughly. | 2.5 h |

### Hands-On Labs

1. Create a CodeCommit repository with a main/develop branching strategy and configure an EventBridge rule that triggers on PR merges.
2. Build a CodePipeline with Source (CodeCommit) → Build (CodeBuild) → Deploy (S3) with a manual approval gate between Build and Deploy.
3. Write a `buildspec.yml` that builds a Docker image, runs unit tests, generates a test report, and pushes the image to ECR.
4. Configure CodeBuild to access resources in a VPC (e.g., an RDS database for integration tests).
5. Set up a CodeArtifact domain and repository; configure npm/pip to use it as an upstream source.

### Resources

- [CodePipeline User Guide](https://docs.aws.amazon.com/codepipeline/latest/userguide/welcome.html)
- [CodeBuild Build Spec Reference](https://docs.aws.amazon.com/codebuild/latest/userguide/build-spec-ref.html)
- [CodeCommit User Guide](https://docs.aws.amazon.com/codecommit/latest/userguide/welcome.html)
- [CodeArtifact User Guide](https://docs.aws.amazon.com/codeartifact/latest/ug/welcome.html)
- Whitepaper: *Practicing CI/CD on AWS*

### Milestone Checkpoint

- [ ] Can describe the complete CodePipeline structure (stages, actions, input/output artifacts, transitions)
- [ ] Can write a buildspec.yml from scratch for Docker builds with caching
- [ ] Understand V1 vs V2 pipeline types and pipeline execution modes
- [ ] Know how cross-account and cross-region pipelines work (IAM roles, KMS, S3 artifact buckets)

---

## Week 2: SDLC Automation — Deployments and Strategies

**Phase:** Foundation
**Domain:** 1 – SDLC Automation (22%)
**Goal:** Master CodeDeploy, all deployment strategies, Elastic Beanstalk, ECR, and testing in pipelines.

### Daily Breakdown

| Day | Topic | Activity | Time |
|---|---|---|---|
| Mon | CodeDeploy – EC2/On-Premises | AppSpec file for EC2, lifecycle hooks, deployment groups, deployment configs, agent installation. Lab: deploy to an Auto Scaling group with CodeDeploy. | 3 h |
| Tue | CodeDeploy – ECS and Lambda | Blue/green deployments on ECS (task set, ALB, listener rules). Lambda: canary/linear/all-at-once. AppSpec for ECS and Lambda. Lab: ECS blue/green deployment. | 3 h |
| Wed | Deployment Strategies | In-place, rolling, rolling+batch, blue/green, canary, linear, immutable, traffic splitting. Compare across CodeDeploy, Beanstalk, ECS, Lambda. Create a comparison chart. | 2.5 h |
| Thu | Elastic Beanstalk | Deployment policies, .ebextensions, platform hooks, worker environments, blue/green (CNAME swap), managed updates, custom AMI. Lab: deploy an app with rolling+batch. | 3 h |
| Fri | ECR + Testing + Branching | ECR lifecycle policies, image scanning, cross-account replication, immutable tags. Testing strategies in pipelines. Branching strategies (GitFlow, trunk-based). Feature flags with AppConfig. | 2.5 h |
| Sat | Review + Practice Questions | Complete 25 SDLC practice questions (deployment-heavy). Build a full pipeline: Source → Build → Deploy (CodeDeploy blue/green to ECS). | 3 h |

### Hands-On Labs

1. Deploy an application to EC2 Auto Scaling group using CodeDeploy with an in-place rolling deployment; configure auto-rollback on CloudWatch alarm.
2. Perform an ECS blue/green deployment with CodeDeploy — configure the AppSpec, define lifecycle hooks (BeforeAllowTraffic, AfterAllowTraffic), and validate with a Lambda function.
3. Deploy a Lambda function using CodeDeploy with a canary10Percent5Minutes configuration.
4. Deploy an Elastic Beanstalk application using immutable deployment policy; then practice blue/green via environment CNAME swap.
5. Configure ECR lifecycle policies to keep only the last 10 tagged images; enable image scanning on push.
6. Set up an AppConfig feature flag and use it in a Lambda function.

### Resources

- [CodeDeploy AppSpec Reference](https://docs.aws.amazon.com/codedeploy/latest/userguide/reference-appspec-file.html)
- [CodeDeploy Deployment Configurations](https://docs.aws.amazon.com/codedeploy/latest/userguide/deployment-configurations.html)
- [Elastic Beanstalk Deployment Policies](https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/using-features.rolling-version-deploy.html)
- [ECR User Guide](https://docs.aws.amazon.com/AmazonECR/latest/userguide/what-is-ecr.html)
- [AppConfig User Guide](https://docs.aws.amazon.com/appconfig/latest/userguide/what-is-appconfig.html)

### Milestone Checkpoint

- [ ] Can write AppSpec files for EC2, ECS, and Lambda from memory
- [ ] Can explain every deployment strategy and when to use each
- [ ] Know auto-rollback triggers and configuration for CodeDeploy
- [ ] Understand the differences between Beanstalk deployment policies
- [ ] Can describe ECS blue/green deployment flow with CodeDeploy (replacement task set, reroute traffic, termination wait)

---

## Week 3: Configuration Management and Infrastructure as Code

**Phase:** Foundation
**Domain:** 2 – Configuration Management and IaC (17%)
**Goal:** Master CloudFormation, CDK basics, Systems Manager, OpsWorks, and Service Catalog.

### Daily Breakdown

| Day | Topic | Activity | Time |
|---|---|---|---|
| Mon | CloudFormation Fundamentals | Template anatomy, intrinsic functions (Ref, Fn::GetAtt, Fn::Sub, Fn::ImportValue, Fn::Select, Fn::If), pseudo-parameters, mappings, conditions. Lab: write a multi-resource template. | 3 h |
| Tue | CloudFormation Advanced | Nested stacks, cross-stack references, StackSets (Organizations integration, drift detection), change sets, rollback triggers, custom resources (Lambda-backed), resource import, deletion policies. | 3 h |
| Wed | CloudFormation Deployment + Helpers | cfn-init, cfn-signal, cfn-hup, CreationPolicy, WaitCondition, DependsOn. CloudFormation + CodePipeline deployment actions. Drift detection. Lab: cfn-init bootstrapping an EC2 instance. | 3 h |
| Thu | AWS CDK + Service Catalog | CDK constructs (L1/L2/L3), `cdk synth`, `cdk diff`, `cdk deploy`, CDK Pipelines. Service Catalog: portfolios, products, constraints, TagOptions, launch roles. | 2.5 h |
| Fri | Systems Manager | SSM Agent, Run Command, Automation (runbooks, approval steps), Patch Manager (baselines, maintenance windows), State Manager, Session Manager, Parameter Store (Standard/Advanced, tiers, policies). | 3 h |
| Sat | OpsWorks + Review | OpsWorks Stacks (Chef), OpsWorks for Chef Automate, OpsWorks for Puppet Enterprise. When to use which. Week 3 review + 20 IaC practice questions. | 2.5 h |

### Hands-On Labs

1. Build a CloudFormation template with conditions, mappings, nested stacks, and outputs exported for cross-stack reference.
2. Use CloudFormation StackSets to deploy a Config Rule across an Organization.
3. Create a custom resource backed by a Lambda function.
4. Set up a CDK Pipelines self-mutating pipeline.
5. Create an SSM Automation runbook that patches an instance, waits for health check, then snapshots the AMI.
6. Configure Patch Manager with a custom patch baseline and a maintenance window.

### Resources

- [CloudFormation Template Reference](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/template-reference.html)
- [CDK Developer Guide](https://docs.aws.amazon.com/cdk/v2/guide/home.html)
- [Systems Manager User Guide](https://docs.aws.amazon.com/systems-manager/latest/userguide/what-is-systems-manager.html)
- Whitepaper: *Infrastructure as Code*

### Milestone Checkpoint

- [ ] Can write CloudFormation templates with intrinsic functions, conditions, and nested stacks from scratch
- [ ] Know StackSets permissions models (self-managed vs service-managed)
- [ ] Understand cfn-init / cfn-signal / CreationPolicy pattern
- [ ] Can describe SSM Automation runbooks and when to use them vs. Run Command
- [ ] Know the differences between OpsWorks Stacks, Chef Automate, and Puppet Enterprise

---

## Week 4: Monitoring and Logging

**Phase:** Foundation
**Domain:** 3 – Monitoring and Logging (15%)
**Goal:** Master CloudWatch, X-Ray, CloudTrail, centralized logging patterns, and OpenSearch.

### Daily Breakdown

| Day | Topic | Activity | Time |
|---|---|---|---|
| Mon | CloudWatch Metrics & Alarms | Custom metrics (PutMetricData, high-resolution), metric math, composite alarms, anomaly detection, alarm actions (EC2, ASG, SNS). Lab: create composite alarm for an ECS service. | 3 h |
| Tue | CloudWatch Logs | Log groups, streams, filters, metric filters, subscription filters, Logs Insights queries, cross-account log subscriptions, retention policies, export to S3. Lab: metric filter → alarm → SNS. | 3 h |
| Wed | CloudWatch Advanced | Dashboards, Synthetics (canary scripts), RUM, Evidently (feature flags + A/B testing), Contributor Insights, ServiceLens. Lab: build a Synthetics canary for an API. | 2.5 h |
| Thu | X-Ray + CloudTrail | X-Ray: SDK instrumentation, daemon, sampling rules, trace analysis, service map, groups, insights. CloudTrail: management/data events, trails, organization trail, Insights, integration with Athena. | 3 h |
| Fri | Centralized Logging | Architecture: CloudWatch Logs → Kinesis Data Firehose → S3 / OpenSearch. Cross-account logging patterns. VPC Flow Logs, ALB access logs, S3 access logs. OpenSearch basics. | 2.5 h |
| Sat | Review + Practice Questions | Review all notes. Answer 20 monitoring/logging practice questions. Build a centralized logging architecture diagram. | 2.5 h |

### Hands-On Labs

1. Create a CloudWatch metric filter that parses ERROR from application logs, triggers an alarm, sends to SNS, and invokes a Lambda for auto-remediation.
2. Set up cross-account CloudWatch Logs subscription from a workload account to a central logging account via Kinesis Data Firehose → S3.
3. Instrument a sample application with X-Ray SDK; view traces, service map, and create X-Ray groups.
4. Create a CloudTrail organization trail with data events for S3; query logs using Athena.
5. Build a CloudWatch Synthetics canary that monitors an API endpoint and creates alarms on failure.

### Resources

- [CloudWatch User Guide](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/WhatIsCloudWatch.html)
- [X-Ray Developer Guide](https://docs.aws.amazon.com/xray/latest/devguide/aws-xray.html)
- [CloudTrail User Guide](https://docs.aws.amazon.com/awscloudtrail/latest/userguide/cloudtrail-user-guide.html)

### Milestone Checkpoint

- [ ] Can write CloudWatch Logs Insights queries for common patterns
- [ ] Know metric filter syntax and how to create alarms from log-derived metrics
- [ ] Understand cross-account CloudWatch Logs subscription architecture
- [ ] Can explain X-Ray sampling rules and how traces propagate across services
- [ ] Know the difference between CloudTrail management events, data events, and Insights events

---

## Week 5: Incident Response + Policies and Standards

**Phase:** Deep Dive
**Domain:** 5 – Incident and Event Response (18%) + Domain 4 – Policies and Standards (10%)
**Goal:** Master EventBridge-driven automation, auto-remediation, Config Rules, SCPs, and security services.

### Daily Breakdown

| Day | Topic | Activity | Time |
|---|---|---|---|
| Mon | EventBridge Deep Dive | Event buses (default, custom, partner), event patterns (content filtering), rules, targets, input transformers, archive & replay, cross-account event delivery. Lab: EventBridge → Step Functions workflow. | 3 h |
| Tue | Incident Response Automation | Lambda-based remediation, SSM Automation for incident response, GuardDuty → EventBridge → Lambda patterns, Health API events, Auto Scaling lifecycle hooks for draining. Lab: auto-remediate unauthorized security group change. | 3 h |
| Wed | Systems Manager Incident Manager | Incident Manager: response plans, contacts, escalation plans, runbooks, post-incident analysis. Lab: set up an Incident Manager response plan with SSM Automation. | 2.5 h |
| Thu | AWS Config Deep Dive | Managed rules, custom rules (Lambda, Guard), aggregators, conformance packs, remediation actions (manual, automatic), multi-account/multi-region. Lab: Config Rule + SSM auto-remediation. | 3 h |
| Fri | Policies and Standards | SCPs (deny patterns, guardrails), IAM policies (boundaries, session policies), AWS Organizations, Control Tower (guardrails: preventive/detective/proactive), Security Hub, Inspector, GuardDuty, Macie. | 3 h |
| Sat | Review + Practice Questions | Answer 15 incident response + 10 policies practice questions. Create a cheat sheet mapping "event → detection → remediation" flows. | 2.5 h |

### Hands-On Labs

1. Create an EventBridge rule that matches GuardDuty findings of high severity and invokes a Step Functions workflow to isolate the affected EC2 instance.
2. Configure Auto Scaling lifecycle hooks to drain ECS tasks before instance termination.
3. Set up AWS Config with 5 managed rules, 1 custom rule (Lambda-based), and automatic remediation using SSM Automation.
4. Create an SCP that denies disabling CloudTrail, disabling GuardDuty, or leaving the Organization.
5. Enable Security Hub across an Organization and configure automated findings ingestion.

### Resources

- [EventBridge User Guide](https://docs.aws.amazon.com/eventbridge/latest/userguide/eb-what-is.html)
- [AWS Config Developer Guide](https://docs.aws.amazon.com/config/latest/developerguide/WhatIsConfig.html)
- [Organizations SCP Documentation](https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_policies_scps.html)
- [Security Hub User Guide](https://docs.aws.amazon.com/securityhub/latest/userguide/what-is-securityhub.html)

### Milestone Checkpoint

- [ ] Can design EventBridge → Lambda/Step Functions auto-remediation patterns from memory
- [ ] Know the difference between Config Rules (compliance) and CloudTrail (audit logging)
- [ ] Understand SCP evaluation logic and common deny patterns
- [ ] Can explain the Control Tower guardrail types and how they map to Config Rules and SCPs
- [ ] Know when to use GuardDuty vs. Inspector vs. Macie vs. Security Hub

---

## Week 6: High Availability, Fault Tolerance, and Disaster Recovery

**Phase:** Deep Dive
**Domain:** 6 – HA, FT, and DR (18%)
**Goal:** Master multi-AZ/multi-region architectures, DR strategies, Route 53 failover, and data replication.

### Daily Breakdown

| Day | Topic | Activity | Time |
|---|---|---|---|
| Mon | HA Fundamentals | Multi-AZ deployments (RDS, ElastiCache, EFS, ALB), Auto Scaling (target tracking, step, scheduled, predictive), ELB (ALB/NLB/GWLB), cross-zone load balancing, connection draining. | 3 h |
| Tue | DR Strategies | Backup & Restore, Pilot Light, Warm Standby, Multi-site Active/Active. RPO/RTO calculations. AWS Elastic Disaster Recovery (DRS). Lab: set up DRS for an EC2 instance. | 3 h |
| Wed | Route 53 + DNS Failover | Routing policies (simple, weighted, latency, failover, geolocation, geoproximity, multivalue). Health checks (endpoint, calculated, CloudWatch alarm). DNS failover architectures. | 2.5 h |
| Thu | Data Replication | S3 CRR/SRR (replication rules, time control, metrics), DynamoDB Global Tables, Aurora Global Database (write forwarding, managed failover), RDS cross-region read replicas, cross-region KMS. | 3 h |
| Fri | Multi-Region Architecture | Multi-region CI/CD pipelines, Route 53 with health checks, cross-region EventBridge, AWS Backup (cross-region, cross-account vaults), Well-Architected reliability patterns. | 3 h |
| Sat | Review + Practice Questions | Answer 25 HA/FT/DR practice questions. Draw a multi-region active-passive architecture diagram. | 2.5 h |

### Hands-On Labs

1. Configure RDS Multi-AZ with automated failover; simulate a failover and observe behavior.
2. Set up S3 Cross-Region Replication with replication time control.
3. Create an Aurora Global Database; practice a managed planned failover.
4. Configure Route 53 failover routing with health checks that monitor an ALB.
5. Set up AWS Backup with a cross-region backup vault and a backup plan.
6. Deploy a pilot-light DR architecture: AMI copies, stopped EC2 instances, pre-provisioned VPC, Route 53 failover.

### Resources

- [Disaster Recovery Whitepaper](https://docs.aws.amazon.com/whitepapers/latest/disaster-recovery-workloads-on-aws/disaster-recovery-workloads-on-aws.html)
- [Route 53 Developer Guide](https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/Welcome.html)
- [Aurora Global Database](https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/aurora-global-database.html)
- [AWS Backup Developer Guide](https://docs.aws.amazon.com/aws-backup/latest/devguide/whatisbackup.html)
- Well-Architected Reliability Pillar

### Milestone Checkpoint

- [ ] Can name the 4 DR strategies and their typical RPO/RTO ranges
- [ ] Know how DRS works at a high level (continuous replication, recovery instances, drill)
- [ ] Understand Route 53 failover with calculated health checks
- [ ] Can explain Aurora Global Database failover (planned, unplanned, detach & promote)
- [ ] Know cross-region replication patterns for S3, DynamoDB, RDS, Aurora, and EBS

---

## Week 7: Practice Exams and Weak-Area Review

**Phase:** Practice
**Goal:** Take full-length practice exams, identify weak areas, deep-dive into gaps.

### Daily Breakdown

| Day | Activity | Time |
|---|---|---|
| Mon | **Practice Exam 1** (75 questions, timed 180 min). Score it. Categorize every wrong answer by domain. | 3 h |
| Tue | **Review Exam 1**: For every wrong answer, read the relevant docs section. Make flashcards. Re-do the section practice questions for the weakest domain. | 3 h |
| Wed | **Targeted study**: Focus on the 2 weakest domains from Exam 1. Re-read articles, redo labs. | 3 h |
| Thu | **Practice Exam 2** (75 questions, timed 180 min). Score it. Compare improvement. | 3 h |
| Fri | **Review Exam 2**: Deep-dive into remaining weak areas. Focus on any patterns you keep missing. | 2.5 h |
| Sat | **Cross-domain scenario practice**: 20 questions that span multiple domains (e.g., CI/CD + monitoring, IaC + HA). | 2.5 h |

### Tips for This Phase

- **Track your scores by domain** — create a simple spreadsheet.
- **Don't just memorize answers** — understand *why* each wrong option is wrong.
- **Time yourself** — if you're consistently running over 2.4 min/question, practice speed reading scenarios.
- **Focus 80% of review time on weak areas**, not on domains where you already score >80%.

### Practice Exam Sources

- [AWS Skill Builder](https://explore.skillbuilder.aws/) — Official practice exam (free with account)
- [Tutorials Dojo](https://tutorialsdojo.com/) — Excellent scenario-based questions (highly recommended)
- [Whizlabs](https://www.whizlabs.com/) — Large question bank
- [Stephane Maarek Udemy Practice Tests](https://www.udemy.com/) — Popular and well-regarded

### Milestone Checkpoint

- [ ] Scored ≥ 75% on at least one full-length practice exam
- [ ] Can identify weak domains and have a targeted plan to address them
- [ ] Comfortable with time management (finishing with ≥ 20 min to spare)

---

## Week 8: Final Review and Cram Strategy

**Phase:** Review & Cram
**Goal:** Solidify knowledge, fill final gaps, build exam confidence.

### Daily Breakdown

| Day | Activity | Time |
|---|---|---|
| Mon | **Cheat sheet creation**: Write a 1-page cheat sheet per domain from memory. Then check against your notes — anything you missed goes on a "critical review" list. | 3 h |
| Tue | **Service comparison cramming**: Review all the "when to use X vs Y" decisions: CodeDeploy vs Beanstalk vs ECS deploy, Config vs CloudTrail, GuardDuty vs Inspector vs Macie, Secrets Manager vs Parameter Store, etc. | 2.5 h |
| Wed | **Deployment strategy mega-review**: Create a matrix of all deployment strategies × all services. This is the single highest-ROI topic. | 2.5 h |
| Thu | **Practice Exam 3** (final full-length, timed). Target score: ≥ 80%. Review any remaining wrong answers. | 3 h |
| Fri | **Light review only**: Re-read cheat sheets, key whitepapers (CI/CD, DR). Go through "critical review" list one final time. **No new topics.** Rest your brain. | 2 h |
| Sat | **Exam day** (or rest day if exam is Sunday/Monday). | — |

### Last-Week Cram Priorities

These are the topics most likely to make the difference between pass and fail:

1. **Deployment strategies** — which strategy for which service, with which configuration
2. **EventBridge patterns** — event-driven architecture for automation and incident response
3. **CloudFormation** — intrinsic functions, helper scripts, StackSets, custom resources
4. **Auto Scaling lifecycle hooks** — how they integrate with CodeDeploy and ECS
5. **Cross-account patterns** — IAM assume-role chains, resource policies, Organizations SCPs
6. **Config Rules + remediation** — managed rules, custom rules, SSM Automation remediation
7. **DR strategies** — RPO/RTO, pilot light vs warm standby, Route 53 failover
8. **SSM Automation** — runbooks, approval steps, multi-account execution

### Key Differentiators to Memorize

| Topic A | Topic B | Key Difference |
|---|---|---|
| Secrets Manager | Parameter Store SecureString | Secrets Manager has built-in rotation (Lambda); Parameter Store does not natively rotate. |
| Config Rules | CloudTrail | Config = compliance state ("is it compliant?"); CloudTrail = audit log ("who changed it?"). |
| GuardDuty | Inspector | GuardDuty = threat detection (VPC Flow, DNS, CloudTrail); Inspector = vulnerability scanning (EC2, ECR, Lambda). |
| Blue/Green | Canary | Blue/Green shifts 100% at once to new env; Canary shifts incrementally (e.g., 10% then 90%). |
| CodeDeploy in-place | CodeDeploy blue/green | In-place updates existing instances; blue/green provisions new instances. |
| Rolling | Rolling with additional batch | Rolling takes instances out of service; rolling+batch launches extra instances first to maintain capacity. |
| Immutable | Blue/Green (Beanstalk) | Immutable creates instances in *same* environment's ASG; blue/green creates an entirely *new* environment. |
| CloudFormation drift | Config Rules | Drift = "does resource match template?"; Config = "does resource match compliance rule?" |
| StackSets self-managed | StackSets service-managed | Self-managed = you create admin/execution IAM roles; service-managed = Organizations manages trust automatically. |

### Day Before the Exam

- **Do NOT study new topics.** Only review your cheat sheets.
- Get a full night's sleep.
- Prepare your testing environment (quiet room for online; or know your testing center route).
- Have your ID and confirmation email ready.
- Arrive / log in 15 minutes early.

---

## Resource Summary Across All Weeks

### Video Courses

| Course | Platform |
|---|---|
| Stephane Maarek — AWS DevOps Professional | Udemy |
| Adrian Cantrill — AWS DevOps Professional | learn.cantrill.io |
| Neal Davis — AWS DevOps Professional | Digital Cloud Training |

### Practice Exams

| Source | Notes |
|---|---|
| AWS Skill Builder Official Practice | Free, closest to real exam |
| Tutorials Dojo | Best scenario-based questions |
| Whizlabs | Large bank, good explanations |
| Stephane Maarek (Udemy) | Good complement |

### Documentation and Whitepapers

- Practicing CI/CD on AWS (whitepaper)
- Infrastructure as Code (whitepaper)
- Disaster Recovery on AWS (whitepaper)
- Well-Architected Operational Excellence Pillar
- Well-Architected Reliability Pillar
- All service user guides listed in weekly resources

### re:Invent Sessions (Search YouTube)

- "Deep Dive on AWS CodePipeline"
- "Advanced Deployment Strategies on AWS"
- "Infrastructure as Code: AWS CloudFormation and Beyond"
- "Monitoring and Observability on AWS"
- "Multi-Account Strategies"
- "Disaster Recovery with AWS"

---

## Progress Tracker

Copy this into a separate document and check off items as you go:

```
Week 1: [ ] Mon [ ] Tue [ ] Wed [ ] Thu [ ] Fri [ ] Sat — Milestone: ___/4
Week 2: [ ] Mon [ ] Tue [ ] Wed [ ] Thu [ ] Fri [ ] Sat — Milestone: ___/5
Week 3: [ ] Mon [ ] Tue [ ] Wed [ ] Thu [ ] Fri [ ] Sat — Milestone: ___/5
Week 4: [ ] Mon [ ] Tue [ ] Wed [ ] Thu [ ] Fri [ ] Sat — Milestone: ___/5
Week 5: [ ] Mon [ ] Tue [ ] Wed [ ] Thu [ ] Fri [ ] Sat — Milestone: ___/5
Week 6: [ ] Mon [ ] Tue [ ] Wed [ ] Thu [ ] Fri [ ] Sat — Milestone: ___/5
Week 7: [ ] Mon [ ] Tue [ ] Wed [ ] Thu [ ] Fri [ ] Sat — Milestone: ___/3
Week 8: [ ] Mon [ ] Tue [ ] Wed [ ] Thu [ ] Fri [ ] Sat — EXAM DAY!

Practice Exam Scores:
  Exam 1: ___/75 (___%)  — Weakest: Domain ___
  Exam 2: ___/75 (___%)  — Weakest: Domain ___
  Exam 3: ___/75 (___%)  — Weakest: Domain ___
```

---

*Good luck — you've got this!*
