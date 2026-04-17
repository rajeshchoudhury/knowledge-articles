# Phase G — Implementation Governance

## Overview

Phase G is the phase where architecture meets reality. After months (sometimes years) of architecture development, visioning, planning, and stakeholder alignment in Phases A through F, Phase G is where the enterprise actually **builds, deploys, and governs** implementation projects to ensure they conform to the Target Architecture.

The fundamental purpose of Phase G is to provide **architecture oversight of the implementation**. It is not a project management phase — it does not manage schedules, budgets, or developer tasks. Instead, it ensures that the solutions being built and deployed are **architecture-compliant**, that deviations are identified and managed, and that the architecture delivers the business value it promised.

Phase G is sometimes misunderstood as a rubber-stamping exercise. In practice, it is one of the most critical phases because this is where the gap between "architecture as designed" and "architecture as built" becomes visible. Without rigorous implementation governance, organizations commonly experience **architecture drift** — a gradual divergence between the intended Target Architecture and the systems actually deployed.

```
┌────────────────────────────────────────────────────────┐
│                 Phase G Context                         │
│                                                         │
│   Phase F ──────────► PHASE G ──────────► Phase H       │
│   (Migration          (Implementation     (Architecture │
│    Planning)           Governance)         Change Mgmt) │
│                                                         │
│   Key Activities:                                       │
│   ┌──────────────────┐  ┌──────────────────┐            │
│   │ Architecture     │  │ Compliance       │            │
│   │ Contracts        │  │ Reviews          │            │
│   └────────┬─────────┘  └────────┬─────────┘            │
│            │                      │                      │
│            ▼                      ▼                      │
│   ┌──────────────────────────────────────┐              │
│   │   Architecture-Compliant Solutions   │              │
│   │          Deployed                     │              │
│   └──────────────────────────────────────┘              │
└────────────────────────────────────────────────────────┘
```

---

## Objectives

The primary objectives of Phase G are:

1. **Ensure conformance of the implementation with the Target Architecture** — Verify that every implementation project builds solutions that align with the architecture definition.
2. **Perform appropriate Architecture Governance functions** for the solution being implemented — Apply governance at the right level of rigor for each project.
3. **Govern and manage the Architecture Contract** — Establish formal agreements between the architecture function and implementation teams, and monitor adherence.
4. **Produce an Architecture-compliant implemented solution** — The ultimate deliverable is deployed solutions that conform to the Target Architecture.
5. **Formulate recommendations for each implementation project** — Provide architecture guidance, resolve design questions, and recommend approaches for implementation decisions.
6. **Ensure that the Implementation and Migration Plan is followed** — Monitor execution against the plan finalized in Phase F.

---

## Key Concepts

### Architecture Contract

The Architecture Contract is the **central governance instrument** of Phase G. It is a formal, joint agreement between the architecture function (the development partners responsible for defining the architecture) and the implementation partners (the teams responsible for building and deploying solutions).

**What the Architecture Contract contains:**

| Section | Content |
|---|---|
| **Introduction and background** | Context, purpose, and relationship to Architecture Vision |
| **Nature of the agreement** | Scope, duration, and parties involved |
| **Scope of the architecture** | What architecture domains and components are covered |
| **Architecture and design principles** | Principles that implementation must adhere to |
| **Conformance requirements** | Specific, measurable requirements for compliance |
| **Conformance measures** | How compliance will be assessed (reviews, metrics, testing) |
| **Interoperability requirements** | Standards and interfaces that must be supported |
| **Change management process** | How changes to the architecture or contract are handled |
| **Business metrics** | KPIs that measure whether business value is being delivered |
| **Governance and escalation** | Who governs, how disputes are resolved |
| **Signatories** | Formal sign-off by architecture and implementation leads |

**How the Architecture Contract is used:**

1. **Established at project initiation**: Before implementation begins, the contract is agreed upon between the architecture team and the implementation team
2. **Referenced during development**: Implementation teams use the contract to guide design and build decisions
3. **Assessed during compliance reviews**: The contract provides the criteria against which compliance is measured
4. **Updated when changes occur**: If approved changes alter the architecture, the contract is updated accordingly
5. **Closed at project completion**: The contract is formally closed when the implementation is deployed and accepted

