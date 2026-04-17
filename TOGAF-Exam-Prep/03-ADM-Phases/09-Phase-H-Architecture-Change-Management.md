# Phase H — Architecture Change Management

## Overview

Phase H is the final sequential phase of the TOGAF ADM cycle before the process loops back to a new cycle. Its purpose is to ensure that the **architecture lifecycle is maintained**, that the architecture responds to change in a controlled and governed manner, and that the enterprise architecture continues to deliver value as the business and technology landscape evolves.

While Phase G focuses on governing the *initial implementation* of the architecture, Phase H focuses on governing the *ongoing evolution* of the architecture after deployment. In the real world, architecture is never "done." Business needs change, technologies evolve, competitors disrupt, and regulations shift. Phase H provides the framework for managing all of these changes in a structured, governed manner.

Phase H is the bridge between one ADM cycle and the next. It determines whether a change can be handled as a minor update, an incremental enhancement, or whether a full re-architecting effort (a new ADM cycle) is required.

```
┌──────────────────────────────────────────────────────────┐
│                    Phase H Context                        │
│                                                           │
│   Phase G ──────────► PHASE H ──────────► New ADM Cycle   │
│   (Implementation     (Architecture       (Back to        │
│    Governance)         Change Mgmt)        Phase A or     │
│                                            any phase)     │
│                                                           │
│   Change Drivers:                                         │
│   ┌──────────┐  ┌──────────┐  ┌──────────┐               │
│   │ Business │  │Technology│  │ Lessons  │               │
│   │ Changes  │  │ Changes  │  │ Learned  │               │
│   └────┬─────┘  └────┬─────┘  └────┬─────┘               │
│        │              │              │                     │
│        └──────────────┼──────────────┘                     │
│                       ▼                                    │
│              ┌─────────────────┐                           │
│              │ Change Impact   │                           │
│              │ Assessment      │                           │
│              └────────┬────────┘                           │
│                       │                                    │
│           ┌───────────┼───────────┐                        │
│           ▼           ▼           ▼                        │
│     Simplification  Incremental  Re-architecting           │
│     Change          Change       Change                    │
└──────────────────────────────────────────────────────────┘
```

---

## Objectives

The primary objectives of Phase H are:

1. **Ensure that the architecture lifecycle is maintained** — The deployed architecture must continue to be governed, monitored, and evolved throughout its operational life.
2. **Ensure that the Architecture Governance Framework is executed** — Governance does not end with deployment; it continues as the architecture operates and evolves.
3. **Ensure that the Enterprise Architecture Capability meets current requirements** — The architecture practice itself must evolve to remain effective.
4. **Establish and support the enterprise architecture through a defined change management process** — Provide a structured mechanism for handling all types of architecture change.
5. **Monitor enterprise architecture capability maturity** — Assess and improve the organization's ability to perform enterprise architecture.
6. **Monitor business and technology changes that might impact the architecture** — Proactive scanning for change drivers, not just reactive responses.

---

## Key Concepts

### Drivers for Architecture Change

Architecture change can be triggered by multiple sources:

| Driver Category | Examples |
|---|---|
| **Business changes** | Mergers and acquisitions, new markets, organizational restructuring, new business models, regulatory changes, competitive pressures |
| **Technology changes** | New technology availability, technology obsolescence, vendor product changes, security vulnerabilities, platform end-of-life |
| **Lessons learned** | Post-implementation reviews from Phase G, operational issues, performance problems, user feedback |
| **Standards changes** | Updated industry standards, new compliance requirements, changed enterprise standards |
| **Environmental changes** | Economic shifts, geopolitical changes, pandemic impacts, sustainability requirements |
| **Strategic changes** | New enterprise strategy, changed business priorities, new executive leadership with different vision |

### Three Categories of Architecture Change

Phase H classifies changes into three categories, each requiring a different response:

#### 1. Simplification Change

