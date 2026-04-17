# TOGAF Part 2 Certified - Practice Test 18
**Time Allowed:** 90 minutes | **Questions:** 8 | **Pass Mark:** 60% (24/40)

---

## Scenario 1: Healthcare EA Program at MedAlliance Health System

MedAlliance Health System is a large integrated delivery network operating 12 hospitals, 85 outpatient clinics, and a health insurance plan covering 1.2 million members across the southeastern United States. The organization employs 35,000 people, including 4,500 physicians. The CEO has launched a strategic initiative called "Connected Health 2028" aimed at creating a seamless, digitally-enabled patient experience across all care settings — from telehealth consultations and remote patient monitoring to inpatient care and post-discharge follow-up.

The current IT landscape is fragmented: three different Electronic Health Record (EHR) systems are in use (inherited from past acquisitions), the health insurance plan runs on a separate claims administration platform, the patient portal is a standalone application with limited integration to the EHRs, and the telehealth platform was deployed as an emergency measure during a past crisis with no architectural oversight. There is no unified patient identity across systems, meaning a patient who visits a hospital and an outpatient clinic may have two separate medical records.

The Board has approved $150 million over five years and appointed a Chief Architect to establish an EA practice and guide the transformation. The Chief Medical Officer (CMO) is a strong advocate for the initiative but insists that clinical workflow efficiency must not be compromised during the transformation. The Chief Financial Officer (CFO) wants to see measurable ROI within 18 months. The CISO has raised concerns about the expanded attack surface that a connected digital health ecosystem would create, particularly given the sensitivity of Protected Health Information (PHI) and the organization's obligations under HIPAA.

### Question 1
As the Chief Architect beginning Phase A (Architecture Vision), what should be the PRIMARY focus of the Architecture Vision for the Connected Health 2028 initiative?

a) Develop a detailed technology roadmap for replacing all three EHR systems with a single platform within the first two years, as EHR consolidation is the foundation for all other Connected Health objectives

b) Create an Architecture Vision that articulates the target state of a connected health ecosystem, identifying the key capabilities required (unified patient identity, interoperable clinical data exchange, integrated care coordination, secure data sharing), mapping these to the strategic objectives of Connected Health 2028, identifying stakeholder concerns (clinical workflow continuity, ROI timeline, security/privacy), and defining the scope, constraints, and key architecture principles — using this to obtain stakeholder buy-in and secure the Statement of Architecture Work

c) Focus the Architecture Vision exclusively on the telehealth and remote monitoring capabilities, as these are the most visible digital health features and will demonstrate quick wins to the Board

d) Begin with a comprehensive security architecture assessment of all existing systems before defining any target state, as HIPAA compliance must be the first priority in any healthcare architecture initiative

---

## Scenario 2: Security Architecture Decisions at DigiPay Financial

DigiPay Financial is a fintech company that operates a digital payments platform processing $12 billion in annual transaction volume across 15 million active accounts. The company has grown rapidly through innovation but has struggled to keep pace with security requirements. A recent penetration test revealed critical vulnerabilities in the platform's authentication mechanisms, API security, and data encryption practices. The financial regulator has issued a formal remediation notice requiring DigiPay to address all critical findings within 12 months.

The enterprise architecture team is working through Phase C (Information Systems Architecture) and Phase D (Technology Architecture) concurrently to develop the security architecture. The CISO wants to implement a zero-trust security architecture, requiring all users, devices, and services to be continuously authenticated and authorized. The VP of Product, however, is concerned that additional security measures will increase friction in the user experience and reduce transaction conversion rates — every additional authentication step historically reduces conversion by 2-3%.

The development teams currently deploy code multiple times daily through a CI/CD pipeline with minimal security gates. The DevOps team leader argues that adding security reviews to the deployment pipeline will slow down their release velocity. The architecture team must design a security architecture that satisfies the regulator, the CISO's zero-trust vision, and the business's need for a frictionless user experience and rapid deployment velocity.

### Question 2
How should the Chief Architect approach the security architecture to balance regulatory compliance, security, user experience, and deployment velocity?

