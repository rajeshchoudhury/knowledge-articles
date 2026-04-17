# TOGAF Part 2 Certified - Practice Test 22
**Time Allowed:** 90 minutes | **Questions:** 8 | **Pass Mark:** 60% (24/40)
**Maximum Score:** 40 points

---

## Scenario 1: Telecommunications Company Network Modernization

TeleNova Communications is a major telecommunications provider serving 42 million subscribers across a national market. The company's network infrastructure has evolved over 25 years through successive technology generations—2G, 3G, and 4G—each layered atop the previous generation rather than replacing it. The result is a massively complex network architecture with over 1,800 network elements from 14 different vendors, 23 distinct OSS/BSS (Operations Support Systems/Business Support Systems) platforms, and an estimated 45,000 integration points between systems.

The network operations team spends 68% of its budget maintaining legacy 2G and 3G infrastructure that serves only 12% of traffic. Network fault resolution times average 4.2 hours due to the complexity of diagnosing issues across interconnected legacy and modern systems. The company's ARPU (Average Revenue Per User) has declined 18% over three years as over-the-top (OTT) services commoditize basic connectivity.

The Board has approved a $2.8 billion Network Modernization Program spanning five years with three strategic objectives: decommission 2G by year 2 and 3G by year 4, deploy a nationwide 5G network covering 85% of the population by year 5, and transform the OSS/BSS landscape to a cloud-native, AI-driven operations model. The program will be executed while maintaining service to 42 million subscribers—any significant network outage would trigger regulatory penalties and massive customer churn.

The Chief Architect must develop the enterprise architecture to guide this transformation, coordinating between the Network Engineering team (focused on radio access and core network), the IT team (responsible for OSS/BSS), the Commercial team (defining new 5G services), and the Regulatory Affairs team (managing spectrum and compliance requirements).

### Question 1
What is the BEST approach for the Chief Architect to structure the enterprise architecture for TeleNova's network modernization program?

a) Focus exclusively on the technology architecture (Phase D of the ADM) since this is fundamentally a network infrastructure transformation, and delegate business and application architecture concerns to the respective business and IT teams.

b) Apply the full ADM cycle with the Architecture Landscape concept: develop a Strategic Architecture that defines the end-state vision across all four architecture domains (Business, Data, Application, Technology), recognizing that network modernization is not just a technology project but transforms business models (new 5G services), data architecture (real-time network analytics), and application architecture (cloud-native OSS/BSS). Partition the work into Segment Architectures aligned to the three strategic objectives (legacy decommission, 5G deployment, OSS/BSS transformation), each with its own ADM iteration. Use Transition Architectures to define stable intermediate states (plateaus) ensuring that at every point during the five-year program, all 42 million subscribers maintain service. Apply the Stakeholder Management approach to align the four major stakeholder groups (Network Engineering, IT, Commercial, Regulatory) through a shared Architecture Vision, and use the Architecture Requirements Specification to formally capture regulatory and service continuity constraints.

c) Adopt a vendor-driven approach by selecting a single 5G equipment vendor (such as Ericsson or Nokia) and using their reference architecture as the target state, allowing the vendor to drive the architecture decisions since they have the deepest network technology expertise.

d) Break the program into 14 independent vendor replacement projects (one for each current vendor), allowing each project team to select the best replacement independently and integrate the results at the end of the five-year program.

---

## Scenario 2: 5G Architecture Decisions

TeleNova's 5G deployment architecture requires critical decisions about network architecture approach. The Network Engineering team has proposed two competing architectures:

**Option Alpha:** A standalone 5G (SA) architecture deploying a fully cloud-native 5G core network from day one, with network slicing capabilities enabling differentiated services for enterprise customers (ultra-reliable low-latency for manufacturing, massive IoT for smart cities, enhanced mobile broadband for consumers). This approach requires a $1.4 billion investment in the core network alone and will take 24 months before any commercial services launch.

**Option Beta:** A non-standalone 5G (NSA) architecture initially leveraging the existing 4G core network with 5G radio access, enabling faster time to market (commercial launch in 8 months) at lower initial cost ($600 million). Advanced capabilities like network slicing would be added later through a core network upgrade in years 3-4.

The Commercial Director strongly supports Option Beta, arguing that competitors are already offering 5G services and every month of delay costs market share. The CTO prefers Option Alpha, arguing that the NSA approach will create technical debt and require expensive rework when the core is eventually upgraded. The CFO wants the lowest-cost option that meets minimum requirements. The Enterprise Sales VP insists on network slicing from day one, as three major enterprise contracts worth $180 million annually are contingent on this capability.

The Architecture Board must make a recommendation that balances these competing concerns.

### Question 2
What is the BEST architectural recommendation for the Architecture Board regarding TeleNova's 5G deployment approach?

a) Recommend Option Beta (NSA) as it provides the fastest time to market, and defer the standalone core network decision to a future ADM cycle when technology has matured and costs have decreased.

