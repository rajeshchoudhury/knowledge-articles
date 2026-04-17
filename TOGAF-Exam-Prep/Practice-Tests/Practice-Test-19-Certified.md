# TOGAF Part 2 Certified - Practice Test 19
**Time Allowed:** 90 minutes | **Questions:** 8 | **Pass Mark:** 60% (24/40)

---

## Scenario 1: Government EA Program at the Department of National Services

The Department of National Services (DNS) is a large federal government agency responsible for delivering citizen services across social security, immigration, tax administration, and public health. The department employs 45,000 civil servants across 120 regional offices and serves 80 million citizens. The Secretary of the department has mandated the establishment of an Enterprise Architecture program to support a government-wide digital transformation initiative called "Citizen First 2030," which aims to provide seamless, integrated digital services to citizens regardless of which government function they interact with.

Currently, each of the four divisions (social security, immigration, tax, public health) operates its own IT systems with minimal integration. Citizens must interact separately with each division, often providing the same information multiple times. There are 480 applications in the department's portfolio, many developed decades ago using legacy technologies including COBOL mainframes, Oracle Forms, and early Java web applications. The department's annual IT budget is $1.8 billion, of which 78% is spent on maintaining existing systems, leaving only 22% for new development.

The Chief Architect has been appointed from the private sector and faces unique government challenges: procurement regulations require lengthy competitive bidding processes for technology acquisitions; the IT workforce is unionized with limited flexibility in hiring, reassignment, or skill development; political leadership changes every four to eight years, potentially shifting strategic priorities; and each division has its own CIO who reports to a different political appointee, creating a complex governance landscape with no single authority over IT strategy.

### Question 1
What should the Chief Architect prioritize during the Preliminary Phase to establish the EA program in this government context?

a) Develop a comprehensive federal enterprise architecture framework from scratch that addresses all government-specific constraints, spending the first 18 months on framework development before engaging with any divisions

b) Tailor the TOGAF framework to the government context during the Preliminary Phase — establish an Architecture Governance structure that works within the existing political and organizational hierarchy (including a cross-divisional Architecture Board with representation from each division's CIO), define Architecture Principles that reflect both government mandates (transparency, equity, accessibility, security) and Citizen First 2030 objectives, create a Tailored Architecture Framework that accounts for procurement constraints and workforce limitations, and secure a formal mandate (Statement of Architecture Work) signed by the Secretary to provide the authority needed to operate across divisional boundaries

c) Focus exclusively on the tax administration division as a pilot, as it has the largest IT budget and the most modernization potential, deferring the cross-divisional integration challenges until the pilot is complete

d) Adopt the Federal Enterprise Architecture Framework (FEAF) as-is without any TOGAF integration, as government agencies should use government-specific frameworks rather than private-sector frameworks

---

## Scenario 2: Multi-Department Architecture Governance at Regional Health Authority

The Regional Health Authority (RHA) oversees healthcare delivery for a region of 6 million people through five semi-autonomous health districts. Each district manages its own hospitals, primary care clinics, and community health services. The RHA has been directed by the Minister of Health to implement a unified architecture governance framework to ensure that technology investments across all five districts are coordinated and that clinical data can flow seamlessly between districts to support continuity of care.

However, each district has its own IT budget controlled by a District Health Director, its own technology teams, and a strong culture of operational independence. Two districts have invested heavily in modern EHR systems, two use older clinical systems, and one district is still primarily paper-based. The total annual IT spend across all five districts is $250 million, but there is no centralized oversight of how this budget is allocated.

The Chief Architect appointed by the RHA has attempted to establish a centralized Architecture Review Board, but the District Health Directors have resisted, viewing it as an infringement on their operational autonomy. The two districts with modern EHR systems argue that centralized governance would slow down their innovation, while the less mature districts see it as an unwelcome burden on their already-stretched resources. The Minister's mandate gives the RHA authority to set standards but does not explicitly grant the power to veto district-level technology decisions.

### Question 2
How should the Chief Architect establish effective architecture governance across the five health districts given the organizational constraints?

a) Use the Minister's mandate to establish a strong centralized governance model with full veto power over all district technology decisions, overriding the districts' operational autonomy to ensure compliance

