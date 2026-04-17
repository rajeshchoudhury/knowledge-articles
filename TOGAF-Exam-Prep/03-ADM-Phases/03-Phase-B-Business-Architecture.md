# Phase B: Business Architecture

## Overview

Phase B is the **first of the four architecture domain phases** (B, C, D) in the TOGAF ADM cycle. It develops the **Business Architecture** that describes how the enterprise needs to operate to achieve the business goals, and responds to the strategic drivers set out in the Architecture Vision (Phase A). Phase B produces both the **Baseline Business Architecture** (current state) and the **Target Business Architecture** (desired future state), then identifies the gaps between them.

The Business Architecture is foundational — it drives the requirements for the Information Systems Architecture (Phase C) and the Technology Architecture (Phase D). Getting the Business Architecture right means that subsequent technology decisions are grounded in real business needs rather than technology preferences.

```
┌───────────────────────────────────────────────────────────────┐
│                   PHASE B: BUSINESS ARCHITECTURE              │
│                                                               │
│  ┌──────────────────┐                ┌──────────────────────┐ │
│  │ BASELINE         │                │ TARGET               │ │
│  │ Business         │    ────GAP──── │ Business             │ │
│  │ Architecture     │    ANALYSIS    │ Architecture         │ │
│  │ (Current State)  │                │ (Future State)       │ │
│  └──────────────────┘                └──────────────────────┘ │
│                                                               │
│  Key Artifacts:                                               │
│  • Catalogs (who, what, where)                                │
│  • Matrices (relationships)                                   │
│  • Diagrams (visual representations)                          │
│                                                               │
│  Key Concepts:                                                │
│  • Business Capabilities    • Value Streams                   │
│  • Business Processes       • Business Services               │
│  • Organization Structure   • Business Functions              │
└───────────────────────────────────────────────────────────────┘
```

> **Exam Tip:** Phase B is the first domain architecture phase and always comes before Phase C and D. The Business Architecture drives the other domain architectures. Understand that the business view is "first among equals" in the ADM because business needs should drive technology, not the other way around.

---

## Objectives of Phase B

The objectives of Phase B are to:

1. **Develop the Target Business Architecture** that describes how the enterprise needs to operate to achieve business goals, respond to the strategic drivers set out in the Architecture Vision, and address the Statement of Architecture Work and stakeholder concerns.
2. **Develop the Baseline Business Architecture description** to the extent necessary to support the Target Business Architecture.
3. **Identify candidate Architecture Roadmap components** based on gaps between the Baseline and Target Business Architectures.
4. **Select relevant architecture viewpoints** that demonstrate how stakeholder concerns are addressed in the Business Architecture.

---

## Key Business Architecture Concepts

### Business Capabilities

A **business capability** is a particular ability or capacity that a business may possess or exchange to achieve a specific purpose. Capabilities describe **what** the business does (not how it does it). They are relatively stable over time, even as processes and technology change.

Examples:
- Customer Management
- Order Fulfillment
- Risk Assessment
- Product Development
- Financial Reporting

Business capabilities are organized into a **Business Capability Map** — a hierarchical decomposition of all capabilities the enterprise needs. This map is a powerful strategic tool for identifying gaps, redundancies, and investment priorities.

```
┌────────────────────────────────────────────────────────────┐
│                 ENTERPRISE CAPABILITY MAP                   │
│                                                            │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────────┐ │
│  │ CUSTOMER     │  │ PRODUCT      │  │ FINANCIAL        │ │
│  │ MANAGEMENT   │  │ MANAGEMENT   │  │ MANAGEMENT       │ │
│  │              │  │              │  │                  │ │
│  │ • Acquisition│  │ • Design     │  │ • Accounting     │ │
│  │ • Onboarding │  │ • Development│  │ • Reporting      │ │
│  │ • Service    │  │ • Lifecycle  │  │ • Compliance     │ │
│  │ • Retention  │  │ • Pricing    │  │ • Treasury       │ │
│  │ • Analytics  │  │ • Portfolio  │  │ • Tax            │ │
│  └──────────────┘  └──────────────┘  └──────────────────┘ │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────────┐ │
│  │ SUPPLY CHAIN │  │ HUMAN        │  │ TECHNOLOGY       │ │
│  │ MANAGEMENT   │  │ RESOURCES    │  │ MANAGEMENT       │ │
│  │              │  │              │  │                  │ │
│  │ • Sourcing   │  │ • Recruiting │  │ • Infrastructure │ │
│  │ • Procurement│  │ • Talent Mgmt│  │ • App Management │ │
│  │ • Logistics  │  │ • Payroll    │  │ • Data Mgmt      │ │
│  │ • Warehousing│  │ • Learning   │  │ • Security       │ │
│  │ • Distribution│ │ • Benefits   │  │ • Service Mgmt   │ │
│  └──────────────┘  └──────────────┘  └──────────────────┘ │
└────────────────────────────────────────────────────────────┘
```

