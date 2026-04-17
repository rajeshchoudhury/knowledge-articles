# Article 11: Integration Patterns & Enterprise Architecture for Claims

## Table of Contents

1. [Claims System Integration Landscape](#1-claims-system-integration-landscape)
2. [Integration Pattern Taxonomy](#2-integration-pattern-taxonomy)
3. [Enterprise Service Bus (ESB) Architecture](#3-enterprise-service-bus-esb-architecture)
4. [API Gateway Patterns for Claims](#4-api-gateway-patterns-for-claims)
5. [Event-Driven Architecture](#5-event-driven-architecture)
6. [Message Queue Patterns](#6-message-queue-patterns)
7. [Synchronous vs Asynchronous Integration](#7-synchronous-vs-asynchronous-integration)
8. [Canonical Data Model for Claims](#8-canonical-data-model-for-claims)
9. [Data Transformation and Mapping](#9-data-transformation-and-mapping)
10. [Policy Administration System Integration](#10-policy-administration-system-integration)
11. [Billing System Integration](#11-billing-system-integration)
12. [Reinsurance System Integration](#12-reinsurance-system-integration)
13. [General Ledger and ERP Integration](#13-general-ledger-and-erp-integration)
14. [Document Management System Integration](#14-document-management-system-integration)
15. [External Data Provider Integration](#15-external-data-provider-integration)
16. [Vendor Platform Integration](#16-vendor-platform-integration)
17. [Healthcare System Integration](#17-healthcare-system-integration)
18. [State Regulatory System Integration](#18-state-regulatory-system-integration)
19. [OFAC and Sanctions Screening Integration](#19-ofac-and-sanctions-screening-integration)
20. [Real-Time vs Batch Integration](#20-real-time-vs-batch-integration)
21. [File-Based Integration Patterns](#21-file-based-integration-patterns)
22. [Error Handling and Retry Patterns](#22-error-handling-and-retry-patterns)
23. [Circuit Breaker and Bulkhead Patterns](#23-circuit-breaker-and-bulkhead-patterns)
24. [Idempotency Patterns](#24-idempotency-patterns)
25. [Distributed Transaction Management](#25-distributed-transaction-management)
26. [Integration Monitoring and Observability](#26-integration-monitoring-and-observability)
27. [Integration Architecture Diagrams](#27-integration-architecture-diagrams)
28. [API Versioning and Lifecycle Management](#28-api-versioning-and-lifecycle-management)
29. [Security Patterns](#29-security-patterns)
30. [Sample Integration Flows](#30-sample-integration-flows)

---

## 1. Claims System Integration Landscape

### 1.1 The Integration Challenge in Insurance Claims

A claims management system sits at the center of a carrier's technology ecosystem. Unlike greenfield SaaS startups where a single database may suffice, an insurance enterprise must integrate a claims platform with **20 to 50+ upstream, downstream, and lateral systems**. The claims system is the single largest consumer and producer of cross-system events in most P&C carriers.

```
+-----------------------------------------------------------------------+
|                    CLAIMS INTEGRATION LANDSCAPE                        |
+-----------------------------------------------------------------------+
|                                                                       |
|  UPSTREAM SYSTEMS              CLAIMS CORE          DOWNSTREAM SYSTEMS |
|  ┌──────────────┐          ┌──────────────┐       ┌──────────────┐    |
|  │ Policy Admin │─────────▶│              │──────▶│ Reinsurance  │    |
|  │ (PAS)        │          │              │       └──────────────┘    |
|  └──────────────┘          │              │       ┌──────────────┐    |
|  ┌──────────────┐          │   CLAIMS     │──────▶│ General      │    |
|  │ Billing      │─────────▶│   MANAGEMENT │       │ Ledger / ERP │    |
|  │ System       │          │   SYSTEM     │       └──────────────┘    |
|  └──────────────┘          │              │       ┌──────────────┐    |
|  ┌──────────────┐          │              │──────▶│ Regulatory   │    |
|  │ Agency /     │─────────▶│              │       │ Reporting    │    |
|  │ Portal       │          │              │       └──────────────┘    |
|  └──────────────┘          │              │       ┌──────────────┐    |
|  ┌──────────────┐          │              │──────▶│ BI / Data    │    |
|  │ Customer     │─────────▶│              │       │ Warehouse    │    |
|  │ Portal       │          │              │       └──────────────┘    |
|  └──────────────┘          └──────┬───────┘                          |
|                                   │                                   |
|  LATERAL SYSTEMS                  │          VENDOR SYSTEMS            |
|  ┌──────────────┐                 │          ┌──────────────┐         |
|  │ Doc Mgmt     │◀────────────────┤─────────▶│ CCC ONE      │         |
|  │ (ECM)        │                 │          └──────────────┘         |
|  └──────────────┘                 │          ┌──────────────┐         |
|  ┌──────────────┐                 │─────────▶│ Xactimate    │         |
|  │ SIU / Fraud  │◀────────────────┤          └──────────────┘         |
|  │ Detection    │                 │          ┌──────────────┐         |
|  └──────────────┘                 │─────────▶│ Mitchell     │         |
|  ┌──────────────┐                 │          └──────────────┘         |
|  │ Subrogation  │◀────────────────┤          ┌──────────────┐         |
|  │ System       │                 └─────────▶│ Copart / IAA │         |
|  └──────────────┘                            └──────────────┘         |
|                                                                       |
|  EXTERNAL DATA PROVIDERS                                              |
|  ┌───────────┐ ┌───────────┐ ┌───────────┐ ┌───────────┐            |
|  │ ISO Claim │ │ LexisNexis│ │ CLUE      │ │ Weather   │            |
|  │ Search    │ │           │ │           │ │ Data      │            |
|  └───────────┘ └───────────┘ └───────────┘ └───────────┘            |
+-----------------------------------------------------------------------+
```

### 1.2 System Categories and Integration Characteristics

| System Category | Systems | Integration Direction | Volume | Latency Requirement | Pattern |
|---|---|---|---|---|---|
| Policy Admin | Guidewire, Duck Creek, Majesco | Bidirectional | Medium | Sync (< 2s) | API / Event |
| Billing | Guidewire BillingCenter, custom | Downstream | Medium | Async (< 30s) | Event / Batch |
| Reinsurance | Gen Re, Swiss Re, custom | Downstream | Low | Batch (daily) | File / API |
| GL / ERP | SAP, Oracle Financials | Downstream | High | Batch (hourly) | File / API |
| Document Mgmt | OnBase, FileNet, Alfresco | Bidirectional | Very High | Sync (< 5s) | API |
| External Data | ISO, LexisNexis, CLUE | Upstream | Medium | Sync (< 10s) | API |
| Vendor Platforms | CCC, Mitchell, Xactimate | Bidirectional | High | Async (< 60s) | API / File |
| Regulatory | State DOI, NAIC | Downstream | Low | Batch (monthly) | File |
| SIU / Fraud | SHIFT, SAS, FICO | Bidirectional | Medium | Sync (< 5s) | API / Event |
| BI / DW | Snowflake, Databricks | Downstream | Very High | Batch (nightly) | CDC / File |

### 1.3 Integration Volume Profiles

A mid-sized carrier processing 100,000 claims per year generates:

| Transaction Type | Daily Volume | Peak Volume | Avg Payload Size |
|---|---|---|---|
| Policy Lookups | 2,000 | 10,000 (CAT) | 15 KB |
| Claim Status Events | 15,000 | 75,000 (CAT) | 3 KB |
| Payment Transactions | 5,000 | 25,000 | 8 KB |
| Document Uploads | 8,000 | 40,000 | 2 MB |
| Estimate Exchanges | 1,500 | 7,500 | 50 KB |
| Reserve Changes | 3,000 | 15,000 | 5 KB |
| GL Postings | 10,000 | 50,000 | 2 KB |
| External Data Calls | 3,000 | 15,000 | 20 KB |

### 1.4 Integration Quality Attributes

When architecting claims integration, these quality attributes must be evaluated:

| Attribute | Description | Claims-Specific Consideration |
|---|---|---|
| Reliability | Message guaranteed delivery | Payment transactions cannot be lost |
| Ordering | Sequence of message processing | Reserve changes must apply in order |
| Idempotency | Safe to retry without duplication | Duplicate payments are catastrophic |
| Latency | Time for end-to-end processing | FNOL requires sub-second policy lookup |
| Throughput | Volume handling capacity | CAT events = 10x normal volume |
| Observability | Tracing, logging, monitoring | Regulatory audit requires full trail |
| Security | Data protection in transit/rest | PII, PHI, financial data everywhere |
| Recoverability | Recovery from failure states | Must reconcile after outage |

---

## 2. Integration Pattern Taxonomy

### 2.1 Point-to-Point Integration

The simplest and most common legacy pattern where systems connect directly.

```
  ┌──────┐     ┌──────┐
  │ Sys A│────▶│ Sys B│
  └──────┘     └──────┘
  ┌──────┐     ┌──────┐
  │ Sys A│────▶│ Sys C│
  └──────┘     └──────┘
  ┌──────┐     ┌──────┐
  │ Sys B│────▶│ Sys C│
  └──────┘     └──────┘

  With N systems, connections = N(N-1)/2
  10 systems = 45 connections
  20 systems = 190 connections
```

**Advantages for Claims:**
- Simple to implement for initial integrations
- Low latency (direct connection)
- No middleware dependency

**Disadvantages for Claims:**
- Exponential growth in connections (n-squared problem)
- Tight coupling between systems
- No centralized logging, monitoring, or transformation
- Brittle: changing one system's API breaks all consumers
- No message replay capability

**When to Use:**
- Prototype or MVP claims systems
- Single integration between two stable systems
- Ultra-low latency requirements (< 100ms)

### 2.2 Hub-and-Spoke (ESB) Pattern

All systems communicate through a central integration hub.

```
                    ┌──────────────────┐
                    │                  │
  ┌──────┐         │   ENTERPRISE     │         ┌──────┐
  │Policy │────────▶│   SERVICE BUS    │────────▶│  GL  │
  │ Admin │◀────────│                  │◀────────│      │
  └──────┘         │  ┌────────────┐  │         └──────┘
                    │  │ Transform  │  │
  ┌──────┐         │  │ Route      │  │         ┌──────┐
  │Claims │────────▶│  │ Enrich     │  │────────▶│Reins │
  │System │◀────────│  │ Validate   │  │◀────────│      │
  └──────┘         │  │ Log        │  │         └──────┘
                    │  └────────────┘  │
  ┌──────┐         │                  │         ┌──────┐
  │Vendor │────────▶│                  │────────▶│  DW  │
  │System │◀────────│                  │◀────────│      │
  └──────┘         └──────────────────┘         └──────┘
```

**Advantages for Claims:**
- Centralized message transformation and routing
- Single point for security enforcement
- Audit trail and logging
- Protocol mediation (REST ↔ SOAP ↔ File ↔ MQ)

**Disadvantages for Claims:**
- Single point of failure (mitigated with HA deployment)
- Can become a bottleneck at scale
- Vendor lock-in (MuleSoft, IBM, TIBCO licenses are expensive)
- Operational complexity

### 2.3 Event-Driven Architecture (EDA)

Systems publish events to an event backbone; interested systems subscribe.

```
  PRODUCERS                EVENT BACKBONE              CONSUMERS
  ┌──────┐            ┌────────────────────┐
  │Claims│──publish──▶│                    │──subscribe──▶┌──────┐
  │System│            │  claim.created     │              │  GL  │
  └──────┘            │  claim.updated     │──subscribe──▶┌──────┐
                      │  reserve.changed   │              │Reins │
  ┌──────┐            │  payment.issued    │──subscribe──▶└──────┘
  │Policy│──publish──▶│  policy.endorsed   │              ┌──────┐
  │Admin │            │  policy.cancelled  │──subscribe──▶│  DW  │
  └──────┘            │  document.uploaded  │              └──────┘
                      │  estimate.received │
  ┌──────┐            │  fraud.detected    │──subscribe──▶┌──────┐
  │Vendor│──publish──▶│                    │              │ SIU  │
  │System│            └────────────────────┘              └──────┘
  └──────┘
```

**Event Categories in Claims:**

| Category | Events | Typical Consumers |
|---|---|---|
| Claim Lifecycle | `claim.created`, `claim.reopened`, `claim.closed` | GL, BI, Reinsurance, Regulatory |
| Reserve | `reserve.set`, `reserve.changed`, `reserve.released` | GL, Reinsurance, BI |
| Payment | `payment.requested`, `payment.approved`, `payment.issued` | GL, Billing, Tax, 1099 |
| Coverage | `coverage.verified`, `coverage.denied` | SIU, Subrogation |
| Assignment | `claim.assigned`, `claim.reassigned` | Workforce Management |
| Estimate | `estimate.received`, `estimate.approved`, `supplement.received` | Vendor Systems, Financial |
| Document | `document.uploaded`, `document.classified` | ECM, Compliance |
| Fraud | `fraud.alert.raised`, `fraud.investigation.opened` | SIU, Management |

### 2.4 API-Led Connectivity

Three-layer API architecture separating concerns.

```
  ┌─────────────────────────────────────────────────┐
  │                EXPERIENCE APIs                   │
  │  (Channel-specific: web portal, mobile, agent)  │
  │                                                  │
  │  GET /portal/claims/{id}/summary                │
  │  POST /mobile/fnol                              │
  │  GET /agent/claims/dashboard                    │
  └────────────────────┬────────────────────────────┘
                       │
  ┌────────────────────▼────────────────────────────┐
  │                 PROCESS APIs                     │
  │  (Business process orchestration)               │
  │                                                  │
  │  POST /claims                                   │
  │  PUT /claims/{id}/reserves                      │
  │  POST /claims/{id}/payments                     │
  │  PUT /claims/{id}/assignment                    │
  └────────────────────┬────────────────────────────┘
                       │
  ┌────────────────────▼────────────────────────────┐
  │                 SYSTEM APIs                      │
  │  (Direct system access, canonical data model)   │
  │                                                  │
  │  GET /policy-admin/policies/{policyNumber}      │
  │  POST /accounting/journal-entries               │
  │  GET /document-mgmt/documents/{docId}           │
  │  POST /vendor/estimates                         │
  └─────────────────────────────────────────────────┘
```

### 2.5 Microservices Mesh

Claims decomposed into microservices communicating via service mesh.

```
  ┌─────────────────────────────────────────────────────────┐
  │                    SERVICE MESH (Istio/Linkerd)          │
  │                                                          │
  │  ┌──────────┐   ┌──────────┐   ┌──────────┐            │
  │  │  FNOL    │   │ Coverage │   │ Reserve  │            │
  │  │ Service  │──▶│ Service  │──▶│ Service  │            │
  │  └──────────┘   └──────────┘   └──────────┘            │
  │       │                              │                   │
  │       ▼                              ▼                   │
  │  ┌──────────┐   ┌──────────┐   ┌──────────┐            │
  │  │Assignment│   │ Payment  │   │ Vendor   │            │
  │  │ Service  │   │ Service  │──▶│ Service  │            │
  │  └──────────┘   └──────────┘   └──────────┘            │
  │       │              │                                   │
  │       ▼              ▼                                   │
  │  ┌──────────┐   ┌──────────┐   ┌──────────┐            │
  │  │Litigation│   │Subrogation   │ Reporting│            │
  │  │ Service  │   │ Service  │   │ Service  │            │
  │  └──────────┘   └──────────┘   └──────────┘            │
  │                                                          │
  │  [mTLS]  [Load Balancing]  [Circuit Breaking]           │
  │  [Retry]  [Observability]  [Traffic Management]         │
  └─────────────────────────────────────────────────────────┘
```

### 2.6 Pattern Selection Matrix

| Criteria | Point-to-Point | ESB | Event-Driven | API-Led | Microservices |
|---|---|---|---|---|---|
| Integration Count | < 5 | 5 – 30 | 10 – 100+ | 10 – 50 | 20 – 100+ |
| Team Size | < 5 | 5 – 20 | 10 – 50 | 10 – 30 | 20 – 100+ |
| Latency | Lowest | Medium | Variable | Medium | Medium |
| Scalability | Low | Medium | High | High | Highest |
| Operational Cost | Low | High | Medium | Medium | High |
| Vendor Lock-in | Low | High | Medium | Medium | Low |
| Best For Claims | MVP | Mid-market | Large carrier | Growing carrier | Insurtech / Digital |

---

## 3. Enterprise Service Bus (ESB) Architecture

### 3.1 ESB in Claims: Role and Responsibilities

The ESB acts as the integration backbone, handling:

1. **Protocol Mediation** – Converting between REST, SOAP, JMS, File, FTP
2. **Message Routing** – Content-based, header-based, itinerary-based
3. **Message Transformation** – Format conversion (XML ↔ JSON ↔ CSV ↔ Fixed-width)
4. **Message Enrichment** – Adding data from reference sources
5. **Security Enforcement** – Authentication, authorization, encryption
6. **Error Handling** – Dead letter queues, retry policies, alerting
7. **Logging and Audit** – Message capture for compliance

### 3.2 MuleSoft Integration for Claims

MuleSoft Anypoint Platform is the most commonly adopted ESB/iPaaS for P&C carriers modernizing their integration layer.

**Architecture:**

```
  ┌──────────────────────────────────────────────────────┐
  │              MuleSoft Anypoint Platform               │
  │                                                       │
  │  ┌───────────────────────────────────────────────┐   │
  │  │            Anypoint Exchange                   │   │
  │  │  [Claims API] [Policy API] [Payment API]      │   │
  │  │  [Vendor API] [Document API] [GL API]         │   │
  │  └───────────────────────────────────────────────┘   │
  │                                                       │
  │  ┌───────────────────────────────────────────────┐   │
  │  │           API Manager / Gateway               │   │
  │  │  [Rate Limiting] [OAuth2] [CORS] [Throttling] │   │
  │  └───────────────────────────────────────────────┘   │
  │                                                       │
  │  ┌───────────────────────────────────────────────┐   │
  │  │         Mule Runtime Engine (CloudHub 2.0)    │   │
  │  │                                                │   │
  │  │  ┌────────────┐  ┌────────────┐              │   │
  │  │  │ Claims     │  │ Policy     │              │   │
  │  │  │ Process API│  │ System API │              │   │
  │  │  └────────────┘  └────────────┘              │   │
  │  │  ┌────────────┐  ┌────────────┐              │   │
  │  │  │ Payment    │  │ GL         │              │   │
  │  │  │ Process API│  │ System API │              │   │
  │  │  └────────────┘  └────────────┘              │   │
  │  │                                                │   │
  │  │  [DataWeave] [Connectors] [Object Store]      │   │
  │  └───────────────────────────────────────────────┘   │
  │                                                       │
  │  ┌───────────────────────────────────────────────┐   │
  │  │          Anypoint MQ / Messaging              │   │
  │  │  [claim-events-queue]  [payment-queue]        │   │
  │  │  [gl-posting-queue]    [dead-letter-queue]    │   │
  │  └───────────────────────────────────────────────┘   │
  └──────────────────────────────────────────────────────┘
```

**Sample MuleSoft DataWeave Transformation – Claim to GL Posting:**

```dataweave
%dw 2.0
output application/json
---
{
  journalEntries: payload.payments map ((payment) -> {
    entryId: uuid(),
    postingDate: now() as String { format: "yyyy-MM-dd" },
    effectiveDate: payment.issueDate,
    source: "CLAIMS",
    sourceReference: payment.claimNumber,
    description: "Claim Payment - " ++ payment.claimNumber ++ " - " ++ payment.payeeName,
    lineItems: [
      {
        accountCode: payment.coverageType match {
          case "LIABILITY_BI" -> "6100-1010"
          case "LIABILITY_PD" -> "6100-1020"
          case "COLLISION"    -> "6100-1030"
          case "COMPREHENSIVE"-> "6100-1040"
          case "PIP"          -> "6100-1050"
          else                -> "6100-1099"
        },
        debitAmount: payment.amount,
        creditAmount: 0,
        costCenter: payment.branchCode,
        lob: payment.lineOfBusiness,
        state: payment.lossState
      },
      {
        accountCode: "1010-0010",
        debitAmount: 0,
        creditAmount: payment.amount,
        costCenter: "CORP",
        lob: payment.lineOfBusiness,
        state: payment.lossState
      }
    ]
  })
}
```

### 3.3 IBM Integration Bus (App Connect Enterprise)

**Deployment Architecture:**

```
  ┌────────────────────────────────────────────────────┐
  │         IBM App Connect Enterprise                  │
  │                                                     │
  │  Integration Node: CLAIMS_PROD                      │
  │  ├── Integration Server: CLAIMS_INBOUND            │
  │  │   ├── Flow: FNOL_Intake                         │
  │  │   ├── Flow: Policy_Lookup                       │
  │  │   └── Flow: Coverage_Verification               │
  │  │                                                  │
  │  ├── Integration Server: CLAIMS_OUTBOUND           │
  │  │   ├── Flow: GL_Posting                          │
  │  │   ├── Flow: Reinsurance_Notification            │
  │  │   └── Flow: Regulatory_Reporting                │
  │  │                                                  │
  │  ├── Integration Server: VENDOR_INTEGRATION        │
  │  │   ├── Flow: CCC_Estimate_Exchange               │
  │  │   ├── Flow: Mitchell_Assignment                 │
  │  │   ├── Flow: Xactimate_Estimate_Import           │
  │  │   └── Flow: Copart_Salvage_Assignment           │
  │  │                                                  │
  │  └── Integration Server: DATA_SERVICES            │
  │      ├── Flow: ISO_ClaimSearch                     │
  │      ├── Flow: LexisNexis_Lookup                   │
  │      └── Flow: CLUE_Report                         │
  │                                                     │
  │  Message Flows use:                                 │
  │  - MQ Input/Output nodes (IBM MQ)                  │
  │  - HTTP Input/Request nodes (REST/SOAP)            │
  │  - File Input/Output nodes (batch)                 │
  │  - ESQL / Java Compute nodes (transformation)      │
  └────────────────────────────────────────────────────┘
```

### 3.4 TIBCO Integration

```
  ┌────────────────────────────────────────────────────┐
  │              TIBCO Integration Suite                 │
  │                                                     │
  │  BusinessWorks Container Edition                    │
  │  ├── Claims Integration Application                │
  │  │   ├── Process: ClaimIntake                      │
  │  │   ├── Process: PolicyValidation                 │
  │  │   ├── Process: PaymentProcessing                │
  │  │   └── Process: VendorCommunication              │
  │  │                                                  │
  │  TIBCO EMS (Enterprise Message Service)            │
  │  ├── Queue: claims.fnol.inbound                    │
  │  ├── Queue: claims.payment.outbound                │
  │  ├── Topic: claims.status.updates                  │
  │  └── Queue: claims.errors.deadletter              │
  │                                                     │
  │  TIBCO Mashery (API Management)                    │
  │  ├── Claims API Gateway                            │
  │  ├── Partner API Portal                            │
  │  └── Analytics Dashboard                           │
  └────────────────────────────────────────────────────┘
```

### 3.5 ESB Product Comparison for Claims

| Feature | MuleSoft | IBM ACE | TIBCO BW |
|---|---|---|---|
| Deployment | CloudHub, Hybrid, On-Prem | On-Prem, CP4I (OpenShift) | Container, On-Prem |
| Transformation | DataWeave | ESQL, Java, Graphical Map | XSLT, Java, Mapper |
| API Management | Built-in (Anypoint) | IBM API Connect (separate) | Mashery (separate) |
| Messaging | Anypoint MQ | IBM MQ | TIBCO EMS |
| Connectors | 400+ pre-built | Moderate | Moderate |
| Insurance-Specific | ACORD connectors, Guidewire | Generic | Generic |
| Learning Curve | Moderate | Steep | Moderate |
| Cost (Annual) | $75K – $500K+ | $100K – $1M+ | $80K – $400K+ |
| Cloud-Native | Yes (CloudHub 2.0) | Partial (CP4I) | Yes (BWCE) |
| Market Trend (P&C) | Growing rapidly | Declining | Stable |

---

## 4. API Gateway Patterns for Claims

### 4.1 API Gateway Role in Claims

The API Gateway sits at the perimeter, handling cross-cutting concerns before requests reach backend services.

```
  CONSUMERS                    GATEWAY                    CLAIMS SERVICES
  ┌───────────┐           ┌──────────────┐           ┌───────────────┐
  │ Agent     │──HTTPS───▶│              │──────────▶│ FNOL Service  │
  │ Portal    │           │  ┌────────┐  │           └───────────────┘
  └───────────┘           │  │Auth    │  │           ┌───────────────┐
  ┌───────────┐           │  │Rate    │  │──────────▶│ Search Service│
  │ Customer  │──HTTPS───▶│  │Limit   │  │           └───────────────┘
  │ Portal    │           │  │Log     │  │           ┌───────────────┐
  └───────────┘           │  │Cache   │  │──────────▶│ Payment Svc   │
  ┌───────────┐           │  │Route   │  │           └───────────────┘
  │ Mobile    │──HTTPS───▶│  │Transform│  │           ┌───────────────┐
  │ App       │           │  │Throttle│  │──────────▶│ Document Svc  │
  └───────────┘           │  └────────┘  │           └───────────────┘
  ┌───────────┐           │              │           ┌───────────────┐
  │ Vendor    │──HTTPS───▶│              │──────────▶│ Vendor Svc    │
  │ Partners  │           └──────────────┘           └───────────────┘
  └───────────┘
```

### 4.2 Kong Gateway Configuration

```yaml
# Kong declarative configuration for Claims API
_format_version: "3.0"

services:
  - name: claims-fnol-service
    url: http://claims-fnol.internal:8080
    routes:
      - name: fnol-route
        paths:
          - /api/v1/claims/fnol
        methods:
          - POST
        strip_path: false
    plugins:
      - name: rate-limiting
        config:
          minute: 100
          hour: 5000
          policy: redis
          redis_host: redis.internal
      - name: oauth2
        config:
          scopes:
            - claims:write
          mandatory_scope: true
          token_expiration: 3600
      - name: request-transformer
        config:
          add:
            headers:
              - "X-Request-Source:gateway"
              - "X-Correlation-ID:$(uuid)"
      - name: response-ratelimiting
        config:
          limits:
            claims:
              minute: 200
      - name: request-size-limiting
        config:
          allowed_payload_size: 10  # MB

  - name: claims-search-service
    url: http://claims-search.internal:8080
    routes:
      - name: claims-search-route
        paths:
          - /api/v1/claims
        methods:
          - GET
    plugins:
      - name: rate-limiting
        config:
          minute: 500
          hour: 25000
      - name: proxy-cache
        config:
          response_code:
            - 200
          request_method:
            - GET
          content_type:
            - "application/json"
          cache_ttl: 30
          strategy: memory

  - name: claims-payment-service
    url: http://claims-payment.internal:8080
    routes:
      - name: payment-route
        paths:
          - /api/v1/claims/payments
        methods:
          - POST
    plugins:
      - name: rate-limiting
        config:
          minute: 50
      - name: request-validator
        config:
          body_schema: |
            {
              "type": "object",
              "required": ["claimNumber", "amount", "payeeId"],
              "properties": {
                "claimNumber": { "type": "string", "pattern": "^CLM-[0-9]{10}$" },
                "amount": { "type": "number", "minimum": 0.01, "maximum": 10000000 },
                "payeeId": { "type": "string" }
              }
            }

consumers:
  - username: agent-portal
    keyauth_credentials:
      - key: agent-portal-api-key-prod
  - username: customer-portal
    keyauth_credentials:
      - key: customer-portal-api-key-prod
  - username: vendor-ccc
    keyauth_credentials:
      - key: vendor-ccc-api-key-prod

upstreams:
  - name: claims-fnol-upstream
    algorithm: round-robin
    healthchecks:
      active:
        http_path: /health
        healthy:
          interval: 5
          successes: 2
        unhealthy:
          interval: 5
          http_failures: 3
    targets:
      - target: claims-fnol-1.internal:8080
        weight: 100
      - target: claims-fnol-2.internal:8080
        weight: 100
```

### 4.3 AWS API Gateway Configuration

```yaml
# AWS SAM template for Claims API Gateway
AWSTemplateFormatVersion: '2010-09-09'
Transform: AWS::Serverless-2016-10-31

Resources:
  ClaimsApi:
    Type: AWS::Serverless::Api
    Properties:
      StageName: prod
      Auth:
        DefaultAuthorizer: ClaimsCognitoAuthorizer
        Authorizers:
          ClaimsCognitoAuthorizer:
            UserPoolArn: !GetAtt ClaimsUserPool.Arn
      AccessLogSetting:
        DestinationArn: !GetAtt ApiAccessLogGroup.Arn
        Format: >-
          {"requestId":"$context.requestId",
           "ip":"$context.identity.sourceIp",
           "caller":"$context.identity.caller",
           "user":"$context.identity.user",
           "requestTime":"$context.requestTime",
           "httpMethod":"$context.httpMethod",
           "resourcePath":"$context.resourcePath",
           "status":"$context.status",
           "protocol":"$context.protocol",
           "responseLength":"$context.responseLength",
           "integrationLatency":"$context.integrationLatency"}
      MethodSettings:
        - ResourcePath: "/*"
          HttpMethod: "*"
          ThrottlingBurstLimit: 500
          ThrottlingRateLimit: 1000
          MetricsEnabled: true
          DataTraceEnabled: false
          LoggingLevel: INFO
      Models:
        ClaimFNOL:
          type: object
          required:
            - policyNumber
            - lossDate
            - lossDescription
          properties:
            policyNumber:
              type: string
              pattern: "^POL-[A-Z]{2}-[0-9]{8}$"
            lossDate:
              type: string
              format: date-time
            lossDescription:
              type: string
              maxLength: 5000

  FnolFunction:
    Type: AWS::Serverless::Function
    Properties:
      Handler: com.insurance.claims.fnol.Handler::handleRequest
      Runtime: java17
      MemorySize: 1024
      Timeout: 30
      Events:
        CreateClaim:
          Type: Api
          Properties:
            RestApiId: !Ref ClaimsApi
            Path: /claims/fnol
            Method: POST
```

### 4.4 Apigee Configuration

```xml
<!-- Apigee Proxy Configuration for Claims API -->
<ProxyEndpoint name="claims-proxy">
  <PreFlow>
    <Request>
      <!-- Verify API Key -->
      <Step>
        <Name>Verify-API-Key</Name>
      </Step>
      <!-- OAuth2 Token Validation -->
      <Step>
        <Name>OAuth-v20-Verify-Access-Token</Name>
      </Step>
      <!-- Spike Arrest -->
      <Step>
        <Name>Spike-Arrest-Claims</Name>
        <Condition>proxy.pathsuffix MatchesPath "/fnol"</Condition>
      </Step>
      <!-- Quota Enforcement -->
      <Step>
        <Name>Quota-Claims-API</Name>
      </Step>
      <!-- Threat Protection -->
      <Step>
        <Name>JSON-Threat-Protection</Name>
      </Step>
      <!-- Correlation ID -->
      <Step>
        <Name>Assign-Correlation-ID</Name>
      </Step>
    </Request>
  </PreFlow>

  <Flows>
    <Flow name="FNOL">
      <Condition>
        (proxy.pathsuffix MatchesPath "/fnol") and (request.verb = "POST")
      </Condition>
      <Request>
        <Step>
          <Name>Validate-FNOL-Schema</Name>
        </Step>
        <Step>
          <Name>Extract-Policy-Number</Name>
        </Step>
      </Request>
    </Flow>
    <Flow name="ClaimSearch">
      <Condition>
        (proxy.pathsuffix MatchesPath "/claims") and (request.verb = "GET")
      </Condition>
      <Request>
        <Step>
          <Name>Cache-Lookup</Name>
        </Step>
      </Request>
      <Response>
        <Step>
          <Name>Cache-Populate</Name>
        </Step>
      </Response>
    </Flow>
  </Flows>

  <PostFlow>
    <Response>
      <Step>
        <Name>Add-CORS-Headers</Name>
      </Step>
      <Step>
        <Name>Log-To-Stackdriver</Name>
      </Step>
    </Response>
  </PostFlow>

  <HTTPProxyConnection>
    <BasePath>/v1/claims</BasePath>
    <VirtualHost>secure</VirtualHost>
  </HTTPProxyConnection>

  <RouteRule name="fnol-target">
    <Condition>proxy.pathsuffix MatchesPath "/fnol"</Condition>
    <TargetEndpoint>claims-fnol-backend</TargetEndpoint>
  </RouteRule>
  <RouteRule name="default-target">
    <TargetEndpoint>claims-core-backend</TargetEndpoint>
  </RouteRule>
</ProxyEndpoint>
```

### 4.5 Gateway Pattern Comparison

| Feature | Kong | AWS API GW | Apigee | Azure APIM |
|---|---|---|---|---|
| Deployment | Self-hosted / Cloud | AWS-managed | Google-managed | Azure-managed |
| Protocol Support | REST, gRPC, WebSocket | REST, WebSocket | REST, SOAP, gRPC | REST, SOAP, GraphQL |
| Auth | OAuth2, JWT, Key, LDAP | Cognito, Lambda Auth | OAuth2, SAML, Key | OAuth2, JWT, Cert |
| Rate Limiting | Plugin-based | Per-stage | Quota + Spike Arrest | Policy-based |
| Transformation | Plugin-based | VTL, Lambda | JavaScript, Java | Policy (XSLT, Liquid) |
| Analytics | Plugin (Prometheus) | CloudWatch | Built-in analytics | Built-in analytics |
| Cost Model | Open-source / Enterprise | Per-request | Subscription | Tier-based |
| Claims Fit | Hybrid / On-prem carriers | AWS-native carriers | Google-aligned | Azure-aligned |

---

## 5. Event-Driven Architecture

### 5.1 Apache Kafka for Claims

Kafka is the most widely adopted event backbone for large P&C carriers.

**Topic Design:**

```
claims-events/
├── claims.fnol.created              # New claim intake
├── claims.status.changed            # Claim status transitions
├── claims.coverage.verified         # Coverage decision
├── claims.coverage.denied           # Coverage denial
├── claims.assignment.changed        # Adjuster assignment
├── claims.reserve.set               # Initial reserve
├── claims.reserve.changed           # Reserve adjustment
├── claims.reserve.released          # Reserve release on closure
├── claims.payment.requested         # Payment authorization request
├── claims.payment.approved          # Payment authorized
├── claims.payment.issued            # Check/ACH sent
├── claims.payment.voided            # Payment void
├── claims.estimate.received         # Vendor estimate arrived
├── claims.estimate.approved         # Estimate approved
├── claims.estimate.supplement       # Supplement received
├── claims.document.uploaded         # Document attached
├── claims.document.classified       # AI classification completed
├── claims.fraud.alert               # Fraud score threshold exceeded
├── claims.litigation.filed          # Lawsuit received
├── claims.subrogation.identified    # Subro opportunity found
├── claims.closed                    # Claim finalized
├── claims.reopened                  # Claim reopened
```

**Kafka Cluster Configuration:**

```properties
# Kafka Broker Configuration for Claims
broker.id=1
num.network.threads=8
num.io.threads=16
socket.send.buffer.bytes=102400
socket.receive.buffer.bytes=102400
socket.request.max.bytes=104857600

log.dirs=/var/kafka-data/claims
num.partitions=12
default.replication.factor=3
min.insync.replicas=2

log.retention.hours=168  # 7 days for hot data
log.retention.bytes=107374182400  # 100 GB per partition
log.segment.bytes=1073741824  # 1 GB segments

# Exactly-once semantics (critical for payments)
transaction.state.log.replication.factor=3
transaction.state.log.min.isr=2

# Compression
compression.type=lz4

# Security
security.inter.broker.protocol=SASL_SSL
sasl.mechanism.inter.broker.protocol=SCRAM-SHA-512
ssl.keystore.location=/etc/kafka/ssl/kafka.keystore.jks
ssl.truststore.location=/etc/kafka/ssl/kafka.truststore.jks
```

**Claim Event Schema (Avro):**

```json
{
  "type": "record",
  "name": "ClaimEvent",
  "namespace": "com.insurance.claims.events",
  "fields": [
    { "name": "eventId", "type": "string", "doc": "Unique event identifier (UUID)" },
    { "name": "eventType", "type": {
        "type": "enum",
        "name": "ClaimEventType",
        "symbols": [
          "CLAIM_CREATED", "CLAIM_UPDATED", "CLAIM_CLOSED", "CLAIM_REOPENED",
          "RESERVE_SET", "RESERVE_CHANGED", "RESERVE_RELEASED",
          "PAYMENT_REQUESTED", "PAYMENT_APPROVED", "PAYMENT_ISSUED", "PAYMENT_VOIDED",
          "COVERAGE_VERIFIED", "COVERAGE_DENIED",
          "ESTIMATE_RECEIVED", "ESTIMATE_APPROVED",
          "ASSIGNMENT_CHANGED", "DOCUMENT_UPLOADED",
          "FRAUD_ALERT", "LITIGATION_FILED",
          "SUBROGATION_IDENTIFIED"
        ]
      }
    },
    { "name": "eventTimestamp", "type": "long", "logicalType": "timestamp-millis" },
    { "name": "claimNumber", "type": "string" },
    { "name": "policyNumber", "type": "string" },
    { "name": "lineOfBusiness", "type": "string" },
    { "name": "state", "type": "string" },
    { "name": "correlationId", "type": "string" },
    { "name": "causationId", "type": ["null", "string"], "default": null },
    { "name": "userId", "type": "string" },
    { "name": "source", "type": "string" },
    { "name": "schemaVersion", "type": "int", "default": 1 },
    { "name": "payload", "type": "string", "doc": "JSON-encoded event-specific payload" },
    { "name": "metadata", "type": { "type": "map", "values": "string" } }
  ]
}
```

**Kafka Consumer for GL Posting:**

```java
@KafkaListener(
    topics = {"claims.payment.issued", "claims.reserve.changed", "claims.reserve.released"},
    groupId = "gl-posting-consumer",
    containerFactory = "claimsKafkaListenerContainerFactory"
)
public class GLPostingConsumer {

    private final GLPostingService glPostingService;
    private final IdempotencyStore idempotencyStore;

    @KafkaHandler
    public void handlePaymentIssued(
            @Payload ClaimEvent event,
            @Header(KafkaHeaders.RECEIVED_KEY) String key,
            @Header(KafkaHeaders.RECEIVED_PARTITION) int partition,
            @Header(KafkaHeaders.OFFSET) long offset,
            Acknowledgment ack) {

        String idempotencyKey = event.getEventId();

        if (idempotencyStore.isDuplicate(idempotencyKey)) {
            log.info("Duplicate event detected: {}", idempotencyKey);
            ack.acknowledge();
            return;
        }

        try {
            PaymentPayload payment = deserializePayload(event.getPayload(), PaymentPayload.class);

            GLJournalEntry entry = GLJournalEntry.builder()
                .entryId(UUID.randomUUID().toString())
                .postingDate(LocalDate.now())
                .effectiveDate(payment.getIssueDate())
                .source("CLAIMS")
                .sourceReference(event.getClaimNumber())
                .debitAccount(mapCoverageToExpenseAccount(payment.getCoverageType()))
                .creditAccount("1010-0010")  // Cash/Bank account
                .amount(payment.getAmount())
                .currency(payment.getCurrency())
                .lineOfBusiness(event.getLineOfBusiness())
                .state(event.getState())
                .build();

            glPostingService.postJournalEntry(entry);
            idempotencyStore.record(idempotencyKey, entry.getEntryId());
            ack.acknowledge();

        } catch (RetryableException e) {
            log.warn("Retryable error processing event: {}", idempotencyKey, e);
            throw e;  // Will be retried by container
        } catch (Exception e) {
            log.error("Non-retryable error processing event: {}", idempotencyKey, e);
            deadLetterPublisher.publish(event, e);
            ack.acknowledge();
        }
    }
}
```

### 5.2 AWS EventBridge for Claims

```json
{
  "Source": "com.insurance.claims",
  "DetailType": "ClaimPaymentIssued",
  "Detail": {
    "claimNumber": "CLM-2025-00001234",
    "policyNumber": "POL-CA-20250001",
    "paymentId": "PAY-2025-00005678",
    "payeeType": "CLAIMANT",
    "payeeName": "John Smith",
    "amount": 15000.00,
    "currency": "USD",
    "paymentMethod": "ACH",
    "coverageType": "COLLISION",
    "lineOfBusiness": "PERSONAL_AUTO",
    "state": "CA",
    "branchCode": "WEST-01"
  },
  "Time": "2025-03-15T14:30:00Z",
  "Resources": ["arn:aws:claims:us-west-2:123456789:claim/CLM-2025-00001234"]
}
```

**EventBridge Rules:**

```json
{
  "Rules": [
    {
      "Name": "ClaimPaymentToGL",
      "EventPattern": {
        "source": ["com.insurance.claims"],
        "detail-type": ["ClaimPaymentIssued", "ClaimPaymentVoided"]
      },
      "Targets": [
        {
          "Id": "GLPostingQueue",
          "Arn": "arn:aws:sqs:us-west-2:123456789:gl-posting-queue",
          "DeadLetterConfig": {
            "Arn": "arn:aws:sqs:us-west-2:123456789:gl-posting-dlq"
          },
          "RetryPolicy": {
            "MaximumRetryAttempts": 5,
            "MaximumEventAgeInSeconds": 86400
          }
        }
      ]
    },
    {
      "Name": "LargeClaimAlert",
      "EventPattern": {
        "source": ["com.insurance.claims"],
        "detail-type": ["ClaimReserveChanged"],
        "detail": {
          "newReserveAmount": [{ "numeric": [">=", 500000] }]
        }
      },
      "Targets": [
        {
          "Id": "LargeClaimSNS",
          "Arn": "arn:aws:sns:us-west-2:123456789:large-claim-notifications"
        }
      ]
    },
    {
      "Name": "FraudAlertRouting",
      "EventPattern": {
        "source": ["com.insurance.claims"],
        "detail-type": ["FraudAlertRaised"],
        "detail": {
          "fraudScore": [{ "numeric": [">=", 80] }]
        }
      },
      "Targets": [
        {
          "Id": "SIUQueue",
          "Arn": "arn:aws:sqs:us-west-2:123456789:siu-investigation-queue"
        }
      ]
    }
  ]
}
```

### 5.3 Azure Event Grid for Claims

```json
{
  "properties": {
    "topic": "/subscriptions/{sub-id}/resourceGroups/claims-rg/providers/Microsoft.EventGrid/topics/claims-events",
    "inputSchema": "CloudEventSchemaV1_0",
    "publicNetworkAccess": "Disabled",
    "inboundIpRules": [],
    "dataResidencyBoundary": "WithinRegion"
  }
}
```

**Event Grid Subscriptions:**

```json
[
  {
    "name": "claims-to-gl-subscription",
    "properties": {
      "destination": {
        "endpointType": "ServiceBusQueue",
        "properties": {
          "resourceId": "/subscriptions/{sub-id}/resourceGroups/claims-rg/providers/Microsoft.ServiceBus/namespaces/claims-ns/queues/gl-posting"
        }
      },
      "filter": {
        "includedEventTypes": [
          "Claims.Payment.Issued",
          "Claims.Payment.Voided",
          "Claims.Reserve.Changed"
        ],
        "advancedFilters": [
          {
            "operatorType": "StringIn",
            "key": "data.lineOfBusiness",
            "values": ["PERSONAL_AUTO", "HOMEOWNERS", "COMMERCIAL_AUTO"]
          }
        ]
      },
      "retryPolicy": {
        "maxDeliveryAttempts": 10,
        "eventTimeToLiveInMinutes": 1440
      },
      "deadLetterDestination": {
        "endpointType": "StorageBlob",
        "properties": {
          "resourceId": "/subscriptions/{sub-id}/resourceGroups/claims-rg/providers/Microsoft.Storage/storageAccounts/claimsdlq",
          "blobContainerName": "gl-posting-dlq"
        }
      }
    }
  }
]
```

---

## 6. Message Queue Patterns

### 6.1 Queue Topology for Claims

```
CLAIMS QUEUE ARCHITECTURE
═══════════════════════════════════════════════════════════════

  HIGH PRIORITY QUEUES (SLA < 30s)
  ┌─────────────────────────────────────┐
  │ claims.fnol.intake                  │  FNOL submission processing
  │ claims.payment.authorization        │  Payment approval requests
  │ claims.fraud.scoring                │  Real-time fraud checks
  │ claims.coverage.verification        │  Policy/coverage lookup
  └─────────────────────────────────────┘

  STANDARD PRIORITY QUEUES (SLA < 5min)
  ┌─────────────────────────────────────┐
  │ claims.assignment.routing           │  Adjuster assignment
  │ claims.estimate.processing          │  Estimate intake
  │ claims.reserve.posting              │  Reserve changes
  │ claims.notification.outbound        │  Customer notifications
  │ claims.document.classification      │  AI document classification
  └─────────────────────────────────────┘

  LOW PRIORITY QUEUES (SLA < 1hr)
  ┌─────────────────────────────────────┐
  │ claims.gl.posting                   │  General ledger entries
  │ claims.reinsurance.notification     │  Ceded loss notification
  │ claims.analytics.events             │  BI/DW feed
  │ claims.regulatory.reporting         │  Compliance data
  │ claims.search.indexing              │  Search index updates
  └─────────────────────────────────────┘

  BATCH QUEUES (SLA < 24hr)
  ┌─────────────────────────────────────┐
  │ claims.iso.statistical.reporting    │  ISO stat plan data
  │ claims.state.datacall               │  State data call files
  │ claims.1099.generation              │  IRS 1099 processing
  │ claims.archive.processing           │  Document archival
  └─────────────────────────────────────┘

  DEAD LETTER QUEUES
  ┌─────────────────────────────────────┐
  │ claims.fnol.intake.dlq              │
  │ claims.payment.authorization.dlq    │
  │ claims.gl.posting.dlq               │
  │ claims.*.dlq                        │  One DLQ per operational queue
  └─────────────────────────────────────┘
```

### 6.2 RabbitMQ Configuration

```python
# RabbitMQ Exchange and Queue Setup for Claims
import pika

connection = pika.BlockingConnection(pika.ConnectionParameters(
    host='rabbitmq.claims.internal',
    port=5671,
    virtual_host='/claims',
    credentials=pika.PlainCredentials('claims-service', 'encrypted-password'),
    ssl_options=pika.SSLOptions(ssl.create_default_context())
))

channel = connection.channel()

# Topic Exchange for claim events
channel.exchange_declare(
    exchange='claims.events',
    exchange_type='topic',
    durable=True,
    arguments={
        'alternate-exchange': 'claims.events.unrouted'
    }
)

# Direct Exchange for command messages
channel.exchange_declare(
    exchange='claims.commands',
    exchange_type='direct',
    durable=True
)

# Dead Letter Exchange
channel.exchange_declare(
    exchange='claims.dlx',
    exchange_type='fanout',
    durable=True
)

# Queue: GL Posting
channel.queue_declare(
    queue='claims.gl.posting',
    durable=True,
    arguments={
        'x-dead-letter-exchange': 'claims.dlx',
        'x-dead-letter-routing-key': 'claims.gl.posting.dlq',
        'x-message-ttl': 86400000,      # 24 hours
        'x-max-length': 100000,          # Max queue depth
        'x-max-priority': 10,
        'x-queue-type': 'quorum'         # Quorum queue for durability
    }
)

# Bind queues to exchanges
channel.queue_bind(
    exchange='claims.events',
    queue='claims.gl.posting',
    routing_key='claims.payment.#'        # All payment events
)
channel.queue_bind(
    exchange='claims.events',
    queue='claims.gl.posting',
    routing_key='claims.reserve.#'        # All reserve events
)

# Queue: Payment Processing
channel.queue_declare(
    queue='claims.payment.processing',
    durable=True,
    arguments={
        'x-dead-letter-exchange': 'claims.dlx',
        'x-dead-letter-routing-key': 'claims.payment.processing.dlq',
        'x-message-ttl': 3600000,         # 1 hour
        'x-max-length': 50000,
        'x-queue-type': 'quorum'
    }
)
```

### 6.3 AWS SQS Configuration

```json
{
  "QueueConfigurations": [
    {
      "QueueName": "claims-payment-processing",
      "Attributes": {
        "DelaySeconds": "0",
        "MaximumMessageSize": "262144",
        "MessageRetentionPeriod": "1209600",
        "VisibilityTimeout": "300",
        "ReceiveMessageWaitTimeSeconds": "20",
        "RedrivePolicy": {
          "deadLetterTargetArn": "arn:aws:sqs:us-west-2:123456789:claims-payment-dlq",
          "maxReceiveCount": 5
        },
        "SqsManagedSseEnabled": "true",
        "FifoQueue": "true",
        "ContentBasedDeduplication": "true",
        "DeduplicationScope": "messageGroup"
      },
      "Tags": {
        "Application": "Claims",
        "Environment": "Production",
        "CostCenter": "CLAIMS-IT",
        "DataClassification": "Confidential"
      }
    },
    {
      "QueueName": "claims-gl-posting.fifo",
      "Attributes": {
        "FifoQueue": "true",
        "ContentBasedDeduplication": "false",
        "DeduplicationScope": "messageGroup",
        "FifoThroughputLimit": "perMessageGroupId",
        "VisibilityTimeout": "600",
        "RedrivePolicy": {
          "deadLetterTargetArn": "arn:aws:sqs:us-west-2:123456789:claims-gl-posting-dlq.fifo",
          "maxReceiveCount": 3
        }
      }
    }
  ]
}
```

### 6.4 Azure Service Bus Configuration

```json
{
  "namespace": "claims-servicebus",
  "sku": "Premium",
  "properties": {
    "messagingUnits": 4,
    "zoneRedundant": true
  },
  "queues": [
    {
      "name": "claims-payment-processing",
      "properties": {
        "maxSizeInMegabytes": 5120,
        "requiresDuplicateDetection": true,
        "duplicateDetectionHistoryTimeWindow": "PT10M",
        "requiresSession": true,
        "deadLetteringOnMessageExpiration": true,
        "defaultMessageTimeToLive": "P14D",
        "lockDuration": "PT5M",
        "maxDeliveryCount": 5,
        "enablePartitioning": false,
        "enableBatchedOperations": true
      }
    }
  ],
  "topics": [
    {
      "name": "claim-events",
      "properties": {
        "maxSizeInMegabytes": 5120,
        "enablePartitioning": true,
        "supportOrdering": true,
        "defaultMessageTimeToLive": "P7D"
      },
      "subscriptions": [
        {
          "name": "gl-posting",
          "properties": {
            "maxDeliveryCount": 5,
            "deadLetteringOnMessageExpiration": true,
            "lockDuration": "PT5M"
          },
          "rules": [
            {
              "name": "payment-and-reserve-events",
              "filter": {
                "sqlExpression": "eventType IN ('PAYMENT_ISSUED','PAYMENT_VOIDED','RESERVE_CHANGED','RESERVE_RELEASED')"
              }
            }
          ]
        },
        {
          "name": "reinsurance-notification",
          "properties": {
            "maxDeliveryCount": 3
          },
          "rules": [
            {
              "name": "large-losses",
              "filter": {
                "sqlExpression": "totalIncurred > 250000 OR eventType = 'CLAIM_CREATED' AND lineOfBusiness = 'COMMERCIAL_PROPERTY'"
              }
            }
          ]
        }
      ]
    }
  ]
}
```

---

## 7. Synchronous vs Asynchronous Integration

### 7.1 Decision Matrix

| Scenario | Pattern | Rationale |
|---|---|---|
| Policy lookup during FNOL | **Synchronous** | Adjuster needs real-time verification |
| Coverage verification | **Synchronous** | Decision gate; cannot proceed without result |
| Fraud score check | **Synchronous** | Needed before claim proceeds |
| Payment authorization | **Synchronous** | User expects immediate confirmation |
| GL journal entry posting | **Asynchronous** | Financial system can process independently |
| Reinsurance notification | **Asynchronous** | Not time-sensitive; batch acceptable |
| Document upload to ECM | **Asynchronous** | Large payloads; decoupled storage |
| Vendor estimate assignment | **Asynchronous** | External vendor workflow is inherently async |
| Search index update | **Asynchronous** | Eventual consistency acceptable |
| State regulatory reporting | **Asynchronous** (Batch) | Monthly/quarterly cycles |
| Customer email notification | **Asynchronous** | Fire-and-forget with retry |
| Real-time dashboard update | **Event-driven** | Push-based UI updates |
| Catastrophe triage scoring | **Synchronous** | Routing decision required immediately |
| ISO statistical reporting | **Batch** | Nightly/monthly extract |

### 7.2 Synchronous Integration Patterns

```
  SYNCHRONOUS: Request-Reply
  ═══════════════════════════════════════
  
  Claims UI         Claims Service        Policy Admin
  ────────          ──────────────        ────────────
      │                   │                     │
      │  POST /fnol       │                     │
      │──────────────────▶│                     │
      │                   │  GET /policy/{num}  │
      │                   │────────────────────▶│
      │                   │                     │
      │                   │  200 OK + Policy    │
      │                   │◀────────────────────│
      │                   │                     │
      │  201 Created      │                     │
      │◀──────────────────│                     │
      │                   │                     │
  
  Total Latency = UI→Claims + Claims→PAS + Processing
  Typical: 200ms + 500ms + 300ms = ~1s

  SYNCHRONOUS WITH TIMEOUT AND FALLBACK
  ═══════════════════════════════════════

  Claims Service        Policy Admin        Cache
  ──────────────        ────────────        ─────
      │                      │                │
      │  GET /policy/{num}   │                │
      │─────────────────────▶│                │
      │                      │                │
      │  [TIMEOUT after 3s]  │                │
      │      X               │                │
      │                      │                │
      │  GET /policy/{num}   │                │
      │──────────────────────────────────────▶│
      │                      │                │
      │  200 OK (cached)     │                │
      │◀──────────────────────────────────────│
      │                      │                │
```

### 7.3 Asynchronous Integration Patterns

```
  ASYNCHRONOUS: Fire-and-Forget with Callback
  ═══════════════════════════════════════════════

  Claims Service    Message Queue    GL Service     Claims Service
  ──────────────    ─────────────    ──────────     ──────────────
      │                  │               │               │
      │  PUBLISH         │               │               │
      │  gl.posting      │               │               │
      │─────────────────▶│               │               │
      │                  │               │               │
      │  ACK             │               │               │
      │◀─────────────────│               │               │
      │                  │               │               │
      │  (Claims Service │  CONSUME      │               │
      │   continues)     │──────────────▶│               │
      │                  │               │               │
      │                  │               │  POST /callback│
      │                  │               │──────────────▶│
      │                  │               │               │
      │                  │               │  200 OK       │
      │                  │               │◀──────────────│

  ASYNCHRONOUS: Request-Reply via Correlation
  ═══════════════════════════════════════════════

  Claims Service    Request Queue    Vendor Service   Reply Queue    Claims Service
  ──────────────    ─────────────    ──────────────   ───────────    ──────────────
      │                  │                │               │               │
      │  PUBLISH         │                │               │               │
      │  correlationId=X │                │               │               │
      │─────────────────▶│                │               │               │
      │                  │  CONSUME       │               │               │
      │                  │───────────────▶│               │               │
      │                  │                │               │               │
      │                  │                │  PUBLISH      │               │
      │                  │                │  corrId=X     │               │
      │                  │                │──────────────▶│               │
      │                  │                │               │  CONSUME      │
      │                  │                │               │  corrId=X     │
      │                  │                │               │──────────────▶│
```

---

## 8. Canonical Data Model for Claims

### 8.1 The Problem

Each system in the insurance ecosystem has its own data model:

```
  Guidewire ClaimCenter    │    CCC ONE           │    SAP GL
  ─────────────────────    │    ────────           │    ──────
  Claim.ClaimNumber        │    Assignment.RefNum  │    BKPF-BELNR
  Claim.LossDate           │    Loss.DateOfLoss    │    BKPF-BUDAT
  Claim.PolicyNumber       │    Policy.PolicyNum   │    BKPF-XBLNR
  Exposure.CoverageType    │    Vehicle.CovType    │    BSEG-SAKNR
  Payment.Amount           │    Estimate.TotalAmt  │    BSEG-WRBTR
  
  Without CDM: N systems × (N-1) transformations = N(N-1) mappings
  With CDM: N systems × 2 (to/from CDM) = 2N mappings
  
  For 15 systems:
  Without CDM: 210 mappings
  With CDM:     30 mappings
```

### 8.2 Claims Canonical Data Model (CDM)

```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "title": "ClaimCanonicalModel",
  "version": "3.2.0",
  "description": "Canonical data model for PnC claims integration",
  "type": "object",
  "properties": {
    "claim": {
      "type": "object",
      "properties": {
        "claimIdentifier": {
          "type": "object",
          "properties": {
            "claimNumber": { "type": "string", "pattern": "^CLM-[0-9]{4}-[0-9]{8}$" },
            "sourceSystemId": { "type": "string" },
            "sourceSystemClaimId": { "type": "string" },
            "externalReferenceIds": {
              "type": "array",
              "items": {
                "type": "object",
                "properties": {
                  "system": { "type": "string" },
                  "referenceId": { "type": "string" },
                  "referenceType": { "type": "string" }
                }
              }
            }
          },
          "required": ["claimNumber"]
        },
        "claimStatus": {
          "type": "object",
          "properties": {
            "statusCode": {
              "type": "string",
              "enum": ["OPEN", "CLOSED", "REOPENED", "VOID"]
            },
            "subStatusCode": {
              "type": "string",
              "enum": [
                "NEW", "UNDER_INVESTIGATION", "PENDING_COVERAGE_DECISION",
                "COVERAGE_APPROVED", "COVERAGE_DENIED", "PENDING_SETTLEMENT",
                "SETTLED", "LITIGATION", "CLOSED_WITH_PAYMENT",
                "CLOSED_WITHOUT_PAYMENT", "SUBROGATION"
              ]
            },
            "statusDate": { "type": "string", "format": "date-time" },
            "statusChangedBy": { "type": "string" }
          }
        },
        "lossInformation": {
          "type": "object",
          "properties": {
            "lossDate": { "type": "string", "format": "date-time" },
            "reportDate": { "type": "string", "format": "date-time" },
            "lossDescription": { "type": "string", "maxLength": 5000 },
            "lossCauseCode": { "type": "string" },
            "lossTypeCode": { "type": "string" },
            "catastropheCode": { "type": "string" },
            "lossLocation": {
              "type": "object",
              "properties": {
                "addressLine1": { "type": "string" },
                "addressLine2": { "type": "string" },
                "city": { "type": "string" },
                "stateCode": { "type": "string", "pattern": "^[A-Z]{2}$" },
                "postalCode": { "type": "string" },
                "countryCode": { "type": "string", "default": "US" },
                "latitude": { "type": "number" },
                "longitude": { "type": "number" },
                "countyCode": { "type": "string" },
                "fipsCode": { "type": "string" }
              }
            }
          },
          "required": ["lossDate", "reportDate", "lossCauseCode"]
        },
        "policyReference": {
          "type": "object",
          "properties": {
            "policyNumber": { "type": "string" },
            "policyEffectiveDate": { "type": "string", "format": "date" },
            "policyExpirationDate": { "type": "string", "format": "date" },
            "policyType": { "type": "string" },
            "lineOfBusiness": {
              "type": "string",
              "enum": [
                "PERSONAL_AUTO", "HOMEOWNERS", "COMMERCIAL_AUTO",
                "COMMERCIAL_PROPERTY", "GENERAL_LIABILITY", "WORKERS_COMP",
                "COMMERCIAL_PACKAGE", "UMBRELLA", "BOP", "INLAND_MARINE"
              ]
            },
            "insuredName": { "type": "string" },
            "producerCode": { "type": "string" },
            "underwritingCompany": { "type": "string" }
          },
          "required": ["policyNumber", "lineOfBusiness"]
        },
        "financials": {
          "type": "object",
          "properties": {
            "currency": { "type": "string", "default": "USD" },
            "reserves": {
              "type": "array",
              "items": {
                "type": "object",
                "properties": {
                  "reserveId": { "type": "string" },
                  "exposureId": { "type": "string" },
                  "coverageType": { "type": "string" },
                  "reserveCategory": {
                    "type": "string",
                    "enum": ["INDEMNITY", "EXPENSE", "ALAE", "ULAE"]
                  },
                  "currentAmount": { "type": "number" },
                  "previousAmount": { "type": "number" },
                  "changeAmount": { "type": "number" },
                  "changeDate": { "type": "string", "format": "date-time" },
                  "changedBy": { "type": "string" },
                  "changeReason": { "type": "string" }
                }
              }
            },
            "payments": {
              "type": "array",
              "items": {
                "type": "object",
                "properties": {
                  "paymentId": { "type": "string" },
                  "paymentType": {
                    "type": "string",
                    "enum": ["INDEMNITY", "EXPENSE", "ALAE"]
                  },
                  "paymentStatus": {
                    "type": "string",
                    "enum": ["REQUESTED", "APPROVED", "ISSUED", "CLEARED", "VOIDED", "STOPPED"]
                  },
                  "amount": { "type": "number" },
                  "issueDate": { "type": "string", "format": "date" },
                  "checkNumber": { "type": "string" },
                  "paymentMethod": {
                    "type": "string",
                    "enum": ["CHECK", "ACH", "WIRE", "VIRTUAL_CARD"]
                  },
                  "payee": {
                    "type": "object",
                    "properties": {
                      "payeeId": { "type": "string" },
                      "payeeName": { "type": "string" },
                      "payeeType": {
                        "type": "string",
                        "enum": ["INSURED", "CLAIMANT", "VENDOR", "ATTORNEY", "MEDICAL_PROVIDER", "LIENHOLDER", "MORTGAGEE"]
                      },
                      "taxId": { "type": "string" },
                      "address": { "$ref": "#/definitions/Address" }
                    }
                  },
                  "exposureId": { "type": "string" },
                  "coverageType": { "type": "string" },
                  "costType": { "type": "string" },
                  "costCategory": { "type": "string" },
                  "invoice": {
                    "type": "object",
                    "properties": {
                      "invoiceNumber": { "type": "string" },
                      "invoiceDate": { "type": "string", "format": "date" },
                      "vendorId": { "type": "string" }
                    }
                  }
                }
              }
            },
            "recoveries": {
              "type": "array",
              "items": {
                "type": "object",
                "properties": {
                  "recoveryId": { "type": "string" },
                  "recoveryType": {
                    "type": "string",
                    "enum": ["SUBROGATION", "SALVAGE", "DEDUCTIBLE", "SIU", "OTHER"]
                  },
                  "amount": { "type": "number" },
                  "recoveryDate": { "type": "string", "format": "date" },
                  "sourceParty": { "type": "string" }
                }
              }
            },
            "totalIncurred": { "type": "number" },
            "totalPaid": { "type": "number" },
            "totalReserves": { "type": "number" },
            "totalRecoveries": { "type": "number" },
            "netIncurred": { "type": "number" }
          }
        },
        "parties": {
          "type": "array",
          "items": {
            "type": "object",
            "properties": {
              "partyId": { "type": "string" },
              "partyRole": {
                "type": "string",
                "enum": [
                  "INSURED", "CLAIMANT", "WITNESS", "ADJUSTER",
                  "ATTORNEY_PLAINTIFF", "ATTORNEY_DEFENSE",
                  "MEDICAL_PROVIDER", "REPAIR_SHOP", "APPRAISER",
                  "INDEPENDENT_ADJUSTER", "PUBLIC_ADJUSTER"
                ]
              },
              "partyType": { "type": "string", "enum": ["INDIVIDUAL", "ORGANIZATION"] },
              "firstName": { "type": "string" },
              "lastName": { "type": "string" },
              "organizationName": { "type": "string" },
              "taxIdentifier": { "type": "string" },
              "dateOfBirth": { "type": "string", "format": "date" },
              "contactInfo": {
                "type": "object",
                "properties": {
                  "phoneNumbers": { "type": "array", "items": { "$ref": "#/definitions/Phone" } },
                  "emailAddresses": { "type": "array", "items": { "type": "string", "format": "email" } },
                  "addresses": { "type": "array", "items": { "$ref": "#/definitions/Address" } }
                }
              }
            }
          }
        },
        "exposures": {
          "type": "array",
          "items": {
            "type": "object",
            "properties": {
              "exposureId": { "type": "string" },
              "exposureType": {
                "type": "string",
                "enum": [
                  "VEHICLE_DAMAGE", "PROPERTY_DAMAGE", "BODILY_INJURY",
                  "PIP", "MEDPAY", "UNINSURED_MOTORIST", "CONTENTS",
                  "ADDITIONAL_LIVING_EXPENSE", "GENERAL_LIABILITY",
                  "PROFESSIONAL_LIABILITY"
                ]
              },
              "coverageType": { "type": "string" },
              "claimantId": { "type": "string" },
              "status": { "type": "string" },
              "closedDate": { "type": "string", "format": "date-time" }
            }
          }
        },
        "auditTrail": {
          "type": "array",
          "items": {
            "type": "object",
            "properties": {
              "activityId": { "type": "string" },
              "activityDate": { "type": "string", "format": "date-time" },
              "activityType": { "type": "string" },
              "description": { "type": "string" },
              "userId": { "type": "string" },
              "systemSource": { "type": "string" }
            }
          }
        }
      }
    }
  }
}
```

### 8.3 ACORD Data Standards Alignment

The CDM should align with ACORD (Association for Cooperative Operations Research and Development) standards:

| CDM Field | ACORD XML Element | ACORD Standard |
|---|---|---|
| `claimNumber` | `ClaimsOccurrence/ItemIdInfo/AgencyId` | ACORD P&C Claims |
| `lossDate` | `ClaimsOccurrence/LossDt` | ACORD P&C Claims |
| `lossCauseCode` | `ClaimsOccurrence/LossCauseCd` | ACORD Code Lists |
| `policyNumber` | `Policy/PolicyNumber` | ACORD P&C Policy |
| `coverageType` | `Coverage/CoverageCd` | ACORD Code Lists |
| `paymentAmount` | `ClaimsPayment/PaymentAmt/Amt` | ACORD P&C Claims |
| `reserveAmount` | `ReserveInfo/ReserveAmt/Amt` | ACORD P&C Claims |

---

## 9. Data Transformation and Mapping

### 9.1 Transformation Pattern Categories

```
  SOURCE FORMAT    TRANSFORMATION ENGINE    TARGET FORMAT
  ─────────────    ─────────────────────    ─────────────
  JSON        ───▶                     ───▶ JSON
  XML         ───▶  ┌──────────────┐  ───▶ XML
  CSV         ───▶  │  DataWeave   │  ───▶ CSV
  Fixed-Width ───▶  │  XSLT        │  ───▶ Fixed-Width
  ACORD XML   ───▶  │  JSONata     │  ───▶ EDI X12
  HL7 FHIR    ───▶  │  MapForce    │  ───▶ Flat File
  EDI X12     ───▶  │  Custom Java │  ───▶ ACORD XML
  Avro        ───▶  │  Python      │  ───▶ Parquet
  Protobuf    ───▶  └──────────────┘  ───▶ Database
```

### 9.2 DataWeave Transformations

**Guidewire ClaimCenter → Canonical Claim:**

```dataweave
%dw 2.0
output application/json
---
{
  claim: {
    claimIdentifier: {
      claimNumber: payload.ClaimInfo.ClaimNumber,
      sourceSystemId: "GUIDEWIRE_CC",
      sourceSystemClaimId: payload.ClaimInfo.PublicID
    },
    claimStatus: {
      statusCode: payload.ClaimInfo.State match {
        case "open" -> "OPEN"
        case "closed" -> "CLOSED"
        case "draft" -> "OPEN"
        else -> "OPEN"
      },
      subStatusCode: mapGuidewireSubStatus(payload.ClaimInfo.ClaimState),
      statusDate: payload.ClaimInfo.CloseDate default payload.ClaimInfo.CreateTime
    },
    lossInformation: {
      lossDate: payload.ClaimInfo.LossDate as DateTime,
      reportDate: payload.ClaimInfo.ReportedDate as DateTime,
      lossDescription: payload.ClaimInfo.Description,
      lossCauseCode: payload.ClaimInfo.LossCause.Code,
      lossTypeCode: payload.ClaimInfo.LossType.Code,
      catastropheCode: payload.ClaimInfo.Catastrophe.CatastropheNumber default null,
      lossLocation: {
        addressLine1: payload.ClaimInfo.LossLocation.AddressLine1,
        city: payload.ClaimInfo.LossLocation.City,
        stateCode: payload.ClaimInfo.LossLocation.State.Code,
        postalCode: payload.ClaimInfo.LossLocation.PostalCode,
        countryCode: payload.ClaimInfo.LossLocation.Country.Code default "US",
        latitude: payload.ClaimInfo.LossLocation.SpatialPoint.Latitude,
        longitude: payload.ClaimInfo.LossLocation.SpatialPoint.Longitude
      }
    },
    policyReference: {
      policyNumber: payload.ClaimInfo.Policy.PolicyNumber,
      policyEffectiveDate: payload.ClaimInfo.Policy.EffectiveDate,
      policyExpirationDate: payload.ClaimInfo.Policy.ExpirationDate,
      lineOfBusiness: mapGuidewireLOB(payload.ClaimInfo.Policy.PolicyType.Code),
      insuredName: payload.ClaimInfo.Policy.Insured.DisplayName,
      producerCode: payload.ClaimInfo.Policy.ProducerCode.Code
    },
    financials: {
      reserves: payload.ClaimInfo.Exposures flatMap ((exp) ->
        exp.Reserves map ((res) -> {
          reserveId: res.PublicID,
          exposureId: exp.PublicID,
          coverageType: exp.Coverage.Type.Code,
          reserveCategory: res.CostType.Code match {
            case "claimcost" -> "INDEMNITY"
            case "aoexpense" -> "ALAE"
            else -> "EXPENSE"
          },
          currentAmount: res.PendingAmount,
          changeDate: res.ChangeDateFormatted
        })
      ),
      payments: payload.ClaimInfo.Checks flatMap ((chk) ->
        chk.Payments map ((pmt) -> {
          paymentId: pmt.PublicID,
          paymentType: pmt.CostType.Code,
          paymentStatus: chk.Status.Code upper,
          amount: pmt.Amount.Amount,
          issueDate: chk.IssueDate,
          checkNumber: chk.CheckNumber,
          paymentMethod: chk.PaymentMethod.Code match {
            case "check" -> "CHECK"
            case "eft" -> "ACH"
            case "manual" -> "CHECK"
            else -> "CHECK"
          }
        })
      ),
      totalIncurred: payload.ClaimInfo.ClaimFinancialsSummary.TotalIncurredNet.Amount default 0,
      totalPaid: payload.ClaimInfo.ClaimFinancialsSummary.TotalPayments.Amount default 0,
      totalReserves: payload.ClaimInfo.ClaimFinancialsSummary.RemainingReserves.Amount default 0
    }
  }
}
```

### 9.3 XSLT for ACORD XML Transformation

```xml
<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:acord="http://www.ACORD.org/standards/PC_Surety/ACORD1/xml/"
  xmlns:cdm="http://insurance.com/claims/cdm/v3">

  <xsl:output method="xml" indent="yes" encoding="UTF-8"/>

  <xsl:template match="/">
    <cdm:Claim>
      <cdm:ClaimIdentifier>
        <cdm:ClaimNumber>
          <xsl:value-of select="//acord:ClaimsOccurrence/acord:ItemIdInfo/acord:AgencyId"/>
        </cdm:ClaimNumber>
      </cdm:ClaimIdentifier>

      <cdm:LossInformation>
        <cdm:LossDate>
          <xsl:value-of select="//acord:ClaimsOccurrence/acord:LossDt"/>
        </cdm:LossDate>
        <cdm:LossCauseCode>
          <xsl:call-template name="mapACORDLossCause">
            <xsl:with-param name="acordCode" select="//acord:ClaimsOccurrence/acord:LossCauseCd"/>
          </xsl:call-template>
        </cdm:LossCauseCode>
        <cdm:LossLocation>
          <cdm:AddressLine1>
            <xsl:value-of select="//acord:ClaimsOccurrence/acord:Addr/acord:Addr1"/>
          </cdm:AddressLine1>
          <cdm:City>
            <xsl:value-of select="//acord:ClaimsOccurrence/acord:Addr/acord:City"/>
          </cdm:City>
          <cdm:StateCode>
            <xsl:value-of select="//acord:ClaimsOccurrence/acord:Addr/acord:StateProvCd"/>
          </cdm:StateCode>
          <cdm:PostalCode>
            <xsl:value-of select="//acord:ClaimsOccurrence/acord:Addr/acord:PostalCode"/>
          </cdm:PostalCode>
        </cdm:LossLocation>
      </cdm:LossInformation>

      <cdm:PolicyReference>
        <cdm:PolicyNumber>
          <xsl:value-of select="//acord:Policy/acord:PolicyNumber"/>
        </cdm:PolicyNumber>
        <cdm:EffectiveDate>
          <xsl:value-of select="//acord:Policy/acord:ContractTerm/acord:EffectiveDt"/>
        </cdm:EffectiveDate>
      </cdm:PolicyReference>

      <xsl:for-each select="//acord:ClaimsPayment">
        <cdm:Payment>
          <cdm:Amount>
            <xsl:value-of select="acord:PaymentAmt/acord:Amt"/>
          </cdm:Amount>
          <cdm:PaymentDate>
            <xsl:value-of select="acord:PaymentDt"/>
          </cdm:PaymentDate>
        </cdm:Payment>
      </xsl:for-each>
    </cdm:Claim>
  </xsl:template>

  <xsl:template name="mapACORDLossCause">
    <xsl:param name="acordCode"/>
    <xsl:choose>
      <xsl:when test="$acordCode = 'COLL'">COLLISION</xsl:when>
      <xsl:when test="$acordCode = 'COMP'">COMPREHENSIVE</xsl:when>
      <xsl:when test="$acordCode = 'FIRE'">FIRE</xsl:when>
      <xsl:when test="$acordCode = 'THFT'">THEFT</xsl:when>
      <xsl:when test="$acordCode = 'WIND'">WINDSTORM</xsl:when>
      <xsl:when test="$acordCode = 'HAIL'">HAIL</xsl:when>
      <xsl:when test="$acordCode = 'WATR'">WATER_DAMAGE</xsl:when>
      <xsl:otherwise>OTHER</xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
```

---

## 10. Policy Administration System Integration

### 10.1 Integration Points with PAS

```
  CLAIMS SYSTEM                          POLICY ADMIN SYSTEM
  ═════════════                          ═══════════════════

  FNOL Intake ──────── Policy Lookup ──────────▶ Policy Search API
              ◀──────── Policy Data ──────────── (policy snapshot)

  Coverage    ──────── Verify Coverage ────────▶ Coverage API
  Verification◀──────── Coverage Details ──────── (limits, deductibles)

  Reserve     ──────── Check Policy Limits ────▶ Limits API
  Setting     ◀──────── Available Limits ──────── (remaining limits)

  Payment     ──────── Deductible Lookup ──────▶ Deductible API
  Processing  ◀──────── Deductible Amount ─────── (per-occurrence/aggregate)

  Subrogation ──────── Named Insured ──────────▶ Insured Lookup API
              ◀──────── Insured Details ────────── (contact info)

  Claim       ──────── Claim Notification ─────▶ Policy Activity API
  Lifecycle   ──────── (open, close, reopen) ──── (update policy record)
```

### 10.2 Guidewire PolicyCenter Integration

```
  ┌─────────────────┐                    ┌─────────────────┐
  │ Guidewire       │                    │ Guidewire       │
  │ ClaimCenter     │                    │ PolicyCenter    │
  │                 │  Cloud API (REST)  │                 │
  │  Claim FNOL ────│───────────────────▶│  Policy Search  │
  │                 │  GET /policies     │                 │
  │                 │  ?number={num}     │                 │
  │                 │                    │                 │
  │                 │  200 OK            │                 │
  │  Policy Data ◀──│────────────────────│  Policy Snapshot│
  │                 │                    │                 │
  │  Coverage ──────│───────────────────▶│  Coverage       │
  │  Verify         │  GET /policies/    │  Details        │
  │                 │  {id}/coverages    │                 │
  │                 │                    │                 │
  └─────────────────┘                    └─────────────────┘

  Integration Methods:
  1. Guidewire Cloud API (REST) - Preferred for cloud deployments
  2. Guidewire Integration Gateway - SOAP/REST adapter
  3. Messaging (GW Messaging) - Event-based
  4. Database-level (not recommended) - Direct DB queries
```

**Guidewire Cloud API Policy Lookup:**

```http
GET /policy/v1/policies?filter=policyNumber eq 'POL-CA-20250001'
    &fields=policyNumber,effectiveDate,expirationDate,status,
            product,insured,coverages,deductibles
Host: policycenter.guidewire.cloud
Authorization: Bearer eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9...
Accept: application/json
X-Correlation-ID: CLM-2025-00001234
X-Request-Source: ClaimCenter
```

**Response:**

```json
{
  "data": {
    "attributes": {
      "policyNumber": "POL-CA-20250001",
      "effectiveDate": "2025-01-15",
      "expirationDate": "2026-01-15",
      "status": {
        "code": "InForce",
        "name": "In Force"
      },
      "product": {
        "code": "PersonalAutoLine",
        "name": "Personal Auto"
      },
      "insured": {
        "displayName": "John A. Smith",
        "firstName": "John",
        "lastName": "Smith",
        "dateOfBirth": "1985-03-22",
        "address": {
          "addressLine1": "123 Main St",
          "city": "Los Angeles",
          "state": "CA",
          "postalCode": "90001"
        }
      },
      "vehicles": [
        {
          "vin": "1HGBH41JXMN109186",
          "year": 2023,
          "make": "Honda",
          "model": "Accord",
          "bodyType": "Sedan",
          "garageLocation": {
            "state": "CA",
            "postalCode": "90001"
          },
          "coverages": [
            {
              "coverageCode": "PALiabBICov",
              "coverageName": "Bodily Injury Liability",
              "perPersonLimit": 100000,
              "perAccidentLimit": 300000,
              "deductible": 0
            },
            {
              "coverageCode": "PALiabPDCov",
              "coverageName": "Property Damage Liability",
              "perAccidentLimit": 100000,
              "deductible": 0
            },
            {
              "coverageCode": "PACollisionCov",
              "coverageName": "Collision",
              "perAccidentLimit": null,
              "deductible": 500
            },
            {
              "coverageCode": "PAComprehensiveCov",
              "coverageName": "Comprehensive",
              "perAccidentLimit": null,
              "deductible": 250
            }
          ]
        }
      ]
    }
  }
}
```

### 10.3 Duck Creek Integration

```
  Duck Creek OnDemand Integration
  ═══════════════════════════════

  Claims System            Duck Creek Gateway           Duck Creek Policy
  ────────────             ──────────────────           ────────────────
      │                         │                            │
      │  POST /api/v2/          │                            │
      │  policy/search          │                            │
      │────────────────────────▶│                            │
      │                         │  Internal Service Call     │
      │                         │───────────────────────────▶│
      │                         │                            │
      │                         │  Policy + Coverages        │
      │                         │◀───────────────────────────│
      │                         │                            │
      │  200 OK                 │                            │
      │  (Duck Creek JSON)      │                            │
      │◀────────────────────────│                            │
      │                         │                            │

  Duck Creek uses:
  - REST API Gateway for real-time
  - Message-based (Azure Service Bus) for async
  - SSIS/ADF for batch data exchange
```

---

## 11. Billing System Integration

### 11.1 Claims-to-Billing Integration Points

| Integration Point | Direction | Trigger | Data Exchanged |
|---|---|---|---|
| Premium verification | Claims → Billing | FNOL | Account status, payment status |
| Subrogation recovery posting | Claims → Billing | Recovery received | Recovery amount, source |
| Deductible billing | Claims → Billing | Deductible collected | Deductible amount, insured account |
| Claim payment offset | Claims → Billing | Payment issued | Offset against premium balance |
| Return premium for cancelled policy | Billing → Claims | Policy cancellation | Earned/unearned premium |
| Installment plan suspension | Claims → Billing | Large claim on account | Suspension request |
| Reinstatement after claim | Claims → Billing | Claim resolution | Policy reinstatement |

### 11.2 Payment Integration Flow

```
  CLAIMS PAYMENT LIFECYCLE WITH BILLING
  ═════════════════════════════════════════

  Claims Service    Payment Service    Billing System    Bank/ACH
  ──────────────    ───────────────    ──────────────    ────────
      │                  │                  │               │
      │ Request Payment  │                  │               │
      │─────────────────▶│                  │               │
      │                  │                  │               │
      │                  │ Check offsets    │               │
      │                  │─────────────────▶│               │
      │                  │                  │               │
      │                  │ Offset amount   │               │
      │                  │◀─────────────────│               │
      │                  │                  │               │
      │                  │ Net Payment      │               │
      │                  │─────────────────────────────────▶│
      │                  │                  │               │
      │                  │ Confirmation     │               │
      │                  │◀─────────────────────────────────│
      │                  │                  │               │
      │                  │ Post payment     │               │
      │                  │─────────────────▶│               │
      │                  │                  │               │
      │ Payment Issued   │                  │               │
      │◀─────────────────│                  │               │
```

---

## 12. Reinsurance System Integration

### 12.1 Treaty and Facultative Reinsurance Data Flow

```
  CLAIMS SYSTEM                    REINSURANCE SYSTEM
  ═════════════                    ══════════════════

  TREATY REINSURANCE (automated):
  ┌─────────────┐                  ┌─────────────────┐
  │ Claim Event │  reserve.set     │ Treaty Engine   │
  │ (Reserve    │─────────────────▶│                 │
  │  Change)    │                  │ Apply treaties: │
  │             │                  │ - Quota Share   │
  │             │                  │ - Excess of Loss│
  │             │                  │ - Stop Loss     │
  │             │  ceded amounts   │                 │
  │             │◀─────────────────│ Calculate ceded │
  └─────────────┘                  │ and retained    │
                                   └─────────────────┘

  FACULTATIVE REINSURANCE (manual notification):
  ┌─────────────┐                  ┌─────────────────┐
  │ Large Claim │  threshold       │ Fac Placement   │
  │ Alert       │  exceeded        │                 │
  │ (>$500K)    │─────────────────▶│ - Notify broker │
  │             │                  │ - Request quote │
  │             │                  │ - Bind coverage │
  │             │  fac certificate │                 │
  │             │◀─────────────────│ Return terms    │
  └─────────────┘                  └─────────────────┘
```

### 12.2 Reinsurance Data Payload

```json
{
  "reinsuranceNotification": {
    "notificationType": "RESERVE_CHANGE",
    "claimNumber": "CLM-2025-00001234",
    "policyNumber": "POL-CA-20250001",
    "lineOfBusiness": "COMMERCIAL_PROPERTY",
    "lossDate": "2025-03-01",
    "catastropheCode": "CAT-2025-003",
    "grossReserve": {
      "indemnity": 2500000.00,
      "expense": 350000.00,
      "total": 2850000.00
    },
    "applicableTreaties": [
      {
        "treatyId": "QS-2025-001",
        "treatyType": "QUOTA_SHARE",
        "cessionPercentage": 30.0,
        "cededIndemnity": 750000.00,
        "cededExpense": 105000.00,
        "retainedIndemnity": 1750000.00,
        "retainedExpense": 245000.00
      },
      {
        "treatyId": "XOL-2025-001",
        "treatyType": "EXCESS_OF_LOSS",
        "retentionAmount": 1000000.00,
        "limitAmount": 5000000.00,
        "cededAmount": 850000.00,
        "layerExhausted": false
      }
    ],
    "netRetained": {
      "indemnity": 900000.00,
      "expense": 140000.00,
      "total": 1040000.00
    }
  }
}
```

---

## 13. General Ledger and ERP Integration

### 13.1 Claims GL Posting Rules

| Claim Event | Debit Account | Credit Account | Amount |
|---|---|---|---|
| Reserve Set (Indemnity) | Loss Reserve Expense (6100) | Loss Reserve Liability (3100) | Reserve Amount |
| Reserve Increase | Loss Reserve Expense (6100) | Loss Reserve Liability (3100) | Increase Amount |
| Reserve Decrease | Loss Reserve Liability (3100) | Loss Reserve Expense (6100) | Decrease Amount |
| Payment Issued | Loss Reserve Liability (3100) | Cash/Bank (1010) | Payment Amount |
| ALAE Reserve Set | LAE Expense (6200) | LAE Reserve Liability (3200) | Reserve Amount |
| ALAE Payment | LAE Reserve Liability (3200) | Cash/Bank (1010) | Payment Amount |
| Subrogation Recovery | Cash/Bank (1010) | Subrogation Recovery (4100) | Recovery Amount |
| Salvage Recovery | Cash/Bank (1010) | Salvage Recovery (4200) | Recovery Amount |
| Reserve Release (Close) | Loss Reserve Liability (3100) | Loss Reserve Expense (6100) | Remaining Reserve |

### 13.2 SAP Integration

```
  SAP GL POSTING INTEGRATION
  ════════════════════════════

  Claims System         MuleSoft ESB              SAP ERP
  ──────────────        ────────────              ───────
      │                      │                       │
      │  GL Posting Event    │                       │
      │─────────────────────▶│                       │
      │                      │                       │
      │                      │  Transform to         │
      │                      │  BAPI Format           │
      │                      │                       │
      │                      │  RFC Call:             │
      │                      │  BAPI_ACC_DOCUMENT_POST│
      │                      │──────────────────────▶│
      │                      │                       │
      │                      │  Document Number      │
      │                      │◀──────────────────────│
      │                      │                       │
      │  Posting Confirmed   │                       │
      │◀─────────────────────│                       │
```

**SAP BAPI Payload:**

```json
{
  "DOCUMENTHEADER": {
    "OBJ_TYPE": "BKPFF",
    "OBJ_KEY": "CLM-2025-00001234",
    "BUS_ACT": "RFBU",
    "USERNAME": "CLAIMS_SVC",
    "COMP_CODE": "1000",
    "DOC_DATE": "2025-03-15",
    "PSTNG_DATE": "2025-03-15",
    "DOC_TYPE": "SA",
    "REF_DOC_NO": "CLM-2025-00001234",
    "HEADER_TXT": "Claim Payment - CLM-2025-00001234"
  },
  "ACCOUNTGL": [
    {
      "ITEMNO_ACC": "001",
      "GL_ACCOUNT": "0061001010",
      "COMP_CODE": "1000",
      "PSTNG_DATE": "2025-03-15",
      "DOC_TYPE": "SA",
      "PROFIT_CTR": "PC-WEST-01",
      "COSTCENTER": "CC-CLAIMS-AUTO",
      "FUNC_AREA": "1100"
    },
    {
      "ITEMNO_ACC": "002",
      "GL_ACCOUNT": "0010100010",
      "COMP_CODE": "1000",
      "PSTNG_DATE": "2025-03-15",
      "DOC_TYPE": "SA",
      "PROFIT_CTR": "PC-CORP"
    }
  ],
  "CURRENCYAMOUNT": [
    {
      "ITEMNO_ACC": "001",
      "CURRENCY": "USD",
      "AMT_DOCCUR": 15000.00
    },
    {
      "ITEMNO_ACC": "002",
      "CURRENCY": "USD",
      "AMT_DOCCUR": -15000.00
    }
  ]
}
```

### 13.3 Oracle Financials Integration

```sql
-- Oracle GL Interface Table Population
INSERT INTO GL_INTERFACE (
  STATUS, SET_OF_BOOKS_ID, ACCOUNTING_DATE, CURRENCY_CODE,
  DATE_CREATED, CREATED_BY, ACTUAL_FLAG,
  USER_JE_CATEGORY_NAME, USER_JE_SOURCE_NAME,
  SEGMENT1, SEGMENT2, SEGMENT3, SEGMENT4,
  ENTERED_DR, ENTERED_CR,
  REFERENCE1, REFERENCE2, REFERENCE4, REFERENCE5
) VALUES (
  'NEW',              -- Status: NEW for unprocessed
  1,                  -- Set of Books ID
  TO_DATE('2025-03-15', 'YYYY-MM-DD'),
  'USD',
  SYSDATE,
  'CLAIMS_INTERFACE',
  'A',                -- Actual (not budget)
  'Claims',           -- Journal Category
  'Claims System',    -- Journal Source
  '1000',             -- Company
  '6100',             -- Account (Loss Reserve Expense)
  '1010',             -- Cost Center (Personal Auto)
  'CA',               -- State
  15000.00,           -- Debit Amount
  NULL,               -- Credit Amount
  'CLM-2025-00001234',   -- Claim Number
  'PAY-2025-00005678',   -- Payment ID
  'Claim Payment - Personal Auto Collision',
  'BATCH-2025-03-15-001'
);
```

---

## 14. Document Management System Integration

### 14.1 ECM Integration Architecture

```
  CLAIMS SYSTEM                  ECM SYSTEM
  ═════════════                  ══════════

  Document Upload:
  ┌──────────┐    multipart/    ┌──────────────┐
  │ Claims   │    form-data     │              │
  │ UI/API   │─────────────────▶│  OnBase /    │
  │          │                  │  FileNet /   │
  │          │  documentId      │  Alfresco    │
  │          │◀─────────────────│              │
  └──────────┘                  └──────────────┘

  Document Retrieval:
  ┌──────────┐    GET /docs/    ┌──────────────┐
  │ Claims   │    {docId}       │              │
  │ UI/API   │─────────────────▶│  ECM System  │
  │          │                  │              │
  │          │  binary stream   │              │
  │          │◀─────────────────│              │
  └──────────┘                  └──────────────┘

  Document Search:
  ┌──────────┐   query by       ┌──────────────┐
  │ Claims   │   claimNumber    │              │
  │ UI/API   │─────────────────▶│  ECM System  │
  │          │                  │              │
  │          │  document list   │              │
  │          │◀─────────────────│              │
  └──────────┘                  └──────────────┘
```

### 14.2 Document Metadata Schema

```json
{
  "documentMetadata": {
    "documentId": "DOC-2025-00012345",
    "claimNumber": "CLM-2025-00001234",
    "exposureId": "EXP-001",
    "documentType": {
      "code": "POLICE_REPORT",
      "category": "INVESTIGATION",
      "subCategory": "LAW_ENFORCEMENT"
    },
    "documentTypeHierarchy": [
      "CLAIM_DOCUMENT",
      "INVESTIGATION",
      "LAW_ENFORCEMENT",
      "POLICE_REPORT"
    ],
    "fileName": "police_report_CLM-2025-00001234.pdf",
    "mimeType": "application/pdf",
    "fileSizeBytes": 1548792,
    "pageCount": 5,
    "uploadDate": "2025-03-16T09:30:00Z",
    "uploadedBy": "adjuster.jsmith",
    "source": "MANUAL_UPLOAD",
    "securityClassification": "CONFIDENTIAL",
    "retentionPolicy": {
      "retentionPeriod": "P10Y",
      "dispositionAction": "DESTROY",
      "legalHold": false
    },
    "ocrCompleted": true,
    "aiClassificationConfidence": 0.95,
    "searchableText": true,
    "linkedDocuments": [
      { "documentId": "DOC-2025-00012340", "relationship": "SUPERSEDES" }
    ],
    "customProperties": {
      "reportNumber": "PD-2025-00456",
      "officerName": "Ofc. Martinez",
      "jurisdiction": "LAPD Pacific Division"
    }
  }
}
```

### 14.3 Document Type Taxonomy

| Category | Document Type Code | Description | Retention |
|---|---|---|---|
| FNOL | FNOL_FORM | First Notice of Loss form | 10 years |
| FNOL | RECORDED_STATEMENT | Audio/transcript of statement | 10 years |
| INVESTIGATION | POLICE_REPORT | Law enforcement report | 10 years |
| INVESTIGATION | WITNESS_STATEMENT | Witness statement | 10 years |
| INVESTIGATION | SCENE_PHOTOS | Photos of loss scene | 10 years |
| MEDICAL | MEDICAL_RECORDS | Treatment records | 10 years + |
| MEDICAL | MEDICAL_BILLS | Provider invoices | 10 years |
| MEDICAL | IME_REPORT | Independent medical exam | 10 years |
| ESTIMATE | DAMAGE_ESTIMATE | Repair/replacement estimate | 7 years |
| ESTIMATE | SUPPLEMENT | Supplemental estimate | 7 years |
| FINANCIAL | CHECK_IMAGE | Payment check image | 7 years |
| FINANCIAL | INVOICE | Vendor invoice | 7 years |
| LEGAL | DEMAND_LETTER | Attorney demand | Litigation + 7 years |
| LEGAL | COMPLAINT | Filed lawsuit | Litigation + 7 years |
| LEGAL | SETTLEMENT_AGREEMENT | Signed settlement | Permanent |
| CORRESPONDENCE | DENIAL_LETTER | Coverage denial letter | 10 years |
| CORRESPONDENCE | RESERVATION_OF_RIGHTS | ROR letter | 10 years |
| REGULATORY | DOI_COMPLAINT | Dept of Insurance complaint | 10 years |

---

## 15. External Data Provider Integration

### 15.1 ISO ClaimSearch Integration

```
  ISO CLAIMSEARCH INTEGRATION
  ═══════════════════════════

  Claims System          ISO Gateway            ISO ClaimSearch
  ──────────────         ───────────            ──────────────
      │                       │                       │
      │  FNOL Created         │                       │
      │───────────────────────│                       │
      │                       │                       │
      │  Submit Claim Report  │                       │
      │  (ACORD XML)          │                       │
      │──────────────────────▶│                       │
      │                       │  Forward to ISO       │
      │                       │──────────────────────▶│
      │                       │                       │
      │                       │  Match Response       │
      │                       │◀──────────────────────│
      │                       │                       │
      │  Match Results        │                       │
      │◀──────────────────────│                       │
      │                       │                       │
      │  Claim Report         │                       │
      │  (if requested)       │                       │
      │◀──────────────────────│                       │
      │                       │                       │

  Frequency: Real-time (per FNOL) + nightly batch for updates
  Protocol: SOAP/XML (legacy) or REST/JSON (new)
  Authentication: Certificate-based (mTLS)
```

### 15.2 LexisNexis Integration

```json
{
  "lexisNexisRequest": {
    "requestType": "CLAIMS_DISCOVERY",
    "searchCriteria": {
      "subject": {
        "firstName": "John",
        "lastName": "Smith",
        "dateOfBirth": "1985-03-22",
        "ssn": "XXX-XX-1234",
        "address": {
          "street": "123 Main St",
          "city": "Los Angeles",
          "state": "CA",
          "zip": "90001"
        }
      },
      "vehicle": {
        "vin": "1HGBH41JXMN109186",
        "year": 2023,
        "make": "Honda",
        "model": "Accord"
      },
      "searchParameters": {
        "includeClaimHistory": true,
        "includeMVR": true,
        "includeCLUE": true,
        "includePropertyHistory": true,
        "yearsBack": 7
      }
    }
  }
}
```

### 15.3 Weather Data Integration

```
  WEATHER DATA FOR CLAIMS VALIDATION
  ═══════════════════════════════════

  Use Cases:
  1. Validate hail claims against actual weather events
  2. Verify flood claims with precipitation data
  3. Confirm wind damage with wind speed records
  4. Support/refute date-of-loss for weather events

  Providers:
  ┌──────────────────────────────────────────────────────┐
  │ Provider          │ Data Type      │ Integration     │
  ├──────────────────────────────────────────────────────┤
  │ DTN/WeatherOps    │ Forensic wx    │ REST API        │
  │ CoreLogic Weather │ Hail/wind maps │ REST API + File │
  │ Verisk Aerial     │ Aerial imagery │ REST API        │
  │ NOAA              │ Historical wx  │ REST API (free) │
  │ AccuWeather       │ Forecast/hist  │ REST API        │
  └──────────────────────────────────────────────────────┘
```

### 15.4 External Data Provider Summary

| Provider | Data | Protocol | Auth | Latency | Cost Model |
|---|---|---|---|---|---|
| ISO ClaimSearch | Claim history matching | SOAP/REST | mTLS | 2-5s | Per-search |
| LexisNexis | Claims discovery, MVR, CLUE | REST | OAuth2 | 3-10s | Per-report |
| CLUE (LexisNexis) | Claims history | REST | OAuth2 | 3-5s | Per-report |
| Verisk/ISO | Property data, risk scoring | REST | API Key | 2-5s | Subscription |
| DTN WeatherOps | Forensic weather | REST | API Key | 1-3s | Per-query |
| CoreLogic | Property data, aerial imagery | REST | OAuth2 | 5-15s | Subscription |
| Verisk Aerial | Pre/post-loss aerial imagery | REST | OAuth2 | 10-30s | Per-image |
| OFAC/SDN | Sanctions screening | REST/File | API Key | < 1s | Free/Subscription |
| NICB | Theft/fraud database | SOAP | mTLS | 2-5s | Membership |
| Dun & Bradstreet | Business verification | REST | OAuth2 | 2-5s | Per-lookup |

---

## 16. Vendor Platform Integration

### 16.1 Auto Estimatics Integration (CCC ONE)

```
  CCC ONE INTEGRATION FLOW
  ════════════════════════

  Claims System            CCC Secure Share          CCC ONE
  ──────────────           ────────────────          ───────
      │                         │                       │
      │  Create Assignment      │                       │
      │  (BMS/XML or REST)      │                       │
      │────────────────────────▶│                       │
      │                         │  Route to Appraiser  │
      │                         │──────────────────────▶│
      │                         │                       │
      │                         │  [Appraiser inspects] │
      │                         │  [Writes estimate]    │
      │                         │                       │
      │                         │  Estimate Complete    │
      │                         │◀──────────────────────│
      │  EMS/BMS XML            │                       │
      │  (Estimate Data)        │                       │
      │◀────────────────────────│                       │
      │                         │                       │
      │  Photos + Documents     │                       │
      │◀────────────────────────│                       │
      │                         │                       │
      │  Supplement Request     │                       │
      │────────────────────────▶│                       │
      │                         │──────────────────────▶│
      │                         │                       │

  Data Formats:
  - BMS (Business Message Specification) XML
  - EMS (Estimate Management Standard) XML
  - CIECA (Collision Industry Electronic Commerce Association) standards
  - Photos: JPEG with EXIF metadata
```

### 16.2 CCC Assignment Payload

```xml
<?xml version="1.0" encoding="UTF-8"?>
<BMS xmlns="http://www.cieca.com/BMS">
  <AssignmentAddRq>
    <RqUID>ASN-2025-00009876</RqUID>
    <TransactionDt>2025-03-16</TransactionDt>
    <ClaimInfo>
      <ClaimNum>CLM-2025-00001234</ClaimNum>
      <LossDt>2025-03-14</LossDt>
      <LossDesc>Rear-end collision at intersection</LossDesc>
      <LossType>Collision</LossType>
    </ClaimInfo>
    <PolicyInfo>
      <PolicyNum>POL-CA-20250001</PolicyNum>
      <PolicyType>PersonalAuto</PolicyType>
      <InsuredName>John A. Smith</InsuredName>
      <DeductibleAmt>500.00</DeductibleAmt>
      <CoverageType>Collision</CoverageType>
    </PolicyInfo>
    <VehicleInfo>
      <VIN>1HGBH41JXMN109186</VIN>
      <Year>2023</Year>
      <Make>Honda</Make>
      <Model>Accord</Model>
      <BodyStyle>Sedan</BodyStyle>
      <Color>Silver</Color>
      <Mileage>28500</Mileage>
      <PreAccidentCondition>Good</PreAccidentCondition>
      <DamageDescription>
        <PrimaryDamageArea>RearEnd</PrimaryDamageArea>
        <SecondaryDamageArea>Trunk</SecondaryDamageArea>
        <SeverityLevel>Moderate</SeverityLevel>
        <Driveable>Yes</Driveable>
      </DamageDescription>
    </VehicleInfo>
    <OwnerInfo>
      <Name>John A. Smith</Name>
      <Phone>310-555-1234</Phone>
      <Email>jsmith@email.com</Email>
      <Address>
        <Street>123 Main St</Street>
        <City>Los Angeles</City>
        <State>CA</State>
        <Zip>90001</Zip>
      </Address>
    </OwnerInfo>
    <AssignmentInfo>
      <AssignmentType>FieldInspection</AssignmentType>
      <InspectionLocation>
        <LocationType>OwnerResidence</LocationType>
      </InspectionLocation>
      <Priority>Standard</Priority>
      <TargetCompletionDt>2025-03-19</TargetCompletionDt>
    </AssignmentInfo>
  </AssignmentAddRq>
</BMS>
```

### 16.3 Xactimate Integration (Property Estimation)

```json
{
  "xactimateAssignment": {
    "assignmentId": "XA-2025-00006789",
    "claimNumber": "CLM-2025-00002345",
    "policyNumber": "POL-FL-20250002",
    "insuredInfo": {
      "name": "Jane Rodriguez",
      "phone": "305-555-6789",
      "email": "jrodriguez@email.com"
    },
    "propertyInfo": {
      "address": "456 Oak Avenue, Miami, FL 33101",
      "propertyType": "SingleFamily",
      "yearBuilt": 2005,
      "squareFootage": 2400,
      "stories": 2,
      "roofType": "Hip",
      "roofMaterial": "AsphaltShingle",
      "constructionType": "CBS"
    },
    "lossInfo": {
      "lossDate": "2025-03-10",
      "perilType": "Wind",
      "catastropheId": "CAT-2025-003",
      "damageDescription": "Hurricane wind damage to roof and water intrusion"
    },
    "coverageInfo": {
      "coverageA": 450000.00,
      "coverageB": 45000.00,
      "coverageC": 225000.00,
      "coverageD": 90000.00,
      "deductible": 11250.00,
      "deductibleType": "Hurricane",
      "deductiblePercentage": 2.5
    },
    "assignmentType": "INITIAL_INSPECTION",
    "priority": "HIGH",
    "targetCompletionDate": "2025-03-13"
  }
}
```

### 16.4 Salvage Auction Integration (Copart / IAA)

```json
{
  "salvageAssignment": {
    "assignmentId": "SAL-2025-00003456",
    "claimNumber": "CLM-2025-00001234",
    "vehicleInfo": {
      "vin": "1HGBH41JXMN109186",
      "year": 2023,
      "make": "Honda",
      "model": "Accord",
      "trim": "EX-L",
      "color": "Silver",
      "mileage": 28500,
      "titleState": "CA",
      "titleType": "SALVAGE",
      "keyAvailable": true,
      "driveable": false
    },
    "pickupLocation": {
      "locationType": "REPAIR_SHOP",
      "name": "ABC Body Shop",
      "address": "789 Industrial Blvd, Los Angeles, CA 90015",
      "contactName": "Mike Johnson",
      "contactPhone": "310-555-9876"
    },
    "financialInfo": {
      "acv": 28500.00,
      "settlementAmount": 27000.00,
      "deductible": 500.00,
      "netPayment": 26500.00,
      "estimatedSalvageValue": 8500.00,
      "minimumBid": 7000.00
    },
    "titleInfo": {
      "titleReceived": false,
      "titleLocation": "LIENHOLDER",
      "lienholderName": "Chase Auto Finance",
      "lienholderAddress": "PO Box 15298, Wilmington, DE 19850"
    },
    "pickupInstructions": "Vehicle at rear lot, key in office. Contact Mike.",
    "auctionPreferences": {
      "preferredAuction": "COPART",
      "yardLocation": "COPART_LOS_ANGELES",
      "holdDays": 14,
      "auctionType": "ONLINE"
    }
  }
}
```

---

## 17. Healthcare System Integration

### 17.1 HL7 FHIR for Injury Claims

```
  INJURY CLAIM HEALTHCARE INTEGRATION
  ═══════════════════════════════════

  Claims System         FHIR Gateway          Provider EHR
  ──────────────        ────────────          ────────────
      │                      │                     │
      │  Request Medical     │                     │
      │  Records             │                     │
      │─────────────────────▶│                     │
      │                      │  FHIR Patient/$match│
      │                      │────────────────────▶│
      │                      │                     │
      │                      │  Patient Bundle     │
      │                      │◀────────────────────│
      │                      │                     │
      │                      │  GET /Condition     │
      │                      │  ?patient={id}      │
      │                      │────────────────────▶│
      │                      │                     │
      │                      │  Condition Bundle   │
      │                      │◀────────────────────│
      │                      │                     │
      │  Structured Medical  │                     │
      │  Data                │                     │
      │◀─────────────────────│                     │
```

### 17.2 X12 EDI for Medical Bills (837/835)

```
  MEDICAL BILL PROCESSING VIA EDI
  ═══════════════════════════════

  Medical Provider    Clearinghouse    Claims System    Provider
  ────────────────    ─────────────    ──────────────   ────────
      │                    │                │              │
      │  837P (Claim)      │                │              │
      │───────────────────▶│                │              │
      │                    │  Forward 837   │              │
      │                    │───────────────▶│              │
      │                    │                │              │
      │                    │                │  Process     │
      │                    │                │  Review      │
      │                    │                │  Adjudicate  │
      │                    │                │              │
      │                    │  835 (Payment) │              │
      │                    │◀───────────────│              │
      │  835 (ERA)         │                │              │
      │◀───────────────────│                │              │

  X12 Transaction Sets:
  837P - Professional Claim
  837I - Institutional Claim
  835  - Payment/Remittance Advice
  277  - Claim Status Response
  276  - Claim Status Request
```

**Sample 837P Segment:**

```
ISA*00*          *00*          *ZZ*SENDERPROD     *ZZ*RECEIVERPROD   *250316*1430*^*00501*000000001*0*P*:~
GS*HC*SENDERPROD*RECEIVERPROD*20250316*1430*1*X*005010X222A1~
ST*837*0001*005010X222A1~
BHT*0019*00*CLM20250001234*20250316*1430*CH~
NM1*41*2*ABC MEDICAL GROUP*****46*1234567890~
NM1*40*2*INSURANCE CARRIER*****46*9876543210~
HL*1**20*1~
NM1*85*2*ABC MEDICAL GROUP*****XX*1234567893~
HL*2*1*22*0~
SBR*P*18*GROUP001******CI~
NM1*IL*1*SMITH*JOHN*A***MI*POL-CA-20250001~
CLM*CLM-2025-00001234*1500***11:B:1*Y*A*Y*Y~
DTP*431*D8*20250314~
DTP*472*D8*20250316~
SV1*HC:99213*150*UN*1***1~
SV1*HC:72148*850*UN*1***2~
SV1*HC:97110*500*UN*4***3~
SE*20*0001~
GE*1*1~
IEA*1*000000001~
```

---

## 18. State Regulatory System Integration

### 18.1 Regulatory Filing Systems

| System | Purpose | Frequency | Format | States |
|---|---|---|---|---|
| NAIC SERFF | Rate/form filings | As needed | Proprietary | All 50 states |
| State DOI Portals | Complaint response | Per-complaint | Various | Per-state |
| NAIC Market Conduct | Exam data requests | Per-exam | Excel/CSV | Per-state |
| ISO Statistical Agent | Statistical reporting | Monthly/Quarterly | ISO formats | Most states |
| NCCI | Workers comp data | Quarterly | NCCI formats | 38 states |
| AAIS | Stat reporting | Monthly | AAIS formats | Some states |
| State Data Calls | Ad-hoc data requests | As required | Excel/CSV/XML | Per-state |

### 18.2 State Filing Integration Architecture

```
  REGULATORY REPORTING ARCHITECTURE
  ═════════════════════════════════

  Claims DW     Reporting Engine    File Generation    Transmission
  ─────────     ────────────────    ───────────────    ────────────
      │               │                   │                │
      │  Extract      │                   │                │
      │  Claims Data  │                   │                │
      │──────────────▶│                   │                │
      │               │                   │                │
      │               │  Apply State      │                │
      │               │  Rules Engine     │                │
      │               │                   │                │
      │               │  Generate Files   │                │
      │               │──────────────────▶│                │
      │               │                   │                │
      │               │                   │  SFTP to       │
      │               │                   │  State DOI     │
      │               │                   │───────────────▶│
      │               │                   │                │
      │               │                   │  Upload to     │
      │               │                   │  NAIC Portal   │
      │               │                   │───────────────▶│
      │               │                   │                │
      │               │                   │  Confirmation  │
      │               │                   │◀───────────────│
```

---

## 19. OFAC and Sanctions Screening Integration

### 19.1 OFAC Screening in Claims

```
  OFAC SCREENING FLOW
  ═══════════════════

  Trigger Points:
  1. New Claimant added to claim
  2. Payment requested (every payee)
  3. New vendor/provider added
  4. Periodic batch re-screening

  Claims Service       OFAC Screening       SDN Database
  ──────────────       ──────────────       ────────────
      │                     │                    │
      │  Screen Payee       │                    │
      │  {name, address,    │                    │
      │   country, DOB}     │                    │
      │────────────────────▶│                    │
      │                     │  Fuzzy Match       │
      │                     │  (Soundex, Edit    │
      │                     │   Distance, etc.)  │
      │                     │───────────────────▶│
      │                     │                    │
      │                     │  Match Results     │
      │                     │◀───────────────────│
      │                     │                    │
      │  Result:            │                    │
      │  NO_MATCH /         │                    │
      │  POTENTIAL_MATCH /  │                    │
      │  CONFIRMED_MATCH    │                    │
      │◀────────────────────│                    │
      │                     │                    │

  If POTENTIAL_MATCH or CONFIRMED_MATCH:
  - Block payment immediately
  - Route to Compliance team
  - File SAR if confirmed
```

### 19.2 OFAC Screening Request/Response

```json
{
  "screeningRequest": {
    "requestId": "OFAC-2025-00045678",
    "screeningType": "PAYMENT",
    "sourceClaimNumber": "CLM-2025-00001234",
    "sourceTransactionId": "PAY-2025-00005678",
    "entity": {
      "entityType": "INDIVIDUAL",
      "fullName": "John A. Smith",
      "firstName": "John",
      "lastName": "Smith",
      "dateOfBirth": "1985-03-22",
      "nationality": "US",
      "address": {
        "street": "123 Main St",
        "city": "Los Angeles",
        "state": "CA",
        "country": "US",
        "postalCode": "90001"
      },
      "identifiers": [
        { "type": "SSN", "value": "***-**-1234" },
        { "type": "DRIVERS_LICENSE", "value": "CA-D1234567" }
      ]
    }
  }
}
```

**Response:**

```json
{
  "screeningResponse": {
    "requestId": "OFAC-2025-00045678",
    "screeningDate": "2025-03-16T10:15:00Z",
    "result": "NO_MATCH",
    "matchScore": 0,
    "listsChecked": [
      "OFAC_SDN",
      "OFAC_CONSOLIDATED",
      "EU_SANCTIONS",
      "UN_SANCTIONS",
      "PEP_LIST"
    ],
    "potentialMatches": [],
    "disposition": "CLEARED",
    "clearanceExpiry": "2025-09-16T10:15:00Z"
  }
}
```

---

## 20. Real-Time vs Batch Integration

### 20.1 Integration Timing Matrix

```
  REAL-TIME (< 5 seconds)
  ┌─────────────────────────────────────────────────┐
  │ • Policy lookup during FNOL                     │
  │ • Coverage verification                         │
  │ • Fraud score calculation                       │
  │ • OFAC/sanctions screening                      │
  │ • Payment authorization                         │
  │ • Claim status inquiry (portal)                 │
  │ • Address/phone validation                      │
  │ • VIN decode                                    │
  └─────────────────────────────────────────────────┘

  NEAR-REAL-TIME (< 5 minutes)
  ┌─────────────────────────────────────────────────┐
  │ • Claim event notification to downstream        │
  │ • Reserve change propagation                    │
  │ • Document upload to ECM                        │
  │ • Email/SMS notifications                       │
  │ • Search index updates                          │
  │ • Dashboard metric updates                      │
  └─────────────────────────────────────────────────┘

  BATCH (scheduled intervals)
  ┌─────────────────────────────────────────────────┐
  │ • GL journal entry posting (hourly)             │
  │ • Reinsurance bordereaux (daily/monthly)        │
  │ • Data warehouse ETL (nightly)                  │
  │ • ISO statistical reporting (monthly)           │
  │ • State data calls (monthly/quarterly)          │
  │ • 1099 generation (annual)                      │
  │ • OFAC batch re-screening (quarterly)           │
  │ • Actuarial data extracts (monthly)             │
  │ • Vendor performance reporting (monthly)        │
  │ • Litigation management sync (daily)            │
  └─────────────────────────────────────────────────┘
```

### 20.2 Batch Processing Architecture

```
  NIGHTLY BATCH PROCESSING
  ════════════════════════

  22:00  ┌──────────────────────────────────────────┐
         │ Step 1: Claims Data Extract               │
         │ Source: Claims DB → Staging Area          │
         │ Volume: ~50,000 records                   │
         │ Duration: ~30 min                         │
  22:30  └──────────────────┬───────────────────────┘
                            │
  22:30  ┌──────────────────▼───────────────────────┐
         │ Step 2: Data Transformation               │
         │ Apply business rules, map to target       │
         │ Duration: ~45 min                         │
  23:15  └──────────────────┬───────────────────────┘
                            │
         ┌──────────────────▼───────────────┐
         │                                   │
  23:15  ▼                                   ▼
  ┌────────────────┐                ┌────────────────┐
  │ Step 3a: GL    │                │ Step 3b: DW    │
  │ File Gen       │                │ Load           │
  │ Duration: 20min│                │ Duration: 60min│
  23:35  └────┬─────┘                └────┬───────────┘
              │                           │
  23:35  ┌────▼──────────┐         00:15  │
         │ Step 4: SFTP  │                │
         │ to SAP        │                │
         │ Duration: 10m │                │
  23:45  └───────────────┘                │
                                          │
  00:15  ┌────────────────────────────────▼──────────┐
         │ Step 5: Reconciliation                     │
         │ Compare source counts with target counts  │
         │ Generate discrepancy report               │
         │ Duration: ~15 min                         │
  00:30  └────────────────────────────────────────────┘
```

---

## 21. File-Based Integration Patterns

### 21.1 SFTP Integration

```
  SFTP FILE EXCHANGE PATTERN
  ════════════════════════════

  Claims System          SFTP Server          Trading Partner
  ──────────────         ───────────          ───────────────
      │                       │                     │
      │  Generate File        │                     │
      │  (CSV/Fixed/XML)      │                     │
      │                       │                     │
      │  PUT /outbound/       │                     │
      │  claims_20250316.csv  │                     │
      │──────────────────────▶│                     │
      │                       │                     │
      │  Write .done trigger  │                     │
      │──────────────────────▶│                     │
      │                       │  Poll for .done     │
      │                       │◀────────────────────│
      │                       │                     │
      │                       │  GET file           │
      │                       │────────────────────▶│
      │                       │                     │
      │                       │  Move to /processed │
      │                       │                     │

  File Naming Convention:
  {system}_{datatype}_{date}_{sequence}.{ext}
  claims_gl_posting_20250316_001.csv
  claims_iso_statistical_20250316_001.xml
  claims_reins_bordereaux_202503_001.csv
```

### 21.2 S3 / Azure Blob Integration

```
  CLOUD STORAGE FILE EXCHANGE
  ═══════════════════════════

  S3 Bucket Structure:
  s3://insurance-claims-integration/
  ├── inbound/
  │   ├── estimates/          # From vendor platforms
  │   ├── medical-bills/      # From clearinghouse
  │   ├── policy-extracts/    # From PAS batch
  │   └── vendor-invoices/    # From vendors
  ├── outbound/
  │   ├── gl-postings/        # To SAP/Oracle
  │   ├── reinsurance/        # To reinsurer
  │   ├── regulatory/         # To state DOI
  │   ├── iso-statistical/    # To ISO
  │   └── data-warehouse/     # To DW/BI
  ├── processing/             # Currently being processed
  ├── archive/                # Processed files (lifecycle: 90 days → Glacier)
  └── error/                  # Failed processing
```

**S3 Event-Driven Processing:**

```json
{
  "S3EventNotification": {
    "bucket": "insurance-claims-integration",
    "key": "inbound/estimates/ccc_estimate_20250316_001.xml",
    "eventType": "s3:ObjectCreated:Put"
  },
  "LambdaProcessing": {
    "function": "claims-file-processor",
    "steps": [
      "1. Validate file format and schema",
      "2. Extract and transform data",
      "3. Post to claims API",
      "4. Move file to archive/",
      "5. Send processing confirmation",
      "6. On error: move to error/, alert operations"
    ]
  }
}
```

---

## 22. Error Handling and Retry Patterns

### 22.1 Error Classification

| Error Type | Examples | Retry Strategy | Escalation |
|---|---|---|---|
| Transient | Network timeout, 503, connection reset | Exponential backoff, 3-5 retries | Alert after max retries |
| Throttling | 429 Too Many Requests | Backoff with jitter, respect Retry-After | Reduce rate, alert |
| Data Validation | 400 Bad Request, schema mismatch | No retry; fix data, resubmit | Route to data quality team |
| Authentication | 401 Unauthorized, token expired | Refresh token, retry once | Alert security team |
| Authorization | 403 Forbidden | No retry | Alert security team |
| Business Logic | Coverage not found, policy expired | No retry | Route to adjuster |
| System | 500 Internal Server Error | Retry 2-3 times, then DLQ | Alert development team |
| Timeout | Gateway timeout (504) | Retry with longer timeout | Alert infrastructure |

### 22.2 Retry Implementation

```java
@Configuration
public class RetryConfiguration {

    @Bean
    public RetryTemplate claimsRetryTemplate() {
        RetryTemplate retryTemplate = new RetryTemplate();

        ExponentialBackOffPolicy backOffPolicy = new ExponentialBackOffPolicy();
        backOffPolicy.setInitialInterval(1000L);    // 1 second
        backOffPolicy.setMultiplier(2.0);            // Double each time
        backOffPolicy.setMaxInterval(30000L);         // Max 30 seconds
        retryTemplate.setBackOffPolicy(backOffPolicy);

        Map<Class<? extends Throwable>, Boolean> retryableExceptions = new HashMap<>();
        retryableExceptions.put(TransientDataAccessException.class, true);
        retryableExceptions.put(HttpServerErrorException.class, true);
        retryableExceptions.put(ResourceAccessException.class, true);
        retryableExceptions.put(HttpClientErrorException.TooManyRequests.class, true);

        retryableExceptions.put(HttpClientErrorException.BadRequest.class, false);
        retryableExceptions.put(HttpClientErrorException.Unauthorized.class, false);
        retryableExceptions.put(HttpClientErrorException.Forbidden.class, false);
        retryableExceptions.put(HttpClientErrorException.NotFound.class, false);

        SimpleRetryPolicy retryPolicy = new SimpleRetryPolicy(5, retryableExceptions);
        retryTemplate.setRetryPolicy(retryPolicy);

        retryTemplate.registerListener(new RetryListenerSupport() {
            @Override
            public <T, E extends Throwable> void onError(
                    RetryContext context, RetryCallback<T, E> callback, Throwable throwable) {
                log.warn("Retry attempt {} for operation: {}",
                    context.getRetryCount(), context.getAttribute("operation"), throwable);
                metricsService.incrementRetryCounter(
                    (String) context.getAttribute("operation"),
                    context.getRetryCount());
            }
        });

        return retryTemplate;
    }
}
```

### 22.3 Dead Letter Queue Processing

```
  DEAD LETTER QUEUE (DLQ) PATTERN
  ════════════════════════════════

  Primary Queue         DLQ                  DLQ Processor
  ─────────────         ───                  ─────────────
      │                  │                       │
      │  Message         │                       │
      │  Processing      │                       │
      │  Fails (3x)      │                       │
      │─────────────────▶│                       │
      │                  │                       │
      │                  │  ┌─────────────────┐  │
      │                  │  │ DLQ contains:   │  │
      │                  │  │ - Original msg  │  │
      │                  │  │ - Error details │  │
      │                  │  │ - Retry count   │  │
      │                  │  │ - Timestamp     │  │
      │                  │  │ - Correlation ID│  │
      │                  │  └─────────────────┘  │
      │                  │                       │
      │                  │  Poll/Schedule        │
      │                  │──────────────────────▶│
      │                  │                       │
      │                  │  Options:             │
      │                  │  1. Auto-retry        │
      │                  │  2. Manual review     │
      │                  │  3. Transform & retry │
      │                  │  4. Discard + alert   │
      │◀─────────────────│──────────────────────│
      │  Requeue         │                       │
```

---

## 23. Circuit Breaker and Bulkhead Patterns

### 23.1 Circuit Breaker for Claims Integration

```
  CIRCUIT BREAKER STATES
  ══════════════════════

  ┌──────────┐    failure threshold    ┌──────────┐
  │          │    exceeded             │          │
  │  CLOSED  │────────────────────────▶│   OPEN   │
  │ (normal) │                         │ (failing)│
  │          │                         │          │
  └──────────┘                         └─────┬────┘
       ▲                                     │
       │                                     │ timeout expires
       │        ┌──────────────┐             │
       │        │              │◀────────────┘
       │  success│  HALF-OPEN  │
       │  threshold│ (testing)  │
       └────────│              │
                └──────────────┘
                     │ failure
                     │ in test
                     ▼
                ┌──────────┐
                │   OPEN   │
                │ (failing)│
                └──────────┘
```

**Resilience4j Configuration:**

```yaml
resilience4j:
  circuitbreaker:
    instances:
      policyAdminService:
        slidingWindowType: COUNT_BASED
        slidingWindowSize: 20
        failureRateThreshold: 50
        waitDurationInOpenState: 30s
        permittedNumberOfCallsInHalfOpenState: 5
        automaticTransitionFromOpenToHalfOpenEnabled: true
        recordExceptions:
          - java.io.IOException
          - java.net.SocketTimeoutException
          - org.springframework.web.client.HttpServerErrorException
        ignoreExceptions:
          - org.springframework.web.client.HttpClientErrorException$NotFound
      
      vendorEstimateService:
        slidingWindowType: TIME_BASED
        slidingWindowSize: 60
        failureRateThreshold: 60
        waitDurationInOpenState: 60s
        slowCallDurationThreshold: 10s
        slowCallRateThreshold: 80
      
      ofacScreeningService:
        slidingWindowType: COUNT_BASED
        slidingWindowSize: 10
        failureRateThreshold: 30
        waitDurationInOpenState: 15s

  bulkhead:
    instances:
      policyAdminService:
        maxConcurrentCalls: 25
        maxWaitDuration: 5s
      vendorEstimateService:
        maxConcurrentCalls: 50
        maxWaitDuration: 10s
      documentUploadService:
        maxConcurrentCalls: 100
        maxWaitDuration: 30s

  ratelimiter:
    instances:
      isoClaimSearch:
        limitForPeriod: 100
        limitRefreshPeriod: 1m
        timeoutDuration: 5s
      lexisNexis:
        limitForPeriod: 50
        limitRefreshPeriod: 1m
        timeoutDuration: 10s

  timelimiter:
    instances:
      policyLookup:
        timeoutDuration: 3s
      coverageVerification:
        timeoutDuration: 5s
      vendorAssignment:
        timeoutDuration: 10s
```

### 23.2 Bulkhead Pattern

```
  BULKHEAD PATTERN FOR CLAIMS
  ═══════════════════════════

  ┌────────────────────────────────────────────────────────┐
  │                  CLAIMS SERVICE                         │
  │                                                         │
  │  ┌──────────────────┐  ┌──────────────────┐           │
  │  │ Policy Lookup    │  │ Vendor Estimate  │           │
  │  │ Thread Pool: 25  │  │ Thread Pool: 50  │           │
  │  │ Queue: 50        │  │ Queue: 100       │           │
  │  │                  │  │                  │           │
  │  │ If pool full:    │  │ If pool full:    │           │
  │  │ → Reject + cache │  │ → Queue + async  │           │
  │  └──────────────────┘  └──────────────────┘           │
  │                                                         │
  │  ┌──────────────────┐  ┌──────────────────┐           │
  │  │ OFAC Screening   │  │ Document Upload  │           │
  │  │ Thread Pool: 10  │  │ Thread Pool: 100 │           │
  │  │ Queue: 20        │  │ Queue: 200       │           │
  │  │                  │  │                  │           │
  │  │ If pool full:    │  │ If pool full:    │           │
  │  │ → Block payment  │  │ → Queue for later│           │
  │  └──────────────────┘  └──────────────────┘           │
  │                                                         │
  │  Isolation: Failure in one pool does NOT affect others  │
  └────────────────────────────────────────────────────────┘
```

---

## 24. Idempotency Patterns

### 24.1 The Problem

In claims processing, duplicate messages are inevitable due to retries, failover, and at-least-once delivery semantics. Duplicate payments are financially catastrophic.

### 24.2 Idempotency Key Design

| Transaction Type | Idempotency Key | Storage | TTL |
|---|---|---|---|
| Payment | `{claimNumber}:{paymentId}:{amount}:{payeeId}` | Redis + DB | 30 days |
| Reserve Change | `{claimNumber}:{exposureId}:{reserveType}:{timestamp}` | Redis | 7 days |
| GL Posting | `{source}:{sourceRef}:{postingDate}:{entryType}` | Database | 90 days |
| Vendor Assignment | `{claimNumber}:{vendorType}:{assignmentDate}` | Redis | 7 days |
| OFAC Screening | `{entityHash}:{screeningType}` | Redis | 180 days |
| Document Upload | `{claimNumber}:{fileHash}:{documentType}` | Redis + DB | 30 days |

### 24.3 Implementation

```java
@Service
public class IdempotencyService {

    private final RedisTemplate<String, IdempotencyRecord> redisTemplate;
    private final IdempotencyRepository dbRepository;

    public <T> T executeIdempotent(
            String idempotencyKey,
            Supplier<T> operation,
            Duration ttl) {

        // Step 1: Check Redis cache first (fast path)
        IdempotencyRecord cached = redisTemplate.opsForValue().get(idempotencyKey);
        if (cached != null) {
            if (cached.getStatus() == IdempotencyStatus.COMPLETED) {
                log.info("Idempotent hit (cache): {}", idempotencyKey);
                return deserialize(cached.getResult());
            }
            if (cached.getStatus() == IdempotencyStatus.IN_PROGRESS) {
                throw new ConcurrentOperationException(
                    "Operation already in progress: " + idempotencyKey);
            }
        }

        // Step 2: Check database (durable store)
        Optional<IdempotencyRecord> dbRecord = dbRepository.findByKey(idempotencyKey);
        if (dbRecord.isPresent() && dbRecord.get().getStatus() == IdempotencyStatus.COMPLETED) {
            redisTemplate.opsForValue().set(idempotencyKey, dbRecord.get(), ttl);
            return deserialize(dbRecord.get().getResult());
        }

        // Step 3: Acquire lock (optimistic)
        IdempotencyRecord lockRecord = IdempotencyRecord.builder()
            .key(idempotencyKey)
            .status(IdempotencyStatus.IN_PROGRESS)
            .createdAt(Instant.now())
            .build();

        Boolean acquired = redisTemplate.opsForValue()
            .setIfAbsent(idempotencyKey, lockRecord, ttl);

        if (Boolean.FALSE.equals(acquired)) {
            throw new ConcurrentOperationException(
                "Could not acquire lock: " + idempotencyKey);
        }

        try {
            // Step 4: Execute operation
            T result = operation.get();

            // Step 5: Record completion
            IdempotencyRecord completedRecord = IdempotencyRecord.builder()
                .key(idempotencyKey)
                .status(IdempotencyStatus.COMPLETED)
                .result(serialize(result))
                .createdAt(Instant.now())
                .build();

            dbRepository.save(completedRecord);
            redisTemplate.opsForValue().set(idempotencyKey, completedRecord, ttl);

            return result;

        } catch (Exception e) {
            redisTemplate.delete(idempotencyKey);
            throw e;
        }
    }
}
```

---

## 25. Distributed Transaction Management

### 25.1 Saga Pattern for Claims

The Saga pattern manages distributed transactions across microservices without using a global two-phase commit.

```
  CLAIM PAYMENT SAGA (Orchestration)
  ═══════════════════════════════════

  Saga Orchestrator
  ─────────────────
      │
      │  Step 1: Validate Payment
      │───────────────────────────▶ Payment Validation Service
      │                              ✓ Amount within authority
      │                              ✓ Reserve available
      │                              ✓ No duplicate
      │
      │  Step 2: OFAC Screening
      │───────────────────────────▶ Compliance Service
      │                              ✓ Payee cleared
      │
      │  Step 3: Reserve Reduction
      │───────────────────────────▶ Reserve Service
      │                              ✓ Reserve decremented
      │
      │  Step 4: Issue Payment
      │───────────────────────────▶ Payment Service
      │                              ✓ Check/ACH initiated
      │
      │  Step 5: GL Posting
      │───────────────────────────▶ GL Service
      │                              ✓ Journal entry created
      │
      │  Step 6: Notification
      │───────────────────────────▶ Notification Service
      │                              ✓ Payee notified
      │
      │  SAGA COMPLETE ✓

  COMPENSATION (if Step 4 fails):
  ─────────────────────────────
      │
      │  Compensate Step 3: Restore Reserve
      │───────────────────────────▶ Reserve Service
      │                              ✓ Reserve restored
      │
      │  Compensate Step 2: (no-op, screening is read-only)
      │
      │  Compensate Step 1: (no-op, validation is read-only)
      │
      │  SAGA COMPENSATED ✗
      │  → Alert adjuster of payment failure
```

### 25.2 Saga Implementation

```java
@Component
public class PaymentSaga {

    private final SagaOrchestrator orchestrator;

    public SagaResult executePaymentSaga(PaymentRequest request) {

        return orchestrator.newSaga("CLAIM_PAYMENT")
            .correlationId(request.getPaymentId())

            .step("VALIDATE_PAYMENT")
                .action(ctx -> paymentValidationService.validate(request))
                .compensate(ctx -> {}) // Read-only, no compensation needed
                .build()

            .step("OFAC_SCREENING")
                .action(ctx -> complianceService.screenPayee(request.getPayee()))
                .compensate(ctx -> {})
                .timeout(Duration.ofSeconds(10))
                .retries(2)
                .build()

            .step("REDUCE_RESERVE")
                .action(ctx -> reserveService.reduceReserve(
                    request.getClaimNumber(),
                    request.getExposureId(),
                    request.getAmount()))
                .compensate(ctx -> reserveService.restoreReserve(
                    request.getClaimNumber(),
                    request.getExposureId(),
                    request.getAmount()))
                .build()

            .step("ISSUE_PAYMENT")
                .action(ctx -> paymentService.issuePayment(request))
                .compensate(ctx -> paymentService.voidPayment(
                    ctx.get("paymentId")))
                .timeout(Duration.ofSeconds(30))
                .build()

            .step("GL_POSTING")
                .action(ctx -> glService.postJournalEntry(
                    buildGLEntry(request, ctx.get("paymentId"))))
                .compensate(ctx -> glService.reverseJournalEntry(
                    ctx.get("journalEntryId")))
                .build()

            .step("SEND_NOTIFICATION")
                .action(ctx -> notificationService.notifyPayee(request))
                .compensate(ctx -> {})
                .optional(true)
                .build()

            .onComplete(ctx -> {
                auditService.logSagaCompletion("CLAIM_PAYMENT", request.getPaymentId());
                metricsService.recordPaymentSagaSuccess();
            })
            .onCompensate(ctx -> {
                auditService.logSagaCompensation("CLAIM_PAYMENT", request.getPaymentId());
                metricsService.recordPaymentSagaFailure();
                alertService.alertPaymentFailure(request);
            })

            .execute();
    }
}
```

---

## 26. Integration Monitoring and Observability

### 26.1 Observability Stack

```
  CLAIMS INTEGRATION OBSERVABILITY
  ═════════════════════════════════

  ┌─────────────────────────────────────────────────────────┐
  │                    GRAFANA DASHBOARD                     │
  │  ┌────────────┐  ┌────────────┐  ┌────────────┐       │
  │  │ Integration│  │ Error Rate │  │ Latency    │       │
  │  │ Volume     │  │ by System  │  │ Percentiles│       │
  │  └────────────┘  └────────────┘  └────────────┘       │
  │  ┌────────────┐  ┌────────────┐  ┌────────────┐       │
  │  │ Circuit    │  │ DLQ Depth  │  │ Retry      │       │
  │  │ Breaker    │  │            │  │ Rate       │       │
  │  └────────────┘  └────────────┘  └────────────┘       │
  └─────────────────────────────────────────────────────────┘
           │                │                │
  ┌────────▼──────┐  ┌─────▼──────┐  ┌─────▼──────┐
  │  Prometheus   │  │   Loki     │  │   Tempo    │
  │  (Metrics)    │  │   (Logs)   │  │  (Traces)  │
  └────────┬──────┘  └─────┬──────┘  └─────┬──────┘
           │                │                │
  ┌────────▼────────────────▼────────────────▼──────┐
  │              OpenTelemetry Collector             │
  │  ┌──────────┐  ┌──────────┐  ┌──────────┐     │
  │  │ Metrics  │  │  Logs    │  │  Traces  │     │
  │  │ Receiver │  │ Receiver │  │ Receiver │     │
  │  └──────────┘  └──────────┘  └──────────┘     │
  └─────────────────────────────────────────────────┘
           ▲                ▲                ▲
           │                │                │
  ┌────────┴──┐  ┌─────────┴──┐  ┌─────────┴──┐
  │ Claims    │  │ ESB /      │  │ API        │
  │ Services  │  │ Integration│  │ Gateway    │
  └───────────┘  └────────────┘  └────────────┘
```

### 26.2 Key Integration Metrics

```
# Prometheus metrics for claims integration

# Message throughput
claims_integration_messages_total{
  source="claims_service",
  destination="gl_service",
  message_type="payment_posting",
  status="success|failure"
} counter

# Latency histogram
claims_integration_latency_seconds{
  source="claims_service",
  destination="policy_admin",
  operation="policy_lookup"
} histogram (buckets: 0.1, 0.25, 0.5, 1, 2.5, 5, 10)

# Circuit breaker state
claims_circuit_breaker_state{
  name="policy_admin_service",
  state="closed|open|half_open"
} gauge

# Dead letter queue depth
claims_dlq_depth{
  queue_name="claims.gl.posting.dlq"
} gauge

# Retry count
claims_integration_retries_total{
  destination="vendor_estimate",
  retry_attempt="1|2|3|4|5"
} counter

# Batch processing
claims_batch_processing_duration_seconds{
  job_name="nightly_gl_extract",
  status="success|failure"
} gauge

claims_batch_records_processed_total{
  job_name="nightly_gl_extract"
} counter
```

### 26.3 Alerting Rules

```yaml
groups:
  - name: claims_integration_alerts
    rules:
      - alert: HighIntegrationErrorRate
        expr: |
          rate(claims_integration_messages_total{status="failure"}[5m])
          / rate(claims_integration_messages_total[5m]) > 0.05
        for: 5m
        labels:
          severity: critical
          team: claims-integration
        annotations:
          summary: "High error rate on {{ $labels.destination }} integration"
          description: "Error rate is {{ $value | humanizePercentage }} for {{ $labels.source }} → {{ $labels.destination }}"

      - alert: CircuitBreakerOpen
        expr: claims_circuit_breaker_state{state="open"} == 1
        for: 1m
        labels:
          severity: warning
          team: claims-integration
        annotations:
          summary: "Circuit breaker OPEN for {{ $labels.name }}"

      - alert: DLQDepthHigh
        expr: claims_dlq_depth > 100
        for: 10m
        labels:
          severity: warning
          team: claims-integration
        annotations:
          summary: "DLQ depth high: {{ $labels.queue_name }} = {{ $value }}"

      - alert: PaymentIntegrationDown
        expr: |
          up{job="claims-payment-service"} == 0
          or rate(claims_integration_messages_total{destination="payment_service"}[5m]) == 0
        for: 2m
        labels:
          severity: critical
          team: claims-integration
          pager: "true"
        annotations:
          summary: "Payment integration appears down"

      - alert: BatchJobFailed
        expr: claims_batch_processing_duration_seconds{status="failure"} > 0
        labels:
          severity: critical
          team: claims-operations
        annotations:
          summary: "Batch job failed: {{ $labels.job_name }}"

      - alert: HighLatencyPolicyLookup
        expr: |
          histogram_quantile(0.95, 
            rate(claims_integration_latency_seconds_bucket{
              operation="policy_lookup"}[5m])) > 3
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "P95 latency for policy lookup exceeds 3s"
```

---

## 27. Integration Architecture Diagrams

### 27.1 Complete Enterprise Integration Architecture

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                     ENTERPRISE CLAIMS INTEGRATION ARCHITECTURE               │
│                                                                              │
│  ┌──────────────────────────────────────────────────────────────────────┐   │
│  │                         API GATEWAY LAYER                            │   │
│  │  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐           │   │
│  │  │ Agent    │  │ Customer │  │ Mobile   │  │ Vendor   │           │   │
│  │  │ Portal   │  │ Portal   │  │ App      │  │ Partners │           │   │
│  │  └────┬─────┘  └────┬─────┘  └────┬─────┘  └────┬─────┘           │   │
│  │       └──────────────┴──────────────┴──────────────┘                │   │
│  │                           │                                         │   │
│  │              ┌────────────▼────────────┐                            │   │
│  │              │     API GATEWAY         │                            │   │
│  │              │  (Kong / Apigee / AWS)  │                            │   │
│  │              │  Auth│Rate│Log│Route    │                            │   │
│  │              └────────────┬────────────┘                            │   │
│  └──────────────────────────┼──────────────────────────────────────────┘   │
│                              │                                              │
│  ┌──────────────────────────┼──────────────────────────────────────────┐   │
│  │              SERVICE MESH (Istio / Linkerd)                         │   │
│  │                           │                                         │   │
│  │  ┌────────┐  ┌────────┐  │  ┌────────┐  ┌────────┐  ┌────────┐  │   │
│  │  │ FNOL   │  │Coverage│  │  │Reserve │  │Payment │  │Document│  │   │
│  │  │Service │  │Service │  │  │Service │  │Service │  │Service │  │   │
│  │  └───┬────┘  └───┬────┘  │  └───┬────┘  └───┬────┘  └───┬────┘  │   │
│  │      │           │       │      │           │           │        │   │
│  │      └───────────┴───────┼──────┴───────────┴───────────┘        │   │
│  │                          │                                        │   │
│  └──────────────────────────┼────────────────────────────────────────┘   │
│                              │                                              │
│  ┌──────────────────────────┼──────────────────────────────────────────┐   │
│  │                   EVENT BACKBONE (Kafka)                             │   │
│  │                          │                                          │   │
│  │  ┌───────────────────────▼──────────────────────────────────────┐  │   │
│  │  │  claim.created │ reserve.changed │ payment.issued │ ...     │  │   │
│  │  └──────┬─────────────────┬────────────────────┬───────────────┘  │   │
│  │         │                 │                    │                   │   │
│  └─────────┼─────────────────┼────────────────────┼──────────────────┘   │
│            │                 │                    │                        │
│  ┌─────────▼──┐  ┌──────────▼──┐  ┌─────────────▼────┐                  │
│  │ GL / ERP   │  │ Reinsurance │  │ Data Warehouse   │                  │
│  │ (SAP)      │  │ System      │  │ (Snowflake)      │                  │
│  └────────────┘  └─────────────┘  └──────────────────┘                  │
│                                                                           │
│  ┌────────────────────────────────────────────────────────────────────┐   │
│  │                 EXTERNAL INTEGRATION LAYER (ESB / iPaaS)           │   │
│  │                                                                    │   │
│  │  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐            │   │
│  │  │ Policy   │ │ ISO      │ │ CCC ONE  │ │ Xactimate│            │   │
│  │  │ Admin    │ │ Claim    │ │          │ │          │            │   │
│  │  │ (GW PC)  │ │ Search   │ │          │ │          │            │   │
│  │  └──────────┘ └──────────┘ └──────────┘ └──────────┘            │   │
│  │  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐            │   │
│  │  │ LexisNexis│ │ Copart  │ │ OnBase   │ │ State DOI│            │   │
│  │  │          │ │ / IAA    │ │ (ECM)    │ │          │            │   │
│  │  └──────────┘ └──────────┘ └──────────┘ └──────────┘            │   │
│  └────────────────────────────────────────────────────────────────────┘   │
│                                                                           │
│  ┌────────────────────────────────────────────────────────────────────┐   │
│  │                    OBSERVABILITY LAYER                              │   │
│  │  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐         │   │
│  │  │Prometheus│  │  Grafana │  │   Loki   │  │  Tempo   │         │   │
│  │  │ (Metrics)│  │(Dashboard│  │  (Logs)  │  │ (Traces) │         │   │
│  │  └──────────┘  └──────────┘  └──────────┘  └──────────┘         │   │
│  └────────────────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## 28. API Versioning and Lifecycle Management

### 28.1 API Versioning Strategy

| Strategy | URL Example | Header Example | Pros | Cons |
|---|---|---|---|---|
| URL Path | `/v1/claims`, `/v2/claims` | N/A | Simple, clear, cacheable | URL pollution |
| Header | `/claims` | `Accept: application/vnd.claims.v2+json` | Clean URLs | Hidden versioning |
| Query Param | `/claims?version=2` | N/A | Easy to implement | Not RESTful |
| **Recommended** | **URL Path (major), Header (minor)** | | Best balance | |

### 28.2 API Lifecycle

```
  API VERSION LIFECYCLE
  ═════════════════════

  ┌──────────┐    ┌──────────┐    ┌──────────┐    ┌──────────┐    ┌──────────┐
  │  DRAFT   │───▶│  BETA    │───▶│   GA     │───▶│DEPRECATED│───▶│ RETIRED  │
  │          │    │          │    │          │    │          │    │          │
  │ Internal │    │ Limited  │    │ Full     │    │ Sunset   │    │ Removed  │
  │ testing  │    │ partners │    │ release  │    │ notice   │    │          │
  │          │    │          │    │          │    │ 12 months│    │          │
  └──────────┘    └──────────┘    └──────────┘    └──────────┘    └──────────┘
       2 months       3 months        N/A           12 months        N/A

  Versioning Rules for Claims APIs:
  1. Breaking changes require new major version (v1 → v2)
  2. Additive changes are backward-compatible (no version bump)
  3. Minimum 12-month deprecation window
  4. Maximum 2 concurrent major versions supported
  5. All versions must pass current compliance requirements
```

### 28.3 API Contract Example (OpenAPI 3.0)

```yaml
openapi: 3.0.3
info:
  title: Claims API
  version: 2.1.0
  description: PnC Claims Management API
  contact:
    name: Claims Platform Team
    email: claims-platform@insurance.com

servers:
  - url: https://api.insurance.com/v2
    description: Production
  - url: https://api-staging.insurance.com/v2
    description: Staging

paths:
  /claims:
    post:
      operationId: createClaim
      summary: Create a new claim (FNOL)
      tags: [Claims]
      security:
        - OAuth2: [claims:write]
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/CreateClaimRequest'
      responses:
        '201':
          description: Claim created successfully
          headers:
            Location:
              schema:
                type: string
              example: /v2/claims/CLM-2025-00001234
            X-Correlation-ID:
              schema:
                type: string
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ClaimResponse'
        '400':
          $ref: '#/components/responses/BadRequest'
        '401':
          $ref: '#/components/responses/Unauthorized'
        '409':
          $ref: '#/components/responses/Conflict'
        '422':
          $ref: '#/components/responses/UnprocessableEntity'
        '429':
          $ref: '#/components/responses/TooManyRequests'

components:
  schemas:
    CreateClaimRequest:
      type: object
      required:
        - policyNumber
        - lossDate
        - lossDescription
        - lossCauseCode
        - reporterInfo
      properties:
        policyNumber:
          type: string
          pattern: '^POL-[A-Z]{2}-[0-9]{8}$'
          example: "POL-CA-20250001"
        lossDate:
          type: string
          format: date-time
          example: "2025-03-14T15:30:00Z"
        lossDescription:
          type: string
          maxLength: 5000
          example: "Rear-end collision at intersection of Main St and 3rd Ave"
        lossCauseCode:
          type: string
          enum: [COLLISION, COMPREHENSIVE, FIRE, THEFT, WATER_DAMAGE, WIND, HAIL, LIABILITY, OTHER]

  securitySchemes:
    OAuth2:
      type: oauth2
      flows:
        clientCredentials:
          tokenUrl: https://auth.insurance.com/oauth/token
          scopes:
            claims:read: Read claims
            claims:write: Create and update claims
            claims:payment: Authorize payments
            claims:admin: Administrative operations
```

---

## 29. Security Patterns

### 29.1 Security Architecture

```
  CLAIMS INTEGRATION SECURITY LAYERS
  ═══════════════════════════════════

  Layer 1: Network Security
  ┌──────────────────────────────────────────────────┐
  │ • VPN / PrivateLink for partner connections       │
  │ • TLS 1.2+ for all connections                   │
  │ • Network segmentation (claims in dedicated VPC) │
  │ • WAF for public-facing APIs                     │
  │ • DDoS protection (AWS Shield / Cloudflare)      │
  └──────────────────────────────────────────────────┘

  Layer 2: Authentication & Authorization
  ┌──────────────────────────────────────────────────┐
  │ • OAuth2 + OIDC for API authentication            │
  │ • mTLS for system-to-system integration           │
  │ • API keys for vendor partners (with rotation)    │
  │ • RBAC + ABAC for fine-grained authorization     │
  │ • JWT tokens with short expiry (15 min)           │
  └──────────────────────────────────────────────────┘

  Layer 3: Data Security
  ┌──────────────────────────────────────────────────┐
  │ • AES-256 encryption at rest                     │
  │ • TLS 1.3 encryption in transit                  │
  │ • Field-level encryption for PII/PHI             │
  │ • Data masking in non-production environments     │
  │ • Tokenization for SSN, TaxID, bank accounts     │
  └──────────────────────────────────────────────────┘

  Layer 4: Audit & Compliance
  ┌──────────────────────────────────────────────────┐
  │ • Full audit trail for all integration calls      │
  │ • PII access logging (CCPA/HIPAA)                │
  │ • API usage analytics and anomaly detection       │
  │ • Regulatory compliance reporting                 │
  │ • Data retention and disposal automation          │
  └──────────────────────────────────────────────────┘
```

### 29.2 OAuth2 Configuration for Claims

```json
{
  "oauth2_configuration": {
    "authorization_server": "https://auth.insurance.com",
    "token_endpoint": "/oauth/token",
    "jwks_uri": "/oauth/jwks",
    
    "clients": [
      {
        "client_id": "claims-service",
        "grant_type": "client_credentials",
        "scopes": ["claims:read", "claims:write", "claims:payment", "policy:read"],
        "token_lifetime_seconds": 900,
        "description": "Claims microservice"
      },
      {
        "client_id": "agent-portal",
        "grant_type": "authorization_code",
        "scopes": ["claims:read", "claims:write"],
        "token_lifetime_seconds": 3600,
        "redirect_uris": ["https://portal.insurance.com/callback"],
        "description": "Agent-facing web portal"
      },
      {
        "client_id": "vendor-ccc",
        "grant_type": "client_credentials",
        "scopes": ["claims:estimates:write", "claims:assignments:read"],
        "token_lifetime_seconds": 1800,
        "ip_whitelist": ["203.0.113.0/24"],
        "rate_limit": { "requests_per_minute": 100 },
        "description": "CCC ONE vendor integration"
      },
      {
        "client_id": "customer-mobile",
        "grant_type": "authorization_code_pkce",
        "scopes": ["claims:read:own", "claims:write:own"],
        "token_lifetime_seconds": 900,
        "refresh_token_lifetime_seconds": 86400,
        "description": "Customer mobile app"
      }
    ],

    "resource_policies": [
      {
        "resource": "/v2/claims/*/payments",
        "method": "POST",
        "required_scopes": ["claims:payment"],
        "additional_checks": ["payment_authority_limit", "dual_approval_check"]
      },
      {
        "resource": "/v2/claims/*/medical-records",
        "method": "GET",
        "required_scopes": ["claims:medical:read"],
        "additional_checks": ["hipaa_authorization_check", "audit_pii_access"]
      }
    ]
  }
}
```

### 29.3 mTLS for System-to-System

```yaml
# mTLS configuration for claims integration
tls:
  server:
    certificate: /etc/ssl/claims-service/server.crt
    private_key: /etc/ssl/claims-service/server.key
    ca_certificate: /etc/ssl/ca/insurance-root-ca.crt
    min_version: TLS1.3
    cipher_suites:
      - TLS_AES_256_GCM_SHA384
      - TLS_AES_128_GCM_SHA256
      - TLS_CHACHA20_POLY1305_SHA256
    client_auth: REQUIRE

  client_certificates:
    - name: policy-admin
      subject_cn: "policy-admin.insurance.internal"
      issuer: "Insurance Internal CA"
      allowed_operations: ["policy:read"]
    
    - name: gl-service
      subject_cn: "gl-service.insurance.internal"
      issuer: "Insurance Internal CA"
      allowed_operations: ["gl:write"]
    
    - name: vendor-ccc
      subject_cn: "ccc-one.cccis.com"
      issuer: "DigiCert Global CA"
      allowed_operations: ["estimates:write", "assignments:read"]
      ip_whitelist: ["203.0.113.0/24"]
    
  certificate_rotation:
    auto_rotate: true
    rotation_period_days: 90
    renewal_before_expiry_days: 30
    notification_channels:
      - email: security-team@insurance.com
      - slack: "#claims-security-alerts"
```

---

## 30. Sample Integration Flows

### 30.1 FNOL End-to-End Integration Flow

```
  FNOL INTEGRATION SEQUENCE
  ═════════════════════════

  Agent      API        FNOL       Policy      Coverage     Fraud       Assign      Notify      ISO
  Portal     Gateway    Service    Admin       Service      Service     Service     Service     ClaimSearch
  ──────     ───────    ────────   ──────      ────────     ───────     ───────     ───────     ───────
    │          │          │          │           │            │           │           │           │
    │ POST     │          │          │           │            │           │           │           │
    │ /fnol    │          │          │           │            │           │           │           │
    │─────────▶│          │          │           │            │           │           │           │
    │          │          │          │           │            │           │           │           │
    │          │ Auth +   │          │           │            │           │           │           │
    │          │ Route    │          │           │            │           │           │           │
    │          │─────────▶│          │           │            │           │           │           │
    │          │          │          │           │            │           │           │           │
    │          │          │ Lookup   │           │            │           │           │           │
    │          │          │ Policy   │           │            │           │           │           │
    │          │          │─────────▶│           │            │           │           │           │
    │          │          │          │           │            │           │           │           │
    │          │          │ Policy + │           │            │           │           │           │
    │          │          │ Coverages│           │            │           │           │           │
    │          │          │◀─────────│           │            │           │           │           │
    │          │          │          │           │            │           │           │           │
    │          │          │ Verify   │           │            │           │           │           │
    │          │          │──────────────────────▶            │           │           │           │
    │          │          │          │           │            │           │           │           │
    │          │          │ Coverage │           │            │           │           │           │
    │          │          │ Result   │           │            │           │           │           │
    │          │          │◀──────────────────────            │           │           │           │
    │          │          │          │           │            │           │           │           │
    │          │          │ Score    │           │            │           │           │           │
    │          │          │──────────────────────────────────▶│           │           │           │
    │          │          │          │           │            │           │           │           │
    │          │          │ Fraud    │           │            │           │           │           │
    │          │          │ Score    │           │            │           │           │           │
    │          │          │◀──────────────────────────────────│           │           │           │
    │          │          │          │           │            │           │           │           │
    │          │          │ Create   │           │            │           │           │           │
    │          │          │ Claim    │           │            │           │           │           │
    │          │          │ (DB)     │           │            │           │           │           │
    │          │          │          │           │            │           │           │           │
    │          │          │─[EVENT: claim.created]───────────────────────────────────────────────▶│
    │          │          │          │           │            │           │           │           │
    │          │          │ Assign   │           │            │           │           │           │
    │          │          │──────────────────────────────────────────────▶│           │           │
    │          │          │          │           │            │           │           │           │
    │          │          │ Adjuster │           │            │           │           │           │
    │          │          │◀──────────────────────────────────────────────│           │           │
    │          │          │          │           │            │           │           │           │
    │          │          │ Notify   │           │            │           │           │           │
    │          │          │──────────────────────────────────────────────────────────▶│           │
    │          │          │          │           │            │           │           │           │
    │          │ 201      │          │           │            │           │           │           │
    │          │ Created  │          │           │            │           │           │           │
    │          │◀─────────│          │           │            │           │           │           │
    │          │          │          │           │            │           │           │           │
    │ 201      │          │          │           │            │           │           │           │
    │ Created  │          │          │           │            │           │           │           │
    │◀─────────│          │          │           │            │           │           │           │

  Synchronous calls: Policy Lookup, Coverage Verify, Fraud Score
  Asynchronous:       Assignment, Notification, ISO ClaimSearch
  Total sync latency target: < 3 seconds
```

### 30.2 Payment Authorization Flow

```
  PAYMENT AUTHORIZATION SEQUENCE
  ══════════════════════════════

  Adjuster   Claims     Auth       OFAC       Reserve    Payment    GL         Bank
  UI         Service    Service    Screening  Service    Service    Service    Gateway
  ────────   ───────    ───────    ─────────  ───────    ───────    ───────    ───────
    │          │          │          │          │          │          │          │
    │ Request  │          │          │          │          │          │          │
    │ Payment  │          │          │          │          │          │          │
    │─────────▶│          │          │          │          │          │          │
    │          │          │          │          │          │          │          │
    │          │ Check    │          │          │          │          │          │
    │          │ Authority│          │          │          │          │          │
    │          │─────────▶│          │          │          │          │          │
    │          │          │          │          │          │          │          │
    │          │ Approved │          │          │          │          │          │
    │          │◀─────────│          │          │          │          │          │
    │          │          │          │          │          │          │          │
    │          │ Screen   │          │          │          │          │          │
    │          │ Payee    │          │          │          │          │          │
    │          │─────────────────────▶          │          │          │          │
    │          │          │          │          │          │          │          │
    │          │ Cleared  │          │          │          │          │          │
    │          │◀─────────────────────          │          │          │          │
    │          │          │          │          │          │          │          │
    │          │ Reduce   │          │          │          │          │          │
    │          │ Reserve  │          │          │          │          │          │
    │          │───────────────────────────────▶│          │          │          │
    │          │          │          │          │          │          │          │
    │          │ Reserve  │          │          │          │          │          │
    │          │ Reduced  │          │          │          │          │          │
    │          │◀───────────────────────────────│          │          │          │
    │          │          │          │          │          │          │          │
    │          │ Issue    │          │          │          │          │          │
    │          │ Payment  │          │          │          │          │          │
    │          │─────────────────────────────────────────▶│          │          │
    │          │          │          │          │          │          │          │
    │          │          │          │          │          │ Submit   │          │
    │          │          │          │          │          │ to Bank  │          │
    │          │          │          │          │          │─────────────────────▶
    │          │          │          │          │          │          │          │
    │          │          │          │          │          │ Bank Ref │          │
    │          │          │          │          │          │◀─────────────────────
    │          │          │          │          │          │          │          │
    │          │ Payment  │          │          │          │          │          │
    │          │ Issued   │          │          │          │          │          │
    │          │◀─────────────────────────────────────────│          │          │
    │          │          │          │          │          │          │          │
    │          │─[EVENT: payment.issued]────────────────────────────▶│          │
    │          │          │          │          │          │          │          │
    │          │          │          │          │          │          │ Post to  │
    │          │          │          │          │          │          │ GL       │
    │          │          │          │          │          │          │          │
    │ Payment  │          │          │          │          │          │          │
    │ Confirmed│          │          │          │          │          │          │
    │◀─────────│          │          │          │          │          │          │
```

### 30.3 Catastrophe Event Integration

```
  CATASTROPHE CLAIM SURGE INTEGRATION
  ═══════════════════════════════════

  Event: Hurricane makes landfall
  
  T+0:  Weather Data Feed → CAT Event Created
  T+1h: FNOL volume spikes 50x
  
  Normal Flow:
  ┌──────┐    100/hr    ┌──────┐    100/hr    ┌──────┐
  │ FNOL │─────────────▶│Claims│─────────────▶│ All  │
  │Intake│              │System│              │Downstream│
  └──────┘              └──────┘              └──────┘

  CAT Flow (with backpressure):
  ┌──────┐   5000/hr    ┌──────┐              ┌──────┐
  │ FNOL │─────────────▶│Claims│──[QUEUE]────▶│ All  │
  │Intake│              │System│   buffered   │Downstream│
  └──────┘              └──────┘              └──────┘
                           │
                           ├──▶ Priority Queue (injury claims first)
                           ├──▶ Auto-triage (AI severity scoring)
                           ├──▶ Batch vendor assignments
                           ├──▶ Throttle GL postings (hourly batch)
                           └──▶ Defer ISO reporting (daily batch)

  CAT Integration Scaling:
  ┌──────────────────────────────────────────────────────┐
  │ Component              │ Normal │ CAT Mode           │
  ├──────────────────────────────────────────────────────┤
  │ FNOL API instances     │ 3      │ 15 (auto-scale)   │
  │ Kafka partitions       │ 12     │ 36 (pre-scaled)   │
  │ GL posting frequency   │ Real-time │ Hourly batch   │
  │ Vendor assignment      │ Real-time │ Batched (15min) │
  │ ISO reporting          │ Real-time │ Daily batch     │
  │ Policy lookup cache TTL│ 5 min  │ 30 min           │
  │ Document processing    │ Real-time │ Queued (1hr)   │
  └──────────────────────────────────────────────────────┘
```

---

## Appendix A: Integration Technology Decision Framework

### Decision Tree

```
  START
  │
  ├─ "Is this a new greenfield project?"
  │   ├─ YES → "Cloud-native or on-premises?"
  │   │   ├─ CLOUD → Event-driven (Kafka/EventBridge) + API-led (API Gateway)
  │   │   └─ ON-PREM → ESB (MuleSoft/IBM ACE) + Message Queue (IBM MQ)
  │   │
  │   └─ NO → "What is the current integration pattern?"
  │       ├─ POINT-TO-POINT → Introduce ESB/iPaaS incrementally
  │       ├─ ESB → Add event backbone (Kafka) for new integrations
  │       └─ CUSTOM → Assess and migrate to standard patterns
  │
  ├─ "What is the integration volume?"
  │   ├─ LOW (< 1000 msg/day) → REST API direct integration
  │   ├─ MEDIUM (1K - 100K/day) → API Gateway + Message Queue
  │   └─ HIGH (> 100K/day) → Event streaming (Kafka) + CQRS
  │
  └─ "What is the latency requirement?"
      ├─ REAL-TIME (< 2s) → Synchronous REST/gRPC with caching
      ├─ NEAR-REAL-TIME (< 5min) → Event-driven with message queue
      └─ BATCH → File-based (S3/SFTP) with scheduled processing
```

### Appendix B: Vendor Integration Quick Reference

| Vendor | Protocol | Auth | Format | Docs |
|---|---|---|---|---|
| Guidewire | REST (Cloud API) / SOAP | OAuth2 / Basic | JSON / XML | developer.guidewire.com |
| Duck Creek | REST | OAuth2 | JSON | docs.duckcreek.com |
| CCC ONE | SOAP / REST | mTLS / API Key | BMS XML / JSON | cccis.com/developer |
| Mitchell | REST / SOAP | API Key | XML / JSON | mitchell.com/api |
| Xactimate | REST | OAuth2 | ESX / XML / JSON | verisk.com/developer |
| Copart | REST / SFTP | API Key / SSH Key | JSON / CSV | copart.com/partners |
| IAA | REST / SFTP | API Key | JSON / CSV | iaai.com/api |
| ISO ClaimSearch | SOAP / REST | mTLS | ACORD XML / JSON | verisk.com |
| LexisNexis | REST | OAuth2 | JSON | developer.lexisnexis.com |
| OnBase | REST / SOAP | OAuth2 | JSON / SOAP | hyland.com/developer |

---

*This article is part of the PnC Claims Encyclopedia. For related topics, see Article 1 (Claims Lifecycle), Article 6 (Payments), and Article 10 (Data Architecture).*