- **Description**: A change that can be handled by making a straightforward simplification or reduction in the architecture
- **Scope**: Narrow; affects a small, well-defined part of the architecture
- **Process**: Can be handled within the current Architecture Governance framework without initiating a new ADM cycle
- **Examples**: Decommissioning a redundant system, consolidating duplicate data stores, removing an unused interface
- **Approval**: Architecture Board or delegated authority can approve
- **Timeline**: Typically short (weeks to a few months)

#### 2. Incremental Change

- **Description**: A change that requires updates to the architecture but can be handled as an increment within the current architecture framework
- **Scope**: Moderate; may affect multiple architecture domains but does not fundamentally alter the architecture direction
- **Process**: May require re-entry into specific ADM phases (e.g., returning to Phase B or C to update a specific domain) rather than a full ADM cycle
- **Examples**: Adding a new application to support a new business process, extending an integration platform to accommodate a new partner, upgrading a technology platform to a new version
- **Approval**: Architecture Board approval required; may need updated Architecture Contract
- **Timeline**: Typically medium (months to a year)

#### 3. Re-architecting Change

- **Description**: A fundamental change that requires a complete re-examination of the architecture
- **Scope**: Broad; affects the foundational assumptions, principles, or structure of the architecture
- **Process**: Requires initiation of a **new ADM cycle** starting from Phase A (or the Preliminary Phase if the architecture framework itself needs updating)
- **Examples**: Digital transformation initiative, cloud migration strategy, post-merger architecture integration, fundamental business model change
- **Approval**: Executive sponsorship and full Architecture Board engagement required; new Request for Architecture Work
- **Timeline**: Typically long (one to several years)

```
Change Request Received
         │
         ▼
┌─────────────────┐
│ Assess Impact   │
│ and Scope       │
└────────┬────────┘
         │
    ┌────┴────┬──────────┐
    ▼         ▼          ▼
┌────────┐┌────────┐┌──────────┐
│Simplif-││Incre-  ││Re-archi- │
│ication ││mental  ││tecting   │
│        ││        ││          │
│Handle  ││Re-enter││New ADM   │
│within  ││specific││cycle     │
│current ││ADM     ││(Phase A) │
│govern- ││phases  ││          │
│ance    ││        ││          │
└────────┘└────────┘└──────────┘
```

### Architecture Change Request Process

The Architecture Change Request is the formal mechanism for proposing, assessing, and disposing of architecture changes:

1. **Change Request submission**: Any stakeholder can submit a request identifying the change needed, the business justification, and the urgency
2. **Change classification**: The architecture team classifies the change (simplification, incremental, re-architecting)
3. **Impact assessment**: Assess the impact across all architecture domains (business, data, application, technology)
4. **Stakeholder analysis**: Identify who is affected and obtain their input
5. **Options analysis**: Develop options for addressing the change
6. **Recommendation**: Architecture team recommends a course of action
7. **Decision**: Architecture Board (or delegated authority) approves, rejects, or defers the change
8. **Implementation**: Approved changes are implemented through the appropriate mechanism
9. **Verification**: Confirm that the change was implemented correctly and achieved its objectives

### Architecture Compliance Review in Phase H

Compliance reviews in Phase H differ from those in Phase G:

| Aspect | Phase G Reviews | Phase H Reviews |
|---|---|---|
| **Focus** | New implementations | Ongoing operations |
| **Frequency** | At project milestones | Periodic (quarterly, annually) |
| **Trigger** | Project governance gates | Scheduled reviews or change events |
| **Scope** | Individual projects | The entire deployed architecture |
| **Purpose** | Ensure build conformance | Ensure operational conformance and detect drift |

Phase H compliance reviews help detect **architecture erosion** — the gradual degradation of architecture conformance as operational teams make small, ungoverned changes over time.

---

## Inputs

