# TOGAF Part 2 Certified - Practice Test 17
**Time Allowed:** 90 minutes | **Questions:** 8 | **Pass Mark:** 60% (24/40)

---

## Scenario 1: EA Program Launch at Fortuna Financial Services

Fortuna Financial Services is a regional banking group with $85 billion in assets under management, operating across retail banking, wealth management, commercial lending, and insurance. The organization employs 12,000 people and operates from 180 branch locations. The Group CEO has mandated the establishment of a formal Enterprise Architecture program after a failed $40 million core banking replacement project — a failure largely attributed to the absence of architectural oversight and poor integration planning.

The CIO has been tasked with setting up the EA program and has hired a Chief Architect with extensive TOGAF experience. The existing IT landscape consists of approximately 250 applications, many of which are legacy systems acquired through mergers over the past 15 years. There is no Architecture Repository, no documented architecture principles, and no formal governance structure. The IT department is organized around technology silos (infrastructure, applications, database, security), with limited alignment to business functions.

The Board has approved a modest initial budget of $2 million for the EA program's first year, with the expectation that the program will demonstrate tangible value within 12 months. The business side is wary of the EA initiative, having experienced "ivory tower" architecture efforts at previous employers. Several senior business executives have expressed the view that architecture is an IT concern that should not involve their teams. The Chief Architect recognizes that the Preliminary Phase work will be critical to the program's long-term success.

### Question 1
What should the Chief Architect prioritize during the Preliminary Phase to establish a successful EA program at Fortuna?

a) Develop a comprehensive, 100-page Architecture Framework document that defines all standards, principles, reference models, and governance procedures before engaging with any stakeholders or beginning any architecture development work

b) Focus the Preliminary Phase on three key deliverables: establishing the organizational model for EA (including defining the architecture team's scope, roles, and reporting structure), defining a foundational set of Architecture Principles developed collaboratively with business stakeholders to demonstrate EA's relevance beyond IT, and establishing an initial tailored Architecture Framework that is fit-for-purpose given the organization's maturity level — delivering these within a 90-day timeframe to build momentum

c) Skip the Preliminary Phase entirely and jump directly to Phase A (Architecture Vision) for the highest-priority business initiative, as the Preliminary Phase is optional in TOGAF and the Board expects tangible value within 12 months

d) Use the entire first-year budget to purchase and deploy a comprehensive EA toolset and populate it with a detailed inventory of all 250 applications before beginning any architecture development work

---

## Scenario 2: Regulatory Compliance Architecture at SecureBank

SecureBank is a mid-tier commercial bank operating in the European Union that has been struggling with regulatory compliance. The bank has received warnings from its primary regulator regarding inadequate anti-money laundering (AML) controls, weak data governance practices, and insufficient operational resilience capabilities. The regulator has given SecureBank 18 months to demonstrate significant improvement or face potential license restrictions.

The Chief Architect has been asked to develop an architecture that addresses all three regulatory concerns holistically rather than through disconnected remediation projects. Currently, AML screening is performed by a legacy system that operates in batch mode (processing transactions overnight), data governance is handled through manual spreadsheets with no automated data quality controls, and operational resilience testing has never been conducted because the bank lacks a comprehensive view of its critical business services and their technology dependencies.

The architecture team has completed the Architecture Vision (Phase A) and is now working through the Business Architecture (Phase B). They have identified that the three regulatory concerns are deeply interconnected: effective AML requires high-quality data; operational resilience requires understanding service dependencies; and data governance underpins both. However, the remediation project has been organized into three separate workstreams with different project managers, budgets, and timelines. Each workstream is developing its own solution independently, with no coordination mechanism.

### Question 2
What should the Chief Architect recommend to ensure the regulatory compliance architecture is coherent and effective?

a) Allow the three workstreams to continue independently since each has its own project manager and budget, and combine their outputs at the end into a single architecture document for the regulator

b) Recommend restructuring the program governance to establish the enterprise architecture as the integrating mechanism across all three workstreams, using the Architecture Definition Document to define a unified Target Architecture that addresses the interconnected regulatory requirements, with the Business Architecture (Phase B) establishing the critical business services map that serves as the foundation for all three compliance domains, and Requirements Management ensuring cross-workstream dependencies are identified and managed

c) Advise the bank to hire a regulatory consulting firm to handle the compliance response instead of using enterprise architecture, as regulatory compliance is outside the scope of TOGAF

