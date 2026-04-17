# Monitoring & Management Question Bank

**AWS Solutions Architect Associate (SAA-C03) — Topic-Wise Practice**
**Total Questions: 30**

---

### Question 1
A company wants to monitor the CPU utilization of their EC2 instances and receive an email notification when CPU exceeds 80% for 5 consecutive minutes. What should the architect configure?

A) CloudWatch Logs metric filter with an SNS notification
B) CloudWatch alarm on the `CPUUtilization` metric with a 5-minute period and 1 evaluation period, with an SNS topic action
C) AWS Config rule monitoring CPU utilization
D) CloudTrail event for high CPU

**Answer: B**
**Explanation:** CloudWatch alarms monitor metrics and trigger actions when thresholds are breached. Setting a 5-minute period with 1 evaluation period means the alarm triggers when CPU exceeds 80% for one 5-minute period. SNS delivers the email notification. CloudWatch Logs (A) is for log data. Config (C) monitors resource configuration, not performance. CloudTrail (D) logs API calls, not resource metrics.

---

### Question 2
A company wants to collect and analyze application logs from EC2 instances in near real-time. They need to search, filter, and create dashboards from the log data. What should the architect configure?

A) Ship logs to S3 and query with Athena
B) Install the CloudWatch agent on EC2 instances to push logs to CloudWatch Logs, then use CloudWatch Logs Insights for analysis
C) Enable VPC Flow Logs
D) Use CloudTrail to capture application logs

**Answer: B**
**Explanation:** The CloudWatch agent collects and pushes custom logs and system metrics to CloudWatch Logs. CloudWatch Logs Insights provides an interactive query language for searching and analyzing log data in near real-time. S3 + Athena (A) is batch, not near real-time. VPC Flow Logs (C) capture network traffic, not application logs. CloudTrail (D) captures API calls, not application logs.

---

### Question 3
A company needs to track all API calls made in their AWS account for security auditing. They need to know who made each call, when, from where, and the request/response details. What should the architect enable?

A) CloudWatch Logs
B) VPC Flow Logs
C) AWS CloudTrail
D) AWS Config

**Answer: C**
**Explanation:** CloudTrail records AWS API calls including the caller identity, time, source IP, request parameters, and response. It provides a complete audit trail of account activity. CloudWatch Logs (A) stores application/system logs. VPC Flow Logs (B) capture network traffic metadata. Config (C) tracks resource configuration changes, not API calls.

---

### Question 4
A company wants to ensure that all S3 buckets in their account have versioning enabled. If versioning is disabled on any bucket, they want to be notified immediately. What should the architect set up?

A) CloudTrail monitoring for `PutBucketVersioning` API calls
B) AWS Config managed rule `s3-bucket-versioning-enabled` with SNS notification on non-compliance
C) A Lambda function that checks all buckets daily
D) CloudWatch alarm on S3 bucket metrics

**Answer: B**
**Explanation:** AWS Config continuously evaluates resource configurations against rules. The `s3-bucket-versioning-enabled` managed rule checks if S3 buckets have versioning enabled and reports non-compliance. SNS notifications can alert the team immediately. CloudTrail (A) logs API calls but doesn't evaluate compliance. Lambda (C) requires custom development. CloudWatch (D) monitors performance metrics, not configuration.

---

### Question 5
A company has a CloudFormation stack that manages their VPC, subnets, and security groups. A developer accidentally deleted the stack, which removed all networking resources. How can the architect prevent this from happening again?

A) Use IAM policies to deny `cloudformation:DeleteStack` for all users
B) Enable CloudFormation stack termination protection
C) Create a backup of the stack template in S3
D) Use AWS Config to monitor CloudFormation stacks

**Answer: B**
**Explanation:** CloudFormation termination protection prevents a stack from being accidentally deleted. When enabled, any attempt to delete the stack through the console, CLI, or API will fail until termination protection is disabled. IAM policies (A) are too broad — they would prevent legitimate deletions. Template backups (C) don't prevent deletion. Config (D) monitors but doesn't prevent.

---

### Question 6
A company has deployed a multi-tier application using CloudFormation. They want to update the application tier without affecting the database tier. The database is an RDS instance defined in the same stack. What should the architect use?

A) Delete and recreate the stack with the updated template
B) Use CloudFormation stack policies to prevent updates to the RDS resource, then update the stack
C) Create a separate stack for the database
D) Use CloudFormation change sets to preview changes, then apply

**Answer: B**
**Explanation:** Stack policies define which resources can be updated during stack updates. By setting a Deny policy on the RDS resource, CloudFormation will prevent any changes to it during updates. Change sets (D) preview changes but don't prevent them. Deleting the stack (A) removes everything. Separate stacks (C) are a good practice but require refactoring.

