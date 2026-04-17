# Phase D: Technology Architecture

## Overview

Phase D of the TOGAF Architecture Development Method (ADM) develops the **Target Technology Architecture** that enables the logical and physical realization of the Business Architecture (Phase B), Data Architecture, and Application Architecture (Phase C). Technology Architecture defines the IT infrastructure, platforms, middleware, networking, and processing capabilities required to deploy and operate the information systems.

Technology Architecture is where abstract architectural concepts become concrete. The logical application and data components defined in Phase C must be mapped to specific technology platforms, hosting environments, network topologies, and infrastructure services. Phase D answers the question: **"What technology infrastructure do we need to support the business, data, and application architectures?"**

```
┌────────────────────────────────────────────────────────────┐
│                    Architecture Stack                      │
│                                                            │
│  ┌──────────────────────────────────────────────────────┐  │
│  │          Business Architecture (Phase B)             │  │
│  └──────────────────────┬───────────────────────────────┘  │
│  ┌──────────────────────▼───────────────────────────────┐  │
│  │    Information Systems Architecture (Phase C)        │  │
│  │    (Data + Application)                              │  │
│  └──────────────────────┬───────────────────────────────┘  │
│  ┌──────────────────────▼───────────────────────────────┐  │
│  │        Technology Architecture (Phase D)  ◄── HERE   │  │
│  │    (Infrastructure, Platforms, Networks)              │  │
│  └──────────────────────────────────────────────────────┘  │
└────────────────────────────────────────────────────────────┘
```

> **Exam Tip:** Phase D is the final architecture definition phase. After Phase D, the ADM moves into implementation planning (Phases E and F). Ensure you understand that Phase D completes the "architecture stack" that spans Business, Data, Application, and Technology.

---

## Objectives of Phase D

The primary objectives of Phase D are to:

1. **Develop the Target Technology Architecture** that enables the Business, Data, and Application Architecture components, addressing the Statement of Architecture Work and stakeholder concerns.
2. **Identify candidate Architecture Roadmap components** based on gaps between the Baseline and Target Technology Architectures.
3. **Select relevant architecture viewpoints** (e.g., infrastructure, security, operations) that demonstrate how stakeholder concerns are addressed.
4. **Develop views** of the baseline and target technology architectures using the selected viewpoints.
5. **Map technology components to application and data components** defined in Phase C.

---

## Key Concepts

### Technology Components and Services

| Concept | Definition | Example |
|---------|------------|---------|
| **Technology Component** | A specific piece of technology infrastructure (hardware, software, or platform) | Linux server, Oracle database engine, Kubernetes cluster |
| **Technology Service** | A technical capability provided by a technology component, consumed by applications | Compute service, message queuing service, object storage service |
| **Platform Service** | A higher-level categorization of technology services that support application operation | Application server platform, database platform, integration platform |
| **Infrastructure** | The foundational technology layer including compute, storage, networking, and facilities | Data center, cloud region, network backbone |

### Technology Architecture in Modern Contexts

While TOGAF's Technology Architecture concepts were originally defined for traditional on-premises infrastructure, they apply equally to modern technology paradigms:

#### Cloud Computing

| Cloud Model | Technology Architecture Relevance |
|-------------|----------------------------------|
| **IaaS** (Infrastructure as a Service) | Maps directly to technology components — virtual machines, storage volumes, virtual networks |
| **PaaS** (Platform as a Service) | Maps to platform services — managed databases, application runtimes, container orchestration |
| **SaaS** (Software as a Service) | Crosses the boundary between Application and Technology Architecture — the SaaS provider manages both |
| **Serverless / FaaS** | Abstracts infrastructure entirely; Technology Architecture focuses on service configuration, limits, and integration |

#### Containers and Microservices

- **Container platforms** (Docker, Kubernetes) are technology components that host application components.
- **Service meshes** (Istio, Linkerd) are technology components that manage inter-service communication.
- **Container registries** and **CI/CD pipelines** are part of the technology infrastructure supporting the Software Engineering Diagram from Phase C.

