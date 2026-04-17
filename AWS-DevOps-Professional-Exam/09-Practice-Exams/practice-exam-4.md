# Practice Exam 4 - AWS DevOps Engineer Professional (Comprehensive Review)
**Time Limit:** 180 minutes | **Questions:** 75 | **Passing Score:** ~750/1000
**Purpose:** Final comprehensive review covering all domains with emphasis on real-world scenarios

---

### Question 1
A company is migrating its on-premises CI/CD pipeline to AWS. The existing pipeline uses Jenkins to build Java applications, run integration tests against a PostgreSQL database, and deploy to VMware-based virtual machines. The team wants to minimize operational overhead while maintaining the ability to run integration tests that require a real database during the build phase. They also need to deploy to Amazon ECS on Fargate. Which approach meets these requirements with the LEAST operational overhead?

**A)** Migrate Jenkins to Amazon EC2 with auto-scaling, use an Amazon RDS PostgreSQL instance for integration tests, and deploy to ECS using a Jenkins plugin.
**B)** Use AWS CodePipeline with AWS CodeBuild for builds, spin up a PostgreSQL container as a sidecar in the CodeBuild buildspec for integration tests, and use the ECS deploy action in CodePipeline.
**C)** Install Jenkins on Amazon EKS, use Amazon Aurora PostgreSQL Serverless for integration tests, and deploy to ECS via Helm charts.
**D)** Use AWS CodePipeline with AWS CodeBuild, provision an Amazon RDS instance for each build using CloudFormation, run tests, and tear down the database after each build.

<details>
<summary>Answer</summary>

**Correct Answer: B**

**Explanation:** CodeBuild supports sidecar containers (via the buildspec `env` or Docker Compose) so a PostgreSQL container can run alongside the build without provisioning any external database, reducing overhead and cost. CodePipeline with the ECS deploy action natively handles Fargate deployments. Option A requires managing Jenkins infrastructure. Option C adds Kubernetes complexity. Option D is slow and expensive since spinning up and tearing down RDS per build takes significant time.

**Domain:** Domain 1 - SDLC Automation
</details>

---

### Question 2
A DevOps engineer manages infrastructure using AWS CloudFormation across 15 AWS accounts in an AWS Organization. Each account needs a standardized VPC with specific CIDR ranges, security groups, and VPC flow logs. When a new account is added to the organization, the VPC infrastructure must be automatically provisioned. The CIDR ranges differ per account based on a mapping. What is the MOST operationally efficient solution?

**A)** Create a CloudFormation StackSet with automatic deployment enabled for the organization, using mappings in the template to assign CIDR ranges based on the account ID.
**B)** Write an AWS Lambda function triggered by AWS Organizations events that deploys a CloudFormation stack to each new account via the CloudFormation API using an assumed role.
**C)** Use AWS Service Catalog with a VPC product and configure automatic provisioning when accounts join the organization using AWS Control Tower account factory.
**D)** Create a CodePipeline that detects new accounts via EventBridge and deploys CloudFormation stacks to the new accounts using cross-account IAM roles.

<details>
<summary>Answer</summary>

**Correct Answer: A**

**Explanation:** CloudFormation StackSets with automatic deployment for AWS Organizations will automatically deploy the stack to any new account added to the targeted organizational units. Using CloudFormation mappings within the template allows different CIDR ranges per account. This is the most operationally efficient as it requires no custom code or pipeline management. Options B and D involve custom automation that adds operational overhead. Option C adds Service Catalog complexity unnecessarily.

**Domain:** Domain 2 - Configuration Management and IaC
</details>

---

### Question 3
A company runs a critical microservices application on Amazon ECS with Fargate. The application consists of 12 services, each with its own task definition. During a recent deployment, a new version of the order-processing service caused a 30% increase in response latency. The team wants to implement a deployment strategy that automatically detects performance degradation and rolls back without manual intervention. Which deployment configuration achieves this?

**A)** Configure ECS service with a rolling update deployment, and use an Application Load Balancer health check with a low threshold to detect unhealthy tasks.
**B)** Use AWS CodeDeploy with an ECS blue/green deployment, configure a CloudWatch alarm on the `TargetResponseTime` metric for the target group, and set the alarm as a rollback trigger in the deployment group.
**C)** Implement a canary deployment using AWS App Mesh with Envoy sidecars, manually monitor CloudWatch dashboards, and run a rollback script if latency increases.
**D)** Use a CodePipeline with a manual approval stage after deployment, where an operator checks CloudWatch metrics and approves or rejects the deployment.

<details>
<summary>Answer</summary>

**Correct Answer: B**

**Explanation:** AWS CodeDeploy ECS blue/green deployments natively support CloudWatch alarms as rollback triggers. By setting an alarm on `TargetResponseTime`, CodeDeploy will automatically roll back to the original task set if latency exceeds the threshold during the deployment window. Option A's rolling update doesn't support automatic rollback based on custom metrics. Option C requires manual monitoring. Option D requires human intervention and is not automated.

**Domain:** Domain 1 - SDLC Automation
</details>

---

### Question 4
An organization stores sensitive configuration data including database credentials, API keys, and TLS certificates. The database credentials must be rotated every 30 days automatically. The API keys are static and referenced by multiple Lambda functions. TLS certificates are managed for internal services. Which combination of AWS services provides the MOST cost-effective and operationally efficient secrets management strategy?

**A)** Store all secrets in AWS Secrets Manager with automatic rotation enabled for everything.
**B)** Store database credentials in AWS Secrets Manager with automatic rotation enabled, store API keys in AWS Systems Manager Parameter Store SecureString parameters, and use AWS Certificate Manager for TLS certificates.
**C)** Store all secrets in AWS Systems Manager Parameter Store SecureString parameters and use a Lambda function on a schedule to rotate the database credentials.
**D)** Store all secrets in an encrypted Amazon S3 bucket and use S3 event notifications to trigger rotation Lambda functions.

<details>
<summary>Answer</summary>

**Correct Answer: B**

**Explanation:** This approach optimizes for both cost and functionality. Secrets Manager is ideal for database credentials because it has built-in automatic rotation with native support for RDS, Redshift, and DocumentDB. Parameter Store SecureString is more cost-effective for static secrets like API keys that don't need rotation. ACM handles TLS certificates with automatic renewal at no additional cost. Option A works but is more expensive since Secrets Manager charges per secret per month. Option C requires custom rotation code. Option D is insecure and operationally complex.

**Domain:** Domain 4 - Policies and Standards Automation
</details>

---

### Question 5
A DevOps team is designing a disaster recovery strategy for a three-tier web application. The application uses an Application Load Balancer, Amazon ECS on EC2, and Amazon Aurora MySQL. The RTO is 15 minutes and the RPO is 1 minute. The DR region must remain cost-efficient during normal operations. Which DR architecture meets these requirements?

**A)** Use a pilot light strategy with Aurora cross-region read replicas, pre-configured ECS task definitions in the DR region, and Route 53 health checks with automatic failover.
**B)** Use a backup-and-restore strategy with Aurora automated backups copied to the DR region and CloudFormation templates ready to deploy the full stack.
**C)** Use a multi-site active/active strategy with Aurora Global Database and identical ECS clusters running in both regions behind a Global Accelerator.
**D)** Use a warm standby strategy with Aurora Global Database, a scaled-down ECS cluster running in the DR region, and Route 53 weighted routing.

<details>
<summary>Answer</summary>

**Correct Answer: D**

**Explanation:** A warm standby with Aurora Global Database provides an RPO of approximately 1 second (well within the 1-minute requirement) and an RTO of minutes since the infrastructure is already running at reduced capacity in the DR region. The scaled-down ECS cluster keeps costs low while enabling rapid scale-up. Option A (pilot light) might not meet the 15-minute RTO since ECS instances need to be launched. Option B cannot meet either the RTO or RPO requirements. Option C meets the requirements but is significantly more expensive than necessary.

**Domain:** Domain 6 - High Availability, Fault Tolerance, and Disaster Recovery
</details>

---

### Question 6
A company uses AWS CodePipeline to deploy a serverless application built with AWS SAM. The application consists of 20 Lambda functions, 5 API Gateway APIs, 3 DynamoDB tables, and 2 SQS queues. Deployments occasionally fail partway through, leaving the application in an inconsistent state. The team wants atomic deployments where either all changes are applied or none are. Which approach BEST achieves this?

**A)** Split the SAM template into separate nested stacks for each resource type and deploy them sequentially in the pipeline.
**B)** Use a single SAM template with CloudFormation change sets, enable automatic rollback on failure, and use `AutoPublishAlias` with `DeploymentPreference` for Lambda functions.
**C)** Deploy each Lambda function individually using `aws lambda update-function-code` in a CodeBuild step with a custom rollback script.
**D)** Use AWS CDK with the `cdk deploy` command and the `--require-approval never` flag in CodeBuild.

<details>
<summary>Answer</summary>

**Correct Answer: B**

**Explanation:** A single SAM template deployed via CloudFormation provides atomic deployment semantics — if any resource update fails, CloudFormation automatically rolls back all changes to the previous state. `AutoPublishAlias` with `DeploymentPreference` enables safe Lambda deployments with traffic shifting. Change sets provide visibility into what will change before execution. Option A with nested stacks doesn't guarantee atomicity across stacks. Option C has no built-in rollback mechanism. Option D with CDK still uses CloudFormation under the hood but doesn't leverage SAM's Lambda deployment preferences.

**Domain:** Domain 1 - SDLC Automation
</details>

---

### Question 7
A security team requires that all Amazon EC2 instances in the organization must have encrypted EBS volumes, must not have public IP addresses, and must have the SSM agent installed. Non-compliant instances must be automatically identified and reported to a central security account. Remediation should be attempted automatically where possible. Which solution meets ALL of these requirements? **(Choose TWO.)**

**A)** Deploy AWS Config rules for `encrypted-volumes`, `ec2-instance-no-public-ip`, and a custom rule for SSM agent using AWS Config aggregator to the security account.
**B)** Create a CloudWatch Events rule that monitors EC2 `RunInstances` API calls via CloudTrail and triggers a Lambda function to check compliance.
**C)** Configure AWS Config automatic remediation using Systems Manager Automation documents to encrypt unencrypted volumes and remove public IP associations.
**D)** Use Amazon Inspector to scan for unencrypted volumes and public IP addresses across all accounts.
**E)** Use AWS Security Hub with the AWS Foundational Security Best Practices standard to centralize findings and create custom actions for remediation.

<details>
<summary>Answer</summary>

**Correct Answer: A, C**

**Explanation:** AWS Config rules provide continuous compliance monitoring for the specified requirements. The Config aggregator centralizes compliance data in the security account. AWS Config automatic remediation with SSM Automation documents can remediate non-compliant resources automatically (e.g., encrypting volumes via EBS snapshot-copy-encrypt workflow, modifying instance attributes). Option B only checks at launch time and doesn't provide continuous compliance. Option D (Inspector) doesn't check for these specific compliance items. Option E provides centralized findings but doesn't natively remediate the specific issues described.

**Domain:** Domain 4 - Policies and Standards Automation
</details>

---

### Question 8
A DevOps engineer needs to deploy a containerized application to Amazon ECS. The application processes sensitive financial data and must not send any traffic over the public internet. The containers need to pull images from Amazon ECR, write logs to CloudWatch Logs, and access an Amazon S3 bucket for reports. The ECS tasks run on Fargate in private subnets with no NAT gateway. Which configuration enables this?

**A)** Create VPC interface endpoints for ECR (`com.amazonaws.region.ecr.api` and `com.amazonaws.region.ecr.dkr`), CloudWatch Logs (`com.amazonaws.region.logs`), and a gateway endpoint for S3. Also create an interface endpoint for `com.amazonaws.region.s3` for ECR layer downloads.
**B)** Create a NAT gateway in a public subnet and route traffic from the private subnets through it.
**C)** Configure the ECS tasks to use a public subnet with a security group that restricts outbound traffic to only AWS service IP ranges.
**D)** Enable AWS PrivateLink for all services and configure the ECS task execution role with VPC endpoint policies.

<details>
<summary>Answer</summary>

**Correct Answer: A**

**Explanation:** To pull images from ECR without internet access, you need both the `ecr.api` and `ecr.dkr` interface endpoints, plus an S3 endpoint (gateway or interface) since ECR stores layers in S3. The CloudWatch Logs interface endpoint enables log delivery. The S3 gateway endpoint handles both the ECR layer downloads and the report bucket access. Option B uses a NAT gateway which sends traffic over the internet. Option C uses public subnets which violates the requirement. Option D is vague and doesn't specify the actual endpoints needed.

**Domain:** Domain 5 - Incident and Event Response
</details>

---

### Question 9
A team manages a large CloudFormation stack with over 200 resources including VPCs, subnets, security groups, EC2 instances, RDS databases, and Lambda functions. The stack takes over 45 minutes to update and changes to networking resources sometimes cause unintended cascading updates to dependent resources. The team wants to improve manageability and reduce blast radius of changes. Which approach is MOST appropriate?

**A)** Migrate to Terraform which handles large stacks more efficiently.
**B)** Split the monolithic stack into multiple stacks organized by lifecycle (networking, data, compute, application) and use CloudFormation cross-stack references with exported outputs.
**C)** Use CloudFormation change sets and manually review every change before execution.
**D)** Convert all resources to use CloudFormation modules to improve organization within the single stack.

<details>
<summary>Answer</summary>

**Correct Answer: B**

