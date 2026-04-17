# Architecture Repository

## Introduction

The Architecture Repository is a critical holding area for all architecture-related outputs within an organization. It provides the structured storage and classification system that enables architecture artifacts to be managed, shared, reused, and governed effectively over time. Without a well-organized repository, architecture efforts become fragmented, duplicated, and ultimately unsustainable.

For the TOGAF 10 certification exam, the Architecture Repository is a frequently tested topic. You need to understand its six components, the three levels of the Architecture Landscape, how the repository interacts with the ADM, and its relationship to the Enterprise Continuum. Questions often focus on distinguishing between the repository components and understanding what type of content belongs in each.

---

## What Is the Architecture Repository?

### Definition

The **Architecture Repository** is the place where all architecture outputs are stored and managed. It acts as a holding area for all architecture-related assets, including architecture descriptions, models, building blocks, standards, reference materials, and governance records. The repository provides a structured classification system that supports all aspects of architecture management.

### Purpose

The Architecture Repository serves several essential purposes:

- **Central Storage**: Provides a single, authoritative source for all architecture assets
- **Classification**: Organizes architecture outputs in a structured taxonomy
- **Reuse**: Enables the discovery and reuse of existing architecture assets
- **Governance**: Supports architecture governance by maintaining records of decisions, compliance, and assessments
- **Continuity**: Preserves architectural knowledge across ADM iterations and personnel changes
- **Communication**: Provides stakeholders with access to relevant architecture information
- **Versioning**: Maintains version history of architecture artifacts as they evolve
- **Consistency**: Ensures consistent terminology, standards, and approaches across the enterprise

---

## Components of the Architecture Repository

The Architecture Repository consists of **six major components**:

```
+------------------------------------------------------------------+
|                    ARCHITECTURE REPOSITORY                         |
|                                                                    |
|  +------------------------------------------------------------+  |
|  |  1. ARCHITECTURE METAMODEL                                  |  |
|  |     Describes types of architecture assets and              |  |
|  |     relationships between them                              |  |
|  +------------------------------------------------------------+  |
|                                                                    |
|  +------------------------------------------------------------+  |
|  |  2. ARCHITECTURE CAPABILITY                                 |  |
|  |     Parameters, structures, and processes that              |  |
|  |     support architecture practice                           |  |
|  +------------------------------------------------------------+  |
|                                                                    |
|  +------------------------------------------------------------+  |
|  |  3. ARCHITECTURE LANDSCAPE                                  |  |
|  |     Architectural representation at Strategic,              |  |
|  |     Segment, and Capability levels                          |  |
|  +------------------------------------------------------------+  |
|                                                                    |
|  +------------------------------------------------------------+  |
|  |  4. STANDARDS INFORMATION BASE (SIB)                        |  |
|  |     Standards that govern architecture: industry,           |  |
|  |     regulatory, and organizational standards                |  |
|  +------------------------------------------------------------+  |
|                                                                    |
|  +------------------------------------------------------------+  |
|  |  5. REFERENCE LIBRARY                                       |  |
|  |     Reference models, patterns, templates                   |  |
|  +------------------------------------------------------------+  |
|                                                                    |
|  +------------------------------------------------------------+  |
|  |  6. GOVERNANCE LOG                                          |  |
|  |     Governance decisions, compliance assessments,           |  |
|  |     capability assessments, calendars                       |  |
|  +------------------------------------------------------------+  |
|                                                                    |
+------------------------------------------------------------------+
```

---

### 1. Architecture Metamodel

#### Definition

The **Architecture Metamodel** defines the types of architecture assets that can be stored in the repository and the relationships between them. It is the "model of the model" — it describes the structure and organization of architectural content.

#### What It Contains

- **Entity types**: The kinds of things that are modeled (e.g., Business Service, Application Component, Technology Platform, Data Entity)
- **Relationships**: How entity types relate to each other (e.g., "Application Component" supports "Business Service")
- **Attribute definitions**: The properties that each entity type has (e.g., name, description, owner, status)
- **Constraints**: Rules about valid relationships and attribute values

#### Purpose

The metamodel ensures consistency across all architecture work. When all architects follow the same metamodel, their outputs can be combined, compared, and analyzed coherently. The TOGAF Content Metamodel provides a standard starting point that organizations can extend.

#### TOGAF Content Metamodel Core Entities

