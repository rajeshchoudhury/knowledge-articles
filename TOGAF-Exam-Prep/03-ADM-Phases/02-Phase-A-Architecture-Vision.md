# Phase A: Architecture Vision

## Overview

Phase A is the **first phase within the ADM cycle** (following the Preliminary Phase, which precedes the cycle). It establishes the **scope, constraints, and expectations** for an architecture engagement. The central purpose of Phase A is to develop a high-level aspirational vision of the capabilities and business value to be delivered, and to obtain executive approval for a **Statement of Architecture Work** that defines the architecture project going forward.

Phase A is where the architecture effort transitions from organizational preparation (Preliminary Phase) to a specific, sponsored architecture project. It answers the fundamental question: **"What are we trying to achieve with this architecture effort, and do we have agreement to proceed?"**

```
┌──────────────────────────────────────────────────────────────┐
│                     PHASE A: ARCHITECTURE VISION             │
│                                                              │
│  ┌─────────────┐     ┌──────────────┐     ┌──────────────┐  │
│  │ Request for  │     │ Stakeholder  │     │ Architecture │  │
│  │ Architecture │────▶│ Engagement & │────▶│ Vision       │  │
│  │ Work (INPUT) │     │ Analysis     │     │ Document     │  │
│  └─────────────┘     └──────────────┘     └──────┬───────┘  │
│                                                   │          │
│  ┌─────────────┐     ┌──────────────┐     ┌──────▼───────┐  │
│  │ Approved     │     │ Business     │     │ Scope,       │  │
│  │ Statement of │◀────│ Transformation│◀────│ Constraints, │  │
│  │ Arch Work    │     │ Readiness    │     │ Risks        │  │
│  │ (OUTPUT)     │     │ Assessment   │     │              │  │
│  └─────────────┘     └──────────────┘     └──────────────┘  │
└──────────────────────────────────────────────────────────────┘
```

> **Exam Tip:** Phase A produces two critical deliverables — the **Architecture Vision** (a document describing the target state) and the **Statement of Architecture Work** (a project charter for the architecture effort). The exam frequently asks which is the primary output. The answer is the **Approved Statement of Architecture Work**, because it is the formal trigger for proceeding to Phase B.

---

## Objectives of Phase A

The objectives of Phase A are to:

1. **Develop a high-level aspirational vision** of the capabilities and business value to be delivered as a result of the proposed enterprise architecture.
2. **Obtain approval for a Statement of Architecture Work** that defines a program of works to develop and deploy the architecture outlined in the Architecture Vision.
3. **Validate the business principles, business goals, and strategic business drivers** that underpin the architecture effort.
4. **Define the scope of the architecture effort** — what is in and out of scope, depth vs. breadth, time horizon, and architecture domains involved.
5. **Identify stakeholders, their concerns, and their requirements** — understand who cares about the architecture and what they need from it.
6. **Assess business transformation readiness** — evaluate whether the organization is ready for the changes implied by the architecture.
7. **Create the initial Architecture Vision** that describes the Target Architecture at a high level and communicates the value proposition.
8. **Secure formal approval** from sponsors and stakeholders to proceed with detailed architecture development.

---

## Key Concepts

### The Request for Architecture Work — The Key INPUT Trigger

The **Request for Architecture Work** is the formal document that triggers Phase A. It originates from the Preliminary Phase (or from an Architecture Board recognizing a need) and typically contains:

- The sponsoring organization and authority
- The business problem or opportunity being addressed
- Strategic context and business drivers
- High-level scope and constraints
- Timeline expectations
- Budget considerations
- Known stakeholders

Without a Request for Architecture Work, Phase A cannot formally begin. This document serves as the "authorization to proceed" with architecture development.

> **Exam Tip:** The Request for Architecture Work is an OUTPUT of the Preliminary Phase and the key INPUT to Phase A. This input-output chain between phases is a frequently tested concept.

### The Statement of Architecture Work — The Key OUTPUT Deliverable

The **Statement of Architecture Work** is the principal output of Phase A. It functions as a **project charter for the architecture effort** and defines:

| Element | Description |
|---------|-------------|
| **Architecture project description and scope** | What the architecture effort will cover |
| **Overview of the Architecture Vision** | Summary of the target state and value proposition |
| **Specific change-of-scope procedures** | How scope changes will be handled |
| **Roles, responsibilities, and deliverables** | Who does what and what will be produced |
| **Acceptance criteria and procedures** | How success will be measured |
| **Architecture project plan and schedule** | Timeline and milestones |
| **Risks and risk mitigation** | Known risks and initial mitigation strategies |
| **Signature approvals** | Formal sign-off from sponsors and key stakeholders |

The Statement of Architecture Work must be **formally approved** before the architecture team can proceed to Phase B. This approval represents the commitment of resources and authority to the architecture project.

### Architecture Vision Document

The Architecture Vision is a high-level description of the Target Architecture that provides a summary view of:

- The business scenario or problem being addressed
- The proposed target state across all relevant architecture domains (Business, Data, Application, Technology)
- The business value and key benefits
- The high-level gap between the current state and the target state
- Key risks and constraints
- The value proposition for stakeholders

The Architecture Vision is deliberately **high-level** — it provides enough detail to communicate the direction and gain buy-in, but not the full depth that will be developed in Phases B through D.

```
┌────────────────────────────────────────────────────────┐
│              ARCHITECTURE VISION DOCUMENT               │
│                                                         │
│  ┌───────────────────────────────────────────────────┐  │
│  │ Problem/Opportunity Statement                     │  │
│  └───────────────────────────────────────────────────┘  │
│  ┌───────────────────────────────────────────────────┐  │
│  │ High-Level Target Architecture (all domains)      │  │
│  │  • Business Architecture (summary)                │  │
│  │  • Data Architecture (summary)                    │  │
│  │  • Application Architecture (summary)             │  │
│  │  • Technology Architecture (summary)              │  │
│  └───────────────────────────────────────────────────┘  │
│  ┌───────────────────────────────────────────────────┐  │
│  │ Stakeholder Concerns & Requirements               │  │
│  └───────────────────────────────────────────────────┘  │
│  ┌───────────────────────────────────────────────────┐  │
│  │ Value Proposition & KPIs                          │  │
│  └───────────────────────────────────────────────────┘  │
│  ┌───────────────────────────────────────────────────┐  │
│  │ Risks, Constraints, Assumptions                   │  │
│  └───────────────────────────────────────────────────┘  │
└────────────────────────────────────────────────────────┘
```

---

## Stakeholder Management

### Stakeholder Map Matrix

Stakeholder management is a critical activity in Phase A. TOGAF provides the **Stakeholder Map Matrix** as a technique for identifying, classifying, and prioritizing stakeholders. The most commonly referenced model is the **Power/Interest Grid**:

```
                        INTEREST
                 Low                High
            ┌─────────────┬─────────────────┐
            │             │                 │
     High   │   Keep      │   Manage        │
            │   Satisfied │   Closely       │
   POWER    │             │   (Key Players) │
            ├─────────────┼─────────────────┤
            │             │                 │
     Low    │   Monitor   │   Keep          │
            │   (Minimal  │   Informed      │
            │    Effort)  │                 │
            └─────────────┴─────────────────┘
```

| Quadrant | Strategy | Example Stakeholders |
|----------|----------|---------------------|
| **High Power, High Interest** (Key Players) | Manage closely — engage frequently, involve in decisions, address concerns proactively | CIO, CFO, Business Unit Leaders, Architecture Board |
| **High Power, Low Interest** (Keep Satisfied) | Keep satisfied — provide high-level updates, escalate critical issues | CEO, Board Members, Regulatory Bodies |
| **Low Power, High Interest** (Keep Informed) | Keep informed — provide regular communications, leverage their expertise | Domain experts, developers, solution architects, end-users |
| **Low Power, Low Interest** (Monitor) | Monitor — minimal effort, inform only when necessary | External vendors (not directly impacted), peripheral departments |

Steps for creating the Stakeholder Map:

1. **Identify** all stakeholders — anyone who affects or is affected by the architecture.
2. **Classify** each stakeholder by their concerns, power, and interest.
3. **Position** them on the Power/Interest grid.
4. **Define engagement strategy** for each stakeholder or stakeholder group.
5. **Document** in the Stakeholder Map Matrix.
6. **Review and update** throughout the ADM cycle.

> **Exam Tip:** The exam may present a scenario with multiple stakeholders and ask you to classify them using the Power/Interest grid. Focus on understanding the difference between "power" (ability to influence outcomes) and "interest" (level of concern with the architecture effort).

---

## Business Transformation Readiness Assessment

The **Business Transformation Readiness Assessment** evaluates whether the organization is ready for the changes that the architecture implies. This is a TOGAF-recommended technique that examines readiness factors including:

| Readiness Factor | Description |
|-----------------|-------------|
| **Vision** | Is there a clear vision for the change and is it well-communicated? |
| **Desire, Willingness, and Resolve** | Do key stakeholders want the change and are they willing to pursue it? |
| **Need** | Is there a clear and acknowledged business need driving the change? |
| **Business Case** | Is there a compelling financial and strategic business case? |
| **Funding** | Is adequate funding available and committed? |
| **Sponsorship and Leadership** | Is there strong, visible executive sponsorship? |
| **Governance** | Are governance mechanisms in place to manage the transformation? |
| **Accountability** | Are clear roles and accountability defined for transformation success? |
| **IT Capacity to Execute** | Does the IT organization have the skills, tools, and capacity to deliver? |
| **Enterprise Capacity to Execute** | Does the broader organization have the ability to absorb the change? |

For each factor, the assessment determines:
- **Current maturity level** (1–5 scale or RAG status)
- **Required maturity level** for success
- **Gap** between current and required
- **Mitigation actions** to close the gap
- **Risk rating** if the gap cannot be closed

The Business Transformation Readiness Assessment is a key input to risk management activities and may influence the scope, phasing, or pace of the architecture effort.

---

## Risk Assessment

Phase A includes initial **risk identification, classification, and mitigation**. TOGAF classifies risks using two dimensions:

| Dimension | Description |
|-----------|-------------|
| **Initial Level of Risk** | The risk level before any mitigation (inherent risk) |
| **Residual Level of Risk** | The risk level remaining after mitigation actions (residual risk) |

Risks are typically categorized as:

| Risk Category | Examples |
|--------------|----------|
| **Business risks** | Market shifts, competitive pressures, regulatory changes |
| **Technology risks** | Platform obsolescence, integration complexity, performance unknowns |
| **Organizational risks** | Resistance to change, skill gaps, inadequate sponsorship |
| **Delivery risks** | Schedule overruns, resource constraints, vendor dependencies |
| **Architecture risks** | Overly complex architecture, standards non-compliance, insufficient stakeholder buy-in |

For each risk, document:
- Risk ID and description
- Category
- Initial risk rating (likelihood × impact)
- Mitigation actions
- Residual risk rating
- Owner

---

## Capability Assessment

The Capability Assessment evaluates the organization's current capability relative to what is needed to achieve the Architecture Vision. It examines:

- **Business Capability Assessment** — What business capabilities exist today? What capabilities are needed?
- **IT Capability Assessment** — What is the current IT maturity? Skills? Infrastructure? Tools?
- **Architecture Maturity Assessment** — How mature is the EA practice? (Often measured against maturity models like ACMM)
- **Readiness and risks** — Cross-references the Business Transformation Readiness Assessment.

The Capability Assessment helps calibrate the architecture effort — if the organization has low maturity, the architecture may need to be more prescriptive and incremental.

---

## Communications Plan

The Communications Plan defines how architecture-related information will be communicated to stakeholders throughout the ADM cycle. It is developed in Phase A and maintained throughout. It includes:

| Element | Description |
|---------|-------------|
| **Stakeholder groups** | Who needs to be communicated with |
| **Key messages** | What needs to be communicated to each group |
| **Communication channels** | How (email, meetings, dashboards, newsletters, intranet) |
| **Frequency** | How often (weekly, monthly, milestone-based) |
| **Responsible parties** | Who owns each communication |
| **Feedback mechanisms** | How stakeholders can provide input |