**Explanation:** Splitting the monolithic stack into lifecycle-based stacks (networking, data, compute, application) reduces the blast radius because changes to one layer don't trigger updates to resources in other stacks. Cross-stack references using exports and `Fn::ImportValue` maintain the ability to reference resources across stacks. This also reduces update times since each stack has fewer resources. Option A doesn't solve the architectural problem. Option C still has the cascading update risk. Option D (modules) helps organization but doesn't reduce blast radius since all resources are still in one stack.

**Domain:** Domain 2 - Configuration Management and IaC
</details>

---

### Question 10
A company is running an application on Amazon EKS. The development team uses a GitOps workflow where all Kubernetes manifests are stored in a Git repository. When a developer pushes changes to the manifests repository, the changes should be automatically applied to the EKS cluster. The team wants to use a pull-based GitOps model for security reasons. Which solution BEST implements this pattern on AWS?

**A)** Use AWS CodePipeline triggered by a CodeCommit push event to run `kubectl apply` in a CodeBuild step using an IAM role with EKS access.
**B)** Install Flux or ArgoCD in the EKS cluster, configure it to watch the Git repository, and let it automatically reconcile the cluster state with the desired state in Git.
**C)** Create a webhook from the Git repository to an API Gateway endpoint that triggers a Lambda function to apply changes to EKS using the Kubernetes API.
**D)** Use AWS App Mesh to synchronize application configuration from Git to the EKS cluster.

<details>
<summary>Answer</summary>

**Correct Answer: B**

**Explanation:** Flux and ArgoCD are purpose-built GitOps operators that run inside the Kubernetes cluster and implement a pull-based model. They continuously poll the Git repository for changes and reconcile the cluster state to match the desired state defined in Git. This is more secure than push-based models because the cluster pulls changes rather than having external systems push to it. Option A is a push-based model. Option C is also push-based via webhooks. Option D (App Mesh) is a service mesh and doesn't handle GitOps deployments.

**Domain:** Domain 1 - SDLC Automation
</details>

---

### Question 11
A DevOps engineer is designing an observability strategy for a distributed microservices application running on Amazon ECS. The application has 15 services communicating via REST APIs and Amazon SQS. The team needs to trace requests end-to-end, correlate logs across services, and create unified dashboards with custom metrics. Which combination of tools provides the MOST comprehensive observability with the LEAST operational overhead? **(Choose TWO.)**

**A)** Deploy the AWS Distro for OpenTelemetry (ADOT) as a sidecar in each ECS task to collect traces and metrics, and send them to AWS X-Ray and Amazon CloudWatch.
**B)** Install a self-managed Jaeger cluster on EC2 for distributed tracing and Prometheus on EC2 for metrics collection.
**C)** Use Amazon CloudWatch Container Insights for metrics, CloudWatch Logs Insights for log correlation using structured JSON logging with trace IDs, and CloudWatch ServiceLens for the unified view.
**D)** Deploy an Elasticsearch, Logstash, Kibana (ELK) stack on EC2 for centralized logging and tracing.
**E)** Use AWS CloudTrail for tracing API calls between services and VPC Flow Logs for network-level monitoring.

<details>
<summary>Answer</summary>

**Correct Answer: A, C**

**Explanation:** ADOT as a sidecar provides vendor-neutral instrumentation that sends traces to X-Ray and metrics to CloudWatch, covering distributed tracing with minimal effort. CloudWatch Container Insights provides out-of-the-box ECS metrics, Logs Insights enables powerful log correlation using structured logging with trace IDs, and ServiceLens ties metrics, logs, and traces together in a unified view. Options B and D require managing infrastructure (EC2 instances) for monitoring which adds significant operational overhead. Option E (CloudTrail and VPC Flow Logs) monitors AWS API calls and network flows, not application-level requests.

**Domain:** Domain 3 - Monitoring and Logging
</details>

---

### Question 12
A company needs to manage database schema migrations as part of their CI/CD pipeline. The application uses Amazon Aurora PostgreSQL and the team deploys new application versions multiple times per day. Schema changes must be versioned, applied automatically during deployment, and support rollback if the migration fails. The database contains 500 GB of data. Which approach is MOST appropriate?

**A)** Use a database migration tool like Flyway or Liquibase integrated into the CodeBuild buildspec, run migrations as a pre-deployment step, and use the tool's built-in rollback capability for failed migrations.
**B)** Use Amazon RDS Blue/Green Deployments to create a green copy of the database, apply schema changes to the green copy, and switch over after validation.
**C)** Write raw SQL migration scripts, store them in the application repository, and execute them via a Lambda function triggered by CodePipeline.
**D)** Apply schema changes manually by a DBA before each deployment using a change management ticket.

<details>
<summary>Answer</summary>

**Correct Answer: A**

**Explanation:** Flyway and Liquibase are industry-standard database migration tools that provide version-controlled, repeatable schema migrations with built-in rollback support. Integrating them into CodeBuild ensures migrations run automatically as part of the CI/CD pipeline. They track which migrations have been applied and can generate rollback scripts. Option B (RDS Blue/Green) is designed for major version upgrades, not frequent schema changes multiple times per day — it creates a full database copy which is slow and expensive for 500 GB. Option C lacks version tracking and rollback capabilities. Option D is manual and doesn't scale with multiple daily deployments.

**Domain:** Domain 1 - SDLC Automation
</details>

---

### Question 13
A DevOps engineer is implementing infrastructure drift detection. The infrastructure is managed using CloudFormation across 8 AWS accounts. The engineer needs to detect when manual changes are made to CloudFormation-managed resources, alert the team, and optionally auto-remediate the drift. Which solution provides the MOST comprehensive drift management?

**A)** Enable CloudFormation drift detection on a schedule using a Lambda function, publish drift results to an SNS topic, and use a second Lambda function to trigger a CloudFormation stack update to remediate drift.
**B)** Use AWS Config rules to detect changes to resources and compare them against the expected CloudFormation configuration.
**C)** Enable AWS CloudTrail and create EventBridge rules that detect manual API calls to modify CloudFormation-managed resources, then trigger an SSM Automation document to restore the original configuration.
**D)** Use a cron job on an EC2 instance to periodically run `aws cloudformation detect-stack-drift` and email results.

<details>
<summary>Answer</summary>

**Correct Answer: A**

**Explanation:** CloudFormation drift detection is the native mechanism for identifying changes between the actual resource state and the CloudFormation template. Scheduling it via Lambda ensures continuous monitoring. Publishing to SNS enables alerts, and a remediation Lambda can trigger `update-stack` using the existing template to restore the expected state. Option B detects changes but doesn't natively compare against CloudFormation templates. Option C only catches API calls and misses console changes or changes made by other services. Option D works but uses an EC2 instance unnecessarily, adding operational overhead.

**Domain:** Domain 2 - Configuration Management and IaC
</details>

---

### Question 14
A company is evaluating container orchestration options for a new microservices application. The application has 30 services with varying resource requirements. Some services need GPU instances for ML inference. The team has limited Kubernetes expertise. The application must support service mesh capabilities, advanced traffic management, and blue/green deployments. Cost optimization is important. Which container orchestration approach is MOST appropriate?

**A)** Use Amazon ECS on Fargate for all services to eliminate infrastructure management.
**B)** Use Amazon EKS with managed node groups, including GPU node groups for ML services, AWS App Mesh for service mesh capabilities, and Kubernetes-native deployment strategies.
**C)** Use Amazon ECS on EC2 with a mix of regular and GPU instances in separate capacity providers, AWS App Mesh for service mesh, and CodeDeploy for blue/green deployments.
**D)** Use AWS Lambda for all services to avoid container management entirely.

<details>
<summary>Answer</summary>

**Correct Answer: C**

**Explanation:** ECS on EC2 supports GPU instances through capacity providers, which Fargate does not support for GPU workloads. AWS App Mesh provides service mesh capabilities with traffic management regardless of whether you use ECS or EKS. CodeDeploy integrates natively with ECS for blue/green deployments. Since the team has limited Kubernetes expertise, ECS is a better fit than EKS. Option A (Fargate) doesn't support GPU instances. Option B requires Kubernetes expertise the team lacks. Option D (Lambda) doesn't support GPU inference or long-running services well.

**Domain:** Domain 6 - High Availability, Fault Tolerance, and Disaster Recovery
</details>

---

### Question 15
A DevOps engineer needs to implement a canary deployment for an API running on Amazon API Gateway with AWS Lambda. The canary should receive 10% of traffic for 30 minutes, and if the error rate exceeds 1%, the deployment should automatically roll back. Which implementation achieves this?

**A)** Use API Gateway canary release deployments with a 10% canary traffic split, and create a CloudWatch alarm on the canary stage's `5XXError` metric that triggers a Lambda function to promote or roll back the canary.
**B)** Use Lambda weighted aliases to split traffic 90/10 between old and new versions, with CodeDeploy `Canary10Percent30Minutes` deployment preference and a CloudWatch alarm for automatic rollback.
**C)** Create two separate API Gateway stages (production and canary) and use Route 53 weighted routing to split traffic 90/10 between them.
**D)** Deploy the new Lambda version to a separate API Gateway endpoint and use an Application Load Balancer to split traffic between the two endpoints.

<details>
<summary>Answer</summary>

**Correct Answer: B**

**Explanation:** Lambda deployment preferences with CodeDeploy provide native canary deployment support. `Canary10Percent30Minutes` sends 10% of traffic to the new version for 30 minutes before shifting all traffic. CloudWatch alarms configured in the SAM/CloudFormation template automatically trigger rollback if the error threshold is breached. This is the most integrated and automated approach. Option A requires custom Lambda functions for promotion/rollback. Option C requires managing separate stages and Route 53 configuration. Option D adds unnecessary ALB complexity.

**Domain:** Domain 1 - SDLC Automation
</details>

---

### Question 16
A company operates in a regulated industry and must prove that all infrastructure changes are approved, audited, and traceable to a specific change request. The infrastructure is managed using CloudFormation. Which solution provides the MOST comprehensive audit trail for infrastructure changes?

**A)** Enable CloudTrail logging for CloudFormation API calls, store logs in a centralized S3 bucket with object lock, and use CloudTrail Lake for querying. Tag all CloudFormation stacks with the change request ID.
**B)** Use AWS Config to record all resource configuration changes and store the configuration history in S3.
**C)** Enable CloudFormation stack event notifications to an SNS topic and archive the notifications in S3.
**D)** Use a Git repository for CloudFormation templates with pull request approvals, and store the git commit hash in the CloudFormation stack description.

<details>
<summary>Answer</summary>

**Correct Answer: A**

**Explanation:** CloudTrail captures every CloudFormation API call (CreateStack, UpdateStack, DeleteStack) including who made the call, when, and with what parameters. Storing logs in S3 with Object Lock ensures immutability for regulatory compliance. CloudTrail Lake enables SQL-based querying of the audit trail. Tagging stacks with change request IDs links infrastructure changes to the change management system. Option B records what changed but not who initiated the CloudFormation operation. Option C only captures stack events, not the API-level details. Option D provides code-level audit but not deployment-level audit.

**Domain:** Domain 4 - Policies and Standards Automation
</details>

---

### Question 17
A DevOps team manages a multi-region application deployed using AWS CloudFormation StackSets. A recent deployment failed in one region due to a service limit, but succeeded in three other regions, leaving the application in an inconsistent state. Which combination of practices would BEST prevent this situation in the future? **(Choose TWO.)**

**A)** Configure the StackSet with `MaxConcurrentPercentage` set to 25% and `FailureToleranceCount` set to 0, so that a failure in any region stops the deployment.
**B)** Use CloudFormation StackSet `SEQUENTIAL` region deployment order and monitor the deployment in each region before proceeding.
**C)** Before deploying, use AWS Service Quotas API to programmatically verify that all target regions have sufficient service limits for the resources being deployed.
**D)** Deploy to all regions simultaneously to reduce the deployment window.
**E)** Use a single CloudFormation stack with conditions for each region instead of StackSets.

<details>
<summary>Answer</summary>

**Correct Answer: A, C**

**Explanation:** Setting `FailureToleranceCount` to 0 ensures that any failure immediately halts the StackSet operation, preventing inconsistent states across regions. Proactively checking service quotas before deployment catches potential limit issues before they cause failures. Option B (sequential deployment) slows down deployments but doesn't prevent the consistency issue since a failure mid-way still leaves some regions updated. Option D (simultaneous) is the opposite of safe deployment practices. Option E is not a viable architecture for multi-region deployments.

**Domain:** Domain 2 - Configuration Management and IaC
</details>

---

### Question 18
Which of the following is LEAST likely to be a benefit of using AWS CDK over raw CloudFormation templates?

**A)** The ability to use programming language constructs like loops, conditionals, and inheritance to generate infrastructure code.
**B)** Faster CloudFormation stack deployment times compared to raw CloudFormation templates.
**C)** Higher-level abstractions (L2 and L3 constructs) that set secure defaults and reduce boilerplate.
**D)** The ability to write unit tests for infrastructure code using standard testing frameworks.

<details>
<summary>Answer</summary>

**Correct Answer: B**

**Explanation:** CDK synthesizes to CloudFormation templates and deploys them using the same CloudFormation service, so there is no difference in deployment speed. In fact, CDK may add a small overhead for the synthesis step. Options A, C, and D are genuine benefits of CDK — programming constructs, high-level abstractions with secure defaults, and unit testing capability (e.g., using Jest or pytest with CDK assertions).

**Domain:** Domain 2 - Configuration Management and IaC
</details>

---

### Question 19
A company is implementing a multi-account strategy using AWS Organizations and AWS Control Tower. The DevOps team needs to ensure that all accounts have centralized logging, security guardrails, and standardized networking. Developer accounts should allow experimentation but production accounts must have strict change control. Which design BEST achieves this?

