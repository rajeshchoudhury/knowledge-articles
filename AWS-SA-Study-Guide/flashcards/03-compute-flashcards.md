# Compute Flashcards

## AWS Solutions Architect Associate (SAA-C03) — Deck 3 of 9

---

### Card 1
**Q:** What are the main EC2 instance type families and their use cases?
**A:** **General Purpose (M, T)** – balanced compute/memory/networking; web servers, code repos. **Compute Optimized (C)** – high-performance processors; batch processing, ML, gaming, HPC. **Memory Optimized (R, X, z)** – large datasets in memory; in-memory databases, real-time big data analytics. **Storage Optimized (I, D, H)** – high sequential read/write to local storage; data warehousing, distributed file systems. **Accelerated Computing (P, G, Inf, Trn)** – GPUs/custom hardware; ML training/inference, graphics rendering.

---

### Card 2
**Q:** What are T-series burstable instances and CPU credits?
**A:** T-series instances (T2, T3, T3a) provide a **baseline CPU performance** with the ability to burst above it using **CPU credits**. Credits accumulate when the instance is below baseline and are consumed during bursts. When credits are exhausted, performance drops to baseline. **T2 Unlimited / T3 Unlimited** – allows sustained bursting beyond credits at an additional charge per vCPU-hour. T3 has Unlimited mode on by default. Good for variable workloads (web servers, dev environments).

---

### Card 3
**Q:** What are the EC2 purchasing options?
**A:** **On-Demand** – pay per second (Linux/Windows, min 60s), no commitment, highest cost. **Reserved Instances (RI)** – 1 or 3 year commitment, up to 72% discount; Standard RI (can change AZ, scope) or Convertible RI (can change instance family/OS/tenancy). **Savings Plans** – commit to $/hour for 1 or 3 years; Compute SP (any family/region/OS) or EC2 Instance SP (specific family/region). **Spot** – up to 90% discount, can be interrupted with 2-min warning. **Dedicated Host** – physical server, for licensing compliance. **Dedicated Instance** – hardware not shared with other accounts. **Capacity Reservations** – reserve capacity in an AZ, no discount.

---

### Card 4
**Q:** What are Spot Instances and Spot Fleets?
**A:** **Spot Instances** use spare EC2 capacity at up to 90% discount. You set a max price; if the spot price exceeds it, the instance is interrupted (2-minute warning). Strategies for interruption: **Terminate**, **Stop**, or **Hibernate**. **Spot Fleet** – collection of Spot + optional On-Demand instances. Define launch pools (instance types, AZs). Allocation strategies: **lowestPrice**, **diversified**, **capacityOptimized** (recommended to minimize interruptions), **priceCapacityOptimized** (best balance). Good for batch, data analysis, CI/CD, stateless workloads.

---

### Card 5
**Q:** What is the difference between Standard and Convertible Reserved Instances?
**A:** **Standard RI** – up to 72% discount; you can change the AZ, instance size (within the same family), and scope (AZ ↔ Region). Cannot change instance family, OS, or tenancy. Can sell on the RI Marketplace. **Convertible RI** – up to 66% discount; you can change instance family, OS, tenancy, and scope. Cannot sell on the RI Marketplace. Both require 1 or 3 year terms. Payment: All Upfront > Partial Upfront > No Upfront (discount decreases).

---

### Card 6
**Q:** What is an EC2 Savings Plan vs. a Compute Savings Plan?
**A:** **EC2 Instance Savings Plan** – commit to a specific instance family and region (e.g., M5 in us-east-1); up to 72% discount; flexible on size, OS, and tenancy within that family/region. **Compute Savings Plan** – most flexible; applies across any instance family, region, OS, tenancy, and even applies to Fargate and Lambda; up to 66% discount. Both are 1 or 3 year commitments with $/hour spend commitment.

---

### Card 7
**Q:** What is the difference between Dedicated Hosts and Dedicated Instances?
**A:** **Dedicated Host** – an entire physical server allocated to you; you have visibility into sockets/cores; supports **BYOL** (Bring Your Own License); you control instance placement; per-host billing. **Dedicated Instance** – hardware not shared with other accounts, but you may share the host with your own instances; no hardware visibility or placement control; per-instance billing. Use Dedicated Hosts for server-bound software licenses (Windows Server, SQL Server, SUSE).

---