b) Design a federated governance model aligned with TOGAF's Architecture Governance framework that distinguishes between three tiers of architecture decisions: RHA-level decisions (interoperability standards, shared data standards, security requirements, common patient identity) that are mandatory and governed by a cross-district Architecture Board; district-level decisions (local system selection, implementation approaches, internal workflows) that remain under district autonomy; and shared investment decisions (joint procurement, shared platforms) that are governed collaboratively — establish the Architecture Board with representatives from each district who have both the authority to commit their districts and the clinical knowledge to ensure decisions support care delivery

c) Allow each district to continue governing its own technology decisions independently and focus only on building point-to-point data interfaces between districts when specific data sharing needs arise

d) Mandate that all five districts adopt the same EHR system used by the two most advanced districts, as technology standardization is the only way to achieve interoperability and centralized governance

---

## Scenario 3: Reference Architecture Creation at National Digital Agency

The National Digital Agency (NDA) is a government body established to accelerate digital transformation across all federal agencies. The NDA has been tasked with creating a reference architecture for digital government services that all 28 federal agencies can adopt when building citizen-facing digital services. Currently, each agency builds its own digital services independently, resulting in inconsistent citizen experiences, duplicated capabilities (28 separate identity verification systems, 22 separate notification systems, 19 separate payment processing systems), and no interoperability between agency services.

The NDA has assembled a reference architecture team of 10 architects drawn from different agencies. The team must produce a reference architecture that is comprehensive enough to drive consistency and reuse, yet flexible enough to accommodate the diverse needs of agencies ranging from the tax authority to the national parks service. The reference architecture must address common capabilities (citizen identity, authentication, notifications, payments, document management, case management), integration patterns, data standards, security requirements, and accessibility standards.

A critical tension has emerged: some agency representatives want a highly prescriptive reference architecture with mandatory standards and specific technology choices, arguing that only strict prescription will drive adoption. Others want a loose guidelines document that agencies can interpret freely, arguing that agencies' needs are too diverse for a one-size-fits-all approach.

### Question 3
How should the team structure the reference architecture to balance prescription with flexibility?

a) Create a highly prescriptive reference architecture that specifies exact technologies, vendors, and implementation patterns for every capability, leaving no room for agency-level interpretation

b) Structure the reference architecture using TOGAF's Building Block concepts at two levels: define Architecture Building Blocks (ABBs) that specify the required capabilities, interfaces, and standards at an abstract level (e.g., "Citizen Identity Service" with defined API specifications, data standards, and security requirements), then provide Solution Building Blocks (SBBs) as reference implementations that agencies can adopt or use as templates when building their own implementations — make ABBs and their interfaces mandatory to ensure interoperability, while allowing agencies flexibility in their SBB implementations as long as they conform to the ABB specifications, and publish the reference architecture in the Architecture Repository with a governance process for evolving it based on agency feedback

c) Produce a high-level principles document with general guidance and no specific technical requirements, allowing each agency to interpret and implement the principles as they see fit

d) Select one agency's existing digital services platform as the standard and mandate that all 27 other agencies migrate to it, as reuse of an existing platform is more efficient than creating a new reference architecture

---

## Scenario 4: Architecture Repository Setup at Metropolitan Transit Authority

The Metropolitan Transit Authority (MTA) operates the public transit system for a major city, including buses, subway, commuter rail, and ferry services. The MTA has recently established an enterprise architecture practice and the Chief Architect is setting up the Architecture Repository. The MTA operates 230 applications supporting fare collection, vehicle tracking, maintenance management, scheduling, customer information, safety systems, and corporate functions.

The Chief Architect faces several challenges in establishing the repository: there is no existing documentation for most applications (only 40 of 230 applications have any architecture documentation); the architecture team consists of only three architects who must balance repository population with ongoing architecture development work; different stakeholder groups need different views of the architecture (the Board needs strategic portfolio views, the operations team needs integration maps, the maintenance team needs technology lifecycle information, and the security team needs data flow diagrams); and there is no EA tool in place (the CTO has deferred the tool acquisition decision pending budget approval in six months).

