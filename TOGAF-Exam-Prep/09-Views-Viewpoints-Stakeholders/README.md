# Architecture Views, Viewpoints, and Stakeholders

## Introduction

One of the most critical aspects of enterprise architecture is the ability to communicate complex architectural decisions to diverse audiences. A single architecture description cannot effectively address the concerns of every stakeholder — a CEO cares about strategic alignment and ROI, while a developer needs interface specifications and technology stack details. TOGAF addresses this challenge through a structured framework of **Views**, **Viewpoints**, and **Stakeholders**, heavily influenced by the ISO/IEC/IEEE 42010 standard.

This chapter is essential for TOGAF 10 certification because questions frequently test your understanding of the relationships between these concepts, how to select appropriate viewpoints for different stakeholders, and how views are created and used throughout the ADM cycle.

---

## Key Concepts

### Stakeholder

A **stakeholder** is an individual, team, organization, or class thereof, having an interest in a system. In TOGAF, stakeholders are individuals who have key roles in, or concerns about, the architecture. They influence the architecture and are affected by it. Stakeholders are not limited to people within the organization — they can include regulators, customers, suppliers, and partners.

### Concern

A **concern** is an interest in a system relevant to one or more of its stakeholders. Concerns relate to any aspect of the system's functioning, development, or operation — including performance, reliability, security, distribution, and evolvability. A single stakeholder typically has multiple concerns, and a single concern is often shared by multiple stakeholders.

### Viewpoint

An **architecture viewpoint** is a specification of the conventions for a particular type of architecture view. It establishes the conventions for constructing, interpreting, and analyzing a view. A viewpoint defines:

- The stakeholders whose concerns are addressed by the viewpoint
- The concerns that are addressed
- The model kinds used (e.g., class diagrams, process flows)
- The analytical methods applied to the view's models
- The conventions, rules, and notations used

Think of a viewpoint as a **template** or **recipe** for creating a view. It is reusable across multiple architectures.

### View

An **architecture view** is a representation of a system from the perspective of a related set of concerns. It is the actual content — the diagrams, tables, and textual descriptions — produced by applying a viewpoint to a particular architecture. Each view addresses one or more stakeholder concerns.

Think of a view as the **instantiation** of a viewpoint for a specific architecture.

### The Key Relationship

```
Viewpoint (template/recipe) --applied to--> Architecture --produces--> View (actual content)
```

A viewpoint is generic and reusable. A view is specific to a particular architecture at a particular point in time.

---

## ISO/IEC/IEEE 42010 Standard

### Overview

ISO/IEC/IEEE 42010:2011 (Systems and Software Engineering — Architecture Description) is the international standard for architecture descriptions. TOGAF explicitly aligns with this standard for its views and viewpoints concepts.

### Key Elements of 42010

The standard defines:

1. **Architecture Description (AD)**: A work product used to express an architecture
2. **Stakeholder**: An individual, team, organization, or classes thereof having an interest in a system
3. **Concern**: An interest in a system relevant to stakeholders
4. **Architecture Viewpoint**: A specification of conventions for constructing and using a view
5. **Architecture View**: A representation of a whole system from the perspective of a related set of concerns
6. **Model Kind**: Conventions for a type of modeling (e.g., UML class diagram, BPMN)
7. **Architecture Model**: A model developed under the governing conventions of a model kind

### How TOGAF Aligns with 42010

| 42010 Concept | TOGAF Equivalent |
|---|---|
| Architecture Description | Architecture artifacts, deliverables, building blocks |
| Stakeholder | Stakeholder (same concept) |
| Concern | Concern (same concept) |
| Architecture Viewpoint | Architecture Viewpoint |
| Architecture View | Architecture View |
| Model Kind | Architecture model types (catalogs, matrices, diagrams) |
| Architecture Model | Specific catalogs, matrices, and diagrams |

TOGAF extends 42010 by providing specific, named viewpoints tailored to enterprise architecture, and by embedding the view creation process within the ADM lifecycle.

---

## Stakeholder Identification and Classification

### Why Stakeholder Identification Matters

Failure to identify and engage the right stakeholders is one of the top reasons architecture initiatives fail. If key stakeholders are missed, their concerns go unaddressed, leading to architectures that lack buy-in, fail to meet real business needs, or face resistance during implementation.

