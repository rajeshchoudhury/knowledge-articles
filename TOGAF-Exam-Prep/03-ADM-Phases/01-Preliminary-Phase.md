# ADM Preliminary Phase: Framework and Principles

## Overview

The Preliminary Phase is the **preparation and initiation** phase of the TOGAF Architecture Development Method (ADM). It is executed **before** the main ADM cycle begins and establishes the organizational context, architecture principles, framework tailoring, and governance structures that will guide all subsequent architecture work. Think of the Preliminary Phase as "getting ready to do architecture" — it ensures that the organization has the right foundation, mandate, sponsorship, tools, and principles in place before any specific architecture project commences.

Unlike the cyclical Phases A through H, the Preliminary Phase is typically executed **once** (or revisited infrequently) to set up or refresh the enterprise architecture capability. However, TOGAF recognizes that organizations may return to the Preliminary Phase whenever there is a fundamental shift in business strategy, a merger/acquisition, or a significant change in the architecture governance model.

```
┌──────────────────────────────────────────────────────────────┐
│                    PRELIMINARY PHASE                         │
│                                                              │
│  ┌──────────────┐  ┌──────────────┐  ┌────────────────────┐ │
│  │ Define the   │  │ Establish    │  │ Define             │ │
│  │ Enterprise   │──▶ Architecture │──▶ Architecture       │ │
│  │ Context      │  │ Principles   │  │ Framework          │ │
│  └──────────────┘  └──────────────┘  └────────┬───────────┘ │
│                                               │             │
│  ┌──────────────┐  ┌──────────────┐  ┌────────▼───────────┐ │
│  │ Set Up       │  │ Establish    │  │ Establish           │ │
│  │ Architecture │◀──│ Governance  │◀──│ Architecture       │ │
│  │ Repository   │  │ Framework    │  │ Capability          │ │
│  └──────┬───────┘  └──────────────┘  └────────────────────┘ │
│         │                                                    │
│         ▼                                                    │
│  ┌──────────────────────────────────────────────────────┐    │
│  │    Ready to enter Phase A: Architecture Vision       │    │
│  └──────────────────────────────────────────────────────┘    │
└──────────────────────────────────────────────────────────────┘
```

> **Exam Tip:** The Preliminary Phase is NOT part of the cyclical ADM phases (A–H). It precedes the cycle. However, it is considered part of the ADM. Do not confuse it with Requirements Management, which is the central, continuous process spanning all phases.

---

## Objectives of the Preliminary Phase

The Preliminary Phase has the following key objectives:

1. **Determine the Architecture Capability desired by the organization** — Understand what level of architecture maturity the enterprise aspires to, and what it will take to get there.
2. **Establish the Architecture Capability** — Put in place the people, processes, tools, organization, roles, and responsibilities required to deliver architecture.
3. **Define the scope of organizations impacted** — Clarify which parts of the enterprise are within the architecture effort's boundaries ("the enterprise" for the purpose of architecture work).
4. **Confirm governance and support frameworks** — Align with existing corporate governance, IT governance, and any regulatory frameworks.
5. **Define and establish the architecture team and organization** — Set up the EA team, define reporting structures, and secure sponsorship.
6. **Identify and establish architecture principles** — Create a set of guiding principles that constrain and guide architecture decisions.
7. **Tailor the TOGAF framework** — Customize TOGAF and integrate it with other frameworks or methods the organization uses.
8. **Implement architecture tools** — Select and deploy architecture modeling tools, repositories, and collaboration platforms.

---

## Approach

### Defining "The Enterprise"

A critical first step is to define what "the enterprise" means in the context of this architecture effort. TOGAF uses the term "enterprise" broadly — it can range from a single department to a federation of organizations across geographies. The scope definition must be explicit and agreed upon by sponsors.

Key questions to answer:

- Which organizational units are included?
- Which business functions, processes, or capabilities are in scope?
- Are partner organizations, suppliers, or customers included?
- What geographies are covered?
- Are there organizational boundaries that constrain or complicate architecture work?

