# Module 05: Architecture Content Framework

> **Comprehensive study guide for the TOGAF 10 certification exam — Architecture Content Framework**

---

## Overview

The **Architecture Content Framework** provides a structural model for architectural content that allows major work products to be consistently defined, structured, and presented. It answers the question: *"What outputs does the ADM produce, and how are they organized?"*

The Content Framework is one of the three core pillars of TOGAF's Fundamental Content (alongside the ADM and ADM Guidelines & Techniques). It is heavily tested on both Part 1 and Part 2 of the TOGAF certification exam.

```
┌──────────────────────────────────────────────────────────────┐
│             ARCHITECTURE CONTENT FRAMEWORK                    │
│                                                              │
│  ┌──────────────────────────────────────────────────────┐   │
│  │              CONTENT METAMODEL                        │   │
│  │   Defines entities, attributes, and relationships     │   │
│  └──────────────────────────────────────────────────────┘   │
│                          │                                   │
│          ┌───────────────┼───────────────┐                  │
│          ▼               ▼               ▼                  │
│  ┌──────────────┐ ┌──────────────┐ ┌──────────────┐       │
│  │ DELIVERABLES │ │  ARTIFACTS   │ │  BUILDING    │       │
│  │              │ │              │ │  BLOCKS      │       │
│  │ Contractually│ │ Catalogs     │ │              │       │
│  │ specified    │ │ Matrices     │ │ ABBs         │       │
│  │ work products│ │ Diagrams     │ │ SBBs         │       │
│  └──────────────┘ └──────────────┘ └──────────────┘       │
└──────────────────────────────────────────────────────────────┘
```

### Three Key Content Types

| Content Type | Definition | Examples |
|---|---|---|
| **Deliverables** | Contractually specified work products that are formally reviewed, agreed, and signed off by stakeholders | Architecture Definition Document, Architecture Roadmap |
| **Artifacts** | More granular architectural work products that describe an architecture from a specific viewpoint — contained within deliverables | Catalogs, Matrices, Diagrams |
| **Building Blocks** | Reusable components of business, IT, or architectural capability | Architecture Building Blocks (ABBs), Solution Building Blocks (SBBs) |

**Exam Tip:** A single deliverable may contain multiple artifacts. For example, the Architecture Definition Document contains catalogs, matrices, and diagrams from Phases B through D.

---

## 1. Content Metamodel

### What Is the Content Metamodel?

The **Content Metamodel** defines a formal structure for architectural content by specifying the types of entities (things), their attributes (properties), and their relationships (how they connect). It provides a standard vocabulary and structure so that architecture content is consistent and interoperable.

Think of the metamodel as the "database schema" for architecture content — it defines what types of things can be stored and how they relate.

### Core vs. Full Content Metamodel

TOGAF defines two levels of metamodel:

| Metamodel Level | Description | Usage |
|---|---|---|
| **Core Content Metamodel** | A minimal set of entities and relationships sufficient for most architecture work | Recommended starting point for all organizations |
| **Full Content Metamodel** | An extended set that includes additional entities and relationships for more sophisticated architecture practices | For mature organizations needing detailed architecture management |

### Metamodel Extensions

The Full Content Metamodel can be extended with several optional modules:

| Extension | Description |
|---|---|
| **Governance Extension** | Adds entities for contracts, compliance, standards, and governance processes |
| **Services Extension** | Adds detailed service-related entities for SOA and service-oriented approaches |
| **Process Modeling Extension** | Adds entities for detailed business process modeling (events, controls, products) |
| **Data Extension** | Adds entities for detailed data modeling (logical and physical data entities) |
| **Infrastructure Consolidation Extension** | Adds entities for infrastructure and location-based architecture |
| **Motivation Extension** | Adds entities for drivers, goals, objectives, and measures that motivate the architecture |

---

## 2. Content Metamodel Entities

The metamodel defines the following key entities. Each entity represents a distinct type of architectural element.

### Core Entities

| Entity | Definition | Architecture Domain |
|---|---|---|
| **Actor** | A person, organization, or system that has a role that initiates or interacts with activities | Business |
| **Application Component** | An encapsulation of application functionality, aligned to implementation structure | Application |
| **Business Service** | A service that supports business capabilities; defined by the business for the business | Business |
| **Constraint** | An external factor that limits the realization of the architecture | Cross-domain |
| **Contract** | An agreement between a service consumer and a service provider that establishes functional and non-functional parameters for interaction | Cross-domain |
| **Data Entity** | An encapsulation of data that is recognized by a business domain expert as a discrete concept | Data |
| **Event** | An organizational state change that triggers processing events; may originate from inside or outside the organization | Business/Application |
| **Function** | A unit of business capability; delivers business value at a defined level of granularity | Business |
| **Gap** | A statement of difference between the Baseline and Target Architectures | Cross-domain |
| **Goal** | A high-level statement of intent, direction, or desired end state for the organization and its stakeholders | Business |
| **Information System Service** | The automated elements of a business service — realized through application components | Application |
| **Location** | A place where business activity takes place and which can be mapped to technology infrastructure | Cross-domain |
| **Measure** | An indicator or factor that can be tracked, usually expressed quantitatively, to assess performance against objectives | Business |
| **Objective** | A time-bounded milestone for an organization; a specific, measurable target derived from a Goal | Business |
| **Organization Unit** | A self-contained unit of people and resources with goals, objectives, and measures | Business |
| **Platform Service** | A technical capability required to provide enabling infrastructure for the delivery of applications | Technology |
| **Principle** | A qualitative statement of intent that should be met by the architecture; has at least a supporting rationale and measure of importance | Cross-domain |
| **Process** | A flow of activities triggered by an event that achieves a business outcome; processes may decompose into sub-processes | Business |
| **Requirement** | A quantitative statement of business need that must be met by a particular architecture or work package | Cross-domain |
| **Role** | The usual or expected function of an actor, or the part somebody or something plays in a particular action or event | Business |
| **Service** | An element of behavior that provides specific value; abstracts the underlying complexity of the implementation | Cross-domain |
| **Technology Component** | An encapsulation of technology infrastructure that represents a technology solution entity | Technology |
| **Work Package** | A set of actions identified to achieve one or more objectives for the business; can be a part of a project or a complete project | Cross-domain |