### Card 8
**Q:** What are EC2 placement groups and their trade-offs?
**A:** **Cluster** – all instances in a single AZ on same rack; pros: 10 Gbps between instances, lowest latency; cons: single point of failure, limited to one AZ. **Spread** – each instance on different hardware; pros: high availability; cons: max 7 instances per AZ per group. **Partition** – instances spread across partitions (different racks), up to 7 partitions per AZ; pros: scales to 100s of instances, partition-aware apps (HDFS, Kafka); cons: must manage partition awareness. Choose based on performance vs. availability needs.

---

### Card 9
**Q:** What is an Amazon Machine Image (AMI)?
**A:** An AMI is a template for launching EC2 instances. It contains: OS, application software, launch permissions, and block device mapping (EBS volumes). AMIs are **regional** but can be copied cross-region. Types: **Public** (AWS Marketplace, community), **Private** (your account), **Shared** (shared with specific accounts). Custom AMIs include your pre-installed software, reducing boot time. AMIs can be backed by EBS (most common) or instance store. The AMI creation process creates EBS snapshots behind the scenes.

---

### Card 10
**Q:** What is EC2 User Data?
**A:** User Data is a script that runs **once** at instance **first launch** (boot). It runs as the **root** user. Common uses: install software, download files, configure settings. Passed as base64-encoded text, limit 16 KB. Available at `http://169.254.169.254/latest/user-data`. For scripts that need to run every boot, use cloud-init configurations with `[scripts-user, always]`. User data is not encrypted — don't include secrets.

---

### Card 11
**Q:** What is EC2 Instance Metadata Service (IMDS)?
**A:** IMDS provides instance information accessible at `http://169.254.169.254/latest/meta-data/`. Data includes: instance ID, AMI ID, instance type, public/private IP, IAM role credentials, hostname, placement, security groups. **IMDSv1** – simple GET request (vulnerable to SSRF). **IMDSv2** – requires a session token (PUT request first, then GET with token header); recommended for security. You can enforce IMDSv2-only via launch configuration or `HttpTokens: required`.

---

### Card 12
**Q:** What is an Auto Scaling Group (ASG) and what are its key components?
**A:** An ASG automatically adjusts the number of EC2 instances based on demand. Key components: **Launch Template/Configuration** (AMI, instance type, key pair, SGs, user data), **Minimum/Maximum/Desired capacity**, **Scaling Policies** (dynamic rules for scaling), **Health Checks** (EC2 or ELB health), **AZ distribution** (instances spread across specified AZs). ASG maintains desired capacity by replacing unhealthy instances. Integrates with ELB for automatic registration/deregistration.

---

### Card 13
**Q:** What are the types of ASG scaling policies?
**A:** **Target Tracking** – maintain a metric at a target value (e.g., average CPU at 50%); simplest, ASG creates/manages CloudWatch alarms. **Step Scaling** – scale by different amounts based on alarm thresholds (e.g., add 2 if CPU > 70%, add 4 if CPU > 90%). **Simple Scaling** – single scaling action per alarm, waits for cooldown period; legacy, prefer Step or Target Tracking. **Scheduled Scaling** – scale based on known time patterns (e.g., scale up at 9 AM on weekdays). **Predictive Scaling** – ML-based, forecasts load and pre-scales.

---

### Card 14
**Q:** What is the ASG cooldown period?
**A:** The cooldown period (default **300 seconds**) is the time after a scaling activity during which the ASG will not launch or terminate additional instances. It allows new instances to start handling traffic and metrics to stabilize. Without a cooldown, the ASG might over-scale. Applicable to Simple Scaling only. Step Scaling and Target Tracking use **warm-up time** instead (time for a new instance to contribute to metrics). Reduce cooldown if using fast-launching AMIs.

---

### Card 15
**Q:** What is the difference between a Launch Template and a Launch Configuration?
**A:** **Launch Configuration** (legacy) – immutable; you must create a new one for changes; supports a single instance type; no versioning. **Launch Template** (recommended) – supports versioning, multiple instance types (mixed instances), Spot options, placement groups, capacity reservations, T2/T3 Unlimited; can be used for both ASG and standalone launches. AWS recommends Launch Templates for all new ASGs. Launch Configurations are being phased out.

---

### Card 16
**Q:** How does ASG handle AZ rebalancing?
**A:** ASG distributes instances evenly across configured AZs. If an AZ becomes unhealthy or instances are unevenly distributed (e.g., after manual termination), ASG performs **AZ rebalancing** — it launches new instances in underrepresented AZs, then terminates instances in overrepresented AZs. During rebalancing, the ASG can temporarily exceed the max capacity by 10%. The default termination policy terminates the instance with the oldest launch configuration in the AZ with the most instances.