The CTO has asked the Chief Architect to have a "usable" Architecture Repository within 90 days that demonstrates value to stakeholders. The Chief Architect must decide what to include in the initial repository, how to structure it, and how to populate it efficiently with limited resources.

### Question 4
What approach should the Chief Architect take to establish the Architecture Repository within the 90-day timeline?

a) Wait for the EA tool acquisition in six months before beginning any repository work, as an Architecture Repository without a proper tool will be inefficient and will need to be reworked when the tool arrives

b) Establish the Architecture Repository using TOGAF's Architecture Repository structure with a pragmatic, incremental approach: start with the Architecture Landscape (focusing on the most critical 50 applications supporting core transit operations), the Standards Information Base (documenting current technology standards and lifecycle status), and a Governance Log — use available tools (enterprise wiki, spreadsheets, diagramming tools) as interim platforms, prioritize populating the repository with content that serves the highest-priority stakeholder needs (strategic portfolio view for the Board, integration maps for operations), leverage automated discovery tools where possible to accelerate application inventory, and design the repository structure to be tool-agnostic so content can be migrated to the EA tool when acquired

c) Assign all three architects to a 90-day sprint focused exclusively on documenting all 230 applications in detail, suspending all other architecture work until the repository is fully populated

d) Purchase the most expensive EA tool on the market immediately without waiting for budget approval and populate it with a complete metamodel covering every TOGAF artifact type, even those not immediately needed

---

## Scenario 5: Interoperability Challenges at the Federal Emergency Management Consortium

The Federal Emergency Management Consortium (FEMC) coordinates disaster response across 12 federal agencies, 50 state-level emergency management offices, and 300 county-level first responder organizations. During a recent major disaster response, critical failures in interoperability were exposed: agencies could not share real-time situation data because their systems used incompatible data formats; resource allocation requests had to be processed manually because there was no common system for resource management; and communications between federal and state agencies relied on phone calls and emails because their incident management systems could not exchange data electronically.

A post-disaster review recommended establishing a shared interoperability architecture. The FEMC Chief Architect has been appointed to lead this effort. The challenge is enormous: the 362 organizations use hundreds of different systems, have different levels of IT maturity (from sophisticated federal agencies to volunteer county organizations with minimal IT capability), operate under different governance authorities, and have severely limited budgets. Additionally, any solution must work reliably during disasters when network connectivity may be degraded and systems may be under extreme load.

The FEMC has no authority to mandate technology choices for the individual organizations, and any solution must be achievable without requiring organizations to replace their existing systems. The architecture must enable interoperability through standards and integration patterns rather than technology standardization.

### Question 5
What architectural approach should the Chief Architect recommend to achieve interoperability across the consortium?

a) Develop a single centralized disaster management platform that all 362 organizations must adopt, replacing their existing systems with a common solution funded by the federal government

b) Develop an interoperability reference architecture focused on standards-based integration: define common data exchange standards using established emergency management standards (e.g., NIEM, CAP, EDXL) as Architecture Building Blocks, specify standard integration patterns (publish-subscribe for real-time situation data, request-response for resource management) through a federated integration architecture, design for degraded-mode operation (offline-capable, store-and-forward messaging for unreliable networks), implement the architecture in tiers based on organizational capability (full integration for sophisticated organizations, simplified gateway adapters for less capable organizations), and establish a governance framework with FEMC-level standards that organizations can adopt progressively — using TOGAF's Architecture Partitioning to separate the interoperability architecture (FEMC-governed) from each organization's internal architecture (self-governed)

c) Establish a phone-based coordination center with trained operators who manually relay information between organizations, as technology-based interoperability is too complex for this many diverse organizations

d) Focus interoperability efforts only on the 12 federal agencies since they have the most resources, and exclude state and county organizations from the interoperability architecture

---

## Scenario 6: Migration Planning with Budget Constraints at the City Education Department

The City Education Department manages public education for 350 schools serving 500,000 students. The department's IT systems include a 20-year-old student information system (SIS), a separate human resources system for 35,000 staff, a facilities management system, a transportation routing system for 2,000 school buses, a curriculum management platform, and various department-specific applications totaling 85 systems. Most systems are on-premises, running on aging infrastructure with increasing maintenance costs and reliability issues.

