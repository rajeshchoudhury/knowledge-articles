# Module 04: ADM Guidelines and Techniques

> **Comprehensive study guide for the TOGAF 10 certification exam — ADM Guidelines and Techniques**

---

## Overview

The **ADM Guidelines and Techniques** are a collection of supporting resources that complement the Architecture Development Method (ADM). While the ADM itself defines *what* to do (the phases and steps), the Guidelines and Techniques define *how* to do it — they provide practical advice, templates, and methods that architects apply within and across the ADM phases.

In TOGAF 10, these guidelines and techniques are part of the **Fundamental Content** and are essential reading for both Part 1 (Foundation) and Part 2 (Certified) exams.

```
┌──────────────────────────────────────────────────────────┐
│                  ADM GUIDELINES & TECHNIQUES              │
│                                                          │
│  ┌──────────────────┐  ┌──────────────────────────────┐  │
│  │   GUIDELINES     │  │       TECHNIQUES             │  │
│  │                  │  │                              │  │
│  │ • Applying       │  │ • Architecture Principles    │  │
│  │   Iteration      │  │ • Stakeholder Management     │  │
│  │ • Architecture   │  │ • Architecture Patterns      │  │
│  │   Landscape      │  │ • Gap Analysis               │  │
│  │ • Security       │  │ • Migration Planning         │  │
│  │   Architecture   │  │ • Interoperability           │  │
│  │ • SOA            │  │ • Business Transformation    │  │
│  │                  │  │   Readiness Assessment       │  │
│  │                  │  │ • Risk Management            │  │
│  │                  │  │ • Capability-Based Planning   │  │
│  └──────────────────┘  └──────────────────────────────┘  │
└──────────────────────────────────────────────────────────┘
```

**Key Exam Point:** Guidelines provide direction on *how to adapt and use* the ADM, while techniques provide specific *methods and tools* applied during ADM execution. Both can be used in any combination, tailored to the organization's needs.

---

## 1. Architecture Principles

### What Are Architecture Principles?

Architecture Principles are general rules and guidelines that inform and support the way an organization fulfills its mission. They are enduring, rarely amended, and reflect a level of consensus among the various elements of the enterprise. Principles form the basis for making future IT decisions and set the foundation for architecture governance.

Architecture Principles are typically defined during the **Preliminary Phase** and refined in **Phase A (Architecture Vision)**. They are used throughout all subsequent phases to guide decision-making.

### Characteristics of Good Principles

| Characteristic | Description |
|---|---|
| **Understandable** | The principle should be easily understood by all stakeholders |
| **Robust** | Each principle should be definitive and precise to allow for consistent interpretation |
| **Complete** | Every potentially important principle should be defined |
| **Consistent** | Principles should not contradict each other |
| **Stable** | Principles should be enduring but able to accommodate change through amendment |

### Architecture Principle Template

TOGAF provides a standard template with five components:

| Component | Description | Example |
|---|---|---|
| **Name** | A concise, memorable label | "Data is Shared" |
| **Statement** | A succinct declaration of the principle | "Data is shared across enterprise functions and organizations" |
| **Rationale** | Why the principle exists — business justification | "Timely access to accurate data is essential for improving quality and efficiency" |
| **Implications** | What must change or be done to support the principle | "Education on data sharing policies; common data definitions needed; data stewardship roles required" |
| **Metrics** (optional in TOGAF 10) | How compliance will be measured | "% of business units using shared data repositories" |

### Example Principles

**Principle 1: Technology Independence**

| Component | Content |
|---|---|
| Name | Technology Independence |
| Statement | The architecture does not depend on a specific hardware or software product |
| Rationale | Technology independence enables the organization to respond to changing technology markets and reduces vendor lock-in |
| Implications | Standards-based solutions are preferred; proprietary extensions require explicit approval; middleware must abstract technology differences |

**Principle 2: Data Trustee**

| Component | Content |
|---|---|
| Name | Data Trustee |
| Statement | Each data element has a trustee accountable for its quality |
| Rationale | Only through a single point of accountability can data quality be ensured |
| Implications | A data governance role must be established; data quality metrics must be defined; data ownership must be clearly assigned |

### Categories of Principles

TOGAF distinguishes between:

1. **Enterprise Principles** — Provide a basis for decision-making across the entire enterprise (often defined by business leadership)
2. **IT Principles** — Guide the use of IT resources and assets
3. **Architecture Principles** — Govern the architecture development process itself

**Exam Tip:** Principles are NOT the same as requirements. Principles are *general rules* that guide decisions; requirements are *specific needs* that must be met. Principles *generate* requirements.

---

## 2. Stakeholder Management

### Why Stakeholder Management Matters

Enterprise architecture efforts affect many people across the organization. Effective stakeholder management ensures the right people are engaged, their concerns are addressed, and the architecture gains the political support it needs to succeed. Poor stakeholder management is one of the primary reasons architecture initiatives fail.

Stakeholder management is applied primarily in **Phase A (Architecture Vision)** but continues throughout all ADM phases.

### The Stakeholder Management Process

1. **Identify** stakeholders
2. **Classify** stakeholders (using the Power/Interest grid)
3. **Determine** stakeholder management approach
4. **Tailor** engagement and communication
5. **Monitor** effectiveness of engagement

### Power/Interest Grid (Stakeholder Map Matrix)

The Power/Interest grid is the primary tool TOGAF recommends for classifying stakeholders:

```
                        POWER (Influence)
                    Low                 High
              ┌──────────────────┬──────────────────┐
              │                  │                  │
    High      │   KEEP           │   KEY PLAYERS    │
              │   INFORMED       │                  │
              │                  │   Engage closely │
  INTEREST    │   Regular        │   and actively   │
              │   communication  │   manage         │
              ├──────────────────┼──────────────────┤
              │                  │                  │
    Low       │   MINIMAL        │   KEEP           │
              │   EFFORT         │   SATISFIED      │
              │                  │                  │
              │   Monitor only   │   Address their  │
              │                  │   concerns       │
              └──────────────────┴──────────────────┘
```