### Extended Entities (Full Metamodel)

| Entity | Definition | Extension |
|---|---|---|
| **Assumption** | A statement of fact or situation taken for granted | Governance |
| **Business Capability** | A particular ability that a business may possess or exchange to achieve a specific purpose | Motivation |
| **Communication Style** | The approach to presenting and sharing information to stakeholders | Governance |
| **Control** | A decision-making step with accompanying decision logic used to determine execution approach | Process Modeling |
| **Course of Action** | Direction and focus provided by strategic goals and objectives, translated into actions and resource allocation | Motivation |
| **Deliverable** | An architecturally significant work product | Governance |
| **Driver** | An external or internal condition that motivates the organization to define goals and implement changes | Motivation |
| **Logical Application Component** | An encapsulation of application functionality that is independent of implementation | Services |
| **Logical Data Component** | A boundary zone that encapsulates related data entities | Data |
| **Logical Technology Component** | An encapsulation of technology infrastructure independent of specific products | Infrastructure |
| **Physical Application Component** | An application, application module, application service, or software component | Services |
| **Physical Data Component** | A boundary zone that encapsulates related data entities to a specific physical implementation | Data |
| **Physical Technology Component** | A specific technology infrastructure product or component | Infrastructure |
| **Product** | A goods or service offered to customers | Process Modeling |
| **Standard** | An agreed-upon approach, specification, or product to be used in the architecture | Governance |
| **Value Stream** | A representation of an end-to-end collection of value-adding activities | Motivation |

### Entity Relationships

The metamodel defines how entities connect. Key relationships include:

```
┌──────────────┐         ┌──────────────┐         ┌──────────────┐
│   Goal       │ decomposes│  Objective   │ measures │   Measure    │
│              │──────────→│              │──────────→│              │
└──────────────┘  into    └──────────────┘         └──────────────┘

┌──────────────┐         ┌──────────────┐         ┌──────────────┐
│Organization  │ owns     │  Function    │ realizes │  Business    │
│   Unit       │─────────→│              │─────────→│  Service     │
└──────────────┘         └──────────────┘         └──────────────┘

┌──────────────┐         ┌──────────────┐         ┌──────────────┐
│  Business    │ realized │ Information  │ realized │ Application  │
│  Service     │── by ───→│ System       │── by ───→│ Component    │
│              │         │ Service      │         │              │
└──────────────┘         └──────────────┘         └──────────────┘

┌──────────────┐         ┌──────────────┐         ┌──────────────┐
│ Application  │ hosted   │ Platform     │ realized │ Technology   │
│ Component    │── on ───→│ Service      │── by ───→│ Component    │
└──────────────┘         └──────────────┘         └──────────────┘

┌──────────────┐  performs ┌──────────────┐ operates in ┌──────────────┐
│   Actor      │─────────→│    Role       │────────────→│  Location    │
└──────────────┘          └──────────────┘             └──────────────┘

┌──────────────┐  accesses ┌──────────────┐
│ Application  │──────────→│  Data Entity  │
│ Component    │           │               │
└──────────────┘           └───────────────┘

┌──────────────┐  triggers ┌──────────────┐ generates ┌──────────────┐
│   Event      │──────────→│  Process      │──────────→│  Event       │
└──────────────┘           └──────────────┘           └──────────────┘
```

**Key Relationship Chains (for exam):**

1. **Goal → Objective → Measure** (strategic decomposition)
2. **Organization Unit → Function → Business Service** (business capability delivery)
3. **Business Service → IS Service → Application Component** (service realization)
4. **Application Component → Platform Service → Technology Component** (technology stack)
5. **Actor → Role → Function → Process** (who does what)
6. **Data Entity → Application Component → Technology Component** (data hosting)

---

## 3. Architecture Deliverables

Deliverables are the formal, contractually specified work products of the ADM. They are reviewed, agreed, and signed off by stakeholders. Below is a comprehensive list of all key deliverables.

### Complete List of Architecture Deliverables

#### 3.1 Architecture Principles

| Attribute | Detail |
|---|---|
| **Definition** | A set of general rules and guidelines that inform and support architecture decisions |
| **Created In** | Preliminary Phase |
| **Used In** | All phases |
| **Contains** | Name, Statement, Rationale, Implications for each principle |
| **Signed Off By** | Architecture Board, Sponsor |

#### 3.2 Request for Architecture Work

| Attribute | Detail |
|---|---|
| **Definition** | A document from the sponsoring organization requesting the development of an architecture |
| **Created In** | Preliminary Phase (triggers Phase A) |
| **Used In** | Phase A |
| **Contains** | Organization sponsors, scope, constraints, budget, timelines, business goals |
| **Signed Off By** | Sponsoring organization |

#### 3.3 Architecture Vision

| Attribute | Detail |
|---|---|
| **Definition** | A high-level, aspirational view of the end architecture; provides a summary of changes needed to achieve the business strategy |
| **Created In** | Phase A |
| **Used In** | All subsequent phases as a reference |
| **Contains** | Problem description, objective, summary views of Baseline/Target, stakeholder concerns, key requirements |
| **Signed Off By** | Sponsor, Architecture Board, Key Stakeholders |

#### 3.4 Statement of Architecture Work