The department has a total IT budget of $45 million annually, of which $38 million is consumed by operations and maintenance of existing systems. The remaining $7 million for new initiatives is grossly insufficient for the comprehensive modernization needed. The Superintendent has asked the Chief Architect to develop a migration plan that modernizes the most critical systems within these budget constraints. A complication is that the department cannot obtain additional funding without demonstrating improved educational outcomes from technology investments, creating a chicken-and-egg problem.

The architecture team has completed Phases A through D and has a clear Target Architecture. The challenge is now in Phase E (Opportunities and Solutions) and Phase F (Migration Planning): how to sequence the migration to deliver maximum value within severe budget constraints, ideally generating cost savings from early phases that can fund subsequent migration phases.

### Question 6
What migration planning approach should the Chief Architect recommend during Phase E and Phase F?

a) Request a complete budget increase to fund the full modernization at once, and delay all migration work until the additional funding is approved by the city government

b) Develop a self-funding migration plan using TOGAF's Phase E and Phase F guidance: identify quick-win migrations that reduce operational costs (e.g., migrating low-risk applications to cloud to reduce infrastructure costs, consolidating redundant systems), use the projected cost savings from early migrations to fund subsequent phases, sequence the migration using the Implementation Factor Assessment and Deduction Matrix to prioritize based on business value, implementation risk, cost, and dependencies, define Transition Architectures that represent stable intermediate states at the end of each funded phase, establish measurable outcomes for each phase that demonstrate educational impact (enabling the department to make the case for additional funding), and create an Architecture Roadmap that shows the complete migration path while clearly marking funded versus unfunded phases

c) Modernize only the student information system since it directly impacts educational outcomes, and defer all other modernization indefinitely until more budget becomes available

d) Outsource all IT operations to a managed service provider to reduce costs, using the savings to fund modernization, without conducting any architecture analysis of which systems to migrate first

---

## Scenario 7: Stakeholder Management in Political Environments at the State Revenue Department

The State Revenue Department is implementing a new tax administration system to replace a 25-year-old mainframe system. The project has been approved with a $180 million budget and a four-year timeline. The Chief Architect is leading the architecture development using the ADM. The project has strong support from the Governor and the Revenue Commissioner, but the political landscape is complex and volatile.

Several stakeholder challenges have emerged during Phase A and Phase B: the state legislature's IT oversight committee has publicly questioned the cost and timeline, comparing it unfavorably to smaller-scale tax system replacements in neighboring states; the state employees' union opposes the project because it is expected to automate functions currently performed by 500 tax processing staff; a powerful lobbyist representing the incumbent mainframe vendor is advocating against the replacement, claiming modernization of the existing system would be cheaper and less risky; local media has published critical articles about cost overruns in previous state IT projects, creating public skepticism; and the upcoming election cycle means the Governor (the project's primary sponsor) may not be in office beyond the next two years.

The Chief Architect recognizes that the project's success depends as much on stakeholder management as on technical architecture. The architecture work itself is progressing well, but the political environment threatens to undermine or cancel the project regardless of its technical merit.

### Question 7
How should the Chief Architect address the stakeholder management challenges to protect the project?

a) Focus exclusively on the technical architecture and ignore the political dynamics, as stakeholder management is the responsibility of the project manager and political leadership, not the architecture team

b) Develop a comprehensive stakeholder management strategy as part of the Architecture Vision (Phase A): conduct a formal stakeholder analysis using TOGAF's stakeholder management techniques to map all stakeholders by their power, influence, and position (support/opposition/neutral), develop tailored communication approaches for each stakeholder group — provide the legislative committee with transparent cost-benefit analysis and benchmarking data, work with the project sponsor to develop a workforce transition plan that addresses union concerns, prepare technical rebuttals to the incumbent vendor's claims with architecture evidence, and structure the Architecture Roadmap and Implementation Plan with clear milestones that deliver visible value within the first two years (before the election cycle risk), using Transition Architectures to ensure each phase delivers independently valuable outcomes that build momentum and political support

