# TOGAF Part 2 Certified - Practice Test 44: The Governance Gauntlet
## Difficulty: EXPERT
**Time Allowed:** 90 minutes | **Questions:** 8 | **Pass Mark:** 60% (24/40)

> **Note:** Expert-level difficulty. Every scenario involves a complex GOVERNANCE challenge requiring deep understanding of TOGAF Architecture Governance principles. Designed to be significantly harder than the actual exam.

---

## Scenario 1: Governance vs. Agility

**FastTech Solutions** is a rapidly growing software company with 2,000 employees and 45 active software projects. The company adopted TOGAF three years ago and established a formal Architecture Governance framework including an Architecture Board, compliance review processes, and architecture principles. The governance framework was designed when the company had 500 employees and 12 projects.

The PMO has raised an urgent concern: the current Architecture Governance process adds an average of 30% to project delivery timelines. Every project must undergo a full architecture compliance review at four checkpoints (Phase A approval, Phase D completion, Phase F approval, Phase G implementation review). Each review cycle takes 2-3 weeks because the Architecture Board meets only biweekly and has a backlog of 15 projects awaiting review.

The PMO Director presents data: competitor companies using lightweight governance deliver features 40% faster. Three high-priority projects missed market windows last quarter because of governance delays. The company's most talented developers are threatening to leave, citing governance overhead as "bureaucratic waste." The CEO has publicly stated the company must be "agile and fast."

Meanwhile, the Chief Architect presents counter-evidence: last year, the governance process caught 23 architecture-significant issues before they reached production, including a data security vulnerability that would have exposed customer data. Two projects that received governance dispensations to "fast-track" subsequently required expensive rework.

The Architecture Board must balance governance rigor with delivery agility.

### Question 1
How should the Architecture Board restructure governance to balance rigor with agility?

a) Eliminate the formal Architecture Compliance review process entirely and replace it with post-implementation architecture audits. Projects can self-certify compliance during development, and the architecture team will conduct audits quarterly to identify issues. This maximizes delivery speed while maintaining eventual oversight.

b) Implement a risk-based, tiered governance model. Classify projects into three tiers based on architecture impact: Tier 1 (high impact: new platforms, cross-cutting changes, security-sensitive) gets full governance with Architecture Board review at all checkpoints. Tier 2 (medium impact: significant feature additions, integration changes) gets streamlined governance with Architecture Board review only at Phase A and Phase G checkpoints. Tier 3 (low impact: minor enhancements, bug fixes, cosmetic changes) gets delegated governance with architect-level sign-off and periodic spot-check audits. Additionally, increase Architecture Board meeting frequency, establish a standing sub-committee for expedited reviews, and create architecture guardrails (automated compliance checks) that enable continuous compliance without manual review bottlenecks.

c) Maintain the current governance process but hire additional architects to reduce the review backlog. The 30% timeline increase is acceptable because the governance process has proven its value by catching 23 issues. The PMO's comparison with competitors is misleading because those competitors likely have hidden technical debt.

d) Transfer governance authority to individual project architects and dissolve the central Architecture Board. Decentralized governance allows each project to make architecture decisions at the speed required by the business. The Chief Architect can serve in an advisory capacity without approval authority.

### Question 2
How should the Architecture Board address the specific concern about high-priority projects missing market windows due to governance delays?

a) Grant a blanket dispensation for all projects classified as "high-priority" by the PMO. High-priority projects should be exempt from architecture governance to ensure they meet market deadlines.

b) For the immediate backlog, implement an expedited review track: establish a two-person Architecture Board sub-committee empowered to conduct emergency reviews within 48 hours for business-critical projects. For long-term improvement, integrate architecture governance into the project lifecycle rather than treating it as a separate gate—embed architects within high-priority project teams to provide continuous architecture guidance, reducing the need for formal checkpoint reviews. Ensure all expedited reviews are documented in the Governance Log with rationale for the expedited process.

c) Require the PMO to submit project schedules that include governance review time from the outset. The problem is not governance overhead—it's inadequate project planning that doesn't account for mandatory governance activities.

d) Allow high-priority projects to proceed without architecture review but require them to purchase "architecture insurance"—a dedicated budget allocation for post-delivery architecture remediation.

---

## Scenario 2: The Expired Dispensation

**MedicalSystems Inc.** is a healthcare technology company that develops electronic health record (EHR) systems. Eighteen months ago, the Architecture Board granted a dispensation for the company's flagship EHR product to use a non-standard proprietary database engine instead of the enterprise-standard PostgreSQL. The dispensation was granted because the proprietary engine provided specialized healthcare data indexing capabilities that PostgreSQL lacked at the time, and the EHR product needed to meet a critical regulatory certification deadline.

The dispensation terms specified:
- Duration: 12 months (now expired by 6 months)
- Condition: The team must develop a migration plan to PostgreSQL within the dispensation period
- Review: Quarterly compliance updates to the Architecture Board

The current situation:
- The migration plan was never developed—the team claims they were too busy meeting regulatory requirements
- The proprietary database now stores 5 years of patient health records for 2 million patients
- 12 other applications have been built with integrations to the proprietary database
- The proprietary database vendor has been acquired by a competitor and licensing costs have tripled
- PostgreSQL has since added the healthcare indexing capabilities that originally justified the dispensation
- The CTO of the EHR division argues that migrating would risk patient data integrity and create regulatory re-certification requirements

### Question 3
What governance action should the Architecture Board take regarding the expired dispensation?

a) Retroactively extend the dispensation indefinitely. The system is too deeply embedded to change, and attempting to enforce compliance would risk patient data safety. The Architecture Board should accept the reality and update the enterprise standards to include the proprietary database as an approved alternative.

b) Formally acknowledge the dispensation breach and conduct a thorough impact assessment. Establish a remediation governance process: require the EHR team to develop a comprehensive migration plan with realistic timelines (acknowledging the 2M patient record migration complexity), interim risk mitigation measures (for tripled licensing costs and vendor acquisition risks), and a phased transition approach that maintains regulatory compliance throughout. Issue a new, time-bound dispensation with strict milestones, quarterly Architecture Board reviews, and explicit consequences for non-compliance. Document lessons learned to strengthen the dispensation monitoring process. Record all decisions in the Governance Log.

