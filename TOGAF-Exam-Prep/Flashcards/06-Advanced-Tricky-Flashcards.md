# Advanced & Tricky TOGAF Flashcards

These flashcards target the most commonly confused concepts, subtle distinctions, and edge cases that appear on the TOGAF certification exam.

---

**Q1:** What is the EXACT difference between Phase E (Opportunities & Solutions) and Phase F (Migration Planning)?

**A:** **Phase E** identifies opportunities and solutions — it determines *what* work packages, projects, and Transition Architectures are needed to move from Baseline to Target. It produces an *initial* Architecture Roadmap and identifies the building blocks required. **Phase F** takes those outputs and creates a *detailed, finalized* Implementation and Migration Plan — it assigns costs, benefits, risk assessments, and prioritizes projects into a concrete migration strategy. Think of it this way: **E = what needs to happen; F = exactly how and when it will happen, and what it will cost.**

---

**Q2:** What is the difference between the Architecture Vision (document) and the Statement of Architecture Work?

**A:** The **Architecture Vision** is a high-level aspirational description of the Target Architecture — it communicates the value, key stakeholder concerns, and the scope of the architecture engagement. It is a *deliverable* that describes the "future state" at a summary level. The **Statement of Architecture Work** is the *contractual document* — it defines scope, approach, schedule, resources, constraints, and governance for the architecture project. It is the formal agreement between the sponsoring organization and the architecture team. **The Statement of Architecture Work is the contract; the Architecture Vision is the destination.**

---

**Q3:** How do Architecture Contracts (Phase G) differ from the Statement of Architecture Work (Phase A)?

**A:** The **Statement of Architecture Work** (Phase A) is a contract between the *architecture team and the sponsor* — it governs the architecture development effort itself (scope, timeline, deliverables of the ADM cycle). **Architecture Contracts** (Phase G) are agreements between the *architecture function and implementation partners/development teams* — they govern how the implementation must conform to the architecture. SoAW controls the *design process*; Architecture Contracts control the *build process*.

---

**Q4:** What are the distinct purposes of the Architecture Definition Document (ADD) vs. the Architecture Requirements Specification (ARS)?

**A:** The **Architecture Definition Document** describes the *architecture itself* — Baseline and Target Architectures across all domains, including building blocks, views, rationale, and gap analysis. It answers "what does the architecture look like?" The **Architecture Requirements Specification** captures *constraints and requirements* that the architecture must satisfy — functional requirements, non-functional requirements, service contracts, and implementation guidelines that the solution must meet. It answers "what must the architecture achieve?" The ADD is the *design*; the ARS is the *specification of what the design must fulfil*.

---

**Q5:** What is the precise relationship between Architecture Building Blocks (ABBs) and Solution Building Blocks (SBBs)? When does one become the other?

**A:** **ABBs** are vendor-neutral, technology-agnostic components that define *what* functionality is needed (e.g., "a customer identity management capability"). **SBBs** are specific, product-aware implementations that define *how* the functionality is realized (e.g., "Okta for customer identity management"). An ABB becomes an SBB during **Phase E (Opportunities & Solutions)**, when opportunities are mapped to specific products, technologies, or vendors. ABBs live toward the *Foundation Architecture* end of the Enterprise Continuum; SBBs live toward the *Organization-Specific* end.

---

**Q6:** What is the difference between a View and a Viewpoint?

**A:** A **Viewpoint** is the *template, pattern, or specification* — it defines the perspective, conventions, and modeling techniques to be used. Think of it as the *recipe* or *camera angle*. A **View** is the *instance* — the actual representation of the architecture created by applying a viewpoint to a specific system or domain. Think of it as the *photograph taken from that angle*. Viewpoint = reusable pattern; View = specific artifact produced using that pattern for a particular stakeholder concern.

---

**Q7:** Define Deliverable, Artifact, and Building Block precisely. How do they relate to each other?

**A:** A **Deliverable** is a formal, contractually specified work product that is reviewed, agreed, and signed off by stakeholders (e.g., Architecture Definition Document). An **Artifact** is a more granular architectural work product — a catalog, matrix, or diagram — that describes an aspect of the architecture. Artifacts are *contained within* deliverables. A **Building Block** is a potentially reusable component of business, IT, or architectural capability that can be combined with other building blocks to deliver architectures and solutions. **Relationship:** Deliverables contain Artifacts. Artifacts describe Building Blocks. A single deliverable (like the ADD) may contain multiple artifacts (diagrams, catalogs), which in turn describe various building blocks.

---

**Q8:** What are the three types of architecture artifacts in the Content Framework? Give an example of each.

