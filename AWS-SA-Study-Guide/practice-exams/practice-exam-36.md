# Practice Exam 36 - AWS Solutions Architect Associate (SAA-C03) - Containers & Compute Optimization

## Ultra-Hard Containers & Compute Deep Dive

### Instructions
- **65 questions** | **130 minutes**
- This exam is **SIGNIFICANTLY HARDER** than the real SAA-C03
- Focuses on containers (ECS, EKS, Fargate), compute optimization, and workload-specific architectures
- Mix of multiple choice (single answer) and multiple response (select 2-3)
- Passing score: 720/1000

### Domain Distribution
| Domain | Questions |
|--------|-----------|
| Security | ~20 |
| Resilient Architecture | ~17 |
| High-Performing Architecture | ~16 |
| Cost-Optimized Architecture | ~12 |

---

### Question 1
A machine learning team runs inference workloads on ECS Fargate tasks. Each task requires 30 GB of model data loaded from S3 at startup. The current startup time is 8 minutes because the task must download the model to its ephemeral storage on each launch. The team needs to reduce cold start time to under 2 minutes while keeping Fargate's serverless model. Which solution BEST addresses this?

A) Mount an Amazon EFS file system to the Fargate tasks. Pre-load the model data into EFS from a separate ECS task. New inference tasks mount the EFS volume and access the model data immediately without downloading from S3. Configure EFS with Provisioned Throughput to ensure fast reads during concurrent task launches.  
B) Increase the Fargate task ephemeral storage to 200 GB and use a larger task size to speed up S3 downloads  
C) Use EC2 launch type with instance store volumes pre-loaded with the model data  
D) Store the model in an EBS volume and attach it to the Fargate task  

---

### Question 2
A company is deciding between Amazon ECS and Amazon EKS for a new microservices platform. The platform has 50 services, the team has deep Kubernetes expertise, they need to run the same workloads on-premises and in AWS, they require custom scheduling policies, and they use Helm charts extensively. Which platform should the solutions architect recommend and why?

A) Amazon EKS — the team's Kubernetes expertise, requirement for on-premises portability (EKS Anywhere), custom scheduling (Kubernetes scheduler extensions), and Helm chart ecosystem all align with Kubernetes. ECS would require re-learning and re-tooling.  
B) Amazon ECS — it is simpler and cheaper for 50 services, and ECS Anywhere provides on-premises support  
C) Amazon EKS on Fargate — eliminates node management while providing full Kubernetes compatibility  
D) Amazon ECS with AWS Copilot — simplifies deployment and abstracts away container orchestration complexity  

---

### Question 3
**(Select TWO)** A company runs stateful ECS tasks that process financial transactions. When an Auto Scaling event terminates an EC2 instance, in-flight transactions are lost. The team needs to gracefully drain tasks before instance termination. Which TWO configurations should be implemented?

A) Configure ECS container instance draining by setting the instance to DRAINING state via an Auto Scaling lifecycle hook. Create a Lambda function triggered by the lifecycle hook that calls the ECS API to set the instance to DRAINING. The ECS scheduler stops placing new tasks and waits for existing tasks to complete before allowing termination.  
B) Set the deregistration delay on the ECS service's target group to a value longer than the maximum transaction processing time, ensuring the load balancer stops sending new requests while in-flight transactions complete  
C) Configure ECS task placement constraints to spread tasks across instances so that no single instance handles all transactions  
D) Enable ECS managed termination protection on the tasks — this prevents the Auto Scaling group from terminating instances with running tasks  
E) Use Fargate instead of EC2 launch type to avoid instance termination concerns  

---

### Question 4
A company runs a high-frequency trading application that requires single-digit microsecond inter-node latency. The application runs on 8 EC2 instances that must communicate via TCP with minimal jitter. The instances also require 100 Gbps networking. Which EC2 configuration provides the LOWEST network latency?

A) Deploy c5n.18xlarge instances in a cluster placement group with Enhanced Networking (ENA) enabled. The cluster placement group ensures all instances are on the same underlying hardware rack, providing the lowest latency and highest throughput.  
B) Deploy instances in a spread placement group across 3 AZs for fault tolerance with Enhanced Networking  
C) Use a partition placement group with 8 partitions for maximum isolation  
D) Deploy instances with Elastic Fabric Adapter (EFA) in a cluster placement group for HPC network bypass  

---

### Question 5
A company needs to run a containerized application that requires GPU access. The application performs real-time video transcoding using NVIDIA CUDA. They want to use ECS. Which configuration allows GPU access for ECS tasks?

A) Use the EC2 launch type with GPU-enabled instances (e.g., p3 or g4dn). Install the NVIDIA container runtime on the instances. In the ECS task definition, specify GPU resource requirements using the `resourceRequirements` field with type `GPU` and the number of GPUs needed. ECS will place tasks on instances with available GPUs.  
B) Use Fargate with GPU task definitions — Fargate supports GPU workloads natively  
C) Use EC2 instances with GPUs but access them via the standard CPU resource allocation in the task definition  
D) Mount the GPU device using Docker volumes in the ECS task definition's `mountPoints` configuration  

---

### Question 6
A company runs an EKS cluster with 200 nodes. The cluster uses the Cluster Autoscaler, but the team reports that scaling up takes 5-7 minutes because new EC2 instances take time to launch and join the cluster. Workload pods are pending during this time. The team wants to reduce this to under 60 seconds. Which solution should the architect recommend?

A) Replace Cluster Autoscaler with Karpenter. Karpenter directly provisions EC2 instances optimized for pending pod requirements, bypasses Auto Scaling Groups, and launches instances faster. Additionally, implement Karpenter's consolidation feature to right-size the fleet continuously.  
B) Pre-warm the Auto Scaling Group by setting the minimum size to the expected peak capacity  
C) Use Fargate profiles for all workloads to eliminate node provisioning entirely  
D) Create custom AMIs with all dependencies pre-installed and configure the Cluster Autoscaler with `--scale-down-delay-after-add=0`  

---

### Question 7
A company runs a batch processing pipeline on ECS. Each batch job processes a 50 GB dataset and requires temporary storage for intermediate results. The tasks run on Fargate. The current Fargate ephemeral storage limit is not sufficient, and the team needs 150 GB of temporary storage per task. They also need shared storage accessible by multiple concurrent tasks processing the same dataset. What is the MOST cost-effective solution?

A) Configure Fargate tasks with 150 GB ephemeral storage (Fargate supports up to 200 GB) for intermediate results. Mount an EFS file system in Access Point mode for the shared dataset accessible by multiple concurrent tasks. EFS is only charged for storage used and provides concurrent multi-task access.  
B) Switch to EC2 launch type with instances that have large instance store volumes  
C) Use S3 as the shared storage layer with Fargate's default 20 GB ephemeral storage, reading and writing intermediate results to S3  
D) Mount a single EBS volume shared across all Fargate tasks  

---

### Question 8
**(Select TWO)** A company has a web application running on an ECS service with an Application Load Balancer. They want to implement a blue/green deployment using AWS CodeDeploy. During the deployment, 10% of traffic should be shifted to the new (green) task set for 15 minutes before completing the full shift. If the green task set's CloudWatch alarm triggers, the deployment must automatically roll back. Which TWO configurations are required?

A) Create a CodeDeploy deployment group with deployment type "Blue/Green" and deployment configuration "CodeDeployDefault.ECSCanary10Percent15Minutes". This shifts 10% of traffic initially, waits 15 minutes, then shifts the remaining 90%.  
B) Configure the deployment group with an auto-rollback configuration that triggers on CloudWatch alarm state change to ALARM. Associate the specific CloudWatch alarm (e.g., 5XX error rate) with the deployment group.  
C) Configure two ALB target groups and use ALB weighted routing rules to manually shift traffic percentages  
D) Use ECS rolling update deployment type with minimum healthy percent set to 90%  
E) Create a CodePipeline with a manual approval step between the 10% and 100% traffic shifts  

---

### Question 9
A company has an EC2 Fleet with a target capacity of 100 instances: 30 On-Demand and 70 Spot. The On-Demand instances should use the cheapest available instance type from a list of 5 types. Spot instances should be diversified across all 5 instance types and 3 AZs to minimize interruptions. How should the Fleet be configured?

A) Configure the EC2 Fleet with `OnDemandAllocationStrategy: lowest-price` to select the cheapest On-Demand type, and `SpotAllocationStrategy: capacity-optimized-prioritized` to choose Spot instances from pools with the most available capacity across all 5 types and 3 AZs. Specify all 5 instance types in the launch template overrides with all 3 AZ subnets.  
B) Create 5 separate Auto Scaling Groups (one per instance type) with mixed instances policy  
C) Use `SpotAllocationStrategy: lowest-price` with `SpotInstancePools: 5` to diversify across the cheapest 5 pools  
D) Configure On-Demand only with Reserved Instance pricing and Spot Fleet for the Spot capacity separately  

---

### Question 10
A gaming company runs real-time multiplayer game servers on EC2 Spot Instances. When a Spot interruption occurs, active game sessions are lost. The company needs at least 2 minutes of warning before termination to save game state. How should the architect design the interruption handling?

A) Use the EC2 Instance Metadata Service endpoint (http://169.254.169.254/latest/meta-data/spot/instance-action) polled every 5 seconds by an agent on the instance. When the 2-minute interruption notice appears, the agent triggers a game state save to DynamoDB and gracefully disconnects players. Additionally, configure EventBridge to capture Spot interruption warnings and invoke a Lambda function that initiates replacement instance provisioning.  
B) Rely on the 2-minute Spot Instance termination notice in CloudWatch Events only — no agent needed on the instance  
C) Use Spot Instance hibernation to save the entire instance state to EBS  
D) Deploy a Spot Fleet with maintain mode — terminated instances are automatically replaced  

---

### Question 11
A company runs an EKS cluster with 100 pods, each requiring a unique private IP address. The cluster uses the Amazon VPC CNI plugin. The current nodes are t3.medium (3 ENIs per instance, 5 IPs per ENI = 15 IPs per node). The team reports IP address exhaustion in the subnet, causing pod scheduling failures. What should the solutions architect recommend?

A) Enable the VPC CNI prefix delegation feature. This assigns /28 IPv4 prefixes (16 IPs each) to ENIs instead of individual IPs, significantly increasing the number of IPs available per node. A t3.medium with 3 ENIs and prefix delegation can support up to 48 IPs (3 ENIs × 16 IPs per prefix). Also, increase the subnet CIDR range or add secondary CIDRs to the VPC for more address space.  
B) Add larger instance types (e.g., m5.4xlarge with more ENIs) to increase IP capacity per node  
C) Switch from VPC CNI to Calico CNI for overlay networking that doesn't consume VPC IPs  
D) Create more subnets in different AZs and configure the VPC CNI to use them  

---