```
Architecture          Architecture           Implementation
Function              Contract               Team
    │                     │                       │
    │  Define contract    │                       │
    │────────────────────►│                       │
    │                     │   Agree to contract   │
    │                     │◄──────────────────────│
    │                     │                       │
    │                     │   Build solution      │
    │                     │   (referencing         │
    │                     │    contract)           │
    │                     │──────────────────────►│
    │                     │                       │
    │  Compliance review  │                       │
    │────────────────────►│                       │
    │                     │   Report compliance   │
    │                     │◄──────────────────────│
    │                     │                       │
    │  Close contract     │                       │
    │────────────────────►│                       │
```

### Architecture Compliance Reviews

Architecture Compliance Reviews are formal evaluations that determine whether an implementation project conforms to the established architecture. They are the **primary enforcement mechanism** of Phase G.

**Types of compliance:**

| Level | Description |
|---|---|
| **Irrelevant** | The architecture specification is not applicable to this project |
| **Consistent** | The implementation is compatible with the architecture but does not directly implement it |
| **Compliant** | The implementation demonstrably satisfies all the architecture specification requirements |
| **Conformant** | The implementation fully conforms and is a complete implementation of the architecture specification |
| **Non-conformant** | The implementation does not comply; a dispensation (waiver) may be required |

**The compliance review process includes:**

1. **Schedule reviews** in alignment with project milestones and governance gates
2. **Prepare the review**: Gather architecture documentation, implementation artifacts, and contract terms
3. **Conduct the review**: Architecture team evaluates the implementation against the contract
4. **Produce the Compliance Assessment**: Document findings, level of compliance, gaps, and recommendations
5. **Issue disposition**: Accept (compliant), conditionally accept (minor gaps with remediation plan), or reject (significant non-conformance)
6. **Follow up**: Track remediation of identified gaps

### Conformance Requirements

Conformance requirements specify **what must be true** for an implementation to be considered architecture-compliant. They are derived from:

- The Architecture Definition Document (Phases B, C, D)
- The Architecture Requirements Specification
- Applicable architecture principles
- Standards, patterns, and guidelines from the Architecture Repository
- The Architecture Contract

**Categories of conformance requirements:**

- **Structural conformance**: Does the solution structure match the architecture (components, interfaces, layers)?
- **Behavioral conformance**: Does the solution behavior match specified interactions and process flows?
- **Standards conformance**: Does the solution use mandated technologies, protocols, and standards?
- **Quality conformance**: Does the solution meet non-functional requirements (performance, security, availability)?
- **Interoperability conformance**: Does the solution integrate correctly with other systems as specified?

---

## Inputs

| Input | Source | Purpose |
|---|---|---|
| Request for Architecture Work | Phase A | Original scope and mandate |
| Capability Assessment | Phase A | Baseline capabilities and gaps |
| Organizational Model for EA | Preliminary Phase | Architecture governance structure |
| Governance Models | Preliminary Phase | Existing enterprise governance |
| Architecture Vision | Phase A | High-level vision and value targets |
| Architecture Definition Document | Phases B, C, D | The complete architecture definition |
| Architecture Requirements Specification | Phases B, C, D | Formal architecture requirements |
| Architecture Roadmap (finalized) | Phase F | Sequenced transformation plan |
| Implementation and Migration Plan (finalized) | Phase F | Detailed execution plan |
| Implementation Governance Model | Phase F | How governance will be applied |
| Transition Architectures (finalized) | Phase F | Intermediate target states |
| Architecture Contract (draft) | Phase F | Draft agreement to be formalized |
| Change Requests (from prior phases) | All phases | Pending change requests |
| Architecture Repository | All phases | Standards, patterns, building blocks |

---

## Steps in Detail

### Step 1: Confirm Scope and Priorities for Deployment with Development Management

At the outset of Phase G, confirm with development management and project leads:

- Which projects are in scope for this governance cycle
- The priority order for deployment
- The timeline and milestones from the Implementation and Migration Plan
- Any changes in business context since Phase F that affect priorities
- The governance rigor level appropriate for each project (larger, higher-risk projects warrant more intensive governance)

This step establishes a shared understanding between the architecture function and implementation teams about what will be governed and how.

### Step 2: Identify Deployment Resources and Skills

Ensure that the right resources are available for implementation governance:

- **Architecture resources**: Architects with the right domain expertise to review implementations
- **Review infrastructure**: Tools, environments, and processes for conducting compliance reviews
- **Testing resources**: Environments for integration testing, performance testing, and security testing
- **Governance support**: Administrative support for scheduling reviews, tracking findings, managing contracts

Also identify any skills gaps in the implementation teams that could affect their ability to build architecture-compliant solutions, and plan for training or supplementary resources.

### Step 3: Guide Development of Solutions Deployment

Throughout the implementation, the architecture function provides ongoing guidance:

- **Design reviews**: Review solution designs before coding begins to catch non-conformance early
- **Architecture consultations**: Be available to answer questions from implementation teams about architecture intent and requirements
- **Pattern guidance**: Direct teams to approved architecture patterns and building blocks
- **Decision support**: Help resolve trade-offs between architecture conformance and practical implementation constraints
- **Standards clarification**: Clarify which standards apply and how they should be implemented

This is a proactive, collaborative activity — not just a policing function. The goal is to help implementation teams succeed, not to catch them failing.

### Step 4: Perform Enterprise Architecture Compliance Reviews

Execute the compliance review process described in the Key Concepts section:

- **Conduct reviews at governance gates** defined in the Implementation and Migration Plan
- **Evaluate each project** against its Architecture Contract
- **Produce Compliance Assessments** documenting the level of conformance
- **Issue findings and recommendations**: Identify gaps, risks, and required remediation
- **Track remediation**: Ensure non-conformance issues are resolved within agreed timeframes
- **Escalate when necessary**: If significant non-conformance cannot be resolved at the project level, escalate to the Architecture Board or governance body

Compliance reviews should be scheduled at key project milestones: after design, after build, before deployment, and after deployment.

### Step 5: Implement Business and IT Operations

As solutions are deployed, ensure that the operational aspects are properly addressed:

- **Operational readiness**: Verify that operations teams are trained and prepared to support the new solutions
- **Service level agreements**: Confirm that SLAs are defined and achievable
- **Monitoring and alerting**: Ensure that the deployed solutions are properly monitored
- **Support processes**: Verify that incident management, problem management, and change management processes are updated for the new solutions
- **Business process changes**: Confirm that business process changes required by the new architecture are implemented and staff are trained

### Step 6: Perform Post-Implementation Review and Close the Implementation

After deployment:

1. **Post-implementation review**: Assess whether the implementation achieved its objectives and delivered the expected business value
2. **Lessons learned**: Document what went well and what could be improved for future implementation governance
3. **Architecture Repository update**: Update the repository with the as-built architecture, solution building blocks, and any new patterns discovered
4. **Architecture Contract closure**: Formally close the Architecture Contract for completed projects
5. **Residual risk assessment**: Identify any ongoing risks that need to be managed in operations
6. **Handover to operations**: Formally hand over responsibility from the project team to operations
7. **Feed forward to Phase H**: Document any change requests or architecture updates needed for Phase H (Architecture Change Management)

---

## Outputs

| Output | Description |
|---|---|
| **Architecture Contract (signed)** | Formal agreement between architecture function and implementation teams |
| **Compliance Assessments** | Formal evaluations of each project's architecture conformance |
| **Change Requests** | Requests to change the architecture based on implementation discoveries |
| **Architecture-compliant solutions deployed** | The primary deliverable — working solutions that conform to the Target Architecture |
| **Architecture Repository updates** | Solution Building Blocks, patterns, and as-built documentation |
| **Implementation Governance recommendations** | Recommendations for improving governance in future cycles |
| **Post-implementation review reports** | Assessment of implementation success and lessons learned |
| **Impact analysis on Architecture Landscape** | Assessment of how deployed solutions affect the overall enterprise architecture |

---

## Change Management During Implementation

Change is inevitable during implementation. Phase G must have a robust change management process:

```
┌──────────────┐     ┌──────────────┐     ┌──────────────┐
│ Change       │     │ Impact       │     │ Disposition  │
│ Request      │────►│ Assessment   │────►│              │
│ Raised       │     │              │     │ - Approve    │
└──────────────┘     └──────────────┘     │ - Defer      │
                                          │ - Reject     │
                                          │ - Escalate   │
                                          └──────┬───────┘
                                                 │
                          ┌──────────────────────┼──────────────────────┐
                          │                      │                      │
                          ▼                      ▼                      ▼
                   ┌────────────┐        ┌────────────┐        ┌────────────┐
                   │ Update     │        │ Log for    │        │ Trigger    │
                   │ Contract & │        │ next ADM   │        │ Phase H    │
                   │ Continue   │        │ cycle      │        │ review     │
                   └────────────┘        └────────────┘        └────────────┘
```