**A:** **(1) Catalogs** — ordered lists of building blocks of a specific type (e.g., Technology Standards Catalog, Application Portfolio Catalog, Business Service/Function Catalog). **(2) Matrices** — show relationships between two or more entities (e.g., Application/Data Matrix, Stakeholder Map Matrix, Role/Actor Catalog mapped to Functions). **(3) Diagrams** — visual, graphical representations of architecture (e.g., Business Footprint Diagram, Application Communication Diagram, Environments and Locations Diagram). **Key distinction:** Catalogs are *lists*, Matrices are *grids/cross-references*, Diagrams are *pictures*.

---

**Q9:** Which ADM phase produces the Architecture Roadmap?

**A:** The Architecture Roadmap is *initially created* in **Phase E (Opportunities & Solutions)** — this is where work packages, projects, and Transition Architectures are first identified and sequenced. It is then *refined and finalized* in **Phase F (Migration Planning)** with detailed scheduling, cost/benefit analysis, and prioritization. The exam will try to trick you with Phase F alone — remember that **E initiates it, F finalizes it**.

---

**Q10:** In which phase are Transition Architectures created?

**A:** Transition Architectures are *identified and defined* in **Phase E (Opportunities & Solutions)**. They represent intermediate, stable states of the architecture between the Baseline and the Target. In **Phase F**, they are further refined with migration details. The common exam trap is selecting Phase F — but Phase E is where they are *first created*.

---

**Q11:** List and define all six TOGAF architecture compliance levels.

**A:**
1. **Irrelevant** — The standard or specification has no relevance to this architecture.
2. **Consistent** — The architecture is compatible with the standard but does not directly implement it; it does not conflict.
3. **Compliant** — The architecture implements some, but not all, of the standard's provisions.
4. **Conformant** — The architecture implements all provisions of the standard, but also includes additional features not covered by the standard.
5. **Fully Conformant** — The architecture completely and exclusively implements all provisions of the standard, with no additions or deviations.
6. **Non-Conformant** — The architecture does not implement the standard and conflicts with it.

**Key exam distinction:** Compliant = *partial* implementation. Conformant = *full* implementation plus extras. Fully Conformant = *exact* implementation, nothing more.

---

**Q12:** Describe the direction of the Enterprise Continuum from left to right.

**A:** The Enterprise Continuum classifies assets from **generic/universal** (left) to **organization-specific** (right). The progression is: **Foundation Architectures** (most generic, e.g., TRM, III-RM) → **Common Systems Architectures** (more refined, e.g., industry-shared patterns) → **Industry Architectures** (industry-specific patterns and standards) → **Organization-Specific Architectures** (tailored to the enterprise). This applies to both the **Architecture Continuum** (architectural descriptions) and the **Solutions Continuum** (implementation solutions). ABBs live more toward the left; SBBs live more toward the right.

---

**Q13:** What are the three levels of the Architecture Landscape? Precisely define each.

**A:**
1. **Strategic Architecture** — A high-level, long-range (3-5+ year) view providing an *overall summary* of the entire enterprise. It enables executive decision-making and direction-setting.
2. **Segment Architecture** — A detailed architecture for a *major business segment, capability, or organizational unit* (e.g., HR, Finance, Supply Chain). It provides more detail than Strategic but narrower scope than the full enterprise.
3. **Capability Architecture** — The most detailed level, providing *highly specific, implementation-ready* architecture for a single capability, project, or system. It supports direct solution delivery.

**Think of it as a zoom lens:** Strategic = wide angle; Segment = medium zoom; Capability = close-up.

---

**Q14:** When does the ADM cycle restart? What triggers it?

**A:** The ADM cycle restarts when **Phase H (Architecture Change Management)** identifies that a change request cannot be handled through simplification or incremental change within the current architecture. Phase H produces a new **Request for Architecture Work**, which feeds back as the primary input to **Phase A (Architecture Vision)**, triggering a new ADM cycle. This is the formal mechanism for architecture evolution.

---

**Q15:** What is the ONLY input to Phase A that does NOT originate from the Preliminary Phase?

**A:** The **Request for Architecture Work**. All other Phase A inputs (Architecture Principles, Organizational Model for EA, Tailored Architecture Framework, etc.) come from the Preliminary Phase. The Request for Architecture Work can come from Phase H (Architecture Change Management) — triggering a new cycle — or from an external organizational sponsor requesting architecture development. This is a common exam question designed to test whether you understand the ADM's feedback loop.

---

**Q16:** Define the three types of change identified in Phase H: Simplification, Incremental, and Re-Architecting.

**A:**
1. **Simplification Change** — A change that can be handled by *reducing or simplifying* the current architecture. It doesn't require significant new development and can be managed within the current architecture cycle (e.g., retiring a redundant system).
2. **Incremental Change** — A change that updates the Target Architecture but can be managed by *adjusting existing work packages* within the current Migration Plan. It doesn't alter the fundamental architecture direction.
3. **Re-Architecting Change** — A significant change that *fundamentally alters the architecture direction* and requires a new ADM cycle to be initiated (via a new Request for Architecture Work to Phase A). This is the most disruptive change type.

