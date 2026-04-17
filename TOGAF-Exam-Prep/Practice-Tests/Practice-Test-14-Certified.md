# TOGAF Part 2 Certified - Practice Test 14
## Focus: ADM Phase Selection, Stakeholder Management, Governance, Scope, Compliance, Migration, Change Management, Requirements

**Time Allowed:** 90 minutes | **Questions:** 8 | **Pass Mark:** 60% (24/40)

**Instructions:** Each question presents a scenario and asks you to select the BEST answer. Answers are scored on a graduated scale:
- Best answer = 5 points
- Second best = 3 points
- Third best = 1 point
- Worst/Distractor = 0 points

---

## Scenario 1: ADM Phase Selection for a Digital Transformation

GlobalRetail Corp is a multinational retail company with 500 stores across 12 countries. The company has operated with a decentralized IT model for 15 years, where each regional division independently purchased and managed its own systems. The new CIO, hired six months ago, has been tasked by the board with leading a "Digital Transformation" initiative that will unify the company's disparate systems into a single, cloud-based platform supporting e-commerce, supply chain management, and customer analytics.

The CIO has assembled a team of three enterprise architects. However, GlobalRetail has never had a formal enterprise architecture practice. There are no documented architecture principles, no governance framework, no architecture repository, and no established relationships between the architecture team and the regional IT directors. The regional IT directors are skeptical of the initiative, viewing it as a threat to their autonomy. The board expects visible progress within six months.

The lead enterprise architect must decide the best approach to begin the architecture effort.

### Question 1
Given this situation, what should the lead enterprise architect recommend as the FIRST major activity?

a) Begin with the Preliminary Phase to establish the architecture capability, define principles, set up governance, and build organizational support before launching the ADM cycle for the digital transformation  
b) Begin directly with Phase A (Architecture Vision) for the digital transformation to show quick progress to the board, and establish architecture governance practices in parallel  
c) Begin with Phase B (Business Architecture) to quickly document the current business processes across all regions, since understanding the business is the most urgent need  
d) Begin with Phase E (Opportunities and Solutions) to identify quick-win technology consolidation projects that demonstrate value to skeptical stakeholders  

---

## Scenario 2: Stakeholder Management During Architecture Development

MedTech Industries is a mid-sized medical device manufacturer developing a new integrated quality management and regulatory compliance system. The enterprise architect, Sarah, has completed Phase A and is midway through Phase B (Business Architecture). She has identified 14 key stakeholders, but three critical conflicts have emerged:

1. The VP of Quality Assurance insists that all quality data must remain on-premises due to regulatory concerns about cloud storage of medical device records, citing FDA 21 CFR Part 11 requirements.
2. The CTO is pushing for a fully cloud-native architecture, arguing that on-premises infrastructure is too expensive and limits scalability.
3. The VP of Manufacturing Operations is concerned that the new system will disrupt production during the transition period, as the company cannot afford any downtime during its busiest season (Q4).

Sarah has attempted to resolve these conflicts through individual meetings, but each stakeholder is firm in their position. The Architecture Vision approved in Phase A did not anticipate these specific conflicts. The project sponsor (COO) has limited technical knowledge and has asked Sarah to recommend a path forward.

### Question 2
What should Sarah recommend as the best approach to resolve these stakeholder conflicts?

a) Escalate the conflicts to the Architecture Board for a binding governance decision, presenting each stakeholder's position and requesting the board to mandate a specific approach based on architectural best practices  
b) Revisit the Architecture Vision with all three stakeholders together, using the Requirements Management process to update requirements based on regulatory constraints, and develop a hybrid architecture option (sensitive data on-premises, other workloads in cloud) with a phased migration that avoids Q4 disruption  
c) Proceed with Phase B using the CTO's cloud-native approach since the CTO has the highest technical authority, and document the other stakeholders' concerns as risks to be addressed during implementation  
d) Pause the architecture effort and commission a separate regulatory compliance study to determine exactly which data must remain on-premises, before resuming Phase B with definitive regulatory guidance  

---