### Management Approaches by Quadrant

| Quadrant | Power | Interest | Approach |
|---|---|---|---|
| **Key Players** | High | High | These are the most critical stakeholders. Engage them closely, seek their input on decisions, and keep them actively involved. Examples: CIO, Business Unit Leaders, Architecture Board. |
| **Keep Satisfied** | High | Low | These stakeholders can impact the project but are not currently engaged. Keep them satisfied with periodic updates, avoid surprising them. Examples: CFO, Legal/Compliance. |
| **Keep Informed** | Low | High | Interested but lack power. Provide regular information and make them feel heard. They can become advocates or detractors. Examples: Developers, End Users. |
| **Minimal Effort** | Low | Low | Monitor but don't over-invest. Provide general communications. Examples: External vendors, peripheral teams. |

### Stakeholder Identification Categories

TOGAF identifies common stakeholder classes:

| Stakeholder Class | Typical Concerns |
|---|---|
| Corporate functions (CEO, CFO, CIO) | Strategy alignment, ROI, risk |
| End-user organization | Usability, training, job impact |
| Project organization | Schedule, budget, scope |
| System operations | Operability, SLAs, maintenance |
| Enterprise/IT architecture team | Standards, patterns, compliance |
| Developers | Technical feasibility, tools |
| Procurement | Vendor selection, contracts |
| Regulatory bodies | Compliance, legal requirements |

### RACI Matrix for Architecture Governance

| Activity | Sponsor | Arch Board | Lead Architect | Stakeholders |
|---|---|---|---|---|
| Approve Architecture Vision | A | R | C | I |
| Review Architecture Deliverables | I | A | R | C |
| Approve Statement of Arch Work | A | R | C | I |
| Architecture Compliance Review | I | A | R | I |
| Change Request Approval | A | R | C | I |

*(R = Responsible, A = Accountable, C = Consulted, I = Informed)*

---

## 3. Architecture Patterns

### Definition

An **Architecture Pattern** is a reusable, proven solution to a commonly occurring problem in architecture design within a given context. Patterns describe a structure of components that solves a design problem and can be applied across similar situations.

### Types of Architecture Patterns

| Pattern Type | Description | Example |
|---|---|---|
| **Business Patterns** | Reusable approaches to common business problems | Shared services model, hub-and-spoke distribution |
| **Data Patterns** | Standard approaches to data management and integration | Master data management, data warehouse, event sourcing |
| **Application Patterns** | Reusable application design structures | Microservices, layered architecture, API gateway |
| **Technology Patterns** | Standard technology infrastructure approaches | Cloud-native infrastructure, containerized deployment, CDN |
| **Integration Patterns** | Approaches for connecting systems | Enterprise service bus, publish-subscribe, point-to-point |

### How Patterns Relate to the ADM

Patterns are used throughout the ADM, but particularly in:

- **Phase B (Business Architecture):** Business patterns for organizational design
- **Phase C (Information Systems):** Data and application patterns
- **Phase D (Technology Architecture):** Infrastructure and platform patterns
- **Phase E (Opportunities & Solutions):** Integration patterns for solution design

### Patterns and the Enterprise Continuum

Patterns exist at various levels of the **Enterprise Continuum**, from generic (Foundation Architecture) to specific (Organization-Specific Architecture):

```
Foundation      Common Systems      Industry      Organization-Specific
Patterns    →    Patterns       →   Patterns  →      Patterns

More Generic ──────────────────────────────→ More Specific
```

**Exam Tip:** Architecture patterns are NOT the same as building blocks, though they are related. A pattern describes a *proven solution approach*; a building block is a *reusable component* of an architecture. Patterns may *use* building blocks.

---

## 4. Gap Analysis

### What Is Gap Analysis?

Gap Analysis is a key technique used in the ADM to validate an architecture that is being developed. It operates by identifying the gaps between the **Baseline Architecture** (current state) and the **Target Architecture** (desired future state). It highlights items that have been intentionally omitted, accidentally left out, or that are in the baseline but not carried forward to the target.

Gap Analysis is used extensively in **Phases B, C, and D** and feeds directly into **Phase E (Opportunities and Solutions)**.

### The Gap Analysis Matrix

The primary tool is a matrix that compares baseline and target architecture elements:

```
                              TARGET ARCHITECTURE
                    ┌────────┬────────┬────────┬────────┬─────────┐
                    │ Target │ Target │ Target │ Target │         │
                    │ Elem 1 │ Elem 2 │ Elem 3 │ Elem 4 │ Dropped │
    ┌───────────────┼────────┼────────┼────────┼────────┼─────────┤
    │ Baseline      │        │        │        │        │         │
B   │ Elem 1        │ Mapped │        │        │        │         │
A   ├───────────────┼────────┼────────┼────────┼────────┼─────────┤
S   │ Baseline      │        │        │        │        │         │
E   │ Elem 2        │        │ Mapped │        │        │         │
L   ├───────────────┼────────┼────────┼────────┼────────┼─────────┤
I   │ Baseline      │        │        │        │        │   ✗     │
N   │ Elem 3        │        │        │        │        │ Dropped │
E   ├───────────────┼────────┼────────┼────────┼────────┼─────────┤
    │ New           │        │        │   ✗    │   ✗    │         │
    │               │        │        │  New   │  New   │         │
    └───────────────┴────────┴────────┴────────┴────────┴─────────┘
```

### Interpreting the Gap Analysis Matrix

| Result | Meaning | Action Required |
|---|---|---|
| **Diagonal matches** (Baseline → Target mapped) | Element exists in both baseline and target (may need modification) | Assess if change is needed; if identical, no action |
| **Row with no target match** (Dropped column checked) | Baseline element deliberately excluded from target | Confirm deliberate omission; plan decommissioning |
| **Column with no baseline match** (New row) | New element in target that does not exist in baseline | This is a **gap** — must be addressed through new development, procurement, or reuse |
| **Empty intersection** | No relationship between those elements | No action needed |