d) Focus exclusively on the AML workstream since it is the highest-risk regulatory finding, and defer the data governance and operational resilience workstreams until the AML issue is resolved

---

## Scenario 3: Architecture Team Restructuring at Vanguard Insurance

Vanguard Insurance is restructuring its IT organization to support a new operating model based on value streams rather than functional silos. The company has identified six value streams: Customer Acquisition, Policy Servicing, Claims Management, Risk & Underwriting, Investment Management, and Corporate Services. Each value stream will be led by a Value Stream Owner with end-to-end accountability for business outcomes.

The existing enterprise architecture team consists of eight architects organized by domain: two Business Architects, two Application Architects, two Data Architects, and two Technology Architects. Under the current model, each architect works across all business areas within their domain specialization. The CTO wants to restructure the architecture team to align with the new value stream model.

Two restructuring options have been proposed. Option A would assign one architect to each value stream as a "full-stack" architect responsible for all architecture domains within that value stream, with the remaining two architects serving as enterprise-level architects focused on cross-cutting concerns. Option B would maintain the domain specialization but create a matrix structure where each domain architect is assigned to serve two or three value streams, maintaining their domain expertise while developing value stream knowledge. The architects themselves are divided on the best approach — the Business and Application Architects favor Option A for its closer business alignment, while the Data and Technology Architects favor Option B because they believe their specializations require deep domain expertise that would be diluted in a full-stack model.

### Question 3
Based on TOGAF's guidance on architecture team organization and architecture partitioning, which restructuring option should the Chief Architect recommend?

a) Option A (full-stack value stream architects) without modification, as this best aligns with modern agile organizational principles and eliminates the coordination overhead of the domain-specialized model

b) A hybrid approach combining elements of both options: assign architects to value streams as the primary alignment (supporting Option A's business proximity) but establish architecture domain communities of practice led by the most experienced domain specialists to maintain and develop deep expertise, using TOGAF's Architecture Partitioning concepts to define clear boundaries between value stream (segment-level) architecture work and enterprise-wide (strategic-level) architecture concerns that require cross-value-stream coordination

c) Option B (matrix structure) without modification, as maintaining domain specialization is essential for architecture quality and the matrix structure provides sufficient business alignment through the value stream assignments

d) Maintain the current domain-based structure and reject the value stream alignment entirely, as changing the architecture team structure will disrupt ongoing architecture work and domain expertise is more important than business alignment

---

## Scenario 4: SOA Implementation Decisions at Meridian Logistics

Meridian Logistics is a global freight and logistics company that operates across 30 countries with 20,000 employees. The company has decided to implement a Service-Oriented Architecture (SOA) to improve integration between its core operational systems: Transportation Management, Warehouse Management, Customs & Compliance, Customer Relationship Management, and Financial Management. Currently, these systems are integrated through 85 point-to-point interfaces using a mix of file transfers, database links, and custom APIs.

The architecture team has completed Phase A through Phase C of the ADM and has defined a Target Architecture based on SOA principles with an Enterprise Service Bus (ESB) as the integration backbone. However, during Phase D (Technology Architecture), a heated debate has emerged. The younger architects advocate for replacing the ESB concept with a modern event-driven microservices architecture using an API gateway and message broker, arguing that ESB is an outdated pattern. The senior architects counter that the ESB provides the centralized governance and orchestration capabilities needed for a logistics operation where transaction integrity is critical.

Meanwhile, the IT Operations team has raised concerns about both approaches, noting that the company lacks the skills and operational maturity to manage either a complex ESB infrastructure or a distributed microservices architecture. The current operations team is experienced with traditional middleware and batch processing. The CTO has asked the Chief Architect to make a definitive technology architecture recommendation.

### Question 4
What should the Chief Architect recommend during Phase D (Technology Architecture)?

a) Adopt the full microservices architecture with API gateway and message broker, as ESB is an outdated technology that will create a single point of failure and does not align with industry best practices

b) Evaluate both approaches against the organization's specific requirements, constraints, and capabilities using a structured assessment that considers the Architecture Requirements Specification from previous phases, the IT operations team's current maturity and skills, the need for transaction integrity in logistics operations, and the organization's ability to evolve — then define a pragmatic Target Technology Architecture that may incorporate elements of both patterns (e.g., API-led integration for new services with event-driven patterns for real-time logistics events, while using managed integration services to reduce operational complexity), documenting the rationale and trade-offs in the Architecture Definition Document

