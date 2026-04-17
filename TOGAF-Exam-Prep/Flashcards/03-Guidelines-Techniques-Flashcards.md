# TOGAF 10 ADM Guidelines & Techniques Flashcards

> 60+ exam-focused flashcards covering all key ADM Guidelines and Techniques.
> Format: **Q** = Question, **A** = Answer

---

## 1. Gap Analysis

**Q:** What is Gap Analysis in TOGAF?
**A:** A technique for comparing the baseline architecture with the target architecture to identify gaps (what's missing), overlaps (what's redundant), and elements to be retained, replaced, or eliminated.

---

**Q:** In which ADM phases is Gap Analysis performed?
**A:** Primarily in Phases B, C, and D. The results are consolidated in Phase E.

---

**Q:** How is Gap Analysis typically represented?
**A:** As a matrix with baseline architecture elements on the rows and target architecture elements on the columns. Cells show whether elements are mapped (retained), modified, new, or eliminated.

---

**Q:** What are the four possible outcomes for an element in Gap Analysis?
**A:** (1) Retained/carried forward as-is, (2) Modified/enhanced, (3) New (exists in target but not baseline — a gap), (4) Eliminated (exists in baseline but not target — surplus).

---

**Q:** What drives the identification of work packages from Gap Analysis?
**A:** The gaps and modifications identified — each gap or modification becomes a candidate work package or project that must be implemented to reach the target state.

---

**Q:** What is a "consolidated" Gap Analysis?
**A:** The combination of gap analysis results from all architecture domains (B, C, D) into a single unified view in Phase E, enabling identification of cross-domain dependencies.

---

---

## 2. Stakeholder Management

**Q:** What is the purpose of Stakeholder Management in TOGAF?
**A:** To ensure that the interests, concerns, and expectations of all relevant stakeholders are identified, understood, and addressed throughout the architecture development process.

---

**Q:** In which phase is stakeholder identification and analysis primarily performed?
**A:** Phase A — Architecture Vision. Stakeholders are identified and their concerns are mapped.

---

**Q:** What is a Stakeholder Map?
**A:** A classification of stakeholders by their level of power (influence) and interest in the architecture, typically displayed as a Power/Interest grid.

---

**Q:** What are the four quadrants of the Power/Interest Grid?
**A:** (1) High Power / High Interest → Manage Closely (key players), (2) High Power / Low Interest → Keep Satisfied, (3) Low Power / High Interest → Keep Informed, (4) Low Power / Low Interest → Monitor.

---

**Q:** Name common stakeholder classes in TOGAF.
**A:** Corporate functions (CxOs), end-user organizations, project management, system operations, engineering/development, suppliers, regulatory bodies, architecture board.

---

**Q:** What is a Communication Plan?
**A:** A plan that defines how architecture information will be communicated to each stakeholder group, including format, frequency, level of detail, and communication channels.

---

**Q:** Why is stakeholder buy-in critical in Phase A?
**A:** Without stakeholder buy-in, the architecture effort will lack sponsorship, resources, and organizational support — leading to project failure.

---

---

## 3. Risk Management

**Q:** What is the TOGAF approach to Risk Management?
**A:** A structured approach to identifying, classifying, and mitigating risks throughout the ADM cycle. Risks are assessed for both the architecture itself and the architecture process.

---

**Q:** What are the two levels of risk in TOGAF?
**A:** (1) Initial Level of Risk — the risk before any mitigating action is taken. (2) Residual Level of Risk — the risk remaining after mitigation actions have been applied.

---

**Q:** How are risks classified in TOGAF?
**A:** By Effect (impact if the risk materializes — Catastrophic, Critical, Marginal, Negligible) and Frequency (likelihood — Frequent, Likely, Occasional, Seldom, Unlikely).

---

**Q:** What is Risk Mitigation in TOGAF?
**A:** Actions taken to reduce the probability or impact of identified risks. Each risk should have a mitigation strategy documented.

---

**Q:** Where is the risk register maintained?
**A:** In the Architecture Repository, typically within the Governance Log. Risks are tracked and updated throughout the ADM cycle.

---

**Q:** In which phases is risk assessment particularly important?
**A:** Phase A (initial risk identification), Phases E and F (implementation risk assessment and prioritization), and Phase G (monitoring risks during implementation).

---