---

**Q17:** What are the exact components of the Architecture Repository?

**A:** The Architecture Repository contains six components:
1. **Architecture Metamodel** — Defines the structure and semantics of architecture content.
2. **Architecture Capability** — Parameters, structures, and processes supporting the architecture function (governance, skills, roles).
3. **Architecture Landscape** — The current state of the architecture at Strategic, Segment, and Capability levels.
4. **Standards Information Base (SIB)** — Captures standards (industry standards, organizational standards, technology standards) that the architecture must conform to.
5. **Reference Library** — External reference models, patterns, and templates (e.g., TRM, III-RM) used as starting points.
6. **Governance Log** — Records of governance activity, decisions, compliance assessments, dispensations, and change requests.

---

**Q18:** What are the four proficiency levels in the TOGAF Skills Framework?

**A:**
1. **Level 1 — Background** — May have education but no practical experience. Understands general concepts.
2. **Level 2 — Awareness** — Has some practical experience and understanding. Can contribute under supervision.
3. **Level 3 — Knowledge** — Has substantial practical experience and can work independently. Can lead in the specific area.
4. **Level 4 — Expert** — Recognized authority with extensive, deep experience. Can set direction and mentor others.

These apply to skills across business, enterprise architecture, program/project management, IT general knowledge, technical IT, and legal domains.

---

**Q19:** What are the distinct responsibilities of the Architecture Board vs. the Chief Architect?

**A:** The **Architecture Board** provides *governance oversight* — it ensures compliance, resolves disputes, enforces architecture contracts, approves dispensations, manages risk, and represents broad organizational interests. It is a *cross-organizational governance body*. The **Chief Architect** is an individual who *leads the architecture practice* — responsible for the architecture vision, technical direction, ensuring quality of architecture work, managing the architecture team, and presenting recommendations. **Key distinction:** The Board *governs and approves*; the Chief Architect *leads and designs*. The Board doesn't create architecture — it provides oversight over the architecture function.

---

**Q20:** How does TOGAF define interoperability, and how does it differ from integration?

**A:** TOGAF defines **interoperability** as the ability of systems to *exchange information and use the information that has been exchanged* — both syntactic (format) and semantic (meaning) interoperability. **Integration** implies tighter coupling — systems are connected and may share internal processes, data stores, or logic. **Interoperability** allows systems to remain independent while still communicating effectively. TOGAF emphasizes that interoperability supports "boundaryless information flow" — the aspiration that information moves freely across organizational and system boundaries without being constrained by technology choices.

---

**Q21:** Which technique uses the Power/Interest grid? What is its purpose?

**A:** The **Stakeholder Management** technique uses the Power/Interest grid. It classifies stakeholders into four quadrants based on their level of *Power* (ability to influence the architecture) and *Interest* (degree of concern about the architecture outcomes):
- **High Power / High Interest** → Manage Closely (Key Players)
- **High Power / Low Interest** → Keep Satisfied
- **Low Power / High Interest** → Keep Informed
- **Low Power / Low Interest** → Monitor (Minimal Effort)

This is used throughout the ADM cycle but is first applied in **Phase A** during stakeholder identification and is critical for tailoring communication approaches.

---

**Q22:** What is a dispensation in architecture governance? When and why is it granted?

**A:** A **dispensation** is a formal approval to *deviate from an architecture standard or target architecture* for a defined period, subject to specific conditions. It is granted by the **Architecture Board** when strict compliance would be impractical, too costly, or counterproductive in a specific situation. It typically includes: (1) the specific deviation allowed, (2) the justification, (3) a time limit, and (4) a remediation plan to bring the system into compliance eventually. Dispensations are recorded in the **Governance Log** within the Architecture Repository. They are NOT permanent exemptions — they are temporary, conditional approvals.

---

**Q23:** What is in the Core Content Metamodel vs. its extensions?

**A:** The **Core Content Metamodel** includes the fundamental entity types and relationships needed for any architecture effort. Core entities include: *Actor, Role, Business Service, Function, Data Entity, Application Component, Technology Component, Platform Service, and more.* The **Extensions** add optional entity types for richer modeling needs:
- **Governance Extension** — Adds contract, compliance, control entities.
- **Services Extension** — Adds service-level details like service quality, SLAs.
- **Process Modeling Extension** — Adds process, event, and detailed workflow entities.
- **Data Extension** — Adds logical and physical data entity detail.
- **Infrastructure Consolidation Extension** — Adds location, physical infrastructure details.
- **Motivation Extension** — Adds drivers, goals, objectives, and measures.

Organizations decide which extensions to adopt based on their scope and maturity.

---

