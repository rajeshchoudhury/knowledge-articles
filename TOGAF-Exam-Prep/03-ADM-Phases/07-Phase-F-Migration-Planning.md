# Phase F — Migration Planning

## Overview

Phase F is the sixth phase of the TOGAF Architecture Development Method (ADM) cycle and marks the transition from architecture definition into implementation planning. While Phases B through D define *what* the Target Architecture looks like and Phase E identifies *how* to get there at a strategic level, Phase F is where the organization finalizes the **detailed Implementation and Migration Plan**, assigns concrete business value to every work package, and produces a prioritized, risk-assessed roadmap that the enterprise can actually execute.

Phase F sits at the critical juncture between "architecture on paper" and "architecture in practice." Poor execution of this phase is one of the most common reasons enterprise architecture initiatives fail to deliver value — the architecture may be technically sound, but without a realistic, prioritized, and well-coordinated migration plan, projects stall, budgets overrun, and stakeholder confidence erodes.

```
┌──────────────────────────────────────────────┐
│              ADM Context                      │
│                                               │
│   Phase E ──► PHASE F ──► Phase G             │
│   (Opportunities    (Migration    (Implemen-  │
│    & Solutions)      Planning)     tation      │
│                                   Governance) │
│                                               │
│   Key Transition:                             │
│   Strategic roadmap ──► Executable plan       │
│   Candidate projects ──► Prioritized projects │
│   Draft Transition  ──► Finalized Transition  │
│   Architectures          Architectures        │
└──────────────────────────────────────────────┘
```

---

## Objectives

The primary objectives of Phase F are:

1. **Finalize the Architecture Roadmap and the Implementation and Migration Plan** — Move from the draft roadmap produced in Phase E to a finalized, detailed plan that can be handed to project managers and portfolio governance bodies.
2. **Ensure the Implementation and Migration Plan is coordinated with the enterprise's management frameworks** — Align the plan with existing portfolio management, project management, and operations management processes.
3. **Assign a business value to each work package** — Perform rigorous cost/benefit analysis so that decision-makers can prioritize based on quantified business value rather than opinion.
4. **Confirm Transition Architectures** — Finalize the intermediate architecture states the enterprise will pass through on the way to the Target Architecture.
5. **Prioritize all migration projects** — Use multiple criteria (business value, risk, resource availability, stakeholder priorities, dependencies) to produce an ordered sequence of implementation projects.
6. **Ensure that the business value and cost of work packages and Transition Architectures is understood by key stakeholders** — Transparency and buy-in are essential for sustained funding and sponsorship.

---

## Key Concepts

### The Implementation and Migration Plan

The Implementation and Migration Plan is the master document (or set of documents) that describes:

| Element | Description |
|---|---|
| **Project list** | All implementation projects derived from work packages |
| **Sequencing** | The order in which projects will be executed |
| **Dependencies** | Inter-project dependencies and external dependencies |
| **Milestones** | Key checkpoints including Transition Architecture delivery dates |
| **Resource allocation** | People, budget, infrastructure, tools |
| **Risk mitigations** | Identified risks and planned responses |
| **Governance gates** | Compliance review points aligned with Phase G |
| **Business value metrics** | Expected value delivery per project/increment |

### Transition Architectures

Transition Architectures are intermediate, formally defined architecture states between the Baseline (current) and Target architectures. They exist because:

- Large transformations cannot be delivered in a single step
- The organization needs to realize incremental business value
- Risk must be managed by delivering in smaller, validated increments
- Dependencies and constraints may require specific ordering

```
Baseline         Transition       Transition       Target
Architecture     Architecture 1   Architecture 2   Architecture
    │                 │                │                │
    ▼                 ▼                ▼                ▼
┌────────┐      ┌────────┐      ┌────────┐      ┌────────┐
│ Current │ ───► │ TA-1   │ ───► │ TA-2   │ ───► │ Target │
│ State   │      │        │      │        │      │ State  │
└────────┘      └────────┘      └────────┘      └────────┘
  Year 0         Year 1          Year 2           Year 3
  
  Work Pkgs:     Work Pkgs:      Work Pkgs:
  WP-1, WP-2    WP-3, WP-4     WP-5, WP-6, WP-7
```