### How Gap Analysis Feeds Into Opportunity Identification

The gaps identified become the primary input to **Phase E (Opportunities and Solutions)**:

1. **Gaps** → become **opportunities** for new projects or initiatives
2. **Dropped elements** → may require **decommissioning** projects
3. **Modified elements** → may require **transformation** projects
4. **Consolidated gaps** across all architecture domains → feed into the **Consolidated Gaps, Solutions, and Dependencies Matrix**

### Steps to Perform Gap Analysis

1. List all architecture elements in the Baseline Architecture
2. List all architecture elements in the Target Architecture
3. Create the gap matrix and map baseline elements to their target equivalents
4. Identify elements that are new in the target (gaps)
5. Identify elements from the baseline with no target equivalent (to be dropped)
6. Assess the impact and complexity of each gap
7. Document gaps as requirements or opportunities
8. Feed results into Phase E for solution planning

**Exam Tip:** Gap analysis can be performed for each architecture domain (Business, Data, Application, Technology) separately, and then results are consolidated in Phase E.

---

## 5. Migration Planning Techniques

Migration Planning is a collection of techniques used primarily in **Phase E (Opportunities and Solutions)** and **Phase F (Migration Planning)** to plan and prioritize the implementation of the Target Architecture.

### 5.1 Implementation Factor Assessment and Deduction Matrix

This technique assesses the factors that influence the sequence of implementation projects.

**Implementation Factors:**

| Factor | Description |
|---|---|
| **Costs** | Financial cost of the project |
| **Benefits** | Business value delivered |
| **Risk** | Probability and impact of failure |
| **Dependencies** | What this project depends on / what depends on it |
| **Organizational readiness** | How ready the organization is for this change |
| **Cultural impact** | How the project affects organizational culture |
| **Regulatory compliance** | Whether the project is mandated by regulation |
| **Technical complexity** | How difficult the project is to implement |
| **Time to implement** | Calendar time needed |
| **Resource availability** | Staff and skills available |

The **Deduction Matrix** then applies these factors to derive a recommended implementation sequence:

```
┌──────────────────┬────────┬─────────┬──────┬─────────┬───────────┬──────────┐
│ Project          │ Cost   │ Benefit │ Risk │ Depends │ Readiness │ Priority │
├──────────────────┼────────┼─────────┼──────┼─────────┼───────────┼──────────┤
│ ERP Upgrade      │ High   │ High    │ Med  │ None    │ Medium    │ 2        │
│ Cloud Migration  │ Medium │ High    │ High │ ERP     │ Low       │ 4        │
│ API Gateway      │ Low    │ Medium  │ Low  │ None    │ High      │ 1        │
│ Data Warehouse   │ Medium │ High    │ Med  │ ERP     │ Medium    │ 3        │
└──────────────────┴────────┴─────────┴──────┴─────────┴───────────┴──────────┘
```

### 5.2 Consolidated Gaps, Solutions, and Dependencies Matrix

This matrix brings together the results of gap analysis from all architecture domains (B, C, D) into a single view. It maps:

- **Gaps** identified in each architecture domain
- **Potential solutions** (projects or work packages) to address each gap
- **Dependencies** between solutions

| Architecture Domain | Gap | Potential Solution | Dependencies |
|---|---|---|---|
| Business | No digital channel | Implement e-commerce platform | Application modernization |
| Data | Fragmented customer data | Master Data Management project | Data governance framework |
| Application | Legacy CRM | CRM replacement/upgrade | Cloud infrastructure |
| Technology | On-premise only | Cloud migration program | Network upgrade |

### 5.3 Architecture Definition Increments Table

This table defines how the architecture will be delivered in increments (Transition Architectures). Each increment represents a stable, intermediate state between the Baseline and Target Architecture.

| Architecture Element | Baseline (As-Is) | Transition 1 | Transition 2 | Target (To-Be) |
|---|---|---|---|---|
| CRM System | Legacy On-Prem | Cloud-Hybrid CRM | Full Cloud CRM | Full Cloud CRM |
| Data Platform | Spreadsheets | Centralized DB | Data Warehouse | Data Lake + DW |
| Integration | Point-to-Point | ESB (partial) | Full ESB | API Gateway + ESB |
| Security | Perimeter only | + Identity Mgmt | + Zero Trust (core) | Full Zero Trust |

### 5.4 Transition Architecture State Evolution Table

This table shows how each major architecture component evolves through each transition state. It provides a timeline view of the planned evolution.

| State | Timeframe | Key Changes | Business Value Delivered |
|---|---|---|---|
| Baseline | Current | As-is state | Current operations |
| Transition 1 | Months 1-6 | Cloud CRM, Central DB | Improved customer visibility |
| Transition 2 | Months 7-12 | Full ESB, Data Warehouse | Real-time data integration |
| Target | Months 13-18 | API Gateway, Data Lake, Zero Trust | Full digital capability |

### 5.5 Business Value Assessment

This technique evaluates each project or work package by its business value to determine priority. It considers:

**Performance Criteria:**
- Business value (revenue impact, cost savings)
- Strategic alignment
- Customer impact
- Operational efficiency

**Risk Criteria:**
- Implementation risk
- Organizational risk
- Technology risk
- Market risk

A common approach is the **Value/Risk Matrix**:

```
                        BUSINESS VALUE
                    Low                 High
              ┌──────────────────┬──────────────────┐
              │                  │                  │
    Low       │   DEPRIORITIZE   │   QUICK WINS     │
              │                  │                  │
    RISK      │   Low value,     │   High value,    │
              │   low risk:      │   low risk:      │
              │   defer or drop  │   DO FIRST       │
              ├──────────────────┼──────────────────┤
              │                  │                  │
    High      │   AVOID          │   STRATEGIC      │
              │                  │   INVESTMENTS     │
              │   Low value,     │                  │
              │   high risk:     │   High value,    │
              │   eliminate      │   high risk:     │
              │                  │   plan carefully │
              └──────────────────┴──────────────────┘
```