**A)** Create a flat organizational structure with all accounts at the root level and use IAM policies to differentiate between development and production accounts.
**B)** Create separate OUs for Sandbox, Development, Staging, and Production. Apply preventive guardrails (SCPs) to Production that restrict manual changes. Use detective guardrails across all OUs. Enable centralized logging to a dedicated Log Archive account.
**C)** Use a single account with separate VPCs for each environment and IAM permission boundaries to isolate workloads.
**D)** Create separate AWS Organizations for development and production environments with a shared services account in each.

<details>
<summary>Answer</summary>

**Correct Answer: B**

**Explanation:** AWS Control Tower's recommended multi-account architecture uses OUs to organize accounts by purpose. Different guardrails can be applied per OU — restrictive SCPs on Production prevent manual changes while Sandbox allows experimentation. A centralized Log Archive account (a Control Tower default) collects CloudTrail, Config, and other logs from all accounts. Detective guardrails monitor compliance across all environments. Option A lacks organizational hierarchy. Option C violates multi-account best practices. Option D creates management complexity with multiple organizations.

**Domain:** Domain 4 - Policies and Standards Automation
</details>

---

### Question 20
A DevOps engineer manages an application that uses Amazon CloudFront to serve a React single-page application from S3 and API calls from an ALB origin. Users report that after deployments, they see stale JavaScript bundles. Cache invalidation is currently done manually. The engineer wants to automate this process while minimizing unnecessary invalidation costs. Which approach is MOST cost-effective?

**A)** Create a CloudFront invalidation for `/*` after every deployment using a CodePipeline action.
**B)** Use versioned filenames for JavaScript bundles (e.g., `main.abc123.js`) and only invalidate `index.html` and `/service-worker.js` after deployment.
**C)** Set the CloudFront default TTL to 0 so all requests go to the origin.
**D)** Use Lambda@Edge to add `Cache-Control: no-cache` headers to all responses.

<details>
<summary>Answer</summary>

**Correct Answer: B**

**Explanation:** Versioned filenames (content hashing) ensure that new deployments serve new file URLs, making cache invalidation unnecessary for static assets. Only `index.html` (which references the versioned assets) and service workers need invalidation since they have fixed URLs. This minimizes invalidation costs (CloudFront charges per invalidation path after the first 1,000). Option A invalidates everything unnecessarily which is expensive. Option C eliminates caching benefits entirely. Option D adds latency and reduces cache hit ratios.

**Domain:** Domain 6 - High Availability, Fault Tolerance, and Disaster Recovery
</details>

---

### Question 21
A DevOps team has been asked to implement an automated security incident response for their AWS environment. When an IAM access key is found to be compromised, the system must automatically disable the key, isolate the associated IAM user, notify the security team, and capture forensic data. Which solution achieves this with the MOST automation?

**A)** Create an EventBridge rule triggered by GuardDuty findings of type `UnauthorizedAccess:IAMUser`, invoke a Step Functions state machine that disables the access key, attaches a deny-all IAM policy, sends an SNS notification, and creates a CloudTrail Lake query for the user's recent activity.
**B)** Have the security team monitor GuardDuty findings daily and manually disable compromised access keys.
**C)** Use AWS Config to detect IAM access key usage anomalies and trigger a Lambda function to rotate the key.
**D)** Create a CloudWatch alarm on IAM API call metrics and trigger an SNS notification to the security team for manual investigation.

<details>
<summary>Answer</summary>

**Correct Answer: A**

**Explanation:** This provides end-to-end automation. GuardDuty detects the compromise, EventBridge routes the finding, and Step Functions orchestrates the multi-step response (disable key, isolate user, notify, capture forensics). Step Functions is ideal here because it provides state management, error handling, and audit trail for the incident response workflow. Option B is entirely manual. Option C doesn't address the specific incident response workflow. Option D only notifies and doesn't automate remediation.

**Domain:** Domain 5 - Incident and Event Response
</details>

---

### Question 22
A company runs batch processing jobs on Amazon EC2 Spot Instances managed by an Auto Scaling group. The jobs are triggered every hour and take approximately 20 minutes to complete. Occasionally, Spot interruptions cause jobs to fail midway. The team needs to handle interruptions gracefully and ensure job completion. Which approach is MOST reliable? **(Choose TWO.)**

**A)** Subscribe to EC2 Spot Instance interruption notices via the instance metadata service and implement checkpointing in the application so jobs can resume from the last checkpoint on a new instance.
**B)** Use a mixed instances policy in the Auto Scaling group with multiple instance types and Availability Zones to reduce the probability of simultaneous interruptions.
**C)** Switch entirely to On-Demand instances to avoid interruption.
**D)** Set the Spot maximum price to the On-Demand price to prevent interruptions.
**E)** Run the jobs on AWS Lambda to avoid Spot interruption issues entirely.

<details>
<summary>Answer</summary>

**Correct Answer: A, B**

**Explanation:** Spot interruption notices give a 2-minute warning, allowing the application to checkpoint progress. When a new instance starts, the job can resume from the last checkpoint rather than restarting. Using a mixed instances policy with multiple instance types and AZs diversifies the Spot capacity pool, significantly reducing interruption probability. Option C eliminates cost savings. Option D doesn't prevent interruptions since Spot instances can be interrupted regardless of max price when capacity is unavailable. Option E has a 15-minute timeout limit which may not accommodate all batch jobs.

**Domain:** Domain 6 - High Availability, Fault Tolerance, and Disaster Recovery
</details>

---

### Question 23
Which of the following is NOT a valid deployment strategy supported natively by AWS CodeDeploy for Amazon ECS?

**A)** Blue/green deployment with linear traffic shifting (e.g., 10% every 5 minutes).
**B)** Blue/green deployment with canary traffic shifting (e.g., 10% for 10 minutes, then 100%).
**C)** Rolling update deployment that replaces tasks one at a time within the existing service.
**D)** Blue/green deployment with all-at-once traffic shifting.

<details>
<summary>Answer</summary>

**Correct Answer: C**

**Explanation:** AWS CodeDeploy for ECS only supports blue/green deployments where a new replacement task set is created alongside the original. Traffic can be shifted using linear, canary, or all-at-once configurations. Rolling updates are an ECS service-level deployment type managed by ECS itself, not by CodeDeploy. When you choose CodeDeploy as the deployment controller for an ECS service, rolling updates are not available — it's exclusively blue/green.

**Domain:** Domain 1 - SDLC Automation
</details>

---

### Question 24
A company needs to implement cross-region replication for critical data stored in multiple AWS services. The data includes DynamoDB tables, S3 buckets, and Amazon Aurora databases. The replication must support failover with minimal data loss. Which combination of replication strategies is CORRECT? **(Choose THREE.)**

**A)** Enable DynamoDB Global Tables to replicate data across regions with multi-active writes.
**B)** Configure S3 Cross-Region Replication (CRR) with S3 Replication Time Control (S3 RTC) for predictable replication within 15 minutes.
**C)** Create an Aurora Global Database with cross-region read replicas that can be promoted during failover.
**D)** Use AWS DMS to continuously replicate DynamoDB data to a DynamoDB table in the DR region.
**E)** Use S3 batch operations to periodically copy objects to the DR region on a daily schedule.
**F)** Take Aurora automated backups and copy them to the DR region.

<details>
<summary>Answer</summary>

**Correct Answer: A, B, C**

**Explanation:** DynamoDB Global Tables provide built-in multi-region, multi-active replication with sub-second latency. S3 CRR with RTC guarantees replication of 99.99% of objects within 15 minutes, providing predictable RPO. Aurora Global Database replicates data with typically less than 1-second lag and allows read replicas to be promoted to primary in the DR region. Option D is unnecessary since Global Tables handle DynamoDB replication natively. Option E has an unacceptable RPO of up to 24 hours. Option F (backup copy) has a higher RPO than Aurora Global Database.

**Domain:** Domain 6 - High Availability, Fault Tolerance, and Disaster Recovery
</details>

---

### Question 25
A DevOps engineer is implementing automated compliance reporting for PCI DSS requirements. The reports must show the compliance status of all resources, be generated monthly, and be stored immutably for 7 years. Which solution meets these requirements with the LEAST operational effort?

**A)** Use AWS Config conformance packs with PCI DSS rules, generate compliance reports using the Config API via a monthly Lambda function, and store reports in S3 with Object Lock in Governance mode for 7 years.
**B)** Write custom Lambda functions to check each PCI DSS requirement, store results in DynamoDB, and generate PDF reports using another Lambda function.
**C)** Use AWS Audit Manager with the PCI DSS framework, configure automated evidence collection, and generate monthly assessments stored in an S3 bucket with retention policies.
**D)** Hire a third-party auditor to manually verify compliance monthly and upload their reports to S3.

<details>
<summary>Answer</summary>

**Correct Answer: C**

**Explanation:** AWS Audit Manager is purpose-built for compliance reporting and auditing. It has a pre-built PCI DSS framework, automatically collects evidence from AWS Config, CloudTrail, and other sources, and generates assessment reports. Automated evidence collection and monthly assessment generation require minimal operational effort. Option A requires building the reporting layer. Option B requires extensive custom development. Option D is entirely manual and expensive. Audit Manager stores evidence in S3, which can be configured with Object Lock for immutability.

**Domain:** Domain 4 - Policies and Standards Automation
</details>

---

### Question 26
A DevOps engineer is troubleshooting intermittent 504 Gateway Timeout errors for an application running behind an Application Load Balancer with Amazon ECS Fargate tasks as targets. The errors happen randomly across all targets and last for 2-3 seconds. CloudWatch metrics show that target response time occasionally spikes to 60 seconds. Which troubleshooting steps should the engineer take? **(Choose TWO.)**

**A)** Check if the ECS tasks are reaching their CPU or memory limits during the timeouts, causing the application to become unresponsive.
**B)** Increase the ALB idle timeout to 120 seconds to accommodate the slow responses.
**C)** Analyze the application logs for the time periods when timeouts occur to identify slow database queries, external API calls, or resource contention that causes the latency spikes.
**D)** Increase the number of ECS tasks to handle more concurrent requests.
**E)** Change the target group health check interval to 5 seconds to detect unhealthy targets faster.

<details>
<summary>Answer</summary>

**Correct Answer: A, C**

**Explanation:** 504 errors from an ALB occur when the target doesn't respond within the idle timeout. Checking CPU/memory limits helps determine if resource exhaustion is causing the application to freeze. Analyzing application logs during timeout periods identifies the root cause (slow queries, external dependencies, etc.). Option B masks the problem rather than fixing it. Option D doesn't help if the issue is resource contention or slow dependencies within each task. Option E improves health check detection but doesn't fix the underlying timeout issue.

**Domain:** Domain 3 - Monitoring and Logging
</details>

---

### Question 27
A company uses AWS CodeBuild to build Docker images for 50 microservices. Each build takes approximately 10 minutes, with 6 minutes spent downloading base images and dependencies. The team wants to reduce build times significantly. Which approach provides the GREATEST reduction in build time?

**A)** Use CodeBuild caching with a local cache mode to cache Docker layers between builds and an S3 cache for source files and dependencies.
**B)** Use larger CodeBuild compute types to speed up the build process.
**C)** Pre-build a custom Docker base image containing all common dependencies, push it to Amazon ECR, and use it as the base image in all microservice Dockerfiles. Combine with Docker layer caching in CodeBuild.
**D)** Run builds in parallel across multiple CodeBuild projects.

<details>
<summary>Answer</summary>

**Correct Answer: C**

**Explanation:** Since 6 out of 10 minutes are spent downloading base images and dependencies, pre-building a custom base image with all common dependencies eliminates this bottleneck. Combined with Docker layer caching in CodeBuild, subsequent builds only need to build the application-specific layers, dramatically reducing build time. Option A helps with caching but still requires initial downloads. Option B uses faster machines but still downloads the same dependencies. Option D runs builds concurrently but doesn't reduce individual build times.

**Domain:** Domain 1 - SDLC Automation
</details>

---

### Question 28
A DevOps engineer needs to ensure that all Amazon S3 buckets in an organization deny any requests that do not use TLS encryption in transit. New buckets must automatically have this policy applied. Which is the MOST scalable approach?

**A)** Create an AWS Config rule to detect S3 buckets without the TLS policy and use automatic remediation with an SSM Automation document that adds a bucket policy denying non-TLS requests.
**B)** Use an SCP at the organization root that denies `s3:*` actions when `aws:SecureTransport` is false.
**C)** Create a Lambda function triggered by CloudTrail `CreateBucket` events that adds the TLS bucket policy to new buckets.
**D)** Include the TLS bucket policy in a CloudFormation template and deploy it using StackSets to all accounts.

<details>
<summary>Answer</summary>

**Correct Answer: B**

**Explanation:** An SCP with a condition denying S3 actions when `aws:SecureTransport` is false applies organization-wide to all accounts and all buckets, both existing and new. It's the most scalable because it's a single policy at the organization level, doesn't require per-bucket configuration, and can't be bypassed by individual accounts. Option A detects and remediates but has a time gap between bucket creation and remediation. Option C only handles new buckets. Option D requires managing StackSets and doesn't prevent non-TLS access between stack deployments.

**Domain:** Domain 4 - Policies and Standards Automation
</details>

---

### Question 29
A DevOps team operates a SaaS application with a PostgreSQL database on Amazon RDS. They need to perform a major PostgreSQL version upgrade (11 to 15) with minimal downtime. The database is 2 TB in size with heavy write traffic. Which approach minimizes downtime during the upgrade?