### Value Streams

A **value stream** represents an end-to-end collection of activities that create value for a customer, stakeholder, or end user. Value streams in TOGAF cross organizational boundaries and focus on the **flow of value** rather than organizational structure.

Value streams are composed of **value stream stages**, each of which:
- Delivers an incremental portion of value
- Can be mapped to business capabilities
- Can be measured for performance

Example value stream — "Customer Onboarding":

```
┌──────────┐   ┌──────────┐   ┌──────────┐   ┌──────────┐   ┌──────────┐
│ Customer │   │ Identity │   │ Risk     │   │ Account  │   │ Welcome  │
│ Request  │──▶│ Verifi-  │──▶│ Assess-  │──▶│ Setup &  │──▶│ & Enable │
│ Received │   │ cation   │   │ ment     │   │ Config   │   │ Services │
└──────────┘   └──────────┘   └──────────┘   └──────────┘   └──────────┘
   Stage 1        Stage 2        Stage 3        Stage 4        Stage 5
```

> **Exam Tip:** Value streams and business capabilities are complementary views. Capabilities show WHAT the business does; value streams show HOW value flows end-to-end. The exam may ask about the relationship between these two concepts.

### Business Processes

A **business process** is a defined set of business activities or steps, with specified inputs and outputs, that accomplish a specific business objective. Processes define HOW work gets done. Unlike capabilities (which are stable), processes may change frequently as the business optimizes operations.

### Business Functions

A **business function** is a grouping of business activities based on required business capabilities. Functions are typically aligned to organizational structure (e.g., Marketing function, Finance function).

### Organization Structures

The organizational structure defines how the enterprise is organized — hierarchies, reporting lines, departments, teams, and roles. In the Business Architecture, organizational structure is mapped to business functions and capabilities.

### Business Services

A **business service** supports business capabilities by providing a defined set of functionality that can be consumed by internal or external parties. Business services have defined interfaces and service level expectations.

---

## Business Architecture Catalogs

Catalogs are structured lists of architecture entities of a specific type. They are the "inventory" of the Business Architecture.

| Catalog | Purpose | Key Content |
|---------|---------|-------------|
| **Organization/Actor Catalog** | Lists all organizations, organizational units, and actors (people, systems) in the business architecture | Organization name, type, location, parent organization, key contacts |
| **Driver/Goal/Objective Catalog** | Documents the business drivers, goals, and objectives that the architecture must address | Driver name, description, associated goal, target metrics, timeframe |
| **Role Catalog** | Lists all business roles and their descriptions | Role name, description, responsibilities, skills required, associated actor(s) |
| **Business Service/Function Catalog** | Lists business services and functions, their descriptions, and their groupings | Service/function name, description, owning organization, consuming organizations, SLA |
| **Location Catalog** | Documents all business locations and their characteristics | Location name, type (office, data center, warehouse), geography, capacity |
| **Process/Event/Control/Product Catalog** | Lists business processes, events that trigger them, controls that govern them, and products they produce | Process name, trigger event, control points, outputs/products, owning function |
| **Contract/Measure Catalog** | Documents contracts (agreements) and measures (KPIs, metrics) associated with business services | Contract name, parties, SLAs, KPIs, measurement frequency, thresholds |

> **Exam Tip:** You do not need to memorize every column in every catalog, but you should know what each catalog captures and be able to match a scenario to the appropriate catalog. For example, if asked "Where would you document business KPIs?", the answer is the Contract/Measure Catalog.

---

## Business Architecture Matrices

Matrices show the **relationships** between architecture entities. They are two-dimensional grids that map entities from one catalog to entities from another.

| Matrix | Purpose | Rows × Columns |
|--------|---------|----------------|
| **Business Interaction Matrix** | Shows the relationships and dependencies between organizations/business units | Organization × Organization |
| **Actor/Role Matrix** | Maps actors (people, systems) to the roles they perform | Actor × Role |

