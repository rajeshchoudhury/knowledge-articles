# TOGAF Reference Models

## Introduction

Reference models are a cornerstone of the TOGAF framework, providing standardized blueprints that architects can use as starting points for developing technology architectures. Rather than designing every architecture from scratch, TOGAF encourages leveraging proven reference models that encapsulate industry best practices and common architectural patterns.

TOGAF provides two foundational reference models:

1. **The TOGAF Technical Reference Model (TRM)** — a model of the fundamental platform services
2. **The Integrated Information Infrastructure Reference Model (III-RM)** — a model focused on enabling Boundaryless Information Flow

Understanding these reference models, their components, and how they are used within the ADM is essential for the TOGAF 10 certification exam. Questions frequently test your knowledge of TRM service categories, III-RM components, and how reference models fit into the Enterprise Continuum.

---

## What Are Reference Models?

### Definition

A **reference model** is an abstract framework for understanding significant relationships among the entities of some environment. It enables the development of specific architectures using consistent standards or specifications supporting that environment. Reference models are NOT the architecture itself — they are templates that guide architecture creation.

### Role in TOGAF

Reference models serve several critical purposes:

- **Starting Point**: Provide a common foundation for architecture development, avoiding "blank sheet" starts
- **Standardization**: Promote consistent architectural approaches across the enterprise
- **Communication**: Establish a shared vocabulary and taxonomy for architectural discussions
- **Guidance**: Help architects identify required platform services and infrastructure components
- **Reuse**: Enable the reuse of proven architectural patterns and service definitions
- **Benchmarking**: Provide a reference against which to evaluate architecture completeness

### Types of Reference Models

| Type | Description | Example |
|---|---|---|
| **Foundation Reference Models** | Generic models applicable across all industries | TOGAF TRM |
| **Common Systems Reference Models** | Models for commonly needed capabilities | TOGAF III-RM |
| **Industry Reference Models** | Models specific to an industry sector | BIAN (Banking), HL7 (Healthcare), TMForum (Telecom) |
| **Organization-Specific Models** | Custom models tailored to an enterprise | Internal reference architectures |

---

## The TOGAF Technical Reference Model (TRM)

### Purpose and Overview

The TOGAF TRM provides a model and taxonomy of generic platform services. Its purpose is to provide a widely accepted, common core upon which more specific architectures and architectural building blocks can be based. The TRM is positioned at the **Foundation Architecture** level of the Enterprise Continuum — it represents the most generic, universally applicable architectural blueprint.

The TRM answers the question: **"What fundamental platform services does any application need?"**

### Structure of the TRM

The TRM consists of two main entities and two key interfaces:

```
+----------------------------------------------------------+
|                                                          |
|              APPLICATION SOFTWARE                        |
|         (Business applications that users                |
|          interact with directly)                         |
|                                                          |
+===================== API ================================+
|  Application Platform Interface                          |
|  (Interface between applications and platform services)  |
+===================== API ================================+
|                                                          |
|              APPLICATION PLATFORM                        |
|         (Platform services that support                  |
|          application software)                           |
|                                                          |
|  +----------------------------------------------------+ |
|  |  Data         |  Data         |  Graphics &        | |
|  |  Interchange  |  Management   |  Imaging           | |
|  |  Services     |  Services     |  Services          | |
|  +--------------++--------------++--------------------+ |
|  |  International|  Location &   |  Network           | |
|  |  Operation    |  Directory    |  Services          | |
|  |  Services     |  Services     |                    | |
|  +--------------++--------------++--------------------+ |
|  |  Operating    |  Software     |  Transaction       | |
|  |  System       |  Engineering  |  Processing        | |
|  |  Services     |  Services     |  Services          | |
|  +--------------++--------------++--------------------+ |
|  |  User         |  Security     |                    | |
|  |  Interface    |  Services     |                    | |
|  |  Services     |               |                    | |
|  +--------------++---------------+--------------------+ |
|                                                          |
+================ CII ====================================+
|  Communications Infrastructure Interface                 |
|  (Interface between platform and comms infrastructure)   |
+================ CII ====================================+
|                                                          |
|         COMMUNICATIONS INFRASTRUCTURE                    |
|         (Networking, hardware, physical infrastructure)  |
|                                                          |
+----------------------------------------------------------+
```