```
┌─────────────────────────────────────────────────────┐
│              Cloud Provider (e.g., AWS)              │
│  ┌───────────────────────────────────────────────┐  │
│  │         Kubernetes Cluster (EKS)              │  │
│  │  ┌─────────┐ ┌─────────┐ ┌─────────────────┐ │  │
│  │  │ Pod:    │ │ Pod:    │ │ Pod:            │ │  │
│  │  │ Order   │ │ Payment │ │ Inventory       │ │  │
│  │  │ Service │ │ Service │ │ Service         │ │  │
│  │  └────┬────┘ └────┬────┘ └───────┬─────────┘ │  │
│  │       │           │              │            │  │
│  │  ┌────▼───────────▼──────────────▼─────────┐  │  │
│  │  │         Service Mesh (Istio)            │  │  │
│  │  └─────────────────────────────────────────┘  │  │
│  └───────────────────────────────────────────────┘  │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────┐  │
│  │ RDS (Database)│  │ S3 (Storage) │  │ SQS      │  │
│  │              │  │              │  │ (Queue)  │  │
│  └──────────────┘  └──────────────┘  └──────────┘  │
└─────────────────────────────────────────────────────┘
```

> **Exam Tip:** The TOGAF exam may reference cloud and modern technology patterns. Understand how cloud services map to traditional technology architecture concepts. IaaS = infrastructure components, PaaS = platform services, SaaS = blurs the application/technology boundary.

---

## Technology Architecture Catalogs

### Technology Standards Catalog

The Technology Standards Catalog documents the approved technology standards for the enterprise. It is a critical governance artifact that ensures consistency and reduces technology proliferation.

| Column | Description |
|--------|-------------|
| Technology Domain | Area (e.g., Operating Systems, Databases, Middleware, Networking) |
| Technology Standard | Specific approved product or version |
| Standard Status | Approved, Emerging, Contained, Retired (see lifecycle below) |
| Applicability | When and where this standard applies |
| Owner | Technology domain owner |
| Review Date | Next scheduled review |

**Technology Standard Lifecycle States:**

| State | Meaning |
|-------|---------|
| **Emerging** | Under evaluation; approved for pilot/limited use |
| **Approved (Current)** | Fully approved for new projects and ongoing use |
| **Contained** | Still supported but not approved for new projects; phasing out |
| **Retired** | No longer supported; must be migrated away from |

```
Technology Standard Lifecycle:

  Emerging ──► Approved ──► Contained ──► Retired
  (Pilot)     (Current)    (Phase Out)   (End of Life)
```

> **Exam Tip:** The Technology Standards Catalog and its lifecycle states (Emerging, Approved, Contained, Retired) are frequently tested. Know what each state means and when transitions occur.

### Technology Portfolio Catalog

The Technology Portfolio Catalog inventories all technology assets in the enterprise, similar to the Application Portfolio Catalog but for technology components.

| Column | Description |
|--------|-------------|
| Technology Component | Name of the technology asset |
| Type | Hardware, Software, Platform, Service |
| Vendor | Technology vendor |
| Version | Current version in use |
| Standard Compliance | Whether it aligns with the Technology Standards Catalog |
| Lifecycle State | Active, Sunset, Planned, Retired |
| Hosting Location | On-premises, Cloud (which provider/region), Hybrid |

---

## Technology Architecture Matrices

### Application/Technology Matrix

This is the primary matrix in Phase D. It maps application components (from Phase C) to the technology components that host, support, or enable them.

```
                      │ Linux  │ Windows│ Oracle │ PostgreSQL│ Kubernetes│ AWS S3
                      │ Server │ Server │ DB     │           │           │
──────────────────────┼────────┼────────┼────────┼───────────┼───────────┼──────
Order Management App  │   X    │        │   X    │           │     X     │
CRM System            │        │   X    │        │     X     │           │
Analytics Platform    │   X    │        │        │     X     │     X     │   X
E-Commerce Portal     │   X    │        │        │     X     │     X     │   X
Legacy HR System      │        │   X    │   X    │           │           │
```

This matrix helps identify:
- Which technology components are most critical (used by many applications)
- Technology dependencies for each application
- Opportunities for technology consolidation
- Impact analysis when changing technology standards

---

## Technology Architecture Diagrams

### 1. Environments and Locations Diagram

Shows the physical or virtual environments (development, testing, staging, production) and their geographic locations. This diagram is essential for understanding deployment topology and compliance requirements (data residency, sovereignty).