The **Business Interaction Matrix** is particularly valuable for identifying:
- Dependencies between business units
- Integration points that the architecture must support
- Redundancies and overlaps in business functions
- Communication patterns

Example Actor/Role Matrix:

| | Customer Service Rep | Claims Processor | Underwriter | Branch Manager |
|---|:---:|:---:|:---:|:---:|
| **John Smith** | ✓ | | | |
| **Jane Doe** | | ✓ | ✓ | |
| **Claims System** | | ✓ | | |
| **Regional Manager** | | | | ✓ |

---

## Business Architecture Diagrams

Diagrams provide **visual representations** of the Business Architecture. They are the most communicative artifacts for stakeholders.

### Business Footprint Diagram

**Purpose:** Shows the links between business goals, organizational units, business functions, and services. Provides a "footprint" of the business — who does what and why.

**Content:** Maps organizational units to the business functions they perform and the business goals they support. Often overlaid with geographic information.

### Business Service/Information Diagram

**Purpose:** Shows the relationship between business services and the information (data entities) they create, consume, or manage.

**Content:** Business services along one axis, data entities along another, with relationships showing create/read/update/delete interactions.

### Functional Decomposition Diagram

**Purpose:** Shows the hierarchical decomposition of business functions into sub-functions. Provides a structured breakdown of what the business does.

**Content:** A tree structure starting from the enterprise level, decomposing into major functions, sub-functions, and activities.

```
                        Enterprise
                            │
            ┌───────────────┼───────────────┐
            │               │               │
     ┌──────▼──────┐ ┌─────▼─────┐ ┌───────▼──────┐
     │ Sales &     │ │ Operations│ │ Support      │
     │ Marketing   │ │           │ │ Services     │
     └──────┬──────┘ └─────┬─────┘ └───────┬──────┘
            │              │               │
     ┌──────┼──────┐   ┌──┼──┐       ┌────┼────┐
     │      │      │   │  │  │       │    │    │
   Lead  Campaign Order Fulfi- Quality HR  Finance IT
   Mgmt  Mgmt    Mgmt  llment Ctrl
```

### Product Lifecycle Diagram

**Purpose:** Shows the stages of a product's lifecycle and the business processes, services, and capabilities involved at each stage.

**Content:** Lifecycle stages (concept, development, launch, growth, maturity, decline, retirement) with associated activities.

### Goal/Objective/Service Diagram

**Purpose:** Links business goals and objectives to the business services that support them. Provides traceability from strategy to execution.

**Content:** Goals → Objectives → Business Services mapping, often with KPIs attached.

### Business Use-Case Diagram

**Purpose:** Shows the interactions between business actors and business processes or services. Based on UML use-case diagram notation adapted for business architecture.

**Content:** Actors (people, organizations, systems) and the business use cases (processes/services) they participate in.

### Organization Decomposition Diagram

**Purpose:** Shows the hierarchical decomposition of the organization — from the enterprise level down to departments, teams, and roles.

**Content:** Organizational hierarchy with reporting relationships and spans of control.

### Process Flow Diagram

**Purpose:** Shows the sequence of activities in a business process, including decision points, parallel activities, and handoffs between organizations or roles.

**Content:** Activities, decisions, flows, swim lanes (by organization or role), inputs, outputs.

### Event Diagram

**Purpose:** Shows the relationship between business events and the business processes they trigger. Helps understand how the business responds to internal and external stimuli.

**Content:** Events (triggers), processes (responses), outcomes, and timing.

---

## Business Capability Map — Concept and Usage

The Business Capability Map is one of the most powerful tools in Phase B. It provides a structured, hierarchical view of all the capabilities the business needs, independent of organizational structure, process, or technology.

**How to build a Business Capability Map:**

1. **Identify Level 0** — The enterprise itself.
2. **Identify Level 1 capabilities** — Major business areas (e.g., Customer Management, Product Management, Operations).
3. **Decompose to Level 2** — Sub-capabilities within each Level 1 (e.g., Customer Acquisition, Customer Service, Customer Analytics under Customer Management).
4. **Decompose to Level 3 (if needed)** — Further detail where necessary.
5. **Validate** — Review with business stakeholders to ensure completeness and accuracy.
6. **Assess** — Rate each capability on maturity, strategic importance, and investment priority.

**Usage of the Business Capability Map:**

