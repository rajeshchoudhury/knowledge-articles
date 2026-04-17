# TOGAF Part 2 Certified - Practice Test 21
**Time Allowed:** 90 minutes | **Questions:** 8 | **Pass Mark:** 60% (24/40)
**Maximum Score:** 40 points

---

## Scenario 1: Retail Company Digital Transformation

GlobalMart is a large brick-and-mortar retail chain with 2,400 stores across 18 countries. The company has experienced a 15% decline in foot traffic over the past three years as consumers increasingly shift to online shopping. The CEO has launched a "Digital First" initiative with a $450 million investment over three years to fundamentally transform how the company operates and engages with customers. The transformation encompasses building an omnichannel commerce platform, creating a unified customer data platform, implementing AI-driven supply chain optimization, digitizing in-store experiences with IoT sensors and smart shelving, and launching a marketplace model allowing third-party sellers.

The enterprise architecture team has been asked to lead the transformation. Currently, GlobalMart's IT landscape consists of a 15-year-old monolithic ERP system (heavily customized SAP), 47 different point-of-sale systems across different regions, 12 separate customer databases with no master data management, and a legacy warehouse management system written in COBOL. There are approximately 340 integration points, many of which are batch-based file transfers running overnight. The company has minimal cloud presence and no API management capability.

The CIO has asked the Chief Architect to present the recommended architectural approach to the executive committee within four weeks. Some executives are pushing for a "big bang" replacement of all legacy systems, while others want an incremental approach. The CFO is concerned about the investment risk, and the COO wants to ensure store operations are never disrupted during the transition.

### Question 1
As the Chief Architect, what is the BEST approach to structure this digital transformation using the TOGAF ADM?

a) Execute a full ADM cycle starting with Architecture Vision through to Architecture Change Management, treating the entire digital transformation as a single architecture project, ensuring comprehensive coverage of all requirements before any implementation begins.

b) Apply the ADM using the Architecture Landscape concept with Strategic Architecture for the overall transformation vision, then partition into Segment Architectures for each major capability (omnichannel, supply chain, data platform, marketplace), and use iteration within each segment to deliver incremental value while maintaining alignment to the strategic direction.

c) Skip the ADM entirely since it is too slow for digital transformation, instead adopt a pure agile approach with autonomous squads working on individual components, and retrospectively document the architecture once implementations are complete.

d) Begin with Phase B (Business Architecture) to fully document all 2,400 stores' current business processes before making any architectural decisions, ensuring complete baseline documentation of the existing state across all 18 countries.

---

## Scenario 2: API Strategy Decisions

NorthStar Financial Services is a mid-sized financial institution undergoing a modernization program. The enterprise architecture team has been developing an API strategy to expose core banking capabilities as services. The strategy must address multiple stakeholder concerns: the Digital Banking team wants to rapidly build mobile applications, the Partnership team wants to enable Open Banking with fintech partners, the Risk team is concerned about data exposure and compliance with financial regulations, and the Infrastructure team is worried about performance impacts on core banking systems.

The current state includes a mainframe-based core banking system processing 2.3 million transactions daily, a middleware layer using IBM MQ for message routing, and several departmental applications accessing data through direct database connections. There is no formal API management platform, and the few existing REST APIs were built ad-hoc by individual project teams with no consistent standards for security, versioning, or error handling.

The Chief Architect has proposed implementing an API management platform with a three-tier API architecture: System APIs (wrapping core systems), Process APIs (orchestrating business logic), and Experience APIs (tailored for specific channels). However, the Head of Development argues this is over-engineered and wants to simply expose database views as REST endpoints for speed. The CISO insists on API security standards compliance with PSD2 and Open Banking regulations. The program has a 12-month timeline to deliver the first set of partner-facing APIs.

### Question 2
What is the BEST approach for the Chief Architect to resolve the conflicting stakeholder requirements and establish the API architecture?

a) Accept the Head of Development's simpler approach of exposing database views as REST endpoints to meet the 12-month timeline, and plan to refactor later once the urgency passes, as delivering on time is the most critical success factor.

b) Conduct Architecture Vision (Phase A) with all key stakeholders to establish shared concerns and objectives, then use the Business Scenarios technique to capture the API strategy requirements from each stakeholder perspective. Develop the Target Architecture across Phases B through D showing how the three-tier API model addresses each concern, and use the Architecture Requirements Specification to formally capture security and compliance constraints as non-negotiable requirements.