| Scope Level | Description | Example |
|-------------|-------------|---------|
| **Full Enterprise** | Entire organization, all divisions | Global bank — all business lines |
| **Federation of Enterprises** | Multiple collaborating organizations | Supply chain consortium |
| **Extended Enterprise** | Core org + selected partners/suppliers | Manufacturer + logistics partners |
| **Department/Division** | Single major business unit | Retail banking division only |
| **Program/Project** | Specific initiative | Digital transformation program |

> **Exam Tip:** The TOGAF Standard emphasizes that enterprise architecture should ideally encompass the entire organization, but practically it must be scoped to what is manageable and where sponsorship exists. The exam may test whether you understand that "the enterprise" in TOGAF does NOT necessarily mean the whole corporation.

### Identifying Key Drivers and Elements

The Preliminary Phase requires understanding the organizational context, including:

- **Business strategy and strategic plans** — Where is the organization heading?
- **Business drivers** — What external and internal forces are compelling change (competitive pressure, regulation, technology disruption)?
- **Current organizational structure** — How is the enterprise organized today?
- **Existing governance frameworks** — What governance mechanisms already exist?
- **Existing architecture capability (if any)** — Is there a current EA practice, and at what maturity level?
- **Stakeholder landscape** — Who are the key executives, decision-makers, and influencers?

---

## Defining the Architecture Framework

TOGAF is designed to be tailored, not applied rigidly out of the box. The Preliminary Phase is where you customize the framework to fit the organization's unique context. This tailoring may involve:

- **Selecting relevant ADM phases and steps** — Not every organization needs every step of every phase.
- **Integrating with other frameworks** — Many organizations combine TOGAF with ITIL, COBIT, SAFe, Zachman, or industry-specific frameworks.
- **Defining deliverable templates** — Standardizing document formats, naming conventions, and quality criteria.
- **Establishing architecture metamodel extensions** — Extending TOGAF's content metamodel to capture organization-specific entities.
- **Defining terminology** — Ensuring consistent use of terms across the enterprise.

| Integration Point | Framework | How They Complement |
|-------------------|-----------|-------------------|
| IT Service Management | ITIL 4 | TOGAF defines the architecture; ITIL manages service operations |
| IT Governance | COBIT | COBIT provides governance controls; TOGAF provides architecture structure |
| Agile Delivery | SAFe | SAFe manages agile execution; TOGAF provides architectural runway |
| Capability Framework | Zachman | Zachman offers a classification schema; TOGAF provides process and governance |
| Risk Management | ISO 31000 | ISO 31000 provides risk framework; TOGAF embeds risk into architecture decisions |

---

## Defining Architecture Principles

Architecture principles are **general rules and guidelines** that inform and support the way in which an organization sets about fulfilling its mission. They reflect a level of consensus across the enterprise and are intended to be enduring (not easily changed). TOGAF mandates that principles be defined with four components:

| Component | Description |
|-----------|-------------|
| **Name** | A brief, memorable label |
| **Statement** | A succinct declaration of the principle |
| **Rationale** | Why this principle is important — the business justification |
| **Implications** | What it means in practice — constraints, actions, or consequences |

### Sample Architecture Principles

Below are seven example principles suitable for exam preparation:

#### Principle 1: Primacy of Principles

| Component | Detail |
|-----------|--------|
| **Name** | Primacy of Principles |
| **Statement** | These architecture principles apply to all organizations within the enterprise. |
| **Rationale** | The only way to provide a consistent, high-quality information environment is if all organizations abide by the same set of principles. Without this principle, individual departments could pursue conflicting solutions that are locally optimal but globally suboptimal. |
| **Implications** | Any conflict with these principles must be resolved through the architecture governance process. Waivers require formal approval. All stakeholders must be educated on these principles and their binding nature. |

#### Principle 2: Maximize Benefit to the Enterprise

| Component | Detail |
|-----------|--------|
| **Name** | Maximize Benefit to the Enterprise |
| **Statement** | Information management decisions are made to provide maximum benefit to the enterprise as a whole. |
| **Rationale** | Local optimization rarely leads to global optimization. Decisions must be enterprise-wide to avoid duplication, promote interoperability, and reduce total cost of ownership. |
| **Implications** | Conflicting priorities across departments must be resolved through architecture governance. Projects may need to absorb additional cost or complexity if it benefits the enterprise overall. A cross-functional architecture review board must adjudicate disputes. |

#### Principle 3: Data is an Asset