---

## All Inputs (Detailed)

| Input | Description | Source |
|-------|-------------|--------|
| **Request for Architecture Work** | The trigger document from the Preliminary Phase or Architecture Board | Preliminary Phase / Architecture Board |
| **Business principles, business goals, and business drivers** | The strategic business context that the architecture must address | Business leadership / Preliminary Phase |
| **Architecture Principles** | Guiding principles established in the Preliminary Phase | Preliminary Phase |
| **Enterprise Continuum** | The classification of architecture and solution assets from generic to specific | Architecture Repository |
| **Architecture Repository** | All existing architecture content — models, standards, reference materials, governance records | Architecture Repository |
| **Organizational Model for Enterprise Architecture** | EA team structure, roles, processes, governance model | Preliminary Phase |
| **Tailored Architecture Framework** | The customized version of TOGAF and any integrated frameworks | Preliminary Phase |
| **Existing architecture documentation** | Any current-state architecture descriptions, diagrams, or models | Previous ADM cycles / legacy documentation |

> **Exam Tip:** The Request for Architecture Work is the **trigger** input — it formally initiates Phase A. The other inputs provide context and constraints. Be able to identify which inputs come from the Preliminary Phase versus from the Architecture Repository.

---

## All Steps (Detailed)

### Step 1: Establish the Architecture Project

Set up the architecture project by:

- Reviewing and validating the Request for Architecture Work.
- Determining the architecture project scope and approach based on the request.
- Identifying the resources required (architects, tools, budget, timeline).
- Setting up project management structures (project plan, meeting cadence, reporting).
- Confirming alignment with the Tailored Architecture Framework.

### Step 2: Identify Stakeholders, Concerns, and Business Requirements

This is a critical early step:

- Identify ALL stakeholders — internal and external, direct and indirect.
- Classify stakeholders using the Power/Interest grid (Stakeholder Map Matrix).
- Elicit and document stakeholder concerns — what do they care about, what are they worried about?
- Capture high-level business requirements from stakeholders.
- Determine which architecture viewpoints will address each stakeholder concern.

### Step 3: Confirm and Elaborate Business Goals, Business Drivers, and Constraints

Take the business context from the inputs and refine it:

- Review strategic business goals and confirm they are still current and relevant.
- Elaborate business drivers — understand the forces compelling change at a detailed level.
- Identify constraints (regulatory, budgetary, organizational, timeline, technical).
- Map goals and drivers to potential architecture responses.
- Ensure clear traceability from business drivers to architecture decisions.

### Step 4: Evaluate Business Capabilities

Assess the organization's current business capabilities:

- Identify current business capabilities relevant to the architecture scope.
- Assess the maturity of each capability.
- Identify capability gaps that the architecture must address.
- Consider capability sourcing options (build, buy, partner, outsource).

### Step 5: Assess Readiness for Business Transformation

Perform the Business Transformation Readiness Assessment:

- Evaluate readiness factors (vision, desire, need, funding, sponsorship, capacity, etc.).
- Identify gaps between current readiness and required readiness.
- Develop mitigation actions for readiness gaps.
- Incorporate readiness findings into risk assessment.
- Use readiness assessment to influence scope, phasing, and approach.

### Step 6: Define Scope

Formally define the scope of the architecture effort:

- **Breadth** — Which enterprise units, functions, or geographies are in scope?
- **Depth** — How detailed will the architecture work be? (Strategic overview vs. detailed design)
- **Architecture domains** — Which domains will be addressed? (Business, Data, Application, Technology — or a subset)
- **Time horizon** — What is the planning horizon? (Short-term, medium-term, long-term)
- **Architecture Landscape level** — Strategic Architecture, Segment Architecture, or Capability Architecture?

### Step 7: Confirm and Elaborate Architecture Principles, Including Business Principles

Validate that the principles from the Preliminary Phase are still appropriate:

- Review architecture principles for relevance to this specific architecture engagement.
- Elaborate principles with any engagement-specific interpretations.
- Review business principles to ensure alignment.
- Identify any principle conflicts and resolve them.
- Update principles if necessary (through proper governance).

### Step 8: Develop Architecture Vision

Create the Architecture Vision document:

- Define the target state at a high level across all relevant architecture domains.
- Describe the business scenario or problem being solved.
- Articulate the business value and strategic alignment.
- Create high-level views of the target architecture (Business, Data, Application, Technology).
- Identify the gap between current state and target state (at a high level).
- Develop key diagrams: Solution Concept Diagram is the primary diagram for Phase A.

The **Solution Concept Diagram** provides a high-level graphical depiction of the proposed solution, showing the key elements and their relationships without going into detailed architecture.

### Step 9: Define the Target Architecture Value Propositions and KPIs

Articulate the value the target architecture will deliver:

- Define value propositions for each stakeholder group.
- Establish Key Performance Indicators (KPIs) that will measure architecture success.
- Create a traceability matrix from business goals → architecture capabilities → KPIs.
- Ensure KPIs are SMART (Specific, Measurable, Achievable, Relevant, Time-bound).

### Step 10: Identify the Business Transformation Risks and Mitigation Activities

Perform initial risk assessment:

- Identify risks across all categories (business, technology, organizational, delivery, architecture).
- Assess initial risk ratings (likelihood × impact).
- Develop mitigation actions for significant risks.
- Determine residual risk ratings.
- Assign risk owners.
- Incorporate readiness assessment findings.
- Create the initial risk register.

### Step 11: Develop Statement of Architecture Work; Secure Approval

Bring everything together:

- Draft the Statement of Architecture Work incorporating all findings from previous steps.
- Include scope, approach, plan, deliverables, governance, risks, and resource requirements.
- Present to stakeholders and the Architecture Board for review.
- Address feedback and concerns.
- Obtain formal sign-off and approval.
- Once approved, the architecture project is authorized to proceed to Phase B.

---

## All Outputs (Detailed)

| Output | Description |
|--------|-------------|
| **Approved Statement of Architecture Work** | The formally approved project charter for the architecture effort — scope, approach, timeline, deliverables, governance, risks, resources, and acceptance criteria |
| **Refined statements of business principles, business goals, and business drivers** | Updated and elaborated versions of the business context, validated through stakeholder engagement |
| **Architecture Principles (maybe updated)** | Architecture principles confirmed or refined for the specific engagement |
| **Architecture Vision** | High-level description of the target architecture, business value, and gap from current state; includes the Solution Concept Diagram |
| **Draft Architecture Definition Document (high-level)** | Initial version of the Architecture Definition Document, populated with high-level target architecture content from the Vision; will be elaborated in Phases B–D |
| **Communications Plan** | Defines stakeholder communication strategy — who, what, when, how, and feedback loops |
| **Additional content populating the Architecture Repository** | New or updated content added to the repository: stakeholder maps, risk registers, business goals, principles, etc. |

> **Exam Tip:** The **Approved Statement of Architecture Work** is the most important output of Phase A — it is the formal authorization to proceed. The Architecture Vision is also critical but is secondary to the Statement of Architecture Work in terms of governance significance.

---

## Relationship Between Architecture Vision and the Rest of the ADM

Phase A's Architecture Vision sets the direction that all subsequent phases follow:

```
                    ┌─────────────────────────┐
                    │   Phase A:              │
                    │   Architecture Vision   │
                    │                         │
                    │ • Sets scope & direction│
                    │ • Gains approval        │
                    │ • Identifies risks      │
                    └────────┬────────────────┘
                             │
            ┌────────────────┼────────────────┐
            │                │                │
   ┌────────▼──────┐ ┌──────▼──────┐ ┌───────▼──────┐
   │ Phase B:      │ │ Phase C:    │ │ Phase D:     │
   │ Business      │ │ IS          │ │ Technology   │
   │ Architecture  │ │ Architecture│ │ Architecture │
   │               │ │             │ │              │
   │ Elaborates    │ │ Elaborates  │ │ Elaborates   │
   │ business      │ │ data &      │ │ technology   │
   │ aspects of    │ │ application │ │ aspects of   │
   │ the Vision    │ │ aspects     │ │ the Vision   │
   └───────────────┘ └─────────────┘ └──────────────┘
```

