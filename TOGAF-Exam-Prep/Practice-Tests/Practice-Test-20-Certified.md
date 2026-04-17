# TOGAF Part 2 Certified - Practice Test 20
**Time Allowed:** 90 minutes | **Questions:** 8 | **Pass Mark:** 60% (24/40)

---

## Scenario 1: Manufacturing IoT Architecture at Steelworth Industries

Steelworth Industries is a major steel manufacturer operating 8 production plants across North America, producing 15 million tons of steel annually. The company has embarked on an Industry 4.0 initiative to implement IoT (Internet of Things) across its manufacturing operations. The initiative aims to deploy 50,000 sensors across all plants to monitor equipment health, environmental conditions, energy consumption, and product quality in real time. The data from these sensors will feed predictive maintenance algorithms, optimize energy usage, and enable real-time quality control.

The Chief Architect has been engaged to develop the IoT architecture. The current manufacturing environment uses traditional Operational Technology (OT) systems — Programmable Logic Controllers (PLCs), Supervisory Control and Data Acquisition (SCADA) systems, and Manufacturing Execution Systems (MES) — that have been isolated from the corporate IT network for safety and security reasons. The OT teams are deeply concerned about connecting industrial control systems to the corporate network or the internet, citing safety risks (a cyberattack could potentially cause physical harm to workers or equipment damage) and reliability risks (network latency could disrupt real-time control loops).

The IT team wants to integrate IoT data into the enterprise data platform for analytics and business intelligence. The CTO envisions a unified architecture where IoT data flows from the plant floor to cloud-based analytics platforms. The VP of Manufacturing insists that plant floor operations must remain isolated from the corporate network, with no direct connectivity between OT and IT systems. The CISO supports the VP of Manufacturing's position and adds that any IoT deployment must comply with the IEC 62443 industrial cybersecurity standard.

### Question 1
How should the Chief Architect design the IoT architecture to address the conflicting requirements between IT integration and OT isolation during Phases C and D?

a) Implement a direct connection between all OT systems and the corporate IT network, routing IoT data through the existing enterprise network to the cloud analytics platform, as modern network security tools can adequately protect industrial systems

b) Design a layered architecture using TOGAF's Phase C (Information Systems Architecture) and Phase D (Technology Architecture) that establishes clear boundaries between OT and IT domains — implement an OT demilitarized zone (DMZ) as an intermediary layer where IoT data is collected, sanitized, and forwarded to the IT domain without allowing any direct connectivity between OT systems and the corporate/cloud network, deploy edge computing capabilities in the DMZ for time-sensitive analytics (predictive maintenance, real-time quality control) that cannot tolerate cloud latency, and use the Architecture Requirements Specification to document the non-negotiable safety and security constraints, treating the IEC 62443 compliance requirement as an architecture constraint that shapes the Technology Architecture

c) Keep all OT systems completely isolated and abandon the IoT initiative, as the safety risks of connecting industrial systems outweigh any potential benefits

d) Deploy all IoT sensors on a completely separate network with its own cloud analytics platform, creating a parallel technology infrastructure with no integration to either the OT or IT environments

---

## Scenario 2: Supply Chain Integration Architecture at FreshDirect Foods

FreshDirect Foods is a national fresh food distributor that manages a complex supply chain connecting 2,000 agricultural producers, 15 distribution centers, 400 transportation routes, and 8,000 retail outlet customers. The company differentiates itself through its ability to deliver fresh produce within 24 hours of harvest. The CEO has identified supply chain visibility as the top strategic priority — the company currently lacks real-time visibility into product location, temperature conditions during transit, and accurate demand forecasting.

The Chief Architect has been tasked with developing a supply chain integration architecture. The current integration landscape is problematic: suppliers use a variety of systems ranging from sophisticated ERP platforms to paper-based processes; the company's internal systems (warehouse management, transportation management, order management, demand planning) are poorly integrated with manual handoffs between processes; and retail customers have diverse systems for receiving orders, managing inventory, and sharing point-of-sale data.

During Phase B (Business Architecture), the architecture team has mapped the end-to-end supply chain processes and identified 23 critical integration points where data must flow between internal and external systems. The challenge is that the company does not control the technology used by its 2,000 suppliers or 8,000 retail customers, and imposing technology requirements on these external partners would damage business relationships. Additionally, many small agricultural producers have minimal IT capability and communicate primarily through phone and email.