| Component | Detail |
|-----------|--------|
| **Name** | Data is an Asset |
| **Statement** | Data is an asset that has value to the enterprise and is managed accordingly. |
| **Rationale** | Data is a corporate resource and must be managed with the same discipline applied to other tangible corporate assets. Accurate, timely data is critical to strategic decisions, operations, and compliance. |
| **Implications** | Data stewards must be identified and empowered. Data quality programs must be funded. Data must have defined ownership, lifecycle policies, and access controls. Metadata management must be established. |

#### Principle 4: Service Orientation

| Component | Detail |
|-----------|--------|
| **Name** | Service Orientation |
| **Statement** | The architecture is based on a design of services that mirror real-world business activities and are accessible through standard interfaces. |
| **Rationale** | Service orientation promotes loose coupling, reuse, and composability. It reduces point-to-point integrations, lowers long-term maintenance costs, and supports agility. |
| **Implications** | Applications must expose functionality through well-defined service interfaces. All new systems must be designed with APIs. An integration strategy based on services must be adopted. Legacy systems may require wrapping. |

#### Principle 5: Technology Independence

| Component | Detail |
|-----------|--------|
| **Name** | Technology Independence |
| **Statement** | The architecture does not depend on a specific technology product or vendor. |
| **Rationale** | Technology changes rapidly. Vendor lock-in limits flexibility, increases switching costs, and constrains future options. Standards-based approaches provide portability and protect investments. |
| **Implications** | Open standards must be preferred over proprietary ones. Contracts with vendors should include data portability clauses. Applications should be designed with abstraction layers to insulate against technology changes. |

#### Principle 6: Requirements-Based Change

| Component | Detail |
|-----------|--------|
| **Name** | Requirements-Based Change |
| **Statement** | Changes to applications and technology are made only in response to business needs. |
| **Rationale** | This principle ensures that technology change serves business purposes rather than being pursued for its own sake. It prevents "shiny new object syndrome" and ensures resources are focused on value delivery. |
| **Implications** | All change requests must be traced to business requirements. A business case must accompany technology proposals. Architecture governance must validate the business justification for changes. |

#### Principle 7: Common Use Applications

| Component | Detail |
|-----------|--------|
| **Name** | Common Use Applications |
| **Statement** | Development of applications used across the enterprise is preferred over the development of similar or duplicative applications used only within a single organization. |
| **Rationale** | Duplication wastes resources and creates inconsistency. Shared applications reduce total cost of ownership, improve data consistency, and support a unified user experience. |
| **Implications** | Before building new applications, the architecture repository must be searched for existing solutions. Shared platforms may require compromise on specific departmental requirements. Governance must enforce reuse-before-build policies. |

> **Exam Tip:** The exam frequently tests the four components of an architecture principle (Name, Statement, Rationale, Implications). Be prepared to identify missing components or to match principles to their correct category. Also note that architecture principles are different from business principles — architecture principles guide IT/architecture decisions specifically.

---

## Establishing the Architecture Capability

The architecture capability is the organizational competency that enables the ongoing development and use of enterprise architecture. It encompasses:

### Governance

- **Architecture Board** — A cross-functional body that provides oversight, direction, and dispute resolution for architecture activities.
- **Compliance reviews** — Formal checkpoints where projects are assessed for conformance to architecture standards.
- **Dispensation process** — A formal mechanism for granting exceptions to architecture standards when justified.
- **Architecture contracts** — Agreements between the architecture function and project/program teams defining deliverables, quality, and conformance expectations.

### Organization

- **EA team structure** — Centralized, federated, or hybrid models.
- **Reporting lines** — Where does the EA function sit in the organizational hierarchy? (Ideally reports to CIO or CTO with dotted lines to business leadership.)
- **Budget and funding** — How is the EA function funded? Dedicated budget vs. project-funded.

### Processes

- **Architecture development process** — The tailored ADM.
- **Architecture review process** — How architecture deliverables are reviewed and approved.
- **Architecture communication process** — How architecture decisions, standards, and guidance are disseminated.
- **Architecture change management process** — How the architecture responds to changing requirements.

### Roles and Responsibilities

