# Module 7: Architecture Capability Framework

> **Exam Relevance**: HIGH — The Architecture Capability Framework is tested on both Part 1 and Part 2. Part 1 tests definitions and terminology. Part 2 tests your ability to apply concepts like the Architecture Board, compliance reviews, and the skills framework in scenario-based questions.

---

## Table of Contents

1. [What Is the Architecture Capability Framework?](#1-what-is-the-architecture-capability-framework)
2. [Purpose and Motivation](#2-purpose-and-motivation)
3. [Architecture Board](#3-architecture-board)
4. [Architecture Compliance](#4-architecture-compliance)
5. [Architecture Contracts](#5-architecture-contracts)
6. [Architecture Governance within the Capability Framework](#6-architecture-governance-within-the-capability-framework)
7. [Architecture Maturity Models](#7-architecture-maturity-models)
8. [Architecture Skills Framework](#8-architecture-skills-framework)
9. [Establishing the Architecture Capability](#9-establishing-the-architecture-capability)
10. [Organizational Structures for EA Teams](#10-organizational-structures-for-ea-teams)
11. [EA Governance Models](#11-ea-governance-models)
12. [Budgeting and Resourcing](#12-budgeting-and-resourcing)
13. [Key Diagrams](#13-key-diagrams)
14. [Exam Tips](#14-exam-tips)
15. [Review Questions](#15-review-questions)

---

## 1. What Is the Architecture Capability Framework?

The **Architecture Capability Framework** is a set of reference materials and guidelines provided by TOGAF for establishing, operating, and sustaining an enterprise architecture practice within an organization. While the ADM tells you *how to do architecture*, the Architecture Capability Framework tells you *how to set up and manage the team and governance structures that do the architecture*.

Think of it this way: the ADM is the engine; the Architecture Capability Framework is the factory that builds, maintains, and fuels that engine.

TOGAF defines it as:

> *"A set of resources, guidelines, templates, and background information to help the architect establish an architecture practice within an organization."*

The Architecture Capability Framework addresses:

- **People**: Who performs architecture work, what skills they need, and how they develop
- **Process**: How architecture work is governed, reviewed, and approved
- **Structure**: How the architecture function is organized within the enterprise
- **Tools**: What mechanisms and instruments support architecture operations

---

## 2. Purpose and Motivation

### Why do organizations need an Architecture Capability Framework?

Enterprise architecture does not happen in a vacuum. Even the best ADM execution will fail if the organization lacks:

- A **mandated architecture function** with clear authority
- **Skilled architects** who know their domains
- **Governance processes** that ensure architecture compliance
- **Executive sponsorship** and adequate funding
- **Organizational structures** that position architecture appropriately

### Key Purposes

| Purpose | Description |
|---|---|
| **Establish the Practice** | Define the organizational structures, roles, and processes needed to operate an architecture function |
| **Ensure Quality** | Set up compliance and governance mechanisms to maintain architecture quality |
| **Develop People** | Provide a skills framework for hiring, assessing, and developing architects |
| **Enable Governance** | Create the governance bodies (Architecture Board) and processes needed to make architecture decisions |
| **Sustain Operations** | Ensure the architecture practice has ongoing funding, executive support, and mandate |
| **Measure Maturity** | Provide maturity models to assess and improve the architecture practice over time |

---

## 3. Architecture Board

The **Architecture Board** is the governance body responsible for overseeing the implementation of the architecture governance strategy. It is the primary decision-making authority for architecture within the organization.

### 3.1 Purpose

The Architecture Board exists to:

- Provide oversight and direction for the architecture function
- Resolve architecture disputes and make binding decisions
- Ensure architecture compliance across projects and programs
- Approve architecture contracts, dispensations, and exceptions
- Align architecture decisions with business strategy

### 3.2 Composition

TOGAF recommends the following composition for an Architecture Board:

| Role | Responsibility |
|---|---|
| **Sponsor (Chair)** | Senior executive who provides authority and business context; typically a CIO, CTO, or VP |
| **Chief Architect** | Leads the architecture function; presents architecture recommendations |
| **Business Domain Representatives** | Ensure architectures meet business needs; may include business unit heads |
| **IT Domain Representatives** | Bring technical expertise; may include infrastructure, applications, and data leads |
| **Program/Project Representatives** | Represent the perspective of implementation teams |
| **External Advisors** (optional) | Subject matter experts, consultants, or vendor representatives |

### Composition Principles:

- The board should be **cross-functional** — representing both business and IT
- It should be **senior enough** to have decision-making authority
- It should be **small enough** to make decisions efficiently (typically 5-10 members)
- Membership may rotate based on the architecture domain under review

### 3.3 Responsibilities

The Architecture Board is responsible for:

1. **Providing governance** over the architecture function
2. **Reviewing and approving** architecture deliverables at key ADM milestones
3. **Ensuring compliance** of projects with the target architecture
4. **Resolving conflicts** between architecture requirements and implementation constraints
5. **Granting dispensations** when projects cannot fully comply with the architecture
6. **Approving architecture contracts** between architecture and development/business teams
7. **Managing risk** related to architecture decisions
8. **Setting direction** for the architecture function's priorities and focus areas
9. **Communicating** architecture decisions and their rationale to stakeholders
10. **Monitoring** the effectiveness of the architecture governance framework

### 3.4 Operating Rules

| Rule | Description |
|---|---|
| **Meeting Frequency** | Regular meetings (typically monthly or quarterly); ad-hoc meetings for urgent decisions |
| **Quorum** | Minimum number of members required for decisions (typically majority) |
| **Decision Process** | Consensus-based with the Chair having tie-breaking authority |
| **Escalation** | Unresolved issues escalate to corporate governance (e.g., CIO, executive committee) |
| **Record Keeping** | All decisions, rationale, and action items must be documented in the Governance Log |
| **Agenda** | Published in advance with supporting materials |
| **Authority** | Decisions are binding on all architecture-related activities within scope |

---

## 4. Architecture Compliance

Architecture compliance ensures that projects and implementations adhere to the defined architecture. TOGAF provides a structured approach to assessing compliance.

### 4.1 Compliance Reviews

A **compliance review** is a formal examination of a project's alignment with the target architecture. It is typically conducted at key project milestones (e.g., design review, pre-deployment).

**Purpose of compliance reviews:**
- Verify that implementations follow the architecture
- Identify deviations early before they become costly
- Provide feedback to improve both architectures and implementations
- Feed the Governance Log with compliance records

**When are compliance reviews conducted?**
- At project initiation (architecture alignment check)
- At major design milestones
- Before deployment to production
- After significant change requests
- Periodically for long-running programs

### 4.2 Levels of Conformance

TOGAF defines **six levels of conformance** that describe how well a project aligns with the architecture:

| Level | Definition | Implications |
|---|---|---|
| **Irrelevant** | The architecture specification has no bearing on this project | No compliance action needed; the specification does not apply |
| **Consistent** | The project has not directly implemented the architecture specification but does not conflict with it | Acceptable; the project does not violate the architecture even though it does not explicitly follow it |
| **Compliant** | Some features of the architecture specification have been implemented, and those that have been implemented are in compliance | Partially implemented but acceptable; implemented portions follow the architecture |
| **Conformant** | All the features of the architecture specification have been implemented, and all are in compliance | Fully implemented and fully aligned — the desired state |
| **Fully Conformant** | All features implemented in compliance AND the implementation includes additional features not covered by the specification, which are also in compliance | Exceeds requirements while remaining fully aligned — the best possible state |
| **Non-Conformant** | Some features of the architecture specification have been implemented but are NOT in compliance | A problem state requiring remediation, dispensation, or architecture update |

### Conformance Level Hierarchy (from best to worst):

```
  FULLY CONFORMANT    ← Best: all features + extras, all compliant
        ↓
  CONFORMANT          ← Good: all features implemented and compliant
        ↓
  COMPLIANT           ← Acceptable: partial implementation, all compliant
        ↓
  CONSISTENT          ← OK: doesn't implement but doesn't conflict
        ↓
  IRRELEVANT          ← N/A: specification doesn't apply
        ↓
  NON-CONFORMANT      ← Problem: implemented features are not compliant
```

### 4.3 Handling Non-Conformance

When a project is found to be Non-Conformant, there are several options:

1. **Remediate**: The project modifies its implementation to become compliant
2. **Dispensation**: The Architecture Board grants a formal exception (see Architecture Governance module)
3. **Architecture Update**: The architecture itself is updated to accommodate the project's approach (if justified)
4. **Risk Acceptance**: The risk of non-conformance is formally accepted and documented

---

## 5. Architecture Contracts

**Architecture Contracts** are formal agreements that govern the development and delivery of architecture-related work. They are binding commitments that set expectations between parties.

### 5.1 Types of Architecture Contracts

TOGAF identifies two primary types:

#### Contract Type 1: Architecture Authority ↔ Development Team

This contract governs the relationship between the architecture function and the teams building solutions.

| Element | Description |
|---|---|
| **Purpose** | Ensure that development teams build solutions conforming to the architecture |
| **Contains** | Architecture deliverables, standards to follow, compliance checkpoints, remediation procedures |
| **Signed by** | Chief Architect (or delegate) and Program/Project Manager |
| **Enforced through** | Architecture compliance reviews |

#### Contract Type 2: Architecture Function ↔ Business Users

This contract governs the relationship between the architecture function and the business stakeholders it serves.

| Element | Description |
|---|---|
| **Purpose** | Ensure that the architecture meets business needs and expectations |
| **Contains** | Scope of architecture work, business requirements addressed, timeline, quality attributes |
| **Signed by** | Chief Architect (or delegate) and Business Sponsor |
| **Enforced through** | Business review and acceptance of architecture deliverables |

### 5.2 Key Elements of an Architecture Contract

Every architecture contract should include:

- **Scope and objectives** of the architecture work
- **Architecture deliverables** to be produced
- **Conformance requirements** (which standards and specifications apply)
- **Conformance measures** (how compliance will be assessed)
- **Timeline and milestones** for delivery
- **Roles and responsibilities** of all parties
- **Acceptance criteria** for deliverables
- **Change management procedures** (how changes to the contract are handled)
- **Escalation procedures** for disputes
- **Penalties or consequences** for non-compliance

---

## 6. Architecture Governance within the Capability Framework

Architecture governance, as a component of the Architecture Capability Framework, focuses on the organizational structures and processes needed to govern architecture work effectively. (A detailed treatment of governance is in Module 8.)

### Governance Framework Components

| Component | Description |
|---|---|
| **Governance Bodies** | Architecture Board, steering committees, review panels |
| **Governance Processes** | Compliance reviews, dispensation processes, change control |
| **Governance Artifacts** | Contracts, compliance reports, dispensation records, decision logs |
| **Governance Policies** | Standards, principles, guidelines that govern architecture decisions |

### Organizational Structure for Governance

```
┌───────────────────────────────────────────────┐
│          Corporate Governance Board            │
│    (Board of Directors / Executive Committee)   │
└───────────────────────┬───────────────────────┘
                        │
                        ▼
┌───────────────────────────────────────────────┐
│            IT Governance Board                 │
│         (CIO / IT Leadership Team)             │
└───────────────────────┬───────────────────────┘
                        │
                        ▼
┌───────────────────────────────────────────────┐
│           Architecture Board                   │
│     (Chief Architect + Cross-functional        │
│      representatives)                          │
└───────────────────────┬───────────────────────┘
                        │
          ┌─────────────┼─────────────┐
          ▼             ▼             ▼
    ┌───────────┐ ┌───────────┐ ┌───────────┐
    │ Domain    │ │ Domain    │ │ Domain    │
    │ Arch      │ │ Arch      │ │ Arch      │
    │ Working   │ │ Working   │ │ Working   │
    │ Group     │ │ Group     │ │ Group     │
    │(Business) │ │(Data/App) │ │(Technology│
    └───────────┘ └───────────┘ └───────────┘
```

---

## 7. Architecture Maturity Models

Architecture maturity models help organizations assess the current maturity of their architecture capability and plan improvements. TOGAF references maturity models as a key tool for the Architecture Capability Framework.

### 7.1 Maturity Levels

While TOGAF does not prescribe a single maturity model, it references models similar to CMMI. A typical architecture maturity model includes these levels:

| Level | Name | Characteristics |
|---|---|---|
| **0** | **None** | No architecture practice exists; ad-hoc decision making |
| **1** | **Initial** | Architecture processes are informal, reactive, and inconsistent; dependent on individuals |
| **2** | **Under Development** | Architecture processes are being defined; some standards exist; partial buy-in |
| **3** | **Defined** | Architecture processes are documented, standardized, and followed; governance is in place; consistent execution |
| **4** | **Managed** | Architecture is measured and controlled; metrics are collected; continuous improvement based on data |
| **5** | **Optimizing** | Architecture is a strategic capability; continuous innovation; proactive adaptation to change; architecture drives business strategy |

### 7.2 Maturity Assessment Areas

Organizations should assess maturity across multiple dimensions:

| Dimension | What to Assess |
|---|---|
| **Process** | Are architecture processes defined, documented, and followed? |
| **People** | Are there skilled architects? Is there a skills development program? |
| **Governance** | Is there an Architecture Board? Are compliance reviews conducted? |
| **Tools** | Are appropriate architecture modeling and repository tools in place? |
| **Standards** | Are architecture standards defined and maintained? |
| **Stakeholder Engagement** | Is architecture integrated into business planning and decision-making? |
| **Value Delivery** | Can the architecture function demonstrate measurable business value? |

### 7.3 Using Maturity Assessments

1. **Baseline assessment**: Determine current maturity level
2. **Target setting**: Define the desired maturity level (not every organization needs Level 5)
3. **Gap analysis**: Identify what needs to change to move from current to target
4. **Improvement roadmap**: Plan specific initiatives to close the gaps
5. **Periodic reassessment**: Measure progress at regular intervals

---

## 8. Architecture Skills Framework

The **Architecture Skills Framework** defines the skills, knowledge areas, and proficiency levels needed by enterprise architects. It provides a structured approach to hiring, assessing, developing, and managing architecture talent.

### 8.1 Skills Categories

TOGAF identifies **seven categories of skills** relevant to enterprise architects:

| Category | Description | Examples |
|---|---|---|
| **Generic Skills** | Core professional and interpersonal skills | Leadership, communication, teamwork, problem-solving, negotiation, presentation |
| **Business Skills & Methods** | Understanding of business operations, strategy, and processes | Business case development, strategic planning, financial analysis, business process modeling |
| **Enterprise Architecture Skills** | Specific EA methodology and framework knowledge | TOGAF ADM, architecture modeling, viewpoint development, gap analysis, building block design |
| **Program/Project Management Skills** | Ability to manage and contribute to programs and projects | Project planning, risk management, change management, stakeholder management, resource management |
| **IT General Knowledge Skills** | Broad understanding of IT landscape and trends | Cloud computing, cybersecurity, data management, DevOps, software development lifecycle |
| **Technical IT Skills** | Deep expertise in specific technology domains | Software engineering, networking, database design, middleware, infrastructure, platform engineering |
| **Legal Environment** | Knowledge of relevant laws, regulations, and compliance requirements | Data privacy (GDPR, CCPA), industry regulations, intellectual property, contract law, accessibility standards |

### 8.2 Proficiency Levels

Each skill category is assessed at one of four **proficiency levels**:

| Level | Name | Definition | Description |
|---|---|---|---|
| **1** | **Background** | Has a general awareness | Knows the area exists and has a basic understanding; cannot perform tasks independently |
| **2** | **Awareness** | Has a working knowledge | Understands key concepts and can discuss them; can contribute under guidance |
| **3** | **Knowledge** | Has a detailed understanding | Can apply the skill independently; can make decisions and solve problems in this area |
| **4** | **Expert** | Has deep, specialized expertise | Recognized authority; can mentor others, set standards, and innovate in this area |

### 8.3 Role Descriptions and Skill Requirements

TOGAF defines several key architecture roles with their expected skill profiles:

#### Chief Architect (Enterprise Architect Lead)

| Skill Category | Required Proficiency |
|---|---|
| Generic Skills | Expert (4) |
| Business Skills & Methods | Expert (4) |
| Enterprise Architecture Skills | Expert (4) |
| Program/Project Management Skills | Knowledge (3) |
| IT General Knowledge Skills | Knowledge (3) |
| Technical IT Skills | Awareness (2) |
| Legal Environment | Knowledge (3) |

**Key Responsibilities:**
- Sets the overall direction for the architecture function
- Leads the Architecture Board
- Reports to senior executive leadership
- Ensures architecture aligns with business strategy
- Manages the architecture team and capability

#### Enterprise Architect

| Skill Category | Required Proficiency |
|---|---|
| Generic Skills | Knowledge (3) |
| Business Skills & Methods | Knowledge (3) |
| Enterprise Architecture Skills | Expert (4) |
| Program/Project Management Skills | Knowledge (3) |
| IT General Knowledge Skills | Knowledge (3) |
| Technical IT Skills | Awareness (2) |
| Legal Environment | Awareness (2) |

**Key Responsibilities:**
- Develops and maintains the enterprise-wide architecture
- Executes the ADM across all domains
- Maintains the Architecture Repository
- Conducts architecture reviews

#### Solution Architect

| Skill Category | Required Proficiency |
|---|---|
| Generic Skills | Knowledge (3) |
| Business Skills & Methods | Awareness (2) |
| Enterprise Architecture Skills | Knowledge (3) |
| Program/Project Management Skills | Knowledge (3) |
| IT General Knowledge Skills | Knowledge (3) |
| Technical IT Skills | Expert (4) |
| Legal Environment | Awareness (2) |

**Key Responsibilities:**
- Translates enterprise architecture into solution designs
- Works directly with development teams
- Ensures solutions conform to the enterprise architecture
- Selects technologies and products (SBBs)

#### Program Architect

| Skill Category | Required Proficiency |
|---|---|
| Generic Skills | Knowledge (3) |
| Business Skills & Methods | Knowledge (3) |
| Enterprise Architecture Skills | Knowledge (3) |
| Program/Project Management Skills | Expert (4) |
| IT General Knowledge Skills | Knowledge (3) |
| Technical IT Skills | Awareness (2) |
| Legal Environment | Awareness (2) |

**Key Responsibilities:**
- Ensures architecture consistency across multiple projects within a program
- Manages architecture dependencies between projects
- Coordinates with Solution Architects across the program
- Bridges between Enterprise Architects and project teams

### 8.4 Skills Matrix Summary

```
                   Generic  Business  EA    PM    IT Gen  Tech IT  Legal
                   Skills   Skills    Skills Skills Skills  Skills  Env
  ─────────────── ──────── ──────── ────── ────── ─────── ─────── ──────
  Chief Architect    4        4       4      3      3       2       3
  Enterprise Arch    3        3       4      3      3       2       2
  Solution Arch      3        2       3      3      3       4       2
  Program Arch       3        3       3      4      3       2       2
  ─────────────── ──────── ──────── ────── ────── ─────── ─────── ──────
  
  Proficiency: 1=Background, 2=Awareness, 3=Knowledge, 4=Expert
```

---

## 9. Establishing the Architecture Capability

Establishing an architecture capability is a **critical early step** in TOGAF — it is addressed in the **Preliminary Phase** of the ADM. Before running the first full ADM cycle, the organization must set up the foundations:

### 9.1 Key Steps

| Step | Activity | Output |
|---|---|---|
| **1. Define Scope** | Determine the scope of the architecture capability (enterprise-wide or specific segments) | Architecture Capability Scope Definition |
| **2. Secure Sponsorship** | Obtain executive sponsorship and mandate | Sponsor commitment, budget approval |
| **3. Define Governance** | Establish the Architecture Board, governance processes, and policies | Architecture Board Charter, Governance Framework |
| **4. Staff the Team** | Hire or assign architects; assess skills against the Skills Framework | Architecture team roster, skills gap analysis |
| **5. Define Processes** | Tailor the ADM, define compliance review processes, set up contract templates | Tailored ADM, process documentation |
| **6. Set Up Repository** | Establish the Architecture Repository (tools, structure, initial content) | Functioning Architecture Repository |
| **7. Define Principles** | Establish architecture principles that will guide all architecture work | Architecture Principles document |
| **8. Communicate** | Communicate the architecture capability, its mandate, and its value to the organization | Communication plan, stakeholder briefings |
| **9. Pilot** | Run an initial ADM iteration on a manageable scope to prove the approach | Pilot architecture, lessons learned |
| **10. Refine** | Refine processes, governance, and structures based on pilot experience | Updated capability documentation |

### 9.2 Architecture Principles

Architecture principles are high-level statements that guide architecture decisions. They are established during capability setup and maintained throughout. TOGAF recommends each principle include:

| Element | Description |
|---|---|
| **Name** | A short, memorable label |
| **Statement** | A clear declaration of the principle |
| **Rationale** | Why this principle is important |
| **Implications** | What adopting this principle means in practice |

**Example Principle:**

- **Name**: Technology Independence
- **Statement**: Architecture shall not depend on a specific vendor or technology product
- **Rationale**: Vendor lock-in limits flexibility and increases long-term costs
- **Implications**: Solutions must use open standards; multi-vendor strategies are preferred; architecture descriptions use ABBs before SBBs

---

## 10. Organizational Structures for EA Teams

There are several models for positioning the enterprise architecture function within an organization:

### 10.1 Centralized Model

```
┌───────────────────────────────┐
│        CIO / CTO              │
│  ┌─────────────────────────┐  │
│  │  Central EA Team         │  │
│  │  • Chief Architect       │  │
│  │  • Enterprise Architects │  │
│  │  • Solution Architects   │  │
│  └─────────────┬───────────┘  │
│                │               │
│    ┌───────────┼───────────┐   │
│    ▼           ▼           ▼   │
│  BU-A        BU-B        BU-C  │
│  (served)    (served)    (served│)
└───────────────────────────────┘
```

| Advantage | Disadvantage |
|---|---|
| Consistent standards and approaches | May be distant from business unit needs |
| Efficient resource utilization | Can become a bottleneck |
| Strong governance | May lack domain-specific expertise |

### 10.2 Federated Model

```
┌──────────────────────────────────────┐
│          CIO / CTO                    │
│  ┌──────────────────────┐             │
│  │  Central EA Team      │             │
│  │  (Standards, Govnce)  │             │
│  └──────────┬───────────┘             │
│             │                          │
│    ┌────────┼─────────┐               │
│    ▼        ▼         ▼               │
│  ┌──────┐ ┌──────┐ ┌──────┐          │
│  │ BU-A │ │ BU-B │ │ BU-C │          │
│  │ Arch │ │ Arch │ │ Arch │          │
│  │ Team │ │ Team │ │ Team │          │
│  └──────┘ └──────┘ └──────┘          │
│  (local   (local   (local             │
│   domain   domain   domain            │
│   focus)   focus)   focus)            │
└──────────────────────────────────────┘
```

| Advantage | Disadvantage |
|---|---|
| Close to business unit needs | Risk of inconsistency across BUs |
| Domain-specific expertise | Governance can be harder to enforce |
| Faster response to local needs | Potential duplication of effort |

### 10.3 Hybrid Model

Combines centralized governance and standards with distributed domain architects. This is the **most commonly recommended** approach:

- **Central team** owns: standards, governance, reference architectures, repository, ADM methodology
- **Distributed architects** own: domain-specific architecture, local stakeholder engagement, solution architecture

---

## 11. EA Governance Models

### 11.1 Advisory Model

The architecture function provides **recommendations only** — it has no enforcement authority. Architecture guidance is offered as best practice.

- **Best for**: Organizations new to EA; low maturity
- **Risk**: Architecture may be ignored; consistency suffers

### 11.2 Compliance Model

Architecture standards are **mandatory** and enforced through compliance reviews. Projects must demonstrate conformance.

- **Best for**: Mature organizations; regulated industries
- **Risk**: Can slow down delivery if governance is too rigid

### 11.3 Enabling Model

The architecture function actively **helps** project teams comply. It provides architects, templates, and hands-on support rather than just policing.

- **Best for**: Organizations seeking balance between governance and agility
- **Risk**: Requires significant investment in architecture resources

### 11.4 Strategic Model

Architecture is a **strategic function** reporting to the C-suite. It shapes business strategy, not just IT decisions.

- **Best for**: Organizations at the highest maturity; architecture drives transformation
- **Risk**: Requires deep business trust and executive commitment

---

## 12. Budgeting and Resourcing

Sustaining an architecture capability requires ongoing investment. TOGAF recognizes that without proper budgeting, the architecture function will atrophy.

### 12.1 Cost Categories

| Category | Examples |
|---|---|
| **People** | Architect salaries, training, certifications, contractors |
| **Tools** | Architecture modeling tools (e.g., Sparx EA, Archi), repository platforms |
| **Processes** | Governance administration, compliance review overhead, board operations |
| **Infrastructure** | Repository hosting, collaboration platforms, documentation systems |
| **External Resources** | Consultants, industry memberships, framework licenses |

### 12.2 Funding Models

| Model | Description |
|---|---|
| **Centrally Funded** | Architecture is funded as an overhead cost from the central IT budget |
| **Project-Funded** | Architecture costs are allocated to specific projects that consume architecture services |
| **Chargeback** | Business units pay for architecture services based on usage |
| **Hybrid** | Core capability is centrally funded; project-specific work is charged to projects |

### 12.3 Demonstrating Value

The architecture function must continuously demonstrate its value to justify ongoing investment:

- **Cost avoidance**: Reduced duplication through reuse
- **Risk reduction**: Fewer failed projects due to better architectural alignment
- **Speed**: Faster delivery through reusable patterns and building blocks
- **Strategic alignment**: Better alignment of IT investments with business strategy
- **Compliance**: Reduced regulatory risk through standardized approaches

---

## 13. Key Diagrams

### Architecture Capability Framework — Overview

```
┌──────────────────────────────────────────────────────────────┐
│              ARCHITECTURE CAPABILITY FRAMEWORK                │
├──────────────────────────────────────────────────────────────┤
│                                                               │
│  ┌─────────────────────────────────────────────────────────┐ │
│  │                  GOVERNANCE                              │ │
│  │  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐  │ │
│  │  │ Architecture │  │  Compliance   │  │  Architecture│  │ │
│  │  │    Board     │  │  Reviews      │  │  Contracts   │  │ │
│  │  └──────────────┘  └──────────────┘  └──────────────┘  │ │
│  └─────────────────────────────────────────────────────────┘ │
│                                                               │
│  ┌─────────────────────────────────────────────────────────┐ │
│  │                   PEOPLE                                 │ │
│  │  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐  │ │
│  │  │ Skills        │  │  Roles &     │  │  Maturity    │  │ │
│  │  │ Framework     │  │  Descriptions │  │  Assessment  │  │ │
│  │  └──────────────┘  └──────────────┘  └──────────────┘  │ │
│  └─────────────────────────────────────────────────────────┘ │
│                                                               │
│  ┌─────────────────────────────────────────────────────────┐ │
│  │                ORGANIZATION                              │ │
│  │  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐  │ │
│  │  │ EA Team       │  │  Budgeting   │  │  Org Model   │  │ │
│  │  │ Structure     │  │  & Resourcing│  │  (Central/   │  │ │
│  │  │              │  │              │  │  Federated)  │  │ │
│  │  └──────────────┘  └──────────────┘  └──────────────┘  │ │
│  └─────────────────────────────────────────────────────────┘ │
│                                                               │
│  ┌─────────────────────────────────────────────────────────┐ │
│  │              PROCESSES & TOOLS                           │ │
│  │  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐  │ │
│  │  │ Tailored ADM │  │  Repository  │  │  Architecture│  │ │
│  │  │ Processes     │  │  & Tooling   │  │  Principles  │  │ │
│  │  └──────────────┘  └──────────────┘  └──────────────┘  │ │
│  └─────────────────────────────────────────────────────────┘ │
│                                                               │
└──────────────────────────────────────────────────────────────┘
```

### Skills Framework Matrix

```
                       Proficiency Level Required
                  ┌──────────────────────────────────────┐
                  │ 1=Background  2=Awareness             │
                  │ 3=Knowledge   4=Expert                 │
                  └──────────────────────────────────────┘

  Skill Category    Chief    Enterprise  Solution  Program
                    Arch.    Architect   Architect Architect
  ────────────────  ─────    ──────────  ─────────  ────────
  Generic            ████       ███        ███       ███
  Business           ████       ███        ██        ███
  EA                 ████       ████       ███       ███
  PM                 ███        ███        ███       ████
  IT General         ███        ███        ███       ███
  Technical IT       ██         ██         ████      ██
  Legal              ███        ██         ██        ██

  █ = 1 proficiency level
```

---

## 14. Exam Tips

1. **Know the six conformance levels** cold: Irrelevant, Consistent, Compliant, Conformant, Fully Conformant, Non-Conformant. Exam questions will ask you to identify the correct level for a given scenario.

2. **Architecture Board composition and responsibilities** are frequently tested. Know that the Board is cross-functional, has binding authority, and can grant dispensations.

3. **Two types of Architecture Contracts**: Architecture Authority ↔ Development Team, and Architecture Function ↔ Business Users. Know the difference.

4. **Skills Framework**: Remember the seven skill categories (Generic, Business, EA, PM, IT General, Technical IT, Legal) and four proficiency levels (Background, Awareness, Knowledge, Expert).

5. **Chief Architect vs. Enterprise Architect vs. Solution Architect**: Know the skill profile differences — Chief Architect needs Expert in Generic/Business/EA; Solution Architect needs Expert in Technical IT.

6. **The Architecture Capability is established in the Preliminary Phase** — this is a very common exam question.

7. **Architecture Principles** have four components: Name, Statement, Rationale, Implications.

8. **Maturity models** help assess and improve the architecture practice — the goal is not always Level 5; the right level depends on the organization's needs.

9. **Non-Conformant** is the only "problem" conformance level. All others (including Irrelevant) are acceptable states.

10. **Compliance reviews** happen at key milestones — they are not one-time events.

---

## 15. Review Questions

### Question 1
**What is the primary purpose of the Architecture Capability Framework?**

A) To define the steps of the Architecture Development Method  
B) To provide resources for establishing and operating an architecture practice  
C) To classify architecture assets along a continuum  
D) To define the content metamodel for architecture deliverables  

<details>
<summary>Answer</summary>
**B) To provide resources for establishing and operating an architecture practice.**

The Architecture Capability Framework provides guidelines, templates, and reference materials for setting up and sustaining an architecture function within an organization.
</details>

---

### Question 2
**Which of the following is NOT a level of conformance defined by TOGAF?**

A) Consistent  
B) Compliant  
C) Compatible  
D) Conformant  

<details>
<summary>Answer</summary>
**C) Compatible.**

The six TOGAF conformance levels are: Irrelevant, Consistent, Compliant, Conformant, Fully Conformant, and Non-Conformant. "Compatible" is not one of them.
</details>

---

### Question 3
**Which conformance level indicates that a project has implemented all features of the architecture specification and all are in compliance?**

A) Compliant  
B) Conformant  
C) Fully Conformant  
D) Consistent  

<details>
<summary>Answer</summary>
**B) Conformant.**

