# Requirements Management

## Overview

Requirements Management is **not a phase** in the sequential sense — it is the **central, continuous process** at the heart of the TOGAF ADM cycle. While all other phases (Preliminary through H) operate in a broadly sequential flow, Requirements Management operates throughout every phase, managing the flow of architecture requirements into, out of, and between all ADM phases.

On the ADM cycle diagram, Requirements Management is depicted at the **center** of the circle, connected to every phase. This placement is deliberate and significant: it reflects the reality that requirements drive every phase and that changes to requirements can arise at any point in the cycle. No phase operates in isolation from requirements.

```
                    ┌──────────┐
                    │ Prelim   │
                    │ Phase    │
                    └────┬─────┘
                         │
              ┌──────────┴──────────┐
              │                     │
         ┌────┴────┐          ┌────┴────┐
         │ Phase H │          │ Phase A │
         │         │          │         │
         └────┬────┘          └────┬────┘
              │                     │
         ┌────┴────┐          ┌────┴────┐
         │ Phase G │          │ Phase B │
         │         │          │         │
         └────┬────┘          └────┬────┘
              │    ┌──────────┐    │
              │    │REQUIREM- │    │
              └───►│ENTS      │◄───┘
              ┌───►│MANAGEMENT│◄───┐
              │    │(Center)  │    │
              │    └──────────┘    │
         ┌────┴────┐          ┌────┴────┐
         │ Phase F │          │ Phase C │
         │         │          │         │
         └────┬────┘          └────┴────┘
              │                     │
         ┌────┴────┐          ┌────┴────┐
         │ Phase E │          │ Phase D │
         │         │          │         │
         └─────────┴──────────┴─────────┘
```

Requirements Management ensures that:
- Requirements are **identified** and **documented** consistently
- Requirements are **stored** in a managed repository
- Requirements **flow** to the appropriate phase when needed
- **Changes** to requirements are assessed, approved, and communicated
- Requirements remain **traceable** throughout the architecture lifecycle
- **Conflicts** between requirements are identified and resolved
- Requirements are **prioritized** to guide architecture decisions

---

## Objectives

The objectives of Requirements Management are:

1. **Ensure that the Requirements Management process is sustained and operates for all relevant ADM phases** — Requirements Management must be active during every phase, not just during initial requirements gathering.
2. **Manage architecture requirements identified during any execution of the ADM cycle** — Requirements can emerge at any point; the process must capture them regardless of origin.
3. **Ensure that relevant architecture requirements are available for use by each phase as the phase executes** — Each phase needs access to the requirements that are relevant to its work.
4. **Ensure that a set of baseline requirements is established before detailed architecture work begins** — Provide a stable foundation for architecture development.
5. **Provide a process for managing requirements across the entire ADM cycle** — A single, consistent process rather than ad-hoc handling in each phase.

---

## Key Concepts

### Why Requirements Management Is Central to ADM Success

Requirements Management is central because **every architecture decision is ultimately driven by a requirement**. Without robust requirements management:

- Architecture work may solve the wrong problems
- Conflicting requirements from different stakeholders go unresolved
- Changes to requirements are not communicated, leading to architectural misalignment
- Traceability is lost — nobody can explain why a particular architecture decision was made
- Scope creep occurs unchecked because there is no baseline against which to measure new requests
- Prioritization is ad-hoc and politically driven rather than systematically managed

The central position also reflects the reality that **requirements are iterative**. Initial requirements captured in Phase A are refined in Phase B, further detailed in Phase C, and may be modified based on discoveries in Phases D, E, F, G, and H. Requirements Management provides the continuity that holds this iterative process together.

### The Requirements Repository

The Requirements Repository is the managed store for all architecture requirements. It is part of the broader Architecture Repository and contains:

