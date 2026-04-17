# TOGAF 10 Core Concepts Flashcards

> 55 exam-focused flashcards covering foundational TOGAF concepts.
> Format: **Q** = Question, **A** = Answer

---

## 1. TOGAF Overview

**Q:** What does TOGAF stand for?
**A:** The Open Group Architecture Framework.

---

**Q:** What type of framework is TOGAF?
**A:** An enterprise architecture framework that provides an approach for designing, planning, implementing, and governing enterprise information technology architecture.

---

**Q:** Who maintains and publishes TOGAF?
**A:** The Open Group.

---

**Q:** Is TOGAF a prescriptive methodology or an adaptable framework?
**A:** An adaptable framework. TOGAF is designed to be tailored and customized to meet the specific needs of an organization. It is not a rigid, step-by-step methodology.

---

**Q:** What is the core of TOGAF?
**A:** The Architecture Development Method (ADM) — an iterative, phase-based method for developing and managing an enterprise architecture.

---

**Q:** What are the six main components of TOGAF 10?
**A:** (1) ADM, (2) ADM Guidelines and Techniques, (3) Architecture Content Framework, (4) Enterprise Continuum & Tools, (5) Architecture Capability Framework, (6) TOGAF Library.

---

**Q:** What is the purpose of TOGAF?
**A:** To provide a practical, freely available industry standard method for enterprise architecture that enables organizations to design efficient and effective IT infrastructure, reduce costs, and align IT with business needs.

---

**Q:** What version of TOGAF introduced the "TOGAF Standard" vs "TOGAF Library" split?
**A:** TOGAF 10 (also called the TOGAF Standard, 10th Edition). It separated normative content (the Standard) from non-normative guidance (the Library).

---

**Q:** What is the TOGAF Standard (normative content)?
**A:** The core, mandatory part of TOGAF that defines the fundamental concepts, the ADM, and essential framework elements that must be followed for TOGAF conformance.

---

**Q:** What is the TOGAF Library (non-normative content)?
**A:** Supplementary guidance, reference materials, templates, and best practices that support the TOGAF Standard but are not required for conformance.

---

## 2. Key Definitions

**Q:** Define "Enterprise" in the TOGAF context.
**A:** The highest level of description of an organization, encompassing all its missions and functions. An enterprise can be a whole corporation, a division, a department, or a chain of geographically distant organizations linked by common ownership.

---

**Q:** Define "Architecture" as used in TOGAF.
**A:** (1) A formal description of a system, or a detailed plan of the system at component level, to guide its implementation. (2) The structure of components, their interrelationships, and the principles and guidelines governing their design and evolution over time.

---

**Q:** What is "Enterprise Architecture" (EA)?
**A:** A coherent whole of principles, methods, and models used in the design and realization of an enterprise's organizational structure, business processes, information systems, and IT infrastructure.

---

**Q:** Define "Architecture Framework."
**A:** A foundational structure, or set of structures, used to develop a broad range of different architectures. It describes a method for designing a target state of the enterprise in terms of building blocks, and shows how the building blocks fit together.

---

**Q:** What is "Baseline Architecture"?
**A:** The existing architecture — the "as-is" state of the enterprise at the beginning of an architecture project.

---

**Q:** What is "Target Architecture"?
**A:** The desired future-state architecture — the "to-be" state that addresses stakeholder concerns and meets business requirements.

---

**Q:** What is "Transition Architecture"?
**A:** An intermediate architecture between the baseline and target, representing a formally defined state that occurs at an architecturally significant point during transformation.

---

**Q:** Define "Gap" in TOGAF.
**A:** A statement about a difference between the baseline and target architectures. Gaps are identified through gap analysis and drive migration planning.

---

**Q:** What is an "Architecture Vision"?
**A:** A high-level, aspirational view of the target architecture created in Phase A. It provides an executive summary of the changes and the value to be delivered.

---

**Q:** Define "Concern" in TOGAF.
**A:** An interest in a system relevant to one or more of its stakeholders. Concerns may pertain to any aspect of the system's functioning, development, or operation.

