# AWS SAP-C02 Practice Test 05

**Focus Areas:** Multi-Account Governance, Containers (ECS/EKS), Step Functions, Performance Optimization

**Total Questions: 75** | **Time: 180 minutes**

Domain Distribution: D1 (Organizational Complexity) ~20 | D2 (New Solutions) ~22 | D3 (Continuous Improvement) ~11 | D4 (Migration & Modernization) ~9 | D5 (Cost Optimization) ~13

---

### Question 1
A financial services company operates 120 AWS accounts organized under AWS Organizations. The security team requires that all new accounts automatically have VPC flow logs enabled, AWS Config enabled with a standard set of rules, and an IAM role for the central security team. Currently, these steps are performed manually when accounts are provisioned. A solutions architect needs to automate this process.

A) Use AWS CloudFormation StackSets with service-managed permissions to deploy the required resources across all accounts in the organization, targeting the organization root  
B) Create an AWS Service Catalog product with a CloudFormation template that provisions the required resources, and require all account owners to launch it  
C) Write an AWS Lambda function triggered by the CreateAccountResult event from AWS Organizations via Amazon EventBridge that deploys a CloudFormation stack in the new account using a cross-account role  
D) Use AWS Control Tower Account Factory to provision accounts and add customizations through an AWS Control Tower lifecycle event that triggers a Lambda function to deploy resources  

**Correct Answer: C**
**Explanation:** Option C provides the most direct and reliable automation. When a new account is created in AWS Organizations, the `CreateAccountResult` event is emitted to EventBridge. A Lambda function can assume the `OrganizationAccountAccessRole` (automatically created in new accounts) to deploy a CloudFormation stack with VPC flow logs, AWS Config, and the security IAM role. Option A (StackSets) works for existing accounts but doesn't automatically trigger for new accounts without additional automation. Option B requires manual action from account owners, which doesn't meet the automation requirement. Option D would work if they used Control Tower, but the question states they use AWS Organizations directly, not Control Tower.

---

### Question 2
A company runs a containerized microservices application on Amazon ECS with AWS Fargate. The application consists of 15 services, each with different CPU and memory requirements. During peak hours, some services experience latency spikes because tasks take too long to start. The company wants to minimize cold start times while keeping costs manageable.

A) Migrate all services to Amazon ECS on EC2 with a capacity provider strategy using a mix of On-Demand and Spot instances  
B) Enable Fargate Spot for all services and increase the desired task count to maintain a buffer of running tasks  
C) Implement ECS Service Connect with pre-provisioned Fargate capacity reservations for latency-sensitive services while using standard Fargate for others  
D) Configure ECS service auto scaling with target tracking on CPU utilization and set a higher minimum task count for latency-sensitive services  

**Correct Answer: D**
**Explanation:** Option D addresses the cold start problem by maintaining a higher baseline of running tasks for latency-sensitive services through a higher minimum task count, combined with target tracking auto scaling to handle peaks efficiently. This avoids cold starts by always having tasks ready. Option A introduces management overhead with EC2 instances and Spot interruptions. Option B uses Fargate Spot which can be interrupted with only 2 minutes notice, worsening the latency problem. Option C mentions "Fargate capacity reservations" which is not a real Fargate feature — ECS Service Connect is a service mesh capability, not a capacity reservation mechanism.

---

### Question 3
An enterprise uses a multi-account strategy with separate accounts for development, staging, and production across three business units. They need a centralized networking model where all accounts share a common set of subnets, and a central network team manages VPCs, route tables, and security groups. Inter-account traffic should not traverse the public internet.

A) Create VPCs in each account and establish VPC peering connections between all accounts in a full mesh topology  
B) Use AWS Resource Access Manager (RAM) to share subnets from a central networking account with participating accounts using AWS Transit Gateway for inter-VPC routing  
C) Deploy a hub-and-spoke model using AWS Transit Gateway in the central networking account and create VPC attachments from each account's VPC  
D) Use AWS Resource Access Manager (RAM) to share subnets from VPCs in a central networking account with all participating accounts, eliminating the need for per-account VPCs  

**Correct Answer: D**
**Explanation:** Option D is the best answer. AWS RAM allows sharing subnets from a central networking account with other accounts. Participating accounts launch resources directly into shared subnets managed by the central network team, eliminating the need for individual VPCs in each account. This provides centralized network management and keeps traffic within the VPC (no internet traversal). Option B combines RAM shared subnets with Transit Gateway, but Transit Gateway is unnecessary when accounts share the same VPC subnets — traffic stays within the VPC. Option C requires each account to have its own VPC, adding management overhead. Option A creates a full mesh of peering connections which doesn't scale and doesn't centralize management.

---

### Question 4
A company is building a document processing pipeline using AWS Step Functions. The workflow receives PDF documents, extracts text using Amazon Textract, classifies the document using Amazon Comprehend, stores metadata in Amazon DynamoDB, and archives the original in Amazon S3 Glacier. Some documents are over 100 pages and Textract processing can take up to 15 minutes. The workflow must handle failures gracefully and allow reprocessing of individual failed documents.

A) Use a Standard Step Functions workflow with asynchronous Textract API calls using a task token pattern (.waitForTaskToken), implement retry with exponential backoff on each state, and use a catch block to route failures to a dead letter queue  
B) Use an Express Step Functions workflow with synchronous Textract calls and set the workflow timeout to 30 minutes  
C) Use a Standard Step Functions workflow with synchronous Textract calls and implement a Wait state with a loop to poll for completion  
D) Use a Standard Step Functions workflow calling Textract synchronously, with a Map state to process pages in parallel and a global error handler  

**Correct Answer: A**
**Explanation:** Option A is correct. Standard workflows support long-running executions (up to 1 year). The `.waitForTaskToken` integration pattern is ideal for asynchronous operations like Textract's asynchronous document analysis, which sends a completion notification via SNS/SQS that can resume the Step Function. Retry with exponential backoff handles transient failures, and catch blocks route persistent failures to a DLQ for reprocessing. Option B uses Express workflows which have a maximum duration of 5 minutes, insufficient for 15-minute Textract jobs. Option C uses polling which wastes state transitions and costs more. Option D calls Textract synchronously which would time out for large documents since synchronous API calls in Step Functions have a shorter timeout.

---

### Question 5
A media company stores petabytes of video content across multiple S3 buckets in us-east-1. They are expanding to serve customers in Europe and Asia-Pacific and need to deliver content with low latency globally. The content is read-heavy with infrequent updates. They want to minimize data transfer costs while maintaining a single source of truth in us-east-1.

A) Enable S3 Cross-Region Replication to buckets in eu-west-1 and ap-southeast-1, and use Amazon CloudFront with origin groups pointing to regional buckets  
B) Use Amazon CloudFront with the us-east-1 S3 bucket as the origin, enable Origin Shield in a region closest to the origin, and configure appropriate cache TTLs  
C) Create S3 Multi-Region Access Points and use Amazon CloudFront with the Multi-Region Access Point as the origin  
D) Use AWS Global Accelerator to route requests to the nearest S3 bucket with S3 Cross-Region Replication enabled to all target regions  

**Correct Answer: B**
**Explanation:** Option B is the most cost-effective solution. CloudFront caches content at edge locations globally, reducing latency for read-heavy workloads. Origin Shield adds a centralized caching layer that reduces origin requests, lowering data transfer costs. Since content is read-heavy with infrequent updates, aggressive cache TTLs maximize hit rates. This maintains a single source of truth in us-east-1 without replication costs. Option A works but introduces replication costs for petabytes of data across regions — expensive and unnecessary given CloudFront's caching effectiveness. Option C adds replication overhead; S3 Multi-Region Access Points with replication would also replicate petabytes of data. Option D doesn't help because Global Accelerator optimizes TCP/UDP connections, not content caching, and S3 CRR across all regions is expensive.

---

### Question 6
A healthcare company needs to deploy a HIPAA-compliant container workload on AWS. The application requires persistent storage, secrets management, and the ability to run on infrastructure that is dedicated solely to their organization. They also need fine-grained pod-level security policies and integration with their existing Kubernetes tooling.

A) Deploy on Amazon EKS with Fargate profiles, use AWS Secrets Manager for secrets, and Amazon EFS for persistent storage  
B) Deploy on Amazon EKS with dedicated EC2 instances (Dedicated Hosts), use Kubernetes Secrets encrypted with AWS KMS via envelope encryption, Amazon EBS CSI driver for persistent storage, and implement Pod Security Policies  
C) Deploy on Amazon ECS with EC2 launch type on Dedicated Instances, use AWS Systems Manager Parameter Store for secrets, and Amazon EFS for persistent storage  
D) Deploy on Amazon EKS Anywhere on-premises with their existing hardware, use HashiCorp Vault for secrets, and local NFS storage  

**Correct Answer: B**
**Explanation:** Option B meets all requirements. Amazon EKS provides Kubernetes compatibility for existing tooling. Dedicated Hosts ensure single-tenant hardware for HIPAA isolation requirements. KMS-encrypted Kubernetes Secrets provide proper secrets management. EBS CSI driver provides persistent block storage, and Pod Security Policies enable fine-grained pod-level security. Option A uses Fargate which runs on shared infrastructure (though it is HIPAA-eligible, it doesn't provide hardware dedicated solely to the organization as required). Option C uses ECS which doesn't integrate with existing Kubernetes tooling. Option D moves the workload off AWS, doesn't leverage AWS managed services, and doesn't meet the requirement for running on AWS.

---

### Question 7
A retail company processes millions of orders daily. They use an AWS Step Functions workflow that orchestrates order validation, payment processing, inventory reservation, and shipping notification. They need to add a new requirement: if payment processing fails after inventory has been reserved, the inventory reservation must be automatically rolled back. The workflow must implement this compensation logic reliably.

A) Implement the Saga pattern in Step Functions using a series of Choice states that check for payment failure and route to compensating Lambda functions that reverse the inventory reservation  
B) Use Step Functions with a Parallel state to run payment processing and inventory reservation simultaneously, with error handling on the Parallel state  
C) Implement the Saga pattern using Step Functions with Catch blocks on the payment processing state that trigger compensating transactions (inventory release), and store the workflow state in DynamoDB for audit  
D) Use Amazon SQS FIFO queues between each step instead of Step Functions to ensure ordered processing with dead letter queues for failure handling  

**Correct Answer: C**
**Explanation:** Option C correctly implements the Saga pattern, which is the standard approach for distributed transactions requiring compensation. The Catch block on the payment processing state automatically triggers compensating transactions (releasing reserved inventory) when payment fails. Storing workflow state in DynamoDB provides an audit trail. Option A uses Choice states for error routing, which is less reliable than Catch blocks because Choice states evaluate data conditions, not exceptions — a payment exception wouldn't flow through a Choice state properly. Option B runs payment and inventory in parallel, but the requirement is sequential (reserve inventory first, then process payment). Option D replaces Step Functions with SQS, losing workflow orchestration visibility and making compensation logic much harder to implement.

---

### Question 8
A company has 50 AWS accounts under AWS Organizations. The central IT team wants to ensure that no account can launch EC2 instances outside of approved regions (us-east-1, us-west-2, and eu-west-1). They also need exceptions for global services like IAM, CloudFront, and Route 53. The solution must prevent even account administrators from circumventing this restriction.

A) Create IAM policies in each account that deny EC2 actions outside the approved regions and attach them to all IAM users and roles  
B) Implement a Service Control Policy (SCP) at the organization root that denies all actions outside the approved regions with conditions excluding global services, and attach it to all OUs except the management account  
C) Use AWS Config rules to detect EC2 instances launched in non-approved regions and automatically terminate them using AWS Systems Manager Automation  
D) Deploy AWS CloudFormation Guard rules to prevent CloudFormation templates from specifying non-approved regions  

**Correct Answer: B**
**Explanation:** Option B is correct. SCPs are the only mechanism that can restrict actions across all principals in an account, including account administrators. The SCP can use `aws:RequestedRegion` condition key to deny actions outside approved regions while using `NotAction` or condition key exceptions for global services (IAM, CloudFront, Route 53, etc.). SCPs cannot be overridden by account-level IAM policies. Option A can be circumvented by account administrators who can modify or remove IAM policies. Option C is reactive, not preventive — instances would briefly exist in non-approved regions before termination. Option D only covers CloudFormation deployments, not console or CLI launches.

---

### Question 9
A SaaS company runs a multi-tenant application on Amazon EKS. Each tenant's workload runs in a dedicated Kubernetes namespace. The company needs to ensure network isolation between tenants, limit resource consumption per tenant, and provide tenant-specific logging. They have 200+ tenants and need a scalable solution.

A) Use Kubernetes NetworkPolicies with a Calico CNI plugin for network isolation, ResourceQuotas per namespace for resource limits, and Fluent Bit DaemonSet with namespace-based routing to separate CloudWatch log groups  
B) Create separate EKS clusters per tenant for complete isolation, each with its own logging configuration  
C) Use AWS App Mesh for network isolation between namespaces, Kubernetes LimitRanges for resource limits, and Amazon CloudWatch Container Insights for logging  
D) Deploy each tenant in a separate Fargate profile with dedicated subnets, use security groups for isolation, and enable Fargate logging to separate S3 buckets  

**Correct Answer: A**
**Explanation:** Option A provides a scalable multi-tenant architecture. Calico NetworkPolicies enforce network isolation between namespaces (blocking cross-namespace traffic). ResourceQuotas limit CPU, memory, and object counts per namespace, preventing noisy neighbors. Fluent Bit can route logs based on namespace metadata to separate CloudWatch log groups per tenant. This scales to 200+ tenants on a single cluster. Option B creates 200+ separate clusters which is operationally expensive and doesn't scale. Option C uses App Mesh which is a service mesh for traffic management, not network isolation — it doesn't prevent pod-to-pod communication across namespaces. Option D with Fargate profiles doesn't support Calico NetworkPolicies and has limitations on DaemonSets for logging.

