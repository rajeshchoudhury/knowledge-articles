# 06 — Containers & Orchestration on AWS

## Complete Guide for AWS Solutions Architect Professional (SAP-C02)

---

## Table of Contents

1. [Docker Fundamentals for AWS](#1-docker-fundamentals-for-aws)
2. [Amazon ECR](#2-amazon-ecr)
3. [Amazon ECS Deep Dive](#3-amazon-ecs-deep-dive)
4. [ECS Launch Types](#4-ecs-launch-types)
5. [Amazon EKS Deep Dive](#5-amazon-eks-deep-dive)
6. [AWS Fargate Deep Dive](#6-aws-fargate-deep-dive)
7. [AWS App Runner](#7-aws-app-runner)
8. [Container Networking](#8-container-networking)
9. [Container Storage](#9-container-storage)
10. [Container Security](#10-container-security)
11. [Container Observability](#11-container-observability)
12. [Container Patterns](#12-container-patterns)
13. [Migration to Containers Strategy](#13-migration-to-containers-strategy)
14. [ECS vs EKS Decision Framework](#14-ecs-vs-eks-decision-framework)
15. [Exam Scenarios](#15-exam-scenarios)

---

## 1. Docker Fundamentals for AWS

### What the Exam Expects

You won't be tested on Docker commands, but you must understand images, layers, registries, Dockerfiles, and how containers differ from VMs. The exam tests your ability to architect solutions **using** containers, not build them.

### Core Concepts

```
┌─────────────────────────────────────────────┐
│              Host OS (Amazon Linux 2)        │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐   │
│  │Container │  │Container │  │Container │   │
│  │  App A   │  │  App B   │  │  App C   │   │
│  │ Libraries│  │ Libraries│  │ Libraries│   │
│  └──────────┘  └──────────┘  └──────────┘   │
│  ┌──────────────────────────────────────┐    │
│  │         Docker Engine / containerd   │    │
│  └──────────────────────────────────────┘    │
│  ┌──────────────────────────────────────┐    │
│  │         Host Kernel (shared)         │    │
│  └──────────────────────────────────────┘    │
└─────────────────────────────────────────────┘
```

| Concept | Description |
|---------|------------|
| **Image** | Immutable template built from a Dockerfile; stored in a registry (ECR). Composed of read-only layers. |
| **Container** | Running instance of an image with a thin writable layer on top. |
| **Layer** | Each instruction in a Dockerfile creates a layer. Layers are cached and shared across images. |
| **Registry** | Storage and distribution system for images (ECR, Docker Hub). |
| **Tag** | Human-readable alias for a specific image digest (`myapp:v1.2`). |
| **Digest** | SHA-256 hash that uniquely identifies an image (`sha256:abc123…`). Immutable. |

### Image Lifecycle on AWS

```
Developer → Build Image → Push to ECR → Pull from ECR → Run on ECS/EKS/Fargate
              (docker build)  (docker push)  (docker pull)
```

### Multi-Stage Builds (Exam Relevance)

Multi-stage builds reduce image size, which reduces pull time and attack surface — both relevant to architecture decisions:

```dockerfile
# Build stage
FROM golang:1.21 AS builder
WORKDIR /app
COPY . .
RUN CGO_ENABLED=0 go build -o myapp

# Runtime stage — minimal image
FROM alpine:3.18
COPY --from=builder /app/myapp /myapp
ENTRYPOINT ["/myapp"]
```

> **Exam Tip:** When a question mentions reducing container startup time or improving security posture, consider smaller base images (Alpine, distroless) and multi-stage builds.

---

## 2. Amazon ECR

### Architecture Overview

```
┌──────────────────────────────────────────────────┐
│                  Amazon ECR                       │
│  ┌────────────┐  ┌────────────┐  ┌────────────┐  │
│  │  Private    │  │  Private    │  │  Public     │  │
│  │  Registry   │  │  Registry   │  │  Registry   │  │
│  │  (Acct A)   │  │  (Acct B)   │  │  (gallery)  │  │
│  │             │  │             │  │             │  │
│  │ ┌────────┐  │  │ ┌────────┐  │  │ ┌────────┐  │  │
│  │ │ Repo 1 │  │  │ │ Repo 1 │  │  │ │ Repo 1 │  │  │
│  │ │ :v1    │  │  │ │ :v1    │  │  │ │ :latest│  │  │
│  │ │ :v2    │  │  │ │ :v2    │  │  │ │ :v1    │  │  │
│  │ └────────┘  │  │ └────────┘  │  │ └────────┘  │  │
│  └────────────┘  └────────────┘  └────────────┘  │
└──────────────────────────────────────────────────┘
```

### Private vs Public Registries

| Feature | ECR Private | ECR Public |
|---------|-------------|------------|
| **Endpoint** | `<account_id>.dkr.ecr.<region>.amazonaws.com` | `public.ecr.aws` |
| **Authentication** | IAM-based `GetAuthorizationToken` | Anonymous pull (authenticated for push) |
| **Scanning** | Basic + Enhanced (Inspector) | Basic only |
| **Replication** | Cross-region, cross-account | Not supported |
| **Lifecycle Policies** | Yes | Yes |
| **Pull Through Cache** | Yes | N/A |

### Repository Lifecycle Policies

Lifecycle policies automatically expire old images based on rules. Evaluated in priority order (lower number = higher priority):

```json
{
  "rules": [
    {
      "rulePriority": 1,
      "description": "Keep only 10 tagged images",
      "selection": {
        "tagStatus": "tagged",
        "tagPrefixList": ["prod"],
        "countType": "imageCountMoreThan",
        "countNumber": 10
      },
      "action": {
        "type": "expire"
      }
    },
    {
      "rulePriority": 2,
      "description": "Expire untagged images older than 7 days",
      "selection": {
        "tagStatus": "untagged",
        "countType": "sinceImagePushed",
        "countUnit": "days",
        "countNumber": 7
      },
      "action": {
        "type": "expire"
      }
    }
  ]
}
```

> **Exam Tip:** Lifecycle policies only count images within the **same repository**. If the question involves reducing ECR storage costs, lifecycle policies are the answer.

### Cross-Region and Cross-Account Replication

ECR supports **automatic** replication of images:

```
┌──────────────────────┐     Replication      ┌──────────────────────┐
│  Account A           │ ──────────────────▶   │  Account B           │
│  us-east-1           │                       │  eu-west-1           │
│  ┌────────────────┐  │                       │  ┌────────────────┐  │
│  │ myapp:v1.2     │  │                       │  │ myapp:v1.2     │  │
│  └────────────────┘  │                       │  └────────────────┘  │
└──────────────────────┘                       └──────────────────────┘
```

**Replication configuration** (set at registry level):

```json
{
  "replicationConfiguration": {
    "rules": [
      {
        "destinations": [
          {
            "region": "eu-west-1",
            "registryId": "222233334444"
          }
        ],
        "repositoryFilters": [
          {
            "filterType": "PREFIX_MATCH",
            "filter": "prod"
          }
        ]
      }
    ]
  }
}
```

**Cross-account access** requires a **repository policy** on the source:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowCrossAccountPull",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::222233334444:root"
      },
      "Action": [
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage",
        "ecr:BatchCheckLayerAvailability"
      ]
    }
  ]
}
```

### Image Scanning

| Scan Type | Engine | Scope | Trigger |
|-----------|--------|-------|---------|
| **Basic** | Clair (open-source CVE DB) | OS packages only | On push or manual |
| **Enhanced** | Amazon Inspector | OS packages + application dependencies (Java, Python, Node.js, Go, .NET) | Continuous or on push |

Enhanced scanning integrates with **EventBridge** for automated remediation:

```
ECR Enhanced Scan → Finding → EventBridge Rule → Lambda → Notify/Block Deployment
```

### Pull-Through Cache

ECR pull-through cache proxies images from upstream registries and caches them locally:

```
ECS/EKS → ECR Pull-Through Cache → Docker Hub / Quay / GitHub Container Registry
                                       (first pull fetches, subsequent pulls from ECR)
```

**Benefits:**
- Avoids Docker Hub rate limits (100 pulls/6h anonymous, 200 authenticated)
- Faster pulls from regional ECR endpoints
- Image scanning applied to cached images
- Lifecycle policies apply to cached images

**Configuration:**

```
aws ecr create-pull-through-cache-rule \
  --ecr-repository-prefix docker-hub \
  --upstream-registry-url registry-1.docker.io
```

Usage: `<account>.dkr.ecr.<region>.amazonaws.com/docker-hub/library/nginx:latest`

> **Exam Tip:** If a question mentions Docker Hub rate limiting affecting production deployments, the answer is ECR pull-through cache.

---

## 3. Amazon ECS Deep Dive

### Architecture

```
┌──────────────────────────────────────────────────────────┐
│                      ECS Cluster                          │
│                                                           │
│  ┌─────────────────────────────────────────────────────┐  │
│  │                 ECS Service                          │  │
│  │                                                      │  │
│  │  ┌───────────┐  ┌───────────┐  ┌───────────┐        │  │
│  │  │  Task      │  │  Task      │  │  Task      │       │  │
│  │  │ ┌───────┐  │  │ ┌───────┐  │  │ ┌───────┐  │      │  │
│  │  │ │ App   │  │  │ │ App   │  │  │ │ App   │  │      │  │
│  │  │ │Container│ │  │ │Container│ │  │ │Container│ │     │  │
│  │  │ └───────┘  │  │ └───────┘  │  │ └───────┘  │      │  │
│  │  │ ┌───────┐  │  │ ┌───────┐  │  │ ┌───────┐  │      │  │
│  │  │ │Sidecar│  │  │ │Sidecar│  │  │ │Sidecar│  │      │  │
│  │  │ └───────┘  │  │ └───────┘  │  │ └───────┘  │      │  │
│  │  └───────────┘  └───────────┘  └───────────┘        │  │
│  └─────────────────────────────────────────────────────┘  │
│                                                           │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐    │
│  │ EC2 Instance │  │ EC2 Instance │  │  Fargate      │   │
│  │ (ECS Agent)  │  │ (ECS Agent)  │  │  (serverless) │   │
│  └──────────────┘  └──────────────┘  └──────────────┘    │
└──────────────────────────────────────────────────────────┘
```

### Key Concepts

| Concept | Description |
|---------|------------|
| **Cluster** | Logical grouping of tasks/services. Can span EC2, Fargate, and External instances. |
| **Task Definition** | Blueprint (JSON) describing one or more containers: image, CPU, memory, ports, volumes, IAM roles, logging. Versioned (revisions). |
| **Task** | Running instance of a task definition. Ephemeral — like a Kubernetes Pod. |
| **Service** | Maintains desired count of tasks. Handles rolling updates, load balancer integration, auto scaling. |
| **Container Instance** | EC2 instance running the ECS agent and registered to a cluster. |

### Task Definitions — Detailed Anatomy

```json
{
  "family": "web-app",
  "taskRoleArn": "arn:aws:iam::123456789012:role/ecsTaskRole",
  "executionRoleArn": "arn:aws:iam::123456789012:role/ecsTaskExecutionRole",
  "networkMode": "awsvpc",
  "requiresCompatibilities": ["FARGATE"],
  "cpu": "512",
  "memory": "1024",
  "runtimePlatform": {
    "cpuArchitecture": "ARM64",
    "operatingSystemFamily": "LINUX"
  },
  "containerDefinitions": [
    {
      "name": "web",
      "image": "123456789012.dkr.ecr.us-east-1.amazonaws.com/myapp:v1.2",
      "portMappings": [
        {
          "containerPort": 8080,
          "protocol": "tcp"
        }
      ],
      "essential": true,
      "healthCheck": {
        "command": ["CMD-SHELL", "curl -f http://localhost:8080/health || exit 1"],
        "interval": 30,
        "timeout": 5,
        "retries": 3,
        "startPeriod": 60
      },
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "/ecs/web-app",
          "awslogs-region": "us-east-1",
          "awslogs-stream-prefix": "web"
        }
      },
      "secrets": [
        {
          "name": "DB_PASSWORD",
          "valueFrom": "arn:aws:secretsmanager:us-east-1:123456789012:secret:db-password-abc123"
        },
        {
          "name": "API_KEY",
          "valueFrom": "arn:aws:ssm:us-east-1:123456789012:parameter/api-key"
        }
      ],
      "environment": [
        {
          "name": "APP_ENV",
          "value": "production"
        }
      ]
    },
    {
      "name": "xray-daemon",
      "image": "amazon/aws-xray-daemon",
      "essential": false,
      "portMappings": [
        {
          "containerPort": 2000,
          "protocol": "udp"
        }
      ]
    }
  ]
}
```

**Critical IAM Role Distinction:**

| Role | Purpose | Who Assumes It |
|------|---------|---------------|
| **Task Role** (`taskRoleArn`) | Permissions for the **application** inside the container (e.g., read from S3, write to DynamoDB) | The container/application |
| **Execution Role** (`executionRoleArn`) | Permissions for the **ECS agent** to pull images from ECR, fetch secrets from SSM/Secrets Manager, push logs to CloudWatch | ECS agent / Fargate runtime |

> **Exam Tip:** If a container can't pull images from ECR → check the **execution role**. If the application can't access AWS services → check the **task role**.

### Task Placement Strategies (EC2 Launch Type Only)

Placement strategies determine **how** tasks are placed on container instances:

| Strategy | Behavior | Use Case |
|----------|----------|----------|
| **binpack** | Place tasks on fewest instances (most tightly packed on CPU or memory) | Cost optimization — minimize number of running instances |
| **spread** | Spread tasks evenly across a specified attribute (`instanceId`, `attribute:ecs.availability-zone`) | High availability |
| **random** | Place tasks randomly | Testing, simple workloads |

**Strategies can be chained (evaluated in order):**

```json
{
  "placementStrategy": [
    {
      "type": "spread",
      "field": "attribute:ecs.availability-zone"
    },
    {
      "type": "binpack",
      "field": "memory"
    }
  ]
}
```

This spreads across AZs first, then bin-packs within each AZ.

### Task Placement Constraints

Constraints filter **which** instances are eligible:

| Constraint | Description |
|-----------|------------|
| **distinctInstance** | Each task on a different container instance |
| **memberOf** | Cluster query language expression to filter instances |

```json
{
  "placementConstraints": [
    {
      "type": "distinctInstance"
    },
    {
      "type": "memberOf",
      "expression": "attribute:ecs.instance-type =~ t3.*"
    },
    {
      "type": "memberOf",
      "expression": "attribute:ecs.availability-zone in [us-east-1a, us-east-1b]"
    }
  ]
}
```

> **Exam Tip:** "binpack" = cost optimization. "spread" = availability. Constraints are filters; strategies are ordering algorithms. Fargate does NOT support placement strategies.

### Capacity Providers

Capacity providers manage the infrastructure for running tasks:

| Provider Type | Description |
|--------------|------------|
| **FARGATE** | Built-in, serverless |
| **FARGATE_SPOT** | Built-in, up to 70% discount, 2-minute interruption warning |
| **Auto Scaling Group** | Link an ASG to ECS for managed EC2 capacity |

**Capacity Provider Strategy:**

```json
{
  "capacityProviderStrategy": [
    {
      "capacityProvider": "FARGATE",
      "weight": 1,
      "base": 2
    },
    {
      "capacityProvider": "FARGATE_SPOT",
      "weight": 3,
      "base": 0
    }
  ]
}
```

- **base**: Minimum tasks on this provider (only one provider can have base > 0)
- **weight**: Relative proportion after base is met

Above: 2 tasks always on Fargate, then 75% of additional tasks on Fargate Spot, 25% on Fargate.

### Cluster Auto Scaling (CAS)

For EC2 launch type, CAS automatically scales the ASG to match task demand:

```
ECS Service → needs more tasks → CAS calculates capacity needed →
    scales ASG → new EC2 instances register → tasks placed
```

CAS uses the **CapacityProviderReservation** metric:
- Target = 100% means instances are matched to demand
- Target < 100% leaves headroom for burst

### Service Discovery

Uses **AWS Cloud Map** (Route 53 backed) to register tasks as DNS records:

```
┌─────────────┐     DNS Query:          ┌──────────────────┐
│ Service A   │  ── api.local ────────▶  │ Cloud Map        │
│             │                          │ (Route 53        │
│             │  ◀── 10.0.1.23 ────────  │  private hosted  │
│             │                          │  zone)           │
└─────────────┘                          └──────────────────┘
                                              │
                                    ┌─────────┴─────────┐
                                    │                   │
                              ┌─────┴──────┐      ┌────┴───────┐
                              │ Task B      │      │ Task B     │
                              │ 10.0.1.23   │      │ 10.0.2.45  │
                              └────────────┘      └────────────┘
```

- **A records** for `awsvpc` mode (IP-based)
- **SRV records** for bridge/host mode (IP + port)
- Health checks via Route 53 or ECS task health

### Service Connect

Service Connect is the **modern replacement** for Service Discovery. It provides:

- Built-in client-side load balancing (Envoy proxy sidecar)
- Traffic metrics without code changes
- Service mesh capabilities without App Mesh

```
┌───────────────────────────────────┐
│  Task                             │
│  ┌───────────┐  ┌──────────────┐  │
│  │ App       │──│ Envoy Proxy  │──│──▶ Other Services
│  │ Container │  │ (sidecar)    │  │
│  └───────────┘  └──────────────┘  │
└───────────────────────────────────┘
```

> **Exam Tip:** Service Connect = recommended for new deployments. Service Discovery = still valid for simple DNS-based scenarios.

### ECS Exec (Execute Command)

Debug running containers by executing commands inside them (like `kubectl exec`):

```bash
aws ecs execute-command \
  --cluster my-cluster \
  --task abc123def456 \
  --container web \
  --command "/bin/sh" \
  --interactive
```

**Requirements:**
- Uses SSM Session Manager under the hood
- Task role needs `ssmmessages:CreateControlChannel`, `ssmmessages:CreateDataChannel`, `ssmmessages:OpenControlChannel`, `ssmmessages:OpenDataChannel`
- Enable at service level: `--enable-execute-command`

### Deployment Circuit Breaker

Automatically rolls back failed deployments:

```json
{
  "deploymentConfiguration": {
    "deploymentCircuitBreaker": {
      "enable": true,
      "rollback": true
    },
    "maximumPercent": 200,
    "minimumHealthyPercent": 100
  }
}
```

**How it works:**
1. ECS deploys new tasks
2. If tasks fail to reach RUNNING state or fail health checks
3. After threshold failures → circuit breaker triggers
4. If rollback enabled → automatically reverts to last successful deployment

> **Exam Tip:** Deployment circuit breaker is the ECS-native answer for "automated rollback on failed deployments." For canary/blue-green, use CodeDeploy with ECS.

---

## 4. ECS Launch Types

### Comparison Table

| Feature | EC2 | Fargate | External (ECS Anywhere) |
|---------|-----|---------|------------------------|
| **Infrastructure** | You manage EC2 instances | AWS manages compute | Your on-premises/VM servers |
| **Pricing** | EC2 instance pricing + optional Savings Plans/RIs | Per vCPU + memory per second | Per managed ECS Anywhere instance/hour |
| **GPU Support** | Yes (P3, P4, G4, G5 instances) | No | Limited (depends on hardware) |
| **Placement Strategies** | Yes (binpack, spread, random) | No | No |
| **awsvpc ENI Limit** | Limited by instance ENI count | One ENI per task | Uses host networking |
| **Privileged Mode** | Yes | No | Yes |
| **Docker Volumes** | EBS, EFS, bind mounts, Docker volumes | EFS, ephemeral 20-200GB | Host volumes |
| **Max Task Size** | Limited by instance type | 16 vCPU, 120 GB memory | Limited by host |
| **Networking** | awsvpc, bridge, host, none | awsvpc only | bridge, host |
| **Startup Time** | Seconds (if capacity available) | ~30-60 seconds (image pull) | Seconds |
| **Windows Containers** | Yes | Yes (limited) | No |

### When to Choose Each

**Choose EC2 when:**
- Need GPU workloads
- Need privileged containers
- Need specific instance types (memory-optimized, compute-optimized)
- Cost optimization with Reserved Instances/Savings Plans for steady-state
- Need more than 16 vCPU or 120 GB per task
- Need Windows containers with full feature support

**Choose Fargate when:**
- Want operational simplicity (no patching, no capacity planning)
- Variable or unpredictable workloads
- Small to medium task sizes
- Batch jobs that scale to zero
- Security requirement to not share kernel with other tenants (task-level isolation)

**Choose ECS Anywhere when:**
- Run ECS tasks on on-premises servers or VMs
- Hybrid architecture with consistent orchestration
- Data locality requirements (data must stay on-premises)
- Edge computing scenarios

> **Exam Tip:** Fargate provides **task-level isolation** (each task has its own kernel). EC2 shares the kernel across all tasks on an instance. If the question requires workload isolation, Fargate is more secure.

---

## 5. Amazon EKS Deep Dive

### Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                       AWS Managed                                │
│  ┌───────────────────────────────────────────────────────────┐   │
│  │              EKS Control Plane                             │   │
│  │  ┌──────────┐  ┌──────────┐  ┌──────────┐                │   │
│  │  │ API      │  │ etcd     │  │ Controller│                │   │
│  │  │ Server   │  │ (3 AZs)  │  │ Manager   │                │   │
│  │  └──────────┘  └──────────┘  └──────────┘                │   │
│  │  ┌──────────────────────────────────────┐                 │   │
│  │  │    Kubernetes API Endpoint            │                 │   │
│  │  │  (public and/or private)              │                 │   │
│  │  └──────────────────────────────────────┘                 │   │
│  └───────────────────────────────────────────────────────────┘   │
│                          │                                        │
│                    ENI in customer VPC                             │
│                          │                                        │
└──────────────────────────┼────────────────────────────────────────┘
                           │
┌──────────────────────────┼────────────────────────────────────────┐
│  Customer VPC            │                                        │
│                          ▼                                        │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────────────┐    │
│  │ Managed Node  │  │ Self-Managed │  │ Fargate Profiles     │    │
│  │ Group (ASG)   │  │ Nodes (ASG)  │  │ (serverless pods)    │    │
│  │               │  │              │  │                      │    │
│  │ ┌───┐ ┌───┐   │  │ ┌───┐ ┌───┐  │  │ ┌───┐ ┌───┐         │    │
│  │ │Pod│ │Pod│   │  │ │Pod│ │Pod│  │  │ │Pod│ │Pod│         │    │
│  │ └───┘ └───┘   │  │ └───┘ └───┘  │  │ └───┘ └───┘         │    │
│  └──────────────┘  └──────────────┘  └──────────────────────┘    │
└───────────────────────────────────────────────────────────────────┘
```

### EKS API Server Endpoint Access

| Configuration | Description | Use Case |
|--------------|-------------|----------|
| **Public** | API accessible from internet (with RBAC/IAM) | Development, simple setups |
| **Public + Private** | Workers communicate via private ENIs; API also accessible publicly | Transition period |
| **Private only** | API only accessible from within VPC | Production, security-sensitive |

### Managed Node Groups

AWS manages the EC2 instances, AMI updates, and draining:

- Based on EKS-optimized AMIs (Amazon Linux 2, Bottlerocket, Windows)
- Nodes are in your account (visible in EC2 console)
- Managed updates: cordon → drain → terminate → launch new
- Support for Spot instances, On-Demand, mixed
- Support for custom launch templates
- **Bottlerocket** — AWS-purpose-built OS for containers: minimal attack surface, immutable root filesystem, atomic updates

### Fargate Profiles

Run Kubernetes pods on Fargate (no nodes to manage):

```yaml
# Fargate Profile Configuration
apiVersion: eks.amazonaws.com/v1
kind: FargateProfile
metadata:
  name: my-profile
spec:
  selectors:
    - namespace: production
      labels:
        app: web
    - namespace: batch
  subnets:
    - subnet-abc123
    - subnet-def456
```

**Limitations of Fargate for EKS:**
- No DaemonSets
- No privileged containers
- No GPU
- No EBS volumes (only EFS and ephemeral storage up to 175 GB)
- Each pod gets its own microVM (Firecracker)
- Pod must match a Fargate profile selector (namespace + labels)

### IAM Roles for Service Accounts (IRSA)

Maps Kubernetes service accounts to IAM roles using OIDC federation:

```
┌─────────────────┐                    ┌──────────────┐
│ Pod with SA     │  ── STS AssumeRole │  IAM Role    │
│ "my-sa"        │     with OIDC ──▶  │  "s3-reader" │
│                 │     Web Identity   │              │
└─────────────────┘                    └──────────────┘
                                              │
                                              ▼
                                       ┌──────────────┐
                                       │  S3 Bucket   │
                                       └──────────────┘
```

**IAM Role trust policy:**

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "arn:aws:iam::123456789012:oidc-provider/oidc.eks.us-east-1.amazonaws.com/id/EXAMPLED539D4633E53DE1B71EXAMPLE"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "oidc.eks.us-east-1.amazonaws.com/id/EXAMPLED539D4633E53DE1B71EXAMPLE:sub": "system:serviceaccount:default:my-sa",
          "oidc.eks.us-east-1.amazonaws.com/id/EXAMPLED539D4633E53DE1B71EXAMPLE:aud": "sts.amazonaws.com"
        }
      }
    }
  ]
}
```

### EKS Pod Identity (Newer, Simpler Alternative to IRSA)

Pod Identity simplifies IAM role association — no OIDC provider setup required:

```bash
aws eks create-pod-identity-association \
  --cluster-name my-cluster \
  --namespace default \
  --service-account my-sa \
  --role-arn arn:aws:iam::123456789012:role/my-role
```

| Feature | IRSA | Pod Identity |
|---------|------|-------------|
| OIDC Provider Required | Yes (per cluster) | No |
| Setup Complexity | Higher (trust policy per cluster/SA) | Lower (API call) |
| Cross-Account | Yes (with chaining) | Yes (native) |
| Session Tags | No | Yes |
| Availability | All EKS versions | EKS 1.24+ |

> **Exam Tip:** Pod Identity is the recommended approach for new deployments. IRSA is still valid and may appear in exam questions about existing architectures.

### EBS CSI Driver

Enables Kubernetes persistent volumes backed by EBS:

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: ebs-claim
spec:
  accessModes:
    - ReadWriteOnce
  storageClassName: gp3
  resources:
    requests:
      storage: 50Gi
---
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: gp3
provisioner: ebs.csi.aws.com
parameters:
  type: gp3
  encrypted: "true"
  kmsKeyId: "arn:aws:kms:us-east-1:123456789012:key/abc-123"
volumeBindingMode: WaitForFirstConsumer
```

- **ReadWriteOnce** only (EBS is AZ-scoped)
- Snapshots supported via VolumeSnapshot
- Not available on Fargate

### EFS CSI Driver

Enables shared storage across pods and AZs:

```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: efs-pv
spec:
  capacity:
    storage: 5Gi
  volumeMode: Filesystem
  accessModes:
    - ReadWriteMany
  csi:
    driver: efs.csi.aws.com
    volumeHandle: fs-0123456789abcdef0
```

- **ReadWriteMany** supported (shared across pods, nodes, AZs)
- Works with **both** EC2 nodes and Fargate
- Supports access points for per-pod directory isolation

> **Exam Tip:** Need shared storage across pods? → EFS. Single pod persistent storage? → EBS. Fargate persistent storage? → EFS only.

### Cluster Autoscaler vs Karpenter

| Feature | Cluster Autoscaler | Karpenter |
|---------|-------------------|-----------|
| **Approach** | Scales existing node groups (ASGs) | Provisions nodes directly (no ASGs) |
| **Speed** | Slower (ASG scaling + node registration) | Faster (direct EC2 provisioning) |
| **Flexibility** | Limited to configured instance types in ASG | Dynamically selects optimal instance types |
| **Consolidation** | No (relies on scale-down) | Yes — actively replaces underutilized nodes |
| **Spot Handling** | Basic (one ASG per instance type recommended) | Native price-capacity optimized selection |
| **Configuration** | Node groups per instance family | NodePool CRDs with flexible constraints |
| **AWS Specific** | No (works on any cloud) | Yes (deeply integrated with EC2) |

**Karpenter NodePool example:**

```yaml
apiVersion: karpenter.sh/v1beta1
kind: NodePool
metadata:
  name: default
spec:
  template:
    spec:
      requirements:
        - key: "karpenter.sh/capacity-type"
          operator: In
          values: ["spot", "on-demand"]
        - key: "node.kubernetes.io/instance-type"
          operator: In
          values: ["m5.large", "m5.xlarge", "m5.2xlarge", "c5.large", "c5.xlarge"]
        - key: "topology.kubernetes.io/zone"
          operator: In
          values: ["us-east-1a", "us-east-1b"]
      nodeClassRef:
        name: default
  limits:
    cpu: "1000"
    memory: 1000Gi
  disruption:
    consolidationPolicy: WhenUnderutilized
    expireAfter: 720h
```

> **Exam Tip:** Karpenter is the AWS-recommended autoscaler for EKS. If the question mentions "right-sizing nodes" or "consolidation," Karpenter is the answer.

### AWS Load Balancer Controller

Manages ALB (Ingress) and NLB (Service type LoadBalancer) for EKS:

```yaml
# ALB Ingress
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: web-ingress
  annotations:
    kubernetes.io/ingress.class: alb
    alb.ingress.kubernetes.io/scheme: internet-facing
    alb.ingress.kubernetes.io/target-type: ip
    alb.ingress.kubernetes.io/certificate-arn: arn:aws:acm:us-east-1:123456789012:certificate/abc-123
spec:
  rules:
    - host: app.example.com
      http:
        paths:
          - path: /api
            pathType: Prefix
            backend:
              service:
                name: api-service
                port:
                  number: 80
          - path: /
            pathType: Prefix
            backend:
              service:
                name: web-service
                port:
                  number: 80
```

**Target types:**
- `ip` — registers pod IPs directly (works with Fargate, requires awsvpc/VPC CNI)
- `instance` — registers node IPs with NodePort

### App Mesh Integration

AWS App Mesh provides service mesh with Envoy sidecar proxies:

```
┌────────────────────────────────────────┐
│  App Mesh Virtual Service              │
│                                        │
│  ┌──────────────┐  ┌──────────────┐    │
│  │ Virtual Node │  │ Virtual Node │    │
│  │ (Service A)  │  │ (Service B)  │    │
│  │              │──│              │    │
│  │ ┌──────────┐ │  │ ┌──────────┐ │    │
│  │ │ Envoy    │ │  │ │ Envoy    │ │    │
│  │ │ Proxy    │ │  │ │ Proxy    │ │    │
│  │ └──────────┘ │  │ └──────────┘ │    │
│  └──────────────┘  └──────────────┘    │
└────────────────────────────────────────┘
```

Features: traffic shaping, retries, timeouts, circuit breaking, observability, mTLS between services.

> **Exam Tip:** App Mesh questions are rare on the exam but may appear in the context of "how to implement canary deployments" or "mTLS between microservices."

---

## 6. AWS Fargate Deep Dive

### Pricing Model

Fargate charges per second for compute:

| Resource | Per Second | Per Hour (approx) |
|----------|-----------|-------------------|
| vCPU | $0.04048 | $0.1457 |
| Memory (GB) | $0.004445 | $0.0160 |
| Ephemeral storage (above 20 GB) | $0.000111/GB | $0.0004/GB |

**Fargate Spot** offers up to 70% discount but with 2-minute interruption warning (SIGTERM + 2 min before SIGKILL).

### Valid CPU/Memory Combinations

| vCPU | Memory Range |
|------|-------------|
| 0.25 | 0.5, 1, 2 GB |
| 0.5 | 1 – 4 GB (1 GB increments) |
| 1 | 2 – 8 GB (1 GB increments) |
| 2 | 4 – 16 GB (1 GB increments) |
| 4 | 8 – 30 GB (1 GB increments) |
| 8 | 16 – 60 GB (4 GB increments) |
| 16 | 32 – 120 GB (8 GB increments) |

> **Exam Tip:** If a question says "run a container needing 24 GB memory on Fargate," you need at least 4 vCPU (which supports up to 30 GB). Max Fargate task = 16 vCPU / 120 GB.

### Platform Versions

Fargate platform versions control the runtime:

| Version | Key Features |
|---------|-------------|
| **1.4.0 (Linux)** | EFS support, ephemeral storage 20 GB default (configurable to 200 GB), SYS_PTRACE capability, container init process |
| **LATEST** | Always points to the latest stable version |

ECS uses platform versions. EKS on Fargate has its own versioning tied to Kubernetes versions.

### Ephemeral Storage

- Default: 20 GB
- Configurable: up to 200 GB (ECS), 175 GB (EKS)
- Shared across all containers in a task/pod
- Encrypted at rest with AWS-managed keys
- Non-persistent — lost when task stops

```json
{
  "ephemeralStorage": {
    "sizeInGiB": 100
  }
}
```

---

## 7. AWS App Runner

### Overview

Fully managed service to run containerized web applications at scale with zero infrastructure management:

```
Source (ECR image or GitHub repo) → App Runner → HTTPS endpoint
                                       │
                              ┌────────┴────────┐
                              │  Auto Scaling    │
                              │  Load Balancing  │
                              │  TLS Termination │
                              │  Health Checks   │
                              └─────────────────┘
```

### When to Use App Runner

| Use Case | Appropriate? |
|----------|-------------|
| Simple web APIs and microservices | Yes |
| Need automatic scaling to zero | No (minimum 1 instance) |
| Need VPC access (RDS, ElastiCache) | Yes (via VPC Connector) |
| GPU workloads | No |
| Long-running background jobs | No (request-response only) |
| Need full Kubernetes control | No (use EKS) |
| Rapid prototyping / startup MVPs | Yes |

### Auto Scaling

```json
{
  "AutoScalingConfigurationArn": "arn:aws:apprunner:...",
  "MaxConcurrency": 100,
  "MaxSize": 25,
  "MinSize": 1
}
```

- **MaxConcurrency**: Concurrent requests per instance before scaling out
- **MinSize**: Minimum instances (1 = always warm; cannot be 0)
- **MaxSize**: Maximum instances

### VPC Connector

Enables App Runner services to access resources in a VPC:

```
┌──────────────┐       ┌──────────────────────┐
│  App Runner  │──────▶│  VPC Connector        │
│  Service     │       │  (ENIs in subnets)    │
└──────────────┘       │         │              │
                       │    ┌────▼─────┐        │
                       │    │  RDS     │        │
                       │    │  Redis   │        │
                       │    │  etc.    │        │
                       └────┴──────────┴────────┘
```

> **Exam Tip:** App Runner = simplest container service on AWS. Think of it as "Heroku for AWS." If the question emphasizes simplicity and web app workloads, App Runner may be the answer. For more control → ECS. For Kubernetes → EKS.

---

## 8. Container Networking

### ECS Network Modes

| Mode | Description | Use Case |
|------|------------|----------|
| **awsvpc** | Each task gets its own ENI with a private IP. Required for Fargate. | Production workloads, security groups per task |
| **bridge** | Docker's default bridge network. Tasks share host's ENI via port mapping. | Legacy, multiple tasks per host with dynamic ports |
| **host** | Container shares host network namespace. No port mapping. | Performance-sensitive (no NAT overhead), single task per port per host |
| **none** | No external network connectivity | Security-sensitive batch processing |

### awsvpc Mode Details

```
┌──────────────────────────────────────────────┐
│  EC2 Instance (or Fargate)                   │
│                                               │
│  ┌──────────────┐    ┌──────────────┐         │
│  │ Task A       │    │ Task B       │         │
│  │ ENI: 10.0.1.5│    │ ENI: 10.0.1.6│        │
│  │ SG: sg-web   │    │ SG: sg-api   │        │
│  └──────────────┘    └──────────────┘         │
│                                               │
│  Primary ENI: 10.0.1.4 (host)                │
└──────────────────────────────────────────────┘
```

**Benefits:**
- Each task has its own security group
- Task-level network isolation
- Simplified service discovery (stable IPs)
- Consistent networking between EC2 and Fargate

**Limitation on EC2:** ENI density is limited by instance type. Use `awsvpc trunking` (account setting) to increase ENI limits.

### Service Mesh (App Mesh / Service Connect / Istio)

```
┌──────────────────────────────────────────────────────┐
│  Service Mesh                                         │
│                                                       │
│  ┌────────────┐         ┌────────────┐                │
│  │ Service A  │◀──mTLS──│ Service B  │                │
│  │ ┌────────┐ │         │ ┌────────┐ │                │
│  │ │ App    │ │         │ │ App    │ │                │
│  │ └────────┘ │         │ └────────┘ │                │
│  │ ┌────────┐ │         │ ┌────────┐ │                │
│  │ │ Envoy  │ │         │ │ Envoy  │ │                │
│  │ │ Proxy  │ │         │ │ Proxy  │ │                │
│  │ └────────┘ │         │ └────────┘ │                │
│  └────────────┘         └────────────┘                │
│                                                       │
│  Features: mTLS, retries, circuit breaking,           │
│  traffic shaping, canary deployments, observability   │
└──────────────────────────────────────────────────────┘
```

| Mesh Option | ECS | EKS |
|------------|-----|-----|
| Service Connect | Yes (recommended) | No |
| App Mesh | Yes | Yes |
| Istio | No | Yes |
| Linkerd | No | Yes |

---

## 9. Container Storage

### Storage Options by Service

| Storage Type | ECS EC2 | ECS Fargate | EKS EC2 | EKS Fargate |
|-------------|---------|-------------|---------|-------------|
| **Docker Volumes (local)** | Yes | No | N/A | N/A |
| **Bind Mounts** | Yes | Yes (ephemeral only) | N/A | N/A |
| **EBS** | Yes (via Docker volume plugin) | No | Yes (CSI driver) | No |
| **EFS** | Yes | Yes | Yes (CSI driver) | Yes (CSI driver) |
| **FSx for Lustre** | Yes (via driver) | No | Yes (CSI driver) | No |
| **Ephemeral Storage** | Instance storage | 20-200 GB | Instance storage | Up to 175 GB |

### EFS for Containers — Best Practice Architecture

```
┌────────────────────────────────────────────────────┐
│  VPC                                                │
│                                                     │
│  AZ-a                      AZ-b                     │
│  ┌──────────────┐          ┌──────────────┐         │
│  │ ECS Task     │          │ ECS Task     │         │
│  │  ┌────────┐  │          │  ┌────────┐  │         │
│  │  │ App    │  │          │  │ App    │  │         │
│  │  │ /data ─┼──┼───┐      │  │ /data ─┼──┼───┐    │
│  │  └────────┘  │   │      │  └────────┘  │   │    │
│  └──────────────┘   │      └──────────────┘   │    │
│                     ▼                         ▼    │
│            ┌──────────────────────────────┐        │
│            │     Amazon EFS              │        │
│            │  (Multi-AZ, shared storage) │        │
│            └──────────────────────────────┘        │
└────────────────────────────────────────────────────┘
```

### FSx for Lustre with EKS

High-performance parallel file system for ML training, HPC, video processing:

```yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: fsx-lustre
provisioner: fsx.csi.aws.com
parameters:
  subnetId: subnet-abc123
  securityGroupIds: sg-xyz789
  deploymentType: PERSISTENT_2
  perUnitStorageThroughput: "200"
```

> **Exam Tip:** Need shared storage for containers → EFS. Need high-throughput parallel storage for ML/HPC → FSx for Lustre. Need block storage for databases → EBS (EKS EC2 only).

---

## 10. Container Security

### Multi-Layer Security Model

```
┌─────────────────────────────────────────────────┐
│  1. Image Security                               │
│     - ECR scanning (Basic + Enhanced)            │
│     - Image signing (Notation/cosign)            │
│     - Minimal base images                        │
│     - No secrets in images                       │
├─────────────────────────────────────────────────┤
│  2. Runtime Security                             │
│     - Read-only root filesystem                  │
│     - Non-root user                              │
│     - Drop capabilities                          │
│     - No privileged mode                         │
├─────────────────────────────────────────────────┤
│  3. Network Security                             │
│     - Security groups per task (awsvpc)          │
│     - Network policies (EKS with Calico)         │
│     - mTLS via service mesh                      │
├─────────────────────────────────────────────────┤
│  4. Access Control                               │
│     - Task IAM roles (ECS) / IRSA (EKS)         │
│     - Secrets Manager for credentials            │
│     - Encryption at rest and in transit          │
├─────────────────────────────────────────────────┤
│  5. Audit & Compliance                           │
│     - CloudTrail for API calls                   │
│     - VPC Flow Logs                              │
│     - Container Insights                         │
│     - GuardDuty EKS/ECS protection               │
└─────────────────────────────────────────────────┘
```

### Secrets Management

**ECS — Secrets from Secrets Manager/SSM:**

```json
{
  "containerDefinitions": [
    {
      "name": "app",
      "secrets": [
        {
          "name": "DB_PASSWORD",
          "valueFrom": "arn:aws:secretsmanager:us-east-1:123456789012:secret:prod/db-AbCdEf"
        },
        {
          "name": "API_KEY",
          "valueFrom": "arn:aws:ssm:us-east-1:123456789012:parameter/prod/api-key"
        }
      ]
    }
  ]
}
```

**EKS — Secrets Store CSI Driver:**

```yaml
apiVersion: secrets-store.csi.x-k8s.io/v1
kind: SecretProviderClass
metadata:
  name: aws-secrets
spec:
  provider: aws
  parameters:
    objects: |
      - objectName: "prod/db-password"
        objectType: "secretsmanager"
      - objectName: "/prod/api-key"
        objectType: "ssmparameter"
```

### Image Signing

Use **AWS Signer** with **Notation** to sign container images and enforce signature verification:

```
Build → Sign (AWS Signer) → Push to ECR → Admission Controller verifies → Deploy
```

For EKS, use **Kyverno** or **OPA Gatekeeper** to enforce signed images.

> **Exam Tip:** If the question asks about "ensuring only approved images run in production," the answer involves ECR image scanning + image signing + admission controllers (EKS) or task definition restrictions (ECS).

---

## 11. Container Observability

### CloudWatch Container Insights

Provides cluster, service, task, and container-level metrics:

```
┌───────────────────────────────────────────────────┐
│  Container Insights Dashboard                      │
│                                                    │
│  Cluster CPU: ████████░░ 78%                       │
│  Cluster Mem: ██████░░░░ 62%                       │
│                                                    │
│  Service   │ Tasks │ CPU  │ Memory │ Network       │
│  ──────────┼───────┼──────┼────────┼──────────     │
│  web-svc   │  10   │ 45%  │ 60%    │ 1.2 GB/s     │
│  api-svc   │  5    │ 72%  │ 48%    │ 0.8 GB/s     │
│  worker    │  3    │ 90%  │ 85%    │ 0.1 GB/s     │
└───────────────────────────────────────────────────┘
```

**How to enable:**
- ECS: Account setting or `--containerInsights` at cluster level
- EKS: Deploy CloudWatch agent as DaemonSet or use ADOT (AWS Distro for OpenTelemetry)

### X-Ray for Distributed Tracing

**ECS:** Run X-Ray daemon as a sidecar container:

```json
{
  "name": "xray-daemon",
  "image": "amazon/aws-xray-daemon",
  "essential": false,
  "portMappings": [
    {
      "containerPort": 2000,
      "protocol": "udp"
    }
  ]
}
```

**EKS:** Deploy X-Ray daemon as DaemonSet or use ADOT collector.

### FireLens for Custom Log Routing

FireLens uses Fluent Bit or Fluentd as a log router:

```
┌──────────────────────────────────────────────────┐
│  ECS Task                                         │
│                                                   │
│  ┌──────────┐    ┌──────────────────────┐         │
│  │ App      │───▶│ FireLens (Fluent Bit)│───▶ S3  │
│  │ Container│    │                      │───▶ CloudWatch
│  └──────────┘    │                      │───▶ OpenSearch
│                  │                      │───▶ Datadog
│                  └──────────────────────┘───▶ Splunk
└──────────────────────────────────────────────────┘
```

```json
{
  "containerDefinitions": [
    {
      "name": "app",
      "logConfiguration": {
        "logDriver": "awsfirelens",
        "options": {
          "Name": "kinesis_firehose",
          "region": "us-east-1",
          "delivery_stream": "my-stream"
        }
      }
    },
    {
      "name": "log_router",
      "image": "amazon/aws-for-fluent-bit:latest",
      "essential": true,
      "firelensConfiguration": {
        "type": "fluentbit"
      }
    }
  ]
}
```

> **Exam Tip:** Need to send logs to multiple destinations or third-party services? → FireLens. Simple CloudWatch logging? → `awslogs` driver. Custom log parsing/filtering? → FireLens with Fluent Bit.

---

## 12. Container Patterns

### Sidecar Pattern

A helper container that runs alongside the main container in the same task/pod:

```
┌──────────────────────────────────┐
│  Task / Pod                       │
│  ┌────────────┐  ┌────────────┐  │
│  │ Main App   │  │ Sidecar    │  │
│  │ (web)      │  │ (log agent,│  │
│  │            │  │  proxy,    │  │
│  │            │  │  monitoring)│ │
│  └────────────┘  └────────────┘  │
│       shared network + volumes    │
└──────────────────────────────────┘
```

**Examples:** Log forwarding (Fluent Bit), Envoy proxy, X-Ray daemon, secrets sync agent.

### Ambassador Pattern

A proxy container that handles external communications for the main app:

```
┌─────────────────────────────────────────────┐
│  Task / Pod                                  │
│  ┌────────────┐  ┌──────────────┐            │
│  │ Main App   │──│ Ambassador   │──▶ External│
│  │ localhost:  │  │ (handles TLS,│   Service  │
│  │ 5432       │  │  auth, retry) │           │
│  └────────────┘  └──────────────┘            │
└─────────────────────────────────────────────┘
```

**Examples:** Database proxy (PgBouncer), external API gateway, legacy protocol adapter.

### Adapter Pattern

Transforms or normalizes the main container's output:

```
┌──────────────────────────────────────┐
│  Task / Pod                           │
│  ┌────────────┐  ┌──────────────┐     │
│  │ Main App   │──│ Adapter      │──▶ Monitoring
│  │ (custom    │  │ (transforms  │    (Prometheus
│  │  metrics)  │  │  to standard │     format)
│  │            │  │  format)     │
│  └────────────┘  └──────────────┘     │
└──────────────────────────────────────┘
```

**Examples:** Prometheus exporter sidecar, log format normalizer.

### Init Containers (EKS / ECS)

Run to completion before the main containers start:

```
┌──────────────────────────────────────────┐
│  Pod Lifecycle                            │
│                                           │
│  Init Container 1 → Init Container 2 →   │
│  (pull config)      (run migrations)      │
│                                           │
│  → Main Container + Sidecar (run forever) │
└──────────────────────────────────────────┘
```

**ECS:** Set `essential: false` and `dependsOn` with `SUCCESS` condition.
**EKS:** Native `initContainers` spec.

> **Exam Tip:** The sidecar pattern is the most commonly tested. Understand when to add a sidecar for logging (FireLens), tracing (X-Ray), or proxying (Envoy).

---

## 13. Migration to Containers Strategy

### Migration Approach

```
┌─────────────────────────────────────────────────────────────────┐
│                   Container Migration Path                       │
│                                                                  │
│  Phase 1: Assess        Phase 2: Containerize    Phase 3: Deploy │
│  ┌──────────────┐       ┌──────────────┐         ┌────────────┐  │
│  │ App Discovery │       │ Create       │         │ ECS/EKS    │  │
│  │ Dependency    │──────▶│ Dockerfiles  │────────▶│ Deploy     │  │
│  │ Analysis      │       │ Build CI/CD  │         │ Monitor    │  │
│  │ Prioritize    │       │ Test Images  │         │ Optimize   │  │
│  └──────────────┘       └──────────────┘         └────────────┘  │
│                                                                  │
│  Tools:                  Tools:                   Tools:          │
│  - AWS Migration Hub     - AWS App2Container      - CodePipeline │
│  - App Discovery Service - Docker Compose          - CodeDeploy  │
│  - Migration Evaluator   - ECR                     - Copilot CLI │
└─────────────────────────────────────────────────────────────────┘
```

### AWS App2Container (A2C)

Automatically containerizes existing Java and .NET applications:

1. **Discover** — Inventories running applications on the server
2. **Analyze** — Creates dependency graphs and resource mappings
3. **Containerize** — Generates Dockerfiles and builds images
4. **Deploy** — Creates ECS task definitions, CloudFormation templates

> **Exam Tip:** If the question mentions "migrating an existing Java/.NET application to containers with minimal code changes," AWS App2Container is the answer.

---

## 14. ECS vs EKS Decision Framework

### Decision Matrix

| Factor | Choose ECS | Choose EKS |
|--------|-----------|-----------|
| **Team Skills** | AWS-native, no K8s experience | Kubernetes expertise exists |
| **Portability** | AWS-only is fine | Multi-cloud or hybrid required |
| **Ecosystem** | Limited third-party needs | Need Helm, Operators, Istio, etc. |
| **Complexity** | Simpler architecture preferred | Willing to manage K8s complexity |
| **Cost** | No control plane cost | $0.10/hr per cluster ($73/mo) |
| **Windows Containers** | Good support | Supported but more complex |
| **Batch Processing** | Good with Fargate Spot | Good with Karpenter + Spot |
| **Service Mesh** | Service Connect (simpler) | Istio, Linkerd, App Mesh |
| **CI/CD** | CodeDeploy blue/green | ArgoCD, Flux, Spinnaker |
| **Secrets** | Native SSM/Secrets Manager integration | Secrets Store CSI Driver |
| **Compliance** | SOC, PCI, HIPAA | Same + custom policies with OPA |

### Quick Decision Flow for Exam

```
Q: Need Kubernetes API compatibility or multi-cloud?
├── Yes → EKS
└── No
    Q: Need simplicity and operational efficiency?
    ├── Yes
    │   Q: Web app only, minimal config?
    │   ├── Yes → App Runner
    │   └── No → ECS + Fargate
    └── No
        Q: Need GPU, specific instance types, or cost optimization?
        ├── Yes → ECS on EC2 or EKS on EC2
        └── No → ECS + Fargate
```

> **Exam Tip:** The exam rarely asks "ECS or EKS?" directly. Instead, it describes a scenario and tests whether you understand the constraints that lead to one or the other. Focus on: Kubernetes requirement → EKS. AWS-native simplicity → ECS. Web app simplicity → App Runner.

---

## 15. Exam Scenarios

### Scenario 1: Microservices Migration

**Question:** A company is migrating a monolithic Java application to microservices on AWS. The development team has no Kubernetes experience. They need auto scaling, blue/green deployments, and the ability to scale to zero for batch processing. They want to minimize operational overhead.

**Answer:** **ECS with Fargate** + **CodeDeploy** for blue/green deployments + **Fargate Spot** for batch processing. No Kubernetes experience needed. Fargate eliminates infrastructure management. CodeDeploy integrates natively with ECS for blue/green.

**Why not EKS?** Team has no K8s experience; ECS is simpler. **Why not App Runner?** Need batch processing and more control over networking.

---

### Scenario 2: Multi-Account Container Registry

**Question:** A company has 20 AWS accounts across 3 regions. Development teams build container images in a central CI/CD account. All other accounts need to pull these images. They want automated vulnerability scanning and image cleanup.

**Answer:** **ECR in central account** with:
- **Cross-account repository policies** for pull access
- **ECR replication** for cross-region
- **Enhanced scanning** (Inspector) with EventBridge for alerts
- **Lifecycle policies** to expire old/untagged images

---

### Scenario 3: High-Performance ML Training

**Question:** A data science team needs to run distributed ML training across multiple GPU instances. They need shared high-throughput storage, the ability to scale nodes on demand, and cost optimization with Spot instances.

**Answer:** **EKS** with:
- **Karpenter** for dynamic node provisioning (GPU instances)
- **FSx for Lustre** CSI driver for high-throughput shared storage
- **Spot instances** with Karpenter's price-capacity optimized selection
- **IRSA or Pod Identity** for S3 access to training data

---

### Scenario 4: Hybrid Container Workloads

**Question:** A healthcare company must process patient data on-premises due to regulations, but wants to use the same container orchestration as their cloud workloads. They use ECS for cloud deployments.

**Answer:** **ECS Anywhere** — install the ECS agent on on-premises servers, register them as EXTERNAL instances in ECS clusters. Same task definitions, same API, same CI/CD pipeline.

---

### Scenario 5: Container Logging Requirements

**Question:** An application running on ECS Fargate needs to send logs to both CloudWatch for operational monitoring and to a Splunk instance for security analysis. Different log fields should go to each destination.

**Answer:** **FireLens with Fluent Bit** sidecar container. Configure multiple outputs in Fluent Bit — one for CloudWatch Logs and one for Splunk HTTP Event Collector. Use Fluent Bit filters to route specific log fields to each destination.

---

### Scenario 6: Secure Container Deployment Pipeline

**Question:** A financial services company needs to ensure only vulnerability-free, signed container images are deployed to production EKS clusters.

**Answer:**
1. **ECR Enhanced Scanning** (Inspector) — continuous vulnerability scanning
2. **EventBridge rule** — block deployment if critical vulnerabilities found
3. **AWS Signer + Notation** — sign images after passing scan
4. **Kyverno/OPA Gatekeeper** admission controller — verify image signatures before pod creation
5. **IRSA** — least-privilege IAM roles per service account

---

### Key Exam Tips Summary

| Topic | Key Point |
|-------|-----------|
| ECR | Lifecycle policies reduce cost; enhanced scanning uses Inspector; pull-through cache for Docker Hub rate limits |
| ECS Task Role vs Execution Role | Task role = app permissions; execution role = agent permissions (pull images, fetch secrets) |
| Placement | binpack = cost; spread = availability; Fargate has no placement strategies |
| Capacity Providers | base + weight for mixing Fargate and Fargate Spot |
| EKS Storage | EBS = ReadWriteOnce (EC2 only); EFS = ReadWriteMany (EC2 + Fargate) |
| Karpenter vs CA | Karpenter = right-sizing, consolidation, faster; CA = cloud-agnostic, ASG-based |
| Fargate | Max 16 vCPU / 120 GB; task-level isolation; no GPU; awsvpc only |
| App Runner | Simplest container service; no scale to zero; VPC Connector for private resources |
| FireLens | Multi-destination logging; Fluent Bit sidecar |
| Security | ECR scanning + image signing + admission controllers + task/pod IAM roles |

---

*End of Article 06 — Containers & Orchestration*
