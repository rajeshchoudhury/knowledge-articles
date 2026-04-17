# Compute Question Bank

**AWS Solutions Architect Associate (SAA-C03) — Topic-Wise Practice**
**Total Questions: 30**

---

### Question 1
A company runs a batch processing workload that can tolerate interruptions. The workload runs for 2-6 hours and can be checkpointed and resumed. The company wants to minimize costs. Which EC2 purchasing option should the architect recommend?

A) On-Demand Instances
B) Reserved Instances with a 1-year term
C) Spot Instances
D) Dedicated Hosts

**Answer: C**
**Explanation:** Spot Instances offer up to 90% discount over On-Demand and are ideal for workloads that can tolerate interruptions. Since the batch job supports checkpointing and resumption, Spot Instances are the most cost-effective option. On-Demand (A) is more expensive. Reserved Instances (B) require a commitment and are suited for steady-state workloads. Dedicated Hosts (D) are the most expensive option.

---

### Question 2
A company runs a critical production database on EC2 that requires the lowest possible latency for storage. The database performs random I/O operations and requires 64,000 IOPS consistently. Which EBS volume type should the architect choose?

A) General Purpose SSD (gp3)
B) Provisioned IOPS SSD (io2 Block Express)
C) Throughput Optimized HDD (st1)
D) Cold HDD (sc1)

**Answer: B**
**Explanation:** io2 Block Express supports up to 256,000 IOPS with sub-millisecond latency and 99.999% durability. gp3 (A) maxes out at 16,000 IOPS. st1 (C) and sc1 (D) are HDD volumes that cannot provide high IOPS — they are optimized for throughput and cold data respectively.

---

### Question 3
A company needs to run a memory-intensive application that processes large in-memory datasets. The application requires at least 512 GB of RAM. Which EC2 instance family is MOST appropriate?

A) C-family (Compute Optimized)
B) R-family (Memory Optimized)
C) T-family (Burstable)
D) M-family (General Purpose)

**Answer: B**
**Explanation:** R-family instances (e.g., r6i, r6g) are memory optimized with a high memory-to-CPU ratio, ideal for in-memory databases, caches, and big data analytics. C-family (A) is compute optimized. T-family (C) is for burstable workloads with variable CPU needs. M-family (D) provides balanced compute and memory but not the high memory ratios needed.

---

### Question 4
A company has a web application running on EC2 instances in an Auto Scaling group. The application experiences predictable traffic spikes every day at 9 AM and traffic drops at 6 PM. What Auto Scaling policy should the architect implement?

A) Target tracking scaling policy based on CPU utilization
B) Scheduled scaling actions to increase capacity before 9 AM and decrease after 6 PM
C) Simple scaling policy triggered by CloudWatch alarms
D) Manual scaling by an operations team

**Answer: B**
**Explanation:** Scheduled scaling is ideal for predictable, recurring traffic patterns. By scheduling scale-out before 9 AM, instances are ready when traffic arrives. Target tracking (A) is reactive — it scales after the metric changes, which can cause a delay during traffic spikes. Simple scaling (C) is also reactive. Manual scaling (D) is error-prone and not operationally efficient.

---

### Question 5
A company runs an application that requires low-latency, high-throughput communication between EC2 instances. The instances perform HPC (High Performance Computing) workloads with tightly coupled node-to-node communication. What should the architect configure?

A) Deploy instances in a spread placement group
B) Deploy instances in a cluster placement group with Enhanced Networking enabled
C) Deploy instances across multiple Availability Zones
D) Use burstable T3 instances for cost savings

**Answer: B**
**Explanation:** Cluster placement groups place instances in a single AZ on the same underlying hardware rack, providing the lowest latency and highest throughput for inter-node communication. Enhanced Networking (ENA or EFA) further reduces latency. Spread placement groups (A) maximize high availability by spreading across hardware. Multiple AZs (C) increase latency. T3 instances (D) aren't suited for HPC.

