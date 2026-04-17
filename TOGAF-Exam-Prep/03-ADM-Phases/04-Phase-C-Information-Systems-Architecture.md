# Phase C: Information Systems Architectures (Data and Application)

## Overview

Phase C of the TOGAF Architecture Development Method (ADM) focuses on developing the **Target Information Systems Architecture** — encompassing both **Data Architecture** and **Application Architecture** — that supports the Business Architecture defined in Phase B and aligns with the Architecture Vision from Phase A. This phase is unique in the ADM because it addresses two distinct but tightly coupled sub-architectures within a single phase.

The Information Systems Architecture serves as the bridge between what the business needs (Phase B) and the technology that will deliver it (Phase D). Getting this phase right is critical: poor data and application architecture decisions cascade into every downstream phase.

```
┌─────────────────────────────────────────────────────┐
│                  Phase A: Vision                    │
└──────────────────────┬──────────────────────────────┘
                       │
┌──────────────────────▼──────────────────────────────┐
│            Phase B: Business Architecture           │
└──────────────────────┬──────────────────────────────┘
                       │
┌──────────────────────▼──────────────────────────────┐
│          Phase C: Information Systems               │
│  ┌─────────────────┐   ┌─────────────────────────┐  │
│  │ Data            │   │ Application             │  │
│  │ Architecture    │◄─►│ Architecture            │  │
│  └─────────────────┘   └─────────────────────────┘  │
└──────────────────────┬──────────────────────────────┘
                       │
┌──────────────────────▼──────────────────────────────┐
│          Phase D: Technology Architecture           │
└─────────────────────────────────────────────────────┘
```

> **Exam Tip:** TOGAF allows Phase C sub-architectures to be done in either order — Data first then Application, or Application first then Data. The order depends on the enterprise context and which is the primary driver. The exam may test your understanding that this ordering is flexible.

---

## Objectives of Phase C

The overarching objectives of Phase C are to:

1. **Develop the Target Information Systems (Data and Application) Architecture** describing how the enterprise's Information Systems Architecture will enable the Business Architecture and the Architecture Vision, addressing the Statement of Architecture Work and stakeholder concerns.
2. **Identify candidate Architecture Roadmap components** based on gaps between the Baseline and Target Information Systems Architectures.
3. **Select relevant architecture viewpoints** that will demonstrate how stakeholder concerns are addressed in the Information Systems Architecture.
4. **Develop views** of the target and baseline architectures using the selected viewpoints.

---

## Ordering of Data and Application Architectures

TOGAF explicitly recognizes that Data and Application Architectures can be developed in either order within Phase C. Common approaches include:

| Approach | When to Use |
|----------|-------------|
| **Data-driven** (Data first) | When data is the primary business asset (e.g., financial services, healthcare, analytics-heavy organizations) |
| **Application-driven** (Application first) | When the application landscape is the key concern (e.g., application rationalization, SaaS migration) |
| **Parallel development** | When separate teams handle each domain with coordination checkpoints |

---

## Part 1: Data Architecture

### Objectives of Data Architecture

The specific objectives of the Data Architecture portion of Phase C are to:

- Define the major types and sources of **data entities** necessary to support the business.
- Define how data entities are **created, stored, transported, reported, and retired**.
- Establish a **logical data model** that maps data entities to business functions.
- Develop a **physical data model** appropriate to the target technology environment.
- Ensure data architecture supports **data governance, data quality, and data security** requirements.

### Key Concepts

| Concept | Definition | Exam Relevance |
|---------|------------|----------------|
| **Data Entity** | An encapsulation of data recognized by a business domain expert as a discrete concept (e.g., Customer, Order, Product) | Fundamental building block; appears in catalogs and matrices |
| **Data Component** | A grouping of data entities forming a logical unit of data storage, often mapping to a database or data store | Bridges logical and physical models |
| **Logical Data Model** | Technology-independent representation of data entities, attributes, and relationships | Focus of architecture work in Phase C |
| **Physical Data Model** | Technology-specific implementation of the logical data model (tables, columns, indexes) | Typically refined further in Phase D or implementation |
| **Data Lifecycle** | The stages data goes through: creation, storage, usage, archival, and deletion | Tested through Data Lifecycle Diagrams |