## Scenario 3: Architecture Governance Decision

NorthStar Financial Services is a large bank that has had a mature enterprise architecture practice for eight years. The Architecture Board meets monthly and governs all major technology initiatives. During a routine Architecture Compliance review, the board discovers that the Consumer Banking division's new mobile application, which is already 70% developed, has deviated significantly from the approved Target Architecture.

Specifically, the mobile app team has:
- Built their own custom authentication service instead of using the enterprise-standard Identity and Access Management (IAM) platform
- Used a NoSQL database for customer account data instead of the mandated relational database standard
- Deployed on a different cloud provider than the enterprise standard

The mobile app team argues that these deviations were necessary because the enterprise standards were too slow for mobile user experiences, and the project had aggressive time-to-market deadlines set by the CEO. The app is already being beta-tested by 10,000 customers and has received excellent feedback.

### Question 3
What should the Architecture Board recommend?

a) Mandate that the mobile app team immediately halt development and rebuild the application using enterprise standards, regardless of the delay, because allowing exceptions undermines the entire architecture governance framework  
b) Grant a time-limited dispensation for the current deviations, require the mobile app team to develop a remediation plan to migrate to enterprise standards within an agreed timeframe, and update the compliance review process to catch deviations earlier in the development lifecycle  
c) Accept all deviations permanently as exceptions since the app is already successful with customers, and update the architecture standards to include the mobile team's technology choices as additional approved options  
d) Escalate the issue to the CEO since the aggressive timeline was set by the CEO, making this a business decision rather than an architecture governance decision  

---

## Scenario 4: Defining Architecture Scope

EuroLogistics is a European logistics company that has decided to adopt TOGAF for its enterprise architecture. The company has three major business units: Freight Operations (trucking and rail), Warehousing Services, and Last-Mile Delivery. Each business unit has its own IT systems, but they share a common ERP system and a centralized HR platform.

The CEO wants the architecture team to "fix everything at once" and has requested a single, comprehensive architecture engagement covering all three business units, all four TOGAF architecture domains, and a complete technology refresh—all to be completed within 12 months with a team of four architects.

The lead architect believes this scope is unrealistic and risks delivering nothing useful. However, the CEO is a powerful sponsor who does not like to be told "no." The lead architect needs to propose an alternative approach that manages the scope while maintaining the CEO's support.

### Question 4
What approach should the lead architect propose?

a) Accept the CEO's full scope and attempt to deliver, using an accelerated ADM approach that combines phases and produces lightweight deliverables, since maintaining the sponsor's support is the highest priority  
b) Propose an Architecture Partitioning approach that segments the enterprise architecture into manageable parts—starting with a Strategic Architecture across all business units to establish direction, followed by Segment Architectures for each business unit prioritized by business value, using iterative ADM cycles that deliver incremental results  
c) Propose starting with only the Freight Operations business unit as a pilot, completing the full ADM cycle for that unit before moving to the other business units, explaining to the CEO that a focused approach will yield faster, more tangible results  
d) Hire additional architects and consultants to increase the team to 12 people so the full scope can be addressed, and present the CEO with a budget request for the additional resources needed to meet the 12-month timeline  

---

## Scenario 5: Architecture Compliance Review Decision

Pacific Healthcare Network is a regional healthcare system with 12 hospitals and 45 clinics. The enterprise architecture team conducted a compliance review of a new Electronic Health Records (EHR) integration project and found the following:

- The project uses the approved enterprise service bus (ESB) for integration, which CONFORMS to the integration architecture standard
- The project stores patient data using encryption standards that EXCEED the minimum requirements in the data security architecture
- The project has implemented a custom patient-matching algorithm instead of the enterprise-standard Master Patient Index (MPI), which is NON-CONFORMANT with the data architecture
- The project's user interface follows a completely different design system than the enterprise standard, but the project team argues this was necessary for clinical workflow efficiency

The project is 40% complete and is scheduled for pilot deployment in three months at two hospitals. Patient safety is a critical concern, and the custom patient-matching algorithm has not undergone the same level of testing as the enterprise MPI.

