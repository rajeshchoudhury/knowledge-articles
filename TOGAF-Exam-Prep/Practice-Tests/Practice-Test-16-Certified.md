# TOGAF Part 2 Certified - Practice Test 16
**Time Allowed:** 90 minutes | **Questions:** 8 | **Pass Mark:** 60% (24/40)

---

## Scenario 1: Enterprise Digital Transformation at Meridian Insurance Group

Meridian Insurance Group is a large multinational insurance company with operations in 14 countries, employing over 25,000 staff. The company has embarked on a major digital transformation initiative branded "Meridian 2030" aimed at completely reimagining its customer experience, operational efficiency, and product innovation capabilities. The CEO has secured a $200 million budget over five years and appointed a Chief Digital Officer (CDO) to lead the initiative.

The enterprise currently operates over 350 applications, many of which are legacy mainframe systems developed over the past 30 years. These systems handle core insurance functions including policy administration, claims processing, underwriting, and actuarial calculations. The existing enterprise architecture team, consisting of four architects, has historically focused on technology infrastructure and has limited engagement with the business side. There is no formal Architecture Repository or governance framework in place.

The CDO wants to use TOGAF to establish a proper Enterprise Architecture practice to guide the transformation. However, the business unit leaders are skeptical about EA, viewing it as bureaucratic overhead that will slow down delivery. The CTO supports the initiative but is concerned about the time needed to establish a mature EA practice before the transformation can begin delivering value. Several business units have already started their own digital initiatives independently, creating a risk of fragmented solutions.

### Question 1
As the newly appointed Chief Architect, what should be your FIRST priority in establishing the EA practice to support the Meridian 2030 transformation?

a) Develop a comprehensive Architecture Repository with all reference models, standards catalogs, and governance procedures before engaging with any business units on their transformation projects

b) Create an Architecture Vision (Phase A) for the overall Meridian 2030 program, using it to gain stakeholder buy-in and establish the value proposition of EA while concurrently defining lightweight governance for the already-started initiatives

c) Conduct a detailed current-state assessment of all 350 applications to create a complete baseline architecture across all four architecture domains before any transformation work proceeds

d) Immediately establish a formal Architecture Review Board with representatives from all 14 countries and mandate that all existing digital initiatives halt until they receive formal architecture approval

---

## Scenario 2: Legacy Modernization at Continental Railways

Continental Railways is a national rail operator that runs 2,500 daily train services across a network of 450 stations. The company's core operations are managed by a suite of legacy systems developed in COBOL on IBM mainframes in the late 1980s and early 1990s. These systems handle train scheduling, ticketing, crew rostering, maintenance planning, and revenue management. The systems are reliable but inflexible — even minor changes to fare structures require months of development effort.

The company has hired an enterprise architecture team to plan the modernization of these legacy systems. The Board has approved a seven-year modernization roadmap with an annual budget of $45 million. A critical constraint is that the railway must continue operating without disruption throughout the modernization — even a few hours of system downtime would affect millions of passengers and violate regulatory requirements.

During the Preliminary Phase and Architecture Vision work, the architecture team has identified significant interdependencies between the legacy systems. The ticketing system directly calls the scheduling system, which in turn is tightly coupled with crew rostering. The maintenance planning system shares database tables with the scheduling system. The revenue management system extracts data directly from the ticketing database using batch jobs.

The CIO has asked the Chief Architect to recommend a modernization approach that will allow incremental delivery of new capabilities while managing risk. Several vendors have proposed different approaches: a complete "big bang" replacement with a modern integrated suite, a strangler fig pattern approach, and a full API-layer encapsulation of existing systems.

### Question 2
Which approach should the Chief Architect recommend during Phase E (Opportunities and Solutions) to best address Continental Railways' modernization needs while managing risk?

a) Recommend the big bang replacement with the modern integrated suite, as this eliminates all legacy technical debt in a single program and ensures a clean, modern architecture from day one

b) Recommend the strangler fig pattern, implementing new capabilities in modern technology while gradually migrating functionality away from legacy systems, using the Transition Architectures concept from Phase E to define intermediate stable states that maintain operational continuity