### Question 12
A company needs to run an HPC simulation that requires 256 tightly coupled compute nodes. Each node needs to communicate with all other nodes with low latency. The simulation uses MPI (Message Passing Interface). Which EC2 configuration is optimal?

A) Deploy hpc6a.48xlarge instances in a cluster placement group with Elastic Fabric Adapter (EFA) enabled. EFA provides OS-bypass networking for HPC workloads, enabling direct hardware-level communication that significantly reduces latency for MPI traffic. Use a single Availability Zone.  
B) Use c5n.18xlarge instances in a spread placement group across 3 AZs for fault tolerance  
C) Deploy Graviton3 instances in a partition placement group for cost optimization  
D) Use Fargate with 256 concurrent tasks for simplified management  

---

### Question 13
**(Select TWO)** A company has an Auto Scaling Group with a minimum of 10, desired of 15, and maximum of 50 instances. They need to perform a rolling update to a new AMI. During the update, the application must maintain at least 10 healthy instances at all times, and no more than 20 instances should exist simultaneously (to control costs). Which TWO Auto Scaling Group configurations achieve this?

A) Configure an Instance Refresh with `MinHealthyPercentage: 67` (67% of 15 desired = ~10 instances must remain healthy) and `MaxHealthyPercentage: 134` (134% of 15 = ~20 maximum instances)  
B) Configure instance refresh with `MinHealthyPercentage: 90` and rely on the ASG maximum of 50 to limit instance count  
C) Set `MaxHealthyPercentage: 134` to ensure the ASG does not launch more than 20 instances total during the refresh  
D) Manually terminate instances in batches of 5 and wait for replacements  
E) Use a Blue/Green deployment with a completely new Auto Scaling Group  

---

### Question 14
A company is migrating a monolithic .NET Framework application to containers. The application is 15 GB when packaged as a Docker image. They want to deploy it on AWS Lambda for event-driven scaling. What should the solutions architect advise?

A) Lambda supports container images up to 10 GB. The 15 GB image exceeds the limit. The team must either optimize the image to under 10 GB (multi-stage builds, removing unnecessary dependencies) or deploy on ECS/EKS with Fargate. If event-driven scaling is required on ECS, use ECS with KEDA or SQS-based scaling.  
B) Deploy the container image directly to Lambda — Lambda supports container images up to 15 GB  
C) Lambda only supports zip deployments — container images are not supported  
D) Package the application as a 15 GB zip file and deploy it to Lambda with provisioned concurrency  

---

### Question 15
A company runs a web application on Graviton3 (ARM64) instances. The application is written in Java 17 (which supports ARM64 natively). Before migration, the same application ran on m5.xlarge (x86) instances. After migrating to m6g.xlarge (Graviton), the company observed a 20% cost reduction and 15% performance improvement. The CFO asks: can they get the same savings by migrating their Windows-based .NET Framework 4.8 application to Graviton? What should the architect advise?

A) No — .NET Framework 4.8 runs only on Windows, and Graviton instances run Linux only. .NET Framework is not cross-platform. The .NET application would need to be migrated to .NET 6+ (which is cross-platform and supports ARM64/Linux) before it can run on Graviton instances.  
B) Yes — Graviton instances support Windows Server and .NET Framework natively  
C) Yes — use Wine compatibility layer on Graviton Linux to run .NET Framework  
D) No — Graviton instances do not provide cost savings for compute-intensive workloads  

---

### Question 16
A company runs an ECS service with 20 tasks. Each task has a sidecar container for log collection and a main application container. The main container requires 2 vCPU and 4 GB memory. The sidecar requires 0.25 vCPU and 0.5 GB memory. The tasks run on Fargate. What is the correct Fargate task size configuration?

A) Set the task-level CPU to 4096 (4 vCPU) and memory to 8192 (8 GB). Fargate task sizes must match predefined CPU/memory combinations — the nearest valid combination that accommodates 2.25 vCPU and 4.5 GB is 4 vCPU / 8 GB. At the container level, allocate 2048 CPU units and 4096 MB to the main container, and 256 CPU units and 512 MB to the sidecar.  
B) Set the task-level CPU to 2.25 vCPU and memory to 4.5 GB — Fargate supports custom values  
C) Set the task-level CPU to 2048 (2 vCPU) and memory to 4096 (4 GB), which is enough for the main container since sidecar resources are not counted  
D) Set each container independently — Fargate doesn't require task-level resource definitions  

---

### Question 17
A company runs AWS Batch jobs for genomics analysis. Each job processes a different genome and the processing time varies from 1 hour to 72 hours. Shorter jobs complete quickly but longer jobs sometimes fail due to Spot Instance interruptions. The company wants to minimize cost while ensuring all jobs complete. Which Batch configuration should be used?

A) Create two compute environments: one using Spot Instances for the job queue with a retry strategy (attempts: 3) for shorter jobs, and one using On-Demand Instances as a fallback. Configure the job queue with both compute environments — Spot as primary (higher priority) and On-Demand as secondary. When Spot capacity is unavailable or jobs fail due to interruption, Batch routes to On-Demand. Implement checkpointing in long-running jobs to resume from the last checkpoint after interruption.  
B) Use only On-Demand instances for all jobs to avoid interruption  
C) Use Spot Instances exclusively with the highest bid price set to On-Demand price  
D) Run all jobs on Fargate for guaranteed capacity without interruption  

---

### Question 18
**(Select TWO)** An EKS cluster uses the EKS managed node group with the default Amazon Linux 2 AMI. The security team requires: (1) all pods must use IAM roles for AWS API access (no node-level permissions), and (2) pod-level security policies must restrict pods from running as root. Which TWO configurations meet these requirements?

A) Enable IAM Roles for Service Accounts (IRSA) by associating an OIDC provider with the cluster. Create IAM roles with trust policies that reference Kubernetes service accounts. Annotate pod service accounts with the IAM role ARN using `eks.amazonaws.com/role-arn`.  
B) Configure Pod Security Standards (PSS) with the "restricted" profile enforced at the namespace level using labels (`pod-security.kubernetes.io/enforce: restricted`). This prevents pods from running as root, using privileged containers, or escalating privileges.  
C) Attach IAM policies directly to the EC2 instance profile of the managed node group  
D) Use Network Policies to prevent pods from accessing the EC2 metadata service  
E) Install the deprecated PodSecurityPolicy (PSP) admission controller  

---

### Question 19
A company uses an Auto Scaling Group with a lifecycle hook for launching instances. The hook triggers a Lambda function that installs monitoring agents, registers the instance with a configuration management system, and runs compliance checks. The total setup takes 5 minutes. If any step fails, the instance should be terminated and a new one launched. How should the lifecycle hook be configured?

A) Create a launch lifecycle hook with a heartbeat timeout of 600 seconds (10 minutes, providing buffer). The Lambda function performs all setup steps. On success, the function calls `CompleteLifecycleAction` with `CONTINUE` to put the instance into service. On failure, the function calls `CompleteLifecycleAction` with `ABANDON` to terminate the instance. The ASG automatically launches a replacement.  
B) Use EC2 User Data to perform the setup and signal the ASG with cfn-signal  
C) Create a terminate lifecycle hook that checks compliance before allowing termination  
D) Use EventBridge to detect instance launch and trigger the Lambda function asynchronously  

---

### Question 20
A company needs to choose between ECS Service Connect and AWS App Mesh for service-to-service communication between 30 ECS services. The team wants traffic management features (retries, circuit breaking, timeouts), observability (traces, metrics), and minimal operational overhead. They don't need multi-cluster or cross-platform (EKS/EC2) mesh support. Which option is better?

A) ECS Service Connect — it is built natively into ECS, provides service discovery, traffic management (retries, timeouts), and observability with CloudWatch metrics and X-Ray traces. It requires minimal configuration compared to App Mesh (no virtual nodes, virtual services, or virtual routers to manage). Since the workload is ECS-only and doesn't need cross-platform mesh, Service Connect is simpler with equivalent core features.  
B) AWS App Mesh — it provides more advanced traffic management and observability through Envoy sidecar proxies and is the only option supporting retries and circuit breaking  
C) Use ALB with path-based routing between all 30 services for simplicity  
D) Use AWS Cloud Map for service discovery and implement retries/circuit breaking in application code  

---

### Question 21
A company runs a containerized application on ECS Fargate. The application needs to access secrets (database passwords, API keys) stored in AWS Secrets Manager. The team wants secrets injected into the container at startup without modifying application code. How should this be configured?

A) In the ECS task definition, use the `secrets` property in the container definition to reference Secrets Manager ARNs. ECS injects the secret values as environment variables when the container starts. The task execution role must have `secretsmanager:GetSecretValue` permission for the referenced secrets.  
B) Use a sidecar container that fetches secrets from Secrets Manager and writes them to a shared volume  
C) Store secrets in S3 and download them in the container's entrypoint script  
D) Embed secrets directly in the Docker image's environment variables during the build process  

---

### Question 22
A company has an Auto Scaling Group of EC2 instances behind an ALB. The instances run a stateful application that stores session data in local memory. When an instance is terminated by a scale-in event, active user sessions are lost. The company cannot modify the application to use external session storage. What should the solutions architect recommend to minimize session loss during scale-in?

A) Enable scale-in protection on instances that are actively serving sessions. Use a process running on each instance that monitors active sessions and calls the Auto Scaling API to set `SetInstanceProtection` to true when sessions are active. When sessions complete, the process removes protection, allowing the ASG to terminate the instance during scale-in.  
B) Configure ALB sticky sessions (session affinity) and set the deregistration delay to a long duration (e.g., 3600 seconds). This ensures existing sessions complete on the current instance before it is removed from the target group during scale-in.  
C) Increase the ASG minimum size to prevent scale-in events entirely  
D) Use Spot Instances with Spot Instance interruption handling for graceful shutdown  

---

### Question 23
**(Select THREE)** A company is building a multi-tenant SaaS application on EKS. Each tenant's workload must be isolated from other tenants at the compute, network, and IAM levels. Which THREE configurations provide comprehensive tenant isolation?

A) Deploy each tenant's pods in a dedicated Kubernetes namespace. Apply ResourceQuotas to limit CPU, memory, and pod count per namespace. Use LimitRanges to set default container resource limits.  
B) Implement Kubernetes Network Policies using Calico or VPC CNI network policy support to restrict pod-to-pod communication between namespaces. Each tenant namespace only allows traffic within its own namespace and to shared services.  
C) Use IAM Roles for Service Accounts (IRSA) with separate IAM roles per tenant namespace. Each role has permissions scoped to only that tenant's AWS resources (S3 bucket, DynamoDB table, etc.).  
D) Use a single namespace with labels to differentiate tenants  
E) Deploy separate EKS clusters for each tenant  
F) Run all tenants on the same node pool with no resource limits for maximum efficiency  

---

### Question 24
A company runs an EC2 Auto Scaling Group with a target tracking scaling policy based on CPU utilization (target: 60%). During peak hours, the group scales from 5 to 20 instances. The application takes 3 minutes to start serving traffic after launch. Users experience errors during scaling because the ALB routes traffic to instances that aren't ready. What should the architect configure?