| Entity | Description | Architecture Domain |
|---|---|---|
| Organization Unit | A business unit or department | Business |
| Business Function | A unit of business capability | Business |
| Business Service | An externally visible unit of business functionality | Business |
| Business Process | A sequence of activities that produces a result | Business |
| Data Entity | An encapsulation of data | Data |
| Application Component | An application or module | Application |
| Technology Component | A technology infrastructure element | Technology |
| Platform Service | A technical capability required to support applications | Technology |

---

### 2. Architecture Capability

#### Definition

The **Architecture Capability** defines the parameters, structures, and processes under which the architecture practice operates. It describes the resources, skills, roles, responsibilities, and organizational structures needed to establish and maintain an effective architecture function.

#### What It Contains

| Component | Description |
|---|---|
| **Architecture Board** | The governance body responsible for overseeing architecture decisions |
| **Architecture Skills Framework** | The competencies, skills, and training required for architecture practitioners |
| **Architecture Roles and Responsibilities** | Defined roles (Enterprise Architect, Domain Architect, Solution Architect) and their responsibilities |
| **Architecture Processes** | The processes used to develop, review, approve, and maintain architectures (including the ADM) |
| **Architecture Tools** | The software tools used for architecture modeling, documentation, and management |
| **Architecture Maturity Assessment** | Metrics and assessment criteria for evaluating the maturity of the architecture practice |
| **Business and IT Partnerships** | The structures for collaboration between business and IT in architecture decisions |

#### Purpose

Without a well-defined Architecture Capability, the architecture practice lacks the organizational foundation to be effective. The Architecture Capability ensures that the right people, with the right skills, using the right processes and tools, are in place to deliver and sustain architecture work.

---

### 3. Architecture Landscape

#### Definition

The **Architecture Landscape** is the architectural representation of assets in use, or planned, at particular points in time. It provides a view of the enterprise architecture at different levels of detail and scope, showing how the various architectural elements fit together.

#### Three Levels of the Architecture Landscape

The Architecture Landscape is organized into three levels, each providing a different scope and level of detail:

```
+------------------------------------------------------------------+
|                                                                    |
|  STRATEGIC ARCHITECTURE                                            |
|  (Enterprise-wide, long-term, 3-5+ years)                        |
|  +--------------------------------------------------------------+ |
|  | Broad view of the entire enterprise                           | |
|  | Aligns IT with business strategy                              | |
|  | Enables cross-organizational decision-making                  | |
|  | Examples: Enterprise capability map, strategic roadmap         | |
|  +--------------------------------------------------------------+ |
|                                                                    |
|    SEGMENT ARCHITECTURE                                            |
|    (Business area-specific, medium-term, 1-3 years)               |
|    +----------------------------------------------------------+   |
|    | Detailed architecture for a specific business area        |   |
|    | Bridges strategic direction with implementation           |   |
|    | Examples: HR architecture, supply chain architecture      |   |
|    +----------------------------------------------------------+   |
|                                                                    |
|      CAPABILITY ARCHITECTURE                                       |
|      (Specific capability, short-term, < 1 year)                  |
|      +------------------------------------------------------+     |
|      | Most detailed architecture for a specific capability  |     |
|      | Directly drives implementation projects               |     |
|      | Examples: Customer onboarding capability, payment      |     |
|      |   processing capability                               |     |
|      +------------------------------------------------------+     |
|                                                                    |
+------------------------------------------------------------------+
```

#### Strategic Architecture

| Attribute | Description |
|---|---|
| **Scope** | Enterprise-wide |
| **Time Horizon** | Long-term (3-5+ years) |
| **Level of Detail** | High-level, conceptual |
| **Purpose** | Provide overall direction and enable cross-organization decision-making |
| **Stakeholders** | CEO, CIO, Board, Executive Leadership |
| **Content** | Enterprise capability maps, strategic technology roadmaps, high-level principles |
| **Created By** | Enterprise Architects |
| **Governance** | Architecture Board, Executive Steering Committee |

Strategic Architecture answers: "Where is the enterprise heading from an architecture perspective?"

#### Segment Architecture

| Attribute | Description |
|---|---|
| **Scope** | A specific business area or segment (e.g., HR, Finance, Supply Chain) |
| **Time Horizon** | Medium-term (1-3 years) |
| **Level of Detail** | Moderate — more detail than strategic, less than capability |
| **Purpose** | Provide a detailed architecture for a specific part of the enterprise |
| **Stakeholders** | Business Unit Leaders, Domain Architects, Program Managers |
| **Content** | Segment-specific application landscapes, data models, technology stacks |
| **Created By** | Domain Architects, Solution Architects |
| **Governance** | Architecture Review Board, Domain Governance |

