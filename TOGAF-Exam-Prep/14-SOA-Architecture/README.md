# Service-Oriented Architecture (SOA) and TOGAF

## Table of Contents

- [Introduction](#introduction)
- [SOA Fundamentals](#soa-fundamentals)
- [How TOGAF Supports SOA](#how-togaf-supports-soa)
- [SOA Reference Architecture](#soa-reference-architecture)
- [Service Concepts in TOGAF](#service-concepts-in-togaf)
- [Service Boundaries and Contracts](#service-boundaries-and-contracts)
- [Service Granularity and Composition](#service-granularity-and-composition)
- [SOA Governance Using TOGAF](#soa-governance-using-togaf)
- [Services in Each ADM Phase](#services-in-each-adm-phase)
- [Service Portfolio Management](#service-portfolio-management)
- [Service Identification, Specification, and Realization](#service-identification-specification-and-realization)
- [ESB, API Gateway, and Microservices](#esb-api-gateway-and-microservices)
- [SOA Patterns in Enterprise Architecture](#soa-patterns-in-enterprise-architecture)
- [Integration Architecture Considerations](#integration-architecture-considerations)
- [Review Questions](#review-questions)

---

## Introduction

Service-Oriented Architecture (SOA) is an architectural style that structures enterprise capabilities as a collection of loosely coupled, reusable services. TOGAF provides a comprehensive framework for developing and governing SOA, and the relationship between SOA and TOGAF is deeply intertwined — TOGAF's Architecture Development Method (ADM) provides the process, and SOA provides the architectural style through which enterprise capabilities are realized.

TOGAF 10 recognizes that modern enterprises increasingly adopt service-oriented principles, whether through traditional SOA, microservices, or API-first design. Understanding how TOGAF supports and enables SOA is critical for the certification exam, as it demonstrates how the abstract framework is applied to a concrete architectural paradigm.

The concept of "service" in TOGAF goes beyond the technical definition. TOGAF defines services at multiple levels — business services, information system (IS) services, and technology services — creating a layered service model that bridges business strategy to technology implementation.

---

## SOA Fundamentals

### Core SOA Principles

| Principle | Description |
|-----------|-------------|
| **Loose Coupling** | Services minimize dependencies on each other; changes to one service do not require changes to others |
| **Service Abstraction** | Services hide internal implementation details behind well-defined interfaces |
| **Service Reusability** | Services are designed to be reused across multiple business processes and applications |
| **Service Composability** | Services can be combined (orchestrated or choreographed) to create higher-level capabilities |
| **Service Autonomy** | Services have control over their own logic and resources |
| **Service Discoverability** | Services are described with metadata so they can be discovered and understood |
| **Service Statelessness** | Services minimize retaining information specific to a particular activity |
| **Standardized Service Contracts** | Services share standardized contracts that define their interfaces |

### SOA vs. Traditional Architecture

```
Traditional Monolithic                   Service-Oriented
┌─────────────────────┐         ┌──────┐  ┌──────┐  ┌──────┐
│                     │         │Svc A │  │Svc B │  │Svc C │
│   Tightly Coupled   │         │      │  │      │  │      │
│   Application       │   ──►   └──┬───┘  └──┬───┘  └──┬───┘
│   Components        │            │          │          │
│                     │         ┌──┴──────────┴──────────┴──┐
└─────────────────────┘         │    Service Bus / Mesh      │
                                └────────────────────────────┘
```

### Key SOA Concepts

- **Service** — a self-contained unit of functionality accessible through a well-defined interface
- **Service Consumer** — an entity (application, process, or user) that invokes a service
- **Service Provider** — the entity that implements and exposes a service
- **Service Contract** — the formal agreement between provider and consumer defining the interface, behavior, and quality of service
- **Service Registry/Repository** — a catalog of available services and their metadata
- **Service Bus** — infrastructure for routing messages between service consumers and providers
- **Orchestration** — centralized coordination of service interactions (typically through a process engine)
- **Choreography** — decentralized coordination where services interact based on events and rules

---

## How TOGAF Supports SOA

TOGAF provides several mechanisms that directly support SOA development and governance:

### 1. Building Blocks and Services

TOGAF's concept of **Architecture Building Blocks (ABBs)** and **Solution Building Blocks (SBBs)** maps directly to the SOA concept of services:

| TOGAF Concept | SOA Equivalent |
|---------------|----------------|
| Architecture Building Block (ABB) | Service specification (abstract capability) |
| Solution Building Block (SBB) | Service implementation (concrete realization) |
| Building block specification | Service contract |
| Enterprise Continuum | Service classification and maturity model |

### 2. The ADM as SOA Development Process

The ADM provides a structured process for:
- Identifying services from business requirements (Phase B)
- Specifying services at the information systems level (Phase C)
- Designing service infrastructure (Phase D)
- Planning service implementation (Phase E, F)
- Governing service delivery (Phase G)

### 3. Architecture Repository as Service Repository

TOGAF's Architecture Repository can serve as the foundation for a service repository:
- **Standards Information Base** — service standards and patterns
- **Reference Library** — reusable service specifications and templates
- **Governance Log** — service governance decisions and compliance records

### 4. Architecture Governance for SOA

TOGAF's governance framework provides the structure for SOA governance:
- Service lifecycle management
- Service compliance reviews
- Service versioning policies
- Service retirement procedures

---

## SOA Reference Architecture

A reference architecture for SOA provides a standardized structure for organizing service-oriented systems. TOGAF's Enterprise Continuum supports the use of reference architectures as starting points.

```
┌────────────────────────────────────────────────────────────────┐
│                    Business Process Layer                       │
│    ┌──────────┐  ┌──────────┐  ┌──────────┐                  │
│    │Process A │  │Process B │  │Process C │                  │
│    └────┬─────┘  └────┬─────┘  └────┬─────┘                  │
├─────────┼─────────────┼─────────────┼──────────────────────────┤
│         ▼             ▼             ▼                          │
│                Service Orchestration Layer                      │
│    ┌─────────────────────────────────────────────────┐        │
│    │         Business Process Engine (BPEL/BPMN)     │        │
│    └──────────────────────┬──────────────────────────┘        │
├───────────────────────────┼────────────────────────────────────┤
│                           ▼                                    │
│                  Business Service Layer                         │
│    ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐   │
│    │Customer  │  │Order     │  │Payment   │  │Inventory │   │
│    │Service   │  │Service   │  │Service   │  │Service   │   │
│    └────┬─────┘  └────┬─────┘  └────┬─────┘  └────┬─────┘   │
├─────────┼─────────────┼─────────────┼──────────────┼──────────┤
│         ▼             ▼             ▼              ▼          │
│              Enterprise Service Bus (ESB) Layer                │
│    ┌─────────────────────────────────────────────────┐        │
│    │  Routing | Transformation | Mediation | Security│        │
│    └──────────────────────┬──────────────────────────┘        │
├───────────────────────────┼────────────────────────────────────┤
│                           ▼                                    │
│              Infrastructure Service Layer                      │
│    ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐   │
│    │Identity  │  │Messaging │  │Logging   │  │Monitoring│   │
│    │Service   │  │Service   │  │Service   │  │Service   │   │
│    └──────────┘  └──────────┘  └──────────┘  └──────────┘   │
├────────────────────────────────────────────────────────────────┤
│                 Service Registry / Repository                  │
│    ┌─────────────────────────────────────────────────┐        │
│    │  Service Catalog | Metadata | Policies | SLAs   │        │
│    └─────────────────────────────────────────────────┘        │
└────────────────────────────────────────────────────────────────┘
```

---

## Service Concepts in TOGAF

TOGAF defines services at three distinct levels, creating a layered model that bridges business needs to technology implementation.

### Business Services

**Definition:** A service that supports business capabilities and is meaningful in business terms.

- Expressed in **business language** (e.g., "Process Customer Order," "Verify Credit," "Generate Invoice")
- Defined during **Phase B: Business Architecture**
- Owned by **business stakeholders**
- Defined by **business outcomes** and quality attributes
- Independent of implementation technology

**Examples:**
- Customer Onboarding Service
- Payment Processing Service
- Regulatory Reporting Service
- Loan Approval Service

### Information System (IS) Services

**Definition:** A service that provides automated support for business services through applications and data.

- Expressed in **information systems language** (e.g., "Customer Data Retrieval API," "Order Validation Engine")
- Defined during **Phase C: Information Systems Architecture**
- Decomposed from **business services** into more granular technical capabilities
- May be realized by one or more applications
- Has defined data contracts and interface specifications

**Examples:**
- Customer Data Service (CRUD operations on customer records)
- Credit Scoring Engine Service
- Document Generation Service
- Notification Service (email, SMS, push)

### Technology Services

**Definition:** A service that provides the technical infrastructure needed to host and run IS services.

- Expressed in **technology language** (e.g., "Linux hosting," "Database clustering," "Message queuing")
- Defined during **Phase D: Technology Architecture**
- Provides the **platform capabilities** that IS services depend on
- Typically standardized across the enterprise

**Examples:**
- Compute Service (VMs, containers, serverless)
- Database Service (relational, NoSQL)
- Messaging Service (event streaming, message queues)
- Identity and Access Management Service

### Service Layer Relationship

```
┌─────────────────────────────────────────────┐
│          Business Services                   │
│   "Process Loan Application"                │
│   - Defined by business outcomes            │
│   - Owned by business stakeholders          │
├──────────────────┬──────────────────────────┤
│                  │ supports                  │
│                  ▼                           │
│        IS Services                           │
│   "Credit Check API"  "Document Gen API"    │
│   - Automated capabilities                  │
│   - Defined interfaces and data contracts   │
├──────────────────┬──────────────────────────┤
│                  │ runs on                   │
│                  ▼                           │
│       Technology Services                    │
│   "Container Platform"  "Database Service"  │
│   - Infrastructure capabilities             │
│   - Standardized platforms                  │
└─────────────────────────────────────────────┘
```

---

## Service Boundaries and Contracts

### Defining Service Boundaries

Service boundaries determine what functionality is encapsulated within a single service. Well-defined boundaries are critical for achieving loose coupling and high cohesion.

**Principles for defining boundaries:**

| Principle | Description |
|-----------|-------------|
| **Business capability alignment** | Each service should align with a distinct business capability |
| **Data ownership** | A service should own its data — no shared databases between services |
| **Single responsibility** | A service should have one reason to change |
| **Bounded context** | Use Domain-Driven Design (DDD) bounded contexts to define boundaries |
| **Organizational alignment** | Service boundaries should align with team boundaries (Conway's Law) |

### Service Contracts

A service contract is the formal specification of a service's interface, behavior, and quality attributes.

**Components of a service contract:**

```
┌─────────────────────────────────────────────────┐
│               SERVICE CONTRACT                   │
├─────────────────────────────────────────────────┤
│ Functional Interface                             │
│  • Operations (methods/endpoints)               │
│  • Input/output data formats (schemas)          │
│  • Error handling and fault contracts            │
├─────────────────────────────────────────────────┤
│ Quality of Service (QoS)                         │
│  • Performance (response time, throughput)       │
│  • Availability (uptime SLA)                    │
│  • Scalability (concurrent users/requests)      │
│  • Security (authentication, authorization)      │
├─────────────────────────────────────────────────┤
│ Service Level Agreement (SLA)                    │
│  • Availability targets (e.g., 99.9%)           │
│  • Response time targets (e.g., <200ms p95)     │
│  • Support hours and escalation procedures      │
│  • Penalties for SLA violations                 │
├─────────────────────────────────────────────────┤
│ Versioning and Lifecycle                         │
│  • Version numbering scheme                     │
│  • Backward compatibility policy                │
│  • Deprecation and sunset timeline              │
└─────────────────────────────────────────────────┘
```

---

## Service Granularity and Composition

### Service Granularity Spectrum

```
Fine-Grained                                    Coarse-Grained
◄─────────────────────────────────────────────────────────────►
│                    │                    │                     │
Utility             Entity              Task               Process
Services            Services            Services           Services
│                    │                    │                     │
"Validate           "Get Customer"      "Submit Order"     "End-to-End
 Email Format"                                              Order
                                                           Fulfillment"
```

| Granularity | Characteristics | Pros | Cons |
|-------------|-----------------|------|------|
| **Fine-grained** | Small, focused operations | Highly reusable, flexible composition | More network overhead, complex orchestration |
| **Medium-grained** | Entity or task-level operations | Balance of reuse and simplicity | May not fit all use cases |
| **Coarse-grained** | Process-level operations | Simple to consume, fewer network calls | Less reusable, harder to modify |

### Service Composition Patterns

**1. Service Orchestration**
```
┌──────────────────┐
│  Orchestrator    │
│  (Central        │
│   Controller)    │
└──┬──────┬────┬───┘
   │      │    │
   ▼      ▼    ▼
┌────┐ ┌────┐ ┌────┐
│Svc │ │Svc │ │Svc │
│ A  │ │ B  │ │ C  │
└────┘ └────┘ └────┘
```
- Central process engine controls the flow
- Easier to understand and manage
- Single point of control (and potential failure)
- Implemented with BPEL, BPMN engines

**2. Service Choreography**
```
┌────┐    event    ┌────┐    event    ┌────┐
│Svc │ ──────────► │Svc │ ──────────► │Svc │
│ A  │             │ B  │             │ C  │
└────┘             └────┘             └────┘
   ▲                                     │
   └─────────── event ──────────────────┘
```
- Decentralized — each service knows its own triggers and actions
- More resilient (no central point of failure)
- Harder to monitor and debug end-to-end flows
- Implemented with event-driven architecture

**3. Service Aggregation**
```
┌──────────────────────┐
│  Composite Service   │
│  (Aggregator)        │
│                      │
│  ┌────┐ ┌────┐      │
│  │Svc │ │Svc │      │
│  │ A  │ │ B  │      │
│  └────┘ └────┘      │
└──────────────────────┘
```
- A higher-level service that combines the outputs of multiple lower-level services
- Simplifies the consumer's interface
- Common in API gateway patterns (Backend for Frontend)

---

## SOA Governance Using TOGAF

SOA governance is the framework of policies, processes, and organizational structures that ensure services are developed, deployed, and managed consistently across the enterprise. TOGAF's architecture governance framework provides the foundation.

### SOA Governance Framework

```
┌────────────────────────────────────────────────────────┐
│                 SOA Governance Board                    │
│  (Subset of or reports to Architecture Review Board)   │
├────────────────────────────────────────────────────────┤
│                                                        │
│  ┌────────────────┐  ┌────────────────┐               │
│  │ Service Design │  │ Service Runtime│               │
│  │ Governance     │  │ Governance     │               │
│  │                │  │                │               │
│  │ • Standards    │  │ • SLA monitor  │               │
│  │ • Reviews      │  │ • Versioning   │               │
│  │ • Approvals    │  │ • Retirement   │               │
│  └────────────────┘  └────────────────┘               │
│                                                        │
│  ┌────────────────────────────────────────────┐       │
│  │        Service Lifecycle Management         │       │
│  │  Plan → Design → Build → Deploy → Operate  │       │
│  │  → Monitor → Version → Retire              │       │
│  └────────────────────────────────────────────┘       │
│                                                        │
│  ┌────────────────────────────────────────────┐       │
│  │         Service Registry/Repository         │       │
│  │  (Single source of truth for all services)  │       │
│  └────────────────────────────────────────────┘       │
└────────────────────────────────────────────────────────┘
```

### Key SOA Governance Policies

| Policy Area | Description |
|-------------|-------------|
| Service naming standards | Consistent naming conventions for services, operations, and data types |
| Service design standards | Required patterns, interface standards (REST/SOAP/gRPC), data format standards |
| Service versioning | How versions are numbered, backward compatibility rules, deprecation timelines |
| Service ownership | Clear ownership and accountability for each service |
| Service reuse | Mandatory service discovery before building new services; reuse incentives |
| Service security | Authentication, authorization, and encryption standards for all services |
| Service SLA | Minimum SLA requirements for different service tiers |
| Service retirement | Process for decommissioning services, including consumer notification |

---

## Services in Each ADM Phase

### Phase A: Architecture Vision

- Define the **SOA vision** — the target state for the service-oriented enterprise
- Identify **key business services** from business strategy
- Establish **SOA principles** (e.g., "prefer reuse over rebuild," "services must be stateless")
- Gain stakeholder buy-in for the SOA approach

### Phase B: Business Architecture

- **Identify business services** from business process analysis
- Map **business capabilities to business services**
- Define **business service contracts** (business-level SLAs)
- Analyze **service interaction patterns** between business units
- Create the **business service catalog**

### Phase C: Information Systems Architecture

- **Decompose business services** into IS services
- Define **data services** that manage data entities
- Specify **application services** that automate business logic
- Design **service interfaces** (APIs) with schemas and contracts
- Map **IS services to applications** (which applications provide which services)
- Define **service composition** patterns (orchestration vs. choreography)

### Phase D: Technology Architecture

- Design the **service infrastructure** (ESB, API gateway, service mesh, message broker)
- Define **technology services** that support the service platform
- Specify **deployment patterns** for services (containers, VMs, serverless)
- Design **service discovery and registry** infrastructure
- Plan **service monitoring and management** infrastructure

### Phase E: Opportunities and Solutions

- Evaluate **service platform options** (open-source vs. commercial, cloud vs. on-premises)
- Define **service implementation projects** (work packages)
- Identify **service reuse opportunities** — services that can serve multiple projects
- Plan **service migration** from legacy to SOA

### Phase F: Migration Planning

- Prioritize **service delivery** based on business value and dependencies
- Plan **incremental service deployment** — which services are built first
- Define **transition architectures** that include partial SOA implementations
- Manage **legacy integration** during the transition

### Phase G: Implementation Governance

- Review **service implementations** for compliance with service standards
- Verify **service contracts** match approved specifications
- Ensure **service testing** (functional, integration, performance) is complete
- Validate **service registration** in the service repository

### Phase H: Architecture Change Management

- Monitor **service usage patterns** and performance
- Identify **service optimization** opportunities
- Manage **service version upgrades** and deprecations
- Respond to **changing business needs** with service modifications

---

## Service Portfolio Management

Service portfolio management is the discipline of managing the enterprise's collection of services as a strategic asset.

### Service Portfolio Structure

| Category | Description | Examples |
|----------|-------------|---------|
| **Core Services** | Services that directly support core business capabilities | Order Processing, Claims Management |
| **Shared Services** | Services reused across multiple business domains | Identity Management, Notification, Document Generation |
| **Infrastructure Services** | Technical services that support the service platform | Logging, Monitoring, Configuration Management |
| **Integration Services** | Services that connect systems and translate between formats | Data Transformation, Protocol Bridging, Legacy Adapters |

### Service Lifecycle States

```
┌──────────┐    ┌──────────┐    ┌──────────┐    ┌──────────┐
│ Planned  │───►│ Active   │───►│Deprecated│───►│ Retired  │
│          │    │          │    │          │    │          │
│ In design│    │In prod.  │    │Still     │    │Removed   │
│ or build │    │use       │    │available │    │from      │
│          │    │          │    │but sunset│    │service   │
│          │    │          │    │scheduled │    │          │
└──────────┘    └──────────┘    └──────────┘    └──────────┘
```

### Service Portfolio Metrics

| Metric | Description |
|--------|-------------|
| Total services | Number of services in the portfolio |
| Service reuse ratio | Average number of consumers per service |
| Service availability | Aggregate uptime across the service portfolio |
| Service health index | Composite score of performance, reliability, and usage |
| Stale services | Services with no consumers or declining usage |
| Redundant services | Services with overlapping functionality |

---

## Service Identification, Specification, and Realization

### Service Identification

Service identification is the process of discovering which services the enterprise needs. There are three primary approaches:

**1. Top-down (Business-driven)**
```
Business Strategy ──► Business Capabilities ──► Business Services ──► IS Services
```
- Start with business goals and capabilities
- Decompose into business services
- Further decompose into IS services
- Strongest alignment with business needs

**2. Bottom-up (Technology-driven)**
```
Existing Systems ──► Exposed Interfaces ──► Wrapped Services ──► Service Catalog
```
- Analyze existing applications and systems
- Identify capabilities that can be exposed as services
- Wrap legacy functionality in service interfaces
- Quick wins with existing investments

**3. Meet-in-the-middle**
```
Business Capabilities                    Existing Systems
        │                                       │
        ▼                                       ▼
   Business Services  ◄── Reconciliation ──►  Wrapped Services
        │                                       │
        └──────────► Service Portfolio ◄────────┘
```
- Combine top-down and bottom-up approaches
- Business-driven identification meets technology-driven discovery
- Reconcile to find gaps and overlaps
- Most practical and commonly recommended approach

### Service Specification

Service specification documents the complete definition of a service.

| Specification Element | Description |
|-----------------------|-------------|
| Service Name | Unique, descriptive name following naming conventions |
| Service Description | Plain-language description of what the service does |
| Service Owner | Individual or team responsible for the service |
| Service Category | Core, shared, infrastructure, or integration |
| Operations | List of operations the service exposes |
| Input/Output Schemas | Data structures for each operation |
| Pre/Post Conditions | Conditions that must be true before/after invocation |
| Error Handling | Error codes, fault contracts, recovery behavior |
| Quality of Service | Performance, availability, scalability requirements |
| Security Requirements | Authentication, authorization, encryption needs |
| Dependencies | Other services this service depends on |
| Version | Current version and compatibility information |

### Service Realization

Service realization is the process of implementing specified services.

| Realization Pattern | Description | When to Use |
|--------------------|-------------|-------------|
| **New development** | Build the service from scratch | No existing implementation; unique business logic |
| **Legacy wrapping** | Wrap existing system functionality in a service interface | Valuable legacy capability that needs to be exposed |
| **Package extension** | Extend a COTS package to expose service interfaces | When using commercial packages with extension points |
| **SaaS integration** | Consume and proxy a SaaS service | When cloud services provide the needed capability |
| **Service composition** | Compose from existing services | Required capability is a combination of existing services |

---

## ESB, API Gateway, and Microservices

### Enterprise Service Bus (ESB)

The ESB is a traditional SOA infrastructure pattern that provides centralized message routing, transformation, and mediation.

```
┌─────────────────────────────────────────────────────┐
│                Enterprise Service Bus                │
│                                                     │
│  ┌──────────┐  ┌──────────┐  ┌──────────────────┐  │
│  │ Message  │  │ Protocol │  │ Content-Based    │  │
│  │ Routing  │  │ Transform│  │ Routing          │  │
│  └──────────┘  └──────────┘  └──────────────────┘  │
│  ┌──────────┐  ┌──────────┐  ┌──────────────────┐  │
│  │ Security │  │ Logging  │  │ Service          │  │
│  │ Enforce  │  │ & Audit  │  │ Orchestration    │  │
│  └──────────┘  └──────────┘  └──────────────────┘  │
└─────────────────────────────────────────────────────┘
```

**Strengths:** Centralized control, protocol mediation, complex routing
**Weaknesses:** Single point of failure, complexity, potential bottleneck

### API Gateway

The API Gateway is a modern evolution of the ESB concept, focused on managing API access.

```
                    ┌─────────────────┐
  Consumers ──────► │   API Gateway   │ ──────► Backend Services
                    │                 │
                    │ • Auth/AuthZ    │
                    │ • Rate Limiting │
                    │ • Caching       │
                    │ • Transform     │
                    │ • Analytics     │
                    └─────────────────┘
```

**Strengths:** Lightweight, API-focused, cloud-native, developer-friendly
**Weaknesses:** Less capable for complex integration scenarios

### Microservices Architecture

Microservices represent the evolution of SOA principles with modern technology practices.

```
┌──────────────────────────────────────────────────────┐
│                  Microservices                        │
│                                                      │
│  ┌────────┐  ┌────────┐  ┌────────┐  ┌────────┐   │
│  │Svc A   │  │Svc B   │  │Svc C   │  │Svc D   │   │
│  │        │  │        │  │        │  │        │   │
│  │Own DB  │  │Own DB  │  │Own DB  │  │Own DB  │   │
│  └───┬────┘  └───┬────┘  └───┬────┘  └───┬────┘   │
│      │           │           │           │         │
│  ┌───┴───────────┴───────────┴───────────┴─────┐   │
│  │          Service Mesh / Event Bus            │   │
│  └─────────────────────────────────────────────┘   │
│                                                      │
│  ┌──────────────────────────────────────────────┐   │
│  │    Container Orchestration (Kubernetes)       │   │
│  └──────────────────────────────────────────────┘   │
└──────────────────────────────────────────────────────┘
```

### Comparison Table

| Aspect | ESB | API Gateway | Microservices |
|--------|-----|-------------|---------------|
| Coupling | Loose (via bus) | Loose (via gateway) | Very loose (independent) |
| Deployment | Centralized | Centralized gateway | Independent per service |
| Data | Shared databases common | Varies | Each service owns its data |
| Scaling | Scale the bus | Scale the gateway | Scale individual services |
| Technology | Often single vendor | Multi-vendor | Polyglot (multiple techs) |
| Governance | Centralized | API management platform | Decentralized with guardrails |
| TOGAF Fit | Strong (traditional EA) | Strong (modern EA) | Requires adaptation of EA approach |

### TOGAF and Microservices

While TOGAF was originally designed in an era of traditional SOA, it can be adapted for microservices:

- **ADM iterations become shorter** — aligning with continuous delivery
- **Building blocks become smaller** — each microservice is a building block
- **Governance becomes lighter** — guardrails instead of gates
- **Architecture Repository** stores service specifications and API contracts
- **Standards Information Base** includes microservice design patterns and standards

---

## SOA Patterns in Enterprise Architecture

### Pattern 1: Service Registry / Repository

A central catalog where services are registered, discovered, and governed.

| Component | Purpose |
|-----------|---------|
| Service Catalog | Searchable inventory of all enterprise services |
| Service Metadata | Descriptions, contracts, SLAs, ownership |
| Service Dependencies | Relationship mapping between services |
| Service Policies | Governance policies applied to services |

### Pattern 2: Canonical Data Model

A shared, standardized data model used across all services to ensure consistency.

- Reduces the need for point-to-point data transformation
- Defined during Phase C (Data Architecture)
- Maintained as an Architecture Building Block
- Versioned and governed through architecture governance

### Pattern 3: Service Façade

An intermediary that simplifies or adapts a service interface for specific consumers.

- Adapts complex internal services for external consumption
- Provides version compatibility
- Aggregates multiple fine-grained services into coarser-grained interfaces

### Pattern 4: Event-Driven Architecture (EDA)

Services communicate through events rather than direct invocation.

```
Producer ──► Event Broker ──► Consumer(s)
             (Kafka, etc.)
```

- Enables temporal decoupling (producer and consumer don't need to be available simultaneously)
- Supports event sourcing and CQRS patterns
- Increases scalability and resilience

### Pattern 5: Saga Pattern

Manages distributed transactions across multiple services without a central coordinator.

- Coordinates multi-step business processes
- Each service performs its step and publishes an event
- Compensating transactions handle failures
- Supports eventual consistency

---

## Integration Architecture Considerations

Integration architecture defines how systems, services, and data connect across the enterprise. In a TOGAF context, integration architecture is a key concern during Phase C and Phase D.

### Integration Styles

| Style | Description | Use Case |
|-------|-------------|----------|
| **Synchronous Request/Reply** | Consumer sends request, waits for response | Real-time queries, user-facing operations |
| **Asynchronous Messaging** | Consumer sends message, doesn't wait for response | Background processing, event notification |
| **File Transfer** | Systems exchange data through files | Batch processing, legacy integration |
| **Shared Database** | Systems access the same database | Tightly coupled integration (generally avoid in SOA) |
| **Event Streaming** | Continuous flow of events between systems | Real-time analytics, IoT, complex event processing |

### Integration Architecture Decision Framework

| Decision | Options | Considerations |
|----------|---------|----------------|
| Synchronous vs. Async | Request/reply vs. messaging | Latency requirements, coupling tolerance, failure handling |
| Hub vs. Point-to-Point | Centralized vs. direct connections | Number of integrations, complexity, governance needs |
| Data format | JSON, XML, Protobuf, Avro | Performance, schema evolution, tooling support |
| Protocol | REST, gRPC, GraphQL, AMQP | Performance, streaming needs, developer experience |
| Transformation | In-service vs. middleware | Complexity of transformation, performance needs |

### Integration Anti-Patterns to Avoid

| Anti-Pattern | Problem | Solution |
|--------------|---------|----------|
| Point-to-point spaghetti | Unmanageable mesh of direct connections | Introduce integration middleware (ESB, API gateway) |
| Shared database integration | Tight coupling, schema changes break consumers | Service-owned databases with API access |
| Big Bang integration | Attempting to integrate everything at once | Incremental integration with clear priorities |
| Ignoring data quality | Garbage in, garbage out | Data validation at service boundaries |
| Over-engineering | Building for hypothetical future needs | Design for current requirements, plan for extensibility |

---

## Review Questions

### Question 1
**In TOGAF, services are defined at three levels. Which of the following correctly lists these levels from highest to lowest?**
- A) Technology Service, IS Service, Business Service
- B) Business Service, IS Service, Technology Service
- C) Application Service, Data Service, Infrastructure Service
- D) Process Service, Component Service, Platform Service

**Answer: B** — TOGAF defines services at three levels: Business Services (highest, business-meaningful), Information System (IS) Services (automated capabilities), and Technology Services (lowest, infrastructure platforms).

---

### Question 2
**Which SOA principle states that services should minimize dependencies on each other?**
- A) Service Abstraction
- B) Service Reusability
- C) Loose Coupling
- D) Service Composability

**Answer: C** — Loose Coupling is the SOA principle that services should minimize dependencies on each other so that changes to one service do not require changes to others.

---

### Question 3
**In which ADM phase are business services primarily identified?**
- A) Phase A: Architecture Vision
- B) Phase B: Business Architecture
- C) Phase C: Information Systems Architecture
- D) Phase D: Technology Architecture

**Answer: B** — Business services are primarily identified during Phase B (Business Architecture) through business process analysis and capability mapping. Phase C decomposes these into IS services.

---

### Question 4
**How does the TOGAF concept of Architecture Building Blocks relate to SOA services?**
- A) They are unrelated concepts
- B) ABBs correspond to service specifications, SBBs correspond to service implementations
- C) ABBs are always services, SBBs are never services
- D) ABBs define technology services only

**Answer: B** — Architecture Building Blocks (ABBs) correspond to abstract service specifications (defining what a service does), while Solution Building Blocks (SBBs) correspond to concrete service implementations (specific products or custom code).

---

### Question 5
**Which service composition pattern uses a central process engine to coordinate service interactions?**
- A) Service Choreography
- B) Service Orchestration
- C) Service Aggregation
- D) Service Federation