### Question 2
What integration architecture approach should the Chief Architect recommend during Phase C to enable supply chain visibility while accommodating the diverse technology landscape of external partners?

a) Mandate that all 2,000 suppliers and 8,000 retail customers adopt the company's supply chain platform, providing training and support to ensure adoption, as standardization is the only path to full supply chain visibility

b) Design a multi-tier integration architecture that accommodates the diverse technology maturity of external partners: define a supply chain data exchange standard (using industry standards like GS1 and EPCIS where applicable) as Architecture Building Blocks, implement an integration platform that supports multiple connectivity patterns — API-based real-time integration for technology-sophisticated partners, EDI for mid-tier partners, and simple web portal/mobile app interfaces for low-technology partners (including small agricultural producers) — deploy IoT-enabled track-and-trace capabilities for shipment visibility and temperature monitoring controlled by FreshDirect, and use TOGAF's Business Architecture from Phase B to identify which integration points are most critical for the 24-hour freshness guarantee, prioritizing these in the implementation sequence

c) Build point-to-point custom integrations with each of the top 100 suppliers and top 200 retail customers, covering 80% of transaction volume, and manage the remaining partners through phone and email as they do today

d) Focus exclusively on integrating FreshDirect's internal systems and defer all external partner integration until the internal systems are fully modernized, as internal integration should always precede external integration

---

## Scenario 3: Technology Architecture Modernization at Pacific Energy Utilities

Pacific Energy Utilities is a major electricity and gas utility serving 5 million customers across the western United States. The company's technology architecture has evolved organically over 30 years, resulting in a complex landscape of 320 applications spanning customer billing, meter management, outage management, asset management, workforce scheduling, regulatory reporting, and energy trading. A recent technology assessment revealed that 45% of applications are running on unsupported software versions, 30% have reached end-of-life with no vendor support, and 15% are running on hardware that cannot be replaced because the applications cannot be migrated.

The CTO has declared a "technology debt crisis" and secured Board approval for a five-year, $350 million technology modernization program. The Chief Architect has been asked to develop a Technology Architecture Target State and a modernization roadmap. However, the utility industry presents unique constraints: the public utilities commission requires regulatory approval for major technology investments and expects detailed cost-benefit justification; any modernization must maintain the 99.999% reliability required for critical grid operations; the workforce has deep expertise in legacy technologies but limited experience with modern platforms; and regulated rate structures mean the company cannot simply increase prices to fund modernization.

The architecture team is midway through Phase D (Technology Architecture) and must define a Target Technology Architecture that addresses the technology debt while respecting industry constraints.

### Question 3
What approach should the Chief Architect take to define the Target Technology Architecture and modernization roadmap?

a) Define a Target Technology Architecture based on the latest cloud-native technologies (Kubernetes, microservices, serverless) and plan to migrate all 320 applications to this modern stack within five years

b) Develop the Target Technology Architecture during Phase D by: conducting a comprehensive technology portfolio assessment that classifies all 320 applications by business criticality, technical condition, and modernization options (retain, re-host, re-platform, refactor, replace, retire) using a structured framework, defining the Target Technology Architecture in layers (infrastructure, platform, application services, integration, security) with approved technology standards for each layer, creating a risk-based modernization roadmap that prioritizes applications based on operational risk (unsupported/end-of-life systems supporting critical grid operations first), using Transition Architectures to define intermediate stable states that progressively reduce technology debt while maintaining 99.999% reliability, and preparing the regulatory cost-benefit documentation as an architecture deliverable to support the rate case

c) Focus modernization efforts only on the 15% of applications running on irreplaceable hardware, as these present the most acute risk, and leave the remaining 85% of applications to be addressed in future budget cycles

d) Replace all 320 applications with a single, integrated utility management platform from a major vendor, as consolidation to a single platform eliminates technology diversity and simplifies the architecture

---

## Scenario 4: Implementation Governance Challenges at Atlas Global Banking

Atlas Global Banking is a multinational bank that has completed the architecture development phases (A through D) for a major transformation program called "OneBank" — a $400 million initiative to consolidate 12 regional banking platforms into a single global core banking system. The architecture team produced a comprehensive Architecture Definition Document, detailed Architecture Requirements Specification, and a phased Implementation and Migration Plan with four Transition Architectures over a three-year period.

