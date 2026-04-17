# Microservices on AWS

## Introduction

Microservices architecture is a key topic on the AWS Solutions Architect Associate (SAA-C03) exam. AWS provides a rich ecosystem of services specifically designed to build, deploy, and operate microservices at scale. Understanding how to decompose monoliths, choose the right compute and communication patterns, manage data across services, and implement observability is essential for both the exam and real-world architecture.

This article covers microservices principles, compute options, service discovery, API management, inter-service communication (synchronous and asynchronous), data management patterns, service mesh, observability, CI/CD, security, event-driven patterns, CQRS, migration strategies, and the twelve-factor app methodology mapped to AWS services.

---

## Microservices Principles

### What are Microservices?

Microservices are an architectural style where an application is structured as a collection of **loosely coupled, independently deployable services**. Each service:

- Implements a **single business capability**
- Has its **own data store** (database per service pattern)
- Communicates with other services through well-defined APIs
- Can be **deployed, scaled, and updated independently**
- Can be written in **different programming languages** (polyglot)

### Key Principles

| Principle | Description |
|-----------|-------------|
| **Single Responsibility** | Each service does one thing and does it well |
| **Independently Deployable** | Change and deploy a service without affecting others |
| **Decentralized Data Management** | Each service owns its data; no shared databases |
| **Design for Failure** | Services must handle failures in dependent services gracefully |
| **Smart Endpoints, Dumb Pipes** | Business logic lives in services, not in the communication layer |
| **Infrastructure Automation** | CI/CD, IaC, automated testing for each service |
| **Evolutionary Design** | Services can be replaced or rewritten independently |

### Monolith vs Microservices

| Aspect | Monolith | Microservices |
|--------|----------|---------------|
| **Deployment** | Single unit | Independent per service |
| **Scaling** | Scale entire application | Scale individual services |
| **Technology** | Single tech stack | Polyglot (per service) |
| **Data** | Single database | Database per service |
| **Team structure** | One large team | Small, autonomous teams |
| **Failure** | Single point of failure | Isolated failures |
| **Complexity** | Simple deployment, complex codebase | Complex deployment, simpler codebase |

---

## Compute Options for Microservices

### AWS Lambda

- **Best for:** Event-driven microservices, small functions, low traffic or bursty workloads
- **Scaling:** Automatic, per-request
- **Cost:** Pay per invocation + duration
- **Limitation:** 15-minute max execution time
- **Use case:** API backends, event processing, lightweight services

### Amazon ECS with Fargate

- **Best for:** Long-running services, containerized microservices
- **Scaling:** ECS Service Auto Scaling (target tracking, step, scheduled)
- **Cost:** Pay per vCPU + memory per second
- **Advantage:** No server management with Fargate; standard container tooling
- **Use case:** Web services, background workers, API services

### Amazon ECS with EC2

- **Best for:** Container workloads needing GPU, specific instance types, or Spot pricing
- **Scaling:** ECS Service Auto Scaling + EC2 Auto Scaling (or Capacity Providers)
- **Cost:** Pay for EC2 instances
- **Advantage:** Full control over infrastructure, Spot Instances for cost savings
- **Use case:** GPU workloads, high-throughput batch processing

### Amazon EKS (Elastic Kubernetes Service)

- **Best for:** Organizations already using Kubernetes, need portability across environments
- **Scaling:** Horizontal Pod Autoscaler + Cluster Autoscaler (or Karpenter)
- **Cost:** $0.10/hr per cluster + compute (Fargate or EC2)
- **Advantage:** Kubernetes ecosystem, portability, community support
- **Use case:** Complex microservices with Kubernetes-native tooling

### AWS App Runner

- **Best for:** Simple web applications and APIs that need quick deployment from source code or container image
- **Scaling:** Automatic (based on concurrent requests)
- **Cost:** Pay per vCPU + memory per second (scales to zero provisioning cost)
- **Advantage:** Simplest container deployment experience; no infrastructure configuration
- **Use case:** Simple APIs, web apps, prototypes

### Compute Decision Matrix