### Key Entities

#### 1. Application Software

Application Software represents the business applications that provide functionality to end users. These are the applications that the organization develops, procures, or configures to support business processes. Examples include ERP systems, CRM applications, custom business applications, and productivity tools.

Application Software is NOT part of the platform — it sits on top of the platform and consumes platform services through the API.

#### 2. Application Platform

The Application Platform is the collection of technology components that provide the services needed to support Application Software. This is the core of the TRM. The Application Platform provides a standardized set of services that applications can rely on, abstracting away the underlying infrastructure complexity.

The platform services are organized into a taxonomy of service categories (detailed below).

#### 3. Application Platform Interface (API)

The API is the interface between the Application Software and the Application Platform. It defines how applications access platform services. The API provides a standard way for applications to request services (data management, security, user interface, etc.) without needing to know the implementation details of the platform.

The API is critical because it enables **application portability** — applications written to a standard API can potentially run on different platforms.

#### 4. Communications Infrastructure Interface (CII)

The CII is the interface between the Application Platform and the underlying Communications Infrastructure. It defines how platform services access networking, hardware, and physical infrastructure services.

### Qualities

**Qualities** are non-functional characteristics that apply across all platform services. They represent cross-cutting concerns such as:

- **Availability**: The degree to which the platform is operational and accessible
- **Scalability**: The ability to handle increasing loads
- **Performance**: Response times and throughput
- **Security**: Protection of data and services
- **Manageability**: Ease of monitoring, configuring, and maintaining
- **Interoperability**: Ability to work with other systems
- **Usability**: Ease of use for developers and operators

Qualities are not separate services — they are attributes that **influence and constrain** how platform services are designed and implemented. Each service category should be assessed against these qualities.

### Taxonomy of Platform Services (Detailed Breakdown)

The TRM defines a comprehensive taxonomy of platform service categories:

#### Data Interchange Services
Services that support the exchange of data between applications, both within and across organizational boundaries.

| Sub-Category | Description |
|---|---|
| File transfer services | Bulk data transfer between systems |
| Message-oriented services | Asynchronous message exchange |
| EDI services | Electronic Data Interchange for B2B |
| Streaming services | Real-time data streaming |

#### Data Management Services
Services for the storage, retrieval, and management of persistent data.

| Sub-Category | Description |
|---|---|
| Database services | Relational and non-relational data storage |
| Object management services | Object persistence and retrieval |
| File management services | File system operations |
| Data dictionary services | Metadata management and data definitions |

#### Graphics and Imaging Services
Services that support the creation, manipulation, storage, and display of graphical and imaging data.

| Sub-Category | Description |
|---|---|
| Graphical rendering services | 2D and 3D rendering |
| Image management services | Image storage, conversion, display |
| Printing services | Print queue management, rendering |

#### International Operation Services
Services that enable applications to support multiple languages, character sets, and locale-specific conventions.

| Sub-Category | Description |
|---|---|
| Character set services | Unicode, multi-byte character support |
| Cultural convention services | Date, time, currency, number formatting |
| Localization services | Language-specific resource management |

#### Location and Directory Services
Services for locating and identifying resources, services, and users across the platform.

| Sub-Category | Description |
|---|---|
| Directory services | LDAP, naming services |
| Service discovery | Finding and binding to available services |
| Name resolution | Translating logical to physical addresses |

#### Network Services
Services that provide access to network communications capabilities.

| Sub-Category | Description |
|---|---|
| Transport services | TCP/IP, UDP |
| Remote procedure call | Synchronous remote invocation |
| Web services | HTTP, REST, SOAP |
| Distributed computing | Distributed processing support |

#### Operating System Services
Fundamental services provided by the operating system layer.