b) Recommend a hybrid Transition Architecture approach: deploy NSA 5G (Option Beta) for consumer enhanced mobile broadband services in Phase 1 (months 1-12) to address competitive pressure and generate early revenue, while simultaneously beginning standalone 5G core development. In Transition Architecture 2 (months 12-24), deploy the standalone core in target enterprise markets first, enabling network slicing for the three critical enterprise contracts. In Transition Architecture 3 (months 24-36), complete the SA migration nationally and decommission NSA elements. Document this as a formal Transition Architecture sequence in the ADM Phase E/F deliverables, with each plateau defined as independently stable. Use Architecture Decision Records to capture the rationale, trade-offs, and conditions under which the sequencing would be reassessed. Establish architecture compliance criteria that prevent the NSA deployment from making decisions that would increase the cost of SA migration.

c) Recommend Option Alpha (SA) as it is the architecturally pure solution with no technical debt, and present a business case showing that the long-term cost savings justify the delayed time to market.

d) Recommend letting each region choose its own approach—NSA for urban areas where competitive pressure is highest, and SA for suburban/rural areas where there is more time—creating a dual-architecture deployment.

---

## Scenario 3: Multi-Cloud Strategy

InfraCore Technologies, a large enterprise software company with 8,000 employees, has been operating exclusively on AWS for the past six years. The company's entire product portfolio—a suite of SaaS applications serving 3,200 enterprise customers—runs on AWS, with extensive use of AWS-native services (Lambda, DynamoDB, SQS, Kinesis, Aurora). Annual AWS spending is $84 million and growing 25% year-over-year.

The Board has mandated a multi-cloud strategy driven by three concerns: concentration risk (a major AWS outage last year caused 14 hours of downtime costing $12 million in SLA penalties), customer demand (several government and financial services customers require deployment on specific cloud providers for data sovereignty), and negotiating leverage (reducing dependency on a single vendor to improve commercial terms).

The CTO has asked the enterprise architecture team to develop the multi-cloud architecture. Initial analysis reveals the depth of AWS dependency: 340 Lambda functions, 78 DynamoDB tables, extensive use of AWS IAM for security, CloudFormation for infrastructure as code, and custom integrations with 12 AWS-specific services. The estimated effort to make the application stack cloud-portable is 18 months of development work by a team of 40 engineers—representing a significant opportunity cost against feature development.

The engineering team is divided: the platform team supports multi-cloud for operational resilience, while the product engineering team argues that abstracting away cloud-native services will reduce performance and innovation velocity. The security team has concerns about maintaining consistent security postures across multiple cloud environments.

### Question 3
What is the BEST architectural approach for InfraCore's multi-cloud strategy?

a) Execute a complete "lift and shift" migration to make the entire application stack run on all three major cloud providers (AWS, Azure, GCP) simultaneously, using only cloud-agnostic services and open-source alternatives to AWS-native services.

b) Apply TOGAF's Architecture Principles to establish multi-cloud guiding principles, then develop a tiered multi-cloud architecture through the ADM: Tier 1 - Define an abstraction layer for infrastructure services (compute, storage, networking) that must be cloud-portable, enabling deployment flexibility for customer data sovereignty requirements. Tier 2 - Identify which AWS-native services provide critical competitive advantage (e.g., specific AI/ML capabilities) and accept strategic dependency with documented risk mitigation. Tier 3 - Define which new services must be built cloud-agnostic from inception using open standards (Kubernetes, Terraform, OpenTelemetry). Use the Technology Reference Model to classify all cloud services into these tiers, establish a Standards Information Base for approved services on each cloud platform, and create Transition Architectures that sequence the portability work based on customer demand priority (government and financial services customers first). Include Architecture Decision Records documenting the explicit trade-offs between portability and performance for each service tier.

c) Abandon the multi-cloud strategy since the cost of portability ($84M+ in engineering effort and opportunity cost) outweighs the benefits, and instead negotiate a better enterprise agreement with AWS that includes enhanced SLA guarantees and dedicated support.

d) Adopt a "best of breed" approach where each new product or service is deployed on whichever cloud provider offers the best native services for that workload, with no portability layer, allowing the architecture to naturally diversify across clouds over time.

---

## Scenario 4: Vendor Lock-in Mitigation

GlobalRetail Group, an international retail conglomerate with operations in 28 countries, has recently discovered the full extent of its vendor dependencies after a major vendor (let's call them "MegaSoft") announced a 340% license cost increase effective in 18 months. The vendor's products are deeply embedded across the organization: the ERP system managing $46 billion in annual transactions, the business intelligence platform used by 2,400 analysts, the collaboration suite used by 95,000 employees, the integration platform connecting 180 systems, and the cloud platform hosting 60% of workloads.

The total annual spend with MegaSoft is $290 million, which would increase to approximately $986 million under the new pricing. The CFO has declared this "an existential cost threat" and demanded alternatives. However, the CTO's initial assessment reveals that migrating away from MegaSoft would take 3-5 years and cost an estimated $800 million in migration and retraining expenses, with significant operational risk during the transition.

The Architecture Board has been asked to develop a strategy that addresses the immediate pricing crisis while establishing long-term vendor diversification. The challenge is that MegaSoft's products are not just tools—they are deeply integrated with each other, and the organization's business processes have been designed around MegaSoft-specific capabilities. Additionally, 12,000 employees have MegaSoft-specific skills and certifications.

### Question 4
What is the BEST architectural strategy for GlobalRetail to address the vendor lock-in crisis?

a) Immediately begin migrating all MegaSoft systems to open-source alternatives to eliminate vendor dependency entirely, accepting the short-term disruption for long-term freedom.