Segment Architecture answers: "What does the architecture look like for a specific business area?"

#### Capability Architecture

| Attribute | Description |
|---|---|
| **Scope** | A specific business or technical capability |
| **Time Horizon** | Short-term (typically < 1 year) |
| **Level of Detail** | Very detailed — implementation-ready |
| **Purpose** | Provide the detailed architecture to directly drive project implementation |
| **Stakeholders** | Project Managers, Solution Architects, Developers |
| **Content** | Detailed component designs, interface specifications, deployment diagrams |
| **Created By** | Solution Architects, Technical Leads |
| **Governance** | Project Governance, Technical Review |

Capability Architecture answers: "How exactly will this specific capability be built and deployed?"

#### How the Three Levels Relate

```
Strategic Architecture
        |
        | decomposes into
        v
Segment Architecture(s)
        |
        | decomposes into
        v
Capability Architecture(s)
```

Strategic Architecture sets the direction. Segment Architectures elaborate specific areas within that strategic direction. Capability Architectures provide the implementation-ready detail for specific capabilities within those segments.

---

### 4. Standards Information Base (SIB)

#### Definition

The **Standards Information Base (SIB)** captures the standards with which new architectures must comply. It is the repository of all standards — industry standards, regulatory standards, and organizational standards — that govern architecture decisions.

#### What It Contains

| Standard Type | Description | Examples |
|---|---|---|
| **Industry Standards** | Standards defined by industry bodies | ISO 27001, PCI-DSS, COBIT, ITIL |
| **Regulatory Standards** | Standards mandated by law or regulation | GDPR, HIPAA, SOX, Basel III |
| **Organizational Standards** | Standards defined by the enterprise | Internal coding standards, technology approved lists, data classification policies |
| **Technology Standards** | Standards for technology selection and usage | Approved database platforms, supported operating systems, API design standards |
| **Interface Standards** | Standards for system interfaces and integration | REST API guidelines, message format standards, integration patterns |

#### Standard Lifecycle States

Standards in the SIB have lifecycle states:

| State | Description |
|---|---|
| **Trial** | Under evaluation; may be used in limited, controlled contexts |
| **Active / Current** | Approved for use; new solutions should adopt these standards |
| **Deprecated** | Still in use but being phased out; new solutions should NOT use these |
| **Obsolete / Retired** | No longer supported; must be migrated away from |

#### Purpose

The SIB ensures that architecture decisions are made within the context of applicable standards. During architecture review and governance, proposed architectures are assessed against SIB standards for compliance.

---

### 5. Reference Library

#### Definition

The **Reference Library** provides a collection of reference materials that guide architecture development. It contains reusable assets that architects can leverage as starting points, templates, or patterns.

#### What It Contains

| Asset Type | Description | Examples |
|---|---|---|
| **Reference Models** | Abstract models of standard architectures | TOGAF TRM, III-RM, BIAN, HL7 |
| **Architecture Patterns** | Proven solutions to recurring architectural problems | Microservices pattern, Event-driven architecture pattern, CQRS |
| **Templates** | Standard formats and structures for architecture deliverables | Architecture Definition Document template, Statement of Architecture Work template |
| **Guidelines** | Best practices and guidance for architecture development | Cloud migration guidelines, API design guidelines |
| **Building Block Definitions** | Reusable building block specifications (ABBs and SBBs) | Standard authentication ABB, approved database SBBs |
| **Viewpoint Definitions** | Standard viewpoint specifications for creating views | Business Process Viewpoint, Technology Architecture Viewpoint |

#### Purpose

The Reference Library promotes reuse and consistency. Instead of starting from scratch, architects can leverage proven reference models, patterns, and templates, accelerating architecture development and improving quality.

---

### 6. Governance Log

#### Definition

The **Governance Log** provides a record of all architecture governance activity. It is the audit trail that captures governance decisions, compliance assessments, and other governance-related records.

#### What It Contains