- **Gap analysis** — Compare current capability maturity to required maturity for the Target Architecture.
- **Investment planning** — Identify which capabilities need investment, improvement, or retirement.
- **Heat mapping** — Overlay information like maturity level, risk, or strategic importance using color coding.
- **Alignment** — Ensure that technology investments are aligned with the most critical business capabilities.

---

## Value Stream Mapping in TOGAF

TOGAF 10 places increased emphasis on value streams as a core Business Architecture concept. Value stream mapping involves:

1. **Identify the value stream** — Name the end-to-end flow that delivers value (e.g., "Hire-to-Retire", "Order-to-Cash", "Idea-to-Product").
2. **Define stages** — Break the value stream into discrete stages, each delivering incremental value.
3. **Map capabilities to stages** — Identify which business capabilities are required at each stage.
4. **Identify stakeholders** — Determine who participates in or benefits from each stage.
5. **Identify information flows** — What information is needed and produced at each stage.
6. **Assess performance** — Measure cycle time, quality, cost, and customer satisfaction at each stage.
7. **Identify improvements** — Pinpoint bottlenecks, waste, and opportunities for optimization.

The combination of value streams and capabilities provides a comprehensive view: value streams show the **horizontal flow** of value across the enterprise, while capabilities show the **vertical competencies** needed at each point.

```
Value Stream:  Order-to-Cash
               │
Stages:     Receive  ──▶  Validate  ──▶  Fulfill  ──▶  Invoice  ──▶  Collect
            Order        Order          Order        Customer     Payment
               │            │             │             │            │
Capabilities:  │            │             │             │            │
            Order        Order         Warehouse    Financial    Accounts
            Capture      Validation    Management   Management   Receivable
            Customer     Inventory     Logistics    Billing      Payment
            Management   Management   Shipping     Invoicing    Processing
```

---

## All Inputs (Detailed)

| Input | Description | Source |
|-------|-------------|--------|
| **Request for Architecture Work** | The original trigger document (from Phase A) | Phase A |
| **Capability Assessment** | Assessment of current organizational capabilities | Phase A |
| **Communications Plan** | Stakeholder communication strategy | Phase A |
| **Organizational Model for Enterprise Architecture** | EA team structure and governance | Preliminary Phase |
| **Tailored Architecture Framework** | Customized TOGAF with selected deliverables and processes | Preliminary Phase |
| **Architecture Principles (including Business Principles)** | Guiding principles for architecture decisions | Preliminary Phase / Phase A |
| **Enterprise Continuum** | Classification of architecture and solution assets | Architecture Repository |
| **Architecture Repository** | All existing architecture content | Architecture Repository |
| **Architecture Vision** | High-level target state description from Phase A | Phase A |
| **Draft Architecture Definition Document** | Initial high-level architecture content from Phase A | Phase A |
| **Approved Statement of Architecture Work** | The project charter authorizing the architecture effort | Phase A |

> **Exam Tip:** The key input from Phase A is the **Architecture Vision** — it sets the direction that Phase B must elaborate in detail for the business domain. The Statement of Architecture Work provides the authority and scope constraints.

---

## All Steps (Detailed)

### Step 1: Select Reference Models, Viewpoints, and Tools

Before developing architecture content, select the reference materials and tools that will guide the work:

- **Reference models** — Identify relevant industry reference models (e.g., BIAN for banking, eTOM for telecom, SCOR for supply chain) that can accelerate the development of the Business Architecture.
- **Viewpoints** — Select the architecture viewpoints relevant to the stakeholders and their concerns (e.g., operational viewpoint for business managers, strategic viewpoint for executives).
- **Tools** — Confirm the modeling tools, templates, and methods that will be used (as established in the Preliminary Phase).

### Step 2: Develop Baseline Business Architecture Description

Document the current state of the Business Architecture:

- Gather existing business architecture documentation.
- Interview stakeholders and subject matter experts.
- Build or update the catalogs, matrices, and diagrams for the current state.
- Focus on the areas within the architecture scope defined in Phase A.
- Document only to the level of detail necessary to support gap analysis — avoid over-documenting areas that will not change.

> **Exam Tip:** TOGAF advises developing the Baseline Architecture only to the extent needed to support the Target Architecture and gap analysis. Do not over-invest in documenting the current state if it is going to be significantly replaced.

### Step 3: Develop Target Business Architecture Description

Design the future state of the Business Architecture:

