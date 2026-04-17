# TOGAF Part 2 Certified - Practice Test 43: The Real-World Expert
## Difficulty: EXPERT
**Time Allowed:** 90 minutes | **Questions:** 8 | **Pass Mark:** 60% (24/40)

> **Note:** Expert-level difficulty. Each scenario involves MULTIPLE interacting TOGAF concepts applied to complex, realistic enterprise situations. Designed to be significantly harder than the actual exam.

---

## Scenario 1: The Regulatory Compliance Migration

**PharmaCorp International** is a global pharmaceutical company headquartered in Switzerland with operations in the US, EU, and Asia. The company is embarking on a major initiative to migrate from a fully on-premises IT infrastructure to a hybrid cloud architecture. The initiative is driven by the CEO's strategic vision to enable real-time collaboration between global R&D centers and reduce IT operational costs by 40%.

However, the initiative faces extraordinary complexity. The company must simultaneously comply with FDA 21 CFR Part 11 (electronic records and electronic signatures) for its US operations, EU GDPR (General Data Protection Regulation) for patient and employee data across European operations, and China's Cybersecurity Law for its Shanghai research center. Each regulatory framework has different—and sometimes conflicting—requirements for data residency, access controls, audit trails, and encryption.

The Architecture Board consists of 8 members: the CTO (chair), the Chief Information Security Officer (CISO), the VP of Global Compliance, the VP of R&D IT, the VP of Manufacturing IT, a representative from the PMO, and two external advisors. During Phase A, the Architecture Board approved an Architecture Vision that identified a "single hybrid cloud platform" as the target state.

Now in Phase B, the Enterprise Architect discovers that the business processes for drug trial data management require data to reside in specific geographic regions per FDA and GDPR requirements, while the R&D collaboration use case requires data to flow freely across regions. The Security team insists that all data be encrypted with keys managed on-premises. The Compliance team requires immutable audit trails that FDA auditors can access. The R&D VP wants maximum flexibility and minimal compliance overhead.

The Chief Architect must decide how to proceed given these conflicting requirements.

### Question 1
Given the conflicting regulatory requirements discovered in Phase B, what is the BEST approach according to TOGAF?

a) Return to Phase A to revise the Architecture Vision, as the "single hybrid cloud platform" vision may be fundamentally inadequate given the regulatory complexity. Update the Statement of Architecture Work to include explicit regulatory constraints for each region, engage the Architecture Board to approve a revised vision that acknowledges a "federated hybrid cloud" with regional sovereignty, and ensure the Requirements Management process captures all regulatory requirements as architecture constraints.

b) Continue in Phase B and document the conflicting requirements as architecture constraints within the Business Architecture. Use Business Scenarios to model each regulatory context separately, identify the business processes that span regulatory boundaries, and produce a Business Architecture that explicitly segments processes by regulatory domain. Flag the conflicts as risks in the Architecture Requirements Specification and plan to resolve them in Phase C when specific data and application solutions can be evaluated.

c) Escalate to the Architecture Board immediately and request a dispensation to proceed with the original Architecture Vision. Document the regulatory conflicts as risks and propose that the Compliance team develop workarounds for each regulatory requirement. Continue with Phase B using the assumption that technology solutions in Phase D will resolve the data residency conflicts.

d) Halt the architecture engagement entirely and commission a separate regulatory compliance assessment before continuing with the ADM. The ADM is not designed to handle regulatory complexity, and attempting to proceed without a dedicated compliance framework will result in an architecture that fails regulatory audits.

### Question 2
How should the Enterprise Architect structure the stakeholder engagement to address the CISO's, Compliance VP's, and R&D VP's conflicting priorities?

a) Create separate Architecture Contracts for each stakeholder to ensure their individual requirements are met independently, then reconcile any conflicts during Phase G implementation governance.

b) Use the TOGAF stakeholder management approach: map all stakeholders, document their specific concerns using a Stakeholder Map Matrix, identify concern conflicts explicitly, develop architecture viewpoints that address cross-cutting concerns (security, compliance, collaboration), and create views that demonstrate how the architecture resolves conflicts through trade-offs approved by the Architecture Board.

c) Prioritize the CISO's security requirements above all others since security is a non-negotiable enterprise principle, and ask the Architecture Board to override the R&D VP's flexibility requirements.

d) Defer stakeholder conflict resolution to the PMO, as the Architecture Board should not be involved in resolving business priority disputes between functional leaders.

---

## Scenario 2: The Failed Architecture Vision

**GlobalBank** is a major financial services institution that launched an enterprise architecture program 6 months ago. In Phase A, the architecture team developed an Architecture Vision based on the business strategy of "digital-first banking" and received Architecture Board approval. The Statement of Architecture Work was signed by the CIO, the Architecture Board chair, and the head of the Digital Transformation Program.

During Phase C (Application Architecture), the architecture team discovers critical problems. The approved Architecture Vision assumed that the bank's core banking platform could be extended with APIs to support digital channels. However, a detailed technical assessment—conducted independently by the platform vendor—reveals that the core banking system is 15 years old and its architecture fundamentally cannot support modern API integration without a complete replacement, which would cost $200M and take 3 years.

Additionally, the business strategy has shifted. The new CEO (who joined 3 months ago) has pivoted from "digital-first banking" to "ecosystem banking," requiring the bank to open its platform to third-party fintech partners. This fundamentally changes the architecture requirements from internal digital channels to external platform capabilities.

The Architecture Board is divided. Three members want to continue with the current Architecture Vision and "make it work." Two members want to restart the ADM from Phase A. Two members want to cancel the architecture engagement entirely and let individual project teams make their own technology decisions. The Chief Architect must recommend a path forward.

### Question 3
What is the MOST APPROPRIATE action according to TOGAF governance principles?

a) The Chief Architect should recommend continuing with the current ADM cycle but inserting a formal architecture review checkpoint. Use the Requirements Management process to formally document the changed business strategy and the technical infeasibility as new requirements. Then, iterate back to Phase A to revise the Architecture Vision with the new CEO's "ecosystem banking" strategy, update the Statement of Architecture Work with revised scope and constraints, and re-engage the Architecture Board for approval of the revised vision—preserving the valuable Phase B and partial Phase C work as inputs to the updated cycle.

b) Cancel the current ADM cycle and start a completely new engagement from the Preliminary Phase. The change in CEO and business strategy means the architecture principles, organizational model, and governance framework may all need revision before a new Architecture Vision can be developed.

