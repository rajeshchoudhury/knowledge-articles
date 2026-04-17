# Domain 5 - Continuous Improvement Flash Cards

## AWS Certified Solutions Architect - Professional (SAP-C02)

**Topics:** Systems Manager features, CloudFormation advanced, CDK, Service Catalog, Proton, CloudWatch features, X-Ray, Grafana/Prometheus, DR strategies (RPO/RTO), Elastic Disaster Recovery, Route 53 ARC, Backup, FIS, CI/CD tools (CodeCommit/Build/Deploy/Pipeline), deployment strategies, performance optimization, caching

---

### Card 1
**Q:** What is AWS Systems Manager and its key capabilities?
**A:** Systems Manager (SSM) is a management hub for AWS and on-premises resources. Key capabilities: (1) **Run Command** – execute scripts/commands across fleet. (2) **Patch Manager** – automate OS/application patching. (3) **State Manager** – define and enforce desired state. (4) **Inventory** – collect software/config metadata. (5) **Session Manager** – secure shell without SSH/RDP. (6) **Parameter Store** – centralized config/secrets. (7) **Automation** – runbook execution (documents). (8) **Maintenance Windows** – schedule tasks. (9) **OpsCenter** – aggregate operational issues. (10) **Explorer** – dashboard of operational data. (11) **Change Manager** – approve and track operational changes.

---

### Card 2
**Q:** What is SSM Run Command and how does it work?
**A:** Run Command executes commands on managed instances (EC2 + on-premises) without SSH. Uses SSM Agent (pre-installed on Amazon Linux/Windows AMIs). Features: execute across instance tags/resource groups, rate/error threshold controls, output to S3/CloudWatch, EventBridge notifications, cross-account via Organizations. Documents (SSM Documents) define commands: AWS-provided (AWS-RunShellScript, AWS-RunPowerShellScript) or custom. Use for: ad-hoc commands, configuration changes, software installation, script execution at scale.

---

### Card 3
**Q:** What is SSM Patch Manager?
**A:** Patch Manager automates patching OS and applications on managed instances. Components: (1) **Patch baselines** – define which patches to approve/reject (by severity, classification, auto-approval delays). AWS provides default baselines per OS. (2) **Patch groups** – tag-based grouping for different baseline assignments. (3) **Maintenance windows** – schedule patching. (4) **Compliance reporting** – view patch status per instance. Process: scan for missing patches → apply approved patches → reboot if needed → report compliance. Supports: Linux, Windows, macOS.

---

### Card 4
**Q:** What is SSM Automation and what are its use cases?
**A:** SSM Automation executes multi-step workflows (runbooks) on AWS resources. Automation documents define steps using actions: `aws:executeScript` (Python/PowerShell), `aws:executeAwsApi`, `aws:approve` (manual approval), `aws:branch` (conditional), `aws:sleep`, `aws:changeInstanceState`. Use cases: (1) Remediate Config rule violations (auto-remediation). (2) Golden AMI creation pipeline. (3) Instance recovery (stop, snapshot, restart). (4) Cross-account automation via Organizations. (5) Change management workflows. AWS provides 100+ pre-built documents. Can be triggered by EventBridge, Config rules, or manually.

---

### Card 5
**Q:** What is the difference between SSM Parameter Store Standard and Advanced tiers?
**A:** **Standard**: free, 10,000 parameters max, 4 KB value size, no parameter policies. **Advanced**: $0.05/parameter/month, 100,000 parameters max, 8 KB value size, parameter policies (TTL/expiration, notification before expiration). Both support: String, StringList, SecureString (KMS encryption), hierarchical organization (/app/prod/db_password), versioning. For SecureString: Standard uses default AWS-managed KMS key (free) or CMK ($). Choose Advanced when: need > 10,000 parameters, values > 4 KB, or parameter policies.

---

### Card 6
**Q:** What is AWS CloudFormation and its key advanced features?
**A:** CloudFormation is Infrastructure as Code (IaC) using JSON/YAML templates. Advanced features: (1) **Nested stacks** – modular templates (reuse child stacks). (2) **Cross-stack references** – Export/ImportValue between stacks. (3) **StackSets** – deploy across accounts/regions. (4) **Drift detection** – identify manual changes to stack resources. (5) **Change sets** – preview changes before applying. (6) **Custom resources** – extend with Lambda-backed resources. (7) **Macros** – transform templates with Lambda. (8) **Hooks** – validate resources pre-create/update. (9) **Resource imports** – adopt existing resources into a stack. (10) **Modules** – reusable resource collections.

---

### Card 7
**Q:** What are CloudFormation StackSets and their deployment options?
**A:** StackSets deploy stacks across multiple accounts and regions from a single template. Deployment options: (1) **Self-managed permissions** – create IAM roles manually in admin and target accounts. (2) **Service-managed permissions** – automatic with Organizations. Supports auto-deployment to new accounts joining an OU. Features: concurrent deployments, failure tolerance (max failures/percentage), operation preferences (region order, parallel/sequential), parameter overrides per account/region. Use for: organizational baselines (Config, CloudTrail, security), guardrails, compliance.

---

### Card 8
**Q:** What is CloudFormation drift detection?
**A:** Drift detection identifies resources that have been changed outside of CloudFormation (manual console/API changes). Process: initiate drift detection on stack → CloudFormation compares actual resource configuration vs. template-defined configuration → reports: IN_SYNC, MODIFIED, DELETED, NOT_CHECKED. Drift details show: expected vs. actual values for each property. Limitations: not all resource properties support drift detection, not all resource types supported. Use for: compliance auditing, identifying configuration drift in production. Cannot automatically fix drift—you must update the template or the resource.

---

### Card 9
**Q:** What are CloudFormation custom resources?
**A:** Custom resources let you include resources not natively supported by CloudFormation or execute custom logic during stack operations. Implemented via: (1) **Lambda-backed** – CloudFormation invokes a Lambda function (most common). (2) **SNS-backed** – CloudFormation sends request to SNS topic. Lambda receives: RequestType (Create/Update/Delete), ResourceProperties, and must return a response to a pre-signed S3 URL. Use for: looking up AMI IDs, creating resources in third-party systems, running data migration scripts, any logic not covered by native resources.

---