c) Recommend keeping all legacy systems in place indefinitely and only building an API layer on top, as this eliminates all modernization risk and provides a modern interface to legacy functionality

d) Recommend outsourcing all legacy systems to a third-party managed service provider and focusing the architecture team exclusively on building new digital capabilities on cloud platforms

---

## Scenario 3: Cloud Migration Strategy at Novus Pharmaceuticals

Novus Pharmaceuticals is a mid-size pharmaceutical company with 8,000 employees, operating primarily in North America and Europe. The company maintains two on-premises data centers that host approximately 180 applications supporting drug research, clinical trials management, manufacturing execution, supply chain operations, regulatory submissions, and corporate functions. The data centers are aging and will require $60 million in infrastructure refresh over the next three years.

The CFO has proposed migrating to cloud as a cost-saving measure, and the Board has approved a "Cloud First" strategy. The enterprise architecture team has been tasked with developing the cloud migration architecture. However, significant challenges have emerged: the regulatory affairs team insists that clinical trial data and drug safety databases must remain on-premises due to FDA and EMA regulations; the research division wants the flexibility to use multiple cloud providers for high-performance computing workloads; the manufacturing team is concerned about latency if their manufacturing execution systems move to the cloud; and the CISO has flagged concerns about data sovereignty given the company's European operations and GDPR requirements.

The architecture team has completed Phase B (Business Architecture) and is now working through Phase C (Information Systems Architecture). They need to define the Target Architecture for data and application placement across on-premises and cloud environments. The Head of IT Operations wants a single cloud provider to simplify management, while the research division insists on multi-cloud flexibility.

### Question 3
What is the BEST approach for the architecture team to address the conflicting stakeholder requirements during Phase C?

a) Default to the CFO's cost-saving objective and recommend migrating all applications to a single cloud provider, noting that regulatory and latency concerns can be addressed later during implementation

b) Conduct a stakeholder analysis to understand each group's concerns and priorities, then use the Architecture Requirements Management process to document and categorize requirements as mandatory constraints versus preferences, developing a hybrid cloud Target Architecture that addresses regulatory constraints, data sovereignty obligations, and latency requirements as non-negotiable while treating the single-vs-multi-cloud decision as a trade-off to be resolved through Architecture Definition Document options

c) Escalate all conflicting requirements to the Architecture Review Board and ask them to make a definitive ruling on cloud strategy before proceeding with any architecture development work

d) Accept all stakeholder requirements at face value without prioritization and design a Target Architecture that satisfies every requirement, regardless of cost or complexity implications

---

## Scenario 4: Stakeholder Conflict Resolution at GlobalBank

GlobalBank is a major commercial bank undergoing a regulatory-driven transformation to separate its retail and investment banking operations into distinct legal entities. The separation must be completed within 24 months as mandated by the financial regulator. The enterprise architecture team has been engaged to plan the technology separation, which involves duplicating or partitioning approximately 200 shared technology platforms and data stores.

During Phase B (Business Architecture), a critical conflict has emerged between two powerful stakeholder groups. The Retail Banking division's CEO wants a complete technology separation to achieve full independence and the ability to pursue its own technology strategy. The Group CTO, however, advocates for a shared services model where both entities continue to use common technology platforms (with logical separation) to minimize cost and maintain economies of scale. The regulator requires "operational independence" but has not specified whether this requires physical or logical technology separation.

The Chief Architect has attempted to mediate between the two positions but has been unable to reach consensus. The Retail Banking CEO has gone directly to the Board, and the Group CTO has threatened to withdraw IT resources from the project if his approach is not adopted. Meanwhile, the 24-month regulatory deadline continues to tick, and the architecture team is unable to finalize the Business Architecture without resolving this fundamental question.

### Question 4
What is the BEST course of action for the Chief Architect to resolve this impasse and keep the architecture engagement on track?

a) Side with the Group CTO's shared services approach because it minimizes cost and complexity, and present this as the architecture team's recommendation without further stakeholder consultation

b) Develop two alternative Target Architecture scenarios — one for full separation and one for shared services — with an objective analysis of each against the regulatory requirements, cost implications, operational risk, and time-to-deliver, then present both options to the Architecture Board (or equivalent governance body) with the architecture team's recommendation, allowing the governance body to make an informed decision