c) Continue with the current Architecture Vision in Phase C but add the vendor platform replacement as a work package in Phase E. The Architecture Vision is an aspirational document that doesn't need to match current reality perfectly. Address the CEO's ecosystem strategy as an evolution of the digital-first strategy rather than a fundamental change.

d) Accept the three Architecture Board members' recommendation to continue and "make it work." The Statement of Architecture Work has been signed and represents a binding governance commitment. Changing course would undermine the credibility of architecture governance.

### Question 4
How should the Architecture Board handle the disagreement among its members about the path forward?

a) The Architecture Board chair (CIO) should use the casting vote to break the deadlock, as the TOGAF Standard designates the chair as the final decision-maker in all disputes.

b) The Architecture Board should follow its documented governance procedures for dispute resolution. If no procedures exist, the Board should first document the options with supporting rationale, assess each option against the architecture principles and business strategy, seek input from key stakeholders (especially the new CEO), and reach a consensus decision. If consensus cannot be reached, the Board should escalate to the executive sponsor per the governance escalation path.

c) The Architecture Board should vote democratically with each member having one vote, as majority rule is the default governance mechanism in TOGAF.

d) The Chief Architect should make the decision unilaterally, as TOGAF designates the Chief Architect as the technical authority who can override the Architecture Board on matters of architectural feasibility.

---

## Scenario 3: Reconciling Segment Architectures

**MegaManufacturing Corp** is a diversified manufacturing conglomerate with three major divisions: Automotive (Division A), Aerospace (Division B), and Consumer Electronics (Division C). Over the past three years, each division has independently developed its own Segment Architecture using the TOGAF ADM.

Division A completed its Segment Architecture in 2023 using TOGAF 9.1, focusing heavily on supply chain optimization and just-in-time manufacturing. Division B completed its Segment Architecture in 2024 using TOGAF 9.2, emphasizing quality management and regulatory compliance. Division C completed its Segment Architecture in early 2025 using the TOGAF Standard, 10th Edition, focusing on digital customer experience and IoT-enabled products.

The CEO now demands a unified Strategic Architecture that spans all three divisions to enable shared services, cross-divisional innovation, and a common data platform. The corporate Chief Architect must reconcile three Segment Architectures that:
- Were developed at different times with different versions of the TOGAF framework
- Use different metamodel interpretations and content naming conventions
- Have overlapping but inconsistent technology standards (e.g., Division A uses AWS, Division B uses Azure, Division C uses Google Cloud)
- Have different maturity levels (Division A is in Phase G implementation, Division B is in Phase F planning, Division C just completed Phase D)

### Question 5
What is the CORRECT TOGAF approach to reconciling these three Segment Architectures into a Strategic Architecture?

a) Discard all three Segment Architectures and start the Strategic Architecture from scratch. Version incompatibilities between TOGAF 9.1, 9.2, and 10th Edition mean the segment work cannot be meaningfully reconciled, and attempting to do so will create more confusion than value.

b) Initiate a new Strategic Architecture ADM cycle at the enterprise level. Use the Preliminary Phase to establish a common Tailored Architecture Framework with a unified metamodel and naming conventions. In Phase A, develop a Strategic Architecture Vision that acknowledges the existing Segment Architectures as valuable inputs. In Phases B-D, identify common business capabilities, shared data entities, and reusable technology components across all three divisions. Map each division's Segment Architecture artifacts to the unified metamodel, identify overlaps and conflicts, and develop a Strategic Architecture that provides governance boundaries while allowing division-specific variation.

c) Select the most mature Segment Architecture (Division A, currently in Phase G) as the baseline Strategic Architecture and require Divisions B and C to align their architectures to Division A's approach, standards, and technology choices.

d) Maintain the three Segment Architectures as-is and create a lightweight integration layer that only addresses the shared services and data platform requirements. A Strategic Architecture is unnecessary if the integration points are well-defined.

### Question 6
How should the corporate Chief Architect handle the fact that Division A is already in Phase G implementation while the Strategic Architecture is being developed?

a) Halt Division A's implementation until the Strategic Architecture is complete, to prevent further divergence.

b) Allow Division A's implementation to continue under its existing Architecture Contracts but establish a governance mechanism (architecture dispensation if needed) that requires Division A to conform to the emerging Strategic Architecture for new capabilities and shared components. Use the Architecture Compliance process to assess Division A's implementation against the Strategic Architecture as it develops, and include transition requirements in Division A's Phase H change management process.

c) Exempt Division A entirely from the Strategic Architecture since their implementation is too far along to change, and focus the Strategic Architecture only on Divisions B and C.

d) Require Division A to restart their ADM cycle from Phase A once the Strategic Architecture is approved, discarding their current implementation progress.

---

## Scenario 4: The Abandoned Architecture Repository

**TechServices Global** is a large IT services company that has been practicing enterprise architecture for five years. Over this period, multiple architecture teams across the organization have diligently produced architecture artifacts—Business Architecture documents, Application Portfolio Catalogs, Technology Standards profiles, Architecture Roadmaps, and more. All of these have been stored in the Architecture Repository.

However, the enterprise recently hired a new Chief Architect who discovered a critical problem: the Architecture Repository contains over 3,000 artifacts, but the Enterprise Continuum classification was never properly implemented. Artifacts are stored with inconsistent naming conventions, no version control, no classification by Foundation/Common/Industry/Organization levels, and no clear mapping to the Architecture Landscape levels (Strategic, Segment, Capability). Architects cannot find relevant assets, leading them to create new artifacts from scratch rather than reusing existing ones. This has resulted in duplicated effort, inconsistent architectures, and frustrated stakeholders who receive contradictory architectural guidance.

The Architecture Board has given the new Chief Architect 90 days to develop a recovery strategy.

### Question 7
What is the MOST EFFECTIVE recovery strategy using TOGAF principles?

a) Delete all 3,000 artifacts and start fresh. The cost of classifying and cleaning existing artifacts exceeds the value of the content, especially since much of it is likely outdated after five years.

b) Implement a phased recovery: First, establish a proper Enterprise Continuum classification taxonomy and Architecture Landscape partitioning (Strategic, Segment, Capability levels) in the repository. Second, triage existing artifacts—classify and retain current, high-value artifacts while archiving outdated ones. Third, implement governance processes requiring all new artifacts to be classified, versioned, and mapped to the Enterprise Continuum and Architecture Landscape before being stored. Fourth, communicate the new taxonomy and processes to all architecture teams and provide training. Fifth, assign repository stewards responsible for ongoing quality.