### Question 5
Based on TOGAF's Architecture Compliance framework, what compliance assessment finding should the review team report, and what action should they recommend?

a) Report overall CONFORMANT status because the majority of components conform or exceed standards, and recommend proceeding to pilot deployment with a note about the custom patient-matching algorithm  
b) Report a MIXED compliance finding, recommend that the custom patient-matching algorithm be replaced with the enterprise MPI before any patient-facing deployment due to patient safety risks, grant a time-limited dispensation for the UI design deviation, and require a remediation plan for the UI to align with enterprise standards post-deployment  
c) Report overall NON-CONFORMANT status and recommend halting the entire project until all components fully conform to enterprise standards, as healthcare systems cannot tolerate any deviation from standards  
d) Report overall CONSISTENT status indicating the project is moving toward conformance, and recommend that the project team document their deviations for review after the pilot deployment is complete  

---

## Scenario 6: Migration Planning Challenge

TechManufacture Inc. is a manufacturing company that is migrating from a legacy ERP system (running on-premises for 20 years) to a modern cloud-based ERP. The enterprise architect has completed Phases A through E and has identified three Transition Architectures:

- **TA1:** Migrate Finance and Procurement modules to cloud ERP (6 months)
- **TA2:** Migrate Manufacturing Execution and Supply Chain modules (8 months)
- **TA3:** Migrate HR, CRM, and remaining modules; decommission legacy system (6 months)

During Phase F (Migration Planning), the following complications emerge:
1. The Finance team insists they cannot migrate during the annual audit period (January-March)
2. A key integration partner's API will undergo a breaking change in Month 9
3. The legacy ERP vendor has announced end-of-support effective in 18 months
4. The cloud ERP vendor is releasing a major version upgrade in Month 12 that includes features currently being custom-developed
5. The manufacturing plant cannot have any ERP downtime during its continuous production runs

### Question 6
How should the enterprise architect approach the migration planning given these constraints?

a) Maintain the original three Transition Architectures but adjust the timing to avoid the audit period, completing all migrations before the legacy end-of-support deadline, and accept that some custom development will need to be redone after the vendor upgrade  
b) Re-sequence the Transition Architectures to start with TA2 (Manufacturing) during the audit period when Finance is frozen, align TA1 (Finance) to complete before the next audit period, time TA3 to leverage the vendor's version upgrade to avoid unnecessary custom development, ensure each transition includes a rollback plan for the manufacturing plant, and coordinate the integration partner's API migration with the relevant transition  
c) Compress all three Transition Architectures into a single "big bang" migration to be completed in 12 months, timed to coincide with the vendor's major version upgrade, since this minimizes the total transition period and integration complexity  
d) Extend the migration timeline to 24 months to provide comfortable buffers around all constraints, even though this exceeds the legacy vendor's end-of-support deadline, and negotiate an extended support contract with the legacy vendor  

---

## Scenario 7: Managing Architecture Change Post-Implementation

SmartCity Municipality has completed implementation of its Smart Transportation System, which includes real-time traffic management, connected public transit, and an integrated citizen mobility app. The system has been live for six months and is operating within the defined architecture. The enterprise architect is now in Phase H (Architecture Change Management).

Three change drivers have emerged simultaneously:
1. The national government has passed new legislation requiring all smart city systems to implement a specific cybersecurity framework within 12 months
2. A neighboring municipality wants to connect their transit system, requiring new integration interfaces that were not in the original architecture
3. A major autonomous vehicle company wants to partner with the city to integrate their autonomous shuttle service into the transportation network, requiring significant architectural changes to accommodate vehicle-to-infrastructure (V2I) communication

The Architecture Board must decide how to handle these three change drivers within Phase H.

### Question 7
What should the Architecture Board recommend for managing these three change drivers?