a) Implement the full zero-trust architecture exactly as the CISO envisions it, adding multi-factor authentication to every transaction and mandatory security reviews before every deployment, regardless of the impact on user experience or deployment velocity

b) Design a risk-based security architecture that applies TOGAF's Requirements Management to classify security requirements by risk level and business impact — implement zero-trust principles proportionally (stronger controls for high-value transactions, risk-adaptive authentication that adjusts friction based on transaction risk profiles), integrate security into the CI/CD pipeline through automated security testing (SAST, DAST, dependency scanning) rather than manual reviews to maintain deployment velocity, and use the Architecture Requirements Specification to document how each regulatory finding is addressed while explicitly managing the trade-offs between security and user experience as architecture decisions with stakeholder sign-off

c) Prioritize user experience above all other concerns by implementing only the minimum security changes required by the regulator, as customer retention and conversion rates drive revenue

d) Halt all feature development for 12 months and dedicate the entire engineering team to security remediation, as the regulatory deadline makes security the only priority

---

## Scenario 3: Privacy and Compliance Architecture at EuroData Analytics

EuroData Analytics is a data analytics company headquartered in Germany with operations across the EU, UK, and United States. The company collects and processes consumer behavioral data from 200 million profiles to provide targeted marketing analytics to its clients. The company is facing a complex regulatory landscape: GDPR in the EU, the UK Data Protection Act post-Brexit, CCPA/CPRA in California, and emerging data protection laws in other US states and international markets.

Currently, data privacy compliance is handled on a per-regulation, per-jurisdiction basis with separate technical implementations for each regulatory regime. This has resulted in fragmented privacy controls, inconsistent consent management, duplicated data processing infrastructure, and an inability to respond quickly when new regulations emerge. The legal team estimates that maintaining the current approach will require adding 15 new privacy engineers each year as new regulations are enacted globally.

The Chief Architect has been asked to develop a unified privacy and compliance architecture that can scale to accommodate current and future privacy regulations without requiring new technical implementations for each regulation. The architecture team is in Phase B (Business Architecture) and has identified that the core privacy operations (consent management, data subject rights fulfillment, data inventory, purpose limitation enforcement, data retention management) are fundamentally similar across all regulatory regimes, with variations in specific requirements such as consent mechanisms, retention periods, and data subject rights.

### Question 3
What architectural approach should the Chief Architect recommend during Phase B and Phase C?

a) Continue the current approach of building separate technical implementations for each regulation, as the legal differences between GDPR, CCPA, and other regulations are too significant to address with a unified architecture

b) Design a privacy reference architecture based on a configurable compliance framework — during Phase B, model the common privacy business processes (consent management, data subject rights, purpose limitation, retention management) as reusable business capabilities, then during Phase C, architect a modular data privacy platform where regulatory-specific rules are externalized as configuration rather than code, using TOGAF's Building Block concept to define reusable Architecture Building Blocks (ABBs) for each privacy capability that can be composed and configured for different jurisdictions, with the Architecture Definition Document capturing both the common architecture and the jurisdiction-specific configurations

c) Outsource all privacy compliance to a third-party privacy-as-a-service provider, removing the need for any internal privacy architecture work

d) Wait for global privacy regulations to converge into a single standard before building a unified architecture, as investing in a unified platform now risks it becoming obsolete when regulations change

---

## Scenario 4: Merger Architecture Integration at Consolidated Industrial Corp