b) Apply TOGAF Phase E (Opportunities and Solutions) and Phase F (Migration Planning) to develop a strategic vendor diversification architecture. First, conduct a dependency analysis categorizing all MegaSoft touchpoints by criticality, migration complexity, and available alternatives—creating a formal Architecture Requirements Specification that distinguishes between "must migrate immediately" (cost-driven), "should migrate medium-term" (strategic), and "acceptable to retain" (where MegaSoft provides genuine best-in-class value). Develop a negotiation-informed Transition Architecture: use the migration plan as leverage in MegaSoft pricing negotiations while simultaneously executing on diversification. Define Architecture Principles for vendor independence going forward (e.g., "favor open standards," "abstraction layers at vendor boundaries," "no single vendor >40% of IT spend"). Sequence migrations using TOGAF's Implementation Factor Assessment: prioritize migrations where alternatives are mature and risk is low (e.g., collaboration suite to Google Workspace), defer where alternatives are immature or risk is high (e.g., ERP migration). Establish architecture compliance reviews ensuring no new MegaSoft dependencies are created without Architecture Board approval. Include workforce transformation in the roadmap, addressing the 12,000 employees' skill transition.

c) Accept the price increase and negotiate the best possible multi-year deal with MegaSoft, as the migration cost and risk outweigh the licensing increase, and focus the architecture team on optimizing usage to reduce costs within the MegaSoft ecosystem.

d) Split the migration into two tracks: immediately migrate the collaboration suite and BI platform (lower risk, many alternatives) while retaining MegaSoft for ERP and integration (higher risk to replace), without developing an overall architecture strategy for the transition.

---

## Scenario 5: Architecture Contract Negotiation

MetroTransit Authority, a public transportation agency operating buses, rail, and ferry services in a major metropolitan area, is undertaking a smart transportation initiative. The initiative involves deploying IoT sensors across 4,500 vehicles and 380 stations, implementing a real-time passenger information system, creating an integrated fare payment platform, and building a data analytics platform for route optimization.

The enterprise architecture team has developed the target architecture through ADM Phases A-D and is now entering Phase G (Implementation Governance). Four separate implementation projects have been approved, each managed by a different systems integrator (SI). The Chief Architect must establish Architecture Contracts with each SI to ensure their implementations conform to the target architecture.

The challenges are significant: SI-1 (IoT sensors) wants to use a proprietary IoT platform that locks MetroTransit into their ecosystem. SI-2 (passenger information) has proposed a design that diverges from the approved data architecture by creating a separate passenger database rather than using the shared data services. SI-3 (fare payment) is requesting changes to the target architecture to accommodate their existing product's limitations. SI-4 (analytics) wants to begin implementation before the data architecture is finalized, arguing that waiting will delay their project by six months.

The program director is pressuring the Chief Architect to be "flexible" and allow the SIs to proceed with their proposed approaches to avoid schedule delays.

### Question 5
What is the BEST approach for the Chief Architect to handle the Architecture Contract negotiations?

a) Accept all four SIs' proposed approaches to maintain the program schedule, as schedule delays are more costly than architectural deviations, and plan to address architectural inconsistencies in a future integration phase.

b) Establish formal Architecture Contracts using the TOGAF Architecture Contract template for each SI that clearly define: the conformance requirements each implementation must meet (referencing specific Architecture Building Blocks and standards from the target architecture), the permissible deviations with formal dispensation process (using the Architecture Compliance review framework), the non-negotiable architectural constraints (shared data services, open standards for IoT, target data architecture compliance), and the governance mechanisms for managing changes (Architecture Board review for any proposed architecture modifications). For each SI specifically: require SI-1 to use open IoT standards (MQTT, OPC-UA) with an abstraction layer, or demonstrate how their proprietary platform meets openness requirements; reject SI-2's separate database proposal as non-compliant with the data architecture and require conformance to shared data services; evaluate SI-3's requested changes through the ADM's Architecture Change Management process (Phase H) and approve only if they improve the overall architecture; and allow SI-4 to begin with a defined data interface contract that the analytics platform must conform to, with the understanding that implementation details may evolve as the data architecture is finalized. Formally document all decisions in the Architecture Governance Log.

c) Reject all deviations from the target architecture without discussion, as the architecture was approved through the ADM process and must be implemented exactly as specified, terminating contracts with any SI that refuses to comply.

d) Delegate the architecture compliance decisions to each project's solution architect, as they are closer to the implementation details and can make more informed decisions about what deviations are acceptable.

---

## Scenario 6: Compliance Assessment Findings Handling

Sovereign Wealth Management, a large financial services firm, has completed its first formal Architecture Compliance review of in-flight projects. The results have revealed significant findings across 12 active projects:

- **3 projects rated Non-Conformant:** These projects have made fundamental architectural decisions that contradict the approved enterprise architecture. Project Alpha deployed a separate customer database that duplicates master customer data. Project Beta implemented a custom authentication system instead of using the enterprise identity platform. Project Gamma bypassed the integration platform and created point-to-point interfaces with 7 external systems.