c) Commission a dedicated team to manually classify all 3,000 artifacts within the 90-day window using the Enterprise Continuum taxonomy. Halt all new architecture work until the Repository is fully organized.

d) Migrate to a new Architecture Repository tool that automatically classifies artifacts using AI. The classification problem is a tooling issue, not a governance issue, and the right tool will solve it without process changes.

### Question 8
How should the Chief Architect address the immediate problem of architects creating duplicate artifacts because they cannot find existing ones?

a) Issue a governance mandate prohibiting the creation of any new architecture artifacts until the Repository is organized. This will force architects to find and reuse existing artifacts.

b) Implement an interim governance process: require architects to conduct a documented search of the Repository before creating new artifacts, establish a "Repository liaison" role that helps architects find existing relevant assets, create a curated catalog of the most critical and frequently-used artifacts with proper classification, and institute a peer review process that checks for duplication before approving new artifacts for the Repository.

c) Allow architects to continue creating new artifacts but tag them with a "pending classification" status. Address the backlog after the Repository reorganization is complete.

d) Transfer all Repository management responsibilities to the PMO since the architecture team has demonstrated it cannot manage its own assets effectively.

---

## Scenario 5: The Split Compliance Verdict

**RetailMax** is a national retail chain undergoing a major digital transformation. The company has developed a new omnichannel customer experience platform that integrates in-store, online, and mobile shopping experiences. The platform was developed by an external system integrator under an Architecture Contract that specifies compliance with the enterprise architecture across all four architecture domains.

During the Phase G Architecture Compliance review, the assessment reveals:
- **Business Architecture:** Conformant — all business processes align with the target business architecture
- **Data Architecture:** Non-Conformant — the platform stores customer data in a proprietary format that is incompatible with the enterprise data standards, lacks proper data lineage, and doesn't integrate with the enterprise data warehouse
- **Application Architecture:** Compliant — the application follows the spirit of the application architecture standards but uses some non-standard integration patterns
- **Technology Architecture:** Consistent — the technology stack doesn't conflict with standards but doesn't fully implement them

The project sponsors argue that the platform is already in production with 500,000 active users and generating $50M in monthly revenue. They want the Architecture Board to approve the platform as-is and grant retroactive compliance. The data architecture team insists that the non-conformant data architecture will create significant problems for the planned enterprise-wide Customer 360 initiative. The system integrator claims the proprietary data format was necessary for performance and wasn't explicitly prohibited by the Architecture Contract.

### Question 9
What should the Architecture Board decide regarding the split compliance verdict?

a) Grant full compliance approval for the platform since it is already in production and generating revenue. Business value should override architecture compliance concerns. Modify the enterprise data standards retroactively to accommodate the platform's proprietary format.

b) Acknowledge the mixed compliance results. For the Non-Conformant data architecture, issue a time-bound dispensation that allows continued operation but requires the system integrator to develop and execute a remediation plan to bring the data architecture into compliance. The dispensation should specify: the exact non-conformance, the impact assessment, the remediation milestones, the timeline, and the consequences of non-remediation. For the Compliant and Consistent ratings, document specific gaps and include them in the platform's architecture roadmap. Record all decisions in the Governance Log.

c) Declare the entire platform non-conformant since a platform cannot be partially compliant. Require the system integrator to rebuild the data layer before any further investment in the platform.

d) Escalate the decision to the CEO since the Architecture Board should not make decisions that could impact a $50M revenue stream. Architecture governance should defer to business leadership on matters of financial significance.

### Question 10
How should the Architecture Board address the system integrator's claim that the proprietary data format "wasn't explicitly prohibited" by the Architecture Contract?

a) Accept the claim and acknowledge a gap in the Architecture Contract. The Architecture Board should take responsibility for the oversight and not penalize the integrator.

b) Review the Architecture Contract terms carefully. If the contract specifies compliance with enterprise data standards (which include data format standards), then using a proprietary format is a violation regardless of whether the specific format was explicitly prohibited. The Board should document this as a lesson learned, update the Architecture Contract template to include more explicit data architecture requirements for future engagements, strengthen the architecture review checkpoints during implementation governance (Phase G), and assess whether the integrator's claim indicates a need for clearer communication of architecture standards to development partners.

c) Impose financial penalties on the system integrator for violating the Architecture Contract. The proprietary format was clearly non-compliant and the integrator should have known better.

d) Accept the proprietary format as a new enterprise standard since it has proven to deliver performance benefits. Innovation sometimes requires deviating from established standards.

---

## Scenario 6: The Vendor Bankruptcy Crisis

**LogisticsOne** is a global logistics company executing a multi-year architecture transformation program. The Architecture Roadmap, developed in Phase F, defines five Transition Architectures to reach the Target Architecture over four years:

- **Transition 1** (Complete): Migrated warehouse management to a modern cloud-based platform
- **Transition 2** (In Progress): Implementing a new real-time fleet tracking and route optimization system from vendor "FleetTech" — this is 70% complete
- **Transition 3** (Planned): Building an integrated customer visibility portal that depends on real-time data from the Transition 2 fleet tracking system
- **Transition 4** (Planned): Deploying an AI-powered demand forecasting engine that uses data from both the warehouse system (Transition 1) and fleet tracking system (Transition 2)
- **Transition 5** (Planned): Full platform integration with autonomous vehicle management capabilities

FleetTech has just declared bankruptcy. Their SaaS platform will shut down in 90 days. The Transition 2 implementation is 70% complete with $15M already invested. Transitions 3, 4, and 5 all have dependencies on the fleet tracking capability that Transition 2 was supposed to deliver.

### Question 11
What is the CORRECT TOGAF approach for emergency re-planning?

a) Immediately return to Phase A and develop a completely new Architecture Vision that excludes the fleet tracking capability. The bankruptcy invalidates the entire architecture program, and the Architecture Board should approve a fundamentally different approach.

b) Invoke Phase H: Architecture Change Management to assess the impact. The bankruptcy represents a significant technology change that affects the architecture. Perform an impact assessment across all affected Transition Architectures. Then iterate back to Phase E to re-evaluate opportunities and solutions for the fleet tracking capability—evaluate alternative vendors, open-source solutions, or in-house development. Update the Architecture Roadmap in Phase F to reflect new dependencies, timeline, and risk mitigation. Engage the Architecture Board to approve the revised plan. Throughout, use Requirements Management to ensure the fleet tracking requirements are preserved even as the solution changes.