---

### Question 10
A company is migrating their on-premises batch processing system to AWS. The system processes financial reports nightly, with each batch taking 2-4 hours. The process involves: (1) downloading files from SFTP servers, (2) validating and transforming data, (3) loading into a data warehouse, and (4) generating summary reports. Each step must complete before the next begins, and the entire workflow must be monitored with alerts on failure.

A) Use Amazon MWAA (Managed Workflows for Apache Airflow) to orchestrate the batch workflow with DAGs defining task dependencies, Amazon CloudWatch for monitoring, and SNS for failure alerts  
B) Use AWS Step Functions with a sequential state machine, Lambda functions for each step, and CloudWatch Alarms for monitoring  
C) Create an Amazon EventBridge scheduled rule that triggers a series of Lambda functions chained through SNS topics  
D) Use AWS Batch with job dependencies to define the sequential workflow and CloudWatch Events for monitoring  

**Correct Answer: A**
**Explanation:** Option A is the best choice for a complex batch processing workflow. Apache Airflow (MWAA) is purpose-built for orchestrating batch workflows with dependencies, supports long-running tasks (2-4 hours), provides built-in monitoring dashboards, retries, and alerting. DAGs clearly define task dependencies and order. Option B uses Lambda which has a 15-minute execution timeout, insufficient for 2-4 hour processing steps. Option C creates a fragile chain of Lambda functions with the same timeout limitation. Option D could work for the compute portion but AWS Batch is primarily for containerized batch computing and lacks the rich workflow orchestration features (branching, retries, scheduling) that Airflow provides natively.

---

### Question 11
A global e-commerce platform experiences a 10x traffic increase during annual sales events. Their architecture uses Amazon ECS on EC2 with Application Load Balancers. During the last event, scaling was too slow, causing 503 errors for the first 15 minutes. The company needs to ensure immediate capacity availability during planned scaling events.

A) Switch to AWS Fargate for ECS tasks and configure auto scaling with a scheduled scaling action before the event  
B) Pre-warm the Application Load Balancer by contacting AWS support, use EC2 Auto Scaling with predictive scaling enabled, and configure ECS cluster capacity providers  
C) Replace the ALB with a Network Load Balancer, which handles sudden traffic spikes without pre-warming, and use ECS service auto scaling with step scaling policies  
D) Use Amazon CloudFront in front of the ALB to absorb the traffic spike and cache responses  

**Correct Answer: B**
**Explanation:** Option B addresses all aspects of the scaling bottleneck. Pre-warming the ALB (through AWS support) ensures it can handle sudden traffic increases without the gradual scaling that caused 503 errors. Predictive scaling on the EC2 Auto Scaling group provisions instances before the anticipated traffic spike based on historical patterns. ECS capacity providers ensure tasks are placed efficiently on available instances. Option A helps with scaling but Fargate still takes time to provision tasks and doesn't address the ALB pre-warming issue. Option C — while NLBs handle spikes better, they operate at Layer 4 and lose Layer 7 features (path-based routing, host-based routing) needed for e-commerce. Option D helps for cacheable content but most e-commerce transactions (cart, checkout) cannot be cached.

---

### Question 12
A company needs to implement a centralized DNS solution for their multi-account AWS environment. They have a hybrid setup with on-premises data centers connected via AWS Direct Connect. Applications in any AWS account need to resolve both on-premises DNS names and DNS names in other AWS accounts. On-premises servers also need to resolve AWS private hosted zone records.

A) Create a shared services VPC with Route 53 Resolver inbound and outbound endpoints, share the VPC subnets via AWS RAM, and use Route 53 private hosted zones associated with each VPC  
B) Deploy Route 53 Resolver inbound and outbound endpoints in each account's VPC and configure forwarding rules to on-premises DNS servers  
C) Use a centralized Route 53 Resolver in a shared networking account with inbound endpoints for on-premises resolution, outbound endpoints for forwarding to on-premises DNS, and share resolver rules across accounts using AWS RAM  
D) Set up an EC2-based DNS proxy (BIND) in the shared services VPC with conditional forwarding to on-premises DNS and Route 53 private zones  

**Correct Answer: C**
**Explanation:** Option C is the recommended architecture. Centralizing Route 53 Resolver endpoints in a networking account avoids endpoint duplication across accounts. Inbound endpoints allow on-premises servers to resolve AWS private hosted zones. Outbound endpoints forward AWS queries for on-premises domains to on-premises DNS servers. RAM shares resolver rules with all accounts, enabling consistent DNS resolution. Option A requires sharing VPC subnets, which couples networking and doesn't independently share resolver rules. Option B deploys resolver endpoints in every account, creating operational overhead and cost duplication. Option D uses self-managed DNS servers (BIND), adding maintenance burden and lacking the reliability of managed Route 53 Resolver.

---

### Question 13
A company runs a real-time analytics platform that ingests 500,000 events per second from IoT devices. The data must be processed within 5 seconds of ingestion and made available for sub-second dashboard queries. The system currently uses Amazon Kinesis Data Streams for ingestion but struggles with the processing latency requirement.

A) Increase the number of Kinesis shards and use Kinesis Data Analytics with Apache Flink for real-time processing, storing results in Amazon ElastiCache for Redis for dashboard queries  
B) Replace Kinesis with Amazon MSK (Managed Streaming for Apache Kafka) and use Kafka Streams for processing, storing results in Amazon Redshift for dashboard queries  
C) Use Amazon Kinesis Data Firehose to load data directly into Amazon OpenSearch Service and use OpenSearch Dashboards for visualization  
D) Switch to Amazon SQS FIFO queues for ingestion with Lambda consumers processing events and storing results in DynamoDB  

**Correct Answer: A**
**Explanation:** Option A best meets the requirements. Kinesis Data Analytics with Apache Flink provides true real-time stream processing with sub-second latency. Increasing shard count handles the 500K events/second throughput. ElastiCache for Redis delivers sub-second query response times for dashboard queries on pre-computed aggregations. Option B uses MSK and Kafka Streams which could work for processing but Amazon Redshift is an analytical data warehouse optimized for complex queries, not sub-second dashboard lookups. Option C uses Firehose which buffers data for at least 60 seconds before delivery, violating the 5-second processing requirement. Option D — SQS FIFO queues have a maximum throughput of 300 messages/second (3,000 with batching with high throughput mode), far below the 500K events/second requirement.

---

### Question 14
A solutions architect is designing a CI/CD pipeline for a containerized application deployed on Amazon EKS. The pipeline must support blue/green deployments, automated rollback on health check failure, and canary analysis before full promotion. The team uses GitHub for source control and wants minimal operational overhead.

A) Use AWS CodePipeline with AWS CodeBuild for building images, and AWS CodeDeploy with EKS for blue/green deployments and automated rollback  
B) Use GitHub Actions for CI, Amazon ECR for image storage, and Argo Rollouts with Istio service mesh on EKS for progressive delivery with canary analysis and automated rollback  
C) Use AWS CodePipeline with CodeBuild for CI, push to ECR, and deploy using Helm charts with a manual approval step for promotion  
D) Use GitHub Actions for CI/CD, directly applying Kubernetes manifests with kubectl, and use Kubernetes readiness probes for health checks  

**Correct Answer: B**
**Explanation:** Option B provides the complete solution. GitHub Actions handles CI (building and pushing to ECR). Argo Rollouts is a Kubernetes-native progressive delivery controller that supports canary analysis with metrics-based automated promotion/rollback. Istio provides traffic splitting for canary deployments. This gives blue/green, canary analysis, and automated rollback with minimal operational overhead since Argo Rollouts is declarative. Option A — CodeDeploy supports blue/green for ECS but has limited support for EKS blue/green with canary analysis. Option C requires manual approval, missing the automated canary analysis requirement. Option D lacks progressive delivery capabilities — kubectl apply is all-or-nothing with no canary or blue/green support.

---

### Question 15
A company has a data lake on Amazon S3 with 50TB of data partitioned by date. Analysts run queries using Amazon Athena but report that queries are slow and expensive. The data is stored in CSV format with no compression. Most queries filter on date ranges and a customer_id column. What combination of optimizations should a solutions architect recommend?

A) Convert data to Apache Parquet format with Snappy compression, partition by date, and add a customer_id column as a partition key  
B) Convert data to Apache Parquet format with Snappy compression, maintain date partitioning, and use Athena's partition projection to eliminate partition management overhead  
C) Convert data to Apache Parquet format with Snappy compression, partition by date, create an AWS Glue Data Catalog index on customer_id, and enable Athena query result caching  
D) Move the data to Amazon Redshift Spectrum external tables and create materialized views for common query patterns  

**Correct Answer: C**
**Explanation:** Option C provides the most comprehensive optimization. Converting CSV to Parquet (columnar format) with Snappy compression dramatically reduces data scanned. Maintaining date partitioning helps date-range queries. The AWS Glue Data Catalog column-level index on customer_id enables Athena to skip data files that don't contain the queried customer_id (similar to bloom filters). Query result caching avoids re-scanning for repeated queries. Option A over-partitions by adding customer_id as a partition key — with potentially millions of customers, this creates too many small files (the small files problem). Option B is good but partition projection doesn't help with customer_id filtering. Option D introduces Redshift complexity and cost when Athena optimizations can solve the problem.

---

### Question 16
A startup runs its entire infrastructure in a single AWS account. As the company grows, they plan to adopt a multi-account strategy. They need to migrate existing workloads with minimal downtime, establish account-level isolation for production and development, and maintain centralized billing. They currently have 15 EC2 instances, 5 RDS databases, and numerous S3 buckets.

A) Create new accounts under AWS Organizations, use AWS Application Migration Service for EC2 instances, RDS snapshot copy for databases, and S3 cross-account replication for storage  
B) Use AWS Control Tower to set up a landing zone, create accounts through Account Factory, share AMIs and RDS snapshots to new accounts, and use S3 batch replication  
C) Create new accounts under AWS Organizations, use AWS CloudFormation to recreate infrastructure in target accounts, and perform data migration during a maintenance window  
D) Keep all resources in the single account and use IAM permission boundaries and tags to simulate account-level isolation  

**Correct Answer: B**
**Explanation:** Option B provides the best approach. AWS Control Tower establishes a well-architected multi-account landing zone with guardrails. Account Factory automates new account creation with baseline configurations. Sharing AMIs to target accounts lets you launch identical EC2 instances. RDS snapshot sharing allows cross-account database restoration. S3 batch replication handles large-scale bucket migration. This provides a systematic migration path with governance built in. Option A works technically but lacks the governance framework Control Tower provides. Option C requires recreating infrastructure from scratch, which is error-prone and requires more downtime. Option D doesn't provide true account-level isolation — a compromised IAM principal could still potentially access other workloads.

---

### Question 17
A company is building an event-driven microservices architecture. Service A publishes events that need to be consumed by Services B, C, and D. Each consumer needs to process events independently and at its own pace. Some events require guaranteed ordering by a specific key. The total event volume is 10,000 events per second.

A) Use Amazon SNS with SQS subscriptions — create an SNS topic for Service A, and subscribe separate SQS queues for Services B, C, and D. Use SQS FIFO queues with message group IDs for ordered events  
B) Use Amazon EventBridge with rules routing events to Lambda functions for each consuming service  
C) Use Amazon Kinesis Data Streams with a separate consumer group (enhanced fan-out) for each consuming service, using partition keys for ordering  
D) Use Amazon MSK (Kafka) with consumer groups and message key-based partitioning for ordering  

**Correct Answer: C**
**Explanation:** Option C is the best fit. Kinesis Data Streams with enhanced fan-out provides dedicated 2MB/s throughput per consumer, allowing independent consumption rates. Partition keys guarantee ordering within a shard for events with the same key. Enhanced fan-out supports multiple independent consumers reading at their own pace. Option A using SNS-SQS fanout is excellent for decoupling but SQS FIFO queues have throughput limitations (300 msg/s per queue without high throughput mode, up to 3,000 with batching) which may not handle 10,000 events/second. Option B is good for event routing but Lambda has concurrency limits and EventBridge has a default limit of 10,000 events/second per bus with no native ordering guarantee. Option D works but MSK introduces significant operational overhead compared to Kinesis for this use case.

---

### Question 18
A manufacturing company needs to deploy identical infrastructure stacks across 8 AWS accounts in 4 regions. Each stack includes VPCs, security groups, IAM roles, and monitoring resources. The stacks must be updated centrally when changes are made, and drift detection must be automated. What approach should a solutions architect recommend?

A) Use AWS CloudFormation StackSets with service-managed permissions, automatic deployment enabled for the target OUs, and periodic drift detection using a scheduled Lambda function  
B) Create Terraform workspaces for each account-region combination and use a CI/CD pipeline to apply changes  
C) Use AWS Service Catalog with a portfolio shared across all accounts, requiring each account to update their provisioned products manually  
D) Write a custom script using AWS SDK that iterates through accounts and regions to deploy CloudFormation stacks via the management account role  

**Correct Answer: A**
**Explanation:** Option A is the best approach. CloudFormation StackSets with service-managed permissions automatically creates the necessary roles in member accounts via Organizations integration. Automatic deployment ensures new accounts in the OU automatically receive the stack. StackSets supports multi-region deployment with a single operation. A scheduled Lambda function can call `DetectStackSetDrift` for automated drift detection. Option B works but requires managing Terraform state, credentials for each account, and lacks the native Organizations integration. Option C requires manual action from each account. Option D is fragile, lacks rollback capabilities, and requires custom error handling.

---

