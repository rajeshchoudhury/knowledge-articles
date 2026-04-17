# TOGAF 10 Comprehensive Cheat Sheet

> Quick reference for TOGAF 10 certification exam preparation.
> All key concepts in compact, scannable tables.

---

## 1. ADM Phases — One-Page Summary

| Phase | Name | Objective | Key Inputs | Key Outputs |
|-------|------|-----------|------------|-------------|
| **Preliminary** | Preparation | Define architecture capability, principles, governance, tailor framework | Business strategy, existing frameworks, governance requirements | Architecture Principles, Tailored Framework, Org Model for EA |
| **A** | Architecture Vision | Develop high-level vision, secure stakeholder buy-in, get approval | Request for Architecture Work, Principles, Business goals | Architecture Vision, Statement of Architecture Work, Stakeholder Map |
| **B** | Business Architecture | Develop baseline & target Business Architecture | Architecture Vision, Principles, Business strategy | Business Architecture (B/T), Gap Analysis, Architecture Roadmap components |
| **C** | Information Systems Architectures | Develop baseline & target Data and Application Architectures | Business Architecture, Principles | Data & App Architectures (B/T), Gap Analysis, Roadmap components |
| **D** | Technology Architecture | Develop baseline & target Technology Architecture | Data & App Architectures, Principles | Technology Architecture (B/T), Gap Analysis, Architecture Definition Document (complete) |
| **E** | Opportunities & Solutions | Identify implementation projects, create Transition Architectures, consolidate roadmap | Architecture Definition Document, all Gap Analyses | Architecture Roadmap, Transition Architectures, Implementation Strategy |
| **F** | Migration Planning | Finalize Implementation & Migration Plan, prioritize projects | Architecture Roadmap, Transition Architectures | Implementation & Migration Plan (final), Finalized Roadmap |
| **G** | Implementation Governance | Govern implementation, ensure compliance | Impl. & Migration Plan, Architecture Contracts | Signed Contracts, Compliance Assessments, Implemented solutions |
| **H** | Architecture Change Management | Manage ongoing architecture changes post-deployment | Change requests, Compliance reviews, Deployed arch. | Architecture updates, new Request for Architecture Work (if needed) |
| **RM** | Requirements Management | Manage requirements across all phases (continuous, at center) | Requirements from all phases | Architecture Requirements Specification (continuously updated) |

---

## 2. All TOGAF Deliverables Mapped to Phases

| Deliverable | Primary Phase(s) |
|-------------|-----------------|
| Architecture Principles | Preliminary |
| Tailored Architecture Framework | Preliminary |
| Organizational Model for Enterprise Architecture | Preliminary |
| Request for Architecture Work | Preliminary → Phase A |
| Architecture Vision | Phase A |
| Statement of Architecture Work | Phase A |
| Communications Plan | Phase A |
| Architecture Definition Document | Phases B, C, D (built incrementally) |
| Architecture Requirements Specification | Phases B–H, RM (updated continuously) |
| Architecture Roadmap (components) | Phases B, C, D (incremental) |
| Architecture Roadmap (consolidated) | Phase E |
| Architecture Roadmap (finalized) | Phase F |
| Transition Architectures | Phase E (created), Phase F (finalized) |
| Implementation & Migration Strategy | Phase E |
| Implementation & Migration Plan | Phase E (initial), Phase F (finalized) |
| Architecture Building Blocks (ABBs) | Phases B, C, D |
| Solution Building Blocks (SBBs) | Phases E, F |
| Architecture Contracts | Phase G |
| Compliance Assessments | Phase G |
| Implementation Governance Model | Phase G |
| Change Requests | Phase H |

---

## 3. All Artifacts Mapped to Phases

### Catalogs

| Catalog | Phase |
|---------|-------|
| Organization/Actor Catalog | B |
| Driver/Goal/Objective Catalog | B |
| Role Catalog | B |
| Business Service/Function Catalog | B |
| Location Catalog | B |
| Process/Event/Control/Product Catalog | B |
| Contract/Measure Catalog | B |
| Data Entity/Data Component Catalog | C (Data) |
| Application Portfolio Catalog | C (App) |
| Interface Catalog | C (App) |
| Technology Standards Catalog | D |
| Technology Portfolio Catalog | D |

### Matrices

| Matrix | Phase |
|--------|-------|
| Business Interaction Matrix | B |
| Actor/Role Matrix | B |
| Data Entity/Business Function Matrix (CRUD) | C (Data) |
| Application/Data Matrix | C (Data) |
| Application/Organization Matrix | C (App) |
| Role/Application Matrix | C (App) |
| Application/Function Matrix | C (App) |
| Application Interaction Matrix | C (App) |
| Application/Technology Matrix | D |

