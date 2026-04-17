# Monitoring & Management Flashcards

## AWS Solutions Architect Associate (SAA-C03) — Deck 8 of 9

---

### Card 1
**Q:** What are the core components of Amazon CloudWatch?
**A:** **Metrics** – time-series data points from AWS services and custom sources (CPU, network, request counts). **Alarms** – watch a metric and trigger actions when thresholds are breached (SNS, Auto Scaling, EC2 actions). **Logs** – collect, store, and analyze log data from services, applications, and on-premises. **Dashboards** – customizable visualizations of metrics and logs. **Events/EventBridge** – respond to state changes. **Insights** – Container Insights, Lambda Insights, Application Insights, Contributor Insights for deep analysis.

---

### Card 2
**Q:** What is the difference between standard and detailed monitoring for EC2?
**A:** **Basic (standard) monitoring** – free, metrics sent every **5 minutes**. **Detailed monitoring** – costs extra, metrics sent every **1 minute**. Detailed monitoring is required for ASG scaling policies that need faster reaction times. Note: EC2 memory and disk utilization are NOT built-in metrics — you must install the **CloudWatch Agent** to collect them. Default metrics include CPU, network, disk I/O, and status checks.

---

### Card 3
**Q:** What custom metrics can you send to CloudWatch?
**A:** Any metric your application produces can be sent via the `PutMetricData` API. Common custom metrics: memory utilization, disk space, application-level metrics (request latency, error rates, queue depth). Resolution: **Standard** (1-minute granularity) or **High Resolution** (down to 1-second granularity, costs more). You can add **dimensions** to segment metrics (e.g., per instance, per environment). Use the CloudWatch Agent to collect system-level metrics (memory, disk) automatically.

---

### Card 4
**Q:** What is the CloudWatch Agent?
**A:** The CloudWatch Agent is installed on EC2 instances or on-premises servers to collect: **system-level metrics** (memory, disk, swap, netstat, processes) and **logs** (application logs, system logs). Configured via a JSON configuration file. Uses IAM role (EC2) or IAM user (on-premises) for permissions. Supports both Linux and Windows. Stored in SSM Parameter Store for centralized configuration management. Required for metrics not available by default (memory, disk utilization). Can collect custom StatsD and collectd metrics.

---

### Card 5
**Q:** What are CloudWatch Alarms and their states?
**A:** CloudWatch Alarms monitor a single metric over a time period and trigger actions. Three states: **OK** – metric is within the threshold. **ALARM** – metric has breached the threshold. **INSUFFICIENT_DATA** – not enough data to determine state. Actions: **SNS notification**, **Auto Scaling action** (scale out/in), **EC2 action** (stop, terminate, reboot, recover). Evaluation: you configure a **period** (seconds), **evaluation periods** (number of data points), and **datapoints to alarm** (how many must breach). **Composite alarms** combine multiple alarms with AND/OR logic.

---

### Card 6
**Q:** What is the difference between CloudWatch Alarms and EventBridge?
**A:** **CloudWatch Alarms** – watch a single metric; trigger when a numeric threshold is crossed; actions limited to SNS, ASG, EC2. **EventBridge** – responds to events (state changes, scheduled triggers, custom events); event-driven; routes to 18+ target types (Lambda, SQS, Step Functions, etc.); supports complex event filtering; event patterns match on JSON fields. Use Alarms for metric-based thresholds. Use EventBridge for event-driven architecture and service integration.

---

### Card 7
**Q:** What is CloudWatch Logs and its key concepts?
**A:** CloudWatch Logs stores and manages log data. **Log Groups** – a collection of log streams sharing the same settings (retention, encryption). **Log Streams** – a sequence of log events from the same source (e.g., one per instance). **Retention** – configurable from 1 day to 10 years, or never expire (default). **Metric Filters** – extract metric data from log events (e.g., count ERROR occurrences). **Subscription Filters** – send log data in real-time to Kinesis, Lambda, or Firehose. **Log Insights** – interactive SQL-like query language for analyzing logs.