---

### Question 7
A company wants to manage the configuration of their EC2 fleet. They need to install patches, run scripts, and collect inventory across hundreds of instances without SSH access. What should the architect use?

A) EC2 User Data scripts
B) AWS Systems Manager (SSM) with the SSM Agent
C) AWS OpsWorks
D) Custom Ansible deployed on a bastion host

**Answer: B**
**Explanation:** AWS Systems Manager provides Run Command (execute scripts/commands), Patch Manager (automated patching), and Inventory (software/configuration inventory) without requiring SSH access. It uses the SSM Agent installed on instances. User Data (A) runs only at launch. OpsWorks (C) uses Chef/Puppet and is more complex. Ansible (D) requires a bastion host and SSH.

---

### Question 8
A company deploys infrastructure across 20 AWS accounts using CloudFormation. They want to deploy the same CloudFormation template to all accounts with a single operation. What should the architect use?

A) Copy the template to each account and deploy manually
B) CloudFormation StackSets
C) AWS Service Catalog
D) Terraform

**Answer: B**
**Explanation:** CloudFormation StackSets allow you to deploy CloudFormation stacks across multiple accounts and regions from a single template and operation. It integrates with AWS Organizations for automatic deployment to new accounts. Manual deployment (A) is error-prone. Service Catalog (C) provides approved products but doesn't do cross-account deployment. Terraform (D) is a third-party tool.

---

### Question 9
A company wants to understand the end-to-end latency of their microservices application. The application consists of an API Gateway, multiple Lambda functions, and DynamoDB. They need to visualize the request flow and identify bottlenecks. What should the architect enable?

A) CloudWatch metrics for each service
B) AWS X-Ray tracing across all services
C) VPC Flow Logs
D) CloudTrail data events

**Answer: B**
**Explanation:** AWS X-Ray provides distributed tracing, creating a service map that visualizes the request flow across API Gateway, Lambda, DynamoDB, and other services. It identifies latency bottlenecks in each segment. CloudWatch metrics (A) show individual service metrics but not request flow. VPC Flow Logs (C) capture network traffic. CloudTrail (D) logs API calls, not request latency.

---

### Question 10
A company needs to track changes to their AWS resources over time. For compliance, they need to see the configuration history of every resource and identify when a change was made and by whom. What should the architect enable?

A) CloudTrail for API call logging
B) AWS Config with configuration recording
C) CloudWatch Events for resource changes
D) AWS Trusted Advisor

**Answer: B**
**Explanation:** AWS Config records configuration changes to AWS resources over time, maintaining a configuration history and providing a timeline of changes. Combined with CloudTrail, you can identify who made the change. CloudTrail (A) logs API calls but doesn't maintain resource configuration history. CloudWatch Events (C) triggers on events but doesn't store history. Trusted Advisor (D) provides recommendations.

---

### Question 11
A company runs EC2 instances and wants to monitor custom application metrics (e.g., active user count, request queue depth) that are not available as default CloudWatch metrics. How should they publish these metrics?

A) They cannot push custom metrics to CloudWatch
B) Use the CloudWatch agent or AWS SDK to publish custom metrics using `PutMetricData` API
C) Use VPC Flow Logs to capture application metrics
D) Use CloudTrail to log custom metrics

**Answer: B**
**Explanation:** CloudWatch supports custom metrics published via the `PutMetricData` API or the CloudWatch agent's `statsd` and `collectd` integration. Applications can push any custom metric (active users, queue depth, etc.) to CloudWatch for monitoring and alarming. Custom metrics are fully supported (A is wrong). VPC Flow Logs (C) and CloudTrail (D) serve different purposes.

---

### Question 12
A company has multiple AWS accounts and wants to get recommendations for cost optimization, security, fault tolerance, performance, and service limits across all accounts. What should the architect enable?

A) AWS Config aggregator
B) AWS Trusted Advisor (with Business or Enterprise Support)
C) AWS Cost Explorer
D) AWS Security Hub

**Answer: B**
**Explanation:** AWS Trusted Advisor provides recommendations across five categories: cost optimization, security, fault tolerance, performance, and service limits. With Business or Enterprise Support plans, all checks are available. With AWS Organizations, Trusted Advisor can provide organizational views. Config aggregator (A) aggregates compliance data. Cost Explorer (C) is only for cost. Security Hub (D) is only for security.

---

### Question 13
A company is troubleshooting intermittent connectivity issues between an EC2 instance in a private subnet and the internet via a NAT gateway. What should the architect analyze?

