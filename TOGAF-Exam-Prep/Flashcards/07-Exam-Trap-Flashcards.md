# TOGAF Exam Trap Flashcards

These flashcards specifically address the most common traps, misleading answer choices, and areas where exam candidates consistently choose wrong answers.

---

**TRAP 1:** "The Preliminary Phase is Phase 0 of the ADM."

**TRUTH:** The Preliminary Phase is NOT numbered. It is a *separate, preparatory phase* that sits outside the numbered ADM cycle (Phases A through H). It establishes the architecture capability — defining the framework, principles, governance, tools, and organizational model — before the first ADM cycle begins. Calling it "Phase 0" implies it is part of the cycle sequence, but TOGAF explicitly treats it as distinct.

**WHY IT MATTERS:** Exam questions will list "Phase 0" as an answer choice or reference "the first phase of the ADM." The correct answer is that the Preliminary Phase precedes the ADM cycle, and Phase A (Architecture Vision) is the first phase *within* the cycle.

---

**TRAP 2:** "Requirements Management is a phase you pass through sequentially, between Phase H and Phase A."

**TRUTH:** Requirements Management is NOT a sequential phase. It operates *continuously at the center of the ADM cycle*, interacting with and supporting ALL phases simultaneously. It manages the dynamic identification, storage, prioritization, and disposition of requirements throughout the entire architecture lifecycle.

**WHY IT MATTERS:** Exam questions may present Requirements Management as a step in the sequence or ask "after which phase does Requirements Management occur?" The answer is *none* — it runs continuously. Diagrams always show it in the center of the ADM wheel, not on the perimeter.

---

**TRAP 3:** "Phase B (Business Architecture) only covers business processes."

**TRUTH:** Phase B is far broader than just business processes. It covers: **business capabilities, value streams, organization structures, business functions, business services, business roles and actors, information maps, and business interaction patterns.** Business processes are one component, but TOGAF 10 emphasizes capabilities and value streams as equally (or more) important. The Business Architecture is the foundation upon which Data, Application, and Technology Architectures are built.

**WHY IT MATTERS:** Exam questions may ask what Phase B addresses and include narrow answers focused only on processes. The correct answer will be more comprehensive, encompassing capabilities, value streams, and organizational models.

---

**TRAP 4:** "The TOGAF Technical Reference Model (TRM) is mandatory for all TOGAF implementations."

**TRUTH:** The TRM is a *reference model* — a useful starting point and tool, but NOT mandatory. TOGAF is a *framework*, and its entire philosophy is that it should be *tailored* to the organization's needs. The TRM provides a generic taxonomy of platform services, but organizations are free to adopt, adapt, or disregard it entirely. The same applies to the III-RM and other reference models.

**WHY IT MATTERS:** Exam answers may assert that certain TOGAF components are required. TOGAF repeatedly emphasizes adaptation and tailoring. Any answer stating something is "always required" or "mandatory" should be treated with suspicion unless it is a core ADM principle.

---

**TRAP 5:** "Architecture Compliance means the organization follows the TOGAF standard exactly."

**TRUTH:** Architecture Compliance in TOGAF means that *projects and implementations conform to the organization's own Target Architecture* — not to TOGAF itself. Compliance reviews check whether solutions align with architecture principles, standards, and the defined Target Architecture. TOGAF is the framework used to *develop* the architecture; compliance is about *adhering to what was designed*, not about following TOGAF's structure.

**WHY IT MATTERS:** Exam questions may conflate "TOGAF compliance" with "architecture compliance." The distinction is critical: compliance is about your architecture, not about TOGAF.

---

**TRAP 6:** "The Architecture Board makes all architecture decisions."

**TRUTH:** The Architecture Board provides *governance oversight*, not design decisions. Its responsibilities include: ensuring compliance, resolving disputes, approving dispensations, managing risk, and ensuring architecture processes are followed. **Architecture decisions are made by architects** (led by the Chief Architect). The Board reviews, approves or rejects, and governs — it does not design or decide on specific technical solutions.

**WHY IT MATTERS:** Exam questions may attribute design decisions to the Board. If an answer says the Board "creates," "designs," or "selects" architectures, it is likely wrong. The Board *governs*.

---

**TRAP 7:** "TOGAF prescribes specific tools, notations, and modeling languages."