A) Configure a health check grace period of 200 seconds on the Auto Scaling Group (longer than startup time) so that the ASG doesn't replace instances still starting up. Configure the ALB target group health check with appropriate intervals and thresholds. Most importantly, ensure the application's health check endpoint returns healthy ONLY after it's ready to serve traffic.  
B) Use a step scaling policy instead of target tracking for more control over scaling increments  
C) Set the default cooldown to 300 seconds to prevent rapid scaling  
D) Use Scheduled Scaling to pre-provision instances before peak hours  

---

### Question 25
A company needs to run an AWS Batch multi-node parallel job for an HPC fluid dynamics simulation. The job requires 64 nodes, each with 36 vCPUs and 72 GB memory. All nodes must communicate using MPI. Which AWS Batch configuration supports this?

A) Create a Batch compute environment with EC2 instances that have EFA (Elastic Fabric Adapter) support. Configure the multi-node parallel job definition with `numNodes: 64` and `mainNode: 0`. Specify placement group constraints for the compute environment to ensure all nodes are in the same cluster placement group. Use the `p4d.24xlarge` or `hpc6a.48xlarge` instance type with EFA enabled.  
B) Use Fargate as the compute environment for the multi-node parallel job  
C) Configure 64 separate single-node Batch jobs and coordinate them using Step Functions  
D) Use Batch array jobs with 64 child jobs for parallel processing  

---

### Question 26
A company has a Lambda function packaged as a container image (9.5 GB). The function is invoked infrequently (once per hour) and takes 45 seconds to cold start. The cold start is unacceptable for the use case. The company currently uses provisioned concurrency to keep 5 instances warm, costing $800/month. They want to reduce costs while maintaining fast response times. What should the architect recommend?

A) Optimize the container image: use a minimal base image (like alpine or distroless), remove unnecessary dependencies, and use multi-stage Docker builds to reduce image size. A smaller image reduces cold start time significantly. If cold starts are still too long, reduce provisioned concurrency to the minimum needed (e.g., 1-2 instances instead of 5 for once-per-hour invocations). Also leverage Lambda SnapStart if the runtime supports it.  
B) Switch from container image to a zip deployment package for faster cold starts  
C) Increase the Lambda function's memory to 10 GB for faster initialization  
D) Use reserved concurrency of 5 instead of provisioned concurrency to reduce costs  

---

### Question 27
A company has an ECS cluster on EC2 instances. Tasks are failing to place because no instances have sufficient memory, even though CPU utilization across the cluster is only 30%. The cluster has 10 m5.large instances (8 GB memory each). Tasks request 2 GB memory each, and there are currently 30 running tasks. What is the issue?

A) Memory fragmentation across instances. 10 instances × 8 GB = 80 GB total. However, the ECS agent and OS consume approximately 0.5-1 GB per instance, leaving ~70 GB usable. 30 tasks × 2 GB = 60 GB consumed. The remaining 10 GB is spread across instances (1 GB per instance), and no single instance has 2 GB free for a new task. The solution is to enable ECS managed scaling with a target capacity of 80% or use binpacking placement strategy to consolidate tasks.  
B) The ECS service has reached its task limit  
C) The m5.large instance type does not support ECS tasks larger than 1 GB  
D) Container memory is limited to 50% of the instance memory by default  

---

### Question 28
A company runs a fleet of EC2 instances across 3 AZs. They use a combination of Reserved Instances (1-year, partial upfront) for baseline capacity and Spot Instances for burst capacity. A new requirement mandates that at least 3 instances must be running in each AZ at all times, even if all Spot Instances are interrupted. How should the architect configure the Auto Scaling Group?

A) Configure the ASG with `minSize: 9` (3 per AZ), `OnDemandBaseCapacity: 9`, and `OnDemandPercentageAboveBaseCapacity: 0` (all capacity above baseline comes from Spot). This ensures the first 9 instances are always On-Demand (covered by Reserved Instances), providing guaranteed 3-per-AZ minimum. Set `SpotAllocationStrategy: capacity-optimized` for burst instances.  
B) Create 3 separate ASGs (one per AZ) with minimum size 3 each and a Spot Fleet for burst  
C) Set the ASG minimum to 9 with only Spot Instances and rely on Spot diversification for availability  
D) Use On-Demand Capacity Reservations in each AZ without an Auto Scaling Group  

---

### Question 29
A company needs to deploy a containerized application that requires exactly 1 vCPU and 2 GB memory per container. They expect to run 1,000 concurrent containers. The workload is steady (24/7) and predictable. Comparing ECS on Fargate vs ECS on EC2 (using m5.xlarge: 4 vCPU, 16 GB memory, cost $0.192/hour), which is more cost-effective for this steady-state workload?

A) ECS on EC2 is more cost-effective. Fargate pricing for 1 vCPU + 2 GB is approximately $0.04048 + $0.004445×2 = $0.0494/hour per task. 1,000 tasks = $49.40/hour. EC2: 1,000 containers ÷ 4 containers per m5.xlarge = 250 instances. 250 × $0.192/hour = $48.00/hour. EC2 is cheaper, and with Reserved Instances or Savings Plans, the savings are much greater (up to 72% off).  
B) Fargate is always cheaper because there is no EC2 management overhead  
C) Both cost the same — AWS pricing is designed for price parity between Fargate and EC2  
D) Fargate is cheaper because you don't pay for unused capacity on EC2 instances  

---

### Question 30
**(Select TWO)** A company runs an EKS cluster and needs to implement pod autoscaling. Some workloads should scale based on CPU utilization, while others should scale based on the depth of an SQS queue. Which TWO autoscaling components should be configured?

A) Horizontal Pod Autoscaler (HPA) with the default metrics-server for CPU-based scaling of web workloads  
B) KEDA (Kubernetes Event-Driven Autoscaling) for SQS queue-based scaling. KEDA acts as a custom metrics adapter that can scale pods to zero and scale based on external metrics like SQS queue depth.  
C) Kubernetes Vertical Pod Autoscaler (VPA) for SQS-based scaling  
D) AWS App Mesh metrics for autoscaling decisions  
E) CloudWatch Container Insights for pod scaling  

---

### Question 31
A company has an ECS service running behind an ALB. The service must handle 50,000 requests per second. Each request takes 100ms to process. The containers are configured with 1 vCPU and 2 GB memory. What is the minimum number of tasks required?

A) Each task handles 1 request at a time in 100ms = 10 requests/second per task. For 50,000 RPS: 50,000 / 10 = 5,000 tasks minimum. However, this assumes single-threaded processing. If the application is multi-threaded and can handle concurrent requests, the number decreases. Assuming each 1 vCPU task handles 10 concurrent connections: 50,000 / (10 × 10) = 500 tasks.  
B) 50 tasks — each task handles 1,000 requests per second  
C) 5,000 tasks — assuming single-threaded sequential processing  
D) The answer depends on the application's concurrency model — more information is needed about whether the application handles requests concurrently or sequentially  

---

### Question 32
A company uses EC2 Spot Instances for a distributed data processing workload. They have a Spot Fleet with 100 instances across c5.xlarge, c5.2xlarge, and m5.xlarge types in 3 AZs. The fleet uses `lowest-price` allocation strategy. The team reports frequent interruptions affecting job completion. What should the architect recommend to reduce interruptions?

A) Change the Spot allocation strategy from `lowest-price` to `capacity-optimized`. The `capacity-optimized` strategy selects instances from pools with the highest available capacity, reducing the likelihood of interruption. `lowest-price` concentrates instances in the cheapest pools, which are often the most contested and have the highest interruption rates.  
B) Increase the Spot bid price to 100% of the On-Demand price  
C) Add more instance types to the fleet configuration (e.g., c5a.xlarge, m5a.xlarge, r5.xlarge) to increase pool diversity  
D) Switch entirely to On-Demand instances  

---

### Question 33
A company runs a video encoding service on ECS Fargate. Each encoding task uses 4 vCPU and 30 GB memory and takes 30 minutes. The service processes 500 videos per day, arriving in bursts. Encoding tasks are triggered by S3 events. The company wants the MOST cost-effective compute option. Which should they use?

A) Use Fargate Spot for the encoding tasks. Fargate Spot provides up to 70% discount compared to Fargate On-Demand. Since encoding tasks are fault-tolerant (they can be restarted if interrupted) and the 30-minute duration is short enough to minimize interruption impact, Fargate Spot is optimal. Configure the ECS service with a `FARGATE_SPOT` capacity provider with weight 1, and `FARGATE` with weight 0 as a fallback base.  
B) Use standard Fargate pricing — the tasks are too short for Spot  
C) Use EC2 Reserved Instances sized for peak encoding capacity  
D) Use Lambda with 10 GB memory and 15-minute timeout  

---

### Question 34
**(Select TWO)** A company has an Auto Scaling Group with instances in 3 AZs. The ASG currently has 12 instances (4 per AZ). A scale-in event needs to remove 3 instances. By default, which TWO factors determine which instances are terminated?

A) The ASG first identifies the AZ with the most instances. If all AZs have equal instances (4 each), it selects the AZ with instances closest to the next billing hour (to minimize cost).  
B) Within the selected AZ, the ASG uses the default termination policy which terminates the instance with the oldest launch configuration or launch template version first  
C) The ASG always terminates the newest instances first to preserve long-running workloads  
D) The ASG terminates instances randomly across all AZs  
E) The ASG terminates instances with the lowest CPU utilization  

---

### Question 35
A company needs to run a Windows container on AWS. The container packages a legacy .NET Framework 4.8 application. Which AWS container service supports Windows containers?

A) Amazon ECS with EC2 launch type using Windows-based container instances (Windows Server Core or Windows Server with Desktop Experience AMIs). Register the Windows container instances with the ECS cluster and deploy Windows container task definitions. Note: EKS also supports Windows worker nodes for Windows containers.  
B) Amazon ECS with Fargate — Fargate supports Windows containers natively  
C) Amazon EKS only — ECS does not support Windows containers  
D) Neither ECS nor EKS support Windows containers — use EC2 directly  

---

### Question 36
A company has an ECS cluster running 50 services. The operations team wants to implement centralized logging. Each container's stdout/stderr should be collected and sent to CloudWatch Logs with the container name, task ID, and cluster name as metadata. What is the simplest approach?

A) Use the `awslogs` log driver in the ECS task definitions. Configure `awslogs-group`, `awslogs-region`, and `awslogs-stream-prefix` options. The awslogs driver automatically captures stdout/stderr and sends to CloudWatch Logs. The log stream name format includes the container name, task ID, and ECS cluster context.  
B) Deploy a Fluentd sidecar container in every task definition to collect and forward logs  
C) Install CloudWatch agent on each container instance (EC2 launch type) to scrape container logs  
D) Mount a shared EFS volume for log files and use a Lambda function to process and forward them  

