# TOGAF 10 Key Diagrams Guide

> ASCII text-based diagrams for all key TOGAF concepts.
> Each diagram includes labels and explanatory notes.

---

## 1. ADM Cycle (Circular Diagram with All Phases)

```
                        ┌──────────────────────┐
                        │     Preliminary       │
                        │  (Framework & Princ.) │
                        └──────────┬───────────┘
                                   │
                                   ▼
                        ┌──────────────────────┐
                        │    Phase A            │
                        │  Architecture Vision  │
                        └──────────┬───────────┘
                                   │
              ┌────────────────────┼────────────────────┐
              │                    │                     │
              ▼                    │                     ▼
   ┌─────────────────┐            │          ┌─────────────────┐
   │    Phase H       │            │          │    Phase B       │
   │  Arch. Change    │◄───┐      │     ┌───►│  Business Arch.  │
   │  Management      │    │      │     │    └────────┬────────┘
   └─────────┬───────┘    │      │     │             │
             │             │      │     │             ▼
             ▼             │ ┌────┴───┐ │    ┌─────────────────┐
   ┌─────────────────┐    │ │   RM   │ │    │    Phase C       │
   │    Phase G       │    │ │ Reqmts │ │    │  Info Systems    │
   │  Implementation  │    │ │ Mgmt   │ │    │  (Data + App)    │
   │  Governance      │    │ └────┬───┘ │    └────────┬────────┘
   └─────────┬───────┘    │      │     │             │
             │             │      │     │             ▼
             ▼             │      │     │    ┌─────────────────┐
   ┌─────────────────┐    │      │     │    │    Phase D       │
   │    Phase F       │    │      │     └────│  Technology      │
   │  Migration       │◄──┘      │          │  Architecture    │
   │  Planning        │          │          └────────┬────────┘
   └─────────┬───────┘          │                   │
             │                   │                   │
             │          ┌────────┴─────────┐        │
             └─────────►│    Phase E        │◄──────┘
                        │  Opportunities    │
                        │  & Solutions      │
                        └──────────────────┘
```

**Notes:**
- The ADM is a **cycle** — Phase H can loop back to Phase A for a new iteration
- **Requirements Management (RM)** sits at the center, interacting with ALL phases
- Phases B → C → D form the **Architecture Definition** iteration
- Phases E → F form the **Transition Planning** iteration
- Phases G → H form the **Architecture Governance** iteration
- The cycle is iterative — any phase can revisit a previous phase

---

## 2. Enterprise Continuum Spectrum

```
  GENERIC                                                      SPECIFIC
  (Industry-Wide)                                              (Your Org)
     │                                                              │
     ▼                                                              ▼
  ┌──────────────┬───────────────────┬─────────────────┬────────────────────┐
  │              │                   │                 │                    │
  │  Foundation  │  Common Systems   │    Industry     │  Organization-     │
  │              │                   │                 │  Specific          │
  ├──────────────┼───────────────────┼─────────────────┼────────────────────┤
  │              │                   │                 │                    │
  │  ARCH.       │                   │                 │                    │
  │  CONTINUUM   │  Architectures    │  Architectures  │  Architectures     │
  │  (designs)   │  shared across    │  tailored to    │  unique to your    │
  │              │  many industries  │  your sector    │  enterprise        │
  │              │                   │                 │                    │
  ├──────────────┼───────────────────┼─────────────────┼────────────────────┤
  │              │                   │                 │                    │
  │  SOLUTIONS   │                   │                 │                    │
  │  CONTINUUM   │  Solutions        │  Solutions      │  Solutions         │
  │  (products)  │  (e.g., DBMS,    │  (e.g., SWIFT   │  (e.g., custom     │
  │              │  middleware)      │  for banking)   │  ERP config)       │
  │              │                   │                 │                    │
  └──────────────┴───────────────────┴─────────────────┴────────────────────┘
       │                  │                   │                  │
       ▼                  ▼                   ▼                  ▼
      TRM             III-RM           Industry Ref.      Your Enterprise
  (Technical        (Integrated         Models           Architecture
   Reference        Information
   Model)           Infrastructure
                    Reference Model)

  ◄───────────────── Increasing Specificity ──────────────────►
  ◄───── Broader Applicability    Narrower Applicability ─────►
```