A) CloudTrail logs
B) VPC Flow Logs on the instance's ENI and the NAT gateway's ENI
C) CloudWatch CPU metrics for the NAT gateway
D) S3 access logs

**Answer: B**
**Explanation:** VPC Flow Logs capture network traffic metadata (source/destination IPs, ports, action, bytes) at the ENI level. Analyzing flow logs on both the instance's ENI and the NAT gateway's ENI reveals where traffic is being accepted or rejected. CloudTrail (A) logs API calls, not network traffic. CloudWatch NAT gateway metrics (C) show aggregate traffic but not individual connections. S3 logs (D) are irrelevant.

---

### Question 14
A company deploys a new version of their application using CloudFormation. The update fails midway, and some resources are in an inconsistent state. What is CloudFormation's default behavior when an update fails?

A) CloudFormation deletes the stack entirely
B) CloudFormation rolls back to the previous known good state automatically
C) CloudFormation leaves resources in the failed state and requires manual intervention
D) CloudFormation retries the update automatically

**Answer: B**
**Explanation:** By default, CloudFormation automatically rolls back the stack to the previous known good configuration when an update fails. This ensures resources return to a consistent state. CloudFormation doesn't delete the stack (A), leave resources in a failed state (C), or retry (D) by default. You can disable automatic rollback for debugging purposes.

---

### Question 15
A company needs to store CloudTrail logs for 7 years for compliance. They need the logs to be tamper-proof to ensure integrity. What should the architect configure?

A) CloudTrail logging to CloudWatch Logs with a 7-year retention
B) CloudTrail logging to S3 with log file integrity validation, and an S3 lifecycle policy retaining logs for 7 years with Object Lock
C) CloudTrail logging to a local EBS volume
D) CloudTrail with a 7-year retention setting

**Answer: B**
**Explanation:** CloudTrail log file integrity validation uses SHA-256 hashing to detect any tampering. Storing logs in S3 with Object Lock (Compliance mode) ensures they cannot be deleted or modified for 7 years. CloudWatch Logs (A) supports up to 10 years retention but doesn't have the same integrity validation. CloudTrail doesn't store logs on EBS (C) or have a built-in retention setting beyond S3 (D).

---

### Question 16
A company wants to automate the deployment of security patches to their EC2 fleet. Patches must be applied during a specific maintenance window. They need a report of which instances were patched and any failures. What should the architect use?

A) Write a cron job on each instance to run `yum update`
B) AWS Systems Manager Patch Manager with a defined maintenance window
C) AWS Config with automatic remediation
D) Use CloudFormation to update instance AMIs

**Answer: B**
**Explanation:** SSM Patch Manager automates OS and software patching with configurable baselines and maintenance windows. It provides compliance reports showing patched/unpatched instances. Cron jobs (A) are decentralized and hard to monitor. Config (C) monitors compliance but doesn't manage patching. CloudFormation AMI updates (D) require instance replacement.

---

### Question 17
A company uses CloudWatch to monitor their RDS database. They want to be alerted when free storage space drops below 10 GB AND when CPU utilization exceeds 90%. They want a single alert only when BOTH conditions are true simultaneously. What should the architect configure?

A) Two separate CloudWatch alarms with separate SNS notifications
B) A CloudWatch composite alarm that triggers when both individual alarms are in ALARM state
C) A Lambda function that checks both metrics
D) CloudWatch Logs metric filter for both conditions

**Answer: B**
**Explanation:** CloudWatch composite alarms combine multiple alarms using AND/OR logic. By creating two individual alarms and a composite alarm with AND logic, the notification is sent only when both conditions are true simultaneously. Separate alarms (A) would trigger independently. Lambda (C) is custom code. Metric filters (D) are for log data, not metrics.

---

### Question 18
A company has a CloudFormation template that creates an EC2 instance with a web server. The stack creation succeeds, but the web server software fails to install. CloudFormation reports the stack as `CREATE_COMPLETE` even though the application is not functional. How should the architect fix this?

A) Use CloudFormation `DependsOn` attribute
B) Use `cfn-signal` with a `CreationPolicy` to signal CloudFormation when the software installation completes successfully
C) Add a `WaitCondition` with no timeout
D) Check CloudWatch metrics after stack creation

**Answer: B**
**Explanation:** `cfn-signal` with `CreationPolicy` tells CloudFormation to wait for a success signal from the instance before marking the resource as `CREATE_COMPLETE`. If the signal isn't received within the timeout, CloudFormation rolls back. `DependsOn` (A) controls resource creation order, not installation verification. WaitCondition (C) without timeout would wait indefinitely. CloudWatch (D) is reactive.