---

**Q:** What is a "Capability" in the TOGAF context?
**A:** An ability that an organization, person, or system possesses. Capabilities are typically expressed in general, high-level terms and require a combination of organization, people, processes, and technology to achieve.

---

## 3. Architecture Domains

**Q:** What are the four architecture domains in TOGAF?
**A:** (1) Business Architecture, (2) Data Architecture, (3) Application Architecture, (4) Technology Architecture.

---

**Q:** What does Business Architecture describe?
**A:** The strategy, governance, organization, and key business processes of an enterprise. It defines the business strategy, governance, organization structure, and business processes.

---

**Q:** What does Data Architecture describe?
**A:** The structure of an organization's logical and physical data assets and data management resources. It covers the major types and sources of data, data entities and relationships, and data management policies.

---

**Q:** What does Application Architecture describe?
**A:** A blueprint for the individual application systems to be deployed, their interactions, and their relationships to the core business processes of the organization.

---

**Q:** What does Technology Architecture describe?
**A:** The logical software and hardware infrastructure capabilities needed to support the deployment of business, data, and application services. This includes IT infrastructure, middleware, networking, communications, processing, and standards.

---

**Q:** Which ADM phase develops Business Architecture?
**A:** Phase B — Business Architecture.

---

**Q:** Which ADM phases develop Information Systems Architectures (Data + Application)?
**A:** Phase C — Information Systems Architectures (covers both Data Architecture and Application Architecture).

---

**Q:** Which ADM phase develops Technology Architecture?
**A:** Phase D — Technology Architecture.

---

**Q:** In what order are the architecture domains typically developed?
**A:** Business → Data → Application → Technology (often called "BDAT"). However, TOGAF allows flexibility — Phase C (Data and Application) can be done in either order or in parallel.

---

**Q:** Why does Business Architecture come before the other domains?
**A:** Because it establishes the business context, strategy, and requirements that drive the data, application, and technology architectures. Architecture should be business-driven.

---

## 4. TOGAF Components — Enterprise Continuum

**Q:** What is the Enterprise Continuum?
**A:** A categorization mechanism for classifying architecture and solution artifacts — from generic (industry-wide) to organization-specific. It provides context for understanding how architectures and solutions evolve.

---

**Q:** What are the two main parts of the Enterprise Continuum?
**A:** (1) Architecture Continuum — classifies architecture descriptions from Foundation to Organization-Specific. (2) Solutions Continuum — classifies solution implementations from Foundation to Organization-Specific.

---

**Q:** What is the spectrum of the Architecture Continuum (left to right)?
**A:** Foundation Architectures → Common Systems Architectures → Industry Architectures → Organization-Specific Architectures.

---

**Q:** What is the spectrum of the Solutions Continuum (left to right)?
**A:** Foundation Solutions → Common Systems Solutions → Industry Solutions → Organization-Specific Solutions.

---

**Q:** What is a Foundation Architecture?
**A:** The most generic architecture — a Technical Reference Model (TRM) that provides a foundation on which more specific architectures can be built.

---

**Q:** What is the relationship between the Architecture Continuum and Solutions Continuum?
**A:** They mirror each other. At each level, architectures in the Architecture Continuum guide the selection and development of corresponding solutions in the Solutions Continuum.

---

## 5. TOGAF Components — Architecture Repository

**Q:** What is the Architecture Repository?
**A:** A structured storage facility for all architecture-related outputs within an organization. It holds architecture deliverables, artifacts, models, patterns, and reference materials.

---

**Q:** What are the six classes of information stored in the Architecture Repository?
**A:** (1) Architecture Metamodel, (2) Architecture Capability, (3) Architecture Landscape, (4) Standards Information Base (SIB), (5) Reference Library, (6) Governance Log.

---

**Q:** What is the Architecture Landscape?
**A:** The architectural representation of assets (actual state) deployed within the enterprise at a particular point in time. It provides a view across the organization at three levels: Strategic, Segment, and Capability.

---