**A)** Use Amazon RDS Blue/Green Deployments to create a green environment with the new PostgreSQL version, let it replicate from the blue environment, validate, and then switch over.
**B)** Create a manual snapshot, restore it to a new RDS instance with the target version, and update the application connection string.
**C)** Perform an in-place major version upgrade by modifying the RDS instance's engine version.
**D)** Use AWS DMS to migrate data from the old instance to a new instance running PostgreSQL 15.

<details>
<summary>Answer</summary>

**Correct Answer: A**

**Explanation:** RDS Blue/Green Deployments create a staging environment (green) that stays synchronized with the production environment (blue) using logical replication. The green instance can run the new PostgreSQL version while continuously replicating changes from blue. After validation, the switchover typically completes in under a minute. Option B requires significant downtime for the snapshot restore and application cutover. Option C (in-place upgrade) causes extended downtime for a 2 TB database. Option D requires setting up and managing DMS replication tasks and has higher complexity.

**Domain:** Domain 6 - High Availability, Fault Tolerance, and Disaster Recovery
</details>

---

### Question 30
A company wants to implement a centralized logging solution for their multi-account AWS environment. Logs from CloudTrail, VPC Flow Logs, application logs, and AWS service logs must be aggregated in a central account. The logs must be searchable, have retention policies, and support real-time alerting. Which architecture provides the MOST comprehensive solution?

**A)** Send all logs to a centralized S3 bucket in the log archive account using cross-account policies, and use Amazon Athena for querying.
**B)** Configure CloudWatch Logs cross-account log sharing to send logs to a central monitoring account. Use CloudWatch Logs Insights for querying and CloudWatch alarms for alerting. Set retention policies on each log group.
**C)** Deploy Amazon OpenSearch Service in the central account. Use CloudWatch Logs subscription filters and Kinesis Data Firehose to stream logs from all accounts to OpenSearch. Use OpenSearch Dashboards for visualization and alerting.
**D)** Use AWS CloudTrail Lake for all log aggregation and querying.

<details>
<summary>Answer</summary>

**Correct Answer: C**

**Explanation:** Amazon OpenSearch Service provides powerful full-text search, real-time alerting, and rich dashboards through OpenSearch Dashboards (Kibana). Kinesis Data Firehose handles the cross-account log delivery reliably with buffering and transformation capabilities. Subscription filters on CloudWatch Logs groups in each account stream logs in near-real-time. This architecture supports all log types mentioned and provides the most comprehensive search and alerting capabilities. Option A lacks real-time alerting. Option B works but CloudWatch Logs Insights has query limitations compared to OpenSearch. Option D is only for CloudTrail events, not all log types.

**Domain:** Domain 3 - Monitoring and Logging
</details>

---

### Question 31
A DevOps engineer is implementing a CI/CD pipeline for a containerized application using Amazon ECR and Amazon EKS. The pipeline must build the Docker image, scan it for vulnerabilities, push it to ECR only if no critical vulnerabilities are found, and deploy to EKS using a Helm chart. Which pipeline design achieves this?

**A)** CodeCommit → CodeBuild (build image, push to ECR) → CodeBuild (scan using ECR image scanning) → CodeBuild (deploy Helm chart to EKS).
**B)** CodeCommit → CodeBuild (build image, run ECR enhanced scanning, fail build on critical findings, push to ECR on success) → CodeBuild (deploy Helm chart to EKS using `helm upgrade`).
**C)** CodeCommit → CodeBuild (build image, push to ECR) → Manual approval (security team reviews scan) → CodeBuild (deploy Helm chart to EKS).
**D)** CodeCommit → CodeBuild (build and push to ECR) → Lambda (scan image using Trivy) → CodeBuild (deploy to EKS).

<details>
<summary>Answer</summary>

**Correct Answer: B**

**Explanation:** Building the image first, running ECR enhanced scanning (which uses Amazon Inspector under the hood) and gating on the results before pushing to ECR ensures that only vulnerability-free images reach the registry. Failing the CodeBuild step on critical findings prevents the pipeline from proceeding. The subsequent CodeBuild step deploys using `helm upgrade` to the EKS cluster. Option A pushes the image to ECR before scanning, allowing vulnerable images in the registry. Option C requires manual intervention. Option D pushes first and then scans, similar to Option A.

**Domain:** Domain 1 - SDLC Automation
</details>

---

### Question 32
Which of the following scenarios would LEAST benefit from using AWS Step Functions for orchestration?

**A)** A multi-step order processing workflow that involves payment validation, inventory check, shipping notification, and order confirmation, with error handling and retry logic at each step.
**B)** A simple ETL pipeline that extracts data from S3, transforms it with a single Lambda function, and loads it into DynamoDB.
**C)** A machine learning pipeline that trains a model, evaluates accuracy, and conditionally deploys the model to SageMaker if accuracy exceeds a threshold.
**D)** A security incident response workflow that disables an IAM user, captures forensic data, notifies the security team, and creates a JIRA ticket.

<details>
<summary>Answer</summary>

**Correct Answer: B**

**Explanation:** A simple three-step ETL pipeline (extract, transform, load) with no branching, error handling complexity, or human intervention would benefit least from Step Functions. A single Lambda function or a simple S3 event trigger to Lambda is sufficient and less complex. Options A, C, and D all involve multiple steps with conditional logic, error handling, parallel execution, or human interaction — scenarios where Step Functions' visual workflow, state management, and built-in error handling provide significant value.

**Domain:** Domain 5 - Incident and Event Response
</details>

---

### Question 33
A DevOps team needs to implement automated testing for their CloudFormation templates before deploying to production. The tests should verify template syntax, check for security misconfigurations, validate that the templates create the expected resources, and test the actual deployment in an isolated environment. Which testing strategy covers ALL of these requirements? **(Choose TWO.)**

**A)** Use `cfn-lint` for template syntax validation and `cfn-nag` or Checkov for security misconfiguration scanning as part of the CodeBuild build phase.
**B)** Use CloudFormation change sets in production to preview changes before applying them.
**C)** Deploy the templates to a dedicated testing account using CloudFormation, run integration tests against the deployed resources, and then tear down the stack.
**D)** Use `aws cloudformation validate-template` as the only validation step.
**E)** Manually review all CloudFormation templates before deployment.

<details>
<summary>Answer</summary>

**Correct Answer: A, C**

**Explanation:** `cfn-lint` validates template syntax and catches common errors, while `cfn-nag`/Checkov scans for security misconfigurations (e.g., open security groups, unencrypted resources). These handle static analysis. Deploying to a testing account validates that templates create expected resources and verifies actual behavior in an isolated environment. Together they cover syntax, security, resource validation, and integration testing. Option B only shows what will change, not whether it's correct. Option D only validates basic JSON/YAML syntax. Option E doesn't scale and is error-prone.

**Domain:** Domain 2 - Configuration Management and IaC
</details>

---

### Question 34
A company is running an e-commerce platform with an Amazon Aurora MySQL database. During flash sales, the database experiences read replica lag and connection exhaustion. The application currently connects directly to the Aurora writer endpoint for both reads and writes. Which combination of solutions addresses BOTH issues? **(Choose TWO.)**

**A)** Implement Amazon RDS Proxy in front of the Aurora cluster to pool and share database connections, reducing connection exhaustion.
**B)** Implement read/write splitting in the application using the Aurora reader endpoint for read queries to offload the writer instance.
**C)** Increase the Aurora writer instance size to handle more connections.
**D)** Enable Aurora Auto Scaling for read replicas to automatically add replicas during high-traffic periods.
**E)** Switch to Amazon DynamoDB to eliminate connection management entirely.

<details>
<summary>Answer</summary>

**Correct Answer: A, B**

**Explanation:** RDS Proxy multiplexes and pools database connections, dramatically reducing the number of connections to the Aurora cluster and solving connection exhaustion. Read/write splitting directs read queries to Aurora read replicas via the reader endpoint, offloading the writer instance and reducing both connection pressure and read replica lag (since the writer is less burdened). Option C is expensive and doesn't address read traffic. Option D adds read replicas but doesn't solve connection exhaustion. Option E requires a complete application rewrite.

**Domain:** Domain 6 - High Availability, Fault Tolerance, and Disaster Recovery
</details>

---

### Question 35
A DevOps engineer is setting up monitoring for an Amazon EKS cluster. The team needs to monitor pod-level CPU and memory utilization, node-level metrics, control plane metrics, and application-specific custom metrics. Which combination provides the MOST complete monitoring solution? **(Choose TWO.)**

**A)** Enable Amazon CloudWatch Container Insights for EKS to collect pod-level and node-level CPU, memory, network, and disk metrics.
**B)** Use the Kubernetes Metrics Server with `kubectl top` commands for monitoring.
**C)** Deploy the AWS Distro for OpenTelemetry (ADOT) Collector as a DaemonSet to collect custom application metrics and Prometheus metrics, sending them to Amazon Managed Service for Prometheus and visualizing with Amazon Managed Grafana.
**D)** Use AWS CloudTrail to monitor EKS API calls for performance insights.
**E)** Install a self-managed Prometheus and Grafana stack on EC2 instances.

<details>
<summary>Answer</summary>

**Correct Answer: A, C**

**Explanation:** Container Insights provides comprehensive out-of-the-box metrics for pods, nodes, and the EKS control plane, including cluster-level dashboards in CloudWatch. ADOT as a DaemonSet collects custom application metrics and Prometheus-format metrics, which can be stored in Amazon Managed Prometheus and visualized with Managed Grafana. Together they cover infrastructure, Kubernetes, and custom application metrics. Option B only provides point-in-time metrics without historical data. Option D monitors API calls, not performance. Option E adds operational overhead of managing infrastructure.

**Domain:** Domain 3 - Monitoring and Logging
</details>

---

### Question 36
A DevOps engineer notices that CloudFormation stack updates are failing with the error "UPDATE_ROLLBACK_FAILED." The stack is stuck in this state and cannot be updated or deleted. The failure was caused by a resource that was manually deleted outside of CloudFormation. What is the correct procedure to recover?

**A)** Continue the update rollback using `aws cloudformation continue-update-rollback` with the `--resources-to-skip` parameter to skip the manually deleted resource.
**B)** Delete the entire AWS account and recreate the resources.
**C)** Create a new stack with the same resources using a different stack name.
**D)** Contact AWS Support to reset the stack state.

<details>
<summary>Answer</summary>

**Correct Answer: A**

**Explanation:** When a stack is stuck in `UPDATE_ROLLBACK_FAILED`, the `continue-update-rollback` API with `--resources-to-skip` tells CloudFormation to skip the problematic resources during rollback. This allows the rollback to complete, returning the stack to `UPDATE_ROLLBACK_COMPLETE` state. Once in this state, the engineer can update the stack (which will recreate the missing resource) or import the resource. Option B is extreme and unnecessary. Option C creates duplicate infrastructure. Option D is unnecessary when self-service options exist.

**Domain:** Domain 2 - Configuration Management and IaC
</details>

---

### Question 37
A company's security policy requires that all AWS Lambda functions must run inside a VPC, use encrypted environment variables, and have a maximum execution timeout of 5 minutes. The DevOps team needs to automatically detect and report any Lambda functions that violate these policies. Which approach is MOST effective?

**A)** Create custom AWS Config rules backed by Lambda functions that check each Lambda function's VPC configuration, KMS encryption for environment variables, and timeout setting. Use Config aggregator for multi-account visibility.
**B)** Use Amazon Inspector to scan Lambda functions for configuration violations.
**C)** Write a shell script that uses the AWS CLI to list all Lambda functions and check their configurations on a daily schedule.
**D)** Use IAM policies to prevent the creation of non-compliant Lambda functions.

<details>
<summary>Answer</summary>

**Correct Answer: A**

**Explanation:** Custom AWS Config rules provide continuous, automated compliance checking. Each rule evaluates Lambda function configurations against the security requirements. Config records configuration changes and evaluates compliance whenever a Lambda function is created or modified. Config aggregator provides a centralized view across multiple accounts. Option B (Inspector) focuses on code vulnerabilities and supported runtime analysis, not configuration policies. Option C is not real-time and requires managing infrastructure. Option D can prevent some configurations but IAM conditions cannot enforce all three requirements.

**Domain:** Domain 3 - Monitoring and Logging
</details>

---

### Question 38
A company runs a web application on Amazon EC2 instances behind an Application Load Balancer. During a recent performance review, the team identified that static assets (images, CSS, JavaScript) account for 70% of all requests and are being served directly by the EC2 instances. The application also serves dynamic API responses that vary by user. Which caching strategy provides the GREATEST performance improvement while maintaining correct dynamic content delivery?

**A)** Place Amazon CloudFront in front of the ALB. Configure a cache behavior for `/static/*` with a long TTL, and a separate cache behavior for `/api/*` with caching disabled and `Authorization` header forwarded.
**B)** Enable ALB response caching for all requests with a 1-hour TTL.
**C)** Add an Amazon ElastiCache Redis cluster and cache all HTTP responses at the application level.
**D)** Move all static assets to S3 and serve them directly from S3 without CloudFront.

<details>
<summary>Answer</summary>

**Correct Answer: A**

**Explanation:** CloudFront with path-based cache behaviors provides the optimal strategy. Static assets (`/static/*`) with long TTLs are served from edge locations globally, dramatically reducing load on EC2 instances and improving end-user latency. API paths have caching disabled and forward the `Authorization` header to ensure correct per-user dynamic responses. This offloads 70% of traffic from EC2. Option B doesn't exist — ALB doesn't have response caching. Option C caches at the application level but doesn't reduce incoming request load. Option D improves static serving but without CDN, doesn't improve global latency.