c) Escalate the disagreement to the Architecture Board and have them mandate the three-tier API architecture, then distribute the decision to all teams with a directive to comply, using architecture compliance reviews to enforce adoption.

d) Propose implementing only the Experience API layer since that is what the Digital Banking team needs most urgently, deferring the System and Process API layers to a future phase, and allowing direct database access to continue for internal applications.

---

## Scenario 3: Architecture Vision Development for Board

MedTech Innovations is a healthcare technology company that has grown rapidly through acquisitions, now comprising five previously independent business units: electronic health records (EHR), medical imaging, laboratory information systems (LIS), pharmacy management, and telehealth. Each unit operates its own technology stack, has its own IT team, and serves its own customer base. The Board of Directors has mandated an integrated platform strategy to achieve synergies and create a unified patient journey across all products.

The newly appointed Chief Enterprise Architect must present an Architecture Vision to the Board within six weeks. The challenge is significant: the five business units have different maturity levels (the EHR unit is CMMI Level 4 while telehealth is essentially a startup), different regulatory requirements (HIPAA, FDA 21 CFR Part 11, CLIA), different technology platforms (.NET, Java, Python, Node.js), and different go-to-market strategies. Some business unit heads see integration as a threat to their autonomy and are passively resisting the initiative. The Board expects the Architecture Vision to clearly articulate the business value, technical feasibility, risk profile, and a credible high-level roadmap.

Patient safety is paramount—any integration errors that lead to incorrect patient data correlation could have life-threatening consequences. The current customer base includes 340 hospitals and 12,000 clinics, and any disruption to their operations during integration would be catastrophic for the company's reputation.

### Question 3
What is the BEST approach for creating the Architecture Vision to present to the Board?

a) Focus the Architecture Vision exclusively on the technical integration approach, presenting detailed component diagrams and data flow architectures that demonstrate how the five platforms will be connected, as the Board needs to understand the technical complexity to approve the investment.

b) Develop the Architecture Vision using the TOGAF Architecture Vision document structure, incorporating a Stakeholder Map analysis to identify and address Board concerns, using Business Scenarios to illustrate the value of integration from the patient journey perspective, establishing Architecture Principles that address both innovation and patient safety, and including a high-level capability-based roadmap that shows incremental value delivery while managing risk through defined Transition Architectures.

c) Present the Architecture Vision as a comparison of three vendor platform solutions (Epic, Cerner, and a custom build), with a recommendation to select one and migrate all business units to it, as this provides the Board with a clear decision framework and simplifies the integration challenge.

d) Delay the Architecture Vision presentation and instead conduct a six-month current state assessment of all five business units, documenting every system, interface, and data element before attempting to define any target state, as the Board needs complete information to make an informed decision.

---

## Scenario 4: Segment Architecture vs Capability Architecture Decisions

A multinational energy company, PowerGrid Corp, is undertaking an enterprise architecture initiative to support its strategic pivot from fossil fuels to renewable energy. The company operates in three major segments: traditional power generation (coal and gas plants), renewable energy (wind and solar farms), and energy distribution (grid management). Each segment has distinct operational needs, regulatory environments, and technology requirements.

The EA team is debating the best way to organize and partition their architecture work. The Head of Traditional Power Generation wants a segment-based approach aligned to his business unit, arguing that his regulatory and operational needs are unique (emissions monitoring, plant safety systems, decommissioning planning). The VP of Renewable Energy argues for a capability-based approach, noting that capabilities like "Asset Performance Management," "Energy Trading," and "Customer Engagement" cut across all three segments and offer greater reuse potential. The CTO supports the capability approach but acknowledges that some capabilities are genuinely segment-specific (e.g., nuclear safety for traditional, intermittency management for renewables).

The EA team has limited resources—only eight architects for an organization of 45,000 employees. They need to deliver actionable architecture guidance within six months while establishing a framework that scales as the company's renewable portfolio grows from 20% to a targeted 70% of revenue over 10 years.

### Question 4
What is the BEST approach to organizing the architecture work for PowerGrid Corp?