### Question 19
A healthcare organization is migrating a monolithic .NET application to containers on AWS. The application currently runs on Windows Server and uses MSMQ for message queuing, SQL Server for the database, and Windows file shares for document storage. The team wants to modernize incrementally while maintaining Windows compatibility for the initial migration.

A) Deploy on Amazon EKS with Windows node groups, replace MSMQ with Amazon SQS, migrate SQL Server to Amazon RDS for SQL Server, and replace Windows file shares with Amazon FSx for Windows File Server  
B) Use AWS App2Container to containerize the application, deploy on Amazon ECS with Windows containers and Fargate, migrate to Amazon Aurora PostgreSQL, and use Amazon EFS for file storage  
C) Deploy on Amazon ECS with EC2 Windows instances, keep MSMQ in a separate EC2 instance, migrate SQL Server to Amazon RDS for SQL Server, and use Amazon FSx for Windows File Server  
D) Rewrite the application in .NET Core for Linux containers, deploy on EKS with Fargate, use Amazon Aurora MySQL for the database, and Amazon S3 for document storage  

**Correct Answer: A**
**Explanation:** Option A provides the best incremental modernization path. EKS with Windows node groups supports Windows containers while allowing future migration to Linux. Replacing MSMQ with SQS is a straightforward modernization step that removes a Windows dependency. RDS for SQL Server maintains database compatibility. FSx for Windows File Server provides SMB-compatible shared storage. Option B — Fargate doesn't support Windows containers, and Aurora PostgreSQL requires application changes for SQL Server compatibility. Option C keeps MSMQ on a separate EC2 instance, which isn't a modernization step and creates a single point of failure. Option D requires a complete rewrite which contradicts the incremental modernization requirement.

---

### Question 20
A company's solutions architect needs to design a multi-account logging strategy. All accounts must send CloudTrail logs, VPC flow logs, and application logs to a centralized logging account. The logs must be immutable for 7 years for compliance, searchable for the most recent 90 days, and cost-optimized for long-term storage.

A) Send all logs to a centralized S3 bucket with S3 Object Lock (Compliance mode) for 7-year retention, use Amazon OpenSearch Service for the 90-day searchable window, and S3 Lifecycle policies to transition older data to S3 Glacier Deep Archive  
B) Use Amazon CloudWatch Logs with cross-account log destinations in the logging account, set retention to 7 years, and use CloudWatch Logs Insights for searching  
C) Send all logs to a centralized S3 bucket with S3 Object Lock (Governance mode), use Amazon Athena for querying, and enable S3 Intelligent-Tiering for cost optimization  
D) Use AWS CloudTrail Lake for CloudTrail logs and Amazon CloudWatch Logs for all other logs, with retention set to 7 years on both  

**Correct Answer: A**
**Explanation:** Option A meets all requirements. S3 Object Lock in Compliance mode makes logs truly immutable — even the root user cannot delete them. OpenSearch Service provides fast, searchable access to the 90-day window of recent logs. S3 Lifecycle policies transition older logs (beyond 90 days) to Glacier Deep Archive for cost-optimized long-term storage. Option B storing 7 years of all logs in CloudWatch Logs is extremely expensive. Option C uses Governance mode which allows privileged users to delete objects (not truly immutable for compliance). Option D — CloudTrail Lake is expensive for 7-year retention and CloudWatch Logs is cost-prohibitive for long-term storage of VPC flow logs and application logs.

---

### Question 21
A video streaming company runs transcoding jobs on Amazon ECS. Each job takes 10-30 minutes and processes user-uploaded videos. The workload is unpredictable — sometimes there are 5 jobs, other times 500. The company wants to optimize costs while ensuring jobs complete within a reasonable timeframe.

A) Use ECS with Fargate Spot for all transcoding tasks with a fallback to standard Fargate using a capacity provider strategy  
B) Use ECS with EC2 Spot instances using a capacity provider with managed scaling and multiple instance types  
C) Use AWS Batch with Spot instances for the compute environment and set a maximum vCPU limit  
D) Use ECS with EC2 On-Demand instances and scheduled scaling based on historical patterns  

**Correct Answer: C**
**Explanation:** Option C is the best choice. AWS Batch is purpose-built for batch processing workloads with variable demand. It automatically manages a dynamic pool of Spot instances, handles job queuing and scheduling, and scales to zero when no jobs are pending. Setting a maximum vCPU limit controls costs. Batch also handles Spot interruptions by retrying jobs. Option A uses Fargate Spot which is more expensive per vCPU-hour than EC2 Spot for compute-intensive workloads like transcoding. Option B requires managing ECS cluster auto scaling configuration manually. Option D uses On-Demand instances which are significantly more expensive, and historical patterns don't help with unpredictable workloads.

---

### Question 22
A company operates a containerized application on Amazon EKS that processes sensitive financial data. Regulatory requirements mandate that container images must be scanned for vulnerabilities before deployment, only approved images from the company's private registry can run in the cluster, and all container traffic must be encrypted. How should a solutions architect implement these requirements?

A) Enable Amazon ECR image scanning on push, use OPA Gatekeeper admission controller to enforce that pods only use ECR images, and implement Istio service mesh with mTLS for traffic encryption  
B) Use a third-party container scanning tool in the CI/CD pipeline, configure EKS to use the private ECR registry as a pull-through cache, and enable EKS envelope encryption  
C) Enable ECR image scanning, use Kubernetes PodSecurityPolicies to restrict image sources, and configure AWS App Mesh with TLS termination  
D) Implement Amazon Inspector for ECR scanning, use IAM roles for service accounts to restrict image pull access, and configure security groups for traffic encryption  

**Correct Answer: A**
**Explanation:** Option A addresses all three requirements. ECR image scanning on push detects vulnerabilities before deployment. OPA (Open Policy Agent) Gatekeeper is a Kubernetes admission controller that can enforce policies like allowing only images from specific ECR repositories — it rejects pod creation requests that reference unapproved registries. Istio service mesh with mutual TLS (mTLS) encrypts all pod-to-pod traffic within the cluster. Option B — pull-through cache doesn't restrict which images can run, it only caches external images. EKS envelope encryption is for etcd data at rest, not network traffic. Option C — PodSecurityPolicies (deprecated in Kubernetes 1.25) restrict security contexts, not image sources. Option D — IAM roles for service accounts control AWS API access, not image pull restrictions at the admission level. Security groups operate at the network level and don't encrypt traffic.

---

### Question 23
A company's AWS Step Functions workflow processes insurance claims. The workflow includes steps for document validation, fraud detection (which calls an external third-party API), underwriter review (human approval), and payment processing. The external fraud detection API occasionally returns HTTP 429 (rate limited) errors and sometimes takes up to 60 seconds to respond. How should the solutions architect design the fraud detection step?

A) Use a Lambda function with a 90-second timeout that calls the API, with Step Functions retry configuration using exponential backoff and jitter for HTTP 429 errors, and a maximum of 3 retry attempts  
B) Use Step Functions' HTTP Task state to call the API directly with retry configuration for 429 errors  
C) Use a Lambda function that calls the API with its own retry logic, and set the Step Functions task timeout to 120 seconds  
D) Use an SQS queue between the validation and fraud detection steps, with a Lambda consumer that retries on 429 errors  

**Correct Answer: A**
**Explanation:** Option A is the correct approach. A Lambda function with a 90-second timeout accommodates the up to 60-second API response time with buffer. Step Functions' built-in retry mechanism with exponential backoff and jitter is the proper way to handle 429 rate-limited errors, as it spaces out retries to avoid overwhelming the rate-limited API. Setting maximum attempts to 3 prevents infinite retries. Option B — Step Functions HTTP Task state is not a real feature (as of the current service capabilities). Option C puts retry logic in the Lambda function, which means the Lambda timeout must accommodate multiple retries (potentially 3 x 60 seconds), and it lacks the visibility Step Functions provides for retry state. Option D adds unnecessary complexity with SQS and decouples the workflow, losing the synchronous flow needed for claim processing.

---

### Question 24
A large enterprise is consolidating 300 AWS accounts under a single AWS Organizations structure. They currently have multiple separate organizations and standalone accounts. Each existing organization has its own SCPs and consolidated billing setup. The solutions architect needs to plan the consolidation with minimal service disruption.

A) Create invitations from the target organization to each standalone account and accounts in other organizations (after removing them from their current organization), accept invitations, and reapply SCPs in the new organization structure  
B) Use the AWS Organizations API to programmatically merge organizations by transferring all accounts from source organizations to the target organization  
C) Create new accounts in the target organization using AWS Control Tower and migrate workloads from old accounts to new accounts using AWS Application Migration Service  
D) Contact AWS Support to perform an organization merge, which consolidates all accounts and preserves existing SCPs  

**Correct Answer: A**
**Explanation:** Option A describes the correct process. AWS Organizations doesn't support merging organizations directly. The process requires removing accounts from their current organization (which makes them standalone) and then inviting them to the target organization. SCPs from the old organization are not transferred and must be recreated in the new organization's OU structure. This is manual but can be scripted using the Organizations API. Option B — there is no API to merge organizations. Option C creates entirely new accounts and requires full workload migration, which is extremely disruptive and unnecessary. Option D — AWS Support cannot merge organizations; this is not a supported operation.

---

### Question 25
A company uses AWS Step Functions to orchestrate a machine learning pipeline. The pipeline includes data preprocessing (30 minutes), model training (2 hours), model evaluation (15 minutes), and conditional deployment. The model training step uses Amazon SageMaker. If evaluation metrics don't meet a threshold, the pipeline should retrain with different hyperparameters up to 3 times before alerting the team.

A) Use a Standard Step Functions workflow with SageMaker integration, a Choice state after evaluation to check metrics, and a loop counter in the state input to limit retries to 3, with an SNS notification if all retries fail  
B) Use an Express Step Functions workflow for cost savings, call SageMaker APIs through Lambda functions, and use DynamoDB to track retry counts  
C) Use Step Functions with a Map state to run 3 training jobs in parallel with different hyperparameters, then choose the best model  
D) Use SageMaker Pipelines instead of Step Functions for the entire ML workflow, as it natively supports training, evaluation, and conditional branching  

**Correct Answer: A**
**Explanation:** Option A correctly uses Standard workflows (which support long-running executions needed for 2+ hour training). The SageMaker SDK integration allows direct invocation of training jobs. A Choice state evaluates metrics, and loop logic with a counter in the state input creates the retry mechanism with different hyperparameters. After 3 failures, the workflow routes to an SNS notification step. Option B uses Express workflows which have a 5-minute maximum duration — far too short for 2-hour training jobs. Option C runs all 3 in parallel rather than sequential retry, using more compute resources and not matching the "retry with different hyperparameters" requirement (which implies iterative improvement). Option D — while SageMaker Pipelines exists, the question asks about Step Functions design, and SageMaker Pipelines has less flexibility for non-ML steps and external service integrations.

---

### Question 26
A solutions architect is designing a high-performance computing (HPC) environment on AWS for computational fluid dynamics simulations. The workloads require low-latency, high-bandwidth inter-node communication, access to a shared high-performance file system, and the ability to scale to 1,000 nodes for large simulations.

A) Use EC2 C5n instances in a cluster placement group with Elastic Fabric Adapter (EFA) enabled, Amazon FSx for Lustre linked to an S3 bucket for persistent storage, and AWS ParallelCluster for cluster management  
B) Use EC2 M5 instances across multiple Availability Zones for fault tolerance, with Amazon EFS for shared storage and AWS Batch for job scheduling  
C) Use EC2 P4d instances with EFA in a spread placement group, Amazon FSx for NetApp ONTAP for shared storage, and a custom Slurm scheduler on EC2  
D) Use AWS Graviton-based C6g instances in a cluster placement group, Amazon FSx for Lustre, and AWS ParallelCluster for management  

**Correct Answer: A**
**Explanation:** Option A is optimal for HPC. C5n instances provide high network bandwidth (100 Gbps). Cluster placement groups minimize inter-node latency by placing instances on physically close hardware. EFA provides OS-bypass networking for MPI-based HPC applications with low latency. FSx for Lustre is a high-performance parallel file system ideal for HPC, and linking to S3 provides persistent data storage. ParallelCluster automates HPC cluster management. Option B uses M5 instances (not network-optimized) across AZs (increases latency), and EFS doesn't match Lustre's performance for HPC. Option C uses P4d (GPU instances, unnecessary for CFD CPU workloads), spread placement group (increases latency, opposite of what's needed). Option D — while Graviton instances are cost-efficient, CFD software may not be compiled for ARM architecture, and C5n provides higher network bandwidth.

---

### Question 27
A global company needs to enforce a tagging strategy across all 200 AWS accounts. Every resource must have the tags: CostCenter, Environment, and Owner. Non-compliant resources should be detected and reported, and the creation of EC2 instances and RDS databases without these tags should be blocked.

A) Use Tag Policies in AWS Organizations to define required tags and their allowed values, AWS Config rules (required-tags) for detection and reporting, and SCPs to deny EC2 and RDS creation requests missing the required tags  
B) Use AWS Config rules for detection across all accounts and Lambda remediation functions to add missing tags  
C) Use Tag Policies in AWS Organizations for enforcement and AWS Cost Explorer tag reports for compliance monitoring  
D) Implement a custom CloudFormation hook that validates tags before resource creation, deployed via StackSets across all accounts  

**Correct Answer: A**
**Explanation:** Option A provides a comprehensive three-layer approach. Tag Policies define the tagging standard at the organization level. AWS Config rules (required-tags) detect and report non-compliant resources across accounts. SCPs can deny `ec2:RunInstances` and `rds:CreateDBInstance` actions when the required tags are not present in the request (using `aws:RequestTag` condition key), providing preventive control. Option B only detects and remediates after the fact, not blocking creation. Option C — Tag Policies define standards but don't actively block resource creation; Cost Explorer tags are for cost analysis, not compliance enforcement. Option D only covers CloudFormation-deployed resources, not console or CLI-created resources.