---

### Question 6
A company runs a legacy application on a single EC2 instance. The application writes data to a local instance store volume. The operations team is concerned about data loss if the instance is stopped or terminated. What should the architect recommend?

A) Instance store data persists across instance stops, so no action is needed
B) Migrate the data storage to an EBS volume which persists independently of the instance lifecycle
C) Take snapshots of the instance store volume regularly
D) Configure RAID 0 across multiple instance store volumes for redundancy

**Answer: B**
**Explanation:** Instance store volumes are ephemeral — data is lost when the instance is stopped, terminated, or if the underlying hardware fails. EBS volumes persist independently and can be detached/reattached. Instance store data does NOT persist across stops (A). You cannot take EBS snapshots of instance store volumes (C). RAID 0 (D) stripes data for performance but provides no redundancy.

---

### Question 7
A company needs to run containers in AWS without managing the underlying EC2 infrastructure. The workload is event-driven with unpredictable traffic patterns. What is the MOST operationally efficient solution?

A) Deploy containers on ECS with EC2 launch type and Auto Scaling
B) Deploy containers on ECS with Fargate launch type
C) Deploy containers on self-managed EC2 instances with Docker installed
D) Use Amazon EKS with managed node groups

**Answer: B**
**Explanation:** ECS with Fargate is serverless — AWS manages the infrastructure. You only define the task (container) specifications and pay for the vCPU and memory used. This is ideal for event-driven, unpredictable workloads. ECS with EC2 (A) requires managing the EC2 fleet. Self-managed Docker (C) has the most operational overhead. EKS with managed nodes (D) still requires managing the node groups.

---

### Question 8
A company is considering migrating a monolithic application to a microservices architecture on AWS. The development team is familiar with Kubernetes. They want AWS to manage the Kubernetes control plane. What service should the architect recommend?

A) Amazon ECS with EC2 launch type
B) Amazon EKS
C) AWS Fargate standalone
D) AWS Elastic Beanstalk

**Answer: B**
**Explanation:** Amazon EKS (Elastic Kubernetes Service) manages the Kubernetes control plane, allowing teams familiar with Kubernetes to use the same tooling and APIs. ECS (A) is AWS's proprietary container orchestration. Fargate (C) is a compute engine, not an orchestration platform. Elastic Beanstalk (D) is a PaaS that abstracts infrastructure management.

---

### Question 9
A company runs an application on EC2 instances behind an Auto Scaling group. During a scale-in event, the company wants to ensure that instances processing active requests are not terminated until they complete. What should the architect configure?

A) Lifecycle hooks on the Auto Scaling group to pause termination
B) Instance scale-in protection on instances processing requests
C) Increase the cooldown period to avoid premature scale-in
D) Connection draining (deregistration delay) on the target group

**Answer: D**
**Explanation:** Connection draining (deregistration delay) on the target group ensures the load balancer stops sending new requests to the instance being terminated and waits for in-flight requests to complete (up to the configured timeout). Lifecycle hooks (A) pause the instance in a Terminating:Wait state but don't handle ALB request draining. Scale-in protection (B) prevents termination entirely. Cooldown (C) prevents rapid successive scaling but doesn't protect active requests.

---

### Question 10
A company wants to deploy a simple web application using a PaaS solution that handles capacity provisioning, load balancing, auto-scaling, and application health monitoring automatically. The team does not want to manage infrastructure. What should the architect recommend?

A) Amazon EC2 with a user data script
B) AWS Elastic Beanstalk
C) Amazon ECS with Fargate
D) AWS CloudFormation

**Answer: B**
**Explanation:** Elastic Beanstalk is a PaaS that automatically handles deployment, capacity provisioning, load balancing, auto-scaling, and health monitoring. Developers upload code and Beanstalk manages the rest. EC2 (A) requires manual infrastructure management. ECS Fargate (C) requires container knowledge and configuration. CloudFormation (D) is an IaC tool, not a PaaS.