---

### Question 19
A company needs to provide their developers with pre-approved, self-service access to AWS resources. Developers should be able to launch approved CloudFormation templates without needing full CloudFormation or AWS console access. What should the architect use?

A) IAM policies allowing only specific CloudFormation actions
B) AWS Service Catalog with a portfolio of approved products
C) AWS Control Tower
D) AWS Organizations SCPs

**Answer: B**
**Explanation:** AWS Service Catalog allows administrators to create portfolios of approved products (CloudFormation templates). Developers can self-service launch these products without needing direct CloudFormation access. Service Catalog enforces constraints and governance. IAM policies (A) are complex to maintain. Control Tower (C) is for account governance. SCPs (D) restrict permissions, not provide self-service products.

---

### Question 20
A company wants to detect when unusual API activity occurs in their account, such as a spike in `TerminateInstances` calls or calls from an unusual region. What should the architect enable?

A) CloudWatch Alarms on API call metrics
B) CloudTrail Insights
C) Amazon GuardDuty
D) AWS Config change notifications

**Answer: B**
**Explanation:** CloudTrail Insights automatically detects unusual API activity patterns such as spikes in resource provisioning, bursts of API calls, or calls from unusual regions. It creates Insights events when anomalies are detected. CloudWatch Alarms (A) require predefined thresholds. GuardDuty (C) detects threats but focuses on security threats rather than general API anomalies. Config (D) tracks configuration changes.

---

### Question 21
A company has 500 EC2 instances and needs to store and retrieve configuration parameters (database connection strings, feature flags) used by applications on these instances. Parameters should be versioned and some must be encrypted. What should the architect use?

A) Store parameters in a shared S3 bucket
B) AWS Systems Manager Parameter Store with SecureString parameters for sensitive values
C) Hard-code parameters in the application
D) Store parameters in DynamoDB

**Answer: B**
**Explanation:** SSM Parameter Store provides centralized, hierarchical storage for configuration data and secrets. SecureString parameters are encrypted with KMS. Parameters are versioned, support access control via IAM, and can be referenced directly from EC2 instances via the SSM agent. S3 (A) doesn't provide versioning of parameters natively. Hard-coding (C) is inflexible. DynamoDB (D) works but requires custom implementation.

---

### Question 22
A company is running a production CloudFormation stack and wants to preview what changes an updated template will make before applying it. They want to see which resources will be added, modified, or replaced. What should they use?

A) CloudFormation drift detection
B) CloudFormation change sets
C) CloudFormation stack policies
D) CloudFormation rollback triggers

**Answer: B**
**Explanation:** Change sets preview the changes CloudFormation will make when updating a stack. They show which resources will be added, modified, replaced, or deleted without actually executing the changes. Drift detection (A) identifies differences between the stack template and the actual resource configuration. Stack policies (C) prevent certain updates. Rollback triggers (D) monitor alarms during updates.

---

### Question 23
A company has resources deployed via CloudFormation. They suspect someone manually modified a security group outside of CloudFormation. How can they identify the discrepancy?

A) Review CloudTrail logs
B) Use CloudFormation drift detection
C) Redeploy the CloudFormation stack
D) Check AWS Config for the security group history

**Answer: B**
**Explanation:** CloudFormation drift detection compares the current state of resources against their expected configuration as defined in the stack template. It identifies which resources have drifted and shows the differences. CloudTrail (A) shows who made the change but doesn't compare against the template. Redeploying (C) would overwrite changes. Config (D) shows configuration history but not the template comparison.

---

### Question 24
A company needs to monitor the health of their application across multiple AWS services (ALB, EC2, RDS, Lambda). They want a single dashboard showing key metrics from all services. What should the architect create?

A) Individual service dashboards in each service's console
B) A CloudWatch cross-service dashboard with widgets for metrics from ALB, EC2, RDS, and Lambda
C) An AWS Health Dashboard
D) A Trusted Advisor dashboard

**Answer: B**
**Explanation:** CloudWatch dashboards support widgets from multiple AWS services, allowing you to create a unified view of application health. You can add metrics from ALB (request count, latency), EC2 (CPU, network), RDS (connections, IOPS), and Lambda (invocations, errors). Service-specific dashboards (A) require switching between consoles. Health Dashboard (C) shows AWS service health. Trusted Advisor (D) shows recommendations.

---

### Question 25
A company wants to ensure that their CloudFormation stacks are deployed consistently and that resources created outside of CloudFormation are identified. They want to enforce "infrastructure as code" compliance. What combination should they use?