**Notes:**
- The Architecture Continuum and Solutions Continuum **mirror each other**
- Moving left-to-right: content becomes more specific and less reusable across organizations
- Moving right-to-left: content becomes more generic and broadly applicable
- The TRM sits at the Foundation level; the III-RM at the Common Systems level
- During ADM, you leverage content from the left and customize toward the right

---

## 3. Architecture Repository Structure

```
  ┌─────────────────────────────────────────────────────────────┐
  │                  ARCHITECTURE REPOSITORY                     │
  ├─────────────────────────────────────────────────────────────┤
  │                                                             │
  │  ┌───────────────────┐    ┌───────────────────────────┐    │
  │  │ 1. ARCHITECTURE   │    │ 2. ARCHITECTURE            │    │
  │  │    METAMODEL       │    │    CAPABILITY              │    │
  │  │                   │    │                             │    │
  │  │  Entity types,    │    │  Roles, processes,         │    │
  │  │  attributes,      │    │  governance structures,    │    │
  │  │  relationships    │    │  maturity assessments      │    │
  │  └───────────────────┘    └───────────────────────────┘    │
  │                                                             │
  │  ┌───────────────────────────────────────────────────────┐ │
  │  │ 3. ARCHITECTURE LANDSCAPE                             │ │
  │  │                                                       │ │
  │  │   ┌─────────────┐  ┌──────────────┐  ┌────────────┐ │ │
  │  │   │  Strategic   │  │   Segment    │  │ Capability │ │ │
  │  │   │  (3-5+ yr)   │  │  (program/   │  │ (project   │ │ │
  │  │   │  enterprise- │  │   business   │  │  level     │ │ │
  │  │   │  wide view)  │  │   area)      │  │  detail)   │ │ │
  │  │   └─────────────┘  └──────────────┘  └────────────┘ │ │
  │  │   ◄── Less Detail          More Detail ──►           │ │
  │  └───────────────────────────────────────────────────────┘ │
  │                                                             │
  │  ┌───────────────────┐    ┌───────────────────────────┐    │
  │  │ 4. STANDARDS      │    │ 5. REFERENCE LIBRARY      │    │
  │  │    INFORMATION     │    │                           │    │
  │  │    BASE (SIB)      │    │  Templates, patterns,    │    │
  │  │                   │    │  guidelines, models,      │    │
  │  │  Industry stds,   │    │  reusable reference       │    │
  │  │  mandated tech,   │    │  materials                │    │
  │  │  regulatory reqs  │    │                           │    │
  │  └───────────────────┘    └───────────────────────────┘    │
  │                                                             │
  │  ┌───────────────────────────────────────────────────────┐ │
  │  │ 6. GOVERNANCE LOG                                     │ │
  │  │                                                       │ │
  │  │  Decision records │ Compliance assessments            │ │
  │  │  Dispensations    │ Architecture contracts            │ │
  │  │  Capability assessments │ Review calendar             │ │
  │  └───────────────────────────────────────────────────────┘ │
  │                                                             │
  └─────────────────────────────────────────────────────────────┘
```

**Notes:**
- The Architecture Repository is the **single source of truth** for all architecture-related outputs
- The Architecture Landscape has three levels of granularity: Strategic > Segment > Capability
- The SIB captures what you MUST comply with; the Reference Library captures what you CAN reuse
- The Governance Log is the audit trail of all architecture decisions and compliance activity

---

## 4. Content Framework Hierarchy (Deliverables → Artifacts → Building Blocks)