c) Continue with the remaining Transitions (3, 4, 5) as planned but replace FleetTech with an equivalent vendor. The Architecture Roadmap should remain unchanged except for the vendor substitution, as the architecture itself hasn't changed—only the solution building block has.

d) Cancel Transitions 3, 4, and 5 since their dependency on Transition 2 makes them non-viable. Declare Transition 1 as the final state and close the architecture program.

### Question 12
How should the Architecture Board assess the $15M already invested in the FleetTech implementation?

a) Write off the entire $15M investment as a sunk cost and do not let it influence architectural decisions going forward. Architecture decisions should be based on future value, not past investment.

b) Conduct a thorough assessment of what was built during the 70% completion: identify which components, data, configurations, and integrations can be salvaged or repurposed. Evaluate whether the ABBs (Architecture Building Blocks) defined for fleet tracking remain valid even though the specific SBB (FleetTech) has failed. Determine what parts of the implementation can be migrated to an alternative solution. Factor this analysis into the Phase E re-evaluation to maximize recovery of the investment while making architecture-sound decisions.

c) Sue FleetTech's bankruptcy estate to recover the $15M investment before making any architecture decisions. Financial recovery should be the priority.

d) Use the $15M loss as justification to reduce the scope of the entire architecture program. Request that the Architecture Board proportionally reduce budget for all remaining transitions.

---

## Scenario 7: The Compressed Architecture Vision

**HealthPlus** is a mid-size health insurance company. The CEO has announced a strategic partnership with a major technology company to launch a new "Digital Health Marketplace" business line. The partnership agreement requires HealthPlus to present a viable technology architecture to the partner within 4 weeks. The CEO demands that the architecture team deliver an Architecture Vision within 2 weeks, leaving 2 weeks for partner review and negotiation.

The enterprise architecture team normally takes 8 weeks for Phase A, including stakeholder engagement, capability assessment, business scenario development, and Architecture Board reviews. The team consists of a Chief Architect and two enterprise architects. The company has a mature architecture practice at Level 3 maturity with well-documented architecture principles, a current Architecture Landscape, and an active Architecture Repository.

The Architecture Board chair (CTO) asks the Chief Architect: "Can we deliver a credible Architecture Vision in 2 weeks? And if so, how do we ensure it doesn't become a throwaway document that we have to redo?"

### Question 13
How should the Chief Architect adapt the ADM to deliver an Architecture Vision in 2 weeks?

a) Tell the CEO it's impossible to produce a quality Architecture Vision in 2 weeks and request the full 8-week timeline. Compromising architecture quality for business deadlines violates TOGAF principles and will result in rework.

b) Apply TOGAF's ADM tailoring guidance to create a compressed but rigorous Phase A. Leverage the organization's mature architecture capability: use existing architecture principles (no need to redefine), leverage the current Architecture Landscape as baseline (skip extensive as-is analysis), focus business scenarios on the Digital Health Marketplace use case only (narrow scope), limit stakeholder engagement to the 5 most critical stakeholders, produce a focused Architecture Vision that addresses the partnership scope specifically, and explicitly document what was deferred and what constraints apply to the compressed timeline. Schedule a formal Architecture Board review at the 2-week mark and plan a subsequent iteration to elaborate the Vision once the partnership terms are confirmed.

c) Produce a "draft" Architecture Vision in 2 weeks using only high-level assumptions. Mark it as "preliminary" and plan to replace it with a proper Architecture Vision after the partnership is confirmed. This way the architecture team delivers on time without committing to architectural decisions prematurely.

d) Skip Phase A entirely and go directly to Phase C to define the Application Architecture for the Digital Health Marketplace. The partner cares about technology architecture, not business architecture. Produce a technology solution document and present it as the Architecture Vision.

### Question 14
What TOGAF governance considerations should the Chief Architect address when compressing the timeline?

a) No governance considerations are needed for a compressed timeline. Governance is only relevant for full ADM cycles.

b) The Chief Architect should: ensure the Architecture Board formally approves the tailored ADM approach and compressed timeline (not bypassing governance, but adapting it), document the tailoring decisions and their rationale in the Architecture Repository, establish clear governance checkpoints within the 2-week window (e.g., midpoint review, final Architecture Board approval), explicitly define the scope limitations and risks of the compressed approach in the Statement of Architecture Work, and plan a governance-approved iteration cycle to address gaps identified during the compression.

c) Request the Architecture Board to waive all governance requirements for this engagement since the compressed timeline doesn't allow for proper governance reviews. Resume governance when the full ADM cycle begins.

d) Delegate all governance decisions to the Chief Architect for the duration of the compressed engagement. The Architecture Board can review the completed Architecture Vision retroactively.

---

## Scenario 8: Capability vs. Segment Architecture Debate

**EnergyForward** is a large energy utility company planning a major initiative to implement a "Smart Grid" capability across its operations. The initiative will affect electricity generation, transmission, distribution, and retail operations. It involves IoT sensor deployment, real-time grid monitoring, predictive maintenance, dynamic pricing, and customer engagement through smart meters.

Two senior enterprise architects disagree on the approach:

**Architect A** advocates for a **Segment Architecture** approach. His reasoning: the Smart Grid initiative primarily affects the Distribution division and should be scoped as a segment of the enterprise. This allows a focused, manageable architecture effort that can be completed in 6 months and delivered to the Distribution VP. He argues that trying to address all divisions simultaneously would be too complex and take too long.

**Architect B** advocates for a **Capability Architecture** approach. Her reasoning: "Smart Grid" is a cross-cutting capability that spans generation, transmission, distribution, and retail. IoT sensors in generation plants feed data to transmission optimization, which affects distribution routing, which impacts retail pricing. Treating it as a segment would miss critical interdependencies and result in suboptimal architecture. She proposes a 12-month capability-focused architecture effort.

The Architecture Board must decide. The CTO is impatient for results. The Distribution VP wants something he can implement quickly. The CEO wants the full enterprise benefit.

### Question 15
Based on TOGAF guidance, which approach should the Architecture Board recommend?

a) Adopt Architect A's Segment Architecture approach because speed to delivery is the priority. The Architecture Board can always commission a broader architecture effort later if needed.

b) Adopt Architect B's Capability Architecture approach because completeness and cross-divisional alignment are essential. The Architecture Board should explain to the CTO and Distribution VP that a 12-month timeline is necessary for architectural integrity.