---

### Question 28
A company is deploying a real-time fraud detection system. Transactions arrive at a rate of 50,000 per second. Each transaction must be scored within 100 milliseconds. The fraud detection model is a custom ML model that requires GPU inference. The system must be highly available and handle traffic spikes of up to 100,000 transactions per second.

A) Deploy the model on Amazon SageMaker real-time inference endpoints with auto scaling, use an Application Load Balancer for traffic distribution, and ElastiCache for caching repeat customer scores  
B) Deploy the model on Amazon EKS with GPU node groups using NVIDIA T4 instances, Kubernetes Horizontal Pod Autoscaler, and an NLB for low-latency routing  
C) Use SageMaker Serverless Inference endpoints for automatic scaling and pay-per-use pricing  
D) Deploy the model on Amazon SageMaker real-time inference endpoints with GPU instances (ml.g4dn), auto scaling based on InvocationsPerInstance metric, provisioned concurrency equivalent for baseline capacity, and a Network Load Balancer for sub-millisecond routing  

**Correct Answer: D**
**Explanation:** Option D is the best fit. SageMaker real-time endpoints with GPU instances (ml.g4dn with NVIDIA T4 GPUs) provide low-latency inference. Auto scaling on the InvocationsPerInstance metric handles traffic spikes to 100K TPS. Setting a minimum instance count ensures baseline capacity without cold starts. NLB provides the lowest latency routing (Layer 4). Option A uses ALB which adds latency compared to NLB for this use case (Layer 7 processing overhead). Option B could work but introduces significant operational complexity managing GPU nodes, drivers, and model serving infrastructure on EKS. Option C — Serverless Inference has cold start latency and a maximum concurrent invocations limit that won't meet 100ms latency at 50K-100K TPS.

---

### Question 29
A company manages 50 microservices running on Amazon ECS. Each service has its own CloudWatch Log Group. The operations team is overwhelmed by the volume of logs and wants to implement centralized log analysis with the ability to correlate requests across services, detect anomalies, and create dashboards.

A) Enable AWS X-Ray tracing across all ECS services for request correlation, use CloudWatch Logs Insights for log analysis, and create CloudWatch dashboards  
B) Deploy a centralized Amazon OpenSearch Service cluster, use Fluent Bit sidecars in ECS tasks to ship logs with trace IDs to OpenSearch, enable X-Ray for distributed tracing, and use OpenSearch Dashboards for visualization  
C) Use Amazon CloudWatch ServiceLens which combines X-Ray traces, CloudWatch metrics, and logs into a single view with anomaly detection  
D) Stream all CloudWatch Log Groups to a Kinesis Data Firehose delivery stream and store in S3 for analysis with Amazon Athena  

**Correct Answer: B**
**Explanation:** Option B provides a comprehensive solution. OpenSearch Service excels at log aggregation, full-text search, and anomaly detection across high-volume log data. Fluent Bit sidecars efficiently collect and forward logs with enriched metadata (including X-Ray trace IDs for correlation). X-Ray provides distributed tracing. OpenSearch Dashboards enables rich visualization and dashboarding. This scales well for 50 microservices. Option A — CloudWatch Logs Insights is useful for ad-hoc queries but has limitations for real-time dashboarding and anomaly detection at scale. Option C — ServiceLens provides a unified view but has limited anomaly detection capabilities and doesn't scale as well for 50 services with high log volumes. Option D loses real-time visibility and Athena isn't suited for real-time log analysis.

---

### Question 30
A financial institution needs to ensure that all data stored in their AWS accounts is encrypted. They require customer-managed KMS keys for all encryption, automatic key rotation, and the ability to audit all key usage. Keys must not be exportable, and deletion must require a 30-day waiting period.

A) Create customer-managed KMS keys with automatic annual rotation enabled, enable CloudTrail logging for all KMS API calls, set the key deletion waiting period to 30 days, and use SCPs to deny any encryption operations that don't specify a customer-managed KMS key  
B) Use AWS-managed keys across all services with CloudTrail logging enabled  
C) Create customer-managed keys in AWS CloudHSM for non-exportable key material, enable CloudTrail logging, and use KMS custom key store backed by CloudHSM  
D) Create customer-managed KMS keys with imported key material for full control, enable CloudTrail logging, and use key policies to restrict usage  

**Correct Answer: A**
**Explanation:** Option A satisfies all requirements. Customer-managed KMS keys provide full control. Automatic rotation rotates key material annually. CloudTrail logs all KMS API calls for auditing. The deletion waiting period can be set to 30 days (7-30 day range). SCPs enforce that all encryption operations use customer-managed keys across all accounts. KMS keys are non-exportable by design. Option B uses AWS-managed keys which don't allow customer control over rotation schedule or key policies. Option C — while CloudHSM provides non-exportable keys, it adds significant operational complexity and cost; standard KMS keys are already non-exportable. Option D — imported key material doesn't support automatic key rotation, which is a stated requirement.

---

### Question 31
A company needs to implement a disaster recovery solution for their EKS-based application across two AWS regions. The application uses Amazon Aurora MySQL, Amazon EFS for shared storage, and processes real-time event streams. The RTO is 15 minutes and RPO is 1 minute.

A) Use Amazon Aurora Global Database with a secondary region, EFS replication to the secondary region, and deploy a passive EKS cluster with Argo CD for application deployment. Use Route 53 health checks with failover routing  
B) Run active-active EKS clusters in both regions with Aurora Multi-AZ in each region, EFS in each region with S3 cross-region replication, and Global Accelerator for traffic management  
C) Use Aurora read replicas in the secondary region, scheduled EFS backups to S3 with cross-region replication, and a CloudFormation template to provision EKS in the DR region  
D) Deploy identical infrastructure in both regions using CloudFormation StackSets, use Aurora Global Database, and manually promote the secondary region during disaster  

**Correct Answer: A**
**Explanation:** Option A meets the RTO/RPO requirements. Aurora Global Database provides cross-region replication with typically less than 1-second lag (meeting 1-minute RPO). EFS cross-region replication provides near-real-time file synchronization. A passive EKS cluster with Argo CD allows rapid application deployment from Git (within minutes). Route 53 failover routing with health checks enables automated DNS failover within minutes (meeting 15-minute RTO). Option B is active-active which exceeds requirements and is significantly more expensive. Option C — scheduled EFS backups have higher RPO and provisioning EKS from CloudFormation takes too long for 15-minute RTO. Option D requires manual promotion which risks exceeding the 15-minute RTO due to human involvement.

---

### Question 32
A company has a legacy application that writes log files to a local NFS mount. They want to migrate this application to containers on Amazon ECS without modifying the application code. The logs must be durably stored and searchable. The application writes approximately 50GB of logs daily.

A) Use Amazon EFS mounted in the ECS task definition, and deploy Fluent Bit as a sidecar container to ship logs from EFS to Amazon OpenSearch Service  
B) Configure the ECS task with the awslogs log driver to send stdout/stderr to CloudWatch Logs  
C) Mount an Amazon S3 bucket using s3fs-fuse in the container and use Amazon Athena for log search  
D) Use a bind mount volume in the ECS task definition with a Fluent Bit sidecar that reads the log files and forwards them to CloudWatch Logs  

**Correct Answer: A**
**Explanation:** Option A correctly addresses all requirements. Since the application writes to an NFS mount (not stdout), EFS provides NFS-compatible shared storage that can be mounted in the ECS task definition as a replacement for the original NFS mount — no code changes needed. A Fluent Bit sidecar reads the log files from the EFS mount and ships them to OpenSearch for searchability. Option B only captures stdout/stderr, not file-based logs; the application writes to an NFS mount, not stdout. Option C — s3fs-fuse has poor performance, high latency, and isn't a reliable NFS replacement; it's also not natively supported in ECS task definitions. Option D — bind mount volumes are ephemeral and local to the host; if the task is rescheduled, logs are lost. EFS provides durable, shared storage.

---

### Question 33
A company is building a serverless API that processes requests in multiple steps: input validation, data enrichment from a third-party API, business logic processing, database write, and notification sending. Some requests require all steps while others only require a subset. The company wants maximum flexibility to modify the workflow without code deployments.

A) Use AWS Step Functions Express Workflows with a state machine that includes Choice states to conditionally execute steps based on request attributes, with each step implemented as a Lambda function  
B) Build a monolithic Lambda function that handles all steps with conditional logic  
C) Use Amazon API Gateway with Lambda authorizers for validation, Lambda functions chained through SNS topics for subsequent steps  
D) Use Step Functions Standard Workflows with Activity tasks and on-premises workers for processing  

**Correct Answer: A**
**Explanation:** Option A is the best design. Step Functions Express Workflows are designed for high-volume, short-duration request processing (up to 5 minutes, which is sufficient for API request processing). Choice states provide conditional branching based on request attributes, allowing different step combinations without code changes. The state machine definition can be updated (JSON/YAML) without deploying new Lambda code. Each step as a separate Lambda enables independent scaling and testing. Option B is monolithic and requires code deployment for any workflow change. Option C creates a fragile event-driven chain that's hard to modify, monitor, and debug. Option D uses Standard Workflows which are more expensive for high-volume synchronous API calls and Activity tasks are for external worker polling, which is unnecessary.

---

### Question 34
A solutions architect is designing a multi-account network architecture. The company has 4 VPCs: shared services, production, development, and a data VPC. Production and development should not communicate directly with each other. All VPCs need access to shared services. Only the production VPC should access the data VPC. On-premises connectivity is required for all VPCs via Direct Connect.

A) Use AWS Transit Gateway with separate route tables for production and development. Create a route table for production that includes routes to shared services, data, and on-premises. Create a route table for development with routes to shared services and on-premises only. Associate VPCs with their respective route tables  
B) Use VPC peering between each VPC pair and NACLs to block traffic between production and development  
C) Deploy separate Transit Gateways for production and development, each connected to shared services via peering  
D) Use AWS PrivateLink for all inter-VPC communication with endpoint services in each VPC  

**Correct Answer: A**
**Explanation:** Option A uses Transit Gateway route table segmentation, which is the standard approach for network isolation in multi-account architectures. Production's route table allows communication to shared services, data VPC, and on-premises. Development's route table only includes shared services and on-premises. Since there's no route between production and development route tables, they can't communicate. The data VPC is only in the production route table, ensuring only production can access it. Option B — VPC peering creates a full mesh and NACLs are complex to manage and error-prone for access control at this level. Option C uses multiple Transit Gateways which is unnecessarily complex and expensive. Option D — PrivateLink is for specific service endpoints, not general VPC-to-VPC connectivity, and would require creating endpoint services for every application.

---

### Question 35
A company is running an Apache Spark application on Amazon EMR for daily ETL processing. The cluster processes 5TB of data daily and currently takes 4 hours to complete. The data team wants to reduce processing time to under 2 hours without significantly increasing cost.

A) Switch to Amazon EMR on EKS with Graviton-based instances, enable Spark dynamic resource allocation, and use Apache Iceberg table format for efficient data access  
B) Increase the number of core nodes in the EMR cluster and switch from HDD to SSD-backed instances  
C) Migrate to AWS Glue with Spark-optimized workers, enable job bookmarks, and use the Parquet format  
D) Enable EMR Managed Scaling with a mix of On-Demand core nodes and Spot task nodes, optimize Spark configurations (partitioning, broadcast joins), and use S3 Express One Zone for hot data  

**Correct Answer: D**
**Explanation:** Option D provides a multi-faceted optimization approach. EMR Managed Scaling automatically adjusts the cluster size based on workload demands, using Spot instances for task nodes to control costs. Spark optimization (proper partitioning to reduce shuffles, broadcast joins for small tables) directly reduces processing time. S3 Express One Zone provides single-digit millisecond access latency for frequently accessed data, reducing I/O bottleneck. Option A — EMR on EKS adds operational complexity and Graviton savings are primarily cost-related, not performance-doubling. Option B is a brute-force approach that increases cost linearly. Option C — Glue is managed but may not outperform a tuned EMR cluster and has limitations on fine-grained Spark configuration.

---

### Question 36
A company wants to implement a service mesh for their EKS-based microservices to gain observability, traffic management, and security. They have 30 microservices with complex inter-service communication patterns. The team needs mutual TLS between all services, circuit breaking, and canary deployments. **(Select TWO)**

A) Deploy Istio service mesh with Envoy sidecar proxies for traffic management, mTLS, and observability  
B) Use AWS App Mesh with Envoy proxies for traffic management and integrate with AWS X-Ray for tracing  
C) Implement Linkerd as a lightweight service mesh alternative with built-in mTLS and traffic splitting  
D) Use Kubernetes NetworkPolicies alone for service-to-service security  
E) Deploy NGINX Ingress Controller as a service mesh replacement  

**Correct Answer: A, C**
**Explanation:** Both Istio (A) and Linkerd (C) are full-featured service meshes that support mutual TLS, circuit breaking, canary deployments (traffic splitting), and observability. Istio offers more features but is more complex; Linkerd is lighter weight with simpler operations. Either satisfies all requirements. Option B — App Mesh supports traffic management but has less mature circuit breaking capabilities and relies on X-Ray integration rather than built-in observability (no native mTLS enforcement at the same level as Istio or Linkerd). Option D — NetworkPolicies provide network-level access control but don't offer mTLS, circuit breaking, or traffic management. Option E — NGINX Ingress Controller handles ingress traffic only, not inter-service mesh functionality.

---

### Question 37
A company's Step Functions workflow processes customer orders by calling multiple downstream microservices. During a recent incident, one downstream service became slow, causing the Step Functions executions to pile up and reach the account's concurrent execution limit of 1,000,000 state transitions per second. They need to prevent cascade failures while maintaining throughput.