**Q:** What is the Risk Matrix used for?
**A:** To plot risks by their severity (effect) and likelihood (frequency), enabling prioritization — risks in the high-impact, high-likelihood quadrant require immediate attention.

---

---

## 4. Migration Planning Techniques

**Q:** What is the Implementation Factor Assessment and Deduction matrix?
**A:** A technique used in Phases E and F that catalogs factors (risks, issues, assumptions, dependencies) for each candidate project, enabling assessment and prioritization.

---

**Q:** What factors does the Implementation Factor Assessment consider?
**A:** Risks, issues, assumptions, dependencies, actions needed, impact of each factor, and the resulting recommendation (go/no-go, priority, sequencing).

---

**Q:** What is the purpose of the Business Value Assessment?
**A:** To evaluate the business value contribution of each architecture work package, enabling prioritization of projects based on their value delivery.

---

**Q:** What criteria are used in Business Value Assessment?
**A:** Strategic alignment, financial return (ROI, NPV), stakeholder satisfaction, risk reduction, compliance achievement, competitive advantage, and operational improvement.

---

**Q:** What is a Transition Architecture?
**A:** A formally defined intermediate architecture state between baseline and target, representing a planned plateau in the transformation journey with measurable value delivery.

---

**Q:** How are projects sequenced in Migration Planning?
**A:** Based on: business value, dependencies between projects, resource availability, risk levels, quick-win potential, organizational readiness, and stakeholder priorities.

---

---

## 5. Capability-Based Planning

**Q:** What is Capability-Based Planning?
**A:** A business-driven planning technique that focuses on planning, engineering, and delivering strategic business capabilities to the enterprise, rather than specific technology solutions.

---

**Q:** How does Capability-Based Planning relate to the ADM?
**A:** It provides a business-driven approach for planning transformation that can be used across all ADM phases, particularly in the Preliminary Phase, Phase A, and Phases E/F.

---

**Q:** What is a Capability Increment?
**A:** A discrete portion of a capability architecture that delivers specific business value and can be planned, budgeted, and implemented independently.

---

**Q:** What are the benefits of Capability-Based Planning?
**A:** It ensures architecture work is aligned with business strategy, provides a common vocabulary between business and IT, enables incremental delivery of business value, and supports investment prioritization.

---

**Q:** What is the relationship between capabilities and Transition Architectures?
**A:** Transition Architectures represent the delivery of capability increments — each transition state delivers one or more capability increments on the path to the full target capability.

---

---

## 6. Architecture Compliance

**Q:** What is Architecture Compliance?
**A:** The degree to which an implementation conforms to the defined architecture. Compliance ensures that solutions are built and deployed as designed.

---

**Q:** What are the levels of Architecture Compliance in TOGAF?
**A:** (1) Irrelevant, (2) Consistent, (3) Compliant, (4) Conformant, (5) Fully Conformant, (6) Non-Conformant.

---

**Q:** Define "Irrelevant" compliance level.
**A:** The implementation has no features in common with the architecture specification — the architecture specification is not applicable.

---

**Q:** Define "Consistent" compliance level.
**A:** The implementation has some features in common with the architecture specification, and those features are implemented in accordance with it. It does not conflict, but does not fully implement the spec.

---

**Q:** Define "Compliant" compliance level.
**A:** Some features in the architecture specification are not implemented, but all implemented features are in accordance with it.

---

**Q:** Define "Conformant" compliance level.
**A:** All features in the architecture specification are implemented according to the specification, plus there may be additional features not covered by the spec.

---

**Q:** Define "Fully Conformant" compliance level.
**A:** There is a full, one-to-one correspondence between the architecture specification and the implementation. Every specified feature is implemented, and no additional features exist.

---

**Q:** Define "Non-Conformant" compliance level.
**A:** Some features in the implementation conflict with or violate the architecture specification.

---

**Q:** What is a Compliance Review?
**A:** A formal process conducted during Phase G to assess whether implementation projects and deployed solutions conform to the architecture definition and contracts.

---

**Q:** What is a dispensation in architecture compliance?
**A:** A formal exception granted when a project is found non-conformant but has valid justification. It permits the deviation under specific conditions and timeframes.

---

---

## 7. Business Transformation Readiness Assessment

**Q:** What is the Business Transformation Readiness Assessment?
**A:** A technique for evaluating the organization's readiness to undergo the changes proposed by the architecture. It assesses factors that could impact the success of the transformation.