**TRUTH:** TOGAF is deliberately *tool-agnostic and notation-agnostic*. It does not mandate UML, ArchiMate, BPMN, or any specific tool. While ArchiMate is often used alongside TOGAF (both are from The Open Group), TOGAF itself only specifies *what* artifacts to produce, not *how* to model them. Organizations choose their own tools and notations during the Preliminary Phase when tailoring the framework.

**WHY IT MATTERS:** Exam answers that reference specific tools or notations as TOGAF requirements are incorrect. TOGAF defines artifact types (catalogs, matrices, diagrams) but not the specific notation to create them.

---

**TRAP 8:** "Phase C is only about Data Architecture."

**TRUTH:** Phase C covers BOTH **Data Architecture AND Application Architecture**. These can be done in either order — Data first then Application, Application first then Data, or concurrently — depending on organizational preference. The full name in TOGAF documentation references both domains. Some organizations split Phase C into sub-phases (C1 for Data, C2 for Application), but this is a tailoring choice, not a TOGAF mandate.

**WHY IT MATTERS:** Exam questions may ask what Phase C produces or covers. Any answer limited to only Data or only Application is incomplete. The correct answer addresses both Information Systems domains.

---

**TRAP 9:** "The Enterprise Continuum is a repository for storing architecture assets."

**TRUTH:** The Enterprise Continuum is a *classification scheme* — a conceptual framework for categorizing and organizing architecture assets from generic to organization-specific. The **Architecture Repository** is the actual *storage mechanism*. The Enterprise Continuum provides the *taxonomy* (Foundation → Common Systems → Industry → Organization-Specific); the Repository provides the *storage* (Architecture Landscape, Reference Library, Standards Information Base, Governance Log, etc.).

**WHY IT MATTERS:** This is one of the most frequently confused concepts. Exam questions will present the Enterprise Continuum as a repository or the Repository as a classification scheme. Know which is which.

---

**TRAP 10:** "Architecture Principles are the same as Business Principles."

**TRUTH:** Architecture Principles *derive from* Business Principles but are *distinct*. **Business Principles** express an organization's core values and strategic direction (e.g., "Maximize shareholder value"). **Architecture Principles** translate those into rules that guide architecture decisions (e.g., "Technology Independence" — derived from a business principle of avoiding vendor lock-in). Architecture Principles are more specific, technically-oriented, and directly actionable for the architecture practice. They are defined during the **Preliminary Phase**.

**WHY IT MATTERS:** Exam questions may test the derivation chain: Business Principles → Architecture Principles → architecture decisions. Confusing the two levels is a common error.

---

**TRAP 11:** "You must complete all ADM phases in sequential order, A through H."

**TRUTH:** The ADM is designed to be *iterative and adaptable*. Organizations can: (1) iterate between phases (e.g., revisit Phase B from Phase D), (2) run phases concurrently, (3) skip phases that are not relevant, (4) adapt the level of detail per phase, and (5) scope the ADM to address specific layers. The circular ADM diagram emphasizes iteration, not rigid sequence. The Preliminary Phase explicitly addresses how to *tailor* the ADM.

**WHY IT MATTERS:** Exam answers asserting rigid sequential execution are wrong. TOGAF's flexibility and adaptability are core principles. Look for answers that acknowledge iteration and tailoring.

---

**TRAP 12:** "Gap Analysis only happens in Phase B (Business Architecture)."

**TRUTH:** Gap Analysis is performed in **Phase B (Business Architecture), Phase C (Information Systems Architecture — both Data and Application), AND Phase D (Technology Architecture)**. In each phase, the technique compares the Baseline Architecture with the Target Architecture to identify gaps — missing components, capabilities, or services that must be addressed. The results from all three phases are then consolidated in the **Consolidated Gaps, Solutions, and Dependencies Matrix** in Phase E.

**WHY IT MATTERS:** Exam questions may ask in which phases Gap Analysis occurs. Selecting only one phase is incorrect. The correct answer spans B, C, and D.

---

**TRAP 13:** "The Statement of Architecture Work and the Architecture Contract are the same thing."

**TRUTH:** They serve fundamentally different purposes at different stages:
- **Statement of Architecture Work** (Phase A output) = Agreement between the *architecture team and the sponsor* defining the scope, approach, and deliverables of the *architecture development effort*.
- **Architecture Contract** (Phase G output) = Agreement between the *architecture function and implementation teams* ensuring that *solutions are built in conformance* with the defined architecture.