**Types of changes during implementation:**

- **Minor technical changes**: Can be handled within the implementation team, with Architecture Contract update
- **Architecture-affecting changes**: Must go through architecture impact assessment and may require Architecture Contract amendment
- **Scope changes**: Must be assessed for impact on the overall Implementation and Migration Plan, may require re-planning
- **Business requirement changes**: Must be fed back to Requirements Management and may trigger Phase H

**Key principles:**

- All changes must be assessed for architecture impact before approval
- Changes that affect the Architecture Contract require formal amendment
- Significant changes may need to be deferred to the next ADM cycle
- The goal is to protect architecture integrity while accommodating legitimate change needs

---

## Relationship Between Governance and Change Management

Governance and change management are deeply intertwined in Phase G:

| Governance | Change Management |
|---|---|
| Establishes the rules (Architecture Contract) | Manages exceptions to the rules |
| Conducts compliance reviews | Processes change requests that arise from reviews |
| Ensures conformance | Evaluates and approves deviations when justified |
| Monitors implementation progress | Responds to implementation discoveries and issues |
| Escalates non-conformance | Provides a structured process to resolve non-conformance |

Governance without change management is rigid and impractical. Change management without governance is chaotic and leads to architecture drift. Phase G requires both, working in concert.

---

## Deployment Planning

Deployment planning within Phase G encompasses:

- **Environment management**: Development, testing, staging, and production environment readiness
- **Data migration**: Planning and executing data migration activities for each deployment
- **Cutover planning**: Defining the cutover approach (big bang, phased, parallel running)
- **Rollback planning**: Defining rollback procedures if deployment fails
- **Communication**: Notifying stakeholders, end users, and support teams about deployments
- **Training**: Ensuring end users and support staff are trained before go-live
- **Verification**: Post-deployment verification that the solution is functioning correctly

---

## Business and IT Operating Model for Implementation

Phase G must ensure that the implementation is supported by appropriate operating models:

**Business Operating Model considerations:**
- Business process changes required by the new architecture
- Organizational structure changes (new roles, changed responsibilities)
- Performance measurement and reporting changes
- Customer interaction changes

**IT Operating Model considerations:**
- Service management processes (ITIL-aligned)
- Infrastructure operations and monitoring
- Application support and maintenance
- Security operations
- Disaster recovery and business continuity

---

## Review Questions

**Question 1:** What is the primary objective of Phase G in the TOGAF ADM?

**Answer:** To ensure conformance of implementation projects with the Target Architecture by providing architecture oversight through Architecture Contracts, compliance reviews, and ongoing governance throughout the implementation lifecycle.

---

**Question 2:** What is an Architecture Contract?

**Answer:** An Architecture Contract is a formal, joint agreement between the architecture function (development partners) and the implementation partners. It specifies the scope, conformance requirements, design principles, interoperability requirements, business metrics, and governance processes that the implementation must adhere to. It is the primary governance instrument of Phase G.

---

**Question 3:** What are the five levels of architecture compliance?

**Answer:** (1) Irrelevant — the architecture specification is not applicable, (2) Consistent — compatible with but does not directly implement the architecture, (3) Compliant — demonstrably satisfies all requirements, (4) Conformant — fully conforms and completely implements the specification, (5) Non-conformant — does not comply, a dispensation may be required.

---

**Question 4:** Who are the parties to an Architecture Contract?

**Answer:** The development partners (those responsible for defining the architecture) and the implementation partners (those responsible for building and deploying solutions). Both parties formally sign the contract.

---

**Question 5:** When should compliance reviews be scheduled?

**Answer:** Compliance reviews should be scheduled at key project milestones: after design completion, after build completion, before deployment to production, and after deployment. They should align with the governance gates defined in the Implementation and Migration Plan.

---

**Question 6:** What is the difference between Phase G and project management?