The program is now 18 months into implementation, and serious governance challenges have emerged. Three of the regional implementation teams have deviated significantly from the approved architecture: the Asia-Pacific team has built custom middleware instead of using the approved enterprise integration platform; the European team has implemented a different data model for customer master data than specified in the architecture; and the Latin American team has bypassed the approved security architecture by implementing its own authentication service. Each team justifies its deviations by citing local regulatory requirements, timeline pressures, and the inadequacy of the global architecture to address regional needs.

The Architecture Compliance Reviews have flagged these deviations, but the regional program directors have overridden the findings, arguing that the global architecture was developed without sufficient understanding of regional requirements. The Chief Architect is concerned that these deviations will undermine the program's core objective of platform consolidation and will create integration failures when the regional implementations attempt to connect to the global platform.

### Question 4
How should the Chief Architect address the implementation governance failures in the OneBank program?

a) Accept all regional deviations and modify the global architecture to accommodate the differences, as the regional teams' proximity to local requirements means their decisions are likely superior to the global architecture team's

b) Invoke the Architecture Governance process to address the deviations systematically: convene an Architecture Compliance Review that formally assesses each deviation's impact on the program's consolidation objectives, integration feasibility, security posture, and total cost of ownership, classify deviations into categories (those that reflect genuine gaps in the global architecture requiring architecture updates, those that can be accommodated through managed variation with integration adapters, and those that fundamentally undermine program objectives and must be remediated), escalate the governance authority issue to the program's Steering Committee to reaffirm that architecture compliance is a program requirement that regional directors cannot unilaterally override, and simultaneously initiate Architecture Requirements Management to capture legitimate regional requirements that the global architecture should have addressed, feeding these back into an ADM iteration to update the Architecture Definition Document

c) Halt the entire program immediately until all three regions bring their implementations back into full compliance with the original architecture, regardless of the delay and cost impact

d) Dissolve the global architecture team and delegate all architecture decisions to the regional teams, as centralized architecture governance has proven unworkable in a multinational context

---

## Scenario 5: Architecture Change Management at Velocity Telecom

Velocity Telecom is a telecommunications provider that completed a major enterprise architecture transformation 18 months ago. The transformation established a Target Architecture based on a cloud-native, API-first platform supporting 5G network services, customer experience management, and network operations. The architecture has been implemented and is operational, delivering the expected benefits in terms of reduced time-to-market for new services and improved operational efficiency.

However, the business environment has changed significantly since the Target Architecture was defined: a major competitor has launched an innovative bundled service that combines telecom, content streaming, and smart home services, requiring Velocity to respond with a similar offering; new regulations require network data sovereignty — certain network traffic data must be processed and stored within national borders; the company has acquired a regional cable operator whose hybrid fiber-coaxial network technology was not contemplated in the Target Architecture; and a breakthrough in AI-driven network optimization has created an opportunity to dramatically improve network performance, but requires significant changes to the network operations architecture.

The Chief Architect must determine how to manage these changes to the established architecture. Some stakeholders argue that the architecture should be treated as stable and changes should be minimized to preserve the investment already made. Others argue that the architecture must evolve to remain relevant and that resisting change will make the architecture obsolete.

### Question 5
How should the Chief Architect manage changes to the established architecture?

a) Treat the current Target Architecture as fixed and reject all change requests, as frequent architecture changes undermine stability and waste the investment made in the current architecture

b) Apply TOGAF's Phase H (Architecture Change Management) to manage the evolution systematically: classify each change driver by its nature and urgency — the competitive response and AI opportunity as business-driven changes requiring architecture evolution through a new ADM cycle, the data sovereignty regulation as a mandatory compliance change requiring immediate architecture modification, and the cable operator acquisition as an integration requiring extension of the Architecture Landscape — use the Architecture Requirements Management process to assess the impact of each change on the existing architecture, determine whether each change can be accommodated through incremental modification or requires a full ADM cycle, maintain the Architecture Governance process to ensure changes are evaluated and approved through the Architecture Board, and update the Architecture Repository to reflect approved changes

c) Abandon the current architecture entirely and restart the ADM from the Preliminary Phase to develop a new architecture that addresses all the changed requirements

d) Allow each business unit to make changes to the architecture independently to respond to their specific needs quickly, without centralized architecture governance review

---

## Scenario 6: Risk Management in Architecture at Sovereign Wealth Fund