c) Recommend a hybrid approach informed by TOGAF's Architecture Landscape levels. Start with a Strategic Architecture-level assessment (2-3 months) that identifies the full scope of Smart Grid impacts across all divisions and establishes enterprise-wide architecture principles and constraints. Then commission a Segment Architecture for the Distribution division (3-4 months) that operates within the strategic context and delivers the quick win the Distribution VP needs. Simultaneously, plan Capability Architecture efforts for cross-cutting elements (IoT platform, data analytics, integration) that will serve all divisions. This approach respects both the need for speed and the need for enterprise coherence.

d) Reject both proposals and ask the architects to develop a single, unified approach. Internal disagreement among architects damages the credibility of the architecture function, and the Architecture Board should not be asked to arbitrate technical disputes.

### Question 16
How should the Architecture Board ensure that whichever approach is chosen maintains alignment with the enterprise architecture?

a) No additional alignment measures are needed. The ADM inherently ensures alignment through its phase structure.

b) Establish explicit governance mechanisms: require the chosen architecture effort to reference and comply with existing enterprise Architecture Principles, mandate that all architecture deliverables are reviewed against the Strategic Architecture (if one exists) or that strategic constraints are explicitly documented, ensure the Architecture Repository is updated with all artifacts classified according to the Enterprise Continuum and Architecture Landscape levels, institute formal Architecture Compliance checkpoints at phase transitions, and require that cross-divisional impacts and dependencies are documented in the Architecture Requirements Specification and reviewed by affected division stakeholders.

c) Assign both architects to work together on the chosen approach. Their combined perspectives will naturally ensure alignment.

d) Require the Distribution VP to sign an Architecture Contract guaranteeing that the Smart Grid implementation will conform to whichever enterprise-level architecture emerges later, even if it requires rework.

---

## Answer Key

### Scenario 1 - Question 1
**Scoring:**
- **Answer b) = 5 (Best):** This is the most appropriate TOGAF response. Discovering conflicting requirements during Phase B is a normal part of the ADM process. The correct approach is to document these conflicts as architecture constraints within the current phase, use Business Scenarios to model different regulatory contexts, and produce a Business Architecture that explicitly addresses regulatory segmentation. Flagging conflicts as risks in the Architecture Requirements Specification allows them to be managed through Requirements Management without unnecessarily restarting Phase A. The Architecture Vision's "single hybrid cloud" can be refined rather than replaced.
- **Answer a) = 3:** Returning to Phase A is a valid consideration when fundamental assumptions are invalidated, and this answer correctly identifies the potential inadequacy of the original vision. However, it may be premature—Phase B discovery of constraints is expected, and the "single hybrid cloud" vision may be adaptable to a federated model without fully restarting Phase A. This approach risks unnecessary delay.
- **Answer c) = 1:** Requesting a dispensation to proceed with a potentially flawed Architecture Vision is governance misuse. Dispensations are for temporary deviations from standards, not for ignoring architectural feasibility issues. Assuming technology will resolve fundamental architectural conflicts is a dangerous approach that TOGAF governance is designed to prevent.
- **Answer d) = 0:** Halting the architecture engagement entirely misunderstands the ADM's purpose. The ADM is specifically designed to handle complex requirements including regulatory constraints. Commissioning a separate compliance assessment outside the ADM creates a governance gap and delays the architecture work unnecessarily.

### Scenario 1 - Question 2
**Scoring:**
- **Answer b) = 5 (Best):** This answer correctly applies TOGAF's stakeholder management approach. Mapping stakeholders, documenting concerns, identifying conflicts, and developing cross-cutting viewpoints is exactly how TOGAF handles multi-stakeholder complexity. Creating views that demonstrate trade-offs approved by the Architecture Board ensures governance oversight of conflict resolution. This is the systematic, architecture-driven approach.
- **Answer a) = 3:** Creating separate Architecture Contracts acknowledges stakeholder needs but defers conflict resolution to Phase G, which is too late. Conflicts in architectural requirements should be resolved during architecture development (Phases B-D), not during implementation governance. However, the recognition that formal agreements are needed earns partial credit.
- **Answer c) = 1:** Prioritizing one stakeholder's requirements over others without proper analysis violates the balanced stakeholder engagement principles of TOGAF. While security is important, TOGAF does not prescribe a hierarchy where security automatically overrides all other concerns. The Architecture Board should facilitate balanced resolution.
- **Answer d) = 0:** Deferring stakeholder conflict resolution to the PMO fundamentally misunderstands the role of architecture governance. The Architecture Board exists precisely to resolve architectural conflicts between stakeholders. The PMO manages project delivery, not architecture decisions.

### Scenario 2 - Question 3
**Scoring:**
- **Answer a) = 5 (Best):** This is the correct TOGAF approach. The Requirements Management process is the proper channel for documenting changed requirements and technical infeasibility. Iterating back to Phase A to revise the Architecture Vision—while preserving the valuable Phase B and partial Phase C work—is exactly how the ADM is designed to handle significant scope changes. This approach respects governance (updating the Statement of Architecture Work, re-engaging the Architecture Board) while being pragmatic (not starting from scratch).
- **Answer b) = 3:** Starting from the Preliminary Phase is overly aggressive. While the change in CEO warrants review, the architecture principles, organizational model, and governance framework established in the Preliminary Phase may still be valid. A complete restart wastes the work done in Phases A through C. However, this answer correctly recognizes the significance of the strategic change.
- **Answer c) = 1:** Continuing with an Architecture Vision that is based on incorrect assumptions (API-extensible core banking) and an outdated business strategy is architecturally unsound. The vision is not merely aspirational—it sets the scope and direction for all subsequent architecture work. Adding a $200M platform replacement as a "work package" without revising the vision creates governance and alignment problems.
- **Answer d) = 0:** Treating the Statement of Architecture Work as immutable contradicts TOGAF governance principles. The ADM is explicitly designed to support iteration and change. The Statement of Architecture Work should be updated when circumstances change significantly. Blindly following an outdated commitment undermines the purpose of architecture governance.

### Scenario 2 - Question 4
**Scoring:**
- **Answer b) = 5 (Best):** This answer correctly applies TOGAF governance principles for dispute resolution. The approach is systematic: document options, assess against principles and strategy, seek stakeholder input, and attempt consensus. The escalation path to the executive sponsor is the proper governance mechanism when the Board cannot reach consensus. This maintains the integrity of the governance process while acknowledging practical limitations.
- **Answer a) = 3:** While the chair may need to make final decisions in some circumstances, TOGAF does not designate the chair as having automatic casting vote authority. The chair's role is to facilitate governance, not to act as a unilateral decision-maker. However, strong leadership from the chair is appropriate and this answer recognizes that someone must break the deadlock.
- **Answer c) = 1:** Simple majority voting is not the TOGAF-recommended governance mechanism for architecture decisions. Architecture decisions should be evidence-based and aligned with principles, not determined by vote count. A 4-3 vote could result in a decision that contradicts architecture principles or business strategy.
- **Answer d) = 0:** The Chief Architect does not have authority to override the Architecture Board. TOGAF positions the Architecture Board as the governance authority, not the Chief Architect. While the Chief Architect provides recommendations and technical guidance, the Board makes governance decisions.