---

### Card 17
**Q:** What are the ASG health check types?
**A:** **EC2 health check** (default) – instance is unhealthy if EC2 status checks fail (stopped, terminated, impaired). **ELB health check** – uses the load balancer's health check; instance is unhealthy if ELB reports it as unhealthy. When ELB health check is enabled, both EC2 and ELB checks must pass. ASG has a **Health Check Grace Period** (default 300s) — new instances are not checked until this period expires, allowing time for startup. Custom health checks can be set via API.

---

### Card 18
**Q:** What are the four types of Elastic Load Balancers?
**A:** **Application Load Balancer (ALB)** – Layer 7 (HTTP/HTTPS/gRPC); path/host-based routing, WebSocket, Lambda targets, WAF integration. **Network Load Balancer (NLB)** – Layer 4 (TCP/UDP/TLS); extreme performance (~millions RPS, <100ms latency), static IP per AZ, preserves source IP. **Gateway Load Balancer (GLB)** – Layer 3 (IP packets); for inline third-party virtual appliances (firewalls, IDS); uses GENEVE protocol. **Classic Load Balancer (CLB)** – legacy, Layer 4 & basic Layer 7; being deprecated.

---

### Card 19
**Q:** When should you choose NLB over ALB?
**A:** Use **NLB** when: you need ultra-low latency (<100ms), you need to handle millions of requests per second, you need **static IP addresses** (or Elastic IPs) per AZ, you need to preserve the client's source IP without X-Forwarded-For, you're running TCP/UDP (non-HTTP) protocols, you need PrivateLink (VPC endpoint service requires NLB). Use ALB for HTTP-layer features (path routing, host routing, redirects, authentication, WAF).

---

### Card 20
**Q:** What is a Gateway Load Balancer (GLB) and when do you use it?
**A:** GLB deploys, scales, and manages third-party virtual appliances (firewalls, IDS/IPS, deep packet inspection). It operates at Layer 3 (network layer) using the **GENEVE protocol** on port 6081. It creates a transparent network gateway (single entry/exit point for traffic) and distributes traffic across appliances. Use case: route all VPC traffic through a security appliance for inspection before it reaches the application. Deployed with **Gateway Load Balancer Endpoints** in each VPC.

---

### Card 21
**Q:** What is AWS Lambda?
**A:** Lambda is a serverless compute service that runs code in response to events. Key features: pay per request + compute time (ms granularity), auto-scales (up to 1000 concurrent executions by default), supports many runtimes (Node.js, Python, Java, Go, .NET, Ruby, custom via container images). Timeout: max **15 minutes**. Memory: 128 MB to 10,240 MB (CPU scales proportionally). Disk: 512 MB to 10 GB (`/tmp`). Deployment package: 50 MB zipped, 250 MB unzipped (or 10 GB container image).

---

### Card 22
**Q:** What are Lambda concurrency limits and reserved concurrency?
**A:** **Account-level** concurrent execution limit: **1,000** (soft limit, can be increased). **Reserved concurrency** – guarantees a specific number of concurrent executions for a function (deducted from the account pool); prevents one function from consuming all capacity. **Provisioned concurrency** – pre-initializes a specific number of execution environments to eliminate cold starts; costs money even when idle. Throttled invocations get HTTP 429. Asynchronous invocations are retried; synchronous invocations must be retried by the caller.

---

### Card 23
**Q:** How does Lambda work with a VPC?
**A:** By default, Lambda runs in an AWS-managed VPC with internet access but no access to your VPC resources. To access VPC resources (RDS, ElastiCache), configure Lambda with your VPC, subnets, and security groups. Lambda creates **ENIs** in your subnets using **Hyperplane** (shared ENIs). Once in a VPC, Lambda loses internet access — you need a **NAT Gateway** in a public subnet for internet access, or VPC endpoints for AWS services. Use at least 2 subnets in different AZs for HA.

---

### Card 24
**Q:** What are Lambda Layers?
**A:** Lambda Layers are ZIP archives containing libraries, custom runtimes, or other dependencies. Layers are extracted to `/opt` in the execution environment. Up to **5 layers** per function. Benefits: reduces deployment package size, promotes code reuse across functions, simplifies dependency management. Layers are versioned and can be shared across accounts. Total unzipped size (function + layers) must not exceed 250 MB.

---