a) Adopt a purely segment-based architecture approach aligned to the three business segments (traditional, renewable, distribution), with each segment having its own complete architecture stack, as this best reflects the organizational structure and ensures each segment's unique regulatory requirements are addressed.

b) Implement a hybrid approach using the TOGAF Architecture Landscape concept: define a Strategic Architecture that establishes cross-cutting capabilities and shared services at the enterprise level, then develop Segment Architectures for each business unit that inherit from and extend the strategic architecture. Use Capability Architecture to define shared capabilities (Asset Performance Management, Energy Trading, Customer Engagement, Workforce Management) that span segments, while allowing segment-specific capability extensions where genuinely unique requirements exist. Prioritize the architecture work using a capability heat map that identifies the capabilities most critical to the renewable energy transition.

c) Focus exclusively on a capability-based architecture since the company is transitioning to renewables, and traditional power generation will be phased out anyway. This saves the limited architecture team from wasting time on a declining business segment.

d) Hire a consulting firm to build the complete enterprise architecture across all segments simultaneously, as the internal team of eight architects is insufficient to deliver within six months, and it is better to get external expertise than to compromise on scope.

---

## Scenario 5: Technology Standardization Conflicts

A global logistics company, SwiftFreight, operates across 32 countries with a workforce of 78,000. Following a period of rapid growth through acquisitions (12 companies acquired in 5 years), the technology landscape has become extremely fragmented: 6 different ERP systems, 4 warehouse management systems, 8 transportation management platforms, 3 CRM systems, and over 200 custom applications. Annual IT spending is $1.2 billion, with 72% spent on maintaining existing systems and only 28% on new capabilities.

The newly appointed CTO has mandated technology standardization to reduce the maintenance burden and free up investment for innovation. However, significant resistance has emerged. Regional leaders argue that their local systems are deeply integrated with local logistics partners, customs systems, and regulatory reporting requirements. The Asia-Pacific region, which accounts for 40% of revenue and is growing fastest, has invested heavily in a modern microservices-based platform and refuses to migrate to the European-centric ERP that headquarters is proposing as the standard. The North American division has just completed a two-year SAP implementation and insists their system should be the standard. Meanwhile, the Africa division relies on lightweight mobile-first applications due to infrastructure constraints and cannot adopt enterprise-grade platforms.

The Architecture Board has been asked to establish the Technology Reference Model and make binding standards decisions.

### Question 5
What is the BEST approach for the Architecture Board to handle the technology standardization challenge?

a) Mandate a single global standard for each technology category (one ERP, one WMS, one TMS, one CRM) selected by evaluating all current systems against objective criteria, and enforce migration timelines for all regions, granting no exceptions to ensure consistency.

b) Develop a Technology Reference Model (TRM) using the TOGAF approach that defines technology standards at multiple levels: mandatory global standards for integration, security, and data (non-negotiable), preferred standards for major platform categories with defined criteria for granting dispensations, and permitted regional variations where genuine local requirements exist (documented through Architecture Requirements Specifications). Establish a Standards Information Base within the Architecture Repository, implement an Architecture Compliance review process with defined compliance levels (Irrelevant, Consistent, Compliant, Conformant, Fully Conformant, Non-Conformant), and create a Transition Architecture roadmap that sequences migrations based on business value, technical debt cost, and regional growth priorities—starting with high-value integration standards rather than wholesale platform replacement.

c) Allow each region to continue using their current technology stack but require all systems to expose standard APIs for integration, effectively creating a federated model where standardization occurs only at the interface level.

d) Postpone the standardization effort until the next budget cycle, using the intervening time to conduct a complete inventory of all 200+ applications, as the Architecture Board cannot make informed decisions without a comprehensive understanding of every application and its dependencies.

---

## Scenario 6: Architecture Repository Implementation

DataVault Insurance is implementing an Architecture Repository to support its enterprise architecture practice. The company has 12 enterprise architects, 45 solution architects, and over 200 project teams that need to consume architecture artifacts. Currently, architecture documentation is scattered across SharePoint sites, Confluence wikis, individual architects' laptops, and email attachments. There is no version control, no single source of truth, and significant duplication—the same system has been documented differently by three separate architects.