c) Immediately declare the EHR product non-conformant and mandate a 6-month migration to PostgreSQL. The team violated the dispensation terms by not developing a migration plan, and the Architecture Board must enforce compliance to maintain governance credibility. Any delay signals that dispensation conditions are optional.

d) Dissolve the dispensation and transfer the EHR product governance to the CTO of the EHR division. Since the technical team understands the risks best, they should self-govern the database technology decision without Architecture Board oversight.

### Question 4
How should the Architecture Board address the systemic governance failure of the dispensation conditions not being monitored?

a) No action is needed. Dispensation monitoring is the responsibility of the team that received the dispensation, not the Architecture Board.

b) Conduct a governance process review to strengthen dispensation management. Establish mandatory dispensation tracking mechanisms: create a dispensation registry in the Governance Log with automated milestone alerts, assign a designated Architecture Board member as sponsor for each active dispensation, implement mandatory quarterly dispensation compliance reports with Architecture Board review, define escalation triggers for missed milestones, and establish clear consequences for repeated non-compliance with dispensation conditions. Apply these improvements to all existing and future dispensations across the organization.

c) Issue a formal reprimand to the EHR team for violating the dispensation conditions. Personal accountability is the best way to ensure future compliance with governance processes.

d) Eliminate the dispensation mechanism entirely. If dispensation conditions cannot be enforced, the Architecture Board should only issue binary decisions: conform or reject. This simplifies governance and eliminates the monitoring burden.

---

## Scenario 3: Overlapping Architecture Programs

**ConglomerateX** is a multinational corporation with three concurrent enterprise architecture programs:

**Program Alpha:** A customer experience transformation led by the Chief Marketing Officer, using the ADM to develop a new omnichannel architecture. Currently in Phase C (Application Architecture). Budget: $30M. Team: 15 architects.

**Program Beta:** A supply chain modernization initiative led by the Chief Operations Officer, using the ADM to redesign the logistics and procurement architecture. Currently in Phase E (Opportunities and Solutions). Budget: $25M. Team: 10 architects.

**Program Gamma:** A data analytics and AI platform program led by the Chief Data Officer, using the ADM to build an enterprise-wide data and analytics architecture. Currently in Phase B (Business Architecture). Budget: $40M. Team: 20 architects.

The Chief Architect has identified critical problems:
- Programs Alpha and Gamma both plan to build customer data platforms with overlapping data entities
- Programs Beta and Gamma both require real-time data streaming infrastructure but have specified different technologies
- Programs Alpha and Beta both plan to implement new integration middleware but have selected competing products
- All three programs claim priority for the same infrastructure team's capacity in Q3
- The three program leads do not regularly communicate and each views their program as the most strategically important

### Question 5
What governance coordination strategy should the Architecture Board implement?

a) Cancel the two smaller programs (Alpha and Beta) and consolidate all architecture work under Program Gamma since it has the largest budget and broadest scope. A single program eliminates coordination overhead and prevents overlapping work.

b) Establish a cross-program architecture governance mechanism. Create an Architecture Integration Board (a sub-committee of the Architecture Board) with representatives from all three programs that meets weekly. This board should: identify all overlapping scope areas and create a shared architecture domain map, mandate common solutions for shared infrastructure needs (data platform, streaming, integration middleware), establish a shared Architecture Requirements Specification for cross-cutting components, use the Architecture Roadmap to coordinate sequencing and resolve resource conflicts, require each program to update the shared Architecture Repository with artifacts classified at the appropriate Enterprise Continuum and Architecture Landscape levels, and escalate unresolved conflicts to the full Architecture Board for decision. Maintain each program's independence for domain-specific architecture decisions while governing shared concerns centrally.

c) Allow the three programs to continue independently and resolve conflicts during Phase G implementation governance. Architecture conflicts are best resolved during implementation when the actual technical constraints are clear, not during architecture development when decisions are still theoretical.

d) Require all three programs to pause and consolidate their Architecture Visions into a single enterprise-wide Architecture Vision before proceeding. Without a unified vision, the three programs will inevitably create conflicting architectures.

### Question 6
How should the Architecture Board resolve the immediate conflict of all three programs competing for the same infrastructure team's capacity in Q3?

a) Allow the programs to negotiate among themselves. Resource allocation is a PMO responsibility, not an Architecture Board concern.

b) Use architecture governance to inform the resource allocation decision. The Architecture Board should assess the architecture dependencies between the three programs: determine which program's Q3 deliverables create the foundation that other programs depend on, evaluate the architectural risk of delaying each program, consult the Architecture Roadmap to determine the optimal sequencing, and make a governance recommendation to the executive team (not a unilateral decision) about resource prioritization based on architectural dependencies and enterprise impact. Document the rationale in the Governance Log and ensure the affected programs update their Architecture Roadmaps accordingly.

c) Give priority to the program with the largest budget (Program Gamma at $40M) since it represents the most significant enterprise investment and therefore has the highest strategic importance.

d) Split the infrastructure team equally among all three programs. Equal allocation is the fairest approach and prevents any program from claiming preferential treatment.

---

## Scenario 4: The Paper Tiger Governance Framework

**OldGuard Financial** is a 150-year-old financial services institution. Five years ago, the company invested $5M in establishing an enterprise architecture practice. A comprehensive Architecture Governance Framework was developed including: an Architecture Board charter, architecture principles, compliance review procedures, dispensation processes, an Architecture Repository, and a Tailored Architecture Framework based on TOGAF.

The problem: nobody follows it. A recent internal audit revealed:
- Only 3 of 47 IT projects in the past year underwent architecture compliance review
- The Architecture Board has not met in 8 months
- Architecture Principles are documented but unknown to 90% of project managers
- The Architecture Repository has not been updated in 2 years
- Individual business units make technology decisions without architecture consultation
- The company has accumulated $200M in technical debt due to uncoordinated technology decisions

The CEO is frustrated and is considering disbanding the enterprise architecture practice entirely as a "failed experiment." The CTO (who champions EA) has 90 days to demonstrate the value of architecture governance or the practice will be shut down.

### Question 7
What culture change strategy should the CTO implement using TOGAF guidance?