---

## 6. Interoperability Requirements

### What Is Interoperability?

Interoperability is the ability of two or more systems or components to exchange information and use that exchanged information. TOGAF distinguishes between different types:

| Type | Description |
|---|---|
| **Operational Interoperability** | The ability to operate effectively together at runtime (process and workflow level) |
| **Semantic Interoperability** | The ability to understand exchanged data in the same way (shared meaning) |
| **Technical Interoperability** | The ability to connect and exchange data at the technical level (protocols, formats) |

### Determining Interoperability Requirements

TOGAF recommends identifying interoperability requirements across two dimensions:

1. **Corporate interoperability** — between systems within the enterprise
2. **Inter-enterprise interoperability** — between the enterprise and external partners, suppliers, or customers

### Interoperability in the ADM

Interoperability is considered across multiple phases:

| Phase | Interoperability Activity |
|---|---|
| **Phase A** | Identify high-level interoperability needs; include in Architecture Vision |
| **Phase B** | Define business interoperability requirements (shared processes, information exchange) |
| **Phase C** | Define data and application interoperability requirements (APIs, data formats, semantic models) |
| **Phase D** | Define technology interoperability requirements (protocols, standards, infrastructure compatibility) |
| **Phase E** | Consolidate and resolve interoperability requirements into solutions |

### Enterprise Application Integration (EAI) Considerations

When addressing interoperability, architects must consider:

- **Data format standards** (XML, JSON, EDI, etc.)
- **Communication protocols** (REST, SOAP, AMQP, etc.)
- **Shared vocabularies and ontologies**
- **API governance and lifecycle management**
- **Event-driven integration patterns**
- **Master data management approaches**

---

## 7. Business Transformation Readiness Assessment

### Purpose

The Business Transformation Readiness Assessment evaluates whether the organization is ready to undergo the changes required to move from the baseline to the target architecture. Even the best architecture will fail if the organization is not ready for the transformation.

This technique is used primarily in **Phase A** (initial assessment) and revisited in **Phase E/F** (migration planning).

### Readiness Factors

TOGAF identifies recommended readiness factors to assess:

| Readiness Factor | Description |
|---|---|
| **Vision** | Does the enterprise have a clear, compelling vision of the target state? |
| **Desire, Willingness, and Resolve** | Is there motivation to achieve the vision and stamina to see it through? |
| **Need** | Is there a genuine need for the transformation (burning platform)? |
| **Business Case** | Is there a compelling, defensible business case? |
| **Funding** | Is adequate funding available and committed? |
| **Sponsorship and Leadership** | Is there strong, visible executive sponsorship? |
| **Governance** | Are governance structures in place to manage the transformation? |
| **Accountability** | Is there clear accountability for transformation success? |
| **Workable Approach and Execution Model** | Is there a realistic plan for implementation? |
| **IT Capacity to Execute** | Does IT have the skills, tools, and capacity to deliver? |
| **Enterprise Capacity to Execute** | Does the broader enterprise have the capacity to absorb change? |
| **Enterprise Ability to Implement and Migrate** | Can the organization actually make the switch? |

### Maturity Assessment Scale

Each factor is typically assessed on a maturity scale:

| Level | Rating | Description |
|---|---|---|
| 1 | **None** | Not present or not addressed |
| 2 | **Ad Hoc** | Recognized but not formalized |
| 3 | **Defined** | Documented and agreed upon |
| 4 | **Managed** | Measured, monitored, and actively managed |
| 5 | **Optimized** | Continuously improved and fully integrated |

### Readiness Assessment Technique Steps

1. **Determine readiness factors** — Use the recommended list or tailor to the organization
2. **Present readiness factors** — Using a table format for rating
3. **Assess readiness factors** — Rate each factor on the maturity scale
4. **Assess readiness risks** — For factors below required maturity, identify risks
5. **For each risk, identify improvement actions** — Create a plan to address readiness gaps
6. **Incorporate actions into Phase E/F migration planning** — Readiness actions become part of the implementation plan

### Readiness Assessment Example

| Factor | Current Maturity | Required Maturity | Gap | Risk | Mitigation |
|---|---|---|---|---|---|
| Sponsorship | 4 - Managed | 4 - Managed | None | Low | Continue stakeholder engagement |
| IT Capacity | 2 - Ad Hoc | 4 - Managed | 2 levels | High | Hire/train staff; partner with SI |
| Funding | 3 - Defined | 4 - Managed | 1 level | Medium | Develop phased business case |
| Governance | 2 - Ad Hoc | 3 - Defined | 1 level | Medium | Establish Architecture Board |

---

## 8. Risk Management

### Overview

Risk management in TOGAF is about identifying, classifying, mitigating, and monitoring risks associated with the architecture and its implementation. Architecture risk management runs throughout the entire ADM lifecycle.

### Risk Management Process

```
┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
│  1. Risk         │────→│  2. Initial     │────→│  3. Risk        │
│  Identification  │     │  Risk Assessment│     │  Mitigation     │
└─────────────────┘     └─────────────────┘     └────────┬────────┘
                                                          │
                                                          ▼
                                                ┌─────────────────┐
                                                │  4. Risk        │
                                                │  Monitoring     │
                                                │  (Ongoing)      │
                                                └─────────────────┘
```

### 8.1 Risk Identification

Identify risks associated with the architecture transformation. TOGAF identifies two levels of risk:

| Risk Level | Description | Examples |
|---|---|---|
| **Initial Level of Risk** | Risk categorized before any mitigation is applied | "Cloud migration may expose sensitive data" |
| **Residual Level of Risk** | Risk remaining after mitigation actions are applied | "After encryption, data exposure risk is low" |

Common risk categories:

- **Technical risks** — Technology may not work as expected
- **Schedule risks** — Timelines may not be achievable
- **Resource risks** — Skills or staff may not be available
- **Organizational risks** — Resistance to change, political challenges
- **External risks** — Regulatory changes, market shifts
- **Financial risks** — Budget overruns, reduced funding

### 8.2 Initial Risk Assessment

Classify risks using an **Effect/Probability Matrix**:

```
                         PROBABILITY
                   Low      Medium     High
             ┌──────────┬──────────┬──────────┐
   Severe    │  Medium  │   High   │ Critical │
             ├──────────┼──────────┼──────────┤
EFFECT       │          │          │          │
   Moderate  │   Low    │  Medium  │   High   │
             ├──────────┼──────────┼──────────┤
   Minor     │ Minimal  │   Low    │  Medium  │
             └──────────┴──────────┴──────────┘
```

### 8.3 Risk Mitigation and Tracking

For each identified risk, develop mitigation strategies:

| Strategy | Description | When to Use |
|---|---|---|
| **Avoid** | Eliminate the risk by removing the cause | When the risk is unacceptable and the cause can be removed |
| **Transfer** | Shift risk to another party (insurance, outsourcing) | When risk can be managed better by another party |
| **Mitigate** | Reduce probability or impact through specific actions | Most common approach — active risk reduction |
| **Accept** | Acknowledge the risk and take no action | When cost of mitigation exceeds potential impact |

### 8.4 Risk Monitoring

- Track identified risks throughout the ADM cycle
- Re-assess risk levels at each phase transition
- Monitor residual risks for changes
- Identify new risks as they emerge
- Report risk status to the Architecture Board and stakeholders

**Exam Tip:** TOGAF emphasizes that risk management is *continuous* throughout the ADM, not a one-time activity. Risks should be re-assessed whenever a new phase is entered or significant changes occur.

---

## 9. Capability-Based Planning

### What Is Capability-Based Planning?

Capability-Based Planning (CBP) is a business planning technique that focuses on the planning, engineering, and delivery of strategic **business capabilities** to the enterprise. Rather than planning around organizational structures or technology systems, CBP asks: "What capabilities does the enterprise need to execute its strategy?"

### Key Concepts

| Concept | Description |
|---|---|
| **Business Capability** | A particular ability that a business may possess or exchange to achieve a specific purpose or outcome |
| **Capability Increment** | A discrete portion of a capability delivered over time |
| **Capability Dimension** | The people, process, and technology aspects of a capability |
| **Capability Map** | A visual representation of the enterprise's capabilities, often organized hierarchically |

### How CBP Relates to Business Architecture

```
Strategic Goals → Business Capabilities → Capability Gaps → Architecture Work Packages
        │                 │                       │                    │
        ▼                 ▼                       ▼                    ▼
   "What we        "What we need        "What we're          "Projects to
    want to         to be able            missing"             close gaps"
    achieve"        to do"
```

### Steps in Capability-Based Planning

1. **Define strategic goals** — What the enterprise wants to achieve
2. **Map required capabilities** — What capabilities are needed to meet strategic goals
3. **Assess current capabilities** — What capabilities exist today and at what maturity level
4. **Identify capability gaps** — Differences between required and current capabilities
5. **Plan capability increments** — Define how gaps will be closed over time
6. **Map to architecture work packages** — Translate capability increments into ADM work

### CBP in the ADM

Capability-Based Planning is used primarily in:

- **Phase A:** Identify capabilities needed to support the Architecture Vision
- **Phase B:** Map business capabilities and assess maturity
- **Phase E:** Identify opportunities based on capability gaps
- **Phase F:** Plan capability delivery through migration planning

---

## 10. Architecture Compliance

### What Is Architecture Compliance?

Architecture Compliance ensures that individual projects and implementations conform to the approved enterprise architecture. It is a governance mechanism that maintains architectural integrity while allowing for controlled flexibility.

### Compliance Review Process

The Architecture Compliance Review is a formal process typically conducted during **Phase G (Implementation Governance)**:

1. **Identify projects** requiring compliance review
2. **Schedule compliance review** at appropriate project milestones
3. **Conduct the review** using the compliance checklist
4. **Document findings** — compliance, non-compliance, or dispensations
5. **Recommend actions** — approve, conditionally approve, or reject
6. **Track resolution** of non-compliance issues

### Compliance Assessment Checklist

| Area | Question | Compliant? |
|---|---|---|
| **Hardware/Platform** | Does the solution use approved platforms? | Y/N/Partial |
| **Operating Systems** | Does the solution use approved operating systems? | Y/N/Partial |
| **Database** | Does the solution use approved database technologies? | Y/N/Partial |
| **Application** | Does the application conform to approved patterns? | Y/N/Partial |
| **Integration** | Does the solution use approved integration methods? | Y/N/Partial |
| **Security** | Does the solution comply with security architecture? | Y/N/Partial |
| **Data** | Does the solution comply with data architecture standards? | Y/N/Partial |
| **Network** | Does the solution use approved network infrastructure? | Y/N/Partial |

### Levels of Compliance

TOGAF defines several levels of compliance:

| Level | Description |
|---|---|
| **Compliant** | Implementation fully conforms to the architecture |
| **Conformant** | Implementation is in alignment with the spirit of the architecture, though not fully compliant in every detail |
| **Non-Compliant** | Implementation does not conform to the architecture |
| **Quasi-Compliant** | Implementation has some features that are compliant but is not fully compliant — a temporary state with a plan to achieve full compliance |
| **Tailored Compliance** | The architecture has been explicitly tailored for this project, and the implementation complies with the tailored version |
| **Dispensation** | Formal approval to deviate from the architecture (with documented rationale and time limit) |

**Exam Tip:** Know the difference between compliant, conformant, and non-compliant. Also, understand that *dispensation* is a formal, governed process — not a workaround.

---

## 11. Architecture Maturity Models

### What Are Architecture Maturity Models?