- Use the Architecture Vision as the starting point and elaborate in detail.
- Develop all relevant catalogs, matrices, and diagrams for the target state.
- Ensure the Target Business Architecture addresses business goals, drivers, and stakeholder concerns.
- Apply architecture principles as constraints and guides.
- Consider reference models and industry best practices.
- Validate with stakeholders through iterative reviews.

### Step 4: Perform Gap Analysis

Compare the Baseline and Target Business Architectures to identify gaps:

- Create a gap analysis matrix for each relevant entity type (capabilities, processes, services, organizations).
- Identify elements that are **new** in the target (must be built).
- Identify elements that are **removed** from the baseline (must be retired/eliminated).
- Identify elements that are **modified** (must be changed/evolved).
- Identify elements that are **unchanged** (carry forward as-is).

#### Gap Analysis Example — Business Capabilities

| Baseline Capability | Target Capability | Gap Type | Description |
|--------------------|--------------------|----------|-------------|
| Manual Order Processing | Automated Order Processing | **Modified** | Current manual process must be automated with workflow engine |
| — (does not exist) | AI-Powered Customer Analytics | **New** | New capability required; no current equivalent |
| Fax-Based Communications | — (being retired) | **Eliminated** | Fax communications to be retired; replaced by digital channels |
| Financial Reporting | Financial Reporting | **Unchanged** | Current capability meets target requirements |
| Basic Inventory Tracking | Real-Time Inventory Management | **Modified** | Must upgrade from batch to real-time tracking |
| — (does not exist) | Digital Self-Service Portal | **New** | New customer-facing capability to reduce call center load |
| Paper-Based Contracts | Digital Contract Management | **Modified** | Must digitize contract lifecycle |

#### Gap Analysis Matrix Format

The standard gap analysis matrix format in TOGAF uses a two-dimensional grid:

```
              TARGET ARCHITECTURE
              ┌─────┬─────┬─────┬─────┬──────────┐
              │ T1  │ T2  │ T3  │ T4  │ Eliminated│
    ┌─────────┼─────┼─────┼─────┼─────┼──────────┤
    │ B1      │ ■   │     │     │     │          │ B1 maps to T1
B   │ B2      │     │     │ ■   │     │          │ B2 maps to T3
A   │ B3      │     │     │     │     │    ■     │ B3 eliminated
S   │ B4      │     │ ■   │     │     │          │ B4 maps to T2
E   ├─────────┼─────┼─────┼─────┼─────┼──────────┤
L   │ New     │     │     │     │ ■   │          │ T4 is new
I   └─────────┴─────┴─────┴─────┴─────┴──────────┘
N
E   ■ = Mapping between baseline and target elements
    Empty cells in "Eliminated" column = baseline items carried forward
    ■ in "New" row = target items with no baseline equivalent
    ■ in "Eliminated" column = baseline items with no target equivalent
```

> **Exam Tip:** Gap analysis is performed in Phases B, C, and D (one for each architecture domain). The format is the same: a matrix comparing baseline elements to target elements, with identification of new, modified, eliminated, and unchanged items.

### Step 5: Define Candidate Roadmap Components

Based on the gap analysis, identify work packages that will close the gaps:

- Group related gaps into logical work packages.
- Estimate effort, dependencies, and priority for each work package.
- Identify quick wins (low effort, high value) vs. strategic investments.
- These become **candidate** roadmap components — they will be refined and prioritized in Phases E and F.

### Step 6: Resolve Impacts Across the Architecture Landscape

Assess how the proposed Business Architecture changes affect:

- **Other architecture domains** — Will business changes drive data, application, or technology changes?
- **Other architecture projects or programs** — Are there dependencies or conflicts with parallel efforts?
- **The Architecture Landscape** — How does this fit with Strategic, Segment, and Capability architectures?
- **Organizational readiness** — Are the impacted organizations ready for these changes?

This step ensures that the Business Architecture is not developed in isolation but considers its broader impact.

### Step 7: Conduct Formal Stakeholder Review

Present the Business Architecture to stakeholders for formal review:

- Prepare presentation materials tailored to different stakeholder groups (executives get a strategic view; operational managers get process details).
- Walk through the Baseline, Target, and Gap Analysis.
- Collect feedback and document concerns.
- Resolve conflicts and incorporate agreed changes.
- Obtain stakeholder sign-off on the Business Architecture direction.

### Step 8: Finalize the Business Architecture

Incorporate feedback from the stakeholder review:

- Update catalogs, matrices, and diagrams based on review feedback.
- Resolve any outstanding issues or conflicts.
- Confirm alignment with architecture principles and the Architecture Vision.
- Ensure completeness — all in-scope business entities are addressed.
- Finalize the gap analysis and candidate roadmap components.

### Step 9: Create the Architecture Definition Document

Update the Architecture Definition Document with the completed Business Architecture content:

- Add the Baseline Business Architecture description.
- Add the Target Business Architecture description.
- Add the gap analysis results.
- Add candidate roadmap components.
- Update the Architecture Vision if refinements were made.
- Ensure traceability from business goals through to architectural decisions.

The Architecture Definition Document is a cumulative document — Phase B adds the business content, and Phases C and D will add their respective domain content.

---

## All Outputs (Detailed)

| Output | Description |
|--------|-------------|
| **Refined and updated Architecture Vision** | The Architecture Vision may be refined based on detailed Business Architecture findings |
| **Draft Architecture Definition Document (Business Architecture content)** | The ADD updated with detailed baseline and target Business Architecture descriptions |
| **Draft Architecture Requirements Specification (business requirements)** | Business-specific requirements derived from gap analysis — constraints, standards, guidelines |
| **Business Architecture components of the Architecture Roadmap** | Candidate work packages for closing business architecture gaps |
| **Catalogs (updated)** | All Business Architecture catalogs populated for baseline and target |
| **Matrices (updated)** | All Business Architecture matrices populated for baseline and target |
| **Diagrams (updated)** | All Business Architecture diagrams created for baseline and target |
| **Gap analysis results** | Documented gaps between baseline and target Business Architecture |
| **Impact analysis results** | Assessment of impacts on other domains and the broader Architecture Landscape |

---

## Architecture Views Specific to Phase B

Architecture views are representations of the architecture from the perspective of specific stakeholder concerns. In Phase B, key views include:

| View | Target Audience | Content |
|------|----------------|---------|
| **Strategic Business View** | Executives, board members | Business capabilities, value streams, strategic alignment, investment priorities |
| **Operational Business View** | Business managers, process owners | Business processes, organizational structure, service flows, performance metrics |
| **Organizational View** | HR, organizational design teams | Organization hierarchy, roles, responsibilities, competencies |
| **Process View** | Process owners, operations teams | End-to-end process flows, handoffs, decision points, controls |
| **Value Chain View** | Strategy teams, business analysts | Value stream stages, capability mapping, value creation points |

---

## Exam Tips

1. **Phase B comes first among domain phases** — Business Architecture is always developed before Information Systems and Technology Architecture. Business needs drive technology decisions.

2. **Baseline vs. Target** — Every domain architecture phase (B, C, D) develops both baseline and target descriptions, then performs gap analysis. This pattern is consistent across all three phases.

3. **Catalogs, Matrices, Diagrams** — Know the three artifact types. Catalogs = lists of entities. Matrices = relationships between entities. Diagrams = visual representations. The exam may ask you to match an artifact type to a specific need.

4. **Gap analysis format** — Understand the gap analysis matrix: baseline elements on rows, target elements on columns, with a "New" row and "Eliminated" column. Items can be new, modified, eliminated, or unchanged.

5. **Business Capability Map** — This is a strategic tool showing WHAT the business does. It is stable and technology-independent. Do not confuse it with process maps (which show HOW).

6. **Value Streams** — Understand that value streams cross organizational boundaries and show end-to-end value delivery. They complement capabilities.

7. **Level of baseline documentation** — TOGAF advises documenting the baseline only to the extent needed to support gap analysis. The exam may test this concept.

8. **Candidate roadmap components** — Phase B produces CANDIDATE components. They are not finalized until Phases E and F.

9. **Stakeholder review is mandatory** — Formal stakeholder review is a required step, not optional. Architecture without stakeholder buy-in will fail.

10. **The Architecture Definition Document is cumulative** — Phase B adds business content to the draft ADD started in Phase A. Phases C and D will add their content. It is one document, progressively elaborated.

11. **Reference models accelerate work** — Using industry reference models (BIAN, eTOM, SCOR, etc.) can significantly speed up Phase B by providing pre-built capability and process frameworks.

---

## Review Questions

### Question 1
**What is the PRIMARY objective of Phase B?**

A) To develop the Technology Architecture  
B) To develop the Target Business Architecture that describes how the enterprise needs to operate to achieve business goals  
C) To create the Architecture Vision  
D) To implement the architecture  