The EA team has selected an architecture modeling tool (Sparx Enterprise Architect) and is now debating how to structure the repository. The lead architect wants to implement the full TOGAF Architecture Repository structure immediately, including all six components. The tool administrator argues they should start with just a modeling repository and add governance components later. Several solution architects are skeptical about the initiative, viewing it as bureaucratic overhead that will slow down their project delivery. Project managers are concerned about the additional time required for architects to maintain repository content alongside their project work.

Budget constraints mean the team cannot hire additional staff, and the repository must be operational within four months. The CIO has stated that if the repository doesn't demonstrate value within six months, the initiative will be cancelled.

### Question 6
What is the BEST approach to implementing the Architecture Repository?

a) Implement all six components of the TOGAF Architecture Repository simultaneously (Architecture Metamodel, Architecture Capability, Architecture Landscape, Standards Information Base, Reference Library, Governance Log) to ensure completeness from day one, as partial implementation would compromise the integrity of the repository.

b) Take a phased approach prioritized by stakeholder value: Phase 1 (months 1-2) implement the Architecture Landscape (current state models and catalogs that solution architects need daily) and the Standards Information Base (technology standards that project teams reference for compliance). Phase 2 (months 3-4) add the Reference Library (reference architectures, templates, patterns) and Governance Log (decision records, compliance assessments). Phase 3 (months 5-6) implement the Architecture Metamodel formally and Architecture Capability documentation. Throughout all phases, establish clear content governance processes defining who creates, reviews, approves, and maintains each type of content. Define specific use cases for each stakeholder group (solution architects use it for project start-up, project managers use it for compliance checking) to demonstrate tangible value early.

c) Focus exclusively on migrating all existing documentation from SharePoint, Confluence, and other sources into the Sparx tool, creating a centralized document repository, as the primary problem is fragmentation and the most immediate value comes from having a single source of truth.

d) Abandon the structured repository approach and instead implement a wiki-based architecture knowledge base that architects can update freely without formal processes, as this reduces overhead and increases adoption by removing barriers to contribution.

---

## Scenario 7: Transition Architecture Sequencing

CityBank, a national bank with 15 million customers, is undertaking a core banking transformation from its legacy mainframe system (installed in 1998) to a modern cloud-native core banking platform. The transformation must be completed within 36 months due to the mainframe vendor's end-of-life announcement. The program affects every line of business: retail banking, commercial banking, wealth management, and credit cards. Approximately 1,200 batch processes, 450 online transactions, 340 interfaces to external systems (payment networks, credit bureaus, regulators), and 28 downstream systems depend on the current mainframe.

The program has been divided into four proposed waves by the program manager:
- Wave 1: Retail deposits and savings (8 million accounts)
- Wave 2: Commercial banking (45,000 business accounts but complex products)
- Wave 3: Credit cards (3 million cards, real-time transaction processing)
- Wave 4: Wealth management (200,000 accounts, highest revenue per account)

The Chief Architect must define the Transition Architectures for each wave, ensuring that at every point during the transformation, the bank remains fully operational, regulatory compliant, and able to process transactions without interruption. The regulators have indicated they will conduct enhanced supervision during the migration. The complexity is compounded by the need to run old and new systems in parallel during each wave, requiring a coexistence layer that translates between the mainframe's batch-oriented architecture and the new platform's event-driven architecture.

### Question 7
What is the BEST approach to defining and sequencing the Transition Architectures for CityBank's core banking transformation?

a) Accept the program manager's proposed four-wave sequence as-is since it logically groups products, and focus the architecture effort on designing the Target Architecture for the new cloud-native platform, leaving the transition details to the implementation teams.

b) Develop Transition Architectures for each wave using TOGAF Phase E (Opportunities and Solutions) and Phase F (Migration Planning) rigorously. Reassess the wave sequencing based on architectural dependencies (not just product grouping) by analyzing interface dependencies, shared data entities, and batch process chains. Define each Transition Architecture as a plateau that is independently stable—meaning the bank can operate indefinitely at any plateau if subsequent waves are delayed. For each transition, specify the coexistence architecture showing exactly how old and new systems interact, define rollback architectures for each wave in case of critical failure, create Implementation and Migration Plans that include parallel-run periods with reconciliation processes, identify regulatory touchpoints requiring regulator approval before each wave go-live, and establish architecture compliance criteria that must be met before progressing from one wave to the next. Use the TOGAF concept of "Architecture Building Blocks to Solution Building Blocks" mapping to ensure traceability from the target design through each transition state.