### Diagrams

| Diagram | Phase |
|---------|-------|
| Business Footprint Diagram | B |
| Business Service/Information Diagram | B |
| Functional Decomposition Diagram | B |
| Product Lifecycle Diagram | B |
| Conceptual Data Diagram | C (Data) |
| Logical Data Diagram | C (Data) |
| Data Dissemination Diagram | C (Data) |
| Data Security Diagram | C (Data) |
| Data Migration Diagram | C (Data) |
| Data Lifecycle Diagram | C (Data) |
| Application Communication Diagram | C (App) |
| Application and User Location Diagram | C (App) |
| Application Use-Case Diagram | C (App) |
| Enterprise Manageability Diagram | C (App) |
| Process/Application Realization Diagram | C (App) |
| Software Engineering Diagram | C (App) |
| Application Migration Diagram | C (App) |
| Software Distribution Diagram | C (App) |
| Environments and Locations Diagram | D |
| Platform Decomposition Diagram | D |
| Processing Diagram | D |
| Networked Computing/Hardware Diagram | D |
| Communications Engineering Diagram | D |

---

## 4. Key Definitions (30+ Terms)

| Term | Definition |
|------|-----------|
| Enterprise | Highest-level description of an organization; any collection of organizations with common goals |
| Architecture | Formal description of a system; the structure of components and their interrelationships |
| Enterprise Architecture | Principles, methods, and models for design/realization of an enterprise's structure, processes, IS, and infrastructure |
| ADM | Architecture Development Method — iterative, cyclic method at the core of TOGAF |
| Architecture Domain | The four areas: Business, Data, Application, Technology |
| Baseline Architecture | The existing "as-is" architecture |
| Target Architecture | The desired "to-be" future architecture |
| Transition Architecture | Intermediate architecture state between baseline and target |
| Gap | A difference between baseline and target architectures |
| Architecture Vision | High-level aspirational view of the target; created in Phase A |
| Building Block | Reusable component of enterprise capability |
| ABB | Architecture Building Block — defines *what* capability is needed |
| SBB | Solution Building Block — defines *how* the capability is realized |
| Stakeholder | Individual/group with an interest (concern) in the system |
| Concern | An interest in a system relevant to stakeholders |
| View | Representation of a system from a set of related concerns |
| Viewpoint | Template/specification for constructing a view |
| Architecture Principle | Qualitative statement of intent that guides architecture decisions |
| Enterprise Continuum | Classification mechanism from generic to organization-specific |
| Architecture Repository | Structured storage for all architecture outputs |
| Architecture Landscape | Representation of deployed architecture at Strategic/Segment/Capability levels |
| SIB | Standards Information Base — repository of applicable standards |
| Reference Library | Repository of guidelines, templates, and patterns |
| Governance Log | Record of governance decisions, compliance, and contracts |
| Architecture Board | Governance body overseeing architecture decisions and compliance |
| Architecture Contract | Formal agreement governing architecture deliverables and compliance |
| Compliance Review | Formal assessment of implementation conformance to architecture |
| Dispensation | Formal exception from architecture compliance requirements |
| Capability | An ability an organization possesses, combining people, processes, technology |
| Business Scenario | Technique for describing business problems to derive architecture requirements |
| Content Metamodel | Formal definition of entity types and relationships in architecture descriptions |
| Work Package | A set of actions to realize part of the architecture |
| Architecture Roadmap | Prioritized list of work packages from baseline to target |

---

## 5. Compliance Levels Summary

| Level | Meaning | Key Distinction |
|-------|---------|-----------------|
| **Irrelevant** | No features in common with spec | Spec doesn't apply |
| **Consistent** | Some common features; those follow spec | Partial overlap, no conflict |
| **Compliant** | All implemented features follow spec, but spec not fully covered | Implementation is a **subset** of spec |
| **Conformant** | All spec features implemented, may have extras | Spec is **fully covered** |
| **Fully Conformant** | 1:1 correspondence between spec and implementation | Perfect match |
| **Non-Conformant** | Implementation **conflicts** with spec | The only negative level |

> **Memory Aid:** Compliance levels go from "doesn't apply" → "partial match" → "subset" → "superset" → "exact match" → "conflict"

---

## 6. Architecture Repository Components

| Component | Description | Contents |
|-----------|-------------|----------|
| **Architecture Metamodel** | Defines structure of architecture content | Entity types, attributes, relationships |
| **Architecture Capability** | Supports the architecture function itself | Roles, processes, governance structures, maturity assessments |
| **Architecture Landscape** | Actual deployed architectures | Strategic, Segment, and Capability level views |
| **Standards Information Base** | Applicable standards | Industry standards, mandated products, regulatory requirements |
| **Reference Library** | Reusable reference materials | Templates, patterns, guidelines, models |
| **Governance Log** | Record of governance activity | Decisions, compliance assessments, dispensations, contracts |