Conformant means all features have been implemented and all are in compliance. Fully Conformant goes further — it includes additional features beyond the specification, all of which are also in compliance.
</details>

---

### Question 4
**What are the two types of Architecture Contracts defined by TOGAF?**

A) Internal contracts and external contracts  
B) Contracts between architecture authority and development teams, and contracts between architecture function and business users  
C) Design contracts and implementation contracts  
D) Vendor contracts and service contracts  

<details>
<summary>Answer</summary>
**B) Contracts between architecture authority and development teams, and contracts between architecture function and business users.**

These two contract types cover both the technical delivery relationship and the business service relationship.
</details>

---

### Question 5
**In the TOGAF Skills Framework, how many proficiency levels are defined?**

A) Three  
B) Four  
C) Five  
D) Six  

<details>
<summary>Answer</summary>
**B) Four.**

The four proficiency levels are: Background (1), Awareness (2), Knowledge (3), and Expert (4).
</details>

---

### Question 6
**Which role requires Expert-level proficiency in Technical IT Skills?**

A) Chief Architect  
B) Enterprise Architect  
C) Solution Architect  
D) Program Architect  

<details>
<summary>Answer</summary>
**C) Solution Architect.**

The Solution Architect needs Expert-level Technical IT Skills because they work directly with technology selection and solution design. The Chief Architect and Enterprise Architect need only Awareness in Technical IT.
</details>