```
┌──────────────────────────────────────────────────────────────┐
│                     Global Infrastructure                    │
│                                                              │
│  US-East Region              EU-West Region                  │
│  ┌──────────────────┐       ┌──────────────────┐            │
│  │ Production       │       │ Production       │            │
│  │ ┌──────┐┌──────┐ │       │ ┌──────┐┌──────┐ │            │
│  │ │App   ││DB    │ │  ◄──► │ │App   ││DB    │ │            │
│  │ │Cluster││Cluster│ │ Sync │ │Cluster││Cluster│ │            │
│  │ └──────┘└──────┘ │       │ └──────┘└──────┘ │            │
│  └──────────────────┘       └──────────────────┘            │
│                                                              │
│  ┌──────────────────┐       ┌──────────────────┐            │
│  │ Staging          │       │ Development      │            │
│  │ (Pre-production) │       │ (Dev/Test)       │            │
│  └──────────────────┘       └──────────────────┘            │
└──────────────────────────────────────────────────────────────┘
```

### 2. Platform Decomposition Diagram

Shows how the technology platform is decomposed into its constituent services and components. This is one of the most comprehensive technology architecture diagrams, often structured in layers.

```
┌───────────────────────────────────────────────────────────┐
│                    Platform Services                      │
│                                                           │
│  ┌─────────────────────────────────────────────────────┐  │
│  │  Application Platform Services                      │  │
│  │  (App Servers, Web Servers, API Gateways)           │  │
│  └─────────────────────────────────────────────────────┘  │
│  ┌──────────────────────┐ ┌────────────────────────────┐  │
│  │  Data Platform        │ │  Integration Platform     │  │
│  │  Services             │ │  Services                 │  │
│  │  (RDBMS, NoSQL,      │ │  (ESB, Message Queue,     │  │
│  │   Data Warehouse)    │ │   API Management)         │  │
│  └──────────────────────┘ └────────────────────────────┘  │
│  ┌─────────────────────────────────────────────────────┐  │
│  │  Infrastructure Services                            │  │
│  │  (Compute, Storage, Networking, Security)           │  │
│  └─────────────────────────────────────────────────────┘  │
│  ┌─────────────────────────────────────────────────────┐  │
│  │  Operations & Management Services                   │  │
│  │  (Monitoring, Logging, Backup, Disaster Recovery)   │  │
│  └─────────────────────────────────────────────────────┘  │
└───────────────────────────────────────────────────────────┘
```

### 3. Processing Diagram

Shows the deployment of application components onto technology platforms, focusing on the processing (compute) aspect. It maps which applications run on which processing nodes and how workload is distributed.

### 4. Networked Computing/Hardware Diagram

Shows the physical or logical network topology, including servers, routers, switches, firewalls, load balancers, and their interconnections. This is the classic "network diagram" translated into architecture context.

```
                    ┌──────────┐
                    │ Internet │
                    └────┬─────┘
                         │
                    ┌────▼─────┐
                    │ Firewall │
                    │ / WAF    │
                    └────┬─────┘
                         │
                    ┌────▼─────────┐
                    │ Load Balancer│
                    └───┬─────┬───┘
                        │     │
               ┌────────▼┐   ┌▼────────┐
               │ Web     │   │ Web     │
               │ Server 1│   │ Server 2│
               └────┬────┘   └──┬──────┘
                    │           │
               ┌────▼───────────▼──┐
               │ Application Tier  │
               │ (App Server Pool) │
               └────────┬─────────┘
                        │
               ┌────────▼─────────┐
               │  Database Tier   │
               │  (Primary +      │
               │   Replica)       │
               └──────────────────┘
```

### 5. Communications Engineering Diagram

Shows the detailed communications infrastructure, including protocols, bandwidth, latency requirements, and communication paths between components. More detailed than the Networked Computing diagram, focusing on the "how" of communication rather than the "what."

---

## Developing Baseline and Target Technology Architectures

### Baseline Technology Architecture

To develop the baseline:

1. **Inventory all existing technology assets** — servers, databases, middleware, network devices, cloud subscriptions, licenses.
2. **Map current applications to technology components** using the Application/Technology Matrix.
3. **Document current environments** — development, test, staging, production — using the Environments and Locations Diagram.
4. **Assess current technology standards compliance** — identify where the enterprise deviates from approved standards.
5. **Identify technical debt** — aging hardware, unsupported software versions, security vulnerabilities, capacity constraints.

### Target Technology Architecture