### Card 25
**Q:** What are the Lambda invocation types?
**A:** **Synchronous** – caller waits for the response (API Gateway, ALB, SDK invoke). Errors must be handled by the caller (retries). **Asynchronous** – Lambda queues the event and returns immediately (S3, SNS, EventBridge). Lambda retries twice on failure; failed events go to a **Dead Letter Queue** (SQS/SNS) or a **Destinations** configuration. **Event Source Mapping** – Lambda polls a source (SQS, Kinesis, DynamoDB Streams); Lambda manages the polling and batching.

---

### Card 26
**Q:** What is Lambda@Edge vs. CloudFront Functions?
**A:** **Lambda@Edge** – runs at CloudFront regional edge caches; supports Node.js/Python; up to 10,000 requests/sec per region; max 5s (viewer) or 30s (origin) timeout; access to external network/services; can modify request/response at all 4 trigger points. **CloudFront Functions** – runs at 200+ edge locations; JavaScript only; millions of requests/sec; sub-ms execution; <10 KB code; only viewer request/response triggers; lightweight tasks (header manipulation, URL rewrite, cache key normalization). CloudFront Functions are cheaper and faster; Lambda@Edge is more powerful.

---

### Card 27
**Q:** What is Amazon ECS (Elastic Container Service)?
**A:** ECS is a container orchestration service for running Docker containers on AWS. **Launch types**: **EC2 launch type** – you manage the EC2 instances (ECS agent runs on them); **Fargate launch type** – serverless, AWS manages infrastructure. Key concepts: **Task Definition** (blueprint: image, CPU, memory, ports, IAM role), **Task** (running instance of a task definition), **Service** (maintains desired number of tasks, integrates with ELB), **Cluster** (logical grouping). ECS integrates with ALB for dynamic port mapping.

---

### Card 28
**Q:** What is the difference between ECS Task Role and ECS Task Execution Role?
**A:** **Task Role** – IAM role assumed by the containers **within the task**; defines what AWS services the application code can access (e.g., S3, DynamoDB). Defined in the task definition. **Task Execution Role** – IAM role used by the **ECS agent** to pull container images from ECR, send logs to CloudWatch, and retrieve secrets from Secrets Manager/SSM Parameter Store. Both are defined in the task definition but serve different purposes.

---

### Card 29
**Q:** What is the difference between ECS and EKS?
**A:** **ECS** – AWS-proprietary container orchestration; simpler, deeply integrated with AWS services (ALB, IAM, CloudWatch); no control plane cost (Fargate or EC2 pricing only); best for teams invested in the AWS ecosystem. **EKS** – managed Kubernetes; runs standard K8s; portable across clouds; large ecosystem of K8s tools; $0.10/hr per cluster for control plane; supports EC2 and Fargate node types. Choose EKS for Kubernetes expertise, multi-cloud strategy, or K8s tooling needs.

---

### Card 30
**Q:** What is AWS Fargate?
**A:** Fargate is a serverless compute engine for containers (ECS and EKS). You don't manage EC2 instances — just define CPU and memory requirements in your task/pod definition. Benefits: no cluster management, scales per-task, pay for vCPU and memory per second (min 1 minute), each task runs in its own isolation boundary. Limitations: no GPU support, no persistent local storage (ephemeral storage up to 200 GB), slightly higher cost than well-utilized EC2, no SSH access to underlying host.

---

### Card 31
**Q:** What are the Elastic Beanstalk deployment policies?
**A:** **All at once** – deploy to all instances simultaneously; fastest but causes downtime. **Rolling** – deploy in batches; some instances serve old version during deployment; no additional cost. **Rolling with additional batch** – launches a new batch of instances first, maintaining full capacity; small additional cost. **Immutable** – launches entirely new instances in a new ASG, swaps when healthy; safest, easy rollback, higher cost during deployment. **Traffic Splitting** – canary-style; sends a percentage of traffic to new version; ideal for testing in production.

---

### Card 32
**Q:** What are the Elastic Beanstalk environment tiers?
**A:** **Web Server tier** – handles HTTP requests; includes an ELB, ASG, and EC2 instances running a web server. **Worker tier** – processes background tasks from an SQS queue; includes an ASG, EC2 instances, and an SQS queue with a daemon that pulls messages. Worker environments don't have an ELB. A common pattern is a web server tier receiving requests and offloading work to a worker tier via SQS. Both can be linked in the same application.

---