Consolidated Industrial Corp (CIC) has just completed the acquisition of Praxis Engineering, a $2 billion industrial automation company. CIC itself is a $8 billion diversified industrial company with established enterprise architecture practices, a mature Architecture Repository, defined technology standards, and a functioning Architecture Review Board. Praxis Engineering has no formal EA practice, operates a separate IT organization with 180 applications, and uses a different technology stack (primarily Microsoft-based versus CIC's Java/Linux-based environment).

The Board expects full operational integration within 18 months to realize $200 million in projected synergies, primarily from IT consolidation, shared services, and unified supply chain operations. The Chief Architect has been tasked with developing the integration architecture. However, significant challenges have emerged: Praxis's CTO is resistant to adopting CIC's technology standards, viewing them as less capable than Praxis's Microsoft-based platform; key Praxis engineering applications have no equivalent in CIC's portfolio and must be preserved; and Praxis's customer-facing systems are generating $500 million in annual recurring revenue and cannot be disrupted during integration.

The architecture team needs to develop a pragmatic integration approach that achieves the synergy targets while managing the risks of integrating two fundamentally different technology environments. The integration PMO is pressing for a detailed integration architecture within 60 days.

### Question 4
What approach should the Chief Architect take to develop the integration architecture?

a) Mandate that Praxis Engineering migrate all 180 applications to CIC's technology standards within 18 months, as standardization is the fastest path to realizing IT consolidation synergies

b) Apply the ADM starting with Phase A to develop an Integration Architecture Vision that categorizes Praxis's applications into four groups: consolidate (replace with existing CIC applications), coexist (maintain Praxis applications with integration to CIC systems), modernize (re-platform to CIC standards over time), and retain as-is (unique applications with no CIC equivalent), using gap analysis between the two organizations' architectures to identify integration points and synergy opportunities, defining Transition Architectures that sequence the integration to protect revenue-generating systems while progressively realizing synergies, and establishing interim governance that accommodates both technology environments during the transition period

c) Keep both IT organizations and technology environments completely separate indefinitely and focus integration efforts only on financial reporting consolidation, as technology integration creates too much risk

d) Hire a systems integrator to manage the entire integration and remove the enterprise architecture team from the process, as merger integration is a project management discipline rather than an architecture discipline

---

## Scenario 5: Architecture Maturity Assessment at Beacon Telecommunications

Beacon Telecommunications is a national telecommunications provider that established an enterprise architecture practice four years ago. The CTO has asked the Chief Architect to conduct a formal assessment of the EA practice's maturity to identify areas for improvement and justify continued investment. The EA team has achieved some notable successes — they guided a $100 million network modernization, established technology standards that reduced platform diversity by 40%, and created an Architecture Repository that is actively used.

However, several weaknesses have been observed: the architecture team is perceived as technology-focused with limited business architecture capability; architecture governance is inconsistently applied, with some business units bypassing the Architecture Review Board; the Architecture Repository lacks current-state documentation for 60% of the application portfolio; architecture deliverables vary in quality and format between different architects; there is no formal process for measuring the business value delivered by EA; and stakeholder satisfaction surveys show that business executives rate the EA practice's relevance as "moderate" while IT stakeholders rate it highly.

The Board has indicated that without demonstrable improvement and a clear value proposition, the EA budget (currently $3.5 million annually) may be reduced by 50% in the next fiscal year. The Chief Architect needs to present a credible maturity assessment and improvement roadmap.

### Question 5
How should the Chief Architect approach the architecture maturity assessment and improvement planning?

a) Use an industry-recognized architecture maturity model (such as the TOGAF Architecture Maturity Model or ACMM) to conduct a structured assessment across key dimensions — architecture governance, architecture processes, architecture content/deliverables, business engagement, skills and resources, and value realization — identify the current maturity level for each dimension with supporting evidence, define a realistic target maturity level aligned with the organization's needs, then develop a phased improvement roadmap that prioritizes the dimensions with the greatest gap between current and target maturity, specifically addressing the business engagement and value measurement weaknesses to protect the EA budget

b) Present the successes achieved (network modernization, platform reduction) as evidence that the EA practice is already mature and does not need improvement, arguing that any budget reduction would jeopardize these gains

c) Focus the improvement effort entirely on increasing the Architecture Repository completeness from 40% to 100%, as a complete repository is the most tangible demonstration of EA maturity

d) Propose disbanding the centralized EA team and distributing architecture responsibilities to business unit IT teams, as the moderate business relevance rating suggests that a centralized model is not working

---

## Scenario 6: Capability-Based Planning at Orion Defense Systems