c) Halt all architecture work until the Board of Directors resolves the conflict between the Retail Banking CEO and the Group CTO, as the architecture team should not be making business strategy decisions

d) Escalate to the financial regulator to request a specific ruling on whether physical or logical separation is required, and delay all architecture work until the regulator responds

---

## Scenario 5: Architecture Governance Challenges at Apex Technology Solutions

Apex Technology Solutions is a fast-growing technology company that has expanded from 500 to 5,000 employees over five years through a combination of organic growth and acquisitions. The company now has offices in 8 countries and runs over 200 applications on a mix of on-premises, private cloud, and multiple public cloud platforms. An enterprise architecture practice was established two years ago, and a formal Architecture Governance framework was put in place including an Architecture Review Board (ARB) that meets monthly.

However, the governance framework is struggling. Product teams complain that the ARB process is too slow — a typical architecture review takes four to six weeks, which conflicts with their two-week sprint cycles. Several teams have started bypassing the ARB entirely, building solutions without architecture approval. The ARB members, who are all senior architects, are overwhelmed with review requests and have a backlog of 35 pending reviews. Additionally, three recent acquisitions brought in their own technology stacks and development practices, and there is no clear process for integrating these into the existing architecture framework.

The CTO has asked the Chief Architect to reform the governance framework to make it fit-for-purpose in a fast-moving, agile environment while still maintaining appropriate architectural oversight. Some product team leaders have suggested eliminating the ARB entirely and replacing it with a "self-service" architecture model where teams make their own decisions.

### Question 5
How should the Chief Architect reform the Architecture Governance framework to balance speed with appropriate oversight?

a) Eliminate the ARB entirely and adopt the self-service model suggested by product teams, trusting that teams will make good architectural decisions if provided with architecture principles and guidelines

b) Implement a tiered governance model: define categories of architectural decisions (e.g., high impact, medium impact, low impact) with different governance processes for each — lightweight self-service reviews with guardrails for low-impact decisions, delegated architect approval for medium-impact decisions, and full ARB review reserved only for high-impact, cross-cutting architectural decisions — while also establishing Architecture Compliance reviews as part of project milestones rather than gating sprint cycles

c) Maintain the current monthly ARB process but add more architects to the board to increase review capacity and reduce the backlog, while issuing a mandate that all teams must submit to architecture review before starting development

d) Replace the ARB with automated architecture checks in the CI/CD pipeline that enforce technical standards, removing the need for any human architecture review process

---

## Scenario 6: ADM Adaptation for Agile Delivery at Pinnacle Retail

Pinnacle Retail is one of the largest omni-channel retailers in Europe, operating 1,200 physical stores and a digital commerce platform that generates $4 billion in annual online revenue. The company transitioned to agile delivery practices three years ago, organizing into 45 product teams working in two-week sprints. However, enterprise architecture has continued to operate using a traditional, sequential application of the ADM, with each phase producing comprehensive documentation before moving to the next.

This disconnect has created serious friction. Product teams view the architecture team as an impediment because architecture runway work takes months while they need decisions in days. The architecture team, in turn, is frustrated that product teams are making technology decisions without architectural guidance, resulting in inconsistent technology choices, duplicated capabilities, and growing technical debt. The VP of Engineering has given the Chief Architect an ultimatum: either make the architecture practice relevant to the agile teams within six months, or the EA function will be disbanded and architecture responsibilities distributed to the product teams.

The architecture team consists of 12 architects with deep TOGAF knowledge and extensive experience in traditional EA. However, most have limited experience with agile practices. The Chief Architect needs to transform how the team applies TOGAF to be effective in an agile context while preserving the strategic value that enterprise architecture provides.

### Question 6
How should the Chief Architect adapt the ADM to work effectively with Pinnacle Retail's agile delivery model?

a) Abandon TOGAF entirely and adopt the Scaled Agile Framework (SAFe) as the sole governance model for architecture, as TOGAF is incompatible with agile delivery practices