The Sovereign Wealth Fund (SWF) of a small but wealthy nation manages $800 billion in global investments across equities, fixed income, real estate, and alternative assets. The fund's technology architecture supports portfolio management, risk analytics, trading execution, regulatory reporting, and investor relations. The Chief Architect has been asked to lead a major architecture transformation to implement real-time risk analytics, automated compliance monitoring, and AI-driven investment decision support.

During Phase A (Architecture Vision), the architecture team has identified several significant risks to the architecture transformation: the fund's existing risk analytics platform processes $300 billion in daily position data, and any disruption during migration could result in material financial losses or regulatory breaches; the proposed AI-driven investment models introduce model risk — the possibility that AI algorithms make systematically flawed investment decisions at scale; the cloud deployment being considered for the analytics platform raises data sovereignty concerns, as some nations where the fund invests restrict the processing of financial data outside their borders; and the fund's small but specialized IT team (45 people) may lack the capacity and skills to implement and operate the new architecture.

The Board has asked the Chief Architect to present a risk management strategy for the architecture transformation before approving the program. The fund's risk management culture is mature (for investment risk) but has limited experience applying formal risk management to technology transformations.

### Question 6
How should the Chief Architect develop the risk management strategy for the architecture transformation?

a) Delegate all risk management to the fund's existing investment risk management team, as they have a mature risk framework that can be applied directly to technology transformation without modification

b) Develop a comprehensive architecture risk management approach using TOGAF's risk management guidance integrated with the ADM: conduct a formal risk assessment during Phase A that identifies, classifies, and quantifies the architecture transformation risks across dimensions (operational continuity, model risk, data sovereignty, capacity/skills), define risk mitigation strategies as architecture requirements that shape the Target Architecture (e.g., parallel-run capability to mitigate migration risk, model governance framework to mitigate AI model risk, hybrid deployment to address data sovereignty, managed services to address skills gaps), embed risk checkpoints throughout the ADM phases with explicit risk reviews at each Architecture Compliance Review, design Transition Architectures that minimize the risk window during migration by maintaining fallback capabilities until new systems are proven, and present the risk management strategy to the Board in investment risk terminology they are familiar with to bridge the gap between technology and investment risk management cultures

c) Minimize the risk discussion to avoid alarming the Board and potentially losing their approval for the transformation, presenting only the benefits and downplaying the risks

d) Recommend that the fund avoid the transformation entirely because the risks are too high for an organization managing $800 billion, and suggest incremental improvements to the existing architecture instead

---

## Scenario 7: Capability Assessment at Meridian Aerospace

Meridian Aerospace is a defense and commercial aerospace manufacturer that builds aircraft components, avionics systems, and satellite subsystems. The company has 25,000 employees across 12 facilities and generates $9 billion in annual revenue. The CEO has asked the Chief Architect to conduct a comprehensive capability assessment to support strategic planning. The company is considering entering the urban air mobility (UAM) market — developing electric vertical takeoff and landing (eVTOL) aircraft — and needs to understand which existing capabilities can be leveraged and which new capabilities must be developed.

The Chief Architect must assess capabilities across the entire enterprise: engineering (structural design, avionics engineering, systems integration, testing and certification), manufacturing (composite fabrication, precision machining, electronics assembly, quality assurance), supply chain (procurement, logistics, supplier management), after-market services (maintenance, repair, overhaul), and enabling capabilities (digital engineering, data analytics, cybersecurity, regulatory affairs). Each capability must be assessed for its applicability to UAM, its current maturity level, and the investment required to adapt or develop it for UAM applications.

The assessment faces challenges: capability information is scattered across different divisions with no central catalog; different divisions define and measure capabilities differently; and the division leaders who control the capabilities are protective of their resources and skeptical that their capabilities would be "shared" with a new UAM venture without additional funding.

### Question 7
How should the Chief Architect conduct the capability assessment to support the UAM strategic decision?

a) Outsource the capability assessment to an external management consulting firm, as internal teams lack the objectivity to assess their own capabilities honestly