c) Recommend that the Revenue Commissioner publicly confront and discredit all opposition stakeholders (the union, the lobbyist, the critical media) to eliminate resistance to the project

d) Redesign the entire project as a series of small, low-visibility enhancements to the existing mainframe system to avoid political attention, abandoning the strategic vision of full replacement

---

## Scenario 8: Architecture Principles Development at Federal Logistics Agency

The Federal Logistics Agency (FLA) is responsible for managing the supply chain and logistics operations for all federal government agencies, handling $50 billion in annual procurement and distribution of everything from office supplies to military equipment. The Chief Architect has been tasked with developing a set of Architecture Principles to guide the agency's IT investment decisions and technology architecture. The agency currently has no formal architecture principles, and technology decisions are made on a project-by-project basis with no overarching guidance.

Several stakeholder groups have provided input on what the principles should address: the procurement division wants principles that maximize vendor competition and minimize vendor lock-in; the operations division wants principles that prioritize system reliability and uptime (99.99% availability) above all else; the cybersecurity team wants principles that enforce zero-trust security and data classification; the modernization team wants principles that mandate cloud-first adoption and API-based integration; the budget office wants principles that require total cost of ownership analysis for all technology investments; and the field logistics teams want principles that ensure systems work in disconnected/low-bandwidth environments common in remote deployment locations.

The Chief Architect has collected 47 proposed principles from various stakeholders. Many are contradictory (e.g., "cloud-first" conflicts with "disconnected operation support"), overly specific (describing implementation requirements rather than principles), or reflect narrow departmental interests rather than agency-wide guidance. The principles need to be refined into a coherent, manageable set that provides clear direction without being so prescriptive that they constrain appropriate technology decisions.

### Question 8
How should the Chief Architect develop and refine the Architecture Principles?

a) Accept all 47 proposed principles as submitted and publish them as the official architecture principles, as rejecting any stakeholder's input could create political problems

b) Apply TOGAF's Architecture Principles development guidance to refine the 47 proposals into a coherent set of 10-15 principles: validate each proposed principle against TOGAF's five criteria for good principles (understandable, robust, complete, consistent, stable), consolidate overlapping principles, resolve contradictions by identifying the higher-order principle (e.g., resolving "cloud-first" versus "disconnected operation" through a principle like "Design for operational resilience across all deployment contexts, leveraging cloud services where connectivity permits and ensuring offline capability where it does not"), separate true principles from requirements (moving implementation-level statements to the Architecture Requirements Specification), structure each principle with the TOGAF-recommended format (name, statement, rationale, implications), and validate the final set with all stakeholder groups to ensure their core concerns are represented even if their specific wording has been refined

c) Ignore all stakeholder input and have the architecture team develop the principles independently based on industry best practices, as stakeholders lack the technical knowledge to define architecture principles

d) Adopt a publicly available set of architecture principles from another government agency without modification, as government agencies face similar challenges and developing custom principles is unnecessary

---

## Answer Key

### Scenario 1 - Question 1
**Scoring:**
- **Answer b) = 5 points (Best):** This approach correctly applies the Preliminary Phase's purpose while tailoring it to the government context. TOGAF's Preliminary Phase explicitly covers establishing the organizational model for EA, defining Architecture Principles, and creating a Tailored Architecture Framework. Adapting these to government constraints (procurement, workforce, political governance) demonstrates proper use of TOGAF's tailoring guidance. Securing a formal mandate from the Secretary addresses the authority challenge across divisions. Cross-divisional Architecture Board representation addresses the complex governance landscape. Government-specific principles (transparency, equity, accessibility) ensure the principles are contextually relevant.
- **Answer c) = 3 points (Second Best):** A divisional pilot is a pragmatic approach that reduces scope and complexity. Starting with tax administration (largest budget, most modernization potential) is a reasonable prioritization. However, this approach defers the cross-divisional integration that is the core objective of Citizen First 2030, and a single-division pilot does not establish the enterprise-wide governance authority needed. It addresses feasibility but not the strategic mandate.
- **Answer d) = 1 point (Third Best):** Using FEAF recognizes the existence of government-specific architecture frameworks. However, TOGAF and FEAF are not mutually exclusive — TOGAF provides the methodology (ADM) while FEAF provides government-specific reference models. Adopting FEAF without TOGAF integration loses the structured ADM methodology, governance framework, and enterprise architecture development process that TOGAF provides.
- **Answer a) = 0 points (Distractor):** Spending 18 months developing a framework before engaging with divisions is an ivory-tower approach that would exhaust the political capital needed to sustain the EA program. In a government context where political leadership changes, 18 months of framework development with no visible output would likely result in the program being defunded or deprioritized.