b) Adapt the ADM by operating at multiple speeds: use the full ADM cycle at the enterprise/strategic level for long-range architecture planning (operating on a quarterly cadence aligned with PI Planning), while embedding architects in product teams to provide just-in-time architectural guidance during sprints, leveraging the ADM's iterative nature and the concept of architecture partitioning to separate strategic concerns from solution-level concerns, and producing lightweight Architecture Definition Documents focused on decisions and principles rather than comprehensive documentation

c) Continue operating the ADM sequentially but mandate that product teams reserve 30% of each sprint for architecture compliance work to ensure alignment with the enterprise architecture

d) Split the architecture team into two groups: one that continues traditional ADM execution for enterprise architecture, and another that joins product teams full-time as developers, abandoning their architecture role entirely

---

## Scenario 7: Cross-Organizational Architecture Alignment at United Health Alliance

United Health Alliance (UHA) is a consortium of five independent hospital systems that have formed a strategic alliance to share clinical data, coordinate patient referrals, standardize care protocols, and jointly procure technology. Each hospital system has its own IT department, technology stack, and varying levels of enterprise architecture maturity. Two of the five systems have mature EA practices using TOGAF, one uses Zachman, and two have no formal EA practice.

The alliance has appointed a shared Chief Architect to develop a federated enterprise architecture that enables interoperability and data sharing while respecting the autonomy of each member organization. The immediate priority is establishing a unified patient record that can be accessed across all five systems. However, the hospital systems use three different Electronic Health Record (EHR) platforms, two different patient identification schemes, and have incompatible data classification standards.

During the Architecture Vision phase, significant resistance has emerged from two hospital systems that fear the federated architecture will eventually lead to loss of their technology autonomy. They are concerned that architecture standards set at the alliance level will force them to replace their existing systems. The Chief Architect needs to establish an architecture approach that achieves the alliance's interoperability goals while maintaining the trust and participation of all five member organizations.

### Question 7
What is the BEST approach for the Chief Architect to establish a federated architecture for the United Health Alliance?

a) Mandate that all five hospital systems adopt a single EHR platform, a single patient identification scheme, and unified data standards, as this is the only way to achieve true interoperability and a unified patient record

b) Develop an Architecture Vision that establishes a federated architecture model with clearly defined shared architecture principles, an interoperability reference architecture based on industry standards (such as HL7 FHIR), and a governance structure that distinguishes between alliance-level standards (mandatory for interoperability) and organization-level decisions (autonomous), using the TOGAF Architecture Landscape concept with a Strategic Architecture for alliance concerns and Segment Architectures for each hospital system's domain

c) Allow each hospital system to continue operating independently and connect them through point-to-point interfaces developed on an ad hoc basis whenever a specific data sharing need arises

d) Recommend that the alliance hire a systems integrator to build a centralized data warehouse that extracts data from all five systems nightly, providing a unified view without requiring any changes to the individual hospital systems' architectures

---

## Scenario 8: Architecture Compliance Dispute at TechForward Inc.

TechForward Inc. is a software company with 3,000 employees that develops enterprise SaaS products. The company has a well-established enterprise architecture practice with defined technology standards, architecture principles, and a formal Architecture Compliance Review process. The architecture team recently completed a Target Architecture that specifies a microservices-based architecture using Kubernetes, with all new services to be developed in Go or Java, using PostgreSQL for relational data and Apache Kafka for event streaming.

A high-profile product team, led by a respected VP of Engineering, has just completed development of a critical new product feature using Python with a MongoDB database, deployed on serverless infrastructure (AWS Lambda). The product was developed under aggressive time pressure from the CEO, who promised a key customer the feature within three months. The team argues that their technology choices were necessary to meet the timeline and that the feature is performing well in production.

During the Architecture Compliance Review, the architecture team has flagged the product as non-compliant with five technology standards. The VP of Engineering has pushed back forcefully, arguing that the standards are too rigid, that the feature is generating significant revenue, and that forcing a rewrite would waste months of effort and jeopardize the customer relationship. The Chief Architect must resolve this dispute while maintaining the credibility of the architecture governance process.

### Question 8
How should the Chief Architect handle this architecture compliance dispute?

a) Waive the compliance findings entirely since the feature is already in production and generating revenue, setting a precedent that business outcomes override architecture standards