### Scenario 3 - Question 5
**Scoring:**
- **Answer b) = 5 (Best):** This is the comprehensive, TOGAF-aligned approach. Initiating a Strategic Architecture ADM cycle at the enterprise level is correct—you need a higher-level architecture to reconcile segment architectures. Using the Preliminary Phase to establish a common framework addresses the version inconsistency problem. Mapping existing segment artifacts to a unified metamodel and identifying overlaps and conflicts is the systematic approach. This preserves the value of existing work while creating enterprise coherence.
- **Answer c) = 3:** Selecting the most mature Segment Architecture as a baseline has pragmatic appeal and recognizes that Division A's maturity could accelerate the process. However, the automotive division's architecture was designed for automotive-specific needs and may not be appropriate as an enterprise-wide baseline. This approach risks forcing inappropriate architectural choices on other divisions. Partial credit for recognizing the value of building on existing mature work.
- **Answer d) = 1:** A lightweight integration layer addresses only immediate shared-services needs and ignores the CEO's directive for enterprise-wide strategic alignment. While pragmatic in the short term, this approach fails to deliver the cross-divisional innovation and common data platform the CEO requires. It also doesn't address the underlying problem of inconsistent architectures.
- **Answer a) = 0:** Discarding all three Segment Architectures wastes years of valuable architecture work. The version differences between TOGAF 9.1, 9.2, and 10th Edition are not so fundamental that segment architecture artifacts cannot be reconciled. The core ADM concepts, Content Metamodel entities, and architecture principles remain largely consistent across these versions.

### Scenario 3 - Question 6
**Scoring:**
- **Answer b) = 5 (Best):** This answer balances practical reality (an active implementation that cannot be casually stopped) with governance requirements (alignment with the emerging Strategic Architecture). Using Architecture Compliance assessment, dispensations where needed, and Phase H change management to gradually align Division A is exactly how TOGAF governance handles in-flight implementations. This approach minimizes disruption while maintaining architectural integrity.
- **Answer c) = 3:** Exempting Division A entirely is pragmatic but creates a governance gap. If Division A's implementation proceeds without any alignment to the Strategic Architecture, it may create integration challenges that undermine the enterprise architecture goals. However, this answer recognizes the impracticality of disrupting an active implementation, earning partial credit.
- **Answer a) = 1:** Halting a division's implementation for an enterprise architecture exercise is disproportionate and would damage the architecture function's credibility with business stakeholders. This approach prioritizes architectural purity over business continuity and would likely face strong resistance from Division A's leadership.
- **Answer d) = 0:** Requiring Division A to restart from Phase A after reaching Phase G is wasteful and impractical. It disregards the significant investment in Division A's architecture and implementation work and would severely damage business stakeholder trust in the architecture function.

### Scenario 4 - Question 7
**Scoring:**
- **Answer b) = 5 (Best):** This phased recovery approach is comprehensive and practical. It addresses the root cause (missing classification taxonomy and governance), implements triage for existing content (preserving value while removing waste), establishes forward-looking governance, includes change management (communication and training), and creates ongoing accountability (repository stewards). The phased approach is realistic for a 90-day window.
- **Answer c) = 3:** A dedicated classification team addresses the immediate problem but has significant weaknesses: halting all architecture work for 90 days is unacceptable to business stakeholders, and manual classification of 3,000 artifacts in 90 days may not be feasible. However, the recognition that classification is necessary earns partial credit. This approach also fails to address the governance gap that allowed the problem to occur.
- **Answer d) = 1:** While better tooling may help, framing the problem as purely a tooling issue misses the fundamental governance failure. Even the best tool cannot compensate for the absence of classification standards, naming conventions, and governance processes. Technology alone will not solve what is fundamentally an organizational and governance problem.
- **Answer a) = 0:** Deleting all 3,000 artifacts is an extreme overreaction that destroys potentially valuable intellectual property. Many recent artifacts are likely still valid and useful. A triage approach that retains current, high-value artifacts is far more appropriate than wholesale deletion.

### Scenario 4 - Question 8
**Scoring:**
- **Answer b) = 5 (Best):** This interim governance approach addresses the duplication problem immediately while the longer-term Repository reorganization proceeds. Requiring documented searches, providing liaison support, curating critical artifacts, and peer reviewing for duplication are all practical, implementable measures. This approach balances the need for immediate improvement with the recognition that the full solution will take time.
- **Answer c) = 3:** Allowing continued creation with "pending classification" is pragmatic and avoids disrupting current work. However, it does nothing to prevent duplication and will actually worsen the problem by adding more unclassified artifacts to the backlog. The tag-and-defer approach recognizes the problem but doesn't address it. Partial credit for pragmatism.
- **Answer a) = 1:** Prohibiting new artifact creation is an overly rigid governance response that will paralyze architecture work. Architects cannot do their jobs without creating documentation. This approach prioritizes repository order over architecture delivery and would damage the architecture function's ability to serve the business.
- **Answer d) = 0:** Transferring Repository management to the PMO is an abdication of architecture governance responsibility. The Architecture Repository is a core component of the architecture capability, and its management is an architecture function responsibility. The PMO lacks the architectural expertise to manage architecture assets effectively.

### Scenario 5 - Question 9
**Scoring:**
- **Answer b) = 5 (Best):** This is the balanced, governance-sound approach. Acknowledging mixed compliance results and treating each domain appropriately demonstrates mature governance. The time-bound dispensation for the data architecture non-conformance allows business continuity while requiring remediation. Specifying dispensation details (scope, impact, milestones, timeline, consequences) follows TOGAF dispensation best practices. Recording decisions in the Governance Log maintains audit trail integrity.
- **Answer a) = 3:** Granting full compliance is tempting given the business value, but retroactively modifying enterprise data standards to accommodate one platform's proprietary format is a dangerous precedent. This approach correctly recognizes business value but undermines the integrity of enterprise standards and could cause problems for the Customer 360 initiative. Partial credit for acknowledging the business reality.
- **Answer c) = 1:** Declaring the entire platform non-conformant ignores the multi-domain nature of compliance assessment. TOGAF's compliance assessment framework explicitly allows different compliance levels across different architecture domains. Requiring a complete rebuild is disproportionate when the non-conformance is limited to data architecture. This approach would destroy significant business value unnecessarily.
- **Answer d) = 0:** Escalating to the CEO abdicates the Architecture Board's governance responsibility. The Architecture Board exists to make exactly these kinds of decisions. Deferring to the CEO on architecture compliance undermines the entire governance framework and sets a precedent that business considerations always override architectural integrity.