c) Implement the ESB as originally designed in Phase C, as changing the technology approach during Phase D would require restarting the ADM from Phase A and would delay the program unacceptably

d) Defer the technology decision entirely and implement the SOA Target Architecture using the existing point-to-point integration approach, adding the ESB or microservices layer in a future ADM cycle when the organization has developed the necessary skills

---

## Scenario 5: Data Architecture Consolidation at Premier Healthcare Group

Premier Healthcare Group was formed through the acquisition of three independent hospital operators over the past four years. Each acquired organization brought its own data architecture, including separate master data management systems, data warehouses, reporting platforms, and data governance frameworks. The result is a fragmented data landscape with three separate patient master data repositories (containing overlapping but inconsistent patient records), three data warehouses with different dimensional models, and no single source of truth for key metrics such as patient outcomes, operational efficiency, or financial performance.

The Group CFO has mandated a data architecture consolidation to create a "single version of the truth" for executive reporting and regulatory submissions. The Chief Data Officer (CDO) and Chief Architect are jointly leading this initiative. The architecture team has completed the Business Architecture (Phase B), which identified 45 key business data entities and their usage across the three legacy organizations. They are now in Phase C, working on the Data Architecture component of the Information Systems Architecture.

A critical challenge has emerged: each legacy organization's clinical staff has customized their local data models and reporting to support their specific clinical workflows. A top-down consolidation that replaces these local data architectures with a single enterprise model would disrupt clinical operations and faces strong resistance from the clinical leadership at all three hospitals. However, maintaining three separate data architectures indefinitely defeats the consolidation objective.

### Question 5
What approach should the Chief Architect recommend for the data architecture consolidation during Phase C?

a) Implement a single, centralized enterprise data model that replaces all three legacy data architectures immediately, enforcing standardization across all hospitals to achieve the "single version of the truth" as quickly as possible

b) Design a layered data architecture that preserves operational data autonomy at each hospital while establishing an enterprise data integration layer — define a canonical data model for the 45 key business data entities that serves as the master reference, implement master data management for cross-hospital entities (especially patient records), and create a unified analytics layer that maps local data models to the enterprise model, using Transition Architectures to phase the implementation starting with the highest-priority consolidation areas (patient identity, financial reporting) while allowing local clinical data models to evolve toward the enterprise model over time

c) Abandon the consolidation effort and instead build custom reports that manually reconcile data from the three separate data warehouses, providing the CFO with a consolidated view without changing the underlying data architecture

d) Select the data architecture from the largest acquired hospital and mandate that the other two hospitals migrate all their data to this model within six months, as this minimizes the amount of new architecture work required

---

## Scenario 6: Technology Standards Management at NexGen Software

NexGen Software is a rapidly growing enterprise software company that has scaled from 200 to 2,000 developers in three years. The company develops a suite of integrated business applications sold to mid-market companies. The enterprise architecture team established a Technology Reference Model (TRM) and technology standards two years ago, specifying approved programming languages, frameworks, databases, messaging systems, and deployment platforms.

However, the standards have become a source of significant friction. Development teams complain that the approved standards are outdated — for example, the TRM specifies React 16 while the industry has moved to React 19, and the approved database standard is MySQL while several teams need graph database capabilities for new product features. The architecture team has not updated the TRM since its initial publication, and there is no formal process for proposing, evaluating, or approving new technologies.

Meanwhile, teams have started adopting unapproved technologies informally. A recent audit revealed that 15 different JavaScript frameworks, 8 database technologies, and 4 container orchestration platforms are in use across the company — far exceeding the approved standards. The CTO is concerned about the maintenance burden and skill fragmentation this creates but also recognizes that overly restrictive standards stifle innovation.

### Question 6
How should the Chief Architect reform the technology standards management process?

a) Immediately update the TRM with the latest versions of all currently approved technologies and add every technology found in the audit to the approved list, eliminating the compliance gap by making everything that is currently in use an official standard

b) Establish a Technology Lifecycle Management process that includes: a regular review cadence (e.g., quarterly) for evaluating and updating technology standards; a formal Technology Adoption process where teams can propose new technologies with a business case, which are then evaluated against criteria including strategic fit, skills availability, vendor viability, and total cost of ownership; classification of technologies into categories (preferred, accepted, contained, retired) using the TOGAF Standards Information Base concept; and a Technology Radar that provides visibility into emerging technologies under evaluation — ensuring the TRM remains a living document that balances standardization with innovation