A) Implement a circuit breaker pattern using a DynamoDB table to track downstream service health, with a Choice state that checks the circuit status before calling each service, and falls back to an SQS queue when the circuit is open  
B) Simply increase the Step Functions service quotas by contacting AWS Support  
C) Add timeouts to each Task state and use a Catch block to route to a fallback Lambda that queues requests in SQS for retry  
D) Replace Step Functions with direct Lambda-to-Lambda invocations for better performance  

**Correct Answer: A**
**Explanation:** Option A implements a proper circuit breaker pattern within Step Functions. A DynamoDB table tracks downstream service health (latency, error rates). Before calling a slow service, a Choice state checks if the circuit is "open" (service unhealthy) and routes requests to an SQS queue for deferred processing instead of blocking. When the service recovers, the circuit "closes" and direct calls resume. This prevents execution pile-up. Option B doesn't solve the root cause — the downstream service is the bottleneck. Option C handles individual failures with timeouts but doesn't prevent the cascade effect — new executions still call the slow service. Option D removes orchestration visibility and doesn't address the fundamental cascade failure problem.

---

### Question 38
A company is migrating from a self-managed Kubernetes cluster to Amazon EKS. Their current setup uses persistent volumes backed by Ceph storage, Prometheus for monitoring, Cert-Manager for TLS certificates, and Helm for deployments. They need to replicate this functionality on EKS with AWS-native alternatives where possible.

A) Use Amazon EBS CSI driver for persistent volumes, Amazon Managed Service for Prometheus for monitoring, AWS Private CA with cert-manager for TLS, and continue using Helm for deployments  
B) Use Amazon EFS for all persistent volumes, CloudWatch Container Insights for monitoring, ACM for TLS certificates, and AWS CDK for deployments  
C) Use Amazon EBS CSI driver for persistent volumes, self-managed Prometheus on EKS for monitoring, Let's Encrypt with cert-manager for TLS, and Helm for deployments  
D) Use Amazon FSx for Lustre for persistent volumes, Amazon Managed Grafana for monitoring, AWS Certificate Manager for TLS, and Flux CD for deployments  

**Correct Answer: A**
**Explanation:** Option A provides the best AWS-native migration. EBS CSI driver replaces Ceph for block storage (most Kubernetes workloads use ReadWriteOnce volumes). Amazon Managed Service for Prometheus (AMP) is a fully managed Prometheus-compatible monitoring solution, reducing operational overhead while maintaining Prometheus compatibility (queries, alerts, dashboards). AWS Private CA integrates with cert-manager (the existing tool) for automated TLS certificate management. Helm continues to work on EKS unchanged. Option B — EFS is NFS-based which may not suit all workloads, CDK replaces Helm unnecessarily, and ACM doesn't integrate with Kubernetes cert-manager. Option C keeps self-managed Prometheus, missing the opportunity to reduce operations. Option D — FSx for Lustre is for HPC, not general persistent volumes, and Grafana is for visualization, not a Prometheus replacement.

---

### Question 39
A company needs to process images uploaded to S3. Each image requires: thumbnail generation (5 seconds), metadata extraction (2 seconds), content moderation (10 seconds), and storage of results in DynamoDB. All steps for a single image are independent and can run in parallel. The system processes 1,000 images per hour with occasional bursts to 10,000.

A) Use a Step Functions Express Workflow triggered by S3 events via EventBridge, with a Parallel state running all four tasks concurrently as Lambda functions  
B) Use a single Lambda function triggered by S3 events that performs all four steps sequentially  
C) Use an SNS topic with four SQS queue subscriptions, each with a dedicated Lambda consumer for each processing step  
D) Use Step Functions Standard Workflow with a Map state to process each step sequentially  

**Correct Answer: A**
**Explanation:** Option A is optimal. Step Functions Express Workflows handle high-volume, short-duration executions efficiently. The Parallel state runs all four independent tasks concurrently, reducing total processing time from 19 seconds (sequential) to ~10 seconds (longest task). EventBridge integration with S3 provides reliable triggering. Express Workflows are cost-effective for short-duration, high-volume workloads. Option B processes sequentially, taking 19 seconds per image instead of 10, and a single Lambda becomes a bottleneck during bursts. Option C achieves parallelism but processes each image through four independent paths without coordinated completion tracking — it's harder to know when all steps for one image are complete. Option D uses Standard Workflows (more expensive for high volume) and Map state (designed for iterating over a collection, not parallel independent tasks).

---

### Question 40
A multinational company needs to ensure that their AWS infrastructure complies with both GDPR (EU data residency) and SOC 2 requirements. They operate in us-east-1, eu-west-1, and ap-southeast-1. EU customer data must remain in eu-west-1, and all administrative actions must be logged and auditable.

A) Use SCPs to restrict EU accounts to eu-west-1 only, enable AWS CloudTrail in all accounts with organization trail, enable AWS Config for compliance monitoring, and use AWS Audit Manager for SOC 2 evidence collection  
B) Use separate AWS accounts for EU operations with region-restriction SCPs, and use a third-party audit tool for compliance  
C) Enable VPC endpoints in eu-west-1 to prevent data from leaving the region, and use CloudWatch for audit logging  
D) Use S3 bucket policies with region conditions and IAM policies restricting EU users to eu-west-1 resources  

**Correct Answer: A**
**Explanation:** Option A comprehensively addresses both GDPR and SOC 2. SCPs restricting EU accounts to eu-west-1 enforce data residency at the account level (preventing resource creation in other regions). CloudTrail organization trails capture all administrative API calls for auditing across all accounts. AWS Config provides continuous compliance monitoring. AWS Audit Manager automates SOC 2 evidence collection with pre-built frameworks. Option B lacks specificity on logging and audit mechanisms. Option C — VPC endpoints don't prevent data from leaving a region (they provide private connectivity to AWS services) and CloudWatch alone isn't sufficient for SOC 2 auditing. Option D addresses only S3 and IAM, not the broader infrastructure compliance needs (compute, databases, etc.).

---

### Question 41
A solutions architect is tasked with optimizing the performance of an Amazon DynamoDB table that stores user session data. The table has a partition key of user_id and receives 50,000 read requests per second. Read patterns show that 20% of users (the most active) generate 80% of the traffic, causing hot partitions.

A) Add a DynamoDB Accelerator (DAX) cluster in front of the table to cache hot items and reduce read load on the base table  
B) Increase the provisioned read capacity units to handle the full 50,000 RPS  
C) Add a sort key to better distribute data across partitions  
D) Implement write sharding by appending a random suffix to the partition key  

**Correct Answer: A**
**Explanation:** Option A directly addresses the hot partition issue. DAX is an in-memory cache purpose-built for DynamoDB that caches the most frequently accessed items (the hot 20% of users). This dramatically reduces reads to the base table and provides microsecond response times. Since session data is read-heavy for active users, DAX caching is extremely effective. Option B increases capacity but doesn't solve the hot partition problem — the traffic is still concentrated on specific partitions regardless of total capacity. Option C — adding a sort key doesn't change partition distribution since the partition key (user_id) remains the same. Option D — write sharding complicates reads because you'd need to query multiple shard keys and isn't suitable for a key-value lookup pattern.

---

### Question 42
A company runs a data pipeline where files are uploaded to S3, processed by a Step Functions workflow, and results are stored in Redshift. The pipeline processes 10,000 files daily. Recently, some files have been processed twice due to duplicate S3 event notifications. The company needs exactly-once processing semantics.

A) Use S3 event notifications to trigger a Lambda function that writes a record to a DynamoDB table using a conditional put (file key as the partition key). Only start the Step Functions execution if the put succeeds (item didn't exist)  
B) Use S3 event notifications with SQS and enable SQS deduplication using the file key as the deduplication ID  
C) Use EventBridge with S3 event notifications and configure an EventBridge rule with a deduplication transformer  
D) Switch to S3 Inventory reports processed on a schedule instead of event-driven processing  

**Correct Answer: A**
**Explanation:** Option A implements an idempotency pattern that guarantees exactly-once processing. When a file triggers an event, the Lambda function attempts a conditional put to DynamoDB (PutItem with `attribute_not_exists`). If the item already exists (duplicate event), the conditional put fails and the workflow is not started. If it succeeds (first event for that file), the workflow starts. DynamoDB's conditional writes provide atomic check-and-set behavior. Option B — SQS FIFO deduplication only works within a 5-minute window; if duplicate notifications arrive outside that window, they won't be deduplicated. Standard SQS doesn't have deduplication. Option C — EventBridge doesn't have a native deduplication transformer. Option D switches to batch processing, losing the near-real-time event-driven capability.

---

### Question 43
A large enterprise runs SAP HANA on AWS using EC2 X1e instances. They need to implement a high availability setup that provides automatic failover with an RPO of near zero and RTO of under 5 minutes. The SAP HANA database is 6TB in memory.

A) Use SAP HANA System Replication (HSR) in synchronous mode across two Availability Zones with an overlay IP managed by AWS Launch Wizard for SAP, and use Amazon CloudWatch for health monitoring  
B) Deploy SAP HANA on a single AZ with regular EBS snapshots every 15 minutes to S3, with a standby instance in another AZ that restores from the latest snapshot on failure  
C) Use SAP HANA on a single large instance with EC2 auto recovery for hardware failure detection  
D) Deploy SAP HANA in an active-active configuration across three AZs for maximum availability  

**Correct Answer: A**
**Explanation:** Option A is the correct architecture for SAP HANA HA on AWS. HSR in synchronous mode provides near-zero RPO by replicating every transaction to the secondary node in another AZ before acknowledging to the application. AWS Launch Wizard for SAP automates the overlay IP (virtual IP) failover, which switches to the secondary node within minutes, meeting the 5-minute RTO. Option B — 15-minute snapshots would result in 15-minute RPO at best, and snapshot restoration of 6TB takes much longer than 5 minutes. Option C — EC2 auto recovery handles host hardware failures but doesn't provide cross-AZ failover or data replication. Option D — SAP HANA doesn't natively support active-active multi-primary across three AZs.

---

### Question 44
A company operates a multi-account AWS environment and wants to implement a centralized secrets management solution. Applications across accounts need to access shared secrets (API keys, database credentials) while maintaining account-level isolation for account-specific secrets. Secret access must be auditable.

A) Create a centralized AWS Secrets Manager in a shared services account, use resource-based policies to grant cross-account access to shared secrets, and use AWS RAM to share specific secrets. Enable CloudTrail logging for all Secrets Manager API calls  
B) Replicate all secrets to every account using Secrets Manager cross-region replication and use IAM policies for access control  
C) Store all secrets in AWS Systems Manager Parameter Store SecureString parameters in a centralized account with cross-account IAM roles for access  
D) Use a self-managed HashiCorp Vault cluster in the shared services account accessible via PrivateLink from all accounts  

**Correct Answer: A**
**Explanation:** Option A provides the correct architecture. Centralized Secrets Manager in a shared services account holds shared secrets. Resource-based policies on individual secrets grant specific cross-account access. Account-specific secrets remain in each account's own Secrets Manager. CloudTrail provides auditability for all secret access. Note: AWS RAM can share Secrets Manager secrets with specific accounts or OUs. Option B — cross-region replication exists in Secrets Manager but replicating to every account creates unnecessary copies of shared secrets and increases security surface area. Option C — Parameter Store SecureString works but lacks advanced features like automatic rotation and cross-account sharing that Secrets Manager provides natively. Option D introduces operational overhead of managing Vault infrastructure.

---

### Question 45
A company's containerized application on Amazon ECS has a memory leak that causes tasks to crash after running for approximately 48 hours. The development team is working on a fix, but the operations team needs an immediate mitigation that maintains application availability with zero downtime.

A) Configure ECS service to use rolling update deployment with a minimum healthy percent of 100% and maximum percent of 200%, and set the task definition to include a health check with a deregistration delay. Implement a scheduled Lambda function that triggers ECS service force deployment every 24 hours  
B) Increase the memory allocation for the tasks to 4x the current value to delay the crash  
C) Configure an Application Load Balancer health check that monitors memory utilization and marks tasks unhealthy above a threshold  
D) Implement a container-level health check in the Dockerfile that monitors memory usage and exits when approaching the limit  

**Correct Answer: D**
**Explanation:** Option D is the most effective immediate mitigation. A Docker HEALTHCHECK that monitors the container's memory usage and returns unhealthy (or the process exits) when approaching the leak threshold causes ECS to replace the task proactively. Combined with the ECS service's desired count and rolling deployment, this ensures zero downtime — ECS drains connections from the unhealthy task and starts a replacement before stopping the old one. Option A — force redeploying every 24 hours works but is blunt and could cause unnecessary disruptions (tasks that started recently get restarted too). Option B only delays the inevitable and wastes resources. Option C — ALB health checks can't directly monitor container memory utilization (they check HTTP endpoints).

---

### Question 46
A company wants to deploy a multi-region active-active web application. The application uses Aurora MySQL and must handle writes in both regions. User sessions must be region-sticky but failover-capable. The company wants to minimize the complexity of managing database conflicts.

A) Use Amazon Aurora Global Database with write forwarding enabled. The primary region handles writes while the secondary region forwards write requests to the primary. Use Route 53 latency-based routing with health checks for traffic distribution  
B) Use separate Aurora clusters in each region with bi-directional replication using AWS DMS and custom conflict resolution  
C) Use Aurora Global Database with planned failover to switch the writer between regions on a schedule  
D) Use Amazon DynamoDB Global Tables instead of Aurora for automatic multi-region active-active writes  