### Scenario 5 - Question 10
**Scoring:**
- **Answer b) = 5 (Best):** This is the most thorough and constructive response. It addresses the specific claim by examining the Architecture Contract terms, documents the lesson learned, improves the contract template for future engagements, strengthens governance checkpoints, and assesses communication gaps. This response turns a governance challenge into an opportunity for governance improvement—a hallmark of mature architecture governance.
- **Answer a) = 3:** Acknowledging a gap in the Architecture Contract is honest and appropriate. However, simply accepting the claim without examining the contract terms or implementing improvements for the future is insufficient. If the contract specified compliance with enterprise data standards, the integrator's claim may not be valid. Partial credit for transparency and accountability.
- **Answer d) = 1:** Accepting a proprietary format as a new enterprise standard based on a single implementation's performance claims undermines standards governance. Enterprise standards should be evaluated through proper governance processes, not adopted retroactively to accommodate non-conformant implementations. However, the willingness to consider new approaches based on demonstrated benefits shows some governance maturity.
- **Answer c) = 0:** Imposing financial penalties without first reviewing the Architecture Contract terms is premature and adversarial. Architecture governance should be collaborative, not punitive. The goal is architecture conformance, not financial recovery. Punitive approaches damage relationships with development partners and discourage future engagement with architecture governance.

### Scenario 6 - Question 11
**Scoring:**
- **Answer b) = 5 (Best):** This is the comprehensive TOGAF response to a crisis. Invoking Phase H for impact assessment is correct—the vendor bankruptcy is a significant change event. Iterating back to Phase E to re-evaluate solutions preserves the architecture requirements while finding new solutions. Updating the Architecture Roadmap in Phase F reflects the new reality. Requirements Management ensures the fleet tracking requirements survive the solution change. Architecture Board engagement maintains governance. This approach is systematic, governance-sound, and pragmatic.
- **Answer c) = 3:** Substituting another vendor is pragmatic and recognizes that the architecture itself (ABBs, requirements) hasn't changed—only the SBB has. However, this oversimplifies the situation. A like-for-like vendor replacement for a 70%-complete implementation is unlikely to be straightforward. Data migration, integration rework, and timeline impacts all need to be assessed through proper ADM phases. Partial credit for the important insight about architecture vs. solution stability.
- **Answer a) = 1:** Returning to Phase A for a completely new Architecture Vision is an overreaction. The fleet tracking capability is one component of a broader architecture program. The Architecture Vision and the Transition 1 achievement remain valid. The crisis requires re-planning the solution and roadmap, not reimagining the architecture vision.
- **Answer d) = 0:** Canceling Transitions 3-5 and accepting Transition 1 as the final state is a defeatist approach that abandons the enterprise architecture goals because of one vendor failure. The business requirements that drove the full architecture program haven't changed. TOGAF's ADM is designed to handle exactly this kind of change through Phase H and iteration.

### Scenario 6 - Question 12
**Scoring:**
- **Answer b) = 5 (Best):** This answer demonstrates sophisticated understanding of TOGAF concepts. The distinction between ABBs (which remain valid regardless of SBB failure) and SBBs (which need replacement) is critical. Assessing salvageable components, configurations, and integrations from the 70% completion maximizes recovery. Factoring this analysis into Phase E re-evaluation ensures that architecture decisions are informed by practical considerations without being driven by sunk cost fallacy.
- **Answer a) = 3:** The sunk cost principle is valid in decision theory, and architecture decisions should indeed be forward-looking. However, completely ignoring the 70% completed implementation wastes potentially recoverable value. Components, integrations, data, and knowledge gained from the FleetTech implementation may be transferable to an alternative solution. Partial credit for the correct principle but incomplete application.
- **Answer d) = 1:** Using a vendor bankruptcy as justification to reduce the overall architecture program scope is an inappropriate response. The budget reduction has no logical connection to the fleet tracking vendor failure. Other transitions may not be affected by vendor risk. This approach uses the crisis as an excuse to reduce architecture investment rather than addressing the specific problem.
- **Answer c) = 0:** Pursuing legal action against a bankrupt vendor as a priority over architectural re-planning demonstrates misplaced priorities. Legal matters should be handled by the legal department in parallel with—not instead of—architecture re-planning. The 90-day platform shutdown timeline makes urgent architectural action essential, not legal proceedings.

### Scenario 7 - Question 13
**Scoring:**
- **Answer b) = 5 (Best):** This answer correctly applies TOGAF's ADM tailoring guidance. The key insight is that a mature architecture capability (Level 3) has existing assets that dramatically reduce Phase A effort. Leveraging existing principles, architecture landscape, and repository content is exactly what maturity enables. Narrowing scope to the partnership use case is valid tailoring. Documenting deferrals and constraints maintains integrity. Planning a subsequent iteration ensures the compressed Vision isn't a dead end.
- **Answer c) = 3:** A "draft" or "preliminary" Architecture Vision is a pragmatic compromise, and marking it as preliminary sets appropriate expectations. However, TOGAF doesn't distinguish between "draft" and "real" Architecture Visions—the Vision should be as rigorous as possible within constraints. Planning to replace it entirely suggests the initial effort lacks architectural value. Partial credit for pragmatism and managing expectations.
- **Answer a) = 1:** Refusing to adapt to business timelines demonstrates rigid thinking that undermines the architecture function's credibility. TOGAF explicitly supports ADM tailoring, and the organization's Level 3 maturity provides the foundation for compressed execution. An absolute refusal to compress the timeline ignores TOGAF's flexibility principles.
- **Answer d) = 0:** Skipping Phase A and jumping to Phase C fundamentally violates the ADM's purpose. The Architecture Vision establishes scope, stakeholder alignment, and business value justification. A technology solution document without business architecture context will fail to deliver the strategic partnership alignment the CEO requires. This approach also conflates architecture with solution design.