- **5 projects rated Consistent:** These projects are generally aligned with architectural direction but have notable gaps. They use approved technology standards but have not fully implemented the prescribed data governance patterns, and their security implementations vary from enterprise standards in minor but potentially significant ways.

- **4 projects rated Conformant:** These projects substantially conform to the architecture but have documented, justified deviations that were not formally approved through the dispensation process.

The Architecture Board must decide how to handle these findings. The business stakeholders sponsoring the three Non-Conformant projects argue that their projects are delivering critical business capabilities on time and on budget, and forcing architectural rework would delay delivery by 4-8 months. The Chief Risk Officer is alarmed by the compliance gaps, particularly around the customer data duplication and authentication deviations in a regulated financial services environment.

### Question 6
What is the BEST approach for the Architecture Board to handle these compliance assessment findings?

a) Require all 12 projects to halt and rework their implementations to achieve full conformance with the enterprise architecture before proceeding, as compliance in a regulated financial services environment is non-negotiable.

b) Apply TOGAF's Architecture Compliance framework with graduated responses based on compliance level and risk assessment. For the 3 Non-Conformant projects: conduct a formal risk assessment for each, distinguishing between compliance gaps that create regulatory or security risk (customer data duplication in Project Alpha, custom authentication in Project Beta) and those that create technical debt without immediate risk (point-to-point interfaces in Project Gamma). For Alpha and Beta, mandate remediation plans with defined timelines—Alpha must integrate with master customer data within 90 days post-go-live, Beta must migrate to the enterprise identity platform before production launch. For Gamma, accept the current implementation with a formal dispensation and include interface rationalization in the next architecture roadmap cycle. For the 5 Consistent projects: issue formal Architecture Compliance recommendations documenting the gaps and requiring remediation plans before their next release. For the 4 Conformant projects: retroactively formalize their deviations through the dispensation process, documenting the justification in the Governance Log to improve the dispensation process for future projects. Use all findings to update the Architecture Governance process—specifically, implement earlier compliance checkpoints (at Phase G entry rather than post-implementation) to catch deviations before they become costly to remediate. Present findings to the Architecture Board as lessons learned to improve the Architecture Contract process.

c) Accept all Non-Conformant projects as-is since they are delivering business value, and update the enterprise architecture to reflect what was actually implemented, as the architecture should follow reality rather than dictating it.

d) Escalate all Non-Conformant findings to the CEO and Board of Directors, recommending disciplinary action against the project managers and solution architects responsible for the deviations, as enforcement is necessary to establish architecture governance credibility.

---

## Scenario 7: Architecture Roadmap Prioritization

NextGen Healthcare Systems operates a network of 45 hospitals and 200 clinics. The enterprise architecture team has completed the Target Architecture across all four domains and identified 34 discrete work packages needed to move from the current state to the target state over a five-year period. The total estimated investment is $1.2 billion, but the Board has approved only $600 million for the first three years with a promise to review further funding based on demonstrated value.

The 34 work packages have been grouped into six themes:
1. **Electronic Health Record Modernization** (8 packages, $280M) - Replacing a 12-year-old EHR system
2. **Clinical Decision Support AI** (5 packages, $120M) - AI-driven diagnostics and treatment recommendations
3. **Patient Experience Digital** (6 packages, $95M) - Patient portal, telehealth, mobile app
4. **Revenue Cycle Optimization** (4 packages, $85M) - Billing, coding, claims management modernization
5. **Interoperability Platform** (7 packages, $150M) - HL7 FHIR-based health information exchange
6. **Cybersecurity Hardening** (4 packages, $70M) - Zero trust architecture, endpoint protection, SOC enhancement

Dependencies exist between themes: Clinical AI requires EHR modernization data, Patient Experience requires the Interoperability Platform, and Revenue Cycle needs updated interfaces from the new EHR. The CISO warns that delaying cybersecurity hardening increases breach risk (estimated $50M-$200M potential impact). Clinical leaders argue that Clinical AI could save lives and must be prioritized. The CFO wants Revenue Cycle first as it has the fastest ROI (estimated 280% return in 3 years).

### Question 7
What is the BEST approach for the enterprise architecture team to prioritize the architecture roadmap?

a) Prioritize based purely on financial ROI, sequencing Revenue Cycle Optimization first, as the CFO's analysis shows the fastest payback and the Board specifically wants demonstrated value to unlock further funding.

b) Apply TOGAF Phase F (Migration Planning) with the Implementation Factor Assessment and Deduction Matrix to systematically prioritize work packages. First, establish prioritization criteria spanning multiple dimensions: strategic alignment (Board objectives), dependency analysis (architectural prerequisites), risk (cybersecurity exposure, patient safety), financial return (ROI and cash flow), and organizational readiness. Develop a dependency map showing that EHR Modernization is a foundational prerequisite for Clinical AI and Revenue Cycle, and the Interoperability Platform is prerequisite for Patient Experience. Based on this analysis, construct a sequenced roadmap within the $600M three-year budget: Year 1 - begin EHR Modernization Phase 1 (core data model and integration layer), implement Cybersecurity Hardening (addressing immediate risk), and start Interoperability Platform foundation. Year 2 - complete EHR Modernization, begin Revenue Cycle Optimization (enabled by new EHR data), and begin Patient Experience (enabled by Interoperability). Year 3 - begin Clinical AI (enabled by modernized EHR data), complete Patient Experience, complete Revenue Cycle. Define each year-end as a Transition Architecture plateau that delivers measurable value to support the case for continued funding. Present the Board with clear value milestones at each plateau to build confidence for the remaining $600M investment.