---

### Card 8
**Q:** What is CloudWatch Logs Insights?
**A:** CloudWatch Logs Insights is a query engine for interactively searching and analyzing log data using a purpose-built query language. Automatically discovers fields from JSON logs and common formats. Supports: filtering, aggregation, sorting, statistical functions, time-series visualization, and joining multiple log groups. Queries run across specified time ranges. You pay per GB of data scanned. Use for: troubleshooting, finding error patterns, analyzing request latency, identifying trends. More powerful than metric filters for ad-hoc analysis.

---

### Card 9
**Q:** What is a CloudWatch Metric Filter?
**A:** A Metric Filter extracts metric values from log data in CloudWatch Logs. You define a **filter pattern** (text or JSON pattern to match) and a **metric transformation** (what metric value to publish when the pattern matches). Example: count the number of "ERROR" occurrences → publish as a custom metric → create an alarm on that metric → send SNS notification. Metric Filters only process new log events after creation (not retroactive). They create custom metrics at no additional charge for the filter itself.

---

### Card 10
**Q:** What is CloudWatch Subscription Filter?
**A:** Subscription Filters deliver log events in real-time from CloudWatch Logs to a destination. Destinations: **Kinesis Data Streams** (real-time processing), **Kinesis Data Firehose** (near-real-time delivery to S3/Redshift/OpenSearch), **Lambda** (custom processing). You can have up to **2 subscription filters** per log group. For cross-account log sharing, use a subscription filter to send to Kinesis in a central account. Use for: real-time log analysis, log centralization, streaming to SIEM.

---

### Card 11
**Q:** How do you export CloudWatch Logs to S3?
**A:** Two methods: 1) **CreateExportTask** API – batch export of logs to S3. Not real-time (can take up to 12 hours). The S3 bucket must have a specific bucket policy. Can export a specific time range. 2) **Subscription Filter** → Kinesis Data Firehose → S3 – near-real-time streaming (preferred for continuous export). The Firehose approach is better for ongoing log archival. The export task is better for one-time historical exports. You cannot directly stream CloudWatch Logs to S3 without Firehose.

---

### Card 12
**Q:** What is AWS CloudTrail?
**A:** CloudTrail records API activity across your AWS account. Every API call is logged as an **event**. Event types: **Management events** (control plane operations — create/delete/modify resources; logged by default), **Data events** (data plane operations — S3 GetObject, Lambda Invoke; NOT logged by default, higher volume), **Insights events** (detect unusual activity). Trails deliver events to S3 and optionally CloudWatch Logs. Events are delivered within **15 minutes**. Enabled by default for management events with 90-day history in the console.

---

### Card 13
**Q:** What is the difference between CloudTrail management events and data events?
**A:** **Management events** – operations that manage AWS resources: `CreateBucket`, `RunInstances`, `CreateUser`, `AttachPolicy`. Logged by default. High importance, lower volume. Also called "control plane" events. **Data events** – operations on data within resources: `s3:GetObject`, `s3:PutObject`, `lambda:Invoke`, `dynamodb:GetItem`. NOT logged by default (must be explicitly enabled per trail/event data store). High volume, higher cost. Enable data events only for resources you need to audit.

---

### Card 14
**Q:** What is CloudTrail Insights?
**A:** CloudTrail Insights detects **unusual API activity** in your account by continuously analyzing management events. It establishes a baseline of normal activity, then flags anomalies — such as a spike in `TerminateInstances` calls, burst of `AuthorizeSecurityGroupIngress`, or unusual resource provisioning. Insights events are generated and delivered to your trail's S3 bucket and optionally to CloudWatch Events/EventBridge for automated response. Helps detect: account compromise, misconfigured automation, accidental mass operations.

---

