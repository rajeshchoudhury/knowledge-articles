# Building Blocks in TOGAF

## Introduction

Building Blocks are one of the most practical and frequently tested concepts in the TOGAF 10 certification exam. They represent the fundamental components from which architectures and solutions are assembled. Understanding Building Blocks is essential because they bridge the gap between abstract architecture descriptions and concrete, implementable solutions.

TOGAF defines two primary types of Building Blocks: **Architecture Building Blocks (ABBs)** and **Solution Building Blocks (SBBs)**. ABBs capture what is needed (architecture requirements), while SBBs describe what will be used (solution components). The progression from ABBs to SBBs through the ADM cycle is a core concept that the exam tests heavily.

---

## What Are Building Blocks in TOGAF?

A **Building Block** is a (potentially re-usable) component of enterprise capability that can be combined with other building blocks to deliver architectures and solutions. Building blocks can be defined at various levels of detail, depending on the stage of architecture development.

Building blocks represent components of a business, IT, or architectural capability that can be combined to deliver a particular solution or service. They are a fundamental concept that enables:

- **Reuse**: Building blocks promote the reuse of proven components across the enterprise
- **Standardization**: Common building blocks establish consistent approaches
- **Interoperability**: Well-defined interfaces enable building blocks to work together
- **Modularity**: Solutions are assembled from composable, replaceable parts

### Key Principle

Every building block should have a **published interface** that allows it to interact with other building blocks and with the external environment. This interface is what makes building blocks composable and replaceable.

---

## Architecture Building Blocks (ABBs)

### Definition

An **Architecture Building Block (ABB)** describes a required capability. It captures the fundamental architecture requirements, is technology-aware but product-neutral, and defines what functionality and attributes are needed without specifying how they will be delivered.

### Characteristics of ABBs

| Characteristic | Description |
|---|---|
| **Captures Architecture Requirements** | Defines what is needed in terms of functionality, interfaces, and attributes |
| **Technology-Aware** | Recognizes technology constraints and possibilities |
| **Product-Neutral** | Does NOT specify particular products, tools, or vendors |
| **Defines Functional Behavior** | Specifies what the building block must do |
| **Specifies Interfaces** | Defines how the building block connects to its environment |
| **Performance-Aware** | May specify performance and quality attributes |
| **Reusable** | Can be leveraged across multiple architectures and solutions |
| **Interoperable** | Designed to work with other building blocks through standard interfaces |

### ABB Detail Level

ABBs can be defined at varying levels of granularity:

- **High-Level ABBs** (Phase A): Broad capabilities such as "Customer Relationship Management" or "Identity Management"
- **Detailed ABBs** (Phases B, C, D): Specific functional components such as "Customer Profile Service" or "Authentication Service with SAML 2.0 support"

### ABB Specification Template

A well-specified ABB should include:

1. **Name**: A unique, descriptive name for the building block
2. **Description**: A clear statement of what the building block does and why it is needed
3. **Functional Requirements**: The specific functions the building block must perform
4. **Interfaces**: Published interfaces — inputs, outputs, protocols, and data formats
5. **Interoperability Requirements**: How it must interact with other building blocks
6. **Quality Attributes**: Performance, reliability, security, scalability requirements
7. **Constraints**: Technology constraints, standards that must be adhered to
8. **Dependencies**: Other building blocks or services this ABB depends on
9. **Applicable Standards**: Relevant industry or organizational standards
10. **Ownership**: Who is responsible for this building block

### Examples of ABBs

| Architecture Domain | ABB Example | Description |
|---|---|---|
| **Business** | Customer Onboarding Process | Defines the capability to onboard new customers including KYC |
| **Data** | Customer Master Data Store | Defines the need for a centralized, authoritative source of customer data |
| **Application** | Payment Processing Service | Defines the capability to process various payment types with PCI-DSS compliance |
| **Technology** | High-Availability Compute Platform | Defines the need for a resilient compute infrastructure with 99.99% uptime |