| Relationship | Description |
|-------------|-------------|
| **Phase B** | Develops the detailed Business Architecture that realizes the business aspects of the Vision |
| **Phase C** | Develops the Information Systems Architecture (Data + Application) aligned to the Vision |
| **Phase D** | Develops the Technology Architecture to support the Vision |
| **Phase E** | Identifies implementation opportunities and solutions to realize the Vision |
| **Phase F** | Creates a migration plan to move from current state to the Vision target |
| **Phase G** | Governs implementation to ensure alignment with the Vision |
| **Phase H** | Manages changes that may require revisiting the Vision |
| **Requirements Management** | Continuously manages requirements against the Vision baseline |

The Architecture Vision is the **touchstone** that all subsequent architecture work is measured against. If the Vision changes significantly, the architecture project may need to revisit Phase A for re-approval.

---

## Exam Tips — Common Questions About Phase A

1. **Trigger for Phase A** — The Request for Architecture Work is the trigger. Without it, Phase A does not formally start.

2. **Primary output** — The Approved Statement of Architecture Work is the primary governance output. The Architecture Vision is the primary architecture content output.

3. **Stakeholder Map Matrix** — Know the Power/Interest grid and be able to classify stakeholders into the four quadrants.

4. **Business Transformation Readiness Assessment** — Know the readiness factors and understand that this assessment influences risk management and scope.

5. **Phase A is high-level** — The Architecture Vision provides a summary view, NOT detailed architecture. Detailed work happens in Phases B–D.

6. **Solution Concept Diagram** — This is the primary diagram produced in Phase A. It shows the key elements of the proposed solution at a high level.

7. **Scope dimensions** — Know the four dimensions of scope: breadth (enterprise units), depth (level of detail), architecture domains, and time horizon.

8. **Architecture principles can be updated** — While initially established in the Preliminary Phase, principles can be refined in Phase A based on the specific engagement context.

9. **Communications Plan** — Developed in Phase A, maintained throughout the ADM. Know what it contains.

10. **Phase A can be revisited** — If significant changes occur during later phases that invalidate the Vision, the ADM may cycle back to Phase A.

11. **Draft Architecture Definition Document** — Phase A produces the INITIAL version. It is progressively elaborated in Phases B, C, and D.

---

## Review Questions

### Question 1
**What is the PRIMARY trigger for Phase A?**

A) Business principles, business goals, and business drivers  
B) Architecture Vision  
C) Request for Architecture Work  
D) Statement of Architecture Work  

<details>
<summary>Answer</summary>

**C) Request for Architecture Work**

The Request for Architecture Work is the formal trigger document that initiates Phase A. It is produced in the Preliminary Phase. The Architecture Vision (B) and Statement of Architecture Work (D) are outputs of Phase A, not inputs. Business context (A) is an input but not the trigger.
</details>

---

### Question 2
**What is the PRIMARY deliverable of Phase A?**

A) Architecture Vision  
B) Request for Architecture Work  
C) Approved Statement of Architecture Work  
D) Architecture Definition Document  

<details>
<summary>Answer</summary>

**C) Approved Statement of Architecture Work**

While the Architecture Vision is important, the Approved Statement of Architecture Work is the formal governance deliverable that authorizes the architecture project to proceed. It functions as the project charter.
</details>

---

### Question 3
**In the Power/Interest stakeholder grid, a stakeholder with HIGH power and LOW interest should be:**

A) Managed closely  
B) Kept informed  
C) Kept satisfied  
D) Monitored with minimal effort  

<details>
<summary>Answer</summary>

**C) Kept satisfied**