A) CloudFormation StackSets and IAM policies
B) CloudFormation drift detection and AWS Config rules for resource tagging
C) AWS Service Catalog and SCPs
D) CloudFormation with CodePipeline for CI/CD

**Answer: B**
**Explanation:** CloudFormation drift detection identifies resources that were modified outside of CloudFormation. AWS Config rules can flag resources that don't have CloudFormation tags (indicating they were created manually). Together, they enforce IaC compliance. StackSets (A) deploy across accounts but don't detect manual changes. Service Catalog (C) provides approved products. CodePipeline (D) automates deployment but doesn't detect manual modifications.

---

### Question 26
A company has a Lambda function that processes events from multiple sources. They need to trace requests through the Lambda function to downstream services (DynamoDB, SQS) to identify performance bottlenecks. What should be configured?

A) CloudWatch Logs with structured logging
B) Enable active tracing with AWS X-Ray on the Lambda function
C) Enable VPC Flow Logs
D) Enable CloudTrail data events for Lambda

**Answer: B**
**Explanation:** AWS X-Ray active tracing on Lambda captures traces for each invocation, including downstream calls to DynamoDB, SQS, and other AWS services. The X-Ray service map visualizes dependencies and latency. CloudWatch Logs (A) provide log data but not distributed tracing. VPC Flow Logs (C) capture network traffic. CloudTrail (D) logs invocations but doesn't trace internal execution.

---

### Question 27
A company deploys infrastructure using CloudFormation and wants to retain the RDS database even if the CloudFormation stack is deleted. What should the architect set on the RDS resource in the CloudFormation template?

A) `DependsOn: AWS::RDS::DBInstance`
B) `DeletionPolicy: Retain`
C) `UpdateReplacePolicy: Retain`
D) `Condition: KeepDatabase`

**Answer: B**
**Explanation:** The `DeletionPolicy: Retain` attribute tells CloudFormation to keep the resource when the stack is deleted. The RDS instance will be preserved and must be manually deleted if no longer needed. `UpdateReplacePolicy` (C) handles resource replacement during updates, not stack deletion. `DependsOn` (A) is for ordering. `Condition` (D) is for conditional resource creation.

---

### Question 28
A company wants CloudWatch to monitor memory utilization and disk space on their EC2 instances. These metrics are not available in CloudWatch by default. What should the architect do?

A) Enable detailed monitoring on the EC2 instances
B) Install and configure the CloudWatch agent on the EC2 instances to publish memory and disk metrics
C) Use EC2 instance metadata to get memory usage
D) Enable Enhanced Monitoring on EC2

**Answer: B**
**Explanation:** Memory and disk metrics are not collected by CloudWatch by default. The CloudWatch agent must be installed on EC2 instances to collect and publish these OS-level metrics. Detailed monitoring (A) provides 1-minute granularity for standard metrics but doesn't add new metrics. Instance metadata (C) provides instance attributes, not real-time metrics. Enhanced Monitoring (D) is for RDS, not EC2.

---

### Question 29
A company needs to roll back their CloudFormation stack update if an alarm triggers during the update. For example, if the application error rate exceeds 5% during deployment, the update should automatically roll back. What should the architect configure?

A) CloudWatch alarm connected to a Lambda function that initiates rollback
B) CloudFormation rollback triggers specifying the CloudWatch alarm
C) A Step Functions workflow that monitors the deployment
D) CloudFormation stack policies with alarm conditions

**Answer: B**
**Explanation:** CloudFormation rollback triggers allow you to specify CloudWatch alarms that, if they enter ALARM state during stack creation or update, automatically trigger a rollback. This provides automated safety during deployments. Lambda-based rollback (A) is custom. Step Functions (C) adds complexity. Stack policies (D) don't support alarm conditions.

---

### Question 30
A company has multiple CloudFormation stacks that share common resources (VPC, subnets). The networking stack outputs VPC and subnet IDs that other stacks need to reference. How should cross-stack references be implemented?

A) Hard-code the VPC and subnet IDs in each stack
B) Use CloudFormation Exports in the networking stack and `Fn::ImportValue` in the consuming stacks
C) Use SSM Parameter Store to share values between stacks
D) Both B and C are valid approaches

**Answer: D**
**Explanation:** Both CloudFormation Exports/ImportValue (B) and SSM Parameter Store (C) are valid approaches for sharing values between stacks. Exports create direct dependencies between stacks, while SSM Parameter Store is more flexible (no direct dependency, can be updated independently). Hard-coding (A) is fragile and error-prone. The exam recognizes both as valid patterns.

---

*End of Monitoring & Management Question Bank*