a) Immediately enforce mandatory architecture compliance for all projects. Issue a CEO-level mandate requiring architecture review for every IT investment over $100K. Non-compliant projects will be shut down. Strict enforcement will establish the governance culture.

b) Implement a phased governance revival with a focus on demonstrating value. Phase 1 (Month 1): Reconvene the Architecture Board with refreshed membership including influential business leaders, not just IT representatives. Select 2-3 high-visibility projects as "architecture governance pilots" and provide hands-on architecture support that demonstrably improves their outcomes. Phase 2 (Month 2): Use pilot successes to build credibility. Conduct architecture reviews for the top 10 most expensive current projects, producing actionable recommendations that reduce cost or risk. Publish a brief "Architecture Governance Value Report" showing quantified benefits. Phase 3 (Month 3): Present results to the CEO with a proposal for graduated governance expansion. Re-introduce risk-based compliance tiers (not mandating full review for everything) and implement governance processes that integrate into existing project management workflows rather than creating parallel bureaucracy. Throughout all phases, focus on making governance helpful rather than obstructive—architects should be seen as enablers, not gatekeepers.

c) Redesign the governance framework from scratch. The current framework clearly doesn't work, so the CTO should spend the 90 days developing a new, lighter-weight governance approach and present it to the CEO as the "next generation" of architecture governance.

d) Commission an external consulting firm to implement architecture governance. Internal staff have failed to establish governance culture, and an external firm brings the authority and independence needed to enforce compliance across business units.

### Question 8
How should the Architecture Board address the fact that business units make technology decisions without architecture consultation?

a) Issue a governance policy prohibiting business units from making any technology decisions without Architecture Board approval. Enforce compliance through budget controls—no technology procurement without architecture sign-off.

b) Establish architecture engagement touchpoints that integrate with existing business decision-making processes. Identify the key decision points where business units make technology choices (vendor selection, RFP development, project initiation, budget approval) and embed architecture input at those points. Provide business-friendly architecture guidance (reference architectures, approved technology catalogs, decision frameworks) that helps business units make informed decisions quickly. Create a "Architecture Advisory" service where business units can request lightweight architecture guidance without triggering a full compliance review. Over time, demonstrate the value of architecture input through improved outcomes (cost savings, reduced integration issues, faster delivery) which naturally increases voluntary engagement.

c) Accept that business units will make independent technology decisions and position the architecture team as a cleanup crew that retrospectively aligns non-conformant decisions with the enterprise architecture.

d) Require each business unit to hire its own enterprise architect who reports to the Chief Architect. Embedded architects will ensure architecture governance happens naturally within each business unit.

---

## Scenario 5: The Profitable Rogue System

**TradeFlow Corp** is a commodities trading firm. A compliance assessment has revealed that the company's most profitable product line—an algorithmic trading platform generating $500M in annual revenue—was built entirely outside architecture governance. The platform was developed by a small team of quantitative developers who intentionally avoided architecture review because they believed it would slow them down.

The assessment shows:
- The platform uses no enterprise-standard technologies (custom databases, proprietary messaging, non-standard APIs)
- There is no documentation—no architecture artifacts, no design documents, no operational runbooks
- The platform has a single point of failure—only 3 developers understand the codebase
- The platform processes $10B in daily trading volume with no disaster recovery plan
- Despite these issues, the platform has had 99.97% uptime for 3 years and is the company's highest-performing system
- The trading desk VP fiercely protects the team from "corporate interference" and has the CEO's ear

### Question 9
What governance approach should the Architecture Board take with the rogue trading platform?

a) Immediately mandate full architecture compliance. The platform represents an unacceptable enterprise risk regardless of its profitability. Require the development team to halt new feature development and spend 6 months documenting and conforming the platform to enterprise standards.

b) Apply a risk-based governance approach that recognizes both the platform's value and its risks. Conduct an architecture assessment (not compliance review) to understand the platform's architecture, document its actual architecture retroactively, and quantify the enterprise risks (single point of failure, key-person dependency, no DR plan). Present findings to the Architecture Board and the executive team together—frame the conversation around risk management, not compliance punishment. Propose a phased remediation: immediate priority on disaster recovery and documentation (risk mitigation), medium-term priority on reducing key-person dependency through knowledge transfer and code documentation, longer-term integration of the platform with enterprise monitoring, security, and data governance. Do NOT require technology migration to enterprise standards unless specific risks justify it—the platform's non-standard technology stack is a compliance issue but not necessarily an architectural risk if properly managed. Engage the trading desk VP as a stakeholder, not an adversary.

c) Grant the platform a permanent exemption from architecture governance. It's clearly successful, and attempting to impose governance will damage the company's most profitable product. Architecture governance should focus on underperforming systems that need improvement.

d) Report the governance gap to the external regulators and the board of directors. A $10B daily trading volume platform without disaster recovery and documentation represents a regulatory compliance failure that supersedes internal architecture governance.

### Question 10
How should the Architecture Board engage the resistant trading desk VP?

a) Escalate to the CEO to mandate the trading desk VP's cooperation. The CEO's authority is the only way to overcome the VP's resistance to architecture governance.

b) Approach the VP with a value proposition framed in terms the VP cares about: business continuity and revenue protection. Present the risks in business terms: "If two of the three developers leave, how quickly can operations resume?" "If the custom database fails, what's the revenue impact per hour of downtime?" "What happens when regulators ask for trading system documentation?" Position architecture governance as protecting the VP's $500M revenue stream, not controlling it. Propose a collaborative engagement where the architecture team provides support (disaster recovery planning, documentation assistance, capacity planning) that directly benefits the platform, rather than imposing constraints that slow development. Invite the VP to join the Architecture Board as a member, giving them influence over governance processes rather than being subject to them.

c) Bypass the VP and work directly with the three developers. They understand the technical risks better than the VP and may be more receptive to governance once they understand the personal liability they face.

d) Wait for a failure event. When the platform eventually experiences a major incident (and it will, given the single point of failure), the VP will voluntarily seek architecture governance support. Forcing governance before a crisis will only create organizational conflict.

---

## Scenario 6: Architecture Capability Succession Crisis

**GlobalEnergy** is an energy company whose enterprise architecture practice has been led by a visionary Chief Architect for 12 years. Under her leadership, the practice achieved Level 4 maturity, with a comprehensive Architecture Repository, well-established governance processes, active Architecture Board, and a team of 25 architects.