### Card 33
**Q:** What is EC2 Hibernate?
**A:** EC2 Hibernate saves the in-memory (RAM) state to the root EBS volume, which must be encrypted. On resume, the RAM is restored, and processes continue where they left off (faster than a full boot). Supported instance families and OS types vary. Root volume must be EBS (not instance store) and large enough for the RAM dump. Max hibernation duration: **60 days**. Not supported for bare metal instances or instances with more than 150 GB RAM. Use for long-running processes that need fast resume.

---

### Card 34
**Q:** What is an Elastic IP vs. a public IP on EC2?
**A:** A **public IP** is assigned automatically from Amazon's pool when an instance launches in a public subnet (if configured); it changes when the instance is stopped/started. An **Elastic IP** is a static public IPv4 address you allocate and control; it persists until you release it; can be remapped between instances for failover. You are charged for an EIP not associated with a running instance. Limit: 5 EIPs per region.

---

### Card 35
**Q:** What is EC2 Auto Recovery?
**A:** EC2 Auto Recovery automatically recovers an instance when an underlying system status check fails (hardware failure). The recovered instance retains its instance ID, private IP, Elastic IP, metadata, and placement. The instance is migrated to new hardware and rebooted. Configured via a CloudWatch alarm on `StatusCheckFailed_System`. Only works for instances with EBS-backed root volumes (not instance store). Also available as a default setting with simplified EC2 recovery.

---

### Card 36
**Q:** What are EC2 instance store volumes?
**A:** Instance store volumes provide **temporary block-level storage** on disks physically attached to the host. Very high I/O performance (millions of IOPS for some types). Data is **ephemeral** — lost when the instance is stopped, terminated, or the hardware fails. Good for caches, buffers, scratch data, and temporary content. Not all instance types have instance store. Cannot be detached or attached to another instance. Size is fixed by the instance type.

---

### Card 37
**Q:** What is the EC2 status check?
**A:** Two types: **System Status Check** – monitors AWS infrastructure (hardware, network, power). Failure = AWS problem; resolution: stop/start the instance (migrates to new hardware) or set up auto-recovery. **Instance Status Check** – monitors software/OS configuration. Failure = your problem; resolution: reboot or fix OS issues. Both checks run every minute. CloudWatch metrics: `StatusCheckFailed_System`, `StatusCheckFailed_Instance`, `StatusCheckFailed` (either).

---

### Card 38
**Q:** What is AWS Batch?
**A:** AWS Batch manages batch computing workloads at any scale. You submit **jobs** (shell scripts, Docker containers) to **job queues**, and Batch provisions the optimal quantity and type of compute (EC2 or Fargate). Key concepts: **Job Definition** (like ECS task definition: image, vCPU, memory, commands), **Job Queue** (prioritized queue linked to compute environments), **Compute Environment** (managed or unmanaged; defines instance types, vCPU limits, spot/on-demand). Fully managed — handles scheduling, retries, and dependencies. Use for ETL, genomics, financial modeling.

---

### Card 39
**Q:** What is the difference between AWS Batch and Lambda for batch processing?
**A:** **Lambda** – max 15-min timeout, limited memory (10 GB), limited disk (10 GB /tmp), limited runtimes, serverless, event-driven. **AWS Batch** – no time limit, any compute capacity (hundreds of GBs of RAM), full Docker support, uses EC2/Fargate, optimizes instance selection, handles job dependencies. Choose Lambda for short, event-driven tasks. Choose Batch for long-running, compute-heavy, or data-intensive batch jobs that exceed Lambda's limits.

---

### Card 40
**Q:** What is AWS App Runner?
**A:** App Runner is a fully managed service for deploying containerized web applications and APIs at scale. You provide a source code repository (GitHub) or container image (ECR), and App Runner handles building, deploying, scaling (including to zero with option), load balancing, and TLS. No infrastructure to manage. Automatic scaling based on traffic. Use for simple web apps and APIs where you don't need the complexity of ECS/EKS. Supports custom domains, VPC connectivity (for accessing private resources), and observability features.

---

### Card 41
**Q:** What is Amazon Lightsail?
**A:** Lightsail is a simplified cloud platform for small projects, offering virtual servers, storage, databases, and networking at low, predictable pricing. Bundles include a fixed amount of compute, memory, storage, and data transfer for a flat monthly price. Great for simple web apps, WordPress, development environments, and small business applications. Limited configuration options compared to EC2. Can be connected to other AWS services via VPC peering. Not typically tested heavily on SAA-C03 but appears as a distractor.

---