| Record Type | Description |
|---|---|
| **Governance Decisions** | Records of decisions made by the Architecture Board, including rationale and context |
| **Compliance Assessments** | Results of architecture compliance reviews for projects and solutions |
| **Dispensations / Waivers** | Approved exceptions to standards, including conditions and expiry dates |
| **Capability Assessments** | Evaluations of the architecture practice's maturity and effectiveness |
| **Architecture Contracts** | Formal agreements between architecture and implementation teams |
| **Change Requests** | Requests for architecture changes and their disposition |
| **Risk Log** | Architecture-related risks, their status, and mitigation plans |
| **Calendar** | Schedule of governance activities — review meetings, assessment dates, milestone deadlines |
| **Action Items** | Tracking of governance action items and their completion status |

#### Purpose

The Governance Log provides transparency, accountability, and traceability for architecture governance. It enables:

- **Audit Trail**: Track what decisions were made, when, by whom, and why
- **Accountability**: Hold decision-makers accountable
- **Learning**: Learn from past decisions and assessments
- **Compliance Tracking**: Monitor compliance status across the enterprise
- **Planning**: Schedule and track governance activities

---

## How the Repository Supports the ADM Cycle

The Architecture Repository is not a static store — it is actively used and populated throughout every ADM cycle. Each phase both consumes from and contributes to the repository:

| ADM Phase | Consumes from Repository | Contributes to Repository |
|---|---|---|
| **Preliminary** | Reference Library (frameworks, tools), SIB (existing standards) | Architecture Capability definition, updated metamodel |
| **Phase A: Vision** | Architecture Landscape (current state), Reference Library (patterns) | Architecture Vision document, stakeholder maps |
| **Phase B: Business** | Architecture Landscape (business baseline), Reference Library | Business architecture artifacts (catalogs, matrices, diagrams) |
| **Phase C: Data** | Reference Library (data models, patterns), SIB (data standards) | Data architecture artifacts |
| **Phase C: Application** | Reference Library (III-RM, patterns), Architecture Landscape | Application architecture artifacts |
| **Phase D: Technology** | Reference Library (TRM), SIB (technology standards) | Technology architecture artifacts |
| **Phase E: Solutions** | Architecture Landscape (all domains), SIB | Solution alternatives, work packages |
| **Phase F: Migration** | Architecture Landscape (transition architectures) | Implementation and Migration Plan |
| **Phase G: Governance** | SIB (compliance standards), Governance Log | Compliance assessments, governance decisions, dispensations |
| **Phase H: Change Mgmt** | Architecture Landscape, Governance Log | Change requests, updated architecture artifacts |
| **Requirements Mgmt** | All components | Requirements traceability, impact assessments |

### The Iterative Nature

Each ADM cycle enriches the repository. Over time, the repository becomes increasingly valuable as it accumulates:

- More reference models and patterns (Reference Library)
- More refined standards (SIB)
- Richer governance history (Governance Log)
- More comprehensive architecture landscapes (Architecture Landscape)
- Better building block specifications (across components)

---

## Managing the Repository

### Versioning

Architecture artifacts evolve over time. The repository must support versioning to:

- Track changes to architecture artifacts across ADM iterations
- Maintain historical versions for audit and rollback
- Support parallel development of different architecture versions (baseline vs. target)
- Enable comparison between versions

### Access Control

Not all repository content is appropriate for all audiences:

| Access Level | Audience | Content |
|---|---|---|
| **Public** | All stakeholders | Architecture principles, high-level strategic architecture |
| **Internal** | Architecture team, IT leadership | Detailed architecture artifacts, building blocks, patterns |
| **Restricted** | Architecture Board, Senior Architects | Governance decisions, compliance assessments, dispensations |
| **Confidential** | Authorized individuals only | Security architecture details, sensitive risk assessments |

### Configuration Management

The repository should be managed with configuration management practices:

- **Baseline Control**: Approved architecture versions are baselined and protected from unauthorized changes
- **Change Control**: Changes to baselined artifacts go through a formal change control process
- **Traceability**: Changes are traceable to the change request, governance decision, or ADM iteration that triggered them
- **Impact Analysis**: Before changes are approved, their impact on dependent artifacts is assessed

---

## Repository Tools and Technologies

While TOGAF does not prescribe specific tools, organizations typically use one or more of:

| Tool Category | Purpose | Examples |
|---|---|---|
| **Enterprise Architecture Tools** | Modeling, visualization, repository management | Sparx Enterprise Architect, MEGA HOPEX, BiZZdesign |
| **Document Management** | Storage and versioning of documents | SharePoint, Confluence, Google Workspace |
| **CMDB** | Configuration management for technology components | ServiceNow, BMC Helix |
| **Wikis/Knowledge Bases** | Collaborative architecture documentation | Confluence, Notion, MediaWiki |
| **Governance Platforms** | Governance workflow, compliance tracking | Custom tools, LeanIX, Ardoq |
| **Standards Registries** | Standards management and lifecycle tracking | Custom databases, specialized tools |