---

### Question 37
A company runs an ML training job on a p3.16xlarge instance (8 NVIDIA V100 GPUs). The job takes 12 hours and the training can be checkpointed every 30 minutes. The company wants to reduce costs. The training framework supports resuming from checkpoints. Which approach provides the LOWEST cost?

A) Use a p3.16xlarge Spot Instance. Save checkpoints to S3 every 30 minutes. If a Spot interruption occurs, launch a new Spot Instance and resume from the last checkpoint. Even with interruptions, the ~70% Spot discount makes this cheaper than On-Demand, and the maximum lost work is 30 minutes per interruption.  
B) Use a Reserved Instance for the p3.16xlarge for 1 year  
C) Use Graviton instances for ML training to reduce costs  
D) Use SageMaker managed training jobs exclusively — they automatically use Spot with checkpointing  

---

### Question 38
A company runs a Kubernetes application on EKS. The application has 3 tiers: web (stateless, many replicas), API (stateless, moderate replicas), and database (StatefulSet, 3 replicas with PVCs). The web and API tiers should run on Spot Instances for cost savings, but the database tier must run on On-Demand instances for stability. How should the EKS node groups be configured?

A) Create two EKS managed node groups: one with On-Demand instances labeled `workload=stable` for the database tier, and one with Spot instances labeled `workload=spot` for web and API tiers. Configure the database StatefulSet with a `nodeSelector` for `workload: stable` and a toleration for the On-Demand node taint. Configure web and API Deployments with `nodeSelector` for `workload: spot`.  
B) Use a single managed node group with mixed instances (On-Demand and Spot) and let Kubernetes schedule pods randomly  
C) Use Fargate profiles for all tiers to avoid node management entirely  
D) Create separate EKS clusters for Spot and On-Demand workloads  

---

### Question 39
**(Select TWO)** A company needs to perform a zero-downtime migration of an ECS service from EC2 launch type to Fargate. The service currently runs 10 tasks behind an ALB. Which TWO steps should be performed?

A) Create a new ECS service with the Fargate launch type using the same task definition (updated with `requiresCompatibilities: FARGATE` and `networkMode: awsvpc`) registered to the same ALB target group. Gradually increase the Fargate service's desired count while decreasing the EC2 service's desired count.  
B) Update the existing ECS service's launch type from EC2 to Fargate in-place — ECS handles the migration automatically  
C) Ensure the task definition uses `awsvpc` network mode (required for Fargate) and configure the security groups and subnets in the Fargate service's network configuration. Verify that the ALB target group uses `ip` target type (required for awsvpc).  
D) Simply change the capacity provider from EC2 to Fargate in the existing service  
E) Create a new ALB for the Fargate service and use Route 53 weighted routing to shift traffic  

---

### Question 40
A company runs batch jobs on EC2 instances using Auto Scaling. Jobs are pulled from an SQS queue. Each job takes 10-60 minutes. The ASG scales based on the approximate number of messages visible in the queue. The team notices that during scale-in, instances are terminated while still processing jobs, causing job failures. How should this be fixed?

A) Enable scale-in protection programmatically. Have the instance set its own scale-in protection to `true` via the Auto Scaling API when it starts processing a job and set it to `false` when the job completes. This prevents the ASG from terminating instances with active jobs during scale-in.  
B) Set the ASG cooldown period to 3600 seconds (1 hour) to prevent premature scale-in  
C) Use SQS visibility timeout equal to the maximum job duration (60 minutes) — this is unrelated to ASG scale-in  
D) Configure the ASG to terminate only instances in the `Standby` state  

---

### Question 41
A company has a critical application running on EC2 instances. They want to ensure that their instances use the latest Nitro system for security features including secure boot, hardware-based encryption, and dedicated hardware for the hypervisor. Which instance families run on the Nitro system?

A) All current-generation instance families (C5, M5, R5, T3, P4, G5, and newer) run on the Nitro system. The Nitro system provides enhanced networking (up to 100 Gbps), hardware-level encryption for EBS volumes, and bare-metal options. Older generations (C4, M4, T2) do NOT use Nitro.  
B) Only bare-metal instance types (.metal) use the Nitro system  
C) Only compute-optimized (C-family) instances use the Nitro system  
D) All instance families including first-generation (m1, c1) use the Nitro system  

---

### Question 42
**(Select TWO)** A company runs a machine learning inference application on ECS Fargate. The application receives requests via an ALB and needs to scale based on the number of requests per target (not CPU). The team also wants the service to scale to zero during off-hours to save costs. Which TWO considerations apply?

A) Configure Application Auto Scaling for the ECS service with a target tracking policy using the ALBRequestCountPerTarget metric. This scales based on request count rather than CPU.  
B) ECS services on Fargate cannot scale to zero — the minimum task count is 1. To achieve near-zero cost during off-hours, use Scheduled Scaling to reduce the desired count to 1 during off-hours and increase it during business hours.  
C) Use Step Scaling with CloudWatch alarms on ALBRequestCountPerTarget for more granular control  
D) Configure Karpenter to manage Fargate task scaling  
E) Fargate supports scaling to zero natively — set the desired count to 0 during off-hours  

---

### Question 43
A company runs an application on an Auto Scaling Group. The application stores important state data on instance store volumes (NVMe SSDs for low latency). The operations team reports that state data is lost whenever an instance is stopped, terminated, or fails. How should the architect design a solution that preserves the low-latency writes while preventing data loss?

A) Continue using instance store volumes for low-latency writes. Implement an asynchronous replication mechanism: the application writes to the local instance store for low-latency operations and asynchronously replicates data to an EBS volume or S3 as a durable backup. On instance recovery, restore from the backup. This provides both low latency and durability.  
B) Replace instance store volumes with EBS io2 volumes — they provide similar latency  
C) Use EBS volumes with Provisioned IOPS and enable Multi-Attach for redundancy  
D) Write directly to S3 using Transfer Acceleration for low latency  

---

### Question 44
A company has a containerized web application on EKS. During deployments, they experience 30 seconds of errors because the old pods are terminated before the new pods are fully ready. The deployment uses `maxSurge: 25%` and `maxUnavailable: 25%`. How should this be fixed?

A) Configure readiness probes on the pods to ensure Kubernetes only routes traffic to pods that are fully initialized and ready. Configure a `preStop` lifecycle hook with a `sleep 30` command to give the pod time to finish in-flight requests before receiving SIGTERM. Kubernetes removes the pod from the Service endpoints before sending SIGTERM, but the `preStop` hook provides a grace period for connection draining.  
B) Increase `maxSurge` to 100% and set `maxUnavailable` to 0%  
C) Use `kubectl rollout pause` to manually verify each pod before proceeding  
D) Set `terminationGracePeriodSeconds` to 300 without implementing readiness probes  

---

### Question 45
A company runs a serverless data pipeline: S3 trigger → Lambda (transform) → S3 (output). The Lambda function processes CSV files and produces Parquet output. Input files are 500 MB each. The Lambda function needs 8 GB memory and runs for 10 minutes per file. What are the potential issues?

A) The Lambda function has two limits to consider: (1) the /tmp ephemeral storage is 10 GB (configurable up to 10 GB), which should be sufficient for a single 500 MB file, and (2) the 15-minute maximum timeout, which accommodates the 10-minute processing time. However, if multiple files trigger simultaneously, each invocation uses its own /tmp space. The main concern is ensuring the Lambda deployment package or container image includes the necessary libraries (like pandas, pyarrow) and doesn't exceed size limits.  
B) Lambda can only process files up to 10 MB — the 500 MB file exceeds the input limit  
C) Lambda ephemeral storage (/tmp) is limited to 512 MB and cannot be increased  
D) Lambda maximum memory is 3 GB, which is less than the 8 GB required  

---

### Question 46
A company needs to deploy an EKS cluster with strict network security. Pods in the `frontend` namespace should only accept traffic from the ALB, pods in the `backend` namespace should only accept traffic from `frontend` pods, and pods in the `database` namespace should only accept traffic from `backend` pods. How should this be implemented?

A) Configure Kubernetes Network Policies for each namespace. The `frontend` NetworkPolicy allows ingress only from the ALB's CIDR or security group. The `backend` NetworkPolicy allows ingress only from pods with labels matching `frontend` pods using `namespaceSelector` and `podSelector`. The `database` NetworkPolicy allows ingress only from `backend` pods. Ensure the VPC CNI network policy feature is enabled or use Calico as the network policy engine.  
B) Use Security Groups for Pods — assign different security groups to each namespace  
C) Configure NACLs on the subnets hosting each namespace's pods  
D) Use AWS App Mesh with mTLS between all services for network isolation  

---

### Question 47
A company runs a web application on a mix of On-Demand and Spot Instances in an Auto Scaling Group. They use a mixed instances policy with `OnDemandBaseCapacity: 4`, `OnDemandPercentageAboveBaseCapacity: 25`, and `SpotAllocationStrategy: capacity-optimized`. The current desired capacity is 20. How many On-Demand and Spot instances are running?

A) On-Demand: 4 (base) + 25% of (20 - 4) = 4 + 4 = 8 On-Demand. Spot: 20 - 8 = 12 Spot instances.  
B) On-Demand: 4, Spot: 16  
C) On-Demand: 5 (25% of 20), Spot: 15  
D) On-Demand: 20 (base capacity is 4, but minimum is the desired count)  

---

### Question 48
A company runs an ECS service using capacity provider strategies. They have two capacity providers: FARGATE (weight: 1, base: 2) and FARGATE_SPOT (weight: 3, base: 0). If the service scales to 10 tasks, how many tasks run on each provider?

A) The first 2 tasks run on FARGATE (satisfying the base). The remaining 8 tasks are distributed by weight ratio (1:3): 2 on FARGATE and 6 on FARGATE_SPOT. Total: 4 FARGATE + 6 FARGATE_SPOT = 10 tasks.  
B) 2 FARGATE + 8 FARGATE_SPOT — all tasks above base go to the higher-weight provider  
C) 5 FARGATE + 5 FARGATE_SPOT — equal distribution regardless of weights  
D) 10 FARGATE_SPOT — higher weight means all non-base tasks go to Spot  

---

### Question 49
**(Select TWO)** A company runs a highly available web application on ECS Fargate across 3 AZs. The application experiences a sudden 10x traffic spike. The ECS service has an Application Auto Scaling target tracking policy on CPU utilization (target: 50%). Which TWO issues might occur during the spike?

A) The target tracking policy may not scale fast enough because it adjusts based on the metric's deviation from the target. For sudden 10x spikes, the scaling response is incremental and may take multiple scaling steps. Consider adding a Step Scaling policy as a complement for large metric deviations.  
B) Fargate may hit the account-level Fargate task quota (default: varies by region, often 500-1000 tasks). If the spike requires more tasks than the quota allows, new tasks will fail to launch. Request a quota increase proactively.  
C) Fargate tasks have a 15-minute cold start that prevents rapid scaling  
D) ECS services cannot scale beyond the original desired count  
E) CloudWatch metrics have a 5-second delay that prevents Auto Scaling from detecting the spike  

