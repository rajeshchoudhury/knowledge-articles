# Container and Serverless Services Deep Dive: ECS, EKS, and Lambda

Containers and serverless computing are central to the DOP-C02 exam. You must understand deployment strategies, scaling mechanisms, networking, logging, and integration patterns across ECS, EKS, and Lambda.

---

## Amazon ECS (Elastic Container Service)

### Service Overview

Amazon ECS is a fully managed container orchestration service that supports running Docker containers on AWS. It handles scheduling, placement, and lifecycle management of containers.

### Launch Types

| Launch Type | Description | Use Case |
|-------------|-------------|----------|
| **EC2** | You manage the EC2 instances in the cluster. Full control over instance types, AMIs, and configuration. | GPU workloads, compliance requirements, high customization |
| **Fargate** | Serverless—AWS manages the infrastructure. You only define CPU/memory for tasks. | Most workloads—no infrastructure management |
| **External** (ECS Anywhere) | Run ECS tasks on on-premises or non-AWS infrastructure. Register external instances with the cluster. | Hybrid deployments |

### Task Definitions

A task definition is a blueprint for your application, specifying one or more containers:

**Container definitions** include:
- Image (ECR, Docker Hub, or other registries)
- CPU and memory (hard/soft limits)
- Port mappings
- Environment variables
- Health check configuration
- Logging configuration
- Dependency ordering (`dependsOn`)

**Networking modes:**

| Mode | Description | Exam Relevance |
|------|-------------|----------------|
| **awsvpc** | Each task gets its own ENI with a private IP. Required for Fargate. | Most commonly tested. Enables security groups at the task level. |
| **bridge** | Docker's default bridge networking. Port mapping required. EC2 only. | Dynamic port mapping with ALB. |
| **host** | Task uses the host's network namespace directly. EC2 only. | Maximum network performance, no port mapping overhead. |
| **none** | No external connectivity. | Batch processing with no network needs. |

**Task Role vs Execution Role:**

| Role | Purpose | Permissions |
|------|---------|-------------|
| **Task Role** | Permissions for the **application code** running inside the container | S3 access, DynamoDB access, SQS, etc. |
| **Execution Role** | Permissions for the **ECS agent** to manage the task | Pulling images from ECR, writing to CloudWatch Logs, retrieving secrets |

> **Key Points for the Exam:**
> - **Task Role** = what the application can do. **Execution Role** = what ECS needs to do to launch/manage the task.
> - If containers can't pull images from ECR, check the **execution role**.
> - If the application can't access S3, check the **task role**.
> - `awsvpc` mode is **mandatory** for Fargate.

### Services

An ECS service maintains a specified number of running task instances:

- **Desired count**: The number of tasks to maintain
- **Deployment configuration**: `minimumHealthyPercent` and `maximumPercent` control rolling update behavior
- **Deployment circuit breaker**: Automatically rolls back if tasks repeatedly fail to stabilize. Configured with `enable: true` and `rollback: true`.

**Deployment controllers:**

| Controller | Description |
|------------|-------------|
| **Rolling update** (ECS) | Default. Replaces tasks incrementally based on min/max healthy settings. |
| **Blue/Green** (CodeDeploy) | Creates a new task set, shifts traffic via ALB. Enables canary/linear traffic shifting. |
| **External** | Third-party controller manages deployments. |

### Service Discovery

ECS integrates with **AWS Cloud Map** for DNS-based service discovery:

- Each service registers instances in a Cloud Map namespace
- Other services discover endpoints via DNS queries (e.g., `backend.local`)
- Supports both A records (IP-based, `awsvpc` mode) and SRV records (port-based, `bridge` mode)

### Auto Scaling

**Service Auto Scaling** (task-level):
- **Target tracking**: Maintain a target value for a metric (e.g., CPU utilization at 70%)
- **Step scaling**: Scale based on CloudWatch alarm thresholds with step adjustments
- **Scheduled scaling**: Scale at specific times (e.g., increase capacity during business hours)

**ECS Cluster Capacity Providers** (infrastructure-level):