One governs the design process; the other governs the build process.

**WHY IT MATTERS:** Exam questions frequently present these as interchangeable. If a question asks about implementation governance, the answer is Architecture Contract. If it asks about architecture project authorization, the answer is Statement of Architecture Work.

---

**TRAP 14:** "Phase G (Implementation Governance) is about building solutions."

**TRUTH:** Phase G *governs* the implementation — it does NOT build anything. Its activities include: establishing architecture contracts, performing compliance reviews, conducting architecture governance meetings, and ensuring implementation projects conform to the Target Architecture. The actual building of solutions is done by *development and implementation teams* who operate under the governance framework that Phase G establishes.

**WHY IT MATTERS:** Exam answers may say Phase G "implements," "builds," or "develops" solutions. The correct verb is "governs." Phase G is oversight, not execution.

---

**TRAP 15:** "TOGAF 10 completely replaces TOGAF 9.2 with entirely new concepts."

**TRUTH:** TOGAF 10 *restructures and modernizes* the framework but does not discard the core concepts from TOGAF 9.2. Key changes include: reorganization into a modular structure (TOGAF Fundamental Content, TOGAF Series Guides), updated terminology, stronger emphasis on agile approaches, and enhanced guidance on digital transformation. However, the ADM phases, core deliverables, Enterprise Continuum, Architecture Repository, and governance concepts remain fundamentally consistent. TOGAF 10 is an *evolution*, not a revolution.

**WHY IT MATTERS:** Exam questions may test whether candidates understand the continuity between versions. Answers claiming radical departure from TOGAF 9.2 concepts are typically incorrect.

---

**TRAP 16:** "The Architecture Repository only stores final, approved Target Architectures."

**TRUTH:** The Architecture Repository stores a comprehensive range of architecture assets including: **Baseline Architectures, Target Architectures, Transition Architectures, reference models, standards, architecture principles, governance records (including dispensations and compliance reviews), metamodel definitions, and the entire Architecture Landscape** at all levels (Strategic, Segment, Capability). It is a living, comprehensive library — not just a collection of final states.

**WHY IT MATTERS:** Exam questions may present narrow descriptions of the Repository's contents. The correct answer always reflects its comprehensive scope across all architecture states and governance artifacts.

---

**TRAP 17:** "Transition Architectures are created in Phase F (Migration Planning)."

**TRUTH:** Transition Architectures are *identified and defined* in **Phase E (Opportunities & Solutions)**. They represent formally defined intermediate architecture states between the Baseline and Target Architectures. In **Phase F**, these Transition Architectures are incorporated into the detailed Migration Plan with timelines, resources, and dependencies — but their *creation* happens in Phase E.

**WHY IT MATTERS:** This is a high-frequency exam trap. Phase F handles migration *planning*; Phase E handles the *identification* of Transition Architectures. The question will try to lure you toward Phase F because "transition" sounds like "migration."

---

**TRAP 18:** "The Architecture Vision is primarily about the technology solution."

**TRUTH:** The Architecture Vision spans *all four architecture domains* — Business, Data, Application, AND Technology — at a high level. It provides a holistic, aspirational view of the Target Architecture that communicates value to stakeholders and secures buy-in. While it addresses technology, it is equally (often more) focused on business value, strategic alignment, stakeholder concerns, and the overall direction of change. A technology-only Architecture Vision would be incomplete and misaligned with TOGAF's enterprise-level scope.

**WHY IT MATTERS:** Exam answers that limit the Architecture Vision to technology are incorrect. The correct answer will emphasize its cross-domain, business-driven, stakeholder-oriented nature.

---

**TRAP 19:** "Architecture Compliance reviews only happen during Phase G."

**TRUTH:** While Phase G (Implementation Governance) is where *formal compliance reviews* against Architecture Contracts are most prominent, compliance monitoring is a concern throughout the ADM. Architecture principles and standards should be checked during architecture development (Phases B–D), and ongoing compliance monitoring continues in Phase H (Architecture Change Management). Phase G formalizes the compliance review process for implementation projects, but it is not the exclusive home of compliance activities.

**WHY IT MATTERS:** Exam questions may ask where compliance reviews occur. Answers limiting them exclusively to Phase G are too narrow. The best answer acknowledges Phase G as the primary location while recognizing the broader scope.