---

### Question 50
A company needs to deploy a container that requires kernel capabilities (e.g., NET_ADMIN) for network monitoring. The container must modify iptables rules inside the container. Which container platform supports this?

A) Amazon ECS with EC2 launch type and the task definition configured with `linuxParameters.capabilities.add: ["NET_ADMIN"]`. Fargate does NOT support adding Linux capabilities — the container must run on EC2. The task must also NOT be run in awsvpc network mode if it needs full host network manipulation, or use host network mode.  
B) Amazon ECS with Fargate — set the `privileged` flag to true in the task definition  
C) Amazon EKS only — ECS does not support Linux capabilities  
D) None — AWS container services block all kernel capabilities for security  

---

### Question 51
A company is running an EKS cluster with managed node groups. They want to implement cluster autoscaling that considers GPU resources, specific instance type requirements, and consolidation of underutilized nodes. The Cluster Autoscaler is proving too slow and inflexible. Which alternative should they adopt?

A) Karpenter — it is purpose-built for Kubernetes node autoscaling and provides: (1) direct EC2 API integration for faster provisioning than ASG-based Cluster Autoscaler, (2) pod-aware scheduling that selects optimal instance types (including GPU) based on pending pod requirements, (3) automatic consolidation that replaces underutilized nodes with right-sized instances, (4) support for mixed instance types and purchase options in a single NodePool.  
B) AWS Auto Scaling (application-level) for managing node scaling  
C) Deploy Fargate profiles for GPU workloads to eliminate node management  
D) Use AWS Batch instead of EKS for GPU workloads  

---

### Question 52
**(Select TWO)** A company runs a Java application on EC2. The application creates many short-lived objects, causing frequent garbage collection (GC) pauses that affect response latency (P99 latency spikes to 500ms during GC). The instance is c5.2xlarge (8 vCPU, 16 GB memory). The JVM heap is set to 12 GB. Which TWO actions would MOST reduce GC-related latency?

A) Switch to a memory-optimized instance (r5.2xlarge: 8 vCPU, 64 GB memory) and increase JVM heap to 48 GB to reduce GC frequency. However, this may worsen GC pause duration. Instead, use ZGC or Shenandoah garbage collector (available in Java 17+) which provides sub-millisecond GC pauses regardless of heap size.  
B) Reduce the JVM heap size to 4 GB so that GC completes faster with less memory to scan. The more frequent but shorter GC pauses produce lower P99 latency than infrequent long pauses.  
C) Use Graviton instances (c6g.2xlarge) — ARM64 processors have more efficient GC due to hardware memory management  
D) Enable Enhanced Networking (ENA) for lower network latency  
E) Use a low-latency garbage collector like ZGC (enabled with `-XX:+UseZGC`) which provides consistent sub-millisecond GC pause times even with large heaps  

---

### Question 53
A company has a Lambda function that processes images uploaded to S3. The function uses the sharp library for image processing, which has native binaries. The team currently deploys using a zip package with the Lambda runtime set to Node.js 18.x on x86_64. They want to switch to ARM64 (Graviton2) for the 20% cost savings. What must they consider?

A) The sharp library's native binaries must be recompiled for ARM64 (aarch64-linux). The team must rebuild the deployment package on an ARM64 environment or use cross-compilation. The Lambda function's architecture setting must be changed to `arm64`. The x86_64 native binaries will NOT work on ARM64 — deploying without recompilation will cause runtime errors.  
B) Lambda automatically handles binary translation — no changes needed except the architecture setting  
C) Native binaries are not supported on Lambda ARM64 — only pure JavaScript libraries work  
D) The team must switch to a container image deployment to use ARM64  

---

### Question 54
A company has an ECS cluster running on EC2 instances behind an ALB. The application uses WebSockets for real-time communication. Users report that WebSocket connections are being dropped every 60 seconds. The application has a heartbeat interval of 30 seconds. What is the cause and fix?

A) The ALB's idle timeout is 60 seconds by default. WebSocket connections that don't send data within this timeout are closed. Fix: increase the ALB idle timeout to a value greater than the expected idle period (e.g., 3600 seconds for WebSocket connections). The application's 30-second heartbeat should keep connections alive IF the heartbeat traffic is visible to the ALB. Verify that WebSocket frames are being sent, not just TCP keep-alives.  
B) ECS task recycling terminates tasks every 60 seconds  
C) The NLB does not support WebSocket connections  
D) WebSocket connections have a maximum duration of 60 seconds on AWS  

---

### Question 55
**(Select TWO)** A company is running a stateful application on EKS. The application uses persistent volumes for data storage. The team needs to ensure: (1) persistent volumes survive pod restarts and rescheduling, and (2) the storage provides IOPS up to 64,000 for database workloads. Which TWO configurations are needed?

A) Use the Amazon EBS CSI driver and create a StorageClass with `provisioner: ebs.csi.aws.com`, `type: io2`, and `iopsPerGB: 50`. Create PersistentVolumeClaims (PVCs) in the StatefulSet. EBS volumes persist independently of pods and are automatically reattached when pods are rescheduled to the same AZ.  
B) Use the Amazon EFS CSI driver for all persistent storage — EFS supports unlimited IOPS  
C) Configure `volumeBindingMode: WaitForFirstConsumer` in the StorageClass to ensure EBS volumes are created in the same AZ as the pod. This prevents scheduling failures when pods move across AZs.  
D) Use instance store volumes with the CSI driver for maximum IOPS  
E) Mount S3 as a persistent volume using the Mountpoint for S3 CSI driver  

---

### Question 56
A company runs a containerized machine learning training pipeline on ECS. The pipeline has 4 stages: data preprocessing (CPU-intensive, 2 hours), feature engineering (memory-intensive, 1 hour), model training (GPU-required, 8 hours), and model evaluation (CPU, 30 minutes). They want to optimize costs by using the right compute for each stage. What architecture should be used?

A) Use AWS Step Functions to orchestrate the pipeline with different ECS task definitions per stage. Stage 1: Fargate Spot with 4 vCPU/8 GB. Stage 2: Fargate Spot with 2 vCPU/16 GB. Stage 3: EC2 launch type with p3 GPU instances (Spot with checkpointing). Stage 4: Fargate Spot with 1 vCPU/2 GB. Step Functions passes output locations (S3) between stages. Each stage uses compute optimized for its workload.  
B) Run all stages on a single p3 GPU instance to avoid data transfer between stages  
C) Use a single Fargate task definition with the maximum resources needed (GPU + high memory) for all stages  
D) Use SageMaker Pipelines exclusively — ECS cannot run ML training workloads  

---

### Question 57
A company has an Auto Scaling Group with 10 instances in us-east-1. They use a custom AMI with the application pre-installed. A critical security patch requires updating the AMI. The company needs to replace all instances with the new AMI within 1 hour with zero downtime. What is the fastest approach?

A) Create the new AMI with the security patch. Update the ASG's launch template to a new version using the patched AMI. Start an Instance Refresh with `MinHealthyPercentage: 90` and `InstanceWarmup: 120` (2 minutes). The Instance Refresh automatically replaces instances in rolling batches, maintaining availability throughout.  
B) Terminate all instances simultaneously and let the ASG launch 10 new instances with the new AMI  
C) Manually terminate and replace one instance at a time  
D) Create a new ASG with the new AMI and use Route 53 weighted routing to shift traffic  

---

### Question 58
A company has a Lambda function with 1 GB memory that processes records from a Kinesis Data Stream. The stream has 10 shards. Each record is 100 KB. During peak hours, the function's batch size is 100 records and the function takes 30 seconds to process each batch. The team notices increasing iterator age. What is the problem and solution?

A) With 10 shards, Lambda runs at most 10 concurrent executions (one per shard) by default. Each execution takes 30 seconds per batch of 100 records. If records arrive faster than they can be processed, iterator age increases. Solution: enable the parallelization factor (up to 10 per shard) to process multiple batches concurrently from the same shard. Set `ParallelizationFactor: 5` to run 50 concurrent executions across 10 shards. Also optimize the function to process faster or increase batch size.  
B) Increase the Lambda function's timeout — it's hitting the 15-minute limit  
C) Add more shards to the Kinesis stream — the only way to increase parallelism  
D) Increase Lambda memory to 10 GB for faster processing  

---

### Question 59
A company runs a Kubernetes application on EKS with 50 microservices. They need centralized observability: distributed tracing, metrics, and logs. The team wants an AWS-native solution with minimal operational overhead. Which combination of services should be used?

A) Enable Amazon CloudWatch Container Insights for EKS for metrics and logs. Use AWS X-Ray SDK in each microservice for distributed tracing, with the X-Ray daemon deployed as a DaemonSet. Use CloudWatch Logs with Fluent Bit (deployed as a DaemonSet) for centralized log collection. This is fully AWS-native with low operational overhead.  
B) Deploy a self-managed Prometheus + Grafana + Jaeger stack on the EKS cluster  
C) Use Amazon Managed Service for Prometheus for metrics, Amazon Managed Grafana for dashboards, and AWS Distro for OpenTelemetry for traces and logs  
D) Rely solely on CloudWatch Container Insights — it provides metrics, logs, and traces  

---

### Question 60
**(Select TWO)** A company uses EC2 Spot Instances in an ASG with a mixed instances policy. The ASG uses 6 different instance types across 3 AZs. The company wants to maximize the number of Spot Instances while ensuring they always have enough capacity. Which TWO strategies should they implement?

A) Set `SpotAllocationStrategy: capacity-optimized` to launch Spot Instances from pools with the most available capacity, reducing interruption risk  
B) Set `OnDemandBaseCapacity` to the minimum number of instances needed for the application to function. This guarantees a baseline of On-Demand instances that are never interrupted, with all additional capacity from Spot.  
C) Use `SpotMaxPrice` set to 50% of On-Demand price to save money  
D) Set `OnDemandPercentageAboveBaseCapacity: 100` to ensure all instances above base are On-Demand  
E) Remove all On-Demand capacity and rely entirely on Spot diversity for availability  

---

### Question 61
A company wants to deploy a containerized application that needs to run as PID 1 (init process) to properly handle SIGTERM signals for graceful shutdown. On ECS Fargate, the container's application process runs as PID 1 by default. However, the application doesn't handle SIGTERM and instead requires SIGKILL after a grace period. How should the task definition be configured?

A) Set `stopTimeout` in the container definition to the desired grace period (e.g., 30 seconds). When ECS stops the task, it sends SIGTERM to PID 1. After the stopTimeout period, if the container hasn't exited, ECS sends SIGKILL. This gives the application time to finish work before forced termination.  
B) Configure the Dockerfile's CMD to run a shell script that traps SIGTERM and converts it to SIGKILL  
C) Set `essential: false` on the container so it doesn't receive stop signals  
D) Use the ECS execute command to send SIGKILL manually when stopping tasks  