c) Propose a "big bang" migration approach where all lines of business are migrated simultaneously over a single weekend, eliminating the complexity of coexistence and parallel running, as the phased approach introduces more risk through prolonged dual-system operation.

d) Start with Wave 4 (Wealth Management) because it has the fewest accounts and highest revenue, making it the best candidate for a pilot migration, then use lessons learned to inform the larger retail and commercial waves.

---

## Scenario 8: EA Team Skills Assessment

UniGlobal Corporation, a diversified conglomerate operating in manufacturing, financial services, healthcare, and technology, has decided to establish a formal Enterprise Architecture practice. The company has appointed a Chief Architect and allocated budget for a team of 15 architects. Currently, the organization has several individuals with architecture-related responsibilities scattered across business units, but there is no formal EA practice, no defined architecture processes, and no architecture governance.

The Chief Architect must build the EA capability from scratch. The HR department has identified 22 internal candidates from IT and business roles who have expressed interest in architecture positions. Their backgrounds vary significantly: 5 are senior developers with deep technical skills but no business acumen, 4 are business analysts with strong domain knowledge but limited technology understanding, 3 are project managers who have managed architecture-related projects, 6 are infrastructure specialists focused on networks and servers, and 4 are current "solution architects" whose roles have been primarily technical design without enterprise-level thinking.

The TOGAF Architecture Skills Framework categorizes architecture skills and proficiency levels. The Chief Architect needs to assess the candidates, identify skill gaps, design a development program, and build a team structure that can deliver value within 12 months. The CEO expects the EA team to deliver its first enterprise-level architecture recommendation within 6 months.

### Question 8
What is the BEST approach for the Chief Architect to build the EA capability at UniGlobal?

a) Select the 15 candidates with the strongest technical skills, as enterprise architecture is fundamentally a technology discipline, and provide them with TOGAF certification training to develop their architecture methodology knowledge.

b) Apply the TOGAF Architecture Skills Framework to systematically assess all 22 candidates across the defined skill categories (General Skills, Business Skills and Methods, Enterprise Architecture Skills, Program or Project Management Skills, IT General Knowledge Skills, Technical IT Skills, Legal Environment). Map each candidate's current proficiency against the four levels (Background, Awareness, Knowledge, Expert) for roles aligned to the TOGAF ADM phases. Select the 15 candidates who collectively provide the broadest skill coverage across all categories, prioritizing candidates who demonstrate both business and technology understanding. Design the team structure to align with the ADM—assigning architects to lead specific phases based on their strengths (business-savvy architects lead Phase B, technology specialists lead Phase D) while establishing a rotation program to develop cross-cutting skills. Create a 12-month capability development roadmap with defined milestones, and establish mentoring pairs that combine technical and business skill sets.

c) Hire all 15 positions externally from candidates who already have TOGAF certification and enterprise architecture experience, as building internal capability takes too long to meet the CEO's 6-month expectation.

d) Start by sending all 22 candidates to TOGAF certification training, then select the 15 who score highest on the certification exam, as this ensures the selected team has the strongest TOGAF methodology knowledge.

---

## Answer Key

### Scenario 1 - Question 1: Retail Company Digital Transformation
**Scoring:**
- **Answer B = 5 points (Best):** This answer correctly applies the TOGAF Architecture Landscape concept (Section 3.6), which defines three levels of architecture: Strategic Architecture (providing long-term direction for the entire digital transformation), Segment Architectures (for each major capability area like omnichannel, supply chain, data platform, marketplace), and Capability Architectures (for specific implementation projects within each segment). This approach directly addresses the stakeholders' concerns: the CFO's risk concern is mitigated through incremental delivery, the COO's operational disruption concern is addressed through segment-level transitions, and the overall strategic direction is maintained through the Strategic Architecture. The iterative use of the ADM within each segment aligns with TOGAF's guidance on applying the ADM iteratively (Section 19).
- **Answer A = 3 points:** Recognizes the need to use the full ADM cycle, which is partially correct. However, treating the entire $450M digital transformation as a single monolithic architecture project would be impractical and risky. TOGAF explicitly recommends partitioning large efforts. This approach would take too long to deliver initial value and doesn't address the stakeholders' risk concerns.
- **Answer D = 1 point:** At least recognizes the importance of understanding the current state (Phase B baseline), which is a valid ADM activity. However, documenting all 2,400 stores' processes before making any decisions is analysis paralysis and not what TOGAF recommends—baseline descriptions should be at a level of detail sufficient to support the target architecture definition.
- **Answer C = 0 points:** Completely rejects the TOGAF ADM, which contradicts the fundamental premise of the certification. While agile integration is valid (TOGAF supports agile through its iterative ADM application), abandoning architectural governance for a $450M transformation with 340 integration points would be reckless and contrary to TOGAF principles.