Architecture Maturity Models assess how well-established an organization's architecture practice is. They help organizations understand their current state and plan improvements. TOGAF references the US Department of Commerce Architecture Capability Maturity Model (ACMM) and similar frameworks.

### Common Maturity Levels

| Level | Name | Description |
|---|---|---|
| 0 | **None** | No architecture practice exists |
| 1 | **Initial** | Architecture is done ad hoc; informal, undocumented processes |
| 2 | **Under Development** | Architecture processes are being developed; some documentation exists |
| 3 | **Defined** | Architecture processes are defined, documented, and standardized |
| 4 | **Managed** | Architecture processes are measured, monitored, and controlled |
| 5 | **Optimizing** | Continuous improvement of architecture processes; feedback loops in place |

### How Maturity Models Are Used

- **Benchmarking:** Compare the organization's architecture practice against best practices
- **Goal Setting:** Set target maturity levels for each architecture domain
- **Improvement Planning:** Develop plans to move from current to target maturity
- **Governance:** Monitor progress and ensure continued improvement

---

## 12. Using Iteration in the ADM

### Types of Iteration

TOGAF supports multiple forms of iteration within the ADM:

| Iteration Type | Description | Example |
|---|---|---|
| **Architecture Development Iteration** | Cycling through the entire ADM for a new architecture effort | First iteration produces strategic architecture; second produces segment architecture |
| **Transition Planning Iteration** | Cycling through Phases E and F to plan transitions | Replanning after feedback from implementation |
| **Architecture Governance Iteration** | Cycling through Phases G and H for ongoing governance | Monitoring implementation and responding to change requests |
| **Architecture Capability Iteration** | Cycling through the ADM to develop the architecture capability itself | Improving the architecture practice |

### Iteration Within Phases

Within any single phase, architects may iterate:
- Return to previous steps within the same phase
- Re-enter a completed phase based on new information
- Loop between phases (e.g., iterating between B, C, and D)

### Key Principles for Iteration

1. **Depth** — Each iteration may go deeper into a particular domain
2. **Breadth** — Each iteration may cover a broader scope
3. **Timeframe** — Iterations should be time-boxed to maintain momentum
4. **Output** — Each iteration should produce tangible deliverables

```
┌─────────────────────────────────────────────────────┐
│                  ADM ITERATION CYCLES                 │
│                                                       │
│   Architecture        Architecture       Architecture │
│   Development    →    Governance    →    Capability   │
│   Iteration           Iteration         Iteration     │
│   (Prelim→H)          (G→H loop)        (Prelim→H    │
│                                          for practice)│
│                                                       │
│       ▲                                    │          │
│       └────────────────────────────────────┘          │
│              Feedback and lessons learned              │
└─────────────────────────────────────────────────────┘
```

---

## 13. Architecture Landscape

The Architecture Landscape describes the architectural assets in use within the enterprise at a point in time. TOGAF defines three levels:

### Three Levels of Architecture

| Level | Scope | Timeframe | Detail | Typically Governed By |
|---|---|---|---|---|
| **Strategic Architecture** | Entire enterprise | 3-5 years | High-level, directional | CIO / Architecture Board |
| **Segment Architecture** | A major business area or domain | 1-2 years | Moderate detail | Domain Architects |
| **Capability Architecture** | A specific capability or project | Months | Detailed, implementable | Solution/Project Architects |

### How the Levels Relate

```
┌───────────────────────────────────────────────────────┐
│                STRATEGIC ARCHITECTURE                   │
│           (Enterprise-wide, long-term vision)          │
│                                                        │
│  ┌─────────────────┐  ┌─────────────────────────────┐ │
│  │   SEGMENT        │  │   SEGMENT                    │ │
│  │   ARCHITECTURE   │  │   ARCHITECTURE               │ │
│  │   (HR Domain)    │  │   (Finance Domain)           │ │
│  │                  │  │                              │ │
│  │ ┌────┐ ┌────┐   │  │ ┌────┐ ┌────┐ ┌────┐       │ │
│  │ │Cap │ │Cap │   │  │ │Cap │ │Cap │ │Cap │       │ │
│  │ │Arch│ │Arch│   │  │ │Arch│ │Arch│ │Arch│       │ │
│  │ └────┘ └────┘   │  │ └────┘ └────┘ └────┘       │ │
│  └─────────────────┘  └─────────────────────────────┘ │
└───────────────────────────────────────────────────────┘
```

Each higher level provides context and constraints for the levels below it. Strategic architecture guides segment architecture, which in turn guides capability architecture.

---

## 14. Security Architecture Considerations

### Integration with SABSA

TOGAF recommends integrating security architecture throughout the ADM. The **Sherwood Applied Business Security Architecture (SABSA)** framework is commonly used alongside TOGAF.

### Security in Each ADM Phase

| ADM Phase | Security Consideration |
|---|---|
| **Preliminary** | Establish security architecture principles; identify security governance structure |
| **Phase A** | Include security stakeholders; define security aspects of the Architecture Vision |
| **Phase B** | Define business security requirements; identify security-sensitive business processes |
| **Phase C** | Define data classification; application security patterns; access control models |
| **Phase D** | Define network security architecture; infrastructure security standards; security technology platforms |
| **Phase E** | Consolidate security requirements; ensure security is addressed in all solutions |
| **Phase F** | Include security implementation in migration plans; security testing plans |
| **Phase G** | Security compliance reviews; security architecture contracts |
| **Phase H** | Monitor security posture; respond to security-related change drivers |

### SABSA Alignment with TOGAF

| SABSA Layer | TOGAF Equivalent | Focus |
|---|---|---|
| Contextual | Architecture Vision / Business Architecture | Business security requirements |
| Conceptual | Business Architecture | Security concepts and policies |
| Logical | Information Systems Architecture | Security services and mechanisms |
| Physical | Technology Architecture | Security products and tools |
| Component | Implementation | Specific security implementations |
| Operational | Governance | Security operations and monitoring |

---