<details>
<summary>Answer</summary>

**B) To develop the Target Business Architecture that describes how the enterprise needs to operate to achieve business goals**

Phase B focuses on the Business Architecture domain. Technology Architecture (A) is Phase D. Architecture Vision (C) is Phase A. Implementation (D) is Phase G.
</details>

---

### Question 2
**Which of the following is the correct sequence of architecture domain phases in the ADM?**

A) Phase C → Phase B → Phase D  
B) Phase B → Phase D → Phase C  
C) Phase B → Phase C → Phase D  
D) Phase D → Phase C → Phase B  

<details>
<summary>Answer</summary>

**C) Phase B → Phase C → Phase D**

The standard sequence is: Business Architecture (B) → Information Systems Architecture (C) → Technology Architecture (D). Business needs drive information systems, which drive technology requirements.
</details>

---

### Question 3
**Gap analysis in Phase B compares:**

A) The Architecture Vision and the Statement of Architecture Work  
B) The Baseline Business Architecture and the Target Business Architecture  
C) The Technology Architecture and the Application Architecture  
D) The current IT budget and the required IT budget  

<details>
<summary>Answer</summary>

**B) The Baseline Business Architecture and the Target Business Architecture**

Gap analysis in each domain phase compares the baseline (current state) to the target (desired future state) to identify gaps that must be closed.
</details>

---

### Question 4
**A Business Capability Map shows:**

A) The sequence of steps in a business process  
B) The technology infrastructure of the enterprise  
C) A hierarchical decomposition of WHAT the business does, independent of how it is organized  
D) The network topology of the enterprise  

<details>
<summary>Answer</summary>

**C) A hierarchical decomposition of WHAT the business does, independent of how it is organized**

Business capabilities describe what the business does (not how), are technology-independent, and are organized hierarchically. Process flows show the sequence of steps (A). Technology infrastructure (B) and network topology (D) are Phase D concerns.
</details>

---

### Question 5
**Which artifact type in TOGAF represents the relationships between architecture entities?**

A) Catalogs  
B) Matrices  
C) Diagrams  
D) Principles  

<details>
<summary>Answer</summary>

**B) Matrices**

Matrices map relationships between entities (e.g., Actor/Role Matrix maps actors to roles). Catalogs list entities of a single type. Diagrams provide visual representations. Principles guide decisions.
</details>

---

### Question 6
**The Organization/Actor Catalog documents:**

A) Technology components and their versions  
B) All organizations, organizational units, and actors in the Business Architecture  
C) Application interfaces and their protocols  
D) Data entities and their attributes  

<details>
<summary>Answer</summary>

**B) All organizations, organizational units, and actors in the Business Architecture**

The Organization/Actor Catalog lists the organizational entities and actors (people, systems) that participate in the Business Architecture.
</details>

---

### Question 7
**In a gap analysis matrix, the "New" row represents:**

A) Baseline elements that are being eliminated  
B) Target elements that have no corresponding baseline element  
C) Elements that remain unchanged  
D) Elements that are being modified  

<details>
<summary>Answer</summary>

**B) Target elements that have no corresponding baseline element**

The "New" row captures target state elements that do not exist in the baseline — they must be created from scratch. The "Eliminated" column captures baseline elements with no target equivalent.
</details>

---

### Question 8
**Value streams in TOGAF:**

A) Only apply to manufacturing organizations  
B) Represent end-to-end collections of activities that create value for a customer or stakeholder  
C) Are the same as business processes  
D) Are only relevant in Phase D  

<details>
<summary>Answer</summary>

**B) Represent end-to-end collections of activities that create value for a customer or stakeholder**

Value streams cross organizational boundaries and focus on value delivery. They apply to all types of organizations (not just manufacturing). They are distinct from processes (higher level, value-focused). They are a Phase B concept, not Phase D.
</details>

---

### Question 9
**What is the relationship between business capabilities and value streams?**

A) They are the same concept  
B) Capabilities show WHAT the business does; value streams show the end-to-end flow of HOW value is delivered  
C) Value streams replace capabilities in TOGAF 10  
D) Capabilities are only used in Phase D  

<details>
<summary>Answer</summary>

**B) Capabilities show WHAT the business does; value streams show the end-to-end flow of HOW value is delivered**

They are complementary views. Capabilities can be mapped to value stream stages. Together, they provide a comprehensive business architecture perspective.
</details>

---