c) Prioritize Clinical Decision Support AI first because it has the potential to save patient lives, and patient safety must always be the top priority in healthcare—financial and technical considerations are secondary.

d) Submit all 34 work packages to the Board for prioritization, as these are fundamentally business decisions that should not be made by the architecture team, and implement them in whatever order the Board decides.

---

## Scenario 8: Organizational Resistance to Architecture Governance

PrimeManufacturing Corp, a multinational industrial manufacturer with $18 billion in annual revenue, established an Enterprise Architecture practice 18 months ago. Despite executive sponsorship from the CIO, the practice is struggling with widespread resistance. Specific symptoms include:

- **Business unit autonomy:** The five business unit CIOs view enterprise architecture as "headquarters overhead" that slows down their ability to respond to market needs. They have collectively written a letter to the CEO arguing that the EA practice should be disbanded.
- **Shadow IT proliferation:** Since the EA governance process was introduced, the number of shadow IT projects has increased by 40%, with business units funding technology initiatives through operating budgets to avoid architecture reviews.
- **Project delays:** The architecture review process has added an average of 6 weeks to project timelines, and three critical projects missed market windows due to architecture compliance requirements.
- **Architect credibility:** Several enterprise architects have been criticized for lacking business understanding, with one business unit leader publicly stating that "the architects have never sold a product, manufactured a widget, or served a customer."
- **Governance fatigue:** Project managers report spending 15% of their time on architecture documentation and compliance activities, describing the governance as "bureaucratic theater."

The Chief Architect has been given 90 days to either fix the EA practice or face its dissolution. The CEO has stated: "I believe in enterprise architecture, but it needs to demonstrate value, not just process compliance."

### Question 8
What is the BEST approach for the Chief Architect to transform the EA practice and address organizational resistance?

a) Strengthen governance enforcement by mandating that no IT project over $100K can proceed without architecture approval, implementing penalties for shadow IT, and requiring the CEO to publicly endorse architecture governance at the next all-hands meeting, as the problem is one of authority and compliance.

b) Apply a comprehensive transformation of the EA practice using TOGAF's Architecture Governance framework and Architecture Capability concepts. First, diagnose the root cause: the EA practice has focused on governance process compliance rather than value delivery. Redesign the practice around four pillars:

**Value Demonstration (Weeks 1-4):** Identify 2-3 "quick wins" where architecture provides immediate, visible value to business units—such as resolving an integration challenge, reducing a technology cost, or accelerating a stalled project. Embed architects within business units for 30 days to build credibility and understand business context.

**Governance Streamlining (Weeks 3-6):** Redesign the architecture review process using a tiered approach based on project impact: lightweight review for small projects (1 week turnaround), standard review for medium projects (2 weeks), and deep review only for strategic investments. Implement the TOGAF Architecture Compliance framework with the defined compliance levels to replace binary pass/fail decisions with graduated guidance. Convert the governance process from a gate to a service—architecture reviews should add value through guidance, not just approval.

**Capability Building (Weeks 4-8):** Address the architect credibility gap by requiring all enterprise architects to complete rotations in business units. Recruit architects with business domain experience, not just technology backgrounds. Apply the TOGAF Architecture Skills Framework to assess and develop the team across all seven skill categories with emphasis on Business Skills and Methods, and General Skills (communication, leadership).

**Stakeholder Engagement (Ongoing):** Establish an Architecture Forum (not just an Architecture Board) that includes business unit representation. Use the TOGAF Stakeholder Management approach to identify each business unit CIO's specific concerns and address them directly. Create a quarterly Architecture Value Report that quantifies the business impact of architecture decisions (cost savings, risk reduction, time-to-market improvement). Address shadow IT not through prohibition but through making the architecture process more attractive than the alternative.

c) Dissolve the central EA practice and distribute architects to each business unit, allowing them to function as solution architects under business unit control, as the centralized model clearly isn't working for this organization.

d) Hire an external consulting firm to conduct an independent assessment of the EA practice and implement their recommendations, as the Chief Architect is too close to the problem to objectively evaluate and fix the practice.

---

## Answer Key