### Data Architecture Catalogs

#### Data Entity/Data Component Catalog

This catalog captures the inventory of all data entities and their mapping to data components. It serves as the master reference for data assets.

| Column | Description |
|--------|-------------|
| Data Entity | Name of the business data entity |
| Data Component | The data component (database, data store) where it resides |
| Source System | System of record |
| Owner | Business or data steward responsible |
| Classification | Sensitivity level (public, internal, confidential, restricted) |
| Lifecycle State | Current lifecycle state |

### Data Architecture Matrices

#### Data Entity/Business Function Matrix

This matrix maps data entities to business functions, showing which functions create, read, update, or delete (CRUD) each entity. This is one of the most commonly tested artifacts in TOGAF exams.

```
                    │ Customer │ Order │ Product │ Invoice │ Payment
────────────────────┼──────────┼───────┼─────────┼─────────┼────────
Sales Management    │   CRU    │  CRUD │    R    │   CR    │    R
Inventory Mgmt      │    R     │   R   │  CRUD   │    -    │    -
Finance             │    R     │   R   │    R    │  CRUD   │  CRUD
Customer Service    │   CRU    │  RU   │    R    │    R    │    R
Marketing           │    R     │   R   │    R    │    -    │    -
────────────────────┴──────────┴───────┴─────────┴─────────┴────────
C = Create  R = Read  U = Update  D = Delete
```

> **Exam Tip:** The Data Entity/Business Function matrix is a CRUD matrix. Expect questions about what this matrix reveals — it helps identify data ownership, data redundancy, and integration requirements.

### Data Architecture Diagrams

Phase C defines several key diagrams for Data Architecture:

#### 1. Conceptual Data Diagram

- Shows high-level data entities and their relationships without implementation detail.
- Used for stakeholder communication and early-stage design.
- Represents the business's view of data at the most abstract level.

#### 2. Logical Data Diagram

- Refines the conceptual model with attributes, primary keys, and explicit relationships.
- Technology-independent but structurally detailed.
- Forms the core deliverable of Data Architecture work.

#### 3. Data Dissemination Diagram

- Shows the relationship between data entities, business services, and application components.
- Illustrates how and where data is **replicated, transformed, or shared** across the enterprise.
- Critical for understanding data integration patterns.

```
┌────────────┐     Replicate     ┌────────────┐
│  CRM       │──────────────────►│  Data      │
│  Database  │                   │  Warehouse │
└────────────┘                   └──────┬─────┘
                                        │ ETL
┌────────────┐     Real-time     ┌──────▼─────┐
│  ERP       │──────────────────►│  Analytics │
│  System    │                   │  Platform  │
└────────────┘                   └────────────┘
```

#### 4. Data Lifecycle Diagram

- Depicts the stages of a data entity's lifecycle from creation through retirement.
- Shows the business and technology events that trigger transitions between states.
- Addresses data retention, archival, and disposal requirements.

#### 5. Data Security Diagram

- Illustrates the security classifications applied to data entities.
- Maps data access controls, encryption requirements, and compliance constraints.
- Links data classification to user roles and application components.

#### 6. Data Migration Diagram

- Shows the transition approach for moving data from baseline to target architecture.
- Includes transformation rules, mapping logic, and sequencing.
- Particularly relevant when replacing or consolidating legacy systems.

### Developing Baseline and Target Data Architectures

**Baseline Data Architecture:**
- Document the current state of data entities, their locations, ownership, and quality.
- Identify existing data stores, databases, and integration mechanisms.
- Capture known data issues: duplication, inconsistency, orphaned data, and compliance gaps.

**Target Data Architecture:**
- Design the future-state data landscape aligned with business requirements from Phase B.
- Apply data governance principles, master data management strategies, and data quality standards.
- Ensure data architecture supports the required business capabilities and services.