### Scenario 2 - Question 2: API Strategy Decisions
**Scoring:**
- **Answer B = 5 points (Best):** This answer correctly applies the TOGAF ADM phases sequentially: Phase A (Architecture Vision) to align stakeholders, the Business Scenarios technique (Part III, Chapter 26) to capture complex requirements from multiple perspectives, Phases B-D for target architecture development, and the Architecture Requirements Specification to formalize constraints. The Business Scenarios technique is specifically designed for situations where there are complex, cross-functional requirements with multiple stakeholder perspectives—exactly this situation. This approach balances all stakeholder needs while maintaining architectural rigor.
- **Answer C = 3 points:** Using the Architecture Board to resolve disputes is a legitimate governance mechanism in TOGAF (Part VI). However, mandating a decision without first conducting proper stakeholder analysis and requirements gathering through the ADM is premature. Governance should ratify architecturally sound decisions, not bypass the architecture development process.
- **Answer D = 1 point:** Shows some pragmatism in prioritizing delivery, but the partial approach of only implementing Experience APIs without System and Process APIs would create technical debt. Allowing continued direct database access for internal applications undermines the architecture strategy and creates security risks in a regulated financial environment.
- **Answer A = 0 points:** This approach bypasses the architecture development process entirely. Exposing database views directly violates fundamental architecture principles around abstraction, loose coupling, and security. In a PSD2-regulated environment, this approach would likely fail compliance requirements and create unmaintainable technical debt.

### Scenario 3 - Question 3: Architecture Vision Development for Board
**Scoring:**
- **Answer B = 5 points (Best):** This answer correctly applies the TOGAF Architecture Vision deliverable structure and techniques. The Stakeholder Map analysis (Section 24.2) identifies Board-level concerns and tailors the communication. Business Scenarios (Chapter 26) illustrate concrete value from the patient's perspective—making the abstract integration concept tangible for non-technical Board members. Architecture Principles that balance innovation and patient safety address the fundamental tension in this initiative. A capability-based roadmap with Transition Architectures (Phase E/F concepts) provides a credible delivery plan while managing risk incrementally.
- **Answer C = 3 points:** Providing the Board with a structured vendor evaluation is a reasonable approach for executive decision-making and shows practical thinking. However, this pre-empts the architecture development process—the selection of a solution (buy vs. build) should be an output of Phase E (Opportunities and Solutions), not a starting point for the Architecture Vision (Phase A). This answer also oversimplifies the integration challenge.
- **Answer A = 1 point:** Recognizes the need for technical content in the Architecture Vision, but focusing exclusively on technical details for a Board presentation shows poor stakeholder management. The TOGAF Architecture Vision is specifically designed as a high-level, business-value-oriented document. Board members need to understand business value, risk, and feasibility—not component diagrams.
- **Answer D = 0 points:** Delaying six months directly contradicts the Board's mandate and the urgency of the initiative. TOGAF does not require exhaustive baseline documentation before creating an Architecture Vision. The Architecture Vision (Phase A) is explicitly a high-level document that precedes detailed current-state analysis (which occurs in Phases B-D).