| Content | Description |
|---|---|
| **Requirements catalog** | Master list of all identified requirements with unique identifiers |
| **Requirements baseline** | The approved set of requirements at a point in time |
| **Requirements status** | Current status of each requirement (proposed, approved, implemented, deferred, rejected) |
| **Requirements traceability** | Links from requirements to architecture components, work packages, and stakeholders |
| **Requirements history** | Change history showing how requirements have evolved |
| **Impact assessments** | Records of impact assessments performed for requirements changes |
| **Priority assignments** | Priority classification for each requirement |
| **Stakeholder mapping** | Which stakeholders raised or are affected by each requirement |

### Architecture Requirements Specification

The Architecture Requirements Specification is a formal document that captures the detailed requirements that the architecture must satisfy. It includes:

- **Functional requirements**: What the architecture must do (business processes, capabilities, information flows)
- **Non-functional requirements**: Quality attributes the architecture must exhibit (performance, security, availability, scalability, usability)
- **Architecture constraints**: Limitations imposed by business, technology, regulatory, or organizational factors
- **Assumptions**: Conditions assumed to be true for the requirements to be valid
- **Dependencies**: Requirements that depend on other requirements or external factors
- **Acceptance criteria**: How fulfillment of each requirement will be verified

The Architecture Requirements Specification is produced initially in Phase A and refined throughout Phases B, C, and D as detailed architecture work uncovers additional requirements or clarifies existing ones.

### How Requirements Flow In and Out of Each ADM Phase

Every ADM phase both **consumes** and **produces** requirements:

| Phase | Requirements Consumed | Requirements Produced |
|---|---|---|
| **Preliminary** | Enterprise-level constraints, principles | Architecture principles as high-level requirements |
| **Phase A** | Business goals, stakeholder concerns | Architecture Vision requirements, initial Architecture Requirements Specification |
| **Phase B** | Business architecture requirements | Refined business requirements, gap-identified requirements |
| **Phase C** | Information systems requirements | Refined data and application requirements |
| **Phase D** | Technology architecture requirements | Refined technology requirements |
| **Phase E** | All requirements for solution evaluation | Requirements for work packages, implementation constraints |
| **Phase F** | Requirements for prioritization and planning | Resource and timeline requirements, migration requirements |
| **Phase G** | Conformance requirements for governance | Change-driven requirements from implementation |
| **Phase H** | Requirements for change assessment | New/modified requirements from change drivers |

```
Requirements Flow Pattern:
                                          
Phase A ──requirements──► Req Mgmt ──requirements──► Phase B
Phase B ──requirements──► Req Mgmt ──requirements──► Phase C
Phase C ──requirements──► Req Mgmt ──requirements──► Phase D
   ...and so on for every phase...

Phase G ──change-driven──► Req Mgmt ──updated──► Phase H
Phase H ──new cycle──► Req Mgmt ──baseline──► Phase A (next cycle)
```

### Requirements Prioritization Techniques

Multiple techniques can be used to prioritize requirements:

#### MoSCoW Method

| Priority | Meaning | Guidelines |
|---|---|---|
| **Must have** | Non-negotiable requirements essential for the architecture to be viable | Without these, the architecture fails. Typically 60% or less of effort. |
| **Should have** | Important requirements that add significant value | The architecture would be significantly diminished without them. Typically 20% of effort. |
| **Could have** | Desirable requirements that would be nice to include | These are included if time and resources permit. Typically 20% of effort. |
| **Won't have (this time)** | Requirements explicitly deferred to a future cycle | Acknowledged as valid but not addressed in this iteration. |

#### Other Prioritization Techniques

| Technique | Description |
|---|---|
| **Weighted scoring** | Assign weights to criteria (business value, risk, cost, strategic alignment) and score each requirement |
| **Pairwise comparison** | Compare requirements in pairs to establish relative priority |
| **Kano model** | Classify requirements as basic (expected), performance (proportional satisfaction), or excitement (delighters) |
| **Business value vs. effort matrix** | Plot requirements on a 2×2 grid to identify quick wins, major projects, fill-ins, and thankless tasks |
| **Stakeholder voting** | Allow stakeholders to allocate a fixed number of votes across requirements |
| **Risk-based prioritization** | Prioritize requirements that mitigate the highest risks |
| **Dependency-driven** | Prioritize foundational requirements that other requirements depend on |