---

### Question 7
**During which ADM phase is the Architecture Capability established?**

A) Phase A: Architecture Vision  
B) Phase B: Business Architecture  
C) Preliminary Phase  
D) Phase G: Implementation Governance  

<details>
<summary>Answer</summary>
**C) Preliminary Phase.**

The Preliminary Phase is where the organization establishes the architecture capability, including the Architecture Board, governance framework, skills, and repository.
</details>

---

### Question 8
**What is the role of the Architecture Board in granting dispensations?**

A) The Architecture Board cannot grant dispensations; only the CIO can  
B) The Architecture Board reviews requests for exceptions and may formally approve deviations from the architecture when justified  
C) Dispensations are automatically granted when a project is under budget  
D) Dispensations are only granted for external regulatory requirements  

<details>
<summary>Answer</summary>
**B) The Architecture Board reviews requests for exceptions and may formally approve deviations from the architecture when justified.**

The dispensation process is a formal governance mechanism managed by the Architecture Board to handle legitimate cases where full architecture compliance is not feasible.
</details>

---

### Question 9
**Which of the following are the four components of an Architecture Principle as recommended by TOGAF?**

A) Title, Description, Benefits, Constraints  
B) Name, Statement, Rationale, Implications  
C) Principle, Rule, Exception, Enforcement  
D) Objective, Scope, Criteria, Metrics  