---

## 7. Enterprise Continuum Spectrum

```
GENERIC ◄──────────────────────────────────────────► SPECIFIC

Architecture   Foundation → Common Systems → Industry → Organization-Specific
Continuum      Arch.        Architectures    Arch.      Architectures

Solutions      Foundation → Common Systems → Industry → Organization-Specific
Continuum      Solutions    Solutions        Solutions   Solutions

Examples:      TRM          III-RM           Banking     Your Company's
                                             Reference   Enterprise Arch.
                                             Model
```

---

## 8. Building Blocks Comparison (ABB vs SBB)

| Aspect | ABB (Architecture BB) | SBB (Solution BB) |
|--------|----------------------|-------------------|
| **Defines** | *What* is needed | *How* it is realized |
| **Awareness** | Technology-aware | Product/vendor-aware |
| **Created in** | Phases B, C, D | Phases E, F |
| **Nature** | Requirements-driven | Implementation-driven |
| **Example** | "Relational data store with ACID support" | "PostgreSQL 15 Enterprise" |
| **Granularity** | Abstract capability | Concrete product/solution |
| **Reusability** | High — defines patterns | Variable — depends on product |

---

## 9. Stakeholder Management Techniques

| Technique | Description |
|-----------|-------------|
| **Power/Interest Grid** | Classify stakeholders by power (influence) and interest level |
| **Stakeholder Map Matrix** | Comprehensive list of stakeholders with concerns, influence, and communication needs |
| **Communication Plan** | Defines messages, channels, frequency, and format for each stakeholder group |
| **Business Scenarios** | Engage stakeholders through real business problems to discover requirements |
| **RACI Matrix** | Clarify who is Responsible, Accountable, Consulted, Informed for each decision |

### Power/Interest Grid Actions

| | High Interest | Low Interest |
|---|---|---|
| **High Power** | Manage Closely (key players) | Keep Satisfied |
| **Low Power** | Keep Informed | Monitor |

---

## 10. Risk Management Approach

| Element | Description |
|---------|-------------|
| **Initial Risk Level** | Risk before any mitigation |
| **Residual Risk Level** | Risk after mitigation actions applied |
| **Effect Classification** | Catastrophic → Critical → Marginal → Negligible |
| **Frequency Classification** | Frequent → Likely → Occasional → Seldom → Unlikely |
| **Risk Matrix** | Plot Effect vs Frequency to prioritize |
| **Risk Mitigation** | Actions to reduce probability or impact |
| **Risk Register** | Maintained in Architecture Repository (Governance Log) |

---

## 11. Key Differences: TOGAF 9.2 vs TOGAF 10

| Aspect | TOGAF 9.2 | TOGAF 10 |
|--------|-----------|----------|
| **Structure** | Single monolithic document | Split into TOGAF Standard (normative) + TOGAF Library (non-normative) |
| **Naming** | "TOGAF 9.2" | "The TOGAF Standard, 10th Edition" |
| **Content updates** | Static document releases | Living library with continuous updates |
| **Agile support** | Limited agile guidance | Enhanced guidance for agile/iterative approaches |
| **Digital focus** | Less emphasis on digital transformation | Greater emphasis on digital, cloud, and modern architectures |
| **Modularity** | Less modular | More modular — consume what you need |
| **Core concepts** | Same foundational concepts | Same ADM, domains, and core framework — refined and reorganized |
| **Certification** | Part 1 + Part 2 exams | Updated exams aligned with TOGAF 10 content |
| **Business Architecture** | Covered but less prominent | Elevated emphasis on business architecture and strategy |
| **Integration** | Standalone framework | Better integration guidance with other frameworks (ITIL, SAFe, etc.) |

> **Exam Note:** TOGAF 10 retains the same ADM structure (Preliminary + A–H + RM). The core concepts are the same — the differences are primarily structural and organizational.

---

## 12. Mnemonics and Memory Aids

### ADM Phase Order
**"Please Avoid Bringing Conditions During Every Friday's Governance Hour — Remember Management!"**
- **P**reliminary
- **A**rchitecture Vision
- **B**usiness Architecture
- **C** (Information Systems — Data + App)
- **D** (Technology Architecture)
- **E** (Opportunities & Solutions)
- **F** (Migration Planning)
- **G** (Implementation Governance)
- **H** (Architecture Change Management)
- **R**equirements **M**anagement (center)

### Four Architecture Domains: BDAT
**B**usiness → **D**ata → **A**pplication → **T**echnology

