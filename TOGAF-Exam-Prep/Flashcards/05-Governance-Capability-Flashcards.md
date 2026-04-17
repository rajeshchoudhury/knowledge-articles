# TOGAF 10 Governance & Capability Flashcards

> 60+ exam-focused flashcards covering Architecture Governance and Capability Framework.
> Format: **Q** = Question, **A** = Answer

---

## 1. Architecture Governance — Overview

**Q:** What is Architecture Governance in TOGAF?
**A:** The practice and orientation by which enterprise architectures and other architectures are managed and controlled at an enterprise-wide level. It includes policies, procedures, organizations, and support structures.

---

**Q:** What are the key objectives of Architecture Governance?
**A:** (1) Ensure architecture consistency across the enterprise, (2) Ensure compliance with standards and regulations, (3) Manage architecture change, (4) Support decision-making, (5) Ensure accountability, (6) Protect the organization's architecture investment.

---

**Q:** What is the scope of Architecture Governance?
**A:** It covers the management of: architecture processes (ADM), architecture content, architecture contracts, architecture compliance, architecture change, and architecture organizational structures.

---

**Q:** Where in the ADM is Architecture Governance most active?
**A:** Governance is active throughout the ADM, but is particularly prominent in Phase G (Implementation Governance) and Phase H (Architecture Change Management). The governance framework is established in the Preliminary Phase.

---

**Q:** What organizational body oversees Architecture Governance?
**A:** The Architecture Board — a cross-organizational body that governs architecture decisions and compliance.

---

---

## 2. Architecture Board

**Q:** What is the Architecture Board?
**A:** A governance body responsible for overseeing the implementation of the architecture governance strategy, including reviewing and maintaining the architecture, managing compliance, and approving dispensations.

---

**Q:** What are the key responsibilities of the Architecture Board?
**A:** (1) Providing oversight of all architecture development, (2) Enforcing architecture compliance, (3) Approving or rejecting change requests, (4) Granting dispensations, (5) Resolving architecture conflicts, (6) Ensuring architecture governance processes are followed.

---

**Q:** Who typically sits on the Architecture Board?
**A:** Senior executives (CIO, CTO), chief architect, business unit representatives, program/project managers, and subject matter experts. The composition varies by organization.

---

**Q:** How often does the Architecture Board typically meet?
**A:** Regularly (e.g., monthly or quarterly) and ad-hoc when critical decisions or dispensation requests arise.

---

**Q:** What is the relationship between the Architecture Board and the Enterprise Architecture team?
**A:** The EA team performs the architecture work. The Architecture Board provides governance oversight, approval, and direction. The Board is the decision-making authority; the EA team is the executing body.

---

---

## 3. Architecture Contracts

**Q:** What is an Architecture Contract?
**A:** A joint, formal agreement between development partners and sponsors on the deliverables, quality, and fitness-for-purpose of an architecture. Contracts govern architecture development and implementation.

---

**Q:** What are the two types of Architecture Contracts?
**A:** (1) Architecture Development Contracts — between the architecture team and the business/sponsor, governing architecture deliverables and quality. (2) Business Users' Architecture Contracts — between the architecture function and implementation teams, governing implementation conformance to the architecture.

---

**Q:** In which phase are Architecture Contracts created?
**A:** Phase G — Implementation Governance. Contracts are drafted and signed to govern the implementation of the architecture.

---

**Q:** What does an Architecture Contract typically specify?
**A:** Scope, architecture deliverables, conformance requirements, compliance review schedule, consequences of non-conformance, change procedures, dispute resolution, and acceptance criteria.

---

**Q:** What happens if an implementation violates an Architecture Contract?
**A:** A compliance review is conducted. If non-conformant, the implementation team must remediate, or a dispensation must be formally requested and approved by the Architecture Board.

---

---

## 4. Compliance Levels

**Q:** What are the six levels of Architecture Compliance?
**A:** (1) Irrelevant, (2) Consistent, (3) Compliant, (4) Conformant, (5) Fully Conformant, (6) Non-Conformant.

---

**Q:** What is "Irrelevant" compliance?
**A:** The architecture specification has no features in common with the implementation — the specification is not applicable to that implementation.

---

**Q:** What is "Consistent" compliance?
**A:** The implementation has some features in common with the specification; those features are implemented in accordance with the specification, but the implementation does not fully cover the spec.

---

**Q:** What is "Compliant" compliance?
**A:** All implemented features conform to the specification, but some specification features are not implemented. The implementation is a subset of the specification.

---

**Q:** What is "Conformant" compliance?
**A:** All specification features are implemented in accordance with the specification, but the implementation may also contain additional features beyond the specification.