### Stakeholder Requirements Management

Different stakeholders contribute different types of requirements:

| Stakeholder | Typical Requirements |
|---|---|
| **Executive sponsors** | Strategic alignment, ROI, competitive advantage |
| **Business unit leaders** | Business process support, productivity, customer experience |
| **IT management** | Operational efficiency, maintainability, security, standards compliance |
| **End users** | Usability, performance, functionality |
| **Regulators** | Compliance, audit trails, data protection |
| **Customers** | Service quality, availability, data privacy |
| **Partners** | Integration, interoperability, data exchange |
| **Architecture team** | Consistency, reuse, scalability, modularity |

Managing competing stakeholder requirements is one of the most challenging aspects of Requirements Management. The process must:

1. **Capture** requirements from all relevant stakeholders
2. **Identify conflicts** between requirements from different stakeholders
3. **Facilitate resolution** through negotiation, trade-off analysis, or escalation
4. **Document decisions** including rationale for prioritization choices
5. **Communicate** back to stakeholders about the disposition of their requirements

### Requirements Traceability

Traceability links requirements to architecture components, decisions, and deliverables:

```
Requirement ──► Architecture Component ──► Work Package ──► Implementation
    │                    │                      │                │
    │                    │                      │                │
    ▼                    ▼                      ▼                ▼
Business           Architecture          Migration         Deployed
Goal               Decision              Plan              Solution
```

**Traceability enables:**
- **Impact analysis**: When a requirement changes, identify all affected architecture components and projects
- **Completeness verification**: Confirm that every requirement is addressed by at least one architecture component
- **Justification**: Explain why each architecture decision was made (which requirement drove it)
- **Coverage analysis**: Identify requirements that are not yet addressed (gaps)
- **Change management**: When architecture components change, identify which requirements are affected

A traceability matrix is the typical tool:

| Requirement ID | Description | Architecture Component | Work Package | Status |
|---|---|---|---|---|
| REQ-001 | 24/7 availability for customer portal | App Server Cluster, Load Balancer, DR Site | WP-03 | Implemented |
| REQ-002 | Sub-second response for order lookup | In-memory cache, Optimized query layer | WP-05 | In Progress |
| REQ-003 | GDPR data subject access requests | Data catalog, PII detection, Export API | WP-02 | Approved |

### Change Requests for Requirements

Requirements change requests can originate from:

- **New stakeholder needs**: Business changes generate new requirements
- **Implementation discoveries**: Building the solution reveals requirements that were missed or misunderstood
- **Technology changes**: New technology capabilities enable new requirements or invalidate existing ones
- **Regulatory changes**: New regulations impose new compliance requirements
- **Defects**: Issues in implemented solutions reveal requirements gaps
- **Phase H feedback**: Operational experience identifies needed improvements

The change request process for requirements follows the same pattern as other change requests:

1. **Submit**: Document the proposed change with justification
2. **Classify**: Determine scope and urgency
3. **Assess impact**: Evaluate the effect on architecture, schedule, budget, and other requirements
4. **Decide**: Approve, reject, or defer
5. **Implement**: Update the Requirements Repository and communicate to affected phases
6. **Verify**: Confirm the change was properly incorporated

---

## Inputs

| Input | Source | Purpose |
|---|---|---|
| Architecture Requirements Specification (current) | Phases B, C, D | The current set of detailed requirements |
| Requirements Repository (current) | All phases | The managed store of all requirements |
| Architecture Vision | Phase A | High-level requirements and constraints |
| Stakeholder Map | Phase A | Who contributes requirements |
| Architecture Definition Document | Phases B, C, D | Architecture components that requirements map to |
| Architecture Roadmap | Phase F | Planned implementation sequence |
| Change Requests | Any phase, Phase G, Phase H | Proposed changes to requirements |
| Post-implementation reviews | Phase G | Lessons learned that generate new requirements |
| Value realization reports | Phase H | Performance gaps that generate requirements |
| Gap analysis results | Phases B, C, D | Gaps that translate into requirements |
| Organizational constraints | Preliminary Phase | Enterprise-level constraints on requirements |