| Input | Source | Purpose |
|---|---|---|
| Request for Architecture Work | Phase A | Original scope and mandate |
| Organizational Model for EA | Preliminary Phase | Architecture governance structure |
| Governance Framework | Preliminary Phase | Governance policies and processes |
| Architecture Vision | Phase A | The vision being maintained |
| Architecture Definition Document | Phases B, C, D | The architecture being governed |
| Architecture Requirements Specification | Phases B, C, D | Requirements being tracked |
| Architecture Roadmap | Phase F | Planned evolution path |
| Implementation and Migration Plan | Phase F | Execution plan being monitored |
| Implementation Governance Model | Phase F | How governance is applied |
| Architecture Contracts | Phase G | Agreements being managed |
| Compliance Assessments | Phase G | Current compliance state |
| Change Requests (from Phase G) | Phase G | Changes identified during implementation |
| Post-implementation review reports | Phase G | Lessons learned and issues |
| Architecture Repository | All phases | Complete architecture knowledge base |

---

## Steps in Detail

### Step 1: Establish Value Realization Process

Establish a process to monitor and measure whether the deployed architecture is delivering the business value that was promised:

- **Define value metrics**: Align with the business metrics in the Architecture Contract and the business value assessments from Phase F
- **Establish measurement baselines**: Capture current-state metrics so value delivery can be measured against a baseline
- **Design reporting**: Create dashboards and reports that communicate value realization to stakeholders
- **Define accountability**: Assign ownership for value tracking and reporting
- **Schedule value reviews**: Establish a cadence for reviewing value delivery (e.g., quarterly)

Value realization monitoring is essential for sustaining executive sponsorship and justifying ongoing architecture investment.

### Step 2: Deploy Monitoring Tools

Deploy tools and processes to monitor the architecture in operation:

- **Technical monitoring**: Infrastructure health, application performance, security events, integration flows
- **Business monitoring**: KPI dashboards, process metrics, customer experience metrics
- **Compliance monitoring**: Automated checks for architecture conformance, standards adherence, policy compliance
- **Change monitoring**: Track changes to the operational environment that may affect architecture conformance
- **Trend analysis**: Monitor trends that might indicate emerging issues or opportunities

The monitoring infrastructure should generate alerts when thresholds are breached, enabling proactive rather than reactive change management.

### Step 3: Manage Risks

Continue the risk management activities established in earlier phases:

- **Update the risk register**: Add new risks identified during operations, retire risks that are no longer relevant
- **Monitor existing risks**: Track the status of identified risks and the effectiveness of mitigations
- **Assess new risks**: Evaluate risks arising from the operational environment, technology changes, and business changes
- **Trigger risk responses**: Activate contingency plans when risk events occur
- **Communicate risk status**: Keep stakeholders informed about the risk landscape

### Step 4: Provide Analysis for Architecture Change Management

When change drivers are identified, provide structured analysis to support decision-making:

- **Impact analysis**: Assess the impact of the proposed change across all architecture domains
- **Gap analysis**: Identify gaps between the current architecture and the architecture needed to address the change
- **Options analysis**: Develop multiple options for addressing the change, with pros, cons, and costs for each
- **Recommendation**: Provide a recommended course of action with justification
- **Classification**: Classify the change as simplification, incremental, or re-architecting

This analysis is the foundation for informed decision-making by the Architecture Board.

### Step 5: Develop Change Requirements to Meet Performance Targets

When analysis shows that changes are needed:

- **Document change requirements**: Formally specify what changes are needed and why
- **Define success criteria**: How will we know the change was successful?
- **Estimate resources**: What resources (people, budget, time) are needed?
- **Assess dependencies**: What other changes or projects does this depend on?
- **Prioritize**: Where does this change fit relative to other pending changes?
- **Feed into Requirements Management**: Ensure the change requirements are managed through the Requirements Management process at the center of the ADM

### Step 6: Manage Governance Process

Execute the ongoing governance process:

- **Conduct periodic compliance reviews**: Assess architecture conformance on a scheduled basis
- **Process change requests**: Receive, classify, assess, and disposition architecture change requests
- **Maintain Architecture Contracts**: Update contracts as the architecture evolves
- **Report governance status**: Communicate governance findings and actions to stakeholders
- **Update governance processes**: Refine governance processes based on experience and lessons learned
- **Architecture Board meetings**: Support the Architecture Board with analysis, recommendations, and reporting

### Step 7: Activate the Architecture Implementation Process for Changes

When changes are approved for implementation:

- **For simplification changes**: Issue implementation instructions within the existing governance framework; no new ADM cycle needed
- **For incremental changes**: Determine which ADM phases need to be re-entered (e.g., Phase B for business architecture updates, Phase C for information systems updates) and initiate the appropriate work
- **For re-architecting changes**: Issue a new **Request for Architecture Work** and initiate a new ADM cycle starting from Phase A (or the Preliminary Phase)

```
Approved Change
      │
      ├── Simplification ──► Implement within current governance
      │
      ├── Incremental    ──► Re-enter specific ADM phases
      │                       (B, C, D, E, F as needed)
      │
      └── Re-architecting ──► New Request for Architecture Work
                               ──► New ADM Cycle (Phase A)
```

---

## Outputs

| Output | Description |
|---|---|
| **Architecture Updates** | Modifications to the Architecture Definition Document, Requirements Specification, and other architecture artifacts to reflect approved changes |
| **Changes to the Architecture Framework** | Updates to architecture principles, governance processes, methodologies, or tools based on lessons learned |
| **New Request for Architecture Work** | For re-architecting changes, a formal request that triggers a new ADM cycle |
| **Statement of Architecture Work (updated)** | Updated scope and approach reflecting changes |
| **Architecture Contract (updated)** | Amended contracts reflecting approved changes |
| **Compliance Assessments** | Periodic compliance reviews of the operational architecture |
| **Change Requests (resolved)** | Disposition of all received change requests |
| **Architecture Requirements Specification (updated)** | Requirements updated to reflect approved changes |

---

## Change Management of the Architecture Capability