| Role | Responsibility |
|------|---------------|
| **Chief Architect** | Overall architecture direction, stakeholder management, governance leadership |
| **Domain Architect** | Architecture within a specific domain (Business, Data, Application, Technology) |
| **Solution Architect** | Architecture for specific projects/programs, ensuring alignment to EA standards |
| **Architecture Board Member** | Governance, review, approval, dispute resolution |
| **Architecture Repository Manager** | Maintenance of the architecture repository and its content |
| **Stakeholder/Sponsor** | Provide direction, funding, and authority for architecture activities |

### Skills

- Business acumen and strategic thinking
- Technical depth across architecture domains
- Communication and presentation skills
- Governance and compliance knowledge
- Framework and methodology knowledge (TOGAF, etc.)
- Modeling and tooling proficiency

---

## Setting Up the Architecture Repository

The Architecture Repository is the structured store for all architecture outputs, reference materials, standards, and governance artifacts. Establishing it in the Preliminary Phase ensures a single, consistent location for all architecture content from day one. The repository structure in TOGAF includes:

```
┌──────────────────────────────────────────────────────┐
│               ARCHITECTURE REPOSITORY                │
│                                                      │
│  ┌─────────────────┐  ┌──────────────────────────┐   │
│  │ Architecture     │  │ Standards Information     │   │
│  │ Metamodel        │  │ Base (SIB)               │   │
│  └─────────────────┘  └──────────────────────────┘   │
│  ┌─────────────────┐  ┌──────────────────────────┐   │
│  │ Architecture     │  │ Reference Library         │   │
│  │ Landscape        │  │                          │   │
│  └─────────────────┘  └──────────────────────────┘   │
│  ┌─────────────────┐  ┌──────────────────────────┐   │
│  │ Governance Log   │  │ Architecture Capability   │   │
│  │                  │  │                          │   │
│  └─────────────────┘  └──────────────────────────┘   │
└──────────────────────────────────────────────────────┘
```

| Repository Component | Content |
|---------------------|---------|
| **Architecture Metamodel** | Defines the types of architecture entities and their relationships |
| **Architecture Capability** | Documents the organization's architecture capability maturity, processes, roles |
| **Architecture Landscape** | Strategic, Segment, and Capability architectures at various levels of detail |
| **Standards Information Base (SIB)** | Approved standards, guidelines, patterns, and best practices |
| **Reference Library** | Reference models, templates, and external reference materials (e.g., TOGAF Library, TRM, III-RM) |
| **Governance Log** | Records of governance decisions, compliance assessments, dispensations, and architecture contracts |

---

## Inputs (Detailed)

The following inputs feed into the Preliminary Phase:

| Input | Description | Source |
|-------|-------------|--------|
| **TOGAF Library** | The TOGAF Standard itself, including the ADM, Content Framework, reference models, and supporting guidance | The Open Group |
| **Other architecture framework materials** | Materials from frameworks the organization uses alongside TOGAF (e.g., Zachman, FEAF, DoDAF, BIAN, ArchiMate) | Industry / Government standards bodies |
| **Board strategies, business plans, business strategy** | High-level strategic direction documents from the board and senior leadership | Executive team / Board of Directors |
| **IT strategy, plans, and portfolio** | Current IT strategic documents, technology roadmaps, and the IT project portfolio | CIO office |
| **Business principles, business goals, and business drivers** | Documented business principles, SMART goals, and the forces driving change | Business leadership |
| **Governance and legal frameworks** | Corporate governance structures, regulatory requirements, compliance mandates, and legal constraints | Legal, Compliance, Risk teams |
| **Architecture Capability** | Assessment of the current EA maturity, existing architecture processes, tools, and team capability | Current EA team (if exists) |
| **Partnership and contract agreements** | Existing agreements with partners, vendors, outsourcers, or consortia that constrain or enable architecture decisions | Procurement, Legal, Partner management |

> **Exam Tip:** The Preliminary Phase has a broad range of inputs because it must understand the full organizational context. The exam may present a scenario and ask which input is most relevant. Pay special attention to the distinction between **business** principles/goals/drivers and **architecture** principles — business ones are INPUT; architecture ones are OUTPUT.

---

## Steps (Detailed)

### Step 1: Scope the Enterprise Organizations Impacted

Define the boundaries of the architecture effort. This involves:

- Identifying all organizational units that will participate in or be affected by the architecture.
- Mapping organizational structures to understand reporting lines, decision-making authority, and political dynamics.
- Determining the breadth and depth of coverage — is this a strategic enterprise architecture effort, a segment architecture, or a capability architecture?
- Identifying "core" vs. "extended" enterprise — which external partners, suppliers, or customers are in scope?
- Documenting any constraints on scope (e.g., regulatory restrictions, geographic limitations, political boundaries).

The output is a clear **scope statement** that is agreed upon by key sponsors.

### Step 2: Confirm Governance and Support Frameworks

Ensure that the architecture effort aligns with and leverages existing governance mechanisms:

- Review existing corporate governance (e.g., investment committees, risk committees).
- Review existing IT governance (e.g., IT steering committees, project management offices).
- Identify regulatory and compliance frameworks that the architecture must respect.
- Determine how architecture governance will integrate with existing governance — will it be a new function, or will it be embedded in existing bodies?
- Identify the architecture sponsor(s) and confirm their authority and commitment.

### Step 3: Define and Establish the Enterprise Architecture Team and Organization

Set up the organizational structure for architecture work:

- Define the EA operating model: centralized (single EA team), federated (domain teams with coordination), or hybrid.
- Identify required roles and fill them (Chief Architect, Domain Architects, etc.).
- Establish the Architecture Board — define its charter, membership, meeting cadence, and decision-making authority.
- Secure budget and resources for the EA function.
- Define relationships between the EA team and other teams (project management, development, operations, security).

### Step 4: Identify and Establish Architecture Principles

Develop the set of architecture principles that will guide all subsequent architecture work:

- Review existing business principles, goals, and drivers as the foundation.
- Draft architecture principles using the four-component format (Name, Statement, Rationale, Implications).
- Validate principles with key stakeholders across business and IT.
- Gain formal approval from the Architecture Board and executive sponsor.
- Publish principles and communicate them broadly.
- Establish a process for maintaining and evolving principles over time.

### Step 5: Tailor the TOGAF Framework and Other Selected Architecture Framework(s)

Customize TOGAF to fit the organization's context:

- Select which ADM phases and steps are relevant and at what level of rigor.
- Adapt deliverables and artifacts to organizational templates and standards.
- Integrate with other frameworks (ITIL for service management, COBIT for governance, SAFe for agile).
- Define the architecture content metamodel — decide which entities, attributes, and relationships are relevant.
- Establish naming conventions, taxonomy, and classification schemes.
- Define the level of formality required for different types of architecture engagements (e.g., strategic vs. tactical).
- Document the tailored framework so it is repeatable and teachable.

### Step 6: Implement Architecture Tools

Select and deploy the tools that will support the architecture practice:

- **Architecture modeling tools** — e.g., Sparx EA, Archi, BiZZdesign, Mega
- **Repository tools** — for storing and managing architecture artifacts
- **Collaboration tools** — for stakeholder engagement, reviews, and communication
- **Analysis tools** — for gap analysis, impact analysis, and dependency mapping
- **Governance tools** — for tracking compliance, dispensations, and contracts

Consider integration requirements between tools and with existing enterprise systems (e.g., CMDB, ITSM tools, project portfolio management).

---

## Outputs (Detailed)

| Output | Description |
|--------|-------------|
| **Organizational Model for Enterprise Architecture** | Defines the EA operating model — team structure, roles, responsibilities, constraints, budget, governance model |
| **Tailored Architecture Framework** | TOGAF customized for the organization — selected phases, steps, deliverables, templates, integration points with other frameworks |
| **Initial Architecture Repository** | The repository structure populated with initial content — principles, reference materials, standards, metamodel, templates |
| **Restatement of/reference to Business Principles, Business Goals, and Business Drivers** | Documented and validated set of business context that will drive architecture decisions in subsequent phases |
| **Request for Architecture Work (for Phase A)** | The trigger document that initiates Phase A — contains the business problem/opportunity, scope, constraints, sponsors, and initial stakeholders |
| **Architecture Governance Framework** | Defines how architecture governance will operate — Architecture Board charter, compliance review processes, dispensation procedures, escalation paths |