b) Conduct a formal Architecture Compliance assessment that documents the specific deviations, evaluates the actual risks and impacts of each deviation (security, maintainability, operational complexity, skills availability), then work with the product team to develop a remediation roadmap that addresses the highest-risk deviations over a realistic timeline while granting a time-limited dispensation for lower-risk deviations — simultaneously initiating a review of the architecture standards to determine if they should be updated to accommodate legitimate use cases for the technologies chosen

c) Mandate an immediate rewrite of the entire feature using the approved technology stack, regardless of the business impact, to enforce architecture standards and send a clear message that non-compliance will not be tolerated

d) Remove the product team's VP of Engineering from his role for deliberately bypassing the architecture governance process, as governance violations should have personal consequences to deter future non-compliance

---

## Answer Key

### Scenario 1 - Question 1
**Scoring:**
- **Answer b) = 5 points (Best):** Creating an Architecture Vision (Phase A) is the correct starting point per the ADM. This approach directly addresses the skepticism by demonstrating EA value through the transformation initiative itself, rather than building a comprehensive but unused architecture practice in isolation. Phase A produces the Architecture Vision deliverable that articulates value and gains stakeholder buy-in. Concurrently addressing the already-started initiatives with lightweight governance prevents further fragmentation without being heavy-handed. This aligns with TOGAF's guidance on tailoring the ADM and the principle that EA should deliver value iteratively.
- **Answer c) = 3 points (Second Best):** Understanding the current state is important and is part of ADM Phase B-D baseline architecture work. However, attempting to catalog all 350 applications before any strategic engagement is excessive and delays value delivery. TOGAF supports baseline work at the appropriate scope, not necessarily a complete inventory before starting.
- **Answer a) = 1 point (Third Best):** An Architecture Repository is an important component of an EA practice and is addressed in the Preliminary Phase. However, building a comprehensive repository before engaging with business units is an ivory tower approach that will reinforce the business units' view that EA is bureaucratic overhead. TOGAF's Preliminary Phase guidance includes establishing the Architecture Repository, but in proportion to the organization's readiness.
- **Answer d) = 0 points (Distractor):** Halting already-started initiatives and mandating a 14-country governance board as a first step would be politically damaging, impractical, and would confirm the worst fears of stakeholders who see EA as bureaucratic overhead. This approach ignores TOGAF's emphasis on stakeholder management and tailoring governance to the organization's context.

### Scenario 2 - Question 2
**Scoring:**
- **Answer b) = 5 points (Best):** The strangler fig pattern aligns perfectly with TOGAF Phase E (Opportunities and Solutions), which explicitly addresses Transition Architectures — intermediate, stable architectural states between the baseline and target. This approach manages risk by maintaining operational continuity while incrementally delivering modern capabilities. TOGAF's guidance on migration planning and the creation of Implementation and Migration Plans supports this incremental approach. The tight coupling identified between legacy systems makes a big bang approach extremely risky.
- **Answer c) = 3 points (Second Best):** An API layer approach has merit as it provides a modern interface to legacy functionality and can serve as a first step. However, keeping all legacy systems indefinitely fails to address the core modernization objectives and the inflexibility problem. This could be part of a transition architecture but should not be the end state.
- **Answer a) = 1 point (Third Best):** A big bang replacement addresses the technical debt but introduces unacceptable operational risk for a railway operator that cannot tolerate downtime. TOGAF's risk management guidance and the emphasis on Transition Architectures exist precisely to avoid this kind of all-or-nothing approach.
- **Answer d) = 0 points (Distractor):** Outsourcing legacy systems does not constitute a modernization strategy — it transfers operational responsibility without addressing the underlying architectural problems of tight coupling and inflexibility. This also introduces significant risk around service continuity and vendor dependency.