Orion Defense Systems is a major defense contractor that supplies advanced weapons systems, communications equipment, and cybersecurity solutions to military customers in five allied nations. The company has traditionally organized its architecture practice around technology domains and individual product lines. The CEO has directed the enterprise architecture team to adopt capability-based planning to better align the company's investment decisions with strategic priorities and to identify opportunities for cross-product-line synergy.

The company has 14 product lines, each with its own engineering team, technology stack, and customer relationships. There is significant duplication of capabilities across product lines — for example, six different product lines have independently built their own secure communications capabilities, and four have separate cyber threat analysis engines. This duplication increases development costs, creates inconsistent quality, and makes it difficult to present an integrated capability portfolio to customers.

The Chief Architect has been tasked with developing a capability map, conducting a capability assessment, and creating a capability-based investment plan. However, the product line leaders are territorial and resistant to sharing capabilities, fearing that consolidation will reduce their autonomy and budget. The VP of Engineering supports capability-based planning in principle but is concerned about the complexity of extracting shared capabilities from tightly-coupled product architectures.

### Question 6
How should the Chief Architect implement capability-based planning at Orion Defense Systems?

a) Mandate immediate consolidation of all duplicated capabilities into shared services, requiring all 14 product lines to adopt common implementations within one year regardless of the impact on current product deliveries

b) Implement capability-based planning using TOGAF's Business Architecture (Phase B) approach: first develop a comprehensive business capability map that catalogs all capabilities across the 14 product lines, conduct a capability assessment that evaluates each capability's maturity, strategic importance, and degree of duplication, then use this assessment to identify high-value consolidation opportunities where shared capability building blocks can replace duplicated implementations — prioritize consolidation based on strategic value and feasibility, develop Transition Architectures that allow progressive capability sharing starting with the least complex and highest-value opportunities, and establish a capability governance model that defines ownership, funding, and service levels for shared capabilities

c) Allow each product line to continue building capabilities independently and simply create a catalog that documents what exists, without any consolidation or rationalization effort

d) Select one product line's implementations as the company standard for all shared capabilities and require the other 13 product lines to adopt those implementations, as this minimizes the architecture design effort

---

## Scenario 7: Business Transformation Readiness at Global Express Logistics

Global Express Logistics is a $15 billion international logistics company that has announced a bold strategic transformation called "Logistics 4.0" — aiming to become a fully digital, AI-powered logistics platform within five years. The transformation includes autonomous warehouse operations, predictive supply chain optimization, real-time shipment visibility, and dynamic pricing. The Board has approved $500 million in transformation investment.

The Chief Architect has been engaged to assess the organization's readiness for this transformation and develop the architecture to support it. However, early assessment reveals significant readiness gaps: the current IT infrastructure is primarily on-premises with limited cloud adoption; the data architecture is fragmented with no enterprise data lake or analytics platform; the workforce has limited skills in AI/ML, cloud-native development, and data engineering; the organizational culture is risk-averse and process-oriented, not suited to the agile, experimental approach that AI-driven innovation requires; and the existing governance framework was designed for traditional IT projects and does not accommodate the iterative, experimental nature of AI/ML development.

The CEO expects the architecture team to produce a comprehensive transformation architecture within three months. The CTO is concerned that the three-month timeline is unrealistic given the readiness gaps and wants to propose a more measured, phased approach. Several business unit leaders are already piloting AI solutions independently with external vendors, creating a risk of fragmentation.

### Question 7
How should the Chief Architect approach the business transformation readiness assessment and architecture planning?

a) Produce the comprehensive transformation architecture within three months as the CEO expects, deferring all readiness concerns to the implementation phase since addressing them upfront would delay the architecture work unacceptably

b) Conduct a structured readiness assessment during Phase A that evaluates organizational readiness across key dimensions (technology infrastructure, data maturity, skills/capabilities, culture, governance), then develop an Architecture Vision that defines the Logistics 4.0 target state while explicitly identifying the readiness gaps as architecture requirements that must be addressed through the Transition Architectures — propose a phased transformation approach where early phases focus on foundational enablement (cloud platform, data architecture, skills development, governance adaptation) while later phases deliver the advanced capabilities (AI/ML, autonomous operations), presenting this to the CEO as a realistic plan that manages risk while maintaining ambitious targets and incorporating the independent AI pilots into the governed architecture framework