### Scenario 4 - Question 4: Segment Architecture vs Capability Architecture
**Scoring:**
- **Answer B = 5 points (Best):** This answer demonstrates mastery of the TOGAF Architecture Landscape concept and the relationship between Strategic, Segment, and Capability Architectures. Strategic Architecture provides the enterprise-wide vision and shared capabilities. Segment Architectures address business-unit-specific needs (including unique regulatory requirements like nuclear safety). Capability Architecture defines cross-cutting capabilities that span segments, enabling reuse while allowing segment-specific extensions. The capability heat map prioritization is an excellent application of architecture-to-business alignment, focusing limited resources on the capabilities most critical to the strategic pivot. This hybrid approach directly addresses the resource constraint by focusing effort where it matters most.
- **Answer A = 3 points:** A purely segment-based approach is valid and addresses the legitimate concern about unique regulatory requirements. However, it misses the significant reuse opportunities across segments (Asset Performance Management, Energy Trading) and would require three times the effort for shared capabilities. With only eight architects, this approach would likely fail to deliver within six months.
- **Answer D = 1 point:** Acknowledges the resource constraint, which is a valid concern. However, outsourcing the entire architecture effort to consultants doesn't build internal capability and rarely succeeds for enterprise architecture, which requires deep organizational knowledge. TOGAF emphasizes building internal architecture capability.
- **Answer C = 0 points:** Ignoring the traditional power generation segment (which currently represents 80% of revenue) because it will eventually be phased out is strategically reckless. A 10-year transition means this segment will remain critical for most of the planning horizon. This answer also shows poor understanding of architecture's role in managing transitions.

### Scenario 5 - Question 5: Technology Standardization Conflicts
**Scoring:**
- **Answer B = 5 points (Best):** This answer demonstrates comprehensive understanding of the TOGAF Technology Reference Model (TRM), Standards Information Base, Architecture Compliance framework, and Transition Architecture concepts. The multi-level standards approach (mandatory/preferred/permitted) is realistic for a global organization with diverse requirements. The Architecture Compliance levels (Irrelevant, Consistent, Compliant, Conformant, Fully Conformant, Non-Conformant) are directly from TOGAF's compliance framework. The dispensation process acknowledges that legitimate regional variations exist while maintaining governance. Sequencing migrations by business value rather than mandating wholesale replacement demonstrates mature architecture thinking.
- **Answer C = 3 points:** Federation through API standardization is architecturally sound and addresses the most critical integration need. However, it only addresses the interface level without dealing with the underlying duplication, data inconsistency, and maintenance cost issues. This approach would not significantly reduce the 72% maintenance spend, which is the core business driver for standardization.
- **Answer D = 1 point:** Recognizes the need for comprehensive understanding before making decisions, which is a valid architecture principle. However, postponing the effort entirely is an overreaction—the Architecture Board can establish standards principles and high-level direction while detailed application inventory continues. TOGAF supports iterative refinement of architecture baselines.
- **Answer A = 0 points:** Mandating a single global standard with no exceptions ignores the legitimate requirements of diverse regions. This approach would likely face massive resistance (as described in the Asia-Pacific and Africa scenarios), fail to address genuine local requirements, and potentially damage business operations. TOGAF's governance model explicitly includes dispensation mechanisms for justified non-compliance.

### Scenario 6 - Question 6: Architecture Repository Implementation
**Scoring:**
- **Answer B = 5 points (Best):** This answer demonstrates practical application of the TOGAF Architecture Repository structure (six components: Architecture Metamodel, Architecture Capability, Architecture Landscape, Standards Information Base, Reference Library, Governance Log) while being pragmatic about implementation sequencing. Starting with the Architecture Landscape and Standards Information Base addresses the most immediate stakeholder needs (solution architects and project teams), demonstrating value within the six-month CIO deadline. The phased approach manages the resource constraint of no additional staff. Defining specific use cases for each stakeholder group ensures adoption by showing tangible value. The content governance process addresses the current problem of inconsistency.
- **Answer A = 3 points:** Shows complete knowledge of the six Architecture Repository components, which is technically correct. However, attempting to implement all six simultaneously within four months with existing staff is unrealistic and risks delivering nothing usable. The all-or-nothing approach increases the risk of the initiative being cancelled at the six-month review.
- **Answer C = 1 point:** Addresses the immediate problem of documentation fragmentation, which is valid. However, simply migrating existing documents into a tool doesn't create a structured repository—it creates a centralized document dump. Without the architectural classification, metamodel structure, and governance processes, the migrated content would quickly become as disorganized as the current state.
- **Answer D = 0 points:** An unstructured wiki with no governance processes would likely recreate the current problem of inconsistent, duplicated documentation. This approach abandons the architecture repository concept entirely and doesn't leverage the investment in the Sparx modeling tool. While reducing barriers to contribution sounds appealing, without quality control, the repository would quickly lose credibility.