```
  ┌────────────────────────────────────────────────────────┐
  │                    DELIVERABLES                         │
  │  (Formal, contractually specified work products)       │
  │                                                        │
  │  Examples:                                             │
  │  • Architecture Definition Document                    │
  │  • Architecture Requirements Specification             │
  │  • Architecture Roadmap                                │
  │  • Statement of Architecture Work                      │
  │                                                        │
  │    ┌──────────────────────────────────────────────┐    │
  │    │               ARTIFACTS                       │    │
  │    │  (Granular content within deliverables)       │    │
  │    │                                               │    │
  │    │  ┌──────────┐ ┌──────────┐ ┌──────────────┐  │    │
  │    │  │ CATALOGS │ │ MATRICES │ │   DIAGRAMS   │  │    │
  │    │  │ (lists)  │ │ (grids)  │ │  (visuals)   │  │    │
  │    │  └─────┬────┘ └────┬─────┘ └──────┬───────┘  │    │
  │    │        │           │              │           │    │
  │    │        └───────────┼──────────────┘           │    │
  │    │                    │                           │    │
  │    │    ┌───────────────┴───────────────────┐      │    │
  │    │    │        BUILDING BLOCKS             │      │    │
  │    │    │  (Reusable capability components)  │      │    │
  │    │    │                                    │      │    │
  │    │    │  ┌──────────┐    ┌──────────────┐ │      │    │
  │    │    │  │   ABBs   │───►│    SBBs      │ │      │    │
  │    │    │  │  (what)  │    │   (how)      │ │      │    │
  │    │    │  │ Phases   │    │  Phases      │ │      │    │
  │    │    │  │ B, C, D  │    │  E, F        │ │      │    │
  │    │    │  └──────────┘    └──────────────┘ │      │    │
  │    │    └───────────────────────────────────┘      │    │
  │    └──────────────────────────────────────────────┘    │
  └────────────────────────────────────────────────────────┘

  RELATIONSHIP:
  Deliverables ──contain──► Artifacts ──describe──► Building Blocks
```

**Notes:**
- **Deliverables** are the formal outputs reviewed and signed off by stakeholders
- **Artifacts** are the detailed content (catalogs = lists, matrices = grids, diagrams = pictures)
- **Building Blocks** are the reusable components described by artifacts
- ABBs (abstract, requirements) are realized by SBBs (concrete, products)

---

## 5. ABB to SBB Transformation

```
  ARCHITECTURE DEFINITION                    SOLUTION DESIGN
  (Phases B, C, D)                           (Phases E, F)

  ┌─────────────────────────┐               ┌──────────────────────────┐
  │  ARCHITECTURE BUILDING  │               │   SOLUTION BUILDING      │
  │  BLOCKS (ABBs)          │               │   BLOCKS (SBBs)          │
  │                         │               │                          │
  │  Define WHAT is needed  │──────────────►│  Define HOW it is built  │
  │                         │  "realizes"   │                          │
  │  • Technology-aware     │               │  • Product/vendor-aware  │
  │  • Requirements-driven  │               │  • Implementation-driven │
  │  • Abstract capability  │               │  • Concrete solution     │
  └─────────────────────────┘               └──────────────────────────┘
           │                                            │
           │                                            │
           ▼                                            ▼
  ┌─────────────────────────┐               ┌──────────────────────────┐
  │  Example:               │               │  Example:                │
  │  "Messaging Service:    │──────────────►│  "Apache Kafka 3.x      │
  │   must support async    │               │   deployed on AWS MSK    │
  │   pub/sub, >10K         │               │   with 3-broker          │
  │   msgs/sec, HA"         │               │   cluster"               │
  └─────────────────────────┘               └──────────────────────────┘

  ┌─────────────────────────┐               ┌──────────────────────────┐
  │  Example:               │               │  Example:                │
  │  "Identity Provider:    │──────────────►│  "Okta Enterprise SSO    │
  │   SSO, MFA, SAML 2.0,  │               │   with Okta Verify       │
  │   OAuth 2.0 support"    │               │   for MFA"               │
  └─────────────────────────┘               └──────────────────────────┘
```