c) Recommend that Global Express Logistics delay the entire Logistics 4.0 initiative by two years until all readiness gaps have been resolved, as attempting transformation before the organization is ready will result in failure

d) Focus exclusively on the AI/ML capabilities since these are the most transformative elements of Logistics 4.0, and assume that cloud infrastructure, data architecture, and skills can be developed in parallel by other teams without architectural coordination

---

## Scenario 8: Managing Architecture Debt at Pinnacle E-Commerce

Pinnacle E-Commerce is a leading online retail platform that processes $8 billion in annual gross merchandise value. The platform was built rapidly over the past seven years, prioritizing time-to-market over architectural quality. An architecture assessment has revealed significant architecture debt: the monolithic application has grown to 4 million lines of code with extensive circular dependencies; the database has 2,800 tables with no clear domain boundaries; critical business logic is embedded in database stored procedures making it impossible to scale horizontally; the front-end is a tightly-coupled single-page application that requires full regression testing for any change; and there are no documented architecture decisions or design rationale.

The platform experiences regular performance issues during peak shopping periods, and the development team's velocity has dropped by 40% over the past two years as the codebase complexity has increased. The CTO has acknowledged the problem and allocated 20% of engineering capacity to addressing architecture debt. The Chief Architect has been asked to develop an architecture debt remediation strategy.

However, the business is growing 30% year-over-year, and the VP of Product has a backlog of 200 features requested by customers. The VP of Product is concerned that dedicating 20% of engineering capacity to architecture debt remediation will slow feature delivery and cost the company competitive advantage. The Head of Engineering supports the remediation effort but wants to ensure it delivers measurable improvement, not just theoretical architectural purity.

### Question 8
What approach should the Chief Architect take to manage the architecture debt remediation?

a) Use the full 20% engineering allocation to conduct a complete rewrite of the platform using a modern microservices architecture, as the current monolith is beyond remediation and only a clean-sheet approach can address the accumulated debt

b) Develop an architecture debt management strategy using the ADM: conduct a current-state architecture assessment to catalog and classify architecture debt items by severity (business impact, technical risk, cost of remediation), create a Target Architecture that defines the desired end state (e.g., modular domain-bounded services), then design Transition Architectures that address the highest-impact debt items first while delivering measurable improvements (performance, developer velocity, deployment frequency) — integrate debt remediation with feature delivery by identifying opportunities where feature work can simultaneously address debt (e.g., extracting a service during a feature rewrite), establish metrics to track debt reduction and its business impact, and present the strategy to the VP of Product as an investment that accelerates future feature delivery

c) Accept the architecture debt as a permanent condition and focus the 20% allocation on performance optimization only, using caching and hardware scaling to mask the underlying architectural problems

d) Declare an architecture freeze preventing any new feature development until all architecture debt is remediated, as continuing to add features to the existing architecture will only increase the debt

---

## Answer Key