> **Exam Tip:** The most critical output to remember is the **Request for Architecture Work** — it serves as the bridge from the Preliminary Phase to Phase A. Without it, Phase A cannot begin. The exam often tests the trigger relationship between phases.

---

## Key Relationships to Other Phases

The Preliminary Phase sets the foundation that every other phase depends on:

| Phase | Relationship |
|-------|-------------|
| **Phase A (Architecture Vision)** | Receives the Request for Architecture Work; uses Architecture Principles, Tailored Framework, and Repository |
| **Phases B, C, D (Architecture Development)** | Use the tailored framework, principles, repository, and governance processes established in Preliminary |
| **Phase E (Opportunities and Solutions)** | Leverages the architecture repository and governance framework for evaluation |
| **Phase F (Migration Planning)** | Uses governance processes for prioritization and approval |
| **Phase G (Implementation Governance)** | Uses architecture contracts and compliance review processes defined here |
| **Phase H (Architecture Change Management)** | Relies on the governance framework and change management processes |
| **Requirements Management** | Uses the repository and metamodel to manage requirements across all phases |

```
                    ┌─────────────────────┐
                    │   PRELIMINARY       │
                    │   PHASE             │
                    └────────┬────────────┘
                             │
              Request for Architecture Work
                             │
                    ┌────────▼────────────┐
                    │   Phase A:          │
                    │   Architecture      │
                    │   Vision            │
                    └────────┬────────────┘
                             │
                    ┌────────▼────────────┐
                    │   Phase B:          │
                    │   Business          │
                    │   Architecture      │
                    └────────┬────────────┘
                             │
                    ┌────────▼────────────┐
                    │   Phase C:          │
                    │   IS Architecture   │
                    └────────┬────────────┘
                             │
                    ┌────────▼────────────┐
                    │   Phase D:          │
                    │   Technology        │
                    │   Architecture      │
                    └────────┬────────────┘
                             │
                   ... continues through H ...
```

---

## Exam Tips and Common Traps

1. **Preliminary Phase vs. Phase A** — The Preliminary Phase sets up the architecture **capability** (team, governance, principles, framework). Phase A starts a specific architecture **project** with a Vision. Don't confuse them.

2. **Architecture Principles vs. Business Principles** — Business principles are INPUTS to the Preliminary Phase. Architecture principles are OUTPUTS. The exam tests this distinction.

3. **Tailoring is expected** — TOGAF explicitly encourages tailoring. An answer that says "TOGAF must be applied exactly as written" is incorrect.

4. **Request for Architecture Work** — This is the key bridge document from Preliminary to Phase A. It is an OUTPUT of Preliminary and an INPUT to Phase A.

5. **The Preliminary Phase is part of the ADM** — Even though it precedes the A–H cycle, it is officially part of the ADM.

6. **Enterprise scope is flexible** — "The enterprise" does not necessarily mean the whole corporation. It is defined in the Preliminary Phase based on practical scope.

7. **Principles have four components** — Name, Statement, Rationale, Implications. If the exam asks about principle structure, this is the answer.

8. **Governance is established here** — The Architecture Board, compliance reviews, and dispensation processes are set up in the Preliminary Phase. Phase G performs governance during implementation, but the governance **framework** is established here.

9. **The Architecture Repository is initialized** — It is first created in the Preliminary Phase and then progressively populated throughout all subsequent phases.

10. **Organizational Model for EA** — This output defines who does what in the EA practice. It is distinct from the organizational structure of the enterprise itself.

---

## Review Questions

### Question 1
**Which of the following is the PRIMARY purpose of the Preliminary Phase?**

A) To develop the Architecture Vision for a specific project  
B) To prepare the organization and define the framework for architecture work  
C) To perform gap analysis between baseline and target architectures  
D) To manage architecture requirements  

<details>
<summary>Answer</summary>

**B) To prepare the organization and define the framework for architecture work**

The Preliminary Phase is about establishing the architecture capability, principles, governance, and tailored framework — all preparation activities. Phase A develops the Architecture Vision (A). Gap analysis occurs in Phases B, C, D (C). Requirements Management is a separate continuous process (D).
</details>

---

### Question 2
**Architecture principles in TOGAF must include which four components?**