Each Transition Architecture is a **stable, operable** state — not a construction-in-progress snapshot. The enterprise must be able to run its operations in each Transition Architecture state.

### Business Value Assessment

Every work package must be assessed for its business value. This is a structured cost/benefit analysis that typically includes:

- **Quantitative benefits**: Revenue increase, cost reduction, efficiency gains (measured in currency)
- **Qualitative benefits**: Improved customer satisfaction, regulatory compliance, strategic positioning
- **Costs**: Implementation cost, ongoing operational cost, opportunity cost
- **Net business value**: Benefits minus costs, often expressed as ROI, NPV, or payback period
- **Time-to-value**: How quickly benefits are realized after implementation

### Implementation Factor Assessment and Deduction Matrix

The Implementation Factor Assessment evaluates real-world factors that affect implementation success:

| Factor Category | Examples |
|---|---|
| **Risks** | Technical risk, organizational change risk, market risk |
| **Issues** | Known problems, unresolved architecture gaps |
| **Assumptions** | Dependencies on external events, technology maturity |
| **Dependencies** | Inter-project dependencies, vendor timelines |
| **Actions** | Required preparatory work |
| **Impacts** | Effects on business-as-usual operations |

The **Deduction Matrix** maps these factors against work packages to determine what adjustments (deductions) should be made to business value assessments. A high-risk project might have its net business value reduced, or its priority lowered, based on the deduction matrix.

---

## Inputs

Phase F receives inputs from multiple prior phases and from the enterprise context:

| Input | Source | Purpose |
|---|---|---|
| Request for Architecture Work | Phase A / Sponsor | Original scope and constraints |
| Capability Assessment | Phase A | Current maturity and gaps |
| Communications Plan | Phase A | Stakeholder communication approach |
| Organizational Model for EA | Preliminary Phase | How EA is organized |
| Governance Models | Preliminary Phase | Existing governance structures |
| Architecture Vision | Phase A | High-level vision and value proposition |
| Architecture Repository | All phases | Reusable assets, standards, reference models |
| Draft Architecture Definition Document | Phases B, C, D | The full architecture definition |
| Draft Architecture Requirements Specification | Phases B, C, D | Formal requirements |
| Architecture Roadmap (draft) | Phase E | Draft sequencing from Opportunities & Solutions |
| Transition Architectures (draft) | Phase E | Draft intermediate states |
| Work package portfolio (draft) | Phase E | Candidate projects and work packages |
| Implementation and Migration Strategy | Phase E | High-level migration approach |
| Change Requests from prior phases | Phases B–E | Pending change requests |
| Candidate Implementation and Migration Plan | Phase E | Initial plan to be detailed |

---

## Steps in Detail

### Step 1: Confirm Management Framework Interactions

Before detailed planning begins, confirm how the Implementation and Migration Plan will interact with the enterprise's existing management frameworks:

- **Portfolio Management**: How will architecture-driven projects be integrated into the enterprise project portfolio? What is the approval process?
- **Project Management**: Which methodology (Agile, Waterfall, SAFe, PRINCE2) will implementation projects follow? How do architecture deliverables map to project deliverables?
- **Operations Management**: How will deployment to production be coordinated? What change advisory board (CAB) processes exist?
- **Procurement Management**: What procurement cycles apply for technology acquisitions?

This step is critical because the architecture plan must live within the organization's real operational context, not in an ivory tower.

### Step 2: Assign a Business Value to Each Work Package

For every work package identified in Phase E:

1. **Quantify benefits**: Work with business stakeholders to estimate revenue gains, cost savings, risk reductions, and compliance benefits.
2. **Quantify costs**: Estimate implementation cost (people, technology, facilities), ongoing cost, training cost, and transition cost.
3. **Calculate net value**: Compute ROI, NPV, IRR, or a simpler value metric appropriate for the organization.
4. **Assess time-to-value**: Determine how long after implementation before benefits are realized.
5. **Document assumptions and confidence levels**: Note the reliability of estimates.

This step often involves workshops with finance teams, business unit leaders, and technology leaders.

### Step 3: Estimate Resource Requirements and Project Timings

For each work package and resulting project:

- **People**: Roles required (architects, developers, testers, business analysts, change managers), quantities, and availability
- **Technology**: Hardware, software, licenses, cloud resources
- **Facilities**: Data center space, office space for project teams
- **Budget**: Capital expenditure and operational expenditure requirements
- **Timeline**: Duration estimates considering resource constraints, dependencies, and organizational capacity for change

Resource planning must account for the organization's **capacity for change** — how much transformation the enterprise can absorb at once without disrupting business-as-usual.

### Step 4: Prioritize through Cost/Benefit Analysis and Risk Assessment

Combine business value, cost, risk, and resource availability to produce a prioritized project list:

**Prioritization Criteria:**

| Criterion | Weight (example) | Description |
|---|---|---|
| Business value (ROI) | 30% | Quantified return on investment |
| Strategic alignment | 20% | Alignment with enterprise strategy |
| Risk (inverse) | 15% | Lower-risk projects score higher |
| Resource availability | 10% | Projects with available resources score higher |
| Dependency satisfaction | 10% | Projects with fewer unmet dependencies score higher |
| Stakeholder priority | 10% | Weight of sponsor/stakeholder advocacy |
| Time-to-value | 5% | Faster value realization scores higher |

**Common prioritization techniques:**

- **Weighted scoring model**: Assign weights and scores for each criterion
- **Pairwise comparison**: Compare projects against each other
- **MoSCoW**: Must have, Should have, Could have, Won't have
- **Value vs. Complexity matrix**: Plot projects on a 2×2 grid
- **Dependency-driven sequencing**: Let mandatory dependencies drive ordering

### Step 5: Confirm Transition Architecture Increments with Stakeholders

With prioritized projects and resource estimates, finalize the Transition Architectures:

1. Group projects into increments that deliver stable, operable architecture states
2. Validate that each Transition Architecture is coherent (no half-finished integrations)
3. Confirm with stakeholders that the sequencing delivers acceptable incremental business value
4. Verify that the transition sequence manages risk appropriately (high-risk items are not all clustered)
5. Ensure each Transition Architecture can be governed and compliance-reviewed in Phase G

### Step 6: Generate the Implementation and Migration Plan

Compile all prior analysis into the formal Implementation and Migration Plan:

- **Executive Summary**: Business case, strategic alignment, expected value delivery timeline
- **Project Portfolio**: Complete list of projects with descriptions, owners, and budgets
- **Sequencing and Dependencies**: Gantt chart or equivalent showing project timeline and dependencies
- **Transition Architecture Definitions**: Formal description of each intermediate state
- **Resource Plan**: Staffing plan, technology procurement plan, facility plan
- **Risk Management Plan**: Risk register, mitigation strategies, contingency plans
- **Governance Plan**: Compliance review schedule, architecture governance gates (feeding Phase G)
- **Communication Plan**: How progress and changes will be communicated to stakeholders
- **Value Realization Plan**: When and how benefits will be measured and reported

### Step 7: Complete the Architecture Development Cycle

Finalize the cycle by:

- Ensuring all stakeholders have reviewed and approved the plan
- Updating the Architecture Repository with finalized deliverables
- Issuing any necessary Change Requests for the Architecture Capability
- Confirming readiness to move into Phase G (Implementation Governance)
- Documenting lessons learned from the planning process

---

## Outputs

| Output | Description |
|---|---|
| **Implementation and Migration Plan (finalized)** | The complete, detailed plan for executing the architecture transformation |
| **Finalized Transition Architectures** | Formally defined intermediate architecture states with entry/exit criteria |
| **Finalized Architecture Roadmap** | The confirmed, prioritized, time-sequenced roadmap |
| **Reusable Architecture Building Blocks (ABBs)** | Architecture patterns and components identified for reuse |
| **Implementation Governance Model** | The governance approach for overseeing implementation (feeds Phase G) |
| **Architecture Contract (draft)** | Draft contracts for implementation partners and projects |
| **Change Requests for Architecture Capability** | Requests to improve the enterprise's architecture practice based on lessons learned |
| **Architecture Definition Document updates** | Any refinements discovered during planning |
| **Architecture Requirements Specification updates** | Any requirements changes discovered during planning |

---

## Interaction with Project Management Frameworks

Phase F does not replace project management — it produces the plan that project management will execute. Key interaction points:

```
┌─────────────────────┐     ┌──────────────────────┐
│  Enterprise          │     │  Project Management   │
│  Architecture (EA)   │     │  Office (PMO)         │
│                      │     │                       │
│  Phase F Produces:   │────►│  PMO Executes:        │
│  - Project portfolio │     │  - Project charters   │
│  - Sequencing        │     │  - Detailed schedules  │
│  - Dependencies      │     │  - Resource mgmt      │
│  - Business value    │     │  - Budget tracking    │
│  - Governance model  │     │  - Risk management    │
└─────────────────────┘     └──────────────────────┘
         ▲                            │
         │    Feedback Loop           │
         └────────────────────────────┘
```

**Critical integration points:**

- **Portfolio governance board** must approve the project portfolio
- **PMO** must validate resource estimates and timelines
- **Finance** must approve budget allocations
- **Operations** must confirm deployment windows and change management processes

---

## Risk Assessment in Migration Planning

Risk assessment in Phase F is multi-dimensional:

| Risk Category | Examples | Mitigation Approaches |
|---|---|---|
| **Technical** | New technology unproven, integration complexity | Proof of concept, phased rollout |
| **Organizational** | Change fatigue, skills gaps, resistance | Change management program, training |
| **Schedule** | Dependencies delayed, vendor delays | Buffer time, parallel paths |
| **Financial** | Budget cuts, cost overruns | Contingency budget, phased funding |
| **Business** | Market changes invalidate assumptions | Agile planning, shorter increments |
| **Compliance** | Regulatory changes during implementation | Regulatory monitoring, flexible architecture |

---

## Costs and Benefits of Individual Work Packages

Each work package requires a structured cost/benefit analysis:

**Cost categories:**
- **Direct costs**: Hardware, software, licenses, consulting, contractor fees
- **Labor costs**: Internal staff time, training, temporary backfill
- **Transition costs**: Data migration, parallel running, cutover activities
- **Ongoing costs**: Maintenance, support, licensing renewals, operational overhead
- **Opportunity costs**: What the organization cannot do while resources are committed

**Benefit categories:**
- **Revenue benefits**: New revenue streams, increased sales, improved pricing
- **Cost savings**: Reduced operational costs, decommissioned systems, automation savings
- **Risk reduction**: Reduced business continuity risk, improved security posture
- **Compliance benefits**: Meeting regulatory requirements, avoiding penalties
- **Strategic benefits**: Market positioning, agility, customer experience improvement
- **Intangible benefits**: Employee satisfaction, brand reputation, knowledge retention

---

## Review Questions

**Question 1:** What is the primary objective of Phase F in the TOGAF ADM?

**Answer:** To finalize the detailed Implementation and Migration Plan and to prioritize implementation projects through cost/benefit analysis, ensuring the migration from Baseline to Target Architecture is planned in a structured, business-value-driven, and risk-managed manner.

---

**Question 2:** What is a Transition Architecture?

**Answer:** A Transition Architecture is a formally defined, intermediate architecture state between the Baseline Architecture and the Target Architecture. It represents a stable, operable state that the enterprise can run in while continuing the transformation journey. Transition Architectures enable incremental value delivery and risk management.

---

**Question 3:** What is the purpose of the Implementation Factor Assessment?

**Answer:** The Implementation Factor Assessment evaluates real-world factors such as risks, issues, assumptions, dependencies, actions, and impacts that affect the feasibility and success of implementation projects. It is used alongside the Deduction Matrix to adjust business value assessments and inform prioritization decisions.

---

**Question 4:** Which phase produces the draft Architecture Roadmap that Phase F finalizes?

**Answer:** Phase E (Opportunities and Solutions) produces the draft Architecture Roadmap and candidate work packages. Phase F takes these drafts, assigns business value, performs detailed prioritization, and produces the finalized roadmap and Implementation and Migration Plan.

---

**Question 5:** Name at least four criteria used to prioritize migration projects in Phase F.

**Answer:** (1) Business value / ROI, (2) Strategic alignment, (3) Risk level, (4) Resource availability, (5) Dependency constraints, (6) Stakeholder priorities, (7) Time-to-value. Any four of these are acceptable.

---

**Question 6:** Why must Phase F confirm management framework interactions before detailed planning?