**Answer: B** — Service Orchestration uses a central process engine (orchestrator) to coordinate the sequence and logic of service interactions. Choreography, by contrast, is decentralized.

---

### Question 6
**The "meet-in-the-middle" approach to service identification combines:**
- A) Business architecture and data architecture
- B) Top-down (business-driven) and bottom-up (technology-driven) approaches
- C) Phase A and Phase H activities
- D) Service orchestration and choreography

**Answer: B** — The meet-in-the-middle approach combines top-down service identification (from business capabilities) with bottom-up service discovery (from existing systems), reconciling them into a unified service portfolio.

---

### Question 7
**Which of the following is NOT a valid service lifecycle state?**
- A) Planned
- B) Active
- C) Archived
- D) Retired

**Answer: C** — The standard service lifecycle states are Planned, Active, Deprecated, and Retired. "Archived" is not a standard service lifecycle state in this context.

---

### Question 8
**How does TOGAF's Architecture Repository support SOA governance?**
- A) It has no role in SOA governance
- B) It serves as the foundation for a service repository, storing service standards, specifications, and governance records
- C) It only stores technology architecture documents
- D) It replaces the need for a service registry

**Answer: B** — The Architecture Repository supports SOA governance by storing service standards (in the Standards Information Base), service specifications (in the Reference Library), and governance decisions (in the Governance Log).