<details>
<summary>Answer</summary>
**B) Name, Statement, Rationale, Implications.**

TOGAF defines these four standard elements for architecture principles: a Name (label), Statement (the principle), Rationale (why), and Implications (what it means in practice).
</details>

---

### Question 10
**Which skills category includes knowledge of GDPR, data privacy regulations, and contract law?**

A) Generic Skills  
B) Business Skills & Methods  
C) IT General Knowledge Skills  
D) Legal Environment  

<details>
<summary>Answer</summary>
**D) Legal Environment.**

The Legal Environment skill category covers laws, regulations, compliance requirements, data privacy, intellectual property, and contract law.
</details>

---

### Question 11
**What is the primary difference between "Compliant" and "Conformant" conformance levels?**

A) Compliant means fully implemented; Conformant means partially implemented  
B) Compliant means some features implemented and those are in compliance; Conformant means all features implemented and all are in compliance  
C) They are synonymous terms  
D) Compliant applies to business architecture; Conformant applies to technology architecture  

<details>
<summary>Answer</summary>
**B) Compliant means some features implemented and those are in compliance; Conformant means all features implemented and all are in compliance.**

This is a subtle but important distinction. Compliant = partial implementation, all in compliance. Conformant = full implementation, all in compliance.
</details>

---

### Question 12
**In a federated EA organizational model, what does the central team typically own?**