**Correct Answer: A**
**Explanation:** Option A provides the closest to active-active with Aurora MySQL while avoiding write conflicts. Aurora Global Database with write forwarding allows the secondary region to accept write requests and transparently forward them to the primary region. This eliminates conflict resolution complexity (single writer). Route 53 latency-based routing directs users to the nearest region for reads and writes. Health checks enable failover if a region becomes unavailable. Option B requires managing custom conflict resolution for bi-directional replication, which is complex and error-prone. Option C uses planned failover which isn't active-active — only one region writes at a time with manual switching. Option D changes the database technology, which may require significant application refactoring.

---

### Question 47
A company is designing a system for processing large genomics datasets. Each analysis job requires downloading a 50GB reference genome, processing patient data against it, and storing results. Multiple jobs run concurrently and all use the same reference genome. Job processing takes 2-6 hours on compute-optimized instances.

A) Store the reference genome in S3, use EC2 instances with large instance stores, and download the genome to local storage at job start. Use AWS Batch for job orchestration  
B) Store the reference genome on Amazon FSx for Lustre linked to S3, use AWS Batch with compute-optimized EC2 instances, and mount FSx for Lustre on all batch compute nodes  
C) Store the reference genome in Amazon EFS and mount it on all compute instances  
D) Store the reference genome as an EBS snapshot and attach cloned volumes to each compute instance  

**Correct Answer: B**
**Explanation:** Option B is optimal. FSx for Lustre provides high-throughput parallel file system access, and when linked to S3, it lazily loads the reference genome on first access and caches it. Multiple concurrent jobs share the same FSx file system, avoiding redundant downloads. FSx for Lustre delivers the throughput needed for genomics workloads. AWS Batch manages job scheduling and scaling. Option A requires each job to download 50GB independently, wasting time and bandwidth for concurrent jobs. Option C — EFS can work but has lower throughput than FSx for Lustre for large sequential reads typical in genomics. Option D — cloning EBS snapshots for each instance is slow and doesn't share cached data between instances.

---

### Question 48
A solutions architect is designing a strategy for managing Terraform state files across a multi-account AWS organization with 100 accounts. Each account has its own infrastructure defined in Terraform. The state must be centralized, encrypted, and protected against concurrent modifications.

A) Store state files in an S3 bucket in a shared tooling account with server-side encryption (SSE-KMS), enable versioning, use DynamoDB for state locking, and grant cross-account access via bucket policies and KMS key policies  
B) Store state files in Terraform Cloud with remote state management  
C) Store state files locally on the CI/CD build agents with regular backups to S3  
D) Use AWS Systems Manager Parameter Store to store state files as SecureString parameters  

**Correct Answer: A**
**Explanation:** Option A is the standard enterprise approach for Terraform state management on AWS. A centralized S3 bucket with SSE-KMS encryption protects state files which contain sensitive information. S3 versioning enables state recovery. DynamoDB state locking prevents concurrent modifications (Terraform's native backend supports this). Cross-account access is managed through bucket policies and KMS key policies, allowing each account's CI/CD pipeline to manage its own state. Option B works but moves state management outside AWS to a third-party service, which may not meet data residency requirements. Option C — local state files are fragile, can't prevent concurrent modifications, and risk data loss. Option D — Parameter Store has a 8KB limit for standard and 8KB for advanced parameters, far too small for Terraform state files.

---

### Question 49
A media company streams live video events to millions of viewers. They use Amazon CloudFront for distribution. During a major live event, they need to ensure that viewers experience less than 3 seconds of latency from the live source. The source encoder outputs in CMAF format to their origin server running on EC2.

A) Configure CloudFront with a short cache TTL (1-2 seconds) on the live segments, enable Origin Shield, and use Amazon CloudFront real-time log analysis to monitor latency  
B) Use Amazon Interactive Video Service (IVS) for ultra-low latency live streaming  
C) Use AWS Elemental MediaLive for encoding and AWS Elemental MediaPackage as the origin for CloudFront, configure low-latency HLS (LL-HLS) or low-latency CMAF output, and enable CloudFront to cache with TTL matching the segment duration  
D) Use AWS Global Accelerator instead of CloudFront for lower latency routing to the EC2 origin  

**Correct Answer: C**
**Explanation:** Option C provides an end-to-end low-latency live streaming solution. MediaLive handles encoding optimization. MediaPackage acts as a just-in-time packaging origin supporting LL-HLS and LL-CMAF, which use chunked transfer encoding to reduce segment availability latency. CloudFront caches segments optimally. LL-HLS/LL-CMAF protocols are designed to achieve sub-3-second glass-to-glass latency at scale. Option A with short TTL on a standard origin still relies on full segment availability, keeping latency at the segment duration (typically 6 seconds). Option B — IVS provides ultra-low latency but is designed for interactive streams with lower viewer counts, not millions of concurrent viewers for live events. Option D — Global Accelerator improves routing but doesn't address the fundamental streaming protocol latency.

---

### Question 50
A company manages an AWS environment where developers frequently create resources for testing but forget to delete them, leading to cost overruns. Resources should be automatically cleaned up after a configurable time period unless explicitly marked as permanent.

A) Implement a Lambda function triggered by a daily EventBridge schedule that scans for resources without a "Permanent" tag and that have exceeded their TTL tag value, and terminates/deletes them. Use AWS Config for resource inventory  
B) Use AWS Config rules to detect old resources and send notifications via SNS to resource owners  
C) Implement a custom AWS Nuke script that runs weekly to delete all resources in development accounts  
D) Use AWS Trusted Advisor to identify underutilized resources and manually review weekly  

**Correct Answer: A**
**Explanation:** Option A provides automated cleanup with flexibility. Resources are tagged with a TTL (time-to-live) value when created. A daily Lambda function queries AWS Config's resource inventory, checks for resources past their TTL without a "Permanent" tag, and deletes them. This is configurable per-resource and automated. Option B only sends notifications without taking cleanup action, relying on developers to act. Option C indiscriminately deletes all resources, which is dangerous for shared development resources. Option D is a manual process that doesn't scale.

---

### Question 51
A company is implementing a blue/green deployment strategy for their Amazon ECS Fargate services fronted by an Application Load Balancer. The deployment must support automated rollback based on CloudWatch alarms, traffic shifting over a 10-minute window, and integration with their CodePipeline CI/CD pipeline.

A) Use AWS CodeDeploy with ECS blue/green deployment type, configure a linear traffic shifting configuration (10% every minute), define rollback alarms based on HTTP 5xx error rate, and add a CodeDeploy deploy action in CodePipeline  
B) Use ECS rolling update deployment with circuit breaker enabled and CloudWatch alarms for manual rollback  
C) Use Route 53 weighted routing to shift traffic between two ECS services and Lambda functions for monitoring  
D) Manage blue/green manually with two ECS services and ALB listener rules, switching traffic with an API call  

**Correct Answer: A**
**Explanation:** Option A provides the complete solution. CodeDeploy with ECS supports native blue/green deployments including linear traffic shifting (e.g., Linear10PercentEvery1Minute shifts 10% of traffic per minute over 10 minutes). CloudWatch alarms (HTTP 5xx rate) trigger automatic rollback to the original task set. CodePipeline integrates natively with CodeDeploy as a deploy action. Option B — rolling updates replace tasks gradually but don't provide traffic shifting or easy rollback to the previous version. Option C — Route 53 weighted routing operates at DNS level with TTL-dependent propagation, not suitable for precise 10-minute traffic shifting. Option D requires manual orchestration and custom monitoring.

---

### Question 52
A company has a Step Functions workflow that generates quarterly financial reports. The workflow aggregates data from 12 different data sources, each taking 1-5 minutes to query. After aggregation, a Lambda function generates the report. The current sequential design takes 40 minutes. The solutions architect needs to reduce execution time.

A) Use a Map state in inline mode with each data source as an item in the input array, running all 12 queries in parallel, followed by the report generation Lambda  
B) Use a Parallel state with 12 branches, one for each data source query, followed by the report generation Lambda  
C) Use Step Functions Distributed Map to fan out data source queries across thousands of parallel Lambda invocations  
D) Replace Step Functions with a single Lambda function that uses Python asyncio to query all data sources concurrently  

**Correct Answer: B**
**Explanation:** Option B is the correct approach. A Parallel state runs all 12 branches concurrently (one per data source). Each branch outputs its aggregated data, and the Parallel state waits for all branches to complete before passing the combined results to the report generation Lambda. This reduces execution time from 40 minutes to approximately 5 minutes (the longest single query) plus report generation time. Option A — Map state with inline mode works when all items use the same processing logic; since each data source likely has different query logic, Parallel state with distinct branches is more appropriate. Option C — Distributed Map is designed for processing millions of items from S3, overkill for 12 data sources. Option D — Lambda has a 15-minute timeout and doesn't provide the visibility and error handling of Step Functions.

---

### Question 53
A company needs to provide 500 external partners with secure access to specific S3 objects in their AWS account. Each partner should only access their own folder in the bucket. Partners don't have AWS accounts. Access must be time-limited and auditable.

A) Generate S3 presigned URLs for each partner scoped to their folder prefix, with an expiration time, delivered through a secure partner portal. Log all access using S3 server access logging and CloudTrail data events  
B) Create IAM users for each partner with S3 policies restricting access to their folder  
C) Use S3 Access Points with one access point per partner, each with a policy restricting to their folder prefix  
D) Make the bucket public and use obscure folder naming for security  

**Correct Answer: A**
**Explanation:** Option A is the best solution for external partners without AWS accounts. Presigned URLs provide temporary, scoped access without requiring AWS credentials. A partner portal (web application) authenticates partners and generates presigned URLs specific to their folder prefix. URLs expire after the configured time. S3 server access logging and CloudTrail data events provide complete audit trails. Option B — creating 500 IAM users requires managing AWS credentials for external parties, which is operationally complex and a security concern. Option C — S3 Access Points still require AWS authentication and are better suited for internal use cases. Option D — public access with obscure naming is security through obscurity, which is fundamentally insecure.

---

### Question 54
A solutions architect is designing a high-availability architecture for a stateful TCP-based application that runs on EC2 instances behind a Network Load Balancer. The application maintains long-lived connections (up to 24 hours) and requires session affinity. If an instance fails, new connections should be routed to healthy instances, but existing connections to failed instances are expected to be re-established by the client.

A) Configure the NLB with stickiness enabled (source IP affinity), cross-zone load balancing enabled, and TCP health checks with a 10-second interval. Use an Auto Scaling group across multiple AZs with the NLB target group  
B) Use an Application Load Balancer with cookie-based session affinity and WebSocket support  
C) Deploy instances in a single AZ to avoid cross-AZ latency for sticky sessions, with a standby instance in another AZ  
D) Use Route 53 multivalue routing as a load balancer with health checks  

**Correct Answer: A**
**Explanation:** Option A correctly addresses all requirements. NLB is designed for TCP-based applications with long-lived connections. Source IP affinity (stickiness) ensures a client's connections consistently route to the same instance. Cross-zone load balancing distributes traffic evenly. TCP health checks detect failed instances, and the NLB stops routing new connections to them. Auto Scaling replaces failed instances. Client-side reconnection logic handles re-establishing dropped connections. Option B — ALB operates at Layer 7 (HTTP) and doesn't support arbitrary TCP protocols. Option C — single AZ deployment eliminates high availability. Option D — Route 53 multivalue is DNS-based with TTL-dependent failover, not suitable for real-time connection management.

---

### Question 55
A company wants to migrate their self-hosted GitLab CI/CD to AWS-native services. Their pipeline includes: source code management, build and unit tests, static code analysis, container image scanning, deployment to EKS staging, integration tests, and deployment to EKS production with manual approval. What is the recommended architecture?

A) Use AWS CodeCommit for source control, AWS CodeBuild for builds/tests/scanning, Amazon ECR for images with scan-on-push, AWS CodePipeline for orchestration with a manual approval action before production deployment, and AWS CodeDeploy for EKS deployments  
B) Use GitHub for source control, AWS CodePipeline for orchestration, CodeBuild for builds, third-party scanning tools, and Helm charts applied via CodeBuild for EKS deployments  
C) Migrate to GitHub Actions entirely with self-hosted runners on EKS for all pipeline stages  
D) Use AWS Proton for the entire pipeline with service templates for each stage  

**Correct Answer: A**
**Explanation:** Option A provides a fully AWS-native CI/CD pipeline. CodeCommit replaces GitLab for source control. CodeBuild handles builds, unit tests, and static analysis. ECR's built-in scan-on-push replaces separate container scanning. CodePipeline orchestrates the stages with a native manual approval action before production. CodeDeploy handles EKS deployments. All services integrate natively. Option B uses GitHub (non-AWS) and third-party scanning tools, not fully AWS-native. Option C uses GitHub Actions, not AWS-native. Option D — Proton is an infrastructure provisioning service for platform teams, not a CI/CD pipeline replacement.

---

### Question 56
A company runs an IoT platform that processes telemetry from 100,000 devices. Each device sends a 1KB message every 10 seconds. The data must be processed in real-time for anomaly detection and stored for historical analysis. The current architecture uses Amazon Kinesis Data Streams but is experiencing `ProvisionedThroughputExceededException` errors.

A) Increase the number of Kinesis shards using the UpdateShardCount API, implement enhanced fan-out for the consumer, and use the Kinesis Producer Library (KPL) with aggregation to batch multiple device messages per record  
B) Replace Kinesis with Amazon SQS for the ingestion layer  
C) Switch to Amazon MSK (Kafka) with automatic topic partition scaling  
D) Use Amazon IoT Core rules engine to route messages directly to Lambda for processing and S3 for storage  

**Correct Answer: A**
**Explanation:** Option A directly addresses the throughput exception. At 100,000 devices sending every 10 seconds, that's 10,000 messages/second. Each Kinesis shard supports 1,000 records/second or 1 MB/second for writes. KPL aggregation packs multiple device messages into a single Kinesis record, dramatically increasing effective throughput per shard. Enhanced fan-out provides dedicated read throughput per consumer. UpdateShardCount increases capacity as needed. Option B — SQS doesn't provide the real-time ordered stream processing needed for anomaly detection. Option C — MSK could work but introduces significant operational complexity compared to adding shards to Kinesis. Option D — IoT Core rules engine has throughput limits and Lambda invocations at 10,000/second would be expensive and hit concurrency limits.