---

### Question 9
**In a microservices architecture, how should TOGAF's governance approach be adapted?**
- A) Governance should be eliminated entirely
- B) Governance should become lighter, using guardrails instead of gates
- C) Governance should become stricter to control the larger number of services
- D) Governance applies only to the service mesh, not individual services

**Answer: B** — In a microservices context, TOGAF governance should become lighter and more enabling, using guardrails (standards, patterns, automated checks) instead of heavy gate-based approval processes, to support the speed and autonomy that microservices require.

---

### Question 10
**The Canonical Data Model pattern addresses which SOA challenge?**
- A) Service performance optimization
- B) Data inconsistency and excessive point-to-point transformations between services
- C) Service authentication and authorization
- D) Service deployment automation

**Answer: B** — The Canonical Data Model provides a shared, standardized data model to reduce the need for point-to-point data transformations between services, ensuring data consistency across the enterprise.

---

### Question 11
**Which integration style is generally discouraged in SOA because it creates tight coupling?**
- A) Asynchronous Messaging
- B) Event Streaming
- C) Shared Database
- D) Synchronous Request/Reply

**Answer: C** — Shared Database integration is generally discouraged in SOA because it creates tight coupling between services — changes to the database schema can break multiple services. Each service should own its own data.

---

### Question 12
**A service contract in TOGAF/SOA includes all of the following EXCEPT:**
- A) Functional interface (operations, schemas)
- B) Quality of Service attributes
- C) Service Level Agreements
- D) Source code of the service implementation