**Q:** What are the three levels of the Architecture Landscape?
**A:** (1) Strategic Architecture — long-term summary view, (2) Segment Architecture — detailed view of a specific business area or program, (3) Capability Architecture — detailed view of a particular capability.

---

**Q:** What is the Standards Information Base (SIB)?
**A:** A repository area that captures the standards with which new architectures must comply, including industry standards, selected products, and services.

---

**Q:** What is the Reference Library?
**A:** A repository area for reference materials — guidelines, templates, patterns, and other forms of reference material used in architecture development.

---

**Q:** What is the Governance Log?
**A:** A repository area that provides a record of governance activity, including decision records, compliance assessments, capability assessments, and architecture contracts.

---

## 6. Building Blocks

**Q:** What is a Building Block (BB) in TOGAF?
**A:** A (potentially re-usable) component of enterprise capability that can be combined with other building blocks to deliver architectures and solutions.

---

**Q:** What is an Architecture Building Block (ABB)?
**A:** A component of architecture that describes a required capability. ABBs are technology-aware and define the required functionality and attributes. They capture architecture requirements.

---

**Q:** What is a Solution Building Block (SBB)?
**A:** A component of a solution that fulfills the requirements specified by an ABB. SBBs are product- or vendor-aware and define the actual implementation.

---

**Q:** What is the relationship between ABBs and SBBs?
**A:** ABBs define *what* is needed (requirements-driven). SBBs define *how* those requirements are met (implementation-driven). SBBs implement or realize ABBs.

---

**Q:** At what point in the ADM are ABBs typically defined?
**A:** During Phases B, C, and D (architecture development phases) where architecture requirements are captured.

---

**Q:** At what point in the ADM are SBBs typically defined?
**A:** During Phases E (Opportunities and Solutions) and F (Migration Planning) where implementation solutions are determined.

---

## 7. Stakeholders, Views & Viewpoints

**Q:** What is a Stakeholder in TOGAF?
**A:** An individual, team, organization, or class thereof, having an interest (concern) in a system. Examples: CIO, end users, developers, project managers, sponsors.

---

**Q:** What is a View in TOGAF?
**A:** A representation of a whole system from the perspective of a related set of concerns. A view addresses one or more concerns of the stakeholders who have those concerns.

---

**Q:** What is a Viewpoint in TOGAF?
**A:** A specification of the conventions for constructing and using a view. A viewpoint defines the perspective from which a view is taken — it is the "template" for creating views.

---

**Q:** What is the relationship between Views and Viewpoints?
**A:** A viewpoint is the template/specification; a view is an instance of a viewpoint populated with actual architecture content for a specific system. Think: viewpoint = cookie cutter, view = cookie.

---

**Q:** Why are stakeholder views important in architecture?
**A:** Because different stakeholders have different concerns, and no single representation of an architecture is suitable for all. Views ensure each stakeholder group can understand the architecture in terms relevant to them.

---

## 8. Architecture Principles

**Q:** What is an Architecture Principle?
**A:** A qualitative statement of intent about the architecture. Principles reflect a level of consensus across the enterprise and embody the spirit and thinking of the architecture.

---

**Q:** What are the five recommended components of an Architecture Principle?
**A:** (1) Name — a label, (2) Statement — succinct description of the principle, (3) Rationale — why the principle is important, (4) Implications — what must happen to follow the principle, (5) Metrics (optional in some formulations).

---

**Q:** In which ADM phase are Architecture Principles typically defined?
**A:** In the Preliminary Phase. Principles are an input to Phase A and guide all subsequent ADM phases.

---

**Q:** Give an example of a common architecture principle.
**A:** "Technology Independence" — applications should not depend on specific technology choices, allowing the technology platform to change without impacting applications.

---

**Q:** What is the difference between Architecture Principles and Architecture Requirements?
**A:** Principles are general rules and guidelines that inform and constrain all architecture work. Requirements are specific, measurable needs for a particular architecture project. Principles are enduring; requirements are project-specific.

---

---

*Total: 55 flashcards — TOGAF Core Concepts*