| Criteria | Lambda | Fargate | ECS/EC2 | EKS | App Runner |
|----------|--------|---------|---------|-----|-----------|
| **Operational overhead** | Lowest | Low | Medium | High | Lowest |
| **Execution time limit** | 15 min | None | None | None | None |
| **Container support** | Images only | Full | Full | Full | Full |
| **Kubernetes** | No | No | No | Yes | No |
| **GPU** | No | No | Yes | Yes | No |
| **Scale to zero** | Yes | No | No | No | Yes (provisioning) |
| **Startup time** | Cold start | 30-60s | Seconds | Seconds | Seconds |
| **Best exam keyword** | "serverless" | "containers, no servers" | "containers, full control" | "Kubernetes" | "simplest container deploy" |

---

## Service Discovery

### The Challenge

In microservices, services need to find each other. Unlike monoliths where components share the same process, microservices communicate over the network. Service instances are dynamic — they start, stop, scale, and their IP addresses change.

### AWS Cloud Map

- **Fully managed service discovery** for cloud resources
- Register any cloud resource (EC2, ECS, Lambda, IP addresses, etc.)
- Services are registered in **namespaces** and **services**
- Supports both **API-based discovery** (DiscoverInstances API) and **DNS-based discovery**
- Integrates natively with ECS and EKS
- Health checks automatically deregister unhealthy instances

### ECS Service Discovery

- Built on top of AWS Cloud Map
- When you create an ECS service with service discovery:
  1. ECS automatically registers task instances in Cloud Map
  2. Other services discover instances via DNS (e.g., `service-a.local`)
  3. ECS deregisters tasks when they stop
- Supports both **A records** (IP) and **SRV records** (IP + port)

### Route 53 Private Hosted Zones

- DNS-based service discovery using private DNS names
- Services register their endpoints in Route 53
- Other services resolve the DNS name to find the endpoint
- Less dynamic than Cloud Map (requires manual or automated updates)
- Use case: Simple service discovery for services with stable endpoints

### Comparison

| Feature | Cloud Map | ECS Service Discovery | Route 53 |
|---------|-----------|----------------------|----------|
| **Registration** | API + ECS/EKS auto | ECS automatic | Manual or API |
| **Discovery** | API + DNS | DNS | DNS |
| **Health checks** | Yes | Yes (via Cloud Map) | Yes |
| **Dynamic** | Very (real-time) | Very (ECS managed) | Less (DNS TTL) |
| **Best for** | Complex microservices | ECS workloads | Simple, stable services |

---

## API Management

### Amazon API Gateway

- **REST API:** Full-featured with caching, throttling, API keys, usage plans, WAF integration
- **HTTP API:** Simpler, cheaper (70% less), faster, supports JWT authorizers natively
- **WebSocket API:** Real-time bidirectional communication
- **Use as:** External-facing API gateway, mobile backend, partner API

### AWS AppSync

- **Managed GraphQL** service
- Combine data from multiple sources in a single API call
- Real-time subscriptions over WebSocket
- **Use as:** GraphQL API, real-time data API, mobile backend

### Application Load Balancer (ALB)

- Layer 7 load balancer with path-based and host-based routing
- Route requests to different microservices based on URL path or hostname
- Integrates with ECS, EKS, EC2, Lambda
- **Use as:** Internal service routing, microservice request distribution

### Internal vs External APIs

| Type | Service | Use Case |
|------|---------|----------|
| **External (public)** | API Gateway | Mobile apps, third-party integrations, web frontends |
| **Internal (service-to-service)** | ALB, Cloud Map, App Mesh | Microservices communicating with each other |
| **GraphQL** | AppSync | Complex data queries, real-time subscriptions |

---

## Inter-Service Communication

### Synchronous Communication

#### REST (HTTP/HTTPS)

- Most common synchronous pattern
- Request-response model
- Services call each other via HTTP endpoints
- Implemented via: API Gateway, ALB, direct HTTP calls
- **Advantage:** Simple, well-understood, debugging tools available
- **Disadvantage:** Tight coupling (caller waits for response), cascade failures

#### gRPC

