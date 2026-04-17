# TOGAF 10 Content Framework Flashcards

> 65+ exam-focused flashcards covering the Architecture Content Framework.
> Format: **Q** = Question, **A** = Answer

---

## 1. Content Framework Overview

**Q:** What is the Architecture Content Framework?
**A:** A structured model for defining and classifying architectural work products. It categorizes outputs into Deliverables, Artifacts, and Building Blocks, and is supported by the Content Metamodel.

---

**Q:** What are the three categories of architectural work products?
**A:** (1) Deliverables — formal work products contractually specified and reviewed/signed off by stakeholders. (2) Artifacts — more granular architectural content (catalogs, matrices, diagrams). (3) Building Blocks — reusable components of capability (ABBs and SBBs).

---

**Q:** What is the hierarchy relationship: Deliverables → Artifacts → Building Blocks?
**A:** Deliverables contain one or more artifacts. Artifacts describe building blocks. Building blocks are the actual reusable architecture or solution components. Each level provides a different granularity of content.

---

**Q:** What is the Content Metamodel?
**A:** A formal definition of the types of entities (e.g., services, functions, actors, data entities), their attributes, and the relationships between them that are used in TOGAF architecture descriptions.

---

---

## 2. Deliverables — Overview and List

**Q:** What is a Deliverable in TOGAF?
**A:** A formally reviewed and agreed-upon work product produced during the ADM. Deliverables represent the output of projects and are contractually specified.

---

**Q:** List the key TOGAF deliverables.
**A:** Architecture Principles, Architecture Vision, Architecture Definition Document, Architecture Requirements Specification, Architecture Roadmap, Transition Architectures, Statement of Architecture Work, Implementation and Migration Plan, Architecture Contracts, Compliance Assessments, Architecture Building Blocks, Solution Building Blocks, Request for Architecture Work, Communications Plan, Implementation Governance Model.

---

**Q:** Which deliverable is produced in the Preliminary Phase?
**A:** Architecture Principles, Tailored Architecture Framework, Organizational Model for Enterprise Architecture.

---

**Q:** Which deliverables are produced in Phase A?
**A:** Architecture Vision, Statement of Architecture Work, Communications Plan.

---

**Q:** Which deliverable is progressively built in Phases B, C, and D?
**A:** Architecture Definition Document (each phase adds its domain-specific content).

---

**Q:** Which deliverable is updated in every phase from B onward?
**A:** Architecture Requirements Specification — it is updated as requirements are identified, refined, and validated in each phase.

---

**Q:** Which deliverable is produced in Phase E?
**A:** Architecture Roadmap (consolidated), Transition Architectures, initial Implementation and Migration Plan.

---

**Q:** Which deliverable is finalized in Phase F?
**A:** Implementation and Migration Plan, finalized Architecture Roadmap.

---

**Q:** Which deliverable is produced in Phase G?
**A:** Architecture Contracts (signed), Compliance Assessments.

---

**Q:** What is the Architecture Definition Document (ADD)?
**A:** The comprehensive deliverable that captures the baseline and target architectures for all four domains (Business, Data, Application, Technology). It is built incrementally across Phases B, C, and D.

---

**Q:** What is the Architecture Requirements Specification?
**A:** A quantitative document capturing all architecture requirements — functional, non-functional, constraints, and assumptions — that the architecture must satisfy.

---

---

## 3. Artifacts — Catalogs

**Q:** What is a Catalog in TOGAF?
**A:** A list of items (things) in the architecture — an ordered inventory of building blocks or elements of a specific type. Examples: list of all applications, list of all data entities.

---

**Q:** List the key Catalogs in the Architecture Content Framework.
**A:** Organization/Actor Catalog, Driver/Goal/Objective Catalog, Role Catalog, Business Service/Function Catalog, Location Catalog, Process/Event/Control/Product Catalog, Contract/Measure Catalog, Data Entity/Data Component Catalog, Application Portfolio Catalog, Interface Catalog, Technology Standards Catalog, Technology Portfolio Catalog.

---

**Q:** Which catalogs are created in Phase B (Business Architecture)?
**A:** Organization/Actor Catalog, Driver/Goal/Objective Catalog, Role Catalog, Business Service/Function Catalog, Location Catalog, Process/Event/Control/Product Catalog, Contract/Measure Catalog.

---

**Q:** Which catalogs are created in Phase C (Data Architecture)?
**A:** Data Entity/Data Component Catalog.

---