**Notes:**
- ABBs are defined during architecture development (B, C, D) — they state requirements
- SBBs are identified during solution planning (E, F) — they name specific products/solutions
- The mapping is often many-to-many: one ABB may be fulfilled by multiple SBBs, and one SBB may fulfill multiple ABBs
- Gap analysis reveals where no existing SBB satisfies an ABB (requiring procurement, build, or configuration)

---

## 6. Stakeholder Power/Interest Grid

```
         HIGH POWER
              │
              │
  ┌───────────┼───────────────┐
  │           │               │
  │   KEEP    │    MANAGE     │
  │ SATISFIED │    CLOSELY    │
  │           │               │
  │  (Monitor │  (Key         │
  │   needs,  │   players,    │
  │   provide │   engage      │
  │   updates │   regularly,  │
  │   when    │   involve in  │
  │   asked)  │   decisions)  │
  │           │               │
  ├───────────┼───────────────┤  ◄── LOW INTEREST ──── HIGH INTEREST
  │           │               │
  │  MONITOR  │    KEEP       │
  │  (MINIMAL │   INFORMED    │
  │   EFFORT) │               │
  │           │  (Regular     │
  │  (Watch   │   updates,    │
  │   for     │   newsletters │
  │   changes │   and         │
  │   in      │   briefings)  │
  │   power/  │               │
  │   interest│               │
  │           │               │
  └───────────┼───────────────┘
              │
         LOW POWER

  Actions Summary:
  ┌────────────────┬─────────────────┬────────────────────────────┐
  │ Quadrant       │ Strategy        │ Example Stakeholders       │
  ├────────────────┼─────────────────┼────────────────────────────┤
  │ High/High      │ Manage Closely  │ CIO, Sponsor, Bus. Owner   │
  │ High/Low       │ Keep Satisfied  │ CFO, Legal, Board members  │
  │ Low/High       │ Keep Informed   │ Developers, End users      │
  │ Low/Low        │ Monitor         │ External vendors, public   │
  └────────────────┴─────────────────┴────────────────────────────┘
```

**Notes:**
- Created primarily in **Phase A** (Architecture Vision)
- Updated throughout the ADM as stakeholder dynamics change
- Drives the **Communication Plan** — different messages and channels for each quadrant
- "Manage Closely" stakeholders can make or break the architecture initiative

---

## 7. Architecture Landscape Levels

```
  ┌─────────────────────────────────────────────────────────────────┐
  │                                                                 │
  │  STRATEGIC ARCHITECTURE                                         │
  │  ═══════════════════════                                        │
  │  • Scope: Entire enterprise                                     │
  │  • Timeframe: 3-5+ years                                        │
  │  • Detail: High-level / summary                                 │
  │  • Purpose: Long-term direction and alignment                   │
  │                                                                 │
  │    ┌─────────────────────────────────────────────────────────┐  │
  │    │                                                         │  │
  │    │  SEGMENT ARCHITECTURE                                   │  │
  │    │  ═══════════════════════                                 │  │
  │    │  • Scope: Specific business area, program, or domain    │  │
  │    │  • Timeframe: 1-3 years                                  │  │
  │    │  • Detail: Moderate / more specific                      │  │
  │    │  • Purpose: Guide programs and initiatives               │  │
  │    │                                                         │  │
  │    │    ┌─────────────────────────────────────────────────┐  │  │
  │    │    │                                                 │  │  │
  │    │    │  CAPABILITY ARCHITECTURE                        │  │  │
  │    │    │  ═══════════════════════                         │  │  │
  │    │    │  • Scope: Specific capability or project        │  │  │
  │    │    │  • Timeframe: Months to 1 year                   │  │  │
  │    │    │  • Detail: Very detailed / implementation-ready  │  │  │
  │    │    │  • Purpose: Direct project implementation        │  │  │
  │    │    │                                                 │  │  │
  │    │    └─────────────────────────────────────────────────┘  │  │
  │    │                                                         │  │
  │    └─────────────────────────────────────────────────────────┘  │
  │                                                                 │
  └─────────────────────────────────────────────────────────────────┘

  SCOPE:    Broad ──────────────────────────────────────► Narrow
  DETAIL:   Low ────────────────────────────────────────► High
  HORIZON:  Long-term ─────────────────────────────────► Near-term
```