---

### Question 62
A company is evaluating EC2 pricing models for a production database server. The server runs 24/7 and requires a db.r5.4xlarge equivalent (16 vCPU, 128 GB memory). The commitment period is 3 years. The company has steady-state usage with no expected changes. Which pricing model provides the MAXIMUM discount?

A) EC2 Instance Savings Plan for a 3-year term with all upfront payment provides up to 72% savings compared to On-Demand. Alternatively, a 3-year All Upfront Reserved Instance provides similar savings. For a known, steady-state workload with no expected changes, the All Upfront payment option over 3 years provides the maximum possible discount.  
B) 1-year Partial Upfront Reserved Instance  
C) Spot Instances with persistent Spot requests for guaranteed capacity  
D) Compute Savings Plan for maximum flexibility across instance families  

---

### Question 63
**(Select TWO)** A company runs a real-time data processing application on ECS. The application reads from Kinesis Data Streams, processes records, and writes to DynamoDB. The ECS tasks are CPU-bound during processing and memory-bound during batch writes. The company wants to right-size the tasks. Which TWO approaches help determine the correct task size?

A) Use CloudWatch Container Insights to monitor CPU utilization and memory utilization at the task level. Analyze peak and average values over a 2-week period. Set task CPU to accommodate peak CPU usage with 20% headroom and memory to accommodate peak memory with 20% headroom.  
B) Use AWS Compute Optimizer which analyzes ECS task resource utilization and provides right-sizing recommendations based on historical metrics  
C) Run load tests with progressively smaller task sizes until the application fails  
D) Use the default Fargate task size (0.25 vCPU, 0.5 GB) and scale horizontally  
E) Monitor only CloudTrail for ECS API call patterns to determine sizing  

---

### Question 64
A company needs to deploy a blue/green environment for a monolithic application running on an Auto Scaling Group behind an ALB. The deployment must allow instant rollback and the green environment must be tested with production traffic before full cutover. Which approach provides this?

A) Create a second Auto Scaling Group (green) with the new version behind a second target group on the same ALB. Use ALB weighted target group routing to shift 10% of traffic to the green target group for testing. If successful, shift to 100%. For rollback, shift traffic back to the blue target group (100%/0%). Both ASGs remain running during the transition for instant rollback.  
B) Use CodeDeploy in-place deployment with traffic hooks  
C) Deploy the green environment behind a separate ALB and use Route 53 weighted routing  
D) Terminate the blue ASG instances and launch green ASG instances in one operation  

---

### Question 65
A company has a web application running on ECS Fargate. The application handles unpredictable traffic ranging from 10 requests per minute to 50,000 requests per second. During idle periods, they want to minimize costs, and during peak periods, they need to handle the load within seconds. The application starts up in 5 seconds. Which architecture provides the BEST balance of cost and responsiveness?

A) Configure the ECS service with Application Auto Scaling using a target tracking policy on ALBRequestCountPerTarget. Set a low target value (e.g., 100 requests per target) for aggressive scaling. Add a Step Scaling policy triggered by a CloudWatch alarm on high request count for rapid response to sudden spikes. Set the service minimum to 2 tasks (for availability) and maximum to a high number (e.g., 500). The 5-second startup time means new tasks can serve traffic almost immediately, and Fargate's serverless model means you only pay for running tasks.  
B) Use Lambda behind API Gateway for fully serverless scaling to zero  
C) Use a fixed fleet of 100 Fargate tasks running 24/7 to handle peak capacity  
D) Use EC2 Auto Scaling with predictive scaling for anticipated traffic patterns  

---

## Answer Key

### Question 1
**Correct Answer: A**

Amazon EFS mounted to Fargate tasks solves the cold start problem:
- EFS provides shared, persistent storage accessible immediately by new tasks.
- Model data is pre-loaded once and shared across all tasks.
- Provisioned Throughput ensures consistent read performance during concurrent launches.
- Option B: Larger ephemeral storage still requires downloading from S3 each time.
- Option C: EC2 launch type abandons the serverless requirement.
- Option D: EBS volumes cannot be attached to Fargate tasks.

### Question 2
**Correct Answer: A**

EKS is the right choice when:
- Team has deep Kubernetes expertise (reduced learning curve).
- On-premises portability is needed (EKS Anywhere).
- Custom scheduling policies are needed (Kubernetes scheduler).
- Helm charts are used (native Kubernetes package management).
- Option B: ECS is simpler but doesn't leverage existing Kubernetes expertise.
- Option C: EKS Fargate doesn't support DaemonSets or custom schedulers.
- Option D: Copilot simplifies ECS but doesn't provide Kubernetes compatibility.

### Question 3
**Correct Answer: A, B**

Graceful task draining requires:
- A: Lifecycle hook + DRAINING state stops new task placement and allows existing tasks to complete.
- B: Deregistration delay keeps the instance registered in the target group long enough for in-flight requests to complete.
- Option C: Placement constraints spread tasks but don't prevent termination loss.
- Option D: ECS managed termination protection prevents termination but may block scaling indefinitely.
- Option E: Fargate task termination requires similar graceful handling.

### Question 4
**Correct Answer: A**

For single-digit microsecond latency:
- Cluster placement group: all instances on the same rack for minimal network hops.
- c5n.18xlarge: 100 Gbps networking with Enhanced Networking.
- Option B: Spread placement group increases latency by distributing across hardware.
- Option C: Partition placement group is for big data, not low latency.
- Option D: EFA is for HPC MPI workloads — TCP applications benefit more from cluster placement + ENA.

### Question 5
**Correct Answer: A**