---

## Solution Building Blocks (SBBs)

### Definition

A **Solution Building Block (SBB)** represents a candidate solution component that will be used to implement the architecture. SBBs are product-aware or vendor-aware — they specify concrete products, technologies, or components that fulfill the requirements defined by ABBs.

### Characteristics of SBBs

| Characteristic | Description |
|---|---|
| **Candidate Solution Component** | Represents a specific implementation option |
| **Product/Vendor-Aware** | Specifies particular products, tools, platforms, or vendors |
| **Implementation-Specific** | Defines how the capability will be delivered |
| **Defined Interfaces** | Concrete interface specifications (APIs, protocols, formats) |
| **May Be COTS or Custom** | Can be commercial off-the-shelf, open-source, or custom-built |
| **Constrained by ABBs** | Must satisfy the requirements defined by the corresponding ABBs |
| **Deployable** | Can be procured, configured, and deployed |
| **Versionable** | Has specific version and configuration information |

### SBB Specification Template

A well-specified SBB should include:

1. **Name**: The specific product/component name
2. **Description**: What the component does and how it fulfills the ABB requirements
3. **Product/Technology**: Specific product name, version, vendor
4. **Interface Specifications**: Concrete API definitions, protocols, data formats
5. **Configuration Requirements**: How the component must be configured
6. **Dependencies**: Runtime dependencies, libraries, infrastructure requirements
7. **Licensing**: License type, cost implications, restrictions
8. **Support Model**: Vendor support, community support, internal support
9. **Compliance**: How it meets the standards and constraints from the ABB
10. **Deployment Specifications**: Hardware requirements, deployment topology, scaling
11. **ABB Mapping**: Which ABB(s) this SBB implements

### Examples of SBBs

| Architecture Domain | Corresponding ABB | SBB Example |
|---|---|---|
| **Business** | Customer Onboarding Process | Salesforce CRM with custom onboarding workflow |
| **Data** | Customer Master Data Store | Oracle MDM 12c on Oracle Exadata |
| **Application** | Payment Processing Service | Stripe Payment Gateway v2023.1 with PCI-DSS Level 1 |
| **Technology** | High-Availability Compute Platform | AWS EKS cluster with multi-AZ deployment on m6i.xlarge instances |

---

## Relationship Between ABBs and SBBs

### The Fundamental Relationship

ABBs define **WHAT** is needed; SBBs define **HOW** it will be delivered. One ABB may be fulfilled by one or more SBBs, and conversely, one SBB may fulfill multiple ABBs.

```
+---------------------+                    +---------------------+
| Architecture        |    implements      | Solution            |
| Building Block      |<------------------>| Building Block      |
| (ABB)               |                    | (SBB)               |
|                     |                    |                     |
| - What is needed    |                    | - How it's delivered |
| - Product-neutral   |                    | - Product-specific   |
| - Functional specs  |                    | - Implementation     |
| - Quality attrs     |                    |   details            |
| - Interface reqs    |                    | - Concrete APIs      |
+---------------------+                    +---------------------+
```

### Mapping Relationships

| Relationship | Description | Example |
|---|---|---|
| **1 ABB : 1 SBB** | One SBB directly implements one ABB | "Messaging Service" ABB → Apache Kafka 3.5 SBB |
| **1 ABB : N SBBs** | Multiple SBBs together implement one ABB | "Data Analytics Platform" ABB → Hadoop + Spark + Tableau SBBs |
| **N ABBs : 1 SBB** | One SBB fulfills multiple ABBs | "Enterprise Integration Platform" SBB fulfills both "Message Routing" and "Protocol Translation" ABBs |

---

## How ABBs Evolve into SBBs Through the ADM

The evolution from ABBs to SBBs is a progressive refinement that occurs across multiple ADM phases:

```
  Phase A          Phase B/C/D        Phase E            Phase F/G
  (Vision)         (Architecture)     (Opportunities     (Migration/
                                       & Solutions)       Implementation)

+----------+     +----------+       +----------+       +----------+
| High-    |     | Detailed |       | Candidate|       | Selected |
| Level    |---->| ABBs     |------>| SBBs     |------>| & Deployed|
| ABBs     |     |          |       |          |       | SBBs     |
+----------+     +----------+       +----------+       +----------+

  Broad            Specific           Product-           Configured
  capabilities     functional         specific           and
  identified       requirements       options            implemented
                   defined            evaluated
```

### Phase-by-Phase Evolution

| ADM Phase | Building Block Activity |
|---|---|
| **Phase A: Architecture Vision** | High-level ABBs identified; broad capabilities described at the vision level |
| **Phase B: Business Architecture** | Business ABBs defined with detailed functional and process requirements |
| **Phase C: Data Architecture** | Data ABBs defined — data stores, data services, data quality requirements |
| **Phase C: Application Architecture** | Application ABBs defined — application services, integration requirements, functional specifications |
| **Phase D: Technology Architecture** | Technology ABBs defined — infrastructure, platform, and network requirements |
| **Phase E: Opportunities & Solutions** | ABBs mapped to candidate SBBs; build-vs-buy analysis; SBB options evaluated |
| **Phase F: Migration Planning** | SBBs prioritized and sequenced for implementation in work packages |
| **Phase G: Implementation Governance** | SBBs deployed and verified against ABB specifications; compliance checked |
| **Phase H: Change Management** | Deployed SBBs monitored; changes may trigger new ABB/SBB definitions |

---

## Building Block Characteristics (Good Building Blocks)

TOGAF specifies that well-designed building blocks should exhibit the following characteristics:

### 1. Reusable
Building blocks should be designed for reuse across multiple solutions and contexts. Reuse reduces cost, improves consistency, and accelerates delivery.

### 2. Replaceable
A building block should be replaceable by another building block that provides the same interface and meets the same requirements. This is enabled by well-defined interfaces and separation of interface from implementation.

### 3. Well-Specified
Building blocks must be thoroughly documented with clear functional specifications, interface definitions, quality attributes, and constraints.

### 4. Governed by Published Interfaces
Every building block should have formally published interfaces that define how it interacts with other building blocks and the external environment. The interface is the contract.

### 5. Composable
Building blocks should be designed to be combined with other building blocks to create larger, more complex capabilities.

### 6. Loosely Coupled
Building blocks should minimize dependencies on other building blocks, interacting only through published interfaces.

### 7. Self-Contained
A building block should encapsulate its internal workings and not expose implementation details beyond its interface.

---

## Building Block Design Principles

| Principle | Description |
|---|---|
| **Separation of Concerns** | Each building block addresses a specific, well-defined concern |
| **Interface-Driven Design** | Define interfaces before implementation; the interface IS the contract |
| **Encapsulation** | Hide internal complexity; expose only what is needed through the interface |
| **Loose Coupling** | Minimize dependencies between building blocks |
| **High Cohesion** | Related functions should be grouped within the same building block |
| **Standardization** | Use standard interfaces, protocols, and data formats where possible |
| **Technology Independence** (for ABBs) | ABBs should not prescribe specific technology choices |
| **Scalability** | Design building blocks to scale independently |

---

## Building Block Lifecycle

Building blocks go through a lifecycle that parallels and extends beyond the ADM:

```
+------------+     +------------+     +------------+     +------------+
|   Define   |---->|  Specify   |---->| Implement  |---->|  Deploy    |
|            |     |            |     |            |     |            |
| Identify   |     | Detail     |     | Build or   |     | Configure  |
| capability |     | requirements|    | procure    |     | and deploy |
| need       |     | & interfaces|    | component  |     | into env   |
+------------+     +------------+     +------------+     +------------+
                                                               |
+------------+     +------------+     +------------+           |
|   Retire   |<----|  Evolve    |<----|  Operate   |<----------+
|            |     |            |     |            |
| Sunset and |     | Enhance,   |     | Monitor,   |
| replace    |     | upgrade,   |     | maintain,  |
|            |     | version    |     | support    |
+------------+     +------------+     +------------+
```