### Card 10
**Q:** What is AWS CDK (Cloud Development Kit)?
**A:** CDK defines cloud infrastructure using programming languages (TypeScript, Python, Java, C#, Go). Key concepts: (1) **Constructs** – building blocks (L1: direct CloudFormation, L2: higher-level with defaults, L3: patterns combining multiple resources). (2) **Stacks** – unit of deployment. (3) **App** – container for stacks. CDK synthesizes to CloudFormation templates. Benefits: use loops, conditions, inheritance; IDE auto-completion; test infrastructure with unit tests; reusable libraries. `cdk synth` generates template, `cdk deploy` deploys, `cdk diff` shows changes.

---

### Card 11
**Q:** What is the difference between CDK L1, L2, and L3 constructs?
**A:** (1) **L1 (CFN resources)**: direct mapping to CloudFormation resources. Prefix: `Cfn*` (e.g., `CfnBucket`). You specify all properties. Most control, most verbose. (2) **L2 (Curated)**: higher-level with sensible defaults and convenience methods. (e.g., `Bucket` with `.addLifecycleRule()`). Reduces boilerplate. Most commonly used. (3) **L3 (Patterns)**: multi-resource patterns combining L2 constructs. (e.g., `LambdaRestApi` creates API Gateway + Lambda integration). Highest abstraction, opinionated defaults. Choose L2 for most resources; use L1 when L2 doesn't support a property; use L3 for common patterns.

---

### Card 12
**Q:** What is AWS Proton?
**A:** Proton is a managed service for platform engineering. Platform teams define: (1) **Environment templates** – shared infrastructure (VPC, ECS cluster, databases). (2) **Service templates** – application deployment patterns (containerized service, Lambda function). Templates use CloudFormation or Terraform. Developers select a template and deploy without managing infrastructure. Proton handles: provisioning, monitoring template versions, propagating updates to deployed instances. Enables: self-service deployment, consistent infrastructure, separation of platform and application concerns. Integrates with CodePipeline for CI/CD.

---

### Card 13
**Q:** What is Amazon CloudWatch and its key monitoring features?
**A:** CloudWatch provides monitoring and observability. Features: (1) **Metrics** – time-series data (AWS and custom). Standard 5-min, detailed 1-min, high-res 1-sec. (2) **Alarms** – threshold-based alerting (OK/ALARM/INSUFFICIENT_DATA). Composite alarms combine multiple. (3) **Dashboards** – customizable visualizations. Cross-account and cross-region. (4) **Logs** – centralized log management. Log groups, streams, insights queries, metric filters. (5) **Events/EventBridge** – event-driven automation. (6) **Contributor Insights** – identify top contributors. (7) **Anomaly Detection** – ML-based thresholds. (8) **ServiceLens** – map and monitor services.

---

### Card 14
**Q:** What are CloudWatch Alarms and their types?
**A:** Types: (1) **Metric alarm** – monitors a single metric against a threshold. Actions: SNS, Auto Scaling, EC2 (stop, terminate, reboot, recover). States: OK, ALARM, INSUFFICIENT_DATA. Configurable: period (evaluation interval), evaluation periods (data points to alarm), statistic (Average, Max, p99, etc.). (2) **Composite alarm** – combines multiple alarms using Boolean logic (AND, OR, NOT). Reduces alarm noise. Example: only alert when BOTH CPU > 80% AND memory > 90%. (3) **Anomaly detection alarm** – uses ML model of metric's expected value; alarms on deviation bands.

---

### Card 15
**Q:** What is CloudWatch Logs Insights?
**A:** Logs Insights enables interactive querying of log data using a purpose-built query language. Features: auto-discovers log fields, supports: filtering (`filter`), aggregation (`stats`), sorting (`sort`), pattern matching (`parse`), time-series visualization. Queries across multiple log groups. Saves queries for reuse. Query language supports: pipe syntax, regex, glob patterns, mathematical/statistical functions. Use for: troubleshooting (find errors), operational analysis, security investigation. Cost: $0.005/GB scanned. Performance: queries scan in parallel, typically complete in seconds.

---

### Card 16
**Q:** What are CloudWatch custom metrics and how do you publish them?
**A:** Custom metrics extend CloudWatch beyond built-in metrics. Publishing methods: (1) **PutMetricData API** – direct API call with namespace, metric name, dimensions, value, timestamp. (2) **CloudWatch Agent** – collect OS-level metrics (memory, disk, CPU per-core) and application logs. Installable via SSM. (3) **Embedded Metric Format** – emit metrics from Lambda/ECS via structured JSON in stdout. (4) **Metric filters** – extract metrics from log data (e.g., count error occurrences). Common custom metrics: memory utilization, disk usage, application latency, queue depth, business KPIs.

---

### Card 17
**Q:** What is the CloudWatch Agent and what metrics does it collect?
**A:** CloudWatch Agent collects OS-level and application metrics not available through default EC2 monitoring. Collects: (1) **Memory** – utilization, available, used. (2) **Disk** – space used/available/utilization per mount, IOPS. (3) **CPU** – per-core utilization, iowait, steal. (4) **Network** – packets, bytes per interface. (5) **Processes** – count, blocked, running. (6) **Custom application logs** – tailed from log files. Configuration: JSON config file (wizard available). Installable via SSM Distributor. Supports: Linux, Windows, on-premises servers. Unified agent replaces legacy CloudWatch Logs agent.

---

### Card 18
**Q:** What is AWS X-Ray and how does it enable distributed tracing?
**A:** X-Ray traces requests across microservices. Components: (1) **X-Ray SDK** – instruments application code (auto-instruments AWS SDK calls, HTTP calls, SQL queries). (2) **X-Ray Daemon** – listens on UDP port 2000, batches and sends trace data to X-Ray service. (3) **Service Map** – visual dependency graph of services. (4) **Traces** – end-to-end request path with timing. (5) **Segments/Subsegments** – each service/operation generates a segment. (6) **Annotations** – indexed key-value pairs for filtering. (7) **Metadata** – non-indexed data. (8) **Groups** – filter traces by annotation/URL. Integrates with: Lambda, API Gateway, ECS, EKS, EC2, Elastic Beanstalk.

---

### Card 19
**Q:** What is the difference between X-Ray traces, segments, and subsegments?
**A:** **Trace**: represents an end-to-end request journey across all services. Identified by a trace ID (propagated via headers). **Segment**: data generated by a single service for that trace. Contains: service name, request/response details, start/end time, status code, errors. **Subsegment**: more granular breakdown within a segment. Examples: downstream HTTP call, AWS SDK call, SQL query, custom logic block. Subsegments enable identifying exactly which operation within a service is slow. Annotations on segments/subsegments enable filtering traces by custom criteria.

---

### Card 20
**Q:** What is Amazon Managed Grafana?
**A:** Managed Grafana is a fully managed Grafana service for visualization and dashboards. Features: auto-scaling, HA, SSO via IAM Identity Center or SAML, data source plugins (CloudWatch, Prometheus, X-Ray, Timestream, Athena, Redshift, OpenSearch, many third-party). Workspace-based: each workspace is an isolated Grafana instance. Supports: alerting, dashboard sharing, organizations, teams. Use for: unified observability across AWS and third-party metrics, custom dashboards, correlating metrics from multiple sources. Pricing: per active user/month.

---

### Card 21
**Q:** What is Amazon Managed Service for Prometheus?
**A:** Managed Prometheus provides a Prometheus-compatible monitoring service. Features: fully managed (no cluster management), auto-scaling, multi-AZ HA, PromQL query support, 150-day default retention. Data collection: Prometheus remote write from self-managed Prometheus, AWS Distro for OpenTelemetry (ADOT) collector, or CloudWatch agent with Prometheus discovery. Works with EKS (native metric collection), ECS, and EC2. Query via Managed Grafana or any PromQL-compatible tool. Use for: container/Kubernetes metrics at scale.

---

### Card 22
**Q:** What are the four DR strategies and their cost/complexity trade-offs?
**A:** (1) **Backup & Restore**: Cost: lowest (storage only). Complexity: lowest. RPO: hours. RTO: hours. Best for: non-critical workloads. (2) **Pilot Light**: Cost: low (minimal running resources—database replica). Complexity: moderate. RPO: minutes. RTO: tens of minutes. Best for: core systems with moderate RTO tolerance. (3) **Warm Standby**: Cost: moderate (~10-50% of production). Complexity: higher. RPO: seconds. RTO: minutes. Best for: business-critical systems. (4) **Multi-Site Active/Active**: Cost: highest (~100% duplication). Complexity: highest. RPO: near-zero. RTO: near-zero. Best for: mission-critical, zero-tolerance.

---

### Card 23
**Q:** What is the difference between RPO and RTO?
**A:** **RPO (Recovery Point Objective)**: maximum acceptable data loss measured in time. How far back can you lose data? Example: RPO of 1 hour means you can tolerate losing up to 1 hour of data. Drives: backup frequency, replication strategy. **RTO (Recovery Time Objective)**: maximum acceptable downtime. How quickly must you recover? Example: RTO of 15 minutes means the system must be running within 15 minutes. Drives: infrastructure readiness, automation level. Lower RPO/RTO = higher cost. Always define both for each workload based on business impact.

---

### Card 24
**Q:** How do you implement a Pilot Light DR strategy on AWS?
**A:** Implementation: (1) Replicate database to DR region (Aurora Global Database, RDS cross-region read replica, or DynamoDB Global Tables). (2) Store AMIs/container images in DR region. (3) Store infrastructure templates (CloudFormation/CDK) in S3/CodeCommit. (4) On disaster: launch EC2/ECS from AMIs/templates, promote database replica to primary, update Route 53 to point to DR region. Automation: EventBridge rules detect failures, trigger Step Functions workflow that launches infrastructure. Key: database is the only always-running resource in DR region. Everything else launches on demand.

---

### Card 25
**Q:** How do you implement a Warm Standby DR strategy?
**A:** Implementation: (1) Full production stack running in DR region but at REDUCED capacity (e.g., minimum instance count, smaller instance types). (2) Database: Aurora Global Database or cross-region read replica (always in sync). (3) Auto Scaling groups at minimum capacity. (4) ALB/NLB running. (5) On disaster: scale up Auto Scaling (increase desired/max), promote database, update Route 53 (failover routing policy with health checks). (6) Consider: pre-warm ALBs, increase RDS instance size. Advantage over Pilot Light: faster RTO because infrastructure is already running.

---

### Card 26
**Q:** What is AWS Elastic Disaster Recovery (DRS)?
**A:** DRS provides continuous replication for DR. Features: (1) Agent-based, block-level replication from on-premises/cloud to AWS. (2) RPO: seconds (continuous replication). (3) RTO: minutes (launch recovery instances from latest replication state). (4) Point-in-time recovery (select specific recovery point). (5) Non-disruptive DR drills (test without affecting production). (6) Automated failover/failback. (7) Replication to staging area (low-cost instances/volumes). Process: install agent → continuous replication → test → failover (launch right-sized instances) → failback when primary recovers.

---

### Card 27
**Q:** What is Amazon Route 53 Application Recovery Controller (ARC)?
**A:** Route 53 ARC manages application recovery across AWS Regions and AZs. Components: (1) **Readiness check** – continuously monitors resource configuration and capacity in recovery environments. Verifies DR environment matches production (instance counts, capacity, configuration). (2) **Routing control** – simple on/off switches for traffic routing. Override Route 53 health checks to force failover or failback. (3) **Safety rules** – prevent dangerous actions (e.g., turning off both regions simultaneously). Use for: controlled, reliable failover with human-in-the-loop safety. Simpler than complex health check logic.

---

### Card 28
**Q:** What is AWS Backup and its advanced features?
**A:** AWS Backup centralizes backup management. Advanced features: (1) **Backup plans** – frequency (cron/rate), retention (days to years), lifecycle (cold storage after N days). (2) **Cross-region backup** – automatic copy to another region. (3) **Cross-account backup** – via Organizations. (4) **Backup Vault Lock** – WORM compliance mode (immutable backups). (5) **Backup Audit Manager** – compliance reporting (are backups running? Encrypted? Retained?). (6) **Backup policies** – Organization-level policies via AWS Organizations. (7) **Legal hold** – prevent backup deletion during investigations. Supports 15+ AWS services.

---

### Card 29
**Q:** What is AWS Fault Injection Service (FIS)?
**A:** FIS (formerly Fault Injection Simulator) runs chaos engineering experiments on AWS workloads. Features: (1) Pre-built experiment templates for common fault types. (2) Actions: stop/reboot/terminate EC2, inject CPU/memory/disk stress, throttle/error EBS I/O, disrupt network (latency, packet loss), failover RDS/ElastiCache, throttle API calls. (3) Targets: instances by tag, ASG, EKS pods, ECS tasks. (4) Stop conditions: CloudWatch alarm thresholds to auto-stop experiments. (5) IAM role-based access control. Use for: validating resilience, testing auto-scaling, verifying failover, identifying weaknesses before they cause outages.

---

### Card 30
**Q:** What is AWS CodePipeline?
**A:** CodePipeline is a managed CI/CD orchestration service. Components: (1) **Pipeline**: sequence of stages. (2) **Stages**: Source, Build, Test, Deploy, Approval (manual gate). (3) **Actions**: activities within stages. Source: CodeCommit, GitHub, S3, ECR. Build: CodeBuild, Jenkins. Test: CodeBuild, third-party. Deploy: CodeDeploy, CloudFormation, ECS, S3, Elastic Beanstalk, Service Catalog, AppConfig. Features: parallel actions within stages, cross-account/region actions, EventBridge integration, pipeline-level variables, manual approval with SNS notification.

---

### Card 31
**Q:** What is AWS CodeBuild?
**A:** CodeBuild is a managed build service. Features: compiles code, runs tests, produces artifacts. Uses **buildspec.yml** defining: phases (install, pre_build, build, post_build), artifacts (output), cache (dependencies), environment variables. Compute: managed (small/medium/large/2xlarge, ARM/x86, GPU), or custom Docker images. Supports: batch builds (parallel), build caching (S3 or local), VPC access (for private resources), test reports (JUnit, Cucumber), build badges. Pricing: per build-minute. Integrates with CodePipeline, EventBridge, and CloudWatch.

---

### Card 32
**Q:** What is AWS CodeDeploy and its deployment types?
**A:** CodeDeploy automates application deployment to EC2, Lambda, and ECS. Deployment types: (1) **In-place** (EC2/on-premises): updates existing instances. Supports: AllAtOnce, HalfAtATime, OneAtATime, custom (percentage/count). Uses appspec.yml with lifecycle hooks (BeforeInstall, AfterInstall, ApplicationStart, ValidateService). (2) **Blue/Green** (EC2): creates new instances, routes traffic, terminates old. (3) **Blue/Green** (ECS): creates new task set, routes ALB traffic, terminates old. (4) **Lambda**: Canary (10% for X minutes), Linear (10% every X minutes), AllAtOnce. Automatic rollback on CloudWatch alarm trigger.

---

### Card 33
**Q:** What is the difference between blue/green, canary, and rolling deployments?
**A:** **Blue/Green**: deploy new version to identical environment (green). Switch all traffic from old (blue) to green at once. Fast rollback (switch back). Cost: 2x infrastructure during deployment. **Canary**: route small percentage (e.g., 10%) to new version. Monitor. If OK, shift remaining traffic. Early detection of issues. **Rolling**: gradually update instances/tasks (batch by batch). Fewer resources needed than blue/green. Slower rollback (must re-deploy old version). **Rolling with additional batch**: add extra instances first, then roll (maintains full capacity). Each has different risk, cost, and speed characteristics.

---

### Card 34
**Q:** What are CodeDeploy lifecycle hooks?
**A:** Hooks are scripts that run at specific stages during deployment. EC2/on-premises in-place hooks (in order): `ApplicationStop` → `DownloadBundle` → `BeforeInstall` → `Install` → `AfterInstall` → `ApplicationStart` → `ValidateService`. **BeforeInstall**: back up current version, decrypt files. **AfterInstall**: configure app, set permissions. **ApplicationStart**: start services. **ValidateService**: run health checks. Each hook has a timeout (default 3,600 seconds). If a hook fails, deployment fails and can trigger automatic rollback. Defined in appspec.yml.

---

### Card 35
**Q:** What is AWS CodeCommit?
**A:** CodeCommit is a managed Git repository service. Features: fully managed, highly available, encrypted at rest (KMS) and in transit, unlimited repos, supports: Git HTTPS/SSH, branch/tag management, pull requests with approvals, code review comments, notifications (SNS, Lambda triggers), cross-account access via IAM roles. Integrates with CodePipeline, CodeBuild, CodeDeploy. Pricing: first 5 active users free, then $1/user/month. Note: CodeCommit is being phased out by AWS—new customers should consider GitHub, GitLab, or Bitbucket with CodePipeline integration.

---

### Card 36
**Q:** What are CloudFormation change sets?
**A:** Change sets preview the impact of template changes before applying them. Process: (1) Create change set with updated template. (2) Review changes: which resources will be added, modified, or replaced. (3) Execute change set to apply changes, or delete to cancel. Types of changes: **Add** (new resource), **Modify** (update in-place or with some interruption), **Remove** (delete resource), **Replace** (delete and recreate—data loss risk). Change sets help prevent accidental deletions or replacements. Can have multiple change sets for comparison. JSON/console view available.

---

### Card 37
**Q:** What is CloudFormation resource import?
**A:** Resource import brings existing AWS resources under CloudFormation management without recreating them. Process: (1) Add resource to template with `DeletionPolicy: Retain`. (2) Create change set of type IMPORT. (3) Provide resource identifier (e.g., bucket name, instance ID). (4) Execute import. Use for: adopting manually created resources, recovering from deleted stacks (resources retained via DeletionPolicy), reorganizing resources across stacks. Limitations: not all resource types support import, resource must not already be in another stack.

---

### Card 38
**Q:** What is the difference between CloudFormation nested stacks and cross-stack references?
**A:** **Nested stacks**: parent stack contains child stacks as resources (`AWS::CloudFormation::Stack`). Child stacks are managed by the parent. Lifecycle coupled—updating parent can update children. Best for: reusable component templates (VPC module, security group module). **Cross-stack references**: stacks export values (`Outputs.Export`), other stacks import them (`Fn::ImportValue`). Stacks are independent—lifecycle decoupled. Best for: sharing outputs between independently managed stacks (networking stack exports VPC ID, application stack imports it). Cannot delete exporting stack while imports exist.

---

### Card 39
**Q:** What is AWS CloudFormation Guard?
**A:** CloudFormation Guard (cfn-guard) is a policy-as-code tool that validates CloudFormation templates against rules. Write rules in a domain-specific language: e.g., `AWS::EC2::Instance { InstanceType IN ["t3.micro", "t3.small"] }`, `AWS::S3::Bucket { BucketEncryption EXISTS }`. Use for: pre-deployment compliance checks (enforce encryption, restrict instance types, require tags), CI/CD pipeline gates, organizational policy enforcement. Complements cfn-lint (syntax validation) with semantic/policy validation. Can be used in CodePipeline build steps.

---

### Card 40
**Q:** What is the CloudWatch Embedded Metric Format (EMF)?
**A:** EMF allows publishing custom metrics by writing structured JSON to stdout (no PutMetricData API calls needed). CloudWatch automatically extracts metrics from the structured log entries. Format: JSON with `_aws` namespace containing `Timestamp`, `CloudWatchMetrics` (namespace, dimensions, metrics). Benefits: zero-latency metric publishing, correlated logs and metrics (same log entry), batch multiple metrics, lower API costs. Available in Lambda natively (use aws-embedded-metrics library). Use for: high-volume custom metrics from Lambda, ECS, Kubernetes.

---

### Card 41
**Q:** What is CloudWatch Synthetics (Canaries)?
**A:** CloudWatch Synthetics creates canaries—configurable scripts that run on schedule to monitor endpoints and APIs. Written in Node.js or Python. Features: (1) Screenshot capture of web pages. (2) HAR file generation (HTTP archive). (3) Monitor availability, latency, broken links, DOM changes. (4) Visual monitoring (compare screenshots against baseline). (5) API canaries (test REST endpoints). Canaries run on Lambda. Schedule: once per minute up to once per hour. Alerts via CloudWatch Alarms on canary metrics. Use for: proactive monitoring of user-facing endpoints, SLA verification, pre-deployment smoke tests.

---

### Card 42
**Q:** What is CloudWatch ServiceLens?
**A:** ServiceLens provides end-to-end observability by combining CloudWatch metrics, logs, and X-Ray traces into a single view. Features: (1) Service map showing dependencies and health. (2) Correlated view: select a trace and see related logs and metrics. (3) Latency and error visualizations per service. (4) Integration with Container Insights for ECS/EKS. Use for: quickly identifying which service in a microservices architecture is causing issues, understanding service dependencies, correlating performance problems with specific traces and log entries.

---

### Card 43
**Q:** What is CloudWatch Container Insights?
**A:** Container Insights collects, aggregates, and summarizes metrics and logs from containerized applications. Supports: ECS, EKS, Kubernetes on EC2, Fargate. Metrics: CPU, memory, disk, network at cluster, service, task, pod, and container level. Features: pre-built dashboards, automatic metric collection, performance log events (JSON), integration with CloudWatch Logs Insights for querying. Enhanced observability with Prometheus metrics for EKS. Uses CloudWatch Agent or ADOT Collector. Additional cost: custom metrics pricing. Essential for container fleet monitoring.

---

### Card 44
**Q:** What is AWS CloudWatch Application Insights?
**A:** Application Insights automatically sets up monitoring for applications and their underlying AWS resources. It detects anomalies, diagnoses issues, and generates insights. Supports: .NET, SQL Server, IIS, and common application stacks. Process: select a resource group → Application Insights discovers components → auto-configures CloudWatch Alarms, metrics, log patterns → detects problems → generates insights dashboards. Reduces mean time to resolution (MTTR) by correlating symptoms across application layers. Integrates with OpsCenter for operational issue management.

---

### Card 45
**Q:** What is the difference between CloudWatch Events and Amazon EventBridge?
**A:** EventBridge is the evolution of CloudWatch Events. Same underlying infrastructure. **CloudWatch Events**: default event bus only, AWS service events and scheduled rules. **EventBridge additions**: custom event buses (application events), partner event buses (SaaS: Salesforce, Zendesk, Datadog), schema registry and discovery, archive and replay, Pipes (point-to-point), Scheduler (cron/rate), richer filtering (content-based, prefix, suffix, numeric). New features are EventBridge-only. AWS recommends using EventBridge for all new development. Existing CloudWatch Events rules continue to work.

---

### Card 46
**Q:** What are the key CI/CD patterns for the SA Pro exam?
**A:** Common patterns: (1) **Source → Build → Deploy**: CodeCommit → CodeBuild → CodeDeploy (to EC2). (2) **Container pipeline**: ECR push → CodeBuild (docker build/push) → CodeDeploy (ECS blue/green). (3) **Serverless pipeline**: CodeCommit → CodeBuild (SAM build) → CodeDeploy (Lambda canary/linear). (4) **Infrastructure pipeline**: CodeCommit → CodeBuild (cfn-lint, cfn-guard) → CloudFormation deploy. (5) **Multi-account**: pipeline in shared account, deploy to dev/staging/prod accounts via cross-account roles. (6) **Cross-region**: CodePipeline actions can target different regions.

---

### Card 47
**Q:** How do you implement a multi-account CI/CD pipeline?
**A:** Pattern: (1) **Tooling account** hosts CodePipeline, CodeBuild, artifact S3 bucket. (2) **Target accounts** (dev, staging, prod) have cross-account IAM roles. (3) Pipeline stages: Source (CodeCommit) → Build (CodeBuild) → Deploy Dev (CloudFormation with cross-account role) → Manual Approval → Deploy Staging → Manual Approval → Deploy Prod. (4) Artifact bucket policy allows target account access. (5) KMS key policy allows target accounts to decrypt artifacts. (6) Each deploy action assumes a role in the target account. Alternative: use separate pipelines per account triggered by artifact promotion.

---

### Card 48
**Q:** What is AWS CodeArtifact?
**A:** CodeArtifact is a managed artifact repository for software packages. Supports: npm, PyPI, Maven, NuGet, Swift, Cargo, generic. Features: upstream repository chaining (proxy through CodeArtifact to public registries—npm, PyPI, Maven Central), caching, fine-grained IAM access control, encryption, cross-account access, domain-based organization. Use for: centralized package management, security scanning of dependencies, controlling which packages developers can use, reducing external dependency on public registries, ensuring consistent package versions across teams.

---

### Card 49
**Q:** What deployment strategies does CodeDeploy support for ECS?
**A:** ECS deployments use blue/green only. Options: (1) **Canary**: ECSCanary10Percent5Minutes (10% for 5 min, then 100%). (2) **Linear**: ECSLinear10PercentEvery1Minute (shift 10% per minute). (3) **All-at-once**: ECSAllAtOnce (immediate 100% shift). Configuration via deployment group. Uses: ALB with two target groups (blue and green). Lifecycle hooks: BeforeInstall, AfterInstall, AfterAllowTestTraffic, BeforeAllowTraffic, AfterAllowTraffic. Automatic rollback: based on CloudWatch alarms. Test traffic: optional test listener port for validation before shifting production traffic.

---

### Card 50
**Q:** What is AWS AppConfig?
**A:** AppConfig is a feature of Systems Manager for deploying application configuration changes safely. Features: (1) Feature flags – enable/disable features without deployment. (2) Configuration profiles – managed JSON/YAML configs. (3) Validation – JSON schema or Lambda validator before deployment. (4) Deployment strategies – AllAtOnce, Linear, Canary. Monitor with CloudWatch alarms; auto-rollback on alarm. (5) Sources: SSM Parameter Store, SSM Documents, S3, or AppConfig hosted configuration. Use for: gradually rolling out configuration changes, feature toggles, operational tuning without code deploys.

---

### Card 51
**Q:** What is the difference between SSM Automation, Step Functions, and EventBridge for orchestration?
**A:** **SSM Automation**: operational runbooks for infrastructure management. Best for: EC2/resource management, patching, AMI building, remediation. Limited to SSM actions + Lambda. **Step Functions**: general-purpose workflow orchestration. Best for: application workflows, data processing pipelines, microservice orchestration. 220+ AWS service integrations. Visual workflow designer. **EventBridge**: event-driven routing and scheduling. Best for: decoupled event processing, routing events to multiple targets, cron scheduling. Choose SSM for ops automation, Step Functions for complex workflows, EventBridge for event routing.

---

### Card 52
**Q:** What are the key CloudWatch metrics to monitor for different AWS services?
**A:** **EC2**: CPUUtilization (built-in), MemoryUtilization (custom agent), NetworkIn/Out, StatusCheckFailed. **RDS**: CPUUtilization, FreeableMemory, DatabaseConnections, ReadIOPS/WriteIOPS, ReplicaLag. **ALB**: RequestCount, TargetResponseTime, HTTPCode_Target_5XX, HealthyHostCount. **Lambda**: Invocations, Duration, Errors, Throttles, ConcurrentExecutions, IteratorAge (for stream sources). **SQS**: ApproximateNumberOfMessagesVisible, ApproximateAgeOfOldestMessage. **DynamoDB**: ConsumedReadCapacityUnits, ThrottledRequests, SuccessfulRequestLatency. Monitor these for auto-scaling triggers and operational health.

---

### Card 53
**Q:** What is CloudWatch cross-account observability?
**A:** Cross-account observability allows a monitoring account to view and query CloudWatch data (metrics, logs, traces) from source accounts. Setup: (1) Designate a monitoring account (sink). (2) Configure source accounts to share data with the monitoring account (link). (3) Source accounts send data via OAM (Observability Access Manager) links. Features: query metrics/logs from source accounts in the monitoring account's console, create cross-account dashboards, use Logs Insights across accounts. Supports Organizations for easy multi-account setup. No data duplication—queries are live.

---

### Card 54
**Q:** What is AWS Resilience Hub?
**A:** Resilience Hub helps define, track, and manage application resilience posture. Features: (1) Define RPO/RTO targets per application. (2) Discover application components (CloudFormation, Terraform, EKS, or manual). (3) Assess resilience against targets. (4) Recommendations: identifies gaps and suggests improvements (add Multi-AZ, cross-region backup, etc.). (5) Track resilience score over time. (6) Operational recommendations: alarms and SOPs for recovery. (7) FIS experiment templates for testing. Integrates with CloudFormation and Terraform. Continuously monitors for drift from resilience policy.

---

### Card 55
**Q:** How do you implement automated rollback in a CI/CD pipeline?
**A:** Methods: (1) **CodeDeploy** – configure automatic rollback when CloudWatch alarm triggers or deployment fails. Reverts to last successful deployment. (2) **CloudFormation** – set `--rollback-on-failure` (default). Monitors stack events; rolls back if resource creation fails. (3) **CodePipeline** – manual approval gate + automated testing stage. If tests fail, pipeline stops (no rollback needed—changes not applied). (4) **ECS Blue/Green** – rollback by shifting traffic back to original task set. (5) **Lambda aliases** – CodeDeploy reverts alias to previous version. (6) **Feature flags** – disable feature via AppConfig without redeployment.

---

### Card 56
**Q:** What is the difference between horizontal and vertical scaling for databases?
**A:** **Vertical scaling** (scale up): increase instance class (e.g., db.r5.large → db.r5.2xlarge). Pros: simple, no application changes. Cons: downtime during resize (RDS), hard limits, single point of failure. **Horizontal scaling** (scale out): add read replicas (RDS/Aurora), sharding (DynamoDB), caching (ElastiCache). Pros: higher scalability, improved availability. Cons: eventual consistency for read replicas, application must handle routing. For writes: vertical scaling or sharding (DynamoDB, manual sharding for RDS). Aurora: scales reads to 15 replicas with 10ms lag.

---

### Card 57
**Q:** What are the caching strategies for improving application performance?
**A:** Caching layers: (1) **CDN** (CloudFront) – cache static/dynamic content at edge. (2) **API Gateway caching** – cache API responses. (3) **Application cache** (ElastiCache Redis/Memcached) – cache database queries, session data, computed results. (4) **Database cache** (DAX for DynamoDB, RDS query cache) – transparent caching layer. (5) **DNS caching** – Route 53 TTL settings. Strategy selection: cache frequently accessed, rarely changed data. Set appropriate TTL based on data freshness requirements. Implement cache invalidation (TTL, events, explicit invalidation). Monitor hit rates.

---

### Card 58
**Q:** What is Amazon ElastiCache Global Datastore?
**A:** Global Datastore provides cross-region Redis replication. One primary region (read-write) and up to two secondary regions (read-only). Replication lag: typically < 1 second. Failover: promote secondary to primary (manually or automated). Use for: geo-distributed applications needing low-latency cached reads globally, DR for cache layer. Works with Redis cluster mode enabled. Data is replicated at the cluster level. Cross-region data transfer charges apply. Alternative to: maintaining separate caches per region (which requires app-level cache synchronization).

---

### Card 59
**Q:** How do you implement a multi-region active-active architecture?
**A:** Components: (1) **DNS**: Route 53 with latency-based or geolocation routing. Health checks for failover. (2) **Compute**: identical infrastructure in each region (CloudFormation StackSets). (3) **Database**: DynamoDB Global Tables (multi-active), Aurora Global Database (one write region, sub-second replication), or S3 Cross-Region Replication. (4) **Caching**: ElastiCache Global Datastore. (5) **State management**: externalize session state to DynamoDB Global Tables. (6) **Conflict resolution**: last-writer-wins (DynamoDB), application-level merging, or CRDT patterns. Challenges: data consistency, conflict resolution, deployment coordination.

---

### Card 60
**Q:** What is Amazon Route 53 health check-based failover?
**A:** Implementation: (1) Create health checks for primary and DR endpoints. (2) Create failover routing policy: primary record (health check associated) and secondary record. (3) If primary health check fails → Route 53 automatically returns secondary record. Health check types: endpoint (HTTP/HTTPS/TCP), calculated (combine multiple), CloudWatch alarm-based. Configuration: request interval (10s or 30s), failure threshold (1-10), string matching, latency measurement. Cascade: health check on ALB → health check on Route 53 → failover to DR region. Consider TTL impact on client caching.

---

### Card 61
**Q:** What is AWS Backup Vault Lock?
**A:** Backup Vault Lock enforces WORM (Write Once Read Many) on backup vaults. Once locked in compliance mode, it cannot be changed or deleted—even by the root user. Features: (1) **Governance mode** – can be removed by users with sufficient permissions. (2) **Compliance mode** – cannot be removed by anyone once locked. Minimum retention and maximum retention enforced. 72-hour cooling-off period after enabling (to test). Use for: SEC 17a-4, HIPAA, regulatory requirements mandating immutable backups. Prevents: accidental or malicious backup deletion. Complements S3 Object Lock for broader data protection.

---

### Card 62
**Q:** What is the CloudFormation DeletionPolicy attribute?
**A:** DeletionPolicy controls what happens to a resource when it's removed from a stack or the stack is deleted. Options: (1) **Delete** (default for most) – resource is deleted. (2) **Retain** – resource is preserved (not deleted). (3) **Snapshot** – creates a final snapshot before deletion (supported for: EBS, RDS, Redshift, ElastiCache, Neptune, DocumentDB). Use Retain for: critical databases, S3 buckets with data. Use Snapshot for: databases that might need recovery. Always set DeletionPolicy on stateful resources to prevent accidental data loss during stack operations.

---

### Card 63
**Q:** What is CloudFormation UpdateReplacePolicy?
**A:** UpdateReplacePolicy controls what happens when a resource is replaced during a stack update (some property changes require replacement). Options: (1) **Delete** (default) – old resource deleted after new one created. (2) **Retain** – old resource preserved. (3) **Snapshot** – snapshot of old resource before deletion. This is different from DeletionPolicy (which applies to stack deletion). Use UpdateReplacePolicy to protect data when CloudFormation needs to replace a resource (e.g., changing RDS engine version that requires replacement). Always set on stateful resources.

---

### Card 64
**Q:** What is AWS Systems Manager Change Manager?
**A:** Change Manager provides a change management framework. Features: (1) Change templates – define what changes are allowed and approval workflows. (2) Change requests – request specific changes with justification. (3) Approval workflows – multi-level approvals with IAM/SSO integration. (4) Scheduling – plan changes during maintenance windows. (5) Automation – executes changes via SSM Automation documents. (6) Audit trail – full history in CloudTrail. (7) Integration with ServiceNow and Jira. Use for: production change control, compliance requirements for change approval, reducing unauthorized changes.

---

### Card 65
**Q:** What is AWS Systems Manager OpsCenter?
**A:** OpsCenter provides a central place to view, investigate, and resolve operational issues (OpsItems). Sources: CloudWatch Alarms, Config rule changes, EventBridge events, GuardDuty findings, Security Hub findings, manually created items. Each OpsItem contains: description, source, related resources, associated runbooks (SSM Automation documents), timeline. Features: aggregate OpsItems across accounts via Organizations, associate runbooks for remediation, track resolution status, operational metrics. Reduces context-switching by centralizing operational data.

---

### Card 66
**Q:** How do you optimize performance for a Lambda function?
**A:** Optimization techniques: (1) **Memory** – increase memory (also increases CPU proportionally). Use Power Tuning. (2) **Code** – minimize dependencies, use layers for shared code, lazy-load modules. (3) **Connection reuse** – initialize clients outside handler (reused across invocations). Keep-alive for HTTP connections. (4) **Package size** – smaller = faster cold start. Use Lambda layers. (5) **Runtime** – compiled languages (Rust, Go) have fastest cold starts. (6) **Provisioned concurrency** – eliminate cold starts. (7) **SnapStart** – for Java. (8) **ARM (Graviton)** – better price-performance. (9) **Avoid VPC** unless needed (VPC adds ENI setup time, mitigated with Hyperplane).

---

### Card 67
**Q:** What is the AWS Well-Architected Tool?
**A:** The Well-Architected Tool helps review workloads against the six Well-Architected pillars. Process: (1) Define workload (name, account, description, architecture). (2) Answer questions for each pillar (multiple choice). (3) Tool generates: improvement plan with prioritized recommendations, risk counts (high/medium), and notes. (4) Track improvements over time with milestones. (5) Generate reports. Features: custom lenses (industry-specific or organizational), integration with Trusted Advisor, sharing reviews across accounts. Lenses: Serverless, SaaS, Machine Learning, Data Analytics, IoT, and more.

---

### Card 68
**Q:** What is the difference between SSM Maintenance Windows and EventBridge Scheduler?
**A:** **SSM Maintenance Windows**: schedule SSM tasks (Run Command, Automation, Step Functions, Lambda) on registered targets (instances by tag/ID). Features: cron/rate scheduling, multi-task support, registered targets, execution history. Best for: infrastructure maintenance tasks (patching, snapshots, cleanup). **EventBridge Scheduler**: schedule invoking any of 270+ AWS service targets. Supports: one-time and recurring schedules, flexible time windows, dead-letter queues, retries. Best for: general-purpose scheduling of any AWS action. Use Maintenance Windows for SSM-specific tasks; EventBridge Scheduler for everything else.

---

### Card 69
**Q:** What is AWS CloudFormation Hooks?
**A:** CloudFormation Hooks are custom validation logic that runs before or during resource provisioning. Types: (1) Pre-create, pre-update, pre-delete hooks for resources. (2) Implemented as CloudFormation extensions (TypeScript/Python). Process: hook evaluates the resource properties → returns PASS or FAIL → if FAIL, provisioning is blocked or warned. Use for: enforce policies (all S3 buckets must be encrypted), validate naming conventions, check against external compliance systems. Similar to OPA/cfn-guard but executes within CloudFormation itself. More powerful than cfn-guard as hooks can call external APIs.

---

### Card 70
**Q:** What are the performance optimization strategies for Amazon RDS/Aurora?
**A:** Strategies: (1) **Read replicas** – offload read-heavy workloads (up to 15 for Aurora). (2) **Caching** – ElastiCache for frequently accessed data. (3) **Connection pooling** – RDS Proxy. (4) **Performance Insights** – identify slow queries, top SQL, wait events. (5) **Parameter tuning** – optimize DB parameter groups (buffer pool, query cache, connection limits). (6) **Instance right-sizing** – match instance to workload. (7) **Storage optimization** – use io2 for IOPS-heavy, gp3 for cost-effective. (8) **Query optimization** – indexes, EXPLAIN plans, avoid N+1 queries. (9) **Aurora Parallel Query** – distribute query processing across storage nodes.

---

### Card 71
**Q:** What is Amazon CloudWatch RUM (Real User Monitoring)?
**A:** CloudWatch RUM collects client-side performance data from real users of web applications. Metrics: page load time, JS errors, HTTP errors, user journeys, session data. Implementation: add JavaScript snippet to web application. Features: performance breakdown (DNS, TCP, TLS, TTFB, DOM), error tracking, user session replay, Apdex score, integration with X-Ray (connect client-side to server-side traces). Use for: understanding real user experience, identifying client-side bottlenecks, geographic performance variations, correlating client and server performance issues.

---

### Card 72
**Q:** What is AWS CloudFormation StackSets auto-deployment?
**A:** Auto-deployment automatically deploys StackSets to new accounts when they join an OU. Configuration: enable auto-deployment on the StackSet, specify target OUs. When a new account is created (via Control Tower or Organizations) and placed in a managed OU, the StackSet automatically deploys. Also supports: retain stacks when accounts leave OU or delete stacks. Use for: ensuring every new account gets: Config rules, CloudTrail, GuardDuty, security baselines, IAM roles, networking configuration. Key enabler for automated account governance at scale.

---

### Card 73
**Q:** How do you design a performant API with API Gateway and Lambda?
**A:** Design: (1) **Caching** (REST API) – reduce Lambda invocations. (2) **Regional endpoint** – lower latency for regional users. (3) **Lambda memory** – optimize for speed. (4) **Provisioned concurrency** – eliminate cold starts for critical APIs. (5) **Connection reuse** – keep SDK clients alive across invocations. (6) **API Gateway throttling** – protect backend. (7) **Async processing** – return 202, process via SQS/Step Functions for long operations. (8) **Response compression** – enable gzip. (9) **Use HTTP API** over REST API for lower latency (up to 60% lower). (10) **Payload optimization** – minimize response size. (11) **VPC endpoint** – avoid NAT for VPC Lambda.

---

### Card 74
**Q:** What is the AWS CDK Pipelines construct?
**A:** CDK Pipelines is an L3 construct that creates self-mutating CI/CD pipelines. The pipeline builds, tests, and deploys CDK applications. Self-mutating: when you change the pipeline definition in CDK code and push, the pipeline updates itself before deploying application changes. Features: stages (represent deployment targets), waves (parallel stages), pre/post actions (testing, approval), cross-account/region deployment. CodePipeline-based. Simplifies: setting up CI/CD for infrastructure code, multi-environment deployments, pipeline maintenance (no manual pipeline updates).

---

### Card 75
**Q:** What is the difference between EBS snapshots and AMIs for disaster recovery?
**A:** **EBS Snapshots**: point-in-time copy of EBS volumes stored in S3 (regionally). Incremental. Can be copied cross-region. Used to: restore individual volumes, create volumes in other AZs. **AMIs**: machine images containing: root volume snapshot + instance configuration (instance type, security groups, block device mappings). Can be copied cross-region. Used to: launch identical EC2 instances. For DR: copy AMIs cross-region to quickly launch instances. Copy snapshots for data volumes. AMIs are more complete; snapshots are more granular. Use both: AMIs for compute recovery, snapshots for data volumes.

---

### Card 76
**Q:** What is AWS Systems Manager Distributor?
**A:** Distributor is an SSM feature for distributing and installing software packages to managed instances. Features: AWS-provided packages (CloudWatch Agent, AWS Inspector Agent, CodeDeploy Agent) and custom packages. Packages contain: install/update/uninstall scripts, software binaries, version management. Integrates with State Manager to ensure software is always installed and up-to-date. Supports: Linux and Windows. Use for: distributing custom agents, installing/updating software fleet-wide, ensuring baseline software is always present. More efficient than custom scripts via Run Command.

---

### Card 77
**Q:** What is the recommended approach for managing secrets in CI/CD pipelines?
**A:** Best practices: (1) **Never store secrets in code** – use environment variables or secret managers. (2) **AWS Secrets Manager** – for database credentials, API keys. Automatic rotation. (3) **SSM Parameter Store (SecureString)** – for non-rotating config secrets. (4) **CodeBuild environment variables from Secrets Manager/Parameter Store** – reference in buildspec. (5) **KMS encryption** – encrypt artifacts and environment variables. (6) **IAM roles** – CodeBuild/CodeDeploy roles with least privilege. (7) **No secrets in CloudFormation parameters** – use `Dynamic References` (resolve at deploy time from SSM/Secrets Manager).

---

### Card 78
**Q:** What is the AWS Fault Injection Service experiment design process?
**A:** Design process: (1) **Define hypothesis** – "Our application handles AZ failure with < 5 min recovery." (2) **Select actions** – e.g., `aws:ec2:stop-instances`, `aws:rds:failover-db-cluster`, `aws:network:disrupt-connectivity`. (3) **Define targets** – instances/resources (by tags, ASG, percentage). (4) **Set stop conditions** – CloudWatch alarms that auto-stop the experiment if impact exceeds safe threshold. (5) **Set duration** – how long the fault lasts. (6) **Execute** – run during low-risk windows initially. (7) **Monitor** – observe application behavior. (8) **Analyze** – compare against hypothesis. (9) **Remediate** – fix gaps. (10) **Repeat** – build confidence.

---

### Card 79
**Q:** What is the CloudFormation wait condition and creation policy?
**A:** **WaitCondition** + **WaitConditionHandle**: pause stack creation until a signal is received (e.g., from cfn-signal on EC2 after application setup completes). Timeout configurable. **CreationPolicy**: similar but on specific resources (ASG, EC2). Defines: `ResourceSignal` with count and timeout. CloudFormation waits until N signals received. Use for: ensuring EC2 instances are fully configured (UserData completed) before CloudFormation marks them as CREATE_COMPLETE. Prevents dependent resources from being created before instances are ready. cfn-signal sends success/failure.

---

### Card 80
**Q:** What are the key performance metrics to monitor for web applications?
**A:** Key metrics by layer: **Frontend**: page load time, Time to First Byte (TTFB), First Contentful Paint, Core Web Vitals (LCP, FID, CLS) via CloudWatch RUM. **API**: request latency (p50, p95, p99), error rate (4xx, 5xx), request rate (TPS). **Application**: Lambda duration, ECS CPU/memory, connection pool utilization. **Database**: query latency, connection count, IOPS, replication lag, deadlocks. **Cache**: hit rate, evictions, memory utilization, connections. **Infrastructure**: CPU, memory, network I/O, disk I/O. Set alarms on p99 latency and error rates for SLO monitoring.

---

### Card 81
**Q:** What is Amazon DevOps Guru?
**A:** DevOps Guru uses ML to detect operational anomalies and provide automated recommendations. It analyzes: CloudWatch metrics, CloudTrail events, Config changes. Detects: anomalous behavior in applications, predicts potential issues. Provides: insights with root cause analysis, recommendations for remediation. Covers: Lambda, DynamoDB, RDS, EC2, ECS, EKS, and more. Proactive insights: predict issues before they impact customers. Reactive insights: identify root cause of ongoing issues. Integrates with OpsCenter, EventBridge, SNS. Per-resource-hour pricing.

---

### Card 82
**Q:** What is the difference between horizontal scaling with Auto Scaling and vertical scaling with instance type changes?
**A:** **Horizontal (Auto Scaling)**: add/remove instances based on demand. Benefits: high availability, fault tolerance, no downtime for scaling, theoretically unlimited. Requires: stateless applications, load balancer, health checks. Scaling speed: minutes (faster with warm pools). **Vertical (resize)**: change instance type. Benefits: simpler architecture, no application changes. Requires: stop/start (downtime for EBS-backed), or use newer instance types (some allow live migration). Limits: max instance type. For exam: horizontal scaling is almost always preferred unless application constraints prevent it.

---

### Card 83
**Q:** What is the AWS CDK Aspects feature?
**A:** CDK Aspects apply operations across all constructs in a scope (stack, app). Use the visitor pattern: aspect visits every construct and can inspect or modify it. Use cases: (1) **Tagging** – add tags to all resources automatically. (2) **Validation** – verify all S3 buckets have encryption. (3) **Compliance** – check all security groups don't allow 0.0.0.0/0. (4) **Modification** – add deletion protection to all databases. Example: `Aspects.of(stack).add(new Tag('Environment', 'prod'))`. Aspects run during synthesis. Powerful for enforcing organizational standards across CDK applications.

---

### Card 84
**Q:** What is AWS Service Catalog and how does it support continuous improvement?
**A:** Service Catalog enables continuous improvement by: (1) **Versioning** – products have versions; update the product and users get the latest approved version. (2) **Constraints** – enforce guardrails (instance types, regions). Update constraints as policies evolve. (3) **Portfolio sharing** – share across accounts/Organization. Central team updates, all accounts benefit. (4) **TagOptions** – enforce evolving tagging standards. (5) **Self-service provisioning** – developers don't need deep AWS knowledge. Platform team continuously improves underlying templates while maintaining simple interface. Enables platform engineering best practices.

---

### Card 85
**Q:** What is the process for implementing a DR drill?
**A:** DR drill process: (1) **Plan** – define scope (which applications), success criteria (RPO/RTO met), participants, communication plan. (2) **Prepare** – verify replication status, check target region capacity, review runbooks. (3) **Execute** – use Elastic Disaster Recovery for server failover, or Route 53 ARC routing controls, or manual runbook steps. (4) **Validate** – verify applications are functional, test data integrity, confirm RPO/RTO metrics. (5) **Failback** – return to primary region. (6) **Document** – record findings, update runbooks, track improvements. (7) **Schedule** – regular drills (quarterly minimum). Use FIS for additional chaos testing.

---

### Card 86
**Q:** What is the difference between CloudFormation and Terraform on AWS?
**A:** **CloudFormation**: AWS-native, JSON/YAML, supports all AWS resources (usually day-one), StackSets for multi-account, drift detection, change sets, resource import, deep AWS integration (Service Catalog, Control Tower, Proton). **Terraform**: multi-cloud, HCL language, state file management, open-source with rich module ecosystem, plan command (like change sets), supports non-AWS resources, community providers. For exam: CloudFormation is the default answer unless multi-cloud or non-AWS resources are mentioned. Both are valid IaC tools. CDK can synthesize to CloudFormation or Terraform.

---

### Card 87
**Q:** What is the Amazon CloudWatch Contributor Insights?
**A:** Contributor Insights analyzes time-series data to identify top contributors. Creates rules from CloudWatch Logs that extract fields and count/aggregate occurrences. Examples: top 10 IP addresses hitting your API, top 10 most accessed URLs, top 10 accounts generating most errors. Rules: define log group, log format, fields to extract, aggregation method. Generates: top-N report, time-series visualization. Integrates with CloudWatch Dashboards and Alarms. Use for: identifying heavy users, finding noisy neighbors, troubleshooting by identifying patterns in log data.

---

### Card 88
**Q:** What is the recommended approach for database schema changes in CI/CD?
**A:** Best practices: (1) **Version control** – store migration scripts in source control. (2) **Forward-only migrations** – don't modify existing migrations; add new ones. (3) **Tools**: Flyway, Liquibase, Django migrations, Rails migrations, Prisma migrate. (4) **Blue/green for databases** – AWS RDS Blue/Green deployments: create green copy, apply schema changes, test, switch. (5) **Backward-compatible changes** – new schema should work with old AND new application code (expand/contract pattern). (6) **Run in CodeBuild** – execute migration scripts in build phase with RDS Proxy/VPC access. (7) **RDS Blue/Green Deployments** – managed schema migration with switchover.

---

### Card 89
**Q:** What is Amazon RDS Blue/Green Deployments?
**A:** RDS Blue/Green Deployments create a staging environment (green) that mirrors production (blue) using logical replication. Process: (1) Create blue/green deployment (copies DB, replication starts). (2) Apply changes to green: schema changes, parameter changes, engine upgrades, instance resizing. (3) Test green thoroughly. (4) Switchover: green becomes production, blue becomes old. Switchover typically < 1 minute downtime. Automatic safeguards: switchover blocked if replication lag is too high. Supports: RDS MySQL, MariaDB, PostgreSQL. Simplifies major version upgrades and schema changes.

---

### Card 90
**Q:** What is the AWS Well-Architected Reliability pillar's approach to testing reliability?
**A:** Testing approach: (1) **Playbooks** – predefined procedures for investigating issues. Store in SSM documents. (2) **Game days** – simulated failure events with real team response. (3) **Chaos engineering** – use FIS to inject faults. Start small (single instance), increase scope. (4) **Load testing** – verify capacity under expected and peak load. (5) **Failure mode analysis** – identify what can fail, likelihood, impact. (6) **DR testing** – regular DR drills to validate RPO/RTO. (7) **Canary deployments** – test in production with small traffic. Key principle: test failure regularly to build confidence in recovery procedures.

---

### Card 91
**Q:** What is AWS Config remediation?
**A:** Config remediation automatically or manually fixes non-compliant resources. Two types: (1) **Automatic remediation**: triggers SSM Automation document when a resource is non-compliant. Example: if S3 bucket public access detected → automatically enable Block Public Access. (2) **Manual remediation**: admin reviews non-compliance and triggers remediation document. Retry configuration: max automatic retries (1-25), retry interval. Common remediation actions: enable encryption, add required tags, restrict security groups, enable logging. Uses SSM Automation documents (AWS-provided or custom).

---

### Card 92
**Q:** What is the recommended CI/CD architecture for serverless applications?
**A:** Architecture: (1) **Source**: CodeCommit/GitHub. (2) **Build**: CodeBuild with SAM CLI (`sam build`, `sam package`). (3) **Test**: CodeBuild runs unit tests, integration tests against local emulation. (4) **Deploy Dev**: CodeDeploy/SAM deploy to dev account (AllAtOnce). (5) **Integration tests**: automated tests against deployed dev environment. (6) **Deploy Staging**: SAM deploy to staging with canary deployment (10% for 10 min). (7) **Approval**: manual gate. (8) **Deploy Prod**: CodeDeploy with canary/linear deployment + CloudWatch alarms for auto-rollback. Use SAM Accelerate for faster local development iteration.

---

### Card 93
**Q:** What is CloudWatch Metric Streams?
**A:** Metric Streams provides near-real-time stream of CloudWatch metrics to third-party destinations. Destinations: Kinesis Data Firehose → S3, Datadog, Dynatrace, New Relic, Splunk, Sumo Logic. Formats: JSON or OpenTelemetry 0.7.0. Configuration: stream all metrics or filter by namespace. Use for: sending AWS metrics to third-party monitoring tools without polling CloudWatch API (more efficient, lower latency, no API rate limits). Pricing: per metric update streamed ($0.003/1,000 metric updates).

---

### Card 94
**Q:** How do you implement infrastructure testing in a CI/CD pipeline?
**A:** Testing layers: (1) **Static analysis**: cfn-lint (CloudFormation syntax), cfn-guard (policy validation), CDK `Aspects` (programmatic validation), tflint (Terraform). (2) **Unit tests**: CDK assertions library (test synthesized CloudFormation), Terraform `plan` + validation. (3) **Integration tests**: deploy to test environment, run tests against actual resources, validate connectivity/access. (4) **Security scanning**: cfn_nag, checkov, Bridgecrew for security misconfigurations. (5) **Compliance**: AWS Config rules post-deployment. Pipeline: lint → security scan → unit test → deploy test env → integration test → deploy staging → deploy prod.

---

### Card 95
**Q:** What is the difference between RTO and actual recovery time, and how do you minimize the gap?
**A:** **RTO** is the target maximum acceptable downtime. **Actual recovery time** depends on: detection speed, human decision time, execution time. Minimize the gap: (1) **Automated detection** – CloudWatch Alarms, health checks, Route 53 health checks. (2) **Automated response** – EventBridge + Lambda/SSM Automation. (3) **Pre-provisioned infrastructure** – warm standby instead of pilot light. (4) **Runbook automation** – SSM Automation documents instead of manual steps. (5) **Regular DR drills** – practice reduces execution time. (6) **Route 53 ARC routing controls** – one-click failover. (7) **Elastic Disaster Recovery** – automated server failover. Each level of automation reduces the gap.

---

### Card 96
**Q:** What is the AWS Distro for OpenTelemetry (ADOT)?
**A:** ADOT is an AWS-supported distribution of OpenTelemetry for collecting metrics and traces. Components: ADOT Collector (receives, processes, exports telemetry data). Supports: sending traces to X-Ray, metrics to CloudWatch/Managed Prometheus, and third-party backends. Integrates with: Lambda (layer), ECS, EKS, EC2. Benefits over X-Ray SDK alone: vendor-neutral instrumentation (OpenTelemetry standard), send to multiple backends simultaneously, support for non-AWS monitoring tools. Recommended for new applications wanting observability portability.

---

### Card 97
**Q:** What is the recommended approach for managing multiple AWS environments (dev/staging/prod)?
**A:** Best practices: (1) **Separate accounts** per environment (Organizations). (2) **Infrastructure as Code** – same templates across environments with environment-specific parameters. (3) **CI/CD pipeline** – promotes artifacts through environments with gates. (4) **SSM Parameter Store** – environment-specific config per account. (5) **Tagging** – Environment tag on all resources. (6) **SCPs** – restrict prod account (no direct console changes). (7) **Budget alerts** – per environment. (8) **Instance Scheduler** – stop non-prod nights/weekends. (9) **Smaller instances** in non-prod. (10) **Feature flags** – AppConfig for environment-specific behavior.

---

### Card 98
**Q:** What is AWS Config Advanced Query?
**A:** Config Advanced Query allows SQL-like queries across your AWS resource configurations. Uses a structured query language to query the current configuration state. Examples: `SELECT resourceId, configuration.instanceType WHERE resourceType = 'AWS::EC2::Instance'`. Supports: single-account or aggregator (multi-account/region) queries. Use for: inventory queries (find all unencrypted volumes), compliance checks (find public security groups), resource reporting (count resources by type/region). Queries current state only (not historical). More flexible than standard Config resource listing.

---

### Card 99
**Q:** What is the deployment strategy for critical infrastructure changes?
**A:** Strategy: (1) **Change set review** – CloudFormation change sets for preview. (2) **Staged rollout** – deploy to dev → staging → one prod region → all prod regions. (3) **Canary testing** – weighted Route 53 routing to send small traffic to new infrastructure. (4) **Rollback plan** – CloudFormation rollback, Route 53 failover, blue/green switch-back. (5) **Change window** – schedule during low-traffic period. (6) **SSM Change Manager** – approval workflow. (7) **Monitoring** – enhanced monitoring during and after change. (8) **Communication** – notify stakeholders. (9) **Post-change validation** – automated smoke tests. (10) **Document** – update runbooks and architecture.

---

### Card 100
**Q:** What is AWS CloudFormation registry and private extensions?
**A:** CloudFormation registry is a catalog of extensions: resource types, modules, and hooks. **Public extensions**: AWS and third-party published extensions (MongoDB Atlas, Datadog, PagerDuty resources). **Private extensions**: custom resource types you develop and register. Build with CloudFormation CLI in TypeScript, Java, or Python. Define: schema (properties, required, read-only), handlers (create, read, update, delete, list). Once registered, use like native CloudFormation resources. Benefits over custom resources (Lambda): full lifecycle management, drift detection, type-safe schema, testing framework.

---

### Card 101
**Q:** What is the recommended monitoring strategy for a microservices architecture?
**A:** Strategy: (1) **Distributed tracing** – X-Ray or ADOT to trace requests across services. (2) **Service map** – X-Ray/ServiceLens for dependency visualization. (3) **Centralized logging** – CloudWatch Logs with correlation IDs across services. (4) **Metrics per service** – latency, error rate, request rate (RED method) or Rate/Errors/Duration. (5) **Synthetic monitoring** – CloudWatch Canaries for critical paths. (6) **RUM** – CloudWatch RUM for end-user experience. (7) **Dashboards** – Grafana for unified view. (8) **Alerting** – composite alarms to reduce noise. (9) **Anomaly detection** – CloudWatch ML-based anomalies. (10) **Automated response** – EventBridge + Lambda for self-healing.

---

### Card 102
**Q:** What is the difference between proactive and reactive scaling?
**A:** **Reactive scaling**: responds to current demand. Target tracking (maintain CPU at 50%), step scaling (add instances when alarm triggers). Lag: 2-5 minutes to detect + launch instances. Handles: gradual load increases. Problem: can't handle sudden spikes fast enough. **Proactive scaling**: anticipates demand. Predictive scaling (ML-based, predicts from historical patterns), scheduled scaling (known events like product launches), warm pools (pre-initialized instances). Use together: proactive as baseline + reactive for unexpected spikes. Predictive scaling needs 14 days of history to train.

---

### Card 103
**Q:** What is the AWS Cloud Map?
**A:** Cloud Map is a service discovery service. Register service instances with attributes. Clients discover services via: (1) **DNS** – Cloud Map creates Route 53 records (A, SRV, CNAME). Instances register/deregister automatically. (2) **API** – DiscoverInstances API for more flexible discovery (attribute-based filtering). Health checks: Route 53 health checks or custom (via API). Integrates with: ECS (automatic registration/deregistration), EKS, Lambda. Use for: microservice discovery without hardcoded endpoints, replacing manual DNS management, service-to-service communication in container architectures.

---

### Card 104
**Q:** What is the approach for implementing GitOps on AWS?
**A:** GitOps principles: infrastructure and application state stored in Git, changes via pull requests, automated reconciliation. AWS implementation: (1) **Flux CD/ArgoCD on EKS** – GitOps controllers that sync Kubernetes manifests from Git. (2) **CDK Pipelines** – self-mutating pipelines from CDK code in Git. (3) **CodePipeline + CloudFormation** – deploy infrastructure changes on Git push. (4) **AFT (Account Factory for Terraform)** – GitOps for account provisioning. (5) **EKS Blueprints** – GitOps-based cluster configuration. Key: Git is the single source of truth for all infrastructure state.

---

### Card 105
**Q:** What is the recommended approach for performance testing an AWS architecture?
**A:** Approach: (1) **Baseline** – measure current performance under normal load. (2) **Load testing** – simulate expected peak load (tools: Locust, k6, Gatling on EC2/Fargate). (3) **Stress testing** – find breaking points beyond peak load. (4) **Endurance testing** – sustained load over hours/days to find memory leaks, connection exhaustion. (5) **Spike testing** – sudden traffic bursts. (6) **Monitor**: CloudWatch metrics, X-Ray traces, database performance. (7) **Identify bottlenecks**: check each tier (CDN, LB, compute, database, network). (8) **Optimize and re-test**. Consider: pre-warm ALBs for large expected traffic, Auto Scaling behavior under load, DynamoDB auto-scaling reaction time.

---

### Card 106
**Q:** What is AWS Systems Manager Inventory?
**A:** SSM Inventory collects metadata about managed instances: installed applications, AWS components (CLI, agents), files, network configurations, Windows updates, services, Windows registry, custom inventory. Collection: scheduled (every 30 min, hourly, daily). Data stored in SSM and can be synced to S3 for analysis. Query with: Systems Manager Inventory dashboard, Advanced Insights (Athena queries), Config advanced queries. Use for: software asset management, compliance verification (is antivirus installed?), vulnerability assessment (which instances run specific software versions?), license tracking.

---

### Card 107
**Q:** What is the difference between active-passive and active-active DR?
**A:** **Active-Passive**: one region handles all traffic (active), second region is standby (passive—pilot light or warm standby). On failure: promote passive, redirect traffic. Simpler, cheaper. Challenges: RTO depends on standby readiness. **Active-Active**: both regions handle traffic simultaneously. Route 53 distributes requests. Databases replicated bi-directionally (DynamoDB Global Tables). Near-zero RTO/RPO. Challenges: data consistency, conflict resolution, write routing, higher cost (2x infrastructure). For exam: active-passive is usually sufficient unless RTO/RPO requirements demand near-zero.

---

### Card 108
**Q:** What are CloudFormation stack policies?
**A:** Stack policies are JSON documents that control which resources can be updated during a stack update. By default: all resources can be updated. With a stack policy: explicitly allow/deny updates to specific resources. Example: deny updates to production RDS instance. Actions: Update:Modify, Update:Replace, Update:Delete, Update:*. Principal: always "*". Can be temporarily overridden during specific updates. Use for: protecting critical resources (databases, encryption keys) from accidental updates. Once set, cannot be removed (but can be modified). Different from DeletionPolicy (which protects during deletion).

---

### Card 109
**Q:** What is the recommended logging and auditing strategy for AWS workloads?
**A:** Strategy: (1) **CloudTrail** – API call logging (organization trail to central S3). (2) **VPC Flow Logs** – network traffic metadata. (3) **CloudWatch Logs** – application logs (via agent). (4) **S3 access logs** – bucket-level access logging. (5) **ELB access logs** – request-level logs to S3. (6) **RDS audit logs** – database activity (CloudWatch export). (7) **WAF logs** – web request details. (8) **GuardDuty** – threat detection findings. Centralize: all logs to a dedicated logging account. Protect: S3 Object Lock, Glacier Vault Lock. Analyze: Athena, OpenSearch, CloudWatch Insights. Alert: EventBridge + SNS.

---

### Card 110
**Q:** What is the difference between AWS Config rules and CloudWatch alarms for continuous monitoring?
**A:** **Config rules**: evaluate RESOURCE CONFIGURATIONS. Triggered by: configuration changes or periodic schedule. Check: is the resource compliant with the rule? (e.g., is EBS encrypted? Is S3 public?). Remediation: SSM Automation. Focus: compliance and configuration drift. **CloudWatch alarms**: evaluate METRICS over time. Triggered by: metric threshold breach or anomaly. Check: is the metric within acceptable range? (e.g., CPU > 80%, error rate > 5%). Actions: SNS, Auto Scaling, EC2 actions. Focus: operational performance. Use both: Config for compliance, CloudWatch for operational health.