### Scenario 1 - Question 1: Telecommunications Network Modernization
**Scoring:**
- **Answer B = 5 points (Best):** This answer demonstrates comprehensive application of the TOGAF ADM to a complex, multi-domain transformation. The key insight is recognizing that network modernization is not just a technology project—it transforms business models (new 5G services require new revenue models, partnership ecosystems), data architecture (real-time network analytics, AI-driven operations), and application architecture (cloud-native OSS/BSS replaces legacy). The Architecture Landscape approach with Strategic, Segment, and Transition Architectures correctly partitions the work. Stakeholder Management across the four groups (Network Engineering, IT, Commercial, Regulatory) follows TOGAF's guidance on aligning diverse stakeholder concerns through a shared Architecture Vision. Formally capturing regulatory and service continuity constraints in the Architecture Requirements Specification ensures non-negotiable requirements are protected throughout the five-year program.
- **Answer A = 3 points:** Recognizes the technology complexity, and Phase D (Technology Architecture) is certainly critical for a network transformation. However, focusing exclusively on technology ignores the business, data, and application architecture dimensions that are equally important. TOGAF's ADM explicitly covers all four domains because they are interdependent—you cannot design the 5G network architecture without understanding the new business services it must support.
- **Answer C = 1 point:** Vendor reference architectures are valuable inputs to architecture development, but delegating architecture decisions to a vendor creates single-vendor dependency and ignores the multi-vendor reality (14 current vendors). TOGAF's vendor-neutral approach is specifically designed to prevent this type of vendor lock-in. The Chief Architect must maintain ownership of architecture decisions.
- **Answer D = 0 points:** Breaking the program into vendor-by-vendor replacement projects ignores the fundamental architectural interdependencies between network elements. The 45,000 integration points mean that changes to one vendor's systems cascade across the network. This approach would result in 14 isolated projects with no overall architectural coherence, likely causing massive integration failures.

### Scenario 2 - Question 2: 5G Architecture Decisions
**Scoring:**
- **Answer B = 5 points (Best):** This answer demonstrates masterful application of TOGAF's Transition Architecture concept. Rather than choosing between two binary options, it creates a sequenced architectural pathway that addresses all stakeholder concerns: competitive urgency (NSA launch in Phase 1), enterprise revenue (SA with network slicing in Phase 2 targeting the three critical contracts), and long-term architectural soundness (complete SA migration in Phase 3). The use of Architecture Decision Records to document rationale and trade-offs, and architecture compliance criteria to prevent the NSA deployment from complicating SA migration, are sophisticated governance mechanisms directly from TOGAF. Each plateau being "independently stable" is a fundamental Transition Architecture principle.
- **Answer C = 3 points:** Option Alpha (SA) is architecturally the cleanest solution and would avoid technical debt—this is a legitimate architectural argument. However, ignoring the competitive and commercial realities (lost market share, $180M enterprise contracts at risk) demonstrates a common architecture anti-pattern of pursuing architectural purity at the expense of business value. TOGAF explicitly recognizes that architecture must balance idealism with pragmatism.
- **Answer A = 1 point:** Option Beta (NSA) addresses the time-to-market concern but accepts significant technical debt without a plan to address it. "Deferring to a future ADM cycle" is vague and doesn't address the enterprise customers' network slicing requirement. In TOGAF terms, this answer identifies one Transition Architecture but fails to define the complete transition pathway to the target state.
- **Answer D = 0 points:** Creating a dual regional architecture with different approaches (NSA in urban, SA in rural) would result in the worst of both worlds: the complexity of managing two architectures with none of the benefits of a coherent transition strategy. This approach ignores network architecture fundamentals (subscribers roam between urban and rural areas) and would double operational complexity.

### Scenario 3 - Question 3: Multi-Cloud Strategy
**Scoring:**
- **Answer B = 5 points (Best):** This answer applies TOGAF's Architecture Principles, Technology Reference Model (TRM), Standards Information Base, and Transition Architecture concepts to a modern cloud architecture challenge. The tiered approach is strategically sound: Tier 1 (portability for infrastructure) addresses the Board's customer sovereignty and negotiating leverage concerns; Tier 2 (strategic dependency acceptance) preserves competitive advantage from cloud-native services; Tier 3 (cloud-agnostic for new services) prevents future lock-in. Using the TRM to classify services and the Standards Information Base for approved services on each platform provides operational governance. The Transition Architecture sequences work by customer demand priority, ensuring the portability investment delivers business value. Architecture Decision Records documenting portability vs. performance trade-offs create transparent governance.
- **Answer D = 3 points:** The "best of breed" approach achieves natural vendor diversification, which partially addresses the Board's concerns about concentration risk and negotiating leverage. However, without a portability layer or architecture strategy, each new deployment creates its own cloud-native dependency, making it impossible to move workloads between clouds for customer sovereignty or resilience. This addresses the symptom (single vendor) without solving the underlying problem (lock-in).
- **Answer C = 1 point:** Challenging the multi-cloud strategy and negotiating with AWS shows pragmatic thinking about cost-benefit analysis. However, this ignores the Board's customer sovereignty concern (government and financial services customers requiring specific clouds), which is a non-negotiable business requirement, not a cost optimization question. An architect who cannot address the Board's stated requirements will lose credibility.
- **Answer A = 0 points:** A complete "lift and shift" to cloud-agnostic services would sacrifice the performance and innovation benefits of cloud-native services, costing far more than the estimated 18 months and $84M in engineering effort. This extreme approach would likely damage product quality and innovation velocity, undermining InfraCore's competitive position in the enterprise software market.