1. **Define**: Identify the need for a building block (ABB creation)
2. **Specify**: Detail the functional requirements, interfaces, and quality attributes
3. **Implement**: Build, procure, or configure the solution component (SBB creation)
4. **Deploy**: Install, configure, and make the building block operational
5. **Operate**: Monitor, maintain, and support the building block in production
6. **Evolve**: Enhance, upgrade, or version the building block as needs change
7. **Retire**: Sunset the building block when it is no longer needed or is replaced

---

## Building Blocks and the Enterprise Continuum

Building blocks exist at different levels of abstraction within the Enterprise Continuum:

```
+------------------------------------------------------------------+
|                    Enterprise Continuum                            |
|                                                                    |
|  Foundation    Common Systems    Industry      Organization-       |
|  Architecture  Architectures    Architectures  Specific            |
|                                                Architectures       |
|  +-----------+ +-----------+   +-----------+  +-----------+       |
|  | Generic   | | Shared    |   | Industry- |  | Org-      |       |
|  | BBs       | | BBs       |   | specific  |  | specific  |       |
|  | (e.g.,    | | (e.g.,    |   | BBs       |  | BBs       |       |
|  | TCP/IP,   | | ERP,      |   | (e.g.,    |  | (e.g.,    |       |
|  | HTTP,     | | CRM,      |   | SWIFT for |  | Custom    |       |
|  | RDBMS)    | | IAM)      |   | banking)  |  | Trading   |       |
|  +-----------+ +-----------+   +-----------+  | Platform) |       |
|                                                +-----------+       |
|  <-- More Generic                   More Specific -->             |
|  <-- More Reusable                  More Tailored -->             |
+------------------------------------------------------------------+
```

- **Foundation Building Blocks**: Generic, broadly applicable (e.g., operating systems, databases, networking protocols)
- **Common Systems Building Blocks**: Widely used patterns (e.g., ERP modules, CRM systems, identity management)
- **Industry Building Blocks**: Specific to an industry (e.g., SWIFT messaging for banking, HL7 for healthcare)
- **Organization-Specific Building Blocks**: Custom to the enterprise (e.g., proprietary algorithms, custom business processes)

The Enterprise Continuum encourages architects to leverage existing building blocks (especially at the Foundation and Common Systems levels) before designing custom ones, promoting reuse and reducing risk.

---

## Building Blocks in Each ADM Phase: Detailed Breakdown

### Preliminary Phase
- Establish the building block approach and governance framework
- Define building block naming conventions and taxonomy
- Identify existing building block repositories

### Phase A: Architecture Vision
- Identify high-level building blocks needed to realize the architecture vision
- Map building blocks to business goals and drivers
- These are very coarse-grained ABBs

### Phase B: Business Architecture
- Define Business ABBs: business processes, organizational units, business functions, business services
- Examples: "Order Management Process," "Customer Service Function," "Regulatory Compliance Service"

### Phase C: Data Architecture
- Define Data ABBs: data entities, data stores, data services, data quality rules
- Examples: "Product Catalog Data Store," "Customer Data Service," "Real-Time Data Ingestion Pipeline"

### Phase C: Application Architecture
- Define Application ABBs: application components, application services, application interfaces
- Examples: "Order Processing Application," "Customer Portal Service," "Inventory Management API"

### Phase D: Technology Architecture
- Define Technology ABBs: compute platforms, storage, networking, middleware
- Examples: "Container Orchestration Platform," "API Gateway," "Enterprise Service Bus"
- Begin identifying candidate SBBs (technology products that could fulfill ABBs)

### Phase E: Opportunities and Solutions
- Map ABBs to candidate SBBs
- Conduct build-vs-buy analysis for each ABB
- Evaluate alternative SBBs against ABB requirements
- Select preferred SBBs and document rationale
- Group SBBs into work packages