A) All architecture work for every business unit  
B) Standards, governance, and reference architectures  
C) Only the technology architecture domain  
D) Budget allocation for all IT projects  

<details>
<summary>Answer</summary>
**B) Standards, governance, and reference architectures.**

In a federated model, the central team owns cross-cutting concerns like standards and governance, while distributed teams own domain-specific architecture work within their business units.
</details>

---

### Question 13
**An organization's architecture team has documented processes, follows standardized practices, and has governance in place. Which maturity level does this represent?**

A) Level 1 — Initial  
B) Level 2 — Under Development  
C) Level 3 — Defined  
D) Level 4 — Managed  

<details>
<summary>Answer</summary>
**C) Level 3 — Defined.**

At Level 3, processes are documented, standardized, and consistently followed with governance in place. Level 4 adds metrics and quantitative management.
</details>

---

### Question 14
**Which organizational model for EA teams is most commonly recommended for balancing governance consistency with business unit responsiveness?**

A) Fully centralized model  
B) Fully decentralized model  
C) Hybrid (federated) model  
D) Outsourced model  

<details>
<summary>Answer</summary>
**C) Hybrid (federated) model.**

The hybrid model combines centralized governance and standards with distributed domain architects who work close to business units, balancing consistency with responsiveness.
</details>

---