GPU access on ECS:
- EC2 launch type required (Fargate doesn't support GPU).
- NVIDIA container runtime enables GPU access in containers.
- Task definition `resourceRequirements` specifies GPU needs.
- ECS scheduler places tasks on GPU-available instances.
- Option B: Fargate does not support GPU workloads.
- Option C: GPU must be explicitly requested as a resource type.
- Option D: GPU access is not through Docker volumes.

### Question 6
**Correct Answer: A**

Karpenter vs Cluster Autoscaler:
- Karpenter provisions EC2 instances directly (bypasses ASG).
- Evaluates pending pod requirements to choose optimal instance types.
- Faster provisioning (under 60 seconds typically).
- Consolidation reduces waste by replacing underutilized nodes.
- Option B: Over-provisioning wastes money.
- Option C: Fargate doesn't support all Kubernetes features (DaemonSets, etc.).
- Option D: Custom AMIs help but ASG is still the bottleneck.

### Question 7
**Correct Answer: A**

Fargate ephemeral storage + EFS:
- Fargate supports up to 200 GB ephemeral storage (increased from 20 GB).
- EFS provides shared, concurrent access for multiple tasks.
- Cost-effective: EFS charges for storage used only, no pre-provisioning.
- Option B: EC2 launch type is more complex to manage.
- Option C: S3 as intermediate storage adds significant latency.
- Option D: EBS cannot be shared across Fargate tasks.

### Question 8
**Correct Answer: A, B**

ECS Blue/Green with CodeDeploy:
- A: CodeDeployDefault.ECSCanary10Percent15Minutes shifts 10%, waits 15 min, then 90%.
- B: Auto-rollback on CloudWatch alarm automatically reverts on error detection.
- Option C: Manual ALB weighted routing doesn't provide automated canary + rollback.
- Option D: Rolling update is not blue/green.
- Option E: Manual approval is not automated rollback.

### Question 9
**Correct Answer: A**

EC2 Fleet configuration:
- `lowest-price` for On-Demand: selects cheapest available type.
- `capacity-optimized-prioritized` for Spot: balances capacity availability with priority preference.
- Multiple instance types + AZs maximize Spot pool diversity.
- Option B: Multiple ASGs add management complexity.
- Option C: `lowest-price` for Spot concentrates in contested pools.
- Option D: Separate fleet management is unnecessarily complex.

### Question 10
**Correct Answer: A**

Spot interruption handling:
- Instance metadata endpoint provides 2-minute warning.
- Agent polls and triggers graceful shutdown (game state save).
- EventBridge captures the interruption event for replacement provisioning.
- Option B: CloudWatch Events notification alone doesn't trigger on-instance actions.
- Option C: Spot hibernation doesn't work for all instance types and requires EBS root.
- Option D: Replacement doesn't save the game state.

### Question 11
**Correct Answer: A**

VPC CNI prefix delegation:
- Assigns /28 prefixes (16 IPs) instead of individual IPs per ENI slot.
- Dramatically increases IP capacity per node.
- Also need more address space (secondary CIDRs) for the subnet.
- Option B: Larger instances increase cost significantly.
- Option C: Non-VPC CNI loses some AWS integrations (security groups for pods, etc.).
- Option D: More subnets don't increase per-node IP capacity.

### Question 12
**Correct Answer: A**

HPC with MPI requires:
- EFA for OS-bypass networking (low-latency MPI communication).
- Cluster placement group for all 256 nodes in the same physical cluster.
- HPC-optimized instance types (hpc6a.48xlarge designed for HPC).
- Option B: Spread placement across AZs increases inter-node latency.
- Option C: Partition placement group doesn't provide the tight coupling needed.
- Option D: Fargate doesn't support EFA or MPI.

### Question 13
**Correct Answer: A, C**

Instance Refresh parameters:
- A: MinHealthyPercentage: 67% of 15 = 10.05, rounded to 10 minimum healthy instances.
- C: MaxHealthyPercentage: 134% of 15 = 20.1, rounded to 20 maximum instances during refresh.
- Together, these ensure 10-20 instances during the rolling update.
- Option B: 90% min healthy is stricter than needed.
- Option D: Manual process is error-prone and slow.
- Option E: Blue/Green doubles infrastructure temporarily.

### Question 14
**Correct Answer: A**

Lambda container image size limit:
- Maximum is 10 GB for container images.
- 15 GB exceeds this limit.
- The team must optimize the image or use ECS/EKS.
- Option B: 15 GB exceeds the 10 GB limit.
- Option C: Lambda does support container images.
- Option D: Lambda zip limit is 50 MB compressed / 250 MB uncompressed.

### Question 15
**Correct Answer: A**

.NET Framework and Graviton compatibility:
- .NET Framework 4.8 is Windows-only.
- Graviton instances only run Linux.
- Migration to .NET 6+ (cross-platform) is required first.
- Option B: Graviton does NOT support Windows.
- Option C: Wine is not a production-viable solution.
- Option D: Graviton does provide cost savings for supported workloads.

### Question 16
**Correct Answer: A**

Fargate task sizing:
- Total container needs: 2.25 vCPU, 4.5 GB memory.
- Fargate has fixed combinations: the nearest valid size is 4 vCPU / 8 GB.
- Container-level allocations are within the task-level limits.
- Option B: Fargate doesn't support arbitrary CPU/memory values.
- Option C: Sidecar resources ARE counted in the task total.
- Option D: Fargate requires task-level resource definitions.

### Question 17
**Correct Answer: A**

Batch with mixed compute:
- Spot for cost savings with retry strategy for short jobs.
- On-Demand fallback for reliability.
- Checkpointing for long-running jobs minimizes lost work.
- Option B: All On-Demand is most expensive.
- Option C: Highest bid doesn't prevent interruptions.
- Option D: Fargate for Batch doesn't support all job types (e.g., multi-node parallel).

### Question 18
**Correct Answer: A, B**

EKS pod security:
- A: IRSA provides pod-level IAM without node-level permissions.
- B: Pod Security Standards (PSS) with restricted profile prevents root and privilege escalation.
- Option C: Instance profile grants node-level permissions to all pods.
- Option D: Network Policies block metadata service but don't provide IAM scoping.
- Option E: PodSecurityPolicy is deprecated in Kubernetes 1.25+.

### Question 19
**Correct Answer: A**

Lifecycle hook for instance setup:
- Launch hook pauses instance before InService state.
- Lambda performs setup, calls CONTINUE on success or ABANDON on failure.
- ABANDON terminates the instance; ASG launches replacement.
- Option B: User Data runs asynchronously without lifecycle state control.
- Option C: Terminate hook is for shutdown, not launch.
- Option D: EventBridge doesn't provide lifecycle state control.

### Question 20
**Correct Answer: A**

ECS Service Connect:
- Built into ECS — minimal configuration.
- Provides service discovery, retries, timeouts, observability.
- No separate mesh components (virtual nodes, routers) to manage.
- For ECS-only workloads, simpler than App Mesh.
- Option B: App Mesh has more features but significantly more complexity.
- Option C: ALB between all 30 services creates a complex hub.
- Option D: Application-level retry implementation is maintenance-heavy.

### Question 21
**Correct Answer: A**

ECS secrets injection:
- `secrets` property in container definition references Secrets Manager ARNs.
- Values injected as environment variables at startup.
- Task execution role needs `secretsmanager:GetSecretValue`.
- No application code changes needed.
- Option B: Sidecar approach is more complex.
- Option C: S3 is not designed for secrets management.
- Option D: Embedding secrets in images is a security anti-pattern.

### Question 22
**Correct Answer: B**

For applications that cannot be modified:
- ALB sticky sessions (session affinity) route the same user to the same instance.
- Long deregistration delay keeps draining connections open during scale-in.
- Option A requires application modification (calling ASG API).
- Option C: Preventing scale-in wastes resources.
- Option D: Spot interruption handling is a separate concern.

### Question 23
**Correct Answer: A, B, C**

Multi-tenant EKS isolation:
- A: Namespace isolation with resource quotas and limit ranges.
- B: Network Policies restrict inter-namespace traffic.
- C: IRSA provides IAM-level isolation per tenant.
- Option D: Labels alone don't provide isolation.
- Option E: Separate clusters are most expensive and complex.
- Option F: No resource limits allow noisy neighbor problems.

### Question 24
**Correct Answer: A**

Preventing traffic to unready instances:
- Health check grace period: prevents ASG from terminating instances still starting.
- ALB health checks: only route traffic to healthy targets.
- Application health endpoint: returns healthy only when ready.
- Option B: Step scaling doesn't address the readiness issue.
- Option C: Cooldown doesn't prevent routing to unready instances.
- Option D: Scheduled scaling helps but doesn't solve the readiness issue.

### Question 25
**Correct Answer: A**

Batch multi-node parallel for HPC:
- Multi-node parallel jobs coordinate across multiple instances.
- EFA provides low-latency MPI communication.
- Cluster placement group ensures co-location.
- Option B: Fargate doesn't support multi-node parallel jobs.
- Option C: Separate jobs don't provide MPI coordination.
- Option D: Array jobs are for embarrassingly parallel work, not tightly coupled MPI.

### Question 26
**Correct Answer: A**

Container image optimization:
- Smaller image = faster pull = shorter cold start.
- Minimal base images (alpine, distroless) reduce size significantly.
- Multi-stage builds exclude build dependencies from the final image.
- Reduced provisioned concurrency (1-2 vs 5 for hourly invocations).
- Option B: Zip packages have their own size limits (250 MB uncompressed).
- Option C: More memory speeds execution but doesn't address image pull time.
- Option D: Reserved concurrency limits maximum, doesn't keep instances warm.

### Question 27
**Correct Answer: A**

ECS memory fragmentation:
- Total usable memory < theoretical maximum due to OS/agent overhead.
- 30 tasks × 2 GB = 60 GB spread across 10 instances.
- Remaining memory is fragmented — no single instance has 2 GB free.
- Solutions: managed scaling, binpacking placement strategy, or larger instances.
- Option B: ECS service task limits are configurable.
- Option C: No such instance-level memory limit.
- Option D: No default 50% container memory limit.

### Question 28
**Correct Answer: A**

Mixed instances policy for guaranteed capacity:
- `OnDemandBaseCapacity: 9` ensures 9 On-Demand instances (3 per AZ).
- `OnDemandPercentageAboveBaseCapacity: 0` makes all additional instances Spot.
- Reserved Instances cover the On-Demand base cost.
- Option B: Separate ASGs add management complexity.
- Option C: Spot-only can't guarantee minimum capacity.
- Option D: Capacity Reservations without ASG don't provide autoscaling.

### Question 29
**Correct Answer: A**

Cost comparison for steady-state:
- Fargate: ~$49.40/hour for 1,000 tasks.
- EC2 (m5.xlarge): 250 instances × $0.192 = $48.00/hour, cheaper before RI/SP discounts.
- With RIs or Savings Plans, EC2 cost drops by 40-72%.
- For steady 24/7 workloads, EC2 with commitments is significantly cheaper.
- Option B: Fargate is not always cheaper.
- Option C: There is a price difference.
- Option D: EC2 utilization can be very high with proper sizing.

### Question 30
**Correct Answer: A, B**

Pod autoscaling:
- A: HPA with metrics-server handles CPU-based scaling for web workloads.
- B: KEDA provides SQS-based scaling with scale-to-zero capability.
- Option C: VPA adjusts pod resource requests, doesn't scale on external metrics.
- Option D: App Mesh metrics are for observability, not autoscaling triggers.
- Option E: Container Insights collects metrics but doesn't provide HPA custom metrics.

### Question 31
**Correct Answer: D**

The correct answer depends on the concurrency model:
- Single-threaded: 50,000 / 10 = 5,000 tasks.
- Multi-threaded (10 concurrent): 50,000 / 100 = 500 tasks.
- The question doesn't specify the application's concurrency model.
- Without this information, the answer cannot be determined precisely.
- Option A provides calculations for both models but assumes concurrency.
- Option C assumes single-threaded only.

### Question 32
**Correct Answer: A**

Reducing Spot interruptions:
- `capacity-optimized` selects from pools with highest available capacity.
- `lowest-price` concentrates in the cheapest (most contested) pools.
- Adding more instance types (option C) also helps but the allocation strategy change has the biggest impact.
- Option B: Bid price doesn't prevent interruptions (Spot pricing model changed).
- Option C: Valid complementary strategy but not the primary fix.
- Option D: On-Demand eliminates savings.

### Question 33
**Correct Answer: A**

Fargate Spot for batch workloads:
- Up to 70% discount vs Fargate On-Demand.
- Encoding tasks are fault-tolerant (can be restarted).
- Short duration (30 min) minimizes interruption impact.
- Capacity provider strategy with Fargate fallback.
- Option B: Standard Fargate is more expensive.
- Option C: Reserved Instances for variable batch load wastes money.
- Option D: Lambda's 15-minute timeout is too short for 30-minute encoding.

### Question 34
**Correct Answer: A, B**

ASG default termination behavior:
- A: Selects the AZ with the most instances first (rebalancing).
- B: Within the AZ, terminates the instance with the oldest launch configuration/template version.
- Option C: Default doesn't target newest instances.
- Option D: Not random — follows a specific algorithm.
- Option E: CPU utilization is not part of the default policy.

### Question 35
**Correct Answer: A**

Windows containers on AWS:
- ECS EC2 launch type supports Windows container instances.
- EKS also supports Windows worker nodes.
- Windows Server Core and Windows Server with Desktop Experience AMIs available.
- Option B: Fargate has limited Windows container support (only certain task definitions).
- Option C: ECS does support Windows containers.
- Option D: Both ECS and EKS support Windows containers.

### Question 36
**Correct Answer: A**

ECS logging with awslogs driver:
- Built into ECS — no sidecar needed.
- Captures stdout/stderr from containers.
- Configurable log groups, regions, and stream prefixes.
- Includes container name and task ID in log stream names.
- Option B: Fluentd sidecar adds complexity and resource overhead.
- Option C: CloudWatch agent on instances is for EC2 metrics, not container logs.
- Option D: EFS for logs is over-engineered.

### Question 37
**Correct Answer: A**

Spot with checkpointing for ML training:
- ~70% Spot discount significantly reduces costs.
- 30-minute checkpoint interval limits lost work.
- Resume from checkpoint after interruption.
- Even with multiple interruptions, total cost is much lower than On-Demand.
- Option B: 1-year RI commitment for a single training job is wasteful.
- Option C: Graviton doesn't have GPU instances for ML training.
- Option D: SageMaker is an option but not the only one, and the question asks about general architecture.

### Question 38
**Correct Answer: A**

EKS node group segregation:
- Separate node groups for On-Demand (stable) and Spot (flexible) workloads.
- Node labels and nodeSelectors ensure pod placement.
- Taints/tolerations prevent unintended scheduling.
- Option B: Mixed node group doesn't guarantee database pods land on On-Demand.
- Option C: Fargate doesn't support StatefulSets with persistent volumes well.
- Option D: Separate clusters add management overhead.

### Question 39
**Correct Answer: A, C**

Migrating ECS EC2 to Fargate:
- A: Create a new Fargate service, gradually shift capacity.
- C: awsvpc network mode is required for Fargate; target group must use `ip` type.
- Option B: Launch type cannot be changed in-place on an existing service.
- Option D: Capacity provider changes don't automatically handle network mode requirements.
- Option E: Separate ALB is unnecessary — same target group works.

### Question 40
**Correct Answer: A**

Programmatic scale-in protection:
- Instance sets protection when processing starts.
- Removes protection when processing ends.
- ASG respects protection during scale-in decisions.
- Option B: 3600s cooldown prevents all scaling, not just problematic scale-in.
- Option C: SQS visibility timeout is for message processing, not ASG scale-in.
- Option D: Standby state is for maintenance, not job protection.

### Question 41
**Correct Answer: A**

Nitro system instances:
- All current-generation families (5th gen+): C5, M5, R5, T3, P4, G5, etc.
- Provides enhanced networking, EBS encryption, improved security.
- Older generations (C4, M4, T2) use Xen hypervisor.
- Option B: All current-gen instances use Nitro, not just bare-metal.
- Option C: Not limited to compute-optimized families.
- Option D: First-generation instances use PV/Xen.

### Question 42
**Correct Answer: A, B**

Fargate scaling considerations:
- A: ALBRequestCountPerTarget metric for request-based scaling.
- B: ECS Fargate minimum desired count is 0 starting 2024, but there's a startup time consideration. For cost optimization, use scheduled scaling to reduce to minimum during off-hours.
- Option C: Step Scaling works but target tracking is simpler for this case.
- Option D: Karpenter is for Kubernetes nodes, not Fargate tasks.
- Option E: Fargate scaling to zero is now supported but has cold start implications.

### Question 43
**Correct Answer: A**

Instance store with async replication:
- Instance store provides the lowest latency writes.
- Async replication to EBS/S3 provides durability.
- Recovery from backup on new instance launch.
- Option B: EBS io2 has higher latency than instance store NVMe.
- Option C: EBS Multi-Attach is limited and doesn't match instance store speed.
- Option D: S3 writes have much higher latency than local disk.

### Question 44
**Correct Answer: A**

Kubernetes deployment readiness and graceful shutdown:
- Readiness probes prevent routing to unready pods.
- preStop hook provides time for in-flight request completion.
- Kubernetes removes pod from endpoints before SIGTERM.
- Option B: More surge doesn't fix the draining issue.
- Option C: Manual verification doesn't scale.
- Option D: Grace period without readiness probes doesn't prevent traffic to unready pods.

### Question 45
**Correct Answer: A**

Lambda limits for data processing:
- Ephemeral storage: up to 10 GB (configurable since 2022).
- Timeout: 15 minutes maximum (10-minute processing fits).
- Memory: up to 10 GB (8 GB requirement fits).
- Main concerns: library dependencies and package size.
- Option B: Lambda doesn't have a 10 MB input file limit.
- Option C: /tmp is configurable up to 10 GB.
- Option D: Lambda memory maximum is 10 GB.

### Question 46
**Correct Answer: A**

Kubernetes Network Policies:
- Per-namespace policies control ingress/egress.
- namespaceSelector + podSelector for fine-grained rules.
- VPC CNI network policy support or Calico required.
- Option B: Security Groups for Pods don't provide namespace-level Kubernetes policy.
- Option C: NACLs are subnet-level, not pod-level.
- Option D: App Mesh provides mTLS but not network isolation at the level of Network Policies.

### Question 47
**Correct Answer: A**

Mixed instances policy calculation:
- Base: 4 On-Demand instances.
- Above base: 20 - 4 = 16 instances.
- On-Demand percentage above base: 25% of 16 = 4 more On-Demand.
- Total On-Demand: 4 + 4 = 8.
- Total Spot: 20 - 8 = 12.
- Option B: Doesn't account for percentage above base.
- Option C: Percentage is applied to above-base, not total.
- Option D: On-Demand base is not the total.

### Question 48
**Correct Answer: A**

Capacity provider strategy:
- Base tasks go to providers with base > 0: 2 tasks to FARGATE.
- Remaining 8 tasks distributed by weight ratio 1:3 = 2 FARGATE + 6 FARGATE_SPOT.
- Total: 4 FARGATE + 6 FARGATE_SPOT.
- Option B: Weight ratio applies to all tasks above base.
- Option C: Weights determine distribution, not equal split.
- Option D: Both providers receive tasks based on weight.

### Question 49
**Correct Answer: A, B**

Fargate auto scaling challenges:
- A: Target tracking scales incrementally — slow for 10x spikes.
- B: Fargate task quotas can be a hard limit during rapid scale-out.
- Option C: Fargate cold start is typically under 1 minute, not 15 minutes.
- Option D: ECS services can scale beyond original desired count.
- Option E: CloudWatch metric delay is 1 minute for standard, not 5 seconds.

### Question 50
**Correct Answer: A**

Linux capabilities on ECS:
- EC2 launch type supports adding Linux capabilities (NET_ADMIN, etc.).
- Fargate restricts capabilities for security — cannot add NET_ADMIN.
- Task definition's linuxParameters.capabilities.add field.
- Option B: Fargate doesn't support privileged mode or adding capabilities.
- Option C: ECS does support Linux capabilities on EC2.
- Option D: EC2 launch type allows kernel capabilities.

### Question 51
**Correct Answer: A**

Karpenter advantages:
- Faster provisioning via direct EC2 API (no ASG intermediate).
- Pod-aware scheduling for optimal instance selection.
- GPU-aware provisioning.
- Automatic consolidation.
- Option B: Application Auto Scaling doesn't manage EC2 nodes.
- Option C: Fargate doesn't support GPU workloads.
- Option D: Batch is a different compute paradigm.

### Question 52
**Correct Answer: A, E**

Actually, both A and E recommend ZGC. The best answer:
- E: ZGC provides sub-millisecond GC pauses regardless of heap size.
- A: Switching to memory-optimized instance + ZGC is a comprehensive solution.

**Correct Answer: A (for the comprehensive approach) and E (for the specific GC change)**

The most impactful single change is switching to ZGC (option E). Combined with appropriate instance sizing (option A), this solves the GC latency problem.
- Option B: Reducing heap increases GC frequency, which may worsen overall throughput.
- Option C: ARM64 doesn't inherently improve GC performance.
- Option D: Network latency is unrelated to GC pauses.

### Question 53
**Correct Answer: A**

ARM64 migration with native binaries:
- Native binaries must be compiled for the target architecture (ARM64).
- x86_64 binaries will cause runtime errors on ARM64.
- Lambda architecture setting must be changed.
- Option B: Lambda does NOT handle binary translation.
- Option C: Native binaries work on ARM64 if compiled for it.
- Option D: Container images are one option but not the only one.

### Question 54
**Correct Answer: A**

ALB idle timeout and WebSockets:
- ALB default idle timeout is 60 seconds.
- WebSocket connections that appear idle are dropped.
- Increasing idle timeout fixes the issue.
- Application heartbeats must be visible to the ALB as WebSocket frames.
- Option B: ECS doesn't recycle tasks automatically.
- Option C: NLB does support WebSockets (layer 4), but ALB also supports them.
- Option D: No 60-second WebSocket limit exists.

### Question 55
**Correct Answer: A, C**

EKS persistent storage:
- A: EBS CSI driver with io2 provides up to 64,000 IOPS.
- C: WaitForFirstConsumer prevents cross-AZ scheduling issues.
- Option B: EFS doesn't provide guaranteed IOPS at the 64,000 level.
- Option D: Instance store volumes are not persistent.
- Option E: S3 is object storage, not block storage for databases.

### Question 56
**Correct Answer: A**

Step Functions orchestrated ML pipeline:
- Different task definitions per stage optimize compute costs.
- Fargate Spot for fault-tolerant stages.
- EC2 with GPU for training stage.
- Step Functions manages state and output passing.
- Option B: GPU instance running for all stages wastes money during non-GPU stages.
- Option C: Single oversized task wastes resources.
- Option D: SageMaker is one option but not required — ECS can run ML workloads.

### Question 57
**Correct Answer: A**

Instance Refresh for AMI updates:
- Updates launch template, then rolls instances automatically.
- MinHealthyPercentage maintains availability.
- InstanceWarmup gives new instances time to initialize.
- Option B: Simultaneous termination causes downtime.
- Option C: Manual replacement is slow and error-prone.
- Option D: Separate ASG with Route 53 adds DNS propagation delay.

### Question 58
**Correct Answer: A**

Kinesis + Lambda parallelization:
- Default: 1 Lambda invocation per shard.
- ParallelizationFactor increases concurrent processing per shard (up to 10).
- Reduces iterator age by processing batches in parallel.
- Option B: 30-second execution time is within Lambda limits.
- Option C: More shards help but ParallelizationFactor is simpler.
- Option D: Memory increase helps but doesn't address parallelism.

### Question 59
**Correct Answer: A**

AWS-native observability stack:
- Container Insights for metrics and performance data.
- X-Ray for distributed tracing.
- Fluent Bit DaemonSet for log collection to CloudWatch Logs.
- Fully managed, minimal operational overhead.
- Option B: Self-managed stack has highest operational overhead.
- Option C: Managed Prometheus/Grafana is valid but more complex than option A.
- Option D: Container Insights alone doesn't provide distributed tracing.

### Question 60
**Correct Answer: A, B**

Maximizing Spot with guaranteed capacity:
- A: capacity-optimized reduces interruption risk.
- B: OnDemandBaseCapacity ensures minimum guaranteed instances.
- Option C: Restricting max price limits available Spot pools.
- Option D: 100% On-Demand above base eliminates Spot benefits.
- Option E: No On-Demand means no guaranteed capacity.

### Question 61
**Correct Answer: A**

ECS stopTimeout for graceful shutdown:
- ECS sends SIGTERM to PID 1 when stopping.
- stopTimeout defines the wait before SIGKILL.
- Application gets grace period to finish work.
- Option B: Shell script wrapper complicates PID 1 signal handling.
- Option C: essential: false means the container can stop without affecting the task.
- Option D: Manual SIGKILL doesn't integrate with ECS task lifecycle.

### Question 62
**Correct Answer: A**

Maximum EC2 discount:
- 3-year All Upfront provides the deepest discount (up to 72%).
- For steady-state 24/7 workloads, full commitment makes sense.
- Instance Savings Plan or RI with All Upfront for 3 years.
- Option B: 1-year provides less discount than 3-year.
- Option C: Spot doesn't guarantee capacity for production databases.
- Option D: Compute Savings Plan provides flexibility but slightly less discount than Instance SP.

### Question 63
**Correct Answer: A, B**

ECS task right-sizing:
- A: Container Insights provides CPU and memory utilization metrics for analysis.
- B: Compute Optimizer provides automated right-sizing recommendations.
- Option C: Testing to failure is risky and imprecise.
- Option D: Minimum task size may be insufficient.
- Option E: CloudTrail doesn't provide resource utilization data.

### Question 64
**Correct Answer: A**

Blue/Green with ALB weighted target groups:
- Two ASGs (blue/green) behind the same ALB.
- Weighted target groups enable canary testing.
- Instant rollback by adjusting weights.
- Both environments run simultaneously.
- Option B: In-place deployment doesn't maintain two environments.
- Option C: Route 53 weighted routing has DNS propagation delay.
- Option D: Simultaneous swap causes downtime.

### Question 65
**Correct Answer: A**

Fargate with aggressive auto scaling:
- Target tracking on request count for steady scaling.
- Step Scaling for sudden spikes.
- 5-second startup means fast scale-out responsiveness.
- Minimum 2 tasks for availability, pay-per-use for idle periods.
- Option B: Lambda is an option but may have cold start issues with container images.
- Option C: Fixed fleet wastes money during idle periods.
- Option D: Predictive scaling doesn't handle unpredictable traffic well.