### Tool Selection Considerations

- **Integration**: Tools should integrate with each other and with the ADM workflow
- **Accessibility**: Stakeholders need appropriate access to repository content
- **Scalability**: The repository will grow over time; tools must scale
- **Search**: Powerful search capabilities are essential for finding and reusing assets
- **Reporting**: Tools should support generating reports and dashboards from repository content
- **API Access**: Programmatic access enables automation and integration

---

## Relationship to the Enterprise Continuum

The Architecture Repository and the Enterprise Continuum are distinct but closely related concepts:

| Concept | Definition | Focus |
|---|---|---|
| **Enterprise Continuum** | A conceptual classification framework for categorizing architecture assets from generic to specific | Classification and categorization |
| **Architecture Repository** | The physical/logical storage facility for architecture outputs | Storage and management |

```
+------------------------------------------------------------------+
|                    ENTERPRISE CONTINUUM                            |
|                    (Classification Framework)                     |
|                                                                    |
|  Foundation ---> Common Systems ---> Industry ---> Org-Specific   |
|                                                                    |
|   "How do we CLASSIFY architecture assets?"                       |
+------------------------------------------------------------------+
         |
         | is implemented by / stored in
         v
+------------------------------------------------------------------+
|                    ARCHITECTURE REPOSITORY                         |
|                    (Storage and Management)                        |
|                                                                    |
|  Metamodel | Capability | Landscape | SIB | Reference | Gov Log  |
|                                                                    |
|   "Where do we STORE and MANAGE architecture assets?"             |
+------------------------------------------------------------------+
```

The Enterprise Continuum provides the classification scheme; the Architecture Repository provides the storage mechanism. The Reference Library component of the repository directly maps to the Enterprise Continuum, as reference models and patterns are classified along the Foundation → Organization-Specific spectrum.

Key distinction for the exam: The Enterprise Continuum is a **virtual classification** (a way of thinking about and organizing content). The Architecture Repository is the **actual store** where the content lives.

---

## Populating the Repository Through ADM Iterations

### Initial Population

When first establishing an Architecture Repository, the initial population typically includes:

1. **Architecture Metamodel**: Adopt or adapt the TOGAF Content Metamodel
2. **Architecture Capability**: Document the current architecture team structure, processes, and tools
3. **Architecture Landscape**: Capture the current-state (baseline) architecture at the Strategic level
4. **Standards Information Base**: Compile existing standards from various sources
5. **Reference Library**: Import relevant reference models (TRM, III-RM, industry models) and any existing templates
6. **Governance Log**: Initialize governance records from any existing architecture governance activities

### Progressive Enrichment

| ADM Iteration | Repository Growth |
|---|---|
| **First Iteration** | Baseline established; initial standards populated; first governance decisions recorded |
| **Second Iteration** | Baseline refined; gaps in standards identified and filled; first compliance assessments conducted |
| **Third+ Iterations** | Rich library of patterns and building blocks; mature governance history; comprehensive landscape at all three levels |

### Maintenance Activities

Ongoing repository maintenance includes:

- **Regular Reviews**: Periodically review and update standards (SIB) to reflect new regulations and technology changes
- **Archival**: Archive obsolete architecture artifacts while preserving them for historical reference
- **Quality Checks**: Verify that repository content is current, accurate, and complete
- **Usage Tracking**: Monitor which repository assets are most/least used to identify gaps and improvement opportunities
- **Stakeholder Feedback**: Gather feedback from repository users to improve organization and accessibility

---

## Exam Tips

- **Six Components**: Memorize all six: Architecture Metamodel, Architecture Capability, Architecture Landscape, Standards Information Base, Reference Library, Governance Log
- **Architecture Landscape Levels**: Know the three levels (Strategic, Segment, Capability) and their characteristics (scope, time horizon, detail level)
- **SIB vs. Reference Library**: The SIB contains standards; the Reference Library contains reference models, patterns, and templates. Do not confuse them.
- **Repository vs. Enterprise Continuum**: The Enterprise Continuum is a classification framework; the Repository is the storage mechanism. They are related but distinct.
- **Governance Log Contents**: Know what the Governance Log contains — decisions, compliance assessments, dispensations, capability assessments, calendar
- **Standard Lifecycle**: Know the standard lifecycle states: Trial → Active → Deprecated → Obsolete