## 15. Techniques Mapped to ADM Phases

| Technique | Prelim | A | B | C | D | E | F | G | H | Req Mgmt |
|---|---|---|---|---|---|---|---|---|---|---|
| Architecture Principles | ● | ● | | | | | | | | |
| Stakeholder Management | | ● | ● | ● | ● | ● | ● | ● | ● | |
| Architecture Patterns | | | ● | ● | ● | ● | | | | |
| Gap Analysis | | | ● | ● | ● | ● | | | | |
| Migration Planning | | | | | | ● | ● | | | |
| Interoperability | | ● | ● | ● | ● | ● | | | | |
| Business Transformation Readiness | | ● | | | | ● | ● | | | |
| Risk Management | | ● | ● | ● | ● | ● | ● | ● | ● | ● |
| Capability-Based Planning | | ● | ● | | | ● | ● | | | |
| Architecture Compliance | | | | | | | | ● | ● | |
| Security Architecture | ● | ● | ● | ● | ● | ● | ● | ● | ● | |

*● = Primary use in this phase*

---

## 16. Summary of Key Concepts for the Exam

| Concept | Key Points to Remember |
|---|---|
| **Guidelines vs. Techniques** | Guidelines = how to adapt the ADM; Techniques = specific tools/methods |
| **Principles** | Defined in Preliminary/Phase A; use the 5-component template; generate requirements |
| **Stakeholder Management** | Power/Interest grid with 4 quadrants; Key Players get the most attention |
| **Gap Analysis** | Matrix comparing Baseline vs. Target; identifies new, modified, and dropped elements |
| **Migration Planning** | 5 key techniques: Implementation Factors, Consolidated Gaps, Definition Increments, State Evolution, Business Value |
| **Risk Management** | Continuous process; Initial vs. Residual risk; Effect/Probability matrix |
| **Compliance** | Compliant vs. Conformant vs. Non-Compliant; Dispensation is formal |
| **Capability-Based Planning** | Focus on business capabilities, not org structures; maps to architecture work |
| **Readiness Assessment** | 12 readiness factors; maturity scale 1-5; risks from gaps; mitigation plans |
| **Iteration** | 4 types of iteration; within and across phases; enables depth and breadth |
| **Architecture Landscape** | Strategic (enterprise-wide) → Segment (domain) → Capability (project) |

---

## Review Questions

### Question 1
**Which of the following is NOT a component of the Architecture Principle template in TOGAF?**

A) Name
B) Statement
C) Rationale
D) Priority

**Answer: D) Priority**
The TOGAF Architecture Principle template contains: Name, Statement, Rationale, and Implications. Priority is not part of the standard template.

---

### Question 2
**In the Stakeholder Power/Interest grid, a stakeholder with HIGH power and LOW interest should be managed using which approach?**

A) Key Players — engage closely
B) Keep Satisfied — address their concerns
C) Keep Informed — regular communication
D) Minimal Effort — monitor only

**Answer: B) Keep Satisfied**
Stakeholders with high power but low interest should be kept satisfied. They have the authority to impact the project even though they are not currently engaged. Avoid surprising them.

---

### Question 3
**What is the primary purpose of Gap Analysis in the ADM?**

A) To identify risks associated with the Target Architecture
B) To compare Baseline and Target Architectures and identify differences
C) To assess stakeholder readiness for change
D) To evaluate the business value of architecture projects

**Answer: B) To compare Baseline and Target Architectures and identify differences**
Gap Analysis compares what exists (Baseline) to what is desired (Target) to identify what needs to change.

---

### Question 4
**In which ADM phases is Gap Analysis primarily performed?**

A) Preliminary and Phase A
B) Phases B, C, D, and E
C) Phases F and G
D) Phase H and Requirements Management

**Answer: B) Phases B, C, D, and E**
Gap Analysis is performed in Phases B (Business), C (Information Systems), and D (Technology) for each domain, with results consolidated in Phase E.

---

### Question 5
**The Consolidated Gaps, Solutions, and Dependencies Matrix brings together results from which phases?**

A) Preliminary and Phase A
B) Phases B, C, and D
C) Phases E and F only
D) Phases G and H

**Answer: B) Phases B, C, and D**
The matrix consolidates gap analysis results from all architecture domains (Business, Data, Application, Technology) developed in Phases B, C, and D.

---

### Question 6
**Which migration planning technique evaluates factors like cost, benefit, risk, and organizational readiness for each project?**

A) Business Value Assessment
B) Architecture Definition Increments Table
C) Implementation Factor Assessment and Deduction Matrix
D) Transition Architecture State Evolution Table

**Answer: C) Implementation Factor Assessment and Deduction Matrix**
This technique systematically evaluates implementation factors to derive a recommended sequence for projects.

---

### Question 7
**What is the difference between Initial Risk and Residual Risk?**

A) Initial risk is strategic; residual risk is tactical
B) Initial risk is before mitigation; residual risk is after mitigation
C) Initial risk is in Phase A; residual risk is in Phase H
D) Initial risk is documented; residual risk is undocumented

**Answer: B) Initial risk is before mitigation; residual risk is after mitigation**
Initial risk is the risk level before any mitigation actions. Residual risk is what remains after mitigation has been applied.

---

### Question 8
**In TOGAF's compliance levels, what does "Dispensation" mean?**

A) The project has been formally cancelled
B) Formal approval to deviate from the architecture
C) The architecture has been rejected by the Architecture Board
D) The project is fully compliant

**Answer: B) Formal approval to deviate from the architecture**
A dispensation is a formal, governed process that allows a project to deviate from the approved architecture, with documented rationale and typically a time limit.

---

### Question 9
**Which of the following is NOT one of TOGAF's recommended readiness factors for Business Transformation Readiness Assessment?**

A) Vision
B) Desire, Willingness, and Resolve
C) Competitive Analysis
D) Funding