High power, low interest stakeholders (like a CEO who has authority but isn't closely following the architecture effort) should be kept satisfied with high-level updates and consulted on critical decisions, but not burdened with detailed information.
</details>

---

### Question 4
**Which of the following is NOT a readiness factor in the Business Transformation Readiness Assessment?**

A) Vision  
B) Funding  
C) Technology vendor selection  
D) Sponsorship and Leadership  

<details>
<summary>Answer</summary>

**C) Technology vendor selection**

Technology vendor selection is not a readiness factor — it is a solution decision. The readiness factors assess organizational preparedness: vision, desire, need, business case, funding, sponsorship, governance, accountability, IT capacity, and enterprise capacity.
</details>

---

### Question 5
**The Architecture Vision document provides:**

A) Detailed technical specifications for the target environment  
B) A high-level aspirational description of the target architecture and business value  
C) A complete gap analysis between baseline and target architectures  
D) Implementation plans with timelines and resource allocations  

<details>
<summary>Answer</summary>

**B) A high-level aspirational description of the target architecture and business value**

The Architecture Vision is deliberately high-level. It communicates direction and gains buy-in. Detailed specifications (A) come from Phases B–D. Complete gap analysis (C) is done in Phases B–D. Implementation plans (D) are developed in Phase F.
</details>

---

### Question 6
**What is the primary diagram produced in Phase A?**

A) Business Footprint Diagram  
B) Application Communication Diagram  
C) Solution Concept Diagram  
D) Environments and Locations Diagram  

<details>
<summary>Answer</summary>

**C) Solution Concept Diagram**

The Solution Concept Diagram provides a high-level graphical depiction of the proposed solution. It is the primary diagram for Phase A. The other diagrams are produced in Phases B, C, and D respectively.
</details>

---

### Question 7
**Which statement about the Statement of Architecture Work is TRUE?**

A) It is produced in the Preliminary Phase  
B) It is an informal agreement that does not require formal approval  
C) It defines the architecture project scope, approach, deliverables, risks, and requires formal approval  
D) It replaces the Architecture Vision document  

<details>
<summary>Answer</summary>

**C) It defines the architecture project scope, approach, deliverables, risks, and requires formal approval**

The Statement of Architecture Work functions as a project charter and requires formal sign-off. It is produced in Phase A (not Preliminary), is formal (not informal), and complements the Architecture Vision (does not replace it).
</details>

---

### Question 8
**During Phase A, risk assessment should consider:**

A) Only technology risks  
B) Only business risks  
C) Risks across multiple categories including business, technology, organizational, and delivery  
D) Only risks that can be fully mitigated  

<details>
<summary>Answer</summary>

**C) Risks across multiple categories including business, technology, organizational, and delivery**

Risk assessment in Phase A is comprehensive, covering all risk categories. It is not limited to a single category, and it includes risks that may not be fully mitigable (residual risks are documented).
</details>

---

### Question 9
**The Communications Plan developed in Phase A:**

A) Is only used during Phase A  
B) Defines how architecture information will be communicated to stakeholders throughout the ADM cycle  
C) Is only distributed to the Architecture Board  
D) Replaces the Stakeholder Map Matrix  

<details>
<summary>Answer</summary>

**B) Defines how architecture information will be communicated to stakeholders throughout the ADM cycle**

The Communications Plan is developed in Phase A but maintained and used throughout all ADM phases. It defines the communication strategy for all stakeholders, not just the Architecture Board, and it complements the Stakeholder Map Matrix.
</details>

---

### Question 10
**Which of the following is an output of Phase A?**

A) Request for Architecture Work  
B) TOGAF Library  
C) Architecture Principles (maybe updated)  
D) Partnership and contract agreements  

<details>
<summary>Answer</summary>

**C) Architecture Principles (maybe updated)**

Architecture Principles may be refined during Phase A based on the specific engagement context. The Request for Architecture Work (A) is an input, not output. The TOGAF Library (B) is an input. Partnership agreements (D) are inputs from the Preliminary Phase.
</details>

---

### Question 11
**Phase A is best described as:**

A) A detailed design phase for all four architecture domains  
B) A phase that establishes the organizational architecture capability  
C) A visioning and scoping phase that gains approval to proceed with detailed architecture work  
D) A phase focused exclusively on technology selection  