---

## Review Questions

### Question 1
**How many major components does the Architecture Repository contain?**

A) Three  
B) Four  
C) Five  
D) Six  

**Answer: D** — The Architecture Repository contains six components: Architecture Metamodel, Architecture Capability, Architecture Landscape, Standards Information Base, Reference Library, and Governance Log.

---

### Question 2
**Which component of the Architecture Repository captures standards with which new architectures must comply?**

A) Architecture Metamodel  
B) Reference Library  
C) Standards Information Base (SIB)  
D) Governance Log  

**Answer: C** — The Standards Information Base (SIB) captures the standards — industry, regulatory, and organizational — that new architectures must comply with.

---

### Question 3
**Which component of the Architecture Repository contains reference models, patterns, and templates?**

A) Architecture Metamodel  
B) Reference Library  
C) Standards Information Base  
D) Architecture Capability  

**Answer: B** — The Reference Library contains reference models (e.g., TRM, III-RM), architecture patterns, templates, and guidelines that architects can leverage.

---

### Question 4
**What are the three levels of the Architecture Landscape?**

A) Foundation, Common Systems, Organization-Specific  
B) Conceptual, Logical, Physical  
C) Strategic, Segment, Capability  
D) Business, Application, Technology  

**Answer: C** — The Architecture Landscape has three levels: Strategic Architecture (enterprise-wide, long-term), Segment Architecture (business area-specific, medium-term), and Capability Architecture (specific capability, short-term, implementation-ready).

---

### Question 5
**Strategic Architecture is characterized by:**

A) Short-term, implementation-ready detail for a specific capability  
B) Medium-term, moderate detail for a business area  
C) Long-term, enterprise-wide, high-level conceptual direction  
D) Detailed technology specifications for infrastructure  

**Answer: C** — Strategic Architecture provides long-term (3-5+ years), enterprise-wide, high-level conceptual direction that aligns IT with business strategy.

---

### Question 6
**Segment Architecture is BEST described as:**

A) The most detailed, implementation-ready architecture  
B) A detailed architecture for a specific business area or segment  
C) The enterprise-wide strategic direction  
D) A reference model for platform services  

**Answer: B** — Segment Architecture provides a detailed architecture for a specific business area or segment (e.g., HR, Finance, Supply Chain) with a medium-term time horizon.

---

### Question 7
**Capability Architecture is BEST described as:**

A) The enterprise-wide strategic vision  
B) A segment-level business area architecture  
C) The most detailed architecture for a specific capability, directly driving project implementation  
D) The architecture governance framework  

**Answer: C** — Capability Architecture is the most detailed level, providing implementation-ready architecture for a specific business or technical capability, typically with a short-term horizon.

---

### Question 8
**What does the Architecture Metamodel define?**

A) The governance structure for architecture  
B) The types of architecture assets and relationships between them  
C) The standards that must be followed  
D) The physical storage location of architecture files  

**Answer: B** — The Architecture Metamodel defines the types of architecture assets (entity types) and the relationships between them. It is the "model of the model."

---

### Question 9
**The Governance Log in the Architecture Repository contains which of the following?**

A) Reference models and patterns  
B) Technology standards and regulations  
C) Governance decisions, compliance assessments, dispensations, and capability assessments  
D) Application source code and deployment scripts  

**Answer: C** — The Governance Log captures governance decisions, compliance assessment results, dispensations (approved exceptions), capability assessments, architecture contracts, change requests, and the governance calendar.

---

### Question 10
**What is the relationship between the Enterprise Continuum and the Architecture Repository?**

A) They are the same thing  
B) The Enterprise Continuum is a classification framework; the Architecture Repository is the storage mechanism  
C) The Architecture Repository replaces the Enterprise Continuum  
D) The Enterprise Continuum is a component of the Architecture Repository  

**Answer: B** — The Enterprise Continuum provides a virtual classification framework for categorizing architecture assets. The Architecture Repository is the actual storage facility where these assets are managed. They are distinct but complementary concepts.

---

### Question 11
**A standard in the SIB is marked as "Deprecated." This means:**