**Answer:** Phase G provides architecture governance and oversight — ensuring solutions conform to the Target Architecture. Project management manages schedules, budgets, resources, and tasks. Phase G does not replace project management; it works alongside it to ensure that what is built is architecturally sound, while project management ensures it is built on time and within budget.

---

**Question 7:** What happens when a compliance review identifies non-conformance?

**Answer:** Non-conformance findings are documented in the Compliance Assessment. Depending on severity: minor issues may result in a remediation plan with an agreed timeline; significant issues may require architecture change requests, contract amendments, or escalation to the Architecture Board. The disposition may be to accept with conditions, defer to the next cycle, or require immediate correction.

---

**Question 8:** What is "architecture drift" and how does Phase G prevent it?

**Answer:** Architecture drift is the gradual divergence between the intended Target Architecture and the systems actually built and deployed. Phase G prevents it through formal Architecture Contracts that define conformance requirements, regular compliance reviews that detect deviations, and a structured change management process that ensures any deviations are intentional and approved.

---

**Question 9:** What inputs does Phase G receive from Phase F?

**Answer:** Phase G receives the finalized Implementation and Migration Plan, finalized Architecture Roadmap, finalized Transition Architectures, Implementation Governance Model, and draft Architecture Contracts from Phase F.

---

**Question 10:** How does Phase G handle changes discovered during implementation?

**Answer:** Through a structured change management process: changes are raised as Change Requests, assessed for architecture impact, and then either approved (with Architecture Contract updates), deferred to the next ADM cycle, rejected, or escalated to the Architecture Board. The goal is to protect architecture integrity while accommodating legitimate change needs.

---

**Question 11:** What does "operational readiness" mean in Phase G?

**Answer:** Operational readiness means that operations teams are trained and prepared to support the new solutions, SLAs are defined, monitoring and alerting are in place, support processes (incident, problem, change management) are updated, and business process changes are implemented with staff training completed.

---

**Question 12:** What is a post-implementation review?

**Answer:** A post-implementation review is an assessment conducted after deployment that evaluates whether the implementation achieved its objectives, delivered the expected business value, and conformed to the architecture. It also captures lessons learned, identifies residual risks, and generates inputs for Phase H (Architecture Change Management).

---

**Question 13:** What is the relationship between compliance reviews and Architecture Contracts?

**Answer:** The Architecture Contract defines the conformance requirements and measures. Compliance reviews evaluate the implementation against those requirements. The contract is the "what must be true" document; the compliance review is the "is it actually true" assessment. They work together as the core governance mechanism.

---

**Question 14:** What outputs does Phase G produce that feed into Phase H?

**Answer:** Change Requests (requests to change the architecture based on implementation discoveries), post-implementation review reports (lessons learned and residual issues), and Impact Analysis on the Architecture Landscape all feed into Phase H for architecture change management.

---

**Question 15:** What is the role of the Architecture Board during Phase G?

**Answer:** The Architecture Board serves as the escalation point for governance issues, approves or rejects significant change requests, adjudicates disputes between architecture and implementation teams, grants dispensations for non-conformance when justified, and provides overall oversight of the implementation governance process.

---

**Question 16:** Why is Phase G described as collaborative rather than just policing?

**Answer:** Because Phase G includes proactive guidance activities — design reviews, architecture consultations, pattern guidance, and decision support — that help implementation teams succeed. The goal is to build architecture-compliant solutions, not merely to catch failures. This collaborative approach increases compliance rates and reduces adversarial dynamics between architecture and implementation teams.

---

**Question 17:** What role does deployment planning play within Phase G?

**Answer:** Deployment planning within Phase G ensures that environments are ready, data migration is planned, cutover approaches are defined, rollback procedures are in place, stakeholders and users are notified, training is completed, and post-deployment verification confirms the solution functions correctly. It bridges the gap between development completion and operational readiness.

---

## Summary

Phase G is where the enterprise architecture transitions from plans and documents into working, deployed solutions. Its core mechanism is the Architecture Contract — a formal agreement between architecture and implementation teams that defines what "architecture compliance" means. Through regular compliance reviews, ongoing guidance, and structured change management, Phase G ensures that what gets built matches what was designed. The phase concludes with post-implementation reviews that capture lessons learned and feed into Phase H for ongoing architecture change management. Without effective Phase G governance, even the best-designed architecture will suffer from drift and dilution as implementation realities diverge from architectural intent.