| Attribute | Detail |
|---|---|
| **Definition** | Defines the scope and approach for completing an architecture project; a contract between the architect and the sponsor |
| **Created In** | Phase A |
| **Used In** | Governs phases B through F |
| **Contains** | Scope, architecture approach, deliverables, acceptance criteria, schedule, risks, budget |
| **Signed Off By** | Sponsor, Lead Architect |

#### 3.5 Architecture Definition Document

| Attribute | Detail |
|---|---|
| **Definition** | The container for the core architectural deliverables from each domain (B, C, D); provides a qualitative view of the solution |
| **Created In** | Phases B, C, D (progressively) |
| **Used In** | Phases E, F, G |
| **Contains** | Baseline Architecture, Target Architecture for each domain; Architecture Artifacts (catalogs, matrices, diagrams); gap analysis results; rationale |
| **Signed Off By** | Architecture Board, Domain Architects |

#### 3.6 Architecture Requirements Specification

| Attribute | Detail |
|---|---|
| **Definition** | A quantitative, testable set of requirements that must be met by the Target Architecture; the companion to the Architecture Definition Document |
| **Created In** | Phases B, C, D (progressively) |
| **Used In** | Phases E, F, G for validation |
| **Contains** | Success measures, architecture requirements (functional, non-functional), service contracts, implementation guidelines, conformance requirements |
| **Signed Off By** | Architecture Board, Key Stakeholders |

#### 3.7 Architecture Roadmap

| Attribute | Detail |
|---|---|
| **Definition** | Lists individual work packages in a timeline that will realize the Target Architecture; shows the incremental path from Baseline to Target |
| **Created In** | Phases B through F (progressively) |
| **Used In** | Phases E, F, G |
| **Contains** | Work package descriptions, timeline, dependencies, transition architectures |
| **Signed Off By** | Architecture Board, Sponsor |

#### 3.8 Transition Architecture

| Attribute | Detail |
|---|---|
| **Definition** | A formally defined intermediate state of the architecture between Baseline and Target; a stable, operable state that delivers value |
| **Created In** | Phase E (defined), Phase F (detailed) |
| **Used In** | Phases F, G |
| **Contains** | Architecture state descriptions for each transition; builds progressively on the Architecture Definition Document |
| **Signed Off By** | Architecture Board, Sponsor |

#### 3.9 Implementation and Migration Plan

| Attribute | Detail |
|---|---|
| **Definition** | A detailed plan for the implementation of the Target Architecture through a series of Transition Architectures |
| **Created In** | Phase F |
| **Used In** | Phase G |
| **Contains** | Implementation project list, sequencing, dependencies, migration approach, resource requirements, schedule, costs |
| **Signed Off By** | Architecture Board, Sponsor, Program Management |

#### 3.10 Implementation Governance Model

| Attribute | Detail |
|---|---|
| **Definition** | Defines the governance framework for monitoring and managing the implementation of the architecture |
| **Created In** | Phase F (planned), Phase G (executed) |
| **Used In** | Phase G, Phase H |
| **Contains** | Governance organization, compliance processes, exception handling, decision-making authority |
| **Signed Off By** | Architecture Board, Sponsor |

#### 3.11 Architecture Contract

| Attribute | Detail |
|---|---|
| **Definition** | A joint agreement between the architecture function and implementation partners that governs the development and deployment |
| **Created In** | Phase G |
| **Used In** | Phase G, Phase H |
| **Contains** | Scope, roles and responsibilities, acceptance criteria, deliverables, architecture compliance requirements, SLAs |
| **Signed Off By** | Lead Architect, Implementation Lead, Sponsor |

#### 3.12 Compliance Assessment

| Attribute | Detail |
|---|---|
| **Definition** | An evaluation of whether the implementation conforms to the approved architecture |
| **Created In** | Phase G |
| **Used In** | Phase G, Phase H |
| **Contains** | Compliance review checklist results, non-compliance items, dispensations, recommended actions |
| **Signed Off By** | Architecture Board |

#### 3.13 Change Request

| Attribute | Detail |
|---|---|
| **Definition** | A request to modify the architecture due to new drivers, requirements, or issues discovered during implementation |
| **Created In** | Phase H (also Phase G when issues arise) |
| **Used In** | Feeds back into the ADM cycle |
| **Contains** | Description of change, rationale, impact assessment, recommended action |
| **Signed Off By** | Architecture Board |

#### 3.14 Architecture Building Blocks (ABBs)

| Attribute | Detail |
|---|---|
| **Definition** | Reusable architecture components that capture architecture requirements and direct/guide the development of SBBs |
| **Created In** | Phases B, C, D |
| **Used In** | Phase E (mapped to SBBs) |
| **Contains** | Fundamental functionality definition, interfaces, interoperability requirements, relationship to other ABBs |
| **Signed Off By** | Architecture Board |

#### 3.15 Solution Building Blocks (SBBs)

| Attribute | Detail |
|---|---|
| **Definition** | Components of the solution that implement the functionality defined in the ABBs; product or vendor-specific |
| **Created In** | Phase E |
| **Used In** | Phases F, G |
| **Contains** | Specific product/vendor information, implementation details, configuration, interfaces |
| **Signed Off By** | Architecture Board, Solution Architects |

#### 3.16 Communications Plan

| Attribute | Detail |
|---|---|
| **Definition** | Defines the approach for communicating architecture information to stakeholders |
| **Created In** | Phase A |
| **Used In** | All phases |
| **Contains** | Stakeholder communication needs, communication methods, frequency, responsible parties |
| **Signed Off By** | Lead Architect, Sponsor |

#### 3.17 Organization Model for Enterprise Architecture

| Attribute | Detail |
|---|---|
| **Definition** | Defines the organizational structure, roles, and responsibilities for the architecture practice |
| **Created In** | Preliminary Phase |
| **Used In** | All phases |
| **Contains** | Architecture team structure, roles, skills, budget, governance bodies |
| **Signed Off By** | Sponsor, CIO |