c) Remove all technology standards and allow development teams complete freedom to choose any technology they prefer, as standards are inherently incompatible with developer productivity and innovation

d) Lock down the existing TRM and mandate that all teams using unapproved technologies must immediately migrate to the approved stack within 60 days, with non-compliance resulting in project cancellation

---

## Scenario 7: Vendor Evaluation Using Architecture Framework at Atlas Manufacturing

Atlas Manufacturing is a $5 billion industrial conglomerate evaluating enterprise resource planning (ERP) solutions to replace its aging, heavily customized SAP ECC system. The company operates 12 manufacturing plants across three continents, with complex supply chain, production planning, quality management, and financial operations. The current ERP has been customized with over 3,000 modifications that reflect the company's unique manufacturing processes, but these customizations have made the system unmaintainable and have blocked upgrades for seven years.

The CFO is championing a move to a cloud-based ERP to reduce IT costs, while the COO insists that any new system must support the company's unique manufacturing processes without sacrificing the functionality provided by the current customizations. The IT team has shortlisted three vendors: a tier-one cloud ERP provider that requires process standardization ("adopt not adapt"), a best-of-breed solution that offers extensive configurability but requires integration of multiple specialized modules, and a mid-market ERP that offers a good balance of functionality and customization at a lower cost but has limited global deployment experience.

The Chief Architect has been asked to lead the vendor evaluation and make a recommendation. The procurement team wants to base the decision primarily on cost, while the COO insists on functional fit as the primary criterion.

### Question 7
How should the Chief Architect structure the vendor evaluation using TOGAF?

a) Base the evaluation solely on a detailed feature comparison matrix that maps each vendor's capabilities against the 3,000 existing customizations, selecting the vendor that covers the most existing functionality

b) Use the Architecture Definition Document and Architecture Requirements Specification developed during the ADM as the foundation for the evaluation — assess each vendor against the Target Architecture requirements across all four architecture domains (business, data, application, technology), evaluate alignment with Architecture Principles, assess the gap between each vendor's baseline capabilities and the target requirements, consider the Transition Architecture implications (migration complexity, timeline, risk) for each option, and weight the evaluation criteria based on business priorities agreed with key stakeholders through the architecture governance process

c) Defer to the procurement team's cost-based evaluation since vendor selection is fundamentally a commercial decision that falls outside the scope of enterprise architecture

d) Recommend the tier-one cloud ERP provider by default because industry analysts rank it highest, and advise the COO that the company should change its manufacturing processes to fit the software rather than customizing the software

---

## Scenario 8: Architecture Review Board Operations at Centennial Bank

Centennial Bank has operated an Architecture Review Board (ARB) for three years. The ARB consists of the Chief Architect (chair), four domain architects (business, application, data, technology), the CISO, and two rotating business representatives. The ARB meets bi-weekly and reviews project architecture deliverables at key gates: Architecture Vision approval, Target Architecture approval, and implementation compliance review.

Recently, the ARB's effectiveness has been questioned by multiple stakeholders. Project managers complain that ARB meetings are poorly structured — reviews often run over time, discussions devolve into technical debates between architects with no clear outcome, and decisions are not consistently documented or communicated. Three projects have reported delays of two to four weeks waiting for ARB decisions. Business representatives find the meetings too technical and have stopped attending regularly, which means business perspective is missing from architecture decisions.

The Head of the Project Management Office (PMO) has formally complained to the CIO, stating that the ARB is a bottleneck and suggesting it be replaced with a simpler sign-off process where the Chief Architect alone approves architecture deliverables. The Chief Architect recognizes that the ARB process needs improvement but believes that a single-person approval process would reduce the quality and breadth of architecture reviews.

### Question 8
How should the Chief Architect reform the ARB to address these operational issues while maintaining effective architecture governance?

a) Accept the PMO Head's suggestion and replace the ARB with a single Chief Architect approval process, as this would eliminate the bottleneck and the Chief Architect has sufficient expertise to make all architecture decisions independently