| Sub-Category | Description |
|---|---|
| Process management | Process creation, scheduling, termination |
| Memory management | Allocation, deallocation, virtual memory |
| I/O services | Input/output operations |
| File system services | File operations, access control |
| Timer services | Scheduling and time management |

#### Software Engineering Services
Services that support the development, testing, and deployment of software.

| Sub-Category | Description |
|---|---|
| Programming language services | Compilers, interpreters, runtimes |
| Object management services | Object lifecycle management |
| Version control services | Source code management |
| Build and deployment services | CI/CD, packaging, deployment |
| Testing services | Test frameworks, test automation |

#### Transaction Processing Services
Services that support the reliable execution of business transactions.

| Sub-Category | Description |
|---|---|
| Transaction management | ACID transactions, two-phase commit |
| Queuing services | Reliable message queuing |
| Concurrency control | Locking, optimistic concurrency |

#### User Interface Services
Services that support the presentation layer and user interaction.

| Sub-Category | Description |
|---|---|
| Display management | Window management, layout |
| Input handling | Keyboard, mouse, touch input |
| Dialog services | UI component rendering |
| Desktop management | Desktop integration |

#### Security Services
Services that protect the platform, applications, and data from unauthorized access and threats.

| Sub-Category | Description |
|---|---|
| Authentication | Identity verification |
| Authorization | Access control, permissions |
| Audit | Logging and tracking of security events |
| Encryption | Data encryption at rest and in transit |
| Non-repudiation | Proof of origin and receipt |
| Certificate management | PKI, digital certificates |

### How the TRM Is Used in Phase D

The TRM is primarily used during **Phase D (Technology Architecture)** of the ADM:

1. **Identify Platform Services**: Use the TRM taxonomy to identify which platform services are required to support the application architecture defined in Phase C
2. **Gap Analysis**: Compare the required platform services against the organization's current platform to identify gaps
3. **Define Technology ABBs**: Create Architecture Building Blocks for each required platform service
4. **Select Standards**: Identify appropriate technology standards for each service category
5. **Map to Products**: Begin mapping platform services to candidate technology products (SBBs)

The TRM ensures completeness — by checking the application architecture against each TRM service category, architects can verify they have not overlooked any critical infrastructure requirements.

---

## The Integrated Information Infrastructure Reference Model (III-RM)

### Purpose and Scope

The III-RM is a reference model focused on enabling **Boundaryless Information Flow** — the seamless exchange of information across organizational, geographic, and technical boundaries. While the TRM provides a generic platform taxonomy, the III-RM specifically addresses the challenge of application interoperability and information sharing.

The III-RM is positioned at the **Common Systems Architecture** level of the Enterprise Continuum — it is more specific than the TRM (Foundation) but still broadly applicable across industries.

The III-RM answers the question: **"What infrastructure is needed to enable seamless information sharing across the enterprise and beyond?"**

### Boundaryless Information Flow

**Boundaryless Information Flow** is a TOGAF concept describing the ideal state where information flows freely to authorized users, systems, and partners without being impeded by unnecessary technical, organizational, or geographic barriers. The III-RM provides the architectural model to achieve this vision.

Key aspects of Boundaryless Information Flow:

- Information is available to the right people at the right time
- Technical barriers to information sharing are minimized
- Security and access control are maintained without impeding legitimate flow
- Applications can share information regardless of platform differences
- Partners and external entities can exchange information through standard interfaces

### Components of the III-RM

```
+----------------------------------------------------------+
|                                                          |
|              BUSINESS APPLICATIONS                       |
|         (Applications that create and                    |
|          consume business information)                   |
|                                                          |
|  +---------------------------------------------------+  |
|  | Consumer   | Business  | Broker    | Provider     |  |
|  | Apps       | Process   | Apps      | Apps         |  |
|  |            | Apps      |           |              |  |
|  +---------------------------------------------------+  |
|                                                          |
+===================== API ================================+
|  Application Platform Interface                          |
+===================== API ================================+
|                                                          |
|         INFRASTRUCTURE APPLICATIONS                      |
|         (Applications that enable information            |
|          sharing and management)                         |
|                                                          |
|  +---------------------------------------------------+  |
|  | Development| Information| Management | Data        |  |
|  | Tools      | Access     | Utilities  | Interchange |  |
|  |            | Tools      |            | Services    |  |
|  +---------------------------------------------------+  |
|                                                          |
+===================== API ================================+
|                                                          |
|              APPLICATION PLATFORM                        |
|         (Same as TRM — fundamental                       |
|          platform services)                              |
|                                                          |
+================ CII ====================================+
|                                                          |
|         COMMUNICATIONS INFRASTRUCTURE                    |
|                                                          |
+----------------------------------------------------------+
```