---

**Q:** What is "Fully Conformant" compliance?
**A:** Full one-to-one correspondence between the specification and the implementation. All spec features implemented, no extra features, perfect alignment.

---

**Q:** What is "Non-Conformant" compliance?
**A:** The implementation contains features that conflict with or violate the architecture specification. This is the only negative compliance level.

---

**Q:** Exam trick: What is the difference between "Compliant" and "Conformant"?
**A:** Compliant = everything implemented *follows* the spec, but spec is not fully covered (some spec items missing). Conformant = the spec is fully *covered* (all spec items implemented), but there may be extras. Think: Compliant = partial coverage, Conformant = full coverage.

---

---

## 5. Compliance Review Process

**Q:** What is the purpose of a Compliance Review?
**A:** To formally assess whether a project or solution conforms to the architecture, identify deviations, and recommend corrective action or dispensation.

---

**Q:** When are Compliance Reviews conducted?
**A:** During Phase G (Implementation Governance), typically at key project milestones: design review, code review, test review, pre-deployment review.

---

**Q:** What are the steps in a Compliance Review?
**A:** (1) Identify the project/solution to review, (2) Collect relevant architecture documents and implementation artifacts, (3) Assess against architecture specifications, (4) Classify the compliance level, (5) Document findings and recommendations, (6) Submit to Architecture Board for decision.

---

**Q:** What are the possible outcomes of a Compliance Review?
**A:** (1) Approved — implementation is compliant/conformant, (2) Dispensation granted — deviation is acceptable with conditions, (3) Remediation required — implementation must be corrected, (4) Escalation — significant deviation requires Architecture Board or higher-level decision.

---

**Q:** What is a dispensation?
**A:** A formal, documented exception from the Architecture Board permitting a specific deviation from the architecture specification, usually with conditions, a time limit, and a remediation plan.

---

---

## 6. Architecture Capability Framework

**Q:** What is the Architecture Capability Framework?
**A:** A TOGAF component that describes the organization, processes, skills, roles, and responsibilities needed to establish and operate an enterprise architecture practice within an organization.

---

**Q:** What are the key elements of the Architecture Capability Framework?
**A:** (1) Architecture Board, (2) Architecture Compliance, (3) Architecture Contracts, (4) Architecture Governance, (5) Architecture Maturity Models, (6) Architecture Skills Framework.

---

**Q:** What is the purpose of the Architecture Capability Framework?
**A:** To help organizations establish, mature, and sustain their enterprise architecture capability — ensuring they have the right people, processes, and tools to perform architecture work effectively.

---

**Q:** What is Architecture Maturity?
**A:** The level of sophistication of an organization's enterprise architecture practice, often measured using a maturity model (e.g., CMM-based levels from Initial through Optimizing).

---

**Q:** What is the typical maturity progression for an EA capability?
**A:** Level 1 (Initial/Ad Hoc) → Level 2 (Under Development) → Level 3 (Defined) → Level 4 (Managed) → Level 5 (Optimizing/Measured). Organizations aspire to reach at least Level 3.

---

---

## 7. Architecture Skills Framework

**Q:** What is the Architecture Skills Framework?
**A:** A framework that defines the skills, knowledge areas, and competency levels needed by members of the architecture team to perform their roles effectively.

---

**Q:** What skill categories does the Architecture Skills Framework cover?
**A:** Generic skills (e.g., leadership, communication, teamwork), Business skills (e.g., business process management, strategic planning), Enterprise Architecture skills (e.g., framework knowledge, modeling), Program/Project Management skills, IT General Knowledge skills (e.g., asset management, migration planning), Technical IT skills (e.g., software engineering, security, networking), Legal Environment awareness.

---

**Q:** What are the proficiency levels in the Skills Framework?
**A:** (1) Background — basic awareness, (2) Awareness — conceptual understanding, (3) Knowledge — working knowledge, (4) Expert — deep expertise capable of leading and mentoring.

---

**Q:** What roles are described in the Architecture Skills Framework?
**A:** Enterprise Architect, Business Architect, Data/Information Architect, Application Architect, Technology Architect, plus supporting roles like Architecture Program Manager.

---

**Q:** Why is the Skills Framework important for the exam?
**A:** The exam tests awareness that architecture is not just about methods and frameworks — it requires skilled people. Understanding the roles and skills ensures the organization can execute architecture work.

---

---

## 8. Enterprise Continuum

**Q:** What is the Enterprise Continuum?
**A:** A classification mechanism for architecture and solution artifacts, ranging from generic/foundational (applicable broadly across industries) to specific (tailored to a particular organization).

---