The Chief Architect is retiring in 6 months. The succession situation is dire:
- No formal succession plan exists
- The Deputy Chief Architect left 2 years ago and was never replaced
- 60% of the architecture team's institutional knowledge exists only in the Chief Architect's head
- Key governance relationships (with the Architecture Board, business unit leaders, the CIO) are personal relationships built by the Chief Architect over 12 years
- The Architecture Board chair (CIO) is concerned that the architecture practice will collapse after the retirement
- Two senior architects are competing for the role but neither has the Chief Architect's strategic vision or stakeholder relationships
- The Tailored Architecture Framework was personally designed by the Chief Architect and has never been formally documented

### Question 11
How should the organization ensure architecture capability continuity using TOGAF guidance?

a) Hire an external Chief Architect with TOGAF certification and enterprise architecture experience. An external hire brings fresh perspective and the skills needed to lead the practice. Internal candidates clearly lack the necessary capabilities.

b) Implement a structured capability transfer and succession plan over the remaining 6 months. Knowledge capture: Have the Chief Architect formally document the Tailored Architecture Framework, governance relationships, decision-making rationale for key architecture decisions, and institutional knowledge in the Architecture Repository. Governance formalization: Transition personal governance relationships into formal governance processes—ensure the Architecture Board charter, stakeholder engagement processes, and escalation procedures are documented and can function independently of any individual. Leadership development: Have the retiring Chief Architect mentor both senior architect candidates, gradually transfer responsibilities, and have each candidate lead significant architecture engagements independently. Organizational structure: Re-establish the Deputy Chief Architect role immediately and appoint the stronger internal candidate, with the Chief Architect providing coaching. Stakeholder transition: Schedule joint meetings where the Chief Architect introduces the successor to key stakeholders and transfers relationship context. Architecture Board role: Strengthen the Architecture Board's governance independence so it can maintain continuity even during leadership transition.

c) Promote the more senior of the two internal candidates immediately and let them learn on the job. The 6-month overlap with the retiring Chief Architect provides sufficient transition time if the new leader is given full authority.

d) Outsource the Chief Architect role to an architecture consulting firm. This eliminates succession risk because consulting firms can always provide replacement personnel. The internal team can continue in their current roles under consulting leadership.

### Question 12
How should the Architecture Board address the risk that the Tailored Architecture Framework has never been formally documented?

a) The Tailored Architecture Framework doesn't need documentation—it exists in the practices and habits of the architecture team. As long as the team continues their current practices, the framework will persist.

b) Make documentation of the Tailored Architecture Framework the highest-priority deliverable for the next 3 months. The Chief Architect should work with a documentation team to capture: the organization-specific adaptations to the TOGAF ADM (which phases are expanded, compressed, or combined), the customized Content Metamodel and artifact templates, the specific governance procedures and decision-making criteria, the Architecture Repository structure and classification scheme, the relationship between the framework and organizational culture and decision-making processes. Store this documentation in the Architecture Repository with proper version control. Have the architecture team review and validate the documentation to ensure accuracy and identify any gaps between documented process and actual practice.

c) Start fresh with a standard TOGAF implementation. Since the Tailored Architecture Framework was never documented, this is an opportunity to reset to a baseline TOGAF approach that any new Chief Architect can understand and execute.

d) Hire an external consultant to reverse-engineer the Tailored Architecture Framework by interviewing the architecture team and observing their processes. External documentation avoids bias from the retiring Chief Architect.

---

## Scenario 7: Architecture Board Legitimacy Crisis

**PublicServ** is a large government agency responsible for citizen services. The agency adopted TOGAF 5 years ago and established an Architecture Board to govern IT architecture decisions. The Architecture Board consists of 7 members: the CIO (chair), 3 IT directors, 2 senior enterprise architects, and 1 project management director.

External auditors have raised serious concerns about the legitimacy of the Architecture Board's decisions:
- The Board has no business representation—all members are from IT
- Critical architecture decisions affecting citizen services were made without consulting citizen service delivery managers
- The Board approved a $100M platform replacement without input from the finance or procurement departments
- Business stakeholders describe the Architecture Board as "an IT committee making decisions about things they don't understand"
- The Board's governance decisions have been overridden 5 times in the past year by the Deputy Secretary (the agency's #2 executive) because they didn't adequately consider business impacts
- Morale within the Architecture Board is low because members feel their authority is being undermined

### Question 13
How should the Architecture Board be restructured to address the legitimacy concerns?

a) Expand the Architecture Board to include 15 members: the existing 7 IT members plus 8 business representatives from citizen service delivery, finance, procurement, HR, legal, policy, field operations, and communications. Larger representation ensures all perspectives are included.

b) Restructure the Architecture Board to include balanced business and IT representation, following TOGAF's guidance on board composition. Reconstitute the Board with: the CIO or CTO as chair, 2-3 IT/architecture representatives (technical expertise), 2-3 business representatives from key operational areas (citizen service delivery, field operations), 1 finance/procurement representative (investment perspective), 1 senior executive sponsor (ensures alignment with agency strategy), maintaining 7-9 total members for effective decision-making. Establish clear terms of reference that define the Board's decision-making authority, scope, escalation paths, and the boundary between the Board's architecture governance role and the Deputy Secretary's executive authority. Create stakeholder advisory groups for specific architecture initiatives to provide broader input without enlarging the core Board. Implement a communication process to keep non-member stakeholders informed of governance decisions and their rationale.

c) Replace the Architecture Board with a business-led governance committee. Since business impact is the primary concern, governance should be led by business leaders with IT providing advisory support.

d) Maintain the current Board composition but add a mandatory "business impact review" step to every architecture decision. Each decision must include a written business impact assessment reviewed and signed off by relevant business stakeholders before the Board votes.

### Question 14
How should the Architecture Board address the Deputy Secretary's pattern of overriding governance decisions?

a) Accept the overrides as legitimate executive authority. The Deputy Secretary outranks the Architecture Board, and their overrides are a normal part of organizational hierarchy. The Board should focus on making better recommendations that the Deputy Secretary won't need to override.