**Domain:** Domain 6 - High Availability, Fault Tolerance, and Disaster Recovery
</details>

---

### Question 39
A DevOps engineer needs to implement operational runbooks for common operational tasks such as restarting services, rotating credentials, and scaling resources. The runbooks must be executable, auditable, and support approval workflows for sensitive operations. Which AWS service is MOST appropriate?

**A)** AWS Systems Manager Automation documents (runbooks) with the approval action type for sensitive operations, integrated with CloudTrail for audit logging.
**B)** Store runbooks as Markdown documents in a wiki and have operators execute the steps manually.
**C)** Create Lambda functions for each operational task and trigger them from a custom web dashboard.
**D)** Use AWS Step Functions for all operational workflows with manual approval via callback tokens.

<details>
<summary>Answer</summary>

**Correct Answer: A**

**Explanation:** SSM Automation documents are purpose-built for operational runbooks. They support multi-step workflows, built-in approval actions that pause execution until an IAM principal approves, parameterized execution, role-based access, and full audit logging via CloudTrail. They integrate with other SSM capabilities like Run Command and Patch Manager. Option B is not automated or auditable. Option C requires custom development and lacks built-in approval workflows. Option D works but is more complex and expensive for common operational tasks that SSM handles natively.

**Domain:** Domain 5 - Incident and Event Response
</details>

---

### Question 40
Which of the following is NOT a valid use case for Amazon EventBridge?

**A)** Routing AWS service events (like EC2 state changes or CodePipeline execution changes) to targets like Lambda, SNS, or Step Functions.
**B)** Processing high-throughput streaming data at millions of events per second from IoT devices with ordering guarantees.
**C)** Scheduling automated tasks using cron or rate expressions to invoke Lambda functions or other targets.
**D)** Receiving events from SaaS partners like Zendesk, Datadog, or PagerDuty and routing them to AWS services for processing.

<details>
<summary>Answer</summary>

**Correct Answer: B**

**Explanation:** EventBridge is designed for event routing and orchestration, not high-throughput stream processing. For millions of events per second with ordering guarantees, Amazon Kinesis Data Streams is the appropriate service. EventBridge has throughput limits (varies by region, typically 10,000+ events/second with burst) and doesn't guarantee ordering. Options A, C, and D are all core EventBridge capabilities: service event routing, scheduled rules, and SaaS partner integrations.

**Domain:** Domain 5 - Incident and Event Response
</details>

---

### Question 41
A DevOps team is implementing a disaster recovery test automation for their multi-tier application. The test must simulate a complete regional failure, validate that failover works within the RTO, verify data integrity after failover, and generate a compliance report. The tests must run quarterly without human intervention. Which approach BEST achieves this?

**A)** Use AWS Fault Injection Simulator (FIS) to simulate regional failures, trigger the DR failover process via Route 53, validate the application using synthetic canaries in CloudWatch Synthetics, and generate the compliance report using a Step Functions workflow that orchestrates all steps.
**B)** Manually disable resources in the primary region quarterly and observe the failover behavior.
**C)** Use chaos engineering tools on EC2 instances to simulate failures at the instance level.
**D)** Document the DR procedure and review it quarterly without actually testing.

<details>
<summary>Answer</summary>

**Correct Answer: A**

**Explanation:** AWS FIS provides controlled fault injection that can simulate regional disruptions at the AWS service level. CloudWatch Synthetics canaries continuously test the application endpoint and verify functionality after failover. Step Functions orchestrates the entire test workflow: inject fault, wait for failover, run validation canaries, check data integrity, generate report. This can be scheduled to run quarterly via EventBridge. Option B is manual and risky. Option C only tests instance-level failures, not regional DR. Option D doesn't actually test the DR process.

**Domain:** Domain 6 - High Availability, Fault Tolerance, and Disaster Recovery
</details>

---

### Question 42
A DevOps engineer is deploying an application update to Amazon EC2 instances using AWS CodeDeploy with an in-place deployment. The deployment must update instances in three deployment groups sequentially: first the canary group (5% of instances), then the staging group (25% of instances), and finally the remaining instances. If any group shows errors, the deployment should stop. How should this be configured?

**A)** Create a single deployment group with a custom deployment configuration that deploys to 5%, then 25%, then the rest.
**B)** Create three separate deployment groups in CodeDeploy and use a CodePipeline with three sequential CodeDeploy deploy actions, each targeting a different deployment group. Add a CloudWatch alarm action between stages.
**C)** Create a single deployment group and use the `MinimumHealthyHosts` setting to control the rollout percentage.
**D)** Create three Auto Scaling groups and deploy to each one separately using three different CodeDeploy applications.

<details>
<summary>Answer</summary>

**Correct Answer: B**

**Explanation:** CodePipeline allows sequential deployment actions targeting different deployment groups. Each deploy action waits for completion before the next begins. CloudWatch alarms between stages (or CodeDeploy's built-in alarm integration) can halt the pipeline if errors are detected. This provides the graduated rollout with automatic stopping capability. Option A doesn't support the three-phase approach natively. Option C only controls how many instances stay healthy during deployment, not phased rollout. Option D unnecessarily creates separate ASGs and applications.

**Domain:** Domain 1 - SDLC Automation
</details>

---

### Question 43
A company is migrating from a monolithic application to microservices on Amazon ECS. During the transition, some services still run on the monolith while others have been extracted to ECS. API requests need to be routed to either the monolith or the appropriate microservice based on the URL path. The routing must support gradual traffic shifting during migration. Which solution BEST supports this migration pattern?

**A)** Use an Application Load Balancer with path-based routing rules that direct specific URL paths to ECS target groups and the default route to the monolith's target group. Use weighted target groups for gradual traffic shifting during migration.
**B)** Use Amazon API Gateway with resource-based routing to direct traffic to either the monolith or ECS services.
**C)** Deploy an Nginx reverse proxy on EC2 to handle path-based routing between the monolith and microservices.
**D)** Use Route 53 with different DNS records for each microservice.

<details>
<summary>Answer</summary>

**Correct Answer: A**

**Explanation:** ALB path-based routing natively supports directing specific URL paths to different target groups. As each microservice is extracted from the monolith, a new path-based rule directs traffic for that path to the ECS target group. Weighted target groups allow gradual traffic shifting from monolith to microservice for each path. The default rule continues sending unmatched paths to the monolith. Option B adds latency and cost unnecessarily. Option C requires managing additional infrastructure. Option D doesn't support path-based routing.

**Domain:** Domain 1 - SDLC Automation
</details>

---

### Question 44
Which of the following is LEAST likely to cause a CloudFormation stack to enter the `UPDATE_ROLLBACK_IN_PROGRESS` state?

**A)** A resource property value that doesn't meet service constraints (e.g., an invalid instance type).
**B)** Exceeding a service quota for the resource being created.
**C)** Adding a new tag to an existing S3 bucket in the template.
**D)** A circular dependency between resources in the template.

<details>
<summary>Answer</summary>

**Correct Answer: C**

**Explanation:** Adding a tag to an existing S3 bucket is a minor, non-disruptive update that is extremely unlikely to fail. Tags can be added to most resources without any disruption and don't require resource replacement. Options A (invalid property values), B (service quota exhaustion), and D (circular dependencies) are common causes of stack update failures that trigger rollbacks. Circular dependencies are actually caught during template validation, but if they occur during update due to dynamic references, they cause failures.

**Domain:** Domain 2 - Configuration Management and IaC
</details>

---

### Question 45
A company has implemented Amazon GuardDuty across all accounts in their AWS Organization. The security team wants to automate responses to different finding types. High-severity findings should trigger immediate automated remediation, medium-severity findings should create tickets for investigation, and low-severity findings should be aggregated in a weekly report. Which architecture supports this tiered response model? **(Choose TWO.)**

**A)** Use EventBridge rules with event patterns matching GuardDuty finding severities. Route high-severity events to a Step Functions state machine for automated remediation, and medium-severity events to a Lambda function that creates JIRA tickets.
**B)** Use a single Lambda function that processes all GuardDuty findings and determines the appropriate action based on severity.
**C)** For the weekly low-severity report, use a scheduled Lambda function that queries GuardDuty findings via the API, aggregates low-severity findings, and sends a summary to the security team via SES.
**D)** Configure GuardDuty to send all findings directly to an SQS queue for batch processing.
**E)** Use AWS Security Hub to aggregate all findings and manually review them weekly.

<details>
<summary>Answer</summary>

**Correct Answer: A, C**

**Explanation:** EventBridge provides native integration with GuardDuty and allows routing findings based on severity level using event patterns. High-severity findings are routed to Step Functions for complex automated remediation workflows. Medium-severity findings go to Lambda for ticket creation. A separate scheduled Lambda function handles the weekly aggregation of low-severity findings. Option B creates a monolithic function that's harder to maintain. Option D doesn't provide tiered routing. Option E requires manual review and doesn't automate responses.

**Domain:** Domain 5 - Incident and Event Response
</details>

---

### Question 46
A DevOps engineer is implementing a blue/green deployment for an application running on AWS Elastic Beanstalk. The application uses an Amazon RDS database. During the swap, the engineer needs to ensure that database connections are handled properly and that no data is lost. Which considerations are MOST important? **(Choose TWO.)**

**A)** Decouple the RDS instance from the Elastic Beanstalk environment so it is not tied to either the blue or green environment's lifecycle.
**B)** Ensure the application uses connection pooling and handles database connection interruptions gracefully during the CNAME swap.
**C)** Create a new RDS instance for the green environment and migrate data during the swap.
**D)** Use Elastic Beanstalk's built-in database migration tool to synchronize the databases.
**E)** Increase the RDS instance size before the swap to handle double the connections.

<details>
<summary>Answer</summary>

**Correct Answer: A, B**

**Explanation:** Decoupling RDS from Elastic Beanstalk is critical because if the database is created as part of the Beanstalk environment, terminating the old (blue) environment will delete the database. A decoupled RDS instance persists independently. Connection pooling and graceful reconnection handling are important because during the CNAME swap, some in-flight requests may experience connection interruptions. Option C is unnecessary if the database is decoupled since both environments share the same database. Option D doesn't exist. Option E is wasteful since both environments use the same database.

**Domain:** Domain 1 - SDLC Automation
</details>

---

### Question 47
A company wants to implement a transit gateway architecture to connect 20 VPCs across 4 AWS accounts. The architecture must support centralized internet egress through a shared services VPC, inter-VPC communication with fine-grained routing, and connectivity to an on-premises data center via AWS Direct Connect. Which of the following is NOT a required component of this architecture?

**A)** Transit Gateway route tables with separate route tables for different routing domains (e.g., shared services, production, development).
**B)** Transit Gateway attachments for each VPC and the Direct Connect Gateway.
**C)** VPC peering connections between all 20 VPCs for redundant connectivity.
**D)** Resource Access Manager (RAM) sharing of the Transit Gateway with all 4 accounts.

<details>
<summary>Answer</summary>

**Correct Answer: C**

**Explanation:** VPC peering is not needed when using Transit Gateway, as Transit Gateway provides transitive routing between all attached VPCs. Adding VPC peering on top would be redundant and create unnecessary complexity. Transit Gateway route tables (A) control traffic flow between segments. VPC attachments and Direct Connect Gateway attachment (B) connect the networks. RAM sharing (D) allows the Transit Gateway in one account to be used by VPCs in other accounts.

**Domain:** Domain 6 - High Availability, Fault Tolerance, and Disaster Recovery
</details>

---

### Question 48
A DevOps team needs to implement a solution that automatically scales Amazon ECS services based on custom business metrics (e.g., queue depth per active worker). CloudWatch doesn't have a built-in metric for this. Which approach enables custom metric-based auto scaling?

**A)** Publish a custom CloudWatch metric from the application that calculates queue depth divided by active worker count, then create an ECS Service Auto Scaling target tracking policy using this custom metric.
**B)** Use Step Scaling policies with CloudWatch alarms on the custom metric published by the application, with multiple step adjustments based on different threshold breaches.
**C)** Write a Lambda function on a schedule that checks the queue depth, calculates the desired task count, and calls the ECS `UpdateService` API directly.
**D)** Use AWS Application Auto Scaling with a Scheduled Scaling action based on known traffic patterns.

<details>
<summary>Answer</summary>

**Correct Answer: B**

**Explanation:** Step Scaling policies with CloudWatch alarms provide the most flexible auto scaling for custom metrics. The application publishes the custom metric (queue depth per worker), CloudWatch alarms trigger at different thresholds, and step scaling adjustments add or remove tasks proportionally. Target tracking (Option A) requires a specific metric format and behavior that may not fit a ratio metric well. Option C bypasses the Auto Scaling service and loses cooldown period management and scaling history. Option D is schedule-based and doesn't react to actual demand.

**Domain:** Domain 5 - Incident and Event Response
</details>

---

### Question 49
A DevOps engineer is implementing a solution to manage environment-specific configurations for a 12-factor application deployed to multiple environments (dev, staging, production) on Amazon ECS. The configurations include non-sensitive settings (feature flags, service URLs) and sensitive settings (database passwords, API keys). Which approach follows best practices?

**A)** Store all configurations in AWS Systems Manager Parameter Store with a hierarchical naming convention (e.g., `/app/dev/db-host`, `/app/prod/db-host`). Use SecureString for sensitive values. Inject parameters into ECS task definitions using the `secrets` and `environment` fields with `valueFrom` referencing the parameter ARN.
**B)** Bake all configurations into the Docker image for each environment.
**C)** Store configurations in a `.env` file in the application repository and copy it to the container at runtime.
**D)** Use environment-specific ECS task definitions with hardcoded values for each environment.