### Card 15
**Q:** What is the difference between CloudTrail and AWS Config?
**A:** **CloudTrail** – records **who** did **what** and **when** (API calls). Answers: "Who terminated this instance? When was this bucket created?" **Config** – records **what** the resource configuration looks like over time and evaluates compliance. Answers: "What was the security group configuration last Tuesday? Is this S3 bucket encrypted?" CloudTrail = API activity audit trail. Config = resource configuration history and compliance. Together they provide a complete picture: who changed it (CloudTrail) + what changed (Config).

---

### Card 16
**Q:** What is AWS Config?
**A:** AWS Config continuously records and evaluates the configuration of your AWS resources. Key features: **Configuration recorder** – tracks resource configuration changes. **Config Rules** – evaluate configurations against desired settings (managed or custom rules). **Remediation** – automatic remediation using SSM Automation documents. **Configuration timeline** – see how a resource changed over time. **Aggregator** – multi-account/region view. **Conformance Packs** – collection of Config rules and remediation actions deployed as a single entity. Config is regional but can aggregate across regions/accounts.

---

### Card 17
**Q:** What are AWS Config Rules?
**A:** Config Rules evaluate whether resource configurations comply with desired settings. **AWS Managed Rules** – pre-built rules (e.g., `s3-bucket-versioning-enabled`, `ec2-instance-no-public-ip`, `rds-instance-public-access-check`). Over 300+ available. **Custom Rules** – you write Lambda functions to evaluate compliance. Rules can be triggered: **on configuration change** (when a resource changes) or **periodic** (every 1, 3, 6, 12, or 24 hours). Rules evaluate as COMPLIANT or NON_COMPLIANT. Non-compliant resources can trigger auto-remediation.

---

### Card 18
**Q:** How does AWS Config remediation work?
**A:** Config Rules can trigger **automatic remediation** using **SSM Automation documents** when a resource is found non-compliant. You select a managed or custom automation document and map parameters. Example: if `s3-bucket-public-write-prohibited` rule finds a non-compliant bucket, remediation runs an SSM Automation to remove the public access. **Remediation retries** can be configured (up to 5 attempts). For manual approval, use SSM Automation with an approval step. Remediation can also be set to manual (one-click in console).

---

### Card 19
**Q:** What is an AWS Config Aggregator?
**A:** A Config Aggregator collects configuration and compliance data from multiple accounts and regions into a single account. Set up: create an aggregator in a central account and authorize source accounts (or use Organizations for automatic authorization). The aggregated view shows: total compliant/non-compliant resources, non-compliant rules, and resource inventory across all accounts and regions. Does not copy actual Config data — it provides a read-only view. Used for centralized compliance monitoring.

---

### Card 20
**Q:** What is an AWS Config Conformance Pack?
**A:** A Conformance Pack is a collection of Config Rules and remediation actions packaged as a YAML template. Deployed as a single unit across an account or organization. AWS provides sample packs for common standards: CIS, PCI DSS, HIPAA, NIST. You can create custom packs. Benefits: consistent compliance posture across accounts, version-controlled, easy to deploy via Organizations. Conformance Pack generates a compliance score. Different from Config Rules (individual) — Conformance Packs bundle related rules together.

---

### Card 21
**Q:** What is AWS Trusted Advisor?
**A:** Trusted Advisor inspects your AWS environment and provides recommendations across **five categories**: **Cost Optimization** (unused resources, RI optimization), **Performance** (over/under-provisioned resources), **Security** (open security groups, IAM usage, MFA on root), **Fault Tolerance** (EBS snapshots, Multi-AZ, backups), **Service Limits** (approaching limits). **Basic/Developer** plans: 7 core checks (mostly security). **Business/Enterprise** plans: full checks, CloudWatch alarms, programmatic access via API. Checks are refreshed periodically or manually.

---