### Phase F: Migration Planning
- Sequence SBB implementation across transition architectures
- Define SBB dependencies and implementation order
- Create implementation and migration plans for SBBs

### Phase G: Implementation Governance
- Verify that implemented SBBs conform to ABB specifications
- Conduct compliance reviews
- Manage building block deployment

### Phase H: Architecture Change Management
- Monitor deployed SBBs for change triggers
- Assess whether changes require new ABBs or SBBs
- Manage building block evolution and retirement

---

## Examples of Building Blocks at Different Levels

### Example: E-Commerce Platform

| Domain | ABB (What) | SBB (How) |
|---|---|---|
| **Business** | Online Order Fulfillment Process | Custom fulfillment workflow in Salesforce Commerce Cloud |
| **Data** | Product Catalog Data Service | PostgreSQL 15 with GraphQL API layer |
| **Application** | Shopping Cart Service | Microservice built with Spring Boot 3.1, deployed on Kubernetes |
| **Application** | Payment Processing Gateway | Stripe API v2023-10 with 3D Secure 2.0 |
| **Technology** | Scalable Compute Platform | AWS EKS with auto-scaling node groups |
| **Technology** | Content Delivery Network | CloudFront with edge caching |

---

## ASCII Diagram: ABB to SBB Evolution

```
                    ARCHITECTURE BUILDING BLOCKS
                    (Product-Neutral Specifications)
    +----------------------------------------------------------+
    |                                                          |
    |  +----------------+  +----------------+  +------------+  |
    |  | Authentication |  | Data Storage   |  | Messaging  |  |
    |  | Service ABB    |  | Service ABB    |  | Service    |  |
    |  |                |  |                |  | ABB        |  |
    |  | - SSO support  |  | - ACID comply  |  | - Async    |  |
    |  | - MFA capable  |  | - 10TB+ scale  |  | - At-least |  |
    |  | - SAML/OIDC    |  | - HA required  |  |   -once    |  |
    |  +-------+--------+  +-------+--------+  +-----+------+  |
    |          |                    |                  |         |
    +----------------------------------------------------------+
               |                    |                  |
               v                    v                  v
    +----------------------------------------------------------+
    |                                                          |
    |  SOLUTION BUILDING BLOCKS                                |
    |  (Product-Specific Implementations)                      |
    |                                                          |
    |  +----------------+  +----------------+  +------------+  |
    |  | Okta Identity  |  | Amazon Aurora  |  | Apache     |  |
    |  | Cloud v2023    |  | PostgreSQL     |  | Kafka 3.5  |  |
    |  |                |  | (Multi-AZ)     |  | (3-broker  |  |
    |  | - SSO via OIDC |  | - 99.99% SLA   |  |  cluster)  |  |
    |  | - Adaptive MFA |  | - Auto-scaling |  | - Exactly  |  |
    |  | - SAML 2.0     |  |   to 128TB     |  |   -once    |  |
    |  +----------------+  +----------------+  +------------+  |
    |                                                          |
    +----------------------------------------------------------+
```

---

## Exam Tips

- **ABB vs. SBB**: The single most important distinction — ABBs are product-neutral, SBBs are product-specific. Expect multiple questions on this.
- **Phase Mapping**: Know that ABBs are primarily defined in Phases B, C, D, and SBBs are identified in Phase E.
- **Building Block Characteristics**: Memorize the key characteristics — reusable, replaceable, well-specified, published interfaces.
- **Enterprise Continuum Relationship**: Building blocks range from generic (Foundation) to organization-specific. Reuse from the generic end first.
- **Interface Importance**: Every building block should have a published interface — this is fundamental.

---

## Review Questions

### Question 1
**What is the primary difference between an Architecture Building Block (ABB) and a Solution Building Block (SBB)?**