### Card 42
**Q:** What is an ALB listener rule and what conditions does it support?
**A:** ALB listener rules determine how the load balancer routes requests. Conditions: **host-header** (e.g., `api.example.com`), **path-pattern** (e.g., `/api/*`), **http-request-method** (GET, POST), **source-ip** (client IP CIDR), **http-header** (custom header values), **query-string** (key-value pairs). Actions: **forward** (to target group), **redirect** (301/302), **fixed-response** (return static response), **authenticate-oidc** / **authenticate-cognito**. Rules have priorities; default rule has lowest priority.

---

### Card 43
**Q:** What is connection draining vs. slow start mode on ALB?
**A:** **Connection draining** (deregistration delay) – allows in-flight requests to complete before a deregistering target is removed (default 300s). **Slow start mode** – gradually increases traffic to newly registered targets over a configurable warm-up period (30-900s) instead of sending full traffic immediately. This prevents overwhelming new instances that need to warm up caches or initialize resources. Both are configured at the target group level.

---

### Card 44
**Q:** How does ALB authentication work?
**A:** ALB can authenticate users directly using listener rules. Two options: **Authenticate with Cognito** – integrates with Cognito User Pools for managed sign-up/sign-in. **Authenticate with OIDC** – supports any OpenID Connect-compatible IdP (Okta, Auth0, Google, etc.). The ALB intercepts requests, redirects unauthenticated users to the IdP login page, validates the token, and forwards authenticated requests to targets with user claims in headers. Offloads authentication from your application.

---

### Card 45
**Q:** What is the NLB target group behavior with IP preservation?
**A:** NLB preserves the client's source IP address by default when routing to **instance type** targets. When routing to **IP type** targets or through a **PrivateLink**, proxy protocol v2 must be enabled to pass the source IP. Unlike ALB (which uses X-Forwarded-For header), NLB operates at Layer 4 and the original TCP connection information is preserved. This is important for applications that need the client's real IP for logging or security.

---

### Card 46
**Q:** What are Lambda Destinations vs. Dead Letter Queues (DLQ)?
**A:** **DLQ** – sends failed asynchronous invocation events to SQS or SNS after retries are exhausted; only captures failures. **Lambda Destinations** – sends both **success** and **failure** invocation results to SQS, SNS, Lambda, or EventBridge; includes more metadata (response payload, error details). Destinations are recommended over DLQ because they support success routing and provide richer event information. DLQ is still supported for backward compatibility.

---

### Card 47
**Q:** What is ECS Service Auto Scaling?
**A:** ECS Service Auto Scaling adjusts the number of ECS tasks. Three scaling types: **Target Tracking** – maintain a metric at a target (e.g., average CPU at 50%, ALBRequestCountPerTarget). **Step Scaling** – scale based on CloudWatch alarm thresholds. **Scheduled Scaling** – scale at specific times. For EC2 launch type, you also need to scale the underlying EC2 instances (use **Cluster Auto Scaling** with a Capacity Provider). Fargate automatically handles infrastructure scaling.

---

### Card 48
**Q:** What is an ECS Capacity Provider?
**A:** A Capacity Provider manages the infrastructure that tasks run on. **Fargate Capacity Provider** – uses Fargate (and Fargate Spot) for serverless tasks. **Auto Scaling Group Capacity Provider** – links an ASG to the ECS cluster; enables **Cluster Auto Scaling** which automatically adjusts EC2 capacity based on task placement needs. You define a capacity provider strategy (e.g., 70% Fargate, 30% Fargate Spot) at the cluster or service level. This ensures infrastructure scales with your workload.

---

### Card 49
**Q:** What happens when a Spot Instance is interrupted?
**A:** AWS sends a **2-minute warning** via the instance metadata and a CloudWatch Event/EventBridge notification. The instance can be **terminated**, **stopped**, or **hibernated** based on the interruption behavior you configured. For Spot Fleets, the fleet can attempt to replace the instance. Best practices: use diversified instance types/AZs, checkpoint work regularly, use Spot-friendly architectures (stateless, fault-tolerant). Spot blocks (defined duration) have been deprecated.

---

### Card 50
**Q:** What is the EC2 Serial Console?
**A:** The EC2 Serial Console provides text-based access to an instance's serial port for troubleshooting boot and network issues — even when SSH/RDP is unavailable. It works like a physical serial connection. Use cases: debugging boot failures, misconfigured firewalls, broken SSH configurations, and kernel issues. Must be enabled at the account level. Requires IAM permissions. Supported for Nitro-based instances. Accessible through the console or AWS CLI.

---

*End of Deck 3 — 50 cards*