b) Conduct the capability assessment using TOGAF's Business Architecture (Phase B) approach: develop a comprehensive business capability map that catalogs all enterprise capabilities using a consistent taxonomy and assessment framework, assess each capability across standardized dimensions (maturity level, strategic importance, performance, capacity, adaptability), map the required capabilities for UAM market entry (drawing on industry analysis and UAM-specific requirements such as electric propulsion, autonomous flight systems, urban airspace management, new certification frameworks), perform a gap analysis between existing capabilities and UAM requirements to identify which capabilities can be directly leveraged, which need enhancement, and which are entirely new, estimate the investment required for capability development across each category, and present the findings using the TOGAF Business Transformation Readiness Assessment approach to give the CEO a clear, evidence-based picture of the organization's readiness for UAM entry

c) Assess only the engineering and manufacturing capabilities since these are the most directly relevant to building eVTOL aircraft, excluding supply chain, after-market services, and enabling capabilities from the assessment scope

d) Skip the capability assessment and recommend that the company acquire an existing UAM startup instead, as building capabilities internally would take too long in a rapidly moving market

---

## Scenario 8: EA Communication Strategy at Nexus Conglomerate

Nexus Conglomerate is a diversified industrial holding company with 12 operating companies spanning energy, transportation, construction, telecommunications, and financial services. The company employs 85,000 people globally. A corporate EA function was established two years ago to drive synergies across the operating companies and align technology investments with the corporate strategy. The EA team has produced significant work: a corporate technology standards catalog, a shared services architecture for common functions (HR, finance, procurement), a data sharing architecture for cross-company analytics, and an integration reference architecture.

However, a stakeholder survey has revealed a critical problem: the EA function's work is largely unknown outside of the corporate IT department. Operating company CEOs view EA as a corporate IT overhead; CIOs of operating companies see it as corporate intrusion into their technology autonomy; business executives have no awareness of the shared services or data sharing architectures; and even within corporate IT, many staff cannot articulate the value the EA function provides. The Chief Architect realizes that the EA practice has a communication problem — excellent architecture work is being produced but not effectively communicated to the stakeholders who need to understand and act on it.

The corporate CEO has asked the Chief Architect to present the EA function's value proposition at the next quarterly Operating Company CEOs meeting and is considering reducing the EA budget if the function cannot demonstrate its relevance to the operating companies.

### Question 8
How should the Chief Architect develop an EA communication strategy to demonstrate value and gain stakeholder support?

a) Produce a comprehensive 200-page Architecture Vision document that details all EA work completed to date and distribute it to all stakeholders, as the problem is that stakeholders haven't been given enough information about the EA function's work

b) Develop a targeted EA communication strategy aligned with TOGAF's stakeholder management guidance: segment the audience into distinct stakeholder groups (operating company CEOs, operating company CIOs, business executives, corporate IT staff), develop tailored communication materials for each group that translate architecture work into their language and concerns (e.g., for CEOs: quantified synergy opportunities and cost avoidance; for CIOs: integration patterns that enable rather than constrain their autonomy; for business executives: data-driven decision capabilities), create architecture views using TOGAF's viewpoint concept that present relevant information for each stakeholder's concerns, establish regular communication cadences (executive briefings, CIO architecture forums, business capability workshops), and for the CEO presentation specifically, prepare a concise value narrative with measurable outcomes — cost savings from shared services, revenue opportunities from data sharing, risk reduction from standards compliance — supported by specific examples that operating company CEOs can relate to

c) Hire a marketing firm to create polished promotional materials and a brand identity for the EA function, as the problem is one of marketing rather than communication substance

d) Request that the corporate CEO mandate all operating companies to engage with the EA function, using executive authority rather than communication to solve the engagement problem

---

## Answer Key

### Scenario 1 - Question 1
**Scoring:**
- **Answer b) = 5 points (Best):** This approach correctly applies TOGAF Phases C and D to design a layered architecture that addresses the fundamental OT/IT security boundary. The OT DMZ concept is the industry-standard pattern for enabling data flow from manufacturing systems to enterprise systems without creating direct connectivity that could compromise safety. Edge computing in the DMZ addresses the time-sensitive analytics requirement without introducing cloud latency into operational processes. Treating IEC 62443 compliance and safety constraints as non-negotiable architecture requirements in the Architecture Requirements Specification ensures these constraints shape the architecture rather than being treated as afterthoughts. This architecture balances the CTO's integration vision with the VP of Manufacturing's isolation requirement.
- **Answer d) = 3 points (Second Best):** Deploying IoT on a completely separate network provides a safe starting point that avoids OT/IT convergence risks. This approach would deliver some IoT benefits (sensor data collection, basic analytics) without the integration challenges. However, creating a parallel infrastructure with no integration to either OT or IT defeats the purpose of the Industry 4.0 initiative — the value comes from integrating IoT data with enterprise analytics and operational systems.
- **Answer c) = 1 point (Third Best):** The safety concerns raised by the OT team and CISO are legitimate. However, abandoning the IoT initiative entirely is an overreaction that ignores the availability of well-established architectural patterns (DMZ, data diodes, unidirectional gateways) that enable safe OT/IT data flow. This approach sacrifices significant business value to avoid a risk that can be architecturally managed.
- **Answer a) = 0 points (Distractor):** Directly connecting OT systems to the corporate IT network violates fundamental industrial cybersecurity principles and the IEC 62443 standard that the CISO has identified as a requirement. Modern network security tools are not sufficient to protect industrial control systems from the full range of cyber threats, and a successful attack could cause physical harm to workers or equipment damage. This approach ignores the architecture constraint that OT isolation is non-negotiable.