### Card 22
**Q:** What are the 7 core Trusted Advisor checks available to all accounts?
**A:** 1) **S3 Bucket Permissions** – buckets with open access. 2) **Security Groups – Specific Ports Unrestricted** – ports 22 (SSH), 3389 (RDP), etc. open to 0.0.0.0/0. 3) **IAM Use** – at least one IAM user exists. 4) **MFA on Root Account** – MFA enabled on root. 5) **EBS Public Snapshots** – publicly shared EBS snapshots. 6) **RDS Public Snapshots** – publicly shared RDS snapshots. 7) **Service Limits** – resources approaching limits (80%). Business/Enterprise plans unlock 100+ additional checks.

---

### Card 23
**Q:** What is AWS CloudFormation?
**A:** CloudFormation is an Infrastructure as Code (IaC) service that provisions AWS resources using declarative templates (JSON/YAML). Key concepts: **Templates** – define resources and their configurations. **Stacks** – instances of templates with specific parameters; all resources in a stack are created/updated/deleted together. **Change Sets** – preview changes before executing. **Drift Detection** – identify resources that have been manually modified. Benefits: repeatable, version-controlled, dependencies managed automatically, rollback on failure. Free — you only pay for the resources created.

---

### Card 24
**Q:** What are the key CloudFormation intrinsic functions?
**A:** **Ref** – returns the value of a parameter or the physical ID of a resource. **Fn::GetAtt** – returns an attribute of a resource (e.g., ARN, DNS name). **Fn::Join** – concatenate strings with a delimiter. **Fn::Sub** – substitute variables in a string (like template literals). **Fn::Select** – pick an element from a list by index. **Fn::Split** – split a string into a list. **Fn::ImportValue** – import an exported value from another stack. **Fn::FindInMap** – look up values from a Mappings section. **Condition functions** – Fn::If, Fn::Equals, Fn::And, Fn::Or, Fn::Not.

---

### Card 25
**Q:** What are CloudFormation cross-stack references?
**A:** Cross-stack references allow one stack to use outputs from another stack. Process: **Stack A** defines an Output with an `Export` name. **Stack B** uses `Fn::ImportValue` to reference the exported value. Use for: sharing VPC IDs, subnet IDs, security group IDs, or ALB ARNs across stacks. The exporting stack cannot be deleted while its values are imported by another stack. Different from nested stacks (parent-child relationship) — cross-stack is peer-to-peer sharing.

---

### Card 26
**Q:** What is the difference between CloudFormation nested stacks and cross-stack references?
**A:** **Nested Stacks** – a parent stack creates child stacks using `AWS::CloudFormation::Stack`. Child stacks are components of the parent. Use for: reusing template patterns (e.g., a standard ALB stack). Lifecycle is tied to the parent — updating the parent can update children. **Cross-Stack References** – independent stacks share values via Exports/ImportValue. Use for: sharing resources across independent stacks (e.g., network stack exports VPC ID, app stack imports it). Nested = reusable components. Cross-stack = sharing between independent stacks.

---

### Card 27
**Q:** What is AWS CloudFormation StackSets?
**A:** StackSets deploy CloudFormation stacks across **multiple accounts** and **multiple regions** in a single operation. Managed via a **management account** in Organizations (or self-managed via IAM roles). Use cases: deploy standard security configurations across all accounts, create IAM roles in every account, deploy compliance rules organization-wide. Features: concurrent deployment, failure tolerance settings, automatic deployment to new accounts (with Organizations integration), per-region ordering.

---

### Card 28
**Q:** What is CloudFormation Drift Detection?
**A:** Drift detection identifies resources in a stack whose actual configuration differs from the template definition (manual changes outside CloudFormation). You can check drift at the stack level or individual resource level. Drift statuses: **IN_SYNC**, **MODIFIED**, **DELETED**, **NOT_CHECKED**. The drift report shows which properties changed and the expected vs. actual values. Drift detection doesn't fix drift — you must update the template or the resource manually. Not all resource types support drift detection.

---