### Scenario 3 - Question 3
**Scoring:**
- **Answer b) = 5 points (Best):** This approach correctly applies TOGAF's Architecture Requirements Management process, which runs continuously throughout the ADM and is responsible for managing, classifying, and prioritizing requirements. Distinguishing between mandatory constraints (regulatory, data sovereignty) and preferences (single vs. multi-cloud) is essential for resolving conflicting requirements. Developing a hybrid cloud architecture that addresses hard constraints while treating other decisions as trade-offs follows TOGAF's guidance on producing alternative architectures and using the Architecture Definition Document to document options and rationale.
- **Answer c) = 3 points (Second Best):** Escalating to the ARB is a legitimate governance mechanism, but it should come with analysis and recommendations rather than simply asking the ARB to decide. The architecture team should do the analytical work of requirements categorization and options analysis before presenting to the governance body.
- **Answer d) = 1 point (Third Best):** Accepting all requirements shows respect for stakeholders but fails to apply architectural judgment. The role of the architect is to analyze, prioritize, and identify trade-offs, not to blindly accommodate every request. An architecture that satisfies every requirement without prioritization may be technically infeasible or prohibitively expensive.
- **Answer a) = 0 points (Distractor):** Defaulting to a single stakeholder's cost objective while dismissing regulatory and latency concerns violates TOGAF's stakeholder management principles. Regulatory and latency requirements are hard constraints that cannot be "addressed later." This approach would likely result in regulatory violations and operational failures.

### Scenario 4 - Question 4
**Scoring:**
- **Answer b) = 5 points (Best):** This approach directly applies TOGAF's concept of developing alternative Target Architectures and presenting them through the governance process. Phase B (Business Architecture) supports the creation of architecture options. Providing objective analysis against multiple criteria (regulatory, cost, risk, time) enables informed decision-making. Using the Architecture Board as the governance body for resolving strategic architectural disputes is exactly its intended purpose. The Chief Architect provides analysis and recommendations but appropriately defers the strategic business decision to the governance body.
- **Answer d) = 3 points (Second Best):** Seeking regulatory clarity is a reasonable step that could help resolve the dispute with authoritative input. However, waiting for a regulatory response (which could take months) while halting all work is impractical given the 24-month deadline. Regulatory clarification should be pursued in parallel with architecture development, not as a blocking dependency.
- **Answer c) = 1 point (Third Best):** While it is true that the architecture team should not make strategic business decisions unilaterally, completely halting work is an abdication of the Chief Architect's responsibility. The architect's role includes facilitating decision-making by providing analysis and options, not simply waiting for decisions to be made by others.
- **Answer a) = 0 points (Distractor):** Siding with one stakeholder without proper analysis and governance undermines the Chief Architect's credibility and objectivity. This approach ignores TOGAF's emphasis on balanced stakeholder management and could result in a suboptimal architecture that fails to meet regulatory requirements.

### Scenario 5 - Question 5
**Scoring:**
- **Answer b) = 5 points (Best):** A tiered governance model directly addresses the root cause of the problem — the current one-size-fits-all approach applies the same heavyweight process to all decisions. TOGAF's Architecture Governance framework supports tailoring governance processes to the significance and impact of architectural decisions. The concept of Architecture Compliance reviews at project milestones (rather than gating individual sprints) aligns with TOGAF's guidance on compliance reviews. This approach preserves oversight for high-impact decisions while enabling speed for routine decisions.
- **Answer d) = 3 points (Second Best):** Automating standards enforcement through CI/CD pipelines is a valuable tactical measure that can address technology standards compliance. However, it cannot replace human architectural judgment for complex decisions about system design, integration patterns, and strategic technology direction. This should be a complement to, not a replacement for, architecture governance.
- **Answer a) = 1 point (Third Best):** While providing principles and guidelines is part of the solution, completely eliminating governance oversight removes the mechanism for ensuring cross-cutting concerns, strategic alignment, and architectural coherence. TOGAF emphasizes that governance is essential for managing architecture across the enterprise.
- **Answer c) = 0 points (Distractor):** Adding more capacity to a broken process does not fix the process. The fundamental problem is that the governance model is not suited to agile delivery, and adding more architects while mandating compliance will only increase the friction. This approach ignores the need to adapt governance to the organization's operating model.