### Question 15
**What should happen when a compliance review finds a project to be Non-Conformant?**

A) The project must be cancelled immediately  
B) The project should choose from: remediation, dispensation, architecture update, or risk acceptance  
C) The Architecture Board automatically loses jurisdiction  
D) The project continues with no action required  

<details>
<summary>Answer</summary>
**B) The project should choose from: remediation, dispensation, architecture update, or risk acceptance.**

Non-Conformance does not mean automatic cancellation. There are multiple resolution paths, each appropriate for different circumstances.
</details>

---

### Question 16
**Which of the following is NOT typically a responsibility of the Architecture Board?**

A) Writing application code for enterprise projects  
B) Reviewing and approving architecture deliverables  
C) Granting dispensations for non-conformance  
D) Resolving architecture-related conflicts  

<details>
<summary>Answer</summary>
**A) Writing application code for enterprise projects.**

The Architecture Board is a governance body. It reviews, approves, and directs — it does not perform hands-on development work.
</details>

---

### Question 17
**A Chief Architect needs Expert proficiency in which three skill categories?**

A) Generic, Business, Technical IT  
B) Generic, Business, Enterprise Architecture  
C) Enterprise Architecture, Technical IT, Legal Environment  
D) Business, PM, IT General Knowledge  

<details>
<summary>Answer</summary>
**B) Generic, Business, Enterprise Architecture.**

The Chief Architect needs Expert (Level 4) proficiency in Generic Skills, Business Skills & Methods, and Enterprise Architecture Skills — reflecting their role as a senior leader bridging business and architecture.
</details>

---

*Next Module: [08 — Architecture Governance →](../08-Architecture-Governance/README.md)*

---

*These materials are for exam preparation purposes. TOGAF is a registered trademark of The Open Group.*