### Scenario 4 - Question 4: Vendor Lock-in Mitigation
**Scoring:**
- **Answer B = 5 points (Best):** This answer applies TOGAF Phase E (Opportunities and Solutions) and Phase F (Migration Planning) to develop a comprehensive vendor diversification strategy. The categorization of MegaSoft touchpoints by criticality, complexity, and alternatives creates a rational basis for prioritization—directly applying TOGAF's gap analysis approach. Using the migration plan as negotiation leverage is strategically sophisticated and addresses the immediate pricing crisis. The Architecture Principles for vendor independence ("favor open standards," "abstraction layers," "no single vendor >40%") establish long-term governance. The Implementation Factor Assessment from Phase F provides a structured framework for sequencing migrations. Including workforce transformation recognizes that architecture change is not just about technology. The compliance review preventing new dependencies without Board approval applies TOGAF governance to the ongoing operational environment.
- **Answer C = 3 points:** Accepting the price increase and negotiating is a pragmatic option that avoids migration risk and disruption. In TOGAF terms, this represents a valid architectural decision if the risk/benefit analysis supports it. However, it doesn't address the underlying strategic vulnerability of extreme vendor dependency, and a 340% price increase signals a vendor relationship that will only become more adversarial. This answer treats the symptom without addressing the structural problem.
- **Answer D = 1 point:** Splitting into two tracks shows some architectural thinking by distinguishing between lower-risk and higher-risk migrations. However, proceeding "without developing an overall architecture strategy" contradicts fundamental TOGAF principles. Without an enterprise-level architecture guiding both tracks, the migrations may create new integration challenges and fail to establish the vendor independence principles needed to prevent future lock-in.
- **Answer A = 0 points:** Immediately migrating everything to open-source ignores the complexity, cost, risk, and feasibility assessment that TOGAF's ADM requires. A $800M migration executed urgently would likely result in massive disruption to $46B in annual transactions. Open-source alternatives may not exist for all MegaSoft capabilities, and the 12,000 employees' skill gap would create operational risk. This approach prioritizes ideology over practical architecture.

### Scenario 5 - Question 5: Architecture Contract Negotiation
**Scoring:**
- **Answer B = 5 points (Best):** This answer directly applies TOGAF's Architecture Contract concept and Architecture Compliance framework in a practical, nuanced way. The contract template with conformance requirements referencing specific Architecture Building Blocks creates clear, measurable compliance criteria. The dispensation process provides a formal mechanism for managing necessary deviations. The non-negotiable constraints (shared data services, open standards) protect architectural integrity on critical points. The specific guidance for each SI is well-calibrated: requiring open standards from SI-1 while allowing proprietary implementation if openness requirements are met; rejecting SI-2's duplicate database as a genuine architecture violation; evaluating SI-3's changes through Architecture Change Management (Phase H), which is the correct TOGAF mechanism for proposed architecture modifications; and allowing SI-4 to proceed with defined interface contracts—a pragmatic approach that maintains architecture direction while accommodating timeline realities. Documenting everything in the Governance Log creates the audit trail needed for public sector accountability.
- **Answer C = 3 points:** Maintaining architectural integrity by enforcing conformance is a legitimate position, and TOGAF does establish the Architecture Board's authority to mandate compliance. However, a rigid "comply or be terminated" approach in a public sector context with contracted SIs would likely result in contract disputes, delays, and cost overruns that exceed the cost of managed architectural compromise. Effective architecture governance requires balancing purity with pragmatism.
- **Answer D = 1 point:** Solution architects do have implementation-level knowledge valuable for compliance decisions. However, delegating enterprise architecture compliance to project-level architects undermines the governance framework. Solution architects optimizing for their individual project may accept deviations that create system-wide integration problems—exactly the scenario described with SI-2's separate database.
- **Answer A = 0 points:** Accepting all deviations to maintain schedule directly contradicts the purpose of Architecture Contracts and Implementation Governance (Phase G). In a public transportation context, allowing a proprietary IoT platform (SI-1) and duplicate passenger database (SI-2) would create vendor lock-in and data quality issues that could affect passenger safety. Deferring integration problems to "a future phase" is a common anti-pattern that typically results in exponentially more expensive remediation.