### Scenario 1 - Question 1
**Scoring:**
- **Answer b) = 5 points (Best):** Phase A (Architecture Vision) should establish the holistic vision for the Connected Health 2028 initiative, identifying required capabilities, mapping to strategic objectives, and addressing stakeholder concerns. This is exactly what TOGAF's Architecture Vision deliverable is designed to do. By identifying key capabilities (unified patient identity, interoperable clinical data exchange) rather than jumping to technology solutions (EHR replacement), the Architecture Vision sets the strategic direction that will guide subsequent phases. Addressing stakeholder concerns (clinical workflow, ROI, security) within the vision ensures buy-in. The Statement of Architecture Work provides formal authorization to proceed.
- **Answer d) = 3 points (Second Best):** Security is a critical concern in healthcare architecture, and HIPAA compliance is a genuine constraint. Conducting a security assessment is important work that should happen during the architecture development. However, making it the sole focus of Phase A before defining the target state puts a constraint assessment before the vision, which inverts the proper sequence. Security requirements should be identified in Phase A and addressed comprehensively during Phases B-D.
- **Answer c) = 1 point (Third Best):** Focusing on telehealth and remote monitoring addresses visible digital health capabilities and could deliver quick wins. However, this approach takes a narrow scope that misses the foundational capabilities (unified patient identity, data interoperability) without which individual capabilities will remain siloed. The Architecture Vision should address the full scope of Connected Health 2028.
- **Answer a) = 0 points (Distractor):** Jumping to EHR consolidation as the Phase A focus confuses a technology solution with an Architecture Vision. EHR consolidation may or may not be the best approach — this is a decision for Phase C (Application Architecture), not Phase A. Starting with a technology decision before understanding the full scope of business capabilities needed puts the solution before the problem.

### Scenario 2 - Question 2
**Scoring:**
- **Answer b) = 5 points (Best):** This approach correctly applies TOGAF's Requirements Management process to classify and prioritize requirements by risk level and business impact. Risk-adaptive authentication (adjusting security friction based on transaction risk) directly addresses the trade-off between security and user experience. Integrating automated security testing into the CI/CD pipeline (DevSecOps) maintains deployment velocity while adding security assurance. Documenting how each regulatory finding is addressed in the Architecture Requirements Specification provides audit evidence. Managing trade-offs as explicit architecture decisions with stakeholder sign-off ensures transparency and accountability.
- **Answer c) = 3 points (Second Best):** Prioritizing user experience and implementing only minimum regulatory requirements is pragmatic and recognizes the business importance of conversion rates. However, implementing only the minimum creates a compliance-only posture that does not address the underlying security weaknesses, potentially leading to future breaches and more severe regulatory action. TOGAF's risk management approach supports a more balanced solution.
- **Answer d) = 1 point (Third Best):** Taking security seriously by halting feature development demonstrates commitment to remediation. However, a 12-month feature freeze for a rapidly growing fintech company could be existentially damaging from a competitive standpoint. TOGAF supports integrating remediation with ongoing development rather than treating it as an all-or-nothing activity.
- **Answer a) = 0 points (Distractor):** Implementing maximum security controls on every transaction without considering business impact ignores the well-established principle that security measures should be proportionate to risk. Multi-factor authentication on every transaction would devastate user experience and conversion rates. This approach does not apply risk-based thinking and would likely face such strong business resistance that it would never be implemented.

### Scenario 3 - Question 3
**Scoring:**
- **Answer b) = 5 points (Best):** This approach correctly applies TOGAF's Building Block concept to define reusable Architecture Building Blocks (ABBs) for privacy capabilities. Modeling common privacy processes during Phase B establishes the business foundation. The modular, configurable platform architecture in Phase C externalizes regulatory-specific rules as configuration, enabling scalability to new regulations without new code. This approach directly addresses the stated problem of unsustainable scaling (15 new engineers per regulation) by creating a platform that accommodates regulatory variation through configuration. The Architecture Definition Document captures both common and jurisdiction-specific elements.
- **Answer c) = 3 points (Second Best):** A third-party privacy-as-a-service provider could provide a pre-built, multi-jurisdiction compliance solution. However, outsourcing a core compliance function to a third party introduces vendor dependency, limits customization, and may not fully integrate with EuroData's data processing architecture. It partially addresses the problem but does not develop internal architectural capability.
- **Answer a) = 1 point (Third Best):** The current approach works and respects legal differences between regulations. However, the scenario explicitly states it is unsustainable — requiring 15 new engineers annually as regulations proliferate. Continuing this approach ignores the architectural opportunity to identify and leverage commonality across regulatory frameworks.
- **Answer d) = 0 points (Distractor):** Waiting for global regulatory convergence is unrealistic — privacy regulations are proliferating and diverging, not converging. This approach leaves the company with an unsustainable compliance model indefinitely and provides no path to improving the current situation. Enterprise architecture should address current challenges, not wait for external conditions to change.