| Provider | Behavior |
|----------|----------|
| **FARGATE** | On-demand Fargate capacity |
| **FARGATE_SPOT** | Spot-priced Fargate capacity (can be interrupted) |
| **EC2 Auto Scaling group** | Managed scaling of EC2 instances based on task demand. Uses `CapacityProviderReservation` metric. |

**Capacity Provider strategy** assigns weights to providers:

```json
{
  "capacityProviderStrategy": [
    { "capacityProvider": "FARGATE", "weight": 1, "base": 2 },
    { "capacityProvider": "FARGATE_SPOT", "weight": 4 }
  ]
}
```

The `base` ensures a minimum number of tasks on the specified provider. `weight` determines the ratio of tasks distributed across providers.

> **Key Points for the Exam:**
> - The **capacity provider with `base`** guarantees a minimum number of tasks on reliable capacity (e.g., on-demand).
> - Weights determine proportional distribution of remaining tasks.
> - EC2 capacity provider uses **managed scaling** to automatically adjust the ASG desired count.

### ECS Exec

ECS Exec enables interactive debugging by starting an SSM Session Manager session into a running container:

- Requires SSM agent in the container (Fargate includes it automatically)
- The **task role** needs SSM permissions (`ssmmessages:*`)
- Enable `executeCommandConfiguration` on the cluster and `enableExecuteCommand` on the service

### Logging

**awslogs driver**: Sends container stdout/stderr to CloudWatch Logs. Configure `logConfiguration` in the task definition with log group, region, and stream prefix.

**FireLens**: A log router based on Fluentd or Fluent Bit that runs as a sidecar container:
- Routes logs to multiple destinations (CloudWatch, S3, Kinesis, Elasticsearch, third-party)
- Supports custom Fluent Bit configuration files
- More flexible than awslogs for complex routing and filtering

### Secrets in Task Definitions

ECS can inject secrets as environment variables or as files:

- **Secrets Manager**: Reference a secret ARN in `secrets` block. The execution role needs `secretsmanager:GetSecretValue`.
- **SSM Parameter Store**: Reference a parameter ARN. The execution role needs `ssm:GetParameters`.
- Secrets are resolved at **task launch time**—changing the secret value requires restarting the task.

---

## Amazon EKS (Elastic Kubernetes Service)

### Service Overview

Amazon EKS runs Kubernetes control plane across multiple Availability Zones. You manage worker nodes (or use Fargate). EKS is Kubernetes-conformant, so standard Kubernetes tools and manifests work.

### Control Plane and Worker Nodes

- **Control plane**: Managed by AWS. Runs the Kubernetes API server, etcd, scheduler, and controllers across 3 AZs.
- **Worker nodes**: Where your pods run. Three options:

| Node Type | Description |
|-----------|-------------|
| **Managed node groups** | AWS manages the EC2 instances. Automatic AMI updates, draining, and replacement. |
| **Self-managed nodes** | You manage EC2 instances. Full control over AMI, instance type, and configuration. |
| **Fargate** | Serverless pods. Each pod runs in its own isolated micro-VM. No node management. |

### Kubernetes Concepts for the Exam

You don't need deep Kubernetes expertise, but you must understand:

- **Pods**: Smallest deployable unit. One or more containers sharing network/storage.
- **Deployments**: Manage ReplicaSets for rolling updates and rollbacks.
- **Services**: Expose pods via ClusterIP (internal), NodePort, or LoadBalancer (creates an AWS ALB/NLB).
- **Namespaces**: Logical isolation within a cluster. Used for multi-tenancy and resource quotas.
- **RBAC**: Role-Based Access Control. Roles/ClusterRoles define permissions; RoleBindings/ClusterRoleBindings assign them to users/service accounts.

### EKS Add-ons

Managed add-ons simplify cluster operations:

| Add-on | Purpose |
|--------|---------|
| **VPC CNI** | Assigns VPC IP addresses to pods for native VPC networking |
| **CoreDNS** | Cluster DNS service |
| **kube-proxy** | Network proxy running on each node |
| **EBS CSI Driver** | Enables EBS volume attachment for persistent storage |