### Gap Analysis for Data Architecture

Gap analysis compares the baseline and target data architectures to identify:

- **New data entities** required by the target architecture
- **Data entities to be eliminated** or consolidated
- **Data entities requiring modification** (schema changes, ownership shifts, migration)
- **Data integration gaps** where new interfaces or transformations are needed
- **Data quality gaps** requiring cleansing or enrichment programs

---

## Part 2: Application Architecture

### Objectives of Application Architecture

The specific objectives of the Application Architecture portion of Phase C are to:

- Define the major kinds of **application components and services** needed to process the data and support the business.
- Define the **interactions between application components** and their relationship to core business processes.
- Develop a target application portfolio that is **rationalized, efficient, and aligned** with business needs.
- Identify candidate applications or components to be **developed, acquired, reused, or retired**.

### Key Concepts

| Concept | Definition | Exam Relevance |
|---------|------------|----------------|
| **Application Component** | An encapsulation of application functionality, independently deployable and manageable | Core building block of Application Architecture |
| **Application Service** | A unit of functionality exposed by an application component through a well-defined interface | Tested in the context of service-oriented architecture |
| **Logical Application Component** | A technology-independent representation of an application unit (e.g., "Order Management") | Architecture-level artifact |
| **Physical Application Component** | A specific implementation of a logical component (e.g., "SAP MM Module", "Custom Java Microservice") | Maps logical to actual deployable units |
| **Application Portfolio** | The complete inventory of applications across the enterprise | Key catalog artifact |

> **Exam Tip:** Understand the distinction between *logical* and *physical* application components. The exam frequently tests this: logical components represent "what" functionality is needed; physical components represent "how" and "with what" it is realized.

### Application Architecture Catalogs

#### Application Portfolio Catalog

The Application Portfolio Catalog is the comprehensive inventory of all applications in the enterprise, providing a single source of truth for application management decisions.

| Column | Description |
|--------|-------------|
| Application Name | Canonical name of the application |
| Application Type | Custom, COTS, SaaS, Legacy, etc. |
| Business Capability Supported | Which business capabilities it serves |
| Technical Fitness | Current technical health assessment |
| Business Value | Business value rating |
| Lifecycle State | Active, Sunset, Planned, Retired |
| Owner | Application owner or product owner |

### Application Architecture Matrices

Phase C defines several matrices for Application Architecture:

#### 1. Application/Organization Matrix
Maps applications to organizational units, showing which parts of the organization use which applications. Reveals application sprawl and consolidation opportunities.

#### 2. Role/Application Matrix
Maps user roles to applications, showing which roles interact with which applications and in what capacity (viewer, editor, administrator). Supports security and access planning.

#### 3. Application/Function Matrix
Maps applications to business functions, showing which applications support which business functions. Reveals functional overlap and gaps.

```
                    │ Order  │ CRM   │ ERP   │ BI      │ E-Commerce
                    │ Mgmt   │       │       │ Platform│ Platform
────────────────────┼────────┼───────┼───────┼─────────┼──────────
Sales Mgmt          │   X    │   X   │       │    X    │     X
Inventory           │   X    │       │   X   │    X    │
Financial Reporting │        │       │   X   │    X    │
Customer Support    │   X    │   X   │       │         │
Procurement         │        │       │   X   │         │
```

#### 4. Application Interaction Matrix
Maps interactions (data flows, service calls, events) between applications. Critical for understanding integration complexity and dependencies.

### Application Architecture Diagrams

Phase C defines the following diagrams for Application Architecture:

#### 1. Application Communication Diagram
Shows the logical or physical application components and the communication (data/service) connections between them. One of the most important diagrams in Application Architecture.

```
┌──────────┐   REST API   ┌──────────┐   Events    ┌───────────┐
│ Web      │─────────────►│ Order    │────────────►│ Inventory │
│ Portal   │              │ Service  │             │ Service   │
└──────────┘              └────┬─────┘             └───────────┘
                               │ JDBC
                          ┌────▼─────┐
                          │ Order    │
                          │ Database │
                          └──────────┘
```