### Detailed Component Descriptions

#### Business Applications

Business Applications sit at the top of the III-RM and represent the applications that create, consume, and process business information. The III-RM categorizes business applications by their role in information flow:

| Category | Description | Example |
|---|---|---|
| **Consumer Applications** | Applications that primarily consume information | Reporting dashboards, analytics tools |
| **Business Process Applications** | Applications that process and transform information as part of business workflows | ERP modules, workflow engines |
| **Broker Applications** | Applications that mediate and route information between providers and consumers | ESB, API gateways, integration platforms |
| **Provider Applications** | Applications that are authoritative sources of information | Master data systems, systems of record |

#### Infrastructure Applications

Infrastructure Applications provide the tools and services that enable Business Applications to share information effectively. They sit between Business Applications and the Application Platform:

| Category | Description | Example |
|---|---|---|
| **Development Tools** | Tools for building, testing, and deploying integration solutions | IDEs, API design tools, testing frameworks |
| **Information Access Tools** | Tools for querying, reporting, and visualizing shared information | Query engines, ETL tools, data virtualization |
| **Management Utilities** | Tools for managing, monitoring, and administering the information infrastructure | Configuration management, monitoring, logging |
| **Data Interchange Services** | Services that handle the actual exchange of data between applications | Message brokers, file transfer, API management |

#### Application Platform

The Application Platform in the III-RM is the same as in the TRM — the collection of fundamental platform services (data management, security, networking, etc.). The III-RM builds on top of the TRM's platform.

#### Communications Infrastructure

The Communications Infrastructure provides the networking and physical infrastructure that enables all communication. This is also inherited from the TRM model.

### The "Boundary" Concept in III-RM

A critical concept in the III-RM is the **boundary** — any point at which information flow is impeded or must be managed. Boundaries can be:

| Boundary Type | Description | Challenge |
|---|---|---|
| **Organizational** | Between business units, departments | Different data definitions, governance rules |
| **Geographic** | Between locations, regions, countries | Latency, data sovereignty, compliance |
| **Technical** | Between different technology platforms | Data format differences, protocol mismatches |
| **Temporal** | Between different time zones or batch windows | Synchronization, consistency |
| **Semantic** | Between different data definitions or vocabularies | Meaning and interpretation mismatches |

The III-RM's architecture aims to minimize the impact of these boundaries on legitimate information flow while maintaining security and governance.

### How III-RM Supports Interoperability

The III-RM supports interoperability at multiple levels:

1. **Data Level**: Standard data formats, schemas, and interchange protocols
2. **Application Level**: Standard APIs, service interfaces, and integration patterns
3. **Technology Level**: Common platforms, middleware, and infrastructure services
4. **Business Level**: Shared business processes, rules, and governance frameworks

---

## How Reference Models Relate to the Enterprise Continuum

Reference models are positioned along the Enterprise Continuum based on their level of generality:

```
Enterprise Continuum
<-- Generic ================================ Specific -->

+------------------+------------------+------------------+------------------+
| Foundation       | Common Systems   | Industry         | Organization-    |
| Architectures    | Architectures    | Architectures    | Specific Archs   |
+------------------+------------------+------------------+------------------+
|                  |                  |                  |                  |
| TOGAF TRM        | TOGAF III-RM     | BIAN (Banking)   | Your Enterprise  |
|                  |                  | HL7 (Healthcare) | Architecture     |
| Generic platform | Boundaryless     | TMForum (Telco)  |                  |
| services         | Information      | ACORD (Insurance)|                  |
| taxonomy         | Flow model       |                  |                  |
|                  |                  |                  |                  |
+------------------+------------------+------------------+------------------+
```