- High-performance RPC framework using Protocol Buffers
- Binary serialization (smaller payloads, faster than JSON)
- Supports streaming (server, client, bidirectional)
- Requires NLB (Layer 4) on AWS (ALB doesn't fully support HTTP/2 for gRPC — actually ALB does support gRPC now)
- **Advantage:** Performance, strong typing, code generation
- **Use case:** High-throughput service-to-service communication

#### GraphQL (via AppSync)

- Query exactly the data you need (no over-fetching)
- Combine multiple service calls into a single request
- **Advantage:** Flexible queries, reduced network calls
- **Use case:** APIs serving multiple client types (mobile, web, IoT)

### Asynchronous Communication

#### Amazon SQS (Simple Queue Service)

- **Point-to-point** messaging: one producer, one consumer
- Message is consumed and deleted by a single consumer
- **Standard queue:** At-least-once delivery, best-effort ordering, virtually unlimited throughput
- **FIFO queue:** Exactly-once processing, strict ordering, 300 TPS (3,000 with batching)
- **Dead Letter Queue (DLQ):** Messages that fail processing after max retries
- **Visibility timeout:** Time a message is invisible after being read (prevents duplicate processing)
- **Long polling:** Reduce empty responses and cost (wait up to 20 seconds for messages)
- **Use case:** Decouple services, buffer requests, work queues

#### Amazon SNS (Simple Notification Service)

- **Pub/sub** messaging: one publisher, many subscribers
- Message delivered to ALL subscribers of a topic
- Subscribers: SQS, Lambda, HTTP/HTTPS, email, SMS, mobile push
- **Message filtering:** Subscribers receive only messages matching their filter policy
- **FIFO topics:** Ordered, deduplicated delivery to FIFO SQS queues
- **Use case:** Event notifications, fan-out to multiple consumers

#### Amazon EventBridge

- **Serverless event bus** for event-driven architectures
- Event sources: AWS services, custom applications, SaaS integrations
- **Rules:** Filter events and route to targets based on event patterns
- **Schema registry:** Discover and manage event schemas
- **Archive and replay:** Store events and replay them later
- **Targets:** Lambda, SQS, SNS, Step Functions, Kinesis, API Gateway, etc. (20+ targets)
- **Use case:** Complex event routing, SaaS integrations, event-driven microservices

#### Amazon Kinesis Data Streams

- **Real-time streaming** data service
- Ordered records within a shard
- Multiple consumers can read the same stream (enhanced fan-out)
- Retention: 1 to 365 days
- **Use case:** Real-time analytics, log aggregation, IoT data streaming

### Choosing the Right Communication Pattern

| Scenario | Pattern | Service |
|----------|---------|---------|
| Service A needs immediate response from B | Synchronous | REST via ALB/API Gateway |
| Service A sends work for B to process later | Async (queue) | SQS |
| Event needs to reach multiple services | Async (pub/sub) | SNS or EventBridge |
| Complex event routing with filters | Async (event bus) | EventBridge |
| High-volume real-time data stream | Async (streaming) | Kinesis |
| "Fire and forget" notification | Async (pub/sub) | SNS |

### SQS vs SNS vs EventBridge

| Feature | SQS | SNS | EventBridge |
|---------|-----|-----|-------------|
| **Pattern** | Queue (point-to-point) | Pub/Sub (fan-out) | Event Bus (routing) |
| **Consumers** | 1 per message | All subscribers | Matched targets |
| **Filtering** | No (consumer reads all) | Message attribute filters | Event pattern matching |
| **Retry** | Built-in (visibility timeout) | Delivery retry policy | DLQ for failed targets |
| **Ordering** | FIFO available | FIFO available | No ordering guarantee |
| **SaaS integration** | No | No | Yes (Zendesk, Datadog, etc.) |
| **Schema** | No | No | Schema Registry |
| **Archive/Replay** | No (messages deleted) | No | Yes |
| **Use when** | Decouple, buffer | Notify multiple services | Complex routing, SaaS events |

---

## Data Management

### Database Per Service Pattern

Each microservice owns its data and exposes it only through its API. No service directly accesses another service's database.

**Why?**
- Loose coupling: services can change their data schema independently
- Independent scaling: each database scales based on its service's needs
- Technology freedom: each service can use the best database for its needs

**Implementation on AWS:**
| Service Type | Database Choice |
|-------------|----------------|
| User service | RDS (relational data, transactions) |
| Product catalog | DynamoDB (key-value, high read throughput) |
| Search service | OpenSearch (full-text search) |
| Session store | ElastiCache Redis (in-memory, fast) |
| Order history | DynamoDB (flexible schema, scalable) |
| Analytics | Redshift (columnar, analytical queries) |
| Graph relationships | Neptune (graph queries) |

### Eventual Consistency

With database-per-service, data consistency across services cannot rely on ACID transactions. Instead, use **eventual consistency**:

- Service A updates its database and publishes an event
- Service B receives the event and updates its database
- For a brief period, data may be inconsistent across services
- Eventually, all services converge to the same state

### Saga Pattern

For distributed transactions spanning multiple services:

**Orchestration-based (Step Functions):**
- A central orchestrator (Step Functions) tells each service what to do
- If a step fails, the orchestrator runs compensating transactions
- Easier to understand and debug
- Central point of coordination

**Choreography-based (Events):**
- Each service publishes events and reacts to events from other services
- No central coordinator
- More decoupled but harder to debug and track
- Implemented with SNS, EventBridge, or DynamoDB Streams

**Comparison:**
| Feature | Orchestration | Choreography |
|---------|--------------|--------------|
| **Coordinator** | Central (Step Functions) | None (event-driven) |
| **Coupling** | Services coupled to orchestrator | Services decoupled |
| **Visibility** | Easy to track (state machine) | Hard to track (distributed events) |
| **Complexity** | Simpler logic, complex orchestrator | Complex logic, no orchestrator |
| **AWS service** | Step Functions | EventBridge, SNS, SQS |

### Exam Tip

When the question describes a **distributed transaction** across services, the answer is the **Saga pattern**. If it asks for a **managed orchestration solution**, the answer is **Step Functions** (orchestration-based saga).

---

## Service Mesh: AWS App Mesh

### What is a Service Mesh?

A service mesh is a dedicated infrastructure layer that handles service-to-service communication. It provides:

- **Traffic management:** Routing, load balancing, retries, timeouts, circuit breaking
- **Observability:** Metrics, tracing, logging for all service-to-service calls
- **Security:** mTLS (mutual TLS) encryption between services

### AWS App Mesh

- Managed service mesh based on the **Envoy proxy**
- Works with ECS, EKS, EC2, and Fargate
- **Components:**
  - **Mesh:** Logical grouping of services
  - **Virtual Service:** Abstraction of a real service
  - **Virtual Node:** Pointer to a specific service (ECS service, EKS deployment)
  - **Virtual Router:** Routes traffic to virtual nodes based on rules
  - **Virtual Gateway:** Ingress for traffic entering the mesh from outside
- **Envoy Proxy:** Deployed as a sidecar container alongside each service container

### How It Works

```
Service A (container) ←→ Envoy Sidecar ←→ Envoy Sidecar ←→ Service B (container)
                              ↑                    ↑
                         App Mesh Control Plane
```

1. Each service runs with an Envoy sidecar proxy
2. All traffic flows through the sidecar (intercepted transparently)
3. The sidecar handles: routing, retries, timeouts, circuit breaking, mTLS
4. App Mesh control plane configures all sidecars
5. Envoy proxies export metrics to CloudWatch, traces to X-Ray

### Use Cases

- Complex microservices with many service-to-service calls
- Need for traffic shifting (canary, blue-green between service versions)
- mTLS encryption between services
- Centralized observability for all service communication

### Exam Tip

When the question mentions **"service mesh"**, **"Envoy proxy"**, **"traffic management between microservices"**, or **"mTLS between services,"** the answer is AWS App Mesh.

---

## Containerized Microservices: ECS Deep Dive

### Task Definitions

- A **blueprint** for your application (like a Dockerfile + run configuration)
- Defines: container images, CPU/memory, port mappings, environment variables, logging, IAM roles
- Supports **multiple containers** in a single task (main container + sidecars)
- **Task Role:** IAM role for the containers in the task (access to AWS services)
- **Execution Role:** IAM role for ECS agent (pull images from ECR, write logs to CloudWatch)

### Service-to-Service Communication Patterns

| Pattern | Implementation |
|---------|---------------|
| **ALB-based** | Each service behind an ALB; services call each other via ALB DNS |
| **Service Discovery** | ECS Service Discovery (Cloud Map); services resolve DNS names |
| **Service Mesh** | App Mesh + Envoy sidecars; traffic managed by mesh |
| **API Gateway** | External API Gateway routes to different services |

### ECS Networking Modes

| Mode | Description | Use Case |
|------|-------------|----------|
| **awsvpc** | Each task gets its own ENI with private IP | **Recommended** for Fargate and most EC2 |
| **bridge** | Docker bridge network | Legacy, EC2 only |
| **host** | Task uses the host's network | High-performance, EC2 only |
| **none** | No network connectivity | Isolated tasks |

### Key ECS Concepts for Exam

- **Cluster:** Logical grouping of services and tasks
- **Service:** Maintains desired count of tasks, integrates with ALB
- **Task:** Running instance of a task definition
- **Capacity Provider:** Manages the infrastructure (Fargate, Fargate Spot, EC2 ASG)

---

## Observability

### AWS X-Ray Distributed Tracing

- Trace requests as they flow through multiple microservices
- **Service Map:** Visual representation of service dependencies and latency
- **Trace:** End-to-end request path through services
- **Segments:** Per-service contribution to a trace
- **Subsegments:** Granular timing within a service (database calls, HTTP calls)
- **Sampling rules:** Control what percentage of requests are traced
- **Groups:** Filter traces by criteria (error traces, slow traces)
- **Insights:** Automated anomaly detection

**Integration:**
- Lambda: Enable **Active Tracing** in configuration
- ECS/EKS: Run **X-Ray daemon** as a sidecar container
- API Gateway: Enable tracing on the stage
- App Mesh: Envoy proxies automatically send traces to X-Ray

### CloudWatch Container Insights

- Collect, aggregate, and summarize metrics and logs from containerized applications
- Works with ECS, EKS, and Kubernetes on EC2
- Provides: CPU, memory, disk, network metrics at cluster, service, and task level
- **Enhanced observability** with EKS: detailed Kubernetes metrics (pods, nodes, namespaces)
- Publishes metrics to CloudWatch for alarms and dashboards

### App Mesh + Envoy Metrics

- Envoy proxies generate detailed metrics: request count, latency, error rates, connection pools
- Metrics exported to CloudWatch
- Per-service and per-route visibility
- Combined with X-Ray for end-to-end tracing

### Observability Stack Summary

| Layer | Service | What It Provides |
|-------|---------|-----------------|
| **Metrics** | CloudWatch + Container Insights | CPU, memory, request rates, custom metrics |
| **Logs** | CloudWatch Logs | Application logs, structured logging |
| **Traces** | X-Ray | Distributed tracing, service maps |
| **Service mesh** | App Mesh + Envoy | Inter-service traffic metrics |

---

## CI/CD for Microservices

### Pipeline Architecture

Each microservice should have its own CI/CD pipeline:

```
Source (CodeCommit/GitHub)
    ↓
Build (CodeBuild) — build, test, create container image
    ↓
Push Image to ECR
    ↓
Deploy (CodeDeploy / ECS rolling update / EKS)
```

### Key Services

| Service | Role |
|---------|------|
| **AWS CodeCommit** | Git repository (or GitHub, Bitbucket) |
| **AWS CodeBuild** | Build and test code, create Docker images |
| **Amazon ECR** | Container image registry |
| **AWS CodeDeploy** | Deployment automation (rolling, blue-green, canary) |
| **AWS CodePipeline** | Orchestrate the CI/CD pipeline stages |

### Deployment Strategies for Microservices

| Strategy | Description | Risk | Rollback |
|----------|-------------|------|----------|
| **Rolling update** | Replace instances gradually | Low-Medium | Deploy previous version |
| **Blue-Green** | Deploy new version alongside old, switch traffic | Low | Switch back to blue |
| **Canary** | Route small % of traffic to new version, then increase | Lowest | Route 100% back to old |
| **All-at-once** | Replace everything at once | Highest | Deploy previous version |

### ECS Deployment Types

| Type | Description |
|------|-------------|
| **Rolling update** | ECS replaces tasks gradually (default) |
| **Blue-Green (CodeDeploy)** | Deploy new task set, CodeDeploy shifts traffic via ALB |
| **External** | Third-party deployment controller |

### Best Practices

- **Independent pipelines:** Each microservice has its own pipeline
- **Automated testing:** Unit, integration, contract tests in CodeBuild
- **Infrastructure as Code:** CloudFormation/CDK for service infrastructure
- **Immutable artifacts:** Build Docker images with tags (never use `latest` in production)
- **Rollback automation:** CloudWatch Alarms trigger automatic rollback in CodeDeploy

---

## Security for Microservices

### Network Security

| Layer | Control |
|-------|---------|
| **VPC** | Isolate microservices in private subnets |
| **Security Groups** | Per-service firewall rules (allow only required ports between services) |
| **NACLs** | Subnet-level firewall for additional control |
| **VPC Endpoints** | Access AWS services without internet (S3, DynamoDB, ECR, etc.) |
| **App Mesh mTLS** | Encrypt service-to-service traffic |

### IAM Security

| Feature | Description |
|---------|-------------|
| **ECS Task Roles** | Each task (service) gets its own IAM role with minimum permissions |
| **Lambda Execution Roles** | Each Lambda function gets its own IAM role |
| **IRSA (EKS)** | IAM Roles for Service Accounts — per-pod IAM roles in Kubernetes |
| **Service-linked roles** | AWS-managed roles for service operations |

### Service-to-Service Authentication

| Pattern | Implementation |
|---------|---------------|
| **IAM + SigV4** | Services sign requests with AWS credentials; API Gateway IAM auth |
| **mTLS** | Mutual TLS via App Mesh — certificate-based authentication |
| **API Keys** | Simple authentication for internal services (not recommended for security) |
| **JWT tokens** | Services issue/validate JWTs for inter-service authentication |

### Secrets Management

- **AWS Secrets Manager:** Store database credentials, API keys with automatic rotation
- **AWS Systems Manager Parameter Store:** Store configuration values and secrets
- **ECS secrets:** Reference Secrets Manager/Parameter Store values in task definitions
- **Lambda environment variables:** Encrypted with KMS
- **Never hardcode secrets** in container images, code, or task definitions

---

## Event-Driven Microservices

### Architecture Pattern

```
Service A → EventBridge (event bus) → Rule → Service B
                                    → Rule → Service C
                                    → Rule → Service D
```

### How It Works

1. Service A publishes an event to EventBridge (e.g., `OrderCreated`)
2. EventBridge matches the event against rules
3. Matched rules route the event to target services
4. Each target service processes the event independently

### EventBridge for Microservices

- **Event Bus:** Central bus that all services publish to and consume from
- **Custom event bus:** Isolate events by domain or team
- **Event patterns:** Filter events by source, detail-type, and event fields
- **Schema registry:** Auto-discover and track event schemas
- **Archive and replay:** Replay events for debugging or reprocessing

### SNS/SQS for Event-Driven Microservices

- **SNS topic per event type:** `OrderCreated`, `PaymentProcessed`, `ShipmentSent`
- Each consuming service subscribes via SQS queue
- SQS provides buffering, retries, and dead letter queues
- Simple and effective for fan-out patterns

### DynamoDB Streams for Change Data Capture

- Capture all changes to a DynamoDB table
- Trigger Lambda functions on inserts, updates, deletes
- Use for: search index updates, analytics, notifications, cross-service data sync
- Changes are ordered per item and available for 24 hours

---

## CQRS and Event Sourcing Patterns on AWS

### CQRS (Command Query Responsibility Segregation)

Separate the write model (commands) from the read model (queries):

- **Write side:** Optimized for transactional writes (DynamoDB, RDS)
- **Read side:** Optimized for queries (OpenSearch, ElastiCache, materialized views)
- **Sync mechanism:** DynamoDB Streams / EventBridge / Kinesis → Lambda → Read store

### Event Sourcing

Instead of storing current state, store a sequence of events:

1. Every state change is stored as an immutable event
2. Current state is derived by replaying events
3. Events stored in: Kinesis Data Streams, DynamoDB, S3

**Benefits:**
- Complete audit trail
- Can reconstruct state at any point in time
- Events can drive multiple read models

**AWS Implementation:**
- **Event store:** Kinesis Data Streams or DynamoDB (with streams)
- **Event processing:** Lambda, Kinesis Data Analytics
- **Read model projection:** Lambda consuming streams, writing to read-optimized stores
- **Snapshots:** Periodic state snapshots in DynamoDB or S3 to avoid replaying all events

---

## Strangler Fig Pattern for Migration

### The Pattern

Gradually replace a monolithic application with microservices, one component at a time. The pattern is named after the strangler fig tree, which grows around a host tree until the host is completely replaced.

### Implementation on AWS

```
Clients → API Gateway / ALB
              ├── /users → New Microservice (Lambda/ECS)
              ├── /products → New Microservice (Lambda/ECS)
              └── /legacy/* → Monolith (EC2)
```

### Steps

1. **Identify a component** to extract from the monolith
2. **Build the microservice** that replaces that component
3. **Route traffic** for that component to the new microservice (using API Gateway path-based routing or ALB path-based routing)
4. **Repeat** for the next component
5. Eventually, all traffic goes to microservices; the monolith can be decommissioned

### Key AWS Services

- **API Gateway:** Route different paths to different backends
- **ALB:** Path-based routing to different target groups (monolith + microservices)
- **Route 53 weighted routing:** Gradually shift traffic from monolith to microservices

### Exam Tip

When the question describes **"incrementally migrating from a monolith to microservices"** or **"migrating without rewriting everything at once,"** the answer is the Strangler Fig pattern.

---

## Decomposition Patterns

### By Business Capability

Decompose based on what the business does:

| Business Capability | Microservice |
|-------------------|-------------|
| User management | User Service |
| Product catalog | Product Service |
| Order processing | Order Service |
| Payment processing | Payment Service |
| Shipping | Shipping Service |
| Notification | Notification Service |

### By Subdomain (Domain-Driven Design)

Use DDD bounded contexts to define service boundaries:

- **Core domain:** The differentiating business capability (invest most here)
- **Supporting domain:** Necessary but not differentiating
- **Generic domain:** Commoditized capabilities (use SaaS or off-the-shelf)

### Anti-Patterns

| Anti-Pattern | Description |
|-------------|-------------|
| **Distributed monolith** | Services are tightly coupled and must be deployed together |
| **Shared database** | Multiple services share a database, creating tight coupling |
| **Too fine-grained** | Services are too small, causing excessive network overhead |
| **Too coarse-grained** | Services are too large, negating microservices benefits |
| **Chatty services** | Services make too many synchronous calls to each other |

---

## Twelve-Factor App Methodology on AWS

The twelve-factor app methodology is a set of best practices for building modern, cloud-native applications. Here's how each factor maps to AWS:

| Factor | Principle | AWS Implementation |
|--------|-----------|-------------------|
| **I. Codebase** | One codebase per service, tracked in version control | CodeCommit, GitHub |
| **II. Dependencies** | Explicitly declare and isolate dependencies | Dockerfile, requirements.txt, package.json |
| **III. Config** | Store config in the environment, not in code | Parameter Store, Secrets Manager, Environment Variables |
| **IV. Backing Services** | Treat backing services as attached resources | RDS, DynamoDB, ElastiCache, S3 (connection strings via config) |
| **V. Build, Release, Run** | Strictly separate build, release, and run stages | CodeBuild (build), CodePipeline (release), ECS/Lambda (run) |
| **VI. Processes** | Execute the app as stateless processes | Lambda (stateless), Fargate tasks (stateless), externalize state to DynamoDB/ElastiCache |
| **VII. Port Binding** | Export services via port binding | ECS task port mappings, ALB target groups |
| **VIII. Concurrency** | Scale out via the process model | ECS Service Auto Scaling, Lambda concurrency, ASG |
| **IX. Disposability** | Maximize robustness with fast startup and graceful shutdown | ECS task stop signals, Lambda cleanup, ALB deregistration delay |
| **X. Dev/Prod Parity** | Keep development, staging, and production as similar as possible | CloudFormation/CDK for identical environments, same container images |
| **XI. Logs** | Treat logs as event streams | CloudWatch Logs (stdout/stderr from containers), Kinesis for log streaming |
| **XII. Admin Processes** | Run admin/management tasks as one-off processes | ECS RunTask (one-off), Lambda, SSM Run Command |

---

## Common Exam Scenarios

### Scenario 1: Decouple Services

**Question:** "Two microservices are directly calling each other via HTTP. When Service B goes down, Service A also fails. How to make this more resilient?"

**Answer:** Use Amazon SQS between the services. Service A sends messages to an SQS queue; Service B processes messages from the queue. If Service B is down, messages accumulate in the queue and are processed when Service B recovers.

### Scenario 2: Fan-Out Events

**Question:** "When an order is placed, multiple services need to be notified (inventory, shipping, notifications). How to architect this?"

**Answer:** Service publishes an `OrderCreated` event to an SNS topic. Each consuming service has an SQS queue subscribed to the topic (SNS → SQS fan-out pattern). Alternatively, use EventBridge for more complex routing.

### Scenario 3: Service Discovery for ECS

**Question:** "Multiple ECS services need to discover and communicate with each other without hardcoding IP addresses."

**Answer:** Use ECS Service Discovery (backed by AWS Cloud Map). Each service registers a DNS name (e.g., `service-a.internal`). Other services resolve this DNS name to find the current IP addresses of running tasks.

### Scenario 4: Migrate from Monolith

**Question:** "A company wants to gradually decompose their monolith into microservices without a big-bang rewrite."

**Answer:** Use the Strangler Fig pattern. Deploy an ALB (or API Gateway) in front of the monolith. Gradually route paths to new microservices while the monolith handles remaining functionality.

### Scenario 5: Distributed Tracing

**Question:** "A request goes through 10 microservices. The team needs to identify which service is causing latency."

**Answer:** AWS X-Ray distributed tracing. Enable X-Ray in all services (Lambda active tracing, X-Ray daemon sidecar for ECS). The service map shows latency per service; traces show the full request path.

### Scenario 6: Database Per Service

**Question:** "A team is building microservices. Should they use a shared database or separate databases?"

**Answer:** Database per service pattern. Each microservice owns its data store. Use eventual consistency and event-driven patterns (DynamoDB Streams, EventBridge) to synchronize data between services when needed.

### Scenario 7: Container Deployment Strategy

**Question:** "A company wants to deploy a new version of their ECS service with minimal risk."

**Answer:** Blue-green deployment with CodeDeploy. Deploy the new task definition as a new target group. CodeDeploy shifts traffic from the old to the new target group. If issues are detected (CloudWatch Alarms), CodeDeploy automatically rolls back.

### Scenario 8: Secure Inter-Service Communication

**Question:** "All communication between microservices must be encrypted."

**Answer:** AWS App Mesh with mTLS enabled. Envoy sidecar proxies handle TLS termination and origination, encrypting all service-to-service traffic with mutual TLS authentication.

### Scenario 9: Complex Event Routing

**Question:** "Different event types need to be routed to different microservices based on event content."

**Answer:** Amazon EventBridge. Define event rules with patterns that match specific event attributes. Each rule routes matched events to the appropriate target service (Lambda, SQS, Step Functions, etc.).

### Scenario 10: Container Orchestration Choice

**Question:** "A company currently uses Kubernetes on-premises and wants to move to AWS with minimal changes."

**Answer:** Amazon EKS — Managed Kubernetes that's compatible with existing Kubernetes manifests, Helm charts, and tooling.

---

## Summary Quick Reference

| Topic | Key Service(s) | Exam Trigger |
|-------|----------------|-------------|
| Serverless microservices | Lambda, API Gateway | "no servers", "event-driven" |
| Container microservices | ECS/Fargate, EKS | "containers", "Docker", "Kubernetes" |
| Service discovery | Cloud Map, ECS SD | "find services", "dynamic endpoints" |
| Async communication | SQS, SNS, EventBridge | "decouple", "async", "event-driven" |
| Distributed transaction | Step Functions (Saga) | "transaction across services" |
| Service mesh | App Mesh | "Envoy", "mTLS", "traffic management" |
| Distributed tracing | X-Ray | "trace requests", "identify latency" |
| Container metrics | Container Insights | "container monitoring" |
| CI/CD | CodePipeline, CodeDeploy | "automated deployment", "blue-green" |
| Migration from monolith | Strangler Fig + ALB | "gradually migrate", "incremental" |

---

*Next Article: [Exam Day Tips & Last-Minute Review](33-exam-day-tips.md)*