### Compliance Levels Order
**"I Can't Climb Cliffs For Nothing"**
- **I**rrelevant
- **C**onsistent
- **C**ompliant (partial coverage)
- **C**onformant (full coverage)
- **F**ully Conformant
- **N**on-Conformant

### Enterprise Continuum (Generic → Specific)
**"From Common Industries to Our Org"**
- **F**oundation → **C**ommon Systems → **I**ndustry → **O**rganization-Specific

### Architecture Repository Components: "MASLRG"
**"My Architecture Stores Lots of Reference Governance"**
- **M**etamodel
- **A**rchitecture Capability
- **S**tandards Information Base
- **L**andscape
- **R**eference Library
- **G**overnance Log

### Architecture Landscape Levels
**"Strategize Segments of Capability"**
- **S**trategic → **S**egment → **C**apability

### ABB vs SBB
- **A**BB = **A**bstract (what)
- **S**BB = **S**pecific (how)

### Deliverables Quick Memory
- Phase A = **V**ision + **S**tatement
- Phases B/C/D = **D**efinition + **R**equirements
- Phase E = **R**oadmap + **T**ransitions
- Phase F = **M**igration **P**lan
- Phase G = **C**ontracts + **C**ompliance
- Phase H = **C**hange

---

## 13. Common Exam Traps and How to Avoid Them

| Trap | Reality | How to Remember |
|------|---------|-----------------|
| "Phase C produces one architecture" | Phase C produces TWO: Data Architecture + Application Architecture | C = "**C**ombined" (Data + App) |
| "Architecture Roadmap is only from Phase E" | Roadmap *components* emerge from B/C/D; *consolidated* in E; *finalized* in F | Roadmap evolves across B→E→F |
| "Preliminary Phase is Phase 0" | Preliminary Phase has no number | It's "Preliminary" — before numbering starts |
| "ADM is linear/waterfall" | ADM is iterative and cyclic — phases can be revisited | "Cycle" is in the diagram — it's a circle |
| "Compliance = Conformance" | Compliant ≠ Conformant. Compliant = subset, Conformant = superset | Compli**ant** = p**art**ial; Conform**ant** = **form**-complete |
| "Architecture Governance = Phase G only" | Governance is a capability spanning the entire ADM; Phase G specifically governs implementation | Governance is the umbrella; Phase G is implementation-specific |
| "Requirements Management is a phase like others" | RM is at the center, operates continuously — not sequential | RM is the hub of the wheel |
| "ABBs and SBBs are the same" | ABBs = abstract requirements (B/C/D), SBBs = concrete solutions (E/F) | A = Abstract, S = Specific |
| "Enterprise Continuum is an artifact" | It is a classification scheme, not a deliverable or artifact | It *classifies* artifacts — it is not one itself |
| "Phase H only handles small changes" | Phase H handles all three types: simplification, incremental, and re-architecting | H = "Handle everything from tweaks to total redo" |
| "Architecture Board does the architecture" | Architecture Board governs; the EA team does the work | Board = decision authority; Team = execution |
| "Stakeholder analysis happens once" | Stakeholders are revisited throughout the ADM; initial analysis in Phase A | Phase A is the big one, but it's ongoing |
| "Gap Analysis is Phase E" | Gap Analysis is done in B, C, D per domain; Phase E consolidates them | "Gap per phase, consolidate in E" |
| "Architecture Principles = Requirements" | Principles are general, enduring guidelines; Requirements are specific and project-scoped | Principles guide; Requirements constrain |

---

## 14. Quick Phase Identification Guide

> "In which phase does X happen?" — fast lookup table

| Activity | Phase |
|----------|-------|
| Define architecture principles | Preliminary |
| Tailor the TOGAF framework | Preliminary |
| Create the Architecture Vision | A |
| Approve the Statement of Architecture Work | A |
| Use Business Scenarios | A |
| Develop Business Architecture | B |
| Perform first Gap Analysis | B |
| Create Functional Decomposition Diagram | B |
| Develop Data Architecture | C |
| Create Application Portfolio Catalog | C |
| Develop Technology Architecture | D |
| Complete Architecture Definition Document | D |
| Identify work packages/projects | E |
| Create Transition Architectures | E |
| First identify SBBs | E |
| Consolidate the Architecture Roadmap | E |
| Finalize Implementation & Migration Plan | F |
| Prioritize projects by business value | F |
| Sign Architecture Contracts | G |
| Conduct Compliance Reviews | G |
| Govern implementation projects | G |
| Manage post-deployment changes | H |
| Determine if new ADM cycle needed | H |
| Manage requirements continuously | Requirements Management |

---