### Stakeholder Identification Process

1. **Identify potential stakeholders** by examining the organizational chart, project documentation, and governance structures
2. **Categorize stakeholders** by their role and level of influence
3. **Assess each stakeholder's concerns** — what aspects of the architecture matter to them
4. **Prioritize stakeholders** based on their power and interest
5. **Plan engagement** — determine how and when to involve each stakeholder

### Stakeholder Management: Power/Interest Grid

The Power/Interest Grid classifies stakeholders along two axes:

```
                        HIGH POWER
              +---------------------------+
              |  Keep Satisfied |  Manage  |
              |    (Monitor)    | Closely  |
              +---------------------------+
              |    Monitor      |  Keep    |
              |   (Minimum      | Informed |
              |    Effort)      |          |
              +---------------------------+
                        LOW POWER
            LOW INTEREST              HIGH INTEREST
```

- **High Power, High Interest** (Manage Closely): CEO, CIO — actively engage, consult frequently
- **High Power, Low Interest** (Keep Satisfied): CFO, Board — keep satisfied, avoid overloading with detail
- **Low Power, High Interest** (Keep Informed): Developers, End Users — provide regular updates
- **Low Power, Low Interest** (Monitor): External parties — monitor with minimal effort

### RACI Matrix

TOGAF also recommends using RACI matrices for stakeholder management:

| Activity | CEO | CIO | CTO | Project Manager | Architect |
|---|---|---|---|---|---|
| Set architecture vision | A | R | C | I | R |
| Approve architecture | A | R | C | I | R |
| Define requirements | C | A | C | R | R |
| Review deliverables | I | A | C | R | R |
| Governance decisions | A | R | C | I | C |

- **R** = Responsible (does the work)
- **A** = Accountable (ultimate authority)
- **C** = Consulted (provides input)
- **I** = Informed (kept up to date)

---

## Common Stakeholders in Enterprise Architecture

### Executive Stakeholders

| Stakeholder | Role | Typical Concerns |
|---|---|---|
| **CEO** (Chief Executive Officer) | Overall organizational leadership | Strategic alignment, ROI, competitive advantage, risk management |
| **CIO** (Chief Information Officer) | IT strategy and alignment with business | IT strategy alignment, cost management, technology roadmap, risk |
| **CFO** (Chief Financial Officer) | Financial oversight | Cost, budget compliance, financial risk, ROI justification |
| **CTO** (Chief Technology Officer) | Technology direction and innovation | Technology strategy, innovation, standards, technical debt |
| **COO** (Chief Operating Officer) | Operations management | Operational efficiency, process improvement, service quality |

### Management Stakeholders

| Stakeholder | Role | Typical Concerns |
|---|---|---|
| **Business Unit Leaders** | Lead specific business areas | Business process support, functionality, competitive features |
| **Program/Project Managers** | Deliver specific initiatives | Schedule, scope, budget, dependencies, resource allocation |
| **IT Operations Managers** | Run and maintain IT services | System availability, performance, maintainability, disaster recovery |
| **Data Officers / Data Stewards** | Data governance and management | Data quality, data security, regulatory compliance, data accessibility |

### Technical Stakeholders

| Stakeholder | Role | Typical Concerns |
|---|---|---|
| **Enterprise Architects** | Define overall architecture | Architecture principles, standards compliance, integration, reuse |
| **Solution/Application Architects** | Design specific solutions | Application design, integration patterns, technology selection |
| **Application Developers** | Build and maintain applications | APIs, frameworks, development standards, testing, deployment |
| **Infrastructure Engineers** | Manage infrastructure | Hardware, networking, cloud, capacity planning, performance |

### Other Stakeholders

| Stakeholder | Role | Typical Concerns |
|---|---|---|
| **End Users** | Consume IT services | Usability, accessibility, performance, functionality |
| **Regulators** | Enforce legal/regulatory compliance | Compliance, audit trails, data protection, reporting |
| **Customers** | External consumers of products/services | Service quality, data privacy, reliability |
| **Suppliers/Partners** | Provide goods/services | Integration, data exchange standards, SLAs |

---

## Architecture Viewpoints

### Definition and Purpose

An architecture viewpoint defines the perspective from which a view is taken. It specifies:

- Which stakeholders it serves
- What concerns it addresses
- What types of models it contains
- What notation and modeling techniques are used
- What analysis methods can be applied

Viewpoints are reusable templates. Once defined, the same viewpoint can be applied to multiple architectures across the enterprise.

### Standard Viewpoints in TOGAF

TOGAF does not mandate a fixed set of viewpoints but provides guidance and examples. Common viewpoints include:

| Viewpoint | Stakeholders | Concerns Addressed | Typical Models |
|---|---|---|---|
| **Business Architecture Viewpoint** | CEO, Business Unit Leaders, COO | Business processes, organizational structure, business capabilities | Process flow diagrams, organizational charts, capability maps |
| **Data Architecture Viewpoint** | Data Officers, Application Architects | Data entities, data flow, data quality, data lifecycle | Data entity diagrams, data flow diagrams, data lifecycle diagrams |
| **Application Architecture Viewpoint** | CIO, Solution Architects, Developers | Application portfolio, interfaces, integration | Application portfolio catalog, interface diagrams, application communication diagrams |
| **Technology Architecture Viewpoint** | CTO, Infrastructure Engineers, IT Ops | Infrastructure, platforms, networking, deployment | Platform decomposition, network diagrams, deployment diagrams |
| **Security Viewpoint** | CISO, Regulators, Compliance Officers | Security policies, access control, threats | Threat models, access control matrices, security zone diagrams |
| **Interoperability Viewpoint** | Integration Architects, Partners | System-to-system integration, data exchange | Integration maps, message flow diagrams |
| **Migration Planning Viewpoint** | Program Managers, Project Managers | Transition planning, sequencing, dependencies | Migration roadmaps, Gantt charts, dependency matrices |

### Viewpoint Specification Template

A well-defined viewpoint should document:

1. **Viewpoint Name**: A unique, descriptive name
2. **Stakeholders**: Which stakeholders this viewpoint serves
3. **Concerns Addressed**: What specific concerns it addresses
4. **Model Kinds**: What types of models it uses (catalogs, matrices, diagrams)
5. **Modeling Conventions**: What notations and standards apply (e.g., UML, ArchiMate, BPMN)
6. **Analysis Techniques**: What analytical methods can be applied to the view
7. **Anti-Concerns**: What this viewpoint explicitly does not address

---

## Creating and Using Architecture Views

### The View Creation Process

Views are created as part of the ADM cycle. The general process is:

1. **Identify Stakeholders** (Preliminary Phase and Phase A): Determine who the stakeholders are for this architecture effort
2. **Identify Concerns** (Phase A): Through stakeholder engagement, understand what concerns each stakeholder has
3. **Select Viewpoints** (Phase A): Choose appropriate viewpoints that address the identified concerns
4. **Create Models** (Phases B, C, D): Develop the actual models (catalogs, matrices, diagrams) that populate each view
5. **Assemble Views** (Phases B, C, D): Combine related models into coherent views
6. **Validate Views** (Phase A through D, and Governance): Review views with stakeholders to ensure concerns are addressed
7. **Maintain Views** (Phase H and Governance): Keep views current as the architecture evolves

### Relationship Between Views, Viewpoints, and Models

```
+-------------------+
|    VIEWPOINT      |  (Template/specification)
|  - Stakeholders   |
|  - Concerns       |
|  - Model Kinds    |
+--------+----------+
         |
         | applied to a specific architecture
         v
+-------------------+
|      VIEW         |  (Actual representation)
|  - Addresses      |
|    specific       |
|    concerns       |
+--------+----------+
         |
         | composed of
         v
+-------------------+
|     MODELS        |  (Catalogs, Matrices, Diagrams)
|  - Data entities  |
|  - Process flows  |
|  - Etc.           |
+-------------------+
```

A view is composed of one or more **architecture models**. TOGAF classifies models into three types:

- **Catalogs**: Lists of building blocks of a specific type (e.g., application catalog, technology standards catalog)
- **Matrices**: Show relationships between model elements (e.g., application-to-function matrix, stakeholder-to-concern matrix)
- **Diagrams**: Visual representations of model elements and relationships (e.g., network diagram, process flow diagram)

---

## Selecting Appropriate Viewpoints for Stakeholders

### Selection Criteria

When selecting viewpoints, consider:

1. **Stakeholder Concerns**: The primary driver — which viewpoints address the concerns of your stakeholders?
2. **Stakeholder Sophistication**: Technical stakeholders can handle detailed technical views; executives need high-level, business-focused views
3. **Architecture Scope**: A broad enterprise architecture may require more viewpoints than a targeted solution architecture
4. **Available Resources**: Creating views takes effort — prioritize viewpoints that deliver the most value
5. **Organizational Standards**: Some organizations mandate specific viewpoints for governance or compliance

### Mapping Stakeholders to Views Across ADM Phases

| ADM Phase | Key Stakeholders | Key Views Created |
|---|---|---|
| **Preliminary** | CIO, Enterprise Architects, Governance Board | Architecture Principles View |
| **Phase A: Architecture Vision** | CEO, CIO, Business Unit Leaders | Business Scenario Views, Stakeholder Map View, Value Chain View |
| **Phase B: Business Architecture** | CEO, COO, Business Unit Leaders, Process Owners | Business Process Views, Organizational Views, Business Capability Views |
| **Phase C: Information Systems – Data** | Data Officers, Application Architects | Data Entity Views, Data Flow Views, Data Lifecycle Views |
| **Phase C: Information Systems – Application** | CIO, Solution Architects, Developers | Application Portfolio Views, Application Communication Views, Application Integration Views |
| **Phase D: Technology Architecture** | CTO, Infrastructure Engineers, IT Operations | Technology Standards Views, Platform Decomposition Views, Network/Infrastructure Views |
| **Phase E: Opportunities and Solutions** | Program Managers, Project Managers | Project Context Views, Benefits Realization Views |
| **Phase F: Migration Planning** | Program Managers, CIO | Migration Roadmap Views, Transition Architecture Views |
| **Phase G: Implementation Governance** | Project Managers, Architects | Compliance Assessment Views, Implementation Views |
| **Phase H: Architecture Change Management** | Enterprise Architects, Governance Board | Change Impact Views |

---

## Comprehensive Stakeholder-Concern-Viewpoint Mapping

| Stakeholder | Key Concerns | Recommended Viewpoints |
|---|---|---|
| **CEO** | Strategic direction, ROI, competitive advantage, risk | Business Architecture Viewpoint, Migration Planning Viewpoint |
| **CIO** | IT-business alignment, IT strategy, cost optimization | All viewpoints (at summary level), Application Architecture Viewpoint |
| **CFO** | Cost, budget, financial risk | Cost Analysis Viewpoint, Migration Planning Viewpoint |
| **CTO** | Technology direction, innovation, standards | Technology Architecture Viewpoint, Interoperability Viewpoint |
| **Business Unit Leaders** | Process efficiency, functionality, competitive features | Business Architecture Viewpoint, Application Architecture Viewpoint |
| **Program/Project Managers** | Timeline, scope, resources, dependencies | Migration Planning Viewpoint, Project Context Viewpoint |
| **IT Operations** | Availability, performance, maintainability, disaster recovery | Technology Architecture Viewpoint, Security Viewpoint |
| **Application Developers** | APIs, frameworks, standards, integration points | Application Architecture Viewpoint, Data Architecture Viewpoint |
| **End Users** | Usability, performance, accessibility | Business Architecture Viewpoint (user-facing processes) |
| **Regulators** | Compliance, audit, data protection | Security Viewpoint, Data Architecture Viewpoint, Compliance Viewpoint |
| **Data Officers** | Data quality, governance, privacy, lifecycle | Data Architecture Viewpoint |
| **Security Officers** | Threat landscape, access control, data protection | Security Viewpoint, Technology Architecture Viewpoint |

---

## Best Practices for Views and Viewpoints

1. **Tailor views to your audience**: Never present a single monolithic architecture document to all stakeholders
2. **Use standard notations**: Leverage established modeling languages (ArchiMate, UML, BPMN) for consistency
3. **Keep views current**: Outdated views erode trust in the architecture practice
4. **Cross-reference views**: Ensure consistency across views by validating shared elements
5. **Iterate views through the ADM**: Views evolve — early views are high-level and get refined in later phases
6. **Document viewpoint specifications**: Don't just create views — document the viewpoints so they can be reused
7. **Validate with stakeholders**: The ultimate test of a view is whether the stakeholder finds it useful
8. **Manage view complexity**: If a view becomes too complex, consider splitting it or raising the abstraction level