Phase H is not only about managing changes to the architecture itself — it also manages changes to the **architecture capability** (the organization's ability to do enterprise architecture):

- **Process improvements**: Refine ADM processes based on lessons learned across cycles
- **Tool improvements**: Upgrade or replace architecture tools and repositories
- **Skills development**: Identify and address skills gaps in the architecture team
- **Governance maturity**: Evolve governance processes to match organizational maturity
- **Stakeholder engagement**: Improve how the architecture function engages with the business

This meta-level change management ensures the architecture practice itself continues to improve over time.

---

## Relationship to Architecture Governance

Phase H has a deep relationship with the Architecture Governance framework:

| Governance Aspect | Phase H Role |
|---|---|
| **Policy enforcement** | Ensures architecture policies continue to be followed in operations |
| **Compliance monitoring** | Conducts periodic compliance reviews of deployed architecture |
| **Change control** | Provides the change management process for architecture changes |
| **Dispensation management** | Manages waivers and exceptions granted during operations |
| **Standards management** | Updates standards based on technology evolution and lessons learned |
| **Architecture Board support** | Provides analysis and recommendations to the Architecture Board |
| **Reporting** | Reports on architecture health, compliance, and value delivery |

Governance is the **continuous thread** that runs through Phase G (implementation governance) and Phase H (change governance). Together, they ensure the architecture is not only built right but stays right.

---

## When to Trigger a New ADM Cycle vs. Making Incremental Changes

This is one of the most important judgment calls in Phase H. The decision framework:

| Factor | Incremental Change | New ADM Cycle |
|---|---|---|
| **Scope** | Affects one or two architecture domains | Affects all or most architecture domains |
| **Principles** | Current principles still valid | Fundamental principles need revisiting |
| **Vision** | Architecture Vision still valid | Vision no longer adequate |
| **Stakeholders** | Same stakeholder landscape | New stakeholders, changed power dynamics |
| **Business model** | Business model unchanged | Business model fundamentally different |
| **Technology platform** | Platform evolution (upgrade) | Platform revolution (replacement) |
| **Timeline** | Months | Years |
| **Investment** | Within existing budgets | Requires new capital allocation |
| **Risk** | Manageable within current framework | Requires comprehensive risk reassessment |

**Rules of thumb:**

- If the Architecture Vision is still valid and the change fits within the existing architectural direction, it is likely incremental
- If the change requires revisiting the Architecture Vision or enterprise strategy, it is likely re-architecting
- If more than 50% of the architecture domains are significantly affected, it is likely re-architecting
- When in doubt, start with an Architecture Vision review (abbreviated Phase A) to determine the appropriate scope

---

## Architecture Erosion and Drift

Two related concepts that Phase H must actively combat:

**Architecture Erosion**: The gradual degradation of architecture quality through numerous small, individually insignificant changes that cumulatively undermine the architecture's integrity. Like erosion of a hillside, each small change seems harmless, but over time the landscape is fundamentally altered.

**Architecture Drift**: The growing distance between the documented architecture and the actual deployed systems. This occurs when changes are made to systems without updating architecture documentation, or when operational teams make changes outside the governance process.

**Countermeasures:**
- Regular compliance reviews (detect drift)
- Automated conformance monitoring (detect erosion in real-time)
- Culture of architecture awareness (prevent both)
- Low-friction change request process (avoid shadow changes that bypass governance)
- Architecture documentation automation (keep documents in sync with reality)

---

## Review Questions

**Question 1:** What is the primary purpose of Phase H in the TOGAF ADM?

**Answer:** To ensure that the architecture lifecycle is maintained through a structured change management process, that the governance framework continues to be executed, and that the enterprise architecture evolves in a controlled manner in response to business and technology changes.

---

**Question 2:** What are the three categories of architecture change in Phase H?

**Answer:** (1) Simplification change — handled within current governance, (2) Incremental change — requires re-entry into specific ADM phases, (3) Re-architecting change — requires a new ADM cycle starting from Phase A.

---

**Question 3:** What triggers a re-architecting change rather than an incremental change?

**Answer:** A re-architecting change is triggered when the change affects the foundational assumptions, principles, or structure of the architecture — such as a fundamental business model change, digital transformation initiative, or post-merger integration. Key indicators include: the Architecture Vision is no longer valid, most architecture domains are significantly affected, or new executive leadership has a fundamentally different strategic direction.

---

**Question 4:** What are the main drivers for architecture change?

**Answer:** Business changes (mergers, new markets, regulation), technology changes (new technology, obsolescence, vulnerabilities), lessons learned (from Phase G post-implementation reviews), standards changes, environmental changes (economic, geopolitical), and strategic changes (new strategy, changed priorities).

---

**Question 5:** How does Phase H differ from Phase G?

**Answer:** Phase G governs the initial implementation of the architecture (ensuring build conformance). Phase H governs the ongoing evolution of the deployed architecture (ensuring operational conformance and managing change). Phase G is project-focused; Phase H is lifecycle-focused.

---

**Question 6:** What is architecture erosion?

**Answer:** Architecture erosion is the gradual degradation of architecture quality through numerous small, individually insignificant changes that cumulatively undermine the architecture's integrity. Each small change seems harmless, but over time the architecture's structural quality is fundamentally degraded.

---

**Question 7:** What is the Architecture Change Request process?

**Answer:** The process includes: (1) Change Request submission, (2) Change classification (simplification/incremental/re-architecting), (3) Impact assessment across all domains, (4) Stakeholder analysis, (5) Options analysis, (6) Recommendation by the architecture team, (7) Decision by the Architecture Board, (8) Implementation through the appropriate mechanism, (9) Verification that the change achieved its objectives.

---

**Question 8:** What output of Phase H triggers a new ADM cycle?

**Answer:** A new Request for Architecture Work. When Phase H determines that a re-architecting change is needed, it issues a new Request for Architecture Work that initiates a new ADM cycle, typically starting from Phase A (Architecture Vision).

---

**Question 9:** What is the role of monitoring in Phase H?

**Answer:** Monitoring in Phase H serves multiple purposes: technical monitoring tracks infrastructure and application health; business monitoring tracks KPI delivery and value realization; compliance monitoring detects architecture drift and non-conformance; and change monitoring identifies environmental changes that may require architecture responses. Monitoring enables proactive rather than reactive change management.

---

**Question 10:** How does Phase H manage the architecture capability itself?

**Answer:** Phase H manages changes to the architecture capability through process improvements (refining ADM processes), tool improvements (upgrading architecture tools), skills development (addressing skills gaps), governance maturity evolution, and stakeholder engagement improvements. This meta-level management ensures the architecture practice itself continues to improve.

---

**Question 11:** What is the value realization process in Phase H?

**Answer:** The value realization process monitors and measures whether the deployed architecture is delivering the business value that was promised. It involves defining value metrics, establishing measurement baselines, designing reporting, assigning accountability, and scheduling value reviews. It sustains executive sponsorship by demonstrating tangible returns on architecture investment.

---

**Question 12:** How does Phase H interact with Requirements Management?

**Answer:** When Phase H identifies change requirements, these are fed into the Requirements Management process at the center of the ADM. Requirements Management ensures that change-driven requirements are properly documented, prioritized, assessed for impact, and tracked through whichever ADM phases are activated to address them.

---

**Question 13:** What is the difference between architecture erosion and architecture drift?

**Answer:** Architecture erosion is the gradual degradation of architecture quality through small cumulative changes. Architecture drift is the growing distance between documented architecture and actually deployed systems. Erosion degrades the architecture itself; drift degrades the accuracy of the documentation. Both are combated through compliance reviews, automated monitoring, and governance.

---

**Question 14:** When should Phase H conduct compliance reviews?

**Answer:** Phase H should conduct compliance reviews on a periodic basis (quarterly or annually), when significant changes are deployed, when monitoring detects potential non-conformance, and when business or technology changes create new compliance risks. Unlike Phase G reviews (at project milestones), Phase H reviews focus on the ongoing operational architecture.

---

**Question 15:** What happens to approved incremental changes?

**Answer:** Approved incremental changes trigger re-entry into the specific ADM phases needed to address the change. For example, a change affecting the technology architecture would re-enter Phase D, while a change requiring new implementation projects would re-enter Phases E and F. This is a targeted re-entry, not a full ADM cycle.

---

**Question 16:** What role does the Architecture Board play in Phase H?

**Answer:** The Architecture Board approves or rejects significant change requests, sets the threshold for what constitutes each category of change, grants dispensations for non-conformance when justified, approves changes to the architecture governance framework, sponsors new ADM cycles when re-architecting is needed, and provides strategic direction for architecture evolution.

---

**Question 17:** How does Phase H contribute to continuous improvement of enterprise architecture?

**Answer:** Phase H creates a feedback loop by collecting lessons learned, monitoring value delivery, conducting compliance reviews, and managing the architecture capability. This feedback loop identifies what works well and what needs improvement, driving changes to both the architecture itself and the architecture practice. Each ADM cycle benefits from the improvements captured by Phase H from previous cycles.

---

## Summary

Phase H closes the ADM cycle by establishing the ongoing management of architecture change. Its three-tiered classification of changes (simplification, incremental, re-architecting) provides a proportionate response mechanism — small changes are handled efficiently within existing governance, while fundamental changes trigger full new ADM cycles. By combining value realization monitoring, compliance reviews, risk management, and a structured change request process, Phase H ensures the architecture remains relevant, compliant, and valuable throughout its operational life. It is the phase that transforms enterprise architecture from a one-time project into a continuous organizational capability.