---

### Question 11
A company runs Lambda functions that process messages from an SQS queue. Occasionally, the Lambda function runs for more than 15 minutes on complex messages. What should the architect recommend?

A) Increase the Lambda timeout to 30 minutes
B) Use Step Functions to orchestrate the long-running processing as multiple Lambda invocations
C) Switch to ECS Fargate tasks for processing
D) Both B and C are valid solutions

**Answer: D**
**Explanation:** Lambda has a hard maximum timeout of 15 minutes, so it cannot be increased beyond that (A is impossible). Both Step Functions with chunked processing (B) and Fargate tasks (C) can handle longer-running processes. Step Functions can break the work into smaller pieces across multiple Lambda invocations. Fargate tasks have no time limit. The choice depends on the specific requirements.

---

### Question 12
A company wants to run an application that requires a software license tied to the physical CPU sockets and cores. They need visibility and control over the physical server placement. Which purchasing option should they use?

A) On-Demand Instances
B) Spot Instances
C) Dedicated Hosts
D) Dedicated Instances

**Answer: C**
**Explanation:** Dedicated Hosts give you a physical server fully dedicated to your use with visibility into the number of sockets and physical cores. This is required for Bring Your Own License (BYOL) models that are tied to physical attributes. Dedicated Instances (D) run on dedicated hardware but don't provide socket/core visibility. On-Demand (A) and Spot (B) run on shared multi-tenant hardware.

---

### Question 13
A company has a fleet of EC2 instances running a stateless web application. They want to distribute instances across the underlying hardware to maximize availability. Individual instance failure should not affect more than one instance. What placement strategy should they use?

A) Cluster placement group
B) Spread placement group
C) Partition placement group
D) Default placement (no placement group)

**Answer: B**
**Explanation:** Spread placement groups distribute instances across distinct underlying hardware (separate racks with independent power and networking). Each instance is isolated, so a hardware failure affects only one instance. Cluster (A) packs instances close together for performance. Partition (C) groups instances into partitions, where each partition is on separate hardware — suited for distributed systems like Hadoop/Cassandra. Default placement (D) provides no hardware distribution guarantee.

---

### Question 14
A company has a Reserved Instance for `m5.xlarge` in `us-east-1a`. They want to change it to `m5.2xlarge` in `us-east-1b`. What should they do?

A) Modify the existing reservation to change instance type and AZ
B) Exchange the Convertible Reserved Instance for a new one with the desired attributes
C) Cancel the reservation and purchase a new one
D) Standard Reserved Instances allow changing both instance type and AZ through modification

**Answer: B**
**Explanation:** Convertible Reserved Instances can be exchanged for different instance families, types, OS, tenancy, or payment options. Standard RIs can only be modified within the same instance family (e.g., m5.xlarge to m5.large) and can change AZ within the same region, but cannot change to m5.2xlarge. If they have a Standard RI, they would need to sell it on the Marketplace and buy a new one. Option B is the recommended approach if they have Convertible RIs.

---

### Question 15
A Lambda function is configured to connect to an RDS database in a private subnet. The function occasionally experiences connection timeouts during cold starts. What should the architect recommend to address this?

A) Increase the Lambda function's memory allocation
B) Use RDS Proxy to manage database connections
C) Move the Lambda function out of the VPC
D) Increase the RDS instance size

**Answer: B**
**Explanation:** RDS Proxy manages a pool of database connections, reducing the overhead of establishing new connections during Lambda cold starts. It also improves connection management when Lambda scales. Increasing memory (A) speeds up execution but doesn't address connection establishment. Moving Lambda out of VPC (C) would lose private subnet access. RDS instance size (D) doesn't address connection establishment latency.

---

### Question 16
A company needs to run a GPU-intensive machine learning training workload that takes 48 hours to complete. The workload cannot be interrupted. What is the MOST cost-effective approach?