b) Reform the ARB operations by: establishing clear, time-boxed review procedures with standardized review criteria and templates to ensure focused discussions; implementing a pre-review process where the architecture team conducts detailed technical analysis before the ARB meeting so that ARB sessions focus on decision-making rather than discovery; creating separate tracks for technical reviews (handled by the architecture team) and governance decisions (handled by the ARB) to reduce meeting scope; producing clear, written decision records that are communicated to all stakeholders; and redesigning business representative engagement with business-friendly materials and scheduling — aligning the reformed process with TOGAF's Architecture Governance framework guidance on compliance reviews and organizational structure

c) Increase ARB meeting frequency from bi-weekly to weekly to address the backlog, while keeping all other processes unchanged

d) Remove the business representatives from the ARB permanently since they find the meetings too technical, and run the ARB as a purely technical review body of architects and the CISO

---

## Answer Key

### Scenario 1 - Question 1
**Scoring:**
- **Answer b) = 5 points (Best):** This approach correctly focuses the Preliminary Phase on its core TOGAF deliverables: the Organizational Model for Enterprise Architecture, Architecture Principles, and a Tailored Architecture Framework. Developing principles collaboratively with business stakeholders directly addresses the "ivory tower" concern and demonstrates EA's relevance beyond IT. The 90-day timeframe creates urgency and builds momentum toward the Board's 12-month value demonstration expectation. TOGAF's Preliminary Phase guidance explicitly covers these three areas as foundational to the EA practice.
- **Answer c) = 3 points (Second Best):** While demonstrating value quickly is important and Phase A would deliver visible results, the Preliminary Phase is not optional — it establishes the essential foundation (organizational model, principles, tailored framework) without which Phase A will lack direction and governance. However, this answer correctly identifies the urgency of delivering business value and the iterative nature of the ADM.
- **Answer d) = 1 point (Third Best):** An Architecture Repository and tooling are important long-term investments, but spending the entire first-year budget on tools and inventory before establishing the foundational elements of the EA practice is premature. TOGAF addresses the Architecture Repository as part of the Preliminary Phase but as a component, not the sole focus.
- **Answer a) = 0 points (Distractor):** A 100-page framework document created in isolation before any stakeholder engagement is the epitome of the "ivory tower" approach that business executives already fear. This approach ignores TOGAF's emphasis on stakeholder engagement and tailoring the framework to the organization's needs and maturity level.

### Scenario 2 - Question 2
**Scoring:**
- **Answer b) = 5 points (Best):** This approach correctly uses enterprise architecture as an integrating mechanism across related initiatives. The Architecture Definition Document is designed to provide a unified view of the Target Architecture across all domains. Using Business Architecture (Phase B) to map critical business services provides the foundation for understanding dependencies across all three compliance areas. Requirements Management running throughout the ADM ensures cross-workstream dependencies are identified and managed. TOGAF's ADM is specifically designed to address interconnected architectural concerns holistically rather than in silos.
- **Answer d) = 3 points (Second Best):** Prioritizing AML as the highest risk is a valid risk management approach. However, the scenario explicitly states that the three concerns are deeply interconnected — addressing AML in isolation without data governance (which AML depends on) would be suboptimal. TOGAF supports risk-based prioritization but also emphasizes understanding dependencies.
- **Answer a) = 1 point (Third Best):** Allowing independent workstreams acknowledges the existing organizational structure, but combining outputs at the end is a recipe for inconsistency and integration failure. The scenario has already identified that the three areas are deeply interconnected, making independent development risky. This approach would likely require significant rework to achieve coherence.
- **Answer c) = 0 points (Distractor):** Regulatory compliance architecture is well within the scope of TOGAF. Enterprise architecture regularly addresses compliance requirements as part of business and information systems architecture. Suggesting that TOGAF cannot handle regulatory requirements demonstrates a fundamental misunderstanding of the framework's applicability.

