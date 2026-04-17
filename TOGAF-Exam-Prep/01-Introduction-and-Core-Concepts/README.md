# Module 01: Introduction and Core Concepts

> **Estimated study time: 4–5 hours | Exam weight: ~10–15% of Part 1 questions**

---

## Table of Contents

1. [What Is Enterprise Architecture and Why It Matters](#1-what-is-enterprise-architecture-and-why-it-matters)
2. [History of TOGAF](#2-history-of-togaf)
3. [The Open Group and Its Role](#3-the-open-group-and-its-role)
4. [TOGAF as a Framework vs. Methodology](#4-togaf-as-a-framework-vs-methodology)
5. [Key Terminology](#5-key-terminology)
6. [The Four Architecture Domains](#6-the-four-architecture-domains)
7. [TOGAF's Structure](#7-togafs-structure)
8. [Key Principles of TOGAF](#8-key-principles-of-togaf)
9. [Architecture Principles in Detail](#9-architecture-principles-in-detail)
10. [How TOGAF Relates to Other Frameworks](#10-how-togaf-relates-to-other-frameworks)
11. [Architecture at Different Levels of the Enterprise](#11-architecture-at-different-levels-of-the-enterprise)
12. [Business Drivers for Enterprise Architecture](#12-business-drivers-for-enterprise-architecture)
13. [Review Questions and Answers](#13-review-questions-and-answers)

---

## 1. What Is Enterprise Architecture and Why It Matters

Enterprise Architecture (EA) is the practice of analyzing, designing, planning, and implementing enterprise-wide strategies for developing and executing business and technology plans. At its core, EA bridges the gap between business strategy and IT execution.

### The Problem EA Solves

Modern enterprises face a fundamental challenge: their business strategies evolve rapidly, but their IT systems, built up over decades, change slowly and expensively. Without a disciplined architectural approach, organizations accumulate:

- **Technology debt** — overlapping systems, inconsistent data, aging platforms that nobody understands
- **Siloed decision-making** — each business unit buys its own tools, creating duplication and incompatibility
- **Misalignment** — IT investments that don't support strategic business goals
- **Rigidity** — inability to adapt quickly when markets, regulations, or customer demands shift

Enterprise architecture addresses these problems by providing a holistic view of the organization — its processes, information, applications, and technology infrastructure — and a systematic method for evolving that landscape in alignment with business strategy.

### The Value Proposition

Organizations with mature EA practices consistently demonstrate:

| Benefit | How EA Delivers It |
|---|---|
| **Cost reduction** | Eliminate redundant systems, consolidate infrastructure, standardize technology stacks |
| **Faster time to market** | Reuse existing components, clear technology roadmaps reduce decision-making time |
| **Better decision-making** | Visibility into the current state enables informed investment choices |
| **Regulatory compliance** | Documented architecture makes it easier to demonstrate compliance |
| **Risk management** | Understanding dependencies and single points of failure |
| **Agility** | Well-architected enterprises can adapt more quickly to change |

> **Exam Tip**: The exam may ask about the *purpose* or *benefits* of enterprise architecture. Remember that EA is fundamentally about **aligning IT with business strategy** and **managing complexity**.

---

## 2. History of TOGAF

TOGAF has evolved significantly since its inception. Understanding this history helps you appreciate why certain design decisions were made and how the framework has matured.

### Timeline

| Version | Year | Key Developments |
|---|---|---|
| **TOGAF 1** | 1995 | Based on the US Department of Defense Technical Architecture Framework for Information Management (TAFIM). Focused primarily on technology architecture. |
| **TOGAF 2–6** | 1996–2001 | Incremental refinements. The Architecture Development Method (ADM) was introduced and expanded. |
| **TOGAF 7** | 2001 | "Technical Edition" — significant expansion, but still heavily technology-focused. |
| **TOGAF 8** | 2002–2006 | Major shift: expanded scope to include Business Architecture, Data Architecture, and Application Architecture alongside Technology Architecture. TOGAF became a true *enterprise* architecture framework. Version 8.1.1 (2006) was widely adopted. |
| **TOGAF 9** | 2009 | Comprehensive overhaul. Introduced the Content Framework, formal content metamodel, Architecture Repository, and mature governance concepts. TOGAF 9.1 (2011) and 9.2 (2018) refined the standard further. |
| **TOGAF 10** | 2022 | Restructured as a modular standard — the "TOGAF Standard" rather than a monolithic document. Introduced the TOGAF Library concept, improved alignment with agile and digital transformation practices, and made the framework more adaptable. |

### Why TOGAF 10 Is Different

TOGAF 10 represents a structural shift, not just a content update. Key changes include:

1. **Modular structure**: Instead of a single large document, TOGAF 10 is a collection of documents — the Fundamental Content plus a series of TOGAF Series Guides
2. **TOGAF Library**: A living, continuously updated repository of reference materials, templates, and guidance
3. **Agile alignment**: Better support for iterative and agile approaches to architecture
4. **Digital transformation**: Updated guidance for cloud, APIs, microservices, and digital business models
5. **Separation of normative and guidance content**: The core standard (what you must do) is clearly distinguished from advisory guides (how you might do it)

> **Exam Tip**: The exam tests TOGAF 10 specifically. Be aware that TOGAF 10 is organized differently from TOGAF 9.x, even though much of the core content (especially the ADM) remains conceptually similar.

---

## 3. The Open Group and Its Role

**The Open Group** is a global consortium of over 800 member organizations including enterprises, government agencies, and technology vendors. Founded in 1996 through the merger of X/Open Company and the Open Software Foundation, The Open Group works to:

- Develop **open, vendor-neutral technology standards** and certifications
- Maintain the TOGAF Standard and certification program
- Operate the **ArchiMate** enterprise architecture modeling language
- Provide the **IT4IT** reference architecture for managing the IT business
- Run the **Open FAIR** risk analysis standard
- Operate certification programs that validate individual and organizational competence

The Open Group owns the TOGAF trademark and controls the certification exams. The TOGAF specification itself is available to members and can be accessed through their website (some content requires membership).

> **Exam Tip**: If a question asks who maintains or governs TOGAF, the answer is **The Open Group**.

---

## 4. TOGAF as a Framework vs. Methodology

This distinction is frequently tested and commonly misunderstood.

### Framework

A **framework** provides a structure for organizing information, a set of tools and building blocks, and a common vocabulary. It is a scaffolding that you adapt to your needs. Frameworks are:
- Generic and adaptable
- Not prescriptive about specific steps or sequence (though they may suggest one)
- Designed to be tailored to different organizations and contexts

### Methodology

A **methodology** is a specific, step-by-step procedure for accomplishing a task. Methodologies are:
- More prescriptive
- Often sequential
- Designed to be followed as prescribed

### TOGAF: A Framework That Contains a Method

TOGAF is officially a **framework**. It provides:
- The **ADM** — which is a *method* (a defined process with phases, steps, inputs, and outputs)
- The **Content Framework** — structures for organizing architectural deliverables
- The **Enterprise Continuum** — a classification system for architectural assets
- The **Architecture Capability Framework** — guidance for building an architecture practice

The ADM, while it looks like a methodology, is explicitly designed to be **tailored**. Organizations are expected to adapt the ADM's phases, sequences, and outputs to fit their specific context. This tailoring is what keeps TOGAF a framework rather than a rigid methodology.

> **Exam Tip**: If asked whether TOGAF is a "framework" or a "methodology," the correct answer is **framework**. TOGAF *contains* a method (the ADM), but the framework as a whole is designed to be adapted, not followed prescriptively.

---

## 5. Key Terminology

Mastering TOGAF terminology is essential for both Part 1 and Part 2 of the exam. Every term below has a specific, defined meaning within the TOGAF standard.

### Core Terms

| Term | TOGAF Definition |
|---|---|
| **Enterprise** | The highest level of description of an organization, covering all missions and functions. An enterprise can be a whole corporation, a division, a government agency, or a functional cross-section (e.g., "the procurement enterprise" spanning multiple departments). |
| **Architecture** | (1) A formal description of a system, or a detailed plan of the system at component level, to guide its implementation. (2) The structure of components, their inter-relationships, and the principles and guidelines governing their design and evolution over time. |
| **Architecture Framework** | A foundational structure, or set of structures, which can be used for developing a broad range of different architectures. It should describe a method for designing a target state of the enterprise, and contain a set of tools and a common vocabulary. |
| **Stakeholder** | An individual, team, organization, or class thereof, having an interest in a system. |
| **Concern** | An interest in a system relevant to one or more of its stakeholders. Concerns may pertain to any aspect of the system's functioning, development, or operation. |
| **View** | A representation of a whole system from the perspective of a related set of concerns. |
| **Viewpoint** | A definition of the perspective from which a view is taken. It defines the template or pattern for constructing a view. Specifies the stakeholders whose concerns are reflected and the model kinds used. |

### Distinguishing View and Viewpoint

This distinction is a frequent exam topic:

- A **viewpoint** is like a camera position — it defines *where* you look from and *what* you are looking at
- A **view** is the actual photograph taken from that viewpoint — the specific representation created for specific stakeholders

**Example**: A "Technology Viewpoint" defines that we will show infrastructure components and their relationships. The "Production Environment Technology View" is the actual diagram showing servers, networks, and storage for the production environment.

### Additional Essential Terms

| Term | Definition |
|---|---|
| **Artifact** | An architectural work product that describes an aspect of the architecture (e.g., a diagram, catalog, or matrix). |
| **Deliverable** | A contractually specified work product. A deliverable may contain multiple artifacts. |
| **Building Block** | A (potentially re-usable) component of enterprise capability — business, IT, or architectural — that can be combined with other building blocks to deliver architectures and solutions. |
| **Architecture Building Block (ABB)** | A building block at the architecture level — describes required capability and shapes the specification of Solution Building Blocks. |
| **Solution Building Block (SBB)** | A building block at the solution level — represents a specific solution component that will be used to implement the architecture. |
| **Gap** | A statement of the difference between two states (typically Baseline and Target architecture). |
| **Baseline Architecture** | The existing architecture (the "as-is" state). |
| **Target Architecture** | The desired future architecture (the "to-be" state). |
| **Transition Architecture** | A formally defined intermediate state between Baseline and Target, representing a step in the migration plan. |

> **Exam Tip**: Part 1 frequently tests whether you know the precise TOGAF definitions. "Architecture," "Enterprise," and the View/Viewpoint distinction are among the most commonly tested terms.

---

## 6. The Four Architecture Domains

TOGAF organizes enterprise architecture into four interrelated domains, often abbreviated as **BDAT**:

```
┌──────────────────────────────────────────────────────────┐
│                    ENTERPRISE ARCHITECTURE                │
│                                                          │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐  │
│  │   BUSINESS    │  │     DATA     │  │  APPLICATION │  │
│  │ ARCHITECTURE  │  │ ARCHITECTURE │  │ ARCHITECTURE │  │
│  │              │  │              │  │              │  │
│  │ • Strategy   │  │ • Logical    │  │ • App        │  │
│  │ • Governance │  │   data model │  │   portfolio  │  │
│  │ • Processes  │  │ • Data mgmt  │  │ • App        │  │
│  │ • Org struct │  │ • Data flow  │  │   components │  │
│  │ • Roles      │  │ • Metadata   │  │ • Integration│  │
│  │ • Functions  │  │ • Governance │  │ • Interfaces │  │
│  └──────┬───────┘  └──────┬───────┘  └──────┬───────┘  │
│         │                 │                 │           │
│         └────────┬────────┴────────┬────────┘           │
│                  │                 │                     │
│           ┌──────┴─────────────────┴──────┐             │
│           │     TECHNOLOGY ARCHITECTURE    │             │
│           │                               │             │
│           │  • Hardware    • Middleware    │             │
│           │  • Networks    • Standards     │             │
│           │  • Platforms   • Infrastructure│             │
│           └───────────────────────────────┘             │
│                                                          │
└──────────────────────────────────────────────────────────┘
```

### Business Architecture

Defines the business strategy, governance, organization, and key business processes. It is the foundation upon which the other three architectures are built.

**Key elements:**
- Organization structure and roles
- Business functions and capabilities
- Business processes and workflows
- Business goals, objectives, and drivers
- Business services and contracts
- Location and geographic distribution

**Why it matters**: Business architecture ensures that technology investments are driven by business needs. Without understanding the business context, technology architecture risks being technically excellent but strategically irrelevant.

### Data Architecture

Describes the structure of an organization's logical and physical data assets and data management resources.

**Key elements:**
- Logical data models (entities, attributes, relationships)
- Physical data models and database designs
- Data management policies and governance
- Data flows and data integration patterns
- Data lifecycle management
- Master data management and data quality

### Application Architecture

Provides a blueprint for the individual applications to be deployed, their interactions, and their relationships to the core business processes of the organization.

**Key elements:**
- Application portfolio (inventory of all applications)
- Application components and their responsibilities
- Application interaction patterns and interfaces
- Application migration and modernization plans
- Application communication diagrams

### Technology Architecture

Describes the logical software and hardware capabilities required to support the deployment of business, data, and application services.

**Key elements:**
- Technology standards and platforms
- Infrastructure components (servers, storage, networking)
- Middleware and integration platforms
- Security infrastructure
- Technology portfolios and roadmaps
- Cloud and deployment platforms

> **Exam Tip**: The exam refers to these collectively as **BDAT**. Note that Data Architecture and Application Architecture are sometimes grouped together as **Information Systems Architecture** (Phase C of the ADM covers both). Business Architecture is addressed in Phase B, and Technology Architecture in Phase D.

---

## 7. TOGAF's Structure

TOGAF 10 is organized into several major components that work together. Understanding how these pieces fit is fundamental to the exam.

```
┌─────────────────────────────────────────────────────────────────┐
│                      TOGAF STANDARD                              │
│                                                                  │
│  ┌─────────────────────────────────────────────────────────┐    │
│  │              ARCHITECTURE DEVELOPMENT METHOD (ADM)       │    │
│  │                                                         │    │
│  │         Preliminary ──► A ──► B ──► C ──► D             │    │
│  │              ▲                              │            │    │
│  │              │     Requirements             │            │    │
│  │              │     Management               ▼            │    │
│  │         H ◄──────── (Central) ──────────► E             │    │
│  │              ▲                              │            │    │
│  │              │                              ▼            │    │
│  │           G ◄─────── F ◄───────────────────┘            │    │
│  │                                                         │    │
│  └─────────────────────────────────────────────────────────┘    │
│                                                                  │
│  ┌──────────────────┐  ┌─────────────────────────────────┐     │
│  │  ADM GUIDELINES   │  │   ARCHITECTURE CONTENT           │     │
│  │  AND TECHNIQUES   │  │   FRAMEWORK                      │     │
│  │                   │  │                                  │     │
│  │ • Iteration       │  │ • Deliverables                   │     │
│  │ • Architecture    │  │ • Artifacts                      │     │
│  │   Patterns        │  │ • Building Blocks                │     │
│  │ • Gap Analysis    │  │ • Content Metamodel              │     │
│  │ • Stakeholder     │  │                                  │     │
│  │   Management      │  │                                  │     │
│  │ • Migration       │  │                                  │     │
│  │   Planning        │  │                                  │     │
│  └──────────────────┘  └─────────────────────────────────┘     │
│                                                                  │
│  ┌──────────────────┐  ┌─────────────────────────────────┐     │
│  │    ENTERPRISE     │  │   ARCHITECTURE CAPABILITY        │     │
│  │    CONTINUUM      │  │   FRAMEWORK                      │     │
│  │                   │  │                                  │     │
│  │ • Architecture    │  │ • Architecture Board             │     │
│  │   Repository      │  │ • Architecture Compliance        │     │
│  │ • Architecture    │  │ • Architecture Skills            │     │
│  │   Continuum       │  │ • Architecture Governance        │     │
│  │ • Solutions       │  │ • Maturity Models                │     │
│  │   Continuum       │  │                                  │     │
│  └──────────────────┘  └─────────────────────────────────┘     │
│                                                                  │
│  ┌────────────────────────────────────────────────────────┐     │
│  │    TOGAF REFERENCE MODELS                               │     │
│  │    • Technical Reference Model (TRM)                    │     │
│  │    • Integrated Information Infrastructure RM (III-RM)  │     │
│  └────────────────────────────────────────────────────────┘     │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

### Architecture Development Method (ADM)

The ADM is the core of TOGAF. It is a step-by-step method for developing and managing an enterprise architecture. The ADM consists of:

- **Preliminary Phase**: Preparing the organization for architecture work — defining "where, what, why, who, and how we do architecture"
- **Phase A – Architecture Vision**: Defining the scope, constraints, and expectations; securing stakeholder approval
- **Phase B – Business Architecture**: Developing the Business Architecture to support the agreed Architecture Vision
- **Phase C – Information Systems Architecture**: Developing Data and Application Architectures
- **Phase D – Technology Architecture**: Developing the Technology Architecture
- **Phase E – Opportunities and Solutions**: Performing initial implementation planning; identifying major implementation projects
- **Phase F – Migration Planning**: Finalizing a detailed Implementation and Migration Plan
- **Phase G – Implementation Governance**: Providing architectural oversight of the implementation
- **Phase H – Architecture Change Management**: Managing changes to the architecture in response to new requirements or opportunities
- **Requirements Management**: A central process that manages architecture requirements throughout the ADM cycle

The ADM is iterative at multiple levels and is designed to be tailored to organizational needs.

### Architecture Content Framework

Provides a structured model for architectural work products. It defines:

- **Deliverables** — formally reviewed, agreed, and signed-off work products (e.g., Architecture Definition Document)
- **Artifacts** — catalogs, matrices, and diagrams that make up the deliverables
- **Building Blocks** — ABBs (architecture level) and SBBs (solution level)
- **Content Metamodel** — defines the types of architectural entities and their relationships

### Enterprise Continuum

A classification system for architecture and solution assets, ranging from the most generic (foundation architectures) to the most specific (organization-specific architectures):

```
Foundation        Common Systems       Industry         Organization-
Architectures     Architectures        Architectures    Specific
                                                       Architectures
◄────────────────────────────────────────────────────────────────►
  Most Generic                                    Most Specific
```

The Enterprise Continuum has two dimensions:
- **Architecture Continuum** — classifies architecture descriptions
- **Solutions Continuum** — classifies solution implementations

### Architecture Capability Framework

Provides guidance for establishing and operating an architecture practice within an organization, covering:

- Architecture Board structure and responsibilities
- Architecture compliance review processes
- Architecture contracts
- Architecture governance
- Skills and role definitions for architecture teams
- Maturity models for assessing architecture capability

### TOGAF Reference Models

- **Technical Reference Model (TRM)**: A generic taxonomy and graphical model of application platform services, showing how applications sit on a platform of services
- **Integrated Information Infrastructure Reference Model (III-RM)**: A reference model focused on the integration of information across the enterprise, emphasizing "boundaryless information flow"

> **Exam Tip**: Know how these components relate to each other. The ADM *uses* the Content Framework to define what gets produced, the Enterprise Continuum to classify and store assets, and the Capability Framework to ensure the organization can sustain architecture practice.

---

## 8. Key Principles of TOGAF

TOGAF is built on several foundational principles that shape how the framework is applied:

1. **Enterprise scope**: Architecture addresses the entire enterprise, not just IT
2. **Iterative process**: The ADM is designed to be repeated; architecture is never "finished"
3. **Reusability**: Leverage existing architectural assets; avoid reinventing the wheel
4. **Stakeholder-driven**: Architecture exists to serve stakeholders; their concerns drive the process
5. **Tailoring**: The ADM and framework should be adapted to organizational context
6. **Vendor neutrality**: TOGAF does not prescribe specific products or technologies
7. **Governance**: Architecture must be governed throughout its lifecycle
8. **Business-driven**: Technology architecture serves business strategy, not the reverse
9. **Standards-based**: Use open standards to maximize interoperability and reduce vendor lock-in
10. **Continuous improvement**: Architecture evolves continuously in response to changing business needs

---

## 9. Architecture Principles in Detail

Architecture Principles are a critical concept in TOGAF and a heavily tested exam topic. They are general rules and guidelines that inform and support the way an organization fulfills its mission.

### Definition

An Architecture Principle is a qualitative statement of intent that should be met by the architecture. Principles are enduring — they change rarely and govern decisions about both Baseline and Target architectures.

### Components of an Architecture Principle

Every well-formed architecture principle must have four components:

| Component | Purpose | Example |
|---|---|---|
| **Name** | A label that is easy to remember; should clearly convey the core idea | "Data is a Shared Asset" |
| **Statement** | A succinct, unambiguous declaration of the principle | "Users have access to the data necessary to perform their duties; therefore, data is shared across enterprise functions and organizations." |
| **Rationale** | Explains why the principle is important; highlights the business benefit | "Timely access to accurate data is essential to improving the quality and efficiency of enterprise decision-making. It is less costly to maintain a single source of data than to maintain duplicate copies. Shared data reduces data inconsistency." |
| **Implications** | Describes the consequences of adopting the principle — what must change, what constraints it creates | "Education and access must be provided to enable users to access shared data. Shared data management policies and procedures must be established. Data stewardship roles must be defined." |

### Qualities of Good Architecture Principles

- **Understandable**: Plain language; accessible to all stakeholders, not just technologists
- **Robust**: Each principle is definitive and precise enough to support consistent decision-making
- **Complete**: Every potentially relevant situation is covered by the set of principles taken together
- **Consistent**: Principles do not contradict each other; where tensions exist, the relative priority is clear
- **Stable**: Principles are enduring; they change infrequently (if they change constantly, they are not principles)

### Where Principles Fit in the ADM

Architecture principles are typically **defined in the Preliminary Phase** and **refined in Phase A (Architecture Vision)**. They serve as guardrails throughout all subsequent ADM phases, constraining architectural decisions and ensuring consistency.

> **Exam Tip**: The exam loves to test the four components of an architecture principle (Name, Statement, Rationale, Implications). Memorize these. Also know that principles are created in the Preliminary Phase.

---

## 10. How TOGAF Relates to Other Frameworks

TOGAF does not exist in isolation. Understanding how it relates to other EA frameworks provides context and is occasionally tested.

### Zachman Framework

| Aspect | TOGAF | Zachman |
|---|---|---|
| **Type** | Framework with a method (ADM) | Classification taxonomy (ontology) |
| **Focus** | Process for *developing* architecture | Structure for *organizing* architecture artifacts |
| **Prescriptive?** | Provides a process (ADM) but expects tailoring | Describes what should be documented but not how |
| **Complementary?** | Yes — Zachman's taxonomy can organize TOGAF's deliverables |

The Zachman Framework is a 6×6 matrix classifying architectural artifacts by perspective (Planner, Owner, Designer, Builder, Implementer, User) and interrogative (What, How, Where, Who, When, Why). It tells you *what* to document, while TOGAF tells you *how* to create and manage architecture.

### FEAF (Federal Enterprise Architecture Framework)

- Developed by the US Federal Government for government agencies
- Shares concepts with TOGAF (e.g., reference models, architecture domains)
- TOGAF is broader and more internationally applicable; FEAF is US-government specific
- Many government architects use TOGAF concepts within a FEAF structure

### DoDAF (Department of Defense Architecture Framework)

- Focused on military and defense systems
- Emphasizes operational viewpoints and systems interoperability
- Uses a specific set of "viewpoints" and "models" (OV, SV, TV, etc.)
- More domain-specific than TOGAF; TOGAF provides a more general enterprise perspective

### SABSA (Sherwood Applied Business Security Architecture)

- Focused specifically on security architecture
- Provides a layered model for security architecture aligned with business requirements
- Complements TOGAF — SABSA handles security architecture depth while TOGAF provides the enterprise context
- TOGAF's ADM can incorporate SABSA's security architecture approach within its phases

### ArchiMate

- Not a competing framework but a **modeling language** maintained by The Open Group
- Provides a visual notation for describing enterprise architectures
- Designed to complement TOGAF — ArchiMate models can be used to create TOGAF artifacts
- Think of it as the "UML for enterprise architecture"

### Summary Comparison

```
                    Process/    Classi-     Security    Modeling
                    Method      fication    Focused     Language
                    ────────    ────────    ────────    ────────
TOGAF                  ✓
Zachman                            ✓
FEAF                   ✓           ✓
DoDAF                  ✓           ✓
SABSA                  ✓                       ✓
ArchiMate                                                  ✓
```

> **Exam Tip**: You don't need deep knowledge of other frameworks for the TOGAF exam. Know that TOGAF is complementary to (not a replacement for) frameworks like Zachman and SABSA, and that ArchiMate is the modeling language designed to work with TOGAF.

---

## 11. Architecture at Different Levels of the Enterprise

TOGAF recognizes that architecture operates at multiple levels within an enterprise. Understanding these levels is essential for grasping how the ADM iterates and how architecture efforts are scoped.

### Three Levels of Architecture

| Level | Scope | Timeframe | Detail Level |
|---|---|---|---|
| **Strategic Architecture** | Entire enterprise | Long-term (3–10 years) | High-level direction; links to business strategy |
| **Segment Architecture** | A specific business segment, program, or portfolio area | Medium-term (1–3 years) | More detailed than strategic; less detailed than capability |
| **Capability Architecture** | A specific project or capability implementation | Short-term (months to 1 year) | Detailed enough to guide implementation directly |

```
┌─────────────────────────────────────────────┐
│          STRATEGIC ARCHITECTURE              │
│  Enterprise-wide, long-term direction        │
│  ┌───────────────────────────────────────┐  │
│  │      SEGMENT ARCHITECTURE             │  │
│  │  Business area or portfolio focused    │  │
│  │  ┌─────────────────────────────────┐  │  │
│  │  │   CAPABILITY ARCHITECTURE       │  │  │
│  │  │   Project-level detail          │  │  │
│  │  └─────────────────────────────────┘  │  │
│  └───────────────────────────────────────┘  │
└─────────────────────────────────────────────┘
```

### Architecture Landscape

The Architecture Landscape is the architectural representation of assets in use or planned for use within the enterprise at particular points in time. It includes:

- **Baseline Landscape**: The current state architecture
- **Target Landscape**: The desired future state
- **Transition Architectures**: Formally defined intermediate states between baseline and target

The architecture landscape operates across all three levels (strategic, segment, capability) and all four domains (BDAT).

### ADM Iteration Across Levels

The ADM is applied iteratively across these levels:

1. **Architecture Context iteration**: Sets the overall strategic context and direction
2. **Architecture Definition iteration**: Develops detailed architecture for a segment
3. **Transition Planning iteration**: Plans the transition from baseline to target for a specific capability

> **Exam Tip**: Understand that TOGAF supports architecture at multiple levels and that the ADM can be applied iteratively at each level. The concept of iteration is tested frequently.

---

## 12. Business Drivers for Enterprise Architecture

Understanding *why* organizations invest in enterprise architecture helps you answer exam questions about the value and purpose of EA.

### Common Business Drivers

**Strategic Drivers:**
- Digital transformation initiatives
- Mergers, acquisitions, or divestitures
- Entry into new markets or geographies
- Business model innovation
- Customer experience improvement

**Operational Drivers:**
- Cost reduction and operational efficiency
- Process standardization and optimization
- Legacy system modernization
- Data integration across silos
- Workforce optimization

**Compliance and Risk Drivers:**
- Regulatory compliance (GDPR, SOX, HIPAA, etc.)
- Cybersecurity and data privacy requirements
- Business continuity and disaster recovery
- Audit and reporting requirements

**Technology Drivers:**
- Cloud migration and adoption
- Technology standardization
- API-driven and microservices architectures
- Elimination of technology debt
- Platform consolidation

### How EA Addresses These Drivers

Enterprise architecture provides value in response to these drivers by:

1. **Creating a common language** — All stakeholders understand the current state, future state, and the gap
2. **Enabling informed decisions** — Investment decisions are based on architectural analysis, not guesswork
3. **Reducing redundancy** — Shared services and reusable components lower costs
4. **Managing complexity** — Architecture makes complex interdependencies visible and manageable
5. **Accelerating change** — Well-documented architectures enable faster impact analysis and implementation
6. **Ensuring alignment** — Every technology initiative can be traced to a business driver

> **Exam Tip**: Part 2 scenarios often present a business situation and ask what TOGAF approach is most appropriate. Understanding business drivers helps you connect the scenario to the correct ADM phase or technique.

---

## 13. Review Questions and Answers

Test your understanding of Module 01 with these exam-style questions. Try to answer each question before reading the answer.

---

### Question 1

**Which of the following best describes the purpose of enterprise architecture?**

A) To document all the technical systems in an organization
B) To provide a strategic context for the evolution of the IT system in response to the constantly changing needs of the business environment
C) To create detailed technical designs for software applications
D) To manage IT project portfolios and budgets

<details>
<summary>Answer</summary>

**B) To provide a strategic context for the evolution of the IT system in response to the constantly changing needs of the business environment**

EA is fundamentally about aligning IT with business strategy, not just documenting systems (A), creating technical designs (C), or managing portfolios (D).
</details>

---

### Question 2

**TOGAF is best described as:**

A) A project management methodology
B) An enterprise architecture framework
C) A software development methodology
D) A technology standards specification

<details>
<summary>Answer</summary>

**B) An enterprise architecture framework**

TOGAF is a framework, not a methodology (A, C) or a standards specification (D). It provides structures, methods, and a common vocabulary for developing enterprise architecture.
</details>

---

### Question 3

**Which organization maintains and governs the TOGAF standard?**

A) IEEE
B) ISO
C) The Open Group
D) OMG (Object Management Group)

<details>
<summary>Answer</summary>

**C) The Open Group**

The Open Group is the vendor-neutral consortium that maintains TOGAF, its certification program, and related standards like ArchiMate.
</details>

---

### Question 4

**What are the four architecture domains in TOGAF?**

A) Strategy, Operations, Technology, Governance
B) Business, Data, Application, Technology
C) People, Process, Technology, Information
D) Infrastructure, Platform, Application, Presentation

<details>
<summary>Answer</summary>

**B) Business, Data, Application, Technology**

These are commonly abbreviated as BDAT. Note that Data and Application architectures are often grouped as "Information Systems Architecture" within ADM Phase C.
</details>

---

### Question 5

**What is the difference between a View and a Viewpoint in TOGAF?**

A) A View is the same as a Viewpoint; the terms are interchangeable
B) A Viewpoint defines the template for constructing a View; a View is the actual representation created for specific stakeholders
C) A View is a high-level perspective; a Viewpoint is a detailed perspective
D) A Viewpoint is created first in Phase A; a View is created in Phase D

<details>
<summary>Answer</summary>

**B) A Viewpoint defines the template for constructing a View; a View is the actual representation created for specific stakeholders**

A Viewpoint is the "camera position" (the pattern or template); a View is the "photograph" (the actual representation). They are not interchangeable (A), not differentiated by detail level (C), and not phase-specific (D).
</details>

---

### Question 6

**Which component of an Architecture Principle describes the consequences of adopting the principle?**

A) Name
B) Statement
C) Rationale
D) Implications

<details>
<summary>Answer</summary>

**D) Implications**

The four components of an Architecture Principle are Name (label), Statement (declaration of the principle), Rationale (why it's important), and Implications (what must change or what constraints result from adopting it).
</details>

---

### Question 7

**In which ADM phase are Architecture Principles typically defined?**

A) Phase A — Architecture Vision
B) Phase B — Business Architecture
C) Preliminary Phase
D) Phase H — Architecture Change Management

<details>
<summary>Answer</summary>

**C) Preliminary Phase**

Architecture Principles are established during the Preliminary Phase as part of setting up the architecture capability. They are refined in Phase A but initially defined in the Preliminary Phase.
</details>

---

### Question 8

**What is the primary purpose of the Architecture Development Method (ADM)?**

A) To provide a tested and repeatable process for developing architectures
B) To define the technical standards for an organization
C) To manage the organization's project portfolio
D) To create software development specifications

<details>
<summary>Answer</summary>

**A) To provide a tested and repeatable process for developing architectures**

The ADM is the core of TOGAF — a step-by-step method for developing enterprise architecture. It is not about standards (B), project management (C), or software specs (D).
</details>

---

### Question 9

**How does TOGAF relate to the Zachman Framework?**

A) TOGAF replaces the Zachman Framework entirely
B) They are identical frameworks with different names
C) They are complementary — Zachman provides a classification taxonomy while TOGAF provides a development process
D) Zachman is a newer version of TOGAF

<details>
<summary>Answer</summary>

**C) They are complementary — Zachman provides a classification taxonomy while TOGAF provides a development process**

Zachman tells you *what* to document (a classification scheme). TOGAF tells you *how* to develop and manage architecture (a process). Organizations can use both together.
</details>

---

### Question 10

**What distinguishes an Architecture Building Block (ABB) from a Solution Building Block (SBB)?**

A) ABBs are physical components; SBBs are logical components
B) ABBs describe required capability at an architecture level; SBBs represent specific solution components for implementation
C) ABBs are used in Phase B; SBBs are used in Phase D
D) There is no meaningful difference; the terms are interchangeable

<details>
<summary>Answer</summary>

**B) ABBs describe required capability at an architecture level; SBBs represent specific solution components for implementation**

ABBs define *what* is needed (architecture specification). SBBs define *how* it will be provided (specific products, services, or components). ABBs are product-agnostic; SBBs are product-specific.
</details>

---

### Question 11

**Which of the following is NOT one of the four components of an Architecture Principle?**

A) Name
B) Rationale
C) Priority
D) Implications

<details>
<summary>Answer</summary>

**C) Priority**

The four components are Name, Statement, Rationale, and Implications. Priority is not one of the defined components, though principles may be prioritized relative to each other in practice.
</details>

---

### Question 12

**The Enterprise Continuum classifies architecture assets ranging from:**

A) Simple to complex
B) Generic (foundation) to specific (organization-specific)
C) High-level to detailed
D) Current state to future state

<details>
<summary>Answer</summary>

**B) Generic (foundation) to specific (organization-specific)**

The Enterprise Continuum is a spectrum from Foundation Architectures (most generic) through Common Systems and Industry Architectures to Organization-Specific Architectures (most specific).
</details>

---

### Question 13

**TOGAF 10 differs from TOGAF 9.x primarily in:**

A) Completely different ADM phases
B) A modular document structure with a TOGAF Library, separating normative content from guidance
C) Removal of the Content Framework
D) Replacement of the Enterprise Continuum with a new classification system

<details>
<summary>Answer</summary>

**B) A modular document structure with a TOGAF Library, separating normative content from guidance**

TOGAF 10's key structural change is modularization. The ADM phases (A), Content Framework (C), and Enterprise Continuum (D) all remain conceptually similar to TOGAF 9.x.
</details>

---

### Question 14

**At which level of architecture does a specific project or capability implementation operate?**

A) Strategic Architecture
B) Segment Architecture
C) Capability Architecture
D) Enterprise Architecture

<details>
<summary>Answer</summary>

**C) Capability Architecture**

The three levels are Strategic (enterprise-wide, long-term), Segment (business area, medium-term), and Capability (project-level, short-term). Capability Architecture is detailed enough to guide a specific implementation.
</details>

---

### Question 15

**Which statement best describes the concept of a Transition Architecture?**

A) The final desired state of the architecture
B) A formally defined intermediate state between the Baseline and Target architectures
C) The initial architecture before any changes are made
D) An architecture that is no longer in use

<details>
<summary>Answer</summary>

**B) A formally defined intermediate state between the Baseline and Target architectures**

Transition Architectures represent planned "stepping stones" between where the organization is now (Baseline) and where it wants to be (Target). They are essential for phased migration planning.
</details>

---

### Question 16

**Which of the following is a business driver for enterprise architecture?**

A) Choosing a specific database vendor
B) Writing unit tests for software applications
C) Mergers and acquisitions requiring IT system integration
D) Selecting a programming language for a new project

<details>
<summary>Answer</summary>

**C) Mergers and acquisitions requiring IT system integration**

M&A activity is a classic strategic business driver for EA — it requires understanding and integrating the architectures of two or more organizations. Options A, B, and D are operational or technical decisions, not enterprise-level business drivers.
</details>

---

### Question 17

**The TOGAF Content Framework distinguishes between deliverables, artifacts, and building blocks. Which of the following correctly describes an artifact?**

A) A contractually specified work product that is formally reviewed and signed off
B) An architectural work product that describes an aspect of the architecture, such as a diagram, catalog, or matrix
C) A reusable component that can be combined with others to deliver solutions
D) A principle that guides architecture development

<details>
<summary>Answer</summary>

**B) An architectural work product that describes an aspect of the architecture, such as a diagram, catalog, or matrix**

A deliverable (A) is the formally signed-off work product. A building block (C) is a reusable component. A principle (D) is a guiding rule. An artifact is a specific work product (catalog, matrix, or diagram) that makes up part of a deliverable.
</details>

---

## Summary

This module covered the foundational concepts you need before diving into the ADM phases. Key takeaways:

- **Enterprise Architecture** bridges business strategy and IT execution
- **TOGAF** is a framework (not a methodology) maintained by The Open Group
- The **four architecture domains** (BDAT) cover Business, Data, Application, and Technology
- TOGAF's major components are the **ADM**, **Content Framework**, **Enterprise Continuum**, **Capability Framework**, and **Reference Models**
- **Architecture Principles** have four components: Name, Statement, Rationale, and Implications
- TOGAF **complements** other frameworks like Zachman, FEAF, and SABSA
- Architecture operates at three levels: **Strategic**, **Segment**, and **Capability**
- The **View/Viewpoint** and **ABB/SBB** distinctions are critical for the exam

**Next module**: [Module 02 — ADM Overview and Key Concepts →](../02-ADM-Overview/README.md)

---

*Study time complete for Module 01. Review the flashcards in Deck A before moving to Module 02.*