a) Initiate a single, comprehensive new ADM cycle (new Request for Architecture Work) that addresses all three change drivers together, since they all affect the same transportation system and should be architecturally coherent  
b) Classify each change driver by urgency and impact: treat the cybersecurity legislation as a compliance-driven change requiring an immediate targeted ADM cycle, evaluate the neighboring municipality integration as a Segment Architecture update that can be handled through incremental change, and initiate a separate strategic ADM cycle for the autonomous vehicle integration due to its transformational scope and complexity  
c) Address all three changes through Phase H's change management process without initiating new ADM cycles, since the architecture was recently implemented and should be stable enough to accommodate these changes through configuration and extensions  
d) Prioritize only the cybersecurity legislation change since it has a legal deadline, defer the other two changes for at least 12 months to allow the current architecture to stabilize, and revisit the deferred items in the next annual architecture planning cycle  

---

## Scenario 8: Requirements Prioritization Under Constraints

DataDriven Analytics is a fast-growing data analytics startup that has secured Series C funding and is scaling rapidly. The company has hired its first enterprise architect to establish architecture practices. During Phase A, the architect identified 47 architecture requirements from various stakeholders. However, the company has limited resources and must prioritize.

The requirements include:
- **Critical Business:** Real-time analytics pipeline (CEO), Multi-tenant data isolation (Legal/Compliance), Customer-facing API platform (VP Sales)
- **Infrastructure:** Cloud infrastructure standardization (VP Engineering), Disaster recovery and business continuity (CTO), Automated deployment pipeline (DevOps Lead)
- **Security:** SOC 2 Type II compliance (Legal/Board requirement for enterprise customers), Data encryption at rest and in transit (Security Officer)
- **Technical Debt:** Legacy monolith decomposition into microservices (VP Engineering), Database migration from single instance to distributed cluster (DBA)

The board has mandated that SOC 2 compliance must be achieved within 9 months as enterprise customers will not sign contracts without it. The CEO wants the real-time analytics pipeline within 6 months as it is the company's primary differentiator. Resources are limited to a team of 20 engineers.

### Question 8
How should the enterprise architect prioritize and sequence these requirements?

a) Prioritize exclusively based on business revenue impact: real-time analytics pipeline first (CEO priority), then API platform (revenue-generating), then SOC 2 compliance, fitting other requirements around these primary workstreams  
b) Use a risk-based and dependency-driven prioritization: sequence SOC 2 compliance and data security foundational work first (as they enable enterprise revenue and have a hard deadline), architect the real-time analytics pipeline in parallel (leveraging the security foundations), then layer the API platform on the analytics infrastructure, while incorporating cloud standardization and disaster recovery as cross-cutting enablers that support all workstreams  
c) Address all technical debt first by decomposing the monolith and migrating the database, since building new capabilities on unstable foundations will result in rework, and then address business and compliance requirements on the modernized platform  
d) Implement all requirements simultaneously by splitting the 20-engineer team across all workstreams, with each workstream receiving resources proportional to the number of requirements in that category, to ensure balanced progress across all areas  

---

## Answer Key

### Question 1: ADM Phase Selection for a Digital Transformation
**Scoring:**
- **Answer a) = 5 points (Best)** — This is the correct approach. Without an established architecture capability, jumping directly into the ADM cycle will fail. The Preliminary Phase is essential for establishing principles, governance, organizational buy-in, and relationships with stakeholders (especially the skeptical regional IT directors). TOGAF explicitly states that the Preliminary Phase defines the "where, what, why, who, and how we do architecture" in the organization. Skipping this in an organization with no architecture practice is a critical mistake.
- **Answer b) = 3 points (Second)** — Starting with Phase A to demonstrate progress is reasonable, and doing governance in parallel acknowledges the gap. However, without the Preliminary Phase, Phase A risks being undermined by lack of principles, governance, and organizational support. The parallel approach may lead to conflicts and rework.
- **Answer d) = 1 point (Third)** — While showing value through quick wins can build credibility, starting at Phase E without any architecture foundation, vision, or business/technology architecture is a significant departure from the ADM. It addresses a symptom (skepticism) rather than the root cause (no architecture capability).
- **Answer c) = 0 points (Distractor)** — Starting at Phase B skips critical preparatory work. Documenting current business processes without architecture principles, governance, or a vision will produce inventory, not architecture. It also doesn't address the organizational and political challenges.