**Notes:**
- These three levels live in the Architecture Landscape component of the Architecture Repository
- Strategic Architecture provides the overall enterprise direction
- Segment Architecture details a specific business area or program
- Capability Architecture provides implementation-level detail for specific projects
- Each level must be consistent with the levels above it

---

## 8. Technical Reference Model (TRM) Structure

```
  ┌─────────────────────────────────────────────────────────────┐
  │                     QUALITIES                                │
  │  (Cross-cutting: Security, Manageability, Performance,      │
  │   Availability, Scalability, Interoperability)              │
  ├─────────────────────────────────────────────────────────────┤
  │                                                             │
  │                   APPLICATION PLATFORM                       │
  │                                                             │
  │  ┌───────────────────────────────────────────────────────┐  │
  │  │                APPLICATION SOFTWARE                    │  │
  │  │  (Business applications that users interact with)     │  │
  │  └───────────────────┬───────────────────────────────────┘  │
  │                      │ Application Platform Interface (API) │
  │  ┌───────────────────┴───────────────────────────────────┐  │
  │  │            APPLICATION PLATFORM SERVICES               │  │
  │  │                                                       │  │
  │  │  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌─────────┐ │  │
  │  │  │ Data     │ │ Intl.    │ │ Location │ │ Trans-  │ │  │
  │  │  │ Mgmt     │ │ Operation│ │ & Dir.   │ │ action  │ │  │
  │  │  │ Services │ │ Services │ │ Services │ │ Proc.   │ │  │
  │  │  └──────────┘ └──────────┘ └──────────┘ └─────────┘ │  │
  │  │  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌─────────┐ │  │
  │  │  │ User     │ │ Security │ │ System & │ │ Software│ │  │
  │  │  │ Interface│ │ Services │ │ Network  │ │ Engin.  │ │  │
  │  │  │ Services │ │          │ │ Mgmt     │ │ Services│ │  │
  │  │  └──────────┘ └──────────┘ └──────────┘ └─────────┘ │  │
  │  └───────────────────┬───────────────────────────────────┘  │
  │                      │ Comms Infrastructure Interface (CII) │
  │  ┌───────────────────┴───────────────────────────────────┐  │
  │  │         COMMUNICATIONS INFRASTRUCTURE                  │  │
  │  │  (Networking, middleware, operating systems)           │  │
  │  └───────────────────────────────────────────────────────┘  │
  │                                                             │
  └─────────────────────────────────────────────────────────────┘
```

**Notes:**
- The TRM is a **Foundation Architecture** on the Enterprise Continuum
- It provides a taxonomy for platform services that applications can use
- Two key interfaces: **API** (between apps and platform) and **CII** (between platform and infrastructure)
- Qualities (non-functional requirements) cut across all layers
- The TRM is generic — it is customized for specific organizations

---

## 9. Integrated Information Infrastructure Reference Model (III-RM)