<details>
<summary>Answer</summary>

**Correct Answer: A**

**Explanation:** Parameter Store's hierarchical naming convention provides organized, environment-specific configuration management. SecureString parameters encrypt sensitive values with KMS. ECS natively integrates with Parameter Store via the `secrets` field in task definitions, injecting values at runtime without baking them into images. This follows the 12-factor app principle of storing config in the environment. Option B creates different images per environment, violating the "build once, deploy anywhere" principle. Option C exposes secrets in the repository. Option D requires maintaining multiple task definitions with hardcoded values.

**Domain:** Domain 2 - Configuration Management and IaC
</details>

---

### Question 50
A company needs to implement a solution that prevents accidental deletion of critical AWS resources (production RDS instances, S3 buckets with important data, and DynamoDB tables). The solution must work across all accounts in the organization. Which combination of techniques provides the MOST comprehensive protection? **(Choose THREE.)**

**A)** Enable termination protection on RDS instances and DynamoDB deletion protection on tables.
**B)** Apply S3 bucket policies that deny `s3:DeleteBucket` actions and enable MFA delete for versioned buckets.
**C)** Use SCPs at the organization level that deny deletion of resources tagged with `Environment: Production`.
**D)** Enable CloudFormation stack termination protection for all production stacks.
**E)** Create IAM policies that deny all delete actions for all users.
**F)** Disable the AWS Console for all users to prevent accidental clicks.

<details>
<summary>Answer</summary>

**Correct Answer: A, B, C**

**Explanation:** This creates defense-in-depth. Termination protection (A) provides resource-level protection requiring an explicit disable before deletion. S3 bucket policies with MFA delete (B) require multi-factor authentication for destructive operations. SCPs (C) provide organization-wide guardrails that prevent deletion of tagged production resources, even by account administrators. Option D only protects CloudFormation-managed resources. Option E would block all delete operations including non-production, causing operational issues. Option F is impractical.

**Domain:** Domain 4 - Policies and Standards Automation
</details>

---

### Question 51
A DevOps team operates a real-time data pipeline using Amazon Kinesis Data Streams. The pipeline processes 50,000 records per second with each record averaging 5 KB. Downstream Lambda consumers are experiencing throttling and data loss. Which approach resolves the throughput issue? **(Choose TWO.)**

**A)** Increase the number of Kinesis shards using the `UpdateShardCount` API and enable enhanced fan-out for the Lambda consumers.
**B)** Enable Kinesis Data Streams on-demand capacity mode to automatically manage shard capacity.
**C)** Increase the Lambda function memory to process records faster.
**D)** Switch from Kinesis Data Streams to Amazon SQS FIFO queues for higher throughput.
**E)** Reduce the batch size for the Lambda event source mapping.

<details>
<summary>Answer</summary>

**Correct Answer: A, B**

**Explanation:** Each Kinesis shard supports 1 MB/s input and 2 MB/s output. At 50,000 records × 5 KB = 250 MB/s, significantly more shards are needed. Enhanced fan-out provides 2 MB/s per consumer per shard using HTTP/2, eliminating consumer competition. Alternatively, on-demand capacity mode automatically scales shards based on traffic, eliminating manual shard management. Option C doesn't fix shard throughput limits. Option D (SQS FIFO) has lower throughput limits (300-3000 messages/second). Option E reduces throughput rather than increasing it.

**Domain:** Domain 5 - Incident and Event Response
</details>

---

### Question 52
A DevOps engineer is configuring AWS CloudWatch for a production application. The team needs to be alerted when the application's error rate exceeds 5% of total requests for more than 5 consecutive minutes, not just when the absolute error count is high. The metrics available are `RequestCount` and `ErrorCount`. Which CloudWatch feature should be used?

**A)** Create a CloudWatch Metric Math expression that calculates `(ErrorCount / RequestCount) * 100` and create an alarm on this expression with a threshold of 5 and a period of 5 minutes with 5 consecutive data points.
**B)** Create two separate alarms: one for `ErrorCount > 100` and one for `RequestCount < 2000`, and combine them with a composite alarm.
**C)** Create a CloudWatch anomaly detection alarm on the `ErrorCount` metric.
**D)** Use CloudWatch Logs Insights to query for errors and create an alarm based on the query results.

<details>
<summary>Answer</summary>

**Correct Answer: A**

**Explanation:** CloudWatch Metric Math allows creating expressions that combine multiple metrics. Dividing `ErrorCount` by `RequestCount` gives the error rate as a percentage. An alarm on this expression with 5 evaluation periods of 1 minute each (requiring all 5 to breach) provides the "5 consecutive minutes above 5%" behavior. Option B uses absolute thresholds which don't accurately represent the error rate. Option C detects anomalies but not a specific percentage threshold. Option D is designed for log analysis, not metric-based alerting.

**Domain:** Domain 3 - Monitoring and Logging
</details>

---

### Question 53
A company is implementing a CI/CD pipeline for AWS Lambda functions using AWS SAM. The team has 40 Lambda functions that share common utility code. When the shared code changes, all dependent functions must be redeployed. The team wants to minimize deployment time and avoid redundant deployments. Which approach is MOST efficient?

**A)** Package the shared code as a Lambda Layer, deploy it independently, and reference the layer ARN in each function's SAM template. Use a pipeline that detects changes in the shared code and only redeploys affected functions.
**B)** Copy the shared code into each Lambda function's deployment package.
**C)** Create a single monolithic Lambda function that contains all code.
**D)** Use Lambda extensions to load shared code at runtime from S3.

<details>
<summary>Answer</summary>

**Correct Answer: A**

**Explanation:** Lambda Layers allow sharing code across multiple functions without duplication. When the shared layer changes, it's deployed once as a new layer version. Functions that reference the layer only need to be updated to point to the new layer version, which is a lightweight configuration change. A pipeline with dependency detection avoids redeploying functions unaffected by the change. Option B causes code duplication across 40 packages. Option C violates single-responsibility principles. Option D adds startup latency and S3 dependency.

**Domain:** Domain 1 - SDLC Automation
</details>

---

### Question 54
A DevOps engineer is implementing centralized secrets rotation for a multi-account environment. The application in Account A needs to access an RDS database in Account B. The database credentials must be rotated every 30 days, and the application must always use the current credentials without downtime. Which architecture achieves this?

**A)** Store the database credentials in AWS Secrets Manager in Account B with automatic rotation enabled. Share the secret with Account A using a resource-based policy on the secret. The application in Account A retrieves the secret using the cross-account secret ARN.
**B)** Store the database credentials in AWS Secrets Manager in Account A and use a custom Lambda rotation function that connects to RDS in Account B to rotate the password.
**C)** Store the database credentials in Parameter Store in both accounts and use a Lambda function to synchronize them.
**D)** Hardcode the database credentials in the application and update them manually every 30 days.

<details>
<summary>Answer</summary>

**Correct Answer: A**

**Explanation:** Secrets Manager supports cross-account access via resource-based policies. Storing the secret in Account B (where the RDS instance lives) allows the built-in RDS rotation Lambda function to rotate the password directly since it has network access to the database. The resource-based policy grants Account A's application permission to retrieve the secret. The application always calls `GetSecretValue` which returns the current credentials. Option B requires a custom rotation function with cross-account VPC networking complexity. Option C requires synchronization logic and has race conditions. Option D is insecure and causes downtime during rotation.

**Domain:** Domain 4 - Policies and Standards Automation
</details>

---

### Question 55
Which of the following CloudWatch Logs features is NOT available for analyzing log data?

**A)** CloudWatch Logs Insights for interactive SQL-like querying of log data.
**B)** Metric filters to extract numeric values from log events and create CloudWatch metrics.
**C)** Subscription filters to stream log data in real-time to Kinesis, Lambda, or OpenSearch.
**D)** Automatic machine learning-based anomaly detection on log patterns without any configuration.

<details>
<summary>Answer</summary>

**Correct Answer: D**

**Explanation:** CloudWatch Logs does not provide automatic ML-based anomaly detection on log patterns without configuration. While CloudWatch has anomaly detection for metrics, log-level anomaly detection requires setting up CloudWatch Logs Anomaly Detection with specific log groups and pattern configuration. Options A (Logs Insights), B (Metric Filters), and C (Subscription Filters) are all standard CloudWatch Logs features that are available and commonly used for log analysis.

**Domain:** Domain 3 - Monitoring and Logging
</details>

---

### Question 56
A DevOps team is implementing a multi-region active-active architecture for a web application. Both regions must serve traffic simultaneously, and writes in one region must be visible in the other region within seconds. The application uses DynamoDB for data storage and S3 for static assets. Which architecture achieves this? **(Choose TWO.)**

**A)** Use DynamoDB Global Tables for multi-region, multi-active data replication with sub-second replication between regions.
**B)** Use S3 Cross-Region Replication with S3 Replication Time Control (RTC) to ensure static assets are available in both regions with predictable replication time.
**C)** Use a single DynamoDB table in one region and configure Global Accelerator to route all writes to that region.
**D)** Use AWS DataSync to synchronize S3 data between regions on an hourly schedule.
**E)** Deploy separate DynamoDB tables in each region and use a Lambda function to replicate data between them.

<details>
<summary>Answer</summary>

**Correct Answer: A, B**

**Explanation:** DynamoDB Global Tables provide built-in multi-region, multi-active replication. Writes to any replica table are propagated to all other replica tables typically within one second. S3 CRR with RTC ensures that 99.99% of objects are replicated within 15 minutes, and most objects are replicated much faster. Together they enable true active-active operations for both data and static assets. Option C makes it active-passive for writes. Option D's hourly schedule is too slow. Option E requires custom replication code with potential data consistency issues.

**Domain:** Domain 6 - High Availability, Fault Tolerance, and Disaster Recovery
</details>

---

### Question 57
A company wants to implement a solution where developers can provision pre-approved infrastructure resources without needing direct CloudFormation or Terraform access. The resources must be compliant with organizational standards, and the DevOps team wants to control which resources are available. Which approach is MOST appropriate?

**A)** Use AWS Service Catalog with portfolios and products. Create CloudFormation-based products with pre-approved templates, share portfolios with developer accounts, and use launch constraints to control the IAM role used during provisioning.
**B)** Give developers read-only access to CloudFormation and have them submit pull requests for infrastructure changes.
**C)** Create an internal web portal backed by Lambda functions that provision resources using the AWS SDK.
**D)** Give developers full CloudFormation access with permission boundaries that limit which resources they can create.

<details>
<summary>Answer</summary>

**Correct Answer: A**

**Explanation:** AWS Service Catalog provides a self-service portal where developers choose from pre-approved products (infrastructure templates). Portfolios organize products by team or use case. Launch constraints allow provisioning with elevated permissions while the developer only needs Service Catalog access. TagOptions enforce tagging standards. This provides the guardrails the DevOps team needs while empowering developers. Option B slows down developers. Option C requires building and maintaining a custom portal. Option D still requires CloudFormation knowledge and is harder to constrain.

**Domain:** Domain 2 - Configuration Management and IaC
</details>

---

### Question 58
A DevOps engineer is implementing canary analysis for an application deployed on Amazon ECS. The canary receives 5% of traffic and the analysis must compare the canary's error rate, latency percentiles (p50, p95, p99), and custom business metrics against the baseline. If the canary performs worse than the baseline by a statistically significant margin, the deployment should automatically roll back. Which approach provides the MOST rigorous canary analysis?

**A)** Use CloudWatch alarms on static thresholds for each metric and trigger rollback if any alarm fires.
**B)** Use Amazon CloudWatch Evidently to run the canary as a feature experiment. Define metrics (error rate, latency, business metrics) and let Evidently perform statistical analysis. Configure automatic rollback based on Evidently's statistical significance results.
**C)** Write a custom Lambda function that compares canary and baseline CloudWatch metrics using a t-test and triggers rollback via CodeDeploy if the p-value is below 0.05.
**D)** Monitor a CloudWatch dashboard manually during the canary period and decide whether to proceed.

<details>
<summary>Answer</summary>

**Correct Answer: B**

**Explanation:** CloudWatch Evidently is designed for feature experimentation and canary analysis. It performs statistical analysis comparing the treatment (canary) against the control (baseline), determining if differences are statistically significant. It supports custom metrics and provides automated actions based on results, including stopping the experiment (triggering rollback). Option A uses static thresholds without statistical comparison to baseline. Option C requires custom statistical implementation and maintenance. Option D is manual and subjective.

**Domain:** Domain 1 - SDLC Automation
</details>

---

### Question 59
A company must ensure that all CloudFormation deployments to production accounts go through an approval workflow. The workflow must include a code review of template changes, a security review, and a change advisory board (CAB) approval. If any step fails, the deployment must be blocked. Which solution implements this with the LEAST custom development?

**A)** Use AWS CodePipeline with a source stage from CodeCommit, a CodeBuild stage that runs cfn-lint and cfn-nag for security review, a manual approval stage for CAB approval, and a CloudFormation deploy stage with a change set review step.
**B)** Build a custom CI/CD system using Lambda functions and Step Functions to orchestrate the approval workflow.
**C)** Use GitHub Actions to run template checks and require manual approvals before merging to the main branch.
**D)** Implement a ServiceNow integration that creates change requests and automatically deploys after all approvals.

<details>
<summary>Answer</summary>

**Correct Answer: A**