### IAM Roles for Service Accounts (IRSA)

IRSA maps Kubernetes service accounts to IAM roles, enabling fine-grained IAM permissions at the pod level:

1. Create an OIDC identity provider for the EKS cluster
2. Create an IAM role with a trust policy referencing the OIDC provider and the Kubernetes service account
3. Annotate the Kubernetes service account with the IAM role ARN
4. Pods using that service account automatically receive temporary IAM credentials

> **Key Points for the Exam:**
> - IRSA eliminates the need to use the EC2 instance profile for pod-level permissions. Without IRSA, all pods on a node share the node's IAM role.
> - The OIDC provider must be created for the cluster before IRSA works.
> - IRSA is the recommended approach for granting AWS permissions to Kubernetes workloads.

### Cluster Autoscaler vs Karpenter

| Feature | Cluster Autoscaler | Karpenter |
|---------|-------------------|-----------|
| Approach | Adjusts ASG desired count based on pending pods | Provisions nodes directly (no ASG needed) |
| Speed | Slower (relies on ASG scaling) | Faster (launches instances directly) |
| Flexibility | Limited to pre-defined node groups | Selects optimal instance types dynamically |
| Consolidation | No built-in | Consolidates workloads to reduce cost/waste |
| Recommendation | Legacy | Preferred for most EKS deployments |

### Logging

- **Control plane logging**: API server, audit, authenticator, controller manager, scheduler logs → CloudWatch Logs
- **Application logging**: Deploy Fluent Bit as a **DaemonSet** to collect and ship container logs to CloudWatch, S3, or Elasticsearch
- **Fargate logging**: Use Fluent Bit sidecar (built into Fargate pod infrastructure)

### EKS Blueprints

EKS Blueprints is a CDK/Terraform framework for provisioning EKS clusters with best-practice configurations, add-ons, and team management. It simplifies cluster creation for platform teams.

### Upgrades

EKS upgrades require a specific order:

1. **Control plane**: Update the EKS cluster version (AWS handles this, one minor version at a time)
2. **Managed node groups**: Update the node group to match the new control plane version (rolling replacement of nodes)
3. **Self-managed nodes**: Launch new nodes with the updated AMI, drain old nodes, and terminate them
4. **Add-ons**: Update add-on versions to match the new Kubernetes version

> **Key Points for the Exam:**
> - EKS supports upgrading **one minor version at a time** (e.g., 1.27 → 1.28, not 1.27 → 1.29).
> - Always upgrade the **control plane first**, then the worker nodes, then the add-ons.
> - Managed node groups automate the node upgrade process with rolling updates.

---

## AWS Lambda

### Service Overview

AWS Lambda runs code in response to events without provisioning servers. You pay only for compute time consumed. Lambda supports multiple runtimes (Node.js, Python, Java, Go, .NET, Ruby) and custom runtimes via Lambda Runtime API.

### Execution Model

| Concept | Description |
|---------|-------------|
| **Cold start** | New execution environment initialization. Includes downloading code, starting the runtime, and running init code. Adds latency (100ms to several seconds depending on runtime and package size). |
| **Warm start** | Reuses an existing execution environment. Only the handler function runs. Much faster. |
| **Provisioned concurrency** | Pre-initializes a specified number of execution environments to eliminate cold starts. |

> **Key Points for the Exam:**
> - **Provisioned concurrency** is the solution for latency-sensitive Lambda functions. It maintains warm environments ready to handle requests.
> - Code outside the handler function (global scope) runs during **initialization** and is reused across invocations—use this for database connections, SDK clients, and configuration loading.

### Deployment: Versions, Aliases, and Traffic Shifting

- **Versions**: Immutable snapshots of function code and configuration. `$LATEST` is the mutable working version.
- **Aliases**: Named pointers to specific versions (e.g., `prod` → version 5, `staging` → version 6).
- **Traffic shifting**: An alias can point to **two versions** with weighted routing for canary deployments.