### Scenario 7 - Question 7: Transition Architecture Sequencing
**Scoring:**
- **Answer B = 5 points (Best):** This is the most comprehensive and architecturally rigorous answer. It correctly applies TOGAF Phase E (Opportunities and Solutions) for identifying transition architectures and Phase F (Migration Planning) for detailed sequencing. The key insight is reassessing wave sequencing based on architectural dependencies rather than product grouping—this is a core TOGAF principle that implementation should follow architectural dependencies, not organizational boundaries. The concept of each transition being an independently stable plateau is fundamental to TOGAF's Transition Architecture guidance. Including rollback architectures, parallel-run reconciliation, regulatory touchpoints, and compliance gates before wave progression demonstrates mature architecture thinking. The ABB-to-SBB traceability concept (from TOGAF's building blocks guidance) ensures that the target design intent is preserved through each transition state.
- **Answer D = 3 points:** Starting with the smallest, highest-value segment as a pilot is reasonable risk management and aligns with the principle of proving the approach on a manageable scope. However, this ignores architectural dependencies—Wealth Management may have dependencies on retail banking systems that make it difficult to migrate independently. The sequencing decision should be driven by architecture analysis, not just business unit size.
- **Answer A = 1 point:** At least accepts the phased approach rather than big bang. However, accepting the program manager's wave sequence without architectural analysis is a significant risk. Product grouping may not align with architectural dependencies—for example, shared reference data or batch process chains may span product lines and require careful coordination.
- **Answer C = 0 points:** A "big bang" migration of a core banking system processing 2.3 million daily transactions across 15 million customers is catastrophically risky. This approach has historically been the most common cause of banking system migration failures. It contradicts TOGAF's guidance on transition architectures and risk management. Regulatory concerns alone would make this approach non-viable for a bank under enhanced supervision.

### Scenario 8 - Question 8: EA Team Skills Assessment
**Scoring:**
- **Answer B = 5 points (Best):** This answer directly applies the TOGAF Architecture Skills Framework (Part VII, Chapter 52), which defines seven skill categories (General Skills, Business Skills and Methods, Enterprise Architecture Skills, Program/Project Management Skills, IT General Knowledge Skills, Technical IT Skills, Legal Environment) and four proficiency levels (Background, Awareness, Knowledge, Expert). The approach of selecting candidates based on collective skill coverage rather than individual technical depth reflects the reality that EA teams need diverse skills. Aligning architects to ADM phases based on strengths (business analysts to Phase B, technologists to Phase D) demonstrates practical application of the framework. The rotation program builds cross-cutting skills over time, and mentoring pairs accelerate development through knowledge sharing.
- **Answer D = 3 points:** TOGAF certification training is a valid component of capability development, and using certification scores as an assessment mechanism has some merit. However, certification exam scores measure TOGAF methodology knowledge, not the full spectrum of enterprise architecture skills. This approach would likely favor candidates with strong memorization skills over those with practical business and architecture experience. It also doesn't address team composition or structure.
- **Answer C = 1 point:** External hiring would bring immediate capability, which is a valid consideration given the 6-month deadline. However, this completely ignores the 22 internal candidates who understand the organization's business context—a critical asset for enterprise architecture. TOGAF emphasizes that business domain knowledge is as important as architecture methodology knowledge. External architects without organizational context rarely deliver value quickly.
- **Answer A = 0 points:** Selecting based solely on technical skills fundamentally misunderstands enterprise architecture. TOGAF explicitly defines EA as spanning business, data, application, and technology domains. The Architecture Skills Framework places equal emphasis on business skills, general skills, and enterprise architecture skills alongside technical skills. A team of 15 pure technicians would be unable to engage with business stakeholders, develop business architecture (Phase B), or establish architecture governance.

---

## Score Card

| Scenario | Your Answer | Your Score | Max Score |
|----------|-------------|------------|-----------|
| 1        |             |            | 5         |
| 2        |             |            | 5         |
| 3        |             |            | 5         |
| 4        |             |            | 5         |
| 5        |             |            | 5         |
| 6        |             |            | 5         |
| 7        |             |            | 5         |
| 8        |             |            | 5         |
| **Total**|             |            | **40**    |

**Pass Mark: 24/40 (60%)**