b) Address the root cause by establishing a clear governance relationship between the Architecture Board and executive leadership. Engage the Deputy Secretary directly to understand why overrides occurred—likely because architecture decisions inadequately considered business impacts. Propose a governance structure where: the Architecture Board charter explicitly defines its decision-making authority and the escalation path to executive leadership, the Deputy Secretary (or delegate) serves as the executive sponsor of the Architecture Board with regular briefings, major architecture decisions include a preliminary executive briefing before formal Board approval, the Board's decision-making process incorporates business impact analysis that addresses executive concerns proactively. This approach transforms the adversarial dynamic into a collaborative governance relationship while respecting the legitimate authority hierarchy.

c) Escalate to the agency head (Secretary) and request formal recognition that Architecture Board decisions cannot be overridden without going through a documented appeal process. The Board's authority must be absolute within its defined scope.

d) Reduce the Architecture Board's scope to purely technical decisions (technology standards, platform choices, integration patterns) and cede all business-impacting architecture decisions to the Deputy Secretary. This eliminates the conflict by narrowing the Board's authority.

---

## Scenario 8: The Fragmented Tailored Architecture Framework

**WorldWide Manufacturing** is a global manufacturing company with operations in North America, Europe, and Asia-Pacific. When the company adopted TOGAF 4 years ago, each regional office was allowed to create its own Tailored Architecture Framework based on the corporate TOGAF adoption mandate. This was intended to allow regional flexibility while maintaining alignment.

The result has been problematic:
- **North America** tailored the ADM to emphasize rapid delivery: phases are compressed, governance reviews are minimal, and the focus is on technology architecture. Their approach closely resembles agile development with architecture oversight.
- **Europe** tailored the ADM to emphasize governance and compliance: full ADM phases with extensive documentation, mandatory compliance reviews at every phase transition, and heavy emphasis on data architecture due to GDPR. Their approach is thorough but slow.
- **Asia-Pacific** tailored the ADM to focus on capability development: strong emphasis on Phase A visioning and Phase B business architecture, with Phases C-D treated as implementation detail delegated to vendor partners. Their approach is business-aligned but technically weak.

The corporate Chief Architect has been asked to lead a cross-regional architecture initiative for a new global ERP platform. The initiative requires consistent architecture practices across all three regions. However:
- Each region claims their tailored framework is superior and appropriate for their context
- Artifacts from different regions cannot be compared because they use different metamodel interpretations
- Regional Architecture Boards have different governance standards and compliance definitions
- Regional architects have been trained on their regional framework, not the others

### Question 15
What standardization approach should the corporate Chief Architect take?

a) Mandate that all regions adopt the most comprehensive framework (Europe's) since it provides the most rigorous governance and documentation. Other regions can compress activities if time permits, but the baseline standard should be the most thorough approach.

b) Develop a "Federated Architecture Governance" model. Establish a corporate-level Architecture Governance Framework that defines: mandatory common elements that all regional frameworks must include (core metamodel entities, minimum governance checkpoints, standard artifact templates for cross-regional artifacts, common compliance assessment criteria, shared Architecture Repository structure and classification scheme), while allowing regional flexibility for: additional governance activities appropriate to regional regulatory requirements, regional-specific artifact types and documentation depth, tailored phase emphasis based on regional business context. For the global ERP initiative specifically, define a project-level Tailored Architecture Framework that all three regional teams will use, drawing the best elements from each regional approach. Establish a corporate Architecture Integration Board that governs cross-regional architecture decisions while regional Boards maintain authority over regional-specific decisions.

c) Create an entirely new fourth Tailored Architecture Framework for global initiatives, separate from all three regional frameworks. This avoids the political challenge of choosing one region's approach over another and gives the Chief Architect a clean slate.

d) Allow each region to continue using their own framework for the ERP initiative but require that all deliverables be translated into a common format at the end of each phase. A translation layer preserves regional autonomy while enabling cross-regional comparison.

### Question 16
How should the corporate Chief Architect address the fact that regional architects have been trained only on their regional framework?

a) No training is needed. Professional architects should be able to adapt to any TOGAF-based framework since the underlying principles are the same.

b) Implement a structured capability development program. For the immediate ERP initiative: conduct a cross-regional architecture workshop where architects from all three regions learn each other's frameworks, understand the rationale behind different tailoring choices, and collaboratively develop the project-level framework. For long-term organizational development: create a corporate architecture training curriculum that covers the common corporate framework elements while acknowledging regional variations, establish an architect rotation program where architects spend 3-6 months working in a different region, develop a corporate architecture community of practice that shares knowledge across regions, include cross-regional framework knowledge in architect competency assessments and career development paths.

c) Replace all regional architects with a new corporate architecture team that is trained on a single, unified framework. This eliminates the training problem by starting with a clean slate.

d) Hire external consultants with experience in all three regions to lead the ERP initiative. External consultants don't have regional allegiance and can work across all three frameworks without bias.

---

## Answer Key

### Scenario 1 - Question 1
**Scoring:**
- **Answer b) = 5 (Best):** This answer demonstrates sophisticated governance design aligned with TOGAF principles. A risk-based, tiered governance model is the correct approach to balancing rigor with agility. High-impact projects receive full governance while low-impact projects get proportionate oversight. Increasing Board frequency and establishing sub-committees address the capacity bottleneck. Automated compliance guardrails represent modern governance that enables speed. This approach preserves the governance value demonstrated by the 23 caught issues while eliminating unnecessary overhead for low-risk projects.
- **Answer c) = 3:** Hiring more architects to reduce the backlog addresses the symptom (review delays) but not the root cause (one-size-fits-all governance for all projects). The defense of the 30% timeline increase has merit—the governance value is real. However, refusing to adapt governance to organizational growth demonstrates rigidity that will ultimately erode stakeholder support for the architecture function. Partial credit for correctly valuing governance outcomes.
- **Answer a) = 1:** Eliminating formal compliance reviews and relying on self-certification with periodic audits fundamentally weakens governance. Self-certification removes the independent review that caught 23 issues. Post-implementation audits discover problems too late—after costly implementations are complete. While the intent to reduce overhead is valid, the approach removes governance value rather than optimizing it.
- **Answer d) = 0:** Dissolving the central Architecture Board and decentralizing governance eliminates the enterprise-wide perspective that prevents conflicting architecture decisions. TOGAF specifically establishes the Architecture Board as a central governance body because distributed decision-making without coordination leads to exactly the kind of inconsistency and technical debt that EA is designed to prevent.