**Q24:** Who creates the Request for Architecture Work? Under what circumstances?

**A:** The **Request for Architecture Work** can be created by:
1. **The sponsoring organization** — When a senior executive, business leader, or CIO recognizes the need for architecture work to support a strategic initiative, organizational change, or problem resolution.
2. **Phase H (Architecture Change Management)** — When monitoring identifies that the current architecture cannot accommodate a required change through simplification or incremental updates, triggering a re-architecting change and a new ADM cycle.

It serves as the *primary trigger* for initiating a new Phase A and must include: the organization sponsor, the strategic goals and drivers, scope of the architecture effort, constraints, budget considerations, timeline expectations, and key stakeholders.

---

**Q25:** In which phase does the Business Transformation Readiness Assessment occur? What does it assess?

**A:** The Business Transformation Readiness Assessment is performed in **Phase E (Opportunities & Solutions)** and refined in **Phase F (Migration Planning)**. It assesses the organization's *readiness to undergo the transformation* required by the Target Architecture. Factors assessed include:
- **Vision clarity** — Do stakeholders understand and agree on the target?
- **Desire, willingness, and resolve** — Is there sufficient organizational commitment?
- **Business case** — Is the financial justification clear?
- **Governance readiness** — Are governance structures in place?
- **IT capacity** — Can the IT organization handle the change?
- **Organizational capacity** — Can the enterprise manage the transformation scope?
- **Enterprise ability to execute** — Does the organization have the skills and processes?

Each factor is rated and risks/mitigations are identified.

---

**Q26:** What is the Implementation Factor Assessment and Deduction Matrix? Which phase uses it?

**A:** The **Implementation Factor Assessment and Deduction Matrix** is used in **Phase E (Opportunities & Solutions)** and **Phase F (Migration Planning)**. Its purpose is to document *factors that impact the architecture implementation plan* — such as risks, organizational issues, cultural factors, technical dependencies, and constraints — and then *deduce* the implications of these factors on the migration approach and work package sequencing. It bridges the gap between identifying solutions (Phase E) and creating a realistic, risk-aware migration plan (Phase F). It ensures that real-world constraints are factored into project sequencing and planning.

---

**Q27:** What is the Consolidated Gaps, Solutions, and Dependencies Matrix? Which phase produces it?

**A:** The **Consolidated Gaps, Solutions, and Dependencies Matrix** is produced in **Phase E (Opportunities & Solutions)**. It consolidates *all gaps identified during Phases B, C, and D* (from gap analyses in each domain), maps them to *potential solutions or building blocks*, and documents *dependencies between them*. This matrix is critical because it provides a unified, cross-domain view that prevents duplicate solutions, identifies shared dependencies, and ensures that solutions address gaps holistically rather than in domain silos.

---

**Q28:** What are the four components of an Architecture Principle? Define each.

**A:**
1. **Name** — A short, memorable label that identifies the principle (e.g., "Data is an Asset," "Technology Independence").
2. **Statement** — A succinct declaration of the principle's intent. It should be unambiguous and declarative.
3. **Rationale** — The justification for *why* the principle exists. It links the principle to business drivers, goals, or strategic motivations. Without rationale, a principle lacks authority.
4. **Implications** — The *consequences* of adopting the principle. What must the organization do differently? What constraints does it impose? What resources or changes are required? This is where the principle becomes actionable.

All four components are required for a well-formed architecture principle. The exam frequently tests whether candidates know all four — especially *Implications*, which is the most commonly forgotten.

---

**Q29:** What is the difference between Architecture Governance and IT Governance?

**A:** **Architecture Governance** is *specifically focused on the architecture practice* — ensuring that architecture processes, content, compliance reviews, contracts, and the Architecture Board function effectively. It governs how architecture is developed, maintained, and enforced. **IT Governance** is *broader* — it covers the overall management of IT resources, investment decisions, risk management, value delivery, and performance measurement across the enterprise. Architecture Governance is a *subset of* and *contributor to* IT Governance. TOGAF's Architecture Governance Framework addresses the architecture-specific aspects, while IT Governance (e.g., COBIT frameworks) encompasses the entire IT function.

---

**Q30:** What does "boundaryless information flow" mean in TOGAF?

**A:** "Boundaryless information flow" is TOGAF's aspirational vision — it describes a state where information moves *freely and securely* across organizational boundaries, geographic boundaries, and technology boundaries without being impeded by incompatible systems, proprietary formats, or organizational silos. It is the *guiding ideal* behind The Open Group's mission and TOGAF's approach to enterprise architecture. It does NOT mean no security or no controls — rather, it means that *technical and organizational barriers to information sharing are minimized* while appropriate security and governance are maintained. The **Integrated Information Infrastructure Reference Model (III-RM)** specifically supports achieving boundaryless information flow.

---