A) On-Demand P-family instances
B) Spot Instances with checkpointing
C) Reserved Instances (1-year, All Upfront) for P-family
D) On-Demand Instances with Savings Plans

**Answer: D**
**Explanation:** Since the workload takes 48 hours and cannot be interrupted, Spot Instances (B) are risky despite being cheapest. For a one-time 48-hour job, Reserved Instances (C) for 1 year would be wasteful. Compute Savings Plans (D) offer up to 66% discount over On-Demand for a commitment to consistent compute usage, which is more cost-effective than On-Demand (A) for even short-term usage if the company will continue running compute workloads. If this is truly a one-time job, On-Demand (A) would be the answer — this is a nuanced exam question.

---

### Question 17
An Auto Scaling group has a minimum of 2, desired of 4, and maximum of 8 instances. A target tracking policy is set for 50% average CPU utilization. The current average CPU across all instances is 75%. How will Auto Scaling respond?

A) It will launch new instances to bring the average CPU closer to 50%
B) It will terminate instances to reduce the total fleet
C) No action because the desired capacity is within min/max bounds
D) It will increase the instance size (vertical scaling)

**Answer: A**
**Explanation:** Target tracking scaling adjusts the number of instances to keep the metric close to the target. Since CPU (75%) exceeds the target (50%), Auto Scaling will launch additional instances (up to the maximum of 8) to distribute load and bring average CPU down. It will NOT terminate (B) or do nothing (C). Auto Scaling only does horizontal scaling, not vertical (D).

---

### Question 18
A company runs a web application with unpredictable traffic. They want to minimize costs while maintaining consistent performance during traffic spikes. The application is stateless. What combination of EC2 purchasing options should the architect recommend?

A) All On-Demand Instances
B) A base of Reserved Instances for minimum traffic and On-Demand for spikes
C) A base of Reserved Instances for minimum traffic and Spot Instances with On-Demand fallback for spikes
D) All Spot Instances

**Answer: C**
**Explanation:** The optimal strategy uses Reserved Instances (or Savings Plans) for the baseline steady-state traffic, Spot Instances for cost-effective scaling during spikes (since the app is stateless), and On-Demand as a fallback if Spot capacity is unavailable. This provides the best cost optimization. All On-Demand (A) is expensive. Option B is good but not the most cost-effective. All Spot (D) risks availability issues.

---

### Question 19
A company's Auto Scaling group launches instances using a launch template. They want to update the AMI used by the Auto Scaling group without causing downtime. What is the correct approach?

A) Update the AMI ID in the existing launch template (create a new version) and configure the ASG to use the latest version, then perform an instance refresh
B) Terminate all existing instances and let Auto Scaling launch new ones
C) Modify the running instances directly to use the new AMI
D) Create a new Auto Scaling group with the new AMI and delete the old one

**Answer: A**
**Explanation:** Creating a new version of the launch template with the updated AMI and performing an instance refresh gradually replaces instances with minimal disruption. Terminating all instances (B) causes downtime. Running instances cannot be modified to use a new AMI (C). Creating a new ASG (D) is more complex and requires traffic migration.

---

### Question 20
A company runs a three-tier application. The web tier handles HTTP requests, the app tier processes business logic, and the data tier is an RDS database. During peak hours, the app tier becomes a bottleneck. What should the architect recommend?

A) Move the app tier to larger instances (vertical scaling)
B) Place the app tier behind an internal ALB in an Auto Scaling group
C) Add an ElastiCache layer between the app tier and database
D) Migrate the app tier to Lambda

**Answer: B**
**Explanation:** Placing the app tier in an Auto Scaling group behind an internal ALB allows it to scale horizontally based on demand. This addresses the bottleneck during peak hours. Vertical scaling (A) has limits and requires downtime. ElastiCache (C) helps if the bottleneck is database queries, but the question states the app tier is the bottleneck. Lambda (D) requires significant refactoring.