A) ABBs are more detailed than SBBs  
B) ABBs are product-neutral; SBBs are product-specific  
C) ABBs are created after SBBs  
D) SBBs are more abstract than ABBs  

**Answer: B** — ABBs define what capability is needed without specifying particular products or vendors. SBBs specify the actual products, tools, or components that will deliver the capability.

---

### Question 2
**In which ADM phase are ABBs primarily mapped to candidate SBBs?**

A) Phase B: Business Architecture  
B) Phase C: Information Systems Architectures  
C) Phase D: Technology Architecture  
D) Phase E: Opportunities and Solutions  

**Answer: D** — Phase E (Opportunities and Solutions) is where ABBs are mapped to candidate SBBs, build-vs-buy analysis is conducted, and SBB options are evaluated.

---

### Question 3
**Which of the following is NOT a characteristic of a well-designed building block?**

A) Reusable  
B) Replaceable  
C) Vendor-locked  
D) Well-specified with published interfaces  

**Answer: C** — Vendor lock-in contradicts building block principles. Well-designed building blocks should be replaceable by alternative components that meet the same interface and requirements.

---

### Question 4
**An architect defines a building block as "A messaging service that supports asynchronous communication, guarantees at-least-once delivery, and provides topic-based pub/sub." This is an example of:**

A) A Solution Building Block  
B) An Architecture Building Block  
C) A deployment specification  
D) A technology standard  

**Answer: B** — This is an ABB because it describes what is needed (functional requirements and quality attributes) without specifying a particular product. It is product-neutral.

---

### Question 5
**An architect specifies "Apache Kafka 3.5 deployed as a 3-broker cluster on AWS EC2 m6i.xlarge instances with multi-AZ replication." This is an example of:**

A) An Architecture Building Block  
B) A Solution Building Block  
C) A reference model  
D) An architecture principle  

**Answer: B** — This is an SBB because it specifies a concrete product (Apache Kafka), version (3.5), and deployment details (AWS EC2 instances, cluster configuration).

---

### Question 6
**How do building blocks relate to the Enterprise Continuum?**

A) Building blocks replace the Enterprise Continuum  
B) Building blocks exist at different levels of abstraction within the Enterprise Continuum, from generic to organization-specific  
C) The Enterprise Continuum only contains SBBs  
D) Building blocks are only found in the Architecture Repository, not the Enterprise Continuum  

**Answer: B** — Building blocks exist across the Enterprise Continuum spectrum, from Foundation (generic) through Common Systems, Industry, to Organization-Specific (most tailored).

---

### Question 7
**Which of the following BEST describes the relationship between ABBs and SBBs?**

A) ABBs and SBBs are always one-to-one  
B) One ABB can be fulfilled by multiple SBBs, and one SBB can fulfill multiple ABBs  
C) SBBs must be defined before ABBs  
D) ABBs are only relevant to business architecture  

**Answer: B** — The relationship between ABBs and SBBs is many-to-many. A single ABB may require multiple SBBs for implementation, and a single SBB (like an integration platform) may fulfill multiple ABBs.

---

### Question 8
**During Phase G (Implementation Governance), what is the primary building block activity?**

A) Defining new ABBs  
B) Conducting build-vs-buy analysis  
C) Verifying that implemented SBBs conform to ABB specifications  
D) Retiring old building blocks  

**Answer: C** — In Phase G, the primary building block activity is verifying that the implemented SBBs conform to the ABB specifications through compliance reviews.

---

### Question 9
**A building block specification states: "Must support SAML 2.0 and OIDC protocols for federated identity." This requirement is MOST appropriately part of:**

A) An SBB functional specification  
B) An ABB interface specification  
C) A governance policy  
D) A migration plan  

**Answer: B** — Interface requirements like protocol support (SAML 2.0, OIDC) are part of the ABB interface specification. They describe what the building block must support without naming a specific product.

---

### Question 10
**What is the recommended approach when an architect needs a building block for a common capability like email?**