**Explanation:** CodePipeline natively supports the required workflow. CodeCommit pull requests handle code review. CodeBuild with cfn-lint (syntax) and cfn-nag (security) automates security checks. The manual approval action implements CAB approval with SNS notifications and timeout settings. CloudFormation change sets provide a final review of actual changes before execution. This uses all AWS-native services with minimal custom code. Option B requires significant custom development. Option C doesn't integrate directly with CloudFormation deployment. Option D requires external tooling integration.

**Domain:** Domain 2 - Configuration Management and IaC
</details>

---

### Question 60
A company operates a data lake on Amazon S3 with petabytes of data. The data lake receives data from multiple sources via Kinesis Data Firehose. The team needs to detect and alert on data quality issues such as missing fields, schema changes, and duplicate records. Which solution provides the MOST comprehensive data quality monitoring?

**A)** Use AWS Glue Data Quality rules to define data quality checks, run them as part of Glue ETL jobs, publish quality scores as CloudWatch metrics, and create alarms for quality degradation.
**B)** Write custom Lambda functions to sample and validate data after each Firehose delivery.
**C)** Use Amazon Athena to run SQL queries that check for data quality issues on a daily schedule.
**D)** Use S3 event notifications to trigger a Lambda function that validates each object's schema against a predefined JSON schema.

<details>
<summary>Answer</summary>

**Correct Answer: A**

**Explanation:** AWS Glue Data Quality provides a rule-based framework for defining and enforcing data quality checks at scale. It can check for completeness (missing fields), consistency (schema validation), uniqueness (duplicate detection), and more. Quality scores are published as CloudWatch metrics enabling automated alerting. Integration with Glue ETL jobs means checks run as part of the data processing pipeline. Option B requires custom validation logic. Option C only detects issues retroactively and doesn't scale. Option D only validates schema, not data quality aspects like duplicates.

**Domain:** Domain 3 - Monitoring and Logging
</details>

---

### Question 61
A DevOps engineer needs to ensure high availability for an application that uses Amazon SQS as a decoupling mechanism between a producer running on ECS and consumers running on Lambda. During peak traffic, the SQS queue depth grows significantly and messages take too long to process. Which approach ensures messages are processed within the required 30-second SLA? **(Choose TWO.)**

**A)** Configure the Lambda function's SQS event source mapping with a maximum batching window and increased batch size, and increase the Lambda reserved concurrency to match expected peak throughput.
**B)** Increase the SQS message visibility timeout to prevent duplicate processing and enable long polling.
**C)** Switch from standard SQS to SQS FIFO for better message processing guarantees.
**D)** Configure Lambda to scale automatically by removing the reserved concurrency limit (use unreserved account concurrency) and set the `MaximumConcurrency` on the event source mapping.
**E)** Replace SQS with Amazon SNS for faster message delivery.

<details>
<summary>Answer</summary>

**Correct Answer: A, D**

**Explanation:** Lambda automatically scales with SQS by adding more concurrent executions as queue depth grows. Setting appropriate batch size and batching window optimizes throughput per invocation. Using `MaximumConcurrency` on the event source mapping (available since late 2022) allows controlled scaling without running into account-level concurrency limits. Reserved concurrency or `MaximumConcurrency` ensures predictable scaling. Option B helps with duplicate prevention but doesn't speed up processing. Option C reduces throughput due to FIFO ordering constraints. Option E eliminates the queue-based decoupling and back-pressure benefits.

**Domain:** Domain 5 - Incident and Event Response
</details>

---

### Question 62
A company has 200 EC2 instances running across 5 AWS accounts. The DevOps team needs to ensure all instances are patched within 48 hours of critical security patches being released. The patching must be scheduled during maintenance windows, support rollback if patching causes issues, and provide a compliance dashboard. Which solution is MOST comprehensive?

**A)** Use AWS Systems Manager Patch Manager with patch baselines, maintenance windows, and patch groups. Use SSM Compliance to generate compliance reports. Enable SSM State Manager to ensure the SSM agent is always running. Use CloudWatch dashboards for visibility.
**B)** Create a cron job on each instance to run `yum update` or `apt upgrade` nightly.
**C)** Use AWS Config to detect unpatched instances and trigger Lambda functions that SSH into instances to apply patches.
**D)** Use Amazon Inspector to identify missing patches and manually apply them.

<details>
<summary>Answer</summary>

**Correct Answer: A**

**Explanation:** SSM Patch Manager provides end-to-end patch management. Patch baselines define which patches to apply and when. Maintenance windows schedule patching during approved times. Patch groups organize instances by application or environment for targeted patching. SSM Compliance provides the dashboard showing patch compliance status. State Manager ensures agents remain connected. For rollback, instances can be snapshotted before patching via SSM Automation. Option B is unmanaged and has no compliance visibility. Option C is fragile and insecure (SSH). Option D only identifies but doesn't automate patching.

**Domain:** Domain 3 - Monitoring and Logging
</details>

---

### Question 63
A DevOps team wants to implement infrastructure as code testing for their Terraform modules. The testing strategy should include unit tests that don't require deploying resources, integration tests that deploy to a sandbox, and compliance tests that verify security standards. Which testing framework combination is MOST appropriate?

**A)** Use `terraform validate` and `terraform plan` for unit testing, Terratest (Go-based) for integration testing that deploys and validates real infrastructure, and Open Policy Agent (OPA) with Conftest for compliance policy testing against the Terraform plan output.
**B)** Use only `terraform validate` for all testing.
**C)** Manually review Terraform plans before applying.
**D)** Use AWS Config rules to detect non-compliant infrastructure after deployment.

<details>
<summary>Answer</summary>

**Correct Answer: A**

**Explanation:** This provides comprehensive testing at all levels. `terraform validate` checks syntax and internal consistency without requiring provider access. `terraform plan` output can be evaluated for expected resources without deploying. Terratest automates end-to-end testing by deploying infrastructure, running assertions, and destroying resources. OPA with Conftest evaluates Terraform plan JSON against policy rules (e.g., "all S3 buckets must have encryption enabled") before deployment. Option B only validates syntax. Option C doesn't scale. Option D only catches issues after deployment.

**Domain:** Domain 2 - Configuration Management and IaC
</details>

---

### Question 64
Which of the following scenarios would LEAST benefit from using Amazon RDS Proxy?

**A)** An application with many Lambda functions that create and destroy database connections frequently, causing connection churn on the RDS instance.
**B)** An application running on a single, long-running EC2 instance with a persistent connection pool to an RDS database serving low-traffic internal tools.
**C)** A multi-tenant SaaS application where each tenant has its own Lambda function and all connect to the same Aurora cluster.
**D)** An application that experiences traffic spikes causing the RDS instance to hit its maximum connection limit.

<details>
<summary>Answer</summary>

**Correct Answer: B**

**Explanation:** RDS Proxy provides the greatest benefit when there are many short-lived connections, connection churn, or connection exhaustion issues. A single EC2 instance with a persistent connection pool serving low traffic already manages connections efficiently and would see minimal benefit from RDS Proxy. Adding Proxy would only add latency and cost. Options A and C both involve Lambda functions that create/destroy connections frequently — exactly the scenario RDS Proxy is designed for. Option D directly addresses connection limit issues that Proxy solves through connection multiplexing.

**Domain:** Domain 6 - High Availability, Fault Tolerance, and Disaster Recovery
</details>

---

### Question 65
A DevOps engineer is implementing an automated incident response workflow for detecting and responding to unauthorized SSH access attempts on EC2 instances. The solution must detect brute-force attempts, block the attacking IP address, notify the security team, and log all actions taken. Which architecture provides the MOST automated response?

**A)** Configure Amazon GuardDuty to detect SSH brute-force findings (`UnauthorizedAccess:EC2/SSHBruteForce`), create an EventBridge rule to trigger a Step Functions workflow that updates the NACL to block the attacker IP, creates an SNS notification, and logs all actions to CloudWatch Logs.
**B)** Monitor VPC Flow Logs for high volumes of traffic on port 22 using a CloudWatch Logs metric filter and alarm that triggers an SNS notification.
**C)** Install fail2ban on all EC2 instances to block brute-force attempts locally.
**D)** Use AWS WAF to block SSH brute-force attempts at the network edge.

<details>
<summary>Answer</summary>

**Correct Answer: A**

**Explanation:** GuardDuty uses machine learning and threat intelligence to detect SSH brute-force attacks, providing high-fidelity findings with attacker IP addresses. EventBridge routes the finding to Step Functions, which orchestrates the multi-step response: blocking the IP via NACL update, notifying via SNS, and logging all actions. This provides comprehensive automation with audit trail. Option B detects traffic volume but can't distinguish legitimate SSH from brute-force. Option C is local to each instance and doesn't provide centralized response. Option D (WAF) operates at Layer 7 and doesn't protect SSH (Layer 4).

**Domain:** Domain 5 - Incident and Event Response
</details>

---

### Question 66
A DevOps team is deploying a new version of a Lambda function that processes records from a DynamoDB Stream. The function must process every record exactly once, and the new version introduces a change in the processing logic. If the new version has bugs, the team needs to revert quickly. Which deployment strategy minimizes the risk of data loss or duplicate processing?

**A)** Use Lambda aliases with weighted traffic shifting (CodeDeploy canary) to gradually shift DynamoDB Stream processing to the new version.
**B)** Deploy the new version and update the DynamoDB Stream event source mapping to use the new function version directly. If issues occur, update back to the old version.
**C)** Deploy the new version as a separate Lambda function and create a second DynamoDB Stream consumer, then remove the old consumer after validation.
**D)** Use Lambda versioning to publish the new version and update the alias used by the event source mapping. Configure the event source mapping's `FunctionResponseTypes` to include `ReportBatchItemFailures` for error handling.

<details>
<summary>Answer</summary>

**Correct Answer: D**

**Explanation:** Lambda versioning with aliases provides clean rollback by simply pointing the alias back to the previous version. `ReportBatchItemFailures` allows the function to report which specific records in a batch failed, so only failed records are retried rather than the entire batch, reducing duplicate processing. This is critical for stream processing where you need exactly-once semantics. Option A (weighted routing) doesn't work well with stream-based event sources since you can't split a stream between two function versions. Option C would cause duplicate processing since both consumers read the same stream. Option B works but lacks the partial failure handling.

**Domain:** Domain 1 - SDLC Automation
</details>

---

### Question 67
A DevOps engineer is implementing a cost-optimized CI/CD pipeline that builds, tests, and deploys applications. The pipeline runs 200 builds per day, each taking approximately 15 minutes. Most of the build time is spent running tests. The team wants to reduce pipeline costs while maintaining build speed. Which approach provides the GREATEST cost savings?

**A)** Use CodeBuild with a smaller compute type and accept slower builds.
**B)** Run CodeBuild on reserved capacity to get a discount for the predictable usage pattern. Use CodeBuild batch builds to run test suites in parallel across multiple smaller compute instances.
**C)** Migrate builds to a self-managed Jenkins server on a reserved EC2 instance.
**D)** Split the test suite into critical and non-critical tests. Run only critical tests in the pipeline and schedule non-critical tests as nightly batch runs.

<details>
<summary>Answer</summary>

**Correct Answer: B**

**Explanation:** CodeBuild reserved capacity provides significant discounts (up to 80%) for predictable build volumes. Batch builds split the test suite across multiple parallel compute environments, reducing wall-clock time while leveraging smaller (cheaper) instance types. Combined, this optimizes both cost and speed. Option A reduces cost but slows builds. Option C requires managing Jenkins infrastructure, and EC2 reserved instances may not be cheaper than CodeBuild reserved capacity once you factor in maintenance. Option D skips tests which could let bugs through.

**Domain:** Domain 1 - SDLC Automation
</details>

---

### Question 68
A company has implemented AWS Config across their organization. They need to ensure that the following are continuously monitored: all EBS volumes must be encrypted, all security groups must not allow ingress from 0.0.0.0/0 on port 22, and all IAM users must have MFA enabled. When non-compliance is detected, the team wants automatic remediation for the first two rules and a notification for the third. Which implementation is CORRECT?

**A)** Use AWS Config managed rules `encrypted-volumes`, `restricted-ssh`, and `mfa-enabled-for-iam-console-access`. Configure automatic remediation for the first two using SSM Automation documents (encrypt EBS via snapshot-copy-encrypt, and remove offending security group rules). Configure SNS notification for MFA non-compliance via EventBridge.
**B)** Write custom Lambda-backed Config rules for all three checks and custom remediation Lambda functions.
**C)** Use AWS Security Hub to aggregate findings and manually remediate non-compliant resources.
**D)** Use GuardDuty to detect non-compliant configurations and trigger auto-remediation.

<details>
<summary>Answer</summary>

**Correct Answer: A**

**Explanation:** AWS Config provides managed rules for all three requirements, eliminating custom rule development. Automatic remediation with SSM Automation documents can encrypt unencrypted EBS volumes (by creating an encrypted snapshot and replacing the volume) and remove unrestricted SSH rules from security groups. MFA requires human action (setting up an MFA device), so notification via EventBridge to SNS is the appropriate response. Option B requires unnecessary custom development when managed rules exist. Option C doesn't automate remediation. Option D is for threat detection, not configuration compliance.

**Domain:** Domain 3 - Monitoring and Logging
</details>

---

### Question 69
A DevOps team manages a fleet of 500 EC2 instances across multiple accounts. They need to implement a solution that ensures all instances have a specific set of software installed, configuration files in place, and services running. The desired state must be enforced continuously — if someone manually changes a configuration, it should be automatically reverted. Which solution provides continuous state enforcement?