---

### Question 21
A Lambda function processes images uploaded to S3. The function needs 3 GB of memory and takes approximately 10 seconds to process each image. The function is invoked about 1 million times per month. The architect wants to optimize cost. What should they consider?

A) Use Provisioned Concurrency to reduce cold start costs
B) Use Graviton2 (arm64) architecture for the Lambda function to reduce costs by up to 20%
C) Move the processing to EC2 Spot Instances
D) Reduce memory to 128 MB to minimize cost

**Answer: B**
**Explanation:** Lambda functions running on Graviton2 (arm64) processors are approximately 20% cheaper and offer better performance. For compute-intensive workloads like image processing with high invocation counts, this provides meaningful savings. Provisioned Concurrency (A) adds cost, not reduces it. Spot Instances (C) add operational complexity. Reducing memory (D) would slow down processing and may increase duration cost.

---

### Question 22
A company needs to run Windows-based .NET applications in containers on AWS. The team wants to minimize operational overhead. What should the architect recommend?

A) ECS on EC2 with Windows AMIs
B) ECS on Fargate with Windows containers
C) EKS on EC2 with Windows node groups
D) EC2 Windows instances with Docker installed manually

**Answer: B**
**Explanation:** ECS on Fargate supports Windows containers, providing a serverless experience that eliminates the need to manage EC2 instances. This minimizes operational overhead. ECS on EC2 (A) and EKS on EC2 (C) require managing the underlying instances. Manual Docker on EC2 (D) has the most overhead.

---

### Question 23
A company has an application where users upload files that trigger processing. The processing takes 1-2 seconds per file. During business hours, there are 100 concurrent uploads. What is the MOST cost-effective compute solution?

A) EC2 Auto Scaling group with On-Demand instances
B) AWS Lambda triggered by S3 events
C) ECS Fargate tasks
D) A single large EC2 instance

**Answer: B**
**Explanation:** Lambda is ideal for short-duration (1-2 seconds), event-driven processing triggered by S3 uploads. With 100 concurrent uploads, Lambda scales automatically. Lambda is more cost-effective than running EC2 instances or Fargate for short-duration, event-driven tasks. A single EC2 instance (D) cannot handle 100 concurrent operations efficiently.

---

### Question 24
An application runs on an EC2 instance and needs to make API calls to S3 and DynamoDB. The instance has an IAM role attached. During peak load, API calls to DynamoDB are being throttled. What should the architect check FIRST?

A) The IAM role's policy is too restrictive
B) The DynamoDB table's provisioned capacity (RCU/WCU) is insufficient
C) The EC2 instance's network bandwidth is saturated
D) The security group is blocking DynamoDB API calls

**Answer: B**
**Explanation:** DynamoDB throttling occurs when the table's provisioned Read/Write Capacity Units are exceeded. This is the most common cause. IAM role issues (A) would cause Access Denied, not throttling. Network bandwidth (C) is unlikely to throttle DynamoDB API calls specifically. Security groups (D) don't affect AWS API calls (which go through HTTPS endpoints).

---

### Question 25
A company is migrating a legacy application that requires a fixed private IP address for communication with on-premises systems. The application runs on EC2 behind a load balancer. Which load balancer allows assigning a static IP per AZ?

A) Application Load Balancer
B) Network Load Balancer
C) Classic Load Balancer
D) Gateway Load Balancer

**Answer: B**
**Explanation:** Network Load Balancer supports assigning one static IP address (or Elastic IP) per Availability Zone. This is useful for whitelisting in firewalls. ALB (A) uses dynamic IPs. Classic LB (C) uses dynamic IPs. Gateway LB (D) is for third-party virtual appliances and does not provide static IPs to clients.

---

### Question 26
A company wants to run a microservice that responds to HTTP requests. The service is written in Python and only receives about 10 requests per day. Each request takes about 200 milliseconds. What is the MOST cost-effective compute option?