### Question 10
**TOGAF advises that the Baseline Architecture should be:**

A) Documented in exhaustive detail regardless of scope  
B) Documented only to the extent necessary to support the Target Architecture and gap analysis  
C) Ignored entirely — only the Target Architecture matters  
D) Documented using a different framework than the Target Architecture  

<details>
<summary>Answer</summary>

**B) Documented only to the extent necessary to support the Target Architecture and gap analysis**

TOGAF explicitly recommends avoiding over-documentation of the baseline. Focus effort on areas where changes are expected, and document to the level of detail needed for meaningful gap analysis.
</details>

---

### Question 11
**The Functional Decomposition Diagram shows:**

A) Network topology  
B) The hierarchical decomposition of business functions into sub-functions  
C) Data entity relationships  
D) Application interfaces  

<details>
<summary>Answer</summary>

**B) The hierarchical decomposition of business functions into sub-functions**

The Functional Decomposition Diagram is a tree-structured breakdown of business functions. It provides a structured view of what the business does, decomposed from high-level functions to detailed activities.
</details>

---

### Question 12
**Phase B produces candidate roadmap components. These are:**

A) Final, approved implementation plans  
B) Preliminary work packages that will be refined and prioritized in Phases E and F  
C) Technology procurement orders  
D) Staffing plans for the IT department  

<details>
<summary>Answer</summary>

**B) Preliminary work packages that will be refined and prioritized in Phases E and F**

Phase B identifies candidate roadmap components based on gap analysis, but they are only candidates. They are consolidated, evaluated, and prioritized in Phase E (Opportunities and Solutions) and Phase F (Migration Planning).
</details>

---

### Question 13
**Which step in Phase B involves presenting the architecture to stakeholders for formal review?**

A) Step 1 — Select reference models, viewpoints, and tools  
B) Step 4 — Perform gap analysis  
C) Step 7 — Conduct formal stakeholder review  
D) Step 9 — Create the Architecture Definition Document  

<details>
<summary>Answer</summary>

**C) Step 7 — Conduct formal stakeholder review**

Formal stakeholder review is Step 7, where the Business Architecture (baseline, target, and gaps) is presented to stakeholders for feedback and approval.
</details>

---

### Question 14
**The Actor/Role Matrix maps:**

A) Business goals to business services  
B) Actors (people, systems) to the roles they perform  
C) Applications to technology platforms  
D) Data entities to business processes  

<details>
<summary>Answer</summary>

**B) Actors (people, systems) to the roles they perform**

The Actor/Role Matrix is a Business Architecture matrix that shows which actors fill which business roles. This helps understand organizational responsibilities and potential automation opportunities.
</details>

---

### Question 15
**Which of the following is NOT a Business Architecture catalog?**

A) Organization/Actor Catalog  
B) Technology Standards Catalog  
C) Role Catalog  
D) Business Service/Function Catalog  

<details>
<summary>Answer</summary>

**B) Technology Standards Catalog**

The Technology Standards Catalog belongs to the Technology Architecture (Phase D), not the Business Architecture (Phase B). All other options are legitimate Phase B catalogs.
</details>

---

### Question 16
**In Phase B, Step 6 (Resolve impacts across the Architecture Landscape) is important because:**

A) It determines the project budget  
B) It ensures the Business Architecture is not developed in isolation but considers its impact on other domains, projects, and the broader landscape  
C) It selects the technology vendor  
D) It replaces the need for Phase C  

<details>
<summary>Answer</summary>

**B) It ensures the Business Architecture is not developed in isolation but considers its impact on other domains, projects, and the broader landscape**

Step 6 is about understanding the broader implications of Business Architecture changes — how they affect data, application, technology domains; other parallel architecture projects; and the overall Architecture Landscape.
</details>

---

### Question 17
**The Business Footprint Diagram shows:**

A) The physical locations of data centers  
B) The links between business goals, organizational units, business functions, and services  
C) The software deployment topology  
D) The network bandwidth utilization  

<details>
<summary>Answer</summary>

**B) The links between business goals, organizational units, business functions, and services**

The Business Footprint Diagram provides a comprehensive view of who does what and why — mapping organizational units to business functions and business goals to services. It provides the strategic "footprint" of the business.
</details>

---

*← [Phase A: Architecture Vision](02-Phase-A-Architecture-Vision.md) | Proceed to [Phase C: Information Systems Architecture](04-Phase-C-Information-Systems-Architecture.md) →*