A) Name, Description, Owner, Priority  
B) Name, Statement, Rationale, Implications  
C) Title, Definition, Impact, Mitigation  
D) Name, Category, Weight, Enforcement  

<details>
<summary>Answer</summary>

**B) Name, Statement, Rationale, Implications**

These are the four mandatory components defined in the TOGAF Standard for documenting architecture principles. This is a frequently tested fact.
</details>

---

### Question 3
**What is the key output of the Preliminary Phase that triggers Phase A?**

A) Architecture Vision  
B) Statement of Architecture Work  
C) Request for Architecture Work  
D) Architecture Contract  

<details>
<summary>Answer</summary>

**C) Request for Architecture Work**

The Request for Architecture Work is the formal trigger document that initiates Phase A. The Architecture Vision (A) is an output of Phase A. The Statement of Architecture Work (B) is also an output of Phase A. Architecture Contracts (D) are used in Phase G.
</details>

---

### Question 4
**In the Preliminary Phase, "defining the enterprise" means:**

A) Creating the legal entity structure for the organization  
B) Determining the organizational scope of the architecture effort  
C) Defining all business processes in the organization  
D) Creating the organizational chart  

<details>
<summary>Answer</summary>

**B) Determining the organizational scope of the architecture effort**

"Defining the enterprise" means determining which parts of the organization are in scope for architecture work. It does not involve legal structuring (A), full process definition (C), or creating org charts (D).
</details>

---

### Question 5
**Which of the following is an INPUT to the Preliminary Phase?**

A) Architecture Principles  
B) Tailored Architecture Framework  
C) Business principles, business goals, and business drivers  
D) Request for Architecture Work  

<details>
<summary>Answer</summary>

**C) Business principles, business goals, and business drivers**

Business principles are inputs; Architecture Principles are outputs. The Tailored Architecture Framework (B) is an output. The Request for Architecture Work (D) is also an output.
</details>

---

### Question 6
**The Preliminary Phase recommends establishing which governance body?**

A) Project Management Office  
B) Architecture Board  
C) IT Steering Committee  
D) Change Advisory Board  

<details>
<summary>Answer</summary>

**B) Architecture Board**

The Architecture Board is established in the Preliminary Phase to provide governance, oversight, and dispute resolution for architecture activities. The other bodies may exist but are not specifically established by the Preliminary Phase.
</details>

---

### Question 7
**Which statement about tailoring TOGAF is TRUE?**

A) TOGAF must be applied exactly as defined without modification  
B) Tailoring is done in Phase A after the Architecture Vision is approved  
C) TOGAF is designed to be tailored to fit the organization's context, and this is done in the Preliminary Phase  
D) Tailoring TOGAF means removing the Architecture Repository  

<details>
<summary>Answer</summary>

**C) TOGAF is designed to be tailored to fit the organization's context, and this is done in the Preliminary Phase**

TOGAF explicitly encourages tailoring. This includes adapting deliverables, selecting relevant phases/steps, and integrating with other frameworks. This tailoring occurs in the Preliminary Phase, not Phase A.
</details>

---

### Question 8
**What is the Architecture Repository?**

A) A tool for version-controlling source code  
B) A structured store for all architecture outputs, reference materials, standards, and governance artifacts  
C) A database containing all business data entities  
D) A collection of approved project plans  

<details>
<summary>Answer</summary>

**B) A structured store for all architecture outputs, reference materials, standards, and governance artifacts**

The Architecture Repository is a key TOGAF concept — it holds the architecture metamodel, landscape, Standards Information Base, reference library, governance log, and capability documentation.
</details>

---

### Question 9
**Which of the following is NOT a component of the Architecture Repository?**

A) Architecture Metamodel  
B) Standards Information Base  
C) Project Management Plan  
D) Governance Log  

<details>
<summary>Answer</summary>

**C) Project Management Plan**

The Architecture Repository includes the Architecture Metamodel, Standards Information Base, Reference Library, Architecture Landscape, Governance Log, and Architecture Capability. A Project Management Plan is not part of the repository.
</details>

---

### Question 10
**The Preliminary Phase is best described as:**

A) A phase that is executed once and never revisited  
B) A cyclical phase that repeats with every ADM iteration  
C) A preparatory phase typically executed once but revisited when significant organizational changes occur  
D) A phase that runs continuously in parallel with all other phases  