### Scenario 2 - Question 2
**Scoring:**
- **Answer b) = 5 points (Best):** A federated governance model directly applies TOGAF's Architecture Governance framework to a multi-organization context. The three-tier decision model (mandatory RHA standards, autonomous district decisions, collaborative shared investments) is a sophisticated governance design that respects the political reality of district autonomy while ensuring interoperability for patient care. The Architecture Board composition (authority to commit, clinical knowledge) ensures decisions are both implementable and clinically appropriate. This approach works within the Minister's mandate (authority to set standards, not veto decisions) and addresses both the advanced districts' innovation concerns and the less mature districts' resource constraints.
- **Answer d) = 3 points (Second Best):** Standardizing on the EHR system used by the most advanced districts would address interoperability through technology standardization. However, mandating a specific system for the three non-compliant districts (especially the paper-based one) would face enormous resistance, requires significant unfunded investment, and may not be the best clinical or financial decision for those districts. It addresses the technical problem but ignores the organizational and political constraints.
- **Answer c) = 1 point (Third Best):** Allowing districts to continue independently and building point-to-point interfaces is a pragmatic, low-friction approach. However, ad hoc point-to-point integration does not scale to five districts with multiple systems each, does not establish consistent standards, and does not address the Minister's mandate for coordinated technology investments. It solves specific sharing needs but creates integration spaghetti.
- **Answer a) = 0 points (Distractor):** The Minister's mandate explicitly does not grant veto power over district decisions. Attempting to establish centralized veto authority would exceed the Chief Architect's mandate, provoke a governance crisis, and likely result in the architecture program being rejected by the districts. Effective governance in a federated context must work through influence and shared standards, not centralized control.

### Scenario 3 - Question 3
**Scoring:**
- **Answer b) = 5 points (Best):** This approach correctly applies TOGAF's Building Block concepts at two levels of abstraction. Architecture Building Blocks (ABBs) define capabilities, interfaces, and standards at an abstract level that ensures interoperability, while Solution Building Blocks (SBBs) provide reference implementations that agencies can adopt or adapt. This directly resolves the prescription-vs-flexibility tension: ABBs are mandatory (ensuring consistency), while SBB implementations are flexible (accommodating diversity). Publishing in the Architecture Repository with a governance process for evolution ensures the reference architecture remains relevant. This is a textbook application of TOGAF's building block approach.
- **Answer c) = 3 points (Second Best):** A principles-based approach provides flexibility and avoids the resistance that prescriptive standards might generate. However, high-level principles without specific technical requirements will not drive the interoperability and reuse that the NDA is tasked with achieving. Agencies will interpret principles differently, and the 28 separate identity verification systems will continue to proliferate.
- **Answer d) = 1 point (Third Best):** Reusing an existing platform is efficient in principle. However, selecting one agency's platform as the standard may not meet other agencies' diverse needs, creates dependency on that agency, and generates political resistance from the 27 agencies that must adopt someone else's solution.
- **Answer a) = 0 points (Distractor):** Specifying exact technologies and vendors in a government reference architecture would likely violate procurement regulations (which typically require competitive bidding), would become outdated quickly as technology evolves, and would stifle innovation. This level of prescription would also face enormous resistance from agencies with different technology environments and needs.