### Scenario 2 - Question 2
**Scoring:**
- **Answer b) = 5 points (Best):** This multi-tier integration architecture correctly applies TOGAF's Building Block concept to define reusable integration patterns while accommodating the diverse technology landscape. Using industry standards (GS1, EPCIS) as Architecture Building Blocks ensures the integration architecture is based on proven supply chain standards. The tiered connectivity model (API, EDI, web portal/mobile) accommodates partners at different technology maturity levels without excluding low-technology producers. IoT-enabled track-and-trace under FreshDirect's control provides supply chain visibility without depending on partner technology capabilities. Prioritizing integration points based on the 24-hour freshness guarantee (from the Phase B Business Architecture) ensures the architecture serves the core business differentiator.
- **Answer c) = 3 points (Second Best):** Focusing on the top 100 suppliers and 200 customers to cover 80% of transaction volume is a pragmatic 80/20 approach. However, point-to-point custom integrations do not scale and create maintenance burden. More importantly, this approach leaves 1,900 suppliers and 7,800 customers without integration, potentially missing visibility gaps in the supply chain that affect the freshness guarantee.
- **Answer d) = 1 point (Third Best):** Internal integration is a reasonable prerequisite that would deliver immediate value by connecting FreshDirect's own systems. However, supply chain visibility inherently requires external integration — internal systems cannot provide visibility into supplier operations, transit conditions, or retail demand without external data flows. Deferring external integration indefinitely misses the core business requirement.
- **Answer a) = 0 points (Distractor):** Mandating that 10,000 external partners adopt FreshDirect's platform is commercially infeasible and would damage business relationships. Many small agricultural producers lack the IT capability to adopt any standardized platform. This approach ignores the explicit constraint that FreshDirect cannot impose technology requirements on its trading partners.

### Scenario 3 - Question 3
**Scoring:**
- **Answer b) = 5 points (Best):** This approach applies a structured technology portfolio assessment methodology (the 6 Rs: retain, re-host, re-platform, refactor, replace, retire) that is consistent with TOGAF Phase D guidance for defining the Target Technology Architecture. Defining the architecture in layers ensures comprehensive coverage. Risk-based prioritization (addressing unsupported systems supporting critical grid operations first) directly addresses the "99.999% reliability" constraint. Transition Architectures enable progressive modernization while maintaining operational continuity. Preparing regulatory cost-benefit documentation recognizes the unique utility industry constraint that technology investments require rate case approval.
- **Answer c) = 3 points (Second Best):** Focusing on the 15% of applications on irreplaceable hardware addresses the most acute risk. This is a valid risk-based prioritization that could be the first phase of a broader modernization. However, limiting the effort to only this segment leaves 85% of the technology debt unaddressed, including the 45% running on unsupported software versions that also present significant operational risk.
- **Answer a) = 1 point (Third Best):** Defining a cloud-native Target Architecture demonstrates forward-thinking technology vision. However, migrating all 320 applications to cloud-native technologies within five years is unrealistic for a utility with 99.999% reliability requirements, legacy workforce skills, and regulatory investment constraints. Many utility-specific applications (SCADA, outage management, grid control) have specialized requirements that cloud-native architectures may not address.
- **Answer d) = 0 points (Distractor):** Replacing all 320 applications with a single platform is unrealistic — no single vendor platform covers the full range of utility operations from energy trading to grid control to customer billing. This approach introduces massive vendor lock-in, enormous implementation risk, and ignores the diversity of utility-specific application requirements.