<details>
<summary>Answer</summary>

**C) A preparatory phase typically executed once but revisited when significant organizational changes occur**

The Preliminary Phase is normally a one-time setup, but organizations may revisit it after mergers, major strategy shifts, or governance changes. It is not strictly one-time-only (A), not cyclical (B), and not continuous (D — that describes Requirements Management).
</details>

---

### Question 11
**What is the relationship between business principles and architecture principles?**

A) They are the same thing  
B) Business principles are derived from architecture principles  
C) Architecture principles are developed considering business principles as input  
D) Architecture principles replace business principles  

<details>
<summary>Answer</summary>

**C) Architecture principles are developed considering business principles as input**

Business principles inform and guide the development of architecture principles. They are different levels of principles — business principles guide the enterprise broadly, while architecture principles specifically guide architecture and technology decisions.
</details>

---

### Question 12
**An organization wants to combine TOGAF with ITIL and SAFe. Where in the ADM is this integration planned?**

A) Phase A — Architecture Vision  
B) Preliminary Phase — Tailoring the TOGAF Framework  
C) Phase E — Opportunities and Solutions  
D) Phase G — Implementation Governance  

<details>
<summary>Answer</summary>

**B) Preliminary Phase — Tailoring the TOGAF Framework**

Framework integration and tailoring is a core activity of the Preliminary Phase. This is where TOGAF is customized and integrated with other frameworks like ITIL, COBIT, SAFe, and Zachman.
</details>

---

### Question 13
**Which role is typically responsible for leading the Preliminary Phase activities?**

A) Project Manager  
B) Chief Architect or Enterprise Architect  
C) Business Analyst  
D) Software Developer  

<details>
<summary>Answer</summary>

**B) Chief Architect or Enterprise Architect**

The Chief Architect or Enterprise Architect is typically responsible for leading the Preliminary Phase, as it involves establishing the architecture practice, principles, and governance.
</details>

---

### Question 14
**The Organizational Model for Enterprise Architecture is an output of which phase?**

A) Phase A  
B) Preliminary Phase  
C) Phase G  
D) Phase H  

<details>
<summary>Answer</summary>

**B) Preliminary Phase**

The Organizational Model for Enterprise Architecture defines the EA team structure, roles, and governance model. It is created in the Preliminary Phase as part of establishing the architecture capability.
</details>

---

### Question 15
**Which of the following BEST describes the scope definition activity in the Preliminary Phase?**

A) Defining the technical scope of a specific solution  
B) Defining which organizations, functions, and geographies are part of the architecture effort  
C) Defining the project scope for a single development team  
D) Defining the security perimeter of the enterprise network  

<details>
<summary>Answer</summary>

**B) Defining which organizations, functions, and geographies are part of the architecture effort**

Scope definition in the Preliminary Phase is about defining "the enterprise" for architecture purposes — which organizational units, business functions, and geographies are included. It is not about technical solution scope, project scope, or security perimeters.
</details>

---

### Question 16
**Which statement about the Architecture Governance Framework is correct?**

A) It is established in Phase G  
B) It is established in the Preliminary Phase and used throughout the ADM  
C) It is only used during Phase A  
D) It is an optional component of TOGAF  

<details>
<summary>Answer</summary>

**B) It is established in the Preliminary Phase and used throughout the ADM**

The Architecture Governance Framework is created in the Preliminary Phase and then applied across all subsequent ADM phases. Phase G is about governing implementation, but the governance framework itself is set up earlier.
</details>

---

### Question 17
**An organization is performing the Preliminary Phase for the first time. They have no existing architecture capability. Which of the following steps should be performed FIRST?**

A) Implement architecture tools  
B) Tailor the TOGAF framework  
C) Scope the enterprise organizations impacted  
D) Identify and establish architecture principles  

<details>
<summary>Answer</summary>

**C) Scope the enterprise organizations impacted**

Before you can tailor frameworks, define principles, or implement tools, you must first understand the scope — which parts of the enterprise are involved. This establishes the context for all subsequent Preliminary Phase activities.
</details>

---

*End of Preliminary Phase study guide. Proceed to [Phase A: Architecture Vision](02-Phase-A-Architecture-Vision.md) →*
