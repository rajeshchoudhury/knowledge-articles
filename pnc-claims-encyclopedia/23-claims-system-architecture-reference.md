# Claims System Architecture: Complete Reference Guide

## Table of Contents

1. [Evolution of Claims System Architecture](#1-evolution-of-claims-system-architecture)
2. [Reference Architecture for Modern Claims Platform](#2-reference-architecture-for-modern-claims-platform)
3. [Core Claims Processing Engine](#3-core-claims-processing-engine)
4. [Microservices Decomposition](#4-microservices-decomposition)
5. [Database Architecture](#5-database-architecture)
6. [Event-Driven Architecture](#6-event-driven-architecture)
7. [Business Rules Engine Integration](#7-business-rules-engine-integration)
8. [Workflow Engine Integration](#8-workflow-engine-integration)
9. [Security Architecture](#9-security-architecture)
10. [Scalability and Performance](#10-scalability-and-performance)
11. [Cloud Architecture](#11-cloud-architecture)
12. [DevOps and CI/CD](#12-devops-and-cicd)
13. [Observability](#13-observability)
14. [Disaster Recovery and Business Continuity](#14-disaster-recovery-and-business-continuity)
15. [Multi-Tenant Architecture](#15-multi-tenant-architecture)
16. [Complete Technology Stack](#16-complete-technology-stack)
17. [Architecture Decision Records](#17-architecture-decision-records)

---

## 1. Evolution of Claims System Architecture

### 1.1 Architecture Generations

```
CLAIMS SYSTEM ARCHITECTURE EVOLUTION:
+====================================================================+
|                                                                    |
|  GENERATION 1: MAINFRAME (1970s-1990s)                             |
|  +--------------------------------------------------------------+  |
|  |  Technology: COBOL, CICS, IMS DB, VSAM, DB2                  |  |
|  |  Architecture: Monolithic, batch-oriented                     |  |
|  |  UI: Green screen terminals (3270)                            |  |
|  |  Integration: Flat file exchange, JCL batch jobs              |  |
|  |  Characteristics:                                             |  |
|  |  ├── Highly reliable and performant for batch processing      |  |
|  |  ├── Difficult to modify or extend                            |  |
|  |  ├── Limited real-time capabilities                           |  |
|  |  ├── Deep institutional knowledge required                    |  |
|  |  └── Still running at many large carriers today               |  |
|  +--------------------------------------------------------------+  |
|                                                                    |
|  GENERATION 2: CLIENT-SERVER (1990s-2000s)                         |
|  +--------------------------------------------------------------+  |
|  |  Technology: VB6, PowerBuilder, Delphi, C++, Oracle/SQL Server|  |
|  |  Architecture: Two-tier or three-tier client-server           |  |
|  |  UI: Windows desktop applications (thick client)              |  |
|  |  Integration: ODBC, COM/DCOM, middleware (MQ Series)          |  |
|  |  Characteristics:                                             |  |
|  |  ├── Rich desktop user experience                             |  |
|  |  ├── Difficult deployment and version management              |  |
|  |  ├── Scalability limitations                                  |  |
|  |  ├── Tight coupling between UI and business logic             |  |
|  |  └── Many still in production (legacy modernization targets)  |  |
|  +--------------------------------------------------------------+  |
|                                                                    |
|  GENERATION 3: WEB-BASED (2000s-2010s)                             |
|  +--------------------------------------------------------------+  |
|  |  Technology: Java EE, .NET, Spring, JSP/ASP.NET, Oracle/SQL   |  |
|  |  Architecture: N-tier web application, SOA emerging           |  |
|  |  UI: Web browser (thin client), early AJAX                    |  |
|  |  Integration: Web services (SOAP/WSDL), ESB, XML messaging    |  |
|  |  Characteristics:                                             |  |
|  |  ├── Browser-based access (no client install)                 |  |
|  |  ├── Centralized deployment                                   |  |
|  |  ├── SOA principles for integration                           |  |
|  |  ├── Still often monolithic beneath the web layer             |  |
|  |  └── Major vendor platforms: Guidewire, Duck Creek, Majesco   |  |
|  +--------------------------------------------------------------+  |
|                                                                    |
|  GENERATION 4: SOA / API-BASED (2010s-2020s)                       |
|  +--------------------------------------------------------------+  |
|  |  Technology: Java/Spring, .NET Core, REST APIs, Angular/React |  |
|  |  Architecture: Service-Oriented Architecture, API-first       |  |
|  |  UI: Single Page Applications (SPA), responsive design        |  |
|  |  Integration: REST APIs, API Gateway, message queues          |  |
|  |  Characteristics:                                             |  |
|  |  ├── API-first design enabling multi-channel                  |  |
|  |  ├── Service reuse across applications                        |  |
|  |  ├── ESB as integration backbone                              |  |
|  |  ├── Beginning of cloud adoption                              |  |
|  |  └── Digital claims capabilities emerging                     |  |
|  +--------------------------------------------------------------+  |
|                                                                    |
|  GENERATION 5: CLOUD-NATIVE / MICROSERVICES (2020s+)               |
|  +--------------------------------------------------------------+  |
|  |  Technology: Go, Kotlin, Node.js, Python, React/Vue           |  |
|  |  Architecture: Microservices, event-driven, cloud-native      |  |
|  |  UI: React/Vue SPA, mobile-first, progressive web apps       |  |
|  |  Integration: Event streaming (Kafka), API mesh, GraphQL      |  |
|  |  Characteristics:                                             |  |
|  |  ├── Independent deployment of services                       |  |
|  |  ├── Auto-scaling for CAT surge                               |  |
|  |  ├── AI/ML embedded in claims processing                      |  |
|  |  ├── Real-time analytics and decisioning                      |  |
|  |  ├── Composable architecture                                  |  |
|  |  └── Multi-cloud and hybrid deployment                        |  |
|  +--------------------------------------------------------------+  |
|                                                                    |
+====================================================================+
```

---

## 2. Reference Architecture for Modern Claims Platform

### 2.1 High-Level Architecture Diagram

```
MODERN CLAIMS PLATFORM REFERENCE ARCHITECTURE:
+====================================================================+
|                                                                    |
|  ┌─────────────────── CHANNELS ──────────────────────────────────┐ |
|  │  Web Portal  │  Mobile App  │  Agent Portal  │  Partner API   │ |
|  └──────────────┴──────────────┴────────────────┴────────────────┘ |
|                              │                                     |
|  ┌───────────────────────────┴───────────────────────────────────┐ |
|  │                     API GATEWAY                                │ |
|  │  (Kong / AWS API GW / Apigee)                                 │ |
|  │  Auth │ Rate Limit │ Routing │ Transform │ Analytics          │ |
|  └───────────────────────────┬───────────────────────────────────┘ |
|                              │                                     |
|  ┌───────────────── BFF LAYER (Backend for Frontend) ────────────┐ |
|  │  Claims Web BFF  │  Mobile BFF  │  Partner BFF                │ |
|  └───────────────────────────┬───────────────────────────────────┘ |
|                              │                                     |
|  ╔═══════════════════════════╧═══════════════════════════════════╗ |
|  ║                  CORE CLAIMS SERVICES                         ║ |
|  ║  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐        ║ |
|  ║  │  FNOL    │ │  Claim   │ │ Coverage │ │ Reserve  │        ║ |
|  ║  │ Service  │ │ Service  │ │ Service  │ │ Service  │        ║ |
|  ║  └──────────┘ └──────────┘ └──────────┘ └──────────┘        ║ |
|  ║  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐        ║ |
|  ║  │ Payment  │ │Assignment│ │ Document │ │  Comms   │        ║ |
|  ║  │ Service  │ │ Service  │ │ Service  │ │ Service  │        ║ |
|  ║  └──────────┘ └──────────┘ └──────────┘ └──────────┘        ║ |
|  ║  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐        ║ |
|  ║  │  Fraud   │ │ Subrogo  │ │  Vendor  │ │ Analytics│        ║ |
|  ║  │ Service  │ │ Service  │ │ Service  │ │ Service  │        ║ |
|  ║  └──────────┘ └──────────┘ └──────────┘ └──────────┘        ║ |
|  ║  ┌──────────┐ ┌──────────┐                                   ║ |
|  ║  │  Search  │ │  Audit   │                                   ║ |
|  ║  │ Service  │ │ Service  │                                   ║ |
|  ║  └──────────┘ └──────────┘                                   ║ |
|  ╚═══════════════════════════╤═══════════════════════════════════╝ |
|                              │                                     |
|  ┌───────────────────────────┴───────────────────────────────────┐ |
|  │              EVENT STREAMING BACKBONE (Kafka)                  │ |
|  │  ClaimCreated│ReserveChanged│PaymentIssued│ClaimClosed│...    │ |
|  └───────────────────────────┬───────────────────────────────────┘ |
|                              │                                     |
|  ╔═══════════════════════════╧═══════════════════════════════════╗ |
|  ║               CROSS-CUTTING SERVICES                          ║ |
|  ║  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐        ║ |
|  ║  │  Rules   │ │ Workflow │ │ Identity │ │ Notifica │        ║ |
|  ║  │ Engine   │ │ Engine   │ │ (AuthN/Z)│ │  tion    │        ║ |
|  ║  │(Drools)  │ │(Camunda) │ │(Keycloak)│ │ Service  │        ║ |
|  ║  └──────────┘ └──────────┘ └──────────┘ └──────────┘        ║ |
|  ╚═══════════════════════════╤═══════════════════════════════════╝ |
|                              │                                     |
|  ┌───────────────────────────┴───────────────────────────────────┐ |
|  │                    DATA LAYER                                  │ |
|  │  PostgreSQL │ MongoDB │ Redis │ Elasticsearch │ S3/Blob       │ |
|  └───────────────────────────┬───────────────────────────────────┘ |
|                              │                                     |
|  ┌───────────────────────────┴───────────────────────────────────┐ |
|  │              EXTERNAL INTEGRATIONS                             │ |
|  │  Policy Admin│Billing│Reinsurance│Vendors│State Portals│...   │ |
|  └───────────────────────────────────────────────────────────────┘ |
|                                                                    |
+====================================================================+
```

---

## 3. Core Claims Processing Engine

### 3.1 Claim Creation and Management

```
CLAIM LIFECYCLE STATE MACHINE:
+------------------------------------------------------------------+
|                                                                  |
|  [FNOL Received] ──→ [Under Investigation]                       |
|       │                    │          │                           |
|       │                    ▼          ▼                           |
|       │              [Accepted]   [Denied]                       |
|       │                    │          │                           |
|       │                    ▼          ▼                           |
|       │              [In Handling] [Closed-Denied]                |
|       │                    │                                     |
|       │           ┌───────┼────────┐                             |
|       │           ▼       ▼        ▼                             |
|       │     [In Litigation] [In Settlement] [Ready to Close]     |
|       │           │       │        │                             |
|       │           ▼       ▼        ▼                             |
|       │     [Settled] ──→ [Closed]                               |
|       │                      │                                   |
|       │                      ▼                                   |
|       │                [Reopened] ──→ [In Handling] ──→ [Closed] |
|       │                                                          |
|       └──→ [Void/Duplicate] (terminal state)                    |
|                                                                  |
+------------------------------------------------------------------+
```

### 3.2 Coverage Verification Engine

```
COVERAGE VERIFICATION FLOW:
+------------------------------------------------------------------+
|                                                                  |
|  INPUT: Claim details (DOL, LOB, cause, location, insured)      |
|       │                                                          |
|       ▼                                                          |
|  1. POLICY RETRIEVAL                                             |
|     ├── Query Policy Administration System                       |
|     ├── Retrieve policy in force at DOL                          |
|     ├── Get all coverages, limits, deductibles                   |
|     └── Verify named insured and additional insureds             |
|       │                                                          |
|       ▼                                                          |
|  2. COVERAGE MATCHING                                            |
|     ├── Match cause of loss to covered perils                    |
|     ├── Identify applicable coverage part(s)                     |
|     ├── Check coverage territory                                 |
|     └── Verify occurrence within policy period                   |
|       │                                                          |
|       ▼                                                          |
|  3. EXCLUSION CHECK                                              |
|     ├── Evaluate all policy exclusions                           |
|     ├── Check endorsement modifications                          |
|     ├── Apply exclusion exceptions (exception to exclusion)      |
|     └── Document applicable exclusions                           |
|       │                                                          |
|       ▼                                                          |
|  4. CONDITIONS CHECK                                             |
|     ├── Notice requirements met?                                 |
|     ├── Cooperation obligation met?                              |
|     ├── Proof of loss submitted?                                 |
|     └── Other policy conditions                                  |
|       │                                                          |
|       ▼                                                          |
|  5. LIMITS AND DEDUCTIBLE APPLICATION                            |
|     ├── Apply per-occurrence limit                               |
|     ├── Apply aggregate limit (remaining)                        |
|     ├── Apply deductible/SIR                                     |
|     ├── Apply co-insurance clause                                |
|     └── Calculate available coverage                             |
|       │                                                          |
|       ▼                                                          |
|  OUTPUT: Coverage determination                                   |
|     ├── COVERED: with limits, deductibles identified             |
|     ├── NOT COVERED: with specific exclusion/reason              |
|     ├── PARTIAL: some coverages apply, others don't              |
|     └── PENDING: additional investigation needed                 |
|                                                                  |
+------------------------------------------------------------------+
```

### 3.3 Reserve Management Engine

```
RESERVE MANAGEMENT ARCHITECTURE:
+------------------------------------------------------------------+
|                                                                  |
|  RESERVE TYPES:                                                  |
|  ├── Case Reserve (Loss): adjuster-set per claim                 |
|  ├── Case Reserve (ALAE): allocated expense per claim            |
|  ├── IBNR (Incurred But Not Reported): actuarial estimate        |
|  ├── IBNER (Incurred But Not Enough Reported): development       |
|  ├── Bulk Reserve: portfolio-level reserve adjustment            |
|  └── Salvage/Subrogation Reserve: anticipated recoveries         |
|                                                                  |
|  RESERVE CALCULATION ENGINE:                                     |
|  ├── Initial reserves: auto-set based on rules                   |
|  │   ├── Claim type + LOB + severity = initial reserve table     |
|  │   ├── ML models for severity prediction                       |
|  │   └── Override capability for adjusters                       |
|  ├── Reserve changes: adjuster-initiated with approval           |
|  │   ├── Authority levels by role and amount                     |
|  │   ├── Approval workflow for changes above threshold           |
|  │   └── Full audit trail of all changes                        |
|  └── Automated reserve reviews:                                  |
|      ├── Diary-driven review schedule                            |
|      ├── Rule-based adequacy checks                              |
|      └── Actuarial development factor application                |
|                                                                  |
|  RESERVE AUTHORITY MATRIX:                                       |
|  +------------------------------------------------------------+  |
|  | Role              | Individual | Change     | Approval     |  |
|  |                   | Claim Limit| Authority  | Required >   |  |
|  +------------------------------------------------------------+  |
|  | Adjuster I        | $50,000    | $10,000    | $10,000      |  |
|  | Adjuster II       | $150,000   | $25,000    | $25,000      |  |
|  | Senior Adjuster   | $500,000   | $75,000    | $75,000      |  |
|  | Claims Supervisor | $1,000,000 | $250,000   | $250,000     |  |
|  | Claims Manager    | $5,000,000 | $1,000,000 | $1,000,000   |  |
|  | Claims Director   | Unlimited  | $5,000,000 | $5,000,000   |  |
|  | Claims VP/CTO     | Unlimited  | Unlimited  | Board report |  |
|  +------------------------------------------------------------+  |
|                                                                  |
+------------------------------------------------------------------+
```

### 3.4 Payment Processing Engine

```
PAYMENT PROCESSING ARCHITECTURE:
+------------------------------------------------------------------+
|                                                                  |
|  PAYMENT TYPES:                                                  |
|  ├── Indemnity (loss payment to claimant/insured)                |
|  ├── Medical (payment to medical provider in WC)                 |
|  ├── Expense (ALAE - attorney fees, expert fees, etc.)           |
|  ├── Supplemental payment (additional payment on same claim)     |
|  └── Recovery (salvage/subrogation - negative payment)           |
|                                                                  |
|  PAYMENT METHODS:                                                |
|  ├── Check (physical or virtual)                                 |
|  ├── ACH/EFT (electronic funds transfer)                         |
|  ├── Wire transfer (large payments)                              |
|  ├── Virtual card                                                |
|  ├── Push-to-debit (instant payments)                            |
|  └── Draft authority (for vendors)                               |
|                                                                  |
|  PAYMENT WORKFLOW:                                               |
|  ├── 1. Adjuster initiates payment request                      |
|  ├── 2. System validates:                                        |
|  │   ├── Authority level check                                   |
|  │   ├── Reserve adequacy check                                  |
|  │   ├── Duplicate payment check                                 |
|  │   ├── Payee validation (OFAC, sanctions, tax ID)              |
|  │   └── Policy limit check                                     |
|  ├── 3. Approval routing (if above authority)                    |
|  ├── 4. Payment execution                                        |
|  │   ├── Generate check or initiate EFT                          |
|  │   ├── Update paid amounts                                     |
|  │   ├── Reduce outstanding reserves                             |
|  │   └── Post to GL                                              |
|  ├── 5. Tax reporting (1099 tracking)                            |
|  └── 6. Reinsurance ceded payment calculation                    |
|                                                                  |
+------------------------------------------------------------------+
```

### 3.5 Assignment and Workflow Engine

```
ASSIGNMENT ENGINE:
+------------------------------------------------------------------+
|                                                                  |
|  ASSIGNMENT FACTORS:                                             |
|  ├── Line of business                                            |
|  ├── Claim type and complexity                                   |
|  ├── Geographic location                                         |
|  ├── Adjuster skill and certification                            |
|  ├── Current workload/caseload                                   |
|  ├── Authority level required                                    |
|  ├── Language requirements                                       |
|  └── Specialty (litigation, fraud, catastrophe)                  |
|                                                                  |
|  ASSIGNMENT ALGORITHMS:                                          |
|  ├── Round-robin: distribute evenly across team                  |
|  ├── Skill-based: match claim requirements to adjuster skills    |
|  ├── Workload-balanced: consider current caseload                |
|  ├── Geographic: assign based on proximity                       |
|  ├── Segmentation: route by complexity/severity tier             |
|  └── AI-assisted: ML model recommends best adjuster              |
|                                                                  |
+------------------------------------------------------------------+
```

---

## 4. Microservices Decomposition

### 4.1 Domain-Driven Design for Claims

```
DDD BOUNDED CONTEXTS FOR CLAIMS:
+====================================================================+
|                                                                    |
|  ┌────────────────────┐   ┌────────────────────┐                   |
|  │    FNOL CONTEXT     │   │   CLAIM CONTEXT     │                   |
|  │                    │   │                    │                   |
|  │  Entities:         │   │  Entities:         │                   |
|  │  - Submission      │──>│  - Claim           │                   |
|  │  - Claimant        │   │  - Claimant        │                   |
|  │  - LossReport      │   │  - Coverage        │                   |
|  │  - Attachment      │   │  - Exposure         │                   |
|  │                    │   │  - Activity         │                   |
|  │  Value Objects:    │   │                    │                   |
|  │  - ContactInfo     │   │  Value Objects:    │                   |
|  │  - LossDescription │   │  - ClaimStatus     │                   |
|  │  - InjuryDetail    │   │  - Jurisdiction    │                   |
|  └────────────────────┘   └────────────────────┘                   |
|                                                                    |
|  ┌────────────────────┐   ┌────────────────────┐                   |
|  │  COVERAGE CONTEXT   │   │  RESERVE CONTEXT    │                   |
|  │                    │   │                    │                   |
|  │  Entities:         │   │  Entities:         │                   |
|  │  - Policy          │   │  - ReserveLine     │                   |
|  │  - CoverageItem    │   │  - ReserveChange   │                   |
|  │  - Endorsement     │   │  - ReserveApproval │                   |
|  │  - Exclusion       │   │                    │                   |
|  │                    │   │  Value Objects:    │                   |
|  │  Value Objects:    │   │  - ReserveAmount   │                   |
|  │  - Limit           │   │  - ReserveType     │                   |
|  │  - Deductible      │   │  - AuthorityLevel  │                   |
|  │  - CoverageTerm    │   │                    │                   |
|  └────────────────────┘   └────────────────────┘                   |
|                                                                    |
|  ┌────────────────────┐   ┌────────────────────┐                   |
|  │  PAYMENT CONTEXT    │   │ ASSIGNMENT CONTEXT  │                   |
|  │                    │   │                    │                   |
|  │  Entities:         │   │  Entities:         │                   |
|  │  - Payment         │   │  - Assignment      │                   |
|  │  - PaymentBatch    │   │  - Adjuster        │                   |
|  │  - Payee           │   │  - Team            │                   |
|  │  - TaxReporting    │   │  - Workload        │                   |
|  │                    │   │                    │                   |
|  │  Value Objects:    │   │  Value Objects:    │                   |
|  │  - Money           │   │  - Skill           │                   |
|  │  - PaymentMethod   │   │  - Capacity        │                   |
|  │  - CheckInfo       │   │  - AssignmentRule  │                   |
|  └────────────────────┘   └────────────────────┘                   |
|                                                                    |
+====================================================================+
```

### 4.2 Service Catalog (20+ Microservices)

```
CLAIMS MICROSERVICES CATALOG:
+====================================================================+
|                                                                    |
|  SERVICE               | RESPONSIBILITIES                          |
|  ═════════════════════════════════════════════════════════════════  |
|                                                                    |
|  1. fnol-service       | - FNOL intake from all channels           |
|                        | - Claim creation and initial validation    |
|                        | - Duplicate detection                      |
|                        | - Initial triage and categorization        |
|                        | DB: PostgreSQL | Events: FNOLReceived      |
|                                                                    |
|  2. claim-service      | - Claim lifecycle management               |
|                        | - Status transitions                       |
|                        | - Exposure management                      |
|                        | - Claim reopening logic                    |
|                        | DB: PostgreSQL | Events: ClaimCreated,     |
|                        |   ClaimStatusChanged, ClaimClosed          |
|                                                                    |
|  3. coverage-service   | - Policy lookup and verification           |
|                        | - Coverage determination                   |
|                        | - Limit and deductible application         |
|                        | - Exclusion evaluation                     |
|                        | DB: PostgreSQL (read replica from PAS)     |
|                        | Events: CoverageDetermined                 |
|                                                                    |
|  4. reserve-service    | - Case reserve management                  |
|                        | - Reserve change processing                |
|                        | - Authority validation                     |
|                        | - Approval workflow                        |
|                        | - Auto-reserve calculation                 |
|                        | DB: PostgreSQL | Events: ReserveSet,       |
|                        |   ReserveChanged, ReserveApproved          |
|                                                                    |
|  5. payment-service    | - Payment creation and validation          |
|                        | - Check/EFT processing                     |
|                        | - Payment approval workflow                |
|                        | - Void/stop/reissue                        |
|                        | - 1099 tax reporting                       |
|                        | DB: PostgreSQL | Events: PaymentIssued,    |
|                        |   PaymentVoided, PaymentCleared            |
|                                                                    |
|  6. assignment-service | - Adjuster assignment                      |
|                        | - Workload balancing                       |
|                        | - Skill-based routing                      |
|                        | - Reassignment management                  |
|                        | DB: PostgreSQL | Events: ClaimAssigned,    |
|                        |   ClaimReassigned                          |
|                                                                    |
|  7. document-service   | - Document upload/storage                  |
|                        | - OCR and classification                   |
|                        | - Metadata extraction                      |
|                        | - Version management                       |
|                        | DB: MongoDB + S3 | Events: DocumentUploaded|
|                                                                    |
|  8. communication-svc  | - Correspondence generation                |
|                        | - Template management                      |
|                        | - Email/SMS/push notifications             |
|                        | - Letter printing integration              |
|                        | DB: PostgreSQL | Events: CorrespondenceSent|
|                                                                    |
|  9. fraud-service      | - Fraud scoring at FNOL                    |
|                        | - Red flag detection                       |
|                        | - SIU referral management                  |
|                        | - Predictive fraud models                  |
|                        | DB: PostgreSQL + Neo4j                     |
|                        | Events: FraudAlertRaised, SIUReferral      |
|                                                                    |
|  10. subrogation-svc   | - Subrogation identification               |
|                        | - Recovery tracking                        |
|                        | - Third-party demand management            |
|                        | - Arbitration tracking                     |
|                        | DB: PostgreSQL | Events: SubroIdentified,  |
|                        |   RecoveryReceived                         |
|                                                                    |
|  11. vendor-service    | - Vendor integration hub                   |
|                        | - Assignment to repair shops, etc.         |
|                        | - Vendor performance tracking              |
|                        | - Invoice management                       |
|                        | DB: PostgreSQL | Events: VendorAssigned    |
|                                                                    |
|  12. analytics-service | - Real-time metrics aggregation            |
|                        | - KPI calculation                          |
|                        | - Reporting data preparation               |
|                        | - Predictive analytics serving             |
|                        | DB: ClickHouse/Snowflake                   |
|                        | Consumes all domain events                 |
|                                                                    |
|  13. search-service    | - Full-text claim search                   |
|                        | - Advanced filtering                       |
|                        | - Type-ahead suggestions                   |
|                        | - Similar claims identification            |
|                        | DB: Elasticsearch | Indexes from events    |
|                                                                    |
|  14. audit-service     | - Immutable event logging                  |
|                        | - Compliance audit trail                   |
|                        | - Data access logging                      |
|                        | - Regulatory event tracking                |
|                        | DB: PostgreSQL (append-only)               |
|                        | Consumes all domain events                 |
|                                                                    |
|  15. diary-service     | - Diary/task management                    |
|                        | - Follow-up scheduling                     |
|                        | - Escalation management                    |
|                        | - SLA monitoring                           |
|                        | DB: PostgreSQL | Events: DiaryCreated      |
|                                                                    |
|  16. litigation-svc    | - Litigation tracking                      |
|                        | - Attorney management                      |
|                        | - Court date tracking                      |
|                        | - Legal expense management                 |
|                        | DB: PostgreSQL                             |
|                                                                    |
|  17. reinsurance-svc   | - Ceded reserve calculation                |
|                        | - Treaty matching                          |
|                        | - Notification management                  |
|                        | - Bordereaux generation                    |
|                        | DB: PostgreSQL | Events: CededReserveSet   |
|                                                                    |
|  18. catastrophe-svc   | - CAT event management                    |
|                        | - Claims-to-event association              |
|                        | - Aggregate monitoring                     |
|                        | - CAT response coordination                |
|                        | DB: PostgreSQL + PostGIS                   |
|                                                                    |
|  19. notification-svc  | - Push notification management             |
|                        | - Email delivery                           |
|                        | - SMS delivery                             |
|                        | - Notification preferences                 |
|                        | DB: PostgreSQL + Redis                     |
|                                                                    |
|  20. config-service    | - Business configuration management        |
|                        | - LOB-specific rules configuration         |
|                        | - Feature flags                            |
|                        | - State-specific parameter management      |
|                        | DB: PostgreSQL + Redis cache               |
|                                                                    |
|  21. reporting-service | - Regulatory report generation             |
|                        | - EDI/FROI/SROI generation                 |
|                        | - Financial reporting                      |
|                        | - Ad-hoc report execution                  |
|                        | DB: Read replicas + Snowflake              |
|                                                                    |
|  22. party-service     | - Claimant/insured management              |
|                        | - Contact information                      |
|                        | - Party role management                    |
|                        | - Duplicate detection and merge            |
|                        | DB: PostgreSQL + Elasticsearch             |
|                                                                    |
+====================================================================+
```

### 4.3 Inter-Service Communication

```
SERVICE COMMUNICATION PATTERNS:
+------------------------------------------------------------------+
|                                                                  |
|  SYNCHRONOUS (Request/Response):                                 |
|  ├── REST APIs: for CRUD operations and queries                  |
|  │   ├── claim-service → coverage-service (verify coverage)      |
|  │   ├── payment-service → reserve-service (check adequacy)      |
|  │   ├── fnol-service → fraud-service (score submission)         |
|  │   └── Any service → party-service (resolve party info)        |
|  └── gRPC: for internal high-performance calls                   |
|      ├── search-service ← claim-service (index updates)          |
|      └── analytics-service ← any service (metric increments)     |
|                                                                  |
|  ASYNCHRONOUS (Event-Driven):                                    |
|  ├── Domain Events via Kafka:                                    |
|  │   ├── FNOLReceived → assignment-service (assign adjuster)     |
|  │   ├── FNOLReceived → fraud-service (score claim)              |
|  │   ├── ClaimCreated → search-service (index)                   |
|  │   ├── ClaimCreated → audit-service (log)                      |
|  │   ├── ReserveChanged → reinsurance-svc (calc ceded)           |
|  │   ├── ReserveChanged → analytics-service (update metrics)     |
|  │   ├── PaymentIssued → reinsurance-svc (calc ceded payment)    |
|  │   ├── PaymentIssued → analytics-service (update metrics)      |
|  │   ├── ClaimClosed → analytics-service (closure metrics)       |
|  │   └── Any event → audit-service (immutable log)               |
|  └── Commands via message queue:                                 |
|      ├── GenerateCorrespondence → communication-svc              |
|      ├── SendNotification → notification-svc                     |
|      └── GenerateReport → reporting-service                      |
|                                                                  |
+------------------------------------------------------------------+
```

---

## 5. Database Architecture

### 5.1 Polyglot Persistence

```
DATABASE STRATEGY PER SERVICE:
+====================================================================+
|                                                                    |
|  PostgreSQL (Primary Relational):                                  |
|  ├── claim-service: claims, exposures, activities                  |
|  ├── reserve-service: reserves, changes, approvals                 |
|  ├── payment-service: payments, batches, tax reporting             |
|  ├── coverage-service: policy cache, coverage determinations       |
|  ├── assignment-service: adjusters, teams, assignments             |
|  ├── subrogation-service: recoveries, demands, arbitrations        |
|  └── audit-service: immutable audit log (append-only)              |
|                                                                    |
|  MongoDB (Document Store):                                         |
|  ├── document-service: document metadata and classification        |
|  ├── fnol-service: flexible FNOL submission schemas                |
|  └── communication-service: templates and generated documents      |
|                                                                    |
|  Elasticsearch (Search/Analytics):                                 |
|  ├── search-service: full-text claim search index                  |
|  ├── party-service: fuzzy name/address matching                    |
|  └── analytics-service: time-series claim metrics                  |
|                                                                    |
|  Redis (Cache/Session):                                            |
|  ├── API gateway: rate limiting, session management                |
|  ├── config-service: configuration cache                           |
|  ├── coverage-service: policy data cache                           |
|  └── All services: distributed caching layer                       |
|                                                                    |
|  Neo4j (Graph Database):                                           |
|  ├── fraud-service: relationship graph for fraud detection         |
|  │   (claimant → attorney → provider → address networks)           |
|  └── party-service: party relationship management                  |
|                                                                    |
|  S3/Blob Storage:                                                  |
|  ├── document-service: actual file storage                         |
|  ├── communication-service: generated correspondence               |
|  └── reporting-service: generated reports                          |
|                                                                    |
|  ClickHouse/Snowflake (Analytics):                                 |
|  ├── analytics-service: aggregated metrics data warehouse          |
|  └── reporting-service: reporting data mart                        |
|                                                                    |
+====================================================================+
```

### 5.2 CQRS Pattern for Claims

```
CQRS (Command Query Responsibility Segregation):
+------------------------------------------------------------------+
|                                                                  |
|  WRITE SIDE (Command Model):                                     |
|  ┌─────────────────────────────────────────┐                      |
|  │  API → Command Handler → Domain Model    │                      |
|  │         → Repository → PostgreSQL         │                      |
|  │         → Event Publisher → Kafka         │                      |
|  └─────────────────────────────────────────┘                      |
|                                                                  |
|  Commands:                                                       |
|  ├── CreateClaim, UpdateClaim, CloseClaim                        |
|  ├── SetReserve, ChangeReserve, ApproveReserve                   |
|  ├── CreatePayment, ApprovePayment, VoidPayment                  |
|  └── AssignClaim, ReassignClaim                                  |
|                                                                  |
|  READ SIDE (Query Model):                                        |
|  ┌─────────────────────────────────────────┐                      |
|  │  Kafka → Event Projector → Read Store    │                      |
|  │  API → Query Handler → Read Store         │                      |
|  └─────────────────────────────────────────┘                      |
|                                                                  |
|  Read Stores:                                                    |
|  ├── Elasticsearch: claim search, full-text                      |
|  ├── Redis: claim summary cache, dashboard data                  |
|  ├── ClickHouse: analytics views, aggregations                   |
|  └── PostgreSQL read replica: detail queries                     |
|                                                                  |
|  BENEFITS FOR CLAIMS:                                            |
|  ├── Write model optimized for transactional integrity           |
|  ├── Read model optimized for query performance                  |
|  ├── Different scaling for reads vs writes                       |
|  ├── Claims search can be independently optimized                |
|  └── Analytics queries don't impact transaction processing       |
|                                                                  |
+------------------------------------------------------------------+
```

### 5.3 Event Sourcing for Claims State

```
EVENT SOURCING MODEL:
+------------------------------------------------------------------+
|                                                                  |
|  CONCEPT: Store state changes as sequence of events              |
|  Current state = replay of all events from beginning             |
|                                                                  |
|  CLAIM EVENT STREAM EXAMPLE:                                     |
|  +----+----+----------------------------------------------+     |
|  | Seq| Time | Event                                      |     |
|  +----+----+----------------------------------------------+     |
|  | 1  | T1   | ClaimCreated { claimNumber: "CLM-001",     |     |
|  |    |      |   lob: "AUTO", dol: "2025-04-15" }         |     |
|  | 2  | T2   | CoverageVerified { policyNumber: "POL-X",  |     |
|  |    |      |   status: "COVERED", limit: 1000000 }       |     |
|  | 3  | T3   | ClaimAssigned { adjusterId: "ADJ-42",      |     |
|  |    |      |   team: "Auto-Property" }                   |     |
|  | 4  | T4   | ReserveSet { type: "LOSS", amount: 25000 } |     |
|  | 5  | T5   | ReserveSet { type: "ALAE", amount: 5000 }  |     |
|  | 6  | T6   | DocumentUploaded { docId: "DOC-1",         |     |
|  |    |      |   type: "POLICE_REPORT" }                   |     |
|  | 7  | T7   | ReserveChanged { type: "LOSS", old: 25000, |     |
|  |    |      |   new: 45000, reason: "Revised estimate" }  |     |
|  | 8  | T8   | PaymentIssued { amount: 30000,             |     |
|  |    |      |   payee: "CLAIMANT", method: "CHECK" }      |     |
|  | 9  | T9   | PaymentIssued { amount: 15000,             |     |
|  |    |      |   payee: "BODY_SHOP", method: "EFT" }       |     |
|  | 10 | T10  | ReserveChanged { type: "LOSS", old: 45000, |     |
|  |    |      |   new: 0, reason: "Claim fully paid" }      |     |
|  | 11 | T11  | ClaimClosed { reason: "PAID_IN_FULL" }     |     |
|  +----+----+----------------------------------------------+     |
|                                                                  |
|  BENEFITS:                                                       |
|  ├── Complete audit trail built in                               |
|  ├── Temporal queries (state at any point in time)               |
|  ├── Event replay for debugging and analysis                     |
|  ├── New read models by replaying events                         |
|  └── Natural fit for domain events and CQRS                     |
|                                                                  |
|  CHALLENGES:                                                     |
|  ├── Event schema evolution                                      |
|  ├── Snapshot management for long-lived aggregates               |
|  ├── Eventual consistency with read models                       |
|  └── Complexity increase vs traditional CRUD                     |
|                                                                  |
+------------------------------------------------------------------+
```

---

## 6. Event-Driven Architecture

### 6.1 Domain Events

```
CLAIMS DOMAIN EVENTS CATALOG:
+------------------------------------------------------------------+
| Event Name              | Published By    | Key Data              |
+------------------------------------------------------------------+
| FNOLReceived            | fnol-service    | submissionId, channel |
| ClaimCreated            | claim-service   | claimId, claimNumber  |
| ClaimStatusChanged      | claim-service   | claimId, old, new     |
| ClaimClosed             | claim-service   | claimId, reason       |
| ClaimReopened           | claim-service   | claimId, reason       |
| CoverageDetermined      | coverage-svc    | claimId, result       |
| ReserveSet              | reserve-service | claimId, type, amount |
| ReserveChanged          | reserve-service | claimId, old, new     |
| ReserveApproved         | reserve-service | claimId, approver     |
| PaymentRequested        | payment-service | claimId, amount       |
| PaymentApproved         | payment-service | paymentId, approver   |
| PaymentIssued           | payment-service | paymentId, amount     |
| PaymentVoided           | payment-service | paymentId, reason     |
| ClaimAssigned           | assignment-svc  | claimId, adjusterId   |
| ClaimReassigned         | assignment-svc  | claimId, old, new     |
| DocumentUploaded        | document-svc    | claimId, docId, type  |
| CorrespondenceSent      | comms-service   | claimId, type, channel|
| FraudAlertRaised        | fraud-service   | claimId, score, flags |
| SIUReferralCreated      | fraud-service   | claimId, reason       |
| SubrogationIdentified   | subrogation-svc | claimId, thirdParty   |
| RecoveryReceived        | subrogation-svc | claimId, amount       |
| VendorAssigned          | vendor-service  | claimId, vendorId     |
| CATEventDeclared        | catastrophe-svc | eventId, peril        |
| ClaimLinkedToCAT        | catastrophe-svc | claimId, eventId      |
| CededReserveCalculated  | reinsurance-svc | claimId, treatyId     |
| DiaryCreated            | diary-service   | claimId, dueDate      |
| DiaryCompleted          | diary-service   | claimId, diaryId      |
+------------------------------------------------------------------+
```

### 6.2 Event Streaming with Kafka

```
KAFKA TOPIC DESIGN:
+------------------------------------------------------------------+
|                                                                  |
|  TOPIC NAMING CONVENTION:                                        |
|  claims.<context>.<event-type>                                   |
|                                                                  |
|  TOPICS:                                                         |
|  ├── claims.fnol.received                                        |
|  ├── claims.claim.lifecycle                                      |
|  ├── claims.coverage.determined                                  |
|  ├── claims.reserve.changed                                      |
|  ├── claims.payment.issued                                       |
|  ├── claims.assignment.changed                                   |
|  ├── claims.document.uploaded                                    |
|  ├── claims.fraud.alert                                          |
|  ├── claims.subrogation.recovery                                 |
|  ├── claims.catastrophe.event                                    |
|  └── claims.audit.trail                                          |
|                                                                  |
|  PARTITIONING STRATEGY:                                          |
|  ├── Partition key: claimId (ensures ordering per claim)         |
|  ├── Partitions per topic: 12-24 (based on throughput needs)     |
|  ├── Replication factor: 3 (for high availability)               |
|  └── Retention: 7 days for operational, infinite for audit       |
|                                                                  |
|  CONSUMER GROUPS:                                                |
|  ├── analytics-consumer: reads all events for metrics            |
|  ├── search-consumer: reads lifecycle events for indexing        |
|  ├── audit-consumer: reads all events for audit trail            |
|  ├── reinsurance-consumer: reads reserve/payment events          |
|  ├── notification-consumer: reads events for alerting            |
|  └── reporting-consumer: reads events for data warehouse         |
|                                                                  |
+------------------------------------------------------------------+
```

### 6.3 Saga Pattern for Distributed Transactions

```
SAGA: PAYMENT PROCESSING
+------------------------------------------------------------------+
|                                                                  |
|  STEP 1: Create Payment Request                                  |
|    payment-service → PaymentRequested event                      |
|       ↓                                                          |
|  STEP 2: Validate Reserve Adequacy                               |
|    reserve-service checks sufficient reserves                    |
|    ├── Success → ReserveValidated event                          |
|    └── Failure → PaymentRejected event (COMPENSATE: cancel req)  |
|       ↓                                                          |
|  STEP 3: Approve Payment (if above authority)                    |
|    assignment-service checks authority                            |
|    ├── Success → PaymentApproved event                           |
|    └── Failure → PaymentPendingApproval (await human action)     |
|       ↓                                                          |
|  STEP 4: Execute Payment                                         |
|    payment-service issues check/EFT                              |
|    ├── Success → PaymentIssued event                             |
|    └── Failure → PaymentFailed (COMPENSATE: reverse validation)  |
|       ↓                                                          |
|  STEP 5: Update Reserves                                         |
|    reserve-service reduces outstanding by paid amount            |
|    → ReserveUpdated event                                        |
|       ↓                                                          |
|  STEP 6: Calculate Ceded Payment                                 |
|    reinsurance-service calculates reinsurer share                |
|    → CededPaymentCalculated event                                |
|       ↓                                                          |
|  STEP 7: Post to GL                                              |
|    accounting integration posts journal entries                   |
|    → GLEntryPosted event                                         |
|                                                                  |
|  COMPENSATION (ROLLBACK) FLOW:                                   |
|  If any step fails:                                              |
|  ├── PaymentFailed → Reverse reserve hold                        |
|  ├── PaymentFailed → Notify adjuster of failure                  |
|  └── PaymentFailed → Log failure for investigation               |
|                                                                  |
+------------------------------------------------------------------+
```

---

## 7. Business Rules Engine Integration

### 7.1 Rule Categories

```
CLAIMS BUSINESS RULES TAXONOMY:
+------------------------------------------------------------------+
|                                                                  |
|  UNDERWRITING/COVERAGE RULES:                                    |
|  ├── Coverage determination rules                                |
|  ├── Exclusion evaluation rules                                  |
|  ├── Limit application rules                                     |
|  └── Deductible application rules                                |
|                                                                  |
|  CLAIM HANDLING RULES:                                           |
|  ├── Assignment rules (routing by LOB, complexity, geography)    |
|  ├── Authority rules (reserve/payment limits by role)            |
|  ├── Diary rules (follow-up schedules by claim type)             |
|  ├── Escalation rules (trigger conditions for escalation)        |
|  └── Closure rules (conditions for auto-closing claims)          |
|                                                                  |
|  RESERVE RULES:                                                  |
|  ├── Initial reserve rules (based on claim characteristics)      |
|  ├── Reserve adequacy rules (flags under/over-reserved claims)   |
|  ├── Authority matrix rules                                     |
|  └── Bulk reserve rules                                          |
|                                                                  |
|  PAYMENT RULES:                                                  |
|  ├── Payment validation rules                                    |
|  ├── Duplicate payment detection rules                           |
|  ├── Authority matrix rules                                     |
|  ├── OFAC/sanctions screening rules                              |
|  └── Tax reporting rules (1099 thresholds)                       |
|                                                                  |
|  FRAUD RULES:                                                    |
|  ├── Red flag indicator rules                                    |
|  ├── Scoring model rules                                         |
|  ├── SIU referral threshold rules                                |
|  └── Suspicious pattern detection rules                          |
|                                                                  |
|  REGULATORY RULES:                                               |
|  ├── State-specific filing deadline rules                        |
|  ├── State-specific benefit calculation rules (WC)               |
|  ├── Notice requirement rules                                    |
|  └── Compliance check rules                                     |
|                                                                  |
+------------------------------------------------------------------+
```

### 7.2 Rules Engine Architecture

```
RULES ENGINE INTEGRATION PATTERN:
+------------------------------------------------------------------+
|                                                                  |
|  SERVICE ──→ RULES ENGINE ──→ DECISION                           |
|                                                                  |
|  ARCHITECTURE OPTIONS:                                           |
|                                                                  |
|  OPTION A: Embedded Rules Engine                                 |
|  ┌────────────────────────────────────────┐                      |
|  │  Microservice                          │                      |
|  │  ┌──────────────────────────────────┐  │                      |
|  │  │  Drools Engine (embedded JAR)    │  │                      |
|  │  │  ├── DRL rules files             │  │                      |
|  │  │  ├── Decision tables (Excel/CSV) │  │                      |
|  │  │  └── Rule execution session      │  │                      |
|  │  └──────────────────────────────────┘  │                      |
|  └────────────────────────────────────────┘                      |
|  PRO: Low latency, no network hop                                |
|  CON: Rules coupled to service deployment                        |
|                                                                  |
|  OPTION B: Decision Service (Standalone)                         |
|  ┌──────────────┐   REST/gRPC   ┌──────────────────┐            |
|  │ Microservice │ ────────────> │ Decision Service  │            |
|  │              │ <──────────── │ (Drools/Corticon) │            |
|  └──────────────┘               │ ├── Rule Repo     │            |
|                                 │ ├── Version Mgmt  │            |
|                                 │ └── Audit Trail   │            |
|                                 └──────────────────┘            |
|  PRO: Centralized rule management, independent deployment        |
|  CON: Additional network latency                                 |
|                                                                  |
|  OPTION C: DMN (Decision Model and Notation)                     |
|  ├── Standard notation for decision modeling                     |
|  ├── Visual decision tables and decision requirements diagrams   |
|  ├── Executable by DMN-compliant engines (Camunda, Red Hat)      |
|  └── Business analysts can author decisions                      |
|                                                                  |
+------------------------------------------------------------------+
```

---

## 8. Workflow Engine Integration

### 8.1 BPM Engine Selection

```
WORKFLOW ENGINE COMPARISON:
+------------------------------------------------------------------+
| Feature              | Camunda 8  | Flowable   | Activiti       |
+------------------------------------------------------------------+
| BPMN 2.0 Support     | Full       | Full       | Full           |
| DMN Support           | Full       | Full       | Limited        |
| Cloud-Native          | Yes (Zeebe)| Partial    | No             |
| Scalability           | Excellent  | Good       | Good           |
| Microservice Support  | Native     | Plugin     | Plugin         |
| REST API              | Full       | Full       | Full           |
| Java Integration      | Native     | Native     | Native         |
| Community             | Large      | Moderate   | Large (legacy) |
| Commercial Support    | Yes        | Yes        | Limited        |
| Recommendation        | Preferred  | Good alt.  | Legacy         |
+------------------------------------------------------------------+
```

### 8.2 Claims BPMN Processes

```
FNOL-TO-CLOSE PROCESS (BPMN Simplified):
+------------------------------------------------------------------+
|                                                                  |
|  (START) → [Receive FNOL]                                        |
|              │                                                   |
|              ▼                                                   |
|         [Validate & Create Claim]                                |
|              │                                                   |
|         ┌────┴────┐                                              |
|         ▼         ▼                                              |
|  [Auto-Assign]  [Fraud Score]                                    |
|         │         │                                              |
|         └────┬────┘                                              |
|              ▼                                                   |
|    <Fraud Score High?> ──Yes──→ [SIU Review] → <Accept?>         |
|         │ No                                    │ No → [Deny]    |
|         ▼                                       │ Yes            |
|  [Adjuster Investigation]  <─────────────────────┘               |
|         │                                                        |
|         ▼                                                        |
|  <Compensable?> ──No──→ [Issue Denial] → (END-DENIED)           |
|         │ Yes                                                    |
|         ▼                                                        |
|  [Set Reserves]                                                  |
|         │                                                        |
|         ▼                                                        |
|  [Handle Claim] ←─── (loop for claim handling activities)        |
|     ├── [Process Payments]                                       |
|     ├── [Manage Medical] (WC)                                    |
|     ├── [Negotiate Settlement]                                   |
|     └── [Manage Litigation]                                      |
|         │                                                        |
|         ▼                                                        |
|  <Ready to Close?> ──No──→ [Continue Handling]                   |
|         │ Yes                                                    |
|         ▼                                                        |
|  [Close Claim] → (END-CLOSED)                                   |
|                                                                  |
+------------------------------------------------------------------+
```

---

## 9. Security Architecture

### 9.1 Authentication and Authorization

```
SECURITY ARCHITECTURE:
+====================================================================+
|                                                                    |
|  AUTHENTICATION:                                                   |
|  ┌──────────────────────────────────────────────────────────────┐  |
|  │  Identity Provider (Keycloak / Okta / Azure AD)              │  |
|  │  ├── OAuth 2.0 Authorization Code (web apps)                 │  |
|  │  ├── OAuth 2.0 Client Credentials (service-to-service)       │  |
|  │  ├── OIDC (OpenID Connect) for SSO                           │  |
|  │  ├── SAML 2.0 for enterprise federation                      │  |
|  │  ├── MFA (multi-factor authentication)                       │  |
|  │  └── JWT tokens with claims-based identity                   │  |
|  └──────────────────────────────────────────────────────────────┘  |
|                                                                    |
|  AUTHORIZATION:                                                    |
|  ┌──────────────────────────────────────────────────────────────┐  |
|  │  RBAC (Role-Based Access Control):                           │  |
|  │  ├── Claims_Adjuster: view/edit assigned claims              │  |
|  │  ├── Claims_Supervisor: view/edit team claims, approve       │  |
|  │  ├── Claims_Manager: all claims in unit, higher authority    │  |
|  │  ├── Claims_Director: all claims, max authority              │  |
|  │  ├── SIU_Investigator: fraud investigation access            │  |
|  │  ├── Medical_Reviewer: medical management access             │  |
|  │  ├── Finance_Analyst: financial reporting access             │  |
|  │  └── System_Admin: configuration and admin access            │  |
|  │                                                              │  |
|  │  ABAC (Attribute-Based Access Control):                      │  |
|  │  ├── LOB restriction (user can only see their LOB)           │  |
|  │  ├── State/jurisdiction restriction                          │  |
|  │  ├── Claim amount threshold                                  │  |
|  │  ├── Claim status-based access                               │  |
|  │  └── PII/PHI access restrictions                             │  |
|  └──────────────────────────────────────────────────────────────┘  |
|                                                                    |
|  JWT TOKEN DESIGN:                                                 |
|  {                                                                 |
|    "sub": "user-123",                                              |
|    "name": "Jane Adjuster",                                       |
|    "roles": ["claims_adjuster"],                                   |
|    "lob": ["AUTO", "PROPERTY"],                                    |
|    "states": ["CA", "NV", "AZ"],                                   |
|    "authority_level": 2,                                           |
|    "reserve_limit": 150000,                                       |
|    "payment_limit": 50000,                                        |
|    "team_id": "team-auto-west",                                    |
|    "org_unit": "claims-auto",                                      |
|    "pii_access": true,                                             |
|    "phi_access": false                                             |
|  }                                                                 |
|                                                                    |
+====================================================================+
```

### 9.2 Data Protection

```
DATA PROTECTION STRATEGY:
+------------------------------------------------------------------+
|                                                                  |
|  ENCRYPTION:                                                     |
|  ├── At Rest:                                                    |
|  │   ├── Database: TDE (Transparent Data Encryption)             |
|  │   ├── Files/Docs: AES-256 encryption in S3                   |
|  │   ├── Backups: encrypted with KMS-managed keys               |
|  │   └── Key management: AWS KMS / Azure Key Vault / HashiCorp  |
|  └── In Transit:                                                 |
|      ├── TLS 1.3 for all external communications                |
|      ├── mTLS for inter-service communication                    |
|      └── Encrypted message payload for sensitive data            |
|                                                                  |
|  PII/PHI PROTECTION:                                             |
|  ├── Data classification: PUBLIC, INTERNAL, CONFIDENTIAL, PII   |
|  ├── Field-level encryption for SSN, DOB, medical data          |
|  ├── Data masking in non-production environments                |
|  ├── Tokenization for SSN in logging/analytics                  |
|  ├── Access logging for all PII/PHI access                      |
|  └── Right to deletion support (CCPA/GDPR)                      |
|                                                                  |
|  AUDIT LOGGING:                                                  |
|  ├── All data access logged (who, what, when, from where)       |
|  ├── All data modifications logged with before/after            |
|  ├── All authentication events logged                           |
|  ├── All authorization failures logged                          |
|  ├── Immutable audit trail (append-only)                        |
|  └── Retention: 7 years minimum (regulatory requirement)        |
|                                                                  |
+------------------------------------------------------------------+
```

---

## 10. Scalability and Performance

### 10.1 Scaling Patterns

```
SCALABILITY ARCHITECTURE:
+------------------------------------------------------------------+
|                                                                  |
|  HORIZONTAL SCALING:                                             |
|  ├── Each microservice independently scalable                    |
|  ├── Kubernetes HPA (Horizontal Pod Autoscaler)                  |
|  │   ├── CPU-based: scale when CPU > 70%                        |
|  │   ├── Memory-based: scale when memory > 80%                  |
|  │   └── Custom metrics: scale on request queue depth            |
|  ├── Stateless services: easy horizontal scaling                 |
|  └── Stateful services: careful partition strategy               |
|                                                                  |
|  CACHING STRATEGY:                                               |
|  ├── L1 Cache: in-process (Caffeine/Guava) - 1-5 min TTL       |
|  ├── L2 Cache: distributed (Redis) - 5-60 min TTL              |
|  ├── CDN: static assets and API responses - edge caching         |
|  ├── What to cache:                                              |
|  │   ├── Policy data (from PAS) - 15 min TTL                   |
|  │   ├── Configuration data - 5 min TTL                         |
|  │   ├── User session data - session duration                    |
|  │   ├── Adjuster assignment rules - 30 min TTL                 |
|  │   └── Code table lookups - 1 hour TTL                        |
|  └── Cache invalidation: event-driven (Kafka consumer)           |
|                                                                  |
|  PERFORMANCE BENCHMARKS:                                         |
|  +------------------------------------------------------------+  |
|  | Operation                    | Target SLA  | P99 Target    |  |
|  +------------------------------------------------------------+  |
|  | FNOL submission              | < 3 sec     | < 5 sec       |  |
|  | Claim search                 | < 500 ms    | < 1 sec       |  |
|  | Claim detail retrieval       | < 200 ms    | < 500 ms      |  |
|  | Reserve change               | < 1 sec     | < 2 sec       |  |
|  | Payment creation             | < 2 sec     | < 3 sec       |  |
|  | Document upload              | < 5 sec     | < 10 sec      |  |
|  | Dashboard load               | < 2 sec     | < 4 sec       |  |
|  | Report generation            | < 30 sec    | < 60 sec      |  |
|  +------------------------------------------------------------+  |
|                                                                  |
|  CAT SURGE SCALING:                                              |
|  ├── Normal load: 500 FNOL/day, 2000 reserve changes/day       |
|  ├── CAT surge: 50,000 FNOL/day, 200,000 changes/day           |
|  ├── Auto-scaling must handle 100x surge within 15 minutes       |
|  ├── Pre-provisioned warm capacity for known hurricane season    |
|  ├── Database read replicas auto-provisioned                     |
|  └── Queue depth monitoring with circuit breakers                |
|                                                                  |
+------------------------------------------------------------------+
```

---

## 11. Cloud Architecture

### 11.1 AWS Reference Architecture

```
AWS CLAIMS PLATFORM:
+====================================================================+
|                                                                    |
|  ┌─────────────── Internet ──────────────────────────────────────┐ |
|  │  CloudFront (CDN) → ALB → EKS (Kubernetes)                   │ |
|  └───────────────────────────────────────────────────────────────┘ |
|                                                                    |
|  COMPUTE:                                                          |
|  ├── Amazon EKS: container orchestration for microservices         |
|  ├── AWS Fargate: serverless container execution                   |
|  ├── AWS Lambda: event-driven functions (document processing,      |
|  │   notification dispatch, async transformations)                 |
|  └── EC2: legacy integration, batch processing                    |
|                                                                    |
|  DATA:                                                             |
|  ├── Amazon RDS (PostgreSQL): primary relational databases         |
|  │   ├── Multi-AZ for HA                                          |
|  │   ├── Read replicas for reporting                              |
|  │   └── RDS Proxy for connection pooling                         |
|  ├── Amazon DocumentDB: document storage (MongoDB compatible)      |
|  ├── Amazon ElastiCache (Redis): caching and session               |
|  ├── Amazon OpenSearch: full-text search                          |
|  ├── Amazon Neptune: graph database for fraud detection            |
|  ├── Amazon S3: document/image storage                            |
|  └── Amazon Redshift / Snowflake: data warehouse                  |
|                                                                    |
|  MESSAGING:                                                        |
|  ├── Amazon MSK (Managed Kafka): event streaming backbone          |
|  ├── Amazon SQS: task queues (payment processing, doc OCR)        |
|  ├── Amazon SNS: fan-out notifications                            |
|  └── Amazon EventBridge: event routing and filtering               |
|                                                                    |
|  SECURITY:                                                         |
|  ├── AWS IAM: service-level permissions                           |
|  ├── AWS KMS: encryption key management                           |
|  ├── AWS WAF: web application firewall                            |
|  ├── AWS Secrets Manager: credential management                   |
|  ├── AWS Certificate Manager: TLS certificates                    |
|  └── Amazon Cognito or Keycloak on EKS: user authentication      |
|                                                                    |
|  OBSERVABILITY:                                                    |
|  ├── Amazon CloudWatch: logs, metrics, alarms                     |
|  ├── AWS X-Ray: distributed tracing                               |
|  ├── Amazon Managed Grafana: dashboards                           |
|  └── Amazon Managed Prometheus: metrics collection                |
|                                                                    |
|  NETWORKING:                                                       |
|  ├── Amazon VPC: isolated network                                 |
|  ├── AWS Transit Gateway: multi-VPC connectivity                  |
|  ├── AWS PrivateLink: private API access                          |
|  └── AWS Direct Connect: hybrid connectivity to on-prem           |
|                                                                    |
+====================================================================+
```

### 11.2 Azure Reference Architecture

```
AZURE CLAIMS PLATFORM:
+------------------------------------------------------------------+
|                                                                  |
|  COMPUTE:                                                        |
|  ├── Azure Kubernetes Service (AKS)                              |
|  ├── Azure Container Instances (ACI)                             |
|  ├── Azure Functions                                             |
|  └── Azure App Service (legacy integration)                      |
|                                                                  |
|  DATA:                                                           |
|  ├── Azure Database for PostgreSQL                               |
|  ├── Azure Cosmos DB (MongoDB API)                               |
|  ├── Azure Cache for Redis                                       |
|  ├── Azure Cognitive Search                                      |
|  ├── Azure Blob Storage                                          |
|  └── Azure Synapse Analytics                                     |
|                                                                  |
|  MESSAGING:                                                      |
|  ├── Azure Event Hubs (Kafka compatible)                         |
|  ├── Azure Service Bus                                           |
|  └── Azure Event Grid                                            |
|                                                                  |
|  SECURITY:                                                       |
|  ├── Azure AD: identity and access management                    |
|  ├── Azure Key Vault                                             |
|  └── Azure Front Door + WAF                                      |
|                                                                  |
+------------------------------------------------------------------+
```

---

## 12. DevOps and CI/CD

### 12.1 Pipeline Design

```
CI/CD PIPELINE FOR CLAIMS MICROSERVICES:
+====================================================================+
|                                                                    |
|  COMMIT → BUILD → TEST → SECURITY → ARTIFACT → DEPLOY → VERIFY   |
|                                                                    |
|  1. CODE COMMIT                                                    |
|     ├── Feature branch → PR → Code review → Merge to main         |
|     ├── Trunk-based development preferred                          |
|     └── Git hooks: lint, format, commit message validation         |
|                                                                    |
|  2. BUILD                                                          |
|     ├── Compile/build application                                  |
|     ├── Build Docker container image                               |
|     ├── Tag with: git SHA, semantic version                        |
|     └── Push to container registry (ECR/ACR)                       |
|                                                                    |
|  3. TEST                                                           |
|     ├── Unit tests (> 80% coverage target)                         |
|     ├── Integration tests (Testcontainers)                         |
|     ├── Contract tests (Pact)                                      |
|     ├── API tests (Postman/Newman)                                 |
|     └── Performance tests (k6, Gatling) — on staging              |
|                                                                    |
|  4. SECURITY SCAN                                                  |
|     ├── SAST (SonarQube, Checkmarx)                                |
|     ├── DAST (OWASP ZAP)                                           |
|     ├── Container scan (Trivy, Snyk)                               |
|     ├── Dependency scan (Dependabot, Snyk)                         |
|     └── Secret detection (GitLeaks, TruffleHog)                    |
|                                                                    |
|  5. ARTIFACT                                                       |
|     ├── Container image → ECR/ACR                                  |
|     ├── Helm chart → Chart repository                              |
|     └── API spec → API catalog                                     |
|                                                                    |
|  6. DEPLOY                                                         |
|     ├── DEV: automatic on merge to main                            |
|     ├── STAGING: automatic after DEV passes                        |
|     ├── PRODUCTION: manual approval gate                           |
|     ├── Strategy: blue-green or canary                             |
|     └── Rollback: automatic on health check failure                |
|                                                                    |
|  7. VERIFY                                                         |
|     ├── Smoke tests in target environment                          |
|     ├── Synthetic monitoring                                       |
|     ├── Canary analysis (progressive rollout)                      |
|     └── Production readiness checklist verification                |
|                                                                    |
+====================================================================+
```

### 12.2 Feature Flagging

```
FEATURE FLAGS FOR CLAIMS:
+------------------------------------------------------------------+
|                                                                  |
|  USE CASES:                                                      |
|  ├── New FNOL intake channel (enable for subset of users)        |
|  ├── ML reserve recommendation (gradual rollout by LOB)          |
|  ├── New payment method (enable by state)                        |
|  ├── Regulatory changes (enable on effective date per state)     |
|  └── A/B testing (compare new vs old claim handling workflow)    |
|                                                                  |
|  FLAG TYPES:                                                     |
|  ├── Release flags: enable/disable new features                  |
|  ├── Operational flags: circuit breakers, fallbacks              |
|  ├── Experiment flags: A/B testing                               |
|  └── Permission flags: user-segment-specific features            |
|                                                                  |
|  TOOLS: LaunchDarkly, Unleash, Flagsmith, AWS AppConfig          |
|                                                                  |
+------------------------------------------------------------------+
```

---

## 13. Observability

### 13.1 Logging Strategy

```
LOGGING ARCHITECTURE:
+------------------------------------------------------------------+
|                                                                  |
|  STRUCTURED LOGGING FORMAT (JSON):                               |
|  {                                                               |
|    "timestamp": "2025-04-16T10:30:00Z",                         |
|    "level": "INFO",                                              |
|    "service": "claim-service",                                   |
|    "traceId": "abc123",                                          |
|    "spanId": "def456",                                           |
|    "userId": "adjuster-42",                                      |
|    "claimId": "CLM-2025-001",                                    |
|    "action": "reserve_changed",                                  |
|    "details": {                                                  |
|      "reserveType": "LOSS",                                      |
|      "oldAmount": 25000,                                         |
|      "newAmount": 45000                                          |
|    }                                                             |
|  }                                                               |
|                                                                  |
|  LOG AGGREGATION:                                                |
|  Microservice → Fluentd/Fluent Bit → Elasticsearch/Splunk       |
|  → Kibana/Splunk Dashboard                                      |
|                                                                  |
|  SENSITIVE DATA IN LOGS:                                         |
|  ├── NEVER log SSN, full credit card, passwords                  |
|  ├── Mask PII in logs (last 4 of SSN, masked names)             |
|  ├── Separate audit logs for PII access (encrypted)             |
|  └── Log retention: 90 days operational, 7 years audit           |
|                                                                  |
+------------------------------------------------------------------+
```

### 13.2 Metrics and Monitoring

```
METRICS STRATEGY:
+------------------------------------------------------------------+
|                                                                  |
|  INFRASTRUCTURE METRICS (Prometheus):                            |
|  ├── CPU/memory utilization per pod                              |
|  ├── Network I/O                                                 |
|  ├── Disk I/O                                                    |
|  ├── Container restart counts                                    |
|  └── Node health                                                 |
|                                                                  |
|  APPLICATION METRICS (Custom):                                   |
|  ├── Request rate (per service, per endpoint)                    |
|  ├── Error rate (4xx, 5xx by service)                            |
|  ├── Response time (P50, P95, P99 by endpoint)                  |
|  ├── Claims created per hour                                     |
|  ├── Reserves set/changed per hour                               |
|  ├── Payments processed per hour                                 |
|  ├── Kafka consumer lag (by consumer group)                      |
|  ├── Database connection pool utilization                        |
|  └── Cache hit/miss rates                                        |
|                                                                  |
|  BUSINESS METRICS (Claims-specific):                             |
|  ├── FNOL volume (by channel, LOB, state)                        |
|  ├── Average claim age                                           |
|  ├── Claims closed per day                                       |
|  ├── Average reserve per claim                                   |
|  ├── Payment volume and value                                    |
|  ├── SLA compliance rates                                        |
|  └── Adjuster productivity metrics                               |
|                                                                  |
|  DASHBOARDS (Grafana):                                           |
|  ├── Service health overview (RED metrics per service)           |
|  ├── Claims operations dashboard                                 |
|  ├── Kafka streaming health                                      |
|  ├── Database performance                                        |
|  └── Security and compliance                                     |
|                                                                  |
+------------------------------------------------------------------+
```

### 13.3 Distributed Tracing

```
DISTRIBUTED TRACING:
+------------------------------------------------------------------+
|                                                                  |
|  TRACE EXAMPLE: FNOL Submission                                  |
|                                                                  |
|  [API Gateway] ─┐                                               |
|  │ 50ms         │                                               |
|  └──→ [fnol-service] ─┐                                        |
|       │ 200ms          │                                        |
|       ├──→ [fraud-service] (30ms)                               |
|       ├──→ [coverage-service] (80ms)                            |
|       │    └──→ [Policy API] (60ms)                             |
|       ├──→ [assignment-service] (40ms)                          |
|       ├──→ [reserve-service] (50ms)                             |
|       ├──→ [Kafka: ClaimCreated] (5ms)                          |
|       └──→ [PostgreSQL] (20ms)                                  |
|                                                                  |
|  Total trace: 280ms                                              |
|  Spans: 8                                                        |
|  TraceId: abc-123-def-456                                        |
|                                                                  |
|  TOOLS: Jaeger, Zipkin, AWS X-Ray, Datadog APM                  |
|                                                                  |
+------------------------------------------------------------------+
```

---

## 14. Disaster Recovery and Business Continuity

### 14.1 DR Strategy

```
DR/BCP ARCHITECTURE:
+------------------------------------------------------------------+
|                                                                  |
|  RPO/RTO TARGETS:                                                |
|  +------------------------------------------------------------+  |
|  | Component            | RPO          | RTO                  |  |
|  +------------------------------------------------------------+  |
|  | Claims Processing    | 1 hour       | 4 hours              |  |
|  | Payment Processing   | 0 (no loss)  | 2 hours              |  |
|  | Document Storage     | 24 hours     | 8 hours              |  |
|  | Analytics/Reporting  | 24 hours     | 24 hours             |  |
|  | FNOL Intake          | 0 (no loss)  | 1 hour               |  |
|  +------------------------------------------------------------+  |
|                                                                  |
|  DR TOPOLOGY:                                                    |
|  ┌────────────────────┐    ┌────────────────────┐                |
|  │  PRIMARY REGION     │    │  DR REGION           │                |
|  │  (us-east-1)       │    │  (us-west-2)        │                |
|  │                    │    │                    │                |
|  │  EKS Cluster       │───→│  EKS Cluster       │                |
|  │  RDS Primary       │───→│  RDS Standby       │                |
|  │  Redis Primary     │───→│  Redis Replica     │                |
|  │  Kafka Cluster     │───→│  Kafka Mirror      │                |
|  │  S3 (CRR enabled)  │───→│  S3 Replica        │                |
|  └────────────────────┘    └────────────────────┘                |
|                                                                  |
|  FAILOVER PROCESS:                                               |
|  ├── Automated health checks detect primary failure              |
|  ├── DNS failover (Route 53 health check)                        |
|  ├── RDS promote standby to primary                              |
|  ├── EKS pods in DR region begin serving traffic                 |
|  ├── Kafka consumers in DR region start processing               |
|  └── Manual verification before full cutover                     |
|                                                                  |
+------------------------------------------------------------------+
```

---

## 15. Multi-Tenant Architecture

### 15.1 Multi-Tenancy for MGAs/TPAs

```
MULTI-TENANT ARCHITECTURE:
+------------------------------------------------------------------+
|                                                                  |
|  TENANCY MODELS:                                                 |
|                                                                  |
|  OPTION A: SHARED INFRASTRUCTURE, ISOLATED DATA                  |
|  ├── All tenants share services and databases                    |
|  ├── Tenant isolation via tenant_id column in all tables         |
|  ├── Row-level security (RLS) in PostgreSQL                      |
|  ├── Tenant context propagated via JWT token                     |
|  PRO: Cost-efficient, easy management                            |
|  CON: Noisy neighbor risk, complex data isolation               |
|                                                                  |
|  OPTION B: SHARED SERVICES, ISOLATED DATABASES                   |
|  ├── Services are shared (multi-tenant code)                     |
|  ├── Each tenant gets own database schema or instance            |
|  ├── Connection routing based on tenant context                  |
|  PRO: Better isolation, easier compliance                        |
|  CON: More infrastructure, connection management                 |
|                                                                  |
|  OPTION C: ISOLATED SERVICES (per tenant deployment)             |
|  ├── Each tenant gets dedicated service instances                |
|  ├── Namespace-based isolation in Kubernetes                     |
|  ├── Full data and compute isolation                             |
|  PRO: Maximum isolation, independent scaling                     |
|  CON: High cost, management overhead                             |
|                                                                  |
|  RECOMMENDED: Option B for claims platforms                      |
|  (balance of isolation and cost)                                 |
|                                                                  |
|  TENANT-SPECIFIC CONFIGURATION:                                  |
|  ├── Business rules per tenant                                   |
|  ├── Workflow configuration per tenant                            |
|  ├── Branding and UI customization per tenant                    |
|  ├── Integration endpoints per tenant                            |
|  ├── Authority levels per tenant                                 |
|  └── Reporting templates per tenant                              |
|                                                                  |
+------------------------------------------------------------------+
```

---

## 16. Complete Technology Stack

### 16.1 Recommended Stack

```
CLAIMS PLATFORM TECHNOLOGY STACK:
+====================================================================+
| Layer              | Technology                  | Purpose          |
+====================================================================+
| Frontend           | React 18 + TypeScript       | Web UI           |
|                    | React Native                | Mobile app       |
|                    | Tailwind CSS                | Styling          |
|                    | TanStack Query              | Data fetching    |
+--------------------------------------------------------------------+
| BFF Layer          | Node.js (Express/Fastify)   | Backend for FE   |
|                    | GraphQL (Apollo)            | Flexible queries |
+--------------------------------------------------------------------+
| API Gateway        | Kong / AWS API Gateway      | Traffic mgmt     |
+--------------------------------------------------------------------+
| Microservices      | Java 21 + Spring Boot 3     | Core services    |
|                    | Kotlin                      | Modern JVM       |
|                    | Go                          | High-perf svc    |
|                    | Python                      | ML/analytics     |
+--------------------------------------------------------------------+
| Rules Engine       | Drools / Red Hat DM         | Business rules   |
| Workflow           | Camunda 8 (Zeebe)           | BPM              |
+--------------------------------------------------------------------+
| Event Streaming    | Apache Kafka (MSK)          | Event backbone   |
| Message Queue      | Amazon SQS / RabbitMQ       | Task queues      |
+--------------------------------------------------------------------+
| Primary DB         | PostgreSQL 16               | Transactional    |
| Document DB        | MongoDB 7 / DocumentDB      | Flexible schema  |
| Cache              | Redis 7                     | Caching/session  |
| Search             | Elasticsearch 8 / OpenSearch| Full-text search |
| Graph DB           | Neo4j                       | Fraud detection  |
| Data Warehouse     | Snowflake / Redshift        | Analytics        |
| Object Storage     | Amazon S3                   | Documents/files  |
+--------------------------------------------------------------------+
| Container Orch.    | Kubernetes (EKS/AKS)        | Service mgmt     |
| Service Mesh       | Istio / Linkerd             | Traffic/security |
| CI/CD              | GitHub Actions / GitLab CI  | Pipeline         |
| IaC                | Terraform                   | Infrastructure   |
| Container Registry | ECR / ACR                   | Image storage    |
+--------------------------------------------------------------------+
| Monitoring         | Prometheus + Grafana        | Metrics          |
| Logging            | ELK / Splunk / Datadog      | Log aggregation  |
| Tracing            | Jaeger / Datadog APM        | Dist. tracing    |
| Alerting           | PagerDuty / OpsGenie        | Incident mgmt    |
+--------------------------------------------------------------------+
| Security           | Keycloak / Okta             | Identity         |
|                    | HashiCorp Vault             | Secrets          |
|                    | SonarQube / Snyk            | Code security    |
+--------------------------------------------------------------------+
| Testing            | JUnit 5 / Testcontainers    | Unit/Integration |
|                    | Pact                        | Contract testing |
|                    | k6 / Gatling                | Performance      |
|                    | Cypress / Playwright        | E2E              |
+====================================================================+
```

---

## 17. Architecture Decision Records

### 17.1 ADR Template

```
ADR-001: Use Event Sourcing for Claims Core

STATUS: Accepted
DATE: 2025-01-15

CONTEXT:
Claims processing requires a complete audit trail of all state
changes. Regulatory requirements mandate knowing the exact state
of a claim at any point in time. Traditional CRUD with audit
tables creates dual-write complexity.

DECISION:
Adopt event sourcing for the claim aggregate in claim-service.
All state changes will be persisted as domain events in an event
store (PostgreSQL with event tables). Current state will be
derived by replaying events, with snapshots every 50 events for
performance.

CONSEQUENCES:
+ Complete audit trail inherent in design
+ Temporal queries supported natively
+ Natural fit for event-driven architecture
+ Can rebuild read models without data loss
- Increased complexity for developers
- Event schema evolution needs careful management
- Eventual consistency with read models
- Snapshot management overhead
```

```
ADR-002: Database Per Service (with exceptions)

STATUS: Accepted
DATE: 2025-01-20

CONTEXT:
Microservices best practice suggests database per service for
loose coupling. However, strict isolation creates challenges for
cross-service queries and reporting.

DECISION:
Each core service owns its database schema (logical isolation
within shared PostgreSQL cluster for cost). Exceptions:
- Analytics service reads from all databases via CDC (Debezium)
- Reporting uses a read-optimized data warehouse (Snowflake)
- Search service maintains its own Elasticsearch index

CONSEQUENCES:
+ Service autonomy and independent evolution
+ Clear data ownership
+ Performance isolation per service
- Cross-service queries require event-based synchronization
- Data duplication across read models
- Eventual consistency between services
```

```
ADR-003: Kafka as Event Streaming Backbone

STATUS: Accepted
DATE: 2025-02-01

CONTEXT:
The claims platform requires reliable, ordered, scalable event
distribution between 20+ microservices. Events must be durable
and replayable for event sourcing and audit purposes.

DECISION:
Use Apache Kafka (AWS MSK managed) as the primary event streaming
platform. Topic-per-aggregate-type pattern. ClaimId as partition
key for ordering guarantees.

CONSEQUENCES:
+ Proven at scale (millions of events/day)
+ Durable, replayable event log
+ Decoupled service communication
+ Strong ecosystem (Connect, Streams, Schema Registry)
- Operational complexity (managed service mitigates)
- Eventual consistency between services
- Schema evolution requires Schema Registry discipline
```

```
ADR-004: Camunda 8 for Claims Workflow

STATUS: Accepted
DATE: 2025-02-10

CONTEXT:
Claims processing involves complex, long-running workflows with
human tasks, timers, escalations, and conditional branching. Need
a standards-based (BPMN 2.0) workflow engine that supports
microservices architecture.

DECISION:
Adopt Camunda 8 (Zeebe engine) for claims workflow orchestration.
BPMN 2.0 for process modeling, DMN for decision tables. Deploy as
part of the Kubernetes cluster.

CONSEQUENCES:
+ Standards-based (BPMN 2.0, DMN)
+ Cloud-native with Zeebe engine
+ Visual process modeling for business analysts
+ Built-in monitoring and operations tooling
+ Supports long-running processes with timers
- Learning curve for development team
- Additional infrastructure component
- License cost for enterprise features
```

```
ADR-005: Multi-Region Active-Passive DR Strategy

STATUS: Accepted
DATE: 2025-02-15

CONTEXT:
Claims processing is a business-critical function requiring high
availability. The platform must survive a complete region failure
with minimal data loss and downtime.

DECISION:
Deploy primary in us-east-1, DR in us-west-2. Active-passive
configuration with:
- RDS cross-region read replica (auto-promotion)
- S3 cross-region replication
- Kafka MirrorMaker 2 for event replication
- Kubernetes cluster in DR region (scaled to minimum)
- DNS failover via Route 53

RPO: 1 hour, RTO: 4 hours for claims processing.

CONSEQUENCES:
+ Business continuity guaranteed
+ Regulatory compliance for data protection
+ Tested failover process
- Significant infrastructure cost (DR region)
- Cross-region data replication latency
- Regular DR testing overhead
```

---

## Summary

A modern claims system architecture must balance several competing concerns:

1. **Flexibility** — The insurance industry constantly evolves with new products, regulations, and customer expectations. The architecture must accommodate change without wholesale rewrites.

2. **Reliability** — Claims processing is the core promise of insurance. System downtime directly impacts policyholders and regulatory compliance.

3. **Scalability** — Catastrophic events can spike volume 100x overnight. The architecture must handle these surges gracefully.

4. **Security** — Claims data includes PII, PHI, financial data, and privileged legal information requiring rigorous protection.

5. **Auditability** — Every action must be traceable for regulatory compliance, litigation support, and operational excellence.

6. **Performance** — Adjusters work in these systems all day. Sub-second response times for common operations are essential for productivity.

The microservices approach with event-driven architecture provides the best foundation for these requirements, while acknowledging the operational complexity this introduces. Teams should adopt these patterns incrementally, starting with the highest-value services and expanding as organizational maturity grows.