---

### Question 57
A company is building a multi-tenant SaaS application where each tenant's data must be isolated in the database layer. They use Amazon Aurora PostgreSQL. Some tenants require dedicated compute resources while others can share. The company expects 500+ tenants and needs to minimize operational overhead.

A) Use a silo model for premium tenants (dedicated Aurora clusters) and a pool model for standard tenants (shared Aurora cluster with row-level security using tenant_id). Use a routing layer to direct queries to the appropriate cluster  
B) Create separate Aurora clusters for every tenant  
C) Use a single Aurora cluster with separate schemas per tenant  
D) Use Amazon DynamoDB with tenant_id as the partition key for all tenants  

**Correct Answer: A**
**Explanation:** Option A implements a hybrid isolation model which is the industry best practice for multi-tenant SaaS. Premium tenants requiring dedicated compute get their own Aurora clusters (silo model) providing complete isolation. Standard tenants share an Aurora cluster using PostgreSQL row-level security (RLS) policies that filter data by tenant_id (pool model), providing logical isolation with efficient resource utilization. A routing layer (API Gateway + Lambda or a service mesh) directs each tenant's queries to the appropriate cluster. Option B — 500+ dedicated clusters is operationally prohibitive and expensive. Option C — separate schemas provide logical isolation but all tenants share compute, not meeting the dedicated compute requirement for some tenants. Option D changes the database technology which may require application rewrite.

---

### Question 58
A solutions architect needs to design a caching strategy for a high-traffic e-commerce product catalog API. The catalog has 500,000 products that update 100 times per hour. The API serves 100,000 requests per second. Stale data is acceptable for up to 60 seconds but not longer.

A) Use Amazon ElastiCache for Redis with a cache-aside pattern, 60-second TTL on cached items, and an EventBridge pipe from DynamoDB Streams to a Lambda function that invalidates specific cache entries when products are updated  
B) Use CloudFront caching with a 60-second TTL for all API responses  
C) Use ElastiCache for Memcached with write-through caching and a 60-second TTL  
D) Implement application-level caching in the API servers' memory using LRU eviction  

**Correct Answer: A**
**Explanation:** Option A provides precise cache invalidation within the staleness tolerance. Cache-aside pattern loads from the database on cache miss and caches the result. The 60-second TTL ensures stale data doesn't persist beyond the tolerance. DynamoDB Streams captures product updates in real-time, and a Lambda function invalidates the specific cache entry, reducing the window of stale data to near-zero for frequently updated products. Option B — CloudFront caching at the CDN level works for static content but doesn't handle targeted invalidation efficiently (invalidation API has limits). Option C — write-through caching updates the cache on every write but Memcached doesn't support the same data structure richness as Redis and lacks persistence. Option D — application-level caching doesn't share state across API server instances and can't handle 100K RPS efficiently.

---

### Question 59
A company needs to implement end-to-end encryption for data in transit within their VPC. Application servers on EC2 communicate with RDS PostgreSQL, ElastiCache Redis, and Amazon OpenSearch Service. All connections must use TLS 1.2 or higher, and certificates must be managed centrally.

A) Enable SSL/TLS on RDS PostgreSQL using the rds-ca-2019 certificate bundle, enable in-transit encryption on ElastiCache for Redis, configure OpenSearch with node-to-node encryption and HTTPS, and use AWS Private CA for application server certificates  
B) Use VPC encryption by default to encrypt all traffic within the VPC  
C) Place all services behind a Network Load Balancer with TLS termination  
D) Use AWS PrivateLink for all service connections, which encrypts traffic by default  

**Correct Answer: A**
**Explanation:** Option A correctly configures TLS for each service. RDS PostgreSQL supports SSL connections using AWS-provided CA certificates. ElastiCache for Redis supports in-transit encryption (TLS). OpenSearch supports HTTPS and node-to-node encryption. AWS Private CA provides centrally managed certificates for the application servers. Each service requires individual TLS configuration as there's no VPC-level blanket encryption. Option B — there is no VPC encryption feature that automatically encrypts all traffic. Option C — NLB TLS termination means traffic from NLB to backends would be unencrypted unless re-encrypted. Option D — PrivateLink provides private connectivity but does not encrypt data in transit at the application layer.

---

### Question 60
A company is implementing a data mesh architecture on AWS. Each business domain (marketing, sales, finance) owns and publishes their data products. Consumers across domains need to discover and access these data products while maintaining domain autonomy and data governance. **(Select TWO)**

A) Use AWS Lake Formation with data sharing across accounts, where each domain has its own AWS account and S3 data lake, and Lake Formation permissions control cross-domain access  
B) Use AWS Glue Data Catalog as a central metadata registry with Lake Formation tag-based access control for cross-domain discovery and access governance  
C) Create a central data warehouse in Amazon Redshift that ingests data from all domains  
D) Use AWS DataZone for data mesh governance with domain-specific publishing and consumer subscription workflows  
E) Store all data in a single S3 bucket with folder-level IAM policies for domain isolation  

**Correct Answer: A, D**
**Explanation:** Options A and D together provide a complete data mesh implementation. AWS DataZone (D) is purpose-built for data mesh governance — it supports domain-specific publishing of data products, consumer discovery through a business data catalog, and subscription/approval workflows for access governance. Lake Formation with cross-account data sharing (A) enables each domain to maintain autonomy in their own AWS account while sharing data products with consumers through fine-grained permissions. Option B — Glue Data Catalog is a metadata store, not a data mesh governance tool (though it's used by Lake Formation and DataZone). Option C — a central data warehouse is the opposite of a data mesh philosophy (centralized vs. decentralized). Option E — a single S3 bucket with folder-level policies doesn't provide domain autonomy or governance workflows.

---

### Question 61
A healthcare company runs ECS tasks that process Protected Health Information (PHI). They need to ensure that ECS tasks can only pull images from their approved ECR repositories, secrets are injected securely at runtime, and all task-level API calls are logged. What combination of controls should be implemented?

A) Use ECS task execution role with an IAM policy scoped to specific ECR repositories, inject secrets using Secrets Manager references in the task definition's secrets section, enable ECS exec logging to CloudWatch, and use AWS CloudTrail for API logging  
B) Use a public Docker Hub registry with image signing for trusted images  
C) Store secrets as environment variables in the ECS task definition and restrict access using security groups  
D) Use ECS Anywhere with on-premises container runtime for complete control over the execution environment  

**Correct Answer: A**
**Explanation:** Option A provides comprehensive security. The task execution role's IAM policy restricts ECR image pulls to specific repository ARNs, preventing unauthorized images. Secrets Manager references in the task definition inject secrets securely at runtime without embedding them in environment variables or images. ECS Exec logging captures interactive session activity. CloudTrail logs all ECS API calls. Option B — public Docker Hub lacks enterprise security controls and isn't HIPAA-appropriate for PHI workloads. Option C — environment variables in task definitions are visible in the console and API responses, not secure for PHI-related secrets. Option D — ECS Anywhere adds operational complexity and moves away from managed infrastructure.

---

### Question 62
A company's data warehouse team runs complex queries on Amazon Redshift that join data from the Redshift cluster with data stored in S3 (using Redshift Spectrum) and data in an Aurora PostgreSQL database. Some queries take over 30 minutes due to the federated query overhead. How should the solutions architect optimize this?

A) Create materialized views in Redshift that pre-join frequently accessed data from Aurora and S3, schedule materialized view refreshes, and use Redshift result caching for repeated queries  
B) Migrate all data from Aurora and S3 into Redshift for co-located queries  
C) Use Amazon Athena with federated query instead of Redshift Spectrum  
D) Increase the Redshift cluster size by doubling the number of nodes  

**Correct Answer: A**
**Explanation:** Option A addresses the performance issue effectively. Materialized views in Redshift can pre-compute joins across local Redshift data, Spectrum (S3), and federated Aurora data. Scheduled refreshes keep the materialized views current. Result caching avoids re-executing identical queries. This dramatically reduces query time for repeated and similar query patterns. Option B — migrating all data to Redshift eliminates the federated architecture's flexibility and may significantly increase storage costs for large S3 datasets. Option C — Athena doesn't improve performance over Redshift Spectrum for this use case. Option D — adding nodes helps with Redshift-internal processing but doesn't address the federated query overhead from Aurora and S3.

---

### Question 63
A company has deployed a containerized application on Amazon EKS with Kubernetes Cluster Autoscaler. During traffic spikes, new pods are stuck in Pending state for 5-8 minutes while the autoscaler provisions new nodes. The company wants to reduce this wait time to under 2 minutes.

A) Replace Cluster Autoscaler with Karpenter, which provisions right-sized nodes faster by directly calling the EC2 fleet API, and configure node templates with preferred instance types from multiple families  
B) Increase the Cluster Autoscaler's scale-up speed by reducing the scan interval to 1 second  
C) Pre-provision a large pool of always-running nodes to absorb any traffic spike  
D) Use Fargate profiles for all pods to eliminate node provisioning entirely  

**Correct Answer: A**
**Explanation:** Option A is the best solution. Karpenter is a Kubernetes node autoscaler that provisions nodes significantly faster than Cluster Autoscaler because it directly calls EC2 fleet APIs instead of working through Auto Scaling Groups. It selects optimal instance types based on pending pod requirements and can provision nodes in under 2 minutes. Node templates allow specifying instance family flexibility for faster availability. Option B — Cluster Autoscaler's bottleneck isn't the scan interval but the ASG scaling mechanism which requires ASG health checks and lifecycle hooks. Option C wastes resources and cost. Option D — Fargate has its own cold start time (30-60+ seconds per pod) and doesn't support DaemonSets, hostNetwork, or other Kubernetes features that may be required.

---

### Question 64
A company uses AWS Organizations with multiple OUs. They need to provide a self-service mechanism for development teams to create new AWS accounts that automatically conform to the company's security and networking baselines, including VPC setup, security group templates, IAM identity provider configuration, and GuardDuty enablement.

A) Use AWS Control Tower Account Factory for Terraform (AFT) to automate account creation with customized Terraform templates that provision networking, security, and identity baselines as part of the account vending pipeline  
B) Manually create accounts in the AWS Organizations console and run a baseline CloudFormation template after creation  
C) Allow development teams to create their own AWS accounts using the AWS sign-up page and then invite them to the organization  
D) Use AWS Service Catalog with a product that provisions a new account via a Lambda-backed custom resource and runs baseline configuration  

**Correct Answer: A**
**Explanation:** Option A provides the most comprehensive solution. Control Tower Account Factory for Terraform (AFT) allows teams to submit account requests through a Terraform-based pipeline. AFT automatically creates the account through Control Tower's Account Factory, applies Control Tower guardrails, and then runs custom Terraform templates for networking (VPC), security (security groups, GuardDuty), and identity (IAM Identity Provider) baselines. This is fully automated and self-service. Option B requires manual steps after account creation. Option C creates accounts outside the organization with no baseline. Option D can work but requires more custom development and doesn't provide the pre-built governance guardrails that Control Tower includes.

---

### Question 65
A company processes credit card transactions and must comply with PCI DSS. They use Amazon ECS for their cardholder data environment (CDE). The solutions architect needs to ensure proper network segmentation between the CDE and non-CDE environments, restrict outbound internet access from the CDE, and enable detailed network monitoring.

A) Place CDE ECS tasks in private subnets with no NAT gateway, use VPC endpoints for required AWS service access, implement security groups and NACLs for microsegmentation, enable VPC Flow Logs with traffic mirroring for detailed inspection, and use AWS Firewall Manager for centralized security group management  
B) Use separate VPCs for CDE and non-CDE with VPC peering and security groups  
C) Use a WAF in front of the ALB to segment CDE and non-CDE traffic  
D) Place CDE tasks in public subnets with security groups restricting inbound traffic  

**Correct Answer: A**
**Explanation:** Option A provides PCI DSS-compliant network segmentation. Private subnets without NAT gateway prevent all outbound internet access. VPC endpoints provide private, controlled access to required AWS services (ECR, CloudWatch, Secrets Manager). Security groups and NACLs create microsegmentation between CDE and non-CDE. VPC Flow Logs meet logging requirements, and traffic mirroring enables deep packet inspection for PCI compliance. Firewall Manager ensures consistent security group management. Option B — VPC peering allows communication which could violate segmentation if not carefully controlled. Option C — WAF is for web application protection, not network segmentation. Option D — public subnets expose CDE tasks to the internet, violating PCI DSS requirements.

---

### Question 66
A solutions architect needs to optimize the performance of a Lambda function that processes API Gateway requests. The function currently has a p99 latency of 3 seconds, with 2 seconds attributed to cold starts. The function uses a 512MB memory allocation and connects to an RDS database in a VPC. The target p99 latency is under 500ms.

A) Increase the Lambda memory to 1769MB (1 full vCPU), enable provisioned concurrency based on expected traffic, use RDS Proxy for connection pooling, and implement Lambda SnapStart if using Java  
B) Move the database connection initialization outside the handler function and increase the timeout to 30 seconds  
C) Replace Lambda with an ECS Fargate service for consistent performance  
D) Use Lambda@Edge for lower latency execution closer to the user  