---

## Steps in Detail

### Step 1: Identify and Document Requirements

Gather requirements from all relevant sources:

- **Stakeholder interviews and workshops**: Elicit requirements directly from stakeholders
- **Business strategy documents**: Extract requirements from strategic plans, business cases, and vision statements
- **Regulatory and compliance sources**: Identify requirements from regulations, standards, and audit findings
- **Existing architecture documentation**: Extract requirements from current architecture artifacts
- **Gap analysis**: Translate identified gaps into formal requirements
- **Benchmarking**: Compare with industry best practices to identify improvement requirements

For each requirement, document:
- Unique identifier
- Description
- Source (who raised it / where it came from)
- Priority (initial)
- Type (functional, non-functional, constraint)
- Acceptance criteria
- Dependencies
- Affected architecture domains

### Step 2: Baseline Requirements

Establish a requirements baseline — a formally approved set of requirements that serves as the foundation for architecture work:

- **Review and validate** all identified requirements with stakeholders
- **Resolve conflicts** between requirements through facilitated discussions
- **Gain formal approval** from the Architecture Board or designated authority
- **Establish the baseline** in the Requirements Repository with version control
- **Communicate the baseline** to all ADM phase teams

The baseline is not immutable — it can be changed, but only through the formal change management process. This prevents scope creep while allowing necessary evolution.

### Step 3: Monitor Baseline Requirements

Continuously monitor the requirements baseline throughout the ADM cycle:

- **Track requirements status**: Monitor which requirements are being addressed, which are deferred, which are at risk
- **Detect requirement conflicts**: As detailed architecture work proceeds, new conflicts may emerge
- **Verify completeness**: Ensure all baseline requirements have corresponding architecture components
- **Monitor external changes**: Watch for business, regulatory, or technology changes that affect requirements validity
- **Report status**: Provide regular requirements status reports to stakeholders and the Architecture Board

### Step 4: Identify Changed Requirements

Detect requirements that need to change based on:

- **Architecture work discoveries**: Detailed architecture analysis reveals requirements that are incomplete, incorrect, or infeasible
- **Stakeholder feedback**: Ongoing stakeholder engagement surfaces changed needs
- **External factors**: Business, market, regulatory, or technology changes
- **Constraint changes**: Budget, timeline, or resource constraints that affect what can be achieved
- **Priority shifts**: Business priorities change, affecting requirements priorities

### Step 5: Identify Changed Requirements from Implementation Lessons

Specifically capture requirements changes driven by implementation experience:

- **Phase G findings**: Compliance reviews reveal requirements that were unclear or missing
- **Implementation team feedback**: Developers and integrators identify requirements issues
- **Testing results**: Test execution reveals requirements gaps or conflicts
- **Deployment experience**: Production deployment reveals operational requirements not previously identified
- **User feedback**: End users identify requirements gaps after initial exposure to the solution

This step creates a critical feedback loop from implementation back to requirements.

### Step 6: Manage Requirements

Perform ongoing requirements management activities:

- **Maintain the Requirements Repository**: Keep all requirements data current and accurate
- **Manage requirements lifecycle**: Track each requirement through its lifecycle (proposed → approved → in progress → implemented → verified)
- **Manage dependencies**: Track and communicate inter-requirement dependencies
- **Manage priorities**: Re-prioritize requirements as business context changes
- **Manage conflicts**: Identify and resolve conflicting requirements
- **Support architecture decisions**: Provide requirements information to support decisions in all phases

### Step 7: Assess Impact of Requirement Changes

When requirements change, perform a formal impact assessment:

- **Architecture impact**: Which architecture components are affected? How much rework is needed?
- **Project impact**: Which work packages and projects are affected? What schedule and cost changes result?
- **Other requirements impact**: Which other requirements are affected by this change (through dependencies)?
- **Stakeholder impact**: Which stakeholders are affected? Do they need to be consulted?
- **Risk impact**: Does the change introduce new risks or mitigate existing ones?