---

### Question 2: Stakeholder Management During Architecture Development
**Scoring:**
- **Answer b) = 5 points (Best)** — This is the most comprehensive and architecturally sound approach. It uses the Requirements Management process (which TOGAF mandates as continuous), addresses all three stakeholders' concerns with a practical solution (hybrid architecture for regulatory compliance, phased migration for operations), and involves stakeholders jointly to find common ground. It also revisits the Architecture Vision, which TOGAF supports when new information emerges.
- **Answer a) = 3 points (Second)** — Escalating to the Architecture Board is a legitimate governance mechanism, and in some cases necessary. However, it bypasses the architect's responsibility to first attempt resolution. The board may also lack the domain-specific knowledge (FDA regulations, manufacturing operations) to make the best decision. It's a good backup option if the collaborative approach fails.
- **Answer d) = 1 point (Third)** — Commissioning a regulatory study addresses one concern but ignores the other two and introduces delay. While regulatory clarity is valuable, TOGAF encourages architects to work with available information and iterate. This approach is overly cautious and single-threaded.
- **Answer c) = 0 points (Distractor)** — Proceeding with one stakeholder's position while ignoring others violates TOGAF's stakeholder management principles. The CTO does not have unilateral authority over architecture, and ignoring regulatory concerns could have legal consequences. This approach will alienate stakeholders and create implementation risks.

---

### Question 3: Architecture Governance Decision
**Scoring:**
- **Answer b) = 5 points (Best)** — This is the balanced governance approach TOGAF recommends. A time-limited dispensation acknowledges the business reality (70% complete, positive customer feedback) while maintaining governance authority. Requiring a remediation plan preserves architecture integrity. Improving the compliance process addresses the root cause (deviations weren't caught early enough). This demonstrates mature governance that balances control with pragmatism.
- **Answer c) = 3 points (Second)** — Accepting the deviations acknowledges the business value, and updating standards to include new options is reasonable if the mobile team's choices prove architecturally sound. However, permanently accepting all deviations without a remediation path sets a dangerous precedent and undermines governance authority. It should not be done without thorough evaluation.
- **Answer d) = 1 point (Third)** — Escalating to the CEO recognizes the business context (CEO-driven timeline), but it abdicates the Architecture Board's governance responsibility. The board should make its recommendation and then escalate only if needed. Simply passing the decision upward weakens the governance framework.
- **Answer a) = 0 points (Distractor)** — Mandating an immediate halt of a 70%-complete, customer-facing application is disproportionate and ignores business reality. It would damage the credibility of the architecture function, alienate the development team, and cause significant business harm. Governance should be pragmatic, not dogmatic.

---

### Question 4: Defining Architecture Scope
**Scoring:**
- **Answer b) = 5 points (Best)** — Architecture Partitioning is explicitly recommended by TOGAF for managing complex, large-scope architecture efforts. Starting with a Strategic Architecture shows the CEO a holistic approach while Segment Architectures provide manageable execution units. This approach respects the CEO's ambition while being realistic about delivery. Iterative ADM cycles deliver incremental value and build confidence. This maintains sponsor support through visible progress while managing scope effectively.
- **Answer c) = 3 points (Second)** — A pilot approach is pragmatic and reduces risk. Completing a full ADM cycle for one business unit before moving to others is valid and demonstrates value. However, it may not satisfy the CEO's desire for enterprise-wide vision, and it misses the opportunity to identify cross-cutting issues and shared services early. It also leaves two business units waiting with no architecture guidance.
- **Answer a) = 1 point (Third)** — While maintaining sponsor support is important, accepting an unrealistic scope risks delivering superficial or unusable results. Combining phases and producing lightweight deliverables may not yield the architectural rigor needed for a three-business-unit transformation. It's better to manage expectations than to overpromise and underdeliver.
- **Answer d) = 0 points (Distractor)** — Simply requesting more resources doesn't address the fundamental scope management issue. More people don't linearly increase architecture capacity, and the CEO may reject the budget request. This avoids the architect's responsibility to provide professional advice on scope management and is not an architecture solution.