**Q:** Which catalogs are created in Phase C (Application Architecture)?
**A:** Application Portfolio Catalog, Interface Catalog.

---

**Q:** Which catalogs are created in Phase D (Technology Architecture)?
**A:** Technology Standards Catalog, Technology Portfolio Catalog.

---

**Q:** What does the Application Portfolio Catalog contain?
**A:** An inventory of all applications in the enterprise, including attributes such as name, description, owner, technology platform, lifecycle status (active, retiring, planned), and supported business functions.

---

**Q:** What does the Technology Standards Catalog contain?
**A:** A list of approved technology standards — products, versions, platforms, and their compliance status (mandated, preferred, emerging, retiring, retired).

---

---

## 4. Artifacts — Matrices

**Q:** What is a Matrix in TOGAF?
**A:** A grid showing the relationship between two types of entities. Matrices map one architectural element to another to show dependencies, interactions, or CRUD operations.

---

**Q:** List the key Matrices in the Architecture Content Framework.
**A:** Business Interaction Matrix, Actor/Role Matrix, Data Entity/Business Function Matrix, Application/Organization Matrix, Role/Application Matrix, Application/Function Matrix, Application Interaction Matrix, Application/Technology Matrix.

---

**Q:** Which matrices are created in Phase B?
**A:** Business Interaction Matrix, Actor/Role Matrix.

---

**Q:** Which matrices are created in Phase C (Data Architecture)?
**A:** Data Entity/Business Function Matrix (CRUD matrix), Application/Data Matrix.

---

**Q:** Which matrices are created in Phase C (Application Architecture)?
**A:** Application/Organization Matrix, Role/Application Matrix, Application/Function Matrix, Application Interaction Matrix.

---

**Q:** Which matrices are created in Phase D?
**A:** Application/Technology Matrix.

---

**Q:** What does the Data Entity/Business Function Matrix show?
**A:** Which business functions Create, Read, Update, or Delete (CRUD) which data entities. It is a critical data governance artifact.

---

**Q:** What does the Application Interaction Matrix show?
**A:** The communication and data-exchange relationships between application systems — which applications interact with each other and the nature of those interactions.

---

**Q:** What does the Application/Technology Matrix show?
**A:** The mapping of applications to their supporting technology platforms — which technology infrastructure supports which applications.

---

---

## 5. Artifacts — Diagrams

**Q:** What is a Diagram in TOGAF?
**A:** A visual representation of architectural information. Diagrams present views of the architecture that are tailored to the concerns of specific stakeholders.

---

**Q:** List the key Business Architecture Diagrams.
**A:** Business Footprint Diagram, Business Service/Information Diagram, Functional Decomposition Diagram, Product Lifecycle Diagram.

---

**Q:** List the key Data Architecture Diagrams.
**A:** Conceptual Data Diagram, Logical Data Diagram, Data Dissemination Diagram, Data Security Diagram, Data Migration Diagram, Data Lifecycle Diagram.

---

**Q:** List the key Application Architecture Diagrams.
**A:** Application Communication Diagram, Application and User Location Diagram, Application Use-Case Diagram, Enterprise Manageability Diagram, Process/Application Realization Diagram, Software Engineering Diagram, Application Migration Diagram, Software Distribution Diagram.

---

**Q:** List the key Technology Architecture Diagrams.
**A:** Environments and Locations Diagram, Platform Decomposition Diagram, Processing Diagram, Networked Computing/Hardware Diagram, Communications Engineering Diagram.

---

**Q:** What does a Business Footprint Diagram show?
**A:** The links between business goals, business units, business functions, and the services and data that support them — showing the overall business landscape.

---

**Q:** What does a Functional Decomposition Diagram show?
**A:** A hierarchical breakdown of business functions into sub-functions, providing a structured view of what the organization does.

---

**Q:** What does an Application Communication Diagram show?
**A:** The relationships and data flows between application components, showing how applications communicate with each other.

---

**Q:** What does a Platform Decomposition Diagram show?
**A:** The technology platform that supports the information systems architecture, broken down into technology components and their relationships.

---

**Q:** What does a Data Dissemination Diagram show?
**A:** How data flows between data stores and application components, showing the relationship between data entities, data stores, and consuming applications.

---

---

## 6. Building Blocks (ABB vs SBB)

**Q:** What is an Architecture Building Block (ABB)?
**A:** A package of functionality defined to meet business requirements. ABBs are technology-aware, capture architecture requirements, and define *what* capability is needed (not *how*).