```
  ┌─────────────────────────────────────────────────────────────┐
  │                        III-RM                                │
  │           (Common Systems Architecture level)                │
  │                                                             │
  │  ┌──────────────────────────────────────────────────────┐   │
  │  │               BUSINESS APPLICATIONS                   │   │
  │  │  (Consumer applications that need integrated info)    │   │
  │  └──────────────────────┬───────────────────────────────┘   │
  │                         │                                    │
  │  ┌──────────────────────┴───────────────────────────────┐   │
  │  │          INFRASTRUCTURE APPLICATIONS                  │   │
  │  │                                                       │   │
  │  │  ┌──────────┐  ┌───────────┐  ┌──────────────────┐  │   │
  │  │  │ Business │  │ Info.     │  │ Application      │  │   │
  │  │  │ Process  │  │ Access &  │  │ Integration      │  │   │
  │  │  │ Integ.   │  │ Delivery  │  │ Services         │  │   │
  │  │  └──────────┘  └───────────┘  └──────────────────┘  │   │
  │  │  ┌──────────┐  ┌───────────┐  ┌──────────────────┐  │   │
  │  │  │ Data     │  │ Content   │  │ Development      │  │   │
  │  │  │ Mgmt &   │  │ Mgmt &   │  │ Tools &          │  │   │
  │  │  │ Exchange │  │ Publish.  │  │ Services         │  │   │
  │  │  └──────────┘  └───────────┘  └──────────────────┘  │   │
  │  └──────────────────────┬───────────────────────────────┘   │
  │                         │                                    │
  │  ┌──────────────────────┴───────────────────────────────┐   │
  │  │            APPLICATION PLATFORM SERVICES              │   │
  │  │         (From TRM — underlying platform)              │   │
  │  └──────────────────────────────────────────────────────┘   │
  │                                                             │
  │  ┌──────────────────────────────────────────────────────┐   │
  │  │               QUALITIES                               │   │
  │  │  (Security, Availability, Performance, etc.)          │   │
  │  └──────────────────────────────────────────────────────┘   │
  │                                                             │
  └─────────────────────────────────────────────────────────────┘
```

**Notes:**
- The III-RM is a **Common Systems Architecture** on the Enterprise Continuum
- It builds ON TOP of the TRM, adding an Infrastructure Applications layer
- Focus: how to provide an **integrated information infrastructure** for business applications
- The key addition: Infrastructure Applications that integrate data, content, and business processes
- It shows how "boundaryless information flow" is achieved across the enterprise

---

## 10. Architecture Governance Framework

```
  ┌─────────────────────────────────────────────────────────────────┐
  │                ARCHITECTURE GOVERNANCE FRAMEWORK                 │
  ├─────────────────────────────────────────────────────────────────┤
  │                                                                 │
  │  ┌─────────────────────────────────────────────────────────┐   │
  │  │                   ARCHITECTURE BOARD                     │   │
  │  │  (Oversight, decisions, approvals, dispensations)        │   │
  │  └─────────────────────────┬───────────────────────────────┘   │
  │                            │                                    │
  │         ┌──────────────────┼──────────────────┐                │
  │         ▼                  ▼                  ▼                │
  │  ┌──────────────┐  ┌──────────────┐  ┌──────────────────┐    │
  │  │  POLICY &    │  │  COMPLIANCE  │  │  COMPLIANCE      │    │
  │  │  STANDARDS   │  │  REVIEWS     │  │  LEVELS          │    │
  │  │              │  │              │  │                  │    │
  │  │  • Arch.     │  │  • Design    │  │  • Irrelevant   │    │
  │  │    Principles│  │    review    │  │  • Consistent   │    │
  │  │  • Standards │  │  • Code      │  │  • Compliant    │    │
  │  │  • Guidelines│  │    review    │  │  • Conformant   │    │
  │  │  • Mandates  │  │  • Deploy    │  │  • Fully Conf.  │    │
  │  │              │  │    review    │  │  • Non-Conf.    │    │
  │  └──────────────┘  └──────────────┘  └──────────────────┘    │
  │                                                                 │
  │  ┌──────────────┐  ┌──────────────┐  ┌──────────────────┐    │
  │  │  CONTRACTS   │  │ DISPENSATION │  │  GOVERNANCE      │    │
  │  │              │  │  PROCESS     │  │  LOG             │    │
  │  │  • Dev.      │  │              │  │                  │    │
  │  │    contracts │  │  • Request   │  │  • Decisions     │    │
  │  │  • Business  │  │  • Evaluate  │  │  • Assessments   │    │
  │  │    contracts │  │  • Approve / │  │  • Dispensations  │    │
  │  │  • SLAs      │  │    Reject   │  │  • Contracts     │    │
  │  │              │  │  • Conditions│  │  • Calendar      │    │
  │  └──────────────┘  └──────────────┘  └──────────────────┘    │
  │                                                                 │
  │         ◄──── Feeds into Architecture Repository ────►         │
  │                                                                 │
  └─────────────────────────────────────────────────────────────────┘
```