### Scenario 3 - Question 3
**Scoring:**
- **Answer b) = 5 points (Best):** This hybrid approach directly applies TOGAF's Architecture Partitioning concepts, which distinguish between Strategic Architecture (enterprise-wide, cross-cutting concerns) and Segment Architecture (specific business areas or value streams). Assigning architects to value streams provides the business proximity that Option A offers, while communities of practice maintain the deep domain expertise that Option B preserves. The distinction between segment-level and strategic-level architecture work provides clear role boundaries. This approach is pragmatic and addresses concerns from both groups of architects.
- **Answer c) = 3 points (Second Best):** Option B preserves important domain expertise and provides some business alignment through matrix assignments. However, a matrix structure can create ambiguity about priorities and accountability. The Data and Technology Architects' concern about specialization dilution is valid, which this option addresses, but the lack of primary business alignment limits the architecture team's effectiveness in supporting value streams.
- **Answer a) = 1 point (Third Best):** Option A provides the strongest business alignment but risks diluting specialized expertise, particularly in complex domains like data architecture and technology infrastructure. TOGAF recognizes that certain architecture domains require specialized knowledge that is difficult to maintain in a generalist role.
- **Answer d) = 0 points (Distractor):** Refusing to align the architecture team with the new organizational model isolates the architecture function from the business. TOGAF emphasizes that the architecture practice must be aligned with the organization's structure and operating model. Maintaining an outdated organizational structure while the rest of the company transforms would marginalize the architecture team.

### Scenario 4 - Question 4
**Scoring:**
- **Answer b) = 5 points (Best):** This approach correctly applies Phase D's purpose: selecting technology components that address the requirements defined in earlier phases. Using the Architecture Requirements Specification as the evaluation baseline ensures the technology decision is driven by actual requirements rather than technology preferences. Considering the IT operations team's maturity is essential — TOGAF emphasizes that architecture must be implementable within the organization's capabilities. A pragmatic approach that combines patterns based on specific use cases (rather than dogmatic adherence to one pattern) demonstrates mature architectural thinking. Documenting rationale and trade-offs in the Architecture Definition Document ensures transparency.
- **Answer d) = 3 points (Second Best):** Deferring the technology decision and focusing on skill development acknowledges the IT operations team's constraints. However, implementing the SOA Target Architecture on existing point-to-point integrations is contradictory — SOA requires an integration strategy. This approach delays needed modernization while potentially creating more technical debt by building new services on the existing integration spaghetti.
- **Answer a) = 1 point (Third Best):** While microservices architecture has merits, this recommendation is technology-driven rather than requirements-driven. It ignores the IT operations team's maturity constraints, the need for transaction integrity in logistics, and the organization's ability to manage a distributed architecture. TOGAF emphasizes that technology decisions should be driven by business requirements and organizational capabilities, not industry trends.
- **Answer c) = 0 points (Distractor):** The ADM is iterative and allows for feedback between phases. Discovering new information during Phase D that requires adjustments to Phase C outputs is a normal part of the ADM cycle — it does not require restarting from Phase A. TOGAF's iteration model explicitly supports revisiting earlier phases when new information emerges. This answer reflects a rigid, waterfall interpretation of the ADM that contradicts its design.

### Scenario 5 - Question 5
**Scoring:**
- **Answer b) = 5 points (Best):** This layered approach correctly applies TOGAF's Transition Architecture concept — creating intermediate stable states that move from baseline to target incrementally. The canonical data model for key business entities addresses the "single version of the truth" requirement while preserving operational data autonomy that clinical staff depend on. Master data management for cross-hospital entities (especially patient records) addresses the most critical consolidation need. Using Transition Architectures to prioritize based on business value (starting with patient identity and financial reporting) demonstrates risk-aware, value-driven architecture planning. This approach respects the constraint that clinical workflows cannot be disrupted.
- **Answer d) = 3 points (Second Best):** Selecting the largest hospital's data architecture as the target reduces the amount of new design work. However, this approach is likely to face even stronger resistance from the other two hospitals (whose staff would bear the full migration burden), and the largest hospital's model may not be the best fit for the consolidated enterprise. It partially addresses the consolidation need but does so in a politically risky manner.
- **Answer c) = 1 point (Third Best):** Custom reconciliation reports provide a tactical solution to the CFO's immediate need but do not address the underlying data architecture fragmentation. This approach creates an ongoing manual burden and does not enable the operational benefits (e.g., unified patient records, consistent clinical analytics) that a proper data architecture consolidation would deliver.
- **Answer a) = 0 points (Distractor):** Immediate replacement of all three data architectures with a single model ignores the operational reality that clinical systems depend on their current data models. This approach would disrupt clinical operations, faces strong resistance, and creates unacceptable implementation risk. It reflects a technically ideal but practically undeliverable architecture.