---

**Q:** What factors does the Readiness Assessment evaluate?
**A:** Vision clarity, executive leadership commitment, IT governance capability, organizational change capacity, IT project management capability, ability to implement business process changes, ability to manage enterprise-level transformation, resource availability, skill levels.

---

**Q:** In which phases is the Readiness Assessment particularly useful?
**A:** Phase A (early assessment of readiness), Phase E (factor into solution choices), and Phase F (factor into migration planning and prioritization).

---

**Q:** What is a Readiness Factor?
**A:** A specific organizational capability or condition (e.g., "change management maturity," "executive sponsorship") that is assessed for its current state and desired state, with gaps identified.

---

**Q:** How are readiness factors rated?
**A:** Each factor is rated by its current maturity level and the urgency/importance of improving it. Factors with large gaps and high urgency are prioritized for action.

---

---

## 8. Interoperability

**Q:** What is Interoperability in TOGAF?
**A:** The ability of two or more systems or components to exchange and use information, and to perform functions cooperatively.

---

**Q:** What is the TOGAF approach to defining interoperability requirements?
**A:** Identify the degree of interoperability needed (operational, functional, constructive), define the nature of exchange (data, services, processes), and specify standards and protocols to achieve it.

---

**Q:** What are the types of interoperability in TOGAF?
**A:** (1) Operational interoperability — systems can work together in a meaningful way, (2) Functional interoperability — systems can exchange data, (3) Constructive interoperability — systems are built using compatible standards and interfaces.

---

**Q:** Why is interoperability a key consideration in architecture?
**A:** Because enterprises have multiple systems that must exchange information and work together. Lack of interoperability leads to data silos, redundant systems, and increased integration costs.

---

**Q:** In which phases is interoperability addressed?
**A:** Phase B (business interoperability requirements), Phase C (data and application interoperability), Phase D (technology interoperability standards), and Phase E (interoperability in solution design).

---

---

## 9. Business Scenarios

**Q:** What is a Business Scenario?
**A:** A technique for describing real business situations and problems in a way that enables architects to derive and document architecture requirements.

---

**Q:** What are the components of a Business Scenario?
**A:** (1) The business problem or opportunity, (2) The business and technology environment, (3) The actors and their roles, (4) The desired outcome, (5) Constraints, (6) Technical requirements derived from the scenario.

---

**Q:** In which phase are Business Scenarios primarily used?
**A:** Phase A — Architecture Vision, to develop and validate the Architecture Vision and to identify requirements.

---

**Q:** Why are Business Scenarios valuable for architecture?
**A:** They ground architecture work in real business problems, ensure architecture solutions address actual business needs, and provide a mechanism for validating architectures against requirements.

---

---

## 10. Architecture Patterns

**Q:** What is an Architecture Pattern in TOGAF?
**A:** A reusable solution to a commonly occurring architecture problem. Patterns capture proven design approaches that can be applied across multiple architecture engagements.

---

**Q:** Where are Architecture Patterns stored?
**A:** In the Architecture Repository, typically in the Reference Library, and they are part of the Enterprise Continuum.

---

**Q:** How do patterns relate to the Enterprise Continuum?
**A:** Patterns exist along the continuum — from generic Foundation Patterns (applicable broadly) to Organization-Specific Patterns (tailored to a specific enterprise).

---

---

## 11. Additional Techniques

**Q:** What is the purpose of the Architecture Definition Document?
**A:** To provide a comprehensive record of the baseline and target architectures for all four architecture domains, created across Phases B, C, and D.

---

**Q:** What is the Consolidated Gaps, Solutions, and Dependencies matrix?
**A:** A matrix created in Phase E that combines gap analysis results from all domains, mapping gaps to potential solutions and identifying dependencies between them.

---

**Q:** What is the role of iteration in the ADM?
**A:** Iteration allows the architecture to be refined progressively. Within a cycle, phases may be revisited. Across cycles, the entire ADM can be repeated to evolve the architecture over time.

---

**Q:** What is the difference between an Architecture Definition and an Architecture Requirements Specification?
**A:** The Architecture Definition Document describes the baseline and target architectures (the design). The Architecture Requirements Specification captures the measurable requirements that the architecture must satisfy (the constraints).

---

---

*Total: 60 flashcards — ADM Guidelines & Techniques*