The impact assessment informs the decision to approve, reject, or defer the change.

```
Requirements Impact Assessment Process:

Changed Requirement
        │
        ▼
┌───────────────────┐
│ Identify Affected │
│ - Architecture    │
│ - Projects        │
│ - Requirements    │
│ - Stakeholders    │
│ - Risks           │
└────────┬──────────┘
         │
         ▼
┌───────────────────┐
│ Quantify Impact   │
│ - Effort          │
│ - Cost            │
│ - Schedule        │
│ - Risk            │
└────────┬──────────┘
         │
         ▼
┌───────────────────┐
│ Recommendation    │
│ - Approve         │
│ - Reject          │
│ - Defer           │
│ - Modify          │
└───────────────────┘
```

### Step 8: Implement Requirements Arising from Phase H

When Phase H identifies the need for architecture changes, new or modified requirements are generated:

- **Receive change requirements from Phase H**: These may result from technology changes, business changes, lessons learned, or compliance findings
- **Document as formal requirements**: Enter into the Requirements Repository with full documentation
- **Assess impact**: Perform impact assessment against the current architecture and requirements baseline
- **Prioritize**: Determine priority relative to other pending requirements
- **Route to appropriate phase**: Direct the requirements to the phase(s) that need to address them

### Step 9: Update the Requirements Repository

Maintain the Requirements Repository as the single source of truth:

- **Apply approved changes**: Update requirements records to reflect approved changes
- **Update traceability**: Maintain traceability links as requirements and architecture components evolve
- **Archive resolved items**: Move completed, rejected, or obsoleted requirements to archive
- **Version control**: Maintain version history for all requirements changes
- **Validate integrity**: Periodically verify that the repository is consistent and complete

### Step 10: Implement Change in Current or Future ADM Phases

Route approved requirements changes to the appropriate ADM phases:

- **Current cycle changes**: If the change affects a phase currently in progress, communicate the change immediately and assess whether rework is needed
- **Future phase changes**: If the change affects a downstream phase, update the requirements that will be consumed by that phase
- **Next cycle changes**: If the change is deferred to the next ADM cycle, tag it appropriately in the Requirements Repository and ensure it is included in the next cycle's requirements baseline
- **Cross-phase changes**: If the change affects multiple phases, coordinate communication and impact management across all affected phases

---

## Outputs

| Output | Description |
|---|---|
| **Requirements Impact Assessment** | Formal analysis of the impact of proposed requirements changes on architecture, projects, costs, schedules, and risks |
| **Architecture Requirements Specification (updated)** | The formal requirements document updated to reflect approved changes throughout the ADM cycle |
| **Requirements Repository (updated)** | The managed store with all requirements current, traceable, and version-controlled |
| **Change Requests for Requirements** | Formal requests for requirements changes, with impact assessments and recommendations |
| **Requirements status reports** | Regular reports on requirements status, coverage, conflicts, and changes |

---

## How Requirements Are Managed Across All ADM Phases

The interaction between Requirements Management and each ADM phase is specific and structured:

### Preliminary Phase
- Identify enterprise-level constraints and principles that become high-level requirements
- Establish the Requirements Management process itself

### Phase A — Architecture Vision
- Capture high-level business requirements and stakeholder concerns
- Produce the initial Architecture Requirements Specification
- Establish the requirements baseline

### Phase B — Business Architecture
- Refine business requirements based on detailed business architecture analysis
- Identify new requirements from gap analysis
- Resolve conflicts between business requirements

### Phase C — Information Systems Architectures
- Refine data and application requirements based on detailed IS architecture analysis
- Identify new requirements for data management, application functionality, and integration
- Resolve conflicts between IS requirements and business requirements

### Phase D — Technology Architecture
- Refine technology requirements based on detailed technology architecture analysis
- Identify new requirements for infrastructure, platforms, and deployment
- Resolve conflicts between technology constraints and higher-level requirements

### Phase E — Opportunities and Solutions
- Evaluate requirements against candidate solutions
- Identify implementation-specific requirements (ordering, grouping, timing)
- Manage requirements across work packages