### Card 29
**Q:** What are CloudFormation stack policies?
**A:** A stack policy is a JSON document that defines which stack resources can be updated and by whom. By default, all resources can be updated. When you set a stack policy, all update actions are **denied** unless explicitly allowed. Use for: protecting critical resources from accidental updates (e.g., production database). The policy applies during `UpdateStack`. To override temporarily, pass `--stack-policy-during-update-url` or `--stack-policy-during-update-body`. Stack policies are different from IAM policies.

---

### Card 30
**Q:** What is the AWS CDK (Cloud Development Kit)?
**A:** CDK lets you define cloud infrastructure using familiar programming languages (TypeScript, Python, Java, C#, Go). CDK code is compiled into CloudFormation templates. Key concepts: **Constructs** – building blocks (L1 = raw CFN resources, L2 = opinionated defaults, L3 = patterns/complete solutions). **Stacks** – unit of deployment. **App** – container for stacks. Benefits: loops, conditions, IDE support, type safety, reusable patterns, testing with assertion libraries. `cdk synth` generates the CloudFormation template. `cdk deploy` deploys it.

---

### Card 31
**Q:** What is AWS Systems Manager (SSM)?
**A:** SSM is a suite of tools for managing EC2 instances and on-premises servers at scale. Key capabilities: **Run Command** (execute commands remotely), **Session Manager** (secure shell access without SSH), **Patch Manager** (automate OS patching), **Parameter Store** (centralized configuration), **State Manager** (maintain desired state), **Automation** (runbooks for common tasks), **Inventory** (collect software inventory), **OpsCenter** (operational issue management). Requires the **SSM Agent** (pre-installed on Amazon Linux and Windows AMIs).

---

### Card 32
**Q:** What is SSM Session Manager?
**A:** Session Manager provides secure, browser-based or CLI shell access to EC2 instances and on-premises servers **without opening SSH ports** (port 22), managing SSH keys, or using bastion hosts. Traffic goes through the SSM service (HTTPS). Features: IAM-based access control, full audit logging to S3 and CloudWatch Logs, no inbound security group rules needed, port forwarding supported. Requires: SSM Agent installed, instance must have an IAM role with SSM permissions, and outbound HTTPS (443) access to SSM endpoints.

---

### Card 33
**Q:** What is SSM Run Command?
**A:** Run Command remotely executes commands on managed instances (EC2 or on-premises) without SSH/RDP. You choose a **document** (pre-defined or custom), specify targets (instance IDs, tags, resource groups), and execute. Features: rate control (concurrency and error thresholds), output to S3/CloudWatch, SNS notifications, integration with EventBridge. Common use: install software, run scripts, collect logs, update configurations. No need to manage bastion hosts. Commands execute via the SSM Agent.

---

### Card 34
**Q:** What is SSM Patch Manager?
**A:** Patch Manager automates the process of patching managed instances with security-related and other updates. Components: **Patch Baseline** – defines which patches to approve/reject (OS, classification, severity). AWS provides default baselines per OS. **Patch Groups** – organize instances by tag (e.g., "Production", "Development"). **Maintenance Window** – schedule patching times. Process: scan for missing patches → report compliance → optionally install patches. Reports compliance to SSM Compliance dashboard and Config.

---

### Card 35
**Q:** What is SSM Automation?
**A:** SSM Automation simplifies common maintenance and deployment tasks using **runbooks** (Automation documents). AWS provides 100+ pre-built runbooks: restart instances, create AMIs, create snapshots, apply patches, update CloudFormation stacks. Custom runbooks use steps (actions) like `aws:executeAwsApi`, `aws:runCommand`, `aws:invokeLambdaFunction`, `aws:approve` (manual approval), `aws:branch` (conditional logic). Integrations: EventBridge triggers, Config remediation, maintenance windows. Use for automated incident response and operational tasks.

---

### Card 36
**Q:** What is SSM Parameter Store?
**A:** Parameter Store provides secure, hierarchical storage for configuration data and secrets. Supports: **String**, **StringList**, **SecureString** (encrypted with KMS). Hierarchy: `/app/prod/db-url`, `/app/dev/db-url`. Features: versioning, notifications via EventBridge, integration with CloudFormation, Lambda, ECS. **Standard tier**: free, 10,000 params, 4 KB max. **Advanced tier**: $0.05/param/month, 100,000 params, 8 KB max, parameter policies (expiration, notification before expiry). No native auto-rotation (unlike Secrets Manager).

---

### Card 37
**Q:** What is AWS X-Ray?
**A:** X-Ray is a distributed tracing service for analyzing and debugging microservices architectures. It traces requests as they flow through your application (API Gateway → Lambda → DynamoDB → etc.), creating a **service map** visualization. Shows: request latency, error rates, HTTP status codes, annotations, and metadata per service. Instruments code via the **X-Ray SDK** (add to your code) or **X-Ray Daemon** (collects traces from the SDK and sends to the X-Ray service). Supports: EC2, ECS, Lambda, Elastic Beanstalk, API Gateway.

---

### Card 38
**Q:** What are X-Ray key concepts?
**A:** **Segments** – data about work done by a single service (name, request, response, start/end time). **Subsegments** – more granular detail within a segment (e.g., an external HTTP call, a DynamoDB query). **Traces** – a collection of segments for a single request as it passes through services; identified by a trace ID. **Annotations** – indexed key-value pairs for filtering traces. **Metadata** – non-indexed key-value pairs for additional data. **Service Map** – visual graph of your application showing connections and health. **Sampling rules** – control how many requests are traced to reduce cost.

---

### Card 39
**Q:** What is CloudWatch Container Insights?
**A:** Container Insights collects, aggregates, and summarizes metrics and logs from containerized applications on **ECS**, **EKS**, **Kubernetes on EC2**, and **Fargate**. Metrics: CPU, memory, disk, network per container/task/pod/service/cluster. Provides pre-built dashboards. Uses the **CloudWatch Agent** (ECS) or **Fluent Bit/Fluentd** (EKS) for collection. Enables performance monitoring and troubleshooting at the container level. Costs apply per metric and log ingestion.

---

### Card 40
**Q:** What is CloudWatch Application Insights?
**A:** Application Insights automatically discovers and monitors application components and their dependencies. It detects abnormal patterns using ML and creates CloudWatch alarms and dashboards automatically. Supports: .NET, Java, SQL Server, IIS, and other common application stacks. When issues are detected, it generates **Observations** (correlated findings) and links to relevant metrics, logs, and X-Ray traces. Simplifies monitoring setup for common application architectures without manual configuration.

---

### Card 41
**Q:** What are CloudWatch Logs cross-account subscriptions?
**A:** You can send CloudWatch Logs from one account to a destination in another account using **cross-account subscription filters**. The destination account creates a Kinesis Data Stream or Kinesis Data Firehose delivery stream. A **destination** resource is created in the receiving account with a resource policy allowing the sender. The sending account creates a subscription filter pointing to the destination ARN. Use for: centralized log analysis, security monitoring, and compliance across an organization.

---

### Card 42
**Q:** What is a CloudTrail Trail vs. CloudTrail Lake?
**A:** **Trail** – delivers events to an S3 bucket (and optionally CloudWatch Logs); you manage storage and querying (Athena). Events delivered within 15 minutes. **CloudTrail Lake** – managed event data store; SQL-based query engine; no need for S3; retention up to 7 years (configurable); faster querying; dashboard support; cross-account with Organizations. Lake is better for analysis without managing S3 buckets and Athena. Trail is better for long-term archival and integration with existing S3-based workflows.

---

### Card 43
**Q:** How do you analyze CloudTrail logs stored in S3?
**A:** Use **Amazon Athena** to query CloudTrail logs with SQL. AWS provides a pre-built Athena table definition for CloudTrail. You can query: who made API calls, from which IP, what actions were performed, what resources were affected. Create the Athena table pointing to the CloudTrail S3 bucket, then run SQL queries. Use with **AWS Glue Data Catalog** for schema management. For automated analysis, use CloudTrail Insights or create EventBridge rules for specific API calls.

---

### Card 44
**Q:** What is the difference between CloudWatch agent unified log and the old CloudWatch Logs agent?
**A:** The **old CloudWatch Logs agent** (awslogs) – only collects logs; no metrics; older, being deprecated. The **new unified CloudWatch Agent** – collects both logs AND system metrics (memory, disk, network details, process counts, swap); supports StatsD and collectd; more configuration options; supports SSM Parameter Store for config management. Always use the unified agent for new deployments. It replaces both the old logs agent and any custom metric collection scripts.

---

### Card 45
**Q:** What is a CloudWatch Composite Alarm?
**A:** A Composite Alarm monitors the states of **multiple other alarms** using Boolean logic (AND, OR, NOT). It enters ALARM state only when the combined conditions are met. Use for: reducing alarm noise (e.g., alert only when BOTH high CPU and high error rate alarms are active), creating complex monitoring scenarios, avoiding false positives from individual metrics. Composite alarms can trigger SNS actions. They don't evaluate metrics directly — only the states of child alarms.

---

### Card 46
**Q:** What is CloudWatch Anomaly Detection?
**A:** CloudWatch Anomaly Detection uses ML to analyze metric history and create a model of expected values (a **band** of normal behavior). Alarms can be configured to trigger when the metric goes **outside the expected band** rather than crossing a static threshold. The model adapts to patterns (time of day, day of week, seasonality). Use for: metrics with variable baselines (e.g., traffic that's higher on weekdays than weekends). Works with any CloudWatch metric. Reduces false alarms from static thresholds.

---

### Card 47
**Q:** What is the CloudTrail organization trail?
**A:** An organization trail logs events for **all accounts** in an AWS Organization. Created in the management account and automatically applies to all member accounts. Events from all accounts are delivered to a single S3 bucket. Member accounts can see the trail but cannot modify or delete it. Benefits: centralized auditing, consistent logging, no need to create trails in each account individually. Can include management events, data events, and Insights. Simplifies compliance and security monitoring.

---

### Card 48
**Q:** What is SSM State Manager?
**A:** State Manager maintains managed instances in a defined, consistent state. You create **associations** that define the desired state (e.g., ensure antivirus is installed, specific ports are closed, CloudWatch agent is running). Associations are applied on a schedule (cron, rate) or on startup. Uses SSM Documents as the definition of the desired state. If a resource drifts from the desired state, State Manager reapplies the association. Think of it as a continuous enforcement tool, complementing Patch Manager and Run Command.

---

### Card 49
**Q:** What is CloudWatch Evidently?
**A:** CloudWatch Evidently enables **feature flags** and **A/B testing** for applications. **Feature Flags** – safely launch features to a subset of users; control rollout (e.g., 10% of users, then 50%, then 100%). **Experiments** – A/B test different variations and measure impact on metrics. Integrates with CloudWatch for metric collection. Use for: gradual feature rollouts, measuring feature impact, reducing risk of new deployments. Similar to third-party feature flag services but integrated with AWS.

---

### Card 50
**Q:** What is the CloudWatch metric math feature?
**A:** Metric Math allows you to create new time-series metrics by applying mathematical expressions to existing CloudWatch metrics. Examples: `errorRate = errors / requests * 100`, `averageLatency = SUM(latency) / SampleCount`, combining metrics from different sources. Supported in dashboards, alarms, and API queries. Operators: +, -, *, /, ^, and functions like AVG, SUM, MIN, MAX, STDDEV, PERCENTILE, FILL, IF, METRICS. Enables sophisticated monitoring without custom metrics.

---

*End of Deck 8 — 50 cards*