**Notes:**
- The Architecture Board is the **central governance body**
- Governance activities span the entire ADM but are most active in Phases G and H
- Architecture Contracts bind both the EA team and implementation projects
- Dispensations are formal exceptions — they require Board approval and conditions
- All governance activity is recorded in the **Governance Log** in the Architecture Repository

---

## 11. Gap Analysis Matrix Template

```
  GAP ANALYSIS MATRIX

  Rows    = Baseline Architecture Elements (current state)
  Columns = Target Architecture Elements (future state)

              TARGET ELEMENTS
              ┌────────┬────────┬────────┬────────┬────────────┐
              │ T-Elem │ T-Elem │ T-Elem │ T-Elem │ ELIMINATED │
              │   1    │   2    │   3    │   4    │ (not in    │
              │        │        │        │        │  target)   │
  ┌───────────┼────────┼────────┼────────┼────────┼────────────┤
  │ B-Elem 1  │RETAINED│        │        │        │            │
  │ (current) │ as-is  │        │        │        │            │
  ├───────────┼────────┼────────┼────────┼────────┼────────────┤
  │ B-Elem 2  │        │MODIFIED│        │        │            │
  │ (current) │        │(change)│        │        │            │
  ├───────────┼────────┼────────┼────────┼────────┼────────────┤
  │ B-Elem 3  │        │        │        │        │ ELIMINATED │
  │ (current) │        │        │        │        │ (remove)   │
  ├───────────┼────────┼────────┼────────┼────────┼────────────┤
  │ B-Elem 4  │        │        │RETAINED│        │            │
  │ (current) │        │        │ as-is  │        │            │
  ├───────────┼────────┼────────┼────────┼────────┼────────────┤
  │ NEW       │        │        │        │  GAP   │            │
  │ (not in   │        │        │        │ (build │            │
  │  baseline)│        │        │        │  new)  │            │
  └───────────┴────────┴────────┴────────┴────────┴────────────┘

  CELL VALUES:
  ┌───────────────┬──────────────────────────────────────────┐
  │ RETAINED      │ Element exists in both — keep as-is      │
  │ MODIFIED      │ Element exists in both — needs changes   │
  │ GAP           │ New in target, not in baseline — BUILD   │
  │ ELIMINATED    │ In baseline only, not in target — REMOVE │
  │ (empty)       │ No relationship between these elements   │
  └───────────────┴──────────────────────────────────────────┘
```

**Notes:**
- Gap Analysis is performed in Phases B, C, and D for each architecture domain
- Results are consolidated in Phase E to identify cross-domain dependencies
- **Gaps** drive new work packages — things that must be built or acquired
- **Eliminated** items drive decommissioning work packages
- **Modified** items drive change/enhancement projects
- The matrix format makes it easy to see what changes are needed at a glance

---

## 12. Implementation Factor Assessment Matrix