---

## Exam Tips

- **Views vs. Viewpoints**: The exam frequently tests whether you understand the difference. A viewpoint is a specification/template; a view is the actual representation for a specific architecture.
- **42010 Alignment**: Know that TOGAF aligns with ISO/IEC/IEEE 42010 for views and viewpoints.
- **Stakeholder-Concern Mapping**: Be prepared for questions that ask you to match stakeholders to concerns or recommend appropriate viewpoints for specific stakeholders.
- **ADM Integration**: Understand that stakeholders are identified in Phase A and that views are created throughout Phases B, C, and D.
- **Models compose Views**: Views are made up of catalogs, matrices, and diagrams.

---

## Review Questions

### Question 1
**What is the primary difference between an architecture view and an architecture viewpoint?**

A) A view is a template; a viewpoint is the actual content  
B) A viewpoint is a specification of conventions for constructing a view; a view is the actual representation of an architecture  
C) Views are used in Phase A; viewpoints are used in Phase B  
D) A viewpoint addresses a single concern; a view addresses multiple concerns  

**Answer: B** — A viewpoint is a reusable specification (template) that defines how to construct, interpret, and analyze a view. A view is the actual content produced by applying a viewpoint to a specific architecture.

---

### Question 2
**Which international standard does TOGAF align with for its views and viewpoints approach?**

A) ISO 27001  
B) ISO/IEC/IEEE 42010  
C) ISO 9001  
D) IEEE 1471 (superseded)  

**Answer: B** — TOGAF explicitly aligns with ISO/IEC/IEEE 42010:2011 for its architecture description concepts, including views, viewpoints, stakeholders, and concerns.

---

### Question 3
**In the Power/Interest Grid, which strategy is appropriate for stakeholders with high power and low interest?**

A) Manage Closely  
B) Keep Informed  
C) Keep Satisfied  
D) Monitor  

**Answer: C** — Stakeholders with high power but low interest should be kept satisfied. They have the authority to impact the architecture effort but may not be deeply engaged. Avoid overloading them with detail, but ensure their needs are met.

---

### Question 4
**What does the "R" in a RACI matrix stand for?**

A) Reviewer  
B) Responsible  
C) Required  
D) Recommended  

**Answer: B** — RACI stands for Responsible (does the work), Accountable (ultimate authority), Consulted (provides input), and Informed (kept up to date).

---

### Question 5
**Which of the following is NOT a component of a viewpoint specification?**

A) Stakeholders addressed  
B) Concerns addressed  
C) Model kinds used  
D) Implementation timeline  

**Answer: D** — A viewpoint specification includes stakeholders, concerns, model kinds, modeling conventions, and analysis techniques. Implementation timeline is not part of the viewpoint specification — it would be part of a migration planning view.

---

### Question 6
**In which ADM phase are stakeholders primarily identified?**

A) Preliminary Phase  
B) Phase A: Architecture Vision  
C) Phase B: Business Architecture  
D) Phase E: Opportunities and Solutions  

**Answer: B** — Stakeholders are primarily identified during Phase A (Architecture Vision), though some initial stakeholder identification may occur in the Preliminary Phase. Phase A is where the stakeholder map is formally created.

---

### Question 7
**Which stakeholder would be MOST interested in a Technology Architecture Viewpoint?**

A) CEO  
B) End Users  
C) CTO  
D) Business Unit Leaders  

**Answer: C** — The CTO is responsible for technology direction, standards, and innovation, making the Technology Architecture Viewpoint most relevant to their concerns.

---

### Question 8
**What are the three types of architecture models in TOGAF?**

A) Documents, Spreadsheets, Presentations  
B) Catalogs, Matrices, Diagrams  
C) Requirements, Designs, Implementations  
D) Business, Application, Technology  

**Answer: B** — TOGAF classifies architecture models into three types: Catalogs (lists of building blocks), Matrices (showing relationships), and Diagrams (visual representations).

---

### Question 9
**A concern in TOGAF is best described as:**

A) A problem that needs to be solved immediately  
B) An interest in a system relevant to one or more stakeholders  
C) A risk identified during architecture review  
D) A gap between the baseline and target architecture  