### Phase F — Migration Planning
- Use requirements to inform prioritization and sequencing
- Identify migration-specific requirements (transition state requirements)
- Manage requirements for Transition Architectures

### Phase G — Implementation Governance
- Use requirements as conformance criteria in compliance reviews
- Capture new requirements arising from implementation experience
- Manage change requests that affect requirements

### Phase H — Architecture Change Management
- Generate new/modified requirements from change drivers
- Re-baseline requirements for the next ADM cycle
- Feed lessons learned into requirements for future cycles

---

## Common Pitfalls in Requirements Management

| Pitfall | Consequence | Prevention |
|---|---|---|
| **No formal process** | Ad-hoc handling leads to lost requirements | Establish the process in the Preliminary Phase |
| **Incomplete stakeholder coverage** | Missing requirements from overlooked stakeholders | Comprehensive stakeholder mapping in Phase A |
| **No baseline** | Scope creep without control | Formal baseline approval before Phase B |
| **No traceability** | Cannot assess change impact | Maintain traceability matrix from the start |
| **No prioritization** | Everything is equally important (meaning nothing is) | Apply MoSCoW or weighted scoring early |
| **Ignoring non-functional requirements** | Architecture underperforms | Explicitly elicit NFRs alongside functional requirements |
| **No change management** | Requirements churn destabilizes architecture | Formal change request process for all changes |
| **Requirements not communicated** | Phase teams work with outdated requirements | Proactive communication when requirements change |

---

## Review Questions

**Question 1:** Why is Requirements Management shown at the center of the ADM cycle rather than as a sequential phase?

**Answer:** Because Requirements Management operates continuously throughout every phase of the ADM, not just at one point in the sequence. Requirements flow into and out of every phase, and changes to requirements can arise at any point. The central position reflects this continuous, cross-phase nature.

---

**Question 2:** What is the Requirements Repository?

**Answer:** The Requirements Repository is the managed store for all architecture requirements. It contains the requirements catalog, requirements baseline, status tracking, traceability links, change history, impact assessments, priority assignments, and stakeholder mapping. It is part of the broader Architecture Repository.

---

**Question 3:** What is a requirements baseline and why is it important?

**Answer:** A requirements baseline is the formally approved set of requirements at a point in time that serves as the foundation for architecture work. It is important because it provides a controlled reference point — changes can only be made through the formal change management process, preventing uncontrolled scope creep while still allowing necessary evolution.

---

**Question 4:** What does MoSCoW stand for and how is it used?

**Answer:** MoSCoW stands for Must have, Should have, Could have, and Won't have (this time). It is a prioritization technique that classifies requirements into four categories based on their importance. "Must have" requirements are non-negotiable, "Should have" are important but not critical, "Could have" are desirable if resources permit, and "Won't have" are explicitly deferred to a future iteration.

---

**Question 5:** What is requirements traceability?

**Answer:** Requirements traceability is the ability to link each requirement to the architecture components that address it, the work packages that implement it, the stakeholders who raised it, and the business goals it supports. It enables impact analysis, completeness verification, justification of architecture decisions, and effective change management.

---

**Question 6:** How does Requirements Management interact with Phase G?

**Answer:** During Phase G, requirements are used as conformance criteria in architecture compliance reviews. Requirements Management receives new or modified requirements arising from implementation experience (e.g., requirements that were unclear, missing, or infeasible as discovered during implementation) and processes them through the change management workflow.

---

**Question 7:** What triggers a requirements impact assessment?

**Answer:** A requirements impact assessment is triggered when a change to one or more requirements is proposed. This can come from stakeholder requests, architecture work discoveries, implementation lessons, regulatory changes, technology changes, or Phase H change management activities.

---

**Question 8:** What is the difference between the Architecture Requirements Specification and the Requirements Repository?

**Answer:** The Architecture Requirements Specification is a formal document that captures the detailed requirements the architecture must satisfy (functional, non-functional, constraints). The Requirements Repository is the managed store that contains the specification plus additional information like traceability links, change history, status tracking, and impact assessments. The specification is one artifact within the repository.