#### 2. Application and User Location Diagram
Shows the geographical distribution of applications and their users. Important for performance, latency, and compliance considerations.

#### 3. Application Use-Case Diagram
Describes the functional requirements of applications in terms of use cases. Connects business requirements to application behavior.

#### 4. Enterprise Manageability Diagram
Shows how applications are managed, monitored, and controlled across the enterprise. Covers operational aspects like logging, alerting, and configuration management.

#### 5. Process/Application Realization Diagram
Maps business processes (from Phase B) to the applications that realize them. Directly connects business architecture to application architecture.

#### 6. Software Engineering Diagram
Shows the development environment, build processes, and deployment pipelines for application components. Relevant for DevOps and CI/CD considerations.

#### 7. Application Migration Diagram
Shows the transition from baseline to target application portfolio, including interim states. Identifies the sequencing and dependencies of application changes.

#### 8. Software Distribution Diagram
Shows how software is distributed and deployed across the technology infrastructure. Includes deployment topology, installation mechanisms, and update strategies.

### Developing Baseline and Target Application Architectures

**Baseline Application Architecture:**
- Inventory all current applications (the Application Portfolio Catalog).
- Document current application interactions and integration patterns.
- Assess technical fitness, business alignment, and lifecycle state of each application.
- Identify known pain points: redundancy, poor integration, technical debt, and unsupported platforms.

**Target Application Architecture:**
- Define the future-state application landscape driven by business requirements.
- Rationalize the application portfolio — eliminate redundancy, consolidate where appropriate.
- Define new applications or services needed to address business capability gaps.
- Establish integration patterns (APIs, events, batch) for the target state.
- Align application boundaries with business domains (consider domain-driven design principles).

### Gap Analysis for Application Architecture

Gap analysis compares baseline and target application architectures to identify:

- **New applications** to be developed or procured
- **Applications to be retired** or decommissioned
- **Applications requiring modification** (feature additions, re-platforming, re-hosting)
- **Integration gaps** where new interfaces or middleware are needed
- **Consolidation opportunities** where multiple applications serve overlapping functions

---

## Inputs, Steps, and Outputs

### Inputs to Phase C

| Input | Source |
|-------|--------|
| Architecture Reference Materials | External / Architecture Repository |
| Request for Architecture Work | Sponsor / Phase A |
| Capability Assessment | Phases A, B |
| Communications Plan | Phase A |
| Organization Model for Enterprise Architecture | Preliminary Phase |
| Tailored Architecture Framework | Preliminary Phase |
| Architecture Principles (including Data Principles) | Preliminary Phase |
| Statement of Architecture Work | Phase A |
| Architecture Vision | Phase A |
| Architecture Repository | All prior phases |
| Draft Architecture Documents and Draft Architecture Requirements Specification (Business Architecture) | Phase B |
| Business Architecture components of the Architecture Roadmap | Phase B |

### Steps in Phase C

The key steps are the same for both Data and Application Architecture sub-phases:

1. **Select reference models, viewpoints, and tools** — Choose appropriate frameworks, reference models (e.g., TOGAF TRM, III-RM), and modeling tools.
2. **Develop Baseline Data/Application Architecture Description** — Document the current state using catalogs, matrices, and diagrams.
3. **Develop Target Data/Application Architecture Description** — Design the future state aligned with business requirements and Architecture Vision.
4. **Perform gap analysis** — Compare baseline to target, identifying gaps, overlaps, and impacts.
5. **Define candidate roadmap components** — Propose work packages, projects, or initiatives to close the gaps.
6. **Resolve impacts across the Architecture Landscape** — Assess how Information Systems Architecture changes affect other architecture domains.
7. **Conduct formal stakeholder review** — Present findings and obtain approval from key stakeholders.
8. **Finalize the Information Systems Architecture** — Incorporate feedback and update architecture deliverables.
9. **Create Architecture Definition Document** — Document the complete Information Systems Architecture.