### Scenario 1 - Question 2
**Scoring:**
- **Answer b) = 5 (Best):** This answer provides both immediate relief (expedited review track) and structural improvement (embedded architects for continuous guidance). The 48-hour emergency review process maintains governance integrity while eliminating bottlenecks for critical projects. Embedding architects in project teams is particularly strong—it shifts governance from a gate to a continuous service, which is more effective and less disruptive. Documenting all expedited reviews in the Governance Log maintains the audit trail.
- **Answer c) = 3:** Requiring projects to include governance time in their schedules is procedurally correct—governance activities should be planned, not treated as surprises. However, this response alone doesn't address the legitimate concern about governance overhead. It shifts the blame to project planning without acknowledging that the governance process itself may need optimization. Partial credit for the valid point about planning.
- **Answer a) = 1:** A blanket dispensation for "high-priority" projects undermines the governance framework entirely. Since most projects could be classified as "high-priority" by a PMO motivated to avoid governance, this approach effectively creates an opt-out mechanism. The 23 architecture issues caught by governance likely included high-priority projects—the issues don't care about project priority.
- **Answer d) = 0:** "Architecture insurance" (a budget for post-delivery remediation) is a creative but fundamentally flawed concept. It incentivizes ignoring architecture governance by making non-compliance a budgetable cost rather than a preventable problem. This approach normalizes architecture non-compliance and converts governance from prevention to expensive after-the-fact correction.

### Scenario 2 - Question 3
**Scoring:**
- **Answer b) = 5 (Best):** This is the most balanced and TOGAF-aligned approach. It acknowledges the breach (not ignoring the governance failure), conducts impact assessment (data-driven decision-making), recognizes the practical complexity (2M patient records, regulatory compliance), establishes a realistic remediation path (phased transition), and strengthens governance processes (lessons learned). The new dispensation with strict milestones provides governance structure while allowing the necessary time for a complex migration. Recording in the Governance Log maintains institutional memory.
- **Answer a) = 3:** Retroactive extension and standards modification is pragmatic but sets a dangerous governance precedent. If any sufficiently entrenched system can force standards changes, the enterprise standards become meaningless. However, this answer correctly recognizes the impracticality of forcing an immediate migration and the real risks to patient data. Partial credit for pragmatism and risk awareness.
- **Answer c) = 1:** Mandating a 6-month migration to PostgreSQL for a system with 2M patient records, 12 dependent applications, and regulatory certification requirements is unrealistic and potentially dangerous. While the governance principle (enforce compliance) is correct, the implementation timeline ignores practical constraints. Rushed data migrations in healthcare can endanger patient safety. Partial credit only for maintaining governance principle.
- **Answer d) = 0:** Dissolving the dispensation and transferring governance to the team that failed to comply with dispensation conditions is a complete governance abdication. Self-governance for a non-compliant team eliminates the oversight that exists precisely because the team has demonstrated it will not prioritize architectural compliance on its own.

### Scenario 2 - Question 4
**Scoring:**
- **Answer b) = 5 (Best):** This is a comprehensive governance improvement response. Establishing a dispensation registry, assigning Board sponsors, implementing mandatory reporting, defining escalation triggers, and establishing consequences all address the systemic monitoring failure. Applying improvements to all dispensations ensures the lesson extends beyond this single case. This transforms the failure from a one-time problem into a governance maturation opportunity.
- **Answer a) = 3:** While dispensation holders do bear responsibility for compliance, the Architecture Board also has a governance responsibility to monitor dispensation conditions. The Board granted the dispensation with conditions—those conditions are meaningless if the Board doesn't track them. However, this answer correctly identifies that the dispensation holder shares responsibility, earning partial credit.
- **Answer d) = 1:** Eliminating dispensations entirely is an overreaction that removes a valuable governance tool. Dispensations exist because real-world situations sometimes require temporary deviations. The problem isn't the dispensation mechanism—it's the monitoring process. Removing dispensations forces binary conform/reject decisions that may not serve enterprise interests in complex situations.
- **Answer c) = 0:** Formal reprimands focus on blame rather than process improvement. While accountability matters, punitive responses to governance failures don't fix the underlying process deficiency. If the Board failed to monitor, the process needs strengthening—not just the people involved. This approach also damages the relationship between the architecture governance function and development teams.

### Scenario 3 - Question 5
**Scoring:**
- **Answer b) = 5 (Best):** The Architecture Integration Board approach is the correct governance response to overlapping programs. It maintains each program's independence for domain-specific work while centrally governing shared concerns. The specific mechanisms (shared domain map, mandated common solutions, shared Architecture Requirements Specification, coordinated Roadmap, shared Repository, escalation to full Board) are all TOGAF-aligned practices. This approach prevents duplication without creating a governance bottleneck.
- **Answer d) = 3:** Pausing all three programs to consolidate Architecture Visions addresses the alignment problem but at a high cost. Stopping $95M worth of in-flight programs for a Vision consolidation exercise would cause significant business disruption and likely lose executive support for the architecture function. However, the underlying insight—that a unified vision is needed—is correct. Partial credit for identifying the alignment gap.
- **Answer c) = 1:** Deferring conflict resolution to Phase G implementation governance is far too late. By Phase G, each program will have committed to specific technologies and approaches. Resolving conflicts during implementation means expensive rework. TOGAF's governance framework is designed to catch conflicts early in the architecture development phases, not during implementation. Partial credit only for acknowledging that conflicts will eventually be resolved.
- **Answer a) = 0:** Canceling two programs to consolidate into one ignores the distinct business objectives of each initiative. The programs exist because different business leaders have different needs (customer experience, supply chain, data analytics). Consolidation under one program loses the business sponsorship and domain expertise of the others. This is a political approach that avoids governance challenge rather than addressing it.

