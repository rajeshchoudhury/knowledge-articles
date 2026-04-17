# Application Modernization — AWS SAP-C02 Domain 3 Deep Dive

## Table of Contents
1. [Modernization Patterns](#1-modernization-patterns)
2. [Monolith to Microservices Decomposition](#2-monolith-to-microservices-decomposition)
3. [Containerization Strategies](#3-containerization-strategies)
4. [Serverless Transformation Patterns](#4-serverless-transformation-patterns)
5. [Event-Driven Architecture Migration](#5-event-driven-architecture-migration)
6. [API-First Modernization](#6-api-first-modernization)
7. [Data Layer Modernization](#7-data-layer-modernization)
8. [Mainframe Modernization Approaches](#8-mainframe-modernization-approaches)
9. [Application Portfolio Assessment for Modernization](#9-application-portfolio-assessment-for-modernization)
10. [Modernization with AWS Services](#10-modernization-with-aws-services)
11. [Exam Scenarios](#11-exam-scenarios)

---

## 1. Modernization Patterns

### 1.1 Strangler Fig Pattern

**Concept:** Incrementally replace parts of a monolithic application by routing new functionality to new services while gradually migrating old functionality. Named after the strangler fig tree that grows around a host tree.

```
Phase 1: Initial State
┌─────────────────────────────────┐
│          Monolith               │
│  ┌───────┐ ┌───────┐ ┌───────┐ │
│  │Orders │ │Users  │ │Search │ │
│  │       │ │       │ │       │ │
│  └───────┘ └───────┘ └───────┘ │
└─────────────────────────────────┘
         ▲ All traffic
         │
    ┌────┴────┐
    │  Client │
    └─────────┘

Phase 2: Extract First Service (Users)
┌──────────────────────┐    ┌──────────────┐
│     Monolith         │    │  Users       │
│  ┌───────┐ ┌───────┐ │    │  Microservice│
│  │Orders │ │Search │ │    │  (ECS/EKS)   │
│  └───────┘ └───────┘ │    └──────▲───────┘
└──────────▲───────────┘           │
           │                       │
    ┌──────┴───────────────────────┴──┐
    │    API Gateway / ALB (Router)    │
    │    /api/orders → Monolith        │
    │    /api/users  → New Service     │
    │    /api/search → Monolith        │
    └──────────────▲───────────────────┘
                   │
              ┌────┴────┐
              │  Client │
              └─────────┘

Phase 3: Extract More Services
┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐
│ Orders   │  │ Users    │  │ Search   │  │ Payments │
│ Service  │  │ Service  │  │ Service  │  │ Service  │
│ (ECS)    │  │ (ECS)    │  │(OpenSrch)│  │ (Lambda) │
└──────────┘  └──────────┘  └──────────┘  └──────────┘
     ▲             ▲             ▲             ▲
     └─────────────┴─────────────┴─────────────┘
                          │
              ┌───────────┴───────────┐
              │  API Gateway / ALB     │
              │  (All traffic routed   │
              │   to microservices)    │
              └───────────▲───────────┘
                          │
                     ┌────┴────┐
                     │  Client │
                     └─────────┘

Phase 4: Monolith Decommissioned ✓
```

**Implementation with AWS:**
- **Router:** API Gateway or Application Load Balancer with path-based routing
- **Migration Hub Refactor Spaces:** Manages the incremental routing
- **New services:** ECS, EKS, or Lambda
- **Shared data:** Eventually migrate to per-service databases

**Best Practices:**
- Start with the least-coupled module
- Extract functionality by bounded context (Domain-Driven Design)
- Use feature flags to gradually shift traffic
- Keep the monolith running until all functionality is extracted
- Implement an anti-corruption layer between old and new

### 1.2 Anti-Corruption Layer (ACL)

**Concept:** A translation layer between old and new systems that prevents the new system from being contaminated by the old system's data models and concepts.

```
Old System (Legacy)            Anti-Corruption Layer           New System
┌──────────────────┐          ┌────────────────────┐         ┌──────────────┐
│  CustomerRecord  │          │  Translator/Adapter │         │  Customer    │
│  {                │          │                    │         │  {            │
│    CUST_ID: 123   │─────────▶│  Transforms:       │────────▶│   id: "c123" │
│    CUST_NM: "JOE" │          │  - Field mapping   │         │   name: "Joe"│
│    CUST_ADDR1:    │          │  - Data conversion │         │   address: { │
│     "123 MAIN"    │          │  - Validation      │         │     street:  │
│    ACCT_STAT: "A" │          │  - Error handling  │         │     "123 Main│
│  }                │          │                    │         │   }          │
└──────────────────┘          └────────────────────┘         │   status:    │
                                                              │    "active"  │
                                                              │  }           │
                                                              └──────────────┘
```

**Implementation:**
- API layer that translates between old and new data formats
- Queue-based integration (SQS) with transformer Lambda
- EventBridge pipe with input transformation
- AWS AppSync with resolvers that translate

### 1.3 Branch by Abstraction

**Concept:** Introduce an abstraction layer in the existing codebase, then build a new implementation behind it, and finally switch from old to new.

```
Step 1: Current State
┌───────────────────┐
│  Application Code │
│       │           │
│       ▼           │
│  ┌──────────────┐ │
│  │ Old Payment  │ │
│  │ Module       │ │
│  └──────────────┘ │
└───────────────────┘

Step 2: Introduce Abstraction
┌───────────────────┐
│  Application Code │
│       │           │
│       ▼           │
│  ┌──────────────┐ │
│  │ Payment      │ │
│  │ Interface    │ │
│  └──────┬───────┘ │
│         │         │
│  ┌──────▼───────┐ │
│  │ Old Payment  │ │
│  │ Module       │ │
│  └──────────────┘ │
└───────────────────┘

Step 3: Build New Implementation
┌───────────────────┐
│  Application Code │
│       │           │
│       ▼           │
│  ┌──────────────┐ │
│  │ Payment      │ │
│  │ Interface    │ │
│  └──┬────────┬──┘ │
│     │ toggle │    │
│  ┌──▼──┐ ┌──▼──┐ │
│  │ Old │ │ New │ │
│  │     │ │(AWS)│ │
│  └─────┘ └─────┘ │
└───────────────────┘

Step 4: Switch to New, Remove Old
┌───────────────────┐
│  Application Code │
│       │           │
│       ▼           │
│  ┌──────────────┐ │
│  │ New Payment  │ │
│  │ Service      │ │
│  │ (Lambda +    │ │
│  │  Stripe API) │ │
│  └──────────────┘ │
└───────────────────┘
```

### 1.4 Pattern Comparison

| Pattern | Risk | Speed | Complexity | Best For |
|---|---|---|---|---|
| Strangler Fig | Low | Gradual | Medium | Web applications with URL-based routing |
| Anti-Corruption Layer | Low | Gradual | Medium | Legacy integration with new services |
| Branch by Abstraction | Low | Medium | Low | Internal module replacement |
| Big Bang Rewrite | HIGH | Fast (if works) | High | Small apps only (NOT recommended for large) |

> **Exam Tip:** Strangler fig is the most commonly tested pattern. When the exam says "incrementally modernize" or "gradually replace," think strangler fig with API Gateway or ALB routing.

---

## 2. Monolith to Microservices Decomposition

### 2.1 Domain-Driven Design (DDD) for Decomposition

**Bounded Contexts:** Each microservice should own a distinct business domain.

```
E-Commerce Monolith Decomposition:

Bounded Contexts (Microservices):
┌─────────────┐  ┌─────────────┐  ┌─────────────┐
│  Product     │  │  Order      │  │  Customer   │
│  Catalog     │  │  Management │  │  Management │
│  ┌─────────┐ │  │  ┌─────────┐│  │  ┌─────────┐│
│  │Products │ │  │  │Orders   ││  │  │Customers││
│  │Category │ │  │  │Items    ││  │  │Addresses││
│  │Reviews  │ │  │  │Payments ││  │  │Prefs    ││
│  └─────────┘ │  │  └─────────┘│  │  └─────────┘│
│  DynamoDB    │  │  Aurora PG   │  │  DynamoDB   │
└─────────────┘  └─────────────┘  └─────────────┘

┌─────────────┐  ┌─────────────┐  ┌─────────────┐
│  Inventory   │  │  Shipping   │  │  Notifica-  │
│  Management  │  │  & Delivery │  │  tions      │
│  ┌─────────┐ │  │  ┌─────────┐│  │  ┌─────────┐│
│  │Stock    │ │  │  │Shipments││  │  │Templates││
│  │Warehouses│ │  │  │Tracking ││  │  │Channels ││
│  └─────────┘ │  │  └─────────┘│  │  └─────────┘│
│  Aurora MySQL│  │  DynamoDB   │  │  SES+SNS    │
└─────────────┘  └─────────────┘  └─────────────┘
```

### 2.2 Decomposition Strategies

**Strategy 1: Decompose by Business Capability**
- Identify core business capabilities (catalog, ordering, payment)
- Each capability becomes a microservice
- Services own their data

**Strategy 2: Decompose by Subdomain**
- Core domain: Primary business value (keep in-house)
- Supporting domain: Necessary but not differentiating
- Generic domain: Common functionality (may use SaaS)

**Strategy 3: Decompose by Data**
- Identify tables used by single vs multiple features
- Group tables by access patterns
- Service boundary = data boundary

### 2.3 Database Per Service Pattern

```
BEFORE (Shared Database):
┌─────────┐  ┌─────────┐  ┌─────────┐
│ Service │  │ Service │  │ Service │
│    A    │  │    B    │  │    C    │
└────┬────┘  └────┬────┘  └────┬────┘
     │            │            │
     └────────────┼────────────┘
                  │
           ┌──────▼──────┐
           │  Shared     │   ← Problem: tight coupling,
           │  Database   │     schema changes affect all
           └─────────────┘

AFTER (Database Per Service):
┌─────────┐  ┌─────────┐  ┌─────────┐
│ Service │  │ Service │  │ Service │
│    A    │  │    B    │  │    C    │
└────┬────┘  └────┬────┘  └────┬────┘
     │            │            │
┌────▼────┐  ┌────▼────┐  ┌────▼────┐
│ DB A    │  │ DB B    │  │ DB C    │  ← Each service
│(DynamoDB)│  │(Aurora) │  │(Redis)  │    owns its data
└─────────┘  └─────────┘  └─────────┘

Communication between services: API calls or events (not shared DB)
```

### 2.4 Inter-Service Communication

| Pattern | Mechanism | AWS Service | Use Case |
|---|---|---|---|
| **Synchronous** | REST API | API Gateway + ALB | Request/response |
| **Synchronous** | gRPC | ALB + ECS | Low-latency internal |
| **Asynchronous** | Message queue | SQS | Decoupled processing |
| **Asynchronous** | Pub/sub | SNS | Fan-out notifications |
| **Asynchronous** | Event bus | EventBridge | Event-driven routing |
| **Asynchronous** | Streaming | Kinesis | Real-time data streams |
| **Choreography** | Events | EventBridge + SQS | Distributed workflows |
| **Orchestration** | Workflow | Step Functions | Complex workflows |

### 2.5 Saga Pattern for Distributed Transactions

```
Order Saga (Choreography):

1. Order Service         2. Payment Service      3. Inventory Service
   creates order ──────▶    charges card ────────▶   reserves stock
   (OrderCreated event)    (PaymentProcessed)      (StockReserved)
                                                          │
                                                          ▼
                           4. Shipping Service
                              creates shipment
                              (ShipmentCreated)

Compensating transactions (if step 3 fails):
3. Inventory Service: StockReservationFailed ──▶
2. Payment Service: Refund payment ──▶
1. Order Service: Cancel order

AWS Implementation:
- EventBridge for events
- SQS for reliable delivery
- Step Functions for orchestration variant
- DynamoDB for each service's state
```

---

## 3. Containerization Strategies

### 3.1 Lift and Shift to Containers

**Step 1:** Containerize the existing application as-is (monolith in a container)

```
BEFORE:                          AFTER:
┌──────────────────┐            ┌──────────────────┐
│  EC2 Instance    │            │  ECS / EKS       │
│  ┌──────────────┐│            │  ┌──────────────┐│
│  │ Monolith App ││            │  │ Container    ││
│  │ (Java WAR)   ││   ────▶   │  │ (Monolith)   ││
│  │ + Tomcat     ││            │  │ FROM tomcat  ││
│  │ + OS deps    ││            │  │ COPY app.war ││
│  └──────────────┘│            │  └──────────────┘│
│  Amazon Linux    │            │  Fargate / EC2   │
└──────────────────┘            └──────────────────┘

Dockerfile:
FROM tomcat:9-jdk11
COPY app.war /usr/local/tomcat/webapps/
EXPOSE 8080
```

**Benefits of containerizing first:**
- Standardized deployment (CI/CD)
- Consistent environments (dev/staging/prod)
- Auto-scaling with ECS/EKS
- Foundation for later decomposition
- Reduced operational complexity vs. managing VMs

### 3.2 AWS App2Container (A2C)

**What:** Automated tool to containerize existing Java and .NET applications.

```
A2C Workflow:
┌──────────────────┐
│ 1. Discover      │  app2container inventory
│    running apps  │
└────────┬─────────┘
         │
┌────────▼─────────┐
│ 2. Analyze       │  app2container analyze --application-id <id>
│    dependencies  │
└────────┬─────────┘
         │
┌────────▼─────────┐
│ 3. Containerize  │  app2container containerize --application-id <id>
│    (Dockerfile   │  → Generates Dockerfile, build artifacts
│     + artifacts) │
└────────┬─────────┘
         │
┌────────▼─────────┐
│ 4. Deploy        │  app2container generate app-deployment
│    to ECS/EKS    │  → CloudFormation template for ECS/EKS
└──────────────────┘
```

### 3.3 Container Orchestration Decision

| Factor | ECS | EKS | Fargate |
|---|---|---|---|
| **Complexity** | Lower | Higher | Lowest |
| **Kubernetes needed** | No | Yes | Both ECS & EKS |
| **Multi-cloud** | No | Yes (K8s portable) | AWS only |
| **Vendor lock-in** | Higher | Lower | Medium |
| **Pricing** | EC2 only | EC2 + $0.10/hr control plane | Per vCPU/memory |
| **Ops overhead** | Medium | High | Low |
| **Best for** | AWS-native | K8s expertise, multi-cloud | Minimal ops |

### 3.4 Migration Path: VMs → Containers → Microservices

```
Phase 1 (Month 1-3):     Phase 2 (Month 4-8):      Phase 3 (Month 9-18):
Rehost to EC2             Containerize               Decompose
┌──────────┐             ┌──────────┐               ┌───┐ ┌───┐ ┌───┐
│ Monolith │  ──────▶    │Container │   ──────▶     │ A │ │ B │ │ C │
│ on EC2   │             │on ECS    │               │   │ │   │ │   │
│          │             │(Fargate) │               └───┘ └───┘ └───┘
└──────────┘             └──────────┘               Microservices
                                                     on ECS/EKS

Each phase delivers value:
Phase 1: Off on-premises, in AWS
Phase 2: CI/CD, auto-scaling, consistent deploys
Phase 3: Independent scaling, polyglot, team autonomy
```

---

## 4. Serverless Transformation Patterns

### 4.1 Common Serverless Patterns

**Pattern 1: API Backend**
```
Traditional:                    Serverless:
Client → EC2 → RDS             Client → API GW → Lambda → DynamoDB
```

**Pattern 2: Web Application**
```
Traditional:                    Serverless:
Client → ALB → EC2 → RDS       Client → CloudFront → S3 (static)
                                       → API GW → Lambda → Aurora SL
```

**Pattern 3: Batch Processing**
```
Traditional:                    Serverless:
Cron → EC2 → Process → DB      EventBridge → Lambda → Process → DynamoDB
                                Schedule rule     or Step Functions
```

**Pattern 4: Event Processing**
```
Traditional:                    Serverless:
App → Queue → EC2 consumer      App → SQS → Lambda → DynamoDB
                                App → Kinesis → Lambda → S3
```

**Pattern 5: File Processing**
```
Traditional:                    Serverless:
SFTP → EC2 → Process → DB      S3 event → Lambda → Process → DynamoDB
                                Transfer Family → S3 → Lambda → DynamoDB
```

### 4.2 Serverless Architecture Example

```
Full Serverless E-Commerce:

┌──────────┐   ┌──────────┐   ┌──────────────────────────────────────┐
│ CloudFrnt│──▶│   S3     │   │ API Gateway                          │
│          │   │ (static  │   │  /products  → Lambda → DynamoDB      │
│          │   │  React)  │   │  /orders    → Lambda → Aurora SLv2   │
│          │   └──────────┘   │  /search    → Lambda → OpenSearch    │
│          │                  │  /cart       → Lambda → ElastiCache   │
└──────────┘                  └──────────────────────────────────────┘
                                        │
                              ┌─────────▼──────────┐
                              │ Step Functions      │
                              │ (Order Workflow)    │
                              │  1. Validate order  │
                              │  2. Process payment │
                              │  3. Reserve stock   │
                              │  4. Send confirm    │
                              └─────────────────────┘
                                        │
                              ┌─────────▼──────────┐
                              │ EventBridge         │
                              │  OrderPlaced ──▶ Lambda (analytics)
                              │               ──▶ Lambda (email via SES)
                              │               ──▶ Lambda (inventory update)
                              └────────────────────┘
```

### 4.3 Lambda Considerations for Modernization

| Consideration | Details |
|---|---|
| **Cold starts** | 100ms-10s depending on runtime and VPC. Use Provisioned Concurrency for latency-sensitive. |
| **Execution limit** | 15 minutes max. Use Step Functions for longer workflows. |
| **Memory/CPU** | 128 MB - 10,240 MB. CPU scales linearly with memory. |
| **Concurrency** | Default 1,000 per region (can increase). Use reserved concurrency for critical functions. |
| **Payload size** | 6 MB sync (API Gateway), 256 KB async. Use S3 for large payloads. |
| **VPC access** | Adds cold start time. Use VPC endpoints. Hyperplane ENI (since 2019) helps. |
| **State** | Stateless — use DynamoDB/ElastiCache for state. |
| **Package size** | 50 MB zipped, 250 MB unzipped. Use layers or container images (10 GB). |

---

## 5. Event-Driven Architecture Migration

### 5.1 From Synchronous to Event-Driven

```
BEFORE (Synchronous — Tight Coupling):
┌─────────┐  HTTP  ┌─────────┐  HTTP  ┌─────────┐  HTTP  ┌─────────┐
│ Order   │───────▶│ Payment │───────▶│Inventory│───────▶│Shipping │
│ Service │◀───────│ Service │◀───────│ Service │◀───────│ Service │
└─────────┘        └─────────┘        └─────────┘        └─────────┘
Problem: If any service is down, the entire chain fails

AFTER (Event-Driven — Loose Coupling):
┌─────────┐  event  ┌──────────────┐  event  ┌─────────┐
│ Order   │────────▶│ EventBridge  │────────▶│ Payment │
│ Service │         │              │         │ Service │
└─────────┘         │              │         └─────────┘
                    │              │  event  ┌─────────┐
                    │              │────────▶│Inventory│
                    │              │         │ Service │
                    │              │         └─────────┘
                    │              │  event  ┌─────────┐
                    │              │────────▶│Shipping │
                    └──────────────┘         │ Service │
                                            └─────────┘
Benefit: Services are independent; failures are isolated
```

### 5.2 Event-Driven Patterns on AWS

| Pattern | AWS Services | Use Case |
|---|---|---|
| **Event Bus** | EventBridge | Route events by rules to targets |
| **Message Queue** | SQS | Point-to-point, guaranteed delivery |
| **Pub/Sub** | SNS | Fan-out to multiple subscribers |
| **Event Streaming** | Kinesis Data Streams | Real-time ordered event processing |
| **Event Sourcing** | Kinesis + DynamoDB | Replay events, audit trail |
| **CQRS** | DynamoDB + OpenSearch | Separate read/write models |
| **Workflow** | Step Functions | Multi-step orchestration |

### 5.3 CQRS (Command Query Responsibility Segregation)

```
                    ┌──────────────┐
    Writes ────────▶│  Command     │──────▶ DynamoDB (optimized for writes)
    (POST/PUT)      │  Handler     │           │
                    └──────────────┘           │ DynamoDB Stream
                                               ▼
                                        ┌──────────────┐
                                        │   Lambda     │──────▶ OpenSearch
                                        │ (Projector)  │   (optimized for
                                        └──────────────┘    complex queries)
                                                                  ▲
    Reads ─────────────────────────────────────────────────────────┘
    (GET/search)
```

---

## 6. API-First Modernization

### 6.1 API Gateway as Modernization Layer

```
Legacy Application (No APIs)           Modernized (API Layer)
┌─────────────────────┐              ┌──────────────────────────┐
│ Browser ──▶ Server  │              │ API Gateway              │
│ (server-rendered    │   ──────▶    │  │                       │
│  HTML pages)        │              │  ├── /api/v1/products    │
│                     │              │  │   → Lambda (new)      │
│ Tightly coupled     │              │  ├── /api/v1/orders      │
│ No mobile support   │              │  │   → Legacy (VPC Link) │
│ No partner access   │              │  └── /api/v1/customers   │
└─────────────────────┘              │      → Lambda (new)      │
                                     └──────────────────────────┘
                                     
Benefits:
- Mobile apps can now consume APIs
- Partners get API access (with API keys)
- Gradual migration: some APIs → new, some → legacy
- Rate limiting, throttling, authentication
```

### 6.2 API Gateway Integration Patterns

| Backend | Integration Type | Use Case |
|---|---|---|
| Lambda | Lambda proxy | New serverless functions |
| EC2/ECS (ALB) | HTTP proxy / VPC Link | Existing container/VM services |
| AWS Services | AWS integration | Direct S3, DynamoDB, SQS access |
| Legacy on-prem | HTTP proxy via VPN | During migration |

### 6.3 GraphQL Modernization with AppSync

```
Multiple REST APIs                      Single GraphQL Endpoint
┌─────────┐ ┌─────────┐ ┌─────────┐   ┌──────────────────────────┐
│/products│ │/orders  │ │/reviews │   │  AWS AppSync              │
│  API    │ │  API    │ │  API    │   │  ┌──────────────────────┐ │
└─────────┘ └─────────┘ └─────────┘   │  │ GraphQL Schema       │ │
3 requests to render one page          │  │ type Product {       │ │
                                       │  │   name, price,       │ │
           ──────▶                     │  │   orders, reviews    │ │
                                       │  │ }                    │ │
                                       │  └──────┬─────┬────────┘ │
                                       │  Resolvers:   │         │
                                       │  DynamoDB  Lambda  HTTP │
                                       └──────────────────────────┘
                                       1 request gets all data
```

---

## 7. Data Layer Modernization

### 7.1 RDBMS to Purpose-Built Databases

```
Monolithic Database                     Purpose-Built Databases
┌───────────────────────┐              ┌────────────────────┐
│  Single Oracle DB     │              │ Product Catalog    │
│  ┌─────────────────┐  │              │ → DynamoDB         │
│  │ Products        │  │              │ (key-value, scale) │
│  │ Orders          │  │              ├────────────────────┤
│  │ Customers       │  │   ──────▶    │ Orders             │
│  │ Sessions        │  │              │ → Aurora PostgreSQL │
│  │ Analytics       │  │              │ (ACID, complex SQL)│
│  │ Search Index    │  │              ├────────────────────┤
│  │ User Prefs      │  │              │ Sessions           │
│  └─────────────────┘  │              │ → ElastiCache Redis│
│  $2M/year license     │              │ (millisecond reads)│
└───────────────────────┘              ├────────────────────┤
                                       │ Analytics          │
                                       │ → Redshift         │
                                       │ (columnar, BI)     │
                                       ├────────────────────┤
                                       │ Search             │
                                       │ → OpenSearch       │
                                       │ (full-text search) │
                                       └────────────────────┘
                                       ~$200K/year total
```

### 7.2 Purpose-Built Database Selection

| Access Pattern | Database | Why |
|---|---|---|
| Key-value lookups | DynamoDB | Single-digit millisecond at any scale |
| Complex queries, joins, transactions | Aurora (MySQL/PostgreSQL) | ACID, SQL compatibility |
| Caching, sessions, leaderboards | ElastiCache (Redis/Memcached) | Microsecond latency |
| Full-text search | OpenSearch Service | Inverted index, aggregations |
| Graph traversal (social, fraud) | Neptune | Graph queries (Gremlin, SPARQL) |
| Time-series (IoT, metrics) | Timestream | Time-series optimized |
| Ledger (immutable, verifiable) | QLDB | Cryptographically verifiable |
| Wide-column (Cassandra-like) | Keyspaces | CQL compatible, managed |
| Document (MongoDB-like) | DocumentDB | MongoDB compatible, managed |
| Data warehouse (analytics) | Redshift | Columnar, MPP, BI |
| Data lake queries | Athena + S3 | Serverless SQL on S3 |

### 7.3 Data Migration Patterns

**Pattern 1: Database per Service (Clean Split)**
```
Single DB → Identify tables per domain → Migrate to separate databases
```

**Pattern 2: Shared Database with Schemas**
```
Single DB → Create schemas per service → Enforce access boundaries → Eventually split
```

**Pattern 3: Event-Sourced Migration**
```
Legacy DB → Capture changes as events → Build new materialized views in purpose-built DB
```

---

## 8. Mainframe Modernization Approaches

### 8.1 AWS Mainframe Modernization Service

AWS offers two patterns:

**Pattern 1: Automated Refactoring (Blu Age)**
```
COBOL / PL/I Code           Blu Age                 Java on AWS
┌──────────────────┐       ┌──────────────────┐     ┌──────────────────┐
│  COBOL programs  │──────▶│  Automated       │────▶│  Java Spring     │
│  JCL jobs        │       │  Code Conversion │     │  Boot apps       │
│  CICS screens    │       │  (Blu Age engine)│     │  Batch (AWS Batch│
│  DB2 / VSAM      │       │                  │     │  or Step Funcs)  │
│                  │       │  Generates Java   │     │  Angular UI      │
│                  │       │  + Angular        │     │  Aurora PostgreSQL│
└──────────────────┘       └──────────────────┘     └──────────────────┘
```

**Pattern 2: Replatform (Micro Focus)**
```
COBOL / PL/I Code           Micro Focus             EC2 on AWS
┌──────────────────┐       ┌──────────────────┐     ┌──────────────────┐
│  COBOL programs  │──────▶│  Recompile for   │────▶│  COBOL runs on   │
│  JCL jobs        │       │  x86 Linux/Win   │     │  EC2 (Linux)     │
│  CICS screens    │       │  (Micro Focus    │     │  Same COBOL code │
│  DB2 / VSAM      │       │   Enterprise     │     │  DB2 → RDS/Aurora│
│                  │       │   Server)        │     │  VSAM → RDS/Files│
└──────────────────┘       └──────────────────┘     └──────────────────┘
```

### 8.2 Mainframe Modernization Decision

| Approach | Timeline | Risk | Cost | Code Changes |
|---|---|---|---|---|
| **Replatform (Micro Focus)** | 6-18 months | Low | Medium | Minimal |
| **Automated Refactor (Blu Age)** | 12-24 months | Medium | High | Automated |
| **Manual Rewrite** | 24-48 months | High | Highest | Complete |
| **Augment (Keep + Extend)** | Ongoing | Low | Low | None on mainframe |

### 8.3 Mainframe Data Migration

```
┌──────────────────┐
│  Mainframe       │
│  ┌──────────┐    │
│  │ Db2 z/OS │────┼── DMS ──────────▶ Aurora PostgreSQL
│  └──────────┘    │
│  ┌──────────┐    │
│  │ VSAM     │────┼── Custom ETL ───▶ DynamoDB / S3
│  └──────────┘    │
│  ┌──────────┐    │
│  │ IMS DB   │────┼── Custom ETL ───▶ Aurora / DynamoDB
│  └──────────┘    │
│  ┌──────────┐    │
│  │ Flat files│───┼── DataSync/S3 ──▶ S3 + Athena/Glue
│  └──────────┘    │
└──────────────────┘
```

---

## 9. Application Portfolio Assessment for Modernization

### 9.1 Assessment Framework

**The MODA Framework (Modernization Decision Assessment):**

```
For each application, score 1-5 on:

Business Fit:
├── Strategic importance     (1=low, 5=core business)
├── Revenue dependency       (1=none, 5=primary revenue)
├── User satisfaction        (1=poor, 5=excellent)
└── Competitive advantage    (1=none, 5=key differentiator)

Technical Health:
├── Architecture quality     (1=spaghetti, 5=clean)
├── Code quality             (1=unmaintainable, 5=clean)
├── Technical debt           (1=severe, 5=minimal)
├── Test coverage            (1=none, 5=>80%)
├── Deployment frequency     (1=annual, 5=daily)
└── Security posture         (1=critical vulnerabilities, 5=secure)
```

### 9.2 Modernization Quadrant

```
                     High Business Value
                           │
           ┌───────────────┼───────────────┐
           │   TOLERATE    │  INVEST       │
           │               │               │
           │ Low tech health│ High value +  │
           │ High bus value │ Low tech debt │
           │               │               │
           │ → Replatform  │ → Refactor/   │
           │   or gradual  │   Re-architect│
           │   modernize   │   (priority!) │
  Low   ───┼───────────────┼───────────────┼─── High
  Tech     │   ELIMINATE   │  MIGRATE      │    Tech
  Health   │               │               │    Health
           │ Low value +   │ Good tech +   │
           │ Low tech health│ Low bus value │
           │               │               │
           │ → Retire or   │ → Rehost or   │
           │   Replace     │   Replatform  │
           └───────────────┼───────────────┘
                           │
                     Low Business Value
```

---

## 10. Modernization with AWS Services

### 10.1 ECS Modernization

```
Monolith ──▶ Docker container ──▶ ECS Fargate

Architecture:
Internet ──▶ ALB ──▶ ECS Service (3 tasks) ──▶ Aurora
                      │ Task 1 (Fargate)
                      │ Task 2 (Fargate)
                      │ Task 3 (Fargate)
                      
Auto Scaling: Target tracking (CPU 70% or ALB request count)
Service Discovery: AWS Cloud Map (for inter-service communication)
```

### 10.2 EKS Modernization

```
Microservices on EKS:

┌─────────────────────────────────────────────────────────┐
│  EKS Cluster                                             │
│  ┌──────────────────────────────────────────────────┐   │
│  │  Namespace: production                             │   │
│  │  ┌──────────┐  ┌──────────┐  ┌──────────┐       │   │
│  │  │ Product  │  │  Order   │  │  Payment │       │   │
│  │  │ Service  │  │  Service │  │  Service │       │   │
│  │  │ (3 pods) │  │ (5 pods) │  │ (3 pods) │       │   │
│  │  └──────────┘  └──────────┘  └──────────┘       │   │
│  │                                                    │   │
│  │  Service Mesh: AWS App Mesh / Istio               │   │
│  │  Ingress: AWS Load Balancer Controller            │   │
│  │  Autoscaling: Karpenter + HPA                     │   │
│  └──────────────────────────────────────────────────┘   │
│                                                          │
│  Node Groups: Managed (m5.xlarge) + Fargate profiles    │
└─────────────────────────────────────────────────────────┘
```

### 10.3 Lambda + Step Functions Modernization

```
Batch Processing Modernization:

BEFORE:
Cron job → EC2 instance → Process 1M records → Write to DB
(Runs for 6 hours, oversized EC2 running 24/7)

AFTER:
EventBridge (schedule) → Step Functions:
  ├── Lambda: Query S3 for files (30 sec)
  ├── Map State (parallel):
  │   ├── Lambda: Process batch 1 (5 min)
  │   ├── Lambda: Process batch 2 (5 min)
  │   ├── ... (100 parallel invocations)
  │   └── Lambda: Process batch 100 (5 min)
  ├── Lambda: Aggregate results (1 min)
  └── Lambda: Write to DynamoDB (2 min)

Total time: ~8 minutes (vs 6 hours)
Cost: Pay only for execution time
```

### 10.4 Service Mapping

| Legacy Component | AWS Modernized Service |
|---|---|
| Apache/Nginx web server | CloudFront + S3 (static) or ALB + ECS |
| Application server (Tomcat/JBoss) | ECS, EKS, Lambda, Elastic Beanstalk |
| Cron jobs | EventBridge + Lambda/Step Functions |
| Message broker (RabbitMQ/ActiveMQ) | Amazon MQ, SQS, SNS, EventBridge |
| File server (NFS/CIFS) | EFS, FSx, S3 |
| Email server | SES, WorkMail |
| LDAP/Active Directory | AWS Directory Service, IAM Identity Center |
| Monitoring (Nagios/Zabbix) | CloudWatch, Managed Grafana, X-Ray |
| Log management (ELK self-hosted) | OpenSearch Service, CloudWatch Logs |
| CI/CD (Jenkins self-hosted) | CodePipeline, CodeBuild, CodeDeploy |
| Container registry (self-hosted) | ECR |
| Data warehouse (Teradata/Oracle) | Redshift, Athena + S3 |
| ETL (Informatica/DataStage) | Glue, Step Functions + Lambda |
| Search (Solr/Elasticsearch) | OpenSearch Service |
| Cache (Memcached/Redis self-hosted) | ElastiCache |
| API management (Apigee/MuleSoft) | API Gateway, AppSync |

---

## 11. Exam Scenarios

### Scenario 1: Monolith Decomposition

**Question:** A company has a monolithic Java application deployed on EC2 instances behind an ALB. They want to gradually break it into microservices. The application currently handles product catalog, ordering, and user management. What approach should they use?

**Answer:** **Strangler Fig Pattern** with ALB path-based routing.

**Implementation:**
1. Deploy new Product Catalog microservice on ECS Fargate
2. Configure ALB path-based routing: `/api/products/*` → ECS target group
3. Keep `/api/orders/*` and `/api/users/*` routing to monolith EC2
4. Next: Extract Order service, then User service
5. Eventually decommission the monolith

---

### Scenario 2: Serverless Transformation

**Question:** A company runs a batch processing job on an m5.4xlarge EC2 instance that processes CSV files uploaded to a file share. The job runs for 10 minutes every hour but the instance runs 24/7. How can they modernize for cost and efficiency?

**Answer:** **Serverless — S3 + Lambda + Step Functions**

**Architecture:**
1. Replace file share with S3 bucket
2. S3 event notification triggers Lambda on new file upload
3. Lambda processes CSV file (or Step Functions for large files with Map state)
4. Results written to DynamoDB or another S3 bucket
5. Cost: Pay only for 10 minutes of Lambda execution per hour vs 24/7 EC2

---

### Scenario 3: Containerization First

**Question:** A company has 50 applications running on on-premises VMs. They want to modernize but lack cloud-native expertise. Timeline is 12 months. What approach?

**Answer:** **Containerize first (lift and shift to containers), then modernize.**

**Steps:**
1. Use **AWS App2Container** to containerize Java/.NET apps
2. Deploy containers on **ECS Fargate** (minimal ops overhead)
3. Set up CI/CD pipelines with CodePipeline + CodeBuild
4. Achieve cloud deployment benefits: auto-scaling, consistent environments
5. **Phase 2** (after 12 months): Start decomposing high-value apps into microservices

---

### Scenario 4: Event-Driven Migration

**Question:** A company's order processing system currently uses synchronous REST calls between 5 services. When the payment service is slow, all orders fail. How should they redesign?

**Answer:** **Event-driven architecture** with SQS/EventBridge.

**Architecture:**
1. Order Service publishes `OrderCreated` event to EventBridge
2. Payment Service subscribes to `OrderCreated` → processes payment → publishes `PaymentCompleted`
3. Inventory Service subscribes to `PaymentCompleted` → reserves stock
4. Shipping Service subscribes to stock reserved event → creates shipment
5. Each service has SQS dead-letter queue for failed events
6. Step Functions orchestrates the saga with compensating transactions for failures

---

### Scenario 5: Mainframe Modernization

**Question:** A company runs a 30-year-old COBOL application on an IBM mainframe. They spend $5M/year on mainframe costs. They want to move to AWS but have limited Java developers. The COBOL codebase is 2 million lines. What approach?

**Answer:** **Replatform using AWS Mainframe Modernization (Micro Focus)** for quick wins, with a long-term plan for automated refactoring.

**Phase 1 (6-12 months):** Replatform with Micro Focus
- Recompile COBOL for x86 Linux on EC2
- Migrate Db2 z/OS → Aurora PostgreSQL (SCT + DMS)
- Migrate VSAM → Aurora or S3
- Same COBOL code, different platform
- Immediate savings: $5M → ~$1.5M/year

**Phase 2 (12-36 months):** Automated Refactoring with Blu Age
- Convert COBOL → Java Spring Boot automatically
- Deploy on ECS/EKS
- Further cost reduction and cloud-native benefits

---

> **Key Exam Tips Summary:**
> 1. **Strangler fig** = Default pattern for incremental modernization (most common exam answer)
> 2. **Containers first** = Lowest-risk path for teams new to cloud-native
> 3. **Serverless** = Best for event-driven, batch processing, and variable workloads
> 4. **API Gateway** = Key enabler for strangler fig (path-based routing)
> 5. **Step Functions** = Complex workflows, saga pattern, batch orchestration
> 6. **EventBridge** = Decouple services, event-driven architecture
> 7. **Database per service** = Microservices should own their data
> 8. **Purpose-built databases** = Use the right database for the access pattern
> 9. **App2Container** = Automated containerization for Java and .NET
> 10. **Mainframe modernization** = Micro Focus (replatform, fast) or Blu Age (refactor, thorough)