---

**Question 9:** How are conflicting requirements resolved?

**Answer:** Conflicting requirements are resolved through facilitated discussions with affected stakeholders, trade-off analysis (evaluating the consequences of favoring each conflicting requirement), prioritization (using techniques like MoSCoW or weighted scoring), escalation to the Architecture Board when stakeholders cannot agree, and documentation of the decision rationale.

---

**Question 10:** What happens when a requirement changes during Phase C but Phase B work is already complete?

**Answer:** Requirements Management assesses the impact of the change on Phase B deliverables. If the change affects the Business Architecture, Phase B work may need to be revisited. The impact assessment determines the scope of rework needed, and the change is communicated to all affected phase teams. This is an example of the iterative nature of the ADM that Requirements Management enables.

---

**Question 11:** How do requirements from Phase H enter the next ADM cycle?

**Answer:** Phase H generates new or modified requirements from change drivers (technology changes, business changes, lessons learned). These are documented in the Requirements Repository with appropriate priority and routing. When a new ADM cycle begins, Requirements Management ensures these requirements are included in the baseline for Phase A of the next cycle.

---

**Question 12:** What is the role of non-functional requirements in enterprise architecture?

**Answer:** Non-functional requirements define the quality attributes the architecture must exhibit — performance, security, availability, scalability, usability, maintainability, etc. They are critical because they often drive architectural decisions more than functional requirements. A system that performs all required functions but cannot scale or is insecure is architecturally inadequate.

---

**Question 13:** What information does a Requirements Impact Assessment contain?

**Answer:** A Requirements Impact Assessment contains: identification of affected architecture components, affected projects and work packages, affected related requirements (through dependencies), affected stakeholders, quantified impact on effort/cost/schedule, risk implications, and a recommendation to approve, reject, defer, or modify the change.

---

**Question 14:** How does Requirements Management support architecture governance?

**Answer:** Requirements Management supports governance by providing the conformance criteria used in compliance reviews (Phase G), maintaining traceability so the rationale for architecture decisions can be verified, ensuring all approved requirements are addressed, and processing change requests that affect requirements through a formal, governed change management process.

---

**Question 15:** What is the lifecycle of a requirement in TOGAF?

**Answer:** A requirement follows a lifecycle: Proposed (initially identified) → Approved (accepted into the baseline) → In Progress (being addressed by architecture work) → Implemented (solution deployed) → Verified (confirmed that the implementation satisfies the requirement). Requirements may also be Deferred (moved to a future cycle), Rejected (not accepted), or Obsoleted (no longer relevant).

---

**Question 16:** Why is it important to identify requirements from implementation lessons (Step 5)?

**Answer:** Implementation lessons reveal requirements that were missed, incomplete, or incorrect during the architecture definition phases. This feedback loop is essential for improving the architecture (both the current deployment and future cycles) and for improving the requirements management process itself. Without this feedback, the same requirements gaps will recur in future cycles.

---

**Question 17:** How does Requirements Management prevent scope creep?

**Answer:** By establishing a formal requirements baseline, any proposed change must go through the change management process — including impact assessment, stakeholder consultation, and formal approval. This prevents uncontrolled addition of requirements (scope creep) while still allowing necessary changes. The baseline makes scope changes visible and deliberate rather than invisible and accidental.

---

## Summary

Requirements Management is the connective tissue of the TOGAF ADM. Its central position is not merely a diagram convention — it reflects the fundamental truth that requirements are the driving force behind every architecture decision, and that requirements management must be active and continuous throughout the entire ADM lifecycle. By providing a structured process for identifying, documenting, baselining, prioritizing, tracing, and managing changes to requirements, Requirements Management ensures that the architecture remains aligned with stakeholder needs, that changes are controlled and communicated, and that the rationale for architecture decisions is preserved. Mastery of Requirements Management is essential for TOGAF certification because it underpins the coherence and traceability of the entire ADM process.