**Q:** What are the two halves of the Enterprise Continuum?
**A:** (1) Architecture Continuum — classifies architecture descriptions. (2) Solutions Continuum — classifies solution implementations.

---

**Q:** What are the four levels of the Architecture Continuum?
**A:** Foundation Architectures → Common Systems Architectures → Industry Architectures → Organization-Specific Architectures.

---

**Q:** What are the four levels of the Solutions Continuum?
**A:** Foundation Solutions → Common Systems Solutions → Industry Solutions → Organization-Specific Solutions.

---

**Q:** What is a Foundation Architecture?
**A:** The most generic architecture level — includes the Technical Reference Model (TRM). Provides the starting point that all other architectures build upon.

---

**Q:** What is a Common Systems Architecture?
**A:** An architecture that addresses common IT functions shared across many industries — e.g., security, network management, data management. The III-RM (Integrated Information Infrastructure Reference Model) is an example.

---

**Q:** What is an Industry Architecture?
**A:** An architecture tailored to a specific industry vertical — e.g., banking reference architecture, healthcare interoperability standards, telecommunications network architecture.

---

**Q:** What is an Organization-Specific Architecture?
**A:** An architecture that is unique to a specific enterprise, built by applying and customizing architectures from the other continuum levels to the organization's particular needs.

---

**Q:** How does the Enterprise Continuum relate to the Architecture Repository?
**A:** The Enterprise Continuum provides a classification scheme for the content stored in the Architecture Repository. Repository content is organized according to its position on the continuum.

---

---

## 9. Architecture Repository — Components

**Q:** What are the six components of the Architecture Repository?
**A:** (1) Architecture Metamodel, (2) Architecture Capability, (3) Architecture Landscape, (4) Standards Information Base (SIB), (5) Reference Library, (6) Governance Log.

---

**Q:** What is the Architecture Metamodel (in the repository)?
**A:** The formal definition of entity types, attributes, and relationships used to describe architecture content — it defines the structure of how architecture information is stored.

---

**Q:** What is the Architecture Capability (in the repository)?
**A:** Repository area that stores parameters, structures, and processes supporting the architecture capability — roles, responsibilities, governance processes, maturity assessments.

---

**Q:** What is the Architecture Landscape (in the repository)?
**A:** The representation of the actual deployed architecture at three levels: Strategic Architecture, Segment Architecture, and Capability Architecture.

---

**Q:** What is Strategic Architecture (landscape level)?
**A:** A high-level, long-range view of the entire enterprise architecture, providing direction for the segment and capability levels. Typically spans 3-5+ years.

---

**Q:** What is Segment Architecture (landscape level)?
**A:** A detailed architecture for a specific business segment, program, or major initiative. More detailed than strategic but broader than capability level.

---

**Q:** What is Capability Architecture (landscape level)?
**A:** The most detailed level, focusing on a specific capability or project. Provides the detailed design needed for implementation.

---

**Q:** What is the Standards Information Base (SIB)?
**A:** A repository of standards — industry standards, regulatory requirements, mandated technologies, and best practices that architectures must comply with.

---

**Q:** What is the Reference Library (in the repository)?
**A:** A collection of reference materials — guidelines, templates, patterns, architecture models, and reusable content that supports architecture development.

---

**Q:** What is the Governance Log (in the repository)?
**A:** A record of all governance activity — decisions, compliance assessments, dispensations, capability assessments, calendar of reviews, and architecture contracts.

---

---

## 10. Exam-Focus Questions

**Q:** Exam trap: Is Architecture Governance the same as IT Governance?
**A:** No. Architecture Governance is a subset of IT Governance. IT Governance covers the entire IT function. Architecture Governance specifically focuses on managing and controlling architecture development and compliance.

---

**Q:** Exam trap: Who approves dispensations?
**A:** The Architecture Board (or equivalent governance body). Dispensations cannot be self-granted by project teams.

---

**Q:** Exam trap: Where are Architecture Principles stored?
**A:** In the Architecture Repository. They are defined in the Preliminary Phase and stored as part of the repository's Reference Library or Architecture Capability content.

---

**Q:** Exam trap: What is the difference between the Architecture Landscape and the Architecture Definition Document?
**A:** The Architecture Landscape is the repository view of the deployed (actual) architecture at different levels. The Architecture Definition Document is a deliverable created during an ADM cycle that describes baseline and target architectures for a specific architecture project.

---

**Q:** Exam trap: Is the Enterprise Continuum a deliverable or a classification scheme?
**A:** A classification scheme. It is not a deliverable or artifact — it is a way of organizing and categorizing architecture and solution content within the Architecture Repository.

---

---

*Total: 60 flashcards — Governance & Capability*