**Answer: D** — A service contract defines the external specification (interface, QoS, SLA, versioning) but does NOT include implementation details like source code. Service abstraction requires hiding internal implementation behind the contract.

---

### Question 13
**When comparing ESB and API Gateway patterns, which statement is correct?**
- A) ESB and API Gateway are identical concepts
- B) API Gateway is focused on API management and is more lightweight, while ESB provides complex integration capabilities
- C) ESB is more modern than API Gateway
- D) API Gateway replaces all ESB functionality

**Answer: B** — The API Gateway is a more modern, lightweight pattern focused on API access management. The ESB provides more complex integration capabilities (protocol transformation, content-based routing, orchestration). They serve different purposes and can coexist.

---

### Question 14
**The Saga pattern in SOA is used to:**
- A) Manage service versioning
- B) Handle distributed transactions across multiple services using compensating actions
- C) Discover services in a registry
- D) Transform data between different service formats

**Answer: B** — The Saga pattern manages distributed transactions across multiple services. Each service performs its step and publishes an event; if a step fails, compensating transactions are executed to undo previous steps.

---

### Question 15
**Service granularity in SOA refers to:**
- A) The number of services in the portfolio
- B) The size and scope of functionality encapsulated in a single service
- C) The performance of a service
- D) The technology used to implement a service

**Answer: B** — Service granularity refers to the size and scope of functionality encapsulated in a single service. Fine-grained services are small and focused; coarse-grained services encapsulate broader functionality.

---

### Question 16
**In the SOA Reference Architecture, the Service Orchestration Layer is responsible for:**
- A) Providing physical infrastructure for services
- B) Coordinating the execution of multiple services to fulfill a business process
- C) Discovering services in the registry
- D) Monitoring service health

**Answer: B** — The Service Orchestration Layer coordinates the execution sequence of multiple services to fulfill end-to-end business processes, typically using a BPEL or BPMN engine.

---

*End of SOA Architecture Study Guide*