---

### Question 5: Architecture Compliance Review Decision
**Scoring:**
- **Answer b) = 5 points (Best)** — This is the most thorough and risk-aware approach. It correctly differentiates between deviations by severity: the custom patient-matching algorithm is a patient safety issue that must be addressed before deployment, while the UI deviation is lower risk and can be managed through a dispensation. This approach applies TOGAF's compliance framework proportionally and demonstrates mature governance judgment. Patient safety must take priority over project timelines.
- **Answer a) = 3 points (Second)** — Reporting overall CONFORMANT status is incorrect (there are clear non-conformances), but the instinct to allow the project to proceed is understandable given its progress. The recommendation to proceed with just a note about the patient-matching algorithm underestimates the patient safety risk. However, it at least acknowledges the issue.
- **Answer d) = 1 point (Third)** — Reporting CONSISTENT status somewhat acknowledges the mixed picture, but deferring review until after patient-facing deployment is irresponsible given the patient safety implications of an untested patient-matching algorithm. This delays governance action when it's most needed.
- **Answer c) = 0 points (Distractor)** — Halting the entire project is disproportionate. The integration and encryption components are conformant or exceed standards. Treating all deviations equally without risk assessment is a failure of governance judgment. It would also damage the architecture function's credibility and relationship with project teams.

---

### Question 6: Migration Planning Challenge
**Scoring:**
- **Answer b) = 5 points (Best)** — This demonstrates sophisticated migration planning that accounts for all constraints. Re-sequencing Transition Architectures is exactly what Phase F is designed for. Starting manufacturing migration during audit period (when Finance is frozen) is intelligent resource utilization. Timing TA3 to leverage the vendor upgrade avoids wasted custom development. Including rollback plans addresses the manufacturing continuity concern. Coordinating the API partner change with the relevant transition prevents integration failures. This is comprehensive Phase F execution.
- **Answer a) = 3 points (Second)** — Maintaining the original sequence and adjusting timing is a reasonable but suboptimal approach. It addresses the audit constraint and end-of-support deadline but misses the opportunity to optimize around the vendor upgrade, leading to wasted custom development. It also doesn't show the creative re-sequencing that Phase F should produce.
- **Answer d) = 1 point (Third)** — Extending the timeline addresses the comfort level but exceeds the end-of-support deadline, creating a risk period without vendor support. Negotiating extended support may not be possible or may be prohibitively expensive. This approach is overly conservative and doesn't demonstrate effective migration planning.
- **Answer c) = 0 points (Distractor)** — A "big bang" migration of a 20-year-old ERP system is extremely high risk, especially with a continuous manufacturing operation that cannot tolerate downtime. This ignores the fundamental purpose of Transition Architectures, which is to reduce risk through incremental change. The vendor upgrade timing is a single advantage that doesn't offset the catastrophic risk.

---

### Question 7: Managing Architecture Change Post-Implementation
**Scoring:**
- **Answer b) = 5 points (Best)** — This demonstrates mature Phase H change management by classifying each change driver appropriately based on urgency, impact, and scope. The cybersecurity legislation has a hard deadline and compliance implications—it needs an immediate targeted ADM cycle. The neighboring municipality integration is a bounded extension—manageable as a Segment Architecture update. The autonomous vehicle integration is transformational—requiring a separate strategic ADM cycle with its own Architecture Vision. This approach avoids overloading a single ADM cycle while ensuring each change driver gets appropriate attention.
- **Answer a) = 3 points (Second)** — Initiating a single comprehensive ADM cycle ensures architectural coherence, which is valuable. However, combining a compliance deadline-driven change, an incremental integration, and a transformational innovation into one cycle creates scope management challenges and risks delaying the time-sensitive cybersecurity response. Coherence can be maintained through governance without forcing everything into one cycle.
- **Answer d) = 1 point (Third)** — Prioritizing the cybersecurity legislation is correct, but deferring both other changes for 12 months is overly rigid. The neighboring municipality integration may be time-sensitive (mutual benefit), and the autonomous vehicle partnership opportunity could be lost. Phase H should be dynamic and responsive, not arbitrarily deferring changes.
- **Answer c) = 0 points (Distractor)** — Attempting to handle all three changes through Phase H without new ADM cycles severely underestimates the scope of the changes, particularly the autonomous vehicle integration and the cybersecurity framework implementation. Phase H identifies when new ADM cycles are needed—and all three of these changes, to varying degrees, exceed what configuration and extension can handle. The cybersecurity change alone likely requires formal architecture work.