Integration with **CodeDeploy** for managed traffic shifting:
- `LambdaCanary10Percent5Minutes`: 10% to new version for 5 minutes, then 100%
- `LambdaLinear10PercentEvery1Minute`: Shift 10% every minute
- `LambdaAllAtOnce`: Immediate full shift
- Pre/post traffic hooks (Lambda functions) validate the deployment

> **Key Points for the Exam:**
> - Lambda traffic shifting is done through **aliases**, not versions directly.
> - CodeDeploy manages the traffic shifting and can automatically roll back if CloudWatch alarms trigger.

### Event Source Mappings

Event source mappings poll event sources and invoke Lambda synchronously:

| Source | Behavior |
|--------|----------|
| **SQS** | Polls the queue, batches messages (up to 10), invokes Lambda. Supports batch window and scaling from 5 to 1000 concurrent batches. |
| **Kinesis** | Polls shards. One Lambda invocation per shard per batch. Supports parallel processing per shard (up to 10 concurrent batches per shard). |
| **DynamoDB Streams** | Similar to Kinesis—polls the stream, one invocation per shard. |
| **MSK/Kafka** | Polls Kafka topics. Supports SASL/SCRAM and mTLS authentication. |

**Error handling for event source mappings:**
- **BisectBatchOnFunctionError**: Split a failed batch in half and retry each half separately
- **MaximumRetryAttempts**: Number of retries before discarding the record
- **MaximumRecordAgeInSeconds**: Discard records older than this threshold
- **DestinationConfig.OnFailure**: Send failed records to an SQS queue or SNS topic

### Destinations

Lambda destinations route invocation results **asynchronously**:

- **On success**: SQS, SNS, Lambda, or EventBridge
- **On failure**: SQS, SNS, Lambda, or EventBridge

Destinations replace the older **dead-letter queue** (DLQ) mechanism, which only supports on-failure routing to SQS or SNS.

> **Key Points for the Exam:**
> - **Destinations** are preferred over DLQs for asynchronous invocations because they support both success and failure routing, and include more context in the payload.
> - DLQs are configured on the **Lambda function**. For event source mappings (SQS), the DLQ is configured on the **SQS source queue**, not the Lambda function.

### Layers

Lambda Layers are ZIP archives containing libraries, runtimes, or data shared across functions:

- Up to **5 layers** per function
- Layers are versioned and immutable
- Can be shared across accounts using resource-based policies
- Layers are extracted to `/opt` in the execution environment
- Common use: shared libraries, custom runtimes, common configuration

### VPC Connectivity

Lambda functions can connect to VPC resources:

- Specify VPC, subnets, and security groups in function configuration
- Lambda creates **Hyperplane ENIs** in your VPC subnets (shared across functions)
- VPC-connected functions **lose internet access** by default—use a **NAT Gateway** in a public subnet for internet access
- Alternatively, use **VPC endpoints** to access AWS services without internet

> **Key Points for the Exam:**
> - A Lambda function in a VPC **cannot reach the internet** unless there is a NAT Gateway (or NAT instance) in the VPC.
> - VPC configuration adds minimal cold start latency since the Hyperplane ENI improvement (previously significant).
> - To access both VPC resources and AWS services, use VPC endpoints for AWS services and NAT Gateway for external internet.

### Concurrency

| Type | Description |
|------|-------------|
| **Unreserved concurrency** | Shared pool across all functions in the account (default limit: 1000) |
| **Reserved concurrency** | Guarantees a set number of concurrent executions for a function. Also acts as a **maximum limit**—the function cannot exceed this value. |
| **Provisioned concurrency** | Pre-initializes execution environments. Eliminates cold starts. Can be combined with Application Auto Scaling for scheduled or target-tracking scaling. |
| **Burst concurrency** | Allows immediate scaling up to a burst limit (varies by region: 500-3000). After the burst, scales at 500 additional instances per minute. |

> **Key Points for the Exam:**
> - **Reserved concurrency** both guarantees AND limits concurrency. Setting it to 0 effectively **throttles** the function.
> - If a function is being throttled, check reserved concurrency settings and account-level concurrency limits.

### Lambda Extensions

Extensions augment Lambda with monitoring, observability, security, and governance tools:

- **Internal extensions**: Run within the Lambda process (e.g., APM agents)
- **External extensions**: Run as separate processes alongside the function (e.g., log collectors, security agents)
- Extensions can hook into the Lambda lifecycle: `Init`, `Invoke`, `Shutdown`

### Container Image Support

Lambda supports container images up to **10 GB**:

- Images must implement the Lambda Runtime API
- AWS provides base images for supported runtimes
- Alternative: use any base image with the Runtime Interface Client (RIC)
- Container images are stored in ECR

### Lambda@Edge vs CloudFront Functions

| Feature | Lambda@Edge | CloudFront Functions |
|---------|-------------|---------------------|
| Runtime | Node.js, Python | JavaScript only |
| Execution location | Regional edge caches | 200+ CloudFront edge locations |
| Max execution time | 5s (viewer) / 30s (origin) | < 1ms |
| Max memory | 128-10,240 MB | 2 MB |
| Network access | Yes | No |
| Triggers | Viewer request/response, Origin request/response | Viewer request/response only |
| Use case | Complex transformations, auth, API calls | Simple header manipulation, URL rewrites, cache key normalization |

> **Key Points for the Exam:**
> - Use **CloudFront Functions** for lightweight, high-volume operations (header manipulation, URL rewrites).
> - Use **Lambda@Edge** when you need network access, longer execution time, or origin triggers.

### Step Functions Integration

Lambda integrates deeply with Step Functions for orchestrating workflows:

- **Standard workflows**: Long-running (up to 1 year), exactly-once execution, audit history
- **Express workflows**: High-volume, short-duration (up to 5 minutes), at-least-once execution
- Integration patterns:
  - **Request-response** (default): Call Lambda, wait for response
  - **Wait for callback** (`.waitForTaskToken`): Pause workflow until external process calls back
  - **Run a job** (`.sync`): Wait for a long-running job to complete

---

## Cross-Service Integration Patterns

### ECS Blue/Green with CodeDeploy

1. CodePipeline source stage triggers on ECR image push
2. CodeBuild updates the ECS task definition with the new image URI
3. CodeDeploy performs blue/green deployment:
   - Creates new task set with updated task definition
   - Routes test listener traffic to green target group
   - Runs validation via `AfterAllowTestTraffic` hook
   - Shifts production traffic (canary/linear/all-at-once)
   - Terminates the original task set after a waiting period

### Lambda Canary Deployment

1. CodePipeline triggers CodeBuild to package and deploy new Lambda code
2. Lambda publishes a new version
3. CodeDeploy shifts traffic on the alias from the old version to the new version
4. Pre/post traffic hooks run validation Lambda functions
5. CloudWatch alarms monitor error rates; CodeDeploy rolls back if alarms fire

### EKS with CI/CD

1. CodePipeline source from CodeCommit
2. CodeBuild builds the container image, pushes to ECR
3. CodeBuild updates the Kubernetes manifest with the new image tag
4. CodeBuild runs `kubectl apply` or Helm upgrade to deploy to EKS
5. Alternative: Use Flux or ArgoCD for GitOps-based deployment

---

## Summary: Top Exam Scenarios

1. **ECS tasks can't pull images from ECR**: Check the **execution role** for ECR permissions
2. **Pods need AWS API access in EKS**: Use **IRSA** (IAM Roles for Service Accounts)
3. **Lambda cold start latency**: Use **provisioned concurrency**
4. **Lambda in VPC can't reach internet**: Add a **NAT Gateway**
5. **ECS blue/green deployment**: Requires **CodeDeploy** as the deployment controller with ALB and two target groups
6. **Lambda event source mapping failures**: Configure **bisect batch on error**, **max retry attempts**, and **on-failure destination**
7. **ECS container logs to multiple destinations**: Use **FireLens** (Fluent Bit sidecar)
8. **EKS cluster upgrade**: Control plane first → managed node groups → add-ons (one minor version at a time)
9. **Lambda traffic shifting**: Use **aliases** with weighted routing managed by **CodeDeploy**
10. **ECS tasks need to access Secrets Manager**: Add permission to the **execution role** and reference secrets in the task definition