### Scenario 4 - Question 4
**Scoring:**
- **Answer b) = 5 points (Best):** This approach applies TOGAF's Architecture Repository structure pragmatically within real-world constraints. Focusing on the most critical 50 applications (rather than all 230) prioritizes value over completeness. Addressing the highest-priority stakeholder needs (Board portfolio view, operations integration maps) ensures the repository demonstrates value within 90 days. Using available tools as interim platforms is pragmatic and avoids the analysis paralysis of waiting for the perfect tool. Designing the repository structure to be tool-agnostic ensures content can be migrated later. This approach aligns with TOGAF's guidance that the Architecture Repository should contain the Architecture Landscape, Standards Information Base, Reference Library, and Governance Log.
- **Answer c) = 3 points (Second Best):** Dedicating all resources to comprehensive documentation would make progress on repository population. However, suspending all other architecture work for 90 days means no architecture guidance for ongoing projects, and attempting to document all 230 applications in 90 days with three architects (averaging one application per day each) would produce superficial documentation of limited value.
- **Answer a) = 1 point (Third Best):** Waiting for the EA tool is prudent from a technology perspective — having a proper tool would be more efficient. However, a six-month delay before beginning any repository work means missing the 90-day deadline, providing no interim value to stakeholders, and potentially losing organizational support for the EA practice.
- **Answer d) = 0 points (Distractor):** Purchasing an expensive tool without budget approval is a governance violation that would undermine the Chief Architect's credibility. Populating every TOGAF artifact type regardless of immediate need creates unnecessary work and delays value delivery. This approach prioritizes tooling and completeness over pragmatic value delivery.

### Scenario 5 - Question 5
**Scoring:**
- **Answer b) = 5 points (Best):** This approach correctly applies TOGAF's Architecture Partitioning to separate the interoperability architecture (governed by FEMC) from each organization's internal architecture (self-governed). Using established emergency management standards (NIEM, CAP, EDXL) as Architecture Building Blocks leverages proven industry standards rather than inventing new ones. The federated integration architecture with standard patterns (publish-subscribe, request-response) provides clear technical guidance. Designing for degraded-mode operation addresses the critical disaster-scenario constraint. Tiered implementation based on organizational capability ensures the architecture is achievable for all 362 organizations, from sophisticated federal agencies to volunteer county teams.
- **Answer d) = 3 points (Second Best):** Focusing on the 12 federal agencies reduces scope and complexity, making the effort more manageable. Federal agencies have the resources and maturity to implement interoperability. However, disaster response fundamentally requires coordination between federal, state, and county levels — excluding state and county organizations from the interoperability architecture undermines the core purpose. This could be a valid first phase but should not be the entire scope.
- **Answer c) = 1 point (Third Best):** A phone-based coordination center provides a low-tech backup capability that works when systems fail. However, as the primary solution, it does not scale to major disaster response involving hundreds of organizations, introduces human error in information relay, and does not address the real-time data sharing needs identified in the post-disaster review.
- **Answer a) = 0 points (Distractor):** A single centralized platform for 362 independent organizations is politically, financially, and logistically infeasible. FEMC has no authority to mandate platform adoption, many organizations cannot afford new systems, and a centralized platform creates a single point of failure that is unacceptable for disaster response operations.

### Scenario 6 - Question 6
**Scoring:**
- **Answer b) = 5 points (Best):** This approach directly applies TOGAF Phase E and Phase F concepts. The self-funding model (using cost savings from early migrations to fund subsequent phases) is a pragmatic solution to the budget constraint. The Implementation Factor Assessment and Deduction Matrix from Phase E is the correct TOGAF technique for prioritizing migration work packages. Transition Architectures define stable intermediate states that deliver value at each phase. Establishing measurable educational outcomes enables the department to justify additional funding. The Architecture Roadmap showing funded versus unfunded phases provides transparency and a basis for future budget requests. This approach turns the budget constraint into a sequencing discipline rather than a blocking issue.
- **Answer c) = 3 points (Second Best):** Prioritizing the student information system is a reasonable choice given its direct educational impact. However, this approach leaves 84 other systems without a migration strategy, does not generate the cost savings needed to fund additional modernization, and does not present a comprehensive roadmap that demonstrates architectural thinking.
- **Answer d) = 1 point (Third Best):** Outsourcing IT operations could reduce costs and free budget for modernization. However, outsourcing without architecture analysis risks perpetuating the current fragmented landscape under a different operational model. The cost savings may also not materialize as expected without understanding system dependencies and rationalization opportunities.
- **Answer a) = 0 points (Distractor):** Requesting a complete budget increase and delaying all work until approved is unrealistic in a government context where budget cycles are annual and competing priorities are intense. This approach provides no interim value and no demonstration of what migration could achieve, making it harder to justify the budget increase request.