#### 3.18 Tailored Architecture Framework

| Attribute | Detail |
|---|---|
| **Definition** | A customized version of TOGAF tailored to the specific needs of the organization |
| **Created In** | Preliminary Phase |
| **Used In** | All phases |
| **Contains** | Tailored ADM process, selected deliverables, terminology mapping, organizational adaptations |
| **Signed Off By** | Architecture Board, Sponsor |

#### 3.19 Requirements Impact Assessment

| Attribute | Detail |
|---|---|
| **Definition** | An assessment of the impact of new or changed requirements on the current architecture |
| **Created In** | Requirements Management (throughout) |
| **Used In** | All phases when requirements change |
| **Contains** | New/changed requirement description, affected phases, impact analysis, recommended action |
| **Signed Off By** | Lead Architect, Requirements Manager |

#### 3.20 Architecture Repository

| Attribute | Detail |
|---|---|
| **Definition** | The storage facility for all architecture-related work products; the comprehensive record of architectural assets |
| **Created In** | Preliminary Phase (established); populated throughout |
| **Used In** | All phases |
| **Contains** | Architecture Metamodel, Architecture Landscape, Standards Information Base, Reference Library, Governance Log |
| **Signed Off By** | Architecture Board (governance) |

---

## 4. Architecture Artifacts

Artifacts are the granular work products contained within deliverables. TOGAF categorizes artifacts into three types: **Catalogs**, **Matrices**, and **Diagrams**.

### Catalogs

Catalogs are **lists of things** — structured inventories of architectural elements of a specific type.

| Catalog | Description | Created In | Domain |
|---|---|---|---|
| **Principles Catalog** | Lists all architecture principles | Preliminary | Cross-domain |
| **Organization/Actor Catalog** | Lists organization units, actors, and their roles | Phase B | Business |
| **Driver/Goal/Objective Catalog** | Lists business drivers, goals, and objectives | Phase B | Business |
| **Role Catalog** | Lists business roles and their descriptions | Phase B | Business |
| **Business Service/Function Catalog** | Lists business services and functions | Phase B | Business |
| **Location Catalog** | Lists business locations and site information | Phase B | Business |
| **Process/Event/Control/Product Catalog** | Lists business processes, events, controls, and products | Phase B | Business |
| **Contract/Measure Catalog** | Lists service contracts and performance measures | Phase B | Business |
| **Data Entity/Data Component Catalog** | Lists data entities and their logical groupings | Phase C (Data) | Data |
| **Application Portfolio Catalog** | Lists all applications in the portfolio with key attributes | Phase C (App) | Application |
| **Interface Catalog** | Lists application interfaces and integration points | Phase C (App) | Application |
| **Technology Standards Catalog** | Lists approved technology standards and products | Phase D | Technology |
| **Technology Portfolio Catalog** | Lists technology components in the current portfolio | Phase D | Technology |
| **Requirements Catalog** | Lists architecture requirements (cross-domain) | Requirements Mgmt | Cross-domain |
| **Gap Catalog** | Lists identified gaps between Baseline and Target | Phases B, C, D | Cross-domain |

### Matrices

Matrices show **relationships between things** — they map entities from one type to entities of another type.

| Matrix | Description | Created In | Shows Relationship Between |
|---|---|---|---|
| **Stakeholder Map Matrix** | Maps stakeholders to their power, interest, and management approach | Phase A | Stakeholders ↔ Influence/Interest |
| **Business Interaction Matrix** | Shows interactions between organization units | Phase B | Org Unit ↔ Org Unit |
| **Actor/Role Matrix** | Maps actors to their roles | Phase B | Actor ↔ Role |
| **Business Function/Organization Matrix** | Maps business functions to organization units | Phase B | Function ↔ Org Unit |
| **Business Service/Information Matrix** | Maps business services to the information they use | Phase B | Service ↔ Data Entity |
| **Data Entity/Business Function Matrix** | Maps data entities to the business functions that create, read, update, delete them (CRUD) | Phase C (Data) | Data Entity ↔ Function |
| **Application/Organization Matrix** | Maps applications to the organization units that use them | Phase C (App) | App Component ↔ Org Unit |
| **Application/Function Matrix** | Maps applications to the business functions they support | Phase C (App) | App Component ↔ Function |
| **Role/Application Matrix** | Maps roles to the applications they interact with | Phase C (App) | Role ↔ App Component |
| **Application/Technology Matrix** | Maps applications to their hosting technology | Phase D | App Component ↔ Technology Component |
| **Application Interaction Matrix** | Shows interactions between applications | Phase C (App) | App Component ↔ App Component |
| **Technology Standards Compliance Matrix** | Maps technology components to approved standards | Phase D | Technology ↔ Standard |
| **Consolidated Gaps, Solutions, Dependencies Matrix** | Maps gaps to potential solutions and their dependencies | Phase E | Gap ↔ Solution ↔ Dependency |

### Diagrams

Diagrams provide **visual representations** of architectural content from specific viewpoints.