- **TRM** = Foundation Architecture level (most generic)
- **III-RM** = Common Systems Architecture level (generic but with specific focus on information sharing)
- **Industry Models** = Industry Architecture level (industry-specific patterns)
- **Organization Models** = Organization-Specific Architecture level (tailored to the enterprise)

Architects should use reference models as starting points: begin with the most generic applicable model (e.g., TRM) and progressively specialize toward the organization-specific level through the ADM iterations.

---

## Using Reference Models in the ADM

| ADM Phase | Reference Model Usage |
|---|---|
| **Preliminary** | Select relevant reference models; determine which will guide the architecture effort |
| **Phase A** | Use reference models to inform the Architecture Vision; identify applicable standards |
| **Phase B** | Industry reference models may inform business process architecture |
| **Phase C** | III-RM guides information sharing and application integration architecture |
| **Phase D** | TRM guides technology architecture; use TRM taxonomy to identify required platform services |
| **Phase E** | Map reference model services to candidate products/solutions |
| **Phase F** | Use reference models to validate migration architecture completeness |
| **Phase G** | Use reference models as benchmarks for compliance review |
| **Phase H** | Reference models help assess the impact of proposed changes |

### Practical Usage Pattern

1. **Start with the TRM**: Identify which platform service categories are relevant to your architecture
2. **Layer the III-RM**: If interoperability and information sharing are key concerns, overlay the III-RM
3. **Apply industry models**: If available, incorporate industry-specific reference models
4. **Specialize**: Progressively refine the reference model to your organization's specific context
5. **Document deviations**: When your architecture deviates from a reference model, document and justify the deviation

---

## Industry-Specific Reference Models

While TOGAF provides the TRM and III-RM, architects should be aware that many industries have their own reference models:

| Industry | Reference Model | Focus |
|---|---|---|
| **Banking** | BIAN (Banking Industry Architecture Network) | Service landscape for banking |
| **Healthcare** | HL7 FHIR | Health information exchange |
| **Telecommunications** | TMForum Frameworx | Telecom business processes and information |
| **Insurance** | ACORD (Association for Cooperative Operations Research and Development) | Insurance data standards |
| **Government** | FEAF (Federal Enterprise Architecture Framework) | Federal government architecture |
| **Defense** | DoDAF (Department of Defense Architecture Framework) | Military architecture |
| **Retail** | ARTS (Association for Retail Technology Standards) | Retail technology standards |

These industry models are positioned at the "Industry Architectures" level of the Enterprise Continuum and can be combined with TOGAF's reference models for a comprehensive architecture foundation.

---

## Key Differences: TRM vs. III-RM

| Aspect | TRM | III-RM |
|---|---|---|
| **Focus** | Platform services taxonomy | Boundaryless Information Flow |
| **Enterprise Continuum Level** | Foundation Architecture | Common Systems Architecture |
| **Primary ADM Phase** | Phase D (Technology Architecture) | Phase C (Information Systems Architecture) |
| **Key Question** | "What platform services do we need?" | "How do we enable seamless information sharing?" |
| **Scope** | Single platform service categories | Cross-platform information integration |
| **Application Types** | Generic Application Software | Consumer, Provider, Broker, Business Process Apps |
| **Unique Concept** | Service taxonomy with 11 categories | Boundaryless Information Flow, Boundaries |

---

## Exam Tips

- **TRM Service Categories**: Memorize all 11 service categories — Data Interchange, Data Management, Graphics & Imaging, International Operations, Location & Directory, Network, Operating System, Software Engineering, Transaction Processing, User Interface, Security
- **TRM vs. III-RM Positioning**: TRM is Foundation; III-RM is Common Systems. Know their positions on the Enterprise Continuum.
- **Key Interfaces**: Remember API (Application Platform Interface) and CII (Communications Infrastructure Interface)
- **Boundaryless Information Flow**: This is the III-RM's central concept — know what it means
- **Qualities vs. Services**: Qualities are cross-cutting non-functional attributes, not separate services
- **Phase Mapping**: TRM is primarily used in Phase D; III-RM is primarily used in Phase C