### Scenario 7 - Question 7
**Scoring:**
- **Answer b) = 5 points (Best):** This approach correctly applies TOGAF's stakeholder management techniques, which are a core part of Phase A (Architecture Vision). Formal stakeholder analysis using power/influence/position mapping provides a structured basis for developing tailored engagement strategies. Addressing each stakeholder group with appropriate communication (cost-benefit for the legislature, workforce transition for the union, technical evidence against vendor claims, media-friendly milestones) demonstrates comprehensive stakeholder management. Structuring the roadmap to deliver value within two years directly addresses the political risk of the election cycle. Transition Architectures that deliver independently valuable outcomes ensure the project remains viable even if political priorities shift.
- **Answer d) = 3 points (Second Best):** Redesigning the project as incremental enhancements reduces political visibility and opposition. This approach pragmatically addresses the political risks. However, it abandons the strategic vision of full replacement, which means the fundamental problems of the 25-year-old mainframe (inflexibility, maintenance costs, skills shortage) are not addressed. It is a politically expedient but architecturally suboptimal approach.
- **Answer a) = 1 point (Third Best):** Focusing on technical architecture while leaving stakeholder management to others is a common architect behavior but a significant risk in politically complex environments. The scenario explicitly states that success depends on stakeholder management. TOGAF's Phase A includes stakeholder management as a core activity, not an optional extra. However, this answer correctly identifies that the technical architecture should progress.
- **Answer c) = 0 points (Distractor):** Publicly confronting opposition stakeholders would escalate political conflict, generate negative media coverage, and potentially unite opposition groups against the project. Effective stakeholder management in political environments requires engagement and communication, not confrontation.

### Scenario 8 - Question 8
**Scoring:**
- **Answer b) = 5 points (Best):** This approach directly applies TOGAF's Architecture Principles development guidance. TOGAF defines five quality criteria for good principles (understandable, robust, complete, consistent, stable) and provides a recommended structure (name, statement, rationale, implications). The process of refining 47 proposals into 10-15 principles demonstrates proper architectural judgment — consolidating overlapping principles, resolving contradictions through higher-order principles, and separating principles from requirements. The example of resolving "cloud-first" versus "disconnected operation" through a higher-order resilience principle demonstrates sophisticated principle crafting. Validating with stakeholders ensures buy-in while maintaining architectural integrity.
- **Answer d) = 3 points (Second Best):** Adopting principles from another government agency provides a quick starting point and leverages proven work. However, principles should reflect the specific organization's context, priorities, and constraints. The FLA's unique requirements (e.g., disconnected field operations, $50 billion procurement scale) may not be reflected in another agency's principles. This approach saves time but may miss critical organizational-specific guidance.
- **Answer c) = 1 point (Third Best):** Having the architecture team develop principles based on industry best practices produces technically sound principles. However, ignoring stakeholder input in a government context with multiple powerful stakeholder groups will result in principles that lack organizational buy-in and are unlikely to be adopted. TOGAF emphasizes that principles should be developed collaboratively with stakeholders.
- **Answer a) = 0 points (Distractor):** Publishing all 47 principles without refinement creates an unmanageable, contradictory set that provides no clear guidance. Contradictory principles (cloud-first vs. disconnected operation) would paralyze decision-making. TOGAF's guidance explicitly addresses the need for principles to be consistent and manageable in number.

---

### Score Card
| Scenario | Your Answer | Points (0/1/3/5) |
|----------|-------------|-------------------|
| 1 | | |
| 2 | | |
| 3 | | |
| 4 | | |
| 5 | | |
| 6 | | |
| 7 | | |
| 8 | | |
| **Total** | | **/40** |
| **Pass** | | **24/40 (60%)** |