### Outputs of Phase C

| Output | Description |
|--------|-------------|
| Refined and updated Architecture Vision | Reflecting IS Architecture insights |
| Draft Architecture Definition Document (Data and Application) | Core deliverable containing target architecture |
| Draft Architecture Requirements Specification (updated) | Requirements including IS-specific constraints |
| Data Architecture components of the Architecture Roadmap | Roadmap items for data domain |
| Application Architecture components of the Architecture Roadmap | Roadmap items for application domain |
| IS Architecture catalogs (Data Entity catalog, Application Portfolio catalog) | Inventories and classifications |
| IS Architecture matrices (CRUD matrix, Application/Function matrix, etc.) | Relationship mappings |
| IS Architecture diagrams (all diagrams listed above) | Visual models |
| Gap analysis results (Data and Application) | Identified gaps between baseline and target |
| Impact analysis results | Cross-domain impact assessment |

---

## Relationship Between Data and Application Architectures

Data and Application Architectures are deeply interdependent:

- **Applications create, read, update, and delete data** — the CRUD matrix explicitly models this relationship.
- **Data entities define the information contracts** between application components.
- **Application boundaries influence data ownership** — each application component typically "owns" certain data entities.
- **Data integration requirements drive application integration patterns** — the need to share data between applications determines integration architecture.
- **Data quality and governance depend on application behavior** — applications are the mechanism through which data governance policies are enforced.

```
┌─────────────────────────────────────────────────────┐
│           Information Systems Architecture          │
│                                                     │
│  ┌───────────────┐         ┌─────────────────────┐  │
│  │    Data        │ ◄─────► │   Application       │  │
│  │  Architecture  │ CRUD    │   Architecture      │  │
│  │               │ Matrix   │                     │  │
│  │  - Entities   │         │  - Components       │  │
│  │  - Models     │         │  - Services         │  │
│  │  - Stores     │         │  - Interactions     │  │
│  │  - Governance │         │  - Portfolio        │  │
│  └───────────────┘         └─────────────────────┘  │
└─────────────────────────────────────────────────────┘
```

> **Exam Tip:** The exam may ask which artifacts connect Data Architecture and Application Architecture. The answer is the **Data Entity/Business Function matrix (CRUD matrix)** and the **Data Dissemination Diagram**, which shows data flow between application components.

---

## Exam Review Questions

### Question 1
**What are the two sub-architectures developed in Phase C?**

**Answer:** Data Architecture and Application Architecture. These can be developed in either order depending on the enterprise context and which is the primary driver.

---

### Question 2
**What is the purpose of the Data Entity/Business Function matrix?**

**Answer:** It maps data entities to business functions using CRUD notation (Create, Read, Update, Delete), showing which business functions interact with which data entities and in what manner. It helps identify data ownership, redundancy, and integration requirements.

---

### Question 3
**What is the difference between a logical application component and a physical application component?**

**Answer:** A logical application component is a technology-independent description of a unit of application functionality (e.g., "Customer Relationship Management"). A physical application component is a specific implementation of that functionality (e.g., "Salesforce CRM" or a "custom Java microservice"). Logical components describe "what" is needed; physical components describe "how" it is realized.

---

### Question 4
**Which diagram shows how data flows and is replicated between application components?**

**Answer:** The Data Dissemination Diagram. It shows the relationship between data entities, business services, and application components, illustrating how data is replicated, transformed, or shared across the enterprise.

---

### Question 5
**What is the Application Portfolio Catalog?**

**Answer:** A comprehensive inventory of all applications in the enterprise, including information such as application name, type, business capability supported, technical fitness, business value, lifecycle state, and ownership. It serves as the single source of truth for application management decisions.

---

### Question 6
**In what order must Data Architecture and Application Architecture be developed in Phase C?**