### Scenario 4 - Question 4
**Scoring:**
- **Answer b) = 5 points (Best):** This approach applies the ADM systematically to the integration challenge. The four-category classification (consolidate, coexist, modernize, retain) is a practical application of gap analysis between the two organizations' architectures. Transition Architectures enable sequenced integration that protects revenue-generating systems while progressively realizing synergies. Interim governance that accommodates both technology environments during transition is pragmatic and reduces resistance. This approach directly addresses the 18-month synergy target while managing risks around revenue-generating systems and technology diversity.
- **Answer c) = 3 points (Second Best):** Maintaining separation reduces integration risk and protects revenue-generating systems. Financial reporting consolidation is a reasonable starting point. However, this approach fails to deliver the $200 million in IT consolidation and shared services synergies that the Board expects. It is too conservative given the strategic objectives, though it correctly identifies the need to protect operational stability.
- **Answer a) = 1 point (Third Best):** Full migration to CIC's standards would deliver maximum standardization but ignores the practical constraints: Praxis's unique engineering applications have no CIC equivalent, revenue-generating customer systems cannot be disrupted, and the CTO's resistance will create organizational friction. An 18-month timeline for migrating 180 applications across technology stacks is unrealistic and dangerous.
- **Answer d) = 0 points (Distractor):** Merger technology integration is fundamentally an architecture discipline — it requires understanding the architectures of both organizations, identifying integration patterns, and designing the target integrated architecture. Removing the EA team from this process would leave the integration without architectural coherence.

### Scenario 5 - Question 5
**Scoring:**
- **Answer a) = 5 points (Best):** Using a recognized architecture maturity model provides a structured, credible assessment framework. Assessing across multiple dimensions identifies specific strengths and weaknesses. Defining target maturity levels aligned with organizational needs ensures the improvement plan is proportionate. Prioritizing based on the gap between current and target maturity focuses effort where it matters most. Specifically addressing business engagement and value measurement directly responds to the threats to the EA budget. This approach gives the Board a credible, evidence-based improvement plan.
- **Answer b) = 3 points (Second Best):** Highlighting past successes is a valid communication strategy and provides evidence of EA value. However, presenting the practice as already mature when clear weaknesses exist (inconsistent governance, incomplete repository, low business engagement scores) lacks credibility. The Board has already indicated dissatisfaction, so a defensive posture is unlikely to protect the budget.
- **Answer c) = 1 point (Third Best):** Repository completeness is measurable and tangible, making it a reasonable improvement target. However, it addresses only one dimension of maturity while ignoring the more critical weaknesses — particularly business engagement and value measurement, which directly affect the Board's funding decision. A 100% complete repository that business stakeholders don't value won't save the budget.
- **Answer d) = 0 points (Distractor):** Disbanding the centralized EA team in response to a moderate business relevance rating is an overreaction. The assessment should determine why business engagement is moderate and develop targeted improvements, not eliminate the function entirely. TOGAF supports various organizational models for EA, and the assessment may reveal that a different centralized approach (more business-engaged) is the solution.

### Scenario 6 - Question 6
**Scoring:**
- **Answer b) = 5 points (Best):** This approach correctly applies TOGAF's Business Architecture (Phase B) through capability mapping and assessment, which is the foundation for capability-based planning. The systematic process — mapping capabilities, assessing maturity and duplication, prioritizing consolidation based on strategic value and feasibility — follows TOGAF's guidance on business transformation readiness and capability assessment. Transition Architectures enable progressive consolidation starting with low-complexity, high-value opportunities, which builds confidence and demonstrates value before tackling more complex consolidations. A capability governance model with defined ownership and service levels addresses the product line leaders' concerns about quality and reliability.
- **Answer c) = 3 points (Second Best):** Creating a capability catalog is a necessary first step and provides valuable visibility into duplication. However, stopping at documentation without any rationalization effort fails to deliver the synergies and cost reductions the CEO is seeking. Cataloging without action is a partial solution that addresses awareness but not outcomes.
- **Answer d) = 1 point (Third Best):** Selecting one product line's implementations minimizes design effort but risks choosing suboptimal implementations and generates maximum resistance from 13 product lines. The selected implementations may not meet the requirements of other product lines' contexts. This approach also ignores the capability assessment step that would identify which implementations are actually the best.
- **Answer a) = 0 points (Distractor):** Mandating immediate consolidation of all capabilities within one year ignores the complexity of extracting shared capabilities from tightly-coupled product architectures. This approach would disrupt current product deliveries, generate massive resistance from product line leaders, and is likely technically infeasible within the timeline. TOGAF's Transition Architecture concept exists precisely to avoid this kind of big-bang approach.