**Answer: B** — Per ISO/IEC/IEEE 42010 and TOGAF, a concern is an interest in a system relevant to one or more of its stakeholders. Concerns can relate to any aspect of system functioning including performance, reliability, security, and evolvability.

---

### Question 10
**Which of the following best describes the relationship between viewpoints and views?**

A) A viewpoint is created once; a view is created for each architecture  
B) Multiple viewpoints are combined to create a single view  
C) Views are generic; viewpoints are architecture-specific  
D) Viewpoints are created by stakeholders; views are created by architects  

**Answer: A** — A viewpoint is a reusable specification that can be applied across multiple architectures. A view is the actual instantiation for a specific architecture, so a new view is created each time the viewpoint is applied.

---

### Question 11
**When using the Power/Interest Grid, a developer who is highly interested in the architecture but has low organizational power should be:**

A) Managed Closely  
B) Kept Satisfied  
C) Kept Informed  
D) Monitored with minimal effort  

**Answer: C** — A stakeholder with low power but high interest should be kept informed. They care about the architecture and can provide valuable input, but they lack the organizational authority to block or approve decisions.

---

### Question 12
**Which viewpoint would BEST address a regulator's concerns about data protection?**

A) Business Architecture Viewpoint  
B) Technology Architecture Viewpoint  
C) Migration Planning Viewpoint  
D) Data Architecture Viewpoint and Security Viewpoint  

**Answer: D** — Regulators concerned about data protection need to see both how data is managed (Data Architecture Viewpoint) and how it is secured (Security Viewpoint).

---

### Question 13
**According to TOGAF, architecture views are primarily created during which ADM phases?**

A) Phase A only  
B) Phases B, C, and D  
C) Phase E and F  
D) Phase G and H  

**Answer: B** — While stakeholders and viewpoints are identified in Phase A, the actual architecture views (containing business, data, application, and technology models) are primarily created during Phases B (Business Architecture), C (Information Systems Architectures), and D (Technology Architecture).

---

### Question 14
**What is the purpose of documenting "anti-concerns" in a viewpoint specification?**

A) To identify security threats  
B) To explicitly state what the viewpoint does NOT address  
C) To document negative stakeholder feedback  
D) To track concerns that were rejected  

**Answer: B** — Anti-concerns explicitly document what a viewpoint does NOT address. This prevents misunderstandings and ensures stakeholders do not expect information from a view that it was never designed to provide.

---

### Question 15
**An architect needs to communicate the application integration landscape to both the CIO and the development team. What is the BEST approach?**

A) Create a single detailed integration diagram for both audiences  
B) Create two views using the same viewpoint but at different levels of abstraction  
C) Only present to the development team since the CIO won't understand technical details  
D) Postpone until Phase D when technology details are available  

**Answer: B** — The best approach is to create two views from the same viewpoint (Application Architecture / Integration Viewpoint) but at different levels of abstraction — a high-level summary for the CIO and a detailed technical view for the development team.

---

### Question 16
**Which of the following is a valid reason to define a new custom viewpoint rather than using an existing one?**

A) The architect wants to demonstrate creativity  
B) Existing viewpoints do not address a specific set of stakeholder concerns unique to the organization  
C) Custom viewpoints are always preferred over standard viewpoints  
D) The organization does not use ISO/IEC/IEEE 42010  

**Answer: B** — Custom viewpoints should be created when existing viewpoints do not adequately address the specific concerns of stakeholders in a particular organizational context. TOGAF encourages tailoring viewpoints to organizational needs.

---

## Summary

Understanding views, viewpoints, and stakeholders is fundamental to effective enterprise architecture communication. The key takeaways are:

- **Stakeholders** have **concerns** about the architecture
- **Viewpoints** are reusable specifications that define how to address specific concerns
- **Views** are the actual representations produced by applying viewpoints to a specific architecture
- Views are composed of **catalogs, matrices, and diagrams**
- TOGAF aligns with **ISO/IEC/IEEE 42010** for these concepts
- Stakeholder management tools like the **Power/Interest Grid** and **RACI matrix** help prioritize engagement
- Views are created throughout the ADM, primarily in **Phases B, C, and D**
- Always tailor views to the audience — different stakeholders need different levels of detail and different perspectives

---

*Next: [Building Blocks](../10-Building-Blocks/README.md)*