### Scenario 3 - Question 6
**Scoring:**
- **Answer b) = 5 (Best):** This answer correctly positions architecture governance as informing, not unilaterally making, resource allocation decisions. Assessing architecture dependencies to determine optimal sequencing is a valuable contribution that only the architecture function can provide. Making a recommendation to the executive team (rather than a unilateral decision) respects organizational authority while providing architectural insight. Documenting rationale and updating Roadmaps ensures transparency and follow-through.
- **Answer a) = 3:** Resource allocation IS partially a PMO responsibility, and this answer correctly identifies the boundary. However, architecture governance has a legitimate role in informing resource decisions when architecture dependencies exist between programs. The Architecture Board can identify which sequencing creates the least architectural risk—a perspective the PMO may not have. Partial credit for correct boundary awareness but incomplete governance contribution.
- **Answer d) = 1:** Equal allocation ignores architecture dependencies and optimizes for fairness rather than enterprise value. If Program Beta's Phase E deliverables create infrastructure that Programs Alpha and Gamma depend on, equal allocation delays all three programs. Architecture governance should inform prioritization based on dependencies, not default to mathematical equality.
- **Answer c) = 0:** Budget size does not determine architectural priority. The largest budget program may not have the most critical Q3 dependencies. Using budget as a proxy for importance ignores architectural analysis entirely and sets a precedent that funding equals governance priority—undermining the architecture function's role in objective technical assessment.

### Scenario 4 - Question 7
**Scoring:**
- **Answer b) = 5 (Best):** This phased approach demonstrates strategic governance revival. Starting with quick wins (pilot projects that demonstrate value) rather than mandates builds credibility. Using quantified benefits to make the case for governance is essential in a skeptical environment. The graduated approach (pilots → targeted reviews → broader governance) is realistic for a 90-day window. Critically, this answer recognizes that governance culture must be earned through demonstrated value, not imposed through mandates. Making governance helpful rather than obstructive is the cultural transformation required.
- **Answer c) = 3:** Redesigning the governance framework acknowledges that the current approach has failed. However, spending the entire 90 days on redesign without demonstrating value risks the same outcome—a beautifully designed framework that nobody follows. The CEO wants evidence of value, not a better plan. Partial credit for recognizing the need for change but missing the urgency of demonstrating value.
- **Answer a) = 1:** Mandatory enforcement through CEO mandate may produce short-term compliance but will generate resentment and resistance. In an organization where 90% of project managers don't know the architecture principles, forcing compliance without education and enablement will be seen as arbitrary bureaucracy. Shutting down non-compliant projects would paralyze the business. Governance by mandate without cultural change is unsustainable.
- **Answer d) = 0:** Outsourcing governance implementation admits defeat for the internal architecture function and creates dependency on external consultants. External consultants cannot build the internal relationships, institutional knowledge, and cultural change needed for sustainable governance. When the consultants leave, the governance will collapse again. This approach also signals to the CEO that the internal team is incapable.

### Scenario 4 - Question 8
**Scoring:**
- **Answer b) = 5 (Best):** This answer transforms governance from a gatekeeping function to an enabling service. Integrating architecture input into existing business decision processes (rather than creating separate architecture gates) reduces friction. The "Architecture Advisory" service provides value without imposing compliance overhead. Providing business-friendly tools (reference architectures, approved catalogs, decision frameworks) empowers business units to make architecture-aligned decisions independently. Demonstrating value through outcomes creates natural demand for architecture input—the best governance is when stakeholders seek architecture guidance voluntarily.
- **Answer d) = 3:** Embedding architects in business units is structurally sound and addresses the proximity problem. However, it's an expensive solution (hiring architects for every business unit) and creates dual-reporting challenges. The approach also assumes that proximity alone will solve the engagement problem, when the fundamental issue is that business units don't see architecture's value. Partial credit for the embedded model concept.
- **Answer a) = 1:** Budget control as a governance enforcement mechanism is heavy-handed and will generate significant business resistance. In an organization where the architecture practice is already seen as a "failed experiment," adding procurement gates will confirm the perception of architecture as bureaucratic obstruction. While budget integration has some validity for major investments, applying it universally is disproportionate.
- **Answer c) = 0:** Positioning the architecture team as a "cleanup crew" for non-conformant decisions is a complete surrender of the architecture function's proactive governance role. Retroactive alignment is always more expensive and less effective than proactive guidance. This approach cements architecture as an afterthought rather than a strategic capability.

### Scenario 5 - Question 9
**Scoring:**
- **Answer b) = 5 (Best):** This is the most nuanced and TOGAF-aligned response. The risk-based approach correctly separates compliance issues from genuine architectural risks. The phased remediation priorities (DR first, then knowledge transfer, then integration) address the most critical risks first. Critically, NOT requiring technology migration to enterprise standards unless risks justify it shows mature governance judgment—the platform's non-standard technology works well and forced migration could introduce more risk than it mitigates. Engaging the trading desk VP as a stakeholder rather than an adversary is essential for success.
- **Answer a) = 3:** Mandating full compliance addresses the genuine risks (single point of failure, no DR, no documentation) but the approach—halting feature development for 6 months—would be perceived as punitive and would face fierce resistance from the VP and potentially the CEO. The platform generates $500M annually; any disruption must be carefully managed. Partial credit for correctly identifying the seriousness of the governance gap.
- **Answer d) = 1:** Reporting to external regulators is premature and escalates beyond architecture governance to legal/regulatory territory. While the regulatory risk is real, the Architecture Board's role is to address it through architecture governance, not to bypass internal governance by involving external authorities. However, partial credit for recognizing the regulatory dimension of the risk.
- **Answer c) = 0:** A permanent governance exemption based on current performance ignores the significant risks identified. The platform's 99.97% uptime to date doesn't mitigate the single point of failure, key-person dependency, and absence of disaster recovery. Past performance does not predict future incidents. Exempting the highest-risk system from governance is the opposite of risk-based governance.