**Answer: C) Competitive Analysis**
TOGAF's readiness factors include Vision, Desire/Willingness/Resolve, Need, Business Case, Funding, Sponsorship, Governance, Accountability, Workable Approach, IT Capacity, Enterprise Capacity, and Enterprise Ability to Implement. Competitive Analysis is not a standard readiness factor.

---

### Question 10
**Capability-Based Planning focuses primarily on:**

A) Technology platforms and their lifecycle
B) Organizational hierarchy and reporting structures
C) Strategic business capabilities needed to execute the strategy
D) Financial investment portfolios

**Answer: C) Strategic business capabilities needed to execute the strategy**
CBP plans around the capabilities an enterprise needs, rather than organizational structures or technology systems.

---

### Question 11
**Which three levels comprise the Architecture Landscape in TOGAF?**

A) Foundation, Common Systems, Industry
B) Strategic, Segment, Capability
C) Conceptual, Logical, Physical
D) Business, Information, Technology

**Answer: B) Strategic, Segment, Capability**
The Architecture Landscape has three levels: Strategic Architecture (enterprise-wide, 3-5 years), Segment Architecture (domain, 1-2 years), and Capability Architecture (project, months).

---

### Question 12
**What types of interoperability does TOGAF distinguish between?**

A) Internal and External
B) Hardware and Software
C) Operational, Semantic, and Technical
D) Strategic and Tactical

**Answer: C) Operational, Semantic, and Technical**
TOGAF identifies three types: Operational (process-level), Semantic (shared meaning), and Technical (protocol/format level).

---

### Question 13
**In the Risk Assessment matrix, a risk with HIGH probability and SEVERE effect would be classified as:**

A) High
B) Medium
C) Critical
D) Low

**Answer: C) Critical**
In the Effect/Probability matrix, the intersection of high probability and severe effect produces the highest classification — Critical.

---

### Question 14
**Which ADM phase is the primary consumer of Architecture Compliance reviews?**

A) Phase A — Architecture Vision
B) Phase D — Technology Architecture
C) Phase G — Implementation Governance
D) Phase H — Architecture Change Management

**Answer: C) Phase G — Implementation Governance**
Architecture Compliance reviews are primarily conducted during Phase G to ensure that implementations conform to the approved architecture.

---

### Question 15
**Which iteration type involves cycling through Phases G and H?**

A) Architecture Development Iteration
B) Transition Planning Iteration
C) Architecture Governance Iteration
D) Architecture Capability Iteration

**Answer: C) Architecture Governance Iteration**
The Architecture Governance Iteration cycles through Phases G (Implementation Governance) and H (Architecture Change Management) for ongoing monitoring and change management.

---

### Question 16
**The SABSA framework is referenced by TOGAF in the context of:**

A) Business Architecture modeling
B) Security Architecture integration
C) Data Architecture classification
D) Application portfolio management

**Answer: B) Security Architecture integration**
SABSA (Sherwood Applied Business Security Architecture) is specifically referenced by TOGAF as a complementary framework for integrating security architecture into the ADM.

---

### Question 17
**Architecture Principles should be defined during which phase(s) of the ADM?**

A) Phase E and Phase F
B) Preliminary Phase and Phase A
C) Phase G and Phase H
D) Phase B and Phase C

**Answer: B) Preliminary Phase and Phase A**
Architecture Principles are typically established in the Preliminary Phase and further refined in Phase A (Architecture Vision).

---

### Question 18
**The Architecture Definition Increments Table is used to:**

A) Define how the architecture will be delivered in increments through Transition Architectures
B) List all stakeholders and their power/interest ratings
C) Document all risks and their mitigation strategies
D) Catalog all architecture principles

**Answer: A) Define how the architecture will be delivered in increments through Transition Architectures**
This table shows how each architecture element evolves from Baseline through Transition states to the Target Architecture.

---

### Question 19
**What is the relationship between Architecture Principles and Requirements?**

A) Principles and requirements are the same thing
B) Requirements generate principles
C) Principles generate requirements
D) Principles replace requirements

**Answer: C) Principles generate requirements**
Principles are general rules that guide decision-making. They *generate* specific requirements. For example, a principle of "Data is Shared" generates requirements for shared data repositories, data governance, etc.

---

### Question 20
**In the Stakeholder Map, which quadrant requires the MOST engagement effort?**

A) Low Power, Low Interest
B) Low Power, High Interest
C) High Power, Low Interest
D) High Power, High Interest

**Answer: D) High Power, High Interest**
The "Key Players" quadrant (High Power, High Interest) requires the most active engagement. These stakeholders must be closely managed and actively involved in decisions.

---

### Question 21
**Which risk mitigation strategy involves shifting the risk to another party?**

A) Avoid
B) Mitigate
C) Transfer
D) Accept

**Answer: C) Transfer**
Risk transfer involves shifting the risk to another party, such as through insurance, outsourcing, or contractual arrangements.

---

### Question 22
**What is the difference between "Compliant" and "Conformant" in TOGAF's compliance levels?**

A) There is no difference — they are synonyms
B) Compliant means full compliance; conformant means aligned with the spirit of the architecture
C) Conformant is stricter than compliant
D) Compliant is for Phase G; conformant is for Phase H

**Answer: B) Compliant means full compliance; conformant means aligned with the spirit of the architecture**
Compliant means the implementation fully conforms in every detail. Conformant means it is aligned with the intent and spirit of the architecture, even if not every detail is fully compliant.

---

### Question 23
**Business Transformation Readiness Assessment uses a maturity scale. What is the highest level?**

A) Level 3 — Defined
B) Level 4 — Managed
C) Level 5 — Optimized
D) Level 6 — Transformational

**Answer: C) Level 5 — Optimized**
The readiness maturity scale ranges from Level 1 (None) to Level 5 (Optimized), where processes are continuously improved and fully integrated.

---

*These materials are for exam preparation purposes. TOGAF is a registered trademark of The Open Group. Always refer to the official TOGAF Standard, 10th Edition for authoritative content.*