**Answer:** Because the Implementation and Migration Plan must integrate with the organization's existing portfolio management, project management, operations management, and procurement processes. If the plan does not align with how the organization actually manages work, it will not be executed effectively.

---

**Question 7:** What is the Deduction Matrix?

**Answer:** The Deduction Matrix maps implementation factors (risks, issues, dependencies) against work packages to determine what deductions (adjustments) should be applied to business value assessments. It provides a structured way to reduce the perceived value of work packages based on real-world implementation challenges.

---

**Question 8:** What is the difference between the Architecture Roadmap and the Implementation and Migration Plan?

**Answer:** The Architecture Roadmap is a high-level, time-sequenced view of work packages and Transition Architectures showing the path from Baseline to Target Architecture. The Implementation and Migration Plan is a more detailed document that includes project-level schedules, resource allocations, budgets, risk management plans, governance gates, and detailed dependency analysis. The roadmap is "what and when"; the plan is "how, with whom, and with what resources."

---

**Question 9:** What key output of Phase F feeds directly into Phase G?

**Answer:** The Implementation Governance Model and the draft Architecture Contracts feed directly into Phase G. The Implementation and Migration Plan as a whole provides the baseline against which Phase G performs governance and compliance reviews.

---

**Question 10:** How does Phase F handle the organization's capacity for change?

**Answer:** Phase F considers the organization's capacity for change when estimating resource requirements and project timings (Step 3). This means assessing how much transformation the enterprise can absorb simultaneously without disrupting business-as-usual operations. Projects are sequenced and sized to stay within this capacity.

---

**Question 11:** What types of costs should be considered when assessing work package costs?

**Answer:** Direct costs (hardware, software, licenses), labor costs (internal staff, training), transition costs (data migration, parallel running, cutover), ongoing operational costs (maintenance, support), and opportunity costs (resources unavailable for other initiatives).

---

**Question 12:** Why are Transition Architectures required to be "stable and operable"?

**Answer:** Because the enterprise must be able to run its day-to-day operations in each Transition Architecture state. These are not construction-in-progress snapshots but formally defined states with fully functional capabilities. If a Transition Architecture is not operable, the organization cannot safely pause or slow the transformation if needed.

---

**Question 13:** What role does the finance team play in Phase F?

**Answer:** The finance team helps quantify benefits (revenue, cost savings), validates cost estimates, applies financial analysis methods (ROI, NPV, IRR), approves budget allocations for the implementation portfolio, and ensures the plan aligns with financial planning cycles and constraints.

---

**Question 14:** How does Phase F relate to Agile implementation approaches?

**Answer:** Phase F can produce plans that accommodate Agile delivery methods. Rather than detailed waterfall schedules, the plan may define high-level increments (mapped to Transition Architectures) with Agile teams executing within each increment. The key requirement is that the plan establishes the sequence, dependencies, and governance gates regardless of the implementation methodology.

---

**Question 15:** What happens to the outputs of Phase F when the ADM cycle proceeds?

**Answer:** The finalized Implementation and Migration Plan, Architecture Contracts, and Implementation Governance Model are carried into Phase G (Implementation Governance), which uses them to govern the actual execution of implementation projects, perform compliance reviews, and manage changes during implementation.

---

**Question 16:** In what step of Phase F is business value formally assigned to work packages?

**Answer:** Step 2 — "Assign a Business Value to Each Work Package." This involves working with business stakeholders to quantify benefits, estimate costs, and calculate net business value for every work package.

---

**Question 17:** What is the significance of dependencies in Phase F prioritization?

**Answer:** Dependencies constrain the sequencing of projects — a project that depends on another cannot begin until its predecessor is complete. Dependencies may override pure business-value prioritization because a high-value project cannot be scheduled first if it depends on a lower-value foundational project. Phase F must balance priority scores with dependency chains to produce a feasible sequence.

---

## Summary

Phase F transforms architecture strategy into an actionable, funded, and governed implementation plan. Its core contribution is the rigorous business-value-driven prioritization of work packages, the finalization of Transition Architectures as stable milestones, and the production of a comprehensive Implementation and Migration Plan that integrates with the enterprise's real-world management frameworks. Success in Phase F requires deep collaboration between architects, business leaders, finance teams, and project management, and directly determines whether the architecture vision will be realized in practice.