**A)** Use AWS Systems Manager State Manager with SSM documents (Automation or Command documents) to define the desired state and associate them with managed instances. Configure the association schedule to run every 30 minutes.
**B)** Use AWS Config to detect configuration drift and trigger Lambda functions to fix it.
**C)** Create a golden AMI with all required software and relaunch instances when drift is detected.
**D)** Use Ansible Tower running on EC2 to continuously push configurations to all instances.

<details>
<summary>Answer</summary>

**Correct Answer: A**

**Explanation:** SSM State Manager is designed specifically for continuous state enforcement. Associations define the desired state (installed software, configuration files, running services) and SSM continuously ensures instances maintain that state. If someone manually changes a configuration, the next association run (every 30 minutes) reverts it. State Manager works across accounts with SSM's multi-account capabilities. Option B detects drift but requires custom remediation. Option C is extreme — you don't relaunch instances for config drift. Option D requires managing Ansible Tower infrastructure.

**Domain:** Domain 5 - Incident and Event Response
</details>

---

### Question 70
A company is implementing a zero-downtime database migration from a self-managed PostgreSQL database on EC2 to Amazon Aurora PostgreSQL. The application must remain operational throughout the migration, and the cutover window must be less than 1 minute. The database is 500 GB with continuous write traffic. Which migration strategy achieves this?

**A)** Use AWS Database Migration Service (DMS) with full load and change data capture (CDC) replication to Aurora. Monitor the replication lag until it reaches near-zero. During the cutover, stop writes to the source, wait for final CDC events to replicate, switch the application's database connection string to Aurora, and resume operations.
**B)** Take a pg_dump backup of the source database, restore it to Aurora, and switch the application connection string.
**C)** Set up native PostgreSQL logical replication from EC2 to Aurora, wait for the replica to catch up, then promote Aurora and switch the application.
**D)** Use AWS DataSync to copy the PostgreSQL data files to Aurora.

<details>
<summary>Answer</summary>

**Correct Answer: A**

**Explanation:** DMS with full load and CDC provides continuous replication from source to target. The full load copies the initial data while CDC captures ongoing changes. Once replication lag approaches zero, the cutover involves briefly stopping writes (seconds, not minutes), allowing final CDC events to replicate, and switching the connection string. This achieves sub-minute cutover. Option B requires downtime for the dump/restore of 500 GB. Option C works but DMS is the AWS-recommended approach and handles more edge cases. Option D cannot copy a live database's data files.

**Domain:** Domain 6 - High Availability, Fault Tolerance, and Disaster Recovery
</details>

---

### Question 71
A DevOps engineer is designing a notification strategy for a CI/CD pipeline. Different stakeholders need different notifications: developers need build failure details, QA needs deployment-to-staging notifications, operations needs production deployment results, and management needs weekly deployment frequency reports. Which architecture supports ALL these requirements with the LEAST operational overhead? **(Choose TWO.)**

**A)** Use CodePipeline event notifications via EventBridge. Create different EventBridge rules for each stakeholder group, filtering by pipeline stage and action status. Route developer notifications to a Slack channel via ChatBot, QA notifications to an SNS topic, and operations notifications to a PagerDuty integration.
**B)** Use CodeStar Notifications to configure notification rules for the CodePipeline, targeting different SNS topics for different event types.
**C)** For the weekly management report, schedule a Lambda function via EventBridge that queries the CodePipeline execution history API, aggregates deployment metrics, and sends a formatted report via SES.
**D)** Have each team member poll the CodePipeline console for updates.
**E)** Write a custom notification microservice that subscribes to all pipeline events and routes them to appropriate channels.

<details>
<summary>Answer</summary>

**Correct Answer: A, C**

**Explanation:** EventBridge provides granular event filtering and flexible target routing. Different rules can filter by stage (build, staging, production) and status (failed, succeeded) to route notifications to the appropriate stakeholder and channel. AWS Chatbot integrates EventBridge with Slack/Microsoft Teams natively. For the weekly report, a scheduled Lambda function can query pipeline execution history and generate aggregated metrics. Option B works for basic notifications but has less granular routing than EventBridge. Option D is manual. Option E requires building and maintaining custom infrastructure.

**Domain:** Domain 3 - Monitoring and Logging
</details>

---

### Question 72
A company needs to implement a solution for managing Terraform state files across multiple teams and environments. The state files must be encrypted, access-controlled per team, support state locking during applies, and be backed up. Which approach BEST meets these requirements?

**A)** Store Terraform state in Amazon S3 with server-side encryption (SSE-KMS), use DynamoDB for state locking, implement bucket policies and IAM policies that restrict each team to their environment's state file prefix, and enable S3 versioning for backup and recovery.
**B)** Store Terraform state files in a shared Git repository.
**C)** Use Terraform Cloud for state management.
**D)** Store state files locally on each developer's machine.

<details>
<summary>Answer</summary>

**Correct Answer: A**

**Explanation:** S3 as a Terraform backend with DynamoDB locking is the AWS-native approach that meets all requirements. SSE-KMS encryption protects state files that often contain sensitive data. DynamoDB provides state locking to prevent concurrent modifications. S3 bucket policies with prefix-based restrictions limit each team to their state files (e.g., `/team-a/prod/`, `/team-b/dev/`). S3 versioning maintains history of state file changes for backup and recovery. Option B exposes sensitive data in Git and doesn't support locking. Option C works but adds external dependency and cost. Option D has no collaboration, locking, or backup.

**Domain:** Domain 2 - Configuration Management and IaC
</details>

---

### Question 73
A DevOps team is troubleshooting an issue where an Auto Scaling group is rapidly launching and terminating EC2 instances (flapping). The instances pass the initial health check but are terminated within minutes. CloudWatch metrics show CPU and memory are within normal ranges. Which troubleshooting steps should the engineer take to identify the root cause? **(Choose TWO.)**

**A)** Check the Auto Scaling group's scaling policies to determine if a CloudWatch alarm is oscillating between ALARM and OK states, causing rapid scale-out and scale-in.
**B)** Check the Elastic Load Balancer health check settings — if the health check path returns errors intermittently, the ELB marks instances as unhealthy, causing ASG to terminate and replace them.
**C)** Increase the instance type to a larger size to provide more resources.
**D)** Disable Auto Scaling entirely until the issue is resolved.
**E)** Check the ASG lifecycle hooks to see if there's a hook that is timing out and causing instance termination.

<details>
<summary>Answer</summary>

**Correct Answer: A, B**

**Explanation:** Flapping is commonly caused by either oscillating scaling policies (where scale-out triggers cooldown, then scale-in triggers, creating a cycle) or ELB health check failures. If the health check path has intermittent errors (e.g., application initialization issues), the ELB marks instances unhealthy, ASG terminates them, launches new ones, which also fail health checks. Checking scaling activity history and ELB health check target response are the key diagnostic steps. Option C doesn't address the root cause. Option D stops the issue but doesn't fix it. Option E is possible but less common than A and B.

**Domain:** Domain 5 - Incident and Event Response
</details>

---

### Question 74
A company wants to implement a solution where every CloudFormation stack deployed in production must have specific tags (Owner, CostCenter, Environment), must not create public S3 buckets, and must not provision EC2 instances with public IP addresses. Which solution enforces these requirements BEFORE the stack is created? **(Choose TWO.)**

**A)** Create an SCP that denies `cloudformation:CreateStack` unless the request includes the required tags, and denies `s3:CreateBucket` when `s3:x-amz-acl` is `public-read`.
**B)** Use CloudFormation Guard rules to validate templates against the policies (required tags, no public S3, no public IPs) and run the validation as a CodeBuild step before deployment.
**C)** Use AWS Config rules to detect non-compliant resources after they are created.
**D)** Use CloudFormation hooks to validate resource properties against the policy requirements. Register the hooks to run as `preCreate` handlers that fail the stack creation if non-compliant resources are detected.
**E)** Implement the policies as IAM permission boundaries.

<details>
<summary>Answer</summary>

**Correct Answer: B, D**

**Explanation:** CloudFormation Guard is a policy-as-code tool that validates CloudFormation templates against rules before deployment, catching violations in the CI/CD pipeline before reaching AWS. CloudFormation Hooks run during stack operations and can block resource creation if the resource configuration violates policies — this provides a last line of defense even if the pipeline check is bypassed. Together they provide both shift-left validation and runtime enforcement. Option A (SCPs) can enforce some conditions but cannot inspect CloudFormation template contents. Option C only detects after creation. Option E (permission boundaries) don't validate resource configurations.

**Domain:** Domain 4 - Policies and Standards Automation
</details>

---

### Question 75
A company operates a critical application with a global user base. The application is deployed in us-east-1 (primary) and eu-west-1 (DR). The DR plan requires quarterly testing with automated verification. During the last DR test, the team discovered that several components had been added to the primary region but not to the DR region's CloudFormation templates. The DNS failover also took longer than expected due to TTL issues. Which combination of improvements addresses ALL of these issues? **(Choose THREE.)**

**A)** Use CloudFormation StackSets to deploy the same templates to both regions simultaneously, ensuring parity between primary and DR infrastructure.
**B)** Reduce the Route 53 health check interval to 10 seconds and set the TTL on failover DNS records to 60 seconds or less.
**C)** Implement an automated DR test using AWS Fault Injection Simulator (FIS) and Step Functions that runs quarterly, validates all components in the DR region, compares resource inventories between regions, and generates a compliance report.
**D)** Manually verify DR readiness by reviewing documentation before each quarterly test.
**E)** Add more regions to the DR strategy to improve coverage.
**F)** Use Global Accelerator instead of Route 53 for failover, since Global Accelerator can shift traffic within seconds without depending on DNS TTL propagation.

<details>
<summary>Answer</summary>

**Correct Answer: A, C, F**

**Explanation:** StackSets ensure both regions always have identical infrastructure by deploying from the same templates, preventing the DR drift problem. Automated DR testing with FIS and Step Functions provides quarterly validation with resource inventory comparison to catch any discrepancies. Global Accelerator routes traffic at the network layer using anycast IP addresses, providing near-instant failover (within seconds) without depending on DNS TTL propagation delays. Option B improves but doesn't eliminate TTL issues since clients may cache DNS beyond the TTL. Option D is manual and error-prone. Option E adds complexity without addressing the identified issues.

**Domain:** Domain 6 - High Availability, Fault Tolerance, and Disaster Recovery
</details>

---

## Answer Key

| Q | Ans | Domain | Q | Ans | Domain | Q | Ans | Domain |
|---|-----|--------|---|-----|--------|---|-----|--------|
| 1 | B | D1 | 26 | A,C | D3 | 51 | A,B | D5 |
| 2 | A | D2 | 27 | C | D1 | 52 | A | D3 |
| 3 | B | D1 | 28 | B | D4 | 53 | A | D1 |
| 4 | B | D4 | 29 | A | D6 | 54 | A | D4 |
| 5 | D | D6 | 30 | C | D3 | 55 | D | D3 |
| 6 | B | D1 | 31 | B | D1 | 56 | A,B | D6 |
| 7 | A,C | D4 | 32 | B | D5 | 57 | A | D2 |
| 8 | A | D5 | 33 | A,C | D2 | 58 | B | D1 |
| 9 | B | D2 | 34 | A,B | D6 | 59 | A | D2 |
| 10 | B | D1 | 35 | A,C | D3 | 60 | A | D3 |
| 11 | A,C | D3 | 36 | A | D2 | 61 | A,D | D5 |
| 12 | A | D1 | 37 | A | D3 | 62 | A | D3 |
| 13 | A | D2 | 38 | A | D6 | 63 | A | D2 |
| 14 | C | D6 | 39 | A | D5 | 64 | B | D6 |
| 15 | B | D1 | 40 | B | D5 | 65 | A | D5 |
| 16 | A | D4 | 41 | A | D6 | 66 | D | D1 |
| 17 | A,C | D2 | 42 | B | D1 | 67 | B | D1 |
| 18 | B | D2 | 43 | A | D1 | 68 | A | D3 |
| 19 | B | D4 | 44 | C | D2 | 69 | A | D5 |
| 20 | B | D6 | 45 | A,C | D5 | 70 | A | D6 |
| 21 | A | D5 | 46 | A,B | D1 | 71 | A,C | D3 |
| 22 | A,B | D6 | 47 | C | D6 | 72 | A | D2 |
| 23 | C | D1 | 48 | B | D5 | 73 | A,B | D5 |
| 24 | A,B,C | D6 | 49 | A | D2 | 74 | B,D | D4 |
| 25 | C | D4 | 50 | A,B,C | D4 | 75 | A,C,F | D6 |

## Domain Distribution Summary

| Domain | Target | Actual |
|--------|--------|--------|
| Domain 1 - SDLC Automation | ~17 | 17 |
| Domain 2 - Configuration Management and IaC | ~13 | 13 |
| Domain 3 - Monitoring and Logging | ~11 | 11 |
| Domain 4 - Policies and Standards Automation | ~7 | 7 |
| Domain 5 - Incident and Event Response | ~13 | 13 |
| Domain 6 - High Availability, Fault Tolerance, and DR | ~14 | 14 |
| **Total** | **75** | **75** |

## Special Question Types

**"Choose TWO/THREE" Questions (15):** Q7, Q11, Q17, Q22, Q24, Q26, Q33, Q34, Q35, Q45, Q50, Q56, Q61, Q71, Q73

**"NOT/LEAST" Questions (10):** Q18, Q23, Q32, Q40, Q44, Q47, Q55, Q64, Q74 (partial), Q75 (partial)