| Diagram | Description | Created In | Domain |
|---|---|---|---|
| **Stakeholder Map Diagram** | Visual representation of stakeholder power/interest | Phase A | Cross-domain |
| **Business Model Diagram** | High-level view of the business model | Phase A/B | Business |
| **Value Chain Diagram** | Shows key business activities and their value contribution | Phase B | Business |
| **Value Stream Map** | End-to-end view of value creation across the enterprise | Phase B | Business |
| **Business Capability Map** | Hierarchical view of business capabilities | Phase B | Business |
| **Organization Decomposition Diagram** | Shows organizational hierarchy and structure | Phase B | Business |
| **Business Service/Information Diagram** | Shows business services and the information they exchange | Phase B | Business |
| **Functional Decomposition Diagram** | Hierarchical breakdown of business functions | Phase B | Business |
| **Product Lifecycle Diagram** | Shows lifecycle stages of key business products/services | Phase B | Business |
| **Goal/Objective/Service Diagram** | Links goals to objectives to the services that support them | Phase B | Business |
| **Business Use-Case Diagram** | Shows business use cases and the actors involved | Phase B | Business |
| **Organization/Actor Catalog Diagram** | Visual representation of the actor catalog | Phase B | Business |
| **Process Flow Diagram** | Detailed flow of business processes | Phase B | Business |
| **Event Diagram** | Shows events and their triggers/responses | Phase B | Business |
| **Conceptual Data Diagram** | High-level view of data entities and relationships | Phase C (Data) | Data |
| **Logical Data Diagram** | Detailed logical data model with entities, attributes, relationships | Phase C (Data) | Data |
| **Data Dissemination Diagram** | Shows how data flows between components and business entities | Phase C (Data) | Data |
| **Data Lifecycle Diagram** | Shows the lifecycle of key data entities | Phase C (Data) | Data |
| **Data Security Diagram** | Shows data security classifications and access controls | Phase C (Data) | Data |
| **Data Migration Diagram** | Shows how data will be migrated from legacy to target | Phase C (Data) | Data |
| **Application Communication Diagram** | Shows application-to-application communication | Phase C (App) | Application |
| **Application and User Location Diagram** | Maps applications to the locations where users access them | Phase C (App) | Application |
| **Application Use-Case Diagram** | Shows application use cases | Phase C (App) | Application |
| **Enterprise Manageability Diagram** | Shows how applications are managed and monitored | Phase C (App) | Application |
| **Software Engineering Diagram** | Shows software development and component structure | Phase C (App) | Application |
| **Application Migration Diagram** | Shows migration path for applications | Phase C (App) | Application |
| **Software Distribution Diagram** | Shows how software is distributed across infrastructure | Phase C (App) | Application |
| **Environments and Locations Diagram** | Shows technology environments (dev, test, prod) and locations | Phase D | Technology |
| **Platform Decomposition Diagram** | Breaks down technology platforms into constituent components | Phase D | Technology |
| **Processing Diagram** | Shows processing nodes and their deployment | Phase D | Technology |
| **Networked Computing/Hardware Diagram** | Shows network topology and hardware layout | Phase D | Technology |
| **Communications Engineering Diagram** | Details communication links and protocols | Phase D | Technology |
| **Benefits Diagram** | Maps architecture changes to business benefits | Phase E/F | Cross-domain |
| **Project Context Diagram** | Shows how implementation projects relate to one another | Phase E/F | Cross-domain |
| **Implementation Factor Assessment Diagram** | Visualizes the implementation factor analysis | Phase E/F | Cross-domain |

---

## 5. Building Blocks

### What Are Building Blocks?

A **Building Block** is a (potentially reusable) component of business, IT, or architectural capability that can be combined with other building blocks to deliver architectures and solutions. Building blocks are the fundamental components from which architectures are constructed.

### Architecture Building Blocks (ABBs) vs. Solution Building Blocks (SBBs)

| Characteristic | Architecture Building Blocks (ABBs) | Solution Building Blocks (SBBs) |
|---|---|---|
| **Level of Abstraction** | High — describe *what* is needed | Low — describe *how* it is implemented |
| **Product-Specific?** | No — technology and vendor independent | Yes — specific products, versions, vendors |
| **Created In** | Phases B, C, D | Phase E (mapped from ABBs) |
| **Defines** | Required functionality, interfaces, standards | Implementation approach, configuration, products |
| **Example** | "Customer Relationship Management capability" | "Salesforce CRM, Enterprise Edition v23" |
| **Another Example** | "Relational Database Service" | "Oracle Database 19c on AWS RDS" |
| **Another Example** | "Message Queuing Platform" | "Apache Kafka 3.5 on Kubernetes" |
| **Granularity** | Coarse-grained | Fine-grained |
| **Reuse Focus** | Reusable functional requirements | Reusable technical components |

### Characteristics of Good Building Blocks

A well-defined building block:

| Characteristic | Description |
|---|---|
| **Considers implementation and usage** | Practical and implementable, not purely theoretical |
| **May have multiple implementations** | An ABB can be realized by different SBBs |
| **May be assembled from other building blocks** | Building blocks can be composed hierarchically |
| **May have interfaces to other building blocks** | Clearly defined interaction points |
| **Should publish interfaces** | APIs and protocols for interaction are well-documented |
| **Has defined boundaries** | Clear scope of what is included and excluded |
| **Is replaceable** | Can be swapped with another building block that implements the same interface |
| **Is reusable** | Designed for use in multiple contexts |
| **Should be technology-aware** (for SBBs) | SBBs are specific about the technology used |

### How ABBs Map to SBBs

The progression from ABB to SBB follows the ADM phases:

```
Phase B, C, D                    Phase E                    Phase F, G
┌──────────────┐           ┌──────────────┐           ┌──────────────┐
│              │           │              │           │              │
│  Define      │           │  Map ABBs    │           │  Implement   │
│  ABBs        │──────────→│  to SBBs     │──────────→│  SBBs        │
│              │           │              │           │              │
│  "What"      │           │  "How"       │           │  "Build/Buy" │
│              │           │              │           │              │
└──────────────┘           └──────────────┘           └──────────────┘

Example:
ABB: "Customer Data      SBB: "Salesforce         Implementation:
Management Capability"    Data Cloud on AWS"       Deploy, configure,
                                                   integrate, test
```

### Building Block Specification

A building block specification typically includes:

| Component | ABB Specification | SBB Specification |
|---|---|---|
| **Name and Description** | Yes | Yes |
| **Functionality** | Required capabilities | Delivered capabilities |
| **Interfaces** | Required interfaces (abstract) | Published interfaces (concrete APIs) |
| **Interoperability** | Interoperability requirements | Interoperability implementation |
| **Dependencies** | Dependencies on other ABBs | Dependencies on other SBBs and infrastructure |
| **Standards** | Required standards compliance | Supported standards |
| **Performance** | Performance requirements | Performance characteristics |
| **Security** | Security requirements | Security implementation |
| **Vendor/Product** | Not specified | Specific vendor and product |
| **Configuration** | Not applicable | Configuration details |

---

## 6. Deliverables, Artifacts, and Building Blocks Mapped to ADM Phases

### Deliverables by Phase

| ADM Phase | Key Deliverables Produced |
|---|---|
| **Preliminary** | Architecture Principles, Organization Model for EA, Tailored Architecture Framework, Architecture Repository (established) |
| **Phase A** | Architecture Vision, Statement of Architecture Work, Communications Plan, Request for Architecture Work (input) |
| **Phase B** | Architecture Definition Document (business domain), Architecture Requirements Specification (business domain), Architecture Roadmap (initial) |
| **Phase C** | Architecture Definition Document (data + app domains), Architecture Requirements Specification (data + app domains), Architecture Roadmap (updated) |
| **Phase D** | Architecture Definition Document (technology domain), Architecture Requirements Specification (technology domain), Architecture Roadmap (updated) |
| **Phase E** | Transition Architectures, Architecture Roadmap (consolidated), Implementation and Migration Plan (draft), ABB → SBB mapping |
| **Phase F** | Implementation and Migration Plan (final), Transition Architectures (finalized), Implementation Governance Model |
| **Phase G** | Architecture Contract, Compliance Assessment, Change Requests |
| **Phase H** | Change Requests, Requirements Impact Assessment, Architecture updates |
| **Requirements Management** | Requirements Impact Assessment, Requirements Catalog (ongoing) |

### Artifacts by Phase

| ADM Phase | Key Catalogs | Key Matrices | Key Diagrams |
|---|---|---|---|
| **Preliminary** | Principles Catalog | — | — |
| **Phase A** | — | Stakeholder Map Matrix | Stakeholder Map Diagram, Business Model Diagram |
| **Phase B** | Organization/Actor Catalog, Driver/Goal/Objective Catalog, Role Catalog, Business Service/Function Catalog, Location Catalog, Process/Event/Control/Product Catalog, Contract/Measure Catalog | Business Interaction Matrix, Actor/Role Matrix, Business Function/Org Matrix, Business Service/Information Matrix | Value Chain Diagram, Value Stream Map, Organization Decomposition Diagram, Functional Decomposition Diagram, Goal/Objective/Service Diagram, Business Use-Case Diagram, Process Flow Diagram, Event Diagram |
| **Phase C (Data)** | Data Entity/Data Component Catalog | Data Entity/Business Function Matrix | Conceptual Data Diagram, Logical Data Diagram, Data Dissemination Diagram, Data Lifecycle Diagram, Data Security Diagram, Data Migration Diagram |
| **Phase C (App)** | Application Portfolio Catalog, Interface Catalog | Application/Organization Matrix, Application/Function Matrix, Role/Application Matrix, Application Interaction Matrix | Application Communication Diagram, Application and User Location Diagram, Application Use-Case Diagram, Enterprise Manageability Diagram, Application Migration Diagram, Software Distribution Diagram |
| **Phase D** | Technology Standards Catalog, Technology Portfolio Catalog | Application/Technology Matrix, Technology Standards Compliance Matrix | Environments and Locations Diagram, Platform Decomposition Diagram, Processing Diagram, Networked Computing/Hardware Diagram, Communications Engineering Diagram |
| **Phase E** | Gap Catalog | Consolidated Gaps/Solutions/Dependencies Matrix | Benefits Diagram, Project Context Diagram |
| **Phase F** | — | — | Implementation Factor Assessment Diagram |

### Building Blocks by Phase

| ADM Phase | ABBs | SBBs |
|---|---|---|
| **Phase B** | Business ABBs (business services, functions, processes) | — |
| **Phase C** | Data ABBs, Application ABBs | — |
| **Phase D** | Technology ABBs (platform services, infrastructure) | — |
| **Phase E** | ABBs refined and consolidated | SBBs selected and mapped to ABBs |
| **Phase F** | — | SBBs finalized and sequenced |
| **Phase G** | — | SBBs implemented and verified |

---

## 7. Comprehensive Mapping Table: Techniques, Deliverables, Artifacts, Building Blocks by Phase

| Phase | Techniques Used | Deliverables | Artifacts (Examples) | Building Blocks |
|---|---|---|---|---|
| **Preliminary** | Architecture Principles | Principles, Org Model, Tailored Framework, Repository | Principles Catalog | — |
| **A** | Stakeholder Mgmt, Readiness Assessment, Risk Mgmt, Capability-Based Planning | Vision, Statement of Arch Work, Comms Plan | Stakeholder Map Matrix/Diagram | — |
| **B** | Gap Analysis, Interoperability, Risk Mgmt, Patterns | Arch Definition Doc (business), Arch Req Spec (business), Roadmap | Business catalogs, matrices, diagrams | Business ABBs |
| **C** | Gap Analysis, Interoperability, Risk Mgmt, Patterns | Arch Definition Doc (data + app), Arch Req Spec (data + app), Roadmap | Data + App catalogs, matrices, diagrams | Data + App ABBs |
| **D** | Gap Analysis, Interoperability, Risk Mgmt, Patterns | Arch Definition Doc (tech), Arch Req Spec (tech), Roadmap | Tech catalogs, matrices, diagrams | Technology ABBs |
| **E** | Migration Planning, Consolidated Gaps, Business Value | Transition Archs, Roadmap, Impl Plan (draft) | Consolidated Gaps Matrix, Benefits Diagram | ABBs → SBBs |
| **F** | Migration Planning, Business Value, Readiness | Impl & Migration Plan, Governance Model | Implementation Factor Diagram | SBBs finalized |
| **G** | Compliance Review, Risk Mgmt | Arch Contract, Compliance Assessment | Compliance Checklist | SBBs implemented |
| **H** | Risk Mgmt, Change Assessment | Change Requests, Req Impact Assessment | — | — |
| **Req Mgmt** | Risk Mgmt | Requirements Impact Assessment | Requirements Catalog | — |