```
  IMPLEMENTATION FACTOR ASSESSMENT AND DEDUCTION MATRIX

  ┌────────────────┬─────────┬────────┬──────────┬──────────┬────────────┐
  │                │         │        │          │          │            │
  │  WORK PACKAGE  │  RISK   │ ISSUE  │ASSUMPTION│DEPENDENCY│   ACTION   │
  │                │         │        │          │          │            │
  ├────────────────┼─────────┼────────┼──────────┼──────────┼────────────┤
  │                │         │        │          │          │            │
  │  WP-1:         │ Medium  │ Legacy │ Budget   │ WP-3     │ Prototype  │
  │  Migrate CRM   │ (data   │ system │ approved │ must     │ first,     │
  │                │  loss)  │ EOL    │ by Q3    │ complete │ then       │
  │                │         │        │          │ first    │ migrate    │
  ├────────────────┼─────────┼────────┼──────────┼──────────┼────────────┤
  │                │         │        │          │          │            │
  │  WP-2:         │ Low     │ None   │ API      │ None     │ Proceed    │
  │  Deploy API    │         │        │ standard │          │ as         │
  │  Gateway       │         │        │ agreed   │          │ planned    │
  │                │         │        │          │          │            │
  ├────────────────┼─────────┼────────┼──────────┼──────────┼────────────┤
  │                │         │        │          │          │            │
  │  WP-3:         │ High    │ Vendor │ Contract │ WP-2     │ Negotiate  │
  │  Replace ERP   │ (scope, │ lock-  │ signed   │ provides │ contract,  │
  │                │  cost)  │ in     │ by Q2    │ APIs     │ phase the  │
  │                │         │        │          │          │ rollout    │
  ├────────────────┼─────────┼────────┼──────────┼──────────┼────────────┤
  │                │         │        │          │          │            │
  │  WP-4:         │ Medium  │ Skills │ Training │ None     │ Train      │
  │  Cloud          │ (outage)│ gap in │ complete │          │ staff,     │
  │  Migration     │         │ team   │ by Q1    │          │ pilot      │
  │                │         │        │          │          │ first      │
  └────────────────┴─────────┴────────┴──────────┴──────────┴────────────┘

  DEDUCTION (Prioritization):
  ┌────────────────┬──────────┬──────────┬──────────┬──────────┐
  │  WORK PACKAGE  │ BUSINESS │   RISK   │  EFFORT  │ PRIORITY │
  │                │  VALUE   │  LEVEL   │          │          │
  ├────────────────┼──────────┼──────────┼──────────┼──────────┤
  │  WP-2: API GW  │  High    │   Low    │   Low    │    1     │
  │  WP-4: Cloud   │  High    │  Medium  │  Medium  │    2     │
  │  WP-1: CRM     │  Medium  │  Medium  │  Medium  │    3     │
  │  WP-3: ERP     │  High    │   High   │   High   │    4     │
  └────────────────┴──────────┴──────────┴──────────┴──────────┘
```

**Notes:**
- Used in **Phases E and F** to evaluate and prioritize implementation projects
- The Assessment matrix catalogs factors for each work package
- The Deduction matrix derives prioritization from the assessed factors
- Dependencies between work packages constrain sequencing
- High-value, low-risk, low-effort items ("quick wins") are prioritized first
- This drives the final sequencing in the Implementation and Migration Plan

---

## Summary of All Diagrams

| # | Diagram | Key Concept | Exam Relevance |
|---|---------|-------------|----------------|
| 1 | ADM Cycle | Phase order, RM at center, iterative nature | Very High |
| 2 | Enterprise Continuum | Generic→Specific spectrum, TRM/III-RM placement | High |
| 3 | Architecture Repository | 6 components, Landscape levels | High |
| 4 | Content Framework | Deliverables→Artifacts→Building Blocks hierarchy | High |
| 5 | ABB to SBB | What vs How, phase mapping | High |
| 6 | Stakeholder Grid | Power/Interest quadrants and strategies | Medium |
| 7 | Architecture Landscape | Strategic→Segment→Capability levels | Medium |
| 8 | TRM Structure | API/CII interfaces, platform services | Medium |
| 9 | III-RM Structure | Infrastructure applications layer | Medium |
| 10 | Governance Framework | Board, compliance, contracts, dispensations | High |
| 11 | Gap Analysis Matrix | Retained/Modified/Gap/Eliminated | Very High |
| 12 | Implementation Factors | Risk/Issue/Dependency assessment and prioritization | Medium |

---