### Scenario 4 - Question 4
**Scoring:**
- **Answer b) = 5 points (Best):** This approach correctly applies TOGAF's Architecture Governance process and Architecture Compliance Review mechanisms. The structured classification of deviations (genuine gaps, manageable variations, fundamental conflicts) demonstrates mature architectural judgment — not all deviations are equal, and the response should be proportionate. Escalating the governance authority issue to the Steering Committee is the appropriate mechanism for resolving authority disputes. Initiating an ADM iteration to capture legitimate regional requirements that the global architecture missed demonstrates that architecture governance is responsive, not rigid. This balanced approach maintains program integrity while acknowledging that the global architecture team may have made incomplete assumptions.
- **Answer a) = 3 points (Second Best):** Acknowledging that regional teams may have valid insights about local requirements is important, and modifying the global architecture to accommodate legitimate differences is appropriate. However, accepting all deviations without assessment undermines the consolidation objective — if every region has different middleware, data models, and security implementations, the "OneBank" platform will be multiple platforms in name only.
- **Answer c) = 1 point (Third Best):** Enforcing compliance demonstrates that governance has authority. However, halting the entire program to enforce compliance on all three regions simultaneously creates massive delay and cost impact. A more targeted approach that assesses which deviations truly need remediation (versus those that can be accommodated) is more proportionate and pragmatic.
- **Answer d) = 0 points (Distractor):** Dissolving the global architecture team and delegating all decisions to regions would result in 12 divergent implementations that cannot integrate into a single platform. This defeats the entire purpose of the OneBank program and the $400 million investment. The governance challenges indicate the need for governance reform, not governance elimination.

### Scenario 5 - Question 5
**Scoring:**
- **Answer b) = 5 points (Best):** This approach correctly applies TOGAF Phase H (Architecture Change Management), which is specifically designed to manage changes to an established architecture. Classifying change drivers by nature and urgency is the first step in Phase H — it determines whether changes can be handled through incremental modification or require a new ADM cycle. The competitive response and AI opportunity are strategic changes warranting a new ADM cycle; the data sovereignty regulation is a mandatory compliance change requiring immediate attention; and the cable operator acquisition is an architecture extension. Using Architecture Requirements Management to assess impact, the Architecture Board for governance, and the Architecture Repository for documentation ensures changes are managed systematically rather than ad hoc.
- **Answer c) = 3 points (Second Best):** Restarting the ADM acknowledges that significant changes have accumulated and a comprehensive rethink may be needed. However, starting from the Preliminary Phase is excessive — the organizational model, architecture principles, and framework are still valid. A new ADM cycle from Phase A would be more appropriate, and the existing architecture provides the baseline rather than being abandoned entirely.
- **Answer a) = 1 point (Third Best):** Maintaining architecture stability has value — frequent changes do create disruption and waste investment. However, a rigid refusal to evolve the architecture in the face of competitive threats, regulatory mandates, and acquisitions would render the architecture increasingly irrelevant. TOGAF explicitly includes Phase H to manage architecture evolution because change is inevitable.
- **Answer d) = 0 points (Distractor):** Allowing independent changes without governance would fragment the architecture and undo the benefits of the transformation. Each business unit making changes independently would create inconsistencies, integration failures, and security vulnerabilities. Architecture governance exists to ensure changes are coherent and aligned.

### Scenario 6 - Question 6
**Scoring:**
- **Answer b) = 5 points (Best):** This approach integrates TOGAF's risk management guidance with the ADM, making risk management a continuous thread throughout the architecture development. The formal risk assessment during Phase A with classification across multiple dimensions (operational continuity, model risk, data sovereignty, skills) is comprehensive. Defining risk mitigation strategies as architecture requirements that shape the Target Architecture ensures risks are architecturally addressed rather than just documented. Embedding risk checkpoints throughout the ADM provides continuous risk oversight. Designing Transition Architectures with fallback capabilities directly addresses the migration risk for a $300 billion daily operation. Presenting in investment risk terminology bridges the cultural gap between the fund's mature investment risk practice and the less familiar technology risk domain.
- **Answer d) = 3 points (Second Best):** Recognizing the risks and recommending a more conservative approach (incremental improvements) is a valid risk management response. For an organization managing $800 billion, extreme caution is appropriate. However, avoiding transformation entirely also carries risks — the existing technology may become a competitive disadvantage, regulatory requirements may not be met, and the opportunity cost of not implementing AI-driven investment capabilities is significant.
- **Answer a) = 1 point (Third Best):** Leveraging the fund's existing investment risk management team provides access to mature risk management practices and organizational risk culture. However, investment risk frameworks (focused on market risk, credit risk, liquidity risk) do not directly translate to technology transformation risks (migration risk, integration risk, skills risk). Some adaptation is needed rather than direct application.
- **Answer c) = 0 points (Distractor):** Downplaying risks to the Board of a sovereign wealth fund is ethically questionable and strategically dangerous. If risks materialize without Board awareness, the consequences would be severe for both the fund and the Chief Architect's credibility. Mature organizations expect transparent risk assessment, not risk concealment.