---

## 8. Summary of Key Concepts for the Exam

| Concept | Key Points to Remember |
|---|---|
| **Deliverables** | Formally reviewed and signed off by stakeholders; contractual work products |
| **Artifacts** | Catalogs (lists), Matrices (relationships), Diagrams (visual views); contained within deliverables |
| **Building Blocks** | ABBs = what (vendor-independent); SBBs = how (vendor-specific); ABBs map to SBBs in Phase E |
| **Content Metamodel** | Core metamodel is the starting point; Full metamodel adds extensions; defines entities and relationships |
| **Architecture Definition Document** | Built progressively through Phases B, C, D; contains all architecture artifacts |
| **Architecture Requirements Specification** | Companion to the Architecture Definition Document; contains testable requirements |
| **Architecture Roadmap** | Timeline of work packages from Baseline to Target; built progressively |
| **Transition Architecture** | Intermediate, stable states between Baseline and Target; defined in Phase E |
| **Architecture Contract** | Agreement between architecture and implementation; governs Phase G |
| **Architecture Repository** | Storage for all architecture assets; contains the Architecture Landscape, Standards Info Base, Reference Library, Governance Log |

---

## Review Questions

### Question 1
**What are the three types of architecture artifacts in the Content Framework?**

A) Principles, Patterns, and Procedures
B) Catalogs, Matrices, and Diagrams
C) Documents, Templates, and Models
D) Views, Viewpoints, and Perspectives

**Answer: B) Catalogs, Matrices, and Diagrams**
The Architecture Content Framework categorizes artifacts into Catalogs (lists of things), Matrices (relationships between things), and Diagrams (visual representations).

---

### Question 2
**What is the key difference between a Deliverable and an Artifact?**

A) Deliverables are created by architects; artifacts are created by stakeholders
B) Deliverables are contractually specified and signed off; artifacts are granular components within deliverables
C) Deliverables are diagrams; artifacts are documents
D) There is no difference — they are synonyms

**Answer: B) Deliverables are contractually specified and signed off; artifacts are granular components within deliverables**
Deliverables are the formal work products reviewed and signed off by stakeholders. Artifacts are the detailed content within deliverables.

---

### Question 3
**Which deliverable serves as a contract between the architect and the sponsor for an architecture engagement?**

A) Architecture Contract
B) Architecture Vision
C) Statement of Architecture Work
D) Request for Architecture Work

**Answer: C) Statement of Architecture Work**
The Statement of Architecture Work defines the scope, approach, deliverables, and acceptance criteria for an architecture project. It is the agreement between architect and sponsor. (Note: The Architecture Contract in Phase G governs implementation, not the architecture engagement itself.)

---

### Question 4
**Architecture Building Blocks (ABBs) are created in which ADM phases?**

A) Preliminary Phase only
B) Phase A only
C) Phases B, C, and D
D) Phase E only

**Answer: C) Phases B, C, and D**
ABBs are defined during the architecture development phases: Phase B (Business ABBs), Phase C (Data and Application ABBs), and Phase D (Technology ABBs).

---

### Question 5
**How do ABBs relate to SBBs?**

A) ABBs and SBBs are the same thing
B) ABBs define vendor-independent requirements; SBBs define product-specific implementations
C) SBBs are created first, then mapped to ABBs
D) ABBs are for technology only; SBBs are for business only

**Answer: B) ABBs define vendor-independent requirements; SBBs define product-specific implementations**
ABBs describe *what* is needed at an abstract level. SBBs describe *how* it is implemented using specific products and vendors. ABBs are mapped to SBBs in Phase E.

---

### Question 6
**The Architecture Definition Document is progressively built through which phases?**

A) Preliminary and Phase A
B) Phases B, C, and D
C) Phases E and F
D) Phases G and H

**Answer: B) Phases B, C, and D**
The Architecture Definition Document is the container for architecture content from each domain: Business (B), Information Systems (C), and Technology (D).

---

### Question 7
**Which artifact type shows relationships between two types of entities?**

A) Catalog
B) Matrix
C) Diagram
D) Deliverable

**Answer: B) Matrix**
Matrices show relationships between entities (e.g., Application/Function Matrix maps applications to the business functions they support).

---

### Question 8
**The Content Metamodel defines:**

A) The ADM phases and their sequence
B) The types of entities, their attributes, and their relationships
C) The governance structure for the architecture practice
D) The tools used for architecture development

**Answer: B) The types of entities, their attributes, and their relationships**
The Content Metamodel is the formal structure for architecture content — it defines what types of architectural elements exist and how they relate to each other.

---

### Question 9
**Which metamodel entity represents "a particular ability that a business may possess or exchange to achieve a specific purpose"?**

A) Function
B) Business Service
C) Business Capability
D) Process

**Answer: C) Business Capability**
A Business Capability represents a particular ability that a business may possess or exchange to achieve a specific purpose. It is part of the Motivation Extension of the full metamodel.

---

### Question 10
**The Transition Architecture deliverable is primarily created in which phase?**

A) Phase A
B) Phase C
C) Phase E
D) Phase G

**Answer: C) Phase E**
Transition Architectures are defined in Phase E (Opportunities and Solutions) and finalized in Phase F (Migration Planning). They represent intermediate stable states between Baseline and Target.

---

### Question 11
**What is the Architecture Requirements Specification?**