### Scenario 6 - Question 6: Compliance Assessment Findings Handling
**Scoring:**
- **Answer B = 5 points (Best):** This answer demonstrates sophisticated application of TOGAF's Architecture Compliance framework with graduated, risk-based responses. The key differentiation between compliance gaps that create regulatory/security risk versus those that create technical debt is critical in financial services. The specific, measurable remediation requirements (Alpha: 90-day integration timeline, Beta: pre-production migration) are actionable and enforceable. Accepting Gamma's point-to-point interfaces with formal dispensation is pragmatic—the interfaces work and the cost of immediate rework exceeds the technical debt. For Consistent projects, requiring remediation plans before next release balances cost with compliance improvement. Retroactively formalizing Conformant deviations improves governance process maturity. The most valuable insight is the process improvement recommendation: implementing earlier compliance checkpoints at Phase G entry rather than post-implementation prevents the very problems discovered. This transforms the compliance assessment from a punitive exercise into a governance improvement opportunity.
- **Answer A = 3 points:** In a regulated financial services environment, compliance is genuinely important, and this answer reflects the Chief Risk Officer's valid concerns. However, halting all 12 projects (including the 4 that are Conformant and 5 that are Consistent) is disproportionate and would create massive business disruption. TOGAF's compliance framework explicitly defines graduated compliance levels to enable nuanced responses, not binary stop/go decisions.
- **Answer C = 1 point:** "Accepting reality" and updating the architecture to match implementations is sometimes appropriate (TOGAF's Phase H addresses architecture changes driven by implementation experience). However, in a regulated financial services environment, accepting a custom authentication system and duplicate customer data as "the new architecture" would create compliance and regulatory risks. Architecture should guide implementation, not simply document whatever was built.
- **Answer D = 0 points:** Escalating to the CEO with disciplinary recommendations would destroy any remaining goodwill toward the EA practice. Architecture governance is about guiding and improving, not punishing. This approach would ensure that future deviations are hidden rather than reported, making the compliance problem worse. TOGAF's governance framework emphasizes collaboration and value, not enforcement through punishment.

### Scenario 7 - Question 7: Architecture Roadmap Prioritization
**Scoring:**
- **Answer B = 5 points (Best):** This answer correctly applies TOGAF Phase F (Migration Planning) with the Implementation Factor Assessment and Deduction Matrix—the specific TOGAF tools designed for exactly this challenge. The multi-dimensional prioritization criteria (strategic alignment, dependencies, risk, ROI, readiness) balance the competing stakeholder concerns rather than optimizing for a single dimension. The dependency analysis revealing EHR as a prerequisite for Clinical AI and Revenue Cycle, and Interoperability as a prerequisite for Patient Experience, is critical—it means you cannot simply prioritize by ROI because Revenue Cycle depends on EHR. Including Cybersecurity Hardening in Year 1 addresses the CISO's risk concern within the $600M constraint. Defining each year-end as a Transition Architecture plateau with measurable value supports the Board's requirement to see demonstrated value before approving additional funding. This answer demonstrates that architecture is not just about what to build, but in what order, based on dependencies and constraints.
- **Answer A = 3 points:** Revenue Cycle Optimization has the best ROI and the Board wants demonstrated value—this is a rational financial argument. However, Revenue Cycle depends on updated interfaces from the new EHR, which means starting Revenue Cycle first would require expensive temporary interfaces or a significantly delayed timeline. Ignoring architectural dependencies to chase ROI is a common planning failure that TOGAF's dependency analysis is designed to prevent.
- **Answer C = 1 point:** Patient safety is a legitimate priority in healthcare, and Clinical AI's potential to save lives is a compelling argument. However, Clinical AI has a hard dependency on EHR Modernization data—you cannot deploy AI diagnostics on a 12-year-old data platform. This answer prioritizes the right capability for the wrong reasons while ignoring the prerequisite dependencies that make early Clinical AI deployment impractical.
- **Answer D = 0 points:** Submitting all 34 work packages to the Board without architecture analysis abdicates the architecture team's core responsibility. Boards cannot effectively evaluate technical dependencies, architectural prerequisites, or implementation sequencing. TOGAF explicitly positions the architecture team as responsible for providing prioritized, dependency-aware roadmaps—that is the value they add. Asking the Board to do the architects' job demonstrates a failure to understand the EA role.

### Scenario 8 - Question 8: Organizational Resistance to Architecture Governance
**Scoring:**
- **Answer B = 5 points (Best):** This answer demonstrates a comprehensive, evidence-based transformation of the EA practice using multiple TOGAF concepts. The diagnosis that the practice focused on process compliance rather than value delivery identifies the root cause accurately. The four-pillar approach is well-structured:

  **Value Demonstration** addresses the CEO's mandate ("demonstrate value") through quick wins that build credibility. Embedding architects in business units directly addresses the "never served a customer" criticism by building business context.

  **Governance Streamlining** applies TOGAF's Architecture Compliance framework with graduated compliance levels (replacing binary pass/fail), and the tiered review process based on project impact addresses the 6-week delay complaint while maintaining governance for strategic investments. Converting from gate to service is a fundamental shift in EA operating model.

  **Capability Building** applies the TOGAF Architecture Skills Framework (seven categories) to address the architect credibility gap, specifically emphasizing Business Skills and Methods and General Skills.

  **Stakeholder Engagement** applies TOGAF's Stakeholder Management approach and addresses shadow IT through attraction rather than prohibition—a mature governance approach.

  The 90-day timeline with defined milestones demonstrates that this is an executable plan, not an abstract strategy.
- **Answer C = 3 points:** Distributing architects to business units would address the "headquarters overhead" perception and build business domain knowledge. In TOGAF terms, this shifts from a centralized to a federated EA operating model—a legitimate architectural choice. However, dissolving the central practice entirely eliminates the enterprise-level perspective that prevents silos and duplication. A hybrid model (central strategy, federated delivery) would be better, which answer B achieves through the embedding approach.
- **Answer D = 1 point:** External assessment can provide objectivity, but this defers action for 90 days (the assessment itself would consume the available time) and signals to the organization that the Chief Architect cannot solve the problem. In a credibility crisis, bringing in consultants typically reinforces the perception that the EA practice cannot deliver value independently.
- **Answer A = 0 points:** Strengthening enforcement when the current governance is already perceived as "bureaucratic theater" would dramatically worsen the resistance. Mandating penalties for shadow IT would drive shadow IT further underground rather than eliminating it. Having the CEO publicly endorse architecture governance would spend political capital without addressing the fundamental value delivery problem. This approach treats the symptoms (non-compliance) rather than the disease (governance that doesn't deliver value).

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