---

**Q:** What is a Solution Building Block (SBB)?
**A:** A candidate product, solution, or component that implements the functionality defined by an ABB. SBBs are product/vendor-aware and define *how* the requirement is realized.

---

**Q:** What are the characteristics of a good Building Block?
**A:** (1) Implements one or more published interfaces, (2) May interoperate with other building blocks, (3) May be assembled from other building blocks, (4) May represent a re-usable component, (5) Conforms to the overall architecture.

---

**Q:** In which phases are ABBs created?
**A:** Phases B, C, D — during architecture definition.

---

**Q:** In which phases are SBBs identified?
**A:** Phases E and F — during opportunities/solutions identification and migration planning.

---

**Q:** What drives the ABB-to-SBB mapping?
**A:** The ABBs (requirements) are matched against available products, technologies, and solutions (SBBs) during Phase E. Gap analysis reveals where new SBBs must be procured, built, or configured.

---

**Q:** Give an example of an ABB and its corresponding SBB.
**A:** ABB: "Relational Data Store — must support ACID transactions and handle 10K concurrent users." SBB: "Oracle Database 19c Enterprise Edition" or "PostgreSQL 15."

---

---

## 7. Content Metamodel

**Q:** What is the purpose of the Content Metamodel?
**A:** To provide a formal definition of the entities, attributes, and relationships that make up the architecture content, ensuring consistency and completeness across all architecture descriptions.

---

**Q:** Name key entities in the Content Metamodel.
**A:** Actor, Role, Organization Unit, Function, Business Service, Process, Data Entity, Application Component, Technology Component, Platform Service, Principle, Constraint, Requirement, Assumption, Gap, Work Package, Capability, Course of Action, Event, Location, Goal, Objective, Measure.

---

**Q:** What is the difference between an Actor and a Role in the metamodel?
**A:** An Actor is a person, organization, or system that performs actions. A Role is a set of responsibilities or behaviors that an Actor assumes in a given context. An Actor may play multiple Roles.

---

**Q:** What is the difference between a Function and a Service in the metamodel?
**A:** A Function is an internal capability (what the organization does). A Service is an externally visible, contracted piece of functionality (what the organization exposes to consumers).

---

**Q:** What is a Data Entity?
**A:** An encapsulation of data recognized by a business domain expert as a "thing" — a fundamental data concept with identity and lifecycle (e.g., Customer, Order, Product).

---

**Q:** What is an Application Component?
**A:** An encapsulation of application functionality, aligned to implementation technology. It is a self-contained unit of functionality in the application architecture.

---

**Q:** What is a Technology Component?
**A:** An encapsulation of technology infrastructure that represents a technology solution to a specific problem. Examples: server, database platform, network switch.

---

**Q:** What is a Platform Service?
**A:** A technology capability provided by the technology infrastructure to support the deployment of applications and data services. Examples: hosting, messaging, security services.

---

## 8. Artifacts-to-Phase Mapping (Exam Focus)

**Q:** Which phase produces the Organization/Actor Catalog?
**A:** Phase B — Business Architecture.

---

**Q:** Which phase produces the Data Entity/Data Component Catalog?
**A:** Phase C — Information Systems Architectures (Data Architecture).

---

**Q:** Which phase produces the Application Portfolio Catalog?
**A:** Phase C — Information Systems Architectures (Application Architecture).

---

**Q:** Which phase produces the Technology Standards Catalog?
**A:** Phase D — Technology Architecture.

---

**Q:** Which phase produces the Business Interaction Matrix?
**A:** Phase B — Business Architecture.

---

**Q:** Which phase produces the Data Entity/Business Function Matrix?
**A:** Phase C — Data Architecture.

---

**Q:** Which phase produces the Application/Technology Matrix?
**A:** Phase D — Technology Architecture.

---

**Q:** Which phase produces the Platform Decomposition Diagram?
**A:** Phase D — Technology Architecture.

---

**Q:** Which phase produces the Functional Decomposition Diagram?
**A:** Phase B — Business Architecture.

---

**Q:** Which phase produces the Application Communication Diagram?
**A:** Phase C — Application Architecture.

---

**Q:** Exam trap: Can artifacts from one phase be reused or referenced in another?
**A:** Yes. Artifacts from earlier phases are key inputs to subsequent phases. For example, the Application Portfolio Catalog from Phase C is referenced in Phase D when mapping applications to technology platforms.

---

---

*Total: 65 flashcards — Architecture Content Framework*