---

## Review Questions

### Question 1
**Where is the TOGAF Technical Reference Model (TRM) positioned in the Enterprise Continuum?**

A) Common Systems Architecture  
B) Industry Architecture  
C) Foundation Architecture  
D) Organization-Specific Architecture  

**Answer: C** — The TRM is positioned at the Foundation Architecture level of the Enterprise Continuum because it provides the most generic, universally applicable model of platform services.

---

### Question 2
**What are the two main entities in the TRM?**

A) Business Architecture and Technology Architecture  
B) Application Software and Application Platform  
C) Hardware and Software  
D) Infrastructure and Applications  

**Answer: B** — The TRM's two main entities are Application Software (business applications) and Application Platform (technology services that support applications).

---

### Question 3
**What does the API in the TRM represent?**

A) A specific programming interface like REST  
B) The interface between Application Software and the Application Platform  
C) The interface between platforms and communications infrastructure  
D) A development tool for building applications  

**Answer: B** — The API (Application Platform Interface) in the TRM is the interface between Application Software (applications) and the Application Platform (services). It defines how applications access platform services.

---

### Question 4
**What does the CII in the TRM represent?**

A) The Customer Information Interface  
B) A security certificate infrastructure  
C) The Communications Infrastructure Interface between the platform and networking  
D) A configuration management tool  

**Answer: C** — The CII (Communications Infrastructure Interface) is the interface between the Application Platform and the underlying Communications Infrastructure (networking, hardware).

---

### Question 5
**Which of the following is NOT one of the TRM's platform service categories?**

A) Data Management Services  
B) Security Services  
C) Project Management Services  
D) Transaction Processing Services  

**Answer: C** — Project Management Services is not a TRM platform service category. The 11 categories are: Data Interchange, Data Management, Graphics & Imaging, International Operations, Location & Directory, Network, Operating System, Software Engineering, Transaction Processing, User Interface, and Security.

---

### Question 6
**In the TRM, "Qualities" are best described as:**

A) Separate platform service categories  
B) Cross-cutting, non-functional attributes that apply across all platform services  
C) Application software requirements  
D) Metrics for measuring architecture maturity  

**Answer: B** — Qualities are non-functional attributes (availability, performance, security, scalability, etc.) that cut across all platform service categories. They are not separate services but attributes that influence how services are designed.

---

### Question 7
**The III-RM is primarily concerned with:**

A) Hardware infrastructure management  
B) Enabling Boundaryless Information Flow  
C) Application development methodologies  
D) Business process reengineering  

**Answer: B** — The III-RM's central purpose is enabling Boundaryless Information Flow — the seamless exchange of information across organizational, technical, and geographic boundaries.

---

### Question 8
**Where is the III-RM positioned in the Enterprise Continuum?**

A) Foundation Architecture  
B) Common Systems Architecture  
C) Industry Architecture  
D) Organization-Specific Architecture  

**Answer: B** — The III-RM is positioned at the Common Systems Architecture level, one step more specific than the TRM (Foundation) but still broadly applicable across industries.

---

### Question 9
**In the III-RM, which type of business application mediates and routes information between providers and consumers?**

A) Consumer Applications  
B) Business Process Applications  
C) Broker Applications  
D) Provider Applications  

**Answer: C** — Broker Applications mediate and route information between Provider Applications (authoritative data sources) and Consumer Applications (information consumers).

---

### Question 10
**Which ADM phase primarily uses the TRM?**

A) Phase A: Architecture Vision  
B) Phase B: Business Architecture  
C) Phase C: Information Systems Architecture  
D) Phase D: Technology Architecture  

**Answer: D** — The TRM is primarily used in Phase D (Technology Architecture) to identify required platform services and define the technology infrastructure.