A) Always build a custom solution  
B) Check the Enterprise Continuum for existing building blocks, starting from the Foundation and Common Systems levels  
C) Skip building blocks for common capabilities  
D) Define only SBBs without corresponding ABBs  

**Answer: B** — TOGAF encourages leveraging existing building blocks from the Enterprise Continuum, starting with the most generic level (Foundation) and moving toward more specific levels only when necessary.

---

### Question 11
**Which building block design principle states that a building block should hide its internal complexity?**

A) Loose Coupling  
B) Separation of Concerns  
C) Encapsulation  
D) High Cohesion  

**Answer: C** — Encapsulation is the design principle that requires building blocks to hide their internal complexity, exposing only the published interface.

---

### Question 12
**In the building block lifecycle, what immediately follows the "Deploy" stage?**

A) Define  
B) Operate  
C) Evolve  
D) Retire  

**Answer: B** — The building block lifecycle goes: Define → Specify → Implement → Deploy → **Operate** → Evolve → Retire. After deployment, the building block enters operation where it is monitored, maintained, and supported.

---

### Question 13
**A project manager asks an architect: "Can we replace the current CRM system with a different vendor's product?" The architect's BEST response based on building block principles is:**

A) "No, building blocks cannot be replaced once deployed"  
B) "Yes, if the replacement SBB satisfies the same ABB specifications and published interfaces"  
C) "Only if we redefine the entire architecture"  
D) "Replacements are only possible during Phase A"  

**Answer: B** — One of the core building block characteristics is replaceability. An SBB can be replaced by another SBB as long as the replacement satisfies the same ABB specifications and published interfaces.

---

### Question 14
**Which of the following is an example of an Industry-level building block in the Enterprise Continuum?**

A) TCP/IP networking stack  
B) SWIFT messaging for banking transactions  
C) A custom reporting dashboard  
D) A relational database management system  

**Answer: B** — SWIFT messaging is specific to the banking/financial services industry, making it an Industry-level building block. TCP/IP and RDBMS are Foundation-level, and a custom dashboard is Organization-Specific.

---

### Question 15
**What is the MAIN reason that every building block should have published interfaces?**

A) To increase documentation overhead  
B) To enable interoperability, replaceability, and composability  
C) To comply with government regulations  
D) To support project management activities  

**Answer: B** — Published interfaces are fundamental to enabling the core building block characteristics: interoperability (blocks can work together), replaceability (blocks can be swapped), and composability (blocks can be combined).

---

### Question 16
**An organization has defined ABBs during Phases B through D. In Phase E, they discover that a single COTS product can fulfill three different ABBs. What is the CORRECT approach?**

A) Reject the COTS product because there must be a 1:1 mapping  
B) Accept the COTS product as a single SBB that fulfills three ABBs, documenting the mapping  
C) Split the COTS product into three separate SBBs  
D) Redefine the three ABBs as a single ABB  

**Answer: B** — A many-to-many relationship between ABBs and SBBs is valid. A single SBB can fulfill multiple ABBs. The correct approach is to document the mapping clearly.

---

## Summary

Building blocks are the fundamental components from which architectures and solutions are constructed in TOGAF:

- **Architecture Building Blocks (ABBs)** define WHAT is needed — they are product-neutral, capture requirements, and specify interfaces
- **Solution Building Blocks (SBBs)** define HOW needs are met — they are product-specific, name concrete technologies, and include deployment details
- ABBs evolve into SBBs through the ADM, primarily transitioning in **Phase E**
- Good building blocks are **reusable, replaceable, well-specified**, and have **published interfaces**
- Building blocks exist across the **Enterprise Continuum** from generic to organization-specific
- The building block lifecycle spans from Definition through Operation to Retirement
- ABB-to-SBB relationships can be **many-to-many**

---

*Previous: [Views, Viewpoints, and Stakeholders](../09-Views-Viewpoints-Stakeholders/README.md) | Next: [TOGAF Reference Models](../11-TOGAF-Reference-Models/README.md)*