A) A high-level aspirational view of the architecture
B) A quantitative, testable set of requirements for the Target Architecture
C) A list of all stakeholders and their concerns
D) A contract governing implementation

**Answer: B) A quantitative, testable set of requirements for the Target Architecture**
The Architecture Requirements Specification is the companion to the Architecture Definition Document. While the ADD provides a qualitative view, the ARS provides testable requirements.

---

### Question 12
**Which of the following is a characteristic of a well-defined building block?**

A) It is always vendor-specific
B) It cannot be replaced
C) It publishes well-defined interfaces
D) It is always at the highest level of abstraction

**Answer: C) It publishes well-defined interfaces**
Good building blocks have clearly defined and published interfaces that enable interaction with other building blocks and allow for replaceability.

---

### Question 13
**The Data Entity/Business Function Matrix is an example of which artifact type?**

A) Catalog
B) Matrix
C) Diagram
D) Deliverable

**Answer: B) Matrix**
This is a matrix that shows the CRUD (Create, Read, Update, Delete) relationships between data entities and business functions.

---

### Question 14
**The Platform Decomposition Diagram belongs to which architecture domain?**

A) Business Architecture
B) Data Architecture
C) Application Architecture
D) Technology Architecture

**Answer: D) Technology Architecture**
The Platform Decomposition Diagram shows technology platforms broken down into their constituent components and is created in Phase D.

---

### Question 15
**Which deliverable is the primary input that triggers Phase A?**

A) Architecture Vision
B) Statement of Architecture Work
C) Request for Architecture Work
D) Architecture Principles

**Answer: C) Request for Architecture Work**
The Request for Architecture Work is the formal trigger from the sponsoring organization that initiates an architecture development cycle starting with Phase A.

---

### Question 16
**Which entity in the Content Metamodel represents "a statement of difference between the Baseline and Target Architectures"?**

A) Requirement
B) Constraint
C) Gap
D) Objective

**Answer: C) Gap**
A Gap specifically represents the difference between what exists in the Baseline Architecture and what is needed in the Target Architecture.

---

### Question 17
**The Architecture Repository contains all of the following EXCEPT:**

A) Architecture Landscape
B) Standards Information Base
C) Governance Log
D) Project Management Plan

**Answer: D) Project Management Plan**
The Architecture Repository contains the Architecture Metamodel, Architecture Landscape, Standards Information Base, Reference Library, and Governance Log. Project Management Plans are not part of the architecture repository.

---

### Question 18
**In the Content Metamodel, which chain of relationships correctly describes service realization?**

A) Goal → Objective → Measure
B) Business Service → Information System Service → Application Component
C) Actor → Role → Function
D) Location → Organization Unit → Business Service

**Answer: B) Business Service → Information System Service → Application Component**
This chain shows how a Business Service is realized by an Information System Service, which in turn is realized by an Application Component. This is one of the most important relationship chains in the metamodel.

---

### Question 19
**The Communications Plan deliverable is created in which phase?**

A) Preliminary Phase
B) Phase A
C) Phase E
D) Phase G

**Answer: B) Phase A**
The Communications Plan is created in Phase A (Architecture Vision) to define how architecture information will be communicated to stakeholders throughout the engagement.

---

### Question 20
**Which of the following correctly describes the difference between the Core and Full Content Metamodel?**

A) The Core Metamodel includes more entities than the Full Metamodel
B) The Core Metamodel is a minimal set sufficient for most work; the Full Metamodel adds extensions for mature organizations
C) The Core Metamodel is for Phase A only; the Full Metamodel is for all phases
D) There is no difference — they are the same

**Answer: B) The Core Metamodel is a minimal set sufficient for most work; the Full Metamodel adds extensions for mature organizations**
The Core Metamodel provides a sufficient starting point. The Full Metamodel adds optional extensions (Governance, Services, Process Modeling, Data, Infrastructure Consolidation, Motivation) for organizations with more sophisticated needs.

---

### Question 21
**Which diagram shows the lifecycle stages of key business products or services?**

A) Value Chain Diagram
B) Product Lifecycle Diagram
C) Process Flow Diagram
D) Data Lifecycle Diagram

**Answer: B) Product Lifecycle Diagram**
The Product Lifecycle Diagram shows the stages through which a business product or service passes during its lifetime. It is created during Phase B.

---

### Question 22
**The Functional Decomposition Diagram is created in which phase and shows what?**

A) Phase A — a high-level business model
B) Phase B — a hierarchical breakdown of business functions
C) Phase C — application component structure
D) Phase D — technology platform layers

**Answer: B) Phase B — a hierarchical breakdown of business functions**
The Functional Decomposition Diagram is a Phase B (Business Architecture) artifact that hierarchically decomposes business functions into sub-functions, providing a structured view of what the business does.

---

### Question 23
**Which of the following is true about Solution Building Blocks (SBBs)?**

A) SBBs are defined before ABBs in the ADM
B) SBBs are vendor-independent
C) SBBs define specific products, configurations, and vendors
D) SBBs are never reusable

**Answer: C) SBBs define specific products, configurations, and vendors**
SBBs are product-specific building blocks that implement the requirements defined by ABBs. They include vendor details, version numbers, configuration specifications, and concrete implementation details.

---

### Question 24
**The Goal/Objective/Service Diagram links which three elements?**

A) Principles, Standards, and Guidelines
B) Goals, Objectives, and Services
C) Actors, Roles, and Functions
D) Requirements, Constraints, and Assumptions

**Answer: B) Goals, Objectives, and Services**
This Phase B diagram visually links strategic goals to measurable objectives to the business services that support achieving them, providing traceability from strategy to implementation.

---

*These materials are for exam preparation purposes. TOGAF is a registered trademark of The Open Group. Always refer to the official TOGAF Standard, 10th Edition for authoritative content.*