### Scenario 5 - Question 10
**Scoring:**
- **Answer b) = 5 (Best):** This answer demonstrates expert stakeholder engagement. Framing governance in terms the VP values (revenue protection, business continuity) rather than compliance language is key to engagement. The specific questions posed (developer departure risk, downtime revenue impact, regulatory documentation requirements) make the risks tangible and personal. Offering architecture support that benefits the platform directly (DR planning, documentation help) positions the architecture team as allies. Inviting the VP to join the Architecture Board is a masterstroke—it gives the VP influence over governance rather than being subject to it, transforming the relationship from adversarial to collaborative.
- **Answer a) = 3:** CEO escalation may eventually be necessary but should be a last resort, not the first action. Using hierarchical authority to force compliance damages the relationship and creates resentment. The VP may comply grudgingly but will look for ways to circumvent governance. However, having executive backing is important, and the CEO should be aware of the risk. Partial credit for recognizing the need for authority when resistance is strong.
- **Answer c) = 1:** Bypassing the VP to work directly with developers is politically dangerous and ethically questionable. Going around a business leader to access their team creates organizational conflict and undermines management authority. Even if the developers are receptive, they need their VP's support to allocate time for governance activities. This approach might produce short-term results but creates lasting organizational damage.
- **Answer d) = 0:** Waiting for a failure event is irresponsible risk management. When the platform handles $10B in daily trading volume with no DR plan, a major failure could be catastrophic for the company. The Architecture Board has a governance responsibility to address known, significant risks proactively. Waiting for failure to prove the point is gambling with the enterprise.

### Scenario 6 - Question 11
**Scoring:**
- **Answer b) = 5 (Best):** This comprehensive succession plan addresses all dimensions of the capability transfer challenge. Knowledge capture ensures institutional knowledge survives the transition. Governance formalization eliminates personal dependency in governance relationships. Leadership development prepares internal candidates with real experience. Re-establishing the Deputy role provides immediate structural support. Stakeholder transition maintains relationship continuity. Strengthening Board independence ensures governance survives leadership change. This approach recognizes that architecture capability resides in people, processes, AND organizational structures—all three must be addressed.
- **Answer c) = 3:** Promoting one candidate immediately provides a clear successor with a 6-month mentorship period. However, this approach focuses only on the leadership succession and ignores the broader institutional knowledge capture, governance formalization, and stakeholder transition needs. The 6-month overlap is valuable but insufficient without structured knowledge transfer. Partial credit for the practical leadership decision.
- **Answer a) = 1:** An external hire brings new skills but loses 12 years of institutional knowledge, stakeholder relationships, and organizational context. External candidates won't understand the company's Tailored Architecture Framework (which isn't documented), the governance relationships, or the organizational culture. The transition period required for an external hire to become effective could be longer than the 6-month window. Partial credit for bringing fresh perspective.
- **Answer d) = 0:** Outsourcing the Chief Architect role is a surrender of internal architecture capability. Consulting firms optimize for engagement revenue, not organizational capability development. The internal team's institutional knowledge would be undervalued, and the organization becomes dependent on external parties for a core strategic capability. This approach contradicts TOGAF's emphasis on building organizational architecture capability.

### Scenario 6 - Question 12
**Scoring:**
- **Answer b) = 5 (Best):** Making TAF documentation the highest priority is correct given the retirement timeline. The specific elements to document (ADM adaptations, metamodel customizations, governance procedures, Repository structure, cultural relationships) cover both the explicit and tacit knowledge in the framework. Having the architecture team review documentation catches gaps between documented and actual practice. Storing in the Architecture Repository with version control ensures long-term accessibility. This approach preserves the organization's most valuable architecture asset.
- **Answer d) = 3:** An external consultant bringing objectivity to the documentation process has merit—insiders may have blind spots about their own practices. However, relying solely on reverse engineering introduces risk: the consultant may miss tacit knowledge, misinterpret practices, or produce documentation that doesn't capture the Chief Architect's design rationale. The Chief Architect should be the primary source, with external validation as a supplement. Partial credit for the objectivity insight.
- **Answer c) = 1:** Starting fresh with standard TOGAF discards 12 years of organizational adaptation that made the framework effective. The Tailored Architecture Framework exists because the organization needed specific adaptations—reverting to vanilla TOGAF means re-learning those lessons. The disruption of changing frameworks during a leadership transition compounds the risk. Partial credit for recognizing the documentation gap as an opportunity.
- **Answer a) = 0:** Assuming the framework will persist through team habits ignores the reality of organizational knowledge decay. When the Chief Architect leaves, team practices will gradually diverge without a documented reference. New team members will have no onboarding resource. Disagreements about "how we do things" will have no resolution mechanism. Undocumented processes are fragile processes—this approach guarantees eventual framework degradation.

---

## Score Card

| Scenario | Question | Your Answer | Points (0-5) |
|---|---|---|---|
| Scenario 1: Governance vs. Agility | Q1 | ___ | ___/5 |
| Scenario 1: Governance vs. Agility | Q2 | ___ | ___/5 |
| Scenario 2: Expired Dispensation | Q3 | ___ | ___/5 |
| Scenario 2: Expired Dispensation | Q4 | ___ | ___/5 |
| Scenario 3: Overlapping Programs | Q5 | ___ | ___/5 |
| Scenario 3: Overlapping Programs | Q6 | ___ | ___/5 |
| Scenario 4: Paper Tiger Framework | Q7 | ___ | ___/5 |
| Scenario 4: Paper Tiger Framework | Q8 | ___ | ___/5 |
| Scenario 5: Profitable Rogue System | Q9 | ___ | ___/5 |
| Scenario 5: Profitable Rogue System | Q10 | ___ | ___/5 |
| Scenario 6: Succession Crisis | Q11 | ___ | ___/5 |
| Scenario 6: Succession Crisis | Q12 | ___ | ___/5 |
| Scenario 7: Legitimacy Crisis | Q13 | ___ | ___/5 |
| Scenario 7: Legitimacy Crisis | Q14 | ___ | ___/5 |
| Scenario 8: Fragmented Framework | Q15 | ___ | ___/5 |
| Scenario 8: Fragmented Framework | Q16 | ___ | ___/5 |
| | **TOTAL** | | **___/80** |

**Scaled Score: ___ / 40** (divide total by 2)

| Scaled Score | Rating |
|---|---|
| 36-40 | Governance Grandmaster - You can design and manage governance for any organization |
| 30-35 | Expert - Strong governance judgment in complex situations |
| 24-29 | Pass - You understand governance principles but need more practice with edge cases |
| 18-23 | Near Miss - Review TOGAF governance framework depth and nuance |
| Below 18 | Study architecture governance as a discipline, not just a TOGAF concept |
