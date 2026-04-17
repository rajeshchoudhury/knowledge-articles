# The Architecture Development Method (ADM) — Comprehensive Overview

## Table of Contents

- [Introduction: What is the ADM?](#introduction-what-is-the-adm)
- [Why the ADM is the Core of TOGAF](#why-the-adm-is-the-core-of-togaf)
- [The ADM Cycle](#the-adm-cycle)
- [How the ADM Phases Relate to Each Other](#how-the-adm-phases-relate-to-each-other)
- [Inputs, Steps, and Outputs](#inputs-steps-and-outputs)
- [ADM Iteration Approaches](#adm-iteration-approaches)
- [ADM and the Enterprise Continuum](#adm-and-the-enterprise-continuum)
- [Adapting the ADM](#adapting-the-adm)
- [ADM Versioning: TOGAF 9.2 to TOGAF 10](#adm-versioning-togaf-92-to-togaf-10)
- [Key Deliverables, Artifacts, and Building Blocks](#key-deliverables-artifacts-and-building-blocks)
- [Exam Tips and Question Patterns](#exam-tips-and-question-patterns)
- [Review Questions](#review-questions)

---

## Introduction: What is the ADM?

The **Architecture Development Method (ADM)** is the step-by-step approach defined by TOGAF for developing and managing an enterprise architecture. It is the process component of the TOGAF Standard and provides a tested, repeatable method for developing architectures. The ADM establishes an architecture framework, develops architecture content, transitions from one architecture state to the next, and governs the realization of architectures.

The ADM is designed to address — but not limited to — the following:

- Business, Data, Application, and Technology architectures (the four architecture domains)
- The development of an architecture that enables the enterprise to meet its business goals
- The identification of transition architectures that incrementally deliver the target state
- Governance of the realization of architectures

The ADM is **iterative**, **cyclical**, and designed to be **adapted** to the needs of the organization. It is not a rigid, one-size-fits-all process. Rather, the TOGAF Standard explicitly encourages architects to tailor the ADM to fit within other enterprise frameworks such as business planning, project lifecycle management (e.g., PRINCE2, PMP), and operational frameworks (e.g., ITIL).

> **Exam Alert:** The ADM is the most heavily tested topic across both the TOGAF Foundation (Part 1) and Certified (Part 2) exams. You must understand every phase, its purpose, its inputs, and its outputs.

---

## Why the ADM is the Core of TOGAF

TOGAF consists of several components — the ADM, the Architecture Content Framework, the Enterprise Continuum, the Architecture Capability Framework, and ADM Guidelines and Techniques — but the ADM sits at the center of all of them. Here is why:

1. **The ADM is the process engine.** While the Content Framework defines *what* you produce and the Enterprise Continuum defines *where* you classify it, the ADM defines *how* you develop architecture. Every other TOGAF component feeds into or supports the ADM.

2. **All TOGAF deliverables are produced by the ADM.** The Architecture Content Framework describes catalogs, matrices, diagrams, and deliverables — all of which are outputs of specific ADM phases.

3. **The ADM drives governance.** Architecture governance is exercised at multiple ADM phases, ensuring that the architecture work remains aligned with enterprise goals.

4. **The ADM integrates the Enterprise Continuum.** At every phase, the ADM leverages and contributes to the Enterprise Continuum — the virtual repository of architecture assets ranging from generic foundations to organization-specific solutions.

5. **The ADM is the framework's recommended method.** Unlike some standards that offer multiple process choices, TOGAF positions the ADM as the singular recommended method, though it acknowledges that it should be adapted.

| TOGAF Component | Relationship to ADM |
|---|---|
| Architecture Content Framework | Defines the artifacts the ADM produces |
| Enterprise Continuum | Repository the ADM leverages and populates |
| Architecture Capability Framework | Establishes the organizational capability to execute the ADM |
| ADM Guidelines and Techniques | Provides supporting techniques for ADM phases |
| Architecture Governance | Governs the outputs and processes of the ADM |

---

## The ADM Cycle

The ADM is represented as a circular diagram with **Requirements Management** at the center and the phases arranged around it. The Preliminary Phase sits at the top, and the cycle proceeds clockwise.

```
                    ┌─────────────────────┐
                    │    Preliminary       │
                    │    Phase             │
                    └──────────┬──────────┘
                               │
                    ┌──────────▼──────────┐
                    │   Phase A:          │
          ┌─────── │   Architecture       │ ────────┐
          │        │   Vision             │         │
          │        └──────────┬──────────┘         │
          │                   │                     │
┌─────────▼───────┐ ┌────────▼─────────┐ ┌────────▼─────────┐
│  Phase H:       │ │                  │ │  Phase B:         │
│  Architecture   │ │   Requirements   │ │  Business         │
│  Change         │ │   Management     │ │  Architecture     │
│  Management     │ │   (CENTER)       │ │                   │
└─────────┬───────┘ │                  │ └────────┬─────────┘
          │        └──────────────────┘         │
          │                                      │
┌─────────▼───────┐                    ┌────────▼─────────┐
│  Phase G:       │                    │  Phase C:         │
│  Implementation │                    │  Information      │
│  Governance     │                    │  Systems          │
└─────────┬───────┘                    │  Architecture     │
          │                            └────────┬─────────┘
          │        ┌──────────────────┐         │
          │        │  Phase E:        │         │
┌─────────▼───────┐│  Opportunities  │┌────────▼─────────┐
│  Phase F:       ││  and            ││  Phase D:         │
│  Migration      │◄  Solutions      ►│  Technology       │
│  Planning       │└──────────────────┘│  Architecture     │
└─────────────────┘                    └──────────────────┘
```

### Summary of Each Phase

| Phase | Name | Purpose |
|---|---|---|
| **Preliminary** | Framework and Principles | Prepare the organization to execute architecture projects |
| **A** | Architecture Vision | Set the scope, constraints, and expectations; obtain approval |
| **B** | Business Architecture | Develop the Business Architecture (baseline and target) |
| **C** | Information Systems Architecture | Develop Data and Application Architectures |
| **D** | Technology Architecture | Develop the Technology Architecture |
| **E** | Opportunities and Solutions | Identify delivery vehicles and implementation projects |
| **F** | Migration Planning | Finalize a detailed Implementation and Migration Plan |
| **G** | Implementation Governance | Provide architectural oversight of the implementation |
| **H** | Architecture Change Management | Manage changes to the architecture in an orderly manner |
| **Requirements Management** | (Center) | Manage architecture requirements throughout the ADM cycle |

> **Exam Tip:** You will be asked to identify which phase produces a specific deliverable or addresses a specific concern. Memorize the phase names and their core purposes.

---

## How the ADM Phases Relate to Each Other

The phases of the ADM are not isolated; they feed into each other in a continuous cycle:

### Sequential Flow (Primary)

The primary flow is clockwise from Preliminary through Phase H. Each phase produces outputs that become inputs to the next phase:

- **Preliminary** establishes the capability and principles → feeds **Phase A**
- **Phase A** defines the vision and scope → feeds **Phases B, C, D**
- **Phases B, C, D** develop domain architectures → feed **Phase E**
- **Phase E** identifies implementation projects → feeds **Phase F**
- **Phase F** creates the migration plan → feeds **Phase G**
- **Phase G** governs implementation → feeds **Phase H**
- **Phase H** manages ongoing changes → can trigger a new **Phase A** cycle

### Requirements Management (Continuous)

Requirements Management is at the center because it is not a discrete phase that occurs once. It operates continuously throughout all phases. Any phase can generate, clarify, modify, or retire requirements, and those changes are managed centrally.

### Feedback Loops

The ADM supports jumping back to earlier phases when:

- A gap analysis in Phase B reveals that the vision in Phase A needs to be revised
- Implementation issues in Phase G require re-examination of the migration plan from Phase F
- Change requests in Phase H trigger a new architecture cycle starting at Phase A (or even Preliminary if the organizational capability has changed)

### Phase Groupings

The ADM phases can be conceptually grouped:

| Group | Phases | Focus |
|---|---|---|
| **Architecture Context** | Preliminary, A | Set up capability, define vision |
| **Architecture Definition** | B, C, D | Define the four architecture domains |
| **Transition Planning** | E, F | Plan the journey from baseline to target |
| **Architecture Realization** | G, H | Oversee implementation and manage change |
| **Continuous** | Requirements Management | Runs throughout all phases |

---

## Inputs, Steps, and Outputs

Every ADM phase follows a consistent structure of **Inputs**, **Steps**, and **Outputs**. This is a fundamental structural concept in the ADM.

### Inputs

Inputs are the information, documents, and artifacts that a phase requires to begin its work. They come from:

- Previous ADM phases (e.g., the Architecture Vision from Phase A is an input to Phase B)
- External sources (e.g., business strategy documents, regulatory requirements)
- The Architecture Repository (e.g., reference models, standards, previously developed architecture content)

### Steps

Steps are the activities performed within a phase. They are listed in a recommended order but are not strictly sequential. The TOGAF Standard notes that the order of steps within a phase may vary depending on the situation.

### Outputs

Outputs are the deliverables, artifacts, and updated repository content produced by the phase. These outputs typically become inputs to subsequent phases.

### The Pattern

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│   INPUTS    │ ──► │   STEPS     │ ──► │  OUTPUTS    │
│             │     │             │     │             │
│ - Documents │     │ - Activity 1│     │ - Deliverble│
│ - Artifacts │     │ - Activity 2│     │ - Artifacts │
│ - External  │     │ - Activity 3│     │ - Updated   │
│   reference │     │ - ...       │     │   repository│
└─────────────┘     └─────────────┘     └─────────────┘
```

> **Exam Tip:** Part 2 (Certified) questions frequently present a scenario and ask you to identify the correct input or output for a given phase. Understanding the input/output chains across phases is critical.

---

## ADM Iteration Approaches

The ADM is designed to be used iteratively. TOGAF defines several iteration styles:

### 1. Architecture Landscape Iteration

This is the broadest iteration style. It covers the full ADM cycle (Preliminary through Phase H) and is used to develop the **Strategic Architecture** that spans the entire enterprise.

- **Scope:** Enterprise-wide
- **Depth:** High-level, strategic
- **Cycle Time:** Typically 12–24 months
- **Purpose:** Establish the overall direction for the enterprise architecture, identify major work packages, and align the architecture landscape with business strategy

### 2. Architecture Capability Iteration

This iteration focuses on establishing or evolving the **architecture capability** within the organization. It primarily exercises the Preliminary Phase and, to a lesser extent, Phase A.

- **Scope:** The architecture practice itself
- **Depth:** Detailed for governance, tools, processes, skills
- **Cycle Time:** Ongoing, triggered by organizational changes
- **Purpose:** Mature the organization's ability to perform enterprise architecture work

### 3. Transition Planning Iteration

This iteration focuses on the phases that deal with moving from the baseline to the target: primarily Phases E and F, with some involvement of Phases G and H.

- **Scope:** Implementation and migration planning
- **Depth:** Detailed, project-level
- **Cycle Time:** Aligned with project and program cycles
- **Purpose:** Develop detailed implementation plans, resolve dependencies between work packages, ensure that the transition from current to target state is well-orchestrated

### 4. Architecture Development Iteration (Segment/Capability)

This iteration focuses on the architecture definition phases (B, C, D) for a specific **segment** of the enterprise or a specific **capability**.

- **Scope:** A segment or capability within the enterprise
- **Depth:** Detailed, including baseline and target states
- **Cycle Time:** Typically 3–6 months
- **Purpose:** Develop the detailed architecture for a specific area (e.g., Customer Relationship Management, Human Resources)

| Iteration Style | Primary Phases | Scope | Typical Cycle Time |
|---|---|---|---|
| Architecture Landscape | All (Prelim – H) | Enterprise-wide | 12–24 months |
| Architecture Capability | Preliminary, A | Architecture practice | Ongoing |
| Transition Planning | E, F, (G, H) | Implementation planning | Aligned with programs |
| Architecture Development | A, B, C, D | Segment or capability | 3–6 months |

> **Exam Tip:** Expect questions that describe a scenario and ask which iteration approach is most appropriate. Pay attention to cues like "establish governance" (Capability), "enterprise-wide direction" (Landscape), or "plan the migration" (Transition Planning).

---

## ADM and the Enterprise Continuum

The **Enterprise Continuum** is a classification mechanism (a "virtual repository") for architecture and solution assets. It provides a context for understanding and leveraging architecture assets at every ADM phase.

### How the ADM Interacts with the Enterprise Continuum

1. **Leveraging existing assets:** At the start of each ADM phase (particularly B, C, D), the architect searches the Enterprise Continuum for reusable architecture and solution building blocks. This helps avoid reinventing the wheel.

2. **Populating the continuum:** As the ADM produces outputs — reference architectures, standards, patterns, building blocks — these are classified and stored in the Enterprise Continuum for future reuse.

3. **The Architecture Repository** is the physical manifestation that supports the Enterprise Continuum. It stores the actual architecture artifacts that the Enterprise Continuum classifies.

### The Continuum Spectrum

```
Foundation ──► Common Systems ──► Industry ──► Organization-Specific
(most generic)                                 (most specific)

Examples:
TOGAF TRM        III-RM          BIAN (Banking)    Your company's
                                 HL7 (Healthcare)  specific architecture
```

At every ADM phase, the architect moves along this spectrum:

- **Phase B–D:** Start from generic reference models and specialize toward the organization's needs
- **Phase E–F:** Identify solutions that may come from any point on the continuum
- **Phase H:** Changes may result in new organization-specific content being added

> **Exam Tip:** The Enterprise Continuum is *not* a repository — it is a classification scheme. The Architecture Repository is the actual storage mechanism. This distinction is frequently tested.

---

## Adapting the ADM

One of the most important characteristics of the ADM is that it is explicitly designed to be **adapted** (also called "tailored") to the needs of the organization. The TOGAF Standard states that the ADM should be adapted to handle a variety of different usage scenarios, including different:

### Reasons for Adaptation

1. **Organizational maturity:** A startup will use the ADM differently than a large financial institution
2. **Scope of effort:** A full enterprise architecture engagement differs from a focused application modernization project
3. **Integration with existing processes:** The ADM must coexist with an organization's existing project management methodology, governance framework, and change management processes
4. **Industry-specific requirements:** Healthcare, financial services, and government organizations may have regulatory requirements that demand additional steps or artifacts

### How to Adapt

- **Modify the phase order:** While the standard sequence is Preliminary → A → B → C → D → E → F → G → H, organizations may alter this order (e.g., running B and C in parallel)
- **Adjust the level of detail:** Some phases may be performed in great detail while others are summarized, depending on the scope
- **Add or remove steps:** Steps within each phase can be added, removed, or modified
- **Integrate with other frameworks:** The ADM can be combined with SAFe, ITIL, COBIT, or other process frameworks
- **Define enterprise-specific deliverables:** Organizations may add deliverables beyond what TOGAF suggests

### The Tailored Architecture Framework

The Preliminary Phase is where the ADM is formally tailored. The output "Tailored Architecture Framework" documents how the organization has adapted the ADM, including which deliverables are mandatory, which are optional, and how phases relate to the organization's own project lifecycle.

> **Exam Tip:** Questions about adapting the ADM are common on the Part 2 exam. The key takeaway is that the ADM is *meant* to be adapted, and the Preliminary Phase is where this tailoring is formalized. However, one should understand the full standard ADM before adapting it.

---

## ADM Versioning: TOGAF 9.2 to TOGAF 10

TOGAF 10 (officially called **"The TOGAF Standard, 10th Edition"**) introduced a significant **structural** reorganization while keeping the core ADM largely consistent. Understanding the key differences is important for the current exam.

### Key Changes in TOGAF 10

| Aspect | TOGAF 9.2 | TOGAF 10 |
|---|---|---|
| **Document structure** | Single monolithic document | Modular structure (TOGAF Fundamental Content + TOGAF Series Guides) |
| **ADM core** | Part II of the TOGAF document | Part of TOGAF Fundamental Content |
| **ADM phases** | Same 8 phases + Preliminary + Req. Mgmt | Same 8 phases + Preliminary + Req. Mgmt (unchanged) |
| **Guidelines and Techniques** | Embedded in the standard | Some moved to separate Series Guides |
| **Architecture Content Framework** | Part IV | Remains part of Fundamental Content |
| **Reference Models (TRM, III-RM)** | Included in the standard | Moved to TOGAF Series Guides |
| **Naming** | "TOGAF 9.2" or "TOGAF Version 9.2" | "The TOGAF Standard, 10th Edition" |
| **Certification** | TOGAF 9 Certified | TOGAF Enterprise Architecture Part 1 / Part 2 |

### What Stayed the Same

- The ADM cycle and its phases remain fundamentally unchanged
- The concept of Inputs, Steps, Outputs for each phase
- Requirements Management at the center
- The Enterprise Continuum concept
- Architecture Building Blocks (ABBs) and Solution Building Blocks (SBBs)
- Architecture governance principles

### What Changed

- **Modularity:** TOGAF 10 separates "Fundamental Content" (the core that changes slowly) from "Series Guides" (guidance that can be updated independently). This means the ADM core is more stable, and supplementary guidance (like how to apply TOGAF in Agile contexts) can evolve faster.
- **Series Guides:** New guides were introduced for topics like Security Architecture, Digital Transformation, and Agile methods, allowing the TOGAF ecosystem to grow without modifying the core standard.
- **Terminology Refinements:** Some terms were clarified or updated, though the fundamental vocabulary remains consistent.

> **Exam Tip:** The exam is based on "The TOGAF Standard, 10th Edition." Know the modular structure (Fundamental Content vs. Series Guides). The ADM phases themselves have not materially changed — the reorganization is primarily structural.

---

## Key Deliverables, Artifacts, and Building Blocks

Understanding the difference between deliverables, artifacts, and building blocks is critical for the exam.

### Definitions

| Term | Definition |
|---|---|
| **Deliverable** | A work product that is contractually specified and formally reviewed, agreed, and signed off by stakeholders. Deliverables represent the output of projects and are archived. |
| **Artifact** | A more granular architecture work product that describes an aspect of the architecture. Artifacts are generally classified as catalogs, matrices, or diagrams. |
| **Building Block** | A (potentially reusable) component of business, IT, or architectural capability that can be combined with other building blocks to deliver architectures and solutions. |

### Building Block Types

- **Architecture Building Blocks (ABBs):** Describe required capability and shape the specification of Solution Building Blocks. They are defined in the architecture definition phases (B, C, D).
- **Solution Building Blocks (SBBs):** Represent components that will be used to implement the required capability. They are defined in the transition planning phases (E, F) and refined during implementation (G).

### Key Deliverables by Phase

| Phase | Key Deliverables |
|---|---|
| **Preliminary** | Organizational Model for EA, Tailored Architecture Framework, Architecture Principles, Architecture Repository (initial) |
| **A** | Architecture Vision, Statement of Architecture Work (approved), Communications Plan |
| **B** | Architecture Definition Document (Business Architecture section), Architecture Requirements Specification (Business) |
| **C** | Architecture Definition Document (Data and Application Architecture sections), Architecture Requirements Specification (IS) |
| **D** | Architecture Definition Document (Technology Architecture section), Architecture Requirements Specification (Technology) |
| **E** | Implementation and Migration Strategy, Transition Architectures |
| **F** | Implementation and Migration Plan, Finalized Architecture Definition Document, Finalized Transition Architectures |
| **G** | Architecture Contract, Compliance Assessments |
| **H** | Architecture Updates, Changes to Architecture Framework, New Request for Architecture Work (if needed) |
| **Req. Mgmt** | Architecture Requirements Specification (updated throughout) |

### Key Artifact Types

| Type | Description | Examples |
|---|---|---|
| **Catalogs** | Lists of building blocks of a specific type | Technology Standards Catalog, Application Portfolio Catalog, Business Service Catalog |
| **Matrices** | Show relationships between building blocks | Application/Technology Matrix, Stakeholder Map Matrix, Role/Function Matrix |
| **Diagrams** | Graphical representations of architecture | Business Footprint Diagram, Application Communication Diagram, Network Diagram |

> **Exam Tip:** Know which deliverables belong to which phase. Also, understand the distinction between deliverables (formally signed off), artifacts (catalogs, matrices, diagrams), and building blocks (ABBs and SBBs).

---

## Exam Tips and Question Patterns

### Part 1 (Foundation) Patterns

1. **"Which phase produces X?"** — You will be asked to identify the phase that produces a specific deliverable or artifact.
2. **"What is the purpose of Phase X?"** — Direct recall of phase objectives.
3. **"Which of the following is NOT an output of Phase X?"** — Requires knowing the outputs of each phase precisely.
4. **"Requirements Management is..."** — Expect questions about its role as a continuous, central process.
5. **"The ADM is best described as..."** — Iterative, cyclical, adaptable method.

### Part 2 (Certified) Patterns

1. **Scenario-based:** "An architect is at the point where they need to identify implementation projects. Which phase are they in?" (Phase E)
2. **Best practice:** "The architecture team has been asked to tailor the ADM. In which phase should this be done?" (Preliminary)
3. **Ordering:** "Which sequence correctly represents the ADM phases?" (Prelim → A → B → C → D → E → F → G → H, with Requirements Management throughout)
4. **Input/Output chains:** "The Architecture Vision is an input to which phases?"
5. **Iteration:** "An organization wants to establish its architecture governance. Which iteration approach should it use?" (Architecture Capability)

### Key Memory Aids

- **Phases B, C, D** are the "Architecture Definition" phases — they produce the architecture content
- **Phases E, F** are the "Planning" phases — they produce the implementation roadmap
- **Phase G** is about **Governance** during implementation (not doing the implementation itself)
- **Phase H** is about **Change** — managing the ongoing evolution
- **Requirements Management** is the **only** phase that is continuous and sits in the center
- The **Statement of Architecture Work** is approved in **Phase A** — it is like a project charter for the architecture effort

---

## Review Questions

### Question 1
**Which of the following best describes the Architecture Development Method (ADM)?**

A) A one-time, sequential process for developing enterprise architecture
B) An iterative method for developing and managing enterprise architecture that can be adapted to organizational needs
C) A framework for classifying architecture assets from generic to specific
D) A governance model for overseeing architecture implementation

**Answer: B** — The ADM is iterative, cyclical, and explicitly designed to be adapted. Option C describes the Enterprise Continuum. Option D describes Architecture Governance, which is a component but not the ADM itself.

---

### Question 2
**Requirements Management in the ADM is best described as:**

A) A phase that occurs between Phase D and Phase E
B) A phase that occurs only at the beginning of the ADM cycle
C) A continuous process that operates throughout all ADM phases and is at the center of the ADM cycle
D) A phase that is only relevant to Phases B, C, and D

**Answer: C** — Requirements Management is central and continuous, depicted at the center of the ADM cycle diagram.

---

### Question 3
**In which phase is the ADM formally tailored to meet the needs of the organization?**

A) Phase A: Architecture Vision
B) Phase H: Architecture Change Management
C) Preliminary Phase
D) Requirements Management

**Answer: C** — The Preliminary Phase is where the organization tailors the TOGAF framework and ADM to its needs, producing the Tailored Architecture Framework.

---

### Question 4
**The Statement of Architecture Work is a key deliverable of which phase?**

A) Preliminary Phase
B) Phase A: Architecture Vision
C) Phase B: Business Architecture
D) Phase E: Opportunities and Solutions

**Answer: B** — The Statement of Architecture Work is created and approved in Phase A. It serves as the project charter for the architecture development effort.

---

### Question 5
**Which iteration approach would an organization use to mature its architecture governance and team capabilities?**

A) Architecture Landscape iteration
B) Architecture Development iteration
C) Transition Planning iteration
D) Architecture Capability iteration

**Answer: D** — Architecture Capability iteration focuses on establishing and evolving the architecture capability, including governance, processes, tools, and skills.

---

### Question 6
**The Enterprise Continuum is best described as:**

A) A physical repository that stores architecture artifacts
B) A classification scheme for architecture and solution assets, ranging from generic to organization-specific
C) A governance framework for managing architecture changes
D) The collection of all ADM phases and their deliverables

**Answer: B** — The Enterprise Continuum is a classification scheme (virtual repository), not a physical repository. The Architecture Repository is the physical storage.

---

### Question 7
**Which phases are considered the "Architecture Definition" phases?**

A) Preliminary, A, B
B) B, C, D
C) E, F, G
D) A, B, C, D

**Answer: B** — Phases B (Business), C (Information Systems), and D (Technology) are the architecture definition phases where the actual architecture content is developed.

---

### Question 8
**What is the difference between Architecture Building Blocks (ABBs) and Solution Building Blocks (SBBs)?**

A) ABBs are technology-specific; SBBs are vendor-neutral
B) ABBs describe required capability at a specification level; SBBs represent actual components for implementation
C) ABBs are produced in Phase E; SBBs are produced in Phase B
D) There is no difference; the terms are interchangeable

**Answer: B** — ABBs define what capability is needed (specification-level), while SBBs define how that capability is delivered (implementation-level).

---

### Question 9
**In TOGAF 10, what is the relationship between Fundamental Content and Series Guides?**

A) Fundamental Content replaces Series Guides
B) Series Guides contain the ADM phases; Fundamental Content provides supplementary guidance
C) Fundamental Content contains the core TOGAF standard including the ADM; Series Guides provide supplementary guidance that can be updated independently
D) They are two names for the same thing

**Answer: C** — TOGAF 10's modular structure separates the stable core (Fundamental Content) from independently updatable guidance (Series Guides).

---

### Question 10
**Which of the following is NOT a reason for adapting the ADM?**

A) To align with the organization's existing project management methodology
B) To remove the Requirements Management process entirely
C) To accommodate industry-specific regulatory requirements
D) To adjust the level of detail based on the scope of the effort

**Answer: B** — Requirements Management is a fundamental part of the ADM and should not be removed. The other options are all valid reasons for adapting the ADM.

---

### Question 11
**An architect needs to create a detailed implementation plan that sequences work packages and identifies dependencies. Which ADM phase addresses this?**

A) Phase D: Technology Architecture
B) Phase E: Opportunities and Solutions
C) Phase F: Migration Planning
D) Phase G: Implementation Governance

**Answer: C** — Phase F (Migration Planning) is where the detailed Implementation and Migration Plan is created, sequencing work packages and resolving dependencies.

---

### Question 12
**Phase G of the ADM is primarily concerned with:**

A) Developing the technology architecture
B) Identifying opportunities for reuse of existing architecture assets
C) Providing architectural oversight during the implementation of change projects
D) Managing changes to the architecture after implementation is complete

**Answer: C** — Phase G provides architectural oversight (governance) during implementation. Phase D develops the technology architecture, Phase E identifies opportunities, and Phase H manages post-implementation changes.

---

### Question 13
**Which of the following correctly lists the ADM phases in order?**

A) Preliminary → A → B → D → C → E → F → G → H
B) A → Preliminary → B → C → D → E → F → G → H
C) Preliminary → A → B → C → D → E → F → G → H
D) Preliminary → A → C → B → D → E → F → G → H

**Answer: C** — The correct sequence is Preliminary → A (Vision) → B (Business) → C (Information Systems) → D (Technology) → E (Opportunities) → F (Migration) → G (Implementation Governance) → H (Change Management).

---

### Question 14
**Artifacts in TOGAF are classified into which three types?**

A) Deliverables, Building Blocks, and Constraints
B) Catalogs, Matrices, and Diagrams
C) Principles, Standards, and Guidelines
D) Strategies, Blueprints, and Roadmaps

**Answer: B** — TOGAF classifies artifacts into Catalogs (lists), Matrices (relationships), and Diagrams (graphical representations).

---

### Question 15
**An organization is conducting its first enterprise-wide architecture effort to set the strategic direction. Which iteration approach is most appropriate?**

A) Architecture Capability iteration
B) Architecture Development iteration
C) Architecture Landscape iteration
D) Transition Planning iteration

**Answer: C** — Architecture Landscape iteration covers the full ADM cycle at the enterprise level and is used to establish the strategic architecture direction.

---

### Question 16
**What is the role of Phase H in the ADM?**

A) To implement the architecture changes identified in Phase G
B) To ensure the architecture responds to changes in the business and technology environment in a controlled manner
C) To identify and evaluate candidate building blocks for the architecture
D) To produce the final version of the Architecture Requirements Specification

**Answer: B** — Phase H (Architecture Change Management) ensures that the architecture remains relevant and responds to changes in an orderly manner. It may trigger a new ADM cycle if significant changes are needed.

---

### Question 17
**Which of the following statements about the ADM is TRUE?**

A) The ADM must be followed exactly as defined in the TOGAF Standard without any modifications
B) Each phase of the ADM must be completed before the next phase can begin
C) The ADM provides a generic method that is intended to be tailored by the adopting organization
D) The ADM applies only to IT architecture and does not address business concerns

**Answer: C** — The ADM is designed to be tailored (adapted). It is not rigid (A), phases can overlap and iterate (B), and it addresses all four architecture domains including business (D).

---

*Next: [Preliminary Phase →](../03-ADM-Phases/01-Preliminary-Phase.md)*