A) The standard is no longer valid and must not be used anywhere  
B) The standard is still in use but is being phased out; new solutions should not adopt it  
C) The standard is under evaluation  
D) The standard has been approved for enterprise-wide use  

**Answer: B** — "Deprecated" means the standard is still in use in existing systems but is being phased out. New solutions should NOT adopt deprecated standards; they should use active/current standards instead.

---

### Question 12
**Which component of the Architecture Repository defines the roles, skills, and organizational structures needed for the architecture practice?**

A) Architecture Metamodel  
B) Architecture Capability  
C) Architecture Landscape  
D) Reference Library  

**Answer: B** — Architecture Capability defines the parameters, structures, and processes under which the architecture practice operates, including roles, skills, organizational structures, and tools.

---

### Question 13
**An architect needs a template for creating an Architecture Definition Document. Where in the repository should they look?**

A) Standards Information Base  
B) Governance Log  
C) Reference Library  
D) Architecture Metamodel  

**Answer: C** — The Reference Library contains templates, patterns, reference models, and guidelines. A document template would be stored in the Reference Library.

---

### Question 14
**During Phase G (Implementation Governance), the results of architecture compliance reviews are stored in which repository component?**

A) Architecture Landscape  
B) Standards Information Base  
C) Reference Library  
D) Governance Log  

**Answer: D** — Compliance assessment results are stored in the Governance Log, which captures all governance activity including decisions, compliance reviews, dispensations, and action items.

---

### Question 15
**An organization grants a project an exception to a technology standard due to unique requirements. This exception record should be stored in:**

A) Standards Information Base  
B) Reference Library  
C) Governance Log (as a dispensation)  
D) Architecture Metamodel  

**Answer: C** — Dispensations (approved exceptions to standards) are recorded in the Governance Log with their conditions, rationale, and expiry dates.

---

### Question 16
**How does the Architecture Repository grow over multiple ADM iterations?**

A) It remains static once initially populated  
B) It grows progressively — each ADM iteration adds new artifacts, refines standards, accumulates governance history, and enriches the Reference Library  
C) Old content is deleted and replaced with each new iteration  
D) Only the Governance Log grows; other components remain fixed  

**Answer: B** — The Architecture Repository grows progressively with each ADM iteration. New architecture artifacts are added, standards are updated, governance history accumulates, and the Reference Library is enriched with new patterns and building blocks.

---

### Question 17
**Which of the following CORRECTLY maps repository components to their contents?**

A) SIB contains reference models; Reference Library contains standards  
B) SIB contains standards; Reference Library contains reference models and patterns  
C) Governance Log contains standards; SIB contains governance decisions  
D) Architecture Metamodel contains compliance assessments; Governance Log contains entity types  

**Answer: B** — The SIB contains standards (industry, regulatory, organizational). The Reference Library contains reference models, patterns, templates, and guidelines. This is a commonly tested distinction.

---

### Question 18
**An enterprise has architectures at different levels — a 5-year enterprise-wide roadmap, a 2-year HR transformation architecture, and a 6-month customer portal redesign. These represent:**

A) Three different Architecture Repositories  
B) Three levels of the Architecture Landscape: Strategic, Segment, and Capability  
C) Three ADM cycles  
D) Three components of the Reference Library  

**Answer: B** — The 5-year enterprise-wide roadmap is Strategic Architecture, the 2-year HR transformation is Segment Architecture, and the 6-month customer portal redesign is Capability Architecture — the three levels of the Architecture Landscape.

---

## Summary

The Architecture Repository is the structured storage and management facility for all architecture outputs:

- **Six components**: Architecture Metamodel, Architecture Capability, Architecture Landscape, Standards Information Base (SIB), Reference Library, Governance Log
- **Architecture Landscape** has three levels: **Strategic** (enterprise-wide, long-term), **Segment** (business area, medium-term), **Capability** (specific capability, short-term, implementation-ready)
- The **SIB** contains standards; the **Reference Library** contains reference models, patterns, and templates — do not confuse them
- The **Governance Log** captures decisions, compliance assessments, dispensations, and the governance calendar
- The repository is **distinct from the Enterprise Continuum**: the Continuum classifies; the Repository stores
- The repository grows **progressively** through ADM iterations, becoming more valuable over time
- Proper **versioning, access control, and configuration management** are essential for repository effectiveness

---

*Previous: [TOGAF Reference Models](../11-TOGAF-Reference-Models/README.md) | Next: [Security Architecture](../13-Security-Architecture/README.md)*