### Scenario 7 - Question 7
**Scoring:**
- **Answer b) = 5 points (Best):** This approach correctly uses Phase A to assess organizational readiness as a key input to the Architecture Vision. TOGAF supports readiness assessment as part of understanding the organization's ability to execute the transformation. Identifying readiness gaps as architecture requirements ensures they are addressed through the architecture work rather than deferred to implementation. Phased Transition Architectures that build foundational capabilities before advanced ones is sound architectural sequencing. Incorporating independent AI pilots into the governed framework addresses the fragmentation risk. Presenting a realistic plan to the CEO maintains ambition while managing expectations.
- **Answer a) = 3 points (Second Best):** Meeting the CEO's three-month timeline demonstrates responsiveness to executive direction. However, producing a comprehensive transformation architecture without addressing fundamental readiness gaps (cloud infrastructure, data architecture, skills, governance) creates a plan that cannot be executed. TOGAF's Phase A guidance specifically includes assessing the organization's readiness to undertake the architecture transformation.
- **Answer c) = 1 point (Third Best):** Recognizing readiness gaps is valid, but recommending a two-year delay is overly conservative and does not align with the Board's strategic direction. The readiness gaps should be addressed as part of the transformation, not as a prerequisite to starting it. TOGAF supports addressing readiness through Transition Architectures rather than delaying the entire initiative.
- **Answer d) = 0 points (Distractor):** Focusing exclusively on AI/ML capabilities without addressing foundational architecture (cloud, data, skills) is building a house starting from the roof. AI/ML capabilities depend on having proper data architecture, cloud infrastructure, and skilled resources. Assuming these can be developed independently without coordination ignores the fundamental interdependencies that enterprise architecture exists to manage.

### Scenario 8 - Question 8
**Scoring:**
- **Answer b) = 5 points (Best):** This approach applies the ADM systematically to the debt remediation challenge. Cataloging and classifying debt by severity enables prioritization. The Target Architecture defines the desired end state, while Transition Architectures address the highest-impact items first. The key insight is integrating debt remediation with feature delivery — identifying opportunities where feature work simultaneously reduces debt. This "boy scout rule" approach delivers business value while progressively improving the architecture. Establishing metrics for debt reduction and its business impact directly addresses the Head of Engineering's requirement for measurable improvement and provides evidence to the VP of Product that the investment accelerates future delivery.
- **Answer c) = 3 points (Second Best):** Performance optimization addresses the most visible symptom (peak period issues) and can be achieved through caching and scaling without deep architectural changes. However, this treats the symptoms rather than the disease — the underlying circular dependencies, monolithic structure, and database coupling will continue to reduce developer velocity and increase fragility. This is a tactical response, not an architectural solution.
- **Answer a) = 1 point (Third Best):** A complete rewrite using microservices is architecturally appealing but historically risky. Rewriting a 4-million-line-of-code platform while the business grows 30% annually is a massive undertaking that frequently fails. The 20% allocation is insufficient for a complete rewrite, and this approach provides no incremental value during the rewrite period.
- **Answer d) = 0 points (Distractor):** An architecture freeze that halts all feature development for a company growing 30% annually would be commercially devastating. Competitors would capture the market opportunity while Pinnacle stagnates. This approach also ignores the possibility of integrating debt remediation with feature delivery.

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