### Scenario 7 - Question 14
**Scoring:**
- **Answer b) = 5 (Best):** This answer demonstrates that governance adapts to circumstances without being abandoned. Architecture Board approval of the tailored approach, documentation of tailoring decisions, embedded checkpoints, explicit scope limitations, and planned iteration are all sound governance practices. The key principle is that compressed timelines require adapted governance, not absent governance.
- **Answer d) = 3:** Delegating decisions to the Chief Architect with retroactive Board review is pragmatic for a compressed timeline. However, this approach weakens governance by removing the Architecture Board from real-time decision-making. If the Chief Architect makes a decision the Board later disagrees with, retroactive correction is more costly than upfront governance. Partial credit for acknowledging the time pressure while maintaining some governance.
- **Answer c) = 1:** Waiving all governance requirements, even temporarily, sets a dangerous precedent. Future engagements may cite this precedent to bypass governance. Additionally, the compressed timeline is exactly when governance is most needed—rushed decisions without oversight are the highest risk for architectural errors. This approach misunderstands governance as bureaucratic overhead rather than risk management.
- **Answer a) = 0:** Stating that governance is only relevant for full ADM cycles fundamentally misunderstands TOGAF governance. Governance applies to ALL architecture work, regardless of scope or timeline. Compressed engagements may have adapted governance mechanisms, but they must have governance. This answer reveals a critical misunderstanding of TOGAF principles.

### Scenario 8 - Question 15
**Scoring:**
- **Answer c) = 5 (Best):** This hybrid approach demonstrates sophisticated understanding of TOGAF's Architecture Landscape levels. Starting with a Strategic Architecture assessment provides the enterprise-wide context. Then executing a Segment Architecture for Distribution delivers the quick win. Parallel Capability Architecture efforts for cross-cutting elements address Architect B's valid concern about interdependencies. This approach satisfies all stakeholders: the CTO gets speed (Strategic assessment in 2-3 months, Segment delivery in 6-7 months), the Distribution VP gets a focused deliverable, and the CEO gets enterprise-wide benefit through the capability architectures.
- **Answer b) = 3:** Architect B's reasoning is technically sound—Smart Grid IS a cross-cutting capability. However, proposing a 12-month monolithic effort ignores the business reality of impatient stakeholders and the risk of a large architecture effort losing momentum. The completeness argument is valid, but the approach lacks pragmatism. Partial credit for correct architectural analysis.
- **Answer a) = 1:** Architect A's speed-focused approach addresses the CTO's and Distribution VP's concerns but risks creating a siloed architecture that misses critical cross-divisional interdependencies. The assertion that "we can always do a broader effort later" often results in the broader effort never happening, leaving the enterprise with an architecturally suboptimal solution. Partial credit for pragmatism.
- **Answer d) = 0:** Rejecting both proposals and asking for a unified approach is an abdication of the Architecture Board's decision-making role. The Board exists to evaluate options and make decisions, including when experts disagree. Suppressing healthy technical debate damages the architecture culture. The disagreement reveals a genuine architectural tension that the Board should address, not dismiss.

### Scenario 8 - Question 16
**Scoring:**
- **Answer b) = 5 (Best):** This comprehensive set of governance mechanisms ensures alignment regardless of which approach is chosen. Referencing enterprise principles, reviewing against Strategic Architecture, updating the Repository with proper classification, compliance checkpoints, and cross-divisional impact documentation are all TOGAF-aligned governance practices. These mechanisms work for both Segment and Capability approaches and ensure the chosen architecture serves enterprise interests.
- **Answer c) = 3:** Having both architects collaborate is a good team practice that leverages their complementary perspectives. However, relying on their combined perspectives to "naturally ensure alignment" is naive—alignment requires formal governance mechanisms, not just good intentions. Collaboration addresses the interpersonal dynamic but not the structural governance requirements. Partial credit for the collaborative approach.
- **Answer d) = 1:** Requiring the Distribution VP to sign an Architecture Contract guaranteeing future conformance sounds like good governance but is impractical. The VP cannot commit to conforming to an architecture that doesn't yet exist. Architecture Contracts should be based on defined architectures, not future unknowns. This approach also places inappropriate risk on a single stakeholder.
- **Answer a) = 0:** Stating that the ADM inherently ensures alignment is incorrect. While the ADM provides a structured approach, explicit governance mechanisms are needed to ensure a Segment or Capability Architecture aligns with enterprise architecture. Without deliberate governance, architectures can diverge from enterprise direction despite following the ADM correctly. Alignment requires conscious effort, not just process adherence.

---

## Score Card

| Scenario | Question | Your Answer | Points (0-5) |
|---|---|---|---|
| Scenario 1: Regulatory Compliance | Q1 | ___ | ___/5 |
| Scenario 1: Regulatory Compliance | Q2 | ___ | ___/5 |
| Scenario 2: Failed Architecture Vision | Q3 | ___ | ___/5 |
| Scenario 2: Failed Architecture Vision | Q4 | ___ | ___/5 |
| Scenario 3: Reconciling Segments | Q5 | ___ | ___/5 |
| Scenario 3: Reconciling Segments | Q6 | ___ | ___/5 |
| Scenario 4: Abandoned Repository | Q7 | ___ | ___/5 |
| Scenario 4: Abandoned Repository | Q8 | ___ | ___/5 |
| Scenario 5: Split Compliance | Q9 | ___ | ___/5 |
| Scenario 5: Split Compliance | Q10 | ___ | ___/5 |
| Scenario 6: Vendor Bankruptcy | Q11 | ___ | ___/5 |
| Scenario 6: Vendor Bankruptcy | Q12 | ___ | ___/5 |
| Scenario 7: Compressed Vision | Q13 | ___ | ___/5 |
| Scenario 7: Compressed Vision | Q14 | ___ | ___/5 |
| Scenario 8: Capability vs. Segment | Q15 | ___ | ___/5 |
| Scenario 8: Capability vs. Segment | Q16 | ___ | ___/5 |
| | **TOTAL** | | **___/80** |

**Scaled Score: ___ / 40** (divide total by 2)

| Scaled Score | Rating |
|---|---|
| 36-40 | TOGAF Master Practitioner - You can handle any real-world challenge |
| 30-35 | Expert - Strong ability to apply TOGAF in complex situations |
| 24-29 | Pass - You can apply TOGAF concepts but review edge cases |
| 18-23 | Near Miss - Need more practice with multi-concept scenarios |
| Below 18 | Focus on understanding how TOGAF concepts work together in practice |