### Scenario 6 - Question 6
**Scoring:**
- **Answer b) = 5 points (Best):** This approach leverages TOGAF's built-in support for iteration and adaptation. The ADM is explicitly designed to be iterative, and TOGAF provides guidance on Architecture Partitioning — separating strategic, segment, and capability architectures that can operate at different cadences. Operating the ADM at the enterprise level on a quarterly cadence while providing just-in-time guidance at the sprint level demonstrates a proper understanding of how TOGAF can be adapted for agile contexts. Lightweight Architecture Definition Documents focused on decisions and principles align with TOGAF's guidance that deliverables should be proportionate to the need.
- **Answer d) = 3 points (Second Best):** Splitting the team recognizes the need for different operating models but creates an artificial separation. Having architects abandon their architecture role entirely to become developers loses the strategic perspective that EA provides. However, having some architects embedded in product teams (while maintaining their architecture role) is a valid element of the solution.
- **Answer c) = 1 point (Third Best):** Mandating that product teams dedicate 30% of sprints to architecture compliance work correctly recognizes the need for alignment but does so in a rigid, top-down manner that will generate further resistance. This approach treats the symptom (non-compliance) rather than the cause (disconnect between EA and agile delivery cadences).
- **Answer a) = 0 points (Distractor):** TOGAF is not incompatible with agile delivery — the ADM is explicitly designed to be tailored and iterated. Abandoning TOGAF entirely loses the strategic planning, governance, and enterprise-wide coherence that frameworks like SAFe are not designed to provide on their own. This is a false dichotomy.

### Scenario 7 - Question 7
**Scoring:**
- **Answer b) = 5 points (Best):** This approach correctly applies TOGAF's concepts of federated architecture, Architecture Landscape (with Strategic and Segment levels), and Architecture Governance with clearly defined boundaries. Establishing shared principles for interoperability while preserving organizational autonomy for local decisions directly addresses the trust concerns. Using industry standards (HL7 FHIR) as the basis for the interoperability reference architecture ensures the alliance adopts proven patterns. The Architecture Vision deliverable from Phase A is the right vehicle for articulating this federated model and gaining buy-in.
- **Answer d) = 3 points (Second Best):** A centralized data warehouse provides a pragmatic solution for data sharing without requiring changes to individual systems. However, it creates a single point of failure, introduces data latency (nightly extracts), does not enable real-time clinical workflows, and does not establish the architectural foundation for future integration needs. It addresses the immediate need but not the strategic architecture.
- **Answer a) = 1 point (Third Best):** While standardization on a single EHR would deliver the best interoperability, mandating this approach for independent organizations in a voluntary alliance is politically unrealistic and would likely cause members to leave the alliance. It ignores the critical constraint of organizational autonomy and the trust issues already identified.
- **Answer c) = 0 points (Distractor):** Ad hoc point-to-point interfaces create an integration spaghetti that becomes increasingly unmaintainable as the number of connections grows. This approach provides no architectural governance, no standards, and no strategic direction — it is the antithesis of enterprise architecture.

### Scenario 8 - Question 8
**Scoring:**
- **Answer b) = 5 points (Best):** This approach correctly applies TOGAF's Architecture Compliance Review process, which is designed to identify deviations, assess their impact, and determine appropriate responses. TOGAF recognizes that not all deviations are equal — some represent genuine risks that require remediation, while others may reveal gaps in the standards themselves. The concept of dispensations (time-limited waivers with remediation plans) is a recognized governance mechanism. Reviewing the standards based on legitimate new use cases demonstrates that governance is responsive and evidence-based, not rigid and arbitrary.
- **Answer a) = 3 points (Second Best):** Acknowledging business outcomes is pragmatic and avoids disrupting a revenue-generating feature. However, waiving compliance findings entirely without risk assessment or remediation planning undermines the governance process and sets a precedent that teams can bypass standards with impunity if they claim business urgency.
- **Answer c) = 1 point (Third Best):** While enforcing standards is important, mandating an immediate rewrite without considering business impact demonstrates a rigid, technology-centric approach that ignores the broader organizational context. TOGAF's governance guidance emphasizes proportionate response, not zero-tolerance enforcement.
- **Answer d) = 0 points (Distractor):** Punishing individuals for technology decisions is outside the scope of architecture governance and would create a toxic relationship between the architecture team and development teams. Architecture governance should focus on technical outcomes and organizational alignment, not personal consequences.

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