---

### Question 11
**Which ADM phase primarily uses the III-RM?**

A) Phase A: Architecture Vision  
B) Phase B: Business Architecture  
C) Phase C: Information Systems Architecture  
D) Phase D: Technology Architecture  

**Answer: C** — The III-RM is primarily used in Phase C (Information Systems Architecture) to guide the design of application integration and information sharing architectures.

---

### Question 12
**A "boundary" in the context of the III-RM refers to:**

A) A firewall between network segments  
B) Any point at which information flow is impeded or must be managed  
C) The physical border of a data center  
D) The limit of an architect's authority  

**Answer: B** — In the III-RM, a boundary is any point where information flow is impeded or must be managed. Boundaries can be organizational, geographic, technical, temporal, or semantic.

---

### Question 13
**What is the relationship between the Application Platform in the III-RM and the TRM?**

A) They are completely different models  
B) The III-RM's Application Platform is the same as the TRM's — the III-RM builds on top of the TRM  
C) The III-RM replaces the TRM  
D) The TRM is a subset of the III-RM  

**Answer: B** — The III-RM's Application Platform is the same as the TRM's. The III-RM extends the TRM by adding the concepts of Business Applications (categorized by information flow role) and Infrastructure Applications.

---

### Question 14
**An architect is developing a technology architecture for a new application. To ensure all required platform services are identified, the architect should:**

A) Only consider networking requirements  
B) Use the TRM taxonomy to systematically check each platform service category  
C) Skip reference models and rely on vendor recommendations  
D) Use only the III-RM  

**Answer: B** — The TRM's taxonomy of 11 platform service categories provides a comprehensive checklist for identifying all required platform services, ensuring nothing is overlooked.

---

### Question 15
**Which of the following is an Industry-level reference model?**

A) TOGAF TRM  
B) TOGAF III-RM  
C) BIAN (Banking Industry Architecture Network)  
D) ISO/IEC/IEEE 42010  

**Answer: C** — BIAN is an Industry-level reference model specific to the banking industry. The TRM is Foundation-level, the III-RM is Common Systems-level, and 42010 is a standard (not a reference model).

---

### Question 16
**What is the correct order of reference model usage from the most generic to the most specific in the Enterprise Continuum?**

A) III-RM → TRM → Industry Models → Organization Models  
B) Organization Models → Industry Models → III-RM → TRM  
C) TRM → III-RM → Industry Models → Organization Models  
D) Industry Models → TRM → III-RM → Organization Models  

**Answer: C** — The correct order from most generic to most specific is: TRM (Foundation) → III-RM (Common Systems) → Industry Models (Industry) → Organization Models (Organization-Specific).

---

### Question 17
**An organization wants to ensure seamless information exchange between its CRM, ERP, and supply chain systems. Which TOGAF reference model is MOST relevant?**

A) TRM, because it defines platform services  
B) III-RM, because it addresses Boundaryless Information Flow and application interoperability  
C) Neither — a custom reference model is needed  
D) Both equally, with no preference  

**Answer: B** — The III-RM is specifically designed to address interoperability and seamless information exchange between applications, making it the most relevant reference model for this scenario.

---

## Summary

TOGAF's reference models provide essential templates for architecture development:

- **The TRM** provides a taxonomy of 11 platform service categories at the **Foundation Architecture** level, primarily used in **Phase D**
- **The III-RM** addresses **Boundaryless Information Flow** at the **Common Systems Architecture** level, primarily used in **Phase C**
- Both models define key interfaces: **API** (Application Platform Interface) and **CII** (Communications Infrastructure Interface)
- **Qualities** are cross-cutting non-functional attributes, not separate services
- Reference models are positioned along the **Enterprise Continuum** from generic to specific
- Industry-specific reference models complement TOGAF's built-in models
- Architects should **start with generic models** and progressively specialize them

---

*Previous: [Building Blocks](../10-Building-Blocks/README.md) | Next: [Architecture Repository](../12-Architecture-Repository/README.md)*