### Scenario 6 - Question 6
**Scoring:**
- **Answer b) = 5 points (Best):** This approach establishes a sustainable Technology Lifecycle Management process that addresses the root cause: the lack of a process for evolving technology standards. The Standards Information Base is a TOGAF concept that supports classification of standards by lifecycle status. A Technology Adoption process provides a legitimate channel for teams to propose new technologies, reducing the incentive to adopt technologies informally. The Technology Radar concept provides forward-looking visibility. Regular review cadences ensure the TRM remains current. This approach balances standardization (reducing fragmentation) with controlled innovation.
- **Answer a) = 3 points (Second Best):** Updating the TRM with current versions is necessary, but simply approving everything currently in use does not address the underlying problem of technology proliferation. Making all 15 JavaScript frameworks approved standards would legitimize fragmentation rather than managing it. However, this answer correctly identifies that the standards need updating.
- **Answer d) = 1 point (Third Best):** Enforcing current standards addresses the compliance gap but does so punitively and unrealistically. A 60-day migration mandate for all non-compliant technologies would be massively disruptive and would not address the legitimate need for technologies not in the current TRM (such as graph databases).
- **Answer c) = 0 points (Distractor):** Eliminating all technology standards would accelerate the fragmentation problem, increasing the maintenance burden, skill fragmentation, and operational complexity that the CTO is already concerned about. TOGAF recognizes technology standards as essential for managing technology diversity across the enterprise.

### Scenario 7 - Question 7
**Scoring:**
- **Answer b) = 5 points (Best):** This approach uses the ADM's core deliverables (Architecture Definition Document and Architecture Requirements Specification) as the evaluation foundation, ensuring the vendor assessment is driven by the organization's actual architectural requirements rather than generic feature lists or cost alone. Evaluating across all four TOGAF architecture domains provides a comprehensive assessment. Considering Transition Architecture implications (migration complexity, timeline, risk) addresses the practical reality that the best vendor on paper may be the hardest to implement. Weighting criteria based on stakeholder-agreed business priorities ensures the evaluation reflects organizational values, not just architectural preferences.
- **Answer a) = 3 points (Second Best):** A feature comparison against existing customizations is a reasonable component of the evaluation but is backward-looking — it assesses the vendor against the current state rather than the Target Architecture. Many of the 3,000 customizations may represent legacy practices that the Target Architecture intends to change. However, understanding functional coverage is a legitimate evaluation criterion.
- **Answer d) = 1 point (Third Best):** Recommending a vendor based solely on analyst rankings without assessing fit to the organization's specific requirements demonstrates superficial analysis. Advising the COO to change manufacturing processes to fit the software may be partially valid (reducing customization is generally beneficial) but dismissing the COO's requirements entirely ignores stakeholder management principles.
- **Answer c) = 0 points (Distractor):** Vendor evaluation for a strategic platform like ERP is absolutely within the scope of enterprise architecture. The architectural implications of the vendor choice (integration patterns, data migration, technology platform, deployment model) are fundamental architecture decisions. Deferring to procurement on a purely cost basis would likely result in a selection that fails to meet the organization's architectural requirements.

### Scenario 8 - Question 8
**Scoring:**
- **Answer b) = 5 points (Best):** This comprehensive reform addresses each identified problem: time-boxed reviews with standardized criteria fix the unstructured meetings; pre-review technical analysis separates technical detail from governance decisions, reducing meeting scope and duration; written decision records address the communication gap; redesigned business engagement ensures business perspective is maintained. This approach aligns with TOGAF's Architecture Governance framework, which provides guidance on governance organization, compliance review processes, and communication. The reforms maintain the multi-perspective review that an ARB provides while addressing the operational issues.
- **Answer c) = 3 points (Second Best):** Increasing meeting frequency could reduce the backlog and wait times. However, without addressing the structural issues (unstructured discussions, missing business input, poor documentation), more frequent meetings would simply create more instances of the same problems. This addresses a symptom (backlog) without fixing the root causes.
- **Answer a) = 1 point (Third Best):** A single-person approval process would indeed eliminate the bottleneck but at the cost of losing multi-perspective review. The Chief Architect alone cannot bring the breadth of knowledge across all architecture domains plus security and business perspectives. TOGAF's governance guidance supports collaborative review bodies for significant architectural decisions.
- **Answer d) = 0 points (Distractor):** Removing business representatives eliminates the business perspective from architecture decisions, which is the opposite of what TOGAF advocates. The problem is not that business representatives attend but that the meetings are too technical for them. The solution is to make the process more accessible to business participants, not to exclude them.

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