<details>
<summary>Answer</summary>

**C) A visioning and scoping phase that gains approval to proceed with detailed architecture work**

Phase A develops the Architecture Vision and secures approval via the Statement of Architecture Work. It does not go into detailed design (A — that is Phases B–D), does not establish the architecture capability (B — that is the Preliminary Phase), and is not limited to technology (D).
</details>

---

### Question 12
**What are the four dimensions of scope defined in Phase A?**

A) Time, cost, quality, risk  
B) Breadth, depth, architecture domains, time horizon  
C) People, process, technology, data  
D) Strategy, segment, capability, solution  

<details>
<summary>Answer</summary>

**B) Breadth, depth, architecture domains, time horizon**

The four scope dimensions in Phase A are: breadth (enterprise units), depth (level of detail), architecture domains (which of B, C, D are covered), and time horizon (planning timeframe). The other options describe different TOGAF or project management concepts.
</details>

---

### Question 13
**What happens if the Architecture Vision changes significantly during Phase C?**

A) Phase C continues as planned  
B) The change is ignored until Phase H  
C) The ADM may need to cycle back to Phase A for re-approval  
D) The Architecture Repository is deleted and rebuilt  

<details>
<summary>Answer</summary>

**C) The ADM may need to cycle back to Phase A for re-approval**

If significant changes occur that invalidate the Architecture Vision, the ADM's iterative nature allows cycling back to Phase A to revise the Vision and obtain re-approval. The ADM is not a rigid waterfall — it supports iteration.
</details>

---

### Question 14
**The Business Transformation Readiness Assessment is primarily used to:**

A) Select technology vendors  
B) Evaluate whether the organization is ready for the changes implied by the architecture  
C) Define the architecture metamodel  
D) Create the Architecture Repository  

<details>
<summary>Answer</summary>

**B) Evaluate whether the organization is ready for the changes implied by the architecture**

The assessment examines organizational readiness across multiple factors (vision, desire, need, funding, sponsorship, etc.) and identifies gaps that could jeopardize the transformation. Its findings feed into risk management and may influence scope and phasing.
</details>

---

### Question 15
**Which stakeholder engagement activity is performed in Step 2 of Phase A?**

A) Creating the Architecture Repository  
B) Identifying stakeholders, their concerns, and business requirements  
C) Developing the Technology Architecture  
D) Creating architecture contracts  

<details>
<summary>Answer</summary>

**B) Identifying stakeholders, their concerns, and business requirements**

Step 2 is about stakeholder identification and classification using the Stakeholder Map Matrix. It includes eliciting concerns and capturing high-level business requirements. Architecture contracts (D) are Phase G. Technology Architecture (C) is Phase D.
</details>

---

### Question 16
**A Draft Architecture Definition Document is produced in Phase A. What happens to it in subsequent phases?**

A) It is discarded and replaced  
B) It is locked and cannot be changed  
C) It is progressively elaborated with detailed architecture content in Phases B, C, and D  
D) It is only used in Phase G  

<details>
<summary>Answer</summary>

**C) It is progressively elaborated with detailed architecture content in Phases B, C, and D**

The Architecture Definition Document begins as a high-level draft in Phase A and is progressively filled in with detailed Business Architecture (Phase B), Information Systems Architecture (Phase C), and Technology Architecture (Phase D).
</details>

---

### Question 17
**TOGAF classifies risks using which two dimensions?**

A) Probability and Impact  
B) Initial Level of Risk and Residual Level of Risk  
C) Technical Risk and Business Risk  
D) Cost and Schedule  

<details>
<summary>Answer</summary>

**B) Initial Level of Risk and Residual Level of Risk**

TOGAF uses two dimensions: the initial risk level (before mitigation) and the residual risk level (after mitigation). While probability and impact are factors within a risk level, TOGAF's specific two-dimensional classification uses initial and residual risk.
</details>

---

*← [Preliminary Phase](01-Preliminary-Phase.md) | Proceed to [Phase B: Business Architecture](03-Phase-B-Business-Architecture.md) →*