---

### Question 8: Requirements Prioritization Under Constraints
**Scoring:**
- **Answer b) = 5 points (Best)** — This approach applies sound architectural thinking to prioritization: security and compliance foundations (SOC 2, encryption) are prerequisites for enterprise revenue and have a hard deadline, making them logical starting points. Architecting the analytics pipeline in parallel leverages these foundations and meets the CEO's timeline. Layering the API platform on analytics infrastructure shows dependency-aware sequencing. Treating cloud standardization and DR as cross-cutting enablers is architecturally correct—they support rather than compete with the primary workstreams. This is the only answer that balances business urgency, compliance deadlines, technical dependencies, and resource constraints.
- **Answer a) = 3 points (Second)** — Revenue-focused prioritization reflects business reality, and the CEO's analytics pipeline is indeed critical. However, delaying SOC 2 compliance to third priority risks missing the 9-month board mandate, which could prevent enterprise customer acquisition entirely. Prioritizing by revenue impact alone ignores dependencies and compliance deadlines.
- **Answer c) = 1 point (Third)** — Addressing technical debt first is architecturally principled but ignores business and compliance urgency. A monolith decomposition and database migration are multi-month efforts that would consume the team while SOC 2 compliance and the analytics pipeline fall behind schedule. In a startup context, this approach could run out the clock before delivering business value.
- **Answer d) = 0 points (Distractor)** — Splitting 20 engineers across all workstreams simultaneously guarantees that nothing is completed on time. This ignores prioritization entirely—the antithesis of what the architect was asked to do. With limited resources, focus and sequencing are essential. Spreading thin leads to context-switching overhead and delays across the board.

---

## Score Card

| Question | Your Answer | Points Earned |
|----------|-------------|---------------|
| Q1 - ADM Phase Selection | ___ | ___ / 5 |
| Q2 - Stakeholder Management | ___ | ___ / 5 |
| Q3 - Governance Decision | ___ | ___ / 5 |
| Q4 - Architecture Scope | ___ | ___ / 5 |
| Q5 - Compliance Review | ___ | ___ / 5 |
| Q6 - Migration Planning | ___ | ___ / 5 |
| Q7 - Change Management | ___ | ___ / 5 |
| Q8 - Requirements Prioritization | ___ | ___ / 5 |
| **Total** | | **___ / 40** |

| Result | Score |
|--------|-------|
| Total Points | ___ / 40 |
| Percentage | ___ % |
| **Pass Mark** | **60% (24/40)** |
| Result | PASS / FAIL |

### Scoring Guide
| Points | Grade | Meaning |
|--------|-------|---------|
| 5 | Best | You selected the optimal TOGAF-aligned answer |
| 3 | Second | You selected a reasonable but suboptimal answer |
| 1 | Third | You selected a marginally acceptable answer |
| 0 | Distractor | You selected the incorrect/worst answer |

### Performance by Scenario Topic

| Topic | Question | Points |
|-------|----------|--------|
| ADM Phase Selection | Q1 | ___ / 5 |
| Stakeholder Management | Q2 | ___ / 5 |
| Architecture Governance | Q3 | ___ / 5 |
| Architecture Scope Definition | Q4 | ___ / 5 |
| Compliance Review Decision | Q5 | ___ / 5 |
| Migration Planning | Q6 | ___ / 5 |
| Change Management | Q7 | ___ / 5 |
| Requirements Prioritization | Q8 | ___ / 5 |