To develop the target:

1. **Derive technology requirements** from the Application and Data Architecture (Phase C) — what compute, storage, networking, and platform services are needed.
2. **Apply technology standards** — use the Technology Standards Catalog to select approved technologies.
3. **Design the target platform** — define hosting environments, network topology, security zones, and operational services.
4. **Address non-functional requirements** — performance, availability, scalability, security, disaster recovery, and compliance.
5. **Consider emerging technologies** — evaluate cloud services, containerization, serverless, edge computing as appropriate.
6. **Define the target state** for each technology domain (compute, storage, networking, security, operations).

---

## Gap Analysis for Technology Architecture

Gap analysis in Phase D follows the same pattern as Phases B and C:

| Category | Examples |
|----------|----------|
| **New technology required** | New cloud platform subscription, new container orchestration platform, new API gateway |
| **Technology to be retired** | Legacy mainframe, unsupported database version, deprecated middleware |
| **Technology to be modified** | Server upgrades, network bandwidth increases, security hardening |
| **Technology unchanged** | Stable infrastructure components that meet target requirements |

Gap analysis results from Phase D are combined with results from Phases B and C in Phase E to create the consolidated gaps, solutions, and dependencies matrix.

---

## Technology Standards and Their Role

Technology standards serve several critical purposes:

1. **Reduce complexity** — Limiting the number of approved technologies simplifies operations, reduces training needs, and improves troubleshooting.
2. **Enable interoperability** — Standard technologies are more likely to work together without custom integration.
3. **Improve procurement** — Volume licensing and vendor consolidation reduce costs.
4. **Support skills development** — Focusing on fewer technologies allows deeper expertise.
5. **Reduce risk** — Approved standards are vetted for security, reliability, and vendor support.

The Technology Standards Catalog is the governance mechanism for managing technology standards across the enterprise.

---

## Platform Services and Their Categorization

TOGAF categorizes platform services into several domains. Understanding this categorization is important for the exam:

| Category | Services | Examples |
|----------|----------|---------|
| **Application Platform** | Runtime, web serving, API management | JBoss, Tomcat, Kong API Gateway |
| **Data Platform** | Database, data warehousing, caching | PostgreSQL, Snowflake, Redis |
| **Integration Platform** | Messaging, ESB, event streaming | RabbitMQ, Kafka, MuleSoft |
| **Security Platform** | Identity, access management, encryption | Keycloak, HashiCorp Vault |
| **Infrastructure Platform** | Compute, storage, networking | VMware, AWS EC2, Cisco switches |
| **Operations Platform** | Monitoring, logging, backup, DR | Prometheus, ELK Stack, Veeam |
| **Development Platform** | CI/CD, version control, testing | Jenkins, GitLab, Selenium |

---

## The Technology Reference Model (TRM) Relationship

The TOGAF **Technology Reference Model (TRM)** provides a foundational taxonomy of platform services that can be used as a starting point for Technology Architecture work. While the TRM is not prescriptive, it provides:

- A **common vocabulary** for technology services
- A **categorization framework** for organizing technology components
- A **reference structure** for the Platform Decomposition Diagram

The TRM identifies two major categories:
1. **Infrastructure Services** — Generic technology services (operating system, networking, storage)
2. **Application Platform Services** — Technology services that directly support applications (transaction processing, data management, user interface services)

```
┌─────────────────────────────────────────────────────┐
│                 Application Software                │
├─────────────────────────────────────────────────────┤
│          Application Platform Services              │
│  (Data Mgmt, Transaction Processing, UI Services,   │
│   Security, System & Network Mgmt)                  │
├─────────────────────────────────────────────────────┤
│           Infrastructure Services                   │
│  (Operating System, Networking, Storage, Compute)    │
├─────────────────────────────────────────────────────┤
│              Physical Infrastructure                │
│  (Hardware, Networking Equipment, Facilities)        │
└─────────────────────────────────────────────────────┘
```

> **Exam Tip:** The TRM is a TOGAF reference model, not a mandatory artifact. It provides a taxonomy for categorizing platform services. Know the two main layers: Infrastructure Services and Application Platform Services.

---

## Mapping Technology to Application and Business Requirements

A critical aspect of Phase D is ensuring **traceability** from technology decisions back to application and business requirements:

```
Business Requirement ──► Business Service ──► Application Component ──► Technology Component
     (Phase B)              (Phase B)           (Phase C)               (Phase D)

Example:
"24/7 availability"  ──►  "Order Service"  ──►  "Order Mgmt App"  ──►  "HA Kubernetes Cluster
                                                                        + Multi-AZ RDS"
```

This traceability ensures that every technology investment is justified by a business need and that non-functional requirements (performance, availability, security) are addressed at the technology level.

---

## Inputs, Steps, and Outputs

### Inputs to Phase D

| Input | Source |
|-------|--------|
| Architecture Reference Materials | External / Architecture Repository |
| Request for Architecture Work | Sponsor / Phase A |
| Capability Assessment | Prior phases |
| Communications Plan | Phase A |
| Organization Model for Enterprise Architecture | Preliminary Phase |
| Tailored Architecture Framework | Preliminary Phase |
| Architecture Principles (including Technology Principles) | Preliminary Phase |
| Statement of Architecture Work | Phase A |
| Architecture Vision | Phase A |
| Architecture Repository | All prior phases |
| Draft Architecture Definition Document (Business, Data, Application) | Phases B and C |
| Draft Architecture Requirements Specification (updated through Phase C) | Phases B and C |
| Business, Data, and Application Architecture components of the Architecture Roadmap | Phases B and C |

### Steps in Phase D

1. **Select reference models, viewpoints, and tools** — Choose appropriate technology reference models (e.g., TRM), viewpoints, and modeling tools.
2. **Develop Baseline Technology Architecture Description** — Document the current technology landscape using catalogs, matrices, and diagrams.
3. **Develop Target Technology Architecture Description** — Design the future-state technology architecture aligned with business, data, and application requirements.
4. **Perform gap analysis** — Compare baseline to target technology architecture, identifying gaps and impacts.
5. **Define candidate roadmap components** — Propose technology work packages, projects, or procurement actions.
6. **Resolve impacts across the Architecture Landscape** — Assess how technology changes affect other architecture domains.
7. **Conduct formal stakeholder review** — Present the Technology Architecture to stakeholders for review and approval.
8. **Finalize the Technology Architecture** — Incorporate feedback and finalize deliverables.
9. **Create Architecture Definition Document** — Document the complete Technology Architecture.

### Outputs of Phase D

| Output | Description |
|--------|-------------|
| Refined and updated Architecture Vision | Reflecting Technology Architecture insights |
| Draft Architecture Definition Document (Technology) | Core deliverable with target technology architecture |
| Draft Architecture Requirements Specification (updated) | Including technology-specific constraints |
| Technology Architecture components of the Architecture Roadmap | Roadmap items for technology domain |
| Technology Architecture catalogs | Technology Standards Catalog, Technology Portfolio Catalog |
| Technology Architecture matrices | Application/Technology Matrix |
| Technology Architecture diagrams | All diagrams listed in the diagrams section above |
| Gap analysis results (Technology) | Identified gaps between baseline and target |
| Impact analysis results | Cross-domain impact assessment |

---

## Exam Review Questions

### Question 1
**What is the primary objective of Phase D?**

**Answer:** To develop the Target Technology Architecture that enables the logical and physical realization of the Business, Data, and Application Architectures defined in Phases B and C, addressing stakeholder concerns and the Statement of Architecture Work.

---

### Question 2
**What are the four lifecycle states for technology standards in the Technology Standards Catalog?**

**Answer:** Emerging (under evaluation, approved for pilot use), Approved/Current (fully approved for new projects), Contained (still supported but not approved for new projects), and Retired (no longer supported, must be migrated away from).

---

### Question 3
**What does the Application/Technology Matrix show?**

**Answer:** It maps application components to the technology components that host, support, or enable them. It identifies technology dependencies, critical technology components, consolidation opportunities, and supports impact analysis when technology standards change.

---

### Question 4
**What is the Platform Decomposition Diagram?**

**Answer:** One of the most comprehensive Technology Architecture diagrams, it shows how the technology platform is decomposed into its constituent services and components, typically organized in layers (application platform, data platform, integration platform, infrastructure, operations).

---

### Question 5
**How does cloud computing map to TOGAF Technology Architecture concepts?**

**Answer:** IaaS maps to infrastructure technology components (compute, storage, networking). PaaS maps to platform services (managed databases, application runtimes). SaaS crosses the application/technology boundary. Serverless abstracts infrastructure, shifting Technology Architecture focus to service configuration and integration.

