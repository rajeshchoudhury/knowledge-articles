# ECS, EKS & Container Services

## Table of Contents

1. [Docker Fundamentals](#docker-fundamentals)
2. [Amazon ECR (Elastic Container Registry)](#amazon-ecr)
3. [Amazon ECS (Elastic Container Service)](#amazon-ecs)
4. [ECS Task Definitions](#ecs-task-definitions)
5. [ECS Services](#ecs-services)
6. [ECS Auto Scaling](#ecs-auto-scaling)
7. [ECS Networking Modes](#ecs-networking-modes)
8. [AWS Fargate](#aws-fargate)
9. [Amazon EKS (Elastic Kubernetes Service)](#amazon-eks)
10. [EKS Networking](#eks-networking)
11. [AWS App Runner](#aws-app-runner)
12. [AWS Copilot CLI](#aws-copilot-cli)
13. [Container Insights](#container-insights)
14. [Exam Scenarios: When to Choose What](#exam-scenarios-when-to-choose-what)

---

## Docker Fundamentals

Docker is a platform for developing, shipping, and running applications in **containers** — lightweight, standalone, executable packages that include everything needed to run a piece of software.

### Key Docker Concepts

**Image:**
- A read-only template with instructions for creating a container
- Built from a **Dockerfile** — a text file with build instructions
- Stored in a **registry** (Docker Hub, Amazon ECR)
- Images are composed of **layers** (each instruction in the Dockerfile creates a layer)
- Layers are cached — only changed layers are rebuilt

**Container:**
- A running instance of an image
- Isolated process with its own filesystem, networking, and process space
- Ephemeral by default — data is lost when the container is removed
- Can mount **volumes** for persistent storage

**Dockerfile example:**
```dockerfile
FROM python:3.11-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
EXPOSE 8080
CMD ["python", "app.py"]
```

**Registry:**
- A storage and distribution system for Docker images
- **Docker Hub**: Public registry (default)
- **Amazon ECR**: AWS-managed private (and public) registry
- Images are identified by `registry/repository:tag`

### Why Containers for the Cloud?

- **Consistency**: Same image runs identically in dev, staging, and production
- **Isolation**: Each container is isolated from others
- **Efficiency**: Containers share the host OS kernel (lighter than VMs)
- **Portability**: Run on any system with a container runtime
- **Microservices**: Natural fit for decomposing applications into small, independent services

---

## Amazon ECR

Amazon Elastic Container Registry (ECR) is a fully managed Docker container registry that makes it easy to store, manage, and deploy container images.

### Private Repositories

- Images stored in your account, accessible only to authorized users/roles
- Each AWS account has a **default private registry** at: `{account_id}.dkr.ecr.{region}.amazonaws.com`
- Repositories within the registry: `{account_id}.dkr.ecr.{region}.amazonaws.com/{repo-name}:{tag}`
- Access controlled via **IAM policies** and **repository policies**
- Supports **tag immutability** (prevent overwriting tags)

### Public Repositories

- ECR Public Gallery: `public.ecr.aws/{alias}/{repo-name}`
- Publicly accessible — anyone can pull images
- Useful for open-source projects or publicly shared base images

### Image Scanning

**Basic scanning:**
- Uses the Common Vulnerabilities and Exposures (CVE) database
- Scans on push (configurable) or manual scan
- Free

**Enhanced scanning:**
- Powered by **Amazon Inspector**
- Continuous scanning (not just on push)
- Scans for OS vulnerabilities and programming language package vulnerabilities
- Additional cost

### Lifecycle Policies

Automate cleanup of unused or old images to reduce storage costs:

- **Rules** based on: image age, image count, tag status (tagged/untagged)
- Rules are evaluated in priority order
- Common policies:
  - Keep only the last N tagged images
  - Remove untagged images older than X days
  - Keep only images matching specific tag prefixes

### Cross-Region and Cross-Account Replication

**Cross-Region Replication:**
- Automatically replicate images to other AWS Regions
- Useful for multi-region deployments (reduced pull latency)
- Configure replication rules in the **registry settings** (not per-repository)

**Cross-Account Replication:**
- Replicate images to ECR registries in other AWS accounts
- Requires permissions in both source and destination accounts
- Uses **registry policy** in the destination account

**Pull-Through Cache:**
- Cache images from external public registries (Docker Hub, GitHub Container Registry, Quay)
- First pull fetches from upstream and caches in ECR
- Subsequent pulls are served from ECR cache
- Reduces pull rate limit issues with public registries

### Authentication

```bash
# Get an authentication token and authenticate Docker client
aws ecr get-login-password --region us-east-1 | \
  docker login --username AWS --password-stdin \
  123456789012.dkr.ecr.us-east-1.amazonaws.com
```

- Tokens are valid for **12 hours**
- IAM policies control who can push/pull images
- For ECS/EKS: the **task execution role** needs `ecr:GetAuthorizationToken` and `ecr:BatchGetImage` permissions

---

## Amazon ECS

Amazon Elastic Container Service (ECS) is a fully managed container orchestration service that makes it easy to run, stop, and manage containers on a cluster.

### Core Concepts

**Cluster:**
- A logical grouping of tasks or services
- Can contain a mix of EC2 instances and Fargate tasks
- Region-specific
- Default cluster is created automatically

**Task Definition:**
- A blueprint for your application (like a Dockerfile for ECS)
- Defines: containers, CPU/memory, ports, volumes, logging, IAM roles, networking mode
- Immutable and versioned (revisions: 1, 2, 3, ...)
- Can define multiple containers in one task definition (sidecar pattern)

**Task:**
- A running instance of a task definition
- Can be run standalone (one-off) or as part of a service
- Each task gets its own ephemeral storage (20-200 GB)

**Service:**
- Maintains a desired count of tasks
- Integrates with load balancers (ALB, NLB)
- Handles task replacement if a task fails
- Supports rolling updates and blue/green deployments

### Launch Types

**EC2 Launch Type:**
- You manage the EC2 instances in the cluster
- You control instance types, AMI, capacity
- ECS Agent runs on each instance (included in ECS-optimized AMI)
- You pay for the EC2 instances (even if underutilized)
- More control over infrastructure
- Instance role (EC2 instance profile) needed for ECS Agent

**Fargate Launch Type:**
- AWS manages the infrastructure (no EC2 instances to manage)
- You specify CPU and memory per task
- Tasks run in isolation
- Pay per task (vCPU + memory per second)
- No SSH access to underlying infrastructure
- Simpler operations, less control

**Choosing between them:**

| Factor | EC2 | Fargate |
|--------|-----|---------|
| Infrastructure management | You manage | AWS manages |
| Pricing model | Per instance | Per task |
| GPU support | Yes | No |
| Persistent storage | EBS, EFS, Instance Store | EFS, ephemeral (20 GB) |
| Windows containers | Yes | Yes (limited) |
| Spot capacity | Yes (Spot Instances) | Yes (Fargate Spot) |
| Startup time | Faster (instances already running) | 30-90 seconds |
| Best for | GPU, custom AMIs, cost optimization at scale | Simplicity, variable workloads |

---

## ECS Task Definitions

Task definitions are JSON documents that describe one or more containers (up to 10) that form your application.

### Key Parameters

**CPU and Memory:**

For **Fargate** tasks, CPU and memory are defined at the task level:

| CPU (vCPU) | Memory Options |
|------------|---------------|
| 0.25 vCPU | 0.5 GB, 1 GB, 2 GB |
| 0.5 vCPU | 1 GB to 4 GB (1 GB increments) |
| 1 vCPU | 2 GB to 8 GB (1 GB increments) |
| 2 vCPU | 4 GB to 16 GB (1 GB increments) |
| 4 vCPU | 8 GB to 30 GB (1 GB increments) |
| 8 vCPU | 16 GB to 60 GB (4 GB increments) |
| 16 vCPU | 32 GB to 120 GB (8 GB increments) |

For **EC2** tasks, CPU and memory can be defined at the container level or task level.

**Port Mappings:**
- Map container ports to host ports
- With **awsvpc** networking: container port = host port (each task has its own ENI)
- With **bridge** networking: you can use dynamic port mapping (host port = 0, ALB handles mapping)

**Volumes:**

| Volume Type | Persistence | Shared Between Containers | Notes |
|-------------|------------|--------------------------|-------|
| Docker volumes | Task lifetime | Yes (in same task) | Default |
| Bind mounts | Task lifetime | Yes (in same task) | Mount host paths |
| EFS | Persistent | Yes (across tasks) | Requires VPC networking |
| EBS | Persistent | No | Fargate + EC2 support |

**Logging:**
- **awslogs** driver: Send logs to CloudWatch Logs (most common)
- **splunk**: Send to Splunk
- **fluentd** / **firelens**: Flexible log routing (to S3, Elasticsearch, Datadog, etc.)
- FireLens uses Fluentd or Fluent Bit as a sidecar container for log routing

### IAM Roles

**Task Execution Role:**
- Used by the **ECS Agent** (not your application)
- Permissions to:
  - Pull container images from ECR (`ecr:GetAuthorizationToken`, `ecr:BatchGetImage`)
  - Send logs to CloudWatch (`logs:CreateLogStream`, `logs:PutLogEvents`)
  - Retrieve secrets from Secrets Manager or SSM Parameter Store
- AWS provides a managed policy: `AmazonECSTaskExecutionRolePolicy`

**Task Role:**
- Used by the **containers in the task** (your application code)
- Defines what AWS services/resources your application can access
- Example: If your app reads from S3 and writes to DynamoDB, the task role needs those permissions
- Each task definition can have a different task role

**Critical distinction**: Task Execution Role = what ECS infrastructure needs. Task Role = what your app needs.

### Environment Variables & Secrets

- **Plain text**: Defined directly in the task definition
- **From SSM Parameter Store**: Reference a parameter by ARN (uses task execution role)
- **From Secrets Manager**: Reference a secret by ARN (uses task execution role)
- Secrets are injected as environment variables at container startup

```json
{
  "secrets": [
    {
      "name": "DB_PASSWORD",
      "valueFrom": "arn:aws:secretsmanager:us-east-1:123456789:secret:mydb-password"
    },
    {
      "name": "API_KEY",
      "valueFrom": "arn:aws:ssm:us-east-1:123456789:parameter/myapp/api-key"
    }
  ]
}
```

---

## ECS Services

An ECS Service maintains a desired number of tasks and handles deployment, scaling, and load balancing.

### Deployment Types

**Rolling Update (default):**
- Gradually replaces old tasks with new tasks
- Configurable parameters:
  - **minimumHealthyPercent**: Minimum percentage of desired tasks that must remain running (default 100%)
  - **maximumPercent**: Maximum percentage of desired tasks (running + pending) allowed (default 200%)
- Example: desired=4, min=50%, max=200% → ECS can stop 2 old tasks and start 4 new tasks simultaneously

**Blue/Green Deployment (with CodeDeploy):**
- Two target groups: Blue (current) and Green (new)
- CodeDeploy shifts traffic from Blue to Green
- Options:
  - **Canary**: Shift a percentage of traffic first, then shift all
  - **Linear**: Shift traffic in equal increments
  - **All-at-once**: Shift 100% immediately
- Supports automatic rollback based on CloudWatch alarms
- Requires Application Load Balancer (ALB)

**External Deployment:**
- Use a third-party deployment controller
- Full control over the deployment process

### Circuit Breaker

ECS deployment circuit breaker automatically stops deployments that are failing.

- If new tasks repeatedly fail to reach a healthy state, the deployment is marked as failed
- Optional **rollback**: Automatically roll back to the last successful deployment
- Prevents bad deployments from affecting the entire service

### Load Balancer Integration

**Application Load Balancer (ALB):**
- Recommended for most HTTP/HTTPS applications
- Supports dynamic port mapping (bridge networking)
- Path-based and host-based routing
- Health checks at the target group level

**Network Load Balancer (NLB):**
- For TCP/UDP traffic or extreme performance needs
- Static IP addresses / Elastic IPs
- Lower latency than ALB

**Configuration:**
- ECS registers tasks as targets in ALB/NLB target groups
- For **awsvpc** mode: targets are registered by IP address
- For **bridge** mode: targets are registered by instance ID + port (dynamic port mapping)
- Health check grace period: delay before health checks start (allows time for startup)

### Service Discovery (AWS Cloud Map)

ECS integrates with **AWS Cloud Map** for service discovery:
- Services register automatically with a DNS namespace
- Other services can find them by DNS name
- Supports both DNS-based and API-based discovery
- Creates SRV or A records in Route 53
- Useful for service-to-service communication without a load balancer

---

## ECS Auto Scaling

### Service Auto Scaling

Automatically adjusts the number of tasks (desired count) in an ECS service.

**Scaling policies:**

**Target Tracking:**
- Set a target value for a metric
- ECS adjusts task count to maintain the target
- Metrics: `ECSServiceAverageCPUUtilization`, `ECSServiceAverageMemoryUtilization`, `ALBRequestCountPerTarget`

**Step Scaling:**
- Define scaling adjustments based on CloudWatch alarm thresholds
- More fine-grained control

**Scheduled Scaling:**
- Scale based on a schedule
- Adjust min/max/desired capacity at specific times

### Cluster Auto Scaling (Capacity Providers)

Capacity Providers manage the infrastructure capacity for ECS tasks.

**For EC2 launch type:**
- **Auto Scaling Group Capacity Provider**: Links an ASG to ECS
- **Managed scaling**: ECS automatically scales the ASG based on the tasks' resource needs
- **Managed termination protection**: Prevents scale-in from terminating instances running tasks
- Target capacity: Percentage of cluster resources to keep reserved (e.g., 100% means no spare capacity)

**For Fargate:**
- **FARGATE** capacity provider: On-demand Fargate tasks
- **FARGATE_SPOT** capacity provider: Spot-priced Fargate tasks (up to 70% savings)
- Can mix both in a **capacity provider strategy** (e.g., base=2 on FARGATE, burst on FARGATE_SPOT)

**Capacity Provider Strategy example:**
```json
{
  "capacityProviderStrategy": [
    {
      "capacityProvider": "FARGATE",
      "base": 2,
      "weight": 1
    },
    {
      "capacityProvider": "FARGATE_SPOT",
      "base": 0,
      "weight": 3
    }
  ]
}
```
This runs at least 2 tasks on regular Fargate and spreads additional tasks 75% on Spot, 25% on regular Fargate.

---

## ECS Networking Modes

### awsvpc Mode

- Each task gets its own **Elastic Network Interface (ENI)** with a private IP address
- Tasks behave like EC2 instances from a networking perspective
- Full support for security groups at the task level
- **Required** for Fargate
- Recommended for EC2 launch type as well
- Limitation on EC2: Number of ENIs is limited by instance type (use ENI trunking to increase)
- ALB targets registered by **IP address**

### bridge Mode (EC2 only)

- Uses Docker's built-in virtual bridge network
- Containers share the host's network via port mapping
- Supports **dynamic port mapping** with ALB (host port = 0)
- Multiple tasks of the same definition can run on one host (different host ports)
- Security groups apply at the **instance level** (not task level)
- ALB targets registered by **instance ID + port**

### host Mode (EC2 only)

- Container ports map directly to host ports (no Docker networking layer)
- Best network performance (no NAT/bridge overhead)
- Only one task per host per port (port conflicts)
- Not recommended for most use cases

### none Mode

- Task has no external network connectivity
- Only loopback interface available
- Useful for tasks that don't need network access (batch processing with local data)

### Networking Mode Comparison

| Feature | awsvpc | bridge | host | none |
|---------|--------|--------|------|------|
| Task-level security groups | Yes | No | No | N/A |
| Task-level ENI | Yes | No | No | No |
| Dynamic port mapping | N/A | Yes | No | N/A |
| Multiple tasks/host/port | Yes | Yes | No | N/A |
| Fargate support | Yes | No | No | No |
| Performance | Good | Good | Best | N/A |
| Exam relevance | **High** | Medium | Low | Low |

---

## AWS Fargate

Fargate is the **serverless** compute engine for containers — runs containers without managing EC2 instances.

### Key Features

- No instances to manage, patch, or scale
- Per-task billing (vCPU + memory per second, minimum 1 minute)
- Isolation: Each task runs in its own kernel runtime environment (micro-VM)
- Supports ECS and EKS
- OS: Linux and Windows containers (Linux more common)

### Platform Versions

Fargate uses **platform versions** to manage the runtime environment:
- **Linux**: 1.4.0 (latest), 1.3.0, etc. Use `LATEST` for the most current.
- Each version includes: runtime, kernel version, Docker version
- New features are tied to platform versions (e.g., EFS support added in 1.4.0)
- Platform versions are updated by AWS (not by you)

### Fargate Spot

- Run Fargate tasks at up to **70% discount** compared to regular Fargate
- Tasks can be interrupted with a **30-second warning** when AWS needs the capacity
- Suitable for: fault-tolerant, stateless, interruptible workloads
- Configure via capacity provider strategy (mix Spot and regular Fargate)

### Sizing

**Fargate task sizes** are predefined combinations of CPU and memory (see the table in ECS Task Definitions section).

**Ephemeral storage:**
- Default: 20 GB per task
- Configurable: up to 200 GB
- Shared among all containers in the task
- Lifecycle: task lifetime only

**Persistent storage with Fargate:**
- **EFS**: Mount EFS file systems for shared, persistent storage across tasks
- **EBS**: Attach EBS volumes (added in 2023) for task-specific persistent storage

---

## Amazon EKS

Amazon Elastic Kubernetes Service (EKS) is a managed service that makes it easy to run **Kubernetes** on AWS.

### Kubernetes Basics

Kubernetes (K8s) is an open-source container orchestration platform:
- **Cluster**: A set of nodes that run containerized applications
- **Node**: A worker machine (EC2 instance or Fargate pod)
- **Pod**: The smallest deployable unit — one or more containers
- **Service**: Exposes pods to network traffic (ClusterIP, NodePort, LoadBalancer)
- **Deployment**: Manages rolling updates and scaling of pods
- **Namespace**: Logical isolation within a cluster

### EKS Architecture

**Control Plane (managed by AWS):**
- API server, etcd (cluster state store), scheduler, controller manager
- Runs across multiple AZs for high availability
- You don't manage or see the control plane infrastructure

**Data Plane (your workloads):**
- Worker nodes where your pods run
- Three options for compute:
  1. **Managed Node Groups**: AWS manages EC2 instances (AMI updates, patching, scaling)
  2. **Self-Managed Nodes**: You manage EC2 instances (full control)
  3. **Fargate Profiles**: Serverless pods on Fargate

### Managed Node Groups

- AWS creates and manages EC2 instances in an Auto Scaling Group
- Automatic AMI updates and patching (configurable)
- Support for On-Demand and Spot instances
- Integration with Cluster Autoscaler and Karpenter
- Uses EKS-optimized AMI (Amazon Linux 2, Bottlerocket, Windows)
- Graceful node updates (cordon, drain, replace)

### Fargate Profiles

- Define which pods run on Fargate using **selectors** (namespace, labels)
- Each pod runs in its own micro-VM (isolation)
- No node management
- Limitations:
  - No DaemonSets
  - No privileged containers
  - No GPU
  - No persistent volumes (use EFS)
  - Limited to 4 vCPU and 30 GB memory per pod

### EKS Add-ons

Managed software that provides additional Kubernetes capabilities:
- **CoreDNS**: Cluster DNS resolution
- **kube-proxy**: Network proxy on each node
- **VPC CNI**: Networking for pods (assigns VPC IP addresses)
- **Amazon EBS CSI Driver**: Persistent block storage
- **Amazon EFS CSI Driver**: Persistent file storage
- **AWS Load Balancer Controller**: Provisions ALB/NLB for Kubernetes services/ingresses
- **Cluster Autoscaler** / **Karpenter**: Node scaling

### EKS Anywhere

- Run EKS on your own on-premises infrastructure
- Uses VMware vSphere or bare metal
- Same Kubernetes tooling as EKS in the cloud
- Connected (to AWS) or disconnected operation

### EKS Distro (EKS-D)

- The same open-source Kubernetes distribution used by EKS
- Run it yourself anywhere (on-premises, other clouds)
- Self-managed (no AWS management)

---

## EKS Networking

### VPC CNI (Container Network Interface)

- The **Amazon VPC CNI plugin** assigns VPC IP addresses directly to pods
- Each pod gets a real VPC IP address (routable within the VPC)
- No overlay network (unlike default Kubernetes networking)
- Pods can communicate with any resource in the VPC using VPC routing
- ENIs are attached to worker nodes; IPs from the ENI's subnet are assigned to pods
- Maximum pods per node is limited by the number of ENIs and IPs per ENI

**IP address planning:**
- Pods consume VPC CIDR IP addresses
- Large clusters can exhaust subnet IP space
- Solutions: larger subnets, custom networking (pods in separate subnets), prefix delegation (assign /28 prefixes instead of individual IPs)

### Service Mesh

**AWS App Mesh:**
- Managed service mesh based on Envoy proxy
- Provides: traffic management, observability, mTLS
- Works with ECS, EKS, and EC2
- Concepts: virtual nodes, virtual services, virtual routers, routes

**Kubernetes native options:**
- Istio
- Linkerd
- Both run on EKS as third-party add-ons

### Load Balancing for EKS

**AWS Load Balancer Controller:**
- Creates ALB for Kubernetes **Ingress** resources
- Creates NLB for Kubernetes **Service** (type: LoadBalancer) resources
- Supports instance mode (traffic to NodePort) and IP mode (traffic directly to pods)
- IP mode requires VPC CNI (pods have VPC IPs)

---

## AWS App Runner

AWS App Runner is a fully managed service for deploying web applications and APIs — the simplest way to run containers on AWS.

### Source Options

**Container image from ECR:**
- Point to an ECR image
- App Runner pulls and runs it

**Source code from GitHub:**
- App Runner builds and deploys automatically
- Supports: Python, Node.js, Java, .NET, Go, Ruby, PHP
- Automatic rebuilds on code push (continuous deployment)

### Key Features

- **Automatic scaling**: Scales based on incoming traffic (including scale to zero-ish: minimum 1 instance by default, or provisioned concurrency)
- **Load balancing**: Built-in (no ALB/NLB to configure)
- **TLS/HTTPS**: Automatic TLS termination
- **Custom domains**: Add your own domain with automatic certificate management
- **Health checks**: Configurable health check paths
- **Auto-deployment**: Triggered by ECR image push or GitHub push
- **Observability**: CloudWatch metrics and logs, X-Ray tracing

### VPC Connector

- By default, App Runner services can access the public internet but NOT your VPC
- Use a **VPC Connector** to connect to resources in your VPC (RDS, ElastiCache, etc.)
- Specify subnets and security groups
- Outbound traffic flows through the VPC (to reach VPC resources)
- Inbound traffic still comes through App Runner's public endpoint

### App Runner vs Fargate vs Beanstalk

| Feature | App Runner | Fargate (ECS) | Elastic Beanstalk |
|---------|-----------|---------------|-------------------|
| Complexity | Simplest | Medium | Medium |
| Container support | Yes | Yes | Yes (Docker platform) |
| Source code deployment | Yes (GitHub) | No | Yes |
| Scaling | Automatic | Configurable auto-scaling | Configurable |
| Networking | Simple (VPC connector) | Full VPC control | Full VPC control |
| Customization | Limited | High | High |
| Pricing | Per vCPU/memory + requests | Per vCPU/memory | EC2/Fargate underneath |
| Best for | Simple web apps/APIs | Complex containerized apps | Full platform management |

---

## AWS Copilot CLI

AWS Copilot is a CLI tool that simplifies building, releasing, and operating containerized applications on ECS and Fargate.

### Key Concepts

- **Application**: A collection of related services and environments
- **Service**: A long-running container (load balanced, backend, or worker)
- **Job**: A scheduled or one-off task
- **Environment**: A deployment stage (test, staging, production)
- **Pipeline**: CI/CD pipeline for automated deployments

### Common Commands

```bash
copilot init           # Initialize a new application
copilot env init       # Create a new environment
copilot svc init       # Create a new service
copilot svc deploy     # Deploy a service
copilot job init       # Create a scheduled job
copilot pipeline init  # Set up a CI/CD pipeline
copilot svc status     # Check service status
copilot svc logs       # View service logs
```

### Service Types

- **Load Balanced Web Service**: Behind an ALB, internet-facing
- **Backend Service**: Internal service (service discovery, no public endpoint)
- **Worker Service**: Processes messages from an SQS queue
- **Request-Driven Web Service**: Runs on App Runner

---

## Container Insights

Amazon CloudWatch Container Insights collects, aggregates, and summarizes metrics and logs from containerized applications.

### Metrics Collected

- **Cluster level**: CPU, memory, network, storage utilization
- **Service level**: Task count, CPU/memory per service
- **Task level**: CPU/memory per task
- **Container level**: CPU/memory per container

### Setup

**For ECS:**
- Enable Container Insights at the cluster level (or account level for all new clusters)
- Uses the CloudWatch agent (deployed as a daemon task on EC2, or automatically on Fargate)

**For EKS:**
- Deploy the **CloudWatch agent** and **Fluent Bit** as DaemonSets
- Or use the **CloudWatch Observability add-on**
- Captures pod, node, and cluster-level metrics

### Enhanced Observability

- **Performance log events**: Detailed performance data in CloudWatch Logs
- **Prometheus metrics**: Collect and monitor Prometheus metrics from containerized workloads
- **Application Insights**: Automatic dashboards for common application patterns

---

## Exam Scenarios: When to Choose What

### ECS vs EKS

| Factor | Choose ECS | Choose EKS |
|--------|-----------|-----------|
| Kubernetes experience | No/limited | Yes, team knows K8s |
| Multi-cloud / portability | Not needed | Yes (K8s is portable) |
| Ecosystem | AWS-native tools | Rich K8s ecosystem (Helm, Istio, etc.) |
| Complexity tolerance | Want simplicity | Accept complexity for power |
| Community support | AWS docs | Huge K8s community |
| Service mesh | App Mesh | App Mesh, Istio, Linkerd |
| On-premises | ECS Anywhere | EKS Anywhere |
| Cost | Lower management overhead | Higher (control plane: $0.10/hour) |

### ECS/EKS vs Lambda

| Factor | Choose Containers (ECS/EKS) | Choose Lambda |
|--------|---------------------------|---------------|
| Execution duration | >15 minutes | <15 minutes |
| Startup time tolerance | Seconds OK | Needs sub-second (with provisioned concurrency) |
| Consistent traffic | Yes | Spiky/event-driven |
| Memory needs | >10 GB | ≤10 GB |
| GPU needs | Yes (EC2 launch type) | No |
| Docker investment | Already containerized | Functions/small tasks |
| Operational overhead | Some | Minimal |

### Fargate vs EC2 Launch Type

| Factor | Choose Fargate | Choose EC2 |
|--------|---------------|-----------|
| Server management | Want serverless | Fine managing instances |
| GPU | Not needed | Needed |
| Spot pricing model | Fargate Spot (70% off) | EC2 Spot (90% off) |
| Windows containers | Limited support | Full support |
| Persistent storage | EFS, limited EBS | Any (EBS, Instance Store, EFS) |
| Cost at scale | Can be expensive | More cost-effective with RIs |
| Compliance | Good (isolation) | Full control |

### When to Choose Beanstalk Over ECS

- Developer doesn't want to think about containers or orchestration
- Traditional web application (not microservices)
- Need managed platform (Apache, Nginx, IIS, Tomcat, Docker)
- Rapid deployment without infrastructure knowledge
- Small team, fewer operational resources

### Common Exam Scenarios

**Scenario 1: Migrate a monolithic app to containers**
**Q:** Company wants to containerize a Java application with minimal operational overhead.
**A:** Fargate on ECS with ALB. Use ECR for images. No servers to manage.

**Scenario 2: Run Kubernetes workloads**
**Q:** Company has existing Kubernetes manifests and Helm charts. Need to run on AWS.
**A:** EKS with managed node groups. Existing K8s tooling works natively.

**Scenario 3: Simplest container deployment**
**Q:** Developer wants to deploy a container from a GitHub repo with zero infrastructure management.
**A:** App Runner. Auto-builds from source, auto-scales, no infrastructure config.

**Scenario 4: Cost-optimized batch container processing**
**Q:** Nightly batch job in containers. Can tolerate interruptions.
**A:** ECS on Fargate Spot, or ECS on EC2 Spot instances.

**Scenario 5: Container logs to S3**
**Q:** Need to route container logs to S3 and Elasticsearch simultaneously.
**A:** ECS with FireLens (Fluent Bit sidecar) for flexible log routing to multiple destinations.

**Scenario 6: Secrets injection**
**Q:** Containers need database credentials that rotate automatically.
**A:** Store credentials in Secrets Manager. Reference them in the ECS task definition. Task execution role grants access to the secret.

**Scenario 7: Cross-region container deployment**
**Q:** Application runs in us-east-1 and needs to deploy to eu-west-1.
**A:** ECR cross-region replication to replicate images. Deploy ECS services in both regions.

**Scenario 8: Multi-container sidecar**
**Q:** Application container needs an Envoy proxy for service mesh.
**A:** Define both containers in the same ECS task definition. Use App Mesh with Envoy sidecar injection.

### Key Exam Tips

1. **Fargate** = serverless containers. No instances to manage. Exam default for simplicity.
2. **ECS** = AWS-native container orchestration. Simpler than EKS.
3. **EKS** = Kubernetes on AWS. Choose when K8s expertise/portability is needed.
4. **App Runner** = simplest option. When the question emphasizes "minimal operational overhead" for a web app.
5. **Task Execution Role** = ECS infrastructure needs (pull images, write logs). **Task Role** = your app's AWS permissions.
6. **awsvpc** networking mode = task-level security groups + Fargate requirement.
7. **Capacity Providers** = how ECS manages EC2 Auto Scaling and Fargate Spot.
8. **ECR lifecycle policies** = clean up old/untagged images automatically.
9. **FireLens** (Fluent Bit/Fluentd) = flexible log routing from ECS containers.
10. **Service Discovery (Cloud Map)** = DNS-based discovery for service-to-service communication.

---

*Previous: [← Lambda & Serverless](08-lambda-serverless.md) | Next: [Elastic Beanstalk & App Runner →](10-beanstalk-apprunner.md)*