**Answer:** TOGAF does not mandate a specific order. They can be developed Data-first, Application-first, or in parallel, depending on the enterprise context. Data-driven organizations may prefer Data first, while application-centric initiatives may prefer Application first.

---

### Question 7
**What is the purpose of gap analysis in Phase C?**

**Answer:** Gap analysis compares the baseline and target architectures (for both Data and Application) to identify what is new, what must be modified, what must be eliminated, and what remains unchanged. The results feed into the Architecture Roadmap and drive work package identification in Phase E.

---

### Question 8
**Which matrix maps applications to business functions?**

**Answer:** The Application/Function Matrix. It shows which applications support which business functions, revealing functional overlaps and gaps in the application portfolio.

---

### Question 9
**What does the Application Communication Diagram show?**

**Answer:** It shows the logical or physical application components and the communication connections (data flows, service calls, events) between them. It is one of the most important diagrams for understanding integration complexity.

---

### Question 10
**What is a Data Entity in TOGAF?**

**Answer:** A data entity is an encapsulation of data that is recognized by a business domain expert as a discrete, meaningful concept. Examples include Customer, Order, Product, Invoice. Data entities are the fundamental building blocks of Data Architecture.

---

### Question 11
**How does Phase C relate to Phase B?**

**Answer:** Phase C's Information Systems Architecture must support and enable the Business Architecture defined in Phase B. The business functions, processes, and services from Phase B drive the requirements for what data entities and application components are needed. The Process/Application Realization Diagram directly connects Phase B processes to Phase C applications.

---

### Question 12
**What inputs does Phase C receive from Phase B?**

**Answer:** Key inputs include the Draft Architecture Documents (Business Architecture), Draft Architecture Requirements Specification (Business Architecture), and Business Architecture components of the Architecture Roadmap. These provide the business context that Phase C must support.

---

### Question 13
**What is the Application Interaction Matrix?**

**Answer:** A matrix that maps the interactions (data flows, service calls, events, and dependencies) between application components. It is critical for understanding integration complexity and identifying coupling and dependency risks.

---

### Question 14
**What is the Data Lifecycle Diagram used for?**

**Answer:** It depicts the stages a data entity goes through from creation to retirement, including creation, storage, usage, archival, and deletion. It shows the business and technology events that trigger transitions between lifecycle states and addresses data retention, archival, and disposal requirements.

---

### Question 15
**What role does the Data Security Diagram play in Phase C?**

**Answer:** It illustrates the security classifications applied to data entities, maps data access controls and encryption requirements, and links data classification to user roles and application components. It ensures that data protection and compliance requirements are addressed in the architecture.

---

### Question 16
**What are the key outputs of Phase C?**

**Answer:** Key outputs include the refined Architecture Vision, Draft Architecture Definition Document (covering Data and Application), Draft Architecture Requirements Specification, Data and Application Architecture components of the Architecture Roadmap, IS Architecture catalogs, matrices, and diagrams, and the gap analysis and impact analysis results.

---

### Question 17
**What is the Process/Application Realization Diagram?**

**Answer:** It maps business processes (defined in Phase B Business Architecture) to the application components that realize and support those processes. It directly connects business architecture to application architecture and ensures that every business process has adequate application support.

---

## Key Exam Takeaways

1. **Phase C covers TWO sub-architectures** (Data and Application) — both must be addressed.
2. The order of Data and Application architecture development is **flexible**, not fixed.
3. The **Data Entity/Business Function matrix (CRUD matrix)** is a critical linking artifact.
4. Know the distinction between **logical** and **physical** components for both Data and Application.
5. **Gap analysis** in Phase C feeds directly into Phase E (Opportunities and Solutions).
6. Phase C builds upon Phase B outputs and provides inputs to Phase D.
7. The **Application Portfolio Catalog** is central to application rationalization decisions.
8. Understand what each diagram type shows — the exam tests recognition of diagram purposes.
9. Data Architecture addresses **governance, quality, security, and lifecycle** — not just data modeling.
10. Application Architecture addresses **portfolio management, integration, and rationalization** — not just development.