---

### Question 6
**What is the relationship between the TRM and Phase D?**

**Answer:** The TOGAF Technology Reference Model (TRM) provides a foundational taxonomy and categorization of platform services that can serve as a starting point for Technology Architecture work. It offers a common vocabulary and reference structure but is not prescriptive or mandatory.

---

### Question 7
**What does the Environments and Locations Diagram show?**

**Answer:** It shows the physical or virtual environments (development, testing, staging, production) and their geographic locations. It is essential for understanding deployment topology, data residency requirements, and compliance with sovereignty regulations.

---

### Question 8
**What is the difference between the Networked Computing/Hardware Diagram and the Communications Engineering Diagram?**

**Answer:** The Networked Computing/Hardware Diagram shows the physical or logical network topology including servers, routers, switches, and firewalls. The Communications Engineering Diagram focuses on the communication details — protocols, bandwidth, latency requirements, and communication paths. The former focuses on "what" components exist; the latter on "how" they communicate.

---

### Question 9
**Why are technology standards important in enterprise architecture?**

**Answer:** Technology standards reduce complexity, enable interoperability, improve procurement through volume licensing, support skills development by focusing on fewer technologies, and reduce risk through vetted, supported products.

---

### Question 10
**What inputs does Phase D receive from Phase C?**

**Answer:** Key inputs include the Draft Architecture Definition Document (Data and Application Architecture), Draft Architecture Requirements Specification (updated through Phase C), and Data and Application Architecture components of the Architecture Roadmap.

---

### Question 11
**How does Phase D gap analysis differ from Phase C gap analysis?**

**Answer:** Phase D gap analysis focuses specifically on technology components, infrastructure, and platform services rather than data entities or application components. It identifies new technology needed, technology to be retired, technology requiring upgrades, and technology that can remain unchanged. The results are later combined with Phase B and C gap analyses in Phase E.

---

### Question 12
**What is the Processing Diagram used for?**

**Answer:** It shows the deployment of application components onto technology platforms, focusing on the compute/processing aspect. It maps which applications run on which processing nodes and how workload is distributed across the infrastructure.

---

### Question 13
**What role does traceability play in Phase D?**

**Answer:** Traceability ensures that every technology decision can be traced back through application components and business services to a business requirement. This justifies technology investments and ensures that non-functional requirements (performance, availability, security, scalability) are properly addressed at the technology level.

---

### Question 14
**What are the two main categories in the TOGAF TRM?**

**Answer:** Infrastructure Services (generic technology services like operating system, networking, storage) and Application Platform Services (technology services directly supporting applications like transaction processing, data management, user interface services).

---

### Question 15
**After Phase D, what phase follows in the ADM cycle?**

**Answer:** Phase E (Opportunities and Solutions). Phase D is the last architecture definition phase. Phase E begins the transition to implementation planning by consolidating gap analysis results from Phases B, C, and D and identifying work packages and Transition Architectures.

---

### Question 16
**What is the Technology Portfolio Catalog?**

**Answer:** A comprehensive inventory of all technology assets in the enterprise, including technology component name, type (hardware/software/platform/service), vendor, version, standards compliance status, lifecycle state, and hosting location. It is the technology equivalent of the Application Portfolio Catalog.

---

## Key Exam Takeaways

1. Phase D is the **final architecture definition phase** — it completes the Business → Data → Application → Technology stack.
2. The **Technology Standards Catalog** with its four lifecycle states (Emerging, Approved, Contained, Retired) is heavily tested.
3. The **Application/Technology Matrix** is the primary matrix in Phase D — it links Phase C to Phase D.
4. Know the purpose of each diagram — especially **Platform Decomposition**, **Environments and Locations**, and **Networked Computing**.
5. Understand how **cloud computing** maps to traditional technology architecture concepts.
6. The **TRM** provides a taxonomy, not a prescription — it's a reference model for categorizing platform services.
7. **Gap analysis** results from Phase D feed into Phase E alongside results from Phases B and C.
8. **Traceability** from technology to business requirements is a core Phase D principle.
9. Phase D must address **non-functional requirements** — performance, availability, scalability, security, disaster recovery.
10. Technology Architecture must support **all three upstream architectures** (Business, Data, Application).