**Correct Answer: A**
**Explanation:** Option A addresses all performance bottlenecks. Increasing memory to 1769MB allocates a full vCPU, speeding up initialization. Provisioned concurrency eliminates cold starts entirely by keeping function instances pre-initialized. RDS Proxy eliminates database connection overhead (VPC cold start used to be an issue but is now minimal; connection pooling is still valuable). SnapStart (for Java runtimes) reduces cold starts by snapshotting the initialized execution environment. Together, these bring p99 well under 500ms. Option B — moving initialization outside the handler is already a best practice but doesn't eliminate cold starts (initialization still runs on cold start). Option C replaces serverless with containers, losing auto-scaling and pay-per-use benefits. Option D — Lambda@Edge is for CloudFront event processing and can't connect to RDS in a VPC.

---

### Question 67
A company has a complex AWS Step Functions workflow with 50+ states. When issues occur, debugging is difficult because the team can't easily trace the execution path or identify which state failed. They need better observability into their Step Functions executions.

A) Enable Step Functions X-Ray tracing for distributed tracing, use CloudWatch Logs for execution history logging (ALL events level), create CloudWatch dashboards for execution metrics, and use Step Functions execution event history API for programmatic debugging  
B) Add CloudWatch custom metrics in each Lambda function to track execution progress  
C) Enable AWS CloudTrail for Step Functions API call logging  
D) Use Step Functions Express Workflows instead, which have built-in CloudWatch Logs integration  

**Correct Answer: A**
**Explanation:** Option A provides comprehensive observability. X-Ray tracing visualizes the execution path through all states, showing timing and errors. CloudWatch Logs integration at ALL events level captures every state transition, input/output, and error for detailed debugging. CloudWatch dashboards display execution metrics (successes, failures, duration). The execution event history API enables programmatic analysis and alerting. Together, these make debugging the 50+ state workflow manageable. Option B only tracks Lambda states, missing Choice, Wait, Parallel, and other state types. Option C — CloudTrail logs API calls (StartExecution, DescribeExecution) but not internal state execution details. Option D — switching to Express Workflows may break functionality (5-minute limit) and isn't an observability improvement for the existing Standard Workflow.

---

### Question 68
A company is implementing a data retention and lifecycle policy for their S3 data lake containing 200TB across multiple buckets. Data access patterns show: hot data (0-30 days, frequent access), warm data (31-180 days, occasional access), cold data (181 days-2 years, rare access), and archive data (2-7 years, almost never accessed). After 7 years, data must be permanently deleted. **(Select TWO)**

A) Implement S3 Lifecycle policies to transition objects: S3 Standard (0-30 days) → S3 Standard-IA (31-180 days) → S3 Glacier Instant Retrieval (181 days-2 years) → S3 Glacier Deep Archive (2-7 years), with expiration at 7 years  
B) Use S3 Intelligent-Tiering for all data to automatically optimize storage costs  
C) Implement S3 Object Lock with a retention period of 7 years followed by a lifecycle expiration rule  
D) Use S3 Lifecycle policies with the Expiration action set to 2,555 days (7 years) to auto-delete expired data  
E) Manually review and delete data quarterly using S3 Inventory reports  

**Correct Answer: A, D**
**Explanation:** Options A and D together provide the complete lifecycle management. Option A defines transitions matching the access patterns: Standard for hot access, Standard-IA for warm (lower cost, retrieval fee), Glacier Instant Retrieval for cold (millisecond retrieval when rarely needed), and Glacier Deep Archive for archive (lowest cost). Option D ensures permanent deletion at 7 years through the Expiration action, meeting the data retention policy. Option B — Intelligent-Tiering is useful when access patterns are unpredictable, but here the patterns are well-defined, making explicit lifecycle rules more cost-effective (no monitoring fee per object). Option C — Object Lock prevents deletion, which conflicts with the need to delete after 7 years (Compliance mode). Option E is manual and doesn't scale.

---

### Question 69
A company is deploying a new microservice that needs to process messages from an SQS queue. During normal operations, the message volume is 1,000/hour. During promotional events, it spikes to 500,000/hour. Messages must be processed within 5 minutes of being sent. The processing logic takes 10 seconds per message.

A) Use a Lambda function triggered by SQS with reserved concurrency of 500, batch size of 10, and a maximum concurrency setting on the event source mapping to prevent throttling downstream services  
B) Use an ECS Fargate service with SQS-based auto scaling  
C) Use a single EC2 instance polling the SQS queue  
D) Use Lambda with default concurrency and no reserved concurrency  

**Correct Answer: A**
**Explanation:** Option A is well-designed. Lambda-SQS integration automatically scales consumers based on queue depth. Reserved concurrency of 500 ensures capacity during spikes while preventing runaway scaling. With batch size of 10 and 10-second processing per message, each Lambda invocation processes 10 messages. At 500,000 messages/hour (~139/second), you need ~14 concurrent invocations minimum. The maximum concurrency setting on the event source mapping provides fine-grained control over scaling to protect downstream services. Option B works but Fargate scaling is slower to react (minutes vs. seconds for Lambda). Option C — a single EC2 instance can't handle 500,000 messages/hour within the 5-minute processing window. Option D — without reserved concurrency, spikes could consume the account's Lambda concurrency pool, affecting other functions.

---

### Question 70
A company has a legacy application that uses multicast networking for service discovery and state synchronization between application servers. They want to migrate this application to AWS without modifying the application code.

A) Use AWS Transit Gateway with multicast support enabled, create a Transit Gateway multicast domain, and deploy the application on EC2 instances in VPCs attached to the Transit Gateway with multicast-enabled subnets  
B) Use Application Load Balancer with target groups for service discovery and replace multicast with ALB-based communication  
C) Deploy the application in a single VPC with a large subnet and rely on VPC's built-in multicast support  
D) Use Amazon VPC with AWS Cloud Map for service discovery to replace multicast functionality  

**Correct Answer: A**
**Explanation:** Option A is correct. AWS Transit Gateway supports IP multicast, making it the only AWS networking service that provides multicast capability. By creating a Transit Gateway multicast domain and associating EC2 instances as multicast group members, the legacy application can use multicast without code changes. This is specifically designed for migrating multicast-dependent applications to AWS. Option B requires application modification to use ALB instead of multicast. Option C — VPCs do not natively support multicast; this is a common misconception. Option D — Cloud Map replaces service discovery but doesn't support the state synchronization aspect that relies on multicast.

---

### Question 71
A company runs a global API serving customers in North America, Europe, and Asia. The API is deployed in us-east-1 with an ALB and ECS. They want to improve performance for European and Asian users while maintaining a single deployment for simplicity. API responses are not cacheable (personalized data).

A) Place Amazon CloudFront in front of the ALB with caching disabled (cache policy with TTL 0), which still improves performance by using AWS's backbone network and persistent connections to the origin  
B) Use AWS Global Accelerator to route users to the nearest AWS edge location and then over the AWS global network to us-east-1  
C) Deploy the API in three regions and use Route 53 latency-based routing  
D) Use Route 53 geolocation routing to direct all traffic to us-east-1  

**Correct Answer: B**
**Explanation:** Option B is the best answer. Global Accelerator provides static anycast IP addresses that route traffic to the nearest AWS edge location. From there, traffic travels over AWS's private global backbone network to us-east-1, avoiding public internet routing. This reduces latency significantly for European and Asian users while maintaining a single deployment. Global Accelerator also provides instant failover capabilities. Option A — CloudFront with no caching can also use the AWS backbone, but Global Accelerator is better suited for non-cacheable API traffic as it operates at Layer 4 (TCP/UDP) with lower overhead than CloudFront's Layer 7 processing. Option C requires multi-region deployment which contradicts the single deployment requirement. Option D — geolocation routing just determines DNS resolution location, it doesn't improve network path performance.

---

### Question 72
A company uses AWS Step Functions to orchestrate nightly data processing. The workflow has grown to include 200+ states and is becoming difficult to manage. Some portions of the workflow are reused across multiple workflows. The team wants to modularize the design.

A) Break the monolithic workflow into nested state machines using Step Functions' ability to invoke other state machines as a task state. Create reusable sub-workflows for common patterns and call them from parent workflows  
B) Convert the entire workflow to AWS Lambda orchestrated via EventBridge rules  
C) Split the workflow into separate Step Functions workflows connected by SQS queues  
D) Use AWS Step Functions Workflow Studio to visually manage the large workflow  

**Correct Answer: A**
**Explanation:** Option A implements proper modular design. Step Functions supports invoking other state machines using the `arn:aws:states:::states:startExecution` service integration. This enables creating reusable sub-workflows (e.g., data validation, notification, error handling) that multiple parent workflows can call. The parent workflow waits for the sub-workflow to complete and receives its output. This dramatically simplifies management of the 200+ state workflow by breaking it into manageable, testable components. Option B loses the orchestration visibility and error handling that Step Functions provides. Option C introduces loose coupling via SQS that makes it harder to track end-to-end execution and handle errors. Option D helps with visualization but doesn't solve the modularity or reusability problem.

---

### Question 73
A company is migrating a monolithic Java application to a microservices architecture on AWS. The application currently uses a shared Oracle database. During the migration, some microservices will be extracted while others remain in the monolith. Both the monolith and new microservices need to access data during the transition period. What data migration strategy should the solutions architect recommend?

A) Implement the Strangler Fig pattern with a database-per-service approach. Extract microservices one at a time, giving each its own database (RDS or DynamoDB). Use change data capture (CDC) with AWS DMS to synchronize data between the shared Oracle database and new microservice databases during the transition  
B) Migrate the entire Oracle database to Aurora PostgreSQL first, then start extracting microservices  
C) Keep all microservices connected to the shared Oracle database until the full migration is complete  
D) Perform a big-bang migration of all services simultaneously to avoid the transition period  

**Correct Answer: A**
**Explanation:** Option A follows the proven Strangler Fig pattern for incremental migration. Each extracted microservice gets its own database (database-per-service pattern), enabling independent scaling and technology selection. AWS DMS with CDC maintains real-time data synchronization between the original Oracle database and new microservice databases during the transition period, allowing the monolith and microservices to coexist. As services are extracted, CDC streams are retired. Option B delays microservice extraction and forces a single database technology choice upfront. Option C maintains the shared database anti-pattern, creating tight coupling. Option D is high-risk with extended downtime for a complex application.

---

### Question 74
A financial services company needs to ensure that all Amazon EBS volumes in their production account are encrypted with a specific customer-managed KMS key. Existing unencrypted volumes must be detected and remediated. New unencrypted volumes must be prevented from being created.

A) Enable EBS encryption by default in the account with the specified CMK as the default key. Deploy an AWS Config rule (encrypted-volumes) with an SSM Automation remediation that creates encrypted snapshots and replaces unencrypted volumes. Add an SCP denying ec2:CreateVolume without the encryption parameter  
B) Use AWS Config to detect unencrypted volumes and send SNS notifications for manual remediation  
C) Enable EBS encryption by default and assume all future volumes will be encrypted  
D) Write a Lambda function that runs hourly to scan for and encrypt unencrypted volumes  

**Correct Answer: A**
**Explanation:** Option A provides a three-layer defense. Enabling EBS encryption by default with the specified CMK ensures all new volumes created without explicit encryption settings are encrypted automatically. The AWS Config rule detects any existing unencrypted volumes, and SSM Automation remediation automatically creates an encrypted copy and replaces the volume. The SCP provides an additional preventive layer by denying volume creation that explicitly disables encryption. Option B only detects without automated remediation. Option C — encryption by default can be overridden by explicitly creating unencrypted volumes (by setting Encrypted=false). Option D is periodic rather than real-time and doesn't prevent creation of unencrypted volumes.

---

### Question 75
A company runs a large-scale batch analytics platform on AWS. They use Amazon EMR clusters that launch nightly, process data for 6 hours, and terminate. The clusters use 100 r5.4xlarge instances. The company has been running this workload consistently for 2 years and expects it to continue for at least 3 more years. The solutions architect needs to reduce costs significantly.

A) Purchase 3-year partial upfront Reserved Instances for r5.4xlarge to cover the baseline, and use Spot instances for any additional capacity  
B) Use Spot instances for the entire cluster with multiple instance type diversification  
C) Purchase an EC2 Instance Savings Plan for a 3-year term with all upfront payment, sized for the 6-hour nightly usage pattern, covering the compute spend  
D) Use EMR Managed Scaling with a mix of On-Demand core nodes and Spot task nodes  

**Correct Answer: C**
**Explanation:** Option C is the most cost-effective. EC2 Instance Savings Plans provide up to 72% savings for a 3-year all-upfront commitment. Unlike Reserved Instances, Savings Plans apply to the compute spend regardless of instance type, size, or region, providing flexibility. The plan is sized based on the consistent nightly usage (100 x r5.4xlarge for 6 hours/night). Since the workload is predictable and runs for at least 3 more years, the commitment is well-justified. Option A — Reserved Instances are less flexible than Savings Plans and partial upfront provides less savings than all upfront. Option B — 100% Spot for the entire cluster risks interruption during the 6-hour processing window. Option D helps with scaling but doesn't address the fundamental pricing optimization for the predictable baseline workload.

---

**End of Practice Test 05**

Total Questions: 75
- Domain 1 (Organizational Complexity): Questions 1, 3, 8, 12, 16, 20, 24, 27, 34, 40, 44, 48, 53, 57, 60, 64, 65, 70, 73, 74 (20)
- Domain 2 (New Solutions): Questions 2, 4, 6, 7, 9, 13, 14, 17, 22, 26, 28, 31, 33, 39, 43, 46, 49, 54, 56, 59, 61, 69 (22)
- Domain 3 (Continuous Improvement): Questions 11, 15, 29, 35, 37, 41, 45, 52, 62, 63, 67 (11)
- Domain 4 (Migration & Modernization): Questions 10, 19, 32, 38, 47, 55, 66, 72, 73 (9)
- Domain 5 (Cost Optimization): Questions 5, 18, 21, 23, 25, 36, 42, 50, 58, 68, 71, 75, 51 (13)