A) EC2 t3.micro On-Demand Instance
B) ECS Fargate task running continuously
C) AWS Lambda with API Gateway
D) EC2 t3.micro Reserved Instance

**Answer: C**
**Explanation:** For 10 requests/day at 200ms each, the total compute time is about 2 seconds per day. Lambda charges only for actual execution time with no idle cost. An EC2 instance (A, D) running 24/7 for 2 seconds of work is extremely wasteful. Fargate (B) running continuously is similarly wasteful. Lambda with API Gateway is by far the most cost-effective option.

---

### Question 27
A company's Auto Scaling group uses a launch template with a `t3.large` instance type. They want the ASG to be able to use multiple instance types to increase availability and optimize costs. How should this be configured?

A) Create multiple launch templates and attach them all to the ASG
B) Use a mixed instances policy in the Auto Scaling group with multiple instance types
C) Create multiple ASGs, each with a different instance type
D) Use Spot Fleet instead of Auto Scaling groups

**Answer: B**
**Explanation:** Mixed instances policy allows an ASG to launch instances using multiple instance types (e.g., t3.large, m5.large, m5a.large) with configurable On-Demand/Spot ratios. This increases availability by diversifying across instance types. Multiple launch templates (A) aren't supported per ASG. Multiple ASGs (C) are hard to manage. Spot Fleet (D) is an alternative but ASG with mixed instances is the recommended approach.

---

### Question 28
A company wants to deploy a Lambda function that needs access to a resource in a private subnet (an RDS database). What must be configured for the Lambda function to access the database?

A) Assign a public IP to the Lambda function
B) Configure the Lambda function with VPC settings specifying private subnets and a security group
C) Create a VPC endpoint for Lambda
D) Place the RDS database in a public subnet

**Answer: B**
**Explanation:** Lambda functions can be configured to run inside a VPC by specifying subnets and security groups. The function will use an ENI in the specified subnet to access VPC resources like RDS. Lambda cannot have a public IP (A). VPC endpoints for Lambda (C) aren't used for this purpose. Moving RDS to a public subnet (D) is a security risk.

---

### Question 29
A company runs stateful applications on EC2 instances. The application stores session data locally. They need to implement Auto Scaling but are concerned about losing session data during scale-in events. What should the architect recommend?

A) Use sticky sessions on the load balancer
B) Externalize session state to ElastiCache or DynamoDB
C) Increase the minimum capacity of the Auto Scaling group to prevent scale-in
D) Use instance store volumes for session storage

**Answer: B**
**Explanation:** Externalizing session state to ElastiCache (Redis/Memcached) or DynamoDB makes the application tier truly stateless, allowing any instance to serve any request. This eliminates data loss during scale-in. Sticky sessions (A) don't prevent data loss when an instance is terminated. Preventing scale-in (C) defeats the purpose of Auto Scaling. Instance store volumes (D) are ephemeral.

---

### Question 30
A company has a workload that runs every Monday at midnight for exactly 3 hours. The workload requires 4 vCPUs and 16 GB RAM. They want to minimize costs over a 1-year period. What should the architect recommend?

A) On-Demand `m5.xlarge` running only during the 3-hour window (using Auto Scaling scheduled actions)
B) Reserved Instance `m5.xlarge` with 1-year All Upfront payment
C) Spot Instance `m5.xlarge` with a Spot Fleet
D) Compute Savings Plan with $0.10/hour commitment

**Answer: A**
**Explanation:** The workload runs only 3 hours per week (156 hours/year out of 8,760). A Reserved Instance (B) would be idle 98% of the time, wasting money. Spot (C) is cheapest per hour but risks interruption for a scheduled job. A Savings Plan (D) commits to a consistent per-hour spend that would also be wasted. On-Demand with scheduled actions (A) gives predictable availability and only charges for the 3 hours used.

---

*End of Compute Question Bank*