---

**TRAP 20:** "Building Blocks must be reusable software components."

**TRUTH:** Building Blocks exist at ALL architecture levels — they are NOT limited to software. Types include:
- **Business Building Blocks** — e.g., a customer onboarding capability, a payment processing function.
- **Data Building Blocks** — e.g., a customer data entity, a product information schema.
- **Application Building Blocks** — e.g., a CRM system, an order management application.
- **Technology Building Blocks** — e.g., a database server, a network firewall, a cloud platform.

Building Blocks are defined as "potentially reusable components of business, IT, or architectural capability." The word "potentially" is important — reusability is desirable but not mandatory.

**WHY IT MATTERS:** Exam answers that define BBs only as software components are incorrect. The correct answer recognizes their cross-domain nature.

---

**TRAP 21:** "The III-RM (Integrated Information Infrastructure Reference Model) replaces the TRM."

**TRUTH:** The III-RM and TRM are *complementary*, not competing. The **TRM (Technical Reference Model)** provides a generic taxonomy of *platform services* — a model of the technology infrastructure. The **III-RM** specifically addresses how applications and their underlying infrastructure integrate to enable *boundaryless information flow*. The III-RM focuses on the application-level interoperability layer; the TRM focuses on the technology platform layer. Both reside on the Foundation Architecture end of the Enterprise Continuum and can be used together.

**WHY IT MATTERS:** Exam questions may present these as alternatives or ask which one supersedes the other. The correct answer is that they address different concerns and are used together.

---

**TRAP 22:** "Phase H (Architecture Change Management) means the architecture project is complete."

**TRUTH:** Phase H is NOT an ending — it is a *continuous monitoring and change management* phase. Its purpose is to ensure the architecture remains fit for purpose by monitoring: technology changes, business changes, lessons learned, and maturity of the architecture practice. When changes are needed, Phase H classifies them (simplification, incremental, or re-architecting) and may trigger an entirely new ADM cycle by issuing a new Request for Architecture Work to Phase A.

**WHY IT MATTERS:** Exam questions may present Phase H as a conclusion. The correct understanding is that Phase H is the mechanism for continuous architecture evolution, feeding back into the ADM cycle.

---

**TRAP 23:** "Stakeholder Management is only relevant during Phase A."

**TRUTH:** While stakeholder identification and initial analysis using the Power/Interest grid begins in **Phase A**, Stakeholder Management *spans the entire ADM cycle*. Stakeholder concerns, communication plans, and engagement strategies must be maintained and updated in every phase. New stakeholders may emerge in later phases, and the power/interest dynamics can shift as the architecture progresses through design, planning, and implementation governance.

**WHY IT MATTERS:** Exam questions may ask when Stakeholder Management is relevant. Answers limiting it to Phase A are incorrect. The correct answer recognizes it as an ongoing, cross-phase activity.

---

**TRAP 24:** "Architecture Maturity means the organization is fully compliant with TOGAF."

**TRUTH:** Architecture Maturity measures the *maturity of the organization's enterprise architecture capability* — how well-established, repeatable, managed, and optimized the architecture practice is. It is typically assessed using maturity models (such as ACMM — Architecture Capability Maturity Model or similar frameworks) with levels ranging from informal/ad-hoc to optimized/continuously improving. It has **nothing to do with TOGAF compliance** — an organization could have a mature EA practice using a completely different framework, or be immature despite claiming to follow TOGAF.

**WHY IT MATTERS:** Exam questions may conflate TOGAF adoption with maturity. The correct answer focuses on the *capability* of the EA practice, independent of which framework is used.

---

**TRAP 25:** "The Content Metamodel is a database schema for storing architecture data."

**TRUTH:** The Content Metamodel is a *conceptual model* that defines the types of architectural entities (e.g., Business Service, Application Component, Data Entity, Technology Component) and the *relationships between them* (e.g., "Application Component realizes Business Service"). It provides a *structured vocabulary* for describing architecture content consistently. It is NOT a database schema, data model, or storage specification — it does not dictate how architecture data is physically stored. It ensures that when architects talk about entities and relationships, they use consistent definitions.

**WHY IT MATTERS:** Exam questions may describe the Content Metamodel in database or storage terms. The correct answer emphasizes that it is a conceptual model defining entity types and relationships for consistent architecture description — not a physical data storage design.

---