### Scenario 7 - Question 7
**Scoring:**
- **Answer b) = 5 points (Best):** This approach correctly uses TOGAF's Business Architecture (Phase B) for capability mapping and assessment. A comprehensive capability map with consistent taxonomy provides the foundation for the assessment. Assessing across standardized dimensions (maturity, strategic importance, performance, capacity, adaptability) ensures comparability across divisions. Mapping required UAM capabilities against existing capabilities through gap analysis provides the evidence base for the strategic decision. Estimating investment for each gap category (leverage, enhance, develop new) gives the CEO actionable financial information. The Business Transformation Readiness Assessment approach provides a structured framework for presenting findings.
- **Answer a) = 3 points (Second Best):** External consultants can bring objectivity and cross-industry benchmarking to the assessment. However, outsourcing the entire assessment removes the architecture team's direct engagement with the divisions, losing the opportunity to build relationships and develop the internal capability map that would serve the organization beyond this single assessment. External assessments also lack the deep institutional knowledge needed to understand context and nuance.
- **Answer c) = 1 point (Third Best):** Engineering and manufacturing capabilities are central to UAM, but a narrow scope misses critical enabling capabilities. UAM market entry requires supply chain capabilities (new suppliers for electric propulsion components), regulatory affairs capabilities (new certification frameworks for eVTOL), digital engineering capabilities (autonomous flight systems), and after-market service capabilities (new maintenance paradigms). Excluding these from the assessment would give the CEO an incomplete picture.
- **Answer d) = 0 points (Distractor):** Skipping the capability assessment and recommending acquisition bypasses the architecture team's role entirely. The CEO specifically asked for a capability assessment to inform the strategic decision. An acquisition might be the right answer, but it should emerge from the assessment rather than replace it. Additionally, acquiring a startup brings its own integration challenges that would still require capability assessment.

### Scenario 8 - Question 8
**Scoring:**
- **Answer b) = 5 points (Best):** This approach correctly applies TOGAF's stakeholder management guidance and the concept of architecture viewpoints. Segmenting audiences and developing tailored communications for each group addresses the root cause — different stakeholders need different information presented in their language. TOGAF's viewpoint concept (creating architecture views tailored to specific stakeholder concerns) provides the framework for this differentiated communication. Quantified value narratives with measurable outcomes (cost savings, revenue opportunities, risk reduction) speak the language of operating company CEOs. Regular communication cadences ensure engagement is sustained, not one-time. The CEO presentation with specific, relatable examples provides the immediate defense needed for the budget discussion.
- **Answer d) = 3 points (Second Best):** Executive mandate would force engagement in the short term. However, mandated engagement without demonstrated value creates resentment and compliance without commitment. The operating company CEOs would view it as corporate overreach, undermining the collaborative relationship the EA function needs. This approach treats the symptom (lack of engagement) without addressing the cause (lack of visible value).
- **Answer c) = 1 point (Third Best):** Marketing materials can improve the visibility of the EA function. However, the problem is not branding — it is that stakeholders do not understand how the EA function's work relates to their specific concerns and priorities. Polished materials that still present architecture in architecture language will not resonate with business stakeholders. Communication substance matters more than presentation polish.
- **Answer a) = 0 points (Distractor):** A 200-page document would reinforce the perception of EA as bureaucratic overhead. No operating company CEO will read a 200-page Architecture Vision. This approach treats the communication problem with more of the same — comprehensive architecture documentation that stakeholders do not engage with. The problem is not insufficient documentation but insufficient stakeholder-relevant communication.

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
